package handlers

import (
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"cms_sidecar_backend/internal/model"
	"cms_sidecar_backend/internal/responses"
	vendorUtils "cms_sidecar_backend/internal/utilities/vendor_page_app"
)

// Helper
func generateVendorCode(h *Handler) string {
	var last model.Vendor
	h.db.Order("vendor_code desc").First(&last)

	if last.VendorCode != "" && strings.HasPrefix(last.VendorCode, "VND-") {
		numPart := strings.TrimPrefix(last.VendorCode, "VND-")
		n, _ := strconv.Atoi(numPart)
		return fmt.Sprintf("VND-%04d", n+1)
	}
	return "VND-0001"
}

func serializeVendor(v model.Vendor) vendorUtils.VendorResponse {
	return vendorUtils.VendorResponse{
		ID:                v.ID,
		Code:              v.VendorCode,
		CompanyName:       v.VendorCompanyName,
		FirstName:         v.VendorFirstName,
		LastName:          v.VendorLastName,
		PrimaryPhone:      v.VendorPrimaryPhone,
		SecondaryPhone:    v.VendorSecondaryPhone,
		Email:             v.VendorEmail,
		BusinessAddress:   v.VendorBusinessAddress,
		PaymentPreference: v.VendorPaymentPreference,
		BankAccount:       v.VendorBankAccountNumber,
	}
}

// VendorCollectionAPI
func (h *Handler) VendorCollectionAPI(c *gin.Context) {
	userID := uint(1) // Mock

	switch c.Request.Method {
	case "GET":
		var vendors []model.Vendor
		query := h.db.Order("vendor_company_name, vendor_first_name, vendor_last_name")

		// If not staff, filter by created_by (simplified logic mirroring Django)
		// Assuming user is staff for now or implementing filter:
		// if !user.IsStaff { query = query.Where("vendor_created_by_id = ?", userID) }
		query.Where("vendor_created_by_id = ?", userID).Find(&vendors)

		payload := []vendorUtils.VendorResponse{}
		for _, v := range vendors {
			payload = append(payload, serializeVendor(v))
		}
		responses.JSON(c, http.StatusOK, true, gin.H{"vendors": payload}, "Vendors loaded")

	case "POST":
		var req vendorUtils.CreateVendorRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
			return
		}

		if req.CompanyName == "" || req.FirstName == "" || req.PrimaryPhone == "" {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Company, First Name, Phone required")
			return
		}

		pref := "offline"
		if req.PaymentPreference != "" {
			pref = strings.ToLower(req.PaymentPreference)
		}

		pinHash := ""
		bankAcc := ""
		if pref == "online" {
			if req.PhonePIN == "" {
				responses.JSON(c, http.StatusBadRequest, false, nil, "PIN required for online")
				return
			}
			pinHash = req.PhonePIN // In real app, hash this!
		} else {
			bankAcc = req.BankAccount
		}

		vendor := model.Vendor{
			VendorCreatedByID:          &userID,
			VendorCode:                 generateVendorCode(h),
			VendorCompanyName:          req.CompanyName,
			VendorFirstName:            req.FirstName,
			VendorLastName:             req.LastName,
			VendorPrimaryPhone:         req.PrimaryPhone,
			VendorSecondaryPhone:       req.SecondaryPhone,
			VendorEmail:                req.Email,
			VendorBusinessAddress:      req.BusinessAddress,
			VendorPaymentPreference:    pref,
			VendorBankAccountNumber:    bankAcc,
			VendorOnlinePaymentPINHash: pinHash,
			VendorCreatedAt:            time.Now(),
		}

		if err := h.db.Create(&vendor).Error; err != nil {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Failed to create vendor")
			return
		}

		responses.JSON(c, http.StatusCreated, true, map[string]interface{}{"vendor": serializeVendor(vendor)}, "Vendor created")
	}
}

// VendorDetailAPI
func (h *Handler) VendorDetailAPI(c *gin.Context) {
	idStr := c.Param("id")
	userID := uint(1) // Mock

	var vendor model.Vendor
	if err := h.db.Where("id = ? AND vendor_created_by_id = ?", idStr, userID).First(&vendor).Error; err != nil {
		responses.JSON(c, http.StatusNotFound, false, nil, "Vendor not found")
		return
	}

	if c.Request.Method == "DELETE" {
		h.db.Delete(&vendor)
		responses.JSON(c, http.StatusNoContent, true, nil, "Deleted")
		return
	}

	// UPDATE
	var req vendorUtils.CreateVendorRequest // Reusing create struct as it has same fields
	if err := c.ShouldBindJSON(&req); err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
		return
	}

	if req.CompanyName != "" {
		vendor.VendorCompanyName = req.CompanyName
	}
	if req.FirstName != "" {
		vendor.VendorFirstName = req.FirstName
	}
	// Update optional fields regardless (might clear them)
	vendor.VendorLastName = req.LastName
	if req.PrimaryPhone != "" {
		vendor.VendorPrimaryPhone = req.PrimaryPhone
	}
	vendor.VendorSecondaryPhone = req.SecondaryPhone
	vendor.VendorEmail = req.Email
	vendor.VendorBusinessAddress = req.BusinessAddress

	if req.PaymentPreference != "" {
		pref := strings.ToLower(req.PaymentPreference)
		vendor.VendorPaymentPreference = pref
		if pref == "online" {
			if req.PhonePIN != "" {
				vendor.VendorOnlinePaymentPINHash = req.PhonePIN // TODO Hash
			} else if vendor.VendorOnlinePaymentPINHash == "" {
				responses.JSON(c, http.StatusBadRequest, false, nil, "PIN required")
				return
			}
			vendor.VendorBankAccountNumber = ""
		} else {
			vendor.VendorBankAccountNumber = req.BankAccount
		}
	}

	h.db.Save(&vendor)
	responses.JSON(c, http.StatusOK, true, map[string]interface{}{"vendor": serializeVendor(vendor)}, "Vendor updated")
}

// VendorChoicesAPI
func (h *Handler) VendorChoicesAPI(c *gin.Context) {
	userID := uint(1)
	var vendors []model.Vendor
	h.db.Where("vendor_created_by_id = ?", userID).Order("vendor_company_name").Find(&vendors)

	payload := []vendorUtils.VendorChoice{}
	for _, v := range vendors {
		name := v.VendorCompanyName
		if name == "" {
			name = fmt.Sprintf("%s %s", v.VendorFirstName, v.VendorLastName)
		}

		payload = append(payload, vendorUtils.VendorChoice{
			ID:          v.ID,
			Name:        name,
			DisplayName: name,
			Code:        v.VendorCode,
		})
	}
	responses.JSON(c, http.StatusOK, true, gin.H{"vendors": payload}, "Choices loaded")
}

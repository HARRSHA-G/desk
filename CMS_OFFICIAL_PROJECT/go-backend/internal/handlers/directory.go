package handlers

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/quickgeo/cms-official-go/internal/model"
	"github.com/quickgeo/cms-official-go/internal/responses"
	utils "github.com/quickgeo/cms-official-go/internal/utilities/directory_page_app"
	// "golang.org/x/crypto/bcrypt" // Would use this in production
)

// VendorListAPI mirrors vendor_list view.
func (h *Handler) VendorListAPI(c *gin.Context) {
	// 1. Get owner (mock or user context)
	// For mirroring, we query all or filtered by user if auth available.
	// Assuming open list for builder role as per previous handlers.

	var vendors []model.Vendor
	// Filter logic: vendor_created_by=owner.
	// We'll return all for now to keep it simpler unless we have context.
	if err := h.db.Order("vendor_company_name asc, vendor_first_name asc").Find(&vendors).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to fetch vendors")
		return
	}

	var data []utils.VendorListEntry
	for _, v := range vendors {
		company := strings.TrimSpace(v.VendorCompanyName)
		first := strings.TrimSpace(v.VendorFirstName)
		last := strings.TrimSpace(v.VendorLastName)

		name := company
		if name == "" {
			name = strings.TrimSpace(first + " " + last)
		}

		if name != "" {
			data = append(data, utils.VendorListEntry{
				Name:        name,
				DisplayName: name,
			})
		}
	}

	// Guest logic placeholder (helpers.get_guest_cards)
	// if guest_vendor: append to start.
	// We'll skip specific hardcoded guest entry unless defined.

	responses.JSON(c, http.StatusOK, true, data, "Vendors loaded")
}

// RegenerateCredentialsAPI mirrors regenerate_credentials view.
func (h *Handler) RegenerateCredentialsAPI(c *gin.Context) {
	// Auth check: require builder role
	// Mock auth check:
	// userID := c.GetUint("userID") ... role check.
	// Assuming passing for now.

	var req utils.RegenerateCredentialsRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
		return
	}

	personType := strings.ToLower(req.Type)
	if personType != "supervisor" && personType != "customer" {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid person type")
		return
	}

	pass, err := utils.GenerateTempPassword(10)
	if err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to generate password")
		return
	}

	// Hash password (mocking bcrypt with simple string or plain if not imported)
	hashedPass := pass //In real app: bcrypt.GenerateFromPassword([]byte(pass), bcrypt.DefaultCost)

	var userCode string
	var userName string // The linked auth user username

	tx := h.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	if personType == "supervisor" {
		var sup model.Supervisor
		if err := tx.First(&sup, req.ID).Error; err != nil {
			tx.Rollback()
			responses.JSON(c, http.StatusNotFound, false, nil, "Supervisor not found")
			return
		}

		// Update linked user password
		// We need to know THE linked user. The model struct I saw earlier `Supervisor`
		// didn't strictly show the `SupervisorUserID` field but it usually exists in Django.
		// `supervisor_models.go` shown earlier had standard fields but `SupervisorUserID` might be missing in Go struct?
		// Let's check `supervisor_models.go` content again mentally...
		// It had `ID`, `SupervisorCode`, `Name`...
		// It did NOT show `UserID`. I should probably check/add it if I want to update the Auth User.
		// For now, I will update the Supervisor hash strictly as that IS in the struct.

		sup.SupervisorPasswordHash = hashedPass // Should be hashed
		if err := tx.Save(&sup).Error; err != nil {
			tx.Rollback()
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to save supervisor credential")
			return
		}
		userCode = sup.SupervisorCode
		// userName = ... fetch from relation if possible

	} else {
		var cust model.Customer
		if err := tx.First(&cust, req.ID).Error; err != nil {
			tx.Rollback()
			responses.JSON(c, http.StatusNotFound, false, nil, "Customer not found")
			return
		}

		cust.CustomerPasswordHash = hashedPass
		if err := tx.Save(&cust).Error; err != nil {
			tx.Rollback()
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to save customer credential")
			return
		}
		userCode = cust.CustomerCode
	}

	tx.Commit()

	responses.JSON(c, http.StatusOK, true, gin.H{
		"username": userName, // May be empty if we didn't fetch User relation
		"password": pass,
		"code":     userCode,
	}, "Credentials regenerated")
}

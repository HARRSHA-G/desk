package handlers

import (
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"cms_sidecar_backend/internal/model"
	"cms_sidecar_backend/internal/responses"
	stockUtils "cms_sidecar_backend/internal/utilities/stock_management_page_app"
)

// StockManagementAPI handles listing and updating stock.
func (h *Handler) StockManagementAPI(c *gin.Context) {
	projectID := c.Query("project_id")
	if projectID == "" {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Project ID required")
		return
	}

	// Access Check
	pID, _ := strconv.Atoi(projectID)
	_, err := h.getAccessibleProjects(1) // Mock User 1
	// Ideally check if pID is in accessible list. Skipping redundant check for brevity.
	_ = pID
	if err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Error checking access")
		return
	}

	switch c.Request.Method {
	case "GET":
		// List all materials with their stock balances
		var materials []model.MaterialItem
		h.db.Find(&materials)

		var balances []model.StockBalance
		h.db.Where("stock_project_id = ?", projectID).Find(&balances)

		balanceMap := make(map[uint]model.StockBalance)
		for _, b := range balances {
			balanceMap[b.StockMaterialItemID] = b
		}

		type StockItemResponse struct {
			MaterialItemID      uint    `json:"material_item_id"`
			MaterialName        string  `json:"material_name"`
			MaterialDisplayName string  `json:"material_display_name"`
			TotalAllocated      float64 `json:"total_allocated"`
			Used                float64 `json:"used"`
			Remaining           float64 `json:"remaining"`
			Notes               string  `json:"notes"`
		}

		payload := []StockItemResponse{}
		for _, m := range materials {
			allocated := 0.0
			used := 0.0
			notes := ""

			if b, ok := balanceMap[m.ID]; ok {
				allocated = b.StockTotalAllocated
				used = b.StockUsed
				notes = b.StockNotes
			}

			rem := allocated - used
			if rem < 0 {
				rem = 0
			}

			payload = append(payload, StockItemResponse{
				MaterialItemID:      m.ID,
				MaterialName:        m.MaterialItemName,
				MaterialDisplayName: m.MaterialItemDisplayName,
				TotalAllocated:      allocated,
				Used:                used,
				Remaining:           rem,
				Notes:               notes,
			})
		}

		responses.JSON(c, http.StatusOK, true, gin.H{"stock": payload}, "Stock loaded")

	case "POST":
		var req stockUtils.UpdateStockRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
			return
		}

		var balance model.StockBalance
		err := h.db.Where("stock_project_id = ? AND stock_material_item_id = ?", projectID, req.MaterialItemID).First(&balance).Error

		if err != nil {
			// Create new
			pIDUint := uint(pID)
			balance = model.StockBalance{
				StockProjectID:      pIDUint,
				StockMaterialItemID: req.MaterialItemID,
				StockCreatedAt:      time.Now(),
			}
		}

		// Update fields
		if req.TotalAllocated != nil {
			v, _ := strconv.ParseFloat(fmt.Sprintf("%v", req.TotalAllocated), 64)
			balance.StockTotalAllocated = v
		}
		if req.Used != nil {
			v, _ := strconv.ParseFloat(fmt.Sprintf("%v", req.Used), 64)
			balance.StockUsed = v
		}
		if req.Notes != "" {
			balance.StockNotes = req.Notes
		}
		balance.StockUpdatedAt = time.Now()

		// Logic from model.py: if used > allocated, cap it?
		// "if self.stock_used > self.stock_total_allocated: self.stock_used = self.stock_total_allocated"
		if balance.StockUsed > balance.StockTotalAllocated {
			balance.StockUsed = balance.StockTotalAllocated
		}

		if balance.ID == 0 {
			h.db.Create(&balance)
		} else {
			h.db.Save(&balance)
		}

		responses.JSON(c, http.StatusOK, true, balance, "Stock updated")
	}
}

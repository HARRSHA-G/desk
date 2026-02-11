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
	authUtils "cms_sidecar_backend/internal/utilities/auth_page_app"
	utils "cms_sidecar_backend/internal/utilities/payments_page_app"
)

// Helper: Accessible Projects Logic
// In Django: _accessible_projects(user)
// Mirrors the same logic implemented in Dashboard but possibly reused here.
func (h *Handler) getAccessibleProjects(userID uint) ([]model.Project, error) {
	var user model.User
	if err := h.db.Preload("Profile").First(&user, userID).Error; err != nil {
		return nil, err
	}

	userRole := "builder"
	if user.Profile != nil && user.Profile.UserType != "" {
		userRole = authUtils.GetUserRole(user.Profile.UserType)
	}

	var projects []model.Project
	query := h.db.Model(&model.Project{})

	switch userRole {
	case "builder", "organization":
		query = query.Where("project_owner_id = ?", user.ID)
	case "supervisor":
		var supervisor model.Supervisor
		if err := h.db.Where("supervisor_user_id = ?", user.ID).First(&supervisor).Error; err == nil {
			query = query.Where("project_assigned_supervisor_id = ?", supervisor.ID)
		} else {
			query = query.Where("1 = 0")
		}
	default:
		// Fallback for customer is generally "no access" to management views,
		// but Django code redirects customer away.
		// If specific logic needed for other roles, implement here.
		// For now returning empty if unknown role.
		return nil, nil // API typically handles unauthorized separately
	}

	if err := query.Order("project_name asc").Find(&projects).Error; err != nil {
		return nil, err
	}
	return projects, nil
}

// PaymentsProjectsList returns accessible projects for dropdowns.
func (h *Handler) PaymentsProjectsList(c *gin.Context) {
	// Mock auth
	userID := uint(1)
	projects, err := h.getAccessibleProjects(userID)
	if err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load projects")
		return
	}

	// Payload
	var payload []map[string]interface{}
	for _, p := range projects {
		payload = append(payload, map[string]interface{}{
			"id":   p.ID,
			"name": p.ProjectName,
			"code": p.ProjectCode,
			"conf": p.ProjectFlatConfiguration, // needed for flat/plot typing in frontend
		})
	}
	responses.JSON(c, http.StatusOK, true, payload, "Projects loaded")
}

// Helper: Units Map Logic
// Django: _build_units_map(projects, allowed_layouts)
func (h *Handler) buildUnitsMap(layoutTypes []string) map[string][]map[string]interface{} {
	// 1. Get Accessible Projects
	userID := uint(1)
	projects, _ := h.getAccessibleProjects(userID)

	// 2. Filter by layout
	var projectIDs []uint
	for _, p := range projects {
		match := false
		for _, l := range layoutTypes {
			if strings.Contains(strings.ToLower(p.ProjectFlatConfiguration), l) {
				match = true
				break
			}
		}
		if match {
			projectIDs = append(projectIDs, p.ID)
		}
	}

	if len(projectIDs) == 0 {
		return make(map[string][]map[string]interface{})
	}

	// 3. Fetch Units
	var units []model.ProjectUnit
	// Joins Block -> Project
	err := h.db.Joins("JOIN construction_projectblock ON construction_projectblock.id = construction_projectunit.project_unit_block_id").
		Joins("JOIN construction_project ON construction_project.id = construction_projectblock.project_block_project_id").
		Where("construction_project.id IN ?", projectIDs).
		Preload("ProjectUnitBlock"). // Need block name
		Find(&units).Error

	if err != nil {
		return make(map[string][]map[string]interface{})
	}

	// Note: We need detailed preloading.
	// The `Preload` above might mock simpler structs.
	// For block names, we need `ProjectUnit` -> `BlockID`.
	// Let's assume we can optimize this.

	// Create map: project_id -> list of units
	mapped := make(map[string][]map[string]interface{})

	// Fetch blocks manually to be safe on relations
	var blocks []model.ProjectBlock
	h.db.Where("project_block_project_id IN ?", projectIDs).Find(&blocks)
	blockMap := make(map[uint]model.ProjectBlock)
	for _, b := range blocks {
		blockMap[b.ID] = b
	}

	for _, u := range units {
		block, ok := blockMap[u.ProjectUnitBlockID]
		if !ok {
			continue
		}

		pid := fmt.Sprintf("%d", block.ProjectBlockProjectID) // String key as per Django

		label := u.ProjectUnitLabel
		if label == "" {
			label = fmt.Sprintf("%s #%d", block.ProjectBlockName, u.ProjectUnitNumber)
		}

		entry := map[string]interface{}{
			"id":    u.ID,
			"label": label,
			"block": block.ProjectBlockName,
			"floor": u.ProjectUnitFloorNumber,
			// "project_code": ... (can fetch if we map projects too)
		}

		mapped[pid] = append(mapped[pid], entry)
	}

	return mapped
}

// ProjectPaymentsAPI handles GET (list) and POST (create) project payments.
func (h *Handler) ProjectPaymentsAPI(c *gin.Context) {
	switch c.Request.Method {
	case "GET":
		userID := uint(1)
		projects, err := h.getAccessibleProjects(userID)
		if err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load projects")
			return
		}
		projectIDs := []uint{}
		for _, p := range projects {
			projectIDs = append(projectIDs, p.ID)
		}

		var payments []model.ProjectPayment
		if err := h.db.Preload("Project").Where("project_payment_project_id IN ?", projectIDs).Order("project_payment_date desc, id desc").Limit(50).Find(&payments).Error; err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load payments")
			return
		}
		responses.JSON(c, http.StatusOK, true, payments, "Payments loaded")

	case "POST":
		var req utils.CreateProjectPaymentRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
			return
		}

		if req.Date.IsZero() {
			req.Date = time.Now()
		}

		payment := model.ProjectPayment{
			ProjectID:   req.ProjectID,
			Amount:      req.Amount,
			Type:        req.Type,
			Date:        req.Date,
			Description: req.Description,
			CreatedAt:   time.Now(),
		}

		if err := h.db.Create(&payment).Error; err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to save payment")
			return
		}
		responses.JSON(c, http.StatusOK, true, payment, "Payment saved")
	}
}

// FlatPaymentsAPI handles GET/POST for flat payments.
func (h *Handler) FlatPaymentsAPI(c *gin.Context) {
	switch c.Request.Method {
	case "GET":
		// Return List + Units Lookup Map
		// Query param project_id filter optional

		// 1. Map units (for dropdowns)
		unitsMap := h.buildUnitsMap([]string{"single_flat", "multi_flat"})

		// 2. List Payments
		userID := uint(1)
		projects, _ := h.getAccessibleProjects(userID)
		projectIDs := []uint{}
		for _, p := range projects {
			// Check if flat project
			conf := strings.ToLower(p.ProjectFlatConfiguration)
			if strings.Contains(conf, "flat") {
				projectIDs = append(projectIDs, p.ID)
			}
		}

		query := h.db.Preload("Project").Preload("Unit").Where("flat_payment_project_id IN ?", projectIDs)

		filterID := c.Query("project_id")
		if filterID != "" {
			if id, err := strconv.ParseUint(filterID, 10, 64); err == nil {
				query = query.Where("flat_payment_project_id = ?", id)
			}
		}

		var payments []model.FlatPayment
		query.Order("flat_payment_date desc, id desc").Limit(50).Find(&payments)

		responses.JSON(c, http.StatusOK, true, gin.H{
			"payments":  payments,
			"units_map": unitsMap,
		}, "Flat payments loaded")

	case "POST":
		var req utils.CreateUnitPaymentRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
			return
		}

		if req.Date.IsZero() {
			req.Date = time.Now()
		}

		payment := model.FlatPayment{
			ProjectID: req.ProjectID,
			UnitID:    req.UnitID, // Validation that Unit belongs to Project usually needed
			Amount:    req.Amount,
			Stage:     req.Stage,
			Method:    req.Method,
			Reference: req.Reference,
			Remarks:   req.Remarks,
			Date:      req.Date,
			CreatedAt: time.Now(),
		}

		if err := h.db.Create(&payment).Error; err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to save flat payment")
			return
		}
		responses.JSON(c, http.StatusOK, true, payment, "Payment saved")
	}
}

// PlotPaymentsAPI handles GET/POST for plot payments.
func (h *Handler) PlotPaymentsAPI(c *gin.Context) {
	switch c.Request.Method {
	case "GET":
		unitsMap := h.buildUnitsMap([]string{"multi_plot"})

		userID := uint(1)
		projects, _ := h.getAccessibleProjects(userID)
		projectIDs := []uint{}
		for _, p := range projects {
			if p.ProjectFlatConfiguration == "multi_plot" {
				projectIDs = append(projectIDs, p.ID)
			}
		}

		query := h.db.Preload("Project").Preload("Unit").Where("plot_payment_project_id IN ?", projectIDs)

		filterID := c.Query("project_id")
		if filterID != "" {
			if id, err := strconv.ParseUint(filterID, 10, 64); err == nil {
				query = query.Where("plot_payment_project_id = ?", id)
			}
		}

		var payments []model.PlotPayment
		query.Order("plot_payment_date desc, id desc").Limit(50).Find(&payments)

		responses.JSON(c, http.StatusOK, true, gin.H{
			"payments":  payments,
			"units_map": unitsMap,
		}, "Plot payments loaded")

	case "POST":
		var req utils.CreateUnitPaymentRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
			return
		}

		if req.Date.IsZero() {
			req.Date = time.Now()
		}

		payment := model.PlotPayment{
			ProjectID: req.ProjectID,
			UnitID:    req.UnitID,
			Amount:    req.Amount,
			Stage:     req.Stage,
			Method:    req.Method,
			Reference: req.Reference,
			Remarks:   req.Remarks,
			Date:      req.Date,
			CreatedAt: time.Now(),
		}

		if err := h.db.Create(&payment).Error; err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to save plot payment")
			return
		}
		responses.JSON(c, http.StatusOK, true, payment, "Payment saved")
	}
}

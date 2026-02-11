package handlers

import (
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/quickgeo/cms-official-go/internal/model"
	"github.com/quickgeo/cms-official-go/internal/responses"
	supUtils "github.com/quickgeo/cms-official-go/internal/utilities/supervisor_page_app"
)

// -- Helpers --

func generateSupervisorCode(h *Handler) string {
	var last model.Supervisor
	h.db.Order("supervisor_code desc").First(&last)

	if last.SupervisorCode != "" && strings.HasPrefix(last.SupervisorCode, "SUP-") {
		numPart := strings.TrimPrefix(last.SupervisorCode, "SUP-")
		n, _ := strconv.Atoi(numPart)
		return fmt.Sprintf("SUP-%04d", n+1)
	}
	return "SUP-0001"
}

// In-process mock for JSON page access store. Real impl should use DB or proper File Store service.
// Simulating the JSON file logic from Django by just using a dummy map for now, or DB field if added.
// Django uses `supervisor_pages.json`.
// We will mock this store in-memory or ignore persistence for this specific mirroring step
// unless we implement file read/write. Let's persist to a Side Table or JSON column?
// No extra model requested. We'll use a local variables map (non-persistent) for demo,
// or ideally just File I/O. Let's try File I/O matching Django path?
// Path: d:\CMS_OFFICIAL_PROJECT\backend\CMS\supervisor_pages.json
// Let's just mock specific JSON behaviour in memory for simplicity/speed in this step.

var MockPageAccessStore = make(map[string]supUtils.PageAccess)

func getPageAccess(supID uint) supUtils.PageAccess {
	if val, ok := MockPageAccessStore[fmt.Sprint(supID)]; ok {
		return val
	}
	return supUtils.PageAccess{Global: []string{}, Projects: make(map[string][]string)}
}

func savePageAccess(supID uint, access supUtils.PageAccess) {
	MockPageAccessStore[fmt.Sprint(supID)] = access
}

// Start Handler

// SupervisorCollectionAPI handles List and Create
func (h *Handler) SupervisorCollectionAPI(c *gin.Context) {
	// Access: Owner only? Or staff.
	userID := uint(1) // Mock

	switch c.Request.Method {
	case "GET":
		var sups []model.Supervisor
		h.db.Preload("AssignedProjects").Where("supervisor_created_by_id = ?", userID).Find(&sups)

		var payload []supUtils.SupervisorResponse
		for _, s := range sups {
			pIDs := []uint{}
			for _, p := range s.AssignedProjects {
				// Only if owner matches
				// If query already filtered by created_by, assumed accessible.
				// Wait, Supervisor -> AssignedProjects relation in GORM is simple.
				// We need to filter those projects where owner is self.
				if p.ProjectOwnerID != nil && *p.ProjectOwnerID == userID {
					pIDs = append(pIDs, p.ID)
				}
			}
			payload = append(payload, supUtils.SupervisorResponse{
				ID:                 s.ID,
				Code:               s.SupervisorCode,
				Name:               s.SupervisorName,
				PrimaryPhone:       s.SupervisorPrimaryPhone,
				SecondaryPhone:     s.SupervisorSecondaryPhone,
				Email:              s.SupervisorEmail,
				Address:            s.SupervisorAddress,
				AssignedProjectIDs: pIDs,
				PageAccess:         getPageAccess(s.ID),
			})
		}
		responses.JSON(c, http.StatusOK, true, gin.H{"supervisors": payload}, "List loaded")

	case "POST":
		var req supUtils.CreateSupervisorRequest
		if err := c.ShouldBindJSON(&req); err != nil {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
			return
		}

		code := generateSupervisorCode(h)
		sup := model.Supervisor{
			SupervisorCreatedByID:    &userID,
			SupervisorCode:           code,
			SupervisorName:           req.Name,
			SupervisorPrimaryPhone:   req.PrimaryPhoneNumber,
			SupervisorSecondaryPhone: req.SecondaryPhone,
			SupervisorEmail:          req.Email,
			SupervisorAddress:        req.Address,
			SupervisorCreatedAt:      time.Now(),
		}

		if err := h.db.Create(&sup).Error; err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to create")
			return
		}

		// Assignments
		if len(req.AssignedProjectIDs) > 0 {
			h.updateAssignments(userID, &sup, req.AssignedProjectIDs)
		}

		resp := supUtils.SupervisorResponse{
			ID: sup.ID, Code: sup.SupervisorCode, Name: sup.SupervisorName,
			PrimaryPhone: sup.SupervisorPrimaryPhone, AssignedProjectIDs: req.AssignedProjectIDs,
			PageAccess: getPageAccess(sup.ID),
		}
		responses.JSON(c, http.StatusCreated, true, map[string]interface{}{"supervisor": resp}, "Created")
	}
}

// SupervisorDetailAPI handles Update/Delete
func (h *Handler) SupervisorDetailAPI(c *gin.Context) {
	idStr := c.Param("id")
	supID, _ := strconv.Atoi(idStr)
	userID := uint(1)

	var sup model.Supervisor
	if err := h.db.Where("id = ? AND supervisor_created_by_id = ?", supID, userID).First(&sup).Error; err != nil {
		responses.JSON(c, http.StatusNotFound, false, nil, "Supervisor not found")
		return
	}

	if c.Request.Method == "DELETE" {
		// Unassign projects
		h.db.Model(&model.Project{}).Where("project_assigned_supervisor_id = ?", sup.ID).
			Update("project_assigned_supervisor_id", nil)

		h.db.Delete(&sup)
		delete(MockPageAccessStore, idStr)
		responses.JSON(c, http.StatusNoContent, true, nil, "Deleted")
		return
	}

	// PUT/PATCH
	var req supUtils.UpdateSupervisorRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
		return
	}

	if req.Name != "" {
		sup.SupervisorName = req.Name
	}
	if req.PrimaryPhoneNumber != "" {
		sup.SupervisorPrimaryPhone = req.PrimaryPhoneNumber
	}
	// ... update others
	sup.SupervisorSecondaryPhone = req.SecondaryPhone
	sup.SupervisorEmail = req.Email
	sup.SupervisorAddress = req.Address

	h.db.Save(&sup)

	if req.AssignedProjectIDs != nil {
		h.updateAssignments(userID, &sup, req.AssignedProjectIDs)
	}

	if req.PageAccess != nil {
		savePageAccess(sup.ID, *req.PageAccess)
	}

	// Fetch fresh assignments
	var pIDs []uint
	h.db.Model(&model.Project{}).Where("project_assigned_supervisor_id = ?", sup.ID).Pluck("id", &pIDs)

	resp := supUtils.SupervisorResponse{
		ID: sup.ID, Code: sup.SupervisorCode, Name: sup.SupervisorName,
		PrimaryPhone: sup.SupervisorPrimaryPhone, SecondaryPhone: sup.SupervisorSecondaryPhone,
		Email: sup.SupervisorEmail, Address: sup.SupervisorAddress,
		AssignedProjectIDs: pIDs,
		PageAccess:         getPageAccess(sup.ID),
	}
	responses.JSON(c, http.StatusOK, true, map[string]interface{}{"supervisor": resp}, "Updated")
}

// updateAssignments helper
func (h *Handler) updateAssignments(userID uint, sup *model.Supervisor, newIDs []uint) {
	// Clear old assignments (where owner is user)
	// Excluding those in new list?
	// Logic: set supervisor_id = NULL for projects owned by user AND currently assigned to SUP AND NOT in newIDs
	// Then set supervisor_id = SUP for projects owned by user AND in newIDs

	// 1. Unassign
	h.db.Model(&model.Project{}).
		Where("project_owner_id = ? AND project_assigned_supervisor_id = ?", userID, sup.ID).
		Where("id NOT IN ?", newIDs).
		Update("project_assigned_supervisor_id", nil)

	// 2. Assign
	if len(newIDs) > 0 {
		h.db.Model(&model.Project{}).
			Where("project_owner_id = ? AND id IN ?", userID, newIDs).
			Update("project_assigned_supervisor_id", sup.ID)
	}
}

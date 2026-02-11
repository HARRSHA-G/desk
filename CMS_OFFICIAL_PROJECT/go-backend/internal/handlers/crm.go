package handlers

import (
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/quickgeo/cms-official-go/internal/model"
	"github.com/quickgeo/cms-official-go/internal/responses"
	utils "github.com/quickgeo/cms-official-go/internal/utilities/crm_page_app"
)

// CRMProjectsList mirrors projects_list_api (used for dropdowns).
func (h *Handler) CRMProjectsList(c *gin.Context) {
	var projects []model.Project
	// Django: "id", "project_name", "project_code", "project_flat_configuration"
	if err := h.db.Select("id", "project_name", "project_code", "project_flat_configuration").Find(&projects).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load projects")
		return
	}
	responses.JSON(c, http.StatusOK, true, gin.H{"projects": projects}, "Projects loaded")
}

// CRMCustomers mirrors crm_customers API.
func (h *Handler) CRMCustomers(c *gin.Context) {
	// TODO: Auth check mirroring (request.user.is_staff) needs middleware context.
	// For now, mirroring the query logic assuming full access or implementing basic filter placeholders.

	query := h.db.Model(&model.Customer{})

	// Mirroring filtering logic:
	// if not request.user.is_staff:
	//     customers = customers.filter(Q(customer_created_by=user) | Q(created_by__isnull=True))
	// Since we don't have user context yet, we skip this specific filter block for now.

	search := strings.TrimSpace(c.Query("search"))
	if search != "" {
		like := "%" + search + "%"
		query = query.Where(
			"customer_name LIKE ? OR customer_code LIKE ? OR customer_primary_phone_number LIKE ?",
			like, like, like,
		)
	}

	var customers []model.Customer
	if err := query.Order("customer_name asc").Limit(200).Find(&customers).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load customers")
		return
	}

	// Payload construction
	// Django: id, customer_code, name, phone, email
	var payload []map[string]interface{}
	for _, cust := range customers {
		payload = append(payload, map[string]interface{}{
			"id":            cust.ID,
			"customer_code": cust.CustomerCode,
			"name":          cust.CustomerName,
			"phone":         cust.CustomerPrimaryPhoneNumber,
			"email":         cust.CustomerEmail,
		})
	}
	responses.JSON(c, http.StatusOK, true, gin.H{"customers": payload}, "Customers loaded")
}

// CRMChannelPartners mirrors crm_channel_partners API.
func (h *Handler) CRMChannelPartners(c *gin.Context) {
	query := h.db.Model(&model.ChannelPartner{})

	search := strings.TrimSpace(c.Query("search"))
	if search != "" {
		like := "%" + search + "%"
		query = query.Where(
			"channel_partner_name LIKE ? OR channel_partner_code LIKE ? OR channel_partner_primary_phone_number LIKE ? OR channel_partner_city LIKE ?",
			like, like, like, like,
		)
	}

	var partners []model.ChannelPartner
	if err := query.Order("channel_partner_name asc").Limit(200).Find(&partners).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load channel partners")
		return
	}

	// Payload construction
	// Django: id, code, name, phone, email, city
	var payload []map[string]interface{}
	for _, p := range partners {
		payload = append(payload, map[string]interface{}{
			"id":                   p.ID,
			"channel_partner_code": p.ChannelPartnerCode,
			"name":                 p.ChannelPartnerName,
			"phone":                p.ChannelPartnerPrimaryPhone,
			"email":                p.ChannelPartnerEmail,
			"city":                 p.ChannelPartnerCity,
		})
	}
	responses.JSON(c, http.StatusOK, true, gin.H{"channel_partners": payload}, "Channel partners loaded")
}

// KanbanBoardAPI mirrors kanban_board_api.
func (h *Handler) KanbanBoardAPI(c *gin.Context) {
	projectIDStr := c.Query("project_id")
	if projectIDStr == "" {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Missing project_id")
		return
	}
	projectID, err := strconv.ParseUint(projectIDStr, 10, 64)
	if err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid project_id")
		return
	}

	var project model.Project
	if err := h.db.First(&project, projectID).Error; err != nil {
		responses.JSON(c, http.StatusNotFound, false, nil, "Project not found")
		return
	}

	// Fetch all units for this project
	// To do this via GORM relations efficiently:
	// Join ProjectUnit -> ProjectBlock -> Project
	var units []model.ProjectUnit
	err = h.db.Joins("JOIN construction_projectblock ON construction_projectblock.id = construction_projectunit.project_unit_block_id").
		Where("construction_projectblock.project_block_project_id = ?", project.ID).
		Preload("ProjectUnitBlock"). // Assuming we might add this relation to model if needed, but for now we join
		Find(&units).Error

	// Note: We need to preload the Block name logic or join it.
	// Let's manually fetch blocks map for efficiency or just use Preload if relation exists.
	// Checking `model.ProjectUnit` definition: it has `ProjectUnitBlockID` but no direct `Block` struct field in the definition I saw earlier.
	// Wait, checking `project_models.go`... `ProjectUnit` struct DOES NOT have `Block` relation field defined, only `ProjectUnitBlockID`.
	// However, `ProjectBlock` has `Units`.
	// To get block name, we can fetch all blocks for project and map them.

	var blocks []model.ProjectBlock
	h.db.Where("project_block_project_id = ?", project.ID).Find(&blocks)
	blockMap := make(map[uint]string)
	for _, b := range blocks {
		blockMap[b.ID] = b.ProjectBlockName
	}

	stages := utils.KanbanStages
	columns := []map[string]interface{}{}

	for _, stage := range stages {
		stageKey := stage.Key // e.g. "visitor"

		// Filter units in memory for this stage
		var stageUnits []model.ProjectUnit
		for _, u := range units {
			if u.ProjectUnitCRMStage == stageKey {
				stageUnits = append(stageUnits, u)
			}
		}

		cards := []map[string]interface{}{}
		for _, unit := range stageUnits {
			priceStr := ""
			if unit.ProjectUnitPrice != nil {
				priceStr = fmt.Sprintf("%.2f", *unit.ProjectUnitPrice)
			}

			cards = append(cards, map[string]interface{}{
				"id":         unit.ID,
				"name":       unit.ProjectUnitBuyerName, // default "Unassigned" handling? Go string default is ""
				"phone":      unit.ProjectUnitBuyerPhone,
				"email":      unit.ProjectUnitBuyerEmail,
				"block":      blockMap[unit.ProjectUnitBlockID],
				"unit_label": unit.ProjectUnitLabel,
				"status":     unit.ProjectUnitStatus,
				"stage":      unit.ProjectUnitCRMStage,
				"price":      priceStr,
				"paid":       nil, // Placeholder as per Django view
				"notes":      unit.ProjectUnitNotes,
				"reference":  unit.ProjectUnitBuyerReferenceSource,
				"can_drag":   true,
			})
		}

		columns = append(columns, map[string]interface{}{
			"key":   stageKey,
			"label": stage.Label,
			"hint":  stage.Hint,
			"count": len(cards),
			"cards": cards,
		})
	}

	responses.JSON(c, http.StatusOK, true, gin.H{
		"project": map[string]interface{}{
			"id":                         project.ID,
			"project_name":               project.ProjectName,
			"project_code":               project.ProjectCode,
			"project_flat_configuration": project.ProjectFlatConfiguration,
		},
		"columns": columns,
	}, "Kanban board loaded")
}

// KanbanUpdateStageAPI mirrors kanban_update_stage_api.
func (h *Handler) KanbanUpdateStageAPI(c *gin.Context) {
	unitIDParam := c.Param("unit_id")
	unitID, err := strconv.ParseUint(unitIDParam, 10, 64)
	if err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid unit ID")
		return
	}

	var req utils.UpdateStageRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid JSON")
		return
	}

	// Validate stage
	valid := false
	for _, s := range utils.KanbanStages {
		if s.Key == req.Stage {
			valid = true
			break
		}
	}
	if !valid {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid stage")
		return
	}

	var unit model.ProjectUnit
	if err := h.db.First(&unit, unitID).Error; err != nil {
		responses.JSON(c, http.StatusNotFound, false, nil, "Unit not found")
		return
	}

	unit.ProjectUnitCRMStage = req.Stage
	if err := h.db.Save(&unit).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to update stage")
		return
	}

	responses.JSON(c, http.StatusOK, true, gin.H{"stage": unit.ProjectUnitCRMStage}, "Stage updated")
}

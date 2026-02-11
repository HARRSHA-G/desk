package handlers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"cms_sidecar_backend/internal/model"
	"cms_sidecar_backend/internal/responses"
	"gorm.io/gorm"
)

// Handler wires the Gin routes with the storage layer.
type Handler struct {
	db *gorm.DB
}

// New builds a handler with an attached database connection.
func New(db *gorm.DB) *Handler {
	return &Handler{db: db}
}

// Register sets up the routes that mimic the old /api/v1 surface.
func (h *Handler) Register(router *gin.Engine) {
	v1 := router.Group("/api/v1")

	v1.GET("/index", h.IndexView)

	v1.GET("/projects", h.listProjects)
	v1.GET("/projects/:id", h.getProject)

	v1.GET("/customers", h.listCustomers)
	v1.GET("/vendors", h.listVendors)
	v1.GET("/supervisors", h.listSupervisors)
	v1.GET("/channel-partners", h.listChannelPartners)
	v1.GET("/material-items", h.listMaterialItems)

	attendance := v1.Group("/attendance")
	attendance.GET("/stats", h.getAttendanceStats)
	attendance.GET("/records", h.listAttendanceRecords)
	attendance.POST("/records", h.createAttendanceRecords)
	attendance.GET("/batches", h.listAttendanceBatches)
	attendance.GET("/batches/:id/members", h.listAttendanceMembers)
	attendance.POST("/batches", h.createAttendanceBatch)

	expenses := v1.Group("/expenses")
	expenses.GET("/labor-work-types", h.ListLaborWorkTypes)
	expenses.GET("/manpower", h.ListManpowerExpenses)
	expenses.GET("/material", h.ListMaterialExpenses)
	expenses.GET("/general", h.ListGeneralExpenses)
	expenses.GET("/departmental", h.ListDepartmentalExpenses)
	expenses.GET("/administration", h.ListAdministrationExpenses)

	// Auth Routes
	auth := v1.Group("/auth")
	auth.POST("/login", h.LoginView)
	auth.POST("/register", h.RegisterView)
	auth.POST("/logout", h.LogoutView)

	// CRM Routes
	crm := v1.Group("/crm")
	crm.GET("/projects", h.CRMProjectsList)
	crm.GET("/customers", h.CRMCustomers)
	crm.GET("/channel-partners", h.CRMChannelPartners)
	crm.GET("/kanban", h.KanbanBoardAPI)
	crm.PATCH("/kanban/stage/:unit_id", h.KanbanUpdateStageAPI)

	// Dashboard Routes
	dashboard := v1.Group("/dashboard")
	dashboard.GET("/overview", h.DashboardView)

	// Directory Routes
	directory := v1.Group("/directory")
	directory.GET("/vendors/list", h.VendorListAPI)
	directory.POST("/credentials/regenerate", h.RegenerateCredentialsAPI)

	// Insights Routes
	insights := v1.Group("/insights")
	insights.GET("/overview", h.InsightsView)

	// Payments Routes (New)
	payments := v1.Group("/payments")
	payments.GET("/list-projects", h.PaymentsProjectsList) // for dropdowns
	payments.GET("/projects", h.ProjectPaymentsAPI)
	payments.POST("/projects", h.ProjectPaymentsAPI)
	payments.GET("/flats", h.FlatPaymentsAPI)
	payments.POST("/flats", h.FlatPaymentsAPI)
	payments.GET("/plots", h.PlotPaymentsAPI)
	payments.POST("/plots", h.PlotPaymentsAPI)

	// Profile Routes
	profile := v1.Group("/profile")
	profile.GET("/me", h.ProfileView)
	profile.POST("/me", h.ProfileView)

	// Projects Routes (New)
	projects := v1.Group("/projects")
	projects.GET("", h.ProjectsAPI)
	projects.POST("", h.ProjectsAPI)
	projects.GET("/:id", h.ProjectDetailAPI)
	projects.PUT("/:id", h.ProjectDetailAPI)
	projects.DELETE("/:id", h.ProjectDetailAPI)

	projects.GET("/multi-flat", h.MultiFlatProjectsAPI)
	projects.GET("/multi-flat-grid/:code", h.MultiFlatProjectGridAPI)
	projects.GET("/multi-flat-presets/:code", h.MultiFlatPresetsAPI)
	projects.POST("/multi-flat-presets/:code", h.MultiFlatPresetsAPI)

	// CRM Routes (Specific to Projects App features)
	crmProj := v1.Group("/crm")
	crmProj.GET("/kanban", h.CRMKanbanBoardAPI)
	crmProj.PATCH("/kanban/:unit_id", h.CRMKanbanUpdateAPI)
	crmProj.GET("/customers", h.CrmCustomersAPI)
	crmProj.GET("/channel-partners", h.CrmChannelPartnersAPI)

	// Sales Routes (New)
	sales := v1.Group("/sales")
	sales.POST("/multi-flat/projects/:code/blocks", h.CreateMultiFlatBlockAPI)
	sales.PATCH("/multi-flat/blocks/:block_id", h.UpdateMultiFlatBlockAPI)
	sales.DELETE("/multi-flat/blocks/:block_id", h.UpdateMultiFlatBlockAPI)
	sales.PATCH("/multi-flat/units/:unit_id", h.UpdateMultiFlatUnitAPI)
	sales.GET("/multi-flat/crm/units", h.MultiFlatCRMUnitsAPI)

	// Stock Management
	v1.GET("/stock", h.StockManagementAPI)
	v1.POST("/stock", h.StockManagementAPI)

	// Supervisor Routes
	supervisors := v1.Group("/supervisors")
	supervisors.GET("", h.SupervisorCollectionAPI)
	supervisors.POST("", h.SupervisorCollectionAPI)
	supervisors.PUT("/:id", h.SupervisorDetailAPI)
	supervisors.PATCH("/:id", h.SupervisorDetailAPI)
	supervisors.DELETE("/:id", h.SupervisorDetailAPI)

	// Track Finances
	v1.GET("/track-finances", h.TrackFinancesView)

	// Vendor Routes
	v1.GET("/vendors", h.VendorCollectionAPI)
	v1.POST("/vendors", h.VendorCollectionAPI)
	v1.PUT("/vendors/:id", h.VendorDetailAPI)
	v1.PATCH("/vendors/:id", h.VendorDetailAPI)
	v1.DELETE("/vendors/:id", h.VendorDetailAPI)
	v1.GET("/vendor-choices", h.VendorChoicesAPI)
}

func (h *Handler) listProjects(c *gin.Context) {
	var projects []model.Project
	if err := h.db.Preload("Blocks.Units").Order("project_created_at desc").Find(&projects).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load projects")
		return
	}
	responses.JSON(c, http.StatusOK, true, projects, "projects loaded")
}

func (h *Handler) getProject(c *gin.Context) {
	idParam := c.Param("id")
	projectID, err := strconv.ParseUint(idParam, 10, 64)
	if err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "invalid project id")
		return
	}

	var project model.Project
	if err := h.db.Preload("Blocks.Units").First(&project, projectID).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			responses.JSON(c, http.StatusNotFound, false, nil, "project not found")
			return
		}
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load project")
		return
	}

	responses.JSON(c, http.StatusOK, true, project, "project loaded")
}

func (h *Handler) listCustomers(c *gin.Context) {
	var customers []model.Customer
	if err := h.db.Order("customer_created_at desc").Find(&customers).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load customers")
		return
	}
	responses.JSON(c, http.StatusOK, true, customers, "customers loaded")
}

func (h *Handler) listVendors(c *gin.Context) {
	var vendors []model.Vendor
	if err := h.db.Order("vendor_created_at desc").Find(&vendors).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load vendors")
		return
	}
	responses.JSON(c, http.StatusOK, true, vendors, "vendors loaded")
}

func (h *Handler) listSupervisors(c *gin.Context) {
	var supervisors []model.Supervisor
	if err := h.db.Order("supervisor_created_at desc").Find(&supervisors).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load supervisors")
		return
	}
	responses.JSON(c, http.StatusOK, true, supervisors, "supervisors loaded")
}

func (h *Handler) listChannelPartners(c *gin.Context) {
	var partners []model.ChannelPartner
	if err := h.db.Order("channel_partner_created_at desc").Find(&partners).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load channel partners")
		return
	}
	responses.JSON(c, http.StatusOK, true, partners, "channel partners loaded")
}

func (h *Handler) listMaterialItems(c *gin.Context) {
	var items []model.MaterialItem
	if err := h.db.Order("material_item_display_name asc").Find(&items).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load material items")
		return
	}
	responses.JSON(c, http.StatusOK, true, items, "material items loaded")
}

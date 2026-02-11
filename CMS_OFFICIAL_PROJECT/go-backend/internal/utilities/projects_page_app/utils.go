package projects_page_app

// Constants
var (
	ProjectStatusChoices = map[string]string{
		"Active":    "Active",
		"Planning":  "Planning",
		"Completed": "Completed",
		"On Hold":   "On Hold",
		"Cancelled": "Cancelled",
	}

	ProjectUnitStatusChoices = map[string]string{
		"available": "Available",
		"hold":      "On Hold",
		"booked":    "Booked",
		"sold":      "Sold",
	}

	KanbanStageMeta = map[string]map[string]string{
		"visitor":   {"label": "Visitor", "hint": "No payments; early interest"},
		"active":    {"label": "Active", "hint": "Paying or in progress"},
		"completed": {"label": "Completed", "hint": "Fully paid / closed"},
	}
)

// Request Structs

type CreateProjectRequest struct {
	ProjectCode                 string   `json:"project_code"`
	ProjectName                 string   `json:"project_name"`
	ProjectLandAreaSquareFeet   *float64 `json:"project_land_area_square_feet"`
	ProjectConstructionType     string   `json:"project_construction_type"`
	ProjectFlatConfiguration    string   `json:"project_flat_configuration"`
	ProjectBlockCount           uint     `json:"project_block_count"`
	ProjectLandAddress          string   `json:"project_land_address"`
	ProjectBudget               float64  `json:"project_budget"`
	ProjectDurationMonths       uint     `json:"project_duration_months"`
	ProjectStatus               string   `json:"project_status"`
	ProjectAssignedSupervisorID *uint    `json:"assigned_supervisor"` // Aliased for simpler payload
	ProjectAssignedCustomerID   *uint    `json:"assigned_customer"`   // Aliased
}

type UpdateProjectRequest struct {
	CreateProjectRequest // Embed for now, fields are similar
	// Add partial update fields if needed distinct from create
}

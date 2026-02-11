package crm_page_app

// KanbanStage represents a column in the Kanban board.
type KanbanStage struct {
	Key   string `json:"key"`
	Label string `json:"label"`
	Hint  string `json:"hint"`
}

// KanbanStages defines the standard lifecycle stages for a CRM unit.
var KanbanStages = []KanbanStage{
	{Key: "visitor", Label: "Visitor", Hint: "No payments; early interest"},
	{Key: "active", Label: "Active", Hint: "Paying or in progress"},
	{Key: "completed", Label: "Completed", Hint: "Fully paid / closed"},
}

// UpdateStageRequest mirrors the payload for updating a unit's stage.
type UpdateStageRequest struct {
	Stage string `json:"stage"`
}

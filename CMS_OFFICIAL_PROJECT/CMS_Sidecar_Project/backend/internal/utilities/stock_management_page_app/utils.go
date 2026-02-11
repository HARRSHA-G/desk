package stock_management_page_app

// UpdateStockRequest
type UpdateStockRequest struct {
	MaterialItemID uint        `json:"material_item_id"`
	TotalAllocated interface{} `json:"total_allocated"` // float or string
	Used           interface{} `json:"used"`
	Notes          string      `json:"notes"`
}

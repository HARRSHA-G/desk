package sales_page_app

// CreateBlockRequest
type CreateBlockRequest struct {
	Name               string      `json:"name"`
	FloorCount         interface{} `json:"floor_count"` // Can be string or int in JSON, handle conversion
	UnitsPerFloor      interface{} `json:"units_per_floor"`
	Notes              string      `json:"notes"`
	UnitLayoutTemplate interface{} `json:"unit_layout_template"` // JSON list or string
}

// UpdateBlockRequest
type UpdateBlockRequest struct {
	Name               string      `json:"name"`
	FloorCount         interface{} `json:"floor_count"`
	UnitsPerFloor      interface{} `json:"units_per_floor"`
	Notes              *string     `json:"notes"` // pointer to distinguish nil vs empty if needed
	UnitLayoutTemplate interface{} `json:"unit_layout_template"`
}

// UpdateUnitRequest
type UpdateUnitRequest struct {
	Status                string      `json:"status"`
	UnitLabel             string      `json:"unit_label"`
	BHKConfiguration      string      `json:"bhk_configuration"`
	BuyerName             string      `json:"buyer_name"`
	BuyerEmail            string      `json:"buyer_email"`
	BuyerPhone            string      `json:"buyer_phone"`
	BuyerReferenceSource  string      `json:"buyer_reference_source"`
	BuyerReferenceContact string      `json:"buyer_reference_contact"`
	BuyerCustomer         interface{} `json:"buyer_customer"`        // id or code
	BuyerChannelPartner   interface{} `json:"buyer_channel_partner"` // id
	Facing                string      `json:"facing"`
	Notes                 string      `json:"notes"`
	Price                 interface{} `json:"price"`        // string or number
	AreaSqft              interface{} `json:"area_sqft"`    // string or number
	BookingDate           string      `json:"booking_date"` // YYYY-MM-DD
}

type UnitResponse struct {
	ID                              uint   `json:"id"`
	ProjectCode                     string `json:"project_code"`
	ProjectUnitLabel                string `json:"project_unit_label"`
	ProjectUnitBHKConfiguration     string `json:"project_unit_bhk_configuration"`
	ProjectUnitStatus               string `json:"project_unit_status"`
	ProjectUnitFacing               string `json:"project_unit_facing"`
	ProjectUnitAreaSqft             string `json:"project_unit_area_sqft"`
	ProjectUnitPrice                string `json:"project_unit_price"`
	ProjectUnitBuyerName            string `json:"project_unit_buyer_name"`
	ProjectUnitBuyerEmail           string `json:"project_unit_buyer_email"`
	ProjectUnitBuyerPhone           string `json:"project_unit_buyer_phone"`
	ProjectUnitBuyerReferenceSource string `json:"project_unit_buyer_reference_source"`
	ProjectUnitBookingDate          string `json:"project_unit_booking_date"`
	ProjectUnitNotes                string `json:"project_unit_notes"`
}

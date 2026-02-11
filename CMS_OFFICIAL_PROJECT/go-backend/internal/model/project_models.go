package model

import (
	"time"

	"gorm.io/datatypes"
)

// Project mirrors the construction_project table in the existing Django backend.
type Project struct {
	ID                          uint              `gorm:"column:id;primaryKey" json:"id"`
	ProjectOwnerID              *uint             `gorm:"column:project_owner_id" json:"project_owner_id,omitempty"`
	ProjectAssignedSupervisorID *uint             `gorm:"column:project_assigned_supervisor_id" json:"project_assigned_supervisor_id,omitempty"`
	ProjectAssignedCustomerID   *uint             `gorm:"column:project_assigned_customer_id" json:"project_assigned_customer_id,omitempty"`
	ProjectCode                 string            `gorm:"column:project_code" json:"project_code"`
	ProjectName                 string            `gorm:"column:project_name" json:"project_name"`
	ProjectLandAreaSquareFeet   *float64          `gorm:"column:project_land_area_square_feet" json:"project_land_area_square_feet,omitempty"`
	ProjectConstructionType     string            `gorm:"column:project_construction_type" json:"project_construction_type"`
	ProjectFlatConfiguration    string            `gorm:"column:project_flat_configuration" json:"project_flat_configuration"`
	ProjectBlockCount           uint              `gorm:"column:project_block_count" json:"project_block_count"`
	ProjectLandAddress          string            `gorm:"column:project_land_address" json:"project_land_address"`
	ProjectBudget               float64           `gorm:"column:project_budget" json:"project_budget"`
	ProjectDurationMonths       uint              `gorm:"column:project_duration_months" json:"project_duration_months"`
	ProjectStatus               string            `gorm:"column:project_status" json:"project_status"`
	ProjectTotalPaid            float64           `gorm:"column:project_total_paid" json:"project_total_paid"`
	ProjectRemainingAmount      float64           `gorm:"column:project_remaining_amount" json:"project_remaining_amount"`
	ProjectPermissionStatusMap  datatypes.JSON    `gorm:"column:project_permission_status_map" json:"project_permission_status_map"`
	ProjectCreatedAt            time.Time         `gorm:"column:project_created_at" json:"project_created_at"`
	ProjectUpdatedAt            time.Time         `gorm:"column:project_updated_at" json:"project_updated_at"`
	ProjectDeletedAt            *time.Time        `gorm:"column:project_deleted_at" json:"project_deleted_at,omitempty"`
	Blocks                      []ProjectBlock    `gorm:"foreignKey:ProjectBlockProjectID" json:"blocks,omitempty"`
	ManpowerExpenses            []ManpowerExpense `gorm:"foreignKey:ManpowerExpenseProjectID" json:"manpower_expenses,omitempty"`
	MaterialExpenses            []MaterialExpense `gorm:"foreignKey:MaterialExpenseProjectID" json:"material_expenses,omitempty"`
	ProjectPayments             []ProjectPayment  `gorm:"foreignKey:ProjectPaymentProjectID" json:"project_payments,omitempty"`
	FlatPayments                []FlatPayment     `gorm:"foreignKey:FlatPaymentProjectID" json:"flat_payments,omitempty"`
	PlotPayments                []PlotPayment     `gorm:"foreignKey:PlotPaymentProjectID" json:"plot_payments,omitempty"`
}

func (Project) TableName() string {
	return "construction_project"
}

// ProjectBlock represents the construction_projectblock table.
type ProjectBlock struct {
	ID                        uint           `gorm:"column:id;primaryKey" json:"id"`
	ProjectBlockProjectID     uint           `gorm:"column:project_block_project_id" json:"project_id"`
	ProjectBlockName          string         `gorm:"column:project_block_name" json:"project_block_name"`
	ProjectBlockSequence      uint           `gorm:"column:project_block_sequence" json:"project_block_sequence"`
	ProjectBlockFloorCount    uint           `gorm:"column:project_block_floor_count" json:"project_block_floor_count"`
	ProjectBlockUnitsPerFloor uint           `gorm:"column:project_block_units_per_floor" json:"project_block_units_per_floor"`
	ProjectBlockNotes         string         `gorm:"column:project_block_notes" json:"project_block_notes"`
	ProjectBlockUnitLayout    datatypes.JSON `gorm:"column:project_block_unit_layout_template" json:"project_block_unit_layout_template"`
	ProjectBlockCreatedAt     time.Time      `gorm:"column:project_block_created_at" json:"project_block_created_at"`
	ProjectBlockUpdatedAt     time.Time      `gorm:"column:project_block_updated_at" json:"project_block_updated_at"`
	Units                     []ProjectUnit  `gorm:"foreignKey:ProjectUnitBlockID" json:"units,omitempty"`
	ProjectBlockProject       Project        `gorm:"foreignKey:ProjectBlockProjectID" json:"-"`
}

func (ProjectBlock) TableName() string {
	return "construction_projectblock"
}

// ProjectUnit mirrors construction_projectunit and captures buyer info and CRM status.
type ProjectUnit struct {
	ID                               uint         `gorm:"column:id;primaryKey" json:"id"`
	ProjectUnitBlockID               uint         `gorm:"column:project_unit_block_id" json:"block_id"`
	ProjectUnitFloorNumber           uint         `gorm:"column:project_unit_floor_number" json:"floor_number"`
	ProjectUnitNumber                uint         `gorm:"column:project_unit_number" json:"unit_number"`
	ProjectUnitLabel                 string       `gorm:"column:project_unit_label" json:"unit_label"`
	ProjectUnitBHKConfiguration      string       `gorm:"column:project_unit_bhk_configuration" json:"bhk_configuration"`
	ProjectUnitStatus                string       `gorm:"column:project_unit_status" json:"unit_status"`
	ProjectUnitCRMStage              string       `gorm:"column:project_unit_crm_stage" json:"crm_stage"`
	ProjectUnitFacing                string       `gorm:"column:project_unit_facing" json:"unit_facing"`
	ProjectUnitAreaSqft              *float64     `gorm:"column:project_unit_area_sqft" json:"area_sqft,omitempty"`
	ProjectUnitPrice                 *float64     `gorm:"column:project_unit_price" json:"unit_price,omitempty"`
	ProjectUnitBuyerName             string       `gorm:"column:project_unit_buyer_name" json:"buyer_name"`
	ProjectUnitBuyerEmail            string       `gorm:"column:project_unit_buyer_email" json:"buyer_email"`
	ProjectUnitBuyerPhone            string       `gorm:"column:project_unit_buyer_phone" json:"buyer_phone"`
	ProjectUnitBuyerReferenceSource  string       `gorm:"column:project_unit_buyer_reference_source" json:"reference_source"`
	ProjectUnitBuyerReferenceContact string       `gorm:"column:project_unit_buyer_reference_contact" json:"reference_contact"`
	ProjectUnitBookingDate           *time.Time   `gorm:"column:project_unit_booking_date" json:"booking_date,omitempty"`
	ProjectUnitNotes                 string       `gorm:"column:project_unit_notes" json:"unit_notes"`
	ProjectUnitCreatedAt             time.Time    `gorm:"column:project_unit_created_at" json:"created_at"`
	ProjectUnitUpdatedAt             time.Time    `gorm:"column:project_unit_updated_at" json:"updated_at"`
	ProjectUnitBuyerCustomerID       *uint        `gorm:"column:project_unit_buyer_customer_id" json:"buyer_customer_id,omitempty"`
	ProjectUnitBuyerChannelPartnerID *uint        `gorm:"column:project_unit_buyer_channel_partner_id" json:"buyer_channel_partner_id,omitempty"`
	ProjectUnitBlock                 ProjectBlock `gorm:"foreignKey:ProjectUnitBlockID" json:"-"`
}

func (ProjectUnit) TableName() string {
	return "construction_projectunit"
}

// ProjectPreset mirrors construction_projectpreset
type ProjectPreset struct {
	ID                         uint           `gorm:"column:id;primaryKey" json:"id"`
	ProjectPresetProjectID     uint           `gorm:"column:project_preset_project_id" json:"project_id"`
	ProjectPresetBHKOptions    datatypes.JSON `gorm:"column:project_preset_bhk_options" json:"bhk_options"`
	ProjectPresetFacingOptions datatypes.JSON `gorm:"column:project_preset_facing_options" json:"facing_options"`
	ProjectPresetAreaOptions   datatypes.JSON `gorm:"column:project_preset_area_options" json:"area_options"`
	ProjectPresetUpdatedAt     time.Time      `gorm:"column:project_preset_updated_at" json:"updated_at"`
}

func (ProjectPreset) TableName() string {
	return "construction_projectpreset"
}

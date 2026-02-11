package model

import "time"

// ProjectPayment mirrors project_payments table.
type ProjectPayment struct {
	ID          uint      `gorm:"column:id;primaryKey" json:"id"`
	ProjectID   uint      `gorm:"column:project_payment_project_id" json:"project_id"`
	Project     Project   `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
	Amount      float64   `gorm:"column:project_payment_amount" json:"amount"`
	Date        time.Time `gorm:"column:project_payment_date" json:"date"`
	Type        string    `gorm:"column:project_payment_type" json:"type"`
	Description string    `gorm:"column:project_payment_description" json:"description"`
	Document    string    `gorm:"column:project_payment_document" json:"document"` // File path
	CreatedAt   time.Time `gorm:"column:project_payment_created_at" json:"created_at"`
}

func (ProjectPayment) TableName() string {
	return "project_payments"
}

// FlatPayment mirrors flat_payments table.
type FlatPayment struct {
	ID        uint        `gorm:"column:id;primaryKey" json:"id"`
	ProjectID uint        `gorm:"column:flat_payment_project_id" json:"project_id"`
	Project   Project     `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
	UnitID    uint        `gorm:"column:flat_payment_unit_id" json:"unit_id"`
	Unit      ProjectUnit `gorm:"foreignKey:UnitID" json:"unit,omitempty"`
	Amount    float64     `gorm:"column:flat_payment_amount" json:"amount"`
	Stage     string      `gorm:"column:flat_payment_stage" json:"stage"`
	Method    string      `gorm:"column:flat_payment_method" json:"method"`
	Reference string      `gorm:"column:flat_payment_reference" json:"reference"`
	Remarks   string      `gorm:"column:flat_payment_remarks" json:"remarks"`
	Date      time.Time   `gorm:"column:flat_payment_date" json:"date"`
	Receipt   string      `gorm:"column:flat_payment_receipt" json:"receipt"` // File path
	CreatedAt time.Time   `gorm:"column:flat_payment_created_at" json:"created_at"`
}

func (FlatPayment) TableName() string {
	return "flat_payments"
}

// PlotPayment mirrors plot_payments table.
type PlotPayment struct {
	ID        uint        `gorm:"column:id;primaryKey" json:"id"`
	ProjectID uint        `gorm:"column:plot_payment_project_id" json:"project_id"`
	Project   Project     `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
	UnitID    uint        `gorm:"column:plot_payment_unit_id" json:"unit_id"`
	Unit      ProjectUnit `gorm:"foreignKey:UnitID" json:"unit,omitempty"`
	Amount    float64     `gorm:"column:plot_payment_amount" json:"amount"`
	Stage     string      `gorm:"column:plot_payment_stage" json:"stage"`
	Method    string      `gorm:"column:plot_payment_method" json:"method"`
	Reference string      `gorm:"column:plot_payment_reference" json:"reference"`
	Remarks   string      `gorm:"column:plot_payment_remarks" json:"remarks"`
	Date      time.Time   `gorm:"column:plot_payment_date" json:"date"`
	Receipt   string      `gorm:"column:plot_payment_receipt" json:"receipt"` // File path
	CreatedAt time.Time   `gorm:"column:plot_payment_created_at" json:"created_at"`
}

func (PlotPayment) TableName() string {
	return "plot_payments"
}

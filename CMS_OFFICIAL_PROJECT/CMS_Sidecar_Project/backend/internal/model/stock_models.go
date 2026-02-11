package model

import (
	"time"
)

// StockBalance mirrors stock_management_page_app/models.py StockBalance
type StockBalance struct {
	ID                  uint      `gorm:"column:id;primaryKey" json:"id"`
	StockProjectID      uint      `gorm:"column:stock_project_id" json:"stock_project_id"`
	StockMaterialItemID uint      `gorm:"column:stock_material_item_id" json:"stock_material_item_id"`
	StockTotalAllocated float64   `gorm:"column:stock_total_allocated;default:0" json:"stock_total_allocated"`
	StockUsed           float64   `gorm:"column:stock_used;default:0" json:"stock_used"`
	StockNotes          string    `gorm:"column:stock_notes" json:"stock_notes"`
	StockCreatedAt      time.Time `gorm:"column:stock_created_at" json:"stock_created_at"`
	StockUpdatedAt      time.Time `gorm:"column:stock_updated_at" json:"stock_updated_at"`

	// Relations
	StockProject      Project      `gorm:"foreignKey:StockProjectID" json:"-"`
	StockMaterialItem MaterialItem `gorm:"foreignKey:StockMaterialItemID" json:"material_item,omitempty"`
}

func (StockBalance) TableName() string {
	return "stock_management_page_app_stockbalance"
}

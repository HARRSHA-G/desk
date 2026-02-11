package model

import "time"

// MaterialItem mirrors the construction_materialitem table.
type MaterialItem struct {
	ID                      uint      `gorm:"column:id;primaryKey" json:"id"`
	MaterialItemName        string    `gorm:"column:material_item_name" json:"name"`
	MaterialItemDisplayName string    `gorm:"column:material_item_display_name" json:"display_name"`
	MaterialItemIsActive    bool      `gorm:"column:material_item_is_active" json:"is_active"`
	MaterialItemCreatedAt   time.Time `gorm:"column:material_item_created_at" json:"created_at"`
	MaterialItemUpdatedAt   time.Time `gorm:"column:material_item_updated_at" json:"updated_at"`
}

func (MaterialItem) TableName() string {
	return "construction_materialitem"
}

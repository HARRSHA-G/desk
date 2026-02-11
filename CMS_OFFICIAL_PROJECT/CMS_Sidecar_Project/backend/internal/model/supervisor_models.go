package model

import (
	"time"
)

// Supervisor mirrors construction_supervisor
type Supervisor struct {
	ID                       uint      `gorm:"column:id;primaryKey" json:"id"`
	SupervisorUserID         *uint     `gorm:"column:supervisor_user_id" json:"supervisor_user_id"`
	SupervisorCreatedByID    *uint     `gorm:"column:supervisor_created_by_id" json:"supervisor_created_by_id"`
	SupervisorCode           string    `gorm:"column:supervisor_code" json:"supervisor_code"`
	SupervisorName           string    `gorm:"column:supervisor_name" json:"supervisor_name"`
	SupervisorPrimaryPhone   string    `gorm:"column:supervisor_primary_phone_number" json:"supervisor_primary_phone_number"`
	SupervisorSecondaryPhone string    `gorm:"column:supervisor_secondary_phone_number" json:"supervisor_secondary_phone_number"`
	SupervisorAddress        string    `gorm:"column:supervisor_address" json:"supervisor_address"`
	SupervisorEmail          string    `gorm:"column:supervisor_email" json:"supervisor_email"`
	SupervisorPasswordHash   string    `gorm:"column:supervisor_password_hash" json:"-"`
	SupervisorCreatedAt      time.Time `gorm:"column:supervisor_created_at" json:"supervisor_created_at"`
	SupervisorUpdatedAt      time.Time `gorm:"column:supervisor_updated_at" json:"supervisor_updated_at"`

	// Relationships
	SupervisorUser   *User     `gorm:"foreignKey:SupervisorUserID" json:"-"`
	AssignedProjects []Project `gorm:"foreignKey:ProjectAssignedSupervisorID" json:"assigned_projects,omitempty"`
}

func (Supervisor) TableName() string {
	return "construction_supervisor"
}

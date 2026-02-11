package model

import "time"

// LaborWorkType mirrors construction_laborworktype and backs the manpower expense form.
type LaborWorkType struct {
	ID                       uint      `gorm:"column:id;primaryKey" json:"id"`
	LaborWorkTypeName        string    `gorm:"column:labor_work_type_name" json:"name"`
	LaborWorkTypeDescription string    `gorm:"column:labor_work_type_description" json:"description"`
	LaborWorkTypeCreatedAt   time.Time `gorm:"column:labor_work_type_created_at" json:"created_at"`
	LaborWorkTypeUpdatedAt   time.Time `gorm:"column:labor_work_type_updated_at" json:"updated_at"`
}

func (LaborWorkType) TableName() string {
	return "construction_laborworktype"
}

// ManpowerExpense tracks labor spending for the utilities/expenses page.
type ManpowerExpense struct {
	ID                            uint           `gorm:"column:id;primaryKey" json:"id"`
	ManpowerExpenseDate           time.Time      `gorm:"column:manpower_expense_date" json:"date"`
	ManpowerExpenseNumberOfPeople uint           `gorm:"column:manpower_expense_number_of_people" json:"number_of_people"`
	ManpowerExpensePerPersonCost  float64        `gorm:"column:manpower_expense_per_person_cost" json:"per_person_cost"`
	ManpowerExpenseTotalAmount    float64        `gorm:"column:manpower_expense_total_amount" json:"total_amount"`
	ManpowerExpenseDescription    string         `gorm:"column:manpower_expense_description" json:"description"`
	ManpowerExpenseCreatedAt      time.Time      `gorm:"column:manpower_expense_created_at" json:"created_at"`
	ManpowerExpenseUpdatedAt      time.Time      `gorm:"column:manpower_expense_updated_at" json:"updated_at"`
	ProjectID                     uint           `gorm:"column:manpower_expense_project_id" json:"project_id"`
	Project                       Project        `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
	WorkTypeID                    *uint          `gorm:"column:manpower_expense_work_type_id" json:"work_type_id,omitempty"`
	WorkType                      *LaborWorkType `gorm:"foreignKey:WorkTypeID" json:"work_type,omitempty"`
}

func (ManpowerExpense) TableName() string {
	return "construction_manpowerexpense"
}

// MaterialExpense captures material spending on a project.
type MaterialExpense struct {
	ID                            uint         `gorm:"column:id;primaryKey" json:"id"`
	MaterialExpenseDate           time.Time    `gorm:"column:material_expense_date" json:"date"`
	MaterialExpenseItemID         uint         `gorm:"column:material_expense_item_id" json:"item_id"`
	MaterialExpenseItem           MaterialItem `gorm:"foreignKey:MaterialExpenseItemID" json:"item,omitempty"`
	MaterialExpenseProjectID      uint         `gorm:"column:material_expense_project_id" json:"project_id"`
	Project                       Project      `gorm:"foreignKey:MaterialExpenseProjectID" json:"project,omitempty"`
	MaterialExpenseCustomItemName string       `gorm:"column:material_expense_custom_item_name" json:"custom_item,omitempty"`
	MaterialExpensePerUnitCost    float64      `gorm:"column:material_expense_per_unit_cost" json:"per_unit_cost"`
	MaterialExpenseQuantity       float64      `gorm:"column:material_expense_quantity" json:"quantity"`
	MaterialExpenseTotalAmount    float64      `gorm:"column:material_expense_total_amount" json:"total_amount"`
	MaterialExpenseCGST           float64      `gorm:"column:material_expense_cgst" json:"cgst"`
	MaterialExpenseSGST           float64      `gorm:"column:material_expense_sgst" json:"sgst"`
	MaterialExpenseIGST           float64      `gorm:"column:material_expense_igst" json:"igst"`
	MaterialExpenseTotalTax       float64      `gorm:"column:material_expense_total_tax" json:"total_tax"`
	MaterialExpenseDescription    string       `gorm:"column:material_expense_description" json:"description"`
	MaterialExpenseCreatedAt      time.Time    `gorm:"column:material_expense_created_at" json:"created_at"`
	MaterialExpenseUpdatedAt      time.Time    `gorm:"column:material_expense_updated_at" json:"updated_at"`
}

func (MaterialExpense) TableName() string {
	return "construction_materialexpense"
}

// GeneralExpense represents administrative or departmental charges like utilities.
type GeneralExpense struct {
	ID                        uint      `gorm:"column:id;primaryKey" json:"id"`
	GeneralExpenseType        string    `gorm:"column:general_expense_type" json:"type"`
	GeneralExpenseDate        time.Time `gorm:"column:general_expense_date" json:"date"`
	GeneralExpenseAmount      float64   `gorm:"column:general_expense_amount" json:"amount"`
	GeneralExpenseDescription string    `gorm:"column:general_expense_description" json:"description"`
	GeneralExpenseCreatedAt   time.Time `gorm:"column:general_expense_created_at" json:"created_at"`
	GeneralExpenseUpdatedAt   time.Time `gorm:"column:general_expense_updated_at" json:"updated_at"`
	ProjectID                 uint      `gorm:"column:general_expense_project_id" json:"project_id"`
	Project                   Project   `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
}

func (GeneralExpense) TableName() string {
	return "construction_generalexpense"
}

// DepartmentalExpense mirrors the departmental expense category.
type DepartmentalExpense struct {
	ID                             uint      `gorm:"column:id;primaryKey" json:"id"`
	DepartmentalExpenseDate        time.Time `gorm:"column:departmental_expense_date" json:"date"`
	DepartmentalExpenseAmount      float64   `gorm:"column:departmental_expense_amount" json:"amount"`
	DepartmentalExpenseDescription string    `gorm:"column:departmental_expense_description" json:"description"`
	DepartmentalExpenseCreatedAt   time.Time `gorm:"column:departmental_expense_created_at" json:"created_at"`
	DepartmentalExpenseUpdatedAt   time.Time `gorm:"column:departmental_expense_updated_at" json:"updated_at"`
	ProjectID                      uint      `gorm:"column:departmental_expense_project_id" json:"project_id"`
	Project                        Project   `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
}

func (DepartmentalExpense) TableName() string {
	return "construction_departmentalexpense"
}

// AdministrationExpense mirrors the administration expense category (includes utilities).
type AdministrationExpense struct {
	ID                               uint      `gorm:"column:id;primaryKey" json:"id"`
	AdministrationExpenseDate        time.Time `gorm:"column:administration_expense_date" json:"date"`
	AdministrationExpenseAmount      float64   `gorm:"column:administration_expense_amount" json:"amount"`
	AdministrationExpenseDescription string    `gorm:"column:administration_expense_description" json:"description"`
	AdministrationExpenseCreatedAt   time.Time `gorm:"column:administration_expense_created_at" json:"created_at"`
	AdministrationExpenseUpdatedAt   time.Time `gorm:"column:administration_expense_updated_at" json:"updated_at"`
	ProjectID                        uint      `gorm:"column:administration_expense_project_id" json:"project_id"`
	Project                          Project   `gorm:"foreignKey:ProjectID" json:"project,omitempty"`
}

func (AdministrationExpense) TableName() string {
	return "construction_administrationexpense"
}

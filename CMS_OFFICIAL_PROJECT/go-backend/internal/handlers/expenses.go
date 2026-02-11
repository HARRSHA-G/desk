package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/quickgeo/cms-official-go/internal/model"
	"github.com/quickgeo/cms-official-go/internal/responses"
)

// ListLaborWorkTypes returns all labor work types.
func (h *Handler) ListLaborWorkTypes(c *gin.Context) {
	var workTypes []model.LaborWorkType
	if err := h.db.Order("labor_work_type_name asc").Find(&workTypes).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load labor work types")
		return
	}
	responses.JSON(c, http.StatusOK, true, workTypes, "Labor work types loaded")
}

// ListManpowerExpenses returns manpower expenses.
func (h *Handler) ListManpowerExpenses(c *gin.Context) {
	var expenses []model.ManpowerExpense
	if err := h.db.Preload("Project").Preload("WorkType").Order("manpower_expense_date desc").Find(&expenses).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load manpower expenses")
		return
	}
	responses.JSON(c, http.StatusOK, true, expenses, "Manpower expenses loaded")
}

// ListMaterialExpenses returns material expenses.
func (h *Handler) ListMaterialExpenses(c *gin.Context) {
	var expenses []model.MaterialExpense
	if err := h.db.Preload("Project").Preload("MaterialExpenseItem").Order("material_expense_date desc").Find(&expenses).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load material expenses")
		return
	}
	responses.JSON(c, http.StatusOK, true, expenses, "Material expenses loaded")
}

// ListGeneralExpenses returns general expenses.
func (h *Handler) ListGeneralExpenses(c *gin.Context) {
	var expenses []model.GeneralExpense
	if err := h.db.Preload("Project").Order("general_expense_date desc").Find(&expenses).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load general expenses")
		return
	}
	responses.JSON(c, http.StatusOK, true, expenses, "General expenses loaded")
}

// ListDepartmentalExpenses returns departmental expenses.
func (h *Handler) ListDepartmentalExpenses(c *gin.Context) {
	var expenses []model.DepartmentalExpense
	if err := h.db.Preload("Project").Order("departmental_expense_date desc").Find(&expenses).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load departmental expenses")
		return
	}
	responses.JSON(c, http.StatusOK, true, expenses, "Departmental expenses loaded")
}

// ListAdministrationExpenses returns administration expenses.
func (h *Handler) ListAdministrationExpenses(c *gin.Context) {
	var expenses []model.AdministrationExpense
	if err := h.db.Preload("Project").Order("administration_expense_date desc").Find(&expenses).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load administration expenses")
		return
	}
	responses.JSON(c, http.StatusOK, true, expenses, "Administration expenses loaded")
}

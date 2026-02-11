package handlers

import (
	"net/http"
	"regexp"
	"strings"

	"github.com/gin-gonic/gin"
	"cms_sidecar_backend/internal/model"
	"cms_sidecar_backend/internal/responses"
	authUtils "cms_sidecar_backend/internal/utilities/auth_page_app"
	utils "cms_sidecar_backend/internal/utilities/profile_page_app"
	projectUtils "cms_sidecar_backend/internal/utilities/projects_page_app"
)

// ProfileView handles GET and POST for the profile page.
func (h *Handler) ProfileView(c *gin.Context) {
	// 1. Authenticate / Get User
	userID := uint(1) // Mock
	var user model.User
	if err := h.db.Preload("Profile").First(&user, userID).Error; err != nil {
		responses.JSON(c, http.StatusUnauthorized, false, nil, "User not found")
		return
	}

	// Create profile if missing (mirroring get_or_create)
	if user.Profile == nil {
		newProfile := model.Profile{UserID: user.ID, UserType: "builder", ThemePreference: "dark"}
		h.db.Create(&newProfile)
		user.Profile = &newProfile
	}
	profile := user.Profile

	switch c.Request.Method {
	case "GET":
		// Populate display fields
		displayName := profile.DisplayName
		if displayName == "" {
			displayName = user.FirstName
		}
		if displayName == "" {
			displayName = user.Username
		}

		avatarUrl := profile.Avatar // placeholder
		avatarLetter := "C"
		if len(displayName) > 0 {
			avatarLetter = strings.ToUpper(displayName[:1])
		}

		accountType := "Builder"
		if profile.UserType != "" {
			accountType = strings.Title(profile.UserType)
		}

		// Accessible Projects
		projects, err := h.getAccessibleProjects(user.ID) // Helper from payments.go
		if err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load projects")
			return
		}

		projectCount := len(projects)
		projectIDs := []uint{}
		totalBudget := 0.0
		for _, p := range projects {
			projectIDs = append(projectIDs, p.ID)
			totalBudget += p.ProjectBudget
		}

		// Status Counts
		statusCounts := projectUtils.BuildStatusCounts(projects)

		// Aggregations
		var manpowerTotal float64
		// Only run query if we have projects
		if len(projectIDs) > 0 {
			h.db.Model(&model.ManpowerExpense{}).Where("manpower_expense_project_id IN ?", projectIDs).
				Select("COALESCE(SUM(manpower_expense_total_amount), 0)").Scan(&manpowerTotal)
		}

		var materialTotal float64
		if len(projectIDs) > 0 {
			h.db.Model(&model.MaterialExpense{}).Where("material_expense_project_id IN ?", projectIDs).
				Select("COALESCE(SUM(material_expense_total_amount), 0)").Scan(&materialTotal)
		}
		totalExpenses := manpowerTotal + materialTotal

		var totalPayments float64
		if len(projectIDs) > 0 {
			h.db.Model(&model.ProjectPayment{}).Where("project_payment_project_id IN ?", projectIDs).
				Select("COALESCE(SUM(project_payment_amount), 0)").Scan(&totalPayments)
		}

		// Phone formatting
		phoneCC := ""
		phoneLocal := ""
		if len(profile.PhoneNumber) > 10 {
			phoneCC = profile.PhoneNumber[:len(profile.PhoneNumber)-10]
			phoneLocal = profile.PhoneNumber[len(profile.PhoneNumber)-10:]
		} else {
			phoneLocal = profile.PhoneNumber
		}

		responses.JSON(c, http.StatusOK, true, gin.H{
			"profile":              profile,
			"display_name":         displayName,
			"avatar_letter":        avatarLetter,
			"avatar_url":           avatarUrl,
			"account_type_display": accountType,
			"user_role":            profile.UserType,
			"theme_preference":     profile.ThemePreference,
			"project_count":        projectCount,
			"status_counts":        statusCounts,
			"total_expenses":       totalExpenses,
			"total_payments":       totalPayments,
			"total_budget":         totalBudget,
			"manpower_total":       manpowerTotal,
			"material_total":       materialTotal,
			"phone_country_code":   phoneCC,
			"phone_local":          phoneLocal,
			"email":                user.Email,
		}, "Profile loaded")

	case "POST":
		// Handle Updates
		var req utils.UpdateProfileRequest
		if err := c.ShouldBind(&req); err != nil {
			responses.JSON(c, http.StatusBadRequest, false, nil, "Invalid payload")
			return
		}

		// Validation: Phone
		phoneFinal := profile.PhoneNumber
		if req.PhoneLocal != "" {
			if matched, _ := regexp.MatchString(`^\d{10}$`, req.PhoneLocal); !matched {
				responses.JSON(c, http.StatusBadRequest, false, nil, "Phone number must be exactly 10 digits")
				return
			}
			cc := req.CountryCode
			if cc == "" {
				cc = "+91"
			}
			if !strings.HasPrefix(cc, "+") {
				cc = "+" + cc
			}
			phoneFinal = cc + req.PhoneLocal
		}

		// Validation: Password
		passwordChanged := false
		if req.CurrentPassword != "" || req.NewPassword != "" || req.ConfirmPassword != "" {
			if req.NewPassword != req.ConfirmPassword {
				responses.JSON(c, http.StatusBadRequest, false, nil, "New password and confirmation do not match")
				return
			}
			if len(req.NewPassword) < 8 {
				responses.JSON(c, http.StatusBadRequest, false, nil, "Password must be 8+ chars")
				return
			}
			user.Password = req.NewPassword // Hash this
			passwordChanged = true
		}

		// Update Fields
		if req.DisplayName != "" {
			profile.DisplayName = req.DisplayName
		}
		if req.Role != "" {
			profile.Role = req.Role
		}
		if req.Theme != "" {
			profile.ThemePreference = req.Theme
		}
		profile.PhoneNumber = phoneFinal

		// Save Profile
		if err := h.db.Save(profile).Error; err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to update profile")
			return
		}

		// Update User
		user.FirstName = req.DisplayName
		if req.Email != "" {
			user.Email = req.Email
		}
		if err := h.db.Save(&user).Error; err != nil {
			responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to update user")
			return
		}

		msg := "Profile updated successfully"
		if passwordChanged {
			msg = "Profile and password updated successfully"
		}

		responses.JSON(c, http.StatusOK, true, profile, msg)
	}
}

// Ensure authUtils is used or remove import if not used
var _ = authUtils.GetUserRole

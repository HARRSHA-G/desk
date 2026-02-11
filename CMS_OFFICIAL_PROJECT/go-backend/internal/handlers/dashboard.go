package handlers

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/quickgeo/cms-official-go/internal/model"
	"github.com/quickgeo/cms-official-go/internal/responses"
	authUtils "github.com/quickgeo/cms-official-go/internal/utilities/auth_page_app"
	projectUtils "github.com/quickgeo/cms-official-go/internal/utilities/projects_page_app"
)

// DashboardView mirrors the dashboard overview logic.
func (h *Handler) DashboardView(c *gin.Context) {
	// 1. Get User/Profile
	// For now, mocking user as 1 for mirroring logic until we possess full auth middleware.
	// In real app, userID := c.GetUint("userID")

	// Placeholder: User is assumed to be logged in (Middleware should handle this).
	// Let's assume we can fetch the user details from DB based on a mocked header or similar if auth wasn't active.
	// For strict mirroring of logic:

	// profile, _ = Profile.objects.get_or_create(user=request.user)
	// display_name = profile.display_name or ...

	// Mocking behavior:
	userID := uint(1) // Default to ID 1 for dev/mirroring if no auth token.

	var user model.User
	if err := h.db.Preload("Profile").First(&user, userID).Error; err != nil {
		// If no user 1, fail gracefully
		responses.JSON(c, http.StatusUnauthorized, false, nil, "User not authenticated")
		return
	}

	displayName := user.Username
	userRole := "builder"
	if user.Profile != nil {
		if user.Profile.UserType != "" {
			displayName = user.Username // or Profile display name if it existed
			userRole = authUtils.GetUserRole(user.Profile.UserType)
		}
	}

	// 2. Fetch User Projects (Scoped)
	// projects_for_user(request.user)
	var projects []model.Project
	query := h.db.Model(&model.Project{})

	switch userRole {
	case "builder", "organization":
		query = query.Where("project_owner_id = ?", user.ID)
	case "supervisor":
		// query = query.Where("project_assigned_supervisor__supervisor_user=user") -> Join
		// Simplified:
		// Join Supervisor table to check user_id?
		// Or assume project_assigned_supervisor_id points to a Supervisor record which points to User.
		// For mirroring A-Z, we need the Supervisor model link.
		// Let's stick to the main concept:
		// If logic is complicated, we might skip the detailed complex JOIN implementation in this step
		// unless explicity requested, but "A-Z" implies we should try.

		// Note from project_models.go: ProjectAssignedSupervisorID *uint.
		// This ID refers to `construction_supervisor` table ID.
		// We need to find the supervisor record for this user.
		var supervisor model.Supervisor
		if err := h.db.Where("supervisor_user_id = ?", user.ID).First(&supervisor).Error; err == nil {
			query = query.Where("project_assigned_supervisor_id = ?", supervisor.ID)
		} else {
			// User is supervisor role but no supervisor record? No projects.
			query = query.Where("1 = 0")
		}
	default:
		// Fallback: owner OR supervisor OR customer
		// Complex OR Logic
		// This requires finding the Supervisor/Customer IDs for this user first.

		var supID uint
		var custID uint

		var sup model.Supervisor
		if h.db.Where("supervisor_user_id = ?", user.ID).First(&sup).Error == nil {
			supID = sup.ID
		}
		var cust model.Customer
		if h.db.Where("customer_user_id = ?", user.ID).First(&cust).Error == nil {
			custID = cust.ID
		}

		// user.ID is owner
		conditions := []string{"project_owner_id = ?"}
		args := []interface{}{user.ID}

		if supID > 0 {
			conditions = append(conditions, "project_assigned_supervisor_id = ?")
			args = append(args, supID)
		}
		if custID > 0 {
			conditions = append(conditions, "project_assigned_customer_id = ?")
			args = append(args, custID)
		}

		whereClause := strings.Join(conditions, " OR ")
		query = query.Where(whereClause, args...)
	}

	if err := query.Find(&projects).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to load projects")
		return
	}

	// 3. Build Status Counts
	statusCounts := projectUtils.BuildStatusCounts(projects)

	// 4. Build Status Cards Payload
	var statusCards []map[string]interface{}
	for _, card := range projectUtils.StatusCardConfig {
		statusCards = append(statusCards, map[string]interface{}{
			"status":      card.Status,
			"key":         card.Key,
			"label":       card.Label,
			"description": card.Description,
			"icon":        card.Icon,
			"count":       statusCounts[card.Key],
		})
	}

	responses.JSON(c, http.StatusOK, true, gin.H{
		"display_name":   displayName,
		"status_cards":   statusCards,
		"status_counts":  statusCounts,
		"total_projects": statusCounts["total"],
	}, "Dashboard loaded")
}

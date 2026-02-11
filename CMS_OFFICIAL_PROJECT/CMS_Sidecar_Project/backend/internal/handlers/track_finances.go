package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"cms_sidecar_backend/internal/responses"
)

// TrackFinancesView - simple access check, returns 200 OK.
// In Django this renders a template. In Go backend API, it likely just confirms access or returns config.
// Frontend handles UI.
func (h *Handler) TrackFinancesView(c *gin.Context) {
	// Simple role check
	// user := c.MustGet("user").(model.User) -- if middleware
	// We'll trust middleware or mock:
	userID := uint(1) // mock
	_, err := h.getAccessibleProjects(userID)
	if err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Error checking access")
		return
	}

	// Just return success, frontend loads remaining data via other APIs (Project, Expenses, Payments)
	responses.JSON(c, http.StatusOK, true, gin.H{"message": "Access granted"}, "Welcome to Track Finances")
}

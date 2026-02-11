package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"cms_sidecar_backend/internal/responses"
)

// IndexView mirrors the index page logic.
// Logic: If authenticated -> Redirect Dashboard. Else -> Show Index.
func (h *Handler) IndexView(c *gin.Context) {
	// Mock auth check: In real app, check c.Get("userID") or similar.
	// We'll trust the client side token or session for now, OR rely on this endpoint
	// being called with a token.

	// If we assume this API is consumed by a SPA:
	// The SPA checks if it has a token. If yes, it might skip this or auto-navigate.
	// But to mirror server-side redirection logic:

	// Check if "Authorization" header exists?
	authHeader := c.GetHeader("Authorization")
	isAuthenticated := authHeader != ""

	if isAuthenticated {
		// Redirect logic
		// In an API, we send a JSON instruction or 302 Found.
		// Sending JSON as this is an API backend for a frontend app normally.
		responses.JSON(c, http.StatusOK, true, gin.H{
			"redirect": "dashboard",
			"message":  "User authenticated",
		}, "Redirect to dashboard")
		return
	}

	// Not authenticated
	responses.JSON(c, http.StatusOK, true, gin.H{
		"page":    "index",
		"message": "Welcome to CMS",
	}, "Show Index Page")
}

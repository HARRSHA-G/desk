package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/quickgeo/cms-official-go/internal/responses"
)

// InsightsView mirrors the insights page loader.
// Since the Django view only renders a template with no context,
// this API simply confirms availability.
func (h *Handler) InsightsView(c *gin.Context) {
	responses.JSON(c, http.StatusOK, true, gin.H{
		"message": "Insights module loaded",
	}, "Insights loaded")
}

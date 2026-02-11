package responses

import "github.com/gin-gonic/gin"

// APIResponse standardizes JSON output similar to the Django backend.
type APIResponse struct {
	Success bool        `json:"success"`
	Data    interface{} `json:"data,omitempty"`
	Message string      `json:"message"`
}

// JSON writes a standardized response.
func JSON(c *gin.Context, status int, success bool, data interface{}, message string) {
	c.JSON(status, APIResponse{
		Success: success,
		Data:    data,
		Message: message,
	})
}

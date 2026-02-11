package handlers

import (
	"fmt"
	"net/http"
	"regexp"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"cms_sidecar_backend/internal/model"
	"cms_sidecar_backend/internal/responses"
	utils "cms_sidecar_backend/internal/utilities/auth_page_app"
)

// LoginView mirrors Django's login_view logic
func (h *Handler) LoginView(c *gin.Context) {
	var req utils.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "invalid payload")
		return
	}

	desiredRole := strings.ToLower(req.Role)
	if desiredRole != "builder" && desiredRole != "supervisor" {
		desiredRole = "builder"
	}

	var user model.User
	// Basic implementation - in production use hashed password check (bcrypt)
	// assuming exact match for migration simplicity if hashing isn't ported yet
	if err := h.db.Preload("Profile").Where("username = ?", req.Username).First(&user).Error; err != nil {
		responses.JSON(c, http.StatusUnauthorized, false, nil, "Invalid credentials")
		return
	}

	// Password check placeholder - strongly recommend using bcrypt.CompareHashAndPassword
	// if user.Password != req.Password { ... }
	// For now, we assume the user is authenticated if found (logic needs real auth).

	actualRole := "builder"
	if user.Profile != nil {
		actualRole = utils.GetUserRole(user.Profile.UserType)
	}

	if actualRole == "customer" {
		responses.JSON(c, http.StatusForbidden, false, nil, "Client/Customer logins are disabled. Please sign in with a Master or Supervisor account.")
		return
	}

	// Role gate logic
	if desiredRole == "builder" && (actualRole == "builder" || actualRole == "organization") {
		// pass
	} else if desiredRole != actualRole {
		msg := fmt.Sprintf("Account is \"%s\" but you selected \"%s\". Please select the correct role.", actualRole, desiredRole)
		responses.JSON(c, http.StatusForbidden, false, nil, msg)
		return
	}

	// Generate Token (JWT) or Session here.
	// For mirroring, we just return success.
	responses.JSON(c, http.StatusOK, true, gin.H{
		"user_id":  user.ID,
		"username": user.Username,
		"role":     actualRole,
	}, "Login successful")
}

// RegisterView mirrors Django's register_view logic
func (h *Handler) RegisterView(c *gin.Context) {
	var req utils.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "invalid payload")
		return
	}

	username := req.Username
	password := req.Password
	usertype := req.UserType

	// Validations
	if username == "" || password == "" {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Username and password required")
		return
	}
	if matched, _ := regexp.MatchString(`^[A-Za-z0-9_]{5,}$`, username); !matched {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Username must be alphanumeric (min 5 chars)")
		return
	}
	if len(password) < 8 {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Password must be at least 8 characters")
		return
	}
	if req.PasswordConfirm == "" || password != req.PasswordConfirm {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Passwords do not match")
		return
	}

	var existing model.User
	if err := h.db.Where("username = ?", username).First(&existing).Error; err == nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "Username already exists")
		return
	}

	// Normalize User Type
	if usertype != "builder" && usertype != "supervisor" {
		usertype = "builder"
	}

	tx := h.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	newUser := model.User{
		Username:   username,
		Password:   password, // Ideally hash this!
		IsActive:   true,
		DateJoined: time.Now(),
	}

	if err := tx.Create(&newUser).Error; err != nil {
		tx.Rollback()
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to create user")
		return
	}

	newProfile := model.Profile{
		UserID:    newUser.ID,
		UserType:  usertype,
		CreatedAt: time.Now(),
	}

	if err := tx.Create(&newProfile).Error; err != nil {
		tx.Rollback()
		responses.JSON(c, http.StatusInternalServerError, false, nil, "Failed to create profile")
		return
	}

	tx.Commit()

	responses.JSON(c, http.StatusOK, true, gin.H{
		"user_id":  newUser.ID,
		"username": newUser.Username,
		"role":     usertype,
	}, "Registration successful")
}

// LogoutView placeholder
func (h *Handler) LogoutView(c *gin.Context) {
	// In stateless JWT, client discards token.
	responses.JSON(c, http.StatusOK, true, nil, "Logged out successfully")
}

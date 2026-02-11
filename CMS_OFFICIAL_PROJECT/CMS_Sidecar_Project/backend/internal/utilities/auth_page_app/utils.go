package auth_page_app

import "strings"

// LoginRequest mirrors request payload for login.
type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
	Role     string `json:"login_role"`
}

// RegisterRequest mirrors request payload for registration.
type RegisterRequest struct {
	Username        string `json:"username"`
	Password        string `json:"password"`
	PasswordConfirm string `json:"password_confirm"`
	UserType        string `json:"usertype"`
}

// GetUserRole returns the user type or defaults to 'builder'.
// This logic mirrors the Django helper:
// def get_user_role(user):
//     try:
//         return user.profile.user_type
//     except Exception:
//         return 'builder'
func GetUserRole(userType string) string {
	if userType == "" {
		return "builder"
	}
	return userType
}

// IsBuilderRole checks if the role is 'builder' or 'organization'.
// Logic mirrors Django:
// def is_builder_role(role):
//     return role in ('builder', 'organization')
func IsBuilderRole(role string) bool {
	role = strings.ToLower(role)
	return role == "builder" || role == "organization"
}

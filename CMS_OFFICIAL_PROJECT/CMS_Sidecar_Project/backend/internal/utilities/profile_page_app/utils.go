package profile_page_app

// Constants
var (
	ThemeChoices = map[string]string{
		"dark":  "Dark",
		"light": "Light",
	}
)

// UpdateProfileRequest struct
type UpdateProfileRequest struct {
	DisplayName     string `json:"display_name"`
	Email           string `json:"email"`
	Role            string `json:"role"`
	Theme           string `json:"theme_preference"`
	CountryCode     string `json:"country_code"`
	PhoneLocal      string `json:"phone_local"`
	CurrentPassword string `json:"current_password"`
	NewPassword     string `json:"new_password"`
	ConfirmPassword string `json:"confirm_password"`
	// Avatar handling via multipart form usually, but if JSON API, maybe base64?
	// The View handles standard Form POST. API usually standardizes on JSON.
	// We'll assume JSON for now or Form. Gin `ShouldBind` handles both if tags present.
}

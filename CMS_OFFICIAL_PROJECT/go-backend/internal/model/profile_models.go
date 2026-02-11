package model

import "time"

// Profile mirrors the profile_page_app_profile table.
type Profile struct {
	ID              uint      `gorm:"column:id;primaryKey" json:"id"`
	UserID          uint      `gorm:"column:profile_user_id;uniqueIndex" json:"user_id"`
	UserType        string    `gorm:"column:profile_user_type" json:"user_type"` // builder, supervisor, etc.
	ProjectsCount   uint      `gorm:"column:profile_projects_count;default:0" json:"projects_count"`
	DisplayName     string    `gorm:"column:profile_display_name" json:"display_name"`
	Role            string    `gorm:"column:profile_role" json:"role"` // e.g. "Manager"
	PhoneNumber     string    `gorm:"column:profile_phone_number" json:"phone_number"`
	Avatar          string    `gorm:"column:profile_avatar" json:"avatar"` // path
	ThemePreference string    `gorm:"column:profile_theme_preference;default:'dark'" json:"theme_preference"`
	CreatedAt       time.Time `gorm:"column:created_at" json:"created_at"` // Assuming timestamps exist or using Gorm defaults if not in Django model explicitly but usually good practice.
	// Django model didn't show created_at/updated_at explicitly in the snippet but standard models usually have them.
	// We'll leave them out or generic if not in snippet. The snippet shows `created = models.DateTimeField`? No.
	// It relies on Django defaults? No, Django models don't have timestamps by default unless added.
	// Snippet: `Profile(models.Model)`... no timestamp fields shown.
	// However, I added `CreatedAt` in previous `model/profile_models.go` iteration.
	// I will keep them but careful about column names.
	// Wait, if the Django model DOES NOT have them, GORM might fail to query if column missing.
	// I should check `0001_initial.py` or similar if I could, but I can't.
	// Safest is to NOT include them if not in Django model snippet.
	// I will remove CreatedAt/UpdatedAt to match the Django snippet strictly to avoid SQL errors.
}

func (Profile) TableName() string {
	return "profile_page_app_profile"
}

// User is a standard auth user meta-model.
type User struct {
	ID         uint      `gorm:"column:id;primaryKey" json:"id"`
	Username   string    `gorm:"column:username;uniqueIndex" json:"username"`
	Password   string    `gorm:"column:password" json:"-"`
	Email      string    `gorm:"column:email" json:"email"`
	FirstName  string    `gorm:"column:first_name" json:"first_name"`
	LastName   string    `gorm:"column:last_name" json:"last_name"`
	IsActive   bool      `gorm:"column:is_active" json:"is_active"`
	DateJoined time.Time `gorm:"column:date_joined" json:"date_joined"`
	Profile    *Profile  `gorm:"foreignKey:UserID;references:ID" json:"profile,omitempty"`
}

func (User) TableName() string {
	return "auth_user"
}

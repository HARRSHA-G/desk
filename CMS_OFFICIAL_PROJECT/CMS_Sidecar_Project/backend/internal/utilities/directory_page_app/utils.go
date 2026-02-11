package directory_page_app

import (
	"crypto/rand"
	"math/big"
)

// Constants containing choices used in directory forms.
var (
	CustomerUpdateFreq = map[string]string{
		"daily":   "Daily",
		"weekly":  "Weekly",
		"monthly": "Monthly",
	}

	CustomerContactPref = map[string]string{
		"phone": "Phone",
		"email": "Email",
	}

	PaymentMethodPref = map[string]string{
		"offline": "Offline",
		"online":  "Online",
	}
)

// GenerateTempPassword creates a random alphanumeric string.
func GenerateTempPassword(length int) (string, error) {
	const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	ret := make([]byte, length)
	for i := 0; i < length; i++ {
		num, err := rand.Int(rand.Reader, big.NewInt(int64(len(letters))))
		if err != nil {
			return "", err
		}
		ret[i] = letters[num.Int64()]
	}
	return string(ret), nil
}

// VendorListEntry mirrors vendor_list response.
type VendorListEntry struct {
	Name        string `json:"name"`
	DisplayName string `json:"display_name"`
	IsGuest     bool   `json:"is_guest,omitempty"`
	Code        string `json:"code,omitempty"`
}

// RegenerateCredentialsRequest payload.
type RegenerateCredentialsRequest struct {
	Type string `json:"type"`
	ID   uint   `json:"id"`
}

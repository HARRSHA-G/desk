package vendor_page_app

// CreateVendorRequest
type CreateVendorRequest struct {
	CompanyName       string `json:"company_name"`
	FirstName         string `json:"first_name"`
	LastName          string `json:"last_name"`
	PrimaryPhone      string `json:"primary_phone_number"`
	SecondaryPhone    string `json:"secondary_phone_number"`
	Email             string `json:"email"`
	BusinessAddress   string `json:"business_address"`
	PaymentPreference string `json:"payment_method_preference"`
	BankAccount       string `json:"bank_account_number"`
	PhonePIN          string `json:"phone_pin"`
}

// VendorResponse
type VendorResponse struct {
	ID                uint   `json:"id"`
	Code              string `json:"code"`
	CompanyName       string `json:"company_name"`
	FirstName         string `json:"first_name"`
	LastName          string `json:"last_name"`
	PrimaryPhone      string `json:"primary_phone_number"`
	SecondaryPhone    string `json:"secondary_phone_number"`
	Email             string `json:"email"`
	BusinessAddress   string `json:"business_address"`
	PaymentPreference string `json:"payment_method_preference"`
	BankAccount       string `json:"bank_account_number"`
}

type VendorChoice struct {
	ID          uint   `json:"id"`
	Name        string `json:"name"`
	DisplayName string `json:"display_name"`
	Code        string `json:"code"`
}

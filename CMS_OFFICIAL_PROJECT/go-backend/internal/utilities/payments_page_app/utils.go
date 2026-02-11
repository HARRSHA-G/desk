package payments_page_app

import "time"

// Constants for Payment choices.
var (
	PaymentTypes = map[string]string{
		"Advance":     "Advance Payment",
		"Installment": "Installment Payment",
		"Full":        "Full Payment",
	}

	UnitPaymentStages = map[string]string{
		"booking":            "Booking / Token",
		"construction_stage": "Construction Stage Installment",
		"handover":           "Handover / Final",
		"other":              "Other",
	}

	UnitPaymentMethods = map[string]string{
		"cash":          "Cash",
		"bank_transfer": "Bank Transfer",
		"cheque":        "Cheque",
		"upi":           "UPI / Wallet",
		"card":          "Card",
		"other":         "Other",
	}
)

// CreateProjectPaymentRequest struct
type CreateProjectPaymentRequest struct {
	ProjectID   uint      `json:"project_id" binding:"required"`
	Amount      float64   `json:"amount" binding:"required"`
	Type        string    `json:"payment_type" binding:"required"`
	Date        time.Time `json:"payment_date"`
	Description string    `json:"description"`
}

// CreateUnitPaymentRequest struct (shared for Flat/Plot)
type CreateUnitPaymentRequest struct {
	ProjectID uint      `json:"project_id" binding:"required"`
	UnitID    uint      `json:"unit_id" binding:"required"`
	Amount    float64   `json:"amount" binding:"required"`
	Stage     string    `json:"payment_stage"`
	Method    string    `json:"payment_method"`
	Reference string    `json:"reference_number"`
	Remarks   string    `json:"remarks"`
	Date      time.Time `json:"payment_date"`
}

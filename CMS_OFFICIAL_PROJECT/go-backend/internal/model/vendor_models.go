package model

import (
	"time"
)

// Vendor mirrors construction_vendor
type Vendor struct {
	ID                         uint      `gorm:"column:id;primaryKey" json:"id"`
	VendorCode                 string    `gorm:"column:vendor_code;unique" json:"vendor_code"`
	VendorCompanyName          string    `gorm:"column:vendor_company_name" json:"vendor_company_name"`
	VendorFirstName            string    `gorm:"column:vendor_first_name" json:"vendor_first_name"`
	VendorLastName             string    `gorm:"column:vendor_last_name" json:"vendor_last_name"`
	VendorPrimaryPhone         string    `gorm:"column:vendor_primary_phone_number" json:"vendor_primary_phone_number"`
	VendorSecondaryPhone       string    `gorm:"column:vendor_secondary_phone_number" json:"vendor_secondary_phone_number"`
	VendorEmail                string    `gorm:"column:vendor_email" json:"vendor_email"`
	VendorBusinessAddress      string    `gorm:"column:vendor_business_address" json:"vendor_business_address"`
	VendorPaymentPreference    string    `gorm:"column:vendor_payment_method_preference;default:'offline'" json:"vendor_payment_method_preference"`
	VendorBankAccountNumber    string    `gorm:"column:vendor_bank_account_number" json:"vendor_bank_account_number"`
	VendorOnlinePaymentPINHash string    `gorm:"column:vendor_online_payment_pin_hash" json:"-"`
	VendorCreatedAt            time.Time `gorm:"column:vendor_created_at" json:"vendor_created_at"`
	VendorUpdatedAt            time.Time `gorm:"column:vendor_updated_at" json:"vendor_updated_at"`
	VendorCreatedByID          *uint     `gorm:"column:vendor_created_by_id" json:"vendor_created_by_id"`

	// Relations
	VendorCreatedBy *User `gorm:"foreignKey:VendorCreatedByID" json:"-"`
}

func (Vendor) TableName() string {
	return "construction_vendor"
}

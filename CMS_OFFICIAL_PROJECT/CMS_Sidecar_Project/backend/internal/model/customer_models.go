package model

import "time"

// Customer mirrors the construction_customer table.
type Customer struct {
	ID                              uint      `gorm:"column:id;primaryKey" json:"id"`
	CustomerCode                    string    `gorm:"column:customer_code" json:"customer_code"`
	CustomerName                    string    `gorm:"column:customer_name" json:"customer_name"`
	CustomerPrimaryPhoneNumber      string    `gorm:"column:customer_primary_phone_number" json:"primary_phone"`
	CustomerSecondaryPhoneNumber    string    `gorm:"column:customer_secondary_phone_number" json:"secondary_phone"`
	CustomerAddress                 string    `gorm:"column:customer_address" json:"address"`
	CustomerCompanyName             string    `gorm:"column:customer_company_name" json:"company_name"`
	CustomerEmail                   string    `gorm:"column:customer_email" json:"email"`
	CustomerUpdatePreference        string    `gorm:"column:customer_update_frequency_preference" json:"update_frequency"`
	CustomerContactPreference       string    `gorm:"column:customer_contact_preference" json:"contact_preference"`
	CustomerJobTitle                string    `gorm:"column:customer_job_title" json:"job_title"`
	CustomerJobDetailNotes          string    `gorm:"column:customer_job_detail_notes" json:"job_detail_notes"`
	CustomerPaymentMethodPreference string    `gorm:"column:customer_payment_method_preference" json:"payment_method"`
	CustomerBankAccountName         string    `gorm:"column:customer_bank_account_name" json:"bank_account_name"`
	CustomerBankAccountNumber       string    `gorm:"column:customer_bank_account_number" json:"bank_account_number"`
	CustomerBankIFSCCode            string    `gorm:"column:customer_bank_ifsc_code" json:"bank_ifsc_code"`
	CustomerOnlineUPIID             string    `gorm:"column:customer_online_upi_id" json:"upi_id"`
	CustomerOnlineWalletNumber      string    `gorm:"column:customer_online_wallet_number" json:"wallet_number"`
	CustomerPasswordHash            string    `gorm:"column:customer_password_hash" json:"password_hash"`
	CustomerCreatedAt               time.Time `gorm:"column:customer_created_at" json:"created_at"`
	CustomerUpdatedAt               time.Time `gorm:"column:customer_updated_at" json:"updated_at"`
}

func (Customer) TableName() string {
	return "construction_customer"
}

package model

import "time"

// ChannelPartner mirrors the construction_channelpartner table.
type ChannelPartner struct {
	ID                         uint      `gorm:"column:id;primaryKey" json:"id"`
	ChannelPartnerCode         string    `gorm:"column:channel_partner_code" json:"channel_partner_code"`
	ChannelPartnerName         string    `gorm:"column:channel_partner_name" json:"name"`
	ChannelPartnerPrimaryPhone string    `gorm:"column:channel_partner_primary_phone_number" json:"primary_phone"`
	ChannelPartnerEmail        string    `gorm:"column:channel_partner_email" json:"email"`
	ChannelPartnerCity         string    `gorm:"column:channel_partner_city" json:"city"`
	ChannelPartnerReraNumber   string    `gorm:"column:channel_partner_rera_number" json:"rera_number"`
	ChannelPartnerCreatedAt    time.Time `gorm:"column:channel_partner_created_at" json:"created_at"`
	ChannelPartnerUpdatedAt    time.Time `gorm:"column:channel_partner_updated_at" json:"updated_at"`
}

func (ChannelPartner) TableName() string {
	return "construction_channelpartner"
}

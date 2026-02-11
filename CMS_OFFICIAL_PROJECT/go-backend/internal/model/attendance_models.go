package model

import (
	"errors"
	"fmt"
	"regexp"
	"strconv"
	"strings"
	"time"

	"gorm.io/gorm"
)

var (
	AttendanceStatusChoices = []string{"present", "remote", "leave", "absent"}
	AttendanceModeChoices   = []string{"onsite", "remote", "field"}
)

// AttendanceBatch mirrors construction_attendancebatch.
type AttendanceBatch struct {
	ID          uint               `gorm:"column:id;primaryKey" json:"id"`
	Name        string             `gorm:"column:name" json:"name"`
	Description string             `gorm:"column:description" json:"description"`
	CreatedAt   time.Time          `gorm:"column:created_at" json:"created_at"`
	Members     []AttendanceMember `gorm:"foreignKey:BatchID" json:"members,omitempty"`
}

func (AttendanceBatch) TableName() string {
	return "construction_attendancebatch"
}

// AttendanceMember mirrors construction_attendancemember.
type AttendanceMember struct {
	ID        uint            `gorm:"column:id;primaryKey" json:"id"`
	Name      string          `gorm:"column:name" json:"name"`
	Role      string          `gorm:"column:role" json:"role"`
	IsActive  bool            `gorm:"column:is_active" json:"is_active"`
	CreatedAt time.Time       `gorm:"column:created_at" json:"created_at"`
	BatchID   uint            `gorm:"column:batch_id" json:"batch_id"`
	Batch     AttendanceBatch `gorm:"foreignKey:BatchID" json:"batch,omitempty"`
}

func (AttendanceMember) TableName() string {
	return "construction_attendancemember"
}

// AttendanceRecord mirrors construction_attendancerecord.
type AttendanceRecord struct {
	ID              uint              `gorm:"column:id;primaryKey" json:"id"`
	AttendanceCode  string            `gorm:"column:attendance_code" json:"code"`
	AttendeeName    string            `gorm:"column:attendee_name" json:"name"`
	AttendeeRole    string            `gorm:"column:attendee_role" json:"role"`
	AttendanceDate  time.Time         `gorm:"column:attendance_date" json:"date"`
	Status          string            `gorm:"column:status" json:"status"`
	Mode            string            `gorm:"column:mode" json:"mode"`
	CheckInTime     *time.Time        `gorm:"column:check_in_time" json:"check_in_time,omitempty"`
	CheckOutTime    *time.Time        `gorm:"column:check_out_time" json:"check_out_time,omitempty"`
	WorkNotes       string            `gorm:"column:work_notes" json:"notes"`
	CreatedAt       time.Time         `gorm:"column:created_at" json:"created_at"`
	AttendeeUserID  *uint             `gorm:"column:attendee_user_id" json:"attendee_user_id,omitempty"`
	AttendanceBatch string            `gorm:"column:attendance_batch" json:"batch"`
	MemberID        *uint             `gorm:"column:member_id" json:"member_id,omitempty"`
	Member          *AttendanceMember `gorm:"foreignKey:MemberID" json:"member,omitempty"`
}

func (AttendanceRecord) TableName() string {
	return "construction_attendancerecord"
}

var attendanceCodePattern = regexp.MustCompile(`^ATT-(\d{4})$`)

func (r *AttendanceRecord) generateAttendanceCode(tx *gorm.DB) error {
	if r.AttendanceCode != "" {
		return nil
	}
	var last AttendanceRecord
	err := tx.Order("attendance_code desc").Limit(1).First(&last).Error
	seq := 1
	if err == nil && attendanceCodePattern.MatchString(last.AttendanceCode) {
		matches := attendanceCodePattern.FindStringSubmatch(last.AttendanceCode)
		if len(matches) == 2 {
			v, parseErr := strconv.Atoi(matches[1])
			if parseErr == nil {
				seq = v + 1
			}
		}
	}
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		return err
	}
	r.AttendanceCode = fmt.Sprintf("ATT-%04d", seq)
	return nil
}

func (r *AttendanceRecord) BeforeCreate(tx *gorm.DB) error {
	return r.generateAttendanceCode(tx)
}

// NormalizeAttendanceStatus ensures the provided status is known.
func NormalizeAttendanceStatus(status string) string {
	status = strings.ToLower(status)
	for _, choice := range AttendanceStatusChoices {
		if choice == status {
			return status
		}
	}
	return "present"
}

// NormalizeAttendanceMode ensures the provided mode is known.
func NormalizeAttendanceMode(mode string) string {
	mode = strings.ToLower(mode)
	for _, choice := range AttendanceModeChoices {
		if choice == mode {
			return mode
		}
	}
	return "onsite"
}

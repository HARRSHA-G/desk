package attendance_page_app

import (
	"strings"
	"time"
)

// Constants mirroring Django's utils.py
var (
	AttendanceStatusMap = map[string]string{
		"present": "Present",
		"remote":  "Remote",
		"leave":   "Leave",
		"absent":  "Absent",
	}

	AttendanceModeMap = map[string]string{
		"onsite": "On-site",
		"remote": "Remote",
		"field":  "Field Visit",
	}
)

// AttendanceBatchRequest mirrors the JSON sent when creating batches.
type AttendanceBatchRequest struct {
	Name        string   `json:"name"`
	Description string   `json:"description"`
	Members     []string `json:"members"`
	Role        string   `json:"role"`
}

// AttendanceRecordRequest captures the attendance marking payload.
type AttendanceRecordRequest struct {
	BatchID          uint   `json:"batch_id"`
	Mode             string `json:"mode"`
	Notes            string `json:"notes"`
	CheckIn          string `json:"check_in"`
	CheckOut         string `json:"check_out"`
	PresentMemberIDs []uint `json:"present_member_ids"`
}

// ChartEntry represents a label/total pair for graphs.
type ChartEntry struct {
	Label string `json:"label"`
	Total int    `json:"total"`
}

// DateOnly truncates time to midnight.
func DateOnly(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location())
}

// ParseAttendanceTime reads HH:MM strings.
func ParseAttendanceTime(value string) (*time.Time, error) {
	value = strings.TrimSpace(value)
	if value == "" {
		return nil, nil
	}
	parsed, err := time.Parse("15:04", value)
	if err != nil {
		return nil, err
	}
	return &parsed, nil
}

// MonthStart returns the first day of the month for the given date.
func MonthStart(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), 1, 0, 0, 0, 0, t.Location())
}

// SubtractMonths returns a date 'n' months before the given date.
// Go's AddDate(0, -n, 0) handles month rollover automatically.
func SubtractMonths(t time.Time, months int) time.Time {
	return t.AddDate(0, -months, 0)
}

// GetLast7Days returns the dates for the last 7 days including today.
func GetLast7Days(today time.Time) []time.Time {
	var dates []time.Time
	// range(6, -1, -1) in python means 6, 5, 4, 3, 2, 1, 0 days ago.
	for i := 6; i >= 0; i-- {
		dates = append(dates, today.AddDate(0, 0, -i))
	}
	return dates
}

// GetLast6Months returns the first day of the month for the last 6 months including current.
func GetLast6Months(today time.Time) []time.Time {
	currentMonthStart := MonthStart(today)
	var months []time.Time
	// range(5, -1, -1) means 5 months ago to 0 months ago.
	for i := 5; i >= 0; i-- {
		months = append(months, currentMonthStart.AddDate(0, -i, 0))
	}
	return months
}

// GetLast3Years returns the current year and the previous two years.
func GetLast3Years(today time.Time) []int {
	return []int{today.Year() - 2, today.Year() - 1, today.Year()}
}

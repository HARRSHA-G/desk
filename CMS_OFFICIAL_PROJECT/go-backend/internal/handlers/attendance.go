package handlers

import (
	"errors"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/quickgeo/cms-official-go/internal/model"
	"github.com/quickgeo/cms-official-go/internal/responses"
	utils "github.com/quickgeo/cms-official-go/internal/utilities/attendance_page_app"
	"gorm.io/gorm"
)

func (h *Handler) getAttendanceStats(c *gin.Context) {
	var records []model.AttendanceRecord
	if err := h.db.Order("attendance_date desc").Find(&records).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load attendance stats")
		return
	}

	now := time.Now()
	today := utils.DateOnly(now)
	stats := map[string]int{
		"total_today":    0,
		"present_today":  0,
		"remote_today":   0,
		"on_leave_today": 0,
	}

	dailyDates := utils.GetLast7Days(today)
	dailyTotals := make(map[string]int)

	monthRange := utils.GetLast6Months(today)
	monthlyTotals := make(map[string]int)

	yearRange := utils.GetLast3Years(today)
	yearlyTotals := make(map[int]int)
	statusTotals := make(map[string]int)

	for _, rec := range records {
		recDate := utils.DateOnly(rec.AttendanceDate)
		dateKey := recDate.Format("2006-01-02")
		dailyTotals[dateKey]++
		if recDate.Equal(today) {
			stats["total_today"]++
			if rec.Status == "present" {
				stats["present_today"]++
			}
			if rec.Mode == "remote" {
				stats["remote_today"]++
			}
			if rec.Status == "leave" {
				stats["on_leave_today"]++
			}
		}
		monthKey := recDate.Format("2006-01")
		monthlyTotals[monthKey]++
		yearlyTotals[recDate.Year()]++
		statusTotals[rec.Status]++
	}

	dailyChart := make([]utils.ChartEntry, len(dailyDates))
	for i, d := range dailyDates {
		dailyChart[i] = utils.ChartEntry{
			Label: d.Format("Jan 02"),
			Total: dailyTotals[d.Format("2006-01-02")],
		}
	}

	monthlyChart := make([]utils.ChartEntry, len(monthRange))
	for i, m := range monthRange {
		monthlyChart[i] = utils.ChartEntry{
			Label: m.Format("Jan 2006"),
			Total: monthlyTotals[m.Format("2006-01")],
		}
	}

	statusLabel := utils.AttendanceStatusMap
	statusChart := make([]utils.ChartEntry, 0, len(statusTotals))
	for status, total := range statusTotals {
		statusChart = append(statusChart, utils.ChartEntry{
			Label: statusLabel[status],
			Total: total,
		})
	}

	yearlyChart := make([]utils.ChartEntry, len(yearRange))
	for i, year := range yearRange {
		yearlyChart[i] = utils.ChartEntry{
			Label: strconv.Itoa(year),
			Total: yearlyTotals[year],
		}
	}

	responses.JSON(c, http.StatusOK, true, gin.H{
		"stats":         stats,
		"daily_chart":   dailyChart,
		"monthly_chart": monthlyChart,
		"yearly_chart":  yearlyChart,
		"status_chart":  statusChart,
	}, "attendance stats loaded")
}

func (h *Handler) listAttendanceRecords(c *gin.Context) {
	limit := 150
	if q := c.Query("limit"); q != "" {
		if val, err := strconv.Atoi(q); err == nil && val > 0 {
			limit = val
		}
	}

	var records []model.AttendanceRecord
	if err := h.db.Preload("Member").Order("attendance_date desc, created_at desc").Limit(limit).Find(&records).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load attendance records")
		return
	}
	responses.JSON(c, http.StatusOK, true, records, "attendance records loaded")
}

func (h *Handler) listAttendanceBatches(c *gin.Context) {
	var batches []model.AttendanceBatch
	if err := h.db.Order("name asc").Find(&batches).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load attendance batches")
		return
	}
	responses.JSON(c, http.StatusOK, true, batches, "attendance batches loaded")
}

func (h *Handler) listAttendanceMembers(c *gin.Context) {
	idParam := c.Param("id")
	if idParam == "" {
		responses.JSON(c, http.StatusBadRequest, false, nil, "missing batch id")
		return
	}
	batchID, err := strconv.ParseUint(idParam, 10, 64)
	if err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "invalid batch id")
		return
	}

	var members []model.AttendanceMember
	if err := h.db.Where("batch_id = ? AND is_active = ?", batchID, true).Order("name asc").Find(&members).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load batch members")
		return
	}
	responses.JSON(c, http.StatusOK, true, members, "batch members loaded")
}

func (h *Handler) createAttendanceBatch(c *gin.Context) {
	var req utils.AttendanceBatchRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "invalid payload")
		return
	}

	name := strings.TrimSpace(req.Name)
	if name == "" {
		responses.JSON(c, http.StatusBadRequest, false, nil, "batch name is required")
		return
	}
	role := strings.TrimSpace(req.Role)
	if role == "" {
		role = "staff"
	}

	tx := h.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			panic(r)
		}
	}()

	var batch model.AttendanceBatch
	err := tx.Where("name = ?", name).First(&batch).Error
	if err != nil && !errors.Is(err, gorm.ErrRecordNotFound) {
		tx.Rollback()
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load batch")
		return
	}
	if errors.Is(err, gorm.ErrRecordNotFound) {
		batch = model.AttendanceBatch{
			Name:        name,
			Description: strings.TrimSpace(req.Description),
			CreatedAt:   time.Now(),
		}
		if err := tx.Create(&batch).Error; err != nil {
			tx.Rollback()
			responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to create batch")
			return
		}
	} else if batch.Description == "" && strings.TrimSpace(req.Description) != "" {
		batch.Description = strings.TrimSpace(req.Description)
		if err := tx.Model(&batch).Update("description", batch.Description).Error; err != nil {
			tx.Rollback()
			responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to update batch description")
			return
		}
	}

	created := 0
	names := make(map[string]struct{})
	for _, raw := range req.Members {
		if raw == "" {
			continue
		}
		name := strings.TrimSpace(raw)
		if name == "" {
			continue
		}
		if _, ok := names[strings.ToLower(name)]; ok {
			continue
		}
		names[strings.ToLower(name)] = struct{}{}
		var member model.AttendanceMember
		if err := tx.Where("batch_id = ? AND name = ?", batch.ID, name).First(&member).Error; err == nil {
			continue
		}
		member = model.AttendanceMember{
			BatchID:   batch.ID,
			Name:      name,
			Role:      role,
			IsActive:  true,
			CreatedAt: time.Now(),
		}
		if err := tx.Create(&member).Error; err != nil {
			tx.Rollback()
			responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to create member")
			return
		}
		created++
	}

	if err := tx.Commit().Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to persist batch")
		return
	}

	message := "Batch saved."
	if created > 0 {
		message = fmt.Sprintf("Batch saved. Added %d member(s).", created)
	}
	responses.JSON(c, http.StatusOK, true, batch, message)
}

func (h *Handler) createAttendanceRecords(c *gin.Context) {
	var req utils.AttendanceRecordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "invalid payload")
		return
	}

	if len(req.PresentMemberIDs) == 0 {
		responses.JSON(c, http.StatusBadRequest, false, nil, "select at least one present member")
		return
	}

	checkIn, err := utils.ParseAttendanceTime(req.CheckIn)
	if err != nil || checkIn == nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "check-in time is required (HH:MM)")
		return
	}
	checkOut, err := utils.ParseAttendanceTime(req.CheckOut)
	if err != nil || checkOut == nil {
		responses.JSON(c, http.StatusBadRequest, false, nil, "check-out time is required (HH:MM)")
		return
	}

	var batch model.AttendanceBatch
	if err := h.db.First(&batch, req.BatchID).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			responses.JSON(c, http.StatusBadRequest, false, nil, "batch not found")
			return
		}
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load batch")
		return
	}

	var members []model.AttendanceMember
	if err := h.db.Where("batch_id = ? AND is_active = ?", batch.ID, true).Find(&members).Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to load batch members")
		return
	}

	presentMap := make(map[uint]struct{}, len(req.PresentMemberIDs))
	for _, id := range req.PresentMemberIDs {
		presentMap[id] = struct{}{}
	}

	attendanceDate := utils.DateOnly(time.Now())
	tx := h.db.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
			panic(r)
		}
	}()

	created := 0
	for _, member := range members {
		_, isPresent := presentMap[member.ID]
		status := "absent"
		mode := "onsite"
		if isPresent {
			status = "present"
			mode = model.NormalizeAttendanceMode(req.Mode)
		}
		record := model.AttendanceRecord{
			AttendeeName:    member.Name,
			AttendeeRole:    member.Role,
			AttendanceDate:  attendanceDate,
			Status:          status,
			Mode:            mode,
			CheckInTime:     nil,
			CheckOutTime:    nil,
			WorkNotes:       "",
			CreatedAt:       time.Now(),
			AttendanceBatch: batch.Name,
			MemberID:        &member.ID,
		}
		if isPresent {
			record.CheckInTime = checkIn
			record.CheckOutTime = checkOut
			record.WorkNotes = strings.TrimSpace(req.Notes)
		}
		if err := tx.Create(&record).Error; err != nil {
			tx.Rollback()
			responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to save attendance")
			return
		}
		created++
	}

	if err := tx.Commit().Error; err != nil {
		responses.JSON(c, http.StatusInternalServerError, false, nil, "failed to persist attendance")
		return
	}
	responses.JSON(c, http.StatusOK, true, nil, fmt.Sprintf("Marked attendance for %d member(s).", created))
}

package projects_page_app

import (
	"strings"

	"github.com/quickgeo/cms-official-go/internal/model"
)

// StatusCardConfigEntry mirrors the card configuration from Django helpers.
type StatusCardConfigEntry struct {
	Key         string `json:"key"`
	Status      string `json:"status"`
	Label       string `json:"label"`
	Description string `json:"description"`
	Icon        string `json:"icon"`
}

// StatusCardConfig defines the dashboard status cards.
var StatusCardConfig = []StatusCardConfigEntry{
	{
		Key:         "planning",
		Status:      "Planning",
		Label:       "Planning",
		Description: "Blueprints, permits, and budgets being finalized.",
		Icon:        "ri-draft-line",
	},
	{
		Key:         "active",
		Status:      "Active",
		Label:       "Active",
		Description: "Execution in progress with live site activity.",
		Icon:        "ri-pulse-line",
	},
	{
		Key:         "on_hold",
		Status:      "On Hold",
		Label:       "On Hold",
		Description: "Paused for approvals, funds, or client decisions.",
		Icon:        "ri-timer-2-line",
	},
	{
		Key:         "completed",
		Status:      "Completed",
		Label:       "Completed",
		Description: "Delivered with handover and closing checks done.",
		Icon:        "ri-verified-badge-line",
	},
	{
		Key:         "cancelled",
		Status:      "Cancelled",
		Label:       "Cancelled",
		Description: "Stopped with no further work planned.",
		Icon:        "ri-close-circle-line",
	},
}

var statusSlugMap map[string]string

func init() {
	statusSlugMap = make(map[string]string)
	for _, c := range StatusCardConfig {
		statusSlugMap[c.Key] = c.Key
		statusSlugMap[strings.ToLower(c.Status)] = c.Key
	}
}

func normalizeStatus(value string) string {
	if value == "" {
		return ""
	}
	return strings.ToLower(strings.TrimSpace(value))
}

// BuildStatusCounts calculates status distribution for given projects.
func BuildStatusCounts(projects []model.Project) map[string]int {
	counts := make(map[string]int)
	for _, c := range StatusCardConfig {
		counts[c.Key] = 0
	}
	counts["total"] = 0

	for _, p := range projects {
		norm := normalizeStatus(p.ProjectStatus)
		// simple replacement similar to Django logic "replace(' ', '_')" not strictly present here
		// but key mapping usually matches "on hold" -> "on_hold" if mapped correctly.
		// Let's refine normalize to match python logic exactly if we want standard keys.
		// Python: strip().lower().replace(" ", "_").
		// If project status is "On Hold", python -> "on_hold".

		// In Go, let's replicate that exactly:
		keyAttempt := strings.ReplaceAll(norm, " ", "_")

		if mapped, ok := statusSlugMap[keyAttempt]; ok {
			counts[mapped]++
		} else if mapped, ok := statusSlugMap[norm]; ok {
			// fallback check without underscore replacement
			counts[mapped]++
		}
		counts["total"]++
	}
	return counts
}

// Scoping logic will likely live in Repo/Service layer or Handler with scopes,
// but we can put a helper here if we pass the DB connection.
// For now, mirroring pure logic helpers.

package supervisor_page_app

// PageAccess record: global + project specific
type PageAccess struct {
	Global   []string            `json:"global"`
	Projects map[string][]string `json:"projects"`
}

// SupervisorRequest
type CreateSupervisorRequest struct {
	Name               string `json:"name"`
	PrimaryPhoneNumber string `json:"primary_phone_number"`
	SecondaryPhone     string `json:"secondary_phone_number"`
	Email              string `json:"email"`
	Address            string `json:"address"`
	AssignedProjectIDs []uint `json:"assigned_project_ids"`
}

// UpdateSupervisorRequest
type UpdateSupervisorRequest struct {
	Name               string      `json:"name"`
	PrimaryPhoneNumber string      `json:"primary_phone_number"`
	SecondaryPhone     string      `json:"secondary_phone_number"`
	Email              string      `json:"email"`
	Address            string      `json:"address"`
	AssignedProjectIDs []uint      `json:"assigned_project_ids"`
	PageAccess         *PageAccess `json:"page_access,omitempty"`
}

// SupervisorResponse includes model + assignments + access
type SupervisorResponse struct {
	ID                 uint       `json:"id"`
	Code               string     `json:"code"`
	Name               string     `json:"name"`
	PrimaryPhone       string     `json:"primary_phone_number"`
	SecondaryPhone     string     `json:"secondary_phone_number"`
	Email              string     `json:"email"`
	Address            string     `json:"address"`
	AssignedProjectIDs []uint     `json:"assigned_project_ids"`
	PageAccess         PageAccess `json:"page_access"`
}

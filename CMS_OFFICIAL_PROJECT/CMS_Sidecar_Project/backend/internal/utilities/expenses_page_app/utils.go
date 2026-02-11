package expenses_page_app

// Constants for expense configurations.
var (
	GeneralExpenseTypes = map[string]string{
		"departmental":   "Departmental Expense",
		"administration": "Administration Expense",
	}

	DepartmentalCategories = []string{
		"Quality & QC",
		"Safety",
		"Design & Engineering",
		"Security",
		"Procurement",
		"Human Resources",
		"Other (Departmental)",
	}

	AdministrationCategories = []string{
		"Legal & Permits",
		"Office & Software",
		"Insurance & Compliance",
		"Marketing & Tendering",
		"Travel & Communication",
		"Utilities & Bills",
		"Other (Administration)",
	}
)

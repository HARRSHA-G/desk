/**
 * Internationalization (i18n) Readiness (Rule 25 General Coding Standards).
 * Centralized mapping for UI strings to support future multi-language support.
 */

const translations = {
    en: {
        common: {
            appName: "ConstructFlow",
            loading: "Loading...",
            error: "An error occurred",
            save: "Save",
            cancel: "Cancel",
            delete: "Delete",
            edit: "Edit",
            actions: "Actions",
            searchPlaceholder: "Type here to search...",
            clearFilters: "Clear Filters",
        },
        dashboard: {
            title: "Dashboard",
            subtitle: "Overview of all construction projects.",
            totalProjects: "Total Projects",
            projectDetails: "Project Details",
        },
        projects: {
            title: "Projects Management",
            subtitle: "All your construction projects in one place.",
            newProject: "New Project",
            projectId: "Project ID",
            projectName: "Project Name",
            status: "Status",
            budget: "Budget",
        }
    }
};

export const t = (path, locale = 'en') => {
    const keys = path.split('.');
    let result = translations[locale];
    for (const key of keys) {
        if (result[key] === undefined) return path;
        result = result[key];
    }
    return result;
};

export default translations;

export const STATUS_CONFIG = {
    planning: { label: 'Planning', icon: 'ri-file-list-3-line', color: 'primary' },
    active: { label: 'In Progress', icon: 'ri-hammer-line', color: 'warning' },
    completed: { label: 'Completed', icon: 'ri-checkbox-circle-line', color: 'success' },
    on_hold: { label: 'On Hold', icon: 'ri-pause-circle-line', color: 'info' },
    cancelled: { label: 'Cancelled', icon: 'ri-close-circle-line', color: 'danger' },
};

export const formatCurrency = (val) => new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(val);

export const normalizeProjectData = (data) => {
    return data.map(p => {
        const normStatus = (p.project_status || p.status || 'planning').toLowerCase();
        return {
            ...p,
            id: p.id || p.project_id,
            code: p.project_code || p.code || 'N/A',
            name: p.project_name || p.name || 'Untitled',
            status: normStatus,
            layout: p.project_flat_configuration_label || p.flat_configuration_label || p.layout || '-',
            layoutKey: (p.project_flat_configuration || p.flat_configuration || '').toLowerCase(),
            budget: Number(p.estimated_budget || p.project_budget || p.budget || 0),
            received: Number(p.project_total_paid || p.total_paid || 0),
            pending: Number(p.project_remaining_amount || p.remaining_amount || 0),
            duration: p.project_duration_months || p.duration_months || '-',
            layoutKeyRaw: (p.project_flat_configuration || p.flat_configuration || '').toLowerCase(),
            customer: (p.project_flat_configuration === 'multi_flat' || p.project_flat_configuration === 'multi_plot')
                ? 'Handled in CRM'
                : (p.assigned_customer_name || p.project_assigned_customer?.customer_name || 'Not assigned'),
            supervisor: (p.project_flat_configuration === 'multi_flat' || p.project_flat_configuration === 'multi_plot')
                ? 'Assign via CRM/Blocks'
                : (p.assigned_supervisor_name || p.project_assigned_supervisor?.supervisor_name || 'Not assigned'),
        };
    });
};

export const calculateStats = (projects) => {
    const newStats = { planning: 0, active: 0, completed: 0, on_hold: 0, cancelled: 0 };
    projects.forEach(p => {
        let status = p.status;
        if (status === 'suspended' || status === 'on hold') status = 'on_hold';

        if (newStats.hasOwnProperty(status)) newStats[status]++;
        else if (status === 'in progress') newStats.active++;
    });
    return newStats;
};

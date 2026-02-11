export const formatCurrency = (value) =>
    Number.isFinite(value)
        ? value.toLocaleString('en-IN', {
            style: 'currency',
            currency: 'INR',
            minimumFractionDigits: 0,
        })
        : '₹0';

export const ensureString = (value, fallback = '') => {
    if (typeof value === 'string') return value;
    if (value === null || value === undefined) return fallback;
    if (typeof value === 'object') {
        if ('label' in value) return ensureString(value.label, fallback);
        if ('name' in value) return ensureString(value.name, fallback);
        if ('value' in value) return ensureString(value.value, fallback);
        try {
            return JSON.stringify(value);
        } catch {
            return fallback;
        }
    }
    return String(value);
};

export const normalizeProjects = (list) => {
    return list
        .map((proj) => ({
            id: proj.id,
            name: proj.project_name || proj.name || 'Untitled Project',
            code: proj.project_code || proj.code || '',
            status: (proj.status || '').toLowerCase(),
        }))
        .filter((proj) => !['completed', 'on hold', 'cancelled', 'archived'].includes(proj.status));
};

export const normalizeStockEntries = (entries) => {
    return entries.map((entry) => ({
        id: entry.id,
        name: ensureString(entry.material_name, 'Unnamed material'),
        total: Number(entry.total_stock) || Number(entry.allocated) || 0,
        used: Number(entry.used_stock) || Number(entry.used) || 0,
    }));
};

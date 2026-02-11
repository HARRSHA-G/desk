
import { z } from 'zod';

export const projectSchema = z.object({
    name: z.string().min(3, 'Name must be at least 3 characters'),
    code: z.string().min(2, 'Code is required'),
    landAddress: z.string().optional(),
    landArea: z.string().or(z.number()).optional(),
    constructionType: z.string().default('residential'),
    status: z.string().default('Planning'),
    layout: z.string().default('single_flat'),
    budget: z.string().or(z.number()).optional(),
    duration: z.string().or(z.number()).optional(),
    customer: z.string().optional(),
    supervisor: z.string().optional(),
});

export const PERMISSION_REQUIREMENTS = {
    residential: [
        { key: 'land_ownership_proof', label: 'Land ownership proof' },
        { key: 'land_use_conversion', label: 'Land use conversion' },
        { key: 'building_plan_approval', label: 'Building plan approval' },
        { key: 'layout_zonal_clearance', label: 'Layout / zoning clearance' },
        { key: 'technical_plans', label: 'Technical plans' },
    ],
    commercial: [
        { key: 'ownership_identity_proof', label: 'Ownership & identity proof' },
        { key: 'land_use_certificate', label: 'Land use certificate' },
        { key: 'building_plan_approval_commercial', label: 'Commercial plan approval' },
        { key: 'noc_fire_highrise', label: 'Fire NOC' },
        { key: 'noc_environmental', label: 'Environmental clearance' },
    ],
    semi_commercial: [
        { key: 'land_ownership_proof', label: 'Land ownership proof' },
        { key: 'building_plan_approval', label: 'Building plan approval' },
        { key: 'noc_fire', label: 'Fire NOC' },
        { key: 'noc_pollution', label: 'Pollution consent' },
    ],
};

export const FALLBACK_PROJECTS = [
    {
        id: 'PRJ-101',
        code: 'ID-101AAA',
        name: 'Evergreen Villas',
        status: 'active',
        layout: 'Single Unit',
        layoutKey: 'single_flat',
        budget: 12000000,
        paid: 5000000,
        remaining: 7000000,
        customer: 'Nikhil Green',
        supervisor: 'Asha Supervisor',
        landAddress: 'Plot 12, Greenfield Layout, Bengaluru',
        landArea: 3200,
        constructionType: 'Residential',
        duration: 12,
        permissionMap: {
            land_ownership_proof: 'completed',
            land_use_conversion: 'pending',
            building_plan_approval: 'pending',
            layout_zonal_clearance: 'pending',
            technical_plans: 'pending',
        },
    },
    {
        id: 'PRJ-102',
        code: 'ID-102BBB',
        name: 'Skyline Heights',
        status: 'planning',
        layout: 'Multi Flat',
        layoutKey: 'multi_flat',
        budget: 18000000,
        paid: 0,
        remaining: 18000000,
        customer: 'Handled in CRM',
        supervisor: 'Assign via CRM/Blocks',
        landAddress: 'Phase 2, Whitefield, Bengaluru',
        landArea: 5400,
        constructionType: 'Commercial',
        duration: 18,
        permissionMap: {},
    },
];

export const LAYOUT_LABELS = {
    single_flat: 'Single Unit',
    multi_flat: 'Multi Flat',
    multi_plot: 'Multi Plot',
};

export const VALID_LAYOUT_KEYS = Object.keys(LAYOUT_LABELS);

export const DEFAULT_FORM_DATA = {
    name: '',
    code: '',
    landAddress: '',
    landArea: '',
    constructionType: 'residential',
    status: 'Planning',
    layout: 'single_flat',
    budget: '',
    duration: '',
    customer: '',
    supervisor: '',
};

export const MULTI_UNIT_LAYOUTS = ['multi_flat', 'multi_plot'];
export const MULTI_UNIT_CUSTOMER_LABEL = 'Handled in CRM';
export const MULTI_UNIT_SUPERVISOR_LABEL = 'Assign via CRM/Blocks';

export const normalizeLayoutKey = (value) => {
    if (!value) return 'single_flat';
    const normalized = value.toString().toLowerCase().replace(/\s+/g, '_');
    return VALID_LAYOUT_KEYS.includes(normalized) ? normalized : 'single_flat';
};

export const formatStatusLabel = (value) => {
    if (!value) return 'Planning';
    const cleaned = value.toString().replace(/_/g, ' ').trim();
    return cleaned
        .split(' ')
        .map((chunk) => (chunk ? chunk.charAt(0).toUpperCase() + chunk.slice(1).toLowerCase() : chunk))
        .join(' ');
};

export const safeNumber = (value, fallback = 0) => {
    const numeric = Number(value);
    return Number.isNaN(numeric) ? fallback : numeric;
};

export const buildPermissionStateFromMap = (permissionMap = {}, constructionType = 'residential') => {
    const requirements = PERMISSION_REQUIREMENTS[constructionType] || [];
    const next = {};
    requirements.forEach((perm) => {
        const status = permissionMap?.[perm.key];
        next[perm.key] = status === true || (status || '').toString().toLowerCase() === 'completed';
    });
    return next;
};

export const buildPermissionMapFromState = (state = {}) => {
    const map = {};
    Object.keys(state).forEach((key) => {
        map[key] = state[key] ? 'completed' : 'pending';
    });
    return map;
};

export const getChoiceLabel = (choices = [], identifier) => {
    if (!identifier) return null;
    const match = choices.find((item) => (item.id || item.code) === identifier);
    return match?.name || match?.label || match?.code || null;
};

export const mapProjectToForm = (project) => {
    if (!project) {
        return { ...DEFAULT_FORM_DATA };
    }
    return {
        name: project.name || '',
        code: project.code || '',
        landAddress: project.landAddress || '',
        landArea: project.landArea ? String(project.landArea) : '',
        constructionType: project.constructionType || 'residential',
        status: formatStatusLabel(project.status),
        layout: project.layoutKey || normalizeLayoutKey(project.layout),
        budget: project.budget != null ? String(project.budget) : '',
        duration: project.duration != null ? String(project.duration) : '',
        customer: project.customerId || '',
        supervisor: project.supervisorId || '',
    };
};

export const buildProjectRecordFromForm = ({
    formData,
    permissionMap,
    existingProject = null,
    customerChoices = [],
    supervisorChoices = [],
}) => {
    const layoutKey = normalizeLayoutKey(formData.layout || existingProject?.layoutKey);
    const layoutLabel = LAYOUT_LABELS[layoutKey] || existingProject?.layout || 'Project';
    const status = (formData.status || existingProject?.status || 'Planning').toLowerCase();
    const budget = safeNumber(formData.budget, existingProject?.budget ?? 0);
    const duration = safeNumber(formData.duration, existingProject?.duration ?? 0);
    const area = safeNumber(formData.landArea, existingProject?.landArea ?? '');
    const isMultiLayout = MULTI_UNIT_LAYOUTS.includes(layoutKey);

    const defaultCustomerLabel = isMultiLayout ? MULTI_UNIT_CUSTOMER_LABEL : 'Not assigned';
    const defaultSupervisorLabel = isMultiLayout ? MULTI_UNIT_SUPERVISOR_LABEL : 'Not assigned';
    const customerLabel =
        isMultiLayout
            ? MULTI_UNIT_CUSTOMER_LABEL
            : getChoiceLabel(customerChoices, formData.customer) || existingProject?.customer || defaultCustomerLabel;
    const supervisorLabel =
        isMultiLayout
            ? MULTI_UNIT_SUPERVISOR_LABEL
            : getChoiceLabel(supervisorChoices, formData.supervisor) || existingProject?.supervisor || defaultSupervisorLabel;
    const customerId = isMultiLayout ? '' : formData.customer || existingProject?.customerId || '';
    const supervisorId = isMultiLayout ? '' : formData.supervisor || existingProject?.supervisorId || '';

    return {
        id: existingProject?.id || formData.id || `local-${Date.now()}`,
        code: formData.code || existingProject?.code || `PRJ-${Date.now()}`,
        name: formData.name || existingProject?.name || 'Untitled',
        status,
        layout: layoutLabel,
        layoutKey,
        budget,
        paid: existingProject?.paid ?? 0,
        remaining: existingProject?.remaining ?? budget,
        customer: customerLabel,
        customerId,
        supervisor: supervisorLabel,
        supervisorId,
        landAddress: formData.landAddress || existingProject?.landAddress || '',
        landArea: area,
        constructionType: formData.constructionType || existingProject?.constructionType || 'residential',
        permissionMap,
        duration,
    };
};

export const statusColor = (status) => {
    switch ((status || '').toLowerCase()) {
        case 'active':
            return 'warning';
        case 'completed':
            return 'success';
        case 'cancelled':
            return 'danger';
        case 'planning':
            return 'primary';
        case 'on_hold':
        case 'on hold':
            return 'info';
        default:
            return 'neutral';
    }
};

export const formatCurrency = (val) =>
    new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(
        Number(val || 0),
    );

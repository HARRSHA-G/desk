export const STATUS_META = {
    available: { label: 'Available', color: 'success' },
    hold: { label: 'Hold', color: 'warning' },
    booked: { label: 'Booked', color: 'info' },
    sold: { label: 'Sold', color: 'neutral' },
    missing: { label: 'Missing', color: 'danger' },
};

export const TEMPLATE_PRESETS = [
    { label: 'Plot 30 x 40 - North', config: { size: '1200 sqft', facing: 'North', price: 'INR 42 L' } },
    { label: 'Plot 40 x 60 - East', config: { size: '2400 sqft', facing: 'East', price: 'INR 68 L' } },
    { label: 'Plot 30 x 50 - West', config: { size: '1500 sqft', facing: 'West', price: 'INR 52 L' } },
];

export const CHANNEL_PARTNERS = ['In-house sales', 'Channel Prism', 'Partner Orbit'];

export const DEFAULT_FILTERS = {
    search: '',
    stage: 'all',
    status: 'all',
    facing: 'all',
    zone: 'all',
    floor: 'all',
};

export const heroPanelSx = (mode) => ({
    borderRadius: '24px',
    border: '1px solid',
    borderColor: mode === 'dark' ? 'rgba(255,255,255,0.2)' : 'rgba(15,23,42,0.2)',
    boxShadow: mode === 'dark' ? '0 30px 60px rgba(0,0,0,0.65)' : '0 30px 50px rgba(15,23,42,0.2)',
    backdropFilter: 'blur(24px)',
    backgroundColor: mode === 'dark' ? 'rgba(15,23,42,0.75)' : 'rgba(255,255,255,0.92)',
    color: mode === 'dark' ? '#f8fafc' : '#111827',
    p: { xs: 3, md: 4 },
});

export const glassPanelSx = (mode) => ({
    borderRadius: '20px',
    border: '1px solid',
    borderColor: mode === 'dark' ? 'rgba(255,255,255,0.15)' : 'rgba(15,23,42,0.08)',
    boxShadow: mode === 'dark' ? '0 20px 40px rgba(0,0,0,0.6)' : '0 20px 40px rgba(15,23,42,0.15)',
    backdropFilter: 'blur(18px)',
    backgroundColor: mode === 'dark' ? 'rgba(15,23,42,0.65)' : 'rgba(255,255,255,0.85)',
});

export const HERO_DESCRIPTION = 'Transparent control surface for multi-plot projects with floors, plot templates, and live availability from the sales API.';

// --- Data Builders ---

export const floorProfilesNorth = [
    { floor: 5, stage: 'launch', statuses: ['available', 'hold', 'booked', 'sold'] },
    { floor: 4, stage: 'launch', statuses: ['hold', 'available', 'booked', 'sold'] },
    { floor: 3, stage: 'pre-launch', statuses: ['available', 'available', 'hold', 'booked'] },
    { floor: 2, stage: 'handover', statuses: ['sold', 'sold', 'sold', 'sold'] },
];

export const floorProfilesSouth = [
    { floor: 5, stage: 'launch', statuses: ['available', 'hold', 'missing', 'sold'] },
    { floor: 4, stage: 'launch', statuses: ['booked', 'booked', 'hold', 'available'] },
    { floor: 3, stage: 'pre-launch', statuses: ['available', 'available', 'hold', 'booked'] },
    { floor: 2, stage: 'handover', statuses: ['sold', 'sold', 'booked', 'available'] },
];

const buildFloor = (zoneId, floorNumber, stage, statuses) => {
    const facings = ['North', 'East', 'South', 'West'];
    const sizes = ['1200 sqft', '1500 sqft', '1800 sqft', '2400 sqft'];
    return {
        floor: floorNumber,
        plots: statuses.slice(0, 4).map((status, idx) => ({
            id: `${zoneId}-${floorNumber}-${idx + 1}`,
            label: `${floorNumber}${String(idx + 1).padStart(2, '0')}`,
            status,
            stage,
            facing: facings[idx % facings.length],
            size: sizes[idx % sizes.length],
            price: `${40 + idx * 6}L`,
            buyer: {},
        })),
    };
};

const buildZone = (zoneId, name, stage, floorProfiles) => ({
    zoneId,
    name,
    stage,
    floors: floorProfiles.map((profile) => buildFloor(zoneId, profile.floor, profile.stage, profile.statuses)),
});

export const FALLBACK_MULTI_PLOT_DEFINITIONS = [
    {
        id: 'ID-105EEE',
        code: 'ID-105EEE',
        name: 'Meadow Plots',
        stage: 'launch',
        status: 'active',
        badge: 'Meadow Plots Launch',
        location: 'Whitefield, Bangalore',
        description: 'Phase 1 pockets with smart road and landscape planning.',
        zones: [
            { zoneId: 'N', name: 'North Ridge', stage: 'launch', floorProfiles: floorProfilesNorth },
            { zoneId: 'S', name: 'South Vale', stage: 'pre-launch', floorProfiles: floorProfilesSouth },
        ],
    },
    {
        id: 'ID-106FFF',
        code: 'ID-106FFF',
        name: 'Lakeside Acres',
        stage: 'pre-launch',
        status: 'active',
        badge: 'Lakeside Acres',
        location: 'Udaipur, Rajasthan',
        description: 'Premium lakeside plots with gated community amenities.',
        zones: [
            { zoneId: 'E', name: 'East Bay', stage: 'launch', floorProfiles: floorProfilesNorth },
            { zoneId: 'W', name: 'West Shores', stage: 'handover', floorProfiles: floorProfilesSouth },
        ],
    },
];

export const buildFallbackMultiPlotProject = (definition) => ({
    id: definition.id,
    code: definition.code,
    name: definition.name,
    stage: definition.stage,
    status: definition.status,
    badge: definition.badge,
    location: definition.location,
    description: definition.description,
    zones: definition.zones.map((zone) =>
        buildZone(zone.zoneId, zone.name, zone.stage, zone.floorProfiles),
    ),
});

export const getFallbackMultiPlotProjects = (projectId) => {
    if (projectId) {
        const match = FALLBACK_MULTI_PLOT_DEFINITIONS.find((definition) => String(definition.id) === String(projectId));
        return match ? [buildFallbackMultiPlotProject(match)] : [];
    }
    return FALLBACK_MULTI_PLOT_DEFINITIONS.map(buildFallbackMultiPlotProject);
};

// --- Helpers ---

export const flattenPlots = (projects) => {
    const units = [];
    projects.forEach((project) => {
        project.zones.forEach((zone) => {
            zone.floors.forEach((floor) => {
                floor.plots.forEach((plot) => {
                    units.push({
                        ...plot,
                        projectId: project.id,
                        projectName: project.name,
                        projectCode: project.code,
                        zoneId: zone.zoneId,
                        zoneName: zone.name,
                        floorNumber: floor.floor,
                        zoneStage: zone.stage,
                        projectStage: project.stage,
                    });
                });
            });
        });
    });
    return units;
};

export const matchesSearch = (plot, term) => {
    if (!term) return true;
    const normalized = term.toLowerCase();
    return (
        plot.label.toLowerCase().includes(normalized) ||
        plot.projectName.toLowerCase().includes(normalized) ||
        plot.zoneName.toLowerCase().includes(normalized)
    );
};

export const applyFilters = (plots, filters) =>
    plots.filter((plot) => {
        if (filters.stage !== 'all' && plot.stage !== filters.stage) return false;
        if (filters.status !== 'all' && plot.status !== filters.status) return false;
        if (filters.facing !== 'all' && plot.facing !== filters.facing) return false;
        if (filters.zone !== 'all' && plot.zoneId !== filters.zone) return false;
        if (filters.floor !== 'all' && String(plot.floorNumber) !== String(filters.floor)) return false;
        if (!matchesSearch(plot, filters.search)) return false;
        return true;
    });

export const buildSummary = (plots) => {
    const counts = { total: plots.length, available: 0, hold: 0, booked: 0, sold: 0, missing: 0 };
    plots.forEach((plot) => {
        const status = plot.status;
        if (status && typeof counts[status] === 'number') {
            counts[status] += 1;
        }
    });
    const zoneCount = Array.from(new Set(plots.map((plot) => `${plot.projectId}-${plot.zoneId}`))).length;
    return { ...counts, zones: zoneCount };
};

export const uniqueValues = (items, selector) => {
    const set = new Set();
    items.forEach((item) => {
        const value = selector(item);
        if (value) set.add(value);
    });
    return Array.from(set);
};

export const stageOptionsFromPlots = (plots) => uniqueValues(plots, (plot) => plot.stage).sort();
export const facingOptionsFromPlots = (plots) => uniqueValues(plots, (plot) => plot.facing).sort();
export const floorOptionsFromPlots = (plots) =>
    Array.from(new Set(plots.map((plot) => plot.floorNumber).filter((floor) => floor != null))).sort((a, b) => a - b);
export const zoneOptionsFromProjects = (projects) =>
    Array.from(new Set(projects.flatMap((project) => project.zones.map((zone) => zone.zoneId)))).sort();

export const humanize = (value) =>
    value
        ?.split('-')
        .map((chunk) => (chunk ? chunk.charAt(0).toUpperCase() + chunk.slice(1) : chunk))
        .join(' ');

export const buildQueryFromFilters = (filters) => {
    const query = {};
    if (filters.stage && filters.stage !== 'all') query.stage = filters.stage;
    if (filters.status && filters.status !== 'all') query.status = filters.status;
    if (filters.facing && filters.facing !== 'all') query.facing = filters.facing;
    if (filters.zone && filters.zone !== 'all') query.zone = filters.zone;
    if (filters.floor && filters.floor !== 'all') query.floor = filters.floor;
    return query;
};

// --- Mappers ---

export const normalizeMultiPlotPayload = (rawData) => {
    const payload = Array.isArray(rawData) ? rawData : rawData?.results || rawData?.projects || [];
    if (!Array.isArray(payload) || !payload.length) return [];
    return payload.map((project, projectIndex) => {
        const zonesSource = project.zones || project.blocks || [];
        const normalizedZones = zonesSource
            .map((zone, zoneIndex) => {
                const floorsSource = zone.floors || zone.levels || [];
                const normalizedFloors = floorsSource
                    .map((floor) => {
                        const plotsSource = floor.plots || floor.units || [];
                        const normalizedPlots = plotsSource.map((plot, plotIndex) => ({
                            id: plot.plot_id || plot.id || `${projectIndex}-${zoneIndex}-${plotIndex}`,
                            label: plot.plot_label || plot.name || `P-${plotIndex + 1}`,
                            status: (plot.status || 'available').toLowerCase(),
                            stage: (plot.stage || project.stage || 'launch').toLowerCase(),
                            facing: plot.facing || 'North',
                            size: plot.size || plot.plot_size || '1200 sqft',
                            price: plot.price || plot.amount || 'INR 45 L',
                            buyer: plot.buyer || {},
                        }));
                        if (!normalizedPlots.length) return null;
                        return {
                            floor: floor.floor || floor.level || 0,
                            plots: normalizedPlots,
                        };
                    })
                    .filter(Boolean);
                if (!normalizedFloors.length) return null;
                return {
                    zoneId: zone.zone_id || zone.code || `Z-${zoneIndex + 1}`,
                    name: zone.name || zone.zone_label || `Zone ${zoneIndex + 1}`,
                    stage: zone.stage || project.stage || 'launch',
                    floors: normalizedFloors,
                };
            })
            .filter(Boolean);
        if (!normalizedZones.length) return null;
        return {
            id: project.id || project.project_id || `project-${projectIndex}`,
            code: project.code || project.project_code || `MP-${projectIndex}`,
            name: project.name || project.project_name || 'Unnamed project',
            stage: (project.stage || 'launch').toLowerCase(),
            status: project.status || project.project_status || 'active',
            badge: project.badge || 'Plot matrix',
            location: project.location || project.address || 'Location pending',
            description: project.description || project.summary || '',
            zones: normalizedZones,
        };
    }).filter(Boolean);
};

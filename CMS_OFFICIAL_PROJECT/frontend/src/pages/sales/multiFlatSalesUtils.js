export const STATUS_META = {
    available: { label: 'Available', color: 'success' },
    hold: { label: 'Hold', color: 'warning' },
    booked: { label: 'Booked', color: 'info' },
    sold: { label: 'Sold', color: 'neutral' },
    missing: { label: 'Missing', color: 'danger' },
};

export const TEMPLATE_PRESETS = [
    { label: '2BHK East Cozy  -  1065', config: { bhk: '2 BHK', facing: 'East', area: '1065' } },
    { label: '3BHK North Premium  -  1450', config: { bhk: '3 BHK', facing: 'North', area: '1450' } },
    { label: '3BHK West Penthouse  -  1580', config: { bhk: '3 BHK', facing: 'West', area: '1580' } },
];

export const CHANNEL_PARTNERS = ['In-house sales', 'Channel Prism', 'Partner Orbit'];

export const DEFAULT_FILTERS = {
    search: '',
    stage: 'all',
    status: 'all',
    facing: 'all',
    block: 'all',
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

export const HERO_DESCRIPTION = 'Translucent control surface with filters, live metrics, and the grid you need to keep every floor and unit in sync with sales commitments.';

// --- Data Builders ---

export const floorProfilesA = [
    { floor: 16, stage: 'launch', statuses: ['available', 'hold', 'booked', 'sold'] },
    { floor: 15, stage: 'launch', statuses: ['sold', 'booked', 'hold', 'missing'] },
    { floor: 14, stage: 'pre-launch', statuses: ['available', 'hold', 'available', 'booked'] },
    { floor: 13, stage: 'handover', statuses: ['sold', 'sold', 'booked', 'available'] },
];

export const floorProfilesB = [
    { floor: 12, stage: 'pre-launch', statuses: ['available', 'available', 'hold', 'booked'] },
    { floor: 11, stage: 'launch', statuses: ['hold', 'booked', 'sold', 'missing'] },
    { floor: 10, stage: 'handover', statuses: ['sold', 'sold', 'booked', 'available'] },
    { floor: 9, stage: 'launch', statuses: ['available', 'hold', 'booked', 'available'] },
];

export const floorProfilesC = [
    { floor: 18, stage: 'launch', statuses: ['available', 'hold', 'booked', 'sold'] },
    { floor: 17, stage: 'launch', statuses: ['booked', 'sold', 'hold', 'missing'] },
    { floor: 16, stage: 'pre-launch', statuses: ['available', 'hold', 'available', 'booked'] },
    { floor: 15, stage: 'handover', statuses: ['sold', 'sold', 'booked', 'available'] },
];

export const floorProfilesD = [
    { floor: 14, stage: 'launch', statuses: ['hold', 'booked', 'missing', 'sold'] },
    { floor: 13, stage: 'launch', statuses: ['available', 'hold', 'booked', 'available'] },
    { floor: 12, stage: 'pre-launch', statuses: ['available', 'available', 'hold', 'booked'] },
    { floor: 11, stage: 'handover', statuses: ['sold', 'sold', 'booked', 'available'] },
];

const buildFloor = (blockId, floorNumber, stage, statuses) => {
    const facings = ['East', 'West', 'North', 'South'];
    return {
        floor: floorNumber,
        units: statuses.slice(0, 4).map((status, idx) => ({
            id: `${blockId}-${floorNumber}-${idx + 1}`,
            label: `${floorNumber}${String(idx + 1).padStart(2, '0')}`,
            status,
            stage,
            facing: facings[idx % facings.length],
            bhk: idx % 2 === 0 ? '2 BHK' : '3 BHK',
            area: idx % 2 === 0 ? 1075 + idx * 20 : 1330 + idx * 25,
            buyer: {},
        })),
    };
};

const buildBlock = (blockId, name, stage, floorsCount, unitsPerFloor, floorProfiles) => ({
    blockId,
    name,
    stage,
    floorsCount,
    unitsPerFloor,
    floors: floorProfiles.map((profile) => buildFloor(blockId, profile.floor, profile.stage, profile.statuses)),
});

export const FALLBACK_MULTI_FLAT_DEFINITIONS = [
    {
        id: 'ID-103CCC',
        code: 'ID-103CCC',
        name: 'Skyline Heights',
        stage: 'launch',
        status: 'active',
        badge: 'Skyline Heights Matrix',
        location: 'Sarjapur Road, Bangalore',
        description: 'Tower A and B units for Skyline Heights are prepped with CRM-ready data.',
        blocks: [
            { blockId: 'A', name: 'Aurora Block', stage: 'launch', floorProfiles: floorProfilesA },
            { blockId: 'B', name: 'Horizon Block', stage: 'pre-launch', floorProfiles: floorProfilesB },
        ],
    },
    {
        id: 'ID-104DDD',
        code: 'ID-104DDD',
        name: 'Tech Park Residences',
        stage: 'pre-launch',
        status: 'active',
        badge: 'Tech Park Residences',
        location: 'Kalyani Nagar, Pune',
        description: 'Modern twin towers with walk-up controls for flats & amenities.',
        blocks: [
            { blockId: 'Alpha', name: 'Alpha Tower', stage: 'launch', floorProfiles: floorProfilesC },
            { blockId: 'Beta', name: 'Beta Tower', stage: 'handover', floorProfiles: floorProfilesD },
        ],
    },
];

export const buildFallbackMultiFlatProject = (definition) => ({
    id: definition.id,
    code: definition.code,
    name: definition.name,
    stage: definition.stage,
    status: definition.status,
    badge: definition.badge,
    location: definition.location,
    description: definition.description,
    blocks: definition.blocks.map((block) =>
        buildBlock(block.blockId, block.name, block.stage, block.floorProfiles),
    ),
});

export const getFallbackMultiFlatProjects = (projectId) => {
    if (projectId) {
        const match = FALLBACK_MULTI_FLAT_DEFINITIONS.find(
            (definition) => String(definition.id) === String(projectId),
        );
        return match ? [buildFallbackMultiFlatProject(match)] : [];
    }
    return FALLBACK_MULTI_FLAT_DEFINITIONS.map(buildFallbackMultiFlatProject);
};

// --- Helpers ---

export const flattenUnits = (projects) => {
    const units = [];
    projects.forEach((project) => {
        project.blocks.forEach((block) => {
            block.floors.forEach((floor) => {
                floor.units.forEach((unit) => {
                    units.push({
                        ...unit,
                        projectId: project.id,
                        projectName: project.name,
                        projectCode: project.code,
                        blockId: block.blockId,
                        blockName: block.name,
                        floorNumber: floor.floor,
                        blockStage: block.stage,
                        projectStage: project.stage,
                    });
                });
            });
        });
    });
    return units;
};

export const matchesSearch = (unit, term) => {
    if (!term) return true;
    const normalized = term.toLowerCase();
    return (
        unit.label.toLowerCase().includes(normalized) ||
        unit.projectName.toLowerCase().includes(normalized) ||
        unit.blockName.toLowerCase().includes(normalized)
    );
};

export const applyFilters = (units, filters) =>
    units.filter((unit) => {
        if (filters.stage !== 'all' && unit.stage !== filters.stage) return false;
        if (filters.status !== 'all' && unit.status !== filters.status) return false;
        if (filters.facing !== 'all' && unit.facing !== filters.facing) return false;
        if (filters.block !== 'all' && unit.blockId !== filters.block) return false;
        if (filters.floor !== 'all' && String(unit.floorNumber) !== String(filters.floor)) return false;
        if (!matchesSearch(unit, filters.search)) return false;
        return true;
    });

export const buildSummary = (units) => {
    const counts = { total: units.length, available: 0, hold: 0, booked: 0, sold: 0, missing: 0 };
    units.forEach((unit) => {
        const status = unit.status;
        if (status && typeof counts[status] === 'number') {
            counts[status] += 1;
        }
    });
    const blockCount = new Set(units.map((unit) => `${unit.projectId}-${unit.blockId}`)).size;
    return { ...counts, blocks: blockCount };
};

export const uniqueValues = (items, selector) => {
    const set = new Set();
    items.forEach((item) => {
        const value = selector(item);
        if (value) set.add(value);
    });
    return Array.from(set);
};

export const stageOptionsFromUnits = (units) => uniqueValues(units, (unit) => unit.stage).sort();
export const facingOptionsFromUnits = (units) => uniqueValues(units, (unit) => unit.facing).sort();
export const floorOptionsFromUnits = (units) =>
    Array.from(new Set(units.map((unit) => unit.floorNumber).filter((floor) => floor != null))).sort((a, b) => a - b);
export const blockOptionsFromProjects = (projects) =>
    Array.from(new Set(projects.flatMap((project) => project.blocks.map((block) => block.blockId)))).sort();

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
    if (filters.block && filters.block !== 'all') query.block = filters.block;
    if (filters.floor && filters.floor !== 'all') query.floor = filters.floor;
    return query;
};

// --- Mappers ---

export const mapProjectGridResponse = (payload) => {
    if (!payload?.project) return null;
    const project = payload.project;
    const blocks = (payload.blocks || []).map((block) => {
        const floorsSource = block.floor_count_data || block.floors || block.levels || [];
        const normalizedFloors = floorsSource
            .map((floorRow) => {
                const unitsSource = floorRow.units || floorRow.flats || [];
                if (!unitsSource.length) return null;
                return {
                    floor: floorRow.floor,
                    units: unitsSource.map((unit, unitIndex) => ({
                        id: unit.id,
                        label: unit.project_unit_label || unit.label || `F${floorRow.floor}-${unitIndex + 1}`,
                        status: (unit.project_unit_status || unit.status || 'available').toLowerCase(),
                        stage: (unit.sale_stage || unit.stage || project.project_status || 'launch').toLowerCase(),
                        facing: unit.project_unit_facing || unit.facing || 'East',
                        bhk: unit.project_unit_bhk_configuration || unit.bhk || '2 BHK',
                        area: unit.project_unit_area_sqft || unit.area || 1100,
                        buyer: {
                            customerName: unit.buyer_customer_name || unit.project_unit_buyer_name || '',
                            channelPartner: unit.buyer_channel_partner_name || '',
                        },
                    })),
                };
            })
            .filter(Boolean);
        if (!normalizedFloors.length) return null;
        return {
            blockId: block.block_id || block.id || block.code || `block-${block.project_block_sequence || 0}`,
            name: block.project_block_name || block.name || block.block_label || `Block ${block.block_id || block.code || ''}`,
            stage: (block.stage || project.project_status || 'launch').toLowerCase(),
            floorsCount: block.project_block_floor_count || normalizedFloors.length,
            unitsPerFloor: block.project_block_units_per_floor || (normalizedFloors[0]?.units?.length ?? 0),
            floors: normalizedFloors,
        };
    }).filter(Boolean);
    if (!blocks.length) return null;
    return [
        {
            id: project.id,
            code: project.project_code,
            name: project.project_name,
            stage: (project.project_status || 'launch').toLowerCase(),
            status: project.project_status || 'active',
            badge: project.project_status || 'Live matrix',
            location: project.project_land_address || '',
            description: project.project_description || '',
            blocks,
        },
    ];
};

export const normalizeMultiFlatPayload = (rawData) => {
    const payload = Array.isArray(rawData) ? rawData : rawData?.results || rawData?.projects || [];
    if (!Array.isArray(payload) || !payload.length) return [];
    return payload.map((project, projectIndex) => {
        const blocksSource = project.blocks || project.towers || [];
        const normalizedBlocks = blocksSource
            .map((block, blockIndex) => {
                const floorsSource = block.floors || block.levels || [];
                const normalizedFloors = floorsSource
                    .map((floor) => {
                        const unitsSource = floor.units || floor.flats || [];
                        const normalizedUnits = unitsSource.map((unit, unitIndex) => ({
                            id: unit.unit_id || unit.id || `${projectIndex}-${blockIndex}-${unitIndex}`,
                            label: unit.unit_label || unit.name || `U-${unitIndex + 1}`,
                            status: (unit.status || 'available').toLowerCase(),
                            stage: (unit.stage || project.stage || 'launch').toLowerCase(),
                            facing: unit.facing || 'East',
                            bhk: unit.bhk || unit.flat_type || '2 BHK',
                            area: unit.area_sqft || unit.area || 1100,
                            buyer: unit.buyer || {},
                        }));
                        if (!normalizedUnits.length) return null;
                        return {
                            floor: floor.floor || floor.level || 0,
                            units: normalizedUnits,
                        };
                    })
                    .filter(Boolean);
                if (!normalizedFloors.length) return null;
                return {
                    blockId: block.block_id || block.code || `BLK-${blockIndex + 1}`,
                    name: block.name || block.block_label || `Block ${blockIndex + 1}`,
                    stage: block.stage || project.stage || 'launch',
                    floorsCount: block.floor_count || block.floorsCount || normalizedFloors.length,
                    unitsPerFloor: block.units_per_floor || 4,
                    floors: normalizedFloors,
                };
            })
            .filter(Boolean);
        if (!normalizedBlocks.length) return null;
        return {
            id: project.id || project.project_id || `project-${projectIndex}`,
            code: project.code || project.project_code || `MF-${projectIndex}`,
            name: project.name || project.project_name || 'Unnamed project',
            stage: (project.stage || 'launch').toLowerCase(),
            status: project.status || project.project_status || 'active',
            badge: project.badge || 'Sales matrix',
            location: project.location || project.land_address || 'Location pending',
            description: project.description || project.summary || '',
            blocks: normalizedBlocks,
        };
    }).filter(Boolean);
};

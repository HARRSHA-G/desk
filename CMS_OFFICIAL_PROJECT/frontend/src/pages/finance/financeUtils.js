export const projectsData = [
    { id: 'p1', name: 'Zenith Tower', type: 'flat' },
    { id: 'p2', name: 'Garden Enclave', type: 'flat' },
    { id: 'p3', name: 'Phoenix Villas', type: 'plot' },
];

export const flatUnitsData = {
    p1: {
        blocks: [
            { id: 'A', name: 'Block A', floors: [{ id: 'F15', name: '15', units: [{ id: '1501', name: '1501' }, { id: '1502', name: '1502' }] }] },
            { id: 'B', name: 'Block B', floors: [{ id: 'F10', name: '10', units: [{ id: '1001', name: '1001' }] }] },
        ],
    },
    p2: {
        blocks: [{ id: 'C', name: 'Block C', floors: [{ id: 'F5', name: '5', units: [{ id: '501', name: '501' }] }] }],
    },
};

export const plotUnitsData = {
    p3: [
        { id: 'PL-01', name: 'Plot 01' },
        { id: 'PL-02', name: 'Plot 02' },
    ],
};

export const formatDisplayDate = (iso) => {
    if (!iso) return '-';
    const [y, m, d] = iso.split('-');
    return `${d}/${m}/${y}`;
};

export const getCategoryLabel = (cat) => {
    if (cat === 'project') return 'Project Payment';
    if (cat === 'flat') return 'Flat Payment';
    if (cat === 'plot') return 'Plot Payment';
    return '';
};

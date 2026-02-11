export const HEALTH_COLOR = {
    Platinum: 'success',
    Gold: 'warning',
    Silver: 'neutral',
};

export const MOCK_PARTNERS = [
    {
        id: 'P-101',
        name: 'Skyline Realty',
        contact: 'Ananya Rao',
        phone: '+91 98111 22334',
        email: 'hello@skyline.com',
        deals: 12,
        volume: '6.5 Cr',
        health: 'Platinum',
    },
    {
        id: 'P-102',
        name: 'Vertex Associates',
        contact: 'Rahul Jain',
        phone: '+91 98770 11223',
        email: 'rahul@vertex.in',
        deals: 8,
        volume: '3.1 Cr',
        health: 'Gold',
    },
    {
        id: 'P-103',
        name: 'Aurora Estates',
        contact: 'Pooja Kulkarni',
        phone: '+91 98002 44321',
        email: 'pooja@aurora.com',
        deals: 5,
        volume: '2.4 Cr',
        health: 'Silver',
    },
];

export const INITIAL_PARTNER_FORM = {
    name: '',
    contact: '',
    phone: '',
    email: '',
    ifsc: '',
    account: '',
    nominee: '',
    kycId: '',
    declaration: '',
};

export const normalizePartnerPayload = (data) => {
    const list = Array.isArray(data) ? data : data?.results || [];
    return list.map((p, idx) => ({
        id: p.id || p.partner_id || `P-${idx + 200}`,
        name: p.name || p.company_name || 'Partner',
        contact: p.contact || p.contact_person || '-',
        phone: p.phone || p.mobile || '-',
        email: p.email || '-',
        deals: p.deals || p.total_deals || 0,
        volume: p.volume || p.revenue || 'N/A',
        health: p.health || 'Gold',
    }));
};

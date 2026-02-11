import { z } from 'zod';

export const customerSchema = z.object({
    name: z.string().min(3, 'Name must be at least 3 characters'),
    phone: z.string().min(10, 'Phone must be at least 10 digits'),
    email: z.string().email('Invalid email address'),
    type: z.string().default('project'),
    interest: z.string().optional(),
    budget: z.string().optional(),
    status: z.string().default('New'),
    bundle: z.string().optional(),
    leadSource: z.string().default('Web Form'),
});

export const TAB_CONFIG = [
    { value: 'project', label: 'Project' },
    { value: 'flat', label: 'Flat' },
    { value: 'plot', label: 'Plot' },
];

export const statusColor = {
    Hot: 'success',
    Warm: 'warning',
    New: 'neutral',
};

export const panelSx = {
    bgcolor: 'background.surface',
    border: '1px solid',
    borderColor: 'divider',
    backdropFilter: 'blur(12px)',
    boxShadow: 'md',
    borderRadius: '16px',
};

export const mockCustomers = [
    {
        id: 'C-001',
        name: 'Riya Sen',
        phone: '+91 98765 43210',
        email: 'riya.sen@email.com',
        type: 'project',
        interest: 'Premium Villa',
        budget: '1.2 Cr',
        status: 'Hot',
        bundle: ['Lead: Bangalore Expo', 'Lead: Web Form'],
    },
    {
        id: 'C-002',
        name: 'Arjun Mehta',
        phone: '+91 99887 66554',
        email: 'arjun.m@email.com',
        type: 'flat',
        interest: 'Tower B - 12th Floor',
        budget: '85 Lakh',
        status: 'Warm',
        bundle: ['Referral - Manoj', 'Lead: Walk-in'],
    },
    {
        id: 'C-003',
        name: 'Sara Iqbal',
        phone: '+91 90123 77889',
        email: 'sara.i@email.com',
        type: 'plot',
        interest: 'East facing, 40x60',
        budget: '70 Lakh',
        status: 'New',
        bundle: ['Portal - 99acres'],
    },
    {
        id: 'C-004',
        name: 'Kunal Shah',
        phone: '+91 90909 22334',
        email: 'kunal.shah@email.com',
        type: 'flat',
        interest: 'Tower C - 8th Floor',
        budget: '78 Lakh',
        status: 'Hot',
        bundle: ['Lead: Social Ads', 'Lead: Site Visit'],
    },
];

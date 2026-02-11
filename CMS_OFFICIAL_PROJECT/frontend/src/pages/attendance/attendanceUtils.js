export const CHART_DATA = {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    datasets: [
        {
            label: 'Present',
            data: [12, 19, 15, 17, 14, 10, 5],
            backgroundColor: 'rgba(34, 181, 191, 0.6)',
        },
        {
            label: 'Absent',
            data: [2, 1, 3, 0, 2, 5, 15],
            backgroundColor: 'rgba(239, 68, 68, 0.6)',
        },
    ],
};

export const CHART_OPTIONS = {
    maintainAspectRatio: false,
    plugins: {
        legend: {
            position: 'bottom',
        },
    },
};

export const INITIAL_STATS = {
    total_today: 0,
    present_today: 0,
    remote_today: 0,
    on_leave_today: 0,
};

export const INITIAL_MARK_DATA = {
    checkIn: '',
    checkOut: '',
    mode: 'onsite',
    notes: '',
};

export const normalizeBatches = (data) => {
    if (Array.isArray(data)) return data;
    if (data?.results) return data.results;
    return [];
};

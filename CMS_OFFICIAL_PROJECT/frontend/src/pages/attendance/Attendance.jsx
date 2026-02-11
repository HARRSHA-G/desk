import React, { useState } from 'react';
import {
    Box,
    Typography,
    Tabs,
    TabList,
    Tab,
    TabPanel,
    CircularProgress,
} from '@mui/joy';
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend,
    ArcElement
} from 'chart.js';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import api from '../../api';

import {
    INITIAL_STATS,
    INITIAL_MARK_DATA,
    normalizeBatches,
} from './attendanceUtils';

import AttendanceDashboard from '../../components/attendance/AttendanceDashboard';
import AttendanceBatches from '../../components/attendance/AttendanceBatches';
import MarkAttendance from '../../components/attendance/MarkAttendance';

ChartJS.register(
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend,
    ArcElement
);

const Attendance = () => {
    const queryClient = useQueryClient();
    const [activeTab, setActiveTab] = useState(0);

    const [selectedBatchId, setSelectedBatchId] = useState('');
    const [batchMembers, setBatchMembers] = useState([]);
    const [markData, setMarkData] = useState(INITIAL_MARK_DATA);
    const [selectedMembers, setSelectedMembers] = useState({});

    // Queries
    const { data: stats = INITIAL_STATS, isLoading: statsLoading } = useQuery({
        queryKey: ['attendance', 'stats'],
        queryFn: async () => {
            const response = await api.get('/attendance/stats/');
            return response.data || INITIAL_STATS;
        },
    });

    const { data: batches = [] } = useQuery({
        queryKey: ['attendance', 'batches'],
        queryFn: async () => {
            const response = await api.get('/attendance/batches/');
            return normalizeBatches(response.data);
        },
    });

    // Load Batch Members mutation/query mix
    // Here we use state for simplicity since it's transient UI state for selection
    const loadBatchMembers = async (batchId) => {
        if (!batchId) return;
        try {
            const response = await api.get(`/attendance/batches/${batchId}/members/`);
            const members = Array.isArray(response.data) ? response.data : [];
            setBatchMembers(members);
            const initialSelection = {};
            members.forEach((m) => (initialSelection[m.id] = true));
            setSelectedMembers(initialSelection);
        } catch (error) {
            toast.error('Failed to load members');
        }
    };

    const handleMemberToggle = (id) => {
        setSelectedMembers((prev) => ({ ...prev, [id]: !prev[id] }));
    };

    const markMutation = useMutation({
        mutationFn: async () => {
            const payload = {
                batch_id: selectedBatchId,
                ...markData,
                member_ids: Object.keys(selectedMembers).filter((id) => selectedMembers[id]),
            };
            return api.post('/attendance/mark/', payload);
        },
        onSuccess: () => {
            toast.success('Attendance marked successfully!');
            queryClient.invalidateQueries(['attendance', 'stats']);
        },
        onError: () => {
            toast.error('Failed to mark attendance.');
        },
    });

    if (statsLoading && activeTab === 0) {
        return (
            <Box sx={{ display: 'flex', justifyContent: 'center', p: 5 }}>
                <CircularProgress />
            </Box>
        );
    }

    return (
        <Box sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 } }}>
            <Box sx={{ mb: 3 }}>
                <Typography level="h2">Attendance</Typography>
                <Typography level="body-md" color="neutral">
                    Track daily presence, batches, and trends.
                </Typography>
            </Box>

            <Tabs
                value={activeTab}
                onChange={(e, val) => setActiveTab(val)}
                sx={{ bgcolor: 'transparent', mb: 3 }}
            >
                <TabList sx={{ p: 0.5, gap: 0.5, borderRadius: 'md', bgcolor: 'background.level1' }}>
                    <Tab value={0} sx={{ borderRadius: 'sm' }}>Dashboard</Tab>
                    <Tab value={1} sx={{ borderRadius: 'sm' }}>Batches</Tab>
                    <Tab value={2} sx={{ borderRadius: 'sm' }}>Mark Attendance</Tab>
                </TabList>

                <TabPanel value={0} sx={{ p: 0, bgcolor: 'transparent' }}>
                    <AttendanceDashboard stats={stats} />
                </TabPanel>

                <TabPanel value={1} sx={{ p: 0, bgcolor: 'transparent' }}>
                    <AttendanceBatches batches={batches} />
                </TabPanel>

                <TabPanel value={2} sx={{ p: 0, bgcolor: 'transparent' }}>
                    <MarkAttendance
                        batches={batches}
                        selectedBatchId={selectedBatchId}
                        setSelectedBatchId={setSelectedBatchId}
                        batchMembers={batchMembers}
                        loadBatchMembers={loadBatchMembers}
                        markData={markData}
                        onMarkDataChange={setMarkData}
                        selectedMembers={selectedMembers}
                        onMemberToggle={handleMemberToggle}
                        onSubmit={() => markMutation.mutate()}
                        loading={markMutation.isLoading}
                    />
                </TabPanel>
            </Tabs>
        </Box>
    );
};

export default Attendance;

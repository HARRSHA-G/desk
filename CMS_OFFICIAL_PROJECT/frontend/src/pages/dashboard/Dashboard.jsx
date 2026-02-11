import React, { useEffect, useState } from 'react';
import { Box, Typography, Sheet, Button, Grid, Alert } from '@mui/joy';
import api from '../../api';
import PageHeader from '../../components/PageHeader';

import DashboardSkeleton from '../../components/dashboard/DashboardSkeleton';
import StatusCard from '../../components/dashboard/StatusCard';
import DashboardProjectTable from '../../components/dashboard/DashboardProjectTable';

import {
    STATUS_CONFIG,
    normalizeProjectData,
    calculateStats
} from './dashboardUtils';

const Dashboard = () => {
    const [projects, setProjects] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [stats, setStats] = useState({ planning: 0, active: 0, completed: 0, on_hold: 0, cancelled: 0 });

    const [selectedStatus, setSelectedStatus] = useState(null);
    const [selectedLayout, setSelectedLayout] = useState('all');
    const [sortBudgetDesc, setSortBudgetDesc] = useState(false);

    useEffect(() => {
        const fetchProjects = async () => {
            try {
                const response = await api.get('/projects/');
                const data = Array.isArray(response.data) ? response.data : (response.data.results || response.data);
                const processed = normalizeProjectData(data);

                setProjects(processed);
                setStats(calculateStats(processed));

            } catch (err) {
                console.error("Failed to fetch dashboard data", err);
                setError('Failed to load project data. Please verify your connection.');
            } finally {
                setLoading(false);
            }
        };

        fetchProjects();
    }, []);

    // Filter Logic
    const filteredProjects = projects.filter(p => {
        if (selectedStatus && p.status !== selectedStatus) {
            if (selectedStatus === 'active' && p.status === 'in progress') return true;
            return false;
        }
        if (selectedLayout !== 'all') {
            if (selectedLayout === 'single_flat' && !p.layoutKey.includes('single')) return false;
            if (selectedLayout === 'multi_flat' && !p.layoutKey.includes('multi_flat')) return false;
            if (selectedLayout === 'multi_plot' && !p.layoutKey.includes('multi_plot')) return false;
        }
        return true;
    }).sort((a, b) => {
        if (sortBudgetDesc) return b.budget - a.budget;
        return 0;
    });

    if (loading) {
        return <DashboardSkeleton />;
    }

    if (error) {
        return (
            <Box sx={{ p: 3 }}>
                <Alert color="danger" variant="soft">{error}</Alert>
            </Box>
        );
    }

    return (
        <Box component="main" sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 } }}>
            <PageHeader title="Dashboard" />
            <Box component="header">
                <Box sx={{ mb: 4 }}>
                    <Typography level="h2" component="h1" sx={{ mb: 1, color: 'text.primary' }}>
                        Dashboard
                    </Typography>
                    <Typography level="body-md" sx={{ color: 'text.secondary' }}>
                        Overview of all construction projects.
                    </Typography>
                </Box>
            </Box>

            <Sheet
                variant="outlined"
                sx={{
                    p: 2,
                    mb: 3,
                    borderRadius: 'lg',
                    display: 'flex',
                    flexWrap: 'wrap',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    gap: 2,
                    bgcolor: 'background.surface',
                }}
            >
                <Typography fontWeight="lg">
                    Total Projects: <Typography color="primary">{projects.length}</Typography>
                </Typography>

                <Box sx={{ display: 'flex', gap: 1 }}>
                    {selectedStatus && (
                        <Button
                            variant="soft"
                            color="neutral"
                            size="sm"
                            onClick={() => setSelectedStatus(null)}
                            startDecorator={<i className="ri-close-line"></i>}
                        >
                            Clear Filter
                        </Button>
                    )}
                </Box>
            </Sheet>

            <Grid component="section" container spacing={2} sx={{ mb: 4 }} aria-label="Project Status Summary">
                {Object.keys(STATUS_CONFIG).map((key) => {
                    const config = STATUS_CONFIG[key];
                    return (
                        <Grid key={key} xs={12} sm={6} md={4} lg={2.4}>
                            <StatusCard
                                {...config}
                                count={stats[key] || 0}
                                selected={selectedStatus === key}
                                onClick={() => setSelectedStatus(selectedStatus === key ? null : key)}
                            />
                        </Grid>
                    );
                })}
            </Grid>

            {/* Projects Table */}
            <DashboardProjectTable
                selectedStatus={selectedStatus}
                selectedLayout={selectedLayout}
                setSelectedLayout={setSelectedLayout}
                sortBudgetDesc={sortBudgetDesc}
                setSortBudgetDesc={setSortBudgetDesc}
                filteredProjects={filteredProjects}
            />
        </Box>
    );
};

export default Dashboard;

import React from 'react';
import Box from '@mui/joy/Box';
import Grid from '@mui/joy/Grid';

const DashboardSkeleton = () => (
    <Box sx={{ p: { xs: 2, md: 3 } }}>
        <Box sx={{ mb: 4, display: 'flex', flexDirection: 'column', gap: 1 }}>
            <Box className="skeleton" sx={{ width: 250, height: 40 }} />
            <Box className="skeleton" sx={{ width: 180, height: 20 }} />
        </Box>
        <Grid container spacing={2} sx={{ mb: 4 }}>
            {[1, 2, 3, 4, 5].map((i) => (
                <Grid key={i} xs={12} sm={6} md={4} lg={2.4}>
                    <Box className="skeleton" sx={{ height: 120, borderRadius: '20px' }} />
                </Grid>
            ))}
        </Grid>
        <Box className="skeleton" sx={{ height: 400, borderRadius: '16px' }} />
    </Box>
);

export default DashboardSkeleton;

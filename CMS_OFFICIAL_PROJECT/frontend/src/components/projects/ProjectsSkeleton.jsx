import React from 'react';
import { Box, Grid } from '@mui/joy';

const ProjectsSkeleton = () => (
    <Box sx={{ p: { xs: 2, md: 3 } }}>
        <Box sx={{ mb: 4, display: 'flex', justifyContent: 'space-between' }}>
            <Box className="skeleton" sx={{ width: 300, height: 40 }} />
            <Box className="skeleton" sx={{ width: 140, height: 44, borderRadius: '12px' }} />
        </Box>
        <Box className="skeleton" sx={{ mb: 3, height: 100, borderRadius: '16px' }} />
        <Grid container spacing={2}>
            {[1, 2, 3, 4, 5, 6, 7, 8].map((i) => (
                <Grid key={i} xs={12} sm={6} lg={3}>
                    <Box className="skeleton" sx={{ height: 280, borderRadius: '18px' }} />
                </Grid>
            ))}
        </Grid>
    </Box>
);

export default ProjectsSkeleton;

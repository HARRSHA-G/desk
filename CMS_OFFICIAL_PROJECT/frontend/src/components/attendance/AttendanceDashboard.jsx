import React from 'react';
import { Box, Card, Grid, Typography } from '@mui/joy';
import { Bar } from 'react-chartjs-2';
import { CHART_DATA, CHART_OPTIONS } from '../../pages/attendance/attendanceUtils';

const AttendanceDashboard = ({ stats }) => {
    return (
        <Box sx={{ p: 0, bgcolor: 'transparent' }}>
            <Grid container spacing={2} sx={{ mb: 3, pt: 2 }}>
                <Grid xs={12} sm={6} md={3}>
                    <Card variant="outlined">
                        <Typography level="body-sm">Logged Today</Typography>
                        <Typography level="h2">{stats.total_today}</Typography>
                        <Typography level="body-xs" color="neutral">
                            Total entries
                        </Typography>
                    </Card>
                </Grid>
                <Grid xs={12} sm={6} md={3}>
                    <Card variant="outlined">
                        <Typography level="body-sm">Present</Typography>
                        <Typography level="h2" color="success">
                            {stats.present_today}
                        </Typography>
                        <Typography level="body-xs" color="neutral">
                            On-site check-ins
                        </Typography>
                    </Card>
                </Grid>
                <Grid xs={12} sm={6} md={3}>
                    <Card variant="outlined">
                        <Typography level="body-sm">Remote</Typography>
                        <Typography level="h2" color="primary">
                            {stats.remote_today}
                        </Typography>
                        <Typography level="body-xs" color="neutral">
                            Working offsite
                        </Typography>
                    </Card>
                </Grid>
                <Grid xs={12} sm={6} md={3}>
                    <Card variant="outlined">
                        <Typography level="body-sm">On Leave</Typography>
                        <Typography level="h2" color="warning">
                            {stats.on_leave_today}
                        </Typography>
                        <Typography level="body-xs" color="neutral">
                            Planned/Unplanned
                        </Typography>
                    </Card>
                </Grid>
            </Grid>

            <Card variant="outlined">
                <Typography level="title-lg" sx={{ mb: 2 }}>
                    Attendance Trends
                </Typography>
                <Box sx={{ height: 300, width: '100%' }}>
                    <Bar data={CHART_DATA} options={CHART_OPTIONS} />
                </Box>
            </Card>
        </Box>
    );
};

export default AttendanceDashboard;

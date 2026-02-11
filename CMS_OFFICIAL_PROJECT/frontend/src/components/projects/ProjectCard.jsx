import React from 'react';
import { Card, Box, Typography, Chip } from '@mui/joy';

const statusColor = (status) => {
    switch ((status || '').toLowerCase()) {
        case 'active':
            return 'warning';
        case 'completed':
            return 'success';
        case 'cancelled':
            return 'danger';
        case 'planning':
            return 'primary';
        case 'on_hold':
        case 'on hold':
            return 'info';
        default:
            return 'neutral';
    }
};

const formatCurrency = (val) =>
    new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(
        Number(val || 0),
    );

const InfoRow = ({ icon, label }) => (
    <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75 }}>
        <i className={icon} style={{ fontSize: '1rem', opacity: 0.8 }}></i>
        <Typography level="body-sm">{label}</Typography>
    </Box>
);

const ProjectCard = ({ project, onClick }) => {
    const permissionMap = project.permissionMap || {};
    const permDone = Object.values(permissionMap).filter(
        (v) => (v || '').toString().toLowerCase() === 'completed',
    ).length;
    const permTotal = Object.keys(permissionMap).length || 10;
    const area = project.landArea ? Number(project.landArea) : null;
    const isMultiUnitProject = (project.layoutKey || project.layout || '').includes('multi');

    return (
        <Card
            variant="outlined"
            role={onClick ? 'button' : undefined}
            onClick={() => onClick?.(project)}
            sx={{
                height: '100%',
                display: 'flex',
                flexDirection: 'column',
                gap: 1,
                borderRadius: '18px',
                cursor: onClick ? 'pointer' : 'default',
                transition: 'transform 0.2s, box-shadow 0.2s',
                '&:hover': {
                    transform: onClick ? 'translateY(-4px)' : undefined,
                    boxShadow: onClick ? 'md' : undefined,
                    borderColor: 'primary.outlinedBorder',
                },
            }}
        >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 1 }}>
                <Typography level="body-sm" fontWeight="lg" sx={{ letterSpacing: 0.4 }}>
                    ID: {project.code}
                </Typography>
                <Chip size="sm" variant="soft" color="primary" sx={{ textTransform: 'uppercase' }}>
                    {project.layout || project.layoutKey || 'Project'}
                </Chip>
            </Box>

            <Typography level="title-lg" sx={{ mb: 0.5 }}>
                {project.name}
            </Typography>

            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.35, color: 'text.secondary' }}>
                <InfoRow icon="ri-ruler-2-line" label={area ? `Area ${area.toLocaleString('en-IN')} sq ft` : 'Area not set'} />
                <InfoRow icon="ri-community-line" label={`Type ${project.constructionType || 'N/A'}`} />
                <InfoRow icon="ri-time-line" label={`Duration ${project.duration || '-'} M`} />
                <InfoRow icon="ri-shield-check-line" label={`Permissions ${permDone}/${permTotal}`} />
                {isMultiUnitProject ? (
                    <InfoRow icon="ri-building-line" label="Customer & supervisor managed via CRM and supervisor Page" />
                ) : (
                    <>
                        <InfoRow icon="ri-user-2-line" label={`Supervisor ${project.supervisor || 'Not assigned'}`} />
                        <InfoRow icon="ri-user-heart-line" label={`Customer ${project.customer || 'Not assigned'}`} />
                    </>
                )}
                <InfoRow icon="ri-money-rupee-circle-line" label={`Budget ${formatCurrency(project.budget || 0)}`} />
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                    <i className="ri-checkbox-blank-circle-line" style={{ fontSize: '0.95rem', opacity: 0.7 }}></i>
                    <Chip size="sm" variant="soft" color={statusColor(project.status)}>
                        {project.status}
                    </Chip>
                </Box>
            </Box>

            {!isMultiUnitProject && (
                <Box
                    sx={{
                        mt: 1,
                        pt: 1,
                        borderTop: '1px solid',
                        borderColor: 'divider',
                        display: 'flex',
                        justifyContent: 'space-between',
                    }}
                >
                    <Typography level="body-sm" color="success">
                        Paid: {formatCurrency(project.paid || 0)}
                    </Typography>
                    <Typography level="body-sm" color="danger">
                        Due: {formatCurrency(project.remaining || 0)}
                    </Typography>
                </Box>
            )}

            <InfoRow icon="ri-map-pin-line" label={`Location ${project.landAddress || 'Not set'}`} />
        </Card>
    );
};

export default ProjectCard;

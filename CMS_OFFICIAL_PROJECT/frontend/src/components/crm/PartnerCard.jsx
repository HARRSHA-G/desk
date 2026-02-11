import React from 'react';
import { Box, Card, Chip, Divider, Typography } from '@mui/joy';
import { HEALTH_COLOR } from '../../pages/crm/channelPartnerUtils';

const panelSx = {
    bgcolor: 'background.surface',
    border: '1px solid',
    borderColor: 'divider',
    backdropFilter: 'blur(12px)',
    boxShadow: 'md',
    borderRadius: '16px',
};

const PartnerCard = ({ partner }) => {
    return (
        <Card
            sx={{
                ...panelSx,
                height: '100%',
                display: 'flex',
                flexDirection: 'column',
                gap: 1.5,
                transition: 'transform 0.2s ease, box-shadow 0.2s ease',
                '&:hover': {
                    transform: 'translateY(-4px)',
                    boxShadow: 'lg',
                    borderColor: 'primary.500',
                },
            }}
        >
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                <Box>
                    <Typography level="title-lg">{partner.name}</Typography>
                    <Typography level="body-sm" color="neutral">
                        {partner.contact}
                    </Typography>
                </Box>
                <Chip variant="soft" size="sm" color={HEALTH_COLOR[partner.health] || 'neutral'}>
                    {partner.health}
                </Chip>
            </Box>

            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5 }}>
                <Typography level="body-sm" startDecorator={<i className="ri-smartphone-line" />}>
                    {partner.phone}
                </Typography>
                <Typography level="body-sm" startDecorator={<i className="ri-mail-line" />}>
                    {partner.email}
                </Typography>
            </Box>

            <Divider sx={{ borderColor: 'divider' }} />

            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <Box>
                    <Typography level="body-xs" sx={{ opacity: 0.7 }}>
                        Deals Closed
                    </Typography>
                    <Typography level="title-md">{partner.deals}</Typography>
                </Box>
                <Box>
                    <Typography level="body-xs" sx={{ opacity: 0.7 }}>
                        Volume
                    </Typography>
                    <Typography level="title-md" color="primary">
                        {partner.volume}
                    </Typography>
                </Box>
            </Box>
        </Card>
    );
};

export default PartnerCard;

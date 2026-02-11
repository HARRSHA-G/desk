import React from 'react';
import { Box, Card, Chip, Typography, Stack } from '@mui/joy';
import { statusColor, panelSx } from '../../pages/crm/customerUtils';

const CustomerCard = ({ customer }) => {
    return (
        <Card
            sx={{
                ...panelSx,
                height: '100%',
                borderColor: 'divider',
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
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 1 }}>
                <Box>
                    <Typography level="title-lg">{customer.name}</Typography>
                    <Typography level="body-sm" color="neutral">{customer.email}</Typography>
                </Box>
                <Chip variant="soft" color={statusColor[customer.status] || 'neutral'} size="sm">
                    {customer.status}
                </Chip>
            </Box>

            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5 }}>
                <Typography level="body-sm" startDecorator={<i className="ri-smartphone-line" />}>
                    {customer.phone}
                </Typography>
                <Typography level="body-sm" startDecorator={<i className="ri-focus-2-line" />}>
                    {customer.interest}
                </Typography>
                <Typography level="body-sm" startDecorator={<i className="ri-money-rupee-circle-line" />}>
                    Budget: {customer.budget}
                </Typography>
            </Box>

            <Box>
                <Typography level="body-xs" sx={{ opacity: 0.7, mb: 0.5 }}>
                    Bundle (Leads)
                </Typography>
                <Stack direction="row" spacing={0.5} flexWrap="wrap" useFlexGap>
                    {(customer.bundle || []).map((b) => (
                        <Chip key={b} size="sm" variant="soft" color="primary">
                            {b}
                        </Chip>
                    ))}
                    {(customer.bundle || []).length === 0 && (
                        <Typography level="body-xs" color="neutral">
                            No bundle attached
                        </Typography>
                    )}
                </Stack>
            </Box>
        </Card>
    );
};

export default CustomerCard;

import React from 'react';
import Card from '@mui/joy/Card';
import Box from '@mui/joy/Box';
import Typography from '@mui/joy/Typography';

const StatusCard = ({ label, count, icon, color, selected, onClick }) => (
    <Card
        variant={selected ? 'soft' : 'outlined'}
        color={selected ? color : 'neutral'}
        onClick={onClick}
        sx={{
            cursor: 'pointer',
            boxShadow: 'none',
            transition: '0.2s',
            '&:hover': {
                bgcolor: 'background.level1',
                borderColor: `${color}.500 !important`,
                transform: 'translateY(-2px)',
            },
            ...(selected && {
                borderColor: `${color}.500`,
                boxShadow: 'sm',
            })
        }}
    >
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
            <Box>
                <Typography level="body-xs" fontWeight="lg" textTransform="uppercase" sx={{ opacity: 0.7, mb: 0.5 }}>
                    {label}
                </Typography>
                <Typography level="h3" fontWeight="xl">
                    {count}
                </Typography>
            </Box>
            <Box
                sx={{
                    width: 36,
                    height: 36,
                    borderRadius: 'md',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    bgcolor: selected ? `${color}.softBg` : 'background.surface',
                    color: selected ? `${color}.plainColor` : 'text.secondary',
                    fontSize: '1.2rem',
                    border: '1px solid',
                    borderColor: 'divider',
                }}
            >
                <i className={icon}></i>
            </Box>
        </Box>
        <Typography level="body-xs" sx={{ mt: 1, color: 'text.tertiary' }}>
            Projects in {label.toLowerCase()} stage
        </Typography>
    </Card>
);

export default StatusCard;

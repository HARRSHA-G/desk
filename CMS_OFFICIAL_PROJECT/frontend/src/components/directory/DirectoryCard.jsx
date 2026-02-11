import React from 'react';
import { Box, Card, Chip, IconButton, Typography } from '@mui/joy';

const DirectoryCard = ({ person, type, onEdit, onDelete }) => (
    <Card
        variant="outlined"
        sx={{
            height: '100%',
            transition: 'transform 0.2s, border-color 0.2s',
            '&:hover': {
                transform: 'translateY(-4px)',
                borderColor: 'primary.outlinedBorder',
                boxShadow: 'md',
            },
        }}
    >
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', mb: 1 }}>
            <Typography level="title-lg">{person.name || person.company_name}</Typography>
            <Chip size="sm" variant="soft" color="primary">
                {person.code || 'N/A'}
            </Chip>
        </Box>

        {type === 'vendor' && person.first_name && (
            <Typography level="body-sm" color="neutral" sx={{ mb: 1 }}>
                Contact: {person.first_name} {person.last_name}
            </Typography>
        )}

        <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5, mb: 2 }}>
            {person.email && (
                <Typography level="body-xs" startDecorator={<i className="ri-mail-line"></i>}>
                    {person.email}
                </Typography>
            )}
            {person.primary_phone_number && (
                <Typography level="body-xs" startDecorator={<i className="ri-phone-line"></i>}>
                    {person.primary_phone_number}
                </Typography>
            )}
        </Box>

        <Box sx={{ mt: 'auto', display: 'flex', justifyContent: 'flex-end', gap: 1 }}>
            <IconButton size="sm" variant="plain" color="primary" onClick={() => onEdit(person)}>
                <i className="ri-edit-2-line"></i>
            </IconButton>
            <IconButton size="sm" variant="plain" color="danger" onClick={() => onDelete(person.id)}>
                <i className="ri-delete-bin-line"></i>
            </IconButton>
        </Box>
    </Card>
);

export default DirectoryCard;

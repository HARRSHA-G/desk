import React from 'react';
import { Box, Button, Card, Chip, Grid, Typography } from '@mui/joy';

const AttendanceBatches = ({ batches }) => {
    return (
        <Box sx={{ py: 2 }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                <Typography level="title-lg">Managed Batches</Typography>
                <Button size="sm" startDecorator={<i className="ri-add-line" />}>
                    Add Batch
                </Button>
            </Box>

            <Grid container spacing={2}>
                {batches.length > 0 ? (
                    batches.map((batch) => (
                        <Grid key={batch.id} xs={12} sm={6} md={4}>
                            <Card
                                variant="outlined"
                                sx={{ cursor: 'pointer', '&:hover': { borderColor: 'primary.500' } }}
                            >
                                <Typography level="title-md">{batch.name}</Typography>
                                <Typography level="body-sm">{batch.description || 'No description'}</Typography>
                                <Chip size="sm" variant="soft" sx={{ mt: 1 }}>
                                    {batch.member_count || 0} Members
                                </Chip>
                            </Card>
                        </Grid>
                    ))
                ) : (
                    <Box sx={{ p: 3, width: '100%', textAlign: 'center' }}>
                        <Typography color="neutral">No batches found.</Typography>
                    </Box>
                )}
            </Grid>
        </Box>
    );
};

export default AttendanceBatches;

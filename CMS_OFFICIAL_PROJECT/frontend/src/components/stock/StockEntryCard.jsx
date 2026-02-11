import React from 'react';
import { Card, Stack, Typography, Grid, FormControl, FormLabel, Input } from '@mui/joy';
import { formatCurrency } from '../../pages/stock/stockUtils';

const StockEntryCard = ({ entry, onStockChange }) => {
    return (
        <Card variant="outlined" sx={{ borderRadius: 'lg' }}>
            <Stack spacing={1}>
                <Typography level="body-lg" fontWeight="md">
                    {entry.name}
                </Typography>
                <Grid container spacing={2} alignItems="flex-end">
                    <Grid xs={12} md={4}>
                        <FormControl>
                            <FormLabel>Allocated (Total)</FormLabel>
                            <Input
                                type="number"
                                value={entry.total}
                                onChange={(e) => onStockChange(entry.id, 'total', e.target.value)}
                                endDecorator={<Typography level="body-xs">units</Typography>}
                            />
                        </FormControl>
                    </Grid>
                    <Grid xs={12} md={4}>
                        <FormControl>
                            <FormLabel>Used</FormLabel>
                            <Input
                                type="number"
                                value={entry.used}
                                onChange={(e) => onStockChange(entry.id, 'used', e.target.value)}
                                endDecorator={<Typography level="body-xs">units</Typography>}
                            />
                        </FormControl>
                    </Grid>
                    <Grid xs={12} md={4}>
                        <Typography level="body-xs" color="neutral" sx={{ mb: 0.5 }}>
                            Remaining
                        </Typography>
                        <Typography level="title-md">
                            {formatCurrency(Math.max(0, entry.total - (entry.used || 0)))}
                        </Typography>
                    </Grid>
                </Grid>
            </Stack>
        </Card>
    );
};

export default StockEntryCard;

import React from 'react';
import { Box, Chip } from '@mui/joy';

const statusMeta = {
    available: { label: 'Available', color: 'success' },
    booked: { label: 'Booked', color: 'warning' },
    sold: { label: 'Sold', color: 'primary' },
    hold: { label: 'On Hold', color: 'neutral' },
};

const renderStatusChip = (status) => {
    const key = String(status || 'available').toLowerCase();
    const meta = statusMeta[key] || {
        label: status || 'Unknown',
        color: 'neutral',
    };
    return (
        <Chip variant="soft" color={meta.color} size="sm" sx={{ fontWeight: 600 }}>
            {meta.label}
        </Chip>
    );
};

const CRMTable = ({ records, loading, errorMessage }) => {
    if (loading) {
        return (
            <Box sx={{ py: 6, textAlign: 'center' }}>
                Loading...
            </Box>
        );
    }

    if (errorMessage) {
        return (
            <Box sx={{ py: 6, textAlign: 'center' }}>
                {errorMessage}
            </Box>
        );
    }

    if (records.length === 0) {
        return (
            <Box sx={{ py: 6, textAlign: 'center' }}>
                No matching records.
            </Box>
        );
    }

    return (
        <Box component="div" sx={{ overflowX: 'auto' }}>
            <Box component="table" sx={{ width: '100%', borderCollapse: 'collapse' }}>
                <Box component="thead">
                    <Box component="tr">
                        {[
                            'Project',
                            'Block / Flat',
                            'BHK',
                            'Status',
                            'Buyer',
                            'Contact',
                            'Reference',
                            'Price',
                            'Booked',
                        ].map((heading) => (
                            <Box
                                key={heading}
                                component="th"
                                sx={{
                                    textAlign: 'left',
                                    padding: '12px 14px',
                                    fontWeight: 600,
                                    fontSize: '0.85rem',
                                    letterSpacing: '0.04em',
                                    color: 'text.tertiary',
                                    borderBottom: '1px solid',
                                    borderColor: 'divider',
                                }}
                            >
                                {heading}
                            </Box>
                        ))}
                    </Box>
                </Box>
                <Box component="tbody">
                    {records.map((record, index) => {
                        const project = [record.project_code, record.project_name]
                            .filter(Boolean)
                            .join(' - ');
                        const blockFlat = [record.block_name, record.unit_label]
                            .filter(Boolean)
                            .join(' / ');
                        const contactPieces = [
                            record.buyer_phone,
                            record.buyer_email,
                        ].filter(Boolean);
                        const priceValue =
                            record.price ||
                            record.booking_price ||
                            record.selling_price ||
                            record.amount;

                        return (
                            <Box
                                key={`${record.id || index}-${record.unit_id || ''}`}
                                component="tr"
                                sx={{
                                    transition: 'background 0.2s ease',
                                    '&:hover': {
                                        backgroundColor: 'background.level1',
                                    },
                                }}
                            >
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        fontWeight: 600,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {project || '-'}
                                </Box>
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {blockFlat || '-'}
                                </Box>
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {record.bhk_configuration || '-'}
                                </Box>
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {renderStatusChip(record.status)}
                                </Box>
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {record.buyer_name || '-'}
                                </Box>
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {contactPieces.length ? contactPieces.join(' / ') : '-'}
                                </Box>
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {record.buyer_reference_source || '-'}
                                </Box>
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {priceValue ? `Rs ${priceValue}` : '-'}
                                </Box>
                                <Box
                                    component="td"
                                    sx={{
                                        py: 1.5,
                                        px: 1.5,
                                        borderBottom: '1px solid',
                                        borderColor: 'divider',
                                    }}
                                >
                                    {record.booking_date || record.sold_date || '-'}
                                </Box>
                            </Box>
                        );
                    })}
                </Box>
            </Box>
        </Box>
    );
};

export default CRMTable;

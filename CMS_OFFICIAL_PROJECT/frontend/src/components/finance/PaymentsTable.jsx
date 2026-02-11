import React from 'react';
import { Box, Chip, Sheet, Table, Typography } from '@mui/joy';
import { formatDisplayDate, getCategoryLabel } from '../../pages/finance/financeUtils';

const PaymentsTable = ({ category, payments, projectName }) => {
    return (
        <Sheet variant="outlined" sx={{ borderRadius: 'lg', overflow: 'hidden' }}>
            <Box sx={{ p: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
                <Typography level="title-md">{projectName} - {getCategoryLabel(category)} History</Typography>
            </Box>
            <Box sx={{ overflowX: 'auto' }}>
                <Table hoverRow stickyHeader>
                    <thead>
                        <tr>
                            {category === 'project' && (
                                <>
                                    <th>Amount</th>
                                    <th>Date</th>
                                    <th>Type</th>
                                    <th>Description</th>
                                </>
                            )}
                            {category === 'flat' && (
                                <>
                                    <th>Unit</th>
                                    <th>Receipt</th>
                                    <th>Amount</th>
                                    <th>Date</th>
                                    <th>Stage</th>
                                </>
                            )}
                            {category === 'plot' && (
                                <>
                                    <th>Unit</th>
                                    <th>Receipt</th>
                                    <th>Amount</th>
                                    <th>Date</th>
                                    <th>Stage</th>
                                </>
                            )}
                        </tr>
                    </thead>
                    <tbody>
                        {payments.length === 0 ? (
                            <tr>
                                <td colSpan={category === 'project' ? 4 : 5} style={{ textAlign: 'center', p: 2 }}>
                                    No records found.
                                </td>
                            </tr>
                        ) : (
                            payments.map((p) => (
                                <tr key={p.id}>
                                    {category === 'project' && (
                                        <>
                                            <td>₹{Number(p.amount).toLocaleString()}</td>
                                            <td>{formatDisplayDate(p.date)}</td>
                                            <td>{p.type}</td>
                                            <td>{p.description || '-'}</td>
                                        </>
                                    )}
                                    {category === 'flat' && (
                                        <>
                                            <td><Chip variant="soft" size="sm">{p.unit}</Chip></td>
                                            <td>{p.receipt}</td>
                                            <td>₹{Number(p.amount).toLocaleString()}</td>
                                            <td>{formatDisplayDate(p.date)}</td>
                                            <td>{p.stage}</td>
                                        </>
                                    )}
                                    {category === 'plot' && (
                                        <>
                                            <td><Chip variant="soft" size="sm" color="warning">{p.unit}</Chip></td>
                                            <td>{p.receipt}</td>
                                            <td>₹{Number(p.amount).toLocaleString()}</td>
                                            <td>{formatDisplayDate(p.date)}</td>
                                            <td>{p.stage}</td>
                                        </>
                                    )}
                                </tr>
                            ))
                        )}
                    </tbody>
                </Table>
            </Box>
        </Sheet>
    );
};

export default PaymentsTable;

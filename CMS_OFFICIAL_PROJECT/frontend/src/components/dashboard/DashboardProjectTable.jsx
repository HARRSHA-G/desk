import React from 'react';
import Sheet from '@mui/joy/Sheet';
import Box from '@mui/joy/Box';
import Typography from '@mui/joy/Typography';
import Select from '@mui/joy/Select';
import Option from '@mui/joy/Option';
import Button from '@mui/joy/Button';
import Table from '@mui/joy/Table';
import Chip from '@mui/joy/Chip';
import ArrowDownwardIcon from '@mui/icons-material/ArrowDownward';
import ArrowUpwardIcon from '@mui/icons-material/ArrowUpward';
import { STATUS_CONFIG, formatCurrency } from '../../pages/dashboard/dashboardUtils';

const DashboardProjectTable = ({
    selectedStatus,
    selectedLayout,
    setSelectedLayout,
    sortBudgetDesc,
    setSortBudgetDesc,
    filteredProjects
}) => {
    return (
        <Sheet
            component="section"
            variant="outlined"
            sx={{
                borderRadius: 'lg',
                overflow: 'hidden',
                bgcolor: 'background.surface',
            }}
        >
            <Box sx={{ p: 2.5, display: 'flex', flexWrap: 'wrap', alignItems: 'center', justifyContent: 'space-between', gap: 2, borderBottom: '1px solid', borderColor: 'divider' }}>
                <Box>
                    <Typography level="title-lg">Project Details</Typography>
                    <Typography level="body-sm">
                        {selectedStatus ? `Status: ${STATUS_CONFIG[selectedStatus]?.label || selectedStatus}` : 'Showing all projects'}
                    </Typography>
                </Box>
                <Box sx={{ display: 'flex', gap: 1.5, flexWrap: 'wrap' }}>
                    <Select
                        defaultValue="all"
                        value={selectedLayout}
                        size="sm"
                        sx={{ minWidth: 140 }}
                        onChange={(e, val) => setSelectedLayout(val)}
                    >
                        <Option value="all">All layouts</Option>
                        <Option value="single_flat">Single Unit</Option>
                        <Option value="multi_flat">Multi Flat</Option>
                        <Option value="multi_plot">Multi Plot</Option>
                    </Select>
                    <Button
                        variant={sortBudgetDesc ? 'solid' : 'outlined'}
                        color={sortBudgetDesc ? 'primary' : 'neutral'}
                        size="sm"
                        onClick={() => setSortBudgetDesc(!sortBudgetDesc)}
                        endDecorator={sortBudgetDesc ? <ArrowDownwardIcon /> : <ArrowUpwardIcon />}
                    >
                        Sort by Budget
                    </Button>
                </Box>
            </Box>

            <Box sx={{ overflowX: 'auto' }}>
                <Table hoverRow stickyHeader>
                    <thead>
                        <tr>
                            <th style={{ width: 60, textAlign: 'center' }}>S No</th>
                            <th>Project ID</th>
                            <th>Project Name</th>
                            <th>Status</th>
                            <th>Layout</th>
                            <th>Budget</th>
                            <th>Paid</th>
                            <th>Pending</th>
                            <th>Duration</th>
                            <th>Customer</th>
                            <th>Supervisor</th>
                        </tr>
                    </thead>
                    <tbody>
                        {filteredProjects.length > 0 ? filteredProjects.map((p, index) => (
                            <tr key={p.id || index}>
                                <td style={{ textAlign: 'center', color: 'var(--joy-palette-text-tertiary)' }}>{index + 1}</td>
                                <td>
                                    <Typography fontWeight="md">{p.code}</Typography>
                                </td>
                                <td>
                                    <Typography fontWeight="md">{p.name}</Typography>
                                </td>
                                <td>
                                    <Chip
                                        variant="soft"
                                        size="sm"
                                        color={
                                            p.status === 'active' || p.status === 'in progress' ? 'warning' :
                                                p.status === 'completed' ? 'success' :
                                                    p.status === 'cancelled' ? 'danger' : 'info'
                                        }
                                    >
                                        {p.status}
                                    </Chip>
                                </td>
                                <td>{p.layout}</td>
                                <td>{formatCurrency(p.budget)}</td>
                                <td>{formatCurrency(p.received)}</td>
                                <td>{formatCurrency(p.pending)}</td>
                                <td>{p.duration} mo</td>
                                <td>{(p.layoutKeyRaw || p.layoutKey || '').includes('multi') ? 'Handled in CRM' : p.customer || 'Not assigned'}</td>
                                <td>{(p.layoutKeyRaw || p.layoutKey || '').includes('multi') ? 'Assign via CRM/Blocks' : p.supervisor || 'Not assigned'}</td>

                            </tr>
                        )) : (
                            <tr>
                                <td colSpan={11} style={{ textAlign: 'center', padding: '3rem' }}>
                                    <Typography level="body-md" fontStyle="italic">
                                        No projects found matching current filters.
                                    </Typography>
                                </td>
                            </tr>
                        )}
                    </tbody>
                </Table>
            </Box>
        </Sheet>
    );
};

export default DashboardProjectTable;

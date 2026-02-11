import React from 'react';
import {
    Box,
    Button,
    Card,
    Checkbox,
    FormControl,
    FormLabel,
    Grid,
    Input,
    Option,
    Select,
    Sheet,
    Typography,
} from '@mui/joy';

const MarkAttendance = ({
    batches,
    selectedBatchId,
    setSelectedBatchId,
    batchMembers,
    loadBatchMembers,
    markData,
    onMarkDataChange,
    selectedMembers,
    onMemberToggle,
    onSubmit,
}) => {
    return (
        <Box sx={{ py: 2 }}>
            <Card variant="outlined">
                <Box sx={{ mb: 2 }}>
                    <Typography level="title-lg">Quick Mark</Typography>
                    <Typography level="body-sm" color="neutral">
                        Select batch, load members, and submit.
                    </Typography>
                </Box>

                <Grid container spacing={2} sx={{ mb: 3 }}>
                    <Grid xs={12} md={4}>
                        <FormControl>
                            <FormLabel>Select Batch</FormLabel>
                            <Box sx={{ display: 'flex', gap: 1 }}>
                                <Select
                                    value={selectedBatchId}
                                    onChange={(e, val) => setSelectedBatchId(val)}
                                    sx={{ flex: 1 }}
                                >
                                    <Option value="">Choose...</Option>
                                    {batches.map((b) => (
                                        <Option key={b.id} value={b.id}>
                                            {b.name}
                                        </Option>
                                    ))}
                                </Select>
                                <Button
                                    variant="soft"
                                    onClick={() => loadBatchMembers(selectedBatchId)}
                                    disabled={!selectedBatchId}
                                >
                                    Load
                                </Button>
                            </Box>
                        </FormControl>
                    </Grid>
                    <Grid xs={12} sm={6} md={2}>
                        <FormControl>
                            <FormLabel>Mode</FormLabel>
                            <Select
                                value={markData.mode}
                                onChange={(e, val) => onMarkDataChange({ ...markData, mode: val })}
                            >
                                <Option value="onsite">On-site</Option>
                                <Option value="remote">Remote</Option>
                            </Select>
                        </FormControl>
                    </Grid>
                    <Grid xs={12} sm={6} md={3}>
                        <FormControl>
                            <FormLabel>Check In</FormLabel>
                            <Input
                                type="time"
                                value={markData.checkIn}
                                onChange={(e) => onMarkDataChange({ ...markData, checkIn: e.target.value })}
                            />
                        </FormControl>
                    </Grid>
                    <Grid xs={12} sm={6} md={3}>
                        <FormControl>
                            <FormLabel>Check Out</FormLabel>
                            <Input
                                type="time"
                                value={markData.checkOut}
                                onChange={(e) => onMarkDataChange({ ...markData, checkOut: e.target.value })}
                            />
                        </FormControl>
                    </Grid>
                </Grid>

                {batchMembers.length > 0 && (
                    <Box>
                        <Typography level="title-md" sx={{ mb: 1 }}>
                            Members ({batchMembers.length})
                        </Typography>
                        <Typography level="body-xs" sx={{ mb: 2 }}>
                            Click to toggle presence (Selected = Present)
                        </Typography>

                        <Grid container spacing={1}>
                            {batchMembers.map((member) => {
                                const isSelected = !!selectedMembers[member.id];
                                return (
                                    <Grid key={member.id} xs={6} sm={4} md={3}>
                                        <Sheet
                                            variant={isSelected ? 'soft' : 'outlined'}
                                            color={isSelected ? 'success' : 'neutral'}
                                            onClick={() => onMemberToggle(member.id)}
                                            sx={{
                                                p: 1.5,
                                                borderRadius: 'md',
                                                cursor: 'pointer',
                                                border: '1px solid',
                                                borderColor: isSelected ? 'transparent' : 'divider',
                                                transition: '0.2s',
                                                '&:hover': {
                                                    borderColor: isSelected ? 'transparent' : 'primary.300',
                                                }
                                            }}
                                        >
                                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                                                <Checkbox
                                                    checked={isSelected}
                                                    readOnly
                                                    color="success"
                                                    sx={{ pointerEvents: 'none' }}
                                                />
                                                <Box>
                                                    <Typography level="title-sm">{member.name}</Typography>
                                                    <Typography level="body-xs">{member.role || 'Member'}</Typography>
                                                </Box>
                                            </Box>
                                        </Sheet>
                                    </Grid>
                                );
                            })}
                        </Grid>

                        <Box sx={{ mt: 3, display: 'flex', justifyContent: 'flex-end' }}>
                            <Button size="lg" onClick={onSubmit}>
                                Submit Attendance
                            </Button>
                        </Box>
                    </Box>
                )}
            </Card>
        </Box>
    );
};

export default MarkAttendance;

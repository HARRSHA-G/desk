import React from 'react';
import { Button, FormControl, FormLabel, Grid, Input, Option, Select, Sheet } from '@mui/joy';

const FiltersPanel = ({
    projects,
    selectedProject,
    setSelectedProject,
    fromDateIso,
    setFromDateIso,
    toDateIso,
    setToDateIso,
    handleGenerate,
    loading,
}) => {
    return (
        <Sheet variant="outlined" sx={{ p: 2, borderRadius: 'lg', mb: 3, bgcolor: 'background.surface' }}>
            <Grid container spacing={2} alignItems="flex-end">
                <Grid xs={12} md={4}>
                    <FormControl>
                        <FormLabel>Project</FormLabel>
                        <Select
                            placeholder="Select a project..."
                            value={selectedProject}
                            onChange={(e, val) => setSelectedProject(val)}
                            startDecorator={<i className="ri-building-line" />}
                        >
                            {projects.map((p) => (
                                <Option key={p.id} value={p.id}>
                                    {p.name} {p.code ? `(${p.code})` : ''}
                                </Option>
                            ))}
                        </Select>
                    </FormControl>
                </Grid>
                <Grid xs={6} md={3}>
                    <FormControl>
                        <FormLabel>From Date</FormLabel>
                        <Input
                            type="date"
                            value={fromDateIso}
                            onChange={(e) => setFromDateIso(e.target.value)}
                        />
                    </FormControl>
                </Grid>
                <Grid xs={6} md={3}>
                    <FormControl>
                        <FormLabel>To Date</FormLabel>
                        <Input
                            type="date"
                            value={toDateIso}
                            onChange={(e) => setToDateIso(e.target.value)}
                        />
                    </FormControl>
                </Grid>
                <Grid xs={12} md={2}>
                    <Button
                        fullWidth
                        onClick={handleGenerate}
                        disabled={loading}
                        startDecorator={loading ? null : <i className="ri-search-line" />}
                    >
                        {loading ? 'Loading...' : 'Generate'}
                    </Button>
                </Grid>
            </Grid>
        </Sheet>
    );
};

export default FiltersPanel;

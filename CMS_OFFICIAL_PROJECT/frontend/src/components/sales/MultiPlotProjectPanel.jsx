import React, { useEffect, useState } from 'react';
import {
    Box,
    Button,
    Chip,
    Grid,
    Input,
    Sheet,
    Stack,
    Typography,
    useTheme,
    FormControl,
    FormLabel,
    Card
} from '@mui/joy';
import { STATUS_META, TEMPLATE_PRESETS, glassPanelSx, humanize } from '../../pages/sales/multiPlotSalesUtils';

const MultiPlotProjectPanel = ({
    project,
    plots,
    templateControls,
    onTemplateChange,
    onTemplateSave,
    onOpenBuyer,
}) => {
    const theme = useTheme();
    const panelSx = glassPanelSx(theme.palette.mode);
    const [activeZoneId, setActiveZoneId] = useState(project.zones[0]?.zoneId);
    const [templateExpanded, setTemplateExpanded] = useState(false);

    useEffect(() => {
        setActiveZoneId(project.zones[0]?.zoneId);
    }, [project.id]);

    const zone = project.zones.find((item) => item.zoneId === activeZoneId) || project.zones[0];
    const templateKey = `${project.id}-${zone?.zoneId}`;
    const templateState = templateControls[templateKey] || {
        floors: zone?.floors.length || 0,
        plotsPerFloor: (zone?.floors[0]?.plots.length) || 4,
        size: '1200 sqft',
        facing: 'North',
        price: 'INR 45 L',
    };

    const projectPlots = plots.filter((plot) => plot.projectId === project.id);
    const zonePlots = projectPlots.filter((plot) => plot.zoneId === zone?.zoneId);

    const stats = projectPlots.reduce(
        (acc, plot) => {
            if (STATUS_META[plot.status]) {
                acc[plot.status] += 1;
            }
            acc.total += 1;
            return acc;
        },
        { total: 0, available: 0, hold: 0, booked: 0, sold: 0, missing: 0 },
    );

    const toggleTemplate = () => {
        setTemplateExpanded((prev) => !prev);
    };

    return (
        <Grid item xs={12}>
            <Sheet sx={{ ...panelSx, p: 3, minHeight: 520, display: 'flex', flexDirection: 'column', gap: 2 }}>
                <Box>
                    <Stack direction="row" spacing={1} alignItems="center" mb={1} flexWrap="wrap">
                        <Chip variant="soft" color="primary">
                            {project.badge}
                        </Chip>
                        <Chip variant="soft" color="info">
                            {humanize(project.stage)} stage
                        </Chip>
                    </Stack>
                    <Typography level="title-lg">{project.name}</Typography>
                    <Typography level="body-md" color="neutral">
                        {project.description || project.location}
                    </Typography>
                </Box>

                <Stack direction="row" spacing={1} flexWrap="wrap">
                    {Object.entries(stats)
                        .filter(([key]) => key !== 'total')
                        .map(([key, value]) => (
                            <Chip key={key} size="sm" variant="outlined" color={STATUS_META[key]?.color || 'neutral'}>
                                {STATUS_META[key]?.label || humanize(key)} {value}
                            </Chip>
                        ))}
                    <Chip size="sm" variant="outlined" color="primary">
                        Total {stats.total}
                    </Chip>
                </Stack>

                <Box>
                    <Typography level="body-sm" color="neutral">
                        Zone {zone?.zoneId}: {zone?.name}
                    </Typography>
                    <Typography level="body-sm" color="neutral">
                        {zone?.floors.length} floors - {zone?.floors[0]?.plots.length} plots/floor
                    </Typography>
                </Box>

                <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
                    {project.zones.map((zoneItem) => (
                        <Chip
                            key={zoneItem.zoneId}
                            variant={zoneItem.zoneId === activeZoneId ? 'soft' : 'outlined'}
                            color={zoneItem.zoneId === activeZoneId ? 'primary' : 'neutral'}
                            size="sm"
                            onClick={() => setActiveZoneId(zoneItem.zoneId)}
                            sx={{ cursor: 'pointer' }}
                        >
                            Zone {zoneItem.zoneId}
                        </Chip>
                    ))}
                </Box>

                <Box sx={{ display: 'flex', gap: 1, alignItems: 'center', flexWrap: 'wrap' }}>
                    <Button variant="soft" color="neutral" size="sm" onClick={toggleTemplate}>
                        {templateExpanded ? 'Hide templates' : 'Manage templates'}
                    </Button>
                    <Typography level="body-xs" color="neutral">
                        {zonePlots.length} plots shown for this zone
                    </Typography>
                </Box>

                {templateExpanded && (
                    <Sheet sx={{ ...panelSx, p: 2 }}>
                        <Typography level="body-sm" color="neutral">
                            Zone-level controls keep floors and plots per floor synchronized with new templates.
                        </Typography>
                        <Grid container spacing={1} sx={{ mt: 1 }}>
                            <Grid xs={6}>
                                <FormControl>
                                    <FormLabel>Floors</FormLabel>
                                    <Input
                                        type="number"
                                        value={templateState.floors}
                                        onChange={(event) =>
                                            onTemplateChange(project.id, zone?.zoneId, { floors: Number(event.target.value) })
                                        }
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={6}>
                                <FormControl>
                                    <FormLabel>Plots / floor</FormLabel>
                                    <Input
                                        type="number"
                                        value={templateState.plotsPerFloor}
                                        onChange={(event) =>
                                            onTemplateChange(project.id, zone?.zoneId, { plotsPerFloor: Number(event.target.value) })
                                        }
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={12}>
                                <FormLabel>Preset templates</FormLabel>
                                <Stack direction="row" spacing={1} flexWrap="wrap" sx={{ mt: 1 }}>
                                    {TEMPLATE_PRESETS.map((preset) => (
                                        <Button
                                            key={preset.label}
                                            variant="plain"
                                            color="primary"
                                            size="sm"
                                            onClick={() => onTemplateChange(project.id, zone?.zoneId, preset.config)}
                                        >
                                            {preset.label}
                                        </Button>
                                    ))}
                                </Stack>
                            </Grid>
                            <Grid xs={12}>
                                <Stack direction={{ xs: 'column', sm: 'row' }} spacing={1}>
                                    <FormControl sx={{ flex: 1 }}>
                                        <FormLabel>Size</FormLabel>
                                        <Input
                                            value={templateState.size}
                                            onChange={(event) =>
                                                onTemplateChange(project.id, zone?.zoneId, { size: event.target.value })
                                            }
                                        />
                                    </FormControl>
                                    <FormControl sx={{ flex: 1 }}>
                                        <FormLabel>Facing</FormLabel>
                                        <Input
                                            value={templateState.facing}
                                            onChange={(event) =>
                                                onTemplateChange(project.id, zone?.zoneId, { facing: event.target.value })
                                            }
                                        />
                                    </FormControl>
                                    <FormControl sx={{ flex: 1 }}>
                                        <FormLabel>Price</FormLabel>
                                        <Input
                                            value={templateState.price}
                                            onChange={(event) =>
                                                onTemplateChange(project.id, zone?.zoneId, { price: event.target.value })
                                            }
                                        />
                                    </FormControl>
                                </Stack>
                            </Grid>
                            <Grid xs={12}>
                                <Button
                                    variant="solid"
                                    color="primary"
                                    onClick={() => onTemplateSave(project.id, zone?.zoneId, templateState)}
                                >
                                    Save template
                                </Button>
                            </Grid>
                        </Grid>
                    </Sheet>
                )}

                <Box sx={{ flex: 1, overflow: 'hidden' }}>
                    {!projectPlots.length ? (
                        <Box sx={{ py: 8, textAlign: 'center' }}>
                            <Typography level="body-sm" color="neutral">
                                No plots match the active filters for this project.
                            </Typography>
                        </Box>
                    ) : (
                        <Grid container spacing={1}>
                            {projectPlots.map((plot) => {
                                const statusMeta = STATUS_META[plot.status] || { label: humanize(plot.status), color: 'neutral' };
                                return (
                                    <Grid key={plot.id} xs={6} sm={4}>
                                        <Card
                                            variant="outlined"
                                            sx={{
                                                borderRadius: '14px',
                                                p: 1.5,
                                                cursor: 'pointer',
                                                ':hover': { boxShadow: 'md' },
                                                height: '100%',
                                                display: 'flex',
                                                flexDirection: 'column',
                                                gap: 0.5,
                                            }}
                                        >
                                            <Typography level="body-md">{plot.label}</Typography>
                                            <Stack direction="row" spacing={0.5} flexWrap="wrap">
                                                <Chip size="sm" color="info" variant="soft">
                                                    {humanize(plot.stage)}
                                                </Chip>
                                                <Chip size="sm" color={statusMeta.color} variant="soft">
                                                    {statusMeta.label}
                                                </Chip>
                                            </Stack>
                                            <Typography level="body-xs" color="neutral">
                                                {plot.size} - {plot.facing} - {plot.price}
                                            </Typography>
                                            <Button variant="soft" color="primary" size="sm" onClick={() => onOpenBuyer(plot)}>
                                                Edit buyer
                                            </Button>
                                        </Card>
                                    </Grid>
                                );
                            })}
                        </Grid>
                    )}
                </Box>
            </Sheet>
        </Grid>
    );
};

export default MultiPlotProjectPanel;

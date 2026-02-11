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
import { STATUS_META, TEMPLATE_PRESETS, glassPanelSx, humanize } from '../../pages/sales/multiFlatSalesUtils';

const ProjectPanel = ({
    project,
    units,
    templateControls,
    onTemplateChange,
    onTemplateSave,
    onOpenBuyer,
}) => {
    const theme = useTheme();
    const panelSx = glassPanelSx(theme.palette.mode);
    const [activeBlockId, setActiveBlockId] = useState(project.blocks[0]?.blockId);
    const [templateExpanded, setTemplateExpanded] = useState(false);

    useEffect(() => {
        setActiveBlockId(project.blocks[0]?.blockId);
    }, [project.id]);

    const block = project.blocks.find((item) => item.blockId === activeBlockId) || project.blocks[0];
    const templateKey = `${project.id}-${block?.blockId}`;
    const templateState = templateControls[templateKey] || {
        floors: block?.floorsCount || 0,
        unitsPerFloor: block?.unitsPerFloor || 4,
        bhk: '2 BHK',
        facing: 'East',
        area: '1100',
    };

    const projectUnits = units.filter((unit) => unit.projectId === project.id);
    const blockUnits = projectUnits.filter((unit) => unit.blockId === block?.blockId);

    const stats = projectUnits.reduce(
        (acc, unit) => {
            if (STATUS_META[unit.status]) {
                acc[unit.status] += 1;
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
        <Grid xs={12}>
            <Sheet sx={{ ...panelSx, p: 3, minHeight: 480, display: 'flex', flexDirection: 'column', gap: 2 }}>
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
                        Block {block?.blockId}: {block?.name}
                    </Typography>
                    <Typography level="body-sm" color="neutral">
                        {block?.floorsCount} floors  -  {block?.unitsPerFloor} units/floor
                    </Typography>
                </Box>

                <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
                    {project.blocks.map((blockItem) => (
                        <Chip
                            key={blockItem.blockId}
                            variant={blockItem.blockId === activeBlockId ? 'soft' : 'outlined'}
                            color={blockItem.blockId === activeBlockId ? 'primary' : 'neutral'}
                            size="sm"
                            onClick={() => setActiveBlockId(blockItem.blockId)}
                            sx={{ cursor: 'pointer' }}
                        >
                            Block {blockItem.blockId}
                        </Chip>
                    ))}
                </Box>

                <Box sx={{ display: 'flex', gap: 1, alignItems: 'center', flexWrap: 'wrap' }}>
                    <Button variant="soft" color="neutral" size="sm" onClick={toggleTemplate}>
                        {templateExpanded ? 'Hide templates' : 'Manage templates'}
                    </Button>
                    <Typography level="body-xs" color="neutral">
                        {blockUnits.length} units shown for this block
                    </Typography>
                </Box>

                {templateExpanded && (
                    <Sheet sx={{ ...panelSx, p: 2 }}>
                        <Typography level="body-sm" color="neutral">
                            Block-level controls for floor count and units per floor keep new templates aligned with current configuration.
                        </Typography>
                        <Grid container spacing={1} sx={{ mt: 1 }}>
                            <Grid xs={6}>
                                <FormControl>
                                    <FormLabel>Floors</FormLabel>
                                    <Input
                                        type="number"
                                        value={templateState.floors}
                                        onChange={(event) =>
                                            onTemplateChange(project.id, block?.blockId, { floors: Number(event.target.value) })
                                        }
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={6}>
                                <FormControl>
                                    <FormLabel>Units / floor</FormLabel>
                                    <Input
                                        type="number"
                                        value={templateState.unitsPerFloor}
                                        onChange={(event) =>
                                            onTemplateChange(project.id, block?.blockId, { unitsPerFloor: Number(event.target.value) })
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
                                            onClick={() => onTemplateChange(project.id, block?.blockId, preset.config)}
                                        >
                                            {preset.label}
                                        </Button>
                                    ))}
                                </Stack>
                            </Grid>
                            <Grid xs={12}>
                                <Stack direction={{ xs: 'column', sm: 'row' }} spacing={1}>
                                    <FormControl sx={{ flex: 1 }}>
                                        <FormLabel>BHK</FormLabel>
                                        <Input
                                            value={templateState.bhk}
                                            onChange={(event) =>
                                                onTemplateChange(project.id, block?.blockId, { bhk: event.target.value })
                                            }
                                        />
                                    </FormControl>
                                    <FormControl sx={{ flex: 1 }}>
                                        <FormLabel>Facing</FormLabel>
                                        <Input
                                            value={templateState.facing}
                                            onChange={(event) =>
                                                onTemplateChange(project.id, block?.blockId, { facing: event.target.value })
                                            }
                                        />
                                    </FormControl>
                                    <FormControl sx={{ flex: 1 }}>
                                        <FormLabel>Area (sq ft)</FormLabel>
                                        <Input
                                            type="number"
                                            value={templateState.area}
                                            onChange={(event) =>
                                                onTemplateChange(project.id, block?.blockId, { area: event.target.value })
                                            }
                                        />
                                    </FormControl>
                                </Stack>
                            </Grid>
                            <Grid xs={12}>
                                <Button
                                    variant="solid"
                                    color="primary"
                                    onClick={() => onTemplateSave(project.id, block?.blockId, templateState)}
                                >
                                    Save template
                                </Button>
                            </Grid>
                        </Grid>
                    </Sheet>
                )}

                <Box sx={{ flex: 1, overflow: 'hidden' }}>
                    {!projectUnits.length ? (
                        <Box sx={{ py: 8, textAlign: 'center' }}>
                            <Typography level="body-sm" color="neutral">
                                No units match the active filters for this project.
                            </Typography>
                        </Box>
                    ) : (
                        <Grid container spacing={1}>
                            {projectUnits.map((unit) => {
                                const statusMeta = STATUS_META[unit.status] || { label: humanize(unit.status), color: 'neutral' };
                                return (
                                    <Grid key={unit.id} xs={6} sm={4}>
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
                                            <Typography level="body-md">{unit.label}</Typography>
                                            <Stack direction="row" spacing={0.5} flexWrap="wrap">
                                                <Chip size="sm" color="info" variant="soft">
                                                    {humanize(unit.stage)}
                                                </Chip>
                                                <Chip size="sm" color={statusMeta.color} variant="soft">
                                                    {statusMeta.label}
                                                </Chip>
                                            </Stack>
                                            <Typography level="body-xs" color="neutral">
                                                {unit.bhk}  -  {unit.facing}  -  {unit.area} sq ft
                                            </Typography>
                                            <Button
                                                variant="soft"
                                                color="primary"
                                                size="sm"
                                                onClick={() => onOpenBuyer(unit)}
                                            >
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

export default ProjectPanel;

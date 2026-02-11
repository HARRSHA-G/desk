import React, { useEffect, useMemo, useState } from 'react';
import {
  Alert,
  Box,
  Button,
  Chip,
  FormControl,
  FormLabel,
  Grid,
  Input,
  Option,
  Select,
  Sheet,
  Stack,
  Typography,
  useTheme,
} from '@mui/joy';
import api from '../../api';

import {
  STATUS_META,
  DEFAULT_FILTERS,
  HERO_DESCRIPTION,
  getFallbackMultiPlotProjects,
  flattenPlots,
  applyFilters,
  buildSummary,
  stageOptionsFromPlots,
  facingOptionsFromPlots,
  floorOptionsFromPlots,
  zoneOptionsFromProjects,
  humanize,
  buildQueryFromFilters,
  normalizeMultiPlotPayload,
  heroPanelSx,
  glassPanelSx
} from './multiPlotSalesUtils';

import MultiPlotProjectPanel from '../../components/sales/MultiPlotProjectPanel';
import MultiPlotBuyerModal from '../../components/sales/MultiPlotBuyerModal';

const MultiPlotSales = () => {
  const theme = useTheme();
  const heroSx = heroPanelSx(theme.palette.mode);
  const baseGlassSx = glassPanelSx(theme.palette.mode);
  const [projects, setProjects] = useState([]);
  const [projectChoices, setProjectChoices] = useState([]);
  const [projectChoicesLoading, setProjectChoicesLoading] = useState(true);
  const [selectedProjectId, setSelectedProjectId] = useState('');
  const [lastLoadedProjectId, setLastLoadedProjectId] = useState(null);
  const [filters, setFilters] = useState(() => ({ ...DEFAULT_FILTERS }));
  const [loading, setLoading] = useState(false);
  const [alert, setAlert] = useState(null);
  const [buyerModal, setBuyerModal] = useState({ open: false, plot: null });
  const [templateControls, setTemplateControls] = useState({});

  useEffect(() => {
    let active = true;
    const loadProjects = async () => {
      setProjectChoicesLoading(true);
      try {
        const response = await api.get('/projects/');
        if (!active) return;
        const payload = Array.isArray(response.data) ? response.data : response.data?.results || [];
        const multiPlotProjects = payload
          .filter((item) => (item.project_flat_configuration || '').toLowerCase() === 'multi_plot')
          .map((item) => ({
            id: item.id || item.project_id || String(item.project_code || item.code || ''),
            name: item.project_name || item.name || 'Unnamed project',
            code: item.project_code || item.code || '',
          }));
        setProjectChoices(multiPlotProjects);
      } catch (err) {
        console.warn('Could not load project list', err);
        setProjectChoices([]);
      } finally {
        if (active) setProjectChoicesLoading(false);
      }
    };
    loadProjects();
    return () => {
      active = false;
    };
  }, []);

  useEffect(() => {
    if (!alert) return undefined;
    const timer = setTimeout(() => setAlert(null), 4200);
    return () => clearTimeout(timer);
  }, [alert]);

  const flattenedPlots = useMemo(() => flattenPlots(projects), [projects]);
  const filteredPlots = useMemo(() => applyFilters(flattenedPlots, filters), [flattenedPlots, filters]);
  const summary = useMemo(() => buildSummary(filteredPlots), [filteredPlots]);
  const stageOptions = useMemo(() => stageOptionsFromPlots(flattenedPlots), [flattenedPlots]);
  const facingOptions = useMemo(() => facingOptionsFromPlots(flattenedPlots), [flattenedPlots]);
  const floorOptions = useMemo(() => floorOptionsFromPlots(flattenedPlots), [flattenedPlots]);
  const zoneOptions = useMemo(() => zoneOptionsFromProjects(projects), [projects]);
  const searchTerm = filters.search.trim().toLowerCase();

  const visibleProjects = useMemo(() => {
    if (!searchTerm) return projects;
    return projects.filter((project) => {
      if (project.name.toLowerCase().includes(searchTerm) || project.code.toLowerCase().includes(searchTerm)) {
        return true;
      }
      return flattenedPlots.some(
        (plot) =>
          plot.projectId === project.id &&
          (plot.label.toLowerCase().includes(searchTerm) || plot.zoneName.toLowerCase().includes(searchTerm)),
      );
    });
  }, [searchTerm, projects, flattenedPlots]);

  const lastLoadedProject = lastLoadedProjectId
    ? projectChoices.find((project) => String(project.id) === String(lastLoadedProjectId))
    : null;

  const fetchMultiPlotData = async (projectId, queryFilters) => {
    if (!projectId) return;
    const appliedFilters = queryFilters || filters;
    setLoading(true);
    try {
      const params = {
        ...buildQueryFromFilters(appliedFilters),
        project_id: projectId,
      };
      const response = await api.get('/sales/multi-plot', { params });
      const normalized = normalizeMultiPlotPayload(response.data);
      if (normalized.length) {
        setProjects(normalized);
        setAlert({ type: 'success', message: 'Live multi-plot data synced.' });
      } else {
        const fallbackProjects = getFallbackMultiPlotProjects(projectId);
        if (fallbackProjects.length) {
          setProjects(fallbackProjects);
          setAlert({
            type: 'info',
            message: `No live data yet; showing bundled layout for ${fallbackProjects[0].name}.`,
          });
        } else {
          setProjects([]);
          setAlert({ type: 'info', message: 'No live multi-plot data yet; using a cached layout.' });
        }
      }
    } catch (err) {
      console.warn('Failed to fetch multi-plot sales data', err);
      const fallbackProjects = getFallbackMultiPlotProjects(projectId);
      if (fallbackProjects.length) {
        setProjects(fallbackProjects);
        setAlert({
          type: 'info',
          message: `Live API offline; showing bundled layout for ${fallbackProjects[0].name}.`,
        });
      } else {
        setProjects([]);
        setAlert({ type: 'danger', message: 'Could not reach /api/multi-plot/sales; using fallback data.' });
      }
    } finally {
      setLoading(false);
    }
  };

  const handleFilterChange = (field, value) => {
    setFilters((prev) => ({
      ...prev,
      [field]: value !== undefined ? value : prev[field],
    }));
  };

  const handleLoadPlots = () => {
    if (!selectedProjectId) return;
    setLastLoadedProjectId(selectedProjectId);
    fetchMultiPlotData(selectedProjectId, filters);
  };

  const handleResetFilters = () => {
    setFilters({ ...DEFAULT_FILTERS });
    setAlert({ type: 'info', message: 'Filters reset to defaults.' });
  };

  const handleRefresh = () => {
    if (!lastLoadedProjectId) return;
    fetchMultiPlotData(lastLoadedProjectId, filters);
  };

  const handleTemplateChange = (projectId, zoneId, nextState) => {
    const key = `${projectId}-${zoneId}`;
    setTemplateControls((prev) => ({
      ...prev,
      [key]: {
        ...prev[key],
        ...nextState,
      },
    }));
  };

  const handleTemplateSave = (projectId, zoneId, state) => {
    setAlert({ type: 'success', message: `Template saved for Zone ${zoneId}.` });
    handleTemplateChange(projectId, zoneId, state);
  };

  const openBuyerModal = (plot) => {
    setBuyerModal({ open: true, plot });
  };

  const closeBuyerModal = () => {
    setBuyerModal({ open: false, plot: null });
  };

  const handleBuyerSave = (formData) => {
    setAlert({ type: 'success', message: `Saved buyer info for ${buyerModal.plot?.label}.` });
    closeBuyerModal();
  };

  const filteredPlotsExist = filteredPlots.length > 0;

  return (
    <Box sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 }, display: 'flex', flexDirection: 'column', gap: 3 }}>

      <Sheet sx={{ ...heroSx }}>
        <Stack spacing={1}>
          <Chip variant="soft" color="primary" sx={{ alignSelf: 'flex-start', textTransform: 'uppercase' }}>
            Multi-plot Sales Admin
          </Chip>
          <Typography level="h2" sx={{ fontWeight: 700 }}>
            Multi-plot sales command center
          </Typography>
          <Typography level="body-lg" sx={{ maxWidth: 520 }}>
            {HERO_DESCRIPTION}
          </Typography>
        </Stack>
      </Sheet>


      {alert && (

        <Alert color={alert.type} variant="soft" sx={{ borderRadius: '18px' }}>
          {alert.message}
        </Alert>

      )}


      <Sheet sx={{ ...baseGlassSx, p: 2 }}>
        <Stack direction="row" spacing={1} flexWrap="wrap" alignItems="flex-end">
          <Select
            value={selectedProjectId}
            onChange={(event, value) => setSelectedProjectId(value)}
            disabled={projectChoicesLoading}
            placeholder={projectChoicesLoading ? 'Loading projects...' : 'Select project'}
            sx={{ minWidth: 220 }}
          >
            <Option value="">Select project</Option>
            {projectChoices.map((project) => (
              <Option key={project.id} value={project.id}>
                {project.name}
              </Option>
            ))}
          </Select>
          <Button
            variant="solid"
            color="primary"
            onClick={handleLoadPlots}
            disabled={!selectedProjectId || loading}
          >
            {loading ? 'Loading project...' : 'Load project'}
          </Button>
          {lastLoadedProjectId && (
            <Chip variant="soft" color="success" startDecorator={<i className="ri-check-line" />}>
              Loaded: {lastLoadedProject?.name || lastLoadedProject?.code || 'Project'}
            </Chip>
          )}
        </Stack>
        {!lastLoadedProjectId && (
          <Typography level="body-sm" color="neutral" sx={{ mt: 1 }}>
            Choose a project and click Load project to bring its multi-plot matrix into view.
          </Typography>
        )}
      </Sheet>



      <Sheet sx={{ ...baseGlassSx, p: { xs: 2, md: 3 } }}>
        <Grid container spacing={2} alignItems="flex-end">
          <Grid xs={12} md={4}>
            <FormControl>
              <FormLabel>Search plots, projects, or zones</FormLabel>
              <Input
                value={filters.search}
                onChange={(e) => handleFilterChange('search', e.target.value)}
                placeholder="Plot 502 / North"
              />
            </FormControl>
          </Grid>
          <Grid xs={12} md={8}>
            <Grid container spacing={2}>
              <Grid xs={6} md={3}>
                <FormControl>
                  <FormLabel>Stage</FormLabel>
                  <Select value={filters.stage} onChange={(event, value) => handleFilterChange('stage', value)}>
                    <Option value="all">All stages</Option>
                    {stageOptions.map((stage) => (
                      <Option key={stage} value={stage}>
                        {humanize(stage)}
                      </Option>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid xs={6} md={3}>
                <FormControl>
                  <FormLabel>Status</FormLabel>
                  <Select value={filters.status} onChange={(event, value) => handleFilterChange('status', value)}>
                    <Option value="all">All statuses</Option>
                    {Object.keys(STATUS_META).map((status) => (
                      <Option key={status} value={status}>
                        {STATUS_META[status].label}
                      </Option>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid xs={6} md={2}>
                <FormControl>
                  <FormLabel>Facing</FormLabel>
                  <Select value={filters.facing} onChange={(event, value) => handleFilterChange('facing', value)}>
                    <Option value="all">All</Option>
                    {facingOptions.map((facing) => (
                      <Option key={facing} value={facing}>
                        {facing}
                      </Option>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid xs={6} md={2}>
                <FormControl>
                  <FormLabel>Zone</FormLabel>
                  <Select value={filters.zone} onChange={(event, value) => handleFilterChange('zone', value)}>
                    <Option value="all">All zones</Option>
                    {zoneOptions.map((zoneId) => (
                      <Option key={zoneId} value={zoneId}>
                        Zone {zoneId}
                      </Option>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid xs={6} md={2}>
                <FormControl>
                  <FormLabel>Floor</FormLabel>
                  <Select value={filters.floor} onChange={(event, value) => handleFilterChange('floor', value)}>
                    <Option value="all">All floors</Option>
                    {floorOptions.map((floor) => (
                      <Option key={floor} value={floor}>
                        Floor {floor}
                      </Option>
                    ))}
                  </Select>
                </FormControl>
              </Grid>
              <Grid xs={12} sx={{ display: 'flex', gap: 1 }}>
                <Button color="neutral" variant="plain" onClick={handleResetFilters}>
                  Reset filters
                </Button>
                <Button variant="solid" color="primary" loading={loading} onClick={handleRefresh}>
                  Refresh data
                </Button>
              </Grid>
            </Grid>
          </Grid>
        </Grid>
      </Sheet>



      <Grid container spacing={2}>
        <Grid xs={12} sm={6} md={3}>
          <Sheet sx={{ ...baseGlassSx, p: 2 }}>
            <Typography level="body-sm" color="neutral">Plots visible</Typography>
            <Typography level="h4" sx={{ fontWeight: 600 }}>{summary.total}</Typography>
          </Sheet>
        </Grid>
        <Grid xs={12} sm={6} md={3}>
          <Sheet sx={{ ...baseGlassSx, p: 2 }}>
            <Typography level="body-sm" color="neutral">Available</Typography>
            <Typography level="h4" sx={{ fontWeight: 600 }}>{summary.available}</Typography>
          </Sheet>
        </Grid>
        <Grid xs={12} sm={6} md={2}>
          <Sheet sx={{ ...baseGlassSx, p: 2 }}>
            <Typography level="body-sm" color="neutral">Hold</Typography>
            <Typography level="h4" sx={{ fontWeight: 600 }}>{summary.hold}</Typography>
          </Sheet>
        </Grid>
        <Grid xs={12} sm={6} md={2}>
          <Sheet sx={{ ...baseGlassSx, p: 2 }}>
            <Typography level="body-sm" color="neutral">Booked</Typography>
            <Typography level="h4" sx={{ fontWeight: 600 }}>{summary.booked}</Typography>
          </Sheet>
        </Grid>
        <Grid xs={12} sm={6} md={2}>
          <Sheet sx={{ ...baseGlassSx, p: 2 }}>
            <Typography level="body-sm" color="neutral">Sold</Typography>
            <Typography level="h4" sx={{ fontWeight: 600 }}>{summary.sold}</Typography>
          </Sheet>
        </Grid>
      </Grid>



      <Box display="flex" justifyContent="space-between" alignItems="center" flexWrap="wrap" gap={2}>
        <Typography level="h5">Active projects</Typography>
        {!filteredPlotsExist && (
          <Typography level="body-sm" color="neutral">
            {projects.length
              ? 'Filters hid every plot. Adjust stage/status or reset to see the grid again.'
              : 'Select a project and click Load project to view its plots.'}
          </Typography>
        )}
      </Box>
      <Grid container direction="column" spacing={3} sx={{ mt: 1 }}>
        {visibleProjects.map((project) => (
          <Grid key={project.id}>
            <MultiPlotProjectPanel
              project={project}
              plots={filteredPlots}
              templateControls={templateControls}
              onTemplateChange={handleTemplateChange}
              onTemplateSave={handleTemplateSave}
              onOpenBuyer={openBuyerModal}
            />
          </Grid>
        ))}
      </Grid>
      {!visibleProjects.length && (
        <Box sx={{ py: 8, textAlign: 'center' }}>
          <Typography level="h6" color="neutral">
            {projects.length ? 'Nothing matches the search term yet.' : 'Load a project to see its grid.'}
          </Typography>
        </Box>
      )}


      <MultiPlotBuyerModal open={buyerModal.open} plot={buyerModal.plot} onClose={closeBuyerModal} onSave={handleBuyerSave} />
    </Box>
  );
};

export default MultiPlotSales;

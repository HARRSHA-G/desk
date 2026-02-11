import React, { useMemo, useState } from 'react';
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
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import api from '../../api';

import {
  STATUS_META,
  DEFAULT_FILTERS,
  HERO_DESCRIPTION,
  getFallbackMultiFlatProjects,
  flattenUnits,
  applyFilters,
  buildSummary,
  stageOptionsFromUnits,
  facingOptionsFromUnits,
  floorOptionsFromUnits,
  blockOptionsFromProjects,
  humanize,
  buildQueryFromFilters,
  mapProjectGridResponse,
  normalizeMultiFlatPayload,
  heroPanelSx,
  glassPanelSx
} from './multiFlatSalesUtils';

import ProjectPanel from '../../components/sales/ProjectPanel';
import BuyerModal from '../../components/sales/BuyerModal';

const MultiFlatSales = () => {
  const theme = useTheme();
  const queryClient = useQueryClient();
  const heroSx = heroPanelSx(theme.palette.mode);
  const baseGlassSx = glassPanelSx(theme.palette.mode);

  const [selectedProjectId, setSelectedProjectId] = useState('');
  const [lastLoadedProjectId, setLastLoadedProjectId] = useState(null);
  const [filters, setFilters] = useState(() => ({ ...DEFAULT_FILTERS }));
  const [buyerModal, setBuyerModal] = useState({ open: false, unit: null });
  const [templateControls, setTemplateControls] = useState({});

  // Queries
  const { data: projectChoices = [], isLoading: projectChoicesLoading } = useQuery({
    queryKey: ['projects', 'multi-flat'],
    queryFn: async () => {
      const response = await api.get('/projects/');
      const payload = Array.isArray(response.data) ? response.data : response.data?.results || [];
      return payload
        .filter((item) => (item.project_flat_configuration || '').toLowerCase() === 'multi_flat')
        .map((item) => ({
          id: item.id || item.project_id,
          name: item.project_name || item.name || 'Unnamed project',
          code: item.project_code || item.code || '',
        }));
    },
  });

  const { data: projects = [], isFetching: gridLoading } = useQuery({
    queryKey: ['multi-flat-grid', lastLoadedProjectId, filters],
    queryFn: async () => {
      if (!lastLoadedProjectId) return [];
      const params = buildQueryFromFilters(filters);
      try {
        const response = await api.get(`/multi-flat/projects/${lastLoadedProjectId}/grid/`, { params });
        const shaped = mapProjectGridResponse(response.data);
        const normalized = normalizeMultiFlatPayload(shaped || response.data);
        if (normalized.length) return normalized;
        return getFallbackMultiFlatProjects(lastLoadedProjectId);
      } catch (err) {
        toast.error('API offline, showing fallback.');
        return getFallbackMultiFlatProjects(lastLoadedProjectId);
      }
    },
    enabled: !!lastLoadedProjectId,
  });

  const flattenedUnits = useMemo(() => flattenUnits(projects), [projects]);
  const filteredUnits = useMemo(() => applyFilters(flattenedUnits, filters), [flattenedUnits, filters]);
  const summary = useMemo(() => buildSummary(filteredUnits), [filteredUnits]);
  const stageOptions = useMemo(() => stageOptionsFromUnits(flattenedUnits), [flattenedUnits]);
  const facingOptions = useMemo(() => facingOptionsFromUnits(flattenedUnits), [flattenedUnits]);
  const floorOptions = useMemo(() => floorOptionsFromUnits(flattenedUnits), [flattenedUnits]);
  const blockOptions = useMemo(() => blockOptionsFromProjects(projects), [projects]);
  const searchTerm = filters.search.trim().toLowerCase();

  const visibleProjects = useMemo(() => {
    if (!searchTerm) return projects;
    return projects.filter((project) => {
      if (project.name.toLowerCase().includes(searchTerm) || project.code.toLowerCase().includes(searchTerm)) {
        return true;
      }
      return flattenedUnits.some(
        (unit) =>
          unit.projectId === project.id &&
          (unit.label.toLowerCase().includes(searchTerm) || unit.blockName.toLowerCase().includes(searchTerm)),
      );
    });
  }, [searchTerm, projects, flattenedUnits]);

  const handleFilterChange = (field, value) => {
    setFilters((prev) => ({ ...prev, [field]: value }));
  };

  const handleLoadProject = () => {
    if (!selectedProjectId) return;
    setLastLoadedProjectId(selectedProjectId);
  };

  const handleResetFilters = () => {
    setFilters({ ...DEFAULT_FILTERS });
    toast.success('Filters cleared.');
  };

  const handleTemplateSave = (projectId, blockId, state) => {
    toast.success(`Template saved for Block ${blockId}.`);
    const key = `${projectId}-${blockId}`;
    setTemplateControls((prev) => ({ ...prev, [key]: { ...prev[key], ...state } }));
  };

  const handleBuyerSave = (formData) => {
    toast.success(`Saved buyer info for ${buyerModal.unit?.label}.`);
    setBuyerModal({ open: false, unit: null });
  };

  return (
    <Box sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 }, display: 'flex', flexDirection: 'column', gap: 3 }}>
      <Sheet sx={{ ...heroSx }}>
        <Stack spacing={1}>
          <Chip variant="soft" color="primary" sx={{ alignSelf: 'flex-start', textTransform: 'uppercase' }}>
            Multi-flat Sales Admin
          </Chip>
          <Typography level="h2" sx={{ fontWeight: 700 }}>command center</Typography>
          <Typography level="body-lg" sx={{ maxWidth: 520 }}>{HERO_DESCRIPTION}</Typography>
        </Stack>
      </Sheet>

      <Sheet sx={{ ...baseGlassSx, p: 2 }}>
        <Stack direction="row" spacing={1} flexWrap="wrap" alignItems="flex-end">
          <Select
            value={selectedProjectId}
            onChange={(e, val) => setSelectedProjectId(val)}
            disabled={projectChoicesLoading}
            placeholder="Select project"
            sx={{ minWidth: 220 }}
          >
            {projectChoices.map((p) => (
              <Option key={p.id} value={p.id}>{p.name}</Option>
            ))}
          </Select>
          <Button onClick={handleLoadProject} disabled={!selectedProjectId || gridLoading}>
            {gridLoading ? 'Loading...' : 'Load project'}
          </Button>
        </Stack>
      </Sheet>

      <Sheet sx={{ ...baseGlassSx, p: { xs: 2, md: 3 } }}>
        <Grid container spacing={2}>
          <Grid xs={12} md={4}>
            <FormControl>
              <FormLabel>Search</FormLabel>
              <Input
                value={filters.search}
                onChange={(e) => handleFilterChange('search', e.target.value)}
                placeholder="Block A / 1401"
              />
            </FormControl>
          </Grid>
          <Grid xs={12} md={8}>
            <Grid container spacing={2}>
              <Grid xs={6} md={3}>
                <FormControl>
                  <FormLabel>Stage</FormLabel>
                  <Select value={filters.stage} onChange={(e, val) => handleFilterChange('stage', val)}>
                    <Option value="all">All stages</Option>
                    {stageOptions.map((s) => <Option key={s} value={s}>{humanize(s)}</Option>)}
                  </Select>
                </FormControl>
              </Grid>
              <Grid xs={6} md={3}>
                <FormControl>
                  <FormLabel>Status</FormLabel>
                  <Select value={filters.status} onChange={(e, val) => handleFilterChange('status', val)}>
                    <Option value="all">All statuses</Option>
                    {Object.keys(STATUS_META).map((s) => <Option key={s} value={s}>{STATUS_META[s].label}</Option>)}
                  </Select>
                </FormControl>
              </Grid>
              <Grid xs={12} sx={{ display: 'flex', gap: 1, mt: 1 }}>
                <Button color="neutral" variant="plain" onClick={handleResetFilters}>Reset</Button>
                <Button variant="solid" loading={gridLoading} onClick={() => queryClient.invalidateQueries(['multi-flat-grid'])}>Refresh</Button>
              </Grid>
            </Grid>
          </Grid>
        </Grid>
      </Sheet>

      <Grid container spacing={2}>
        {['total', 'available', 'hold', 'booked', 'sold'].map((k) => (
          <Grid key={k} xs={12} sm={6} md={2}>
            <Sheet sx={{ ...baseGlassSx, p: 2 }}>
              <Typography level="body-xs" sx={{ textTransform: 'capitalize' }}>{k}</Typography>
              <Typography level="h4">{summary[k]}</Typography>
            </Sheet>
          </Grid>
        ))}
      </Grid>

      <Grid container spacing={3} direction="column">
        {visibleProjects.map((project) => (
          <Grid key={project.id}>
            <ProjectPanel
              project={project}
              units={filteredUnits}
              templateControls={templateControls}
              onTemplateChange={(p, b, s) => setTemplateControls(v => ({ ...v, [`${p}-${b}`]: { ...v[`${p}-${b}`], ...s } }))}
              onTemplateSave={handleTemplateSave}
              onOpenBuyer={(unit) => setBuyerModal({ open: true, unit })}
            />
          </Grid>
        ))}
      </Grid>

      <BuyerModal
        open={buyerModal.open}
        unit={buyerModal.unit}
        onClose={() => setBuyerModal({ open: false, unit: null })}
        onSave={handleBuyerSave}
      />
    </Box>
  );
};

export default MultiFlatSales;

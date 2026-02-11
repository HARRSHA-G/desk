import React, { useMemo, useState } from 'react';
import {
  Box,
  Button,
  FormControl,
  FormLabel,
  Grid,
  Input,
  Option,
  Select,
  Sheet,
  Typography,
} from '@mui/joy';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import api from '../../api';
import PageHeader from '../../components/PageHeader';

import ProjectCard from '../../components/projects/ProjectCard';
import ProjectsSkeleton from '../../components/projects/ProjectsSkeleton';
import ProjectFormModal from '../../components/projects/ProjectFormModal';

import {
  FALLBACK_PROJECTS,
  DEFAULT_FORM_DATA,
  PERMISSION_REQUIREMENTS,
  MULTI_UNIT_LAYOUTS,
  normalizeLayoutKey,
  mapProjectToForm,
  buildPermissionStateFromMap,
  buildPermissionMapFromState,
  buildProjectRecordFromForm,
} from './projectUtils';

const Projects = () => {
  const queryClient = useQueryClient();
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [layoutFilter, setLayoutFilter] = useState('all');

  const [projectModal, setProjectModal] = useState({
    open: false,
    mode: 'create',
    project: null,
  });

  // Queries
  const { data: projects = [], isLoading: projectsLoading } = useQuery({
    queryKey: ['projects'],
    queryFn: async () => {
      const res = await api.get('/projects/');
      const data = Array.isArray(res.data) ? res.data : res.data?.results || [];
      return data.map((p) => ({
        id: p.id || p.project_id,
        code: p.project_code || p.code || 'N/A',
        name: p.project_name || p.name || 'Untitled',
        status: (p.project_status || p.status || 'Planning').toLowerCase(),
        layout: p.project_flat_configuration_label || p.flat_configuration_label || '-',
        layoutKey: (p.project_flat_configuration || '').toLowerCase(),
        budget: Number(p.estimated_budget || p.project_budget || 0),
        paid: Number(p.project_total_paid || 0),
        remaining: Number(p.project_remaining_amount || 0),
        customer: p.assigned_customer_name || p.project_assigned_customer?.customer_name || 'Not assigned',
        supervisor: p.assigned_supervisor_name || p.project_assigned_supervisor?.supervisor_name || 'Not assigned',
        landAddress: p.project_land_address || p.land_address || '',
        landArea: p.project_land_area_square_feet || p.land_area_square_feet || '',
        constructionType: p.project_construction_type || p.construction_type || '',
        permissionMap: p.project_permission_status_map || p.permission_status_map || {},
        duration: p.project_duration_months || '',
      }));
    },
    initialData: FALLBACK_PROJECTS,
  });

  const { data: choices = { supervisors: [], customers: [] } } = useQuery({
    queryKey: ['choices'],
    queryFn: async () => {
      const [supRes, custRes] = await Promise.all([
        api.get('/choices/supervisors/').catch(() => ({ data: [] })),
        api.get('/choices/customers/').catch(() => ({ data: [] })),
      ]);
      return {
        supervisors: Array.isArray(supRes.data) ? supRes.data : [],
        customers: Array.isArray(custRes.data) ? custRes.data : [],
      };
    },
  });

  // Mutations
  const saveMutation = useMutation({
    mutationFn: async (payload) => {
      if (projectModal.mode === 'create') {
        return api.post('/projects/', payload);
      }
      return api.patch(`/projects/${projectModal.project.id}/`, payload);
    },
    onSuccess: () => {
      toast.success(`Project ${projectModal.mode === 'create' ? 'created' : 'updated'} successfully.`);
      queryClient.invalidateQueries(['projects']);
      closeProjectModal();
    },
    onError: (err) => {
      console.error('Save failed', err);
      toast.error('Failed to save project.');
    },
  });

  const filteredProjects = useMemo(() => {
    return projects.filter((p) => {
      const matchesSearch =
        p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        (p.code || '').toLowerCase().includes(searchQuery.toLowerCase());
      const matchesStatus = statusFilter === 'all' || (p.status || '').toLowerCase() === statusFilter;
      const matchesLayout = layoutFilter === 'all' || (p.layoutKey || '').includes(layoutFilter);
      return matchesSearch && matchesStatus && matchesLayout;
    });
  }, [projects, searchQuery, statusFilter, layoutFilter]);

  const closeProjectModal = () => {
    setProjectModal({ open: false, mode: 'create', project: null });
  };

  const openCreateProjectModal = () => {
    setProjectModal({ open: true, mode: 'create', project: null });
  };

  const openEditProjectModal = (project) => {
    setProjectModal({ open: true, mode: 'edit', project });
  };

  const handleModalSubmit = (formValues, permState) => {
    const permissionMap = buildPermissionMapFromState(permState);
    const layoutKey = normalizeLayoutKey(formValues.layout);
    const isMultiLayout = MULTI_UNIT_LAYOUTS.includes(layoutKey);

    const payload = {
      project_name: formValues.name || 'Untitled Project',
      project_code: formValues.code,
      project_status: formValues.status,
      project_flat_configuration: layoutKey,
      project_construction_type: formValues.constructionType,
      project_land_address: formValues.landAddress,
      project_land_area_square_feet: Number(formValues.landArea || 0),
      project_budget: Number(formValues.budget || 0),
      project_duration_months: Number(formValues.duration || 0),
      project_assigned_customer: isMultiLayout ? null : formValues.customer || null,
      project_assigned_supervisor: isMultiLayout ? null : formValues.supervisor || null,
      project_permission_status_map: permissionMap,
    };
    saveMutation.mutate(payload);
  };

  return (
    <Box component="main" sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 } }}>
      <PageHeader title="Projects Management" />

      <Box component="header" sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3, flexWrap: 'wrap', gap: 2 }}>
        <Box>
          <Typography level="h2" component="h1">Projects</Typography>
          <Typography level="body-md" color="neutral">All your construction projects in one place.</Typography>
        </Box>
        <Button
          startDecorator={<i className="ri-add-line" />}
          size="lg"
          onClick={openCreateProjectModal}
        >
          New Project
        </Button>
      </Box>

      <Sheet
        variant="outlined"
        sx={{
          p: 2,
          mb: 3,
          borderRadius: 'lg',
          display: 'flex',
          gap: 2,
          flexWrap: 'wrap',
          alignItems: 'center',
          bgcolor: 'background.surface'
        }}
      >
        <FormControl sx={{ flex: 1, minWidth: 200 }}>
          <FormLabel>Search</FormLabel>
          <Input
            placeholder="Search by name or code..."
            startDecorator={<i className="ri-search-line" />}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </FormControl>

        <FormControl sx={{ minWidth: 160 }}>
          <FormLabel>Status</FormLabel>
          <Select
            value={statusFilter}
            onChange={(e, val) => setStatusFilter(val)}
          >
            <Option value="all">All Statuses</Option>
            <Option value="planning">Planning</Option>
            <Option value="active">Active</Option>
            <Option value="completed">Completed</Option>
            <Option value="on_hold">On Hold</Option>
            <Option value="cancelled">Cancelled</Option>
          </Select>
        </FormControl>

        <FormControl sx={{ minWidth: 160 }}>
          <FormLabel>Layout</FormLabel>
          <Select
            value={layoutFilter}
            onChange={(e, val) => setLayoutFilter(val)}
          >
            <Option value="all">All Layouts</Option>
            <Option value="single_flat">Single Unit</Option>
            <Option value="multi_flat">Multi Flat</Option>
            <Option value="multi_plot">Multi Plot</Option>
          </Select>
        </FormControl>
      </Sheet>

      {projectsLoading && !projects.length ? (
        <ProjectsSkeleton />
      ) : (
        <Grid container spacing={2}>
          {filteredProjects.map((project) => (
            <Grid key={project.id} xs={12} sm={6} lg={3} xl={3}>
              <ProjectCard project={project} onClick={() => openEditProjectModal(project)} />
            </Grid>
          ))}
          {filteredProjects.length === 0 && (
            <Box sx={{ width: '100%', textAlign: 'center', py: 8 }}>
              <Typography level="h4" color="neutral">No projects found.</Typography>
            </Box>
          )}
        </Grid>
      )}

      {projectModal.open && (
        <ProjectFormModal
          mode={projectModal.mode}
          open={projectModal.open}
          onClose={closeProjectModal}
          project={projectModal.project}
          onSubmit={handleModalSubmit}
          saving={saveMutation.isLoading}
          supervisors={choices.supervisors}
          customers={choices.customers}
        />
      )}
    </Box>
  );
};

export default Projects;

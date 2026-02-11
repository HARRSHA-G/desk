import React, { useMemo, useState, useEffect } from 'react';
import {
  Box,
  Button,
  Card,
  Divider,
  FormControl,
  FormLabel,
  Grid,
  Option,
  Select,
  Stack,
  Typography,
} from '@mui/joy';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import api from '../../api';
import { formatCurrency, normalizeProjects, normalizeStockEntries } from './stockUtils';
import StockEntryCard from '../../components/stock/StockEntryCard';

const StockManagement = () => {
  const queryClient = useQueryClient();
  const [selectedProjectId, setSelectedProjectId] = useState('');
  const [stockEntries, setStockEntries] = useState([]);

  // Projects Query
  const { data: projects = [] } = useQuery({
    queryKey: ['projects'],
    queryFn: async () => {
      const response = await api.get('/projects/');
      const list = Array.isArray(response.data) ? response.data : [];
      return normalizeProjects(list);
    },
  });

  // Stock Query (Lazy loaded on button click or enabled by state)
  const [fetchStock, setFetchStock] = useState(false);
  const { isFetching: loading } = useQuery({
    queryKey: ['stock', selectedProjectId],
    queryFn: async () => {
      const response = await api.get(`/stock/${selectedProjectId}/`);
      const entries = Array.isArray(response.data) ? response.data : [];
      const normalized = normalizeStockEntries(entries);
      setStockEntries(normalized);
      toast.success('Stock data loaded.');
      return normalized;
    },
    enabled: fetchStock && !!selectedProjectId,
    onSettled: () => setFetchStock(false),
  });

  // Save Mutation
  const saveMutation = useMutation({
    mutationFn: async () => {
      return api.post(`/stock/${selectedProjectId}/adjustments/`, {
        adjustments: stockEntries.map((entry) => ({
          id: entry.id,
          total: entry.total,
          used: entry.used,
        })),
      });
    },
    onSuccess: () => {
      toast.success('Stock adjustments saved successfully.');
      queryClient.invalidateQueries(['stock', selectedProjectId]);
    },
    onError: () => {
      toast.error('Unable to save adjustments.');
    },
  });

  const handleStockChange = (entryId, field, nextValue) => {
    const parsed = parseFloat(nextValue);
    setStockEntries((prev) =>
      prev.map((entry) => {
        if (entry.id !== entryId) return entry;
        const updated = { ...entry };
        if (field === 'total') {
          updated.total = Number.isNaN(parsed) || parsed < 0 ? 0 : parsed;
          if (updated.used > updated.total) updated.used = updated.total;
        }
        if (field === 'used') {
          updated.used = Number.isNaN(parsed) || parsed < 0 ? 0 : parsed;
          if (updated.used > updated.total) updated.used = updated.total;
        }
        return updated;
      })
    );
  };

  const summary = useMemo(() => {
    const allocated = stockEntries.reduce((sum, entry) => sum + (entry.total || 0), 0);
    const used = stockEntries.reduce((sum, entry) => sum + (entry.used || 0), 0);
    return { allocated, used, remaining: Math.max(0, allocated - used) };
  }, [stockEntries]);

  return (
    <Box sx={{ p: { xs: 2, md: 3 }, maxWidth: 1100, mx: 'auto' }}>
      <Card variant="outlined" sx={{ borderRadius: 'xl', p: { xs: 2, md: 3 }, mb: 3 }}>
        <Stack spacing={2}>
          <Typography level="h3">Stock Management</Typography>
          <Typography level="body-md" color="neutral">
            Manage material inventory. Set the allocated stock for this project and track usage.
          </Typography>
          <Grid container spacing={2} alignItems="center">
            <Grid xs={12} md={6}>
              <FormControl>
                <FormLabel>Project</FormLabel>
                <Select
                  placeholder="Select project"
                  value={selectedProjectId}
                  onChange={(e, value) => {
                    setSelectedProjectId(value);
                    setStockEntries([]); // Reset entries when project changes
                  }}
                >
                  {projects.map((project) => (
                    <Option key={project.id} value={project.id}>
                      {project.name} {project.code ? `(${project.code})` : ''}
                    </Option>
                  ))}
                </Select>
              </FormControl>
            </Grid>
            <Grid xs={12} md={6} sx={{ display: 'flex', gap: 1 }}>
              <Button
                variant="solid"
                onClick={() => setFetchStock(true)}
                loading={loading}
                disabled={!selectedProjectId}
              >
                Load Stock
              </Button>
              <Button
                variant="plain"
                disabled={!stockEntries.length}
                onClick={() => saveMutation.mutate()}
                loading={saveMutation.isLoading}
              >
                Save Changes
              </Button>
            </Grid>
          </Grid>

          {stockEntries.length > 0 && (
            <>
              <Divider />
              <Stack direction="row" spacing={2} flexWrap="wrap">
                <Typography level="body-sm">Total Allocated: {formatCurrency(summary.allocated)}</Typography>
                <Typography level="body-sm">Total Used: {formatCurrency(summary.used)}</Typography>
                <Typography level="body-sm">Total Remaining: {formatCurrency(summary.remaining)}</Typography>
              </Stack>
            </>
          )}
        </Stack>
      </Card>

      {stockEntries.length > 0 && (
        <Stack spacing={2}>
          {stockEntries.map((entry) => (
            <StockEntryCard key={entry.id} entry={entry} onStockChange={handleStockChange} />
          ))}
        </Stack>
      )}
    </Box>
  );
};

export default StockManagement;

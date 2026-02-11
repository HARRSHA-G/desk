import React, { useState, useMemo } from 'react';
import {
  Box,
  Button,
  Card,
  Chip,
  Divider,
  IconButton,
  Modal,
  ModalClose,
  ModalDialog,
  Sheet,
  Stack,
  Table,
  Typography,
  Grid,
} from '@mui/joy';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import api from '../../api';

import {
  formatCurrency,
  normalizeProject,
  handleExportExcel,
  handleExportPDF,
} from './trackFinancesUtils';

import FiltersPanel from '../../components/finance/FiltersPanel';
import ExportButtons from '../../components/finance/ExportButtons';

const TrackFinances = () => {
  const queryClient = useQueryClient();
  const [selectedProject, setSelectedProject] = useState('');
  const [fromDateIso, setFromDateIso] = useState('');
  const [toDateIso, setToDateIso] = useState('');
  const [activeTab, setActiveTab] = useState('payments');

  // Multi-step query state
  const [searchParams, setSearchParams] = useState(null);

  // Fetch Projects
  const { data: projects = [] } = useQuery({
    queryKey: ['projects'],
    queryFn: async () => {
      const res = await api.get('/projects/');
      const data = Array.isArray(res.data) ? res.data : res.data?.results || [];
      return data.map(normalizeProject);
    },
  });

  // Fetch Expenses
  const { data: financeData, isLoading: isFinanceLoading } = useQuery({
    queryKey: ['expenses', searchParams],
    queryFn: async () => {
      const { projectId, startDate, endDate } = searchParams;
      const params = new URLSearchParams();
      if (startDate) params.set('start_date', startDate);
      if (endDate) params.set('end_date', endDate);
      const url = `/track-expenses/${projectId}/${params.toString() ? `?${params.toString()}` : ''}`;
      const res = await api.get(url);
      const data = res.data || {};

      // Process and normalize in queryFn
      const payments = (data.payments || []).map((p) => ({ ...p, amountNum: Number(p.amount) || 0 }));
      const manpower = (data.manpower_expenses || []).map((m) => ({ ...m, amountNum: Number(m.total_amount) || 0 }));
      const material = (data.material_expenses || []).map((m) => {
        const qty = Number(m.quantity ?? m.material_expense_quantity) || 0;
        const unit = Number(m.per_unit_cost ?? m.material_expense_per_unit_cost) || 0;
        return {
          ...m,
          custom_item_name: m.material_name || m.custom_item_name,
          quantity: qty,
          per_unit_cost: unit,
          amountNum: Number(m.total_amount ?? m.material_expense_total_amount) || qty * unit,
        };
      });
      const departmental = (data.departmental_expenses || []).map((d) => ({ ...d, amountNum: Number(d.amount) || 0 }));
      const administration = (data.administration_expenses || []).map((d) => ({ ...d, amountNum: Number(d.amount) || 0 }));

      return {
        payments,
        manpower,
        material,
        departmental,
        administration,
        totals: {
          payments: payments.reduce((s, x) => s + x.amountNum, 0),
          manpower: manpower.reduce((s, x) => s + x.amountNum, 0),
          material: material.reduce((s, x) => s + x.amountNum, 0),
          departmental: departmental.reduce((s, x) => s + x.amountNum, 0),
          administration: administration.reduce((s, x) => s + x.amountNum, 0),
        },
      };
    },
    enabled: !!searchParams,
  });

  // Delete Mutation
  const deleteMutation = useMutation({
    mutationFn: async ({ kind, id }) => {
      const url = kind === 'payment' ? `/delete-payment/${id}/` : `/delete-expense/${kind}/${id}/`;
      return api.delete(url);
    },
    onSuccess: (_, variables) => {
      toast.success(`${variables.label || 'Item'} deleted.`);
      queryClient.invalidateQueries(['expenses']);
      setDeleteState({ open: false, kind: null, id: null, label: '' });
    },
    onError: () => {
      toast.error('Could not delete record.');
    },
  });

  const [deleteState, setDeleteState] = useState({
    open: false,
    kind: null,
    id: null,
    label: '',
  });

  const handleGenerate = () => {
    if (!selectedProject) {
      toast.error('Please select a project first.');
      return;
    }
    if (fromDateIso && toDateIso && fromDateIso > toDateIso) {
      toast.error('From date must be before To date.');
      return;
    }
    setSearchParams({ projectId: selectedProject, startDate: fromDateIso, endDate: toDateIso });
  };

  const openDelete = (kind, id, label) => {
    setDeleteState({ open: true, kind, id, label });
  };

  const onExportExcel = () => {
    if (!financeData) return;
    const { payments, manpower, material, departmental, administration } = financeData;
    handleExportExcel(
      payments,
      manpower,
      material,
      departmental,
      administration,
      projects,
      selectedProject,
      fromDateIso,
      toDateIso,
      (msg, type) => (type === 'danger' ? toast.error(msg) : toast.success(msg))
    );
  };

  const onExportPDF = () => {
    if (!financeData) return;
    const { payments, manpower, material, departmental, administration, totals } = financeData;
    handleExportPDF(
      payments,
      manpower,
      material,
      departmental,
      administration,
      projects,
      selectedProject,
      fromDateIso,
      toDateIso,
      totals,
      (msg, type) => (type === 'danger' ? toast.error(msg) : toast.success(msg))
    );
  };

  const renderTable = (data, columns, kind) => (
    <Box sx={{ overflowX: 'auto' }}>
      <Table hoverRow stickyHeader>
        <thead>
          <tr>
            {columns.map((c, i) => (
              <th key={i} style={c.style}>
                {c.label}
              </th>
            ))}
            <th style={{ width: 100, textAlign: 'right' }}>Action</th>
          </tr>
        </thead>
        <tbody>
          {data.length === 0 ? (
            <tr>
              <td colSpan={columns.length + 1} style={{ textAlign: 'center', padding: '2rem', color: 'gray' }}>
                No records found.
              </td>
            </tr>
          ) : (
            data.map((row, idx) => (
              <tr key={row.id || idx}>
                {columns.map((c, i) => (
                  <td key={i}>{c.render ? c.render(row) : row[c.key] || '-'}</td>
                ))}
                <td style={{ textAlign: 'right' }}>
                  <IconButton
                    size="sm"
                    color="danger"
                    variant="plain"
                    disabled={deleteMutation.isLoading}
                    onClick={() => openDelete(kind, row.id, 'Item')}
                  >
                    <i className="ri-delete-bin-line" />
                  </IconButton>
                </td>
              </tr>
            ))
          )}
        </tbody>
      </Table>
    </Box>
  );

  return (
    <Box sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 } }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography level="h2">Track Finances</Typography>
      </Box>

      <FiltersPanel
        projects={projects}
        selectedProject={selectedProject}
        setSelectedProject={setSelectedProject}
        fromDateIso={fromDateIso}
        setFromDateIso={setFromDateIso}
        toDateIso={toDateIso}
        setToDateIso={setToDateIso}
        handleGenerate={handleGenerate}
        loading={isFinanceLoading}
      />

      {financeData && (
        <>
          <Grid container spacing={2}>
            <Grid xs={12} md={3} lg={2}>
              <Stack spacing={1}>
                {[
                  { id: 'payments', label: 'Payments', icon: 'ri-bank-card-line' },
                  { id: 'manpower', label: 'Manpower', icon: 'ri-group-line' },
                  { id: 'material', label: 'Material', icon: 'ri-tools-line' },
                  { id: 'departmental', label: 'Departmental', icon: 'ri-briefcase-2-line' },
                  { id: 'administration', label: 'Admin', icon: 'ri-file-list-3-line' },
                ].map((tab) => (
                  <Button
                    key={tab.id}
                    variant={activeTab === tab.id ? 'solid' : 'plain'}
                    color={activeTab === tab.id ? 'primary' : 'neutral'}
                    startDecorator={<i className={tab.icon} />}
                    onClick={() => setActiveTab(tab.id)}
                    sx={{ justifyContent: 'flex-start' }}
                  >
                    {tab.label}
                  </Button>
                ))}
              </Stack>
            </Grid>

            <Grid xs={12} md={9} lg={10}>
              <div id="finance-report-content">
                <Sheet variant="outlined" sx={{ p: 0, borderRadius: 'lg', overflow: 'hidden' }}>
                  <Box
                    sx={{
                      p: 2,
                      borderBottom: '1px solid',
                      borderColor: 'divider',
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center',
                      bgcolor: 'background.level1',
                    }}
                  >
                    <Stack direction="row" spacing={1} alignItems="center">
                      <i className="ri-file-list-2-line" />
                      <Typography level="title-lg" style={{ textTransform: 'capitalize' }}>
                        {activeTab}
                      </Typography>
                    </Stack>
                    <Chip variant="soft" color="success" size="lg">
                      Total: {formatCurrency(financeData.totals[activeTab])}
                    </Chip>
                  </Box>

                  {activeTab === 'payments' &&
                    renderTable(
                      financeData.payments,
                      [
                        { label: 'Date', key: 'payment_date' },
                        { label: 'Type', key: 'payment_type' },
                        { label: 'Mode', key: 'payment_mode' },
                        { label: 'Amount', key: 'amount', render: (r) => formatCurrency(r.amount) },
                        { label: 'Description', key: 'description' },
                      ],
                      'payment'
                    )}

                  {activeTab === 'manpower' &&
                    renderTable(
                      financeData.manpower,
                      [
                        { label: 'Date', key: 'date' },
                        { label: 'Work Type', key: 'work_type_display' },
                        { label: 'People', key: 'number_of_people' },
                        { label: 'Total', key: 'total_amount', render: (r) => formatCurrency(r.total_amount) },
                      ],
                      'manpower'
                    )}

                  {activeTab === 'material' &&
                    renderTable(
                      financeData.material,
                      [
                        { label: 'Date', key: 'date' },
                        { label: 'Material', key: 'custom_item_name' },
                        { label: 'Qty', key: 'quantity' },
                        { label: 'Total', key: 'total_amount', render: (r) => formatCurrency(r.amountNum) },
                        { label: 'Vendor', key: 'vendor_name', render: (r) => r.vendor?.company_name || '-' },
                      ],
                      'material'
                    )}

                  {activeTab === 'departmental' &&
                    renderTable(
                      financeData.departmental,
                      [
                        { label: 'Date', key: 'date' },
                        { label: 'Expense', key: 'expense_name' },
                        { label: 'Amount', key: 'amount', render: (r) => formatCurrency(r.amount) },
                        { label: 'Paid By', key: 'paid_by_name' },
                      ],
                      'departmental'
                    )}

                  {activeTab === 'administration' &&
                    renderTable(
                      financeData.administration,
                      [
                        { label: 'Date', key: 'date' },
                        { label: 'Expense', key: 'expense_name' },
                        { label: 'Amount', key: 'amount', render: (r) => formatCurrency(r.amount) },
                      ],
                      'administration'
                    )}
                </Sheet>
              </div>
            </Grid>
          </Grid>

          <ExportButtons onExportExcel={onExportExcel} onExportPDF={onExportPDF} />
        </>
      )}

      <Modal open={deleteState.open} onClose={() => setDeleteState({ ...deleteState, open: false })}>
        <ModalDialog variant="outlined" role="alertdialog">
          <ModalClose />
          <Typography level="h4" color="danger" startDecorator={<i className="ri-alert-line" />}>
            Confirm Deletion
          </Typography>
          <Divider sx={{ my: 1 }} />
          <Typography>
            Are you sure you want to delete this {deleteState.label}? This action cannot be undone.
          </Typography>
          <Box sx={{ display: 'flex', gap: 1, justifyContent: 'flex-end', mt: 2 }}>
            <Button
              variant="plain"
              color="neutral"
              onClick={() => setDeleteState({ ...deleteState, open: false })}
            >
              Cancel
            </Button>
            <Button
              variant="solid"
              color="danger"
              loading={deleteMutation.isLoading}
              onClick={() => deleteMutation.mutate({ kind: deleteState.kind, id: deleteState.id, label: deleteState.label })}
            >
              Delete
            </Button>
          </Box>
        </ModalDialog>
      </Modal>
    </Box>
  );
};

export default TrackFinances;

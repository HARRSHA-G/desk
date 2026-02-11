import React, { useMemo, useState } from 'react';
import {
  Box,
  Button,
  Grid,
  Input,
  Sheet,
  RadioGroup,
  Radio,
  Typography,
} from '@mui/joy';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import api from '../../api';

import CustomerCard from '../../components/crm/CustomerCard';
import AddCustomerModal from '../../components/crm/AddCustomerModal';
import { TAB_CONFIG, mockCustomers, panelSx } from './customerUtils';

const Customers = () => {
  const queryClient = useQueryClient();
  const [activeTab, setActiveTab] = useState('project');
  const [search, setSearch] = useState('');
  const [openModal, setOpenModal] = useState(false);

  // Queries
  const { data: customers = [], isLoading } = useQuery({
    queryKey: ['customers'],
    queryFn: async () => {
      const response = await api.get('/crm/customers');
      const data = Array.isArray(response.data)
        ? response.data
        : response.data?.results || [];

      if (data.length === 0) return mockCustomers;

      return data.map((item, idx) => ({
        id: item.id || item.customer_id || `C-${idx + 100}`,
        name: item.name || item.customer_name || 'Unnamed',
        phone: item.phone || item.phone_number || item.mobile || '-',
        email: item.email || item.email_id || '-',
        type: (item.type || item.category || 'project').toLowerCase(),
        interest: item.interest || item.requirement || 'N/A',
        budget: item.budget || item.estimated_budget || 'N/A',
        status: (item.status || 'New')?.replace(/^\w/, (c) => c.toUpperCase()),
        bundle: item.bundle || item.leads || [],
      }));
    },
    initialData: mockCustomers,
  });

  // Mutations
  const addMutation = useMutation({
    mutationFn: async (formData) => {
      const payload = {
        ...formData,
        bundle: formData.bundle ? formData.bundle.split(',').map((b) => b.trim()) : [],
      };
      // return api.post('/crm/customers', payload);
      return payload; // Mock success for now since we don't have POST endpoint confirmed
    },
    onSuccess: (newCustomer) => {
      toast.success('Customer added successfully!');
      queryClient.setQueryData(['customers'], (old) => [
        { ...newCustomer, id: `C-${Date.now()}` },
        ...old,
      ]);
      setOpenModal(false);
    },
    onError: () => {
      toast.error('Failed to add customer.');
    },
  });

  const filtered = useMemo(() => {
    return customers.filter(
      (c) =>
        c.type === activeTab &&
        (c.name.toLowerCase().includes(search.toLowerCase()) ||
          c.phone.toLowerCase().includes(search.toLowerCase()) ||
          c.email.toLowerCase().includes(search.toLowerCase())),
    );
  }, [customers, activeTab, search]);

  return (
    <Box sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 } }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3, gap: 2, flexWrap: 'wrap' }}>
        <Box>
          <Typography level="h2" sx={{ color: 'text.primary' }}>
            Customers
          </Typography>
          <Typography level="body-md" sx={{ color: 'text.secondary' }}>
            Manage leads and customers across projects, flats, and plots.
          </Typography>
        </Box>
        <Button startDecorator={<i className="ri-user-add-line" />} size="lg" onClick={() => setOpenModal(true)}>
          Add Customer
        </Button>
      </Box>

      <RadioGroup
        orientation="horizontal"
        value={activeTab}
        onChange={(e) => setActiveTab(e.target.value)}
        sx={{
          mb: 3,
          p: 0.5,
          borderRadius: 'lg',
          bgcolor: 'background.level1',
          width: 'fit-content',
          '--RadioGroup-gap': '4px',
        }}
      >
        {TAB_CONFIG.map((tab) => (
          <Sheet
            key={tab.value}
            variant={activeTab === tab.value ? 'solid' : 'transparent'}
            color={activeTab === tab.value ? 'primary' : 'neutral'}
            sx={{
              p: 1,
              px: 3,
              borderRadius: 'md',
              transition: 'all 0.2s',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              boxShadow: activeTab === tab.value ? 'sm' : 'none',
              '&:hover': {
                bgcolor: activeTab === tab.value ? 'primary.solidHover' : 'background.level2',
              }
            }}
          >
            <Radio
              value={tab.value}
              disableIcon
              overlay
              label={tab.label}
              sx={{
                color: activeTab === tab.value ? 'common.white' : 'text.secondary',
                fontWeight: activeTab === tab.value ? '600' : '500',
              }}
            />
          </Sheet>
        ))}
      </RadioGroup>

      <Sheet sx={{ ...panelSx, p: 2, mb: 3 }}>
        <Input
          placeholder="Search name, phone, or email..."
          startDecorator={<i className="ri-search-line" />}
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          sx={{ bgcolor: 'background.body' }}
        />
      </Sheet>

      <Grid container spacing={2}>
        {filtered.map((customer) => (
          <Grid key={customer.id} xs={12} sm={6} md={4}>
            <CustomerCard customer={customer} />
          </Grid>
        ))}
        {filtered.length === 0 && !isLoading && (
          <Box sx={{ width: '100%', textAlign: 'center', py: 6 }}>
            <Typography level="body-lg" color="neutral">
              No customers yet in this segment.
            </Typography>
          </Box>
        )}
      </Grid>

      <AddCustomerModal
        open={openModal}
        onClose={() => setOpenModal(false)}
        activeTab={activeTab}
        onSave={(data) => addMutation.mutate(data)}
        loading={addMutation.isLoading}
      />
    </Box>
  );
};

export default Customers;

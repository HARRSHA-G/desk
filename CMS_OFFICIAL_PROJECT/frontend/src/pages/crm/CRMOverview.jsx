import React, { useEffect, useRef, useState } from 'react';
import {
  Box,
  Button,
  Card,
  Chip,
  Input,
  Option,
  Select,
  Stack,
  Typography,
} from '@mui/joy';
import api from '../../api';

import CRMTable from '../../components/crm/CRMTable';
import { statusOptions } from './crmOverviewUtils';

const CRMOverview = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState(statusOptions[0].value);
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(true);
  const [errorMessage, setErrorMessage] = useState('');
  const [alert, setAlert] = useState({ message: '', type: '' });
  const [fetchKey, setFetchKey] = useState(0);

  const latestSearchRef = useRef('');
  const alertTimerRef = useRef(null);

  useEffect(() => {
    return () => {
      if (alertTimerRef.current) {
        clearTimeout(alertTimerRef.current);
      }
    };
  }, []);

  useEffect(() => {
    const handler = setTimeout(() => {
      const trimmed = searchTerm.trim();
      latestSearchRef.current = trimmed;
    }, 300);

    return () => clearTimeout(handler);
  }, [searchTerm]);

  const showAlert = (message, type = 'error') => {
    setAlert({ message, type });
    if (alertTimerRef.current) {
      clearTimeout(alertTimerRef.current);
    }
    alertTimerRef.current = setTimeout(() => {
      setAlert({ message: '', type: '' });
    }, 3200);
  };

  useEffect(() => {
    let active = true;
    const fetchRecords = async () => {
      setLoading(true);
      setErrorMessage('');
      try {
        const params = {};
        if (latestSearchRef.current) {
          params.search = latestSearchRef.current;
        }
        if (statusFilter) {
          params.status = statusFilter;
        }
        const response = await api.get('/multi-flat/crm/units/', { params });
        if (!active) return;
        const payload = response.data;
        const list =
          Array.isArray(payload) && payload.length
            ? payload
            : Array.isArray(payload?.results)
              ? payload.results
              : Array.isArray(payload?.units)
                ? payload.units
                : [];
        setRecords(list);
      } catch (error) {
        console.error('Failed to load CRM data', error);
        if (!active) return;
        setRecords([]);
        setErrorMessage('Could not load CRM data.');
        showAlert('Could not load CRM data.', 'error');
      } finally {
        if (active) {
          setLoading(false);
        }
      }
    };

    fetchRecords();
    return () => {
      active = false;
    };
  }, [statusFilter, fetchKey]);

  const handleSearch = () => {
    const trimmed = searchTerm.trim();
    latestSearchRef.current = trimmed;
    setFetchKey((prev) => prev + 1);
  };

  const handleReload = () => {
    setFetchKey((prev) => prev + 1);
  };

  const handleStatusChange = (event, value) => {
    if (!value) return;
    setStatusFilter(value);
    setFetchKey((prev) => prev + 1);
  };

  return (
    <Box
      sx={{
        minHeight: '100vh',
        py: 5,
        px: { xs: 2, md: 3 },
      }}
    >
      <Box
        sx={{
          maxWidth: 1200,
          mx: 'auto',
          display: 'flex',
          flexDirection: 'column',
          gap: 3,
        }}
      >
        <Card sx={{ p: { xs: 3, md: 4 }, overflow: 'hidden' }}>
          <Stack spacing={1.5}>
            <Stack
              direction="row"
              spacing={1}
              alignItems="center"
              flexWrap="wrap"
            >
              <Chip
                variant="soft"
                color="primary"
                startDecorator={<i className="ri-contacts-book-2-line" />}
              >
                CRM
              </Chip>
            </Stack>
            <Typography level="h1" fontWeight={700}>
              Customer records linked to your multi-flat units
            </Typography>
            <Typography level="body-md" color="text.tertiary">
              Search buyers across projects, filter by status, and keep phone/email/reference context beside each unit.
            </Typography>
          </Stack>
        </Card>

        <Stack
          direction={{ xs: 'column', md: 'row' }}
          spacing={2}
          alignItems={{ xs: 'stretch', md: 'center' }}
        >
          <Input
            placeholder="Search by buyer, phone, unit, or project"
            value={searchTerm}
            onChange={(event) => setSearchTerm(event.target.value)}
            sx={{
              flex: 1,
            }}
          />
          <Button
            variant="solid"
            color="primary"
            onClick={handleSearch}
            startDecorator={<i className="ri-search-line" />}
            sx={{ minWidth: 140 }}
          >
            Search
          </Button>
          <Select
            value={statusFilter}
            onChange={handleStatusChange}
            sx={{ minWidth: 200, flexShrink: 0 }}
          >
            {statusOptions.map((option) => (
              <Option key={option.value} value={option.value}>
                {option.label}
              </Option>
            ))}
          </Select>
          <Button
            variant="outlined"
            color="neutral"
            onClick={handleReload}
            startDecorator={<i className="ri-refresh-line" />}
            sx={{ minWidth: 140 }}
          >
            Reload
          </Button>
        </Stack>

        {alert.message && (
          <Card
            variant="outlined"
            color={alert.type === 'success' ? 'success' : 'danger'}
            sx={{ p: 2 }}
          >
            <Typography level="body-md" fontWeight={600}>
              {alert.message}
            </Typography>
          </Card>
        )}

        <Card sx={{ p: 3 }}>
          <Typography level="title-lg" fontWeight={600} mb={2}>
            Buyer records
          </Typography>
          <CRMTable records={records} loading={loading} errorMessage={errorMessage} />
        </Card>
      </Box>
    </Box>
  );
};

export default CRMOverview;

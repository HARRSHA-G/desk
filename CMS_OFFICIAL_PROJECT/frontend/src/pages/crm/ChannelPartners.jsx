import React, { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Grid,
  Input,
  Sheet,
  Typography,
} from '@mui/joy';
import api from '../../api';

import {
  MOCK_PARTNERS,
  normalizePartnerPayload,
} from './channelPartnerUtils';

import PartnerCard from '../../components/crm/PartnerCard';
import AddPartnerModal from '../../components/crm/AddPartnerModal';

const panelSx = {
  bgcolor: 'background.surface',
  border: '1px solid',
  borderColor: 'divider',
  backdropFilter: 'blur(12px)',
  boxShadow: 'md',
  borderRadius: '16px',
};

const ChannelPartners = () => {
  const [partners, setPartners] = useState([]);
  const [search, setSearch] = useState('');
  const [open, setOpen] = useState(false);

  useEffect(() => {
    let active = true;
    setPartners(MOCK_PARTNERS);

    const fetchPartners = async () => {
      try {
        const res = await api.get('/crm/channel-partners');
        const normalized = normalizePartnerPayload(res.data);
        if (!active || normalized.length === 0) return;
        setPartners(normalized);
      } catch (err) {
        console.warn('Using mock partners, API unavailable', err);
      }
    };
    fetchPartners();
    return () => {
      active = false;
    };
  }, []);

  const filtered = partners.filter(
    (p) =>
      p.name.toLowerCase().includes(search.toLowerCase()) ||
      p.contact.toLowerCase().includes(search.toLowerCase()),
  );

  const handleAddPartner = (formData) => {
    const newPartner = {
      id: `P-${Math.floor(Math.random() * 900 + 100)}`,
      name: formData.name || 'New Partner',
      contact: formData.contact || '-',
      phone: formData.phone || '-',
      email: formData.email || '-',
      deals: 0,
      volume: '0',
      health: 'Silver',
    };
    setPartners((prev) => [newPartner, ...prev]);
    setOpen(false);
  };

  return (
    <Box sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 } }}>
      <Box
        sx={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          mb: 3,
          gap: 2,
          flexWrap: 'wrap',
        }}
      >
        <Box>
          <Typography level="h2">Channel Partners</Typography>
          <Typography level="body-md" color="neutral">
            Partner grid with KYC-friendly onboarding.
          </Typography>
        </Box>
        <Button
          startDecorator={<i className="ri-user-shared-line" />}
          size="lg"
          onClick={() => setOpen(true)}
        >
          Add Partner
        </Button>
      </Box>

      <Sheet sx={{ ...panelSx, p: 2, mb: 3 }}>
        <Input
          placeholder="Search partner or contact person"
          startDecorator={<i className="ri-search-line" />}
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          sx={{ bgcolor: 'background.level1', borderColor: 'divider' }}
        />
      </Sheet>

      <Grid container spacing={2}>
        {filtered.map((partner) => (
          <Grid key={partner.id} xs={12} sm={6} md={4}>
            <PartnerCard partner={partner} />
          </Grid>
        ))}

        {filtered.length === 0 && (
          <Box sx={{ width: '100%', textAlign: 'center', py: 6 }}>
            <Typography level="body-lg" color="neutral">
              No partners found.
            </Typography>
          </Box>
        )}
      </Grid>

      <AddPartnerModal open={open} onClose={() => setOpen(false)} onSave={handleAddPartner} />
    </Box>
  );
};

export default ChannelPartners;

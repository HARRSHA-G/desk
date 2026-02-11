import React, { useState, useMemo } from 'react';
import {
  Box,
  Radio,
  RadioGroup,
  Sheet,
  Typography,
  Grid,
  FormControl,
  FormLabel,
  Select,
  Option,
} from '@mui/joy';
import { projectsData, flatUnitsData, plotUnitsData, getCategoryLabel } from './financeUtils';
import ProjectPaymentForm from '../../components/finance/ProjectPaymentForm';
import FlatPaymentForm from '../../components/finance/FlatPaymentForm';
import PlotPaymentForm from '../../components/finance/PlotPaymentForm';
import PaymentsTable from '../../components/finance/PaymentsTable';

const todayIso = new Date().toISOString().split('T')[0];

const Payments = () => {
  const [selectedProjectId, setSelectedProjectId] = useState('');
  const [paymentCategory, setPaymentCategory] = useState('project'); // 'project', 'flat', 'plot'

  // Forms State
  const [projectPayment, setProjectPayment] = useState({
    amount: '',
    payment_date: todayIso,
    payment_type: 'Advance',
    description: '',
  });

  const [flatPayment, setFlatPayment] = useState({
    receipt_id: '',
    block: '',
    floor: '',
    unit: '',
    amount: '',
    payment_date: todayIso,
    payment_stage: 'advance',
    payment_method: 'cash',
    remarks: '',
  });

  const [plotPayment, setPlotPayment] = useState({
    unit: '',
    amount: '',
    payment_date: todayIso,
    payment_stage: 'booking',
    payment_method: 'cash',
    receipt_id: '',
    remarks: '',
  });

  // Lists State
  const [projectPayments, setProjectPayments] = useState([]);
  const [flatPayments, setFlatPayments] = useState([]);
  const [plotPayments, setPlotPayments] = useState([]);

  // Computed Options
  const selectedProject = useMemo(() => projectsData.find(p => p.id === selectedProjectId), [selectedProjectId]);

  const blockOptions = useMemo(() => {
    if (!selectedProjectId) return [];
    const data = flatUnitsData[selectedProjectId];
    return data?.blocks?.map((b) => ({ value: b.id, label: b.name })) || [];
  }, [selectedProjectId]);

  const floorOptions = useMemo(() => {
    if (!selectedProjectId) return [];
    const block = flatUnitsData[selectedProjectId]?.blocks?.find((b) => b.id === flatPayment.block);
    return block?.floors?.map((f) => ({ value: f.id, label: f.name })) || [];
  }, [selectedProjectId, flatPayment.block]);

  const unitOptions = useMemo(() => {
    if (!selectedProjectId) return [];
    const block = flatUnitsData[selectedProjectId]?.blocks?.find((b) => b.id === flatPayment.block);
    const floor = block?.floors?.find((f) => f.id === flatPayment.floor);
    return floor?.units?.map((u) => ({ value: u.id, label: u.name })) || [];
  }, [selectedProjectId, flatPayment.block, flatPayment.floor]);

  const plotOptions = useMemo(() => {
    if (!selectedProjectId) return [];
    return (plotUnitsData[selectedProjectId] || []).map((u) => ({ value: u.id, label: u.name }));
  }, [selectedProjectId]);

  // Handlers
  const handleProjectSubmit = (e) => {
    e.preventDefault();
    setProjectPayments((prev) => [
      {
        id: `PP-${prev.length + 1}`,
        projectId: selectedProjectId,
        projectName: selectedProject?.name,
        amount: projectPayment.amount,
        date: projectPayment.payment_date,
        type: projectPayment.payment_type,
        description: projectPayment.description,
      },
      ...prev,
    ]);
    setProjectPayment(prev => ({ ...prev, amount: '', description: '' }));
  };

  const handleFlatSubmit = (e) => {
    e.preventDefault();
    setFlatPayments((prev) => [
      {
        id: `FP-${prev.length + 1}`,
        projectId: selectedProjectId,
        projectName: selectedProject?.name,
        unit: flatPayment.unit || '-',
        receipt: flatPayment.receipt_id || '-',
        amount: flatPayment.amount,
        date: flatPayment.payment_date,
        stage: flatPayment.payment_stage,
      },
      ...prev,
    ]);
    setFlatPayment(prev => ({ ...prev, amount: '', remarks: '', receipt_id: '' }));
  };

  const handlePlotSubmit = (e) => {
    e.preventDefault();
    setPlotPayments((prev) => [
      {
        id: `PL-${prev.length + 1}`,
        projectId: selectedProjectId,
        projectName: selectedProject?.name,
        unit: plotPayment.unit || '-',
        receipt: plotPayment.receipt_id || '-',
        amount: plotPayment.amount,
        date: plotPayment.payment_date,
        stage: plotPayment.payment_stage,
      },
      ...prev,
    ]);
    setPlotPayment(prev => ({ ...prev, amount: '', remarks: '', receipt_id: '' }));
  };

  const handleProjectChange = (val) => {
    setSelectedProjectId(val);
    setPaymentCategory('project');
    setFlatPayment(prev => ({ ...prev, block: '', floor: '', unit: '' }));
    setPlotPayment(prev => ({ ...prev, unit: '' }));
  };

  const visiblePayments = useMemo(() => {
    if (paymentCategory === 'project') return projectPayments.filter(p => p.projectId === selectedProjectId);
    if (paymentCategory === 'flat') return flatPayments.filter(p => p.projectId === selectedProjectId);
    if (paymentCategory === 'plot') return plotPayments.filter(p => p.projectId === selectedProjectId);
    return [];
  }, [paymentCategory, projectPayments, flatPayments, plotPayments, selectedProjectId]);

  return (
    <Box sx={{ width: '100%', maxWidth: 1400, mx: 'auto', p: { xs: 2, md: 3 } }}>

      <Box sx={{ mb: 3 }}>
        <Typography level="h2">Payments Hub</Typography>
        <Typography level="body-md" color="neutral">
          Record and track payments by project context.
        </Typography>
      </Box>


      {/* TOP CONFIGURATION PANEL */}

      <Sheet variant="outlined" sx={{ p: 3, borderRadius: 'lg', mb: 3, display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 3, alignItems: 'center' }}>
        <FormControl sx={{ minWidth: 240 }}>
          <FormLabel>Select Project</FormLabel>
          <Select
            placeholder="Choose a project..."
            value={selectedProjectId}
            onChange={(e, val) => handleProjectChange(val)}
          >
            {projectsData.map(p => <Option key={p.id} value={p.id}>{p.name}</Option>)}
          </Select>
        </FormControl>

        {selectedProjectId && (

          <FormControl>
            <FormLabel>Payment Category</FormLabel>
            <RadioGroup
              orientation="horizontal"
              value={paymentCategory}
              onChange={(e) => setPaymentCategory(e.target.value)}
              sx={{ gap: 2 }}
            >
              <Sheet variant="soft" color={paymentCategory === 'project' ? 'primary' : 'neutral'} sx={{ p: 1, px: 2, borderRadius: 'md', display: 'flex', alignItems: 'center', gap: 1 }}>
                <Radio value="project" overlay label="Project Payment" />
              </Sheet>
              <Sheet variant="soft" color={paymentCategory === 'flat' ? 'primary' : 'neutral'} sx={{ p: 1, px: 2, borderRadius: 'md', display: 'flex', alignItems: 'center', gap: 1 }}>
                <Radio value="flat" overlay label="Flat Payment" />
              </Sheet>
              <Sheet variant="soft" color={paymentCategory === 'plot' ? 'primary' : 'neutral'} sx={{ p: 1, px: 2, borderRadius: 'md', display: 'flex', alignItems: 'center', gap: 1 }}>
                <Radio value="plot" overlay label="Plot Payment" />
              </Sheet>
            </RadioGroup>
          </FormControl>

        )}
      </Sheet>


      {/* MAIN CONTENT AREA */}
      {selectedProjectId ? (

        <Grid container spacing={3}>
          {/* LEFT COLUMN: FORM */}
          <Grid xs={12} lg={4}>
            <Sheet variant="outlined" sx={{ p: 3, borderRadius: 'lg', height: '100%' }}>
              <Typography level="title-lg" sx={{ mb: 2 }}>Add {getCategoryLabel(paymentCategory)}</Typography>

              {paymentCategory === 'project' && (
                <ProjectPaymentForm
                  payment={projectPayment}
                  onChange={setProjectPayment}
                  onSubmit={handleProjectSubmit}
                />
              )}

              {paymentCategory === 'flat' && (
                <FlatPaymentForm
                  payment={flatPayment}
                  onChange={setFlatPayment}
                  onSubmit={handleFlatSubmit}
                  blockOptions={blockOptions}
                  floorOptions={floorOptions}
                  unitOptions={unitOptions}
                />
              )}

              {paymentCategory === 'plot' && (
                <PlotPaymentForm
                  payment={plotPayment}
                  onChange={setPlotPayment}
                  onSubmit={handlePlotSubmit}
                  plotOptions={plotOptions}
                />
              )}
            </Sheet>
          </Grid>

          {/* RIGHT COLUMN: LIST */}
          <Grid xs={12} lg={8}>
            <PaymentsTable
              category={paymentCategory}
              payments={visiblePayments}
              projectName={selectedProject?.name}
            />
          </Grid>
        </Grid>

      ) : (

        <Box sx={{ p: 4, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', opacity: 0.6 }}>
          <Typography level="title-lg">No Project Selected</Typography>
          <Typography>Please select a project above to manage payments.</Typography>
        </Box>

      )}
    </Box>
  );
};

export default Payments;

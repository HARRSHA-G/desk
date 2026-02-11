import React, { useEffect, useState } from 'react';
import {
    Button,
    FormControl,
    FormLabel,
    Grid,
    Input,
    Modal,
    ModalClose,
    ModalDialog,
    Option,
    Select,
    Stack,
    Textarea,
    Typography,
} from '@mui/joy';
import { CHANNEL_PARTNERS, TEMPLATE_PRESETS } from '../../pages/sales/multiFlatSalesUtils';

const BuyerModal = ({ open, unit, onClose, onSave }) => {
    const [form, setForm] = useState({
        channelPartner: '',
        customerName: '',
        contact: '',
        bhk: '',
        facing: '',
        area: '',
        notes: '',
    });

    useEffect(() => {
        if (!unit) {
            setForm((prev) => ({ ...prev, channelPartner: '', customerName: '', contact: '', bhk: '', facing: '', area: '', notes: '' }));
            return;
        }
        setForm({
            channelPartner: unit.channelPartner || '',
            customerName: unit.customerName || unit.buyer?.name || '',
            contact: unit.buyer?.contact || '',
            bhk: unit.bhk || '',
            facing: unit.facing || '',
            area: unit.area ? String(unit.area) : '',
            notes: unit.buyer?.notes || '',
        });
    }, [unit]);

    const applyPreset = (preset) => {
        setForm((prev) => ({ ...prev, ...preset }));
    };

    const handleSubmit = () => {
        onSave(form);
    };

    return (
        <Modal open={open} onClose={onClose}>
            <ModalDialog layout="center" sx={{ width: 480, maxWidth: '95%' }}>
                <ModalClose />
                <Typography level="h5" sx={{ mb: 1 }}>
                    Buyer & channel partner details
                </Typography>
                <Typography level="body-xs" color="neutral" sx={{ mb: 2 }}>
                    Channel partners and customer inputs unify the multi-flat inventory with CRM and unit templates.
                </Typography>
                <Stack spacing={2}>
                    <FormControl>
                        <FormLabel>Channel partner</FormLabel>
                        <Select
                            value={form.channelPartner}
                            onChange={(event, value) => setForm((prev) => ({ ...prev, channelPartner: value }))}
                            placeholder="Select partner"
                        >
                            <Option value="">(None)</Option>
                            {CHANNEL_PARTNERS.map((partner) => (
                                <Option key={partner} value={partner}>
                                    {partner}
                                </Option>
                            ))}
                        </Select>
                    </FormControl>
                    <FormControl>
                        <FormLabel>Customer name</FormLabel>
                        <Input
                            value={form.customerName}
                            onChange={(event) => setForm((prev) => ({ ...prev, customerName: event.target.value }))}
                        />
                    </FormControl>
                    <FormControl>
                        <FormLabel>Contact / mobile</FormLabel>
                        <Input
                            value={form.contact}
                            onChange={(event) => setForm((prev) => ({ ...prev, contact: event.target.value }))}
                        />
                    </FormControl>
                    <Stack direction="row" spacing={1} flexWrap="wrap" sx={{ mt: 1 }}>
                        {TEMPLATE_PRESETS.map((preset) => (
                            <Button
                                key={preset.label}
                                variant="outlined"
                                color="neutral"
                                size="sm"
                                onClick={() => applyPreset(preset.config)}
                            >
                                {preset.label}
                            </Button>
                        ))}
                    </Stack>
                    <Grid container spacing={2}>
                        <Grid xs={12} sm={4}>
                            <FormControl>
                                <FormLabel>BHK</FormLabel>
                                <Input
                                    value={form.bhk}
                                    onChange={(event) => setForm((prev) => ({ ...prev, bhk: event.target.value }))}
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={4}>
                            <FormControl>
                                <FormLabel>Facing</FormLabel>
                                <Input
                                    value={form.facing}
                                    onChange={(event) => setForm((prev) => ({ ...prev, facing: event.target.value }))}
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={4}>
                            <FormControl>
                                <FormLabel>Area (sq ft)</FormLabel>
                                <Input
                                    type="number"
                                    value={form.area}
                                    onChange={(event) => setForm((prev) => ({ ...prev, area: event.target.value }))}
                                />
                            </FormControl>
                        </Grid>
                    </Grid>
                    <FormControl>
                        <FormLabel>Notes</FormLabel>
                        <Textarea
                            minRows={3}
                            value={form.notes}
                            onChange={(event) => setForm((prev) => ({ ...prev, notes: event.target.value }))}
                            placeholder="Share buyer-specific instructions"
                        />
                    </FormControl>
                </Stack>
                <Stack direction="row" spacing={1} justifyContent="flex-end" sx={{ mt: 3 }}>
                    <Button variant="plain" onClick={onClose}>
                        Cancel
                    </Button>
                    <Button variant="solid" color="primary" onClick={handleSubmit}>
                        Save buyer
                    </Button>
                </Stack>
            </ModalDialog>
        </Modal>
    );
};

export default BuyerModal;

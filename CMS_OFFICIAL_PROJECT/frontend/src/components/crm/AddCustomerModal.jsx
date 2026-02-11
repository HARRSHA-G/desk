import React, { useEffect } from 'react';
import {
    Box,
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
    Textarea,
    Typography,
    FormHelperText,
} from '@mui/joy';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { TAB_CONFIG, customerSchema } from '../../pages/crm/customerUtils';

const AddCustomerModal = ({ open, onClose, onSave, activeTab, loading }) => {
    const {
        register,
        handleSubmit,
        control,
        reset,
        formState: { errors },
    } = useForm({
        resolver: zodResolver(customerSchema),
        defaultValues: {
            name: '',
            phone: '',
            email: '',
            type: 'project',
            interest: '',
            budget: '',
            status: 'New',
            bundle: '',
            leadSource: 'Web Form',
        },
    });

    useEffect(() => {
        if (open) {
            reset({
                name: '',
                phone: '',
                email: '',
                type: activeTab || 'project',
                interest: '',
                budget: '',
                status: 'New',
                bundle: '',
                leadSource: 'Web Form',
            });
        }
    }, [open, activeTab, reset]);

    return (
        <Modal open={open} onClose={onClose}>
            <ModalDialog
                layout="center"
                sx={{
                    maxWidth: 720,
                    width: '90%',
                    bgcolor: 'background.surface',
                    border: '1px solid',
                    borderColor: 'divider',
                    backdropFilter: 'blur(16px)',
                    boxShadow: 'lg',
                }}
            >
                <ModalClose />
                <Typography level="h4" sx={{ mb: 2 }}>
                    Add Customer
                </Typography>

                <form onSubmit={handleSubmit(onSave)}>
                    <Grid container spacing={2}>
                        <Grid xs={12} sm={6}>
                            <FormControl error={!!errors.name}>
                                <FormLabel>Name</FormLabel>
                                <Input {...register('name')} placeholder="Customer name" />
                                {errors.name && <FormHelperText>{errors.name.message}</FormHelperText>}
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Type</FormLabel>
                                <Controller
                                    name="type"
                                    control={control}
                                    render={({ field }) => (
                                        <Select {...field} onChange={(_, val) => field.onChange(val)}>
                                            {TAB_CONFIG.map((tab) => (
                                                <Option key={tab.value} value={tab.value}>
                                                    {tab.label}
                                                </Option>
                                            ))}
                                        </Select>
                                    )}
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl error={!!errors.phone}>
                                <FormLabel>Phone</FormLabel>
                                <Input {...register('phone')} placeholder="+91 9xxxx xxxxx" />
                                {errors.phone && <FormHelperText>{errors.phone.message}</FormHelperText>}
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl error={!!errors.email}>
                                <FormLabel>Email</FormLabel>
                                <Input {...register('email')} placeholder="customer@email.com" />
                                {errors.email && <FormHelperText>{errors.email.message}</FormHelperText>}
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Interest / Unit</FormLabel>
                                <Input {...register('interest')} placeholder="Tower B, 12th floor" />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Budget</FormLabel>
                                <Input {...register('budget')} placeholder="e.g., 80 Lakh" />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Status</FormLabel>
                                <Controller
                                    name="status"
                                    control={control}
                                    render={({ field }) => (
                                        <Select {...field} onChange={(_, val) => field.onChange(val)}>
                                            <Option value="Hot">Hot</Option>
                                            <Option value="Warm">Warm</Option>
                                            <Option value="New">New</Option>
                                        </Select>
                                    )}
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Lead Source</FormLabel>
                                <Controller
                                    name="leadSource"
                                    control={control}
                                    render={({ field }) => (
                                        <Select {...field} onChange={(_, val) => field.onChange(val)}>
                                            <Option value="Web Form">Web Form</Option>
                                            <Option value="Channel Partner">Channel Partner</Option>
                                            <Option value="Referral">Referral</Option>
                                            <Option value="Walk-in">Walk-in</Option>
                                        </Select>
                                    )}
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12}>
                            <FormControl>
                                <FormLabel>Bundle (Leads)</FormLabel>
                                <Textarea
                                    {...register('bundle')}
                                    minRows={2}
                                    placeholder="Comma separated lead sources or IDs"
                                />
                            </FormControl>
                        </Grid>
                    </Grid>

                    <Box sx={{ display: 'flex', justifyContent: 'flex-end', gap: 1.5, mt: 3 }}>
                        <Button variant="soft" color="neutral" onClick={onClose} disabled={loading}>
                            Cancel
                        </Button>
                        <Button type="submit" loading={loading}>Save Customer</Button>
                    </Box>
                </form>
            </ModalDialog>
        </Modal>
    );
};

export default AddCustomerModal;

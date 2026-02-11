import React, { useEffect, useState } from 'react';
import {
    Modal,
    ModalDialog,
    ModalClose,
    Typography,
    Grid,
    FormControl,
    FormLabel,
    Input,
    Select,
    Option,
    Box,
    Button,
    Checkbox,
    FormHelperText,
} from '@mui/joy';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import {
    MULTI_UNIT_LAYOUTS,
    normalizeLayoutKey,
    projectSchema,
    PERMISSION_REQUIREMENTS,
    buildPermissionStateFromMap,
} from '../../pages/projects/projectUtils';

const ProjectFormModal = ({
    mode,
    open,
    onClose,
    project,
    onSubmit,
    saving,
    supervisors,
    customers,
}) => {
    const isEditMode = mode === 'edit';

    const {
        register,
        handleSubmit,
        control,
        watch,
        reset,
        formState: { errors },
    } = useForm({
        resolver: zodResolver(projectSchema),
        defaultValues: {
            name: '',
            code: '',
            status: 'Planning',
            constructionType: 'residential',
            layout: 'single_flat',
            landAddress: '',
            landArea: '',
            budget: '',
            duration: '',
            customer: '',
            supervisor: '',
        },
    });

    const constructionType = watch('constructionType');
    const layout = watch('layout');
    const isMultiLayout = MULTI_UNIT_LAYOUTS.includes(normalizeLayoutKey(layout));

    const [permissionState, setPermissionState] = useState({});

    useEffect(() => {
        if (open) {
            if (isEditMode && project) {
                reset({
                    name: project.name || '',
                    code: project.code || '',
                    status: project.status || 'Planning',
                    constructionType: project.constructionType || 'residential',
                    layout: project.layoutKey || 'single_flat',
                    landAddress: project.landAddress || '',
                    landArea: project.landArea || '',
                    budget: project.budget || '',
                    duration: project.duration || '',
                    customer: project.customerId || '',
                    supervisor: project.supervisorId || '',
                });
                setPermissionState(buildPermissionStateFromMap(project.permissionMap, project.constructionType));
            } else {
                reset();
                setPermissionState({});
            }
        }
    }, [open, isEditMode, project, reset]);

    useEffect(() => {
        const requirements = PERMISSION_REQUIREMENTS[constructionType] || [];
        setPermissionState((prev) => {
            const next = {};
            requirements.forEach((perm) => {
                next[perm.key] = prev[perm.key] ?? false;
            });
            return next;
        });
    }, [constructionType]);

    const onFormSubmit = (data) => {
        onSubmit(data, permissionState);
    };

    return (
        <Modal open={open} onClose={onClose}>
            <ModalDialog layout="center" sx={{ maxWidth: 520, width: '95%', overflowY: 'auto' }}>
                <ModalClose />
                <Typography level="h4" sx={{ mb: 1 }}>
                    {isEditMode ? 'Edit Project' : 'Create New Project'}
                </Typography>

                <form onSubmit={handleSubmit(onFormSubmit)}>
                    <Grid container spacing={1.5}>
                        <Grid xs={12}>
                            <FormControl error={!!errors.name}>
                                <FormLabel>Project Name</FormLabel>
                                <Input {...register('name')} placeholder="Project name" />
                                {errors.name && <FormHelperText>{errors.name.message}</FormHelperText>}
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl required error={!!errors.code}>
                                <FormLabel>Project ID</FormLabel>
                                <Input {...register('code')} placeholder="PRJ-001" />
                                {errors.code && <FormHelperText>{errors.code.message}</FormHelperText>}
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
                                            <Option value="Active">Active</Option>
                                            <Option value="Planning">Planning</Option>
                                            <Option value="Completed">Completed</Option>
                                            <Option value="On Hold">On Hold</Option>
                                            <Option value="Cancelled">Cancelled</Option>
                                        </Select>
                                    )}
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12}>
                            <FormControl>
                                <FormLabel>Land Address</FormLabel>
                                <Input {...register('landAddress')} placeholder="Site address" />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Land Area (sq. ft.)</FormLabel>
                                <Input type="number" {...register('landArea')} placeholder="0" />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Construction Type</FormLabel>
                                <Controller
                                    name="constructionType"
                                    control={control}
                                    render={({ field }) => (
                                        <Select {...field} onChange={(_, val) => field.onChange(val)}>
                                            <Option value="residential">Residential</Option>
                                            <Option value="commercial">Commercial</Option>
                                            <Option value="semi_commercial">Semi-Commercial</Option>
                                        </Select>
                                    )}
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Layout</FormLabel>
                                <Controller
                                    name="layout"
                                    control={control}
                                    render={({ field }) => (
                                        <Select {...field} onChange={(_, val) => field.onChange(val)}>
                                            <Option value="single_flat">Single Unit</Option>
                                            <Option value="multi_flat">Multi Flat</Option>
                                            <Option value="multi_plot">Multi Plot</Option>
                                        </Select>
                                    )}
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Budget</FormLabel>
                                <Input type="number" {...register('budget')} placeholder="0" />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} sm={6}>
                            <FormControl>
                                <FormLabel>Duration (months)</FormLabel>
                                <Input type="number" {...register('duration')} placeholder="18" />
                            </FormControl>
                        </Grid>

                        {!isMultiLayout ? (
                            <>
                                <Grid xs={12} sm={6}>
                                    <FormControl>
                                        <FormLabel>Customer</FormLabel>
                                        <Controller
                                            name="customer"
                                            control={control}
                                            render={({ field }) => (
                                                <Select {...field} onChange={(_, val) => field.onChange(val)} placeholder="Select customer">
                                                    <Option value="">Not assigned</Option>
                                                    {customers.map((c) => (
                                                        <Option key={c.id || c.code} value={c.id || c.code}>
                                                            {c.name || c.code}
                                                        </Option>
                                                    ))}
                                                </Select>
                                            )}
                                        />
                                    </FormControl>
                                </Grid>
                                <Grid xs={12} sm={6}>
                                    <FormControl>
                                        <FormLabel>Supervisor</FormLabel>
                                        <Controller
                                            name="supervisor"
                                            control={control}
                                            render={({ field }) => (
                                                <Select {...field} onChange={(_, val) => field.onChange(val)} placeholder="Select supervisor">
                                                    <Option value="">Not assigned</Option>
                                                    {supervisors.map((s) => (
                                                        <Option key={s.id || s.code} value={s.id || s.code}>
                                                            {s.name || s.code}
                                                        </Option>
                                                    ))}
                                                </Select>
                                            )}
                                        />
                                    </FormControl>
                                </Grid>
                            </>
                        ) : (
                            <Grid xs={12}>
                                <Typography level="body-sm" color="neutral">
                                    Multi-unit layouts are managed through CRM.
                                </Typography>
                            </Grid>
                        )}

                        <Grid xs={12}>
                            <FormLabel sx={{ mb: 1 }}>Permissions Checklist</FormLabel>
                            <Box
                                sx={{
                                    display: 'flex',
                                    flexDirection: 'column',
                                    gap: 0.5,
                                    maxHeight: 160,
                                    overflowY: 'auto',
                                    border: '1px solid',
                                    borderColor: 'divider',
                                    borderRadius: 'md',
                                    p: 1,
                                }}
                            >
                                {(PERMISSION_REQUIREMENTS[constructionType] || []).map((perm) => (
                                    <Checkbox
                                        key={perm.key}
                                        label={perm.label}
                                        checked={!!permissionState[perm.key]}
                                        onChange={(e) => setPermissionState({ ...permissionState, [perm.key]: e.target.checked })}
                                    />
                                ))}
                            </Box>
                        </Grid>
                    </Grid>

                    <Box sx={{ display: 'flex', gap: 1, justifyContent: 'flex-end', mt: 3 }}>
                        <Button variant="plain" color="neutral" onClick={onClose} disabled={saving}>
                            Cancel
                        </Button>
                        <Button type="submit" loading={saving}>
                            {isEditMode ? 'Save Changes' : 'Create Project'}
                        </Button>
                    </Box>
                </form>
            </ModalDialog>
        </Modal>
    );
};

export default ProjectFormModal;

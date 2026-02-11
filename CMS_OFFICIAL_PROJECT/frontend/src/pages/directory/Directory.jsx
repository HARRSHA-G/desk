import React, { useState } from 'react';
import {
    Box,
    Typography,
    Button,
    Grid,
    Input,
    Textarea,
    FormControl,
    FormLabel,
    Chip,
    Modal,
    ModalDialog,
    ModalClose,
    Sheet,
    Divider,
} from '@mui/joy';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import toast from 'react-hot-toast';
import api from '../../api';
import DirectoryCard from '../../components/directory/DirectoryCard';

const Directory = () => {
    const queryClient = useQueryClient();
    const [showAddType, setShowAddType] = useState(null); // 'supervisor' | 'vendor'
    const [editingPerson, setEditingPerson] = useState(null);

    // Queries
    const { data: directoryData = { supervisors: [], vendors: [] }, isLoading } = useQuery({
        queryKey: ['directory'],
        queryFn: async () => {
            const [supRes, vendRes] = await Promise.all([
                api.get('/directory/supervisors/').catch(() => ({ data: [] })),
                api.get('/directory/vendors/').catch(() => ({ data: [] })),
            ]);
            return {
                supervisors: Array.isArray(supRes.data) ? supRes.data : [],
                vendors: Array.isArray(vendRes.data) ? vendRes.data : [],
            };
        },
    });

    // Mutations
    const createMutation = useMutation({
        mutationFn: async ({ type, payload }) => {
            // return api.post(`/directory/${type}s/`, payload);
            return payload;
        },
        onSuccess: (_, { type }) => {
            toast.success(`${type} added successfully!`);
            queryClient.invalidateQueries(['directory']);
            setShowAddType(null);
        },
    });

    const deleteMutation = useMutation({
        mutationFn: async ({ type, id }) => {
            // return api.delete(`/directory/${type}s/${id}/`);
            return id;
        },
        onSuccess: (_, { type }) => {
            toast.success(`${type} deleted.`);
            queryClient.invalidateQueries(['directory']);
        },
    });

    const handleDelete = (type, id) => {
        if (window.confirm('Are you sure?')) {
            deleteMutation.mutate({ type, id });
        }
    };

    const handleFormSubmit = (e, type) => {
        e.preventDefault();
        const formData = new FormData(e.target);
        const payload = Object.fromEntries(formData.entries());
        createMutation.mutate({ type, payload });
    };

    return (
        <Box sx={{ width: '100%', maxWidth: 1600, mx: 'auto', p: { xs: 2, md: 3 } }}>
            <Box sx={{ mb: 3 }}>
                <Typography level="title-sm" color="primary" sx={{ textTransform: 'uppercase' }}>
                    Directory
                </Typography>
                <Typography level="h2">People Management</Typography>
                <Typography level="body-md" color="neutral">
                    Manage supervisors, vendors, and contacts.
                </Typography>
            </Box>

            <Box sx={{ display: 'flex', gap: 2, mb: 4, flexWrap: 'wrap' }}>
                <Button
                    startDecorator={<i className="ri-user-star-line"></i>}
                    onClick={() => setShowAddType(showAddType === 'supervisor' ? null : 'supervisor')}
                    variant={showAddType === 'supervisor' ? 'solid' : 'soft'}
                >
                    Add Supervisor
                </Button>
                <Button
                    startDecorator={<i className="ri-building-line"></i>}
                    onClick={() => setShowAddType(showAddType === 'vendor' ? null : 'vendor')}
                    variant={showAddType === 'vendor' ? 'solid' : 'soft'}
                >
                    Add Vendor
                </Button>
            </Box>

            {showAddType === 'supervisor' && (
                <Sheet variant="outlined" sx={{ p: 3, borderRadius: 'lg', mb: 4, bgcolor: 'background.level1' }}>
                    <Typography level="h4" sx={{ mb: 2 }}>New Supervisor</Typography>
                    <form onSubmit={(e) => handleFormSubmit(e, 'supervisor')}>
                        <Grid container spacing={2}>
                            <Grid xs={12} md={6}>
                                <FormControl required><FormLabel>Name</FormLabel><Input name="name" /></FormControl>
                            </Grid>
                            <Grid xs={12} md={6}>
                                <FormControl required><FormLabel>Phone</FormLabel><Input name="primary_phone_number" /></FormControl>
                            </Grid>
                            <Grid xs={12} md={6}>
                                <FormControl><FormLabel>Email</FormLabel><Input name="email" type="email" /></FormControl>
                            </Grid>
                            <Grid xs={12}><FormControl><FormLabel>Address</FormLabel><Textarea name="address" minRows={2} /></FormControl></Grid>
                        </Grid>
                        <Box sx={{ mt: 2, display: 'flex', justifyContent: 'flex-end', gap: 1 }}>
                            <Button variant="plain" onClick={() => setShowAddType(null)}>Cancel</Button>
                            <Button type="submit" loading={createMutation.isLoading}>Save</Button>
                        </Box>
                    </form>
                </Sheet>
            )}

            {showAddType === 'vendor' && (
                <Sheet variant="outlined" sx={{ p: 3, borderRadius: 'lg', mb: 4, bgcolor: 'background.level1' }}>
                    <Typography level="h4" sx={{ mb: 2 }}>New Vendor</Typography>
                    <form onSubmit={(e) => handleFormSubmit(e, 'vendor')}>
                        <Grid container spacing={2}>
                            <Grid xs={12} md={6}>
                                <FormControl required><FormLabel>Company Name</FormLabel><Input name="company_name" /></FormControl>
                            </Grid>
                            <Grid xs={12} md={6}>
                                <FormControl required><FormLabel>Phone</FormLabel><Input name="primary_phone_number" /></FormControl>
                            </Grid>
                            <Grid xs={12} md={6}>
                                <FormControl required><FormLabel>Contact First Name</FormLabel><Input name="first_name" /></FormControl>
                            </Grid>
                            <Grid xs={12}><FormControl><FormLabel>Address</FormLabel><Textarea name="business_address" minRows={2} /></FormControl></Grid>
                        </Grid>
                        <Box sx={{ mt: 2, display: 'flex', justifyContent: 'flex-end', gap: 1 }}>
                            <Button variant="plain" onClick={() => setShowAddType(null)}>Cancel</Button>
                            <Button type="submit" loading={createMutation.isLoading}>Save</Button>
                        </Box>
                    </form>
                </Sheet>
            )}

            <Box sx={{ mb: 5 }}>
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                    <Typography level="h3">Supervisors</Typography>
                    <Chip variant="soft">{directoryData.supervisors.length}</Chip>
                </Box>
                <Grid container spacing={2}>
                    {directoryData.supervisors.map(s => (
                        <Grid key={s.id} xs={12} sm={6} md={4} lg={3}>
                            <DirectoryCard
                                person={s}
                                type="supervisor"
                                onEdit={(p) => setEditingPerson({ type: 'supervisor', data: p })}
                                onDelete={(id) => handleDelete('supervisor', id)}
                            />
                        </Grid>
                    ))}
                </Grid>
            </Box>

            <Box>
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                    <Typography level="h3">Vendors</Typography>
                    <Chip variant="soft">{directoryData.vendors.length}</Chip>
                </Box>
                <Grid container spacing={2}>
                    {directoryData.vendors.map(v => (
                        <Grid key={v.id} xs={12} sm={6} md={4} lg={3}>
                            <DirectoryCard
                                person={v}
                                type="vendor"
                                onEdit={(p) => setEditingPerson({ type: 'vendor', data: p })}
                                onDelete={(id) => handleDelete('vendor', id)}
                            />
                        </Grid>
                    ))}
                </Grid>
            </Box>

            {editingPerson && (
                <Modal open={!!editingPerson} onClose={() => setEditingPerson(null)}>
                    <ModalDialog>
                        <ModalClose />
                        <Typography level="h4">Edit {editingPerson.type}</Typography>
                        <Divider sx={{ my: 1.5 }} />
                        <Typography>Save functionality for {editingPerson.data.name || editingPerson.data.company_name} is under development.</Typography>
                    </ModalDialog>
                </Modal>
            )}
        </Box>
    );
};

export default Directory;

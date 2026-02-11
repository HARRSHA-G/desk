import React, { useState } from 'react';
import {
    Button,
    FormControl,
    FormLabel,
    Grid,
    Input,
    Modal,
    ModalClose,
    ModalDialog,
    Stack,
    Tab,
    TabList,
    TabPanel,
    Tabs,
    Textarea,
    Typography,
} from '@mui/joy';

const AddPartnerModal = ({ open, onClose, onSave }) => {
    const [tab, setTab] = useState(0);
    const [formData, setFormData] = useState({
        name: '',
        contact: '',
        phone: '',
        email: '',
        ifsc: '',
        account: '',
        nominee: '',
        kycId: '',
        declaration: '',
    });

    const handleSubmit = () => {
        onSave(formData);
        setFormData({
            name: '',
            contact: '',
            phone: '',
            email: '',
            ifsc: '',
            account: '',
            nominee: '',
            kycId: '',
            declaration: '',
        });
        setTab(0);
    };

    return (
        <Modal open={open} onClose={onClose}>
            <ModalDialog
                sx={{
                    maxWidth: 780,
                    width: '90%',
                    bgcolor: 'background.surface',
                    border: '1px solid',
                    borderColor: 'divider',
                    backdropFilter: 'blur(16px)',
                    boxShadow: 'lg',
                }}
            >
                <ModalClose />
                <Typography level="h4" sx={{ mb: 1.5 }}>
                    Add Channel Partner
                </Typography>
                <Tabs value={tab} onChange={(e, val) => setTab(val)} sx={{ '--Tabs-gap': '16px' }}>
                    <TabList>
                        <Tab value={0}>Personal Info</Tab>
                        <Tab value={1}>Bank & Nominee</Tab>
                        <Tab value={2}>KYC / Declaration</Tab>
                    </TabList>

                    <TabPanel value={0}>
                        <Grid container spacing={2}>
                            <Grid xs={12} sm={6}>
                                <FormControl>
                                    <FormLabel>Company / Firm</FormLabel>
                                    <Input
                                        value={formData.name}
                                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                                        placeholder="Partner name"
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={12} sm={6}>
                                <FormControl>
                                    <FormLabel>Primary Contact</FormLabel>
                                    <Input
                                        value={formData.contact}
                                        onChange={(e) => setFormData({ ...formData, contact: e.target.value })}
                                        placeholder="Contact person"
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={12} sm={6}>
                                <FormControl>
                                    <FormLabel>Phone</FormLabel>
                                    <Input
                                        value={formData.phone}
                                        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                                        placeholder="+91 9xxxx xxxxx"
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={12} sm={6}>
                                <FormControl>
                                    <FormLabel>Email</FormLabel>
                                    <Input
                                        value={formData.email}
                                        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                                        placeholder="contact@email.com"
                                    />
                                </FormControl>
                            </Grid>
                        </Grid>
                    </TabPanel>

                    <TabPanel value={1}>
                        <Grid container spacing={2}>
                            <Grid xs={12} sm={6}>
                                <FormControl>
                                    <FormLabel>Account Number</FormLabel>
                                    <Input
                                        value={formData.account}
                                        onChange={(e) => setFormData({ ...formData, account: e.target.value })}
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={12} sm={6}>
                                <FormControl>
                                    <FormLabel>IFSC</FormLabel>
                                    <Input
                                        value={formData.ifsc}
                                        onChange={(e) => setFormData({ ...formData, ifsc: e.target.value })}
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={12}>
                                <FormControl>
                                    <FormLabel>Nominee</FormLabel>
                                    <Input
                                        value={formData.nominee}
                                        onChange={(e) => setFormData({ ...formData, nominee: e.target.value })}
                                    />
                                </FormControl>
                            </Grid>
                        </Grid>
                    </TabPanel>

                    <TabPanel value={2}>
                        <Grid container spacing={2}>
                            <Grid xs={12} sm={6}>
                                <FormControl>
                                    <FormLabel>KYC ID</FormLabel>
                                    <Input
                                        value={formData.kycId}
                                        onChange={(e) => setFormData({ ...formData, kycId: e.target.value })}
                                        placeholder="PAN / GST / Aadhaar"
                                    />
                                </FormControl>
                            </Grid>
                            <Grid xs={12}>
                                <FormControl>
                                    <FormLabel>Declaration</FormLabel>
                                    <Textarea
                                        minRows={3}
                                        value={formData.declaration}
                                        onChange={(e) => setFormData({ ...formData, declaration: e.target.value })}
                                        placeholder="KYC declaration, compliance notes..."
                                    />
                                </FormControl>
                            </Grid>
                        </Grid>
                    </TabPanel>
                </Tabs>

                <Stack direction="row" justifyContent="flex-end" spacing={1.5} sx={{ mt: 3 }}>
                    <Button variant="soft" color="neutral" onClick={onClose}>
                        Cancel
                    </Button>
                    <Button onClick={handleSubmit}>Save Partner</Button>
                </Stack>
            </ModalDialog>
        </Modal>
    );
};

export default AddPartnerModal;

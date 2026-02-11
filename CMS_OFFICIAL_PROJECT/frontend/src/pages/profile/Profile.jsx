import React, { useState, useEffect } from 'react';
import {
    Box,
    Typography,
    Button,
    Card,
    Avatar,
    Grid,
    Input,
    FormLabel,
    FormControl,
    Select,
    Option,
    Divider,
    Stack,
    IconButton,
    Modal,
    ModalDialog,
    ModalClose,
    DialogTitle,
    DialogContent,
    DialogActions,
    useColorScheme
} from '@mui/joy';
import {
    Edit as EditIcon,
    Logout as LogoutIcon,
    Visibility,
    VisibilityOff
} from '@mui/icons-material';
import api from '../../api';

const Profile = () => {
    const { mode, setMode } = useColorScheme();
    const [user, setUser] = useState({
        display_name: '',
        username: '',
        email: '',
        account_type: 'Admin', // default
        theme_preference: 'dark',
        phone_local: '',
        avatar_url: null,
        date_joined: new Date().toISOString(),
        last_login: new Date().toISOString()
    });

    const [projectCount, setProjectCount] = useState(0);
    const [loading, setLoading] = useState(true);
    const [logoutModalOpen, setLogoutModalOpen] = useState(false);

    // Password Visibility
    const [showCurrentPassword, setShowCurrentPassword] = useState(false);
    const [showNewPassword, setShowNewPassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);

    useEffect(() => {
        // Fetch profile data
        const fetchProfile = async () => {
            try {
                setLoading(true);
                // This endpoint logic is assumed; adjust based on actual backend
                // In a real generic app, we might hit /api/user/profile/
                // For now, we'll simulate or try a likely endpoint
                // const response = await api.get('/api/user/profile/');
                // setUser(response.data);

                // Mock data for demonstration until backend is 100% confirmed
                setTimeout(() => {
                    setUser({
                        display_name: 'Admin User',
                        username: 'admin',
                        email: 'admin@constructflow.com',
                        account_type: 'Super Admin',
                        theme_preference: 'dark',
                        phone_local: '9876543210',
                        avatar_url: null,
                        date_joined: '2025-01-01',
                        last_login: new Date().toISOString()
                    });
                    setProjectCount(12);
                    setLoading(false);
                }, 800);
            } catch (error) {
                console.error("Failed to load profile", error);
                setLoading(false);
            }
        };

        fetchProfile();
    }, []);

    const handleLogout = async () => {
        try {
            await api.post('/logout/'); // Assumed Django logout endpoint
            window.location.href = '/login'; // Redirect manually or via router
        } catch (error) {
            console.error("Logout failed", error);
            // Force redirect anyway
            window.location.href = '/login';
        }
    };

    const handleSave = (e) => {
        e.preventDefault();
        // Logic to save profile changes
        alert('Profile updated successfully (Mock)');
    };

    return (
        <Box sx={{ maxWidth: '960px', margin: '0 auto', p: { xs: 2, md: 4 }, display: 'flex', flexDirection: 'column', gap: 4 }} className="fade-in">

            {/* Profile Card */}
            <Card variant="outlined" sx={{
                p: 4,
                borderRadius: '24px',
                bgcolor: 'background.surface',
                boxShadow: 'lg',
                borderColor: 'neutral.outlinedBorder'
            }}>

                {/* Header Section */}
                <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2, mb: 4, textAlign: 'center' }}>
                    <Box sx={{ position: 'relative' }}>
                        <Avatar
                            src={user.avatar_url}
                            alt={user.display_name}
                            sx={{
                                width: 120,
                                height: 120,
                                fontSize: '3rem',
                                border: '4px solid',
                                borderColor: 'background.body',
                                boxShadow: 'lg'
                            }}
                        >
                            {user.display_name?.charAt(0) || 'U'}
                        </Avatar>
                        <IconButton
                            size="sm"
                            variant="solid"
                            color="primary"
                            sx={{
                                position: 'absolute',
                                bottom: 0,
                                right: 0,
                                borderRadius: '50%',
                                border: '4px solid',
                                borderColor: 'background.body'
                            }}
                        >
                            <EditIcon fontSize="small" />
                        </IconButton>
                    </Box>

                    <Box>
                        <Typography level="h2" sx={{ fontWeight: 600, fontSize: '2rem' }}>{user.display_name}</Typography>
                        <Typography level="body-sm" textColor="text.tertiary">{user.email}</Typography>
                    </Box>

                    <Stack direction="row" spacing={1} flexWrap="wrap" justifyContent="center">
                        <Typography level="body-xs" variant="soft" color="primary" sx={{ borderRadius: 'xl', px: 1 }}>
                            {user.account_type}
                        </Typography>
                        <Typography level="body-xs" variant="soft" color="neutral" sx={{ borderRadius: 'xl', px: 1 }}>
                            Joined {new Date(user.date_joined).toLocaleDateString()}
                        </Typography>
                    </Stack>
                </Box>

                {/* Metrics */}
                <Box sx={{ display: 'flex', justifyContent: 'center', mb: 4 }}>
                    <Card variant="soft" color="primary" sx={{ width: '100%', maxWidth: 400, textAlign: 'center', borderRadius: 'lg' }}>
                        <Typography level="body-xs" textTransform="uppercase" letterSpacing="1px" fontWeight="lg">Projects</Typography>
                        <Typography level="h2" sx={{ fontSize: '2.5rem', my: 1 }}>{projectCount}</Typography>
                        <Typography level="body-xs">Across all layouts and statuses</Typography>
                    </Card>
                </Box>

                {/* Form */}
                <form onSubmit={handleSave}>
                    <Grid container spacing={3}>

                        {/* Account Details */}
                        <Grid xs={12}>
                            <Typography level="h4" sx={{ mb: 2 }}>Account Details</Typography>
                        </Grid>

                        <Grid xs={12} md={6}>
                            <FormControl>
                                <FormLabel>Display Name</FormLabel>
                                <Input
                                    name="display_name"
                                    value={user.display_name}
                                    onChange={(e) => setUser({ ...user, display_name: e.target.value })}
                                />
                            </FormControl>
                        </Grid>

                        <Grid xs={12} md={6}>
                            <FormControl>
                                <FormLabel>Username</FormLabel>
                                <Input
                                    name="username"
                                    value={user.username}
                                    readOnly
                                    variant="soft"
                                />
                            </FormControl>
                        </Grid>

                        <Grid xs={12} md={6}>
                            <FormControl>
                                <FormLabel>Email</FormLabel>
                                <Input
                                    name="email"
                                    value={user.email}
                                    onChange={(e) => setUser({ ...user, email: e.target.value })}
                                    type="email"
                                />
                            </FormControl>
                        </Grid>

                        <Grid xs={12} md={6}>
                            <FormControl>
                                <FormLabel>Theme Preference</FormLabel>
                                <Select
                                    name="theme_preference"
                                    value={mode}
                                    onChange={(_, val) => {
                                        setMode(val);
                                        setUser({ ...user, theme_preference: val });
                                    }}
                                >
                                    <Option value="dark">Dark</Option>
                                    <Option value="light">Light</Option>
                                </Select>
                            </FormControl>
                        </Grid>

                        <Grid xs={12} md={6}>
                            <FormControl>
                                <FormLabel>Phone Number</FormLabel>
                                <Box sx={{ display: 'flex', gap: 1 }}>
                                    <Select name="phone_country" defaultValue="+91" sx={{ width: 100 }}>
                                        <Option value="+91">+91</Option>
                                    </Select>
                                    <Input
                                        name="phone_local"
                                        value={user.phone_local}
                                        onChange={(e) => setUser({ ...user, phone_local: e.target.value })}
                                        placeholder="10-digit number"
                                        fullWidth
                                    />
                                </Box>
                            </FormControl>
                        </Grid>

                        {/* Password Section */}
                        <Grid xs={12} sx={{ mt: 2 }}>
                            <Typography level="h4" sx={{ mb: 1 }}>Password</Typography>
                            <Typography level="body-xs" textColor="text.tertiary" sx={{ mb: 2 }}>Leave blank to keep current password</Typography>
                        </Grid>

                        <Grid xs={12} md={4}>
                            <FormControl>
                                <FormLabel>Current Password</FormLabel>
                                <Input
                                    name="current_password"
                                    type={showCurrentPassword ? 'text' : 'password'}
                                    endDecorator={
                                        <IconButton onClick={() => setShowCurrentPassword(!showCurrentPassword)}>
                                            {showCurrentPassword ? <VisibilityOff /> : <Visibility />}
                                        </IconButton>
                                    }
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} md={4}>
                            <FormControl>
                                <FormLabel>New Password</FormLabel>
                                <Input
                                    name="new_password"
                                    type={showNewPassword ? 'text' : 'password'}
                                    endDecorator={
                                        <IconButton onClick={() => setShowNewPassword(!showNewPassword)}>
                                            {showNewPassword ? <VisibilityOff /> : <Visibility />}
                                        </IconButton>
                                    }
                                />
                            </FormControl>
                        </Grid>
                        <Grid xs={12} md={4}>
                            <FormControl>
                                <FormLabel>Confirm Password</FormLabel>
                                <Input
                                    name="confirm_password"
                                    type={showConfirmPassword ? 'text' : 'password'}
                                    endDecorator={
                                        <IconButton onClick={() => setShowConfirmPassword(!showConfirmPassword)}>
                                            {showConfirmPassword ? <VisibilityOff /> : <Visibility />}
                                        </IconButton>
                                    }
                                />
                            </FormControl>
                        </Grid>

                        <Grid xs={12} sx={{ mt: 4, display: 'flex', justifyContent: 'center' }}>
                            <Button size="lg" type="submit" sx={{ borderRadius: 'xl', px: 6 }}>Save Changes</Button>
                        </Grid>

                    </Grid>
                </form>

                {/* Security / Logout */}
                <Box sx={{ mt: 6, p: 3, borderRadius: 'lg', bgcolor: 'background.level1', border: '1px solid', borderColor: 'divider' }}>
                    <Typography level="h4" sx={{ mb: 1 }}>Security</Typography>
                    <Typography level="body-sm" textColor="text.secondary" sx={{ mb: 2 }}>
                        Sign out of this device. You will need your credentials to log in again.
                    </Typography>
                    <Button variant="outlined" color="danger" startDecorator={<LogoutIcon />} onClick={() => setLogoutModalOpen(true)}>
                        Log Out
                    </Button>
                </Box>

            </Card>

            {/* Logout Modal */}
            <Modal open={logoutModalOpen} onClose={() => setLogoutModalOpen(false)}>
                <ModalDialog variant="outlined" role="alertdialog">
                    <DialogTitle>
                        <LogoutIcon />
                        Confirmation
                    </DialogTitle>
                    <DialogContent>
                        Are you sure you want to log out?
                    </DialogContent>
                    <DialogActions>
                        <Button variant="solid" color="danger" onClick={handleLogout}>
                            Logout
                        </Button>
                        <Button variant="plain" color="neutral" onClick={() => setLogoutModalOpen(false)}>
                            Cancel
                        </Button>
                    </DialogActions>
                </ModalDialog>
            </Modal>

        </Box>
    );
};

export default Profile;

import React, { useState } from 'react';
import { useLocation } from 'react-router-dom';
import Box from '@mui/joy/Box';
import IconButton from '@mui/joy/IconButton';
import Typography from '@mui/joy/Typography';
import MenuIcon from '@mui/icons-material/Menu';
import Sidebar from './Sidebar';

const Layout = ({ children }) => {
    const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
    const location = useLocation();

    return (
        <Box sx={{ display: 'flex', minHeight: '100vh', bgcolor: 'background.body' }}>
            {/* Rule 28: Bypass Blocks (Skip to content) */}
            <a href="#main-content" className="skip-to-content">
                Skip to main content
            </a>

            {/* Rule 45: Live region for status announcements */}
            <Box
                aria-live="polite"
                aria-atomic="true"
                sx={{ position: 'absolute', width: 1, height: 1, p: 0, m: -1, overflow: 'hidden', clip: 'rect(0,0,0,0)', border: 0 }}
                id="status-announcer"
            />

            {/* Mobile Topbar */}
            <Box
                sx={{
                    display: { xs: 'flex', md: 'none' },
                    position: 'fixed',
                    top: 0,
                    left: 0,
                    right: 0,
                    height: '60px',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    px: 2,
                    bgcolor: 'background.surface',
                    borderBottom: '1px solid',
                    borderColor: 'divider',
                    zIndex: 1100,
                }}
            >
                <IconButton onClick={() => setIsMobileMenuOpen(true)}>
                    <MenuIcon />
                </IconButton>
                <Box sx={{ display: 'flex', gap: 1, alignItems: 'center' }}>
                    <Box
                        sx={{
                            width: 24,
                            height: 24,
                            borderRadius: 'xs',
                            bgcolor: 'primary.softBg',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                        }}
                    >
                        <i className="ri-building-4-fill" style={{ color: 'var(--joy-palette-primary-500)', fontSize: '0.9rem' }}></i>
                    </Box>
                    <Typography level="title-md" fontWeight="lg">
                        ConstructFlow
                    </Typography>
                </Box>
                <Box sx={{ width: 40 }} /> {/* Spacer to balance menu icon */}
            </Box>

            <Sidebar isOpen={isMobileMenuOpen} onClose={() => setIsMobileMenuOpen(false)} />

            <Box
                component="main"
                id="main-content"
                sx={{
                    flex: 1,
                    display: 'flex',
                    flexDirection: 'column',
                    pt: { xs: '60px', md: 0 }, // Mobile topbar height
                    minWidth: 0, // Prevent overflow issues
                    overflowX: 'hidden', // Prevent scrollbar during transitions
                }}
            >
                {children}
            </Box>
        </Box>
    );
};

export default Layout;

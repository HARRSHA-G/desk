import React, { useState } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import Box from '@mui/joy/Box';
import List from '@mui/joy/List';
import ListItem from '@mui/joy/ListItem';
import ListItemButton from '@mui/joy/ListItemButton';
import ListItemDecorator from '@mui/joy/ListItemDecorator';
import ListItemContent from '@mui/joy/ListItemContent';
import Typography from '@mui/joy/Typography';
import Sheet from '@mui/joy/Sheet';
import IconButton from '@mui/joy/IconButton';
import KeyboardArrowDown from '@mui/icons-material/KeyboardArrowDown';
import CloseIcon from '@mui/icons-material/Close';

const NavItem = ({ to, icon, label, end = false, currentPath, onClose }) => (
  <ListItem>
    <ListItemButton
      component={NavLink}
      to={to}
      end={end}
      selected={end ? currentPath === to : currentPath.startsWith(to)}
      onClick={() => (typeof window !== 'undefined' && window.innerWidth <= 1024) && onClose()}
      sx={{
        borderRadius: 'md',
        gap: 1.5,
        '&.active': {
          bgcolor: 'primary.softBg',
          color: 'primary.plainColor',
          fontWeight: '600',
        }
      }}
    >
      <ListItemDecorator>
        <i className={icon} style={{ fontSize: '1.2rem' }}></i>
      </ListItemDecorator>
      <ListItemContent>{label}</ListItemContent>
    </ListItemButton>
  </ListItem>
);

const Sidebar = ({ isOpen, onClose }) => {
  const location = useLocation();
  const [salesHover, setSalesHover] = useState(false);
  const [crmHover, setCrmHover] = useState(false);

  const salesOpen = salesHover || location.pathname.includes('/sales/');
  const crmOpen = crmHover || location.pathname.includes('/crm/');

  const toggleOnMobile = (setter, current) => {
    if (typeof window !== 'undefined' && window.innerWidth <= 1024) {
      setter(!current);
    }
  };

  return (
    <>
      <Sheet
        className="Sidebar"
        sx={{
          position: { xs: 'fixed', md: 'sticky' },
          transform: {
            xs: isOpen ? 'translateX(0)' : 'translateX(-100%)',
            md: 'none',
          },
          transition: 'transform 0.4s, width 0.4s',
          height: '100vh',
          width: '260px',
          top: 0,
          p: 2,
          flexShrink: 0,
          display: 'flex',
          flexDirection: 'column',
          gap: 2,
          borderRight: '1px solid',
          borderColor: 'divider',
          zIndex: 10000,
          bgcolor: 'background.surface',
        }}
      >
        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <Box sx={{ display: 'flex', gap: 1.5, alignItems: 'center' }}>
            <Box
              sx={{
                width: 32,
                height: 32,
                borderRadius: 'md',
                background: 'linear-gradient(135deg, #d4af37, #f3e5b5)', // Gold to Champagne
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <i className="ri-building-4-fill" style={{ color: '#1A1A1B' }}></i>
            </Box>
            <Typography level="title-lg" sx={{ fontWeight: 700 }}>
              Construct<Typography color="primary">Flow</Typography>
            </Typography>
          </Box>
          <IconButton
            variant="plain"
            sx={{ display: { xs: 'flex', md: 'none' } }}
            onClick={onClose}
          >
            <CloseIcon />
          </IconButton>
        </Box>

        <Box sx={{
          flex: 1,
          overflowY: 'auto',
          '&::-webkit-scrollbar': { display: 'none' },
          scrollbarWidth: 'none',
          msOverflowStyle: 'none',
        }}>
          <List
            size="sm"
            sx={{
              gap: 1,
              '--ListItem-radius': '8px',
            }}
          >
            <NavItem to="/dashboard" icon="ri-layout-grid-line" label="Dashboard" currentPath={location.pathname} onClose={onClose} />
            <NavItem to="/projects" icon="ri-folder-3-line" label="Projects" end currentPath={location.pathname} onClose={onClose} />

            {/* Sales Dropdown */}
            <ListItem
              nested
              onMouseEnter={() => setSalesHover(true)}
              onMouseLeave={() => setSalesHover(false)}
            >
              <ListItemButton
                aria-expanded={salesOpen}
                aria-controls="sales-nav-list"
                onClick={(e) => { e.preventDefault(); toggleOnMobile(setSalesHover, salesOpen); }}
                selected={salesOpen}
              >
                <ListItemDecorator><i className="ri-store-2-line" style={{ fontSize: '1.2rem' }}></i></ListItemDecorator>
                <ListItemContent>Sales</ListItemContent>
                <KeyboardArrowDown sx={{ transform: salesOpen ? 'rotate(180deg)' : 'none', transition: '0.2s' }} />
              </ListItemButton>
              {salesOpen && (
                <List id="sales-nav-list" sx={{ gap: 0.5 }}>
                  <NavItem to="/sales/multi-flat-sales" label="Flat Sales" currentPath={location.pathname} onClose={onClose} />
                  <NavItem to="/sales/multi-plot-sales" label="Plot Sales" currentPath={location.pathname} onClose={onClose} />
                </List>
              )}
            </ListItem>

            {/* CRM Dropdown */}
            <ListItem
              nested
              onMouseEnter={() => setCrmHover(true)}
              onMouseLeave={() => setCrmHover(false)}
            >
              <ListItemButton
                aria-expanded={crmOpen}
                aria-controls="crm-nav-list"
                onClick={(e) => { e.preventDefault(); toggleOnMobile(setCrmHover, crmOpen); }}
                selected={crmOpen}
              >
                <ListItemDecorator><i className="ri-contacts-book-2-line" style={{ fontSize: '1.2rem' }}></i></ListItemDecorator>
                <ListItemContent>CRM</ListItemContent>
                <KeyboardArrowDown sx={{ transform: crmOpen ? 'rotate(180deg)' : 'none', transition: '0.2s' }} />
              </ListItemButton>
              {crmOpen && (
                <List id="crm-nav-list" sx={{ gap: 0.5 }}>
                  <NavItem to="/crm/overview" label="CRM Overview" currentPath={location.pathname} onClose={onClose} />
                  <NavItem to="/crm/channel-partners" label="Channel Partners" currentPath={location.pathname} onClose={onClose} />
                  <NavItem to="/crm/customers" label="Customers" currentPath={location.pathname} onClose={onClose} />
                </List>
              )}
            </ListItem>

            <NavItem to="/expenses" icon="ri-wallet-3-line" label="Expenses" currentPath={location.pathname} onClose={onClose} />
            <NavItem to="/stock" icon="ri-stack-line" label="Stock Management" currentPath={location.pathname} onClose={onClose} />
            <NavItem to="/finance/payments" icon="ri-bank-card-2-line" label="Payments" currentPath={location.pathname} onClose={onClose} />
            <NavItem to="/directory/supervisors" icon="ri-user-star-line" label="Supervisors" currentPath={location.pathname} onClose={onClose} />
            <NavItem to="/directory/vendors" icon="ri-building-line" label="Vendors" currentPath={location.pathname} onClose={onClose} />
            <NavItem to="/attendance" icon="ri-time-line" label="Attendance" currentPath={location.pathname} onClose={onClose} />
            <NavItem to="/finance/track-finances" icon="ri-bar-chart-2-line" label="Track Finances" currentPath={location.pathname} onClose={onClose} />
            <NavItem to="/insights" icon="ri-pie-chart-2-line" label="Insights" currentPath={location.pathname} onClose={onClose} />

            <List sx={{ mt: 2, borderTop: '1px solid', borderColor: 'divider', pt: 2 }}>
              <NavItem to="/profile" icon="ri-user-3-line" label="Profile" currentPath={location.pathname} onClose={onClose} />
            </List>
          </List>
        </Box>

        <Box sx={{ pt: 1, borderTop: '1px solid', borderColor: 'divider' }}>
          <Typography level="body-xs" sx={{ opacity: 0.6 }}>
            Powered by <strong>ConstructFlow</strong>
          </Typography>
        </Box>
      </Sheet>

      {/* Mobile Overlay */}
      {isOpen && (
        <Box
          sx={{
            position: 'fixed',
            inset: 0,
            bgcolor: 'rgba(0,0,0,0.5)',
            zIndex: 9999,
            backdropFilter: 'blur(4px)',
            display: { md: 'none' }
          }}
          onClick={onClose}
        />
      )}
    </>
  );
};

export default Sidebar;

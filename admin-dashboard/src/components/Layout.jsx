import { useState } from 'react';
import { Outlet, useNavigate } from 'react-router-dom';
import { styled } from '@mui/material/styles';
import {
  Box,
  Drawer,
  AppBar,
  Toolbar,
  List,
  Typography,
  Divider,
  IconButton,
  ListItem,
  ListItemButton,
  ListItemIcon,
  ListItemText,
} from '@mui/material';
import {
  Menu as MenuIcon,
  ChevronLeft as ChevronLeftIcon,
  Dashboard as DashboardIcon,
  Inventory as InventoryIcon,
  Group as GroupIcon,
  Logout as LogoutIcon,
} from '@mui/icons-material';
import { useAuth } from '../context/AuthContext';

const drawerWidth = 240;

// ✅ Fixed: Removed TypeScript generics (`< { open?: boolean } >`)
const Main = styled('main', { shouldForwardProp: (prop) => prop !== 'open' })(
  ({ theme, open }) => ({
    flexGrow: 1,
    padding: theme.spacing(3),
    transition: theme.transitions.create('margin', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
    marginLeft: `-${drawerWidth}px`,
    width: '100%',
    overflowX: 'hidden',
    ...(open && {
      transition: theme.transitions.create('margin', {
        easing: theme.transitions.easing.easeOut,
        duration: theme.transitions.duration.enteringScreen,
      }),
      marginLeft: 0,
    }),
  })
);

const DrawerHeader = styled('div')(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  padding: theme.spacing(0, 1),
  ...theme.mixins.toolbar,
  justifyContent: 'flex-end',
}));

export default function Layout() {
  const [open, setOpen] = useState(true);
  const navigate = useNavigate();
  const { user, logout } = useAuth();

  const handleDrawerOpen = () => setOpen(true);
  const handleDrawerClose = () => setOpen(false);

  return (
    <Box sx={{ display: 'flex' }}>
      <AppBar 
        position="fixed" 
        sx={{ 
          zIndex: (theme) => theme.zIndex.drawer + 1,
          backgroundColor: '#0A83BC',
          boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)',
        }}
      >
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            onClick={handleDrawerOpen}
            edge="start"
            sx={{ mr: 2, ...(open && { display: 'none' }) }}
          >
            <MenuIcon />
          </IconButton>
          <Box
            component="img"
            src="/lenshive_logo.png"
            alt="LensHive Logo"
            sx={{
              height: 40,
              width: 'auto',
              mr: 2,
            }}
          />
          <Typography 
            variant="h6" 
            noWrap 
            component="div" 
            sx={{ 
              flexGrow: 1,
              fontWeight: 600,
            }}
          >
            LensHive Admin
          </Typography>
          <IconButton
            color="inherit"
            onClick={() => logout()}
            aria-label="logout"
            title="Logout"
            sx={{
              '&:hover': {
                backgroundColor: 'rgba(255, 255, 255, 0.1)',
              },
            }}
          >
            <LogoutIcon />
          </IconButton>
        </Toolbar>
      </AppBar>

      <Drawer
        sx={{
          width: drawerWidth,
          flexShrink: 0,
          '& .MuiDrawer-paper': {
            width: drawerWidth,
            boxSizing: 'border-box',
            backgroundColor: '#FFFFFF',
            borderRight: '1px solid #E0E0E0',
          },
        }}
        variant="persistent"
        anchor="left"
        open={open}
      >
        <DrawerHeader>
          <IconButton 
            onClick={handleDrawerClose}
            sx={{
              '&:hover': {
                backgroundColor: '#F5F5F5',
              },
            }}
          >
            <ChevronLeftIcon />
          </IconButton>
        </DrawerHeader>
        <Divider sx={{ borderColor: '#E0E0E0' }} />
        <List sx={{ pt: 1 }}>
          <ListItem disablePadding>
            <ListItemButton 
              onClick={() => navigate('/')}
              sx={{
                borderRadius: '8px',
                mx: 1,
                mb: 0.5,
                '&:hover': {
                  backgroundColor: '#F5F5F5',
                },
                '&.Mui-selected': {
                  backgroundColor: '#E3F2FD',
                  color: '#0A83BC',
                  '&:hover': {
                    backgroundColor: '#E3F2FD',
                  },
                  '& .MuiListItemIcon-root': {
                    color: '#0A83BC',
                  },
                },
              }}
            >
              <ListItemIcon>
                <DashboardIcon />
              </ListItemIcon>
              <ListItemText 
                primary="Dashboard"
                primaryTypographyProps={{
                  fontWeight: 500,
                }}
              />
            </ListItemButton>
          </ListItem>
          <ListItem disablePadding>
            <ListItemButton 
              onClick={() => navigate('/products')}
              sx={{
                borderRadius: '8px',
                mx: 1,
                mb: 0.5,
                '&:hover': {
                  backgroundColor: '#F5F5F5',
                },
                '&.Mui-selected': {
                  backgroundColor: '#E3F2FD',
                  color: '#0A83BC',
                  '&:hover': {
                    backgroundColor: '#E3F2FD',
                  },
                  '& .MuiListItemIcon-root': {
                    color: '#0A83BC',
                  },
                },
              }}
            >
              <ListItemIcon>
                <InventoryIcon />
              </ListItemIcon>
              <ListItemText 
                primary="Products"
                primaryTypographyProps={{
                  fontWeight: 500,
                }}
              />
            </ListItemButton>
          </ListItem>
          {user?.role === 'admin' && (
            <ListItem disablePadding>
              <ListItemButton 
                onClick={() => navigate('/users')}
                sx={{
                  borderRadius: '8px',
                  mx: 1,
                  mb: 0.5,
                  '&:hover': {
                    backgroundColor: '#F5F5F5',
                  },
                  '&.Mui-selected': {
                    backgroundColor: '#E3F2FD',
                    color: '#0A83BC',
                    '&:hover': {
                      backgroundColor: '#E3F2FD',
                    },
                    '& .MuiListItemIcon-root': {
                      color: '#0A83BC',
                    },
                  },
                }}
              >
                <ListItemIcon>
                  <GroupIcon />
                </ListItemIcon>
                <ListItemText 
                  primary="Users"
                  primaryTypographyProps={{
                    fontWeight: 500,
                  }}
                />
              </ListItemButton>
            </ListItem>
          )}
        </List>
      </Drawer>

      <Main 
        open={open}
        sx={{
          backgroundColor: '#FFFFFF',
          overflowX: 'hidden',
        }}
      >
        <DrawerHeader />
        <Box sx={{ width: '100%', maxWidth: '100%', overflowX: 'hidden' }}>
          <Outlet />
        </Box>
      </Main>
    </Box>
  );
}

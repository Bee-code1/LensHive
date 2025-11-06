import { useState, useEffect } from 'react';
import {
  Box,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  TextField,
  IconButton,
  Typography,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Alert,
  Snackbar,
} from '@mui/material';
import { DataGrid, GridToolbar } from '@mui/x-data-grid';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
} from '@mui/icons-material';
import { usePermissions } from '../hooks/usePermissions';

export default function Users() {
  const [users, setUsers] = useState([]);
  const [open, setOpen] = useState(false);
  const [editUser, setEditUser] = useState(null);
  const [formData, setFormData] = useState({
    full_name: '',
    email: '',
    password: '',
    role: 'customer',
    is_active: true,
  });
  const [snackbar, setSnackbar] = useState({
    open: false,
    message: '',
    severity: 'success',
  });

  const { isAdmin } = usePermissions();

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await fetch('http://localhost:8000/api/auth/users/', {
        headers: {
          'Authorization': `Token ${token}`,
        },
      });
      if (response.ok) {
        const data = await response.json();
        // Format data to ensure consistent structure
        const formattedUsers = data.map(user => ({
          ...user,
          id: user.id,
          full_name: user.full_name,
          email: user.email,
          role: user.role,
          is_active: user.is_active,
        }));
        setUsers(formattedUsers);
      } else {
        const error = await response.json();
        showNotification(error.message || 'Failed to fetch users', 'error');
      }
    } catch (error) {
      console.error('Error fetching users:', error);
      showNotification('Error fetching users', 'error');
    }
  };

  const handleOpen = (user = null) => {
    if (user) {
      setEditUser(user);
      setFormData({
        full_name: user.full_name,
        email: user.email,
        role: user.role,
        is_active: user.is_active,
        password: '', // Don't populate password for edit
      });
    } else {
      setEditUser(null);
      setFormData({
        full_name: '',
        email: '',
        password: '',
        role: 'customer',
        is_active: true,
      });
    }
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setEditUser(null);
  };

  const showNotification = (message, severity = 'success') => {
    setSnackbar({
      open: true,
      message,
      severity,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const token = localStorage.getItem('token');
      // Ensure we're using the string representation of the UUID
      const url = editUser
        ? `http://localhost:8000/api/auth/users/${editUser.id.toString()}/`
        : 'http://localhost:8000/api/auth/users/create/';

      // Prepare data to send
      const dataToSend = {
        full_name: formData.full_name,
        email: formData.email.toLowerCase(),
        role: formData.role,
        is_active: formData.is_active
      };
      
      // Only include password if it's provided (for edit) or if creating new user
      if (formData.password) {
        dataToSend.password = formData.password;
      }

      if (!dataToSend.password && !editUser) {
        showNotification('Password is required for new users', 'error');
        return;
      }

      console.log('Making request to:', url);
      console.log('With data:', dataToSend);

      const response = await fetch(url, {
        method: editUser ? 'PUT' : 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Token ${token}`,
        },
        body: JSON.stringify(dataToSend),
      });

      console.log('Response status:', response.status);

      const data = await response.json();

      if (response.ok) {
        showNotification(
          editUser ? 'User updated successfully' : 'User created successfully',
          'success'
        );
        fetchUsers();
        handleClose();
      } else {
        // Handle specific error messages
        let errorMessage = 'Operation failed';
        if (typeof data === 'object') {
          // Try to find the first error message
          const firstError = Object.entries(data).find(([key, value]) => 
            Array.isArray(value) ? value[0] : value
          );
          if (firstError) {
            errorMessage = Array.isArray(firstError[1]) 
              ? firstError[1][0] 
              : firstError[1];
          }
        }
        showNotification(errorMessage, 'error');
      }
    } catch (error) {
      console.error('Error:', error);
      showNotification('Operation failed', 'error');
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this user?')) return;

    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`http://localhost:8000/api/auth/users/${id}/`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Token ${token}`,
        },
      });
      
      if (response.ok) {
        showNotification('User deleted successfully');
        fetchUsers();
      } else {
        const error = await response.json();
        showNotification(
          error.message || 'Failed to delete user',
          'error'
        );
      }
    } catch (error) {
      console.error('Error deleting user:', error);
      showNotification('Failed to delete user', 'error');
    }
  };

  const columns = [
    {
      field: 'full_name',
      headerName: 'Name',
      flex: 1,
      minWidth: 200,
    },
    {
      field: 'email',
      headerName: 'Email',
      flex: 1,
      minWidth: 200,
    },
    {
      field: 'role',
      headerName: 'Role',
      width: 120,
      renderCell: (params) => (
        <Box
          sx={{
            backgroundColor: params.value === 'admin' ? 'primary.main' : 'grey.200',
            color: params.value === 'admin' ? 'white' : 'text.primary',
            px: 1,
            py: 0.5,
            borderRadius: 1,
            fontSize: '0.875rem',
            textTransform: 'capitalize',
          }}
        >
          {params.value}
        </Box>
      ),
    },
    {
      field: 'is_active',
      headerName: 'Status',
      width: 120,
      renderCell: (params) => (
        <Box
          sx={{
            backgroundColor: params.value ? 'success.light' : 'error.light',
            color: params.value ? 'success.dark' : 'error.dark',
            px: 1,
            py: 0.5,
            borderRadius: 1,
            fontSize: '0.875rem',
          }}
        >
          {params.value ? 'Active' : 'Inactive'}
        </Box>
      ),
    },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 120,
      sortable: false,
      renderCell: (params) => (
        <Box>
          <IconButton 
            onClick={() => handleOpen(params.row)} 
            size="small"
            disabled={!isAdmin}
          >
            <EditIcon />
          </IconButton>
          <IconButton 
            onClick={() => handleDelete(params.row.id)} 
            size="small" 
            color="error"
            disabled={!isAdmin}
          >
            <DeleteIcon />
          </IconButton>
        </Box>
      ),
    },
  ];

  if (!isAdmin) {
    return (
      <Box sx={{ p: 3 }}>
        <Typography color="error">
          You don't have permission to access this page.
        </Typography>
      </Box>
    );
  }

  return (
    <Box>
      <Box sx={{ mb: 4, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <Typography variant="h5">Users</Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => handleOpen()}
        >
          Add User
        </Button>
      </Box>

      <Box sx={{ height: 600, width: '100%' }}>
        <DataGrid
          rows={users}
          columns={columns}
          pageSize={10}
          rowsPerPageOptions={[5, 10, 20]}
          checkboxSelection
          disableSelectionOnClick
          components={{ Toolbar: GridToolbar }}
          componentsProps={{
            toolbar: {
              showQuickFilter: true,
              quickFilterProps: { debounceMs: 500 },
            },
          }}
        />
      </Box>

      <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
        <DialogTitle>{editUser ? 'Edit User' : 'Add New User'}</DialogTitle>
        <form onSubmit={handleSubmit}>
          <DialogContent>
            <TextField
              fullWidth
              label="Full Name"
              margin="normal"
              value={formData.full_name}
              onChange={(e) => setFormData({ ...formData, full_name: e.target.value })}
              required
            />
            <TextField
              fullWidth
              label="Email"
              type="email"
              margin="normal"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              required
            />
            <TextField
              fullWidth
              label="Password"
              type="password"
              margin="normal"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              required={!editUser}
              helperText={editUser ? 'Leave blank to keep current password' : ''}
            />
            <FormControl fullWidth margin="normal">
              <InputLabel>Role</InputLabel>
              <Select
                value={formData.role}
                label="Role"
                onChange={(e) => setFormData({ ...formData, role: e.target.value })}
              >
                <MenuItem value="customer">Customer</MenuItem>
                <MenuItem value="staff">Staff</MenuItem>
                <MenuItem value="admin">Admin</MenuItem>
              </Select>
            </FormControl>
            <FormControl fullWidth margin="normal">
              <InputLabel>Status</InputLabel>
              <Select
                value={formData.is_active}
                label="Status"
                onChange={(e) => setFormData({ ...formData, is_active: e.target.value })}
              >
                <MenuItem value={true}>Active</MenuItem>
                <MenuItem value={false}>Inactive</MenuItem>
              </Select>
            </FormControl>
          </DialogContent>
          <DialogActions>
            <Button onClick={handleClose}>Cancel</Button>
            <Button type="submit" variant="contained">
              {editUser ? 'Update' : 'Create'}
            </Button>
          </DialogActions>
        </form>
      </Dialog>

      <Snackbar
        open={snackbar.open}
        autoHideDuration={6000}
        onClose={() => setSnackbar({ ...snackbar, open: false })}
        anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
      >
        <Alert severity={snackbar.severity} onClose={() => setSnackbar({ ...snackbar, open: false })}>
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
}
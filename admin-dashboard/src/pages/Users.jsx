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
    role: 'staff',
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
        setUsers(data);
      }
    } catch (error) {
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
        password: '', // Don't populate password for edit
      });
    } else {
      setEditUser(null);
      setFormData({
        full_name: '',
        email: '',
        password: '',
        role: 'staff',
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
      const url = editUser
        ? `http://localhost:8000/api/auth/users/${editUser.id}/`
        : 'http://localhost:8000/api/auth/users/';

      const response = await fetch(url, {
        method: editUser ? 'PUT' : 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Token ${token}`,
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        showNotification(
          editUser ? 'User updated successfully' : 'User created successfully'
        );
        fetchUsers();
        handleClose();
      } else {
        const error = await response.json();
        showNotification(error.message || 'Operation failed', 'error');
      }
    } catch (error) {
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
        showNotification('Failed to delete user', 'error');
      }
    } catch (error) {
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
        <Typography sx={{ 
          textTransform: 'capitalize',
          color: params.value === 'admin' ? 'primary.main' : 'text.primary',
        }}>
          {params.value}
        </Typography>
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
                <MenuItem value="staff">Staff</MenuItem>
                <MenuItem value="admin">Admin</MenuItem>
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
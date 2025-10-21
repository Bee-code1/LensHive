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
  MenuItem,
  Select,
  InputLabel,
  FormControl,
  Alert,
  Snackbar,
} from '@mui/material';
import { useAuth } from '../context/AuthContext';
import { DataGrid, GridToolbar } from '@mui/x-data-grid';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
} from '@mui/icons-material';

export default function Products() {
  const { user } = useAuth();
  const [products, setProducts] = useState([]);
  const [open, setOpen] = useState(false);
  const [editProduct, setEditProduct] = useState(null);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    price: '',
    stock: '',
    image: null,
  });

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const response = await fetch('http://localhost:8000/api/products/', {
        headers: {
          'Authorization': `Token ${localStorage.getItem('token')}`,
        }
      });
      if (response.ok) {
        const data = await response.json();
        setProducts(data);
      } else {
        showNotification('Failed to fetch products', 'error');
      }
    } catch (error) {
      console.error('Error fetching products:', error);
      showNotification('Error loading products', 'error');
    }
  };

  const handleOpen = (product = null) => {
    if (product) {
      setEditProduct(product);
      setFormData({
        name: product.name,
        description: product.description,
        price: product.price.toString(),
        stock: product.stock.toString(),
        image: null,
      });
    } else {
      setEditProduct(null);
      setFormData({
        name: '',
        description: '',
        price: '',
        stock: '',
        image: null,
      });
    }
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setEditProduct(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const formDataToSend = new FormData();
    Object.keys(formData).forEach(key => {
      if (formData[key] !== null) {
        formDataToSend.append(key, formData[key]);
      }
    });

    try {
      const url = editProduct
        ? `http://localhost:8000/api/products/${editProduct.id}/`
        : 'http://localhost:8000/api/products/';
      
      const response = await fetch(url, {
        method: editProduct ? 'PUT' : 'POST',
        headers: {
          'Authorization': `Token ${localStorage.getItem('token')}`,
        },
        body: formDataToSend,
      });

      if (response.ok) {
        fetchProducts();
        handleClose();
      }
    } catch (error) {
      console.error('Error saving product:', error);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this product?')) {
      try {
        const response = await fetch(`http://localhost:8000/api/products/${id}/`, {
          method: 'DELETE',
          headers: {
            'Authorization': `Token ${localStorage.getItem('token')}`,
          },
        });
        if (response.ok) {
          fetchProducts();
        }
      } catch (error) {
        console.error('Error deleting product:', error);
      }
    }
  };

  const [snackbar, setSnackbar] = useState({
    open: false,
    message: '',
    severity: 'success',
  });

  const handleCloseSnackbar = () => {
    setSnackbar({ ...snackbar, open: false });
  };

  const showNotification = (message, severity = 'success') => {
    setSnackbar({
      open: true,
      message,
      severity,
    });
  };

  const columns = [
    {
      field: 'image',
      headerName: 'Image',
      width: 100,
      renderCell: (params) => (
        <Box
          component="img"
          sx={{
            height: 50,
            width: 50,
            objectFit: 'cover',
            borderRadius: 1,
          }}
          src={params.row.image || '/placeholder.png'}
          alt={params.row.name}
        />
      ),
    },
    {
      field: 'name',
      headerName: 'Name',
      flex: 1,
      minWidth: 200,
    },
    {
      field: 'description',
      headerName: 'Description',
      flex: 2,
      minWidth: 300,
    },
    {
      field: 'price',
      headerName: 'Price',
      width: 120,
      renderCell: (params) => `$${params.row.price}`,
    },
    {
      field: 'stock',
      headerName: 'Stock',
      width: 120,
    },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 120,
      sortable: false,
      renderCell: (params) => (
        <Box>
          <IconButton onClick={() => handleOpen(params.row)} size="small">
            <EditIcon />
          </IconButton>
          <IconButton onClick={() => handleDelete(params.row.id)} size="small" color="error">
            <DeleteIcon />
          </IconButton>
        </Box>
      ),
    },
  ];

  return (
    <Box>
      <Box sx={{ mb: 4, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <Typography variant="h5">Products</Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => handleOpen()}
        >
          Add Product
        </Button>
      </Box>

      <Box sx={{ height: 600, width: '100%' }}>
        <DataGrid
          rows={products}
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

      <Snackbar
        open={snackbar.open}
        autoHideDuration={6000}
        onClose={handleCloseSnackbar}
        anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
      >
        <Alert onClose={handleCloseSnackbar} severity={snackbar.severity}>
          {snackbar.message}
        </Alert>
      </Snackbar>

      <Dialog open={open} onClose={handleClose}>
        <DialogTitle>{editProduct ? 'Edit Product' : 'Add New Product'}</DialogTitle>
        <form onSubmit={handleSubmit}>
          <DialogContent>
            <TextField
              fullWidth
              label="Name"
              margin="normal"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              required
            />
            <TextField
              fullWidth
              label="Description"
              margin="normal"
              multiline
              rows={4}
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              required
            />
            <TextField
              fullWidth
              label="Price"
              margin="normal"
              type="number"
              value={formData.price}
              onChange={(e) => setFormData({ ...formData, price: e.target.value })}
              required
            />
            <TextField
              fullWidth
              label="Stock"
              margin="normal"
              type="number"
              value={formData.stock}
              onChange={(e) => setFormData({ ...formData, stock: e.target.value })}
              required
            />
            <TextField
              fullWidth
              type="file"
              margin="normal"
              onChange={(e) => setFormData({ ...formData, image: e.target.files[0] })}
            />
          </DialogContent>
          <DialogActions>
            <Button onClick={handleClose}>Cancel</Button>
            <Button type="submit" variant="contained">
              {editProduct ? 'Update' : 'Create'}
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </Box>
  );
}
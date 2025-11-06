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
  StarBorder as StarBorderIcon,
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
    images: [],
    existingImages: [],
  });

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const response = await fetch('http://localhost:8000/api/products/', {
        headers: {
          'Authorization': `Token ${localStorage.getItem('token')}`,
        },
        // Add cache busting to ensure we get fresh data
        cache: 'no-store'
      });
      if (response.ok) {
        const data = await response.json();
        // Ensure the data is properly formatted
        setProducts(data.map(product => ({
          ...product,
          primary_image: product.primary_image ? product.primary_image : null,
          images: product.images || []
        })));
      } else {
        showNotification('Failed to fetch products', 'error');
      }
    } catch (error) {
      console.error('Error fetching products:', error);
      showNotification('Error loading products', 'error');
    }
  };

  const handleOpen = async (product = null) => {
    if (product) {
      try {
        // Get the full product data to ensure we have all image information
        const response = await fetch(`http://localhost:8000/api/products/${product.id}/`, {
          headers: {
            'Authorization': `Token ${localStorage.getItem('token')}`,
          },
        });
        
        if (!response.ok) {
          throw new Error('Failed to fetch product details');
        }

        const fullProduct = await response.json();
        console.log('Fetched product details:', fullProduct); // Debug log

        setEditProduct(fullProduct);
        setFormData({
          name: fullProduct.name,
          description: fullProduct.description,
          price: fullProduct.price.toString(),
          stock: fullProduct.stock.toString(),
          images: [],
          existingImages: fullProduct.images || [],
        });
      } catch (error) {
        console.error('Error fetching product details:', error);
        showNotification('Error loading product details', 'error');
      }
    } else {
      setEditProduct(null);
      setFormData({
        name: '',
        description: '',
        price: '',
        stock: '',
        images: [],
        existingImages: [],
      });
    }
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setEditProduct(null);
    setFormData({
      name: '',
      description: '',
      price: '',
      stock: '',
      images: [],
      existingImages: [],
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const formDataToSend = new FormData();
    Object.keys(formData).forEach(key => {
      if (key === 'images') {
        formData[key].forEach(file => {
          formDataToSend.append('images', file);
        });
      } else if (key !== 'existingImages' && formData[key] !== null) {
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
        const result = await response.json();
        // Update products list with the new data
        if (editProduct) {
          setProducts(products.map(p => p.id === editProduct.id ? result : p));
        } else {
          setProducts([result, ...products]);
        }
        handleClose();
        // Show success notification
        showNotification(editProduct ? 'Product updated successfully' : 'Product created successfully');
      } else {
        const errorData = await response.json();
        showNotification(errorData.detail || 'Failed to save product', 'error');
      }
    } catch (error) {
      console.error('Error saving product:', error);
      showNotification('Error saving product', 'error');
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
      field: 'primary_image',
      headerName: 'Image',
      width: 100,
      renderCell: (params) => {
        const imageUrl = params.row.primary_image 
          ? (params.row.primary_image.startsWith('http') 
             ? params.row.primary_image 
             : `http://localhost:8000${params.row.primary_image}`)
          : '/placeholder.png';
        return (
          <Box
            component="img"
            sx={{
              height: 50,
              width: 50,
              objectFit: 'cover',
              borderRadius: 1,
            }}
            src={imageUrl}
            alt={params.row.name}
          />
        );
      },
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
      minWidth: 200,
      maxWidth: 400,
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
    <Box sx={{ width: '100%', maxWidth: '100%', overflowX: 'hidden' }}>
      <Box sx={{ mb: 4, display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 2 }}>
        <Typography variant="h5" sx={{ fontWeight: 600, color: '#212121' }}>
          Products
        </Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => handleOpen()}
          sx={{
            backgroundColor: '#0A83BC',
            '&:hover': {
              backgroundColor: '#075A85',
            },
          }}
        >
          Add Product
        </Button>
      </Box>

      <Box sx={{ height: 600, width: '100%', maxWidth: '100%', overflowX: 'auto' }}>
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
          sx={{
            width: '100%',
            '& .MuiDataGrid-root': {
              border: 'none',
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

      <Dialog 
        open={open} 
        onClose={handleClose}
        maxWidth="sm"
        fullWidth
        PaperProps={{
          sx: {
            maxWidth: '600px',
            width: '100%',
          },
        }}
      >
        <DialogTitle>{editProduct ? 'Edit Product' : 'Add New Product'}</DialogTitle>
        <form onSubmit={handleSubmit}>
          <DialogContent sx={{ overflowX: 'hidden' }}>
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
            <Box sx={{ mt: 2, mb: 2 }}>
              <input
                accept="image/*"
                style={{ display: 'none' }}
                id="raised-button-file"
                multiple
                type="file"
                onChange={(e) => {
                  const files = Array.from(e.target.files);
                  setFormData({ ...formData, images: [...formData.images, ...files] });
                }}
              />
              <label htmlFor="raised-button-file">
                <Button variant="outlined" component="span">
                  Upload Images
                </Button>
              </label>
            </Box>
            
            {/* Image Previews */}
            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, mt: 2, maxWidth: '100%', overflowX: 'hidden' }}>
              {/* Existing Images */}
              {formData.existingImages.map((img, index) => (
                <Box
                  key={`existing-${index}`}
                  sx={{
                    position: 'relative',
                    width: 100,
                    height: 100,
                  }}
                >
                  <Box
                    component="img"
                    sx={{
                      width: '100%',
                      height: '100%',
                      objectFit: 'cover',
                      borderRadius: 1,
                    }}
                    src={`http://localhost:8000${img.image_url}`}
                    alt={`Existing ${index}`}
                  />
                  <IconButton
                    size="small"
                    sx={{
                      position: 'absolute',
                      top: -8,
                      right: -8,
                      bgcolor: 'background.paper',
                      '&:hover': { bgcolor: 'error.light' },
                    }}
                    onClick={async () => {
                      try {
                        const response = await fetch(
                          `http://localhost:8000/api/products/${editProduct.id}/delete_image/`,
                          {
                            method: 'POST',
                            headers: {
                              'Authorization': `Token ${localStorage.getItem('token')}`,
                              'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({ image_id: img.id }),
                          }
                        );
                        if (response.ok) {
                          setFormData({
                            ...formData,
                            existingImages: formData.existingImages.filter((_, i) => i !== index),
                          });
                        }
                      } catch (error) {
                        console.error('Error deleting image:', error);
                      }
                    }}
                  >
                    <DeleteIcon fontSize="small" />
                  </IconButton>
                  {!img.is_primary && (
                    <IconButton
                      size="small"
                      sx={{
                        position: 'absolute',
                        top: -8,
                        left: -8,
                        bgcolor: 'background.paper',
                        '&:hover': { bgcolor: 'primary.light' },
                      }}
                      onClick={async () => {
                        try {
                          const response = await fetch(
                            `http://localhost:8000/api/products/${editProduct.id}/set_primary_image/`,
                            {
                              method: 'POST',
                              headers: {
                                'Authorization': `Token ${localStorage.getItem('token')}`,
                                'Content-Type': 'application/json',
                              },
                              body: JSON.stringify({ image_id: img.id }),
                            }
                          );
                          if (response.ok) {
                            // Refresh the product data
                            fetchProducts();
                          }
                        } catch (error) {
                          console.error('Error setting primary image:', error);
                        }
                      }}
                    >
                      <StarBorderIcon fontSize="small" />
                    </IconButton>
                  )}
                </Box>
              ))}

              {/* New Images */}
              {formData.images.map((file, index) => (
                <Box
                  key={`new-${index}`}
                  sx={{
                    position: 'relative',
                    width: 100,
                    height: 100,
                  }}
                >
                  <Box
                    component="img"
                    sx={{
                      width: '100%',
                      height: '100%',
                      objectFit: 'cover',
                      borderRadius: 1,
                    }}
                    src={URL.createObjectURL(file)}
                    alt={`New ${index}`}
                  />
                  <IconButton
                    size="small"
                    sx={{
                      position: 'absolute',
                      top: -8,
                      right: -8,
                      bgcolor: 'background.paper',
                      '&:hover': { bgcolor: 'error.light' },
                    }}
                    onClick={() => {
                      setFormData({
                        ...formData,
                        images: formData.images.filter((_, i) => i !== index),
                      });
                    }}
                  >
                    <DeleteIcon fontSize="small" />
                  </IconButton>
                </Box>
              ))}
            </Box>
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
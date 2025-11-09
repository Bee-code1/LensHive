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
  FormControlLabel,
  Switch,
  Grid,
  Autocomplete,
  Chip,
} from '@mui/material';
import { useAuth } from '../context/AuthContext';
import { DataGrid, GridToolbar } from '@mui/x-data-grid';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  StarBorder as StarBorderIcon,
} from '@mui/icons-material';

// Predefined options for dropdowns
const FRAME_COLORS = [
  'Black', 'Brown', 'Tortoise', 'Gray', 'Silver', 'Gold', 'Rose Gold',
  'Blue', 'Red', 'Green', 'Purple', 'Pink', 'White', 'Navy', 'Beige',
  'Obsidian', 'Matte Black', 'Gunmetal', 'Crystal', 'Transparent'
];

const SIZES = [
  'Small', 'Medium', 'Large', 'Extra Large',
  '48mm', '50mm', '52mm', '54mm', '56mm', '58mm',
  'Narrow', 'Wide', 'Standard'
];

const LENS_OPTIONS = [
  'Frame Only',
  'Customize Lenses',
  'Prescription Lenses',
  'Blue Light Blocking',
  'Photochromic',
  'Polarized',
  'Gradient',
  'Mirror',
  'Anti-Reflective Coating'
];

const CATEGORIES = [
  'Men', 'Women', 'Kids', 'Unisex',
  'Sunglasses', 'Reading Glasses', 'Computer Glasses',
  'Sports', 'Fashion', 'Prescription', 'Safety'
];

export default function Products() {
  const { user } = useAuth();
  const [products, setProducts] = useState([]);
  const [open, setOpen] = useState(false);
  const [editProduct, setEditProduct] = useState(null);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    price: '',
    currency: 'PKR',
    stock: '',
    category: '',
    brand: '',
    frame_colors: [],
    sizes: [],
    lens_options: [],
    is_bestseller: false,
    is_new: false,
    is_available: true,
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
        
        // Handle frame colors - use array if available, otherwise split string
        let frameColorsArray = [];
        if (fullProduct.colors && Array.isArray(fullProduct.colors) && fullProduct.colors.length > 0) {
          frameColorsArray = fullProduct.colors;
        } else if (fullProduct.frame_colors) {
          frameColorsArray = fullProduct.frame_colors.split(',').map(c => c.trim()).filter(c => c);
        }
        
        // Handle sizes - use array if available, otherwise split string
        let sizesArray = [];
        if (fullProduct.sizes && Array.isArray(fullProduct.sizes) && fullProduct.sizes.length > 0) {
          sizesArray = fullProduct.sizes;
        } else if (typeof fullProduct.sizes === 'string' && fullProduct.sizes) {
          sizesArray = fullProduct.sizes.split(',').map(s => s.trim()).filter(s => s);
        }
        
        // Handle lens options - use array if available, otherwise split string
        let lensOptionsArray = [];
        if (fullProduct.lens_options && Array.isArray(fullProduct.lens_options) && fullProduct.lens_options.length > 0) {
          lensOptionsArray = fullProduct.lens_options;
        } else if (typeof fullProduct.lens_options === 'string' && fullProduct.lens_options) {
          lensOptionsArray = fullProduct.lens_options.split(',').map(o => o.trim()).filter(o => o);
        }
        
        setFormData({
          name: fullProduct.name || '',
          description: fullProduct.description || '',
          price: fullProduct.price?.toString() || '',
          currency: fullProduct.currency || 'PKR',
          stock: fullProduct.stock?.toString() || '',
          category: fullProduct.category || '',
          brand: fullProduct.brand || '',
          frame_colors: frameColorsArray,
          sizes: sizesArray,
          lens_options: lensOptionsArray,
          is_bestseller: fullProduct.is_bestseller || false,
          is_new: fullProduct.is_new || false,
          is_available: fullProduct.is_available !== undefined ? fullProduct.is_available : true,
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
        currency: 'PKR',
        stock: '',
        category: '',
        brand: '',
        frame_colors: [],
        sizes: [],
        lens_options: [],
        is_bestseller: false,
        is_new: false,
        is_available: true,
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
      currency: 'PKR',
      stock: '',
      category: '',
      brand: '',
      frame_colors: [],
      sizes: [],
      lens_options: [],
      is_bestseller: false,
      is_new: false,
      is_available: true,
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
      } else if (key === 'existingImages') {
        // Skip existingImages, it's only for display
      } else if (key === 'is_bestseller' || key === 'is_new' || key === 'is_available') {
        // Handle boolean fields
        formDataToSend.append(key, formData[key] ? 'true' : 'false');
      } else if (key === 'frame_colors' || key === 'sizes' || key === 'lens_options') {
        // Convert arrays to comma-separated strings
        if (Array.isArray(formData[key]) && formData[key].length > 0) {
          formDataToSend.append(key, formData[key].join(','));
        }
      } else if (formData[key] !== null && formData[key] !== '' && formData[key] !== undefined) {
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
        maxWidth="md"
        fullWidth
        PaperProps={{
          sx: {
            maxWidth: '700px',
            width: '100%',
            maxHeight: '90vh',
          },
        }}
      >
        <DialogTitle>{editProduct ? 'Edit Product' : 'Add New Product'}</DialogTitle>
        <form onSubmit={handleSubmit}>
          <DialogContent sx={{ overflowX: 'hidden', overflowY: 'auto', maxHeight: '70vh' }}>
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
            <Grid container spacing={2}>
              <Grid item xs={8}>
                <TextField
                  fullWidth
                  label="Price"
                  margin="normal"
                  type="number"
                  value={formData.price}
                  onChange={(e) => setFormData({ ...formData, price: e.target.value })}
                  required
                />
              </Grid>
              <Grid item xs={4}>
                <FormControl fullWidth margin="normal">
                  <InputLabel>Currency</InputLabel>
                  <Select
                    value={formData.currency}
                    label="Currency"
                    onChange={(e) => setFormData({ ...formData, currency: e.target.value })}
                  >
                    <MenuItem value="PKR">PKR</MenuItem>
                    <MenuItem value="USD">USD</MenuItem>
                    <MenuItem value="EUR">EUR</MenuItem>
                  </Select>
                </FormControl>
              </Grid>
            </Grid>
            <TextField
              fullWidth
              label="Stock"
              margin="normal"
              type="number"
              value={formData.stock}
              onChange={(e) => setFormData({ ...formData, stock: e.target.value })}
              required
            />
            <FormControl fullWidth margin="normal">
              <InputLabel>Category</InputLabel>
              <Select
                value={formData.category}
                label="Category"
                onChange={(e) => setFormData({ ...formData, category: e.target.value })}
              >
                {CATEGORIES.map(cat => (
                  <MenuItem key={cat} value={cat}>{cat}</MenuItem>
                ))}
              </Select>
            </FormControl>
            <TextField
              fullWidth
              label="Brand"
              margin="normal"
              value={formData.brand}
              onChange={(e) => setFormData({ ...formData, brand: e.target.value })}
              placeholder="e.g., Ray-Ban, Oakley"
            />
            <Autocomplete
              multiple
              options={FRAME_COLORS}
              value={formData.frame_colors}
              onChange={(event, newValue) => {
                setFormData({ ...formData, frame_colors: newValue });
              }}
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Frame Colors"
                  margin="normal"
                  helperText="Select one or more frame colors"
                />
              )}
              renderTags={(value, getTagProps) =>
                value.map((option, index) => (
                  <Chip
                    variant="outlined"
                    label={option}
                    {...getTagProps({ index })}
                    key={option}
                  />
                ))
              }
            />
            <Autocomplete
              multiple
              options={SIZES}
              value={formData.sizes}
              onChange={(event, newValue) => {
                setFormData({ ...formData, sizes: newValue });
              }}
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Sizes"
                  margin="normal"
                  helperText="Select one or more sizes"
                />
              )}
              renderTags={(value, getTagProps) =>
                value.map((option, index) => (
                  <Chip
                    variant="outlined"
                    label={option}
                    {...getTagProps({ index })}
                    key={option}
                  />
                ))
              }
            />
            <Autocomplete
              multiple
              options={LENS_OPTIONS}
              value={formData.lens_options}
              onChange={(event, newValue) => {
                setFormData({ ...formData, lens_options: newValue });
              }}
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Lens Options"
                  margin="normal"
                  helperText="Select one or more lens options"
                />
              )}
              renderTags={(value, getTagProps) =>
                value.map((option, index) => (
                  <Chip
                    variant="outlined"
                    label={option}
                    {...getTagProps({ index })}
                    key={option}
                  />
                ))
              }
            />
            <Box sx={{ mt: 2, mb: 1 }}>
              <FormControlLabel
                control={
                  <Switch
                    checked={formData.is_bestseller}
                    onChange={(e) => setFormData({ ...formData, is_bestseller: e.target.checked })}
                  />
                }
                label="Bestseller"
              />
              <FormControlLabel
                control={
                  <Switch
                    checked={formData.is_new}
                    onChange={(e) => setFormData({ ...formData, is_new: e.target.checked })}
                  />
                }
                label="New Product"
              />
              <FormControlLabel
                control={
                  <Switch
                    checked={formData.is_available}
                    onChange={(e) => setFormData({ ...formData, is_available: e.target.checked })}
                  />
                }
                label="Available"
              />
            </Box>
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
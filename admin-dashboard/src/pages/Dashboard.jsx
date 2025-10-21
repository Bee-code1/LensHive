import { useState, useEffect } from 'react';
import {
  Grid,
  Card,
  CardContent,
  Typography,
  Box,
  Paper,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
} from '@mui/material';
import {
  Inventory as InventoryIcon,
  ShoppingCart as OrderIcon,
  Person as UserIcon,
  TrendingUp as TrendingUpIcon,
} from '@mui/icons-material';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from 'recharts';

export default function Dashboard() {
  const [stats, setStats] = useState({
    totalProducts: 0,
    totalOrders: 0,
    totalUsers: 0,
    totalRevenue: 0,
  });

  const [recentProducts, setRecentProducts] = useState([]);
  const [recentOrders, setRecentOrders] = useState([]);

  // Sample data for charts
  const salesData = [
    { name: 'Jan', sales: 4000 },
    { name: 'Feb', sales: 3000 },
    { name: 'Mar', sales: 5000 },
    { name: 'Apr', sales: 2780 },
    { name: 'May', sales: 1890 },
    { name: 'Jun', sales: 2390 },
  ];

  const categoryData = [
    { name: 'Contact Lenses', value: 400 },
    { name: 'Eyeglasses', value: 300 },
    { name: 'Sunglasses', value: 300 },
    { name: 'Accessories', value: 200 },
  ];

  const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042'];

  useEffect(() => {
    fetchStats();
    fetchRecentData();
  }, []);

  const fetchStats = async () => {
    try {
      const productsResponse = await fetch('http://localhost:8000/api/products/');
      const products = await productsResponse.json();
      
      // Update with real and mock data
      setStats({
        totalProducts: products.length,
        totalOrders: 25,
        totalUsers: 50,
        totalRevenue: 15000,
      });
    } catch (error) {
      console.error('Error fetching stats:', error);
    }
  };

  const fetchRecentData = async () => {
    try {
      const response = await fetch('http://localhost:8000/api/products/');
      const products = await response.json();
      setRecentProducts(products.slice(0, 5));
      
      // Mock recent orders data
      setRecentOrders([
        { id: 1, customer: 'John Doe', total: 150, status: 'Delivered' },
        { id: 2, customer: 'Jane Smith', total: 245, status: 'Processing' },
        { id: 3, customer: 'Mike Johnson', total: 320, status: 'Pending' },
      ]);
    } catch (error) {
      console.error('Error fetching recent data:', error);
    }
  };

  const StatCard = ({ title, value, icon: Icon, subtitle }) => (
    <Card>
      <CardContent>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
          <Icon sx={{ fontSize: 40, color: 'primary.main', mr: 2 }} />
          <Box>
            <Typography variant="h6" component="div">
              {title}
            </Typography>
            {subtitle && (
              <Typography variant="body2" color="text.secondary">
                {subtitle}
              </Typography>
            )}
          </Box>
        </Box>
        <Typography variant="h4" component="div">
          {value}
        </Typography>
      </CardContent>
    </Card>
  );

  return (
    <Box>
      <Box sx={{ mb: 4, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <Typography variant="h5">
          Dashboard Overview
        </Typography>
        <Button variant="contained" startIcon={<TrendingUpIcon />}>
          Generate Report
        </Button>
      </Box>

      <Grid container spacing={3}>
        <Grid item xs={12} md={3}>
          <StatCard
            title="Total Products"
            value={stats.totalProducts}
            icon={InventoryIcon}
          />
        </Grid>
        <Grid item xs={12} md={3}>
          <StatCard
            title="Total Orders"
            value={stats.totalOrders}
            icon={OrderIcon}
          />
        </Grid>
        <Grid item xs={12} md={3}>
          <StatCard
            title="Total Users"
            value={stats.totalUsers}
            icon={UserIcon}
          />
        </Grid>
        <Grid item xs={12} md={3}>
          <StatCard
            title="Revenue"
            value={`$${stats.totalRevenue.toLocaleString()}`}
            icon={TrendingUpIcon}
            subtitle="Last 30 days"
          />
        </Grid>

        {/* Sales Chart */}
        <Grid item xs={12} md={8}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Sales Overview
              </Typography>
              <Box sx={{ height: 300 }}>
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={salesData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip />
                    <Line type="monotone" dataKey="sales" stroke="#8884d8" />
                  </LineChart>
                </ResponsiveContainer>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Category Distribution */}
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Product Categories
              </Typography>
              <Box sx={{ height: 300 }}>
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={categoryData}
                      cx="50%"
                      cy="50%"
                      outerRadius={80}
                      fill="#8884d8"
                      dataKey="value"
                      label
                    >
                      {categoryData.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                      ))}
                    </Pie>
                    <Tooltip />
                  </PieChart>
                </ResponsiveContainer>
              </Box>
            </CardContent>
          </Card>
        </Grid>

        {/* Recent Products */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Recent Products
              </Typography>
              <TableContainer component={Paper}>
                <Table size="small">
                  <TableHead>
                    <TableRow>
                      <TableCell>Name</TableCell>
                      <TableCell>Price</TableCell>
                      <TableCell>Stock</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {recentProducts.map((product) => (
                      <TableRow key={product.id}>
                        <TableCell>{product.name}</TableCell>
                        <TableCell>${product.price}</TableCell>
                        <TableCell>{product.stock}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Recent Orders */}
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Recent Orders
              </Typography>
              <TableContainer component={Paper}>
                <Table size="small">
                  <TableHead>
                    <TableRow>
                      <TableCell>Order ID</TableCell>
                      <TableCell>Customer</TableCell>
                      <TableCell>Total</TableCell>
                      <TableCell>Status</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {recentOrders.map((order) => (
                      <TableRow key={order.id}>
                        <TableCell>#{order.id}</TableCell>
                        <TableCell>{order.customer}</TableCell>
                        <TableCell>${order.total}</TableCell>
                        <TableCell>{order.status}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
}
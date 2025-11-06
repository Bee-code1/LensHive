import { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  TextField,
  Button,
  Typography,
  Alert,
  InputAdornment,
  IconButton,
  CircularProgress,
} from '@mui/material';
import {
  Visibility,
  VisibilityOff,
  Email as EmailIcon,
  Lock as LockIcon,
} from '@mui/icons-material';
import { useAuth } from '../context/AuthContext';
import { useLocation, useNavigate } from 'react-router-dom';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  const { login } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const handleLogin = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    const result = await login(email, password);
    
    if (!result.success) {
      setError(result.error);
      setLoading(false);
    } else {
      // Navigate to the page they tried to visit or home
      const from = location.state?.from?.pathname || '/';
      navigate(from);
    }
  };

  return (
    <Box
      sx={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#FFFFFF',
        padding: 3,
      }}
    >
      <Box sx={{ width: '100%', maxWidth: 400 }}>
        {/* Logo and Title Section */}
        <Box sx={{ textAlign: 'center', mb: 4 }}>
          <Box
            component="img"
            src="/lenshive_logo.png"
            alt="LensHive Logo"
            sx={{
              width: 135,
              height: 90,
              objectFit: 'contain',
              mb: 2,
            }}
          />
          <Typography
            variant="h5"
            component="h1"
            sx={{
              fontWeight: 800,
              color: '#0A83BC',
              fontSize: '21px',
            }}
          >
            LensHive
          </Typography>
        </Box>

        {/* Login Card */}
        <Card
          sx={{
            borderRadius: '16px',
            border: '1px solid #E0E0E0',
            boxShadow: '0 4px 10px rgba(0, 0, 0, 0.05)',
          }}
        >
          <CardContent sx={{ p: 3 }}>
            {error && (
              <Alert severity="error" sx={{ mb: 3, borderRadius: '8px' }}>
                {error}
              </Alert>
            )}

            <form onSubmit={handleLogin}>
              <TextField
                fullWidth
                placeholder="Email"
                variant="outlined"
                margin="normal"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                autoComplete="email"
                autoFocus
                InputProps={{
                  startAdornment: (
                    <InputAdornment position="start">
                      <EmailIcon sx={{ color: 'text.secondary', fontSize: 20 }} />
                    </InputAdornment>
                  ),
                }}
                sx={{
                  '& .MuiOutlinedInput-root': {
                    backgroundColor: '#F5F5F5',
                    borderRadius: '8px',
                    '& fieldset': {
                      border: 'none',
                    },
                    '&:hover': {
                      backgroundColor: '#EEEEEE',
                    },
                    '&.Mui-focused': {
                      backgroundColor: '#FFFFFF',
                      '& fieldset': {
                        border: '1px solid #0A83BC',
                      },
                    },
                  },
                  '& .MuiInputBase-input': {
                    padding: '16px',
                  },
                }}
              />
              <TextField
                fullWidth
                placeholder="Password"
                type={showPassword ? 'text' : 'password'}
                variant="outlined"
                margin="normal"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                autoComplete="current-password"
                InputProps={{
                  startAdornment: (
                    <InputAdornment position="start">
                      <LockIcon sx={{ color: 'text.secondary', fontSize: 20 }} />
                    </InputAdornment>
                  ),
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        onClick={() => setShowPassword(!showPassword)}
                        edge="end"
                        sx={{ color: 'text.secondary' }}
                      >
                        {showPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                }}
                sx={{
                  '& .MuiOutlinedInput-root': {
                    backgroundColor: '#F5F5F5',
                    borderRadius: '8px',
                    '& fieldset': {
                      border: 'none',
                    },
                    '&:hover': {
                      backgroundColor: '#EEEEEE',
                    },
                    '&.Mui-focused': {
                      backgroundColor: '#FFFFFF',
                      '& fieldset': {
                        border: '1px solid #0A83BC',
                      },
                    },
                  },
                  '& .MuiInputBase-input': {
                    padding: '16px',
                  },
                }}
              />
              <Button
                type="submit"
                fullWidth
                variant="contained"
                size="large"
                sx={{
                  mt: 3,
                  mb: 2,
                  py: 1.5,
                  backgroundColor: '#0A83BC',
                  borderRadius: '8px',
                  textTransform: 'none',
                  fontWeight: 600,
                  fontSize: '16px',
                  '&:hover': {
                    backgroundColor: '#075A85',
                  },
                  '&:disabled': {
                    backgroundColor: '#0A83BC',
                    opacity: 0.6,
                  },
                }}
                disabled={loading}
              >
                {loading ? (
                  <CircularProgress size={20} sx={{ color: '#FFFFFF' }} />
                ) : (
                  'Login'
                )}
              </Button>
            </form>
          </CardContent>
        </Card>
      </Box>
    </Box>
  );
}
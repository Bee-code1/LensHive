import { createContext, useContext, useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    // Check if user is logged in on component mount
    checkAuth();
  }, []);

  const checkAuth = async () => {
    try {
      const token = localStorage.getItem('token');
      if (token) {
        // Verify token with backend
        const response = await fetch('http://localhost:8000/api/auth/verify/', {
          headers: {
            'Authorization': `Token ${token}`,
            'Content-Type': 'application/json',
          }
        });
        
        if (response.ok) {
          const userData = await response.json();
          if (userData.role === 'admin') {
            setUser(userData);
          } else {
            // User is not an admin
            localStorage.removeItem('token');
            setUser(null);
          }
        } else {
          // If token is invalid, remove it
          localStorage.removeItem('token');
          setUser(null);
        }
      } else {
        setLoading(false);
      }
    } catch (error) {
      console.error('Auth check failed:', error);
      localStorage.removeItem('token');
      setUser(null);
    } finally {
      setLoading(false);
    }
  };

  const login = async (email, password) => {
    try {
      const response = await fetch('http://localhost:8000/api/auth/login/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      const data = await response.json();

      if (response.ok) {
        if (data.user.role === 'admin') {
          localStorage.setItem('token', data.token);
          setUser(data.user);
          navigate('/');
          return { success: true };
        } else {
          return { 
            success: false, 
            error: 'Access denied. Admin privileges required.'
          };
        }
      } else {
        return { 
          success: false, 
          error: data.message || 'Invalid credentials'
        };
      }
    } catch (error) {
      console.error('Login failed:', error);
      return { 
        success: false, 
        error: 'Login failed. Please try again.'
      };
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
    navigate('/login');
  };

  const value = {
    user,
    login,
    logout,
    loading
  };

  return (
    <AuthContext.Provider value={value}>
      {!loading && children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
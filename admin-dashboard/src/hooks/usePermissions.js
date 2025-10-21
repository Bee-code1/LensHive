import { useAuth } from '../context/AuthContext';

export const usePermissions = () => {
  const { user } = useAuth();
  const permissions = user?.permissions || {};

  return {
    canManageUsers: permissions.can_manage_users || false,
    canManageProducts: permissions.can_manage_products || false,
    canViewAnalytics: permissions.can_view_analytics || false,
    isAdmin: user?.role === 'admin',
    isStaff: user?.role === 'staff',
  };
};
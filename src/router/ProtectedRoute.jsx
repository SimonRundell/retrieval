import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

/**
 * Wraps teacher-only routes.
 * Redirects unauthenticated visitors to /teacher/login,
 * preserving the intended destination for post-login redirect.
 */
export default function ProtectedRoute({ children }) {
    const { isAuthenticated } = useAuth();
    const location = useLocation();

    if (!isAuthenticated) {
        return <Navigate to="/teacher/login" state={{ from: location }} replace />;
    }

    return children;
}

import { useState } from 'react';
import { useNavigate, useLocation, Link } from 'react-router-dom';
import CryptoJS from 'crypto-js';
import { useAuth }  from '../../contexts/AuthContext';
import { useToast } from '../../contexts/ToastContext';
import api    from '../../hooks/useApi';
import Button from '../../components/ui/Button';
import Input  from '../../components/ui/Input';

/**
 * TeacherLogin — JWT-authenticated login page for staff only.
 */
export default function TeacherLogin() {
    const navigate  = useNavigate();
    const location  = useLocation();
    const { login } = useAuth();
    const toast     = useToast();
    const from      = location.state?.from?.pathname || '/teacher';

    const [email,    setEmail]    = useState('');
    const [password, setPassword] = useState('');
    const [loading,  setLoading]  = useState(false);
    const [error,    setError]    = useState('');

    async function handleSubmit(e) {
        e.preventDefault();
        setError('');
        if (!email || !password) return setError('Please enter your email and password.');
        setLoading(true);
        try {
            const hash = CryptoJS.MD5(password).toString();
            const res  = await api.post('/getLogin.php', { email, passwordHash: hash });
            const { token, teacher } = res.data;
            login(token, teacher);
            toast.success(`Welcome back, ${teacher.name}!`);
            navigate(from, { replace: true });
        } catch (err) {
            const msg = err.response?.data?.message;
            setError(msg || 'Login failed. Check your credentials and try again.');
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="login-page">
            <div className="login-card">
                <div className="login-header">
                    <img src="/exeter-logo.png" alt="Exeter College" />
                    <div>
                        <h1 className="login-title">Teacher Sign In</h1>
                        <p className="login-subtitle">Retrieval Quiz Online — Staff Portal</p>
                    </div>
                </div>

                <form onSubmit={handleSubmit} noValidate>
                    <Input
                        label="Email address"
                        type="email"
                        value={email}
                        onChange={e => setEmail(e.target.value)}
                        autoComplete="username"
                        autoFocus
                    />
                    <Input
                        label="Password"
                        type="password"
                        value={password}
                        onChange={e => setPassword(e.target.value)}
                        autoComplete="current-password"
                    />
                    {error && <p className="form-error" role="alert" style={{ marginBottom: 16 }}>{error}</p>}
                    <Button type="submit" fullWidth size="lg" disabled={loading}>
                        {loading ? 'Signing in…' : 'Sign in'}
                    </Button>
                </form>

                <p style={{ textAlign: 'center', marginTop: 24, fontSize: 'var(--text-sm)', color: 'var(--gray-400)' }}>
                    <Link to="/">← Back to student entry</Link>
                </p>
            </div>
        </div>
    );
}

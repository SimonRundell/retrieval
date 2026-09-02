import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import CryptoJS from 'crypto-js';
import { useAuth }  from '../../contexts/AuthContext';
import { useToast } from '../../contexts/ToastContext';
import api    from '../../hooks/useApi';
import Button from '../../components/ui/Button';
import Input  from '../../components/ui/Input';

/**
 * TeacherRegister — self-service registration page for new teacher accounts.
 */
export default function TeacherRegister() {
    const navigate  = useNavigate();
    const { login } = useAuth();
    const toast     = useToast();

    const [studentName,     setStudentName]     = useState('');
    const [schoolName,      setSchoolName]      = useState('');
    const [email,           setEmail]           = useState('');
    const [password,        setPassword]        = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [loading,         setLoading]         = useState(false);
    const [error,           setError]           = useState('');

    async function handleSubmit(e) {
        e.preventDefault();
        setError('');
        if (!studentName.trim()) return setError('Please enter your name.');
        if (!schoolName.trim())  return setError('Please enter your school name.');
        if (!email.trim())       return setError('Please enter your email address.');
        if (!password)           return setError('Please choose a password.');
        if (password !== confirmPassword) return setError('Passwords do not match.');

        setLoading(true);
        try {
            const hash = CryptoJS.MD5(password).toString();
            const res  = await api.post('/registerTeacher.php', {
                email: email.trim(),
                passwordHash: hash,
                studentName: studentName.trim(),
                schoolName: schoolName.trim(),
            });
            const { token, teacher } = res.data;
            login(token, teacher);
            toast.success(`Welcome, ${teacher.name}!`);
            navigate('/teacher', { replace: true });
        } catch (err) {
            const msg = err.response?.data?.message;
            setError(msg || 'Registration failed. Please try again.');
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
                        <h1 className="login-title">Teacher Registration</h1>
                        <p className="login-subtitle">Retrieval Quiz Online — Staff Portal</p>
                    </div>
                </div>

                <form onSubmit={handleSubmit} noValidate>
                    <Input
                        label="Your name"
                        value={studentName}
                        onChange={e => setStudentName(e.target.value)}
                        autoComplete="name"
                        autoFocus
                    />
                    <Input
                        label="School name"
                        value={schoolName}
                        onChange={e => setSchoolName(e.target.value)}
                        autoComplete="organization"
                    />
                    <Input
                        label="Email address"
                        type="email"
                        value={email}
                        onChange={e => setEmail(e.target.value)}
                        autoComplete="username"
                    />
                    <Input
                        label="Password"
                        type="password"
                        value={password}
                        onChange={e => setPassword(e.target.value)}
                        autoComplete="new-password"
                    />
                    <Input
                        label="Confirm password"
                        type="password"
                        value={confirmPassword}
                        onChange={e => setConfirmPassword(e.target.value)}
                        autoComplete="new-password"
                    />
                    {error && <p className="form-error mb-4" role="alert">{error}</p>}
                    <Button type="submit" fullWidth size="lg" disabled={loading}>
                        {loading ? 'Creating account…' : 'Create account'}
                    </Button>
                </form>

                <p className="login-back-link">
                    Already have an account? <Link to="/teacher/login">Sign in here</Link>
                </p>
            </div>
        </div>
    );
}

import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import Button from '../../components/ui/Button';
import Input  from '../../components/ui/Input';
import api    from '../../hooks/useApi';

/**
 * StudentEntry — the public landing page.
 * Students enter their name and a quiz code; no account required.
 */
export default function StudentEntry() {
    const navigate = useNavigate();
    const [name,   setName]   = useState('');
    const [code,   setCode]   = useState('');
    const [error,  setError]  = useState('');
    const [loading, setLoading] = useState(false);

    async function handleStart(e) {
        e.preventDefault();
        setError('');
        if (!name.trim())         return setError('Please enter your name.');
        if (code.trim().length < 1) return setError('Please enter a quiz code.');

        setLoading(true);
        try {
            const res = await api.post('/getQuiz.php', { quizCode: code.trim().toLowerCase() });
            const quiz = res.data;
            if (!quiz || quiz.status_code === 404) {
                setError('Quiz code not found. Check the code and try again.');
                return;
            }
            navigate(`/quiz/${code.trim().toLowerCase()}`, {
                state: { studentName: name.trim(), quizName: quiz.quizName, quizType: quiz.quizType },
            });
        } catch {
            setError('Quiz code not found. Check the code and try again.');
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="entry-page">
            <div className="entry-card">
                <div className="entry-logo">
                    <img src="/exeter-logo.png" alt="Exeter College" />
                </div>
                <h1 className="entry-title">Retrieval Quiz</h1>
                <p className="entry-subtitle">Enter your details below to start your quiz</p>

                <form onSubmit={handleStart} noValidate>
                    <Input
                        label="Your name"
                        placeholder="e.g. Alex Smith"
                        value={name}
                        onChange={e => setName(e.target.value)}
                        autoComplete="given-name"
                        autoFocus
                    />
                    <Input
                        label="Quiz code"
                        placeholder="e.g. g4o21x"
                        value={code}
                        onChange={e => setCode(e.target.value.toLowerCase())}
                        autoComplete="off"
                        hint="Your teacher will give you this code"
                    />
                    {error && <p className="form-error" role="alert">{error}</p>}
                    <Button type="submit" fullWidth size="lg" disabled={loading} style={{ marginTop: '8px' }}>
                        {loading ? 'Finding quiz…' : 'Start quiz →'}
                    </Button>
                </form>

                <p className="entry-teacher-link">
                    Are you a teacher? <Link to="/teacher/login">Sign in here</Link>
                </p>
            </div>
        </div>
    );
}

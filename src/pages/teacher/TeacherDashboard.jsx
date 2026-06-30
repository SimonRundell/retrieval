import { useEffect, useState } from 'react';
import { useNavigate, Link }   from 'react-router-dom';
import { useAuth }  from '../../contexts/AuthContext';
import { useToast } from '../../contexts/ToastContext';
import api       from '../../hooks/useApi';
import Button    from '../../components/ui/Button';
import Spinner   from '../../components/ui/Spinner';
import Accordion from '../../components/ui/Accordion';
import Modal     from '../../components/ui/Modal';
import Input     from '../../components/ui/Input';

function questionCount(quiz) {
    try {
        const d = typeof quiz.quizData === 'string' ? JSON.parse(quiz.quizData) : quiz.quizData;
        if (quiz.quizType === 1 || quiz.quizType === '1') {
            return (d.QuestionSets ?? []).reduce((n, s) => n + (s.QuestionAnswerPairs?.length ?? 0), 0);
        }
        return Array.isArray(d) ? d.length : 0;
    } catch { return '?'; }
}

/**
 * TeacherDashboard — lists all quizzes with create, edit, copy and watch actions.
 */
export default function TeacherDashboard() {
    const { teacher, logout } = useAuth();
    const toast    = useToast();
    const navigate = useNavigate();

    const [quizzes, setQuizzes] = useState([]);
    const [loading, setLoading] = useState(true);

    const [watchModal,   setWatchModal]   = useState(null);
    const [duration,     setDuration]     = useState('10');
    const [clearScores,  setClearScores]  = useState(true);
    const [launching,    setLaunching]    = useState(false);

    useEffect(() => {
        api.post('/getAllQuizzes.php', {})
            .then(res => setQuizzes(Array.isArray(res.data) ? res.data : []))
            .catch(() => toast.error('Failed to load quizzes.'))
            .finally(() => setLoading(false));
    }, []);

    function copyCode(code) {
        navigator.clipboard.writeText(code)
            .then(() => toast.success(`Code "${code}" copied!`))
            .catch(() => toast.error('Could not access clipboard — please copy the code manually.'));
    }

    async function launchSession() {
        setLaunching(true);
        const mins = parseInt(duration, 10) || 10;
        try {
            await api.post('/createSession.php', {
                quizCode:     watchModal.quizCode,
                durationSecs: mins * 60,
                clearScores,
            });
            toast.success('Session started!');
            navigate(`/teacher/quiz/watch/${watchModal.quizCode}`);
        } catch {
            toast.error('Failed to start session.');
        } finally {
            setLaunching(false);
            setWatchModal(null);
        }
    }

    const typeLabel = t => (t === 2 || t === '2') ? 'Multiple Choice' : 'Match Definitions';
    const typeBadge = t => (t === 2 || t === '2') ? 'badge--yellow' : 'badge--blue';

    const items = quizzes.map(q => ({
        key: q.quizCode,
        label: (
            <div style={{ display: 'flex', alignItems: 'center', gap: 12, minWidth: 0, flex: 1 }}>
                <span className={`badge ${typeBadge(q.quizType)}`}>{typeLabel(q.quizType)}</span>
                <span style={{ fontWeight: 600, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{q.quizName}</span>
                <span className="quiz-meta-item" style={{ marginLeft: 'auto', flexShrink: 0 }}>{questionCount(q)} questions</span>
            </div>
        ),
        children: (
            <div>
                <div className="quiz-meta">
                    <span className="quiz-meta-item">Subject: <strong>{q.quizSubject || '—'}</strong></span>
                    <span className="quiz-meta-item">Topic: <strong>{q.quizTopic || '—'}</strong></span>
                    <span className="quiz-meta-item">Year: <strong>{q.quizYear || '—'}</strong></span>
                    <span className="quiz-meta-item">Unit: <strong>{q.quizUnit || '—'}</strong></span>
                </div>
                {q.quizDescription && <p style={{ marginTop: 8, fontSize: 'var(--text-sm)', color: 'var(--gray-500)' }}>{q.quizDescription}</p>}
                <div className="quiz-actions">
                    <span
                        className="code-chip"
                        onClick={() => copyCode(q.quizCode)}
                        title="Click to copy"
                    >
                        📋 {q.quizCode}
                    </span>
                    <Button
                        size="sm"
                        variant="secondary"
                        onClick={() => navigate(`/teacher/quiz/edit/${q.quizCode}`)}
                    >
                        ✏️ Edit
                    </Button>
                    <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => { setWatchModal(q); setDuration('10'); setClearScores(true); }}
                    >
                        📺 Launch live session
                    </Button>
                </div>
            </div>
        ),
    }));

    return (
        <div className="app-shell">
            <header className="app-header">
                <div className="app-header-logo">
                    <img src="/exeter-logo.png" alt="Exeter College" />
                    <span className="app-header-title">Retrieval Quiz Online</span>
                </div>
                <nav className="app-header-nav">
                    <span className="app-header-user">Signed in as <strong>{teacher?.name}</strong></span>
                    <Button variant="ghost" size="sm" onClick={() => { logout(); navigate('/teacher/login'); }}>Sign out</Button>
                </nav>
            </header>

            <main className="app-main">
                <div className="dashboard-header">
                    <div>
                        <h1 className="dashboard-title">My Quizzes</h1>
                        <p className="dashboard-subtitle">{quizzes.length} quiz{quizzes.length !== 1 ? 'zes' : ''} available</p>
                    </div>
                    <Link to="/teacher/quiz/new">
                        <Button variant="primary">+ Create quiz</Button>
                    </Link>
                </div>

                {loading && <Spinner overlay label="Loading quizzes…" />}

                {!loading && quizzes.length === 0 && (
                    <div className="card">
                        <div className="card-body text-center" style={{ padding: '48px 24px' }}>
                            <p style={{ fontSize: 'var(--text-lg)', color: 'var(--gray-400)', marginBottom: 16 }}>No quizzes yet.</p>
                            <Link to="/teacher/quiz/new">
                                <Button variant="primary">Create your first quiz</Button>
                            </Link>
                        </div>
                    </div>
                )}

                {!loading && quizzes.length > 0 && <Accordion items={items} multi />}
            </main>

            <Modal
                open={!!watchModal}
                onClose={() => setWatchModal(null)}
                title={`Launch: ${watchModal?.quizName}`}
                footer={
                    <>
                        <Button variant="ghost" onClick={() => setWatchModal(null)}>Cancel</Button>
                        <Button variant="primary" onClick={launchSession} disabled={launching}>
                            {launching ? 'Starting…' : 'Launch session'}
                        </Button>
                    </>
                }
            >
                <p style={{ marginBottom: 16, color: 'var(--gray-600)', fontSize: 'var(--text-sm)' }}>
                    Students will see a countdown timer. The session starts immediately when you click Launch.
                </p>
                <Input
                    label="Time limit (minutes)"
                    type="number"
                    min="1"
                    max="60"
                    value={duration}
                    onChange={e => setDuration(e.target.value)}
                />
                <div className="form-group" style={{ marginTop: 4 }}>
                    <label className="form-label">Leaderboard</label>
                    <div className="launch-option-group">
                        <label className={`launch-option${clearScores ? ' launch-option--selected' : ''}`}>
                            <input
                                type="radio"
                                name="clearScores"
                                checked={clearScores}
                                onChange={() => setClearScores(true)}
                            />
                            <div>
                                <span className="launch-option-title">Start fresh</span>
                                <span className="launch-option-desc">Remove all previous scores for this quiz before the session begins.</span>
                            </div>
                        </label>
                        <label className={`launch-option${!clearScores ? ' launch-option--selected' : ''}`}>
                            <input
                                type="radio"
                                name="clearScores"
                                checked={!clearScores}
                                onChange={() => setClearScores(false)}
                            />
                            <div>
                                <span className="launch-option-title">Keep existing scores</span>
                                <span className="launch-option-desc">New results are added alongside the current leaderboard — useful for multiple groups.</span>
                            </div>
                        </label>
                    </div>
                </div>
            </Modal>
        </div>
    );
}

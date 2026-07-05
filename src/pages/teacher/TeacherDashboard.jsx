import { useEffect, useState } from 'react';
import { useNavigate, Link }   from 'react-router-dom';
import CryptoJS from 'crypto-js';
import { useAuth }  from '../../contexts/AuthContext';
import { useToast } from '../../contexts/ToastContext';
import api       from '../../hooks/useApi';
import useLookups from '../../hooks/useLookups';
import Button    from '../../components/ui/Button';
import Spinner   from '../../components/ui/Spinner';
import Accordion from '../../components/ui/Accordion';
import Modal     from '../../components/ui/Modal';
import Input     from '../../components/ui/Input';
import UserManagement from './UserManagement';
import ManageLookupsModal from './ManageLookupsModal';

const emptyFilters = { title: '', subject: '', topic: '', year: '', unit: '' };

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
    const [tab, setTab] = useState('quizzes');

    const [lookups, , reloadLookups] = useLookups();
    const [filters, setFilters] = useState(emptyFilters);
    const [manageListsOpen, setManageListsOpen] = useState(false);

    const [watchModal,   setWatchModal]   = useState(null);
    const [duration,     setDuration]     = useState('10');
    const [clearScores,  setClearScores]  = useState(true);
    const [launching,    setLaunching]    = useState(false);

    const [changePwOpen, setChangePwOpen] = useState(false);
    const [currentPw,    setCurrentPw]    = useState('');
    const [newPw,        setNewPw]        = useState('');
    const [confirmPw,    setConfirmPw]    = useState('');
    const [changingPw,   setChangingPw]   = useState(false);

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

    function openChangePassword() {
        setCurrentPw(''); setNewPw(''); setConfirmPw('');
        setChangePwOpen(true);
    }

    async function handleChangePassword() {
        if (!currentPw || !newPw) return toast.error('Please fill in both password fields.');
        if (newPw !== confirmPw)  return toast.error('New passwords do not match.');

        setChangingPw(true);
        try {
            await api.post('/changePassword.php', {
                currentPasswordHash: CryptoJS.MD5(currentPw).toString(),
                newPasswordHash:     CryptoJS.MD5(newPw).toString(),
            });
            toast.success('Password changed!');
            setChangePwOpen(false);
        } catch (err) {
            toast.error(err.response?.data?.message || 'Failed to change password.');
        } finally {
            setChangingPw(false);
        }
    }

    const typeLabel = t => (t === 2 || t === '2') ? 'Multiple Choice' : 'Match Definitions';
    const typeBadge = t => (t === 2 || t === '2') ? 'badge--yellow' : 'badge--blue';

    function updateFilter(key, val) { setFilters(prev => ({ ...prev, [key]: val })); }
    function clearFilters() { setFilters(emptyFilters); }
    const filtersActive = Object.values(filters).some(Boolean);

    const filteredQuizzes = quizzes.filter(q => (
        (!filters.title   || q.quizName.toLowerCase().includes(filters.title.toLowerCase())) &&
        (!filters.subject || q.quizSubject === filters.subject) &&
        (!filters.topic   || q.quizTopic   === filters.topic) &&
        (!filters.year    || q.quizYear    === filters.year) &&
        (!filters.unit    || q.quizUnit    === filters.unit)
    ));

    const items = filteredQuizzes.map(q => ({
        key: q.quizCode,
        label: (
            <div className="quiz-accordion-label">
                <span className={`badge ${typeBadge(q.quizType)}`}>{typeLabel(q.quizType)}</span>
                <span className="quiz-accordion-name">{q.quizName}</span>
                <span className="quiz-meta-item quiz-meta-item--auto">{questionCount(q)} questions</span>
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
                {q.quizDescription && <p className="quiz-description">{q.quizDescription}</p>}
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
                    <Button variant="ghost" size="sm" onClick={openChangePassword}>Change password</Button>
                    <Button variant="ghost" size="sm" onClick={() => { logout(); navigate('/teacher/login'); }}>Sign out</Button>
                </nav>
            </header>

            <main className="app-main">
                {teacher?.admin && (
                    <div className="dashboard-tabs">
                        <button
                            className={`dashboard-tab${tab === 'quizzes' ? ' dashboard-tab--active' : ''}`}
                            onClick={() => setTab('quizzes')}
                        >
                            My Quizzes
                        </button>
                        <button
                            className={`dashboard-tab${tab === 'users' ? ' dashboard-tab--active' : ''}`}
                            onClick={() => setTab('users')}
                        >
                            Manage Users
                        </button>
                    </div>
                )}

                {tab === 'users' && teacher?.admin ? (
                    <UserManagement />
                ) : (
                    <>
                        <div className="dashboard-header">
                            <div>
                                <h1 className="dashboard-title">My Quizzes</h1>
                                <p className="dashboard-subtitle">
                                    {filtersActive
                                        ? `${filteredQuizzes.length} of ${quizzes.length} quiz${quizzes.length !== 1 ? 'zes' : ''}`
                                        : `${quizzes.length} quiz${quizzes.length !== 1 ? 'zes' : ''} available`}
                                </p>
                            </div>
                            <div className="flex gap-2">
                                <Button variant="secondary" onClick={() => setManageListsOpen(true)}>Manage lists</Button>
                                <Link to="/teacher/quiz/new">
                                    <Button variant="primary">+ Create quiz</Button>
                                </Link>
                            </div>
                        </div>

                        {!loading && quizzes.length > 0 && (
                            <div className="filter-bar">
                                <input
                                    className="form-input filter-bar-title"
                                    placeholder="Search by title…"
                                    value={filters.title}
                                    onChange={e => updateFilter('title', e.target.value)}
                                />
                                <select className="form-select" value={filters.subject} onChange={e => updateFilter('subject', e.target.value)}>
                                    <option value="">All subjects</option>
                                    {lookups.subject.map(o => <option key={o.id} value={o.value}>{o.value}</option>)}
                                </select>
                                <select className="form-select" value={filters.topic} onChange={e => updateFilter('topic', e.target.value)}>
                                    <option value="">All topics</option>
                                    {lookups.topic.map(o => <option key={o.id} value={o.value}>{o.value}</option>)}
                                </select>
                                <select className="form-select" value={filters.year} onChange={e => updateFilter('year', e.target.value)}>
                                    <option value="">All years</option>
                                    {lookups.year.map(o => <option key={o.id} value={o.value}>{o.value}</option>)}
                                </select>
                                <select className="form-select" value={filters.unit} onChange={e => updateFilter('unit', e.target.value)}>
                                    <option value="">All units</option>
                                    {lookups.unit.map(o => <option key={o.id} value={o.value}>{o.value}</option>)}
                                </select>
                                {filtersActive && <Button variant="ghost" size="sm" onClick={clearFilters}>Clear filters</Button>}
                            </div>
                        )}

                        {loading && <Spinner overlay label="Loading quizzes…" />}

                        {!loading && quizzes.length === 0 && (
                            <div className="card">
                                <div className="card-body text-center p-12-6">
                                    <p className="empty-state-text mb-4">No quizzes yet.</p>
                                    <Link to="/teacher/quiz/new">
                                        <Button variant="primary">Create your first quiz</Button>
                                    </Link>
                                </div>
                            </div>
                        )}

                        {!loading && quizzes.length > 0 && filteredQuizzes.length === 0 && (
                            <div className="card">
                                <div className="card-body text-center p-12-6">
                                    <p className="empty-state-text mb-4">No quizzes match your filters.</p>
                                    <Button variant="secondary" onClick={clearFilters}>Clear filters</Button>
                                </div>
                            </div>
                        )}

                        {!loading && filteredQuizzes.length > 0 && <Accordion items={items} multi />}
                    </>
                )}
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
                <p className="modal-hint-text mb-4">
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
                <div className="form-group mt-1">
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

            <Modal
                open={changePwOpen}
                onClose={() => setChangePwOpen(false)}
                title="Change password"
                footer={
                    <>
                        <Button variant="ghost" onClick={() => setChangePwOpen(false)}>Cancel</Button>
                        <Button variant="primary" onClick={handleChangePassword} disabled={changingPw}>
                            {changingPw ? 'Saving…' : 'Change password'}
                        </Button>
                    </>
                }
            >
                <Input
                    label="Current password *"
                    type="password"
                    value={currentPw}
                    onChange={e => setCurrentPw(e.target.value)}
                    autoComplete="current-password"
                />
                <Input
                    label="New password *"
                    type="password"
                    value={newPw}
                    onChange={e => setNewPw(e.target.value)}
                    autoComplete="new-password"
                />
                <Input
                    label="Confirm new password *"
                    type="password"
                    value={confirmPw}
                    onChange={e => setConfirmPw(e.target.value)}
                    autoComplete="new-password"
                />
            </Modal>

            <ManageLookupsModal
                open={manageListsOpen}
                onClose={() => setManageListsOpen(false)}
                lookups={lookups}
                onReload={reloadLookups}
            />
        </div>
    );
}

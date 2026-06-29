import { useEffect, useRef, useState } from 'react';
import { useParams, Link }  from 'react-router-dom';
import api        from '../../hooks/useApi';
import QuizTimer  from '../../components/quiz/QuizTimer';
import Spinner    from '../../components/ui/Spinner';

const POLL_INTERVAL_MS = 3000;
const RANK_ICONS = ['🥇', '🥈', '🥉'];

/**
 * WatchQuiz — projector-friendly live leaderboard for a timed quiz session.
 * Polls watchStatus.php every 3 seconds and displays a sorted leaderboard.
 * Teacher navigates here after creating a session via TeacherDashboard.
 */
export default function WatchQuiz() {
    const { quizCode }  = useParams();
    const [session,  setSession]  = useState(null);
    const [students, setStudents] = useState([]);
    const [quizName, setQuizName] = useState('');
    const [loading,  setLoading]  = useState(true);
    const pollRef = useRef(null);

    useEffect(() => {
        Promise.all([
            api.post('/getSession.php', { quizCode }),
            api.post('/getQuiz.php',    { quizCode }),
        ]).then(([sessRes, quizRes]) => {
            if (sessRes.data?.startTime)   setSession(sessRes.data);
            if (quizRes.data?.quizName)    setQuizName(quizRes.data.quizName);
        }).catch(() => {}).finally(() => setLoading(false));

        pollStatus();
        pollRef.current = setInterval(pollStatus, POLL_INTERVAL_MS);
        return () => clearInterval(pollRef.current);
    }, [quizCode]);

    function pollStatus() {
        api.post('/watchStatus.php', { quizCode })
            .then(res => {
                if (Array.isArray(res.data)) setStudents(res.data);
            })
            .catch(() => {});
    }

    const rowClass = (i) => {
        if (i === 0) return 'watch-row watch-row--first';
        if (i === 1) return 'watch-row watch-row--second';
        if (i === 2) return 'watch-row watch-row--third';
        return 'watch-row';
    };

    return (
        <div className="watch-page">
            <div className="watch-header">
                <div>
                    <div className="watch-title">📺 {quizName || quizCode}</div>
                    <div style={{ color: 'rgba(255,255,255,0.5)', fontSize: 'var(--text-sm)', marginTop: 4 }}>
                        Code: <strong style={{ color: 'rgba(255,255,255,0.8)' }}>{quizCode}</strong>
                        &nbsp;· {students.length} student{students.length !== 1 ? 's' : ''} active
                    </div>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 24 }}>
                    {session && (
                        <QuizTimer
                            startTime={session.startTime}
                            durationSecs={session.durationSecs}
                            large
                        />
                    )}
                    <Link to="/teacher" style={{ color: 'rgba(255,255,255,0.5)', fontSize: 'var(--text-sm)' }}>
                        ← Dashboard
                    </Link>
                </div>
            </div>

            <div className="watch-body">
                {loading && <Spinner overlay label="Loading session…" />}

                {!loading && students.length === 0 && (
                    <div className="watch-empty">
                        Waiting for students to join…<br />
                        <span style={{ fontSize: 'var(--text-sm)', marginTop: 8, display: 'block' }}>
                            Tell them to visit the site and enter code <strong>{quizCode}</strong>
                        </span>
                    </div>
                )}

                {students.length > 0 && (
                    <div className="watch-leaderboard">
                        {students.map((s, i) => (
                            <div key={s.studentName} className={rowClass(i)}>
                                <div className="watch-rank">
                                    {i < 3 ? RANK_ICONS[i] : `#${i + 1}`}
                                </div>
                                <div className="watch-name">{s.studentName}</div>
                                <div className="watch-score">{s.score} pts</div>
                                <div className={`watch-status${s.quizComplete == 1 ? ' watch-status--done' : ''}`}>
                                    {s.quizComplete == 1 ? '✓ Done' : 'In progress…'}
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
}

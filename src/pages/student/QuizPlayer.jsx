import { useEffect, useState } from 'react';
import { useParams, useLocation, useNavigate } from 'react-router-dom';
import api          from '../../hooks/useApi';
import Spinner      from '../../components/ui/Spinner';
import MatchQuizBoard from '../../components/quiz/MatchQuizBoard';
import MCQuizBoard    from '../../components/quiz/MCQuizBoard';
import QuizTimer      from '../../components/quiz/QuizTimer';

/**
 * QuizPlayer — fetches the quiz and session, then renders the correct board.
 * Receives studentName and quizType via React Router location state.
 */
export default function QuizPlayer() {
    const { quizCode } = useParams();
    const location     = useLocation();
    const navigate     = useNavigate();

    const studentName = location.state?.studentName || 'Anonymous';

    const [quiz,    setQuiz]    = useState(null);
    const [session, setSession] = useState(null);
    const [error,   setError]   = useState('');
    const [timedOut, setTimedOut] = useState(false);

    useEffect(() => {
        Promise.all([
            api.post('/getQuiz.php',    { quizCode }),
            api.post('/getSession.php', { quizCode }).catch(() => ({ data: null })),
        ]).then(([quizRes, sessRes]) => {
            if (!quizRes.data || quizRes.data.status_code === 404) {
                setError('Quiz not found.');
                return;
            }
            setQuiz(quizRes.data);
            if (sessRes.data && sessRes.data.startTime) setSession(sessRes.data);
        }).catch(() => setError('Failed to load quiz. Please try again.'));
    }, [quizCode]);

    if (error)  return <div className="flex-center" style={{ minHeight: '100vh' }}><p>{error}</p></div>;
    if (!quiz)  return <Spinner overlay label="Loading quiz…" />;

    const timerProps = session
        ? {
            startTime:     session.startTime,
            durationSecs:  Number(session.durationSecs),
            remainingSecs: Number(session.remainingSecs),
            onExpire:      () => setTimedOut(true),
          }
        : null;

    const sharedProps = {
        quiz,
        studentName,
        quizCode,
        timedOut,
        timerProps,
        onExit: () => navigate('/'),
    };

    return quiz.quizType === 2
        ? <MCQuizBoard    {...sharedProps} />
        : <MatchQuizBoard {...sharedProps} />;
}

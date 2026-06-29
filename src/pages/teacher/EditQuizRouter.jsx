import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import api       from '../../hooks/useApi';
import Spinner   from '../../components/ui/Spinner';
import EditMatchQuiz from './EditMatchQuiz';
import EditMCQuiz    from './EditMCQuiz';

/**
 * EditQuizRouter — fetches a quiz by code and routes to the correct editor.
 */
export default function EditQuizRouter() {
    const { quizCode } = useParams();
    const [quiz,    setQuiz]    = useState(null);
    const [error,   setError]   = useState('');

    useEffect(() => {
        api.post('/getQuiz.php', { quizCode })
            .then(res => {
                if (!res.data || res.data.status_code === 404) setError('Quiz not found.');
                else setQuiz(res.data);
            })
            .catch(() => setError('Failed to load quiz.'));
    }, [quizCode]);

    if (error)  return <p style={{ padding: 32 }}>{error}</p>;
    if (!quiz)  return <Spinner overlay label="Loading quiz…" />;

    return (quiz.quizType === 2 || quiz.quizType === '2')
        ? <EditMCQuiz quiz={quiz} />
        : <EditMatchQuiz quiz={quiz} />;
}

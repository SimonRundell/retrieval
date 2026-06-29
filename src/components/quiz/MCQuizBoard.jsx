import { useEffect, useState } from 'react';
import api        from '../../hooks/useApi';
import QuizTimer  from './QuizTimer';
import ScoreModal from './ScoreModal';

const COLOURS = ['--ans-1', '--ans-2', '--ans-3', '--ans-4'];
const LETTERS  = ['A', 'B', 'C', 'D'];

/**
 * MCQuizBoard — multiple-choice quiz player for quizType 2.
 */
export default function MCQuizBoard({ quiz, studentName, quizCode, timedOut, timerProps, onExit }) {
    const questions = typeof quiz.quizData === 'string'
        ? JSON.parse(quiz.quizData)
        : quiz.quizData;

    const [index,    setIndex]    = useState(0);
    const [score,    setScore]    = useState(0);
    const [chosen,   setChosen]   = useState(null);
    const [showScore, setShowScore] = useState(false);

    useEffect(() => {
        if (timedOut && !showScore) submitQuiz(score);
    }, [timedOut]);

    function submitQuiz(finalScore) {
        api.post('/updateStatus.php', {
            studentName, quizCode, score: finalScore, quizComplete: 1,
        }).catch(() => {});
        setShowScore(true);
    }

    function handleAnswer(answerIdx) {
        if (chosen !== null) return;
        setChosen(answerIdx);
        const q = questions[index];
        const correct = answerIdx === q.correctAnswer;
        const newScore = correct ? score + 1 : score;
        if (correct) setScore(newScore);

        setTimeout(() => {
            setChosen(null);
            if (index + 1 < questions.length) {
                setIndex(index + 1);
            } else {
                submitQuiz(newScore);
            }
        }, 900);
    }

    if (!questions?.length) return <p style={{ padding: 24 }}>No questions found in this quiz.</p>;

    const q   = questions[index];
    const pct = Math.round(((index) / questions.length) * 100);

    return (
        <div className="quiz-page">
            <div className="quiz-header">
                <div className="quiz-header-info">
                    <h2>{quiz.quizName}</h2>
                    <p>Playing as: <strong>{studentName}</strong></p>
                </div>
                <div className="flex gap-4" style={{ alignItems: 'center' }}>
                    {timerProps && <QuizTimer {...timerProps} />}
                    <div className="quiz-score-display">
                        Score <span className="quiz-score-value">{score}</span>
                    </div>
                    <div>
                        <div className="quiz-progress-bar">
                            <div className="quiz-progress-fill" style={{ width: `${pct}%` }} />
                        </div>
                        <p className="match-set-progress">{index + 1} of {questions.length}</p>
                    </div>
                </div>
            </div>

            <div className="mc-quiz-body">
                <div className="mc-question-container">
                    <div className="mc-question-card-player">
                        <div className="mc-question-number">Question {index + 1} of {questions.length}</div>
                        <div className="mc-question-text">{q.question}</div>
                    </div>
                    <div className="mc-answers-grid-player">
                        {q.answers.map((ans, i) => {
                            let cls = `mc-answer-btn mc-answer-btn--${i + 1}`;
                            if (chosen !== null) {
                                if (i === q.correctAnswer) cls += ' mc-answer-btn--correct';
                                else if (i === chosen)     cls += ' mc-answer-btn--incorrect';
                            }
                            return (
                                <button key={i} className={cls} onClick={() => handleAnswer(i)} disabled={chosen !== null}>
                                    <span className="mc-answer-letter">{LETTERS[i]}</span>
                                    {ans}
                                </button>
                            );
                        })}
                    </div>
                </div>
            </div>

            <ScoreModal
                open={showScore}
                score={score}
                total={questions.length}
                quizName={quiz.quizName}
                onPlayAgain={() => { setShowScore(false); setIndex(0); setScore(0); setChosen(null); }}
                onExit={onExit}
            />
        </div>
    );
}

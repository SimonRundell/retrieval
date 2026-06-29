import { useEffect, useRef, useState } from 'react';
import {
    DndContext,
    DragOverlay,
    MouseSensor,
    TouchSensor,
    useSensor,
    useSensors,
    useDroppable,
    useDraggable,
} from '@dnd-kit/core';
import api        from '../../hooks/useApi';
import Button     from '../ui/Button';
import QuizTimer  from './QuizTimer';
import ScoreModal from './ScoreModal';

/* ----------------------------------------------------------
   Sub-components
   ---------------------------------------------------------- */

function DraggableAnswer({ answer, isPlaced }) {
    const { attributes, listeners, setNodeRef, isDragging } = useDraggable({ id: answer.id });
    let cls = 'match-answer-chip';
    if (isPlaced)  cls += ' match-answer-chip--placed';
    if (isDragging) cls += ' match-answer-chip--dragging';
    return (
        <div ref={setNodeRef} className={cls} {...listeners} {...attributes}>
            ⠿ {answer.text}
        </div>
    );
}

function DroppableQuestion({ question, status }) {
    const { setNodeRef, isOver } = useDroppable({ id: question.id });
    let cls = 'match-question-slot';
    if (status === 'correct')   cls += ' match-question-slot--correct';
    else if (status === 'incorrect') cls += ' match-question-slot--incorrect';
    else if (isOver) cls += ' match-question-slot--over';

    return (
        <div ref={setNodeRef} className={cls}>
            <span className="match-question-text">{question.text}</span>
            {status === 'correct'   && <span className="match-question-status">✓</span>}
            {status === 'incorrect' && <span className="match-question-status">✕</span>}
        </div>
    );
}

/* ----------------------------------------------------------
   Helpers
   ---------------------------------------------------------- */

function shuffle(arr) {
    const a = [...arr];
    for (let i = a.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
}

function buildSetData(quizData, setIndex) {
    const raw  = typeof quizData === 'string' ? JSON.parse(quizData) : quizData;
    const sets = raw.QuestionSets ?? [];
    if (setIndex >= sets.length) return null;
    const set     = sets[setIndex];
    const pairs   = set.QuestionAnswerPairs ?? [];
    const questions = pairs.map((p, i) => ({ id: `q-${i}`, text: p.Question, answer: p.Answer }));
    const answers   = shuffle(pairs.map((p, i) => ({ id: `a-${i}`, text: p.Answer })));
    return { header: set.Header, questions, answers, totalSets: sets.length };
}

/* ----------------------------------------------------------
   Main component
   ---------------------------------------------------------- */

/**
 * MatchQuizBoard — drag-and-drop quiz for quizType 1 using @dnd-kit.
 */
export default function MatchQuizBoard({ quiz, studentName, quizCode, timedOut, timerProps, onExit }) {
    const quizData     = typeof quiz.quizData === 'string' ? JSON.parse(quiz.quizData) : quiz.quizData;
    const totalSets    = (quizData.QuestionSets ?? []).length;
    const totalQ       = (quizData.QuestionSets ?? []).reduce((n, s) => n + (s.QuestionAnswerPairs?.length ?? 0), 0);

    const [setIndex,    setSetIndex]    = useState(0);
    const [setData,     setSetData]     = useState(() => buildSetData(quiz.quizData, 0));
    const [statuses,    setStatuses]    = useState({});
    const [placedMap,   setPlacedMap]   = useState({});
    const [score,       setScore]       = useState(0);
    const [totalAnswered, setTotalAnswered] = useState(0);
    const [activeAnswer, setActiveAnswer]  = useState(null);
    const [showScore,   setShowScore]   = useState(false);
    const incorrectTimers = useRef({});

    const sensors = useSensors(
        useSensor(MouseSensor, { activationConstraint: { distance: 5 } }),
        useSensor(TouchSensor, { activationConstraint: { delay: 100, tolerance: 5 } }),
    );

    useEffect(() => {
        if (timedOut) setShowScore(true);
    }, [timedOut]);

    function loadSet(idx) {
        const data = buildSetData(quiz.quizData, idx);
        setSetIndex(idx);
        setSetData(data);
        setStatuses({});
        setPlacedMap({});
    }

    function onDragStart({ active }) {
        setActiveAnswer(setData.answers.find(a => a.id === active.id) ?? null);
    }

    function onDragEnd({ active, over }) {
        setActiveAnswer(null);
        if (!over) return;

        const answerId   = active.id;
        const questionId = over.id;
        if (!questionId.startsWith('q-')) return;

        if (statuses[questionId] === 'correct') return;
        if (placedMap[answerId]) return;

        const question = setData.questions.find(q => q.id === questionId);
        const answer   = setData.answers.find(a => a.id === answerId);
        if (!question || !answer) return;

        const isCorrect = answer.text.trim() === question.answer.trim();

        if (isCorrect) {
            setStatuses(prev  => ({ ...prev, [questionId]: 'correct' }));
            setPlacedMap(prev => ({ ...prev, [answerId]: true }));
            const newScore = score + 1;
            const newTotal = totalAnswered + 1;
            setScore(newScore);
            setTotalAnswered(newTotal);

            api.post('/updateStatus.php', {
                studentName, quizCode, score: newScore, quizComplete: 0,
            }).catch(() => {});

            const allCorrect = setData.questions.every(
                q => q.id === questionId || statuses[q.id] === 'correct'
            );
            if (allCorrect) {
                if (setIndex + 1 < totalSets) {
                    setTimeout(() => loadSet(setIndex + 1), 900);
                } else {
                    setTimeout(() => {
                        api.post('/updateStatus.php', {
                            studentName, quizCode, score: newScore, quizComplete: 1,
                        }).catch(() => {});
                        setShowScore(true);
                    }, 900);
                }
            }
        } else {
            setStatuses(prev => ({ ...prev, [questionId]: 'incorrect' }));
            clearTimeout(incorrectTimers.current[questionId]);
            incorrectTimers.current[questionId] = setTimeout(() => {
                setStatuses(prev => {
                    const next = { ...prev };
                    if (next[questionId] === 'incorrect') delete next[questionId];
                    return next;
                });
            }, 800);
        }
    }

    if (!setData) return null;

    const correctCount   = Object.values(statuses).filter(s => s === 'correct').length;
    const setProgressPct = (correctCount / setData.questions.length) * 100;
    const totalPct       = totalSets > 0 ? ((setIndex / totalSets) + (correctCount / setData.questions.length / totalSets)) * 100 : 0;

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
                        <div className="quiz-progress-bar" title={`Set ${setIndex + 1} of ${totalSets}`}>
                            <div className="quiz-progress-fill" style={{ width: `${Math.round(totalPct)}%` }} />
                        </div>
                        <p className="match-set-progress">Set {setIndex + 1} of {totalSets}</p>
                    </div>
                </div>
            </div>

            {setData.header && (
                <div style={{ textAlign: 'center', padding: '12px 24px', background: 'var(--primary-light)', borderBottom: '1px solid var(--primary-mid)', fontWeight: 600, color: 'var(--primary-dark)' }}>
                    {setData.header}
                </div>
            )}

            <DndContext sensors={sensors} onDragStart={onDragStart} onDragEnd={onDragEnd}>
                <div className="match-quiz-body">
                    <div>
                        <p className="match-col-label">Questions — drop answers here</p>
                        <div className="match-questions">
                            {setData.questions.map(q => (
                                <DroppableQuestion key={q.id} question={q} status={statuses[q.id]} />
                            ))}
                        </div>
                    </div>
                    <div>
                        <p className="match-col-label">Answers — drag to match</p>
                        <div className="match-answers">
                            {setData.answers.map(a => (
                                <DraggableAnswer key={a.id} answer={a} isPlaced={!!placedMap[a.id]} />
                            ))}
                        </div>
                    </div>
                </div>

                <DragOverlay>
                    {activeAnswer && (
                        <div className="match-drag-overlay">⠿ {activeAnswer.text}</div>
                    )}
                </DragOverlay>
            </DndContext>

            <ScoreModal
                open={showScore}
                score={score}
                total={totalQ}
                quizName={quiz.quizName}
                onPlayAgain={() => { setShowScore(false); setScore(0); setTotalAnswered(0); loadSet(0); }}
                onExit={onExit}
            />
        </div>
    );
}

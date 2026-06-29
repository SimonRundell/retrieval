import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useToast } from '../../contexts/ToastContext';
import api    from '../../hooks/useApi';
import Button from '../../components/ui/Button';
import Input  from '../../components/ui/Input';

const LETTERS = ['A', 'B', 'C', 'D'];

/**
 * EditMCQuiz — edit a multiple-choice quiz (quizType 2).
 * Receives the full quiz object from EditQuizRouter.
 */
export default function EditMCQuiz({ quiz }) {
    const toast    = useToast();
    const navigate = useNavigate();

    const raw = typeof quiz.quizData === 'string' ? JSON.parse(quiz.quizData) : quiz.quizData;

    const [meta, setMeta] = useState({
        quizName:        quiz.quizName        || '',
        quizSubject:     quiz.quizSubject     || '',
        quizDescription: quiz.quizDescription || '',
        quizTopic:       quiz.quizTopic       || '',
        quizYear:        quiz.quizYear        || '',
        quizUnit:        quiz.quizUnit        || '',
    });

    const [questions, setQuestions] = useState(
        Array.isArray(raw) ? raw : []
    );

    const [saving, setSaving] = useState(false);

    function updateMeta(key, val) { setMeta(prev => ({ ...prev, [key]: val })); }

    function updateQuestion(idx, field, val) {
        setQuestions(prev => prev.map((q, i) => i === idx ? { ...q, [field]: val } : q));
    }

    function updateAnswer(qIdx, aIdx, val) {
        setQuestions(prev => prev.map((q, i) => {
            if (i !== qIdx) return q;
            const answers = [...q.answers];
            answers[aIdx] = val;
            return { ...q, answers };
        }));
    }

    function addQuestion() {
        setQuestions(prev => [...prev, { question: '', answers: ['', '', '', ''], correctAnswer: 0 }]);
    }

    function removeQuestion(idx) {
        if (questions.length > 1) setQuestions(prev => prev.filter((_, i) => i !== idx));
    }

    async function handleSave() {
        if (!meta.quizName.trim()) return toast.error('Quiz name is required.');
        for (const q of questions) {
            if (!q.question.trim()) return toast.error('All questions must have text.');
            if (q.answers.some(a => !a.trim())) return toast.error('All answer options must be filled in.');
        }
        setSaving(true);
        try {
            await api.post('/updateQuiz.php', {
                quizType: 2, quizCode: quiz.quizCode,
                quizName: meta.quizName, quizSetBy: quiz.quizSetBy,
                quizSubject: meta.quizSubject, quizDescription: meta.quizDescription,
                quizTopic: meta.quizTopic, quizYear: meta.quizYear, quizUnit: meta.quizUnit,
                quizData: questions,
            });
            toast.success('Quiz updated!');
            navigate('/teacher');
        } catch {
            toast.error('Failed to update quiz. Please try again.');
        } finally {
            setSaving(false);
        }
    }

    return (
        <div className="app-shell">
            <header className="app-header">
                <div className="app-header-logo">
                    <img src="/exeter-logo.png" alt="Exeter College" />
                    <span className="app-header-title">Edit: {quiz.quizName}</span>
                </div>
                <nav className="app-header-nav">
                    <span className="code-chip">📋 {quiz.quizCode}</span>
                    <Link to="/teacher"><Button variant="ghost" size="sm">← Dashboard</Button></Link>
                    <Button variant="primary" onClick={handleSave} disabled={saving}>
                        {saving ? 'Saving…' : 'Save changes'}
                    </Button>
                </nav>
            </header>

            <main className="app-main">
                <div className="card editor-metadata">
                    <div className="card-header"><h3>Quiz details</h3></div>
                    <div className="card-body">
                        <div className="form-row">
                            <Input label="Quiz name *" value={meta.quizName} onChange={e => updateMeta('quizName', e.target.value)} />
                            <Input label="Subject"     value={meta.quizSubject} onChange={e => updateMeta('quizSubject', e.target.value)} />
                        </div>
                        <div className="form-row">
                            <Input label="Topic" value={meta.quizTopic} onChange={e => updateMeta('quizTopic', e.target.value)} />
                            <Input label="Year"  value={meta.quizYear}  onChange={e => updateMeta('quizYear', e.target.value)} />
                            <Input label="Unit"  value={meta.quizUnit}  onChange={e => updateMeta('quizUnit', e.target.value)} />
                        </div>
                        <div className="form-group">
                            <label className="form-label">Description</label>
                            <textarea className="form-textarea" value={meta.quizDescription} onChange={e => updateMeta('quizDescription', e.target.value)} />
                        </div>
                    </div>
                </div>

                <div className="editor-toolbar">
                    <h2 style={{ fontSize: 'var(--text-xl)', fontWeight: 700 }}>Questions</h2>
                    <Button variant="secondary" onClick={addQuestion}>+ Add question</Button>
                </div>

                <div className="editor-questions">
                    {questions.map((q, qIdx) => (
                        <div key={qIdx} className="mc-question-card-editor">
                            <div className="flex-between" style={{ marginBottom: 12 }}>
                                <span style={{ fontWeight: 600, color: 'var(--gray-500)', fontSize: 'var(--text-sm)' }}>Question {qIdx + 1}</span>
                                <Button variant="ghost" size="sm" iconOnly onClick={() => removeQuestion(qIdx)} disabled={questions.length === 1}>🗑</Button>
                            </div>
                            <div className="form-group" style={{ marginBottom: 12 }}>
                                <input className="form-input" placeholder="Enter the question…" value={q.question} onChange={e => updateQuestion(qIdx, 'question', e.target.value)} />
                            </div>
                            <div className="mc-answers-grid">
                                {q.answers.map((ans, aIdx) => (
                                    <div key={aIdx} className="mc-answer-row">
                                        <span className={`mc-answer-label mc-answer-label--${LETTERS[aIdx].toLowerCase()}`}>{LETTERS[aIdx]}</span>
                                        <input className="form-input" placeholder={`Answer ${LETTERS[aIdx]}…`} value={ans} onChange={e => updateAnswer(qIdx, aIdx, e.target.value)} />
                                    </div>
                                ))}
                            </div>
                            <div className="form-group" style={{ marginTop: 12 }}>
                                <label className="form-label">Correct answer</label>
                                <select className="form-select" value={q.correctAnswer} onChange={e => updateQuestion(qIdx, 'correctAnswer', Number(e.target.value))}>
                                    {LETTERS.map((l, i) => <option key={i} value={i}>Answer {l}</option>)}
                                </select>
                            </div>
                        </div>
                    ))}
                </div>
            </main>
        </div>
    );
}

import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth }  from '../../contexts/AuthContext';
import { useToast } from '../../contexts/ToastContext';
import api    from '../../hooks/useApi';
import Button from '../../components/ui/Button';
import Input  from '../../components/ui/Input';

function genCode() { return Math.random().toString(36).substring(2, 8); }

const LETTERS = ['A', 'B', 'C', 'D'];
const COLOURS  = ['--ans-1', '--ans-2', '--ans-3', '--ans-4'];

function emptyQuestion() {
    return { question: '', answers: ['', '', '', ''], correctAnswer: 0 };
}

/**
 * NewMCQuiz — create a multiple-choice quiz.
 */
export default function NewMCQuiz() {
    const { teacher } = useAuth();
    const toast       = useToast();
    const navigate    = useNavigate();

    const [meta, setMeta] = useState({
        quizName: '', quizSubject: '', quizDescription: '',
        quizTopic: '', quizYear: '', quizUnit: '',
    });

    const [questions, setQuestions] = useState([emptyQuestion()]);
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

    function addQuestion()       { setQuestions(prev => [...prev, emptyQuestion()]); }
    function removeQuestion(idx) { if (questions.length > 1) setQuestions(prev => prev.filter((_, i) => i !== idx)); }

    async function handleSave() {
        if (!meta.quizName.trim()) return toast.error('Quiz name is required.');
        for (const q of questions) {
            if (!q.question.trim()) return toast.error('All questions must have text.');
            if (q.answers.some(a => !a.trim())) return toast.error('All answer options must be filled in.');
        }
        setSaving(true);
        try {
            await api.post('/insertQuiz.php', {
                quizType: 2,
                quizCode: genCode(),
                quizName: meta.quizName,
                quizSetBy: teacher.id,
                quizSubject: meta.quizSubject,
                quizDescription: meta.quizDescription,
                quizTopic: meta.quizTopic,
                quizYear: meta.quizYear,
                quizUnit: meta.quizUnit,
                quizData: questions,
            });
            toast.success('Quiz created!');
            navigate('/teacher');
        } catch {
            toast.error('Failed to save quiz. Please try again.');
        } finally {
            setSaving(false);
        }
    }

    return (
        <div className="app-shell">
            <header className="app-header">
                <div className="app-header-logo">
                    <img src="/exeter-logo.png" alt="Exeter College" />
                    <span className="app-header-title">New Multiple Choice Quiz</span>
                </div>
                <nav className="app-header-nav">
                    <Link to="/teacher"><Button variant="ghost" size="sm">← Dashboard</Button></Link>
                    <Button variant="primary" onClick={handleSave} disabled={saving}>
                        {saving ? 'Saving…' : 'Save quiz'}
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
                            <textarea
                                className="form-textarea"
                                value={meta.quizDescription}
                                onChange={e => updateMeta('quizDescription', e.target.value)}
                                placeholder="Brief description shown to students when browsing…"
                            />
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
                                <span style={{ fontWeight: 600, color: 'var(--gray-500)', fontSize: 'var(--text-sm)' }}>
                                    Question {qIdx + 1}
                                </span>
                                <Button variant="ghost" size="sm" iconOnly onClick={() => removeQuestion(qIdx)} disabled={questions.length === 1} title="Delete">🗑</Button>
                            </div>
                            <div className="form-group" style={{ marginBottom: 12 }}>
                                <input
                                    className="form-input"
                                    placeholder="Enter the question…"
                                    value={q.question}
                                    onChange={e => updateQuestion(qIdx, 'question', e.target.value)}
                                />
                            </div>
                            <div className="mc-answers-grid">
                                {q.answers.map((ans, aIdx) => (
                                    <div key={aIdx} className="mc-answer-row">
                                        <span className={`mc-answer-label mc-answer-label--${LETTERS[aIdx].toLowerCase()}`}>{LETTERS[aIdx]}</span>
                                        <input
                                            className="form-input"
                                            placeholder={`Answer ${LETTERS[aIdx]}…`}
                                            value={ans}
                                            onChange={e => updateAnswer(qIdx, aIdx, e.target.value)}
                                        />
                                    </div>
                                ))}
                            </div>
                            <div className="form-group" style={{ marginTop: 12 }}>
                                <label className="form-label">Correct answer</label>
                                <select
                                    className="form-select"
                                    value={q.correctAnswer}
                                    onChange={e => updateQuestion(qIdx, 'correctAnswer', Number(e.target.value))}
                                >
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

import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useToast } from '../../contexts/ToastContext';
import api    from '../../hooks/useApi';
import Button from '../../components/ui/Button';
import Input  from '../../components/ui/Input';

const QUESTIONS_PER_SET = 4;

/**
 * EditMatchQuiz — edit a match-definitions quiz (quizType 1).
 * Receives the full quiz object from EditQuizRouter.
 */
export default function EditMatchQuiz({ quiz }) {
    const toast    = useToast();
    const navigate = useNavigate();

    const raw   = typeof quiz.quizData === 'string' ? JSON.parse(quiz.quizData) : quiz.quizData;
    const sets  = raw.QuestionSets ?? [];

    const flatPairs = sets.flatMap(s =>
        (s.QuestionAnswerPairs ?? []).map(p => ({ question: p.Question, answer: p.Answer }))
    );
    const flatHeaders = sets.map(s => s.Header ?? '');

    const [meta, setMeta] = useState({
        quizName:        quiz.quizName        || '',
        quizSubject:     quiz.quizSubject     || '',
        quizDescription: quiz.quizDescription || '',
        quizTopic:       quiz.quizTopic       || '',
        quizYear:        quiz.quizYear        || '',
        quizUnit:        quiz.quizUnit        || '',
    });

    const [pairs,      setPairs]      = useState(flatPairs);
    const [setHeaders, setSetHeaders] = useState(flatHeaders);
    const [saving,     setSaving]     = useState(false);

    function updateMeta(key, val) { setMeta(prev => ({ ...prev, [key]: val })); }
    function updatePair(idx, key, val) { setPairs(prev => prev.map((p, i) => i === idx ? { ...p, [key]: val } : p)); }
    function updateHeader(setIdx, val) { setSetHeaders(prev => prev.map((h, i) => i === setIdx ? val : h)); }

    function addPair() {
        setPairs(prev => {
            const next   = [...prev, { question: '', answer: '' }];
            const setIdx = Math.floor((next.length - 1) / QUESTIONS_PER_SET);
            setSetHeaders(h => { const n = [...h]; if (!n[setIdx]) n[setIdx] = `Set ${setIdx + 1}`; return n; });
            return next;
        });
    }

    function removePair(idx) { if (pairs.length > 1) setPairs(prev => prev.filter((_, i) => i !== idx)); }

    function movePair(idx, dir) {
        setPairs(prev => {
            const next = [...prev]; const target = idx + dir;
            if (target < 0 || target >= next.length) return prev;
            [next[idx], next[target]] = [next[target], next[idx]];
            return next;
        });
    }

    async function handleSave() {
        if (!meta.quizName.trim()) return toast.error('Quiz name is required.');
        if (pairs.some(p => !p.question.trim() || !p.answer.trim())) return toast.error('All questions and answers must be filled in.');

        const QuestionSets = [];
        for (let i = 0; i < pairs.length; i += QUESTIONS_PER_SET) {
            const slice  = pairs.slice(i, i + QUESTIONS_PER_SET);
            const setIdx = Math.floor(i / QUESTIONS_PER_SET);
            QuestionSets.push({
                Header: setHeaders[setIdx] || `Set ${setIdx + 1}`,
                QuestionAnswerPairs: slice.map(p => ({ Question: p.question, Answer: p.answer })),
            });
        }

        setSaving(true);
        try {
            await api.post('/updateQuiz.php', {
                quizType: 1, quizCode: quiz.quizCode,
                quizName: meta.quizName, quizSetBy: quiz.quizSetBy,
                quizSubject: meta.quizSubject, quizDescription: meta.quizDescription,
                quizTopic: meta.quizTopic, quizYear: meta.quizYear, quizUnit: meta.quizUnit,
                quizData: { QuestionSets },
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

                <div className="card">
                    <div className="card-header">
                        <h3>Questions &amp; Answers</h3>
                        <span className="badge badge--gray">{pairs.length} pairs</span>
                    </div>
                    <div className="card-body">
                        <div className="editor-questions">
                            {pairs.map((pair, idx) => {
                                const isSetStart = idx % QUESTIONS_PER_SET === 0;
                                const setIdx     = Math.floor(idx / QUESTIONS_PER_SET);
                                return (
                                    <div key={idx}>
                                        {isSetStart && (
                                            <div className="question-set-header">
                                                <span className="question-set-label">Set {setIdx + 1} header:</span>
                                                <input className="form-input" value={setHeaders[setIdx] || ''} onChange={e => updateHeader(setIdx, e.target.value)} placeholder="e.g. Match key terms to definitions" />
                                            </div>
                                        )}
                                        <div className="question-row">
                                            <span className="question-row-num">{idx + 1}</span>
                                            <input className="form-input" placeholder="Question / term" value={pair.question} onChange={e => updatePair(idx, 'question', e.target.value)} />
                                            <input className="form-input" placeholder="Answer / definition" value={pair.answer} onChange={e => updatePair(idx, 'answer', e.target.value)} />
                                            <div className="flex gap-2">
                                                <Button variant="ghost" size="sm" iconOnly onClick={() => movePair(idx, -1)} disabled={idx === 0}>↑</Button>
                                                <Button variant="ghost" size="sm" iconOnly onClick={() => movePair(idx, 1)}  disabled={idx === pairs.length - 1}>↓</Button>
                                                <Button variant="ghost" size="sm" iconOnly onClick={() => removePair(idx)}>🗑</Button>
                                            </div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                        <div style={{ marginTop: 16 }}>
                            <Button variant="secondary" onClick={addPair}>+ Add question</Button>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}

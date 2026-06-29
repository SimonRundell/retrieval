import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth }  from '../../contexts/AuthContext';
import { useToast } from '../../contexts/ToastContext';
import api    from '../../hooks/useApi';
import Button from '../../components/ui/Button';
import Input  from '../../components/ui/Input';

const QUESTIONS_PER_SET = 4;

function genCode() {
    return Math.random().toString(36).substring(2, 8);
}

function buildSetHeaders(pairs) {
    const headers = [];
    for (let i = 0; i < pairs.length; i += QUESTIONS_PER_SET) {
        headers[Math.floor(i / QUESTIONS_PER_SET)] = `Set ${Math.floor(i / QUESTIONS_PER_SET) + 1}`;
    }
    return headers;
}

/**
 * NewMatchQuiz — create a drag-and-drop match definitions quiz.
 */
export default function NewMatchQuiz() {
    const { teacher } = useAuth();
    const toast       = useToast();
    const navigate    = useNavigate();

    const [meta, setMeta] = useState({
        quizName: '', quizSubject: '', quizDescription: '',
        quizTopic: '', quizYear: '', quizUnit: '',
    });

    const [pairs, setPairs] = useState([
        { question: '', answer: '' },
        { question: '', answer: '' },
        { question: '', answer: '' },
        { question: '', answer: '' },
    ]);

    const [setHeaders, setSetHeaders] = useState(['Set 1']);
    const [saving, setSaving] = useState(false);

    function updateMeta(key, val) {
        setMeta(prev => ({ ...prev, [key]: val }));
    }

    function updatePair(idx, key, val) {
        setPairs(prev => prev.map((p, i) => i === idx ? { ...p, [key]: val } : p));
    }

    function addPair() {
        setPairs(prev => {
            const next = [...prev, { question: '', answer: '' }];
            const setIdx = Math.floor((next.length - 1) / QUESTIONS_PER_SET);
            setSetHeaders(h => {
                const n = [...h];
                if (!n[setIdx]) n[setIdx] = `Set ${setIdx + 1}`;
                return n;
            });
            return next;
        });
    }

    function removePair(idx) {
        if (pairs.length <= 1) return;
        setPairs(prev => prev.filter((_, i) => i !== idx));
    }

    function movePair(idx, dir) {
        setPairs(prev => {
            const next = [...prev];
            const target = idx + dir;
            if (target < 0 || target >= next.length) return prev;
            [next[idx], next[target]] = [next[target], next[idx]];
            return next;
        });
    }

    function updateHeader(setIdx, val) {
        setSetHeaders(prev => prev.map((h, i) => i === setIdx ? val : h));
    }

    async function handleSave() {
        if (!meta.quizName.trim()) return toast.error('Quiz name is required.');
        const incomplete = pairs.some(p => !p.question.trim() || !p.answer.trim());
        if (incomplete) return toast.error('All questions and answers must be filled in.');

        const QuestionSets = [];
        for (let i = 0; i < pairs.length; i += QUESTIONS_PER_SET) {
            const slice = pairs.slice(i, i + QUESTIONS_PER_SET);
            const setIdx = Math.floor(i / QUESTIONS_PER_SET);
            QuestionSets.push({
                Header: setHeaders[setIdx] || `Set ${setIdx + 1}`,
                QuestionAnswerPairs: slice.map(p => ({ Question: p.question, Answer: p.answer })),
            });
        }

        setSaving(true);
        try {
            await api.post('/insertQuiz.php', {
                quizType: 1,
                quizCode: genCode(),
                quizName: meta.quizName,
                quizSetBy: teacher.id,
                quizSubject: meta.quizSubject,
                quizDescription: meta.quizDescription,
                quizTopic: meta.quizTopic,
                quizYear: meta.quizYear,
                quizUnit: meta.quizUnit,
                quizData: { QuestionSets },
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
                    <span className="app-header-title">New Match Definitions Quiz</span>
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
                            <Input label="Topic"  value={meta.quizTopic} onChange={e => updateMeta('quizTopic', e.target.value)} />
                            <Input label="Year"   value={meta.quizYear}  onChange={e => updateMeta('quizYear', e.target.value)} />
                            <Input label="Unit"   value={meta.quizUnit}  onChange={e => updateMeta('quizUnit', e.target.value)} />
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

                <div className="card">
                    <div className="card-header">
                        <h3>Questions &amp; Answers</h3>
                        <span className="badge badge--gray">{pairs.length} pairs · {Math.ceil(pairs.length / QUESTIONS_PER_SET)} set{Math.ceil(pairs.length / QUESTIONS_PER_SET) !== 1 ? 's' : ''}</span>
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
                                                <input
                                                    className="form-input"
                                                    value={setHeaders[setIdx] || ''}
                                                    onChange={e => updateHeader(setIdx, e.target.value)}
                                                    placeholder={`e.g. Match key terms to definitions`}
                                                />
                                            </div>
                                        )}
                                        <div className="question-row">
                                            <span className="question-row-num">{idx + 1}</span>
                                            <input
                                                className="form-input"
                                                placeholder="Question / term"
                                                value={pair.question}
                                                onChange={e => updatePair(idx, 'question', e.target.value)}
                                            />
                                            <input
                                                className="form-input"
                                                placeholder="Answer / definition"
                                                value={pair.answer}
                                                onChange={e => updatePair(idx, 'answer', e.target.value)}
                                            />
                                            <div className="flex gap-2">
                                                <Button variant="ghost" size="sm" iconOnly onClick={() => movePair(idx, -1)} disabled={idx === 0} title="Move up">↑</Button>
                                                <Button variant="ghost" size="sm" iconOnly onClick={() => movePair(idx, 1)}  disabled={idx === pairs.length - 1} title="Move down">↓</Button>
                                                <Button variant="ghost" size="sm" iconOnly onClick={() => removePair(idx)} title="Delete">🗑</Button>
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

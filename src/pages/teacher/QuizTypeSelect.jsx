import { useNavigate, Link } from 'react-router-dom';
import Button from '../../components/ui/Button';

/**
 * QuizTypeSelect — teacher picks which kind of quiz to create.
 */
export default function QuizTypeSelect() {
    const navigate = useNavigate();
    return (
        <div className="app-shell">
            <header className="app-header">
                <div className="app-header-logo">
                    <img src="/exeter-logo.png" alt="Exeter College" />
                    <span className="app-header-title">Create New Quiz</span>
                </div>
                <nav className="app-header-nav">
                    <Link to="/teacher"><Button variant="ghost" size="sm">← Dashboard</Button></Link>
                </nav>
            </header>
            <main className="app-main">
                <h1 className="editor-page-title">Choose quiz type</h1>
                <div className="quiz-type-grid">
                    <div className="quiz-type-card" onClick={() => navigate('/teacher/quiz/new/match')} role="button" tabIndex={0}>
                        <div className="quiz-type-icon">🔗</div>
                        <div className="quiz-type-name">Match Definitions</div>
                        <div className="quiz-type-desc">Students drag answers to match questions. Great for vocabulary and key concepts.</div>
                    </div>
                    <div className="quiz-type-card" onClick={() => navigate('/teacher/quiz/new/mc')} role="button" tabIndex={0}>
                        <div className="quiz-type-icon">✅</div>
                        <div className="quiz-type-name">Multiple Choice</div>
                        <div className="quiz-type-desc">Students pick one correct answer from four options. Great for knowledge testing.</div>
                    </div>
                </div>
            </main>
        </div>
    );
}

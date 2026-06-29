import Modal from '../ui/Modal';
import Button from '../ui/Button';

/**
 * ScoreModal — end-of-quiz results overlay.
 *
 * @param {boolean}  open
 * @param {number}   score        Correct answers.
 * @param {number}   total        Total questions.
 * @param {string}   quizName
 * @param {Function} onPlayAgain  Resets quiz.
 * @param {Function} onExit       Returns to entry page.
 */
export default function ScoreModal({ open, score, total, quizName, onPlayAgain, onExit }) {
    const pct   = total > 0 ? Math.round((score / total) * 100) : 0;
    const emoji = pct >= 80 ? '🎉' : pct >= 50 ? '👍' : '💪';
    const label = pct >= 80
        ? 'Excellent work!'
        : pct >= 50
        ? 'Good effort — keep practising!'
        : 'Keep going — practice makes perfect!';

    return (
        <Modal open={open} title={quizName || 'Quiz Complete'}>
            <div className="score-modal-body">
                <div className="score-emoji">{emoji}</div>
                <div className="score-value">{score} / {total}</div>
                <div className="score-label">{label}</div>
                <div className="flex-center gap-3">
                    {onPlayAgain && (
                        <Button variant="secondary" onClick={onPlayAgain}>Try again</Button>
                    )}
                    <Button variant="primary" onClick={onExit}>Finish</Button>
                </div>
            </div>
        </Modal>
    );
}

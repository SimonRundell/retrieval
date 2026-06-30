import Modal  from '../ui/Modal';
import Button from '../ui/Button';

/**
 * ScoreModal — end-of-quiz results overlay with answer review.
 *
 * @param {boolean}  open
 * @param {number}   score          Correct answers.
 * @param {number}   total          Total questions.
 * @param {string}   quizName
 * @param {Array}    reviewItems    Question review data. Two shapes:
 *   MC:    { type:'mc',    question, correctAnswer, studentAnswer, wasCorrect }
 *   Match: { type:'match', question, answer }
 * @param {Function} onPlayAgain    Resets the quiz.
 * @param {Function} onExit         Returns to the entry page.
 */
export default function ScoreModal({ open, score, total, quizName, reviewItems, onPlayAgain, onExit }) {
    const pct   = total > 0 ? Math.round((score / total) * 100) : 0;
    const emoji = pct >= 80 ? '🎉' : pct >= 50 ? '👍' : '💪';
    const label = pct >= 80
        ? 'Excellent work!'
        : pct >= 50
        ? 'Good effort — keep practising!'
        : 'Keep going — practice makes perfect!';

    const hasReview = reviewItems?.length > 0;
    const quizType  = hasReview ? reviewItems[0].type : null;

    return (
        <Modal open={open} title={quizName || 'Quiz Complete'} size={hasReview ? 'wide' : ''}>
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

            {hasReview && (
                <div className="score-review">
                    <h3 className="score-review-title">
                        {quizType === 'match' ? 'All matched pairs' : 'Question review'}
                    </h3>

                    {quizType === 'match' && (
                        <p className="score-review-hint">
                            Use these to help you remember — cover one column and test yourself.
                        </p>
                    )}

                    <div className="score-review-list">
                        {reviewItems.map((item, i) => (
                            quizType === 'match'
                                ? (
                                    <div key={i} className="score-review-item score-review-item--match">
                                        <span className="score-review-term">{item.question}</span>
                                        <span className="score-review-arrow">→</span>
                                        <span className="score-review-definition">{item.answer}</span>
                                    </div>
                                ) : (
                                    <div key={i} className={`score-review-item${item.wasCorrect ? ' score-review-item--correct' : ' score-review-item--wrong'}`}>
                                        <div className="score-review-q">
                                            <span className="score-review-icon">{item.wasCorrect ? '✓' : '✗'}</span>
                                            <span className="score-review-question">{item.question}</span>
                                        </div>
                                        <div className="score-review-answers">
                                            {!item.wasCorrect && (
                                                <span className="score-review-student">
                                                    Your answer: <strong>{item.studentAnswer}</strong>
                                                </span>
                                            )}
                                            <span className="score-review-correct">
                                                Correct answer: <strong>{item.correctAnswer}</strong>
                                            </span>
                                        </div>
                                    </div>
                                )
                        ))}
                    </div>
                </div>
            )}
        </Modal>
    );
}

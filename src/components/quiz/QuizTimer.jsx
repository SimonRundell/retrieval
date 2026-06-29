import { useEffect, useRef, useState } from 'react';

/**
 * QuizTimer — countdown display that calls onExpire when it reaches zero.
 *
 * @param {string}   startTime     ISO 8601 datetime string when the session started.
 * @param {number}   durationSecs  Total duration in seconds.
 * @param {number}   [remainingSecs] Server-calculated remaining seconds at load time.
 *                                  When provided it is used as the initial value so the
 *                                  first render is correct even if startTime has timezone
 *                                  ambiguity. Subsequent ticks recalculate from startTime.
 * @param {Function} [onExpire]    Callback fired once when time reaches zero.
 * @param {boolean}  [large]       Use the watch-page (projector) style.
 */
export default function QuizTimer({ startTime, durationSecs, remainingSecs, onExpire, large = false }) {
    const [remaining, setRemaining] = useState(() =>
        remainingSecs !== undefined ? Math.max(0, remainingSecs) : calcRemaining(startTime, durationSecs)
    );
    const expiredRef = useRef(false);

    useEffect(() => {
        if (remaining <= 0 && !expiredRef.current) {
            expiredRef.current = true;
            onExpire?.();
            return;
        }

        const id = setInterval(() => {
            const secs = calcRemaining(startTime, durationSecs);
            setRemaining(secs);
            if (secs <= 0 && !expiredRef.current) {
                expiredRef.current = true;
                clearInterval(id);
                onExpire?.();
            }
        }, 1000);
        return () => clearInterval(id);
    }, [startTime, durationSecs, onExpire]);

    const mins    = Math.floor(remaining / 60).toString().padStart(2, '0');
    const secs    = (remaining % 60).toString().padStart(2, '0');
    const display = `${mins}:${secs}`;

    let cls = large ? 'watch-timer' : 'quiz-timer';
    if (remaining <= 60)       cls += ` ${cls}--danger`;
    else if (remaining <= 120) cls += ` ${cls}--warning`;

    return (
        <div className={cls} role="timer" aria-live="off" aria-label={`${display} remaining`}>
            ⏱ {display}
        </div>
    );
}

function calcRemaining(startTime, durationSecs) {
    const start = new Date(startTime).getTime();
    if (isNaN(start)) return 0;
    const end  = start + durationSecs * 1000;
    return Math.max(0, Math.round((end - Date.now()) / 1000));
}

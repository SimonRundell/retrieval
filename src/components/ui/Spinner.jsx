/**
 * Spinner — loading indicator.
 * @param {'sm'|'md'|'lg'} size
 * @param {boolean}        overlay  Renders a full-screen blocking overlay.
 * @param {string}         label    Text shown beneath the spinner in overlay mode.
 */
export default function Spinner({ size = 'md', overlay = false, label = 'Loading...' }) {
    const cls = ['spinner', size !== 'md' && `spinner--${size}`].filter(Boolean).join(' ');

    if (overlay) {
        return (
            <div className="spinner-overlay" role="status" aria-label={label}>
                <div className={cls} />
                <p>{label}</p>
            </div>
        );
    }

    return <div className={cls} role="status" aria-label={label} />;
}

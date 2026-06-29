/**
 * Input — labelled form input with optional hint and error message.
 */
export default function Input({
    label,
    hint,
    error,
    id,
    className = '',
    type = 'text',
    ...props
}) {
    const inputId = id || label?.toLowerCase().replace(/\s+/g, '-');
    return (
        <div className="form-group">
            {label && <label className="form-label" htmlFor={inputId}>{label}</label>}
            <input
                id={inputId}
                type={type}
                className={`form-input${error ? ' form-input--error' : ''} ${className}`}
                {...props}
            />
            {hint  && <p className="form-hint">{hint}</p>}
            {error && <p className="form-error" role="alert">{error}</p>}
        </div>
    );
}

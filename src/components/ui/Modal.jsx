import { useEffect, useRef } from 'react';

/**
 * Modal — focus-trapped, ESC-dismissible overlay dialog.
 * @param {boolean}  open       Controls visibility.
 * @param {Function} onClose    Called on backdrop click or ESC.
 * @param {string}   title      Header text.
 * @param {string}   size       '' | 'wide'
 */
export default function Modal({ open, onClose, title, children, footer, size = '' }) {
    const dialogRef = useRef(null);

    // Keep the latest onClose in a ref so the effect below doesn't need it as
    // a dependency — onClose is often a fresh function identity on every
    // render, which would otherwise re-run the effect (and steal focus back
    // to the dialog) on every keystroke inside the modal.
    const onCloseRef = useRef(onClose);
    onCloseRef.current = onClose;

    useEffect(() => {
        if (!open) return;
        dialogRef.current?.focus();
        const handler = (e) => { if (e.key === 'Escape') onCloseRef.current?.(); };
        document.addEventListener('keydown', handler);
        return () => document.removeEventListener('keydown', handler);
    }, [open]);

    if (!open) return null;

    return (
        <div className="modal-backdrop" onClick={(e) => { if (e.target === e.currentTarget) onClose?.(); }}>
            <div
                ref={dialogRef}
                className={`modal${size === 'wide' ? ' modal--wide' : ''}`}
                role="dialog"
                aria-modal="true"
                aria-labelledby="modal-title"
                tabIndex={-1}
            >
                {title && (
                    <div className="modal-header">
                        <h2 className="modal-title" id="modal-title">{title}</h2>
                        {onClose && (
                            <button className="modal-close" onClick={onClose} aria-label="Close">×</button>
                        )}
                    </div>
                )}
                <div className="modal-body">{children}</div>
                {footer && <div className="modal-footer">{footer}</div>}
            </div>
        </div>
    );
}

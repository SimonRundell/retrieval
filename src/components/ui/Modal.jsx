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

    useEffect(() => {
        if (!open) return;
        const handler = (e) => { if (e.key === 'Escape') onClose?.(); };
        document.addEventListener('keydown', handler);
        dialogRef.current?.focus();
        return () => document.removeEventListener('keydown', handler);
    }, [open, onClose]);

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

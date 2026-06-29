import { createContext, useCallback, useContext, useState } from 'react';

const ToastContext = createContext(null);

/**
 * Provides a global toast notification queue.
 * Call useToast() in any component to fire toasts.
 */
export function ToastProvider({ children }) {
    const [toasts, setToasts] = useState([]);

    const addToast = useCallback((message, type = 'info', duration = 3500) => {
        const id = Date.now() + Math.random();
        setToasts(prev => [...prev, { id, message, type }]);
        setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), duration);
    }, []);

    const toast = {
        success: (msg) => addToast(msg, 'success'),
        error:   (msg) => addToast(msg, 'error'),
        info:    (msg) => addToast(msg, 'info'),
        warning: (msg) => addToast(msg, 'warning'),
    };

    const icons = { success: '✓', error: '✕', info: 'i', warning: '!' };

    return (
        <ToastContext.Provider value={toast}>
            {children}
            <div className="toast-container" role="region" aria-live="polite">
                {toasts.map(t => (
                    <div key={t.id} className={`toast toast--${t.type}`}>
                        <span className="toast-icon">{icons[t.type]}</span>
                        <span className="toast-message">{t.message}</span>
                    </div>
                ))}
            </div>
        </ToastContext.Provider>
    );
}

export const useToast = () => useContext(ToastContext);

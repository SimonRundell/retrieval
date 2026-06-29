import { useState } from 'react';

/**
 * Accordion — collapsible panel list, replacing antd Collapse.
 * @param {Array}  items  [{ key, label, extra, children }]
 * @param {boolean} multi Allow multiple panels open simultaneously.
 */
export default function Accordion({ items = [], multi = true }) {
    const [open, setOpen] = useState(new Set());

    function toggle(key) {
        setOpen(prev => {
            const next = multi ? new Set(prev) : new Set();
            prev.has(key) ? next.delete(key) : next.add(key);
            return next;
        });
    }

    return (
        <div className="accordion">
            {items.map(item => {
                const isOpen = open.has(item.key);
                return (
                    <div key={item.key} className={`accordion-item${isOpen ? ' accordion-item--open' : ''}`}>
                        <button
                            className="accordion-trigger"
                            onClick={() => toggle(item.key)}
                            aria-expanded={isOpen}
                        >
                            <span className="accordion-trigger-left">{item.label}</span>
                            {item.extra && <span onClick={e => e.stopPropagation()}>{item.extra}</span>}
                            <span className="accordion-chevron" aria-hidden="true">⌄</span>
                        </button>
                        <div className="accordion-content" hidden={!isOpen}>
                            {item.children}
                        </div>
                    </div>
                );
            })}
        </div>
    );
}

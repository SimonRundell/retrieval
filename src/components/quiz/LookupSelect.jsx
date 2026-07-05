import { useState } from 'react';
import { useToast } from '../../contexts/ToastContext';
import api from '../../hooks/useApi';

const ADD_NEW = '__add_new__';

/**
 * LookupSelect — dropdown backed by a standardised tblLookup category
 * (subject/topic/year/unit), with an inline "+ Add new…" option so any
 * teacher can extend the shared list without leaving the quiz editor.
 *
 * @param {string}   label      Field label.
 * @param {string}   category   'subject' | 'topic' | 'year' | 'unit'.
 * @param {string}   value      Currently selected value.
 * @param {Function} onChange   Called with the new string value.
 * @param {Array}    options    [{id, value}] for this category.
 * @param {Function} onOptionsChanged  Called with the updated options array after adding a new value.
 */
export default function LookupSelect({ label, category, value, onChange, options, onOptionsChanged }) {
    const toast = useToast();
    const [adding,   setAdding]   = useState(false);
    const [newValue, setNewValue] = useState('');
    const [saving,   setSaving]   = useState(false);

    // Legacy free-text data may not match any current lookup value — keep it selectable.
    const hasCurrentValue = value && options.some(o => o.value === value);

    async function commitNewValue() {
        const trimmed = newValue.trim();
        if (!trimmed) { setAdding(false); return; }

        setSaving(true);
        try {
            const res = await api.post('/addLookup.php', { category, value: trimmed });
            onOptionsChanged([...options, { id: res.data.id, value: trimmed }]);
            onChange(trimmed);
            setAdding(false);
            setNewValue('');
        } catch (err) {
            toast.error(err.response?.data?.message || 'Failed to add value.');
        } finally {
            setSaving(false);
        }
    }

    if (adding) {
        return (
            <div className="form-group">
                {label && <label className="form-label">{label}</label>}
                <input
                    className="form-input"
                    autoFocus
                    value={newValue}
                    placeholder={`New ${label?.toLowerCase()}…`}
                    disabled={saving}
                    onChange={e => setNewValue(e.target.value)}
                    onBlur={commitNewValue}
                    onKeyDown={e => {
                        if (e.key === 'Enter') { e.preventDefault(); commitNewValue(); }
                        if (e.key === 'Escape') { setAdding(false); setNewValue(''); }
                    }}
                />
            </div>
        );
    }

    return (
        <div className="form-group">
            {label && <label className="form-label">{label}</label>}
            <select
                className="form-select"
                value={value || ''}
                onChange={e => {
                    if (e.target.value === ADD_NEW) { setAdding(true); return; }
                    onChange(e.target.value);
                }}
            >
                <option value="">—</option>
                {!hasCurrentValue && value && <option value={value}>{value}</option>}
                {options.map(o => <option key={o.id} value={o.value}>{o.value}</option>)}
                <option value={ADD_NEW}>+ Add new…</option>
            </select>
        </div>
    );
}

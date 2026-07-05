import { useState } from 'react';
import { useToast } from '../../contexts/ToastContext';
import api from '../../hooks/useApi';
import Modal  from '../../components/ui/Modal';
import Button from '../../components/ui/Button';

const CATEGORIES = [
    { key: 'subject', label: 'Subject' },
    { key: 'topic',   label: 'Topic' },
    { key: 'year',    label: 'Year' },
    { key: 'unit',    label: 'Unit' },
];

/**
 * ManageLookupsModal — lets any teacher add, rename or delete the standardised
 * Subject/Topic/Year/Unit values shared across all quizzes.
 *
 * @param {boolean}  open
 * @param {Function} onClose
 * @param {Object}   lookups   { subject: [{id,value}], topic: [...], year: [...], unit: [...] }
 * @param {Function} onReload  Re-fetches lookups from the server after a change.
 */
export default function ManageLookupsModal({ open, onClose, lookups, onReload }) {
    const toast = useToast();
    const [tab, setTab] = useState('subject');

    const [editingId, setEditingId] = useState(null);
    const [editValue, setEditValue] = useState('');
    const [newValue,  setNewValue]  = useState('');
    const [busy,      setBusy]      = useState(false);

    function startEdit(item) { setEditingId(item.id); setEditValue(item.value); }
    function cancelEdit()    { setEditingId(null); setEditValue(''); }

    async function handleAdd() {
        const trimmed = newValue.trim();
        if (!trimmed) return;
        setBusy(true);
        try {
            await api.post('/addLookup.php', { category: tab, value: trimmed });
            setNewValue('');
            onReload();
        } catch (err) {
            toast.error(err.response?.data?.message || 'Failed to add value.');
        } finally {
            setBusy(false);
        }
    }

    async function handleRename(id) {
        const trimmed = editValue.trim();
        if (!trimmed) return;
        setBusy(true);
        try {
            await api.post('/renameLookup.php', { id, value: trimmed });
            toast.success('Value updated.');
            cancelEdit();
            onReload();
        } catch (err) {
            toast.error(err.response?.data?.message || 'Failed to rename value.');
        } finally {
            setBusy(false);
        }
    }

    async function handleDelete(item) {
        setBusy(true);
        try {
            await api.post('/deleteLookup.php', { id: item.id });
            toast.success('Value deleted.');
            onReload();
        } catch (err) {
            toast.error(err.response?.data?.message || 'Failed to delete value.');
        } finally {
            setBusy(false);
        }
    }

    const items = lookups[tab] || [];

    return (
        <Modal open={open} onClose={onClose} title="Manage standardised lists" footer={<Button variant="ghost" onClick={onClose}>Close</Button>}>
            <div className="dashboard-tabs">
                {CATEGORIES.map(c => (
                    <button
                        key={c.key}
                        className={`dashboard-tab${tab === c.key ? ' dashboard-tab--active' : ''}`}
                        onClick={() => { setTab(c.key); cancelEdit(); }}
                    >
                        {c.label}
                    </button>
                ))}
            </div>

            <div className="lookup-list">
                {items.length === 0 && <p className="form-hint">No values yet.</p>}
                {items.map(item => (
                    <div key={item.id} className="lookup-list-row">
                        {editingId === item.id ? (
                            <input
                                className="form-input"
                                autoFocus
                                value={editValue}
                                disabled={busy}
                                onChange={e => setEditValue(e.target.value)}
                                onKeyDown={e => {
                                    if (e.key === 'Enter')  handleRename(item.id);
                                    if (e.key === 'Escape') cancelEdit();
                                }}
                            />
                        ) : (
                            <span className="lookup-list-value">{item.value}</span>
                        )}
                        <div className="flex gap-2">
                            {editingId === item.id ? (
                                <>
                                    <Button size="sm" variant="secondary" disabled={busy} onClick={() => handleRename(item.id)}>Save</Button>
                                    <Button size="sm" variant="ghost" disabled={busy} onClick={cancelEdit}>Cancel</Button>
                                </>
                            ) : (
                                <>
                                    <Button size="sm" variant="ghost" disabled={busy} onClick={() => startEdit(item)}>Rename</Button>
                                    <Button size="sm" variant="danger" disabled={busy} onClick={() => handleDelete(item)}>Delete</Button>
                                </>
                            )}
                        </div>
                    </div>
                ))}
            </div>

            <div className="lookup-add-row">
                <input
                    className="form-input"
                    placeholder={`Add a new ${tab}…`}
                    value={newValue}
                    disabled={busy}
                    onChange={e => setNewValue(e.target.value)}
                    onKeyDown={e => { if (e.key === 'Enter') handleAdd(); }}
                />
                <Button variant="secondary" disabled={busy || !newValue.trim()} onClick={handleAdd}>+ Add</Button>
            </div>
        </Modal>
    );
}

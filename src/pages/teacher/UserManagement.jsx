import { useEffect, useState } from 'react';
import CryptoJS from 'crypto-js';
import { useAuth }  from '../../contexts/AuthContext';
import { useToast } from '../../contexts/ToastContext';
import api       from '../../hooks/useApi';
import Button    from '../../components/ui/Button';
import Input     from '../../components/ui/Input';
import Modal     from '../../components/ui/Modal';
import Spinner   from '../../components/ui/Spinner';

function emptyForm() {
    return { id: null, email: '', studentName: '', schoolName: '', admin: false, teacher: false };
}

/**
 * UserManagement — admin-only CRUD screen for tbluser (add, edit, delete, reset password).
 */
export default function UserManagement() {
    const { teacher } = useAuth();
    const toast = useToast();

    const [users,   setUsers]   = useState([]);
    const [loading, setLoading] = useState(true);

    const [editUser,  setEditUser]  = useState(null); // null = closed, emptyForm() = add, {...} = edit
    const [form,      setForm]      = useState(emptyForm());
    const [password,  setPassword]  = useState('');
    const [saving,    setSaving]    = useState(false);

    const [deleteUser, setDeleteUser] = useState(null);
    const [deleting,   setDeleting]   = useState(false);

    const [resetUser,     setResetUser]     = useState(null);
    const [resetPassword, setResetPassword] = useState('');
    const [resetting,     setResetting]     = useState(false);

    function loadUsers() {
        setLoading(true);
        api.post('/getUsers.php', {})
            .then(res => setUsers(Array.isArray(res.data) ? res.data : []))
            .catch(() => toast.error('Failed to load users.'))
            .finally(() => setLoading(false));
    }

    useEffect(loadUsers, []);

    function openAdd()  { setForm(emptyForm()); setPassword(''); setEditUser(emptyForm()); }
    function openEdit(u) {
        setForm({
            id: u.id, email: u.email, studentName: u.studentName || '', schoolName: u.schoolName || '',
            admin: !!Number(u.admin), teacher: !!Number(u.teacher),
        });
        setEditUser(u);
    }
    function closeForm() { setEditUser(null); }

    function updateForm(key, val) { setForm(prev => ({ ...prev, [key]: val })); }

    const isSelf = id => id === teacher?.id;

    async function handleSave() {
        if (!form.email.trim()) return toast.error('Email is required.');
        const isNew = form.id == null;
        if (isNew && !password) return toast.error('A password is required for new users.');

        setSaving(true);
        try {
            if (isNew) {
                await api.post('/adminAddUser.php', {
                    email: form.email, passwordHash: CryptoJS.MD5(password).toString(),
                    studentName: form.studentName, schoolName: form.schoolName,
                    admin: form.admin, teacher: form.teacher,
                });
                toast.success('User created!');
            } else {
                await api.post('/adminEditUser.php', {
                    id: form.id, email: form.email,
                    studentName: form.studentName, schoolName: form.schoolName,
                    admin: form.admin, teacher: form.teacher,
                });
                toast.success('User updated!');
            }
            closeForm();
            loadUsers();
        } catch (err) {
            toast.error(err.response?.data?.message || 'Failed to save user.');
        } finally {
            setSaving(false);
        }
    }

    async function handleDelete() {
        setDeleting(true);
        try {
            await api.post('/adminDeleteUser.php', { id: deleteUser.id });
            toast.success('User deleted.');
            setDeleteUser(null);
            loadUsers();
        } catch (err) {
            toast.error(err.response?.data?.message || 'Failed to delete user.');
        } finally {
            setDeleting(false);
        }
    }

    async function handleResetPassword() {
        if (!resetPassword) return toast.error('Enter a new password.');
        setResetting(true);
        try {
            await api.post('/adminResetPassword.php', {
                id: resetUser.id, passwordHash: CryptoJS.MD5(resetPassword).toString(),
            });
            toast.success('Password reset.');
            setResetUser(null);
            setResetPassword('');
        } catch (err) {
            toast.error(err.response?.data?.message || 'Failed to reset password.');
        } finally {
            setResetting(false);
        }
    }

    return (
        <div>
            <div className="dashboard-header">
                <div>
                    <h1 className="dashboard-title">Manage Users</h1>
                    <p className="dashboard-subtitle">{users.length} user{users.length !== 1 ? 's' : ''}</p>
                </div>
                <Button variant="primary" onClick={openAdd}>+ Add user</Button>
            </div>

            {loading && <Spinner overlay label="Loading users…" />}

            {!loading && (
                <div className="csv-table-wrap">
                    <table className="csv-table">
                        <thead>
                            <tr>
                                <th>Email</th>
                                <th>Name</th>
                                <th>School</th>
                                <th>Roles</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {users.map(u => (
                                <tr key={u.id}>
                                    <td>{u.email}</td>
                                    <td>{u.studentName || '—'}</td>
                                    <td>{u.schoolName || '—'}</td>
                                    <td>
                                        {!!Number(u.admin)   && <span className="badge badge--red"   style={{ marginRight: 4 }}>Admin</span>}
                                        {!!Number(u.teacher) && <span className="badge badge--blue">Teacher</span>}
                                    </td>
                                    <td>
                                        <div className="flex gap-2">
                                            <Button size="sm" variant="secondary" onClick={() => openEdit(u)}>Edit</Button>
                                            <Button size="sm" variant="ghost" onClick={() => { setResetUser(u); setResetPassword(''); }}>Reset password</Button>
                                            <Button
                                                size="sm"
                                                variant="danger"
                                                onClick={() => setDeleteUser(u)}
                                                disabled={isSelf(u.id)}
                                                title={isSelf(u.id) ? "You can't delete your own account" : 'Delete'}
                                            >
                                                Delete
                                            </Button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}

            {/* Add / edit modal */}
            <Modal
                open={!!editUser}
                onClose={closeForm}
                title={form.id == null ? 'Add user' : `Edit: ${editUser?.email}`}
                footer={
                    <>
                        <Button variant="ghost" onClick={closeForm}>Cancel</Button>
                        <Button variant="primary" onClick={handleSave} disabled={saving}>
                            {saving ? 'Saving…' : 'Save'}
                        </Button>
                    </>
                }
            >
                <Input label="Email *" type="email" value={form.email} onChange={e => updateForm('email', e.target.value)} />
                <Input label="Name" value={form.studentName} onChange={e => updateForm('studentName', e.target.value)} />
                <Input label="School" value={form.schoolName} onChange={e => updateForm('schoolName', e.target.value)} />
                {form.id == null && (
                    <Input
                        label="Password *"
                        type="password"
                        value={password}
                        onChange={e => setPassword(e.target.value)}
                        autoComplete="new-password"
                    />
                )}
                <div className="form-group">
                    <label className="form-label">Roles</label>
                    <div className="flex gap-2" style={{ flexDirection: 'column' }}>
                        <label style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                            <input type="checkbox" checked={form.teacher} onChange={e => updateForm('teacher', e.target.checked)} />
                            Teacher (can sign in to the staff portal)
                        </label>
                        <label style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                            <input
                                type="checkbox"
                                checked={form.admin}
                                onChange={e => updateForm('admin', e.target.checked)}
                                disabled={isSelf(form.id)}
                                title={isSelf(form.id) ? "You can't remove your own admin access" : undefined}
                            />
                            Administrator (can manage users)
                        </label>
                    </div>
                </div>
            </Modal>

            {/* Delete confirm */}
            <Modal
                open={!!deleteUser}
                onClose={() => setDeleteUser(null)}
                title="Delete user"
                footer={
                    <>
                        <Button variant="ghost" onClick={() => setDeleteUser(null)}>Cancel</Button>
                        <Button variant="danger" onClick={handleDelete} disabled={deleting}>
                            {deleting ? 'Deleting…' : 'Delete'}
                        </Button>
                    </>
                }
            >
                <p>Are you sure you want to delete <strong>{deleteUser?.email}</strong>? This cannot be undone.</p>
            </Modal>

            {/* Reset password */}
            <Modal
                open={!!resetUser}
                onClose={() => setResetUser(null)}
                title={`Reset password: ${resetUser?.email}`}
                footer={
                    <>
                        <Button variant="ghost" onClick={() => setResetUser(null)}>Cancel</Button>
                        <Button variant="primary" onClick={handleResetPassword} disabled={resetting}>
                            {resetting ? 'Saving…' : 'Set new password'}
                        </Button>
                    </>
                }
            >
                <Input
                    label="New password *"
                    type="password"
                    value={resetPassword}
                    onChange={e => setResetPassword(e.target.value)}
                    autoComplete="new-password"
                />
            </Modal>
        </div>
    );
}

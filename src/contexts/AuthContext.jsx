import { createContext, useContext, useState } from 'react';

const AuthContext = createContext(null);

/**
 * Provides JWT-based authentication state throughout the app.
 * Token and teacher profile are persisted to localStorage.
 */
export function AuthProvider({ children }) {
    const [token, setToken] = useState(() => localStorage.getItem('examRevToken'));
    const [teacher, setTeacher] = useState(() => {
        try {
            return JSON.parse(localStorage.getItem('examRevTeacher'));
        } catch {
            return null;
        }
    });

    function login(tok, teacherObj) {
        localStorage.setItem('examRevToken', tok);
        localStorage.setItem('examRevTeacher', JSON.stringify(teacherObj));
        setToken(tok);
        setTeacher(teacherObj);
    }

    function logout() {
        localStorage.removeItem('examRevToken');
        localStorage.removeItem('examRevTeacher');
        setToken(null);
        setTeacher(null);
    }

    return (
        <AuthContext.Provider value={{ token, teacher, login, logout, isAuthenticated: !!token }}>
            {children}
        </AuthContext.Provider>
    );
}

export const useAuth = () => useContext(AuthContext);

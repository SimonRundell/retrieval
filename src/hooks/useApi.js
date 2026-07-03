import axios from 'axios';

/**
 * Pre-configured axios instance.
 * baseURL is set at app startup from public/.config.json (see main.jsx)
 * so the frontend targets the Laragon-served API rather than the Vite dev origin.
 * Automatically attaches the JWT Bearer token from localStorage
 * to every request so individual components don't need to manage headers.
 */
const api = axios.create();

api.interceptors.request.use(config => {
    const token = localStorage.getItem('examRevToken');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

export default api;

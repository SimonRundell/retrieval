import axios from 'axios';

/**
 * Pre-configured axios instance.
 * Automatically attaches the JWT Bearer token from localStorage
 * to every request so individual components don't need to manage headers.
 */
const api = axios.create({
    baseURL: '/api',
});

api.interceptors.request.use(config => {
    const token = localStorage.getItem('examRevToken');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

export default api;

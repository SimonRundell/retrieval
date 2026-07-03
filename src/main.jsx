import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';
import api from './hooks/useApi.js';

/**
 * Loads public/.config.json and applies its "api" URL to the shared axios
 * instance before the app renders, so requests target the Laragon-served
 * backend instead of the Vite dev server origin.
 */
async function bootstrap() {
    const res = await fetch('/.config.json');
    const config = await res.json();
    api.defaults.baseURL = config.api;

    createRoot(document.getElementById('root')).render(
        <StrictMode>
            <App />
        </StrictMode>
    );
}

bootstrap();

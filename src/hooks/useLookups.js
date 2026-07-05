import { useCallback, useEffect, useState } from 'react';
import api from './useApi';

const EMPTY = { subject: [], topic: [], year: [], unit: [] };

/**
 * useLookups — loads the standardised Subject/Topic/Year/Unit value lists
 * shared by the quiz editors and the dashboard filter bar.
 * @returns {[Object, Function, Function]} [lookups, setLookups, reload]
 */
export default function useLookups() {
    const [lookups, setLookups] = useState(EMPTY);

    const reload = useCallback(() => {
        api.post('/getLookups.php', {})
            .then(res => setLookups(res.data || EMPTY))
            .catch(() => {});
    }, []);

    useEffect(reload, [reload]);

    return [lookups, setLookups, reload];
}

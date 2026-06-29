import { useState, useRef } from 'react';
import Modal  from '../ui/Modal';
import Button from '../ui/Button';

const MC_COLS    = ['Question', 'A', 'B', 'C', 'D', 'Correct'];
const MATCH_COLS = ['Term', 'Definition'];

const PREVIEW_LIMIT = 50;

/**
 * Minimal RFC-4180 CSV parser.
 * Handles UTF-8 BOM, CRLF/LF, and double-quote escaping.
 * @param {string} text Raw file text.
 * @returns {string[][]} Array of rows, each an array of trimmed cell strings.
 */
function parseCSV(text) {
    if (text.charCodeAt(0) === 0xFEFF) text = text.slice(1); // strip BOM

    const rows    = [];
    let fields    = [];
    let current   = '';
    let inQuotes  = false;

    // Append sentinel newline so the final row is always flushed
    for (let i = 0; i <= text.length; i++) {
        const ch = i < text.length ? text[i] : '\n';

        if (ch === '"') {
            if (inQuotes && text[i + 1] === '"') { current += '"'; i++; } // escaped quote
            else inQuotes = !inQuotes;
        } else if (ch === ',' && !inQuotes) {
            fields.push(current.trim());
            current = '';
        } else if ((ch === '\n' || ch === '\r') && !inQuotes) {
            if (ch === '\r' && text[i + 1] === '\n') i++; // CRLF
            fields.push(current.trim());
            current = '';
            if (fields.some(f => f !== '')) rows.push(fields);
            fields = [];
        } else {
            current += ch;
        }
    }

    return rows;
}

/**
 * Validate and map CSV rows for a Multiple Choice quiz.
 * Required columns (case-insensitive): Question, A, B, C, D, Correct
 * @returns {{ data?: object[], error?: string }}
 */
function validateMC(rows) {
    if (rows.length < 2) return { error: 'The file has no data rows.' };

    const header  = rows[0].map(h => h.toLowerCase());
    const missing = ['question', 'a', 'b', 'c', 'd', 'correct'].filter(k => !header.includes(k));
    if (missing.length) return { error: `Missing required column(s): ${missing.join(', ')}` };

    const idx = k => header.indexOf(k);

    const data = rows.slice(1).map((row, i) => {
        const question     = (row[idx('question')] ?? '').trim();
        const answers      = ['a', 'b', 'c', 'd'].map(k => (row[idx(k)] ?? '').trim());
        const correctLetter = (row[idx('correct')] ?? '').trim().toUpperCase();
        const correctAnswer = ['A', 'B', 'C', 'D'].indexOf(correctLetter);

        const errors = [];
        if (!question)                   errors.push('Missing question');
        if (answers.some(a => !a))       errors.push('Missing answer option(s)');
        if (correctAnswer === -1)        errors.push(`Correct must be A, B, C or D (got "${correctLetter || 'blank'}")`);

        return { question, answers, correctAnswer, _row: i + 2, _errors: errors };
    });

    return { data };
}

/**
 * Validate and map CSV rows for a Match Definitions quiz.
 * Required columns (case-insensitive): Term, Definition
 * @returns {{ data?: object[], error?: string }}
 */
function validateMatch(rows) {
    if (rows.length < 2) return { error: 'The file has no data rows.' };

    const header  = rows[0].map(h => h.toLowerCase());
    const missing = ['term', 'definition'].filter(k => !header.includes(k));
    if (missing.length) return { error: `Missing required column(s): ${missing.join(', ')}` };

    const tIdx = header.indexOf('term');
    const dIdx = header.indexOf('definition');

    const data = rows.slice(1).map((row, i) => {
        const question = (row[tIdx] ?? '').trim();
        const answer   = (row[dIdx] ?? '').trim();
        const errors   = [];
        if (!question) errors.push('Missing term');
        if (!answer)   errors.push('Missing definition');
        return { question, answer, _row: i + 2, _errors: errors };
    });

    return { data };
}

/**
 * CsvImportModal — guides the teacher through importing bulk questions from a CSV file.
 *
 * @param {Object}   props
 * @param {boolean}  props.open       Controls visibility.
 * @param {Function} props.onClose    Called when the dialog is dismissed.
 * @param {1|2}      props.quizType   1 = Match Definitions, 2 = Multiple Choice.
 * @param {Function} props.onImport   Called with the validated array of question objects on confirm.
 */
export default function CsvImportModal({ open, onClose, quizType, onImport }) {
    const [parsed,   setParsed]   = useState(null);
    const [fileName, setFileName] = useState('');
    const fileRef = useRef(null);

    const isMatch = quizType === 1;

    const exampleRows = isMatch
        ? [
            ['Mitosis',  'Cell division producing two identical daughter cells'],
            ['Meiosis',  'Cell division that produces four genetically unique gametes'],
          ]
        : [
            ['What is the capital of France?', 'London', 'Paris', 'Berlin', 'Madrid', 'B'],
            ['What is the chemical symbol for water?', 'CO2', 'H2O2', 'H2O', 'NaCl', 'C'],
          ];

    function handleFile(e) {
        const file = e.target.files[0];
        if (!file) return;
        setFileName(file.name);
        const reader = new FileReader();
        reader.onload = ev => {
            const rows   = parseCSV(ev.target.result);
            const result = isMatch ? validateMatch(rows) : validateMC(rows);
            setParsed(result);
        };
        reader.readAsText(file, 'UTF-8');
    }

    function handleImport() {
        // Strip internal _row / _errors meta before passing data up
        const cleaned = parsed.data.map(({ _row, _errors, ...rest }) => rest);
        onImport(cleaned);
        handleClose();
    }

    function handleClose() {
        setParsed(null);
        setFileName('');
        if (fileRef.current) fileRef.current.value = '';
        onClose();
    }

    const cols       = isMatch ? MATCH_COLS : MC_COLS;
    const errorCount = parsed?.data?.filter(r => r._errors.length > 0).length ?? 0;
    const canImport  = !!(parsed?.data && errorCount === 0);
    const previewRows = parsed?.data?.slice(0, PREVIEW_LIMIT) ?? [];

    return (
        <Modal
            open={open}
            onClose={handleClose}
            title="Import questions from CSV"
            size="wide"
            footer={
                <>
                    <Button variant="ghost" onClick={handleClose}>Cancel</Button>
                    {parsed?.data && (
                        <Button variant="primary" onClick={handleImport} disabled={!canImport}>
                            Import {parsed.data.length} question{parsed.data.length !== 1 ? 's' : ''}
                        </Button>
                    )}
                </>
            }
        >
            {/* Format guide */}
            <div className="csv-guide">
                <p className="csv-guide-title">
                    Expected columns — <strong>{isMatch ? 'Match Definitions' : 'Multiple Choice'}</strong>
                </p>
                <div className="csv-table-wrap">
                    <table className="csv-table csv-table--example">
                        <thead>
                            <tr>{cols.map(c => <th key={c}>{c}</th>)}</tr>
                        </thead>
                        <tbody>
                            {exampleRows.map((row, i) => (
                                <tr key={i}>{row.map((cell, j) => <td key={j}>{cell}</td>)}</tr>
                            ))}
                        </tbody>
                    </table>
                </div>
                <p className="csv-guide-hint">
                    In Excel, save as <strong>CSV UTF-8 (Comma delimited) (.csv)</strong>.
                    The first row must be the column headings shown above (case is ignored).
                    {isMatch ? ' All pairs are imported as a flat list — the editor will group them into sets of 4.' : ' The Correct column must contain A, B, C or D.'}
                </p>
            </div>

            {/* File picker */}
            <div className="csv-file-row">
                <label className="btn btn--secondary btn--sm" htmlFor="csv-file-input">
                    Choose CSV file
                </label>
                <input
                    id="csv-file-input"
                    ref={fileRef}
                    type="file"
                    accept=".csv,text/csv"
                    onChange={handleFile}
                    className="sr-only"
                />
                <span className="csv-file-name">{fileName || 'No file chosen'}</span>
            </div>

            {/* Parse / structural error */}
            {parsed?.error && (
                <div className="csv-parse-error">{parsed.error}</div>
            )}

            {/* Preview */}
            {parsed?.data && (
                <div className="csv-preview-section">
                    <div className="csv-preview-header">
                        <span className="csv-preview-count">
                            {parsed.data.length} row{parsed.data.length !== 1 ? 's' : ''} found
                        </span>
                        {errorCount > 0 && (
                            <span className="csv-error-badge">
                                {errorCount} row{errorCount !== 1 ? 's have' : ' has'} errors — fix in Excel and re-import
                            </span>
                        )}
                        {errorCount === 0 && (
                            <span className="csv-ok-badge">All rows valid</span>
                        )}
                    </div>

                    <div className="csv-table-wrap">
                        <table className="csv-table csv-table--preview">
                            <thead>
                                <tr>
                                    <th className="csv-col-num">#</th>
                                    {isMatch
                                        ? <><th>Term</th><th>Definition</th></>
                                        : <><th>Question</th><th>A</th><th>B</th><th>C</th><th>D</th><th>Correct</th></>
                                    }
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                {previewRows.map((row, i) => (
                                    <tr key={i} className={row._errors.length ? 'csv-row--error' : ''}>
                                        <td className="csv-col-num">{row._row}</td>
                                        {isMatch
                                            ? <><td>{row.question}</td><td>{row.answer}</td></>
                                            : <>
                                                <td>{row.question}</td>
                                                {row.answers.map((a, j) => <td key={j}>{a}</td>)}
                                                <td>{['A','B','C','D'][row.correctAnswer] ?? '?'}</td>
                                              </>
                                        }
                                        <td>
                                            {row._errors.length
                                                ? <span className="csv-status--error">✗ {row._errors.join('; ')}</span>
                                                : <span className="csv-status--ok">✓</span>
                                            }
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    {parsed.data.length > PREVIEW_LIMIT && (
                        <p className="csv-preview-more">
                            Showing first {PREVIEW_LIMIT} of {parsed.data.length} rows.
                        </p>
                    )}
                </div>
            )}
        </Modal>
    );
}

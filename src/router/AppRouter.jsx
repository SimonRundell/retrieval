import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from '../contexts/AuthContext';
import { ToastProvider } from '../contexts/ToastContext';
import ProtectedRoute from './ProtectedRoute';

import StudentEntry      from '../pages/student/StudentEntry';
import QuizPlayer        from '../pages/student/QuizPlayer';
import TeacherLogin      from '../pages/teacher/TeacherLogin';
import TeacherDashboard  from '../pages/teacher/TeacherDashboard';
import QuizTypeSelect    from '../pages/teacher/QuizTypeSelect';
import NewMatchQuiz      from '../pages/teacher/NewMatchQuiz';
import NewMCQuiz         from '../pages/teacher/NewMCQuiz';
import EditQuizRouter    from '../pages/teacher/EditQuizRouter';
import WatchQuiz         from '../pages/teacher/WatchQuiz';

export default function AppRouter() {
    return (
        <BrowserRouter>
            <AuthProvider>
                <ToastProvider>
                    <Routes>
                        {/* Student (public) */}
                        <Route path="/"               element={<StudentEntry />} />
                        <Route path="/quiz/:quizCode" element={<QuizPlayer />} />

                        {/* Teacher auth */}
                        <Route path="/teacher/login" element={<TeacherLogin />} />

                        {/* Teacher (protected) */}
                        <Route path="/teacher" element={
                            <ProtectedRoute><TeacherDashboard /></ProtectedRoute>
                        } />
                        <Route path="/teacher/quiz/new" element={
                            <ProtectedRoute><QuizTypeSelect /></ProtectedRoute>
                        } />
                        <Route path="/teacher/quiz/new/match" element={
                            <ProtectedRoute><NewMatchQuiz /></ProtectedRoute>
                        } />
                        <Route path="/teacher/quiz/new/mc" element={
                            <ProtectedRoute><NewMCQuiz /></ProtectedRoute>
                        } />
                        <Route path="/teacher/quiz/edit/:quizCode" element={
                            <ProtectedRoute><EditQuizRouter /></ProtectedRoute>
                        } />
                        <Route path="/teacher/quiz/watch/:quizCode" element={
                            <ProtectedRoute><WatchQuiz /></ProtectedRoute>
                        } />

                        {/* Fallback */}
                        <Route path="*" element={<Navigate to="/" replace />} />
                    </Routes>
                </ToastProvider>
            </AuthProvider>
        </BrowserRouter>
    );
}

-- CF Exam Marker Database Schema
-- Cloudflare D1 (SQLite)
-- Supports: Full exams, Chapter tests, Topic quizzes

-- =============================================
-- 1. CHAPTERS - Course chapters by subject
-- =============================================
CREATE TABLE IF NOT EXISTS chapters (
    id TEXT PRIMARY KEY,
    exam_type TEXT NOT NULL,
    grade TEXT,
    subject TEXT NOT NULL,
    chapter_number INTEGER,
    name TEXT NOT NULL,
    description TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active INTEGER DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_chapters_lookup ON chapters(exam_type, grade, subject);
CREATE INDEX IF NOT EXISTS idx_chapters_sort ON chapters(exam_type, grade, subject, sort_order);

-- =============================================
-- 2. TOPICS - Topics within chapters
-- =============================================
CREATE TABLE IF NOT EXISTS topics (
    id TEXT PRIMARY KEY,
    chapter_id TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active INTEGER DEFAULT 1,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_topics_chapter ON topics(chapter_id);
CREATE INDEX IF NOT EXISTS idx_topics_sort ON topics(chapter_id, sort_order);

-- =============================================
-- 3. EXAM SETS - Practice question sets
-- =============================================
CREATE TABLE IF NOT EXISTS exam_sets (
    id TEXT PRIMARY KEY,

    -- Categorization
    exam_type TEXT NOT NULL,
    grade TEXT,
    subject TEXT NOT NULL,

    -- Test scope: full, chapter, topic
    test_type TEXT DEFAULT 'full',
    chapter_id TEXT,
    topic_id TEXT,

    -- Metadata
    name TEXT NOT NULL,
    description TEXT,
    total_questions INTEGER NOT NULL,
    total_marks INTEGER NOT NULL,
    duration_minutes INTEGER DEFAULT 90,
    year TEXT,

    -- Access control
    is_free INTEGER DEFAULT 1,
    price_cents INTEGER DEFAULT 0,
    is_active INTEGER DEFAULT 1,

    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE SET NULL,
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_sets_lookup ON exam_sets(exam_type, grade, subject);
CREATE INDEX IF NOT EXISTS idx_sets_type ON exam_sets(test_type);
CREATE INDEX IF NOT EXISTS idx_sets_chapter ON exam_sets(chapter_id);
CREATE INDEX IF NOT EXISTS idx_sets_topic ON exam_sets(topic_id);
CREATE INDEX IF NOT EXISTS idx_sets_active ON exam_sets(is_active);

-- =============================================
-- 4. QUESTIONS - All exam questions
-- =============================================
CREATE TABLE IF NOT EXISTS questions (
    id TEXT PRIMARY KEY,
    set_id TEXT NOT NULL,
    type TEXT NOT NULL,
    marks INTEGER NOT NULL,
    difficulty REAL DEFAULT 0.5,
    question_text TEXT NOT NULL,
    question_latex TEXT,
    has_diagram INTEGER DEFAULT 0,
    diagram_svg TEXT,
    options_json TEXT,
    solution_json TEXT NOT NULL,
    unit TEXT,
    topic TEXT,
    case_study_json TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (set_id) REFERENCES exam_sets(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_questions_set ON questions(set_id);
CREATE INDEX IF NOT EXISTS idx_questions_type ON questions(type);
CREATE INDEX IF NOT EXISTS idx_questions_sort ON questions(set_id, sort_order);

-- =============================================
-- 5. USERS - User accounts (optional)
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE,
    name TEXT,
    auth_provider TEXT,
    auth_id TEXT,
    is_premium INTEGER DEFAULT 0,
    premium_until TEXT,
    total_tests_taken INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    last_active_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_auth ON users(auth_provider, auth_id);

-- =============================================
-- 6. TEST ATTEMPTS - When users take tests
-- =============================================
CREATE TABLE IF NOT EXISTS test_attempts (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    set_id TEXT NOT NULL,
    started_at TEXT DEFAULT CURRENT_TIMESTAMP,
    submitted_at TEXT,
    time_spent_seconds INTEGER,
    status TEXT DEFAULT 'in_progress',
    total_marks_obtained REAL,
    total_marks_possible INTEGER,
    percentage REAL,
    mcq_correct INTEGER DEFAULT 0,
    mcq_total INTEGER DEFAULT 0,
    subjective_marks REAL DEFAULT 0,
    subjective_total INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (set_id) REFERENCES exam_sets(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_attempts_user ON test_attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_attempts_set ON test_attempts(set_id);
CREATE INDEX IF NOT EXISTS idx_attempts_status ON test_attempts(status);
CREATE INDEX IF NOT EXISTS idx_attempts_started ON test_attempts(started_at);

-- =============================================
-- 7. USER ANSWERS - Answers given by users
-- =============================================
CREATE TABLE IF NOT EXISTS user_answers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    attempt_id TEXT NOT NULL,
    question_id TEXT NOT NULL,
    answer_text TEXT,
    answered_at TEXT DEFAULT CURRENT_TIMESTAMP,
    sub_part TEXT,
    FOREIGN KEY (attempt_id) REFERENCES test_attempts(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    UNIQUE(attempt_id, question_id, sub_part)
);

CREATE INDEX IF NOT EXISTS idx_answers_attempt ON user_answers(attempt_id);
CREATE INDEX IF NOT EXISTS idx_answers_question ON user_answers(question_id);

-- =============================================
-- 8. EVALUATIONS - AI grading results
-- =============================================
CREATE TABLE IF NOT EXISTS evaluations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    attempt_id TEXT NOT NULL,
    question_id TEXT NOT NULL,
    sub_part TEXT,
    marks_awarded REAL NOT NULL,
    max_marks INTEGER NOT NULL,
    feedback TEXT,
    step_analysis_json TEXT,
    confidence REAL,
    model_used TEXT DEFAULT 'gpt-4o-mini',
    evaluated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (attempt_id) REFERENCES test_attempts(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    UNIQUE(attempt_id, question_id, sub_part)
);

CREATE INDEX IF NOT EXISTS idx_evaluations_attempt ON evaluations(attempt_id);
CREATE INDEX IF NOT EXISTS idx_evaluations_question ON evaluations(question_id);

-- =============================================
-- 9. PURCHASES - Track paid content
-- =============================================
CREATE TABLE IF NOT EXISTS purchases (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    set_id TEXT NOT NULL,
    amount_cents INTEGER NOT NULL,
    currency TEXT DEFAULT 'INR',
    payment_provider TEXT,
    payment_id TEXT,
    status TEXT DEFAULT 'pending',
    purchased_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (set_id) REFERENCES exam_sets(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_purchases_user ON purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_purchases_set ON purchases(set_id);
CREATE INDEX IF NOT EXISTS idx_purchases_status ON purchases(status);

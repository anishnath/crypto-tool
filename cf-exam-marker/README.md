# CF Exam Marker

Cloudflare Worker that uses OpenAI to grade/evaluate student answers for subjective exam questions. Includes D1 database for storing exam sets, questions, and tracking user attempts.

## Setup

### 1. Install Wrangler CLI
```bash
npm install -g wrangler
```

### 2. Database Setup

#### First-time setup (create tables)
```bash
cd cf-exam-marker

# Apply schema to remote database
wrangler d1 execute exam-marker-db --file=schema.sql --remote

# Import exam data
node import-data.cjs
wrangler d1 execute exam-marker-db --file=import.sql --remote
```

#### For local development
```bash
# Apply schema locally
wrangler d1 execute exam-marker-db --file=schema.sql --local

# Import data locally
wrangler d1 execute exam-marker-db --file=import.sql --local
```

#### Migration FAQ

**Q: What happens if I run migration again?**

The schema uses `CREATE TABLE IF NOT EXISTS`, so running migration again:
- **Will NOT override** existing tables
- **Will NOT delete** existing data
- Will simply **skip** table creation if tables already exist

**Q: How do I reset/clear all data?**
```bash
# Drop all tables and recreate (WARNING: deletes all data!)
wrangler d1 execute exam-marker-db --command="DROP TABLE IF EXISTS evaluations; DROP TABLE IF EXISTS user_answers; DROP TABLE IF EXISTS test_attempts; DROP TABLE IF EXISTS purchases; DROP TABLE IF EXISTS users; DROP TABLE IF EXISTS questions; DROP TABLE IF EXISTS exam_sets; DROP TABLE IF EXISTS topics; DROP TABLE IF EXISTS chapters;" --remote

# Then re-run schema and import
wrangler d1 execute exam-marker-db --file=schema.sql --remote
wrangler d1 execute exam-marker-db --file=import.sql --remote
```

**Q: How do I add new exam sets?**

1. Create JSON file in `../src/main/webapp/exams/cbse-board/mathematics/data/`
2. Update `import-data.cjs` if needed
3. Run the import script again (uses INSERT, so duplicates will fail - delete first or use unique IDs)

### 3. Add Secrets
```bash
# OpenAI API Key (for AI grading)
wrangler secret put OPENAI_API_KEY

# API Key for protected endpoints
wrangler secret put API_KEY
```

For local development, create `.dev.vars`:
```
OPENAI_API_KEY=sk-...
API_KEY=your-local-api-key
```

### 4. Deploy
```bash
wrangler deploy
```

---

## API Endpoints

### Public Endpoints (No Auth Required)

#### Health Check
```
GET /health
```
```json
{
  "status": "ok",
  "service": "cf-exam-marker",
  "openai_configured": true,
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

---

#### List Chapters
```
GET /api/chapters?exam_type=CBSE&grade=10&subject=mathematics
```
Query params (all optional):
- `exam_type` - CBSE, JEE, NEET, etc.
- `grade` - 10, 11, 12, etc.
- `subject` - mathematics, physics, chemistry, etc.

Response:
```json
{
  "success": true,
  "chapters": [
    {
      "id": "cbse-10-math-ch01",
      "exam_type": "CBSE",
      "grade": "10",
      "subject": "mathematics",
      "chapter_number": 1,
      "name": "Real Numbers",
      "description": "Euclid's division lemma, Fundamental Theorem of Arithmetic, HCF, LCM"
    }
  ]
}
```

---

#### List Topics for a Chapter
```
GET /api/chapters/:id/topics
```
```json
{
  "success": true,
  "topics": [
    { "id": "topic-01", "name": "Euclid's Division Lemma", "sort_order": 1 }
  ]
}
```

---

#### List Exam Sets
```
GET /api/sets?exam_type=CBSE&grade=10&subject=mathematics&test_type=full
```
Query params (all optional):
- `exam_type` - CBSE, JEE, NEET
- `grade` - 10, 11, 12
- `subject` - mathematics, physics, chemistry
- `test_type` - full, chapter, topic
- `chapter_id` - For chapter-specific tests
- `topic_id` - For topic-specific quizzes

Response:
```json
{
  "success": true,
  "sets": [
    {
      "id": "cbse-10-math-full-01",
      "exam_type": "CBSE",
      "grade": "10",
      "subject": "mathematics",
      "test_type": "full",
      "name": "CBSE Class 10 Mathematics - Full Mock Test 1",
      "total_questions": 36,
      "total_marks": 80,
      "duration_minutes": 90,
      "is_free": 1,
      "price_cents": 0
    }
  ]
}
```

---

#### Get Single Set
```
GET /api/sets/:id
```
```json
{
  "success": true,
  "set": {
    "id": "cbse-10-math-full-01",
    "name": "CBSE Class 10 Mathematics - Full Mock Test 1",
    "total_questions": 36,
    "total_marks": 80,
    "duration_minutes": 90
  }
}
```

---

#### Get Questions for a Set
```
GET /api/sets/:id/questions
```
```json
{
  "success": true,
  "set_id": "cbse-10-math-full-01",
  "total": 36,
  "questions": [
    {
      "id": "cbse-10-math-full-01-U2-B2A-Q01",
      "type": "MCQ",
      "marks": 1,
      "difficulty": 0.5,
      "question_text": "If HCF(a, b) = 12...",
      "question_latex": "If $\\text{HCF}(a, b) = 12$...",
      "options": [
        { "id": "A", "text": "Option A" },
        { "id": "B", "text": "Option B" }
      ],
      "solution": {
        "steps": ["Step 1...", "Step 2..."],
        "answer": { "correct_option": "B" }
      }
    }
  ]
}
```

---

#### Start New Test Attempt
```
POST /api/attempts
Content-Type: application/json

{
  "set_id": "cbse-10-math-full-01",
  "user_id": "optional-user-id"
}
```
Response:
```json
{
  "success": true,
  "attempt_id": "94b9bea7-420f-4599-ae4d-0b4e64564282",
  "set_id": "cbse-10-math-full-01",
  "started_at": "2026-01-15T12:19:32.221Z"
}
```

---

#### Get Attempt Details
```
GET /api/attempts/:id
```
```json
{
  "success": true,
  "attempt": {
    "id": "94b9bea7-420f-4599-ae4d-0b4e64564282",
    "set_id": "cbse-10-math-full-01",
    "status": "in_progress",
    "started_at": "2026-01-15T12:19:32.221Z",
    "submitted_at": null,
    "total_marks_obtained": null,
    "total_marks_possible": 80,
    "answers": [
      { "question_id": "Q1", "answer_text": "B", "sub_part": null }
    ],
    "evaluations": []
  }
}
```

---

#### Save Answers
```
POST /api/attempts/:id/answers
Content-Type: application/json

{
  "answers": {
    "cbse-10-math-full-01-U2-B2A-Q01": "B",
    "cbse-10-math-full-01-U3-B3A-Q01": "C",
    "cbse-10-math-full-01-Q36_i": "Answer for case study part i"
  }
}
```
Response:
```json
{
  "success": true,
  "saved": 3
}
```

---

### Protected Endpoints (X-API-Key Required)

#### Get User's Test History
```
GET /api/user/:user_id/attempts?limit=20&offset=0
X-API-Key: your_api_key
```
Query params (optional):
- `limit` - Number of results (default: 20)
- `offset` - Pagination offset (default: 0)

Response:
```json
{
  "success": true,
  "user_id": "google_104567890123456789012",
  "total": 5,
  "limit": 20,
  "offset": 0,
  "attempts": [
    {
      "id": "94b9bea7-420f-4599-ae4d-0b4e64564282",
      "set_id": "cbse-10-math-full-01",
      "set_name": "CBSE Class 10 Mathematics - Full Mock Test 1",
      "exam_type": "CBSE",
      "grade": "10",
      "subject": "mathematics",
      "started_at": "2026-01-15T12:19:32.221Z",
      "submitted_at": "2026-01-15T12:45:00.000Z",
      "time_spent_seconds": 1528,
      "status": "submitted",
      "total_marks_obtained": 62,
      "total_marks_possible": 80,
      "percentage": 78,
      "mcq_correct": 18,
      "mcq_total": 20
    }
  ]
}
```

---

#### Submit Attempt for Grading
```
POST /api/attempts/:id/submit
X-API-Key: your_api_key
```
- Auto-grades MCQ questions
- Marks subjective questions as pending AI evaluation
- Returns initial score (MCQ only)

Response:
```json
{
  "success": true,
  "attempt_id": "94b9bea7-...",
  "status": "submitted",
  "submitted_at": "2026-01-15T12:30:00.000Z",
  "time_spent_seconds": 635,
  "results": {
    "mcq_correct": 18,
    "mcq_total": 20,
    "total_marks_obtained": 18,
    "total_marks_possible": 80,
    "percentage": 22,
    "subjective_pending": 16
  }
}
```

---

#### Mark Single Answer
```
POST /api/mark
Content-Type: application/json
X-API-Key: your_api_key

{
  "question": "Prove that sqrt(2) is irrational.",
  "student_answer": "Assume sqrt(2) = p/q where p,q are coprime...",
  "solution": {
    "steps": ["Assume sqrt(2) is rational...", "..."],
    "answer": "Proven by contradiction"
  },
  "marks": 3,
  "type": "SA"
}
```
Response:
```json
{
  "success": true,
  "evaluation": {
    "marks_awarded": 2,
    "max_marks": 3,
    "feedback": "Good approach but missing final step...",
    "step_analysis": [...],
    "confidence": 0.85
  }
}
```

---

#### Batch Mark (up to 10 questions)
```
POST /api/mark-batch
Content-Type: application/json
X-API-Key: your_api_key

{
  "questions": [
    {
      "question_id": "Q1",
      "question": "Find HCF of 12 and 18",
      "student_answer": "HCF = 6",
      "solution": { "steps": [...], "answer": "6" },
      "marks": 2,
      "type": "VSA"
    }
  ]
}
```
Response:
```json
{
  "success": true,
  "total_marks_awarded": 15,
  "total_max_marks": 20,
  "percentage": 75,
  "evaluations": [...]
}
```

---

#### Math Step-by-Step Solutions (Generic)
```
POST /api/math-steps
Content-Type: application/json
X-API-Key: your_api_key

{
  "operation": "integrate",
  "expression": "e^x*x^2",
  "variable": "x",
  "answer": "e^x*(x^2-2*x+2)",
  "bounds": { "lower": "0", "upper": "1" }
}
```

**Parameters:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `expression` | string | Yes | Math expression (max 200 chars, math characters only) |
| `answer` | string | Yes | Correct answer from CAS engine (anchors the AI response) |
| `operation` | string | No | One of: `integrate`, `differentiate`, `simplify`, `solve` (default: `integrate`) |
| `variable` | string | No | One of: `x`, `y`, `t`, `u`, `z`, `r`, `s`, `n` (default: `x`) |
| `bounds` | object | No | `{lower, upper}` for definite integrals (max 30 chars each) |

**Validation (servlet-side, acts as anti-spam):**
- `expression` and `answer` must match `[a-zA-Z0-9 +\-*/^().,|\!]` regex
- `operation` and `variable` must be from whitelists
- Length limits enforced on all fields
- Invalid requests are rejected before reaching OpenAI (no cost)

Response:
```json
{
  "success": true,
  "steps": [
    { "title": "Integration by Parts", "latex": "\\int e^x x^2 \\, dx = e^x x^2 - \\int e^x (2x) \\, dx" },
    { "title": "Second Integration by Parts", "latex": "\\int e^x (2x) \\, dx = 2x e^x - 2e^x" },
    { "title": "Combine Results", "latex": "e^x(x^2 - 2x + 2) + C" },
    { "title": "Evaluate Bounds", "latex": "\\int_0^1 e^x x^2 \\, dx = e(1-2+2) - (0-0+2) = e - 2" }
  ],
  "method": "Integration by Parts"
}
```

**Cost:** Uses `gpt-4o-mini` with max 500 tokens. Prompt requests 3-5 steps with abbreviated keys to minimize token usage.

---

#### Mark Full Exam
```
POST /api/mark-exam
Content-Type: application/json
X-API-Key: your_api_key

{
  "attempt_id": "optional-attempt-id",
  "answers": {
    "cbse-10-math-full-01-U3-B3A-Q02": "Student's answer for VSA...",
    "cbse-10-math-full-01-U2-B2A-Q02": "Student's answer for SA...",
    "cbse-10-math-full-01-U4-CS-Q36_i": "Answer for case study part i"
  },
  "questions": [
    // Full question objects from the exam JSON
  ]
}
```

**Parameters:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `attempt_id` | string | No | If provided, saves evaluations to DB and updates attempt totals |
| `answers` | object | Yes | Map of question_id → student's answer text |
| `questions` | array | Yes | Full question objects with solution for AI grading |

**Behavior:**
- **Without `attempt_id`**: Stateless mode - grades answers and returns results (no DB save)
- **With `attempt_id`**: Saves evaluations to `evaluations` table and updates `test_attempts` totals

Response:
```json
{
  "success": true,
  "total_marks_awarded": 45,
  "total_max_marks": 75,
  "percentage": 60,
  "questions_evaluated": 25,
  "evaluations": [
    {
      "question_id": "cbse-10-math-full-01-U3-B3A-Q02",
      "sub_part": null,
      "marks_awarded": 2,
      "max_marks": 2,
      "feedback": "Correct use of section formula and accurate calculation.",
      "confidence": 1,
      "error": false
    }
  ],
  "saved_to_db": true,
  "attempt_id": "abc123"
}
```

---

## Database Schema

### Tables
| Table | Description |
|-------|-------------|
| `chapters` | Course chapters by subject (e.g., CBSE Class 10 Math chapters) |
| `topics` | Topics within chapters |
| `exam_sets` | Practice question sets (full, chapter, topic tests) |
| `questions` | All exam questions with solutions |
| `users` | User accounts (optional) |
| `test_attempts` | When users take tests |
| `user_answers` | Answers given by users |
| `evaluations` | AI grading results |
| `purchases` | Track paid content |

### Test Types
- `full` - Full exam (e.g., 80 marks, 36 questions)
- `chapter` - Chapter-wise test
- `topic` - Topic-specific quiz

---

## Local Development

```bash
# Start dev server
wrangler dev

# Test endpoints
curl http://localhost:8787/api/sets | jq .
curl http://localhost:8787/api/chapters?exam_type=CBSE | jq .
```

---

## Cost Considerations

- Uses `gpt-4o-mini` by default (cheaper, fast)
- Can specify `"model": "gpt-4o"` for higher accuracy (more expensive)
- Batching reduces API calls
- Typical exam (25 subjective questions): ~5 API calls
- Math steps: ~500 tokens per request (3-5 steps), answer-anchored prompt keeps output concise

---

## Integration Example (JavaScript)

```javascript
const API_BASE = 'https://exam-marker.8gwifi.org';

// 1. Get available exam sets
const sets = await fetch(`${API_BASE}/api/sets?exam_type=CBSE&grade=10`).then(r => r.json());

// 2. Get questions for a set
const { questions } = await fetch(`${API_BASE}/api/sets/${setId}/questions`).then(r => r.json());

// 3. Start an attempt
const { attempt_id } = await fetch(`${API_BASE}/api/attempts`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ set_id: setId })
}).then(r => r.json());

// 4. Save answers as user progresses
await fetch(`${API_BASE}/api/attempts/${attempt_id}/answers`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ answers: { 'Q1': 'B', 'Q2': 'My answer...' } })
});

// 5. Submit for grading (requires API key)
const results = await fetch(`${API_BASE}/api/attempts/${attempt_id}/submit`, {
  method: 'POST',
  headers: { 'X-API-Key': 'your-api-key' }
}).then(r => r.json());

console.log(`Score: ${results.results.percentage}%`);
```

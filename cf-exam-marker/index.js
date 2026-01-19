// Cloudflare Worker - AI Exam Marker using OpenAI
// Evaluates student answers against marking schemes using GPT

const ALLOWED_ORIGINS = new Set([
  'http://localhost:8080',
  'https://8gwifi.org',
]);

function jsonResponse(body, init = {}) {
  return new Response(JSON.stringify(body), {
    headers: { 'content-type': 'application/json; charset=utf-8' },
    ...init,
  });
}

function withCors(resp, origin) {
  const h = new Headers(resp.headers);
  if (ALLOWED_ORIGINS.has(origin)) {
    h.set('Access-Control-Allow-Origin', origin);
    h.set('Access-Control-Allow-Methods', 'POST,OPTIONS');
    h.set('Access-Control-Allow-Headers', 'content-type,x-api-key');
    h.set('Access-Control-Max-Age', '86400');
    h.append('Vary', 'Origin');
  }
  return new Response(resp.body, { status: resp.status, headers: h });
}

/**
 * Build the prompt for OpenAI to evaluate a single answer
 */
function buildSinglePrompt(question, studentAnswer, solution, maxMarks, questionType) {
  return `You are an expert CBSE Mathematics examiner. Evaluate the student's answer strictly according to CBSE marking guidelines.

## Question (${maxMarks} marks, Type: ${questionType})
${question}

## Model Solution / Marking Scheme
${typeof solution === 'object' ? JSON.stringify(solution, null, 2) : solution}

## Student's Answer
${studentAnswer || '[No answer provided]'}

## Evaluation Guidelines
- Award marks based on correct steps shown, even if final answer is wrong
- For proofs: Check logical flow and correct use of theorems
- For calculations: Partial marks for correct intermediate steps
- For diagrams: Consider if the concept is correctly represented
- Be lenient with minor arithmetic errors if method is correct
- Award 0 marks if answer is completely wrong, irrelevant, or blank

## Note on Student Answer Format
Students write answers using Unicode math symbols. Interpret these correctly:
- x², y³, aⁿ = powers (x squared, y cubed, a to the n)
- √ = square root
- π = pi (3.14159...)
- θ, α, β = Greek letters (theta, alpha, beta)
- Δ = delta (change/triangle)
- ≤, ≥, ≠ = less/greater than or equal, not equal
- ± = plus or minus
- ∴ = therefore
- ∞ = infinity
- Fractions may be written as a/b

## Response Format (JSON only)
{
  "marks_awarded": <number between 0 and ${maxMarks}>,
  "feedback": "<brief constructive feedback>",
  "step_analysis": [
    {"step": "<step description>", "marks": <marks for this step>, "comment": "<optional comment>"}
  ],
  "confidence": <number between 0 and 1>
}

Respond with ONLY the JSON object, no other text.`;
}

/**
 * Build prompt for batch evaluation of multiple answers
 */
function buildBatchPrompt(questions) {
  const questionList = questions.map((q, i) => `
### Question ${i + 1} (ID: ${q.question_id}, ${q.marks} marks, Type: ${q.type})
**Question:** ${q.question}
**Model Solution:** ${typeof q.solution === 'object' ? JSON.stringify(q.solution) : q.solution}
**Student Answer:** ${q.student_answer || '[No answer provided]'}
`).join('\n');

  return `You are an expert CBSE Mathematics examiner. Evaluate ALL the following student answers strictly according to CBSE marking guidelines.

${questionList}

## Evaluation Guidelines
- Award marks based on correct steps shown, even if final answer is wrong
- For proofs: Check logical flow and correct use of theorems
- For calculations: Partial marks for correct intermediate steps
- Be lenient with minor arithmetic errors if method is correct
- Award 0 marks if answer is completely wrong, irrelevant, or blank

## Note on Student Answer Format
Students write answers using Unicode math symbols. Interpret these correctly:
- x², y³, aⁿ = powers (x squared, y cubed, a to the n)
- √ = square root, π = pi, θ/α/β = Greek letters
- Δ = delta, ≤/≥/≠ = comparisons, ± = plus/minus
- ∴ = therefore, ∞ = infinity, fractions as a/b

## Response Format (JSON array only)
[
  {
    "question_id": "<question_id>",
    "marks_awarded": <number>,
    "max_marks": <number>,
    "feedback": "<brief constructive feedback>",
    "confidence": <number between 0 and 1>
  }
]

Respond with ONLY the JSON array, no other text.`;
}

/**
 * Call OpenAI API
 */
async function callOpenAI(prompt, env, options = {}) {
  if (!env.OPENAI_API_KEY) {
    throw new Error('OpenAI API key not configured');
  }

  const model = options.model || 'gpt-4o-mini';
  const temperature = options.temperature ?? 0.1;
  const maxTokens = options.maxTokens || 1000;

  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${env.OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model,
      messages: [
        {
          role: 'system',
          content: 'You are a precise exam evaluator. Always respond with valid JSON only.'
        },
        {
          role: 'user',
          content: prompt
        }
      ],
      temperature,
      max_tokens: maxTokens,
      response_format: { type: 'json_object' }
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    console.error('OpenAI API error:', error);
    throw new Error(`OpenAI API error: ${response.status}`);
  }

  const data = await response.json();
  const content = data.choices?.[0]?.message?.content;

  if (!content) {
    throw new Error('No content in OpenAI response');
  }

  // Parse JSON response
  try {
    return JSON.parse(content);
  } catch (e) {
    console.error('Failed to parse OpenAI response:', content);
    throw new Error('Invalid JSON response from OpenAI');
  }
}

/**
 * Handle single answer marking
 * POST /api/mark
 */
async function handleMark(request, env) {
  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const { question, student_answer, solution, marks, type } = payload;

  if (!question) {
    return jsonResponse({ error: 'Missing required field: question' }, { status: 400 });
  }
  if (!solution) {
    return jsonResponse({ error: 'Missing required field: solution' }, { status: 400 });
  }
  if (!marks || marks < 1) {
    return jsonResponse({ error: 'Missing or invalid field: marks' }, { status: 400 });
  }

  try {
    const prompt = buildSinglePrompt(
      question,
      student_answer,
      solution,
      marks,
      type || 'Unknown'
    );

    const result = await callOpenAI(prompt, env, {
      model: payload.model || 'gpt-4o-mini',
      maxTokens: 1000
    });

    return jsonResponse({
      success: true,
      evaluation: {
        marks_awarded: Math.min(Math.max(0, result.marks_awarded || 0), marks),
        max_marks: marks,
        feedback: result.feedback || '',
        step_analysis: result.step_analysis || [],
        confidence: result.confidence || 0
      }
    });
  } catch (err) {
    console.error('Mark error:', err);
    return jsonResponse({ error: 'Failed to evaluate answer', details: err.message }, { status: 500 });
  }
}

/**
 * Handle batch marking of multiple answers
 * POST /api/mark-batch
 */
async function handleMarkBatch(request, env) {
  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const { questions } = payload;

  if (!questions || !Array.isArray(questions) || questions.length === 0) {
    return jsonResponse({ error: 'Missing or empty questions array' }, { status: 400 });
  }

  if (questions.length > 10) {
    return jsonResponse({ error: 'Maximum 10 questions per batch' }, { status: 400 });
  }

  // Validate each question
  for (let i = 0; i < questions.length; i++) {
    const q = questions[i];
    if (!q.question_id || !q.question || !q.solution || !q.marks) {
      return jsonResponse({
        error: `Question ${i + 1} missing required fields (question_id, question, solution, marks)`
      }, { status: 400 });
    }
  }

  try {
    const prompt = buildBatchPrompt(questions);

    const results = await callOpenAI(prompt, env, {
      model: payload.model || 'gpt-4o-mini',
      maxTokens: 2000
    });

    // Handle both array and object responses
    const evaluations = Array.isArray(results) ? results : (results.evaluations || [results]);

    // Ensure marks are within bounds
    const processedResults = evaluations.map(r => ({
      question_id: r.question_id,
      marks_awarded: Math.min(Math.max(0, r.marks_awarded || 0), r.max_marks || 0),
      max_marks: r.max_marks,
      feedback: r.feedback || '',
      confidence: r.confidence || 0
    }));

    // Calculate totals
    const totalAwarded = processedResults.reduce((sum, r) => sum + r.marks_awarded, 0);
    const totalMax = processedResults.reduce((sum, r) => sum + r.max_marks, 0);

    return jsonResponse({
      success: true,
      total_marks_awarded: totalAwarded,
      total_max_marks: totalMax,
      percentage: totalMax > 0 ? Math.round((totalAwarded / totalMax) * 100) : 0,
      evaluations: processedResults
    });
  } catch (err) {
    console.error('Batch mark error:', err);
    return jsonResponse({ error: 'Failed to evaluate answers', details: err.message }, { status: 500 });
  }
}

/**
 * Handle marking of a complete exam submission
 * POST /api/mark-exam
 * Expects: { answers: { question_id: answer_text }, questions: [...] }
 */
async function handleMarkExam(request, env) {
  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const { attempt_id, answers, questions } = payload;

  if (!answers || typeof answers !== 'object') {
    return jsonResponse({ error: 'Missing answers object' }, { status: 400 });
  }

  if (!questions || !Array.isArray(questions)) {
    return jsonResponse({ error: 'Missing questions array' }, { status: 400 });
  }

  // Filter to only subjective questions (VSA, SA, LA, CaseStudy sub-questions)
  const subjectiveTypes = ['VSA', 'SA', 'LA'];
  const toEvaluate = [];

  console.log('handleMarkExam - answers keys:', Object.keys(answers));
  console.log('handleMarkExam - questions count:', questions.length);

  for (const q of questions) {
    // Get question_id - prefer full ID (q.id) since answers use full IDs
    const questionId = q.id || q.question_id;
    console.log(`Question: id=${q.id}, question_id=${q.question_id}, type=${q.type}, has_sub_questions=${!!q.sub_questions}`);

    // Handle regular subjective questions
    if (subjectiveTypes.includes(q.type) && answers[questionId]) {
      toEvaluate.push({
        question_id: questionId,
        type: q.type,
        marks: q.marks,
        question: q.question?.text_plain || q.question?.text_latex || '',
        solution: q.solution,
        student_answer: answers[questionId]
      });
    }

    // Handle CaseStudy sub-questions
    if (q.type === 'CaseStudy' && q.sub_questions) {
      console.log(`CaseStudy ${questionId} has ${q.sub_questions.length} sub_questions`);
      for (const sub of q.sub_questions) {
        const subId = `${questionId}_${sub.part}`;
        console.log(`  Checking subId=${subId}, exists in answers=${!!answers[subId]}`);
        if (answers[subId]) {
          toEvaluate.push({
            question_id: subId,
            parent_question_id: questionId,
            sub_part: sub.part,
            type: 'CaseStudy-Part',
            marks: sub.marks,
            question: `${q.case_study?.context_plain || ''}\n\nPart ${sub.part}: ${sub.question?.text_plain || ''}`,
            solution: sub.solution,
            student_answer: answers[subId]
          });
        }
      }
    }
  }

  console.log(`handleMarkExam - toEvaluate count: ${toEvaluate.length}`);

  if (toEvaluate.length === 0) {
    console.log('handleMarkExam - returning early, no subjective answers to evaluate');
    return jsonResponse({
      success: true,
      message: 'No subjective answers to evaluate',
      evaluations: [],
      saved_to_db: false
    });
  }

  // Process in batches of 5
  const batchSize = 5;
  const allEvaluations = [];

  for (let i = 0; i < toEvaluate.length; i += batchSize) {
    const batch = toEvaluate.slice(i, i + batchSize);

    try {
      const prompt = buildBatchPrompt(batch);
      const results = await callOpenAI(prompt, env, {
        model: payload.model || 'gpt-4o-mini',
        maxTokens: 2000
      });

      // Extract evaluations array - handle various response formats from OpenAI
      let evaluations;
      if (Array.isArray(results)) {
        evaluations = results;
      } else if (results.evaluations && Array.isArray(results.evaluations)) {
        evaluations = results.evaluations;
      } else if (results.results && Array.isArray(results.results)) {
        evaluations = results.results;
      } else if (results.data && Array.isArray(results.data)) {
        evaluations = results.data;
      } else {
        // Try to find any array property in the response
        const arrayProp = Object.values(results).find(v => Array.isArray(v));
        evaluations = arrayProp || [results];
      }
      console.log(`Batch ${i / batchSize + 1}: Got ${evaluations.length} evaluations from AI`);

      // Map evaluations back to original questions by index if question_id doesn't match
      const mappedEvaluations = evaluations.map((e, idx) => {
        // If AI returned correct question_id, use it
        if (e.question_id && batch.some(q => q.question_id === e.question_id)) {
          return e;
        }
        // Otherwise, map by index
        const originalQ = batch[idx];
        if (originalQ) {
          console.log(`  Mapping evaluation ${idx} to question_id: ${originalQ.question_id}`);
          return { ...e, question_id: originalQ.question_id };
        }
        return e;
      });

      allEvaluations.push(...mappedEvaluations);
    } catch (err) {
      console.error(`Batch ${i / batchSize + 1} error:`, err);
      // Continue with other batches, mark failed ones as 0
      for (const q of batch) {
        allEvaluations.push({
          question_id: q.question_id,
          marks_awarded: 0,
          max_marks: q.marks,
          feedback: 'Evaluation failed',
          confidence: 0,
          error: true
        });
      }
    }
  }

  // Process results - match evaluations with original questions
  const processedResults = allEvaluations.map(r => {
    const original = toEvaluate.find(q => q.question_id === r.question_id);
    const maxMarks = original?.marks || r.max_marks || 0;

    // Ensure question_id is never undefined
    let questionId = original?.parent_question_id || r.question_id;
    if (!questionId) {
      console.warn('Warning: evaluation has no question_id, skipping', r);
      questionId = 'unknown';
    }

    return {
      question_id: questionId,
      sub_part: original?.sub_part || null,
      marks_awarded: Math.min(Math.max(0, r.marks_awarded || 0), maxMarks),
      max_marks: maxMarks,
      feedback: r.feedback || '',
      confidence: r.confidence || 0,
      error: r.error || false
    };
  }).filter(r => r.question_id !== 'unknown');

  const totalAwarded = processedResults.reduce((sum, r) => sum + r.marks_awarded, 0);
  const totalMax = processedResults.reduce((sum, r) => sum + r.max_marks, 0);

  // If attempt_id is provided, save evaluations to database
  let savedToDb = false;
  if (attempt_id && env.DB) {
    try {
      // Delete existing evaluations for these questions, then insert new ones
      const statements = [];

      for (const e of processedResults) {
        // Delete existing evaluation (handles both NULL and non-NULL sub_part)
        if (e.sub_part) {
          statements.push(
            env.DB.prepare(
              'DELETE FROM evaluations WHERE attempt_id = ? AND question_id = ? AND sub_part = ?'
            ).bind(attempt_id, e.question_id, e.sub_part)
          );
        } else {
          statements.push(
            env.DB.prepare(
              'DELETE FROM evaluations WHERE attempt_id = ? AND question_id = ? AND sub_part IS NULL'
            ).bind(attempt_id, e.question_id)
          );
        }

        // Insert new evaluation
        statements.push(
          env.DB.prepare(
            'INSERT INTO evaluations (attempt_id, question_id, sub_part, marks_awarded, max_marks, feedback, confidence) VALUES (?, ?, ?, ?, ?, ?, ?)'
          ).bind(
            attempt_id,
            e.question_id,
            e.sub_part,
            e.marks_awarded,
            e.max_marks,
            e.feedback,
            e.confidence
          )
        );
      }

      if (statements.length > 0) {
        await env.DB.batch(statements);
      }

      // Update attempt totals - recalculate from all evaluations
      const evalTotals = await env.DB.prepare(`
        SELECT
          SUM(marks_awarded) as total_obtained,
          SUM(max_marks) as total_possible
        FROM evaluations
        WHERE attempt_id = ?
      `).bind(attempt_id).first();

      const totalObtained = evalTotals?.total_obtained || 0;
      const totalPossible = evalTotals?.total_possible || 0;
      const percentage = totalPossible > 0 ? Math.round((totalObtained / totalPossible) * 100) : 0;

      // Update attempt with evaluation totals (don't change status - let submit handler do that)
      await env.DB.prepare(`
        UPDATE test_attempts
        SET
          subjective_marks = ?,
          total_marks_obtained = ?,
          percentage = ?
        WHERE id = ?
      `).bind(totalAwarded, totalObtained, percentage, attempt_id).run();

      savedToDb = true;
      console.log(`Saved ${processedResults.length} evaluations for attempt ${attempt_id}`);
    } catch (dbError) {
      console.error('Failed to save evaluations to DB:', dbError);
      // Continue - still return the evaluations even if DB save failed
    }
  }

  return jsonResponse({
    success: true,
    total_marks_awarded: totalAwarded,
    total_max_marks: totalMax,
    percentage: totalMax > 0 ? Math.round((totalAwarded / totalMax) * 100) : 0,
    questions_evaluated: processedResults.length,
    evaluations: processedResults,
    saved_to_db: savedToDb,
    attempt_id: attempt_id || null
  });
}

/**
 * Health check endpoint
 */
async function handleHealth(env) {
  const hasApiKey = !!env.OPENAI_API_KEY;
  return jsonResponse({
    status: 'ok',
    service: 'cf-exam-marker',
    openai_configured: hasApiKey,
    timestamp: new Date().toISOString()
  });
}

function requireApiKey(request, env) {
  if (!env.API_KEY) {
    return jsonResponse({ error: 'API key not configured' }, { status: 500 });
  }

  const provided = request.headers.get('x-api-key');
  if (!provided || provided !== env.API_KEY) {
    return jsonResponse({ error: 'Unauthorized' }, { status: 401 });
  }

  return null;
}

// Generate UUID
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// =============================================
// D1 DATABASE ENDPOINTS
// =============================================

/**
 * GET /api/chapters
 * List chapters with optional filters
 */
async function handleGetChapters(request, env) {
  const url = new URL(request.url);
  const examType = url.searchParams.get('exam_type');
  const grade = url.searchParams.get('grade');
  const subject = url.searchParams.get('subject');

  let query = 'SELECT * FROM chapters WHERE is_active = 1';
  const params = [];

  if (examType) {
    query += ' AND exam_type = ?';
    params.push(examType);
  }
  if (grade) {
    query += ' AND grade = ?';
    params.push(grade);
  }
  if (subject) {
    query += ' AND subject = ?';
    params.push(subject);
  }

  query += ' ORDER BY sort_order';

  const result = await env.DB.prepare(query).bind(...params).all();

  return jsonResponse({
    success: true,
    chapters: result.results
  });
}

/**
 * GET /api/chapters/:id/topics
 * List topics for a chapter
 */
async function handleGetTopics(chapterId, env) {
  const result = await env.DB.prepare(
    'SELECT * FROM topics WHERE chapter_id = ? AND is_active = 1 ORDER BY sort_order'
  ).bind(chapterId).all();

  return jsonResponse({
    success: true,
    topics: result.results
  });
}

/**
 * GET /api/sets
 * List exam sets with filters
 */
async function handleGetSets(request, env) {
  const url = new URL(request.url);
  const examType = url.searchParams.get('exam_type');
  const grade = url.searchParams.get('grade');
  const subject = url.searchParams.get('subject');
  const testType = url.searchParams.get('test_type');
  const chapterId = url.searchParams.get('chapter_id');
  const topicId = url.searchParams.get('topic_id');

  let query = 'SELECT id, exam_type, grade, subject, test_type, chapter_id, topic_id, name, description, total_questions, total_marks, duration_minutes, is_free, price_cents FROM exam_sets WHERE is_active = 1';
  const params = [];

  if (examType) {
    query += ' AND exam_type = ?';
    params.push(examType);
  }
  if (grade) {
    query += ' AND grade = ?';
    params.push(grade);
  }
  if (subject) {
    query += ' AND subject = ?';
    params.push(subject);
  }
  if (testType) {
    query += ' AND test_type = ?';
    params.push(testType);
  }
  if (chapterId) {
    query += ' AND chapter_id = ?';
    params.push(chapterId);
  }
  if (topicId) {
    query += ' AND topic_id = ?';
    params.push(topicId);
  }

  query += ' ORDER BY created_at DESC';

  const result = await env.DB.prepare(query).bind(...params).all();

  return jsonResponse({
    success: true,
    sets: result.results
  });
}

/**
 * GET /api/sets/:id
 * Get single set details
 */
async function handleGetSet(setId, env) {
  const result = await env.DB.prepare(
    'SELECT * FROM exam_sets WHERE id = ? AND is_active = 1'
  ).bind(setId).first();

  if (!result) {
    return jsonResponse({ error: 'Set not found' }, { status: 404 });
  }

  return jsonResponse({
    success: true,
    set: result
  });
}

/**
 * GET /api/sets/:id/questions
 * Get questions for a set
 */
async function handleGetQuestions(setId, env) {
  // First check if set exists and is accessible
  const set = await env.DB.prepare(
    'SELECT id, is_free FROM exam_sets WHERE id = ? AND is_active = 1'
  ).bind(setId).first();

  if (!set) {
    return jsonResponse({ error: 'Set not found' }, { status: 404 });
  }

  // Get questions
  const result = await env.DB.prepare(
    'SELECT id, type, marks, difficulty, question_text, question_latex, has_diagram, diagram_svg, options_json, solution_json, case_study_json, sort_order FROM questions WHERE set_id = ? ORDER BY sort_order'
  ).bind(setId).all();

  // Parse JSON fields and transform to API format
  const questions = result.results.map(q => {
    // Parse JSON fields
    let options = q.options_json ? JSON.parse(q.options_json) : null;
    const solution = q.solution_json ? JSON.parse(q.solution_json) : null;
    let case_study = q.case_study_json ? JSON.parse(q.case_study_json) : null;
    
    // Transform case_study to match frontend format
    // Import may have stored: {title, context, sub_questions} or {title, context_plain, has_diagram, visual_diagram, sub_questions}
    // Frontend expects: {title, context_plain, has_diagram, visual_diagram} and sub_questions at question level
    if (case_study) {
      // Ensure context_plain exists (may have been stored as "context")
      if (case_study.context && !case_study.context_plain) {
        case_study.context_plain = case_study.context;
      }
      // Ensure has_diagram is boolean (convert from 0/1 if needed)
      if (case_study.has_diagram === undefined) {
        case_study.has_diagram = false;
      } else {
        // Convert 0/1 to boolean
        case_study.has_diagram = case_study.has_diagram === 1 || case_study.has_diagram === true;
      }
      // Ensure visual_diagram is properly structured if it exists
      if (case_study.visual_diagram) {
        // visual_diagram should already be an object with svg_code, but ensure it's structured correctly
        if (typeof case_study.visual_diagram === 'string') {
          // If it's a string, convert to object
          case_study.visual_diagram = {
            diagram_type: 'geometric',
            svg_code: case_study.visual_diagram,
            description: null
          };
        } else if (case_study.visual_diagram && typeof case_study.visual_diagram === 'object') {
          // Ensure it has all required properties
          case_study.visual_diagram = {
            diagram_type: case_study.visual_diagram.diagram_type || 'geometric',
            svg_code: case_study.visual_diagram.svg_code || case_study.visual_diagram.svg || '',
            description: case_study.visual_diagram.description || null
          };
        }
      }
    }

    // Transform options from old format to new format
    // Old format: {option_id: "A", text_plain: "...", is_correct: true}
    // New format: {id: "A", text: "...", is_correct: true}
    if (options && Array.isArray(options)) {
      options = options.map(opt => ({
        id: opt.id || opt.option_id,  // Support both formats
        text: opt.text || opt.text_plain || opt.text_latex || '',  // Support all text formats
        is_correct: opt.is_correct || false
      }));
    }

    // Transform diagram from database format to frontend format
    // Database: has_diagram (0/1), diagram_svg (string)
    // Frontend expects: has_diagram (boolean), visual_diagram (object with svg_code)
    let visualDiagram = null;
    const hasDiagram = q.has_diagram === 1 || q.has_diagram === true;
    if (hasDiagram && q.diagram_svg) {
      visualDiagram = {
        diagram_type: 'geometric',  // Default, can be enhanced if stored separately
        svg_code: q.diagram_svg,
        description: null  // Description not stored separately in DB, can be added if needed
      };
    }

    // Remove JSON fields from response (keep only parsed objects)
    const { options_json, solution_json, case_study_json, diagram_svg, question_text, question_latex, has_diagram, ...rest } = q;

    // Transform to match old JSON format structure for frontend compatibility
    // Old format nests question text and diagram in a "question" object
    
    // Build question object (nested structure like old JSON)
    const questionObj = {
      text_plain: question_text || '',
      text_latex: question_latex || null,
      has_diagram: hasDiagram,  // Convert 0/1 to boolean
      visual_diagram: visualDiagram  // Object with svg_code and description
    };

    // For CaseStudy questions, extract sub_questions from case_study and put at question level
    let sub_questions = null;
    if (case_study && case_study.sub_questions) {
      sub_questions = case_study.sub_questions;
      // IMPORTANT: Preserve visual_diagram BEFORE extracting sub_questions
      // Store it separately so it doesn't get lost during destructuring
      const preservedVisualDiagram = case_study.visual_diagram;
      const preservedHasDiagram = case_study.has_diagram;
      
      // Remove sub_questions from case_study object (keep it separate)
      const { sub_questions: _, ...caseStudyWithoutSub } = case_study;
      case_study = caseStudyWithoutSub;
      
      // Restore visual_diagram and has_diagram (they should be preserved, but ensure they're set)
      // Convert has_diagram to boolean
      if (preservedHasDiagram !== undefined) {
        case_study.has_diagram = preservedHasDiagram === 1 || preservedHasDiagram === true;
      }
      
      // Restore and structure visual_diagram
      if (preservedVisualDiagram) {
        // Ensure visual_diagram is properly structured
        if (typeof preservedVisualDiagram === 'string') {
          case_study.visual_diagram = {
            diagram_type: 'geometric',
            svg_code: preservedVisualDiagram,
            description: null
          };
        } else if (preservedVisualDiagram && typeof preservedVisualDiagram === 'object') {
          // Already an object, ensure it has all required properties
          const svgCode = preservedVisualDiagram.svg_code || preservedVisualDiagram.svg || '';
          if (svgCode) {
            case_study.visual_diagram = {
              diagram_type: preservedVisualDiagram.diagram_type || 'geometric',
              svg_code: svgCode,
              description: preservedVisualDiagram.description || null
            };
          } else {
            // No SVG code found, set to null
            case_study.visual_diagram = null;
            case_study.has_diagram = false;
          }
        }
      } else if (preservedHasDiagram && visualDiagram && visualDiagram.svg_code) {
        // Fallback: Use question-level diagram if case study doesn't have its own
        case_study.visual_diagram = visualDiagram;
      } else if (preservedHasDiagram && !preservedVisualDiagram) {
        // has_diagram is true but no visual_diagram found, set has_diagram to false
        case_study.has_diagram = false;
      }
    }

    // Extract question_id from id (remove set prefix)
    // id format: "cbse-10-math-full-01-U2-B2A-Q01"
    // question_id should be: "U2-B2A-Q01"
    let question_id = rest.id;
    if (rest.id && rest.id.includes('-')) {
      const parts = rest.id.split('-');
      // Find the part that starts with "U" (question ID pattern)
      const questionIdIndex = parts.findIndex(p => p.startsWith('U'));
      if (questionIdIndex >= 0) {
        question_id = parts.slice(questionIdIndex).join('-');
      }
    }

    return {
      ...rest,
      question_id: question_id,  // Add question_id for compatibility (matches old JSON)
      question: questionObj,  // Nested question object (matches old JSON format exactly)
      options,
      solution,
      case_study,  // case_study without sub_questions
      sub_questions  // sub_questions at question level (for frontend compatibility)
    };
  });

  return jsonResponse({
    success: true,
    set_id: setId,
    total: questions.length,
    questions
  });
}

/**
 * POST /api/attempts
 * Start a new test attempt
 */
async function handleCreateAttempt(request, env) {
  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const { set_id, user_id } = payload;

  if (!set_id) {
    return jsonResponse({ error: 'Missing required field: set_id' }, { status: 400 });
  }

  // Verify set exists
  const set = await env.DB.prepare(
    'SELECT id, total_marks FROM exam_sets WHERE id = ? AND is_active = 1'
  ).bind(set_id).first();

  if (!set) {
    return jsonResponse({ error: 'Set not found' }, { status: 404 });
  }

  // If user_id is provided, ensure user exists in database (create if not exists)
  let finalUserId = null;
  if (user_id && user_id.trim() !== '') {
    // Check if user exists
    const existingUser = await env.DB.prepare(
      'SELECT id FROM users WHERE id = ?'
    ).bind(user_id).first();

    if (!existingUser) {
      // Create user if doesn't exist
      // User ID from Google OAuth is typically the "sub" claim (e.g., "104567890123456789012")
      // We'll store it as-is, and determine auth provider from the format
      const email = user_id.includes('@') ? user_id : null;
      // Google sub is numeric, if it starts with numbers and looks like a Google sub, use 'google'
      // Otherwise, if it contains @, it might be an email, otherwise unknown
      let authProvider = 'unknown';
      let authId = user_id;
      
      if (user_id.includes('@')) {
        // Looks like an email
        authProvider = 'email';
        authId = user_id;
      } else if (/^\d+$/.test(user_id)) {
        // Numeric ID, likely Google sub
        authProvider = 'google';
        authId = user_id;
      } else if (user_id.startsWith('google_')) {
        // Prefixed with google_
        authProvider = 'google';
        authId = user_id.replace('google_', '');
      }
      
      try {
        await env.DB.prepare(
          'INSERT INTO users (id, email, auth_provider, auth_id, created_at) VALUES (?, ?, ?, ?, ?)'
        ).bind(user_id, email, authProvider, authId, new Date().toISOString()).run();
        finalUserId = user_id;
        console.log(`Created new user: ${user_id} (${authProvider})`);
      } catch (error) {
        // If user creation fails (e.g., duplicate key), user might have been created concurrently
        // Check again if user exists now
        const userCheck = await env.DB.prepare(
          'SELECT id FROM users WHERE id = ?'
        ).bind(user_id).first();
        if (userCheck) {
          finalUserId = user_id;
          console.log(`User ${user_id} exists (created concurrently)`);
        } else {
          // If still doesn't exist, log error and continue with null user_id
          console.error('Failed to create user:', error);
          finalUserId = null;
        }
      }
    } else {
      finalUserId = user_id;
    }
  }

  const attemptId = generateUUID();
  const now = new Date().toISOString();

  await env.DB.prepare(
    'INSERT INTO test_attempts (id, user_id, set_id, started_at, status, total_marks_possible) VALUES (?, ?, ?, ?, ?, ?)'
  ).bind(attemptId, finalUserId, set_id, now, 'in_progress', set.total_marks).run();

  return jsonResponse({
    success: true,
    attempt_id: attemptId,
    set_id: set_id,
    started_at: now
  });
}

/**
 * GET /api/attempts/:id
 * Get attempt details and results
 */
async function handleGetAttempt(attemptId, env) {
  const attempt = await env.DB.prepare(
    'SELECT * FROM test_attempts WHERE id = ?'
  ).bind(attemptId).first();

  if (!attempt) {
    return jsonResponse({ error: 'Attempt not found' }, { status: 404 });
  }

  // Get answers
  const answers = await env.DB.prepare(
    'SELECT question_id, answer_text, sub_part FROM user_answers WHERE attempt_id = ?'
  ).bind(attemptId).all();

  // Get evaluations if submitted or evaluated
  let evaluations = [];
  if (attempt.status === 'submitted' || attempt.status === 'evaluated') {
    const evalResult = await env.DB.prepare(
      'SELECT question_id, sub_part, marks_awarded, max_marks, feedback, confidence FROM evaluations WHERE attempt_id = ?'
    ).bind(attemptId).all();
    evaluations = evalResult.results;
  }

  return jsonResponse({
    success: true,
    attempt: {
      ...attempt,
      answers: answers.results,
      evaluations
    }
  });
}

/**
 * POST /api/attempts/:id/answers
 * Save answers for an attempt
 */
async function handleSaveAnswers(attemptId, request, env) {
  // Verify attempt exists and is in progress
  const attempt = await env.DB.prepare(
    'SELECT id, status FROM test_attempts WHERE id = ?'
  ).bind(attemptId).first();

  if (!attempt) {
    return jsonResponse({ error: 'Attempt not found' }, { status: 404 });
  }

  if (attempt.status !== 'in_progress') {
    return jsonResponse({ error: 'Attempt already submitted' }, { status: 400 });
  }

  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonResponse({ error: 'Invalid JSON body' }, { status: 400 });
  }

  const { answers } = payload;

  if (!answers || typeof answers !== 'object') {
    return jsonResponse({ error: 'Missing answers object' }, { status: 400 });
  }

  const now = new Date().toISOString();
  let savedCount = 0;

  // Use batch for efficiency
  const statements = [];

  for (const [questionId, answerValue] of Object.entries(answers)) {
    // Validate questionId - reject undefined, null, or empty keys
    if (!questionId || questionId === 'undefined' || questionId === 'null' || questionId.trim() === '') {
      console.warn(`Skipping invalid questionId: ${questionId}`);
      continue;
    }

    // Handle CaseStudy questions with nested objects like {"i": "answer1", "ii": "answer2"}
    if (typeof answerValue === 'object' && answerValue !== null) {
      // Flatten nested object - save each sub-part separately
      for (const [part, partAnswer] of Object.entries(answerValue)) {
        if (!part || part === 'undefined' || part === 'null') continue;

        const answerText = partAnswer != null ? String(partAnswer) : '';
        if (answerText.trim() === '') continue;

        statements.push(
          env.DB.prepare(
            'INSERT OR REPLACE INTO user_answers (attempt_id, question_id, answer_text, sub_part, answered_at) VALUES (?, ?, ?, ?, ?)'
          ).bind(attemptId, questionId, answerText, part, now)
        );
        savedCount++;
      }
      continue;
    }

    // Handle regular answers (strings)
    const answerText = answerValue != null ? String(answerValue) : '';

    // Handle sub-parts (e.g., "Q36_i" -> question_id: "Q36", sub_part: "i")
    let qId = questionId;
    let subPart = null;

    const partMatch = questionId.match(/^(.+)_([ivx]+)$/i);
    if (partMatch) {
      qId = partMatch[1];
      subPart = partMatch[2];
    }

    // Additional validation: ensure qId is not empty after parsing
    if (!qId || qId.trim() === '') {
      console.warn(`Invalid question ID after parsing: ${questionId}`);
      continue;
    }

    statements.push(
      env.DB.prepare(
        'INSERT OR REPLACE INTO user_answers (attempt_id, question_id, answer_text, sub_part, answered_at) VALUES (?, ?, ?, ?, ?)'
      ).bind(attemptId, qId, answerText, subPart, now)
    );
    savedCount++;
  }

  if (statements.length > 0) {
    await env.DB.batch(statements);
  }

  return jsonResponse({
    success: true,
    saved: savedCount
  });
}

/**
 * POST /api/attempts/:id/submit
 * Submit attempt for grading (triggers AI marking)
 */
async function handleSubmitAttempt(attemptId, request, env) {
  // Verify attempt exists and is in progress
  const attempt = await env.DB.prepare(
    'SELECT id, set_id, status, started_at FROM test_attempts WHERE id = ?'
  ).bind(attemptId).first();

  if (!attempt) {
    return jsonResponse({ error: 'Attempt not found' }, { status: 404 });
  }

  if (attempt.status !== 'in_progress') {
    return jsonResponse({ error: 'Attempt already submitted' }, { status: 400 });
  }

  // Get all questions for this set
  const questionsResult = await env.DB.prepare(
    'SELECT id, type, marks, question_text, solution_json, case_study_json FROM questions WHERE set_id = ?'
  ).bind(attempt.set_id).all();

  // Get all answers for this attempt
  const answersResult = await env.DB.prepare(
    'SELECT question_id, answer_text, sub_part FROM user_answers WHERE attempt_id = ?'
  ).bind(attemptId).all();

  // Build answers map
  const answersMap = {};
  for (const ans of answersResult.results) {
    const key = ans.sub_part ? `${ans.question_id}_${ans.sub_part}` : ans.question_id;
    answersMap[key] = ans.answer_text;
  }

  const now = new Date();
  const nowISO = now.toISOString();
  
  // Parse started_at - handle both ISO string and SQLite datetime format
  let startedAtDate;
  if (attempt.started_at instanceof Date) {
    startedAtDate = attempt.started_at;
  } else if (typeof attempt.started_at === 'string') {
    // Try parsing as ISO string first (format: 2026-01-16T21:46:29.691Z)
    startedAtDate = new Date(attempt.started_at);
    
    // If parsing failed, try SQLite datetime format (YYYY-MM-DD HH:MM:SS or YYYY-MM-DD HH:MM:SS.SSS)
    if (isNaN(startedAtDate.getTime())) {
      // SQLite format: "2026-01-16 21:46:29" or "2026-01-16 21:46:29.123"
      const sqliteFormat = attempt.started_at.replace(' ', 'T');
      // Add Z if no timezone info (check if ends with Z, +, or timezone offset)
      const hasTimezone = sqliteFormat.endsWith('Z') || 
                         /[+-]\d{2}:?\d{2}$/.test(sqliteFormat);
      startedAtDate = new Date(sqliteFormat + (hasTimezone ? '' : 'Z'));
    }
    
    // If still invalid, log warning and use current time
    if (isNaN(startedAtDate.getTime())) {
      console.warn('Invalid started_at format, using current time:', attempt.started_at);
      startedAtDate = now;
    }
  } else {
    // Fallback to current time if parsing fails
    console.warn('Invalid started_at type:', typeof attempt.started_at, attempt.started_at);
    startedAtDate = now;
  }
  
  // Calculate time spent in seconds (ensure non-negative)
  const timeSpent = Math.max(0, Math.floor((now - startedAtDate) / 1000));
  
  // Log for debugging (only if time is suspiciously low or high)
  if (timeSpent < 1 || timeSpent > 86400) { // Less than 1 second or more than 24 hours
    console.log('Time calculation debug:', {
      started_at_raw: attempt.started_at,
      started_at_type: typeof attempt.started_at,
      started_at_parsed: startedAtDate.toISOString(),
      now: nowISO,
      time_spent_seconds: timeSpent,
      time_spent_minutes: Math.floor(timeSpent / 60)
    });
  }

  // Separate MCQ and subjective questions
  let mcqCorrect = 0;
  let mcqTotal = 0;
  let subjectiveMarks = 0;
  let subjectiveTotal = 0;
  const evaluations = [];

  for (const q of questionsResult.results) {
    const solution = q.solution_json ? JSON.parse(q.solution_json) : {};

    if (q.type === 'MCQ' || q.type === 'Assertion-Reason') {
      mcqTotal++;
      const userAnswer = answersMap[q.id];
      const correctOption = solution.answer?.correct_option;

      if (userAnswer && userAnswer === correctOption) {
        mcqCorrect++;
        evaluations.push({
          question_id: q.id,
          marks_awarded: q.marks,
          max_marks: q.marks,
          feedback: 'Correct',
          confidence: 1.0
        });
      } else {
        evaluations.push({
          question_id: q.id,
          marks_awarded: 0,
          max_marks: q.marks,
          feedback: userAnswer ? `Incorrect. Correct answer: ${correctOption}` : 'Not answered',
          confidence: 1.0
        });
      }
    } else if (q.type === 'CaseStudy') {
      // Handle case study sub-questions
      const caseStudy = q.case_study_json ? JSON.parse(q.case_study_json) : {};
      const subQuestions = caseStudy.sub_questions || [];

      for (const sub of subQuestions) {
        subjectiveTotal += sub.marks;
        const ansKey = `${q.id}_${sub.part}`;
        // These will be graded by AI later or marked as pending
        evaluations.push({
          question_id: q.id,
          sub_part: sub.part,
          marks_awarded: 0, // AI will update this
          max_marks: sub.marks,
          feedback: 'Pending AI evaluation',
          confidence: 0,
          needs_ai: true
        });
      }
    } else {
      // VSA, SA, LA - need AI grading
      subjectiveTotal += q.marks;
      evaluations.push({
        question_id: q.id,
        marks_awarded: 0, // AI will update this
        max_marks: q.marks,
        feedback: 'Pending AI evaluation',
        confidence: 0,
        needs_ai: true
      });
    }
  }

  // Calculate initial score (MCQ only)
  const mcqMarks = mcqCorrect; // Each MCQ is 1 mark
  const totalObtained = mcqMarks + subjectiveMarks;
  const totalPossible = mcqTotal + subjectiveTotal;
  const percentage = totalPossible > 0 ? Math.round((totalObtained / totalPossible) * 100) : 0;

  // Update attempt status
  // Use nowISO (string) instead of now (Date object) for D1 compatibility
  await env.DB.prepare(
    `UPDATE test_attempts SET
      status = 'submitted',
      submitted_at = ?,
      time_spent_seconds = ?,
      total_marks_obtained = ?,
      total_marks_possible = ?,
      percentage = ?,
      mcq_correct = ?,
      mcq_total = ?,
      subjective_marks = ?,
      subjective_total = ?
    WHERE id = ?`
  ).bind(nowISO, timeSpent, totalObtained, totalPossible, percentage, mcqCorrect, mcqTotal, subjectiveMarks, subjectiveTotal, attemptId).run();

  // Store evaluations - use INSERT OR IGNORE to not overwrite existing AI evaluations
  // (markExam may have already saved real evaluations before submitAttempt is called)
  const evalStatements = evaluations.map(e =>
    env.DB.prepare(
      'INSERT OR IGNORE INTO evaluations (attempt_id, question_id, sub_part, marks_awarded, max_marks, feedback, confidence) VALUES (?, ?, ?, ?, ?, ?, ?)'
    ).bind(attemptId, e.question_id, e.sub_part || null, e.marks_awarded, e.max_marks, e.feedback, e.confidence)
  );

  if (evalStatements.length > 0) {
    await env.DB.batch(evalStatements);
  }

  return jsonResponse({
    success: true,
    attempt_id: attemptId,
    status: 'submitted',
    submitted_at: now,
    time_spent_seconds: timeSpent,
    results: {
      mcq_correct: mcqCorrect,
      mcq_total: mcqTotal,
      total_marks_obtained: totalObtained,
      total_marks_possible: totalPossible,
      percentage,
      subjective_pending: evaluations.filter(e => e.needs_ai).length
    }
  });
}

/**
 * GET /api/user/:user_id/attempts
 * Get all attempts for a user (requires API key)
 */
async function handleGetUserAttempts(userId, request, env) {
  const url = new URL(request.url);
  const limit = parseInt(url.searchParams.get('limit')) || 20;
  const offset = parseInt(url.searchParams.get('offset')) || 0;

  // Get attempts with set info
  const result = await env.DB.prepare(`
    SELECT
      ta.id,
      ta.set_id,
      ta.started_at,
      ta.submitted_at,
      ta.time_spent_seconds,
      ta.status,
      ta.total_marks_obtained,
      ta.total_marks_possible,
      ta.percentage,
      ta.mcq_correct,
      ta.mcq_total,
      es.name as set_name,
      es.exam_type,
      es.grade,
      es.subject
    FROM test_attempts ta
    LEFT JOIN exam_sets es ON ta.set_id = es.id
    WHERE ta.user_id = ?
    ORDER BY ta.started_at DESC
    LIMIT ? OFFSET ?
  `).bind(userId, limit, offset).all();

  // Get total count
  const countResult = await env.DB.prepare(
    'SELECT COUNT(*) as total FROM test_attempts WHERE user_id = ?'
  ).bind(userId).first();

  return jsonResponse({
    success: true,
    user_id: userId,
    total: countResult.total,
    limit,
    offset,
    attempts: result.results
  });
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const { pathname } = url;
    const reqOrigin = request.headers.get('Origin') || '';

    try {
      // Health check
      if (pathname === '/health' && request.method === 'GET') {
        return handleHealth(env);
      }

      // =============================================
      // PUBLIC ENDPOINTS (no auth required)
      // =============================================

      // GET /api/chapters - List chapters
      if (pathname === '/api/chapters' && request.method === 'GET') {
        const r = await handleGetChapters(request, env);
        return withCors(r, reqOrigin);
      }

      // GET /api/chapters/:id/topics - List topics for chapter
      const topicsMatch = pathname.match(/^\/api\/chapters\/([^/]+)\/topics$/);
      if (topicsMatch && request.method === 'GET') {
        const r = await handleGetTopics(topicsMatch[1], env);
        return withCors(r, reqOrigin);
      }

      // GET /api/sets - List exam sets
      if (pathname === '/api/sets' && request.method === 'GET') {
        const r = await handleGetSets(request, env);
        return withCors(r, reqOrigin);
      }

      // GET /api/sets/:id - Get single set
      const setMatch = pathname.match(/^\/api\/sets\/([^/]+)$/);
      if (setMatch && request.method === 'GET') {
        const r = await handleGetSet(setMatch[1], env);
        return withCors(r, reqOrigin);
      }

      // GET /api/sets/:id/questions - Get questions for set
      const questionsMatch = pathname.match(/^\/api\/sets\/([^/]+)\/questions$/);
      if (questionsMatch && request.method === 'GET') {
        const r = await handleGetQuestions(questionsMatch[1], env);
        return withCors(r, reqOrigin);
      }

      // POST /api/attempts - Start new attempt
      if (pathname === '/api/attempts' && request.method === 'POST') {
        const r = await handleCreateAttempt(request, env);
        return withCors(r, reqOrigin);
      }

      // GET /api/attempts/:id - Get attempt details
      const attemptGetMatch = pathname.match(/^\/api\/attempts\/([^/]+)$/);
      if (attemptGetMatch && request.method === 'GET') {
        const r = await handleGetAttempt(attemptGetMatch[1], env);
        return withCors(r, reqOrigin);
      }

      // POST /api/attempts/:id/answers - Save answers
      const answersMatch = pathname.match(/^\/api\/attempts\/([^/]+)\/answers$/);
      if (answersMatch && request.method === 'POST') {
        const r = await handleSaveAnswers(answersMatch[1], request, env);
        return withCors(r, reqOrigin);
      }

      // POST /api/attempts/:id/submit - Submit for grading (requires API key for AI marking)
      const submitMatch = pathname.match(/^\/api\/attempts\/([^/]+)\/submit$/);
      if (submitMatch && request.method === 'POST') {
        // API key required for submit since it may trigger AI marking
        const authError = requireApiKey(request, env);
        if (authError) {
          return withCors(authError, reqOrigin);
        }
        const r = await handleSubmitAttempt(submitMatch[1], request, env);
        return withCors(r, reqOrigin);
      }

      // =============================================
      // PROTECTED ENDPOINTS (API key required)
      // =============================================

      // GET /api/user/:user_id/attempts - Get user's test history
      const userAttemptsMatch = pathname.match(/^\/api\/user\/([^/]+)\/attempts$/);
      if (userAttemptsMatch && request.method === 'GET') {
        const authError = requireApiKey(request, env);
        if (authError) {
          return withCors(authError, reqOrigin);
        }
        const r = await handleGetUserAttempts(userAttemptsMatch[1], request, env);
        return withCors(r, reqOrigin);
      }

      // Single answer marking
      if (pathname === '/api/mark' && request.method === 'POST') {
        const authError = requireApiKey(request, env);
        if (authError) {
          return withCors(authError, reqOrigin);
        }
        const r = await handleMark(request, env);
        return withCors(r, reqOrigin);
      }

      // Batch marking
      if (pathname === '/api/mark-batch' && request.method === 'POST') {
        const authError = requireApiKey(request, env);
        if (authError) {
          return withCors(authError, reqOrigin);
        }
        const r = await handleMarkBatch(request, env);
        return withCors(r, reqOrigin);
      }

      // Full exam marking
      if (pathname === '/api/mark-exam' && request.method === 'POST') {
        const authError = requireApiKey(request, env);
        if (authError) {
          return withCors(authError, reqOrigin);
        }
        const r = await handleMarkExam(request, env);
        return withCors(r, reqOrigin);
      }

      // CORS preflight
      if (request.method === 'OPTIONS') {
        return withCors(new Response(null, { status: 204 }), reqOrigin);
      }

      return new Response('Not Found', { status: 404 });
    } catch (err) {
      console.error('Unhandled error:', err);
      return jsonResponse({ error: 'Internal Error' }, { status: 500 });
    }
  },
};

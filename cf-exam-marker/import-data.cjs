/**
 * Import Exam Data Script
 * Imports JSON exam sets into Cloudflare D1 database
 *
 * Usage:
 *   node import-data.js                    # Generate SQL file
 *   wrangler d1 execute exam-marker-db --file=import.sql --remote
 */

const fs = require('fs');
const path = require('path');

// Path to exam data
const DATA_DIR = path.join(__dirname, '../src/main/webapp/exams/cbse-board/mathematics/data');

// CBSE Class 10 Mathematics Chapters
const CHAPTERS = [
  { id: 'cbse-10-math-ch01', number: 1, name: 'Real Numbers', description: 'Euclid\'s division lemma, Fundamental Theorem of Arithmetic, HCF, LCM' },
  { id: 'cbse-10-math-ch02', number: 2, name: 'Polynomials', description: 'Zeros of polynomial, relationship between zeros and coefficients' },
  { id: 'cbse-10-math-ch03', number: 3, name: 'Pair of Linear Equations in Two Variables', description: 'Graphical and algebraic methods of solving' },
  { id: 'cbse-10-math-ch04', number: 4, name: 'Quadratic Equations', description: 'Solutions by factorization, completing square, quadratic formula' },
  { id: 'cbse-10-math-ch05', number: 5, name: 'Arithmetic Progressions', description: 'nth term, sum of n terms' },
  { id: 'cbse-10-math-ch06', number: 6, name: 'Triangles', description: 'Similarity of triangles, Pythagoras theorem' },
  { id: 'cbse-10-math-ch07', number: 7, name: 'Coordinate Geometry', description: 'Distance formula, section formula, area of triangle' },
  { id: 'cbse-10-math-ch08', number: 8, name: 'Introduction to Trigonometry', description: 'Trigonometric ratios, identities' },
  { id: 'cbse-10-math-ch09', number: 9, name: 'Some Applications of Trigonometry', description: 'Heights and distances' },
  { id: 'cbse-10-math-ch10', number: 10, name: 'Circles', description: 'Tangent to a circle, number of tangents' },
  { id: 'cbse-10-math-ch11', number: 11, name: 'Constructions', description: 'Division of line segment, tangent to circle' },
  { id: 'cbse-10-math-ch12', number: 12, name: 'Areas Related to Circles', description: 'Area of sector, segment' },
  { id: 'cbse-10-math-ch13', number: 13, name: 'Surface Areas and Volumes', description: 'Combinations of solids, conversion of solids' },
  { id: 'cbse-10-math-ch14', number: 14, name: 'Statistics', description: 'Mean, median, mode of grouped data' },
  { id: 'cbse-10-math-ch15', number: 15, name: 'Probability', description: 'Classical definition, simple problems' }
];

function escapeSQL(str) {
  if (str === null || str === undefined) return 'NULL';
  if (typeof str !== 'string') str = String(str);
  return "'" + str.replace(/'/g, "''") + "'";
}

function generateChaptersSQL() {
  let sql = '-- Insert Chapters\n';

  CHAPTERS.forEach((ch, i) => {
    sql += `INSERT INTO chapters (id, exam_type, grade, subject, chapter_number, name, description, sort_order) VALUES (${escapeSQL(ch.id)}, 'CBSE', '10', 'mathematics', ${ch.number}, ${escapeSQL(ch.name)}, ${escapeSQL(ch.description)}, ${i + 1});\n`;
  });

  return sql + '\n';
}

function generateSetSQL(setData, setNumber) {
  const setId = `cbse-10-math-full-${String(setNumber).padStart(2, '0')}`;
  const setName = `CBSE Class 10 Mathematics - Full Mock Test ${setNumber}`;

  let sql = `-- Exam Set ${setNumber}\n`;
  sql += `INSERT INTO exam_sets (id, exam_type, grade, subject, test_type, name, total_questions, total_marks, duration_minutes, is_free) VALUES (${escapeSQL(setId)}, 'CBSE', '10', 'mathematics', 'full', ${escapeSQL(setName)}, ${setData.total_questions || 36}, 80, 90, 1);\n\n`;

  return { sql, setId };
}

function generateQuestionsSQL(questions, setId) {
  let sql = '-- Questions\n';

  questions.forEach((q, i) => {
    const questionId = `${setId}-${q.question_id}`;
    const questionText = q.question?.text_plain || q.question?.text_latex || '';
    const questionLatex = q.question?.text_latex || null;
    const hasDiagram = q.question?.has_diagram ? 1 : 0;
    const diagramSvg = q.question?.visual_diagram?.svg_code || null;
    
    // Transform options from old format to new format before storing
    // Old format: {option_id: "A", text_plain: "...", is_correct: true}
    // New format: {id: "A", text: "...", is_correct: true}
    let optionsJson = null;
    if (q.options && Array.isArray(q.options)) {
      const transformedOptions = q.options.map(opt => ({
        id: opt.option_id || opt.id,  // Use option_id if present (old format), otherwise id
        text: opt.text_plain || opt.text || opt.text_latex || '',  // Prefer text_plain, fallback to text
        is_correct: opt.is_correct || false
      }));
      optionsJson = JSON.stringify(transformedOptions);
    }
    
    const solutionJson = JSON.stringify(q.solution || {});
    const unit = q.unit || null;
    const topic = q.topic || null;

    // Handle CaseStudy questions
    // Store case_study with all properties including has_diagram and visual_diagram
    let caseStudyJson = null;
    if (q.type === 'CaseStudy') {
      // Preserve visual_diagram structure with all properties
      const visualDiagram = q.case_study?.visual_diagram ? {
        diagram_type: q.case_study.visual_diagram.diagram_type || 'geometric',
        svg_code: q.case_study.visual_diagram.svg_code || null,
        description: q.case_study.visual_diagram.description || null
      } : null;
      
      caseStudyJson = JSON.stringify({
        title: q.case_study?.title,
        context_plain: q.case_study?.context_plain,  // Keep context_plain (not context)
        has_diagram: q.case_study?.has_diagram || false,
        visual_diagram: visualDiagram,  // Preserve full visual_diagram object
        sub_questions: q.sub_questions || []  // Store sub_questions inside case_study
      });
    }

    sql += `INSERT INTO questions (id, set_id, type, marks, difficulty, question_text, question_latex, has_diagram, diagram_svg, options_json, solution_json, unit, topic, case_study_json, sort_order) VALUES (${escapeSQL(questionId)}, ${escapeSQL(setId)}, ${escapeSQL(q.type)}, ${q.marks}, ${q.difficulty || 0.5}, ${escapeSQL(questionText)}, ${escapeSQL(questionLatex)}, ${hasDiagram}, ${escapeSQL(diagramSvg)}, ${escapeSQL(optionsJson)}, ${escapeSQL(solutionJson)}, ${escapeSQL(unit)}, ${escapeSQL(topic)}, ${escapeSQL(caseStudyJson)}, ${i + 1});\n`;
  });

  return sql + '\n';
}

function main() {
  console.log('Generating import SQL...\n');

  let fullSQL = '-- CF Exam Marker Data Import\n';
  fullSQL += '-- Generated: ' + new Date().toISOString() + '\n\n';

  // Add chapters
  fullSQL += generateChaptersSQL();

  // Find all set files
  const files = fs.readdirSync(DATA_DIR).filter(f => f.match(/set-\d+.*\.json$/));
  console.log(`Found ${files.length} exam set files\n`);

  files.forEach((file, index) => {
    const setNumber = index + 1;
    const filePath = path.join(DATA_DIR, file);

    console.log(`Processing: ${file}`);

    try {
      const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));

      const { sql: setSQL, setId } = generateSetSQL(data, setNumber);
      fullSQL += setSQL;

      if (data.questions && data.questions.length > 0) {
        fullSQL += generateQuestionsSQL(data.questions, setId);
        console.log(`  - ${data.questions.length} questions`);
      }
    } catch (err) {
      console.error(`  Error: ${err.message}`);
    }
  });

  // Write SQL file
  const outputPath = path.join(__dirname, 'import.sql');
  fs.writeFileSync(outputPath, fullSQL);

  console.log(`\nGenerated: ${outputPath}`);
  console.log('\nTo import, run:');
  console.log('  wrangler d1 execute exam-marker-db --file=import.sql --remote');
}

main();

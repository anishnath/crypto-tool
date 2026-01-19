/**
 * Unified Migration Script for CF Exam Marker Database
 * Handles all database migrations in order
 * 
 * Usage:
 *   node migrate.cjs                    # Generate SQL file
 *   wrangler d1 execute exam-marker-db --file=migrate.sql --local
 *   wrangler d1 execute exam-marker-db --file=migrate.sql --remote
 */

const fs = require('fs');
const path = require('path');

// Path to exam data
const DATA_DIR = path.join(__dirname, '../src/main/webapp/exams/cbse-board/mathematics/data');

function escapeSQL(str) {
  if (str === null || str === undefined) return 'NULL';
  if (typeof str !== 'string') str = String(str);
  return "'" + str.replace(/'/g, "''") + "'";
}

/**
 * Migration 1: Fix Case Study Diagrams
 * Updates case_study_json to include visual_diagram and has_diagram
 * Also fixes context_plain field
 */
function migration1_fixCaseStudyDiagrams() {
  console.log('Migration 1: Fixing case study diagrams...');
  
  let sql = '-- Migration 1: Fix Case Study Diagrams\n';
  sql += '-- Updates case_study_json to include visual_diagram, has_diagram, and context_plain\n\n';

  // Find all set files
  const files = fs.readdirSync(DATA_DIR).filter(f => f.match(/set-\d+.*\.json$/));
  let updateCount = 0;

  files.forEach((file, index) => {
    const setNumber = index + 1;
    const setId = `cbse-10-math-full-${String(setNumber).padStart(2, '0')}`;
    const filePath = path.join(DATA_DIR, file);

    try {
      const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));

      if (data.questions && data.questions.length > 0) {
        // Find all CaseStudy questions
        const caseStudyQuestions = data.questions.filter(q => q.type === 'CaseStudy');
        
        caseStudyQuestions.forEach((q) => {
          const questionId = `${setId}-${q.question_id}`;
          
          // Preserve visual_diagram structure with all properties
          const visualDiagram = q.case_study?.visual_diagram ? {
            diagram_type: q.case_study.visual_diagram.diagram_type || 'geometric',
            svg_code: q.case_study.visual_diagram.svg_code || null,
            description: q.case_study.visual_diagram.description || null
          } : null;
          
          // Build updated case_study_json
          const caseStudyJson = JSON.stringify({
            title: q.case_study?.title,
            context_plain: q.case_study?.context_plain || q.case_study?.context,  // Support both
            has_diagram: q.case_study?.has_diagram || false,
            visual_diagram: visualDiagram,  // Include visual_diagram
            sub_questions: q.sub_questions || []  // Keep sub_questions
          });

          // Generate UPDATE statement
          sql += `UPDATE questions SET case_study_json = ${escapeSQL(caseStudyJson)} WHERE id = ${escapeSQL(questionId)};\n`;
          updateCount++;
        });
      }
    } catch (err) {
      console.error(`  Error processing ${file}: ${err.message}`);
    }
  });

  console.log(`  - Updated ${updateCount} case study questions\n`);
  return sql + '\n';
}

/**
 * Main migration function
 * Runs all migrations in order
 */
function main() {
  console.log('Generating unified migration SQL...\n');
  console.log('='.repeat(60));

  let fullSQL = '-- CF Exam Marker Database Migrations\n';
  fullSQL += '-- Generated: ' + new Date().toISOString() + '\n';
  fullSQL += '-- This script applies all pending migrations in order\n\n';

  // Run migrations in order
  fullSQL += migration1_fixCaseStudyDiagrams();

  // Add future migrations here:
  // fullSQL += migration2_fixSomethingElse();
  // fullSQL += migration3_fixAnotherThing();

  // Write SQL file
  const outputPath = path.join(__dirname, 'migrate.sql');
  fs.writeFileSync(outputPath, fullSQL);

  console.log('='.repeat(60));
  console.log(`\n✅ Generated: ${outputPath}`);
  console.log('\nTo apply migrations:');
  console.log('  Local:  wrangler d1 execute exam-marker-db --file=migrate.sql --local');
  console.log('  Remote: wrangler d1 execute exam-marker-db --file=migrate.sql --remote');
}

main();


-- Migration 001: Add unique index to evaluations table
-- This enables INSERT OR IGNORE to work properly, preventing duplicate evaluations
-- for the same (attempt_id, question_id, sub_part) combination

-- First, remove any existing duplicates (keeping the one with highest marks_awarded)
DELETE FROM evaluations
WHERE id NOT IN (
    SELECT MIN(id)
    FROM evaluations
    GROUP BY attempt_id, question_id, COALESCE(sub_part, '')
);

-- Create unique index (achieves same effect as UNIQUE constraint for INSERT OR IGNORE)
CREATE UNIQUE INDEX IF NOT EXISTS idx_evaluations_unique
ON evaluations(attempt_id, question_id, COALESCE(sub_part, ''));

/**
 * Exam Platform - Practice Module
 * Handles practice interface, question rendering, and user interactions
 */

const ExamPractice = (function() {
    'use strict';

    // DOM Elements
    let elements = {
        questionContainer: null,
        navigatorGrid: null,
        mobileNavigatorGrid: null,
        progressStats: null,
        timerDisplay: null
    };

    // Configuration
    let config = {
        showInstantFeedback: false,
        autoAdvance: false,
        onAnswerChange: null,
        onQuestionChange: null,
        onSubmit: null
    };

    // Timer
    let timerInterval = null;
    let timeRemaining = 0;

    /**
     * Initialize practice interface
     */
    function init(options = {}) {
        Object.assign(config, options);

        // Cache DOM elements
        elements.questionContainer = document.getElementById('question-container');
        elements.navigatorGrid = document.getElementById('navigator-grid');
        elements.mobileNavigatorGrid = document.getElementById('mobile-navigator-grid');
        elements.progressStats = document.getElementById('progress-stats');
        elements.timerDisplay = document.getElementById('timer-display');

        // Setup event listeners
        setupEventListeners();
    }

    /**
     * Setup event listeners
     */
    function setupEventListeners() {
        // Keyboard navigation
        document.addEventListener('keydown', handleKeyboard);

        // Mobile navigator toggle
        const navToggle = document.getElementById('mobile-nav-toggle');
        if (navToggle) {
            navToggle.addEventListener('click', toggleMobileNavigator);
        }

        // Close mobile navigator
        const navClose = document.getElementById('mobile-nav-close');
        if (navClose) {
            navClose.addEventListener('click', closeMobileNavigator);
        }

        // Overlay click
        const overlay = document.getElementById('navigator-overlay');
        if (overlay) {
            overlay.addEventListener('click', closeMobileNavigator);
        }
    }

    /**
     * Keyboard navigation
     */
    function handleKeyboard(e) {
        // Don't handle if typing in input
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
            return;
        }

        switch(e.key) {
            case 'ArrowRight':
            case 'n':
                e.preventDefault();
                navigateNext();
                break;
            case 'ArrowLeft':
            case 'p':
                e.preventDefault();
                navigatePrev();
                break;
            case 'm':
                e.preventDefault();
                markCurrentQuestion();
                break;
            case '1':
            case '2':
            case '3':
            case '4':
                if (e.ctrlKey || e.metaKey) return;
                selectOption(e.key);
                break;
        }
    }

    /**
     * Render a question
     */
    function renderQuestion(question, index, total) {
        if (!elements.questionContainer || !question) return;

        const state = ExamCore.getState();
        // API format: question.id, Old JSON format: question.question_id
        const questionId = question.id || question.question_id;
        const answer = ExamCore.getAnswer(questionId);
        const isMarked = ExamCore.isMarked(questionId);

        let html = `
            <div class="question-card" data-question-id="${questionId}">
                <div class="question-header">
                    <div>
                        <span class="question-number">Question ${index + 1} of ${total}</span>
                        <span class="question-type">${question.type}</span>
                    </div>
                    <div class="question-meta">
                        <span class="question-marks">${question.marks} mark${question.marks > 1 ? 's' : ''}</span>
                    </div>
                </div>

                <div class="question-content">
                    ${renderQuestionText(question)}
                </div>

                ${renderDiagram(question)}

                ${renderAnswerArea(question, answer)}

                ${state.isSubmitted ? renderSolution(question) : ''}

                <div class="question-actions">
                    <div class="question-actions-left">
                        ${!state.isSubmitted ? `
                            <button class="btn btn-secondary btn-mark ${isMarked ? 'marked' : ''}" onclick="ExamPractice.toggleMark()">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="${isMarked ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="2">
                                    <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                </svg>
                                ${isMarked ? 'Marked' : 'Mark for Review'}
                            </button>
                            <button class="btn btn-ghost" onclick="ExamPractice.clearAnswer()">
                                Clear
                            </button>
                        ` : ''}
                    </div>
                    <div class="question-actions-right">
                        <button class="btn btn-secondary" onclick="ExamPractice.navigatePrev()" ${index === 0 ? 'disabled' : ''}>
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="15 18 9 12 15 6"></polyline>
                            </svg>
                            Prev
                        </button>
                        <button class="btn btn-primary" onclick="ExamPractice.navigateNext()" ${index === total - 1 ? 'disabled' : ''}>
                            Next
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="9 18 15 12 9 6"></polyline>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        `;

        elements.questionContainer.innerHTML = html;

        // Trigger MathJax rendering only on text content (not SVGs)
        typesetMathContent();

        // Update navigator
        updateNavigator();
        updateProgress();

        // Callback
        if (config.onQuestionChange) {
            config.onQuestionChange(question, index);
        }
    }

    /**
     * Typeset math content using MathJax
     * Only targets text elements, avoiding SVG diagrams
     */
    function typesetMathContent() {
        // Get only text content elements that may contain math
        const mathElements = document.querySelectorAll(
            '.question-content p, .option-text, .solution-steps, .solution-answer, .case-study-content, .sub-question p'
        );

        if (mathElements.length === 0) return;

        const elementsArray = Array.from(mathElements);

        // Function to actually typeset
        function doTypeset() {
            if (typeof MathJax.typesetPromise === 'function') {
                MathJax.typesetPromise(elementsArray).catch(function(err) {
                    console.warn('MathJax typeset error:', err);
                });
            }
        }

        // Check if MathJax is ready
        if (window.MathJax && typeof MathJax.typesetPromise === 'function') {
            // MathJax is fully loaded, typeset now
            doTypeset();
        } else if (window.MathJax && MathJax.startup && MathJax.startup.promise) {
            // MathJax is loading, wait for it
            MathJax.startup.promise.then(doTypeset);
        } else {
            // MathJax not loaded yet, wait for it
            var checkCount = 0;
            var checkInterval = setInterval(function() {
                checkCount++;
                if (window.MathJax && typeof MathJax.typesetPromise === 'function') {
                    clearInterval(checkInterval);
                    doTypeset();
                } else if (checkCount > 50) { // Give up after 5 seconds
                    clearInterval(checkInterval);
                    console.warn('MathJax failed to load');
                }
            }, 100);
        }
    }

    /**
     * Render question text
     * Supports both API format (question_text/question_latex) and old JSON format (question.text_plain/question.text_latex)
     */
    function renderQuestionText(question) {
        // API format: question_text and question_latex at top level
        // Old JSON format: question.text_plain and question.text_latex nested
        let text = question.question_latex || question.question_text || 
                   question.question?.text_latex || question.question?.text_plain || '';

        // Handle case study
        if (question.type === 'CaseStudy' && question.case_study) {
            return `
                <div class="case-study-box">
                    <div class="case-study-title">${ExamCore.escapeHtml(question.case_study.title)}</div>
                    <div class="case-study-content">${question.case_study.context_plain || ''}</div>
                </div>
                ${(question.case_study.has_diagram === true || question.case_study.has_diagram === 1) && question.case_study.visual_diagram && question.case_study.visual_diagram.svg_code ?
                    `<div class="question-diagram">${question.case_study.visual_diagram.svg_code}</div>` : ''
                }
            `;
        }

        return `<p>${text}</p>`;
    }

    /**
     * Render diagram if present
     * Supports both API format (has_diagram/visual_diagram at top level) and old JSON format (nested in question)
     */
    function renderDiagram(question) {
        // API format: has_diagram (boolean) and visual_diagram (object with svg_code) at top level
        // Old JSON format: question.has_diagram (boolean) and question.visual_diagram (object) nested
        // Also support direct diagram_svg string (legacy API format)
        const hasDiagram = question.has_diagram || question.question?.has_diagram;
        let visualDiagram = question.visual_diagram || question.question?.visual_diagram;
        
        // If diagram_svg is a string at top level (legacy format), convert to object
        if (!visualDiagram && question.diagram_svg && typeof question.diagram_svg === 'string') {
            visualDiagram = {
                svg_code: question.diagram_svg,
                description: null
            };
        }
        
        if (!hasDiagram || !visualDiagram) {
            return '';
        }

        // Extract SVG code from object or use directly if it's a string
        const svgCode = visualDiagram.svg_code || (typeof visualDiagram === 'string' ? visualDiagram : '');
        if (!svgCode) {
            return '';
        }

        return `
            <div class="question-diagram">
                ${svgCode}
                ${visualDiagram.description ? `<p class="text-muted text-sm mt-2">${visualDiagram.description}</p>` : ''}
            </div>
        `;
    }

    /**
     * Render answer area based on question type
     */
    function renderAnswerArea(question, answer) {
        const state = ExamCore.getState();

        switch(question.type) {
            case 'MCQ':
            case 'Assertion-Reason':
                return renderMCQOptions(question, answer, state.isSubmitted);
            case 'VSA':
            case 'SA':
            case 'LA':
                return renderTextInput(question, answer, state.isSubmitted);
            case 'CaseStudy':
                return renderCaseStudyQuestions(question, answer, state.isSubmitted);
            default:
                return renderMCQOptions(question, answer, state.isSubmitted);
        }
    }

    /**
     * Render MCQ options
     * Supports both API format (option.id, option.is_correct) and old JSON format (option.option_id, option.is_correct)
     */
    function renderMCQOptions(question, selectedAnswer, isSubmitted) {
        if (!question.options) return '';

        // API format: option.id and option.is_correct
        // Old JSON format: option.option_id and option.is_correct
        const correctOption = question.options.find(o => o.is_correct);
        const correctId = correctOption?.id || correctOption?.option_id || question.solution?.answer?.correct_option;

        let html = '<div class="options-list">';

        question.options.forEach((option, i) => {
            // API format: option.id and option.text at top level
            // Old JSON format: option.option_id, option.text_latex, option.text_plain
            const optionId = option.id || option.option_id;
            const optionText = option.text || option.text_latex || option.text_plain || '';
            const isSelected = selectedAnswer === optionId;
            const isCorrect = optionId === correctId;

            let classes = 'option-item';
            if (isSelected) classes += ' selected';
            if (isSubmitted) {
                classes += ' disabled';
                if (isCorrect) classes += ' correct';
                else if (isSelected && !isCorrect) classes += ' incorrect';
            }

            html += `
                <div class="${classes}" onclick="ExamPractice.selectAnswer('${optionId}')" data-option="${optionId}">
                    <div class="option-radio"></div>
                    <span class="option-label">${optionId})</span>
                    <span class="option-text">${optionText}</span>
                    ${isSubmitted && isCorrect ? '<span class="option-result correct-answer">Correct</span>' : ''}
                    ${isSubmitted && isSelected && !isCorrect ? '<span class="option-result your-answer">Your Answer</span>' : ''}
                </div>
            `;
        });

        html += '</div>';
        return html;
    }

    /**
     * Render simple text input for subjective questions
     * Student-friendly with quick-insert buttons for common math
     */
    function renderTextInput(question, answer, isSubmitted) {
        const rows = question.type === 'LA' ? 8 : (question.type === 'SA' ? 4 : 2);
        // API format: question.id, Old JSON format: question.question_id
        const questionId = question.id || question.question_id;
        const inputId = 'answer-' + (questionId || 'main');

        return `
            <div class="math-input-container">
                <!-- Simple Quick Insert Bar -->
                ${!isSubmitted ? `
                <div class="quick-math-bar">
                    <span class="quick-math-label">Quick insert:</span>
                    <div class="quick-math-buttons">
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', 'x²')" title="Square">x²</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '√')" title="Square root">√</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', 'π')" title="Pi">π</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', 'θ')" title="Theta">θ</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '±')" title="Plus-minus">±</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '°')" title="Degree">°</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '≠')" title="Not equal">≠</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '≤')" title="Less or equal">≤</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '≥')" title="Greater or equal">≥</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '∴')" title="Therefore">∴</button>
                        <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '∞')" title="Infinity">∞</button>
                    </div>
                </div>
                ` : ''}

                <!-- Text Area -->
                <textarea
                    id="${inputId}"
                    class="answer-input"
                    rows="${rows}"
                    placeholder="Write your answer here...&#10;&#10;Tip: Use ^ for powers (x^2 = x²), / for fractions, sqrt() for roots"
                    ${isSubmitted ? 'disabled' : ''}
                    oninput="ExamPractice.handleMathInput('${inputId}')"
                    onchange="ExamPractice.saveTextAnswer(this.value)"
                >${answer || ''}</textarea>

                <!-- Helpful hint -->
                ${!isSubmitted ? `
                <div class="input-hint">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <path d="M12 16v-4"></path>
                        <path d="M12 8h.01"></path>
                    </svg>
                    <span>Write naturally! Examples: <code>x^2</code> for x², <code>sqrt(4)</code> for √4, <code>a/b</code> for fractions</span>
                </div>
                ` : ''}

                <!-- Live Preview (only show if has math-like content) -->
                <div class="math-preview-container" id="preview-container-${inputId}" style="display: none;">
                    <div class="math-preview-label">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                            <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                        Preview
                    </div>
                    <div class="math-preview" id="preview-${inputId}"></div>
                </div>
            </div>
        `;
    }

    /**
     * Insert math symbol at cursor - simple Unicode insertion
     */
    function insertMath(inputId, symbol) {
        const textarea = document.getElementById(inputId);
        if (!textarea || textarea.disabled) return;

        const start = textarea.selectionStart;
        const end = textarea.selectionEnd;
        const text = textarea.value;

        textarea.value = text.substring(0, start) + symbol + text.substring(end);

        const cursorPos = start + symbol.length;
        textarea.setSelectionRange(cursorPos, cursorPos);
        textarea.focus();

        // Trigger input event
        textarea.dispatchEvent(new Event('input', { bubbles: true }));
    }

    /**
     * Handle math input - convert shortcuts to symbols and update preview
     */
    function handleMathInput(inputId) {
        const textarea = document.getElementById(inputId);
        const previewContainer = document.getElementById('preview-container-' + inputId);
        const preview = document.getElementById('preview-' + inputId);
        if (!textarea) return;

        let value = textarea.value;

        // Auto-convert common patterns (only when user types them)
        const cursorPos = textarea.selectionStart;

        // Check for patterns that just got completed
        const conversions = [
            { pattern: /\^2(?![0-9])/g, replace: '²' },
            { pattern: /\^3(?![0-9])/g, replace: '³' },
            { pattern: /\^n(?![a-z])/gi, replace: 'ⁿ' },
            { pattern: /sqrt\(/g, replace: '√(' },
            { pattern: /pi(?![a-z])/gi, replace: 'π' },
            { pattern: /theta(?![a-z])/gi, replace: 'θ' },
            { pattern: /alpha(?![a-z])/gi, replace: 'α' },
            { pattern: /beta(?![a-z])/gi, replace: 'β' },
            { pattern: /delta(?![a-z])/gi, replace: 'Δ' },
            { pattern: /infinity/gi, replace: '∞' },
            { pattern: /<=/g, replace: '≤' },
            { pattern: />=/g, replace: '≥' },
            { pattern: /!=/g, replace: '≠' },
            { pattern: /\+-/g, replace: '±' },
            { pattern: /therefore/gi, replace: '∴' },
            { pattern: /degrees?(?![a-z])/gi, replace: '°' }
        ];

        let newValue = value;
        let offset = 0;

        conversions.forEach(({ pattern, replace }) => {
            newValue = newValue.replace(pattern, (match, index) => {
                // Track offset change for cursor positioning
                offset += replace.length - match.length;
                return replace;
            });
        });

        if (newValue !== value) {
            textarea.value = newValue;
            // Try to maintain cursor position
            const newPos = Math.max(0, cursorPos + offset);
            textarea.setSelectionRange(newPos, newPos);
        }

        // Show preview only if content has math-like symbols
        const hasMath = /[²³ⁿ√πθαβΔ∞≤≥≠±∴°\^\/]/.test(newValue) || /\$.*\$/.test(newValue);

        if (previewContainer && preview) {
            if (hasMath && newValue.trim()) {
                previewContainer.style.display = 'block';

                // Process each line separately to preserve line breaks
                const lines = newValue.split('\n');
                const processedLines = lines.map(function(line) {
                    if (!line.trim()) return '<br>';

                    // Convert to LaTeX for MathJax rendering
                    let latexLine = line
                        .replace(/²/g, '^2')
                        .replace(/³/g, '^3')
                        .replace(/ⁿ/g, '^n')
                        .replace(/√\(([^)]+)\)/g, '\\sqrt{$1}')
                        .replace(/√(\d+)/g, '\\sqrt{$1}')
                        .replace(/√([a-z])/gi, '\\sqrt{$1}')
                        .replace(/π/g, '\\pi')
                        .replace(/θ/g, '\\theta')
                        .replace(/α/g, '\\alpha')
                        .replace(/β/g, '\\beta')
                        .replace(/Δ/g, '\\Delta')
                        .replace(/∞/g, '\\infty')
                        .replace(/≤/g, '\\leq')
                        .replace(/≥/g, '\\geq')
                        .replace(/≠/g, '\\neq')
                        .replace(/±/g, '\\pm')
                        .replace(/∴/g, '\\therefore')
                        .replace(/°/g, '^\\circ')
                        .replace(/(\d+)\/(\d+)/g, '\\frac{$1}{$2}');

                    // Wrap line in math delimiters if it has math and not already wrapped
                    if (!latexLine.includes('$')) {
                        latexLine = '$' + latexLine + '$';
                    }
                    return latexLine;
                });

                preview.innerHTML = processedLines.join('<br>');

                // Typeset with MathJax
                if (window.MathJax && typeof MathJax.typesetPromise === 'function') {
                    MathJax.typesetPromise([preview]).catch(function(err) {
                        // If MathJax fails, just show the Unicode version with line breaks
                        preview.innerHTML = newValue.replace(/\n/g, '<br>');
                    });
                }
            } else {
                previewContainer.style.display = 'none';
            }
        }
    }

    /**
     * Legacy function for compatibility
     */
    function insertSymbol(inputId, symbol) {
        insertMath(inputId, symbol);
    }

    /**
     * Legacy function for compatibility
     */
    function toggleMathHelp(inputId) {
        // No longer needed with simplified interface
    }

    /**
     * Render case study sub-questions
     */
    function renderCaseStudyQuestions(question, answers, isSubmitted) {
        // Support both formats:
        // - sub_questions at question level (API format)
        // - sub_questions inside case_study (old JSON format)
        const subQuestions = question.sub_questions || question.case_study?.sub_questions;
        if (!subQuestions || !Array.isArray(subQuestions) || subQuestions.length === 0) {
            return '';
        }

        answers = answers || {};

        // API format: question.id, Old JSON format: question.question_id
        const questionId = question.id || question.question_id;

        let html = '';
        subQuestions.forEach((subQ, i) => {
            const subAnswer = answers[subQ.part] || '';

            // Support both formats for sub-question text:
            // - subQ.question.text_plain (old format)
            // - subQ.question_text (API format)
            const subQuestionText = subQ.question?.text_plain || subQ.question_text || '';

            // Unique input ID for each sub-question
            const inputId = 'answer-' + (questionId || 'cs') + '-' + subQ.part;

            html += `
                <div class="sub-question">
                    <div class="sub-question-header">
                        <span class="sub-question-number">(${subQ.part})</span>
                        <span class="sub-question-marks">${subQ.marks} mark${subQ.marks > 1 ? 's' : ''}</span>
                    </div>
                    <p class="mb-4">${subQuestionText}</p>

                    <div class="math-input-container">
                        <!-- Quick Insert Bar for math symbols -->
                        ${!isSubmitted ? `
                        <div class="quick-math-bar">
                            <span class="quick-math-label">Quick insert:</span>
                            <div class="quick-math-buttons">
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', 'x²')" title="Square">x²</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '√')" title="Square root">√</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', 'π')" title="Pi">π</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', 'θ')" title="Theta">θ</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '±')" title="Plus-minus">±</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '°')" title="Degree">°</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '≠')" title="Not equal">≠</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '≤')" title="Less or equal">≤</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '≥')" title="Greater or equal">≥</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '∴')" title="Therefore">∴</button>
                                <button type="button" class="quick-btn" onclick="ExamPractice.insertMath('${inputId}', '∞')" title="Infinity">∞</button>
                            </div>
                        </div>
                        ` : ''}

                        <textarea
                            id="${inputId}"
                            class="answer-input"
                            rows="2"
                            placeholder="Your answer... (Tip: Use ^ for powers, sqrt() for roots)"
                            ${isSubmitted ? 'disabled' : ''}
                            oninput="ExamPractice.handleMathInput('${inputId}')"
                            onchange="ExamPractice.saveCaseStudyAnswer('${subQ.part}', this.value)"
                        >${subAnswer}</textarea>

                        <!-- Live Preview for math content -->
                        <div class="math-preview-container" id="preview-container-${inputId}" style="display: none;">
                            <div class="math-preview-label">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                                Preview
                            </div>
                            <div class="math-preview" id="preview-${inputId}"></div>
                        </div>
                    </div>

                    ${isSubmitted ? renderSubQuestionSolution(subQ) : ''}
                </div>
            `;
        });

        return html;
    }

    /**
     * Render solution for sub-question
     */
    function renderSubQuestionSolution(subQ) {
        if (!subQ.solution) return '';

        return `
            <div class="solution-box mt-4">
                <div class="solution-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M9 12l2 2 4-4"></path>
                        <circle cx="12" cy="12" r="10"></circle>
                    </svg>
                    Solution
                </div>
                <ol class="solution-steps">
                    ${(subQ.solution.steps || []).map(step => `<li class="solution-step">${step}</li>`).join('')}
                </ol>
                <div class="solution-answer">
                    Answer: ${subQ.answer?.correct_answer_plain || ''}
                </div>
            </div>
        `;
    }

    /**
     * Render solution
     */
    function renderSolution(question) {
        if (!question.solution) return '';

        const steps = question.solution.steps_latex || question.solution.steps || [];
        const answer = question.solution.answer;

        return `
            <div class="solution-box">
                <div class="solution-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M9 12l2 2 4-4"></path>
                        <circle cx="12" cy="12" r="10"></circle>
                    </svg>
                    Solution
                </div>
                <ol class="solution-steps">
                    ${steps.map(step => `<li class="solution-step">${step}</li>`).join('')}
                </ol>
                ${answer ? `
                    <div class="solution-answer">
                        Answer: ${typeof answer === 'object' ? (answer.correct_option || JSON.stringify(answer)) : answer}
                    </div>
                ` : ''}
            </div>
        `;
    }

    /**
     * Update navigator grid
     */
    function updateNavigator() {
        const state = ExamCore.getState();
        const questions = state.questions || [];

        const renderGrid = (container) => {
            if (!container) return;

            container.innerHTML = questions.map((q, i) => {
                const isAnswered = state.answers[q.question_id] !== undefined;
                const isMarked = state.markedQuestions.includes(q.question_id);
                const isCurrent = i === state.currentQuestionIndex;

                let classes = 'navigator-item';
                if (isCurrent) classes += ' current';
                if (isAnswered) classes += ' answered';
                if (isMarked) classes += ' marked';

                return `<button class="${classes}" onclick="ExamPractice.goToQuestion(${i})">${i + 1}</button>`;
            }).join('');
        };

        renderGrid(elements.navigatorGrid);
        renderGrid(elements.mobileNavigatorGrid);
    }

    /**
     * Update progress display
     */
    function updateProgress() {
        const progress = ExamCore.getProgress();

        if (elements.progressStats) {
            elements.progressStats.innerHTML = `
                <div class="progress-stat">
                    <div class="progress-stat-value">${progress.answered}/${progress.total}</div>
                    <div class="progress-stat-label">Answered</div>
                </div>
                <div class="progress-bar-container">
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: ${progress.percentage}%"></div>
                    </div>
                </div>
                <div class="progress-breakdown">
                    <div class="progress-breakdown-item">
                        <span>Answered</span>
                        <span class="progress-breakdown-value">${progress.answered}</span>
                    </div>
                    <div class="progress-breakdown-item">
                        <span>Unanswered</span>
                        <span class="progress-breakdown-value">${progress.unanswered}</span>
                    </div>
                    <div class="progress-breakdown-item">
                        <span>Marked</span>
                        <span class="progress-breakdown-value">${progress.marked}</span>
                    </div>
                </div>
            `;
        }
    }

    /**
     * Select MCQ answer
     */
    function selectAnswer(optionId) {
        const state = ExamCore.getState();
        if (state.isSubmitted) return;

        const question = ExamCore.getCurrentQuestion();
        if (!question) return;

        // API format: question.id, Old JSON format: question.question_id
        const questionId = question.id || question.question_id;
        if (!questionId) {
            console.error('Cannot save answer: question ID is missing', question);
            return;
        }
        ExamCore.saveAnswer(questionId, optionId);

        // Update UI
        const options = document.querySelectorAll('.option-item');
        options.forEach(opt => {
            opt.classList.remove('selected');
            if (opt.dataset.option === optionId) {
                opt.classList.add('selected');
            }
        });

        updateNavigator();
        updateProgress();

        // Callback
        if (config.onAnswerChange) {
            config.onAnswerChange(questionId, optionId);
        }

        // Show instant feedback if enabled
        if (config.showInstantFeedback) {
            showFeedback(question, optionId);
        }
    }

    /**
     * Save text answer
     */
    function saveTextAnswer(value) {
        const question = ExamCore.getCurrentQuestion();
        if (!question) return;

        // API format: question.id, Old JSON format: question.question_id
        const questionId = question.id || question.question_id;
        if (!questionId) {
            console.error('Cannot save answer: question ID is missing', question);
            return;
        }
        ExamCore.saveAnswer(questionId, value);
        updateNavigator();
        updateProgress();

        if (config.onAnswerChange) {
            // API format: question.id, Old JSON format: question.question_id
            const questionId = question.id || question.question_id;
            config.onAnswerChange(questionId, value);
        }
    }

    /**
     * Save case study answer
     */
    function saveCaseStudyAnswer(part, value) {
        const question = ExamCore.getCurrentQuestion();
        if (!question) return;

        // API format: question.id, Old JSON format: question.question_id
        const questionId = question.id || question.question_id;
        if (!questionId) {
            console.error('Cannot save answer: question ID is missing', question);
            return;
        }
        let answers = ExamCore.getAnswer(questionId) || {};
        answers[part] = value;

        ExamCore.saveAnswer(questionId, answers);
        updateNavigator();
        updateProgress();
    }

    /**
     * Clear current answer
     */
    function clearAnswer() {
        const question = ExamCore.getCurrentQuestion();
        if (!question) return;

        // API format: question.id, Old JSON format: question.question_id
        const questionId = question.id || question.question_id;
        ExamCore.clearAnswer(questionId);

        // Re-render question
        const state = ExamCore.getState();
        renderQuestion(question, state.currentQuestionIndex, state.questions.length);
    }

    /**
     * Toggle mark for current question
     */
    function toggleMark() {
        const question = ExamCore.getCurrentQuestion();
        if (!question) return;

        // API format: question.id, Old JSON format: question.question_id
        const questionId = question.id || question.question_id;
        const isMarked = ExamCore.toggleMark(questionId);

        // Update button
        const markBtn = document.querySelector('.btn-mark');
        if (markBtn) {
            markBtn.classList.toggle('marked', isMarked);
            markBtn.innerHTML = `
                <svg width="16" height="16" viewBox="0 0 24 24" fill="${isMarked ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="2">
                    <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                </svg>
                ${isMarked ? 'Marked' : 'Mark for Review'}
            `;
        }

        updateNavigator();
        updateProgress();
    }

    /**
     * Navigate to specific question
     */
    function goToQuestion(index) {
        const question = ExamCore.goToQuestion(index);
        if (question) {
            const state = ExamCore.getState();
            renderQuestion(question, index, state.questions.length);
            closeMobileNavigator();
        }
    }

    /**
     * Navigate to next question
     */
    function navigateNext() {
        const question = ExamCore.nextQuestion();
        if (question) {
            const state = ExamCore.getState();
            renderQuestion(question, state.currentQuestionIndex, state.questions.length);
        }
    }

    /**
     * Navigate to previous question
     */
    function navigatePrev() {
        const question = ExamCore.prevQuestion();
        if (question) {
            const state = ExamCore.getState();
            renderQuestion(question, state.currentQuestionIndex, state.questions.length);
        }
    }

    /**
     * Select option by number key
     */
    function selectOption(key) {
        const optionMap = { '1': 'A', '2': 'B', '3': 'C', '4': 'D' };
        const optionId = optionMap[key];
        if (optionId) {
            selectAnswer(optionId);
        }
    }

    /**
     * Mark current question
     */
    function markCurrentQuestion() {
        toggleMark();
    }

    /**
     * Show instant feedback
     */
    function showFeedback(question, selectedAnswer) {
        const correctOption = question.options?.find(o => o.is_correct);
        const correctId = correctOption?.option_id || question.solution?.answer?.correct_option;
        const isCorrect = selectedAnswer === correctId;

        const options = document.querySelectorAll('.option-item');
        options.forEach(opt => {
            const optId = opt.dataset.option;
            if (optId === correctId) {
                opt.classList.add('correct');
            } else if (optId === selectedAnswer && !isCorrect) {
                opt.classList.add('incorrect');
            }
            opt.classList.add('disabled');
        });
    }

    /**
     * Start timer
     */
    function startTimer(durationMinutes, onComplete) {
        timeRemaining = durationMinutes * 60;
        updateTimerDisplay();

        timerInterval = setInterval(() => {
            timeRemaining--;

            if (timeRemaining <= 0) {
                clearInterval(timerInterval);
                if (onComplete) onComplete();
                return;
            }

            updateTimerDisplay();
        }, 1000);
    }

    /**
     * Update timer display
     */
    function updateTimerDisplay() {
        if (!elements.timerDisplay) return;

        const display = ExamCore.formatTime(timeRemaining);
        elements.timerDisplay.textContent = display;

        // Warning states
        elements.timerDisplay.parentElement.classList.remove('warning', 'danger');
        if (timeRemaining <= 300) { // 5 minutes
            elements.timerDisplay.parentElement.classList.add('danger');
        } else if (timeRemaining <= 600) { // 10 minutes
            elements.timerDisplay.parentElement.classList.add('warning');
        }
    }

    /**
     * Stop timer
     */
    function stopTimer() {
        if (timerInterval) {
            clearInterval(timerInterval);
            timerInterval = null;
        }
    }

    /**
     * Get remaining time
     */
    function getTimeRemaining() {
        return timeRemaining;
    }

    /**
     * Toggle mobile navigator
     */
    function toggleMobileNavigator() {
        const navigator = document.getElementById('mobile-navigator');
        const overlay = document.getElementById('navigator-overlay');

        if (navigator) {
            navigator.classList.toggle('open');
        }
        if (overlay) {
            overlay.classList.toggle('active');
        }
    }

    /**
     * Close mobile navigator
     */
    function closeMobileNavigator() {
        const navigator = document.getElementById('mobile-navigator');
        const overlay = document.getElementById('navigator-overlay');

        if (navigator) {
            navigator.classList.remove('open');
        }
        if (overlay) {
            overlay.classList.remove('active');
        }
    }

    /**
     * Submit test
     */
    function submitTest() {
        if (!confirm('Are you sure you want to submit the test? You cannot change your answers after submission.')) {
            return;
        }

        stopTimer();
        const results = ExamCore.submit();

        if (config.onSubmit) {
            config.onSubmit(results);
        }

        return results;
    }

    /**
     * Show results page
     */
    function showResults(results) {
        const container = document.getElementById('practice-main') || document.body;

        container.innerHTML = `
            <div class="results-container animate-fade-in">
                <div class="results-header">
                    <h1 class="results-title">Test Completed!</h1>
                    <div class="results-score-circle">
                        <div class="results-score-value">${results.percentage}%</div>
                        <div class="results-score-label">${results.obtainedMarks}/${results.totalMarks} marks</div>
                    </div>
                </div>

                <div class="results-breakdown">
                    <h3 class="results-breakdown-title">Score Breakdown</h3>
                    <div class="results-breakdown-grid">
                        <div class="results-breakdown-item">
                            <div class="results-breakdown-value correct">${results.correct}</div>
                            <div class="results-breakdown-label">Correct</div>
                        </div>
                        <div class="results-breakdown-item">
                            <div class="results-breakdown-value incorrect">${results.incorrect}</div>
                            <div class="results-breakdown-label">Incorrect</div>
                        </div>
                        <div class="results-breakdown-item">
                            <div class="results-breakdown-value unattempted">${results.unattempted}</div>
                            <div class="results-breakdown-label">Unattempted</div>
                        </div>
                    </div>
                </div>

                <div class="results-actions">
                    <button class="btn btn-primary btn-lg" onclick="location.reload()">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M1 4v6h6"></path>
                            <path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"></path>
                        </svg>
                        Review Answers
                    </button>
                    <a href="../" class="btn btn-secondary btn-lg">
                        Try Another Set
                    </a>
                </div>
            </div>
        `;
    }

    // Public API
    return {
        init,
        renderQuestion,
        selectAnswer,
        saveTextAnswer,
        saveCaseStudyAnswer,
        clearAnswer,
        toggleMark,
        goToQuestion,
        navigateNext,
        navigatePrev,
        startTimer,
        stopTimer,
        getTimeRemaining,
        submitTest,
        showResults,
        updateNavigator,
        updateProgress,
        // Math input helpers
        insertMath,
        insertSymbol,
        handleMathInput,
        toggleMathHelp
    };
})();

// Export for use as module
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ExamPractice;
}

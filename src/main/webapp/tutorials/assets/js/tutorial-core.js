/**
 * 8gwifi.org Tutorial Platform - Main JavaScript
 * Handles: Theme toggle, Sidebar, Code Editor, Live Preview
 */

(function () {
    'use strict';
    console.log('Tutorial JS executing...');
    window.TUTORIAL_CORE_LOADED = true;

    // ============================================
    // THEME MANAGEMENT
    // ============================================
    function getStorageItem(key) {
        try {
            return localStorage.getItem(key);
        } catch (e) {
            console.warn('LocalStorage access denied:', e);
            return null;
        }
    }

    function setStorageItem(key, value) {
        try {
            localStorage.setItem(key, value);
        } catch (e) {
            console.warn('LocalStorage access denied:', e);
        }
    }

    function initTheme() {
        const theme = getStorageItem('tutorial-theme');
        const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;

        if (theme === 'dark' || (!theme && prefersDark)) {
            document.documentElement.setAttribute('data-theme', 'dark');
            updateThemeIcons(true);
        } else {
            updateThemeIcons(false);
        }

        // Listen for system theme changes
        if (window.matchMedia) {
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function (e) {
                if (!getStorageItem('tutorial-theme')) {
                    if (e.matches) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                        updateThemeIcons(true);
                    } else {
                        document.documentElement.removeAttribute('data-theme');
                        updateThemeIcons(false);
                    }
                }
            });
        }
    }

    function updateThemeIcons(isDark) {
        const lightIcon = document.querySelector('.theme-icon-light');
        const darkIcon = document.querySelector('.theme-icon-dark');

        if (lightIcon && darkIcon) {
            lightIcon.style.display = isDark ? 'block' : 'none';
            darkIcon.style.display = isDark ? 'none' : 'block';
        }
    }

    window.toggleTheme = function () {
        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        if (isDark) {
            document.documentElement.removeAttribute('data-theme');
            setStorageItem('tutorial-theme', 'light');
            updateThemeIcons(false);
        } else {
            document.documentElement.setAttribute('data-theme', 'dark');
            setStorageItem('tutorial-theme', 'dark');
            updateThemeIcons(true);
        }

        // Update CodeMirror theme if editors exist
        if (window.tutorialEditors) {
            Object.values(window.tutorialEditors).forEach(function (editor) {
                // Handle both single editors and grouped editors
                if (editor && typeof editor.setOption === 'function') {
                    editor.setOption('theme', isDark ? 'default' : 'monokai');
                } else if (editor && editor.html) {
                    // Grouped editor
                    if (editor.html) editor.html.setOption('theme', isDark ? 'default' : 'monokai');
                    if (editor.css) editor.css.setOption('theme', isDark ? 'default' : 'monokai');
                    if (editor.js) editor.js.setOption('theme', isDark ? 'default' : 'monokai');
                }
            });
        }
    };

    // ============================================
    // SIDEBAR MANAGEMENT
    // ============================================
    window.toggleSidebar = function () {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');

        if (sidebar) {
            sidebar.classList.toggle('open');
        }
        if (overlay) {
            overlay.classList.toggle('active');
        }

        // Prevent body scroll when sidebar is open on mobile
        document.body.style.overflow = sidebar && sidebar.classList.contains('open') ? 'hidden' : '';
    };

    // Close sidebar on escape key
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            const sidebar = document.getElementById('sidebar');
            if (sidebar && sidebar.classList.contains('open')) {
                toggleSidebar();
            }
        }
    });

    // ============================================
    // CODE EDITOR MANAGEMENT
    // ============================================
    window.tutorialEditors = {};

    window.initCodeEditor = function (elementId, options) {
        options = options || {};
        const element = document.getElementById(elementId);

        if (!element || typeof CodeMirror === 'undefined') {
            console.warn('CodeMirror not available or element not found:', elementId);
            return null;
        }

        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        const editor = CodeMirror.fromTextArea(element, {
            mode: options.mode || 'htmlmixed',
            theme: isDark ? 'monokai' : 'default',
            lineNumbers: true,
            lineWrapping: true,
            indentUnit: 2,
            tabSize: 2,
            indentWithTabs: false,
            autoCloseTags: true,
            autoCloseBrackets: true,
            matchBrackets: true,
            readOnly: options.readOnly || false
        });

        editor.setSize(null, options.height || 200);

        // Store reference
        window.tutorialEditors[elementId] = editor;

        // Auto-run preview on change (debounced)
        let timeout;
        editor.on('change', function () {
            clearTimeout(timeout);
            timeout = setTimeout(function () {
                // Check if this editor belongs to a group (e.g., editor-editors-html-code -> editor-editors)
                const groupId = elementId.replace(/-html-code$/, '').replace(/-css-code$/, '').replace(/-js-code$/, '');
                if (groupId !== elementId && window.tutorialEditors[groupId] && window.tutorialEditors[groupId].html) {
                    runEditorGroupPreview(groupId);
                } else {
                    runCodePreview(elementId);
                }
            }, 500);
        });

        // Initial preview (only for standalone editors, grouped editors handle their own)
        if (!elementId.endsWith('-html-code') && !elementId.endsWith('-css-code') && !elementId.endsWith('-js-code')) {
            setTimeout(function () {
                runCodePreview(elementId);
            }, 100);
        }

        return editor;
    };

    window.runCodePreview = function (editorId) {
        const editor = window.tutorialEditors[editorId];
        if (!editor) return;

        const code = editor.getValue();
        const previewFrame = document.getElementById('previewFrame');
        const mobilePreviewFrame = document.getElementById('mobilePreviewFrame');

        // Create HTML document
        const html = code.includes('<!DOCTYPE') || code.includes('<html') ? code :
            '<!DOCTYPE html><html><head><meta charset="UTF-8"><style>body{font-family:sans-serif;padding:16px;}</style></head><body>' + code + '</body></html>';

        // Update desktop preview
        if (previewFrame) {
            previewFrame.srcdoc = html;
        }

        // Update mobile preview if open
        if (mobilePreviewFrame) {
            mobilePreviewFrame.srcdoc = html;
        }
    };

    window.refreshPreview = function () {
        // Re-run the first editor's preview
        const editorIds = Object.keys(window.tutorialEditors);
        for (let i = 0; i < editorIds.length; i++) {
            const id = editorIds[i];
            // Find a grouped editor (has .html property) or standalone
            if (window.tutorialEditors[id] && window.tutorialEditors[id].html) {
                runEditorGroupPreview(id);
                return;
            }
        }
        // Fallback to first single editor
        if (editorIds.length > 0) {
            runCodePreview(editorIds[0]);
        }
    };

    window.resetCode = function (editorId, originalCode) {
        const editor = window.tutorialEditors[editorId];
        if (editor && originalCode) {
            editor.setValue(originalCode);
            runCodePreview(editorId);
        }
    };

    window.copyCode = function (editorId) {
        const editor = window.tutorialEditors[editorId];
        if (!editor) return;

        const code = editor.getValue();
        navigator.clipboard.writeText(code).then(function () {
            // Show feedback (you can enhance this)
            alert('Code copied to clipboard!');
        }).catch(function (err) {
            console.error('Failed to copy:', err);
        });
    };

    // ============================================
    // MOBILE PREVIEW
    // ============================================
    window.openMobilePreview = function () {
        const mobilePreview = document.getElementById('mobilePreview');
        if (mobilePreview) {
            mobilePreview.classList.add('open');
            document.body.style.overflow = 'hidden';

            // Sync preview content - find first grouped or single editor
            const editorIds = Object.keys(window.tutorialEditors);
            for (let i = 0; i < editorIds.length; i++) {
                const id = editorIds[i];
                if (window.tutorialEditors[id] && window.tutorialEditors[id].html) {
                    runEditorGroupPreview(id);
                    return;
                }
            }
            // Fallback to single editor
            if (editorIds.length > 0) {
                runCodePreview(editorIds[0]);
            }
        }
    };

    window.closeMobilePreview = function () {
        const mobilePreview = document.getElementById('mobilePreview');
        if (mobilePreview) {
            mobilePreview.classList.remove('open');
            document.body.style.overflow = '';
        }
    };

    // ============================================
    // PROGRESS MANAGEMENT
    // ============================================

    // Detect current tutorial from URL path
    function getCurrentTutorial() {
        const path = window.location.pathname;
        const match = path.match(/\/tutorials\/([^\/]+)\//);
        return match ? match[1] : 'html';
    }

    function updateProgressUI() {
        if (typeof TutorialProgress === 'undefined') return;

        const tutorial = getCurrentTutorial();
        const progress = TutorialProgress.getProgress(tutorial);
        const percent = progress.total > 0 ? Math.round((progress.completed / progress.total) * 100) : 0;

        // Update header progress bar
        const progressFill = document.getElementById('progressFill');
        const progressText = document.getElementById('progressText');

        if (progressFill) {
            progressFill.style.width = percent + '%';
        }
        if (progressText) {
            progressText.textContent = percent + '%';
        }

        // Update sidebar checkmarks
        const completedLessons = TutorialProgress.getCompletedLessons(tutorial);
        completedLessons.forEach(function (lessonId) {
            const navLink = document.querySelector('.nav-link[data-lesson="' + lessonId + '"]');
            if (navLink) {
                navLink.classList.add('completed');
            }
            const statusIcon = document.querySelector('[data-status="' + lessonId + '"]');
            if (statusIcon) {
                statusIcon.style.display = 'block';
            }
        });
    }

    // ============================================
    // QUIZ MANAGEMENT
    // ============================================
    window.checkQuizAnswer = function (questionId, selectedIndex, correctIndex) {
        const options = document.querySelectorAll('[data-question="' + questionId + '"]');

        options.forEach(function (option, index) {
            option.classList.remove('selected');

            if (index === selectedIndex) {
                option.classList.add('selected');
                if (index === correctIndex) {
                    option.classList.add('correct');
                } else {
                    option.classList.add('incorrect');
                }
            }

            if (index === correctIndex) {
                option.classList.add('correct');
            }
        });

        // Return result
        return selectedIndex === correctIndex;
    };

    // ============================================
    // EDITOR COMPONENT HELPERS
    // ============================================
    window.initEditor = function (editorId) {
        // Initialize HTML editor by default
        const htmlEditor = initCodeEditor(editorId + '-html-code', { mode: 'htmlmixed', height: 280 });

        // Initialize CSS and JS editors if they exist (lazy load or init hidden)
        // For now we init them all but they are hidden
        const cssEditor = initCodeEditor(editorId + '-css-code', { mode: 'css', height: 280 });
        const jsEditor = initCodeEditor(editorId + '-js-code', { mode: 'javascript', height: 280 });

        // Store group reference
        window.tutorialEditors[editorId] = {
            html: htmlEditor,
            css: cssEditor,
            js: jsEditor
        };

        // Run initial preview for this editor
        setTimeout(function() {
            runEditorGroupPreview(editorId);
        }, 150);
    };

    // Preview function for grouped editors (HTML/CSS/JS tabs)
    function runEditorGroupPreview(editorId) {
        const group = window.tutorialEditors[editorId];
        if (!group || !group.html) return;

        const html = group.html.getValue();
        const css = group.css ? group.css.getValue() : '';
        const js = group.js ? group.js.getValue() : '';

        const previewFrame = document.getElementById('previewFrame');
        const mobilePreviewFrame = document.getElementById('mobilePreviewFrame');

        // Build document - if HTML already has DOCTYPE/html structure, inject CSS/JS; otherwise wrap it
        let doc;
        if (html.includes('<!DOCTYPE') || html.includes('<html')) {
            // Insert CSS before </head> and JS before </body> if they exist
            doc = html;
            if (css && doc.includes('</head>')) {
                doc = doc.replace('</head>', '<style>' + css + '</style></head>');
            }
            if (js && doc.includes('</body>')) {
                doc = doc.replace('</body>', '<script>' + js + '<\/script></body>');
            }
        } else {
            doc = '<!DOCTYPE html><html><head><meta charset="UTF-8"><style>body{font-family:sans-serif;padding:16px;}' + css + '</style></head><body>' + html + '<script>' + js + '<\/script></body></html>';
        }

        if (previewFrame) {
            previewFrame.srcdoc = doc;
        }
        if (mobilePreviewFrame) {
            mobilePreviewFrame.srcdoc = doc;
        }
    }

    window.switchTab = function (editorId, tab) {
        // Update tab UI
        const container = document.getElementById(editorId + '-container');
        if (!container) return;

        const tabs = container.querySelectorAll('.editor-tab');
        tabs.forEach(t => {
            if (t.dataset.tab === tab) t.classList.add('active');
            else t.classList.remove('active');
        });

        // Show/Hide panes
        const panes = container.querySelectorAll('.code-pane');
        panes.forEach(p => p.style.display = 'none');

        const activePane = document.getElementById(editorId + '-' + tab);
        if (activePane) {
            activePane.style.display = 'block';
            // Refresh CodeMirror layout
            const editorGroup = window.tutorialEditors[editorId];
            if (editorGroup && editorGroup[tab]) {
                editorGroup[tab].refresh();
            }
        }
    };
    console.log('switchTab defined');

    window.runCode = function (editorId) {
        // Check if it's a grouped editor (from tutorial-editor.jsp)
        if (window.tutorialEditors[editorId] && window.tutorialEditors[editorId].html) {
            runEditorGroupPreview(editorId);
        } else {
            // Single editor (from introduction.jsp style)
            runCodePreview(editorId);
        }
    };

    // ============================================
    // INITIALIZATION
    // ============================================
    document.addEventListener('DOMContentLoaded', function () {
        initTheme();
        updateProgressUI();

        // Mark current lesson as in progress
        const currentLesson = document.body.getAttribute('data-lesson');
        const tutorial = getCurrentTutorial();
        if (currentLesson && typeof TutorialProgress !== 'undefined') {
            TutorialProgress.setLastLesson('/tutorials/' + tutorial + '/' + currentLesson + '.jsp');
        }
    });

})();

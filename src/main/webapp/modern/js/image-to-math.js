/**
 * Image to Math — shared component for all math calculator tools.
 *
 * Two-step pipeline:
 *   1. OCR (glm-ocr via /ai?action=ocr) → raw text from image
 *   2. AI parse (qwen-coder via /ai) → structured JSON array of problems
 *
 * Shows a picker modal where user selects which problem to solve.
 * Each math tool provides its own extraction prompt and fill callback.
 *
 * Usage:
 *   ImageToMath.init({
 *       buttonId: 'my-camera-btn',
 *       aiUrl: '/ctx/ai',
 *       extractionPrompt: 'Extract integral expressions...',
 *       onSelect: function(problem) { fillInput(problem.expr); },
 *       onSolveAll: function(problems) { batchSolve(problems); }  // optional
 *   });
 */
;(function (win) {
    'use strict';

    var overlay = null;
    var initialized = false;
    var config = {};
    var els = {};
    var imageData = null;
    var problems = [];
    var busy = false;
    var abortCtrl = null;

    var ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/bmp'];
    var MAX_SIZE_BYTES = 10 * 1024 * 1024;
    var quoteTimer = null;

    var QUOTES = [
        // Scientists & Mathematicians
        { text: 'The book of nature is written in the language of mathematics.', author: 'Galileo Galilei' },
        { text: 'Mathematics is the queen of the sciences.', author: 'Carl Friedrich Gauss' },
        { text: 'Pure mathematics is, in its way, the poetry of logical ideas.', author: 'Albert Einstein' },
        { text: 'The essence of mathematics lies in its freedom.', author: 'Georg Cantor' },
        { text: 'Do not worry about your difficulties in mathematics. I can assure you mine are still greater.', author: 'Albert Einstein' },
        { text: 'God used beautiful mathematics in creating the world.', author: 'Paul Dirac' },
        { text: 'The only way to learn mathematics is to do mathematics.', author: 'Paul Halmos' },
        { text: 'Without mathematics, there\'s nothing you can do. Everything around you is mathematics.', author: 'Shakuntala Devi' },
        { text: 'If people do not believe that mathematics is simple, it is only because they do not realize how complicated life is.', author: 'John von Neumann' },
        { text: 'Mathematics is the music of reason.', author: 'James Joseph Sylvester' },
        { text: 'It is not enough to have a good mind; the main thing is to use it well.', author: 'Ren\u00e9 Descartes' },
        { text: 'The laws of nature are but the mathematical thoughts of God.', author: 'Euclid' },
        { text: 'Imagination is more important than knowledge.', author: 'Albert Einstein' },
        { text: 'An equation means nothing to me unless it expresses a thought of God.', author: 'Srinivasa Ramanujan' },
        { text: 'No great discovery was ever made without a bold guess.', author: 'Isaac Newton' },
        // Motivational
        { text: 'The expert in anything was once a beginner.', author: 'Helen Hayes' },
        { text: 'It always seems impossible until it\'s done.', author: 'Nelson Mandela' },
        { text: 'The secret of getting ahead is getting started.', author: 'Mark Twain' },
        { text: 'Success is not final, failure is not fatal: it is the courage to continue that counts.', author: 'Winston Churchill' },
        { text: 'What we know is a drop, what we don\'t know is an ocean.', author: 'Isaac Newton' },
        { text: 'The beautiful thing about learning is that nobody can take it away from you.', author: 'B.B. King' },
        { text: 'Education is the most powerful weapon which you can use to change the world.', author: 'Nelson Mandela' },
        { text: 'The mind is not a vessel to be filled, but a fire to be kindled.', author: 'Plutarch' },
        { text: 'Genius is one percent inspiration and ninety-nine percent perspiration.', author: 'Thomas Edison' },
        { text: 'The best way to predict the future is to create it.', author: 'Abraham Lincoln' },
        { text: 'In the middle of difficulty lies opportunity.', author: 'Albert Einstein' },
        { text: 'Stay hungry, stay foolish.', author: 'Steve Jobs' },
        { text: 'I have not failed. I\'ve just found 10,000 ways that won\'t work.', author: 'Thomas Edison' },
        { text: 'The important thing is not to stop questioning.', author: 'Albert Einstein' },
        { text: 'Every problem is a gift. Without problems we would not grow.', author: 'Tony Robbins' },
        // Famous figures
        { text: 'I think, therefore I am.', author: 'Ren\u00e9 Descartes' },
        { text: 'The unexamined life is not worth living.', author: 'Socrates' },
        { text: 'Knowledge is power.', author: 'Francis Bacon' },
        { text: 'I know that I know nothing.', author: 'Socrates' },
        { text: 'Simplicity is the ultimate sophistication.', author: 'Leonardo da Vinci' },
        { text: 'Logic will get you from A to B. Imagination will take you everywhere.', author: 'Albert Einstein' },
        { text: 'Live as if you were to die tomorrow. Learn as if you were to live forever.', author: 'Mahatma Gandhi' },
        { text: 'The only true wisdom is in knowing you know nothing.', author: 'Socrates' },
        { text: 'If you can dream it, you can do it.', author: 'Walt Disney' },
        { text: 'Be the change you wish to see in the world.', author: 'Mahatma Gandhi' },
        { text: 'Strive not to be a success, but rather to be of value.', author: 'Albert Einstein' },
        { text: 'The only limit to our realization of tomorrow is our doubts of today.', author: 'Franklin D. Roosevelt' },
        { text: 'Curiosity is the wick in the candle of learning.', author: 'William Arthur Ward' },
        { text: 'Tell me and I forget. Teach me and I remember. Involve me and I learn.', author: 'Benjamin Franklin' },
        // Sports legends
        { text: 'I\'ve missed more than 9000 shots in my career. I\'ve failed over and over again. And that is why I succeed.', author: 'Michael Jordan' },
        { text: 'It\'s not whether you get knocked down, it\'s whether you get up.', author: 'Vince Lombardi' },
        { text: 'You miss 100% of the shots you don\'t take.', author: 'Wayne Gretzky' },
        { text: 'Hard work beats talent when talent doesn\'t work hard.', author: 'Tim Notke' },
        { text: 'The more difficult the victory, the greater the happiness in winning.', author: 'Pel\u00e9' },
        { text: 'Champions keep playing until they get it right.', author: 'Billie Jean King' },
        { text: 'You have to expect things of yourself before you can do them.', author: 'Michael Jordan' },
        { text: 'The only way to prove you are a good sport is to lose.', author: 'Ernie Banks' },
        { text: 'It ain\'t over till it\'s over.', author: 'Yogi Berra' },
        { text: 'Don\'t count the days, make the days count.', author: 'Muhammad Ali' },
        { text: 'I am the greatest. I said that even before I knew I was.', author: 'Muhammad Ali' },
        { text: 'Persistence can change failure into extraordinary achievement.', author: 'Marv Levy' },
        { text: 'The man who has no imagination has no wings.', author: 'Muhammad Ali' },
        { text: 'If you aren\'t going all the way, why go at all?', author: 'Joe Namath' },
        { text: 'Age is no barrier. It\'s a limitation you put on your mind.', author: 'Jackie Joyner-Kersee' }
    ];

    // ═══════════════════════════════════════
    // INIT
    // ═══════════════════════════════════════

    function init(opts) {
        config = {
            aiUrl: opts.aiUrl || '',
            extractionPrompt: opts.extractionPrompt || '',
            onSelect: opts.onSelect || function () {},
            onSolveAll: opts.onSolveAll || null,
            toolName: opts.toolName || 'Calculator'
        };

        if (!initialized) {
            createModal();
            setupGlobalListeners();
            initialized = true;
        }

        // Wire button
        if (opts.buttonId) {
            var btn = document.getElementById(opts.buttonId);
            if (btn) btn.addEventListener('click', open);
        }
    }

    // ═══════════════════════════════════════
    // MODAL
    // ═══════════════════════════════════════

    function createModal() {
        overlay = document.createElement('div');
        overlay.id = 'itm-overlay';
        overlay.className = 'itm-overlay';
        overlay.style.display = 'none';
        overlay.innerHTML =
            '<div class="itm-modal">' +
            '  <div class="itm-header">' +
            '    <span class="itm-title">&#128247; Scan Problem from Image</span>' +
            '    <button class="itm-close" data-action="close">&times;</button>' +
            '  </div>' +
            '  <div class="itm-body">' +
            // Step 1: Upload
            '    <div class="itm-step" id="itm-step-upload">' +
            '      <div class="itm-dropzone" data-action="browse">' +
            '        <div class="itm-dropzone-icon">&#128444;</div>' +
            '        <div class="itm-dropzone-text">Drop image, paste (Ctrl+V), or <span class="itm-browse">browse</span></div>' +
            '        <div class="itm-dropzone-hint">Photo of textbook, whiteboard, homework &bull; Max 10MB</div>' +
            '      </div>' +
            '      <input type="file" class="itm-file-input" accept="image/*" />' +
            '      <div class="itm-url-row">' +
            '        <div class="itm-url-divider"><span>or load from URL</span></div>' +
            '        <div class="itm-url-input-row">' +
            '          <input type="url" class="itm-url-input" placeholder="https://example.com/equation.png" />' +
            '          <button class="itm-url-btn" data-action="load-url">Load</button>' +
            '        </div>' +
            '      </div>' +
            '      <div class="itm-preview" style="display:none;">' +
            '        <img class="itm-preview-img" />' +
            '        <div class="itm-preview-info"></div>' +
            '        <button class="itm-remove" data-action="remove">&times;</button>' +
            '      </div>' +
            '      <div class="itm-error" style="display:none;"></div>' +
            '      <button class="itm-scan-btn" data-action="scan" disabled>Scan Image</button>' +
            '    </div>' +
            // Step 2: Processing
            '    <div class="itm-step" id="itm-step-processing" style="display:none;">' +
            '      <div class="itm-processing">' +
            '        <div class="itm-spinner"></div>' +
            '        <div class="itm-processing-text">Analyzing image&hellip;</div>' +
            '        <div class="itm-quote">' +
            '          <div class="itm-quote-text"></div>' +
            '          <div class="itm-quote-author"></div>' +
            '        </div>' +
            '      </div>' +
            '    </div>' +
            // Step 3: Pick problem
            '    <div class="itm-step" id="itm-step-pick" style="display:none;">' +
            '      <div class="itm-pick-header">Found <span class="itm-pick-count"></span> problem(s) in image</div>' +
            '      <div class="itm-pick-list"></div>' +
            '      <div class="itm-pick-actions">' +
            '        <button class="itm-btn-primary" data-action="solve-selected" disabled>Solve</button>' +
            '        <button class="itm-btn" data-action="back">&#8592; Scan Another</button>' +
            '      </div>' +
            '    </div>' +
            '  </div>' +
            '</div>';

        document.body.insertBefore(overlay, document.body.firstChild);

        // Cache DOM refs
        els.dropzone = overlay.querySelector('.itm-dropzone');
        els.fileInput = overlay.querySelector('.itm-file-input');
        els.preview = overlay.querySelector('.itm-preview');
        els.previewImg = overlay.querySelector('.itm-preview-img');
        els.previewInfo = overlay.querySelector('.itm-preview-info');
        els.error = overlay.querySelector('.itm-error');
        els.scanBtn = overlay.querySelector('[data-action="scan"]');
        els.stepUpload = document.getElementById('itm-step-upload');
        els.stepProcessing = document.getElementById('itm-step-processing');
        els.stepPick = document.getElementById('itm-step-pick');
        els.processingText = overlay.querySelector('.itm-processing-text');
        els.pickCount = overlay.querySelector('.itm-pick-count');
        els.pickList = overlay.querySelector('.itm-pick-list');

        // Event delegation
        overlay.addEventListener('click', function (e) {
            var target = e.target.closest('[data-action]');
            if (!target) {
                if (e.target === overlay) close();
                return;
            }
            var action = target.getAttribute('data-action');
            switch (action) {
                case 'close': close(); break;
                case 'browse': els.fileInput.click(); break;
                case 'remove': clearImage(); break;
                case 'scan': doScan(); break;
                case 'solve-selected': doSolveSelected(); break;
                case 'load-url': doLoadUrl(); break;
                case 'back': showStep('upload'); clearImage(); break;
                case 'select-problem': toggleProblem(target); break;
            }
        });

        els.fileInput.addEventListener('change', function (e) {
            if (e.target.files && e.target.files[0]) handleFile(e.target.files[0]);
            e.target.value = '';
        });

        // Drag and drop
        els.dropzone.addEventListener('dragover', function (e) { e.preventDefault(); els.dropzone.classList.add('dragover'); });
        els.dropzone.addEventListener('dragleave', function () { els.dropzone.classList.remove('dragover'); });
        els.dropzone.addEventListener('drop', function (e) {
            e.preventDefault(); els.dropzone.classList.remove('dragover');
            if (e.dataTransfer.files && e.dataTransfer.files[0]) handleFile(e.dataTransfer.files[0]);
        });
    }

    function setupGlobalListeners() {
        // Paste
        document.addEventListener('paste', function (e) {
            if (overlay.style.display === 'none') return;
            var items = e.clipboardData ? e.clipboardData.items : [];
            for (var i = 0; i < items.length; i++) {
                if (items[i].type.indexOf('image') !== -1) {
                    e.preventDefault();
                    handleFile(items[i].getAsFile());
                    return;
                }
            }
        });
        // Escape
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && overlay.style.display !== 'none') close();
        });
    }

    // ═══════════════════════════════════════
    // FILE HANDLING
    // ═══════════════════════════════════════

    function handleFile(file) {
        hideError();
        if (ALLOWED_TYPES.indexOf(file.type) === -1) { showError('Use JPEG, PNG, or WEBP.'); return; }
        if (file.size > MAX_SIZE_BYTES) { showError('Image too large. Max 10MB.'); return; }

        var reader = new FileReader();
        reader.onload = function (e) {
            var dataUrl = e.target.result;
            var base64 = dataUrl.split(',')[1];
            if (!base64) { showError('Could not read image.'); return; }
            imageData = { base64: base64, dataUrl: dataUrl, name: file.name || 'pasted-image', size: file.size, type: file.type };
            showPreview();
        };
        reader.onerror = function () { showError('Failed to read file.'); };
        reader.readAsDataURL(file);
    }

    function doLoadUrl() {
        var urlInput = overlay.querySelector('.itm-url-input');
        var url = urlInput ? urlInput.value.trim() : '';
        if (!url) { showError('Enter an image URL.'); return; }
        if (!/^https?:\/\/.+/i.test(url)) { showError('Enter a valid URL starting with http:// or https://'); return; }

        hideError();
        urlInput.disabled = true;
        var btn = overlay.querySelector('.itm-url-btn');
        if (btn) { btn.disabled = true; btn.textContent = 'Loading\u2026'; }

        // Fetch image as blob → convert to base64
        fetch(url, { mode: 'cors' })
            .then(function (res) {
                if (!res.ok) throw new Error('Could not load image (HTTP ' + res.status + ')');
                var ct = res.headers.get('content-type') || '';
                if (ct.indexOf('image') === -1) throw new Error('URL does not point to an image');
                return res.blob();
            })
            .then(function (blob) {
                if (blob.size > MAX_SIZE_BYTES) throw new Error('Image too large (' + (blob.size / 1024 / 1024).toFixed(1) + 'MB). Max 10MB.');
                // Convert blob to File and use existing handleFile
                var file = new File([blob], 'from-url.png', { type: blob.type || 'image/png' });
                handleFile(file);
            })
            .catch(function (err) {
                showError(err.message || 'Failed to load image from URL.');
            })
            .finally(function () {
                if (urlInput) urlInput.disabled = false;
                if (btn) { btn.disabled = false; btn.textContent = 'Load'; }
            });
    }

    function showPreview() {
        els.dropzone.style.display = 'none';
        var urlRow = overlay.querySelector('.itm-url-row');
        if (urlRow) urlRow.style.display = 'none';
        els.preview.style.display = 'flex';
        els.previewImg.src = imageData.dataUrl;
        els.previewInfo.textContent = imageData.name + ' \u2022 ' + (imageData.size / 1024).toFixed(0) + 'KB';
        els.scanBtn.disabled = false;
    }

    function clearImage() {
        imageData = null;
        els.dropzone.style.display = '';
        var urlRow = overlay.querySelector('.itm-url-row');
        if (urlRow) urlRow.style.display = '';
        els.preview.style.display = 'none';
        els.scanBtn.disabled = true;
        hideError();
    }

    // ═══════════════════════════════════════
    // TWO-STEP PIPELINE
    // ═══════════════════════════════════════

    function doScan() {
        if (!imageData || busy) return;
        busy = true;
        if (abortCtrl) abortCtrl.abort();
        abortCtrl = new AbortController();

        showStep('processing');
        els.processingText.textContent = 'Reading image\u2026';

        // Step 1: OCR
        fetch(config.aiUrl + '?action=ocr', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ image: imageData.base64, mode: 'text', stream: false }),
            signal: abortCtrl.signal
        })
        .then(function (res) {
            if (!res.ok) return res.json().then(function (d) { throw new Error(d.error || 'Image scan failed'); });
            return res.json();
        })
        .then(function (data) {
            var ocrText = data.response || '';
            if (!ocrText.trim()) throw new Error('No text found in image.');

            els.processingText.textContent = 'Extracting problems\u2026';

            // Step 2: AI parse — extract structured problems
            return fetch(config.aiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    messages: [
                        { role: 'system', content: config.extractionPrompt },
                        { role: 'user', content: 'Extract problems from this text:\n\n' + ocrText }
                    ],
                    stream: false
                }),
                signal: abortCtrl.signal
            });
        })
        .then(function (res) {
            if (!res.ok) return res.json().then(function (d) { throw new Error(d.error || 'Parse failed'); });
            return res.json();
        })
        .then(function (data) {
            var content = '';
            if (data.message && data.message.content) content = data.message.content;
            else if (data.response) content = data.response;
            if (!content) throw new Error('Could not parse problems from image.');

            // Clean and parse JSON
            content = content.replace(/<think>[\s\S]*?<\/think>/g, '').trim();
            content = content.replace(/^```(?:json)?\n?/gm, '').replace(/```\s*$/gm, '').trim();

            try {
                problems = JSON.parse(content);
                if (!Array.isArray(problems)) problems = [problems];
            } catch (e) {
                throw new Error('Could not parse AI response. Try a clearer image.');
            }

            if (problems.length === 0) throw new Error('No problems found in image.');

            showPicker();
            busy = false;
        })
        .catch(function (err) {
            if (err.name === 'AbortError') return;
            busy = false;
            showStep('upload');
            showError(err.message);
        });
    }

    // ═══════════════════════════════════════
    // PROBLEM PICKER
    // ═══════════════════════════════════════

    function showPicker() {
        showStep('pick');
        els.pickCount.textContent = problems.length;

        var html = '';
        problems.forEach(function (p, i) {
            var display = p.display || p.latex || p.expr || '(unknown)';
            var meta = [];
            if (p.type) meta.push(p.type);
            if (p.lower != null && p.upper != null) meta.push('from ' + p.lower + ' to ' + p.upper);
            if (p.variable && p.variable !== 'x') meta.push('var: ' + p.variable);
            // Show the raw latex/expr as code hint
            var exprHint = p.latex || p.expr || '';

            html +=
                '<div class="itm-problem" data-action="select-problem" data-idx="' + i + '">' +
                '  <div class="itm-problem-check">' +
                '    <input type="radio" name="itm-problem-select" class="itm-problem-cb" data-idx="' + i + '"' + (i === 0 ? ' checked' : '') + ' />' +
                '  </div>' +
                '  <div class="itm-problem-content">' +
                '    <div class="itm-problem-display" data-katex="' + escAttr(display) + '">' + escHtml(display) + '</div>' +
                (meta.length ? '    <div class="itm-problem-meta">' + escHtml(meta.join(' \u2022 ')) + '</div>' : '') +
                (exprHint ? '    <div class="itm-problem-expr"><code>' + escHtml(exprHint) + '</code></div>' : '') +
                '  </div>' +
                '</div>';
        });
        els.pickList.innerHTML = html;

        // Try KaTeX rendering
        if (win.katex) {
            els.pickList.querySelectorAll('[data-katex]').forEach(function (el) {
                try {
                    win.katex.render(el.getAttribute('data-katex'), el, { throwOnError: false, displayMode: false });
                } catch (e) { /* keep text fallback */ }
            });
        }

        updateSolveBtn();
    }

    function toggleProblem(target) {
        var idx = target.getAttribute('data-idx');
        var radio = overlay.querySelector('.itm-problem-cb[data-idx="' + idx + '"]');
        if (radio) {
            radio.checked = true;
            // Update selected styling
            overlay.querySelectorAll('.itm-problem').forEach(function (el) {
                el.classList.remove('selected');
            });
            target.classList.add('selected');
        }
        updateSolveBtn();
    }

    function updateSolveBtn() {
        var checked = overlay.querySelector('.itm-problem-cb:checked');
        var btn = overlay.querySelector('[data-action="solve-selected"]');
        if (btn) btn.disabled = !checked;
    }

    function doSolveSelected() {
        var checked = overlay.querySelector('.itm-problem-cb:checked');
        if (!checked) return;
        var idx = parseInt(checked.getAttribute('data-idx'));
        if (problems[idx]) config.onSelect(problems[idx]);
        close();
    }

    // ═══════════════════════════════════════
    // UI HELPERS
    // ═══════════════════════════════════════

    function showStep(name) {
        els.stepUpload.style.display = name === 'upload' ? '' : 'none';
        els.stepProcessing.style.display = name === 'processing' ? '' : 'none';
        els.stepPick.style.display = name === 'pick' ? '' : 'none';

        if (name === 'processing') {
            startQuotes();
        } else {
            stopQuotes();
        }
    }

    function startQuotes() {
        showRandomQuote();
        quoteTimer = setInterval(showRandomQuote, 6000);
    }

    function stopQuotes() {
        if (quoteTimer) { clearInterval(quoteTimer); quoteTimer = null; }
    }

    function showRandomQuote() {
        var q = QUOTES[Math.floor(Math.random() * QUOTES.length)];
        var textEl = overlay.querySelector('.itm-quote-text');
        var authorEl = overlay.querySelector('.itm-quote-author');
        if (textEl && authorEl) {
            textEl.textContent = '\u201c' + q.text + '\u201d';
            authorEl.textContent = '\u2014 ' + q.author;
        }
    }

    function showError(msg) { els.error.textContent = msg; els.error.style.display = 'block'; }
    function hideError() { els.error.style.display = 'none'; }

    function open() {
        if (!initialized) return;
        imageData = null;
        problems = [];
        clearImage();
        showStep('upload');
        overlay.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function close() {
        if (abortCtrl) { abortCtrl.abort(); abortCtrl = null; }
        busy = false;
        overlay.style.display = 'none';
        document.body.style.overflow = '';
    }

    function escHtml(s) { return String(s || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
    function escAttr(s) { return escHtml(s).replace(/"/g, '&quot;'); }

    // ═══════════════════════════════════════
    // EXPORT
    // ═══════════════════════════════════════

    win.ImageToMath = { init: init };

})(window);

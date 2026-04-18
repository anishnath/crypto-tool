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

    var ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/bmp', 'application/pdf'];
    var MAX_SIZE_BYTES = 10 * 1024 * 1024;
    var MAX_PDF_PAGES = 50;
    var pdfDoc = null;        // loaded PDF.js document
    var pdfPageNum = 1;       // selected page number
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
        { text: 'A mathematician is a device for turning coffee into theorems.', author: 'Alfr\u00e9d R\u00e9nyi' },
        { text: 'Nature is written in mathematical language.', author: 'Galileo Galilei' },
        { text: 'In mathematics you don\'t understand things. You just get used to them.', author: 'John von Neumann' },
        { text: 'The miracle of the appropriateness of the language of mathematics for the formulation of the laws of physics is a wonderful gift.', author: 'Eugene Wigner' },
        { text: 'Mathematics compares the most diverse phenomena and discovers the secret analogies that unite them.', author: 'Joseph Fourier' },
        { text: 'It is impossible to be a mathematician without being a poet in soul.', author: 'Sofia Kovalevskaya' },
        { text: 'The art of doing mathematics consists in finding that special case which contains all the germs of generality.', author: 'David Hilbert' },
        { text: 'There is no branch of mathematics, however abstract, which may not someday be applied to the real world.', author: 'Nikolai Lobachevsky' },
        { text: 'Mathematics knows no races or geographic boundaries; for mathematics, the cultural world is one country.', author: 'David Hilbert' },
        { text: 'Life is good for only two things: discovering mathematics and teaching mathematics.', author: 'Sim\u00e9on Poisson' },
        { text: 'The integers were made by God; all else is the work of man.', author: 'Leopold Kronecker' },
        { text: 'One can measure the importance of a scientific work by the number of earlier publications rendered superfluous by it.', author: 'David Hilbert' },
        { text: 'Since the mathematicians have invaded the theory of relativity, I do not understand it myself anymore.', author: 'Albert Einstein' },
        { text: 'Mathematics is not about numbers, equations, computations, or algorithms: it is about understanding.', author: 'William Paul Thurston' },
        { text: 'Young man, in mathematics you don\'t understand things. You just get used to them.', author: 'John von Neumann' },
        // Physics & Science
        { text: 'If I have seen further it is by standing on the shoulders of giants.', author: 'Isaac Newton' },
        { text: 'The important thing in science is not so much to obtain new facts as to discover new ways of thinking about them.', author: 'William Lawrence Bragg' },
        { text: 'Equipped with his five senses, man explores the universe around him and calls the adventure Science.', author: 'Edwin Hubble' },
        { text: 'Nothing in life is to be feared, it is only to be understood.', author: 'Marie Curie' },
        { text: 'I was taught that the way of progress is neither swift nor easy.', author: 'Marie Curie' },
        { text: 'Two things are infinite: the universe and human stupidity; and I\'m not sure about the universe.', author: 'Albert Einstein' },
        { text: 'We cannot solve our problems with the same thinking we used when we created them.', author: 'Albert Einstein' },
        { text: 'Science is a way of thinking much more than it is a body of knowledge.', author: 'Carl Sagan' },
        { text: 'Somewhere, something incredible is waiting to be known.', author: 'Carl Sagan' },
        { text: 'The good thing about science is that it\'s true whether or not you believe in it.', author: 'Neil deGrasse Tyson' },
        { text: 'Not only is the universe stranger than we imagine, it is stranger than we can imagine.', author: 'Sir Arthur Eddington' },
        { text: 'Research is what I\'m doing when I don\'t know what I\'m doing.', author: 'Wernher von Braun' },
        { text: 'The saddest aspect of life right now is that science gathers knowledge faster than society gathers wisdom.', author: 'Isaac Asimov' },
        { text: 'An experiment is a question which science poses to Nature, and a measurement is the recording of Nature\'s answer.', author: 'Max Planck' },
        { text: 'Science is organized knowledge. Wisdom is organized life.', author: 'Immanuel Kant' },
        { text: 'The universe is under no obligation to make sense to you.', author: 'Neil deGrasse Tyson' },
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
        { text: 'What one man calls God, another calls the laws of physics.', author: 'Nikola Tesla' },
        { text: 'The present is theirs; the future, for which I really worked, is mine.', author: 'Nikola Tesla' },
        { text: 'Our greatest weakness lies in giving up. The most certain way to succeed is always to try just one more time.', author: 'Thomas Edison' },
        { text: 'It does not matter how slowly you go as long as you do not stop.', author: 'Confucius' },
        { text: 'Start where you are. Use what you have. Do what you can.', author: 'Arthur Ashe' },
        { text: 'Whether you think you can, or you think you can\'t \u2014 you\'re right.', author: 'Henry Ford' },
        { text: 'You don\'t have to be great to start, but you have to start to be great.', author: 'Zig Ziglar' },
        { text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs' },
        { text: 'Dream big and dare to fail.', author: 'Norman Vaughan' },
        { text: 'A person who never made a mistake never tried anything new.', author: 'Albert Einstein' },
        { text: 'The harder you work, the luckier you get.', author: 'Gary Player' },
        { text: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt' },
        { text: 'The best time to plant a tree was 20 years ago. The second best time is now.', author: 'Chinese Proverb' },
        { text: 'Do what you can, with what you have, where you are.', author: 'Theodore Roosevelt' },
        { text: 'Everything you\'ve ever wanted is on the other side of fear.', author: 'George Addair' },
        // Famous figures & Philosophy
        { text: 'I think, therefore I am.', author: 'Ren\u00e9 Descartes' },
        { text: 'The unexamined life is not worth living.', author: 'Socrates' },
        { text: 'Knowledge is power.', author: 'Francis Bacon' },
        { text: 'I know that I know nothing.', author: 'Socrates' },
        { text: 'Simplicity is the ultimate sophistication.', author: 'Leonardo da Vinci' },
        { text: 'Logic will get you from A to B. Imagination will take you everywhere.', author: 'Albert Einstein' },
        { text: 'Live as if you were to die tomorrow. Learn as if you were to live forever.', author: 'Mahatma Gandhi' },
        { text: 'If you can dream it, you can do it.', author: 'Walt Disney' },
        { text: 'Be the change you wish to see in the world.', author: 'Mahatma Gandhi' },
        { text: 'Strive not to be a success, but rather to be of value.', author: 'Albert Einstein' },
        { text: 'The only limit to our realization of tomorrow is our doubts of today.', author: 'Franklin D. Roosevelt' },
        { text: 'Curiosity is the wick in the candle of learning.', author: 'William Arthur Ward' },
        { text: 'Tell me and I forget. Teach me and I remember. Involve me and I learn.', author: 'Benjamin Franklin' },
        { text: 'An investment in knowledge pays the best interest.', author: 'Benjamin Franklin' },
        { text: 'The only thing we have to fear is fear itself.', author: 'Franklin D. Roosevelt' },
        { text: 'Knowing is not enough; we must apply. Willing is not enough; we must do.', author: 'Johann Wolfgang von Goethe' },
        { text: 'There is nothing permanent except change.', author: 'Heraclitus' },
        { text: 'The only true wisdom is in knowing you know nothing.', author: 'Socrates' },
        { text: 'Happiness is not something readymade. It comes from your own actions.', author: 'Dalai Lama' },
        { text: 'We are what we repeatedly do. Excellence, then, is not an act, but a habit.', author: 'Aristotle' },
        { text: 'The journey of a thousand miles begins with one step.', author: 'Lao Tzu' },
        { text: 'He who has a why to live can bear almost any how.', author: 'Friedrich Nietzsche' },
        { text: 'Knowing yourself is the beginning of all wisdom.', author: 'Aristotle' },
        { text: 'The measure of intelligence is the ability to change.', author: 'Albert Einstein' },
        { text: 'To improve is to change; to be perfect is to change often.', author: 'Winston Churchill' },
        { text: 'Turn your wounds into wisdom.', author: 'Oprah Winfrey' },
        // Technology & Innovation
        { text: 'The science of today is the technology of tomorrow.', author: 'Edward Teller' },
        { text: 'Innovation distinguishes between a leader and a follower.', author: 'Steve Jobs' },
        { text: 'Any sufficiently advanced technology is indistinguishable from magic.', author: 'Arthur C. Clarke' },
        { text: 'The computer was born to solve problems that did not exist before.', author: 'Bill Gates' },
        { text: 'First, solve the problem. Then, write the code.', author: 'John Johnson' },
        { text: 'Programs must be written for people to read, and only incidentally for machines to execute.', author: 'Harold Abelson' },
        { text: 'Measuring programming progress by lines of code is like measuring aircraft building progress by weight.', author: 'Bill Gates' },
        { text: 'Simplicity is prerequisite for reliability.', author: 'Edsger W. Dijkstra' },
        { text: 'The most dangerous phrase in the language is: We\'ve always done it this way.', author: 'Grace Hopper' },
        { text: 'The advance of technology is based on making it fit in so that you don\'t really even notice it, so it\'s part of everyday life.', author: 'Bill Gates' },
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
        { text: 'Age is no barrier. It\'s a limitation you put on your mind.', author: 'Jackie Joyner-Kersee' },
        { text: 'Gold medals aren\'t really made of gold. They\'re made of sweat, determination, and a hard-to-find alloy called guts.', author: 'Dan Gable' },
        { text: 'The principle is competing against yourself. It\'s about self-improvement, about being better than you were the day before.', author: 'Steve Young' },
        { text: 'Never give up! Failure and rejection are only the first step to succeeding.', author: 'Jim Valvano' },
        { text: 'Set your goals high, and don\'t stop till you get there.', author: 'Bo Jackson' },
        { text: 'There may be people that have more talent than you, but there\'s no excuse for anyone to work harder than you do.', author: 'Derek Jeter' },
        { text: 'Obstacles don\'t have to stop you. If you run into a wall, don\'t turn around. Figure out how to climb it.', author: 'Michael Jordan' },
        { text: 'I\'ve always believed that if you put in the work, the results will come.', author: 'Michael Jordan' },
        { text: 'The difference between the impossible and the possible lies in a person\'s determination.', author: 'Tommy Lasorda' },
        { text: 'Winning isn\'t everything, but wanting to win is.', author: 'Vince Lombardi' },
        { text: 'It\'s hard to beat a person who never gives up.', author: 'Babe Ruth' },
        { text: 'The five S\'s of sports training: stamina, speed, strength, skill, and spirit. But the greatest of these is spirit.', author: 'Ken Doherty' },
        { text: 'Pain is temporary. Quitting lasts forever.', author: 'Lance Armstrong' },
        { text: 'You can\'t put a limit on anything. The more you dream, the farther you get.', author: 'Michael Phelps' },
        { text: 'I became a good pitcher when I stopped trying to make them miss the ball and started trying to make them hit it.', author: 'Sandy Koufax' },
        { text: 'A champion is someone who gets up when they can\'t.', author: 'Jack Dempsey' }
    ];
    var quotePool = [];   // shuffled deck for no-repeat cycling

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
            '        <div class="itm-dropzone-text">Drop image or PDF, paste (Ctrl+V), or <span class="itm-browse">browse</span></div>' +
            '        <div class="itm-dropzone-hint">Photo, screenshot, or PDF of textbook/homework &bull; Max 10MB</div>' +
            '      </div>' +
            '      <input type="file" class="itm-file-input" accept="image/*,.pdf,application/pdf" />' +
            '      <div class="itm-url-row">' +
            '        <div class="itm-url-divider"><span>or load from URL</span></div>' +
            '        <div class="itm-url-input-row">' +
            '          <input type="url" class="itm-url-input" placeholder="https://example.com/equation.png or .pdf" />' +
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
            // Step 1b: PDF page picker
            '    <div class="itm-step" id="itm-step-pdf" style="display:none;">' +
            '      <div class="itm-pdf-header">PDF has <span class="itm-pdf-total">0</span> page(s) &mdash; select one to scan</div>' +
            '      <div class="itm-pdf-pages"></div>' +
            '      <div class="itm-pdf-actions">' +
            '        <button class="itm-btn-primary" data-action="pdf-use-page" disabled>Use Page <span class="itm-pdf-sel-num">1</span></button>' +
            '        <button class="itm-btn" data-action="back">&#8592; Back</button>' +
            '      </div>' +
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
            '      <label class="itm-select-all"><input type="checkbox" data-action="select-all" checked /> Select All</label>' +
            '      <div class="itm-pick-list"></div>' +
            '      <div class="itm-pick-actions">' +
            '        <button class="itm-btn-primary" data-action="solve-selected">Solve All (<span class="itm-solve-count">0</span>)</button>' +
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
        els.stepPdf = document.getElementById('itm-step-pdf');
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
                case 'pdf-use-page': doPdfUsePage(); break;
                case 'back': showStep('upload'); clearImage(); break;
                case 'select-problem': toggleProblem(target); break;
                case 'select-all': toggleSelectAll(target); break;
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
        if (ALLOWED_TYPES.indexOf(file.type) === -1) {
            showError('Use JPEG, PNG, WEBP, or PDF.');
            return;
        }
        if (file.size > MAX_SIZE_BYTES) { showError('File too large. Max 10MB.'); return; }

        // PDF → route to page picker
        if (file.type === 'application/pdf' || (file.name && /\.pdf$/i.test(file.name))) {
            handlePdf(file);
            return;
        }

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
        if (!url) { showError('Enter an image or PDF URL.'); return; }
        if (!/^https?:\/\/.+/i.test(url)) { showError('Enter a valid URL starting with http:// or https://'); return; }

        hideError();
        urlInput.disabled = true;
        var btn = overlay.querySelector('.itm-url-btn');
        if (btn) { btn.disabled = true; btn.textContent = 'Loading\u2026'; }

        var isPdfUrl = /\.pdf(\?|#|$)/i.test(url);

        // Fetch file as blob → route to image or PDF handler
        fetch(url, { mode: 'cors' })
            .then(function (res) {
                if (!res.ok) throw new Error('Could not load file (HTTP ' + res.status + ')');
                var ct = res.headers.get('content-type') || '';
                var isImage = ct.indexOf('image') !== -1;
                var isPdf = ct.indexOf('pdf') !== -1 || isPdfUrl;
                if (!isImage && !isPdf) throw new Error('URL does not point to an image or PDF');
                return res.blob();
            })
            .then(function (blob) {
                if (blob.size > MAX_SIZE_BYTES) throw new Error('File too large (' + (blob.size / 1024 / 1024).toFixed(1) + 'MB). Max 10MB.');
                var ct = blob.type || '';
                var isPdf = ct.indexOf('pdf') !== -1 || isPdfUrl;
                var fname = isPdf ? 'from-url.pdf' : 'from-url.png';
                var ftype = isPdf ? 'application/pdf' : (blob.type || 'image/png');
                var file = new File([blob], fname, { type: ftype });
                handleFile(file);
            })
            .catch(function (err) {
                showError(err.message || 'Failed to load from URL.');
            })
            .finally(function () {
                if (urlInput) urlInput.disabled = false;
                if (btn) { btn.disabled = false; btn.textContent = 'Load'; }
            });
    }

    // ═══════════════════════════════════════
    // PDF HANDLING
    // ═══════════════════════════════════════

    var PDFJS_CDN = 'https://cdn.jsdelivr.net/npm/pdfjs-dist@4.4.168/build/pdf.min.mjs';
    var PDFJS_WORKER = 'https://cdn.jsdelivr.net/npm/pdfjs-dist@4.4.168/build/pdf.worker.min.mjs';

    function loadPdfJs(cb) {
        if (win.pdfjsLib) { cb(); return; }
        import(PDFJS_CDN).then(function (mod) {
            win.pdfjsLib = mod;
            mod.GlobalWorkerOptions.workerSrc = PDFJS_WORKER;
            cb();
        }).catch(function () {
            showError('Could not load PDF library. Try a different browser.');
        });
    }

    function handlePdf(file) {
        hideError();
        loadPdfJs(function () {
            var reader = new FileReader();
            reader.onload = function (e) {
                var typedArray = new Uint8Array(e.target.result);
                win.pdfjsLib.getDocument({ data: typedArray }).promise
                    .then(function (doc) {
                        pdfDoc = doc;
                        var total = doc.numPages;
                        if (total > MAX_PDF_PAGES) {
                            showError('PDF has ' + total + ' pages (max ' + MAX_PDF_PAGES + '). Use a shorter file.');
                            return;
                        }
                        showPdfPagePicker(total, file.name);
                    })
                    .catch(function (err) {
                        showError('Could not read PDF: ' + (err.message || 'unknown error'));
                    });
            };
            reader.onerror = function () { showError('Failed to read PDF.'); };
            reader.readAsArrayBuffer(file);
        });
    }

    function showPdfPagePicker(total, fileName) {
        showStep('pdf');
        var totalSpan = overlay.querySelector('.itm-pdf-total');
        if (totalSpan) totalSpan.textContent = total;
        pdfPageNum = 1;

        var container = overlay.querySelector('.itm-pdf-pages');
        container.innerHTML = '';

        // Render page thumbnails
        for (var i = 1; i <= total; i++) {
            (function (pageNum) {
                var card = document.createElement('div');
                card.className = 'itm-pdf-page' + (pageNum === 1 ? ' selected' : '');
                card.setAttribute('data-page', pageNum);
                card.innerHTML =
                    '<canvas class="itm-pdf-thumb"></canvas>' +
                    '<div class="itm-pdf-page-num">Page ' + pageNum + '</div>';
                card.addEventListener('click', function () {
                    container.querySelectorAll('.itm-pdf-page').forEach(function (el) { el.classList.remove('selected'); });
                    card.classList.add('selected');
                    pdfPageNum = pageNum;
                    var selNum = overlay.querySelector('.itm-pdf-sel-num');
                    if (selNum) selNum.textContent = pageNum;
                    var useBtn = overlay.querySelector('[data-action="pdf-use-page"]');
                    if (useBtn) useBtn.disabled = false;
                });
                container.appendChild(card);

                // Render thumbnail
                pdfDoc.getPage(pageNum).then(function (page) {
                    var vp = page.getViewport({ scale: 0.4 });
                    var canvas = card.querySelector('canvas');
                    canvas.width = vp.width;
                    canvas.height = vp.height;
                    page.render({ canvasContext: canvas.getContext('2d'), viewport: vp });
                });
            })(i);
        }

        // Enable button for default selection (page 1)
        var useBtn = overlay.querySelector('[data-action="pdf-use-page"]');
        if (useBtn) useBtn.disabled = false;
        var selNum = overlay.querySelector('.itm-pdf-sel-num');
        if (selNum) selNum.textContent = '1';
    }

    function doPdfUsePage() {
        if (!pdfDoc || !pdfPageNum) return;

        // Show processing while rendering full-res page
        showStep('processing');
        els.processingText.textContent = 'Rendering page ' + pdfPageNum + '\u2026';

        pdfDoc.getPage(pdfPageNum).then(function (page) {
            // Render at 2x for good OCR quality
            var scale = 2.0;
            var vp = page.getViewport({ scale: scale });
            var canvas = document.createElement('canvas');
            canvas.width = vp.width;
            canvas.height = vp.height;
            return page.render({ canvasContext: canvas.getContext('2d'), viewport: vp }).promise.then(function () {
                return canvas;
            });
        }).then(function (canvas) {
            var dataUrl = canvas.toDataURL('image/png');
            var base64 = dataUrl.split(',')[1];
            imageData = {
                base64: base64,
                dataUrl: dataUrl,
                name: 'pdf-page-' + pdfPageNum + '.png',
                size: Math.round(base64.length * 0.75),
                type: 'image/png'
            };
            // Continue to OCR pipeline
            doScan();
        }).catch(function (err) {
            showStep('upload');
            showError('Failed to render PDF page: ' + (err.message || 'unknown error'));
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
        pdfDoc = null;
        pdfPageNum = 1;
        els.dropzone.style.display = '';
        var urlRow = overlay.querySelector('.itm-url-row');
        if (urlRow) urlRow.style.display = '';
        els.preview.style.display = 'none';
        els.scanBtn.disabled = true;
        hideError();
    }

    // ═══════════════════════════════════════
    // OCR CONTENT VALIDATION
    // ═══════════════════════════════════════

    /**
     * Check if OCR output contains math-related content worth sending to AI.
     * Saves an AI call if the image is random/blank/non-math.
     */
    function validateOcrContent(text) {
        if (!text || !text.trim()) {
            return { ok: false, error: 'No text found in image. Try a clearer photo.' };
        }

        var s = text.trim();

        // Too short — likely noise or single word
        if (s.length < 5) {
            return { ok: false, error: 'Image contains too little text. Try a clearer photo with a math problem.' };
        }

        // Check for math indicators: numbers, operators, math symbols, LaTeX commands, function names
        var hasMathSymbols = /[0-9+\-*/=^()∫∑∏√π∞±÷×≤≥≠≈∂∇∈∉⊂⊃∪∩]/.test(s);
        var hasLatexCommands = /\\(?:frac|int|sum|sqrt|sin|cos|tan|log|ln|lim|partial|begin|end|alpha|beta|gamma|theta|pi|infty|cdot|times|left|right)/.test(s);
        var hasMathFunctions = /\b(?:sin|cos|tan|cot|sec|csc|log|ln|exp|sqrt|lim|max|min|arcsin|arccos|arctan|sinh|cosh|tanh)\b/i.test(s);
        var hasMathWords = /\b(?:integral|integrate|derivative|differentiate|solve|evaluate|calculate|compute|find|prove|equation|function|limit|sum|series|matrix|determinant|vector|polynomial|factor|simplify)\b/i.test(s);
        var hasVariables = /\b[xyz]\b/.test(s) || /\bd[xyz]\b/.test(s);
        var hasEquation = /[=<>]/.test(s) && /[0-9a-zA-Z]/.test(s);

        var mathScore = 0;
        if (hasMathSymbols) mathScore += 2;
        if (hasLatexCommands) mathScore += 3;
        if (hasMathFunctions) mathScore += 2;
        if (hasMathWords) mathScore += 2;
        if (hasVariables) mathScore += 1;
        if (hasEquation) mathScore += 1;

        if (mathScore === 0) {
            return { ok: false, error: 'No math content detected in image. Please upload a photo of a math problem, equation, or formula.' };
        }

        if (mathScore < 2 && s.length < 20) {
            return { ok: false, error: 'Image doesn\'t appear to contain a math problem. Try a photo with equations or formulas.' };
        }

        return { ok: true };
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

            // ── Validate OCR output before calling AI ──
            var validation = validateOcrContent(ocrText);
            if (!validation.ok) throw new Error(validation.error);

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

        // Check "select all" by default
        var selectAllCb = overlay.querySelector('[data-action="select-all"]');
        if (selectAllCb) selectAllCb.checked = true;

        var html = '';
        problems.forEach(function (p, i) {
            var display = p.display || p.latex || p.expr || '(unknown)';
            var meta = [];
            if (p.type) meta.push(p.type);
            if (p.lower != null && p.upper != null) meta.push('from ' + p.lower + ' to ' + p.upper);
            if (p.variable && p.variable !== 'x') meta.push('var: ' + p.variable);
            var exprHint = p.latex || p.expr || '';

            html +=
                '<div class="itm-problem selected" data-action="select-problem" data-idx="' + i + '">' +
                '  <div class="itm-problem-check">' +
                '    <input type="checkbox" class="itm-problem-cb" data-idx="' + i + '" checked />' +
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
        var cb = overlay.querySelector('.itm-problem-cb[data-idx="' + idx + '"]');
        if (cb) {
            cb.checked = !cb.checked;
            target.classList.toggle('selected', cb.checked);
        }
        syncSelectAll();
        updateSolveBtn();
    }

    function toggleSelectAll(target) {
        var checked = target.checked !== undefined ? target.checked : target.querySelector('input').checked;
        overlay.querySelectorAll('.itm-problem-cb').forEach(function (cb) {
            cb.checked = checked;
            var card = cb.closest('.itm-problem');
            if (card) card.classList.toggle('selected', checked);
        });
        updateSolveBtn();
    }

    function syncSelectAll() {
        var all = overlay.querySelectorAll('.itm-problem-cb');
        var checkedCount = overlay.querySelectorAll('.itm-problem-cb:checked').length;
        var selectAllCb = overlay.querySelector('[data-action="select-all"]');
        if (selectAllCb) {
            selectAllCb.checked = checkedCount === all.length;
            selectAllCb.indeterminate = checkedCount > 0 && checkedCount < all.length;
        }
    }

    function updateSolveBtn() {
        var checkedCbs = overlay.querySelectorAll('.itm-problem-cb:checked');
        var btn = overlay.querySelector('[data-action="solve-selected"]');
        var countSpan = overlay.querySelector('.itm-solve-count');
        if (countSpan) countSpan.textContent = checkedCbs.length;
        if (btn) {
            btn.disabled = checkedCbs.length === 0;
            // Update button label
            btn.innerHTML = checkedCbs.length <= 1
                ? 'Solve' + (checkedCbs.length ? '' : '')
                : 'Solve All (<span class="itm-solve-count">' + checkedCbs.length + '</span>)';
        }
    }

    function getSelectedProblems() {
        var selected = [];
        overlay.querySelectorAll('.itm-problem-cb:checked').forEach(function (cb) {
            var idx = parseInt(cb.getAttribute('data-idx'));
            if (problems[idx]) selected.push(problems[idx]);
        });
        return selected;
    }

    function doSolveSelected() {
        var selected = getSelectedProblems();
        if (selected.length === 0) return;

        // Single problem — use original onSelect (fills main UI)
        if (selected.length === 1 && !config.onSolveAll) {
            config.onSelect(selected[0]);
            close();
            return;
        }

        // Multiple problems — use batch solve
        if (config.onSolveAll) {
            close();
            config.onSolveAll(selected);
        } else {
            // Fallback: just use first
            config.onSelect(selected[0]);
            close();
        }
    }

    // ═══════════════════════════════════════
    // UI HELPERS
    // ═══════════════════════════════════════

    function showStep(name) {
        els.stepUpload.style.display = name === 'upload' ? '' : 'none';
        els.stepPdf.style.display = name === 'pdf' ? '' : 'none';
        els.stepProcessing.style.display = name === 'processing' ? '' : 'none';
        els.stepPick.style.display = name === 'pick' ? '' : 'none';

        if (name === 'processing') {
            startQuotes();
        } else {
            stopQuotes();
        }
    }

    function startQuotes() {
        showNextQuote();
        quoteTimer = setInterval(showNextQuote, 6000);
    }

    function stopQuotes() {
        if (quoteTimer) { clearInterval(quoteTimer); quoteTimer = null; }
    }

    /** Fisher-Yates shuffle — cycles through all quotes before repeating any. */
    function shuffleQuotes() {
        quotePool = QUOTES.slice();
        for (var i = quotePool.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var tmp = quotePool[i];
            quotePool[i] = quotePool[j];
            quotePool[j] = tmp;
        }
    }

    function showNextQuote() {
        if (quotePool.length === 0) shuffleQuotes();
        var q = quotePool.pop();
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

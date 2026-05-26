/* practice-engine.js — untimed Olympiad-stepwise practice mode.

   Different from exam-engine.js:
   · No timer, no scoring, no cooldown, no question navigator.
   · One problem at a time from a deep pool. "Next" picks a fresh random.
   · Answer optional — if user types and the problem has a `\boxed{}` answer,
     a "Check" button compares. Otherwise just "Reveal stepwise solution".
   · Session counter (attempted / correct / streak) persists in localStorage.

   Mounts to #op-root. Reuses the same KaTeX + DGM/IMG marker rendering
   helpers as the exam engine (intentionally duplicated for self-contained
   engines — see split_amc.py / split_olympiad.py comment).

   Public API:
       OlympiadEngine.init({
           rootId:   'op-root',
           dataBase: '/math/olympiad/data',   // contains meta.json + q/ + s/ + dgm/
           bucket:   'olympiad-stepwise',
           title:    'Olympiad Stepwise Practice'
       });
*/

(function (global) {
    'use strict';

    var OlympiadEngine = {};
    var state = null;
    var X_HANDLE = 'anish2good';

    /* ──────────────────────────────────────────────────────────────────── */
    /* Rendering helpers (mirror of exam-engine.js — keep in sync)          */
    /* ──────────────────────────────────────────────────────────────────── */

    function escHtml(s) {
        return String(s == null ? '' : s)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }

    function mdLinks(s) {
        return s.replace(/\[([^\]]+)\]\((https?:[^)]+)\)/g, function (_, txt, url) {
            return '<a href="' + escHtml(url) + '" target="_blank" rel="noopener noreferrer">' + escHtml(txt) + '</a>';
        });
    }

    function dgmMarker(s) {
        return s.replace(/\{\{DGM:([a-f0-9]{16})\}\}/g, function (_, hash) {
            var base = (state && state.opts && state.opts.dataBase) || '';
            return '<img class="xm-diagram" src="' + base + '/dgm/' + hash + '.svg" alt="diagram" loading="lazy">';
        }).replace(/\{\{IMG:([a-f0-9]{16}\.(?:png|jpe?g|gif|svg|webp))\}\}/gi, function (_, fname) {
            var base = (state && state.opts && state.opts.dataBase) || '';
            return '<img class="xm-diagram" src="' + base + '/img/' + fname + '" alt="figure" loading="lazy">';
        });
    }

    function mdItalicCode(s) {
        s = s.replace(/(^|[\s(])\*(\S[^*\n]*?\S|\S)\*(?=[\s).,;:!?]|$)/g, '$1<em>$2</em>');
        s = s.replace(/(^|[\s(])_(\S[^_\n]*?\S|\S)_(?=[\s).,;:!?]|$)/g, '$1<em>$2</em>');
        s = s.replace(/`([^`\n]+?)`/g, '<code>$1</code>');
        return s;
    }

    function tokenize(text) {
        var out = [];
        var i = 0, n = text.length;
        while (i < n) {
            if (text[i] === '$' && text[i+1] === '$') {
                var end = text.indexOf('$$', i + 2);
                if (end < 0) { out.push({ type: 'prose', text: text.slice(i) }); break; }
                out.push({ type: 'math', display: true, text: text.slice(i + 2, end) });
                i = end + 2;
            } else if (text[i] === '$') {
                var e2 = text.indexOf('$', i + 1);
                if (e2 < 0) { out.push({ type: 'prose', text: text.slice(i) }); break; }
                out.push({ type: 'math', display: false, text: text.slice(i + 1, e2) });
                i = e2 + 1;
            } else {
                var nxt = text.indexOf('$', i);
                out.push({ type: 'prose', text: nxt < 0 ? text.slice(i) : text.slice(i, nxt) });
                i = nxt < 0 ? n : nxt;
            }
        }
        return out;
    }

    function renderTeX(tex, displayMode) {
        if (typeof katex === 'undefined') return escHtml(tex);
        try {
            return katex.renderToString(tex, {
                throwOnError: false, displayMode: !!displayMode, strict: 'ignore'
            });
        } catch (e) { return '<code>' + escHtml(tex) + '</code>'; }
    }

    function renderMath(text) {
        if (!text) return '';
        var tokens = tokenize(text);
        var html = '';
        var boldOpen = false;
        for (var t = 0; t < tokens.length; t++) {
            var tok = tokens[t];
            if (tok.type === 'math') {
                html += renderTeX(tok.text, !!tok.display);
                continue;
            }
            var p = mdLinks(escHtml(tok.text));
            var parts = p.split('**');
            var prose = '';
            for (var k = 0; k < parts.length; k++) {
                if (k > 0) {
                    prose += boldOpen ? '</strong>' : '<strong>';
                    boldOpen = !boldOpen;
                }
                prose += parts[k];
            }
            html += dgmMarker(mdItalicCode(prose));
        }
        if (boldOpen) html += '</strong>';
        return html;
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* localStorage stats                                                   */
    /* ──────────────────────────────────────────────────────────────────── */

    // localStorage key is parameterized via opts.statsKey so different
    // practice pages (Olympiad, JEE, …) keep separate progress.
    function statsKey() { return (state && state.opts && state.opts.statsKey) || 'op.stats'; }

    function loadStats() {
        try {
            var raw = localStorage.getItem(statsKey());
            if (!raw) return defaultStats();
            var s = JSON.parse(raw);
            return Object.assign(defaultStats(), s);
        } catch (e) { return defaultStats(); }
    }
    function defaultStats() {
        return { attempted: 0, correct: 0, wrong: 0, revealed: 0, streak: 0, bestStreak: 0 };
    }
    function saveStats() {
        try { localStorage.setItem(statsKey(), JSON.stringify(state.stats)); } catch (e) {}
    }
    function resetStats() {
        try { localStorage.removeItem(statsKey()); } catch (e) {}
        state.stats = defaultStats();
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Data loading                                                         */
    /* ──────────────────────────────────────────────────────────────────── */

    function fetchJson(url) {
        return fetch(url, { credentials: 'same-origin' })
            .then(function (r) {
                if (!r.ok) throw new Error('HTTP ' + r.status + ' for ' + url);
                return r.json();
            });
    }

    function loadMeta() {
        return fetchJson(state.opts.dataBase + '/meta.json').then(function (m) { state.meta = m; });
    }

    function loadRandomShard() {
        var bk = state.meta.buckets[state.opts.bucket];
        if (!bk || !bk.q_shards || !bk.q_shards.length) {
            throw new Error('No shards for bucket ' + state.opts.bucket);
        }
        var idx = Math.floor(Math.random() * bk.q_shards.length);
        var shard = bk.q_shards[idx];
        state.shardName = shard.f;
        return fetchJson(state.opts.dataBase + '/q/' + shard.f).then(function (data) {
            state.shard = data;
        });
    }

    function loadSolutionShard() {
        if (state.solCache[state.shardName]) return Promise.resolve(state.solCache[state.shardName]);
        return fetchJson(state.opts.dataBase + '/s/' + state.shardName).then(function (data) {
            state.solCache[state.shardName] = data;
            return data;
        });
    }

    function pickRandomProblem() {
        // Random index inside the current shard. If we've shown more than
        // half the shard, swap shards for variety.
        if (state.shownInShard >= Math.floor(state.shard.length / 2)) {
            // Reload a different random shard
            state.shownInShard = 0;
            return loadRandomShard();
        }
        return Promise.resolve();
    }

    function nextProblem() {
        return pickRandomProblem().then(function () {
            var idx = Math.floor(Math.random() * state.shard.length);
            state.problem = state.shard[idx];
            state.shownInShard += 1;
            state.solutionShown = false;
            state.solutionHtml = null;    // clear cached walkthrough for new problem
            state.answerPeeked = false;
            state.problemAnimated = false; // re-arm the typewriter for the new problem
            state.userAnswer = '';
            state.lastResult = null;
            render();
        });
    }

    // Count Next / Reveal / Check clicks and nudge the share popup every
    // SHARE_NUDGE_EVERY interactions. Triggered after meaningful actions
    // (not on every key press).
    var SHARE_NUDGE_EVERY = 10;
    function bumpClick() {
        state.clickCount += 1;
        if (!state.shareSuppressed && state.clickCount % SHARE_NUDGE_EVERY === 0) {
            openShareModal();
        }
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Answer checking                                                      */
    /* ──────────────────────────────────────────────────────────────────── */

    // Normalize a user/key answer into a comparable canonical form.
    // Goal: accept casual typed forms ("1/2", "sqrt(5)", "0.5") for keys
    // that are LaTeX-only (\frac{1}{2}, \sqrt{5}, etc.).
    function normalizeForCheck(s) {
        if (!s) return '';
        s = String(s).trim();
        // Strip LaTeX delimiters / $-signs / \left \right
        s = s.replace(/\$\$?/g, '');
        s = s.replace(/\\left|\\right/g, '');
        // \dfrac / \tfrac / \frac{a}{b}  →  (a)/(b)
        s = s.replace(/\\(?:d|t)?frac\s*\{([^{}]+)\}\s*\{([^{}]+)\}/g, '($1)/($2)');
        // \sqrt[n]{x} → sqrt(x,n) ; \sqrt{x} → sqrt(x)
        s = s.replace(/\\sqrt\s*\[([^\]]+)\]\s*\{([^{}]+)\}/g, 'sqrt($2,$1)');
        s = s.replace(/\\sqrt\s*\{([^{}]+)\}/g, 'sqrt($1)');
        // user-typed unicode square root sign
        s = s.replace(/√\s*([0-9.]+|\([^)]+\))/g, 'sqrt($1)');
        // \pi → pi ; \cdot, \times → * ; \div → /
        s = s.replace(/\\pi\b/g, 'pi');
        s = s.replace(/\\(?:cdot|times)\b/g, '*');
        s = s.replace(/\\div\b/g, '/');
        // strip \text{...} wrappers — they're just typography
        s = s.replace(/\\text\s*\{([^{}]*)\}/g, '$1');
        // strip parens around bare integers/fractions: (1)/(2) → 1/2
        s = s.replace(/\((\-?\d+(?:\.\d+)?)\)/g, '$1');
        // drop all whitespace and lowercase
        s = s.replace(/\s+/g, '').toLowerCase();
        // drop a stray leading + sign
        s = s.replace(/^\+/, '');
        // drop trailing decimal zeros: 12.0 → 12, 12.50 → 12.5
        s = s.replace(/(\.\d*?)0+$/, '$1').replace(/\.$/, '');
        return s;
    }

    // Try to evaluate a numeric value from a normalized answer string.
    // Returns null if the form is too complex (matrices, multi-term, etc).
    function tryEvalNumeric(s) {
        if (!s) return null;
        if (/^-?\d+(?:\.\d+)?$/.test(s)) return parseFloat(s);
        var m = s.match(/^(-?\d+(?:\.\d+)?)\/(\-?\d+(?:\.\d+)?)$/);
        if (m) {
            var num = parseFloat(m[1]), den = parseFloat(m[2]);
            if (den === 0) return null;
            return num / den;
        }
        return null;
    }

    function checkAnswer(user, key) {
        if (!user || !key) return false;
        var u = normalizeForCheck(user);
        var k = normalizeForCheck(key);
        if (u === k) return true;
        // Loose numeric compare (handles "0.5" vs "1/2", "12" vs "12.0")
        var uNum = tryEvalNumeric(u);
        var kNum = tryEvalNumeric(k);
        if (uNum != null && kNum != null && Math.abs(uNum - kNum) < 1e-9) return true;
        return false;
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Render                                                               */
    /* ──────────────────────────────────────────────────────────────────── */

    function render() {
        var root = document.getElementById(state.opts.rootId);
        if (!root) return;
        if (state.phase === 'loading') root.innerHTML = renderLoading();
        else if (state.phase === 'practice') {
            root.innerHTML = renderPractice();
            // After the first render of a problem, mark it animated so the
            // typewriter doesn't re-fire on every subsequent re-render
            // (Check / Peek / Reveal all call render()).
            state.problemAnimated = true;
        }
        wireHandlers();
    }

    function renderLoading() {
        return '<div class="xm-card xm-loading">' +
               '<span class="xm-spinner"></span>Loading the problem pool…' +
               '</div>';
    }

    function renderPractice() {
        var p = state.problem;
        if (!p) return '<div class="xm-card xm-loading">Pulling a problem…</div>';

        var hasKey = !!(p.a && p.a.length);
        var resultBanner = '';
        if (state.lastResult === 'correct') {
            resultBanner = '<div class="op-banner op-banner-ok">Correct.</div>';
        } else if (state.lastResult === 'wrong') {
            resultBanner = '<div class="op-banner op-banner-bad">Not quite — try again, or reveal the solution.</div>';
        }

        var answerSection = '';
        if (!hasKey) {
            answerSection = '<div class="op-banner op-banner-info">This problem has no single closed-form answer — read the stepwise walkthrough below.</div>';
        } else {
            var isInt = p.t === 'int';
            // Placeholder + hint vary by answer type. Integer keys are easy
            // to type; expression keys (\frac, \sqrt, matrices) get a softer
            // placeholder and a Peek button so users don't have to fight
            // LaTeX in a text input.
            var placeholder = isInt
                ? 'integer'
                : 'try 1/2, sqrt(5), 0.5… or hit Peek to compare';
            var hint = isInt
                ? '<span class="op-hint">Integer answer. Negative values OK.</span>'
                : '<span class="op-hint">Expression answer. Casual forms accepted: <code>1/2</code>, <code>sqrt(5)</code>, decimals. Or hit <strong>Peek</strong> to compare with the key.</span>';

            var peekBtn = isInt
                ? ''
                : '<button class="xm-btn" id="op-peek-btn" type="button">' +
                  (state.answerPeeked ? 'Hide key' : 'Peek at answer') +
                  '</button>';

            var peekedRender = '';
            if (state.answerPeeked && !isInt) {
                peekedRender = '<div class="op-peeked">' +
                    '<span class="op-peeked-label">Expected:</span>' +
                    '<span class="op-peeked-tex">' + renderTeX(p.a, false) + '</span>' +
                    '</div>';
            }

            answerSection = '' +
                '<div class="op-answer-row">' +
                '  <label for="op-answer">Your answer</label>' +
                '  <input type="text" id="op-answer" autocomplete="off" autocapitalize="off" spellcheck="false"' +
                '         inputmode="' + (isInt ? 'numeric' : 'text') + '"' +
                '         value="' + escHtml(state.userAnswer || '') + '"' +
                '         placeholder="' + placeholder + '">' +
                '  <button class="xm-btn" id="op-check-btn" type="button">Check</button>' +
                     peekBtn +
                '</div>' +
                hint +
                peekedRender;
        }

        var solHtml = '';
        if (state.solutionShown) {
            // If the walkthrough was already fetched + rendered, paint it
            // straight away instead of re-spinning the spinner — fixes the
            // "spinner stays after Check" bug.
            var body = state.solutionHtml || '<span class="xm-spinner"></span>Loading walkthrough…';
            solHtml = '' +
                '<div class="op-solution">' +
                '  <div class="op-solution-head">Stepwise solution</div>' +
                '  <div class="op-solution-body" id="op-solution-body">' + body + '</div>' +
                '</div>';
        } else {
            solHtml = '<button class="xm-btn xm-btn-primary op-reveal-btn" id="op-reveal-btn" type="button">' +
                      'Reveal stepwise solution &#9662;</button>';
        }

        var stats = state.stats;
        var streakStr = stats.streak >= 2 ? '<strong>' + stats.streak + ' in a row</strong>' : stats.streak;
        var accuracy = stats.attempted > 0
            ? Math.round(100 * stats.correct / stats.attempted) + '%'
            : '—';

        return '' +
            '<div class="op-print-brand" aria-hidden="true">' +
            '  <span class="op-print-brand-mark">8gwifi.org</span>' +
            '  <span class="op-print-brand-path">/math/olympiad &middot; ' + escHtml(p.id || '') + '</span>' +
            '</div>' +
            '<div class="op-card">' +
            '  <div class="op-head">' +
            '    <span class="op-qid">' + escHtml(p.id || '') + '</span>' +
            '    <div class="op-head-actions">' +
            '      <button class="xm-btn op-print-btn" id="op-print-btn" type="button" title="Print this problem + solution">' +
            '        <span aria-hidden="true">&#128424;</span> Print' +
            '      </button>' +
            '      <button class="xm-btn" id="op-skip-btn" type="button">Skip</button>' +
            '      <button class="xm-btn xm-btn-primary" id="op-next-btn" type="button">Next problem &rarr;</button>' +
            '    </div>' +
            '  </div>' +
                  resultBanner +
            '  <div class="op-problem' + (state.problemAnimated ? '' : ' op-problem-typing') + '"><span class="op-q-badge" aria-hidden="true">Q.</span>' + renderMath(p.p || '') + '</div>' +
                  answerSection +
            '  <div class="op-divider"></div>' +
                  solHtml +
            '  <div class="op-print-footer" aria-hidden="true">' +
            '    Source: 8gwifi.org/math/olympiad &middot; ' + escHtml(p.id || '') + ' &middot; printed for personal study' +
            '  </div>' +
            '</div>' +
            '<div class="op-statbar">' +
            '  <div class="op-stat"><span class="op-stat-num">' + stats.attempted + '</span><span class="op-stat-lbl">Attempted</span></div>' +
            '  <div class="op-stat"><span class="op-stat-num">' + stats.correct + '</span><span class="op-stat-lbl">Correct</span></div>' +
            '  <div class="op-stat"><span class="op-stat-num">' + stats.wrong + '</span><span class="op-stat-lbl">Wrong</span></div>' +
            '  <div class="op-stat"><span class="op-stat-num">' + accuracy + '</span><span class="op-stat-lbl">Accuracy</span></div>' +
            '  <div class="op-stat"><span class="op-stat-num">' + streakStr + '</span><span class="op-stat-lbl">Streak</span></div>' +
            '  <div class="op-stat"><span class="op-stat-num">' + stats.bestStreak + '</span><span class="op-stat-lbl">Best</span></div>' +
            '  <button class="xm-btn-ghost" id="op-stats-reset" type="button">Reset</button>' +
            '</div>';
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Handlers                                                             */
    /* ──────────────────────────────────────────────────────────────────── */

    function wireHandlers() {
        if (state.phase !== 'practice') return;

        var skip   = document.getElementById('op-skip-btn');
        var next   = document.getElementById('op-next-btn');
        var check  = document.getElementById('op-check-btn');
        var reveal = document.getElementById('op-reveal-btn');
        var input  = document.getElementById('op-answer');
        var reset  = document.getElementById('op-stats-reset');

        if (skip)   skip.addEventListener('click', function () { nextProblem(); bumpClick(); });
        if (next)   next.addEventListener('click', function () { nextProblem(); bumpClick(); });

        var print = document.getElementById('op-print-btn');
        if (print) print.addEventListener('click', onPrint);
        if (check)  check.addEventListener('click', onCheck);
        if (reveal) reveal.addEventListener('click', onReveal);

        var peek = document.getElementById('op-peek-btn');
        if (peek) peek.addEventListener('click', function () {
            state.answerPeeked = !state.answerPeeked;
            render();
        });
        if (input) {
            input.addEventListener('input', function () { state.userAnswer = input.value; });
            input.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') { e.preventDefault(); onCheck(); }
            });
            // Auto-focus the answer box on every render unless the user is
            // already typing somewhere else.
            if (document.activeElement !== input) {
                try { input.focus({ preventScroll: true }); } catch (_) {}
            }
        }
        if (reset) reset.addEventListener('click', function () {
            if (!confirm('Reset your practice stats? This clears attempted / correct / streak.')) return;
            resetStats();
            render();
        });
    }

    function onPrint() {
        // Make sure the solution is rendered into the DOM before the user
        // hits the system print dialog — otherwise the printout shows the
        // unrevealed "Reveal stepwise solution" button, which is useless on
        // paper. If the walkthrough hasn't been fetched yet, fetch it,
        // wait for it, then trigger print.
        if (state.solutionShown && state.solutionHtml) {
            window.print();
            return;
        }
        state.solutionShown = true;
        render();
        if (state.solutionHtml) {
            window.print();
            return;
        }
        var targetId = state.problem.id;
        loadSolutionShard().then(function (sols) {
            if (!state.problem || state.problem.id !== targetId) return;
            var byId = {};
            for (var i = 0; i < sols.length; i++) byId[sols[i].id] = sols[i].sol;
            state.solutionHtml = renderMath(byId[targetId] || '(solution unavailable)');
            var host = document.getElementById('op-solution-body');
            if (host) host.innerHTML = state.solutionHtml;
            // Slight delay so KaTeX has a frame to lay out the SVG-heavy
            // walkthrough before the browser snapshots the page for print.
            setTimeout(function () { window.print(); }, 200);
        }).catch(function () { window.print(); });
    }

    function onCheck() {
        var input = document.getElementById('op-answer');
        if (!input) return;
        var user = input.value;
        if (!user.trim()) return;
        var p = state.problem;
        var ok = checkAnswer(user, p.a);
        state.stats.attempted += 1;
        if (ok) {
            state.lastResult = 'correct';
            state.stats.correct += 1;
            state.stats.streak += 1;
            if (state.stats.streak > state.stats.bestStreak) state.stats.bestStreak = state.stats.streak;
        } else {
            state.lastResult = 'wrong';
            state.stats.wrong += 1;
            state.stats.streak = 0;
        }
        saveStats();
        render();
        bumpClick();
    }

    function onReveal() {
        state.solutionShown = true;
        state.stats.revealed += 1;
        saveStats();
        render();
        bumpClick();

        // If the walkthrough HTML is already cached (e.g. user re-rendered
        // by clicking Check after revealing), skip the fetch + just paint.
        if (state.solutionHtml) {
            var host0 = document.getElementById('op-solution-body');
            if (host0) host0.innerHTML = state.solutionHtml;
            return;
        }
        // Lazy-load the matching solution shard.
        var targetId = state.problem.id;
        loadSolutionShard().then(function (sols) {
            // Bail if the user already moved to a new problem.
            if (!state.problem || state.problem.id !== targetId) return;
            var byId = {};
            for (var i = 0; i < sols.length; i++) byId[sols[i].id] = sols[i].sol;
            var sol = byId[targetId] || '(solution unavailable)';
            state.solutionHtml = renderMath(sol);
            var host = document.getElementById('op-solution-body');
            if (host) host.innerHTML = state.solutionHtml;
        }).catch(function (e) {
            var host = document.getElementById('op-solution-body');
            if (host) host.innerHTML = '<div class="op-banner op-banner-bad">Could not load: ' + escHtml(e.message) + '</div>';
        });
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Share modal — same shape as exam-engine.js, fires every Nth click   */
    /* ──────────────────────────────────────────────────────────────────── */

    var SHARE_ICONS = {
        x:        '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>',
        linkedin: '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M20.45 20.45h-3.55v-5.57c0-1.33-.03-3.04-1.85-3.04-1.85 0-2.14 1.45-2.14 2.94v5.67H9.36V9h3.41v1.56h.05a3.74 3.74 0 0 1 3.37-1.85c3.6 0 4.27 2.37 4.27 5.46v6.28zM5.34 7.43a2.06 2.06 0 1 1 0-4.13 2.06 2.06 0 0 1 0 4.13zM7.12 20.45H3.56V9h3.56v11.45zM22.22 0H1.77C.79 0 0 .77 0 1.73v20.54C0 23.23.79 24 1.77 24h20.45C23.2 24 24 23.23 24 22.27V1.73C24 .77 23.2 0 22.22 0z"/></svg>',
        whatsapp: '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M17.47 14.38c-.3-.15-1.75-.86-2.02-.96-.27-.1-.47-.15-.67.15-.2.3-.77.96-.94 1.16-.17.2-.35.22-.65.07-.3-.15-1.25-.46-2.38-1.46-.88-.78-1.47-1.74-1.64-2.04-.17-.3-.02-.46.13-.61.13-.13.3-.35.45-.52.15-.17.2-.3.3-.5.1-.2.05-.37-.02-.52-.07-.15-.67-1.6-.91-2.2-.24-.58-.49-.5-.67-.5-.17-.01-.37-.01-.57-.01s-.52.07-.79.37c-.27.3-1.03 1-1.03 2.44s1.06 2.84 1.21 3.04c.15.2 2.08 3.17 5.04 4.44.7.3 1.25.48 1.68.62.71.22 1.35.2 1.86.12.57-.08 1.75-.71 2-1.4.25-.7.25-1.29.17-1.41-.07-.12-.27-.2-.57-.35M12.05 21.8h-.04c-1.83 0-3.64-.5-5.21-1.41l-.37-.22-3.88 1.02 1.04-3.78-.24-.39A9.84 9.84 0 0 1 1.97 11.9c0-5.43 4.42-9.85 9.86-9.85 2.63 0 5.1 1.02 6.96 2.89A9.78 9.78 0 0 1 21.7 11.9c0 5.44-4.42 9.87-9.65 9.91M20.52 3.45A11.78 11.78 0 0 0 12.05.07C5.52.07.21 5.39.2 11.91c0 2.09.55 4.13 1.59 5.93L.11 24l6.32-1.66a11.8 11.8 0 0 0 5.62 1.43h.01c6.53 0 11.84-5.31 11.85-11.84a11.79 11.79 0 0 0-3.39-8.48"/></svg>',
        facebook: '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M24 12.07A12 12 0 1 0 10.13 24v-8.44H7.08v-3.49h3.05V9.43c0-3.01 1.79-4.67 4.53-4.67 1.32 0 2.69.23 2.69.23v2.96h-1.52c-1.49 0-1.96.93-1.96 1.87v2.25h3.33l-.53 3.49h-2.8V24A12 12 0 0 0 24 12.07"/></svg>',
        reddit:   '<svg viewBox="0 0 24 24" aria-hidden="true"><path fill="currentColor" d="M12 0a12 12 0 1 0 0 24A12 12 0 0 0 12 0Zm5.01 4.74c.69 0 1.25.56 1.25 1.25a1.25 1.25 0 1 1-2.5.06l-2.6-.55-.8 3.75c1.83.07 3.48.63 4.68 1.49.3-.3.73-.49 1.2-.49.97 0 1.75.79 1.75 1.76 0 .72-.43 1.33-1 1.61.02.18.04.35.04.52 0 2.7-3.13 4.87-7 4.87s-7-2.17-7-4.87c0-.18.01-.36.04-.53A1.75 1.75 0 0 1 4.03 12c0-.97.78-1.75 1.75-1.75.46 0 .9.2 1.2.49 1.21-.88 2.88-1.43 4.75-1.49l.88-4.18a.34.34 0 0 1 .14-.2.35.35 0 0 1 .24-.04l2.91.62a1.21 1.21 0 0 1 1.11-.7ZM9.25 12c-.69 0-1.25.56-1.25 1.25S8.56 14.5 9.25 14.5s1.25-.56 1.25-1.25S9.94 12 9.25 12Zm5.5 0c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25S16 13.94 16 13.25 15.44 12 14.75 12Zm-5.47 4c-.09 0-.17.03-.23.09a.33.33 0 0 0 0 .46c.84.85 2.48.91 2.96.91s2.1-.06 2.96-.91a.33.33 0 0 0 .03-.46.33.33 0 0 0-.47 0c-.54.53-1.68.73-2.51.73s-1.98-.2-2.51-.73a.33.33 0 0 0-.23-.09Z"/></svg>',
        close:    '<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M6 6 18 18M18 6 6 18"/></svg>'
    };

    function openShareModal() {
        if (state.shareSuppressed) return;
        var existing = document.getElementById('xm-share-host');
        if (existing) existing.remove();

        var url      = window.location.href.split('#')[0];
        var shareTxt = (state.opts && state.opts.shareText) ||
                       'Free olympiad math practice with stepwise solutions — try it, via @' + X_HANDLE;
        var encTxt   = encodeURIComponent(shareTxt);
        var encUrl   = encodeURIComponent(url);

        var twitter  = 'https://twitter.com/intent/tweet?text=' + encTxt + '&url=' + encUrl;
        var linkedin = 'https://www.linkedin.com/sharing/share-offsite/?url=' + encUrl;
        var facebook = 'https://www.facebook.com/sharer/sharer.php?u=' + encUrl;
        var whatsapp = 'https://wa.me/?text=' + encTxt + '%20' + encUrl;
        var reddit   = 'https://www.reddit.com/submit?url=' + encUrl + '&title=' + encTxt;
        var followX  = 'https://twitter.com/' + X_HANDLE;

        function btn(key, label, href) {
            return '<button class="xm-share-icon-btn xs-' + key + '" data-href="' + escHtml(href) + '" type="button" aria-label="Share on ' + escHtml(label) + '">' +
                   '<span class="xm-share-icon">' + SHARE_ICONS[key] + '</span>' +
                   '<span class="xm-share-label">' + escHtml(label) + '</span>' +
                   '</button>';
        }

        var host = document.createElement('div');
        host.id = 'xm-share-host';
        host.innerHTML = '' +
            '<div class="xm-modal-backdrop" id="xm-share-backdrop">' +
            '  <div class="xm-modal xm-share-modal">' +
            '    <button class="xm-share-x" id="xm-share-close-x" type="button" aria-label="Close">' + SHARE_ICONS.close + '</button>' +
            '    <h3>Enjoying the stepwise solutions?</h3>' +
            '    <p>If this is useful, share it — every pass-along helps more students find it.</p>' +
            '    <div class="xm-share-grid">' +
                  btn('x',        'X',        twitter)  +
                  btn('linkedin', 'LinkedIn', linkedin) +
                  btn('whatsapp', 'WhatsApp', whatsapp) +
                  btn('facebook', 'Facebook', facebook) +
                  btn('reddit',   'Reddit',   reddit)   +
            '    </div>' +
            '    <a class="xm-share-via" href="' + escHtml(followX) + '" target="_blank" rel="noopener noreferrer">' +
                   SHARE_ICONS.x + '<span>via @' + X_HANDLE + '</span>' +
            '    </a>' +
            '    <label class="xm-share-mute">' +
            '      <input type="checkbox" id="xm-share-mute"> Don\'t show again this session' +
            '    </label>' +
            '    <div class="xm-modal-actions">' +
            '      <button class="xm-btn xm-btn-primary" id="xm-share-close" type="button">Back to practice</button>' +
            '    </div>' +
            '  </div>' +
            '</div>';
        document.body.appendChild(host);

        function dismiss() {
            var mute = document.getElementById('xm-share-mute');
            if (mute && mute.checked) state.shareSuppressed = true;
            host.remove();
            document.removeEventListener('keydown', onKey);
        }
        function onKey(e) { if (e.key === 'Escape') dismiss(); }

        host.querySelectorAll('.xm-share-icon-btn[data-href]').forEach(function (b) {
            b.addEventListener('click', function () {
                window.open(b.getAttribute('data-href'), '_blank', 'noopener,noreferrer,width=600,height=540');
            });
        });
        document.getElementById('xm-share-close').addEventListener('click', dismiss);
        document.getElementById('xm-share-close-x').addEventListener('click', dismiss);
        document.getElementById('xm-share-backdrop').addEventListener('click', function (e) {
            if (e.target === e.currentTarget) dismiss();
        });
        document.addEventListener('keydown', onKey);
    }

    /* ──────────────────────────────────────────────────────────────────── */
    /* Boot                                                                 */
    /* ──────────────────────────────────────────────────────────────────── */

    function boot() {
        state.phase = 'loading';
        render();
        loadMeta()
            .then(loadRandomShard)
            .then(function () {
                state.phase = 'practice';
                state.shownInShard = 0;
                return nextProblem();
            })
            .catch(function (e) {
                var root = document.getElementById(state.opts.rootId);
                if (root) root.innerHTML = '<div class="xm-card"><div class="op-banner op-banner-bad">' +
                    'Could not load the problem pool: ' + escHtml(e.message) + '</div></div>';
            });
    }

    OlympiadEngine.init = function (opts) {
        state = {
            opts: opts,
            phase: 'loading',
            meta: null,
            shard: null,
            shardName: null,
            shownInShard: 0,
            problem: null,
            solutionShown: false,
            solutionHtml: null,        // cached so re-renders don't lose the loaded walkthrough
            answerPeeked: false,       // user clicked "Peek at answer" — show key without solution
            problemAnimated: false,    // typewriter only runs on first render per problem
            userAnswer: '',
            lastResult: null,
            solCache: {},
            stats: loadStats(),
            clickCount: 0,             // counter for share-popup nudge
            shareSuppressed: false     // user opted out via modal checkbox
        };
        if (typeof katex === 'undefined') {
            var tries = 0;
            (function wait() {
                if (typeof katex !== 'undefined' || tries++ > 50) { boot(); return; }
                setTimeout(wait, 100);
            })();
        } else {
            boot();
        }
    };

    global.OlympiadEngine = OlympiadEngine;
})(window);

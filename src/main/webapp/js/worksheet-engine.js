/**
 * WorksheetEngine - Reusable Print Worksheet Generator
 * Shows config modal → generates worksheet in a full-screen in-page modal overlay
 * with KaTeX rendering and GPT ad placement.
 *
 * Usage:
 *   WorksheetEngine.open({
 *       jsonUrl: '/path/to/questions.json',
 *       title: 'Logarithms',
 *       accentColor: '#0d9488',
 *       branding: '8gwifi.org',
 *       defaultCount: 20
 *   });
 */
var WorksheetEngine = (function() {
'use strict';

var _cache = {};          // jsonUrl → parsed JSON
var _styleInjected = false;

// ==================== Rate Limiting (Exponential Backoff) ====================
// Prevents ad revenue disruption from rapid repeated generations.
// Backoff: 0 → 3s → 5.4s → 9.7s → 17.5s → cap 30s. Resets after 90s idle.

var _rl = {
    count: 0,             // consecutive generate clicks
    lastTime: 0,          // ms timestamp of last generation
    BASE: 3000,           // first cooldown = 3s
    MULTIPLIER: 1.8,      // each subsequent click multiplies
    MAX: 30000,           // hard cap 30s
    RESET_IDLE: 90000,    // reset count after 90s of no generation
    _timer: null          // active countdown interval
};

function _backoffDelay() {
    var now = Date.now();
    // Reset if user has been idle long enough
    if (now - _rl.lastTime > _rl.RESET_IDLE) {
        _rl.count = 0;
    }
    if (_rl.count === 0) return 0;
    return Math.min(_rl.BASE * Math.pow(_rl.MULTIPLIER, _rl.count - 1), _rl.MAX);
}

function _recordGenerate() {
    _rl.lastTime = Date.now();
    _rl.count++;
}

// ==================== Helpers ====================

function esc(s) {
    var d = document.createElement('div');
    d.textContent = s;
    return d.innerHTML;
}

function titleCase(s) {
    return s.replace(/_/g, ' ').replace(/\b\w/g, function(c) { return c.toUpperCase(); });
}

function shuffle(arr) {
    var a = arr.slice();
    for (var i = a.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var t = a[i]; a[i] = a[j]; a[j] = t;
    }
    return a;
}

function difficultyColor(d) {
    var map = { basic: '#22c55e', medium: '#3b82f6', hard: '#f59e0b', scholar: '#ef4444' };
    return map[d] || '#6b7280';
}

function difficultyLabel(d) {
    var map = { basic: 'Basic', medium: 'Medium', hard: 'Hard', scholar: 'Scholar' };
    return map[d] || titleCase(d);
}

// ==================== Style Injection ====================

function injectStyles() {
    if (_styleInjected) return;
    _styleInjected = true;
    var css = [
        /* Config modal backdrop */
        '.we-backdrop{position:fixed;inset:0;z-index:1050;background:rgba(0,0,0,0.5);backdrop-filter:blur(4px);display:flex;align-items:center;justify-content:center;padding:1rem;animation:we-fadeIn .2s ease}',
        '.we-card{position:relative;width:100%;max-width:640px;max-height:92vh;overflow-y:auto;background:var(--bg-primary,#fff);border-radius:1rem;box-shadow:0 25px 50px rgba(0,0,0,0.25);animation:we-slideUp .25s ease}',
        '.we-card-header{padding:1.25rem 1.5rem 1rem;border-bottom:1px solid var(--border,#e5e7eb)}',
        '.we-card-header h3{margin:0;font-size:1.125rem;font-weight:700;color:var(--text-primary,#111)}',
        '.we-card-header p{margin:0.25rem 0 0;font-size:0.75rem;color:var(--text-muted,#9ca3af)}',
        '.we-close{position:absolute;top:1rem;right:1rem;width:2rem;height:2rem;border:none;background:var(--bg-secondary,#f3f4f6);border-radius:0.5rem;cursor:pointer;display:flex;align-items:center;justify-content:center;color:var(--text-muted,#9ca3af);font-size:1.1rem;transition:all .15s}',
        '.we-close:hover{background:var(--bg-tertiary,#e5e7eb);color:var(--text-primary,#111)}',
        '.we-body{padding:1.25rem 1.5rem}',
        '.we-section{margin-bottom:1.125rem}',
        '.we-section-label{font-size:0.6875rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-secondary,#6b7280);margin-bottom:0.375rem;display:flex;align-items:center;justify-content:space-between;gap:0.5rem}',

        /* Select all / none row */
        '.we-select-all-row{display:flex;gap:0.375rem;margin-bottom:0.5rem}',
        '.we-sa-btn{padding:0.2rem 0.625rem;font-size:0.6875rem;font-weight:600;border-radius:2rem;border:1.5px solid var(--border,#e5e7eb);background:var(--bg-primary,#fff);color:var(--text-secondary,#6b7280);cursor:pointer;transition:all .12s;font-family:inherit}',
        '.we-sa-btn:hover{background:var(--bg-secondary,#f3f4f6);border-color:var(--we-accent,#2563eb);color:var(--we-accent,#2563eb)}',

        /* Chip scroll container */
        '.we-checks-wrap{max-height:9rem;overflow-y:auto;padding-right:2px}',
        '.we-checks-wrap.expanded{max-height:none}',
        '.we-checks{display:flex;flex-wrap:wrap;gap:0.375rem}',
        '.we-expand-btn{display:block;width:100%;margin-top:0.375rem;padding:0.2rem 0;font-size:0.6875rem;font-weight:600;color:var(--we-accent,#2563eb);background:none;border:none;cursor:pointer;text-align:center;font-family:inherit}',
        '.we-expand-btn:hover{text-decoration:underline}',

        '.we-check{display:flex;align-items:center;gap:0.3rem;padding:0.3rem 0.5rem 0.3rem 0.625rem;border:1.5px solid var(--border,#e5e7eb);border-radius:2rem;cursor:pointer;font-size:0.75rem;font-weight:500;color:var(--text-secondary,#6b7280);transition:all .15s;user-select:none;background:var(--bg-primary,#fff)}',
        '.we-check.active{border-color:var(--we-accent,#2563eb);background:var(--we-accent-light,#eff6ff);color:var(--we-accent,#2563eb)}',
        '.we-check:hover:not(.active){background:var(--bg-secondary,#f3f4f6)}',
        '.we-check-dot{width:0.5rem;height:0.5rem;border-radius:50%;border:1.5px solid var(--border,#d1d5db);transition:all .15s;flex-shrink:0}',
        '.we-check.active .we-check-dot{background:var(--we-accent,#2563eb);border-color:var(--we-accent,#2563eb)}',
        '.we-check-count{font-size:0.6rem;font-weight:700;padding:0.1rem 0.3rem;border-radius:2rem;background:rgba(0,0,0,0.07);color:inherit;line-height:1.4;flex-shrink:0}',
        '.we-check.active .we-check-count{background:var(--we-accent,#2563eb);color:#fff}',

        '.we-select{width:100%;padding:0.5rem 0.75rem;border:1.5px solid var(--border,#e5e7eb);border-radius:0.5rem;font-size:0.8125rem;background:var(--bg-primary,#fff);color:var(--text-primary,#111);font-family:inherit;cursor:pointer}',
        '.we-select:focus{outline:none;border-color:var(--we-accent,#2563eb)}',
        '.we-toggle-row{display:flex;align-items:center;justify-content:space-between;padding:0.5rem 0}',
        '.we-toggle-label{font-size:0.8125rem;color:var(--text-primary,#111)}',
        '.we-toggle{position:relative;width:2.5rem;height:1.375rem;background:var(--border,#d1d5db);border-radius:1rem;cursor:pointer;transition:background .2s;border:none;padding:0}',
        '.we-toggle.active{background:var(--we-accent,#2563eb)}',
        '.we-toggle::after{content:"";position:absolute;top:2px;left:2px;width:1rem;height:1rem;background:#fff;border-radius:50%;transition:transform .2s;box-shadow:0 1px 3px rgba(0,0,0,0.2)}',
        '.we-toggle.active::after{transform:translateX(1.125rem)}',
        '.we-footer{display:flex;gap:0.5rem;justify-content:flex-end;padding:1rem 1.5rem;border-top:1px solid var(--border,#e5e7eb)}',
        '.we-btn{padding:0.5rem 1.25rem;font-size:0.8125rem;font-weight:600;border-radius:0.5rem;cursor:pointer;transition:all .15s;font-family:inherit;border:1.5px solid var(--border,#e5e7eb);background:var(--bg-primary,#fff);color:var(--text-secondary,#6b7280)}',
        '.we-btn:hover:not(:disabled){background:var(--bg-secondary,#f3f4f6)}',
        '.we-btn-primary{background:var(--we-accent,#2563eb);color:#fff;border-color:var(--we-accent,#2563eb)}',
        '.we-btn-primary:hover:not(:disabled){opacity:0.9;background:var(--we-accent,#2563eb)}',
        '.we-btn-primary:disabled{opacity:0.55;cursor:not-allowed}',

        /* Cooldown indicator */
        '.we-cooldown-bar{height:3px;border-radius:0 0 0.5rem 0.5rem;background:var(--border,#e5e7eb);overflow:hidden;margin:-1px -1.5rem 0;transition:none}',
        '.we-cooldown-bar-fill{height:100%;background:var(--we-accent,#2563eb);transition:width 0.1s linear}',
        '.we-cooldown-msg{font-size:0.6875rem;color:var(--we-accent,#2563eb);text-align:center;margin-top:0.375rem;min-height:1rem;font-weight:500}',

        /* Worksheet modal (full-screen overlay) */
        '.we-ws-backdrop{position:fixed;inset:0;z-index:1060;background:var(--bg-primary,#fff);overflow-y:auto;animation:we-fadeIn .2s ease}',
        '.we-ws-topbar{position:fixed;bottom:0;left:0;right:0;z-index:1070;display:flex;align-items:center;justify-content:center;gap:0.625rem;padding:0.75rem 1.5rem;background:var(--bg-primary,#fff);border-top:1.5px solid var(--border,#e5e7eb);box-shadow:0 -4px 20px rgba(0,0,0,0.1)}',
        '.we-ws-topbar-title{font-size:0.8125rem;font-weight:600;color:var(--text-secondary,#6b7280);margin-right:auto}',
        '.we-ws-topbar-actions{display:flex;gap:0.5rem;align-items:center}',
        '.we-ws-btn{display:inline-flex;align-items:center;gap:0.375rem;padding:0.4rem 0.875rem;font-size:0.75rem;font-weight:600;border:1.5px solid var(--border,#e5e7eb);border-radius:0.5rem;background:var(--bg-primary,#fff);color:var(--text-secondary,#6b7280);cursor:pointer;transition:all .15s;font-family:inherit}',
        '.we-ws-btn:hover{background:var(--bg-secondary,#f3f4f6);border-color:var(--text-muted,#9ca3af)}',
        '.we-ws-btn-accent{background:var(--we-accent,#2563eb);color:#fff;border-color:var(--we-accent,#2563eb)}',
        '.we-ws-btn-accent:hover{opacity:0.9;background:var(--we-accent,#2563eb)}',
        '.we-ws-close{width:2rem;height:2rem;border:none;background:var(--bg-secondary,#f3f4f6);border-radius:0.5rem;cursor:pointer;display:flex;align-items:center;justify-content:center;color:var(--text-muted,#9ca3af);font-size:1.1rem;transition:all .15s}',
        '.we-ws-close:hover{background:var(--bg-tertiary,#e5e7eb);color:var(--text-primary,#111)}',
        '.we-ws-container{max-width:1100px;margin:0 auto;padding:2rem 1.5rem 5rem}',

        /* Worksheet header */
        '.we-ws-header{text-align:center;margin-bottom:1.5rem;padding-bottom:1rem;border-bottom:2px solid var(--we-accent,#2563eb)}',
        '.we-ws-header h1{font-size:1.5rem;font-weight:700;color:var(--text-primary,#111);margin:0 0 0.25rem;font-family:Georgia,"Times New Roman",serif}',
        '.we-ws-header p{font-size:0.8125rem;color:var(--text-secondary,#6b7280);margin:0;font-weight:500}',
        '.we-ws-info{display:flex;gap:2rem;justify-content:center;align-items:center;margin-top:1rem;padding:0.75rem 1rem;border:1.5px solid var(--border,#e5e7eb);border-radius:0.5rem;background:var(--bg-secondary,#f9fafb)}',
        '.we-ws-info span{font-size:0.8125rem;color:var(--text-secondary,#6b7280)}',
        '.we-ws-info-line{width:8rem;border-bottom:1.5px solid var(--text-muted,#9ca3af);display:inline-block}',

        /* Ad slots */
        '.we-ws-ad{margin:1.5rem 0;text-align:center;min-height:90px;display:flex;align-items:center;justify-content:center;background:var(--bg-secondary,#f9fafb);border:1px dashed var(--border,#e5e7eb);border-radius:0.75rem;overflow:hidden;padding:0.5rem}',
        '.we-ws-ad.we-ws-ad-leader{min-height:110px}',
        '.we-ws-ad-label{font-size:0.625rem;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-muted,#9ca3af)}',
        '.we-ws-ad.filled{background:transparent;border:none;padding:0;min-height:0}',

        /* Questions */
        '.we-ws-q{padding:1rem 1.25rem;margin-bottom:0.75rem;background:var(--bg-primary,#fff);border:1.5px solid var(--border,#e5e7eb);border-radius:0.75rem;transition:border-color .15s}',
        '.we-ws-q:hover{border-color:var(--we-accent,#2563eb)}',
        '.we-ws-q-top{display:flex;align-items:center;gap:0.75rem;margin-bottom:0.5rem}',
        '.we-ws-q-num{width:1.75rem;height:1.75rem;border-radius:50%;background:var(--we-accent,#2563eb);color:#fff;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;flex-shrink:0}',
        '.we-ws-q-badges{display:flex;gap:0.375rem;margin-left:auto;flex-wrap:wrap}',
        '.we-ws-q-badge{padding:0.125rem 0.5rem;font-size:0.625rem;font-weight:600;border-radius:2rem;text-transform:uppercase;letter-spacing:0.03em}',
        '.we-ws-q-type{background:var(--we-accent-light,#eff6ff);color:var(--we-accent,#2563eb)}',
        '.we-ws-q-text{font-size:0.9375rem;color:var(--text-primary,#111);line-height:1.7;margin-bottom:0.5rem}',
        '.we-ws-q-text .katex{font-size:1em}',
        /* Expression block — the actual math, displayed prominently */
        '.we-ws-q-expr{text-align:center;margin:0.625rem 0 0.75rem;padding:0.75rem 1rem;background:var(--bg-secondary,#f9fafb);border-radius:0.5rem;overflow-x:auto}',
        '.we-ws-q-expr .katex-display{margin:0;overflow-x:auto;overflow-y:hidden}',
        '.we-ws-q-expr .katex{font-size:1.15em}',
        '[data-theme="dark"] .we-ws-q-expr{background:var(--bg-tertiary)}',
        '.we-ws-q-figure{text-align:center;margin:0.5rem 0 0.75rem;break-inside:avoid}',
        '.we-ws-q-figure-img{max-width:100%;height:auto;max-height:220px;border-radius:0.375rem}',
        '.we-ws-answer-space{min-height:4rem;border:1.5px dashed var(--border,#e5e7eb);border-radius:0.5rem;background:var(--bg-secondary,#f9fafb);display:flex;align-items:center;justify-content:center}',
        '.we-ws-answer-space span{font-size:0.6875rem;color:var(--text-muted,#d1d5db);font-style:italic}',

        /* Answer key */
        '.we-ws-divider{margin:2rem 0;text-align:center;position:relative}',
        '.we-ws-divider::before{content:"";position:absolute;top:50%;left:0;right:0;height:1.5px;background:var(--border,#e5e7eb)}',
        '.we-ws-divider span{position:relative;background:var(--bg-primary,#fff);padding:0 1rem;font-size:0.875rem;font-weight:700;color:var(--we-accent,#2563eb);text-transform:uppercase;letter-spacing:0.05em}',
        '.we-ws-ak{display:grid;grid-template-columns:1fr;gap:0.5rem}',
        '.we-ws-ak-item{display:flex;align-items:baseline;gap:0.5rem;padding:0.5rem 0.75rem;background:var(--bg-secondary,#f9fafb);border-radius:0.5rem;border:1px solid var(--border,#e5e7eb);overflow-x:auto}',
        '.we-ws-ak-num{font-size:0.75rem;font-weight:700;color:var(--text-muted,#9ca3af);min-width:1.5rem;flex-shrink:0}',
        '.we-ws-ak-val{font-size:0.875rem;color:#16a34a;font-weight:600;min-width:0;overflow-x:auto}',
        '.we-ws-ak-val .katex{font-size:0.9em}',

        /* Footer */
        '.we-ws-footer{margin-top:2rem;padding:0.75rem 1rem;border-top:2px solid var(--border,#e5e7eb);display:flex;align-items:center;justify-content:space-between;gap:1rem;flex-wrap:wrap}',
        '.we-ws-footer-brand{font-size:0.875rem;font-weight:700;color:var(--text-primary,#111);letter-spacing:0.01em;white-space:nowrap}',
        '.we-ws-footer-sub{font-size:0.75rem;color:var(--text-secondary,#6b7280);flex:1;text-align:center}',
        '.we-ws-footer-contact{font-size:0.6875rem;color:var(--text-muted,#9ca3af);white-space:nowrap}',

        /* Animations */
        '@keyframes we-fadeIn{from{opacity:0}to{opacity:1}}',
        '@keyframes we-slideUp{from{opacity:0;transform:translateY(1rem)}to{opacity:1;transform:translateY(0)}}',

        /* Print styles */
        '@media print{',
        /* Ensure colors render in print (not washed out) */
        '  *{-webkit-print-color-adjust:exact!important;print-color-adjust:exact!important}',
        '  body>*:not(.we-ws-backdrop){display:none!important}',
        '  .we-ws-backdrop{position:static!important;overflow:visible!important;z-index:auto!important;background:#fff!important}',
        '  .we-ws-topbar,.we-ws-ad{display:none!important}',
        '  .we-ws-container{padding:0.5rem 1rem;max-width:100%}',
        /* Header — strong black border, crisp fonts */
        '  .we-ws-header{border-bottom:2.5px solid #000}',
        '  .we-ws-header h1{color:#000!important;font-size:1.5rem}',
        '  .we-ws-header p{color:#444!important;font-size:0.8125rem}',
        '  .we-ws-info{border:1.5px solid #aaa;background:#f5f5f5!important}',
        '  .we-ws-info span{color:#333!important;font-weight:500}',
        '  .we-ws-info-line{border-bottom-color:#000}',
        /* Questions — avoid page splits mid-question */
        '  .we-ws-q{break-inside:avoid;border:1.5px solid #bbb!important;background:#fff!important}',
        '  .we-ws-q:hover{border-color:#bbb!important}',
        /* Question number circle */
        '  .we-ws-q-num{background:#111!important;color:#fff!important;-webkit-print-color-adjust:exact!important}',
        /* Question type/difficulty badges */
        '  .we-ws-q-badge{color:#333!important;background:#eee!important;-webkit-print-color-adjust:exact!important}',
        /* Question instruction text */
        '  .we-ws-q-text{color:#000!important;font-size:0.9375rem;font-weight:500}',
        /* Math expression block */
        '  .we-ws-q-expr{background:#f7f7f7!important;border:1.5px solid #ccc!important;overflow:visible}',
        '  .we-ws-q-expr .katex-display{overflow:visible;color:#000!important}',
        '  .we-ws-q-expr .katex{color:#000!important;font-size:1.15em!important}',
        /* Answer space — solid border, clearly visible box */
        '  .we-ws-answer-space{border:1.5px solid #888!important;border-style:dashed!important;background:#fff!important;min-height:3rem}',
        '  .we-ws-answer-space span{color:#ccc!important}',
        /* Answer key */
        '  .we-ws-divider{break-before:page}',
        '  .we-ws-divider::before{background:#999!important}',
        '  .we-ws-divider span{color:#000!important;background:#fff!important;font-weight:800}',
        '  .we-ws-ak{gap:0.375rem}',
        '  .we-ws-ak-item{break-inside:avoid;background:#f7f7f7!important;border:1px solid #ddd!important}',
        '  .we-ws-ak-num{color:#555!important;font-weight:700}',
        '  .we-ws-ak-val{color:#000!important;font-weight:700}',
        '  .we-ws-ak-val .katex{color:#000!important}',
        /* Footer — always visible in print */
        /* Fixed footer repeats on every printed page */
        '  .we-ws-footer{position:fixed!important;bottom:0!important;left:0!important;right:0!important;margin:0!important;border-top:1.5px solid #ccc!important;background:#fff!important;padding:0.35rem 1.5rem!important;display:flex!important;align-items:center!important;justify-content:space-between!important;gap:1rem}',
        '  .we-ws-footer-brand{color:#000!important;font-weight:800;font-size:0.8125rem}',
        '  .we-ws-footer-sub{color:#444!important;font-size:0.6875rem;margin:0!important;flex:1;text-align:center}',
        '  .we-ws-footer-contact{color:#555!important;font-size:0.6875rem;margin:0!important;white-space:nowrap}',
        /* Extra bottom padding so last-page content clears the fixed footer */
        '  .we-ws-container{padding-bottom:3rem!important}',
        '  .we-ws-q-figure-img{max-height:180px;max-width:280px}',
        '}',

        /* Dark theme */
        '[data-theme="dark"] .we-card{background:var(--bg-primary);border:1px solid var(--border)}',
        '[data-theme="dark"] .we-ws-backdrop{background:var(--bg-primary)}',
        '[data-theme="dark"] .we-ws-topbar{background:var(--bg-primary);border-bottom-color:var(--border)}',
        '[data-theme="dark"] .we-ws-q-figure-img{filter:invert(0.88) hue-rotate(180deg)}',
        '[data-theme="dark"] .we-checks-wrap{scrollbar-color:var(--border) transparent}',

        /* Responsive */
        '@media(max-width:640px){',
        '  .we-card{max-width:100%;border-radius:0.75rem}',
        '  .we-ws-info{flex-direction:column;gap:0.75rem}',
        '  .we-ws-ak{gap:0.375rem}',
        '  .we-ws-container{padding:1rem 1rem 5rem}',
        '  .we-ws-topbar-title{display:none}',
        '}'
    ].join('\n');
    var style = document.createElement('style');
    style.id = 'we-engine-styles';
    style.textContent = css;
    document.head.appendChild(style);
}

// ==================== Config Modal ====================

function buildConfigModal(data, opts) {
    var typeCounts = {};
    var diffCounts = {};
    var questions = data.questions || [];
    for (var i = 0; i < questions.length; i++) {
        var q = questions[i];
        typeCounts[q.type] = (typeCounts[q.type] || 0) + 1;
        diffCounts[q.difficulty] = (diffCounts[q.difficulty] || 0) + 1;
    }
    var types = Object.keys(typeCounts);
    var diffs = Object.keys(diffCounts);
    var diffOrder = ['basic', 'medium', 'hard', 'scholar'];
    diffs.sort(function(a, b) {
        var ai = diffOrder.indexOf(a), bi = diffOrder.indexOf(b);
        return (ai === -1 ? 99 : ai) - (bi === -1 ? 99 : bi);
    });

    var accent = opts.accentColor || '#2563eb';

    var backdrop = document.createElement('div');
    backdrop.className = 'we-backdrop';
    backdrop.style.setProperty('--we-accent', accent);
    backdrop.style.setProperty('--we-accent-light', accent + '18');

    var card = document.createElement('div');
    card.className = 'we-card';
    card.addEventListener('click', function(e) { e.stopPropagation(); });

    // Header
    var header = document.createElement('div');
    header.className = 'we-card-header';
    header.innerHTML = '<h3 style="color:' + accent + '">' + esc(opts.title || data.topic || 'Worksheet') + ' Worksheet</h3>'
        + '<p>Generate a practice worksheet with random questions and answer key.</p>';
    card.appendChild(header);

    // Close button
    var closeBtn = document.createElement('button');
    closeBtn.className = 'we-close';
    closeBtn.innerHTML = '&times;';
    closeBtn.title = 'Close';
    card.appendChild(closeBtn);

    // Body
    var body = document.createElement('div');
    body.className = 'we-body';

    // ---- Type chips section with scroll + select-all/none ----
    var typeSection = document.createElement('div');
    typeSection.className = 'we-section';

    var typeLabelRow = document.createElement('div');
    typeLabelRow.className = 'we-section-label';
    typeLabelRow.innerHTML = '<span>Question Types <span style="font-weight:400;color:var(--text-muted)">'
        + types.length + ' types</span></span>';
    typeSection.appendChild(typeLabelRow);

    // Select All / None row
    var saRow = document.createElement('div');
    saRow.className = 'we-select-all-row';
    var saAll = document.createElement('button');
    saAll.type = 'button'; saAll.className = 'we-sa-btn'; saAll.textContent = 'All';
    var saNone = document.createElement('button');
    saNone.type = 'button'; saNone.className = 'we-sa-btn'; saNone.textContent = 'None';
    saRow.appendChild(saAll);
    saRow.appendChild(saNone);
    typeSection.appendChild(saRow);

    // Scrollable wrap (collapsed by default when >12 types)
    var checksWrap = document.createElement('div');
    checksWrap.className = 'we-checks-wrap' + (types.length > 12 ? '' : ' expanded');
    var typeChecks = document.createElement('div');
    typeChecks.className = 'we-checks';
    var typeState = {};
    for (var t = 0; t < types.length; t++) {
        typeState[types[t]] = true;
        var chip = document.createElement('div');
        chip.className = 'we-check active';
        chip.setAttribute('data-val', types[t]);
        chip.innerHTML = '<span class="we-check-dot"></span><span>' + esc(titleCase(types[t])) + '</span><span class="we-check-count">' + typeCounts[types[t]] + '</span>';
        typeChecks.appendChild(chip);
    }
    checksWrap.appendChild(typeChecks);
    typeSection.appendChild(checksWrap);

    // Expand / collapse toggle (only when many types)
    if (types.length > 12) {
        var expandBtn = document.createElement('button');
        expandBtn.type = 'button';
        expandBtn.className = 'we-expand-btn';
        expandBtn.textContent = 'Show all ' + types.length + ' types \u25BE';
        var isExpanded = false;
        expandBtn.addEventListener('click', function() {
            isExpanded = !isExpanded;
            checksWrap.classList.toggle('expanded', isExpanded);
            expandBtn.textContent = isExpanded
                ? 'Collapse \u25B4'
                : 'Show all ' + types.length + ' types \u25BE';
        });
        typeSection.appendChild(expandBtn);
    }

    body.appendChild(typeSection);

    // ---- Difficulty chips ----
    var diffSection = document.createElement('div');
    diffSection.className = 'we-section';
    diffSection.innerHTML = '<div class="we-section-label">Difficulty</div>';
    var diffChecks = document.createElement('div');
    diffChecks.className = 'we-checks';
    var diffState = {};
    for (var d = 0; d < diffs.length; d++) {
        diffState[diffs[d]] = true;
        var dChip = document.createElement('div');
        dChip.className = 'we-check active';
        dChip.setAttribute('data-val', diffs[d]);
        dChip.innerHTML = '<span class="we-check-dot" style="border-color:' + difficultyColor(diffs[d]) + '"></span>'
            + '<span>' + esc(difficultyLabel(diffs[d])) + '</span>';
        diffChecks.appendChild(dChip);
    }
    diffSection.appendChild(diffChecks);
    body.appendChild(diffSection);

    // Question count
    var countSection = document.createElement('div');
    countSection.className = 'we-section';
    countSection.innerHTML = '<div class="we-section-label">Number of Questions</div>'
        + '<select class="we-select" id="we-count-select">'
        + '<option value="10">10 questions</option>'
        + '<option value="15">15 questions</option>'
        + '<option value="20"' + (opts.defaultCount === 20 ? ' selected' : '') + '>20 questions</option>'
        + '<option value="30">30 questions</option>'
        + '<option value="50">50 questions</option>'
        + '<option value="75">75 questions</option>'
        + '<option value="100">100 questions</option>'
        + '</select>';
    body.appendChild(countSection);

    // Answer key toggle
    var akSection = document.createElement('div');
    akSection.className = 'we-section';
    var akRow = document.createElement('div');
    akRow.className = 'we-toggle-row';
    akRow.innerHTML = '<span class="we-toggle-label">Include Answer Key</span>';
    var akToggle = document.createElement('button');
    akToggle.className = 'we-toggle active';
    akToggle.type = 'button';
    var akOn = true;
    akToggle.addEventListener('click', function() {
        akOn = !akOn;
        akToggle.classList.toggle('active', akOn);
    });
    akRow.appendChild(akToggle);
    akSection.appendChild(akRow);
    body.appendChild(akSection);

    card.appendChild(body);

    // Footer: cooldown message + progress bar + generate button
    var footer = document.createElement('div');
    footer.className = 'we-footer';
    footer.style.flexDirection = 'column';
    footer.style.gap = '0.5rem';

    // Cooldown UI (hidden until needed)
    var cooldownMsg = document.createElement('div');
    cooldownMsg.className = 'we-cooldown-msg';
    cooldownMsg.style.display = 'none';
    footer.appendChild(cooldownMsg);

    var cooldownBarWrap = document.createElement('div');
    cooldownBarWrap.className = 'we-cooldown-bar';
    cooldownBarWrap.style.display = 'none';
    var cooldownBarFill = document.createElement('div');
    cooldownBarFill.className = 'we-cooldown-bar-fill';
    cooldownBarFill.style.width = '0%';
    cooldownBarWrap.appendChild(cooldownBarFill);

    var btnRow = document.createElement('div');
    btnRow.style.cssText = 'display:flex;gap:0.5rem;justify-content:flex-end;width:100%';

    var cancelBtn = document.createElement('button');
    cancelBtn.className = 'we-btn';
    cancelBtn.textContent = 'Cancel';
    var genBtn = document.createElement('button');
    genBtn.className = 'we-btn we-btn-primary';
    genBtn.textContent = 'Generate Worksheet';
    btnRow.appendChild(cancelBtn);
    btnRow.appendChild(genBtn);

    footer.appendChild(cooldownBarWrap);
    footer.appendChild(btnRow);
    card.appendChild(footer);
    backdrop.appendChild(card);

    // Toggle logic for chips
    function chipToggle(container, stateObj) {
        container.addEventListener('click', function(e) {
            var chip = e.target.closest('.we-check');
            if (!chip) return;
            var val = chip.getAttribute('data-val');
            stateObj[val] = !stateObj[val];
            chip.classList.toggle('active', stateObj[val]);
        });
    }
    chipToggle(typeChecks, typeState);
    chipToggle(diffChecks, diffState);

    // Select All / None
    saAll.addEventListener('click', function() {
        for (var k in typeState) { typeState[k] = true; }
        typeChecks.querySelectorAll('.we-check').forEach(function(c) { c.classList.add('active'); });
    });
    saNone.addEventListener('click', function() {
        for (var k in typeState) { typeState[k] = false; }
        typeChecks.querySelectorAll('.we-check').forEach(function(c) { c.classList.remove('active'); });
    });

    // Close handlers
    function close() {
        if (_rl._timer) { clearInterval(_rl._timer); _rl._timer = null; }
        backdrop.remove();
    }
    backdrop.addEventListener('click', close);
    closeBtn.addEventListener('click', close);
    cancelBtn.addEventListener('click', close);
    document.addEventListener('keydown', function onEsc(e) {
        if (e.key === 'Escape') {
            close();
            document.removeEventListener('keydown', onEsc);
        }
    });

    // ---- Generate with exponential backoff ----
    genBtn.addEventListener('click', function() {
        var selectedTypes = [];
        for (var k in typeState) { if (typeState[k]) selectedTypes.push(k); }
        var selectedDiffs = [];
        for (var k2 in diffState) { if (diffState[k2]) selectedDiffs.push(k2); }
        var count = parseInt(document.getElementById('we-count-select').value) || 20;

        if (selectedTypes.length === 0 || selectedDiffs.length === 0) {
            cooldownMsg.style.display = 'block';
            cooldownMsg.style.color = '#ef4444';
            cooldownMsg.textContent = 'Select at least one type and one difficulty.';
            setTimeout(function() {
                cooldownMsg.style.display = 'none';
                cooldownMsg.style.color = '';
            }, 3000);
            return;
        }

        // Check backoff
        var delay = _backoffDelay();
        if (delay > 0) {
            // Show countdown and disable button
            genBtn.disabled = true;
            cooldownMsg.style.display = 'block';
            cooldownBarWrap.style.display = 'block';
            cooldownBarFill.style.width = '100%';

            var remaining = delay;
            var step = 100; // tick every 100ms
            _rl._timer = setInterval(function() {
                remaining -= step;
                var pct = Math.max(0, (remaining / delay) * 100);
                cooldownBarFill.style.width = pct + '%';
                var secs = Math.ceil(remaining / 1000);
                cooldownMsg.textContent = 'Please wait ' + secs + 's before generating again\u2026';
                if (remaining <= 0) {
                    clearInterval(_rl._timer);
                    _rl._timer = null;
                    genBtn.disabled = false;
                    cooldownMsg.style.display = 'none';
                    cooldownBarWrap.style.display = 'none';
                    cooldownBarFill.style.width = '0%';
                    // Auto-proceed after cooldown so user doesn't have to click again
                    doGenerate(selectedTypes, selectedDiffs, count);
                }
            }, step);
            return;
        }

        doGenerate(selectedTypes, selectedDiffs, count);
    });

    function doGenerate(selectedTypes, selectedDiffs, count) {
        // Filter questions
        var filtered = [];
        for (var fi = 0; fi < questions.length; fi++) {
            var fq = questions[fi];
            if (selectedTypes.indexOf(fq.type) !== -1 && selectedDiffs.indexOf(fq.difficulty) !== -1) {
                filtered.push(fq);
            }
        }
        if (filtered.length === 0) {
            cooldownMsg.style.display = 'block';
            cooldownMsg.style.color = '#ef4444';
            cooldownMsg.textContent = 'No questions match. Try adjusting filters.';
            setTimeout(function() {
                cooldownMsg.style.display = 'none';
                cooldownMsg.style.color = '';
            }, 3000);
            return;
        }

        // Stratified sampling
        var buckets = {};
        for (var bi = 0; bi < filtered.length; bi++) {
            var bt = filtered[bi].type;
            if (!buckets[bt]) buckets[bt] = [];
            buckets[bt].push(filtered[bi]);
        }
        var bucketKeys = shuffle(Object.keys(buckets));
        for (var bk = 0; bk < bucketKeys.length; bk++) {
            buckets[bucketKeys[bk]] = shuffle(buckets[bucketKeys[bk]]);
        }
        var picked = [];
        if (bucketKeys.length > 1) {
            var perType = Math.max(1, Math.floor(count / bucketKeys.length));
            var usedIds = {};
            for (var ri = 0; ri < bucketKeys.length && picked.length < count; ri++) {
                var take = Math.min(perType, buckets[bucketKeys[ri]].length);
                for (var ti = 0; ti < take && picked.length < count; ti++) {
                    picked.push(buckets[bucketKeys[ri]][ti]);
                    usedIds[buckets[bucketKeys[ri]][ti].id] = true;
                }
            }
            if (picked.length < count) {
                var leftover = shuffle(filtered);
                for (var li = 0; li < leftover.length && picked.length < count; li++) {
                    if (!usedIds[leftover[li].id]) {
                        picked.push(leftover[li]);
                        usedIds[leftover[li].id] = true;
                    }
                }
            }
            picked = shuffle(picked);
        } else {
            picked = shuffle(filtered).slice(0, count);
        }

        _recordGenerate();
        close();
        showWorksheet(picked, opts, akOn);
    }

    document.body.appendChild(backdrop);
    genBtn.focus();
}

// ==================== Worksheet Modal ====================

function showWorksheet(questions, opts, showAnswers) {
    var accent = opts.accentColor || '#2563eb';
    var branding = opts.branding || '8gwifi.org';
    var title = opts.title || 'Worksheet';

    var prevOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';

    var overlay = document.createElement('div');
    overlay.className = 'we-ws-backdrop';
    overlay.style.setProperty('--we-accent', accent);
    overlay.style.setProperty('--we-accent-light', accent + '18');

    // Topbar
    var topbar = document.createElement('div');
    topbar.className = 'we-ws-topbar';
    topbar.innerHTML = '<span class="we-ws-topbar-title">' + esc(title) + ' Worksheet &mdash; ' + questions.length + ' Questions</span>';
    var topActions = document.createElement('div');
    topActions.className = 'we-ws-topbar-actions';

    var printBtn = document.createElement('button');
    printBtn.className = 'we-ws-btn we-ws-btn-accent';
    printBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg> Print';
    printBtn.addEventListener('click', function() { window.print(); });
    topActions.appendChild(printBtn);

    var regenBtn = document.createElement('button');
    regenBtn.className = 'we-ws-btn';
    regenBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg> Regenerate';
    regenBtn.addEventListener('click', function() {
        _destroyAdSlots(liveSlots);
        overlay.remove();
        document.body.style.overflow = prevOverflow;
        var cachedData = _cache[opts.jsonUrl];
        if (cachedData) buildConfigModal(cachedData, opts);
    });
    topActions.appendChild(regenBtn);

    var wsClose = document.createElement('button');
    wsClose.className = 'we-ws-close';
    wsClose.innerHTML = '&times;';
    wsClose.title = 'Close';
    wsClose.addEventListener('click', function() {
        _destroyAdSlots(liveSlots);
        overlay.remove();
        document.body.style.overflow = prevOverflow;
    });
    topActions.appendChild(wsClose);
    topbar.appendChild(topActions);
    overlay.appendChild(topbar);

    document.addEventListener('keydown', function onEsc(e) {
        if (e.key === 'Escape') {
            _destroyAdSlots(liveSlots);
            overlay.remove();
            document.body.style.overflow = prevOverflow;
            document.removeEventListener('keydown', onEsc);
        }
    });

    // Container
    var container = document.createElement('div');
    container.className = 'we-ws-container';

    // Worksheet header
    var wsHeader = document.createElement('div');
    wsHeader.className = 'we-ws-header';
    wsHeader.innerHTML = '<h1>' + esc(title) + ' Worksheet</h1>'
        + '<p>' + esc(branding) + ' &mdash; Practice Problems</p>'
        + '<div class="we-ws-info">'
        + '<span>Name: <span class="we-ws-info-line"></span></span>'
        + '<span>Date: <span class="we-ws-info-line"></span></span>'
        + '<span>Score: <span class="we-ws-info-line" style="width:3rem"></span> / ' + questions.length + '</span>'
        + '</div>';
    container.appendChild(wsHeader);

    // ---- Track GPT slots for cleanup ----
    var liveSlots = [];
    var adDescriptors = [];

    // Leaderboard ad below header — wider slot for better CPM in full-screen overlay
    var adTop = _buildAdSlot('ws-leader-' + Date.now(), 'leader');
    container.appendChild(adTop.el);
    adDescriptors.push(adTop);

    // Questions
    for (var i = 0; i < questions.length; i++) {
        var q = questions[i];

        // Rectangle mid-ad every 10 questions
        if (i > 0 && i % 10 === 0) {
            var adMid = _buildAdSlot('ws-mid-' + i + '-' + Date.now(), 'rect');
            container.appendChild(adMid.el);
            adDescriptors.push(adMid);
        }

        var qDiv = document.createElement('div');
        qDiv.className = 'we-ws-q';

        var topRow = document.createElement('div');
        topRow.className = 'we-ws-q-top';
        topRow.innerHTML = '<div class="we-ws-q-num">' + (i + 1) + '</div>'
            + '<div class="we-ws-q-badges">'
            + '<span class="we-ws-q-badge we-ws-q-type">' + esc(titleCase(q.type)) + '</span>'
            + '<span class="we-ws-q-badge" style="background:' + difficultyColor(q.difficulty) + '18;color:' + difficultyColor(q.difficulty) + '">' + esc(difficultyLabel(q.difficulty)) + '</span>'
            + '</div>';
        qDiv.appendChild(topRow);

        var qText = document.createElement('div');
        qText.className = 'we-ws-q-text';
        qText.innerHTML = renderInlineLatex(q.question_text);
        qDiv.appendChild(qText);

        // The actual math expression — field name varies by generator:
        //   logarithm.py  → expression_latex
        //   derivatives.py → function_latex
        //   integrals.py  → integrand_latex
        //   limits / series / vector → math already embedded in question_text via \(...\)
        var exprLatex = q.expression_latex || q.function_latex || q.integrand_latex || '';
        if (exprLatex) {
            var exprEl = document.createElement('div');
            exprEl.className = 'we-ws-q-expr';
            exprEl.setAttribute('data-katex-display', exprLatex);
            qDiv.appendChild(exprEl);
        }

        if (q.figure_svg) {
            var figDiv = document.createElement('div');
            figDiv.className = 'we-ws-q-figure';
            var figImg = document.createElement('img');
            figImg.className = 'we-ws-q-figure-img';
            figImg.src = q.figure_svg;
            figImg.alt = 'Figure for question ' + (i + 1);
            figImg.loading = 'lazy';
            figDiv.appendChild(figImg);
            qDiv.appendChild(figDiv);
        }

        var ansSpace = document.createElement('div');
        ansSpace.className = 'we-ws-answer-space';
        ansSpace.innerHTML = '<span>Write your answer here</span>';
        qDiv.appendChild(ansSpace);

        container.appendChild(qDiv);
    }

    // Rectangle ad before answer key / footer
    var adBottom = _buildAdSlot('ws-bottom-' + Date.now(), 'rect');
    container.appendChild(adBottom.el);
    adDescriptors.push(adBottom);

    // Answer key
    if (showAnswers) {
        var divider = document.createElement('div');
        divider.className = 'we-ws-divider';
        divider.innerHTML = '<span>Answer Key</span>';
        container.appendChild(divider);

        var akGrid = document.createElement('div');
        akGrid.className = 'we-ws-ak';
        for (var a = 0; a < questions.length; a++) {
            var aq = questions[a];
            var akItem = document.createElement('div');
            akItem.className = 'we-ws-ak-item';
            var answerHtml = aq.answer_latex
                ? '<span class="we-ws-ak-val" data-katex="' + escAttr(aq.answer_latex) + '"></span>'
                : '<span class="we-ws-ak-val">' + esc(aq.answer_plain || 'N/A') + '</span>';
            akItem.innerHTML = '<span class="we-ws-ak-num">' + (a + 1) + '.</span>' + answerHtml;
            akGrid.appendChild(akItem);
        }
        container.appendChild(akGrid);
    }

    var wsFooter = document.createElement('div');
    wsFooter.className = 'we-ws-footer';
    wsFooter.innerHTML = ''
        + '<div class="we-ws-footer-brand">' + esc(branding) + '</div>'
        + '<div class="we-ws-footer-sub">' + esc(title) + ' Practice Worksheet &mdash; Free Math Tools</div>'
        + '<div class="we-ws-footer-contact">Contact &amp; feedback: <strong>@anish2good</strong> on X (Twitter)</div>';
    container.appendChild(wsFooter);

    overlay.appendChild(container);
    document.body.appendChild(overlay);

    // Render KaTeX
    renderAllKatex(overlay);

    // Fire all ads after a short yield to let the DOM paint first (helps ad revenue)
    setTimeout(function() {
        _loadGptAds(adDescriptors, liveSlots);
    }, 300);
}

// ==================== Ad Infrastructure ====================

// GPT network/unit paths — same network code as the rest of the site
var _AD_NETWORK = '/147246189,22976055811';
// Rectangle (300x250) — used for mid-content and bottom slots
var _AD_UNIT_RECT     = _AD_NETWORK + '/8gwifi.org_300x250_rectangle_desktop';
var _AD_SIZES_RECT_D  = [[336, 280], [300, 250], [250, 250]];
var _AD_SIZES_RECT_M  = [[300, 250], [320, 100], [250, 250]];
// Leaderboard (728x90) — used for the top banner slot inside the worksheet
var _AD_UNIT_LEADER   = _AD_NETWORK + '/8gwifi.org_728x90_leaderboard_desktop';
var _AD_SIZES_LEAD_D  = [[970, 250], [970, 90], [728, 90], [728, 250]];
var _AD_SIZES_LEAD_M  = [[320, 100], [300, 250]];

/**
 * Build an ad slot placeholder element + metadata.
 * @param {string} slotKey  Unique key (used to generate div ID)
 * @param {string} [type]   'rect' (default) or 'leader'
 * Returns { el: DOMNode, divId: string, type: string }
 */
function _buildAdSlot(slotKey, type) {
    type = type || 'rect';
    var divId = 'we-ad-' + slotKey.replace(/[^a-z0-9]/gi, '-');
    var wrap = document.createElement('div');
    wrap.className = 'we-ws-ad' + (type === 'leader' ? ' we-ws-ad-leader' : '');
    wrap.setAttribute('data-we-ad-id', divId);

    var inner = document.createElement('div');
    inner.id = divId;
    inner.style.cssText = type === 'leader'
        ? 'min-width:320px;min-height:90px;width:100%;display:flex;align-items:center;justify-content:center'
        : 'min-width:250px;min-height:90px;display:flex;align-items:center;justify-content:center';

    var label = document.createElement('span');
    label.className = 'we-ws-ad-label';
    label.textContent = 'Advertisement';
    inner.appendChild(label);

    wrap.appendChild(inner);
    return { el: wrap, divId: divId, type: type };
}

/**
 * Dynamically define + display + refresh GPT slots for the worksheet overlay.
 * Stores slot references in liveSlots for cleanup on close.
 */
function _loadGptAds(adDescriptors, liveSlots) {
    if (typeof googletag === 'undefined' || !googletag.cmd) return;
    var isDesktop = window.innerWidth >= 768;

    googletag.cmd.push(function() {
        var slotsToRefresh = [];
        for (var i = 0; i < adDescriptors.length; i++) {
            var desc = adDescriptors[i];
            var divId = desc.divId;
            var el = document.getElementById(divId);
            if (!el) continue;
            var isLeader = desc.type === 'leader';
            var unitPath = isLeader ? _AD_UNIT_LEADER : _AD_UNIT_RECT;
            var sizes = isLeader
                ? (isDesktop ? _AD_SIZES_LEAD_D : _AD_SIZES_LEAD_M)
                : (isDesktop ? _AD_SIZES_RECT_D : _AD_SIZES_RECT_M);
            try {
                // Remove label placeholder text
                el.innerHTML = '';
                var slot = googletag.defineSlot(unitPath, sizes, divId);
                if (slot) {
                    slot.addService(googletag.pubads());
                    liveSlots.push(slot);
                    slotsToRefresh.push(slot);
                    googletag.display(divId);
                    // Mark wrapper as filled so border/bg are removed
                    var wrap = el.parentElement;
                    if (wrap) wrap.classList.add('filled');
                }
            } catch (e) {
                // Slot already defined or GPT error — restore label
                el.innerHTML = '<span class="we-ws-ad-label">Advertisement</span>';
            }
        }
        if (slotsToRefresh.length > 0) {
            // Refresh fires the actual ad request (needed because disableInitialLoad is set)
            try { googletag.pubads().refresh(slotsToRefresh); } catch (e) {}
        }
    });
}

/**
 * Destroy GPT slots when the overlay closes to avoid stale slot references.
 */
function _destroyAdSlots(slots) {
    if (!slots || slots.length === 0) return;
    if (typeof googletag === 'undefined' || !googletag.destroySlots) return;
    try { googletag.destroySlots(slots); } catch (e) {}
}

// ==================== LaTeX Helpers ====================

function escAttr(s) {
    return s.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function renderInlineLatex(text) {
    if (!text) return '';
    var result = '';
    var remaining = text;
    var regex = /\\\((.+?)\\\)|\$([^$]+)\$/g;
    var lastIndex = 0;
    var match;
    regex.lastIndex = 0;
    while ((match = regex.exec(remaining)) !== null) {
        if (match.index > lastIndex) {
            result += esc(remaining.substring(lastIndex, match.index));
        }
        var latex = match[1] || match[2];
        result += '<span data-katex="' + escAttr(latex.trim()) + '"></span>';
        lastIndex = regex.lastIndex;
    }
    if (lastIndex < remaining.length) {
        result += esc(remaining.substring(lastIndex));
    }
    return result;
}

function renderAllKatex(root) {
    if (typeof katex === 'undefined') return;

    // Inline math — question text with \(...\) or $...$ markers
    var inlineEls = root.querySelectorAll('[data-katex]');
    for (var i = 0; i < inlineEls.length; i++) {
        try {
            katex.render(inlineEls[i].getAttribute('data-katex'), inlineEls[i], {
                throwOnError: false,
                displayMode: false
            });
        } catch (e) {
            inlineEls[i].textContent = inlineEls[i].getAttribute('data-katex');
        }
    }

    // Display math — the expression_latex block, shown as a centered equation
    var displayEls = root.querySelectorAll('[data-katex-display]');
    for (var j = 0; j < displayEls.length; j++) {
        try {
            katex.render(displayEls[j].getAttribute('data-katex-display'), displayEls[j], {
                throwOnError: false,
                displayMode: true
            });
        } catch (e) {
            // Fallback: show raw LaTeX in a code-style block so it's still readable
            displayEls[j].style.cssText += ';font-family:monospace;font-size:0.875rem;text-align:left;white-space:pre-wrap;word-break:break-all';
            displayEls[j].textContent = displayEls[j].getAttribute('data-katex-display');
        }
    }
}

// ==================== Public API ====================

function open(opts) {
    if (!opts || !opts.jsonUrl) {
        console.error('WorksheetEngine: jsonUrl is required');
        return;
    }
    injectStyles();

    if (_cache[opts.jsonUrl]) {
        buildConfigModal(_cache[opts.jsonUrl], opts);
        return;
    }

    var accent = opts.accentColor || '#2563eb';
    var loadBackdrop = document.createElement('div');
    loadBackdrop.className = 'we-backdrop';
    loadBackdrop.innerHTML = '<div class="we-card" style="text-align:center;padding:2rem">'
        + '<div style="width:24px;height:24px;border:3px solid var(--border,#e5e7eb);border-top-color:' + accent + ';border-radius:50%;animation:we-spin .6s linear infinite;margin:0 auto"></div>'
        + '<p style="margin:0.75rem 0 0;font-size:0.8125rem;color:var(--text-muted,#9ca3af)">Loading question bank\u2026</p>'
        + '</div>';
    if (!document.getElementById('we-spin-style')) {
        var spinStyle = document.createElement('style');
        spinStyle.id = 'we-spin-style';
        spinStyle.textContent = '@keyframes we-spin{to{transform:rotate(360deg)}}';
        document.head.appendChild(spinStyle);
    }
    document.body.appendChild(loadBackdrop);

    fetch(opts.jsonUrl)
        .then(function(r) {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
        })
        .then(function(data) {
            _cache[opts.jsonUrl] = data;
            loadBackdrop.remove();
            buildConfigModal(data, opts);
        })
        .catch(function(err) {
            loadBackdrop.remove();
            alert('Failed to load question bank: ' + err.message);
        });
}

return { open: open };
})();

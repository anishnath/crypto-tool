/**
 * WorksheetEngine - Reusable Print Worksheet Generator
 * Shows config modal → generates worksheet in a full-screen in-page modal overlay
 * with KaTeX rendering and ad placement slots.
 *
 * Usage:
 *   WorksheetEngine.open({
 *       jsonUrl: '/path/to/questions.json',
 *       title: 'Taylor & Maclaurin Series',
 *       accentColor: '#2563eb',
 *       branding: '8gwifi.org',
 *       defaultCount: 20
 *   });
 */
var WorksheetEngine = (function() {
'use strict';

var _cache = {};  // jsonUrl → parsed JSON
var _styleInjected = false;

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
        '.we-card{position:relative;width:100%;max-width:520px;max-height:90vh;overflow-y:auto;background:var(--bg-primary,#fff);border-radius:1rem;box-shadow:0 25px 50px rgba(0,0,0,0.25);animation:we-slideUp .25s ease}',
        '.we-card-header{padding:1.25rem 1.5rem 1rem;border-bottom:1px solid var(--border,#e5e7eb)}',
        '.we-card-header h3{margin:0;font-size:1.125rem;font-weight:700;color:var(--text-primary,#111)}',
        '.we-card-header p{margin:0.25rem 0 0;font-size:0.75rem;color:var(--text-muted,#9ca3af)}',
        '.we-close{position:absolute;top:1rem;right:1rem;width:2rem;height:2rem;border:none;background:var(--bg-secondary,#f3f4f6);border-radius:0.5rem;cursor:pointer;display:flex;align-items:center;justify-content:center;color:var(--text-muted,#9ca3af);font-size:1.1rem;transition:all .15s}',
        '.we-close:hover{background:var(--bg-tertiary,#e5e7eb);color:var(--text-primary,#111)}',
        '.we-body{padding:1.25rem 1.5rem}',
        '.we-section{margin-bottom:1rem}',
        '.we-section-label{font-size:0.6875rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-secondary,#6b7280);margin-bottom:0.5rem}',
        '.we-checks{display:flex;flex-wrap:wrap;gap:0.375rem}',
        '.we-check{display:flex;align-items:center;gap:0.375rem;padding:0.3rem 0.625rem;border:1.5px solid var(--border,#e5e7eb);border-radius:2rem;cursor:pointer;font-size:0.75rem;font-weight:500;color:var(--text-secondary,#6b7280);transition:all .15s;user-select:none;background:var(--bg-primary,#fff)}',
        '.we-check.active{border-color:var(--we-accent,#2563eb);background:var(--we-accent-light,#eff6ff);color:var(--we-accent,#2563eb)}',
        '.we-check:hover:not(.active){background:var(--bg-secondary,#f3f4f6)}',
        '.we-check-dot{width:0.5rem;height:0.5rem;border-radius:50%;border:1.5px solid var(--border,#d1d5db);transition:all .15s}',
        '.we-check.active .we-check-dot{background:var(--we-accent,#2563eb);border-color:var(--we-accent,#2563eb)}',
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
        '.we-btn:hover{background:var(--bg-secondary,#f3f4f6)}',
        '.we-btn-primary{background:var(--we-accent,#2563eb);color:#fff;border-color:var(--we-accent,#2563eb)}',
        '.we-btn-primary:hover{opacity:0.9;background:var(--we-accent,#2563eb)}',

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

        '.we-ws-container{max-width:900px;margin:0 auto;padding:2rem 1.5rem 5rem}',

        /* Worksheet header */
        '.we-ws-header{text-align:center;margin-bottom:1.5rem;padding-bottom:1rem;border-bottom:2px solid var(--we-accent,#2563eb)}',
        '.we-ws-header h1{font-size:1.5rem;font-weight:700;color:var(--text-primary,#111);margin:0 0 0.25rem;font-family:Georgia,"Times New Roman",serif}',
        '.we-ws-header p{font-size:0.8125rem;color:var(--text-muted,#9ca3af);margin:0}',
        '.we-ws-info{display:flex;gap:2rem;justify-content:center;align-items:center;margin-top:1rem;padding:0.75rem 1rem;border:1.5px solid var(--border,#e5e7eb);border-radius:0.5rem;background:var(--bg-secondary,#f9fafb)}',
        '.we-ws-info span{font-size:0.8125rem;color:var(--text-secondary,#6b7280)}',
        '.we-ws-info-line{width:8rem;border-bottom:1.5px solid var(--text-muted,#9ca3af);display:inline-block}',

        /* Ad slots */
        '.we-ws-ad{margin:1.5rem 0;text-align:center;min-height:100px;display:flex;align-items:center;justify-content:center;background:var(--bg-secondary,#f9fafb);border:1px dashed var(--border,#e5e7eb);border-radius:0.75rem;padding:0.5rem}',
        '.we-ws-ad-label{font-size:0.625rem;text-transform:uppercase;letter-spacing:0.05em;color:var(--text-muted,#9ca3af)}',

        /* Questions */
        '.we-ws-q{padding:1rem 1.25rem;margin-bottom:0.75rem;background:var(--bg-primary,#fff);border:1.5px solid var(--border,#e5e7eb);border-radius:0.75rem;transition:border-color .15s}',
        '.we-ws-q:hover{border-color:var(--we-accent,#2563eb)}',
        '.we-ws-q-top{display:flex;align-items:center;gap:0.75rem;margin-bottom:0.5rem}',
        '.we-ws-q-num{width:1.75rem;height:1.75rem;border-radius:50%;background:var(--we-accent,#2563eb);color:#fff;display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:700;flex-shrink:0}',
        '.we-ws-q-badges{display:flex;gap:0.375rem;margin-left:auto}',
        '.we-ws-q-badge{padding:0.125rem 0.5rem;font-size:0.625rem;font-weight:600;border-radius:2rem;text-transform:uppercase;letter-spacing:0.03em}',
        '.we-ws-q-type{background:var(--we-accent-light,#eff6ff);color:var(--we-accent,#2563eb)}',
        '.we-ws-q-text{font-size:0.9375rem;color:var(--text-primary,#111);line-height:1.7;margin-bottom:0.75rem}',
        '.we-ws-q-text .katex{font-size:1em}',
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
        '.we-ws-footer{margin-top:2rem;text-align:center;font-size:0.75rem;color:var(--text-muted,#9ca3af);padding-top:1rem;border-top:1px solid var(--border,#e5e7eb)}',

        /* Animations */
        '@keyframes we-fadeIn{from{opacity:0}to{opacity:1}}',
        '@keyframes we-slideUp{from{opacity:0;transform:translateY(1rem)}to{opacity:1;transform:translateY(0)}}',

        /* Print styles */
        '@media print{',
        '  body>*:not(.we-ws-backdrop){display:none!important}',
        '  .we-ws-backdrop{position:static!important;overflow:visible!important;z-index:auto!important}',
        '  .we-ws-topbar,.we-ws-ad{display:none!important}',
        '  .we-ws-container{padding:0.5rem;max-width:100%}',
        '  .we-ws-q{break-inside:avoid;border:1px solid #ccc}',
        '  .we-ws-q:hover{border-color:#ccc}',
        '  .we-ws-divider{break-before:page}',
        '  .we-ws-header{border-bottom-color:#333}',
        '  .we-ws-ak-item{break-inside:avoid}',
        '}',

        /* Dark theme */
        '[data-theme="dark"] .we-card{background:var(--bg-primary);border:1px solid var(--border)}',
        '[data-theme="dark"] .we-ws-backdrop{background:var(--bg-primary)}',
        '[data-theme="dark"] .we-ws-topbar{background:var(--bg-primary);border-bottom-color:var(--border)}',

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
    // Discover types and difficulties from data
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
    // Order difficulties logically
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

    // Type checkboxes
    var typeSection = document.createElement('div');
    typeSection.className = 'we-section';
    typeSection.innerHTML = '<div class="we-section-label">Question Types</div>';
    var typeChecks = document.createElement('div');
    typeChecks.className = 'we-checks';
    var typeState = {};
    for (var t = 0; t < types.length; t++) {
        typeState[types[t]] = true;
        var chip = document.createElement('div');
        chip.className = 'we-check active';
        chip.setAttribute('data-val', types[t]);
        chip.innerHTML = '<span class="we-check-dot"></span>' + esc(titleCase(types[t]));
        typeChecks.appendChild(chip);
    }
    typeSection.appendChild(typeChecks);
    body.appendChild(typeSection);

    // Difficulty checkboxes
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

    // Include answer key toggle
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

    // Footer
    var footer = document.createElement('div');
    footer.className = 'we-footer';
    var cancelBtn = document.createElement('button');
    cancelBtn.className = 'we-btn';
    cancelBtn.textContent = 'Cancel';
    var genBtn = document.createElement('button');
    genBtn.className = 'we-btn we-btn-primary';
    genBtn.textContent = 'Generate Worksheet';
    footer.appendChild(cancelBtn);
    footer.appendChild(genBtn);
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
            if (stateObj[val]) {
                var dot = chip.querySelector('.we-check-dot');
                if (dot) dot.style.borderColor = '';
            }
        });
    }
    chipToggle(typeChecks, typeState);
    chipToggle(diffChecks, diffState);

    // Close handlers
    function close() {
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

    // Generate handler
    genBtn.addEventListener('click', function() {
        var selectedTypes = [];
        for (var k in typeState) { if (typeState[k]) selectedTypes.push(k); }
        var selectedDiffs = [];
        for (var k2 in diffState) { if (diffState[k2]) selectedDiffs.push(k2); }
        var count = parseInt(document.getElementById('we-count-select').value) || 20;

        if (selectedTypes.length === 0 || selectedDiffs.length === 0) {
            alert('Please select at least one type and one difficulty.');
            return;
        }

        // Filter
        var filtered = [];
        for (var fi = 0; fi < questions.length; fi++) {
            var fq = questions[fi];
            if (selectedTypes.indexOf(fq.type) !== -1 && selectedDiffs.indexOf(fq.difficulty) !== -1) {
                filtered.push(fq);
            }
        }

        if (filtered.length === 0) {
            alert('No questions match your filters. Try adjusting your selections.');
            return;
        }

        // Stratified sampling: pick evenly across types, then fill remainder
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
            // Round 1: take perType from each bucket (1 guaranteed per type)
            for (var ri = 0; ri < bucketKeys.length && picked.length < count; ri++) {
                var take = Math.min(perType, buckets[bucketKeys[ri]].length);
                for (var ti = 0; ti < take && picked.length < count; ti++) {
                    picked.push(buckets[bucketKeys[ri]][ti]);
                    usedIds[buckets[bucketKeys[ri]][ti].id] = true;
                }
            }
            // Round 2: fill remainder from all filtered, skipping already picked
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
        close();
        showWorksheet(picked, opts, akOn);
    });

    document.body.appendChild(backdrop);
    // Focus trap: focus Generate button
    genBtn.focus();
}

// ==================== Worksheet Modal ====================

function showWorksheet(questions, opts, showAnswers) {
    var accent = opts.accentColor || '#2563eb';
    var branding = opts.branding || '8gwifi.org';
    var title = opts.title || 'Worksheet';

    // Lock body scroll
    var prevOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';

    var overlay = document.createElement('div');
    overlay.className = 'we-ws-backdrop';
    overlay.style.setProperty('--we-accent', accent);
    overlay.style.setProperty('--we-accent-light', accent + '18');

    // Top bar
    var topbar = document.createElement('div');
    topbar.className = 'we-ws-topbar';
    topbar.innerHTML = '<span class="we-ws-topbar-title">' + esc(title) + ' Worksheet &mdash; ' + questions.length + ' Questions</span>';
    var topActions = document.createElement('div');
    topActions.className = 'we-ws-topbar-actions';

    // Print button
    var printBtn = document.createElement('button');
    printBtn.className = 'we-ws-btn we-ws-btn-accent';
    printBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg> Print';
    printBtn.addEventListener('click', function() { window.print(); });
    topActions.appendChild(printBtn);

    // Regenerate button
    var regenBtn = document.createElement('button');
    regenBtn.className = 'we-ws-btn';
    regenBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg> Regenerate';
    regenBtn.addEventListener('click', function() {
        overlay.remove();
        document.body.style.overflow = prevOverflow;
        // Re-fetch from cache and show config
        var cachedData = _cache[opts.jsonUrl];
        if (cachedData) {
            buildConfigModal(cachedData, opts);
        }
    });
    topActions.appendChild(regenBtn);

    // Close button
    var wsClose = document.createElement('button');
    wsClose.className = 'we-ws-close';
    wsClose.innerHTML = '&times;';
    wsClose.title = 'Close';
    wsClose.addEventListener('click', function() {
        overlay.remove();
        document.body.style.overflow = prevOverflow;
    });
    topActions.appendChild(wsClose);
    topbar.appendChild(topActions);
    overlay.appendChild(topbar);

    // Escape key
    function onEsc(e) {
        if (e.key === 'Escape') {
            overlay.remove();
            document.body.style.overflow = prevOverflow;
            document.removeEventListener('keydown', onEsc);
        }
    }
    document.addEventListener('keydown', onEsc);

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

    // Ad slot 1 (top)
    var adTop = document.createElement('div');
    adTop.className = 'we-ws-ad';
    adTop.setAttribute('data-ad-slot', 'worksheet-top');
    adTop.innerHTML = '<span class="we-ws-ad-label">Advertisement</span>';
    container.appendChild(adTop);

    // Questions
    for (var i = 0; i < questions.length; i++) {
        var q = questions[i];

        // Insert mid ad after every 10 questions
        if (i > 0 && i % 10 === 0) {
            var adMid = document.createElement('div');
            adMid.className = 'we-ws-ad';
            adMid.setAttribute('data-ad-slot', 'worksheet-mid-' + i);
            adMid.innerHTML = '<span class="we-ws-ad-label">Advertisement</span>';
            container.appendChild(adMid);
        }

        var qDiv = document.createElement('div');
        qDiv.className = 'we-ws-q';

        // Top row: number + badges
        var topRow = document.createElement('div');
        topRow.className = 'we-ws-q-top';
        topRow.innerHTML = '<div class="we-ws-q-num">' + (i + 1) + '</div>'
            + '<div class="we-ws-q-badges">'
            + '<span class="we-ws-q-badge we-ws-q-type">' + esc(titleCase(q.type)) + '</span>'
            + '<span class="we-ws-q-badge" style="background:' + difficultyColor(q.difficulty) + '18;color:' + difficultyColor(q.difficulty) + '">' + esc(difficultyLabel(q.difficulty)) + '</span>'
            + '</div>';
        qDiv.appendChild(topRow);

        // Question text with inline KaTeX markers
        var qText = document.createElement('div');
        qText.className = 'we-ws-q-text';
        qText.innerHTML = renderInlineLatex(q.question_text);
        qDiv.appendChild(qText);

        // Answer space
        var ansSpace = document.createElement('div');
        ansSpace.className = 'we-ws-answer-space';
        ansSpace.innerHTML = '<span>Write your answer here</span>';
        qDiv.appendChild(ansSpace);

        container.appendChild(qDiv);
    }

    // Ad slot (bottom, before answer key)
    var adBottom = document.createElement('div');
    adBottom.className = 'we-ws-ad';
    adBottom.setAttribute('data-ad-slot', 'worksheet-bottom');
    adBottom.innerHTML = '<span class="we-ws-ad-label">Advertisement</span>';
    container.appendChild(adBottom);

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

    // Footer
    var wsFooter = document.createElement('div');
    wsFooter.className = 'we-ws-footer';
    wsFooter.textContent = 'Generated by ' + branding + ' \u2014 ' + title + ' Worksheet';
    container.appendChild(wsFooter);

    overlay.appendChild(container);
    document.body.appendChild(overlay);

    // Render KaTeX
    renderAllKatex(overlay);

    // Try to load ads into slots
    loadWorksheetAds(overlay);
}

// ==================== LaTeX Helpers ====================

function escAttr(s) {
    return s.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function renderInlineLatex(text) {
    if (!text) return '';
    // Split on \( ... \) and $...$ delimiters, render LaTeX parts as data-katex spans
    // Process raw text BEFORE html-escaping so backslash delimiters are intact
    var result = '';
    var remaining = text;
    // Match \( ... \) or $...$ (non-greedy)
    var regex = /\\\((.+?)\\\)|\$([^$]+)\$/g;
    var lastIndex = 0;
    var match;
    regex.lastIndex = 0;
    while ((match = regex.exec(remaining)) !== null) {
        // Text before this match — html-escape it
        if (match.index > lastIndex) {
            result += esc(remaining.substring(lastIndex, match.index));
        }
        // The LaTeX content is in group 1 (\(...\)) or group 2 ($...$)
        var latex = match[1] || match[2];
        result += '<span data-katex="' + escAttr(latex.trim()) + '"></span>';
        lastIndex = regex.lastIndex;
    }
    // Remaining text after last match
    if (lastIndex < remaining.length) {
        result += esc(remaining.substring(lastIndex));
    }
    return result;
}

function renderAllKatex(root) {
    if (typeof katex === 'undefined') return;
    var els = root.querySelectorAll('[data-katex]');
    for (var i = 0; i < els.length; i++) {
        try {
            katex.render(els[i].getAttribute('data-katex'), els[i], {
                throwOnError: false,
                displayMode: false
            });
        } catch (e) {
            els[i].textContent = els[i].getAttribute('data-katex');
        }
    }
}

// ==================== Ad Loading ====================

function loadWorksheetAds(overlay) {
    // If googletag is available, try to fill the ad slots
    if (typeof googletag !== 'undefined' && googletag.cmd) {
        var slots = overlay.querySelectorAll('.we-ws-ad');
        for (var i = 0; i < slots.length; i++) {
            var slot = slots[i];
            var slotId = 'we-ad-' + Date.now() + '-' + i;
            var adDiv = document.createElement('div');
            adDiv.id = slotId;
            adDiv.style.minHeight = '90px';
            slot.innerHTML = '';
            slot.appendChild(adDiv);
            (function(sid) {
                googletag.cmd.push(function() {
                    try {
                        googletag.display(sid);
                    } catch (e) { /* ad slot not defined */ }
                });
            })(slotId);
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

    // Fetch JSON (cached)
    if (_cache[opts.jsonUrl]) {
        buildConfigModal(_cache[opts.jsonUrl], opts);
        return;
    }

    // Show loading state briefly
    var loadBackdrop = document.createElement('div');
    loadBackdrop.className = 'we-backdrop';
    loadBackdrop.innerHTML = '<div class="we-card" style="text-align:center;padding:2rem"><div style="width:24px;height:24px;border:3px solid var(--border,#e5e7eb);border-top-color:' + (opts.accentColor || '#2563eb') + ';border-radius:50%;animation:we-spin .6s linear infinite;margin:0 auto"></div><p style="margin:0.75rem 0 0;font-size:0.8125rem;color:var(--text-muted,#9ca3af)">Loading question bank...</p></div>';
    // Add spin keyframe if not present
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

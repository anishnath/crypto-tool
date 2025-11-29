<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div>
<head>
<title>Password Generator Online – Free | 8gwifi.org</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Free online strong password generator. Create random, secure, high-entropy passwords with length/entropy control, symbols, exclude similar characters, and instant strength meter. 100% client-side."/>
    <meta name="keywords" content="strong password generator, random password generator, secure password generator, generate strong passwords online, high entropy passwords, password strength meter, exclude similar characters, copy password, create passwords online" />
    <link rel="canonical" href="https://8gwifi.org/passwdgen.jsp"/>
    <meta name="robots" content="index,follow" />
    <meta property="og:title" content="Password Generator Online – Free | 8gwifi.org"/>
    <meta property="og:description" content="Generate secure, random passwords with adjustable length or entropy. Exclude similar characters, require sets, and copy/download. Runs entirely in your browser."/>
    <meta property="og:type" content="website"/>
    <meta property="og:url" content="https://8gwifi.org/passwdgen.jsp"/>
    <meta property="og:image" content="https://8gwifi.org/images/site/pass.png"/>
    <meta name="twitter:card" content="summary_large_image"/>
    <meta name="twitter:title" content="Password Generator Online – Free | 8gwifi.org"/>
    <meta name="twitter:description" content="Free client-side password generator with entropy controls, symbols, exclude-similar, and strength meter."/>
    <meta name="twitter:image" content="https://8gwifi.org/images/site/pass.png"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <%@ include file="header-script.jsp"%>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Password Generator Online",
      "description": "Generate secure, random passwords with configurable character sets, entropy controls, and strength analysis. 100% client-side generation.",
      "url": "https://8gwifi.org/passwdgen.jsp",
      "image": "https://8gwifi.org/images/site/pass.png",
      "applicationCategory": "SecurityApplication",
      "operatingSystem": "Any",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
      "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
      "datePublished": "2018-05-26",
      "dateModified": "2025-01-30",
      "featureList": [
        "Length or entropy based generation",
        "Exclude similar/ambiguous characters",
        "Require at least one from each selected set",
        "Avoid sequences and adjacent repeats",
        "Instant strength meter and crack-time estimate",
        "Copy and download generated passwords"
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {"@type": "Question", "name": "How do I generate a strong password?", "acceptedAnswer": {"@type": "Answer", "text": "Select the character sets you need, choose a length (12-24+) or target entropy, then click Generate. Use the strength meter and crack-time estimate to gauge security."}},
        {"@type": "Question", "name": "Are passwords generated client-side?", "acceptedAnswer": {"@type": "Answer", "text": "Yes. All generation happens in your browser using the Web Crypto API for randomness when available. Nothing is uploaded or stored on our servers."}},
        {"@type": "Question", "name": "What does exclude similar characters do?", "acceptedAnswer": {"@type": "Answer", "text": "It removes visually ambiguous characters such as O/0, l/1, |, and certain symbols to make passwords easier to read and transcribe."}},
        {"@type": "Question", "name": "Length vs entropy - what should I choose?", "acceptedAnswer": {"@type": "Answer", "text": "Both work. Length is straightforward (e.g., 16 chars). Entropy aims for a target bit strength. Higher entropy increases resistance to brute force attacks."}},
        {"@type": "Question", "name": "How strong should my password be?", "acceptedAnswer": {"@type": "Answer", "text": "For most accounts, 12-16 characters with mixed sets is good. For high-value accounts, consider 20+ characters. Always enable two-factor authentication when possible."}}
      ]
    }
    </script>

<style>
:root {
    --theme-primary: #0284c7;
    --theme-secondary: #0ea5e9;
    --theme-gradient: linear-gradient(135deg, #0284c7 0%, #0ea5e9 100%);
    --theme-light: #f0f9ff;
}

.tool-card {
    background: #fff;
    border: none;
    border-radius: 12px;
    box-shadow: 0 2px 12px rgba(2, 132, 199, 0.08);
    transition: box-shadow 0.2s ease;
}

.tool-card:hover {
    box-shadow: 0 4px 20px rgba(2, 132, 199, 0.15);
}

.card-header-custom {
    background: var(--theme-gradient);
    color: white;
    border-radius: 12px 12px 0 0 !important;
    padding: 0.875rem 1.25rem;
    font-weight: 600;
}

.result-card {
    background: var(--theme-light);
    border: 2px dashed #bae6fd;
    border-radius: 12px;
    min-height: 200px;
}

.form-section {
    background: var(--theme-light);
    border-radius: 8px;
    padding: 1rem;
    margin-bottom: 1rem;
}

.form-section-title {
    font-weight: 600;
    color: var(--theme-primary);
    margin-bottom: 0.75rem;
    font-size: 0.9rem;
}

.result-placeholder {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    min-height: 180px;
    color: #94a3b8;
}

.result-placeholder i {
    font-size: 3rem;
    margin-bottom: 1rem;
    color: #bae6fd;
}

.result-content {
    display: none;
}

.hash-output {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 1rem;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 0.95rem;
    word-break: break-all;
    position: relative;
}

.eeat-badge {
    background: var(--theme-gradient);
    color: white;
    padding: 0.35rem 0.75rem;
    border-radius: 20px;
    font-size: 0.75rem;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
}

.info-badge {
    background: var(--theme-light);
    color: var(--theme-primary);
    padding: 0.25rem 0.6rem;
    border-radius: 12px;
    font-size: 0.7rem;
    margin-right: 0.5rem;
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
}

.btn-generate {
    background: var(--theme-gradient);
    border: none;
    color: white;
    padding: 0.75rem 2rem;
    border-radius: 8px;
    font-weight: 600;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.btn-generate:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);
    color: white;
}

.btn-action {
    background: white;
    border: 1px solid #e2e8f0;
    color: #64748b;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    font-size: 0.85rem;
    transition: all 0.2s ease;
}

.btn-action:hover {
    border-color: var(--theme-primary);
    color: var(--theme-primary);
    background: var(--theme-light);
}

.meter {
    height: 0.625rem;
    background: #e2e8f0;
    border-radius: 10px;
    overflow: hidden;
}

.meter > span {
    display: block;
    height: 100%;
    background: #dc2626;
    transition: width 0.3s ease, background 0.3s ease;
    border-radius: 10px;
}

.meter.weak > span { background: #dc2626; }
.meter.ok > span { background: #f59e0b; }
.meter.good > span { background: #22c55e; }
.meter.excellent > span { background: var(--theme-primary); }

.related-tools {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 1rem;
}

.related-tool-card {
    background: var(--theme-light);
    border: 1px solid #e0f2fe;
    border-radius: 8px;
    padding: 1rem;
    text-decoration: none;
    transition: all 0.2s ease;
    display: block;
}

.related-tool-card:hover {
    border-color: var(--theme-primary);
    box-shadow: 0 2px 8px rgba(2, 132, 199, 0.15);
    text-decoration: none;
    transform: translateY(-2px);
}

.related-tool-card h6 {
    color: var(--theme-primary);
    margin-bottom: 0.25rem;
    font-size: 0.85rem;
}

.related-tool-card p {
    color: #64748b;
    font-size: 0.75rem;
    margin: 0;
}

.charset-item {
    padding: 0.375rem 0;
    border-bottom: 1px solid #f1f5f9;
}

.charset-item:last-child {
    border-bottom: none;
}

.charset-item small {
    color: #94a3b8;
    font-size: 0.7rem;
}

.form-check-input:checked {
    background-color: var(--theme-primary);
    border-color: var(--theme-primary);
}

.form-range::-webkit-slider-thumb {
    background: var(--theme-primary);
}

.form-range::-webkit-slider-runnable-track {
    background: #e0f2fe;
}

.stats-display {
    background: var(--theme-light);
    border-radius: 8px;
    padding: 0.75rem 1rem;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 0.85rem;
    color: #475569;
}

.crack-time-display {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 0.75rem 1rem;
    font-weight: 600;
    color: var(--theme-primary);
}

.password-output {
    background: white;
    border: 2px solid var(--theme-primary);
    border-radius: 8px;
    padding: 1rem;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 1.1rem;
    color: #1e293b;
}

.password-list {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 0.9rem;
}

.alert-security {
    background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
    border: 1px solid #a7f3d0;
    border-radius: 8px;
    color: #065f46;
}

.code-example {
    background: #1e293b;
    border-radius: 8px;
    padding: 1rem;
    color: #e2e8f0;
    font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
    font-size: 0.8rem;
    overflow-x: auto;
}

.table-params {
    font-size: 0.85rem;
}

.table-params th {
    background: var(--theme-light);
    color: var(--theme-primary);
    font-weight: 600;
}

.strength-label {
    font-size: 0.75rem;
    color: #64748b;
}
</style>

<script type="text/javascript">
"use strict";

var CHARACTER_SETS = [
    [true,  "Numbers",        "0123456789"],
    [true,  "Lowercase",      "abcdefghijklmnopqrstuvwxyz"],
    [true,  "Uppercase",      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"],
    [true,  "Symbols",        "!\"#$%" + String.fromCharCode(38) + "'()*+,-./:;" + String.fromCharCode(60) + "=>?@[\\]^_`{|}~"],
    [false, "Space",          " "]
];
var AMBIGUOUS = new Set([...'O0oIl1|`~;:"' + "'" + '.,{}[]()<>/\\']);

function init() {
    var elements = document.createDocumentFragment();
    CHARACTER_SETS.forEach(function(entry, i) {
        var divElem = document.createElement("div");
        divElem.className = "charset-item form-check";
        var inputElem = document.createElement("input");
        inputElem.type = "checkbox";
        inputElem.checked = entry[0];
        inputElem.id = "charset-" + i;
        inputElem.className = "form-check-input";
        divElem.appendChild(inputElem);
        var labelElem = document.createElement("label");
        labelElem.htmlFor = inputElem.id;
        labelElem.className = "form-check-label";
        labelElem.innerHTML = " " + entry[1] + " <small>(" + entry[2].substring(0, 15) + (entry[2].length > 15 ? "..." : "") + ")</small>";
        divElem.appendChild(labelElem);
        elements.appendChild(divElem);
    });
    var containerElem = document.getElementById("charset-checkboxes");
    if (containerElem) {
        containerElem.insertBefore(elements, containerElem.firstChild);
    }
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}

function randomInt(n) {
    var x = Math.floor(Math.random() * n);
    if (window.crypto || window.msCrypto) {
        var cryptoObj = window.crypto || window.msCrypto;
        if (cryptoObj.getRandomValues) {
            var arr = new Uint32Array(1);
            do { cryptoObj.getRandomValues(arr); }
            while (arr[0] - arr[0] % n > 4294967296 - n);
            x = (x + arr[0]) % n;
        }
    }
    return x;
}
</script>

<script>
function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }

function readPgOptions() {
    return {
        excludeSimilar: document.getElementById('exclude-similar') ? document.getElementById('exclude-similar').checked : false,
        requireEach: document.getElementById('require-each') ? document.getElementById('require-each').checked : false,
        noRepeatAdjacent: document.getElementById('no-repeat-adj') ? document.getElementById('no-repeat-adj').checked : false,
        avoidSequences: document.getElementById('avoid-seq') ? document.getElementById('avoid-seq').checked : false
    };
}

function buildPgCharset(opts) {
    var charsetStr = '';
    if (typeof CHARACTER_SETS !== 'undefined') {
        CHARACTER_SETS.forEach(function(entry, i) {
            var el = document.getElementById('charset-' + i);
            if (el && el.checked) charsetStr += entry[2];
        });
    }
    var custom = document.getElementById('custom');
    var customchars = document.getElementById('customchars');
    if (custom && custom.checked && customchars) charsetStr += customchars.value;
    charsetStr = charsetStr.replace(/ /g, '\u00A0');
    var set = [];
    for (var i = 0; i < charsetStr.length; i++) {
        var ch = charsetStr[i];
        if (opts.excludeSimilar && typeof AMBIGUOUS !== 'undefined' && AMBIGUOUS.has(ch)) continue;
        if (set.indexOf(ch) === -1) set.push(ch);
    }
    return set;
}

function pickFromSet(sourceStr, masterSet, opts) {
    var pool = [];
    for (var i = 0; i < sourceStr.length; i++) {
        var ch = sourceStr[i];
        if (opts.excludeSimilar && typeof AMBIGUOUS !== 'undefined' && AMBIGUOUS.has(ch)) continue;
        if (masterSet.indexOf(ch) !== -1 && pool.indexOf(ch) === -1) pool.push(ch);
    }
    if (pool.length === 0) return masterSet[randomInt(masterSet.length)];
    return pool[randomInt(pool.length)];
}

function pgShuffle(arr) {
    for (var i = arr.length - 1; i > 0; i--) {
        var j = randomInt(i + 1);
        var t = arr[i];
        arr[i] = arr[j];
        arr[j] = t;
    }
    return arr;
}

function wouldMakeSeq(out, c) {
    var n = out.length;
    if (n < 2) return false;
    var a = out[n-2].charCodeAt(0), b = out[n-1].charCodeAt(0), d = c.charCodeAt(0);
    return (b === a+1 && d === b+1) || (b === a-1 && d === b-1);
}

function renderMeter(bits) {
    var meter = document.getElementById('entropyMeter');
    if (!meter) return;
    var bar = meter.querySelector('span');
    var pct = Math.max(0, Math.min(100, Math.round(bits / 1.5)));
    meter.className = 'meter';
    if (bits >= 128) meter.classList.add('excellent');
    else if (bits >= 80) meter.classList.add('good');
    else if (bits >= 60) meter.classList.add('ok');
    else meter.classList.add('weak');
    bar.style.width = pct + '%';
}

function crackEstimate(bits) {
    var gps = 1e10;
    var sec = Math.pow(2, bits) / gps;
    return humanTime(sec);
}

function humanTime(sec) {
    if (!isFinite(sec) || sec <= 0) return 'instant';
    if (sec > 3.154e16) return 'centuries+';
    var units = [['year', 31557600], ['day', 86400], ['hour', 3600], ['min', 60], ['sec', 1]];
    var parts = [];
    for (var i = 0; i < units.length; i++) {
        var v = Math.floor(sec / units[i][1]);
        if (v > 0) {
            parts.push(v + ' ' + units[i][0] + (v > 1 ? 's' : ''));
            sec -= v * units[i][1];
            if (parts.length === 2) break;
        }
    }
    return parts.length ? parts.join(' ') : 'less than 1 sec';
}

function generate() {
    var opts = readPgOptions();
    var charset = buildPgCharset(opts);
    if (charset.length === 0) { showToast('Character set is empty', 'warning'); return; }
    if (document.getElementById('by-entropy') && document.getElementById('by-entropy').checked && charset.length < 2) {
        showToast('Need at least 2 distinct characters', 'warning');
        return;
    }

    var length = 16;
    if (document.getElementById('by-length') && document.getElementById('by-length').checked) {
        var len = parseInt(document.getElementById('length').value, 10) || 16;
        length = clamp(len, 4, 2048);
    } else if (document.getElementById('entropy')) {
        var bits = parseFloat(document.getElementById('entropy').value) || 128;
        length = Math.ceil(bits * Math.log(2) / Math.log(charset.length));
        length = clamp(length, 4, 2048);
        var lr = document.getElementById('lengthRange');
        if (lr) lr.value = length;
        var ln = document.getElementById('length');
        if (ln) ln.value = length;
    }

    var countEl = document.getElementById('count');
    var count = countEl ? clamp(parseInt(countEl.value, 10) || 1, 1, 200) : 1;
    var out = [];
    for (var j = 0; j < count; j++) {
        out.push(generateOne(length, charset, opts));
    }

    var first = out[0] || '';
    var list = out.join('\n');
    var pw = document.getElementById('password');
    if (pw) pw.value = first;
    var pl = document.getElementById('passwordList');
    if (pl) pl.value = list;

    var entropyBits = (Math.log(charset.length) || 0) * length / Math.log(2);
    var stats = 'Length: ' + length + ' chars | Charset: ' + charset.length + ' symbols | Entropy: ' + (entropyBits < 70 ? entropyBits.toFixed(2) : entropyBits < 200 ? entropyBits.toFixed(1) : entropyBits.toFixed(0)) + ' bits';
    var st = document.getElementById('statistics');
    if (st) st.textContent = stats;
    renderMeter(entropyBits);
    var ct = document.getElementById('crackTime');
    if (ct) ct.textContent = crackEstimate(entropyBits);

    // Show results
    document.getElementById('resultPlaceholder').style.display = 'none';
    document.getElementById('resultContent').style.display = 'block';

    showToast('Generated ' + count + ' password' + (count > 1 ? 's' : ''), 'success');
}

function generateOne(length, charset, opts) {
    var out = [];
    var pre = [];
    if (opts.requireEach && typeof CHARACTER_SETS !== 'undefined') {
        CHARACTER_SETS.forEach(function(entry, i) {
            var el = document.getElementById('charset-' + i);
            if (el && el.checked) {
                pre.push(pickFromSet(entry[2], charset, opts));
            }
        });
    }
    for (var i = pre.length; i < length; i++) {
        var c, guard = 0;
        do {
            c = charset[randomInt(charset.length)];
            guard++;
        } while (((opts.noRepeatAdjacent && out.length > 0 && out[out.length-1] === c) || (opts.avoidSequences && wouldMakeSeq(out, c))) && guard < 1000);
        out.push(c);
    }
    out = out.concat(pre);
    pgShuffle(out);
    return out.join('');
}

function copyField(id, btn) {
    try {
        var el = document.getElementById(id);
        var val = (el && el.value) || '';
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(val).then(function() { showCopied(btn); });
        } else {
            var ta = document.createElement('textarea');
            ta.value = val;
            document.body.appendChild(ta);
            ta.select();
            try { document.execCommand('copy'); } catch(e) {}
            document.body.removeChild(ta);
            showCopied(btn);
        }
    } catch(e) {}
}

function showCopied(btn) {
    if (btn) {
        var orig = btn.getAttribute('data-orig') || btn.innerHTML;
        btn.setAttribute('data-orig', orig);
        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
        setTimeout(function() { btn.innerHTML = btn.getAttribute('data-orig'); }, 1500);
    }
    showToast('Copied to clipboard', 'success');
}

function toggleVisibility(id, btn) {
    try {
        var el = document.getElementById(id);
        if (!el) return;
        if (el.type === 'text') {
            el.type = 'password';
            if (btn) btn.innerHTML = '<i class="fas fa-eye"></i>';
        } else {
            el.type = 'text';
            if (btn) btn.innerHTML = '<i class="fas fa-eye-slash"></i>';
        }
    } catch(e) {}
}

function downloadList() {
    try {
        var v = (document.getElementById('passwordList').value) || '';
        if (!v) { showToast('Nothing to download', 'warning'); return; }
        var blob = new Blob([v], {type: 'text/plain'});
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = 'passwords_' + Date.now() + '.txt';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        showToast('Download started', 'success');
    } catch(e) {}
}

function showToast(message, type) {
    var bgColor = type === 'success' ? 'var(--theme-gradient)' : type === 'warning' ? 'linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%)' : 'var(--theme-gradient)';
    var toast = $('<div class="position-fixed" style="bottom: 20px; right: 20px; z-index: 9999;">' +
        '<div class="toast show" style="background: ' + bgColor + '; border: none; border-radius: 8px;">' +
        '<div class="toast-body text-white" style="padding: 0.75rem 1rem;">' +
        '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle') + ' me-2"></i>' + message + '</div></div></div>');
    $('body').append(toast);
    setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2500);
}

function copyCmd(cmd) {
    navigator.clipboard.writeText(cmd).then(function() {
        showToast('Command copied', 'success');
    });
}
</script>

</head>

<%@ include file="body-script.jsp"%>

<div class="container mt-4">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h1 class="h4 mb-1"><i class="fas fa-key me-2" style="color: var(--theme-primary);"></i>Password Generator</h1>
            <div class="mt-2">
                <span class="info-badge"><i class="fas fa-lock"></i> Client-Side</span>
                <span class="info-badge"><i class="fas fa-shield-alt"></i> Crypto API</span>
                <span class="info-badge"><i class="fas fa-bolt"></i> High Entropy</span>
                <span class="info-badge"><i class="fas fa-eye-slash"></i> Zero Upload</span>
            </div>
        </div>
        <div class="eeat-badge">
            <i class="fas fa-user-check"></i>
            <span>Anish Nath</span>
        </div>
    </div>

    <!-- Security Notice -->
    <div class="alert alert-security mb-4">
        <i class="fas fa-shield-alt me-2"></i>
        <strong>Secure:</strong> All passwords generated in your browser using Web Crypto API. Nothing is transmitted to our servers.
    </div>

    <form method="get" onsubmit="generate(); return false;">
        <div class="row">
            <!-- Left Column - Configuration -->
            <div class="col-lg-5">
                <!-- Character Sets Card -->
                <div class="card tool-card mb-3">
                    <div class="card-header-custom">
                        <i class="fas fa-font me-2"></i>Character Sets
                    </div>
                    <div class="card-body">
                        <div id="charset-checkboxes" class="mb-3"></div>

                        <div class="form-section">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="custom">
                                <label class="form-check-label" for="custom">Custom Characters</label>
                            </div>
                            <input type="text" class="form-control form-control-sm mt-2" id="customchars" placeholder="Add extra characters here..." oninput="document.getElementById('custom').checked=true;">
                        </div>

                        <div class="form-section-title"><i class="fas fa-cog me-1"></i> Options</div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="exclude-similar">
                            <label class="form-check-label" for="exclude-similar">
                                Exclude similar characters <small class="text-muted">(O, 0, l, 1, |)</small>
                            </label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="require-each" checked>
                            <label class="form-check-label" for="require-each">
                                Require one from each selected set
                            </label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="checkbox" id="no-repeat-adj" checked>
                            <label class="form-check-label" for="no-repeat-adj">
                                No adjacent repeats <small class="text-muted">(aa, 11)</small>
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="avoid-seq">
                            <label class="form-check-label" for="avoid-seq">
                                Avoid sequences <small class="text-muted">(abc, 123)</small>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Length & Count Card -->
                <div class="card tool-card mb-3">
                    <div class="card-header-custom">
                        <i class="fas fa-sliders-h me-2"></i>Length & Entropy
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="form-check mb-2">
                                <input type="radio" class="form-check-input" name="type" id="by-length" checked>
                                <label class="form-check-label fw-medium" for="by-length">By Length</label>
                            </div>
                            <input type="range" class="form-range" min="4" max="128" step="1" id="lengthRange" value="20" oninput="document.getElementById('length').value=this.value; document.getElementById('by-length').checked=true;">
                            <div class="d-flex align-items-center gap-2">
                                <input type="number" class="form-control" min="4" max="512" value="20" step="1" id="length" style="width: 100px;" oninput="document.getElementById('lengthRange').value=this.value; document.getElementById('by-length').checked=true;">
                                <span class="text-muted small">characters</span>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check mb-2">
                                <input type="radio" class="form-check-input" name="type" id="by-entropy">
                                <label class="form-check-label fw-medium" for="by-entropy">By Target Entropy</label>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <input type="number" class="form-control" min="32" value="128" step="1" id="entropy" style="width: 100px;" oninput="document.getElementById('by-entropy').checked=true;">
                                <span class="text-muted small">bits</span>
                            </div>
                        </div>

                        <hr>

                        <div>
                            <label for="count" class="form-label fw-medium">How Many Passwords?</label>
                            <input type="number" id="count" class="form-control" min="1" max="200" value="5" style="width: 100px;">
                        </div>
                    </div>
                </div>

                <!-- Generate Button -->
                <button type="submit" class="btn btn-generate btn-lg w-100 mb-3" onclick="generate(); return false;">
                    <i class="fas fa-bolt me-2"></i>Generate Passwords
                </button>
            </div>

            <!-- Right Column - Results -->
            <div class="col-lg-7">
                <!-- Strength Meter Card -->
                <div class="card tool-card mb-3">
                    <div class="card-header-custom">
                        <i class="fas fa-tachometer-alt me-2"></i>Password Strength
                    </div>
                    <div class="card-body">
                        <div class="meter mb-2" id="entropyMeter"><span style="width: 0;"></span></div>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="strength-label">Weak</span>
                            <span class="strength-label">Moderate</span>
                            <span class="strength-label">Strong</span>
                            <span class="strength-label">Excellent</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small text-muted">Crack Time (10B guesses/sec)</label>
                                <div class="crack-time-display">
                                    <i class="fas fa-clock me-2"></i><span id="crackTime">--</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-muted">Statistics</label>
                                <div class="stats-display" id="statistics">--</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Output Card -->
                <div class="card tool-card mb-3">
                    <div class="card-header-custom">
                        <i class="fas fa-lock me-2"></i>Generated Passwords
                    </div>
                    <div class="card-body">
                        <!-- Placeholder -->
                        <div id="resultPlaceholder" class="result-card p-4">
                            <div class="result-placeholder">
                                <i class="fas fa-key"></i>
                                <p class="mb-0">Click "Generate Passwords" to create secure passwords</p>
                            </div>
                        </div>

                        <!-- Results -->
                        <div id="resultContent" style="display: none;">
                            <label class="form-label small text-muted"><i class="fas fa-star me-1"></i> Primary Password</label>
                            <div class="input-group mb-3">
                                <input type="password" class="form-control password-output" id="password" readonly>
                                <button type="button" class="btn btn-action" title="Toggle visibility" onclick="toggleVisibility('password', this)">
                                    <i class="fas fa-eye"></i>
                                </button>
                                <button type="button" class="btn btn-action" title="Copy" onclick="copyField('password', this)">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </div>

                            <label class="form-label small text-muted"><i class="fas fa-list me-1"></i> All Passwords</label>
                            <textarea id="passwordList" class="form-control password-list" rows="6" readonly></textarea>

                            <div class="mt-3 d-flex gap-2">
                                <button type="button" class="btn btn-action" onclick="copyField('passwordList', this)">
                                    <i class="fas fa-copy me-1"></i> Copy All
                                </button>
                                <button type="button" class="btn btn-action" onclick="downloadList()">
                                    <i class="fas fa-download me-1"></i> Download .txt
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- CLI Commands -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-dark text-white py-2">
            <h6 class="mb-0"><i class="fas fa-terminal me-2"></i>Command Line Alternatives</h6>
        </div>
        <div class="card-body">
            <p class="small text-muted mb-3">Generate passwords from the command line:</p>
            <div class="row g-3">
                <div class="col-md-6">
                    <p class="small mb-1 fw-medium">Linux/macOS (urandom)</p>
                    <div class="code-example">cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%' | head -c 20</div>
                    <button class="btn btn-action btn-sm mt-2" onclick="copyCmd(`cat /dev/urandom | tr -dc 'A-Za-z0-9!@#\$%' | head -c 20`)">
                        <i class="fas fa-copy"></i> Copy
                    </button>
                </div>
                <div class="col-md-6">
                    <p class="small mb-1 fw-medium">OpenSSL</p>
                    <div class="code-example">openssl rand -base64 24 | tr -d '/+=' | head -c 20</div>
                    <button class="btn btn-action btn-sm mt-2" onclick="copyCmd(`openssl rand -base64 24 | tr -d '/+=' | head -c 20`)">
                        <i class="fas fa-copy"></i> Copy
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Educational Content -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light">
            <h5 class="mb-0"><i class="fas fa-graduation-cap me-2" style="color: var(--theme-primary);"></i>Understanding Password Entropy</h5>
        </div>
        <div class="card-body">
            <h6>What is Password Entropy?</h6>
            <p>Entropy measures the randomness and unpredictability of a password. Higher entropy means harder to crack. It's calculated as: <code>E = log2(C^L)</code> where C = charset size and L = length.</p>

            <h6 class="mt-4">Entropy Guidelines</h6>
            <table class="table table-sm table-bordered table-params">
                <thead>
                    <tr>
                        <th>Entropy (bits)</th>
                        <th>Strength</th>
                        <th>Crack Time*</th>
                        <th>Recommended For</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>&lt; 40</td>
                        <td><span class="badge bg-danger">Weak</span></td>
                        <td>Minutes</td>
                        <td>Don't use</td>
                    </tr>
                    <tr>
                        <td>40-60</td>
                        <td><span class="badge bg-warning text-dark">Low</span></td>
                        <td>Days</td>
                        <td>Low-value accounts</td>
                    </tr>
                    <tr>
                        <td>60-80</td>
                        <td><span class="badge bg-info">Moderate</span></td>
                        <td>Years</td>
                        <td>Personal accounts</td>
                    </tr>
                    <tr>
                        <td>80-100</td>
                        <td><span class="badge bg-success">Strong</span></td>
                        <td>Millennia</td>
                        <td>Important accounts</td>
                    </tr>
                    <tr class="table-primary">
                        <td>100-128</td>
                        <td><span class="badge" style="background: var(--theme-primary);">Excellent</span></td>
                        <td>Heat death of universe</td>
                        <td>Critical systems</td>
                    </tr>
                </tbody>
            </table>
            <small class="text-muted">* Assuming 10 billion guesses/second (high-end GPU cluster)</small>

            <h6 class="mt-4">Code Examples</h6>
            <div class="row">
                <div class="col-md-6">
                    <p class="small mb-1 fw-medium">Python (secrets module)</p>
                    <div class="code-example"><code>import secrets
import string

alphabet = string.ascii_letters + string.digits + "!@#$%"
password = ''.join(secrets.choice(alphabet) for _ in range(20))
print(password)</code></div>
                </div>
                <div class="col-md-6">
                    <p class="small mb-1 fw-medium">Node.js (crypto module)</p>
                    <div class="code-example"><code>const crypto = require('crypto');

const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%';
let password = '';
for (let i = 0; i < 20; i++) {
  password += chars[crypto.randomInt(chars.length)];
}</code></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Tools -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light py-2">
            <h6 class="mb-0"><i class="fas fa-tools me-2" style="color: var(--theme-primary);"></i>Related Tools</h6>
        </div>
        <div class="card-body">
            <div class="related-tools">
                <a href="bccrypt.jsp" class="related-tool-card">
                    <h6><i class="fas fa-lock me-1"></i>BCrypt</h6>
                    <p>Hash passwords with BCrypt</p>
                </a>
                <a href="scrypt.jsp" class="related-tool-card">
                    <h6><i class="fas fa-memory me-1"></i>Scrypt</h6>
                    <p>Memory-hard password hashing</p>
                </a>
                <a href="argon2.jsp" class="related-tool-card">
                    <h6><i class="fas fa-trophy me-1"></i>Argon2</h6>
                    <p>PHC winner password hashing</p>
                </a>
                <a href="htpasswd.jsp" class="related-tool-card">
                    <h6><i class="fas fa-server me-1"></i>htpasswd</h6>
                    <p>Apache htpasswd generator</p>
                </a>
                <a href="HashFunctions.jsp" class="related-tool-card">
                    <h6><i class="fas fa-hashtag me-1"></i>Hash Functions</h6>
                    <p>MD5, SHA-1, SHA-256, SHA-512</p>
                </a>
                <a href="hmacgen.jsp" class="related-tool-card">
                    <h6><i class="fas fa-key me-1"></i>HMAC Generator</h6>
                    <p>Generate HMAC signatures</p>
                </a>
            </div>
        </div>
    </div>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>

</div>

<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

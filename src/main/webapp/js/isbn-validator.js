// ========== ISBN LOGIC ==========
function normalizeISBN(isbn) {
    return isbn.replace(/[-\s]/g, '').toUpperCase();
}

function calculateISBN13CheckDigit(isbn) {
    var digits = isbn.substring(0, 12).split('').map(Number);
    var sum = 0;
    for (var i = 0; i < 12; i++) {
        sum += digits[i] * (i % 2 === 0 ? 1 : 3);
    }
    var remainder = sum % 10;
    return remainder === 0 ? 0 : 10 - remainder;
}

function calculateISBN10CheckDigit(isbn) {
    var isbnDigits = normalizeISBN(isbn);
    if (isbnDigits.length < 9) return null;
    var digits = isbnDigits.substring(0, 9).split('').map(Number);
    var sum = 0;
    for (var i = 0; i < 9; i++) {
        sum += digits[i] * (i + 1);
    }
    var remainder = sum % 11;
    if (remainder === 10) return 'X';
    return String(remainder);
}

function validateISBN13(isbn) {
    var normalized = normalizeISBN(isbn);
    if (normalized.length !== 13 || !/^\d{13}$/.test(normalized)) {
        return { valid: false, error: 'ISBN-13 must be exactly 13 digits' };
    }
    if (!normalized.startsWith('978') && !normalized.startsWith('979')) {
        return { valid: false, error: 'ISBN-13 must start with 978 or 979' };
    }
    var checkDigit = calculateISBN13CheckDigit(normalized);
    var providedCheck = parseInt(normalized[12]);
    if (checkDigit !== providedCheck) {
        return { valid: false, error: 'Invalid check digit. Expected ' + checkDigit + ', got ' + providedCheck };
    }
    return { valid: true, isbn: normalized, type: 'ISBN-13', checkDigit: checkDigit };
}

function validateISBN10(isbn) {
    var normalized = normalizeISBN(isbn);
    if (normalized.length !== 10 || !/^[\dX]{10}$/.test(normalized)) {
        return { valid: false, error: 'ISBN-10 must be exactly 10 characters (digits or X)' };
    }
    var checkDigit = calculateISBN10CheckDigit(normalized);
    if (checkDigit === null) {
        return { valid: false, error: 'Error calculating check digit' };
    }
    var providedCheck = normalized[9].toUpperCase();
    if (checkDigit !== providedCheck) {
        return { valid: false, error: 'Invalid check digit. Expected ' + checkDigit + ', got ' + providedCheck };
    }
    return { valid: true, isbn: normalized, type: 'ISBN-10', checkDigit: checkDigit };
}

function convertISBN10To13(isbn10) {
    var normalized = normalizeISBN(isbn10);
    if (normalized.length !== 10) return { error: 'Invalid ISBN-10 format' };
    var isbn13 = '978' + normalized.substring(0, 9);
    var checkDigit = calculateISBN13CheckDigit(isbn13);
    return { isbn13: isbn13 + checkDigit, isbn10: normalized };
}

function convertISBN13To10(isbn13) {
    var normalized = normalizeISBN(isbn13);
    if (normalized.length !== 13 || !normalized.startsWith('978')) {
        return { error: 'Only ISBN-13 starting with 978 can be converted to ISBN-10' };
    }
    var isbn10 = normalized.substring(3, 12);
    var checkDigit = calculateISBN10CheckDigit(isbn10);
    if (checkDigit === null) return { error: 'Error calculating ISBN-10 check digit' };
    return { isbn13: normalized, isbn10: isbn10 + checkDigit };
}

function formatISBN(isbn, type) {
    var n = normalizeISBN(isbn);
    if (type === 'ISBN-13') {
        return n.substring(0,3)+'-'+n.substring(3,4)+'-'+n.substring(4,7)+'-'+n.substring(7,12)+'-'+n.substring(12);
    } else {
        return n.substring(0,1)+'-'+n.substring(1,4)+'-'+n.substring(4,9)+'-'+n.substring(9);
    }
}

// ========== STATE & DOM ==========
var isbnInput = document.getElementById('isbn-input');
var actionSelect = document.getElementById('isbn-action');
var processBtn = document.getElementById('isbn-process-btn');
var convertBtn = document.getElementById('isbn-convert-btn');
var clearBtn = document.getElementById('isbn-clear-btn');
var resultContent = document.getElementById('isbn-result-content');
var resultActions = document.getElementById('isbn-result-actions');
var lastResultText = '';

// ========== CHECK DIGIT STEPS ==========
function buildCheckDigitSteps(isbn, type) {
    var digits = isbn.split('');
    var html = '<div class="isbn-steps"><button class="isbn-steps-header" onclick="this.parentElement.classList.toggle(\'open\')">Check Digit Calculation Steps <span class="isbn-steps-chevron">&#9660;</span></button><div class="isbn-steps-body">';
    if (type === 'ISBN-13') {
        html += '<div style="margin-bottom:0.5rem;color:var(--text-primary);font-weight:600;">ISBN-13 Modulo-10 Algorithm</div>';
        var sum = 0;
        for (var i = 0; i < 12; i++) {
            var w = (i % 2 === 0) ? 1 : 3;
            var p = parseInt(digits[i]) * w;
            sum += p;
            html += '<div class="isbn-step-row"><span>' + digits[i] + ' &times; ' + w + ' = ' + p + '</span><span style="color:var(--text-muted);">pos ' + (i+1) + '</span></div>';
        }
        html += '<div class="isbn-step-row" style="border-top:1px solid var(--border);padding-top:0.375rem;margin-top:0.25rem;"><span class="isbn-step-highlight">Sum = ' + sum + '</span></div>';
        var r = sum % 10;
        var cd = r === 0 ? 0 : 10 - r;
        html += '<div class="isbn-step-row"><span>10 &minus; (' + sum + ' mod 10) = 10 &minus; ' + r + ' = <span class="isbn-step-highlight">' + cd + '</span></span></div>';
    } else {
        html += '<div style="margin-bottom:0.5rem;color:var(--text-primary);font-weight:600;">ISBN-10 Modulo-11 Algorithm</div>';
        var sum = 0;
        for (var i = 0; i < 9; i++) {
            var w = i + 1;
            var p = parseInt(digits[i]) * w;
            sum += p;
            html += '<div class="isbn-step-row"><span>' + digits[i] + ' &times; ' + w + ' = ' + p + '</span><span style="color:var(--text-muted);">pos ' + w + '</span></div>';
        }
        html += '<div class="isbn-step-row" style="border-top:1px solid var(--border);padding-top:0.375rem;margin-top:0.25rem;"><span class="isbn-step-highlight">Sum = ' + sum + '</span></div>';
        var r = sum % 11;
        var cdDisplay = r === 10 ? 'X' : r;
        html += '<div class="isbn-step-row"><span>' + sum + ' mod 11 = <span class="isbn-step-highlight">' + cdDisplay + '</span></span></div>';
    }
    html += '</div></div>';
    return html;
}

// ========== OPEN LIBRARY LOOKUP ==========
function lookupBook(isbn13) {
    var container = document.getElementById('isbn-book-info');
    if (!container) return;
    container.innerHTML = '<div class="isbn-book-loading">Looking up book<span>.</span><span>.</span><span>.</span></div>';

    fetch('https://openlibrary.org/api/books?bibkeys=ISBN:' + isbn13 + '&format=json&jscmd=data')
        .then(function(r) { return r.json(); })
        .then(function(data) {
            var key = 'ISBN:' + isbn13;
            if (!data[key]) {
                container.innerHTML = '<div style="font-size:0.75rem;color:var(--text-muted);">No book metadata found in Open Library.</div>';
                return;
            }
            var book = data[key];
            var coverUrl = book.cover ? (book.cover.medium || book.cover.small) : null;
            var authors = book.authors ? book.authors.map(function(a) { return a.name; }).join(', ') : 'Unknown author';
            var publishers = book.publishers ? book.publishers.map(function(p) { return p.name; }).join(', ') : '';
            var year = book.publish_date || '';
            var pages = book.number_of_pages || '';
            var subjects = book.subjects ? book.subjects.slice(0, 3) : [];

            var html = '<div class="isbn-book-card">';
            if (coverUrl) {
                html += '<img class="isbn-book-cover" src="' + escapeHtml(coverUrl) + '" alt="Book cover" loading="lazy">';
            } else {
                html += '<div class="isbn-book-cover-placeholder">No Cover</div>';
            }
            html += '<div class="isbn-book-meta">';
            html += '<div class="isbn-book-title">' + escapeHtml(book.title || 'Untitled') + '</div>';
            html += '<div class="isbn-book-author">' + escapeHtml(authors) + '</div>';
            html += '<div class="isbn-book-details">';
            if (year) html += '<span class="isbn-book-tag">' + escapeHtml(year) + '</span>';
            if (publishers) html += '<span class="isbn-book-tag">' + escapeHtml(publishers) + '</span>';
            if (pages) html += '<span class="isbn-book-tag">' + pages + ' pages</span>';
            for (var s = 0; s < subjects.length; s++) {
                html += '<span class="isbn-book-tag">' + escapeHtml(subjects[s].name) + '</span>';
            }
            html += '</div></div></div>';
            container.innerHTML = html;
        })
        .catch(function() {
            container.innerHTML = '<div style="font-size:0.75rem;color:var(--text-muted);">Could not fetch book metadata.</div>';
        });
}

// ========== PROCESS ==========
function processISBN() {
    var input = isbnInput.value.trim();
    if (!input) {
        resultContent.innerHTML = '<div class="isbn-warn">Enter an ISBN number to validate</div>';
        return;
    }

    var normalized = normalizeISBN(input);
    var result;

    if (normalized.length === 13) {
        result = validateISBN13(input);
    } else if (normalized.length === 10) {
        result = validateISBN10(input);
    } else {
        resultContent.innerHTML = '<div class="isbn-invalid">Invalid ISBN Length</div><p style="padding:0.5rem;color:var(--text-secondary);font-size:0.8125rem;">ISBN must be 10 or 13 characters (excluding dashes). Got ' + normalized.length + ' characters.</p>';
        resultActions.classList.remove('visible');
        return;
    }

    if (result.valid) {
        var formatted = formatISBN(result.isbn, result.type);
        var html = '';

        html += '<div class="isbn-valid">Valid ' + result.type + '</div>';
        html += '<div class="isbn-display">' + escapeHtml(formatted) + '</div>';

        // Book info from Open Library
        html += '<div id="isbn-book-info"></div>';

        html += '<div class="isbn-info-grid">';
        html += '<div class="isbn-info-row"><span class="isbn-info-label">Type</span><span class="isbn-info-value">' + result.type + '</span></div>';
        html += '<div class="isbn-info-row"><span class="isbn-info-label">Check Digit</span><span class="isbn-info-value">' + result.checkDigit + '</span></div>';
        html += '<div class="isbn-info-row"><span class="isbn-info-label">Raw</span><span class="isbn-info-value">' + result.isbn + '</span></div>';
        html += '</div>';

        // Check digit calculation steps
        html += buildCheckDigitSteps(result.isbn, result.type);

        // Conversion
        if (result.type === 'ISBN-10') {
            var conv = convertISBN10To13(result.isbn);
            if (!conv.error) {
                html += '<div class="isbn-convert-box"><strong>Converted to ISBN-13:</strong><code>' + formatISBN(conv.isbn13, 'ISBN-13') + '</code></div>';
            }
        } else if (result.type === 'ISBN-13' && result.isbn.startsWith('978')) {
            var conv = convertISBN13To10(result.isbn);
            if (!conv.error) {
                html += '<div class="isbn-convert-box"><strong>Converted to ISBN-10:</strong><code>' + formatISBN(conv.isbn10, 'ISBN-10') + '</code></div>';
            }
        } else if (result.type === 'ISBN-13' && result.isbn.startsWith('979')) {
            html += '<div class="isbn-convert-box" style="border-color:var(--warning);"><strong>Cannot convert to ISBN-10</strong><code style="font-size:0.8125rem;color:var(--text-secondary);">ISBN-13 with 979 prefix has no ISBN-10 equivalent</code></div>';
        }

        // Barcode
        var isbnForBarcode = null;
        if (result.type === 'ISBN-13') {
            isbnForBarcode = result.isbn;
        } else {
            var bc = convertISBN10To13(result.isbn);
            if (!bc.error) isbnForBarcode = bc.isbn13;
        }

        if (isbnForBarcode) {
            html += '<div class="isbn-barcode-section"><h5>EAN-13 Barcode</h5><div class="isbn-barcode-area" id="isbn-barcode-area"></div>';
            html += '<div class="isbn-barcode-btns"><button onclick="downloadBarcode(\'png\')">Download PNG</button><button onclick="downloadBarcode(\'svg\')">Download SVG</button></div></div>';
        }

        resultContent.innerHTML = html;
        lastResultText = result.type + ': ' + formatted + ' (Valid, Check Digit: ' + result.checkDigit + ')';
        resultActions.classList.add('visible');

        // Generate barcode after DOM update
        if (isbnForBarcode) {
            setTimeout(function() { generateBarcode(isbnForBarcode); }, 50);
        }

        // Lookup book metadata
        var lookupIsbn = isbnForBarcode || result.isbn;
        setTimeout(function() { lookupBook(lookupIsbn); }, 100);
    } else {
        resultContent.innerHTML = '<div class="isbn-invalid">Invalid ' + (normalized.length === 13 ? 'ISBN-13' : 'ISBN-10') + '</div><p style="padding:0.5rem;color:var(--text-secondary);font-size:0.8125rem;">' + escapeHtml(result.error) + '</p>';
        resultActions.classList.remove('visible');
        lastResultText = '';
    }
}

function generateBarcode(isbn13) {
    var area = document.getElementById('isbn-barcode-area');
    if (!area) return;
    if (typeof JsBarcode === 'undefined') {
        area.innerHTML = '<p style="color:var(--text-muted);font-size:0.8125rem;">Loading barcode library...</p>';
        return;
    }
    var svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.id = 'isbn-barcode-svg';
    try {
        JsBarcode(svg, isbn13, { format: 'EAN13', width: 2, height: 80, displayValue: true, fontSize: 14, margin: 10 });
        area.innerHTML = '';
        area.appendChild(svg);
    } catch (e) {
        area.innerHTML = '<p style="color:var(--error);font-size:0.8125rem;">Barcode error: ' + escapeHtml(e.message) + '</p>';
    }
}

function downloadBarcode(format) {
    var svg = document.getElementById('isbn-barcode-svg');
    if (!svg) return;
    if (format === 'svg') {
        var svgStr = new XMLSerializer().serializeToString(svg);
        var blob = new Blob([svgStr], { type: 'image/svg+xml' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url; a.download = 'isbn-barcode.svg';
        document.body.appendChild(a); a.click(); document.body.removeChild(a);
        URL.revokeObjectURL(url);
    } else {
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d');
        var img = new Image();
        var svgStr = new XMLSerializer().serializeToString(svg);
        var svgBlob = new Blob([svgStr], { type: 'image/svg+xml;charset=utf-8' });
        var url = URL.createObjectURL(svgBlob);
        img.onload = function() {
            canvas.width = img.width; canvas.height = img.height;
            ctx.drawImage(img, 0, 0);
            canvas.toBlob(function(blob) {
                var dUrl = URL.createObjectURL(blob);
                var a = document.createElement('a');
                a.href = dUrl; a.download = 'isbn-barcode.png';
                document.body.appendChild(a); a.click(); document.body.removeChild(a);
                URL.revokeObjectURL(dUrl); URL.revokeObjectURL(url);
            });
        };
        img.src = url;
    }
    if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) ToolUtils.showToast('Barcode downloaded!');
}

function clearAll() {
    isbnInput.value = '';
    resultContent.innerHTML = '<div class="tool-empty-state"><h3>Enter an ISBN to validate</h3><p>Check ISBN format, convert between ISBN-10 and ISBN-13, and generate EAN-13 barcodes.</p></div>';
    resultActions.classList.remove('visible');
    lastResultText = '';
    isbnInput.focus();
}

function copyResult() {
    if (!lastResultText) return;
    if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
        ToolUtils.copyToClipboard(lastResultText);
        ToolUtils.showToast('Copied to clipboard!');
    } else {
        navigator.clipboard.writeText(lastResultText);
    }
}

// ========== UTILS ==========
function escapeHtml(str) {
    if (!str) return '';
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
}

function toggleFaq(btn) {
    var item = btn.closest('.faq-item');
    if (item) item.classList.toggle('open');
}

// ========== AUTO-DETECT ==========
isbnInput.addEventListener('input', function() {
    var n = normalizeISBN(this.value);
    if (n.length === 13) actionSelect.value = 'validate';
    else if (n.length === 10) actionSelect.value = 'convert';
});

// ========== EVENT LISTENERS ==========
processBtn.addEventListener('click', processISBN);
convertBtn.addEventListener('click', processISBN);
clearBtn.addEventListener('click', clearAll);
document.getElementById('isbn-copy-btn').addEventListener('click', copyResult);

isbnInput.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') { e.preventDefault(); processISBN(); }
});

// Sample chips
var chips = document.querySelectorAll('.isbn-chip');
for (var c = 0; c < chips.length; c++) {
    chips[c].addEventListener('click', function() {
        isbnInput.value = this.getAttribute('data-isbn');
        processISBN();
    });
}

// URL param support
(function() {
    var params = new URLSearchParams(window.location.search);
    var isbn = params.get('isbn') || params.get('q');
    if (isbn) { isbnInput.value = isbn; processISBN(); }
})();

/**
 * Shared PGP tool tabs controller.
 * Wires the 4 tabs (Encrypt, Decrypt, Generate Keys, Inspect/Dump) from
 * modern/components/pgp-tool-input-tabs.inc.jsp to the host page's #output panel.
 *
 * Host page contract:
 *   - Has #output (result panel), #resultActions (optional — encrypt-result button row)
 *   - Has DOM from pgp-tool-input-tabs.inc.jsp
 *   - jQuery loaded globally (existing pattern)
 *   - ToolUtils loaded globally (optional, falls back to plain DOM if missing)
 *
 * Usage:
 *   import { initPgpToolTabs } from '/modern/js/pgp/pgp-tool-tabs.js';
 *   initPgpToolTabs({ initialMode: 'encrypt' });
 */

const $ = window.jQuery;
const ToolUtils = window.ToolUtils;

const PGP_FUNCTIONALITY_URL = 'PGPFunctionality';

/** Normalize legacy <font color="..."> wrappers from servlet output into modern alert divs. */
function normalizeServerHtml(msg) {
    let m = String(msg || '')
        .replace(/<font[^>]*color\s*=\s*["']green["'][^>]*>/gi, '<div class="tool-alert tool-alert-success">')
        .replace(/<font[^>]*color\s*=\s*["']red["'][^>]*>/gi, '<div class="tool-alert tool-alert-error">');
    const closeCount = (m.match(/<div class="tool-alert/g) || []).length;
    for (let i = 0; i < closeCount; i++) m = m.replace('</font>', '</div>');
    return m;
}

function isErrorResponse(html) {
    return html.indexOf('tool-alert-error') !== -1
        || html.indexOf('alert-danger') !== -1
        || html.indexOf('System Error') !== -1;
}

function attachKeyActions($outputContainer, opts = {}) {
    const filenameFor = opts.filenameFor || ((val) => val && val.indexOf('PRIVATE') !== -1 ? 'pgp_private_key.asc' : 'pgp_public_key.asc');
    $outputContainer.find('textarea').each(function (idx) {
        const $ta = $(this);
        const taId = opts.idPrefix ? `${opts.idPrefix}_${idx}` : `pgp_output_${idx}`;
        $ta.attr('id', taId);
        const filename = filenameFor($ta.val());
        const actions = $(
            '<div style="display:flex;gap:0.5rem;margin:0.4rem 0 1rem;">' +
              '<button type="button" class="tool-btn tool-btn-sm pgp-out-copy" data-target="' + taId + '">&#128203; Copy</button>' +
              '<button type="button" class="tool-btn tool-btn-sm pgp-out-dl" data-target="' + taId + '" data-filename="' + filename + '">&#8681; Download</button>' +
            '</div>'
        );
        $ta.after(actions);
    });
}

function getResultText() {
    const $ta = $('#output').find('textarea[name="comment"]');
    return $ta.length > 0 ? $ta.val() : null;
}

/** Build the empty-state diagram for a given mode. */
function emptyStateFor(mode) {
    const arrow = '<div class="pgp-flow-arrow"><div class="pgp-flow-arrow-line"></div><div class="pgp-flow-arrow-dot"></div><div class="pgp-flow-arrow-head"></div></div>';

    if (mode === 'genkey') {
        return ''
            + '<div class="tool-empty-state" id="pgpEmptyState"><div class="pgp-flow" id="pgpFlow">'
            + '<div class="pgp-flow-mode">PGP Key Generation</div>'
            + '<div class="pgp-flow-row">'
            +   '<div class="pgp-flow-box pgp-flow-plaintext">Identity + Passphrase</div>'
            +   arrow
            +   '<div class="pgp-flow-box pgp-flow-engine">RSA Keygen<div class="pgp-flow-engine-label">CSRNG</div></div>'
            +   arrow
            +   '<div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">Key Pair</div>'
            + '</div>'
            + '<p class="pgp-flow-caption">Enter an identity + passphrase, pick cipher and key size, then click Generate.</p>'
            + '</div></div>';
    }

    if (mode === 'dump') {
        return ''
            + '<div class="tool-empty-state" id="pgpEmptyState"><div class="pgp-flow" id="pgpFlow">'
            + '<div class="pgp-flow-mode">PGP Packet Inspector</div>'
            + '<div class="pgp-flow-row">'
            +   '<div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.65rem;">PGP Block</div>'
            +   arrow
            +   '<div class="pgp-flow-box pgp-flow-engine">RFC 4880 Parser<div class="pgp-flow-engine-label">pgpdump</div></div>'
            +   arrow
            +   '<div class="pgp-flow-box pgp-flow-plaintext">Packets</div>'
            + '</div>'
            + '<p class="pgp-flow-caption">Paste any armored PGP block to see packet tags, algorithm IDs, key sizes, and fingerprints.</p>'
            + '</div></div>';
    }

    if (mode === 'decrypt') {
        return ''
            + '<div class="tool-empty-state" id="pgpEmptyState"><div class="pgp-flow" id="pgpFlow">'
            + '<div class="pgp-flow-mode">PGP Decrypt</div>'
            + '<div class="pgp-flow-row">'
            +   '<div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">Encrypted</div>'
            +   arrow
            +   '<div class="pgp-flow-box pgp-flow-engine">RSA + AES-256<div class="pgp-flow-engine-label">+ Private Key</div></div>'
            +   arrow
            +   '<div class="pgp-flow-box pgp-flow-plaintext">Message</div>'
            + '</div>'
            + '<p class="pgp-flow-caption">Paste a PGP message + your private key + passphrase, then Decrypt.</p>'
            + '</div></div>';
    }

    return ''
        + '<div class="tool-empty-state" id="pgpEmptyState"><div class="pgp-flow" id="pgpFlow">'
        + '<div class="pgp-flow-mode">PGP Encrypt</div>'
        + '<div class="pgp-flow-row">'
        +   '<div class="pgp-flow-box pgp-flow-plaintext">Message</div>'
        +   arrow
        +   '<div class="pgp-flow-box pgp-flow-engine">ZIP + AES-256<div class="pgp-flow-engine-label">+ Public Key</div></div>'
        +   arrow
        +   '<div class="pgp-flow-box pgp-flow-ciphertext" style="font-size:0.625rem;">PGP Message</div>'
        + '</div>'
        + '<p class="pgp-flow-caption">Enter a message, paste a public key, and click Encrypt.</p>'
        + '</div></div>';
}

/** Public entrypoint. */
export function switchToMode(mode) {
    $('.tool-tab').removeClass('active');
    $('.tool-tab[data-mode="' + mode + '"]').addClass('active');
    $('.tool-form-section').removeClass('active');

    if (mode === 'encrypt')      { $('#encryptSection').addClass('active'); $('#encryptdecrypt').val('encrypt'); }
    else if (mode === 'decrypt') { $('#decryptSection').addClass('active'); $('#encryptdecrypt').val('decrypt'); }
    else if (mode === 'genkey')  { $('#genkeySection').addClass('active'); }
    else if (mode === 'dump')    { $('#dumpSection').addClass('active'); }

    $('#output').html(emptyStateFor(mode));
    $('#resultActions').removeClass('visible');
}

/** ENCRYPT / DECRYPT submission. */
function submitEncryptDecrypt() {
    const isEncrypt = $('#encryptdecrypt').val() === 'encrypt';
    const errs = [];
    if (isEncrypt) {
        if (!$('#p_cmsg').val().trim())       errs.push('Message is required.');
        if (!$('#p_publicKey').val().trim())  errs.push('Recipient public key is required.');
    } else {
        if (!$('#p_pgpmessage').val().trim()) errs.push('Encrypted message is required.');
        if (!$('#p_privateKey').val().trim()) errs.push('Private key is required.');
        if (!$('#p_passpharse').val())        errs.push('Passphrase is required.');
    }
    if (errs.length) {
        if (ToolUtils) ToolUtils.showError('Validation Failed', '#output', errs);
        else $('#output').html('<div class="tool-alert tool-alert-error">' + errs.join('<br>') + '</div>');
        return;
    }

    if (ToolUtils) ToolUtils.showLoading((isEncrypt ? 'Encrypting' : 'Decrypting') + ' your message...', '#output');
    else $('#output').html('<div style="text-align:center;padding:2rem;">Working...</div>');

    $.ajax({
        type: 'POST',
        url: PGP_FUNCTIONALITY_URL,
        data: $('#pgpForm').serialize(),
        success: function (msg) {
            const modernMsg = normalizeServerHtml(msg);
            $('#output').empty();
            const $wrapper = $('<div class="tool-output-wrapper"></div>').append(modernMsg);
            $wrapper.append('<button class="tool-copy-btn" onclick="copyToClipboard(\'#output\')">&#128203; Copy</button>');
            $('#output').append($wrapper);
            if (!isErrorResponse(modernMsg)) {
                $('#resultActions').addClass('visible');
                if (ToolUtils) ToolUtils.showToast(isEncrypt ? 'Message encrypted!' : 'Message decrypted!', 2000, 'success');
            }
        },
        error: function (xhr, status, error) {
            if (ToolUtils) ToolUtils.showError(error || 'Operation failed', '#output', ['Check your connection', 'Verify input fields']);
            else $('#output').html('<div class="tool-alert tool-alert-error">Operation failed.</div>');
        },
    });
}

/** GENERATE KEYS submission. */
function submitGenkey() {
    const identity = $('#pgk_identity').val().trim();
    const passphrase = $('#pgk_passpharse').val();
    const cipher = $('input[name="cipherparameter"]:checked').val();
    const keysize = $('input[name="p_keysize"]:checked').val();

    const errs = [];
    if (!identity) errs.push('Identity is required (name or email).');
    if (identity && !/^[a-z0-9@. ]+$/i.test(identity)) errs.push('Identity may only contain letters, digits, spaces, @, and .');
    if (!passphrase) errs.push('Passphrase is required.');
    if (errs.length) {
        if (ToolUtils) ToolUtils.showError('Validation Failed', '#output', errs);
        else $('#output').html('<div class="tool-alert tool-alert-error">' + errs.join('<br>') + '</div>');
        return;
    }

    if (ToolUtils) ToolUtils.showLoading('Generating ' + keysize + '-bit RSA key pair (' + cipher + ')... up to ~30s for 4096-bit', '#output');
    else $('#output').html('<div style="text-align:center;padding:2rem;">Generating keys...</div>');

    $.ajax({
        type: 'POST',
        url: PGP_FUNCTIONALITY_URL,
        data: $('#pgkForm').serialize(),
        success: function (msg) {
            const modernMsg = normalizeServerHtml(msg);
            $('#output').empty().append(modernMsg);
            attachKeyActions($('#output'), { idPrefix: 'pgk_keyout' });
            if (!isErrorResponse(modernMsg) && ToolUtils) ToolUtils.showToast('Key pair generated for ' + identity, 3000, 'success');
        },
        error: function (xhr, status, error) {
            if (ToolUtils) ToolUtils.showError(error || 'Key generation failed', '#output', ['Check connection', '4096-bit may take 20-40s']);
            else $('#output').html('<div class="tool-alert tool-alert-error">Key generation failed.</div>');
        },
    });
}

/** DUMP / INSPECT submission. */
function submitDump() {
    const raw = $('#p_dump').val();
    if (!raw || !raw.trim()) {
        if (ToolUtils) ToolUtils.showError('Missing Input', '#output', ['Paste a PGP key, message, or signature block.']);
        else $('#output').html('<div class="tool-alert tool-alert-error">Paste a PGP block to inspect.</div>');
        return;
    }
    const hasMarker = /-----BEGIN PGP (PUBLIC KEY BLOCK|PRIVATE KEY BLOCK|MESSAGE|SIGNATURE)-----/.test(raw);
    if (!hasMarker) {
        if (ToolUtils) ToolUtils.showError('Invalid PGP Format', '#output', ['Input must include a BEGIN/END PGP armor block.']);
        else $('#output').html('<div class="tool-alert tool-alert-error">Input must include a BEGIN/END PGP armor block.</div>');
        return;
    }

    if (ToolUtils) ToolUtils.showLoading('Parsing PGP packets...', '#output');
    else $('#output').html('<div style="text-align:center;padding:2rem;">Parsing...</div>');

    $.ajax({
        type: 'POST',
        url: PGP_FUNCTIONALITY_URL,
        data: $('#pgpDumpForm').serialize(),
        success: function (msg) {
            const modernMsg = normalizeServerHtml(msg);
            $('#output').empty().append(modernMsg);
            attachKeyActions($('#output'), { idPrefix: 'pgp_dump_out', filenameFor: () => 'pgp_packet_dump.txt' });
            if (!isErrorResponse(modernMsg) && ToolUtils) ToolUtils.showToast('PGP packets parsed', 2500, 'success');
        },
        error: function (xhr, status, error) {
            if (ToolUtils) ToolUtils.showError(error || 'Failed to parse PGP block', '#output', ['Verify the block is complete', 'Check connection']);
            else $('#output').html('<div class="tool-alert tool-alert-error">Failed to parse PGP block.</div>');
        },
    });
}

/** Email-the-encrypted-result button handler (optional — only fires if #sendEmail exists). */
function wireSendEmail() {
    $('#sendEmail').on('click', function () {
        const text = getResultText();
        if (!text || text.trim() === '') {
            if (ToolUtils) ToolUtils.showToast('Encrypt the message first', 3000, 'warning');
            return;
        }
        const email = prompt("Send the encrypted message to which email address?");
        if (!email) return;
        const validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
        if (!validRegex.test(email)) {
            if (ToolUtils) ToolUtils.showToast('Invalid email address', 3000, 'error');
            return;
        }
        const $btn = $(this);
        const originalLabel = $btn.html();
        $btn.prop('disabled', true).html('<span>&#9203;</span> Sending...');
        if (ToolUtils) ToolUtils.showToast('Sending encrypted message...', 2000, 'info');

        $.ajax({
            type: 'POST',
            url: PGP_FUNCTIONALITY_URL,
            data: {
                methodName: 'PGP_SEND_ENCRYPTION_EMAIL',
                j_csrf: $('input[name="j_csrf"]', '#pgpForm').val(),
                email,
                pgp_message: text,
                p_cmsg: $('#p_cmsg').val() || '',
            },
            success: function (msg) {
                const lower = (msg || '').toLowerCase();
                const ok = lower.indexOf('successfully') !== -1 && lower.indexOf('invalid') === -1;
                if (ToolUtils) {
                    if (ok) ToolUtils.showToast('Encrypted message sent to ' + email, 4000, 'success');
                    else ToolUtils.showToast(lower.indexOf('csrf') !== -1 ? 'Session expired — refresh and try again' : 'Email delivery failed', 4000, 'error');
                }
            },
            error: function (xhr, status, error) {
                if (ToolUtils) ToolUtils.showToast(error || 'Email delivery failed', 4000, 'error');
            },
            complete: function () {
                $btn.prop('disabled', false).html(originalLabel);
            },
        });
    });
}

/** Copy / Download handlers (delegated, idempotent). */
function wireOutputActions() {
    $(document).on('click', '.pgp-out-copy', function () {
        const txt = $('#' + $(this).data('target')).val();
        if (!txt) return;
        if (ToolUtils) ToolUtils.copyToClipboard(txt, { showToast: true, toastMessage: 'Copied to clipboard!' });
        else {
            const ta = document.getElementById($(this).data('target'));
            ta.select(); document.execCommand('copy');
        }
    });
    $(document).on('click', '.pgp-out-dl', function () {
        const txt = $('#' + $(this).data('target')).val();
        const filename = $(this).data('filename') || 'pgp.txt';
        if (!txt) return;
        if (ToolUtils && ToolUtils.downloadAsFile) {
            ToolUtils.downloadAsFile(txt, filename, { showToast: true, toastMessage: filename + ' downloaded' });
        } else {
            const blob = new Blob([txt], { type: 'application/pgp-keys' });
            const a = document.createElement('a');
            a.href = URL.createObjectURL(blob); a.download = filename; a.click();
            URL.revokeObjectURL(a.href);
        }
    });
}

/** Radio-card visual selection (cipher + key size). */
function wireOptionGrids() {
    $('#pgkCipherGrid, #pgkKeysizeGrid').on('change', 'input[type=radio]', function () {
        const $grp = $(this).closest('.pgk-options-grid');
        $grp.find('.pgk-option-label').removeClass('selected');
        $(this).closest('.pgk-option-label').addClass('selected');
    });
}

/** Public entrypoint. */
export function initPgpToolTabs(opts = {}) {
    const initialMode = opts.initialMode || 'encrypt';

    $('.tool-tab').on('click', function () { switchToMode($(this).data('mode')); });
    $('#encryptBtn, #decryptBtn').on('click', submitEncryptDecrypt);
    $('#genkeyBtn').on('click', submitGenkey);
    $('#dumpBtn').on('click', submitDump);

    wireOptionGrids();
    wireOutputActions();
    wireSendEmail();

    // Strip invalid styling on input
    $('textarea, input[type="password"], input[type="text"]').on('input', function () {
        $(this).removeClass('invalid field-invalid');
    });

    switchToMode(initialMode);
}

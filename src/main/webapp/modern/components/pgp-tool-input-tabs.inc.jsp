<%--
  Shared PGP tool input column: 4 tabs (Encrypt, Decrypt, Generate Keys, Inspect/Dump).
  Used by pgpencdec.jsp and pgpkeyfunction.jsp.

  Required on the host page:
    - Output column with #output (for results) and #resultActions (for encrypt-result buttons)
    - JS module: import { initPgpToolTabs } from '<ctx>/modern/js/pgp/pgp-tool-tabs.js'; initPgpToolTabs({ initialMode });
    - CSS: pgpencdec/pgpkeyfunction pages already pull design-system + tool-page styles
       Local pgk-option-* / pgk-section-label styles live in /modern/css/pgp-tool.css

  CSRF: each form carries j_csrf bound to the host JSP's session id.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>

<!-- Mode Selection Tabs -->
<div class="tool-tabs" role="tablist">
    <button type="button" class="tool-tab" data-mode="encrypt" role="tab">
        <span>&#128274;</span> Encrypt Message
    </button>
    <button type="button" class="tool-tab" data-mode="decrypt" role="tab">
        <span>&#128275;</span> Decrypt Message
    </button>
    <button type="button" class="tool-tab" data-mode="genkey" role="tab">
        <span>&#128273;</span> Generate Keys
    </button>
    <button type="button" class="tool-tab" data-mode="dump" role="tab">
        <span>&#128269;</span> Inspect / Dump
    </button>
</div>

<!-- ENCRYPT + DECRYPT form (shared methodName=PGP_ENCRYPTION_DECRYPTION) -->
<form id="pgpForm" method="POST" enctype="application/x-www-form-urlencoded">
    <input type="hidden" name="methodName" id="methodName" value="PGP_ENCRYPTION_DECRYPTION">
    <input type="hidden" name="j_csrf" value="<%=request.getSession().getId() %>">
    <input type="hidden" id="email" name="email" value="">
    <input type="hidden" id="pgp_message" name="pgp_message" value="">
    <input type="hidden" name="encryptdecrypt" id="encryptdecrypt" value="encrypt">

    <!-- ENCRYPT -->
    <div id="encryptSection" class="tool-form-section">
        <div class="tool-input-grid">
            <div class="tool-input-card">
                <div class="tool-input-card-header">
                    <span class="tool-input-card-icon">&#9999;&#65039;</span>
                    <h4>Your Message</h4>
                </div>
                <div class="tool-form-group">
                    <label class="tool-label">Message to Encrypt <span class="tool-badge tool-badge-info">Required</span></label>
                    <p class="tool-hint">Type or paste your secret message</p>
                    <textarea class="tool-textarea auto-resize" id="p_cmsg" name="p_cmsg" placeholder="Type your secret message here..."></textarea>
                    <div class="tool-info-box">&#128161; Only the recipient with the matching private key can decrypt this message</div>
                </div>
            </div>
            <div class="tool-input-card">
                <div class="tool-input-card-header">
                    <span class="tool-input-card-icon">&#128273;</span>
                    <h4>Recipient's Public Key</h4>
                </div>
                <div class="tool-form-group">
                    <label class="tool-label">PGP Public Key <span class="tool-badge tool-badge-info">Required</span></label>
                    <p class="tool-hint">Paste recipient's public key block</p>
                    <textarea class="tool-textarea auto-resize" id="p_publicKey" name="p_publicKey" placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----&#10;Version: ...&#10;&#10;mI0EWi...&#10;-----END PGP PUBLIC KEY BLOCK-----"></textarea>
                </div>
                <div class="tool-form-actions">
                    <button type="button" class="tool-action-btn" id="encryptBtn">
                        &#9889; Run Encryption
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- DECRYPT -->
    <div id="decryptSection" class="tool-form-section">
        <div class="tool-input-grid">
            <div class="tool-input-card">
                <div class="tool-input-card-header">
                    <span class="tool-input-card-icon">&#128232;</span>
                    <h4>Encrypted Message</h4>
                </div>
                <div class="tool-form-group">
                    <label class="tool-label">PGP Encrypted Message <span class="tool-badge tool-badge-info">Required</span></label>
                    <p class="tool-hint">Paste the PGP message block</p>
                    <textarea class="tool-textarea auto-resize" id="p_pgpmessage" name="p_pgpmessage" placeholder="-----BEGIN PGP MESSAGE-----&#10;Version: ...&#10;&#10;hIwD...&#10;-----END PGP MESSAGE-----"></textarea>
                    <div class="tool-info-box">&#9888;&#65039; Include the complete message including BEGIN/END markers</div>
                </div>
            </div>
            <div class="tool-input-card">
                <div class="tool-input-card-header">
                    <span class="tool-input-card-icon">&#128272;</span>
                    <h4>Your Credentials</h4>
                </div>
                <div class="tool-form-group">
                    <label class="tool-label">PGP Private Key <span class="tool-badge tool-badge-info">Required</span></label>
                    <p class="tool-hint">Your private key to decrypt</p>
                    <textarea class="tool-textarea auto-resize" id="p_privateKey" name="p_privateKey" placeholder="-----BEGIN PGP PRIVATE KEY BLOCK-----&#10;...&#10;-----END PGP PRIVATE KEY BLOCK-----"></textarea>
                </div>
                <div class="tool-form-group">
                    <label class="tool-label">Passphrase <span class="tool-badge tool-badge-info">Required</span></label>
                    <p class="tool-hint">Private key passphrase</p>
                    <input type="password" class="tool-input" id="p_passpharse" name="p_passpharse" placeholder="Enter your passphrase">
                </div>
                <div class="tool-form-actions">
                    <button type="button" class="tool-action-btn" id="decryptBtn">
                        &#9889; Run Decryption
                    </button>
                </div>
            </div>
        </div>
    </div>
</form>

<!-- GENERATE KEYS (separate form, methodName=GENERATE_PGEP_KEY) -->
<form id="pgkForm" method="POST" enctype="application/x-www-form-urlencoded">
    <input type="hidden" name="methodName" value="GENERATE_PGEP_KEY">
    <input type="hidden" name="j_csrf" value="<%=request.getSession().getId() %>">
    <input type="hidden" name="email" value="">

    <div id="genkeySection" class="tool-form-section">
        <div class="tool-input-card" style="max-width:none;">
            <div class="tool-input-card-header">
                <span class="tool-input-card-icon">&#128273;</span>
                <h4>Generate PGP Key Pair</h4>
            </div>

            <div class="tool-form-group">
                <label class="tool-label" for="pgk_identity">Identity <span class="tool-badge tool-badge-info">Required</span></label>
                <p class="tool-hint">Name or email address (e.g., <code>alice@example.com</code>)</p>
                <input type="text" class="tool-input" id="pgk_identity" name="p_identity" placeholder="alice@example.com" autocomplete="off">
            </div>

            <div class="tool-form-group">
                <label class="tool-label" for="pgk_passpharse">Passphrase <span class="tool-badge tool-badge-info">Required</span></label>
                <p class="tool-hint">Protects the private key (min 8 characters recommended)</p>
                <input type="password" class="tool-input" id="pgk_passpharse" name="p_passpharse" placeholder="Strong passphrase" autocomplete="new-password">
            </div>

            <div class="pgk-section-label">&#128274; Cipher Algorithm</div>
            <div class="pgk-options-grid" id="pgkCipherGrid">
                <label class="pgk-option-label selected"><input type="radio" name="cipherparameter" value="AES_256" checked><span>AES-256</span><span class="pgk-badge-rec">REC</span></label>
                <label class="pgk-option-label"><input type="radio" name="cipherparameter" value="AES_192"><span>AES-192</span></label>
                <label class="pgk-option-label"><input type="radio" name="cipherparameter" value="AES_128"><span>AES-128</span></label>
                <label class="pgk-option-label"><input type="radio" name="cipherparameter" value="TWOFISH"><span>TWOFISH</span></label>
                <label class="pgk-option-label"><input type="radio" name="cipherparameter" value="BLOWFISH"><span>BLOWFISH</span><span class="pgk-badge-legacy">Legacy</span></label>
                <label class="pgk-option-label"><input type="radio" name="cipherparameter" value="CAST5"><span>CAST5</span><span class="pgk-badge-legacy">Legacy</span></label>
                <label class="pgk-option-label"><input type="radio" name="cipherparameter" value="TRIPLE_DES"><span>3DES</span><span class="pgk-badge-legacy">Legacy</span></label>
            </div>

            <div class="pgk-section-label">&#128207; RSA Key Size</div>
            <div class="pgk-options-grid" id="pgkKeysizeGrid">
                <label class="pgk-option-label selected"><input type="radio" name="p_keysize" value="2048" checked><span>2048-bit</span><span class="pgk-badge-rec">REC</span></label>
                <label class="pgk-option-label"><input type="radio" name="p_keysize" value="4096"><span>4096-bit</span></label>
                <label class="pgk-option-label"><input type="radio" name="p_keysize" value="1024"><span>1024-bit</span><span class="pgk-badge-weak">Weak</span></label>
            </div>

            <div class="tool-info-box">&#128161; Keys are generated server-side via CSRNG and never stored. Save the private key locally &mdash; losing it means losing access.</div>

            <div class="tool-form-actions">
                <button type="button" class="tool-action-btn" id="genkeyBtn">
                    &#128273; Generate Key Pair
                </button>
            </div>
        </div>
    </div>
</form>

<!-- INSPECT / DUMP (separate form, methodName=PGP_DUMP) -->
<form id="pgpDumpForm" method="POST" enctype="application/x-www-form-urlencoded">
    <input type="hidden" name="methodName" value="PGP_DUMP">

    <div id="dumpSection" class="tool-form-section">
        <div class="tool-input-card" style="max-width:none;">
            <div class="tool-input-card-header">
                <span class="tool-input-card-icon">&#128269;</span>
                <h4>Decode PGP Packet Structure</h4>
            </div>
            <div class="tool-form-group">
                <label class="tool-label" for="p_dump">PGP Block <span class="tool-badge tool-badge-info">Required</span></label>
                <p class="tool-hint">Paste a public/private key, PGP message, or signature block. The server parses it per RFC 4880 and shows packet tags, algorithms, key sizes, and fingerprints.</p>
                <textarea class="tool-textarea auto-resize" id="p_dump" name="p_dump" placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----&#10;Version: ...&#10;&#10;mQENBF...&#10;-----END PGP PUBLIC KEY BLOCK-----"></textarea>
                <div class="tool-info-box">&#128161; Accepted blocks: <code>PGP PUBLIC KEY BLOCK</code>, <code>PGP PRIVATE KEY BLOCK</code>, <code>PGP MESSAGE</code>, <code>PGP SIGNATURE</code>.</div>
            </div>
            <div class="tool-form-actions">
                <button type="button" class="tool-action-btn" id="dumpBtn">
                    &#128270; Inspect Packets
                </button>
            </div>
        </div>
    </div>
</form>

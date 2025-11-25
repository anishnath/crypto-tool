<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PGP Suite: Sign, Verify & Generate Keys (Client‑Side)  – Free Tool | 8gwifi.org</title>
    <meta name="description" content="Create PGP cleartext signatures for messages and detached signatures for files — fully client‑side using OpenPGP.js v5. Paste your private key, enter passphrase, and sign securely in your browser.">
    <meta name="keywords" content="pgp sign, pgp signature, cleartext signature, detached signature, openpgp sign, gpg sign, pgp asc sig, sign file pgp, sign message pgp">

    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/pgp-suite.jsp">
    <meta property="og:title" content="PGP Suite: Sign, Verify & Generate Keys (Client‑Side) | 8gwifi.org">
    <meta property="og:description" content="Create PGP cleartext and detached signatures entirely in your browser using OpenPGP.js v5.">
    <meta property="og:image" content="https://8gwifi.org/images/site/pgp-file-decrypt.png">
    <meta property="og:site_name" content="8gwifi.org">
    <meta property="og:locale" content="en_US">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="PGP Suite: Sign, Verify & Generate Keys (Client‑Side)">
    <meta name="twitter:description" content="Cleartext message signing and detached file signatures using OpenPGP.js v5 — private keys never leave your device.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/pgp-file-decrypt.png">
    <meta name="twitter:site" content="@anish2good">
    <meta name="twitter:creator" content="@anish2good">

    <%@ include file="header-script.jsp"%>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://unpkg.com/openpgp@5.11.2/dist/openpgp.min.js"></script>
    <link rel="canonical" href="https://8gwifi.org/pgp-suite.jsp">
    <meta name="author" content="Anish Nath">
    <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1">

    <!-- EEAT: SoftwareApplication schema -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "PGP Suite: Sign, Verify, and Generate Keys",
      "applicationCategory": ["SecurityApplication", "CryptographyApplication"],
      "operatingSystem": "Web",
      "url": "https://8gwifi.org/pgp-suite.jsp",
      "image": "https://8gwifi.org/images/site/pgp-file-decrypt.png",
      "softwareVersion": "5.11.2 (OpenPGP.js)",
      "description": "Client-side PGP suite to clear-sign messages, detached-sign files, verify signatures, and generate key pairs using OpenPGP.js.",
      "author": {
        "@type": "Person",
        "name": "Anish Nath",
        "jobTitle": "Security Engineer",
        "url": "https://x.com/anish2good"
      },
      "publisher": { "@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org" },
      "dateModified": "2025-11-25"
    }
    </script>

    <!-- Breadcrumbs JSON-LD -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/" },
        { "@type": "ListItem", "position": 2, "name": "PGP Suite", "item": "https://8gwifi.org/pgp-suite.jsp" }
      ]
    }
    </script>

    <!-- EEAT: SoftwareSourceCode schema -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareSourceCode",
      "name": "8gwifi PGP Suite",
      "codeRepository": "https://github.com/anishnath/crypto-tool",
      "programmingLanguage": ["JavaScript", "Java", "JSP"],
      "runtimePlatform": "Web Browser",
      "license": "https://choosealicense.com/",
      "url": "https://8gwifi.org/pgp-suite.jsp",
      "creator": { "@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good" },
      "dateModified": "2025-11-25",
      "description": "Source powering the client-side OpenPGP suite (sign, verify, keygen)."
    }
    </script>

    <style>
        .form-card { background:#fff; border-radius:12px; padding:20px; margin-bottom:20px; border:1px solid #e0e0e0; box-shadow:0 2px 8px rgba(0,0,0,.05); }
        .form-card-header { display:flex; align-items:center; gap:10px; margin-bottom:12px; padding-bottom:12px; border-bottom:2px solid #f0f0f0; }
        .key-textarea { font-family:'Courier New', monospace; font-size:12px; border-radius:8px; border:2px solid #dee2e6; }
        .key-textarea:focus { border-color:#4299e1; box-shadow:0 0 0 3px rgba(66,153,225,.1); }
        .file-drop-area { position:relative; border:2px dashed #90caf9; border-radius:12px; padding:30px; text-align:center; background:#f8fbff; transition:.2s; cursor:pointer; }
        .file-drop-area.dragover { border-color:#1976d2; background:#f1f8ff; }
        .file-drop-area input[type=file]{ position:absolute; inset:0; opacity:0; cursor:pointer; }
        .result-area textarea { width:100%; border-radius:8px; font-family:'Courier New', monospace; font-size:12px; min-height:220px; }
        .btn:disabled { opacity:.6; cursor:not-allowed; }
        .small-muted { color:#6c757d; font-size:.9rem; }
        .format-options { display:flex; gap:12px; }
        .format-options .custom-control { margin-right:12px; }
        .sticky-side { position: sticky; top: 80px; }
        @media (max-width: 991.98px) { .sticky-side { position: static; } }
        .id-badge { font-size:.8rem; margin-left:auto; }
        .id-badge.badge { display:inline-flex; align-items:center; gap:6px; }
        .id-badge code { background:transparent; padding:0; }
    </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="pgp-menu-nav.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<h1 class="mt-4">PGP Suite: Sign, Verify & Generate Keys</h1>
<p class="lead text-muted">Create and verify signatures, and generate keys — all client‑side</p>
<hr>

<div class="alert alert-info">
    <i class="fas fa-shield-alt"></i> <strong>Private:</strong> All signing happens locally using OpenPGP.js v5. Your private key and passphrase never leave your device.
    <div class="small mt-1">Need verification? Use <a href="pgpfileverify.jsp">PGP File Signature Verification</a> or the main <a href="PGPFunctionality?invalidate=yes">Signature Verifier</a>.</div>
    </div>

<!-- Tabs -->
<ul class="nav nav-tabs" role="tablist">
  <li class="nav-item">
    <a class="nav-link active" data-toggle="tab" href="#tab-message" role="tab"><i class="fas fa-align-left"></i> Sign Message (Cleartext)</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-toggle="tab" href="#tab-file" role="tab"><i class="fas fa-file-signature"></i> Sign File (Detached)</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-toggle="tab" href="#tab-verify" role="tab"><i class="fas fa-check-double"></i> Verify Signatures</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-toggle="tab" href="#tab-generate" role="tab"><i class="fas fa-key"></i> Generate Keys</a>
  </li>
  </ul>

<div class="tab-content">
  <!-- Cleartext message signing -->
  <div class="tab-pane fade show active" id="tab-message" role="tabpanel">
    <div class="mt-4">
      <div class="row">
        <div class="col-lg-7">
          <div class="form-card">
          <div class="form-card-header">
            <i class="fas fa-align-left text-primary"></i>
            <h5 class="mb-0">Message</h5>
          </div>
          <textarea id="msgInput" class="form-control" rows="8" placeholder="Type or paste the message you want to clear‑sign..."></textarea>
          </div>

          <div class="form-card">
          <div class="form-card-header">
            <i class="fas fa-key text-warning"></i>
            <h5 class="mb-0">PGP Private Key</h5>
            <span id="badgePrivMsg" class="badge badge-light id-badge d-none"><i class="fas fa-fingerprint"></i> <span class="txt">—</span></span>
          </div>
          <textarea id="privKeyMsg" class="form-control key-textarea" rows="8" placeholder="-----BEGIN PGP PRIVATE KEY BLOCK-----

[Paste your private key here]

-----END PGP PRIVATE KEY BLOCK-----"></textarea>
          <small class="small-muted d-block mt-2"><i class="fas fa-info-circle"></i> Key is processed locally and never uploaded.</small>
          </div>

          <div class="form-card">
           <div class="form-card-header">
             <i class="fas fa-lock text-danger"></i>
             <h5 class="mb-0">Passphrase</h5>
           </div>
           <input id="passMsg" type="password" class="form-control" placeholder="Enter private key passphrase">
          </div>

          <div class="d-flex mb-3" style="gap:10px;">
            <button id="btnSignMsg" type="button" class="btn btn-primary btn-lg flex-grow-1" onclick="signCleartext()">
              <i class="fas fa-pen-fancy"></i> Sign Message
            </button>
            <button id="btnDemoSV" type="button" class="btn btn-outline-primary" data-toggle="tooltip" title="Sign the message then auto‑verify using the derived public key" onclick="demoSignVerify()">
              <i class="fas fa-magic"></i> Demo: Sign & Verify
            </button>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="sticky-side">
            <div id="resultMsg" class="result-area" style="display:none;">
              <div class="form-card">
                <div class="form-card-header">
                  <i class="fas fa-check-circle text-success"></i>
                  <h5 class="mb-0">Signed Message</h5>
                </div>
                <textarea id="signedMsg" readonly class="form-control"></textarea>
                <div class="mt-2 d-flex gap-2">
                  <button class="btn btn-outline-secondary mr-2" type="button" onclick="copyText('signedMsg')"><i class="fas fa-copy"></i> Copy</button>
                  <button class="btn btn-outline-success" type="button" onclick="downloadText('signed-message.asc', document.getElementById('signedMsg').value)"><i class="fas fa-download"></i> Download .asc</button>
                  <button class="btn btn-outline-primary ml-2" type="button" onclick="verifyFromSignedResult()" data-toggle="tooltip" title="Send this signed message to the Verify tab and run verification"><i class="fas fa-check"></i> Use to Verify</button>
                </div>
              </div>
            </div>
            <div class="form-card">
              <div class="form-card-header">
                <i class="fas fa-lightbulb text-warning"></i>
                <h5 class="mb-0">Tips</h5>
              </div>
              <ul class="mb-0">
                <li>Use a long, unique passphrase.</li>
                <li>Share only the signed output; keep your private key secret.</li>
                <li>Verify here: <a href="#tab-verify" onclick="try{$('a[href=\'#tab-verify\']').tab('show');}catch(_){}">Verify Signatures</a>.</li>
              </ul>
            </div>

            <!-- PGP Overview / EEAT content -->
            <div class="form-card mt-3">
              <div class="form-card-header">
                <i class="fas fa-book text-primary"></i>
                <h5 class="mb-0">PGP Overview</h5>
              </div>
              <div class="small">
                <p><strong>PGP</strong> (RFC 4880) provides confidentiality (encryption), authenticity (signatures), and integrity.</p>
                <ul>
                  <li><strong>Keys:</strong> Public (share) + Private (keep secret). Verify the <em>fingerprint</em> over a trusted channel.</li>
                  <li><strong>Signing:</strong> Proves author and protects from tampering; does not hide content.</li>
                  <li><strong>Encryption:</strong> Hides content; does not prove author unless also signed.</li>
                  <li><strong>Types:</strong> Cleartext signatures (inline), Detached signatures (.asc/.sig), Attached/opaque signatures.</li>
                  <li><strong>Formats:</strong> .asc (armored text), .pgp/.gpg (binary).</li>
                  <li><strong>Trust:</strong> Direct trust, Web of Trust, WKD/HKP discovery.</li>
                  <li><strong>Key Hygiene:</strong> Use strong passphrases, keep revocation cert offline, rotate/expire keys, prefer Ed25519 for signing.</li>
                </ul>
                <p class="mb-1"><strong>Common issues:</strong> invalid signature (wrong key/tampered), wrong passphrase, mixed line-endings.</p>
                <div class="text-muted">
                  References:
                  <a href="https://www.rfc-editor.org/rfc/rfc4880" target="_blank" rel="noopener">RFC 4880</a>,
                  <a href="https://openpgpjs.org/" target="_blank" rel="noopener">OpenPGP.js</a>,
                  <a href="https://www.gnupg.org/documentation/" target="_blank" rel="noopener">GnuPG</a>
                </div>
              </div>
            </div>
            <div class="form-card mt-3">
              <div class="form-card-header">
                <i class="fas fa-shield-alt text-info"></i>
                <h5 class="mb-0">About & Trust</h5>
              </div>
              <ul class="mb-2">
                <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> (Security Engineer)</li>
                <li><strong>Library:</strong> OpenPGP.js v5.11.2 (client-side only)</li>
                <li><strong>Data handling:</strong> Keys and files never leave your device</li>
                <li><strong>Updated:</strong> <span id="lastUpdated">2025-11-25</span></li>
              </ul>
              <div class="small text-muted">References: <a href="https://www.rfc-editor.org/rfc/rfc4880" target="_blank" rel="noopener">RFC 4880</a>, <a href="https://openpgpjs.org/" target="_blank" rel="noopener">OpenPGP.js Docs</a>, <a href="https://www.gnupg.org/documentation/" target="_blank" rel="noopener">GnuPG Docs</a></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Detached file signing -->
  <div class="tab-pane fade" id="tab-file" role="tabpanel">
    <div class="mt-4">
      <div class="row">
        <div class="col-lg-7">
          <div class="form-card">
          <div class="form-card-header">
            <i class="fas fa-file-upload text-primary"></i>
            <h5 class="mb-0">Select File</h5>
          </div>
          <div id="dropAreaSign" class="file-drop-area">
            <input type="file" id="fileInputSign">
            <div class="file-drop-icon"><i class="fas fa-cloud-upload-alt"></i></div>
            <h5>Drag & Drop file here</h5>
            <p class="text-muted">or click to browse</p>
          </div>
          <div id="fileInfoSign" class="mt-2"></div>
          </div>

          <div class="form-card">
          <div class="form-card-header">
            <i class="fas fa-key text-warning"></i>
            <h5 class="mb-0">PGP Private Key</h5>
            <span id="badgePrivFile" class="badge badge-light id-badge d-none"><i class="fas fa-fingerprint"></i> <span class="txt">—</span></span>
          </div>
          <textarea id="privKeyFile" class="form-control key-textarea" rows="8" placeholder="-----BEGIN PGP PRIVATE KEY BLOCK-----

[Paste your private key here]

-----END PGP PRIVATE KEY BLOCK-----"></textarea>
          </div>

          <div class="form-card">
           <div class="form-card-header">
             <i class="fas fa-lock text-danger"></i>
             <h5 class="mb-0">Passphrase</h5>
           </div>
           <input id="passFile" type="password" class="form-control" placeholder="Enter private key passphrase">
          </div>

          <div class="form-card">
          <div class="form-card-header">
            <i class="fas fa-list-ul text-secondary"></i>
            <h5 class="mb-0">Signature Format</h5>
          </div>
          <div class="format-options">
              <div class="custom-control custom-radio">
                <input type="radio" class="custom-control-input" id="fmtArmored" name="sigfmt" value="armored" checked>
                <label class="custom-control-label" for="fmtArmored">ASCII Armored (.asc)</label>
              </div>
              <div class="custom-control custom-radio">
                <input type="radio" class="custom-control-input" id="fmtBinary" name="sigfmt" value="binary">
                <label class="custom-control-label" for="fmtBinary">Binary (.sig)</label>
              </div>
          </div>
          </div>

          <div class="d-flex mb-3">
        <button id="btnSignFile" type="button" class="btn btn-success btn-lg flex-grow-1" onclick="signDetached()">
          <i class="fas fa-file-signature"></i> Create Detached Signature
        </button>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="sticky-side">
            <div id="resultFile" style="display:none;"></div>
            <div class="form-card">
              <div class="form-card-header">
                <i class="fas fa-shield-alt text-info"></i>
                <h5 class="mb-0">Good to Know</h5>
              </div>
              <ul class="mb-0">
                <li>Detached signature does not modify the original file.</li>
                <li>Share <em>both</em> the file and the signature with the recipient.</li>
                <li>Recipients can verify with <a href="pgpfileverify.jsp">File Signature Verify</a>.</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Verify signatures -->
  <div class="tab-pane fade" id="tab-verify" role="tabpanel">
    <div class="mt-4">
      <div class="row">
        <div class="col-lg-7">
          <!-- Verify cleartext message -->
          <div class="form-card">
            <div class="form-card-header">
              <i class="fas fa-align-left text-success"></i>
              <h5 class="mb-0">Verify Cleartext Signed Message</h5>
            </div>
            <textarea id="signedMsgInput" class="form-control" rows="8" placeholder="Paste clear‑signed message (-----BEGIN PGP SIGNED MESSAGE----- ...)"></textarea>
          </div>

          <div class="form-card">
            <div class="form-card-header">
              <i class="fas fa-key text-primary"></i>
              <h5 class="mb-0">Signer Public Key</h5>
              <span id="badgePubMsg" class="badge badge-light id-badge d-none"><i class="fas fa-fingerprint"></i> <span class="txt">—</span></span>
            </div>
            <textarea id="pubKeyMsg" class="form-control key-textarea" rows="8" placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----

[Paste the signer public key here]

-----END PGP PUBLIC KEY BLOCK-----"></textarea>
          </div>

          <div class="d-flex mb-4">
            <button id="btnVerifyMsg" type="button" class="btn btn-outline-primary btn-lg flex-grow-1" onclick="verifyCleartext()">
              <i class="fas fa-check"></i> Verify Message Signature
            </button>
          </div>

          <!-- Verify detached file signature -->
          <div class="form-card">
            <div class="form-card-header">
              <i class="fas fa-file text-success"></i>
              <h5 class="mb-0">Verify File with Detached Signature</h5>
            </div>
            <div class="row">
              <div class="col-md-6">
                <label class="small font-weight-bold">Original File</label>
                <div id="dropAreaVerifyFile" class="file-drop-area">
                  <input type="file" id="fileInputVerify">
                  <div class="file-drop-icon"><i class="fas fa-cloud-upload-alt"></i></div>
                  <h6>Drop file here</h6>
                  <p class="text-muted">or click to browse</p>
                </div>
                <div id="fileInfoVerify" class="mt-2"></div>
              </div>
              <div class="col-md-6">
                <label class="small font-weight-bold">Detached Signature (.asc or .sig)</label>
                <div id="dropAreaVerifySig" class="file-drop-area">
                  <input type="file" id="sigInputVerify" accept=".asc,.sig">
                  <div class="file-drop-icon"><i class="fas fa-cloud-upload-alt"></i></div>
                  <h6>Drop signature here</h6>
                  <p class="text-muted">or click to browse</p>
                </div>
                <div id="sigInfoVerify" class="mt-2"></div>
              </div>
            </div>
          </div>

          <div class="form-card">
            <div class="form-card-header">
              <i class="fas fa-key text-primary"></i>
              <h5 class="mb-0">Signer Public Key</h5>
              <span id="badgePubFile" class="badge badge-light id-badge d-none"><i class="fas fa-fingerprint"></i> <span class="txt">—</span></span>
            </div>
            <textarea id="pubKeyFile" class="form-control key-textarea" rows="6" placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----

[Paste the signer public key here]

-----END PGP PUBLIC KEY BLOCK-----"></textarea>
          </div>

          <div class="d-flex mb-3">
            <button id="btnVerifyFile" type="button" class="btn btn-outline-success btn-lg flex-grow-1" onclick="verifyDetached()">
              <i class="fas fa-check"></i> Verify Detached Signature
            </button>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="sticky-side">
            <div id="resultVerifyMsg" style="display:none;"></div>
            <div id="resultVerifyFile" style="display:none;"></div>
            <div class="form-card">
              <div class="form-card-header">
                <i class="fas fa-lightbulb text-warning"></i>
                <h5 class="mb-0">Verification Tips</h5>
              </div>
              <ul class="mb-0">
                <li>Always confirm the public key fingerprint via trusted channels.</li>
                <li>Cleartext verification extracts the original message if valid.</li>
                <li>Detached signatures require both original file and signature.</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Generate keys -->
  <div class="tab-pane fade" id="tab-generate" role="tabpanel">
    <div class="mt-4">
      <div class="row">
        <div class="col-lg-7">
          <div class="form-card">
            <div class="form-card-header">
              <i class="fas fa-user text-primary"></i>
              <h5 class="mb-0">Identity</h5>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label class="small font-weight-bold">Name</label>
                <input id="genName" type="text" class="form-control" placeholder="Full Name">
              </div>
              <div class="form-group col-md-6">
                <label class="small font-weight-bold">Email</label>
                <input id="genEmail" type="email" class="form-control" placeholder="name@example.com">
              </div>
            </div>
          </div>

          <div class="form-card">
            <div class="form-card-header">
              <i class="fas fa-cog text-secondary"></i>
              <h5 class="mb-0">Algorithm</h5>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label class="small font-weight-bold">Type</label>
                <select id="genType" class="form-control">
                  <option value="ecc">Ed25519 (recommended)</option>
                  <option value="rsa">RSA</option>
                </select>
              </div>
              <div class="form-group col-md-6" id="rsaBitsGroup" style="display:none;">
                <label class="small font-weight-bold">RSA Bits</label>
                <select id="genBits" class="form-control">
                  <option value="2048">2048</option>
                  <option value="3072">3072</option>
                  <option value="4096" selected>4096</option>
                </select>
              </div>
            </div>
            <small class="small-muted">Ed25519 offers smaller keys and faster operations; RSA maintains broad compatibility.</small>
          </div>

          <div class="form-card">
            <div class="form-card-header">
              <i class="fas fa-lock text-danger"></i>
              <h5 class="mb-0">Passphrase</h5>
            </div>
            <div class="input-group">
              <input id="genPass" type="password" class="form-control" placeholder="Protect your private key with a strong passphrase">
              <div class="input-group-append">
                <button type="button" class="btn btn-outline-secondary" onclick="fillPass('genPass')"><i class="fas fa-magic"></i> Generate</button>
                <button type="button" class="btn btn-outline-secondary" onclick="copyText('genPass')"><i class="fas fa-copy"></i> Copy</button>
              </div>
            </div>
            <div id="genPassFeedback" class="invalid-feedback">Passphrase is required.</div>
            <small class="small-muted d-block mt-2">Use a long, unique passphrase (20+ chars recommended).</small>
          </div>

          <div class="d-flex mb-3">
            <button id="btnGen" type="button" class="btn btn-primary btn-lg flex-grow-1" onclick="generateKeys()">
              <i class="fas fa-key"></i> Generate Key Pair
            </button>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="sticky-side">
            <div id="resultGen" style="display:none;"></div>
            <div class="form-card">
              <div class="form-card-header">
                <i class="fas fa-lightbulb text-warning"></i>
                <h5 class="mb-0">Key Safety</h5>
              </div>
              <ul class="mb-0">
                <li>Backup your private key and passphrase securely.</li>
                <li>Share only the public key; keep private key secret.</li>
                <li>Consider generating a revocation certificate.</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="addcomments.jsp"%>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

<script>
  // Helpers
  function downloadText(filename, text){
    const a=document.createElement('a');
    a.href=URL.createObjectURL(new Blob([text],{type:'text/plain'}));
    a.download=filename; a.click(); URL.revokeObjectURL(a.href);
  }
  async function copyText(id){
    const el=document.getElementById(id);
    if(!el) return;
    const text = (typeof el.value === 'string') ? el.value : (el.textContent || '');
    try{
      if(navigator.clipboard && navigator.clipboard.writeText){
        await navigator.clipboard.writeText(text);
        return;
      }
    }catch(_){ /* fall back */ }
    const ta=document.createElement('textarea');
    ta.value=text; ta.style.position='fixed'; ta.style.opacity='0';
    document.body.appendChild(ta); ta.focus(); ta.select();
    try{ document.execCommand('copy'); }catch(_){ }
    document.body.removeChild(ta);
  }
  function formatFileSize(bytes){ if(bytes===0)return '0 Bytes'; const k=1024, sizes=['Bytes','KB','MB','GB']; const i=Math.floor(Math.log(bytes)/Math.log(k)); return Math.round((bytes/Math.pow(k,i))*100)/100+' '+sizes[i]; }
  function randomPassphrase(len=24){
    const charset = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%^&*()-_=+[]{};:,.?';
    const buf = new Uint32Array(len);
    (window.crypto||window.msCrypto).getRandomValues(buf);
    let out='';
    for(let i=0;i<len;i++){ out += charset[ buf[i] % charset.length ]; }
    return out;
  }
  function fillPass(id){ const el=document.getElementById(id); if(!el) return; el.value = randomPassphrase(28); try{ el.dispatchEvent(new Event('input',{bubbles:true})); }catch(_){} }
  function setupDragAndDrop(dropId, inputId, infoId){
    const drop=document.getElementById(dropId), inp=document.getElementById(inputId), info=document.getElementById(infoId);
    if(!drop||!inp) return;
    ['dragenter','dragover','dragleave','drop'].forEach(n=>drop.addEventListener(n,e=>{e.preventDefault();e.stopPropagation();}));
    ['dragenter','dragover'].forEach(n=>drop.addEventListener(n,()=>drop.classList.add('dragover')));
    ['dragleave','drop'].forEach(n=>drop.addEventListener(n,()=>drop.classList.remove('dragover')));
    drop.addEventListener('drop',e=>{ const f=e.dataTransfer.files; if(f.length>0){ inp.files=f; inp.dispatchEvent(new Event('change',{bubbles:true})); }});
    inp.addEventListener('change',e=>{ const f=e.target.files[0]; if(!f) return; info.innerHTML='<div class="text-success"><i class="fas fa-file"></i> <strong>'+f.name+'</strong> • '+formatFileSize(f.size)+'</div>'; });
  }

  $(document).ready(function(){ setupDragAndDrop('dropAreaSign','fileInputSign','fileInfoSign'); });
  // Toggle RSA bits selector
  $(document).ready(function(){
    function toggleBits(){ const t=$('#genType').val(); $('#rsaBitsGroup').toggle(t==='rsa'); }
    $('#genType').on('change', toggleBits); toggleBits();
    $('[data-toggle="tooltip"]').tooltip();
    // Clear invalid on typing
    const gp=document.getElementById('genPass'); if(gp){ gp.addEventListener('input', function(){ if((this.value||'').trim()){ this.classList.remove('is-invalid'); } }); }
  });

  // Cleartext signing
  async function signCleartext(){
    const btn=document.getElementById('btnSignMsg');
    const text=document.getElementById('msgInput').value.trim();
    const privArm=document.getElementById('privKeyMsg').value.trim();
    const pass=document.getElementById('passMsg').value;
    if(!text){ alert('Please enter a message to sign.'); return; }
    if(!privArm.includes('BEGIN PGP PRIVATE KEY BLOCK')){ alert('Please paste a valid PGP private key.'); return; }
    btn.disabled=true; const old=btn.innerHTML; btn.innerHTML='<i class="fas fa-spinner fa-spin"></i> Signing...';
    try{
      const priv=await openpgp.readPrivateKey({armoredKey:privArm});
      const dPriv=await openpgp.decryptKey({privateKey:priv, passphrase:pass});
      const message=await openpgp.createCleartextMessage({ text });
      const signed=await openpgp.sign({ message, signingKeys:dPriv });
      document.getElementById('signedMsg').value=signed;
      document.getElementById('resultMsg').style.display='block';
    }catch(e){ console.error(e); alert('Signing failed: '+e.message); }
    finally{ btn.disabled=false; btn.innerHTML=old; }
  }

  // Detached file signing
  async function signDetached(){
    const btn=document.getElementById('btnSignFile');
    const inp=document.getElementById('fileInputSign');
    const privArm=document.getElementById('privKeyFile').value.trim();
    const pass=document.getElementById('passFile').value;
    const fmt=(document.querySelector('input[name="sigfmt"]:checked')||{}).value||'armored';
    if(!inp.files.length){ alert('Please choose a file to sign.'); return; }
    if(!privArm.includes('BEGIN PGP PRIVATE KEY BLOCK')){ alert('Please paste a valid PGP private key.'); return; }
    btn.disabled=true; const old=btn.innerHTML; btn.innerHTML='<i class="fas fa-spinner fa-spin"></i> Signing...';
    try{
      const file=inp.files[0];
      const arr=await file.arrayBuffer();
      const msg=await openpgp.createMessage({ binary:new Uint8Array(arr) });
      const priv=await openpgp.readPrivateKey({ armoredKey:privArm });
      const dPriv=await openpgp.decryptKey({ privateKey:priv, passphrase:pass });
      const sig=await openpgp.sign({ message:msg, signingKeys:dPriv, detached:true, format:fmt });

      let blob, name;
      if(fmt==='binary'){
        blob=new Blob([sig],{type:'application/octet-stream'});
        name=file.name+'.sig';
      } else {
        blob=new Blob([sig],{type:'text/plain'});
        name=file.name+'.asc';
      }
      const a=document.createElement('a'); a.href=URL.createObjectURL(blob); a.download=name; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(a.href);
      const res=document.getElementById('resultFile');
      res.style.display='block';
      res.innerHTML='<div class="alert alert-success"><i class="fas fa-check-circle"></i> Detached signature created and downloaded as <strong>'+name+'</strong>.</div>';
    }catch(e){ console.error(e); alert('Signing failed: '+e.message); }
    finally{ btn.disabled=false; btn.innerHTML=old; }
  }

  // From signed message result -> verify tab
  async function verifyFromSignedResult(){
    try{
      const signed = (document.getElementById('signedMsg').value||'').trim();
      if(!signed){ alert('No signed message found. Please sign a message first.'); return; }
      // Prefill signed message in verify tab
      document.getElementById('signedMsgInput').value = signed;
      // Try to provide a public key automatically
      let pubArm = '';
      // 1) If user provided private key in Sign tab, derive public
      const privArm = (document.getElementById('privKeyMsg').value||'').trim();
      if(privArm.includes('BEGIN PGP PRIVATE KEY BLOCK')){
        try{
          const priv = await openpgp.readPrivateKey({armoredKey:privArm});
          const pubObj = (priv.toPublic && typeof priv.toPublic==='function') ? priv.toPublic() : null;
          if(pubObj && pubObj.armor){ pubArm = pubObj.armor(); }
        }catch(_){ /* ignore */ }
      }
      // 2) Else fallback to session public key
      if(!pubArm){ try{ pubArm = sessionStorage.getItem('pgp_pub')||''; }catch(_){ } }
      if(pubArm){ document.getElementById('pubKeyMsg').value = pubArm; }
      // Switch to verify tab and run verification
      $("a[href='#tab-verify']").tab('show');
      await verifyCleartext();
    }catch(e){ console.error(e); alert('Unable to verify: '+e.message); }
  }

  // Demo: Sign & Verify end-to-end for cleartext message
  async function demoSignVerify(){
    const text=(document.getElementById('msgInput').value||'').trim();
    const privArm=(document.getElementById('privKeyMsg').value||'').trim();
    const pass=(document.getElementById('passMsg').value||'');
    if(!text){ alert('Please enter a message to sign.'); return; }
    if(!privArm.includes('BEGIN PGP PRIVATE KEY BLOCK')){ alert('Please paste a valid PGP private key.'); return; }
    const btn=document.getElementById('btnDemoSV'); const old=btn.innerHTML; btn.disabled=true; btn.innerHTML='<i class="fas fa-spinner fa-spin"></i> Running...';
    try{
      const priv=await openpgp.readPrivateKey({armoredKey:privArm});
      const dPriv=await openpgp.decryptKey({privateKey:priv, passphrase:pass});
      const message=await openpgp.createCleartextMessage({ text });
      const signed=await openpgp.sign({ message, signingKeys:dPriv });
      // Show in result pane
      document.getElementById('signedMsg').value=signed; document.getElementById('resultMsg').style.display='block';
      // Try derive public key armored for convenience
      let pubObj=null, pubArm='';
      try{ pubObj = (priv.toPublic && typeof priv.toPublic==='function') ? priv.toPublic() : null; }catch(_){ pubObj=null; }
      try{ pubArm = (pubObj && pubObj.armor) ? pubObj.armor() : ''; }catch(_){ pubArm=''; }
      // Fill verify tab inputs
      $("a[href='#tab-verify']").tab('show');
      document.getElementById('signedMsgInput').value = signed;
      if(pubArm){ document.getElementById('pubKeyMsg').value = pubArm; try{ document.getElementById('pubKeyMsg').dispatchEvent(new Event('input',{bubbles:true})); }catch(_){} }
      // Perform verification directly if pubObj available
      if(pubObj){
        const verification=await openpgp.verify({ message: await openpgp.readCleartextMessage({ cleartextMessage: signed }), verificationKeys: pubObj });
        const ok = await verification.signatures?.[0]?.verified;
        const keyhex = verification.signatures?.[0]?.keyID?.toHex?.() || '';
        const el=document.getElementById('resultVerifyMsg'); el.style.display='block';
        if(ok){
          el.innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Signature VALID'+(keyhex?(' • signer keyID '+keyhex):'')+'.</div>'+
                         '<div class="form-card"><div class="form-card-header"><i class="fas fa-file-alt text-info"></i><h5 class="mb-0">Extracted Message</h5></div>'+
                         '<textarea class="form-control" readonly>'+ text +'</textarea></div>';
        } else {
          el.innerHTML = '<div class="alert alert-danger"><i class="fas fa-times-circle"></i> Signature INVALID.</div>';
        }
      } else {
        // fallback: use the UI verify function if user has pub key
        await verifyCleartext();
      }
    }catch(e){ console.error(e); alert('Demo failed: '+e.message); }
    finally{ btn.disabled=false; btn.innerHTML=old; }
  }

  // Verification - cleartext message
  async function verifyCleartext(){
    const btn=document.getElementById('btnVerifyMsg');
    const signed=document.getElementById('signedMsgInput').value.trim();
    const pubArm=document.getElementById('pubKeyMsg').value.trim();
    if(!signed){ alert('Please paste a clear‑signed message.'); return; }
    if(!pubArm.includes('BEGIN PGP PUBLIC KEY BLOCK')){ alert('Please paste a valid PGP public key.'); return; }
    btn.disabled=true; const old=btn.innerHTML; btn.innerHTML='<i class="fas fa-spinner fa-spin"></i> Verifying...';
    try{
      const publicKey=await openpgp.readKey({ armoredKey: pubArm });
      const message=await openpgp.readCleartextMessage({ cleartextMessage: signed });
      const verification=await openpgp.verify({ message, verificationKeys: publicKey });
      const { data, signatures } = verification;

      // signer meta from provided public key
      let fp = '', uid = '';
      try {
        fp = publicKey.getFingerprint?.() || '';
        if(publicKey.getUserIDs){ const uids = publicKey.getUserIDs(); uid = (uids && uids[0]) || ''; }
        if(!uid && publicKey.users && publicKey.users[0] && publicKey.users[0].userID){ uid = publicKey.users[0].userID.userID || ''; }
        if(!uid && publicKey.getPrimaryUser){ const pu = await publicKey.getPrimaryUser(); uid = pu?.user?.userID?.userID || uid; }
      } catch(_) {}

      // build signature list
      const items = [];
      if (Array.isArray(signatures)) {
        for (const s of signatures) {
          let ok=false, keyhex='', created='';
          try{ ok = await s.verified; }catch(_){ ok=false; }
          try{ keyhex = s.keyID?.toHex?.() || ''; }catch(_){ }
          try{
            const d = s.signature?.created || s.signature?.creationTime || s.created;
            if(d){ const dd = (d instanceof Date) ? d : new Date(d); created = dd.toISOString(); }
          }catch(_){ }
          items.push({ ok, keyhex, created });
        }
      }

      const el=document.getElementById('resultVerifyMsg');
      el.style.display='block';
      if(items.length){
        const anyValid = items.some(i=>i.ok);
        let list = '<ul class="mb-2">';
        items.forEach(i=>{
          list += '<li>'+
                  (i.ok?'<span class="text-success"><i class="fas fa-check-circle"></i> VALID</span>':'<span class="text-danger"><i class="fas fa-times-circle"></i> INVALID</span>')+
                  (i.keyhex?(' • keyID <code>'+i.keyhex+'</code>'):'')+
                  (fp?(' • fingerprint <code>'+fp+'</code>'):'')+
                  (uid?(' • UID '+uid):'')+
                  (i.created?(' • signed at '+i.created):'')+
                  '</li>';
        });
        list += '</ul>';

        el.innerHTML = '<div class="alert alert-'+(anyValid?'success':'danger')+'">'+
                        '<i class="fas fa-'+(anyValid?'check-circle':'times-circle')+'"></i> Signature check completed</div>' +
                       list +
                       '<div class="form-card"><div class="form-card-header"><i class="fas fa-file-alt text-info"></i><h5 class="mb-0">Extracted Message</h5></div>'+
                       '<textarea class="form-control" id="extractedMsg" readonly>'+ (data||'') +'</textarea>'+
                       '<div class="mt-2 d-flex" style="gap:8px;">'+
                       '  <button class="btn btn-outline-secondary" type="button" onclick="copyText(\'extractedMsg\')"><i class="fas fa-copy"></i> Copy</button>'+
                       '  <button id="btnUseToSign" class="btn btn-outline-primary" type="button" data-toggle="tooltip" title="Send this extracted message to the Sign tab"><i class="fas fa-pen"></i> Use to Sign</button>'+
                       '</div>'+
                       '</div>';
        // bind Use to Sign button
        try{
          const btnUTS = document.getElementById('btnUseToSign');
          if(btnUTS){
            btnUTS.addEventListener('click', function(){
              const m = (document.getElementById('extractedMsg').value||'');
              const t = document.getElementById('msgInput'); if(t){ t.value = m; try{ t.dispatchEvent(new Event('input',{bubbles:true})); }catch(_){} }
              $("a[href='#tab-message']").tab('show');
              window.scrollTo({top:0, behavior:'smooth'});
            });
          }
        }catch(_){ }
      } else {
        el.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle"></i> No signatures found.</div>';
      }
    }catch(e){ console.error(e); alert('Verification failed: '+e.message); }
    finally{ btn.disabled=false; btn.innerHTML=old; }
  }

  // Verification - detached signature
  async function verifyDetached(){
    const btn=document.getElementById('btnVerifyFile');
    const fileInp=document.getElementById('fileInputVerify');
    const sigInp=document.getElementById('sigInputVerify');
    const pubArm=document.getElementById('pubKeyFile').value.trim();
    if(!fileInp.files.length){ alert('Please choose the original file.'); return; }
    if(!sigInp.files.length){ alert('Please choose the detached signature (.asc or .sig).'); return; }
    if(!pubArm.includes('BEGIN PGP PUBLIC KEY BLOCK')){ alert('Please paste a valid PGP public key.'); return; }
    btn.disabled=true; const old=btn.innerHTML; btn.innerHTML='<i class="fas fa-spinner fa-spin"></i> Verifying...';
    try{
      const file=fileInp.files[0]; const sigFile=sigInp.files[0];
      const fileBuf=new Uint8Array(await file.arrayBuffer());
      const message=await openpgp.createMessage({ binary:fileBuf });
      const publicKey=await openpgp.readKey({ armoredKey: pubArm });

      // Read signature as armored first, then binary fallback
      let signature;
      try {
        const text = await sigFile.text();
        signature = await openpgp.readSignature({ armoredSignature: text });
      } catch (e) {
        const bin = new Uint8Array(await sigFile.arrayBuffer());
        signature = await openpgp.readSignature({ binarySignature: bin });
      }

      const verification=await openpgp.verify({ message, signature, verificationKeys: publicKey });
      // signer meta
      let fp = '', uid = '';
      try {
        fp = publicKey.getFingerprint?.() || '';
        if(publicKey.getUserIDs){ const uids = publicKey.getUserIDs(); uid = (uids && uids[0]) || ''; }
        if(!uid && publicKey.users && publicKey.users[0] && publicKey.users[0].userID){ uid = publicKey.users[0].userID.userID || ''; }
        if(!uid && publicKey.getPrimaryUser){ const pu = await publicKey.getPrimaryUser(); uid = pu?.user?.userID?.userID || uid; }
      } catch(_) {}

      const sigs = Array.isArray(verification.signatures) ? verification.signatures : [];
      const details = [];
      for (const s of sigs) {
        let ok=false, keyhex='', created='';
        try{ ok = await s.verified; }catch(_){ ok=false; }
        try{ keyhex = s.keyID?.toHex?.() || ''; }catch(_){ }
        try{
          const d = s.signature?.created || s.signature?.creationTime || s.created;
          if(d){ const dd=(d instanceof Date)? d : new Date(d); created = dd.toISOString(); }
        }catch(_){ }
        details.push({ ok, keyhex, created });
      }

      const el=document.getElementById('resultVerifyFile');
      el.style.display='block';
      if(details.length){
        let list = '<ul class="mb-0">';
        details.forEach(i=>{
          list += '<li>'+
                  (i.ok?'<span class="text-success"><i class="fas fa-check-circle"></i> VALID</span>':'<span class="text-danger"><i class="fas fa-times-circle"></i> INVALID</span>')+
                  (i.keyhex?(' • keyID <code>'+i.keyhex+'</code>'):'')+
                  (fp?(' • fingerprint <code>'+fp+'</code>'):'')+
                  (uid?(' • UID '+uid):'')+
                  (i.created?(' • signed at '+i.created):'')+
                  '</li>';
        });
        list += '</ul>';
        const anyValid = details.some(i=>i.ok);
        el.innerHTML = '<div class="alert alert-'+(anyValid?'success':'danger')+'"><i class="fas fa-'+(anyValid?'check-circle':'times-circle')+'"></i> Signature check for <strong>'+file.name+'</strong></div>' + list;
      } else {
        el.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle"></i> No signature information available.</div>';
      }
    }catch(e){ console.error(e); alert('Verification failed: '+e.message); }
    finally{ btn.disabled=false; btn.innerHTML=old; }
  }

  // Init extra drag&drop for verify tab
  $(document).ready(function(){
    setupDragAndDrop('dropAreaVerifyFile','fileInputVerify','fileInfoVerify');
    setupDragAndDrop('dropAreaVerifySig','sigInputVerify','sigInfoVerify');
  });

  // Generate keys (client-side)
  async function generateKeys(){
    const btn=document.getElementById('btnGen');
    const name=(document.getElementById('genName').value||'').trim();
    const email=(document.getElementById('genEmail').value||'').trim();
    const type=(document.getElementById('genType').value||'ecc');
    const bits=parseInt(document.getElementById('genBits')?.value||'4096',10);
    const pass=document.getElementById('genPass').value||'';

    if(!name && !email){ alert('Provide at least a name or email for the key identity.'); return; }
    if(!pass || !pass.trim()){
      const gp=document.getElementById('genPass');
      if(gp){ gp.classList.add('is-invalid'); gp.focus(); }
      return;
    }

    btn.disabled=true; const old=btn.innerHTML; btn.innerHTML='<i class="fas fa-spinner fa-spin"></i> Generating...';
    try{
      const userIDs=[{ name: name||undefined, email: email||undefined }];
      let genOpts;
      if(type==='rsa'){
        genOpts={ type:'rsa', rsaBits:bits, userIDs, passphrase:pass };
      } else {
        genOpts={ type:'ecc', curve:'ed25519', userIDs, passphrase:pass };
      }
      const { privateKey, publicKey, revocationCertificate } = await openpgp.generateKey(genOpts);

      // Fingerprint and key id
      let fingerprint='', keyid='';
      try{
        const pubObj=await openpgp.readKey({ armoredKey: publicKey });
        fingerprint = pubObj.getFingerprint?.() || '';
        keyid = pubObj.getKeyID?.().toHex?.() || '';
      }catch(_){ }

      const res=document.getElementById('resultGen');
      res.style.display='block';
      res.innerHTML = ''+
        '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Key pair generated successfully.'+(fingerprint?(' <span class="d-block mt-1"><strong>Fingerprint:</strong> <code>'+fingerprint+'</code></span>'):'')+(keyid?(' <span class="d-block"><strong>KeyID:</strong> <code>'+keyid+'</code></span>'):'')+'</div>'+
        '<div class="form-card mb-3">'+
        '  <div class="form-card-header"><i class="fas fa-lock text-danger"></i><h5 class="mb-0">Private Key</h5></div>'+
        '  <textarea class="form-control" id="genPriv" readonly rows="10">'+privateKey+'</textarea>'+
        '  <div class="mt-2 d-flex">'+
        '    <button class="btn btn-outline-secondary mr-2" type="button" onclick="copyText(\'genPriv\')"><i class="fas fa-copy"></i> Copy</button>'+
        '    <button class="btn btn-outline-danger" type="button" onclick="downloadText(\'private-key.asc\', document.getElementById(\'genPriv\').value)"><i class="fas fa-download"></i> Download</button>'+
        '  </div>'+
        '</div>'+
        '<div class="form-card mb-3">'+
        '  <div class="form-card-header"><i class="fas fa-key text-success"></i><h5 class="mb-0">Public Key</h5></div>'+
        '  <textarea class="form-control" id="genPub" readonly rows="8">'+publicKey+'</textarea>'+
        '  <div class="mt-2 d-flex">'+
        '    <button class="btn btn-outline-secondary mr-2" type="button" onclick="copyText(\'genPub\')"><i class="fas fa-copy"></i> Copy</button>'+
        '    <button class="btn btn-outline-success" type="button" onclick="downloadText(\'public-key.asc\', document.getElementById(\'genPub\').value)"><i class="fas fa-download"></i> Download</button>'+
        '  </div>'+
        '</div>'+
        (revocationCertificate ? (
        '<div class="form-card">'+
        '  <div class="form-card-header"><i class="fas fa-ban text-warning"></i><h5 class="mb-0">Revocation Certificate</h5></div>'+
        '  <textarea class="form-control" id="genRevoke" readonly rows="6">'+revocationCertificate+'</textarea>'+
        '  <div class="mt-2 d-flex">'+
        '    <button class="btn btn-outline-secondary mr-2" type="button" onclick="copyText(\'genRevoke\')"><i class="fas fa-copy"></i> Copy</button>'+
        '    <button class="btn btn-outline-warning" type="button" onclick="downloadText(\'revocation-certificate.asc\', document.getElementById(\'genRevoke\').value)"><i class="fas fa-download"></i> Download</button>'+
        '  </div>'+
        '</div>'
        ) : '')+
        '<div class="form-card mt-3">'+
        '  <div class="form-card-header"><i class="fas fa-bolt text-primary"></i><h5 class="mb-0">Quick Actions</h5></div>'+
        '  <div class="d-flex flex-wrap" style="gap:8px;">'+
        '    <button id="actUsePrivMsg" class="btn btn-primary"><i class="fas fa-pen"></i> Use Private for Sign Message</button>'+
        '    <button id="actUsePrivFile" class="btn btn-primary"><i class="fas fa-file-signature"></i> Use Private for Sign File</button>'+
        '    <button id="actUsePubVerifyMsg" class="btn btn-success"><i class="fas fa-check"></i> Use Public for Verify Message</button>'+
        '    <button id="actUsePubVerifyFile" class="btn btn-success"><i class="fas fa-check-double"></i> Use Public for Verify File</button>'+
        '    <button id="actSharePubLink" class="btn btn-outline-info"><i class="fas fa-link"></i> Copy Shareable Public Key URL</button>'+
        '    <button id="actSaveSession" class="btn btn-outline-secondary"><i class="fas fa-save"></i> Keep Keys This Session</button>'+
        '    <button id="actClearSession" class="btn btn-outline-secondary"><i class="fas fa-trash"></i> Clear Session Keys</button>'+
        '  </div>'+
        '  <small class="small-muted d-block mt-2">Private key never leaves your browser. Shareable URL includes only your public key (encoded in the URL fragment).</small>'+
        '</div>';

      // Bind quick actions with generated key material
      const switchTab = (id)=>{ try{ $("a[href='#"+id+"']").tab('show'); }catch(_){ } };
      const setVal = (id, val)=>{ const el=document.getElementById(id); if(el){ el.value=val; try{ el.dispatchEvent(new Event('input',{bubbles:true})); }catch(_){} } };
      const b64url = {
        enc: (s)=>{ return btoa(unescape(encodeURIComponent(s))).replace(/\+/g,'-').replace(/\//g,'_').replace(/=+$/,''); },
        dec: (s)=>{ s=s.replace(/-/g,'+').replace(/_/g,'/'); while(s.length%4) s+='='; return decodeURIComponent(escape(atob(s))); }
      };

      document.getElementById('actUsePrivMsg')?.addEventListener('click',()=>{ setVal('privKeyMsg', privateKey); setVal('passMsg', pass); switchTab('tab-message'); window.scrollTo({top:0,behavior:'smooth'}); });
      document.getElementById('actUsePrivFile')?.addEventListener('click',()=>{ setVal('privKeyFile', privateKey); setVal('passFile', pass); switchTab('tab-file'); window.scrollTo({top:0,behavior:'smooth'}); });
      document.getElementById('actUsePubVerifyMsg')?.addEventListener('click',()=>{ setVal('pubKeyMsg', publicKey); switchTab('tab-verify'); });
      document.getElementById('actUsePubVerifyFile')?.addEventListener('click',()=>{ setVal('pubKeyFile', publicKey); switchTab('tab-verify'); });
      document.getElementById('actSharePubLink')?.addEventListener('click',()=>{
        const link = location.origin + location.pathname + '#pubkey=' + b64url.enc(publicKey);
        const ta=document.createElement('textarea'); ta.value=link; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta);
        alert('Shareable public key URL copied to clipboard');
      });
      document.getElementById('actSaveSession')?.addEventListener('click',()=>{
        try{
          sessionStorage.setItem('pgp_pub', publicKey);
          if(confirm('Also keep PRIVATE key in this session (not persistent)?')){
            sessionStorage.setItem('pgp_priv', privateKey);
            alert('Public and private keys saved for this session. They will be cleared when you close the tab.');
          } else {
            alert('Public key saved for this session.');
          }
        }catch(e){ alert('Unable to save to session: '+e.message); }
      });
      document.getElementById('actClearSession')?.addEventListener('click',()=>{
        sessionStorage.removeItem('pgp_pub'); sessionStorage.removeItem('pgp_priv'); alert('Session keys cleared.');
      });
    }catch(e){ console.error(e); alert('Key generation failed: '+e.message); }
    finally{ btn.disabled=false; btn.innerHTML=old; }
  }

  // Load public key from URL fragment or session
  (function initKeyPrefill(){
    try{
      const hash = location.hash || '';
      const params = new URLSearchParams(hash.startsWith('#') ? hash.substring(1) : hash);
      const pk = params.get('pubkey');
      if(pk){
        const dec = (s)=>{ s=s.replace(/-/g,'+').replace(/_/g,'/'); while(s.length%4) s+='='; return decodeURIComponent(escape(atob(s))); };
        const pub = dec(pk);
        const banner = document.createElement('div');
        banner.className='alert alert-info';
        banner.innerHTML = '<i class="fas fa-key"></i> Public key loaded from link. <button type="button" class="btn btn-sm btn-outline-primary ml-2" id="btnApplyPubAll">Apply to Verify</button>';
        const container = document.querySelector('.container-fluid .col-lg-9') || document.querySelector('.container-fluid');
        if(container){ container.insertBefore(banner, container.firstChild || null); }
        document.getElementById('btnApplyPubAll')?.addEventListener('click',()=>{
          const setVal = (id,val)=>{ const el=document.getElementById(id); if(el){ el.value=val; try{ el.dispatchEvent(new Event('input',{bubbles:true})); }catch(_){} } };
          setVal('pubKeyMsg', pub); setVal('pubKeyFile', pub); $("a[href='#tab-verify']").tab('show');
        });
      }
      // Session hint
      if(sessionStorage.getItem('pgp_pub') || sessionStorage.getItem('pgp_priv')){
        const banner2 = document.createElement('div');
        banner2.className='alert alert-secondary mt-2';
        banner2.innerHTML = '<i class="fas fa-save"></i> Session keys available. <button type="button" class="btn btn-sm btn-outline-secondary ml-2" id="btnLoadSessionPub">Use Public</button>'+
                            (sessionStorage.getItem('pgp_priv') ? ' <button type="button" class="btn btn-sm btn-outline-danger ml-1" id="btnLoadSessionPriv">Use Private</button>' : '');
        const container = document.querySelector('.container-fluid .col-lg-9') || document.querySelector('.container-fluid');
        if(container){ container.insertBefore(banner2, container.firstChild || null); }
        document.getElementById('btnLoadSessionPub')?.addEventListener('click',()=>{
          const pub = sessionStorage.getItem('pgp_pub')||''; if(!pub) return; const setVal=(id,val)=>{ const el=document.getElementById(id); if(el){ el.value=val; el.dispatchEvent(new Event('input',{bubbles:true})); } };
          setVal('pubKeyMsg', pub); setVal('pubKeyFile', pub); $("a[href='#tab-verify']").tab('show');
        });
        document.getElementById('btnLoadSessionPriv')?.addEventListener('click',()=>{
          const priv = sessionStorage.getItem('pgp_priv')||''; if(!priv) return; const setVal=(id,val)=>{ const el=document.getElementById(id); if(el){ el.value=val; el.dispatchEvent(new Event('input',{bubbles:true})); } };
          setVal('privKeyMsg', priv); setVal('privKeyFile', priv); $("a[href='#tab-message']").tab('show');
        });
      }
    }catch(_){ }
  })();

  // Identity badge helpers
  function setBadge(id, text){
    const el=document.getElementById(id); if(!el) return;
    if(text && text.length){ el.classList.remove('d-none'); el.querySelector('.txt').textContent=text; }
    else { el.classList.add('d-none'); }
  }
  async function fpFromPubArm(arm){ try{ const k=await openpgp.readKey({armoredKey:arm}); return k.getFingerprint?.()||''; }catch(_){ return ''; } }
  async function fpFromPrivArm(arm){ try{ const k=await openpgp.readPrivateKey({armoredKey:arm}); if(k.getFingerprint){ return k.getFingerprint(); } if(k.toPublic){ const p=k.toPublic(); return p.getFingerprint?.()||''; } return ''; }catch(_){ return ''; } }
  let updTimer=null;
  function scheduleUpdateBadges(){ clearTimeout(updTimer); updTimer=setTimeout(updateBadges, 250); }
  async function updateBadges(){
    const privMsg=(document.getElementById('privKeyMsg').value||'').trim();
    const privFile=(document.getElementById('privKeyFile').value||'').trim();
    const pubMsg=(document.getElementById('pubKeyMsg').value||'').trim();
    const pubFile=(document.getElementById('pubKeyFile').value||'').trim();
    setBadge('badgePrivMsg', privMsg? (await fpFromPrivArm(privMsg)) : '');
    setBadge('badgePrivFile', privFile? (await fpFromPrivArm(privFile)) : '');
    setBadge('badgePubMsg', pubMsg? (await fpFromPubArm(pubMsg)) : '');
    setBadge('badgePubFile', pubFile? (await fpFromPubArm(pubFile)) : '');
  }
  // Bind updates
  ['privKeyMsg','privKeyFile','pubKeyMsg','pubKeyFile'].forEach(id=>{
    const el=document.getElementById(id); if(el){ el.addEventListener('input', scheduleUpdateBadges); }
  });
  // Initial attempt
  setTimeout(updateBadges, 300);
</script>

<!-- FAQ Section -->
<div class="mt-5">
  <div class="form-card">
    <div class="form-card-header">
      <i class="fas fa-question-circle text-primary"></i>
      <h5 class="mb-0">PGP FAQ</h5>
    </div>
    <div class="small">
      <p><strong>Q: What is the difference between cleartext and detached signatures?</strong><br>
         A: Cleartext signatures keep the message human‑readable with an inline signature block; detached signatures are separate .asc/.sig files used to verify any file without changing it.</p>
      <p><strong>Q: How do I verify a signed message?</strong><br>
         A: Paste the signed text and the signer’s public key in the Verify tab and click Verify. You’ll see validity, signer KeyID, fingerprint, UID and the signature time.</p>
      <p><strong>Q: How do I verify a file with a detached signature?</strong><br>
         A: Select the original file and the .asc/.sig signature, paste the signer’s public key, then verify. The suite lists each signature and status.</p>
      <p><strong>Q: Can I recover my private‑key passphrase if I forget it?</strong><br>
         A: No. Passphrases are not recoverable. Generate a new key pair and distribute the new public key; revoke the old key if possible.</p>
      <p><strong>Q: Is this secure? Do keys leave my device?</strong><br>
         A: All operations happen client‑side in your browser using OpenPGP.js. Keys and files never leave your device.</p>
      <p><strong>Q: How do I confirm I have the right public key?</strong><br>
         A: Compare the fingerprint over a trusted channel (in‑person, voice, QR, business card) before trusting signatures or encrypting to the key.</p>
      <p class="mb-0"><strong>Q: Can I sign with multiple keys or add notations?</strong><br>
         A: Advanced options like multi‑sign and notations are planned. For now, you can sign with one key and verify multi‑signature messages.</p>
    </div>
  </div>
</div>

<!-- FAQ JSON-LD -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is the difference between cleartext and detached signatures?",
      "acceptedAnswer": {"@type": "Answer", "text": "Cleartext signatures keep the message readable with an inline signature block; detached signatures are separate .asc/.sig files used to verify any file without modifying it."}
    },
    {
      "@type": "Question",
      "name": "How do I verify a signed message?",
      "acceptedAnswer": {"@type": "Answer", "text": "Paste the signed text and the signer’s public key in the Verify tab and click Verify to see validity, signer KeyID, fingerprint, UID and signature time."}
    },
    {
      "@type": "Question",
      "name": "How do I verify a file with a detached signature?",
      "acceptedAnswer": {"@type": "Answer", "text": "Select the original file and the .asc/.sig signature, paste the signer’s public key, then verify. The suite lists each signature and its status."}
    },
    {
      "@type": "Question",
      "name": "Can I recover my private‑key passphrase if I forget it?",
      "acceptedAnswer": {"@type": "Answer", "text": "No. Passphrases are not recoverable. Generate a new key pair and distribute the new public key; revoke the old key if possible."}
    },
    {
      "@type": "Question",
      "name": "Is this secure? Do keys leave my device?",
      "acceptedAnswer": {"@type": "Answer", "text": "All operations happen client‑side in your browser using OpenPGP.js. Keys and files never leave your device."}
    },
    {
      "@type": "Question",
      "name": "How do I confirm I have the right public key?",
      "acceptedAnswer": {"@type": "Answer", "text": "Compare the fingerprint over a trusted channel (in‑person, voice, QR, business card) before trusting signatures or encrypting to the key."}
    },
    {
      "@type": "Question",
      "name": "Can I sign with multiple keys or add notations?",
      "acceptedAnswer": {"@type": "Answer", "text": "Advanced options like multi‑sign and signature notations are planned. Currently you can sign with one key and verify multi‑signature messages."}
    }
  ]
}
</script>

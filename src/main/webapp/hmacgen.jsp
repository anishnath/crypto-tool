<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>HMAC Generator Online – Free | 8gwifi.org</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Free online HMAC generator. Compute keyed hashes (HMAC) with SHA‑256, SHA‑512, RIPEMD, TIGER and more. Keys never leave your browser. Great for API signing and message authentication.">
    <meta name="keywords" content="online hmac generator, hmac online, HMAC SHA-256, HMAC SHA-512, HMAC RIPEMD160, HMAC TIGER, message authentication, keyed hash, API signing, MAC generator">

    <!-- Open Graph -->
    <meta property="og:title" content="HMAC Generator Online – Free | 8gwifi.org">
    <meta property="og:description" content="Generate HMACs (keyed hashes) with SHA‑2, SHA‑3, RIPEMD, TIGER and more. All computation happens in your browser – keys are never uploaded.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/hmacgen.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/hmac.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="HMAC Generator Online – Free | 8gwifi.org">
    <meta name="twitter:description" content="Generate secure HMACs for API signing and integrity protection. SHA‑256, SHA‑512, RIPEMD, TIGER and more. Keys never leave your browser.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/hmac.png">

    <!-- Canonical URL -->
    <link rel="canonical" href="https://8gwifi.org/hmacgen.jsp">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD EEAT / WebApplication + FAQ + Breadcrumbs -->
    <script type="application/ld+json">
{
      "@context": "https://schema.org",
      "@graph": [
        {
          "@type": "WebApplication",
          "@id": "https://8gwifi.org/hmacgen.jsp#app",
          "name": "Online HMAC Generator",
          "alternateName": "HMAC Calculator, Message Authentication Code Generator, API Signing Helper",
          "applicationCategory": "SecurityApplication",
          "operatingSystem": "Any",
          "url": "https://8gwifi.org/hmacgen.jsp",
          "image": "https://8gwifi.org/images/site/hmac.png",
          "description": "Free online HMAC generator to compute keyed hashes using SHA-256, SHA-512, RIPEMD, TIGER and more. Ideal for API request signing and integrity checks. Keys are processed only in the browser and never logged on the server.",
          "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://8gwifi.org"
          },
          "creator": {
            "@type": "Person",
            "name": "Anish Nath"
          },
          "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
          },
          "datePublished": "2017-09-25",
          "softwareVersion": "v2.0",
          "keywords": [
            "online hmac generate",
            "generate hmac online",
            "HMAC SHA-256",
            "message authentication code",
            "API signing helper"
          ]
        },
        {
          "@type": "FAQPage",
          "@id": "https://8gwifi.org/hmacgen.jsp#faq",
          "mainEntity": [
            {
              "@type": "Question",
              "name": "What is an HMAC?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "HMAC (Hash-based Message Authentication Code) combines a cryptographic hash function with a secret key to provide both integrity and authentication for a message. If the HMAC verifies, you know the message has not been modified and that it was created by someone who knows the shared secret key."
              }
            },
            {
              "@type": "Question",
              "name": "Which HMAC algorithms should I use?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "For modern systems, HMAC-SHA-256 or HMAC-SHA-512 are generally recommended. Legacy hashes such as MD5, MD4, MD2 or SHA-1 are kept mainly for interoperability and testing and should be avoided in new designs."
              }
            },
            {
              "@type": "Question",
              "name": "Are my keys or messages uploaded to the server?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "This HMAC generator is designed so that computation happens in your browser. The tool does not store or log your keys or messages on disk, but you should still avoid using production secrets from untrusted or shared environments."
              }
            }
          ]
        },
        {
          "@type": "BreadcrumbList",
          "@id": "https://8gwifi.org/hmacgen.jsp#breadcrumb",
          "itemListElement": [
            {
              "@type": "ListItem",
              "position": 1,
              "name": "8gwifi.org",
              "item": "https://8gwifi.org/"
            },
            {
              "@type": "ListItem",
              "position": 2,
              "name": "HMAC Generator",
              "item": "https://8gwifi.org/hmacgen.jsp"
            }
          ]
        }
      ]
    }
    </script>

    <style>
      .hmac-page .card-header{
        padding:.75rem 1rem;
        font-weight:600;
        background:linear-gradient(90deg,#0ea5e9,#38bdf8);
        color:#0f172a;
      }
      .hmac-page .card-header.secondary{
        background:linear-gradient(90deg,#e5f3ff,#f3f4ff);
        color:#111827;
      }
      .hmac-page .badge-soft{
        background:rgba(59,130,246,.1);
        color:#1d4ed8;
        border-radius:999px;
        font-size:.75rem;
        padding:.15rem .5rem;
      }
      .hmac-page .eeat-banner{
        background:linear-gradient(120deg,#e0f2fe,#f5f3ff);
        border-radius:.75rem;
        padding:1rem 1.25rem;
        color:#1f2933;
        box-shadow:0 8px 18px rgba(15,23,42,.08);
      }
      .hmac-page .eeat-meta{
        font-size:.8rem;
        color:#9ca3af;
      }
      .hmac-page .result-item{
        border-radius:.5rem;
        border:1px solid #e5e7eb;
        padding:.75rem;
        margin-bottom:.75rem;
        background:#f9fafb;
      }
      .hmac-page .result-label{
        font-size:.8rem;
        font-weight:600;
        color:#6b7280;
      }
      .hmac-page .mono{
        font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono","Courier New",monospace;
      }
      .hmac-page .copy-feedback{
        font-size:.75rem;
        color:#16a34a;
        display:none;
      }
      .hmac-page .algo-chip{
        display:inline-flex;
        align-items:center;
        gap:.3rem;
        border-radius:999px;
        border:1px solid #e5e7eb;
        padding:.2rem .6rem;
        margin:.15rem .3rem .15rem 0;
        background:#fff;
        font-size:.8rem;
      }
      .hmac-page .algo-chip.modern{
        border-color:#22c55e;
        background:rgba(22,163,74,.04);
      }
      .hmac-page .algo-chip.legacy{
        border-color:#f97316;
        background:rgba(248,113,113,.03);
      }
      .hmac-page .algo-chip-weak{
        border-color:#f97316;
      }
      .hmac-page .help-text{
        font-size:.8rem;
        color:#6b7280;
      }
      .hmac-page .section-title{
        font-weight:600;
        font-size:.9rem;
        text-transform:uppercase;
        letter-spacing:.06em;
        color:#6b7280;
        margin-bottom:.25rem;
      }
    </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 hmac-page">
  <div class="eeat-banner mb-4">
    <div class="d-flex justify-content-between align-items-start flex-wrap">
      <div>
        <h1 class="h4 mb-1">Online HMAC Generator</h1>
        <p class="mb-1 small">Compute keyed hashes (HMAC) for message authentication and API request signing. Keys are processed only in memory and never logged.</p>
</div>

        </div>
    </div>

  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm">
        <h5 class="card-header">
          <i class="fas fa-key me-1"></i> Input &amp; Algorithms
        </h5>
        <div class="card-body">
          <form id="hmacForm" method="POST">
            <input type="hidden" name="methodName" id="methodName" value="GENERATE_HMAC">

            <div class="mb-3">
              <label for="inputtext" class="form-label">Message to authenticate</label>
              <textarea class="form-control" id="inputtext" name="text" rows="3" placeholder="clear text message..."></textarea>
              <div class="help-text mt-1">This is the message you will later verify with the same key and algorithm.</div>
    </div>

            <div class="mb-3">
              <label for="passphrase" class="form-label">Secret key</label>
              <div class="input-group input-group-sm">
                <input class="form-control" id="passphrase" type="password" name="passphrase" autocomplete="off" placeholder="Type or generate a shared secret key (never shared or logged)">
                <button type="button" id="btnGenKey" class="btn btn-outline-secondary">
                  <i class="fas fa-random me-1"></i> Generate Key
                </button>
    </div>
              <div class="help-text mt-1">Use a high-entropy key. This tool never stores keys on disk. The generator uses your browser&apos;s crypto API to create a random key.</div>
    </div>

            <div class="mb-2 d-flex justify-content-between align-items-center">
              <div class="section-title mb-0">Algorithms</div>
              <div class="help-text">Select one or more HMAC algorithms.</div>
    </div>

            <div class="mb-2">
              <div class="mb-1 small text-muted">Recommended</div>
              <label class="algo-chip modern">
                <input type="checkbox" id="HmacSHA256" value="HmacSHA256" name="HmacSHA256" checked>
                <span>HMAC-SHA-256</span>
              </label>
              <label class="algo-chip modern">
                <input type="checkbox" id="HmacSHA512" value="HmacSHA512" name="HmacSHA512">
                <span>HMAC-SHA-512</span>
              </label>
              <label class="algo-chip modern">
                <input type="checkbox" id="HmacSHA224" value="HmacSHA224" name="HmacSHA224">
                <span>HMAC-SHA-224</span>
              </label>
    </div>

            <div class="mb-2">
              <div class="mb-1 small text-muted">Other supported algorithms</div>
              <label class="algo-chip">
                <input type="checkbox" id="HmacSHA1" value="HmacSHA1" name="HmacSHA1">
                <span>HMAC-SHA-1</span>
              </label>
              <label class="algo-chip">
                <input type="checkbox" id="HMACTIGER" value="HMACTIGER" name="HMACTIGER">
                <span>HMAC-TIGER</span>
              </label>
              <label class="algo-chip">
                <input type="checkbox" id="HMACRIPEMD128" value="HMACRIPEMD128" name="HMACRIPEMD128">
                <span>HMAC-RIPEMD-128</span>
              </label>
              <label class="algo-chip">
                <input type="checkbox" id="HMACRIPEMD160" value="HMACRIPEMD160" name="HMACRIPEMD160">
                <span>HMAC-RIPEMD-160</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="RC2MAC" value="RC2MAC" name="RC2MAC">
                <span>RC2-MAC</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="RC5MAC" value="RC5MAC" name="RC2MAC">
                <span>RC5-MAC</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="IDEAMAC" value="IDEAMAC" name="IDEAMAC">
                <span>IDEA-MAC</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="IDEAMACCFB8" value="IDEAMACCFB8" name="IDEAMACCFB8">
                <span>IDEA-MAC/CFB8</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="PBEWithHmacSHA1" value="PBEWithHmacSHA1" name="MD2">
                <span>PBEWithHmacSHA1</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="PBEWithHmacSHA384" value="PBEWithHmacSHA384" name="PBEWithHmacSHA384">
                <span>PBE-HmacSHA384</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="PBEWithHmacSHA256" value="PBEWithHmacSHA256" name="PBEWithHmacSHA256">
                <span>PBE-HmacSHA256</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="PBEWithHmacSHA512" value="PBEWithHmacSHA512" name="PBEWithHmacSHA512">
                <span>PBE-HmacSHA512</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="DES" value="DES" name="DES">
                <span>DES-MAC</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="DESEDEMAC" value="DESEDEMAC" name="DESEDEMAC">
                <span>DESEDE-MAC</span>
              </label>
              <label class="algo-chip algo-chip-weak">
                <input type="checkbox" id="HMACMD5" value="HMACMD5" name="HMACMD5">
                <span>HMAC-MD5</span>
              </label>
              <label class="algo-chip algo-chip-weak">
                <input type="checkbox" id="HMACMD4" value="HMACMD4" name="HMACMD4">
                <span>HMAC-MD4</span>
              </label>
              <label class="algo-chip algo-chip-weak">
                <input type="checkbox" id="HMACMD2" value="HMACMD2" name="HMACMD2">
                <span>HMAC-MD2</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="SKIPJACKMAC" value="SKIPJACKMAC" name="SKIPJACKMAC">
                <span>SKIPJACK-MAC</span>
              </label>
              <label class="algo-chip legacy">
                <input type="checkbox" id="SKIPJACKMACCFB8" value="SKIPJACKMACCFB8" name="SKIPJACKMACCFB8">
                <span>SKIPJACK-MAC/CFB8</span>
              </label>
    </div>

            <div class="d-flex flex-wrap align-items-center mt-3 gap-2">
              <button type="submit" class="btn btn-primary btn-sm">
                <i class="fas fa-calculator me-1"></i> Compute HMAC
              </button>
              <button type="button" id="btnClear" class="btn btn-outline-secondary btn-sm">
                <i class="fas fa-eraser me-1"></i> Clear
              </button>
    </div>

            <div id="hmacError" class="alert alert-danger mt-3" style="display:none" role="alert">
              <i class="fas fa-exclamation-triangle me-1"></i><span id="hmacErrorText"></span>
    </div>
          </form>
    </div>
    </div>
    </div>

    <div class="col-lg-5 mb-4">
      <div class="card shadow-sm mb-4">
        <h5 class="card-header secondary">
          <i class="fas fa-shield-alt me-1"></i> HMAC Results
        </h5>
        <div class="card-body">
          <div id="resultsEmpty" class="text-center text-muted py-4">
            <i class="fas fa-shield-alt fa-3x mb-3 opacity-25"></i>
            <p class="mb-0">Your HMAC results will appear here.</p>
            <p class="small">Enter a message, key and choose one or more algorithms, then click <strong>Compute HMAC</strong>.</p>
    </div>
          <div id="hmacResults" style="display:none"></div>

          <div class="mt-3" id="hmacShareContainer" style="display:none">
            <button type="button" id="btnShare" class="btn btn-outline-info btn-sm mb-2">
              <i class="fas fa-link me-1"></i> Generate Share URL
            </button>
            <div class="help-text mb-1">
              The share URL includes your message, selected algorithms and (if present) the secret key; a red warning will explain the risk.
            </div>

            <div id="hmacShareInline" class="mt-2" style="display:none">
              <label class="small fw-semibold mb-1">Share URL</label>
              <div class="input-group input-group-sm">
                <input type="text" class="form-control mono" id="hmacShareUrlInline" readonly>
                <button class="btn btn-outline-secondary" type="button" id="copyHmacShareUrlInline">
                  <i class="fas fa-copy"></i> Copy
                </button>
    </div>
              <div id="hmacShareInlineNote" class="small mt-1"></div>
    </div>
    </div>
    </div>
    </div>

      <div class="card shadow-sm">
        <h5 class="card-header secondary">
          <i class="fas fa-info-circle me-1"></i> About HMAC &amp; security
        </h5>
        <div class="card-body small">
          <p><strong>HMAC (Hash-based Message Authentication Code)</strong> combines a cryptographic hash function with a secret key to provide both <em>integrity</em> and <em>authentication</em> of a message.</p>
          <ul class="mb-2">
            <li><strong>Use modern algorithms</strong>: HMAC-SHA-256 or HMAC-SHA-512 are recommended for new designs.</li>
            <li><strong>Avoid legacy hashes</strong> (MD2, MD4, MD5, SHA‑1) for new systems; they are included here mainly for interoperability and testing.</li>
            <li><strong>Keep keys secret</strong>: Treat your HMAC key like a password or API secret and rotate it regularly.</li>
          </ul>
          <p class="mb-1"><strong>Typical use cases</strong>:</p>
          <ul class="mb-2">
            <li>API request signing (e.g., AWS-style signatures).</li>
            <li>Integrity-protecting configuration files or messages.</li>
            <li>Verifying webhook payloads with a shared secret.</li>
          </ul>
          <p class="mb-1"><strong>References</strong>:</p>
          <ul class="mb-0">
            <li><a href="https://datatracker.ietf.org/doc/html/rfc2104" target="_blank" rel="noopener">RFC 2104: HMAC</a></li>
            <li><a href="https://datatracker.ietf.org/doc/html/rfc4868" target="_blank" rel="noopener">RFC 4868: HMAC-SHA for IPsec</a></li>
          </ul>

            <div class="text-end eeat-meta mt-2 mt-sm-0">
                <div><strong>Author</strong>: Anish Nath</div>
                <div><strong>Last updated</strong>: 2025</div>
                <div><span class="badge-soft">No key storage · Browser-based computation</span></div>
    </div>
    </div>
    </div>
    </div>
    </div>

  <!-- FAQ Section -->
  <div class="row mt-4">
    <div class="col-12">
      <div class="card shadow-sm">
        <h5 class="card-header">
          <i class="fas fa-question-circle me-1"></i> HMAC FAQ
        </h5>
        <div class="card-body small">
          <p class="mb-3">
            Below are some quick answers to common questions about HMAC, how it works under the hood and how this tool handles your data.
          </p>

          <h6 class="fw-semibold">1. What is an HMAC and how does it work?</h6>
          <p>
            HMAC (Hash-based Message Authentication Code) is a construction that turns a cryptographic hash function (such as SHA-256)
            into a <strong>keyed</strong> integrity check. Instead of hashing only the message, HMAC mixes a secret key into the hash in a
            carefully defined way: internally it computes
            <span class="mono">HMAC(K, m) = H((K ⊕ opad) || H((K ⊕ ipad) || m))</span>,
            where <span class="mono">H</span> is the hash, <span class="mono">K</span> is the key, <span class="mono">m</span> is the message and
            <span class="mono">ipad/opad</span> are fixed constants. This design keeps HMAC secure even if the underlying hash has some structural weaknesses.
          </p>

          <h6 class="fw-semibold mt-3">2. Why is HMAC used instead of a plain hash?</h6>
          <p>
            A plain hash (like SHA-256(message)) only tells you that the bits haven&apos;t changed by accident; anyone can recompute it.
            HMAC adds a shared secret key, so only someone who knows the key can generate or verify the MAC. That gives you two properties:
            <strong>integrity</strong> (the message wasn&apos;t modified) and <strong>authentication</strong> (it came from someone who knows the key),
            which is why HMAC is widely used for API request signing, webhooks, VPN protocols and key-derivation functions.
          </p>

          <h6 class="fw-semibold mt-3">3. Which HMAC algorithms and standards are recommended today?</h6>
          <p>
            The original HMAC construction is defined in <a href="https://datatracker.ietf.org/doc/html/rfc2104" target="_blank" rel="noopener">RFC&nbsp;2104</a>.
            Modern protocols typically use HMAC with SHA-2 family hashes, for example:
            HMAC-SHA-256 or HMAC-SHA-512. These are used in TLS (for older ciphersuites),
            IPsec (<a href="https://datatracker.ietf.org/doc/html/rfc4868" target="_blank" rel="noopener">RFC&nbsp;4868</a>),
            AWS Signature Version&nbsp;4, many JWT &quot;HS256/HS512&quot; tokens and HKDF-based key derivation.
            Legacy variants such as HMAC-MD5 or HMAC-SHA-1 are kept mainly for compatibility and should be avoided in new designs.
          </p>

          <h6 class="fw-semibold mt-3">4. How strong should my HMAC key be?</h6>
          <p>
            As a rule of thumb, your HMAC key should be at least as strong as the hash output.
            For HMAC-SHA-256, a randomly generated 128–256 bit key (16–32 bytes) is usually sufficient.
            Avoid short, guessable keys (like simple words or usernames); use a cryptographic random generator instead
            (this tool&apos;s &quot;Generate Key&quot; button uses the browser&apos;s <span class="mono">crypto.getRandomValues()</span> API).
          </p>

          <h6 class="fw-semibold mt-3">5. Is my secret key included in the share URL?</h6>
          <p>
            Yes. If a key is present in the form it is included in the generated share URL, and the tool shows a red warning explaining the risk.
            This is meant for demos and debugging, not for production secrets—anyone with the URL can see the key and verify or forge HMACs.
          </p>

          <h6 class="fw-semibold mt-3">6. Are my keys or messages stored on the server?</h6>
          <p class="mb-0">
            The tool is designed so that computation happens in your browser and inputs are not written to disk.
            Even so, you should treat any online tool as untrusted for long-term production secrets:
            keep keys short-lived, rotate them regularly and prefer offline or self-hosted tooling for highly sensitive data.
          </p>
        </div>
      </div>
    </div>
  </div>

<hr>
<%@ include file="footer_adsense.jsp"%>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

<!-- Share URL Modal (pattern adapted from rsafunctions.jsp) -->
<div class="modal fade" id="hmacShareModal" tabindex="-1" role="dialog" aria-labelledby="hmacShareModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header bg-info text-white">
        <h5 class="modal-title" id="hmacShareModalLabel">
          <i class="fas fa-share-alt"></i> Share URL - Security Notice
        </h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div id="hmacShareWarningContent" class="mb-3"></div>

        <label class="font-weight-bold mb-2">Share URL:</label>
        <div class="input-group mb-3">
          <input type="text" class="form-control" id="hmacShareUrlText" readonly style="font-size:11px;font-family:monospace;">
          <div class="input-group-append">
            <button class="btn btn-success" type="button" id="copyHmacShareUrl">
              <i class="fas fa-copy"></i> Copy
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
  (function(){
    function $(id){ return document.getElementById(id); }

    function showError(msg){
      var box = $('hmacError');
      var text = $('hmacErrorText');
      if(box && text){
        text.textContent = msg;
        box.style.display = 'block';
      }
    }

    function clearError(){
      var box = $('hmacError');
      var text = $('hmacErrorText');
      if(box && text){
        text.textContent = '';
        box.style.display = 'none';
      }
    }

    function renderResults(data){
      var empty = $('resultsEmpty');
      var container = $('hmacResults');
      if(!container) return;
      container.innerHTML = '';

      if(!data || !data.results || !data.results.length){
        if(empty) empty.style.display = 'block';
        container.style.display = 'none';
        return;
      }

      if(empty) empty.style.display = 'none';
      container.style.display = 'block';

      data.results.forEach(function(r){
        var wrap = document.createElement('div');
        wrap.className = 'result-item';

        var title = document.createElement('div');
        title.className = 'd-flex justify-content-between align-items-center mb-1';
        title.innerHTML = '<span class="fw-semibold">'+ (r.algorithm || 'HMAC') +'</span>'
          + '<span class="badge-soft">'+ (r.message && r.message.length ? (r.message.length + " bytes MAC") : "HMAC result") +'</span>';
        wrap.appendChild(title);

        // Base64
        var b64Label = document.createElement('div');
        b64Label.className = 'result-label mb-1';
        b64Label.textContent = 'Base64 encoded HMAC';
        wrap.appendChild(b64Label);

        var b64Group = document.createElement('div');
        b64Group.className = 'input-group input-group-sm mb-2';
        var b64Area = document.createElement('textarea');
        b64Area.className = 'form-control mono';
        b64Area.rows = 2;
        b64Area.readOnly = true;
        b64Area.textContent = r.base64Encoded || '';
        var b64BtnWrap = document.createElement('button');
        b64BtnWrap.type = 'button';
        b64BtnWrap.className = 'btn btn-outline-secondary';
        b64BtnWrap.innerHTML = '<i class="far fa-copy"></i>';
        var b64Feedback = document.createElement('div');
        b64Feedback.className = 'copy-feedback ms-1';
        b64Feedback.textContent = 'Copied';
        b64BtnWrap.addEventListener('click', function(){
          copyToClipboard(b64Area.value || b64Area.textContent, b64Feedback);
        });
        b64Group.appendChild(b64Area);
        b64Group.appendChild(b64BtnWrap);
        wrap.appendChild(b64Group);
        wrap.appendChild(b64Feedback);

        // Hex
        var hexLabel = document.createElement('div');
        hexLabel.className = 'result-label mb-1';
        hexLabel.textContent = 'Hex encoded HMAC';
        wrap.appendChild(hexLabel);

        var hexGroup = document.createElement('div');
        hexGroup.className = 'input-group input-group-sm mb-1';
        var hexArea = document.createElement('textarea');
        hexArea.className = 'form-control mono';
        hexArea.rows = 2;
        hexArea.readOnly = true;
        hexArea.textContent = r.hexEncoded || '';
        var hexBtnWrap = document.createElement('button');
        hexBtnWrap.type = 'button';
        hexBtnWrap.className = 'btn btn-outline-secondary';
        hexBtnWrap.innerHTML = '<i class="far fa-copy"></i>';
        var hexFeedback = document.createElement('div');
        hexFeedback.className = 'copy-feedback ms-1';
        hexFeedback.textContent = 'Copied';
        hexBtnWrap.addEventListener('click', function(){
          copyToClipboard(hexArea.value || hexArea.textContent, hexFeedback);
        });
        hexGroup.appendChild(hexArea);
        hexGroup.appendChild(hexBtnWrap);
        wrap.appendChild(hexGroup);
        wrap.appendChild(hexFeedback);

        container.appendChild(wrap);
      });
    }

    function copyToClipboard(text, feedbackEl){
      if(!text) return;
      if(navigator.clipboard && navigator.clipboard.writeText){
        navigator.clipboard.writeText(text).then(function(){
          if(feedbackEl){
            feedbackEl.style.display = 'inline';
            setTimeout(function(){ feedbackEl.style.display = 'none'; }, 1200);
          }
        });
      }else{
        var ta = document.createElement('textarea');
        ta.value = text;
        ta.style.position = 'fixed';
        ta.style.opacity = '0';
        document.body.appendChild(ta);
        ta.select();
        try{ document.execCommand('copy'); }catch(e){}
        document.body.removeChild(ta);
        if(feedbackEl){
          feedbackEl.style.display = 'inline';
          setTimeout(function(){ feedbackEl.style.display = 'none'; }, 1200);
        }
      }
    }

    function serializeForm(form){
      var params = [];
      for(var i=0;i<form.elements.length;i++){
        var el = form.elements[i];
        if(!el.name || el.disabled) continue;
        if((el.type === 'checkbox' || el.type === 'radio') && !el.checked) continue;
        params.push(encodeURIComponent(el.name) + '=' + encodeURIComponent(el.value));
      }
      return params.join('&');
    }

    function initFromUrl(){
      try{
        var usp = new URLSearchParams(window.location.search);
        // Prefer RSA-style param name `msg`, fall back to older `text`
        var msg = usp.get('msg') || usp.get('text');
        var algos = usp.get('algos');
        var keyParam = usp.get('key');
        if(msg){
          var t = $('inputtext');
          if(t) t.value = msg;
        }
        if(algos){
          algos.split(',').forEach(function(a){
            var el = $(a);
            if(el && el.type === 'checkbox') el.checked = true;
          });
        }
        if(keyParam){
          var k = $('passphrase');
          if(k) k.value = keyParam;
        }
      }catch(e){}
    }

    function shareUrl(){
      var msg = $('inputtext') ? $('inputtext').value : '';
      if(!msg){
        showError('Enter a message before generating a shareable URL.');
        return;
      }

      // Require that results are present before creating share URL
      var resultsDiv = $('hmacResults');
      if(!resultsDiv || resultsDiv.style.display === 'none' || !resultsDiv.children.length){
        showError('Compute HMAC first, then generate a share URL.');
        return;
      }

      clearError();

      var selected = [];
      var form = $('hmacForm');
      if(form){
        for(var i=0;i<form.elements.length;i++){
          var el = form.elements[i];
          if(el.type === 'checkbox' && el.checked){
            selected.push(el.id);
          }
        }
      }

      var key = $('passphrase') ? $('passphrase').value : '';
      var includesKey = false;

      // Use the same URLSearchParams style as rsafunctions.jsp
      var params = new URLSearchParams();
      params.set('msg', msg);
      if(selected.length){
        params.set('algos', selected.join(','));
      }
      if(key){
        params.set('key', key);
        includesKey = true;
      }

      var url = window.location.origin + window.location.pathname + '?' + params.toString();

      // Populate warning content similar to RSA modal
      var warningEl = document.getElementById('hmacShareWarningContent');
      if(warningEl){
        var algoText = selected.length ? selected.join(', ') : 'Default / selected algorithms on page';
        if(includesKey){
          warningEl.innerHTML =
            '<div class="alert alert-danger mb-3">' +
              '<strong><i class="fas fa-exclamation-triangle"></i> DANGER: Secret Key Included!</strong>' +
              '<ul class="mb-0 mt-2">' +
                '<li><strong>Message:</strong> Included in clear text in the URL parameters.</li>' +
                '<li><strong>Algorithms:</strong> ' + algoText + '.</li>' +
                '<li><strong class="text-danger">Secret key:</strong> INCLUDED – this allows anyone with the URL to recompute or verify the HMAC.</li>' +
              '</ul>' +
            '</div>' +
            '<div class="alert alert-danger mb-0">' +
              '<strong><i class="fas fa-skull-crossbones"></i> CRITICAL SECURITY WARNING:</strong>' +
              '<p class="mb-2"><strong>You are about to share your HMAC key via URL!</strong></p>' +
              '<ul class="mb-0">' +
                '<li>Anyone with this URL can verify or forge HMACs for this secret.</li>' +
                '<li>Only use this for demos, testing, or throwaway keys.</li>' +
                '<li>For real systems, never include long‑term secrets in URLs.</li>' +
              '</ul>' +
            '</div>';
        } else {
          warningEl.innerHTML =
            '<div class="alert alert-warning mb-3">' +
              '<strong><i class="fas fa-shield-alt"></i> What\'s Being Shared:</strong>' +
              '<ul class="mb-0 mt-2">' +
                '<li><strong>Message:</strong> Included in clear text in the URL parameters.</li>' +
                '<li><strong>Algorithms:</strong> ' + algoText + '.</li>' +
                '<li><strong>Secret key:</strong> <span class="text-success">NOT included</span> (you must share the key out-of-band).</li>' +
              '</ul>' +
            '</div>' +
            '<div class="alert alert-info mb-0">' +
              '<strong><i class="fas fa-info-circle"></i> Security Reminder:</strong>' +
              '<p class="mb-0">Anyone with this URL can see your message and chosen algorithms, but cannot recompute or verify the HMAC without the shared secret key.</p>' +
            '</div>';
        }
      }

      var urlInput = document.getElementById('hmacShareUrlText');
      if(urlInput){
        urlInput.value = url;
      }

      // Also show share URL inline under results
      var inlineBox = document.getElementById('hmacShareInline');
      var inlineInput = document.getElementById('hmacShareUrlInline');
      var inlineNote = document.getElementById('hmacShareInlineNote');
      if(inlineBox && inlineInput){
        inlineInput.value = url;
        inlineBox.style.display = 'block';
        if(includesKey){
          inlineNote.innerHTML = '<span class="text-danger">Warning: this URL includes the secret key. Use only for demos or throwaway keys.</span>';
        } else {
          inlineNote.innerHTML = '<span class="text-muted">This URL does not include the secret key. Share the key out-of-band if verification is needed.</span>';
        }
      }

      // Show Bootstrap modal (pattern from rsafunctions.jsp)
      if(window.jQuery && typeof jQuery.fn.modal === 'function'){
        jQuery('#hmacShareModal').modal('show');
      }
    }

    function clearAll(){
      var form = $('hmacForm');
      if(form){
        form.reset();
      }
      clearError();
      var res = $('hmacResults');
      var empty = $('resultsEmpty');
      if(res){
        res.innerHTML = '';
        res.style.display = 'none';
      }
      if(empty) empty.style.display = 'block';
    }

    function init(){
      var form = $('hmacForm');
      var clearBtn = $('btnClear');
      var shareBtn = $('btnShare');
      var genKeyBtn = $('btnGenKey');
      var copyShareBtn = $('copyHmacShareUrl');
      var copyShareInlineBtn = $('copyHmacShareUrlInline');

      if(form){
        form.addEventListener('submit', function(e){
          e.preventDefault();
          clearError();
          var msg = $('inputtext') ? $('inputtext').value.trim() : '';
          var key = $('passphrase') ? $('passphrase').value : '';
          if(!msg){
            showError('Message is null or empty.');
            return;
          }
          // Basic key validation
          if(!key){
            showError('Key is null or empty.');
            return;
          }
          if(key.length < 8){
            showError('Key is too short. Use at least 8 characters for the HMAC key.');
            return;
          }
          if(key.trim().length !== key.length){
            showError('Key has leading or trailing whitespace. Please remove extra spaces.');
            return;
          }

          var hasAlgo = false;
          for(var i=0;i<form.elements.length;i++){
            var el = form.elements[i];
            if(el.type === 'checkbox' && el.checked){
              hasAlgo = true;
              break;
            }
          }
          if(!hasAlgo){
            showError('Please select at least one HMAC algorithm.');
            return;
          }

          var params = serializeForm(form);
          var res = $('hmacResults');
          var empty = $('resultsEmpty');
          if(empty) empty.style.display = 'none';
          if(res){
            res.style.display = 'block';
            res.innerHTML = '<div class="text-center text-muted py-3"><img src="images/712.GIF" alt="" class="me-2">Computing HMAC...</div>';
          }
          var shareContainer = $('hmacShareContainer');
          if(shareContainer){
            shareContainer.style.display = 'none';
            var inlineBox = $('hmacShareInline');
            if(inlineBox){
              inlineBox.style.display = 'none';
            }
          }

          fetch('MDFunctionality', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json'
            },
            body: params
          }).then(function(r){
            if(!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
          }).then(function(data){
            if(!data || data.success === false){
              showError(data && data.errorMessage ? data.errorMessage : 'Unable to generate HMAC. Please try again.');
            }
            renderResults(data || {});
            var shareContainer = $('hmacShareContainer');
            if(shareContainer){
              shareContainer.style.display = 'block';
            }
          }).catch(function(err){
            showError('System error: ' + err.getMessage());
          });
        });
      }

      if(clearBtn){
        clearBtn.addEventListener('click', function(e){
          e.preventDefault();
          clearAll();
        });
      }

      if(shareBtn){
        shareBtn.addEventListener('click', function(e){
          e.preventDefault();
          shareUrl();
        });
      }

      if(genKeyBtn){
        genKeyBtn.addEventListener('click', function(e){
          e.preventDefault();
          try{
            var lenBytes = 32; // 256-bit key
            var arr = new Uint8Array(lenBytes);
            if(window.crypto && window.crypto.getRandomValues){
              window.crypto.getRandomValues(arr);
            }else{
              for(var i=0;i<lenBytes;i++){
                arr[i] = Math.floor(Math.random()*256);
              }
            }
            var hex = Array.from(arr).map(function(b){
              return ('0' + b.toString(16)).slice(-2);
            }).join('');
            var pass = $('passphrase');
            if(pass){
              pass.value = hex;
              pass.type = 'text'; // briefly show so user can copy; they can toggle browser mask
            }
          }catch(err){
            alert('Unable to generate key in this browser: ' + err.message);
          }
        });
      }

      if(copyShareBtn){
        copyShareBtn.addEventListener('click', function(){
          var urlInput = $('hmacShareUrlText');
          if(!urlInput || !urlInput.value) return;
          copyToClipboard(urlInput.value, null);
          var self = this;
          var oldHtml = self.innerHTML;
          self.innerHTML = '<i class="fas fa-check"></i> Copied!';
          setTimeout(function(){
            self.innerHTML = oldHtml;
          }, 1500);
        });
      }

      if(copyShareInlineBtn){
        copyShareInlineBtn.addEventListener('click', function(){
          var urlInput = $('hmacShareUrlInline');
          if(!urlInput || !urlInput.value) return;
          copyToClipboard(urlInput.value, null);
          var self = this;
          var oldHtml = self.innerHTML;
          self.innerHTML = '<i class="fas fa-check"></i> Copied!';
          setTimeout(function(){
            self.innerHTML = oldHtml;
          }, 1500);
        });
      }

      initFromUrl();
    }

    if(document.readyState === 'loading'){
      document.addEventListener('DOMContentLoaded', init);
    } else {
      init();
    }
  })();
</script>
</div>
<%@ include file="body-close.jsp"%>

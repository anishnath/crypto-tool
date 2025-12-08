<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Embed Online Compiler – Add Interactive Code Examples | 8gwifi.org</title>
  <meta name="description" content="Embed an online compiler on your site or docs. Copy‑paste iframe code with parameters for language, theme, readonly, autorun, and height. Works with Python, Java, C++, JavaScript and more." />
  <link rel="canonical" href="https://8gwifi.org/embed-online-compiler/" />

  <meta property="og:title" content="Embed Online Compiler – Add Interactive Code Examples" />
  <meta property="og:description" content="Copy‑paste iframe code to embed an online compiler that runs 60+ languages. Configure language, theme, readonly, autorun and height." />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://8gwifi.org/embed-online-compiler/" />
  <meta property="og:image" content="https://8gwifi.org/images/site/onecompiler-preview.png" />

  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="Embed Online Compiler – Add Interactive Code Examples" />
  <meta name="twitter:description" content="Embed a free online compiler for 60+ languages with simple iframe code." />
  <meta name="twitter:image" content="https://8gwifi.org/images/site/onecompiler-preview.png" />

  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "TechArticle",
    "headline": "Embed Online Compiler – Add Interactive Code Examples",
    "about": "Embedding an online compiler via iframe with configuration parameters.",
    "author": {"@type":"Person","name":"Anish Nath"},
    "url": "https://8gwifi.org/embed-online-compiler/",
    "image": "https://8gwifi.org/images/site/onecompiler-preview.png",
    "publisher": {"@type":"Organization","name":"8gwifi.org"}
  }
  </script>

  <%@ include file="../header-script.jsp" %>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; }
    .container { max-width: 980px; margin: 72px auto 48px; padding: 0 16px; }
    h1 { font-size: 2rem; margin-bottom: 0.5rem; }
    h2 { font-size: 1.25rem; margin-top: 2rem; }
    code, pre { background: #0f172a; color: #e2e8f0; border-radius: 6px; }
    pre { padding: 14px; overflow-x: auto; }
    .param { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace; }
    .note { background: #f1f5f9; border-left: 3px solid #0ea5e9; padding: 12px; border-radius: 4px; }
    .example { margin: 16px 0; }
    iframe.demo { width: 100%; height: 420px; border: 1px solid #e2e8f0; border-radius: 8px; }
    ul { padding-left: 18px; }
  </style>
</head>
<body>
  <%@ include file="../header.jsp" %>
  <div class="container">
    <h1>Embed Online Compiler</h1>
    <p>Add interactive, runnable code examples to your website, blog, or documentation with a simple <span class="param">&lt;iframe&gt;</span>. The embed supports 60+ languages and options like readonly, autorun, and dark theme.</p>

    <h2>Quick Start</h2>
    <p>Copy and paste this snippet to embed a Python editor:</p>
    <pre><code>&lt;iframe
  src="https://8gwifi.org/online-compiler/?lang=python&amp;autorun=1"
  width="100%" height="420" loading="lazy"
  style="border:1px solid #e2e8f0;border-radius:8px"&gt;&lt;/iframe&gt;</code></pre>

    <div class="example">
      <iframe class="demo" src="https://8gwifi.org/online-compiler/?lang=python&amp;autorun=1"></iframe>
    </div>

    <h2>Parameters</h2>
    <ul>
      <li><span class="param">lang</span>: default language (e.g., <em>python</em>, <em>java</em>, <em>cpp</em>, <em>javascript</em>).</li>
      <li><span class="param">readonly</span>: <em>1</em> to disable editing (view‑only).</li>
      <li><span class="param">autorun</span>: <em>1</em> to auto‑execute on load (where safe).</li>
      <li><span class="param">theme</span>: <em>vs-dark</em> (default) or <em>vs-light</em>.</li>
      <li><span class="param">height</span>: use the iframe’s <span class="param">height</span> attribute (e.g., <em>420</em>).</li>
      <li><span class="param">code</span>: base64‑encoded source (single‑file). See below.</li>
    </ul>

    <div class="note">Tip: For multi‑file examples, use the in‑app “Share” to generate a snippet URL, then embed that URL in the iframe.</div>

    <h2>Embedding Custom Code</h2>
    <p>Encode your code in Base64 and pass it via <span class="param">code</span>:</p>
    <pre><code>// Example Python
print("Hello from an embedded snippet!")

// Encode to Base64, then:
&lt;iframe
  src="https://8gwifi.org/online-compiler/?lang=python&amp;code=BASE64_HERE"
  width="100%" height="420" loading="lazy"
  style="border:1px solid #e2e8f0;border-radius:8px"&gt;&lt;/iframe&gt;</code></pre>

    <h2>Security & CSP</h2>
    <ul>
      <li>Serve over HTTPS and allow <span class="param">https://8gwifi.org</span> in <span class="param">frame-src</span>.</li>
      <li>Set <span class="param">sandbox</span> on the iframe if your CSP requires it.</li>
      <li>No cookies are set on public GETs for embed pages.</li>
    </ul>

    <h2>Supported Languages</h2>
    <p>See the complete list and versions in the <a href="/API_DOCUMENTATION.md">API documentation</a>.</p>
  </div>
  <%@ include file="../footer.jsp" %>
</body>
</html>


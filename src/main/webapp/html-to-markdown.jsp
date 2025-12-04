<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <title>HTML to Markdown Converter - Free Online Tool with GFM & Table Support</title>

        <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "HTML to Markdown Converter",
  "url": "https://8gwifi.org/html-to-markdown.jsp",
  "description": "Convert HTML to Markdown instantly with our free online tool. Supports GitHub Flavored Markdown (GFM), tables, code blocks, images, and complex formatting. 100% client-side conversion for complete privacy.",
  "applicationCategory": "DeveloperApplication",
  "operatingSystem": "Any",
  "author": { "@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good" },
  "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" },
  "featureList": [
    "Instant HTML to Markdown conversion",
    "GitHub Flavored Markdown (GFM) support",
    "Complex table conversion",
    "Code block formatting",
    "Client-side processing (Privacy focused)",
    "Real-time preview",
    "URL fetching support",
    "Custom heading styles"
  ],
  "datePublished": "2025-12-03",
  "dateModified": "2025-12-04"
}
    </script>
        <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question", "name": "How to convert HTML to Markdown?", "acceptedAnswer": {"@type": "Answer", "text": "Simply paste your HTML code into the input box or fetch it from a URL. The tool automatically converts it to clean Markdown syntax instantly."}},
    {"@type": "Question", "name": "Does this support HTML tables?", "acceptedAnswer": {"@type": "Answer", "text": "Yes, we fully support converting HTML tables into Markdown tables, compatible with GitHub Flavored Markdown (GFM)."}},
    {"@type": "Question", "name": "Is my data private?", "acceptedAnswer": {"@type": "Answer", "text": "Yes. All conversion happens locally in your browser using JavaScript. Your HTML content is never uploaded to our servers."}},
    {"@type": "Question", "name": "Can I convert an entire website URL?", "acceptedAnswer": {"@type": "Answer", "text": "Yes, use the 'Fetch from URL' feature to load HTML from any public webpage and convert it to Markdown."}},
    {"@type": "Question", "name": "What is GFM support?", "acceptedAnswer": {"@type": "Answer", "text": "GFM (GitHub Flavored Markdown) extends standard Markdown with tables, task lists, and strikethrough. Our tool supports these extensions by default."}}
  ]
}
    </script>

        <meta charset="UTF-8">
        <meta name="description"
            content="Convert HTML to Markdown instantly. Free online tool supporting tables, code blocks, images, and GitHub Flavored Markdown (GFM). No server uploads - 100% client-side privacy.">
        <meta name="keywords"
            content="html to markdown, convert html to markdown, html to md, markdown converter, html converter, github flavored markdown, gfm converter, html table to markdown, client-side markdown converter, free online tool">
        <meta name="author" content="Anish Nath">
        <meta name="robots" content="index, follow">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta property="og:title" content="HTML to Markdown Converter - Free Online Tool with GFM & Table Support">
        <meta property="og:description"
            content="Convert HTML to clean Markdown instantly. Supports tables, code blocks, and GFM. 100% Private & Free.">
        <meta property="og:type" content="website">
        <meta property="og:url" content="https://8gwifi.org/html-to-markdown.jsp">
        <link rel="canonical" href="https://8gwifi.org/html-to-markdown.jsp">

        <%@ include file="header-script.jsp" %>
            <script src="https://unpkg.com/turndown/dist/turndown.js"></script>
            <script src="https://unpkg.com/turndown-plugin-gfm/dist/turndown-plugin-gfm.js"></script>

            <style>
                :root {
                    --theme-primary: #667eea;
                    --theme-secondary: #764ba2;
                    --theme-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    --theme-light: #f0f0ff;
                }

                .tool-card {
                    border: none;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                    border-radius: 10px;
                    transition: box-shadow 0.2s;
                }

                .tool-card:hover {
                    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
                }

                .card-header-custom {
                    background: var(--theme-gradient);
                    color: white;
                    border-radius: 10px 10px 0 0 !important;
                    padding: 0.75rem 1rem;
                }

                .card-header-custom h5,
                .card-header-custom h6 {
                    margin: 0;
                    font-weight: 600;
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
                    font-size: 0.75rem;
                    margin-right: 0.5rem;
                    display: inline-flex;
                    align-items: center;
                    gap: 0.3rem;
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

                .result-card {
                    border: 2px dashed #dee2e6;
                    border-radius: 10px;
                    min-height: 200px;
                }

                .result-placeholder {
                    text-align: center;
                    padding: 3rem 1rem;
                    color: #6c757d;
                }

                .result-placeholder i {
                    font-size: 3rem;
                    margin-bottom: 1rem;
                    opacity: 0.5;
                }

                .result-content {
                    display: none;
                }

                .editor-textarea {
                    width: 100%;
                    min-height: 300px;
                    border: 1px solid #dee2e6;
                    border-radius: 8px;
                    padding: 1rem;
                    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
                    font-size: 0.85rem;
                    line-height: 1.6;
                    resize: vertical;
                    outline: none;
                }

                .editor-textarea:focus {
                    border-color: var(--theme-primary);
                    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                }

                .btn-theme {
                    background: var(--theme-gradient);
                    color: white;
                    border: none;
                    padding: 0.5rem 1.5rem;
                    border-radius: 6px;
                    font-weight: 500;
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .btn-theme:hover {
                    color: white;
                    transform: translateY(-1px);
                    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
                }

                .btn-theme-outline {
                    background: white;
                    color: var(--theme-primary);
                    border: 1px solid var(--theme-primary);
                    padding: 0.5rem 1rem;
                    border-radius: 6px;
                    font-weight: 500;
                }

                .btn-theme-outline:hover {
                    background: var(--theme-light);
                }

                .options-grid {
                    display: grid;
                    grid-template-columns: repeat(2, 1fr);
                    gap: 0.75rem;
                }

                @media (max-width: 576px) {
                    .options-grid {
                        grid-template-columns: 1fr;
                    }
                }

                .option-group label {
                    font-size: 0.8rem;
                    font-weight: 500;
                    color: #495057;
                    margin-bottom: 0.25rem;
                    display: block;
                }

                .option-group select {
                    width: 100%;
                    padding: 0.35rem 0.5rem;
                    border: 1px solid #ced4da;
                    border-radius: 6px;
                    font-size: 0.85rem;
                }

                .sample-buttons .btn {
                    padding: 0.25rem 0.5rem;
                    font-size: 0.75rem;
                }

                .char-count {
                    font-size: 0.75rem;
                    color: #6c757d;
                    margin-top: 0.5rem;
                }

                .related-tools {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 1rem;
                }

                .related-tool-card {
                    display: block;
                    padding: 1rem;
                    background: white;
                    border: 1px solid #e9ecef;
                    border-radius: 8px;
                    text-decoration: none;
                    transition: all 0.2s;
                }

                .related-tool-card:hover {
                    border-color: var(--theme-primary);
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    text-decoration: none;
                }

                .related-tool-card h6 {
                    color: var(--theme-primary);
                    margin-bottom: 0.25rem;
                    font-weight: 600;
                }

                .related-tool-card p {
                    color: #6c757d;
                    font-size: 0.8rem;
                    margin: 0;
                }

                .hash-output {
                    background: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 6px;
                    padding: 0.75rem;
                    font-family: monospace;
                    font-size: 0.85rem;
                    word-break: break-all;
                }

                .url-fetch-section {
                    background: linear-gradient(135deg, #e8f4fd 0%, #d6e9f8 100%);
                    border: 1px solid #b8daff;
                    border-radius: 8px;
                    padding: 0.75rem;
                    margin-bottom: 1rem;
                }

                .url-fetch-section .input-group {
                    margin-top: 0.5rem;
                }

                .url-fetch-section input {
                    font-size: 0.85rem;
                }

                .btn-fetch {
                    background: #0056b3;
                    color: white;
                    border: none;
                    font-weight: 500;
                }

                .btn-fetch:hover {
                    background: #004494;
                    color: white;
                }

                .btn-fetch:disabled {
                    background: #6c757d;
                }

                .fetch-spinner {
                    display: none;
                }

                .fetching .fetch-spinner {
                    display: inline-block;
                }

                .fetching .fetch-text {
                    display: none;
                }
            </style>
    </head>


    <%@ include file="body-script.jsp" %>


        <div class="container-fluid py-6">
            <div class="row">
                <!-- Main Content -->
                <div class="col-lg-12 col-md-8">
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h1 class="h4 mb-0">HTML to Markdown Converter</h1>
                            <div class="mt-1">
                                <span class="info-badge"><i class="fas fa-code"></i> Developer Tool</span>
                                <span class="info-badge"><i class="fas fa-lock"></i> Client-Side</span>
                                <span class="info-badge"><i class="fab fa-github"></i> GFM Support</span>
                                <span class="info-badge"><i class="fas fa-globe"></i> URL Fetch</span>
                            </div>
                        </div>
                        <div class="eeat-badge">
                            <i class="fas fa-user-check"></i>
                            <span>Anish Nath</span>
                        </div>
                    </div>

                    <!-- Security Note -->
                    <div class="alert alert-info py-2 mb-3">
                        <i class="fas fa-shield-alt mr-2"></i>
                        <strong>Privacy:</strong> Markdown conversion happens in your browser. URL fetch uses our server
                        to bypass CORS restrictions.
                    </div>

                    <div class="row">
                        <!-- Left Column - Input -->
                        <div class="col-lg-5 mb-4">
                            <div class="card tool-card">
                                <div class="card-header card-header-custom">
                                    <h6><i class="fas fa-code mr-2"></i>HTML Input</h6>
                                </div>
                                <div class="card-body">
                                    <!-- URL Fetch Section -->
                                    <div class="url-fetch-section">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-globe mr-2 text-primary"></i>
                                            <strong class="small">Fetch from URL</strong>
                                        </div>
                                        <div class="input-group mt-2">
                                            <input type="url" id="urlInput" class="form-control"
                                                placeholder="https://example.com/page.html">
                                            <div class="input-group-append">
                                                <button class="btn btn-fetch" id="fetchBtn" onclick="fetchUrl()">
                                                    <span
                                                        class="fetch-spinner spinner-border spinner-border-sm mr-1"></span>
                                                    <span class="fetch-text"><i
                                                            class="fas fa-download mr-1"></i>Fetch</span>
                                                </button>
                                            </div>
                                        </div>
                                        <small class="text-muted d-block mt-1">
                                            <i class="fas fa-info-circle mr-1"></i>Enter a URL to fetch its HTML content
                                        </small>
                                    </div>

                                    <!-- Sample Buttons -->
                                    <div class="mb-3 sample-buttons">
                                        <span class="small text-muted mr-2">Samples:</span>
                                        <button class="btn btn-sm btn-outline-secondary"
                                            onclick="loadSample('basic')">Basic</button>
                                        <button class="btn btn-sm btn-outline-secondary"
                                            onclick="loadSample('table')">Table</button>
                                        <button class="btn btn-sm btn-outline-secondary"
                                            onclick="loadSample('code')">Code</button>
                                        <button class="btn btn-sm btn-outline-secondary"
                                            onclick="loadSample('full')">Full</button>
                                    </div>

                                    <textarea id="htmlInput" class="editor-textarea" placeholder="Paste your HTML code here...

Example:
<h1>Hello World</h1>
<p>This is a <strong>bold</strong> and <em>italic</em> text.</p>
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
</ul>"></textarea>
                                    <div class="char-count">
                                        <span id="htmlCharCount">0</span> characters
                                        <button class="btn btn-sm btn-link text-danger float-right p-0"
                                            onclick="clearInput()">
                                            <i class="fas fa-eraser"></i> Clear
                                        </button>
                                    </div>

                                    <!-- Conversion Options -->
                                    <div class="form-section mt-3">
                                        <div class="form-section-title"><i class="fas fa-cog mr-1"></i>Conversion
                                            Options</div>
                                        <div class="options-grid">
                                            <div class="option-group">
                                                <label for="headingStyle">Heading Style</label>
                                                <select id="headingStyle">
                                                    <option value="atx" selected># ATX</option>
                                                    <option value="setext">Setext</option>
                                                </select>
                                            </div>
                                            <div class="option-group">
                                                <label for="bulletStyle">Bullet Marker</label>
                                                <select id="bulletStyle">
                                                    <option value="-" selected>Dash (-)</option>
                                                    <option value="*">Asterisk (*)</option>
                                                    <option value="+">Plus (+)</option>
                                                </select>
                                            </div>
                                            <div class="option-group">
                                                <label for="codeBlockStyle">Code Block</label>
                                                <select id="codeBlockStyle">
                                                    <option value="fenced" selected>Fenced (```)</option>
                                                    <option value="indented">Indented</option>
                                                </select>
                                            </div>
                                            <div class="option-group">
                                                <label for="linkStyle">Link Style</label>
                                                <select id="linkStyle">
                                                    <option value="inlined" selected>Inline</option>
                                                    <option value="referenced">Referenced</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Convert Button -->
                                    <button class="btn btn-theme btn-block mt-3" onclick="convertToMarkdown()">
                                        <i class="fas fa-exchange-alt mr-2"></i>Convert to Markdown
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column - Output -->
                        <div class="col-lg-7 mb-4">
                            <div class="card tool-card">
                                <div
                                    class="card-header card-header-custom d-flex justify-content-between align-items-center">
                                    <h6 class="mb-0"><i class="fab fa-markdown mr-2"></i>Markdown Output</h6>
                                    <div>
                                        <button class="btn btn-sm btn-light" onclick="copyOutput()">
                                            <i class="fas fa-copy"></i> Copy
                                        </button>
                                        <button class="btn btn-sm btn-light ml-1" onclick="downloadMarkdown()">
                                            <i class="fas fa-download"></i> Download
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div id="resultPlaceholder" class="result-card result-placeholder">
                                        <i class="fab fa-markdown d-block"></i>
                                        <p class="mb-0">Converted Markdown will appear here</p>
                                        <small class="text-muted">Paste HTML and click "Convert"</small>
                                    </div>
                                    <div id="resultContent" class="result-content">
                                        <textarea id="markdownOutput" class="editor-textarea" readonly></textarea>
                                        <div class="char-count">
                                            <span id="mdCharCount">0</span> characters | <span id="mdWordCount">0</span>
                                            words
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Parameter Guide -->
                            <div class="card tool-card mt-3">
                                <div class="card-header bg-light py-2">
                                    <h6 class="mb-0"><i class="fas fa-info-circle mr-2 text-info"></i>Markdown Syntax
                                        Reference</h6>
                                </div>
                                <div class="card-body py-2">
                                    <table class="table table-sm table-bordered mb-0 small">
                                        <thead class="table-light">
                                            <tr>
                                                <th>HTML</th>
                                                <th>Markdown</th>
                                                <th>Output</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>&lt;h1&gt;</code></td>
                                                <td><code># Heading</code></td>
                                                <td>Heading 1</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;strong&gt;</code></td>
                                                <td><code>**bold**</code></td>
                                                <td><strong>bold</strong></td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;em&gt;</code></td>
                                                <td><code>*italic*</code></td>
                                                <td><em>italic</em></td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;a href&gt;</code></td>
                                                <td><code>[text](url)</code></td>
                                                <td>Link</td>
                                            </tr>
                                            <tr>
                                                <td><code>&lt;code&gt;</code></td>
                                                <td><code>`code`</code></td>
                                                <td><code>code</code></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- CLI Commands Section -->
                    <div class="card tool-card mb-4">
                        <div class="card-header bg-dark text-white py-2">
                            <h6 class="mb-0"><i class="fas fa-terminal mr-2"></i>Command Line Alternatives</h6>
                        </div>
                        <div class="card-body">
                            <p class="small text-muted mb-2">Convert HTML to Markdown using popular CLI tools:</p>
                            <div class="row">
                                <div class="col-md-6 mb-2">
                                    <p class="small mb-1"><strong>Pandoc</strong></p>
                                    <pre
                                        class="bg-light p-2 rounded small mb-1"><code>pandoc -f html -t markdown input.html -o output.md</code></pre>
                                    <button class="btn btn-sm btn-outline-secondary"
                                        onclick="copyCmd('pandoc -f html -t markdown input.html -o output.md')">
                                        <i class="fas fa-copy"></i> Copy
                                    </button>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <p class="small mb-1"><strong>Node.js (turndown)</strong></p>
                                    <pre
                                        class="bg-light p-2 rounded small mb-1"><code>npx turndown-cli input.html > output.md</code></pre>
                                    <button class="btn btn-sm btn-outline-secondary"
                                        onclick="copyCmd('npx turndown-cli input.html > output.md')">
                                        <i class="fas fa-copy"></i> Copy
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Educational Content Section -->
                    <div class="card tool-card mb-4">
                        <div class="card-header bg-light">
                            <h5 class="mb-0"><i class="fas fa-graduation-cap mr-2"></i>Understanding HTML to Markdown
                                Conversion</h5>
                        </div>
                        <div class="card-body">
                            <h6>What is Markdown?</h6>
                            <p>Markdown is a lightweight markup language created by John Gruber in 2004. It allows you
                                to write using an easy-to-read, easy-to-write plain text format that converts to
                                structurally valid HTML. Markdown is widely used for documentation, README files, forum
                                posts, and static site generators.</p>

                            <h6 class="mt-4">Why Convert HTML to Markdown?</h6>
                            <ul>
                                <li><strong>Portability:</strong> Markdown files are plain text and work everywhere</li>
                                <li><strong>Readability:</strong> Markdown is human-readable even without rendering</li>
                                <li><strong>Version Control:</strong> Easy to diff and track changes in Git</li>
                                <li><strong>Platform Support:</strong> GitHub, GitLab, Notion, Obsidian all support
                                    Markdown</li>
                            </ul>

                            <h6 class="mt-4">Markdown Flavors Comparison</h6>
                            <table class="table table-sm table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>Feature</th>
                                        <th>Standard MD</th>
                                        <th>GFM</th>
                                        <th>CommonMark</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Tables</td>
                                        <td><span class="badge badge-secondary">No</span></td>
                                        <td><span class="badge badge-success">Yes</span></td>
                                        <td><span class="badge badge-secondary">No</span></td>
                                    </tr>
                                    <tr>
                                        <td>Task Lists</td>
                                        <td><span class="badge badge-secondary">No</span></td>
                                        <td><span class="badge badge-success">Yes</span></td>
                                        <td><span class="badge badge-secondary">No</span></td>
                                    </tr>
                                    <tr>
                                        <td>Strikethrough</td>
                                        <td><span class="badge badge-secondary">No</span></td>
                                        <td><span class="badge badge-success">Yes</span></td>
                                        <td><span class="badge badge-secondary">No</span></td>
                                    </tr>
                                    <tr>
                                        <td>Auto-linking</td>
                                        <td><span class="badge badge-secondary">No</span></td>
                                        <td><span class="badge badge-success">Yes</span></td>
                                        <td><span class="badge badge-secondary">No</span></td>
                                    </tr>
                                    <tr class="table-info">
                                        <td><strong>This Tool</strong></td>
                                        <td colspan="3"><span class="badge badge-primary">GFM (GitHub Flavored
                                                Markdown)</span></td>
                                    </tr>
                                </tbody>
                            </table>

                            <h6 class="mt-4">Code Examples</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <p class="small mb-1"><strong>JavaScript (Turndown)</strong></p>
                                    <pre class="bg-dark text-light p-2 rounded small"><code>const TurndownService = require('turndown');
const turndownService = new TurndownService();

const html = '&lt;h1&gt;Hello&lt;/h1&gt;';
const markdown = turndownService.turndown(html);
// Output: # Hello</code></pre>
                                </div>
                                <div class="col-md-6">
                                    <p class="small mb-1"><strong>Python (markdownify)</strong></p>
                                    <pre class="bg-dark text-light p-2 rounded small"><code>from markdownify import markdownify

html = '&lt;h1&gt;Hello&lt;/h1&gt;'
markdown = markdownify(html)
# Output: # Hello</code></pre>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Related Tools Section -->
                    <div class="card tool-card mb-4">
                        <div class="card-header bg-light py-2">
                            <h6 class="mb-0"><i class="fas fa-tools mr-2"></i>Related Tools</h6>
                        </div>
                        <div class="card-body">
                            <div class="related-tools">
                                <a href="jsonparser.jsp" class="related-tool-card">
                                    <h6><i class="fas fa-code mr-1"></i>JSON Beautifier</h6>
                                    <p>Format and validate JSON data</p>
                                </a>
                                <a href="yamlparser.jsp" class="related-tool-card">
                                    <h6><i class="fas fa-file-code mr-1"></i>YAML to JSON</h6>
                                    <p>Convert YAML to JSON/XML</p>
                                </a>
                                <a href="xml2json.jsp" class="related-tool-card">
                                    <h6><i class="fas fa-exchange-alt mr-1"></i>XML to JSON</h6>
                                    <p>Convert XML to JSON/YAML</p>
                                </a>
                                <a href="diff.jsp" class="related-tool-card">
                                    <h6><i class="fas fa-not-equal mr-1"></i>Text Diff</h6>
                                    <p>Compare text differences</p>
                                </a>
                                <a href="Base64Functions.jsp" class="related-tool-card">
                                    <h6><i class="fas fa-key mr-1"></i>Base64 Encoder</h6>
                                    <p>Encode/decode Base64 data</p>
                                </a>
                                <a href="StringFunctions.jsp" class="related-tool-card">
                                    <h6><i class="fas fa-font mr-1"></i>String Functions</h6>
                                    <p>Various string operations</p>
                                </a>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>

        <script>
            // Sample HTML content
            const samples = {
                basic: `<h1>Hello World</h1>
<p>This is a <strong>bold</strong> and <em>italic</em> text with a <a href="https://example.com">link</a>.</p>
<h2>Features</h2>
<ul>
    <li>Easy to use</li>
    <li>Fast conversion</li>
    <li>Free forever</li>
</ul>
<blockquote>
    <p>This is a blockquote with some wisdom.</p>
</blockquote>`,

                table: `<h2>Sales Report</h2>
<table>
    <thead>
        <tr>
            <th>Product</th>
            <th>Q1</th>
            <th>Q2</th>
            <th>Q3</th>
            <th>Q4</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Widget A</td>
            <td>$10,000</td>
            <td>$12,500</td>
            <td>$15,000</td>
            <td>$18,000</td>
        </tr>
        <tr>
            <td>Widget B</td>
            <td>$8,000</td>
            <td>$9,500</td>
            <td>$11,000</td>
            <td>$13,500</td>
        </tr>
    </tbody>
</table>`,

                code: `<h2>Code Example</h2>
<p>Here's a simple JavaScript function:</p>
<pre><code class="language-javascript">function greet(name) {
    console.log(\`Hello, \${name}!\`);
    return true;
}

// Call the function
greet('World');</code></pre>
<p>You can also use inline <code>code</code> like this.</p>`,

                full: `<article>
    <h1>Complete Guide to Markdown</h1>
    <p>Markdown is a <strong>lightweight markup language</strong> that you can use to add formatting elements to plaintext documents.</p>

    <h2>Why Use Markdown?</h2>
    <ul>
        <li><em>Portable</em> - Files can be opened in any text editor</li>
        <li><em>Platform independent</em> - Works everywhere</li>
        <li><em>Future proof</em> - Will always be readable</li>
    </ul>

    <h2>Basic Syntax</h2>
    <table>
        <thead>
            <tr>
                <th>Element</th>
                <th>Markdown Syntax</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Heading</td>
                <td><code># H1</code></td>
            </tr>
            <tr>
                <td>Bold</td>
                <td><code>**bold**</code></td>
            </tr>
            <tr>
                <td>Italic</td>
                <td><code>*italic*</code></td>
            </tr>
        </tbody>
    </table>

    <h2>Code Example</h2>
    <pre><code class="language-python">def hello_world():
    print("Hello, World!")

hello_world()</code></pre>

    <blockquote>
        <p>Markdown is intended to be as easy-to-read and easy-to-write as possible.</p>
        <cite>- John Gruber</cite>
    </blockquote>

    <h2>Learn More</h2>
    <p>Visit <a href="https://www.markdownguide.org">Markdown Guide</a> for comprehensive documentation.</p>

    <hr>
    <p><img src="https://example.com/markdown-logo.png" alt="Markdown Logo"></p>
</article>`
            };

            // Toast notification
            function showToast(message) {
                var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999; right: 20px; bottom: 20px;">' +
                    '<div class="toast show"><div class="toast-body text-white rounded py-2 px-3" style="background: var(--theme-gradient);">' +
                    '<i class="fas fa-info-circle mr-2"></i>' + message + '</div></div></div>');
                $('body').append(toast);
                setTimeout(function () { toast.fadeOut(function () { toast.remove(); }); }, 2000);
            }

            // Update character counts
            document.getElementById('htmlInput').addEventListener('input', function () {
                document.getElementById('htmlCharCount').textContent = this.value.length;
            });

            // Convert HTML to Markdown
            function convertToMarkdown() {
                const htmlInput = document.getElementById('htmlInput').value;

                if (!htmlInput.trim()) {
                    showToast('Please enter some HTML content to convert.');
                    return;
                }

                // Get options
                const options = {
                    headingStyle: document.getElementById('headingStyle').value,
                    bulletListMarker: document.getElementById('bulletStyle').value,
                    codeBlockStyle: document.getElementById('codeBlockStyle').value,
                    linkStyle: document.getElementById('linkStyle').value
                };

                // Create Turndown instance with options
                const turndownService = new TurndownService(options);

                // Add GFM plugin for tables, strikethrough, etc.
                if (typeof turndownPluginGfm !== 'undefined') {
                    turndownService.use(turndownPluginGfm.gfm);
                }

                try {
                    const markdown = turndownService.turndown(htmlInput);
                    document.getElementById('markdownOutput').value = markdown;
                    document.getElementById('mdCharCount').textContent = markdown.length;
                    document.getElementById('mdWordCount').textContent = markdown.split(/\s+/).filter(w => w).length;

                    // Show result content, hide placeholder
                    document.getElementById('resultPlaceholder').style.display = 'none';
                    document.getElementById('resultContent').style.display = 'block';

                    showToast('Conversion successful!');
                } catch (error) {
                    showToast('Error converting HTML: ' + error.message);
                }
            }

            // Load sample content
            function loadSample(type) {
                document.getElementById('htmlInput').value = samples[type];
                document.getElementById('htmlCharCount').textContent = samples[type].length;
                convertToMarkdown();
            }

            // Copy output to clipboard
            function copyOutput() {
                const output = document.getElementById('markdownOutput');
                if (!output.value) {
                    showToast('No content to copy.');
                    return;
                }
                output.select();
                document.execCommand('copy');
                showToast('Copied to clipboard!');
            }

            // Copy CLI command
            function copyCmd(cmd) {
                navigator.clipboard.writeText(cmd).then(() => {
                    showToast('Command copied!');
                });
            }

            // Download as .md file
            function downloadMarkdown() {
                const markdown = document.getElementById('markdownOutput').value;
                if (!markdown) {
                    showToast('No Markdown content to download.');
                    return;
                }

                const blob = new Blob([markdown], { type: 'text/markdown' });
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'converted.md';
                a.click();
                URL.revokeObjectURL(url);
                showToast('Download started!');
            }

            // Clear input
            function clearInput() {
                document.getElementById('htmlInput').value = '';
                document.getElementById('htmlCharCount').textContent = '0';
            }

            // Sanitize HTML - remove scripts, styles, and non-visible elements
            function sanitizeHtml(html) {
                // Parse HTML using DOMParser
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');

                // Elements to remove completely
                const removeSelectors = [
                    'script',           // JavaScript
                    'style',            // Inline CSS
                    'link[rel="stylesheet"]', // External CSS
                    'link[rel="preload"]',
                    'link[rel="prefetch"]',
                    'link[rel="dns-prefetch"]',
                    'link[rel="preconnect"]',
                    'meta',             // Meta tags
                    'noscript',         // Noscript content
                    'iframe',           // Embedded frames
                    'object',           // Embedded objects
                    'embed',            // Embedded content
                    'svg[hidden]',      // Hidden SVGs
                    'template',         // Template elements
                    '[hidden]',         // Hidden elements
                    '[style*="display:none"]',
                    '[style*="display: none"]',
                    '.hidden',          // Common hidden class
                    'header nav',       // Navigation menus
                    'footer',           // Footer (often has links/legal)
                    'aside.sidebar',    // Sidebars
                    '.advertisement',   // Ads
                    '.ad',
                    '.ads',
                    '[role="banner"]',
                    '[role="navigation"]',
                    '[role="complementary"]'
                ];

                // Remove unwanted elements
                removeSelectors.forEach(selector => {
                    try {
                        doc.querySelectorAll(selector).forEach(el => el.remove());
                    } catch (e) {
                        // Invalid selector, skip
                    }
                });

                // Remove all event handlers (onclick, onload, etc.)
                doc.querySelectorAll('*').forEach(el => {
                    // Remove event attributes
                    Array.from(el.attributes).forEach(attr => {
                        if (attr.name.startsWith('on') ||
                            attr.name === 'style' ||
                            attr.name.startsWith('data-')) {
                            el.removeAttribute(attr.name);
                        }
                    });
                });

                // Try to get main content area first
                const mainContent = doc.querySelector('main, article, [role="main"], .content, .post, .entry, #content, #main');

                if (mainContent) {
                    return mainContent.innerHTML;
                }

                // Fallback to body content
                const body = doc.body;
                if (body) {
                    return body.innerHTML;
                }

                // Last resort: return cleaned full HTML
                return doc.documentElement.innerHTML;
            }

            // Fetch URL content
            async function fetchUrl() {
                const urlInput = document.getElementById('urlInput');
                const fetchBtn = document.getElementById('fetchBtn');
                const url = urlInput.value.trim();

                if (!url) {
                    showToast('Please enter a URL to fetch.');
                    return;
                }

                // Validate URL
                try {
                    new URL(url);
                } catch (e) {
                    showToast('Please enter a valid URL.');
                    return;
                }

                // Show loading state
                fetchBtn.classList.add('fetching');
                fetchBtn.disabled = true;

                try {
                    // Use our own servlet for URL fetching
                    const response = await fetch('UrlFetchFunctionality?url=' + encodeURIComponent(url));

                    if (!response.ok) {
                        throw new Error('Failed to fetch URL');
                    }

                    const data = await response.json();

                    if (data.success && data.contents) {
                        // Sanitize HTML - remove scripts, styles, etc.
                        const cleanHtml = sanitizeHtml(data.contents);

                        document.getElementById('htmlInput').value = cleanHtml;
                        document.getElementById('htmlCharCount').textContent = cleanHtml.length;
                        showToast('URL fetched & cleaned! (' + cleanHtml.length + ' chars)');

                        // Auto-convert after fetch
                        convertToMarkdown();
                    } else {
                        throw new Error(data.error || 'No content received');
                    }
                } catch (error) {
                    console.error('Fetch error:', error);
                    showToast('Error: ' + error.message);
                } finally {
                    // Reset button state
                    fetchBtn.classList.remove('fetching');
                    fetchBtn.disabled = false;
                }
            }

            // Allow Enter key to trigger fetch
            document.getElementById('urlInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    fetchUrl();
                }
            });

            // Auto-convert on option change
            document.querySelectorAll('.option-group select').forEach(select => {
                select.addEventListener('change', () => {
                    if (document.getElementById('htmlInput').value.trim()) {
                        convertToMarkdown();
                    }
                });
            });
        </script>
        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="thanks.jsp" %>

            <hr>

            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="addcomments.jsp" %>
                    </div>
                    <%@ include file="body-close.jsp" %>
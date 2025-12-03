<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Text to Diagram Generator | ASCII Flowchart & Graph-Easy Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free online text-to-diagram converter. Create ASCII flowcharts, architecture diagrams, and graphs from simple text notation. Export to PNG, SVG, PDF. Mermaid & PlantUML alternative. No signup required." />
    <meta name="keywords" content="text to diagram, diagram as code, ascii flowchart generator, graph-easy online, mermaid alternative, plantuml alternative, ascii art diagram, text to flowchart, architecture diagram generator, readme diagram, documentation flowchart, system design diagram, graphviz online, dot to png, unicode box art, free diagram tool" />
    <meta name="robots" content="index,follow" />
    <meta name="author" content="Anish Nath" />
    <link rel="canonical" href="https://8gwifi.org/graph-easy.jsp" />

    <!-- Open Graph for social sharing -->
    <meta property="og:title" content="Text to Diagram Generator | ASCII Flowchart & Graph-Easy Online – Free | 8gwifi.org" />
    <meta property="og:description" content="Free online text-to-diagram converter. Create ASCII flowcharts, architecture diagrams from simple text. Export to PNG, SVG, PDF. Mermaid & PlantUML alternative." />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/graph-easy.jsp" />
    <meta property="og:image" content="https://8gwifi.org/images/graph-easy-og.png" />

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Text to Diagram Generator – ASCII Flowchart Free Online" />
    <meta name="twitter:description" content="Create ASCII flowcharts from text notation. Export to PNG/SVG/PDF. Free Mermaid & PlantUML alternative. No signup required." />
    <meta name="twitter:creator" content="@anish2good" />

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Text to Diagram Generator - Graph-Easy Online",
            "alternateName": ["ASCII Flowchart Generator", "Graph-Easy Online", "Text to Flowchart Converter"],
            "description": "Free online text-to-diagram converter. Create ASCII flowcharts, architecture diagrams from simple text. Export to PNG, SVG, PDF. Mermaid & PlantUML alternative.",
            "url": "https://8gwifi.org/graph-easy.jsp",
            "applicationCategory": "DeveloperApplication",
            "applicationSubCategory": "Diagram Tool",
            "operatingSystem": "Any",
            "browserRequirements": "Requires JavaScript",
            "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
            "author": {"@type": "Person", "name": "Anish Nath", "url": "https://x.com/anish2good"},
            "datePublished": "2024-06-01",
            "dateModified": "2025-12-03",
            "featureList": [
                "Text to ASCII diagram conversion",
                "Export to PNG, SVG, PDF",
                "Unicode box art output",
                "GraphViz DOT export",
                "Live HTML preview",
                "No signup required",
                "Runs entirely in browser"
            ],
            "screenshot": "https://8gwifi.org/images/graph-easy-screenshot.png",
            "softwareHelp": {"@type": "CreativeWork", "url": "https://8gwifi.org/graph-easy.jsp#understanding"},
            "publisher": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
            "aggregateRating": {"@type": "AggregateRating", "ratingValue": "4.7", "ratingCount": "89"}
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "HowTo",
            "name": "How to Create ASCII Diagrams from Text",
            "description": "Step-by-step guide to creating flowcharts and diagrams using Graph-Easy text notation",
            "totalTime": "PT2M",
            "tool": {"@type": "HowToTool", "name": "Graph-Easy Online Tool"},
            "step": [
                {
                    "@type": "HowToStep",
                    "name": "Write your diagram notation",
                    "text": "Enter nodes in brackets like [Start] and connect them with arrows -> for directed edges or <-> for bidirectional",
                    "position": 1
                },
                {
                    "@type": "HowToStep",
                    "name": "Choose output format",
                    "text": "Select ASCII Art for text output, Box Art for Unicode, GraphViz DOT for export, or HTML for web preview",
                    "position": 2
                },
                {
                    "@type": "HowToStep",
                    "name": "Render your diagram",
                    "text": "Click Render Graph or press Ctrl+Enter to generate your diagram instantly",
                    "position": 3
                },
                {
                    "@type": "HowToStep",
                    "name": "Export your diagram",
                    "text": "For GraphViz DOT format, use the PNG, SVG, or PDF export buttons to download your diagram as an image",
                    "position": 4
                }
            ]
        }
    </script>

    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "FAQPage",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "What is Graph-Easy and how does it work?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Graph-Easy is a text-to-diagram tool that converts simple notation into ASCII art flowcharts and graphs. Write [Node A] -> [Node B] and it automatically generates properly formatted diagrams with boxes, arrows, and connections."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Is this a free Mermaid or PlantUML alternative?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Yes! Graph-Easy is a free alternative to Mermaid and PlantUML for creating text-based diagrams. It specializes in ASCII art output that works in terminals, README files, and plain text documentation. It also exports to PNG, SVG, and PDF."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Can I export diagrams to PNG, SVG, or PDF?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Yes! Select 'GraphViz DOT' format, render your diagram, then use the PNG, SVG, or PDF export buttons. The tool uses Viz.js to convert DOT to high-resolution images entirely in your browser."
                    }
                },
                {
                    "@type": "Question",
                    "name": "How do I create architecture or system design diagrams?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Use groups with parentheses like (Frontend) and (Backend) to organize components. Connect services with labeled edges: [API] -> { label: REST; } [Database]. This is perfect for documenting microservices, cloud architecture, and system designs."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Can I use this for README documentation?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Absolutely! ASCII art output is perfect for README files since it displays correctly on GitHub, GitLab, and any plain text viewer. Copy the output directly into your markdown files without needing external image hosting."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Does this tool work offline or require an account?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "No account required! The tool runs entirely in your browser using WebAssembly (Perl compiled to WASM). After the initial load, diagram generation works offline. Your data never leaves your browser."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What's the syntax for edge labels and styling?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Add labels with { label: text; } between nodes: [A] -> { label: yes; } [B]. For styling use { style: dashed; } or { style: bold; }. You can combine multiple attributes in one block."
                    }
                }
            ]
        }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --theme-primary: #059669;
            --theme-secondary: #10b981;
            --theme-gradient: linear-gradient(135deg, #059669 0%, #10b981 100%);
            --theme-light: #ecfdf5;
        }
        .tool-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(5, 150, 105, 0.15);
            transition: box-shadow 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 4px 20px rgba(5, 150, 105, 0.25);
        }
        .card-header-custom {
            background: var(--theme-gradient);
            color: white;
            border-radius: 12px 12px 0 0 !important;
            padding: 0.75rem 1rem;
        }
        .card-header-custom h5 {
            margin: 0;
            font-weight: 600;
            font-size: 1rem;
        }
        .form-section {
            background: var(--theme-light);
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
        }
        .form-section-title {
            font-weight: 600;
            color: var(--theme-primary);
            margin-bottom: 0.5rem;
            font-size: 0.85rem;
        }
        .result-card {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            min-height: 200px;
        }
        .result-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            min-height: 150px;
        }
        .result-content {
            display: none;
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
            display: inline-block;
            background: var(--theme-light);
            color: var(--theme-primary);
            padding: 0.2rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            margin-right: 0.25rem;
        }
        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.75rem;
        }
        .related-tool-card {
            display: block;
            padding: 0.75rem;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            text-decoration: none;
            color: inherit;
            transition: all 0.2s;
        }
        .related-tool-card:hover {
            border-color: var(--theme-primary);
            background: var(--theme-light);
            text-decoration: none;
        }
        .related-tool-card h6 {
            margin: 0 0 0.25rem 0;
            color: var(--theme-primary);
            font-size: 0.9rem;
        }
        .related-tool-card p {
            margin: 0;
            font-size: 0.75rem;
            color: #6c757d;
        }
        #graphInput {
            font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
            font-size: 13px;
            background: #fafafa;
            height: 200px;
        }
        #graphOutput {
            font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
            font-size: 13px;
            background: #1e1e1e;
            color: #00ff00;
            height: 300px;
        }
        .example-btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            background: #e9ecef;
            border: 1px solid #dee2e6;
            color: #333;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .example-btn:hover {
            background: var(--theme-light);
            border-color: var(--theme-primary);
        }
        .status-box {
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            font-size: 0.85rem;
        }
        .status-loading {
            background: #fff3cd;
            color: #856404;
        }
        .status-ready {
            background: #d4edda;
            color: #155724;
        }
        .status-error {
            background: #f8d7da;
            color: #721c24;
        }
        .loader {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid #f3f3f3;
            border-top: 2px solid var(--theme-primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            vertical-align: middle;
            margin-right: 6px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .progress-bar-custom {
            width: 100%;
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin-top: 6px;
            overflow: hidden;
        }
        .progress-bar-fill {
            height: 100%;
            background: var(--theme-gradient);
            border-radius: 2px;
            transition: width 0.3s ease;
            width: 0%;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<%--<%@ include file="navigation.jsp"%>--%>
<%@ include file="devops-tools-navbar.jsp"%>
<%@ include file="footer_adsense.jsp"%>

<div class="container-fluid py-3" style="max-width: 1400px;">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="h4 mb-0">Graph-Easy ASCII Diagram Generator</h1>
            <div class="mt-1">
                <span class="info-badge"><i class="fas fa-project-diagram"></i> Flowcharts</span>
                <span class="info-badge"><i class="fas fa-code"></i> ASCII Art</span>
                <span class="info-badge"><i class="fas fa-globe"></i> Browser-Based</span>
            </div>
        </div>
        <div class="eeat-badge">
            <i class="fas fa-user-check"></i>
            <span>Anish Nath</span>
        </div>
    </div>

    <!-- Status Bar -->
    <div id="statusBox" class="status-box status-loading mb-3">
        <span class="loader"></span>
        <span id="statusText">Loading Perl runtime (~4MB compressed)...</span>
        <div class="progress-bar-custom"><div id="progressFill" class="progress-bar-fill"></div></div>
    </div>

    <div class="row">
        <!-- Left Column - Input -->
        <div class="col-lg-5 mb-3">
            <div class="card tool-card">
                <div class="card-header card-header-custom">
                    <h5><i class="fas fa-edit me-2"></i>Graph Notation Input</h5>
                </div>
                <div class="card-body">
                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-pencil-alt me-1"></i>Enter Graph-Easy Notation</div>
                        <textarea class="form-control" id="graphInput" placeholder="Enter graph notation...
Example: [A] -> [B] -> [C]">[ Start ] -> [ Process ] -> [ End ]
[ Process ] -> { style: dashed; } [ Error ]
[ Error ] -> [ Start ]</textarea>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title"><i class="fas fa-cog me-1"></i>Output Format</div>
                        <select class="form-control" id="formatSelect">
                            <option value="ascii">ASCII Art</option>
                            <option value="boxart">Box Art (Unicode)</option>
                            <option value="html">HTML</option>
                            <option value="graphviz">GraphViz DOT</option>
                            <option value="txt">Text (re-parseable)</option>
                        </select>
                    </div>

                    <button class="btn btn-block text-white" id="renderBtn" disabled style="background: var(--theme-gradient);">
                        <i class="fas fa-play me-1"></i> Render Graph
                    </button>

                    <div class="mt-3">
                        <small class="text-muted d-block mb-2"><strong>Examples:</strong></small>
                        <div class="d-flex flex-wrap gap-1">
                            <button class="example-btn" data-example="simple">Simple</button>
                            <button class="example-btn" data-example="flow">Flowchart</button>
                            <button class="example-btn" data-example="cities">Cities</button>
                            <button class="example-btn" data-example="bidi">Bidirectional</button>
                            <button class="example-btn" data-example="labels">Edge Labels</button>
                            <button class="example-btn" data-example="groups">Groups</button>
                            <button class="example-btn" data-example="selfloop">Self Loop</button>
                            <button class="example-btn" data-example="git">Git Flow</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column - Output -->
        <div class="col-lg-7 mb-3">
            <div class="card tool-card">
                <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-image me-2"></i>Rendered Output</h5>
                    <div class="d-flex gap-1">
                        <!-- DOT Export buttons (hidden by default) -->
                        <div id="dotExportBtns" style="display: none;">
                            <button class="btn btn-sm btn-warning" id="exportPngBtn" title="Export as PNG">
                                <i class="fas fa-file-image"></i> PNG
                            </button>
                            <button class="btn btn-sm btn-info" id="exportSvgBtn" title="Export as SVG">
                                <i class="fas fa-vector-square"></i> SVG
                            </button>
                            <button class="btn btn-sm btn-danger" id="exportPdfBtn" title="Export as PDF">
                                <i class="fas fa-file-pdf"></i> PDF
                            </button>
                        </div>
                        <button class="btn btn-sm btn-light" id="copyBtn" disabled>
                            <i class="fas fa-copy"></i> Copy
                        </button>
                        <button class="btn btn-sm btn-success" id="shareBtn" title="Share this tool">
                            <i class="fas fa-share-alt"></i>
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <!-- Text output (ASCII, BoxArt, DOT, TXT) -->
                    <textarea class="form-control" id="graphOutput" readonly placeholder="Rendered graph will appear here..."></textarea>

                    <!-- HTML Preview (hidden by default) -->
                    <div id="htmlPreviewContainer" style="display: none;">
                        <div class="mb-2">
                            <button class="btn btn-sm btn-outline-secondary" id="toggleHtmlSource">
                                <i class="fas fa-code"></i> View Source
                            </button>
                        </div>
                        <div id="htmlPreview" class="border rounded p-3 bg-white" style="min-height: 300px; overflow: auto;"></div>
                    </div>

                    <!-- SVG Preview for DOT export (hidden) -->
                    <div id="svgPreviewContainer" style="display: none;">
                        <div id="svgPreview" class="border rounded p-3 bg-white mt-2" style="min-height: 200px; overflow: auto;"></div>
                    </div>
                </div>
            </div>

            <!-- Syntax Reference -->
            <div class="card tool-card mt-3">
                <div class="card-header bg-dark text-white py-2">
                    <h6 class="mb-0"><i class="fas fa-book me-2"></i>Quick Syntax Reference</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-sm table-bordered mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>Syntax</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                            </thead>
                            <tbody class="small">
                            <tr>
                                <td><code>[ Node ]</code></td>
                                <td>Create a node</td>
                                <td><code>[ Server ]</code></td>
                            </tr>
                            <tr>
                                <td><code>-></code></td>
                                <td>Directed edge</td>
                                <td><code>[ A ] -> [ B ]</code></td>
                            </tr>
                            <tr>
                                <td><code><-></code></td>
                                <td>Bidirectional edge</td>
                                <td><code>[ A ] <-> [ B ]</code></td>
                            </tr>
                            <tr>
                                <td><code>--</code></td>
                                <td>Undirected edge</td>
                                <td><code>[ A ] -- [ B ]</code></td>
                            </tr>
                            <tr>
                                <td><code>{ label: text; }</code></td>
                                <td>Edge label</td>
                                <td><code>-> { label: yes; }</code></td>
                            </tr>
                            <tr>
                                <td><code>( Group )</code></td>
                                <td>Node group</td>
                                <td><code>( Frontend )</code></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Related Tools -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light py-2">
            <h6 class="mb-0"><i class="fas fa-tools me-2"></i>Related Tools</h6>
        </div>
        <div class="card-body">
            <div class="related-tools">
                <a href="asn1.jsp" class="related-tool-card">
                    <h6><i class="fas fa-stream me-1"></i>ASN.1 Decoder</h6>
                    <p>Parse and visualize ASN.1 structures</p>
                </a>
                <a href="base64.jsp" class="related-tool-card">
                    <h6><i class="fas fa-exchange-alt me-1"></i>Base64 Encoder</h6>
                    <p>Encode and decode Base64 data</p>
                </a>
                <a href="regex.jsp" class="related-tool-card">
                    <h6><i class="fas fa-code me-1"></i>Regex Tester</h6>
                    <p>Test regular expressions online</p>
                </a>
                <a href="jsonformatter.jsp" class="related-tool-card">
                    <h6><i class="fas fa-indent me-1"></i>JSON Formatter</h6>
                    <p>Format and validate JSON data</p>
                </a>
            </div>
        </div>
    </div>

    <%@ include file="thanks.jsp"%>

    <!-- Educational Content -->
    <div class="card tool-card mb-4">
        <div class="card-header bg-light">
            <h5 class="mb-0"><i class="fas fa-graduation-cap me-2"></i>Understanding Graph-Easy</h5>
        </div>
        <div class="card-body">
            <h6>What is Graph-Easy?</h6>
            <p>Graph-Easy is a Perl library that converts simple text notation into beautiful ASCII art diagrams. Originally created by Tels, it's widely used for documenting software architecture, creating flowcharts in documentation, and generating diagrams that can be embedded in plain text files like README files.</p>

            <h6 class="mt-4">Output Formats</h6>
            <div class="row">
                <div class="col-md-3 mb-3">
                    <div class="p-3 rounded h-100" style="background: #d4edda; border: 2px solid #28a745;">
                        <h6 class="text-center" style="color: #155724;"><strong>ASCII Art</strong></h6>
                        <p class="small mb-0">Classic text-based diagrams using +, -, |, and other ASCII characters. Works everywhere.</p>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="p-3 rounded h-100" style="background: #d1ecf1; border: 2px solid #17a2b8;">
                        <h6 class="text-center" style="color: #0c5460;"><strong>Box Art</strong></h6>
                        <p class="small mb-0">Uses Unicode box-drawing characters for cleaner, professional-looking diagrams.</p>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="p-3 rounded h-100" style="background: #fff3cd; border: 2px solid #ffc107;">
                        <h6 class="text-center" style="color: #856404;"><strong>GraphViz DOT</strong> <span class="badge bg-warning text-dark" style="font-size: 0.6rem;">Export</span></h6>
                        <p class="small mb-0">DOT format with <strong>PNG/SVG/PDF export</strong> via Viz.js rendering.</p>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="p-3 rounded h-100" style="background: #e2e3ff; border: 2px solid #6366f1;">
                        <h6 class="text-center" style="color: #4338ca;"><strong>HTML</strong> <span class="badge bg-primary" style="font-size: 0.6rem;">Preview</span></h6>
                        <p class="small mb-0">HTML table output with <strong>live preview</strong>. Toggle to view source code.</p>
                    </div>
                </div>
            </div>

            <h6 class="mt-4">Common Use Cases</h6>
            <ul class="small">
                <li><strong>Documentation:</strong> Create architecture diagrams that live alongside your code</li>
                <li><strong>README files:</strong> Add visual flowcharts to project documentation</li>
                <li><strong>System design:</strong> Quickly sketch component relationships</li>
                <li><strong>Process flows:</strong> Document workflows and decision trees</li>
                <li><strong>Git workflows:</strong> Visualize branching strategies</li>
            </ul>

            <h6 class="mt-4">Syntax Examples</h6>
            <div class="row">
                <div class="col-md-6">
                    <p class="small mb-1"><strong>Simple Chain</strong></p>
                    <pre class="bg-dark text-light p-2 rounded small"><code>[ Input ] -> [ Process ] -> [ Output ]</code></pre>
                </div>
                <div class="col-md-6">
                    <p class="small mb-1"><strong>With Labels</strong></p>
                    <pre class="bg-dark text-light p-2 rounded small"><code>[ Decision ] -> { label: yes; } [ Success ]
[ Decision ] -> { label: no; } [ Retry ]</code></pre>
                </div>
            </div>
            <div class="row mt-2">
                <div class="col-md-6">
                    <p class="small mb-1"><strong>Bidirectional</strong></p>
                    <pre class="bg-dark text-light p-2 rounded small"><code>[ Client ] <-> [ Server ]
[ Server ] <-> [ Database ]</code></pre>
                </div>
                <div class="col-md-6">
                    <p class="small mb-1"><strong>Groups</strong></p>
                    <pre class="bg-dark text-light p-2 rounded small"><code>( Backend )
[ API ] -> [ Service ] -> [ DB ]</code></pre>
                </div>
            </div>

            <h6 class="mt-4">Graph-Easy vs Other Diagram Tools</h6>
            <div class="table-responsive">
                <table class="table table-sm table-bordered">
                    <thead class="table-light">
                    <tr>
                        <th>Feature</th>
                        <th style="background: var(--theme-light);"><strong>Graph-Easy</strong></th>
                        <th>Mermaid</th>
                        <th>PlantUML</th>
                        <th>ASCII Flow</th>
                    </tr>
                    </thead>
                    <tbody class="small">
                    <tr>
                        <td>ASCII Art Output</td>
                        <td class="table-success"><i class="fas fa-check text-success"></i> <strong>Native</strong></td>
                        <td><i class="fas fa-times text-danger"></i> No</td>
                        <td><i class="fas fa-check text-warning"></i> Limited</td>
                        <td><i class="fas fa-check text-success"></i> Yes</td>
                    </tr>
                    <tr>
                        <td>PNG/SVG Export</td>
                        <td class="table-success"><i class="fas fa-check text-success"></i> Yes</td>
                        <td><i class="fas fa-check text-success"></i> Yes</td>
                        <td><i class="fas fa-check text-success"></i> Yes</td>
                        <td><i class="fas fa-times text-danger"></i> No</td>
                    </tr>
                    <tr>
                        <td>README Compatible</td>
                        <td class="table-success"><i class="fas fa-check text-success"></i> <strong>Perfect</strong></td>
                        <td><i class="fas fa-check text-warning"></i> Needs render</td>
                        <td><i class="fas fa-check text-warning"></i> Needs render</td>
                        <td><i class="fas fa-check text-success"></i> Yes</td>
                    </tr>
                    <tr>
                        <td>No Server Required</td>
                        <td class="table-success"><i class="fas fa-check text-success"></i> Browser only</td>
                        <td><i class="fas fa-check text-success"></i> Yes</td>
                        <td><i class="fas fa-times text-danger"></i> Needs Java</td>
                        <td><i class="fas fa-check text-success"></i> Yes</td>
                    </tr>
                    <tr>
                        <td>Learning Curve</td>
                        <td class="table-success"><strong>Easy</strong></td>
                        <td>Medium</td>
                        <td>Medium</td>
                        <td>Visual/Easy</td>
                    </tr>
                    <tr>
                        <td>Best For</td>
                        <td class="table-success"><strong>Docs, README, Terminal</strong></td>
                        <td>Web docs, Markdown</td>
                        <td>UML, Complex diagrams</td>
                        <td>Quick sketches</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <h6 class="mt-4">Who Uses This Tool?</h6>
            <div class="row">
                <div class="col-md-3 col-6 mb-2">
                    <div class="text-center p-2 rounded" style="background: var(--theme-light);">
                        <i class="fas fa-code fa-2x mb-1" style="color: var(--theme-primary);"></i>
                        <p class="small mb-0"><strong>Developers</strong></p>
                        <p class="small text-muted mb-0">README diagrams</p>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-2">
                    <div class="text-center p-2 rounded" style="background: var(--theme-light);">
                        <i class="fas fa-server fa-2x mb-1" style="color: var(--theme-primary);"></i>
                        <p class="small mb-0"><strong>DevOps/SRE</strong></p>
                        <p class="small text-muted mb-0">Architecture docs</p>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-2">
                    <div class="text-center p-2 rounded" style="background: var(--theme-light);">
                        <i class="fas fa-book fa-2x mb-1" style="color: var(--theme-primary);"></i>
                        <p class="small mb-0"><strong>Tech Writers</strong></p>
                        <p class="small text-muted mb-0">Documentation</p>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-2">
                    <div class="text-center p-2 rounded" style="background: var(--theme-light);">
                        <i class="fas fa-graduation-cap fa-2x mb-1" style="color: var(--theme-primary);"></i>
                        <p class="small mb-0"><strong>Students</strong></p>
                        <p class="small text-muted mb-0">Flowcharts</p>
                    </div>
                </div>
            </div>

            <div class="alert alert-info mt-4 small">
                <strong><i class="fas fa-info-circle"></i> Tips:</strong>
                <ul class="mb-0 mt-1">
                    <li>Press <kbd>Ctrl</kbd>+<kbd>Enter</kbd> (or <kbd>Cmd</kbd>+<kbd>Enter</kbd> on Mac) to quickly render your graph.</li>
                    <li>Select <strong>GraphViz DOT</strong> format to export your diagram as PNG, SVG, or PDF.</li>
                    <li>Select <strong>HTML</strong> format to see a live preview - toggle between preview and source code.</li>
                </ul>
            </div>
        </div>
    </div>

    <%@ include file="addcomments.jsp"%>

    <!-- Export Modal -->
    <div class="modal fade" id="exportModal" tabindex="-1" role="dialog" aria-labelledby="exportModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                    <h5 class="modal-title" id="exportModalLabel">
                        <i class="fas fa-download me-2"></i>Export Graph
                    </h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="exportFilename" class="form-label"><strong>Filename</strong></label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="exportFilename" value="8gwifi-graph-data">
                            <span class="input-group-text" id="exportExtension">.png</span>
                        </div>
                        <small class="text-muted">File will be saved as: <span id="fullFilename">8gwifi-graph-data.png</span></small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><strong>Preview</strong></label>
                        <div id="exportPreview" class="border rounded p-3 bg-light text-center" style="min-height: 200px; max-height: 400px; overflow: auto;">
                            <!-- Preview will be inserted here -->
                        </div>
                    </div>

                    <div class="alert alert-info small mb-3">
                        <i class="fas fa-info-circle me-1"></i>
                        <span id="exportInfo">Your graph will be exported as a high-resolution image.</span>
                    </div>

                    <!-- Twitter Support Section -->
                    <div class="border rounded p-3 text-center" style="background: linear-gradient(135deg, #e8f5fd 0%, #f0f9ff 100%);">
                        <p class="mb-2 small"><strong>Enjoying this free tool?</strong> Show your support!</p>
                        <div class="d-flex justify-content-center gap-2 flex-wrap">
                            <a href="https://twitter.com/anish2good" target="_blank" class="btn btn-sm text-white" style="background: #1DA1F2;">
                                <i class="fab fa-twitter me-1"></i>Follow @anish2good
                            </a>
                            <a href="https://twitter.com/intent/tweet?text=Just%20created%20an%20awesome%20ASCII%20diagram%20using%20Graph-Easy%20tool%20by%20%40anish2good%20%F0%9F%9A%80%0A%0ACreate%20flowcharts%2C%20export%20to%20PNG%2FSVG%2FPDF%20-%20all%20in%20your%20browser!%0A%0Ahttps%3A%2F%2F8gwifi.org%2Fgraph-easy.jsp&hashtags=ASCII,DevTools,Diagrams" target="_blank" class="btn btn-sm btn-outline-primary" style="border-color: #1DA1F2; color: #1DA1F2;">
                                <i class="fab fa-twitter me-1"></i>Tweet for Support
                            </a>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn text-white" id="confirmExportBtn" style="background: var(--theme-gradient);">
                        <i class="fas fa-download me-1"></i>Download
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Share Modal -->
    <div class="modal fade" id="shareModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header" style="background: var(--theme-gradient); color: white;">
                    <h5 class="modal-title"><i class="fas fa-share-alt me-2"></i>Share This Tool</h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <div class="mb-3">
                            <i class="fas fa-project-diagram fa-3x" style="color: var(--theme-primary);"></i>
                        </div>
                        <h5>Graph-Easy ASCII Diagram Generator</h5>
                        <p class="text-muted small">Free online text-to-diagram converter for flowcharts and architecture diagrams</p>
                    </div>

                    <!-- Share URL -->
                    <div class="mb-4">
                        <label class="form-label small"><strong>Share URL</strong></label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="shareUrl" value="https://8gwifi.org/graph-easy.jsp" readonly>
                            <button class="btn btn-outline-secondary" type="button" id="copyShareUrl">
                                <i class="fas fa-copy"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Twitter Section -->
                    <div class="border rounded p-3 text-center" style="background: linear-gradient(135deg, #e8f5fd 0%, #f0f9ff 100%);">
                        <p class="mb-3"><strong><i class="fab fa-twitter me-1" style="color: #1DA1F2;"></i>Support on Twitter</strong></p>
                        <div class="d-flex justify-content-center gap-2 flex-wrap">
                            <a href="https://twitter.com/anish2good" target="_blank" class="btn btn-sm text-white" style="background: #1DA1F2;">
                                <i class="fab fa-twitter me-1"></i>Follow @anish2good
                            </a>
                            <a href="https://twitter.com/intent/tweet?text=Just%20created%20an%20awesome%20ASCII%20diagram%20using%20Graph-Easy%20tool%20by%20%40anish2good%20%F0%9F%9A%80%0A%0ACreate%20flowcharts%2C%20export%20to%20PNG%2FSVG%2FPDF%20-%20all%20in%20your%20browser!%0A%0Ahttps%3A%2F%2F8gwifi.org%2Fgraph-easy.jsp&hashtags=ASCII,DevTools,Diagrams,Documentation" target="_blank" class="btn btn-sm btn-outline-primary" style="border-color: #1DA1F2; color: #1DA1F2;">
                                <i class="fab fa-twitter me-1"></i>Tweet This Tool
                            </a>
                        </div>
                        <p class="mt-3 mb-0 small text-muted">Your support helps keep this tool free!</p>
                    </div>

                    <!-- Other Share Options -->
                    <div class="mt-4">
                        <p class="small text-muted mb-2"><strong>More ways to share:</strong></p>
                        <div class="d-flex justify-content-center gap-2">
                            <a href="https://www.linkedin.com/sharing/share-offsite/?url=https://8gwifi.org/graph-easy.jsp" target="_blank" class="btn btn-sm" style="background: #0077b5; color: white;" title="Share on LinkedIn">
                                <i class="fab fa-linkedin"></i>
                            </a>
                            <a href="https://www.reddit.com/submit?url=https://8gwifi.org/graph-easy.jsp&title=Free%20ASCII%20Diagram%20Generator%20-%20Text%20to%20Flowchart" target="_blank" class="btn btn-sm" style="background: #ff4500; color: white;" title="Share on Reddit">
                                <i class="fab fa-reddit"></i>
                            </a>
                            <a href="https://news.ycombinator.com/submitlink?u=https://8gwifi.org/graph-easy.jsp&t=Graph-Easy%20Online%20-%20Free%20ASCII%20Diagram%20Generator" target="_blank" class="btn btn-sm" style="background: #ff6600; color: white;" title="Share on Hacker News">
                                <i class="fab fa-hacker-news"></i>
                            </a>
                            <a href="mailto:?subject=Free%20ASCII%20Diagram%20Generator&body=Check%20out%20this%20free%20tool%20to%20create%20ASCII%20flowcharts%20and%20diagrams%3A%0A%0Ahttps%3A%2F%2F8gwifi.org%2Fgraph-easy.jsp" class="btn btn-sm btn-secondary" title="Share via Email">
                                <i class="fas fa-envelope"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Load Graph-Easy modules bundle -->
<script src="graph-easy/graph-easy-modules.js?v=<%= System.currentTimeMillis() %>"></script>

<!-- Setup script -->
<script>
    // Example graphs
    const examples = {
        simple: '[ A ] -> [ B ] -> [ C ]',

        flow: `[ Start ] -> [ Input ]
[ Input ] -> [ Process ]
[ Process ] -> [ Decision ]
[ Decision ] -> { label: yes; } [ Output ]
[ Decision ] -> { label: no; } [ Process ]
[ Output ] -> [ End ]`,

        cities: `[ Bonn ] -> [ Berlin ]
[ Berlin ] -> [ Frankfurt ]
[ Frankfurt ] -> [ Dresden ]
[ Berlin ] -> [ Potsdam ]
[ Potsdam ] -> [ Cottbus ]
[ Cottbus ] -> [ Frankfurt ]`,

        bidi: `[ Client ] <-> [ Server ]
[ Server ] <-> [ Database ]
[ Client ] <-> [ Cache ]
[ Cache ] -> [ Database ]`,

        labels: `[ Alice ] -- sends request --> [ Server ]
[ Server ] -- queries --> [ Database ]
[ Database ] -- returns data --> [ Server ]
[ Server ] -- sends response --> [ Alice ]`,

        groups: `( Frontend )
[ React ] -> [ Redux ]
[ Redux ] -> [ API Client ]

( Backend )
[ Express ] -> [ MongoDB ]

[ API Client ] -> [ Express ]`,

        selfloop: `[ Retry ] -> [ Retry ]
[ Start ] -> [ Retry ]
[ Retry ] -> [ Success ]
[ Retry ] -> [ Failure ]`,

        git: `[ main ] -> [ feature ]
[ feature ] -> [ commit 1 ]
[ commit 1 ] -> [ commit 2 ]
[ commit 2 ] -> [ merge ]
[ main ] -> [ hotfix ]
[ hotfix ] -> [ merge ]
[ merge ] -> [ main ]`
    };

    // DOM elements
    const inputEl = document.getElementById('graphInput');
    const outputEl = document.getElementById('graphOutput');
    const statusBox = document.getElementById('statusBox');
    const statusText = document.getElementById('statusText');
    const progressFill = document.getElementById('progressFill');
    const renderBtn = document.getElementById('renderBtn');
    const copyBtn = document.getElementById('copyBtn');
    const formatSelect = document.getElementById('formatSelect');
    const htmlPreviewContainer = document.getElementById('htmlPreviewContainer');
    const htmlPreview = document.getElementById('htmlPreview');
    const toggleHtmlSourceBtn = document.getElementById('toggleHtmlSource');
    const dotExportBtns = document.getElementById('dotExportBtns');
    const svgPreviewContainer = document.getElementById('svgPreviewContainer');
    const svgPreview = document.getElementById('svgPreview');

    // State
    let perlReady = false;
    let vizLoaded = false;
    let vizInstance = null;
    let currentDotSource = '';
    let showingHtmlSource = false;

    // Toast notification
    function showToast(message) {
        var toast = $('<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">' +
            '<div class="toast show"><div class="toast-body text-white rounded" style="background: var(--theme-gradient);">' +
            '<i class="fas fa-info-circle me-2"></i>' + message + '</div></div></div>');
        $('body').append(toast);
        setTimeout(function() { toast.fadeOut(function() { toast.remove(); }); }, 2000);
    }

    // Update status
    function setStatus(message, type, progress) {
        statusBox.className = 'status-box mb-3 status-' + type;
        if (type === 'loading') {
            statusText.textContent = message;
            if (progress !== undefined) {
                progressFill.style.width = progress + '%';
            }
            statusBox.innerHTML = '<span class="loader"></span><span id="statusText">' + message + '</span>' +
                '<div class="progress-bar-custom"><div id="progressFill" class="progress-bar-fill" style="width:' + (progress || 0) + '%"></div></div>';
        } else {
            statusBox.innerHTML = '<i class="fas fa-' + (type === 'ready' ? 'check-circle' : 'exclamation-circle') + ' me-2"></i>' + message;
        }
    }

    // Load modules into virtual filesystem
    function loadModulesToFS() {
        if (typeof FS === 'undefined') {
            console.error('FS not available yet');
            return false;
        }

        console.log('Loading Graph-Easy modules into virtual filesystem...');

        try { FS.mkdir('/lib'); } catch (e) {}

        const dirs = new Set();
        for (const modulePath of Object.keys(window.GraphEasyModules)) {
            const dir = modulePath.substring(0, modulePath.lastIndexOf('/'));
            if (dir) {
                let current = '';
                for (const part of dir.split('/')) {
                    current = current ? current + '/' + part : part;
                    dirs.add(current);
                }
            }
        }

        for (const dir of Array.from(dirs).sort()) {
            try { FS.mkdir('/lib/' + dir); } catch (e) {}
        }

        for (const [modulePath, content] of Object.entries(window.GraphEasyModules)) {
            try {
                FS.writeFile('/lib/' + modulePath, content);
            } catch (e) {
                console.error('Failed to write:', modulePath, e);
            }
        }

        console.log('Graph-Easy modules loaded!');
        return true;
    }

    // JavaScript function called by Perl when ready
    window.graphEasyReady = function() {
        perlReady = true;
        setStatus('Ready! Enter graph notation and click "Render Graph".', 'ready');
        renderBtn.disabled = false;
        copyBtn.disabled = false;
    };

    // JavaScript function to render graph (calls Perl)
    window.renderGraphResult = function(output, error) {
        const format = formatSelect.value;

        // Reset all views
        outputEl.style.display = 'block';
        htmlPreviewContainer.style.display = 'none';
        dotExportBtns.style.display = 'none';
        svgPreviewContainer.style.display = 'none';
        showingHtmlSource = false;
        toggleHtmlSourceBtn.innerHTML = '<i class="fas fa-code"></i> View Source';

        if (error) {
            outputEl.value = 'Error: ' + error;
            setStatus('Error: ' + error.split('\n')[0], 'error');
            showToast('Rendering failed');
        } else {
            outputEl.value = output;

            // Handle HTML format - show live preview
            if (format === 'html') {
                outputEl.style.display = 'none';
                htmlPreviewContainer.style.display = 'block';
                htmlPreview.innerHTML = output;
                setStatus('HTML rendered! Click "View Source" to see the code.', 'ready');
            }
            // Handle GraphViz DOT format - enable export buttons
            else if (format === 'graphviz') {
                currentDotSource = output;
                dotExportBtns.style.display = 'inline-block';
                renderDotPreview(output);
                setStatus('DOT generated! Use export buttons for PNG/SVG/PDF.', 'ready');
            }
            else {
                setStatus('Rendered successfully!', 'ready');
            }
            showToast('Graph rendered!');
        }
    };

    // Toggle HTML source view
    toggleHtmlSourceBtn.addEventListener('click', function() {
        showingHtmlSource = !showingHtmlSource;
        if (showingHtmlSource) {
            outputEl.style.display = 'block';
            htmlPreview.style.display = 'none';
            toggleHtmlSourceBtn.innerHTML = '<i class="fas fa-eye"></i> View Preview';
        } else {
            outputEl.style.display = 'none';
            htmlPreview.style.display = 'block';
            toggleHtmlSourceBtn.innerHTML = '<i class="fas fa-code"></i> View Source';
        }
    });

    // Load Viz.js for DOT rendering
    function loadVizJs(callback) {
        if (vizLoaded && vizInstance) {
            callback();
            return;
        }
        const script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/npm/@viz-js/viz@3.2.4/lib/viz-standalone.js';
        script.onload = function() {
            Viz.instance().then(function(viz) {
                vizInstance = viz;
                vizLoaded = true;
                callback();
            });
        };
        script.onerror = function() {
            showToast('Failed to load Viz.js for export');
        };
        document.head.appendChild(script);
    }

    // Render DOT preview as SVG
    function renderDotPreview(dotSource) {
        loadVizJs(function() {
            try {
                const svg = vizInstance.renderSVGElement(dotSource);
                svgPreview.innerHTML = '';
                svgPreview.appendChild(svg);
                svgPreviewContainer.style.display = 'block';
            } catch (e) {
                console.error('DOT render error:', e);
                svgPreviewContainer.style.display = 'none';
            }
        });
    }

    // Export modal elements
    let currentExportType = 'png';
    const exportModal = $('#exportModal');
    const exportFilenameInput = document.getElementById('exportFilename');
    const exportExtension = document.getElementById('exportExtension');
    const fullFilenameSpan = document.getElementById('fullFilename');
    const exportPreviewDiv = document.getElementById('exportPreview');
    const exportInfoSpan = document.getElementById('exportInfo');

    // Update filename preview
    exportFilenameInput.addEventListener('input', function() {
        fullFilenameSpan.textContent = this.value + exportExtension.textContent;
    });

    // Show export modal
    function showExportModal(type) {
        if (!currentDotSource) {
            showToast('No DOT source to export');
            return;
        }

        currentExportType = type;
        const ext = '.' + type;
        exportExtension.textContent = ext;
        fullFilenameSpan.textContent = exportFilenameInput.value + ext;

        // Set info text based on type
        const infoTexts = {
            'png': 'Your graph will be exported as a high-resolution PNG image (2x scale for clarity).',
            'svg': 'Your graph will be exported as a scalable SVG vector graphic.',
            'pdf': 'Your graph will be exported as a PDF document.'
        };
        exportInfoSpan.textContent = infoTexts[type] || '';

        // Load preview
        loadVizJs(function() {
            try {
                const svg = vizInstance.renderSVGElement(currentDotSource);
                exportPreviewDiv.innerHTML = '';
                exportPreviewDiv.appendChild(svg.cloneNode(true));
            } catch (e) {
                exportPreviewDiv.innerHTML = '<p class="text-danger">Preview failed: ' + e.message + '</p>';
            }
        });

        exportModal.modal('show');
    }

    // Export button click handlers - show modal
    document.getElementById('exportPngBtn').addEventListener('click', function() {
        showExportModal('png');
    });

    document.getElementById('exportSvgBtn').addEventListener('click', function() {
        showExportModal('svg');
    });

    document.getElementById('exportPdfBtn').addEventListener('click', function() {
        showExportModal('pdf');
    });

    // Confirm export button
    document.getElementById('confirmExportBtn').addEventListener('click', function() {
        const filename = exportFilenameInput.value || '8gwifi-graph-data';
        const fullFilename = filename + '.' + currentExportType;

        loadVizJs(function() {
            try {
                const svg = vizInstance.renderSVGElement(currentDotSource);
                const svgData = new XMLSerializer().serializeToString(svg);

                if (currentExportType === 'svg') {
                    const blob = new Blob([svgData], { type: 'image/svg+xml' });
                    downloadBlob(blob, fullFilename);
                    exportModal.modal('hide');
                    showToast('SVG downloaded!');
                }
                else if (currentExportType === 'png') {
                    const canvas = document.createElement('canvas');
                    const ctx = canvas.getContext('2d');
                    const img = new Image();

                    img.onload = function() {
                        canvas.width = img.width * 2;
                        canvas.height = img.height * 2;
                        ctx.fillStyle = 'white';
                        ctx.fillRect(0, 0, canvas.width, canvas.height);
                        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                        canvas.toBlob(function(blob) {
                            downloadBlob(blob, fullFilename);
                            exportModal.modal('hide');
                            showToast('PNG downloaded!');
                        }, 'image/png');
                    };
                    img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
                }
                else if (currentExportType === 'pdf') {
                    // Load jsPDF if not already loaded
                    if (typeof window.jspdf === 'undefined') {
                        const script = document.createElement('script');
                        script.src = 'https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js';
                        script.onload = function() {
                            exportToPdf(svgData, fullFilename);
                        };
                        document.head.appendChild(script);
                    } else {
                        exportToPdf(svgData, fullFilename);
                    }
                }
            } catch (e) {
                showToast('Export failed: ' + e.message);
            }
        });
    });

    function exportToPdf(svgData, filename) {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        const img = new Image();

        img.onload = function() {
            canvas.width = img.width * 2;
            canvas.height = img.height * 2;
            ctx.fillStyle = 'white';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

            const imgData = canvas.toDataURL('image/png');
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF({
                orientation: canvas.width > canvas.height ? 'landscape' : 'portrait',
                unit: 'px',
                format: [canvas.width, canvas.height]
            });
            pdf.addImage(imgData, 'PNG', 0, 0, canvas.width, canvas.height);
            pdf.save(filename);
            exportModal.modal('hide');
            showToast('PDF downloaded!');
        };
        img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
    }

    // Helper to download blob
    function downloadBlob(blob, filename) {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    // Render function
    function renderGraph() {
        if (!perlReady) {
            showToast('Perl runtime not ready yet');
            return;
        }

        const input = inputEl.value;
        const format = formatSelect.value;

        setStatus('Rendering...', 'loading', 90);
        outputEl.value = '';

        window.graphInput = input;
        window.graphFormat = format;

        if (window.doRender) {
            window.doRender();
        }
    }

    // Copy to clipboard
    function copyOutput() {
        outputEl.select();
        document.execCommand('copy');
        showToast('Copied to clipboard!');
    }

    // Load example
    function loadExample(name) {
        if (examples[name]) {
            inputEl.value = examples[name];
            showToast('Example loaded: ' + name);
        }
    }

    // Event listeners
    renderBtn.addEventListener('click', renderGraph);
    copyBtn.addEventListener('click', copyOutput);

    document.querySelectorAll('.example-btn').forEach(btn => {
        btn.addEventListener('click', () => loadExample(btn.dataset.example));
    });

    inputEl.addEventListener('keydown', (e) => {
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            e.preventDefault();
            renderGraph();
        }
    });

    // Share button functionality
    const shareBtn = document.getElementById('shareBtn');
    const shareModal = $('#shareModal');
    const copyShareUrlBtn = document.getElementById('copyShareUrl');
    const shareUrlInput = document.getElementById('shareUrl');

    // Generate share URL with encoded input data
    function generateShareUrl() {
        const input = inputEl.value.trim();
        const baseUrl = 'https://8gwifi.org/graph-easy.jsp';

        if (input) {
            // Use base64 encoding for the input data
            const encoded = btoa(unescape(encodeURIComponent(input)));
            return baseUrl + '?data=' + encodeURIComponent(encoded);
        }
        return baseUrl;
    }

    // Update Twitter share link with current data
    function updateTwitterShareLink() {
        const shareUrl = generateShareUrl();
        const tweetText = encodeURIComponent('Just created an awesome ASCII diagram using Graph-Easy tool by @anish2good 🚀\n\nCreate flowcharts, export to PNG/SVG/PDF - all in your browser!\n\n');
        const tweetLink = document.querySelector('#shareModal a[href*="twitter.com/intent/tweet"]');
        if (tweetLink) {
            tweetLink.href = 'https://twitter.com/intent/tweet?text=' + tweetText + encodeURIComponent(shareUrl) + '&hashtags=ASCII,DevTools,Diagrams,Documentation';
        }
    }

    shareBtn.addEventListener('click', function() {
        // Update share URL with current input data
        shareUrlInput.value = generateShareUrl();
        updateTwitterShareLink();
        shareModal.modal('show');
    });

    copyShareUrlBtn.addEventListener('click', function() {
        shareUrlInput.select();
        document.execCommand('copy');
        showToast('URL copied to clipboard!');
    });

    // Load data from URL parameter on page load
    function loadFromUrlParams() {
        const urlParams = new URLSearchParams(window.location.search);
        const encodedData = urlParams.get('data');

        if (encodedData) {
            try {
                const decoded = decodeURIComponent(escape(atob(decodeURIComponent(encodedData))));
                inputEl.value = decoded;
                showToast('Data loaded from shared URL!');

                // Auto-render graph once Perl is ready
                const checkPerlAndRender = setInterval(function() {
                    if (perlReady) {
                        clearInterval(checkPerlAndRender);
                        setTimeout(renderGraph, 500);
                    }
                }, 100);
            } catch (e) {
                console.error('Failed to decode shared data:', e);
            }
        }
    }

    // Call on page load
    loadFromUrlParams();

    // Store modules for Perl to access
    window.graphEasyModuleList = Object.keys(window.GraphEasyModules);
    window.getModuleContent = function(path) {
        return window.GraphEasyModules[path] || '';
    };
</script>

<!-- Load WebPerl -->
<script src="graph-easy/webperl.js?v=<%= System.currentTimeMillis() %>"></script>

<!-- Perl code that runs after WebPerl loads -->
<script type="text/perl">
use strict;
use warnings;
use WebPerl qw/js/;
use File::Path qw(make_path);

js('console')->log("Starting Graph-Easy initialization...");

# Load modules into filesystem from JavaScript
my @module_list = @{ js('window')->{graphEasyModuleList} };
js('console')->log("Loading " . scalar(@module_list) . " modules...");

for my $mod_path (@module_list) {
    my $content = js('window')->getModuleContent($mod_path);
    my $full_path = "/lib/$mod_path";

    my $dir = $full_path;
    $dir =~ s|/[^/]+$||;
    eval { make_path($dir) };

    if (open my $fh, '>', $full_path) {
        print $fh $content;
        close $fh;
        js('console')->log("Wrote: $full_path");
    } else {
        js('console')->error("Failed to write: $full_path - $!");
    }
}

# Now load Graph::Easy
eval {
    push @INC, '/lib';
    require Graph::Easy;
    require Graph::Easy::Parser;
};
if ($@) {
    js('console')->error("Failed to load Graph::Easy: $@");
    js('window')->renderGraphResult('', "Failed to load Graph::Easy: $@");
} else {
    js('console')->log("Graph::Easy loaded successfully!");

    js('window')->{doRender} = sub {
        my $input = js('window')->{graphInput};
        my $format = js('window')->{graphFormat} || 'ascii';

        eval {
            my $parser = Graph::Easy::Parser->new();
            my $graph = $parser->from_text($input);

            if (!$graph) {
                die "Failed to parse: " . ($parser->error() || "Unknown error");
            }

            my $output;
            if ($format eq 'ascii') {
                $output = $graph->as_ascii();
            } elsif ($format eq 'boxart') {
                $output = $graph->as_boxart();
            } elsif ($format eq 'html') {
                $output = $graph->as_html();
            } elsif ($format eq 'graphviz') {
                $output = $graph->as_graphviz();
            } elsif ($format eq 'txt') {
                $output = $graph->as_txt();
            } else {
                $output = $graph->as_ascii();
            }

            js('window')->renderGraphResult($output, '');
        };
        if ($@) {
            js('window')->renderGraphResult('', "$@");
        }
    };

    js('window')->graphEasyReady();
}
</script>
<%@ include file="thanks.jsp"%>
</div>
<%@ include file="body-close.jsp"%>


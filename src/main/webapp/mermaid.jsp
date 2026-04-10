<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
    <% String cacheVersion=String.valueOf(System.currentTimeMillis()); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="robots" content="index,follow" />

            <!-- Resource Hints -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">

            <!-- Critical CSS -->
            <style>
                * {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0
                }

                html {
                    scroll-behavior: smooth;
                    -webkit-text-size-adjust: 100%;
                    -webkit-font-smoothing: antialiased
                }

                body {
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    font-size: 1rem;
                    line-height: 1.5;
                    color: #0f172a;
                    background: #f8fafc;
                    margin: 0
                }

                :root {
                    --primary: #875afb;
                    --primary-dark: #7c3aed;
                    --bg-primary: #fff;
                    --bg-secondary: #f8fafc;
                    --text-primary: #0f172a;
                    --text-secondary: #475569;
                    --border: #e2e8f0
                }

                /* Mermaid specific override */
                .tool-textarea {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 14px;
                    line-height: 1.5;
                    width: 100%;
                    height: 400px;
                    padding: 1rem;
                    border: 1px solid var(--border);
                    border-radius: 0.5rem;
                    background: var(--bg-primary);
                    color: var(--text-primary);
                    resize: vertical;
                }

                .tool-textarea:focus {
                    outline: none;
                    border-color: var(--primary);
                    box-shadow: 0 0 0 3px rgba(135, 90, 251, 0.1);
                }

                #mermaidOutput {
                    overflow: auto;
                    text-align: center;
                    min-height: 300px;
                    background: #fff;
                    padding: 1rem;
                    border-radius: 4px;
                }

                [data-theme="dark"] #mermaidOutput {
                    background: #1e293b;
                }
            </style>

            <!-- SEO -->
            <jsp:include page="modern/components/seo-tool-page.jsp">
                <jsp:param name="toolName" value="AI Mermaid Diagram Generator - Describe in English, Get Diagrams Free" />
                <jsp:param name="toolDescription"
                    value="AI-powered Mermaid diagram generator. Describe your diagram in plain English and AI generates the Mermaid code instantly. Flowcharts, sequence diagrams, class diagrams, Gantt charts, state machines, ER diagrams and more. Live preview, SVG/PNG export. Free, no signup." />
                <jsp:param name="toolCategory" value="Developer Tools" />
                <jsp:param name="toolUrl" value="mermaid.jsp" />
                <jsp:param name="toolKeywords"
                    value="ai mermaid generator, ai diagram generator, ai flowchart, mermaid live editor, ai text to diagram, mermaid online, ai sequence diagram, ai class diagram, ai gantt chart, mermaid ai, describe diagram ai, flowchart from text ai, free diagram generator" />
                <jsp:param name="toolImage" value="mermaid.png" />
                <jsp:param name="toolFeatures"
                    value="AI generates Mermaid code from plain English,Live Preview with instant rendering,9 diagram types: Flowchart Sequence Class State Gantt ER Pie Journey Mindmap,Download SVG/PNG,One-click Copy and Share,AI example prompts for each diagram type,Client-side rendering,Dark mode support,Free and no signup required" />
                <jsp:param name="hasSteps" value="true" />
                <jsp:param name="howToSteps" value="Describe|Type what you want in plain English like 'user login flow with auth check',Generate|Click Generate and AI creates the Mermaid syntax automatically,Customize|Edit the generated code or export as SVG/PNG" />
                <jsp:param name="faq1q" value="How does the AI diagram generator work?" />
                <jsp:param name="faq1a"
                    value="Describe your diagram in plain English — like 'user signup flow with email verification' or 'e-commerce class diagram with User Product Order' — and AI generates valid Mermaid.js syntax that renders instantly as a visual diagram. No need to learn Mermaid syntax." />
                <jsp:param name="faq2q" value="Which diagram types are supported?" />
                <jsp:param name="faq2a"
                    value="9 types: Flowcharts, Sequence Diagrams, Class Diagrams, State Diagrams, Gantt Charts, ER Diagrams, Pie Charts, User Journeys, and Mindmaps. The AI automatically picks the right type based on your description." />
                <jsp:param name="faq3q" value="Is it free?" />
                <jsp:param name="faq3a" value="Yes, completely free with no signup. The AI diagram generation, live preview, editing, and SVG/PNG export are all available immediately." />
                <jsp:param name="faq4q" value="Can I edit the generated code?" />
                <jsp:param name="faq4a" value="Yes. The AI generates editable Mermaid syntax in the code editor. You can modify it freely and the live preview updates in real-time. You can also start from scratch or use the preset examples." />
            </jsp:include>

            <!-- Fonts -->
            <link rel="stylesheet"
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"
                media="print" onload="this.media='all'">
            <noscript>
                <link rel="stylesheet"
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap">
            </noscript>

            <!-- CSS -->
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/modern/css/design-system.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css">
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style"
                onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <noscript>
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
            </noscript>

            <%@ include file="modern/ads/ad-init.jsp" %>

                <script src="https://code.jquery.com/jquery-3.6.0.min.js"
                    integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/mermaid@10.9.0/dist/mermaid.min.js"></script>

                <style>
                    /* Tool-specific theme variables */
                    :root {
                        --tool-primary: #875afb;
                        --tool-primary-dark: #7c3aed;
                        --tool-gradient: linear-gradient(135deg, #875afb 0%, #7c3aed 100%);
                        --tool-light: #f3e8ff;
                    }

                    [data-theme="dark"] {
                        --tool-gradient: linear-gradient(135deg, #a78bfa 0%, #8b5cf6 100%);
                        --tool-light: rgba(139, 92, 246, 0.15);
                    }
                    .mm-ai-chip {
                        padding: 0.2rem 0.5rem;
                        background: rgba(99,102,241,0.08);
                        border: 1px solid rgba(99,102,241,0.15);
                        border-radius: 12px;
                        font-size: 0.7rem;
                        color: #6366f1;
                        font-weight: 500;
                        cursor: pointer;
                        transition: background 0.12s;
                    }
                    .mm-ai-chip:hover { background: rgba(99,102,241,0.15); }
                    [data-theme="dark"] .mm-ai-chip { background: rgba(99,102,241,0.12); border-color: rgba(99,102,241,0.2); color: #a5b4fc; }
                    [data-theme="dark"] .mm-ai-chip:hover { background: rgba(99,102,241,0.2); }
                </style>
        </head>

        <body>
            <!-- Navigation -->
            <%@ include file="modern/components/nav-header.jsp" %>

                <!-- Page Header -->
                <header class="tool-page-header">
                    <div class="tool-page-header-inner">
                        <div>
                            <h1 class="tool-page-title">Mermaid Diagram Generator</h1>
                            <nav class="tool-breadcrumbs">
                                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                                <a href="<%=request.getContextPath()%>/index.jsp#developer">Developer Tools</a> /
                                Mermaid Editor
                            </nav>
                        </div>
                        <div class="tool-page-badges">
                            <span class="tool-badge">Mermaid.js v10+</span>
                            <span class="tool-badge">Live Preview</span>
                            <span class="tool-badge">SVG Export</span>
                        </div>
                    </div>
                </header>

                <!-- Tool Description + Ad Section -->
                <section class="tool-description-section">
                    <div class="tool-description-inner">
                        <div class="tool-description-content">
                            <p>Create complex diagrams from text/code. Visualize flowcharts, sequence diagrams, class
                                diagrams, Gantt charts, and git graphs. Edit code on the left and see the changes
                                instantly.</p>
                        </div>
                        <div class="tool-description-ad">
                            <%@ include file="modern/ads/ad-in-content-top.jsp" %>
                        </div>
                    </div>
                </section>

                <!-- Main Content -->
                <main class="tool-page-container">
                    <!-- ========== INPUT COLUMN ========== -->
                    <div class="tool-input-column">
                        <div class="tool-card">
                            <!-- Diagram Type Tabs -->
                            <div class="tool-tabs" role="tablist" id="typeTabs">
                                <button class="tool-tab active" data-type="flowchart" role="tab"
                                    onclick="loadPreset('flowchart')">Flowchart</button>
                                <button class="tool-tab" data-type="sequence" role="tab"
                                    onclick="loadPreset('sequence')">Sequence</button>
                                <button class="tool-tab" data-type="class" role="tab"
                                    onclick="loadPreset('class')">Class</button>
                                <button class="tool-tab" data-type="state" role="tab"
                                    onclick="loadPreset('state')">State</button>
                                <button class="tool-tab" data-type="gantt" role="tab"
                                    onclick="loadPreset('gantt')">Gantt</button>
                                <button class="tool-tab" data-type="er" role="tab"
                                    onclick="loadPreset('er')">ER</button>
                                <button class="tool-tab" data-type="pie" role="tab"
                                    onclick="loadPreset('pie')">Pie</button>
                                <button class="tool-tab" data-type="journey" role="tab"
                                    onclick="loadPreset('journey')">Journey</button>
                                <button class="tool-tab" data-type="mindmap" role="tab"
                                    onclick="loadPreset('mindmap')">Mindmap</button>
                            </div>

                            <div class="tool-card-body">
                                <!-- AI: Describe in English -->
                                <div class="tool-section" style="margin-bottom:0.75rem;">
                                    <div style="padding:0.75rem;background:linear-gradient(135deg,rgba(99,102,241,0.06),rgba(139,92,246,0.04));border:1px solid rgba(99,102,241,0.15);border-radius:0.5rem;">
                                        <label style="display:flex;align-items:center;gap:0.35rem;font-size:0.8rem;font-weight:600;color:#6366f1;margin-bottom:0.4rem;">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;"><path d="M12 2a4 4 0 014 4v1h1a3 3 0 010 6h-1v1a4 4 0 01-8 0v-1H7a3 3 0 010-6h1V6a4 4 0 014-4z"/><circle cx="9" cy="10" r="1" fill="currentColor" stroke="none"/><circle cx="15" cy="10" r="1" fill="currentColor" stroke="none"/></svg>
                                            AI &mdash; describe your diagram
                                        </label>
                                        <div style="display:flex;gap:0.4rem;">
                                            <input type="text" class="tool-input" id="mm-ai-input" placeholder="e.g. user login flow with auth check and redirect" autocomplete="off" spellcheck="false" style="flex:1;font-size:0.85rem;">
                                            <button type="button" id="mm-ai-btn" style="padding:0.45rem 0.9rem;background:linear-gradient(135deg,#6366f1,#8b5cf6);color:#fff;border:none;border-radius:0.375rem;font-size:0.8rem;font-weight:600;cursor:pointer;white-space:nowrap;">Generate</button>
                                        </div>
                                        <div id="mm-ai-status" style="display:none;margin-top:0.4rem;padding:0.3rem 0.5rem;border-radius:0.25rem;font-size:0.75rem;"></div>
                                        <div style="display:flex;flex-wrap:wrap;gap:0.3rem;margin-top:0.5rem;">
                                            <button type="button" class="mm-ai-chip" data-prompt="user registration flow: sign up form, validate email, send confirmation, activate account" data-type="flowchart">signup flow</button>
                                            <button type="button" class="mm-ai-chip" data-prompt="REST API sequence: client sends request to API gateway, gateway calls auth service, then backend service responds" data-type="sequence">API sequence</button>
                                            <button type="button" class="mm-ai-chip" data-prompt="e-commerce class diagram with User, Product, Order, Cart, Payment classes and their relationships" data-type="class">e-commerce classes</button>
                                            <button type="button" class="mm-ai-chip" data-prompt="order processing states: new, confirmed, shipped, delivered, cancelled with transitions" data-type="state">order states</button>
                                            <button type="button" class="mm-ai-chip" data-prompt="project timeline: design 2 weeks, development 4 weeks, testing 2 weeks, deployment 1 week" data-type="gantt">project gantt</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="tool-section">
                                    <div class="tool-section-header">
                                        <span>Mermaid Code</span>
                                    </div>
                                    <div class="tool-section-content" style="padding-top: 1rem;">
                                        <textarea id="mermaidInput" class="tool-textarea" spellcheck="false"
                                            placeholder="Enter Mermaid syntax here, or use AI above..."></textarea>
                                    </div>
                                </div>

                                <button type="button" class="tool-action-btn" id="renderBtn" onclick="renderDiagram()">
                                    Render Diagram (Manual)
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- ========== OUTPUT COLUMN ========== -->
                    <div class="tool-output-column">
                        <div class="tool-card tool-output-wrapper">
                            <!-- Actions Bar -->
                            <div class="tool-actions-bar">
                                <div class="tool-live-indicator">
                                    <span class="tool-live-dot"></span>
                                    Live Preview
                                </div>
                                <div class="tool-actions-spacer"></div>
                                <button class="tool-btn" id="saveBtn" onclick="saveDiagram()">
                                    <span>&#128190;</span> Save
                                </button>
                                <button class="tool-btn" id="loadBtn" onclick="loadDiagram()">
                                    <span>&#128193;</span> Load
                                </button>
                                <button class="tool-btn" id="copyCodeBtn" onclick="copyCode()">
                                    <span>&#128203;</span> Copy Code
                                </button>
                                <button class="tool-btn" id="shareBtn" onclick="shareOutput()">
                                    <span>&#128279;</span> Share
                                </button>
                                <button class="tool-btn" id="downloadSvgBtn" onclick="downloadSVG()">
                                    <span>&#8681;</span> SVG
                                </button>
                                <button class="tool-btn" id="downloadPngBtn" onclick="downloadPNG()">
                                    <span>&#8681;</span> PNG
                                </button>
                            </div>

                            <!-- Status Bar -->
                            <div class="tool-status" id="statusBar" style="display: none;">
                                <span class="tool-status-dot"></span>
                                <span id="statusText">Rendering...</span>
                            </div>

                            <!-- Error Alert -->
                            <div id="errorAlert" class="tool-alert tool-alert-error"
                                style="display: none; margin: 1rem;">
                                <span>&#9888;</span>
                                <span id="errorText">Syntax Error</span>
                            </div>

                            <!-- Output Area -->
                            <div id="mermaidOutput"></div>
                        </div>
                    </div>

                    <!-- ========== ADS COLUMN ========== -->
                    <div class="tool-ads-column">
                        <%@ include file="modern/ads/ad-three-column.jsp" %>
                    </div>
                </main>

                <!-- In-Content Ad (All Devices) -->
                <div class="tool-mobile-ad-container">
                    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
                </div>

                <!-- Related Tools -->
                <jsp:include page="modern/components/related-tools.jsp">
                    <jsp:param name="currentToolUrl" value="mermaid.jsp" />
                    <jsp:param name="category" value="Developer Tools" />
                    <jsp:param name="limit" value="6" />
                </jsp:include>

                <!-- Support Section -->
                <%@ include file="modern/components/support-section.jsp" %>

                    <!-- Footer -->
                    <footer class="page-footer">
                        <div class="footer-content">
                            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
                            <div class="footer-links">
                                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener"
                                    class="footer-link">Twitter</a>
                            </div>
                        </div>
                    </footer>

                    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
                        <%@ include file="modern/components/analytics.jsp" %>

                            <script
                                src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
                            <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js"
                                defer></script>
                            <script src="<%=request.getContextPath()%>/modern/js/search.js"
                                defer></script>

                            <script>
                                // ========== PRESETS ==========
                                const presets = {
                                    flowchart: `graph TD
    A[Start] --> B{Is it working?}
    B -- Yes --> C[Great!]
    B -- No --> D[Debug]
    D --> B`,
                                    sequence: `sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail!
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!`,
                                    class: `classDiagram
    Animal <|-- Duck
    Animal <|-- Fish
    Animal <|-- Zebra
    Animal : +int age
    Animal : +String gender
    Animal: +isMammal()
    Animal: +mate()
    class Duck{
        +String beakColor
        +swim()
        +quack()
    }
    class Fish{
        -int sizeInFeet
        -canEat()
    }
    class Zebra{
        +bool is_wild
        +run()
    }`,
                                    state: `stateDiagram-v2
    [*] --> Still
    Still --> [*]
    Still --> Moving
    Moving --> Still
    Moving --> Crash
    Crash --> [*]`,
                                    gantt: `gantt
    title A Gantt Diagram
    dateFormat  YYYY-MM-DD
    section Section
    A task           :a1, 2014-01-01, 30d
    Another task     :after a1  , 20d
    section Another
    Task in sec      :2014-01-12  , 12d
    another task      : 24d`,
                                    er: `erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses`,
                                    pie: `pie title Pets adopted by volunteers
    "Dogs" : 386
    "Cats" : 85
    "Rats" : 15`,
                                    journey: `journey
    title My working day
    section Go to work
      Make tea: 5: Me
      Go upstairs: 3: Me
      Do work: 1: Me, Cat
    section Go home
      Go downstairs: 5: Me
      Sit down: 5: Me`,
                                    mindmap: `mindmap
  root((mindmap))
    Origins
      Long history
      ::icon(fa fa-book)
      Popularisation
        British popular psychology author Tony Buzan
    Research
      On effectiveness<br/>and features
      On Automatic creation
        Uses
            Creative techniques
            Strategic planning
            Argument mapping`
                                };

                                let renderTimeout = null;

                                $(document).ready(function () {
                                    // Initialize Mermaid
                                    mermaid.initialize({
                                        startOnLoad: false,
                                        theme: 'default',
                                        securityLevel: 'loose'
                                    });

                                    // Check for shared code
                                    const urlParams = new URLSearchParams(window.location.search);
                                    let sharedCode = urlParams.get('code');

                                    if (sharedCode) {
                                        // ToolUtils.generateShareUrl double-encodes (encodeURIComponent + URLSearchParams)
                                        // so we need to decode it here to get back the original text
                                        try {
                                            sharedCode = decodeURIComponent(sharedCode);
                                        } catch (e) {
                                            console.warn('Failed to decode shared code:', e);
                                        }

                                        $('#mermaidInput').val(sharedCode);
                                        $('#typeTabs .tool-tab').removeClass('active');
                                    } else {
                                        // Load initial preset
                                        loadPreset('flowchart');
                                    }

                                    // Initial render
                                    renderDiagram();

                                    // Setup live preview input listener
                                    $('#mermaidInput').on('input', function () {
                                        clearTimeout(renderTimeout);
                                        renderTimeout = setTimeout(renderDiagram, 500); // 500ms debounce
                                    });

                                    // Update theme when dark mode changes
                                    const observer = new MutationObserver(function (mutations) {
                                        mutations.forEach(function (mutation) {
                                            if (mutation.attributeName === "data-theme") {
                                                updateMermaidTheme();
                                            }
                                        });
                                    });
                                    observer.observe(document.documentElement, { attributes: true });

                                    // Initial theme check
                                    setTimeout(updateMermaidTheme, 100);
                                });

                                // ========== AI: Describe → Mermaid code ==========
                                (function() {
                                    var mmAiInput = document.getElementById('mm-ai-input');
                                    var mmAiBtn = document.getElementById('mm-ai-btn');
                                    var mmAiStatus = document.getElementById('mm-ai-status');

                                    var AI_SYSTEM = 'You are a Mermaid.js diagram expert. Given a plain-English description, output ONLY valid Mermaid syntax. No explanation, no markdown fences, no text before or after.\n\n' +
                                        'Supported types: flowchart (TD/LR), sequenceDiagram, classDiagram, stateDiagram-v2, gantt, erDiagram, pie, journey, mindmap.\n\n' +
                                        'Rules:\n' +
                                        '- First line must be the diagram type keyword (e.g., "flowchart TD")\n' +
                                        '- Use proper Mermaid syntax with correct indentation\n' +
                                        '- For flowcharts: use --> for arrows, [] for rectangular nodes, {} for diamond decisions\n' +
                                        '- For sequence: use ->> for solid arrows, -->> for dashed\n' +
                                        '- Keep diagrams concise but complete (5-15 nodes typically)\n' +
                                        '- Output ONLY the Mermaid code\n\n' +
                                        'Examples:\n' +
                                        'Input: "simple login flow"\nOutput:\nflowchart TD\n    A[Login Page] --> B[Enter Credentials]\n    B --> C{Valid?}\n    C -->|Yes| D[Dashboard]\n    C -->|No| E[Error Message]\n    E --> B\n\n' +
                                        'Input: "client server API call"\nOutput:\nsequenceDiagram\n    Client->>Server: HTTP Request\n    Server->>Database: Query\n    Database-->>Server: Results\n    Server-->>Client: HTTP Response';

                                    function setStatus(msg, cls) {
                                        if (!mmAiStatus) return;
                                        mmAiStatus.textContent = msg;
                                        mmAiStatus.style.display = msg ? 'block' : 'none';
                                        mmAiStatus.style.color = cls === 'error' ? '#dc2626' : cls === 'success' ? '#16a34a' : '#6366f1';
                                        mmAiStatus.style.background = cls === 'error' ? 'rgba(220,38,38,0.08)' : cls === 'success' ? 'rgba(22,163,74,0.08)' : 'rgba(99,102,241,0.08)';
                                    }

                                    if (mmAiBtn && mmAiInput) {
                                        mmAiBtn.addEventListener('click', function() { aiGenerate(); });
                                        mmAiInput.addEventListener('keydown', function(e) {
                                            if (e.key === 'Enter' && !mmAiBtn.disabled) aiGenerate();
                                        });

                                        document.querySelectorAll('.mm-ai-chip').forEach(function(chip) {
                                            chip.addEventListener('click', function() {
                                                mmAiInput.value = chip.getAttribute('data-prompt');
                                                var type = chip.getAttribute('data-type');
                                                if (type) loadPreset(type);
                                                mmAiInput.focus();
                                            });
                                        });
                                    }

                                    function aiGenerate() {
                                        var desc = mmAiInput.value.trim();
                                        if (!desc) { setStatus('Enter a description', 'error'); return; }

                                        mmAiBtn.disabled = true;
                                        mmAiBtn.textContent = 'Thinking...';
                                        setStatus('AI is generating Mermaid code...', 'loading');

                                        fetch('<%=request.getContextPath()%>/ai', {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/json' },
                                            body: JSON.stringify({
                                                messages: [
                                                    { role: 'system', content: AI_SYSTEM },
                                                    { role: 'user', content: desc }
                                                ],
                                                stream: false
                                            })
                                        })
                                        .then(function(r) {
                                            if (r.status === 429) throw new Error('Rate limit — try again in a minute');
                                            if (!r.ok) throw new Error('AI unavailable');
                                            return r.json();
                                        })
                                        .then(function(data) {
                                            var text = '';
                                            if (data.message && data.message.content) text = data.message.content;
                                            else if (data.response) text = data.response;
                                            else if (data.choices && data.choices[0]) {
                                                text = data.choices[0].message ? data.choices[0].message.content : (data.choices[0].text || '');
                                            }
                                            if (!text) throw new Error('Empty AI response');

                                            // Clean: strip markdown fences
                                            text = text.replace(/```mermaid\s*/gi, '').replace(/```\s*/g, '').trim();

                                            // Fill textarea and render
                                            $('#mermaidInput').val(text);
                                            setStatus('Generated! Rendering...', 'success');
                                            renderDiagram();

                                            // Auto-detect diagram type and update tab
                                            var firstLine = text.split('\n')[0].trim().toLowerCase();
                                            var typeMap = {
                                                'flowchart': 'flowchart', 'graph': 'flowchart',
                                                'sequencediagram': 'sequence', 'classdiagram': 'class',
                                                'statediagram': 'state', 'gantt': 'gantt',
                                                'erdiagram': 'er', 'pie': 'pie',
                                                'journey': 'journey', 'mindmap': 'mindmap'
                                            };
                                            Object.keys(typeMap).forEach(function(key) {
                                                if (firstLine.startsWith(key)) {
                                                    $('#typeTabs .tool-tab').removeClass('active');
                                                    $('#typeTabs .tool-tab[data-type="' + typeMap[key] + '"]').addClass('active');
                                                }
                                            });

                                            setTimeout(function() { setStatus('', ''); }, 3000);
                                        })
                                        .catch(function(err) {
                                            setStatus(err.message, 'error');
                                        })
                                        .finally(function() {
                                            mmAiBtn.disabled = false;
                                            mmAiBtn.textContent = 'Generate';
                                        });
                                    }
                                })();

                                function loadPreset(type) {
                                    // Update tabs
                                    $('#typeTabs .tool-tab').removeClass('active');
                                    $(`#typeTabs .tool-tab[data-type="\${type}"]`).addClass('active');

                                    // Update textarea
                                    $('#mermaidInput').val(presets[type] || '');

                                    // Render
                                    renderDiagram();
                                }

                                function updateMermaidTheme() {
                                    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
                                    const theme = isDark ? 'dark' : 'default';

                                    mermaid.initialize({
                                        startOnLoad: false,
                                        theme: theme
                                    });

                                    renderDiagram();
                                }

                                async function renderDiagram() {
                                    const code = $('#mermaidInput').val();
                                    const outputDiv = document.getElementById('mermaidOutput');
                                    const errorAlert = document.getElementById('errorAlert');
                                    const statusBar = document.getElementById('statusBar');

                                    if (!code.trim()) {
                                        outputDiv.innerHTML = '';
                                        return;
                                    }

                                    statusBar.style.display = 'flex';
                                    $('#statusText').text('Rendering...');

                                    try {
                                        const { svg } = await mermaid.render('mermaid-svg-' + Date.now(), code);
                                        outputDiv.innerHTML = svg;
                                        errorAlert.style.display = 'none';
                                        $('#statusText').text('Rendered successfully');
                                        setTimeout(() => { statusBar.style.display = 'none'; }, 2000);
                                    } catch (error) {
                                        console.error('Mermaid Error:', error);
                                        errorAlert.style.display = 'flex';
                                        $('#errorText').text(error.message || 'Syntax Error in Mermaid Code');
                                    }
                                }

                                function copyCode() {
                                    const code = $('#mermaidInput').val();
                                    if (typeof ToolUtils !== 'undefined') {
                                        ToolUtils.copyToClipboard(code, { showToast: true, toastMessage: 'Mermaid code copied!' });
                                    } else {
                                        navigator.clipboard.writeText(code).then(() => alert('Copied!'));
                                    }
                                }

                                function saveDiagram() {
                                    const code = $('#mermaidInput').val();
                                    if (!code.trim()) {
                                        if (typeof ToolUtils !== 'undefined') {
                                            ToolUtils.showToast('Nothing to save!', 2000, 'warning');
                                        } else {
                                            alert('Nothing to save!');
                                        }
                                        return;
                                    }

                                    const name = prompt('Enter a name for this diagram:', 'My Diagram');
                                    if (name) {
                                        const key = 'mermaid_drawing_' + name;
                                        if (typeof ToolUtils !== 'undefined' && ToolUtils.storage) {
                                            if (ToolUtils.storage.save(key, code)) {
                                                ToolUtils.showToast('Diagram saved successfully!');
                                            } else {
                                                ToolUtils.showToast('Failed to save diagram.', 3000, 'error');
                                            }
                                        } else {
                                            alert('Storage functionality not available.');
                                        }
                                    }
                                }

                                function loadDiagram() {
                                    if (typeof ToolUtils !== 'undefined' && ToolUtils.storage) {
                                        ToolUtils.storage.openManager({
                                            toolName: 'Diagram',
                                            keyPrefix: 'mermaid_drawing_',
                                            onLoad: function (data) {
                                                $('#mermaidInput').val(data);
                                                // Reset active tab since custom code is loaded
                                                $('#typeTabs .tool-tab').removeClass('active');
                                                renderDiagram();
                                            }
                                        });
                                    } else {
                                        alert('Storage functionality not available.');
                                    }
                                }

                                function shareOutput() {
                                    const code = $('#mermaidInput').val();
                                    if (!code) return;

                                    if (typeof ToolUtils !== 'undefined') {
                                        const url = ToolUtils.generateShareUrl({
                                            code: code
                                        }, {
                                            showSupportPopup: false, // We'll handle popup in copyToClipboard
                                            toolName: 'Mermaid Generator'
                                        });

                                        ToolUtils.copyToClipboard(url, {
                                            showToast: true,
                                            toastMessage: 'Share URL copied to clipboard!',
                                            showSupportPopup: true,
                                            toolName: 'Mermaid Generator'
                                        });
                                    } else {
                                        alert('Share functionality requires ToolUtils.');
                                    }
                                }

                                function downloadSVG() {
                                    const svgContent = document.getElementById('mermaidOutput').innerHTML;
                                    if (!svgContent) return;

                                    const blob = new Blob([svgContent], { type: 'image/svg+xml' });
                                    const url = URL.createObjectURL(blob);
                                    const a = document.createElement('a');
                                    a.href = url;
                                    a.download = 'mermaid-diagram.svg';
                                    document.body.appendChild(a);
                                    a.click();
                                    document.body.removeChild(a);
                                    URL.revokeObjectURL(url);
                                }

                                function downloadPNG() {
                                    const svgElement = document.querySelector('#mermaidOutput svg');
                                    if (!svgElement) return;

                                    const canvas = document.createElement('canvas');
                                    const serializer = new XMLSerializer();
                                    const svgString = serializer.serializeToString(svgElement);

                                    // Get dimensions from viewBox if width/height not set
                                    let width = svgElement.width.baseVal.value;
                                    let height = svgElement.height.baseVal.value;

                                    if (!width || !height) {
                                        const viewBox = svgElement.viewBox.baseVal;
                                        width = viewBox.width;
                                        height = viewBox.height;
                                    }

                                    // Scale up for better quality
                                    const scale = 2;
                                    canvas.width = width * scale;
                                    canvas.height = height * scale;

                                    const ctx = canvas.getContext('2d');
                                    const img = new Image();

                                    // Use Base64 Data URI to avoid "Tainted Canvas" security error
                                    // This bypasses the origin check for local content
                                    const svg64 = btoa(unescape(encodeURIComponent(svgString)));
                                    const image64 = 'data:image/svg+xml;base64,' + svg64;

                                    img.onload = function () {
                                        ctx.fillStyle = '#ffffff'; // White background for PNG
                                        ctx.fillRect(0, 0, canvas.width, canvas.height);
                                        ctx.drawImage(img, 0, 0, width * scale, height * scale);

                                        try {
                                            const pngUrl = canvas.toDataURL('image/png');
                                            const a = document.createElement('a');
                                            a.href = pngUrl;
                                            a.download = 'mermaid-diagram.png';
                                            document.body.appendChild(a);
                                            a.click();
                                            document.body.removeChild(a);
                                        } catch (e) {
                                            console.error('Export Error:', e);
                                            alert('Could not export to PNG. SecurityError: Tainted canvas.');
                                        }
                                    };

                                    img.src = image64;
                                }
                            </script>
        </body>

        </html>
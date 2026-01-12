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
                <jsp:param name="toolName" value="Mermaid Live Editor - Online Text to Diagram Generator" />
                <jsp:param name="toolDescription"
                    value="Free online Mermaid Live Editor. Generate Flowcharts, Sequence Diagrams, Gantt Charts, Class Diagrams, State Diagrams and more from text. Live preview and download SVG/PNG." />
                <jsp:param name="toolCategory" value="Developer Tools" />
                <jsp:param name="toolUrl" value="mermaid.jsp" />
                <jsp:param name="toolKeywords"
                    value="mermaid live editor, mermaid online, text to diagram, flowchart generator, sequence diagram generator, gantt chart generator, mermaid visual editor, markdown diagram" />
                <jsp:param name="toolImage" value="mermaid.png" />
                <jsp:param name="toolFeatures"
                    value="Live Preview,Support for all Mermaid Types (Flowchart Sequence Gantt Class State Pie ER),Download SVG/PNG,One-click Copy,Client-side rendering,No signup required" />
                <jsp:param name="hasSteps" value="true" />
                <jsp:param name="faq1q" value="What is Mermaid Live Editor?" />
                <jsp:param name="faq1a"
                    value="It's a free online tool to generate diagrams and charts from text definitions using the Mermaid.js library." />
                <jsp:param name="faq2q" value="Which diagram types are supported?" />
                <jsp:param name="faq2a"
                    value="We support Flowcharts, Sequence Diagrams, Gantt Charts, Class Diagrams, State Diagrams, Pie Charts, ER Diagrams, and User Journeys." />
                <jsp:param name="faq3q" value="Is it free?" />
                <jsp:param name="faq3a" value="Yes, completely free and all rendering happens in your browser." />
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
                href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
            <link rel="stylesheet"
                href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style"
                onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>"
                as="style" onload="this.onload=null;this.rel='stylesheet'">
            <noscript>
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
                <link rel="stylesheet"
                    href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
                <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
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
                                <div class="tool-section">
                                    <div class="tool-section-header">
                                        <span>Mermaid Code</span>
                                    </div>
                                    <div class="tool-section-content" style="padding-top: 1rem;">
                                        <textarea id="mermaidInput" class="tool-textarea" spellcheck="false"
                                            placeholder="Enter Mermaid syntax here..."></textarea>
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
                                src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
                            <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"
                                defer></script>
                            <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"
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
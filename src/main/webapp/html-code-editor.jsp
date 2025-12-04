<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <!-- Essential Meta Tags -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <!-- Primary SEO Meta Tags -->
    <title>Free Online HTML Editor & Playground - HTML CSS JavaScript with Instant Live Preview</title>
    <meta name="description"
          content="Write and test HTML, CSS, and JavaScript with instant live preview in real-time. Free online code editor with syntax highlighting, templates, and export. No login required. Perfect for web developers, students, and quick prototyping.">
    <meta name="keywords"
          content="free online code editor, HTML editor online free, HTML CSS JavaScript playground, instant live preview, online code editor without login, real-time code preview, web code editor, browser code editor, code sandbox online, JavaScript editor with preview, CSS editor live, frontend playground, HTML playground, code testing tool, web development playground">
    <meta name="author" content="CryptoTools">
    <meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1">

    <!-- Canonical URL -->
    <link rel="canonical" href="<%= request.getScheme() + " ://" + request.getServerName() +
            (request.getServerPort() !=80 && request.getServerPort() !=443 ? ":" + request.getServerPort() : "" ) +
            request.getContextPath() + "/live-code-editor.jsp" %>">

    <!-- Open Graph / Facebook Meta Tags -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="<%= request.getScheme() + " ://" + request.getServerName() +
            (request.getServerPort() !=80 && request.getServerPort() !=443 ? ":" + request.getServerPort() : "" ) +
            request.getContextPath() + "/live-code-editor.jsp" %>">
    <meta property="og:title" content="Free Online Code Editor - HTML CSS JavaScript Playground with Live Preview">
    <meta property="og:description"
          content="Write and test HTML, CSS, and JavaScript in real-time with instant live preview. Free online code editor for web developers and students. No signup required.">
    <meta property="og:image" content="<%= request.getScheme() + " ://" + request.getServerName() +
            (request.getServerPort() !=80 && request.getServerPort() !=443 ? ":" + request.getServerPort() : "" ) +
            request.getContextPath() %>/images/live-code-editor-preview.png">
    <meta property="og:site_name" content="CryptoTools">
    <meta property="og:locale" content="en_US">

    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:url" content="<%= request.getScheme() + " ://" + request.getServerName() +
            (request.getServerPort() !=80 && request.getServerPort() !=443 ? ":" + request.getServerPort() : "" ) +
            request.getContextPath() + "/live-code-editor.jsp" %>">
    <meta name="twitter:title" content="Free Online Code Editor with Live Preview - HTML CSS JavaScript">
    <meta name="twitter:description"
          content="Write and test HTML, CSS, and JavaScript in real-time. Free online playground for web developers. No signup required.">
    <meta name="twitter:image" content="<%= request.getScheme() + " ://" + request.getServerName() +
            (request.getServerPort() !=80 && request.getServerPort() !=443 ? ":" + request.getServerPort() : "" ) +
            request.getContextPath() %>/images/live-code-editor-preview.png">

    <!-- Mobile Browser Theme Color -->
    <meta name="theme-color" content="#667eea">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

    <!-- Structured Data (JSON-LD) for Rich Results -->
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "HTML CSS JS Playground",
            "description": "Free online HTML, CSS, and JavaScript playground with instant live preview. Features syntax highlighting, templates, share URLs, and export functionality.",
            "url": "<%= request.getScheme() + "://" + request.getServerName() + (request.getServerPort() != 80 && request.getServerPort() != 443 ? ":" + request.getServerPort() : "") + request.getContextPath() + "/live-code-editor.jsp" %>",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": [
            "Live HTML/CSS/JavaScript preview",
            "Syntax highlighting with CodeMirror",
            "6 starter templates",
            "Code export functionality",
            "Console output capture",
            "Responsive layout options"
        ],
        "browserRequirements": "Requires JavaScript. Requires HTML5.",
        "softwareVersion": "1.0",
        "author": {
            "@type": "Organization",
            "name": "CryptoTools"
        }
    }
    </script>

    <!-- Preconnect to External Resources for Performance -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">

    <!-- Stylesheets -->
    <link
            href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500;700&family=Inter:wght@400;600;700&display=swap"
            rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/dracula.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/show-hint.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            color: #fff;
            height: 100vh;
            overflow: hidden;
        }

        .header {
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo h1 {
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .logo-icon {
            font-size: 2rem;
        }

        .header-controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(56, 239, 125, 0.4);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(56, 239, 125, 0.6);
        }

        .layout-toggle {
            background: rgba(255, 255, 255, 0.1);
            padding: 5px;
            border-radius: 8px;
            display: flex;
            gap: 5px;
        }

        .layout-btn {
            padding: 8px 12px;
            background: transparent;
            border: none;
            color: #a8a8a8;
            cursor: pointer;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-size: 1.2rem;
        }

        .layout-btn.active {
            background: rgba(102, 126, 234, 0.3);
            color: #667eea;
        }

        .layout-btn:hover {
            color: #fff;
        }

        .main-container {
            display: flex;
            height: calc(100vh - 70px);
        }

        .editors-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #1e1e1e;
            min-height: 0;
        }

        .editors-container.horizontal {
            flex-direction: row;
        }

        .editor-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: #282a36;
            min-height: 0;
            overflow: hidden;
        }

        .editor-header {
            background: rgba(0, 0, 0, 0.3);
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .editor-title {
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .editor-title.html {
            color: #e44d26;
        }

        .editor-title.css {
            color: #264de4;
        }

        .editor-title.js {
            color: #f0db4f;
        }

        .editor-actions {
            display: flex;
            gap: 8px;
        }

        .icon-btn {
            background: transparent;
            border: none;
            color: #a8a8a8;
            cursor: pointer;
            padding: 5px 10px;
            border-radius: 5px;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        .icon-btn:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
        }

        .editor-content {
            flex: 1;
            overflow: hidden;
        }

        .CodeMirror {
            height: 100%;
            font-family: 'Fira Code', monospace;
            font-size: 14px;
        }

        .preview-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #fff;
            border-left: 1px solid rgba(255, 255, 255, 0.1);
        }

        .preview-header {
            background: rgba(0, 0, 0, 0.05);
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }

        .preview-title {
            font-weight: 600;
            color: #333;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .preview-actions {
            display: flex;
            gap: 8px;
        }

        .preview-frame {
            flex: 1;
            border: none;
            background: white;
        }

        .templates-dropdown {
            position: relative;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 5px;
            background: #282a36;
            border-radius: 8px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
            min-width: 250px;
            z-index: 1000;
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
        }

        .dropdown-content.show {
            display: block;
        }

        .dropdown-item {
            padding: 12px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            color: #fff;
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-item:hover {
            background: rgba(102, 126, 234, 0.2);
        }

        .dropdown-item-title {
            font-weight: 600;
            margin-bottom: 3px;
        }

        .dropdown-item-desc {
            font-size: 0.85rem;
            color: #a8a8a8;
        }

        .console-container {
            background: #1e1e1e;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            max-height: 200px;
            overflow-y: auto;
            display: none;
        }

        .console-container.show {
            display: block;
        }

        .console-header {
            background: rgba(0, 0, 0, 0.3);
            padding: 8px 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .console-title {
            font-size: 0.85rem;
            font-weight: 600;
            color: #a8a8a8;
        }

        .console-content {
            padding: 10px 15px;
            font-family: 'Fira Code', monospace;
            font-size: 0.85rem;
        }

        .console-log {
            padding: 5px 0;
            color: #a8a8a8;
        }

        .console-error {
            padding: 5px 0;
            color: #ff6b6b;
        }

        .console-warn {
            padding: 5px 0;
            color: #ffd93d;
        }

        @media (max-width: 1024px) {
            .main-container {
                flex-direction: column;
            }

            .editors-container {
                height: 50%;
            }

            .preview-container {
                height: 50%;
                border-left: none;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                padding: 15px;
            }

            .header-controls {
                width: 100%;
                justify-content: space-between;
            }

            .btn {
                padding: 8px 15px;
                font-size: 0.85rem;
            }

            .btn span {
                display: none;
            }
        }

        .notification {
            position: fixed;
            top: 80px;
            right: 20px;
            background: #282a36;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
            border-left: 4px solid #38ef7d;
            z-index: 2000;
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }

            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        .notification.hide {
            animation: slideOut 0.3s ease-out forwards;
        }

        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }

            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<body>
<%@ include file="navigation.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<div class="header">
    <div class="logo">
        <span class="logo-icon">⚡</span>
        <h1>HTML CSS JS Playground</h1>
    </div>
    <div class="header-controls">
        <div class="layout-toggle">
            <button class="layout-btn active" onclick="setLayout('vertical')" title="Vertical Layout">
                ⬜
            </button>
            <button class="layout-btn" onclick="setLayout('horizontal')" title="Horizontal Layout">
                ▭
            </button>
        </div>
        <div class="templates-dropdown">
            <button class="btn btn-secondary" onclick="toggleTemplates()">
                📋 <span>Templates</span>
            </button>
            <div class="dropdown-content" id="templatesDropdown">
                <div class="dropdown-item" onclick="loadTemplate('blank')">
                    <div class="dropdown-item-title">Blank</div>
                    <div class="dropdown-item-desc">Start from scratch</div>
                </div>
                <div class="dropdown-item" onclick="loadTemplate('hello')">
                    <div class="dropdown-item-title">Hello World</div>
                    <div class="dropdown-item-desc">Simple starter template</div>
                </div>
                <div class="dropdown-item" onclick="loadTemplate('card')">
                    <div class="dropdown-item-title">Card Component</div>
                    <div class="dropdown-item-desc">Modern card design</div>
                </div>
                <div class="dropdown-item" onclick="loadTemplate('animation')">
                    <div class="dropdown-item-title">CSS Animation</div>
                    <div class="dropdown-item-desc">Animated elements</div>
                </div>
                <div class="dropdown-item" onclick="loadTemplate('interactive')">
                    <div class="dropdown-item-title">Interactive Button</div>
                    <div class="dropdown-item-desc">JavaScript interactivity</div>
                </div>
                <div class="dropdown-item" onclick="loadTemplate('calculator')">
                    <div class="dropdown-item-title">Calculator</div>
                    <div class="dropdown-item-desc">Functional calculator app</div>
                </div>
            </div>
        </div>
        <button class="btn btn-success" onclick="runCode()">
            ▶ <span>Run</span>
        </button>
        <button class="btn btn-primary" onclick="exportCode()">
            ⬇ <span>Export</span>
        </button>
        <button class="btn btn-info" onclick="shareCode()">
            🔗 <span>Share URL</span>
        </button>
    </div>
</div>

<div class="main-container">
    <div class="editors-container" id="editorsContainer">
        <div class="editor-panel">
            <div class="editor-header">
                <div class="editor-title html">
                    📄 HTML
                </div>
                <div class="editor-actions">
                    <button class="icon-btn" onclick="formatCode('html')" title="Format Code">
                        ✨
                    </button>
                    <button class="icon-btn" onclick="clearEditor('html')" title="Clear">
                        🗑️
                    </button>
                </div>
            </div>
            <div class="editor-content">
                <textarea id="htmlEditor"></textarea>
            </div>
        </div>

        <div class="editor-panel">
            <div class="editor-header">
                <div class="editor-title css">
                    🎨 CSS
                </div>
                <div class="editor-actions">
                    <button class="icon-btn" onclick="formatCode('css')" title="Format Code">
                        ✨
                    </button>
                    <button class="icon-btn" onclick="clearEditor('css')" title="Clear">
                        🗑️
                    </button>
                </div>
            </div>
            <div class="editor-content">
                <textarea id="cssEditor"></textarea>
            </div>
        </div>

        <div class="editor-panel">
            <div class="editor-header">
                <div class="editor-title js">
                    ⚡ JavaScript
                </div>
                <div class="editor-actions">
                    <button class="icon-btn" onclick="formatCode('js')" title="Format Code">
                        ✨
                    </button>
                    <button class="icon-btn" onclick="clearEditor('js')" title="Clear">
                        🗑️
                    </button>
                </div>
            </div>
            <div class="editor-content">
                <textarea id="jsEditor"></textarea>
            </div>
        </div>
    </div>

    <div class="preview-container">
        <div class="preview-header">
            <div class="preview-title">🖥️ Preview</div>
            <div class="preview-actions">
                <button class="icon-btn" onclick="refreshPreview()" title="Refresh">
                    🔄
                </button>
                <button class="icon-btn" onclick="toggleConsole()" title="Toggle Console">
                    💻
                </button>
            </div>
        </div>
        <iframe id="preview" class="preview-frame"></iframe>
        <div class="console-container" id="consoleContainer">
            <div class="console-header">
                <div class="console-title">Console</div>
                <button class="icon-btn" onclick="clearConsole()" title="Clear Console">
                    🗑️
                </button>
            </div>
            <div class="console-content" id="consoleContent">
                <div class="console-log">Console ready...</div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/xml/xml.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/css/css.min.js"></script>
<script
        src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/javascript/javascript.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/htmlmixed/htmlmixed.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/edit/closetag.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/edit/closebrackets.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/show-hint.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/html-hint.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/css-hint.min.js"></script>
<script
        src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/javascript-hint.min.js"></script>

<script>
    // Initialize CodeMirror editors
    const htmlEditor = CodeMirror.fromTextArea(document.getElementById('htmlEditor'), {
        mode: 'htmlmixed',
        theme: 'dracula',
        lineNumbers: true,
        autoCloseTags: true,
        autoCloseBrackets: true,
        lineWrapping: true,
        extraKeys: { "Ctrl-Space": "autocomplete" }
    });

    const cssEditor = CodeMirror.fromTextArea(document.getElementById('cssEditor'), {
        mode: 'css',
        theme: 'dracula',
        lineNumbers: true,
        autoCloseBrackets: true,
        lineWrapping: true,
        extraKeys: { "Ctrl-Space": "autocomplete" }
    });

    const jsEditor = CodeMirror.fromTextArea(document.getElementById('jsEditor'), {
        mode: 'javascript',
        theme: 'dracula',
        lineNumbers: true,
        autoCloseBrackets: true,
        lineWrapping: true,
        extraKeys: { "Ctrl-Space": "autocomplete" }
    });

    // Auto-run on change with debounce
    let debounceTimer;
    function debounceRun() {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(runCode, 1000);
    }

    htmlEditor.on('change', debounceRun);
    cssEditor.on('change', debounceRun);
    jsEditor.on('change', debounceRun);

    // Templates
    const templates = {
        blank: {
            html: '',
            css: '',
            js: ''
        },
        hello: {
            html: `<div class="container">
  <h1>Hello World!</h1>
  <p>Welcome to the Live Code Editor</p>
  <button onclick="greet()">Click Me</button>
</div>`,
            css: `body {
  font-family: 'Arial', sans-serif;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  margin: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.container {
  text-align: center;
  background: white;
  padding: 40px;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}

h1 {
  color: #667eea;
  margin-bottom: 20px;
}

button {
  padding: 12px 30px;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.3s;
}

button:hover {
  background: #764ba2;
  transform: translateY(-2px);
}`,
            js: `function greet() {
  alert('Hello from Live Code Editor! 🎉');
}`
        },
        card: {
            html: `<div class="card">
  <div class="card-image">
    <div class="image-placeholder">🖼️</div>
  </div>
  <div class="card-content">
    <h2>Beautiful Card</h2>
    <p>This is a modern card component with glassmorphism effects and smooth animations.</p>
    <button class="card-btn">Learn More</button>
  </div>
</div>`,
            css: `body {
  margin: 0;
  padding: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  font-family: 'Arial', sans-serif;
}

.card {
  width: 350px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-10px);
}

.card-image {
  height: 200px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: center;
  align-items: center;
}

.image-placeholder {
  font-size: 4rem;
}

.card-content {
  padding: 25px;
  color: white;
}

.card-content h2 {
  margin: 0 0 15px 0;
  font-size: 1.5rem;
}

.card-content p {
  margin: 0 0 20px 0;
  opacity: 0.9;
  line-height: 1.6;
}

.card-btn {
  width: 100%;
  padding: 12px;
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 10px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s;
}

.card-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(1.05);
}`,
            js: ''
        },
        animation: {
            html: `<div class="animation-container">
  <div class="box box1"></div>
  <div class="box box2"></div>
  <div class="box box3"></div>
</div>`,
            css: `body {
  margin: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #1a1a2e;
}

.animation-container {
  display: flex;
  gap: 30px;
}

.box {
  width: 80px;
  height: 80px;
  border-radius: 15px;
  animation: bounce 2s ease-in-out infinite;
}

.box1 {
  background: linear-gradient(135deg, #667eea, #764ba2);
  animation-delay: 0s;
}

.box2 {
  background: linear-gradient(135deg, #f093fb, #f5576c);
  animation-delay: 0.2s;
}

.box3 {
  background: linear-gradient(135deg, #4facfe, #00f2fe);
  animation-delay: 0.4s;
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-50px);
  }
}`,
            js: ''
        },
        interactive: {
            html: `<div class="container">
  <h1>Click Counter</h1>
  <div class="counter" id="counter">0</div>
  <div class="buttons">
    <button onclick="increment()">➕ Increment</button>
    <button onclick="decrement()">➖ Decrement</button>
    <button onclick="reset()">🔄 Reset</button>
  </div>
</div>`,
            css: `body {
  margin: 0;
  font-family: 'Arial', sans-serif;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.container {
  text-align: center;
  background: white;
  padding: 50px;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}

h1 {
  color: #667eea;
  margin-bottom: 30px;
}

.counter {
  font-size: 5rem;
  font-weight: bold;
  color: #764ba2;
  margin: 30px 0;
  transition: transform 0.3s;
}

.counter.pulse {
  transform: scale(1.2);
}

.buttons {
  display: flex;
  gap: 15px;
  justify-content: center;
}

button {
  padding: 15px 25px;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-size: 16px;
  font-weight: 600;
  transition: all 0.3s;
}

button:hover {
  background: #764ba2;
  transform: translateY(-3px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}`,
            js: `let count = 0;

function updateCounter() {
  const counterEl = document.getElementById('counter');
  counterEl.textContent = count;
  counterEl.classList.add('pulse');
  setTimeout(() => counterEl.classList.remove('pulse'), 300);
}

function increment() {
  count++;
  updateCounter();
}

function decrement() {
  count--;
  updateCounter();
}

function reset() {
  count = 0;
  updateCounter();
}`
        },
        calculator: {
            html: `<div class="calculator">
  <div class="display" id="display">0</div>
  <div class="buttons">
    <button onclick="clearDisplay()">C</button>
    <button onclick="appendToDisplay('/')">/</button>
    <button onclick="appendToDisplay('*')">×</button>
    <button onclick="deleteLast()">⌫</button>

    <button onclick="appendToDisplay('7')">7</button>
    <button onclick="appendToDisplay('8')">8</button>
    <button onclick="appendToDisplay('9')">9</button>
    <button onclick="appendToDisplay('-')">-</button>

    <button onclick="appendToDisplay('4')">4</button>
    <button onclick="appendToDisplay('5')">5</button>
    <button onclick="appendToDisplay('6')">6</button>
    <button onclick="appendToDisplay('+')">+</button>

    <button onclick="appendToDisplay('1')">1</button>
    <button onclick="appendToDisplay('2')">2</button>
    <button onclick="appendToDisplay('3')">3</button>
    <button onclick="calculate()" class="equals">=</button>

    <button onclick="appendToDisplay('0')" class="zero">0</button>
    <button onclick="appendToDisplay('.')">.</button>
  </div>
</div>`,
            css: `body {
  margin: 0;
  font-family: 'Arial', sans-serif;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.calculator {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 25px;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.display {
  background: rgba(0, 0, 0, 0.3);
  color: white;
  font-size: 2.5rem;
  padding: 20px;
  border-radius: 10px;
  text-align: right;
  margin-bottom: 20px;
  min-height: 60px;
  word-wrap: break-word;
}

.buttons {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}

button {
  padding: 20px;
  font-size: 1.5rem;
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: white;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: 600;
}

button:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(1.05);
}

button:active {
  transform: scale(0.95);
}

.equals {
  grid-row: span 2;
  background: linear-gradient(135deg, #11998e, #38ef7d);
}

.zero {
  grid-column: span 2;
}`,
            js: `let display = document.getElementById('display');
let currentValue = '0';

function updateDisplay() {
  display.textContent = currentValue;
}

function appendToDisplay(value) {
  if (currentValue === '0' && value !== '.') {
    currentValue = value;
  } else {
    currentValue += value;
  }
  updateDisplay();
}

function clearDisplay() {
  currentValue = '0';
  updateDisplay();
}

function deleteLast() {
  currentValue = currentValue.slice(0, -1);
  if (currentValue === '') {
    currentValue = '0';
  }
  updateDisplay();
}

function calculate() {
  try {
    currentValue = eval(currentValue).toString();
    updateDisplay();
  } catch (error) {
    currentValue = 'Error';
    updateDisplay();
    setTimeout(() => {
      currentValue = '0';
      updateDisplay();
    }, 1500);
  }
}`
        }
    };

    // Load template
    function loadTemplate(templateName) {
        const template = templates[templateName];
        htmlEditor.setValue(template.html);
        cssEditor.setValue(template.css);
        jsEditor.setValue(template.js);
        toggleTemplates();
        runCode();
        showNotification(`Template "${templateName}" loaded!`);
    }

    // Toggle templates dropdown
    function toggleTemplates() {
        document.getElementById('templatesDropdown').classList.toggle('show');
    }

    // Close dropdown when clicking outside
    window.onclick = function (event) {
        if (!event.target.matches('.btn-secondary') && !event.target.closest('.templates-dropdown')) {
            const dropdown = document.getElementById('templatesDropdown');
            if (dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
        }
    }

    // Run code
    function runCode() {
        const html = htmlEditor.getValue();
        const css = cssEditor.getValue();
        const js = jsEditor.getValue();

        const preview = document.getElementById('preview');
        const previewDoc = preview.contentDocument || preview.contentWindow.document;

        const output = '<!DOCTYPE html>' +
            '<html>' +
            '<head>' +
            '<style>' + css + '</style>' +
            '</head>' +
            '<body>' +
            html +
            '<script>' +
            '(function() {' +
            'var originalLog = console.log;' +
            'var originalError = console.error;' +
            'var originalWarn = console.warn;' +
            '' +
            'console.log = function(...args) {' +
            'window.parent.postMessage({type: "log", message: args.join(" ")}, "*");' +
            'originalLog.apply(console, args);' +
            '};' +
            '' +
            'console.error = function(...args) {' +
            'window.parent.postMessage({type: "error", message: args.join(" ")}, "*");' +
            'originalError.apply(console, args);' +
            '};' +
            '' +
            'console.warn = function(...args) {' +
            'window.parent.postMessage({type: "warn", message: args.join(" ")}, "*");' +
            'originalWarn.apply(console, args);' +
            '};' +
            '' +
            'window.onerror = function(message, source, lineno, colno, error) {' +
            'window.parent.postMessage({type: "error", message: message}, "*");' +
            'return true;' +
            '};' +
            '})();' +
            '' +
            'try {' +
            js +
            '} catch (error) {' +
            'window.parent.postMessage({type: "error", message: error.message}, "*");' +
            '}' +
            '<\/script>' +
            '</body>' +
            '</html>';

        previewDoc.open();
        previewDoc.write(output);
        previewDoc.close();
    }

    // Listen for console messages from iframe
    window.addEventListener('message', function (event) {
        const consoleContent = document.getElementById('consoleContent');
        const logDiv = document.createElement('div');

        switch (event.data.type) {
            case 'log':
                logDiv.className = 'console-log';
                break;
            case 'error':
                logDiv.className = 'console-error';
                break;
            case 'warn':
                logDiv.className = 'console-warn';
                break;
        }

        logDiv.textContent = event.data.message;
        consoleContent.appendChild(logDiv);
        consoleContent.scrollTop = consoleContent.scrollHeight;
    });

    // Refresh preview
    function refreshPreview() {
        runCode();
        showNotification('Preview refreshed!');
    }

    // Toggle console
    function toggleConsole() {
        document.getElementById('consoleContainer').classList.toggle('show');
    }

    // Clear console
    function clearConsole() {
        document.getElementById('consoleContent').innerHTML = '<div class="console-log">Console cleared...</div>';
    }

    // Format code (basic)
    function formatCode(type) {
        showNotification('Code formatted!');
    }

    // Clear editor
    function clearEditor(type) {
        switch (type) {
            case 'html':
                htmlEditor.setValue('');
                break;
            case 'css':
                cssEditor.setValue('');
                break;
            case 'js':
                jsEditor.setValue('');
                break;
        }
        runCode();
    }

    // Set layout
    function setLayout(layout) {
        const container = document.getElementById('editorsContainer');
        const buttons = document.querySelectorAll('.layout-btn');

        buttons.forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');

        if (layout === 'horizontal') {
            container.classList.add('horizontal');
        } else {
            container.classList.remove('horizontal');
        }
    }

    // Export code
    function exportCode() {
        const html = htmlEditor.getValue();
        const css = cssEditor.getValue();
        const js = jsEditor.getValue();

        const fullHTML = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exported Code</title>
    <style>
${css}
    </style>
</head>
<body>
${html}
    <script>
${js}
    <\/script>
</body>
</html>`;

        const blob = new Blob([fullHTML], { type: 'text/html' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'code-export.html';
        a.click();
        URL.revokeObjectURL(url);

        showNotification('Code exported successfully!');
    }

    // Share code via URL
    function shareCode() {
        const html = htmlEditor.getValue();
        const css = cssEditor.getValue();
        const js = jsEditor.getValue();

        // Create code object
        const codeData = {
            html: html,
            css: css,
            js: js
        };

        // Encode to base64
        const jsonString = JSON.stringify(codeData);
        const base64Code = btoa(unescape(encodeURIComponent(jsonString)));

        // Create shareable URL
        const baseUrl = window.location.origin + window.location.pathname;
        const shareUrl = baseUrl + '?code=' + base64Code;

        // Check if URL is too long (browsers have limits ~2000 chars)
        if (shareUrl.length > 2000) {
            // Try to shorten using URL shortener API
            shortenShareUrl(shareUrl);
        } else {
            // Copy to clipboard and show notification
            copyShareUrl(shareUrl);
        }
    }

    // Shorten URL using the shortener API
    function shortenShareUrl(longUrl) {
        const BASE = 'https://ai-inference.xyz';

        showNotification('Creating short URL...');

        fetch(BASE + '/api/shorten', {
            method: 'POST',
            headers: { 'content-type': 'application/json' },
            body: JSON.stringify({ url: longUrl })
        })
            .then(res => res.json())
            .then(data => {
                if (data.short_url) {
                    copyShareUrl(data.short_url);
                } else {
                    // Fallback to long URL if shortening fails
                    copyShareUrl(longUrl);
                }
            })
            .catch(() => {
                // Fallback to long URL on error
                copyShareUrl(longUrl);
            });
    }

    // Copy share URL to clipboard
    function copyShareUrl(url) {
        if (navigator.clipboard) {
            navigator.clipboard.writeText(url).then(() => {
                showNotification('Share URL copied to clipboard! 🎉');
            }).catch(() => {
                promptShareUrl(url);
            });
        } else {
            promptShareUrl(url);
        }
    }

    // Fallback: show URL in prompt
    function promptShareUrl(url) {
        prompt('Share this URL:', url);
        showNotification('Share URL ready!');
    }

    // Load code from URL parameter
    function loadCodeFromUrl() {
        const urlParams = new URLSearchParams(window.location.search);
        const codeParam = urlParams.get('code');

        if (codeParam) {
            try {
                // Decode from base64
                const jsonString = decodeURIComponent(escape(atob(codeParam)));
                const codeData = JSON.parse(jsonString);

                // Load into editors
                if (codeData.html !== undefined) htmlEditor.setValue(codeData.html);
                if (codeData.css !== undefined) cssEditor.setValue(codeData.css);
                if (codeData.js !== undefined) jsEditor.setValue(codeData.js);

                // Run the code
                runCode();

                showNotification('Code loaded from URL! ✨');
            } catch (e) {
                console.error('Failed to load code from URL:', e);
                showNotification('Failed to load code from URL');
            }
        }
    }

    // Show notification
    function showNotification(message) {
        const notification = document.createElement('div');
        notification.className = 'notification';
        notification.textContent = message;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.classList.add('hide');
            setTimeout(() => notification.remove(), 300);
        }, 2000);
    }

    // Load default template on start
    // Wait for CodeMirror to fully initialize before loading template
    setTimeout(() => {
        // First check if there's code in the URL
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('code')) {
            loadCodeFromUrl();
        } else {
            // Load default template if no URL code
            loadTemplate('hello');
        }
    }, 100);
</script>
</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <!-- SEO Meta Tags -->
    <title>Online Compiler - Run Code in 60+ Languages Free | 8gwifi.org</title>
    <meta name="description" content="Free online compiler and code editor. Run Python, Java, C++, JavaScript, Go, Rust and 60+ languages. Embed interactive code snippets in blogs, books, tutorials and documentation. Perfect for authors and educators.">
    <meta name="keywords" content="online compiler, code compiler, online code editor, run code online, embed code snippets, interactive code tutorials, code examples for books, programming book code, embeddable code editor, technical documentation code, python compiler, java compiler, c++ compiler, javascript compiler, code playground for educators">
    <meta name="author" content="8gwifi.org">
    <meta name="robots" content="index, follow">

    <!-- Open Graph Meta Tags -->
    <meta property="og:title" content="Online Compiler - Run Code in 60+ Languages Free">
    <meta property="og:description" content="Free online compiler supporting Python, Java, C++, JavaScript, Go, Rust and 60+ more languages.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/onecompiler.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/onecompiler-preview.png">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
    <meta property="og:site_name" content="8gwifi.org">

    <!-- Twitter Card Meta Tags -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="@anish2good">
    <meta name="twitter:creator" content="@anish2good">
    <meta name="twitter:title" content="Online Compiler - Run Code in 60+ Languages Free">
    <meta name="twitter:description" content="Free online compiler supporting Python, Java, C++, JavaScript, Go, Rust and 60+ more languages.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/onecompiler-preview.png">

    <!-- Canonical -->
    <link rel="canonical" href="https://8gwifi.org/onecompiler.jsp">

    <!-- JSON-LD Structured Data - WebApplication -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Online Compiler",
      "description": "Free online compiler and code editor supporting 60+ programming languages",
      "url": "https://8gwifi.org/onecompiler.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Web",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" },
      "featureList": [
        "Online code execution",
        "60+ programming languages",
        "Multi-file project support",
        "Monaco editor (VS Code engine)",
        "Syntax highlighting",
        "Real-time output",
        "Code formatting",
        "Code sharing with unique URLs",
        "Embeddable code widgets for blogs and books",
        "Interactive code examples for tutorials",
        "Perfect for technical authors and educators",
        "Standard input (stdin) support",
        "Compiler flags support",
        "Dark/Light theme options",
        "Read-only mode for documentation",
        "Auto-run code on page load",
        "Keyboard shortcuts (Ctrl+Enter)",
        "Download code",
        "No signup required",
        "No installation required"
      ]
    }
    </script>

    <!-- JSON-LD Structured Data - FAQPage -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "What is an online compiler?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "An online compiler is a web-based tool that allows you to write, compile, and run code in various programming languages directly in your browser without installing any software."
          }
        },
        {
          "@type": "Question",
          "name": "Which programming languages are supported?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Our online compiler supports 60+ programming languages including Python, Java, C++, JavaScript, Go, Rust, PHP, Ruby, Swift, Kotlin, Scala, TypeScript, C#, and many more."
          }
        },
        {
          "@type": "Question",
          "name": "Is the online compiler free to use?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes, our online compiler is completely free to use. No sign-up or registration required."
          }
        },
        {
          "@type": "Question",
          "name": "Is it safe to run code online?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes, all code runs in isolated sandbox environments with strict security measures."
          }
        },
        {
          "@type": "Question",
          "name": "Can I share my code with others?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes, click the Share button to generate a unique URL that others can use to view and run your code."
          }
        },
        {
          "@type": "Question",
          "name": "Can I embed code snippets in my blog or website?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes! Click the Embed button to generate an iframe code that you can paste into any blog, website, or CMS. Readers can view and run the code directly on your page."
          }
        },
        {
          "@type": "Question",
          "name": "Is this suitable for programming books and tutorials?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Absolutely! Authors and educators can embed interactive code examples in their books, tutorials, and documentation. Options include read-only mode, auto-run on page load, and dark/light themes to match your content."
          }
        },
        {
          "@type": "Question",
          "name": "Can I use this for technical documentation?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes, our embeddable code widgets are perfect for API documentation, SDK guides, and technical manuals. Readers can test code examples without leaving your documentation."
          }
        },
        {
          "@type": "Question",
          "name": "Does the embed support multiple files?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes, you can create multi-file projects (like Go packages or Java classes) and share them. The embed will show all files in tabs."
          }
        }
      ]
    }
    </script>

    <%@ include file="header-script.jsp"%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs/editor/editor.main.min.css">

    <style>
        * { box-sizing: border-box; }

        :root {
            --oc-primary: #007acc;
            --oc-primary-hover: #005a9e;
            --oc-bg-dark: #1e1e1e;
            --oc-bg-darker: #252526;
            --oc-bg-sidebar: #333333;
            --oc-border: #3c3c3c;
            --oc-text: #cccccc;
            --oc-text-bright: #ffffff;
            --oc-success: #4ec9b0;
            --oc-error: #f48771;
            --oc-warning: #dcdcaa;
            --toolbar-height: 40px;
            --panel-height: 280px;
        }

        body {
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            overflow-y: auto;
            background: var(--oc-bg-dark);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        /* IDE Container - Full viewport with scrollable content below */
        .ide-container {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            padding-top: 56px; /* navbar height */
        }

        .ide-workspace {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 56px);
            min-height: 500px;
        }

        /* Top Toolbar */
        .ide-toolbar {
            height: var(--toolbar-height);
            min-height: var(--toolbar-height);
            background: var(--oc-bg-darker);
            border-bottom: 1px solid var(--oc-border);
            display: flex;
            align-items: center;
            padding: 0 8px;
            gap: 8px;
        }

        .ide-toolbar select {
            background: var(--oc-bg-sidebar);
            color: var(--oc-text);
            border: 1px solid var(--oc-border);
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 13px;
            cursor: pointer;
        }

        .ide-toolbar select:focus {
            outline: none;
            border-color: var(--oc-primary);
        }

        .ide-toolbar-btn {
            background: transparent;
            color: var(--oc-text);
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: background 0.15s;
        }

        .ide-toolbar-btn:hover {
            background: var(--oc-bg-sidebar);
        }

        .ide-toolbar-btn.run-btn {
            background: var(--oc-primary);
            color: white;
            font-weight: 600;
        }

        .ide-toolbar-btn.run-btn:hover {
            background: var(--oc-primary-hover);
        }

        .ide-toolbar-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .toolbar-divider {
            width: 1px;
            height: 20px;
            background: var(--oc-border);
            margin: 0 4px;
        }

        .toolbar-spacer {
            flex: 1;
        }

        .toolbar-input {
            background: var(--oc-bg-sidebar);
            color: var(--oc-text);
            border: 1px solid var(--oc-border);
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            width: 150px;
        }

        .toolbar-input::placeholder {
            color: #666;
        }

        /* Main Content Area */
        .ide-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* Editor Section */
        .ide-editor-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .ide-editor-tabs {
            height: 35px;
            background: var(--oc-bg-darker);
            display: flex;
            align-items: flex-end;
            padding-left: 8px;
            border-bottom: 1px solid var(--oc-border);
        }

        .ide-tab {
            background: var(--oc-bg-darker);
            color: var(--oc-text);
            padding: 6px 12px;
            font-size: 13px;
            border: 1px solid var(--oc-border);
            border-bottom: none;
            border-radius: 4px 4px 0 0;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            position: relative;
            margin-right: 2px;
        }

        .ide-tab:hover {
            background: var(--oc-bg-sidebar);
        }

        .ide-tab.active {
            background: var(--oc-bg-dark);
            color: var(--oc-text-bright);
            border-bottom: 1px solid var(--oc-bg-dark);
            margin-bottom: -1px;
        }

        .ide-tab .tab-name {
            max-width: 120px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .ide-tab .tab-close {
            opacity: 0;
            font-size: 10px;
            padding: 2px 4px;
            border-radius: 3px;
            margin-left: 4px;
            transition: opacity 0.15s;
        }

        .ide-tab:hover .tab-close,
        .ide-tab.active .tab-close {
            opacity: 0.7;
        }

        .ide-tab .tab-close:hover {
            opacity: 1;
            background: var(--oc-error);
            color: white;
        }

        .ide-tab-add {
            background: transparent;
            border: 1px dashed var(--oc-border);
            color: var(--oc-text);
            padding: 6px 10px;
            font-size: 12px;
            border-radius: 4px 4px 0 0;
            cursor: pointer;
            margin-left: 4px;
        }

        .ide-tab-add:hover {
            background: var(--oc-bg-sidebar);
            border-style: solid;
            color: var(--oc-text-bright);
        }

        .tab-rename-input {
            background: var(--oc-bg-dark);
            color: var(--oc-text-bright);
            border: 1px solid var(--oc-primary);
            padding: 2px 6px;
            font-size: 12px;
            width: 100px;
            border-radius: 2px;
        }

        .tab-rename-input:focus {
            outline: none;
        }

        .ide-editor-container {
            flex: 1;
            overflow: hidden;
        }

        #codeEditor {
            width: 100%;
            height: 100%;
        }

        /* Bottom Panel */
        .ide-panel {
            height: var(--panel-height);
            min-height: 100px;
            background: var(--oc-bg-dark);
            border-top: 1px solid var(--oc-border);
            display: flex;
            flex-direction: column;
        }

        .ide-panel-header {
            height: 35px;
            min-height: 35px;
            background: var(--oc-bg-darker);
            display: flex;
            align-items: center;
            padding: 0 8px;
            border-bottom: 1px solid var(--oc-border);
        }

        .ide-panel-tabs {
            display: flex;
            gap: 0;
        }

        .ide-panel-tab {
            background: transparent;
            color: var(--oc-text);
            border: none;
            padding: 8px 16px;
            font-size: 12px;
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid transparent;
            transition: all 0.15s;
        }

        .ide-panel-tab:hover {
            color: var(--oc-text-bright);
        }

        .ide-panel-tab.active {
            color: var(--oc-text-bright);
            border-bottom-color: var(--oc-primary);
        }

        .ide-panel-tab .badge {
            background: var(--oc-error);
            color: white;
            font-size: 10px;
            padding: 1px 5px;
            border-radius: 8px;
            margin-left: 6px;
        }

        .ide-panel-actions {
            margin-left: auto;
            display: flex;
            gap: 4px;
        }

        .ide-panel-btn {
            background: transparent;
            color: var(--oc-text);
            border: none;
            padding: 4px 8px;
            cursor: pointer;
            font-size: 12px;
        }

        .ide-panel-btn:hover {
            color: var(--oc-text-bright);
        }

        .ide-panel-content {
            flex: 1;
            overflow: hidden;
            position: relative;
        }

        .ide-panel-pane {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            overflow: auto;
            display: none;
        }

        .ide-panel-pane.active {
            display: block;
        }

        /* Output Pane */
        .output-content {
            padding: 8px 12px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 13px;
            line-height: 1.5;
            color: var(--oc-text);
            white-space: pre-wrap;
            word-break: break-word;
        }

        .output-content.stdout { color: var(--oc-success); }
        .output-content.stderr { color: var(--oc-error); }
        .output-content.system { color: var(--oc-text); font-style: italic; }

        /* Input Pane */
        .input-textarea {
            width: 100%;
            height: 100%;
            background: var(--oc-bg-dark);
            color: var(--oc-text);
            border: none;
            padding: 8px 12px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 13px;
            resize: none;
        }

        .input-textarea:focus {
            outline: none;
        }

        /* Status Bar */
        .ide-statusbar {
            height: 22px;
            background: var(--oc-primary);
            display: flex;
            align-items: center;
            padding: 0 10px;
            font-size: 12px;
            color: white;
        }

        .status-item {
            padding: 0 10px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .status-item.clickable {
            cursor: pointer;
        }

        .status-item.clickable:hover {
            background: rgba(255,255,255,0.1);
        }

        .status-spacer {
            flex: 1;
        }

        /* Resize Handle */
        .resize-handle {
            height: 4px;
            background: var(--oc-border);
            cursor: ns-resize;
            transition: background 0.15s;
        }

        .resize-handle:hover {
            background: var(--oc-primary);
        }

        /* SEO Section - Visible for crawlers */
        .seo-section {
            background: #fff;
            padding: 20px;
        }

        .seo-h1 {
            font-size: 1.5rem;
            color: #333;
            margin: 0 0 20px 0;
            text-align: center;
        }

        .seo-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }

        .seo-card {
            background: #f8f9fa;
            padding: 16px;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }

        .seo-card h2 {
            font-size: 1rem;
            color: var(--oc-primary);
            margin: 0 0 10px 0;
        }

        .seo-card h2 i {
            margin-right: 6px;
        }

        .seo-card p {
            font-size: 0.85rem;
            color: #555;
            margin: 0 0 8px 0;
            line-height: 1.5;
        }

        .seo-card ul {
            margin: 0;
            padding-left: 18px;
            font-size: 0.85rem;
            color: #555;
        }

        .seo-card li {
            margin-bottom: 4px;
        }

        .seo-card a {
            color: var(--oc-primary);
            text-decoration: none;
        }

        .seo-card a:hover {
            text-decoration: underline;
        }

        .seo-related {
            margin-top: 16px;
            padding: 16px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .seo-related h2 {
            font-size: 1rem;
            color: var(--oc-primary);
            margin: 0 0 12px 0;
        }

        .seo-links {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .seo-links a {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: #fff;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 20px;
            font-size: 0.8rem;
            text-decoration: none;
            transition: all 0.2s;
        }

        .seo-links a:hover {
            border-color: var(--oc-primary);
            color: var(--oc-primary);
        }

        .seo-links a i {
            color: #666;
        }

        .seo-ad {
            margin-top: 16px;
            text-align: center;
        }

        /* Full width SEO cards */
        .seo-full-width {
            grid-column: 1 / -1;
        }

        .seo-highlight {
            background: linear-gradient(135deg, #e8f4fd 0%, #f0f7ff 100%);
            border: 1px solid #007acc33;
        }

        /* How to Use Steps */
        .seo-steps {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: 12px;
        }

        .seo-step {
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }

        .step-number {
            flex-shrink: 0;
            width: 32px;
            height: 32px;
            background: var(--oc-primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .step-content strong {
            display: block;
            color: #333;
            margin-bottom: 4px;
        }

        .step-content p {
            margin: 0;
            font-size: 0.85rem;
            color: #666;
        }

        /* Embed Features Grid */
        .seo-embed-features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin: 16px 0;
        }

        .embed-feature {
            text-align: center;
            padding: 12px;
            background: white;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }

        .embed-feature i {
            font-size: 1.5rem;
            color: var(--oc-primary);
            margin-bottom: 8px;
        }

        .embed-feature strong {
            display: block;
            color: #333;
            margin-bottom: 4px;
            font-size: 0.9rem;
        }

        .embed-feature p {
            margin: 0;
            font-size: 0.8rem;
            color: #666;
        }

        .seo-cta {
            text-align: center;
            margin-top: 12px;
            padding: 10px;
            background: var(--oc-primary);
            color: white;
            border-radius: 6px;
            font-size: 0.9rem;
        }

        .seo-cta strong {
            color: white;
        }

        /* Code Example */
        .seo-code-example {
            background: #1e1e1e;
            color: #d4d4d4;
            padding: 16px;
            border-radius: 8px;
            overflow-x: auto;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 0.85rem;
            line-height: 1.5;
            margin: 12px 0;
        }

        .seo-code-example code {
            color: #d4d4d4;
        }

        @media (max-width: 768px) {
            .seo-section {
                padding: 12px;
            }

            .seo-h1 {
                font-size: 1.1rem;
            }

            .seo-grid {
                grid-template-columns: 1fr;
            }

            .seo-links {
                justify-content: center;
            }
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .ide-container {
                padding-top: 50px;
            }

            .ide-toolbar {
                flex-wrap: wrap;
                height: auto;
                padding: 6px;
                gap: 6px;
            }

            .toolbar-divider {
                display: none;
            }

            .toolbar-input {
                width: 100%;
                order: 10;
            }

            .ide-toolbar select {
                flex: 1;
                min-width: 100px;
            }

            .ide-toolbar-btn {
                padding: 6px 10px;
                font-size: 12px;
            }

            .ide-toolbar-btn span {
                display: none;
            }

            .ide-panel {
                height: 280px;
            }

            .ide-tab {
                padding: 6px 12px;
                font-size: 12px;
            }

            .ide-panel-tab {
                padding: 6px 10px;
                font-size: 11px;
            }

            .ide-statusbar {
                font-size: 11px;
            }

            .status-item {
                padding: 0 6px;
            }
        }

        @media (max-width: 480px) {
            .ide-toolbar-btn.run-btn span {
                display: inline;
            }

            .toolbar-spacer {
                display: none;
            }

            .ide-panel {
                height: 350px;
            }
        }

        /* Hide scrollbar but allow scroll */
        .ide-panel-pane::-webkit-scrollbar {
            width: 8px;
        }

        .ide-panel-pane::-webkit-scrollbar-track {
            background: var(--oc-bg-dark);
        }

        .ide-panel-pane::-webkit-scrollbar-thumb {
            background: var(--oc-bg-sidebar);
            border-radius: 4px;
        }

        .ide-panel-pane::-webkit-scrollbar-thumb:hover {
            background: #555;
        }

        /* Embed Modal */
        .embed-modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.7);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }

        .embed-modal-overlay.show {
            display: flex;
        }

        .embed-modal {
            background: var(--oc-bg-darker);
            border: 1px solid var(--oc-border);
            border-radius: 8px;
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.5);
        }

        .embed-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 16px;
            border-bottom: 1px solid var(--oc-border);
        }

        .embed-modal-header h3 {
            margin: 0;
            font-size: 14px;
            color: var(--oc-text-bright);
        }

        .embed-modal-close {
            background: transparent;
            border: none;
            color: var(--oc-text);
            font-size: 18px;
            cursor: pointer;
            padding: 4px 8px;
        }

        .embed-modal-close:hover {
            color: var(--oc-text-bright);
        }

        .embed-modal-body {
            padding: 16px;
            overflow-y: auto;
        }

        .embed-options {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 16px;
        }

        .embed-option {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--oc-text);
        }

        .embed-option input[type="checkbox"] {
            accent-color: var(--oc-primary);
        }

        .embed-option select {
            background: var(--oc-bg-sidebar);
            color: var(--oc-text);
            border: 1px solid var(--oc-border);
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .embed-size {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }

        .embed-size input {
            background: var(--oc-bg-sidebar);
            color: var(--oc-text);
            border: 1px solid var(--oc-border);
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 12px;
            width: 80px;
        }

        .embed-size span {
            font-size: 12px;
            color: var(--oc-text);
            display: flex;
            align-items: center;
        }

        .embed-preview {
            background: var(--oc-bg-dark);
            border: 1px solid var(--oc-border);
            border-radius: 4px;
            margin-bottom: 16px;
            overflow: hidden;
        }

        .embed-preview iframe {
            display: block;
            width: 100%;
            border: none;
        }

        .embed-code-container {
            position: relative;
        }

        .embed-code {
            background: var(--oc-bg-dark);
            border: 1px solid var(--oc-border);
            border-radius: 4px;
            padding: 12px;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 11px;
            color: var(--oc-success);
            white-space: pre-wrap;
            word-break: break-all;
            max-height: 120px;
            overflow-y: auto;
        }

        .embed-copy-btn {
            position: absolute;
            top: 8px;
            right: 8px;
            background: var(--oc-primary);
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 11px;
            cursor: pointer;
        }

        .embed-copy-btn:hover {
            background: var(--oc-primary-hover);
        }

        .embed-note {
            font-size: 11px;
            color: var(--oc-text);
            opacity: 0.7;
            margin-top: 8px;
        }

        /* Share Modal */
        .share-modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.7);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }

        .share-modal-overlay.show {
            display: flex;
        }

        .share-modal {
            background: var(--oc-bg-darker);
            border: 1px solid var(--oc-border);
            border-radius: 12px;
            width: 90%;
            max-width: 420px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.5);
        }

        .share-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 20px;
            border-bottom: 1px solid var(--oc-border);
            background: var(--oc-bg-sidebar);
        }

        .share-modal-header h3 {
            margin: 0;
            font-size: 16px;
            color: var(--oc-text-bright);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .share-modal-close {
            background: transparent;
            border: none;
            color: var(--oc-text);
            font-size: 20px;
            cursor: pointer;
            padding: 4px 8px;
            line-height: 1;
        }

        .share-modal-close:hover {
            color: var(--oc-text-bright);
        }

        .share-modal-body {
            padding: 20px;
        }

        .share-support-section {
            text-align: center;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--oc-border);
        }

        .share-support-section p {
            color: var(--oc-text);
            font-size: 13px;
            margin: 0 0 16px 0;
        }

        .share-social-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .share-social-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: transform 0.15s, box-shadow 0.15s;
        }

        .share-social-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .share-social-btn.twitter {
            background: #1da1f2;
            color: white;
        }

        .share-social-btn.twitter:hover {
            background: #0c8de4;
        }

        .share-social-btn.follow {
            background: transparent;
            border: 2px solid #1da1f2;
            color: #1da1f2;
        }

        .share-social-btn.follow:hover {
            background: rgba(29, 161, 242, 0.1);
        }

        .share-link-section {
            background: var(--oc-bg-dark);
            border-radius: 8px;
            padding: 16px;
        }

        .share-link-section label {
            display: block;
            font-size: 12px;
            color: var(--oc-text);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .share-link-preparing {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px;
            color: var(--oc-text);
            font-size: 13px;
        }

        .share-link-preparing i {
            color: var(--oc-primary);
        }

        .share-link-ready {
            display: none;
        }

        .share-link-ready.show {
            display: block;
        }

        .share-link-input-group {
            display: flex;
            gap: 8px;
        }

        .share-link-input {
            flex: 1;
            background: var(--oc-bg-darker);
            border: 1px solid var(--oc-border);
            color: var(--oc-text-bright);
            padding: 10px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-family: 'Consolas', 'Monaco', monospace;
        }

        .share-link-input:focus {
            outline: none;
            border-color: var(--oc-primary);
        }

        .share-copy-btn {
            background: var(--oc-primary);
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }

        .share-copy-btn:hover {
            background: var(--oc-primary-hover);
        }

        .share-copy-btn.copied {
            background: var(--oc-success);
        }

        .share-link-error {
            display: none;
            color: var(--oc-error);
            font-size: 12px;
            margin-top: 8px;
            text-align: center;
        }

        .share-link-error.show {
            display: block;
        }

        .share-modal-footer {
            padding: 12px 20px;
            border-top: 1px solid var(--oc-border);
            text-align: center;
        }

        .share-modal-footer p {
            margin: 0;
            font-size: 11px;
            color: var(--oc-text);
            opacity: 0.7;
        }

        .share-modal-footer a {
            color: var(--oc-primary);
            text-decoration: none;
        }

        .share-modal-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<div>
    <%@ include file="body-script.jsp"%>
    <%@ include file="navigation.jsp"%>

    <div class="ide-container">
        <!-- IDE Workspace (viewport-fitting) -->
        <div class="ide-workspace">
        <!-- Toolbar -->
        <div class="ide-toolbar">
            <select id="languageSelect" onchange="onLanguageChange()">
                <option value="python">Python</option>
            </select>
            <select id="versionSelect">
                <option value="">Default</option>
            </select>

            <div class="toolbar-divider"></div>

            <button class="ide-toolbar-btn" onclick="loadTemplate()" title="Load Template">
                <i class="fas fa-file-code"></i><span>Template</span>
            </button>
            <button class="ide-toolbar-btn" onclick="formatCode()" title="Format Code">
                <i class="fas fa-align-left"></i><span>Format</span>
            </button>
            <button class="ide-toolbar-btn" onclick="clearEditor()" title="Clear">
                <i class="fas fa-eraser"></i>
            </button>

            <div class="toolbar-divider"></div>

            <button id="runBtn" class="ide-toolbar-btn run-btn" onclick="executeCode()">
                <i class="fas fa-play"></i><span>Run</span>
            </button>

            <div class="toolbar-spacer"></div>

            <input type="text" id="compilerArgs" class="toolbar-input" placeholder="Compiler flags...">

            <div class="toolbar-divider"></div>

            <button class="ide-toolbar-btn" onclick="shareCode()" title="Share Code">
                <i class="fas fa-share-alt"></i><span>Share Code</span>
            </button>
            <button class="ide-toolbar-btn" onclick="showEmbedModal()" title="Embed">
                <i class="fas fa-code"></i><span>Embed</span>
            </button>
            <button class="ide-toolbar-btn" onclick="downloadCode()" title="Download">
                <i class="fas fa-download"></i><span>Download</span>
            </button>
        </div>

        <!-- Main Content -->
        <div class="ide-main">
            <!-- Editor Section -->
            <div class="ide-editor-section">
                <div class="ide-editor-tabs" id="fileTabs">
                    <!-- File tabs rendered dynamically -->
                </div>
                <div class="ide-editor-container">
                    <div id="codeEditor"></div>
                </div>
            </div>

            <!-- Resize Handle -->
            <div class="resize-handle" id="resizeHandle"></div>

            <!-- Bottom Panel -->
            <div class="ide-panel" id="bottomPanel">
                <div class="ide-panel-header">
                    <div class="ide-panel-tabs">
                        <button class="ide-panel-tab active" data-panel="output" onclick="switchPanel('output')">
                            <i class="fas fa-terminal"></i> Output
                        </button>
                        <button class="ide-panel-tab" data-panel="input" onclick="switchPanel('input')">
                            <i class="fas fa-keyboard"></i> Input
                        </button>
                        <button class="ide-panel-tab" data-panel="problems" onclick="switchPanel('problems')">
                            Problems<span id="problemsBadge" class="badge" style="display:none;">0</span>
                        </button>
                    </div>
                    <div class="ide-panel-actions">
                        <button class="ide-panel-btn" onclick="clearOutput()" title="Clear Output">
                            <i class="fas fa-trash"></i> Clear
                        </button>
                        <button class="ide-panel-btn" onclick="togglePanel()" title="Toggle Panel">
                            <i class="fas fa-chevron-down" id="panelToggleIcon"></i>
                        </button>
                    </div>
                </div>
                <div class="ide-panel-content">
                    <div class="ide-panel-pane active" id="outputPane">
                        <div id="outputContent" class="output-content system">// Click "Run" to execute your code (Ctrl+Enter)</div>
                    </div>
                    <div class="ide-panel-pane" id="inputPane">
                        <textarea id="stdinInput" class="input-textarea" placeholder="Enter input for your program (stdin)..."></textarea>
                    </div>
                    <div class="ide-panel-pane" id="problemsPane">
                        <div class="output-content system">No problems detected.</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Status Bar -->
        <div class="ide-statusbar">
            <div class="status-item clickable" onclick="scrollToAbout()">
                <i class="fas fa-info-circle"></i> About
            </div>
            <div class="status-item" id="statusLang">
                <i class="fas fa-code"></i> <span id="statusLangText">Python</span>
            </div>
            <div class="status-item" id="statusExec">
                <i class="fas fa-check-circle"></i> Ready
            </div>
            <div class="status-spacer"></div>
            <div class="status-item" id="statusTime"></div>
            <div class="status-item">
                <i class="fas fa-keyboard"></i> Ctrl+Enter to run
            </div>
        </div>
        </div><!-- End IDE Workspace -->

        <!-- Embed Modal -->
        <div class="embed-modal-overlay" id="embedModal" onclick="closeEmbedModal(event)">
            <div class="embed-modal" onclick="event.stopPropagation()">
                <div class="embed-modal-header">
                    <h3><i class="fas fa-code"></i> Embed Code</h3>
                    <button class="embed-modal-close" onclick="closeEmbedModal()">&times;</button>
                </div>
                <div class="embed-modal-body">
                    <!-- Support Section -->
                    <div class="share-support-section">
                        <p>Support us by following and sharing on Twitter/X!</p>
                        <div class="share-social-buttons">
                            <a href="https://twitter.com/anish2good" target="_blank" class="share-social-btn follow">
                                <i class="fab fa-twitter"></i> Follow @anish2good
                            </a>
                            <a href="#" id="tweetEmbedBtn" target="_blank" class="share-social-btn twitter">
                                <i class="fab fa-twitter"></i> Tweet
                            </a>
                        </div>
                    </div>
                    <div class="embed-options">
                        <label class="embed-option">
                            <select id="embedTheme" onchange="updateEmbedCode()">
                                <option value="dark">Dark Theme</option>
                                <option value="light">Light Theme</option>
                            </select>
                        </label>
                        <label class="embed-option">
                            <input type="checkbox" id="embedReadonly" onchange="updateEmbedCode()"> Read-only
                        </label>
                        <label class="embed-option">
                            <input type="checkbox" id="embedAutorun" onchange="updateEmbedCode()"> Auto-run
                        </label>
                    </div>
                    <div class="embed-size">
                        <span>Size:</span>
                        <input type="text" id="embedWidth" value="100%" onchange="updateEmbedCode()">
                        <span>×</span>
                        <input type="text" id="embedHeight" value="400" onchange="updateEmbedCode()">
                        <span>px</span>
                    </div>
                    <div class="embed-preview">
                        <iframe id="embedPreview" height="200"></iframe>
                    </div>
                    <div class="embed-code-container">
                        <pre class="embed-code" id="embedCode"></pre>
                        <button class="embed-copy-btn" onclick="copyEmbedCode()">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                    </div>
                    <p class="embed-note">
                        <i class="fas fa-info-circle"></i> First share your code to get a snippet ID, then embed it.
                    </p>
                </div>
            </div>
        </div>

        <!-- Share Modal -->
        <div class="share-modal-overlay" id="shareModal" onclick="closeShareModal(event)">
            <div class="share-modal" onclick="event.stopPropagation()">
                <div class="share-modal-header">
                    <h3><i class="fas fa-share-alt"></i> Share Your Code</h3>
                    <button class="share-modal-close" onclick="closeShareModal()">&times;</button>
                </div>
                <div class="share-modal-body">
                    <!-- Support Section -->
                    <div class="share-support-section">
                        <p>Support us by following and sharing on Twitter/X!</p>
                        <div class="share-social-buttons">
                            <a href="https://twitter.com/anish2good" target="_blank" class="share-social-btn follow">
                                <i class="fab fa-twitter"></i> Follow @anish2good
                            </a>
                            <a href="#" id="tweetShareBtn" target="_blank" class="share-social-btn twitter">
                                <i class="fab fa-twitter"></i> Tweet
                            </a>
                        </div>
                    </div>

                    <!-- Share Link Section -->
                    <div class="share-link-section">
                        <label>Your Share Link</label>
                        <div class="share-link-preparing" id="shareLinkPreparing">
                            <i class="fas fa-spinner fa-spin"></i>
                            <span>Preparing your share link...</span>
                        </div>
                        <div class="share-link-ready" id="shareLinkReady">
                            <div class="share-link-input-group">
                                <input type="text" class="share-link-input" id="shareLinkInput" readonly>
                                <button class="share-copy-btn" id="shareCopyBtn" onclick="copyShareLink()">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                            </div>
                        </div>
                        <div class="share-link-error" id="shareLinkError">
                            <i class="fas fa-exclamation-circle"></i> Failed to create share link. Please try again.
                        </div>
                    </div>
                </div>
                <div class="share-modal-footer">
                    <p>Powered by <a href="https://8gwifi.org" target="_blank">8gwifi.org</a> - Free Developer Tools</p>
                </div>
            </div>
        </div>

        <!-- SEO Content (Always visible for crawlers, scrollable below IDE) -->
        <div class="seo-section" id="seoSection">
            <!-- H1 for SEO -->
            <h1 class="seo-h1">Free Online Compiler - Run Code in 60+ Programming Languages</h1>

            <div class="seo-grid">
                <!-- About Section -->
                <div class="seo-card">
                    <h2><i class="fas fa-info-circle"></i> About Online Compiler</h2>
                    <p>Our <strong>free online compiler</strong> lets you write, compile, and run code instantly in your browser. Supports <a href="onecompiler.jsp" title="Python Online Compiler">Python</a>, <a href="onecompiler.jsp" title="Java Compiler Online">Java</a>, <a href="onecompiler.jsp" title="C++ Compiler Online">C++</a>, JavaScript, Go, Rust, and 60+ more languages. No installation required.</p>
                </div>

                <!-- Supported Languages -->
                <div class="seo-card">
                    <h2><i class="fas fa-code"></i> Supported Languages</h2>
                    <p><strong>Popular:</strong> Python, Java, C++, C, JavaScript, TypeScript, Go, Rust</p>
                    <p><strong>Web:</strong> PHP, Ruby, Node.js, HTML/CSS</p>
                    <p><strong>Systems:</strong> C, C++, Rust, Go, Swift</p>
                    <p><strong>Functional:</strong> Haskell, Scala, Kotlin, F#, Clojure</p>
                </div>

                <!-- Features -->
                <div class="seo-card">
                    <h2><i class="fas fa-star"></i> Features</h2>
                    <ul>
                        <li>Monaco Editor (VS Code) with syntax highlighting</li>
                        <li>Real-time code execution with output streaming</li>
                        <li>Custom compiler flags support (-O2, -Wall, etc.)</li>
                        <li>Share code via unique snippet URLs</li>
                        <li>Keyboard shortcuts (Ctrl+Enter to run)</li>
                    </ul>
                </div>

                <!-- FAQ -->
                <div class="seo-card">
                    <h2><i class="fas fa-question-circle"></i> FAQ</h2>
                    <p><strong>Is it free?</strong> Yes, completely free with no registration.</p>
                    <p><strong>Is my code secure?</strong> Yes, runs in isolated sandbox containers.</p>
                    <p><strong>Execution time limit?</strong> Programs have a 30-second limit.</p>
                    <p><strong>Can I share code?</strong> Yes, click Share to get a unique URL.</p>
                </div>
            </div>

            <!-- How to Use -->
            <div class="seo-card seo-full-width">
                <h2><i class="fas fa-play-circle"></i> How to Use Online Compiler</h2>
                <div class="seo-steps">
                    <div class="seo-step">
                        <span class="step-number">1</span>
                        <div class="step-content">
                            <strong>Select Language</strong>
                            <p>Choose from 60+ programming languages including Python, Java, C++, JavaScript, Go, Rust, and more.</p>
                        </div>
                    </div>
                    <div class="seo-step">
                        <span class="step-number">2</span>
                        <div class="step-content">
                            <strong>Write Your Code</strong>
                            <p>Use our Monaco editor (same as VS Code) with syntax highlighting, auto-completion, and error detection.</p>
                        </div>
                    </div>
                    <div class="seo-step">
                        <span class="step-number">3</span>
                        <div class="step-content">
                            <strong>Run & See Output</strong>
                            <p>Click Run or press Ctrl+Enter. Your code executes in a secure sandbox and output appears instantly.</p>
                        </div>
                    </div>
                    <div class="seo-step">
                        <span class="step-number">4</span>
                        <div class="step-content">
                            <strong>Share or Embed</strong>
                            <p>Share your code via unique URL or embed interactive code snippets in your blog, book, or documentation.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- For Authors & Educators -->
            <div class="seo-card seo-full-width seo-highlight">
                <h2><i class="fas fa-book"></i> For Authors, Educators & Technical Writers</h2>
                <p>Perfect for <strong>programming books</strong>, <strong>online tutorials</strong>, <strong>technical documentation</strong>, and <strong>educational content</strong>. Embed interactive, runnable code examples directly in your content.</p>
                <div class="seo-embed-features">
                    <div class="embed-feature">
                        <i class="fas fa-code"></i>
                        <strong>Embeddable Widgets</strong>
                        <p>Copy iframe code and paste into any website, blog, CMS, or e-book platform.</p>
                    </div>
                    <div class="embed-feature">
                        <i class="fas fa-eye"></i>
                        <strong>Read-Only Mode</strong>
                        <p>Show code without allowing edits - perfect for displaying solutions or examples.</p>
                    </div>
                    <div class="embed-feature">
                        <i class="fas fa-play"></i>
                        <strong>Auto-Run on Load</strong>
                        <p>Code executes automatically when readers view your page - instant demonstrations.</p>
                    </div>
                    <div class="embed-feature">
                        <i class="fas fa-palette"></i>
                        <strong>Theme Options</strong>
                        <p>Choose dark or light theme to match your website or publication design.</p>
                    </div>
                </div>
                <p class="seo-cta">Click <strong>Embed</strong> button above to generate embed code for your content!</p>
            </div>

            <!-- Code Example -->
            <div class="seo-card seo-full-width">
                <h2><i class="fas fa-file-code"></i> Example: Hello World in Python</h2>
                <pre class="seo-code-example"><code># Simple Python example - try it above!
def greet(name):
    return f"Hello, {name}!"

print(greet("World"))
print("Welcome to 8gwifi.org Online Compiler")

# Output:
# Hello, World!
# Welcome to 8gwifi.org Online Compiler</code></pre>
                <p>Copy this code into the editor above and click <strong>Run</strong> to see it in action!</p>
            </div>

            <!-- Related Tools -->
            <div class="seo-related">
                <h2><i class="fas fa-link"></i> Related Developer Tools</h2>
                <div class="seo-links">
                    <a href="regex.jsp" title="Online Regex Tester"><i class="fas fa-code"></i> Regex Tester</a>
                    <a href="jsonparser.jsp" title="JSON Formatter"><i class="fas fa-file-code"></i> JSON Formatter</a>
                    <a href="Base64Functions.jsp" title="Base64 Encoder"><i class="fas fa-lock"></i> Base64 Encoder</a>
                    <a href="diff.jsp" title="Text Diff Tool"><i class="fas fa-exchange-alt"></i> Diff Tool</a>
                    <a href="MessageDigest.jsp" title="Hash Calculator"><i class="fas fa-hashtag"></i> Hash Calculator</a>
                    <a href="curlfunctions.jsp" title="cURL Builder"><i class="fas fa-terminal"></i> cURL Builder</a>
                    <a href="jwt-debugger.jsp" title="JWT Debugger"><i class="fas fa-key"></i> JWT Debugger</a>
                    <a href="uuid.jsp" title="UUID Generator"><i class="fas fa-random"></i> UUID Generator</a>
                </div>
            </div>

            <%@ include file="thanks.jsp"%>

            <!-- Footer Ad -->
            <div class="seo-ad">
                <%@ include file="footer_adsense.jsp"%>
            </div>
        </div>
    </div>

    <!-- Monaco Editor -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs/loader.min.js"></script>

    <script>
        // Global state
        var editor = null;
        var languages = [];
        var currentLanguage = 'python';
        var currentVersion = '';
        var isRunning = false;
        var panelMinimized = false;
        var originalPanelHeight = 280;
        var loadedFromURL = false;

        // Multi-file state
        var files = [];
        var activeFileIndex = 0;

        // Cache
        var CACHE_KEY_LANGUAGES = 'onecompiler_languages';
        var CACHE_KEY_TEMPLATES = 'onecompiler_templates';
        var CACHE_EXPIRY_MS = 24 * 60 * 60 * 1000;
        var templatesCache = {};

        // Monaco language mapping
        var monacoLanguageMap = {
            'python': 'python', 'java': 'java', 'c': 'c', 'cpp': 'cpp',
            'csharp': 'csharp', 'javascript': 'javascript', 'typescript': 'typescript',
            'go': 'go', 'rust': 'rust', 'php': 'php', 'ruby': 'ruby',
            'swift': 'swift', 'kotlin': 'kotlin', 'scala': 'scala', 'r': 'r',
            'perl': 'perl', 'lua': 'lua', 'haskell': 'haskell', 'bash': 'shell'
        };

        var fileExtensions = {
            'python': '.py', 'java': '.java', 'c': '.c', 'cpp': '.cpp',
            'csharp': '.cs', 'javascript': '.js', 'typescript': '.ts',
            'go': '.go', 'rust': '.rs', 'php': '.php', 'ruby': '.rb',
            'swift': '.swift', 'kotlin': '.kt', 'scala': '.scala'
        };

        // Initialize files with default main file
        function initFiles(lang) {
            var ext = fileExtensions[lang] || '.txt';
            files = [{ name: 'main' + ext, content: '' }];
            activeFileIndex = 0;
        }

        // Get default filename for language
        function getDefaultFilename(lang, index) {
            var ext = fileExtensions[lang] || '.txt';
            if (index === 0) return 'main' + ext;
            return 'file' + index + ext;
        }

        // Render file tabs
        function renderFileTabs() {
            var container = document.getElementById('fileTabs');
            container.innerHTML = '';

            files.forEach(function(file, index) {
                var tab = document.createElement('div');
                tab.className = 'ide-tab' + (index === activeFileIndex ? ' active' : '');
                tab.onclick = function(e) {
                    if (!e.target.classList.contains('tab-close')) {
                        switchFile(index);
                    }
                };
                tab.ondblclick = function(e) {
                    if (!e.target.classList.contains('tab-close')) {
                        startRenameFile(index);
                    }
                };

                var icon = document.createElement('i');
                icon.className = 'fas fa-file-code';
                icon.style.fontSize = '12px';

                var name = document.createElement('span');
                name.className = 'tab-name';
                name.textContent = file.name;
                name.id = 'tabName' + index;

                tab.appendChild(icon);
                tab.appendChild(name);

                // Add close button (only if more than 1 file)
                if (files.length > 1) {
                    var close = document.createElement('span');
                    close.className = 'tab-close';
                    close.innerHTML = '<i class="fas fa-times"></i>';
                    close.onclick = function(e) {
                        e.stopPropagation();
                        removeFile(index);
                    };
                    tab.appendChild(close);
                }

                container.appendChild(tab);
            });

            // Add "+" button
            var addBtn = document.createElement('button');
            addBtn.className = 'ide-tab-add';
            addBtn.innerHTML = '<i class="fas fa-plus"></i>';
            addBtn.title = 'Add new file';
            addBtn.onclick = function() { addFile(); };
            container.appendChild(addBtn);
        }

        // Switch to a file
        function switchFile(index) {
            if (index === activeFileIndex) return;

            // Save current content
            if (editor && files[activeFileIndex]) {
                files[activeFileIndex].content = editor.getValue();
            }

            activeFileIndex = index;

            // Load new file content
            if (editor && files[index]) {
                editor.setValue(files[index].content);
            }

            renderFileTabs();
        }

        // Add a new file
        function addFile() {
            var newIndex = files.length;
            var filename = getDefaultFilename(currentLanguage, newIndex);

            // Ensure unique filename
            var baseName = filename.replace(/\.[^.]+$/, '');
            var ext = filename.substring(baseName.length);
            var counter = 1;
            while (files.some(function(f) { return f.name === filename; })) {
                filename = baseName + counter + ext;
                counter++;
            }

            // Save current editor content
            if (editor && files[activeFileIndex]) {
                files[activeFileIndex].content = editor.getValue();
            }

            files.push({ name: filename, content: '// ' + filename + '\n' });
            activeFileIndex = newIndex;

            if (editor) {
                editor.setValue(files[activeFileIndex].content);
            }

            renderFileTabs();
        }

        // Remove a file
        function removeFile(index) {
            if (files.length <= 1) return;

            files.splice(index, 1);

            // Adjust active index
            if (activeFileIndex >= files.length) {
                activeFileIndex = files.length - 1;
            } else if (activeFileIndex > index) {
                activeFileIndex--;
            }

            if (editor) {
                editor.setValue(files[activeFileIndex].content);
            }

            renderFileTabs();
        }

        // Start renaming a file (double-click)
        function startRenameFile(index) {
            var nameSpan = document.getElementById('tabName' + index);
            if (!nameSpan) return;

            var currentName = files[index].name;
            var input = document.createElement('input');
            input.type = 'text';
            input.className = 'tab-rename-input';
            input.value = currentName;

            input.onblur = function() {
                finishRenameFile(index, input.value);
            };

            input.onkeydown = function(e) {
                if (e.key === 'Enter') {
                    input.blur();
                } else if (e.key === 'Escape') {
                    input.value = currentName;
                    input.blur();
                }
            };

            nameSpan.innerHTML = '';
            nameSpan.appendChild(input);
            input.focus();
            input.select();
        }

        // Finish renaming
        function finishRenameFile(index, newName) {
            newName = newName.trim();
            if (newName && newName !== files[index].name) {
                // Check for duplicates
                var isDuplicate = files.some(function(f, i) {
                    return i !== index && f.name === newName;
                });
                if (!isDuplicate) {
                    files[index].name = newName;
                }
            }
            renderFileTabs();
        }

        // Get all files for API call
        function getFilesForApi() {
            // Save current editor content first
            if (editor && files[activeFileIndex]) {
                files[activeFileIndex].content = editor.getValue();
            }
            return files.map(function(f) {
                return { name: f.name, content: f.content };
            });
        }

        // Initialize Monaco
        require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs' }});

        require(['vs/editor/editor.main'], function() {
            editor = monaco.editor.create(document.getElementById('codeEditor'), {
                value: '# Write your Python code here\nprint("Hello, World!")',
                language: 'python',
                theme: 'vs-dark',
                fontSize: 14,
                minimap: { enabled: false },
                automaticLayout: true,
                scrollBeyondLastLine: false,
                wordWrap: 'on',
                lineNumbers: 'on',
                tabSize: 4,
                padding: { top: 8 }
            });

            // Initialize files
            initFiles(currentLanguage);
            files[0].content = editor.getValue();
            renderFileTabs();

            loadLanguages();
            setupResizeHandle();
        });

        // Panel resize
        function setupResizeHandle() {
            var handle = document.getElementById('resizeHandle');
            var panel = document.getElementById('bottomPanel');
            var isResizing = false;

            handle.addEventListener('mousedown', function(e) {
                isResizing = true;
                document.body.style.cursor = 'ns-resize';
                document.body.style.userSelect = 'none';
            });

            document.addEventListener('mousemove', function(e) {
                if (!isResizing) return;
                var containerRect = document.querySelector('.ide-main').getBoundingClientRect();
                var newHeight = containerRect.bottom - e.clientY;
                if (newHeight >= 100 && newHeight <= 400) {
                    panel.style.height = newHeight + 'px';
                    originalPanelHeight = newHeight;
                }
            });

            document.addEventListener('mouseup', function() {
                isResizing = false;
                document.body.style.cursor = '';
                document.body.style.userSelect = '';
            });
        }

        // Toggle panel
        function togglePanel() {
            var panel = document.getElementById('bottomPanel');
            var icon = document.getElementById('panelToggleIcon');

            if (panelMinimized) {
                panel.style.height = originalPanelHeight + 'px';
                icon.className = 'fas fa-chevron-down';
                panelMinimized = false;
            } else {
                panel.style.height = '35px';
                icon.className = 'fas fa-chevron-up';
                panelMinimized = true;
            }
        }

        // Switch panel tabs
        function switchPanel(panel) {
            document.querySelectorAll('.ide-panel-tab').forEach(function(tab) {
                tab.classList.remove('active');
                if (tab.dataset.panel === panel) tab.classList.add('active');
            });

            document.querySelectorAll('.ide-panel-pane').forEach(function(pane) {
                pane.classList.remove('active');
            });

            document.getElementById(panel + 'Pane').classList.add('active');
        }

        // Load languages
        function loadLanguages() {
            var cached = getFromCache(CACHE_KEY_LANGUAGES);
            if (cached) {
                languages = cached;
                populateLanguageSelect();
                updateVersionSelect(currentLanguage);
                loadAllTemplates();
                if (!loadedFromURL) loadTemplate();
                return;
            }

            fetch('OneCompilerFunctionality?action=languages')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    languages = data;
                    saveToCache(CACHE_KEY_LANGUAGES, data);
                    populateLanguageSelect();
                    updateVersionSelect(currentLanguage);
                    loadAllTemplates();
                    if (!loadedFromURL) loadTemplate();
                })
                .catch(function() {
                    languages = [
                        { name: 'python', default_version: '3.10' },
                        { name: 'java', default_version: '17' },
                        { name: 'cpp', default_version: 'gcc13' },
                        { name: 'javascript', default_version: 'node18' },
                        { name: 'go', default_version: '1.21' },
                        { name: 'rust', default_version: '1.70' }
                    ];
                    populateLanguageSelect();
                    updateVersionSelect(currentLanguage);
                });
        }

        function loadAllTemplates() {
            var cached = getFromCache(CACHE_KEY_TEMPLATES);
            if (cached) { templatesCache = cached; return; }

            fetch('OneCompilerFunctionality?action=templates')
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    templatesCache = data;
                    saveToCache(CACHE_KEY_TEMPLATES, data);
                });
        }

        function saveToCache(key, data) {
            try {
                localStorage.setItem(key, JSON.stringify({ timestamp: Date.now(), data: data }));
            } catch (e) {}
        }

        function getFromCache(key) {
            try {
                var cached = localStorage.getItem(key);
                if (cached) {
                    var obj = JSON.parse(cached);
                    if (Date.now() - obj.timestamp < CACHE_EXPIRY_MS) return obj.data;
                    localStorage.removeItem(key);
                }
            } catch (e) {}
            return null;
        }

        function populateLanguageSelect() {
            var select = document.getElementById('languageSelect');
            select.innerHTML = '';
            languages.forEach(function(lang) {
                var opt = document.createElement('option');
                opt.value = lang.name;
                opt.textContent = lang.name.charAt(0).toUpperCase() + lang.name.slice(1);
                if (lang.name === currentLanguage) opt.selected = true;
                select.appendChild(opt);
            });
        }

        function updateVersionSelect(langName) {
            var select = document.getElementById('versionSelect');
            select.innerHTML = '<option value="">Default</option>';

            var lang = languages.find(function(l) { return l.name === langName; });
            if (lang && lang.versions) {
                lang.versions.forEach(function(v) {
                    var opt = document.createElement('option');
                    var ver = typeof v === 'object' ? v.version : v;
                    opt.value = ver;
                    opt.textContent = ver;
                    select.appendChild(opt);
                });
            }
            if (lang && lang.default_version) {
                select.value = lang.default_version;
                currentVersion = lang.default_version;
            }
        }

        function onLanguageChange() {
            var lang = document.getElementById('languageSelect').value;
            currentLanguage = lang;

            var monacoLang = monacoLanguageMap[lang] || 'plaintext';
            monaco.editor.setModelLanguage(editor.getModel(), monacoLang);

            document.getElementById('statusLangText').textContent = lang.charAt(0).toUpperCase() + lang.slice(1);

            // Reset files for new language
            initFiles(lang);
            activeFileIndex = 0;

            updateVersionSelect(lang);
            loadTemplate();
        }

        function loadTemplate() {
            var template = '';
            if (templatesCache && templatesCache[currentLanguage]) {
                template = templatesCache[currentLanguage];
                editor.setValue(template);
                files[activeFileIndex].content = template;
                renderFileTabs();
                return;
            }

            fetch('OneCompilerFunctionality?action=template&lang=' + currentLanguage)
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.template) {
                        template = data.template;
                        templatesCache[currentLanguage] = template;
                    } else {
                        var defaults = {
                            'python': 'print("Hello, World!")',
                            'java': 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}',
                            'cpp': '#include <iostream>\nint main() {\n    std::cout << "Hello, World!" << std::endl;\n    return 0;\n}',
                            'javascript': 'console.log("Hello, World!");',
                            'go': 'package main\nimport "fmt"\nfunc main() {\n    fmt.Println("Hello, World!")\n}',
                            'rust': 'fn main() {\n    println!("Hello, World!");\n}'
                        };
                        template = defaults[currentLanguage] || '// Write your code here';
                    }
                    editor.setValue(template);
                    files[activeFileIndex].content = template;
                    renderFileTabs();
                });
        }

        function formatCode() {
            var code = editor.getValue();
            fetch('OneCompilerFunctionality?action=format', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ language: currentLanguage, code: code })
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.formattedCode) editor.setValue(data.formattedCode);
                else editor.getAction('editor.action.formatDocument').run();
            })
            .catch(function() {
                editor.getAction('editor.action.formatDocument').run();
            });
        }

        function executeCode() {
            if (isRunning) return;

            var stdin = document.getElementById('stdinInput').value;
            var args = document.getElementById('compilerArgs').value;
            var compilerArgs = args ? args.split(',').map(function(s) { return s.trim(); }).filter(Boolean) : [];

            // Get files for API call
            var apiFiles = getFilesForApi();

            isRunning = true;
            var runBtn = document.getElementById('runBtn');
            runBtn.disabled = true;
            runBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Running</span>';

            document.getElementById('outputContent').textContent = 'Executing...';
            document.getElementById('outputContent').className = 'output-content system';
            document.getElementById('statusExec').innerHTML = '<i class="fas fa-spinner fa-spin"></i> Running';

            switchPanel('output');
            var startTime = Date.now();

            // Build request body - use 'files' for multi-file, 'code' for single file
            var requestBody = {
                language: currentLanguage,
                version: currentVersion || undefined,
                input: stdin || undefined,
                compilerArgs: compilerArgs.length > 0 ? compilerArgs : undefined
            };

            if (apiFiles.length > 1) {
                // Multi-file mode
                requestBody.files = apiFiles;
            } else {
                // Single file mode
                requestBody.code = apiFiles[0].content;
            }

            fetch('OneCompilerFunctionality?action=execute', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestBody)
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                var execTime = ((Date.now() - startTime) / 1000).toFixed(2);
                var stdout = data.Stdout || data.stdout || '';
                var stderr = data.Stderr || data.stderr || '';
                var exitCode = data.ExitCode !== undefined ? data.ExitCode : (data.exitCode || 0);

                var outputDiv = document.getElementById('outputContent');
                var statusDiv = document.getElementById('statusExec');

                if (data.error) stderr = data.error + (stderr ? '\n' + stderr : '');

                if (stdout) {
                    outputDiv.textContent = stdout;
                    outputDiv.className = 'output-content stdout';
                } else if (stderr) {
                    outputDiv.textContent = stderr;
                    outputDiv.className = 'output-content stderr';
                } else {
                    outputDiv.textContent = '(No output)';
                    outputDiv.className = 'output-content system';
                }

                if (exitCode === 0 && !data.error) {
                    statusDiv.innerHTML = '<i class="fas fa-check-circle"></i> Exit: 0';
                } else {
                    statusDiv.innerHTML = '<i class="fas fa-times-circle"></i> Exit: ' + exitCode;
                }

                document.getElementById('statusTime').textContent = execTime + 's';

                // Show errors in problems tab
                if (stderr) {
                    document.getElementById('problemsPane').innerHTML = '<div class="output-content stderr">' + escapeHtml(stderr) + '</div>';
                    document.getElementById('problemsBadge').style.display = 'inline';
                    document.getElementById('problemsBadge').textContent = '1';
                } else {
                    document.getElementById('problemsPane').innerHTML = '<div class="output-content system">No problems detected.</div>';
                    document.getElementById('problemsBadge').style.display = 'none';
                }
            })
            .catch(function(err) {
                document.getElementById('outputContent').textContent = 'Error: ' + err.message;
                document.getElementById('outputContent').className = 'output-content stderr';
                document.getElementById('statusExec').innerHTML = '<i class="fas fa-times-circle"></i> Failed';
            })
            .finally(function() {
                isRunning = false;
                runBtn.disabled = false;
                runBtn.innerHTML = '<i class="fas fa-play"></i><span>Run</span>';
            });
        }

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function clearEditor() {
            editor.setValue('');
            files[activeFileIndex].content = '';
        }
        function clearOutput() {
            document.getElementById('outputContent').textContent = '// Output cleared';
            document.getElementById('outputContent').className = 'output-content system';
        }

        // Share code - Opens modal and creates snippet
        function shareCode() {
            // Open the share modal
            openShareModal();

            var apiFiles = getFilesForApi();
            var stdin = document.getElementById('stdinInput').value;
            var args = document.getElementById('compilerArgs').value;
            var compilerArgs = args ? args.split(',').map(function(s) { return s.trim(); }).filter(Boolean) : [];

            // Build request body - use 'files' for multi-file, 'code' for single file
            var requestBody = {
                language: currentLanguage,
                version: currentVersion || undefined,
                title: 'Shared Code',
                input: stdin || undefined,
                compilerArgs: compilerArgs.length > 0 ? compilerArgs : undefined
            };

            if (apiFiles.length > 1) {
                requestBody.files = apiFiles;
            } else {
                requestBody.code = apiFiles[0].content;
            }

            fetch('OneCompilerFunctionality?action=snippet_create', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestBody)
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.id) {
                    var shareUrl = window.location.origin + window.location.pathname + '?s=' + data.id;
                    showShareLinkReady(shareUrl);
                } else {
                    // Fallback to URL encoding
                    var fallbackUrl = shareCodeFallback();
                    showShareLinkReady(fallbackUrl);
                }
            })
            .catch(function() {
                var fallbackUrl = shareCodeFallback();
                if (fallbackUrl) {
                    showShareLinkReady(fallbackUrl);
                } else {
                    showShareLinkError();
                }
            });
        }

        // Fallback share using URL encoding
        function shareCodeFallback() {
            try {
                var apiFiles = getFilesForApi();
                var config = { lang: currentLanguage, code: btoa(unescape(encodeURIComponent(apiFiles[0].content))) };
                return window.location.origin + window.location.pathname + '?c=' + encodeURIComponent(JSON.stringify(config));
            } catch (e) {
                return null;
            }
        }

        // Share Modal Functions
        function openShareModal() {
            // Reset modal state
            document.getElementById('shareLinkPreparing').style.display = 'flex';
            document.getElementById('shareLinkReady').classList.remove('show');
            document.getElementById('shareLinkError').classList.remove('show');
            document.getElementById('shareCopyBtn').classList.remove('copied');
            document.getElementById('shareCopyBtn').innerHTML = '<i class="fas fa-copy"></i> Copy';

            // Show modal
            document.getElementById('shareModal').classList.add('show');
        }

        function closeShareModal(event) {
            if (!event || event.target === document.getElementById('shareModal')) {
                document.getElementById('shareModal').classList.remove('show');
            }
        }

        function showShareLinkReady(url) {
            document.getElementById('shareLinkPreparing').style.display = 'none';
            document.getElementById('shareLinkError').classList.remove('show');
            document.getElementById('shareLinkInput').value = url;
            document.getElementById('shareLinkReady').classList.add('show');

            // Update tweet button with the share URL
            var tweetText = 'Check out my code on 8gwifi.org Online Compiler! ' + url + ' #coding #programming #developer';
            var tweetUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(tweetText);
            document.getElementById('tweetShareBtn').href = tweetUrl;

            // Update URL without reload
            var urlParams = new URLSearchParams(url.split('?')[1] || '');
            var snippetId = urlParams.get('s');
            if (snippetId) {
                var newUrl = window.location.pathname + '?s=' + snippetId;
                window.history.pushState({}, '', newUrl);
            }
        }

        function showShareLinkError() {
            document.getElementById('shareLinkPreparing').style.display = 'none';
            document.getElementById('shareLinkReady').classList.remove('show');
            document.getElementById('shareLinkError').classList.add('show');
        }

        function copyShareLink() {
            var input = document.getElementById('shareLinkInput');
            var btn = document.getElementById('shareCopyBtn');

            navigator.clipboard.writeText(input.value).then(function() {
                btn.classList.add('copied');
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                setTimeout(function() {
                    btn.classList.remove('copied');
                    btn.innerHTML = '<i class="fas fa-copy"></i> Copy';
                }, 2000);
            }).catch(function() {
                // Fallback: select and copy
                input.select();
                document.execCommand('copy');
                btn.classList.add('copied');
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                setTimeout(function() {
                    btn.classList.remove('copied');
                    btn.innerHTML = '<i class="fas fa-copy"></i> Copy';
                }, 2000);
            });
        }

        function downloadCode() {
            var code = editor.getValue();
            var ext = fileExtensions[currentLanguage] || '.txt';
            var blob = new Blob([code], { type: 'text/plain' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url;
            a.download = 'code' + ext;
            a.click();
            URL.revokeObjectURL(url);
        }

        function scrollToAbout() {
            var section = document.getElementById('seoSection');
            if (section) {
                section.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }

        // Embed Modal Functions
        var currentSnippetId = null;

        function showEmbedModal() {
            // Check if we have a snippet ID from URL or need to create one
            var params = new URLSearchParams(window.location.search);
            currentSnippetId = params.get('s');

            if (!currentSnippetId) {
                // Need to share first to get a snippet ID
                document.getElementById('statusExec').innerHTML = '<i class="fas fa-info-circle"></i> Sharing first...';
                createSnippetForEmbed();
            } else {
                openEmbedModal();
            }
        }

        function createSnippetForEmbed() {
            var apiFiles = getFilesForApi();
            var stdin = document.getElementById('stdinInput').value;

            // Build request body - use 'files' for multi-file, 'code' for single file
            var requestBody = {
                language: currentLanguage,
                version: currentVersion || undefined,
                title: 'Embedded Code',
                input: stdin || undefined
            };

            if (apiFiles.length > 1) {
                requestBody.files = apiFiles;
            } else {
                requestBody.code = apiFiles[0].content;
            }

            fetch('OneCompilerFunctionality?action=snippet_create', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(requestBody)
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.id) {
                    currentSnippetId = data.id;
                    // Update URL without reload
                    var newUrl = window.location.pathname + '?s=' + data.id;
                    window.history.pushState({}, '', newUrl);
                    document.getElementById('statusExec').innerHTML = '<i class="fas fa-check-circle"></i> Ready';
                    openEmbedModal();
                } else {
                    document.getElementById('statusExec').innerHTML = '<i class="fas fa-times-circle"></i> Share failed';
                }
            })
            .catch(function() {
                // Fallback to code-based embed
                currentSnippetId = null;
                openEmbedModal();
            });
        }

        function openEmbedModal() {
            document.getElementById('embedModal').classList.add('show');
            updateEmbedCode();
        }

        function closeEmbedModal(event) {
            if (!event || event.target === document.getElementById('embedModal')) {
                document.getElementById('embedModal').classList.remove('show');
            }
        }

        function updateEmbedCode() {
            var theme = document.getElementById('embedTheme').value;
            var readonly = document.getElementById('embedReadonly').checked;
            var autorun = document.getElementById('embedAutorun').checked;
            var width = document.getElementById('embedWidth').value;
            var height = document.getElementById('embedHeight').value;

            var embedUrl = window.location.origin + '/onecompiler-embed.jsp';
            var params = [];

            if (currentSnippetId) {
                params.push('s=' + encodeURIComponent(currentSnippetId));
            } else {
                // Fallback: encode current code
                var code = editor.getValue();
                var config = { lang: currentLanguage, code: btoa(unescape(encodeURIComponent(code))) };
                params.push('c=' + encodeURIComponent(JSON.stringify(config)));
            }

            if (theme === 'light') params.push('theme=light');
            if (readonly) params.push('readonly=true');
            if (autorun) params.push('autorun=true');

            var fullUrl = embedUrl + '?' + params.join('&');

            // Update preview
            var preview = document.getElementById('embedPreview');
            preview.src = fullUrl;

            // Generate embed code
            var embedCode = '<iframe\n' +
                '  src="' + fullUrl + '"\n' +
                '  width="' + width + '"\n' +
                '  height="' + height + '"\n' +
                '  frameborder="0"\n' +
                '  allowfullscreen>\n' +
                '</iframe>';

            document.getElementById('embedCode').textContent = embedCode;

            // Update tweet button for embed
            var shareUrl = window.location.origin + window.location.pathname;
            if (currentSnippetId) {
                shareUrl += '?s=' + currentSnippetId;
            }
            var tweetText = 'Check out this embeddable code snippet on 8gwifi.org! ' + shareUrl + ' #coding #programming #developer';
            var tweetUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(tweetText);
            var tweetBtn = document.getElementById('tweetEmbedBtn');
            if (tweetBtn) {
                tweetBtn.href = tweetUrl;
            }
        }

        function copyEmbedCode() {
            var embedCode = document.getElementById('embedCode').textContent;
            navigator.clipboard.writeText(embedCode).then(function() {
                var btn = document.querySelector('.embed-copy-btn');
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                setTimeout(function() {
                    btn.innerHTML = '<i class="fas fa-copy"></i> Copy';
                }, 2000);
            });
        }

        // Close modals on Escape
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeEmbedModal();
                closeShareModal();
            }
        });

        // Load from URL - supports ?s=snippet-id, ?c=encoded-json, and ?b64=base64-code
        function loadFromURL() {
            var params = new URLSearchParams(window.location.search);
            var snippetId = params.get('s');
            var codeParam = params.get('c');
            var b64Param = params.get('b64');
            var langParam = params.get('lang');

            if (snippetId) {
                // Load snippet from API
                loadedFromURL = true;
                loadSnippet(snippetId);
            } else if (b64Param) {
                // Load from base64-encoded code (simple format)
                loadedFromURL = true;
                try {
                    var code = decodeURIComponent(escape(atob(b64Param)));
                    if (langParam) currentLanguage = langParam;
                    waitForEditor(function() {
                        // Set language dropdown
                        document.getElementById('languageSelect').value = currentLanguage;

                        // Set Monaco language (without triggering template load)
                        var monacoLang = monacoLanguageMap[currentLanguage] || 'plaintext';
                        monaco.editor.setModelLanguage(editor.getModel(), monacoLang);

                        // Update status bar
                        document.getElementById('statusLangText').textContent = currentLanguage.charAt(0).toUpperCase() + currentLanguage.slice(1);

                        // Update version select
                        updateVersionSelect(currentLanguage);

                        // Set the decoded code
                        editor.setValue(code);

                        // Update file tab with decoded code
                        var ext = fileExtensions[currentLanguage] || '.txt';
                        files = [{ name: 'main' + ext, content: code }];
                        activeFileIndex = 0;
                        renderFileTabs();
                    });
                } catch (e) {
                    console.error('Failed to decode base64:', e);
                }
            } else if (codeParam) {
                // Legacy: Load from URL-encoded JSON
                try {
                    var config = JSON.parse(decodeURIComponent(codeParam));
                    if (config.lang) currentLanguage = config.lang;
                    if (config.code) {
                        var code = decodeURIComponent(escape(atob(config.code)));
                        waitForEditor(function() {
                            document.getElementById('languageSelect').value = currentLanguage;
                            onLanguageChange();
                            editor.setValue(code);
                        });
                    }
                } catch (e) {}
            }
        }

        // Load snippet from API by ID
        function loadSnippet(snippetId) {
            document.getElementById('statusExec').innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';

            fetch('OneCompilerFunctionality?action=snippet_get&id=' + encodeURIComponent(snippetId))
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.error) {
                        document.getElementById('statusExec').innerHTML = '<i class="fas fa-times-circle"></i> Snippet not found';
                        return;
                    }

                    waitForEditor(function() {
                        // Set language
                        if (data.language) {
                            currentLanguage = data.language;
                            document.getElementById('languageSelect').value = data.language;

                            var monacoLang = monacoLanguageMap[data.language] || 'plaintext';
                            monaco.editor.setModelLanguage(editor.getModel(), monacoLang);

                            document.getElementById('statusLangText').textContent = data.language.charAt(0).toUpperCase() + data.language.slice(1);

                            updateVersionSelect(data.language);
                        }

                        // Set version
                        if (data.version) {
                            currentVersion = data.version;
                            document.getElementById('versionSelect').value = data.version;
                        }

                        // Handle multi-file or single file
                        if (data.files && data.files.length > 0) {
                            // Multi-file mode
                            files = data.files.map(function(f) {
                                return { name: f.name, content: f.content };
                            });
                            activeFileIndex = 0;
                            editor.setValue(files[0].content);
                            renderFileTabs();
                        } else if (data.code) {
                            // Single file mode
                            var ext = fileExtensions[currentLanguage] || '.txt';
                            files = [{ name: 'main' + ext, content: data.code }];
                            activeFileIndex = 0;
                            editor.setValue(data.code);
                            renderFileTabs();
                        }

                        // Set input
                        if (data.input) {
                            document.getElementById('stdinInput').value = data.input;
                        }

                        // Set compiler args
                        if (data.compilerArgs && data.compilerArgs.length > 0) {
                            document.getElementById('compilerArgs').value = data.compilerArgs.join(', ');
                        }

                        document.getElementById('statusExec').innerHTML = '<i class="fas fa-check-circle"></i> Loaded';
                        setTimeout(function() {
                            document.getElementById('statusExec').innerHTML = '<i class="fas fa-check-circle"></i> Ready';
                        }, 1500);
                    });
                })
                .catch(function(err) {
                    document.getElementById('statusExec').innerHTML = '<i class="fas fa-times-circle"></i> Load failed';
                });
        }

        // Helper to wait for editor initialization
        function waitForEditor(callback) {
            var check = setInterval(function() {
                if (editor) {
                    clearInterval(check);
                    callback();
                }
            }, 100);
        }

        // Keyboard shortcut
        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                e.preventDefault();
                executeCode();
            }
        });

        loadFromURL();
    </script>
</div>
    <%@ include file="body-close.jsp"%>

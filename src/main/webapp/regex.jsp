<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- SEO Meta Tags -->
    <title>Advanced Regex Tester - Regular Expression Testing Tool | 8gwifi.org</title>
    <meta name="description" content="Professional online regex tester with real-time matching, syntax highlighting, capture groups, test cases, and code generation for multiple languages. Perfect for developers and regex learners.">
    <meta name="keywords" content="regex tester, regular expression, regex tool, pattern matching, regex validator, regex debugger, regex generator, test regex online">
    <meta name="author" content="8gwifi.org">
    <meta name="robots" content="index, follow">

    <!-- Open Graph Meta Tags -->
    <meta property="og:title" content="Advanced Regex Tester - Regular Expression Testing Tool">
    <meta property="og:description" content="Professional online regex tester with real-time matching, syntax highlighting, and code generation.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/regex.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/regex.jpg">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "SoftwareApplication",
      "name": "Advanced Regex Tester",
      "description": "Professional online regex tester with real-time matching and code generation",
      "url": "https://8gwifi.org/regex.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Web Browser",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      }
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #3b82f6;
            --match-bg: #fef3c7;
            --match-border: #f59e0b;
            --group-colors: #a78bfa, #f472b6, #fb923c, #34d399, #60a5fa, #c084fc;
        }

        .regex-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1rem;
        }

        .regex-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            text-align: center;
        }

        .regex-header h1 {
            margin: 0 0 0.5rem 0;
            font-size: 2rem;
        }

        .regex-header p {
            margin: 0;
            opacity: 0.9;
        }

        .regex-layout {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 1.5rem;
        }

        @media (max-width: 1024px) {
            .regex-layout {
                grid-template-columns: 1fr;
            }
        }

        .regex-main {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .regex-panel {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
        }

        .regex-panel h3 {
            margin: 0 0 1rem 0;
            font-size: 1.1rem;
            color: #374151;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .regex-input-group {
            margin-bottom: 1.5rem;
        }

        .regex-input-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #4b5563;
            font-size: 0.9rem;
        }

        .regex-pattern-wrapper {
            position: relative;
            display: flex;
            gap: 0.5rem;
            align-items: stretch;
        }

        .regex-pattern-input {
            flex: 1;
            font-family: 'Courier New', monospace;
            font-size: 16px;
            padding: 0.75rem;
            border: 2px solid #d1d5db;
            border-radius: 8px;
            transition: border-color 0.2s;
            overflow-x: auto;
            white-space: nowrap;
        }

        .regex-pattern-input:focus {
            outline: none;
            border-color: var(--primary);
        }

        .regex-pattern-input.valid {
            border-color: var(--success);
        }

        .regex-pattern-input.invalid {
            border-color: var(--danger);
        }

        .regex-flags {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .regex-flag-checkbox {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .regex-flag-checkbox input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .regex-flag-checkbox label {
            cursor: pointer;
            user-select: none;
            font-size: 0.9rem;
        }

        .regex-test-text {
            width: 100%;
            min-height: 200px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            padding: 1rem;
            border: 2px solid #d1d5db;
            border-radius: 8px;
            resize: vertical;
        }

        .regex-results {
            background: #f9fafb;
            border-radius: 8px;
            padding: 1rem;
            min-height: 200px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            line-height: 1.8;
            white-space: pre-wrap;
            word-break: break-word;
            max-height: 500px;
            overflow-y: auto;
        }

        .regex-match {
            background: var(--match-bg);
            border-bottom: 2px solid var(--match-border);
            padding: 0.1rem 0.2rem;
            border-radius: 3px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .regex-match:hover {
            background: #fde68a;
            transform: scale(1.02);
        }

        .regex-group-1 { background: #ddd6fe; border-bottom-color: #8b5cf6; }
        .regex-group-2 { background: #fce7f3; border-bottom-color: #ec4899; }
        .regex-group-3 { background: #fed7aa; border-bottom-color: #f97316; }
        .regex-group-4 { background: #a7f3d0; border-bottom-color: #10b981; }
        .regex-group-5 { background: #bfdbfe; border-bottom-color: #3b82f6; }
        .regex-group-6 { background: #e9d5ff; border-bottom-color: #a855f7; }

        .regex-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .regex-stat {
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            padding: 1rem;
            border-radius: 8px;
            text-align: center;
        }

        .regex-stat-value {
            display: block;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
        }

        .regex-stat-label {
            display: block;
            font-size: 0.85rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }

        .regex-matches-list {
            max-height: 300px;
            overflow-y: auto;
        }

        .regex-match-item {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .regex-match-item:hover {
            border-color: var(--primary);
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }

        .regex-match-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .regex-match-index {
            font-weight: 700;
            color: var(--primary);
        }

        .regex-match-position {
            font-size: 0.85rem;
            color: #6b7280;
        }

        .regex-match-text {
            font-family: 'Courier New', monospace;
            background: #f9fafb;
            padding: 0.5rem;
            border-radius: 4px;
            font-size: 0.9rem;
            word-break: break-all;
            overflow-wrap: break-word;
            max-height: 100px;
            overflow-y: auto;
        }

        .regex-match-groups {
            margin-top: 0.5rem;
            font-size: 0.85rem;
        }

        .regex-match-group {
            display: flex;
            gap: 0.5rem;
            margin-top: 0.25rem;
        }

        .regex-match-group-label {
            font-weight: 600;
            color: #6b7280;
        }

        .regex-match-group-value {
            font-family: 'Courier New', monospace;
            color: #374151;
            word-break: break-all;
            overflow-wrap: break-word;
            flex: 1;
        }

        .regex-library {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 1rem;
            max-height: 800px;
            overflow-y: auto;
        }

        .regex-library h3 {
            margin: 0 0 1rem 0;
            font-size: 1.1rem;
            color: #374151;
            position: sticky;
            top: 0;
            background: white;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e5e7eb;
        }

        .regex-library-section {
            margin-bottom: 1.5rem;
        }

        .regex-library-section h4 {
            font-size: 0.9rem;
            color: #6b7280;
            margin: 0 0 0.5rem 0;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .regex-library-item {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            padding: 0.75rem;
            margin-bottom: 0.5rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .regex-library-item:hover {
            border-color: var(--primary);
            background: #f3f4f6;
        }

        .regex-library-item-title {
            font-weight: 600;
            color: #374151;
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
        }

        .regex-library-item-pattern {
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            color: var(--primary);
            background: white;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            word-break: break-all;
            overflow-wrap: break-word;
            max-height: 80px;
            overflow-y: auto;
            display: block;
        }

        .regex-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
            border-bottom: 2px solid #e5e7eb;
        }

        .regex-tab {
            padding: 0.75rem 1.5rem;
            background: transparent;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            font-weight: 600;
            color: #6b7280;
            transition: all 0.2s;
        }

        .regex-tab.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }

        .regex-tab-content {
            display: none;
        }

        .regex-tab-content.active {
            display: block;
        }

        .regex-code-block {
            background: #1e293b;
            color: #e2e8f0;
            padding: 1rem;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            overflow-x: auto;
            margin-top: 0.5rem;
            position: relative;
            min-height: 100px;
        }

        .regex-code-block pre {
            margin: 0;
            padding: 0;
            color: #e2e8f0;
            white-space: pre-wrap;
            word-wrap: break-word;
            line-height: 1.6;
        }

        .regex-code-keyword {
            color: #c792ea;
            font-weight: 600;
        }

        .regex-code-string {
            color: #c3e88d;
        }

        .regex-code-comment {
            color: #676e95;
            font-style: italic;
        }

        .regex-code-function {
            color: #82aaff;
        }

        .regex-code-copy {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.2s;
        }

        .regex-code-copy:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .regex-test-cases {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .regex-test-case {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: #f9fafb;
            padding: 0.75rem;
            border-radius: 6px;
            border-left: 4px solid transparent;
        }

        .regex-test-case.pass {
            border-left-color: var(--success);
        }

        .regex-test-case.fail {
            border-left-color: var(--danger);
        }

        .regex-test-case-text {
            flex: 1;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
        }

        .regex-test-case-icon {
            font-size: 1.2rem;
        }

        .regex-test-case-add {
            display: flex;
            gap: 0.5rem;
        }

        .regex-test-case-input {
            flex: 1;
            padding: 0.5rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
        }

        .regex-btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s;
        }

        .regex-btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
        }

        .regex-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .regex-btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .regex-btn-secondary:hover {
            background: #d1d5db;
        }

        .regex-btn-small {
            padding: 0.4rem 0.8rem;
            font-size: 0.85rem;
        }

        .regex-error {
            background: #fee2e2;
            border: 1px solid #fecaca;
            color: #991b1b;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 0.5rem;
            font-size: 0.9rem;
        }

        .regex-info {
            background: #dbeafe;
            border: 1px solid #bfdbfe;
            color: #1e40af;
            padding: 1rem;
            border-radius: 8px;
            font-size: 0.9rem;
        }

        .regex-cheatsheet {
            font-size: 0.85rem;
        }

        .regex-cheatsheet table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 0.5rem;
        }

        .regex-cheatsheet td {
            padding: 0.5rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .regex-cheatsheet td:first-child {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: var(--primary);
            width: 30%;
        }

        .regex-quick-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-top: 1rem;
        }
    </style>
</head>

<div>
    <%@ include file="body-script.jsp"%>

    <div class="regex-container">
        <div class="regex-header">
            <h1><i class="fas fa-code"></i> Advanced Regex Tester</h1>
            <p>Professional regular expression testing tool with real-time matching and code generation</p>
        </div>

        <div class="regex-layout">
            <!-- Main Content -->
            <div class="regex-main">
                <!-- Pattern Input -->
                <div class="regex-panel">
                    <h3><i class="fas fa-code-branch"></i> Regular Expression Pattern</h3>

                    <div class="regex-input-group">
                        <label class="regex-input-label">Pattern</label>
                        <div class="regex-pattern-wrapper">
                            <input type="text"
                                   id="regexPattern"
                                   class="regex-pattern-input"
                                   placeholder="Enter your regex pattern here..."
                                   value="(\w+)@(\w+\.\w+)">
                            <button class="regex-btn regex-btn-secondary" onclick="testRegex()">
                                <i class="fas fa-play"></i> Test
                            </button>
                        </div>
                        <div id="patternError"></div>
                    </div>

                    <div class="regex-input-group">
                        <label class="regex-input-label">Flags</label>
                        <div class="regex-flags">
                            <div class="regex-flag-checkbox">
                                <input type="checkbox" id="flagG" checked>
                                <label for="flagG">g (global)</label>
                            </div>
                            <div class="regex-flag-checkbox">
                                <input type="checkbox" id="flagI">
                                <label for="flagI">i (case-insensitive)</label>
                            </div>
                            <div class="regex-flag-checkbox">
                                <input type="checkbox" id="flagM">
                                <label for="flagM">m (multiline)</label>
                            </div>
                            <div class="regex-flag-checkbox">
                                <input type="checkbox" id="flagS">
                                <label for="flagS">s (dotall)</label>
                            </div>
                            <div class="regex-flag-checkbox">
                                <input type="checkbox" id="flagU">
                                <label for="flagU">u (unicode)</label>
                            </div>
                        </div>
                    </div>

                    <div class="regex-quick-actions">
                        <button class="regex-btn regex-btn-secondary regex-btn-small" onclick="clearPattern()">
                            <i class="fas fa-eraser"></i> Clear
                        </button>
                        <button class="regex-btn regex-btn-secondary regex-btn-small" onclick="shareRegex()">
                            <i class="fas fa-share-alt"></i> Share
                        </button>
                    </div>
                </div>

                <!-- Test String -->
                <div class="regex-panel">
                    <h3><i class="fas fa-file-alt"></i> Test String</h3>
                    <textarea id="testString"
                              class="regex-test-text"
                              placeholder="Enter your test string here...">Contact us at support@example.com or sales@company.org for more information.
Visit our website at info@website.net to learn more.</textarea>
                </div>

                <!-- Results -->
                <div class="regex-panel">
                    <h3><i class="fas fa-list-check"></i> Results</h3>

                    <div class="regex-stats" id="statsSection">
                        <div class="regex-stat">
                            <span class="regex-stat-value" id="matchCount">0</span>
                            <span class="regex-stat-label">Matches</span>
                        </div>
                        <div class="regex-stat">
                            <span class="regex-stat-value" id="groupCount">0</span>
                            <span class="regex-stat-label">Groups</span>
                        </div>
                        <div class="regex-stat">
                            <span class="regex-stat-value" id="execTime">0ms</span>
                            <span class="regex-stat-label">Execution Time</span>
                        </div>
                    </div>

                    <div class="regex-tabs">
                        <button class="regex-tab active" onclick="switchResultTab('highlighted')">
                            <i class="fas fa-highlighter"></i> Highlighted
                        </button>
                        <button class="regex-tab" onclick="switchResultTab('matches')">
                            <i class="fas fa-list"></i> Matches
                        </button>
                        <button class="regex-tab" onclick="switchResultTab('replace')">
                            <i class="fas fa-retweet"></i> Replace
                        </button>
                    </div>

                    <div id="highlighted-tab" class="regex-tab-content active">
                        <div class="regex-results" id="highlightedResult">
                            <div class="regex-info">Enter a pattern and click Test to see results</div>
                        </div>
                    </div>

                    <div id="matches-tab" class="regex-tab-content">
                        <div class="regex-matches-list" id="matchesList"></div>
                    </div>

                    <div id="replace-tab" class="regex-tab-content">
                        <div class="regex-input-group">
                            <label class="regex-input-label">Replacement String</label>
                            <input type="text"
                                   id="replaceString"
                                   class="regex-pattern-input"
                                   placeholder="Enter replacement (use $1, $2 for groups)"
                                   value="[$1] at [$2]">
                        </div>
                        <div class="regex-results" id="replaceResult"></div>
                    </div>
                </div>

                <!-- Code Generation -->
                <div class="regex-panel">
                    <h3><i class="fas fa-code"></i> Code Generation</h3>

                    <div class="regex-tabs">
                        <button class="regex-tab active" onclick="switchCodeTab('javascript')">JavaScript</button>
                        <button class="regex-tab" onclick="switchCodeTab('python')">Python</button>
                        <button class="regex-tab" onclick="switchCodeTab('java')">Java</button>
                        <button class="regex-tab" onclick="switchCodeTab('php')">PHP</button>
                        <button class="regex-tab" onclick="switchCodeTab('ruby')">Ruby</button>
                    </div>

                    <div id="javascript-code" class="regex-tab-content active">
                        <div class="regex-code-block" id="jsCode"></div>
                    </div>
                    <div id="python-code" class="regex-tab-content">
                        <div class="regex-code-block" id="pythonCode"></div>
                    </div>
                    <div id="java-code" class="regex-tab-content">
                        <div class="regex-code-block" id="javaCode"></div>
                    </div>
                    <div id="php-code" class="regex-tab-content">
                        <div class="regex-code-block" id="phpCode"></div>
                    </div>
                    <div id="ruby-code" class="regex-tab-content">
                        <div class="regex-code-block" id="rubyCode"></div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="regex-sidebar">
                <div class="regex-library">
                    <h3><i class="fas fa-book"></i> Pattern Library</h3>

                    <div class="regex-library-section">
                        <h4>Common Patterns</h4>
                        <div class="regex-library-item" onclick="loadPattern('[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}', 'gi', 'Contact us at test@email.com or invalid@ or user@example.org for support.')">
                            <div class="regex-library-item-title">Email Address</div>
                            <div class="regex-library-item-pattern">[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}</div>
                        </div>
                        <div class="regex-library-item" onclick="loadPattern('https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)', 'gi', 'Visit https://www.example.com or http://test.org/path for more info. invalid-url is not a URL.')">
                            <div class="regex-library-item-title">URL</div>
                            <div class="regex-library-item-pattern">https?://(www\.)?[-a-zA-Z0-9@:%._\+~#=]...</div>
                        </div>
                        <div class="regex-library-item" onclick="loadPattern('(?:\\+?1[-.]?)?\\(?([0-9]{3})\\)?[-.]?([0-9]{3})[-.]?([0-9]{4})', 'g', 'Call us at 123-456-7890 or (555) 123-4567 or +1.555.123.4567 for assistance.')">
                            <div class="regex-library-item-title">Phone Number (US)</div>
                            <div class="regex-library-item-pattern">(?:\+?1[-.]?)?\(?\d{3}\)?[-.]?\d{3}[-.]?\d{4}</div>
                        </div>
                        <div class="regex-library-item" onclick="loadPattern('(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}', 'g', 'Test these passwords: MyP@ssw0rd is strong, weak is not, Strong123! is good')">
                            <div class="regex-library-item-title">Strong Password (8+ chars)</div>
                            <div class="regex-library-item-pattern">(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])...</div>
                        </div>
                        <div class="regex-library-item" onclick="loadPattern('\\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b', 'g', 'Server IPs: 192.168.1.1 and 255.255.255.0 are valid, but 999.999.999.999 is not.')">
                            <div class="regex-library-item-title">IPv4 Address</div>
                            <div class="regex-library-item-pattern">\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}...</div>
                        </div>
                    </div>

                    <div class="regex-library-section">
                        <h4>Date & Time</h4>
                        <div class="regex-library-item" onclick="loadPattern('\\b\\d{4}-\\d{2}-\\d{2}\\b', 'g', 'Dates: 2024-01-15 is valid, 2024/01/15 is not, also 01-15-2024 format differs')">
                            <div class="regex-library-item-title">Date (YYYY-MM-DD)</div>
                            <div class="regex-library-item-pattern">\b\d{4}-\d{2}-\d{2}\b</div>
                        </div>
                        <div class="regex-library-item" onclick="loadPattern('\\b([0-1]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?\\b', 'g', 'Times: 14:30 and 23:59:59 are valid, but 25:00 is invalid')">
                            <div class="regex-library-item-title">Time (HH:MM or HH:MM:SS)</div>
                            <div class="regex-library-item-pattern">\b([0-1]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?\b</div>
                        </div>
                    </div>

                    <div class="regex-library-section">
                        <h4>Text Processing</h4>
                        <div class="regex-library-item" onclick="loadPattern('\\b[A-Z][a-z]+\\b', 'g', 'Hello World\nthis is a Test\nANOTHER Example')">
                            <div class="regex-library-item-title">Capitalized Words</div>
                            <div class="regex-library-item-pattern">\b[A-Z][a-z]+\b</div>
                        </div>
                        <div class="regex-library-item" onclick="loadPattern('#[a-fA-F0-9]{6}\\b', 'gi', '#FF5733 is red\n#00FF00 is green\n#ZZZZZZ invalid')">
                            <div class="regex-library-item-title">Hex Color Code</div>
                            <div class="regex-library-item-pattern">#[a-fA-F0-9]{6}\b</div>
                        </div>
                        <div class="regex-library-item" onclick="loadPattern('\\d+\\.?\\d*', 'g', 'Price: $19.99\nQuantity: 5\nTotal: 99.95')">
                            <div class="regex-library-item-title">Numbers (Int/Float)</div>
                            <div class="regex-library-item-pattern">\d+\.?\d*</div>
                        </div>
                    </div>

                    <div class="regex-library-section">
                        <h4>Advanced</h4>
                        <div class="regex-library-item" onclick="loadPattern('(?<=\\$)\\d+(?:\\.\\d{2})?', 'g', 'Price: $19.99\nCost: $5\nTotal: 24.99')">
                            <div class="regex-library-item-title">Dollar Amount (Lookbehind)</div>
                            <div class="regex-library-item-pattern">(?<=\$)\d+(?:\.\d{2})?</div>
                        </div>
                        <div class="regex-library-item" onclick="loadPattern('\\b(?!test\\b)\\w+', 'g', 'test word\nanother test\ntesting words')">
                            <div class="regex-library-item-title">Words (Not "test")</div>
                            <div class="regex-library-item-pattern">\b(?!test\b)\w+</div>
                        </div>
                    </div>

                    <div class="regex-library-section">
                        <h4>Cheat Sheet</h4>
                        <div class="regex-cheatsheet">
                            <table>
                                <tr><td>.</td><td>Any character</td></tr>
                                <tr><td>\d</td><td>Digit (0-9)</td></tr>
                                <tr><td>\w</td><td>Word char (a-zA-Z0-9_)</td></tr>
                                <tr><td>\s</td><td>Whitespace</td></tr>
                                <tr><td>^</td><td>Start of string</td></tr>
                                <tr><td>$</td><td>End of string</td></tr>
                                <tr><td>*</td><td>0 or more</td></tr>
                                <tr><td>+</td><td>1 or more</td></tr>
                                <tr><td>?</td><td>0 or 1</td></tr>
                                <tr><td>{n}</td><td>Exactly n times</td></tr>
                                <tr><td>[abc]</td><td>Character set</td></tr>
                                <tr><td>(x)</td><td>Capture group</td></tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Related Tools -->
        <div class="card mt-4">
            <div class="card-header">
                <h4><i class="fas fa-link"></i> Related Tools</h4>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <ul class="list-unstyled">
                            <li><i class="fas fa-exchange-alt text-muted"></i> <a href="diff.jsp">Text Diff Tool</a></li>
                            <li><i class="fas fa-file-code text-muted"></i> <a href="hexeditor.jsp">Hex Editor</a></li>
                            <li><i class="fas fa-compress text-muted"></i> <a href="json-minifier.jsp">JSON Formatter</a></li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="list-unstyled">
                            <li><i class="fas fa-code text-muted"></i> <a href="HexToStringFunctions.jsp">Text Converters</a></li>
                            <li><i class="fas fa-hash text-muted"></i> <a href="MessageDigest.jsp">Hash Calculator</a></li>
                            <li><i class="fas fa-key text-muted"></i> <a href="ecfunctions.jsp">Encryption Tools</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <hr>
        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="thanks.jsp"%>
        <hr>
        <%@ include file="footer_adsense.jsp"%>
        <%@ include file="addcomments.jsp"%>
    </div>

    <script>
        var currentRegex = null;
        var currentMatches = [];

        // Auto-test on input change with debounce
        var debounceTimer;
        document.getElementById('regexPattern').addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(testRegex, 500);
        });

        document.getElementById('testString').addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(testRegex, 500);
        });

        // Flag change listeners
        ['flagG', 'flagI', 'flagM', 'flagS', 'flagU'].forEach(function(id) {
            document.getElementById(id).addEventListener('change', testRegex);
        });

        function getFlags() {
            var flags = '';
            if (document.getElementById('flagG').checked) flags += 'g';
            if (document.getElementById('flagI').checked) flags += 'i';
            if (document.getElementById('flagM').checked) flags += 'm';
            if (document.getElementById('flagS').checked) flags += 's';
            if (document.getElementById('flagU').checked) flags += 'u';
            return flags;
        }

        function testRegex() {
            var pattern = document.getElementById('regexPattern').value;
            var testStr = document.getElementById('testString').value;
            var flags = getFlags();
            var patternInput = document.getElementById('regexPattern');
            var errorDiv = document.getElementById('patternError');

            if (!pattern) {
                patternInput.className = 'regex-pattern-input';
                errorDiv.innerHTML = '';
                document.getElementById('highlightedResult').innerHTML = '<div class="regex-info">Enter a pattern to test</div>';
                return;
            }

            var startTime = performance.now();

            try {
                currentRegex = new RegExp(pattern, flags);
                patternInput.className = 'regex-pattern-input valid';
                errorDiv.innerHTML = '';

                currentMatches = [];
                var match;
                var lastIndex = 0;

                if (flags.indexOf('g') !== -1) {
                    while ((match = currentRegex.exec(testStr)) !== null) {
                        currentMatches.push({
                            match: match[0],
                            index: match.index,
                            groups: Array.from(match).slice(1)
                        });
                        if (match.index === currentRegex.lastIndex) {
                            currentRegex.lastIndex++;
                        }
                    }
                } else {
                    match = currentRegex.exec(testStr);
                    if (match) {
                        currentMatches.push({
                            match: match[0],
                            index: match.index,
                            groups: Array.from(match).slice(1)
                        });
                    }
                }

                var endTime = performance.now();
                var execTime = (endTime - startTime).toFixed(2);

                document.getElementById('matchCount').textContent = currentMatches.length;
                document.getElementById('groupCount').textContent = currentMatches.length > 0 ? currentMatches[0].groups.length : 0;
                document.getElementById('execTime').textContent = execTime + 'ms';

                renderHighlighted();
                renderMatchesList();
                renderReplace();
                generateCode();

            } catch (e) {
                patternInput.className = 'regex-pattern-input invalid';
                errorDiv.innerHTML = '<div class="regex-error"><strong>Error:</strong> ' + e.message + '</div>';
                document.getElementById('highlightedResult').innerHTML = '<div class="regex-error">Invalid regular expression</div>';
                document.getElementById('matchCount').textContent = '0';
                document.getElementById('groupCount').textContent = '0';
            }
        }

        function renderHighlighted() {
            var testStr = document.getElementById('testString').value;
            var resultDiv = document.getElementById('highlightedResult');

            if (currentMatches.length === 0) {
                resultDiv.innerHTML = '<div class="regex-info">No matches found</div>';
                return;
            }

            var html = '';
            var lastIndex = 0;

            currentMatches.forEach(function(matchObj, idx) {
                html += escapeHtml(testStr.substring(lastIndex, matchObj.index));
                html += '<span class="regex-match" title="Match ' + (idx + 1) + ': ' + escapeHtml(matchObj.match) + '">' +
                        escapeHtml(matchObj.match) + '</span>';
                lastIndex = matchObj.index + matchObj.match.length;
            });

            html += escapeHtml(testStr.substring(lastIndex));
            resultDiv.innerHTML = html;
        }

        function renderMatchesList() {
            var listDiv = document.getElementById('matchesList');

            if (currentMatches.length === 0) {
                listDiv.innerHTML = '<div class="regex-info">No matches to display</div>';
                return;
            }

            var html = '';
            currentMatches.forEach(function(matchObj, idx) {
                html += '<div class="regex-match-item">' +
                    '<div class="regex-match-header">' +
                        '<span class="regex-match-index">Match ' + (idx + 1) + '</span>' +
                        '<span class="regex-match-position">Position: ' + matchObj.index + '</span>' +
                    '</div>' +
                    '<div class="regex-match-text">' + escapeHtml(matchObj.match) + '</div>';

                if (matchObj.groups.length > 0) {
                    html += '<div class="regex-match-groups">';
                    matchObj.groups.forEach(function(group, gIdx) {
                        if (group !== undefined) {
                            html += '<div class="regex-match-group">' +
                                '<span class="regex-match-group-label">Group ' + (gIdx + 1) + ':</span>' +
                                '<span class="regex-match-group-value">' + escapeHtml(group) + '</span>' +
                            '</div>';
                        }
                    });
                    html += '</div>';
                }

                html += '</div>';
            });

            listDiv.innerHTML = html;
        }

        function renderReplace() {
            var testStr = document.getElementById('testString').value;
            var replaceStr = document.getElementById('replaceString').value;
            var resultDiv = document.getElementById('replaceResult');

            if (!currentRegex || currentMatches.length === 0) {
                resultDiv.innerHTML = '<div class="regex-info">No matches to replace</div>';
                return;
            }

            try {
                var result = testStr.replace(currentRegex, replaceStr);
                resultDiv.textContent = result;
            } catch (e) {
                resultDiv.innerHTML = '<div class="regex-error">Invalid replacement string</div>';
            }
        }

        function generateCode() {
            var pattern = document.getElementById('regexPattern').value;
            var flags = getFlags();
            var testStr = document.getElementById('testString').value;
            var replaceStr = document.getElementById('replaceString').value;

            var escapedPattern = pattern.replace(/\\/g, '\\\\').replace(/'/g, "\\'");

            var jsCode = 'const regex = /' + escapeHtml(pattern) + '/' + flags + ';\n' +
                'const text = \'' + escapeHtml(testStr.substring(0, 50)) + '...\';\n\n' +
                '// Test for match\n' +
                'const hasMatch = regex.test(text);\n\n' +
                '// Get all matches\n' +
                'const matches = text.match(regex);\n\n' +
                '// Replace\n' +
                'const result = text.replace(regex, \'' + escapeHtml(replaceStr) + '\');';

            document.getElementById('jsCode').innerHTML = '<button class="regex-code-copy" onclick="copyCode(\'js\')">Copy</button>' +
                '<pre>' + jsCode + '</pre>';

            var pythonCode = 'import re\n\n' +
                'pattern = r\'' + escapeHtml(pattern) + '\'\n' +
                'text = \'' + escapeHtml(testStr.substring(0, 50)) + '...\'\n\n' +
                '# Find all matches\n' +
                'matches = re.findall(pattern, text' + (flags.indexOf('i') !== -1 ? ', re.IGNORECASE' : '') + ')\n\n' +
                '# Replace\n' +
                'result = re.sub(pattern, \'' + escapeHtml(replaceStr) + '\', text)';

            document.getElementById('pythonCode').innerHTML = '<button class="regex-code-copy" onclick="copyCode(\'python\')">Copy</button>' +
                '<pre>' + pythonCode + '</pre>';

            var javaFlags = '';
            if (flags.indexOf('i') !== -1) javaFlags += ' | Pattern.CASE_INSENSITIVE';
            if (flags.indexOf('m') !== -1) javaFlags += ' | Pattern.MULTILINE';
            if (javaFlags) javaFlags = javaFlags.substring(3);

            var javaCode = 'import java.util.regex.*;\n\n' +
                'String pattern = "' + escapeHtml(pattern) + '";\n' +
                'String text = "' + escapeHtml(testStr.substring(0, 50)) + '...";\n\n' +
                'Pattern p = Pattern.compile(pattern' + (javaFlags ? ', ' + javaFlags : '') + ');\n' +
                'Matcher m = p.matcher(text);\n\n' +
                '// Find matches\n' +
                'while (m.find()) {\n' +
                '    System.out.println(m.group());\n' +
                '}';

            document.getElementById('javaCode').innerHTML = '<button class="regex-code-copy" onclick="copyCode(\'java\')">Copy</button>' +
                '<pre>' + javaCode + '</pre>';

            var phpPattern = pattern.replace(/\//g, '\\/');
            var phpCode = '&lt;?php\n' +
                '$pattern = \'/' + escapeHtml(phpPattern) + '/' + flags + '\';\n' +
                '$text = \'' + escapeHtml(testStr.substring(0, 50)) + '...\';\n\n' +
                '// Find all matches\n' +
                'preg_match_all($pattern, $text, $matches);\n\n' +
                '// Replace\n' +
                '$result = preg_replace($pattern, \'' + escapeHtml(replaceStr) + '\', $text);\n' +
                '?&gt;';

            document.getElementById('phpCode').innerHTML = '<button class="regex-code-copy" onclick="copyCode(\'php\')">Copy</button>' +
                '<pre>' + phpCode + '</pre>';

            var rubyCode = 'pattern = /' + escapeHtml(pattern) + '/' + flags + '\n' +
                'text = \'' + escapeHtml(testStr.substring(0, 50)) + '...\'\n\n' +
                '# Find all matches\n' +
                'matches = text.scan(pattern)\n\n' +
                '# Replace\n' +
                'result = text.gsub(pattern, \'' + escapeHtml(replaceStr) + '\')';

            document.getElementById('rubyCode').innerHTML = '<button class="regex-code-copy" onclick="copyCode(\'ruby\')">Copy</button>' +
                '<pre>' + rubyCode + '</pre>';
        }

        function escapeHtml(text) {
            var map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, function(m) { return map[m]; });
        }

        function switchResultTab(tab) {
            var tabs = ['highlighted', 'matches', 'replace'];
            tabs.forEach(function(t) {
                document.getElementById(t + '-tab').classList.remove('active');
            });
            document.getElementById(tab + '-tab').classList.add('active');

            document.querySelectorAll('.regex-tabs .regex-tab').forEach(function(btn) {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
        }

        function switchCodeTab(lang) {
            var langs = ['javascript', 'python', 'java', 'php', 'ruby'];
            langs.forEach(function(l) {
                document.getElementById(l + '-code').classList.remove('active');
            });
            document.getElementById(lang + '-code').classList.add('active');

            var parent = event.target.parentElement;
            parent.querySelectorAll('.regex-tab').forEach(function(btn) {
                btn.classList.remove('active');
            });
            event.target.classList.add('active');
        }

        function loadPattern(pattern, flags, testStr) {
            document.getElementById('regexPattern').value = pattern;
            document.getElementById('testString').value = testStr;

            ['flagG', 'flagI', 'flagM', 'flagS', 'flagU'].forEach(function(id) {
                document.getElementById(id).checked = false;
            });

            if (flags.indexOf('g') !== -1) document.getElementById('flagG').checked = true;
            if (flags.indexOf('i') !== -1) document.getElementById('flagI').checked = true;
            if (flags.indexOf('m') !== -1) document.getElementById('flagM').checked = true;
            if (flags.indexOf('s') !== -1) document.getElementById('flagS').checked = true;
            if (flags.indexOf('u') !== -1) document.getElementById('flagU').checked = true;

            testRegex();
        }

        function clearPattern() {
            document.getElementById('regexPattern').value = '';
            document.getElementById('testString').value = '';
            document.getElementById('highlightedResult').innerHTML = '<div class="regex-info">Enter a pattern to test</div>';
            document.getElementById('matchesList').innerHTML = '';
            document.getElementById('matchCount').textContent = '0';
            document.getElementById('groupCount').textContent = '0';
            document.getElementById('execTime').textContent = '0ms';
        }

        function shareRegex() {
            var pattern = document.getElementById('regexPattern').value;
            var testStr = document.getElementById('testString').value;
            var flags = getFlags();

            var config = {
                pattern: pattern,
                flags: flags,
                test: testStr
            };

            var encoded = btoa(JSON.stringify(config));
            var url = window.location.origin + window.location.pathname + '?r=' + encoded;

            navigator.clipboard.writeText(url).then(function() {
                alert('Shareable link copied to clipboard!');
            }).catch(function() {
                alert('Failed to copy link. URL: ' + url);
            });
        }

        function copyCode(lang) {
            var codeMap = {
                'js': 'jsCode',
                'python': 'pythonCode',
                'java': 'javaCode',
                'php': 'phpCode',
                'ruby': 'rubyCode'
            };

            var codeBlock = document.getElementById(codeMap[lang]);
            var text = codeBlock.querySelector('pre').textContent;

            navigator.clipboard.writeText(text).then(function() {
                alert('Code copied to clipboard!');
            }).catch(function() {
                alert('Failed to copy code');
            });
        }

        function loadFromURL() {
            var params = new URLSearchParams(window.location.search);
            var configParam = params.get('r');

            if (configParam) {
                try {
                    var config = JSON.parse(atob(configParam));
                    document.getElementById('regexPattern').value = config.pattern || '';
                    document.getElementById('testString').value = config.test || '';

                    ['flagG', 'flagI', 'flagM', 'flagS', 'flagU'].forEach(function(id) {
                        document.getElementById(id).checked = false;
                    });

                    var flags = config.flags || '';
                    if (flags.indexOf('g') !== -1) document.getElementById('flagG').checked = true;
                    if (flags.indexOf('i') !== -1) document.getElementById('flagI').checked = true;
                    if (flags.indexOf('m') !== -1) document.getElementById('flagM').checked = true;
                    if (flags.indexOf('s') !== -1) document.getElementById('flagS').checked = true;
                    if (flags.indexOf('u') !== -1) document.getElementById('flagU').checked = true;

                    testRegex();
                } catch (e) {
                    console.error('Failed to load shared regex:', e);
                }
            }
        }

        document.getElementById('replaceString').addEventListener('input', function() {
            if (currentMatches.length > 0) {
                renderReplace();
            }
        });

        loadFromURL();
        testRegex();
    </script>
</div>
    <%@ include file="body-close.jsp"%>

</html>

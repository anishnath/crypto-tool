<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());

    String aiToolId = "developer-tools/online-compiler";
    if (request.getAttribute("preferredLanguage") != null) {
        aiToolId = "developer-tools/online-" + ((String) request.getAttribute("preferredLanguage")).toLowerCase() + "-compiler";
    }
    request.setAttribute("aiToolId", aiToolId);
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="/modern/components/ai-assistant-vars.inc.jsp" %>
<%
    // 301 redirect for direct access to onecompiler.jsp
    String uri = request.getRequestURI();
    if (uri != null && uri.endsWith("/onecompiler.jsp")) {
        String target = request.getContextPath() + "/online-compiler/";
        response.setStatus(301);
        response.setHeader("Location", target);
        return;
    }

    // Get SEO attributes with defaults
    String pageTitle = (request.getAttribute("pageTitle") != null)
        ? (String) request.getAttribute("pageTitle")
        : "AI-Powered Online Compiler & IDE - Run Code Online (60+ Languages) | Free";
    String pageDescription = (request.getAttribute("pageDescription") != null)
        ? (String) request.getAttribute("pageDescription")
        : "Free AI-powered online compiler and IDE. Generate code from English, auto-fix errors with AI, and get instant explanations. Run Python, Java, C++, JavaScript, Go, Rust and 60+ languages. No setup required.";
    String pageUrl = (request.getAttribute("pageUrl") != null)
        ? (String) request.getAttribute("pageUrl")
        : "https://8gwifi.org/online-compiler/";
    // Extract URL path for seo-tool-page (e.g., "online-java-compiler/" from full URL)
    String toolUrlPath = pageUrl.replace("https://8gwifi.org/", "");
    // If a wrapper page set language-specific FAQs, skip generic FAQs to avoid duplicate FAQPage JSON-LD
    boolean hasLanguageFaq = (request.getAttribute("languageFaqJsonLd") != null);

    // Per-language SEO content (differentiates each /online-X-compiler/ page so they are not near-duplicates)
    String ocLang = (request.getAttribute("preferredLanguage") != null)
        ? ((String) request.getAttribute("preferredLanguage")).toLowerCase() : "python";
    String[] ocExample = ocLangExample(ocLang);   // [displayName, escapedHelloWorldCode]
    String ocLangName = ocExample[0];
    String ocExampleCode = ocExample[1];

    // Algorithm visualization UI: Java + Python only (or generic compiler with client-side gating)
    String preferredLangAttr = (String) request.getAttribute("preferredLanguage");
    boolean ocVizUiEnabled = isVizUiEnabledForPage(preferredLangAttr);
%>
<%!
    /** Viz UI loads on Java/Python/Go pages and the generic multi-language compiler (client gates by selection). */
    private boolean isVizUiEnabledForPage(String preferredLang) {
        if (preferredLang == null || preferredLang.isEmpty()) {
            return true;
        }
        String lang = preferredLang.toLowerCase();
        return "java".equals(lang) || "python".equals(lang) || "go".equals(lang) || "cpp".equals(lang) || "rust".equals(lang);
    }

    // Returns {displayName, HTML-escaped Hello-World snippet} for a language slug.
    private String[] ocLangExample(String lang) {
        if (lang == null) lang = "python";
        switch (lang) {
            case "c": return new String[]{"C",
                "#include &lt;stdio.h&gt;\n\nint main(void) {\n    printf(\"Hello, World!\\n\");\n    return 0;\n}"};
            case "cpp": case "c++": return new String[]{"C++",
                "#include &lt;iostream&gt;\n\nint main() {\n    std::cout &lt;&lt; \"Hello, World!\" &lt;&lt; std::endl;\n    return 0;\n}"};
            case "csharp": case "c#": return new String[]{"C#",
                "using System;\n\nclass Program {\n    static void Main() {\n        Console.WriteLine(\"Hello, World!\");\n    }\n}"};
            case "java": return new String[]{"Java",
                "public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello, World!\");\n    }\n}"};
            case "javascript": case "js": case "nodejs": return new String[]{"JavaScript",
                "function greet(name) {\n  return `Hello, ${name}!`;\n}\n\nconsole.log(greet(\"World\"));"};
            case "typescript": case "ts": return new String[]{"TypeScript",
                "function greet(name: string): string {\n  return `Hello, ${name}!`;\n}\n\nconsole.log(greet(\"World\"));"};
            case "go": case "golang": return new String[]{"Go",
                "package main\n\nimport \"fmt\"\n\nfunc main() {\n    fmt.Println(\"Hello, World!\")\n}"};
            case "rust": return new String[]{"Rust",
                "fn main() {\n    println!(\"Hello, World!\");\n}"};
            case "ruby": return new String[]{"Ruby",
                "def greet(name)\n  \"Hello, #{name}!\"\nend\n\nputs greet(\"World\")"};
            case "php": return new String[]{"PHP",
                "&lt;?php\nfunction greet($name) {\n    return \"Hello, $name!\";\n}\n\necho greet(\"World\");"};
            case "swift": return new String[]{"Swift",
                "func greet(_ name: String) -&gt; String {\n    return \"Hello, \\(name)!\"\n}\n\nprint(greet(\"World\"))"};
            case "kotlin": return new String[]{"Kotlin",
                "fun main() {\n    println(\"Hello, World!\")\n}"};
            case "scala": return new String[]{"Scala",
                "object Main extends App {\n  println(\"Hello, World!\")\n}"};
            case "dart": return new String[]{"Dart",
                "void main() {\n  print('Hello, World!');\n}"};
            case "r": return new String[]{"R",
                "greet &lt;- function(name) {\n  paste0(\"Hello, \", name, \"!\")\n}\n\nprint(greet(\"World\"))"};
            case "lua": return new String[]{"Lua",
                "local function greet(name)\n  return \"Hello, \" .. name .. \"!\"\nend\n\nprint(greet(\"World\"))"};
            case "bash": case "shell": return new String[]{"Bash",
                "#!/bin/bash\ngreet() {\n  echo \"Hello, $1!\"\n}\n\ngreet \"World\""};
            case "perl": return new String[]{"Perl",
                "use strict;\nuse warnings;\n\nsub greet { return \"Hello, $_[0]!\"; }\nprint greet(\"World\"), \"\\n\";"};
            case "haskell": return new String[]{"Haskell",
                "main :: IO ()\nmain = putStrLn \"Hello, World!\""};
            default: return new String[]{"Python",
                "def greet(name):\n    return f\"Hello, {name}!\"\n\nprint(greet(\"World\"))"};
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index, follow, max-image-preview:large">

    <!-- SEO Component (absolute path needed since this file is included from subdirectories) -->
    <% if (!hasLanguageFaq) { %>
    <!-- Generic FAQs — only rendered on /online-compiler/ (no language-specific wrapper) -->
    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="<%= pageTitle %>" />
        <jsp:param name="toolDescription" value="<%= pageDescription %>" />
        <jsp:param name="toolCategory" value="DeveloperApplication" />
        <jsp:param name="toolUrl" value="<%= toolUrlPath %>" />
        <jsp:param name="toolKeywords" value="ai online compiler, ai code generator, online compiler, run code online, ai fix code errors, ai explain code, online ide, compile code online, execute code online, code editor online, ai programming assistant, run python online, run java online, run javascript online, free compiler, code playground, programming online, ai code assistant free" />
        <jsp:param name="toolImage" value="onecompiler-preview.png" />
        <jsp:param name="toolFeatures" value="AI code generator - describe in English and get runnable code,AI error fix - automatically fixes compilation and runtime errors,AI code explainer - explains code or errors in plain English,Run code in 60+ programming languages,VS Code editor (Monaco) with IntelliSense,Instant code execution with real-time output,Share code snippets via unique URLs,Embed runnable code in websites and blogs,Multi-file project support,Stdin/stdout and compiler flags,No installation or signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Write or Generate Code|Select a language and write code in the Monaco editor or press Ctrl+Shift+A to describe what you want in plain English and let AI generate it,Run and Fix|Click Run or press Ctrl+Enter. If there are errors the AI Fix button appears to automatically correct your code,Explain and Share|Select any code and click Explain for an AI explanation. Share your code via unique URLs or embed it in your website" />
        <jsp:param name="faq1q" value="How does the AI code generator work?" />
        <jsp:param name="faq1a" value="Click the AI button or press Ctrl+Shift+A, then describe what you want in plain English like 'merge sort function' or 'HTTP server that returns JSON'. The AI generates complete runnable code in your selected language and streams it directly into the editor." />
        <jsp:param name="faq2q" value="Can AI fix my code errors automatically?" />
        <jsp:param name="faq2a" value="Yes. When your code has errors, an AI Fix button appears in the toolbar. Click it and the AI reads your code and the error output, then replaces your code with a corrected version. It works for compilation errors, runtime errors, and logic issues across all 60+ supported languages." />
        <jsp:param name="faq3q" value="What programming languages are supported?" />
        <jsp:param name="faq3a" value="You can compile and run 60+ languages online including Python, Java, C, C++, JavaScript, TypeScript, Go, Rust, Ruby, PHP, Swift, Kotlin, Scala, R, and many more. The AI features work with all supported languages, generating and fixing code in whichever language you select." />
        <jsp:param name="faq4q" value="Can AI explain my code or errors?" />
        <jsp:param name="faq4a" value="Yes. Select any code and click the Explain button for a clear explanation of what the code does. If your code produced an error, the AI automatically explains the error, why it happened, and how to fix it." />
        <jsp:param name="faq5q" value="Is this free? Do I need to sign up?" />
        <jsp:param name="faq5a" value="Completely free with no signup required. The AI code generation, error fixing, code explanation, code execution, sharing, and embedding features are all available immediately with no account needed." />
    </jsp:include>
    <% } else { %>
    <!-- Language-specific page — no generic FAQs (avoids duplicate FAQPage JSON-LD in GSC) -->
    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="<%= pageTitle %>" />
        <jsp:param name="toolDescription" value="<%= pageDescription %>" />
        <jsp:param name="toolCategory" value="DeveloperApplication" />
        <jsp:param name="toolUrl" value="<%= toolUrlPath %>" />
        <jsp:param name="toolKeywords" value="ai online compiler, ai code generator, online compiler, run code online, ai fix code errors, ai explain code, online ide, compile code online, execute code online, code editor online, ai programming assistant, free compiler, code playground, programming online, ai code assistant free" />
        <jsp:param name="toolImage" value="onecompiler-preview.png" />
        <jsp:param name="toolFeatures" value="AI code generator - describe in English and get runnable code,AI error fix - automatically fixes compilation and runtime errors,AI code explainer - explains code or errors in plain English,Run code in 60+ programming languages,VS Code editor (Monaco) with IntelliSense,Instant code execution with real-time output,Share code snippets via unique URLs,Embed runnable code in websites and blogs,Multi-file project support,Stdin/stdout and compiler flags,No installation or signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Write or Generate Code|Select a language and write code in the Monaco editor or press Ctrl+Shift+A to describe what you want in plain English and let AI generate it,Run and Fix|Click Run or press Ctrl+Enter. If there are errors the AI Fix button appears to automatically correct your code,Explain and Share|Select any code and click Explain for an AI explanation. Share your code via unique URLs or embed it in your website" />
    </jsp:include>
    <% } %>

    <!-- Canonical is emitted by seo-tool-page.jsp above -->

        <% if (request.getAttribute("preferredLanguage") != null) { %>
        <script>
            window.PREFERRED_LANG = '<%= request.getAttribute("preferredLanguage") %>';
        </script>
        <% } %>

    <!-- Language-specific FAQ JSON-LD (from wrapper pages) -->
    <% if (request.getAttribute("languageFaqJsonLd") != null) { %>
    <script type="application/ld+json">
<%= request.getAttribute("languageFaqJsonLd") %>
    </script>
    <% } %>

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">

    <!-- Modern CSS - Critical -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ide-page.css?v=<%=cacheVersion%>">
    <% if (ocVizUiEnabled) { %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/viz-workspace.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/oc-ownership.css?v=<%=cacheVersion%>">
    <% } %>
    <%@ include file="/modern/components/ai-assistant-head.inc.jsp" %>

    <!-- Deferred CSS -->
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <!-- Monaco Editor CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs/editor/editor.main.min.css">

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Ad System (absolute paths needed since this file is included from subdirectories) -->
    <%@ include file="/modern/ads/ad-init.jsp" %>

    <!-- Analytics -->
    <%@ include file="/modern/components/analytics.jsp" %>

    <style>
        /* IDE-specific overrides (minimal - most styles in ide-page.css) */
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
                    --header-bar-height: 90px;
                }

                /* Light theme (nav toggle sets <html data-theme="light">).
                   Re-themes the IDE chrome + editor area; the visualizer reads
                   these same --oc-* vars so it follows automatically. */
                [data-theme="light"] {
                    --oc-bg-dark: #ffffff;
                    --oc-bg-darker: #f3f3f3;
                    --oc-bg-sidebar: #ececed;
                    --oc-border: #d4d4d4;
                    --oc-text: #444444;
                    --oc-text-bright: #1a1a1a;
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
                    padding-top: var(--nav-height, 72px);
                }

                /* IDE Body: workspace + right rail side-by-side */
                .ide-body {
                    display: flex;
                    flex: 1;
                    min-height: 0;
                    overflow: hidden;
                }

                /* Right Rail Ad Column */
                .ide-right-rail {
                    display: none;
                }

                @media (min-width: 1024px) {
                    .ide-right-rail {
                        display: flex;
                        flex-direction: column;
                        width: 300px;
                        flex-shrink: 0;
                        gap: 16px;
                        padding: 12px 8px 12px 0;
                        background: var(--oc-bg-dark);
                        border-left: 1px solid var(--oc-border);
                        overflow-y: auto;
                    }

                    .ide-right-rail .ad-ide-rail-slot {
                        width: 300px;
                        min-height: 250px;
                        background: var(--oc-bg-darker);
                        border: 1px solid var(--oc-border);
                        border-radius: 6px;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                    }

                    .ide-right-rail .ad-ide-rail-sticky {
                        position: sticky;
                        top: 12px;
                    }

                    .ide-right-rail .ad-label {
                        font-size: 9px;
                        color: #555;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        text-align: center;
                        padding: 4px 0;
                    }

                    .ide-workspace {
                        flex: 1;
                        min-width: 0;
                    }
                }

                @media (min-width: 1400px) {
                    .ide-right-rail {
                        width: 336px;
                    }

                    .ide-right-rail .ad-ide-rail-slot {
                        width: 336px;
                        min-height: 280px;
                    }
                }

                /* Header Bar with H1 and Ad - Always visible above fold */
                .ide-header-bar {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 1rem;
                    padding: 0.5rem 1rem;
                    background: var(--oc-bg-darker);
                    border-bottom: 1px solid var(--oc-border);
                    min-height: var(--header-bar-height);
                }

                .ide-header-bar h1 {
                    margin: 0;
                    font-size: 1.125rem;
                    font-weight: 600;
                    color: var(--oc-text-bright);
                    flex: 1;
                    line-height: 1.3;
                }

                .ide-header-ad {
                    flex-shrink: 0;
                    min-width: 728px;
                    height: 90px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .ide-header-ad-mobile {
                    display: none;
                }

                .ide-workspace {
                    display: flex;
                    flex-direction: column;
                    flex: 1;
                    min-width: 0;
                    height: calc(100vh - var(--nav-height, 72px) - var(--header-bar-height, 90px));
                    min-height: 400px;
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

                .output-content.stdout {
                    color: var(--oc-success);
                }

                .output-content.stderr {
                    color: var(--oc-error);
                }

                .output-content.system {
                    color: var(--oc-text);
                    font-style: italic;
                }

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
                    background: rgba(255, 255, 255, 0.1);
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

                /* Tablet - hide leaderboard ad, show mobile ad */
                @media (max-width: 991px) {
                    .ide-header-ad {
                        display: none;
                    }

                    .ide-header-ad-mobile {
                        display: block;
                        width: 100%;
                        text-align: center;
                        padding: 0.5rem 0;
                    }

                    .ide-header-bar {
                        flex-direction: column;
                        align-items: flex-start;
                        min-height: auto;
                        --header-bar-height: 120px;
                    }

                    .ide-header-bar h1 {
                        font-size: 1rem;
                    }
                }

                /* Mobile Responsive */
                @media (max-width: 768px) {
                    :root {
                        --header-bar-height: 140px;
                    }

                    .ide-container {
                        padding-top: var(--nav-height-mobile, 64px);
                    }

                    .ide-workspace {
                        height: calc(100vh - var(--nav-height-mobile, 64px) - var(--header-bar-height, 140px));
                    }

                    .ide-header-bar h1 {
                        font-size: 0.9375rem;
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

                /* ── AI toolbar buttons ── */
                .oc-ai-btn {
                    background: rgba(129,140,248,0.12) !important;
                    color: #a5b4fc !important;
                    font-weight: 600;
                }
                .oc-ai-btn:hover {
                    background: rgba(129,140,248,0.22) !important;
                }
                #aiFixBtn {
                    background: rgba(244,135,113,0.12) !important;
                    color: #f48771 !important;
                }
                #aiFixBtn:hover {
                    background: rgba(244,135,113,0.22) !important;
                }
                /* Light theme: the lavender/salmon text washes out on white — deepen it. */
                [data-theme="light"] .oc-ai-btn {
                    background: rgba(99,102,241,0.12) !important;
                    color: #4338ca !important;
                }
                [data-theme="light"] .oc-ai-btn:hover {
                    background: rgba(99,102,241,0.20) !important;
                }
                [data-theme="light"] #aiFixBtn {
                    background: rgba(217,83,79,0.12) !important;
                    color: #c0392b !important;
                }
                [data-theme="light"] #aiFixBtn:hover {
                    background: rgba(217,83,79,0.20) !important;
                }
                @media (max-width: 768px) {
                    .oc-ai-btn span,
                    #aiFixBtn span {
                        display: none;
                    }
                }

                <% if (ocVizUiEnabled) { %>
                /* Viz execution line in Monaco (see also viz-workspace.css) */
                .viz-line-highlight {
                    background: rgba(99, 102, 241, 0.28) !important;
                    border-left: 3px solid #818cf8 !important;
                }
                .viz-line-gutter {
                    background: #6366f1 !important;
                    width: 4px !important;
                    margin-left: 3px;
                }
                .viz-exec-glyph {
                    background: #6366f1;
                    border-radius: 50%;
                    width: 10px !important;
                    height: 10px !important;
                    margin-left: 6px;
                    margin-top: 6px;
                    box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.35);
                }
                <% } %>

                /* Embed Modal */
                .embed-modal-overlay {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: rgba(0, 0, 0, 0.7);
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
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
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
                    background: rgba(0, 0, 0, 0.7);
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
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
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
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
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

    <!-- jQuery (required for some functionality) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
</head>
<body class="ide-layout">
    <!-- Modern Navigation -->
    <%@ include file="/modern/components/nav-header.jsp" %>

    <div class="ide-container">

        <!-- Header Bar with H1 and Ad - Always visible above fold -->
        <div class="ide-header-bar">
            <h1><%= (request.getAttribute("h1Text") != null) ? request.getAttribute("h1Text") : "Online Compiler - Run Code in 60+ Languages" %></h1>
            <!-- Desktop Leaderboard Ad (728x90) -->
            <div class="ide-header-ad">
                <%@ include file="/modern/ads/ad-leaderboard.jsp" %>
            </div>
            <!-- Mobile Ad (320x100 or 300x250) -->
            <div class="ide-header-ad-mobile">
                <%@ include file="/modern/ads/ad-mobile-banner.jsp" %>
            </div>
        </div>

        <!-- IDE Body: workspace + right rail side-by-side -->
        <div class="ide-body">

        <!-- IDE Workspace -->
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

<%--                            <button class="ide-toolbar-btn" onclick="loadTemplate()" title="Load Template">--%>
<%--                                <i class="fas fa-file-code"></i><span>Template</span>--%>
<%--                            </button>--%>
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
                            <% if (ocVizUiEnabled) { %>
                            <button id="vizBtn" class="ide-toolbar-btn viz-btn" type="button" title="Visualize algorithm (Ctrl+Shift+V)"<% if (preferredLangAttr == null) { %> style="display:none"<% } %>>
                                <i class="fas fa-project-diagram"></i><span>Visualize</span>
                            </button>
                            <% } %>

                            <div class="toolbar-divider"></div>

                            <button type="button" class="ide-toolbar-btn oc-ai-btn" id="btnOneCompilerAI" title="AI assistant — generate, fix, explain (Ctrl+Shift+A)">
                                <i class="fas fa-wand-magic-sparkles"></i><span>AI</span>
                            </button>
                            <button type="button" class="ide-toolbar-btn" id="aiFixBtn" onclick="openAIFix()" title="AI: Fix errors in your code" style="display:none">
                                <i class="fas fa-wrench"></i><span>AI Fix</span>
                            </button>
                            <button type="button" class="ide-toolbar-btn" onclick="openAIExplain()" title="AI: Explain selected code or full code">
                                <i class="fas fa-lightbulb"></i><span>Explain</span>
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
                            <a class="ide-toolbar-btn" href="<%=request.getContextPath()%>/code-playground/<% if (request.getAttribute("preferredLanguage") != null) { %>?panes=<%= request.getAttribute("preferredLanguage") %>,javascript<% } %>" title="Compare languages and versions side by side in the Code Playground">
                                <i class="fas fa-code-compare"></i><span>Compare</span>
                            </a>
                        </div>

                        <!-- Main Content -->
                        <div class="ide-main" id="ideMain">
                            <% if (ocVizUiEnabled) { %>
                            <div class="ide-code-viz-row" id="ideCodeVizRow">
                                <div class="ide-editor-section">
                                    <div class="ide-editor-tabs" id="fileTabs"></div>
                                    <div class="ide-editor-container">
                                        <div id="codeEditor"></div>
                                    </div>
                                </div>
                                <div class="viz-split-handle" id="vizSplitHandle" aria-hidden="true" title="Drag to resize"></div>
                                <div class="viz-pane-dock" id="vizPaneDock" aria-hidden="true">
                                    <div id="vizShell" class="viz-shell viz-mode-attached" hidden>
                                        <div class="viz-shell-header" id="vizShellHeader">
                                            <h3 id="vizShellTitle"><i class="fas fa-project-diagram"></i> Visualization</h3>
                                            <div class="viz-shell-actions">
                                                <button type="button" class="viz-shell-action" id="vizAttachBtn" title="Attach to editor pane" hidden><i class="fas fa-columns"></i></button>
                                                <button type="button" class="viz-shell-action" id="vizDetachBtn" title="Detach to floating panel"><i class="fas fa-up-right-from-square"></i></button>
                                                <button type="button" class="viz-shell-action viz-shell-close" id="vizCloseBtn" title="Close visualization">&times;</button>
                                            </div>
                                        </div>
                                        <div class="viz-shell-tabs">
                                            <button type="button" class="viz-shell-tab active" data-viz-tab="stage">Visualization</button>
                                            <button type="button" class="viz-shell-tab viz-tab-ownership" data-viz-tab="ownership" hidden>Ownership</button>
                                            <button type="button" class="viz-shell-tab" data-viz-tab="templates">Templates</button>
                                            <button type="button" class="viz-shell-tab" data-viz-tab="log">Log</button>
                                            <button type="button" class="viz-shell-tab" data-viz-tab="help">Help</button>
                                        </div>
                                        <div class="viz-shell-body">
                                            <div class="viz-shell-pane active" data-viz-pane="stage">
                                                <div class="viz-capture-root" id="vizCaptureRoot">
                                                    <div class="viz-step-card" id="vizStepCard"></div>
                                                    <div class="viz-stage" id="vizStage"></div>
                                                </div>
                                                <div class="viz-playback" id="vizPlayback"></div>
                                                <p class="viz-record-status" id="vizRecordStatus" hidden></p>
                                            </div>
                                            <div class="viz-shell-pane" data-viz-pane="templates">
                                                <div id="vizTemplatesContent" class="viz-tpl-panel">Loading templates…</div>
                                            </div>
                                            <div class="viz-shell-pane" data-viz-pane="log">
                                                <div id="vizLogContent" class="ide-viz-log">// Viz command log appears here after Visualize</div>
                                            </div>
                                            <div class="viz-shell-pane" data-viz-pane="help">
                                                <div id="vizHelpContent" class="viz-help-panel">Loading visualization help…</div>
                                            </div>
                                            <div class="viz-shell-pane" data-viz-pane="ownership">
                                                <div id="vizOwnership" class="viz-ownership">Click <strong>Ownership</strong> to see Rust permissions &amp; runtime memory.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="ide-editor-section">
                                <div class="ide-editor-tabs" id="fileTabs"></div>
                                <div class="ide-editor-container">
                                    <div id="codeEditor"></div>
                                </div>
                            </div>
                            <% } %>

                            <!-- Resize Handle -->
                            <div class="resize-handle" id="resizeHandle"></div>

                            <!-- Bottom Panel -->
                            <div class="ide-panel" id="bottomPanel">
                                <div class="ide-panel-header">
                                    <div class="ide-panel-tabs">
                                        <button class="ide-panel-tab active" data-panel="output"
                                            onclick="switchPanel('output')">
                                            <i class="fas fa-terminal"></i> Output
                                        </button>
                                        <button class="ide-panel-tab" data-panel="input" onclick="switchPanel('input')">
                                            <i class="fas fa-keyboard"></i> Input
                                        </button>
                                        <button class="ide-panel-tab" data-panel="problems"
                                            onclick="switchPanel('problems')">
                                            Problems<span id="problemsBadge" class="badge"
                                                style="display:none;">0</span>
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
                                        <div id="outputContent" class="output-content system">// Click "Run" to execute
                                            your code (Ctrl+Enter)</div>
                                    </div>
                                    <div class="ide-panel-pane" id="inputPane">
                                        <textarea id="stdinInput" class="input-textarea"
                                            placeholder="Enter input for your program (stdin)..."></textarea>
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
                                <i class="fas fa-keyboard"></i> Ctrl+Enter run<% if (ocVizUiEnabled) { %> · Ctrl+Shift+V visualize<% } %>
                            </div>
                        </div>
                    </div><!-- End IDE Workspace -->

        <!-- Right Rail Ad Column (Desktop >= 1024px) -->
        <aside class="ide-right-rail" id="ideRightRail">
            <%@ include file="/modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="/modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>

        </div><!-- End IDE Body -->

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
                                        <a href="https://twitter.com/anish2good" target="_blank"
                                            class="share-social-btn follow">
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
                                        <input type="checkbox" id="embedReadonly" onchange="updateEmbedCode()">
                                        Read-only
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
                                    <i class="fas fa-info-circle"></i> First share your code to get a snippet ID, then
                                    embed it.
                                </p>
                            </div>
                        </div>
                    </div>

                    <% if (ocVizUiEnabled) { %>
                    <!-- Visualization floating host (shell moves here when detached) -->
                    <div class="viz-modal-overlay" id="vizModal" aria-hidden="true">
                        <div class="viz-float-host" id="vizFloatHost"></div>
                    </div>
                    <% } %>

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
                                        <a href="https://twitter.com/anish2good" target="_blank"
                                            class="share-social-btn follow">
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
                                        <i class="fas fa-exclamation-circle"></i> Failed to create share link. Please
                                        try again.
                                    </div>
                                </div>
                            </div>
                            <div class="share-modal-footer">
                                <p>Powered by <a href="https://8gwifi.org" target="_blank">8gwifi.org</a> - Free
                                    Developer Tools</p>
                            </div>
                        </div>
                    </div>

            </div><!-- End IDE Workspace -->

            <!-- Transition Ad (Between IDE and SEO Content) -->
            <section class="ide-transition-ad">
                <%@ include file="/modern/ads/ad-in-content-top.jsp" %>
            </section>

            <!-- SEO Content Section (scrollable below IDE) -->
            <main class="ide-seo-content" id="seoSection">
                <!-- Description Section -->
                <section class="ide-description-section">
                    <div class="ide-description-inner">
                        <div class="ide-description-content">
                            <h2><%= (request.getAttribute("h1Text") != null) ? request.getAttribute("h1Text") : "Free Online Compiler - Run Code in 60+ Programming Languages" %></h2>
                            <% if (request.getAttribute("preferredLanguage") != null) { %>
                            <p>Write, compile, and run <strong><%= ocLangName %></strong> code instantly in your browser. This free online <%= ocLangName %> compiler needs no installation or signup &mdash; just type your <%= ocLangName %> program, click Run, and see the output. Supports stdin, multi&#8209;file projects, shareable snippet URLs, and AI help to generate, fix, and explain <%= ocLangName %> code.</p>
                            <% } else { %>
                            <p>Write, compile, and run code instantly in your browser. Our free online compiler supports <strong>60+ programming languages</strong> including Python, Java, C++, JavaScript, Go, Rust, and many more. No installation required.</p>
                            <% } %>
                        </div>
                    </div>
                </section>

                <!-- Info Section -->
                <section class="ide-info-section">
                    <!-- Breadcrumb -->
                    <nav class="ide-breadcrumb" aria-label="Breadcrumb">
                        <a href="/">Home</a> &raquo; <a href="/online-compiler/">Online Compiler</a>
                        <% if (request.getAttribute("preferredLanguage") != null) { %>
                            &raquo; <span><%= pageTitle.replace("Online ", "").replace(" & IDE", "").replace(" | Free", "") %></span>
                        <% } %>
                    </nav>

                    <div class="ide-info-grid">
                        <!-- About Section -->
                        <div class="ide-info-card">
                            <h2><i class="fas fa-info-circle"></i> About Online Compiler</h2>
                            <p>Our <strong>free online compiler</strong> lets you write, compile, and run code
                                instantly in your browser. Supports <a href="/online-python-compiler/"
                                    title="Online Python Compiler">Python</a>, <a href="/online-java-compiler/"
                                    title="Online Java Compiler">Java</a>, <a href="/online-cpp-compiler/"
                                    title="Online C++ Compiler">C++</a>, JavaScript, Go, Rust, and many more
                                languages. No installation required.</p>
                        </div>

                        <!-- Compare / Code Playground (internal link) -->
                        <%
                            String cpLang = (String) request.getAttribute("preferredLanguage");
                            String cpLabel = (cpLang != null && !cpLang.isEmpty())
                                ? (cpLang.substring(0, 1).toUpperCase() + cpLang.substring(1)) : null;
                            String cpHref = request.getContextPath() + "/code-playground/"
                                + (cpLang != null && !cpLang.isEmpty() ? ("?panes=" + cpLang + ",javascript") : "");
                        %>
                        <div class="ide-info-card">
                            <h2><i class="fas fa-code-compare"></i> Compare Languages Side by Side</h2>
                            <% if (cpLabel != null) { %>
                            <p>Want to see how <strong><%= cpLabel %></strong> stacks up against another language?
                                Open the <a href="<%= cpHref %>" title="Compare programming languages side by side">Code Playground</a>
                                to run <%= cpLabel %> next to Python, Go, Rust, or any language &mdash; each pane picks its own
                                language and version, and you run them together.</p>
                            <% } else { %>
                            <p>Run several languages at once in the
                                <a href="<%= cpHref %>" title="Compare programming languages side by side">Code Playground</a>:
                                a split-screen where each pane picks its own language and version, so you can compare
                                Python, Java, Go, C++, Rust and more side by side.</p>
                            <% } %>
                        </div>

                        <!-- Supported Languages -->
                        <div class="ide-info-card">
                            <h2><i class="fas fa-code"></i> Supported Languages</h2>
                            <p><strong>Popular:</strong> Python, Java, C++, C, JavaScript, TypeScript, Go, Rust</p>
                            <p><strong>Web:</strong> PHP, Ruby, Node.js, HTML/CSS</p>
                            <p><strong>Systems:</strong> C, C++, Rust, Go, Swift</p>
                            <p><strong>Functional:</strong> Haskell, Scala, Kotlin, F#, Clojure</p>
                        </div>

                        <!-- Features -->
                        <div class="ide-info-card">
                            <h2><i class="fas fa-star"></i> Features</h2>
                            <ul>
                                <li>Monaco Editor (VS Code) with syntax highlighting</li>
                                <li>Real-time code execution with output streaming</li>
                                <li>Custom compiler flags support (-O2, -Wall, etc.)</li>
                                <li>Share code via unique snippet URLs</li>
                                <li>Keyboard shortcuts (Ctrl+Enter to run)</li>
                            </ul>
                        </div>

                        <% if (!hasLanguageFaq) { %>
                        <!-- FAQ -->
                        <div class="ide-info-card">
                            <h2><i class="fas fa-question-circle"></i> FAQ</h2>
                            <p><strong>Is it free?</strong> Yes, completely free with no registration.</p>
                            <p><strong>Is my code secure?</strong> Yes, runs in isolated sandbox containers.</p>
                            <p><strong>Execution time limit?</strong> Programs have a 30-second limit.</p>
                            <p><strong>Can I share code?</strong> Yes, click Share to get a unique URL.</p>
                        </div>
                        <% } %>

                        <% if (request.getAttribute("seoIntroTitle") != null) { %>
                        <!-- Language-specific intro (from wrapper pages) -->
                        <div class="ide-info-card full-width">
                            <h2><i class="fas fa-terminal"></i> <%= request.getAttribute("seoIntroTitle") %></h2>
                            <p><%= request.getAttribute("seoIntroBody") %></p>
                        </div>
                        <% } %>

                        <% if (request.getAttribute("languageFaqHtml") != null) { %>
                        <!-- Language-specific FAQ (from wrapper pages) -->
                        <div class="ide-info-card">
                            <h2><i class="fas fa-question-circle"></i> FAQ</h2>
                            <div><%= request.getAttribute("languageFaqHtml") %></div>
                        </div>
                        <% } %>

                        <!-- How to Use -->
                        <div class="ide-info-card full-width">
                            <h2><i class="fas fa-play-circle"></i> How to Use Online Compiler</h2>
                            <div class="ide-steps">
                                <div class="ide-step">
                                    <span class="ide-step-number">1</span>
                                    <div class="ide-step-content">
                                        <strong>Select Language</strong>
                                        <p>Choose from 60+ programming languages including Python, Java, C++,
                                            JavaScript, Go, Rust, and more.</p>
                                    </div>
                                </div>
                                <div class="ide-step">
                                    <span class="ide-step-number">2</span>
                                    <div class="ide-step-content">
                                        <strong>Write Your Code</strong>
                                        <p>Use our Monaco editor (same as VS Code) with syntax highlighting,
                                            auto-completion, and error detection.</p>
                                    </div>
                                </div>
                                <div class="ide-step">
                                    <span class="ide-step-number">3</span>
                                    <div class="ide-step-content">
                                        <strong>Run & See Output</strong>
                                        <p>Click Run or press Ctrl+Enter. Your code executes in a secure sandbox and
                                            output appears instantly.</p>
                                    </div>
                                </div>
                                <div class="ide-step">
                                    <span class="ide-step-number">4</span>
                                    <div class="ide-step-content">
                                        <strong>Share or Embed</strong>
                                        <p>Share your code via unique URL or embed interactive code snippets in your
                                            blog, book, or documentation.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- For Authors & Educators -->
                        <div class="ide-info-card full-width highlight">
                            <h2><i class="fas fa-book"></i> For Authors, Educators & Technical Writers</h2>
                            <p>Perfect for <strong>programming books</strong>, <strong>online tutorials</strong>,
                                <strong>technical documentation</strong>, and <strong>educational content</strong>.
                                Embed interactive, runnable code examples directly in your content.</p>
                            <div class="ide-embed-features">
                                <div class="ide-embed-feature">
                                    <i class="fas fa-code"></i>
                                    <strong>Embeddable Widgets</strong>
                                    <p>Copy iframe code and paste into any website, blog, CMS, or e-book platform.</p>
                                </div>
                                <div class="ide-embed-feature">
                                    <i class="fas fa-eye"></i>
                                    <strong>Read-Only Mode</strong>
                                    <p>Show code without allowing edits - perfect for displaying solutions or examples.</p>
                                </div>
                                <div class="ide-embed-feature">
                                    <i class="fas fa-play"></i>
                                    <strong>Auto-Run on Load</strong>
                                    <p>Code executes automatically when readers view your page - instant demonstrations.</p>
                                </div>
                                <div class="ide-embed-feature">
                                    <i class="fas fa-palette"></i>
                                    <strong>Theme Options</strong>
                                    <p>Choose dark or light theme to match your website or publication design.</p>
                                </div>
                            </div>
                            <p class="seo-cta">Click <strong>Embed</strong> button above to generate embed code for your
                                content!</p>
                        </div>

                        <!-- Code Example (language-specific) -->
                        <div class="ide-info-card full-width">
                            <h2><i class="fas fa-file-code"></i> Example: Hello World in <%= ocLangName %></h2>
                            <pre class="ide-code-example"><code><%= ocExampleCode %></code></pre>
                            <p>Copy this <%= ocLangName %> snippet into the editor above and click <strong>Run</strong> to execute it instantly &mdash; no setup required.</p>
                        </div>

                        <!-- Popular Online Compilers -->
                        <div class="ide-info-card full-width">
                            <h2><i class="fas fa-code"></i> Popular Online Compilers</h2>
                            <p>Jump straight to a language-specific page:</p>
                            <div class="ide-related-links">
                                <a href="/online-python-compiler/">Python</a>
                                <a href="/online-javascript-compiler/">JavaScript</a>
                                <a href="/online-typescript-compiler/">TypeScript</a>
                                <a href="/online-ruby-compiler/">Ruby</a>
                                <a href="/online-php-compiler/">PHP</a>
                                <a href="/online-go-compiler/">Go</a>
                                <a href="/online-java-compiler/">Java</a>
                                <a href="/online-c-compiler/">C</a>
                                <a href="/online-cpp-compiler/">C++</a>
                                <a href="/online-csharp-compiler/">C#</a>
                                <a href="/online-rust-compiler/">Rust</a>
                                <a href="/online-swift-compiler/">Swift</a>
                                <a href="/online-scala-compiler/">Scala</a>
                                <a href="/online-dart-compiler/">Dart</a>
                                <a href="/online-kotlin-compiler/">Kotlin</a>
                                <a href="/online-r-compiler/">R</a>
                                <a href="/online-lua-compiler/">Lua</a>
                                <a href="/online-bash-compiler/">Bash</a>
                            </div>
                            <p style="margin-top: 1rem;">Need embeds? See <a href="/embed-online-compiler/">Embed Online Compiler</a>.</p>
                        </div>

                        <!-- Related Developer Tools -->
                        <div class="ide-info-card full-width">
                            <h2><i class="fas fa-link"></i> Related Developer Tools</h2>
                            <div class="ide-related-links">
                                <a href="/regex.jsp" title="Online Regex Tester"><i class="fas fa-code"></i> Regex Tester</a>
                                <a href="/jsonparser.jsp" title="JSON Formatter"><i class="fas fa-file-code"></i> JSON Formatter</a>
                                <a href="/Base64Functions.jsp" title="Base64 Encoder"><i class="fas fa-lock"></i> Base64 Encoder</a>
                                <a href="/diff.jsp" title="Text Diff Tool"><i class="fas fa-exchange-alt"></i> Diff Tool</a>
                                <a href="/MessageDigest.jsp" title="Hash Calculator"><i class="fas fa-hashtag"></i> Hash Calculator</a>
                                <a href="/curlfunctions.jsp" title="cURL Builder"><i class="fas fa-terminal"></i> cURL Builder</a>
                                <a href="/jwt-debugger.jsp" title="JWT Debugger"><i class="fas fa-key"></i> JWT Debugger</a>
                                <a href="/uuid.jsp" title="UUID Generator"><i class="fas fa-random"></i> UUID Generator</a>
                            </div>
                        </div>
                    </div><!-- End ide-info-grid -->
                </section><!-- End ide-info-section -->

                <!-- Mid-Content Ad -->
                <div class="ide-ad-container">
                    <%@ include file="/modern/ads/ad-in-content-mid.jsp" %>
                </div>

                <!-- Support Section -->
                <%@ include file="/modern/components/support-section.jsp" %>

            </main><!-- End ide-seo-content -->
        </div><!-- End ide-container -->

                <!-- Monaco Editor -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs/loader.min.js"></script>
                <% if (ocVizUiEnabled) { %>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-templates.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-api.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-parser.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-render.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-concurrency.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-player.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-recorder.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-ownership.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-ownership-overlay.js?v=<%=cacheVersion%>"></script>
                <script src="<%=request.getContextPath()%>/modern/js/viz/oc-viz-workspace.js?v=<%=cacheVersion%>"></script>
                <% } %>

                <script>
                    // Allow wrapper pages to set a preferred language before initialization
                    if (typeof window !== 'undefined' && window.PREFERRED_LANG) {
                        try { window.PREFERRED_LANG = String(window.PREFERRED_LANG).toLowerCase(); } catch (e) {}
                    }
                    // Global state
                    var editor = null;
                    var languages = [];
                    var currentLanguage = 'python';
                    if (typeof window !== 'undefined' && window.PREFERRED_LANG) {
                        currentLanguage = window.PREFERRED_LANG;
                    }
                    // Root-relative API base to avoid path issues under subdirectories
                    var API_BASE = '<%= request.getContextPath() %>/OneCompilerFunctionality';
                    var vizWorkspace = null;
                    <% if (ocVizUiEnabled) { %>
                    var VIZ_API_BASE = '<%= request.getContextPath() %>/OneCompilerVizFunctionality';
                    var OC_VIZ_SUPPORTED_LANGS = ["java", "python", "go", "cpp", "rust"];
                    <% } %>
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
                        'perl': 'perl', 'lua': 'lua', 'haskell': 'haskell', 'bash': 'shell',
                        // API language key "test" maps to Bash shell for editor highlighting
                        'test': 'shell'
                    };

                    var fileExtensions = {
                        'python': '.py', 'java': '.java', 'c': '.c', 'cpp': '.cpp',
                        'csharp': '.cs', 'javascript': '.js', 'typescript': '.ts',
                        'go': '.go', 'rust': '.rs', 'php': '.php', 'ruby': '.rb',
                        'swift': '.swift', 'kotlin': '.kt', 'scala': '.scala',
                        'r': '.r', 'lua': '.lua', 'bash': '.sh', 'dart': '.dart',
                        'perl': '.pl', 'haskell': '.hs',
                        'test': '.sh'
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

                        files.forEach(function (file, index) {
                            var tab = document.createElement('div');
                            tab.className = 'ide-tab' + (index === activeFileIndex ? ' active' : '');
                            tab.onclick = function (e) {
                                if (!e.target.classList.contains('tab-close')) {
                                    switchFile(index);
                                }
                            };
                            tab.ondblclick = function (e) {
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
                                close.onclick = function (e) {
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
                        addBtn.onclick = function () { addFile(); };
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
                        while (files.some(function (f) { return f.name === filename; })) {
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

                        input.onblur = function () {
                            finishRenameFile(index, input.value);
                        };

                        input.onkeydown = function (e) {
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
                            var isDuplicate = files.some(function (f, i) {
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
                        return files.map(function (f) {
                            return { name: f.name, content: f.content };
                        });
                    }

                    function syncEditorToFiles() {
                        if (editor && files[activeFileIndex]) {
                            files[activeFileIndex].content = editor.getValue();
                        }
                    }

                    function getOutputSnapshot() {
                        var outputEl = document.getElementById('outputContent');
                        var text = outputEl ? (outputEl.textContent || '') : '';
                        var isError = outputEl && (
                            outputEl.classList.contains('stderr')
                            || text.indexOf('Error') !== -1
                            || text.indexOf('error') !== -1
                            || text.indexOf('Traceback') !== -1
                            || text.indexOf('Exception') !== -1
                        );
                        return { text: text, isError: !!isError };
                    }

                    window.ocShell = {
                        syncEditor: syncEditorToFiles,
                        getSnapshot: function () {
                            syncEditorToFiles();
                            var out = getOutputSnapshot();
                            var selection = '';
                            if (editor) {
                                selection = editor.getModel().getValueInRange(editor.getSelection()).trim();
                            }
                            return {
                                language: currentLanguage,
                                languageVersion: currentVersion || '',
                                code: editor ? editor.getValue() : '',
                                selection: selection,
                                stdin: document.getElementById('stdinInput') ? document.getElementById('stdinInput').value : '',
                                compilerArgs: document.getElementById('compilerArgs') ? document.getElementById('compilerArgs').value : '',
                                output: out.text,
                                outputIsError: out.isError,
                                files: files.map(function (f) { return { name: f.name, content: f.content }; }),
                                activeFile: files[activeFileIndex] ? files[activeFileIndex].name : '',
                            };
                        },
                        applyCode: function (content) {
                            if (!editor) return { applied: false, error: 'Editor not ready' };
                            var code = String(content || '');
                            editor.setValue(code);
                            syncEditorToFiles();
                            return { applied: true, file: files[activeFileIndex] ? files[activeFileIndex].name : 'main' };
                        },
                    };

                    function openAIFix() {
                        if (!window.ocCompilerAssistant) return;
                        var lang = currentLanguage || 'code';
                        window.ocCompilerAssistant.open(
                            'Fix the errors from my last Run output. Return the complete corrected ' + lang + ' source in one ```' + lang + ' fenced block.',
                            true
                        );
                    }

                    function openAIExplain() {
                        if (!window.ocCompilerAssistant) return;
                        var selection = '';
                        if (editor) {
                            selection = editor.getModel().getValueInRange(editor.getSelection()).trim();
                        }
                        var prompt = selection
                            ? 'Explain what this selected code does:\n\n```' + (currentLanguage || '') + '\n' + selection + '\n```\n\nNo code changes.'
                            : 'Explain what my current code does. If there are errors in the output pane, explain those too. No code changes unless I ask.';
                        window.ocCompilerAssistant.open(prompt, true);
                    }

                    function hookExecuteForAIFix() {
                        var observer = new MutationObserver(function () {
                            var outputEl = document.getElementById('outputContent');
                            var aiFixBtn = document.getElementById('aiFixBtn');
                            if (outputEl && aiFixBtn) {
                                var snap = getOutputSnapshot();
                                aiFixBtn.style.display = snap.isError ? '' : 'none';
                            }
                        });
                        var outputEl = document.getElementById('outputContent');
                        if (outputEl) {
                            observer.observe(outputEl, { childList: true, characterData: true, subtree: true, attributes: true, attributeFilter: ['class'] });
                        }
                    }
                    hookExecuteForAIFix();

                    // Initialize Monaco
                    require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs' } });

                    require(['vs/editor/editor.main'], function () {
                        var initMonacoLang = monacoLanguageMap[currentLanguage] || 'plaintext';
                        var initialSamples = {
                            python: "# Write your Python code here\nprint('Hello, World!')\n",
                            javascript: "// Node.js JavaScript example\nconsole.log('Hello, World!');\n",
                            typescript: "// TypeScript example\nconsole.log('ok-ts');\n",
                            ruby: "# Ruby example\nputs 'Hello, World!'\n",
                            perl: "# Perl example\nuse strict;\nuse warnings;\n\nprint \"Hello, World!\\n\";\n",
                            php: "<?php\\n// PHP example\\necho 'Hello, World!';\\n",
                            go: "package main\n\nimport \"fmt\"\n\nfunc main() {\n    fmt.Println(\"Hello, World!\")\n}\n",
                            java: "public class Main {\n  public static void main(String[] args) {\n    System.out.println(\"Hello, World!\");\n  }\n}\n",
                            cpp: "#include <iostream>\nusing namespace std;\n\nint main() {\n    cout << \"Hello, World!\\n\";\n    return 0;\n}\n",
                            c: "#include <stdio.h>\n\nint main() {\n    printf(\"Hello, World!\\n\");\n    return 0;\n}\n",
                            csharp: "using System;\nclass Program {\n  static void Main() {\n    Console.WriteLine(\"Hello, World!\");\n  }\n}\n",
                            rust: "fn main() {\n    println!(\"Hello, World!\");\n}\n",
                            swift: "print(\"Hello, World!\")\n",
                            scala: "object Main extends App {\n  println(\"Hello, World!\")\n}\n",
                            dart: "void main() {\n  print('Hello, World!');\n}\n",
                            kotlin: "fun main() {\n  println(\"Hello, World!\")\n}\n",
                            r: "print('Hello, World!')\n",
                            lua: "print('Hello, World!')\n",
                            bash: "#!/usr/bin/env bash\necho \"Hello, World!\"\n",
                            test: "#!/usr/bin/env bash\necho \"Hello, World!\"\n"
                        };
                        var initValue = initialSamples[currentLanguage] || '// Write your ' + (currentLanguage || 'code') + ' code here\n';
                        editor = monaco.editor.create(document.getElementById('codeEditor'), {
                            value: initValue,
                            language: initMonacoLang,
                            theme: (document.documentElement.getAttribute('data-theme') === 'light' ? 'vs' : 'vs-dark'),
                            fontSize: 14,
                            minimap: { enabled: false },
                            automaticLayout: true,
                            scrollBeyondLastLine: false,
                            wordWrap: 'on',
                            lineNumbers: 'on',
                            tabSize: 4,
                            padding: { top: 8 }
                        });

                        // Keep the editor (and thus the visualizer, which reads
                        // the same --oc-* theme vars) in sync with the nav theme.
                        (function () {
                            function applyEditorTheme() {
                                var light = document.documentElement.getAttribute('data-theme') === 'light';
                                monaco.editor.setTheme(light ? 'vs' : 'vs-dark');
                            }
                            applyEditorTheme();
                            new MutationObserver(applyEditorTheme).observe(document.documentElement, {
                                attributes: true, attributeFilter: ['data-theme']
                            });
                        })();

                        // Initialize files
                        initFiles(currentLanguage);
                        <% if (ocVizUiEnabled) { %>initVizWorkspace();<% } %>
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

                        handle.addEventListener('mousedown', function (e) {
                            isResizing = true;
                            document.body.style.cursor = 'ns-resize';
                            document.body.style.userSelect = 'none';
                        });

                        document.addEventListener('mousemove', function (e) {
                            if (!isResizing) return;
                            var containerRect = document.querySelector('.ide-main').getBoundingClientRect();
                            var newHeight = containerRect.bottom - e.clientY;
                            if (newHeight >= 100 && newHeight <= 400) {
                                panel.style.height = newHeight + 'px';
                                originalPanelHeight = newHeight;
                                // Dragging means the panel is no longer collapsed; keep state honest
                                // so closing the viz pane won't override the user's manual size.
                                panelMinimized = false;
                                var icon = document.getElementById('panelToggleIcon');
                                if (icon) icon.className = 'fas fa-chevron-down';
                            }
                        });

                        document.addEventListener('mouseup', function () {
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
                        var pane = document.getElementById(panel + 'Pane');
                        if (!pane) return;

                        document.querySelectorAll('.ide-panel-tab').forEach(function (tab) {
                            tab.classList.remove('active');
                            if (tab.dataset.panel === panel) tab.classList.add('active');
                        });

                        document.querySelectorAll('.ide-panel-pane').forEach(function (p) {
                            p.classList.remove('active');
                        });

                        pane.classList.add('active');
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

                        fetch(API_BASE + '?action=languages')
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                languages = data;
                                saveToCache(CACHE_KEY_LANGUAGES, data);
                                populateLanguageSelect();
                                updateVersionSelect(currentLanguage);
                                loadAllTemplates();
                                if (!loadedFromURL) loadTemplate();
                            })
                            .catch(function () {
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

                        fetch(API_BASE + '?action=templates')
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                templatesCache = data;
                                saveToCache(CACHE_KEY_TEMPLATES, data);
                            });
                    }

                    function saveToCache(key, data) {
                        try {
                            localStorage.setItem(key, JSON.stringify({ timestamp: Date.now(), data: data }));
                        } catch (e) { }
                    }

                    function getFromCache(key) {
                        try {
                            var cached = localStorage.getItem(key);
                            if (cached) {
                                var obj = JSON.parse(cached);
                                if (Date.now() - obj.timestamp < CACHE_EXPIRY_MS) return obj.data;
                                localStorage.removeItem(key);
                            }
                        } catch (e) { }
                        return null;
                    }

                    function populateLanguageSelect() {
                        var select = document.getElementById('languageSelect');
                        select.innerHTML = '';
                        languages.forEach(function (lang) {
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

                        var lang = languages.find(function (l) { return l.name === langName; });
                        if (lang && lang.versions) {
                            lang.versions.forEach(function (v) {
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

                        if (vizWorkspace) {
                            vizWorkspace.updateLanguage(lang);
                        }
                    }

                    <% if (ocVizUiEnabled) { %>
                    function getVizExecutePayload() {
                        if (editor && files[activeFileIndex]) {
                            files[activeFileIndex].content = editor.getValue();
                        }
                        var apiFiles = getFilesForApi();
                        return {
                            language: currentLanguage,
                            version: currentVersion || undefined,
                            files: apiFiles.length > 1 ? apiFiles : undefined,
                            code: apiFiles.length <= 1 ? apiFiles[0].content : undefined
                        };
                    }

                    function initVizWorkspace() {
                        if (!window.OcViz || !window.OcViz.createWorkspace) return;
                        vizWorkspace = window.OcViz.createWorkspace({
                            apiBase: VIZ_API_BASE,
                            editor: editor,
                            initialLanguage: currentLanguage,
                            supportedLanguages: OC_VIZ_SUPPORTED_LANGS,
                            getExecutePayload: getVizExecutePayload,
                            setEditorCode: function (code) {
                                if (!editor) return;
                                editor.setValue(code);
                                if (files[activeFileIndex]) files[activeFileIndex].content = code;
                            },
                            onPaneToggle: function (open) {
                                // Collapse the output panel when viz opens so the editor+viz
                                // get full height; restore it on close. The resize handle still works.
                                var panel = document.getElementById('bottomPanel');
                                var icon = document.getElementById('panelToggleIcon');
                                if (!panel) return;
                                if (open && !panelMinimized) {
                                    panel.style.height = '35px';
                                    if (icon) icon.className = 'fas fa-chevron-up';
                                    panelMinimized = true;
                                } else if (!open && panelMinimized) {
                                    panel.style.height = (originalPanelHeight || 200) + 'px';
                                    if (icon) icon.className = 'fas fa-chevron-down';
                                    panelMinimized = false;
                                }
                            }
                        });
                        vizWorkspace.init();
                    }

                    function executeVisualize() {
                        if (vizWorkspace) {
                            vizWorkspace.runVisualize();
                        }
                    }
                    <% } %>

                    function loadTemplate() {
                        var template = '';
                        if (templatesCache && templatesCache[currentLanguage]) {
                            template = templatesCache[currentLanguage];
                            editor.setValue(template);
                            files[activeFileIndex].content = template;
                            renderFileTabs();
                            return;
                        }

                        fetch(API_BASE + '?action=template&lang=' + currentLanguage)
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
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
                        fetch(API_BASE + '?action=format', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ language: currentLanguage, code: code })
                        })
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                if (data.formattedCode) editor.setValue(data.formattedCode);
                                else editor.getAction('editor.action.formatDocument').run();
                            })
                            .catch(function () {
                                editor.getAction('editor.action.formatDocument').run();
                            });
                    }

                    function executeCode() {
                        if (isRunning) return;

                        var stdin = document.getElementById('stdinInput').value;
                        var args = document.getElementById('compilerArgs').value;
                        var compilerArgs = args ? args.split(',').map(function (s) { return s.trim(); }).filter(Boolean) : [];

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

                        fetch(API_BASE + '?action=execute', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(requestBody)
                        })
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
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
                            .catch(function (err) {
                                document.getElementById('outputContent').textContent = 'Error: ' + err.message;
                                document.getElementById('outputContent').className = 'output-content stderr';
                                document.getElementById('statusExec').innerHTML = '<i class="fas fa-times-circle"></i> Failed';
                            })
                            .finally(function () {
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
                        var compilerArgs = args ? args.split(',').map(function (s) { return s.trim(); }).filter(Boolean) : [];

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

                        fetch(API_BASE + '?action=snippet_create', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(requestBody)
                        })
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                if (data.id) {
                                    var shareUrl = window.location.origin + window.location.pathname + '?s=' + data.id;
                                    showShareLinkReady(shareUrl);
                                } else {
                                    // Fallback to URL encoding
                                    var fallbackUrl = shareCodeFallback();
                                    showShareLinkReady(fallbackUrl);
                                }
                            })
                            .catch(function () {
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

                        navigator.clipboard.writeText(input.value).then(function () {
                            btn.classList.add('copied');
                            btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                            setTimeout(function () {
                                btn.classList.remove('copied');
                                btn.innerHTML = '<i class="fas fa-copy"></i> Copy';
                            }, 2000);
                        }).catch(function () {
                            // Fallback: select and copy
                            input.select();
                            document.execCommand('copy');
                            btn.classList.add('copied');
                            btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                            setTimeout(function () {
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

                        fetch(API_BASE + '?action=snippet_create', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(requestBody)
                        })
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
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
                            .catch(function () {
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
                        navigator.clipboard.writeText(embedCode).then(function () {
                            var btn = document.querySelector('.embed-copy-btn');
                            btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                            setTimeout(function () {
                                btn.innerHTML = '<i class="fas fa-copy"></i> Copy';
                            }, 2000);
                        });
                    }

                    // Close modals on Escape
                    document.addEventListener('keydown', function (e) {
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
                                waitForEditor(function () {
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
                                    waitForEditor(function () {
                                        document.getElementById('languageSelect').value = currentLanguage;
                                        onLanguageChange();
                                        editor.setValue(code);
                                    });
                                }
                            } catch (e) { }
                        }
                    }

                    // Load snippet from API by ID
                    function loadSnippet(snippetId) {
                        document.getElementById('statusExec').innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';

                        fetch(API_BASE + '?action=snippet_get&id=' + encodeURIComponent(snippetId))
                            .then(function (r) { return r.json(); })
                            .then(function (data) {
                                if (data.error) {
                                    document.getElementById('statusExec').innerHTML = '<i class="fas fa-times-circle"></i> Snippet not found';
                                    return;
                                }

                                waitForEditor(function () {
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
                                        files = data.files.map(function (f) {
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
                                    setTimeout(function () {
                                        document.getElementById('statusExec').innerHTML = '<i class="fas fa-check-circle"></i> Ready';
                                    }, 1500);
                                });
                            })
                            .catch(function (err) {
                                document.getElementById('statusExec').innerHTML = '<i class="fas fa-times-circle"></i> Load failed';
                            });
                    }

                    // Helper to wait for editor initialization
                    function waitForEditor(callback) {
                        var check = setInterval(function () {
                            if (editor) {
                                clearInterval(check);
                                callback();
                            }
                        }, 100);
                    }

                    // Keyboard shortcuts
                    document.addEventListener('keydown', function (e) {
                        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                            e.preventDefault();
                            executeCode();
                        }
                        <% if (ocVizUiEnabled) { %>
                        if ((e.ctrlKey || e.metaKey) && e.shiftKey && (e.key === 'V' || e.key === 'v')) {
                            var vizBtn = document.getElementById('vizBtn');
                            if (vizBtn && vizBtn.style.display !== 'none') {
                                e.preventDefault();
                                executeVisualize();
                            }
                        }
                        <% } %>
                    });

                    loadFromURL();

                </script>

    <script type="module">
<%@ include file="/modern/components/ai-assistant-boot.inc.jsp" %>
import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';

window.ocCompilerAssistant = wireLazyAssistant({
  moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/onecompiler-ai.js',
  exportName: 'createOneCompilerAssistant',
  buttonId: 'btnOneCompilerAI',
  boot: aiAssistantBoot,
});
    </script>

    <!-- Sticky Footer Ad -->
    <%@ include file="/modern/ads/ad-sticky-footer.jsp" %>

    <!-- Navigation Scripts -->
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>"></script>

</body>
</html>

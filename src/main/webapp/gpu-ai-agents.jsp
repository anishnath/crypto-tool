<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    // /gpu/ai-agents: GridPup's AI agents (gridpup.com/agents/<slug>). They mirror get-deploying core/market/agents.
    // Links to gridpup.com here are plain (no utm tags, no nofollow): they point at each page's canonical address.
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String hubPage = "ai-agents";
    String GP = "https://gridpup.com";
    // {slug, name, what you give and get, what it does (three points), price line}
    String[][] agents = {
        {"job-search", "AI Job Search Agent",
            "Paste a job and it reads it against your CV: what the role really is, where you match and where you don&rsquo;t, the pay against your target, and a 1 to 5 score.",
            "A fit report for any job before you apply|A tailored resume, cover letter, form answers and interview prep|A tracker for your applications, with reminders",
            "Pay per run, from about 1&cent;. It never applies or sends anything for you."},
        {"marketing", "AI Marketing Agent",
            "Paste your website and get a conversion and SEO audit of your homepage, and see who shows up when your buyers search.",
            "Reads up to 5 of your pages and drafts your product profile|Finds and profiles your competitors|Writes page copy, emails and launch plans for your product",
            "Pay per run, from under 1&cent;. It never publishes or sends anything."},
        {"video", "AI Short Video Maker",
            "Give a topic or your own script and get a short video in 9:16, 16:9 or 1:1.",
            "Narration, with a picture for each scene|Subtitles timed to every word, and music made for the video|Change any scene, then download the MP4",
            "Pay per video, no subscription. It never posts for you."},
        {"slides", "AI Presentation Maker",
            "Describe your presentation or attach a document and get a designed slide deck.",
            "An outline you can change before the slides are made|Layouts, pictures, charts and speaker notes|Edit any slide, present, or download PowerPoint or PDF",
            "Pay per deck, a few cents for 10 slides. It keeps to your facts."},
        {"website", "AI Website Builder",
            "Paste a screenshot or a mockup, or describe the page, and get real code: HTML with Tailwind, for desktop and phone.",
            "The page is written as you watch, then checked in a real browser|Change it by asking, or by typing on the page|Download the code, or publish it in one click with HTTPS",
            "Pay per page, from about 1&cent;. It will not copy a brand or publish for you."},
    };
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="language" content="en">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root,:root[data-theme="light"]{--primary:#6366f1;--primary-dark:#4f46e5;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <jsp:include page="/modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="AI Agents: Job Search, Marketing, Video, Slides and Website Builder" />
        <jsp:param name="toolDescription" value="Five AI agents that finish a job for you: score jobs against your resume, audit your website, make a short video, a slide deck or a working web page. Pay per run." />
        <jsp:param name="toolCategory" value="GPU Prices" />
        <jsp:param name="breadcrumbCategoryUrl" value="gpu" />
        <jsp:param name="toolUrl" value="gpu/ai-agents" />
        <jsp:param name="toolKeywords" value="ai agents, ai job search agent, resume job match score, tailored resume ai, ai marketing agent, website audit ai, competitor analysis ai, ai short video maker, topic to video, ai presentation maker, ai slide deck generator, text to powerpoint, ai website builder, screenshot to code, screenshot to html" />
        <jsp:param name="toolImage" value="gpu-prices.png" />
        <jsp:param name="toolFeatures" value="Score a job against your resume before you apply,Tailored resume cover letter and interview prep,Website conversion and SEO audit,Competitor profiles and marketing copy,Short videos with voice subtitles and music,Slide decks with PowerPoint and PDF download,Web pages from a screenshot or a description,Pay per run from one prepaid balance" />
        <jsp:param name="faq1q" value="What is an AI agent?" />
        <jsp:param name="faq1a" value="A tool that carries a whole job through for you instead of answering one prompt. You give it a goal, such as a job posting, a website, a topic or a screenshot. It does the steps in order, shows you the result and lets you change any part." />
        <jsp:param name="faq2q" value="Which AI agents does GridPup have?" />
        <jsp:param name="faq2a" value="Five: a Job Search Agent that scores jobs against your resume and helps you apply, a Marketing Agent that audits your website and profiles your competitors, a Short Video Maker, a Presentation Maker and a Website Builder." />
        <jsp:param name="faq3q" value="How much do the agents cost?" />
        <jsp:param name="faq3a" value="You pay for each run from a prepaid GridPup balance, and the price is shown before you start. Most runs cost from under a cent to a few cents. There is no subscription." />
        <jsp:param name="faq4q" value="Do the agents send, post or publish anything for me?" />
        <jsp:param name="faq4a" value="No. The Job Search Agent never applies for you, the Marketing Agent never publishes or sends, the video and slides agents never post, and the Website Builder puts a page online only when you press Publish." />
    </jsp:include>
    <%@ include file="/gpu/gpu-hub-head.inc.jsp" %>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">AI agents: job search, marketing, video, slides and websites</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/gpu">GPU Prices</a> /
                    <span>AI Agents</span>
                </nav>
            </div>
        </div>
    </header>
    <%@ include file="/gpu/gpu-hub-nav.inc.jsp" %>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-ad" style="width:100%;">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <main class="gh-wrap">
        <p class="gh-lead">Five AI agents on <a href="<%= GP %>/agents" target="_blank" rel="noopener">GridPup</a>. <strong>Each one takes a job from start to finish: you give it a goal, it does the steps, and you change anything before you use the result.</strong> You pay per run, and the price is shown before you start.</p>
        <div class="gh-cta">
            <a class="gh-btn" href="<%= GP %>/agents" target="_blank" rel="noopener">See all AI agents</a>
            <span class="gh-note">No subscription. Pay per run from one balance.</span>
        </div>

        <% for (String[] a : agents) { %>
        <h2 class="gh-h2"><a href="<%= GP %>/agents/<%= a[0] %>" target="_blank" rel="noopener" style="color:inherit"><%= a[1] %></a></h2>
        <p class="gh-sub"><%= a[2] %></p>
        <div class="gh-grid">
            <% for (String point : a[3].split("\\|")) { %>
            <div class="gh-card"><p><%= point %></p></div>
            <% } %>
        </div>
        <p class="gh-sub"><%= a[4] %> <a href="<%= GP %>/agents/<%= a[0] %>" target="_blank" rel="noopener">Open the <%= a[1] %></a></p>
        <% } %>

        <h2 class="gh-h2">More on GridPup</h2>
        <div class="gh-grid">
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/ai-playground">AI Playground and AI tools</a></h3><p>Ask up to four LLMs the same question side by side, and make images, video and audio.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/llm-services">Deploy an open LLM as an API</a></h3><p>Host Llama, Qwen, gpt-oss or Whisper on the cheapest GPU that fits, behind your own https API.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu">Compare GPU prices</a></h3><p>Live cloud GPU prices across providers, from RTX cards to H100.</p></div>
        </div>

        <h2 class="gh-h2">Frequently asked questions</h2>
        <div class="gh-faq">
        <% for (int i = 1; i <= 8; i++) {
               Object q = request.getAttribute("faq" + i + "q"), a = request.getAttribute("faq" + i + "a");
               if (q == null || a == null) continue; %>
            <details><summary><%= esc(q.toString()) %></summary><p><%= esc(a.toString()) %></p></details>
        <% } %>
        </div>
    </main>

    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <jsp:include page="/modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="gpu/ai-agents"/>
        <jsp:param name="category" value="DevOps & Infrastructure"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="modern/components/support-section.jsp" %>
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>

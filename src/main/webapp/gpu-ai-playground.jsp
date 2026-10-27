<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    // /gpu/ai-playground: GridPup's AI Playground (gridpup.com/playground) and its AI tools (gridpup.com/tools/<slug>).
    // The tools mirror get-deploying apps/web/lib/tasks.ts (TASKS).
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String hubPage = "ai-playground";
    String campaign = "gpu-ai-playground";
    // Group, then {slug, name, what it does}.
    String[][][] tools = {
        {{"Text and chat"},
            {"compare-ai-models", "Compare AI models", "Ask one question and get answers from up to four models side by side, with what each cost and how fast it came."},
            {"ai-translator", "AI translator", "Translate between 34 common languages, or from English into 22 Indian languages."},
            {"extract-data-from-text", "Extract data from text", "Pull names, dates and amounts out of an email, an invoice or a note, with how sure the model is."},
            {"ai-text-classifier", "AI text classifier", "Ask your own questions about a message or review, such as &ldquo;is it a complaint?&rdquo;, and get each answer with its probability."}},
        {{"Images"},
            {"ai-image-generator", "AI image generator", "Make images from text with FLUX, GPT-Image, Seedream and more; compare up to three models."},
            {"ai-photo-editor", "AI photo editor", "Change a photo by describing it: &ldquo;make it night&rdquo; or &ldquo;remove the people in the background&rdquo;."},
            {"remove-background", "Remove background", "Cut the subject out onto a transparent PNG for listings, profiles and slides."},
            {"image-upscaler", "Image upscaler", "Make a small or soft photo bigger and sharper."},
            {"svg-generator", "SVG generator", "Describe an icon or illustration and get an SVG to edit in Figma, Illustrator or Inkscape."}},
        {{"Video"},
            {"ai-video-generator", "AI video generator", "Text to video with Seedance, Runway and more: a short clip in one to three minutes."},
            {"image-to-video", "Image to video", "Bring a photo to life: describe what happens next and get a clip that starts from it."},
            {"video-upscaler", "Video upscaler", "Get a short clip back at twice the size with sharper detail."},
            {"video-background-remover", "Video background remover", "Cut a person or object out of a clip, ready to place over another background."}},
        {{"Audio and speech"},
            {"audio-to-text", "Audio to text", "Transcribe recordings, meetings or videos, with timings, as text or subtitles."},
            {"subtitle-generator", "Subtitle generator", "Make subtitles for a video, fix any line, and download SRT or VTT."},
            {"text-to-speech", "Text to speech", "Pick a voice, listen, compare models and download the audio."}},
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
        <jsp:param name="toolName" value="AI Playground: Compare LLMs, Make Images and Video" />
        <jsp:param name="toolDescription" value="Chat with up to four LLMs side by side (GPT, Claude, Gemini, Grok), make images and videos, transcribe, translate and more. 100+ models, one balance." />
        <jsp:param name="toolCategory" value="GPU Prices" />
        <jsp:param name="breadcrumbCategoryUrl" value="gpu" />
        <jsp:param name="toolUrl" value="gpu/ai-playground" />
        <jsp:param name="toolKeywords" value="llm playground, ai playground, compare ai models, compare llms side by side, chatgpt vs claude vs gemini, ai image generator, ai video generator, text to video, image to video, remove background, audio to text, subtitle generator, text to speech, ai translator, multi model ai chat" />
        <jsp:param name="toolImage" value="gpu-prices.png" />
        <jsp:param name="toolFeatures" value="Chat with up to four AI models side by side,100+ chat image video and voice models,Make and edit images,Make videos from text or a photo,Speech to text and text to speech,Translate classify and extract data from text,Price of each answer shown,One prepaid balance for every model" />
        <jsp:param name="faq1q" value="What is an LLM playground?" />
        <jsp:param name="faq1a" value="A page where you try large language models without writing code: you type a prompt, pick models and compare their answers. GridPup's AI Playground lets you ask up to four models the same question side by side and shows what each answer cost and how fast it came." />
        <jsp:param name="faq2q" value="Which AI models can I use?" />
        <jsp:param name="faq2a" value="Over 100 models: chat models from OpenAI (GPT), Anthropic (Claude), Google (Gemini) and xAI (Grok), image models such as FLUX, GPT-Image and Seedream, video models such as Seedance and Runway, and speech, translation and text-to-speech models." />
        <jsp:param name="faq3q" value="Do I need a subscription to each AI company?" />
        <jsp:param name="faq3a" value="No. You use every model from one prepaid GridPup balance and pay only for what you run. The price of each answer, image or video is shown before or as you make it." />
        <jsp:param name="faq4q" value="Do I need an account?" />
        <jsp:param name="faq4a" value="You can open the Playground and every tool without one. You sign in when you send your first request, and add funds when your balance runs out." />
    </jsp:include>
    <%@ include file="/gpu/gpu-hub-head.inc.jsp" %>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">AI Playground: compare LLMs and use 16 AI tools</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/gpu">GPU Prices</a> /
                    <span>AI Playground</span>
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
        <p class="gh-lead">Try 100+ AI models in one place. <strong>Ask up to four LLMs the same question side by side, then make images, videos, voice-overs, subtitles and translations from the same balance.</strong> Every answer shows what it cost.</p>
        <div class="gh-cta">
            <a class="gh-btn" href="<%= gp("/playground", campaign) %>" target="_blank" rel="noopener">Open the AI Playground</a>
            <a class="gh-btn2" href="<%= gp("/tools", campaign) %>" target="_blank" rel="noopener">See all AI tools</a>
            <span class="gh-note">No subscription. Pay per use from one balance.</span>
        </div>

        <% for (String[][] group : tools) { %>
        <h2 class="gh-h2"><%= group[0][0] %></h2>
        <div class="gh-grid">
            <% for (int i = 1; i < group.length; i++) { String[] t = group[i]; %>
            <div class="gh-card">
                <h3><a href="<%= gp("/tools/" + t[0], campaign) %>" target="_blank" rel="noopener"><%= t[1] %></a></h3>
                <p><%= t[2] %></p>
            </div>
            <% } %>
        </div>
        <% } %>

        <h2 class="gh-h2">Run your own model instead</h2>
        <div class="gh-grid">
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/llm-services">Deploy an open LLM as an API</a></h3><p>Host Llama, Qwen, gpt-oss or Whisper on the cheapest GPU that fits, behind your own https API.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/models">Check what a model needs</a></h3><p>GPU memory and the cheapest machine for popular open models, live.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/model-benchmark">Benchmark it on real GPUs</a></h3><p>Tokens per second and users per GPU before you deploy.</p></div>
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
        <jsp:param name="currentToolUrl" value="gpu/ai-playground"/>
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

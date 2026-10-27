<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="z.y.x.Network.GpuPricesFunctionality" %>
<%
    // /gpu/models: how much GPU memory popular open models need and the cheapest machine for each,
    // live from GridPup's model catalog (gridpup.com/models).
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String hubPage = "models";
    String campaign = "gpu-models";
    // Section id, heading, Hugging Face task, rows, intro.
    String[][] sections = {
        {"chat", "Chat and text LLMs", "text-generation", "20", "Llama, Qwen, gpt-oss, Mistral, DeepSeek and more, served with vLLM."},
        {"vision", "Vision-language models", "image-text-to-text", "8", "Models that read images and text, such as Gemma and Qwen-VL."},
        {"speech", "Speech to text", "automatic-speech-recognition", "6", "Whisper and other transcription models."},
        {"image", "Image generation", "text-to-image", "8", "Stable Diffusion, SDXL and FLUX."},
        {"embed", "Embeddings", "feature-extraction", "6", "Models that turn text into vectors for search and RAG."},
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
        <jsp:param name="toolName" value="LLM GPU Requirements: VRAM Needed and Cost to Run" />
        <jsp:param name="toolDescription" value="How much GPU memory (VRAM) Llama, Qwen, gpt-oss, DeepSeek, Whisper, FLUX and other open models need, and the cheapest cloud GPU that runs each right now." />
        <jsp:param name="toolCategory" value="GPU Prices" />
        <jsp:param name="breadcrumbCategoryUrl" value="gpu" />
        <jsp:param name="toolUrl" value="gpu/models" />
        <jsp:param name="toolKeywords" value="llm gpu requirements, how much vram for llm, vram calculator llm, gpu memory for llama, qwen gpu requirements, gpt-oss gpu requirements, deepseek gpu requirements, whisper gpu requirements, flux vram, stable diffusion vram, cheapest gpu to run llm, run llm in the cloud cost" />
        <jsp:param name="toolImage" value="gpu-prices.png" />
        <jsp:param name="toolFeatures" value="GPU memory needed for popular open models,Cheapest cloud machine that runs each model now,Chat vision speech image and embedding models,Live prices from GPU clouds,Deploy any model as an API in one click on GridPup" />
        <jsp:param name="faq1q" value="How much VRAM do I need to run an LLM?" />
        <jsp:param name="faq1a" value="Roughly 2 GB per billion parameters at 16-bit precision for the weights, plus room for the KV cache that holds the conversation. A 7B-8B model needs about 20 GB to serve with vLLM, a 32B model about 75 GB, and 4-bit (AWQ) versions need about half as much. The tables on this page show the figure for each model." />
        <jsp:param name="faq2q" value="What is the cheapest GPU to run an 8B model?" />
        <jsp:param name="faq2a" value="An 8B model at 16-bit precision needs about 20-22 GB, so one 24 GB GPU (RTX 3090, RTX 4090, L4, A5000) or two 12 GB GPUs run it. A 4-bit AWQ version fits in about 10 GB, on a single RTX 3060. The tables show the cheapest machine that fits each model right now." />
        <jsp:param name="faq3q" value="Can I run a model across several GPUs?" />
        <jsp:param name="faq3a" value="Yes. vLLM splits a model across the GPUs of one machine, so a model that needs 75 GB runs on one 80 GB GPU or on four 24 GB GPUs. That is why the cheapest machine for a model is sometimes several small GPUs." />
        <jsp:param name="faq4q" value="Where does this data come from?" />
        <jsp:param name="faq4a" value="From GridPup (gridpup.com), which reads open models from Hugging Face, works out the GPU memory each needs, and matches it with live GPU offers from cloud providers. Open a model on GridPup to see every GPU that fits and deploy it as an API." />
    </jsp:include>
    <%@ include file="/gpu/gpu-hub-head.inc.jsp" %>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Open models: GPU memory needed and cost to run</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/gpu">GPU Prices</a> /
                    <span>Open models</span>
                </nav>
            </div>
        </div>
    </header>
    <%@ include file="/WEB-INF/gpu/gpu-hub-nav.inc.jsp" %>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-ad" style="width:100%;">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <main class="gh-wrap">
        <p class="gh-lead">Before you rent a GPU for a model, check it fits. <strong>Each table shows how much GPU memory a popular open model needs and the cheapest cloud machine that runs it right now.</strong> The most downloaded models from Hugging Face come first.</p>
        <div class="gh-cta">
            <a class="gh-btn" href="<%= gp("/models", campaign) %>" target="_blank" rel="noopener">Search 4,000+ models on GridPup</a>
            <span class="gh-note">Jump to:
            <% for (int i = 0; i < sections.length; i++) { %><a href="#<%= sections[i][0] %>"><%= sections[i][1] %></a><%= i < sections.length - 1 ? " &middot; " : "" %><% } %>
            </span>
        </div>

        <% for (String[] s : sections) { %>
        <h2 class="gh-h2" id="<%= s[0] %>"><%= s[1] %></h2>
        <p class="gh-sub"><%= s[4] %></p>
        <%= modelTable(GpuPricesFunctionality.models(s[2]), null, Integer.parseInt(s[3]), s[1] + ": GPU memory needed and cheapest machine per hour", campaign) %>
        <% } %>
        <p class="gh-source">GPU memory to serve each model at its published precision with room for the KV cache. Machines and prices from <a href="<%= gp("/models", campaign) %>" target="_blank" rel="noopener">GridPup</a>, updated through the day.</p>

        <h2 class="gh-h2">Next steps</h2>
        <div class="gh-grid">
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/llm-services">Deploy a model as an API</a></h3><p>Serve any model here behind an https API with keys, on the cheapest GPU that fits.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/model-benchmark">Benchmark it on real GPUs</a></h3><p>Tokens per second and users per GPU, so you know which GPU to rent before you deploy.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/training">Fine-tune it</a></h3><p>Train or fine-tune an open model on a cloud GPU from your browser.</p></div>
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
        <jsp:param name="currentToolUrl" value="gpu/models"/>
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

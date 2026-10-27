<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="com.google.gson.JsonArray, z.y.x.Network.GpuPricesFunctionality" %>
<%
    // /gpu/llm-services: deploy an open model as an API (gridpup.com/inference) and test an LLM endpoint's
    // latency (gridpup.com/endpoint-latency). Live machine prices from GridPup's model catalog.
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String hubPage = "llm-services";
    String campaign = "gpu-llm-services";
    JsonArray chat = GpuPricesFunctionality.models("text-generation");
    JsonArray speech = GpuPricesFunctionality.models("automatic-speech-recognition");
    String[] chatPicks = {"meta-llama/Llama-3.1-8B-Instruct", "Qwen/Qwen3-8B", "openai/gpt-oss-20b", "Qwen/Qwen3-14B",
            "Qwen/Qwen3-32B", "openai/gpt-oss-120b", "mistralai/Mistral-7B-Instruct-v0.2", "deepseek-ai/DeepSeek-V3.2"};
    String[] speechPicks = {"openai/whisper-large-v3-turbo", "openai/whisper-large-v3", "distil-whisper/distil-large-v3"};
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
        <jsp:param name="toolName" value="Deploy an LLM as an API and Test LLM Latency" />
        <jsp:param name="toolDescription" value="Host Llama, Qwen, gpt-oss or Whisper as your own https API on the cheapest cloud GPU that fits, and test any LLM endpoint latency from 3 regions." />
        <jsp:param name="toolCategory" value="GPU Prices" />
        <jsp:param name="breadcrumbCategoryUrl" value="gpu" />
        <jsp:param name="toolUrl" value="gpu/llm-services" />
        <jsp:param name="toolKeywords" value="deploy llm as api, host llm api, self-hosted llm api, llm hosting, deploy llama api, vllm hosting, openai compatible api self hosted, llm inference hosting cost, llm latency test, time to first token test, llm endpoint benchmark, tokens per second test, whisper api hosting" />
        <jsp:param name="toolImage" value="gpu-prices.png" />
        <jsp:param name="toolFeatures" value="Deploy open models as an https API with keys,Cheapest GPU that fits the model picked for you,OpenAI-compatible chat API served by vLLM,Billed by the hour,Test any LLM endpoint from US Europe and India,Time to first token and tokens per second under load,HTTP WebSocket and gRPC endpoints" />
        <jsp:param name="faq1q" value="How much does it cost to host an LLM as an API?" />
        <jsp:param name="faq1a" value="You pay for the GPU machine by the hour while the API runs. Small models such as Qwen3-8B or Llama 3.1 8B run on machines that cost well under a dollar an hour; the table on this page shows the cheapest machine for popular models right now. Large models such as DeepSeek V3 need eight data center GPUs." />
        <jsp:param name="faq2q" value="Is the API compatible with OpenAI's?" />
        <jsp:param name="faq2a" value="Chat models are served with vLLM, which offers OpenAI-style /v1/chat/completions, so tools and SDKs written for OpenAI work by changing the base URL and key. Speech models such as Whisper answer OpenAI-style /audio/transcriptions requests." />
        <jsp:param name="faq3q" value="How do I measure my LLM API's latency?" />
        <jsp:param name="faq3a" value="GridPup's endpoint latency test sends real requests to your endpoint from AWS regions in the US, Europe and India and reports DNS, connection and TLS time, time to first token, tokens per second, and how these change with 1, 4, 16 and 32 users at once." />
        <jsp:param name="faq4q" value="Which endpoints can the latency test check?" />
        <jsp:param name="faq4a" value="Your own vLLM, TGI, Ollama or Triton server (a raw IP and port are fine) or an API such as OpenAI, Anthropic, Gemini, Groq, Together or Deepgram, over HTTP(S), WebSocket or gRPC. To test your own server you show it is yours with a token file or DNS record." />
        <jsp:param name="faq5q" value="Which models can I deploy?" />
        <jsp:param name="faq5a" value="Thousands of open models from Hugging Face: chat models (Llama, Qwen, Gemma, Mistral, gpt-oss, DeepSeek), vision models, speech to text (Whisper), image generation (Stable Diffusion, FLUX) and embeddings. Licence-gated models such as Llama need approval on Hugging Face first." />
    </jsp:include>
    <%@ include file="/gpu/gpu-hub-head.inc.jsp" %>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Deploy an LLM as an API and test its latency</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/gpu">GPU Prices</a> /
                    <span>LLM APIs and hosting</span>
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
        <p class="gh-lead">Run an open model as your own API, then check how fast it answers for your users. <strong>GridPup deploys the model on the cheapest cloud GPU that fits it, behind an https address with API keys, and bills by the hour.</strong> Its latency test times any LLM endpoint, yours or a provider's, from three regions.</p>
        <div class="gh-cta">
            <a class="gh-btn" href="<%= gp("/inference", campaign) %>" target="_blank" rel="noopener">Deploy a model on GridPup</a>
            <a class="gh-btn2" href="<%= gp("/endpoint-latency", campaign) %>" target="_blank" rel="noopener">Test an endpoint's latency</a>
        </div>

        <h2 class="gh-h2">Popular LLMs and the cheapest machine for each</h2>
        <p class="gh-sub">GPU memory each model needs to serve with vLLM, and the cheapest machine that fits it right now. Open a model on GridPup to deploy it or see every GPU that fits.</p>
        <%= modelTable(chat, chatPicks, 0, "Popular LLMs: GPU memory needed and cheapest machine per hour", campaign) %>

        <h2 class="gh-h2">Speech to text</h2>
        <p class="gh-sub">Whisper models answer OpenAI-style <code>/audio/transcriptions</code> requests once deployed.</p>
        <%= modelTable(speech, speechPicks, 0, "Speech to text models: GPU memory needed and cheapest machine per hour", campaign) %>
        <p class="gh-source">Machines and prices from <a href="<%= gp("/models", campaign) %>" target="_blank" rel="noopener">GridPup</a>, updated through the day. More models on <a href="<%=request.getContextPath()%>/gpu/models">open models and their GPU needs</a>.</p>

        <h2 class="gh-h2">How deploying works</h2>
        <ol class="gh-steps">
            <li><strong>Pick a model.</strong> Choose one from Hugging Face or bring your own. GridPup shows the GPU memory it needs and every GPU that fits.</li>
            <li><strong>Pick the machine.</strong> The cheapest GPU that fits is chosen for you, or pick another. You see the price per hour first.</li>
            <li><strong>Get your API.</strong> GridPup starts the machine, loads the model and gives you an https address and API keys.</li>
            <li><strong>Stop when done.</strong> You pay by the hour while it runs; stop it any time.</li>
        </ol>

        <h2 class="gh-h2">Endpoint latency test</h2>
        <p class="gh-sub">Already serving a model, or choosing between providers? The test sends real requests from AWS in US East, Frankfurt and Mumbai and measures what people there see.</p>
        <div class="gh-grid">
            <div class="gh-card"><h3>Reaching it</h3><p>DNS, connecting and TLS from each region: how far your endpoint is from your users.</p></div>
            <div class="gh-card"><h3>First token</h3><p>From the request to the first token of the answer, and the first answer token after a model's thinking.</p></div>
            <div class="gh-card"><h3>Speed and load</h3><p>Tokens per second for each user and in all, with 1, 4, 16 and 32 users at once: where it slows and where rate limits start.</p></div>
            <div class="gh-card"><h3>Voice and speech</h3><p>Time to the first audio for voice APIs; for speech to text, time to the first words and the word error rate.</p></div>
        </div>
        <p class="gh-source">Works with OpenAI, Anthropic, Gemini, Groq, Together, Ollama, vLLM, TGI, Triton and your own JSON, WebSocket or gRPC API. <a href="<%= gp("/endpoint-latency", campaign) %>" target="_blank" rel="noopener">Start a test on GridPup</a>.</p>

        <h2 class="gh-h2">Before you deploy</h2>
        <div class="gh-grid">
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/model-benchmark">Benchmark the model first</a></h3><p>Tokens per second and users per GPU on H100, A100, RTX 5090 and more, so you rent the right GPU.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/training">Fine-tune it</a></h3><p>Train or fine-tune your model on a cloud GPU from the browser, then deploy the result.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu/ai-playground">Try hosted models first</a></h3><p>Ask GPT, Claude, Gemini and Grok the same question side by side in the AI Playground, pay per answer.</p></div>
            <div class="gh-card"><h3><a href="<%=request.getContextPath()%>/gpu">Compare GPU prices</a></h3><p>Live prices per GPU-hour for H100, A100, L40S, RTX 4090 and 70+ other GPUs across clouds.</p></div>
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
        <jsp:param name="currentToolUrl" value="gpu/llm-services"/>
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

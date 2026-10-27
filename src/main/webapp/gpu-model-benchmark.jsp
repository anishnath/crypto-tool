<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    // /gpu/model-benchmark: GridPup's model benchmark (gridpup.com/model-benchmark).
    // The plans and the sample results mirror get-deploying apps/web/app/model-benchmark (plans.ts, servingSample.ts).
    // Benchmarks are sold in runs, so this page shows no GPU prices.
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String hubPage = "model-benchmark";
    String campaign = "gpu-model-benchmark";
    // Qwen/Qwen2.5-7B-Instruct on vLLM, 512 tokens in and 256 out: GPU, tokens/s for one user, first token (ms),
    // users whose first token arrives within 1 s (p95), most tokens/s in all (at 128 users).
    String[][] sample = {
        {"nvidia-h100", "H100 80 GB", "107.9", "43", "32", "5,793"},
        {"nvidia-a100", "A100 80 GB", "96.9", "58", "32", "3,924"},
        {"nvidia-rtx-5090", "RTX 5090 32 GB", "103.7", "53", "8", "3,546"},
        {"nvidia-l40s", "L40S 48 GB", "49.8", "65", "8", "2,247"},
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
        <jsp:param name="toolName" value="LLM Benchmark on Real GPUs: Tokens per Second" />
        <jsp:param name="toolDescription" value="Benchmark your LLM on H100, A100, RTX 5090 and L40S before you deploy: tokens per second, time to first token, users per GPU and answer accuracy." />
        <jsp:param name="toolCategory" value="GPU Prices" />
        <jsp:param name="breadcrumbCategoryUrl" value="gpu" />
        <jsp:param name="toolUrl" value="gpu/model-benchmark" />
        <jsp:param name="toolKeywords" value="llm benchmark, gpu benchmark for llm, tokens per second, llm inference benchmark, vllm benchmark, h100 vs a100 llm, rtx 5090 llm benchmark, time to first token, llm throughput benchmark, which gpu for llm inference, onnx model benchmark, ai model benchmark gpu" />
        <jsp:param name="toolImage" value="gpu-prices.png" />
        <jsp:param name="toolFeatures" value="Chat models from Hugging Face served with vLLM,ONNX models from PyTorch TensorFlow and scikit-learn,Tokens per second for one user and under load,Time to first token,Users per GPU within a 1 second first token,Checks the answers match the original model,L4 RTX 4090 RTX 5090 A100 H100 H200 and B200" />
        <jsp:param name="faq1q" value="How many tokens per second does an H100 give for a 7B model?" />
        <jsp:param name="faq1a" value="In GridPup's test of Qwen2.5-7B-Instruct on vLLM (512 tokens in, 256 out), one H100 gave 108 tokens per second to a single user, served 32 users at once with the first token within a second, and reached about 5,800 tokens per second in all with 128 users." />
        <jsp:param name="faq2q" value="Is an RTX 5090 good for LLM inference?" />
        <jsp:param name="faq2a" value="For one user it is almost as fast as an H100 on a 7B model (104 against 108 tokens per second in the same test). With its 32 GB of memory it serves fewer users at once: 8 users within a 1 second first token against 32 on an H100 or A100." />
        <jsp:param name="faq3q" value="What models can I benchmark?" />
        <jsp:param name="faq3a" value="Chat models from Hugging Face by name, served with vLLM and timed in tokens per second, and ONNX files exported from PyTorch, TensorFlow or scikit-learn: image, text, speech, recommendation and tabular models. Licence-gated models are not supported yet." />
        <jsp:param name="faq4q" value="Which GPUs can I test on?" />
        <jsp:param name="faq4a" value="L4, RTX 4090 and RTX 5090 on every plan; A100, H100, H200 and B200 on Tier 2. B300 and other GPUs are available on Enterprise plans." />
        <jsp:param name="faq5q" value="How much does a benchmark cost?" />
        <jsp:param name="faq5a" value="Plans start at $49 a month for 20 benchmark runs; Tier 2 is $249 a month for 100 runs and every GPU up to H200 and B200. A run is one model tested on one GPU. If a test fails on GridPup's side it does not use your runs." />
    </jsp:include>
    <%@ include file="/gpu/gpu-hub-head.inc.jsp" %>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">LLM and AI model benchmark on real GPUs</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/gpu">GPU Prices</a> /
                    <span>Model benchmark</span>
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
        <p class="gh-lead">Find out which GPU your model needs before you pay for one. <strong>GridPup runs your model on real cloud GPUs and reports whether it works, whether the answers are right, and how fast it is on each GPU.</strong> You need no GPU or cloud account of your own.</p>
        <div class="gh-cta">
            <a class="gh-btn" href="<%= gp("/model-benchmark", campaign) %>" target="_blank" rel="noopener">Benchmark your model on GridPup</a>
            <a class="gh-btn2" href="<%= gp("/model-benchmark#mt-sample", campaign) %>" target="_blank" rel="noopener">See a full sample report</a>
        </div>

        <h2 class="gh-h2">Sample result: Qwen2.5-7B on four GPUs</h2>
        <p class="gh-sub">Qwen/Qwen2.5-7B-Instruct served with vLLM, 512 tokens in and 256 out per request, with 1 to 128 users at once. &ldquo;Users served&rdquo; counts users whose first token arrives within one second for 95% of requests.</p>
        <div class="gh-table-wrap">
            <table class="gh-table">
                <caption class="sr-only">Qwen2.5-7B-Instruct LLM benchmark results by GPU</caption>
                <thead>
                    <tr>
                        <th scope="col">GPU</th>
                        <th scope="col" class="r">Tokens/s, one user</th>
                        <th scope="col" class="r gh-hide-sm">First token, one user</th>
                        <th scope="col" class="r">Users served</th>
                        <th scope="col" class="r gh-hide-sm">Most tokens/s in all</th>
                    </tr>
                </thead>
                <tbody>
                <% for (String[] s : sample) { %>
                    <tr>
                        <td><a href="<%= gp("/gpus/" + s[0], campaign) %>" target="_blank" rel="noopener"><%= s[1] %></a></td>
                        <td class="r num"><strong><%= s[2] %></strong></td>
                        <td class="r num gh-hide-sm"><%= s[3] %> ms</td>
                        <td class="r num"><%= s[4] %></td>
                        <td class="r num gh-hide-sm"><%= s[5] %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <p class="gh-source">Measured by <a href="<%= gp("/model-benchmark", campaign) %>" target="_blank" rel="noopener">GridPup</a> in October 2026, one copy of the model per machine, vLLM default settings.</p>

        <h2 class="gh-h2">What the report tells you</h2>
        <div class="gh-grid">
            <div class="gh-card"><h3>Does it work?</h3><p>Whether your model loads and runs on each GPU, and whether every part of it runs on the GPU rather than falling back to the CPU.</p></div>
            <div class="gh-card"><h3>Are the answers right?</h3><p>Whether the answers on the GPU match your original model, including with faster settings such as half precision.</p></div>
            <div class="gh-card"><h3>How fast is it?</h3><p>Tokens per second for one user and under load, time to the first token, and how many users each GPU serves within your target.</p></div>
            <div class="gh-card"><h3>Which GPU fits?</h3><p>The GPUs you chose side by side, so you pick the one that meets your needs instead of the biggest one.</p></div>
        </div>

        <h2 class="gh-h2">How it works</h2>
        <ol class="gh-steps">
            <li><strong>Give your model.</strong> Enter a Hugging Face chat model by name, or upload an ONNX file. GridPup works out the inputs your model needs; you can add a few real examples.</li>
            <li><strong>Pick GPUs.</strong> L4, RTX 4090 and RTX 5090 on every plan; A100, H100, H200 and B200 on Tier 2.</li>
            <li><strong>GridPup tests it.</strong> It sets up each GPU, serves your model and sends it real requests, from one user to many at once.</li>
            <li><strong>Read the report.</strong> One page per model with the results on every GPU and what to change. Your model is used only for your benchmark.</li>
        </ol>

        <h2 class="gh-h2">Plans</h2>
        <div class="gh-grid">
            <div class="gh-card"><h3>Tier 1: $49 a month</h3><p>20 benchmark runs a month on L4, RTX 4090 and RTX 5090. Up to 2 GPUs per test, one test at a time.</p></div>
            <div class="gh-card"><h3>Tier 2: $249 a month</h3><p>100 runs a month on every GPU up to H200 and B200 (bigger GPUs use more runs). Up to 5 GPUs per test, 3 tests at a time.</p></div>
            <div class="gh-card"><h3>Enterprise</h3><p>B300 and other GPUs, dedicated machines and API access. <a href="<%= gp("/model-benchmark#mt-pricing", campaign) %>" target="_blank" rel="noopener">Talk to GridPup</a>.</p></div>
        </div>
        <p class="gh-source">A run is one model tested on one GPU. Runs reset every month; cancel any time.</p>

        <h2 class="gh-h2">Already serving your model?</h2>
        <p class="gh-sub">Test the endpoint you run today from the US, Europe and India: time to first token, tokens per second and behaviour under load. See <a href="<%=request.getContextPath()%>/gpu/llm-services">LLM APIs and hosting</a>.</p>

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
        <jsp:param name="currentToolUrl" value="gpu/model-benchmark"/>
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

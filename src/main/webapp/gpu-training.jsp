<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="com.google.gson.JsonObject, z.y.x.Network.GpuPricesFunctionality" %>
<%
    // /gpu/training: train a model on a cloud GPU with GridPup (gridpup.com/training), with live GPU prices.
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String hubPage = "training";
    String campaign = "gpu-training";
    JsonObject data = GpuPricesFunctionality.snapshot();
    // GPUs people train on, biggest first, with what each is good for.
    String[][] picks = {
        {"nvidia-b200", "Pre-training and full fine-tuning of 70B+ models"},
        {"nvidia-h200", "Full fine-tuning of large models; long context"},
        {"nvidia-h100", "The standard for LLM training and fine-tuning"},
        {"nvidia-a100", "Fine-tuning 7B&ndash;34B models; proven and cheaper than H100"},
        {"nvidia-rtx-pro-6000", "96 GB on one card: LoRA on 70B models"},
        {"nvidia-l40s", "LoRA fine-tuning, vision and diffusion models"},
        {"nvidia-rtx-5090", "Fast and cheap for small models and LoRA"},
        {"nvidia-rtx-4090", "The cheapest way to fine-tune 7B&ndash;8B models with LoRA"},
        {"nvidia-l4", "Small models, classic ML and tests"},
    };
    Double h100p = num(GpuPricesFunctionality.gpu(data, "nvidia-h100"), "cheapest_usd_per_gpu_hour");
    Double r4090p = num(GpuPricesFunctionality.gpu(data, "nvidia-rtx-4090"), "cheapest_usd_per_gpu_hour");
    String h100 = h100p == null ? null : usd(h100p), r4090 = r4090p == null ? null : usd(r4090p);
    String priceLine = (r4090 != null ? "an RTX 4090 from " + r4090 + " an hour" : "")
            + (r4090 != null && h100 != null ? " or " : "") + (h100 != null ? "an H100 from " + h100 + " an hour" : "");
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
        <jsp:param name="toolName" value="Train AI Models on a Cloud GPU from Your Browser" />
        <jsp:param name="toolDescription" value="Train or fine-tune your AI model on a cloud GPU (H100, A100, RTX 4090) from your browser. See the most a run can cost first, then pay per minute." />
        <jsp:param name="toolCategory" value="GPU Prices" />
        <jsp:param name="breadcrumbCategoryUrl" value="gpu" />
        <jsp:param name="toolUrl" value="gpu/training" />
        <jsp:param name="toolKeywords" value="train ai model on cloud gpu, fine-tune llm cloud gpu, gpu for training, rent gpu for training, h100 training cost, a100 training cost, rtx 4090 fine-tuning, lora fine-tuning gpu, pytorch cloud gpu, train model online, cost to train llm, gpu training per hour" />
        <jsp:param name="toolImage" value="gpu-prices.png" />
        <jsp:param name="toolFeatures" value="Write or upload training code in the browser,Pick a GPU and see the most a run can cost,PyTorch TensorFlow JAX and Hugging Face environments,Pay per minute from prepaid credit,Results saved from /outputs when the run ends,Stops by itself at your cost or time limit" />
        <jsp:param name="faq1q" value="How much does it cost to train a model on a cloud GPU?" />
        <jsp:param name="faq1a" value="You pay for the GPU while your code runs, per minute. Training GPUs range from well under a dollar an hour (RTX 4090) to a few dollars an hour (H100, B200); the live table on this page shows the price now. A 10-hour fine-tuning run on one RTX 4090 usually costs a few dollars." />
        <jsp:param name="faq2q" value="Which GPU should I use to fine-tune an LLM?" />
        <jsp:param name="faq2a" value="For LoRA on 7B-8B models an RTX 4090 or RTX 5090 is enough and cheapest. For 13B-34B models or full fine-tuning of small models use an A100 or L40S. For 70B models and full fine-tuning use H100, H200 or B200, often several at once." />
        <jsp:param name="faq3q" value="What code can I run?" />
        <jsp:param name="faq3a" value="Any training code that runs on Linux with an NVIDIA GPU: PyTorch, TensorFlow, JAX, Hugging Face Transformers, Lightning or scikit-learn. You choose a ready environment and add your own packages, for example with a requirements.txt file." />
        <jsp:param name="faq4q" value="Can a training run cost more than I expect?" />
        <jsp:param name="faq4a" value="No. GridPup shows the price per hour and the most the run can cost before it starts, and the run stops by itself at the cost or time limit you set. You can also stop it at any time; what your code saved to /outputs is kept." />
        <jsp:param name="faq5q" value="Do I need a cloud account or my own GPU?" />
        <jsp:param name="faq5a" value="No. GridPup finds a verified machine with the GPU you pick, sets it up, runs your code and shuts it down. You can write code without an account; you sign in and add credit when you want to run it." />
    </jsp:include>
    <%@ include file="/gpu/gpu-hub-head.inc.jsp" %>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Train AI models on a cloud GPU</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/gpu">GPU Prices</a> /
                    <span>Train a model</span>
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
        <p class="gh-lead">Write or upload your training code in the browser, pick a GPU and start. <strong>GridPup runs it on a cloud GPU, saves your results and shuts the machine down.</strong><%= priceLine.isEmpty() ? "" : " Train on " + priceLine + ", paid per minute." %></p>
        <div class="gh-cta">
            <a class="gh-btn" href="<%= gp("/training", campaign) %>" target="_blank" rel="noopener">Start training on GridPup</a>
            <a class="gh-btn2" href="<%=request.getContextPath()%>/gpu">Compare every GPU price</a>
            <span class="gh-note">No account needed to write code. Pay only when it runs.</span>
        </div>

        <h2 class="gh-h2">Training GPUs and their price now</h2>
        <p class="gh-sub">Cheapest on-demand price per GPU-hour across clouds right now, and what a 10-hour run on one GPU costs at that price.</p>
        <div class="gh-table-wrap">
            <table class="gh-table">
                <caption class="sr-only">Cloud GPU prices for training, US dollars per GPU-hour</caption>
                <thead>
                    <tr>
                        <th scope="col">GPU</th>
                        <th scope="col" class="r">Memory</th>
                        <th scope="col" class="r">From /GPU/h</th>
                        <th scope="col" class="r gh-hide-sm">10-hour run</th>
                        <th scope="col" class="gh-hide-sm">Good for</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    int shown = 0;
                    for (String[] p : picks) {
                        JsonObject g = GpuPricesFunctionality.gpu(data, p[0]);
                        if (g == null) continue;
                        Double low = num(g, "cheapest_usd_per_gpu_hour");
                        shown++;
                %>
                    <tr>
                        <td><a href="<%= gp("/gpus/" + p[0], campaign) %>" target="_blank" rel="noopener"><%= esc(GpuPricesFunctionality.fullName(g)) %></a></td>
                        <td class="r num"><%= gb(num(g, "memory_gb")) %></td>
                        <td class="r num"><strong><%= usd(low) %></strong></td>
                        <td class="r num gh-hide-sm"><%= usd(low == null ? null : low * 10) %></td>
                        <td class="gh-hide-sm gh-muted"><%= p[1] %></td>
                    </tr>
                <%  } %>
                </tbody>
            </table>
            <% if (shown == 0) { %><p class="gh-empty">Prices are not available right now. See them on <a href="<%= gp("/training", campaign) %>" target="_blank" rel="noopener">GridPup</a>.</p><% } %>
        </div>
        <p class="gh-source">Prices from <a href="<%= gp("/", campaign) %>" target="_blank" rel="noopener">GridPup</a>, collected from GPU clouds every few minutes. Storage is billed separately on most clouds.</p>

        <h2 class="gh-h2">How a training run works</h2>
        <ol class="gh-steps">
            <li><strong>Add your code.</strong> Write it in the browser editor or upload a project. Pick an environment: PyTorch, TensorFlow, CUDA or plain Ubuntu, and add packages from your requirements file.</li>
            <li><strong>Pick a GPU and a limit.</strong> You see the price per hour and the most the run can cost before you start.</li>
            <li><strong>GridPup runs it.</strong> It finds the cheapest verified machine with your GPU, starts your code and streams the log. A machine that fails to start is replaced at no charge.</li>
            <li><strong>Get your results.</strong> Everything your code writes to <code>/outputs</code> (models, checkpoints, metrics) is saved when the run ends, and the machine is shut down.</li>
        </ol>

        <h2 class="gh-h2">After training</h2>
        <div class="gh-grid">
            <div class="gh-card">
                <h3><a href="<%=request.getContextPath()%>/gpu/model-benchmark">Benchmark it on real GPUs</a></h3>
                <p>Check your model works, gives the right answers and how fast it is on each GPU before you deploy.</p>
            </div>
            <div class="gh-card">
                <h3><a href="<%=request.getContextPath()%>/gpu/llm-services">Deploy it as an API</a></h3>
                <p>Serve your model behind an https API with keys, on the cheapest GPU that fits, billed by the hour.</p>
            </div>
            <div class="gh-card">
                <h3><a href="<%=request.getContextPath()%>/gpu/models">Start from an open model</a></h3>
                <p>See how much GPU memory Llama, Qwen, Gemma or Mistral need before you fine-tune them.</p>
            </div>
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
        <jsp:param name="currentToolUrl" value="gpu/training"/>
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

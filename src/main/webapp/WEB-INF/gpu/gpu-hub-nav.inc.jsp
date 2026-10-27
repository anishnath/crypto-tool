<%-- Links between the /gpu pages. Static include; the including page sets String hubPage
     ("prices", "training", "model-benchmark", "ai-playground", "llm-services" or "models"). --%>
<style>
    .gh-nav{max-width:1200px;margin:0 auto;padding:0.6rem 1rem 0;display:flex;gap:0.4rem;flex-wrap:wrap}
    .gh-nav a{padding:0.35rem 0.75rem;border:1px solid var(--border);border-radius:9999px;font-size:0.8125rem;font-weight:600;color:var(--text-secondary);text-decoration:none;background:var(--bg-primary)}
    .gh-nav a:hover{border-color:#059669;color:#059669}
    .gh-nav a[aria-current="page"]{background:#059669;border-color:#059669;color:#fff}
    .gh-nav a:focus-visible{outline:2px solid #059669;outline-offset:2px}
</style>
<nav class="gh-nav" aria-label="GPU and AI pages">
<%
    String[][] hubLinks = {
        {"prices", "/gpu", "GPU prices"},
        {"training", "/gpu/training", "Train a model"},
        {"model-benchmark", "/gpu/model-benchmark", "LLM benchmark"},
        {"ai-playground", "/gpu/ai-playground", "AI Playground"},
        {"llm-services", "/gpu/llm-services", "LLM APIs and hosting"},
        {"models", "/gpu/models", "Open models"},
    };
    for (String[] l : hubLinks) {
%>
    <a href="<%= request.getContextPath() + l[1] %>"<%= l[0].equals(hubPage) ? " aria-current=\"page\"" : "" %>><%= l[2] %></a>
<%  } %>
</nav>

<%--
    Visible FAQ component — renders the SAME questions/answers that
    seo-tool-page.jsp emits as JSON-LD FAQPage structured data.

    Reads faq1q/a … faq8q/a from request parameters (set via
    <jsp:param> on the page that includes this).  Single source of
    truth → visible HTML and structured data can never drift.

    Why this matters: Google requires JSON-LD FAQPage entries to
    correspond to *visible* FAQs on the page.  Mismatched or hidden
    Q&As get rich snippets demoted or removed entirely (deceptive
    structured-data policy).

    Usage:
        <jsp:include page="../modern/components/visible-faq.jsp" />

    Works as a drop-in for the legacy hand-coded `.ms-faq` blocks
    that have a div-based question (non-clickable, broken).
--%>
<%
    // Source of truth: request attributes set by seo-tool-page.jsp from
    // the parent's <jsp:param> values.  Both the JSON-LD FAQPage block
    // (in seo-tool-page) and this visible HTML pull from the same
    // strings — they cannot drift apart.
    String[] qs = new String[8];
    String[] as = new String[8];
    int filled = 0;
    for (int i = 0; i < 8; i++) {
        Object q = request.getAttribute("faq" + (i + 1) + "q");
        Object a = request.getAttribute("faq" + (i + 1) + "a");
        qs[i] = q == null ? null : q.toString();
        as[i] = a == null ? null : a.toString();
        if (qs[i] != null && as[i] != null) filled++;
    }
%>
<% if (filled > 0) { %>
<section class="rk-card" style="margin-top:1.25rem;">
    <h2 class="ms-section-title">Frequently asked questions</h2>
    <%-- No microdata here: seo-tool-page.jsp already emits a JSON-LD
         FAQPage block.  Duplicating the same statements as microdata
         would confuse parsers and offers no extra SEO benefit. --%>
    <div class="ms-faq">
<% for (int i = 0; i < qs.length; i++) {
        if (qs[i] == null || as[i] == null) continue;
%>
        <div class="ms-faq-item">
            <button type="button" class="ms-faq-q" aria-expanded="false" onclick="this.parentElement.classList.toggle('open');this.setAttribute('aria-expanded',this.parentElement.classList.contains('open'));">
                <span><%= qs[i] %></span>
                <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <polyline points="6 9 12 15 18 9"/>
                </svg>
            </button>
            <div class="ms-faq-a"><%= as[i] %></div>
        </div>
<% } %>
    </div>
</section>
<% } %>

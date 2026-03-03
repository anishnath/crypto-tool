<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="ASN.1 Decoder - Parse DER/BER & X.509 Certificates" />
        <jsp:param name="toolDescription" value="Decode and parse ASN.1 DER/BER encoded data online. View X.509 certificates, CSRs, and private keys as an expandable tree with OID resolution. Supports PEM, Base64, and Hex input. 100% client-side." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="asn1-decoder.jsp" />
        <jsp:param name="toolKeywords" value="ASN.1 decoder, DER decoder, BER decoder, ASN.1 parser, X.509 decoder, certificate decoder, CSR decoder, private key decoder, ASN.1 viewer, decode certificate online, parse ASN.1, PEM decoder, Base64 ASN.1, OID resolver, DER parser, PKCS decoder, ASN.1 structure viewer, certificate parser" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is ASN.1 encoding?" />
        <jsp:param name="faq1a" value="ASN.1 (Abstract Syntax Notation One) is a standard interface description language for defining data structures serialized cross-platform. It is the foundation for X.509 certificates, CSRs, private keys, and virtually every cryptographic object in PKI. Data is encoded using DER or BER binary encoding rules." />
        <jsp:param name="faq2q" value="What is the difference between DER and BER?" />
        <jsp:param name="faq2a" value="DER (Distinguished Encoding Rules) is a strict subset of BER (Basic Encoding Rules) that guarantees a unique binary encoding for every ASN.1 value. DER is required for cryptographic signatures and X.509 certificates because the same data must always encode identically. BER allows multiple valid encodings for the same data." />
        <jsp:param name="faq3q" value="What can I decode with this tool?" />
        <jsp:param name="faq3a" value="You can decode X.509 certificates (PEM or DER), Certificate Signing Requests (CSR), RSA/EC/DSA private and public keys, PKCS#7 CMS structures, PKCS#12 bundles, and any arbitrary ASN.1 encoded data. Input can be PEM (BEGIN/END headers), Base64, or hexadecimal." />
        <jsp:param name="faq4q" value="Is my certificate data sent to a server?" />
        <jsp:param name="faq4a" value="No. All decoding happens entirely in your browser using JavaScript. No data is transmitted to any server. Your certificates, private keys, and ASN.1 structures remain completely private on your device." />
        <jsp:param name="faq5q" value="What ASN.1 tags does this decoder recognise?" />
        <jsp:param name="faq5a" value="The decoder recognises SEQUENCE (0x30), SET (0x31), INTEGER (0x02), BIT STRING (0x03), OCTET STRING (0x04), NULL (0x05), OBJECT IDENTIFIER (0x06), UTF8String (0x0C), PrintableString (0x13), IA5String (0x16), UTCTime (0x17), GeneralizedTime (0x18), and context-specific tags [0]-[3]. OIDs are resolved to human-readable names." />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Decode ASN.1 DER/BER Data",
      "description": "Step-by-step guide to decoding ASN.1 encoded certificates and cryptographic keys.",
      "totalTime": "PT1M",
      "tool": { "@type": "HowToTool", "name": "8gwifi.org ASN.1 Decoder" },
      "step": [
        { "@type": "HowToStep", "position": 1, "name": "Paste encoded data", "text": "Paste your certificate, CSR, or key in PEM format (-----BEGIN...-----), Base64, or hexadecimal into the input field." },
        { "@type": "HowToStep", "position": 2, "name": "Click Decode", "text": "Press the Decode ASN.1 button to parse the binary structure." },
        { "@type": "HowToStep", "position": 3, "name": "Explore the tree", "text": "The ASN.1 Structure tab shows a collapsible tree with tags, lengths, values, and resolved OID names." },
        { "@type": "HowToStep", "position": 4, "name": "View hex dump", "text": "Switch to the Hex Dump tab to see the raw bytes with offset, hex, and ASCII columns." }
      ]
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;700&display=swap" media="print" onload="this.media='all'">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        :root {
            --tool-primary: #0891b2;
            --tool-primary-dark: #0e7490;
            --tool-gradient: linear-gradient(135deg, #0891b2 0%, #0e7490 100%);
            --tool-light: #ecfeff;
            --ad-mono: 'JetBrains Mono', 'Fira Code', Consolas, monospace;
        }
        [data-theme="dark"] { --tool-light: rgba(8, 145, 178, 0.12); }

        /* ── Header ─────────────────────────────── */
        .ad-page-header { padding: 1.75rem 1.5rem 1.25rem; max-width: 1600px; margin: 0 auto; }
        .ad-breadcrumbs { font-size: 0.8125rem; color: var(--text-secondary, #475569); margin-bottom: 0.75rem; }
        .ad-breadcrumbs a { color: var(--tool-primary); text-decoration: none; }
        .ad-breadcrumbs a:hover { text-decoration: underline; }
        .ad-title-row { display: flex; align-items: flex-start; gap: 1rem; flex-wrap: wrap; }
        .ad-page-header h1 { font-size: clamp(1.5rem, 3vw, 2rem); font-weight: 800; color: var(--text-primary, #0f172a); margin: 0 0 0.375rem; }
        .ad-page-header p { color: var(--text-secondary, #475569); font-size: 0.9375rem; line-height: 1.6; margin: 0; max-width: 680px; }
        .ad-badges { display: flex; gap: 0.375rem; flex-wrap: wrap; margin-top: 0.75rem; }
        .ad-badge { display: inline-flex; align-items: center; padding: 0.2rem 0.6rem; font-size: 0.6875rem; font-weight: 500; border-radius: 9999px; background: var(--tool-light); color: var(--tool-primary); border: 1px solid color-mix(in srgb, var(--tool-primary) 25%, transparent); }

        /* ── Cards ─────────────────────────────── */
        .ad-card { background: var(--bg-primary, #fff); border: 1px solid var(--border, #e2e8f0); border-radius: 0.75rem; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .ad-card-header { background: var(--tool-gradient); color: #fff; padding: 0.75rem 1rem; font-weight: 600; font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem; }
        .ad-card-header svg { flex-shrink: 0; opacity: 0.9; }
        .ad-card-body { padding: 1rem; }

        /* ── Form controls ──────────────────────── */
        .ad-form-group { margin-bottom: 1rem; }
        .ad-label { display: block; font-size: 0.8125rem; font-weight: 600; color: var(--text-primary, #0f172a); margin-bottom: 0.375rem; }
        .ad-label-hint { font-weight: 400; color: var(--text-secondary, #475569); }
        .ad-textarea { width: 100%; padding: 0.625rem 0.75rem; background: var(--bg-secondary, #f8fafc); border: 1px solid var(--border, #e2e8f0); border-radius: 0.5rem; color: var(--text-primary, #0f172a); font-size: 0.8125rem; font-family: var(--ad-mono); resize: vertical; min-height: 180px; transition: border-color 0.2s; }
        .ad-textarea:focus { outline: none; border-color: var(--tool-primary); box-shadow: 0 0 0 3px rgba(8,145,178,0.12); }
        .ad-textarea::placeholder { color: var(--text-muted, #94a3b8); }

        /* ── Presets ────────────────────────────── */
        .ad-presets { display: flex; gap: 0.375rem; flex-wrap: wrap; margin-bottom: 0.75rem; }
        .ad-preset { padding: 0.3rem 0.625rem; font-size: 0.75rem; font-weight: 500; border: 1px solid var(--border, #e2e8f0); border-radius: 9999px; background: var(--bg-primary, #fff); color: var(--text-secondary, #475569); cursor: pointer; transition: all 0.15s; font-family: inherit; }
        .ad-preset:hover { border-color: var(--tool-primary); color: var(--tool-primary); background: var(--tool-light); }

        /* ── Buttons ────────────────────────────── */
        .ad-btn-row { display: flex; gap: 0.5rem; flex-wrap: wrap; }
        .ad-btn { display: inline-flex; align-items: center; justify-content: center; gap: 0.375rem; padding: 0.6rem 1.25rem; font-size: 0.875rem; font-weight: 600; border-radius: 0.5rem; border: none; cursor: pointer; transition: all 0.2s; font-family: inherit; }
        .ad-btn-primary { background: var(--tool-gradient); color: #fff; }
        .ad-btn-primary:hover { opacity: 0.92; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(8,145,178,0.3); }
        .ad-btn-secondary { background: var(--bg-secondary, #f8fafc); color: var(--text-primary, #0f172a); border: 1px solid var(--border, #e2e8f0); }
        .ad-btn-secondary:hover { border-color: var(--tool-primary); color: var(--tool-primary); }
        .ad-btn-sm { padding: 0.4rem 0.875rem; font-size: 0.8125rem; }

        /* ── Output tabs ────────────────────────── */
        .ad-tabs { display: flex; border-bottom: 1px solid var(--border, #e2e8f0); overflow-x: auto; -webkit-overflow-scrolling: touch; }
        .ad-tab { padding: 0.75rem 1rem; font-size: 0.8125rem; font-weight: 500; border: none; background: none; color: var(--text-secondary, #475569); cursor: pointer; border-bottom: 2px solid transparent; white-space: nowrap; font-family: inherit; transition: all 0.15s; }
        .ad-tab.active { color: var(--tool-primary); border-bottom-color: var(--tool-primary); }
        .ad-tab:hover:not(.active) { color: var(--text-primary, #0f172a); }
        .ad-tab-content { display: none; padding: 1rem; }
        .ad-tab-content.active { display: block; }

        /* ── Empty state ────────────────────────── */
        .ad-empty { text-align: center; padding: 3rem 1.5rem; color: var(--text-secondary, #475569); }
        .ad-empty svg { opacity: 0.3; margin-bottom: 0.75rem; }
        .ad-empty h3 { font-size: 0.9375rem; font-weight: 600; color: var(--text-primary, #0f172a); margin-bottom: 0.25rem; }
        .ad-empty p { font-size: 0.8125rem; }

        /* ── ASN.1 tree ─────────────────────────── */
        .ad-asn1-tree { font-family: var(--ad-mono); font-size: 0.8125rem; line-height: 1.5; max-height: 600px; overflow-y: auto; padding: 0.375rem 0; }
        .ad-asn1-row { display: flex; align-items: baseline; gap: 0.3rem; padding: 0.14rem 0.75rem; border-radius: 3px; min-width: 0; }
        .ad-asn1-row.has-kids { cursor: pointer; }
        .ad-asn1-row:hover { background: var(--bg-secondary, #f1f5f9); }
        .ad-asn1-children { border-left: 1.5px solid var(--border, #e2e8f0); margin-left: 1.1rem; padding-left: 0.5rem; }
        /* Toggle arrow */
        .ad-asn1-toggle { flex-shrink: 0; font-size: 0.55rem; color: var(--text-muted, #94a3b8); width: 0.85rem; text-align: center; user-select: none; transition: transform 0.15s; line-height: 1; margin-top: 0.15rem; }
        .ad-asn1-row.collapsed .ad-asn1-toggle { transform: rotate(-90deg); }
        .ad-asn1-row.collapsed .ad-asn1-tag-name { font-style: italic; opacity: 0.7; }
        /* Tag name - colored by type */
        .ad-asn1-tag-name { font-weight: 600; flex-shrink: 0; }
        .ad-tag-seq  { color: #6366f1; }
        .ad-tag-int  { color: #0284c7; }
        .ad-tag-oid  { color: #d97706; }
        .ad-tag-str  { color: #059669; }
        .ad-tag-bs   { color: #0891b2; }
        .ad-tag-time { color: #7c3aed; }
        .ad-tag-misc { color: var(--text-secondary, #475569); }
        .ad-tag-ctx  { color: #9333ea; }
        /* Values */
        .ad-val-oid  { color: var(--text-secondary, #64748b); font-size: 0.75rem; }
        .ad-val-name { color: var(--tool-primary); font-size: 0.75rem; }
        .ad-val-str  { color: #059669; }
        .ad-val-num  { color: #0284c7; }
        .ad-val-bool { color: #7c3aed; font-weight: 600; }
        .ad-val-null { color: var(--text-muted, #94a3b8); }
        .ad-val-hex  { color: var(--text-muted, #94a3b8); font-size: 0.7rem; letter-spacing: 0.02em; }
        .ad-val-bits { color: var(--text-secondary, #64748b); font-size: 0.75rem; }
        .ad-val-cnt  { color: var(--text-muted, #94a3b8); font-size: 0.7rem; }
        /* Right-aligned byte offset */
        .ad-asn1-meta { margin-left: auto; flex-shrink: 0; color: var(--text-muted, #94a3b8); font-size: 0.7rem; padding-left: 0.75rem; white-space: nowrap; }
        /* Dark mode */
        [data-theme="dark"] .ad-asn1-row:hover  { background: var(--bg-tertiary, #334155); }
        [data-theme="dark"] .ad-asn1-children   { border-left-color: var(--border, #475569); }
        [data-theme="dark"] .ad-tag-seq  { color: #818cf8; }
        [data-theme="dark"] .ad-tag-int  { color: #38bdf8; }
        [data-theme="dark"] .ad-tag-oid  { color: #fbbf24; }
        [data-theme="dark"] .ad-tag-str  { color: #34d399; }
        [data-theme="dark"] .ad-tag-bs   { color: #22d3ee; }
        [data-theme="dark"] .ad-tag-time { color: #c084fc; }
        [data-theme="dark"] .ad-tag-ctx  { color: #e879f9; }
        [data-theme="dark"] .ad-val-oid  { color: var(--text-secondary, #94a3b8); }
        [data-theme="dark"] .ad-val-str  { color: #34d399; }
        [data-theme="dark"] .ad-val-num  { color: #38bdf8; }
        [data-theme="dark"] .ad-val-bool { color: #c084fc; }
        [data-theme="dark"] .ad-val-name { color: var(--tool-primary); }

        /* ── Hex dump ───────────────────────────── */
        .ad-hex-dump { font-family: var(--ad-mono); font-size: 0.75rem; line-height: 1.7; max-height: 600px; overflow-y: auto; white-space: pre; color: var(--text-primary, #0f172a); }
        .ad-hex-offset { color: var(--text-muted, #64748b); }
        .hb { color: #0284c7; }
        .ha { color: #059669; }
        /* Highlighted bytes (selected node range) */
        .hb.hi { background: rgba(8,145,178,0.18); color: var(--tool-primary); border-radius: 2px; outline: 1px solid rgba(8,145,178,0.35); }
        .ha.hi { background: rgba(8,145,178,0.18); color: var(--tool-primary); border-radius: 2px; }
        /* TL header bytes (tag + length) highlighted differently */
        .hb.hi-tl { background: rgba(217,119,6,0.18); color: #d97706; border-radius: 2px; outline: 1px solid rgba(217,119,6,0.35); }
        /* Selected tree row */
        .ad-asn1-row.selected { background: rgba(8,145,178,0.08) !important; }
        .ad-asn1-row.selected .ad-asn1-tag-name { text-decoration: underline; text-decoration-style: dotted; }
        [data-theme="dark"] .hb { color: #38bdf8; }
        [data-theme="dark"] .ha { color: #34d399; }
        [data-theme="dark"] .hb.hi { background: rgba(8,145,178,0.25); }
        [data-theme="dark"] .ha.hi { background: rgba(8,145,178,0.25); }
        [data-theme="dark"] .hb.hi-tl { background: rgba(251,191,36,0.2); color: #fbbf24; }

        /* ── Output action bar ──────────────────── */
        .ad-output-actions { display: flex; gap: 0.5rem; padding: 0.625rem 1rem; background: var(--bg-secondary, #f8fafc); border-top: 1px solid var(--border, #e2e8f0); flex-wrap: wrap; }

        /* ── FAQ ────────────────────────────────── */
        .ad-faq { padding: 0 1.5rem 2rem; max-width: 1600px; margin: 0 auto; }
        .ad-faq-inner { background: var(--bg-primary, #fff); border: 1px solid var(--border, #e2e8f0); border-radius: 0.75rem; padding: 1.5rem 2rem; box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
        .ad-faq-title { font-size: 1rem; font-weight: 700; color: var(--text-primary, #0f172a); margin: 0 0 1rem; display: flex; align-items: center; gap: 0.5rem; }
        .ad-faq-title svg { color: var(--tool-primary); }
        .ad-faq-item { border: 1px solid var(--border, #e2e8f0); border-radius: 0.5rem; overflow: hidden; margin-bottom: 0.5rem; }
        .ad-faq-q { width: 100%; display: flex; align-items: center; justify-content: space-between; padding: 0.875rem 1rem; border: none; background: var(--bg-secondary, #f8fafc); color: var(--text-primary, #0f172a); font-size: 0.875rem; font-weight: 500; cursor: pointer; text-align: left; font-family: inherit; transition: color 0.15s; }
        .ad-faq-q:hover { color: var(--tool-primary); }
        .ad-faq-chevron { transition: transform 0.2s; flex-shrink: 0; margin-left: 0.5rem; color: var(--text-muted, #94a3b8); }
        .ad-faq-item.open .ad-faq-chevron { transform: rotate(180deg); color: var(--tool-primary); }
        .ad-faq-a { display: none; padding: 0 1rem 0.875rem; font-size: 0.875rem; line-height: 1.7; color: var(--text-secondary, #475569); background: var(--bg-secondary, #f8fafc); }
        .ad-faq-item.open .ad-faq-a { display: block; }

        /* ── Dark mode cards ────────────────────── */
        [data-theme="dark"] .ad-card { background: var(--bg-secondary, #1e293b); border-color: var(--border, #334155); }
        [data-theme="dark"] .ad-textarea { background: var(--bg-tertiary, #334155); border-color: var(--border, #475569); color: var(--text-primary, #f1f5f9); }
        [data-theme="dark"] .ad-preset { background: var(--bg-secondary, #1e293b); border-color: var(--border, #475569); color: var(--text-primary, #e2e8f0); }
        [data-theme="dark"] .ad-btn-secondary { background: var(--bg-secondary, #1e293b); border-color: var(--border, #475569); color: var(--text-primary, #e2e8f0); }
        [data-theme="dark"] .ad-tabs { border-bottom-color: var(--border, #334155); }
        [data-theme="dark"] .ad-asn1-row:hover { background: var(--bg-tertiary, #334155); }
        [data-theme="dark"] .ad-output-actions { background: var(--bg-tertiary, #334155); border-top-color: var(--border, #475569); }
        [data-theme="dark"] .ad-faq-inner { background: var(--bg-secondary, #1e293b); border-color: var(--border, #334155); }
        [data-theme="dark"] .ad-faq-item { border-color: var(--border, #334155); }
        [data-theme="dark"] .ad-faq-q { background: var(--bg-tertiary, #334155); }
        [data-theme="dark"] .ad-faq-a { background: var(--bg-tertiary, #334155); color: var(--text-secondary, #94a3b8); }
        [data-theme="dark"] .ad-empty { color: var(--text-secondary, #94a3b8); }
        [data-theme="dark"] .ad-empty h3 { color: var(--text-primary, #f1f5f9); }

        @media (max-width: 640px) {
            .ad-btn-row { flex-direction: column; }
            .ad-btn { width: 100%; }
        }

        /* ── Result mode: collapse input, expand output full-width ──────── */
        .tool-page-container.ad-result-mode {
            grid-template-columns: 1fr 300px !important;
        }
        .ad-result-mode .tool-input-column { display: none; }

        /* Output card fills column height in result mode */
        .ad-result-mode .tool-output-column { display: flex; flex-direction: column; }
        .ad-result-mode #outputCard { flex: 1; min-height: 0; }

        /* Result bar */
        #resultModeBar { display: none; padding: 0.5rem 0.75rem; background: var(--bg-secondary, #f8fafc); border-bottom: 1px solid var(--border, #e2e8f0); align-items: center; gap: 0.5rem; flex-wrap: wrap; flex-shrink: 0; }
        .ad-result-mode #resultModeBar { display: flex; }
        .ad-result-mode #tabsBar { display: none; }
        #resultStatus { font-size: 0.8rem; color: var(--text-secondary, #475569); flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

        /* outputSplit: flex column (normal) → grid (result) — toggled via JS */
        #outputSplit { flex: 1; min-height: 0; display: flex; flex-direction: column; overflow: hidden; }

        /* Panel labels */
        .ad-split-label { display: none; font-size: 0.7rem; font-weight: 700; color: var(--text-muted, #94a3b8); letter-spacing: 0.07em; text-transform: uppercase; padding: 0.4rem 0.75rem; border-bottom: 1px solid var(--border, #e2e8f0); background: var(--bg-secondary, #f8fafc); flex-shrink: 0; }

        /* Result-mode panel styles (applied via JS class .split-active) */
        #outputSplit.split-active { display: grid !important; grid-template-columns: 1fr 42%; }
        #outputSplit.split-active #tab-tree,
        #outputSplit.split-active #tab-hex { display: flex !important; flex-direction: column; min-height: 0; overflow: hidden; border-right: 1px solid var(--border, #e2e8f0); padding: 0; }
        #outputSplit.split-active #tab-hex { border-right: none; }
        #outputSplit.split-active .ad-split-label { display: block; }
        #outputSplit.split-active #treeResult,
        #outputSplit.split-active #hexResult { display: flex !important; flex: 1; min-height: 0; overflow-y: auto; flex-direction: column; }
        #outputSplit.split-active #asn1Output { flex: 1; }
        #outputSplit.split-active #hexOutput   { flex: 1; padding: 0.5rem 0.75rem; }
        #outputSplit.split-active .ad-asn1-tree,
        #outputSplit.split-active .ad-hex-dump { max-height: none; }
        #outputSplit.split-active #treeEmpty,
        #outputSplit.split-active #hexEmpty { display: none !important; }
        .ad-result-mode #outputActions { display: none !important; }

        /* Responsive */
        @media (max-width: 900px) {
            .tool-page-container.ad-result-mode { grid-template-columns: 1fr !important; }
            #outputSplit.split-active { grid-template-columns: 1fr; }
            #outputSplit.split-active #tab-tree,
            #outputSplit.split-active #tab-hex { border-right: none; border-bottom: 1px solid var(--border, #e2e8f0); max-height: 45vh; }
        }

        [data-theme="dark"] #resultModeBar { background: var(--bg-tertiary, #334155); border-bottom-color: var(--border, #475569); }
        [data-theme="dark"] .ad-split-label { background: var(--bg-tertiary, #334155); border-bottom-color: var(--border, #475569); }
        [data-theme="dark"] #outputSplit.split-active #tab-tree { border-right-color: var(--border, #475569); }

        /* ── Export dropdown ───────────────────── */
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <div class="ad-page-header">
        <nav class="ad-breadcrumbs">
            <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
            <a href="<%=request.getContextPath()%>/index.jsp">Cryptography</a> /
            ASN.1 Decoder
        </nav>
        <h1>ASN.1 Decoder</h1>
        <p>Parse DER/BER encoded data — X.509 certificates, CSRs, private keys — into a readable tree with OID names and a hex dump. 100% client-side.</p>
        <div class="ad-badges">
            <span class="ad-badge">DER / BER</span>
            <span class="ad-badge">X.509 Certificates</span>
            <span class="ad-badge">PEM &amp; Base64</span>
            <span class="ad-badge">OID Resolver</span>
            <span class="ad-badge">No Upload</span>
        </div>
    </div>

    <div class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Paste any PEM, Base64, or hex-encoded ASN.1 object and click Decode. The tree view shows every tag, length, and value with human-readable OID names. Switch to the Hex Dump tab to inspect the raw bytes.</p>
            </div>
            <div class="tool-description-ad">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </div>

    <main class="tool-page-container" id="mainContainer">

        <!-- INPUT COLUMN -->
        <div class="tool-input-column">
            <div class="ad-card" id="inputCard">
                <div class="ad-card-header">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                    Input — PEM / Base64 / Hex
                </div>
                <div class="ad-card-body">
                    <div class="ad-form-group" style="position:relative" id="dropZone">
                        <label class="ad-label">Encoded data <span class="ad-label-hint">(PEM · Base64 · Hex · drag &amp; drop file)</span></label>
                        <textarea class="ad-textarea" id="asn1Input" rows="12"
                            placeholder="Paste PEM (-----BEGIN...-----), Base64, or hex bytes&#10;&#10;Example hex: 30 0d 06 09 2a 86 48 86 f7 0d 01 01 0b 05 00"></textarea>
                        <div id="dropOverlay" style="display:none;position:absolute;inset:0;top:1.5rem;background:rgba(8,145,178,0.08);border:2px dashed var(--tool-primary);border-radius:0.5rem;pointer-events:none;align-items:center;justify-content:center;font-size:0.875rem;font-weight:600;color:var(--tool-primary);">
                            &#8601; Drop file to decode
                        </div>
                    </div>

                    <div class="ad-form-group">
                        <div class="ad-label" style="margin-bottom:0.5rem">Try an example</div>
                        <div class="ad-presets">
                            <button class="ad-preset" onclick="loadExample('rsa')">RSA Cert</button>
                            <button class="ad-preset" onclick="loadExample('ec')">EC Cert</button>
                            <button class="ad-preset" onclick="loadExample('algo')">AlgorithmID</button>
                            <button class="ad-preset" onclick="loadExample('name')">X.500 Name</button>
                            <button class="ad-preset" onclick="loadExample('mixed')">Mixed Types</button>
                        </div>
                    </div>

                    <div class="ad-btn-row">
                        <button class="ad-btn ad-btn-primary" id="decodeBtn" onclick="decodeASN1()">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                            Decode ASN.1
                        </button>
                        <button class="ad-btn ad-btn-secondary" onclick="clearAll()">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/></svg>
                            Clear
                        </button>
                    </div>
                    <div id="decodeStatus" style="margin-top:0.625rem;font-size:0.8125rem;min-height:1.25rem;color:var(--text-secondary,#475569)"></div>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN -->
        <div class="tool-output-column">
            <div class="ad-card" id="outputCard" style="display:flex;flex-direction:column;min-height:480px;">

                <!-- Result-mode action bar (shown after decode) -->
                <div id="resultModeBar">
                    <button class="ad-btn ad-btn-secondary ad-btn-sm" onclick="newAnalysis()" title="Analyse new data" style="flex-shrink:0">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                        New
                    </button>
                    <span id="resultStatus"></span>
                    <button class="ad-btn ad-btn-secondary ad-btn-sm" onclick="copyOutput()" style="flex-shrink:0">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                        Copy
                    </button>
                    <button class="ad-btn ad-btn-secondary ad-btn-sm" onclick="expandAll()" style="flex-shrink:0">Expand</button>
                    <button class="ad-btn ad-btn-secondary ad-btn-sm" onclick="collapseAll()" style="flex-shrink:0">Collapse</button>
                </div>

                <!-- Normal-mode tabs (hidden after decode) -->
                <div class="ad-tabs" id="tabsBar">
                    <button class="ad-tab active" onclick="switchTab('tree',this)">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:inline;vertical-align:middle;margin-right:4px"><circle cx="12" cy="5" r="3"/><line x1="12" y1="8" x2="12" y2="13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="18" r="3"/><line x1="12" y1="13" x2="6" y2="15"/><line x1="12" y1="13" x2="18" y2="15"/></svg>
                        ASN.1 Structure
                    </button>
                    <button class="ad-tab" onclick="switchTab('hex',this)">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display:inline;vertical-align:middle;margin-right:4px"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                        Hex Dump
                    </button>
                </div>

                <!-- Panels — tabs in normal mode, side-by-side grid in result mode -->
                <div id="outputSplit">

                    <!-- Tree panel -->
                    <div class="ad-tab-content active" id="tab-tree">
                        <div class="ad-split-label">ASN.1 Structure</div>
                        <div class="ad-empty" id="treeEmpty">
                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="5" r="3"/><line x1="12" y1="8" x2="12" y2="13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="18" r="3"/><line x1="12" y1="13" x2="6" y2="15"/><line x1="12" y1="13" x2="18" y2="15"/></svg>
                            <h3>No structure yet</h3>
                            <p>Paste ASN.1 data and click Decode.</p>
                        </div>
                        <div id="treeResult" style="display:none;flex:1;overflow-y:auto">
                            <div id="asn1Output" class="ad-asn1-tree"></div>
                        </div>
                    </div>

                    <!-- Hex panel -->
                    <div class="ad-tab-content" id="tab-hex">
                        <div class="ad-split-label">Hex Dump</div>
                        <div class="ad-empty" id="hexEmpty">
                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                            <h3>No hex dump yet</h3>
                            <p>Decode some data first.</p>
                        </div>
                        <div id="hexResult" style="display:none;flex:1;overflow-y:auto">
                            <div id="hexOutput" class="ad-hex-dump"></div>
                        </div>
                    </div>

                </div>

                <!-- Normal-mode action bar (hidden after decode) -->
                <div class="ad-output-actions" id="outputActions" style="display:none">
                    <button class="ad-btn ad-btn-secondary ad-btn-sm" onclick="copyOutput()">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                        Copy Tree
                    </button>
                    <button class="ad-btn ad-btn-secondary ad-btn-sm" onclick="expandAll()">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 3 21 3 21 9"/><polyline points="9 21 3 21 3 15"/><line x1="21" y1="3" x2="14" y2="10"/><line x1="3" y1="21" x2="10" y2="14"/></svg>
                        Expand All
                    </button>
                    <button class="ad-btn ad-btn-secondary ad-btn-sm" onclick="collapseAll()">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="4 14 10 14 10 20"/><polyline points="20 10 14 10 14 4"/><line x1="10" y1="14" x2="21" y2="3"/><line x1="3" y1="21" x2="14" y2="10"/></svg>
                        Collapse All
                    </button>
                </div>
            </div>
        </div>

        <!-- ADS COLUMN -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- FAQ -->
    <div class="ad-faq">
        <div class="ad-faq-inner">
            <h2 class="ad-faq-title">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                Frequently Asked Questions
            </h2>
            <div class="ad-faq-item">
                <button class="ad-faq-q" onclick="this.parentElement.classList.toggle('open')">
                    What is ASN.1 encoding?
                    <svg class="ad-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="ad-faq-a">ASN.1 (Abstract Syntax Notation One) is a standard interface description language for defining data structures serialized cross-platform. It is the foundation for X.509 certificates, CSRs, private keys, and virtually every cryptographic object in PKI. Data is encoded using DER or BER binary encoding rules.</div>
            </div>
            <div class="ad-faq-item">
                <button class="ad-faq-q" onclick="this.parentElement.classList.toggle('open')">
                    What is the difference between DER and BER?
                    <svg class="ad-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="ad-faq-a">DER (Distinguished Encoding Rules) is a strict subset of BER (Basic Encoding Rules) that guarantees a unique binary encoding for every ASN.1 value. DER is required for cryptographic signatures and X.509 certificates because the same data must always encode identically. BER allows multiple valid encodings for the same data.</div>
            </div>
            <div class="ad-faq-item">
                <button class="ad-faq-q" onclick="this.parentElement.classList.toggle('open')">
                    What can I decode with this tool?
                    <svg class="ad-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="ad-faq-a">You can decode X.509 certificates (PEM or DER), Certificate Signing Requests (CSR), RSA/EC/DSA private and public keys, PKCS#7 CMS structures, PKCS#12 bundles, and any arbitrary ASN.1 encoded data. Input can be PEM (BEGIN/END headers), Base64, or hexadecimal.</div>
            </div>
            <div class="ad-faq-item">
                <button class="ad-faq-q" onclick="this.parentElement.classList.toggle('open')">
                    Is my certificate data sent to a server?
                    <svg class="ad-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="ad-faq-a">No. All decoding happens entirely in your browser using JavaScript. No data is transmitted to any server. Your certificates, private keys, and ASN.1 structures remain completely private on your device.</div>
            </div>
            <div class="ad-faq-item">
                <button class="ad-faq-q" onclick="this.parentElement.classList.toggle('open')">
                    What ASN.1 tags does this decoder recognise?
                    <svg class="ad-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="ad-faq-a">SEQUENCE (0x30), SET (0x31), INTEGER (0x02), BIT STRING (0x03), OCTET STRING (0x04), NULL (0x05), OBJECT IDENTIFIER (0x06), UTF8String (0x0C), PrintableString (0x13), IA5String (0x16), UTCTime (0x17), GeneralizedTime (0x18), and context-specific tags [0]–[3]. OIDs are resolved to human-readable names like rsaEncryption and commonName.</div>
            </div>
        </div>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="asn1-decoder.jsp"/>
        <jsp:param name="category" value="Cryptography"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org &mdash; Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/PemParserFunctions.jsp" class="footer-link">PEM Parser</a>
                <a href="<%=request.getContextPath()%>/certs.jsp" class="footer-link">Cert Extractor</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script type="module">
    import { fromBER } from 'https://esm.sh/asn1js@3.0.7';

    let _lastLabel  = 'ASN1';

    // ── Tab switching ────────────────────────────────────────────────────────
    function switchTab(name, btn) {
        document.querySelectorAll('.ad-tab').forEach(function(t) { t.classList.remove('active'); });
        document.querySelectorAll('.ad-tab-content').forEach(function(t) { t.classList.remove('active'); });
        btn.classList.add('active');
        document.getElementById('tab-' + name).classList.add('active');
    }

    // ── Examples ─────────────────────────────────────────────────────────────
    const examples = {
        // Real RSA-2048 self-signed certificate (openssl req -x509 -newkey rsa:2048)
        rsa: `-----BEGIN CERTIFICATE-----
MIIC4DCCAcgCCQDL83SYKS2hoDANBgkqhkiG9w0BAQsFADAyMRAwDgYDVQQDDAdF
eGFtcGxlMREwDwYDVQQKDAhUZXN0IE9yZzELMAkGA1UEBhMCVVMwHhcNMjYwMzAz
MTExOTQ1WhcNMjcwMzAzMTExOTQ1WjAyMRAwDgYDVQQDDAdFeGFtcGxlMREwDwYD
VQQKDAhUZXN0IE9yZzELMAkGA1UEBhMCVVMwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDVSti3OVUMtqoiKnM+PtqdBXV8Y7/qa2SNk4dcRGooeHWMSN4h
kI/txpbqZQI1HV6XEc8uLrn+EvMdHS891n3qT0x88Fb55zEZ4YPDj51lRs/eQJpa
JOy+hSsgU509XYxiDZo30B4rv7A0y/xEwkPCo2wgJruZFv1l/8kbNrVTVNtay95w
058kM2Mqx8zO6DAKIU5IEMfd9jYYS9gMJ69Xvqlb9GjXCq23/2kKtqKYrnBueJxx
8tTz8/nZ3fwxjCYh4b/121rXwknSaYsxXnPFfMA2e9gj8TnrgeAHGxGPazIj321m
rJhuKI8gjl03Jc78i+PXMRhTKa6eAHisA4gNAgMBAAEwDQYJKoZIhvcNAQELBQAD
ggEBACFexkaF3kcVAJgmNXNQjBdpd83JJHLNYCM/1QCbidwx+4/tdQwkRfaOHz2m
Vl54zMlBQHDoN6nv3Stp0C/GCT3tdCXM/FxrizAFUDnkIc+f4vqnyhwuv0sT0urQ
8kZ/sIc4YlHfSVY81IYGP5jgnFfBXyNvoQXOt5HC5qdzjPMt/kQCuUUrG+VOwcjl
N1FrSWEjykWSCcvMOkHtrxkoAX/1Dq0eTYxA9gU4qoo9N407K0HRE906HZPuou2B
brq4dISfcP+SynU24uJuPc3UFc5p5tlf3Ql36/xMmagc+WX01ZtrSAsyyksh4HTv
cJPf4ekk+QZMpL1ZcCv5Bd2SR58=
-----END CERTIFICATE-----`,

        // Real EC P-256 self-signed certificate (openssl req -x509 with ecparam prime256v1)
        ec: `-----BEGIN CERTIFICATE-----
MIIBUjCB+AIJAPcur5ygZkE7MAoGCCqGSM49BAMCMDExEzARBgNVBAMMCkVDIEV4
YW1wbGUxDTALBgNVBAoMBFRlc3QxCzAJBgNVBAYTAlVTMB4XDTI2MDMwMzExMTk1
MVoXDTI3MDMwMzExMTk1MVowMTETMBEGA1UEAwwKRUMgRXhhbXBsZTENMAsGA1UE
CgwEVGVzdDELMAkGA1UEBhMCVVMwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARB
CSbsgL3f4aO4DrEeJIJC8i6VzCF0OzeHVM5sNzcJfkXlUHP26WXxvGSV7ikCoKLb
9m0FEzbjrV+9tCY6RBiVMAoGCCqGSM49BAMCA0kAMEYCIQD2NrlfbZYAVY5J/A/U
m/8/G0Y2Vx77DVUOxzWlJiu9iQIhALBgP8eBs32HrJmlWjCbHBAks9YDibV6Coxj
l3RTq+Fy
-----END CERTIFICATE-----`,

        // AlgorithmIdentifier hex: SEQUENCE { OID sha256WithRSAEncryption, NULL }
        algo: '30 0d 06 09 2a 86 48 86 f7 0d 01 01 0b 05 00',

        // X.500 Name hex: SEQUENCE { SET { SEQUENCE { OID commonName, UTF8String "Test" } } }
        name: '30 0f 31 0d 30 0b 06 03 55 04 03 0c 04 54 65 73 74',

        // Mixed types hex: SEQUENCE { INTEGER 42, OID sha-256, UTF8String, BOOLEAN, NULL }
        mixed: '30 20 02 01 2a 06 09 60 86 48 01 65 03 04 02 01 0c 0b 48 65 6c 6c 6f 20 41 53 4e 2e 31 01 01 ff 05 00'
    };

    function loadExample(type) {
        document.getElementById('asn1Input').value = examples[type];
        setStatus('');
    }

    // ── Extended OID database ────────────────────────────────────────────────
    const OID_MAP = {
        // X.500 attribute types
        '2.5.4.3':'CN (commonName)','2.5.4.4':'SN (surname)','2.5.4.5':'serialNumber',
        '2.5.4.6':'C (countryName)','2.5.4.7':'L (localityName)','2.5.4.8':'ST (stateOrProvinceName)',
        '2.5.4.9':'streetAddress','2.5.4.10':'O (organizationName)','2.5.4.11':'OU (organizationalUnitName)',
        '2.5.4.12':'title','2.5.4.20':'telephoneNumber','2.5.4.42':'givenName','2.5.4.97':'organizationIdentifier',
        // RSA
        '1.2.840.113549.1.1.1':'rsaEncryption','1.2.840.113549.1.1.2':'md2WithRSAEncryption',
        '1.2.840.113549.1.1.4':'md5WithRSAEncryption','1.2.840.113549.1.1.5':'sha1WithRSAEncryption',
        '1.2.840.113549.1.1.7':'id-RSAES-OAEP','1.2.840.113549.1.1.10':'id-RSASSA-PSS',
        '1.2.840.113549.1.1.11':'sha256WithRSAEncryption','1.2.840.113549.1.1.12':'sha384WithRSAEncryption',
        '1.2.840.113549.1.1.13':'sha512WithRSAEncryption','1.2.840.113549.1.1.14':'sha224WithRSAEncryption',
        // EC
        '1.2.840.10045.2.1':'ecPublicKey','1.2.840.10045.4.3.1':'ecdsaWithSHA224',
        '1.2.840.10045.4.3.2':'ecdsaWithSHA256','1.2.840.10045.4.3.3':'ecdsaWithSHA384',
        '1.2.840.10045.4.3.4':'ecdsaWithSHA512',
        // Named curves
        '1.2.840.10045.3.1.7':'secp256r1 (P-256)','1.3.132.0.34':'secp384r1 (P-384)',
        '1.3.132.0.35':'secp521r1 (P-521)','1.3.101.110':'X25519','1.3.101.111':'X448',
        '1.3.101.112':'Ed25519','1.3.101.113':'Ed448',
        // DSA
        '1.2.840.10040.4.1':'dsaEncryption','1.2.840.10040.4.3':'dsa-with-sha256',
        // Hash algorithms
        '1.3.14.3.2.26':'sha-1','1.2.840.113549.2.5':'md5',
        '2.16.840.1.101.3.4.2.1':'sha-256','2.16.840.1.101.3.4.2.2':'sha-384',
        '2.16.840.1.101.3.4.2.3':'sha-512','2.16.840.1.101.3.4.2.4':'sha-224',
        // X.509 extensions
        '2.5.29.14':'subjectKeyIdentifier','2.5.29.15':'keyUsage','2.5.29.17':'subjectAltName',
        '2.5.29.18':'issuerAltName','2.5.29.19':'basicConstraints','2.5.29.20':'cRLNumber',
        '2.5.29.31':'cRLDistributionPoints','2.5.29.32':'certificatePolicies',
        '2.5.29.35':'authorityKeyIdentifier','2.5.29.36':'policyConstraints',
        '2.5.29.37':'extKeyUsage','2.5.29.54':'inhibitAnyPolicy',
        // Extended key usage
        '1.3.6.1.5.5.7.3.1':'serverAuth','1.3.6.1.5.5.7.3.2':'clientAuth',
        '1.3.6.1.5.5.7.3.3':'codeSigning','1.3.6.1.5.5.7.3.4':'emailProtection',
        '1.3.6.1.5.5.7.3.8':'timeStamping','1.3.6.1.5.5.7.3.9':'OCSPSigning',
        // PKCS
        '1.2.840.113549.1.7.1':'data (PKCS#7)','1.2.840.113549.1.7.2':'signedData',
        '1.2.840.113549.1.7.3':'envelopedData','1.2.840.113549.1.9.1':'emailAddress',
        '1.2.840.113549.1.9.14':'extensionRequest',
        // Authority info access
        '1.3.6.1.5.5.7.1.1':'authorityInfoAccess','1.3.6.1.5.5.7.48.1':'OCSP',
        '1.3.6.1.5.5.7.48.2':'caIssuers',
        // Certificate Transparency
        '1.3.6.1.4.1.11129.2.4.2':'sct (Certificate Transparency)',
    };

    // ── Input preparation — PEM / Base64 / Hex auto-detect ──────────────────
    function prepareBytes(raw) {
        const input = raw.trim();
        // PEM
        if (input.startsWith('-----BEGIN')) {
            const b64 = input
                .replace(/-----BEGIN [^\n]+-----/g, '')
                .replace(/-----END [^\n]+-----/g, '')
                .replace(/\s+/g, '');
            return b64ToBytes(b64);
        }
        // Hex (allow spaces, colons, newlines between pairs)
        const hexClean = input.replace(/[\s:]/g, '');
        if (/^[0-9a-fA-F]+$/.test(hexClean) && hexClean.length % 2 === 0) {
            return hexToBytes(hexClean);
        }
        // Base64 fallback
        return b64ToBytes(input.replace(/\s+/g, ''));
    }

    function b64ToBytes(b64) {
        const bin = atob(b64);
        const out = new Uint8Array(bin.length);
        for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
        return out;
    }

    function hexToBytes(hex) {
        const out = new Uint8Array(hex.length / 2);
        for (let i = 0; i < out.length; i++) out[i] = parseInt(hex.slice(i * 2, i * 2 + 2), 16);
        return out;
    }

    // ── Detect structure label from PEM header ───────────────────────────────
    function detectLabel(raw) {
        const m = raw.match(/-----BEGIN ([A-Z0-9 ]+)-----/);
        if (m) return m[1].split(' ').map(w => w[0] + w.slice(1).toLowerCase()).join(' ');
        return 'ASN.1 Structure';
    }

    // ── Main decode ──────────────────────────────────────────────────────────
    function decodeASN1() {
        const raw = document.getElementById('asn1Input').value;
        if (!raw.trim()) { setStatus('Paste ASN.1 data first.', 'var(--text-muted,#94a3b8)'); return; }

        let bytes;
        try {
            bytes = prepareBytes(raw);
        } catch (e) {
            setStatus('Input error: ' + e.message, '#dc2626');
            return;
        }

        const asn1 = fromBER(bytes instanceof Uint8Array ? bytes.buffer : bytes);
        if (asn1.offset === -1) {
            setStatus('Parse error: ' + (asn1.result.error || 'invalid ASN.1'), '#dc2626');
            return;
        }

        let nodeCount = 0;
        const treeHtml = buildTree(asn1.result, 0);
        document.getElementById('asn1Output').innerHTML = treeHtml;
        document.getElementById('treeEmpty').style.display = 'none';
        document.getElementById('treeResult').style.display = 'block';

        document.getElementById('hexOutput').innerHTML = buildHexDump(bytes);
        document.getElementById('hexEmpty').style.display = 'none';
        document.getElementById('hexResult').style.display = 'block';

        document.getElementById('outputActions').style.display = 'flex';

        _lastLabel = detectLabel(raw);

        const nodes = document.querySelectorAll('.ad-asn1-row').length;
        const summary = `${_lastLabel} \u2014 ${bytes.length.toLocaleString()} bytes \u00b7 ${nodes} nodes`;
        setStatus(summary, '#059669');
        document.getElementById('resultStatus').textContent = summary;

        // Switch to result mode: collapse input, expand output as side-by-side split
        document.getElementById('mainContainer').classList.add('ad-result-mode');
        document.getElementById('outputSplit').classList.add('split-active');
        if (window.ToolUtils) ToolUtils.showToast('Decoded successfully', 2000, 'success');
    }

    // ── asn1js tree renderer ─────────────────────────────────────────────────
    let _nodeId = 0;

    function getTagClass(typeName) {
        if (typeName === 'SEQUENCE' || typeName === 'SET') return 'ad-tag-seq';
        if (typeName === 'INTEGER' || typeName === 'ENUMERATED') return 'ad-tag-int';
        if (typeName === 'OBJECT IDENTIFIER') return 'ad-tag-oid';
        if (['UTF8String','PrintableString','IA5String','VisibleString','TeletexString',
             'GeneralString','UniversalString','BMPString'].includes(typeName)) return 'ad-tag-str';
        if (typeName === 'BIT STRING' || typeName === 'OCTET STRING') return 'ad-tag-bs';
        if (typeName === 'UTCTime' || typeName === 'GeneralizedTime') return 'ad-tag-time';
        if (typeName.startsWith('[')) return 'ad-tag-ctx';
        return 'ad-tag-misc';
    }

    function buildTree(node, depth, offset) {
        if (offset === undefined) offset = 0;
        const id = 'nd-' + (_nodeId++);
        const typeName = getTypeName(node);
        const tagCls  = getTagClass(typeName);
        const valueHtml = getValueHtml(node);
        const children  = getChildren(node);
        const hasKids   = children.length > 0;

        // Compute TL header length so children offsets are accurate
        const tlLen    = node.blockLength - (node.valueBlock ? node.valueBlock.blockLength : 0);
        const endOff   = offset + node.blockLength;

        const toggle = hasKids
            ? `<span class="ad-asn1-toggle" onclick="event.stopPropagation();window._toggleNode('${id}')">&#9660;</span>`
            : `<span class="ad-asn1-toggle"></span>`;

        const cntBadge = hasKids
            ? ` <span class="ad-val-cnt">(${children.length})</span>`
            : '';

        let html = `<div class="ad-asn1-row${hasKids ? ' has-kids' : ''}" id="${id}" data-off="${offset}" data-len="${node.blockLength}" data-tl="${tlLen}" onclick="window._selectNode(this)">`;
        html += toggle;
        html += `<span class="ad-asn1-tag-name ${tagCls}">${typeName}</span>`;
        html += cntBadge;
        if (valueHtml) html += ' ' + valueHtml;
        html += `<span class="ad-asn1-meta">@${offset} · ${node.blockLength}b</span>`;
        html += '</div>';

        if (hasKids) {
            html += `<div class="ad-asn1-children" id="${id}-ch">`;
            let childOffset = offset + tlLen;
            for (const child of children) {
                html += buildTree(child, depth + 1, childOffset);
                childOffset += child.blockLength;
            }
            html += '</div>';
        }
        return html;
    }

    function getTypeName(node) {
        if (!node || !node.idBlock) return 'UNKNOWN';
        const cls  = node.idBlock.tagClass;  // asn1js: 1=Universal, 2=Application, 3=Context, 4=Private
        const num  = node.idBlock.tagNumber;
        const cons = node.idBlock.isConstructed;
        if (cls === 1) return node.constructor.blockName();           // Universal
        if (cls === 3) return '[' + num + ']' + (cons ? '' : ' IMPLICIT'); // Context-specific
        if (cls === 2) return '[APP ' + num + ']';                    // Application
        return '[PRIVATE ' + num + ']';
    }

    function getChildren(node) {
        const v = node.valueBlock && node.valueBlock.value;
        if (!Array.isArray(v)) return [];
        return v.filter(c => c && typeof c === 'object' && c.idBlock && c.valueBlock);
    }

    function getValueHtml(node) {
        const bn = node.constructor.blockName ? node.constructor.blockName() : '';
        try {
            if (bn === 'OBJECT IDENTIFIER') {
                const oid  = node.valueBlock.toString();
                const name = OID_MAP[oid];
                return `<span class="ad-val-oid">${oid}</span>`
                     + (name ? ` <span class="ad-val-name">(${name})</span>` : '');
            }
            if (bn === 'INTEGER') {
                if (!node.valueBlock.isHexOnly && node.valueBlock.valueDec !== undefined) {
                    return `<span class="ad-val-num">${node.valueBlock.valueDec}</span>`;
                }
                const hex  = view2hex(node.valueBlock.valueHexView, 40);
                const bits = (node.valueBlock.valueHexView || []).length * 8;
                return `<span class="ad-val-hex">${hex}</span>`
                     + (bits > 32 ? ` <span class="ad-val-bits">${bits}-bit</span>` : '');
            }
            if (['UTF8String','PrintableString','IA5String','VisibleString','TeletexString',
                 'GeneralString','UniversalString','BMPString'].includes(bn)) {
                return `<span class="ad-val-str">\u201c${escapeHtml(node.valueBlock.value)}\u201d</span>`;
            }
            if (bn === 'UTCTime' || bn === 'GeneralizedTime') {
                let display = node.valueBlock.value || '';
                try {
                    const d = node.toDate();
                    display = d.toISOString().replace('T', ' ').slice(0, 19) + ' UTC';
                } catch (_) {}
                return `<span class="ad-val-num">${escapeHtml(display)}</span>`;
            }
            if (bn === 'BOOLEAN') {
                return `<span class="ad-val-bool">${node.valueBlock.value ? 'TRUE' : 'FALSE'}</span>`;
            }
            if (bn === 'NULL') {
                return `<span class="ad-val-null">NULL</span>`;
            }
            if (bn === 'BIT STRING') {
                const view = node.valueBlock.valueHexView;
                if (view && view.length) {
                    const unused = node.valueBlock.unusedBits || 0;
                    const bits   = view.length * 8 - unused;
                    return `<span class="ad-val-bits">${bits} bits</span> <span class="ad-val-hex">${view2hex(view, 20)}</span>`;
                }
            }
            if (bn === 'OCTET STRING') {
                const view = node.valueBlock.valueHexView;
                if (view && view.length) return `<span class="ad-val-hex">${view2hex(view, 24)}</span>`;
            }
            if (bn === 'ENUMERATED') {
                return `<span class="ad-val-num">${node.valueBlock.valueDec}</span>`;
            }
        } catch (_) {}
        return '';
    }

    function view2hex(view, limit) {
        if (!view || !view.length) return '';
        const end = Math.min(view.length, limit);
        let h = '';
        for (let i = 0; i < end; i++) h += view[i].toString(16).padStart(2, '0') + (i < end - 1 ? ':' : '');
        if (view.length > limit) h += '…';
        return h;
    }

    // ── Node selection → hex highlight ───────────────────────────────────────
    window._selectNode = function(rowEl) {
        // Deselect previous
        const prev = document.querySelector('.ad-asn1-row.selected');
        if (prev && prev !== rowEl) prev.classList.remove('selected');
        document.querySelectorAll('#hexOutput .hb.hi, #hexOutput .hb.hi-tl, #hexOutput .ha.hi')
                .forEach(function(el) { el.classList.remove('hi', 'hi-tl'); });

        if (prev === rowEl) { return; } // second click deselects

        rowEl.classList.add('selected');

        const start = parseInt(rowEl.dataset.off, 10);
        const len   = parseInt(rowEl.dataset.len, 10);
        const tlLen = parseInt(rowEl.dataset.tl,  10);

        const hbs = document.querySelectorAll('#hexOutput .hb');
        const has = document.querySelectorAll('#hexOutput .ha');

        for (var i = start; i < Math.min(start + len, hbs.length); i++) {
            // TL header bytes get a different (amber) highlight
            var cls = (i < start + tlLen) ? 'hi-tl' : 'hi';
            hbs[i].classList.add(cls);
            if (i >= start + tlLen) has[i].classList.add('hi'); // ASCII only for value bytes
        }

        // Scroll hex panel to first highlighted byte
        if (hbs[start]) hbs[start].scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    };

    // ── Expand / Collapse ────────────────────────────────────────────────────
    window._toggleNode = function(id) {
        const row  = document.getElementById(id);
        const kids = document.getElementById(id + '-ch');
        if (!row || !kids) return;
        const collapsed = row.classList.toggle('collapsed');
        kids.style.display = collapsed ? 'none' : '';
    };

    function expandAll() {
        document.querySelectorAll('.ad-asn1-row.has-kids').forEach(n => n.classList.remove('collapsed'));
        document.querySelectorAll('.ad-asn1-children').forEach(c => c.style.display = '');
    }

    function collapseAll() {
        document.querySelectorAll('.ad-asn1-row.has-kids').forEach(n => n.classList.add('collapsed'));
        document.querySelectorAll('.ad-asn1-children').forEach(c => c.style.display = 'none');
    }

    // ── Hex dump — per-byte spans for interactive highlighting ───────────────
    function buildHexDump(bytes) {
        const bpl = 16;
        let html = '';
        for (let off = 0; off < bytes.length; off += bpl) {
            html += `<span class="ad-hex-offset">${off.toString(16).padStart(8, '0')}  </span>`;
            let hexPart = '', ascPart = '';
            for (let i = 0; i < bpl; i++) {
                if (off + i < bytes.length) {
                    const b = bytes[off + i];
                    hexPart += `<span class="hb">${b.toString(16).padStart(2, '0')}</span>`;
                    hexPart += (i < bpl - 1) ? ' ' : '  ';
                    if (i === 7) hexPart += ' '; // mid-gap
                    ascPart += `<span class="ha">${(b >= 32 && b <= 126) ? escapeHtml(String.fromCharCode(b)) : '.'}</span>`;
                } else {
                    hexPart += '   ';
                    ascPart += ' ';
                }
            }
            html += hexPart + ascPart + '\n';
        }
        return html;
    }

    // ── Helpers ──────────────────────────────────────────────────────────────
    function escapeHtml(s) {
        const d = document.createElement('div');
        d.textContent = String(s);
        return d.innerHTML;
    }

    function setStatus(msg, color) {
        const el = document.getElementById('decodeStatus');
        el.textContent = msg;
        el.style.color = color || '';
    }

    function newAnalysis() {
        document.getElementById('mainContainer').classList.remove('ad-result-mode');
        document.getElementById('outputSplit').classList.remove('split-active');
        document.getElementById('asn1Input').value = '';
        document.getElementById('asn1Input').focus();
        _nodeId = 0;
        setStatus('');
        document.getElementById('resultStatus').textContent = '';
        // Clear highlights
        document.querySelectorAll('#hexOutput .hb.hi, #hexOutput .hb.hi-tl, #hexOutput .ha.hi')
                .forEach(function(el) { el.classList.remove('hi', 'hi-tl'); });
        var prev = document.querySelector('.ad-asn1-row.selected');
        if (prev) prev.classList.remove('selected');
        // Restore empty states
        ['treeEmpty','hexEmpty'].forEach(function(id) { document.getElementById(id).style.display = ''; });
        ['treeResult','hexResult'].forEach(function(id) { document.getElementById(id).style.display = 'none'; });
        document.getElementById('outputActions').style.display = 'none';
        // Reset to tree tab
        document.querySelectorAll('.ad-tab').forEach(function(t) { t.classList.remove('active'); });
        document.querySelectorAll('.ad-tab-content').forEach(function(t) { t.classList.remove('active'); });
        document.querySelector('.ad-tab').classList.add('active');
        document.getElementById('tab-tree').classList.add('active');
    }

    function clearAll() {
        newAnalysis();
    }

    function copyOutput() {
        const text = document.getElementById('asn1Output')?.innerText || '';
        if (!text) return;
        navigator.clipboard.writeText(text).then(() => {
            if (window.ToolUtils) ToolUtils.showToast('Tree copied!', 2000, 'success');
        }).catch(() => {
            const ta = document.createElement('textarea');
            ta.value = text;
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            document.body.removeChild(ta);
        });
    }

    // ── Drag & drop ──────────────────────────────────────────────────────────
    (function() {
        const zone    = document.getElementById('dropZone');
        const overlay = document.getElementById('dropOverlay');
        if (!zone) return;
        let dragCount = 0;
        zone.addEventListener('dragenter', function(e) {
            e.preventDefault();
            if (++dragCount === 1) overlay.style.display = 'flex';
        });
        zone.addEventListener('dragleave', function() {
            if (--dragCount === 0) overlay.style.display = 'none';
        });
        zone.addEventListener('dragover', function(e) { e.preventDefault(); });
        zone.addEventListener('drop', function(e) {
            e.preventDefault();
            dragCount = 0;
            overlay.style.display = 'none';
            const file = e.dataTransfer.files[0];
            if (!file) return;
            const reader = new FileReader();
            reader.onload = function(ev) {
                document.getElementById('asn1Input').value = ev.target.result;
                decodeASN1();
            };
            reader.readAsText(file);
        });
    })();

    // Expose to global scope for onclick= attributes
    Object.assign(window, { decodeASN1, clearAll, newAnalysis, loadExample, switchTab, expandAll, collapseAll, copyOutput, _selectNode: window._selectNode, _toggleNode: window._toggleNode });
    </script>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>
</body>
</html>

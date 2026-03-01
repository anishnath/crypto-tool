<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="z.y.x.Security.RSAUtil" %>
<%@ page import="java.security.KeyPair" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="z.y.x.Security.pgppojo" %>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());

    String pubKey = "";
    String privKey = "";
    String checkedKey = "1024";
    boolean k1 = false, k2 = false, k3 = false, k4 = false;

    if (request.getSession().getAttribute("pubkey") == null) {
        Gson gson = new Gson();
        DefaultHttpClient httpClient = new DefaultHttpClient();
        String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "rsa/" + 1024;
        HttpGet getRequest = new HttpGet(url1);
        getRequest.addHeader("accept", "application/json");
        HttpResponse response1 = httpClient.execute(getRequest);
        BufferedReader br = new BufferedReader(new InputStreamReader((response1.getEntity().getContent())));
        StringBuilder content = new StringBuilder();
        String line;
        while (null != (line = br.readLine())) { content.append(line); }
        pgppojo pgppojo = (pgppojo) gson.fromJson(content.toString(), pgppojo.class);
        pubKey = pgppojo.getPubliceKey();
        privKey = pgppojo.getPrivateKey();
        checkedKey = "1024";
    } else {
        pubKey = (String) request.getSession().getAttribute("pubkey");
        privKey = (String) request.getSession().getAttribute("privKey");
        checkedKey = (String) request.getSession().getAttribute("keysize");
        if (checkedKey == null || checkedKey.isEmpty()) { checkedKey = "1024"; }
    }

    if ("512".equals(checkedKey)) { k1 = true; }
    if ("1024".equals(checkedKey)) { k2 = true; }
    if ("2048".equals(checkedKey)) { k3 = true; }
    if ("4096".equals(checkedKey)) { k4 = true; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://code.jquery.com">

    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root{--primary:#667eea;--primary-dark:#5a67d8;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="RSA Encryption & Decryption Online - Key Generator & Tool" />
        <jsp:param name="toolDescription" value="RSA encrypt and decrypt online free. Generate 2048 or 4096-bit key pairs. PKCS1 and OAEP SHA-256 modes. Try RSA in Python. No data stored." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="rsafunctions.jsp" />
        <jsp:param name="toolKeywords" value="rsa encryption online, rsa decryption online, rsa key generator, rsa encrypt decrypt, rsa public key encryption, rsa private key decryption, RSA/ECB/PKCS1Padding, RSA OAEP, rsa key pair generator, rsa 2048, rsa 4096, rsa python, rsa tool online" />
        <jsp:param name="toolImage" value="rsa.png" />
        <jsp:param name="toolFeatures" value="Generate RSA key pairs (512 1024 2048 4096-bit),RSA encryption with public key,RSA decryption with private key,Multiple cipher modes: PKCS1Padding and OAEP,OAEP SHA-256 padding support,PEM format key output,Base64 encoded output,Built-in Python compiler for RSA code,Share encrypted results via URL,No data retention - in-memory processing" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Select RSA key size|Choose 2048-bit or 4096-bit RSA key size and generate a new key pair,Enter your message|Type or paste the plaintext message you want to encrypt in the message field,Choose cipher mode|Select a cipher mode such as RSA/ECB/PKCS1Padding or RSA/ECB/OAEPWithSHA-256AndMGF1Padding,Click Process|Click the Process button to encrypt or decrypt using the selected RSA key and mode,Copy or share result|Copy the Base64-encoded ciphertext or share via URL for collaboration" />
        <jsp:param name="faq1q" value="What is RSA encryption and how does it work?" />
        <jsp:param name="faq1a" value="RSA is an asymmetric cryptography algorithm using two keys: a public key for encryption and a private key for decryption. Security is based on the difficulty of factoring large prime numbers. Named after inventors Rivest, Shamir, and Adleman." />
        <jsp:param name="faq2q" value="What RSA cipher modes are supported?" />
        <jsp:param name="faq2a" value="RSA, RSA/ECB/PKCS1Padding, RSA/None/PKCS1Padding, RSA/NONE/OAEPWithSHA1AndMGF1Padding, RSA/ECB/OAEPWithSHA-1AndMGF1Padding, and RSA/ECB/OAEPWithSHA-256AndMGF1Padding. OAEP with SHA-256 is recommended for new applications." />
        <jsp:param name="faq3q" value="What is the maximum message size for RSA encryption?" />
        <jsp:param name="faq3a" value="Depends on key size and padding. 1024-bit with PKCS1: 117 bytes. 2048-bit: 245 bytes. 4096-bit: ~501 bytes. For larger messages, use hybrid encryption (RSA for key exchange, AES for data)." />
        <jsp:param name="faq4q" value="Is this RSA tool secure?" />
        <jsp:param name="faq4a" value="All operations are performed without storing keys or messages. Use 2048-bit or 4096-bit keys for production. For highly sensitive data, generate keys offline. Built on Java Cryptography Architecture (JCA)." />
        <jsp:param name="faq5q" value="Can I decrypt with the public key?" />
        <jsp:param name="faq5a" value="No, RSA decryption requires the private key. The public key encrypts, the private key decrypts. This asymmetric property enables secure communication without pre-shared secrets." />
        <jsp:param name="faq6q" value="How do I encrypt with RSA in Python?" />
        <jsp:param name="faq6a" value="Use the cryptography or pycryptodome library. This tool includes a built-in Python compiler with RSA templates. Click Try It Live to run RSA encryption code directly in your browser." />
    </jsp:include>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
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

    <%@ include file="modern/ads/ad-init.jsp" %>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

    <style>
        /* RSA Tool - Compact input, spacious output */
        .tool-page-container { grid-template-columns: minmax(280px, 320px) 1fr 300px; }
        @media (max-width: 1024px) { .tool-page-container { grid-template-columns: minmax(270px, 310px) 1fr; } }

        .rsa-form-section { padding: 0.875rem; }

        .rsa-section-label {
            display: flex; align-items: center; gap: 0.375rem;
            font-size: 0.6875rem; font-weight: 700; color: var(--text-secondary, #64748b);
            text-transform: uppercase; letter-spacing: 0.06em;
            margin: 0.75rem 0 0.5rem 0; padding-bottom: 0.375rem;
            border-bottom: 1px solid var(--border, #e2e8f0);
        }
        .rsa-section-label:first-child { margin-top: 0; }

        .rsa-form-group { margin-bottom: 0.625rem; }

        .tool-label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-primary); margin-bottom: 0.25rem; }
        .tool-hint { font-size: 0.6875rem; color: var(--text-secondary); margin: 0 0 0.375rem 0; }

        /* Key size chips */
        .rsa-chips { display: flex; flex-wrap: wrap; gap: 0.375rem; margin-top: 0.25rem; }
        .rsa-chip {
            display: inline-flex; align-items: center; gap: 0.25rem;
            padding: 0.3125rem 0.625rem; border: 1.5px solid var(--border); border-radius: 0.375rem;
            cursor: pointer; font-size: 0.75rem; font-weight: 500;
            color: var(--text-primary); background: var(--bg-primary); transition: all 0.15s;
        }
        .rsa-chip:hover { border-color: var(--primary); background: rgba(102,126,234,0.05); }
        .rsa-chip input { display: none; }
        .rsa-chip.selected { border-color: var(--primary); background: linear-gradient(135deg,#667eea 0%,#764ba2 100%); color: #fff; }
        [data-theme="dark"] .rsa-chip { background: var(--bg-primary); color: var(--text-primary); border-color: var(--border); }

        /* Operation toggle */
        .rsa-op-toggle { display: flex; gap: 0; margin-top: 0.25rem; border-radius: 0.5rem; overflow: hidden; border: 1.5px solid var(--border); }
        .rsa-op-btn {
            flex: 1; display: flex; align-items: center; justify-content: center; gap: 0.375rem;
            padding: 0.5rem 0.75rem; cursor: pointer; font-size: 0.8125rem; font-weight: 600;
            color: var(--text-secondary); background: var(--bg-primary); transition: all 0.2s; border: none;
            position: relative;
        }
        .rsa-op-btn input { display: none; }
        .rsa-op-btn:first-child { border-right: 1px solid var(--border); }
        .rsa-op-btn:hover { background: rgba(102,126,234,0.05); }
        .rsa-op-btn.active[data-op="encrypt"] { background: #059669; color: #fff; border-color: #059669; }
        .rsa-op-btn.active[data-op="decrypt"] { background: #d97706; color: #fff; border-color: #d97706; }
        [data-theme="dark"] .rsa-op-btn { background: var(--bg-primary); color: var(--text-secondary); }
        [data-theme="dark"] .rsa-op-btn.active[data-op="encrypt"] { background: #059669; color: #fff; }
        [data-theme="dark"] .rsa-op-btn.active[data-op="decrypt"] { background: #d97706; color: #fff; }

        .rsa-badge-rec { background: #dcfce7; color: #166534; padding: 0 0.3125rem; border-radius: 0.5rem; font-size: 0.5625rem; font-weight: 700; text-transform: uppercase; }
        .rsa-badge-weak { background: #fee2e2; color: #991b1b; padding: 0 0.3125rem; border-radius: 0.5rem; font-size: 0.5625rem; font-weight: 700; text-transform: uppercase; }
        .rsa-chip.selected .rsa-badge-rec, .rsa-chip.selected .rsa-badge-weak { background: rgba(255,255,255,0.3); color: #fff; }
        [data-theme="dark"] .rsa-badge-rec { background: rgba(22,163,74,0.2); color: #86efac; }
        [data-theme="dark"] .rsa-badge-weak { background: rgba(239,68,68,0.15); color: #fca5a5; }

        /* Cipher select */
        .rsa-select {
            width: 100%; padding: 0.375rem 0.5rem; border: 1.5px solid var(--border); border-radius: 0.375rem;
            font-size: 0.75rem; font-family: inherit; background: var(--bg-primary); color: var(--text-primary); cursor: pointer;
        }

        /* Message textarea */
        .rsa-textarea {
            width: 100%; min-height: 80px; padding: 0.5rem 0.625rem; border: 1.5px solid var(--border);
            border-radius: 0.375rem; font-family: 'JetBrains Mono', monospace; font-size: 0.75rem;
            background: var(--bg-primary); color: var(--text-primary); resize: vertical;
        }
        .rsa-textarea:focus, .rsa-select:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }

        /* Keys toggle */
        .rsa-keys-toggle {
            display: flex; align-items: center; justify-content: space-between;
            cursor: pointer; user-select: none;
        }
        .rsa-keys-toggle .rsa-chevron { transition: transform 0.2s; font-size: 0.75rem; }
        .rsa-keys-toggle.open .rsa-chevron { transform: rotate(180deg); }

        .rsa-keys-panel { display: none; margin-top: 0.5rem; }
        .rsa-keys-panel.open { display: block; }

        .rsa-key-textarea {
            width: 100%; min-height: 60px; max-height: 120px; padding: 0.375rem 0.5rem;
            border: 1px solid var(--border); border-radius: 0.375rem;
            font-family: 'JetBrains Mono', monospace; font-size: 0.5625rem; line-height: 1.4;
            background: var(--bg-secondary); color: var(--text-primary); resize: vertical;
        }

        .rsa-key-actions { display: flex; gap: 0.25rem; margin-top: 0.25rem; margin-bottom: 0.5rem; }
        .rsa-key-btn {
            padding: 0.1875rem 0.5rem; border: 1px solid var(--border); border-radius: 0.25rem;
            background: var(--bg-primary); color: var(--text-secondary); font-size: 0.625rem;
            cursor: pointer; font-family: inherit; transition: all 0.15s;
        }
        .rsa-key-btn:hover { background: var(--primary); color: #fff; border-color: var(--primary); }

        /* Sticky actions */
        .rsa-sticky-actions {
            position: sticky; bottom: 0; background: var(--bg-primary);
            padding: 0.75rem 0.875rem; border-top: 1px solid var(--border);
            margin: 0 -0.875rem -0.875rem; border-radius: 0 0 0.75rem 0.75rem;
            display: flex; gap: 0.375rem; z-index: 5;
        }
        .rsa-sticky-actions .tool-action-btn { flex: 1; padding: 0.625rem 0.5rem; font-size: 0.8125rem; }

        /* Output */
        .tool-result-card { display: flex; flex-direction: column; height: 100%; }
        .tool-result-header {
            display: flex; align-items: center; gap: 0.5rem; padding: 0.75rem 1rem;
            background: var(--bg-secondary); border-bottom: 1px solid var(--border);
            border-radius: 0.75rem 0.75rem 0 0;
        }
        .tool-result-header h4 { margin: 0; font-size: 0.9375rem; font-weight: 600; color: var(--text-primary); }
        .tool-result-content { flex: 1; padding: 1.25rem; min-height: 400px; overflow-y: auto; }

        #output textarea { width: 100%; min-height: 120px; padding: 0.75rem; border: 2px solid var(--border); border-radius: 0.5rem; font-family: 'JetBrains Mono', monospace; font-size: 0.8rem; background: var(--bg-secondary); color: var(--text-primary); resize: vertical; }

        .tool-result-actions { display: none; gap: 0.5rem; padding: 0.75rem 1rem; border-top: 1px solid var(--border); background: var(--bg-secondary); border-radius: 0 0 0.75rem 0.75rem; flex-wrap: wrap; }
        .tool-result-actions.visible { display: flex; }
        .tool-result-actions .tool-action-btn { flex: 1; min-width: 80px; margin-top: 0; }

        .tool-action-btn-secondary { background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%); }
        .tool-action-btn-success { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }

        /* Output tabs */
        .rsa-output-tabs { display: flex; gap: 0; border: 1.5px solid var(--border); border-radius: 0.5rem; overflow: hidden; margin-bottom: 0.75rem; }
        .rsa-output-tab { flex: 1; padding: 0.5rem; font-weight: 600; font-size: 0.8125rem; border: none; cursor: pointer; background: var(--bg-secondary); color: var(--text-secondary); transition: all .15s; font-family: inherit; text-align: center; }
        .rsa-output-tab.active { background: linear-gradient(135deg,#667eea 0%,#764ba2 100%); color: #fff; }
        .rsa-output-tab:hover:not(.active) { background: var(--border); }
        [data-theme="dark"] .rsa-output-tab { background: rgba(255,255,255,0.05); }
        [data-theme="dark"] .rsa-output-tab.active { background: linear-gradient(135deg,#667eea 0%,#764ba2 100%); color: #fff; }
        .rsa-panel { display: none; flex: 1; min-height: 0; }
        .rsa-panel.active { display: flex; flex-direction: column; }
        #rsa-panel-python { min-height: 540px; }

        /* Error message overflow control */
        .tool-result-content .tool-alert { word-break: break-word; overflow-wrap: break-word; max-height: 200px; overflow-y: auto; font-size: 0.8125rem; }
        .tool-result-content .tool-alert code, .tool-result-content .tool-alert pre { white-space: pre-wrap; word-break: break-all; font-size: 0.75rem; }

        /* Dark mode */
        [data-theme="dark"] .tool-alert-success { background: rgba(16,185,129,0.15); border-color: rgba(16,185,129,0.3); color: #6ee7b7; }
        [data-theme="dark"] .tool-alert-error { background: rgba(239,68,68,0.15); border-color: rgba(239,68,68,0.3); color: #fca5a5; }
        [data-theme="dark"] .tool-alert-info { background: rgba(59,130,246,0.15); border-color: rgba(59,130,246,0.3); color: #93c5fd; }

        /* Success result card */
        .rsa-result-success { background: var(--bg-primary); border: 2px solid #10b981; border-radius: 0.75rem; overflow: hidden; }
        .rsa-result-success-header { display: flex; align-items: center; gap: 0.5rem; padding: 0.625rem 0.875rem; background: rgba(16,185,129,0.08); border-bottom: 1px solid rgba(16,185,129,0.2); font-size: 0.8125rem; font-weight: 600; color: #059669; }
        [data-theme="dark"] .rsa-result-success { border-color: rgba(16,185,129,0.4); }
        [data-theme="dark"] .rsa-result-success-header { background: rgba(16,185,129,0.1); color: #6ee7b7; }
        .rsa-result-body { padding: 0.875rem; }
        .rsa-result-meta { display: flex; gap: 1rem; margin-bottom: 0.75rem; font-size: 0.75rem; color: var(--text-secondary); }
        .rsa-result-meta strong { color: var(--text-primary); }

        /* FAQ */
        .faq-item{border:1px solid var(--border,#e2e8f0);border-radius:0.5rem;margin-bottom:0.5rem;overflow:hidden}
        .faq-question{padding:0.75rem 1rem;font-weight:600;font-size:0.875rem;color:var(--text-primary,#0f172a);background:var(--bg-secondary,#f8fafc);border:none;width:100%;cursor:pointer;display:flex;align-items:center;justify-content:space-between;gap:0.75rem;font-family:inherit;text-align:left}
        .faq-question:hover{background:var(--border,#f1f5f9)}
        .faq-answer{display:none;padding:0.75rem 1rem;font-size:0.8125rem;line-height:1.6;color:var(--text-secondary,#475569);border-top:1px solid var(--border,#e2e8f0)}
        .faq-item.open .faq-answer{display:block}
        .faq-item.open .faq-chevron{transform:rotate(180deg)}
        .faq-chevron{transition:transform .2s;flex-shrink:0}
        [data-theme="dark"] .faq-question{background:rgba(255,255,255,0.05);color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .faq-question:hover{background:rgba(255,255,255,0.08)}
        [data-theme="dark"] .faq-answer{color:var(--text-secondary,#cbd5e1);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .faq-item{border-color:var(--border,#334155)}

        /* Share modal */
        .rsa-modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
        .rsa-modal-overlay.active { display: flex; }
        .rsa-modal { background: var(--bg-primary); border-radius: 0.75rem; padding: 1.5rem; max-width: 500px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-height: 80vh; overflow-y: auto; }
        .rsa-modal h3 { margin: 0 0 1rem 0; font-size: 1rem; color: var(--text-primary); }
        .rsa-modal-actions { display: flex; gap: 0.5rem; margin-top: 1rem; justify-content: flex-end; }
        .rsa-modal-cancel { padding: 0.5rem 1rem; border: 1px solid var(--border); border-radius: 0.5rem; background: var(--bg-secondary); color: var(--text-primary); cursor: pointer; font-family: inherit; font-size: 0.875rem; }

        .rsa-field-invalid { border-color: #ef4444 !important; box-shadow: 0 0 0 3px rgba(239,68,68,0.1) !important; }

        /* Responsive */
        @media (max-width: 900px) {
            .tool-page-container { grid-template-columns: 1fr; }
            .rsa-sticky-actions { position: static; margin: 0.5rem 0 0; border-top: none; padding: 0; }
        }

        /* ========== RSA Animation (empty state) ========== */
        .rsa-anim { padding: 1.5rem 1rem 1.25rem; text-align: center; }
        .rsa-anim-title {
            font-size: 0.9375rem; font-weight: 700; color: var(--text-primary);
            margin-bottom: 1.25rem; letter-spacing: -0.01em;
        }

        /* Flow container */
        .rsa-anim-flow {
            display: flex; align-items: center; justify-content: center;
            gap: 0.25rem; flex-wrap: nowrap; overflow-x: auto;
            padding: 0.5rem 0;
        }

        /* Person nodes */
        .rsa-anim-node { display: flex; flex-direction: column; align-items: center; gap: 0.25rem; }
        .rsa-anim-icon {
            width: 2.25rem; height: 2.25rem; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
        }
        .rsa-anim-icon-sender { background: #dbeafe; color: #2563eb; }
        .rsa-anim-icon-receiver { background: #dcfce7; color: #16a34a; }
        [data-theme="dark"] .rsa-anim-icon-sender { background: rgba(37,99,235,0.2); color: #60a5fa; }
        [data-theme="dark"] .rsa-anim-icon-receiver { background: rgba(22,163,74,0.2); color: #4ade80; }
        .rsa-anim-label { font-size: 0.625rem; font-weight: 600; color: var(--text-secondary); text-transform: uppercase; letter-spacing: 0.05em; }

        /* Arrows */
        .rsa-anim-arrow {
            display: flex; flex-direction: column; align-items: center; gap: 0.125rem;
            min-width: 3.5rem;
        }
        .rsa-anim-msg {
            font-size: 0.625rem; font-weight: 600; font-family: 'JetBrains Mono', monospace;
            color: #059669; background: #ecfdf5; padding: 0.125rem 0.375rem;
            border-radius: 0.25rem; white-space: nowrap;
        }
        .rsa-anim-msg-cipher { color: #dc2626; background: #fef2f2; font-size: 0.5625rem; }
        [data-theme="dark"] .rsa-anim-msg { background: rgba(5,150,105,0.15); color: #6ee7b7; }
        [data-theme="dark"] .rsa-anim-msg-cipher { background: rgba(220,38,38,0.15); color: #fca5a5; }

        /* Encrypt/Decrypt boxes */
        .rsa-anim-box {
            display: flex; flex-direction: column; align-items: center; gap: 0.25rem;
            padding: 0.5rem 0.625rem; border-radius: 0.5rem; position: relative;
            font-size: 0.6875rem; font-weight: 700; min-width: 4rem;
        }
        .rsa-anim-box-encrypt { background: rgba(5,150,105,0.08); border: 1.5px solid rgba(5,150,105,0.25); color: #059669; }
        .rsa-anim-box-decrypt { background: rgba(217,119,6,0.08); border: 1.5px solid rgba(217,119,6,0.25); color: #d97706; }
        [data-theme="dark"] .rsa-anim-box-encrypt { background: rgba(5,150,105,0.12); border-color: rgba(5,150,105,0.3); color: #6ee7b7; }
        [data-theme="dark"] .rsa-anim-box-decrypt { background: rgba(217,119,6,0.12); border-color: rgba(217,119,6,0.3); color: #fbbf24; }

        /* Key badges */
        .rsa-anim-key-badge {
            display: flex; align-items: center; gap: 0.1875rem;
            font-size: 0.5rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em;
            padding: 0.0625rem 0.3125rem; border-radius: 1rem; white-space: nowrap;
        }
        .rsa-anim-key-pub { background: #dbeafe; color: #1d4ed8; }
        .rsa-anim-key-priv { background: #fef3c7; color: #92400e; }
        [data-theme="dark"] .rsa-anim-key-pub { background: rgba(59,130,246,0.2); color: #93c5fd; }
        [data-theme="dark"] .rsa-anim-key-priv { background: rgba(245,158,11,0.2); color: #fcd34d; }

        /* Hint */
        .rsa-anim-hint {
            margin-top: 1rem; font-size: 0.75rem; color: var(--text-secondary);
        }

        /* Animations */
        @keyframes rsaFadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes rsaSlide { from { opacity: 0; transform: translateX(-8px); } to { opacity: 1; transform: translateX(0); } }
        @keyframes rsaPop { from { opacity: 0; transform: scale(0.5); } to { opacity: 1; transform: scale(1); } }

        .rsa-anim-fade { opacity: 0; animation: rsaFadeIn 0.4s ease forwards; }
        .rsa-anim-slide { opacity: 0; animation: rsaSlide 0.35s ease forwards; }
        .rsa-anim-pop { opacity: 0; animation: rsaPop 0.3s cubic-bezier(0.34,1.56,0.64,1) forwards; }

        /* Respect reduced motion */
        @media (prefers-reduced-motion: reduce) {
            .rsa-anim-fade, .rsa-anim-slide, .rsa-anim-pop { animation: none; opacity: 1; transform: none; }
        }

        /* Responsive: stack vertically on very small */
        @media (max-width: 520px) {
            .rsa-anim-flow { flex-direction: column; gap: 0.125rem; }
            .rsa-anim-arrow svg { transform: rotate(90deg); }
        }
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">RSA Encryption & Decryption</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#cryptography">Cryptography</a> /
                    RSA Tool
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">RSA 512-4096 bit</span>
                <span class="tool-badge">OAEP + PKCS1</span>
                <span class="tool-badge">Python Compiler</span>
                <span class="tool-badge">No Data Stored</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>RSA encryption and decryption tool with key pair generation. Choose key sizes from 512 to 4096-bit, multiple cipher modes including OAEP SHA-256, and run RSA Python code in your browser. No data stored.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN (Compact) ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <!-- Key Size Form (full page reload) -->
                <form id="keySizeForm" method="GET" action="RSAFunctionality" style="display:none;">
                    <input type="hidden" name="q" value="setNeKey">
                    <input type="hidden" name="keysize" id="keySizeHidden" value="<%= checkedKey %>">
                </form>

                <!-- RSA Form (AJAX) -->
                <form id="rsaForm">
                    <input type="hidden" name="methodName" value="CALCULATE_RSA">

                    <div class="rsa-form-section">
                        <!-- Key Size -->
                        <div class="rsa-section-label">&#128207; RSA Key Size (<%= checkedKey %>-bit active)</div>
                        <div class="rsa-chips" id="keySizeChips">
                            <label class="rsa-chip<% if(k1){%> selected<%}%>" data-size="512">
                                <input type="radio" name="keysize_ui" value="512"<% if(k1){%> checked<%}%>>
                                <span>512</span>
                                <span class="rsa-badge-weak">Weak</span>
                            </label>
                            <label class="rsa-chip<% if(k2){%> selected<%}%>" data-size="1024">
                                <input type="radio" name="keysize_ui" value="1024"<% if(k2){%> checked<%}%>>
                                <span>1024</span>
                            </label>
                            <label class="rsa-chip<% if(k3){%> selected<%}%>" data-size="2048">
                                <input type="radio" name="keysize_ui" value="2048"<% if(k3){%> checked<%}%>>
                                <span>2048</span>
                                <span class="rsa-badge-rec">REC</span>
                            </label>
                            <label class="rsa-chip<% if(k4){%> selected<%}%>" data-size="4096">
                                <input type="radio" name="keysize_ui" value="4096"<% if(k4){%> checked<%}%>>
                                <span>4096</span>
                            </label>
                        </div>

                        <!-- Operation Toggle -->
                        <div class="rsa-section-label">&#128274; Operation</div>
                        <div class="rsa-op-toggle" id="opToggle">
                            <label class="rsa-op-btn active" data-op="encrypt">
                                <input type="radio" name="encryptdecryptparameter" value="encrypt" checked>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
                                Encrypt
                            </label>
                            <label class="rsa-op-btn" data-op="decrypt">
                                <input type="radio" name="encryptdecryptparameter" value="decryprt">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 019.9-1"/></svg>
                                Decrypt
                            </label>
                        </div>

                        <!-- Cipher Mode -->
                        <div class="rsa-form-group" style="margin-top: 0.75rem;">
                            <label class="tool-label">Cipher Mode</label>
                            <select class="rsa-select" id="cipherSelect" name="cipherparameter">
                                <option value="RSA" selected>RSA</option>
                                <option value="RSA/ECB/PKCS1Padding">RSA/ECB/PKCS1Padding</option>
                                <option value="RSA/None/PKCS1Padding">RSA/None/PKCS1Padding</option>
                                <option value="RSA/NONE/OAEPWithSHA1AndMGF1Padding">OAEP SHA-1</option>
                                <option value="RSA/ECB/OAEPWithSHA-1AndMGF1Padding">ECB/OAEP SHA-1</option>
                                <option value="RSA/ECB/OAEPWithSHA-256AndMGF1Padding">ECB/OAEP SHA-256</option>
                            </select>
                        </div>

                        <!-- Message -->
                        <div class="rsa-form-group">
                            <label class="tool-label">Message</label>
                            <textarea class="rsa-textarea" id="message" name="message" placeholder="Enter message to encrypt or decrypt..."></textarea>
                            <div class="tool-hint" style="margin-top:0.25rem;">Max: 117B (1024-bit), 245B (2048-bit)</div>
                        </div>

                        <!-- Keys (collapsible) -->
                        <div class="rsa-section-label rsa-keys-toggle" id="keysToggle">
                            &#128273; RSA Keys (PEM)
                            <span class="rsa-chevron">&#9660;</span>
                        </div>
                        <div class="rsa-keys-panel" id="keysPanel">
                            <label class="tool-label">Public Key</label>
                            <textarea class="rsa-key-textarea" id="publickeyparam" name="publickeyparam"><%= pubKey %></textarea>
                            <div class="rsa-key-actions">
                                <button type="button" class="rsa-key-btn" id="copyPublic">&#128203; Copy</button>
                            </div>

                            <label class="tool-label">Private Key</label>
                            <textarea class="rsa-key-textarea" id="privatekeyparam" name="privatekeyparam"><%= privKey %></textarea>
                            <div class="rsa-key-actions">
                                <button type="button" class="rsa-key-btn" id="copyPrivate">&#128203; Copy</button>
                                <button type="button" class="rsa-key-btn" id="copyBothKeys">&#128203; Copy Both</button>
                            </div>
                        </div>
                    </div>

                    <!-- Sticky Actions -->
                    <div class="rsa-sticky-actions">
                        <button type="submit" class="tool-action-btn" id="processBtn" style="background:#059669;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
                            Encrypt
                        </button>
                        <button type="button" class="tool-action-btn tool-action-btn-success" id="newKeysBtn">
                            &#128260; New Keys
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ========== OUTPUT COLUMN ========== -->
        <div class="tool-output-column">
            <div class="rsa-output-tabs">
                <button type="button" class="rsa-output-tab active" data-panel="output">Output</button>
                <button type="button" class="rsa-output-tab" data-panel="python">&#9654; Try It Live</button>
            </div>

            <div class="rsa-panel active" id="rsa-panel-output">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <span>&#128203;</span>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="output">
                        <div class="rsa-anim">
                            <!-- Title -->
                            <div class="rsa-anim-title">How RSA Works</div>

                            <!-- Flow diagram -->
                            <div class="rsa-anim-flow">
                                <!-- Sender -->
                                <div class="rsa-anim-node rsa-anim-fade" style="animation-delay:0.2s">
                                    <div class="rsa-anim-icon rsa-anim-icon-sender">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                    </div>
                                    <span class="rsa-anim-label">Sender</span>
                                </div>

                                <!-- Arrow 1: plaintext -->
                                <div class="rsa-anim-arrow rsa-anim-fade" style="animation-delay:0.5s">
                                    <div class="rsa-anim-msg rsa-anim-slide">"Hello"</div>
                                    <svg width="24" height="12" viewBox="0 0 24 12"><path d="M0 6h20m0 0l-4-4m4 4l-4 4" fill="none" stroke="var(--text-secondary)" stroke-width="1.5"/></svg>
                                </div>

                                <!-- Encrypt box -->
                                <div class="rsa-anim-box rsa-anim-fade rsa-anim-box-encrypt" style="animation-delay:0.9s">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
                                    <span>Encrypt</span>
                                    <div class="rsa-anim-key-badge rsa-anim-key-pub rsa-anim-pop" style="animation-delay:1.2s">
                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg>
                                        Public Key
                                    </div>
                                </div>

                                <!-- Arrow 2: ciphertext -->
                                <div class="rsa-anim-arrow rsa-anim-fade" style="animation-delay:1.5s">
                                    <div class="rsa-anim-msg rsa-anim-msg-cipher rsa-anim-slide" style="animation-delay:1.6s">a3f9...x7b2</div>
                                    <svg width="24" height="12" viewBox="0 0 24 12"><path d="M0 6h20m0 0l-4-4m4 4l-4 4" fill="none" stroke="var(--text-secondary)" stroke-width="1.5"/></svg>
                                </div>

                                <!-- Decrypt box -->
                                <div class="rsa-anim-box rsa-anim-fade rsa-anim-box-decrypt" style="animation-delay:1.9s">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 019.9-1"/></svg>
                                    <span>Decrypt</span>
                                    <div class="rsa-anim-key-badge rsa-anim-key-priv rsa-anim-pop" style="animation-delay:2.2s">
                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 11-7.778 7.778 5.5 5.5 0 017.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg>
                                        Private Key
                                    </div>
                                </div>

                                <!-- Arrow 3: plaintext out -->
                                <div class="rsa-anim-arrow rsa-anim-fade" style="animation-delay:2.5s">
                                    <div class="rsa-anim-msg rsa-anim-slide" style="animation-delay:2.6s">"Hello"</div>
                                    <svg width="24" height="12" viewBox="0 0 24 12"><path d="M0 6h20m0 0l-4-4m4 4l-4 4" fill="none" stroke="var(--text-secondary)" stroke-width="1.5"/></svg>
                                </div>

                                <!-- Receiver -->
                                <div class="rsa-anim-node rsa-anim-fade" style="animation-delay:2.9s">
                                    <div class="rsa-anim-icon rsa-anim-icon-receiver">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                    </div>
                                    <span class="rsa-anim-label">Receiver</span>
                                </div>
                            </div>

                            <!-- Hint -->
                            <div class="rsa-anim-hint rsa-anim-fade" style="animation-delay:3.2s">
                                Enter a message and click <strong>Encrypt</strong> or <strong>Decrypt</strong> to try it.
                            </div>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="resultActions">
                        <button type="button" class="tool-action-btn" id="swapResult">
                            &#128260; Swap
                        </button>
                        <button type="button" class="tool-action-btn tool-action-btn-secondary" id="shareUrl">
                            &#128279; Share
                        </button>
                        <button type="button" class="tool-action-btn tool-action-btn-success" id="copyResult">
                            &#128203; Copy
                        </button>
                    </div>
                </div>
            </div>

            <div class="rsa-panel" id="rsa-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python Compiler</h4>
                        <select id="rsaCompilerTemplate" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:inherit;background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="encrypt">RSA Encrypt/Decrypt</option>
                            <option value="keygen">Generate RSA Keys</option>
                            <option value="oaep">RSA OAEP Padding</option>
                            <option value="sign">RSA Sign/Verify</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="rsaCompilerIframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== ADS COLUMN ========== -->
        <div class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </div>
    </main>

    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="rsafunctions.jsp"/>
        <jsp:param name="category" value="Cryptography"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- E-E-A-T -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--text-primary);">How RSA Encryption Works</h2>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">RSA Key Generation</h3>
                    <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 0.75rem;">RSA keys are generated by selecting two large primes and computing their product (modulus). The public key consists of the modulus and public exponent (65537), while the private key includes the private exponent derived from the primes.</p>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.875rem;">
                        <li><strong>512-bit:</strong> Weak, testing only</li>
                        <li><strong>1024-bit:</strong> Deprecated, avoid for production</li>
                        <li><strong>2048-bit:</strong> Recommended minimum</li>
                        <li><strong>4096-bit:</strong> High security, slower performance</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Padding Schemes</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.875rem;">
                        <li><strong>PKCS1Padding:</strong> Classic scheme, vulnerable to padding oracle attacks. Legacy only.</li>
                        <li><strong>OAEP SHA-1:</strong> More secure than PKCS1, but SHA-1 is deprecated.</li>
                        <li><strong>OAEP SHA-256:</strong> Recommended modern padding. Best security against chosen-ciphertext attacks.</li>
                    </ul>
                    <div class="tool-alert tool-alert-info" style="margin-top: 0.75rem; font-size: 0.8125rem;">
                        <strong>Message Size Limits:</strong> RSA can only encrypt data smaller than the key size minus padding overhead. For larger data, use hybrid encryption (RSA + AES).
                    </div>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Authorship & Expertise</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--primary);">Anish Nath</a></li>
                        <li><strong>Background:</strong> Security engineer, cryptographic implementations</li>
                        <li><strong>Library:</strong> Java Cryptography Architecture (JCA)</li>
                        <li><strong>Active since:</strong> 2017</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Trust & Privacy</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>No Data Retention:</strong> In-session processing only</li>
                        <li><strong>HTTPS Only:</strong> TLS 1.2+ encryption</li>
                        <li><strong>Open Standards:</strong> Standard JCA RSA implementations</li>
                        <li><strong>Use Case:</strong> Testing, learning, and development</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ -->
    <section style="max-width: 1200px; margin: 2rem auto; padding: 0 1rem;">
        <div class="tool-card" style="padding: 2rem; margin-bottom: 1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1rem;" id="faqs">Frequently Asked Questions</h2>

            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">What is RSA encryption and how does it work?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">RSA is an asymmetric cryptography algorithm using two keys: a public key for encryption and a private key for decryption. Named after Rivest, Shamir, and Adleman, security is based on the difficulty of factoring large prime numbers. Widely used for secure data transmission and digital signatures.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">What RSA cipher modes are supported?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">RSA (default), RSA/ECB/PKCS1Padding, RSA/None/PKCS1Padding, OAEP with SHA-1, ECB/OAEP with SHA-1, and ECB/OAEP with SHA-256. OAEP with SHA-256 is recommended for new applications as it provides the best security.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">What is the maximum message size for RSA encryption?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Depends on key size and padding. 1024-bit PKCS1: 117 bytes. 2048-bit: 245 bytes. 4096-bit: ~501 bytes. For larger messages, use hybrid encryption: encrypt data with AES, encrypt the AES key with RSA.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">Is this RSA tool secure?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">All operations are performed without permanently storing keys or messages. Use 2048-bit+ keys for production. Built on standard Java Cryptography Architecture. For highly sensitive data, generate keys offline.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">Can I decrypt with the public key?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">No. RSA decryption requires the private key. Public key encrypts, private key decrypts. This asymmetric property enables secure communication without pre-shared secrets.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">How do I encrypt with RSA in Python?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">cryptography</code> or <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">pycryptodome</code> library. Click <strong>Try It Live</strong> above to run RSA code directly in your browser.</div>
            </div>
        </div>
    </section>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <!-- Share URL Modal -->
    <div class="rsa-modal-overlay" id="shareModal">
        <div class="rsa-modal">
            <h3>&#128279; Share RSA Result</h3>
            <div id="shareWarningContent"></div>
            <div class="rsa-form-group">
                <label class="tool-label">Share URL</label>
                <textarea class="rsa-textarea" id="shareUrlText" readonly style="min-height:60px;font-size:0.6875rem;"></textarea>
            </div>
            <div class="rsa-modal-actions">
                <button type="button" class="rsa-modal-cancel" onclick="$('#shareModal').removeClass('active')">Close</button>
                <button type="button" class="tool-action-btn" id="copyShareUrl">&#128203; Copy URL</button>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        var TOOL_NAME = 'RSA Encryption Tool';
        var lastResponse = null;

        // ========== KEY SIZE CHIP SELECTION ==========
        $('#keySizeChips .rsa-chip').on('click', function() {
            $('#keySizeChips .rsa-chip').removeClass('selected');
            $(this).addClass('selected');
        });

        // ========== OPERATION TOGGLE ==========
        function syncOperationUI() {
            var isEncrypt = $('input[name="encryptdecryptparameter"]:checked').val() === 'encrypt';
            var btn = $('#processBtn');
            var msg = $('#message');
            if (isEncrypt) {
                btn.html('<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg> Encrypt');
                btn.css('background', '#059669');
                msg.attr('placeholder', 'Enter plaintext message to encrypt...');
            } else {
                btn.html('<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 019.9-1"/></svg> Decrypt');
                btn.css('background', '#d97706');
                msg.attr('placeholder', 'Enter Base64-encoded ciphertext to decrypt...');
            }
        }

        $('.rsa-op-btn').on('click', function() {
            $('.rsa-op-btn').removeClass('active');
            $(this).addClass('active');
            $(this).find('input').prop('checked', true);
            syncOperationUI();
        });

        syncOperationUI();

        // ========== KEY SIZE - Generate New Keys ==========
        $('#keySizeChips .rsa-chip').on('click', function() {
            var size = $(this).data('size');
            $('#keySizeHidden').val(size);
            $('#keySizeForm').submit();
        });

        $('#newKeysBtn').on('click', function() {
            var size = $('input[name="keysize_ui"]:checked').val() || '<%= checkedKey %>';
            $('#keySizeHidden').val(size);
            $('#keySizeForm').submit();
        });

        // ========== KEYS TOGGLE ==========
        $('#keysToggle').on('click', function() {
            $(this).toggleClass('open');
            $('#keysPanel').toggleClass('open');
        });

        // ========== COPY KEYS ==========
        $('#copyPublic').on('click', function() { doCopy($('#publickeyparam').val(), 'Public key copied!'); });
        $('#copyPrivate').on('click', function() { doCopy($('#privatekeyparam').val(), 'Private key copied!'); });
        $('#copyBothKeys').on('click', function() {
            var both = '=== PUBLIC KEY ===\n' + $('#publickeyparam').val() + '\n\n=== PRIVATE KEY ===\n' + $('#privatekeyparam').val();
            doCopy(both, 'Both keys copied!');
        });

        function doCopy(text, msg) {
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.copyToClipboard(text, { showToast: true, toastMessage: msg });
            } else {
                navigator.clipboard.writeText(text);
            }
        }

        // ========== FORM VALIDATION & SUBMIT ==========
        $('#rsaForm').on('submit', function(e) {
            e.preventDefault();

            var msg = $('#message').val().trim();
            var currentOp = $('input[name="encryptdecryptparameter"]:checked').val() === 'encrypt' ? 'Encrypting' : 'Decrypting';
            $('#message').removeClass('rsa-field-invalid');

            if (!msg) {
                $('#message').addClass('rsa-field-invalid');
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.showError('Message Required', '#output', ['Enter a message to ' + currentOp.toLowerCase().replace('ing','') + '']);
                }
                $('#message').focus();
                return;
            }

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showLoading(currentOp + ' with RSA...', '#output');
            } else {
                $('#output').html('<div style="text-align:center;padding:2rem;">' + currentOp + '...</div>');
            }
            $('#resultActions').removeClass('visible');

            $.ajax({
                type: 'POST',
                url: 'RSAFunctionality',
                data: $(this).serialize(),
                dataType: 'json',
                success: function(response) {
                    lastResponse = response;
                    renderOutput(response);
                },
                error: function(xhr, status, error) {
                    if (typeof ToolUtils !== 'undefined') {
                        ToolUtils.showError(error || 'Request failed', '#output', ['Check your connection', 'Verify input format']);
                    } else {
                        $('#output').html('<div class="tool-alert tool-alert-error">Error: ' + error + '</div>');
                    }
                    $('#resultActions').removeClass('visible');
                }
            });
        });

        $('#message').on('input', function() { $(this).removeClass('rsa-field-invalid'); });

        // ========== RENDER OUTPUT ==========
        function renderOutput(response) {
            if (response.success) {
                var isEncrypt = response.operation === 'encrypt';
                var result = isEncrypt ? response.base64Encoded : response.message;

                var html = '<div class="rsa-result-success">';
                html += '<div class="rsa-result-success-header">&#9989; ' + (isEncrypt ? 'Encryption' : 'Decryption') + ' Successful</div>';
                html += '<div class="rsa-result-body">';
                html += '<div class="rsa-result-meta"><div><strong>Operation:</strong> ' + response.operation.toUpperCase() + '</div><div><strong>Algorithm:</strong> ' + response.algorithm + '</div></div>';

                if (response.originalMessage) {
                    html += '<div style="margin-bottom:0.75rem;"><label class="tool-label">Original</label>';
                    html += '<div style="padding:0.5rem;background:var(--bg-secondary);border-radius:0.375rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;word-break:break-all;">' + escapeHtml(response.originalMessage) + '</div></div>';
                }

                html += '<label class="tool-label">Result</label>';
                html += '<textarea id="resultText" readonly style="width:100%;min-height:100px;padding:0.625rem;border:2px solid var(--border);border-radius:0.5rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;background:var(--bg-secondary);color:var(--text-primary);resize:vertical;">' + escapeHtml(result) + '</textarea>';
                html += '</div></div>';

                $('#output').html(html);
                $('#resultActions').addClass('visible');

                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.showToast(isEncrypt ? 'Encrypted!' : 'Decrypted!', 2000, 'success');
                }
            } else {
                var errMsg = response.errorMessage || 'Unknown error';
                var shortMsg = errMsg.length > 120 ? errMsg.substring(0, 120) + '...' : errMsg;
                var opLabel = response.operation ? response.operation.charAt(0).toUpperCase() + response.operation.slice(1) : '';

                var errHtml = '<div class="tool-alert tool-alert-error" style="margin:0;">';
                errHtml += '<strong>' + (opLabel ? opLabel + ' Failed' : 'Failed') + '</strong>';
                if (response.algorithm) errHtml += ' <span style="opacity:0.7;font-size:0.75rem;">(' + escapeHtml(response.algorithm) + ')</span>';
                errHtml += '<div style="margin-top:0.375rem;">' + escapeHtml(shortMsg) + '</div>';
                if (errMsg.length > 120) {
                    errHtml += '<details style="margin-top:0.375rem;"><summary style="cursor:pointer;font-size:0.75rem;opacity:0.8;">Show full error</summary>';
                    errHtml += '<div style="margin-top:0.25rem;font-size:0.6875rem;font-family:JetBrains Mono,monospace;white-space:pre-wrap;word-break:break-all;max-height:120px;overflow-y:auto;padding:0.375rem;background:rgba(0,0,0,0.05);border-radius:0.25rem;">' + escapeHtml(errMsg) + '</div></details>';
                }
                errHtml += '</div>';
                $('#output').html(errHtml);
                $('#resultActions').removeClass('visible');
            }
        }

        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }

        // ========== RESULT ACTIONS ==========
        $('#copyResult').on('click', function() {
            var text = $('#resultText').val();
            if (text) doCopy(text, 'Result copied!');
        });

        $('#swapResult').on('click', function() {
            var text = $('#resultText').val();
            if (!text) return;
            $('#message').val(text);

            // Toggle operation
            $('.rsa-op-btn').removeClass('active');
            if (lastResponse && lastResponse.operation === 'encrypt') {
                $('input[value="decryprt"]').prop('checked', true);
                $('.rsa-op-btn[data-op="decrypt"]').addClass('active');
            } else {
                $('input[value="encrypt"]').prop('checked', true);
                $('.rsa-op-btn[data-op="encrypt"]').addClass('active');
            }
            syncOperationUI();

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('Result swapped to input!', 2000, 'info');
            }
        });

        // ========== SHARE URL ==========
        $('#shareUrl').on('click', function() {
            var text = $('#resultText').val();
            if (!text) return;

            var publicKey = $('#publickeyparam').val();
            var privateKey = $('#privatekeyparam').val();
            var includesPrivateKey = privateKey && privateKey.trim().length > 0;

            var params = new URLSearchParams({
                msg: text,
                op: lastResponse.operation === 'encrypt' ? 'decrypt' : 'encrypt',
                algo: lastResponse.algorithm
            });
            if (publicKey && publicKey.trim()) params.append('pubkey', publicKey);
            if (privateKey && privateKey.trim()) params.append('privkey', privateKey);

            var shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();

            var warning = '';
            if (includesPrivateKey) {
                warning = '<div class="tool-alert tool-alert-error" style="margin-bottom:0.75rem;font-size:0.8125rem;"><strong>&#9888; DANGER: Private Key Included!</strong><br>Anyone with this URL can decrypt ALL messages encrypted with your public key. Only share in trusted, secure channels.</div>';
            } else {
                warning = '<div class="tool-alert tool-alert-info" style="margin-bottom:0.75rem;font-size:0.8125rem;"><strong>&#128274; Public key and encrypted content included.</strong> Private key is NOT shared. URL will be long (RSA keys are 1000+ chars).</div>';
            }

            $('#shareWarningContent').html(warning);
            $('#shareUrlText').val(shareUrl);
            $('#shareModal').addClass('active');
        });

        $('#shareModal').on('click', function(e) { if (e.target === this) $(this).removeClass('active'); });

        $('#copyShareUrl').on('click', function() {
            doCopy($('#shareUrlText').val(), 'Share URL copied!');
        });

        // ========== URL PARAMS (shared links) ==========
        var urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('msg')) {
            $('#message').val(urlParams.get('msg'));

            if (urlParams.get('op') === 'decrypt') {
                $('input[value="decryprt"]').prop('checked', true);
                $('.rsa-op-btn').removeClass('active');
                $('.rsa-op-btn[data-op="decrypt"]').addClass('active');
                syncOperationUI();
            }

            if (urlParams.has('algo')) $('#cipherSelect').val(urlParams.get('algo'));
            if (urlParams.has('pubkey')) $('#publickeyparam').val(urlParams.get('pubkey'));
            if (urlParams.has('privkey')) {
                $('#privatekeyparam').val(urlParams.get('privkey'));
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.showToast('Private key loaded from URL - handle with care!', 5000, 'error');
                }
            }

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('Shared RSA data loaded!', 3000, 'success');
            }
        }

        // ========== OUTPUT TABS ==========
        var rsaCompilerLoaded = false;

        $('.rsa-output-tab').on('click', function() {
            var panel = $(this).data('panel');
            $('.rsa-output-tab').removeClass('active');
            $(this).addClass('active');
            $('.rsa-panel').removeClass('active');
            $('#rsa-panel-' + panel).addClass('active');
            if (panel === 'python' && !rsaCompilerLoaded) {
                loadRsaCompiler();
                rsaCompilerLoaded = true;
            }
        });

        // ========== PYTHON COMPILER ==========
        function buildRsaCode(template) {
            switch (template) {
                case 'encrypt':
                    return 'from Crypto.PublicKey import RSA\nfrom Crypto.Cipher import PKCS1_OAEP\nimport base64\n\n' +
                        '# Generate RSA key pair\nkey = RSA.generate(2048)\npub_key = key.publickey()\n\n' +
                        '# Encrypt\ncipher = PKCS1_OAEP.new(pub_key)\nmessage = b"Hello, RSA encryption!"\n' +
                        'encrypted = cipher.encrypt(message)\nprint("Encrypted (base64):", base64.b64encode(encrypted).decode())\n\n' +
                        '# Decrypt\ndecipher = PKCS1_OAEP.new(key)\ndecrypted = decipher.decrypt(encrypted)\nprint("Decrypted:", decrypted.decode())';
                case 'keygen':
                    return 'from Crypto.PublicKey import RSA\n\n# Generate 2048-bit RSA key pair\nkey = RSA.generate(2048)\n\n' +
                        '# Export keys in PEM format\npub_pem = key.publickey().export_key().decode()\npriv_pem = key.export_key().decode()\n\n' +
                        'print("=== PUBLIC KEY ===")\nprint(pub_pem[:200] + "...")\nprint("\\n=== KEY INFO ===")\n' +
                        'print("Key size:", key.size_in_bits(), "bits")\nprint("Public exponent:", key.e)\nprint("Modulus (first 40 hex):", hex(key.n)[:42] + "...")';
                case 'oaep':
                    return 'from Crypto.PublicKey import RSA\nfrom Crypto.Cipher import PKCS1_OAEP\nfrom Crypto.Hash import SHA256\nimport base64\n\n' +
                        '# Generate key\nkey = RSA.generate(2048)\n\n' +
                        '# OAEP with SHA-256 (recommended)\ncipher = PKCS1_OAEP.new(key.publickey(), hashAlgo=SHA256)\nmessage = b"Secure message with OAEP SHA-256"\n' +
                        'encrypted = cipher.encrypt(message)\nprint("OAEP SHA-256 encrypted:", base64.b64encode(encrypted).decode()[:60] + "...")\n\n' +
                        '# Decrypt\ndecipher = PKCS1_OAEP.new(key, hashAlgo=SHA256)\ndecrypted = decipher.decrypt(encrypted)\nprint("Decrypted:", decrypted.decode())\nprint("\\nMax message size (2048-bit OAEP SHA-256):", (2048//8) - 2*32 - 2, "bytes")';
                case 'sign':
                    return 'from Crypto.PublicKey import RSA\nfrom Crypto.Signature import pkcs1_15\nfrom Crypto.Hash import SHA256\n\n' +
                        '# Generate key\nkey = RSA.generate(2048)\n\n# Sign\nmessage = b"Message to sign"\n' +
                        'h = SHA256.new(message)\nsignature = pkcs1_15.new(key).sign(h)\nprint("Signature (hex):", signature.hex()[:80] + "...")\n\n' +
                        '# Verify\ntry:\n    pkcs1_15.new(key.publickey()).verify(SHA256.new(message), signature)\n    print("Signature valid!")\n' +
                        'except ValueError:\n    print("Signature invalid!")';
                default: return '';
            }
        }

        function loadRsaCompiler() {
            var template = $('#rsaCompilerTemplate').val();
            var code = buildRsaCode(template);
            var b64Code = btoa(unescape(encodeURIComponent(code)));
            var config = JSON.stringify({lang: 'python', code: b64Code});
            $('#rsaCompilerIframe').attr('src', '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config));
        }

        $('#rsaCompilerTemplate').on('change', function() {
            rsaCompilerLoaded = false;
            loadRsaCompiler();
            rsaCompilerLoaded = true;
        });
    });

    window.toggleFaq = function(btn) { btn.parentElement.classList.toggle('open'); };
    </script>
</body>
</html>

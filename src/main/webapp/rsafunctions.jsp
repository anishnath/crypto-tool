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
        <jsp:param name="toolName" value="RSA Encryption Decryption Online - Key Generator & Sign" />
        <jsp:param name="toolDescription" value="Free online RSA encryption and decryption tool. Generate 2048 or 4096-bit key pairs instantly, encrypt with OAEP SHA-256, sign and verify with SHA256withRSA. Instant key generation, one-click encrypt-decrypt swap, built-in Python compiler. No signup, no data stored." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="rsafunctions.jsp" />
        <jsp:param name="toolKeywords" value="rsa encryption online, rsa decryption online, rsa key generator online, rsa encrypt decrypt tool, rsa public key encryption, rsa private key decryption, RSA/ECB/PKCS1Padding, RSA/ECB/OAEPWithSHA-256AndMGF1Padding, rsa oaep sha256, rsa key pair generator 2048, rsa 4096 key generator, rsa encrypt python, rsa decrypt python, rsa tool online free, rsa sign message online, rsa verify signature online, SHA256withRSA, SHA512withRSA, rsa digital signature tool, rsa encryption calculator, rsa encrypt text online, rsa decrypt base64, rsa pem key generator, asymmetric encryption online" />
        <jsp:param name="toolImage" value="rsa.png" />
        <jsp:param name="toolFeatures" value="Instant RSA key pair generation (512 1024 2048 4096-bit) without page reload,RSA encryption with public key using PKCS1 or OAEP padding,RSA decryption with private key,One-click encrypt-to-decrypt swap workflow,RSA digital signatures - Sign and Verify in one tool,OAEP SHA-256 padding (recommended for production),SHA256withRSA SHA512withRSA signature verification,Live message byte counter with key-size limits,Instant key regeneration with loading spinner,PEM format key output with one-click copy,Share encrypted results via URL,Built-in Python compiler with RSA code templates,No data stored - all processing in-memory,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Generate RSA key pair|Click a key size chip (2048-bit recommended) to instantly generate a new RSA public and private key pair - no page reload needed,Choose your operation|Select Encrypt or Decrypt or Sign or Verify from the operation grid,Enter your message|Type or paste the plaintext message into the message field - a live byte counter shows remaining capacity for your key size,Select cipher or signature algorithm|Choose OAEP SHA-256 for encryption or SHA256withRSA for signing from the dropdown,Click the action button|Click Encrypt or Sign to process your message instantly via AJAX - results appear without page reload,Swap or verify results|Click Swap to instantly decrypt your ciphertext or Use for Verify to validate a signature - copy or share the result via URL" />
        <jsp:param name="faq1q" value="How do I encrypt a message with RSA online?" />
        <jsp:param name="faq1a" value="Select a key size (2048-bit recommended), choose Encrypt mode, type your message, select a cipher like OAEP SHA-256, and click Encrypt. The tool generates keys instantly without page reload and outputs Base64-encoded ciphertext you can copy or share." />
        <jsp:param name="faq2q" value="What RSA key size should I use - 2048 or 4096 bit?" />
        <jsp:param name="faq2a" value="Use 2048-bit for most applications - it is the industry standard recommended by NIST until 2030. Use 4096-bit for high-security scenarios like certificate authorities or long-lived keys. 512-bit and 1024-bit are insecure and should only be used for testing." />
        <jsp:param name="faq3q" value="What is the maximum message size for RSA encryption?" />
        <jsp:param name="faq3a" value="RSA message size depends on key size minus padding overhead. 1024-bit PKCS1: 117 bytes. 2048-bit PKCS1: 245 bytes. 2048-bit OAEP SHA-256: 190 bytes. 4096-bit PKCS1: 501 bytes. This tool shows a live byte counter. For larger data, use hybrid encryption (RSA + AES)." />
        <jsp:param name="faq4q" value="What is the difference between PKCS1 and OAEP padding?" />
        <jsp:param name="faq4a" value="PKCS1 v1.5 is the legacy RSA padding scheme, vulnerable to Bleichenbacher padding oracle attacks. OAEP (Optimal Asymmetric Encryption Padding) with SHA-256 is the modern recommended standard, providing provable security against chosen-ciphertext attacks. Always use OAEP SHA-256 for new applications." />
        <jsp:param name="faq5q" value="How do I sign and verify a message with RSA?" />
        <jsp:param name="faq5a" value="Select Sign mode, enter your message, choose SHA256withRSA algorithm, and click Sign. The tool creates a digital signature using your private key. To verify, click Use for Verify - the signature auto-populates. Click Verify to confirm authenticity using the public key." />
        <jsp:param name="faq6q" value="How do I encrypt with RSA in Python?" />
        <jsp:param name="faq6a" value="Use the pycryptodome library: from Crypto.PublicKey import RSA and from Crypto.Cipher import PKCS1_OAEP. This tool has a built-in Python compiler with ready-to-run RSA encryption, key generation, OAEP, and signing templates. Click Try It Live to run code in your browser." />
        <jsp:param name="faq7q" value="Is this RSA tool secure? Is my data stored?" />
        <jsp:param name="faq7a" value="No data is permanently stored. Keys and messages are processed in-memory during your session only. The tool uses Java Cryptography Architecture (JCA) with standard RSA implementations. For production secrets, generate keys offline. All connections use HTTPS with TLS 1.2+." />
        <jsp:param name="faq8q" value="Can I decrypt RSA ciphertext with the public key?" />
        <jsp:param name="faq8a" value="No. RSA is asymmetric - the public key encrypts, only the matching private key can decrypt. This is what makes RSA secure for communication: anyone can encrypt with your public key, but only you can decrypt with your private key. For signing, the roles reverse: the private key signs, the public key verifies." />
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
        .tool-page-container { grid-template-columns: minmax(310px, 360px) 1fr 300px; }
        @media (max-width: 1024px) { .tool-page-container { grid-template-columns: minmax(300px, 350px) 1fr; } }

        .rsa-form-section { padding: 1rem; }

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

        /* Operation toggle — 2x2 grid so all 4 buttons always fit */
        .rsa-op-toggle {
            display: grid; grid-template-columns: 1fr 1fr; gap: 0;
            margin-top: 0.25rem; border-radius: 0.5rem; overflow: hidden; border: 1.5px solid var(--border);
        }
        .rsa-op-btn {
            display: flex; align-items: center; justify-content: center; gap: 0.25rem;
            padding: 0.4375rem 0.375rem; cursor: pointer; font-size: 0.75rem; font-weight: 600;
            color: var(--text-secondary); background: var(--bg-primary); transition: all 0.2s; border: none;
            position: relative; white-space: nowrap;
        }
        .rsa-op-btn svg { width: 12px; height: 12px; flex-shrink: 0; }
        .rsa-op-btn input { display: none; }
        .rsa-op-btn:hover { background: rgba(102,126,234,0.05); }
        .rsa-op-btn.active[data-op="encrypt"] { background: #059669; color: #fff; }
        .rsa-op-btn.active[data-op="decrypt"] { background: #d97706; color: #fff; }
        .rsa-op-btn.active[data-op="sign"] { background: #2563eb; color: #fff; }
        .rsa-op-btn.active[data-op="verify"] { background: #7c3aed; color: #fff; }
        /* Grid borders: right edge on left col, bottom edge on top row */
        .rsa-op-btn:nth-child(odd) { border-right: 1px solid var(--border); }
        .rsa-op-btn:nth-child(-n+2) { border-bottom: 1px solid var(--border); }
        [data-theme="dark"] .rsa-op-btn { background: var(--bg-primary); color: var(--text-secondary); }
        [data-theme="dark"] .rsa-op-btn.active[data-op="encrypt"] { background: #059669; color: #fff; }
        [data-theme="dark"] .rsa-op-btn.active[data-op="decrypt"] { background: #d97706; color: #fff; }
        [data-theme="dark"] .rsa-op-btn.active[data-op="sign"] { background: #2563eb; color: #fff; }
        [data-theme="dark"] .rsa-op-btn.active[data-op="verify"] { background: #7c3aed; color: #fff; }

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
            padding: 0.75rem 1rem; border-top: 1px solid var(--border);
            margin: 0 -1rem -1rem; border-radius: 0 0 0.75rem 0.75rem;
            display: flex; gap: 0.5rem; z-index: 5;
        }
        .rsa-sticky-actions .tool-action-btn { flex: 1; padding: 0.625rem 0.75rem; font-size: 0.8125rem; white-space: nowrap; min-width: 0; }

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

        /* Byte counter */
        .rsa-byte-counter {
            font-size: 0.6875rem; font-family: 'JetBrains Mono', monospace;
            text-align: right; margin-top: 0.25rem; color: var(--text-secondary);
        }
        .rsa-byte-counter.warn { color: #d97706; }
        .rsa-byte-counter.over { color: #dc2626; font-weight: 600; }

        /* Verify result cards */
        .rsa-result-valid { background: var(--bg-primary); border: 2px solid #10b981; border-radius: 0.75rem; overflow: hidden; }
        .rsa-result-valid-header { display: flex; align-items: center; gap: 0.5rem; padding: 0.625rem 0.875rem; background: rgba(16,185,129,0.08); border-bottom: 1px solid rgba(16,185,129,0.2); font-size: 0.8125rem; font-weight: 600; color: #059669; }
        .rsa-result-invalid { background: var(--bg-primary); border: 2px solid #ef4444; border-radius: 0.75rem; overflow: hidden; }
        .rsa-result-invalid-header { display: flex; align-items: center; gap: 0.5rem; padding: 0.625rem 0.875rem; background: rgba(239,68,68,0.08); border-bottom: 1px solid rgba(239,68,68,0.2); font-size: 0.8125rem; font-weight: 600; color: #dc2626; }
        [data-theme="dark"] .rsa-result-valid { border-color: rgba(16,185,129,0.4); }
        [data-theme="dark"] .rsa-result-valid-header { background: rgba(16,185,129,0.1); color: #6ee7b7; }
        [data-theme="dark"] .rsa-result-invalid { border-color: rgba(239,68,68,0.4); }
        [data-theme="dark"] .rsa-result-invalid-header { background: rgba(239,68,68,0.1); color: #fca5a5; }

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
            .rsa-sticky-actions { position: static; margin: 0.5rem 0 0; border-top: none; padding: 0; gap: 0.5rem; }
            .rsa-sticky-actions .tool-action-btn { padding: 0.75rem 1rem; font-size: 0.875rem; }
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

        /* Key generation spinner & overlay */
        @keyframes rsaSpin { to { transform: rotate(360deg); } }
        @keyframes rsaKeyFlash {
            0% { border-color: var(--border); background: var(--bg-secondary); }
            40% { border-color: #10b981; background: rgba(16,185,129,0.08); }
            100% { border-color: var(--border); background: var(--bg-secondary); }
        }
        .rsa-spinner {
            display: inline-block; width: 14px; height: 14px; border: 2px solid rgba(255,255,255,0.3);
            border-top-color: #fff; border-radius: 50%; animation: rsaSpin 0.6s linear infinite; vertical-align: -2px;
        }
        .rsa-keys-generating { position: relative; pointer-events: none; }
        .rsa-keys-generating::after {
            content: ''; position: absolute; inset: 0; background: rgba(248,250,252,0.7);
            border-radius: 0.375rem; z-index: 2;
        }
        [data-theme="dark"] .rsa-keys-generating::after { background: rgba(15,23,42,0.6); }
        .rsa-key-textarea.rsa-key-fresh { animation: rsaKeyFlash 0.8s ease; }
        .rsa-keygen-status {
            display: flex; align-items: center; gap: 0.375rem; padding: 0.375rem 0.625rem;
            font-size: 0.6875rem; font-weight: 600; border-radius: 0.375rem; margin-top: 0.375rem;
            transition: opacity 0.3s, max-height 0.3s; overflow: hidden;
        }
        .rsa-keygen-status.loading {
            background: rgba(102,126,234,0.08); border: 1px solid rgba(102,126,234,0.2);
            color: var(--primary); max-height: 40px; opacity: 1;
        }
        .rsa-keygen-status.success {
            background: rgba(16,185,129,0.08); border: 1px solid rgba(16,185,129,0.2);
            color: #059669; max-height: 40px; opacity: 1;
        }
        .rsa-keygen-status.error {
            background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.2);
            color: #dc2626; max-height: 40px; opacity: 1;
        }
        .rsa-keygen-status.hidden { max-height: 0; opacity: 0; padding: 0 0.625rem; margin-top: 0; border: none; }
        [data-theme="dark"] .rsa-keygen-status.loading { background: rgba(102,126,234,0.12); color: #93bbfd; }
        [data-theme="dark"] .rsa-keygen-status.success { background: rgba(16,185,129,0.12); color: #6ee7b7; }
        [data-theme="dark"] .rsa-keygen-status.error { background: rgba(239,68,68,0.12); color: #fca5a5; }

        /* Respect reduced motion */
        @media (prefers-reduced-motion: reduce) {
            .rsa-anim-fade, .rsa-anim-slide, .rsa-anim-pop { animation: none; opacity: 1; transform: none; }
            .rsa-spinner { animation: none; border-top-color: rgba(255,255,255,0.6); }
            .rsa-key-textarea.rsa-key-fresh { animation: none; }
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
                <h1 class="tool-page-title">RSA Encryption & Decryption Online - Key Generator, Sign & Verify</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#cryptography">Cryptography</a> /
                    RSA Encryption Tool
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">2048 & 4096-bit Keys</span>
                <span class="tool-badge">OAEP SHA-256</span>
                <span class="tool-badge">Sign & Verify</span>
                <span class="tool-badge">Instant Key Gen</span>
                <span class="tool-badge">Try It Live (Python)</span>
                <span class="tool-badge">No Data Stored</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Encrypt, decrypt, sign and verify with RSA online. Generate 2048 or 4096-bit key pairs instantly (no page reload), encrypt with OAEP SHA-256 or PKCS1, create digital signatures with SHA256withRSA, and swap between encrypt/decrypt in one click. Includes a built-in Python compiler with RSA code templates. Free, no signup, no data stored.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ========== INPUT COLUMN (Compact) ========== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <!-- RSA Form (AJAX) -->
                <form id="rsaForm">

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
                                <input type="radio" name="op_mode" value="encrypt" checked>
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
                                Encrypt
                            </label>
                            <label class="rsa-op-btn" data-op="decrypt">
                                <input type="radio" name="op_mode" value="decrypt">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 019.9-1"/></svg>
                                Decrypt
                            </label>
                            <label class="rsa-op-btn" data-op="sign">
                                <input type="radio" name="op_mode" value="sign">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg>
                                Sign
                            </label>
                            <label class="rsa-op-btn" data-op="verify">
                                <input type="radio" name="op_mode" value="verify">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                Verify
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
                            <div class="rsa-byte-counter" id="byteCounter">
                                <span id="byteCount">0</span> / <span id="byteMax">245</span> bytes
                            </div>
                        </div>

                        <!-- Signature (Verify mode only) -->
                        <div class="rsa-form-group" id="signatureGroup" style="display:none">
                            <label class="tool-label">Signature (Base64)</label>
                            <textarea class="rsa-textarea" id="signatureInput" name="signature" placeholder="Paste Base64-encoded signature to verify..."></textarea>
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
                        <div class="rsa-keygen-status hidden" id="keygenStatus"></div>
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
                            <div class="rsa-anim-hint rsa-anim-fade" id="animHint" style="animation-delay:3.2s">
                                Enter a message and click <strong>Encrypt</strong>, <strong>Decrypt</strong>, <strong>Sign</strong>, or <strong>Verify</strong> to try it.
                            </div>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="resultActions">
                        <button type="button" class="tool-action-btn" id="swapResult">
                            &#128260; Swap
                        </button>
                        <button type="button" class="tool-action-btn tool-action-btn-secondary" id="useForVerify" style="display:none">
                            &#9989; Use for Verify
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
                    <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 0.75rem;">RSA keys are generated by selecting two large primes (p, q) and computing their product n = p &times; q. The public key is (n, e) where e is typically 65537. The private key contains the private exponent d derived via the extended Euclidean algorithm. This tool generates key pairs instantly via AJAX &mdash; no page reload required.</p>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.875rem;">
                        <li><strong>512-bit:</strong> Insecure &mdash; testing and education only</li>
                        <li><strong>1024-bit:</strong> Deprecated by NIST &mdash; avoid for production</li>
                        <li><strong>2048-bit:</strong> Recommended minimum (NIST standard until 2030)</li>
                        <li><strong>4096-bit:</strong> High security for CAs and long-lived keys</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Padding Schemes Explained</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.875rem;">
                        <li><strong>PKCS1 v1.5:</strong> Legacy scheme. Vulnerable to Bleichenbacher padding oracle attacks (CVE-1998-XXXX). Use only for backwards compatibility.</li>
                        <li><strong>OAEP SHA-1:</strong> Improved security over PKCS1, but SHA-1 is deprecated since 2011.</li>
                        <li><strong>OAEP SHA-256:</strong> Modern recommended padding. Provable CCA2 security. Use <code style="background:var(--bg-secondary);padding:0.1rem 0.3rem;border-radius:0.25rem;font-size:0.85em;">RSA/ECB/OAEPWithSHA-256AndMGF1Padding</code> for all new applications.</li>
                    </ul>
                    <div class="tool-alert tool-alert-info" style="margin-top: 0.75rem; font-size: 0.8125rem;">
                        <strong>Message Size Limits:</strong> RSA encrypts at most (keyBits/8 &minus; paddingOverhead) bytes. 2048-bit OAEP SHA-256 = 190 bytes max. For larger data, use hybrid encryption: encrypt data with AES-256-GCM, encrypt the AES key with RSA.
                    </div>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Authorship & Expertise</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color: var(--primary);">Anish Nath</a></li>
                        <li><strong>Background:</strong> Security engineer specializing in cryptographic implementations</li>
                        <li><strong>Library:</strong> Java Cryptography Architecture (JCA) &mdash; standard RSA provider</li>
                        <li><strong>Active since:</strong> 2017 &mdash; continuously updated</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size: 1rem; margin-bottom: 0.75rem;">Trust & Privacy</h3>
                    <ul style="margin-left: 1rem; color: var(--text-secondary); font-size: 0.9rem;">
                        <li><strong>Zero Data Retention:</strong> Keys and messages exist in-memory during your session only</li>
                        <li><strong>HTTPS Only:</strong> All connections encrypted with TLS 1.2+</li>
                        <li><strong>Open Standards:</strong> Standard JCA/JCE RSA, no proprietary algorithms</li>
                        <li><strong>No Signup Required:</strong> Free, instant access for testing, learning, and development</li>
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
                <button class="faq-question" onclick="toggleFaq(this)">How do I encrypt a message with RSA online?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Select a key size (2048-bit recommended), choose <strong>Encrypt</strong> mode, type your message, select a cipher like OAEP SHA-256, and click Encrypt. The tool generates keys instantly without page reload and outputs Base64-encoded ciphertext you can copy or share via URL.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">What RSA key size should I use &mdash; 2048 or 4096 bit?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use <strong>2048-bit</strong> for most applications &mdash; it is the industry standard recommended by NIST until 2030. Use <strong>4096-bit</strong> for high-security scenarios like certificate authorities or long-lived keys. 512-bit and 1024-bit are insecure and should only be used for testing.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">What is the maximum message size for RSA encryption?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">It depends on key size minus padding overhead. <strong>1024-bit PKCS1:</strong> 117 bytes. <strong>2048-bit PKCS1:</strong> 245 bytes. <strong>2048-bit OAEP SHA-256:</strong> 190 bytes. <strong>4096-bit PKCS1:</strong> ~501 bytes. This tool shows a live byte counter as you type. For larger data, use hybrid encryption (RSA + AES).</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">What is the difference between PKCS1 and OAEP padding?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer"><strong>PKCS1 v1.5</strong> is the legacy RSA padding scheme, vulnerable to Bleichenbacher padding oracle attacks. <strong>OAEP</strong> (Optimal Asymmetric Encryption Padding) with SHA-256 is the modern recommended standard, providing provable security against chosen-ciphertext attacks. Always use <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">RSA/ECB/OAEPWithSHA-256AndMGF1Padding</code> for new applications.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">How do I sign and verify a message with RSA?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Select <strong>Sign</strong> mode, enter your message, choose SHA256withRSA, and click Sign. The tool creates a Base64 digital signature using your private key. To verify, click <strong>Use for Verify</strong> &mdash; the signature auto-populates and the tool switches to Verify mode. Click Verify to confirm authenticity using the public key.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">How do I encrypt with RSA in Python?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">Use the <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">pycryptodome</code> library: <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">from Crypto.PublicKey import RSA</code> and <code style="background:var(--bg-secondary);padding:0.15rem 0.35rem;border-radius:0.25rem;font-size:0.85em;">from Crypto.Cipher import PKCS1_OAEP</code>. This tool includes a built-in Python compiler with ready-to-run templates for RSA encryption, key generation, OAEP, and signing. Click <strong>Try It Live</strong> to run code directly in your browser.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">Is this RSA tool secure? Is my data stored?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">No data is permanently stored. Keys and messages are processed in-memory during your session only. The tool uses standard Java Cryptography Architecture (JCA) RSA implementations. For production secrets, generate keys offline. All connections use HTTPS with TLS 1.2+.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">Can I decrypt RSA ciphertext with the public key?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                <div class="faq-answer">No. RSA is asymmetric &mdash; the public key encrypts, only the matching private key can decrypt. This is what makes RSA secure: anyone can encrypt with your public key, but only you hold the private key to decrypt. For digital signing the roles reverse: the private key signs, the public key verifies.</div>
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
        var currentMode = 'encrypt'; // encrypt | decrypt | sign | verify

        // Cipher algorithm sets
        var encryptAlgorithms = [
            { value: 'RSA', label: 'RSA' },
            { value: 'RSA/ECB/PKCS1Padding', label: 'RSA/ECB/PKCS1Padding' },
            { value: 'RSA/None/PKCS1Padding', label: 'RSA/None/PKCS1Padding' },
            { value: 'RSA/NONE/OAEPWithSHA1AndMGF1Padding', label: 'OAEP SHA-1' },
            { value: 'RSA/ECB/OAEPWithSHA-1AndMGF1Padding', label: 'ECB/OAEP SHA-1' },
            { value: 'RSA/ECB/OAEPWithSHA-256AndMGF1Padding', label: 'ECB/OAEP SHA-256' }
        ];
        var signAlgorithms = [
            { value: 'SHA256withRSA', label: 'SHA256withRSA (Recommended)' },
            { value: 'SHA512withRSA', label: 'SHA512withRSA' },
            { value: 'SHA384withRSA', label: 'SHA384withRSA' },
            { value: 'SHA1withRSA', label: 'SHA1withRSA' },
            { value: 'SHA1WithRSA/PSS', label: 'SHA1WithRSA/PSS' },
            { value: 'SHA224WithRSA/PSS', label: 'SHA224WithRSA/PSS' },
            { value: 'SHA384WithRSA/PSS', label: 'SHA384WithRSA/PSS' },
            { value: 'MD5withRSA', label: 'MD5withRSA (Deprecated)' }
        ];

        // Byte counter max sizes: keyBytes - paddingOverhead
        var paddingOverhead = {
            'RSA': 11, 'RSA/ECB/PKCS1Padding': 11, 'RSA/None/PKCS1Padding': 11,
            'RSA/NONE/OAEPWithSHA1AndMGF1Padding': 42, 'RSA/ECB/OAEPWithSHA-1AndMGF1Padding': 42,
            'RSA/ECB/OAEPWithSHA-256AndMGF1Padding': 66
        };

        function getKeySize() {
            return parseInt($('input[name="keysize_ui"]:checked').val() || '<%= checkedKey %>');
        }

        function getMaxBytes() {
            var algo = $('#cipherSelect').val();
            var overhead = paddingOverhead[algo];
            if (overhead === undefined) return -1; // sign/verify algorithms, no limit
            var keyBytes = getKeySize() / 8;
            return keyBytes - overhead;
        }

        // ========== OPERATION TOGGLE ==========
        function syncOperationUI() {
            currentMode = $('input[name="op_mode"]:checked').val();
            var btn = $('#processBtn');
            var msg = $('#message');
            var isSignVerify = (currentMode === 'sign' || currentMode === 'verify');

            // Update cipher dropdown
            var $select = $('#cipherSelect');
            var algos = isSignVerify ? signAlgorithms : encryptAlgorithms;
            $select.empty();
            algos.forEach(function(a) {
                $select.append($('<option>').val(a.value).text(a.label));
            });

            // Update cipher label
            $select.closest('.rsa-form-group').find('.tool-label').text(isSignVerify ? 'Signature Algorithm' : 'Cipher Mode');

            // Signature group
            $('#signatureGroup').toggle(currentMode === 'verify');

            // Byte counter
            if (isSignVerify) {
                $('#byteCounter').hide();
            } else {
                $('#byteCounter').show();
                updateByteCounter();
            }

            // Process button
            switch (currentMode) {
                case 'encrypt':
                    btn.html('<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg> Encrypt');
                    btn.css('background', '#059669');
                    msg.attr('placeholder', 'Enter plaintext message to encrypt...');
                    break;
                case 'decrypt':
                    btn.html('<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 019.9-1"/></svg> Decrypt');
                    btn.css('background', '#d97706');
                    msg.attr('placeholder', 'Enter Base64-encoded ciphertext to decrypt...');
                    break;
                case 'sign':
                    btn.html('<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><path d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg> Sign');
                    btn.css('background', '#2563eb');
                    msg.attr('placeholder', 'Enter message to sign with private key...');
                    break;
                case 'verify':
                    btn.html('<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> Verify');
                    btn.css('background', '#7c3aed');
                    msg.attr('placeholder', 'Enter original message to verify signature...');
                    break;
            }
        }

        // ========== BYTE COUNTER ==========
        function updateByteCounter() {
            if (currentMode === 'sign' || currentMode === 'verify') return;
            var text = $('#message').val() || '';
            var byteLen = new Blob([text]).size;
            var max = getMaxBytes();
            $('#byteCount').text(byteLen);
            $('#byteMax').text(max > 0 ? max : '?');
            var $counter = $('#byteCounter');
            $counter.removeClass('warn over');
            if (max > 0) {
                var pct = byteLen / max;
                if (pct > 0.9) $counter.addClass('over');
                else if (pct > 0.7) $counter.addClass('warn');
            }
        }

        $('#message').on('input', function() {
            $(this).removeClass('rsa-field-invalid');
            updateByteCounter();
        });

        $('#cipherSelect').on('change', function() { updateByteCounter(); });

        $('.rsa-op-btn').on('click', function() {
            $('.rsa-op-btn').removeClass('active');
            $(this).addClass('active');
            $(this).find('input').prop('checked', true);
            syncOperationUI();
        });

        syncOperationUI();

        // ========== KEY SIZE - Generate New Keys (AJAX) ==========
        var keygenStatusTimer = null;

        function showKeygenStatus(type, msg) {
            var el = document.getElementById('keygenStatus');
            el.className = 'rsa-keygen-status ' + type;
            el.innerHTML = msg;
            // Auto-hide success/error after a delay
            clearTimeout(keygenStatusTimer);
            if (type === 'success' || type === 'error') {
                keygenStatusTimer = setTimeout(function() {
                    el.className = 'rsa-keygen-status hidden';
                }, 4000);
            }
        }

        function generateNewKeys(size) {
            var newKeysBtn = document.getElementById('newKeysBtn');
            var keysPanel = document.getElementById('keysPanel');
            var pubTextarea = document.getElementById('publickeyparam');
            var privTextarea = document.getElementById('privatekeyparam');

            // Update chip selection immediately
            document.querySelectorAll('#keySizeChips .rsa-chip').forEach(function(c) { c.classList.remove('selected'); });
            var target = document.querySelector('#keySizeChips .rsa-chip[data-size="' + size + '"]');
            if (target) target.classList.add('selected');
            var radio = document.querySelector('input[name="keysize_ui"][value="' + size + '"]');
            if (radio) radio.checked = true;

            // Show loading state: button spinner + keys overlay + status message
            newKeysBtn.disabled = true;
            newKeysBtn.innerHTML = '<span class="rsa-spinner"></span> Generating\u2026';
            keysPanel.classList.add('rsa-keys-generating');
            showKeygenStatus('loading', '<span class="rsa-spinner" style="border-color:rgba(102,126,234,0.3);border-top-color:var(--primary);width:12px;height:12px;"></span> Generating ' + size + '-bit RSA key pair\u2026');

            // Auto-expand keys panel so user sees the progress
            var keysToggle = document.getElementById('keysToggle');
            if (!keysToggle.classList.contains('open')) {
                keysToggle.classList.add('open');
                keysPanel.classList.add('open');
            }

            var params = new URLSearchParams({ methodName: 'GENERATE_RSA_KEYS', keysize: size });

            fetch('RSAFunctionality', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(function(r) { return r.json(); })
            .then(function(resp) {
                if (resp.success) {
                    pubTextarea.value = resp.publicKey;
                    privTextarea.value = resp.privateKey;

                    // Flash highlight on key textareas
                    pubTextarea.classList.remove('rsa-key-fresh');
                    privTextarea.classList.remove('rsa-key-fresh');
                    void pubTextarea.offsetWidth; // force reflow
                    pubTextarea.classList.add('rsa-key-fresh');
                    privTextarea.classList.add('rsa-key-fresh');

                    // Update key size label
                    document.querySelector('.rsa-section-label').innerHTML = '&#128207; RSA Key Size (' + resp.keySize + '-bit active)';
                    updateByteCounter();

                    showKeygenStatus('success', '&#9989; ' + resp.keySize + '-bit keys generated successfully');
                    if (typeof ToolUtils !== 'undefined') {
                        ToolUtils.showToast(resp.keySize + '-bit keys generated!', 2000, 'success');
                    }
                } else {
                    showKeygenStatus('error', '&#10060; ' + (resp.errorMessage || 'Key generation failed'));
                    if (typeof ToolUtils !== 'undefined') {
                        ToolUtils.showToast('Key generation failed: ' + (resp.errorMessage || 'Unknown error'), 3000, 'error');
                    }
                }
            })
            .catch(function() {
                showKeygenStatus('error', '&#10060; Connection error - please try again');
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.showToast('Key generation failed - check connection', 3000, 'error');
                }
            })
            .finally(function() {
                newKeysBtn.disabled = false;
                newKeysBtn.innerHTML = '&#128260; New Keys';
                keysPanel.classList.remove('rsa-keys-generating');
            });
        }

        document.querySelectorAll('#keySizeChips .rsa-chip').forEach(function(chip) {
            chip.addEventListener('click', function() {
                generateNewKeys(this.dataset.size);
            });
        });

        document.getElementById('newKeysBtn').addEventListener('click', function() {
            var checked = document.querySelector('input[name="keysize_ui"]:checked');
            var size = checked ? checked.value : '<%= checkedKey %>';
            generateNewKeys(size);
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
            $('#message').removeClass('rsa-field-invalid');
            $('#signatureInput').removeClass('rsa-field-invalid');

            // Validation per mode
            var opLabel, loadingMsg, methodName, encryptdecryptVal;
            var extraData = {};

            switch (currentMode) {
                case 'encrypt':
                    opLabel = 'Encrypt'; loadingMsg = 'Encrypting with RSA...';
                    methodName = 'CALCULATE_RSA'; encryptdecryptVal = 'encrypt';
                    if (!msg) { showFieldError('#message', 'Enter a message to encrypt'); return; }
                    break;
                case 'decrypt':
                    opLabel = 'Decrypt'; loadingMsg = 'Decrypting with RSA...';
                    methodName = 'CALCULATE_RSA'; encryptdecryptVal = 'decryprt';
                    if (!msg) { showFieldError('#message', 'Enter ciphertext to decrypt'); return; }
                    break;
                case 'sign':
                    opLabel = 'Sign'; loadingMsg = 'Signing with RSA...';
                    methodName = 'RSA_SIGN_VERIFY_MESSAGEE'; encryptdecryptVal = 'decryprt';
                    if (!msg) { showFieldError('#message', 'Enter a message to sign'); return; }
                    if (!$('#privatekeyparam').val().trim()) {
                        if (typeof ToolUtils !== 'undefined') ToolUtils.showError('Private Key Required', '#output', ['A private key is needed for signing']);
                        return;
                    }
                    break;
                case 'verify':
                    opLabel = 'Verify'; loadingMsg = 'Verifying RSA signature...';
                    methodName = 'RSA_SIGN_VERIFY_MESSAGEE'; encryptdecryptVal = 'encrypt';
                    if (!msg) { showFieldError('#message', 'Enter the original message'); return; }
                    var sig = $('#signatureInput').val().trim();
                    if (!sig) { showFieldError('#signatureInput', 'Paste the Base64 signature to verify'); return; }
                    extraData.signature = sig;
                    if (!$('#publickeyparam').val().trim()) {
                        if (typeof ToolUtils !== 'undefined') ToolUtils.showError('Public Key Required', '#output', ['A public key is needed for verification']);
                        return;
                    }
                    break;
            }

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showLoading(loadingMsg, '#output');
            } else {
                $('#output').html('<div style="text-align:center;padding:2rem;">' + loadingMsg + '</div>');
            }
            $('#resultActions').removeClass('visible');

            var postData = {
                methodName: methodName,
                encryptdecryptparameter: encryptdecryptVal,
                message: msg,
                cipherparameter: $('#cipherSelect').val(),
                publickeyparam: $('#publickeyparam').val(),
                privatekeyparam: $('#privatekeyparam').val()
            };
            $.extend(postData, extraData);

            $.ajax({
                type: 'POST',
                url: 'RSAFunctionality',
                data: postData,
                dataType: 'json',
                success: function(response) {
                    lastResponse = response;
                    lastResponse._mode = currentMode;
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

        function showFieldError(selector, message) {
            $(selector).addClass('rsa-field-invalid');
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showError('Input Required', '#output', [message]);
            }
            $(selector).focus();
        }

        // ========== RENDER OUTPUT ==========
        function renderOutput(response) {
            var mode = response._mode || (response.operation === 'encrypt' ? 'encrypt' : 'decrypt');

            if (response.success) {
                if (mode === 'sign') {
                    renderSignOutput(response);
                } else if (mode === 'verify') {
                    renderVerifyOutput(response);
                } else {
                    renderEncryptDecryptOutput(response);
                }
            } else {
                renderErrorOutput(response, mode);
            }
        }

        function renderEncryptDecryptOutput(response) {
            var isEncrypt = response.operation === 'encrypt';
            var result = isEncrypt ? response.base64Encoded : response.message;

            var html = '<div class="rsa-result-success">';
            html += '<div class="rsa-result-success-header">&#9989; ' + (isEncrypt ? 'Encryption' : 'Decryption') + ' Successful</div>';
            html += '<div class="rsa-result-body">';
            html += '<div class="rsa-result-meta"><div><strong>Operation:</strong> ' + response.operation.toUpperCase() + '</div><div><strong>Algorithm:</strong> ' + escapeHtml(response.algorithm) + '</div></div>';

            if (response.originalMessage) {
                html += '<div style="margin-bottom:0.75rem;"><label class="tool-label">Original</label>';
                html += '<div style="padding:0.5rem;background:var(--bg-secondary);border-radius:0.375rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;word-break:break-all;">' + escapeHtml(response.originalMessage) + '</div></div>';
            }

            html += '<label class="tool-label">Result</label>';
            html += '<textarea id="resultText" readonly style="width:100%;min-height:100px;padding:0.625rem;border:2px solid var(--border);border-radius:0.5rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;background:var(--bg-secondary);color:var(--text-primary);resize:vertical;">' + escapeHtml(result) + '</textarea>';
            html += '</div></div>';

            $('#output').html(html);
            $('#resultActions').addClass('visible');
            $('#useForVerify').hide();
            $('#swapResult').show();

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast(isEncrypt ? 'Encrypted!' : 'Decrypted!', 2000, 'success');
            }
        }

        function renderSignOutput(response) {
            // Sign result: the server returns base64Encoded or message with the signature
            var signature = response.base64Encoded || response.message || '';

            var html = '<div class="rsa-result-success">';
            html += '<div class="rsa-result-success-header">&#9989; Signed Successfully</div>';
            html += '<div class="rsa-result-body">';
            html += '<div class="rsa-result-meta"><div><strong>Operation:</strong> SIGN</div><div><strong>Algorithm:</strong> ' + escapeHtml(response.algorithm || $('#cipherSelect').val()) + '</div></div>';

            if (response.originalMessage) {
                html += '<div style="margin-bottom:0.75rem;"><label class="tool-label">Original Message</label>';
                html += '<div style="padding:0.5rem;background:var(--bg-secondary);border-radius:0.375rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;word-break:break-all;">' + escapeHtml(response.originalMessage) + '</div></div>';
            }

            html += '<label class="tool-label">Signature (Base64)</label>';
            html += '<textarea id="resultText" readonly style="width:100%;min-height:100px;padding:0.625rem;border:2px solid var(--border);border-radius:0.5rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;background:var(--bg-secondary);color:var(--text-primary);resize:vertical;">' + escapeHtml(signature) + '</textarea>';
            html += '</div></div>';

            $('#output').html(html);
            $('#resultActions').addClass('visible');
            $('#useForVerify').show();
            $('#swapResult').hide();

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('Message signed!', 2000, 'success');
            }
        }

        function renderVerifyOutput(response) {
            // Servlet sets message="VALID"/"INVALID" — use that as the authoritative signal
            // base64Encoded holds the raw API text (e.g. "Signature Verification Passed")
            var isValid = response.message === 'VALID';
            var resultText = response.base64Encoded || response.message || '';

            var html;
            if (isValid) {
                html = '<div class="rsa-result-valid">';
                html += '<div class="rsa-result-valid-header">&#9989; Signature Valid</div>';
            } else {
                html = '<div class="rsa-result-invalid">';
                html += '<div class="rsa-result-invalid-header">&#10060; Signature Invalid</div>';
            }
            html += '<div class="rsa-result-body">';
            html += '<div class="rsa-result-meta"><div><strong>Operation:</strong> VERIFY</div><div><strong>Algorithm:</strong> ' + escapeHtml(response.algorithm || $('#cipherSelect').val()) + '</div></div>';
            html += '<div style="margin-top:0.5rem;font-size:0.8125rem;color:var(--text-secondary);">' + escapeHtml(resultText) + '</div>';
            html += '</div></div>';

            $('#output').html(html);
            $('#resultActions').addClass('visible');
            $('#useForVerify').hide();
            $('#swapResult').hide();

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast(isValid ? 'Signature verified!' : 'Signature invalid!', 2000, isValid ? 'success' : 'error');
            }
        }

        function renderErrorOutput(response, mode) {
            var errMsg = response.errorMessage || 'Unknown error';
            var shortMsg = errMsg.length > 120 ? errMsg.substring(0, 120) + '...' : errMsg;
            var modeLabels = { encrypt: 'Encryption', decrypt: 'Decryption', sign: 'Signing', verify: 'Verification' };
            var opLabel = modeLabels[mode] || (response.operation ? response.operation.charAt(0).toUpperCase() + response.operation.slice(1) : '');

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

            // Toggle encrypt/decrypt
            $('.rsa-op-btn').removeClass('active');
            if (lastResponse && lastResponse.operation === 'encrypt') {
                $('input[name="op_mode"][value="decrypt"]').prop('checked', true);
                $('.rsa-op-btn[data-op="decrypt"]').addClass('active');
            } else {
                $('input[name="op_mode"][value="encrypt"]').prop('checked', true);
                $('.rsa-op-btn[data-op="encrypt"]').addClass('active');
            }
            syncOperationUI();

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('Result swapped to input!', 2000, 'info');
            }
        });

        // ========== USE FOR VERIFY ==========
        $('#useForVerify').on('click', function() {
            var signature = $('#resultText').val();
            if (!signature) return;

            // Switch to verify mode
            $('.rsa-op-btn').removeClass('active');
            $('input[name="op_mode"][value="verify"]').prop('checked', true);
            $('.rsa-op-btn[data-op="verify"]').addClass('active');
            syncOperationUI();

            // Populate signature field with the sign result
            $('#signatureInput').val(signature);

            // Keep the original message (it's already in the message field)

            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showToast('Switched to Verify mode - signature populated!', 3000, 'info');
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
                op: lastResponse && lastResponse.operation === 'encrypt' ? 'decrypt' : 'encrypt',
                algo: lastResponse ? lastResponse.algorithm : ''
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
                $('input[name="op_mode"][value="decrypt"]').prop('checked', true);
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

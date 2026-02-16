<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">

    <!-- Critical CSS -->
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root,:root[data-theme="light"]{--primary:#6366f1;--primary-dark:#4f46e5;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="SSH Key Generator Online - ED25519, RSA for GitHub, GitLab, AWS" />
        <jsp:param name="toolDescription" value="Free SSH key generator for GitHub, GitLab, AWS, Azure. Browser-based, works on Windows Mac Linux. ED25519 or RSA. No signup, client-side. Download .pem/.pub." />
        <jsp:param name="toolCategory" value="Security & PKI" />
        <jsp:param name="toolUrl" value="sshfunctions.jsp" />
        <jsp:param name="toolKeywords" value="ssh key generator online, generate ssh key github, ssh key gitlab, ssh key aws, ed25519 ssh key, rsa 2048 4096, create ssh key windows mac, openssh key generator, ssh-keygen online, ssh fingerprint, putty key generator, ssh key download, id_ed25519 id_rsa, authorized_keys" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="ED25519 RSA ECDSA DSA,Use for GitHub GitLab AWS Azure,Download .pem and .pub files,Browser-based client-side no signup,Works on Windows Mac Linux,Bash executor with ssh-keygen,Fingerprint display,Copy and email keys,OpenSSH format,No data stored" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What is the most secure SSH key algorithm?" />
        <jsp:param name="faq1a" value="ED25519 is recommended for new SSH keys. It offers 128-bit security (equivalent to RSA 3072-bit), faster operations, smaller key sizes, and resistance to timing attacks. RSA 4096-bit is a solid alternative for compatibility." />
        <jsp:param name="faq2q" value="Should I use a passphrase for my SSH key?" />
        <jsp:param name="faq2a" value="Yes. A passphrase adds an extra layer of encryption to your private key. Use ssh-agent to avoid typing it repeatedly during active sessions." />
        <jsp:param name="faq3q" value="How do I copy my SSH public key to a server?" />
        <jsp:param name="faq3a" value="Use ssh-copy-id: ssh-copy-id -i ~/.ssh/id_ed25519.pub user@hostname. Or manually append your public key to ~/.ssh/authorized_keys on the server." />
        <jsp:param name="faq4q" value="What is an SSH key fingerprint?" />
        <jsp:param name="faq4a" value="The fingerprint is a short hash (e.g. SHA256:...) of your public key. Use ssh-keygen -lf ~/.ssh/id_ed25519.pub to display it. Verify fingerprints when connecting to new servers." />
        <jsp:param name="faq5q" value="How do I download my SSH keys?" />
        <jsp:param name="faq5a" value="After generating keys, click 'Download .pem' for the private key or 'Download .pub' for the public key. Files are saved with algorithm-specific names (id_ed25519, id_rsa, etc.)." />
        <jsp:param name="faq6q" value="How do I add my SSH key to GitHub?" />
        <jsp:param name="faq6a" value="Generate your key above, then copy the public key. In GitHub: Settings → SSH and GPG keys → New SSH key → paste the key and save. Use the same key for GitLab, Bitbucket, and SSH servers." />
    </jsp:include>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
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

    <!-- Tool-specific styles -->
    <style>
        :root{--tool-primary:#059669;--tool-primary-dark:#047857;--tool-gradient:linear-gradient(135deg,#059669 0%,#047857 100%);--tool-light:#ecfdf5}
        [data-theme="dark"]{--tool-gradient:linear-gradient(135deg,#10b981 0%,#059669 100%);--tool-light:rgba(5,150,105,0.15)}
        .ssh-algo-grid{display:grid;grid-template-columns:1fr 1fr;gap:0.5rem}
        .ssh-algo-btn{display:flex;flex-direction:column;align-items:center;gap:0.25rem;padding:0.75rem;border:2px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);cursor:pointer;transition:all .15s;font-family:var(--font-sans);text-align:center}
        .ssh-algo-btn:hover{border-color:var(--tool-primary);box-shadow:0 2px 8px rgba(5,150,105,0.2)}
        .ssh-algo-btn.active{border-color:var(--tool-primary);background:var(--tool-light);box-shadow:0 2px 8px rgba(5,150,105,0.25)}
        .ssh-algo-btn input{position:absolute;opacity:0;pointer-events:none}
        .ssh-keysize-group{display:flex;flex-wrap:wrap;gap:0.25rem}
        .ssh-keysize-btn{padding:0.375rem 0.625rem;border:1.5px solid var(--border);border-radius:0.375rem;background:var(--bg-secondary);font-size:0.75rem;font-weight:600;cursor:pointer;font-family:var(--font-sans);transition:all .15s}
        .ssh-keysize-btn.active{background:var(--tool-gradient);color:#fff;border-color:transparent}
        .ssh-keysize-btn:hover:not(.active){border-color:var(--tool-primary);color:var(--tool-primary)}
        .rsa-output-tabs{display:flex;gap:0;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden;margin-bottom:0.75rem}
        .rsa-output-tab{flex:1;padding:0.5rem;font-weight:600;font-size:0.8125rem;border:none;cursor:pointer;background:var(--bg-secondary);color:var(--text-secondary);transition:all .15s;font-family:var(--font-sans);text-align:center}
        .rsa-output-tab.active{background:var(--tool-gradient);color:#fff}
        .rsa-output-tab:hover:not(.active){background:var(--bg-tertiary)}
        [data-theme="dark"] .rsa-output-tab{background:var(--bg-tertiary)}
        [data-theme="dark"] .rsa-output-tab.active{background:var(--tool-gradient);color:#fff}
        .rsa-panel{display:none;flex:1;min-height:0}.rsa-panel.active{display:flex;flex-direction:column}
        .terminal-block{background:#1e1e1e;border-radius:0.5rem;overflow:hidden;margin-bottom:0.75rem}
        .terminal-header{background:#323232;color:#d4d4d4;padding:0.5rem 0.75rem;font-size:0.75rem;display:flex;justify-content:space-between;align-items:center}
        .terminal-body{padding:0.75rem;color:#4ec9b0;font-family:var(--font-mono);font-size:0.8rem;overflow-x:auto;white-space:pre;line-height:1.6;max-height:320px}
        .copy-cmd-btn{background:none;border:1px solid rgba(255,255,255,0.2);color:#d4d4d4;padding:0.2rem 0.5rem;border-radius:0.25rem;cursor:pointer;font-size:0.7rem;transition:all .15s}
        .copy-cmd-btn:hover{background:rgba(255,255,255,0.1)}
        .ssh-cli-tabs{display:flex;gap:0;border-bottom:2px solid #323232;background:#2d2d2d;border-radius:0.5rem 0.5rem 0 0;overflow-x:auto;flex-wrap:wrap}
        .ssh-cli-tab{padding:0.5rem 1rem;font-size:0.75rem;font-weight:600;color:#9ca3af;border:none;background:none;cursor:pointer;white-space:nowrap;font-family:var(--font-sans)}
        .ssh-cli-tab:hover{color:#d4d4d4}
        .ssh-cli-tab.active{color:#4ec9b0}
        .ssh-cli-tab.active::after{content:'';display:block;height:2px;background:#4ec9b0;margin-top:0.25rem}
        .ssh-cli-panel{display:none}.ssh-cli-panel.active{display:block}
        @keyframes spin{to{transform:rotate(360deg)}}
        .ssh-cli-panel .terminal-block{border-radius:0 0 0.5rem 0.5rem}
        .tool-doc-link{color:var(--tool-primary);font-weight:500;text-decoration:none;white-space:nowrap}
        .tool-doc-link:hover{text-decoration:underline}

        /* Description: text on top, dedicated ad placement below (desktop) */
        .tool-description-stacked .tool-description-inner{flex-direction:column;align-items:stretch;gap:0}
        .tool-description-stacked .tool-description-content{flex:none}
        .tool-description-stacked .tool-description-ad-below{display:flex;justify-content:center;margin-top:1rem;min-height:90px;width:100%}
        .tool-description-stacked .tool-description-ad-below .ad-container{margin:0 auto;min-height:90px;width:100%;max-width:728px;background:linear-gradient(135deg,var(--bg-secondary,#f1f5f9) 0%,var(--border,#e2e8f0) 100%)}
        .tool-description-stacked .tool-description-ad-below .ad-container.ad-loaded{background:var(--bg-primary,#fff)}
        @media(max-width:1023px){.tool-description-stacked .tool-description-ad-below{display:none}}

        /* SSH Documentation section – minimal CSS + subtle animations */
        .ssh-doc-section{max-width:900px;margin:0 auto;padding:2rem 1.5rem;background:var(--bg-primary)}
        .ssh-doc-inner{border:1px solid var(--border);border-radius:0.75rem;padding:1.5rem;background:var(--bg-secondary)}
        .ssh-doc-title{font-size:1.25rem;font-weight:700;color:var(--text-primary);margin:0 0 1.25rem;padding-bottom:0.75rem;border-bottom:1px solid var(--border)}
        .ssh-howto-steps{display:flex;flex-direction:column;gap:0.5rem;margin-bottom:0}
        .ssh-howto-step{display:flex;align-items:center;gap:0.75rem;font-size:0.9375rem;color:var(--text-secondary)}
        .ssh-howto-num{display:inline-flex;align-items:center;justify-content:center;width:1.5rem;height:1.5rem;border-radius:50%;background:var(--tool-gradient);color:#fff;font-weight:700;font-size:0.75rem;flex-shrink:0}
        .ssh-platform-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:0.75rem;margin-top:0.5rem}
        .ssh-platform-card{padding:0.75rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);font-size:0.8125rem;line-height:1.5;color:var(--text-secondary)}
        .ssh-platform-card strong{color:var(--tool-primary);display:block;margin-bottom:0.25rem}
        .ssh-doc-subtitle{font-size:1rem;font-weight:600;color:var(--text-primary);margin:1.5rem 0 0.75rem}
        .ssh-doc-accordion{border:1px solid var(--border);border-radius:0.5rem;margin-bottom:0.5rem;overflow:hidden;transition:border-color .2s}
        .ssh-doc-accordion:last-of-type{margin-bottom:0}
        .ssh-doc-accordion:hover{border-color:var(--tool-primary)}
        .ssh-doc-trigger{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 1rem;background:var(--bg-primary);border:none;cursor:pointer;font-family:inherit;font-size:0.9375rem;font-weight:600;color:var(--text-primary);text-align:left;transition:background .2s}
        .ssh-doc-trigger:hover{background:var(--bg-tertiary)}
        .ssh-doc-trigger[aria-expanded="true"]{background:var(--tool-light)}
        .ssh-doc-chevron{display:inline-block;width:0.5rem;height:0.5rem;border-right:2px solid var(--text-secondary);border-bottom:2px solid var(--text-secondary);transform:rotate(45deg);margin-left:0.5rem;transition:transform .25s ease}
        .ssh-doc-trigger[aria-expanded="true"] .ssh-doc-chevron{transform:rotate(-135deg)}
        .ssh-doc-panel{display:grid;grid-template-rows:0fr;transition:grid-template-rows .3s ease}
        .ssh-doc-panel.open{grid-template-rows:1fr}
        .ssh-doc-panel > *{overflow:hidden}
        .ssh-doc-panel > div{padding:0 1rem 1rem;min-height:0}
        .ssh-doc-panel p{margin:0 0 0.75rem;font-size:0.875rem;line-height:1.6;color:var(--text-secondary)}
        .ssh-doc-panel p:last-child{margin-bottom:0}
        .ssh-doc-list{margin:0 0 0.75rem;padding-left:1.25rem;font-size:0.875rem;line-height:1.7;color:var(--text-secondary)}
        .ssh-doc-list li{margin-bottom:0.35rem}
        .ssh-doc-code{background:#1e293b;color:#e2e8f0;padding:0.875rem 1rem;border-radius:0.5rem;font-family:var(--font-mono,'monospace');font-size:0.75rem;overflow-x:auto;margin:0 0 0.75rem;line-height:1.5}
        [data-theme="dark"] .ssh-doc-code{background:#0f172a;color:#cbd5e1}
        .ssh-faq-list{display:flex;flex-direction:column;gap:1rem;margin-top:0.5rem}
        .ssh-faq-item{animation:ssh-fade-in .4s ease;padding:1rem;border:1px solid var(--border);border-radius:0.5rem;background:var(--bg-primary)}
        .ssh-faq-item:nth-child(1){animation-delay:0}
        .ssh-faq-item:nth-child(2){animation-delay:.05s}
        .ssh-faq-item:nth-child(3){animation-delay:.1s}
        .ssh-faq-item:nth-child(4){animation-delay:.15s}
        .ssh-faq-item:nth-child(5){animation-delay:.2s}
        .ssh-faq-item:nth-child(6){animation-delay:.25s}
        @keyframes ssh-fade-in{from{opacity:0;transform:translateY(4px)}to{opacity:1;transform:translateY(0)}}
        @media(prefers-reduced-motion:reduce){.ssh-faq-item{animation:none}}
        .ssh-faq-q{font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.5rem}
        .ssh-faq-a{font-size:0.8125rem;line-height:1.6;color:var(--text-secondary);margin:0}
        [data-theme="dark"] .ssh-doc-inner{background:var(--bg-tertiary)}
        [data-theme="dark"] .ssh-doc-trigger{background:var(--bg-secondary)}
        [data-theme="dark"] .ssh-doc-trigger:hover{background:var(--bg-primary)}
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header -->
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">SSH Key Generator</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#security">Security & PKI</a> /
                    <span>SSH Keygen</span>
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Free</span>
                <span class="tool-badge">ED25519</span>
                <span class="tool-badge">GitHub</span>
                <span class="tool-badge">GitLab</span>
                <span class="tool-badge">AWS</span>
                <span class="tool-badge">Azure</span>
                <span class="tool-badge">No Login</span>
            </div>
        </div>
    </header>

    <!-- Description + Ad (text on top, dedicated ad placement below for desktop) -->
    <section class="tool-description-section tool-description-stacked">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Generate SSH key pairs for <strong>GitHub</strong>, <strong>GitLab</strong>, <strong>AWS</strong>, <strong>Azure</strong>. Works on Windows, Mac, Linux. ED25519 (recommended) or RSA 2048/4096. <strong>Browser-based, client-side</strong>—no signup, no data stored. Download .pem/.pub, copy, email, or run ssh-keygen in the Bash tab. <a href="#ssh-documentation" class="tool-doc-link">How to generate SSH key →</a></p>
            </div>
            <div class="tool-description-ad-below">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <main class="tool-page-container">
        <!-- INPUT COLUMN -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg>
                    SSH Key Configuration
                </div>
                <div class="tool-card-body">
                    <form id="form" method="POST">
                        <input type="hidden" name="methodName" value="GENERATE_SSHKEYGEN">
                        <input type="hidden" name="j_csrf" value="<%=request.getSession().getId()%>">
                        <input type="hidden" id="email" name="email" value="">

                        <!-- Algorithm -->
                        <div class="tool-form-group">
                            <label class="tool-form-label">Algorithm</label>
                            <div class="ssh-algo-grid">
                                <label class="ssh-algo-btn active" id="algo-ed25519">
                                    <input type="radio" name="sshalgo" value="ED25519" checked>
                                    <span style="font-size:1.25rem;">🛡</span>
                                    <span class="font-weight-bold">ED25519</span>
                                    <span class="badge" style="font-size:0.6rem;background:var(--tool-primary);color:#fff;">Best</span>
                                </label>
                                <label class="ssh-algo-btn" id="algo-rsa">
                                    <input type="radio" name="sshalgo" value="RSA">
                                    <span style="font-size:1.25rem;">🔐</span>
                                    <span class="font-weight-bold">RSA</span>
                                    <span class="badge" style="font-size:0.6rem;background:#64748b;color:#fff;">Common</span>
                                </label>
                                <label class="ssh-algo-btn" id="algo-ecdsa">
                                    <input type="radio" name="sshalgo" value="ECDSA">
                                    <span style="font-size:1.25rem;">📈</span>
                                    <span class="font-weight-bold">ECDSA</span>
                                    <span class="badge" style="font-size:0.6rem;background:#3b82f6;color:#fff;">EC</span>
                                </label>
                                <label class="ssh-algo-btn" id="algo-dsa">
                                    <input type="radio" name="sshalgo" value="DSA">
                                    <span style="font-size:1.25rem;">⚠</span>
                                    <span class="font-weight-bold">DSA</span>
                                    <span class="badge" style="font-size:0.6rem;background:#f59e0b;color:#fff;">Deprecated</span>
                                </label>
                            </div>
                        </div>

                        <!-- Key Size (algorithm-specific) -->
                        <div class="tool-form-group">
                            <label class="tool-form-label">Key Size</label>
                            <input type="hidden" name="sshkeysize" id="sshkeysize" value="256">
                            <div id="ed25519keysize">
                                <div style="padding:0.5rem;background:var(--tool-light);border-radius:0.5rem;font-size:0.8125rem;">Fixed 256-bit (≈ RSA 3072)</div>
                            </div>
                            <div id="rsakeysize" style="display:none;">
                                <div class="ssh-keysize-group">
                                    <label class="ssh-keysize-btn" data-size="1024">1024 <span style="color:#ef4444;font-size:0.65rem;">Weak</span></label>
                                    <label class="ssh-keysize-btn active" data-size="2048">2048</label>
                                    <label class="ssh-keysize-btn" data-size="4096">4096</label>
                                </div>
                            </div>
                            <div id="ecdsakeysize" style="display:none;">
                                <div class="ssh-keysize-group">
                                    <label class="ssh-keysize-btn active" data-size="256">P-256</label>
                                    <label class="ssh-keysize-btn" data-size="384">P-384</label>
                                    <label class="ssh-keysize-btn" data-size="521">P-521</label>
                                </div>
                            </div>
                            <div id="dsakeysize" style="display:none;">
                                <div style="font-size:0.75rem;color:#f59e0b;margin-bottom:0.25rem;">DSA is deprecated</div>
                                <div class="ssh-keysize-group">
                                    <label class="ssh-keysize-btn" data-size="512">512</label>
                                    <label class="ssh-keysize-btn active" data-size="1024">1024</label>
                                    <label class="ssh-keysize-btn" data-size="2048">2048</label>
                                </div>
                            </div>
                        </div>

                        <!-- Passphrase -->
                        <div class="tool-form-group">
                            <label class="tool-form-label" for="passphrase">Passphrase (optional)</label>
                            <input class="tool-input" type="password" id="passphrase" name="passphrase" placeholder="Encrypts private key">
                        </div>

                        <!-- Actions -->
                        <div class="tool-form-group">
                            <button type="button" class="tool-action-btn" id="generatessh-keys">Generate SSH Keys</button>
                            <button type="button" class="tool-action-btn" style="background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);margin-top:0.5rem;" id="genkeypairemail">Email Keys</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- OUTPUT COLUMN -->
        <div class="tool-output-column">
            <div class="rsa-output-tabs">
                <button type="button" class="rsa-output-tab active" data-panel="keys">Keys</button>
                <button type="button" class="rsa-output-tab" data-panel="cli">ssh-keygen &amp; test</button>
            </div>

            <!-- Keys Panel -->
            <div class="rsa-panel active" id="panel-keys">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;color:var(--tool-primary);"><path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/></svg>
                        <h4>Generated Keys</h4>
                        <div class="tool-live-indicator" style="margin-left:auto;"><span class="tool-live-dot"></span> Ready</div>
                    </div>
                    <div class="tool-result-content" id="output">
                        <div class="tool-empty-state" id="emptyState">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="width:48px;height:48px;opacity:0.4;margin-bottom:0.5rem;">
                                <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"/>
                            </svg>
                            <h3>Your SSH keys will appear here</h3>
                            <p>Select algorithm, key size, and click "Generate SSH Keys"</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bash Executor Panel (ssh-keygen & test - runs in container) -->
            <div class="rsa-panel" id="panel-cli">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;color:var(--tool-primary);"><path d="M4 17l6-6-6-6M12 19h8"/></svg>
                        <h4>Bash Executor</h4>
                        <select id="sshCliTemplate" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                            <option value="ed25519">ED25519</option>
                            <option value="rsa">RSA</option>
                            <option value="ecdsa">ECDSA</option>
                            <option value="convert">Convert</option>
                            <option value="deploy">Deploy</option>
                            <option value="test">test &amp; ssh</option>
                        </select>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="sshCliIframe" loading="lazy" style="width:100%;height:100%;min-height:420px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ADS COLUMN -->
        <aside class="tool-ads-column">
            <%@ include file="modern/ads/ad-three-column.jsp" %>
        </aside>
    </main>

    <!-- Email Modal -->
    <div class="modal-overlay" id="emailModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:1050;align-items:center;justify-content:center;">
        <div class="tool-card" style="max-width:400px;margin:1rem;">
            <div class="tool-card-header" style="display:flex;justify-content:space-between;align-items:center;">
                <span>Email SSH Keys</span>
                <button type="button" onclick="closeEmailModal()" style="background:none;border:none;color:inherit;font-size:1.25rem;cursor:pointer;">&times;</button>
            </div>
            <div class="tool-card-body">
                <p style="font-size:0.8125rem;color:var(--text-secondary);margin-bottom:1rem;">Keys will be emailed securely. Keep your private key secret.</p>
                <label class="tool-form-label">Email Address</label>
                <input type="email" class="tool-input" id="emailInput" placeholder="your@email.com">
                <div id="emailError" style="color:#ef4444;font-size:0.75rem;margin-top:0.25rem;display:none;">Please enter a valid email.</div>
                <div style="display:flex;gap:0.5rem;margin-top:1rem;">
                    <button type="button" class="tool-action-btn" id="sendEmailBtn">Send Keys</button>
                    <button type="button" onclick="closeEmailModal()" style="padding:0.5rem 1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.5rem;cursor:pointer;">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Mobile Ad -->
    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <!-- SSH Documentation + FAQs -->
    <section class="ssh-doc-section" id="ssh-documentation">
        <div class="ssh-doc-inner">
            <h2 class="ssh-doc-title">How to Generate an SSH Key</h2>
            <div class="ssh-howto-steps">
                <div class="ssh-howto-step"><span class="ssh-howto-num">1</span> Select algorithm (ED25519 or RSA) and key size above</div>
                <div class="ssh-howto-step"><span class="ssh-howto-num">2</span> Click <strong>Generate SSH Keys</strong></div>
                <div class="ssh-howto-step"><span class="ssh-howto-num">3</span> Copy your public key or download .pem/.pub files</div>
                <div class="ssh-howto-step"><span class="ssh-howto-num">4</span> Add public key to GitHub, GitLab, AWS, or <code>~/.ssh/authorized_keys</code></div>
            </div>

            <!-- Use for GitHub, GitLab, AWS -->
            <h3 class="ssh-doc-subtitle" style="margin-top:1.5rem;">Use for GitHub, GitLab, AWS, Azure</h3>
            <div class="ssh-platform-grid">
                <div class="ssh-platform-card">
                    <strong>GitHub</strong> – Settings → SSH and GPG keys → New SSH key → paste public key
                </div>
                <div class="ssh-platform-card">
                    <strong>GitLab</strong> – Preferences → SSH Keys → paste public key
                </div>
                <div class="ssh-platform-card">
                    <strong>AWS EC2</strong> – Paste public key when creating a key pair, or import to existing instance
                </div>
                <div class="ssh-platform-card">
                    <strong>Azure</strong> – Use public key when creating Linux VM, or add to ~/.ssh/authorized_keys
                </div>
            </div>

            <h3 class="ssh-doc-subtitle">Documentation</h3>
            <!-- Accordion: Documentation -->
            <div class="ssh-doc-accordion">
                <button class="ssh-doc-trigger" type="button" aria-expanded="false" aria-controls="doc-what" id="doc-what-btn">
                    <span>What is SSH?</span>
                    <span class="ssh-doc-chevron" aria-hidden="true"></span>
                </button>
                <div class="ssh-doc-panel" id="doc-what" role="region" aria-labelledby="doc-what-btn">
                    <div><p><strong>SSH</strong> (Secure Shell) is a cryptographic network protocol for secure remote login, command execution, and file transfer. SSH keys replace passwords with asymmetric key pairs: a <em>private key</em> (kept secret) and a <em>public key</em> (shared with servers).</p>
                    <p>When you connect, the server verifies your identity using the public key. The private key never leaves your machine (or this tool’s secure generation flow).</p>
                </div>
            </div>

            <div class="ssh-doc-accordion">
                <button class="ssh-doc-trigger" type="button" aria-expanded="false" aria-controls="doc-algos" id="doc-algos-btn">
                    <span>Key Algorithms: ED25519, RSA, ECDSA, DSA</span>
                    <span class="ssh-doc-chevron" aria-hidden="true"></span>
                </button>
                <div class="ssh-doc-panel" id="doc-algos" role="region" aria-labelledby="doc-algos-btn">
                    <div><ul class="ssh-doc-list">
                        <li><strong>ED25519</strong> (recommended) – 256-bit elliptic curve. Fast, small, secure. Use for new keys.</li>
                        <li><strong>RSA</strong> – 1024/2048/4096-bit. Widely supported; prefer 2048+ bits. 4096 for higher security.</li>
                        <li><strong>ECDSA</strong> – P-256, P-384, P-521. Good balance of size and security.</li>
                        <li><strong>DSA</strong> – Deprecated. Avoid for new keys.</li>
                    </ul></div>
                </div>
            </div>

            <div class="ssh-doc-accordion">
                <button class="ssh-doc-trigger" type="button" aria-expanded="false" aria-controls="doc-keygen" id="doc-keygen-btn">
                    <span>Using ssh-keygen (command line)</span>
                    <span class="ssh-doc-chevron" aria-hidden="true"></span>
                </button>
                <div class="ssh-doc-panel" id="doc-keygen" role="region" aria-labelledby="doc-keygen-btn">
                    <div><pre class="ssh-doc-code"># ED25519 (recommended)
ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_ed25519 -N ""

# RSA 4096
ssh-keygen -t rsa -b 4096 -C "your@email.com" -f ~/.ssh/id_rsa -N ""

# Display fingerprint
ssh-keygen -lf ~/.ssh/id_ed25519.pub</pre>
                    <p>Use the <strong>ssh-keygen &amp; test</strong> tab above to run these in the browser.</p></div>
                </div>
            </div>

            <div class="ssh-doc-accordion">
                <button class="ssh-doc-trigger" type="button" aria-expanded="false" aria-controls="doc-example" id="doc-example-btn">
                    <span>Example: Full private key and public key content</span>
                    <span class="ssh-doc-chevron" aria-hidden="true"></span>
                </button>
                <div class="ssh-doc-panel" id="doc-example" role="region" aria-labelledby="doc-example-btn">
                    <div><p><strong>ED25519 public key</strong> (single line, share this):</p>
                    <pre class="ssh-doc-code">ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGW7zkzy1o3jU8+7VqQK8xXj3H5n2pL8qR9sT0uV1wX your@email.com</pre>
                    <p><strong>ED25519 private key</strong> (keep secret, multi-line OpenSSH format):</p>
                    <pre class="ssh-doc-code">-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBlu89M8taN41PPu1akCvMV49x+Z9qS/KkfbE9LldcF1wAAAJgdmB2YHZgd
AAAAC2VkMjU1MTktc2hrAAAAIGW7zkzy1o3jU8+7VqQK8xXj3H5n2pL8qR9sT0uV1wXAAAA
EGW7zkzy1o3jU8+7VqQK8xXj3H5n2pL8qR9sT0uV1wXAAAAAAAAAAECAQAAAAEAAAAGAAAA
C2VkMjU1MTktc2hrAAAAIGW7zkzy1o3jU8+7VqQK8xXj3H5n2pL8qR9sT0uV1wXAAAADAAA
AAIAAAAcAAAAAQAAAAtzc2gtZWQyNTUxOQAAACBlu89M8taN41PPu1akCvMV49x+Z9qS/Kk
fbE9LldcF1wUAAAAgZbvPTPLWjeNTz7tWpArzFePcfmfakvypH2xPS5XXBdcFAAAAFHVzZX
JAZXhhbXBsZS5jb20BAAAAAA==
-----END OPENSSH PRIVATE KEY-----</pre>
                    <p><strong>RSA 2048 public key</strong> (single line):</p>
                    <pre class="ssh-doc-code">ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD...longerBase64...== your@email.com</pre>
                    <p><strong>RSA private key</strong> (PEM format, typically 27+ lines for 2048-bit):</p>
                    <pre class="ssh-doc-code">-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcnNh
AAAAAwEAAQAAAYEA3...base64 continues for many lines...
-----END OPENSSH PRIVATE KEY-----</pre>
                    <p>Generate your own keys above to see real output. Never share your private key.</p></div>
                </div>
            </div>

            <div class="ssh-doc-accordion">
                <button class="ssh-doc-trigger" type="button" aria-expanded="false" aria-controls="doc-deploy" id="doc-deploy-btn">
                    <span>Deploying keys: ssh-copy-id and authorized_keys</span>
                    <span class="ssh-doc-chevron" aria-hidden="true"></span>
                </button>
                <div class="ssh-doc-panel" id="doc-deploy" role="region" aria-labelledby="doc-deploy-btn">
                    <div><pre class="ssh-doc-code"># Copy public key to server (easiest)
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@hostname

# Or manually: append public key to
~/.ssh/authorized_keys</pre>
                    <p>After deploying, connect with <code>ssh user@hostname</code>. No password required.</p></div>
                </div>
            </div>

            <div class="ssh-doc-accordion">
                <button class="ssh-doc-trigger" type="button" aria-expanded="false" aria-controls="doc-security" id="doc-security-btn">
                    <span>Security best practices</span>
                    <span class="ssh-doc-chevron" aria-hidden="true"></span>
                </button>
                <div class="ssh-doc-panel" id="doc-security" role="region" aria-labelledby="doc-security-btn">
                    <div><ul class="ssh-doc-list">
                        <li>Never share your private key. Only share the public key.</li>
                        <li>Use a passphrase for the private key and rely on <code>ssh-agent</code> during sessions.</li>
                        <li>Verify server fingerprints on first connection to avoid MITM attacks.</li>
                        <li>Prefer ED25519 or RSA 2048+ for new keys.</li>
                        <li>Store private keys with restricted permissions: <code>chmod 600 ~/.ssh/id_*</code>.</li>
                    </ul></div>
                </div>
            </div>

            <!-- Visible FAQs (mirrors JSON-LD for SEO) -->
            <h3 class="ssh-doc-subtitle">Frequently Asked Questions</h3>
            <div class="ssh-faq-list">
                <div class="ssh-faq-item">
                    <h4 class="ssh-faq-q">What is the most secure SSH key algorithm?</h4>
                    <p class="ssh-faq-a">ED25519 is recommended for new SSH keys. It offers 128-bit security (equivalent to RSA 3072-bit), faster operations, smaller key sizes, and resistance to timing attacks. RSA 4096-bit is a solid alternative for compatibility.</p>
                </div>
                <div class="ssh-faq-item">
                    <h4 class="ssh-faq-q">Should I use a passphrase for my SSH key?</h4>
                    <p class="ssh-faq-a">Yes. A passphrase adds an extra layer of encryption to your private key. Use ssh-agent to avoid typing it repeatedly during active sessions.</p>
                </div>
                <div class="ssh-faq-item">
                    <h4 class="ssh-faq-q">How do I copy my SSH public key to a server?</h4>
                    <p class="ssh-faq-a">Use ssh-copy-id: ssh-copy-id -i ~/.ssh/id_ed25519.pub user@hostname. Or manually append your public key to ~/.ssh/authorized_keys on the server.</p>
                </div>
                <div class="ssh-faq-item">
                    <h4 class="ssh-faq-q">What is an SSH key fingerprint?</h4>
                    <p class="ssh-faq-a">The fingerprint is a short hash (e.g. SHA256:...) of your public key. Use ssh-keygen -lf ~/.ssh/id_ed25519.pub to display it. Verify fingerprints when connecting to new servers.</p>
                </div>
                <div class="ssh-faq-item">
                    <h4 class="ssh-faq-q">How do I download my SSH keys?</h4>
                    <p class="ssh-faq-a">After generating keys, click &quot;Download .pem&quot; for the private key or &quot;Download .pub&quot; for the public key. Files are saved with algorithm-specific names (id_ed25519, id_rsa, etc.).</p>
                </div>
                <div class="ssh-faq-item">
                    <h4 class="ssh-faq-q">How do I add my SSH key to GitHub?</h4>
                    <p class="ssh-faq-a">Generate your key above, then copy the public key. In GitHub: Settings → SSH and GPG keys → New SSH key → paste the key and save. Use the same key for GitLab, Bitbucket, and SSH servers.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="sshfunctions.jsp"/>
        <jsp:param name="category" value="Security & PKI"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- E-E-A-T: Experience, Expertise, Authoritativeness, Trustworthiness -->
    <section class="tool-expertise-section" style="max-width:900px;margin:2rem auto;padding:0 1.5rem;">
        <div class="tool-card" style="padding:2rem;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-secondary);">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">About This SSH Key Tool &amp; Methodology</h2>
            <p style="margin-bottom:1rem;color:var(--text-secondary);line-height:1.7;">This SSH key generator produces OpenSSH-format key pairs using standard algorithms (ED25519, RSA, ECDSA, DSA). Key generation runs on our secure server using industry-standard Java cryptography; the private key is transmitted over HTTPS only when you request it, and we do not log or store any keys. For fully client-side generation, use the <strong>ssh-keygen &amp; test</strong> Bash tab to run <code>ssh-keygen</code> in your browser.</p>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5rem;margin-top:1.5rem;">
                <div>
                    <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary);">Authorship &amp; Expertise</h3>
                    <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7;">
                        <li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary);">Anish Nath</a></li>
                        <li><strong>Background:</strong> Security and PKI tools for developers</li>
                        <li><strong>Standards:</strong> OpenSSH format, RFC 4253, RFC 8709 (Ed25519)</li>
                    </ul>
                </div>
                <div>
                    <h3 style="font-size:1rem;margin-bottom:0.75rem;color:var(--text-primary);">Trust &amp; Privacy</h3>
                    <ul style="margin-left:1rem;color:var(--text-secondary);font-size:0.9rem;line-height:1.7;">
                        <li><strong>Privacy:</strong> Keys are never stored or logged on our servers</li>
                        <li><strong>HTTPS:</strong> All traffic encrypted; keys transmitted only when displayed</li>
                        <li><strong>Support:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener" style="color:var(--tool-primary);">@anish2good</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script>
(function() {
    function $id(id) { return document.getElementById(id); }
    var form = document.getElementById('form');
    var output = $id('output');
    var emptyState = $id('emptyState');

    // Algorithm toggle - show/hide key size sections
    function setKeysize(val) {
        var inp = $id('sshkeysize');
        if (inp) inp.value = String(val);
    }

    function showKeysize(which) {
        ['ed25519keysize','rsakeysize','ecdsakeysize','dsakeysize'].forEach(function(id) {
            $id(id).style.display = (id === which) ? 'block' : 'none';
        });
        if (which === 'ed25519keysize') setKeysize(256);
        else if (which === 'rsakeysize') setKeysize(2048);
        else if (which === 'ecdsakeysize') setKeysize(256);
        else if (which === 'dsakeysize') setKeysize(1024);
    }

    document.querySelectorAll('input[name="sshalgo"]').forEach(function(r) {
        r.addEventListener('change', function() {
            document.querySelectorAll('.ssh-algo-btn').forEach(function(b) { b.classList.remove('active'); });
            r.closest('.ssh-algo-btn').classList.add('active');
            var v = r.value;
            if (v === 'ED25519') showKeysize('ed25519keysize');
            else if (v === 'RSA') showKeysize('rsakeysize');
            else if (v === 'ECDSA') showKeysize('ecdsakeysize');
            else if (v === 'DSA') showKeysize('dsakeysize');
        });
    });

    document.querySelectorAll('.ssh-keysize-btn').forEach(function(lbl) {
        lbl.addEventListener('click', function() {
            var size = this.getAttribute('data-size');
            if (size) {
                setKeysize(size);
                this.parentElement.querySelectorAll('.ssh-keysize-btn').forEach(function(b) { b.classList.remove('active'); });
                this.classList.add('active');
            }
        });
    });

    // Generate keys
    function doSubmit(optEmail) {
        var fd = new FormData(form);
        if (optEmail) fd.set('email', $id('emailInput').value.trim());
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.showLoading('Generating SSH keys...', '#output');
        } else {
            output.innerHTML = '<div style="text-align:center;padding:2rem;">Generating...</div>';
        }
        fetch('<%=request.getContextPath()%>/SSHFunctionality', {
            method: 'POST',
            body: new URLSearchParams(fd)
        }).then(function(r) { return r.json(); }).then(function(data) {
            output.innerHTML = '';
            if (data.success) {
                var algo = data.algorithm || 'SSH';
                var keySize = data.originalMessage || '';
                var fingerprint = data.hexEncoded || '';
                var privateKey = data.base64Encoded || '';
                var publicKey = data.message || '';
                var emailStatus = data.iv || '';
                var baseName = (algo === 'RSA') ? 'id_rsa' : (algo === 'ECDSA') ? 'id_ecdsa' : (algo === 'DSA') ? 'id_dsa' : 'id_ed25519';
                var html = '<div style="padding:0.75rem;background:var(--tool-light);border-radius:0.5rem;margin-bottom:1rem;">';
                html += '<strong>Algorithm:</strong> ' + (typeof ToolUtils !== 'undefined' ? ToolUtils.escapeHtml(algo) : algo) + (keySize ? ' (' + keySize + '-bit)' : '') + '<br>';
                if (fingerprint) html += '<strong>Fingerprint:</strong> <code style="font-size:0.8rem;">' + (typeof ToolUtils !== 'undefined' ? ToolUtils.escapeHtml(fingerprint) : fingerprint) + '</code><br>';
                if (emailStatus) html += '<span style="color:var(--tool-primary);">' + (typeof ToolUtils !== 'undefined' ? ToolUtils.escapeHtml(emailStatus) : emailStatus) + '</span>';
                html += '</div>';
                html += '<div class="tool-form-group"><label class="tool-form-label">Private Key <span style="color:#ef4444;">Keep Secret</span></label>';
                html += '<textarea id="privateKeyOutput" readonly class="tool-input" rows="10" style="font-family:monospace;font-size:0.75rem;"></textarea>';
                html += '<div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem;">';
                html += '<button type="button" class="tool-action-btn" style="padding:0.5rem;" onclick="sshCopyKey(\'privateKeyOutput\',true)">Copy Private Key</button>';
                html += '<button type="button" class="tool-action-btn" style="padding:0.5rem;background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);" onclick="sshDownloadKey(\'privateKeyOutput\',\'' + baseName + '\')">Download .pem</button>';
                html += '</div></div>';
                html += '<div class="tool-form-group"><label class="tool-form-label">Public Key <span style="color:var(--tool-primary);">Share This</span></label>';
                html += '<textarea id="publicKeyOutput" readonly class="tool-input" rows="5" style="font-family:monospace;font-size:0.75rem;"></textarea>';
                html += '<div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem;">';
                html += '<button type="button" class="tool-action-btn" style="padding:0.5rem;" onclick="sshCopyKey(\'publicKeyOutput\',false)">Copy Public Key</button>';
                html += '<button type="button" class="tool-action-btn" style="padding:0.5rem;background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);" onclick="sshDownloadKey(\'publicKeyOutput\',\'' + baseName + '.pub\')">Download .pub</button>';
                html += '<button type="button" class="tool-action-btn" style="padding:0.5rem;background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);" onclick="sshShareKeys()">Share URL</button>';
                html += '</div></div>';
                output.innerHTML = html;
                $id('privateKeyOutput').value = privateKey;
                $id('publicKeyOutput').value = publicKey;
                if (emptyState) emptyState.style.display = 'none';
                if (emailStatus && typeof ToolUtils !== 'undefined') ToolUtils.showToast('Keys sent!', 2000, 'success');
            } else {
                if (typeof ToolUtils !== 'undefined') {
                    ToolUtils.showError(data.errorMessage || 'Error generating keys', '#output');
                } else {
                    output.innerHTML = '<div style="padding:1rem;background:#fef2f2;border:1px solid #fecaca;border-radius:0.5rem;color:#991b1b;">' + (data.errorMessage || 'Error generating keys') + '</div>';
                }
            }
            $id('email').value = '';
        }).catch(function(err) {
            if (typeof ToolUtils !== 'undefined') {
                ToolUtils.showError('Network error. Please try again.', '#output');
            } else {
                output.innerHTML = '<div style="padding:1rem;background:#fef2f2;border:1px solid #fecaca;border-radius:0.5rem;color:#991b1b;">Network error. Please try again.</div>';
            }
        });
    }

    window.sshCopyKey = function(id, isPrivate) {
        var el = $id(id);
        if (!el || !el.value) return;
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.copyToClipboard(el.value, {
                showToast: true,
                toastMessage: 'Copied to clipboard!',
                showSupportPopup: !isPrivate,
                toolName: 'SSH Key Generator'
            });
        } else {
            navigator.clipboard.writeText(el.value);
        }
    };

    window.sshDownloadKey = function(id, filename) {
        var el = $id(id);
        if (!el || !el.value) return;
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.downloadAsFile(el.value, filename, {
                mimeType: filename.indexOf('.pub') >= 0 ? 'text/plain' : 'application/x-pem-file',
                showToast: true,
                toastMessage: 'Downloaded ' + filename,
                showSupportPopup: true,
                toolName: 'SSH Key Generator'
            });
        } else {
            var a = document.createElement('a');
            a.href = 'data:text/plain;charset=utf-8,' + encodeURIComponent(el.value);
            a.download = filename;
            a.click();
        }
    };

    window.sshShareKeys = function() {
        var pub = $id('publicKeyOutput');
        if (!pub || !pub.value) return;
        if (typeof ToolUtils !== 'undefined') {
            ToolUtils.shareResult(pub.value, {
                paramName: 'pubkey',
                copyToClipboard: true,
                showSupportPopup: true,
                toolName: 'SSH Key Generator'
            });
        }
    };

    $id('generatessh-keys').addEventListener('click', function() { doSubmit(false); });
    $id('genkeypairemail').addEventListener('click', function() {
        $id('emailInput').value = '';
        $id('emailError').style.display = 'none';
        $id('emailModal').style.display = 'flex';
    });
    $id('sendEmailBtn').addEventListener('click', function() {
        var email = $id('emailInput').value.trim();
        var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email || !re.test(email)) {
            $id('emailError').style.display = 'block';
            return;
        }
        $id('emailError').style.display = 'none';
        $id('email').value = email;
        $id('sendEmailBtn').disabled = true;
        $id('sendEmailBtn').textContent = 'Sending...';
        doSubmit(true);
        setTimeout(function() {
            $id('emailModal').style.display = 'none';
            $id('sendEmailBtn').disabled = false;
            $id('sendEmailBtn').textContent = 'Send Keys';
        }, 800);
    });
    window.closeEmailModal = function() {
        $id('emailModal').style.display = 'none';
    };

    // Output tabs
    var sshCliLoaded = false;
    document.querySelectorAll('.rsa-output-tab').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.rsa-output-tab').forEach(function(b) { b.classList.remove('active'); });
            document.querySelectorAll('.rsa-panel').forEach(function(p) { p.classList.remove('active'); });
            this.classList.add('active');
            var panel = this.dataset.panel;
            $id('panel-' + panel).classList.add('active');
            if (panel === 'cli' && !sshCliLoaded) {
                loadSshCliCompiler();
                sshCliLoaded = true;
            }
        });
    });

    // Bash templates for executor (runs via OneCompiler / test image)
    function getSshBashTemplate(tpl) {
        var t = {
            ed25519: '# Generate ED25519 key (recommended)\nssh-keygen -t ed25519 -C "your_email@example.com" -f /tmp/id_ed25519 -N ""\n\n# Display fingerprint\nssh-keygen -lf /tmp/id_ed25519.pub\n\n# Show public key\ncat /tmp/id_ed25519.pub',
            rsa: '# Generate RSA 4096-bit key\nssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f /tmp/id_rsa -N ""\n\n# Extract public key\nssh-keygen -y -f /tmp/id_rsa\n\n# Display fingerprint\nssh-keygen -lf /tmp/id_rsa.pub',
            ecdsa: '# Generate ECDSA P-256 key\nssh-keygen -t ecdsa -b 256 -C "your_email@example.com" -f /tmp/id_ecdsa -N ""\n\n# Display fingerprint\nssh-keygen -lf /tmp/id_ecdsa.pub',
            convert: '# Create test key first\nssh-keygen -t rsa -b 2048 -f /tmp/id_rsa -N "" -q\n\n# Show OpenSSH format\nhead -1 /tmp/id_rsa\n\n# Convert to PEM format\nssh-keygen -p -m PEM -f /tmp/id_rsa -N "" -P "" -q\n\n# Extract public key\nssh-keygen -y -f /tmp/id_rsa',
            deploy: '# Simulate: create key and show ssh-copy-id command\nssh-keygen -t ed25519 -f /tmp/id_ed25519 -N "" -q\n\necho "Run this to copy your key to server:"\necho "ssh-copy-id -i /tmp/id_ed25519.pub user@hostname"\n\necho ""\necho "Or manually:"\ncat /tmp/id_ed25519.pub | head -1',
            test: '# test command - check if file exists\ntest -f /tmp/id_ed25519 2>/dev/null && echo "Key exists" || echo "Key not found (run ed25519 template first)"\n\n# Create a key for testing\nssh-keygen -t ed25519 -f /tmp/id_ed25519 -N "" -q\n\ntest -f /tmp/id_ed25519 && echo "Key exists after generation"\n\n# Display fingerprint\nssh-keygen -lf /tmp/id_ed25519.pub 2>/dev/null || true'
        };
        return t[tpl] || t.ed25519;
    }

    function loadSshCliCompiler() {
        var tpl = ($id('sshCliTemplate') && $id('sshCliTemplate').value) || 'ed25519';
        var code = getSshBashTemplate(tpl);
        var b64Code = btoa(unescape(encodeURIComponent(code)));
        var config = JSON.stringify({ lang: 'bash', code: b64Code });
        var iframe = $id('sshCliIframe');
        if (iframe) {
            iframe.src = '<%=request.getContextPath()%>/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
        }
    }

    if ($id('sshCliTemplate')) {
        $id('sshCliTemplate').addEventListener('change', function() {
            sshCliLoaded = false;
            loadSshCliCompiler();
            sshCliLoaded = true;
        });
    }

    showKeysize('ed25519keysize');

    // SSH documentation accordion
    document.querySelectorAll('.ssh-doc-trigger').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var expanded = this.getAttribute('aria-expanded') === 'true';
            var panel = document.getElementById(this.getAttribute('aria-controls'));
            if (panel) {
                this.setAttribute('aria-expanded', !expanded);
                panel.classList.toggle('open', !expanded);
            }
        });
    });

    // Load shared public key from URL (?pubkey=...&enc=base64)
    if (typeof ToolUtils !== 'undefined') {
        var sharedPub = ToolUtils.loadSharedResult('pubkey');
        if (sharedPub) {
            if (emptyState) emptyState.style.display = 'none';
            var html = '<div style="padding:0.75rem;background:var(--tool-light);border-radius:0.5rem;margin-bottom:1rem;">';
            html += '<strong>Shared Public Key</strong> (loaded from URL)';
            html += '</div>';
            html += '<div class="tool-form-group"><label class="tool-form-label">Public Key</label>';
            html += '<textarea id="publicKeyOutput" readonly class="tool-input" rows="5" style="font-family:monospace;font-size:0.75rem;"></textarea>';
            html += '<div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:0.5rem;">';
            html += '<button type="button" class="tool-action-btn" style="padding:0.5rem;" onclick="sshCopyKey(\'publicKeyOutput\',false)">Copy Public Key</button>';
            html += '<button type="button" class="tool-action-btn" style="padding:0.5rem;background:transparent;border:1.5px solid var(--tool-primary);color:var(--tool-primary);" onclick="sshDownloadKey(\'publicKeyOutput\',\'id_ed25519.pub\')">Download .pub</button>';
            html += '</div></div>';
            output.innerHTML = html;
            $id('publicKeyOutput').value = sharedPub;
        }
    }
})();
    </script>
</body>
</html>

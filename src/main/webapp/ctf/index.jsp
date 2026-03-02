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

    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free CTF Challenge Generator - Stego, Crypto & Forensic" />
        <jsp:param name="toolDescription" value="Create CTF challenges instantly: stego, crypto and forensic puzzles with solutions, hints, and SHA-256 flag verification. 100% free, client-side. No signup." />
        <jsp:param name="toolCategory" value="CTF & Challenges" />
        <jsp:param name="toolUrl" value="ctf/index.jsp" />
        <jsp:param name="toolKeywords" value="CTF challenge generator free, capture the flag maker online, create CTF challenges, steganography CTF generator, crypto CTF tool, forensic CTF creator, CTF puzzle generator, CTF flag maker, CTF practice online, CTF training tool free, online CTF builder, CTF competition generator, jeopardy CTF maker, CTF for beginners, cybersecurity CTF tool, CTF with solutions, CTF hints generator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="6 CTF categories: stego crypto forensic web RE OSINT,39+ encoding and cipher steps,11 difficulty levels across generators,6 crypto challenge types,Dynamic pipeline composition,Auto-generated solutions with full pipeline,Progressive solver hints,SHA-256 flag verification,Upload your own cover images,JSON challenge bundle export,100% client-side and free,No signup or registration" />
        <jsp:param name="faq1q" value="What is a CTF challenge generator and who uses it?" />
        <jsp:param name="faq1a" value="A CTF (Capture The Flag) challenge generator creates cybersecurity puzzles where players find hidden flags using steganography, cryptanalysis, or forensic analysis. Used by CTF competition organizers, cybersecurity instructors, university courses, and anyone practicing offensive security skills." />
        <jsp:param name="faq2q" value="Can I use this to create challenges for CTF competitions?" />
        <jsp:param name="faq2a" value="Yes. Each generated challenge includes a downloadable file, complete solution with decryption keys, pipeline details, SHA-256 flag hash for automated verification, and progressive hints you can share with participants. Export everything as a single JSON bundle." />
        <jsp:param name="faq3q" value="Is the CTF generator free and does it require signup?" />
        <jsp:param name="faq3a" value="Completely free with zero signup. All encoding, encryption, steganography embedding, and challenge generation runs 100% in your browser using JavaScript and the Web Crypto API. Nothing is uploaded to any server. Works offline once loaded." />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "CollectionPage",
      "name": "Free CTF Challenge Generator Suite",
      "url": "https://8gwifi.org/ctf/index.jsp",
      "mainEntity": {
        "@type": "ItemList",
        "numberOfItems": 6,
        "itemListElement": [
          {
            "@type": "ListItem",
            "position": 1,
            "item": {
              "@type": "WebApplication",
              "name": "Steganography CTF Generator",
              "url": "https://8gwifi.org/ctf/stego-ctf-generator.jsp",
              "description": "Hide flags in images and audio — 34 encoding steps, 7 difficulty levels, LSB stego, classical ciphers, tar/zip wrapping.",
              "applicationCategory": "SecurityApplication",
              "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" }
            }
          },
          {
            "@type": "ListItem",
            "position": 2,
            "item": {
              "@type": "WebApplication",
              "name": "Cryptography CTF Generator",
              "url": "https://8gwifi.org/ctf/crypto-ctf-generator.jsp",
              "description": "39 ciphers and encodings, 6 challenge types, dynamic pipeline composition — all client-side.",
              "applicationCategory": "SecurityApplication",
              "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" }
            }
          },
          { "@type": "ListItem", "position": 3, "name": "Forensic CTF Generator", "url": "https://8gwifi.org/ctf/index.jsp#forensic" },
          { "@type": "ListItem", "position": 4, "name": "Web Exploitation CTF Generator", "url": "https://8gwifi.org/ctf/index.jsp#web" },
          { "@type": "ListItem", "position": 5, "name": "Reverse Engineering CTF Generator", "url": "https://8gwifi.org/ctf/index.jsp#re" },
          { "@type": "ListItem", "position": 6, "name": "OSINT CTF Generator", "url": "https://8gwifi.org/ctf/index.jsp#osint" }
        ]
      }
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:#0a0a0f;color:#e2e8f0;margin:0;min-height:100vh}
        :root{
            --ctf-green:#00ff41;--ctf-green-dim:#00cc33;--ctf-cyan:#00d4ff;--ctf-purple:#a855f7;
            --ctf-red:#ef4444;--ctf-bg:#0a0a0f;--ctf-surface:#111827;--ctf-surface-2:#1f2937;
            --ctf-border:#1e293b;--ctf-text:#e2e8f0;--ctf-text-dim:#94a3b8;
            --ctf-glow:0 0 20px rgba(0,255,65,0.15);--ctf-font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
        }
    </style>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;700&display=swap" media="print" onload="this.media='all'">

    <%@ include file="../modern/ads/ad-init.jsp" %>

    <style>
        .ctf-hero{position:relative;padding:4rem 1.5rem 3rem;text-align:center;overflow:hidden;background:linear-gradient(180deg,#0a0a0f 0%,#0d1117 100%)}
        .ctf-hero::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 50% 0%,rgba(0,255,65,0.06) 0%,transparent 70%);pointer-events:none}
        .ctf-hero-badge{display:inline-flex;align-items:center;gap:0.5rem;padding:0.375rem 1rem;background:rgba(0,255,65,0.08);border:1px solid rgba(0,255,65,0.2);border-radius:100px;font-size:0.75rem;font-weight:600;color:var(--ctf-green);text-transform:uppercase;letter-spacing:0.1em;font-family:var(--ctf-font-mono);margin-bottom:1.25rem}
        .ctf-hero-badge .pulse{width:6px;height:6px;border-radius:50%;background:var(--ctf-green);animation:pulse 2s infinite}
        @keyframes pulse{0%,100%{opacity:1}50%{opacity:0.3}}
        .ctf-hero h1{font-size:clamp(2rem,5vw,3.5rem);font-weight:800;color:#fff;margin-bottom:1rem;line-height:1.1}
        .ctf-hero h1 span{background:linear-gradient(135deg,var(--ctf-green),var(--ctf-cyan));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
        .ctf-hero p{font-size:1.125rem;color:var(--ctf-text-dim);max-width:640px;margin:0 auto 2rem;line-height:1.7}
        .ctf-hero-stats{display:flex;justify-content:center;gap:2.5rem;flex-wrap:wrap}
        .ctf-stat{text-align:center}
        .ctf-stat-num{font-size:1.5rem;font-weight:700;font-family:var(--ctf-font-mono);color:var(--ctf-green)}
        .ctf-stat-label{font-size:0.75rem;color:var(--ctf-text-dim);text-transform:uppercase;letter-spacing:0.08em;margin-top:0.25rem}

        .ctf-main{max-width:1200px;margin:0 auto;padding:0 1.5rem 3rem}

        .ctf-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:1.5rem;margin-top:2rem}
        .ctf-card{position:relative;background:var(--ctf-surface);border:1px solid var(--ctf-border);border-radius:1rem;padding:2rem;transition:all 0.3s;overflow:hidden;text-decoration:none;color:inherit;display:block}
        .ctf-card:hover{border-color:var(--ctf-green);transform:translateY(-4px);box-shadow:var(--ctf-glow)}
        .ctf-card.coming-soon{opacity:0.6;pointer-events:none}
        .ctf-card.coming-soon:hover{transform:none;box-shadow:none;border-color:var(--ctf-border)}
        .ctf-card-icon{width:3.5rem;height:3.5rem;border-radius:0.75rem;display:flex;align-items:center;justify-content:center;font-size:1.5rem;margin-bottom:1.25rem}
        .ctf-card h3{font-size:1.25rem;font-weight:700;color:#fff;margin-bottom:0.5rem}
        .ctf-card p{font-size:0.875rem;color:var(--ctf-text-dim);line-height:1.6;margin-bottom:1.25rem}
        .ctf-card-tags{display:flex;flex-wrap:wrap;gap:0.375rem}
        .ctf-tag{padding:0.25rem 0.625rem;background:rgba(0,255,65,0.06);border:1px solid rgba(0,255,65,0.15);border-radius:100px;font-size:0.6875rem;color:var(--ctf-green-dim);font-family:var(--ctf-font-mono)}
        .ctf-card-badge{position:absolute;top:1rem;right:1rem;padding:0.25rem 0.75rem;border-radius:100px;font-size:0.6875rem;font-weight:600;text-transform:uppercase;letter-spacing:0.05em}
        .ctf-card-badge.live{background:rgba(0,255,65,0.1);color:var(--ctf-green);border:1px solid rgba(0,255,65,0.3)}
        .ctf-card-badge.soon{background:rgba(148,163,184,0.1);color:var(--ctf-text-dim);border:1px solid rgba(148,163,184,0.2)}

        .ctf-section-title{font-size:1.5rem;font-weight:700;color:#fff;display:flex;align-items:center;gap:0.75rem}
        .ctf-section-title::before{content:'>';font-family:var(--ctf-font-mono);color:var(--ctf-green);font-weight:400}

        .ctf-features{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:1.25rem;margin-top:3rem}
        .ctf-feature{display:flex;gap:1rem;align-items:flex-start;padding:1.25rem;background:var(--ctf-surface);border:1px solid var(--ctf-border);border-radius:0.75rem}
        .ctf-feature-icon{width:2.5rem;height:2.5rem;border-radius:0.5rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.125rem}
        .ctf-feature h4{font-size:0.9375rem;font-weight:600;color:#fff;margin-bottom:0.25rem}
        .ctf-feature p{font-size:0.8125rem;color:var(--ctf-text-dim);line-height:1.5}

        .ctf-desc-ad-grid{display:grid;grid-template-columns:1fr minmax(300px,728px);gap:1.5rem;align-items:start}
        .ctf-desc-ad-content{min-width:0}
        @media(max-width:1100px){.ctf-desc-ad-grid{grid-template-columns:1fr}.ctf-desc-ad-slot{justify-self:center}}
        .ctf-ad-section{margin:2.5rem 0;max-width:1200px}
        .ctf-mobile-ad{display:none}
        @media(max-width:768px){
            .ctf-grid{grid-template-columns:1fr}
            .ctf-features{grid-template-columns:1fr}
            .ctf-hero-stats{gap:1.5rem}
            .ctf-mobile-ad{display:block;margin:2rem 0}
        }

        @keyframes scanline{0%{transform:translateY(-100%)}100%{transform:translateY(100vh)}}
        .ctf-scanline{position:fixed;top:0;left:0;right:0;height:2px;background:linear-gradient(90deg,transparent,rgba(0,255,65,0.03),transparent);animation:scanline 8s linear infinite;pointer-events:none;z-index:0}
    </style>
</head>
<body data-theme="dark">
    <div class="ctf-scanline"></div>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <section class="ctf-hero">
        <div class="ctf-hero-badge"><span class="pulse"></span> CTF Challenge Suite</div>
        <h1>Capture The <span>Flag</span> Generator</h1>
        <p>Create, solve, and practice cybersecurity challenges. Generate steganography, crypto, forensic, and web puzzles with auto-generated solutions and progressive hints.</p>
        <div class="ctf-hero-stats">
            <div class="ctf-stat"><div class="ctf-stat-num">39+</div><div class="ctf-stat-label">Cipher & Encoding Steps</div></div>
            <div class="ctf-stat"><div class="ctf-stat-num">11</div><div class="ctf-stat-label">Difficulty Levels</div></div>
            <div class="ctf-stat"><div class="ctf-stat-num">100+</div><div class="ctf-stat-label">Pipeline Combos</div></div>
            <div class="ctf-stat"><div class="ctf-stat-num">100%</div><div class="ctf-stat-label">Client-Side</div></div>
        </div>
    </section>

    <section class="tool-description-section" style="max-width:1200px;margin:0 auto;padding:0 1.5rem">
        <div class="ctf-desc-ad-grid">
            <div class="ctf-desc-ad-content">
                <p style="color:var(--ctf-text-dim);line-height:1.7;font-size:0.9375rem">Build jeopardy-style CTF challenges for competitions, university courses, or self-practice. Each generator outputs a downloadable challenge file, complete solution JSON with pipeline details, and progressive hints for solvers. All processing is 100% client-side.</p>
            </div>
            <div class="ctf-desc-ad-slot">
                <%@ include file="../modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <main class="ctf-main">
        <h2 class="ctf-section-title">Challenge Generators</h2>
        <div class="ctf-grid">
            <a href="<%=request.getContextPath()%>/ctf/stego-ctf-generator.jsp" class="ctf-card">
                <span class="ctf-card-badge live">Live</span>
                <div class="ctf-card-icon" style="background:linear-gradient(135deg,#0d9488,#14b8a6);color:#fff">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/></svg>
                </div>
                <h3>Steganography CTF</h3>
                <p>Hide flags in images and audio using LSB embedding, classical ciphers, tar/zip wrapping, scatter keys, spectrogram encoding, and more. 34 transform steps across 7 difficulty levels.</p>
                <div class="ctf-card-tags">
                    <span class="ctf-tag">LSB Stego</span>
                    <span class="ctf-tag">Audio</span>
                    <span class="ctf-tag">Ciphers</span>
                    <span class="ctf-tag">Forensic</span>
                    <span class="ctf-tag">Containers</span>
                </div>
            </a>

            <a href="<%=request.getContextPath()%>/ctf/crypto-ctf-generator.jsp" class="ctf-card">
                <span class="ctf-card-badge live">Live</span>
                <div class="ctf-card-icon" style="background:linear-gradient(135deg,#6366f1,#818cf8);color:#fff">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                </div>
                <h3>Cryptography CTF</h3>
                <p>39 ciphers and encodings across 4 difficulty levels with 6 challenge types. Dynamic pipeline composition, crib dragging, hash cracking, cipher identification, and key-reuse attacks.</p>
                <div class="ctf-card-tags">
                    <span class="ctf-tag">AES</span>
                    <span class="ctf-tag">RSA</span>
                    <span class="ctf-tag">XOR</span>
                    <span class="ctf-tag">Classical</span>
                    <span class="ctf-tag">6 Types</span>
                </div>
            </a>

            <div class="ctf-card coming-soon">
                <span class="ctf-card-badge soon">Coming Soon</span>
                <div class="ctf-card-icon" style="background:linear-gradient(135deg,#f59e0b,#fbbf24);color:#fff">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                </div>
                <h3>Forensic CTF</h3>
                <p>File carving, memory dumps, disk images, metadata analysis, polyglot files, and packet capture challenges.</p>
                <div class="ctf-card-tags">
                    <span class="ctf-tag">Binwalk</span>
                    <span class="ctf-tag">Metadata</span>
                    <span class="ctf-tag">PCAP</span>
                    <span class="ctf-tag">Carving</span>
                </div>
            </div>

            <div class="ctf-card coming-soon">
                <span class="ctf-card-badge soon">Coming Soon</span>
                <div class="ctf-card-icon" style="background:linear-gradient(135deg,#ef4444,#f87171);color:#fff">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
                </div>
                <h3>Web Exploitation CTF</h3>
                <p>XSS, SQL injection, SSRF, CSRF, JWT bypass, and IDOR challenges with sandboxed vulnerable endpoints.</p>
                <div class="ctf-card-tags">
                    <span class="ctf-tag">XSS</span>
                    <span class="ctf-tag">SQLi</span>
                    <span class="ctf-tag">JWT</span>
                    <span class="ctf-tag">SSRF</span>
                </div>
            </div>

            <div class="ctf-card coming-soon">
                <span class="ctf-card-badge soon">Coming Soon</span>
                <div class="ctf-card-icon" style="background:linear-gradient(135deg,#8b5cf6,#a78bfa);color:#fff">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>
                </div>
                <h3>Reverse Engineering CTF</h3>
                <p>Obfuscated code, binary puzzles, encoded algorithms, and logic gate challenges for reverse engineers.</p>
                <div class="ctf-card-tags">
                    <span class="ctf-tag">Obfuscation</span>
                    <span class="ctf-tag">Binary</span>
                    <span class="ctf-tag">Logic</span>
                </div>
            </div>

            <div class="ctf-card coming-soon">
                <span class="ctf-card-badge soon">Coming Soon</span>
                <div class="ctf-card-icon" style="background:linear-gradient(135deg,#06b6d4,#22d3ee);color:#fff">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                </div>
                <h3>OSINT CTF</h3>
                <p>Open-source intelligence puzzles using public data, geolocation, social media clues, and metadata trails.</p>
                <div class="ctf-card-tags">
                    <span class="ctf-tag">Geolocation</span>
                    <span class="ctf-tag">Metadata</span>
                    <span class="ctf-tag">Social</span>
                </div>
            </div>
        </div>

        <div class="ctf-mobile-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <div class="ctf-features">
            <div class="ctf-feature">
                <div class="ctf-feature-icon" style="background:rgba(0,255,65,0.1);color:var(--ctf-green)">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                </div>
                <div>
                    <h4>Complete Solutions</h4>
                    <p>Every challenge includes the full pipeline, keys, and step-by-step decode path as JSON.</p>
                </div>
            </div>
            <div class="ctf-feature">
                <div class="ctf-feature-icon" style="background:rgba(0,212,255,0.1);color:var(--ctf-cyan)">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                </div>
                <div>
                    <h4>Progressive Hints</h4>
                    <p>Auto-generated hints guide solvers step-by-step without giving away the answer.</p>
                </div>
            </div>
            <div class="ctf-feature">
                <div class="ctf-feature-icon" style="background:rgba(168,85,247,0.1);color:var(--ctf-purple)">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                </div>
                <div>
                    <h4>Flag Verification</h4>
                    <p>SHA-256 hash of the flag lets solvers verify their answer without revealing it.</p>
                </div>
            </div>
            <div class="ctf-feature">
                <div class="ctf-feature-icon" style="background:rgba(239,68,68,0.1);color:var(--ctf-red)">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                </div>
                <div>
                    <h4>100% Client-Side</h4>
                    <p>Zero uploads. Everything runs locally in your browser using Web Crypto API.</p>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="../modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
                <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
            </div>
        </div>
    </footer>

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>

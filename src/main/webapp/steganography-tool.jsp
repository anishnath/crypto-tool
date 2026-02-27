<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Steganography Tool - Hide Messages & Files in Images" />
        <jsp:param name="toolDescription" value="Advanced online steganography tool with AES-256 encryption, file embedding, LSB bit plane analysis, and forensic scanner. Hide text or files in images with military-grade encryption, 100% client-side." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="steganography-tool.jsp" />
        <jsp:param name="toolKeywords" value="steganography tool, hide message in image, LSB encoding, image steganography, AES-256 encryption, hide file in image, bit plane viewer, forensic steganalysis, steganography online, encode decode image, steganography analyzer, file embedding steganography, PBKDF2, AES-GCM encryption, digital steganography, LSB bit plane analysis" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="LSB steganography encoding and decoding,Hide arbitrary files (PDF ZIP TXT) inside images,AES-256-GCM encryption with PBKDF2 key derivation,Visual LSB bit plane analyzer per channel and plane,Forensic scanner with 18+ extraction methods,Auto-generate cover images with 4 pattern styles,Real-time capacity meter,100% client-side processing - zero server uploads,Backward-compatible XOR decryption for legacy images,PNG JPEG BMP format support,Three-mode interface: Encode Decode and Analyze,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="High School, College, Professional" />
        <jsp:param name="teaches" value="Steganography, LSB encoding, AES-256 encryption, PBKDF2 key derivation, bit plane analysis, steganalysis, data hiding, digital forensics, image manipulation, cryptography" />
        <jsp:param name="howToSteps" value="Choose or generate a cover image|Upload a PNG JPEG or BMP image or click one of the 4 auto-generated pattern styles like Gradient Mesh or Geometric Shapes,Select Message or File mode|Switch between the Message sub-tab to hide text or the File sub-tab to embed any file type such as PDF ZIP or TXT,Enter your payload|Type your secret message in the text area or drag-and-drop a file into the file upload zone and watch the capacity meter,Set AES-256 password (optional)|Add a password for AES-256-GCM authenticated encryption using PBKDF2 with 100000 iterations of SHA-256,Click Hide Message|Press the Hide Message button to embed your data into the image using LSB encoding,Download the stego image|Save the resulting PNG file which looks identical to the original but contains your hidden data,Analyze with bit plane viewer|Switch to Analyze mode to inspect individual bit planes per RGB channel and visually detect hidden data patterns" />
        <jsp:param name="faq1q" value="What is steganography and how does it work?" />
        <jsp:param name="faq1a" value="Steganography is the practice of hiding secret information within ordinary data such as images so that no one apart from the sender and recipient knows of its existence. This tool uses Least Significant Bit (LSB) encoding which modifies the least important bit of each color channel in image pixels. Since these tiny changes are invisible to the human eye the image looks identical but carries a hidden message. Unlike encryption which makes data unreadable steganography hides the very existence of the data." />
        <jsp:param name="faq2q" value="Is my data safe? Does this tool upload my images?" />
        <jsp:param name="faq2a" value="Yes your data is completely safe. This tool processes everything 100% client-side in your browser using the HTML5 Canvas API, Web Crypto API, and JavaScript. No images messages files or passwords are ever uploaded to any server. All encoding decoding encryption and analysis happens locally on your device. You can verify this by disconnecting from the internet and confirming the tool still works." />
        <jsp:param name="faq3q" value="What image formats work best for steganography?" />
        <jsp:param name="faq3a" value="PNG is the best format for steganography because it uses lossless compression which preserves every pixel value exactly. JPEG uses lossy compression which can destroy the hidden data during re-encoding. BMP files work well since they are uncompressed but result in large file sizes. This tool always outputs PNG files to ensure your hidden data is preserved perfectly. For best results use PNG images as input or use the built-in image generator." />
        <jsp:param name="faq4q" value="How much data can I hide in an image?" />
        <jsp:param name="faq4a" value="The capacity depends on the image dimensions. Each pixel provides 3 bits of storage (one per RGB channel) so the formula is (width x height x 3) / 8 bytes minus a small header. An 800x600 image can store approximately 180KB which is enough for text documents small PDFs or ZIP files. The real-time capacity meter shows exactly how much space is available. You can hide both text messages and arbitrary files such as PDFs ZIPs or documents." />
        <jsp:param name="faq5q" value="How does the AES-256 password encryption work?" />
        <jsp:param name="faq5a" value="When you set a password this tool uses AES-256-GCM authenticated encryption via the Web Crypto API. Your password is derived into a 256-bit cryptographic key using PBKDF2 with 100000 iterations of SHA-256 and a random 16-byte salt. The message is then encrypted with a random 12-byte IV producing authenticated ciphertext that detects any tampering. This is the same encryption standard used by governments and financial institutions. Without the correct password the data is computationally impossible to recover." />
        <jsp:param name="faq6q" value="Can I hide files like PDFs or ZIPs inside images?" />
        <jsp:param name="faq6a" value="Yes this tool supports embedding arbitrary files inside images not just text messages. Switch to the File sub-tab in Encode mode and drag-and-drop any file type including PDF ZIP TXT documents or other formats. The file is embedded with its original filename preserved. When decoding the tool auto-detects whether the hidden data is text or a file and offers a direct download with the original filename intact." />
        <jsp:param name="faq7q" value="What is the bit plane analyzer and how do I use it?" />
        <jsp:param name="faq7a" value="The bit plane analyzer is a visual forensic tool that lets you inspect individual bit planes of each color channel in an image. Switch to Analyze mode and upload any image then select a channel (Red Green Blue or All) and a bit plane (0 for LSB through 7 for MSB). Hidden steganographic data typically appears as noise or irregular patterns in the LSB plane of encoded regions while clean areas show uniform patterns. This is the classic technique used in digital forensics and steganalysis to detect hidden data." />
        <jsp:param name="faq8q" value="What is the forensic scanner and how many formats does it support?" />
        <jsp:param name="faq8a" value="The forensic scanner is a universal decoder that automatically tries 18 or more extraction methods to find hidden messages regardless of which steganography tool was used to encode them. It supports formats from OpenStego Python steganography libraries JavaScript tools and various LSB encoding configurations including different channel orders (RGB BGR) bit orders (MSB LSB) length header formats (BE32 LE32 LE16) and terminators. Results are ranked by confidence score and deduplicated." />
    </jsp:include>

    <!-- Supplementary Schema: Steganography concept entity (E-E-A-T) -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Article",
      "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": "https://8gwifi.org/steganography-tool.jsp"
      },
      "headline": "Steganography Tool with AES-256 Encryption, File Embedding & Bit Plane Analysis",
      "description": "Advanced online steganography suite: hide text or files in images with AES-256-GCM encryption, analyze bit planes per RGB channel, and scan with 18+ forensic extraction methods. 100% client-side.",
      "about": [
        {
          "@type": "Thing",
          "name": "Steganography",
          "alternateName": ["Image steganography", "LSB steganography", "Data hiding", "Digital steganography"],
          "description": "The practice of concealing messages, files, or information within other non-secret data such as images to avoid detection. Digital image steganography modifies the least significant bits of pixel color channels.",
          "sameAs": [
            "https://en.wikipedia.org/wiki/Steganography",
            "https://en.wikipedia.org/wiki/Least_significant_bit"
          ]
        },
        {
          "@type": "Thing",
          "name": "AES-256-GCM",
          "description": "Advanced Encryption Standard with 256-bit keys in Galois/Counter Mode, providing authenticated encryption with associated data (AEAD). Used here with PBKDF2 key derivation for password-based encryption of steganographic payloads.",
          "sameAs": [
            "https://en.wikipedia.org/wiki/Advanced_Encryption_Standard",
            "https://en.wikipedia.org/wiki/Galois/Counter_Mode"
          ]
        },
        {
          "@type": "Thing",
          "name": "Steganalysis",
          "description": "The study and detection of hidden information within digital media. This tool provides bit plane visualization and forensic scanning to detect steganographic content across multiple encoding formats.",
          "sameAs": "https://en.wikipedia.org/wiki/Steganalysis"
        }
      ],
      "author": {
        "@type": "Person",
        "name": "Anish Nath",
        "url": "https://8gwifi.org",
        "jobTitle": "Software Engineer",
        "sameAs": ["https://twitter.com/anish2good"]
      },
      "publisher": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org",
        "logo": {
          "@type": "ImageObject",
          "url": "https://8gwifi.org/images/site/logo.png"
        }
      },
      "datePublished": "2025-01-20",
      "dateModified": "2026-02-28",
      "inLanguage": "en-US",
      "keywords": "steganography, LSB encoding, AES-256 encryption, hide file in image, bit plane analysis, steganalysis, forensic scanner, PBKDF2, data hiding, image steganography, digital forensics, Web Crypto API"
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- Critical inline CSS -->
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        :root{
            --sg-tool:#0d9488;--sg-tool-dark:#0f766e;--sg-gradient:linear-gradient(135deg,#0d9488 0%,#14b8a6 100%);--sg-light:#f0fdfa;
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;
            --border:#e2e8f0;--font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --shadow-sm:0 1px 2px rgba(0,0,0,0.05);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1);
            --radius-md:0.5rem;--radius-lg:0.75rem;
            --z-dropdown:1000;--z-fixed:1030;--z-modal:1050;
            --header-height-desktop:72px;--header-height-mobile:64px
        }
        [data-theme="dark"]{--sg-light:rgba(13,148,136,0.15);--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155}
        [data-theme="dark"] body{background:var(--bg-primary);color:var(--text-primary)}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed);background:var(--bg-primary);border-bottom:1px solid var(--border);height:var(--header-height-desktop)}
        .tool-page-header{background:var(--bg-primary);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--sg-light);color:var(--sg-tool)}
        .tool-description-section{border-bottom:1px solid var(--border);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;display:flex;flex-direction:column}.tool-input-column{order:1}.tool-output-column{order:2;min-height:350px}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--sg-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem}
        .tool-card-body{padding:1rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary);font-size:0.8125rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-input{width:100%;padding:0.5rem 0.75rem;font-family:var(--font-mono);font-size:0.8125rem;border:1.5px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);transition:border-color 0.15s}
        .tool-form-input:focus{outline:none;border-color:var(--sg-tool);box-shadow:0 0 0 3px rgba(13,148,136,0.1)}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--sg-gradient)!important;color:#fff;transition:opacity .15s;font-family:var(--font-sans)}
        .tool-action-btn:hover{opacity:0.9}
        .tool-action-btn:disabled{opacity:0.5;cursor:not-allowed}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary);border-bottom:1px solid var(--border);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary);flex:1}
        .tool-result-content{padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary);border-color:var(--border)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary)}
    </style>

    <!-- Non-blocking CSS -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/css/steganography-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/steganography-tool.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Steganography Tool</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/CipherFunctions.jsp">Cryptography</a> /
                Steganography
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">AES-256 Encryption</span>
            <span class="tool-badge">File Embedding</span>
            <span class="tool-badge">Bit Plane Analyzer</span>
            <span class="tool-badge">Forensic Scanner</span>
            <span class="tool-badge">100% Client-Side</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--sg-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Advanced <strong>steganography tool</strong> to <strong>hide messages and files inside images</strong> using LSB encoding with <strong>AES-256-GCM encryption</strong>. Embed text or arbitrary files (PDF, ZIP, TXT), analyze bit planes per RGB channel, and scan with 18+ forensic extraction methods. Auto-generate cover images, PBKDF2 key derivation, and <strong>100% client-side processing</strong> with zero server uploads.</p>
        </div>
    </div>
</section>

<main class="tool-page-container sg-layout">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">

        <!-- Mode Toggle -->
        <div class="sg-mode-toggle">
            <button type="button" class="sg-mode-btn sg-active" id="sg-mode-encode">Encode</button>
            <button type="button" class="sg-mode-btn" id="sg-mode-decode">Decode</button>
            <button type="button" class="sg-mode-btn" id="sg-mode-analyze">Analyze</button>
        </div>

        <!-- ===== Encode Panel ===== -->
        <div class="sg-panel sg-panel-active" id="sg-encode-panel">

            <!-- Cover Image Card -->
            <div class="tool-card" style="margin-bottom:0.625rem;">
                <div class="tool-card-header" style="background:var(--sg-gradient);">Cover Image</div>
                <div class="tool-card-body">

                    <!-- Source: Upload + Generator (hidden after image loaded) -->
                    <div class="sg-source-container" id="sg-encode-source">
                        <input type="file" id="sg-encode-file" accept="image/png,image/jpeg,image/bmp" style="display:none;">
                        <div class="sg-upload-zone" id="sg-encode-upload-zone">
                            <svg class="sg-upload-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                <polyline points="17 8 12 3 7 8"/>
                                <line x1="12" y1="3" x2="12" y2="15"/>
                            </svg>
                            <p class="sg-upload-title">Upload an image</p>
                            <p class="sg-upload-hint">PNG, JPEG, or BMP - Click or drag and drop</p>
                        </div>

                        <div class="sg-divider">or paste image URL</div>

                        <div class="sg-url-row">
                            <input type="url" class="tool-form-input" id="sg-encode-url" placeholder="https://example.com/image.png">
                            <button type="button" class="sg-url-btn" id="sg-encode-url-btn">Fetch</button>
                        </div>
                        <div class="sg-url-error" id="sg-encode-url-error"></div>

                        <div class="sg-divider">or generate one</div>

                        <div class="sg-gen-grid">
                            <div class="sg-gen-card" data-type="gradient">
                                <svg class="sg-gen-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                    <circle cx="12" cy="12" r="10"/>
                                    <circle cx="12" cy="12" r="6" opacity="0.5"/>
                                    <circle cx="12" cy="12" r="2" opacity="0.3"/>
                                </svg>
                                <span class="sg-gen-label">Gradient Mesh</span>
                            </div>
                            <div class="sg-gen-card" data-type="geometric">
                                <svg class="sg-gen-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                    <rect x="3" y="3" width="8" height="8" rx="1"/>
                                    <circle cx="17" cy="7" r="4"/>
                                    <polygon points="7 14 3 21 11 21"/>
                                </svg>
                                <span class="sg-gen-label">Geometric</span>
                            </div>
                            <div class="sg-gen-card" data-type="noise">
                                <svg class="sg-gen-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                    <rect x="3" y="3" width="18" height="18" rx="2"/>
                                    <line x1="3" y1="9" x2="21" y2="9" stroke-dasharray="2 2"/>
                                    <line x1="3" y1="15" x2="21" y2="15" stroke-dasharray="2 2"/>
                                    <line x1="9" y1="3" x2="9" y2="21" stroke-dasharray="2 2"/>
                                    <line x1="15" y1="3" x2="15" y2="21" stroke-dasharray="2 2"/>
                                </svg>
                                <span class="sg-gen-label">Noise Pattern</span>
                            </div>
                            <div class="sg-gen-card" data-type="waves">
                                <svg class="sg-gen-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                    <path d="M2 12c2-3 4-3 6 0s4 3 6 0 4-3 6 0"/>
                                    <path d="M2 8c2-3 4-3 6 0s4 3 6 0 4-3 6 0" opacity="0.5"/>
                                    <path d="M2 16c2-3 4-3 6 0s4 3 6 0 4-3 6 0" opacity="0.5"/>
                                </svg>
                                <span class="sg-gen-label">Abstract Waves</span>
                            </div>
                        </div>
                    </div>

                    <!-- Preview (shown after image loaded) -->
                    <div class="sg-preview-container" id="sg-encode-preview">
                        <canvas id="sg-encode-preview-canvas" class="sg-image-preview"></canvas>
                        <div id="sg-encode-image-info"></div>
                        <button type="button" class="sg-change-link" id="sg-change-encode">Change Image</button>
                    </div>
                </div>
            </div>

            <!-- Payload + Options Card -->
            <div class="tool-card" style="margin-bottom:0.625rem;">
                <div class="tool-card-header" style="background:var(--sg-gradient);">Payload &amp; Options</div>
                <div class="tool-card-body">
                    <!-- Encode Sub-Tabs: Message / File -->
                    <div class="sg-subtab-toggle">
                        <button type="button" class="sg-subtab-btn sg-active" id="sg-subtab-message">Message</button>
                        <button type="button" class="sg-subtab-btn" id="sg-subtab-file">File</button>
                    </div>

                    <!-- Message Sub-Panel -->
                    <div id="sg-encode-message-panel">
                        <div class="tool-form-group" style="margin-bottom:0.375rem;">
                            <textarea class="tool-form-input" id="sg-message-input" rows="3" placeholder="Type the message you want to hide..." style="resize:vertical;font-family:var(--font-sans);"></textarea>
                        </div>
                        <div class="sg-capacity-meter" id="sg-capacity-container">
                            <div id="sg-capacity-meter"></div>
                        </div>
                    </div>

                    <!-- File Sub-Panel -->
                    <div id="sg-encode-file-panel" style="display:none;">
                        <input type="file" id="sg-embed-file-input" style="display:none;">
                        <div class="sg-upload-zone sg-embed-zone" id="sg-embed-upload-zone">
                            <svg class="sg-upload-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                                <polyline points="14 2 14 8 20 8"/>
                            </svg>
                            <p class="sg-upload-title">Drop a file to embed</p>
                            <p class="sg-upload-hint">Any file type: PDF, ZIP, TXT, etc.</p>
                        </div>
                        <div class="sg-embed-file-info" id="sg-embed-file-info" style="display:none;"></div>
                    </div>

                    <div class="sg-options-row">
                        <div class="sg-password-group">
                            <label class="tool-form-label" for="sg-encode-password">Password (optional, AES-256)</label>
                            <div class="sg-password-wrap">
                                <input type="password" class="tool-form-input" id="sg-encode-password" placeholder="Password">
                                <button type="button" class="sg-password-toggle" id="sg-enc-pwd-toggle" aria-label="Toggle password visibility">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                </button>
                            </div>
                        </div>
                        <label class="sg-checkbox-label" style="padding-bottom:0.375rem;" id="sg-compression-label">
                            <input type="checkbox" id="sg-encode-compression" checked>
                            Compress
                        </label>
                    </div>
                </div>
            </div>

            <!-- Encode Button -->
            <button type="button" class="tool-action-btn" id="sg-encode-btn" disabled>Hide Message</button>
        </div>

        <!-- ===== Decode Panel ===== -->
        <div class="sg-panel" id="sg-decode-panel">

            <!-- Stego Image Card -->
            <div class="tool-card" style="margin-bottom:0.625rem;">
                <div class="tool-card-header" style="background:var(--sg-gradient);">Stego Image</div>
                <div class="tool-card-body">

                    <div class="sg-source-container" id="sg-decode-source">
                        <input type="file" id="sg-decode-file" accept="image/png,image/jpeg,image/bmp" style="display:none;">
                        <div class="sg-upload-zone" id="sg-decode-upload-zone">
                            <svg class="sg-upload-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                <polyline points="17 8 12 3 7 8"/>
                                <line x1="12" y1="3" x2="12" y2="15"/>
                            </svg>
                            <p class="sg-upload-title">Upload stego image</p>
                            <p class="sg-upload-hint">Upload the image containing the hidden message</p>
                        </div>

                        <div class="sg-divider">or paste image URL</div>

                        <div class="sg-url-row">
                            <input type="url" class="tool-form-input" id="sg-decode-url" placeholder="https://example.com/stego-image.png">
                            <button type="button" class="sg-url-btn" id="sg-decode-url-btn">Fetch</button>
                        </div>
                        <div class="sg-url-error" id="sg-decode-url-error"></div>
                    </div>

                    <div class="sg-preview-container" id="sg-decode-preview">
                        <canvas id="sg-decode-preview-canvas" class="sg-image-preview"></canvas>
                        <div id="sg-decode-image-info"></div>
                        <button type="button" class="sg-change-link" id="sg-change-decode">Change Image</button>
                    </div>
                </div>
            </div>

            <!-- Password Card -->
            <div class="tool-card" style="margin-bottom:0.625rem;display:none;" id="sg-decode-password-section">
                <div class="tool-card-header" style="background:var(--sg-gradient);">Password</div>
                <div class="tool-card-body">
                    <div class="tool-form-group" style="margin-bottom:0;">
                        <label class="tool-form-label" for="sg-decode-password">Password (if used during encoding)</label>
                        <div class="sg-password-wrap">
                            <input type="password" class="tool-form-input" id="sg-decode-password" placeholder="Enter password to decrypt">
                            <button type="button" class="sg-password-toggle" id="sg-dec-pwd-toggle" aria-label="Toggle password visibility">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Decode Button -->
            <button type="button" class="tool-action-btn" id="sg-decode-btn" disabled>Extract Message</button>

            <div class="sg-divider">Advanced</div>
            <button type="button" class="tool-action-btn sg-forensic-btn" id="sg-forensic-btn" disabled>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align:-2px;margin-right:4px;"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>Universal Decode (Forensic Scanner)
            </button>
            <p class="sg-forensic-hint">Tries 18+ extraction methods used by OpenStego, Python tutorials, and other tools</p>
        </div>

        <!-- ===== Analyze Panel ===== -->
        <div class="sg-panel" id="sg-analyze-panel">
            <div class="tool-card" style="margin-bottom:0.625rem;">
                <div class="tool-card-header" style="background:var(--sg-gradient);">Image to Analyze</div>
                <div class="tool-card-body">
                    <div class="sg-source-container" id="sg-analyze-source">
                        <input type="file" id="sg-analyze-file" accept="image/png,image/jpeg,image/bmp" style="display:none;">
                        <div class="sg-upload-zone" id="sg-analyze-upload-zone">
                            <svg class="sg-upload-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                <polyline points="17 8 12 3 7 8"/>
                                <line x1="12" y1="3" x2="12" y2="15"/>
                            </svg>
                            <p class="sg-upload-title">Upload image to analyze</p>
                            <p class="sg-upload-hint">View individual bit planes per channel</p>
                        </div>
                    </div>
                    <div class="sg-preview-container" id="sg-analyze-preview">
                        <canvas id="sg-analyze-preview-canvas" class="sg-image-preview"></canvas>
                        <div id="sg-analyze-image-info"></div>
                        <button type="button" class="sg-change-link" id="sg-change-analyze">Change Image</button>
                    </div>
                </div>
            </div>

            <div class="tool-card" style="margin-bottom:0.625rem;">
                <div class="tool-card-header" style="background:var(--sg-gradient);">Bit Plane Controls</div>
                <div class="tool-card-body">
                    <div class="tool-form-group" style="margin-bottom:0.5rem;">
                        <label class="tool-form-label">Channel</label>
                        <div class="sg-bitplane-pills" id="sg-bitplane-channel-pills">
                            <select class="tool-form-input" id="sg-bitplane-channel" style="font-family:var(--font-sans);">
                                <option value="0">Red</option>
                                <option value="1">Green</option>
                                <option value="2">Blue</option>
                                <option value="3" selected>All Channels</option>
                            </select>
                        </div>
                    </div>
                    <div class="tool-form-group" style="margin-bottom:0;">
                        <label class="tool-form-label">Bit Plane</label>
                        <div class="sg-bitplane-pills">
                            <select class="tool-form-input" id="sg-bitplane-plane" style="font-family:var(--font-sans);">
                                <option value="0" selected>0 (LSB)</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7 (MSB)</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <button type="button" class="tool-action-btn" id="sg-analyze-btn" disabled>Analyze Bit Plane</button>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <div class="tool-card">
            <div class="tool-result-header">
                <h4>Result</h4>
            </div>
            <div class="tool-result-content" id="sg-result-content">
                <!-- Populated by StegoCore -->
            </div>
            <div class="sg-result-toolbar" id="sg-toolbar">
                <button type="button" class="sg-toolbar-btn" id="sg-toolbar-download" style="display:none;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                    Download
                </button>
                <button type="button" class="sg-toolbar-btn" id="sg-toolbar-copy" style="display:none;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    Copy
                </button>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- ==================== BELOW-FOLD EDUCATIONAL CONTENT ==================== -->

<!-- What is Steganography? -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="sg-anim">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">What is Steganography?</h2>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            <strong>Steganography</strong> is the art of hiding information within ordinary, non-secret data so that no one suspects the hidden content exists. The word comes from the Greek <em>steganos</em> (covered) and <em>graphein</em> (to write). Unlike encryption, which makes data unreadable, steganography conceals the very existence of the secret message.
        </p>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            The practice dates back to ancient Greece, where messages were tattooed on shaved heads and hidden under regrown hair. In the digital age, steganography embeds data in images, audio, video, or text files. This tool uses <strong>digital image steganography</strong>, hiding text messages in the pixel data of images.
        </p>
        <div class="sg-info-box">
            Steganography is not a replacement for encryption. For maximum security, combine both: encrypt your message first (using the password option), then hide the encrypted text in an image.
        </div>
    </div>
</section>

<!-- How LSB Encoding Works -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="sg-anim sg-anim-d1">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">How LSB Encoding Works</h3>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            <strong>Least Significant Bit (LSB) encoding</strong> is the most common method for image steganography. Every pixel in a digital image is made up of color channels (Red, Green, Blue), each stored as an 8-bit value from 0 to 255. The last bit of each byte is the "least significant" because changing it only shifts the color value by 1 out of 256 -- a difference invisible to the human eye.
        </p>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            This tool converts your message into binary, then replaces the last bit of each RGB channel with one bit of the message. A 4-byte length header is stored first, telling the decoder how many bytes to read. For an 800x600 pixel image, this provides approximately 180KB of storage capacity -- enough for tens of thousands of words.
        </p>
        <div class="sg-info-box" style="font-family:var(--font-mono);font-size:0.8125rem;">
            Original pixel: R=145 (10010001), G=200 (11001000), B=78 (01001110)<br>
            With hidden bits: R=144 (1001000<strong>0</strong>), G=201 (1100100<strong>1</strong>), B=79 (0100111<strong>1</strong>)<br>
            Color change: imperceptible to the human eye
        </div>
    </div>
</section>

<!-- Security and Privacy -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="sg-anim sg-anim-d2">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Security and Privacy</h3>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            This tool runs <strong>100% client-side</strong> in your browser. No images, messages, or passwords are ever uploaded to any server. All processing happens locally using the HTML5 Canvas API and JavaScript. You can verify this by disconnecting from the internet and confirming the tool still works.
        </p>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            The optional password protection uses <strong>AES-256-GCM</strong> authenticated encryption via the Web Crypto API. Your password is derived into a 256-bit key using PBKDF2 with 100,000 iterations of SHA-256. This provides strong, industry-standard encryption for your hidden messages. Older images encoded with XOR encryption are still supported for backward compatibility.
        </p>
    </div>
</section>

<!-- Tips for Best Results -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="sg-anim sg-anim-d3">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Tips for Best Results</h3>
        <div class="sg-tips-grid">
            <div class="sg-tip-card">
                <h4>Use PNG Format</h4>
                <p>PNG uses lossless compression which preserves every pixel exactly. JPEG compression can destroy hidden data. Always save and share stego images as PNG.</p>
            </div>
            <div class="sg-tip-card">
                <h4>Larger Images = More Capacity</h4>
                <p>Each pixel stores 3 bits. An 800x600 image holds ~180KB. For longer messages, use a higher resolution cover image.</p>
            </div>
            <div class="sg-tip-card">
                <h4>Use a Password</h4>
                <p>Even if someone suspects steganography, a password-protected message will appear as random bytes without the correct key.</p>
            </div>
            <div class="sg-tip-card">
                <h4>Enable Compression</h4>
                <p>Base64 compression adds a layer of encoding that makes raw extraction more difficult and improves cross-tool compatibility.</p>
            </div>
        </div>
    </div>
</section>

<!-- FAQ Section -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="sg-anim sg-anim-d3">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Frequently Asked Questions</h3>
        <div class="faq-container">
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    What is steganography and how does it work?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Steganography is the practice of hiding secret information within ordinary data such as images so that no one apart from the sender and recipient knows of its existence. This tool uses Least Significant Bit (LSB) encoding which modifies the least important bit of each color channel in image pixels. Since these tiny changes are invisible to the human eye the image looks identical but carries a hidden message. Unlike encryption which makes data unreadable steganography hides the very existence of the data.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    Is my data safe? Does this tool upload my images?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes, your data is completely safe. This tool processes everything 100% client-side in your browser using the HTML5 Canvas API, Web Crypto API, and JavaScript. No images, messages, files, or passwords are ever uploaded to any server. All encoding, decoding, encryption, and analysis happens locally on your device, which means your private data never leaves your computer. You can verify this by disconnecting from the internet and confirming the tool still works.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    What image formats work best for steganography?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">PNG is the best format for steganography because it uses lossless compression which preserves every pixel value exactly. JPEG uses lossy compression which can destroy the hidden data during re-encoding. BMP files work well since they are uncompressed but result in large file sizes. This tool always outputs PNG files to ensure your hidden message is preserved perfectly. For best results use PNG images as input or use the built-in image generator.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    How much data can I hide in an image?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The capacity depends on the image dimensions. Each pixel provides 3 bits of storage (one per RGB channel) so the formula is (width x height x 3) / 8 bytes minus a small header. An 800x600 image can store approximately 180KB, which is enough for text documents, small PDFs, or ZIP files. The real-time capacity meter shows exactly how much space is available. You can hide both text messages and arbitrary files such as PDFs, ZIPs, or documents.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    How does the AES-256 password encryption work?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">When you set a password, this tool uses AES-256-GCM authenticated encryption via the Web Crypto API. Your password is derived into a 256-bit cryptographic key using PBKDF2 with 100,000 iterations of SHA-256 and a random 16-byte salt. The message is then encrypted with a random 12-byte IV, producing authenticated ciphertext that detects any tampering. This is the same encryption standard used by governments and financial institutions. Without the correct password, the data is computationally impossible to recover. Older images encoded with XOR encryption are still supported for backward compatibility.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    Can I hide files like PDFs or ZIPs inside images?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes, this tool supports embedding arbitrary files inside images, not just text messages. Switch to the File sub-tab in Encode mode and drag-and-drop any file type including PDF, ZIP, TXT, documents, or other formats. The file is embedded with its original filename preserved. When decoding, the tool auto-detects whether the hidden data is text or a file and offers a direct download with the original filename intact.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    What is the bit plane analyzer?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The bit plane analyzer is a visual forensic tool that lets you inspect individual bit planes of each color channel in an image. Switch to Analyze mode, upload any image, then select a channel (Red, Green, Blue, or All) and a bit plane (0 for LSB through 7 for MSB). Hidden steganographic data typically appears as noise or irregular patterns in the LSB plane of encoded regions, while clean areas show uniform patterns. This is the classic technique used in digital forensics and steganalysis to detect hidden data.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    What is the forensic scanner and how many formats does it support?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The forensic scanner is a universal decoder that automatically tries 18+ extraction methods to find hidden messages regardless of which steganography tool was used to encode them. It supports formats from OpenStego, Python steganography libraries, JavaScript tools, and various LSB encoding configurations including different channel orders (RGB, BGR), bit orders (MSB, LSB), length header formats (BE32, LE32, LE16), and terminators. Results are ranked by confidence score and deduplicated.</div>
            </div>
        </div>
    </div>
</section>

<!-- Explore More Cryptography Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="sg-anim sg-anim-d4">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Cryptography Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/CipherFunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#7c3aed,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">AES</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">AES Encryption</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Encrypt and decrypt data with AES-128/192/256</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/rsafunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#2563eb,#60a5fa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">RSA</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">RSA Functions</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">RSA key generation, encryption, signing</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/MessageDigest.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#34d399);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1rem;color:#fff;font-weight:700;">#</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Hash Functions</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">SHA-256, MD5, SHA-512 and more hash algorithms</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/file-encrypt.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#dc2626,#f87171);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;color:#fff;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                </div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">File Encrypt</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Encrypt and decrypt files with AES client-side</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/hex-editor.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#ea580c,#f97316);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.75rem;color:#fff;font-weight:700;font-family:monospace;">0xFF</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Hex Editor</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">View and edit binary data in hexadecimal</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/qr-code-generator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#0d9488,#14b8a6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;color:#fff;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="3" height="3"/><rect x="18" y="18" width="3" height="3"/></svg>
                </div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">QR Code Generator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Generate QR codes for URLs, text, and data</p>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
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

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<!-- Scroll-triggered animations -->
<script>
(function(){
    var els = document.querySelectorAll('.sg-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        for (var i = 0; i < els.length; i++) els[i].classList.add('sg-visible');
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        for (var j = 0; j < entries.length; j++) {
            if (entries[j].isIntersecting) {
                entries[j].target.classList.add('sg-visible');
                obs.unobserve(entries[j].target);
            }
        }
    }, { threshold: 0.15 });
    for (var k = 0; k < els.length; k++) obs.observe(els[k]);
})();
</script>

<!-- Core Scripts -->
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/stego-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/stego-engine.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/stego-imagegen.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/stego-forensic.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/stego-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>

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
        <jsp:param name="toolName" value="Hex Dump Viewer &bull; Binary Structure Analyzer Online" />
        <jsp:param name="toolDescription" value="Free online hex dump viewer with intelligent binary structure analysis. Auto-detects PNG, PDF, ZIP, ELF, PE, JPEG, DER/ASN.1, PEM and 20+ formats. Color-coded headers, magic bytes, checksums, and compressed regions. Structure Map shows file layout at a glance. Export as C, Python, Go, Rust arrays. 100% client-side." />
        <jsp:param name="toolCategory" value="Developer Tools" />
        <jsp:param name="toolUrl" value="hexdump.jsp" />
        <jsp:param name="toolKeywords" value="hex dump online, hex viewer, binary file analyzer, binary structure analyzer, file format parser, hexdump generator, hex editor online, byte viewer, hex to ascii, binary viewer, hex search, file entropy calculator, PNG structure viewer, ELF header parser, PE header analyzer, PDF structure viewer, ZIP file inspector, ASN.1 DER viewer, PEM parser, magic bytes detector, file signature database, xxd online, export hex as C array, export hex as Python bytes" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Intelligent binary structure analysis with 20+ format parsers,Auto-detect file type from 70+ magic byte signatures,Color-coded regions: headers, magic bytes, checksums, compressed data, metadata,Interactive Structure Map panel with clickable regions,Deep parsing for PNG, JPEG, PDF, ZIP, ELF, PE, DER/ASN.1, PEM, JKS,Section-level parsing for GIF, BMP, GZIP, SQLite, Java Class, WASM, MP3, MP4, Mach-O, TAR,Hover tooltips explaining each binary field,View hex/decimal/octal/binary formats,Virtual scrolling for multi-megabyte files,Byte pattern search with highlighting,File entropy and byte frequency statistics,Export as C/Python/Go/Rust source code arrays,Full hex editor with undo/redo and insert/delete,100% client-side processing — files never leave your browser" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Upload a binary file|Drag and drop any file (PNG, PDF, ZIP, EXE, ELF, DER, PEM, etc.) or paste text/hex data,View auto-detected structure|The tool identifies the file type and color-codes regions: pink for magic bytes, blue for headers, orange for checksums, purple for compressed data,Explore the Structure Map|Open the Structure Map panel to see a bird's-eye view of the file layout with clickable regions that scroll to each section,Inspect individual bytes|Click any byte to see hex, decimal, octal, binary values plus which structural region it belongs to,Search and navigate|Search for byte patterns (e.g. 50 4B 03 04 for ZIP headers) and use Go-to-offset for precise navigation,Export or edit|Export as C/Python/Go/Rust arrays, or toggle Edit mode to modify bytes with full undo/redo support" />
        <jsp:param name="faq1q" value="What is a hex dump and how do I read one?" />
        <jsp:param name="faq1a" value="A hex dump displays file contents as hexadecimal values alongside their ASCII text representation. Each line shows an offset address (position in the file), hex byte values (typically 16 per line), and printable ASCII characters. Non-printable bytes appear as dots. This lets you inspect binary file structures, find magic bytes, and analyze data at the byte level." />
        <jsp:param name="faq2q" value="How does the binary structure analyzer work?" />
        <jsp:param name="faq2a" value="When you load a file, the tool checks the first bytes against a database of 70+ magic byte signatures to identify the file type. It then runs a format-specific parser that maps every byte to a structural region — headers, metadata, compressed data, checksums, and more. Each region is color-coded in the hex view and listed in the Structure Map panel. Supported formats include PNG, JPEG, PDF, ZIP, ELF, PE/EXE, DER/ASN.1, PEM, JKS, GIF, BMP, GZIP, SQLite, Java Class, WASM, RIFF (WAV/AVI), MP3, MP4, Mach-O, PGP, PKCS#12, and TAR." />
        <jsp:param name="faq3q" value="What do the color-coded regions mean in the hex view?" />
        <jsp:param name="faq3a" value="Pink/magenta highlights magic bytes (file signatures). Blue marks headers and chunk types. Teal indicates metadata like dimensions or timestamps. Purple shows compressed sections. Orange marks checksums and CRCs. Green highlights embedded text strings. Yellow indicates index structures like tables and directories. Grey shows padding bytes. Hover over any colored byte to see a tooltip explaining that field." />
        <jsp:param name="faq4q" value="How do I search for byte patterns in a hex dump?" />
        <jsp:param name="faq4a" value="Enter hex values separated by spaces in the search box (e.g., 50 4B 03 04 for ZIP file headers). The tool highlights all occurrences and shows the match count. It automatically scrolls to the first match. This is useful for finding file signatures, magic bytes, and specific data sequences." />
        <jsp:param name="faq5q" value="What is file entropy and why does it matter?" />
        <jsp:param name="faq5a" value="Entropy measures the randomness of bytes in a file, ranging from 0 (all identical bytes) to 8 bits (maximum randomness). High entropy (above 7.5) suggests encrypted or compressed data. Low entropy indicates structured text or repeated patterns. Security analysts use entropy to detect encrypted payloads, packed executables, or steganographic content." />
        <jsp:param name="faq6q" value="Can I export hex data as a C or Python array?" />
        <jsp:param name="faq6a" value="Yes. Click the export buttons in the toolbar to download your data as a C unsigned char array, Python bytes literal, Go byte slice, or Rust byte array. Each export generates valid, compilable source code with proper formatting and length constants. This is useful for embedding binary data in source code." />
        <jsp:param name="faq7q" value="What binary file formats are supported for deep structure analysis?" />
        <jsp:param name="faq7a" value="Tier 1 (deep field-level parsing): PNG with IHDR dimensions and per-chunk CRCs, JPEG with SOF/EXIF/Huffman markers, PDF with xref tables and trailers, ZIP with local headers and central directory, ELF with program and section headers, PE/EXE with COFF and optional headers, DER/ASN.1 with recursive TLV decoding, PEM with Base64 body detection, and JKS keystores. Tier 2 (section-level): GIF, BMP, GZIP, SQLite, Java Class, WASM, RIFF (WAV/AVI), MP3/ID3, MP4/MOV, Mach-O, PGP, PKCS#12, and TAR." />
        <jsp:param name="faq8q" value="Is this hex dump tool safe for sensitive files?" />
        <jsp:param name="faq8a" value="Yes. All processing happens entirely in your browser using JavaScript. Files are read via the FileReader API and never leave your computer. No data is sent to any server. The tool works offline after loading. This makes it safe for analyzing confidential documents, proprietary binaries, or security-sensitive files." />
    </jsp:include>

    <!-- TechArticle schema — E-E-A-T signals for binary analysis expertise -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "TechArticle",
        "headline": "Hex Dump Viewer & Intelligent Binary Structure Analyzer",
        "alternativeHeadline": "Analyze PNG, PDF, ZIP, ELF, PE, JPEG and 20+ binary formats with color-coded structure maps",
        "description": "Professional online hex dump viewer with intelligent binary structure analysis. Auto-detects 70+ file signatures and parses 20+ formats including PNG (IHDR, IDAT chunks, CRCs), PDF (xref, trailer), ZIP (local headers, central directory), ELF (program/section headers), PE/EXE (COFF, optional header), DER/ASN.1 (recursive TLV), PEM, JKS, JPEG, GIF, GZIP, SQLite, Java Class, WASM, MP3/MP4, Mach-O, and TAR. Color-coded hex regions with tooltips and an interactive Structure Map.",
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://8gwifi.org",
            "jobTitle": "Security Engineer",
            "sameAs": ["https://twitter.com/anish2good"]
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org",
            "logo": { "@type": "ImageObject", "url": "https://8gwifi.org/images/site/logo.png" }
        },
        "datePublished": "2024-01-01",
        "dateModified": "<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>",
        "proficiencyLevel": "Beginner",
        "dependencies": "Modern web browser with JavaScript enabled",
        "about": [
            { "@type": "Thing", "name": "Hexadecimal", "sameAs": "https://en.wikipedia.org/wiki/Hexadecimal" },
            { "@type": "Thing", "name": "Binary file", "sameAs": "https://en.wikipedia.org/wiki/Binary_file" },
            { "@type": "Thing", "name": "File format", "sameAs": "https://en.wikipedia.org/wiki/File_format" },
            { "@type": "Thing", "name": "Magic number (programming)", "sameAs": "https://en.wikipedia.org/wiki/Magic_number_(programming)" }
        ],
        "keywords": "hex dump, binary structure analysis, file format parser, magic bytes, PNG structure, ELF header, PE header, ASN.1 DER, hex editor, reverse engineering, digital forensics"
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
            --hx-tool:#059669;--hx-tool-dark:#047857;--hx-gradient:linear-gradient(135deg,#059669 0%,#34d399 100%);--hx-light:#ecfdf5;
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;
            --border:#e2e8f0;--font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --shadow-sm:0 1px 2px rgba(0,0,0,0.05);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1);
            --radius-md:0.5rem;--radius-lg:0.75rem;
            --z-dropdown:1000;--z-fixed:1030;--z-modal:1050;
            --header-height-desktop:72px;--header-height-mobile:64px
        }
        [data-theme="dark"]{--hx-light:rgba(5,150,105,0.12);--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155}
        [data-theme="dark"] body{background:var(--bg-primary);color:var(--text-primary)}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed);background:var(--bg-primary);border-bottom:1px solid var(--border);height:var(--header-height-desktop)}
        .tool-page-header{background:var(--bg-primary);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--hx-light);color:var(--hx-tool)}
        .tool-description-section{border-bottom:1px solid var(--border);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.625rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary);border-color:var(--border)}
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
    <link rel="preload" href="<%=request.getContextPath()%>/css/hexdump.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/hexdump.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<!-- ===== Header ===== -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Hex Dump Viewer & Binary Analyzer</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/#developer-tools">Developer Tools</a> /
                Hex Dump
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">Virtual Scrolling</span>
            <span class="tool-badge">5 Export Formats</span>
            <span class="tool-badge">100% Client-Side</span>
        </div>
    </div>
</header>

<!-- ===== Description ===== -->
<section class="tool-description-section" style="background:var(--hx-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>hex dump viewer</strong> and <strong>binary file analyzer</strong> with virtual scrolling for large files. Upload any file or paste text to view <strong>hex, decimal, octal, or binary</strong> representations. Search byte patterns, calculate <strong>file entropy</strong>, and export as <strong>C, Python, Go, Rust</strong> arrays. 100% client-side &mdash; files never leave your browser.</p>
        </div>
    </div>
</section>

<!-- ===== IDE-Style Editor ===== -->
<main style="max-width:1600px;margin:0 auto;padding:0.75rem 1.5rem;">
    <input type="file" id="hx-file-input" style="display:none;">

    <!-- Toolbar -->
    <div class="hx-toolbar" id="hx-toolbar">
        <!-- Input group -->
        <div class="hx-toolbar-group">
            <button type="button" class="hx-toolbar-btn" id="hx-open-btn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:0.8rem;height:0.8rem;"><path d="M13 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V9z"/><polyline points="13 2 13 9 20 9"/></svg>
                Open
            </button>
            <button type="button" class="hx-toolbar-btn" id="hx-paste-text-btn">Text</button>
            <button type="button" class="hx-toolbar-btn" id="hx-paste-hex-btn">Hex</button>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Format pills -->
        <div class="hx-toolbar-group">
            <button type="button" class="hx-format-pill active" data-format="hex">HEX</button>
            <button type="button" class="hx-format-pill" data-format="dec">DEC</button>
            <button type="button" class="hx-format-pill" data-format="oct">OCT</button>
            <button type="button" class="hx-format-pill" data-format="bin">BIN</button>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Display settings -->
        <div class="hx-toolbar-group">
            <select id="hx-bytes-per-line" class="hx-toolbar-select" title="Bytes per line">
                <option value="8">8</option>
                <option value="16" selected>16</option>
                <option value="24">24</option>
                <option value="32">32</option>
            </select>
            <select id="hx-byte-grouping" class="hx-toolbar-select" title="Byte grouping">
                <option value="0">None</option>
                <option value="1" selected>1</option>
                <option value="2">2</option>
                <option value="4">4</option>
                <option value="8">8</option>
            </select>
            <label class="hx-toolbar-checkbox"><input type="checkbox" id="hx-show-ascii" checked> Ascii</label>
            <label class="hx-toolbar-checkbox"><input type="checkbox" id="hx-show-offset" checked> Offset</label>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Search -->
        <div class="hx-toolbar-group">
            <input type="text" id="hx-search-input" class="hx-toolbar-search" placeholder="Search hex: 50 4B 03 04">
            <span class="hx-match-count" id="hx-match-count"></span>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Goto -->
        <div class="hx-toolbar-group">
            <input type="text" id="hx-goto-input" class="hx-toolbar-search hx-toolbar-search-goto" placeholder="Goto 0x">
            <button type="button" class="hx-toolbar-btn" id="hx-goto-btn">Go</button>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Actions -->
        <div class="hx-toolbar-group">
            <button type="button" class="hx-toolbar-btn" id="hx-copy-btn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:0.8rem;height:0.8rem;"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/></svg>
                Copy
            </button>
            <button type="button" class="hx-toolbar-btn" id="hx-download-btn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:0.8rem;height:0.8rem;"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                Save
            </button>
            <div style="position:relative;display:inline-block;">
                <button type="button" class="hx-toolbar-btn" id="hx-export-btn">Export &#9662;</button>
                <div class="hx-export-menu" id="hx-export-menu">
                    <button type="button" class="hx-export-menu-item" id="hx-export-c">C Array</button>
                    <button type="button" class="hx-export-menu-item" id="hx-export-python">Python Bytes</button>
                    <button type="button" class="hx-export-menu-item" id="hx-export-go">Go Slice</button>
                    <button type="button" class="hx-export-menu-item" id="hx-export-rust">Rust Array</button>
                </div>
            </div>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Edit mode -->
        <div class="hx-toolbar-group">
            <button type="button" class="hx-toolbar-btn" id="hx-edit-toggle" title="Toggle edit mode (double-click byte to edit)">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:0.8rem;height:0.8rem;"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                Edit
            </button>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Undo/Redo -->
        <div class="hx-toolbar-group">
            <button type="button" class="hx-toolbar-btn" id="hx-undo-btn" disabled title="Undo (Ctrl+Z)">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:0.8rem;height:0.8rem;"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 102.13-9.36L1 10"/></svg>
                Undo
            </button>
            <button type="button" class="hx-toolbar-btn" id="hx-redo-btn" disabled title="Redo (Ctrl+Y)">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:0.8rem;height:0.8rem;"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 11-2.13-9.36L23 10"/></svg>
                Redo
            </button>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Insert/Delete -->
        <div class="hx-toolbar-group">
            <button type="button" class="hx-toolbar-btn" id="hx-insert-btn" disabled title="Insert byte after selected">Insert</button>
            <button type="button" class="hx-toolbar-btn warning" id="hx-delete-btn" disabled title="Delete selected byte">Delete</button>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Save binary -->
        <div class="hx-toolbar-group">
            <button type="button" class="hx-toolbar-btn" id="hx-save-binary-btn" disabled title="Save modified binary file">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:0.8rem;height:0.8rem;"><path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                Save Binary
            </button>
            <span class="hx-modified-indicator hidden" id="hx-modified-indicator">Modified</span>
        </div>

        <div class="hx-toolbar-divider"></div>

        <!-- Inspector toggle -->
        <button type="button" class="hx-toolbar-btn active" id="hx-inspector-toggle">Inspector</button>

        <!-- Structure panel toggle -->
        <button type="button" class="hx-toolbar-btn active" id="hx-structure-toggle" title="Toggle structure map panel">Structure</button>
    </div>

    <!-- Editor Body -->
    <div class="hx-editor-body" id="hx-editor-body">
        <div class="hx-hex-display" id="hx-hex-display">
            <div class="hx-hex-empty">
                <div class="hx-hex-empty-icon">&#128196;</div>
                <div class="hx-hex-empty-text">Open a file or paste data to begin</div>
                <div class="hx-hex-empty-hint">Drag &amp; drop anywhere, press Ctrl+O, or use the toolbar buttons</div>
            </div>
        </div>
        <div class="hx-inspector" id="hx-inspector">
            <div class="hx-inspector-section" id="hx-byte-info-panel">
                <div class="hx-inspector-empty">Click a byte to inspect</div>
            </div>
            <div class="hx-inspector-section" id="hx-region-info-panel"></div>
            <div class="hx-inspector-section" id="hx-stats-panel">
                <div class="hx-inspector-empty">Load data to view statistics</div>
            </div>
            <div class="hx-inspector-section" id="hx-structure-panel">
                <div class="hx-inspector-title">Structure Map</div>
                <div class="hx-inspector-empty">Load a recognized file to view structure</div>
            </div>
        </div>
    </div>

    <!-- Status Bar -->
    <div class="hx-status-bar" id="hx-status-bar">
        <span class="hx-status-filetype hidden" id="hx-status-filetype"></span>
        <span class="hx-status-sep"></span>
        <span class="hx-status-item" id="hx-status-file">No file loaded</span>
        <span class="hx-status-sep"></span>
        <span class="hx-status-item" id="hx-status-size">0 B</span>
        <span class="hx-status-sep"></span>
        <span class="hx-status-item" id="hx-status-offset">-</span>
        <span class="hx-status-sep"></span>
        <span class="hx-status-item" id="hx-status-format">Hex</span>
        <span class="hx-status-sep"></span>
        <span class="hx-status-item">UTF-8</span>
    </div>

    <!-- Popovers (hidden by default) -->
    <div class="hx-popover" id="hx-text-popover">
        <div class="hx-popover-title">Paste Text</div>
        <textarea id="hx-text-input" placeholder="Type or paste text here..." rows="5"></textarea>
        <button type="button" class="hx-popover-btn" id="hx-text-btn">Generate Hex Dump</button>
    </div>
    <div class="hx-popover" id="hx-hex-popover">
        <div class="hx-popover-title">Paste Hex</div>
        <textarea id="hx-hex-input" placeholder="48 65 6C 6C 6F 20 57 6F 72 6C 64" rows="5"></textarea>
        <button type="button" class="hx-popover-btn" id="hx-hex-btn">Parse Hex Input</button>
    </div>
</main>

<!-- Full-page drop overlay -->
<div class="hx-drop-overlay" id="hx-drop-overlay">
    <div class="hx-drop-overlay-icon">&#128230;</div>
    <div class="hx-drop-overlay-text">Drop file to open</div>
    <div class="hx-drop-overlay-hint">Release to analyze file contents</div>
</div>

<!-- Ad between editor and educational content -->
<div style="max-width:1200px;margin:1.5rem auto;padding:0 1rem;">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- ===== Educational Content ===== -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- How to Use -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">How to Use the Hex Dump Viewer</h2>
        <div class="hx-guide-grid">
            <div class="hx-guide-card">
                <h4>1. Load Your Data</h4>
                <p>Drag and drop any file onto the drop zone, or switch to Text/Hex mode to paste content directly. The tool processes everything in your browser.</p>
            </div>
            <div class="hx-guide-card">
                <h4>2. Customize the View</h4>
                <p>Switch between hex, decimal, octal, and binary formats. Adjust bytes per line (8/16/24/32) and grouping to match your analysis needs.</p>
            </div>
            <div class="hx-guide-card">
                <h4>3. Search & Inspect</h4>
                <p>Search for byte patterns like file signatures (50 4B for ZIP, 89 50 4E 47 for PNG). Click any byte to see all its representations in the Byte Inspector.</p>
            </div>
            <div class="hx-guide-card">
                <h4>4. Export Results</h4>
                <p>Copy the hex dump to clipboard, download as plain text, or export as C, Python, Go, or Rust source code arrays for embedding in your projects.</p>
            </div>
        </div>
    </div>

    <!-- What is a Hex Dump -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">What is a Hex Dump?</h2>
        <div style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);">
            <p style="margin:0 0 1rem;">A <strong>hex dump</strong> (or hexadecimal dump) is a representation of binary data where each byte is displayed as a two-digit hexadecimal number. It is the standard way to inspect and analyze binary files, network packets, memory contents, and raw data at the byte level.</p>
            <p style="margin:0 0 1rem;">The traditional hex dump format shows three columns: the <strong>offset</strong> (byte position), the <strong>hex values</strong> (16 bytes per line), and the <strong>ASCII interpretation</strong> (printable characters or dots for non-printable bytes). This format is used by Unix tools like <code>xxd</code>, <code>hexdump</code>, and <code>od</code>.</p>
            <p style="margin:0;">Hex dumps are essential in <strong>reverse engineering</strong>, <strong>malware analysis</strong>, <strong>network protocol debugging</strong>, <strong>file format research</strong>, and <strong>digital forensics</strong>. Understanding hex representation is a fundamental skill for software developers, security researchers, and system administrators.</p>
        </div>
    </div>

    <!-- Export Formats -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">Export Formats Reference</h2>
        <div class="hx-export-grid">
            <div class="hx-export-card">
                <div class="hx-export-card-lang">C</div>
                <h4>C Array</h4>
                <p>Unsigned char array with length constant</p>
                <code>unsigned char data[] = {
  0x48, 0x65, 0x6C
};</code>
            </div>
            <div class="hx-export-card">
                <div class="hx-export-card-lang">Py</div>
                <h4>Python Bytes</h4>
                <p>Python bytes literal with hex values</p>
                <code>data = bytes([
  0x48, 0x65, 0x6C
])</code>
            </div>
            <div class="hx-export-card">
                <div class="hx-export-card-lang">Go</div>
                <h4>Go Byte Slice</h4>
                <p>Go []byte variable declaration</p>
                <code>var Data = []byte{
  0x48, 0x65, 0x6C,
}</code>
            </div>
            <div class="hx-export-card">
                <div class="hx-export-card-lang">Rs</div>
                <h4>Rust Byte Array</h4>
                <p>Rust const &amp;[u8] static reference</p>
                <code>const DATA: &[u8] = &[
  0x48, 0x65, 0x6C
];</code>
            </div>
        </div>
    </div>

    <!-- Real-World Applications -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">Real-World Applications</h2>
        <div class="hx-guide-grid">
            <div class="hx-guide-card">
                <h4>Reverse Engineering</h4>
                <p>Analyze executable file headers, identify embedded resources, inspect PE/ELF/Mach-O binary structures, and understand file format internals.</p>
            </div>
            <div class="hx-guide-card">
                <h4>Malware Analysis</h4>
                <p>Detect packed or encrypted sections by entropy analysis, find embedded URLs/IPs in malware samples, and identify obfuscation techniques.</p>
            </div>
            <div class="hx-guide-card">
                <h4>Protocol Debugging</h4>
                <p>Inspect network packet captures, analyze TLS handshakes, debug custom binary protocols, and verify data encoding correctness.</p>
            </div>
            <div class="hx-guide-card">
                <h4>Digital Forensics</h4>
                <p>Recover deleted file fragments, identify file types by magic bytes, analyze disk images, and examine file system metadata.</p>
            </div>
        </div>
    </div>

    <!-- FAQ -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;" id="faqs">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">Frequently Asked Questions</h2>

        <div class="hx-faq-item">
            <button class="hx-faq-question" onclick="toggleHxFaq(this)">
                What is a hex dump and how do I read one?
                <svg class="hx-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="hx-faq-answer">A hex dump displays file contents as hexadecimal values alongside their ASCII text representation. Each line shows an offset address (position in the file), hex byte values (typically 16 per line), and printable ASCII characters. Non-printable bytes appear as dots. This lets you inspect binary file structures, find magic bytes, and analyze data at the byte level.</div>
        </div>

        <div class="hx-faq-item">
            <button class="hx-faq-question" onclick="toggleHxFaq(this)">
                How do I convert a file to hex dump online?
                <svg class="hx-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="hx-faq-answer">Drag and drop any file onto the drop zone, or click to browse. The tool reads the file entirely in your browser using the FileReader API and displays the hex dump instantly. No data is uploaded to any server. You can also paste text or raw hex values as input.</div>
        </div>

        <div class="hx-faq-item">
            <button class="hx-faq-question" onclick="toggleHxFaq(this)">
                What do the offset, hex, and ASCII columns mean?
                <svg class="hx-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="hx-faq-answer">The offset column shows the byte position in hexadecimal (e.g., 00000010 means byte 16). The hex column displays each byte as a two-digit hex value (00 to FF). The ASCII column shows the character representation where printable characters (0x20 to 0x7E) display normally and non-printable bytes show as dots.</div>
        </div>

        <div class="hx-faq-item">
            <button class="hx-faq-question" onclick="toggleHxFaq(this)">
                How do I search for byte patterns in a hex dump?
                <svg class="hx-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="hx-faq-answer">Enter hex values separated by spaces in the search box (e.g., 50 4B 03 04 for ZIP file headers). The tool highlights all occurrences and shows the match count. It automatically scrolls to the first match. This is useful for finding file signatures, magic bytes, and specific data sequences.</div>
        </div>

        <div class="hx-faq-item">
            <button class="hx-faq-question" onclick="toggleHxFaq(this)">
                What is file entropy and why does it matter?
                <svg class="hx-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="hx-faq-answer">Entropy measures the randomness of bytes in a file, ranging from 0 (all identical bytes) to 8 bits (maximum randomness). High entropy (above 7.5) suggests encrypted or compressed data. Low entropy indicates structured text or repeated patterns. Security analysts use entropy to detect encrypted payloads, packed executables, or steganographic content.</div>
        </div>

        <div class="hx-faq-item">
            <button class="hx-faq-question" onclick="toggleHxFaq(this)">
                Can I export hex data as a C or Python array?
                <svg class="hx-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="hx-faq-answer">Yes. Click the export buttons in the toolbar to download your data as a C unsigned char array, Python bytes literal, Go byte slice, or Rust byte array. Each export generates valid, compilable source code with proper formatting and length constants.</div>
        </div>

        <div class="hx-faq-item">
            <button class="hx-faq-question" onclick="toggleHxFaq(this)">
                How do I analyze binary file headers with a hex dump?
                <svg class="hx-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="hx-faq-answer">File headers contain magic bytes that identify the file type. For example, PDF files start with 25 50 44 46 (%PDF), PNG with 89 50 4E 47, ZIP with 50 4B 03 04. Use the search feature to find these signatures. The Byte Inspector lets you click any byte to see its decimal, octal, binary, and character values.</div>
        </div>

        <div class="hx-faq-item">
            <button class="hx-faq-question" onclick="toggleHxFaq(this)">
                Is this hex dump tool safe for sensitive files?
                <svg class="hx-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="hx-faq-answer">Yes. All processing happens entirely in your browser using JavaScript. Files are read via the FileReader API and never leave your computer. No data is sent to any server. The tool works offline after loading. This makes it safe for analyzing confidential documents, proprietary binaries, or security-sensitive files.</div>
        </div>
    </div>

    <!-- Related Tools -->
    <div class="tool-card" style="padding:1.5rem 2rem;margin-bottom:1.5rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Developer Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/Base64Functions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#2563eb,#60a5fa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.75rem;color:#fff;font-weight:700;">B64</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Base64 Encoder/Decoder</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Encode and decode Base64 strings and files</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/HashFunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#dc2626,#ef4444);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.75rem;color:#fff;font-weight:700;">#</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Hash Functions</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">MD5, SHA-1, SHA-256, SHA-512 hash generator</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/CipherFunctions.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#7c3aed,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:0.75rem;color:#fff;font-weight:700;">AES</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Cipher Functions</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">AES, DES, Blowfish encryption and decryption</p>
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

<!-- Scripts -->
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/js/hexdump-engine.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/js/hexdump-formats.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/js/hexdump-analyzer.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/js/hexdump-render.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/js/hexdump-export.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/js/hexdump-editor.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/js/hexdump-core.js?v=<%=cacheVersion%>" defer></script>
<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>

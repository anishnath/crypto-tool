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
        <jsp:param name="toolName" value="Steganography Tool - Hide Data in Images & Audio" />
        <jsp:param name="toolDescription" value="Free online steganography tool: hide messages and files in images or WAV audio. Variable bit depth (0-7), AES-256 encryption, deflate compression, Reed-Solomon error correction, forensic scanner with 18+ methods. 100% client-side." />
        <jsp:param name="toolCategory" value="Cryptography" />
        <jsp:param name="toolUrl" value="steganography-tool.jsp" />
        <jsp:param name="toolKeywords" value="steganography tool, hide message in image, audio steganography, WAV steganography, LSB encoding, variable bit depth, Reed-Solomon error correction, image steganography, AES-256 encryption, hide file in image, bit plane viewer, forensic steganalysis, steganography online, encode decode image, deflate compression, CTF steganography, steganography analyzer, file embedding steganography, digital steganography, LSB bit plane analysis" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="LSB steganography encoding and decoding,Variable bit depth 0-7 for up to 8x capacity,Audio WAV steganography with PCM sample embedding,Reed-Solomon error correction survives image edits,Deflate compression for 2-5x smaller payloads,Hide arbitrary files (PDF ZIP TXT) inside images or audio,AES-256-GCM encryption with PBKDF2 key derivation,Visual LSB bit plane analyzer per channel and plane,Forensic scanner with 18+ extraction methods,Auto-generate cover images with 4 pattern styles,Real-time capacity meter with depth-aware calculation,100% client-side processing - zero server uploads,Supports 8-bit 16-bit 24-bit and 32-bit WAV files,Three-mode interface: Encode Decode and Analyze,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="High School, College, Professional" />
        <jsp:param name="teaches" value="Steganography, LSB encoding, audio steganography, variable bit depth, Reed-Solomon codes, AES-256 encryption, PBKDF2 key derivation, bit plane analysis, steganalysis, data hiding, digital forensics, Galois field arithmetic, error correction" />
        <jsp:param name="howToSteps" value="Choose Image or Audio medium|Select Image to hide data in PNG/JPEG/BMP images or Audio WAV to hide data in WAV audio files,Upload or generate a cover file|Upload an image or WAV file or click an auto-generated pattern style like Gradient Mesh or Geometric Shapes,Select Message or File mode|Switch between the Message sub-tab to hide text or the File sub-tab to embed any file type such as PDF ZIP or TXT,Configure encoding options|Set bit depth (0-7) and mode (At bit N or Bits 0..N) to control capacity. Enable Deflate compression for smaller payloads or Reed-Solomon for error resilience,Set AES-256 password (optional)|Add a password for AES-256-GCM authenticated encryption using PBKDF2 with 100000 iterations of SHA-256,Click Hide Message and download|Press Hide Message to embed your data then download the resulting PNG or WAV file which looks or sounds identical to the original,Decode with matching settings|To extract upload the stego file and set the same bit depth and mode used during encoding. RS-protected messages auto-detect and self-correct errors,Analyze with forensic tools|Switch to Analyze mode to inspect bit planes per RGB channel or run the forensic scanner with 18+ extraction methods" />
        <jsp:param name="faq1q" value="What is steganography and how does it work?" />
        <jsp:param name="faq1a" value="Steganography is the practice of hiding secret information within ordinary data such as images or audio so that no one apart from the sender and recipient knows of its existence. This tool uses Least Significant Bit (LSB) encoding which modifies the least important bits of pixel color channels or audio samples. Since these tiny changes are invisible to the human eye and inaudible to the ear the carrier file looks and sounds identical but carries a hidden message." />
        <jsp:param name="faq2q" value="What is variable bit depth and how does it increase capacity?" />
        <jsp:param name="faq2a" value="Variable bit depth lets you embed data in bit positions 0 through 7 of each color channel instead of just the LSB. In At bit N mode you use a single bit position for stealth while in Bits 0..N mode you use multiple bits per channel for up to 8x the standard capacity. Higher bit depths modify more significant bits so there is a tradeoff between capacity and visual quality. Bit depth 0-2 is virtually undetectable while depth 3-7 gives maximum capacity for CTF challenges or large payloads." />
        <jsp:param name="faq3q" value="Can I hide data in audio WAV files?" />
        <jsp:param name="faq3a" value="Yes this tool supports audio WAV steganography. Switch to the Audio WAV medium then upload any PCM WAV file as a cover. The tool embeds data in the least significant bits of audio samples supporting 8-bit 16-bit 24-bit and 32-bit sample formats in mono or stereo. Audio steganography works just like image steganography with variable bit depth support. The output WAV sounds identical to the original but contains your hidden message or file." />
        <jsp:param name="faq4q" value="What is Reed-Solomon error correction and why use it?" />
        <jsp:param name="faq4a" value="Reed-Solomon is an error-correcting code that adds redundant parity bytes to your data so it can survive corruption. When enabled your message can be recovered even after minor image edits JPEG recompression screenshots or social media processing. Choose Low (16 bytes) Medium (32 bytes) or High (48 bytes) parity. RS uses GF(2^8) Galois field arithmetic with Berlekamp-Massey decoding to automatically detect and correct errors during extraction." />
        <jsp:param name="faq5q" value="How does the Deflate compression work?" />
        <jsp:param name="faq5a" value="Enabling Compress (Deflate) applies real deflate compression to your message before embedding reducing payload size by 2-5x for typical text. This means you can fit longer messages into smaller images. The tool uses the browser native CompressionStream API for fast compression. On decoding the tool auto-detects compressed data and decompresses transparently." />
        <jsp:param name="faq6q" value="Is my data safe? Does this tool upload anything?" />
        <jsp:param name="faq6a" value="Your data is completely safe. This tool processes everything 100% client-side in your browser using the HTML5 Canvas API Web Crypto API and JavaScript. No images audio files messages or passwords are ever uploaded to any server. All encoding decoding encryption compression and analysis happens locally on your device. You can verify this by disconnecting from the internet and confirming the tool still works." />
        <jsp:param name="faq7q" value="How much data can I hide in an image or audio file?" />
        <jsp:param name="faq7a" value="For images at the default LSB depth the capacity is (width x height x 3) / 8 bytes. An 800x600 image stores about 180 KB. Using variable bit depth in Bits 0..N mode multiplies capacity by up to 8x. For WAV audio the capacity depends on the number of samples and bit depth. A 10-second 44100 Hz mono WAV at LSB depth stores about 55 KB. The real-time capacity meter updates as you change depth settings." />
        <jsp:param name="faq8q" value="What is the forensic scanner and how many formats does it support?" />
        <jsp:param name="faq8a" value="The forensic scanner is a universal decoder that automatically tries 18 or more extraction methods to find hidden messages regardless of which steganography tool was used to encode them. It supports formats from OpenStego Python steganography libraries JavaScript tools and various LSB encoding configurations including different channel orders (RGB BGR) bit orders (MSB LSB) length header formats (BE32 LE32 LE16) and terminators. Results are ranked by confidence score." />
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
      "headline": "Steganography Tool: Hide Data in Images & Audio with Error Correction",
      "description": "Free online steganography suite: hide text or files in images and WAV audio with variable bit depth (0-7), AES-256 encryption, deflate compression, and Reed-Solomon error correction. 18+ forensic extraction methods. 100% client-side.",
      "about": [
        {
          "@type": "Thing",
          "name": "Steganography",
          "alternateName": ["Image steganography", "Audio steganography", "LSB steganography", "Data hiding", "WAV steganography"],
          "description": "The practice of concealing messages, files, or information within other non-secret data such as images or audio to avoid detection. Digital steganography modifies the least significant bits of pixel color channels or audio samples.",
          "sameAs": [
            "https://en.wikipedia.org/wiki/Steganography",
            "https://en.wikipedia.org/wiki/Least_significant_bit"
          ]
        },
        {
          "@type": "Thing",
          "name": "Reed-Solomon Error Correction",
          "alternateName": ["RS codes", "Reed-Solomon codes"],
          "description": "An error-correcting code that adds redundant parity bytes using GF(2^8) Galois field arithmetic, allowing hidden data to survive minor image edits, JPEG recompression, or social media processing. Uses Berlekamp-Massey decoding algorithm.",
          "sameAs": "https://en.wikipedia.org/wiki/Reed%E2%80%93Solomon_error_correction"
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
      "dateModified": "2026-03-01",
      "inLanguage": "en-US",
      "keywords": "steganography, LSB encoding, audio steganography, WAV steganography, variable bit depth, Reed-Solomon error correction, AES-256 encryption, hide file in image, bit plane analysis, steganalysis, forensic scanner, deflate compression, CTF steganography, PBKDF2, data hiding, Galois field arithmetic"
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- Inlined CSS: design-system + nav + three-column-tool + tool-page + ads + dark-mode + footer + search + steganography-tool — Chanterelle theme -->
    <style>
/* ============ modern/css/design-system.css ============ */
/**
 * 8gwifi.org Modern Design System
 * Mobile-first, modern CSS with custom properties
 * Version: 1.0.0
 */

/* ============================================
   CSS RESET & BASE
   ============================================ */
*,
*::before,
*::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

html {
    scroll-behavior: smooth;
    -webkit-text-size-adjust: 100%;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

body {
    font-family: var(--font-sans);
    font-size: var(--text-base);
    line-height: var(--leading-normal);
    color: var(--text-primary);
    background-color: var(--bg-primary);
}

/* ============================================
   CSS VARIABLES - DESIGN TOKENS
   ============================================ */

:root,
:root[data-theme="light"] {
    /* ========== COLORS ========== */
    
    /* Primary Colors */
    --primary: #d39144;
    --primary-dark: #a17b3a;
    --primary-light: #e0b074;
    --primary-50: #fdf6e9;
    --primary-100: #f9ead0;
    
    /* Neutral Colors */
    --bg-primary: #ffffff;
    --bg-secondary: #f8fafc;
    --bg-tertiary: #f1f5f9;
    --bg-hover: #f8fafc;
    
    /* Text Colors */
    --text-primary: #0f172a;
    --text-secondary: #475569;
    --text-muted: #94a3b8;
    --text-inverse: #ffffff;
    
    /* Border Colors */
    --border: #e2e8f0;
    --border-light: #f1f5f9;
    --border-dark: #cbd5e1;
    
    /* Semantic Colors */
    --success: #10b981;
    --success-light: #d1fae5;
    --warning: #f59e0b;
    --warning-light: #fef3c7;
    --error: #ef4444;
    --error-light: #fee2e2;
    --info: #3b82f6;
    --info-light: #dbeafe;
    
    /* ========== TYPOGRAPHY ========== */
    
    /* Font Families */
    --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    --font-mono: 'JetBrains Mono', 'Fira Code', 'SF Mono', Consolas, 'Liberation Mono', Menlo, monospace;
    
    /* Font Sizes */
    --text-xs: 0.75rem;      /* 12px */
    --text-sm: 0.875rem;     /* 14px */
    --text-base: 1rem;       /* 16px */
    --text-lg: 1.125rem;     /* 18px */
    --text-xl: 1.25rem;      /* 20px */
    --text-2xl: 1.5rem;      /* 24px */
    --text-3xl: 1.875rem;    /* 30px */
    --text-4xl: 2.25rem;     /* 36px */
    
    /* Line Heights */
    --leading-tight: 1.25;
    --leading-normal: 1.5;
    --leading-relaxed: 1.75;
    
    /* Font Weights */
    --font-normal: 400;
    --font-medium: 500;
    --font-semibold: 600;
    --font-bold: 700;
    
    /* ========== SPACING ========== */
    
    --space-1: 0.25rem;   /* 4px */
    --space-2: 0.5rem;    /* 8px */
    --space-3: 0.75rem;   /* 12px */
    --space-4: 1rem;      /* 16px */
    --space-5: 1.25rem;   /* 20px */
    --space-6: 1.5rem;    /* 24px */
    --space-8: 2rem;      /* 32px */
    --space-10: 2.5rem;   /* 40px */
    --space-12: 3rem;     /* 48px */
    --space-16: 4rem;     /* 64px */
    
    /* ========== SHADOWS ========== */
    
    --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
    --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1);
    --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
    --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
    --shadow-2xl: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
    
    /* ========== BORDER RADIUS ========== */
    
    --radius-sm: 0.375rem;   /* 6px */
    --radius-md: 0.5rem;     /* 8px */
    --radius-lg: 0.75rem;    /* 12px */
    --radius-xl: 1rem;       /* 16px */
    --radius-2xl: 1.5rem;    /* 24px */
    --radius-full: 9999px;
    
    /* ========== Z-INDEX SCALE ========== */
    
    --z-dropdown: 1000;
    --z-sticky: 1020;
    --z-fixed: 1030;
    --z-modal-backdrop: 1040;
    --z-modal: 1050;
    --z-popover: 1060;
    --z-tooltip: 1070;
    
    /* ========== TRANSITIONS ========== */
    
    --transition-fast: 150ms ease-in-out;
    --transition-base: 200ms ease-in-out;
    --transition-slow: 300ms ease-in-out;
    
    /* ========== LAYOUT ========== */
    
    --header-height-mobile: 64px;
    --header-height-desktop: 72px;
    --sidebar-width: 280px;
    --sidebar-width-collapsed: 0px;
    --container-max-width: 1280px;
    --content-max-width: 1200px;
}

/* ============================================
   DARK MODE SUPPORT
   ============================================ */

@media (prefers-color-scheme: dark) {
    :root {
        --bg-primary: #0f172a;
        --bg-secondary: #1e293b;
        --bg-tertiary: #334155;
        --bg-hover: #1e293b;
        
        --text-primary: #f1f5f9;
        --text-secondary: #cbd5e1;
        --text-muted: #94a3b8;
        
        --border: #334155;
        --border-light: #475569;
        --border-dark: #64748b;
    }
}

[data-theme="dark"] {
    --bg-primary: #0f172a;
    --bg-secondary: #1e293b;
    --bg-tertiary: #334155;
    --bg-hover: #1e293b;
    
    --text-primary: #f1f5f9;
    --text-secondary: #cbd5e1;
    --text-muted: #94a3b8;
    
    --border: #334155;
    --border-light: #475569;
    --border-dark: #64748b;
}

/* Apply dark mode background to body */
[data-theme="dark"] body {
    background-color: var(--bg-primary);
    color: var(--text-primary);
}

/* ============================================
   RESPONSIVE BREAKPOINTS
   ============================================ */

/* Mobile-first approach */
/* Default: Mobile (< 768px) */

/* Tablet */
@media (min-width: 768px) {
    :root {
        --header-height-mobile: 72px;
    }
}

/* Desktop */
@media (min-width: 992px) {
    /* Desktop-specific overrides */
}

/* Large Desktop */
@media (min-width: 1400px) {
    /* Large desktop optimizations */
}

/* ============================================
   UTILITY CLASSES
   ============================================ */

/* Screen Reader Only */
.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border-width: 0;
}

/* Container */
.container-modern {
    width: 100%;
    margin-left: auto;
    margin-right: auto;
    padding-left: var(--space-4);
    padding-right: var(--space-4);
}

@media (min-width: 768px) {
    .container-modern {
        padding-left: var(--space-6);
        padding-right: var(--space-6);
    }
}

@media (min-width: 1280px) {
    .container-modern {
        max-width: var(--container-max-width);
    }
}

/* Focus Visible */
*:focus-visible {
    outline: 2px solid var(--primary);
    outline-offset: 2px;
}

/* ============================================
   ACCESSIBILITY
   ============================================ */

/* Reduce motion for users who prefer it */
@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}

/* High contrast mode support */
@media (prefers-contrast: high) {
    :root {
        --border: #000000;
        --text-secondary: #000000;
    }
}


/* ============ modern/css/navigation.css ============ */
/**
 * Modern Navigation System
 * Mobile-first, no Bootstrap dependency
 */

/* ============================================
   HEADER NAVIGATION
   ============================================ */

.modern-nav {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: var(--z-fixed, 1030);
    background: var(--bg-primary, #ffffff);
    border-bottom: 1px solid var(--border, #e2e8f0);
    box-shadow: var(--shadow-sm, 0 1px 2px rgba(0,0,0,0.05));
    height: var(--header-height-desktop, 72px);
}

.nav-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 var(--space-4, 1rem);
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 100%;
}

/* Logo */
.nav-logo {
    display: flex;
    align-items: center;
    gap: var(--space-3, 0.75rem);
    text-decoration: none;
    font-weight: 700;
    font-size: var(--text-lg, 1.125rem);
    transition: opacity 0.2s;
}

.nav-logo:hover {
    opacity: 0.8;
}

.nav-logo img {
    width: 32px;
    height: 32px;
    border-radius: var(--radius-md, 0.5rem);
}

.nav-logo span {
    background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #ec4899 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    color: var(--primary, #d39144); /* Fallback for browsers that don't support gradient text */
    font-weight: 700;
    letter-spacing: -0.02em;
}

/* Dark theme logo text */
[data-theme="dark"] .nav-logo span {
    background: linear-gradient(135deg, #818cf8 0%, #a78bfa 50%, #f472b6 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    color: var(--primary-light, #e0b074); /* Fallback */
}

/* Navigation Items */
.nav-items {
    display: flex;
    align-items: center;
    gap: var(--space-6, 1.5rem);
    list-style: none;
    margin: 0;
    padding: 0;
}

.nav-item {
    position: relative;
}

.nav-link {
    color: var(--text-secondary, #475569);
    text-decoration: none;
    font-weight: 500;
    font-size: var(--text-base, 1rem);
    padding: var(--space-2, 0.5rem) var(--space-3, 0.75rem);
    border-radius: var(--radius-md, 0.5rem);
    transition: all 0.2s;
    display: flex;
    align-items: center;
    gap: var(--space-2, 0.5rem);
}

.nav-link:hover {
    color: var(--primary, #d39144);
    background: var(--bg-secondary, #f8fafc);
}

.nav-link.active {
    color: var(--primary, #d39144);
    background: var(--primary-50, #fdf6e9);
}

/* Categories Dropdown */
.nav-item-dropdown {
    position: static;
}

.nav-link-dropdown {
    cursor: pointer;
    user-select: none;
    background: none;
    border: none;
    font-family: inherit;
}

.dropdown-arrow {
    font-size: 0.75rem;
    margin-left: 0.25rem;
    transition: transform 0.2s;
}

/* Mega-Menu */
.mega-menu {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: var(--bg-primary, #ffffff);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: var(--radius-lg, 0.75rem);
    box-shadow: var(--shadow-xl, 0 20px 25px rgba(0,0,0,0.1));
    margin-top: var(--space-2, 0.5rem);
    padding: var(--space-6, 1.5rem);
    max-height: 80vh;
    overflow-y: auto;
    z-index: var(--z-dropdown, 1020);
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.3s ease;
    max-width: 1400px;
    margin-left: auto;
    margin-right: auto;
}

.mega-menu.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.mega-menu-content {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: var(--space-6, 1.5rem);
}

.mega-menu-column {
    min-width: 0;
}

.mega-menu-category-header {
    display: flex;
    align-items: center;
    gap: var(--space-3, 0.75rem);
    margin-bottom: var(--space-4, 1rem);
    padding-bottom: var(--space-3, 0.75rem);
    border-bottom: 2px solid var(--border, #e2e8f0);
}

.mega-menu-icon {
    font-size: var(--text-2xl, 1.5rem);
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--bg-secondary, #f8fafc);
    border-radius: var(--radius-md, 0.5rem);
}

.mega-menu-category-name {
    font-weight: 600;
    font-size: var(--text-base, 1rem);
    color: var(--text-primary, #0f172a);
}

.mega-menu-tool-count {
    font-size: var(--text-sm, 0.875rem);
    color: var(--text-muted, #94a3b8);
}

.mega-menu-tool-list {
    list-style: none;
    margin: 0;
    padding: 0;
    max-height: 400px;
    overflow-y: auto;
    overflow-x: hidden;
}

.mega-menu-tool-list::-webkit-scrollbar {
    width: 6px;
}

.mega-menu-tool-list::-webkit-scrollbar-track {
    background: var(--bg-secondary, #f8fafc);
    border-radius: var(--radius-full, 9999px);
}

.mega-menu-tool-list::-webkit-scrollbar-thumb {
    background: var(--border-dark, #cbd5e1);
    border-radius: var(--radius-full, 9999px);
}

.mega-menu-tool-list::-webkit-scrollbar-thumb:hover {
    background: var(--text-muted, #94a3b8);
}

.mega-menu-tool-list li {
    margin-bottom: var(--space-2, 0.5rem);
}

.mega-menu-tool-link {
    display: flex;
    align-items: center;
    gap: var(--space-2, 0.5rem);
    padding: var(--space-2, 0.5rem) var(--space-3, 0.75rem);
    color: var(--text-secondary, #475569);
    text-decoration: none;
    border-radius: var(--radius-md, 0.5rem);
    font-size: var(--text-sm, 0.875rem);
    transition: all 0.2s;
}

.mega-menu-tool-link:hover {
    background: var(--bg-secondary, #f8fafc);
    color: var(--primary, #d39144);
    padding-left: var(--space-4, 1rem);
}

.tool-icon-small {
    font-size: 1em;
    line-height: 1;
    flex-shrink: 0;
    width: 1.25em;
    text-align: center;
}

.mega-menu-view-all {
    margin-top: var(--space-3, 0.75rem);
    padding-top: var(--space-3, 0.75rem);
    border-top: 1px solid var(--border, #e2e8f0);
}

.mega-menu-view-all-link {
    display: block;
    padding: var(--space-2, 0.5rem) var(--space-3, 0.75rem);
    color: var(--primary, #d39144);
    text-decoration: none;
    font-weight: 600;
    font-size: var(--text-sm, 0.875rem);
    transition: all 0.2s;
}

.mega-menu-view-all-link:hover {
    color: var(--primary-dark, #a17b3a);
    padding-left: var(--space-4, 1rem);
}

/* Search Bar */
.nav-search {
    position: relative;
    flex: 1;
    max-width: 500px;
    margin: 0 var(--space-6, 1.5rem);
}

.search-input {
    width: 100%;
    padding: var(--space-2, 0.5rem) var(--space-10, 2.5rem) var(--space-2, 0.5rem) var(--space-4, 1rem);
    border: 2px solid var(--border, #e2e8f0);
    border-radius: var(--radius-full, 9999px);
    font-size: var(--text-sm, 0.875rem);
    background: var(--bg-secondary, #f8fafc);
    transition: all 0.2s;
    font-family: var(--font-sans);
}

.search-input:focus {
    outline: none;
    border-color: var(--primary, #d39144);
    background: var(--bg-primary, #ffffff);
    box-shadow: 0 0 0 3px oklch(0.759 0.155 65.8 / 0.1);
}

.search-icon {
    position: absolute;
    right: var(--space-4, 1rem);
    top: 50%;
    transform: translateY(-50%);
    color: var(--text-muted, #94a3b8);
    pointer-events: none;
}

/* Action Buttons */
.nav-actions {
    display: flex;
    align-items: center;
    gap: var(--space-3, 0.75rem);
}

.btn-nav {
    padding: var(--space-2, 0.5rem) var(--space-4, 1rem);
    border-radius: var(--radius-md, 0.5rem);
    font-size: var(--text-sm, 0.875rem);
    font-weight: 500;
    text-decoration: none;
    transition: all 0.2s;
    border: none;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: var(--space-2, 0.5rem);
    font-family: var(--font-sans);
}

.btn-nav-primary {
    background: var(--primary, #d39144);
    color: white;
}

.btn-nav-primary:hover {
    background: var(--primary-dark, #a17b3a);
    transform: translateY(-1px);
    box-shadow: var(--shadow-md, 0 4px 6px rgba(0,0,0,0.1));
}

.btn-nav-secondary {
    background: var(--bg-secondary, #f8fafc);
    color: var(--text-secondary, #475569);
    border: 1px solid var(--border, #e2e8f0);
}

.btn-nav-secondary:hover {
    background: var(--bg-tertiary, #f1f5f9);
    border-color: var(--primary, #d39144);
    color: var(--primary, #d39144);
}

/* Mobile Menu Toggle */
.mobile-menu-toggle {
    display: none;
    background: none;
    border: none;
    padding: var(--space-2, 0.5rem);
    cursor: pointer;
    color: var(--text-primary);
    font-size: var(--text-xl, 1.25rem);
    width: 40px;
    height: 40px;
    align-items: center;
    justify-content: center;
    border-radius: var(--radius-md, 0.5rem);
    transition: background 0.2s;
}

.mobile-menu-toggle:hover {
    background: var(--bg-secondary, #f8fafc);
}

/* Mobile Search Toggle */
.mobile-search-toggle {
    display: none;
    background: none;
    border: none;
    padding: var(--space-2, 0.5rem);
    cursor: pointer;
    color: var(--text-secondary);
    font-size: var(--text-lg, 1.125rem);
}

/* ============================================
   MOBILE NAVIGATION
   ============================================ */

@media (max-width: 991px) {
    .modern-nav {
        height: var(--header-height-mobile, 64px);
    }

    .nav-container {
        padding: 0 var(--space-3, 0.75rem);
    }

    .nav-search {
        display: none;
    }

    .nav-items {
        display: none;
    }

    .nav-actions {
        gap: var(--space-2, 0.5rem);
    }

    .btn-nav {
        padding: var(--space-2, 0.5rem) var(--space-3, 0.75rem);
        font-size: var(--text-xs, 0.75rem);
    }

    .mobile-menu-toggle,
    .mobile-search-toggle {
        display: flex;
    }

    /* Hide some nav actions on mobile */
    .btn-nav .nav-text {
        display: none;
    }
}

/* Mobile Drawer */
.mobile-drawer {
    position: fixed;
    top: var(--header-height-mobile, 64px);
    left: 0;
    right: 0;
    bottom: 0;
    background: var(--bg-primary, #ffffff);
    z-index: var(--z-modal, 1050);
    transform: translateX(-100%);
    transition: transform 0.3s ease-in-out;
    overflow-y: auto;
    box-shadow: var(--shadow-xl, 0 20px 25px rgba(0,0,0,0.1));
}

.mobile-drawer.open {
    transform: translateX(0);
}

.drawer-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: var(--z-modal-backdrop, 1040);
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease-in-out;
}

.drawer-overlay.open {
    opacity: 1;
    visibility: visible;
}

.drawer-header {
    padding: var(--space-4, 1rem);
    border-bottom: 1px solid var(--border, #e2e8f0);
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.drawer-title {
    font-size: var(--text-lg, 1.125rem);
    font-weight: 600;
    color: var(--text-primary);
    margin: 0;
}

.drawer-close {
    background: none;
    border: none;
    font-size: var(--text-2xl, 1.5rem);
    color: var(--text-secondary);
    cursor: pointer;
    padding: var(--space-1, 0.25rem);
    width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: var(--radius-md, 0.5rem);
    transition: all 0.2s;
}

.drawer-close:hover {
    background: var(--bg-secondary, #f8fafc);
    color: var(--text-primary);
}

.drawer-search {
    padding: var(--space-4, 1rem);
    border-bottom: 1px solid var(--border, #e2e8f0);
}

.drawer-content {
    padding: var(--space-4, 1rem);
}

.drawer-section {
    margin-bottom: var(--space-6, 1.5rem);
}

.drawer-section-title {
    font-size: var(--text-sm, 0.875rem);
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--text-muted, #94a3b8);
    margin-bottom: var(--space-3, 0.75rem);
    padding: 0 var(--space-2, 0.5rem);
}

.drawer-link {
    display: flex;
    align-items: center;
    gap: var(--space-3, 0.75rem);
    padding: var(--space-3, 0.75rem) var(--space-2, 0.5rem);
    color: var(--text-primary);
    text-decoration: none;
    border-radius: var(--radius-md, 0.5rem);
    transition: all 0.2s;
    font-size: var(--text-base, 1rem);
}

.drawer-link:hover {
    background: var(--bg-secondary, #f8fafc);
    color: var(--primary, #d39144);
    padding-left: var(--space-4, 1rem);
}

.drawer-link-icon {
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: var(--text-lg, 1.125rem);
    flex-shrink: 0;
}

.drawer-empty {
    padding: var(--space-4, 1rem);
    text-align: center;
    color: var(--text-muted, #94a3b8);
    font-size: var(--text-sm, 0.875rem);
    margin: 0;
}

.drawer-loading {
    padding: var(--space-4, 1rem);
    text-align: center;
    color: var(--text-muted, #94a3b8);
    font-size: var(--text-sm, 0.875rem);
    margin: 0;
}

/* Drawer Category Items */
.drawer-category-item {
    margin-bottom: var(--space-2, 0.5rem);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: var(--radius-md, 0.5rem);
    overflow: hidden;
}

.drawer-category-toggle {
    width: 100%;
    padding: var(--space-3, 0.75rem) var(--space-4, 1rem);
    background: var(--bg-secondary, #f8fafc);
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: var(--space-3, 0.75rem);
    font-family: inherit;
    font-size: var(--text-base, 1rem);
    font-weight: 500;
    color: var(--text-primary, #0f172a);
    transition: background 0.2s;
    text-align: left;
}

.drawer-category-toggle:hover {
    background: var(--bg-tertiary, #f1f5f9);
}

.drawer-category-icon {
    font-size: var(--text-xl, 1.25rem);
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.drawer-category-name {
    flex: 1;
    font-weight: 600;
}

.drawer-category-count {
    font-size: var(--text-sm, 0.875rem);
    color: var(--text-muted, #94a3b8);
    background: var(--bg-primary, #ffffff);
    padding: var(--space-1, 0.25rem) var(--space-2, 0.5rem);
    border-radius: var(--radius-full, 9999px);
}

.drawer-category-arrow {
    font-size: var(--text-sm, 0.875rem);
    color: var(--text-muted, #94a3b8);
    transition: transform 0.2s;
}

.drawer-category-content {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.3s ease;
    background: var(--bg-primary, #ffffff);
}

.drawer-category-content.open {
    max-height: 600px;
    overflow-y: auto;
    overflow-x: hidden;
}

.drawer-category-content.open::-webkit-scrollbar {
    width: 6px;
}

.drawer-category-content.open::-webkit-scrollbar-track {
    background: var(--bg-secondary, #f8fafc);
}

.drawer-category-content.open::-webkit-scrollbar-thumb {
    background: var(--border-dark, #cbd5e1);
    border-radius: var(--radius-full, 9999px);
}

.drawer-category-content.open::-webkit-scrollbar-thumb:hover {
    background: var(--text-muted, #94a3b8);
}

.drawer-category-tools {
    padding: var(--space-3, 0.75rem) var(--space-4, 1rem);
    display: flex;
    flex-direction: column;
    gap: var(--space-2, 0.5rem);
}

.drawer-tool-link {
    display: block;
    padding: var(--space-2, 0.5rem) var(--space-3, 0.75rem);
    color: var(--text-secondary, #475569);
    text-decoration: none;
    border-radius: var(--radius-md, 0.5rem);
    font-size: var(--text-sm, 0.875rem);
    transition: all 0.2s;
    margin-left: var(--space-8, 2rem);
}

.drawer-tool-link:hover {
    background: var(--bg-secondary, #f8fafc);
    color: var(--primary, #d39144);
    padding-left: var(--space-4, 1rem);
}

.drawer-view-all {
    display: block;
    padding: var(--space-2, 0.5rem) var(--space-3, 0.75rem);
    color: var(--primary, #d39144);
    text-decoration: none;
    font-weight: 600;
    font-size: var(--text-sm, 0.875rem);
    margin-left: var(--space-8, 2rem);
    margin-top: var(--space-2, 0.5rem);
    transition: all 0.2s;
}

.drawer-view-all:hover {
    color: var(--primary-dark, #a17b3a);
    padding-left: var(--space-4, 1rem);
}

/* Mobile Search Modal */
.mobile-search-modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: var(--bg-primary, #ffffff);
    z-index: var(--z-modal, 1050);
    display: none;
    flex-direction: column;
}

.mobile-search-modal.open {
    display: flex;
}

.mobile-search-header {
    padding: var(--space-4, 1rem);
    border-bottom: 1px solid var(--border, #e2e8f0);
    display: flex;
    align-items: center;
    gap: var(--space-3, 0.75rem);
}

.mobile-search-input {
    flex: 1;
    padding: var(--space-3, 0.75rem) var(--space-4, 1rem);
    border: 2px solid var(--border, #e2e8f0);
    border-radius: var(--radius-md, 0.5rem);
    font-size: var(--text-base, 1rem);
    font-family: var(--font-sans);
}

.mobile-search-input:focus {
    outline: none;
    border-color: var(--primary, #d39144);
    box-shadow: 0 0 0 3px oklch(0.759 0.155 65.8 / 0.1);
}

.mobile-search-close {
    background: none;
    border: none;
    font-size: var(--text-xl, 1.25rem);
    color: var(--text-secondary);
    cursor: pointer;
    padding: var(--space-2, 0.5rem);
}

/* Dark Mode Styles */
[data-theme="dark"] .mega-menu {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .mega-menu-category-header {
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .mega-menu-icon {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .mega-menu-tool-link:hover,
[data-theme="dark"] .drawer-tool-link:hover {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .drawer-category-toggle {
    background: var(--bg-secondary, #1e293b);
}

[data-theme="dark"] .drawer-category-toggle:hover {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .drawer-category-content {
    background: var(--bg-secondary, #1e293b);
}

[data-theme="dark"] .drawer-category-count {
    background: var(--bg-tertiary, #334155);
}

/* ============================================
   RESPONSIVE
   ============================================ */

@media (max-width: 991px) {
    .mega-menu {
        left: var(--space-4, 1rem);
        right: var(--space-4, 1rem);
        max-width: none;
    }
    
    .mega-menu-content {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 767px) {
    .nav-logo span {
        display: inline-block; /* Show on mobile */
        font-size: var(--text-sm, 0.875rem); /* Slightly smaller on mobile */
    }

    .nav-logo {
        font-size: var(--text-base, 1rem);
        gap: var(--space-2, 0.5rem); /* Tighter gap on mobile */
    }
    
    .nav-logo img {
        width: 28px; /* Slightly smaller logo on mobile */
        height: 28px;
    }
    
    .mega-menu {
        display: none; /* Hide mega-menu on mobile, use drawer instead */
    }
}


/* ============ modern/css/three-column-tool.css ============ */
/**
 * Three-Column Tool Page Layout
 * Generic styles for tool pages with Input | Output | Ads layout
 *
 * Usage: Include this CSS and use .tool-* classes
 * For tool-specific theming, define CSS variables:
 *   --tool-primary: #326ce5;
 *   --tool-primary-dark: #1d4ed8;
 *   --tool-gradient: linear-gradient(135deg, #326ce5 0%, #1d4ed8 100%);
 *   --tool-light: #eff6ff;
 */

/* ========================================
   CSS VARIABLES (Defaults)
   ======================================== */
:root {
    --tool-primary: var(--primary, #d39144);
    --tool-primary-dark: var(--primary-dark, #a17b3a);
    --tool-gradient: linear-gradient(135deg, var(--tool-primary) 0%, var(--tool-primary-dark) 100%);
    --tool-light: #fdf6e9;
}

/* ========================================
   THREE COLUMN LAYOUT
   ======================================== */
.tool-page-container {
    display: grid;
    grid-template-columns: minmax(320px, 400px) 1fr 300px;
    gap: 1.5rem;
    max-width: 1600px;
    margin: 0 auto;
    padding: 1.5rem;
    min-height: calc(100vh - 180px);
}

@media (max-width: 1024px) {
    .tool-page-container {
        grid-template-columns: minmax(300px, 380px) 1fr;
    }
    .tool-ads-column { display: none; }
}

@media (max-width: 900px) {
    .tool-page-container {
        grid-template-columns: 1fr;
        gap: 1rem;
        display: flex;
        flex-direction: column;
    }

    .tool-input-column {
        position: relative;
        top: auto;
        max-height: none;
        overflow-y: visible;
        z-index: 1;
        order: 1;
    }

    .tool-output-column {
        display: flex !important;
        min-height: 350px;
        position: relative;
        z-index: 2;
        order: 2;
    }

    .tool-output-wrapper {
        min-height: 300px;
        width: 100%;
    }

    .tool-ads-column {
        order: 3;
    }

    .tool-empty-state {
        padding: 2rem 1rem;
    }

    .tool-empty-state svg {
        width: 60px;
        height: 60px;
    }

    .tool-empty-state p {
        font-size: 0.8125rem;
    }
}

/* ========================================
   INPUT COLUMN (Sticky)
   ======================================== */
.tool-input-column {
    position: sticky;
    top: 90px;
    height: fit-content;
    max-height: calc(100vh - 110px);
    overflow-y: auto;
}

.tool-input-column::-webkit-scrollbar {
    width: 5px;
}

.tool-input-column::-webkit-scrollbar-thumb {
    background: var(--tool-primary);
    border-radius: 3px;
}

/* ========================================
   OUTPUT COLUMN
   ======================================== */
.tool-output-column {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

/* ========================================
   ADS COLUMN
   ======================================== */
.tool-ads-column {
    height: fit-content;
}

/* ========================================
   CARD STYLES
   ======================================== */
.tool-card {
    background: var(--bg-primary, #ffffff);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.75rem;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.tool-card-header {
    background: var(--tool-gradient);
    color: white;
    padding: 0.875rem 1rem;
    font-weight: 600;
    font-size: 0.9375rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.tool-card-body {
    padding: 1rem;
}

/* ========================================
   TABS
   ======================================== */
.tool-tabs {
    display: flex;
    gap: 0.25rem;
    padding: 0.5rem;
    background: var(--bg-secondary, #f8fafc);
    border-bottom: 1px solid var(--border, #e2e8f0);
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
}

.tool-tab {
    padding: 0.5rem 0.75rem;
    font-size: 0.75rem;
    font-weight: 500;
    border: none;
    background: transparent;
    color: var(--text-secondary, #475569);
    cursor: pointer;
    border-radius: 0.375rem;
    white-space: nowrap;
    transition: all 0.15s;
}

.tool-tab:hover {
    background: var(--bg-primary, #ffffff);
    color: var(--tool-primary);
}

.tool-tab.active {
    background: var(--tool-primary);
    color: white;
}

/* ========================================
   FORM STYLES
   ======================================== */
.tool-form-group {
    margin-bottom: 0.875rem;
}

.tool-form-label {
    display: block;
    font-weight: 500;
    margin-bottom: 0.375rem;
    color: var(--text-primary, #0f172a);
    font-size: 0.8125rem;
}

.tool-form-label .required {
    color: #ef4444;
}

.tool-input,
.tool-select,
.tool-textarea {
    width: 100%;
    padding: 0.5rem 0.75rem;
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.375rem;
    font-size: 0.8125rem;
    transition: border-color 0.15s, box-shadow 0.15s;
    background: var(--bg-primary, #ffffff);
    color: var(--text-primary, #0f172a);
}

.tool-input:focus,
.tool-select:focus,
.tool-textarea:focus {
    outline: none;
    border-color: var(--tool-primary);
    box-shadow: 0 0 0 3px oklch(0.759 0.155 65.8 / 0.1);
}

.tool-form-hint {
    font-size: 0.6875rem;
    color: var(--text-secondary, #475569);
    margin-top: 0.25rem;
}

.tool-form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.75rem;
}

@media (max-width: 480px) {
    .tool-form-row {
        grid-template-columns: 1fr;
    }
}

/* ========================================
   COLLAPSIBLE SECTIONS
   ======================================== */
.tool-section {
    background: var(--tool-light);
    border-radius: 0.5rem;
    margin-bottom: 0.75rem;
    overflow: hidden;
}

.tool-section-header {
    padding: 0.625rem 0.75rem;
    font-weight: 600;
    color: var(--tool-primary);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 0.8125rem;
    user-select: none;
}

.tool-section-header:hover {
    background: oklch(0.759 0.155 65.8 / 0.1);
}

.tool-section-header .chevron {
    transition: transform 0.2s;
    font-size: 0.75rem;
}

.tool-section-header.collapsed .chevron {
    transform: rotate(-90deg);
}

.tool-section-content {
    padding: 0.75rem;
    background: var(--bg-primary, #ffffff);
    border-top: 1px solid var(--border, #e2e8f0);
}

.tool-section-content.hidden {
    display: none;
}

/* ========================================
   BUTTONS
   ======================================== */
.tool-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.375rem;
    padding: 0.5rem 1rem;
    font-size: 0.8125rem;
    font-weight: 500;
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.375rem;
    background: var(--bg-primary, #ffffff);
    color: var(--text-primary, #0f172a);
    cursor: pointer;
    transition: all 0.15s;
}

.tool-btn:hover {
    border-color: var(--tool-primary);
    color: var(--tool-primary);
}

.tool-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.tool-btn-primary {
    background: var(--tool-gradient);
    color: white;
    border: none;
}

.tool-btn-primary:hover {
    opacity: 0.9;
    transform: translateY(-1px);
}

.tool-btn-sm {
    padding: 0.375rem 0.625rem;
    font-size: 0.75rem;
}

/* Main action button (full width) */
.tool-action-btn {
    width: 100%;
    padding: 0.75rem;
    font-weight: 600;
    font-size: 0.875rem;
    border: none;
    border-radius: 0.5rem;
    cursor: pointer;
    background: var(--tool-gradient);
    color: white;
    margin-top: 1rem;
    transition: opacity 0.15s, transform 0.15s;
}

.tool-action-btn:hover {
    opacity: 0.95;
    transform: translateY(-1px);
}

.tool-action-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    transform: none;
}

/* ========================================
   ACTIONS BAR
   ======================================== */
.tool-actions-bar {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.75rem 1rem;
    background: var(--bg-secondary, #f8fafc);
    border-bottom: 1px solid var(--border, #e2e8f0);
    flex-wrap: wrap;
}

.tool-actions-spacer {
    flex: 1;
}

/* ========================================
   FORMAT TOGGLE
   ======================================== */
.tool-format-toggle {
    display: inline-flex;
    background: var(--border, #e2e8f0);
    border-radius: 0.375rem;
    padding: 0.125rem;
}

.tool-format-btn {
    padding: 0.375rem 0.75rem;
    font-size: 0.75rem;
    font-weight: 500;
    border: none;
    background: transparent;
    color: var(--text-secondary, #475569);
    cursor: pointer;
    border-radius: 0.25rem;
    transition: all 0.15s;
}

.tool-format-btn.active {
    background: var(--bg-primary, #ffffff);
    color: var(--tool-primary);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

/* ========================================
   OUTPUT PREVIEW
   ======================================== */
.tool-output-wrapper {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-height: 400px;
}

.tool-output-pre {
    flex: 1;
    margin: 0;
    padding: 1rem;
    background: #1e293b;
    color: #e2e8f0;
    font-family: 'JetBrains Mono', 'Fira Code', monospace;
    font-size: 0.75rem;
    line-height: 1.6;
    overflow: auto;
    white-space: pre;
    border-radius: 0 0 0.75rem 0.75rem;
}

/* ========================================
   EMPTY STATE
   ======================================== */
.tool-empty-state {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 3rem;
    color: var(--text-secondary, #475569);
    text-align: center;
    background: var(--bg-secondary, #f8fafc);
    border-radius: 0 0 0.75rem 0.75rem;
}

.tool-empty-state svg {
    width: 80px;
    height: 80px;
    margin-bottom: 1rem;
    opacity: 0.4;
}

.tool-empty-state h3 {
    font-size: 1rem;
    font-weight: 600;
    color: var(--text-primary, #0f172a);
    margin-bottom: 0.5rem;
}

.tool-empty-state p {
    font-size: 0.875rem;
    max-width: 280px;
}

/* ========================================
   PRESETS BAR
   ======================================== */
.tool-presets {
    display: flex;
    gap: 0.375rem;
    padding: 0.5rem 0.75rem;
    background: var(--bg-primary, #ffffff);
    border-bottom: 1px solid var(--border, #e2e8f0);
    overflow-x: auto;
}

.tool-preset-btn {
    padding: 0.375rem 0.625rem;
    font-size: 0.6875rem;
    font-weight: 500;
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 9999px;
    background: var(--bg-primary, #ffffff);
    color: var(--text-secondary, #475569);
    cursor: pointer;
    white-space: nowrap;
    transition: all 0.15s;
}

.tool-preset-btn:hover {
    border-color: var(--tool-primary);
    color: var(--tool-primary);
    background: var(--tool-light);
}

/* ========================================
   STATUS INDICATOR
   ======================================== */
.tool-status {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 0.75rem;
    font-size: 0.75rem;
    background: #dcfce7;
    color: #166534;
    border-bottom: 1px solid #bbf7d0;
}

.tool-status.error {
    background: #fef2f2;
    color: #991b1b;
    border-color: #fecaca;
}

.tool-status-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: currentColor;
}

/* ========================================
   LIVE INDICATOR
   ======================================== */
.tool-live-indicator {
    display: flex;
    align-items: center;
    gap: 0.375rem;
    font-size: 0.6875rem;
    color: #059669;
    font-weight: 500;
}

.tool-live-dot {
    width: 6px;
    height: 6px;
    background: #10b981;
    border-radius: 50%;
    animation: toolPulse 2s infinite;
}

@keyframes toolPulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
}

/* ========================================
   PAGE HEADER
   ======================================== */
.tool-page-header {
    background: var(--bg-primary, #ffffff);
    border-bottom: 1px solid var(--border, #e2e8f0);
    padding: 1.25rem 1.5rem;
    margin-top: 72px;
}

.tool-page-header-inner {
    max-width: 1600px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 1rem;
}

.tool-page-title {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--text-primary, #0f172a);
    margin: 0;
}

.tool-page-badges {
    display: flex;
    gap: 0.5rem;
    flex-wrap: wrap;
}

.tool-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.25rem 0.625rem;
    font-size: 0.6875rem;
    font-weight: 500;
    border-radius: 9999px;
    background: var(--tool-light);
    color: var(--tool-primary);
}

/* ========================================
   BREADCRUMBS
   ======================================== */
.tool-breadcrumbs {
    font-size: 0.8125rem;
    color: var(--text-secondary, #475569);
    margin-top: 0.5rem;
}

.tool-breadcrumbs a {
    color: var(--text-secondary, #475569);
    text-decoration: none;
}

.tool-breadcrumbs a:hover {
    color: var(--tool-primary);
}

/* ========================================
   DESCRIPTION SECTION
   ======================================== */
.tool-description-section {
    background: var(--tool-light);
    border-bottom: 1px solid var(--border, #e2e8f0);
    padding: 1.25rem 1.5rem;
}

.tool-description-inner {
    max-width: 1600px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    gap: 2rem;
}

.tool-description-content {
    flex: 1;
}

.tool-description-content p {
    margin: 0;
    font-size: 0.9375rem;
    line-height: 1.6;
    color: var(--text-secondary, #475569);
}

.tool-description-ad {
    flex-shrink: 0;
    /* Fixed dimensions to prevent CLS */
    width: 728px;
    min-height: 90px;
}

.tool-description-ad .ad-container {
    margin: 0;
    min-height: 90px;
    width: 100%;
    /* Reserve space for ad before it loads */
    background: linear-gradient(135deg, var(--bg-secondary, #f1f5f9) 0%, var(--border, #e2e8f0) 100%);
}

.tool-description-ad .ad-container.ad-loaded {
    background: var(--bg-primary, #ffffff);
}

@media (max-width: 1023px) {
    .tool-description-ad {
        display: none;
    }
}

@media (max-width: 767px) {
    .tool-description-section {
        padding: 1rem;
    }

    .tool-description-content p {
        font-size: 0.875rem;
    }
}

/* ========================================
   MOBILE AD CONTAINER
   ======================================== */
.tool-mobile-ad-container {
    max-width: 1600px;
    margin: 0 auto;
    padding: 1.5rem;
}

.tool-mobile-ad-container .ad-container {
    margin: 0 auto;
    max-width: 336px;
}

@media (min-width: 1025px) {
    .tool-mobile-ad-container {
        display: none;
    }
}

@media (min-width: 768px) and (max-width: 1024px) {
    .tool-mobile-ad-container .ad-container {
        max-width: 728px;
    }
}

@media (max-width: 767px) {
    .tool-mobile-ad-container {
        padding: 1rem;
    }

    .tool-mobile-ad-container .ad-container {
        max-width: 100%;
    }
}

/* ========================================
   ALERT BOX
   ======================================== */
.tool-alert {
    padding: 0.625rem 0.75rem;
    border-radius: 0.375rem;
    font-size: 0.75rem;
    margin-bottom: 0.75rem;
    display: flex;
    align-items: flex-start;
    gap: 0.5rem;
}

.tool-alert-warning {
    background: #fef3c7;
    color: #92400e;
    border: 1px solid #fcd34d;
}

.tool-alert-info {
    background: #eff6ff;
    color: #1e40af;
    border: 1px solid #93c5fd;
}

.tool-alert-success {
    background: #dcfce7;
    color: #166534;
    border: 1px solid #86efac;
}

.tool-alert-error {
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
}

/* ========================================
   KEY-VALUE PAIR EDITOR
   ======================================== */
.kv-container {
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.375rem;
    padding: 0.5rem;
    background: var(--bg-primary, #ffffff);
}

.kv-pair {
    display: flex;
    gap: 0.375rem;
    margin-bottom: 0.375rem;
    align-items: center;
}

.kv-pair:last-child {
    margin-bottom: 0;
}

.kv-pair input,
.kv-key,
.kv-value,
.kv-extra {
    flex: 1;
    padding: 0.375rem 0.5rem;
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.25rem;
    font-size: 0.75rem;
    background: var(--bg-primary, #ffffff);
    color: var(--text-primary, #0f172a);
}

.kv-pair input:focus,
.kv-key:focus,
.kv-value:focus,
.kv-extra:focus {
    outline: none;
    border-color: var(--tool-primary);
}

.btn-remove-kv {
    padding: 0.25rem 0.375rem;
    color: #ef4444;
    background: transparent;
    border: 1px solid #fecaca;
    border-radius: 0.25rem;
    cursor: pointer;
    font-size: 0.625rem;
    line-height: 1;
    flex-shrink: 0;
}

.btn-remove-kv:hover {
    background: #fef2f2;
}

.btn-add-kv {
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.25rem 0.5rem;
    margin-top: 0.375rem;
    font-size: 0.6875rem;
    color: var(--tool-primary);
    background: var(--tool-light);
    border: 1px dashed var(--tool-primary);
    border-radius: 0.25rem;
    cursor: pointer;
    transition: all 0.15s;
}

.btn-add-kv:hover {
    background: var(--tool-primary);
    color: white;
    border-style: solid;
}

/* Volume Mount Row - for complex multi-field rows */
.volume-mount-row,
.toleration-row {
    display: flex;
    gap: 0.375rem;
    margin-bottom: 0.375rem;
    align-items: center;
    flex-wrap: wrap;
}

.volume-mount-row:last-child,
.toleration-row:last-child {
    margin-bottom: 0;
}

/* Inline checkbox label (checkbox inside label) */
.tool-form-label input[type="checkbox"] {
    width: 1rem;
    height: 1rem;
    margin-right: 0.5rem;
    accent-color: var(--tool-primary);
    vertical-align: middle;
}

/* ========================================
   CHECKBOX
   ======================================== */
.tool-checkbox {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.8125rem;
    cursor: pointer;
}

.tool-checkbox input {
    width: 1rem;
    height: 1rem;
    accent-color: var(--tool-primary);
}

/* ========================================
   TOAST
   ======================================== */
.tool-toast {
    position: fixed;
    bottom: 24px;
    right: 24px;
    padding: 0.75rem 1.25rem;
    background: #1e293b;
    color: white;
    border-radius: 0.5rem;
    font-size: 0.875rem;
    font-weight: 500;
    z-index: 9999;
    animation: toolToastIn 0.3s ease;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}

@keyframes toolToastIn {
    from { transform: translateY(20px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}

/* ========================================
   KEY-VALUE PAIR EDITOR
   ======================================== */
.tool-kv-container {
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.375rem;
    padding: 0.5rem;
    background: var(--bg-primary, #ffffff);
}

.tool-kv-pair {
    display: flex;
    gap: 0.375rem;
    margin-bottom: 0.375rem;
    align-items: center;
}

.tool-kv-pair:last-child {
    margin-bottom: 0;
}

.tool-kv-pair input {
    flex: 1;
    padding: 0.375rem 0.5rem;
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.25rem;
    font-size: 0.75rem;
    background: var(--bg-primary, #ffffff);
    color: var(--text-primary, #0f172a);
}

.tool-kv-pair input:focus {
    outline: none;
    border-color: var(--tool-primary);
}

.tool-btn-remove-kv {
    padding: 0.25rem 0.375rem;
    color: #ef4444;
    background: transparent;
    border: 1px solid #fecaca;
    border-radius: 0.25rem;
    cursor: pointer;
    font-size: 0.625rem;
    line-height: 1;
}

.tool-btn-remove-kv:hover {
    background: #fef2f2;
}

.tool-btn-add-kv {
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.25rem 0.5rem;
    margin-top: 0.375rem;
    font-size: 0.6875rem;
    color: var(--tool-primary);
    background: var(--tool-light);
    border: 1px dashed var(--tool-primary);
    border-radius: 0.25rem;
    cursor: pointer;
}

.tool-btn-add-kv:hover {
    background: var(--tool-primary);
    color: white;
    border-style: solid;
}

/* ========================================
   DARK MODE SUPPORT
   ======================================== */
[data-theme="dark"] {
    --tool-light: oklch(0.759 0.155 65.8 / 0.15);
}

[data-theme="dark"] .tool-page-header {
    background: var(--bg-secondary, #1e293b);
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .tool-page-title {
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .tool-breadcrumbs,
[data-theme="dark"] .tool-breadcrumbs a {
    color: var(--text-secondary, #94a3b8);
}

[data-theme="dark"] .tool-breadcrumbs a:hover {
    color: var(--tool-primary);
}

[data-theme="dark"] .tool-badge {
    background: var(--tool-light);
    color: var(--tool-primary);
}

[data-theme="dark"] .tool-description-section {
    background: var(--bg-secondary, #1e293b);
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .tool-description-content p {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .tool-description-ad .ad-container {
    background: linear-gradient(135deg, #334155 0%, #1e293b 100%);
}

[data-theme="dark"] .tool-description-ad .ad-container.ad-loaded {
    background: var(--bg-secondary, #1e293b);
}

[data-theme="dark"] .tool-card {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .tool-tabs {
    background: var(--bg-tertiary, #334155);
    border-bottom-color: var(--border, #475569);
}

[data-theme="dark"] .tool-tab {
    color: var(--text-secondary, #94a3b8);
}

[data-theme="dark"] .tool-tab:hover {
    background: var(--bg-secondary, #1e293b);
    color: var(--tool-primary);
}

[data-theme="dark"] .tool-tab.active {
    background: var(--tool-primary);
    color: white;
}

[data-theme="dark"] .tool-form-label {
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .tool-input,
[data-theme="dark"] .tool-select,
[data-theme="dark"] .tool-textarea {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #475569);
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .tool-input:focus,
[data-theme="dark"] .tool-select:focus,
[data-theme="dark"] .tool-textarea:focus {
    border-color: var(--tool-primary);
    box-shadow: 0 0 0 3px oklch(0.759 0.155 65.8 / 0.2);
}

[data-theme="dark"] .tool-input::placeholder,
[data-theme="dark"] .tool-textarea::placeholder {
    color: var(--text-muted, #64748b);
}

[data-theme="dark"] .tool-form-hint {
    color: var(--text-muted, #64748b);
}

[data-theme="dark"] .tool-section {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .tool-section-header {
    color: var(--tool-primary);
}

[data-theme="dark"] .tool-section-header:hover {
    background: oklch(0.759 0.155 65.8 / 0.1);
}

[data-theme="dark"] .tool-section-content {
    background: var(--bg-secondary, #1e293b);
    border-top-color: var(--border, #475569);
}

[data-theme="dark"] .tool-btn {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #475569);
    color: var(--text-primary, #e2e8f0);
}

[data-theme="dark"] .tool-btn:hover {
    background: var(--tool-primary);
    border-color: var(--tool-primary);
    color: white;
}

[data-theme="dark"] .tool-btn:disabled {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #475569);
    color: var(--text-muted, #64748b);
}

[data-theme="dark"] .tool-action-btn {
    box-shadow: 0 4px 12px oklch(0.759 0.155 65.8 / 0.3);
}

[data-theme="dark"] .tool-action-btn:disabled {
    background: var(--bg-tertiary, #334155);
    color: var(--text-muted, #64748b);
    box-shadow: none;
}

[data-theme="dark"] .tool-actions-bar {
    background: var(--bg-tertiary, #334155);
    border-bottom-color: var(--border, #475569);
}

[data-theme="dark"] .tool-format-toggle {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .tool-format-btn {
    color: var(--text-primary, #e2e8f0);
}

[data-theme="dark"] .tool-format-btn:hover {
    background: var(--bg-secondary, #1e293b);
}

[data-theme="dark"] .tool-format-btn.active {
    background: var(--tool-primary);
    color: white;
}

[data-theme="dark"] .tool-empty-state {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .tool-empty-state h3 {
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .tool-empty-state p {
    color: var(--text-secondary, #94a3b8);
}

[data-theme="dark"] .tool-presets {
    background: var(--bg-tertiary, #334155);
    border-bottom-color: var(--border, #475569);
}

[data-theme="dark"] .tool-preset-btn {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #475569);
    color: var(--text-primary, #e2e8f0);
}

[data-theme="dark"] .tool-preset-btn:hover {
    background: var(--tool-primary);
    border-color: var(--tool-primary);
    color: white;
}

[data-theme="dark"] .tool-checkbox {
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .tool-kv-container {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #475569);
}

[data-theme="dark"] .tool-kv-pair input {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #475569);
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .tool-btn-add-kv {
    background: oklch(0.759 0.155 65.8 / 0.1);
}

/* Dark mode for .kv-* classes (legacy/simplified naming) */
[data-theme="dark"] .kv-container {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #475569);
}

[data-theme="dark"] .kv-pair input,
[data-theme="dark"] .kv-key,
[data-theme="dark"] .kv-value,
[data-theme="dark"] .kv-extra {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #475569);
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .btn-add-kv {
    background: rgba(var(--tool-primary-rgb, 99, 102, 241), 0.1);
}

[data-theme="dark"] .btn-remove-kv {
    background: rgba(239, 68, 68, 0.1);
    border-color: rgba(239, 68, 68, 0.3);
}

[data-theme="dark"] .btn-remove-kv:hover {
    background: rgba(239, 68, 68, 0.2);
}

[data-theme="dark"] .tool-alert-warning {
    background: rgba(251, 191, 36, 0.15);
    color: #fcd34d;
    border-color: rgba(251, 191, 36, 0.3);
}

[data-theme="dark"] .tool-alert-info {
    background: rgba(59, 130, 246, 0.15);
    color: #93c5fd;
    border-color: rgba(59, 130, 246, 0.3);
}

[data-theme="dark"] .tool-alert-success {
    background: rgba(34, 197, 94, 0.15);
    color: #86efac;
    border-color: rgba(34, 197, 94, 0.3);
}

[data-theme="dark"] .tool-alert-error {
    background: rgba(239, 68, 68, 0.15);
    color: #fca5a5;
    border-color: rgba(239, 68, 68, 0.3);
}

/* ============ modern/css/tool-page.css ============ */
/**
 * Modern Tool Page Styles
 * Consistent styling for all tool pages
 */

/* Breadcrumbs */
.breadcrumbs {
    background: var(--bg-secondary, #f8fafc);
    padding: 1rem 1.5rem;
    border-bottom: 1px solid var(--border, #e2e8f0);
    margin-top: 72px;
}

.breadcrumbs-container {
    max-width: 1400px;
    margin-left: 1.5rem; /* Left-aligned with small left margin */
    margin-right: auto;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
}

/* Adjust breadcrumbs for larger screens */
@media (min-width: 1300px) {
    .breadcrumbs-container {
        max-width: min(1400px, calc(100vw - 380px - 3rem));
    }
}

@media (min-width: 1440px) {
    .breadcrumbs-container {
        max-width: min(1400px, calc(100vw - 420px - 3rem));
    }
}

.breadcrumbs a {
    color: var(--primary, #d39144);
    text-decoration: none;
    transition: opacity 0.2s;
}

.breadcrumbs a:hover {
    opacity: 0.8;
}

.breadcrumb-separator {
    color: var(--text-muted, #94a3b8);
}

.breadcrumb-current {
    color: var(--text-secondary, #475569);
    font-weight: 500;
}

/* Tool Header */
.tool-header {
    background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
    padding: 3rem 1.5rem;
    border-bottom: 1px solid var(--border, #e2e8f0);
}

.tool-header-container,
.tool-container {
    max-width: 1200px;
    margin-left: 1.5rem; /* Left-aligned with small left margin */
    margin-right: auto;
    padding-left: 1.5rem;
    padding-right: 1.5rem;
}

/* Optimize for larger screens without ads */
@media (min-width: 1300px) {
    .tool-header-container,
    .tool-container {
        max-width: min(1200px, calc(100vw - 380px - 3rem)); /* Reserve space for right ads */
        margin-left: 1.5rem;
    }
}

@media (min-width: 1440px) {
    .tool-header-container,
    .tool-container {
        max-width: min(1200px, calc(100vw - 420px - 3rem)); /* Reserve space for larger right ads */
        margin-left: 1.5rem;
    }
}

@media (min-width: 1600px) {
    .tool-header-container,
    .tool-container {
        max-width: 1400px; /* Use more space on very large screens */
        margin-left: 1.5rem;
    }
}

.tool-header-content {
    text-align: center;
}

.tool-page-title {
    font-size: clamp(2rem, 4vw, 3rem);
    font-weight: 800;
    margin-bottom: 1rem;
    color: var(--text-primary, #0f172a);
    letter-spacing: -0.02em;
}

.tool-page-description {
    font-size: 1.125rem;
    color: var(--text-secondary, #475569);
    max-width: 700px;
    margin: 0 auto 1.5rem;
    line-height: 1.6;
}

.tool-meta {
    display: flex;
    justify-content: center;
    gap: 0.75rem;
    flex-wrap: wrap;
}

.tool-category-badge,
.tool-badge {
    padding: 0.5rem 1rem;
    border-radius: 50px;
    font-size: 0.875rem;
    font-weight: 500;
}

.tool-category-badge {
    background: var(--primary, #d39144);
    color: white;
}

.tool-badge {
    background: var(--bg-secondary, #f8fafc);
    color: var(--text-secondary, #475569);
    border: 1px solid var(--border, #e2e8f0);
}

/* Tool Main */
.tool-main {
    padding: 3rem 1.5rem;
    min-height: 60vh;
}

/* Dedicated Layout Wrapper for Content + Ads (Desktop only) */
@media (min-width: 1300px) {
    .tool-main {
        display: grid;
        grid-template-columns: 1fr 356px; /* Content + Ad column (336px + 20px gap) */
        gap: 1.5rem;
        padding: 3rem 1.5rem;
        max-width: 100vw;
        margin: 0;
    }
    
    /* Content area in dedicated left column */
    .tool-main > .tool-container {
        grid-column: 1;
        max-width: 100%;
        margin: 0;
        padding: 0;
    }
    
    /* Ad column - dedicated right space (grid column 2) */
    .tool-main > .ad-right-column {
        grid-column: 2;
    }
}

@media (min-width: 1440px) {
    .tool-main {
        grid-template-columns: 1fr 372px; /* 336px + 36px gap */
    }
}

.tool-container {
    max-width: 1200px;
    margin-left: 1.5rem; /* Left-aligned with small left margin */
    margin-right: auto;
    padding-left: 1.5rem;
    padding-right: 1.5rem;
}

/* Optimize for larger screens */
@media (min-width: 1300px) {
    .tool-container {
        max-width: min(1200px, calc(100vw - 380px - 3rem)); /* Reserve space for right ads */
        margin-left: 1.5rem;
    }
}

@media (min-width: 1440px) {
    .tool-container {
        max-width: min(1200px, calc(100vw - 420px - 3rem)); /* Reserve space for larger right ads */
        margin-left: 1.5rem;
    }
}

@media (min-width: 1600px) {
    .tool-container {
        max-width: 1400px; /* Use more space on very large screens */
        margin-left: 1.5rem;
    }
}

/* Tool Form Card */
.tool-form-card {
    background: white;
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 1rem;
    padding: 2rem;
    margin-bottom: 2rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.tool-form-card h2 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    color: var(--text-primary, #0f172a);
}

/* Tool Input Groups */
.input-group {
    margin-bottom: 1.5rem;
}

.input-label {
    display: block;
    font-weight: 500;
    margin-bottom: 0.5rem;
    color: var(--text-primary, #0f172a);
    font-size: 0.9375rem;
}

.input-field,
.textarea-field {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 2px solid var(--border, #e2e8f0);
    border-radius: 0.5rem;
    font-size: 1rem;
    font-family: var(--font-mono, 'JetBrains Mono', monospace);
    transition: all 0.2s;
    background: var(--bg-primary, #ffffff);
    color: var(--text-primary, #0f172a);
}

.textarea-field {
    min-height: 150px;
    resize: vertical;
    font-family: var(--font-mono, 'JetBrains Mono', monospace);
}

.input-field:focus,
.textarea-field:focus {
    outline: none;
    border-color: var(--primary, #d39144);
    box-shadow: 0 0 0 3px oklch(0.759 0.155 65.8 / 0.1);
}

/* Tool Buttons */
.btn-primary,
.btn-secondary {
    padding: 0.75rem 1.5rem;
    border-radius: 0.5rem;
    font-weight: 600;
    font-size: 1rem;
    cursor: pointer;
    transition: all 0.3s ease;
    border: none;
    font-family: inherit;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
}

.btn-primary {
    background: var(--primary, #d39144);
    color: white;
}

.btn-primary:hover {
    background: var(--primary-dark, #a17b3a);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px oklch(0.759 0.155 65.8 / 0.3);
}

.btn-secondary {
    background: var(--bg-secondary, #f8fafc);
    color: var(--text-secondary, #475569);
    border: 1px solid var(--border, #e2e8f0);
}

.btn-secondary:hover {
    background: var(--bg-tertiary, #f1f5f9);
    border-color: var(--primary, #d39144);
    color: var(--primary, #d39144);
}

/* Results Card */
.results-card {
    background: white;
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 1rem;
    padding: 2rem;
    margin-top: 2rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.results-card h3 {
    font-size: 1.25rem;
    font-weight: 600;
    margin-bottom: 1rem;
    color: var(--text-primary, #0f172a);
}

.result-output {
    background: var(--bg-secondary, #f8fafc);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.5rem;
    padding: 1rem;
    font-family: var(--font-mono, 'JetBrains Mono', monospace);
    font-size: 0.9375rem;
    white-space: pre-wrap;
    word-wrap: break-word;
    max-height: 400px;
    overflow-y: auto;
    color: var(--text-primary, #0f172a);
}

/* Dark Mode */
[data-theme="dark"] .breadcrumbs {
    background: var(--bg-secondary, #1e293b);
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .tool-header {
    background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
}

[data-theme="dark"] .tool-form-card,
[data-theme="dark"] .results-card {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .input-field,
[data-theme="dark"] .textarea-field,
[data-theme="dark"] .result-output {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #334155);
    color: var(--text-primary, #f1f5f9);
}

/* Responsive */
@media (max-width: 767px) {
    .breadcrumbs {
        margin-top: 64px;
        padding: 0.75rem 1rem;
    }

    .tool-header {
        padding: 2rem 1rem;
    }

    .tool-main {
        padding: 2rem 1rem;
    }

    .tool-form-card {
        padding: 1.5rem;
    }
}

/* ==================== FAQ Accordion ==================== */
.faq-item {
    border-bottom: 1px solid var(--border, #e2e8f0);
}
.faq-question {
    width: 100%;
    background: none;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 1rem 0;
    font-size: 0.95rem;
    font-weight: 600;
    color: var(--text-primary, #1e293b);
    text-align: left;
    font-family: inherit;
    gap: 0.75rem;
    line-height: 1.4;
}
.faq-question:hover {
    color: var(--accent, #a17b3a);
}
.faq-chevron {
    flex-shrink: 0;
    transition: transform 0.3s ease;
}
.faq-answer {
    max-height: 0;
    overflow: hidden;
    color: var(--text-secondary, #64748b);
    line-height: 1.7;
    font-size: 0.9rem;
    transition: max-height 0.3s ease, padding 0.3s ease;
    padding: 0 0;
}
.faq-item.open .faq-answer {
    max-height: 500px;
    padding: 0 0 1rem 0;
}
.faq-item.open .faq-chevron {
    transform: rotate(180deg);
}
[data-theme="dark"] .faq-question {
    color: var(--text-primary, #f1f5f9);
}
[data-theme="dark"] .faq-answer {
    color: var(--text-secondary, #94a3b8);
}


/* ============ modern/css/ads.css ============ */
/**
 * Modern Ad System Styling
 * Mobile-first, non-intrusive ad placement
 */

/* ============================================
   AD CONTAINER BASE STYLES
   ============================================ */

.ad-container {
    position: relative;
    background: var(--bg-primary, #ffffff);
    border: 1px solid var(--border, #e2e8f0);
    border-left: 3px solid var(--primary, #d39144);
    border-radius: var(--radius-md, 0.5rem);
    padding: var(--space-4, 1rem);
    margin: var(--space-8, 2rem) 0;
    text-align: center;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.ad-container:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

/* Ad Label (Required by AdSense) */
.ad-label {
    font-size: var(--text-xs, 0.75rem);
    color: var(--text-muted, #94a3b8);
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin-bottom: var(--space-2, 0.5rem);
    text-align: center;
    font-weight: 500;
}

/* ============================================
   IN-CONTENT AD STYLES
   ============================================ */

.ad-in-content-top,
.ad-in-content-mid {
    min-height: 90px; /* Prevent layout shift */
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

/* Desktop: Leaderboard */
@media (min-width: 992px) {
    .ad-in-content-top {
        min-height: 90px;
        padding: var(--space-6, 1.5rem);
        max-width: 970px;
        margin-left: auto;
        margin-right: auto;
    }

    .ad-in-content-mid {
        min-height: 280px; /* Accommodate 336x280 */
        max-width: 336px;
        margin-left: auto;
        margin-right: 0; /* Right-align for better visibility */
    }
}

/* Tablet */
@media (min-width: 768px) and (max-width: 991px) {
    .ad-in-content-top {
        min-height: 90px;
    }

    .ad-in-content-mid {
        min-height: 250px;
        max-width: 300px;
        margin-left: auto;
        margin-right: auto;
    }
}

/* Mobile */
@media (max-width: 767px) {
    .ad-container {
        margin: var(--space-6, 1.5rem) 0;
        padding: var(--space-3, 0.75rem);
    }

    .ad-in-content-top {
        min-height: 100px;
    }

    .ad-in-content-mid {
        min-height: 250px;
        width: 100%;
        max-width: 100%;
    }
}

/* ============================================
   HERO BANNER AD (Above-the-fold, inside hero)
   ============================================ */

.ad-hero-banner {
    margin: 0;
    border: none;
    border-left: none;
    border-radius: 0;
    background: transparent;
    box-shadow: none;
    padding: 8px 0;
    min-height: 50px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.ad-hero-banner:hover {
    transform: none;
    box-shadow: none;
}

.ad-hero-banner .ad-label {
    font-size: 9px;
    margin-bottom: 4px;
    opacity: 0.6;
}

/* Desktop: wide leaderboard */
@media (min-width: 992px) {
    .ad-hero-banner {
        min-height: 90px;
        max-width: 970px;
        margin: 0 auto;
        padding: 10px 0;
    }
}

/* Tablet */
@media (min-width: 768px) and (max-width: 991px) {
    .ad-hero-banner {
        min-height: 90px;
        max-width: 728px;
        margin: 0 auto;
    }
}

/* Mobile */
@media (max-width: 767px) {
    .ad-hero-banner {
        min-height: 50px;
        padding: 6px 0;
    }
}

/* Collapse if empty (no ad fill) */
.ad-hero-banner:not(.ad-loaded) {
    min-height: 0;
    padding: 0;
}

/* Dark theme */
[data-theme="dark"] .ad-hero-banner {
    background: transparent;
    border-color: transparent;
}

/* ============================================
   FLOATING RIGHT AD STYLES (Desktop Only)
   ============================================ */

.ad-floating-right {
    position: fixed;
    right: 10px;  /* Moved closer to edge */
    top: 100px;
    width: 300px;  /* Slightly smaller to fit better */
    max-width: 300px;
    z-index: 100;
    display: none;
    opacity: 0;
    transition: opacity 0.3s ease, transform 0.3s ease;
    transform: translateX(20px);
    margin: 0;
    border-radius: var(--radius-lg, 0.75rem);
}

.ad-floating-right.ad-visible {
    display: block;
    opacity: 1;
    transform: translateX(0);
}

/* Hide on mobile/tablet and smaller desktop screens */
@media (max-width: 1299px) {
    .ad-floating-right {
        display: none !important;
    }
}

/* Desktop - only show on screens 1300px+ */
/* Hide floating right ad when right column ads are present */
@media (min-width: 1300px) {
    body.has-right-ads .ad-floating-right {
        display: none !important;
    }
    
    .ad-floating-right {
        min-height: 250px;
        bottom: 120px; /* Above sticky footer */
        right: 15px;  /* Safe distance from edge */
    }
}

/* Large screens - more breathing room */
@media (min-width: 1440px) {
    .ad-floating-right {
        right: 25px;
        width: 336px;  /* Can show full size on larger screens */
        max-width: 336px;
    }
}

/* Extra large screens - optimal positioning */
@media (min-width: 1600px) {
    .ad-floating-right {
        right: 40px;
    }
}

/* Ultra-wide screens */
@media (min-width: 1920px) {
    .ad-floating-right {
        right: 60px;
    }
}

/* Close button for floating ad */
.ad-floating-right .ad-close {
    top: var(--space-2, 0.5rem);
    right: var(--space-2, 0.5rem);
    z-index: 2;
}

/* ============================================
   RIGHT COLUMN AD CONTAINER (Desktop Only)
   Uses empty space on the right side
   ============================================ */

.ad-right-column {
    position: fixed;
    right: 10px;
    top: 100px;
    width: 300px;
    max-width: 300px;
    z-index: 99;
    display: none;
    flex-direction: column;
    gap: 1.5rem;
}

/* Show right column ads on large desktop screens */
/* Use dedicated grid column when available, otherwise fixed positioning */
@media (min-width: 1300px) {
    .ad-right-column {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }
    
    /* If inside tool-main grid, use grid positioning instead of fixed */
    .tool-main > .ad-right-column {
        position: sticky;
        top: 100px; /* Sticky within grid column */
        align-self: start;
        width: 100%;
        max-width: 336px;
        height: fit-content;
    }
    
    /* Fallback: Fixed positioning when not in grid */
    .ad-right-column:not(.tool-main > *) {
        position: fixed;
        right: 10px;
        top: 100px;
        width: 300px;
        max-width: 300px;
    }
}

/* Large screens - full size */
@media (min-width: 1440px) {
    .ad-right-column {
        width: 336px;
        max-width: 336px;
        right: 15px;
    }
    
    /* In grid layout, use full width of grid column */
    .tool-main .ad-right-column {
        max-width: 100%;
    }
}

/* Extra large screens */
@media (min-width: 1600px) {
    .ad-right-column {
        right: 25px;
    }
}

/* Ultra-wide screens */
@media (min-width: 1920px) {
    .ad-right-column {
        right: 40px;
    }
}

/* Right Column Ad Slot */
.ad-right-slot {
    position: relative;
    min-height: 250px;
    display: none;
    opacity: 0;
    transform: translateX(20px);
    transition: opacity 0.3s ease, transform 0.3s ease;
    margin: 0;
}

.ad-right-slot.ad-visible {
    display: block;
    opacity: 1;
    transform: translateX(0);
}

/* Content width optimization - now handled by grid layout */
/* Fallback for when grid is not used */
@media (min-width: 1300px) {
    /* Grid layout handles spacing automatically, but keep fallback for compatibility */
    .tool-main:not(:has(.ad-right-column)) .tool-container {
        max-width: calc(100vw - 3rem);
    }
    
    /* Header and breadcrumbs still use calculated widths */
    body.has-right-ads .tool-header-container {
        max-width: calc(100vw - 380px - 3rem) !important;
        margin-left: 1.5rem !important;
        margin-right: auto !important;
        padding-left: 1.5rem;
        padding-right: 1.5rem;
    }
    
    body.has-right-ads .breadcrumbs-container {
        max-width: calc(100vw - 380px - 3rem) !important;
        margin-left: 1.5rem !important;
        margin-right: auto !important;
    }
}

@media (min-width: 1440px) {
    body.has-right-ads .tool-header-container {
        max-width: calc(100vw - 420px - 3rem) !important;
    }
    
    body.has-right-ads .breadcrumbs-container {
        max-width: calc(100vw - 420px - 3rem) !important;
    }
}

@media (min-width: 1600px) {
    body.has-right-ads .tool-header-container {
        max-width: min(1400px, calc(100vw - 420px - 3rem)) !important;
    }
    
    body.has-right-ads .breadcrumbs-container {
        max-width: min(1400px, calc(100vw - 420px - 3rem)) !important;
    }
}

/* Right column ad close button */
.ad-right-slot .ad-close {
    top: var(--space-2, 0.5rem);
    right: var(--space-2, 0.5rem);
    z-index: 2;
    background: var(--bg-primary, #ffffff);
    border: 1px solid var(--border, #e2e8f0);
}

.ad-right-slot .ad-close:hover {
    background: var(--bg-secondary, #f8fafc);
    border-color: var(--primary, #d39144);
}

/* ============================================
   STICKY FOOTER AD STYLES
   ============================================ */

.ad-sticky-footer {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: var(--z-fixed, 1030);
    margin: 0;
    border-radius: 0;
    border-left: none;
    border-right: none;
    border-bottom: none;
    border-top: 1px solid var(--border, #e2e8f0);
    background: var(--bg-primary, #ffffff);
    box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
    padding: var(--space-3, 0.75rem) var(--space-4, 1rem);
    min-height: auto;
    display: none; /* Hidden by default, shown via JS */
    transform: translateY(100%);
    transition: transform 0.3s ease-in-out;
}

/* Desktop: Position sticky footer ad to the right side */
@media (min-width: 992px) {
    .ad-sticky-footer {
        left: auto; /* Remove left: 0 */
        right: 20px; /* Position from right edge */
        width: 728px; /* Standard leaderboard width */
        max-width: 728px;
        border-radius: var(--radius-lg, 0.75rem) var(--radius-lg, 0.75rem) 0 0;
        border-left: 1px solid var(--border, #e2e8f0);
        border-right: 1px solid var(--border, #e2e8f0);
        box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.15);
    }

    /* Ensure close button is easily accessible on desktop */
    .ad-sticky-footer .ad-close {
        top: var(--space-2, 0.5rem);
        right: var(--space-2, 0.5rem);
        background: var(--bg-primary, #ffffff);
        border: 1px solid var(--border, #e2e8f0);
        z-index: 2;
    }

    .ad-sticky-footer .ad-close:hover {
        background: var(--bg-secondary, #f8fafc);
        border-color: var(--primary, #d39144);
    }
}

.ad-sticky-footer.ad-visible {
    display: block;
    transform: translateY(0);
}

.ad-sticky-footer.ad-collapsed {
    transform: translateY(80%);
}

.ad-sticky-footer.ad-dismissed {
    transform: translateY(100%);
}

/* Close Button */
.ad-close {
    position: absolute;
    top: var(--space-2, 0.5rem);
    right: var(--space-2, 0.5rem);
    background: none;
    border: none;
    font-size: var(--text-xl, 1.25rem);
    color: var(--text-muted, #94a3b8);
    cursor: pointer;
    padding: var(--space-1, 0.25rem);
    line-height: 1;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: var(--radius-full, 9999px);
    transition: all 0.2s ease;
    z-index: 1;
}

.ad-close:hover {
    background: var(--bg-secondary, #f8fafc);
    color: var(--text-primary, #0f172a);
}

.ad-close:focus {
    outline: 2px solid var(--primary, #d39144);
    outline-offset: 2px;
}

/* Mobile Sticky Footer */
@media (max-width: 767px) {
    .ad-sticky-footer {
        padding: var(--space-2, 0.5rem);
    }

    .ad-close {
        width: 36px;
        height: 36px;
        font-size: var(--text-2xl, 1.5rem);
    }
}

/* ============================================
   AD CONTENT WRAPPER
   ============================================ */

.ad-content {
    position: relative;
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* ============================================
   RESPONSIVE AD SIZING
   ============================================ */

/* Ensure ads don't overflow */
.ad-container ins {
    display: block;
    width: 100%;
    max-width: 100%;
}

/* Desktop: Center and constrain leaderboard */
@media (min-width: 992px) {
    #site_8gwifi_org_leaderboard_responsive {
        min-height: 90px;
        max-width: 970px;
        margin: 0 auto;
    }

    #site_8gwifi_org_anchor_responsive {
        min-height: 90px;
        max-width: 970px;
        margin: 0 auto;
    }

    #site_8gwifi_org_rectangle_responsive {
        min-height: 280px;
        max-width: 336px;
    }

    #site_8gwifi_org_floating_right {
        min-height: 280px;
        max-width: 336px;
    }
}


/* Tablet */
@media (min-width: 768px) and (max-width: 991px) {
    #site_8gwifi_org_leaderboard_responsive {
        min-height: 90px;
    }
}

/* Mobile */
@media (max-width: 767px) {
    #site_8gwifi_org_leaderboard_responsive {
        min-height: 100px;
    }

    #site_8gwifi_org_rectangle_responsive {
        min-height: 250px;
    }

    #site_8gwifi_org_anchor_responsive {
        min-height: 100px;
    }
}

/* ============================================
   ACCESSIBILITY
   ============================================ */

/* Accessibility: aria-label ensures screen readers can identify ads */

.ad-container:focus-within {
    outline: 2px solid var(--primary, #d39144);
    outline-offset: 2px;
}

/* ============================================
   DARK MODE SUPPORT
   ============================================ */

@media (prefers-color-scheme: dark) {
    .ad-container {
        background: var(--bg-secondary, #1e293b);
        border-color: var(--border, #334155);
    }

    .ad-label {
        color: var(--text-muted, #94a3b8);
    }

    .ad-sticky-footer {
        background: var(--bg-primary, #0f172a);
        border-top-color: var(--border, #334155);
        box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.3);
    }

    .ad-close:hover {
        background: var(--bg-secondary, #1e293b);
        color: var(--text-primary, #f1f5f9);
    }
}

[data-theme="dark"] .ad-container {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .ad-sticky-footer {
    background: var(--bg-primary, #0f172a);
    border-top-color: var(--border, #334155);
}

[data-theme="dark"] .ad-floating-right {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .ad-floating-right .ad-close:hover {
    background: var(--bg-tertiary, #334155);
    color: var(--text-primary, #f1f5f9);
}

/* ============================================
   EDITOR PANEL NATIVE AD
   Fits inside .me-right-panel (280px wide)
   ============================================ */
.ad-panel-native {
    margin: 0;
    padding: 8px;
    border: none;
    border-bottom: 1px solid var(--border, #e2e8f0);
    border-left: none;
    border-radius: 0;
    box-shadow: none;
    background: var(--bg-secondary, #f8fafc);
    max-width: 280px;
    min-height: 250px;
    flex-shrink: 0;
}

.ad-panel-native:hover {
    transform: none;
    box-shadow: none;
}

.ad-panel-native .ad-label {
    font-size: 9px;
    color: var(--text-muted, #94a3b8);
    margin-bottom: 4px;
}

/* Hidden when right panel is hidden (<= 1024px) */
@media (max-width: 1024px) {
    .ad-panel-native {
        display: none !important;
    }
}

/* ============================================
   DASHBOARD SIDEBAR NATIVE AD
   Fits inside .me-sidebar (240px wide)
   ============================================ */
.ad-sidebar-native {
    margin: 16px 0 0 0;
    padding: 8px;
    border: none;
    border-top: 1px solid var(--border, #e2e8f0);
    border-left: none;
    border-radius: 0;
    box-shadow: none;
    background: transparent;
    max-width: 220px;
    min-height: 200px;
}

.ad-sidebar-native:hover {
    transform: none;
    box-shadow: none;
}

.ad-sidebar-native .ad-label {
    font-size: 9px;
    color: var(--text-muted, #94a3b8);
    margin-bottom: 4px;
}

/* Hidden when sidebar collapses */
@media (max-width: 768px) {
    .ad-sidebar-native {
        display: none !important;
    }
}

/* ============================================
   DASHBOARD BELOW-GRID LEADERBOARD
   Sits after the document grid
   ============================================ */
.ad-below-grid {
    margin: 32px auto 16px auto;
    padding: 12px;
    max-width: 728px;
    min-height: 90px;
    border-left-width: 2px;
}

@media (max-width: 991px) {
    .ad-below-grid {
        max-width: 100%;
        min-height: 100px;
    }
}

/* Dark mode */
[data-theme="dark"] .ad-panel-native {
    background: var(--bg-secondary, #1e293b);
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .ad-sidebar-native {
    border-top-color: var(--border, #334155);
}

/* ============================================
   PRINT STYLES
   ============================================ */

@media print {
    .ad-container {
        display: none !important;
    }
}

/* ============================================
   PERFORMANCE OPTIMIZATIONS
   ============================================ */

/* Prevent layout shift while ads load */
.ad-container::before {
    content: '';
    display: block;
    width: 100%;
}

.ad-in-content-top::before {
    padding-bottom: 12.4%; /* 90px / 728px ≈ 12.4% */
}

.ad-in-content-mid::before {
    padding-bottom: 83.3%; /* 250px / 300px ≈ 83.3% */
}

@media (max-width: 991px) {
    .ad-in-content-top::before {
        padding-bottom: 31.25%; /* 100px / 320px ≈ 31.25% */
    }
}
/* ============ modern/css/dark-mode.css ============ */
/**
 * Dark Mode Styles
 * Complete dark theme support
 */

/* Light theme - explicit reset (uses :root defaults, but ensures consistency) */
[data-theme="light"] {
    /* Background Colors */
    --bg-primary: #ffffff;
    --bg-secondary: #f8fafc;
    --bg-tertiary: #f1f5f9;
    --bg-hover: #f8fafc;
    
    /* Text Colors */
    --text-primary: #0f172a;
    --text-secondary: #475569;
    --text-muted: #94a3b8;
    --text-inverse: #ffffff;
    
    /* Border Colors */
    --border: #e2e8f0;
    --border-light: #f1f5f9;
    --border-dark: #cbd5e1;
}

/* Ensure light theme body/html */
[data-theme="light"] html,
[data-theme="light"] body {
    background-color: var(--bg-primary, #ffffff) !important;
    color: var(--text-primary, #0f172a) !important;
}

/* Dark theme */
[data-theme="dark"] {
    /* Background Colors */
    --bg-primary: #0f172a;
    --bg-secondary: #1e293b;
    --bg-tertiary: #334155;
    --bg-hover: #1e293b;
    
    /* Text Colors */
    --text-primary: #f1f5f9;
    --text-secondary: #cbd5e1;
    --text-muted: #94a3b8;
    --text-inverse: #0f172a;
    
    /* Border Colors */
    --border: #334155;
    --border-light: #475569;
    --border-dark: #64748b;
}

/* Apply dark mode to html and body - CRITICAL for visible theme change */
[data-theme="dark"] html {
    background-color: var(--bg-primary, #0f172a) !important;
}

[data-theme="dark"] body {
    background-color: var(--bg-primary, #0f172a) !important;
    color: var(--text-primary, #f1f5f9) !important;
}

/* Light theme - breadcrumbs and tool sections */
[data-theme="light"] .breadcrumbs {
    background: var(--bg-secondary, #f8fafc) !important;
    border-bottom-color: var(--border, #e2e8f0) !important;
}

[data-theme="light"] .tool-header {
    background: transparent !important;
}

[data-theme="light"] .tool-main {
    background-color: var(--bg-primary, #ffffff) !important;
}

/* Dark mode breadcrumbs */
[data-theme="dark"] .breadcrumbs {
    background: var(--bg-secondary, #1e293b) !important;
    border-bottom-color: var(--border, #334155) !important;
}

[data-theme="dark"] .breadcrumb-current {
    color: var(--text-secondary, #cbd5e1) !important;
}

/* Dark mode tool header */
[data-theme="dark"] .tool-header {
    background: var(--bg-primary, #0f172a) !important;
}

[data-theme="dark"] .tool-page-title {
    color: var(--text-primary, #f1f5f9) !important;
}

[data-theme="dark"] .tool-page-description {
    color: var(--text-secondary, #cbd5e1) !important;
}

/* Dark mode tool main */
[data-theme="dark"] .tool-main {
    background-color: var(--bg-primary, #0f172a) !important;
}

/* Theme Toggle Button */
.theme-toggle {
    background: var(--bg-secondary, #f8fafc);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.5rem;
    padding: 0.5rem;
    cursor: pointer;
    font-size: 1.25rem;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
}

.theme-toggle:hover {
    background: var(--bg-tertiary, #f1f5f9);
    transform: scale(1.1);
}

[data-theme="dark"] .theme-toggle {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .theme-toggle:hover {
    background: var(--bg-tertiary, #334155);
}

/* Dark Mode Hero Section */
[data-theme="dark"] .hero {
    background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
}

[data-theme="dark"] .hero::before {
    background: 
        radial-gradient(circle at 20% 50%, rgba(255,255,255,0.05) 0%, transparent 50%),
        radial-gradient(circle at 80% 80%, rgba(255,255,255,0.05) 0%, transparent 50%);
}

[data-theme="dark"] .hero::after {
    background-image: 
        linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px),
        linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px);
}

/* Dark Mode Tool Cards */
[data-theme="dark"] .tool-card {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .tool-card:hover {
    background: var(--bg-tertiary, #334155);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

[data-theme="dark"] .tool-title {
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .tool-description {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .tool-link {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .tool-link:hover {
    background: var(--bg-tertiary, #334155);
    color: var(--primary, #e0b074);
}

[data-theme="dark"] .tool-more-btn {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #334155);
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .tool-more-btn:hover {
    background: var(--primary, #d39144);
    color: white;
}

[data-theme="dark"] .tool-more-content {
    border-top-color: var(--border, #334155);
}

/* Dark Mode Search */
[data-theme="dark"] .search-wrapper {
    background: rgba(255, 255, 255, 0.05);
    border-color: rgba(255, 255, 255, 0.1);
}

[data-theme="dark"] .search-wrapper:focus-within {
    background: rgba(255, 255, 255, 0.1);
    border-color: rgba(255, 255, 255, 0.2);
}

[data-theme="dark"] .search-input-hero {
    color: white;
}

/* Dark Mode Footer */
[data-theme="dark"] .page-footer {
    background: #0a0f1a;
    border-top-color: var(--border, #334155);
}

[data-theme="dark"] .footer-link {
    color: rgba(255, 255, 255, 0.7);
}

[data-theme="dark"] .footer-link:hover {
    color: white;
}

/* Dark Mode Navigation */
[data-theme="dark"] .modern-nav {
    background: var(--bg-secondary, #1e293b);
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .nav-link {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .nav-link:hover {
    background: var(--bg-tertiary, #334155);
    color: var(--primary, #e0b074);
}

[data-theme="dark"] .search-input {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #334155);
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .btn-nav-secondary {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #334155);
    color: var(--text-secondary, #cbd5e1);
}

/* Dark Mode Mobile Drawer */
[data-theme="dark"] .mobile-drawer {
    background: var(--bg-secondary, #1e293b);
}

[data-theme="dark"] .drawer-header {
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .drawer-link {
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .drawer-link:hover {
    background: var(--bg-tertiary, #334155);
    color: var(--primary, #e0b074);
}

/* Dark Mode Search Results */
[data-theme="dark"] .search-results {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.4);
}

[data-theme="dark"] .search-result-item {
    color: var(--text-primary, #f1f5f9);
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .search-result-item:hover {
    background: var(--bg-tertiary, #334155);
}

[data-theme="dark"] .search-result-category {
    color: var(--text-muted, #94a3b8);
}

/* Smooth Transitions - Apply to specific elements only */
html,
body,
.theme-toggle,
.nav-link,
.drawer-link,
.tool-card,
.button,
input,
textarea,
select,
.card,
.alert {
    transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease;
}

/* Faster transitions for interactive elements */
button,
a,
.nav-link,
.drawer-link {
    transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease, transform 0.2s ease;
}

/* ──────────────────────────────────────────────────────────────────
   Print stylesheet — force light theme regardless of [data-theme]
   ──────────────────────────────────────────────────────────────────
   Without this block, printing (or "Save as PDF") while in dark
   theme produces near-invisible light text on white paper: the
   browser strips background colors for ink-saving but keeps the
   text color, which in dark mode is a near-white #f1f5f9. The
   result is unreadable on paper.

   Fix: reset every dark-theme CSS variable to its light counterpart
   inside @media print, and force html/body back to dark-on-white.
   This auto-applies to every JSP that loads dark-mode.css, so the
   worksheet engine, math calculators, biology tools, and any future
   tool benefits without per-tool changes.

   Also kills CSS transitions/animations during print — Chrome
   occasionally snapshots mid-transition states which prints weird. */
@media print {
    [data-theme="dark"] {
        --bg-primary:     #ffffff !important;
        --bg-secondary:   #ffffff !important;
        --bg-tertiary:    #f5f5f5 !important;
        --bg-hover:       #f5f5f5 !important;
        --text-primary:   #0f172a !important;
        --text-secondary: #334155 !important;
        --text-muted:     #64748b !important;
        --text-inverse:   #ffffff !important;
        --border:         #cbd5e1 !important;
        --border-light:   #e2e8f0 !important;
        --border-dark:    #94a3b8 !important;
    }
    /* Belt-and-suspenders: even if a rule sidesteps the vars and
       inherits from html/body, it now starts from dark-on-white. */
    [data-theme="dark"] html,
    [data-theme="dark"] body {
        background: #ffffff !important;
        color: #0f172a !important;
    }
    /* Generic per-element fallback: dark-themed surfaces commonly
       set background:#1e293b or similar. Force their backgrounds
       transparent in print so they don't carry a dark fill onto
       white paper if the browser respects background printing. */
    [data-theme="dark"] .breadcrumbs,
    [data-theme="dark"] .tool-header,
    [data-theme="dark"] .tool-main,
    [data-theme="dark"] .tool-card,
    [data-theme="dark"] .modern-nav,
    [data-theme="dark"] .page-footer,
    [data-theme="dark"] .hero,
    [data-theme="dark"] .mobile-drawer,
    [data-theme="dark"] .search-results {
        background: #ffffff !important;
        color: #0f172a !important;
    }
    /* Strip transitions and animations during print so the browser
       doesn't snapshot an in-progress fade as the printable frame. */
    *, *::before, *::after {
        transition: none !important;
        animation: none !important;
    }
}


/* ============ modern/css/footer.css ============ */
/**
 * Footer Styles
 * Shared footer styling for all pages
 */

/* Footer */
.page-footer {
    background: #0f172a;
    color: white;
    padding: 3rem 1.5rem;
    text-align: center;
    margin-top: 5rem;
    width: 100%;
    clear: both; /* Clear any floats */
}

.footer-content {
    max-width: 1200px;
    margin: 0 auto; /* Center the footer content */
    padding: 0;
}

.footer-text {
    font-size: 0.9375rem;
    opacity: 0.8;
    margin-bottom: 1rem;
}

.footer-links {
    display: flex;
    justify-content: center;
    gap: 2rem;
    flex-wrap: wrap;
    margin-top: 1.5rem;
}

.footer-link {
    color: white;
    text-decoration: none;
    opacity: 0.7;
    transition: opacity 0.2s;
    font-size: 0.875rem;
}

.footer-link:hover {
    opacity: 1;
}

/* Ensure footer is not affected by grid layouts */
.page-footer {
    display: block;
    grid-column: 1 / -1; /* Span all columns if inside grid */
}

/* Dark mode support */
[data-theme="dark"] .page-footer {
    background: #0a0f1a;
    border-top: 1px solid var(--border, #334155);
}

[data-theme="dark"] .footer-link {
    color: rgba(255, 255, 255, 0.7);
}

[data-theme="dark"] .footer-link:hover {
    color: white;
}



/* ============ modern/css/search.css ============ */
/**
 * Search Results Styling
 */

.search-results {
    position: fixed;
    background: var(--bg-primary, #ffffff);
    border: 2px solid var(--primary, #d39144);
    border-radius: 0.75rem;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25), 0 0 0 1px oklch(0.759 0.155 65.8 / 0.1);
    max-height: 400px;
    overflow-y: auto;
    z-index: 10000;
    display: none;
    margin-top: 0;
    backdrop-filter: blur(10px);
}

[data-theme="dark"] .search-results {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--primary-light, #e0b074);
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5), 0 0 0 1px oklch(0.860 0.127 77.7 / 0.2);
}

.search-results.show {
    display: block;
    animation: slideDown 0.2s ease;
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.search-result-item {
    display: flex;
    align-items: center;
    gap: var(--space-3, 0.75rem);
    padding: 1rem 1.25rem;
    text-decoration: none;
    color: var(--text-primary, #0f172a);
    border-bottom: 1px solid var(--border-light, #f1f5f9);
    background: var(--bg-primary, #ffffff);
    transition: all 0.2s ease;
    cursor: pointer;
}

.search-result-icon {
    font-size: 1.25em;
    line-height: 1;
    flex-shrink: 0;
    width: 1.5em;
    text-align: center;
}

.search-result-content {
    flex: 1;
    min-width: 0;
}

[data-theme="dark"] .search-result-item {
    color: var(--text-dark, #f1f5f9);
    border-bottom-color: var(--border, #334155);
    background: var(--bg-secondary, #1e293b);
}

.search-result-item:last-child {
    border-bottom: none;
}

.search-result-item:hover,
.search-result-item.selected {
    background: var(--primary-50, #fdf6e9);
    color: var(--primary-dark, #a17b3a);
    padding-left: 1.5rem;
    border-left: 3px solid var(--primary, #d39144);
    transform: translateX(2px);
}

[data-theme="dark"] .search-result-item:hover,
[data-theme="dark"] .search-result-item.selected {
    background: var(--bg-tertiary, #334155);
    color: var(--primary-light, #e0b074);
    border-left-color: var(--primary-light, #e0b074);
}

.search-result-category {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--text-muted, #94a3b8);
    margin-bottom: 0.375rem;
    font-weight: 600;
    display: block;
}

[data-theme="dark"] .search-result-category {
    color: var(--text-muted, #64748b);
}

.search-result-name {
    font-size: 0.9375rem;
    font-weight: 600;
    color: var(--text-primary, #0f172a);
    line-height: 1.4;
    display: block;
}

[data-theme="dark"] .search-result-name {
    color: var(--text-dark, #f1f5f9);
}

.search-result-item:hover .search-result-name,
.search-result-item.selected .search-result-name {
    color: var(--primary-dark, #a17b3a);
}

[data-theme="dark"] .search-result-item:hover .search-result-name,
[data-theme="dark"] .search-result-item.selected .search-result-name {
    color: var(--primary-light, #e0b074);
}

.search-result-name mark {
    background: var(--warning-light, #fef3c7);
    color: var(--warning, #f59e0b);
    padding: 0.125rem 0.25rem;
    border-radius: 0.25rem;
    font-weight: 700;
    box-shadow: 0 1px 2px rgba(245, 158, 11, 0.2);
}

[data-theme="dark"] .search-result-name mark {
    background: var(--warning, #f59e0b);
    color: #ffffff;
    box-shadow: 0 1px 2px rgba(245, 158, 11, 0.4);
}

.search-result-empty {
    padding: 2rem;
    text-align: center;
    color: var(--text-secondary, #64748b);
    font-size: var(--text-sm, 0.875rem);
}

[data-theme="dark"] .search-result-empty {
    color: var(--text-muted, #94a3b8);
}

/* Scrollbar for results */
.search-results::-webkit-scrollbar {
    width: 8px;
}

.search-results::-webkit-scrollbar-track {
    background: var(--bg-secondary, #f1f5f9);
    border-radius: 0 0.75rem 0.75rem 0;
}

[data-theme="dark"] .search-results::-webkit-scrollbar-track {
    background: var(--bg-tertiary, #334155);
}

.search-results::-webkit-scrollbar-thumb {
    background: var(--border-dark, #cbd5e1);
    border-radius: 4px;
    border: 2px solid transparent;
    background-clip: padding-box;
}

[data-theme="dark"] .search-results::-webkit-scrollbar-thumb {
    background: var(--border, #475569);
}

.search-results::-webkit-scrollbar-thumb:hover {
    background: var(--primary, #d39144);
}

[data-theme="dark"] .search-results::-webkit-scrollbar-thumb:hover {
    background: var(--primary-light, #e0b074);
}


/* ============ css/steganography-tool.css ============ */
/* Steganography Tool - Component Styles */

:root {
    --sg-tool: #d39144;
    --sg-tool-dark: #a17b3a;
    --sg-gradient: linear-gradient(135deg, #d39144 0%, #e6b366 100%);
    --sg-light: #fdf6e9;
}
[data-theme="dark"] {
    --sg-light: oklch(0.759 0.155 65.8 / 0.15);
}

/* ===== Compact Sidebar Override ===== */
.sg-layout .tool-input-column .tool-card-header {
    padding: 0.5rem 0.75rem;
    font-size: 0.8125rem;
}
.sg-layout .tool-input-column .tool-card-body {
    padding: 0.625rem 0.75rem;
}
.sg-layout .tool-input-column .tool-form-group {
    margin-bottom: 0.5rem;
}
.sg-layout .tool-input-column .tool-form-label {
    font-size: 0.6875rem;
    font-weight: 600;
    margin-bottom: 0.25rem;
}
.sg-layout .tool-input-column .tool-form-input {
    padding: 0.375rem 0.625rem;
    font-size: 0.75rem;
}
.sg-layout .tool-action-btn {
    padding: 0.5625rem;
    font-size: 0.8125rem;
}

/* ===== Mode Toggle ===== */
.sg-mode-toggle {
    display: flex;
    border: 1.5px solid var(--border);
    border-radius: 0.5rem;
    overflow: hidden;
    margin-bottom: 0.625rem;
}
.sg-mode-btn {
    flex: 1;
    padding: 0.375rem 0.625rem;
    font-size: 0.75rem;
    font-weight: 600;
    font-family: var(--font-sans);
    border: none;
    background: var(--bg-primary);
    color: var(--text-secondary);
    cursor: pointer;
    transition: all 0.15s;
    text-align: center;
}
.sg-mode-btn:not(:last-child) {
    border-right: 1.5px solid var(--border);
}
.sg-mode-btn.sg-active {
    background: var(--sg-gradient);
    color: #fff;
}
.sg-mode-btn:hover:not(.sg-active) {
    background: var(--sg-light);
    color: var(--sg-tool);
}

/* ===== Upload Zone ===== */
.sg-upload-zone {
    border: 2px dashed var(--border);
    border-radius: 0.5rem;
    padding: 0.75rem 0.625rem;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s;
    background: var(--bg-secondary);
}
.sg-upload-zone:hover {
    border-color: var(--sg-tool);
    background: var(--sg-light);
}
.sg-upload-zone.sg-drag-over {
    border-color: var(--sg-tool);
    background: var(--sg-light);
    box-shadow: 0 0 0 3px oklch(0.759 0.155 65.8 / 0.15);
}
.sg-upload-icon {
    display: block;
    margin: 0 auto 0.25rem;
    color: var(--text-muted);
}
.sg-upload-zone:hover .sg-upload-icon {
    color: var(--sg-tool);
}
.sg-upload-title {
    font-size: 0.75rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0 0 0.125rem;
}
.sg-upload-hint {
    font-size: 0.625rem;
    color: var(--text-muted);
    margin: 0;
}

/* ===== URL Input Row ===== */
.sg-url-row {
    display: flex;
    gap: 0.25rem;
}
.sg-url-row .tool-form-input {
    flex: 1;
    min-width: 0;
    font-family: var(--font-sans);
    font-size: 0.6875rem;
    padding: 0.3125rem 0.5rem;
}
.sg-url-btn {
    flex-shrink: 0;
    padding: 0.3125rem 0.625rem;
    font-size: 0.6875rem;
    font-weight: 600;
    font-family: var(--font-sans);
    border: 1.5px solid var(--sg-tool);
    border-radius: 0.375rem;
    background: var(--sg-light);
    color: var(--sg-tool);
    cursor: pointer;
    transition: all 0.15s;
    white-space: nowrap;
}
.sg-url-btn:hover {
    background: var(--sg-gradient);
    color: #fff;
    border-color: transparent;
}
.sg-url-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}
.sg-url-error {
    font-size: 0.625rem;
    color: #dc2626;
    margin-top: 0.125rem;
    display: none;
}
.sg-url-error.sg-visible {
    display: block;
}

/* ===== Divider ===== */
.sg-divider {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin: 0.5rem 0;
    font-size: 0.625rem;
    font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.04em;
}
.sg-divider::before,
.sg-divider::after {
    content: '';
    flex: 1;
    height: 1px;
    background: var(--border);
}

/* ===== Generator Picker ===== */
.sg-gen-grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr 1fr;
    gap: 0.375rem;
}
.sg-gen-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.125rem;
    padding: 0.375rem 0.25rem;
    border: 1.5px solid var(--border);
    border-radius: 0.375rem;
    background: var(--bg-primary);
    cursor: pointer;
    transition: all 0.15s;
    text-align: center;
}
.sg-gen-card:hover {
    border-color: var(--sg-tool);
    background: var(--sg-light);
}
.sg-gen-card.sg-gen-active {
    border-color: var(--sg-tool);
    background: var(--sg-light);
    box-shadow: 0 0 0 2px oklch(0.759 0.155 65.8 / 0.2);
}
.sg-gen-icon {
    width: 20px;
    height: 20px;
    color: var(--text-muted);
    transition: color 0.15s;
}
.sg-gen-card:hover .sg-gen-icon,
.sg-gen-card.sg-gen-active .sg-gen-icon {
    color: var(--sg-tool);
}
.sg-gen-label {
    font-size: 0.5625rem;
    font-weight: 600;
    color: var(--text-secondary);
    line-height: 1.1;
}
.sg-gen-card:hover .sg-gen-label,
.sg-gen-card.sg-gen-active .sg-gen-label {
    color: var(--sg-tool);
}

/* ===== Image Preview ===== */
.sg-image-preview {
    width: 100%;
    border-radius: 0.5rem;
    border: 1px solid var(--border);
    display: block;
    max-height: 140px;
    object-fit: contain;
    background: var(--bg-secondary);
}
.sg-image-info {
    display: flex;
    flex-direction: column;
    gap: 0.125rem;
    margin-top: 0.375rem;
}
.sg-image-info-row {
    display: flex;
    justify-content: space-between;
    font-size: 0.625rem;
    color: var(--text-secondary);
}
.sg-image-info-row span:last-child {
    font-weight: 600;
    font-family: var(--font-mono);
    color: var(--text-primary);
}
.sg-change-link {
    display: inline-block;
    margin-top: 0.375rem;
    font-size: 0.625rem;
    font-weight: 600;
    color: var(--sg-tool);
    cursor: pointer;
    background: none;
    border: none;
    padding: 0;
    text-decoration: underline;
    font-family: var(--font-sans);
}
.sg-change-link:hover {
    color: var(--sg-tool-dark);
}

/* ===== Preview Container (shown after image loaded) ===== */
.sg-preview-container {
    display: none;
}
.sg-preview-container.sg-visible {
    display: block;
}
.sg-source-container {
    display: block;
}
.sg-source-container.sg-hidden {
    display: none;
}

/* ===== Capacity Meter ===== */
.sg-capacity-meter {
    margin-top: 0.375rem;
    display: none;
}
.sg-capacity-meter.sg-visible {
    display: block;
}
.sg-capacity-bar-wrap {
    height: 5px;
    background: var(--border);
    border-radius: 3px;
    overflow: hidden;
}
.sg-capacity-bar {
    height: 100%;
    background: var(--sg-gradient);
    border-radius: 3px;
    transition: width 0.2s ease-out, background 0.3s;
    min-width: 0;
}
.sg-capacity-bar.sg-warn {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
}
.sg-capacity-bar.sg-danger {
    background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
}
.sg-capacity-text {
    display: flex;
    justify-content: space-between;
    font-size: 0.625rem;
    color: var(--text-muted);
    margin-top: 0.125rem;
}
.sg-capacity-text span:first-child {
    font-family: var(--font-mono);
    font-weight: 500;
}

/* ===== Password Toggle ===== */
.sg-password-wrap {
    position: relative;
}
.sg-password-wrap .tool-form-input {
    padding-right: 2.25rem;
}
.sg-password-toggle {
    position: absolute;
    right: 0.375rem;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    cursor: pointer;
    color: var(--text-muted);
    padding: 0.125rem;
    display: flex;
    align-items: center;
}
.sg-password-toggle:hover {
    color: var(--sg-tool);
}

/* ===== Options Row (inline password + compression) ===== */
.sg-options-row {
    display: flex;
    gap: 0.5rem;
    align-items: flex-end;
    margin-top: 0.5rem;
    padding-top: 0.5rem;
    border-top: 1px solid var(--border);
}
.sg-options-row .sg-password-group {
    flex: 1;
    min-width: 0;
}
.sg-options-row .sg-password-group .tool-form-label {
    margin-bottom: 0.1875rem;
}

/* ===== Checkbox ===== */
.sg-checkbox-label {
    display: flex;
    align-items: center;
    gap: 0.375rem;
    font-size: 0.6875rem;
    color: var(--text-secondary);
    cursor: pointer;
    white-space: nowrap;
}
.sg-checkbox-label input[type="checkbox"] {
    accent-color: var(--sg-tool);
    width: 0.875rem;
    height: 0.875rem;
}

/* ===== Initial Visual: What is Steganography animation ===== */
.sg-hero-visual {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 1.5rem 1rem 1rem;
    text-align: center;
}
.sg-hero-visual h3 {
    font-size: 1rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0 0 0.375rem;
}
.sg-hero-visual p {
    font-size: 0.8125rem;
    color: var(--text-secondary);
    line-height: 1.5;
    max-width: 360px;
    margin: 0 0 1.25rem;
}

/* Pixel grid demo */
.sg-pixel-demo {
    display: flex;
    align-items: center;
    gap: 1.5rem;
    margin-bottom: 1rem;
}
.sg-pixel-grid {
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    gap: 2px;
    width: 108px;
    flex-shrink: 0;
}
.sg-pixel {
    width: 16px;
    height: 16px;
    border-radius: 2px;
    transition: background 0.4s ease;
}
/* Row-by-row stagger for the "encoding" animation */
.sg-pixel-grid.sg-encoding .sg-pixel:nth-child(6n+1) { animation: sg-pixelFlash 3s ease-in-out infinite 0s; }
.sg-pixel-grid.sg-encoding .sg-pixel:nth-child(6n+2) { animation: sg-pixelFlash 3s ease-in-out infinite 0.15s; }
.sg-pixel-grid.sg-encoding .sg-pixel:nth-child(6n+3) { animation: sg-pixelFlash 3s ease-in-out infinite 0.3s; }
.sg-pixel-grid.sg-encoding .sg-pixel:nth-child(6n+4) { animation: sg-pixelFlash 3s ease-in-out infinite 0.45s; }
.sg-pixel-grid.sg-encoding .sg-pixel:nth-child(6n+5) { animation: sg-pixelFlash 3s ease-in-out infinite 0.6s; }
.sg-pixel-grid.sg-encoding .sg-pixel:nth-child(6n+6) { animation: sg-pixelFlash 3s ease-in-out infinite 0.75s; }

@keyframes sg-pixelFlash {
    0%, 70%, 100% { filter: brightness(1); transform: scale(1); }
    35% { filter: brightness(1.3); transform: scale(1.15); }
}

/* Arrow between grid and message */
.sg-demo-arrow {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.25rem;
    color: var(--sg-tool);
}
.sg-demo-arrow svg {
    animation: sg-arrowPulse 2s ease-in-out infinite;
}
@keyframes sg-arrowPulse {
    0%, 100% { opacity: 0.4; transform: translateX(0); }
    50% { opacity: 1; transform: translateX(3px); }
}
.sg-demo-arrow span {
    font-size: 0.5625rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

/* Message bubble */
.sg-demo-message {
    background: var(--sg-light);
    border: 1.5px solid oklch(0.759 0.155 65.8 / 0.25);
    border-radius: 0.5rem;
    padding: 0.5rem 0.75rem;
    font-family: var(--font-mono);
    font-size: 0.6875rem;
    color: var(--sg-tool-dark);
    line-height: 1.5;
    text-align: left;
    position: relative;
    animation: sg-msgReveal 1.5s ease-out forwards;
    max-width: 150px;
}
@keyframes sg-msgReveal {
    0% { opacity: 0; transform: translateX(-8px); }
    100% { opacity: 1; transform: translateX(0); }
}
[data-theme="dark"] .sg-demo-message {
    color: #e6b366;
}

/* Bits stream overlay on the pixel grid */
.sg-bits-stream {
    display: flex;
    justify-content: center;
    gap: 0.125rem;
    margin-top: 0.25rem;
    font-family: var(--font-mono);
    font-size: 0.5rem;
    font-weight: 600;
    color: var(--sg-tool);
    opacity: 0.7;
    overflow: hidden;
    width: 108px;
}
.sg-bits-stream span {
    animation: sg-bitScroll 4s linear infinite;
}
@keyframes sg-bitScroll {
    0% { opacity: 0.3; }
    50% { opacity: 1; }
    100% { opacity: 0.3; }
}
.sg-bits-stream span:nth-child(odd) { animation-delay: 0.2s; }
.sg-bits-stream span:nth-child(3n) { animation-delay: 0.5s; }

/* Steps row under the demo */
.sg-hero-steps {
    display: flex;
    gap: 0.75rem;
    justify-content: center;
    flex-wrap: wrap;
}
.sg-hero-step {
    display: flex;
    align-items: center;
    gap: 0.375rem;
    font-size: 0.6875rem;
    color: var(--text-secondary);
}
.sg-hero-step-num {
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: var(--sg-gradient);
    color: #fff;
    font-size: 0.5625rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

/* ===== Result Styles ===== */
.sg-result-message {
    padding: 1rem;
    border-radius: 0.5rem;
    margin-bottom: 1rem;
}
.sg-result-message.sg-success {
    background: #f0fdf4;
    border: 1px solid #bbf7d0;
}
[data-theme="dark"] .sg-result-message.sg-success {
    background: rgba(34, 197, 94, 0.1);
    border-color: rgba(34, 197, 94, 0.25);
}
.sg-result-message h5 {
    font-size: 0.9375rem;
    font-weight: 600;
    color: #16a34a;
    margin: 0 0 0.25rem;
}
.sg-result-message p {
    font-size: 0.8125rem;
    color: var(--text-secondary);
    margin: 0;
}
.sg-result-message.sg-error {
    background: #fef2f2;
    border: 1px solid #fecaca;
}
[data-theme="dark"] .sg-result-message.sg-error {
    background: rgba(220, 38, 38, 0.1);
    border-color: rgba(220, 38, 38, 0.25);
}
.sg-result-message.sg-error h5 {
    color: #dc2626;
}
.sg-error-list {
    margin: 0.5rem 0 0;
    padding-left: 1.25rem;
    font-size: 0.8125rem;
    color: var(--text-secondary);
    line-height: 1.6;
}

/* ===== Extracted Message Box ===== */
.sg-extracted-msg {
    font-family: var(--font-mono);
    font-size: 0.8125rem;
    line-height: 1.6;
    padding: 1rem;
    background: var(--bg-secondary);
    border: 1.5px solid var(--border);
    border-radius: 0.5rem;
    white-space: pre-wrap;
    word-break: break-word;
    color: var(--text-primary);
    max-height: 300px;
    overflow-y: auto;
}

/* ===== Result Actions ===== */
.sg-result-actions {
    display: flex;
    gap: 0.5rem;
    margin-top: 1rem;
}
.sg-result-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.375rem;
    padding: 0.5rem 1rem;
    font-size: 0.8125rem;
    font-weight: 600;
    font-family: var(--font-sans);
    border-radius: 0.5rem;
    cursor: pointer;
    transition: all 0.15s;
    border: none;
}
.sg-btn-primary {
    background: var(--sg-gradient);
    color: #fff;
}
.sg-btn-primary:hover {
    opacity: 0.9;
}
.sg-btn-secondary {
    background: var(--bg-secondary);
    color: var(--text-secondary);
    border: 1.5px solid var(--border);
}
.sg-btn-secondary:hover {
    border-color: var(--sg-tool);
    color: var(--sg-tool);
}

/* ===== Result Toolbar ===== */
.sg-result-toolbar {
    display: flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.625rem 0.75rem;
    border-top: 1.5px solid var(--border);
    background: var(--bg-secondary);
    border-radius: 0 0 0.75rem 0.75rem;
    flex-shrink: 0;
}
.sg-toolbar-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.375rem 0.625rem;
    font-size: 0.6875rem;
    font-weight: 600;
    font-family: var(--font-sans);
    border: 1px solid var(--border);
    border-radius: 0.375rem;
    background: var(--bg-primary);
    color: var(--text-secondary);
    cursor: pointer;
    transition: all 0.15s;
    white-space: nowrap;
    line-height: 1;
}
.sg-toolbar-btn:hover {
    background: var(--sg-light);
    color: var(--sg-tool);
    border-color: var(--sg-tool);
}
[data-theme="dark"] .sg-result-toolbar {
    background: var(--bg-tertiary);
}
[data-theme="dark"] .sg-toolbar-btn {
    background: var(--bg-secondary);
    border-color: var(--border);
    color: var(--text-secondary);
}
[data-theme="dark"] .sg-toolbar-btn:hover {
    background: var(--sg-light);
    color: var(--sg-tool);
    border-color: var(--sg-tool);
}

/* ===== Loading Spinner ===== */
.sg-loading {
    display: none;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 3rem 1.5rem;
    text-align: center;
}
.sg-loading.sg-visible {
    display: flex;
}
.sg-spinner {
    width: 36px;
    height: 36px;
    border: 3px solid var(--border);
    border-top-color: var(--sg-tool);
    border-radius: 50%;
    animation: sg-spin 0.8s linear infinite;
    margin-bottom: 0.75rem;
}
@keyframes sg-spin {
    to { transform: rotate(360deg); }
}
.sg-loading-text {
    font-size: 0.8125rem;
    color: var(--text-muted);
    font-weight: 500;
}

/* ===== Animations ===== */
@keyframes sg-fadeIn {
    from { opacity: 0; transform: translateY(0.5rem); }
    to { opacity: 1; transform: translateY(0); }
}
.sg-fade-in {
    animation: sg-fadeIn 0.3s ease-out;
}

/* ===== Scroll Animations ===== */
.sg-anim {
    opacity: 0;
    transform: translateY(1rem);
    transition: opacity 0.5s ease, transform 0.5s ease;
}
.sg-anim.sg-visible {
    opacity: 1;
    transform: translateY(0);
}
.sg-anim-d1 { transition-delay: 0.1s; }
.sg-anim-d2 { transition-delay: 0.2s; }
.sg-anim-d3 { transition-delay: 0.3s; }
.sg-anim-d4 { transition-delay: 0.4s; }

@media (prefers-reduced-motion: reduce) {
    .sg-anim {
        opacity: 1;
        transform: none;
        transition: none;
    }
}

/* ===== Info Box (below fold) ===== */
.sg-info-box {
    background: var(--sg-light);
    border: 1.5px solid oklch(0.759 0.155 65.8 / 0.2);
    border-left: 4px solid var(--sg-tool);
    border-radius: 0.5rem;
    padding: 1rem 1.25rem;
    font-size: 0.875rem;
    line-height: 1.7;
    color: var(--sg-tool-dark);
}
[data-theme="dark"] .sg-info-box {
    background: oklch(0.759 0.155 65.8 / 0.08);
    border-color: oklch(0.759 0.155 65.8 / 0.2);
    border-left-color: var(--sg-tool);
    color: #e6b366;
}

/* ===== Tips Grid ===== */
.sg-tips-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 0.75rem;
    margin: 1rem 0;
}
.sg-tip-card {
    padding: 1rem;
    background: var(--bg-secondary);
    border-radius: 0.5rem;
    border-left: 3px solid var(--sg-tool);
}
.sg-tip-card h4 {
    font-size: 0.875rem;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0 0 0.375rem;
}
.sg-tip-card p {
    font-size: 0.75rem;
    color: var(--text-secondary);
    margin: 0;
    line-height: 1.5;
}

/* ===== Panels visibility ===== */
.sg-panel {
    display: none;
}
.sg-panel.sg-panel-active {
    display: block;
}

/* ===== Responsive ===== */
@media (max-width: 900px) {
    .sg-mode-toggle {
        flex-direction: row;
    }
    .sg-gen-grid {
        grid-template-columns: 1fr 1fr 1fr 1fr;
    }
    .sg-result-actions {
        flex-wrap: wrap;
    }
    .sg-tips-grid {
        grid-template-columns: 1fr;
    }
    .sg-pixel-demo {
        gap: 1rem;
    }
    .sg-options-row {
        flex-direction: column;
        align-items: stretch;
    }
}
@media (max-width: 640px) {
    .sg-upload-zone {
        padding: 0.625rem 0.5rem;
    }
    .sg-gen-grid {
        grid-template-columns: 1fr 1fr;
    }
    .sg-pixel-demo {
        flex-direction: column;
        gap: 0.75rem;
    }
    .sg-demo-arrow svg {
        transform: rotate(90deg);
    }
    .sg-hero-steps {
        flex-direction: column;
        align-items: center;
    }
}

/* ===== Forensic Scanner UI ===== */
.sg-forensic-btn {
    background: var(--bg-secondary) !important;
    color: var(--text-secondary) !important;
    border: 1.5px solid var(--border) !important;
    transition: all 0.15s;
}
.sg-forensic-btn:hover:not(:disabled) {
    border-color: var(--sg-tool) !important;
    color: var(--sg-tool) !important;
    background: var(--sg-light) !important;
}
.sg-forensic-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}
.sg-forensic-hint {
    font-size: 0.625rem;
    color: var(--text-muted);
    margin: 0.25rem 0 0;
    line-height: 1.4;
}

/* Progress bar */
.sg-forensic-progress {
    padding: 2rem 1.5rem;
    text-align: center;
}
.sg-forensic-progress-label {
    font-size: 0.8125rem;
    font-weight: 500;
    color: var(--text-secondary);
    margin-bottom: 0.75rem;
}
.sg-forensic-progress-track {
    height: 6px;
    background: var(--border);
    border-radius: 3px;
    overflow: hidden;
    max-width: 320px;
    margin: 0 auto;
}
.sg-forensic-progress-bar {
    height: 100%;
    background: var(--sg-gradient);
    border-radius: 3px;
    transition: width 0.15s ease-out;
}

/* Results container */
.sg-forensic-results {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

/* Result card */
.sg-forensic-card {
    background: var(--bg-secondary);
    border: 1.5px solid var(--border);
    border-left: 4px solid var(--sg-tool);
    border-radius: 0.5rem;
    padding: 0.875rem 1rem;
}
.sg-forensic-card-header {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 0.375rem;
    flex-wrap: wrap;
}
.sg-forensic-rank {
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: var(--sg-gradient);
    color: #fff;
    font-size: 0.6875rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}
.sg-forensic-confidence {
    font-size: 0.6875rem;
    font-weight: 700;
    padding: 0.125rem 0.5rem;
    border-radius: 1rem;
    line-height: 1.3;
}
.sg-conf-high {
    background: #dcfce7;
    color: #16a34a;
}
.sg-conf-mid {
    background: #fef3c7;
    color: #d97706;
}
.sg-conf-low {
    background: #fecaca;
    color: #dc2626;
}
[data-theme="dark"] .sg-conf-high {
    background: rgba(34, 197, 94, 0.15);
    color: #4ade80;
}
[data-theme="dark"] .sg-conf-mid {
    background: rgba(217, 119, 6, 0.15);
    color: #fbbf24;
}
[data-theme="dark"] .sg-conf-low {
    background: rgba(220, 38, 38, 0.15);
    color: #f87171;
}
.sg-forensic-tool {
    font-size: 0.75rem;
    font-weight: 600;
    color: var(--text-primary);
}
.sg-forensic-details {
    font-size: 0.625rem;
    font-family: var(--font-mono);
    color: var(--text-muted);
    margin-bottom: 0.375rem;
}
.sg-forensic-also {
    font-size: 0.625rem;
    color: var(--text-muted);
    font-style: italic;
    margin-bottom: 0.375rem;
}
.sg-forensic-preview {
    font-family: var(--font-mono);
    font-size: 0.75rem;
    line-height: 1.5;
    padding: 0.5rem 0.625rem;
    background: var(--bg-primary);
    border: 1px solid var(--border);
    border-radius: 0.375rem;
    white-space: pre-wrap;
    word-break: break-word;
    color: var(--text-primary);
    max-height: 4rem;
    overflow: hidden;
}
.sg-forensic-full {
    font-family: var(--font-mono);
    font-size: 0.75rem;
    line-height: 1.5;
    padding: 0.5rem 0.625rem;
    background: var(--bg-primary);
    border: 1px solid var(--border);
    border-radius: 0.375rem;
    white-space: pre-wrap;
    word-break: break-word;
    color: var(--text-primary);
    max-height: 300px;
    overflow-y: auto;
}
.sg-forensic-full.sg-hidden {
    display: none;
}
.sg-forensic-preview.sg-hidden {
    display: none;
}
.sg-forensic-card-actions {
    display: flex;
    gap: 0.375rem;
    margin-top: 0.5rem;
}
.sg-forensic-card-actions .sg-result-btn {
    padding: 0.3125rem 0.625rem;
    font-size: 0.6875rem;
}

/* ===== Medium Toggle ===== */
.sg-medium-toggle {
    display: flex;
    border: 1.5px solid var(--border);
    border-radius: 0.5rem;
    overflow: hidden;
    margin-bottom: 0.375rem;
}
.sg-medium-btn {
    flex: 1;
    padding: 0.3125rem 0.5rem;
    font-size: 0.6875rem;
    font-weight: 600;
    font-family: var(--font-sans);
    border: none;
    background: var(--bg-primary);
    color: var(--text-secondary);
    cursor: pointer;
    transition: all 0.15s;
    text-align: center;
}
.sg-medium-btn:not(:last-child) {
    border-right: 1.5px solid var(--border);
}
.sg-medium-btn.sg-active {
    background: var(--sg-gradient);
    color: #fff;
}
.sg-medium-btn:hover:not(.sg-active) {
    background: var(--sg-light);
    color: var(--sg-tool);
}

/* ===== Bit Depth Controls ===== */
.sg-depth-group {
    margin-bottom: 0;
}
.sg-depth-controls {
    display: flex;
    gap: 0.375rem;
}
.sg-depth-controls select {
    font-size: 0.75rem;
    padding: 0.3125rem 0.5rem;
}
.sg-depth-hint {
    font-size: 0.5625rem;
    color: var(--text-muted);
    margin: 0.25rem 0 0;
    line-height: 1.4;
}

/* ===== Reed-Solomon Controls ===== */
.sg-rs-group {
    margin-bottom: 0;
}
.sg-rs-hint {
    font-size: 0.5625rem;
    color: var(--text-muted);
    margin: 0.25rem 0 0;
    line-height: 1.4;
}

/* ===== Encode Sub-Tabs ===== */
.sg-subtab-toggle {
    display: flex;
    border: 1.5px solid var(--border);
    border-radius: 0.375rem;
    overflow: hidden;
    margin-bottom: 0.5rem;
}
.sg-subtab-btn {
    flex: 1;
    padding: 0.25rem 0.5rem;
    font-size: 0.6875rem;
    font-weight: 600;
    font-family: var(--font-sans);
    border: none;
    background: var(--bg-primary);
    color: var(--text-secondary);
    cursor: pointer;
    transition: all 0.15s;
    text-align: center;
}
.sg-subtab-btn:not(:last-child) {
    border-right: 1.5px solid var(--border);
}
.sg-subtab-btn.sg-active {
    background: var(--sg-light);
    color: var(--sg-tool);
}
.sg-subtab-btn:hover:not(.sg-active) {
    background: var(--bg-secondary);
    color: var(--sg-tool);
}

/* ===== File Embed Zone ===== */
.sg-embed-zone {
    padding: 0.625rem 0.5rem;
}
.sg-embed-file-info {
    margin-top: 0.375rem;
    padding: 0.375rem 0.625rem;
    background: var(--sg-light);
    border: 1px solid oklch(0.759 0.155 65.8 / 0.2);
    border-radius: 0.375rem;
    font-size: 0.6875rem;
    color: var(--text-primary);
}

/* ===== File Download Card ===== */
.sg-file-download-card {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 1rem;
    background: var(--bg-secondary);
    border: 1.5px solid var(--border);
    border-radius: 0.5rem;
    margin-bottom: 0.5rem;
}
.sg-file-download-icon {
    color: var(--sg-tool);
    flex-shrink: 0;
}
.sg-file-download-name {
    font-size: 0.875rem;
    font-weight: 600;
    color: var(--text-primary);
    word-break: break-all;
}
.sg-file-download-size {
    font-size: 0.75rem;
    color: var(--text-muted);
    font-family: var(--font-mono);
}

/* ===== Bit Plane Controls ===== */
.sg-bitplane-pills {
    display: flex;
    gap: 0.25rem;
}
.sg-bitplane-pills select {
    font-size: 0.75rem;
}

/* Dark mode for forensic cards */
[data-theme="dark"] .sg-forensic-card {
    background: var(--bg-tertiary);
    border-color: var(--border);
    border-left-color: var(--sg-tool);
}
[data-theme="dark"] .sg-forensic-preview,
[data-theme="dark"] .sg-forensic-full {
    background: var(--bg-secondary);
    border-color: var(--border);
}

/* ============================================================
   STEGANOGRAPHY TOOL — Chanterelle theme (warm amber/golden)
   All CSS inlined: design-system + nav + three-column-tool +
   tool-page + ads + dark-mode + footer + search + sg-specific
   ============================================================ */

:root,
:root[data-theme="light"] {
    /* Chanterelle brand */
    --primary:        oklch(0.759 0.155 65.8);
    --primary-dark:   oklch(0.598 0.088 81.5);
    --primary-light:  oklch(0.860 0.127 77.7);
    --primary-50:     oklch(0.965 0.025 75 / 1);
    --primary-100:    oklch(0.935 0.045 75 / 1);

    /* Tool-page semantic */
    --tool-primary:      var(--primary);
    --tool-primary-dark: var(--primary-dark);
    --tool-gradient:     linear-gradient(135deg, oklch(0.759 0.155 65.8) 0%, oklch(0.860 0.127 77.7) 100%);
    --tool-light:        oklch(0.860 0.127 77.7 / 0.18);

    /* Steganography aliases */
    --sg-tool:      var(--primary);
    --sg-tool-dark: var(--primary-dark);
    --sg-gradient:  var(--tool-gradient);
    --sg-light:     var(--tool-light);

    /* Surfaces */
    --bg-primary:    oklch(0.998 0.005 75);
    --bg-secondary:  oklch(0.979 0.017 76.1);
    --bg-tertiary:   oklch(0.955 0.025 76);
    --bg-hover:      oklch(0.965 0.020 76);

    /* Text */
    --text-primary:   oklch(0.197 0.014 61.7);
    --text-secondary: oklch(0.420 0.018 65);
    --text-muted:     oklch(0.605 0.015 70);
    --text-inverse:   oklch(0.998 0.005 75);

    /* Borders */
    --border:       oklch(0.910 0.020 75);
    --border-light: oklch(0.955 0.020 75);
    --border-dark:  oklch(0.830 0.025 72);

    /* Semantic status (intentionally unchanged from canonical) */
    --success: #10b981; --success-light: #d1fae5;
    --warning: #f59e0b; --warning-light: #fef3c7;
    --error:   #ef4444; --error-light:   #fee2e2;
    --info:    #3b82f6; --info-light:    #dbeafe;

    /* Typography */
    --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    --font-mono: 'JetBrains Mono', 'Fira Code', 'SF Mono', Consolas, 'Liberation Mono', Menlo, monospace;
    --text-xs: 0.75rem; --text-sm: 0.875rem; --text-base: 1rem; --text-lg: 1.125rem;
    --text-xl: 1.25rem; --text-2xl: 1.5rem; --text-3xl: 1.875rem; --text-4xl: 2.25rem;
    --leading-tight: 1.25; --leading-normal: 1.5; --leading-relaxed: 1.75;
    --font-normal: 400; --font-medium: 500; --font-semibold: 600; --font-bold: 700;

    /* Spacing */
    --space-1: 0.25rem; --space-2: 0.5rem; --space-3: 0.75rem; --space-4: 1rem;
    --space-5: 1.25rem; --space-6: 1.5rem; --space-8: 2rem; --space-10: 2.5rem;
    --space-12: 3rem;  --space-16: 4rem;

    /* Shadows */
    --shadow-sm: 0 1px 2px 0 rgba(0,0,0,0.05);
    --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.10), 0 2px 4px -2px rgba(0,0,0,0.10);
    --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.10), 0 4px 6px -4px rgba(0,0,0,0.10);
    --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.10), 0 8px 10px -6px rgba(0,0,0,0.10);
    --shadow-2xl: 0 25px 50px -12px rgba(0,0,0,0.25);

    /* Radius */
    --radius-sm: 0.375rem; --radius-md: 0.5rem; --radius-lg: 0.75rem;
    --radius-xl: 1rem;     --radius-2xl: 1.5rem; --radius-full: 9999px;

    /* z-index */
    --z-dropdown: 1000; --z-sticky: 1020; --z-fixed: 1030;
    --z-modal-backdrop: 1040; --z-modal: 1050; --z-popover: 1060; --z-tooltip: 1070;

    /* Transitions */
    --transition-fast: 150ms ease-in-out;
    --transition-base: 200ms ease-in-out;
    --transition-slow: 300ms ease-in-out;

    /* Layout */
    --header-height-mobile: 64px;
    --header-height-desktop: 72px;
    --sidebar-width: 280px;
    --sidebar-width-collapsed: 0px;
    --container-max-width: 1280px;
    --content-max-width: 1200px;
}

[data-theme="dark"] {
    --primary:        oklch(0.690 0.135 68);
    --primary-dark:   oklch(0.598 0.088 81.5);
    --primary-light:  oklch(0.820 0.115 77);
    --primary-50:     oklch(0.860 0.127 77.7 / 0.18);
    --primary-100:    oklch(0.860 0.127 77.7 / 0.30);

    --tool-primary:      var(--primary);
    --tool-primary-dark: var(--primary-dark);
    --tool-gradient:     linear-gradient(135deg, oklch(0.690 0.135 68) 0%, oklch(0.598 0.088 81.5) 100%);
    --tool-light:        oklch(0.598 0.088 81.5 / 0.20);

    --sg-tool:      var(--primary);
    --sg-tool-dark: var(--primary-dark);
    --sg-gradient:  var(--tool-gradient);
    --sg-light:     var(--tool-light);

    --bg-primary:   oklch(0.197 0.014 61.7);
    --bg-secondary: oklch(0.250 0.014 62);
    --bg-tertiary:  oklch(0.305 0.014 62);
    --bg-hover:     oklch(0.250 0.014 62);

    --text-primary:   oklch(0.955 0.012 75);
    --text-secondary: oklch(0.820 0.014 72);
    --text-muted:     oklch(0.640 0.014 68);
    --text-inverse:   oklch(0.197 0.014 61.7);

    --border:       oklch(0.330 0.014 65);
    --border-light: oklch(0.420 0.014 65);
    --border-dark:  oklch(0.500 0.014 67);
}

@media (prefers-color-scheme: dark) {
    :root:not([data-theme="light"]) {
        --primary:        oklch(0.690 0.135 68);
        --primary-dark:   oklch(0.598 0.088 81.5);
        --primary-light:  oklch(0.820 0.115 77);
        --bg-primary:     oklch(0.197 0.014 61.7);
        --bg-secondary:   oklch(0.250 0.014 62);
        --bg-tertiary:    oklch(0.305 0.014 62);
        --text-primary:   oklch(0.955 0.012 75);
        --text-secondary: oklch(0.820 0.014 72);
        --text-muted:     oklch(0.640 0.014 68);
        --border:         oklch(0.330 0.014 65);
        --border-light:   oklch(0.420 0.014 65);
        --border-dark:    oklch(0.500 0.014 67);
    }
}

/* Top leaderboard ad band (replaces old description section) */
.sg-top-ad-wrap {
    max-width: 1600px;
    margin: 0 auto;
    padding: 0 1.5rem;
}
.sg-top-ad-wrap .ad-container {
    margin: 0.5rem 0 0;
    min-height: 90px;
    border-left-color: var(--primary);
}
@media (max-width: 767px) {
    .sg-top-ad-wrap { padding: 0 1rem; }
}

/* Compact page header: smaller H1, tighter padding, slim badges */
.tool-page-header {
    padding: 0.5rem 1.5rem !important;
}
.tool-page-header-inner {
    align-items: center;
    gap: 0.75rem;
}
.tool-page-title {
    font-size: 1.0625rem !important;
    font-weight: 600 !important;
    line-height: 1.25;
    letter-spacing: -0.01em;
}
.tool-breadcrumbs {
    font-size: 0.6875rem !important;
    margin-top: 0.125rem !important;
    color: var(--text-muted);
}
.tool-breadcrumbs a {
    color: var(--text-muted);
}
.tool-page-badges {
    gap: 0.3125rem;
}
.tool-page-badges .tool-badge {
    padding: 0.125rem 0.5rem;
    font-size: 0.625rem;
    font-weight: 600;
    letter-spacing: 0.01em;
}
@media (max-width: 640px) {
    .tool-page-header { padding: 0.4375rem 1rem !important; }
    .tool-page-title { font-size: 0.9375rem !important; }
    .tool-breadcrumbs { font-size: 0.625rem !important; }
}
    </style>

    <!-- Non-blocking font preload (only external CSS dependency) -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Hide Data in Images &amp; Audio</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/CipherFunctions.jsp">Cryptography</a> /
                Steganography
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Image &amp; Audio</span>
            <span class="tool-badge">AES-256</span>
            <span class="tool-badge">100% Client-Side</span>
        </div>
    </div>
</header>

<!-- Top leaderboard ad: in place of the old description paragraph -->
<div class="sg-top-ad-wrap">
    <%@ include file="modern/ads/ad-in-content-top.jsp" %>
</div>

<main class="tool-page-container sg-layout">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">

        <!-- Medium Toggle -->
        <div class="sg-medium-toggle">
            <button type="button" class="sg-medium-btn sg-active" id="sg-medium-image">Image</button>
            <button type="button" class="sg-medium-btn" id="sg-medium-audio">Audio WAV</button>
        </div>

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
                        <input type="file" id="sg-encode-file" accept="image/png,image/jpeg,image/bmp,image/webp" style="display:none;">
                        <div class="sg-upload-zone" id="sg-encode-upload-zone">
                            <svg class="sg-upload-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                <polyline points="17 8 12 3 7 8"/>
                                <line x1="12" y1="3" x2="12" y2="15"/>
                            </svg>
                            <p class="sg-upload-title">Upload an image</p>
                            <p class="sg-upload-hint">PNG, JPEG, BMP, or WebP - Click or drag and drop</p>
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

            <!-- Audio Cover Card (shown when medium=audio) -->
            <div class="tool-card sg-audio-only" style="margin-bottom:0.625rem;display:none;">
                <div class="tool-card-header" style="background:var(--sg-gradient);">Cover Audio (WAV)</div>
                <div class="tool-card-body">
                    <div class="sg-source-container" id="sg-encode-audio-source">
                        <input type="file" id="sg-encode-audio-file" accept="audio/wav,audio/wave,.wav" style="display:none;">
                        <div class="sg-upload-zone" id="sg-encode-audio-zone">
                            <svg class="sg-upload-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
                            </svg>
                            <p class="sg-upload-title">Upload a WAV file</p>
                            <p class="sg-upload-hint">PCM WAV format (8/16/24/32 bit)</p>
                        </div>
                    </div>
                    <div class="sg-preview-container" id="sg-encode-audio-preview">
                        <div id="sg-encode-audio-info"></div>
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
                            Compress (Deflate)
                        </label>
                    </div>

                    <!-- Bit Depth Controls -->
                    <div class="sg-depth-group" style="margin-top:0.5rem;padding-top:0.5rem;border-top:1px solid var(--border);">
                        <label class="tool-form-label">Bit Depth</label>
                        <div class="sg-depth-controls">
                            <select class="tool-form-input" id="sg-encode-depth-mode" style="font-family:var(--font-sans);width:auto;flex:1;">
                                <option value="at" selected>At bit N</option>
                                <option value="with">Bits 0..N</option>
                            </select>
                            <select class="tool-form-input" id="sg-encode-depth-value" style="font-family:var(--font-sans);width:auto;flex:1;">
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
                        <p class="sg-depth-hint">Higher bits = more capacity but more visible artifacts. "Bits 0..N" uses multiple bit planes for up to 8x capacity.</p>
                    </div>

                    <!-- Reed-Solomon Error Correction -->
                    <div class="sg-rs-group" style="margin-top:0.5rem;padding-top:0.5rem;border-top:1px solid var(--border);">
                        <label class="sg-checkbox-label">
                            <input type="checkbox" id="sg-encode-rs">
                            Reed-Solomon Error Correction
                        </label>
                        <div id="sg-rs-options" style="display:none;margin-top:0.375rem;">
                            <label class="tool-form-label" style="font-size:0.625rem;">Parity Level</label>
                            <select class="tool-form-input" id="sg-encode-rs-level" style="font-family:var(--font-sans);">
                                <option value="1">Low (16 bytes, ~7% overhead)</option>
                                <option value="2" selected>Medium (32 bytes, ~14% overhead)</option>
                                <option value="3">High (48 bytes, ~21% overhead)</option>
                            </select>
                            <p class="sg-rs-hint">Adds redundancy so hidden data can survive minor image edits. Higher parity = more resilience but uses more capacity.</p>
                        </div>
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
                        <input type="file" id="sg-decode-file" accept="image/png,image/jpeg,image/bmp,image/webp" style="display:none;">
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

            <!-- Audio Decode Upload (shown when medium=audio) -->
            <div class="tool-card sg-audio-only" style="margin-bottom:0.625rem;display:none;">
                <div class="tool-card-header" style="background:var(--sg-gradient);">Stego Audio (WAV)</div>
                <div class="tool-card-body">
                    <div class="sg-source-container" id="sg-decode-audio-source">
                        <input type="file" id="sg-decode-audio-file" accept="audio/wav,audio/wave,.wav" style="display:none;">
                        <div class="sg-upload-zone" id="sg-decode-audio-zone">
                            <svg class="sg-upload-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
                            </svg>
                            <p class="sg-upload-title">Upload stego WAV</p>
                            <p class="sg-upload-hint">Upload the WAV containing hidden data</p>
                        </div>
                    </div>
                    <div class="sg-preview-container" id="sg-decode-audio-preview">
                        <div id="sg-decode-audio-info"></div>
                    </div>
                </div>
            </div>

            <!-- Decode Button -->
            <button type="button" class="tool-action-btn" id="sg-decode-btn" disabled>Extract Message</button>

            <div class="sg-divider">Advanced</div>

            <!-- Decode Bit Depth -->
            <div class="tool-card" style="margin-bottom:0.625rem;">
                <div class="tool-card-body" style="padding:0.5rem 0.75rem;">
                    <label class="tool-form-label" style="font-size:0.6875rem;">Decode Bit Depth</label>
                    <div class="sg-depth-controls">
                        <select class="tool-form-input" id="sg-decode-depth-mode" style="font-family:var(--font-sans);width:auto;flex:1;">
                            <option value="at" selected>At bit N</option>
                            <option value="with">Bits 0..N</option>
                        </select>
                        <select class="tool-form-input" id="sg-decode-depth-value" style="font-family:var(--font-sans);width:auto;flex:1;">
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
                    <p class="sg-depth-hint">Match the depth settings used during encoding</p>
                </div>
            </div>

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
                        <input type="file" id="sg-analyze-file" accept="image/png,image/jpeg,image/bmp,image/webp" style="display:none;">
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

<!-- How to Use This Tool -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="sg-anim sg-anim-d2">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1.25rem;color:var(--text-primary);">How to Use This Steganography Tool</h2>

        <!-- Encode a Message -->
        <div style="margin-bottom:1.75rem;">
            <h3 style="font-size:1rem;font-weight:600;color:var(--sg-tool);margin:0 0 0.75rem;display:flex;align-items:center;gap:0.5rem;">
                <span style="display:inline-flex;align-items:center;justify-content:center;width:1.5rem;height:1.5rem;background:var(--sg-gradient);color:#fff;border-radius:50%;font-size:0.75rem;font-weight:700;flex-shrink:0;">1</span>
                Hide a Message in an Image
            </h3>
            <ol style="margin:0;padding-left:1.5rem;color:var(--text-secondary);font-size:0.875rem;line-height:1.8;">
                <li>Make sure <strong>Image</strong> is selected at the top and you are in <strong>Encode</strong> mode.</li>
                <li><strong>Upload a cover image</strong> (PNG, JPEG, or BMP) or click one of the auto-generated patterns (Gradient, Mesh, Geometric, Noise).</li>
                <li>Type your secret message in the text area. The capacity meter shows how much space is available.</li>
                <li><em>Optional:</em> Set a <strong>password</strong> for AES-256 encryption, enable <strong>Compress (Deflate)</strong> to shrink the payload, or enable <strong>Reed-Solomon</strong> error correction.</li>
                <li><em>Optional:</em> Adjust <strong>Bit Depth</strong> &mdash; use <em>At bit N</em> (single bit) for stealth or <em>Bits 0..N</em> (multi-bit) for more capacity.</li>
                <li>Click <strong>Hide Message</strong> and download the resulting PNG. It looks identical to the original.</li>
            </ol>
        </div>

        <!-- Decode a Message -->
        <div style="margin-bottom:1.75rem;">
            <h3 style="font-size:1rem;font-weight:600;color:var(--sg-tool);margin:0 0 0.75rem;display:flex;align-items:center;gap:0.5rem;">
                <span style="display:inline-flex;align-items:center;justify-content:center;width:1.5rem;height:1.5rem;background:var(--sg-gradient);color:#fff;border-radius:50%;font-size:0.75rem;font-weight:700;flex-shrink:0;">2</span>
                Extract a Hidden Message
            </h3>
            <ol style="margin:0;padding-left:1.5rem;color:var(--text-secondary);font-size:0.875rem;line-height:1.8;">
                <li>Switch to <strong>Decode</strong> mode and upload the stego image.</li>
                <li>If the message was encoded with a non-default bit depth, expand the <strong>Advanced</strong> section and set the <strong>Decode Bit Depth</strong> to match the encoding settings.</li>
                <li>Enter the <strong>password</strong> if one was used during encoding.</li>
                <li>Click <strong>Extract Message</strong>. RS-protected messages are auto-detected and errors are corrected automatically.</li>
                <li>If a file was embedded, you will see a download link with the original filename.</li>
            </ol>
        </div>

        <!-- Hide a File -->
        <div style="margin-bottom:1.75rem;">
            <h3 style="font-size:1rem;font-weight:600;color:var(--sg-tool);margin:0 0 0.75rem;display:flex;align-items:center;gap:0.5rem;">
                <span style="display:inline-flex;align-items:center;justify-content:center;width:1.5rem;height:1.5rem;background:var(--sg-gradient);color:#fff;border-radius:50%;font-size:0.75rem;font-weight:700;flex-shrink:0;">3</span>
                Embed a File (PDF, ZIP, TXT)
            </h3>
            <ol style="margin:0;padding-left:1.5rem;color:var(--text-secondary);font-size:0.875rem;line-height:1.8;">
                <li>In Encode mode, switch to the <strong>File</strong> sub-tab.</li>
                <li>Drag-and-drop any file or click to browse. The tool auto-upscales the cover image if needed.</li>
                <li>Click <strong>Hide File</strong>. The file and its original filename are embedded in the image.</li>
            </ol>
        </div>

        <!-- Audio Steganography -->
        <div style="margin-bottom:1.75rem;">
            <h3 style="font-size:1rem;font-weight:600;color:var(--sg-tool);margin:0 0 0.75rem;display:flex;align-items:center;gap:0.5rem;">
                <span style="display:inline-flex;align-items:center;justify-content:center;width:1.5rem;height:1.5rem;background:var(--sg-gradient);color:#fff;border-radius:50%;font-size:0.75rem;font-weight:700;flex-shrink:0;">4</span>
                Audio WAV Steganography
            </h3>
            <ol style="margin:0;padding-left:1.5rem;color:var(--text-secondary);font-size:0.875rem;line-height:1.8;">
                <li>Click <strong>Audio WAV</strong> at the top to switch from Image mode.</li>
                <li>Upload a PCM WAV file (8/16/24/32-bit, mono or stereo).</li>
                <li>Type your message or select a file to embed, set bit depth, then click <strong>Hide Message</strong>.</li>
                <li>Download the output WAV &mdash; it sounds identical to the original but carries your hidden data.</li>
            </ol>
        </div>

        <!-- Feature Tips -->
        <div style="background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.625rem;padding:1rem 1.25rem;">
            <h3 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.625rem;">Feature Quick Reference</h3>
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:0.75rem;font-size:0.8125rem;color:var(--text-secondary);line-height:1.6;">
                <div><strong style="color:var(--text-primary);">Bit Depth 0 (LSB)</strong> &mdash; Default, virtually undetectable. Best for covert use.</div>
                <div><strong style="color:var(--text-primary);">Bits 0..3</strong> &mdash; 4x capacity with minimal visible artifacts. Good balance.</div>
                <div><strong style="color:var(--text-primary);">Deflate Compression</strong> &mdash; Reduces payload 2-5x. Enable for long text messages.</div>
                <div><strong style="color:var(--text-primary);">Reed-Solomon ECC</strong> &mdash; Protects data from corruption. Use when sharing via social media or messaging apps.</div>
                <div><strong style="color:var(--text-primary);">AES-256 Password</strong> &mdash; Military-grade encryption. Data is unrecoverable without the password.</div>
                <div><strong style="color:var(--text-primary);">Forensic Scanner</strong> &mdash; Auto-detects 18+ stego formats. Use in Analyze mode for CTF challenges.</div>
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
                <div class="faq-answer">Steganography is the practice of hiding secret information within ordinary data such as images or audio so that no one apart from the sender and recipient knows of its existence. This tool uses Least Significant Bit (LSB) encoding which modifies the least important bits of each color channel in image pixels or audio samples. Since these tiny changes are invisible to the human eye and inaudible to the ear, the carrier file looks and sounds identical but carries a hidden message.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    What is variable bit depth and how does it increase capacity?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Variable bit depth lets you embed data in bit positions 0 through 7 of each color channel instead of just the LSB. In <strong>At bit N</strong> mode you use a single bit position for stealth, while in <strong>Bits 0..N</strong> mode you use multiple bits per channel for up to 8x the standard capacity. Bit depth 0-2 is virtually undetectable, while depth 3-7 gives maximum capacity for CTF challenges or large payloads. The decode panel must use the same depth settings as encoding.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    Can I hide data in audio WAV files?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Yes! Switch to the <strong>Audio WAV</strong> medium at the top, then upload any PCM WAV file as a cover. The tool embeds data in the least significant bits of audio samples, supporting 8-bit, 16-bit, 24-bit, and 32-bit sample formats in mono or stereo. Variable bit depth works with audio too. The output WAV sounds identical to the original but contains your hidden message or file.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    What is Reed-Solomon error correction and why use it?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Reed-Solomon (RS) is an error-correcting code that adds redundant parity bytes so your hidden data can survive corruption. Enable it when sharing stego images via social media, messaging apps, or any platform that may recompress images. Choose Low (16B), Medium (32B), or High (48B) parity. RS uses GF(2^8) Galois field arithmetic with Berlekamp-Massey decoding to automatically detect and correct errors during extraction &mdash; no user intervention needed.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    How does the Deflate compression work?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Enabling <strong>Compress (Deflate)</strong> applies real deflate compression to your message before embedding, reducing payload size by 2-5x for typical text. This means you can fit longer messages into smaller images or audio files. The tool uses the browser-native CompressionStream API for fast compression. On decoding, compressed data is auto-detected and decompressed transparently.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    Is my data safe? Does this tool upload anything?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Your data is completely safe. This tool processes everything 100% client-side in your browser using the HTML5 Canvas API, Web Crypto API, and JavaScript. No images, audio files, messages, or passwords are ever uploaded to any server. All encoding, decoding, encryption, compression, and analysis happens locally on your device. You can verify this by disconnecting from the internet and confirming the tool still works.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    How much data can I hide in an image or audio file?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">For images at the default LSB depth, the capacity is (width &times; height &times; 3) / 8 bytes. An 800&times;600 image stores about 180 KB. Using <strong>Bits 0..N</strong> mode with higher depth multiplies capacity by up to 8x. For WAV audio, capacity depends on the number of samples and bit depth &mdash; a 10-second 44100 Hz mono WAV at LSB stores about 55 KB. The real-time capacity meter updates as you change depth settings. Enabling Deflate compression further increases effective capacity by 2-5x.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="StegoCore.toggleFaq(this)">
                    What is the forensic scanner and how many formats does it support?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The forensic scanner is a universal decoder that automatically tries 18+ extraction methods to find hidden messages regardless of which steganography tool was used to encode them. It supports formats from OpenStego, Python steganography libraries, JavaScript tools, and various LSB encoding configurations including different channel orders (RGB, BGR), bit orders (MSB, LSB), length header formats (BE32, LE32, LE16), and terminators. Results are ranked by confidence score &mdash; ideal for CTF challenges and digital forensics.</div>
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
            <a href="<%=request.getContextPath()%>/hexdump.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
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
        <p class="footer-text">&copy; 2026 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

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
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/js/stego-render.js"></script>
<script src="<%=request.getContextPath()%>/js/stego-engine.js"></script>
<script src="<%=request.getContextPath()%>/js/stego-imagegen.js"></script>
<script src="<%=request.getContextPath()%>/js/stego-audio.js"></script>
<script src="<%=request.getContextPath()%>/js/stego-rs.js"></script>
<script src="<%=request.getContextPath()%>/js/stego-forensic.js"></script>
<script src="<%=request.getContextPath()%>/js/stego-core.js"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>

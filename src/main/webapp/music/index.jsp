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
    <meta name="googlebot" content="index,follow">

    <title>Free Music Tools - Guitar & Piano Chord Charts, Audio Tools | 8gwifi.org</title>
    <meta name="description" content="Free online music tools for musicians. Interactive chord charts for guitar and piano with audio playback, fingering guides, inversions, and chord progressions. Learn music theory fast!">
    <meta name="keywords" content="music tools, guitar chords, piano chords, chord finder, chord chart, music theory, learn guitar, learn piano, chord progressions, free music tools">

    <link rel="canonical" href="https://8gwifi.org/music/">

    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/music/">
    <meta property="og:title" content="Free Music Tools - Guitar & Piano Chord Charts">
    <meta property="og:description" content="Interactive chord charts with audio playback, fingering guides, and progressions. Learn guitar and piano chords fast!">
    <meta property="og:image" content="https://8gwifi.org/images/site/music-tools.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Free Music Tools - Guitar & Piano Chord Charts">
    <meta name="twitter:description" content="Interactive chord charts with audio playback, fingering guides, and progressions.">

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- Critical CSS -->
    <style>
        *{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;color:#0f172a;background:#f8fafc}
    </style>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" media="print" onload="this.media='all'">

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">

    <%@ include file="../modern/ads/ad-init.jsp" %>

    <style>
        .music-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 1rem;
            text-align: center;
        }
        .music-hero h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
        .music-hero p {
            font-size: 1.125rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        .tools-grid {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 1.5rem;
        }
        .tool-card-link {
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .tool-card {
            background: var(--bg-primary, #fff);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid var(--border, #e2e8f0);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .tool-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .tool-icon {
            width: 64px;
            height: 64px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 2rem;
        }
        .tool-icon.guitar {
            background: linear-gradient(135deg, #f97316, #ea580c);
        }
        .tool-icon.piano {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        }
        .tool-card h2 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
        }
        .tool-card p {
            color: var(--text-secondary, #475569);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        .tool-features {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }
        .tool-feature {
            background: var(--bg-secondary, #f8fafc);
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            color: var(--text-secondary);
        }
        .coming-soon-section {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .coming-soon-section h2 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            text-align: center;
        }
        .coming-soon-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }
        .coming-soon-card {
            background: var(--bg-primary);
            border: 2px dashed var(--border);
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            opacity: 0.7;
        }
        .coming-soon-card h3 {
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }
        .coming-soon-card p {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }
    </style>

    <!-- JSON-LD -->
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "Free Music Tools - Guitar & Piano Chord Charts",
  "description": "Free online music tools for musicians. Interactive chord charts for guitar and piano with audio playback, fingering guides, inversions, and chord progressions.",
  "url": "https://8gwifi.org/music/",
  "mainEntity": {
    "@type": "ItemList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "item": {
          "@type": "WebApplication",
          "name": "Guitar Chord Chart",
          "url": "https://8gwifi.org/music/guitar-chord-finder.jsp"
        }
      },
      {
        "@type": "ListItem",
        "position": 2,
        "item": {
          "@type": "WebApplication",
          "name": "Piano Chord Chart",
          "url": "https://8gwifi.org/music/piano-chord-finder.jsp"
        }
      }
    ]
  }
}
    </script>
</head>
<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <!-- Hero Section -->
    <section class="music-hero">
        <h1>Free Music Tools</h1>
        <p>Interactive chord charts, audio playback, and learning tools for guitar and piano. Master music theory and start playing your favorite songs today.</p>
    </section>

    <!-- Tools Grid -->
    <section class="tools-grid">
        <a href="<%=request.getContextPath()%>/music/guitar-chord-finder.jsp" class="tool-card-link">
            <div class="tool-card">
                <div class="tool-icon guitar">&#127928;</div>
                <h2>Guitar Chord Chart</h2>
                <p>Learn 160+ guitar chords with interactive fretboard diagrams, audio playback, chord progressions, and left-handed mode. Perfect for beginners!</p>
                <div class="tool-features">
                    <span class="tool-feature">160+ Chords</span>
                    <span class="tool-feature">Audio Playback</span>
                    <span class="tool-feature">Power Chords</span>
                    <span class="tool-feature">Progressions</span>
                    <span class="tool-feature">Left-Handed</span>
                </div>
            </div>
        </a>

        <a href="<%=request.getContextPath()%>/music/piano-chord-finder.jsp" class="tool-card-link">
            <div class="tool-card">
                <div class="tool-icon piano">&#127929;</div>
                <h2>Piano Chord Chart</h2>
                <p>Learn 100+ piano chords with interactive keyboard, fingering guides, inversions, audio playback, and chord progressions. Great for keyboard beginners!</p>
                <div class="tool-features">
                    <span class="tool-feature">100+ Chords</span>
                    <span class="tool-feature">Inversions</span>
                    <span class="tool-feature">Fingering</span>
                    <span class="tool-feature">Audio</span>
                    <span class="tool-feature">Progressions</span>
                </div>
            </div>
        </a>
    </section>

    <!-- Coming Soon -->
    <section class="coming-soon-section">
        <h2>Coming Soon</h2>
        <div class="coming-soon-grid">
            <div class="coming-soon-card">
                <h3>&#127931; Ukulele Chords</h3>
                <p>Chord diagrams for ukulele</p>
            </div>
            <div class="coming-soon-card">
                <h3>&#127926; Metronome</h3>
                <p>Practice with perfect timing</p>
            </div>
            <div class="coming-soon-card">
                <h3>&#127925; Guitar Tuner</h3>
                <p>Tune your guitar by ear</p>
            </div>
            <div class="coming-soon-card">
                <h3>&#127932; Scale Finder</h3>
                <p>Learn musical scales</p>
            </div>
        </div>
    </section>

    <%@ include file="../modern/components/support-section.jsp" %>

    <footer class="page-footer">
        <div class="footer-content">
            <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
            <div class="footer-links">
                <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
                <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            </div>
        </div>
    </footer>

    <%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>

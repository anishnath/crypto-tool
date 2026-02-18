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
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        *:focus-visible{outline:2px solid var(--primary);outline-offset:2px}
        @media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}
        :root,:root[data-theme="light"]{
            --primary:#6366f1;--primary-dark:#4f46e5;--primary-light:#818cf8;--primary-50:#eef2ff;--primary-100:#e0e7ff;
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;--bg-hover:#f8fafc;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;--text-inverse:#fff;
            --border:#e2e8f0;--border-light:#f1f5f9;--border-dark:#cbd5e1;
            --success:#10b981;--warning:#f59e0b;--error:#ef4444;--info:#3b82f6;
            --font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code','SF Mono',Consolas,monospace;
            --text-xs:0.75rem;--text-sm:0.875rem;--text-base:1rem;--text-lg:1.125rem;--text-xl:1.25rem;--text-2xl:1.5rem;
            --leading-tight:1.25;--leading-normal:1.5;
            --font-normal:400;--font-medium:500;--font-semibold:600;--font-bold:700;
            --space-1:0.25rem;--space-2:0.5rem;--space-3:0.75rem;--space-4:1rem;--space-5:1.25rem;--space-6:1.5rem;--space-8:2rem;--space-10:2.5rem;--space-12:3rem;
            --shadow-sm:0 1px 2px 0 rgba(0,0,0,0.05);--shadow-md:0 4px 6px -1px rgba(0,0,0,0.1),0 2px 4px -2px rgba(0,0,0,0.1);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1),0 4px 6px -4px rgba(0,0,0,0.1);
            --radius-sm:0.375rem;--radius-md:0.5rem;--radius-lg:0.75rem;--radius-xl:1rem;--radius-full:9999px;
            --z-dropdown:1000;--z-sticky:1020;--z-fixed:1030;--z-modal-backdrop:1040;--z-modal:1050;
            --transition-fast:150ms ease-in-out;--transition-base:200ms ease-in-out;--transition-slow:300ms ease-in-out;
            --header-height-mobile:64px;--header-height-desktop:72px;--container-max-width:1280px;
            --tool-primary:#0284c7;--tool-primary-dark:#0369a1;--tool-gradient:linear-gradient(135deg,#0284c7 0%,#0ea5e9 100%);--tool-light:#e0f2fe
        }
        @media(prefers-color-scheme:dark){:root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b}}
        [data-theme="dark"]{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--bg-hover:#1e293b;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155;--border-light:#475569;--border-dark:#64748b;--tool-light:rgba(2,132,199,0.15)}
        [data-theme="dark"] body{background-color:var(--bg-primary);color:var(--text-primary)}
        @media(min-width:768px){:root{--header-height-mobile:72px}}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed,1030);background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);box-shadow:var(--shadow-sm);height:var(--header-height-desktop,72px)}
        .nav-container{max-width:1400px;margin:0 auto;padding:0 var(--space-4,1rem);display:flex;align-items:center;justify-content:space-between;height:100%}
        .nav-logo{display:flex;align-items:center;gap:var(--space-3,0.75rem);text-decoration:none;font-weight:700;font-size:var(--text-lg,1.125rem)}
        .nav-logo img{width:32px;height:32px;border-radius:var(--radius-md,0.5rem)}
        .nav-logo span{background:linear-gradient(135deg,#6366f1 0%,#8b5cf6 50%,#ec4899 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;font-weight:700;letter-spacing:-0.02em}
        [data-theme="dark"] .nav-logo span{background:linear-gradient(135deg,#818cf8 0%,#a78bfa 50%,#f472b6 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
        .nav-items{display:flex;align-items:center;gap:var(--space-6,1.5rem);list-style:none;margin:0;padding:0}
        .nav-link{color:var(--text-secondary,#475569);text-decoration:none;font-weight:500;font-size:var(--text-base,1rem);padding:var(--space-2,0.5rem) var(--space-3,0.75rem);border-radius:var(--radius-md,0.5rem);display:flex;align-items:center;gap:var(--space-2,0.5rem)}
        .nav-actions{display:flex;align-items:center;gap:var(--space-3,0.75rem)}
        .btn-nav{padding:var(--space-2,0.5rem) var(--space-4,1rem);border-radius:var(--radius-md,0.5rem);font-size:var(--text-sm,0.875rem);font-weight:500;text-decoration:none;border:none;cursor:pointer;display:inline-flex;align-items:center;gap:var(--space-2,0.5rem);font-family:var(--font-sans)}
        .btn-nav-primary{background:var(--primary,#6366f1);color:#fff}
        .btn-nav-secondary{background:var(--bg-secondary,#f8fafc);color:var(--text-secondary,#475569);border:1px solid var(--border,#e2e8f0)}
        .mobile-menu-toggle,.mobile-search-toggle{display:none;background:none;border:none;padding:var(--space-2,0.5rem);cursor:pointer;color:var(--text-primary)}
        .mobile-menu-toggle{font-size:var(--text-xl,1.25rem);width:40px;height:40px;align-items:center;justify-content:center;border-radius:var(--radius-md,0.5rem)}
        .nav-search{position:relative;flex:1;max-width:500px;margin:0 var(--space-6,1.5rem)}
        .search-input{width:100%;padding:var(--space-2,0.5rem) var(--space-10,2.5rem) var(--space-2,0.5rem) var(--space-4,1rem);border:2px solid var(--border,#e2e8f0);border-radius:var(--radius-full,9999px);font-size:var(--text-sm,0.875rem);background:var(--bg-secondary,#f8fafc);font-family:var(--font-sans)}
        .search-icon{position:absolute;right:var(--space-4,1rem);top:50%;transform:translateY(-50%);color:var(--text-muted,#94a3b8);pointer-events:none}
        @media(max-width:991px){.modern-nav{height:var(--header-height-mobile,64px)}.nav-container{padding:0 var(--space-3,0.75rem)}.nav-search,.nav-items{display:none}.nav-actions{gap:var(--space-2,0.5rem)}.btn-nav{padding:var(--space-2,0.5rem) var(--space-3,0.75rem);font-size:var(--text-xs,0.75rem)}.mobile-menu-toggle,.mobile-search-toggle{display:flex}.btn-nav .nav-text{display:none}}
        .tool-page-header{background:var(--bg-primary,#fff);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary,#0f172a);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;gap:0.25rem;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--tool-light);color:var(--tool-primary)}
        .tool-breadcrumbs{font-size:0.8125rem;color:var(--text-secondary,#475569);margin-top:0.5rem}
        .tool-breadcrumbs a{color:var(--text-secondary,#475569);text-decoration:none}
        .tool-description-section{background:var(--tool-light);border-bottom:1px solid var(--border,#e2e8f0);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;gap:2rem}
        .tool-description-content{flex:1}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary,#475569)}
        @media(max-width:767px){.tool-description-section{padding:1rem}.tool-description-content p{font-size:0.875rem}}
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;gap:1rem;display:flex;flex-direction:column}.tool-input-column{position:relative;top:auto;max-height:none;overflow-y:visible;order:1}.tool-output-column{display:flex!important;min-height:350px;order:2}.tool-ads-column{order:3}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-output-column{display:flex;flex-direction:column;gap:1rem}
        .tool-ads-column{height:fit-content}
        .tool-card{background:var(--bg-primary,#fff);border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--tool-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem;display:flex;align-items:center;gap:0.5rem}
        .tool-card-body{padding:1rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary,#0f172a);font-size:0.8125rem}
        .tool-form-hint{font-size:0.6875rem;color:var(--text-secondary,#475569);margin-top:0.25rem}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--tool-gradient);color:#fff;margin-top:0.5rem;transition:opacity .15s,transform .15s}
        .tool-action-btn:hover{opacity:0.9}
        .tool-result-card{display:flex;flex-direction:column;height:100%}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary,#f8fafc);border-bottom:1px solid var(--border,#e2e8f0);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary,#0f172a);flex:1}
        .tool-result-content{flex:1;padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-result-actions{display:none;gap:0.5rem;padding:1rem 1.25rem;border-top:1px solid var(--border,#e2e8f0);background:var(--bg-secondary,#f8fafc);border-radius:0 0 0.75rem 0.75rem;flex-wrap:wrap}
        .tool-result-actions .tool-action-btn{flex:1;min-width:90px;margin-top:0}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted,#94a3b8)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary,#475569)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-page-header{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary,#1e293b);border-color:var(--border,#334155)}
        [data-theme="dark"] .tool-form-label{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-action-btn{box-shadow:0 4px 12px rgba(2,132,199,0.3)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary,#334155);border-bottom-color:var(--border,#475569)}
        [data-theme="dark"] .tool-result-header h4{color:var(--text-primary,#f1f5f9)}
        [data-theme="dark"] .tool-result-actions{background:var(--bg-tertiary,#334155);border-top-color:var(--border,#475569)}
        [data-theme="dark"] .tool-description-section{background:var(--bg-secondary,#1e293b);border-bottom-color:var(--border,#334155)}
        .sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border-width:0}
        .faq-item{border-bottom:1px solid var(--border,#e2e8f0)}.faq-item:last-child{border-bottom:none}
        .faq-question{display:flex;align-items:center;justify-content:space-between;width:100%;padding:0.875rem 0;background:none;border:none;font-size:0.875rem;font-weight:600;color:var(--text-primary,#0f172a);cursor:pointer;text-align:left;font-family:var(--font-sans);gap:0.75rem}
        .faq-answer{display:none;padding:0 0 0.875rem;font-size:0.8125rem;line-height:1.7;color:var(--text-secondary)}
        .faq-item.open .faq-answer{display:block}
        .faq-chevron{transition:transform 0.2s;flex-shrink:0}.faq-item.open .faq-chevron{transform:rotate(180deg)}
    </style>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Vector Calculator - Dot Product, Cross Product & Magnitude" />
        <jsp:param name="toolDescription" value="Free vector calculator with step-by-step solutions. Dot product, cross product, magnitude, unit vector, projection & angle for 2D and 3D vectors." />
        <jsp:param name="toolCategory" value="Mathematics" />
        <jsp:param name="toolUrl" value="vector-calculator.jsp" />
        <jsp:param name="toolKeywords" value="vector calculator, dot product calculator, cross product calculator, vector magnitude, angle between vectors, vector projection, unit vector calculator, vector addition, scalar multiplication, linear algebra calculator, 3D vector calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Add subtract and scale vectors,Dot product with step-by-step solution,Cross product using determinant method,Magnitude and unit vector computation,Angle between vectors,Vector projection and rejection,Parallelogram area calculation,Triple scalar product,Linear independence check,2D and 3D mode toggle,Interactive Plotly graph,Python NumPy code generation" />
        <jsp:param name="teaches" value="Vector arithmetic, dot product, cross product, vector projection, linear independence, parallelogram area, triple scalar product" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Choose dimension|Select 2D or 3D mode depending on your vectors,Select operation|Pick from 13 operations like Add Dot Product Cross Product Magnitude Projection,Enter vector components|Type x y and z values for each vector in the input fields,Click Calculate|Click Calculate to see the step-by-step solution with LaTeX rendering,View graph|Switch to Graph tab for interactive 2D or 3D visualization of your vectors,Export result|Copy LaTeX or generate NumPy Python code for your computation" />
        <jsp:param name="faq1q" value="What is the dot product of two vectors?" />
        <jsp:param name="faq1a" value="The dot product of vectors a and b is the sum of the products of their corresponding components: a dot b = a1*b1 + a2*b2 + a3*b3. It returns a scalar. If the dot product is zero the vectors are perpendicular (orthogonal). The dot product also equals |a||b|cos(theta) where theta is the angle between them." />
        <jsp:param name="faq2q" value="How do you compute the cross product?" />
        <jsp:param name="faq2a" value="The cross product a x b is computed using the determinant of a 3x3 matrix with unit vectors i j k in the first row and the components of a and b in the second and third rows. The result is a new vector perpendicular to both a and b. The cross product is only defined for 3D vectors." />
        <jsp:param name="faq3q" value="What is vector projection?" />
        <jsp:param name="faq3a" value="The projection of vector b onto vector a gives the component of b in the direction of a. The formula is proj_a(b) = (a dot b)/(a dot a) times a. The rejection is the complementary component: rej_a(b) = b minus proj_a(b). Together projection plus rejection reconstruct the original vector b." />
        <jsp:param name="faq4q" value="How do you find the angle between two vectors?" />
        <jsp:param name="faq4a" value="Use the formula theta = arccos((a dot b) / (|a| * |b|)). First compute the dot product and the magnitudes of both vectors then divide and take the inverse cosine. The result is in radians. Multiply by 180/pi to convert to degrees. Our calculator shows every step." />
        <jsp:param name="faq5q" value="What does it mean for vectors to be linearly independent?" />
        <jsp:param name="faq5a" value="Two vectors are linearly independent if neither is a scalar multiple of the other. In 2D check if the determinant of the matrix formed by the vectors is nonzero. In 3D check if their cross product is nonzero. Linearly independent vectors span the full space and form a basis." />
    </jsp:include>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>
    <%@ include file="modern/ads/ad-init.jsp" %>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/vector-calculator.css?v=<%=cacheVersion%>">
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Vector Calculator with Steps</h1>
                <nav class="tool-breadcrumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                    Vector Calculator
                </nav>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">13 Operations</span>
                <span class="tool-badge">2D &amp; 3D</span>
                <span class="tool-badge">Free &middot; No Signup</span>
            </div>
        </div>
    </header>

    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-content">
                <p>Free online <strong>vector calculator</strong> with <strong>step-by-step solutions</strong>. Compute dot product, cross product, magnitude, projection, angle, and more for <strong>2D and 3D vectors</strong>. Includes <strong>interactive graph</strong>, LaTeX export, and Python NumPy code.</p>
            </div>
        </div>
    </section>

    <main class="tool-page-container">
        <!-- ==================== INPUT COLUMN ==================== -->
        <div class="tool-input-column">
            <div class="tool-card">
                <div class="tool-card-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;">
                        <line x1="5" y1="19" x2="19" y2="5" stroke-linecap="round"/>
                        <polyline points="15 5 19 5 19 9" fill="none"/>
                    </svg>
                    Vector Calculator
                </div>
                <div class="tool-card-body">
                    <!-- Dimension Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Dimension</label>
                        <div class="vc-dim-toggle">
                            <button type="button" class="vc-dim-btn" data-dim="2">2D</button>
                            <button type="button" class="vc-dim-btn active" data-dim="3">3D</button>
                        </div>
                    </div>

                    <!-- Mode Toggle -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Operation</label>
                        <div class="vc-mode-toggle">
                            <button type="button" class="vc-mode-btn active" data-mode="add">Add</button>
                            <button type="button" class="vc-mode-btn" data-mode="subtract">Sub</button>
                            <button type="button" class="vc-mode-btn" data-mode="scalar_multiply">Scale</button>
                            <button type="button" class="vc-mode-btn" data-mode="dot_product">Dot</button>
                            <button type="button" class="vc-mode-btn" data-mode="cross_product">Cross</button>
                            <button type="button" class="vc-mode-btn" data-mode="magnitude">|v|</button>
                            <button type="button" class="vc-mode-btn" data-mode="unit_vector">Unit</button>
                            <button type="button" class="vc-mode-btn" data-mode="angle">Angle</button>
                            <button type="button" class="vc-mode-btn" data-mode="projection">Proj</button>
                            <button type="button" class="vc-mode-btn" data-mode="rejection">Rej</button>
                            <button type="button" class="vc-mode-btn" data-mode="area">Area</button>
                            <button type="button" class="vc-mode-btn" data-mode="triple_scalar">Triple</button>
                            <button type="button" class="vc-mode-btn" data-mode="linear_independence">Indep</button>
                        </div>
                    </div>

                    <!-- Vector a -->
                    <div class="vc-vector-input">
                        <label class="vc-vector-label">Vector a</label>
                        <div class="vc-vector-row">
                            <span class="vc-comp-label">x</span>
                            <input type="number" id="vc-ax" value="1" step="any" autocomplete="off">
                            <span class="vc-comp-label">y</span>
                            <input type="number" id="vc-ay" value="2" step="any" autocomplete="off">
                            <span class="vc-comp-label vc-z-field">z</span>
                            <input type="number" id="vc-az" value="3" step="any" autocomplete="off" class="vc-z-field">
                        </div>
                    </div>

                    <!-- Vector b -->
                    <div class="vc-vector-input" id="vc-vecb-group">
                        <label class="vc-vector-label">Vector b</label>
                        <div class="vc-vector-row">
                            <span class="vc-comp-label">x</span>
                            <input type="number" id="vc-bx" value="4" step="any" autocomplete="off">
                            <span class="vc-comp-label">y</span>
                            <input type="number" id="vc-by" value="-1" step="any" autocomplete="off">
                            <span class="vc-comp-label vc-z-field">z</span>
                            <input type="number" id="vc-bz" value="2" step="any" autocomplete="off" class="vc-z-field">
                        </div>
                    </div>

                    <!-- Vector c (triple scalar only) -->
                    <div class="vc-vector-input" id="vc-vecc-group" style="display:none;">
                        <label class="vc-vector-label">Vector c</label>
                        <div class="vc-vector-row">
                            <span class="vc-comp-label">x</span>
                            <input type="number" id="vc-cx" value="0" step="any" autocomplete="off">
                            <span class="vc-comp-label">y</span>
                            <input type="number" id="vc-cy" value="0" step="any" autocomplete="off">
                            <span class="vc-comp-label vc-z-field">z</span>
                            <input type="number" id="vc-cz" value="0" step="any" autocomplete="off" class="vc-z-field">
                        </div>
                    </div>

                    <!-- Scalar input -->
                    <div class="vc-scalar-input" id="vc-scalar-group" style="display:none;">
                        <label class="vc-vector-label">Scalar k</label>
                        <input type="number" id="vc-scalar" value="2" step="any" autocomplete="off">
                    </div>

                    <!-- Live Preview -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Live Preview</label>
                        <div class="vc-preview" id="vc-preview"><span style="color:var(--text-muted);font-size:0.8125rem;">Enter vector components above&hellip;</span></div>
                    </div>

                    <!-- Buttons -->
                    <button type="button" class="tool-action-btn" id="vc-calc-btn">Calculate</button>
                    <button type="button" class="tool-action-btn" id="vc-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);margin-top:0.5rem;">Clear</button>

                    <hr class="vc-sep">

                    <!-- Quick Examples -->
                    <div class="tool-form-group">
                        <label class="tool-form-label">Quick Examples</label>
                        <div class="vc-examples">
                            <button type="button" class="vc-example-chip" data-example="add-3d">Add 3D</button>
                            <button type="button" class="vc-example-chip" data-example="dot-3d">Dot Product</button>
                            <button type="button" class="vc-example-chip" data-example="cross-3d">Cross Product</button>
                            <button type="button" class="vc-example-chip" data-example="mag-2d">|&lt;3,4&gt;|=5</button>
                            <button type="button" class="vc-example-chip" data-example="angle-2d">90&deg; Angle</button>
                            <button type="button" class="vc-example-chip" data-example="proj-2d">Projection</button>
                            <button type="button" class="vc-example-chip" data-example="unit-3d">Unit Vector</button>
                            <button type="button" class="vc-example-chip" data-example="triple-3d">Triple Scalar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== OUTPUT COLUMN ==================== -->
        <div class="tool-output-column">
            <div class="vc-output-tabs">
                <button type="button" class="vc-output-tab active" data-panel="result">Result</button>
                <button type="button" class="vc-output-tab" data-panel="graph">Graph</button>
                <button type="button" class="vc-output-tab" data-panel="python">Python</button>
            </div>

            <!-- Result Panel -->
            <div class="vc-panel active" id="vc-panel-result">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" id="vc-result-content">
                        <div class="tool-empty-state" id="vc-empty-state">
                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&rarr;</div>
                            <h3>Enter vectors and click Calculate</h3>
                            <p>Supports 13 vector operations including dot product, cross product, projection, and more.</p>
                        </div>
                    </div>
                    <div class="tool-result-actions" id="vc-result-actions">
                        <button type="button" class="tool-action-btn" id="vc-copy-latex-btn">&#128203; Copy LaTeX</button>
                        <button type="button" class="tool-action-btn" id="vc-share-btn">&#128279; Share</button>
                    </div>
                </div>
            </div>

            <!-- Graph Panel -->
            <div class="vc-panel" id="vc-panel-graph">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <h4>Interactive Graph</h4>
                    </div>
                    <div style="flex:1;min-height:0;padding:0.75rem;">
                        <div id="vc-graph-container"></div>
                        <p id="vc-graph-hint" style="text-align:center;font-size:0.75rem;color:var(--text-muted);margin-top:0.5rem;">Calculate vectors to see the graph.</p>
                    </div>
                </div>
            </div>

            <!-- Python Panel -->
            <div class="vc-panel" id="vc-panel-python">
                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <h4>Python (NumPy)</h4>
                    </div>
                    <div style="flex:1;min-height:0;">
                        <iframe id="vc-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== ADS COLUMN ==================== -->
        <div class="tool-ads-column"><%@ include file="modern/ads/ad-three-column.jsp" %></div>
    </main>

    <div class="tool-mobile-ad-container"><%@ include file="modern/ads/ad-in-content-mid.jsp" %></div>

    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="vector-calculator.jsp"/>
        <jsp:param name="keyword" value="mathematics"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- ==================== EDUCATIONAL CONTENT ==================== -->
    <section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

        <!-- 1. What is a Vector -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What is a Vector?</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">A <strong>vector</strong> is a mathematical object with both <strong>magnitude</strong> (length) and <strong>direction</strong>. Unlike scalars (plain numbers), vectors encode directional information. In component form, a vector in 2D is written as <strong>v = (x, y)</strong> and in 3D as <strong>v = (x, y, z)</strong>.</p>
            <div style="background:var(--bg-secondary);border-left:3px solid var(--vc-tool,#0284c7);padding:0.75rem 1rem;border-radius:0 0.375rem 0.375rem 0;margin:0.75rem 0;font-family:var(--font-mono);font-size:0.9375rem;color:var(--text-primary);overflow-x:auto;">
                2D: &vec;v = (v<sub>x</sub>, v<sub>y</sub>) &nbsp;&nbsp;&nbsp; 3D: &vec;v = (v<sub>x</sub>, v<sub>y</sub>, v<sub>z</sub>)
            </div>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Geometrically, a vector is represented as an <strong>arrow</strong> from the origin to a point. The <strong>magnitude</strong> is the arrow's length: |v| = &radic;(x&sup2; + y&sup2;) in 2D or |v| = &radic;(x&sup2; + y&sup2; + z&sup2;) in 3D. A <strong>unit vector</strong> has magnitude 1 and indicates pure direction.</p>
            <div class="vc-edu-grid">
                <div class="vc-edu-card">
                    <h4>Position Vector</h4>
                    <p>Points from the origin to a point P. If P = (3, 4), the position vector is &lt;3, 4&gt; with magnitude 5.</p>
                </div>
                <div class="vc-edu-card">
                    <h4>Standard Unit Vectors</h4>
                    <p>In 3D: &icirc; = (1,0,0), &jcirc; = (0,1,0), k&#770; = (0,0,1). Any vector = x&icirc; + y&jcirc; + zk&#770;.</p>
                </div>
                <div class="vc-edu-card">
                    <h4>Zero Vector</h4>
                    <p>The vector 0 = (0, 0, 0) has no direction and zero magnitude. It is the additive identity.</p>
                </div>
            </div>
        </div>

        <!-- 2. Addition & Subtraction -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Vector Addition &amp; Subtraction</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Vectors are added and subtracted <strong>component-wise</strong>. Geometrically, addition follows the <strong>parallelogram rule</strong> or <strong>tip-to-tail method</strong>.</p>
            <div style="background:var(--bg-secondary);padding:1rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:1.9;overflow-x:auto;color:var(--text-primary);">
                a + b = (a<sub>x</sub>+b<sub>x</sub>, a<sub>y</sub>+b<sub>y</sub>, a<sub>z</sub>+b<sub>z</sub>)<br>
                a &minus; b = (a<sub>x</sub>&minus;b<sub>x</sub>, a<sub>y</sub>&minus;b<sub>y</sub>, a<sub>z</sub>&minus;b<sub>z</sub>)<br><br>
                <strong>Example:</strong> (1,2,3) + (4,&minus;1,2) = (5, 1, 5)
            </div>
            <p style="color:var(--text-secondary);margin-top:0.75rem;line-height:1.7;"><strong>Scalar multiplication</strong> scales each component: k&middot;v = (kv<sub>x</sub>, kv<sub>y</sub>, kv<sub>z</sub>). If k &gt; 0 the direction is preserved; if k &lt; 0 the direction is reversed.</p>
        </div>

        <!-- 3. Dot Product -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Dot Product (Scalar Product)</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The <strong>dot product</strong> of two vectors produces a <strong>scalar</strong>. It has two equivalent definitions:</p>
            <div style="background:var(--bg-secondary);border-left:3px solid var(--vc-tool,#0284c7);padding:0.75rem 1rem;border-radius:0 0.375rem 0.375rem 0;margin:0.75rem 0;font-family:var(--font-mono);font-size:0.9375rem;color:var(--text-primary);overflow-x:auto;">
                <strong>Algebraic:</strong> a &middot; b = a<sub>x</sub>b<sub>x</sub> + a<sub>y</sub>b<sub>y</sub> + a<sub>z</sub>b<sub>z</sub><br>
                <strong>Geometric:</strong> a &middot; b = |a| |b| cos&theta;
            </div>
            <p style="color:var(--text-secondary);margin-bottom:0.5rem;line-height:1.7;"><strong>Key properties:</strong></p>
            <ul style="color:var(--text-secondary);line-height:2;padding-left:1.25rem;margin:0 0 0.75rem;">
                <li>If a &middot; b = 0, the vectors are <strong>orthogonal</strong> (perpendicular)</li>
                <li>If a &middot; b &gt; 0, the angle between them is acute (&lt; 90&deg;)</li>
                <li>If a &middot; b &lt; 0, the angle is obtuse (&gt; 90&deg;)</li>
                <li>a &middot; a = |a|&sup2; (magnitude squared)</li>
            </ul>
        </div>

        <!-- 4. Cross Product -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Cross Product (Vector Product)</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The <strong>cross product</strong> of two 3D vectors produces a new <strong>vector perpendicular</strong> to both inputs. It is computed using the determinant of a 3&times;3 matrix:</p>
            <div style="background:var(--bg-secondary);padding:1rem;border-radius:0.5rem;font-family:var(--font-mono);font-size:0.8125rem;line-height:1.9;overflow-x:auto;color:var(--text-primary);">
                a &times; b = det |&icirc; &jcirc; k&#770;| = (a<sub>y</sub>b<sub>z</sub> &minus; a<sub>z</sub>b<sub>y</sub>)&icirc;<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|a<sub>x</sub> a<sub>y</sub> a<sub>z</sub>| &minus; (a<sub>x</sub>b<sub>z</sub> &minus; a<sub>z</sub>b<sub>x</sub>)&jcirc;<br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|b<sub>x</sub> b<sub>y</sub> b<sub>z</sub>| + (a<sub>x</sub>b<sub>y</sub> &minus; a<sub>y</sub>b<sub>x</sub>)k&#770;
            </div>
            <p style="color:var(--text-secondary);margin-top:0.75rem;line-height:1.7;"><strong>Key facts:</strong> |a &times; b| = |a||b|sin&theta; = area of the parallelogram. The direction follows the <strong>right-hand rule</strong>. The cross product is anti-commutative: a &times; b = &minus;(b &times; a). It is only defined in 3D.</p>
        </div>

        <!-- 5. Projection & Rejection -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Vector Projection &amp; Rejection</h2>
            <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">The <strong>projection</strong> of b onto a gives the component of b in the direction of a. The <strong>rejection</strong> is the perpendicular remainder.</p>
            <div style="background:var(--bg-secondary);border-left:3px solid var(--vc-tool,#0284c7);padding:0.75rem 1rem;border-radius:0 0.375rem 0.375rem 0;margin:0.75rem 0;font-family:var(--font-mono);font-size:0.9375rem;color:var(--text-primary);overflow-x:auto;">
                proj<sub>a</sub>(b) = [(a &middot; b) / (a &middot; a)] &middot; a<br>
                rej<sub>a</sub>(b) = b &minus; proj<sub>a</sub>(b)
            </div>
            <p style="color:var(--text-secondary);line-height:1.7;">The projection and rejection are always <strong>orthogonal</strong>: proj &middot; rej = 0. Together they decompose b into parallel and perpendicular components relative to a. This decomposition is fundamental in physics (work = F &middot; d), computer graphics (lighting), and signal processing.</p>
        </div>

        <!-- 6. Applications -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Applications of Vectors</h2>
            <div class="vc-edu-grid">
                <div class="vc-edu-card">
                    <h4>Physics</h4>
                    <p>Force, velocity, acceleration, momentum, electric/magnetic fields are all vectors. Work = F &middot; d (dot product). Torque = r &times; F (cross product).</p>
                </div>
                <div class="vc-edu-card">
                    <h4>Computer Graphics</h4>
                    <p>Surface normals (cross product), lighting calculations (dot product), camera direction, ray tracing, and 3D transformations.</p>
                </div>
                <div class="vc-edu-card">
                    <h4>Engineering</h4>
                    <p>Structural analysis, fluid dynamics, navigation (GPS vectors), robotics (joint angles), and electromagnetic field analysis.</p>
                </div>
                <div class="vc-edu-card">
                    <h4>Machine Learning</h4>
                    <p>Feature vectors, cosine similarity (dot product), gradient descent, word embeddings, and high-dimensional data representation.</p>
                </div>
            </div>
        </div>

        <!-- 7. Quick Reference Table -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Vector Operations Quick Reference</h2>
            <table class="vc-ops-table">
                <thead><tr><th style="width:22%;">Operation</th><th style="width:38%;">Formula</th><th>Returns</th><th>Dim</th></tr></thead>
                <tbody>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Addition</td><td>a + b = (a<sub>i</sub>+b<sub>i</sub>)</td><td>Vector</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Subtraction</td><td>a &minus; b = (a<sub>i</sub>&minus;b<sub>i</sub>)</td><td>Vector</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Scalar Multiply</td><td>k&middot;a = (k&middot;a<sub>i</sub>)</td><td>Vector</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Dot Product</td><td>&sum; a<sub>i</sub>b<sub>i</sub></td><td>Scalar</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Cross Product</td><td>det[&icirc; &jcirc; k&#770;; a; b]</td><td>Vector</td><td>3D only</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Magnitude</td><td>&radic;(&sum; a<sub>i</sub>&sup2;)</td><td>Scalar</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Unit Vector</td><td>a / |a|</td><td>Vector</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Angle</td><td>arccos(a&middot;b / |a||b|)</td><td>Angle</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Projection</td><td>(a&middot;b/a&middot;a)&middot;a</td><td>Vector</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Rejection</td><td>b &minus; proj<sub>a</sub>(b)</td><td>Vector</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Area</td><td>|a &times; b| or |a<sub>x</sub>b<sub>y</sub>&minus;a<sub>y</sub>b<sub>x</sub>|</td><td>Scalar</td><td>2D/3D</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Triple Scalar</td><td>a &middot; (b &times; c)</td><td>Scalar</td><td>3D only</td></tr>
                    <tr><td style="font-family:var(--font-sans);font-weight:500;">Linear Indep.</td><td>a &times; b &ne; 0 (3D) or det &ne; 0 (2D)</td><td>Boolean</td><td>2D/3D</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 8. FAQ -->
        <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
            <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is the dot product of two vectors?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The dot product of vectors a and b is the sum of the products of their corresponding components: a &middot; b = a<sub>1</sub>b<sub>1</sub> + a<sub>2</sub>b<sub>2</sub> + a<sub>3</sub>b<sub>3</sub>. It returns a scalar. If the dot product is zero, the vectors are perpendicular (orthogonal). The dot product also equals |a||b|cos(&theta;) where &theta; is the angle between them.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you compute the cross product?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The cross product a &times; b is computed using the determinant of a 3&times;3 matrix with unit vectors &icirc;, &jcirc;, k&#770; in the first row and the components of a and b in the second and third rows. The result is a new vector perpendicular to both a and b. The cross product is only defined for 3D vectors.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What is vector projection?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">The projection of vector b onto vector a gives the component of b in the direction of a. The formula is proj<sub>a</sub>(b) = (a &middot; b)/(a &middot; a) &times; a. The rejection is the complementary component: rej<sub>a</sub>(b) = b &minus; proj<sub>a</sub>(b). Together they reconstruct the original vector b.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">How do you find the angle between two vectors?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Use the formula &theta; = arccos((a &middot; b) / (|a| &times; |b|)). First compute the dot product and the magnitudes of both vectors, then divide and take the inverse cosine. The result is in radians; multiply by 180/&pi; to convert to degrees.</div></div>
            <div class="faq-item"><button class="faq-question" onclick="toggleFaq(this)">What does it mean for vectors to be linearly independent?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button><div class="faq-answer">Two vectors are linearly independent if neither is a scalar multiple of the other. In 2D, check if the determinant of the matrix formed by the vectors is nonzero. In 3D, check if their cross product is nonzero. Linearly independent vectors span the full space and form a basis.</div></div>
        </div>
    </section>

    <%@ include file="modern/components/support-section.jsp" %>

    <footer class="page-footer"><div class="footer-content"><p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p><div class="footer-links"><a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a><a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a><a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a></div></div></footer>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/vector-calculator-render.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/vector-calculator-graph.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/vector-calculator-export.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/js/vector-calculator-core.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
</body>
</html>

#!/usr/bin/env node
/**
 * Migrate statistics sidebar JSPs from legacy 3-column layout to Math Studio shell.
 * Run: node scripts/migrate-stats-math-studio.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const WEBAPP = path.join(__dirname, '../src/main/webapp');

const PAGES = [
  { file: 'summary-statistics-calculator.jsp', activeService: 'summary-stats', title: 'Summary Statistics Calculator', subtitle: 'Mean · median · mode · SD · quartiles · histogram', crumb: 'Summary Statistics' },
  { file: 'mean-median-mode.jsp', activeService: 'mean-median-mode', title: 'Mean, Median & Mode Calculator', subtitle: 'Central tendency · frequency table · step-by-step', crumb: 'Mean / Median / Mode' },
  { file: 'standard-deviation.jsp', activeService: 'stddev', title: 'Standard Deviation Calculator', subtitle: 'Sample & population σ · bell curve · deviation table', crumb: 'Standard Deviation' },
  { file: 'variance-calculator.jsp', activeService: 'variance', title: 'Variance Calculator', subtitle: 'Sample & population variance · deviation chart · steps', crumb: 'Variance' },
  { file: 'percentile-calculator.jsp', activeService: 'percentile', title: 'Percentile Calculator', subtitle: 'Percentile rank · quartiles · box plot', crumb: 'Percentile' },
  { file: 'z-score-calculator.jsp', activeService: 'z-score', title: 'Z-Score Calculator', subtitle: 'Standardize · normal CDF · percentile · reverse lookup', crumb: 'Z-Score' },
  { file: 'normal-distribution-calculator.jsp', activeService: 'normal-dist', title: 'Normal Distribution Calculator', subtitle: 'PDF · CDF · inverse · shaded curve', crumb: 'Normal Distribution' },
  { file: 'binomial-distribution-calculator.jsp', activeService: 'binomial-dist', title: 'Binomial Distribution Calculator', subtitle: 'PMF · CDF · exact & cumulative · PMF chart', crumb: 'Binomial Distribution' },
  { file: 'probability-calculator.jsp', activeService: 'probability', title: 'Probability Calculator', subtitle: 'Combinatorics · conditional · Bayes · unions', crumb: 'Probability' },
  { file: 'confidence-interval-calculator.jsp', activeService: 'confidence', title: 'Confidence Interval Calculator', subtitle: 'Mean · proportion · two-sample · CI chart', crumb: 'Confidence Interval' },
  { file: 'hypothesis-test-calculator.jsp', activeService: 'hypothesis', title: 'Hypothesis Test Calculator', subtitle: 'Z & t tests · proportions · p-value · distribution plot', crumb: 'Hypothesis Test' },
  { file: 't-test-calculator.jsp', activeService: 't-test', title: 'T-Test Calculator', subtitle: 'One-sample · two-sample · paired · Welch · t curve', crumb: 'T-Test' },
  { file: 'chi-square-calculator.jsp', activeService: 'chi-square', title: 'Chi-Square Calculator', subtitle: 'Goodness of fit · independence · χ² distribution', crumb: 'Chi-Square' },
  { file: 'anova-calculator.jsp', activeService: 'anova', title: 'ANOVA Calculator', subtitle: 'One-way ANOVA · F-statistic · group charts', crumb: 'ANOVA' },
  { file: 'correlation-calculator.jsp', activeService: 'correlation', title: 'Correlation Calculator', subtitle: 'Pearson r · scatter plot · covariance', crumb: 'Correlation' },
  { file: 'linear-regression-calculator.jsp', activeService: 'regression', title: 'Linear Regression Calculator', subtitle: 'Least squares · R² · residual plot · prediction', crumb: 'Linear Regression' },
  { file: 'sample-size-calculator.jsp', activeService: 'sample-size', title: 'Sample Size Calculator', subtitle: 'Power analysis · margin of error · proportion & mean', crumb: 'Sample Size' },
  { file: 'effect-size-calculator.jsp', activeService: 'effect-size', title: 'Effect Size Calculator', subtitle: "Cohen's d · Pearson r · η² · odds ratio", crumb: 'Effect Size' },
  { file: 'standard-error-calculator.jsp', activeService: 'std-error', title: 'Standard Error Calculator', subtitle: 'SE of mean · proportion · difference · CI chart', crumb: 'Standard Error' },
  { file: 'outlier-detection-calculator.jsp', activeService: 'outlier', title: 'Outlier Detection Calculator', subtitle: 'IQR · Z-score · modified Z · scatter plot', crumb: 'Outlier Detection' },
  { file: 'p-value-calculator.jsp', activeService: 'p-value', title: 'P-Value Calculator', subtitle: 'Z · t · χ² · F tests · distribution shading', crumb: 'P-Value' },
];

function stripInlineCriticalCss(src) {
  return src.replace(/<style>\s*\*,\*::before[\s\S]*?<\/style>\s*/m, '');
}

function stripLegacyHeadAssets(src) {
  let s = src;
  s = s.replace(/<link rel="stylesheet" href="https:\/\/fonts\.googleapis\.com[^>]+>\s*/g, '');
  s = s.replace(/<noscript><link rel="stylesheet" href="https:\/\/fonts\.googleapis\.com[^<]+<\/noscript>\s*/g, '');
  s = s.replace(/<link rel="preload" href="[^"]*\/modern\/css\/[^"]+"[^>]*>\s*/g, '');
  s = s.replace(/<noscript>[\s\S]*?<\/noscript>\s*(?=<%@ include file="modern\/ads\/ad-init)/m, '');
  s = s.replace(/<%@ include file="modern\/ads\/ad-init\.jsp" %>\s*/g, '');
  s = s.replace(/<link rel="stylesheet" href="https:\/\/cdn\.jsdelivr\.net\/npm\/katex[^>]+>\s*/g, '');
  s = s.replace(/<link rel="stylesheet" href="[^"]*\/css\/statistics-calculator\.css[^"]*"[^>]*>\s*/g, '');
  return s;
}

function ensurePagePreamble(src) {
  if (src.includes('ai-assistant-vars.inc.jsp')) return src;
  return src.replace(
    /<%\s*\n\s*String cacheVersion = String\.valueOf\(System\.currentTimeMillis\(\)\);\s*\n%>/,
    `<%
    String v = String.valueOf(System.currentTimeMillis());
    request.setAttribute("v", v);
    request.setAttribute("aiToolId", "math-ai");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>`,
  ).replace(/String cacheVersion/g, 'String v');
}

function insertShellHead(src) {
  if (src.includes('math-studio-shell-head.inc.jsp')) return src;
  const marker = '</jsp:include>\n';
  const idx = src.indexOf('</jsp:include>');
  if (idx === -1) throw new Error('No seo jsp:include close found');
  const insertAt = idx + marker.length;
  return src.slice(0, insertAt) +
    `\n    <%@ include file="modern/components/math-studio-shell-head.inc.jsp" %>\n` +
    src.slice(insertAt);
}

function extractBetween(src, startMarker, endMarker) {
  const start = src.indexOf(startMarker);
  if (start === -1) return null;
  const end = src.indexOf(endMarker, start + startMarker.length);
  if (end === -1) return null;
  return src.slice(start + startMarker.length, end).trim();
}

function unwrapInputColumn(inputCol) {
  let inner = inputCol;
  inner = inner.replace(/<div class="tool-input-column">\s*/i, '');
  inner = inner.replace(/<div class="tool-card">\s*<div class="tool-card-header">[\s\S]*?<\/div>\s*<div class="tool-card-body">\s*/i, '');
  inner = inner.replace(/\s*<\/div>\s*<\/div>\s*$/i, '');
  return inner.trim();
}

function unwrapOutputColumn(outputCol) {
  let inner = outputCol;
  inner = inner.replace(/<div class="tool-output-column">\s*/i, '');
  inner = inner.replace(/\s*<\/div>\s*$/i, '');
  return inner.trim();
}

function migrateBody(src, page) {
  const inputRaw = extractBetween(src, '<!-- ==================== INPUT COLUMN ==================== -->', '<!-- ==================== OUTPUT COLUMN ==================== -->');
  const outputRaw = extractBetween(src, '<!-- ==================== OUTPUT COLUMN ==================== -->', '<!-- ==================== ADS COLUMN ==================== -->');
  if (!inputRaw || !outputRaw) throw new Error('Could not find input/output columns');

  const inputInner = unwrapInputColumn(inputRaw);
  const outputInner = unwrapOutputColumn(outputRaw);

  let edu = extractBetween(src, '<!-- ==================== EDUCATIONAL CONTENT ==================== -->', '<%@ include file="modern/components/support-section.jsp" %>');
  if (!edu) {
    edu = extractBetween(src, '<section class="tool-expertise-section"', '<%@ include file="modern/components/support-section.jsp" %>');
    if (edu) edu = '<section class="tool-expertise-section"' + edu;
  }
  edu = (edu || '').trim();

  const related = extractBetween(src, '<jsp:include page="modern/components/related-tools.jsp">', '</jsp:include>');
  const relatedBlock = related
    ? `<jsp:include page="modern/components/related-tools.jsp">\n${related}\n</jsp:include>\n\n`
    : '';

  const bodyStart = `<body class="ms-body">

<%@ include file="modern/components/nav-header.jsp" %>
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <% request.setAttribute("activeService", "${page.activeService}"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">${page.crumb}</span>
            </nav>
            <h1>${page.title}</h1>
            <p class="ms-subtitle">${page.subtitle}</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
${inputInner.split('\n').map(l => '                    ' + l).join('\n')}
                </div>
            </div>

            <div class="ic-result-card">
${outputInner.split('\n').map(l => '                ' + l).join('\n')}
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

${relatedBlock}${edu ? edu.replace('class="tool-expertise-section"', 'class="tool-expertise-section ms-below-fold"').split('\n').map(l => '        ' + l).join('\n') : ''}

        <%@ include file="modern/components/support-section.jsp" %>

    </section><!-- /.ms-workspace -->

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>
`;

  const bodyEnd = `
<script>window.__MS_STAT_PAGE__ = { key: '${page.activeService}', label: ${JSON.stringify(page.title)} };</script>
<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>
`;

  // Extract scripts block before </body>
  const scriptsMatch = src.match(/<!-- Scripts -->[\s\S]*?(?=<\/body>)/);
  const scripts = scriptsMatch ? scriptsMatch[0].trim() : '';
  const scriptsWithCategories = scripts.includes('categories-menu.js')
    ? scripts
    : scripts.replace(
      '<script src="<%=request.getContextPath()%>/modern/js/search.js',
      '<script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>\n    <script src="<%=request.getContextPath()%>/modern/js/search.js',
    );

  // Replace body
  const bodyMatch = src.match(/<body[\s\S]*<\/html>/);
  if (!bodyMatch) throw new Error('No body found');
  return src.replace(bodyMatch[0], bodyStart + '\n' + scriptsWithCategories + '\n' + bodyEnd);
}

for (const page of PAGES) {
  const filePath = path.join(WEBAPP, page.file);
  if (!fs.existsSync(filePath)) {
    console.warn('SKIP missing:', page.file);
    continue;
  }
  let src = fs.readFileSync(filePath, 'utf8');
  if (src.includes('class="ms-body"')) {
    console.log('SKIP already migrated:', page.file);
    continue;
  }
  try {
    src = ensurePagePreamble(src);
    src = stripInlineCriticalCss(src);
    src = stripLegacyHeadAssets(src);
    src = insertShellHead(src);
    src = migrateBody(src, page);
    // Fix cacheVersion -> v in scripts
    src = src.replace(/cacheVersion/g, 'v');
    fs.writeFileSync(filePath, src, 'utf8');
    console.log('OK', page.file);
  } catch (err) {
    console.error('FAIL', page.file, err.message);
  }
}

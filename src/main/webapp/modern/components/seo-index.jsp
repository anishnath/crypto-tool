<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Comprehensive SEO for Index pages.

    Default behaviour (no `section` param OR section="home") emits the
    full homepage JSON-LD bundle: WebSite + ItemList categories +
    CollectionPage with top 45 tools + Organization + FAQPage + Service.

    Setting section="math" emits math-section schemas instead:
      · CollectionPage @id=/math/ with 49 calculators in mainEntity ItemList
      · BreadcrumbList: Home › Math
      · Course schema with curriculum CourseInstances
      · EducationalAudience + learningResourceType signals
      · FAQ specific to the math index page

    Usage from math/index.jsp:
        <jsp:include page="../modern/components/seo-index.jsp">
            <jsp:param name="section" value="math"/>
        </jsp:include>
--%>

<%
    String baseUrl = "https://8gwifi.org";
    String currentUrl = baseUrl + request.getRequestURI();
    String section = request.getParameter("section");
    if (section == null || section.isEmpty()) section = "home";
%>

<% if ("math".equals(section)) { %>

<!-- ═══════════════════════════════════════════════════════════════════
     MATH SECTION SCHEMAS (section="math")
     Used by /math/index.jsp.  Deeper coverage than the per-tool
     seo-tool-page partial: the CollectionPage + ItemList tells Google
     "these 49 pages form a coherent collection," which unlocks the
     site-link rich card and improves intra-section ranking.
   ═══════════════════════════════════════════════════════════════════ -->

<!-- JSON-LD: CollectionPage + ItemList (49 calculators) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "@id": "<%= baseUrl %>/math/",
  "name": "Math Calculators &mdash; Free Online Step-by-Step Solvers",
  "description": "49 free math calculators with step-by-step CAS-verified solutions covering percentages, algebra, statistics, calculus, linear algebra, trigonometry, logarithms, and more. Every tool is mobile-responsive, free, and requires no signup.",
  "url": "<%= baseUrl %>/math/",
  "image": "<%= baseUrl %>/images/site/math-studio-og.png",
  "isPartOf": {
    "@type": "WebSite",
    "name": "8gwifi.org",
    "url": "<%= baseUrl %>"
  },
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [
      { "@type": "ListItem", "position": 1, "name": "Home", "item": "<%= baseUrl %>" },
      { "@type": "ListItem", "position": 2, "name": "Math",  "item": "<%= baseUrl %>/math/" }
    ]
  },
  "audience": {
    "@type": "EducationalAudience",
    "educationalRole": "student"
  },
  "educationalLevel": "Middle School, High School, AP, Undergraduate",
  "learningResourceType": ["Calculator", "Worksheet", "Step-by-step solver"],
  "inLanguage": "en",
  "mainEntity": {
    "@type": "ItemList",
    "name": "Math Calculators",
    "numberOfItems": 49,
    "itemListElement": [
      {"@type": "ListItem", "position": 1,  "name": "Percentage Calculator",                       "url": "<%= baseUrl %>/percentage-calculator.jsp"},
      {"@type": "ListItem", "position": 2,  "name": "Exponent Calculator",                         "url": "<%= baseUrl %>/exponent-calculator.jsp"},
      {"@type": "ListItem", "position": 3,  "name": "Logarithm Calculator",                        "url": "<%= baseUrl %>/logarithm-calculator.jsp"},
      {"@type": "ListItem", "position": 4,  "name": "Significant Figures Calculator",              "url": "<%= baseUrl %>/significant-figures-calculator.jsp"},
      {"@type": "ListItem", "position": 5,  "name": "Quadratic Equation Solver",                   "url": "<%= baseUrl %>/quadratic-solver.jsp"},
      {"@type": "ListItem", "position": 6,  "name": "Linear Equations Solver",                     "url": "<%= baseUrl %>/linear-equations-solver.jsp"},
      {"@type": "ListItem", "position": 7,  "name": "System of Equations Solver",                  "url": "<%= baseUrl %>/system-equations-solver.jsp"},
      {"@type": "ListItem", "position": 8,  "name": "Inequality Solver",                           "url": "<%= baseUrl %>/inequality-solver.jsp"},
      {"@type": "ListItem", "position": 9,  "name": "24 Game Solver",                              "url": "<%= baseUrl %>/24-game-solver.jsp"},
      {"@type": "ListItem", "position": 10, "name": "Taylor & Maclaurin Series Calculator",        "url": "<%= baseUrl %>/series-calculator.jsp"},
      {"@type": "ListItem", "position": 11, "name": "Derivative Calculator",                       "url": "<%= baseUrl %>/derivative-calculator.jsp"},
      {"@type": "ListItem", "position": 12, "name": "Integral Calculator",                         "url": "<%= baseUrl %>/integral-calculator.jsp"},
      {"@type": "ListItem", "position": 13, "name": "Limit Calculator",                            "url": "<%= baseUrl %>/limit-calculator.jsp"},
      {"@type": "ListItem", "position": 14, "name": "Polynomial Calculator",                       "url": "<%= baseUrl %>/polynomial-calculator.jsp"},
      {"@type": "ListItem", "position": 15, "name": "Matrix Determinant Calculator",               "url": "<%= baseUrl %>/matrix-determinant-calculator.jsp"},
      {"@type": "ListItem", "position": 16, "name": "Matrix Multiplication Calculator",            "url": "<%= baseUrl %>/matrix-multiplication-calculator.jsp"},
      {"@type": "ListItem", "position": 17, "name": "Matrix Inverse Calculator",                   "url": "<%= baseUrl %>/matrix-inverse-calculator.jsp"},
      {"@type": "ListItem", "position": 18, "name": "Matrix Eigenvalue Calculator",                "url": "<%= baseUrl %>/matrix-eigenvalue-calculator.jsp"},
      {"@type": "ListItem", "position": 19, "name": "Matrix Rank Calculator",                      "url": "<%= baseUrl %>/matrix-rank-calculator.jsp"},
      {"@type": "ListItem", "position": 20, "name": "Matrix Addition Calculator",                  "url": "<%= baseUrl %>/matrix-addition-calculator.jsp"},
      {"@type": "ListItem", "position": 21, "name": "Matrix Power Calculator",                     "url": "<%= baseUrl %>/matrix-power-calculator.jsp"},
      {"@type": "ListItem", "position": 22, "name": "Matrix Transpose Calculator",                 "url": "<%= baseUrl %>/matrix-transpose-calculator.jsp"},
      {"@type": "ListItem", "position": 23, "name": "Matrix Type Classifier",                      "url": "<%= baseUrl %>/matrix-type-classifier.jsp"},
      {"@type": "ListItem", "position": 24, "name": "Vector Calculator",                           "url": "<%= baseUrl %>/vector-calculator.jsp"},
      {"@type": "ListItem", "position": 25, "name": "Trig Function Calculator",                    "url": "<%= baseUrl %>/trigonometric-function-calculator.jsp"},
      {"@type": "ListItem", "position": 26, "name": "Trig Identity Calculator",                    "url": "<%= baseUrl %>/trigonometric-identity-calculator.jsp"},
      {"@type": "ListItem", "position": 27, "name": "Trig Equation Solver",                        "url": "<%= baseUrl %>/trigonometric-equation-solver.jsp"},
      {"@type": "ListItem", "position": 28, "name": "Summary Statistics Calculator",               "url": "<%= baseUrl %>/summary-statistics-calculator.jsp"},
      {"@type": "ListItem", "position": 29, "name": "Standard Deviation Calculator",               "url": "<%= baseUrl %>/standard-deviation.jsp"},
      {"@type": "ListItem", "position": 30, "name": "Mean Median Mode Calculator",                 "url": "<%= baseUrl %>/mean-median-mode.jsp"},
      {"@type": "ListItem", "position": 31, "name": "Variance Calculator",                         "url": "<%= baseUrl %>/variance-calculator.jsp"},
      {"@type": "ListItem", "position": 32, "name": "Percentile Calculator",                       "url": "<%= baseUrl %>/percentile-calculator.jsp"},
      {"@type": "ListItem", "position": 33, "name": "Z-Score Calculator",                          "url": "<%= baseUrl %>/z-score-calculator.jsp"},
      {"@type": "ListItem", "position": 34, "name": "Normal Distribution Calculator",              "url": "<%= baseUrl %>/normal-distribution-calculator.jsp"},
      {"@type": "ListItem", "position": 35, "name": "Binomial Distribution Calculator",            "url": "<%= baseUrl %>/binomial-distribution-calculator.jsp"},
      {"@type": "ListItem", "position": 36, "name": "Probability Calculator",                      "url": "<%= baseUrl %>/probability-calculator.jsp"},
      {"@type": "ListItem", "position": 37, "name": "Confidence Interval Calculator",              "url": "<%= baseUrl %>/confidence-interval-calculator.jsp"},
      {"@type": "ListItem", "position": 38, "name": "Hypothesis Test Calculator",                  "url": "<%= baseUrl %>/hypothesis-test-calculator.jsp"},
      {"@type": "ListItem", "position": 39, "name": "T-Test Calculator",                           "url": "<%= baseUrl %>/t-test-calculator.jsp"},
      {"@type": "ListItem", "position": 40, "name": "Chi-Square Calculator",                       "url": "<%= baseUrl %>/chi-square-calculator.jsp"},
      {"@type": "ListItem", "position": 41, "name": "ANOVA Calculator",                            "url": "<%= baseUrl %>/anova-calculator.jsp"},
      {"@type": "ListItem", "position": 42, "name": "Correlation Calculator",                      "url": "<%= baseUrl %>/correlation-calculator.jsp"},
      {"@type": "ListItem", "position": 43, "name": "Linear Regression Calculator",                "url": "<%= baseUrl %>/linear-regression-calculator.jsp"},
      {"@type": "ListItem", "position": 44, "name": "Sample Size Calculator",                      "url": "<%= baseUrl %>/sample-size-calculator.jsp"},
      {"@type": "ListItem", "position": 45, "name": "Effect Size Calculator",                      "url": "<%= baseUrl %>/effect-size-calculator.jsp"},
      {"@type": "ListItem", "position": 46, "name": "Standard Error Calculator",                   "url": "<%= baseUrl %>/standard-error-calculator.jsp"},
      {"@type": "ListItem", "position": 47, "name": "Outlier Detection Calculator",                "url": "<%= baseUrl %>/outlier-detection-calculator.jsp"},
      {"@type": "ListItem", "position": 48, "name": "P-Value Calculator",                          "url": "<%= baseUrl %>/p-value-calculator.jsp"},
      {"@type": "ListItem", "position": 49, "name": "Graphing Calculator",                         "url": "<%= baseUrl %>/graphing-calculator.jsp"}
    ]
  }
}
</script>

<!-- JSON-LD: Course schema — pedagogical cluster signal -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Course",
  "name": "Math Tools and Step-by-Step Solvers",
  "description": "Curriculum-aligned online math calculators covering algebra, calculus, linear algebra, trigonometry, statistics, and discrete math, with worked solutions and printable practice worksheets.",
  "url": "<%= baseUrl %>/math/",
  "provider": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "<%= baseUrl %>"
  },
  "educationalCredentialAwarded": "Self-directed practice",
  "hasCourseInstance": [
    { "@type": "CourseInstance", "courseMode": "Online", "name": "Algebra & Pre-Calculus",
      "courseWorkload": "Self-paced",
      "description": "Quadratic, polynomial, system, inequality, exponent, logarithm calculators with steps and worksheets." },
    { "@type": "CourseInstance", "courseMode": "Online", "name": "Calculus",
      "courseWorkload": "Self-paced",
      "description": "Derivative, integral, limit, series calculators with rule-by-rule traces." },
    { "@type": "CourseInstance", "courseMode": "Online", "name": "Linear Algebra",
      "courseWorkload": "Self-paced",
      "description": "Matrix calculators (determinant, inverse, eigenvalue, rank, multiplication) and vector tools." },
    { "@type": "CourseInstance", "courseMode": "Online", "name": "Trigonometry",
      "courseWorkload": "Self-paced",
      "description": "Trig function, identity, and equation solvers with named-rule step traces." },
    { "@type": "CourseInstance", "courseMode": "Online", "name": "Statistics & Probability",
      "courseWorkload": "Self-paced",
      "description": "21 calculators for descriptive stats, hypothesis tests, distributions, and regression." }
  ],
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock"
  }
}
</script>

<!-- JSON-LD: BreadcrumbList for the math index page (top-level signal) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Home", "item": "<%= baseUrl %>" },
    { "@type": "ListItem", "position": 2, "name": "Math",  "item": "<%= baseUrl %>/math/" }
  ]
}
</script>

<!-- JSON-LD: FAQPage — math-index specific (these mirror the visible
     FAQ on math/index.jsp so the schema and page content stay in sync). -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Are these math calculators free?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, all 49 math calculators are completely free with no registration required. Every tool shows step-by-step solutions with KaTeX-rendered formulas and includes a Python compiler for verification."
      }
    },
    {
      "@type": "Question",
      "name": "Do the calculators show step-by-step solutions?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Every calculator renders detailed step-by-step solutions using KaTeX math notation. Each step explains the rule applied and shows the intermediate calculation, so you learn the method, not just the answer."
      }
    },
    {
      "@type": "Question",
      "name": "What math topics are covered?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Everyday math (percentages, significant figures), algebra (quadratic equations, linear systems, inequalities, polynomials), 21 statistics calculators (descriptive stats, hypothesis testing, regression, ANOVA), calculus (derivatives, integrals, limits, series), linear algebra (9 matrix calculators), trigonometry, logarithms, exponents, and Taylor series."
      }
    },
    {
      "@type": "Question",
      "name": "Do these calculators use a Computer Algebra System?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Most calculators delegate to a server-side CAS engine for symbolic manipulation: it applies named log/trig identities, factors polynomials, evaluates limits via L'Hopital, and verifies every worksheet problem. Results are shown alongside step-by-step rule traces."
      }
    },
    {
      "@type": "Question",
      "name": "Is there a practice worksheet for these calculators?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Tools with a worksheet button (logarithm, integral, derivative, quadratic, polynomial, system of equations, and more) open a bank of 1,000-2,000+ CAS-verified practice problems with full answer keys, organised by topic and difficulty (basic, medium, hard, scholar). Perfect for AP, college, or self-study exam prep."
      }
    },
    {
      "@type": "Question",
      "name": "Can I scan a math problem from a photo?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Tools with a Scan button (logarithm, polynomial, quadratic, inequality, system of equations, integral, limit, derivative) accept a photo of a handwritten or printed problem. The AI vision model extracts the expression, fills the math field automatically, and detects the operation. Works on phone snapshots, textbook pages, and whiteboard photos."
      }
    },
    {
      "@type": "Question",
      "name": "Can I share or export results from these math calculators?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Most calculators support copy-to-clipboard (plain text or LaTeX), a shareable URL that reproduces your inputs, and PDF download where applicable. You can embed formulas directly into papers, homework, or lecture slides."
      }
    },
    {
      "@type": "Question",
      "name": "Do these math calculators work on mobile?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes. Every calculator is mobile-responsive — the input UI adapts to narrow viewports and the step-by-step solutions remain fully readable on phones and tablets. The left sidebar collapses into a slide-in drawer on screens below 1024px."
      }
    }
  ]
}
</script>

<%-- End math section. ────────────────────────────────────────────── --%>

<% } else { %>
<%-- ─── Default homepage schemas (section="home") ───────────────────
     IMPORTANT: webapp/index.jsp includes this partial via the STATIC
     directive `<%@ include file="..." %>`, which inlines the content
     into the parent's _jspService at translation time.  An early
     `<% return; %>` in a static-included file returns from the PARENT's
     service method and halts the whole page render.  We use a proper
     if/else wrap instead so neither branch's `return` can leak. --%>

<!-- JSON-LD: WebSite Schema with SearchAction -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "8gwifi.org - Free Online Tools",
  "alternateName": "8gwifi.org",
  "url": "<%= baseUrl %>",
  "description": "Comprehensive suite of 200+ free online tools for professionals, students, and developers: Cryptography, Network diagnostics, DevOps, Mathematics, Finance, Chemistry, Data Converters, PKI, Blockchain, and more. All tools are client-side, secure, and require no registration.",
  "logo": {
    "@type": "ImageObject",
    "url": "<%= baseUrl %>/images/site/logo.png",
    "width": 512,
    "height": 512
  },
  "image": "<%= baseUrl %>/images/site/logo.png",
  "sameAs": [
    "https://twitter.com/anish2good"
  ],
  "potentialAction": {
    "@type": "SearchAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "<%= baseUrl %>/index.jsp?q={search_term_string}"
    },
    "query-input": "required name=search_term_string"
  },
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "logo": {
      "@type": "ImageObject",
      "url": "<%= baseUrl %>/images/site/logo.png"
    }
  }
}
</script>

<!-- JSON-LD: ItemList Schema for Tool Categories -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "ItemList",
  "name": "Free Online Tools Categories",
  "description": "List of tool categories available on 8gwifi.org",
  "numberOfItems": 16,
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Security & PKI Tools",
      "description": "SSL/TLS scanners, certificate management, JWT/JWS tools, keystores, and comprehensive security utilities",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "PGP Tools",
      "description": "PGP encryption, decryption, key generation, signing, verification, and comprehensive PGP utilities",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "DevOps & Container Tools",
      "description": "Kubernetes, Docker, Ansible generators and infrastructure automation",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 4,
      "name": "Cryptography Tools",
      "description": "Encryption, decryption, hashing, and digital signature tools",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 5,
      "name": "Network Tools",
      "description": "DNS lookup, port scanner, subnet calculator, and network diagnostics",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 6,
      "name": "Secure File Sharing",
      "description": "Encrypted file transfer, secure pastebin, and temporary email",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 7,
      "name": "Blockchain Tools",
      "description": "Ethereum keys, HD wallets, and blockchain development tools",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 8,
      "name": "Encoders & Converters",
      "description": "Base64, JSON, YAML, XML, CSV converters and encoders",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 9,
      "name": "Finance Calculators",
      "description": "EMI calculator, compound interest, stock profit calculator",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 10,
      "name": "Utility Tools",
      "description": "PDF tools, QR code generator, hex editor, text comparison",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "ListItem",
      "position": 11,
      "name": "Mathematics & Education Tools",
      "description": "49 math calculators with step-by-step solutions: algebra, calculus, linear algebra, statistics, trigonometry, logarithms, plus practice worksheets and AI photo scan",
      "url": "<%= baseUrl %>/math/"
    },
    {
      "@type": "ListItem",
      "position": 12,
      "name": "Electronics & Simulation Tools",
      "description": "Circuit simulator with AI generation, Arduino & ESP32 emulator with virtual hardware, and a full digital logic simulator with truth tables, K-maps, and TTL ICs",
      "url": "<%= baseUrl %>/electronics/"
    },
    {
      "@type": "ListItem",
      "position": 13,
      "name": "Video & Audio AI Tools",
      "description": "Free AI video transcription and translation. Convert any video or audio into accurate text in 90+ languages, export plain text, SRT, or VTT subtitles.",
      "url": "<%= baseUrl %>/video/"
    },
    {
      "@type": "ListItem",
      "position": 14,
      "name": "SEO & Web Audit Tools",
      "description": "Google Lighthouse audits with AI fix suggestions, AI SEO checker for 79+ issues, structured-data validator. Core Web Vitals, accessibility, performance scores.",
      "url": "<%= baseUrl %>/seo/"
    },
    {
      "@type": "ListItem",
      "position": 15,
      "name": "CTF Challenge Generators",
      "description": "Capture-the-Flag challenge generators for crypto, forensics, reverse engineering, RSA, and steganography — instant practice problems with parameterised difficulty.",
      "url": "<%= baseUrl %>/ctf/"
    },
    {
      "@type": "ListItem",
      "position": 16,
      "name": "Online Code Compilers",
      "description": "19 free browser-based compilers and runtimes — Python, Java, C, C++, C#, JavaScript, TypeScript, Go, Rust, Kotlin, Swift, Scala, Ruby, PHP, R, Lua, Dart, Bash, and a generic compiler hub.",
      "url": "<%= baseUrl %>/online-compiler/"
    }
  ]
}
</script>

<!-- JSON-LD: BreadcrumbList Schema for Homepage -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "<%= baseUrl %>"
    }
  ]
}
</script>

<!-- JSON-LD: CollectionPage Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "Free Online Tools",
  "description": "Browse free online tools for professionals, students, and developers organized by category",
  "url": "<%= baseUrl %>",
  "mainEntity": {
    "@type": "ItemList",
    "name": "Top Tools and Pages",
    "description": "Top performing pages on 8gwifi.org",
    "numberOfItems": 70,
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "PGP Encrypt/Decrypt",
        "url": "<%= baseUrl %>/pgpencdec.jsp"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "SSH Functions",
        "url": "<%= baseUrl %>/sshfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 3,
        "name": "TikZ Viewer",
        "url": "<%= baseUrl %>/tikz-viewer.jsp"
      },
      {
        "@type": "ListItem",
        "position": 4,
        "name": "PEM Parser Functions",
        "url": "<%= baseUrl %>/PemParserFunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 5,
        "name": "RSA Sign Verify Functions",
        "url": "<%= baseUrl %>/rsasignverifyfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 6,
        "name": "JWK Convert Functions",
        "url": "<%= baseUrl %>/jwkconvertfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 7,
        "name": "Fernet",
        "url": "<%= baseUrl %>/fernet.jsp"
      },
      {
        "@type": "ListItem",
        "position": 8,
        "name": "RSA Functions",
        "url": "<%= baseUrl %>/rsafunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 9,
        "name": "Cipher Functions",
        "url": "<%= baseUrl %>/CipherFunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 10,
        "name": "JWS Generator",
        "url": "<%= baseUrl %>/jwsgen.jsp"
      },
      {
        "@type": "ListItem",
        "position": 11,
        "name": "PGP File Verify",
        "url": "<%= baseUrl %>/pgpfileverify.jsp"
      },
      {
        "@type": "ListItem",
        "position": 12,
        "name": "PGP File Decrypt",
        "url": "<%= baseUrl %>/pgp-file-decrypt.jsp"
      },
      {
        "@type": "ListItem",
        "position": 13,
        "name": "Lewis Structure Generator",
        "url": "<%= baseUrl %>/lewis-structure-generator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 14,
        "name": "EC Sign Verify",
        "url": "<%= baseUrl %>/ecsignverify.jsp"
      },
      {
        "@type": "ListItem",
        "position": 15,
        "name": "PBKDF",
        "url": "<%= baseUrl %>/pbkdf.jsp"
      },
      {
        "@type": "ListItem",
        "position": 16,
        "name": "JKS Functions",
        "url": "<%= baseUrl %>/jks.jsp"
      },
      {
        "@type": "ListItem",
        "position": 17,
        "name": "JWS Parser",
        "url": "<%= baseUrl %>/jwsparse.jsp"
      },
      {
        "@type": "ListItem",
        "position": 18,
        "name": "Base64 Hex",
        "url": "<%= baseUrl %>/base64Hex.jsp"
      },
      {
        "@type": "ListItem",
        "position": 19,
        "name": "EC Functions",
        "url": "<%= baseUrl %>/ecfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 20,
        "name": "PGP Key Functions",
        "url": "<%= baseUrl %>/pgpkeyfunction.jsp"
      },
      {
        "@type": "ListItem",
        "position": 21,
        "name": "PEM Convert",
        "url": "<%= baseUrl %>/pemconvert.jsp"
      },
      {
        "@type": "ListItem",
        "position": 22,
        "name": "PGP Suite",
        "url": "<%= baseUrl %>/pgp-suite.jsp"
      },
      {
        "@type": "ListItem",
        "position": 23,
        "name": "Homepage",
        "url": "<%= baseUrl %>/index.jsp"
      },
      {
        "@type": "ListItem",
        "position": 24,
        "name": "Certificates Tools",
        "url": "<%= baseUrl %>/certs.jsp"
      },
      {
        "@type": "ListItem",
        "position": 25,
        "name": "PEM Public Key",
        "url": "<%= baseUrl %>/pempublic.jsp"
      },
      {
        "@type": "ListItem",
        "position": 26,
        "name": "Steganography Tool",
        "url": "<%= baseUrl %>/steganography-tool.jsp"
      },
      {
        "@type": "ListItem",
        "position": 27,
        "name": "Neural Network Playground",
        "url": "<%= baseUrl %>/neural_network_playground.jsp"
      },
      {
        "@type": "ListItem",
        "position": 28,
        "name": "JWS Verify",
        "url": "<%= baseUrl %>/jwsverify.jsp"
      },
      {
        "@type": "ListItem",
        "position": 29,
        "name": "PBE",
        "url": "<%= baseUrl %>/pbe.jsp"
      },
      {
        "@type": "ListItem",
        "position": 30,
        "name": "Projectile Motion Simulator",
        "url": "<%= baseUrl %>/projectile-motion-simulator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 31,
        "name": "htpasswd Generator",
        "url": "<%= baseUrl %>/htpasswd.jsp"
      },
      {
        "@type": "ListItem",
        "position": 32,
        "name": "Hexdump",
        "url": "<%= baseUrl %>/hexdump.jsp"
      },
      {
        "@type": "ListItem",
        "position": 33,
        "name": "LaTeX Equation Editor",
        "url": "<%= baseUrl %>/latex-equation-editor.jsp"
      },
      {
        "@type": "ListItem",
        "position": 34,
        "name": "PGP Dump",
        "url": "<%= baseUrl %>/pgpdump.jsp"
      },
      {
        "@type": "ListItem",
        "position": 35,
        "name": "Python Intro Tutorial",
        "url": "<%= baseUrl %>/tutorials/python/intro.jsp"
      },
      {
        "@type": "ListItem",
        "position": 36,
        "name": "Argon2",
        "url": "<%= baseUrl %>/argon2.jsp"
      },
      {
        "@type": "ListItem",
        "position": 37,
        "name": "cURL Functions",
        "url": "<%= baseUrl %>/curlfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 38,
        "name": "JWK Functions",
        "url": "<%= baseUrl %>/jwkfunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 39,
        "name": "Password Generator",
        "url": "<%= baseUrl %>/passwdgen.jsp"
      },
      {
        "@type": "ListItem",
        "position": 40,
        "name": "BIP39 Mnemonic",
        "url": "<%= baseUrl %>/bip39-mnemonic.jsp"
      },
      {
        "@type": "ListItem",
        "position": 41,
        "name": "Self Signed Certificate Functions",
        "url": "<%= baseUrl %>/SelfSignCertificateFunctions.jsp"
      },
      {
        "@type": "ListItem",
        "position": 42,
        "name": "Gradient Descent Visualizer",
        "url": "<%= baseUrl %>/gradient_descent_visualizer.jsp"
      },
      {
        "@type": "ListItem",
        "position": 43,
        "name": "ISBN Validator",
        "url": "<%= baseUrl %>/isbn-validator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 44,
        "name": "Programming Tutorials",
        "url": "<%= baseUrl %>/tutorials/index.jsp"
      },
      {
        "@type": "ListItem",
        "position": 45,
        "name": "Exams and Practice",
        "url": "<%= baseUrl %>/exams/"
      },
      {
        "@type": "ListItem",
        "position": 46,
        "name": "Math Calculators Index",
        "url": "<%= baseUrl %>/math/"
      },
      {
        "@type": "ListItem",
        "position": 47,
        "name": "Logarithm Calculator",
        "url": "<%= baseUrl %>/logarithm-calculator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 48,
        "name": "Quadratic Equation Solver",
        "url": "<%= baseUrl %>/quadratic-solver.jsp"
      },
      {
        "@type": "ListItem",
        "position": 49,
        "name": "Polynomial Calculator",
        "url": "<%= baseUrl %>/polynomial-calculator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 50,
        "name": "System of Equations Solver",
        "url": "<%= baseUrl %>/system-equations-solver.jsp"
      },
      {
        "@type": "ListItem",
        "position": 51,
        "name": "Integral Calculator",
        "url": "<%= baseUrl %>/integral-calculator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 52,
        "name": "Derivative Calculator",
        "url": "<%= baseUrl %>/derivative-calculator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 53,
        "name": "Percentage Calculator",
        "url": "<%= baseUrl %>/percentage-calculator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 54,
        "name": "Circuit Simulator with AI",
        "url": "<%= baseUrl %>/physics/labs/circuit-simulator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 55,
        "name": "Arduino & ESP32 Simulator",
        "url": "<%= baseUrl %>/electronics/arduino-simulator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 56,
        "name": "Logic Gate Simulator",
        "url": "<%= baseUrl %>/electronics/logic-simulator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 57,
        "name": "AI Video Transcription",
        "url": "<%= baseUrl %>/video/"
      },
      {
        "@type": "ListItem",
        "position": 58,
        "name": "Lighthouse Audit",
        "url": "<%= baseUrl %>/seo/lighthouse.jsp"
      },
      {
        "@type": "ListItem",
        "position": 59,
        "name": "AI SEO Checker",
        "url": "<%= baseUrl %>/seo/seo-checker.jsp"
      },
      {
        "@type": "ListItem",
        "position": 60,
        "name": "Structured Data Test",
        "url": "<%= baseUrl %>/seo/structured-data.jsp"
      },
      {
        "@type": "ListItem",
        "position": 61,
        "name": "CTF Challenge Generators",
        "url": "<%= baseUrl %>/ctf/"
      },
      {
        "@type": "ListItem",
        "position": 62,
        "name": "RSA CTF Generator",
        "url": "<%= baseUrl %>/ctf/rsa-ctf-generator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 63,
        "name": "Crypto CTF Generator",
        "url": "<%= baseUrl %>/ctf/crypto-ctf-generator.jsp"
      },
      {
        "@type": "ListItem",
        "position": 64,
        "name": "Online Compilers Hub",
        "url": "<%= baseUrl %>/online-compiler/"
      },
      {
        "@type": "ListItem",
        "position": 65,
        "name": "Online Python Compiler",
        "url": "<%= baseUrl %>/online-python-compiler/"
      },
      {
        "@type": "ListItem",
        "position": 66,
        "name": "Online Java Compiler",
        "url": "<%= baseUrl %>/online-java-compiler/"
      },
      {
        "@type": "ListItem",
        "position": 67,
        "name": "Online C++ Compiler",
        "url": "<%= baseUrl %>/online-cpp-compiler/"
      },
      {
        "@type": "ListItem",
        "position": 68,
        "name": "Online JavaScript Compiler",
        "url": "<%= baseUrl %>/online-javascript-compiler/"
      },
      {
        "@type": "ListItem",
        "position": 69,
        "name": "Online Go Compiler",
        "url": "<%= baseUrl %>/online-go-compiler/"
      },
      {
        "@type": "ListItem",
        "position": 70,
        "name": "Online Rust Compiler",
        "url": "<%= baseUrl %>/online-rust-compiler/"
      }
    ]
  },
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "<%= baseUrl %>"
      }
    ]
  }
}
</script>

<!-- JSON-LD: Organization Schema (Enhanced) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "8gwifi.org",
  "url": "<%= baseUrl %>",
  "logo": {
    "@type": "ImageObject",
    "url": "<%= baseUrl %>/images/site/logo.png",
    "width": 512,
    "height": 512
  },
  "description": "Provider of free online developer tools and utilities",
  "foundingDate": "2020",
  "sameAs": [
    "https://twitter.com/anish2good"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "Customer Service",
    "url": "<%= baseUrl %>",
    "availableLanguage": "English"
  },
  "knowsAbout": [
    "Cryptography",
    "Network Tools",
    "DevOps",
    "Web Development",
    "Security Tools",
    "Data Encoding",
    "Certificate Management",
    "Mathematics",
    "Statistics",
    "Calculus",
    "Linear Algebra",
    "Algebra",
    "Trigonometry",
    "Probability",
    "Electronics",
    "Circuit Design",
    "Digital Logic",
    "Arduino",
    "Microcontrollers",
    "Speech Recognition",
    "AI Transcription",
    "Video Processing",
    "Search Engine Optimization",
    "Web Performance",
    "Core Web Vitals",
    "Web Accessibility",
    "Capture the Flag (CTF)",
    "Reverse Engineering",
    "Steganography",
    "Digital Forensics",
    "Online Code Execution",
    "Programming Languages",
    "Python",
    "Java",
    "C++",
    "JavaScript",
    "Go",
    "Rust"
  ]
}
</script>

<!-- JSON-LD: SiteNavigationElement — top-level section signals so Google
     can render site-link cards under the homepage result for /math/,
     /tutorials/, and /exams/.  `sameAs` is for cross-site identity
     (Twitter etc.) — internal section URLs belong in a navigation
     schema, not sameAs. -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "SiteNavigationElement",
      "name": "Math Calculators",
      "description": "49 step-by-step math calculators (algebra, calculus, linear algebra, statistics, trigonometry) with CAS-verified worksheets",
      "url": "<%= baseUrl %>/math/"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "Programming Tutorials",
      "description": "Tutorials covering Python, Java, networking, cryptography, and more",
      "url": "<%= baseUrl %>/tutorials/"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "Exams and Practice",
      "description": "Practice exams and study materials across multiple subjects",
      "url": "<%= baseUrl %>/exams/"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "Crypto & PKI Tools",
      "description": "Encryption, hashing, certificate, JWT/JWS, and PGP utilities",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "DevOps Tools",
      "description": "Kubernetes, Docker, Ansible generators and infrastructure utilities",
      "url": "<%= baseUrl %>/#tools"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "Electronics & Simulation",
      "description": "Circuit simulator, Arduino & ESP32 emulator, and digital logic simulator with truth tables and K-maps",
      "url": "<%= baseUrl %>/electronics/"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "Video & Audio AI",
      "description": "AI video transcription and translation in 90+ languages, SRT/VTT export",
      "url": "<%= baseUrl %>/video/"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "SEO & Web Audits",
      "description": "Lighthouse audits, AI SEO checker, structured-data validator with Core Web Vitals scoring",
      "url": "<%= baseUrl %>/seo/"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "CTF Challenge Generators",
      "description": "Capture-the-Flag generators for crypto, forensics, reverse engineering, RSA, and steganography practice",
      "url": "<%= baseUrl %>/ctf/"
    },
    {
      "@type": "SiteNavigationElement",
      "name": "Online Code Compilers",
      "description": "19 free browser-based compilers and runtimes — Python, Java, C, C++, JavaScript, TypeScript, Go, Rust, Kotlin, Swift, and more",
      "url": "<%= baseUrl %>/online-compiler/"
    }
  ]
}
</script>

<!-- JSON-LD: FAQPage Schema for Common Questions -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Are all tools on 8gwifi.org free to use?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, all 200+ tools on 8gwifi.org are completely free to use. No registration, no credit card, no limitations."
      }
    },
    {
      "@type": "Question",
      "name": "Is my data secure when using these tools?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, all processing happens client-side in your browser. Your data never leaves your device, ensuring complete privacy and security."
      }
    },
    {
      "@type": "Question",
      "name": "Do I need to register to use the tools?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "No registration required. All tools work immediately without any sign-up process. Just open the tool and start using it."
      }
    },
    {
      "@type": "Question",
      "name": "What types of tools are available?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "We offer tools for Cryptography (encryption, hashing), Network diagnostics (DNS, port scanning), DevOps (Kubernetes, Docker), Encoders (Base64, JSON, YAML), PKI/Certificates, Blockchain, File sharing, and Finance calculators."
      }
    },
    {
      "@type": "Question",
      "name": "Can I use these tools offline?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Most tools work offline once the page is loaded, as all processing happens client-side in your browser using JavaScript."
      }
    },
    {
      "@type": "Question",
      "name": "Are the tools suitable for commercial use?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, all tools can be used for commercial purposes. They are provided free of charge with no restrictions on usage."
      }
    }
  ]
}
</script>

<!-- JSON-LD: Service Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Service",
  "serviceType": "Web-based Developer Tools",
  "provider": {
    "@type": "Organization",
    "name": "8gwifi.org"
  },
  "areaServed": "Worldwide",
  "availableChannel": {
    "@type": "ServiceChannel",
    "serviceUrl": "<%= baseUrl %>",
    "serviceType": "Online"
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "url": "<%= baseUrl %>"
  }
}
</script>
<% } /* end if/else for section */ %>

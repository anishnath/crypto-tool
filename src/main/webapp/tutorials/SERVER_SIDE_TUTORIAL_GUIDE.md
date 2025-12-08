# Server-Side Language Tutorial Guide

Complete guide for creating Python, Java, Go, Rust, and other server-side language tutorials on 8gwifi.org.

---

## Table of Contents

1. [UX Architecture](#1-ux-architecture)
2. [Page Structure](#2-page-structure)
3. [Components](#3-components)
4. [SEO Strategy](#4-seo-strategy)
5. [Analytics Integration](#5-analytics-integration)
6. [Ads Integration](#6-ads-integration)
7. [Best Practices](#7-best-practices)
   - 7.4 [Complete Lesson Template](#74-complete-lesson-template)
   - 7.5 [Content Structure Checklist](#75-content-structure-checklist)
   - 7.6 [Callout Box Quick Reference](#76-callout-box-quick-reference)
   - 7.7 [Lesson Quality Audit Checklist](#77-lesson-quality-audit-checklist)
8. [Special Content Elements](#8-special-content-elements)
   - 8.1 [Callouts & Asides](#81-callouts--asides)
   - 8.2 [Exercises & Challenges](#82-exercises--challenges)
   - 8.3 [Definitions & Key Terms](#83-definitions--key-terms)
   - 8.4 [Progress Indicators](#84-progress-indicators)
   - 8.5 [Color Palette](#85-color-palette)
   - 8.6 [Syntax Highlighting](#86-syntax-highlighting-monokai-theme)
   - 8.7 [Fonts CSS](#87-fonts-css)
   - 8.8 [Typography](#88-typography)
   - 8.9 [Info Tables](#89-info-tables)
9. [Course Content Guide](#9-course-content-guide)
10. [Python Curriculum](#10-python-curriculum)
11. [Java Curriculum](#11-java-curriculum)
12. [Go Curriculum](#12-go-curriculum)
13. [Exercise Guidelines](#13-exercise-guidelines)

---

## 1. UX Architecture

### Layout Comparison

| Tutorial Type | Layout | Right Panel |
|---------------|--------|-------------|
| **HTML/CSS/JS** | 3-panel | Live Preview (iframe) |
| **Python/Java/Go** | 2-panel | None (inline output) |

### Server-Side Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│                        HEADER                                │
├─────────┬───────────────────────────────────────────────────┤
│         │  BREADCRUMB: Tutorials / Python / Variables        │
│         │                                                    │
│         │  LESSON TITLE                                      │
│         │  Beginner | ~10 min read                           │
│         │                                                    │
│ SIDEBAR │  ┌──────────────────────────────────────────────┐ │
│  (nav)  │  │  [AD SLOT - TOP]                             │ │
│         │  └──────────────────────────────────────────────┘ │
│         │                                                    │
│         │  <Lesson Content>                                  │
│         │                                                    │
│         │  ┌──────────────────────────────────────────────┐ │
│         │  │ main.py                        [Reset] [Run] │ │
│         │  │ ──────────────────────────────────────────── │ │
│         │  │ 1 │ x = 10                                   │ │
│         │  │ 2 │ print(x * 2)                             │ │
│         │  │ 3 │                                          │ │
│         │  ├──────────────────────────────────────────────┤ │
│         │  │ OUTPUT                    Success   0.02s    │ │
│         │  │ 20                              [Copy][Clear]│ │
│         │  └──────────────────────────────────────────────┘ │
│         │                                                    │
│         │  ┌──────────────────────────────────────────────┐ │
│         │  │  [AD SLOT - MIDDLE]                          │ │
│         │  └──────────────────────────────────────────────┘ │
│         │                                                    │
│         │  <More Lesson Content>                             │
│         │                                                    │
│         │  ┌──────────────────────────────────────────────┐ │
│         │  │  [QUIZ COMPONENT]                            │ │
│         │  └──────────────────────────────────────────────┘ │
│         │                                                    │
│         │  ┌──────────────────────────────────────────────┐ │
│         │  │  [AD SLOT - BOTTOM]                          │ │
│         │  └──────────────────────────────────────────────┘ │
│         │                                                    │
│         │  [<< Prev: Hello World]  [Next: Control Flow >>]  │
├─────────┴───────────────────────────────────────────────────┤
│                        FOOTER                                │
│  [SIDERAILS - LEFT/RIGHT on wide screens]                   │
│  [ANCHOR AD - sticky bottom]                                │
└─────────────────────────────────────────────────────────────┘
```

### Key UX Principles

1. **No Live Preview Panel** - Server-side languages don't need real-time preview
2. **Full-Width Content** - Content area expands without preview panel (max 900px)
3. **Inline Compiler Blocks** - Code + Output in single self-contained component
4. **Execution Stats** - Show time, CPU, memory usage
5. **Input Support** - Stdin input for programs that need user input
6. **Mobile-First** - Compiler blocks must work well on mobile

### Body Class for No-Preview Layout

Add the `no-preview` class to `<body>` for server-side tutorials:

```jsp
<body class="tutorial-body no-preview" data-lesson="variables">
```

This class:
- Removes the reserved space for preview panel
- Centers content with max-width of 900px
- Provides better reading experience for code-heavy tutorials

### CSS Files

Server-side tutorials use these CSS files:

| CSS File | Purpose |
|----------|---------|
| `tutorial.css` | Base tutorial styles |
| `tutorial-server.css` | Server-side specific overrides (auto-loaded via `.no-preview`) |

The `tutorial-server.css` ensures proper layout when there's no preview panel.

---

## 2. Page Structure

### Required Includes (in `<head>`)

```jsp
<%-- Required CSS --%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

<%-- Theme initialization (before body renders) --%>
<script>
    (function () {
        var theme = localStorage.getItem('tutorial-theme');
        if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            document.documentElement.setAttribute('data-theme', 'dark');
        }
    })();
</script>

<%-- Ads + Analytics --%>
<%@ include file="../tutorial-ads.jsp" %>
<%@ include file="../tutorial-analytics.jsp" %>
```

### Required Includes (in `<body>`)

```jsp
<%-- Header --%>
<%@ include file="../tutorial-header.jsp" %>

<%-- Sidebar (language-specific) --%>
<%@ include file="../tutorial-sidebar-python.jsp" %>
<%-- OR: tutorial-sidebar-java.jsp, tutorial-sidebar-go.jsp, etc. --%>

<%-- Footer (includes siderails + anchor ads) --%>
<%@ include file="../tutorial-footer.jsp" %>
```

### Required Scripts (before `</body>`)

```jsp
<script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
<script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
<%-- Add appropriate mode for your language --%>
<script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
<script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
```

---

## 3. Components

### 3.1 Language Logos

Each tutorial sidebar includes a language logo in the header. Logos are stored in `/tutorials/assets/images/`:

| Language | Logo File | Size |
|----------|-----------|------|
| HTML | `html-logo.svg` | 32x32 |
| CSS | `css-logo.svg` | 32x32 |
| JavaScript | `javascript-logo.svg` | 32x32 |
| Python | `python-logo.svg` | 32x32 |
| Java | `java-logo.svg` | 32x32 |
| Go | `go-logo.svg` | 32x32 |

Sidebar header structure with logo:

```jsp
<div class="sidebar-header">
    <div class="sidebar-logo">
        <img src="<%=request.getContextPath()%>/tutorials/assets/images/python-logo.svg"
             alt="Python" width="32" height="32">
    </div>
    <h2 class="sidebar-title">Python Tutorial</h2>
</div>
```

### 3.2 Compiler Component

The `tutorial-compiler.jsp` component is the core interactive element for server-side tutorials.

#### External Code Files (RECOMMENDED)

Store code in external files for easy maintenance:

```jsp
<jsp:include page="../tutorial-compiler.jsp">
    <jsp:param name="codeFile" value="python/variables-basic.py" />
    <jsp:param name="language" value="python" />
    <jsp:param name="editorId" value="compiler-vars" />
</jsp:include>
```

**Benefits of External Files:**
- Edit with proper syntax highlighting in any IDE
- Test code independently before adding to tutorial
- Version control friendly (proper diffs)
- No escaping needed for quotes, newlines, etc.

#### Code File Directory Structure

```
/tutorials/code/
├── python/
│   ├── hello-world.py
│   ├── variables-basic.py
│   ├── variables-types.py
│   ├── loops-for.py
│   └── functions-basic.py
├── java/
│   ├── HelloWorld.java
│   └── Variables.java
└── go/
    ├── hello-world.go
    └── variables.go
```

#### Naming Convention for Code Files

```
{topic}-{subtopic}.{ext}
```

Examples:
- `variables-basic.py` - Basic variable examples
- `variables-types.py` - Data type examples
- `loops-for.py` - For loop examples
- `functions-args.py` - Function arguments

#### Inline Code (Legacy)

For simple one-liners, you can still use inline code:

```jsp
<jsp:include page="../tutorial-compiler.jsp">
    <jsp:param name="initialCode" value="print('Hello, World!')" />
    <jsp:param name="language" value="python" />
    <jsp:param name="editorId" value="compiler-hello" />
</jsp:include>
```

**Note:** Use `\n` for newlines in inline code: `value="x = 10\nprint(x)"`

#### Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `codeFile` | No* | - | Path to external code file (relative to `/tutorials/code/`) |
| `initialCode` | No* | `print('Hello')` | Inline code (use `codeFile` instead for multiline) |
| `language` | Yes | `python` | Language: python, java, go, cpp, c, ruby, rust, kotlin, etc. |
| `editorId` | Yes | `compiler1` | Unique ID (must be unique per page) |
| `filename` | No | Auto-detect | Display filename (e.g., `main.py`) |
| `showStats` | No | `true` | Show execution time/memory stats |
| `collapsible` | No | `false` | Make output collapsible |

*Either `codeFile` or `initialCode` must be provided. `codeFile` takes precedence.

#### Supported Languages

| Language | Value | Default Filename |
|----------|-------|------------------|
| Python | `python` | main.py |
| Java | `java` | Main.java |
| Go | `go` | main.go |
| C++ | `cpp` | main.cpp |
| C | `c` | main.c |
| Ruby | `ruby` | main.rb |
| Rust | `rust` | main.rs |
| JavaScript (Node) | `nodejs` | index.js |
| TypeScript | `typescript` | index.ts |
| PHP | `php` | index.php |
| Kotlin | `kotlin` | Main.kt |
| Swift | `swift` | main.swift |
| Scala | `scala` | Main.scala |

#### Features

- **Line Numbers** - Automatic line numbering
- **Tab Support** - Tab key inserts 4 spaces
- **Syntax Highlighting** - Via CodeMirror modes
- **Input Tab** - For stdin input
- **Copy Output** - One-click copy
- **Execution Stats** - Time, CPU, memory
- **Error Highlighting** - Red output for errors
- **Reset Button** - Restore initial code

### 3.3 Ad Slot Component

```jsp
<jsp:include page="../tutorial-ad-slot.jsp">
    <jsp:param name="slot" value="top" />
    <jsp:param name="responsive" value="true" />
</jsp:include>
```

#### Ad Slot Positions

| Slot | Placement | Description |
|------|-----------|-------------|
| `top` | After lesson header | Before main content |
| `middle` | Between sections | After first major section |
| `bottom` | Before navigation | After quiz/before prev-next |

### 3.4 Quiz Component

```jsp
<jsp:include page="../tutorial-quiz.jsp">
    <jsp:param name="quizId" value="quiz-variables" />
    <jsp:param name="question" value="What is the output of print(type(10))?" />
    <jsp:param name="option1" value="int" />
    <jsp:param name="option2" value="<class 'int'>" />
    <jsp:param name="option3" value="number" />
    <jsp:param name="option4" value="integer" />
    <jsp:param name="correctAnswer" value="1" />
</jsp:include>
```

### 3.5 Navigation Component

```jsp
<jsp:include page="../tutorial-nav.jsp">
    <jsp:param name="prevLink" value="intro.jsp" />
    <jsp:param name="prevTitle" value="Hello World" />
    <jsp:param name="nextLink" value="control-flow.jsp" />
    <jsp:param name="nextTitle" value="Control Flow" />
    <jsp:param name="currentLessonId" value="variables" />
</jsp:include>
```

---

## 4. SEO Strategy

### 4.1 Page Title Format

```
{Topic} - {Language} Tutorial | 8gwifi.org
```

Examples:
- `Variables & Data Types - Python Tutorial | 8gwifi.org`
- `Control Flow - Java Tutorial | 8gwifi.org`
- `Goroutines - Go Tutorial | 8gwifi.org`

### 4.2 Meta Description

```jsp
<meta name="description" content="Learn about {topic} in {language}. {Brief description with keywords}. Interactive examples with live code execution.">
```

Example:
```jsp
<meta name="description" content="Learn about Python variables, data types (strings, integers, floats, booleans), and dynamic typing. Interactive examples with live code execution.">
```

### 4.3 Schema.org Structured Data

Every lesson page MUST include LearningResource schema:

```jsp
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Python Variables and Data Types",
    "description": "Learn about variables and data types in Python with interactive examples.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "teaches": ["Python variables", "Python data types", "Dynamic typing"],
    "timeRequired": "PT10M",
    "isPartOf": {
        "@type": "Course",
        "name": "Python Tutorial",
        "description": "Complete Python programming course for beginners",
        "url": "https://8gwifi.org/tutorials/python/",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org"
        }
    },
    "author": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
    }
}
</script>
```

### 4.4 Open Graph Tags

```jsp
<meta property="og:type" content="article">
<meta property="og:title" content="Variables & Data Types - Python Tutorial">
<meta property="og:description" content="Learn about Python variables and data types with interactive examples.">
<meta property="og:site_name" content="8gwifi.org Tutorials">
<meta property="og:url" content="https://8gwifi.org/tutorials/python/variables.jsp">
<meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-og.png">
```

### 4.5 Canonical URL

```jsp
<link rel="canonical" href="https://8gwifi.org/tutorials/python/variables.jsp">
```

### 4.6 Breadcrumb Schema

```jsp
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        {
            "@type": "ListItem",
            "position": 1,
            "name": "Tutorials",
            "item": "https://8gwifi.org/tutorials/"
        },
        {
            "@type": "ListItem",
            "position": 2,
            "name": "Python",
            "item": "https://8gwifi.org/tutorials/python/"
        },
        {
            "@type": "ListItem",
            "position": 3,
            "name": "Variables & Data Types"
        }
    ]
}
</script>
```

### 4.7 SEO Checklist

- [ ] Unique, descriptive `<title>` (50-60 chars)
- [ ] Meta description (150-160 chars)
- [ ] H1 tag matches topic
- [ ] Proper heading hierarchy (H1 > H2 > H3)
- [ ] Internal links to related lessons
- [ ] External links open in new tab with `rel="noopener"`
- [ ] Alt text for any images
- [ ] LearningResource schema
- [ ] BreadcrumbList schema
- [ ] Open Graph tags
- [ ] Canonical URL

---

## 5. Analytics Integration

### 5.1 Google Analytics 4 (GA4)

Analytics is included via `tutorial-analytics.jsp`. Currently disabled (commented out).

To enable, uncomment the code in `/tutorials/tutorial-analytics.jsp`:

```jsp
<!-- Google Analytics 4 (GA4) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-FQ2QT10GDP"></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-FQ2QT10GDP');
</script>
```

### 5.2 Custom Events to Track

#### Lesson View Event
```javascript
gtag('event', 'lesson_view', {
    'lesson_name': 'variables',
    'module_name': 'Introduction',
    'language': 'python',
    'content_type': 'tutorial'
});
```

#### Code Execution Event
```javascript
gtag('event', 'code_execute', {
    'language': 'python',
    'lesson_name': 'variables',
    'success': true,
    'execution_time': 0.02
});
```

#### Lesson Complete Event
```javascript
gtag('event', 'lesson_complete', {
    'lesson_name': 'variables',
    'language': 'python',
    'time_spent': 300 // seconds
});
```

#### Quiz Answer Event
```javascript
gtag('event', 'quiz_answer', {
    'quiz_id': 'quiz-variables',
    'correct': true,
    'attempt': 1
});
```

### 5.3 Key Metrics to Monitor

| Metric | Description | Goal |
|--------|-------------|------|
| Lesson Views | Page views per lesson | Track popular content |
| Code Executions | How often users run code | Engagement indicator |
| Completion Rate | Users who reach lesson end | Content quality |
| Quiz Success | Correct quiz answers | Learning effectiveness |
| Time on Page | Average session duration | Engagement depth |
| Bounce Rate | Single page sessions | Content relevance |

---

## 6. Ads Integration

### 6.1 Ad Files Structure

```
/tutorials/
├── tutorial-ads.jsp          # Head scripts (GPT + SetupAds init)
├── tutorial-ad-slot.jsp      # All ad slots combined
└── ads/
    ├── ad-sidebar.jsp        # Sidebar ad (desktop)
    ├── ad-leaderboard.jsp    # In-content ad (lazy-loaded)
    ├── ad-siderails.jsp      # Fixed siderails (wide screens)
    ├── ad-anchor.jsp         # Sticky bottom ad
    ├── ad-adsense.jsp        # Google AdSense unit
    └── ad-adsense-head.jsp   # AdSense head script
```

### 6.2 Automatic Ad Placements

These ads are automatically included:

| Ad Type | Included Via | Visibility |
|---------|--------------|------------|
| Sidebar | `tutorial-sidebar-*.jsp` | Desktop (>=992px) |
| Siderails | `tutorial-footer.jsp` | Wide screens (>=1490px) |
| Anchor | `tutorial-footer.jsp` | All devices |

### 6.3 Manual Ad Placements

For in-content ads, add explicitly in lesson JSP:

```jsp
<%-- After introduction --%>
<jsp:include page="../tutorial-ad-slot.jsp">
    <jsp:param name="slot" value="top" />
    <jsp:param name="responsive" value="true" />
</jsp:include>

<%-- Between major sections --%>
<jsp:include page="../tutorial-ad-slot.jsp">
    <jsp:param name="slot" value="middle" />
    <jsp:param name="responsive" value="true" />
</jsp:include>

<%-- Before navigation --%>
<jsp:include page="../tutorial-ad-slot.jsp">
    <jsp:param name="slot" value="bottom" />
    <jsp:param name="responsive" value="true" />
</jsp:include>
```

### 6.4 Ad Slot Sizes

| Slot | Desktop | Tablet | Mobile |
|------|---------|--------|--------|
| Sidebar | 336x336 | 250x250 | Hidden |
| Leaderboard | 728x90 | 468x60 | 336x336 |
| Siderails | 160x600 | Hidden | Hidden |
| Anchor | 1000x100 | 728x90 | 320x100 |

### 6.5 SetupAds Configuration

The ad setup uses SetupAds + Google Publisher Tags (GPT). Key settings:

```javascript
// Lazy loading with inView library
inView.offset(-200);

// GPT Configuration
googletag.pubads().disableInitialLoad();  // Wait for SetupAds
googletag.pubads().enableSingleRequest(); // SRA for performance
googletag.pubads().collapseEmptyDivs();   // Hide empty slots
```

### 6.6 Ad Revenue Optimization Tips

1. **Placement**
   - Above the fold: 1 ad maximum
   - In-content: Every 3-4 paragraphs
   - Don't interrupt code examples

2. **Viewability**
   - Use lazy loading for below-fold ads
   - Anchor ads have highest viewability
   - Sidebar ads perform best on desktop

3. **User Experience**
   - No ads inside compiler component
   - No interstitials during code execution
   - Maintain content-to-ad ratio

---

## 7. Best Practices

### 7.1 Content Guidelines

1. **Keep code examples short** - 5-15 lines per example
2. **One concept per compiler** - Don't overload examples
3. **Provide explanation before code** - Context matters
4. **Use realistic examples** - Not just `foo` and `bar`
5. **Include expected output** - In text before the compiler

### 7.2 Technical Guidelines

1. **Unique editor IDs** - Every compiler needs unique `editorId`
2. **Escape special characters** - In `initialCode` parameter
3. **Test all code** - Verify it runs correctly
4. **Mobile testing** - Check compiler on small screens
5. **Dark mode** - Ensure code is readable in both themes

### 7.3 Performance Guidelines

1. **Lazy load ads** - Use `inView` for below-fold ads
2. **Minimize JS** - Don't include unnecessary CodeMirror modes
3. **Optimize images** - If any, use WebP format
4. **Cache static assets** - CSS, JS should have cache headers

### 7.4 Complete Lesson Template

Use this comprehensive template for all new lessons. Every lesson MUST follow this structure:

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "lesson-id");
   request.setAttribute("currentModule", "Module Name"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <!-- 1. META TAGS -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Lesson Title - Python Tutorial | 8gwifi.org</title>
    <meta name="description" content="Detailed 150-160 char description with keywords...">
    <meta name="keywords" content="keyword1, keyword2, keyword3">

    <!-- Open Graph -->
    <meta property="og:type" content="article">
    <meta property="og:title" content="Lesson Title - Python Tutorial | 8gwifi.org">
    <meta property="og:description" content="Short description for social sharing.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <!-- 2. RESOURCES -->
    <link rel="canonical" href="https://8gwifi.org/tutorials/python/lesson-id.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

    <!-- 3. THEME DETECTION -->
    <script>
        (function () {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <!-- 4. STRUCTURED DATA -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Lesson Title",
        "description": "Full description of what the lesson teaches.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner|Intermediate|Advanced",
        "teaches": ["Concept 1", "Concept 2", "Concept 3"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="lesson-id">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <!-- 5. BREADCRUMB -->
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Lesson Title</span>
                </nav>

                <!-- 6. LESSON HEADER -->
                <header class="lesson-header">
                    <h1 class="lesson-title">Lesson Title</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <!-- 7. LESSON BODY -->
                <div class="lesson-body">

                    <!-- ========== LEAD PARAGRAPH (REQUIRED) ========== -->
                    <p class="lead">Introduction paragraph explaining what this lesson covers
                    and why it's important. 2-3 sentences that hook the reader.</p>

                    <!-- ========== SECTION 1 (REQUIRED) ========== -->
                    <h2>First Concept</h2>
                    <p>Explanation of the concept with context and theory...</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lesson-concept1.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-concept1" />
                    </jsp:include>

                    <!-- INFO BOX - For general information -->
                    <div class="info-box">
                        <strong>Key Point:</strong> Important information the reader should note.
                    </div>

                    <!-- ========== SECTION 2 (REQUIRED) ========== -->
                    <h2>Second Concept</h2>
                    <p>Explanation with a reference table:</p>

                    <!-- INFO TABLE - For reference data -->
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Row 1</td>
                                <td>Description</td>
                                <td><code>example</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lesson-concept2.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-concept2" />
                    </jsp:include>

                    <!-- ========== TIP BOX (REQUIRED) ========== -->
                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Helpful advice for better coding practices.
                        Every lesson MUST have at least one tip-box.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- ========== SECTION 3 (REQUIRED) ========== -->
                    <h2>Third Concept</h2>
                    <p>More explanation with practical examples...</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/lesson-concept3.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-concept3" />
                    </jsp:include>

                    <!-- ========== WARNING BOX (REQUIRED) ========== -->
                    <div class="warning-box">
                        <strong>Caution:</strong> Common pitfall or important warning.
                        Every lesson MUST have at least one warning-box.
                    </div>

                    <!-- ========== COMMON MISTAKES (REQUIRED) ========== -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. First common mistake</h4>
                        <pre><code class="language-python"># Wrong
wrong_code_example()

# Correct
correct_code_example()</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Second common mistake</h4>
                        <pre><code class="language-python"># Wrong
another_wrong()

# Correct
another_correct()</code></pre>
                    </div>

                    <!-- ========== EXERCISE (REQUIRED) ========== -->
                    <h2>Exercise: Practice Task Name</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Description of what to build/solve.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Requirement 1</li>
                            <li>Requirement 2</li>
                            <li>Requirement 3</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-lesson-id.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-lesson" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python"># Complete solution code
def solution():
    pass</code></pre>
                        </details>
                    </div>

                    <!-- ========== SUMMARY (REQUIRED) ========== -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Concept 1:</strong> Brief recap</li>
                            <li><strong>Concept 2:</strong> Brief recap</li>
                            <li><strong>Concept 3:</strong> Brief recap</li>
                        </ul>
                    </div>

                    <!-- ========== WHAT'S NEXT (REQUIRED) ========== -->
                    <h2>What's Next?</h2>
                    <p>Transition text to the next lesson. In the next lesson,
                    we'll explore <strong>Next Topic</strong> and learn how to...</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="previous-lesson.jsp" />
                    <jsp:param name="prevTitle" value="Previous Lesson" />
                    <jsp:param name="nextLink" value="next-lesson.jsp" />
                    <jsp:param name="nextTitle" value="Next Lesson" />
                    <jsp:param name="currentLessonId" value="lesson-id" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>
```

### 7.5 Content Structure Checklist

**Every lesson MUST include these elements:**

| Element | Required | CSS Class | Purpose |
|---------|----------|-----------|---------|
| Lead paragraph | ✅ **YES** | `.lead` | Hook reader, explain what they'll learn |
| 3-6 concept sections | ✅ **YES** | `<h2>` | Each with explanation + code example |
| Code examples | ✅ **YES** | `tutorial-compiler.jsp` | 3-6 interactive examples |
| Info box | ✅ **YES** | `.info-box` | Key points, important notes |
| Tip box | ✅ **YES** | `.tip-box` | Pro tips, best practices, shortcuts |
| Warning box | ✅ **YES** | `.warning-box` | Cautions, pitfalls, common errors |
| Info table | Optional | `.info-table` | Reference data, syntax tables |
| Best practice box | Optional | `.best-practice-box` | Recommended approaches |
| Common Mistakes | ✅ **YES** | `.mistake-box` | 2-4 mistakes with wrong/correct code |
| Exercise | ✅ **YES** | `.exercise-section` | Hands-on practice with solution |
| Summary | ✅ **YES** | `.summary-box` | Bullet point recap |
| What's Next | ✅ **YES** | `<h2>` + `<p>` | Transition to next lesson |

### 7.6 Callout Box Quick Reference

```html
<!-- REQUIRED: Info Box - General information -->
<div class="info-box">
    <strong>Key Point:</strong> Important fact or concept.
</div>

<!-- REQUIRED: Tip Box - Helpful tips -->
<div class="tip-box">
    <strong>Pro Tip:</strong> Best practice advice or shortcut.
</div>

<!-- REQUIRED: Warning Box - Cautions -->
<div class="warning-box">
    <strong>Caution:</strong> Common pitfall to avoid.
</div>

<!-- OPTIONAL: Best Practice Box -->
<div class="best-practice-box">
    <strong>Best Practice:</strong> Recommended approach.
</div>

<!-- REQUIRED (in Common Mistakes section): Mistake Box -->
<div class="mistake-box">
    <h4>1. Mistake title</h4>
    <pre><code class="language-python"># Wrong
wrong_code()

# Correct
correct_code()</code></pre>
</div>

<!-- REQUIRED: Summary Box -->
<div class="summary-box">
    <ul>
        <li><strong>Topic:</strong> Summary point</li>
    </ul>
</div>
```

### 7.7 Lesson Quality Audit Checklist

Before publishing a lesson, verify:

- [ ] Has `<p class="lead">` introduction paragraph
- [ ] Has 3+ sections with `<h2>` headings
- [ ] Has 3+ interactive code examples (tutorial-compiler.jsp)
- [ ] Has at least 1 `.info-box`
- [ ] Has at least 1 `.tip-box` (MANDATORY)
- [ ] Has at least 1 `.warning-box` (MANDATORY)
- [ ] Has "Common Mistakes" section with 2+ `.mistake-box`
- [ ] Has "Exercise" section with `.exercise-section`
- [ ] Has "Summary" section with `.summary-box`
- [ ] Has "What's Next?" section with transition text
- [ ] All code examples are executable (not just `<pre>` blocks)
- [ ] JSON-LD schema includes `teaches` array
- [ ] Meta description is 150-160 characters

---

## 8. Special Content Elements

This section defines the visual design system for callouts, exercises, definitions, and syntax highlighting.

### 8.1 Callouts & Asides

Use callout boxes to highlight important information. Each type has distinct styling:

| Type | Class | Icon | Use Case |
|------|-------|------|----------|
| **Info** | `.info-box` | ℹ️ | General information, background context |
| **Tip** | `.tip-box` | 💡 | Helpful suggestions, shortcuts |
| **Warning** | `.warning-box` | ⚠️ | Cautions, common pitfalls |
| **Best Practice** | `.best-practice-box` | ✅ | Recommended approaches |
| **Mistake** | `.mistake-box` | ❌ | Common errors to avoid |

#### Callout CSS Specifications

```css
/* Base Callout Styles */
.info-box, .tip-box, .warning-box, .best-practice-box, .mistake-box {
    padding: var(--space-4);           /* 16px */
    margin: var(--space-4) 0;
    border-radius: var(--radius-md);   /* 8px */
    border-left: 4px solid;
    font-size: var(--text-sm);         /* 14px */
    line-height: 1.6;
}

/* Info Box - Blue */
.info-box {
    background: #e0f2fe;               /* Light blue */
    border-color: #0284c7;             /* Sky 600 */
    color: #0c4a6e;                    /* Sky 900 */
}

[data-theme="dark"] .info-box {
    background: #0c4a6e20;
    border-color: #38bdf8;
    color: #e0f2fe;
}

/* Tip Box - Green */
.tip-box {
    background: #dcfce7;               /* Light green */
    border-color: #16a34a;             /* Green 600 */
    color: #14532d;                    /* Green 900 */
}

[data-theme="dark"] .tip-box {
    background: #14532d20;
    border-color: #4ade80;
    color: #dcfce7;
}

/* Warning Box - Amber */
.warning-box {
    background: #fef3c7;               /* Light amber */
    border-color: #d97706;             /* Amber 600 */
    color: #78350f;                    /* Amber 900 */
}

[data-theme="dark"] .warning-box {
    background: #78350f20;
    border-color: #fbbf24;
    color: #fef3c7;
}

/* Best Practice Box - Emerald */
.best-practice-box {
    background: #d1fae5;               /* Light emerald */
    border-color: #059669;             /* Emerald 600 */
    color: #064e3b;                    /* Emerald 900 */
}

[data-theme="dark"] .best-practice-box {
    background: #064e3b20;
    border-color: #34d399;
    color: #d1fae5;
}

/* Mistake Box - Red */
.mistake-box {
    background: #fee2e2;               /* Light red */
    border-color: #dc2626;             /* Red 600 */
    color: #7f1d1d;                    /* Red 900 */
}

[data-theme="dark"] .mistake-box {
    background: #7f1d1d20;
    border-color: #f87171;
    color: #fee2e2;
}

/* Callout Title */
.info-box strong, .tip-box strong, .warning-box strong,
.best-practice-box strong, .mistake-box strong {
    display: block;
    font-weight: 600;
    margin-bottom: var(--space-2);
}
```

#### HTML Usage

```html
<div class="info-box">
    <strong>Note:</strong> Strings in Python are immutable.
</div>

<div class="tip-box">
    <strong>Tip:</strong> Use f-strings for cleaner formatting.
</div>

<div class="warning-box">
    <strong>Warning:</strong> Division by zero raises an exception.
</div>

<div class="best-practice-box">
    <strong>Best Practice:</strong> Always use descriptive variable names.
</div>

<div class="mistake-box">
    <h4>Common Mistake: Using = instead of ==</h4>
    <pre><code>if x = 5:  # Wrong - assignment, not comparison</code></pre>
</div>
```

### 8.2 Exercises & Challenges

#### Exercise Section Structure

```
┌─────────────────────────────────────────────────┐
│  EXERCISE HEADER                                │
│  ├─ Icon (graduation cap)                       │
│  ├─ Title: "Exercise: [Name]"                   │
│  └─ Difficulty badge (Easy/Medium/Hard)         │
├─────────────────────────────────────────────────┤
│  EXERCISE BODY                                  │
│  ├─ Task description                            │
│  ├─ Requirements list                           │
│  ├─ [COMPILER BLOCK with starter code]          │
│  └─ Collapsible solution/hint                   │
└─────────────────────────────────────────────────┘
```

#### Exercise CSS Specifications

```css
/* Exercise Section Container */
.exercise-section {
    background: var(--bg-secondary);
    border: 2px solid var(--accent-primary);
    border-radius: var(--radius-lg);     /* 12px */
    padding: var(--space-6);             /* 24px */
    margin: var(--space-6) 0;
}

[data-theme="dark"] .exercise-section {
    background: #1e293b;
    border-color: var(--accent-primary);
}

/* Exercise Header */
.exercise-section h3,
.exercise-section h2 {
    display: flex;
    align-items: center;
    gap: var(--space-2);
    margin-top: 0;
    color: var(--accent-primary);
    font-size: var(--text-xl);           /* 20px */
    font-weight: 600;
}

/* Exercise Icon (before title) */
.exercise-section h3::before {
    content: "🎯";
    font-size: 1.2em;
}

/* Difficulty Badges */
.difficulty-badge {
    display: inline-block;
    padding: var(--space-1) var(--space-3);
    border-radius: var(--radius-full);
    font-size: var(--text-xs);           /* 12px */
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.difficulty-easy {
    background: #dcfce7;
    color: #16a34a;
}

.difficulty-medium {
    background: #fef3c7;
    color: #d97706;
}

.difficulty-hard {
    background: #fee2e2;
    color: #dc2626;
}

/* Requirements List */
.exercise-section ul {
    margin: var(--space-3) 0;
    padding-left: var(--space-6);
}

.exercise-section li {
    margin: var(--space-2) 0;
    color: var(--text-secondary);
}

/* Exercise Hint/Solution Accordion */
.exercise-hint {
    margin-top: var(--space-4);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
}

.exercise-hint summary {
    padding: var(--space-3) var(--space-4);
    background: var(--bg-tertiary);
    cursor: pointer;
    font-weight: 500;
    color: var(--text-secondary);
    border-radius: var(--radius-md);
}

.exercise-hint summary:hover {
    background: var(--bg-hover);
}

.exercise-hint[open] summary {
    border-bottom: 1px solid var(--border);
    border-radius: var(--radius-md) var(--radius-md) 0 0;
}

.exercise-hint pre {
    margin: 0;
    padding: var(--space-4);
    border-radius: 0 0 var(--radius-md) var(--radius-md);
}
```

### 8.3 Definitions & Key Terms

For glossary-style definitions and key term highlighting:

```css
/* Key Term Highlight */
.key-term {
    font-weight: 600;
    color: var(--accent-primary);
    background: var(--accent-primary-light);
    padding: 0 var(--space-1);
    border-radius: var(--radius-sm);
}

/* Definition List */
.definition-list {
    margin: var(--space-4) 0;
}

.definition-list dt {
    font-weight: 600;
    color: var(--text-primary);
    margin-top: var(--space-3);
}

.definition-list dd {
    margin-left: var(--space-4);
    color: var(--text-secondary);
    border-left: 2px solid var(--border);
    padding-left: var(--space-3);
}

/* Summary Box (end of lesson) */
.summary-box {
    background: linear-gradient(135deg, var(--accent-primary-light) 0%, var(--bg-secondary) 100%);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: var(--space-5);
    margin: var(--space-6) 0;
}

.summary-box ul {
    margin: 0;
    padding-left: var(--space-5);
}

.summary-box li {
    margin: var(--space-2) 0;
}
```

### 8.4 Progress Indicators

```css
/* Lesson Progress Bar */
.progress-bar-container {
    position: fixed;
    top: var(--header-height);
    left: 0;
    right: 0;
    height: 3px;
    background: var(--bg-tertiary);
    z-index: 40;
}

.progress-bar {
    height: 100%;
    background: linear-gradient(90deg, var(--accent-primary), var(--success));
    width: 0%;
    transition: width 0.3s ease;
}

/* Completion Checkmark */
.lesson-complete {
    display: flex;
    align-items: center;
    gap: var(--space-2);
    color: var(--success);
    font-weight: 500;
}

.lesson-complete::before {
    content: "✓";
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 20px;
    height: 20px;
    background: var(--success);
    color: white;
    border-radius: 50%;
    font-size: 12px;
}
```

### 8.5 Color Palette

#### Light Theme Colors

| Token | Value | Usage |
|-------|-------|-------|
| `--bg-primary` | `#ffffff` | Page background |
| `--bg-secondary` | `#f8fafc` | Card backgrounds |
| `--bg-tertiary` | `#f1f5f9` | Subtle backgrounds |
| `--text-primary` | `#0f172a` | Main text |
| `--text-secondary` | `#475569` | Secondary text |
| `--text-muted` | `#94a3b8` | Muted/disabled text |
| `--accent-primary` | `#3b82f6` | Links, buttons |
| `--accent-primary-light` | `#eff6ff` | Accent backgrounds |
| `--success` | `#22c55e` | Success states |
| `--success-light` | `#dcfce7` | Success backgrounds |
| `--warning` | `#f59e0b` | Warning states |
| `--error` | `#ef4444` | Error states |
| `--border` | `#e2e8f0` | Borders |

#### Dark Theme Colors

| Token | Value | Usage |
|-------|-------|-------|
| `--bg-primary` | `#0f172a` | Page background |
| `--bg-secondary` | `#1e293b` | Card backgrounds |
| `--bg-tertiary` | `#334155` | Subtle backgrounds |
| `--text-primary` | `#f1f5f9` | Main text |
| `--text-secondary` | `#94a3b8` | Secondary text |
| `--text-muted` | `#64748b` | Muted/disabled text |
| `--accent-primary` | `#60a5fa` | Links, buttons |
| `--border` | `#334155` | Borders |

#### Code Block Colors

| Element | Light | Dark |
|---------|-------|------|
| Background | `#1e1e1e` | `#1e1e1e` |
| Text | `#d4d4d4` | `#d4d4d4` |
| Line Numbers BG | `#252526` | `#252526` |
| Line Numbers Text | `#858585` | `#858585` |

### 8.6 Syntax Highlighting (Monokai Theme)

CodeMirror uses the Monokai color scheme. Here are the token colors:

| Token Type | Color | Hex |
|------------|-------|-----|
| **Keywords** | Pink | `#f92672` |
| **Strings** | Yellow | `#e6db74` |
| **Comments** | Gray | `#75715e` |
| **Functions** | Green | `#a6e22e` |
| **Numbers** | Purple | `#ae81ff` |
| **Variables** | White | `#f8f8f2` |
| **Operators** | Red | `#f92672` |
| **Types/Classes** | Cyan | `#66d9ef` |
| **Properties** | White | `#f8f8f2` |
| **Brackets** | White | `#f8f8f2` |

#### Syntax Highlighting CSS

```css
/* CodeMirror Monokai Overrides */
.cm-s-monokai .cm-keyword { color: #f92672; }
.cm-s-monokai .cm-atom { color: #ae81ff; }
.cm-s-monokai .cm-number { color: #ae81ff; }
.cm-s-monokai .cm-def { color: #a6e22e; }
.cm-s-monokai .cm-variable { color: #f8f8f2; }
.cm-s-monokai .cm-variable-2 { color: #9effff; }
.cm-s-monokai .cm-variable-3, .cm-s-monokai .cm-type { color: #66d9ef; }
.cm-s-monokai .cm-property { color: #a6e22e; }
.cm-s-monokai .cm-operator { color: #f92672; }
.cm-s-monokai .cm-comment { color: #75715e; }
.cm-s-monokai .cm-string { color: #e6db74; }
.cm-s-monokai .cm-string-2 { color: #e6db74; }
.cm-s-monokai .cm-meta { color: #f8f8f2; }
.cm-s-monokai .cm-qualifier { color: #f8f8f2; }
.cm-s-monokai .cm-builtin { color: #66d9ef; }
.cm-s-monokai .cm-bracket { color: #f8f8f2; }
.cm-s-monokai .cm-tag { color: #f92672; }
.cm-s-monokai .cm-attribute { color: #a6e22e; }
.cm-s-monokai .cm-header { color: #ae81ff; }
.cm-s-monokai .cm-quote { color: #e6db74; }
.cm-s-monokai .cm-hr { color: #75715e; }
.cm-s-monokai .cm-link { color: #ae81ff; }
.cm-s-monokai .cm-error { background: #f92672; color: #f8f8f0; }
```

### 8.7 Fonts CSS

The tutorial platform uses self-hosted fonts defined in `fonts.css`. This ensures independence from external services and faster loading.

#### Font Files Location

```
/tutorials/assets/fonts/
├── Inter-Regular.woff2      (400 weight)
├── Inter-Medium.woff2       (500 weight)
├── Inter-SemiBold.woff2     (600 weight)
├── Inter-Bold.woff2         (700 weight)
├── JetBrainsMono-Regular.woff2   (400 weight)
└── JetBrainsMono-Medium.woff2    (500 weight)
```

#### fonts.css Structure

```css
/**
 * 8gwifi.org Tutorial Platform - Font Definitions
 * Self-hosted fonts for independence
 *
 * Download fonts and place in /tutorials/assets/fonts/:
 * - Inter: https://fonts.google.com/specimen/Inter
 * - JetBrains Mono: https://www.jetbrains.com/lp/mono/
 */

/* Inter - Primary UI Font */
@font-face {
    font-family: 'Inter';
    font-style: normal;
    font-weight: 400;
    font-display: swap;
    src: url('../fonts/Inter-Regular.woff2') format('woff2');
}

@font-face {
    font-family: 'Inter';
    font-style: normal;
    font-weight: 500;
    font-display: swap;
    src: url('../fonts/Inter-Medium.woff2') format('woff2');
}

@font-face {
    font-family: 'Inter';
    font-style: normal;
    font-weight: 600;
    font-display: swap;
    src: url('../fonts/Inter-SemiBold.woff2') format('woff2');
}

@font-face {
    font-family: 'Inter';
    font-style: normal;
    font-weight: 700;
    font-display: swap;
    src: url('../fonts/Inter-Bold.woff2') format('woff2');
}

/* JetBrains Mono - Code Font */
@font-face {
    font-family: 'JetBrains Mono';
    font-style: normal;
    font-weight: 400;
    font-display: swap;
    src: url('../fonts/JetBrainsMono-Regular.woff2') format('woff2');
}

@font-face {
    font-family: 'JetBrains Mono';
    font-style: normal;
    font-weight: 500;
    font-display: swap;
    src: url('../fonts/JetBrainsMono-Medium.woff2') format('woff2');
}
```

#### Font Download Links

| Font | Source | Weights Needed |
|------|--------|----------------|
| **Inter** | [Google Fonts](https://fonts.google.com/specimen/Inter) | 400, 500, 600, 700 |
| **JetBrains Mono** | [JetBrains](https://www.jetbrains.com/lp/mono/) | 400, 500 |

### 8.8 Typography

#### Typography Scale

| Element | Font | Size | Weight | Line Height |
|---------|------|------|--------|-------------|
| Body | Inter | 16px | 400 | 1.6 |
| H1 | Inter | 32px | 700 | 1.2 |
| H2 | Inter | 24px | 600 | 1.3 |
| H3 | Inter | 20px | 600 | 1.4 |
| H4 | Inter | 18px | 600 | 1.4 |
| Code (inline) | JetBrains Mono | 14px | 400 | 1.5 |
| Code (block) | JetBrains Mono | 14px | 400 | 1.5 |
| Lead paragraph | Inter | 18px | 400 | 1.7 |
| Small/Caption | Inter | 12px | 400 | 1.5 |

#### Typography CSS Variables

```css
/* Typography Variables */
:root {
    /* Font Families */
    --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
    --font-mono: 'JetBrains Mono', 'Fira Code', Consolas, monospace;

    /* Font Sizes */
    --text-xs: 0.75rem;    /* 12px */
    --text-sm: 0.875rem;   /* 14px */
    --text-base: 1rem;     /* 16px */
    --text-lg: 1.125rem;   /* 18px */
    --text-xl: 1.25rem;    /* 20px */
    --text-2xl: 1.5rem;    /* 24px */
    --text-3xl: 1.875rem;  /* 30px */
    --text-4xl: 2rem;      /* 32px */
}
```

#### Typography Styles

```css
/* Lead Paragraph */
.lead {
    font-size: var(--text-lg);
    color: var(--text-secondary);
    line-height: 1.7;
    margin-bottom: var(--space-6);
}

/* Inline Code */
code:not(pre code) {
    font-family: var(--font-mono);
    font-size: 0.875em;
    background: var(--bg-tertiary);
    padding: 0.125em 0.375em;
    border-radius: var(--radius-sm);
    color: var(--accent-primary);
}

[data-theme="dark"] code:not(pre code) {
    background: #334155;
    color: #f472b6;
}
```

### 8.9 Info Tables

For comparison tables and reference tables:

```css
.info-table {
    width: 100%;
    border-collapse: collapse;
    margin: var(--space-4) 0;
    font-size: var(--text-sm);
}

.info-table th,
.info-table td {
    padding: var(--space-3) var(--space-4);
    text-align: left;
    border-bottom: 1px solid var(--border);
}

.info-table th {
    background: var(--bg-tertiary);
    font-weight: 600;
    color: var(--text-primary);
}

.info-table tr:hover {
    background: var(--bg-secondary);
}

.info-table code {
    background: var(--bg-primary);
}

[data-theme="dark"] .info-table th {
    background: #1e293b;
}
```

---

## 9. Course Content Guide

This section defines the curriculum structure for each language, ensuring comprehensive coverage from beginner to advanced topics.

### 8.1 Lesson Structure Principles

**Every lesson MUST follow these rules:**

1. **All Code Snippets Must Be Executable**
   - Every code example should be in a compiler component, not just static `<pre>` blocks
   - Users should be able to modify and run every example
   - Exception: Very small syntax snippets (1-2 lines) can be static

2. **Every Lesson Ends With an Exercise**
   - Include at least one hands-on exercise at the end
   - Provide a starter code template in the compiler
   - Include expected output or success criteria
   - Consider adding a quiz component for knowledge check

3. **Progressive Complexity**
   - Start with simplest possible example
   - Build complexity gradually
   - Reference previous lessons when using learned concepts

4. **Complete Topic Coverage**
   - Don't skip subtopics (e.g., Python has 15+ data types, not just 3)
   - Cover edge cases and common pitfalls
   - Include real-world use cases

### 8.2 Lesson Template Structure

```
┌─────────────────────────────────────────────┐
│ 1. INTRODUCTION (2-3 sentences)             │
│    - What this lesson covers                │
│    - Why it's important                     │
├─────────────────────────────────────────────┤
│ 2. CONCEPT EXPLANATION                      │
│    - Theory with examples                   │
│    - [EXECUTABLE COMPILER BLOCK]            │
├─────────────────────────────────────────────┤
│ 3. DETAILED BREAKDOWN                       │
│    - Sub-topics with examples               │
│    - [EXECUTABLE COMPILER BLOCK]            │
│    - [EXECUTABLE COMPILER BLOCK]            │
├─────────────────────────────────────────────┤
│ 4. COMMON PATTERNS / BEST PRACTICES         │
│    - Real-world usage                       │
│    - [EXECUTABLE COMPILER BLOCK]            │
├─────────────────────────────────────────────┤
│ 5. COMMON MISTAKES / PITFALLS               │
│    - What to avoid                          │
│    - [EXECUTABLE COMPILER BLOCK]            │
├─────────────────────────────────────────────┤
│ 6. EXERCISE                                 │
│    - Problem statement                      │
│    - [EXECUTABLE COMPILER with starter]     │
│    - Expected output                        │
├─────────────────────────────────────────────┤
│ 7. QUIZ (optional)                          │
│    - 2-3 multiple choice questions          │
├─────────────────────────────────────────────┤
│ 8. SUMMARY                                  │
│    - Key points learned                     │
│    - Link to next lesson                    │
└─────────────────────────────────────────────┘
```

---

## 9. Python Curriculum

### 9.1 Module 1: Getting Started (Beginner)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **1.1 Introduction** | What is Python, Why Python, Python versions, Installation | `intro-hello.py` |
| **1.2 First Program** | print(), Running scripts, Python REPL | `first-program.py` |
| **1.3 Comments** | Single-line (#), Multi-line ('''), Docstrings | `comments-examples.py` |
| **1.4 Syntax Basics** | Indentation, Line continuation, Semicolons | `syntax-basics.py` |

### 9.2 Module 2: Variables & Data Types (Beginner)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **2.1 Variables** | Assignment, Naming rules, Multiple assignment, Constants | `variables-basics.py`, `variables-naming.py` |
| **2.2 Numbers** | `int`, `float`, `complex`, Type conversion, Math operations | `numbers-int.py`, `numbers-float.py`, `numbers-complex.py` |
| **2.3 Strings** | Creating, Indexing, Slicing, Escape chars, Raw strings | `strings-basics.py`, `strings-slicing.py` |
| **2.4 String Methods** | upper(), lower(), split(), join(), find(), replace(), format() | `strings-methods.py`, `strings-format.py` |
| **2.5 Booleans** | True/False, Truthy/Falsy values, bool() function | `booleans-basics.py`, `booleans-truthy.py` |
| **2.6 Type Conversion** | int(), float(), str(), type(), isinstance() | `type-conversion.py` |
| **2.7 None Type** | None, Checking for None, Use cases | `none-type.py` |

### 9.3 Module 3: Operators (Beginner)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **3.1 Arithmetic** | +, -, *, /, //, %, ** | `operators-arithmetic.py` |
| **3.2 Comparison** | ==, !=, <, >, <=, >=, is, is not | `operators-comparison.py` |
| **3.3 Logical** | and, or, not, Short-circuit evaluation | `operators-logical.py` |
| **3.4 Assignment** | =, +=, -=, *=, /=, //=, %=, **= | `operators-assignment.py` |
| **3.5 Bitwise** | &, |, ^, ~, <<, >> | `operators-bitwise.py` |
| **3.6 Membership & Identity** | in, not in, is, is not | `operators-membership.py` |

### 9.4 Module 4: Control Flow (Beginner)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **4.1 If Statements** | if, else, elif, Nested if | `control-if.py`, `control-elif.py` |
| **4.2 Ternary Operator** | Conditional expressions | `control-ternary.py` |
| **4.3 For Loops** | Iterating sequences, range(), enumerate() | `loops-for.py`, `loops-range.py` |
| **4.4 While Loops** | Condition-based loops, Infinite loops | `loops-while.py` |
| **4.5 Loop Control** | break, continue, pass, else clause | `loops-control.py` |
| **4.6 Nested Loops** | Loop inside loop, Breaking nested loops | `loops-nested.py` |

### 9.5 Module 5: Data Structures (Intermediate)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **5.1 Lists** | Creating, Indexing, Slicing, Mutable | `lists-basics.py`, `lists-slicing.py` |
| **5.2 List Methods** | append(), extend(), insert(), remove(), pop(), sort(), reverse() | `lists-methods.py` |
| **5.3 List Comprehensions** | Basic, With conditions, Nested | `lists-comprehension.py` |
| **5.4 Tuples** | Creating, Immutable, Packing/Unpacking, Named tuples | `tuples-basics.py`, `tuples-unpacking.py` |
| **5.5 Sets** | Creating, Unique values, Set operations | `sets-basics.py`, `sets-operations.py` |
| **5.6 Dictionaries** | Key-value pairs, Accessing, Methods | `dicts-basics.py`, `dicts-methods.py` |
| **5.7 Dict Comprehensions** | Creating dicts with comprehensions | `dicts-comprehension.py` |
| **5.8 Nested Structures** | Lists of dicts, Dicts of lists | `nested-structures.py` |

### 9.6 Module 6: Functions (Intermediate)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **6.1 Defining Functions** | def, Parameters, Return values | `functions-basics.py` |
| **6.2 Arguments** | Positional, Keyword, Default values | `functions-args.py` |
| **6.3 *args and **kwargs** | Variable arguments, Unpacking | `functions-varargs.py` |
| **6.4 Return Values** | Single, Multiple, None | `functions-return.py` |
| **6.5 Scope** | Local, Global, Enclosing, Built-in (LEGB) | `functions-scope.py` |
| **6.6 Lambda Functions** | Anonymous functions, Use with map/filter | `functions-lambda.py` |
| **6.7 Higher-Order Functions** | map(), filter(), reduce(), sorted() | `functions-higher-order.py` |
| **6.8 Decorators** | Function decorators, @syntax | `functions-decorators.py` |
| **6.9 Recursion** | Recursive functions, Base case | `functions-recursion.py` |

### 9.7 Module 7: Modules & Packages (Intermediate)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **7.1 Importing** | import, from...import, as | `modules-import.py` |
| **7.2 Built-in Modules** | math, random, datetime, os, sys | `modules-builtin.py` |
| **7.3 Creating Modules** | Your own modules, __name__ | `modules-create.py` |
| **7.4 Packages** | Package structure, __init__.py | `packages-basics.py` |
| **7.5 pip & PyPI** | Installing packages, requirements.txt | `packages-pip.py` |

### 9.8 Module 8: File Handling (Intermediate)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **8.1 Reading Files** | open(), read(), readline(), readlines() | `files-read.py` |
| **8.2 Writing Files** | write(), writelines(), Modes (w, a) | `files-write.py` |
| **8.3 Context Managers** | with statement, Auto-closing | `files-context.py` |
| **8.4 Working with Paths** | os.path, pathlib | `files-paths.py` |
| **8.5 CSV Files** | csv module, Reading/Writing CSV | `files-csv.py` |
| **8.6 JSON Files** | json module, Parsing, Serializing | `files-json.py` |

### 9.9 Module 9: Error Handling (Intermediate)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **9.1 Exceptions** | What are exceptions, Common exceptions | `errors-basics.py` |
| **9.2 Try/Except** | Catching exceptions, Multiple except | `errors-try-except.py` |
| **9.3 Finally & Else** | Cleanup code, Success code | `errors-finally.py` |
| **9.4 Raising Exceptions** | raise, Custom exceptions | `errors-raise.py` |
| **9.5 Assertions** | assert statement, Debugging | `errors-assert.py` |

### 9.10 Module 10: Object-Oriented Programming (Advanced)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **10.1 Classes & Objects** | class, __init__, self, Attributes | `oop-classes.py` |
| **10.2 Methods** | Instance, Class, Static methods | `oop-methods.py` |
| **10.3 Inheritance** | Single, Multiple, super() | `oop-inheritance.py` |
| **10.4 Encapsulation** | Public, Protected, Private (_,__) | `oop-encapsulation.py` |
| **10.5 Polymorphism** | Method overriding, Duck typing | `oop-polymorphism.py` |
| **10.6 Special Methods** | __str__, __repr__, __len__, __eq__ | `oop-dunder.py` |
| **10.7 Properties** | @property, Getters/Setters | `oop-properties.py` |
| **10.8 Abstract Classes** | ABC, @abstractmethod | `oop-abstract.py` |
| **10.9 Dataclasses** | @dataclass, Auto-generated methods | `oop-dataclass.py` |

### 9.11 Module 11: Advanced Topics (Advanced)

| Lesson | Topics to Cover | Code Files Needed |
|--------|-----------------|-------------------|
| **11.1 Iterators** | __iter__, __next__, Custom iterators | `advanced-iterators.py` |
| **11.2 Generators** | yield, Generator expressions | `advanced-generators.py` |
| **11.3 Context Managers** | __enter__, __exit__, @contextmanager | `advanced-context.py` |
| **11.4 Regular Expressions** | re module, Patterns, Match/Search | `advanced-regex.py` |
| **11.5 Type Hints** | Annotations, typing module | `advanced-typing.py` |
| **11.6 Virtual Environments** | venv, Managing dependencies | `advanced-venv.py` |

---

## 10. Java Curriculum

### 10.1 Module 1: Getting Started (Beginner)

| Lesson | Topics to Cover |
|--------|-----------------|
| **1.1 Introduction** | What is Java, JDK vs JRE vs JVM, Installation |
| **1.2 First Program** | main method, System.out.println, Compilation |
| **1.3 Syntax Basics** | Statements, Blocks, Comments |

### 10.2 Module 2: Variables & Data Types (Beginner)

| Lesson | Topics to Cover |
|--------|-----------------|
| **2.1 Primitive Types** | byte, short, int, long, float, double, boolean, char |
| **2.2 Variables** | Declaration, Initialization, Constants (final) |
| **2.3 Type Casting** | Widening, Narrowing, Explicit casting |
| **2.4 Strings** | String class, Immutability, String methods |
| **2.5 Arrays** | Declaration, Initialization, Accessing elements |

### 10.3 Module 3: Operators (Beginner)

| Lesson | Topics to Cover |
|--------|-----------------|
| **3.1 Arithmetic** | +, -, *, /, %, ++, -- |
| **3.2 Comparison** | ==, !=, <, >, <=, >= |
| **3.3 Logical** | &&, ||, ! |
| **3.4 Bitwise** | &, |, ^, ~, <<, >>, >>> |
| **3.5 Assignment** | =, +=, -=, etc. |

### 10.4 Module 4: Control Flow (Beginner)

| Lesson | Topics to Cover |
|--------|-----------------|
| **4.1 If Statements** | if, else, else if |
| **4.2 Switch** | switch, case, break, default |
| **4.3 For Loops** | Traditional for, Enhanced for |
| **4.4 While Loops** | while, do-while |
| **4.5 Loop Control** | break, continue, Labels |

### 10.5 Module 5: OOP Basics (Intermediate)

| Lesson | Topics to Cover |
|--------|-----------------|
| **5.1 Classes & Objects** | class, new, Constructors |
| **5.2 Methods** | Parameters, Return types, Overloading |
| **5.3 Access Modifiers** | public, private, protected, default |
| **5.4 Static Members** | static variables, static methods |
| **5.5 Inheritance** | extends, super, Overriding |
| **5.6 Interfaces** | interface, implements, default methods |
| **5.7 Abstract Classes** | abstract class, abstract methods |
| **5.8 Polymorphism** | Runtime polymorphism, instanceof |

### 10.6 Module 6: Collections (Intermediate)

| Lesson | Topics to Cover |
|--------|-----------------|
| **6.1 ArrayList** | Dynamic arrays, Methods |
| **6.2 LinkedList** | Doubly-linked list |
| **6.3 HashMap** | Key-value pairs |
| **6.4 HashSet** | Unique elements |
| **6.5 Iterators** | Iterator, ListIterator, for-each |

### 10.7 Module 7: Exception Handling (Intermediate)

| Lesson | Topics to Cover |
|--------|-----------------|
| **7.1 Try-Catch** | Catching exceptions |
| **7.2 Multiple Catch** | Handling different exceptions |
| **7.3 Finally** | Cleanup code |
| **7.4 Throw & Throws** | Throwing exceptions |
| **7.5 Custom Exceptions** | Creating exception classes |

---

## 11. Go Curriculum

### 11.1 Module 1: Getting Started (Beginner)

| Lesson | Topics to Cover |
|--------|-----------------|
| **1.1 Introduction** | What is Go, Why Go, Go philosophy |
| **1.2 Installation** | Installing Go, GOPATH, Go modules |
| **1.3 First Program** | package main, import, func main |
| **1.4 Running Go** | go run, go build |

### 11.2 Module 2: Variables & Types (Beginner)

| Lesson | Topics to Cover |
|--------|-----------------|
| **2.1 Variables** | var, :=, Zero values |
| **2.2 Basic Types** | int, float64, string, bool, byte, rune |
| **2.3 Constants** | const, iota |
| **2.4 Type Conversion** | Explicit conversion |

### 11.3 Module 3: Control Flow (Beginner)

| Lesson | Topics to Cover |
|--------|-----------------|
| **3.1 If Statements** | if, else, if with initialization |
| **3.2 Switch** | switch, case, fallthrough |
| **3.3 For Loops** | for (only loop in Go), range |
| **3.4 Defer** | defer, deferred execution |

### 11.4 Module 4: Data Structures (Intermediate)

| Lesson | Topics to Cover |
|--------|-----------------|
| **4.1 Arrays** | Fixed size, Declaration |
| **4.2 Slices** | Dynamic arrays, make, append, copy |
| **4.3 Maps** | Key-value pairs, make, delete |
| **4.4 Structs** | Custom types, Fields |
| **4.5 Pointers** | &, *, Pointer to struct |

### 11.5 Module 5: Functions (Intermediate)

| Lesson | Topics to Cover |
|--------|-----------------|
| **5.1 Functions** | Parameters, Return values |
| **5.2 Multiple Returns** | Named returns |
| **5.3 Variadic Functions** | ...args |
| **5.4 Closures** | Anonymous functions |
| **5.5 Methods** | Receiver functions |
| **5.6 Interfaces** | interface{}, Type assertions |

### 11.6 Module 6: Concurrency (Advanced)

| Lesson | Topics to Cover |
|--------|-----------------|
| **6.1 Goroutines** | go keyword, Lightweight threads |
| **6.2 Channels** | chan, Send/Receive |
| **6.3 Buffered Channels** | Capacity |
| **6.4 Select** | Multiplexing channels |
| **6.5 Sync Package** | WaitGroup, Mutex |

---

## 12. Exercise Guidelines

### 12.1 Exercise Types

| Type | Description | Example |
|------|-------------|---------|
| **Fix the Code** | Code with errors to fix | "Fix the syntax errors in this function" |
| **Complete the Code** | Partial code to complete | "Fill in the missing lines to make it work" |
| **Write from Scratch** | Build something new | "Write a function that calculates..." |
| **Modify Output** | Change existing code | "Modify the code to print numbers 1-10" |
| **Debug** | Find and fix logical errors | "The code runs but gives wrong output. Fix it." |

### 12.2 Exercise Template

```jsp
<div class="exercise-section">
    <h3>Exercise: Calculate Average</h3>
    <p><strong>Task:</strong> Write a function that takes a list of numbers
       and returns their average.</p>

    <p><strong>Requirements:</strong></p>
    <ul>
        <li>Handle empty list (return 0)</li>
        <li>Round to 2 decimal places</li>
    </ul>

    <jsp:include page="../tutorial-compiler.jsp">
        <jsp:param name="codeFile" value="python/exercises/ex-average-starter.py" />
        <jsp:param name="language" value="python" />
        <jsp:param name="editorId" value="exercise-average" />
    </jsp:include>

    <details class="exercise-solution">
        <summary>Show Expected Output</summary>
        <pre>Average of [1, 2, 3, 4, 5]: 3.0
Average of [10, 20]: 15.0
Average of []: 0</pre>
    </details>
</div>
```

### 12.3 Exercise Code File Structure

```
/tutorials/code/python/exercises/
├── ex-01-variables-starter.py
├── ex-01-variables-solution.py
├── ex-02-loops-starter.py
├── ex-02-loops-solution.py
└── ...
```

### 12.4 Difficulty Levels

| Level | Concepts Used | Lines of Code |
|-------|---------------|---------------|
| **Easy** | Current lesson only | 5-10 lines |
| **Medium** | Current + 1-2 previous lessons | 10-20 lines |
| **Hard** | Multiple concepts combined | 20-40 lines |

---

## Appendix: File Checklist for New Language

When adding a new language (e.g., Rust), create:

- [ ] `/tutorials/rust/index.jsp` - Course overview
- [ ] `/tutorials/rust/*.jsp` - Individual lesson pages
- [ ] `/tutorials/tutorial-sidebar-rust.jsp` - Navigation sidebar with logo
- [ ] `/tutorials/assets/images/rust-logo.svg` - Language logo (32x32 SVG)
- [ ] `/tutorials/code/rust/` - Directory for code examples
- [ ] Add sample code files (e.g., `hello-world.rs`, `variables-basic.rs`)
- [ ] Add CodeMirror mode: `/tutorials/assets/js/codemirror-modes/rust.min.js`
- [ ] Update `tutorial-compiler.jsp` if new language needs special handling
- [ ] Add entry to main tutorials index page
- [ ] Update this guide's logo table (Section 3.1)

---

## Appendix: Recent Updates (December 2024)

### External Code Files Support (NEW)
The `tutorial-compiler.jsp` now supports loading code from external files via the `codeFile` parameter:
```jsp
<jsp:param name="codeFile" value="python/variables-basic.py" />
```
**Benefits:**
- Edit Python/Java/Go with proper syntax highlighting
- No escaping needed for quotes, newlines
- Test code independently before adding to tutorials
- Better version control diffs

Code files are stored in `/tutorials/code/{language}/`.

### Newline Handling in Compiler
The `tutorial-compiler.jsp` properly handles escaped newlines (`\n`) in the `initialCode` parameter by converting them to actual newlines before display.

### Output Response Handling
Fixed case-sensitivity issue where servlet returns `Stdout`/`Stderr` (capitalized) but JavaScript was checking for `stdout`/`stderr` (lowercase). Now handles both formats.

### Line Numbers Display
Fixed line numbers displaying horizontally instead of vertically by adding `white-space: pre` to the CSS.

### Ad Slot Filtering
The `tutorial-ad-slot.jsp` component now only renders the specific slot requested via the `slot` parameter, preventing duplicate ad containers.

### Sidebar Consistency
All tutorial sidebars (HTML, CSS, JavaScript, Python, Java, Go) now follow a consistent structure with:
- Language logo in header
- Same nav-section/nav-items structure
- Consistent CSS class naming

### Layout CSS
- Added `tutorial-server.css` for server-side tutorial layouts
- `.no-preview` class removes preview panel space and centers content

---

*Last updated: December 2024*

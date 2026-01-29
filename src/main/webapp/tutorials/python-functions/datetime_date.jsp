<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "datetime_date" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python datetime.date - Date Objects | Try Free</title>
            <meta name="description"
                content="Learn how to use Python's datetime.date() constructor to create date objects. Syntax and examples.">
            <meta name="keywords"
                content="python datetime date, python create date, python date object, python date constructor">
    <meta property="og:title" content="Python datetime.date - Date Objects | Try Free">
    <meta property="og:description" content="Python datetime.date represents a date (year, month, day). Interactive examples with live code. Syntax: date(year, month, day). Work with dates. Try now!">
    <meta property="og:image" content="https://8gwifi.org/tutorials/assets/images/python-logo.svg">
    <meta name="twitter:card" content="summary">

    <meta name="twitter:description" content="Python datetime.date represents a date (year, month, day). Interactive examples with live code. Syntax: date(year, month, day). Work with dates. Try now!">            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/datetime_date.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "TechArticle",
        "headline": "Python datetime.date() Constructor",
        "description": "The datetime.date() constructor returns a date object.",
        "articleSection": "Python Date & Time",
        "keywords": "python, datetime, date, constructor",
        "datePublished": "2026-01-29",
        "dateModified": "2026-01-29",
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "logo": {
                "@type": "ImageObject",
                "url": "https://8gwifi.org/tutorials/assets/images/logo.svg"
            }
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="python-functions-datetime-date">
            <div class="tutorial-layout has-ad-rail">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-python-functions.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content" >
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python-functions/">Functions</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>datetime.date()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python datetime.date() Constructor</h1>
                                    <div class="lesson-meta">
                                        <span>Date & Time</span>
                                        <span>•</span>
                                        <span>Date Object</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>datetime.date()</code> class constructor is used to create a date
                                        object.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>datetime.date(year, month, day)</code></pre>

                                    <h2>Parameters</h2>
                                    <div class="table-responsive">
                                        <table class="reference-table">
                                            <thead>
                                                <tr>
                                                    <th>Parameter</th>
                                                    <th>Description</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><code>year</code></td>
                                                    <td>Required. The year</td>
                                                </tr>
                                                <tr>
                                                    <td><code>month</code></td>
                                                    <td>Required. The month (1-12)</td>
                                                </tr>
                                                <tr>
                                                    <td><code>day</code></td>
                                                    <td>Required. The day (1-31)</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A date object.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>datetime.date()</code> constructor:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/datetime_date.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="datetime_now.jsp" class="related-link">
                                            <span class="related-icon">🕒</span>
                                            <div>
                                                <strong>datetime.now()</strong>
                                                <span>Current time</span>
                                            </div>
                                        </a>
                                    </div>
                                </div>


                                                        </article>

                            <%-- Right Ad Rail (desktop only) --%>
                            <%@ include file="../tutorial-ad-rail.jsp" %>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

        </html>

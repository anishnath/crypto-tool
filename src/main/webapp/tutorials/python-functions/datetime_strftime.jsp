<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "datetime_strftime" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python datetime.strftime() Method - Format Date String | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use the Python datetime.strftime() method. Formats date objects into readable strings. Syntax, format codes, and examples.">
            <meta name="keywords"
                content="python strftime, python format date, python date to string, python date formatting codes">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/datetime_strftime.jsp">
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
        "headline": "Python datetime.strftime() Method",
        "description": "The strftime() method returns a string representing the date, controlled by an explicit format string.",
        "articleSection": "Python Date & Time",
        "keywords": "python, datetime, strftime, format",
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

        <body class="tutorial-body no-preview" data-lesson="python-functions-datetime-strftime">
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
                                    <span>strftime()</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python datetime.strftime() Method</h1>
                                    <div class="lesson-meta">
                                        <span>Date & Time</span>
                                        <span>•</span>
                                        <span>Format Date</span>
                                    </div>
                                </header>

                                <div class="lesson-body">
                                    <p class="lead">
                                        The <code>strftime()</code> method converts a <code>datetime</code> object to a
                                        string, according to a given format.
                                    </p>

                                    <h2>Syntax</h2>
                                    <pre class="language-python"><code>datetime_object.strftime(format)</code></pre>

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
                                                    <td><code>format</code></td>
                                                    <td>Required. A format string to define how the result string should
                                                        look.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Common Format Codes</h2>
                                    <div class="table-responsive">
                                        <table class="reference-table">
                                            <thead>
                                                <tr>
                                                    <th>Code</th>
                                                    <th>Description</th>
                                                    <th>Example</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>%a</td>
                                                    <td>Weekday, short version</td>
                                                    <td>Wed</td>
                                                </tr>
                                                <tr>
                                                    <td>%A</td>
                                                    <td>Weekday, full version</td>
                                                    <td>Wednesday</td>
                                                </tr>
                                                <tr>
                                                    <td>%w</td>
                                                    <td>Weekday as a number 0-6</td>
                                                    <td>3</td>
                                                </tr>
                                                <tr>
                                                    <td>%d</td>
                                                    <td>Day of month 01-31</td>
                                                    <td>31</td>
                                                </tr>
                                                <tr>
                                                    <td>%b</td>
                                                    <td>Month name, short version</td>
                                                    <td>Dec</td>
                                                </tr>
                                                <tr>
                                                    <td>%B</td>
                                                    <td>Month name, full version</td>
                                                    <td>December</td>
                                                </tr>
                                                <tr>
                                                    <td>%m</td>
                                                    <td>Month as a number 01-12</td>
                                                    <td>12</td>
                                                </tr>
                                                <tr>
                                                    <td>%y</td>
                                                    <td>Year, short version, without century</td>
                                                    <td>18</td>
                                                </tr>
                                                <tr>
                                                    <td>%Y</td>
                                                    <td>Year, full version</td>
                                                    <td>2018</td>
                                                </tr>
                                                <tr>
                                                    <td>%H</td>
                                                    <td>Hour 00-23</td>
                                                    <td>17</td>
                                                </tr>
                                                <tr>
                                                    <td>%M</td>
                                                    <td>Minute 00-59</td>
                                                    <td>41</td>
                                                </tr>
                                                <tr>
                                                    <td>%S</td>
                                                    <td>Second 00-59</td>
                                                    <td>08</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                    <h2>Return Value</h2>
                                    <p>A string representing the date.</p>

                                    <h2>Example</h2>
                                    <p>Using the <code>strftime()</code> method:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="codeFile"
                                            value="python-functions/datetime_strftime.py" />
                                    </jsp:include>

                                    <h2>Related Functions</h2>
                                    <div class="related-links">
                                        <a href="datetime_strptime.jsp" class="related-link">
                                            <span class="related-icon">🔄</span>
                                            <div>
                                                <strong>datetime.strptime()</strong>
                                                <span>String to date</span>
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

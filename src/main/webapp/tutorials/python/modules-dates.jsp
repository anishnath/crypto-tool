<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "modules-dates");
   request.setAttribute("currentModule", "Modules & Packages"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python datetime Module - Date Objects, Formatting, Timedelta, Parsing | 8gwifi.org</title>
    <meta name="description"
        content="Master Python datetime module - create date objects, format dates with strftime, perform date arithmetic with timedelta, and parse date strings with strptime.">
    <meta name="keywords"
        content="python datetime, python date, python strftime, python strptime, python timedelta, python date formatting, python date parsing, python date arithmetic">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python datetime Module - Date Objects, Formatting, Timedelta, Parsing">
    <meta property="og:description" content="Master Python datetime: creating, formatting, and manipulating dates and times.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/modules-dates.jsp">
    <link rel="icon" type="image/svg+xml" href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

    <script>
        (function () {
            var theme = localStorage.getItem('tutorial-theme');
            if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                document.documentElement.setAttribute('data-theme', 'dark');
            }
        })();
    </script>

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Python datetime Module",
        "description": "Master Python datetime module - create date objects, format dates with strftime, perform date arithmetic with timedelta, and parse date strings.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["datetime objects", "date and time components", "strftime formatting", "strptime parsing", "timedelta arithmetic", "date differences", "timezone basics"],
        "timeRequired": "PT25M",
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

<body class="tutorial-body no-preview" data-lesson="modules-dates">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>Dates</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Working with Dates and Times</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">The <code>datetime</code> module is Python's Swiss Army knife for dates and times.
                    Whether you're calculating deadlines, formatting timestamps for display, parsing date strings from
                    user input, or finding the difference between two dates - this module has you covered. It's essential
                    for scheduling, logging, data analysis, and virtually any application that deals with time!</p>

                    <!-- Section 1: datetime Objects -->
                    <h2>Creating and Using datetime Objects</h2>
                    <p>The <code>datetime</code> module provides several classes: <code>date</code> for dates only,
                    <code>time</code> for times only, and <code>datetime</code> for both combined. You can create
                    objects representing the current moment or specific dates, then access individual components
                    like year, month, day, hour, and more.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dates-datetime-objects.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-objects" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>datetime vs date vs time:</strong> Use <code>date</code> when you only need the date
                        (no time component), <code>time</code> for time without a date, and <code>datetime</code> when
                        you need both. The <code>datetime.now()</code> method includes microseconds, while
                        <code>date.today()</code> gives you just the date.
                    </div>

                    <!-- Section 2: Formatting -->
                    <h2>Formatting Dates with strftime()</h2>
                    <p>The <code>strftime()</code> method (string format time) converts datetime objects into
                    human-readable strings using format codes. Each code starts with <code>%</code> and represents
                    a date/time component. This is essential for displaying dates in your application or generating
                    formatted output for users.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dates-formatting.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-formatting" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Common Format Patterns:</strong><br>
                        <code>%Y-%m-%d</code> - ISO format (2024-03-15)<br>
                        <code>%m/%d/%Y</code> - US format (03/15/2024)<br>
                        <code>%d/%m/%Y</code> - UK/EU format (15/03/2024)<br>
                        <code>%B %d, %Y</code> - Full date (March 15, 2024)<br>
                        <code>%I:%M %p</code> - 12-hour time (03:30 PM)
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: timedelta -->
                    <h2>Date Arithmetic with timedelta</h2>
                    <p>The <code>timedelta</code> class represents a duration - the difference between two dates or
                    times. You can add or subtract timedeltas from dates to calculate future or past dates, find the
                    difference between two dates, or measure elapsed time. This is crucial for scheduling, expiration
                    dates, and age calculations.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dates-timedelta.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-timedelta" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>timedelta Limitations:</strong> <code>timedelta</code> only supports days, seconds,
                        microseconds, milliseconds, minutes, hours, and weeks. It doesn't have months or years because
                        they're not fixed durations (months have 28-31 days, years have 365-366). For month/year
                        arithmetic, use the <code>dateutil</code> library or manually calculate using <code>replace()</code>.
                    </div>

                    <!-- Section 4: Parsing -->
                    <h2>Parsing Date Strings with strptime()</h2>
                    <p>The <code>strptime()</code> method (string parse time) does the opposite of strftime - it
                    converts a string into a datetime object. This is essential when reading dates from files,
                    APIs, or user input. The format string must match the input string's structure exactly.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/dates-parsing.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-parsing" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing strftime and strptime</h4>
                        <pre><code class="language-python"># strftime = format datetime TO string
# strptime = parse string TO datetime

from datetime import datetime

now = datetime.now()

# Wrong - strptime expects a string, not datetime!
result = datetime.strptime(now, "%Y-%m-%d")  # TypeError!

# Correct usage:
formatted = now.strftime("%Y-%m-%d")  # datetime -> string
parsed = datetime.strptime("2024-03-15", "%Y-%m-%d")  # string -> datetime</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Format string doesn't match input</h4>
                        <pre><code class="language-python">from datetime import datetime

# Wrong - format doesn't match string!
date_str = "15/03/2024"
parsed = datetime.strptime(date_str, "%Y-%m-%d")  # ValueError!

# The string is DD/MM/YYYY, not YYYY-MM-DD
# Correct:
parsed = datetime.strptime(date_str, "%d/%m/%Y")

# Common mistake: US vs UK format
us_date = "03/15/2024"  # MM/DD/YYYY
uk_date = "15/03/2024"  # DD/MM/YYYY
# These need different format strings!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Comparing dates with timezones</h4>
                        <pre><code class="language-python">from datetime import datetime, timezone

# Naive datetime (no timezone)
naive = datetime.now()

# Aware datetime (has timezone)
aware = datetime.now(timezone.utc)

# Wrong - can't compare naive and aware!
if naive > aware:  # TypeError!
    print("naive is later")

# Fix: Make both naive or both aware
naive_utc = datetime.utcnow()  # Both naive
aware_utc = datetime.now(timezone.utc)  # Keep both aware</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Calculating months/years with timedelta</h4>
                        <pre><code class="language-python">from datetime import datetime, timedelta

now = datetime.now()

# Wrong - timedelta doesn't have months!
# one_month = timedelta(months=1)  # TypeError!

# Approximation (not always accurate)
one_month_approx = timedelta(days=30)

# Better - use replace() for month arithmetic
def add_months(dt, months):
    month = dt.month + months
    year = dt.year + (month - 1) // 12
    month = (month - 1) % 12 + 1
    day = min(dt.day, [31,28,31,30,31,30,31,31,30,31,30,31][month-1])
    return dt.replace(year=year, month=month, day=day)

# Or use dateutil library
# from dateutil.relativedelta import relativedelta
# next_month = now + relativedelta(months=1)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Forgetting to import the right class</h4>
                        <pre><code class="language-python"># Wrong - datetime module vs datetime class confusion
import datetime

# This is verbose
now = datetime.datetime.now()
today = datetime.date.today()
delta = datetime.timedelta(days=1)

# Better - import specific classes
from datetime import datetime, date, timedelta

now = datetime.now()
today = date.today()
delta = timedelta(days=1)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Age Calculator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create an age calculator that works with birthdays.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Parse a birthday string in format "YYYY-MM-DD"</li>
                            <li>Calculate the person's age in years</li>
                            <li>Determine how many days until their next birthday</li>
                            <li>Display the next birthday date formatted as "Month Day, Year"</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-modules-dates.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-dates" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">from datetime import datetime, date

def calculate_age(birthday_str):
    """Calculate age and days until next birthday."""
    # Parse the birthday
    birthday = datetime.strptime(birthday_str, "%Y-%m-%d").date()
    today = date.today()

    # Calculate age
    age = today.year - birthday.year
    # Adjust if birthday hasn't occurred this year
    if (today.month, today.day) < (birthday.month, birthday.day):
        age -= 1

    # Calculate next birthday
    next_birthday = birthday.replace(year=today.year)
    if next_birthday < today:
        next_birthday = birthday.replace(year=today.year + 1)

    days_until = (next_birthday - today).days

    # Format the next birthday
    next_bday_formatted = next_birthday.strftime("%B %d, %Y")

    return age, days_until, next_bday_formatted

# Test it
birthday = "1990-06-15"
age, days_until, next_bday = calculate_age(birthday)
print(f"Birthday: {birthday}")
print(f"Age: {age} years")
print(f"Days until next birthday: {days_until}")
print(f"Next birthday: {next_bday}")</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>datetime classes:</strong> <code>date</code>, <code>time</code>, <code>datetime</code>, <code>timedelta</code></li>
                            <li><strong>Current time:</strong> <code>datetime.now()</code>, <code>date.today()</code></li>
                            <li><strong>Components:</strong> Access <code>.year</code>, <code>.month</code>, <code>.day</code>, <code>.hour</code>, etc.</li>
                            <li><strong>strftime():</strong> Format datetime to string - <code>now.strftime("%Y-%m-%d")</code></li>
                            <li><strong>strptime():</strong> Parse string to datetime - <code>datetime.strptime(str, format)</code></li>
                            <li><strong>timedelta:</strong> Duration for date arithmetic - <code>timedelta(days=7)</code></li>
                            <li><strong>Date math:</strong> <code>tomorrow = today + timedelta(days=1)</code></li>
                            <li><strong>Date difference:</strong> <code>(date2 - date1).days</code> gives days between</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can work with dates, let's explore Python's <strong>math module</strong> for
                    mathematical operations beyond basic arithmetic - including trigonometry, logarithms, factorials,
                    and more advanced calculations!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="modules.jsp" />
                    <jsp:param name="prevTitle" value="Modules" />
                    <jsp:param name="nextLink" value="modules-math.jsp" />
                    <jsp:param name="nextTitle" value="Math" />
                    <jsp:param name="currentLessonId" value="modules-dates" />
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

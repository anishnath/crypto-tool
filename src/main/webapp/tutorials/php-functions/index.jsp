<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "index" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Functions Reference - Run & Test PHP Functions Online | 8gwifi.org</title>
            <meta name="description"
                content="Interactive PHP functions reference. Browse, learn, and execute 50+ PHP functions online. String, array, math, date, JSON functions with live examples.">
            <meta name="keywords"
                content="php functions, php function reference, php string functions, php array functions, run php online, php examples, php documentation">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php-functions/">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebPage",
        "name": "PHP Functions Reference",
        "description": "Interactive PHP functions reference with live examples. Browse and execute PHP functions online.",
        "url": "https://8gwifi.org/tutorials/php-functions/",
        "isPartOf": {
            "@type": "WebSite",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "mainEntity": {
            "@type": "SoftwareSourceCode",
            "programmingLanguage": "PHP",
            "codeRepository": "https://8gwifi.org/tutorials/php-functions/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>

                    <style>
                        .functions-search {
                            position: relative;
                            margin-bottom: var(--space-6);
                        }

                        .functions-search input {
                            width: 100%;
                            padding: var(--space-3) var(--space-4);
                            padding-left: 44px;
                            font-size: var(--text-base);
                            border: 1px solid var(--border);
                            border-radius: var(--radius-lg);
                            background: var(--bg-primary);
                            color: var(--text-primary);
                            transition: border-color 0.2s, box-shadow 0.2s;
                        }

                        .functions-search input:focus {
                            outline: none;
                            border-color: var(--accent-primary);
                            box-shadow: 0 0 0 3px var(--accent-light);
                        }

                        .functions-search svg {
                            position: absolute;
                            left: 14px;
                            top: 50%;
                            transform: translateY(-50%);
                            color: var(--text-muted);
                        }

                        .category-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                            gap: var(--space-4);
                            margin-bottom: var(--space-8);
                        }

                        .category-card {
                            background: var(--bg-primary);
                            border: 1px solid var(--border);
                            border-radius: var(--radius-lg);
                            padding: var(--space-5);
                            transition: border-color 0.2s, box-shadow 0.2s;
                        }

                        .category-card:hover {
                            border-color: var(--accent-primary);
                            box-shadow: var(--shadow-md);
                        }

                        .category-header {
                            display: flex;
                            align-items: center;
                            gap: var(--space-3);
                            margin-bottom: var(--space-4);
                        }

                        .category-icon {
                            width: 40px;
                            height: 40px;
                            border-radius: var(--radius-md);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 20px;
                        }

                        .category-icon.strings {
                            background: #dbeafe;
                        }

                        .category-icon.arrays {
                            background: #dcfce7;
                        }

                        .category-icon.math {
                            background: #fef3c7;
                        }

                        .category-icon.date {
                            background: #fce7f3;
                        }

                        .category-icon.json {
                            background: #e0e7ff;
                        }

                        .category-icon.file {
                            background: #f3e8ff;
                        }

                        .category-icon.variable {
                            background: #ccfbf1;
                        }

                        .category-icon.hash {
                            background: #fee2e2;
                        }

                        .category-icon.password {
                            background: #fef9c3;
                        }

                        .category-icon.regex {
                            background: #d1fae5;
                        }

                        .category-icon.url {
                            background: #e0f2fe;
                        }

                        .category-icon.network {
                            background: #fef3c7;
                        }

                        .category-icon.calendar {
                            background: #ffedd5;
                        }

                        .category-icon.general {
                            background: #f1f5f9;
                        }

                        [data-theme="dark"] .category-icon.strings {
                            background: #1e3a5f;
                        }

                        [data-theme="dark"] .category-icon.arrays {
                            background: #14532d;
                        }

                        [data-theme="dark"] .category-icon.math {
                            background: #713f12;
                        }

                        [data-theme="dark"] .category-icon.date {
                            background: #831843;
                        }

                        [data-theme="dark"] .category-icon.json {
                            background: #312e81;
                        }

                        [data-theme="dark"] .category-icon.file {
                            background: #581c87;
                        }

                        [data-theme="dark"] .category-icon.variable {
                            background: #134e4a;
                        }

                        [data-theme="dark"] .category-icon.hash {
                            background: #7f1d1d;
                        }

                        [data-theme="dark"] .category-icon.password {
                            background: #713f12;
                        }

                        [data-theme="dark"] .category-icon.regex {
                            background: #064e3b;
                        }

                        [data-theme="dark"] .category-icon.url {
                            background: #0c4a6e;
                        }

                        [data-theme="dark"] .category-icon.network {
                            background: #78350f;
                        }

                        [data-theme="dark"] .category-icon.calendar {
                            background: #431407;
                        }

                        [data-theme="dark"] .category-icon.general {
                            background: #0f172a;
                        }

                        .category-title {
                            font-size: var(--text-lg);
                            font-weight: 600;
                            color: var(--text-primary);
                        }

                        .category-count {
                            font-size: var(--text-sm);
                            color: var(--text-muted);
                        }

                        .function-list {
                            display: flex;
                            flex-wrap: wrap;
                            gap: var(--space-2);
                        }

                        .function-chip {
                            display: inline-block;
                            padding: var(--space-1) var(--space-3);
                            font-size: var(--text-sm);
                            font-family: var(--font-mono);
                            background: var(--bg-secondary);
                            border: 1px solid var(--border);
                            border-radius: var(--radius-full);
                            color: var(--text-secondary);
                            text-decoration: none;
                            transition: all 0.15s;
                        }

                        .function-chip:hover {
                            background: var(--accent-light);
                            border-color: var(--accent-primary);
                            color: var(--accent-primary);
                        }

                        .all-functions {
                            margin-top: var(--space-8);
                        }

                        .all-functions h2 {
                            margin-bottom: var(--space-4);
                        }

                        .function-table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        .function-table th,
                        .function-table td {
                            padding: var(--space-3) var(--space-4);
                            text-align: left;
                            border-bottom: 1px solid var(--border);
                        }

                        .function-table th {
                            background: var(--bg-secondary);
                            font-weight: 600;
                            font-size: var(--text-sm);
                            color: var(--text-secondary);
                            text-transform: uppercase;
                            letter-spacing: 0.05em;
                        }

                        .function-table tr:hover {
                            background: var(--bg-secondary);
                        }

                        .function-table .func-name {
                            font-family: var(--font-mono);
                            font-weight: 500;
                        }

                        .function-table .func-name a {
                            color: var(--accent-primary);
                            text-decoration: none;
                        }

                        .function-table .func-name a:hover {
                            text-decoration: underline;
                        }

                        .function-table .func-desc {
                            color: var(--text-secondary);
                            font-size: var(--text-sm);
                        }

                        .function-table .func-category {
                            font-size: var(--text-xs);
                            padding: 2px 8px;
                            border-radius: var(--radius-full);
                            background: var(--bg-tertiary);
                            color: var(--text-muted);
                        }

                        .hidden {
                            display: none !important;
                        }
                    </style>
        </head>

        <body class="tutorial-body no-preview" data-lesson="php-functions-index">
            <div class="tutorial-layout has-ad-rail">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-php-functions.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/php/">PHP</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Functions Reference</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Functions Reference</h1>
                                    <p
                                        style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 600px;">
                                        Interactive reference for PHP's most useful built-in functions. Browse by
                                        category, search, and run live examples.
                                    </p>
                                </header>

                                <div class="lesson-body">
                                    <!-- Search -->
                                    <div class="functions-search">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <circle cx="11" cy="11" r="8" />
                                            <path d="m21 21-4.35-4.35" />
                                        </svg>
                                        <input type="text" id="functionSearch"
                                            placeholder="Search functions (e.g., strlen, array_map, date...)">
                                    </div>

                                    <!-- Categories Grid -->
                                    <div class="category-grid">
                                        <!-- String Functions -->
                                        <div class="category-card" data-category="strings">
                                            <div class="category-header">
                                                <div class="category-icon strings">Aa</div>
                                                <div>
                                                    <div class="category-title">String Functions</div>
                                                    <div class="category-count">10 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="strlen.jsp" class="function-chip">strlen()</a>
                                                <a href="str_replace.jsp" class="function-chip">str_replace()</a>
                                                <a href="substr.jsp" class="function-chip">substr()</a>
                                                <a href="strpos.jsp" class="function-chip">strpos()</a>
                                                <a href="explode.jsp" class="function-chip">explode()</a>
                                                <a href="implode.jsp" class="function-chip">implode()</a>
                                                <a href="trim.jsp" class="function-chip">trim()</a>
                                                <a href="strtolower.jsp" class="function-chip">strtolower()</a>
                                                <a href="strtoupper.jsp" class="function-chip">strtoupper()</a>
                                                <a href="sprintf.jsp" class="function-chip">sprintf()</a>
                                            </div>
                                        </div>

                                        <!-- Multibyte String Functions -->
                                        <div class="category-card" data-category="mbstrings">
                                            <div class="category-header">
                                                <div class="category-icon strings">UTF</div>
                                                <div>
                                                    <div class="category-title">Multibyte String Functions</div>
                                                    <div class="category-count">10 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="mb_strlen.jsp" class="function-chip">mb_strlen()</a>
                                                <a href="mb_substr.jsp" class="function-chip">mb_substr()</a>
                                                <a href="mb_strtolower.jsp" class="function-chip">mb_strtolower()</a>
                                                <a href="mb_strtoupper.jsp" class="function-chip">mb_strtoupper()</a>
                                                <a href="mb_strpos.jsp" class="function-chip">mb_strpos()</a>
                                                <a href="mb_convert_encoding.jsp"
                                                    class="function-chip">mb_convert_encoding()</a>
                                                <a href="mb_detect_encoding.jsp"
                                                    class="function-chip">mb_detect_encoding()</a>
                                                <a href="mb_str_split.jsp" class="function-chip">mb_str_split()</a>
                                                <a href="mb_internal_encoding.jsp"
                                                    class="function-chip">mb_internal_encoding()</a>
                                                <a href="mb_check_encoding.jsp"
                                                    class="function-chip">mb_check_encoding()</a>
                                            </div>
                                        </div>

                                        <!-- Array Functions -->
                                        <div class="category-card" data-category="arrays">
                                            <div class="category-header">
                                                <div class="category-icon arrays">[]</div>
                                                <div>
                                                    <div class="category-title">Array Functions</div>
                                                    <div class="category-count">29 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="array_map.jsp" class="function-chip">array_map()</a>
                                                <a href="array_filter.jsp" class="function-chip">array_filter()</a>
                                                <a href="array_merge.jsp" class="function-chip">array_merge()</a>
                                                <a href="array_push.jsp" class="function-chip">array_push()</a>
                                                <a href="array_pop.jsp" class="function-chip">array_pop()</a>
                                                <a href="array_search.jsp" class="function-chip">array_search()</a>
                                                <a href="in_array.jsp" class="function-chip">in_array()</a>
                                                <a href="array_keys.jsp" class="function-chip">array_keys()</a>
                                                <a href="array_values.jsp" class="function-chip">array_values()</a>
                                                <a href="sort.jsp" class="function-chip">sort()</a>
                                                <a href="array_splice.jsp" class="function-chip">array_splice()</a>
                                                <a href="count.jsp" class="function-chip">count()</a>
                                                <a href="krsort.jsp" class="function-chip">krsort()</a>
                                                <a href="ksort.jsp" class="function-chip">ksort()</a>
                                                <a href="natcasesort.jsp" class="function-chip">natcasesort()</a>
                                                <a href="natsort.jsp" class="function-chip">natsort()</a>
                                                <a href="range.jsp" class="function-chip">range()</a>
                                                <a href="rsort.jsp" class="function-chip">rsort()</a>
                                                <a href="shuffle.jsp" class="function-chip">shuffle()</a>
                                                <a href="array_shift.jsp" class="function-chip">array_shift()</a>
                                                <a href="array_unshift.jsp" class="function-chip">array_unshift()</a>
                                                <a href="array_slice.jsp" class="function-chip">array_slice()</a>
                                                <a href="array_chunk.jsp" class="function-chip">array_chunk()</a>
                                                <a href="array_unique.jsp" class="function-chip">array_unique()</a>
                                                <a href="array_reverse.jsp" class="function-chip">array_reverse()</a>
                                                <a href="array_column.jsp" class="function-chip">array_column()</a>
                                                <a href="array_combine.jsp" class="function-chip">array_combine()</a>
                                                <a href="array_diff.jsp" class="function-chip">array_diff()</a>
                                                <a href="array_intersect.jsp"
                                                    class="function-chip">array_intersect()</a>
                                            </div>
                                        </div>

                                        <!-- Math Functions -->
                                        <div class="category-card" data-category="math">
                                            <div class="category-header">
                                                <div class="category-icon math">+-</div>
                                                <div>
                                                    <div class="category-title">Math Functions</div>
                                                    <div class="category-count">7 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="round.jsp" class="function-chip">round()</a>
                                                <a href="floor.jsp" class="function-chip">floor()</a>
                                                <a href="ceil.jsp" class="function-chip">ceil()</a>
                                                <a href="abs.jsp" class="function-chip">abs()</a>
                                                <a href="rand.jsp" class="function-chip">rand()</a>
                                                <a href="max.jsp" class="function-chip">max()</a>
                                                <a href="min.jsp" class="function-chip">min()</a>
                                            </div>
                                        </div>

                                        <!-- Date/Time Functions -->
                                        <div class="category-card" data-category="date">
                                            <div class="category-header">
                                                <div class="category-icon date">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <path d="M12 6v6l4 2" />
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="category-title">Date/Time Functions</div>
                                                    <div class="category-count">16 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="checkdate.jsp" class="function-chip">checkdate()</a>
                                                <a href="date.jsp" class="function-chip">date()</a>
                                                <a href="getdate.jsp" class="function-chip">getdate()</a>
                                                <a href="gettimeofday.jsp" class="function-chip">gettimeofday()</a>
                                                <a href="gmdate.jsp" class="function-chip">gmdate()</a>
                                                <a href="gmmktime.jsp" class="function-chip">gmmktime()</a>
                                                <a href="gmstrftime.jsp" class="function-chip">gmstrftime()</a>
                                                <a href="hrtime.jsp" class="function-chip">hrtime()</a>
                                                <a href="idate.jsp" class="function-chip">idate()</a>
                                                <a href="localtime.jsp" class="function-chip">localtime()</a>
                                                <a href="microtime.jsp" class="function-chip">microtime()</a>
                                                <a href="mktime.jsp" class="function-chip">mktime()</a>
                                                <a href="strftime.jsp" class="function-chip">strftime()</a>
                                                <a href="strptime.jsp" class="function-chip">strptime()</a>
                                                <a href="strtotime.jsp" class="function-chip">strtotime()</a>
                                                <a href="time.jsp" class="function-chip">time()</a>
                                            </div>
                                        </div>

                                        <!-- Calendar Functions -->
                                        <div class="category-card" data-category="calendar">
                                            <div class="category-header">
                                                <div class="category-icon calendar">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="category-title">Calendar Functions</div>
                                                    <div class="category-count">18 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="cal_days_in_month.jsp"
                                                    class="function-chip">cal_days_in_month()</a>
                                                <a href="cal_from_jd.jsp" class="function-chip">cal_from_jd()</a>
                                                <a href="cal_info.jsp" class="function-chip">cal_info()</a>
                                                <a href="cal_to_jd.jsp" class="function-chip">cal_to_jd()</a>
                                                <a href="easter_date.jsp" class="function-chip">easter_date()</a>
                                                <a href="easter_days.jsp" class="function-chip">easter_days()</a>
                                                <a href="frenchtojd.jsp" class="function-chip">frenchtojd()</a>
                                                <a href="gregoriantojd.jsp" class="function-chip">gregoriantojd()</a>
                                                <a href="jddayofweek.jsp" class="function-chip">jddayofweek()</a>
                                                <a href="jdmonthname.jsp" class="function-chip">jdmonthname()</a>
                                                <a href="jdtofrench.jsp" class="function-chip">jdtofrench()</a>
                                                <a href="jdtogregorian.jsp" class="function-chip">jdtogregorian()</a>
                                                <a href="jdtojewish.jsp" class="function-chip">jdtojewish()</a>
                                                <a href="jdtojulian.jsp" class="function-chip">jdtojulian()</a>
                                                <a href="jdtounix.jsp" class="function-chip">jdtounix()</a>
                                                <a href="jewishtojd.jsp" class="function-chip">jewishtojd()</a>
                                                <a href="juliantojd.jsp" class="function-chip">juliantojd()</a>
                                                <a href="unixtojd.jsp" class="function-chip">unixtojd()</a>
                                            </div>
                                        </div>

                                        <!-- JSON Functions -->
                                        <div class="category-card" data-category="json">
                                            <div class="category-header">
                                                <div class="category-icon json">{}</div>
                                                <div>
                                                    <div class="category-title">JSON Functions</div>
                                                    <div class="category-count">2 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="json_encode.jsp" class="function-chip">json_encode()</a>
                                                <a href="json_decode.jsp" class="function-chip">json_decode()</a>
                                            </div>
                                        </div>

                                        <!-- File Functions -->
                                        <div class="category-card" data-category="file">
                                            <div class="category-header">
                                                <div class="category-icon file">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                                        <polyline points="14 2 14 8 20 8" />
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="category-title">File Functions</div>
                                                    <div class="category-count">3 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="file_get_contents.jsp"
                                                    class="function-chip">file_get_contents()</a>
                                                <a href="file_put_contents.jsp"
                                                    class="function-chip">file_put_contents()</a>
                                                <a href="file_exists.jsp" class="function-chip">file_exists()</a>
                                            </div>
                                        </div>

                                        <!-- Variable Functions -->
                                        <div class="category-card" data-category="variable">
                                            <div class="category-header">
                                                <div class="category-icon variable">$</div>
                                                <div>
                                                    <div class="category-title">Variable Functions</div>
                                                    <div class="category-count">5 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="isset.jsp" class="function-chip">isset()</a>
                                                <a href="empty.jsp" class="function-chip">empty()</a>
                                                <a href="var_dump.jsp" class="function-chip">var_dump()</a>
                                                <a href="print_r.jsp" class="function-chip">print_r()</a>
                                                <a href="gettype.jsp" class="function-chip">gettype()</a>
                                            </div>
                                        </div>

                                        <!-- Hash/Crypto Functions -->
                                        <div class="category-card" data-category="hash">
                                            <div class="category-header">
                                                <div class="category-icon hash">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                                                        <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="category-title">Hash/Crypto Functions</div>
                                                    <div class="category-count">9 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="hash.jsp" class="function-chip">hash()</a>
                                                <a href="hash_algos.jsp" class="function-chip">hash_algos()</a>
                                                <a href="hash_equals.jsp" class="function-chip">hash_equals()</a>
                                                <a href="hash_hkdf.jsp" class="function-chip">hash_hkdf()</a>
                                                <a href="hash_hmac.jsp" class="function-chip">hash_hmac()</a>
                                                <a href="hash_hmac_algos.jsp"
                                                    class="function-chip">hash_hmac_algos()</a>
                                                <a href="hash_pbkdf2.jsp" class="function-chip">hash_pbkdf2()</a>
                                                <a href="random_bytes.jsp" class="function-chip">random_bytes()</a>
                                                <a href="random_int.jsp" class="function-chip">random_int()</a>
                                            </div>
                                        </div>

                                        <!-- Password Hashing Functions -->
                                        <div class="category-card" data-category="password">
                                            <div class="category-header">
                                                <div class="category-icon password">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M12 2a5 5 0 0 1 5 5v3H7V7a5 5 0 0 1 5-5z" />
                                                        <rect x="3" y="10" width="18" height="12" rx="2" />
                                                        <circle cx="12" cy="16" r="1" />
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="category-title">Password Hashing</div>
                                                    <div class="category-count">5 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="password_hash.jsp" class="function-chip">password_hash()</a>
                                                <a href="password_verify.jsp"
                                                    class="function-chip">password_verify()</a>
                                                <a href="password_algos.jsp" class="function-chip">password_algos()</a>
                                                <a href="password_get_info.jsp"
                                                    class="function-chip">password_get_info()</a>
                                                <a href="password_needs_rehash.jsp"
                                                    class="function-chip">password_needs_rehash()</a>
                                            </div>
                                        </div>

                                        <!-- Regular Expressions -->
                                        <div class="category-card" data-category="regex">
                                            <div class="category-header">
                                                <div class="category-icon regex">.*</div>
                                                <div>
                                                    <div class="category-title">Regular Expressions</div>
                                                    <div class="category-count">8 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="preg_match.jsp" class="function-chip">preg_match()</a>
                                                <a href="preg_match_all.jsp" class="function-chip">preg_match_all()</a>
                                                <a href="preg_replace.jsp" class="function-chip">preg_replace()</a>
                                                <a href="preg_replace_callback.jsp"
                                                    class="function-chip">preg_replace_callback()</a>
                                                <a href="preg_split.jsp" class="function-chip">preg_split()</a>
                                                <a href="preg_grep.jsp" class="function-chip">preg_grep()</a>
                                                <a href="preg_filter.jsp" class="function-chip">preg_filter()</a>
                                                <a href="preg_quote.jsp" class="function-chip">preg_quote()</a>
                                            </div>
                                        </div>

                                        <!-- URL Functions -->
                                        <div class="category-card" data-category="url">
                                            <div class="category-header">
                                                <div class="category-icon url">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path
                                                            d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
                                                        <path
                                                            d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="category-title">URL Functions</div>
                                                    <div class="category-count">9 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="urlencode.jsp" class="function-chip">urlencode()</a>
                                                <a href="urldecode.jsp" class="function-chip">urldecode()</a>
                                                <a href="rawurlencode.jsp" class="function-chip">rawurlencode()</a>
                                                <a href="rawurldecode.jsp" class="function-chip">rawurldecode()</a>
                                                <a href="base64_encode.jsp" class="function-chip">base64_encode()</a>
                                                <a href="base64_decode.jsp" class="function-chip">base64_decode()</a>
                                                <a href="parse_url.jsp" class="function-chip">parse_url()</a>
                                                <a href="http_build_query.jsp"
                                                    class="function-chip">http_build_query()</a>
                                                <a href="get_meta_tags.jsp" class="function-chip">get_meta_tags()</a>
                                            </div>
                                        </div>

                                        <!-- Network Functions -->
                                        <div class="category-card" data-category="network">
                                            <div class="category-header">
                                                <div class="category-icon network">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="10" />
                                                        <line x1="2" y1="12" x2="22" y2="12" />
                                                        <path
                                                            d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="category-title">Network Functions</div>
                                                    <div class="category-count">8 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="gethostbyaddr.jsp" class="function-chip">gethostbyaddr()</a>
                                                <a href="gethostbyname.jsp" class="function-chip">gethostbyname()</a>
                                                <a href="gethostbynamel.jsp" class="function-chip">gethostbynamel()</a>
                                                <a href="getmxrr.jsp" class="function-chip">getmxrr()</a>
                                                <a href="getservbyname.jsp" class="function-chip">getservbyname()</a>
                                                <a href="getservbyport.jsp" class="function-chip">getservbyport()</a>
                                                <a href="ip2long.jsp" class="function-chip">ip2long()</a>
                                                <a href="long2ip.jsp" class="function-chip">long2ip()</a>
                                            </div>
                                        </div>

                                        <!-- General Functions -->
                                        <div class="category-card" data-category="general">
                                            <div class="category-header">
                                                <div class="category-icon general">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <circle cx="12" cy="12" r="3"></circle>
                                                        <path
                                                            d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z">
                                                        </path>
                                                    </svg>
                                                </div>
                                                <div>
                                                    <div class="category-title">General Functions</div>
                                                    <div class="category-count">9 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="hex2bin.jsp" class="function-chip">hex2bin()</a>
                                                <a href="pack.jsp" class="function-chip">pack()</a>
                                                <a href="serialize.jsp" class="function-chip">serialize()</a>
                                                <a href="token_name.jsp" class="function-chip">token_name()</a>
                                                <a href="uniqid.jsp" class="function-chip">uniqid()</a>
                                                <a href="unpack.jsp" class="function-chip">unpack()</a>
                                                <a href="unserialize.jsp" class="function-chip">unserialize()</a>
                                                <a href="zlib_decode.jsp" class="function-chip">zlib_decode()</a>
                                                <a href="zlib_encode.jsp" class="function-chip">zlib_encode()</a>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- All Functions Table -->
                                    <div class="all-functions">
                                        <h2>All Functions</h2>
                                        <table class="function-table" id="functionTable">
                                            <thead>
                                                <tr>
                                                    <th>Function</th>
                                                    <th>Description</th>
                                                    <th>Category</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- String Functions -->
                                                <tr data-func="strlen" data-cat="strings">
                                                    <td class="func-name"><a href="strlen.jsp">strlen()</a></td>
                                                    <td class="func-desc">Returns the length of a string</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="str_replace" data-cat="strings">
                                                    <td class="func-name"><a href="str_replace.jsp">str_replace()</a>
                                                    </td>
                                                    <td class="func-desc">Replace all occurrences of search string with
                                                        replacement</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="substr" data-cat="strings">
                                                    <td class="func-name"><a href="substr.jsp">substr()</a></td>
                                                    <td class="func-desc">Return part of a string</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="strpos" data-cat="strings">
                                                    <td class="func-name"><a href="strpos.jsp">strpos()</a></td>
                                                    <td class="func-desc">Find the position of the first occurrence of a
                                                        substring</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="explode" data-cat="strings">
                                                    <td class="func-name"><a href="explode.jsp">explode()</a></td>
                                                    <td class="func-desc">Split a string by a delimiter into an array
                                                    </td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="implode" data-cat="strings">
                                                    <td class="func-name"><a href="implode.jsp">implode()</a></td>
                                                    <td class="func-desc">Join array elements into a string</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="trim" data-cat="strings">
                                                    <td class="func-name"><a href="trim.jsp">trim()</a></td>
                                                    <td class="func-desc">Strip whitespace from beginning and end of a
                                                        string</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="strtolower" data-cat="strings">
                                                    <td class="func-name"><a href="strtolower.jsp">strtolower()</a></td>
                                                    <td class="func-desc">Convert a string to lowercase</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="strtoupper" data-cat="strings">
                                                    <td class="func-name"><a href="strtoupper.jsp">strtoupper()</a></td>
                                                    <td class="func-desc">Convert a string to uppercase</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <tr data-func="sprintf" data-cat="strings">
                                                    <td class="func-name"><a href="sprintf.jsp">sprintf()</a></td>
                                                    <td class="func-desc">Return a formatted string</td>
                                                    <td><span class="func-category">String</span></td>
                                                </tr>
                                                <!-- Array Functions -->
                                                <tr data-func="array_map" data-cat="arrays">
                                                    <td class="func-name"><a href="array_map.jsp">array_map()</a></td>
                                                    <td class="func-desc">Apply a callback function to each element of
                                                        an array</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="array_filter" data-cat="arrays">
                                                    <td class="func-name"><a href="array_filter.jsp">array_filter()</a>
                                                    </td>
                                                    <td class="func-desc">Filter elements of an array using a callback
                                                        function</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="array_merge" data-cat="arrays">
                                                    <td class="func-name"><a href="array_merge.jsp">array_merge()</a>
                                                    </td>
                                                    <td class="func-desc">Merge one or more arrays</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="array_push" data-cat="arrays">
                                                    <td class="func-name"><a href="array_push.jsp">array_push()</a></td>
                                                    <td class="func-desc">Push one or more elements onto the end of
                                                        array</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="array_pop" data-cat="arrays">
                                                    <td class="func-name"><a href="array_pop.jsp">array_pop()</a></td>
                                                    <td class="func-desc">Pop the element off the end of array</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="array_search" data-cat="arrays">
                                                    <td class="func-name"><a href="array_search.jsp">array_search()</a>
                                                    </td>
                                                    <td class="func-desc">Search array for a value and return its key
                                                    </td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="in_array" data-cat="arrays">
                                                    <td class="func-name"><a href="in_array.jsp">in_array()</a></td>
                                                    <td class="func-desc">Check if a value exists in an array</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="array_keys" data-cat="arrays">
                                                    <td class="func-name"><a href="array_keys.jsp">array_keys()</a></td>
                                                    <td class="func-desc">Return all keys of an array</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="array_values" data-cat="arrays">
                                                    <td class="func-name"><a href="array_values.jsp">array_values()</a>
                                                    </td>
                                                    <td class="func-desc">Return all values of an array</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <tr data-func="sort" data-cat="arrays">
                                                    <td class="func-name"><a href="sort.jsp">sort()</a>, <a
                                                            href="array_splice.jsp">array_splice()</a>, <a
                                                            href="count.jsp">count()</a>, <a
                                                            href="krsort.jsp">krsort()</a>, <a
                                                            href="ksort.jsp">ksort()</a>, <a
                                                            href="natcasesort.jsp">natcasesort()</a>, <a
                                                            href="natsort.jsp">natsort()</a>, <a
                                                            href="range.jsp">range()</a>, <a
                                                            href="rsort.jsp">rsort()</a>, <a
                                                            href="shuffle.jsp">shuffle()</a></td>
                                                    <td class="func-desc">Sort an array in ascending order</td>
                                                    <td><span class="func-category">Array</span></td>
                                                </tr>
                                                <!-- Math Functions -->
                                                <tr data-func="round" data-cat="math">
                                                    <td class="func-name"><a href="round.jsp">round()</a></td>
                                                    <td class="func-desc">Round a float to the nearest integer</td>
                                                    <td><span class="func-category">Math</span></td>
                                                </tr>
                                                <tr data-func="floor" data-cat="math">
                                                    <td class="func-name"><a href="floor.jsp">floor()</a></td>
                                                    <td class="func-desc">Round a number down to the nearest integer
                                                    </td>
                                                    <td><span class="func-category">Math</span></td>
                                                </tr>
                                                <tr data-func="ceil" data-cat="math">
                                                    <td class="func-name"><a href="ceil.jsp">ceil()</a></td>
                                                    <td class="func-desc">Round a number up to the nearest integer</td>
                                                    <td><span class="func-category">Math</span></td>
                                                </tr>
                                                <tr data-func="abs" data-cat="math">
                                                    <td class="func-name"><a href="abs.jsp">abs()</a></td>
                                                    <td class="func-desc">Return the absolute value of a number</td>
                                                    <td><span class="func-category">Math</span></td>
                                                </tr>
                                                <tr data-func="rand" data-cat="math">
                                                    <td class="func-name"><a href="rand.jsp">rand()</a></td>
                                                    <td class="func-desc">Generate a random integer</td>
                                                    <td><span class="func-category">Math</span></td>
                                                </tr>
                                                <tr data-func="max" data-cat="math">
                                                    <td class="func-name"><a href="max.jsp">max()</a></td>
                                                    <td class="func-desc">Find the highest value</td>
                                                    <td><span class="func-category">Math</span></td>
                                                </tr>
                                                <tr data-func="min" data-cat="math">
                                                    <td class="func-name"><a href="min.jsp">min()</a></td>
                                                    <td class="func-desc">Find the lowest value</td>
                                                    <td><span class="func-category">Math</span></td>
                                                </tr>
                                                <!-- Date Functions -->
                                                <tr data-func="date" data-cat="date">
                                                    <td class="func-name"><a href="date.jsp">date()</a></td>
                                                    <td class="func-desc">Format a local date/time</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="time" data-cat="date">
                                                    <td class="func-name"><a href="time.jsp">time()</a></td>
                                                    <td class="func-desc">Return current Unix timestamp</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="strtotime" data-cat="date">
                                                    <td class="func-name"><a href="strtotime.jsp">strtotime()</a></td>
                                                    <td class="func-desc">Parse English textual datetime to Unix
                                                        timestamp</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="mktime" data-cat="date">
                                                    <td class="func-name"><a href="mktime.jsp">mktime()</a></td>
                                                    <td class="func-desc">Get Unix timestamp for a date</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="checkdate" data-cat="date">
                                                    <td class="func-name"><a href="checkdate.jsp">checkdate()</a></td>
                                                    <td class="func-desc">Validate a Gregorian date</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="getdate" data-cat="date">
                                                    <td class="func-name"><a href="getdate.jsp">getdate()</a></td>
                                                    <td class="func-desc">Get date/time information</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="gettimeofday" data-cat="date">
                                                    <td class="func-name"><a href="gettimeofday.jsp">gettimeofday()</a>
                                                    </td>
                                                    <td class="func-desc">Get current time</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="gmdate" data-cat="date">
                                                    <td class="func-name"><a href="gmdate.jsp">gmdate()</a></td>
                                                    <td class="func-desc">Format a GMT/UTC date/time</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="gmmktime" data-cat="date">
                                                    <td class="func-name"><a href="gmmktime.jsp">gmmktime()</a></td>
                                                    <td class="func-desc">Get Unix timestamp for a GMT date</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="gmstrftime" data-cat="date">
                                                    <td class="func-name"><a href="gmstrftime.jsp">gmstrftime()</a></td>
                                                    <td class="func-desc">Format a GMT/UTC time/date according to locale
                                                        settings</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="hrtime" data-cat="date">
                                                    <td class="func-name"><a href="hrtime.jsp">hrtime()</a></td>
                                                    <td class="func-desc">Get high resolution time</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="idate" data-cat="date">
                                                    <td class="func-name"><a href="idate.jsp">idate()</a></td>
                                                    <td class="func-desc">Format a local time/date as integer</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="localtime" data-cat="date">
                                                    <td class="func-name"><a href="localtime.jsp">localtime()</a></td>
                                                    <td class="func-desc">Get the local time</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="microtime" data-cat="date">
                                                    <td class="func-name"><a href="microtime.jsp">microtime()</a></td>
                                                    <td class="func-desc">Return current Unix timestamp with
                                                        microseconds</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="strftime" data-cat="date">
                                                    <td class="func-name"><a href="strftime.jsp">strftime()</a></td>
                                                    <td class="func-desc">Format a local time/date according to locale
                                                        settings</td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>
                                                <tr data-func="strptime" data-cat="date">
                                                    <td class="func-name"><a href="strptime.jsp">strptime()</a></td>
                                                    <td class="func-desc">Parse a time/date generated with strftime()
                                                    </td>
                                                    <td><span class="func-category">Date</span></td>
                                                </tr>

                                                <!-- Calendar Functions -->
                                                <tr data-func="cal_days_in_month" data-cat="calendar">
                                                    <td class="func-name"><a
                                                            href="cal_days_in_month.jsp">cal_days_in_month()</a></td>
                                                    <td class="func-desc">Return number of days in a month for a given
                                                        year and calendar</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="cal_from_jd" data-cat="calendar">
                                                    <td class="func-name"><a href="cal_from_jd.jsp">cal_from_jd()</a>
                                                    </td>
                                                    <td class="func-desc">Converts from Julian Day Count to a supported
                                                        calendar</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="cal_info" data-cat="calendar">
                                                    <td class="func-name"><a href="cal_info.jsp">cal_info()</a></td>
                                                    <td class="func-desc">Returns information about a particular
                                                        calendar</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="cal_to_jd" data-cat="calendar">
                                                    <td class="func-name"><a href="cal_to_jd.jsp">cal_to_jd()</a></td>
                                                    <td class="func-desc">Converts from a supported calendar to Julian
                                                        Day Count</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="easter_date" data-cat="calendar">
                                                    <td class="func-name"><a href="easter_date.jsp">easter_date()</a>
                                                    </td>
                                                    <td class="func-desc">Get Unix timestamp for midnight on Easter of a
                                                        given year</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="easter_days" data-cat="calendar">
                                                    <td class="func-name"><a href="easter_days.jsp">easter_days()</a>
                                                    </td>
                                                    <td class="func-desc">Get number of days after March 21 on which
                                                        Easter falls for a given year</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="frenchtojd" data-cat="calendar">
                                                    <td class="func-name"><a href="frenchtojd.jsp">frenchtojd()</a></td>
                                                    <td class="func-desc">Converts a date from the French Republican
                                                        Calendar to a Julian Day Count</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="gregoriantojd" data-cat="calendar">
                                                    <td class="func-name"><a
                                                            href="gregoriantojd.jsp">gregoriantojd()</a></td>
                                                    <td class="func-desc">Converts a Gregorian date to Julian Day Count
                                                    </td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="jddayofweek" data-cat="calendar">
                                                    <td class="func-name"><a href="jddayofweek.jsp">jddayofweek()</a>
                                                    </td>
                                                    <td class="func-desc">Returns the day of the week</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="jdmonthname" data-cat="calendar">
                                                    <td class="func-name"><a href="jdmonthname.jsp">jdmonthname()</a>
                                                    </td>
                                                    <td class="func-desc">Returns a month name</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="jdtofrench" data-cat="calendar">
                                                    <td class="func-name"><a href="jdtofrench.jsp">jdtofrench()</a></td>
                                                    <td class="func-desc">Converts a Julian Day Count to the French
                                                        Republican Calendar</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="jdtogregorian" data-cat="calendar">
                                                    <td class="func-name"><a
                                                            href="jdtogregorian.jsp">jdtogregorian()</a></td>
                                                    <td class="func-desc">Converts Julian Day Count to Gregorian date
                                                    </td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="jdtojewish" data-cat="calendar">
                                                    <td class="func-name"><a href="jdtojewish.jsp">jdtojewish()</a></td>
                                                    <td class="func-desc">Converts a Julian day count to a Jewish
                                                        calendar date</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="jdtojulian" data-cat="calendar">
                                                    <td class="func-name"><a href="jdtojulian.jsp">jdtojulian()</a></td>
                                                    <td class="func-desc">Converts a Julian Day Count to a Julian
                                                        Calendar Date</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="jdtounix" data-cat="calendar">
                                                    <td class="func-name"><a href="jdtounix.jsp">jdtounix()</a></td>
                                                    <td class="func-desc">Convert Julian Day to Unix timestamp</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="jewishtojd" data-cat="calendar">
                                                    <td class="func-name"><a href="jewishtojd.jsp">jewishtojd()</a></td>
                                                    <td class="func-desc">Converts a date in the Jewish Calendar to
                                                        Julian Day Count</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="juliantojd" data-cat="calendar">
                                                    <td class="func-name"><a href="juliantojd.jsp">juliantojd()</a></td>
                                                    <td class="func-desc">Converts a Julian Calendar date to Julian Day
                                                        Count</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <tr data-func="unixtojd" data-cat="calendar">
                                                    <td class="func-name"><a href="unixtojd.jsp">unixtojd()</a></td>
                                                    <td class="func-desc">Convert Unix timestamp to Julian Day</td>
                                                    <td><span class="func-category">Calendar</span></td>
                                                </tr>
                                                <!-- JSON Functions -->
                                                <tr data-func="json_encode" data-cat="json">
                                                    <td class="func-name"><a href="json_encode.jsp">json_encode()</a>
                                                    </td>
                                                    <td class="func-desc">Convert a value to JSON</td>
                                                    <td><span class="func-category">JSON</span></td>
                                                </tr>
                                                <tr data-func="json_decode" data-cat="json">
                                                    <td class="func-name"><a href="json_decode.jsp">json_decode()</a>
                                                    </td>
                                                    <td class="func-desc">Decode a JSON string</td>
                                                    <td><span class="func-category">JSON</span></td>
                                                </tr>
                                                <!-- File Functions -->
                                                <tr data-func="file_get_contents" data-cat="file">
                                                    <td class="func-name"><a
                                                            href="file_get_contents.jsp">file_get_contents()</a></td>
                                                    <td class="func-desc">Read entire file into a string</td>
                                                    <td><span class="func-category">File</span></td>
                                                </tr>
                                                <tr data-func="file_put_contents" data-cat="file">
                                                    <td class="func-name"><a
                                                            href="file_put_contents.jsp">file_put_contents()</a></td>
                                                    <td class="func-desc">Write data to a file</td>
                                                    <td><span class="func-category">File</span></td>
                                                </tr>
                                                <tr data-func="file_exists" data-cat="file">
                                                    <td class="func-name"><a href="file_exists.jsp">file_exists()</a>
                                                    </td>
                                                    <td class="func-desc">Check whether a file or directory exists</td>
                                                    <td><span class="func-category">File</span></td>
                                                </tr>
                                                <!-- Variable Functions -->
                                                <tr data-func="isset" data-cat="variable">
                                                    <td class="func-name"><a href="isset.jsp">isset()</a></td>
                                                    <td class="func-desc">Determine if a variable is set and is not null
                                                    </td>
                                                    <td><span class="func-category">Variable</span></td>
                                                </tr>
                                                <tr data-func="empty" data-cat="variable">
                                                    <td class="func-name"><a href="empty.jsp">empty()</a></td>
                                                    <td class="func-desc">Determine whether a variable is empty</td>
                                                    <td><span class="func-category">Variable</span></td>
                                                </tr>
                                                <tr data-func="var_dump" data-cat="variable">
                                                    <td class="func-name"><a href="var_dump.jsp">var_dump()</a></td>
                                                    <td class="func-desc">Dump information about a variable</td>
                                                    <td><span class="func-category">Variable</span></td>
                                                </tr>
                                                <tr data-func="print_r" data-cat="variable">
                                                    <td class="func-name"><a href="print_r.jsp">print_r()</a></td>
                                                    <td class="func-desc">Print human-readable info about a variable
                                                    </td>
                                                    <td><span class="func-category">Variable</span></td>
                                                </tr>
                                                <tr data-func="gettype" data-cat="variable">
                                                    <td class="func-name"><a href="gettype.jsp">gettype()</a></td>
                                                    <td class="func-desc">Get the type of a variable</td>
                                                    <td><span class="func-category">Variable</span></td>
                                                </tr>
                                                <!-- Hash/Crypto Functions -->
                                                <tr data-func="hash" data-cat="hash">
                                                    <td class="func-name"><a href="hash.jsp">hash()</a></td>
                                                    <td class="func-desc">Generate a hash value (message digest)</td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <tr data-func="hash_algos" data-cat="hash">
                                                    <td class="func-name"><a href="hash_algos.jsp">hash_algos()</a></td>
                                                    <td class="func-desc">Return a list of registered hashing algorithms
                                                    </td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <tr data-func="hash_equals" data-cat="hash">
                                                    <td class="func-name"><a href="hash_equals.jsp">hash_equals()</a>
                                                    </td>
                                                    <td class="func-desc">Timing attack safe string comparison</td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <tr data-func="hash_hkdf" data-cat="hash">
                                                    <td class="func-name"><a href="hash_hkdf.jsp">hash_hkdf()</a></td>
                                                    <td class="func-desc">Generate a HKDF key derivation</td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <tr data-func="hash_hmac" data-cat="hash">
                                                    <td class="func-name"><a href="hash_hmac.jsp">hash_hmac()</a></td>
                                                    <td class="func-desc">Generate a keyed hash value using HMAC</td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <tr data-func="hash_hmac_algos" data-cat="hash">
                                                    <td class="func-name"><a
                                                            href="hash_hmac_algos.jsp">hash_hmac_algos()</a></td>
                                                    <td class="func-desc">Return algorithms suitable for hash_hmac</td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <tr data-func="hash_pbkdf2" data-cat="hash">
                                                    <td class="func-name"><a href="hash_pbkdf2.jsp">hash_pbkdf2()</a>
                                                    </td>
                                                    <td class="func-desc">Generate a PBKDF2 key derivation</td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <tr data-func="random_bytes" data-cat="hash">
                                                    <td class="func-name"><a href="random_bytes.jsp">random_bytes()</a>
                                                    </td>
                                                    <td class="func-desc">Generate cryptographically secure random bytes
                                                    </td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <tr data-func="random_int" data-cat="hash">
                                                    <td class="func-name"><a href="random_int.jsp">random_int()</a></td>
                                                    <td class="func-desc">Generate cryptographically secure random
                                                        integers</td>
                                                    <td><span class="func-category">Hash</span></td>
                                                </tr>
                                                <!-- Password Hashing Functions -->
                                                <tr data-func="password_hash" data-cat="password">
                                                    <td class="func-name"><a
                                                            href="password_hash.jsp">password_hash()</a></td>
                                                    <td class="func-desc">Creates a password hash</td>
                                                    <td><span class="func-category">Password</span></td>
                                                </tr>
                                                <tr data-func="password_verify" data-cat="password">
                                                    <td class="func-name"><a
                                                            href="password_verify.jsp">password_verify()</a></td>
                                                    <td class="func-desc">Verifies that a password matches a hash</td>
                                                    <td><span class="func-category">Password</span></td>
                                                </tr>
                                                <tr data-func="password_algos" data-cat="password">
                                                    <td class="func-name"><a
                                                            href="password_algos.jsp">password_algos()</a></td>
                                                    <td class="func-desc">Get available password hashing algorithm IDs
                                                    </td>
                                                    <td><span class="func-category">Password</span></td>
                                                </tr>
                                                <tr data-func="password_get_info" data-cat="password">
                                                    <td class="func-name"><a
                                                            href="password_get_info.jsp">password_get_info()</a></td>
                                                    <td class="func-desc">Returns information about the given hash</td>
                                                    <td><span class="func-category">Password</span></td>
                                                </tr>
                                                <tr data-func="password_needs_rehash" data-cat="password">
                                                    <td class="func-name"><a
                                                            href="password_needs_rehash.jsp">password_needs_rehash()</a>
                                                    </td>
                                                    <td class="func-desc">Checks if the hash matches the given options
                                                    </td>
                                                    <td><span class="func-category">Password</span></td>
                                                </tr>
                                                <!-- Regular Expressions -->
                                                <tr data-func="preg_match" data-cat="regex">
                                                    <td class="func-name"><a href="preg_match.jsp">preg_match()</a></td>
                                                    <td class="func-desc">Perform a regular expression match</td>
                                                    <td><span class="func-category">Regex</span></td>
                                                </tr>
                                                <tr data-func="preg_match_all" data-cat="regex">
                                                    <td class="func-name"><a
                                                            href="preg_match_all.jsp">preg_match_all()</a></td>
                                                    <td class="func-desc">Perform a global regular expression match</td>
                                                    <td><span class="func-category">Regex</span></td>
                                                </tr>
                                                <tr data-func="preg_replace" data-cat="regex">
                                                    <td class="func-name"><a href="preg_replace.jsp">preg_replace()</a>
                                                    </td>
                                                    <td class="func-desc">Perform a regex search and replace</td>
                                                    <td><span class="func-category">Regex</span></td>
                                                </tr>
                                                <tr data-func="preg_replace_callback" data-cat="regex">
                                                    <td class="func-name"><a
                                                            href="preg_replace_callback.jsp">preg_replace_callback()</a>
                                                    </td>
                                                    <td class="func-desc">Regex search and replace using a callback</td>
                                                    <td><span class="func-category">Regex</span></td>
                                                </tr>
                                                <tr data-func="preg_split" data-cat="regex">
                                                    <td class="func-name"><a href="preg_split.jsp">preg_split()</a></td>
                                                    <td class="func-desc">Split string by a regular expression</td>
                                                    <td><span class="func-category">Regex</span></td>
                                                </tr>
                                                <tr data-func="preg_grep" data-cat="regex">
                                                    <td class="func-name"><a href="preg_grep.jsp">preg_grep()</a></td>
                                                    <td class="func-desc">Return array entries that match the pattern
                                                    </td>
                                                    <td><span class="func-category">Regex</span></td>
                                                </tr>
                                                <tr data-func="preg_filter" data-cat="regex">
                                                    <td class="func-name"><a href="preg_filter.jsp">preg_filter()</a>
                                                    </td>
                                                    <td class="func-desc">Perform regex search and replace, return
                                                        matches</td>
                                                    <td><span class="func-category">Regex</span></td>
                                                </tr>
                                                <tr data-func="preg_quote" data-cat="regex">
                                                    <td class="func-name"><a href="preg_quote.jsp">preg_quote()</a></td>
                                                    <td class="func-desc">Quote regular expression characters</td>
                                                    <td><span class="func-category">Regex</span></td>
                                                </tr>
                                                <!-- URL Functions -->
                                                <tr data-func="urlencode" data-cat="url">
                                                    <td class="func-name"><a href="urlencode.jsp">urlencode()</a></td>
                                                    <td class="func-desc">URL-encodes string</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <tr data-func="urldecode" data-cat="url">
                                                    <td class="func-name"><a href="urldecode.jsp">urldecode()</a></td>
                                                    <td class="func-desc">Decodes URL-encoded string</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <tr data-func="rawurlencode" data-cat="url">
                                                    <td class="func-name"><a href="rawurlencode.jsp">rawurlencode()</a>
                                                    </td>
                                                    <td class="func-desc">URL-encode according to RFC 3986</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <tr data-func="rawurldecode" data-cat="url">
                                                    <td class="func-name"><a href="rawurldecode.jsp">rawurldecode()</a>
                                                    </td>
                                                    <td class="func-desc">Decode URL-encoded strings</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <tr data-func="base64_encode" data-cat="url">
                                                    <td class="func-name"><a
                                                            href="base64_encode.jsp">base64_encode()</a></td>
                                                    <td class="func-desc">Encodes data with MIME base64</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <tr data-func="base64_decode" data-cat="url">
                                                    <td class="func-name"><a
                                                            href="base64_decode.jsp">base64_decode()</a></td>
                                                    <td class="func-desc">Decodes data encoded with MIME base64</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <tr data-func="parse_url" data-cat="url">
                                                    <td class="func-name"><a href="parse_url.jsp">parse_url()</a></td>
                                                    <td class="func-desc">Parse a URL and return its components</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <tr data-func="http_build_query" data-cat="url">
                                                    <td class="func-name"><a
                                                            href="http_build_query.jsp">http_build_query()</a></td>
                                                    <td class="func-desc">Generate URL-encoded query string</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <tr data-func="get_meta_tags" data-cat="url">
                                                    <td class="func-name"><a
                                                            href="get_meta_tags.jsp">get_meta_tags()</a></td>
                                                    <td class="func-desc">Extracts all meta tag content attributes</td>
                                                    <td><span class="func-category">URL</span></td>
                                                </tr>
                                                <!-- Network Functions -->
                                                <tr data-func="gethostbyaddr" data-cat="network">
                                                    <td class="func-name"><a
                                                            href="gethostbyaddr.jsp">gethostbyaddr()</a></td>
                                                    <td class="func-desc">Get hostname from IP address (reverse DNS)
                                                    </td>
                                                    <td><span class="func-category">Network</span></td>
                                                </tr>
                                                <tr data-func="gethostbyname" data-cat="network">
                                                    <td class="func-name"><a
                                                            href="gethostbyname.jsp">gethostbyname()</a></td>
                                                    <td class="func-desc">Get IPv4 address from hostname (DNS lookup)
                                                    </td>
                                                    <td><span class="func-category">Network</span></td>
                                                </tr>
                                                <tr data-func="gethostbynamel" data-cat="network">
                                                    <td class="func-name"><a
                                                            href="gethostbynamel.jsp">gethostbynamel()</a></td>
                                                    <td class="func-desc">Get list of IPv4 addresses for a hostname</td>
                                                    <td><span class="func-category">Network</span></td>
                                                </tr>
                                                <tr data-func="getmxrr" data-cat="network">
                                                    <td class="func-name"><a href="getmxrr.jsp">getmxrr()</a></td>
                                                    <td class="func-desc">Get MX records for a domain</td>
                                                    <td><span class="func-category">Network</span></td>
                                                </tr>
                                                <tr data-func="getservbyname" data-cat="network">
                                                    <td class="func-name"><a
                                                            href="getservbyname.jsp">getservbyname()</a></td>
                                                    <td class="func-desc">Get port number for a service name</td>
                                                    <td><span class="func-category">Network</span></td>
                                                </tr>
                                                <tr data-func="getservbyport" data-cat="network">
                                                    <td class="func-name"><a
                                                            href="getservbyport.jsp">getservbyport()</a></td>
                                                    <td class="func-desc">Get service name for a port number</td>
                                                    <td><span class="func-category">Network</span></td>
                                                </tr>
                                                <tr data-func="ip2long" data-cat="network">
                                                    <td class="func-name"><a href="ip2long.jsp">ip2long()</a></td>
                                                    <td class="func-desc">Convert IPv4 address to integer</td>
                                                    <td><span class="func-category">Network</span></td>
                                                </tr>
                                                <tr data-func="long2ip" data-cat="network">
                                                    <td class="func-name"><a href="long2ip.jsp">long2ip()</a></td>
                                                    <td class="func-desc">Convert integer to IPv4 address</td>
                                                    <td><span class="func-category">Network</span></td>
                                                </tr>

                                                <!-- General Functions -->
                                                <tr data-func="hex2bin" data-cat="general">
                                                    <td class="func-name"><a href="hex2bin.jsp">hex2bin()</a></td>
                                                    <td class="func-desc">Decodes a hexadecimally encoded binary string
                                                    </td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                                <tr data-func="pack" data-cat="general">
                                                    <td class="func-name"><a href="pack.jsp">pack()</a></td>
                                                    <td class="func-desc">Pack data into binary string</td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                                <tr data-func="serialize" data-cat="general">
                                                    <td class="func-name"><a href="serialize.jsp">serialize()</a></td>
                                                    <td class="func-desc">Generates a storable representation of a value
                                                    </td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                                <tr data-func="token_name" data-cat="general">
                                                    <td class="func-name"><a href="token_name.jsp">token_name()</a></td>
                                                    <td class="func-desc">Get the symbolic name of a given PHP token
                                                    </td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                                <tr data-func="uniqid" data-cat="general">
                                                    <td class="func-name"><a href="uniqid.jsp">uniqid()</a></td>
                                                    <td class="func-desc">Generate a unique ID</td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                                <tr data-func="unpack" data-cat="general">
                                                    <td class="func-name"><a href="unpack.jsp">unpack()</a></td>
                                                    <td class="func-desc">Unpack data from binary string</td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                                <tr data-func="unserialize" data-cat="general">
                                                    <td class="func-name"><a href="unserialize.jsp">unserialize()</a>
                                                    </td>
                                                    <td class="func-desc">Creates a PHP value from a stored
                                                        representation</td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                                <tr data-func="zlib_decode" data-cat="general">
                                                    <td class="func-name"><a href="zlib_decode.jsp">zlib_decode()</a>
                                                    </td>
                                                    <td class="func-desc">Uncompress any raw/gzip/zlib encoded data</td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                                <tr data-func="zlib_encode" data-cat="general">
                                                    <td class="func-name"><a href="zlib_encode.jsp">zlib_encode()</a>
                                                    </td>
                                                    <td class="func-desc">Compress data with the specified encoding</td>
                                                    <td><span class="func-category">General</span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </article>

                            <%-- Right Ad Rail (desktop only) --%>
                                <%@ include file="../tutorial-ad-rail.jsp" %>
                    </main>
                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
            <script>
                // Search functionality
                document.getElementById('functionSearch').addEventListener('input', function (e) {
                    const query = e.target.value.toLowerCase().trim();
                    const rows = document.querySelectorAll('#functionTable tbody tr');
                    const cards = document.querySelectorAll('.category-card');
                    const chips = document.querySelectorAll('.function-chip');

                    // Filter table rows
                    rows.forEach(row => {
                        const funcName = row.dataset.func || '';
                        const text = row.textContent.toLowerCase();
                        row.classList.toggle('hidden', query && !funcName.includes(query) && !text.includes(query));
                    });

                    // Filter chips in category cards
                    chips.forEach(chip => {
                        const funcName = chip.textContent.toLowerCase();
                        chip.classList.toggle('hidden', query && !funcName.includes(query));
                    });

                    // Hide empty category cards
                    cards.forEach(card => {
                        const visibleChips = card.querySelectorAll('.function-chip:not(.hidden)');
                        card.classList.toggle('hidden', query && visibleChips.length === 0);
                    });
                });
            </script>
        </body>

        </html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentFunction", "index" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Python Functions Reference - 124+ Functions | 8gwifi.org</title>
            <meta name="description"
                content="Complete Python functions reference with 124+ functions across 21 categories. Interactive examples for strings, lists, dicts, crypto, networking, collections, and more.">
            <meta name="keywords"
                content="python functions, python reference, python standard library, python crypto, python networking, python collections, itertools, hashlib, secrets">
            <link rel="canonical" href="https://8gwifi.org/tutorials/python-functions/">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebPage",
        "name": "Python Functions Reference - 124+ Functions",
        "description": "Complete interactive Python standard library reference with live examples across 21 categories.",
        "url": "https://8gwifi.org/tutorials/python-functions/",
        "isPartOf": {
            "@type": "WebSite",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "mainEntity": {
            "@type": "SoftwareSourceCode",
            "programmingLanguage": "Python",
            "codeRepository": "https://8gwifi.org/tutorials/python-functions/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>

                    <style>
                        .hero-stats {
                            display: flex;
                            gap: var(--space-6);
                            margin: var(--space-6) 0;
                            flex-wrap: wrap;
                        }

                        .stat-card {
                            flex: 1;
                            min-width: 150px;
                            padding: var(--space-4);
                            background: linear-gradient(135deg, var(--accent-primary) 0%, var(--accent-secondary) 100%);
                            border-radius: var(--radius-lg);
                            color: white;
                            text-align: center;
                        }

                        .stat-number {
                            font-size: 2.5rem;
                            font-weight: 700;
                            line-height: 1;
                        }

                        .stat-label {
                            font-size: var(--text-sm);
                            opacity: 0.9;
                            margin-top: var(--space-2);
                        }

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
                            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                            gap: var(--space-4);
                            margin-bottom: var(--space-8);
                        }

                        .category-card {
                            background: var(--bg-primary);
                            border: 1px solid var(--border);
                            border-radius: var(--radius-lg);
                            padding: var(--space-5);
                            transition: all 0.2s;
                        }

                        .category-card:hover {
                            border-color: var(--accent-primary);
                            box-shadow: var(--shadow-lg);
                            transform: translateY(-2px);
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
                            font-size: 18px;
                            font-weight: 600;
                        }

                        .category-icon.builtin {
                            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
                            color: #78350f;
                        }

                        .category-icon.conversion {
                            background: linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%);
                            color: #1e3a8a;
                        }

                        .category-icon.strings {
                            background: linear-gradient(135deg, #34d399 0%, #10b981 100%);
                            color: #064e3b;
                        }

                        .category-icon.lists {
                            background: linear-gradient(135deg, #a78bfa 0%, #8b5cf6 100%);
                            color: #4c1d95;
                        }

                        .category-icon.dicts {
                            background: linear-gradient(135deg, #f472b6 0%, #ec4899 100%);
                            color: #831843;
                        }

                        .category-icon.sets {
                            background: linear-gradient(135deg, #2dd4bf 0%, #14b8a6 100%);
                            color: #134e4a;
                        }

                        .category-icon.crypto {
                            background: linear-gradient(135deg, #fb923c 0%, #f97316 100%);
                            color: #7c2d12;
                        }

                        .category-icon.network {
                            background: linear-gradient(135deg, #818cf8 0%, #6366f1 100%);
                            color: #312e81;
                        }

                        .category-icon.advanced {
                            background: linear-gradient(135deg, #c084fc 0%, #a855f7 100%);
                            color: #581c87;
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
                            padding: 4px 10px;
                            font-size: var(--text-xs);
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
                            transform: scale(1.05);
                        }

                        .hidden {
                            display: none !important;
                        }
                    </style>
        </head>

        <body class="tutorial-body no-preview" data-lesson="python-functions-index">
            <div class="tutorial-layout has-ad-rail">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-python-functions.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Functions Reference</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Python Standard Library Reference</h1>
                                    <p
                                        style="font-size: var(--text-lg); color: var(--text-secondary); max-width: 700px; margin-top: var(--space-3);">
                                        Complete interactive reference for Python's standard library. Browse 124+
                                        functions across 21 categories with live, runnable examples.
                                    </p>
                                </header>

                                <!-- Stats -->
                                <div class="hero-stats">
                                    <div class="stat-card">
                                        <div class="stat-number">124+</div>
                                        <div class="stat-label">Functions</div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-number">21</div>
                                        <div class="stat-label">Categories</div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-number">100%</div>
                                        <div class="stat-label">Standard Library</div>
                                    </div>
                                </div>

                                <div class="lesson-body">
                                    <!-- Search -->
                                    <div class="functions-search">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <circle cx="11" cy="11" r="8" />
                                            <path d="m21 21-4.35-4.35" />
                                        </svg>
                                        <input type="text" id="functionSearch"
                                            placeholder="Search 124+ functions (e.g., len, split, Counter, urlparse...)">
                                    </div>

                                    <!-- Categories Grid -->
                                    <div class="category-grid">
                                        <!-- Built-in Functions -->
                                        <div class="category-card" data-category="builtin">
                                            <div class="category-header">
                                                <div class="category-icon builtin">⚡</div>
                                                <div>
                                                    <div class="category-title">Built-in Functions</div>
                                                    <div class="category-count">9 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="print.jsp" class="function-chip">print()</a>
                                                <a href="len.jsp" class="function-chip">len()</a>
                                                <a href="type.jsp" class="function-chip">type()</a>
                                                <a href="isinstance.jsp" class="function-chip">isinstance()</a>
                                                <a href="range.jsp" class="function-chip">range()</a>
                                                <a href="enumerate.jsp" class="function-chip">enumerate()</a>
                                                <a href="zip.jsp" class="function-chip">zip()</a>
                                                <a href="map.jsp" class="function-chip">map()</a>
                                                <a href="filter.jsp" class="function-chip">filter()</a>
                                            </div>
                                        </div>

                                        <!-- Type Conversion -->
                                        <div class="category-card" data-category="conversion">
                                            <div class="category-header">
                                                <div class="category-icon conversion">🔄</div>
                                                <div>
                                                    <div class="category-title">Type Conversion</div>
                                                    <div class="category-count">6 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="int.jsp" class="function-chip">int()</a>
                                                <a href="float.jsp" class="function-chip">float()</a>
                                                <a href="str.jsp" class="function-chip">str()</a>
                                                <a href="bool.jsp" class="function-chip">bool()</a>
                                                <a href="list.jsp" class="function-chip">list()</a>
                                                <a href="dict.jsp" class="function-chip">dict()</a>
                                            </div>
                                        </div>

                                        <!-- String Methods -->
                                        <div class="category-card" data-category="strings">
                                            <div class="category-header">
                                                <div class="category-icon strings">Aa</div>
                                                <div>
                                                    <div class="category-title">String Methods</div>
                                                    <div class="category-count">15+ methods</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="str_split.jsp" class="function-chip">split()</a>
                                                <a href="str_join.jsp" class="function-chip">join()</a>
                                                <a href="str_strip.jsp" class="function-chip">strip()</a>
                                                <a href="str_replace.jsp" class="function-chip">replace()</a>
                                                <a href="str_find.jsp" class="function-chip">find()</a>
                                                <a href="str_upper.jsp" class="function-chip">upper()</a>
                                                <a href="str_lower.jsp" class="function-chip">lower()</a>
                                                <a href="str_format.jsp" class="function-chip">format()</a>
                                                <a href="str_startswith.jsp" class="function-chip">startswith()</a>
                                                <a href="str_endswith.jsp" class="function-chip">endswith()</a>
                                            </div>
                                        </div>

                                        <!-- List Methods -->
                                        <div class="category-card" data-category="lists">
                                            <div class="category-header">
                                                <div class="category-icon lists">[]</div>
                                                <div>
                                                    <div class="category-title">List Methods</div>
                                                    <div class="category-count">11 methods</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="list_append.jsp" class="function-chip">append()</a>
                                                <a href="list_extend.jsp" class="function-chip">extend()</a>
                                                <a href="list_insert.jsp" class="function-chip">insert()</a>
                                                <a href="list_remove.jsp" class="function-chip">remove()</a>
                                                <a href="list_pop.jsp" class="function-chip">pop()</a>
                                                <a href="list_index.jsp" class="function-chip">index()</a>
                                                <a href="list_count.jsp" class="function-chip">count()</a>
                                                <a href="list_sort.jsp" class="function-chip">sort()</a>
                                                <a href="list_reverse.jsp" class="function-chip">reverse()</a>
                                                <a href="list_copy.jsp" class="function-chip">copy()</a>
                                                <a href="list_clear.jsp" class="function-chip">clear()</a>
                                            </div>
                                        </div>

                                        <!-- Dictionary Methods -->
                                        <div class="category-card" data-category="dicts">
                                            <div class="category-header">
                                                <div class="category-icon dicts">{}</div>
                                                <div>
                                                    <div class="category-title">Dictionary Methods</div>
                                                    <div class="category-count">10 methods</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="dict_keys.jsp" class="function-chip">keys()</a>
                                                <a href="dict_values.jsp" class="function-chip">values()</a>
                                                <a href="dict_items.jsp" class="function-chip">items()</a>
                                                <a href="dict_get.jsp" class="function-chip">get()</a>
                                                <a href="dict_update.jsp" class="function-chip">update()</a>
                                                <a href="dict_pop.jsp" class="function-chip">pop()</a>
                                                <a href="dict_setdefault.jsp" class="function-chip">setdefault()</a>
                                                <a href="dict_clear.jsp" class="function-chip">clear()</a>
                                                <a href="dict_copy.jsp" class="function-chip">copy()</a>
                                                <a href="dict_fromkeys.jsp" class="function-chip">fromkeys()</a>
                                            </div>
                                        </div>

                                        <!-- Set Methods -->
                                        <div class="category-card" data-category="sets">
                                            <div class="category-header">
                                                <div class="category-icon sets">∪</div>
                                                <div>
                                                    <div class="category-title">Set Methods</div>
                                                    <div class="category-count">8 methods</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="set_add.jsp" class="function-chip">add()</a>
                                                <a href="set_remove.jsp" class="function-chip">remove()</a>
                                                <a href="set_discard.jsp" class="function-chip">discard()</a>
                                                <a href="set_union.jsp" class="function-chip">union()</a>
                                                <a href="set_intersection.jsp" class="function-chip">intersection()</a>
                                                <a href="set_difference.jsp" class="function-chip">difference()</a>
                                                <a href="set_update.jsp" class="function-chip">update()</a>
                                                <a href="set_clear.jsp" class="function-chip">clear()</a>
                                            </div>
                                        </div>

                                        <!-- Hashing & Crypto -->
                                        <div class="category-card" data-category="crypto">
                                            <div class="category-header">
                                                <div class="category-icon crypto">🔐</div>
                                                <div>
                                                    <div class="category-title">Hashing & Secrets</div>
                                                    <div class="category-count">7 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="hashlib_md5.jsp" class="function-chip">md5()</a>
                                                <a href="hashlib_sha1.jsp" class="function-chip">sha1()</a>
                                                <a href="hashlib_sha256.jsp" class="function-chip">sha256()</a>
                                                <a href="hashlib_sha512.jsp" class="function-chip">sha512()</a>
                                                <a href="secrets_token_hex.jsp" class="function-chip">token_hex()</a>
                                                <a href="secrets_token_urlsafe.jsp"
                                                    class="function-chip">token_urlsafe()</a>
                                                <a href="secrets_token_bytes.jsp"
                                                    class="function-chip">token_bytes()</a>
                                            </div>
                                        </div>

                                        <!-- Networking -->
                                        <div class="category-card" data-category="network">
                                            <div class="category-header">
                                                <div class="category-icon network">🌐</div>
                                                <div>
                                                    <div class="category-title">Networking</div>
                                                    <div class="category-count">7 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="urllib_parse_urlencode.jsp"
                                                    class="function-chip">urlencode()</a>
                                                <a href="urllib_parse_urlparse.jsp" class="function-chip">urlparse()</a>
                                                <a href="urllib_parse_quote.jsp" class="function-chip">quote()</a>
                                                <a href="urllib_parse_unquote.jsp" class="function-chip">unquote()</a>
                                                <a href="urllib_request_urlopen.jsp" class="function-chip">urlopen()</a>
                                                <a href="socket_gethostname.jsp" class="function-chip">gethostname()</a>
                                                <a href="socket_gethostbyname.jsp"
                                                    class="function-chip">gethostbyname()</a>
                                            </div>
                                        </div>

                                        <!-- Collections -->
                                        <div class="category-card" data-category="advanced">
                                            <div class="category-header">
                                                <div class="category-icon advanced">📦</div>
                                                <div>
                                                    <div class="category-title">Collections</div>
                                                    <div class="category-count">3 classes</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="collections_counter.jsp" class="function-chip">Counter()</a>
                                                <a href="collections_defaultdict.jsp"
                                                    class="function-chip">defaultdict()</a>
                                                <a href="collections_deque.jsp" class="function-chip">deque()</a>
                                            </div>
                                        </div>

                                        <!-- Itertools -->
                                        <div class="category-card" data-category="advanced">
                                            <div class="category-header">
                                                <div class="category-icon advanced">🔄</div>
                                                <div>
                                                    <div class="category-title">Itertools</div>
                                                    <div class="category-count">4 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="itertools_chain.jsp" class="function-chip">chain()</a>
                                                <a href="itertools_combinations.jsp"
                                                    class="function-chip">combinations()</a>
                                                <a href="itertools_permutations.jsp"
                                                    class="function-chip">permutations()</a>
                                                <a href="itertools_groupby.jsp" class="function-chip">groupby()</a>
                                            </div>
                                        </div>

                                        <!-- Regular Expressions -->
                                        <div class="category-card" data-category="strings">
                                            <div class="category-header">
                                                <div class="category-icon strings">.*</div>
                                                <div>
                                                    <div class="category-title">Regular Expressions</div>
                                                    <div class="category-count">5 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="re_match.jsp" class="function-chip">match()</a>
                                                <a href="re_search.jsp" class="function-chip">search()</a>
                                                <a href="re_findall.jsp" class="function-chip">findall()</a>
                                                <a href="re_sub.jsp" class="function-chip">sub()</a>
                                                <a href="re_split.jsp" class="function-chip">split()</a>
                                            </div>
                                        </div>

                                        <!-- Math Functions -->
                                        <div class="category-card" data-category="builtin">
                                            <div class="category-header">
                                                <div class="category-icon builtin">∑</div>
                                                <div>
                                                    <div class="category-title">Math Functions</div>
                                                    <div class="category-count">12 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="abs.jsp" class="function-chip">abs()</a>
                                                <a href="round.jsp" class="function-chip">round()</a>
                                                <a href="min.jsp" class="function-chip">min()</a>
                                                <a href="max.jsp" class="function-chip">max()</a>
                                                <a href="sum.jsp" class="function-chip">sum()</a>
                                                <a href="pow.jsp" class="function-chip">pow()</a>
                                                <a href="divmod.jsp" class="function-chip">divmod()</a>
                                                <a href="math_sqrt.jsp" class="function-chip">sqrt()</a>
                                                <a href="math_ceil.jsp" class="function-chip">ceil()</a>
                                                <a href="math_floor.jsp" class="function-chip">floor()</a>
                                                <a href="math_factorial.jsp" class="function-chip">factorial()</a>
                                                <a href="math_pi.jsp" class="function-chip">pi</a>
                                            </div>
                                        </div>

                                        <!-- Date & Time -->
                                        <div class="category-card" data-category="builtin">
                                            <div class="category-header">
                                                <div class="category-icon builtin">🕐</div>
                                                <div>
                                                    <div class="category-title">Date & Time</div>
                                                    <div class="category-count">6 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="datetime_now.jsp" class="function-chip">now()</a>
                                                <a href="datetime_date.jsp" class="function-chip">date()</a>
                                                <a href="datetime_strftime.jsp" class="function-chip">strftime()</a>
                                                <a href="datetime_strptime.jsp" class="function-chip">strptime()</a>
                                                <a href="time_time.jsp" class="function-chip">time()</a>
                                                <a href="time_sleep.jsp" class="function-chip">sleep()</a>
                                            </div>
                                        </div>

                                        <!-- File & OS -->
                                        <div class="category-card" data-category="builtin">
                                            <div class="category-header">
                                                <div class="category-icon builtin">📁</div>
                                                <div>
                                                    <div class="category-title">File & OS</div>
                                                    <div class="category-count">13 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="python_open.jsp" class="function-chip">open()</a>
                                                <a href="file_read.jsp" class="function-chip">read()</a>
                                                <a href="file_write.jsp" class="function-chip">write()</a>
                                                <a href="file_close.jsp" class="function-chip">close()</a>
                                                <a href="os_path_exists.jsp" class="function-chip">exists()</a>
                                                <a href="os_getcwd.jsp" class="function-chip">getcwd()</a>
                                                <a href="os_listdir.jsp" class="function-chip">listdir()</a>
                                                <a href="os_mkdir.jsp" class="function-chip">mkdir()</a>
                                                <a href="os_remove.jsp" class="function-chip">remove()</a>
                                            </div>
                                        </div>

                                        <!-- JSON & Encoding -->
                                        <div class="category-card" data-category="conversion">
                                            <div class="category-header">
                                                <div class="category-icon conversion">📝</div>
                                                <div>
                                                    <div class="category-title">JSON & Encoding</div>
                                                    <div class="category-count">4 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="json_loads.jsp" class="function-chip">loads()</a>
                                                <a href="json_dumps.jsp" class="function-chip">dumps()</a>
                                                <a href="base64_encode.jsp" class="function-chip">b64encode()</a>
                                                <a href="base64_decode.jsp" class="function-chip">b64decode()</a>
                                            </div>
                                        </div>

                                        <!-- Random -->
                                        <div class="category-card" data-category="builtin">
                                            <div class="category-header">
                                                <div class="category-icon builtin">🎲</div>
                                                <div>
                                                    <div class="category-title">Random</div>
                                                    <div class="category-count">4 functions</div>
                                                </div>
                                            </div>
                                            <div class="function-list">
                                                <a href="random_random.jsp" class="function-chip">random()</a>
                                                <a href="random_randint.jsp" class="function-chip">randint()</a>
                                                <a href="random_choice.jsp" class="function-chip">choice()</a>
                                                <a href="random_shuffle.jsp" class="function-chip">shuffle()</a>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Quick Links -->
                                    <div
                                        style="margin-top: var(--space-8); padding: var(--space-6); background: var(--bg-secondary); border-radius: var(--radius-lg);">
                                        <h2 style="margin-bottom: var(--space-4);">✨ What's Included</h2>
                                        <div
                                            style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: var(--space-4);">
                                            <div>
                                                <h3 style="font-size: var(--text-base); margin-bottom: var(--space-2);">
                                                    🎯 Core Python</h3>
                                                <p style="font-size: var(--text-sm); color: var(--text-secondary);">
                                                    Built-in functions, type conversion, and essential operations</p>
                                            </div>
                                            <div>
                                                <h3 style="font-size: var(--text-base); margin-bottom: var(--space-2);">
                                                    📊 Data Structures</h3>
                                                <p style="font-size: var(--text-sm); color: var(--text-secondary);">
                                                    Strings, lists, dicts, sets, tuples, collections</p>
                                            </div>
                                            <div>
                                                <h3 style="font-size: var(--text-base); margin-bottom: var(--space-2);">
                                                    🔐 Cryptography</h3>
                                                <p style="font-size: var(--text-sm); color: var(--text-secondary);">
                                                    Hashing (MD5, SHA), secrets, Base64 encoding</p>
                                            </div>
                                            <div>
                                                <h3 style="font-size: var(--text-base); margin-bottom: var(--space-2);">
                                                    🌐 Networking</h3>
                                                <p style="font-size: var(--text-sm); color: var(--text-secondary);">URL
                                                    parsing, HTTP requests, DNS lookups</p>
                                            </div>
                                            <div>
                                                <h3 style="font-size: var(--text-base); margin-bottom: var(--space-2);">
                                                    ⚡ Advanced</h3>
                                                <p style="font-size: var(--text-sm); color: var(--text-secondary);">
                                                    Collections, itertools, regex, file I/O</p>
                                            </div>
                                            <div>
                                                <h3 style="font-size: var(--text-base); margin-bottom: var(--space-2);">
                                                    🎲 Utilities</h3>
                                                <p style="font-size: var(--text-sm); color: var(--text-secondary);">
                                                    Math, random, date/time, JSON, OS operations</p>
                                            </div>
                                        </div>
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
                    const cards = document.querySelectorAll('.category-card');
                    const chips = document.querySelectorAll('.function-chip');

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
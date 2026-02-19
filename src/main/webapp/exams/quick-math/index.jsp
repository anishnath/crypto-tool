<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // High-CTR SEO Meta Tags
    String seoTitle = "150+ Mental Math Tricks — Multiply, Divide & Calculate Instantly";
    String seoDescription = "Free mental math shortcuts that actually work. Multiply 2-digit numbers in seconds, calculate percentages instantly, square any number ending in 5. Interactive practice with step-by-step breakdowns.";
    String canonicalUrl = "https://8gwifi.org/exams/quick-math/";

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);

    // Build extra head content with Open Graph, Twitter Cards, and JSON-LD
    StringBuilder extraHead = new StringBuilder();

    // Open Graph Tags
    extraHead.append("<meta property=\"og:title\" content=\"").append(seoTitle).append("\">\n");
    extraHead.append("<meta property=\"og:description\" content=\"").append(seoDescription).append("\">\n");
    extraHead.append("<meta property=\"og:url\" content=\"").append(canonicalUrl).append("\">\n");
    extraHead.append("<meta property=\"og:type\" content=\"website\">\n");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">\n");
    extraHead.append("<meta property=\"og:image\" content=\"https://8gwifi.org/images/quick-math-og.png\">\n");

    // Twitter Card Tags
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">\n");
    extraHead.append("<meta name=\"twitter:title\" content=\"").append(seoTitle).append("\">\n");
    extraHead.append("<meta name=\"twitter:description\" content=\"").append(seoDescription).append("\">\n");
    extraHead.append("<meta name=\"twitter:image\" content=\"https://8gwifi.org/images/quick-math-og.png\">\n");

    // Additional SEO Meta Tags
    extraHead.append("<meta name=\"keywords\" content=\"mental math tricks, speed math, fast calculation, math shortcuts, mental arithmetic, multiplication tricks, percentage shortcuts, mental calculation, math speed tricks, number sense, rapid math techniques\">\n");
    extraHead.append("<meta name=\"robots\" content=\"index, follow, max-snippet:-1, max-image-preview:large\">\n");

    // JSON-LD: WebPage Schema
    extraHead.append("<script type=\"application/ld+json\">\n");
    extraHead.append("{\n");
    extraHead.append("  \"@context\": \"https://schema.org\",\n");
    extraHead.append("  \"@type\": \"WebPage\",\n");
    extraHead.append("  \"@id\": \"").append(canonicalUrl).append("\",\n");
    extraHead.append("  \"name\": \"150+ Mental Math Tricks — Multiply, Divide & Calculate Instantly\",\n");
    extraHead.append("  \"description\": \"").append(seoDescription).append("\",\n");
    extraHead.append("  \"url\": \"").append(canonicalUrl).append("\",\n");
    extraHead.append("  \"inLanguage\": \"en\",\n");
    extraHead.append("  \"isPartOf\": {\n");
    extraHead.append("    \"@type\": \"WebSite\",\n");
    extraHead.append("    \"name\": \"8gwifi.org\",\n");
    extraHead.append("    \"url\": \"https://8gwifi.org\"\n");
    extraHead.append("  },\n");
    extraHead.append("  \"about\": {\n");
    extraHead.append("    \"@type\": \"Thing\",\n");
    extraHead.append("    \"name\": \"Mental Mathematics\"\n");
    extraHead.append("  },\n");
    extraHead.append("  \"mainEntity\": {\n");
    extraHead.append("    \"@type\": \"ItemList\",\n");
    extraHead.append("    \"name\": \"Mental Math Tricks & Shortcuts\",\n");
    extraHead.append("    \"description\": \"150+ mental math techniques for fast addition, multiplication, division, percentages, algebra, and more\",\n");
    extraHead.append("    \"numberOfItems\": 150,\n");
    extraHead.append("    \"itemListElement\": [\n");
    extraHead.append("      {\"@type\": \"ListItem\", \"position\": 1, \"name\": \"Addition Tricks\", \"url\": \"").append(canonicalUrl).append("?filter=addition\"},\n");
    extraHead.append("      {\"@type\": \"ListItem\", \"position\": 2, \"name\": \"Multiplication Shortcuts\", \"url\": \"").append(canonicalUrl).append("?filter=multiplication\"},\n");
    extraHead.append("      {\"@type\": \"ListItem\", \"position\": 3, \"name\": \"Division Techniques\", \"url\": \"").append(canonicalUrl).append("?filter=division\"},\n");
    extraHead.append("      {\"@type\": \"ListItem\", \"position\": 4, \"name\": \"Percentage Calculations\", \"url\": \"").append(canonicalUrl).append("?filter=percentage\"},\n");
    extraHead.append("      {\"@type\": \"ListItem\", \"position\": 5, \"name\": \"Square Root Methods\", \"url\": \"").append(canonicalUrl).append("?filter=roots\"},\n");
    extraHead.append("      {\"@type\": \"ListItem\", \"position\": 6, \"name\": \"Algebra Shortcuts\", \"url\": \"").append(canonicalUrl).append("?filter=algebra\"}\n");
    extraHead.append("    ]\n");
    extraHead.append("  }\n");
    extraHead.append("}\n");
    extraHead.append("</script>\n");

    // JSON-LD: Course Schema (for educational content)
    extraHead.append("<script type=\"application/ld+json\">\n");
    extraHead.append("{\n");
    extraHead.append("  \"@context\": \"https://schema.org\",\n");
    extraHead.append("  \"@type\": \"Course\",\n");
    extraHead.append("  \"name\": \"Mental Math Mastery: 150+ Speed Calculation Techniques\",\n");
    extraHead.append("  \"description\": \"Learn 150+ mental math tricks to calculate faster than a calculator. Covers multiplication shortcuts, percentage hacks, and number sense techniques.\",\n");
    extraHead.append("  \"provider\": {\n");
    extraHead.append("    \"@type\": \"Organization\",\n");
    extraHead.append("    \"name\": \"8gwifi.org\",\n");
    extraHead.append("    \"url\": \"https://8gwifi.org\"\n");
    extraHead.append("  },\n");
    extraHead.append("  \"educationalLevel\": \"Beginner to Advanced\",\n");
    extraHead.append("  \"teaches\": [\"Mental Arithmetic\", \"Speed Calculation\", \"Math Shortcuts\", \"Number Sense\"],\n");
    extraHead.append("  \"inLanguage\": \"en\",\n");
    extraHead.append("  \"isAccessibleForFree\": true,\n");
    extraHead.append("  \"audience\": {\n");
    extraHead.append("    \"@type\": \"EducationalAudience\",\n");
    extraHead.append("    \"educationalRole\": \"student\",\n");
    extraHead.append("    \"audienceType\": \"Students and lifelong learners\"\n");
    extraHead.append("  },\n");
    extraHead.append("  \"hasCourseInstance\": {\n");
    extraHead.append("    \"@type\": \"CourseInstance\",\n");
    extraHead.append("    \"courseMode\": \"online\",\n");
    extraHead.append("    \"courseWorkload\": \"Self-paced\"\n");
    extraHead.append("  }\n");
    extraHead.append("}\n");
    extraHead.append("</script>\n");

    // JSON-LD: BreadcrumbList
    extraHead.append("<script type=\"application/ld+json\">\n");
    extraHead.append("{\n");
    extraHead.append("  \"@context\": \"https://schema.org\",\n");
    extraHead.append("  \"@type\": \"BreadcrumbList\",\n");
    extraHead.append("  \"itemListElement\": [\n");
    extraHead.append("    {\"@type\": \"ListItem\", \"position\": 1, \"name\": \"Home\", \"item\": \"https://8gwifi.org/\"},\n");
    extraHead.append("    {\"@type\": \"ListItem\", \"position\": 2, \"name\": \"Exams\", \"item\": \"https://8gwifi.org/exams/\"},\n");
    extraHead.append("    {\"@type\": \"ListItem\", \"position\": 3, \"name\": \"Quick Math\"}\n");
    extraHead.append("  ]\n");
    extraHead.append("}\n");
    extraHead.append("</script>\n");

    // JSON-LD: FAQPage (Great for featured snippets!)
    extraHead.append("<script type=\"application/ld+json\">\n");
    extraHead.append("{\n");
    extraHead.append("  \"@context\": \"https://schema.org\",\n");
    extraHead.append("  \"@type\": \"FAQPage\",\n");
    extraHead.append("  \"mainEntity\": [\n");
    extraHead.append("    {\n");
    extraHead.append("      \"@type\": \"Question\",\n");
    extraHead.append("      \"name\": \"What is the fastest way to multiply by 11?\",\n");
    extraHead.append("      \"acceptedAnswer\": {\n");
    extraHead.append("        \"@type\": \"Answer\",\n");
    extraHead.append("        \"text\": \"To multiply any 2-digit number by 11, add the two digits and place the sum between them. For example: 34 × 11 = 3_(3+4)_4 = 374. If the sum exceeds 9, carry the 1 to the left digit.\"\n");
    extraHead.append("      }\n");
    extraHead.append("    },\n");
    extraHead.append("    {\n");
    extraHead.append("      \"@type\": \"Question\",\n");
    extraHead.append("      \"name\": \"How to calculate percentages mentally?\",\n");
    extraHead.append("      \"acceptedAnswer\": {\n");
    extraHead.append("        \"@type\": \"Answer\",\n");
    extraHead.append("        \"text\": \"Use the 10% anchor method: Find 10% by moving the decimal left, then combine. For 15% of 80: 10% = 8, 5% = 4, so 15% = 12. For 25%, divide by 4. For 50%, divide by 2.\"\n");
    extraHead.append("      }\n");
    extraHead.append("    },\n");
    extraHead.append("    {\n");
    extraHead.append("      \"@type\": \"Question\",\n");
    extraHead.append("      \"name\": \"What are the best mental math techniques?\",\n");
    extraHead.append("      \"acceptedAnswer\": {\n");
    extraHead.append("        \"@type\": \"Answer\",\n");
    extraHead.append("        \"text\": \"The most useful mental math techniques include: multiplying numbers near 100 (complement method), squaring numbers ending in 5, the lattice/crosswise method for multiplication, and anchor-based percentage calculation. Many come from Vedic math, an ancient system with 16 formulas for fast mental calculation.\"\n");
    extraHead.append("      }\n");
    extraHead.append("    },\n");
    extraHead.append("    {\n");
    extraHead.append("      \"@type\": \"Question\",\n");
    extraHead.append("      \"name\": \"How to square numbers ending in 5 instantly?\",\n");
    extraHead.append("      \"acceptedAnswer\": {\n");
    extraHead.append("        \"@type\": \"Answer\",\n");
    extraHead.append("        \"text\": \"For any number ending in 5: multiply the first digit(s) by itself plus 1, then append 25. Example: 35² = 3×4 = 12, append 25 = 1225. Works for 45² = 4×5 = 2025, 75² = 7×8 = 5625, etc.\"\n");
    extraHead.append("      }\n");
    extraHead.append("    }\n");
    extraHead.append("  ]\n");
    extraHead.append("}\n");
    extraHead.append("</script>\n");

    request.setAttribute("extraHeadContent", extraHead.toString());
%>
<%@ include file="../components/header.jsp" %>

            <!-- Load Quick Math Core (split into base + topic bundles) -->
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-core-base.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-addition.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-multiplication.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-division.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-roots.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-percentages.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-algebra.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-probability.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-trains.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-streams.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-alligation.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-trigonometry.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-data.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-series.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-mensuration.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-surds.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-profit.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-simple-interest.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-misc.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-permcomb.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-advanced.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-boats-partnership.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-hcf-sets.js"></script>
            <script src="<%=request.getContextPath()%>/exams/js/quick-math-topics-number-patterns.js"></script>

            <!-- Hero Section -->
            <section class="hero">
                <div class="container">
                    <h1 class="hero-title">150+ Mental Math Tricks &mdash; Calculate Faster Than a Calculator</h1>
                    <p class="hero-subtitle">
                        Multiply 2-digit numbers in seconds. Calculate percentages in your head.
                        Square any number ending in 5 <em>instantly</em>. Free interactive practice with step-by-step breakdowns.
                    </p>
                    <div class="hero-tags">
                        <span class="hero-tag">Multiplication</span>
                        <span class="hero-tag">Percentages</span>
                        <span class="hero-tag">Division</span>
                        <span class="hero-tag">Algebra</span>
                        <span class="hero-tag">Roots & Squares</span>
                        <span class="hero-tag">Speed Math</span>
                    </div>
                </div>
            </section>

            <!-- Ad Banner -->
            <%@ include file="../components/ad-leaderboard.jsp" %>

                <!-- Main Content -->
                <section class="page-section">
                    <div class="container">
                        <!-- Content injected by JS -->
                        <div id="filters" class="filter-controls">
                            <div class="tag-filters" id="tag-filters-container">
                                <!-- Primary operation filters (big buttons) -->
                            </div>
                            <div class="secondary-tag-filters" id="secondary-filters-container">
                                <!-- Secondary filters like money, verification, etc -->
                            </div>
                        </div>

                        <div class="difficulty-filter-row">
                            <label class="filter-label">Difficulty:</label>
                            <div class="difficulty-buttons" id="difficulty-buttons">
                                <button class="diff-btn active" data-difficulty="all">All Levels</button>
                                <button class="diff-btn diff-beginner" data-difficulty="Beginner">Beginner</button>
                                <button class="diff-btn diff-intermediate"
                                    data-difficulty="Intermediate">Intermediate</button>
                                <button class="diff-btn diff-advanced" data-difficulty="Advanced">Advanced</button>
                            </div>
                        </div>

                        <div id="topics-container">
                            <div class="text-center">
                                <div class="spinner-border text-primary" role="status"></div>
                                <p>Loading Math Tricks...</p>
                            </div>
                        </div>
                    </div>
                </section>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        const container = document.getElementById('topics-container');
                        const tagFiltersContainer = document.getElementById('tag-filters-container');
                        const secondaryFiltersContainer = document.getElementById('secondary-filters-container');
                        const difficultyButtons = document.getElementById('difficulty-buttons');

                        let activeTag = 'all';
                        let activeDifficulty = 'all';

                        // Primary operation tags (big buttons) - organized by category
                        // Row 1: Core Math Operations
                        const coreMathTags = ['addition', 'subtraction', 'multiplication', 'division', 'percentage', 'roots'];
                        // Row 2: Competitive Exam Categories
                        const competitiveTags = ['algebra', 'probability', 'time-work', 'speed', 'ratio', 'average'];
                        // All primary tags combined
                        const primaryTags = [...coreMathTags, ...competitiveTags];

                        // Secondary tags are DYNAMIC - auto-discovered from topics
                        // Any tag that exists in topics but isn't primary becomes secondary
                        // Limited to 8 visible by default
                        const MAX_VISIBLE_SECONDARY = 8;
                        let showAllSecondary = false;

                        function getSecondaryTags() {
                            const allTags = getAllTags();
                            return allTags.filter(tag => !primaryTags.includes(tag)).sort((a, b) => {
                                // Sort by count (most used first)
                                const counts = getTagCounts();
                                return (counts[b] || 0) - (counts[a] || 0);
                            });
                        }

                        // Tag display names - add new ones here, or they'll be auto-capitalized
                        const tagDisplayNames = {
                            // Core Math
                            'addition': 'Addition',
                            'subtraction': 'Subtraction',
                            'multiplication': 'Multiply',
                            'division': 'Division',
                            'percentage': 'Percent',
                            'roots': 'Roots',
                            // Competitive Categories
                            'algebra': 'Algebra',
                            'probability': 'Probability',
                            'time-work': 'Time & Work',
                            'speed': 'Speed',
                            'ratio': 'Ratio',
                            'average': 'Average',
                            // Secondary
                            'squares': 'Squares',
                            'trains': 'Trains',
                            'pipes': 'Pipes',
                            'streams': 'Streams',
                            'compound-interest': 'CI',
                            'ages': 'Ages',
                            'fractions': 'Fractions',
                            'decimals': 'Decimals',
                            'money': 'Money',
                            'verification': 'Verify',
                            'sequence': 'Sequence',
                            'advanced': 'Advanced',
                            'intermediate': 'Medium',
                            'lcm': 'LCM/HCF',
                            'equations': 'Equations',
                            'quadratics': 'Quadratic',
                            'boats': 'Boats',
                            'alligation': 'Alligation',
                            'partnership': 'Partnership',
                            'profit': 'Profit/Loss',
                            'simple-interest': 'SI',
                            'mensuration': 'Mensuration',
                            'trigonometry': 'Trig',
                            'permutation': 'P&C',
                            'sets': 'Sets'
                        };

                        // Tag icons - add new ones here, or default icon will be used
                        const tagIcons = {
                            // Core Math
                            'addition': '➕',
                            'subtraction': '➖',
                            'multiplication': '✖️',
                            'division': '➗',
                            'percentage': '%',
                            'roots': '√',
                            // Competitive Categories
                            'algebra': '𝑥',
                            'probability': '🎲',
                            'time-work': '⏱️',
                            'speed': '🚗',
                            'ratio': '⚖️',
                            'average': 'μ',
                            // Secondary
                            'squares': '²',
                            'fractions': '½',
                            'decimals': '.',
                            'money': '💵',
                            'verification': '✓',
                            'sequence': '∑',
                            'advanced': '🔥',
                            'lcm': '∩',
                            'equations': '=',
                            'quadratics': 'x²',
                            'ages': '👤',
                            'trains': '🚂',
                            'boats': '⛵',
                            'pipes': '🚰',
                            'streams': '🌊',
                            'alligation': '⚗️',
                            'partnership': '🤝',
                            'profit': '💰',
                            'simple-interest': '📈',
                            'compound-interest': '📊',
                            'mensuration': '📐',
                            'trigonometry': '📏',
                            'permutation': '🔢',
                            'sets': '∪'
                        };

                        // Count topics per tag
                        function getTagCounts() {
                            const counts = { all: 0 };
                            for (const topicId in QuickMath.topics) {
                                const topic = QuickMath.topics[topicId];
                                counts.all++;
                                if (topic.tags && Array.isArray(topic.tags)) {
                                    topic.tags.forEach(tag => {
                                        counts[tag] = (counts[tag] || 0) + 1;
                                    });
                                }
                            }
                            return counts;
                        }

                        // Extract all unique tags from topics
                        function getAllTags() {
                            const tagSet = new Set();
                            for (const topicId in QuickMath.topics) {
                                const topic = QuickMath.topics[topicId];
                                if (topic.tags && Array.isArray(topic.tags)) {
                                    topic.tags.forEach(tag => tagSet.add(tag));
                                }
                            }
                            return Array.from(tagSet);
                        }

                        // Generate filter buttons dynamically
                        function renderFilterButtons() {
                            const existingTags = getAllTags();
                            const counts = getTagCounts();

                            // Primary filters - "All" button
                            let primaryHtml = '<div class="filter-row"><button class="filter-btn filter-btn-all active" data-filter="all"><span class="filter-icon">📊</span><span class="filter-label">All</span><span class="filter-count">' + counts.all + '</span></button>';

                            // Row 1: Core Math
                            coreMathTags.forEach(tag => {
                                if (existingTags.includes(tag) && counts[tag] > 0) {
                                    const displayName = tagDisplayNames[tag] || tag.charAt(0).toUpperCase() + tag.slice(1);
                                    const icon = tagIcons[tag] || '•';
                                    primaryHtml += '<button class="filter-btn filter-btn-' + tag + '" data-filter="' + tag + '"><span class="filter-icon">' + icon + '</span><span class="filter-label">' + displayName + '</span><span class="filter-count">' + counts[tag] + '</span></button>';
                                }
                            });
                            primaryHtml += '</div>';

                            // Row 2: Competitive Exam Topics
                            primaryHtml += '<div class="filter-row">';
                            competitiveTags.forEach(tag => {
                                if (existingTags.includes(tag) && counts[tag] > 0) {
                                    const displayName = tagDisplayNames[tag] || tag.charAt(0).toUpperCase() + tag.slice(1);
                                    const icon = tagIcons[tag] || '•';
                                    primaryHtml += '<button class="filter-btn filter-btn-' + tag + '" data-filter="' + tag + '"><span class="filter-icon">' + icon + '</span><span class="filter-label">' + displayName + '</span><span class="filter-count">' + counts[tag] + '</span></button>';
                                }
                            });
                            primaryHtml += '</div>';

                            tagFiltersContainer.innerHTML = primaryHtml;

                            // Secondary filters (specialty tags) - Collapsible
                            const secondaryTags = getSecondaryTags();
                            const visibleTags = showAllSecondary ? secondaryTags : secondaryTags.slice(0, MAX_VISIBLE_SECONDARY);
                            const hiddenCount = secondaryTags.length - MAX_VISIBLE_SECONDARY;

                            let secondaryHtml = '<div class="secondary-tags-wrapper">';
                            secondaryHtml += '<span class="secondary-label">More:</span>';
                            let hasSecondary = false;

                            visibleTags.forEach(tag => {
                                if (counts[tag] > 0) {
                                    hasSecondary = true;
                                    const displayName = tagDisplayNames[tag] || tag.charAt(0).toUpperCase() + tag.slice(1);
                                    const icon = tagIcons[tag] || '';
                                    secondaryHtml += '<button class="filter-chip filter-chip-' + tag + '" data-filter="' + tag + '">' + (icon ? '<span class="chip-icon">' + icon + '</span>' : '') + displayName + ' <span class="chip-count">(' + counts[tag] + ')</span></button>';
                                }
                            });

                            // Show more/less toggle
                            if (hiddenCount > 0) {
                                if (showAllSecondary) {
                                    secondaryHtml += '<button class="filter-chip toggle-chip" id="toggle-secondary">Show less ↑</button>';
                                } else {
                                    secondaryHtml += '<button class="filter-chip toggle-chip" id="toggle-secondary">+' + hiddenCount + ' more</button>';
                                }
                            }
                            secondaryHtml += '</div>';

                            if (hasSecondary) {
                                secondaryFiltersContainer.innerHTML = secondaryHtml;
                                secondaryFiltersContainer.style.display = 'flex';

                                // Toggle handler
                                const toggleBtn = document.getElementById('toggle-secondary');
                                if (toggleBtn) {
                                    toggleBtn.addEventListener('click', () => {
                                        showAllSecondary = !showAllSecondary;
                                        renderFilterButtons();
                                        // Restore active filter state
                                        const activeBtn = document.querySelector('[data-filter="' + activeTag + '"]');
                                        if (activeBtn) activeBtn.classList.add('active');
                                    });
                                }
                            } else {
                                secondaryFiltersContainer.style.display = 'none';
                            }

                            // Attach event handlers to all filter buttons
                            attachFilterHandlers();
                        }

                        function attachFilterHandlers() {
                            const allFilterBtns = document.querySelectorAll('.filter-btn, .filter-chip');
                            allFilterBtns.forEach(btn => {
                                btn.addEventListener('click', () => {
                                    // Update active state on all buttons
                                    allFilterBtns.forEach(b => b.classList.remove('active'));
                                    btn.classList.add('active');

                                    activeTag = btn.dataset.filter;
                                    renderTopics();
                                });
                            });
                        }

                        // Initialize filter buttons
                        renderFilterButtons();

                        // Initial Render
                        renderTopics();

                        // Difficulty Filter Buttons Handler
                        difficultyButtons.addEventListener('click', (e) => {
                            const btn = e.target.closest('.diff-btn');
                            if (!btn) return;

                            // Update active state
                            difficultyButtons.querySelectorAll('.diff-btn').forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');

                            activeDifficulty = btn.dataset.difficulty;
                            renderTopics();
                        });

                        function renderTopics() {
                            const grouped = QuickMath.getTopicsByCategory();
                            let html = '';
                            let hasTopics = false;

                            for (const [category, topics] of Object.entries(grouped)) {
                                // Composite Filter: Tag AND Difficulty
                                const visibleTopics = topics.filter(t => {
                                    const tagMatch = activeTag === 'all' || (t.tags && t.tags.includes(activeTag));
                                    const diffMatch = activeDifficulty === 'all' || t.difficulty === activeDifficulty;
                                    return tagMatch && diffMatch;
                                });

                                if (visibleTopics.length > 0) {
                                    hasTopics = true;
                                    html += `
                            <h2 class="section-title mt-8">\${category}</h2>
                            <div class="grid grid-3">
                        `;

                                    visibleTopics.forEach(topic => {
                                        // Generate Tag Badges with CSS classes
                                        const tagBadges = (topic.tags || []).map(tag =>
                                            `<span class="tag-badge tag-badge-\${tag}">\${tag}</span>`
                                        ).join('');

                                        // Difficulty badge with CSS class
                                        const difficulty = topic.difficulty || 'General';
                                        const difficultyClass = difficulty.toLowerCase().replace(/\s+/g, '-');

                                        html += `
                                <a href="practice.jsp?topic=\${topic.id}" class="card card-clickable set-card">
                                    <div class="set-card-header">
                                        <div class="flex-between">
                                            <span class="set-card-badge difficulty-badge difficulty-\${difficultyClass}">\${difficulty}</span>
                                            <div>\${tagBadges}</div>
                                        </div>
                                    </div>
                                    <h3 class="set-card-title mt-2">\${topic.ctrHeadline || topic.title}</h3>
                                    <p class="text-secondary text-sm mt-2">\${topic.description}</p>
                                    <div class="set-card-meta mt-4">
                                        <span class="text-accent text-sm font-bold">Start Practice &rarr;</span>
                                    </div>
                                </a>
                            `;
                                    });
                                    html += `</div>`;
                                }
                            }

                            if (!hasTopics) {
                                html = `
                        <div class="text-center mt-8">
                            <p class="text-lg text-secondary">No topics found matching your filters.</p>
                            <p class="text-sm text-muted">Try adjusting your tag or difficulty selections.</p>
                        </div>
                    `;
                            }

                            container.innerHTML = html;
                        }
                    });
                </script>

                <style>
                    /* Hero Tags for SEO */
                    .hero-tags {
                        display: flex;
                        flex-wrap: wrap;
                        gap: var(--space-2);
                        justify-content: center;
                        margin-top: var(--space-4);
                    }

                    .hero-tag {
                        background: rgba(255, 255, 255, 0.1);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                        padding: 4px 12px;
                        border-radius: 20px;
                        font-size: 0.8rem;
                        color: rgba(255, 255, 255, 0.8);
                        font-weight: 500;
                    }

                    /* ============================================
                       NEW IMPROVED FILTER STYLES
                       ============================================ */

                    /* Filter Container */
                    .filter-controls {
                        display: flex;
                        flex-direction: column;
                        gap: var(--space-4);
                        margin-bottom: var(--space-6);
                        background: var(--bg-secondary);
                        padding: var(--space-5);
                        border-radius: var(--radius-xl);
                        border: 1px solid var(--border);
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                    }

                    /* Primary Tag Filters - Big Buttons */
                    .tag-filters {
                        display: flex;
                        flex-direction: column;
                        gap: var(--space-3);
                    }

                    .filter-row {
                        display: flex;
                        flex-wrap: wrap;
                        gap: var(--space-2);
                        justify-content: center;
                    }

                    .filter-btn {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: 2px;
                        background: rgba(255, 255, 255, 0.05);
                        border: 2px solid rgba(255, 255, 255, 0.15);
                        padding: var(--space-2) var(--space-3);
                        border-radius: var(--radius-md);
                        cursor: pointer;
                        transition: all 0.25s ease;
                        min-width: 70px;
                    }

                    .filter-btn .filter-icon {
                        font-size: 1.2rem;
                        line-height: 1;
                    }

                    .filter-btn .filter-label {
                        font-size: 0.75rem;
                        font-weight: 600;
                        color: #e0e0e0;
                        white-space: nowrap;
                    }

                    .filter-btn .filter-count {
                        font-size: 0.65rem;
                        font-weight: 700;
                        background: rgba(255, 255, 255, 0.1);
                        padding: 1px 6px;
                        border-radius: 8px;
                        color: #aaa;
                    }

                    .filter-btn:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
                    }

                    .filter-btn.active {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.25);
                    }

                    .filter-btn.active .filter-label {
                        color: white;
                    }

                    .filter-btn.active .filter-count {
                        background: rgba(255, 255, 255, 0.25);
                        color: white;
                    }

                    /* Primary Filter Button Colors */
                    .filter-btn-all.active {
                        background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                        border-color: #4f46e5;
                    }

                    .filter-btn-all:hover:not(.active) {
                        background: rgba(99, 102, 241, 0.2);
                        border-color: #6366f1;
                    }

                    .filter-btn-addition.active {
                        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                        border-color: #059669;
                    }

                    .filter-btn-addition:hover:not(.active) {
                        background: rgba(16, 185, 129, 0.2);
                        border-color: #10b981;
                    }

                    .filter-btn-subtraction.active {
                        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                        border-color: #2563eb;
                    }

                    .filter-btn-subtraction:hover:not(.active) {
                        background: rgba(59, 130, 246, 0.2);
                        border-color: #3b82f6;
                    }

                    .filter-btn-multiplication.active {
                        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                        border-color: #d97706;
                    }

                    .filter-btn-multiplication:hover:not(.active) {
                        background: rgba(245, 158, 11, 0.2);
                        border-color: #f59e0b;
                    }

                    .filter-btn-division.active {
                        background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
                        border-color: #7c3aed;
                    }

                    .filter-btn-division:hover:not(.active) {
                        background: rgba(139, 92, 246, 0.2);
                        border-color: #8b5cf6;
                    }

                    .filter-btn-percentage.active {
                        background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
                        border-color: #0891b2;
                    }

                    .filter-btn-percentage:hover:not(.active) {
                        background: rgba(6, 182, 212, 0.2);
                        border-color: #06b6d4;
                    }

                    .filter-btn-algebra.active {
                        background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
                        border-color: #ea580c;
                    }

                    .filter-btn-algebra:hover:not(.active) {
                        background: rgba(249, 115, 22, 0.2);
                        border-color: #f97316;
                    }

                    .filter-btn-roots.active {
                        background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
                        border-color: #0d9488;
                    }

                    .filter-btn-roots:hover:not(.active) {
                        background: rgba(20, 184, 166, 0.2);
                        border-color: #14b8a6;
                    }

                    .filter-btn-probability.active {
                        background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
                        border-color: #9333ea;
                    }

                    .filter-btn-probability:hover:not(.active) {
                        background: rgba(168, 85, 247, 0.2);
                        border-color: #a855f7;
                    }

                    /* New Primary Tags */
                    .filter-btn-time-work.active {
                        background: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
                        border-color: #db2777;
                    }

                    .filter-btn-time-work:hover:not(.active) {
                        background: rgba(236, 72, 153, 0.2);
                        border-color: #ec4899;
                    }

                    .filter-btn-speed.active {
                        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                        border-color: #2563eb;
                    }

                    .filter-btn-speed:hover:not(.active) {
                        background: rgba(59, 130, 246, 0.2);
                        border-color: #3b82f6;
                    }

                    .filter-btn-ratio.active {
                        background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
                        border-color: #16a34a;
                    }

                    .filter-btn-ratio:hover:not(.active) {
                        background: rgba(34, 197, 94, 0.2);
                        border-color: #22c55e;
                    }

                    .filter-btn-average.active {
                        background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
                        border-color: #0284c7;
                    }

                    .filter-btn-average:hover:not(.active) {
                        background: rgba(14, 165, 233, 0.2);
                        border-color: #0ea5e9;
                    }

                    /* Secondary Tag Filters - Small Chips */
                    .secondary-tag-filters {
                        display: flex;
                        flex-wrap: wrap;
                        gap: var(--space-2);
                        align-items: center;
                        justify-content: center;
                        padding-top: var(--space-3);
                        border-top: 1px solid rgba(255, 255, 255, 0.1);
                    }

                    .secondary-tags-wrapper {
                        display: flex;
                        flex-wrap: wrap;
                        gap: var(--space-2);
                        align-items: center;
                        justify-content: center;
                    }

                    .toggle-chip {
                        background: rgba(99, 102, 241, 0.2) !important;
                        border-color: #6366f1 !important;
                        color: #a5b4fc !important;
                        font-weight: 600;
                    }

                    .toggle-chip:hover {
                        background: rgba(99, 102, 241, 0.3) !important;
                        color: white !important;
                    }

                    .secondary-label {
                        font-size: 0.75rem;
                        color: #888;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        margin-right: var(--space-2);
                    }

                    .filter-chip {
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        background: rgba(255, 255, 255, 0.05);
                        border: 1px solid rgba(255, 255, 255, 0.15);
                        padding: 6px 12px;
                        border-radius: 20px;
                        cursor: pointer;
                        font-size: 0.8rem;
                        font-weight: 500;
                        color: #ccc;
                        transition: all 0.2s ease;
                    }

                    .filter-chip .chip-icon {
                        font-size: 0.85rem;
                    }

                    .filter-chip .chip-count {
                        font-size: 0.7rem;
                        color: #888;
                    }

                    .filter-chip:hover {
                        background: rgba(255, 255, 255, 0.1);
                        border-color: rgba(255, 255, 255, 0.3);
                        color: white;
                        transform: translateY(-1px);
                    }

                    .filter-chip.active {
                        color: white;
                    }

                    .filter-chip.active .chip-count {
                        color: rgba(255, 255, 255, 0.8);
                    }

                    /* Secondary chip colors - Active states */
                    .filter-chip-squares.active {
                        background: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
                        border-color: #db2777;
                        box-shadow: 0 2px 8px rgba(236, 72, 153, 0.4);
                    }

                    .filter-chip-fractions.active {
                        background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
                        border-color: #9333ea;
                        box-shadow: 0 2px 8px rgba(168, 85, 247, 0.4);
                    }

                    .filter-chip-decimals.active {
                        background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                        border-color: #4f46e5;
                        box-shadow: 0 2px 8px rgba(99, 102, 241, 0.4);
                    }

                    .filter-chip-money.active {
                        background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
                        border-color: #16a34a;
                        box-shadow: 0 2px 8px rgba(34, 197, 94, 0.4);
                    }

                    .filter-chip-verification.active {
                        background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
                        border-color: #65a30d;
                        box-shadow: 0 2px 8px rgba(132, 204, 22, 0.4);
                    }

                    .filter-chip-sequence.active {
                        background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
                        border-color: #0284c7;
                        box-shadow: 0 2px 8px rgba(14, 165, 233, 0.4);
                    }

                    .filter-chip-advanced.active {
                        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                        border-color: #dc2626;
                        box-shadow: 0 2px 8px rgba(239, 68, 68, 0.4);
                    }

                    .filter-chip-intermediate.active {
                        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                        border-color: #d97706;
                        box-shadow: 0 2px 8px rgba(245, 158, 11, 0.4);
                    }

                    /* Secondary chip colors - Hover states */
                    .filter-chip-squares:hover:not(.active) {
                        background: rgba(236, 72, 153, 0.15);
                        border-color: #ec4899;
                        color: #ec4899;
                    }

                    .filter-chip-fractions:hover:not(.active) {
                        background: rgba(168, 85, 247, 0.15);
                        border-color: #a855f7;
                        color: #a855f7;
                    }

                    .filter-chip-decimals:hover:not(.active) {
                        background: rgba(99, 102, 241, 0.15);
                        border-color: #6366f1;
                        color: #6366f1;
                    }

                    .filter-chip-money:hover:not(.active) {
                        background: rgba(34, 197, 94, 0.15);
                        border-color: #22c55e;
                        color: #22c55e;
                    }

                    .filter-chip-verification:hover:not(.active) {
                        background: rgba(132, 204, 22, 0.15);
                        border-color: #84cc16;
                        color: #84cc16;
                    }

                    .filter-chip-sequence:hover:not(.active) {
                        background: rgba(14, 165, 233, 0.15);
                        border-color: #0ea5e9;
                        color: #0ea5e9;
                    }

                    .filter-chip-advanced:hover:not(.active) {
                        background: rgba(239, 68, 68, 0.15);
                        border-color: #ef4444;
                        color: #ef4444;
                    }

                    .filter-chip-intermediate:hover:not(.active) {
                        background: rgba(245, 158, 11, 0.15);
                        border-color: #f59e0b;
                        color: #f59e0b;
                    }

                    /* Inactive state styling - subtle color tint */
                    .filter-chip-squares {
                        border-color: rgba(236, 72, 153, 0.3);
                    }

                    .filter-chip-fractions {
                        border-color: rgba(168, 85, 247, 0.3);
                    }

                    .filter-chip-decimals {
                        border-color: rgba(99, 102, 241, 0.3);
                    }

                    .filter-chip-money {
                        border-color: rgba(34, 197, 94, 0.3);
                    }

                    .filter-chip-verification {
                        border-color: rgba(132, 204, 22, 0.3);
                    }

                    .filter-chip-sequence {
                        border-color: rgba(14, 165, 233, 0.3);
                    }

                    .filter-chip-advanced {
                        border-color: rgba(239, 68, 68, 0.3);
                    }

                    .filter-chip-intermediate {
                        border-color: rgba(245, 158, 11, 0.3);
                    }

                    .filter-chip-speed {
                        border-color: rgba(59, 130, 246, 0.3);
                    }

                    .filter-chip-ratio {
                        border-color: rgba(168, 85, 247, 0.3);
                    }

                    .filter-chip-average {
                        border-color: rgba(20, 184, 166, 0.3);
                    }

                    .filter-chip-lcm {
                        border-color: rgba(249, 115, 22, 0.3);
                    }

                    .filter-chip-equations {
                        border-color: rgba(99, 102, 241, 0.3);
                    }

                    .filter-chip-quadratics {
                        border-color: rgba(236, 72, 153, 0.3);
                    }

                    /* New chip active & hover states */
                    .filter-chip-speed.active {
                        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                        border-color: #2563eb;
                        box-shadow: 0 2px 8px rgba(59, 130, 246, 0.4);
                    }

                    .filter-chip-speed:hover:not(.active) {
                        background: rgba(59, 130, 246, 0.15);
                        border-color: #3b82f6;
                        color: #3b82f6;
                    }

                    .filter-chip-ratio.active {
                        background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
                        border-color: #9333ea;
                        box-shadow: 0 2px 8px rgba(168, 85, 247, 0.4);
                    }

                    .filter-chip-ratio:hover:not(.active) {
                        background: rgba(168, 85, 247, 0.15);
                        border-color: #a855f7;
                        color: #a855f7;
                    }

                    .filter-chip-average.active {
                        background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
                        border-color: #0d9488;
                        box-shadow: 0 2px 8px rgba(20, 184, 166, 0.4);
                    }

                    .filter-chip-average:hover:not(.active) {
                        background: rgba(20, 184, 166, 0.15);
                        border-color: #14b8a6;
                        color: #14b8a6;
                    }

                    .filter-chip-lcm.active {
                        background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
                        border-color: #ea580c;
                        box-shadow: 0 2px 8px rgba(249, 115, 22, 0.4);
                    }

                    .filter-chip-lcm:hover:not(.active) {
                        background: rgba(249, 115, 22, 0.15);
                        border-color: #f97316;
                        color: #f97316;
                    }

                    .filter-chip-equations.active {
                        background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                        border-color: #4f46e5;
                        box-shadow: 0 2px 8px rgba(99, 102, 241, 0.4);
                    }

                    .filter-chip-equations:hover:not(.active) {
                        background: rgba(99, 102, 241, 0.15);
                        border-color: #6366f1;
                        color: #6366f1;
                    }

                    .filter-chip-quadratics.active {
                        background: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
                        border-color: #db2777;
                        box-shadow: 0 2px 8px rgba(236, 72, 153, 0.4);
                    }

                    .filter-chip-quadratics:hover:not(.active) {
                        background: rgba(236, 72, 153, 0.15);
                        border-color: #ec4899;
                        color: #ec4899;
                    }

                    /* Ages chip */
                    .filter-chip-ages {
                        border-color: rgba(59, 130, 246, 0.3);
                    }

                    .filter-chip-ages.active {
                        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                        border-color: #2563eb;
                        box-shadow: 0 2px 8px rgba(59, 130, 246, 0.4);
                    }

                    .filter-chip-ages:hover:not(.active) {
                        background: rgba(59, 130, 246, 0.15);
                        border-color: #3b82f6;
                        color: #3b82f6;
                    }

                    /* Trains chip */
                    .filter-chip-trains {
                        border-color: rgba(239, 68, 68, 0.3);
                    }

                    .filter-chip-trains.active {
                        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                        border-color: #dc2626;
                        box-shadow: 0 2px 8px rgba(239, 68, 68, 0.4);
                    }

                    .filter-chip-trains:hover:not(.active) {
                        background: rgba(239, 68, 68, 0.15);
                        border-color: #ef4444;
                        color: #ef4444;
                    }

                    /* Boats chip */
                    .filter-chip-boats {
                        border-color: rgba(6, 182, 212, 0.3);
                    }

                    .filter-chip-boats.active {
                        background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
                        border-color: #0891b2;
                        box-shadow: 0 2px 8px rgba(6, 182, 212, 0.4);
                    }

                    .filter-chip-boats:hover:not(.active) {
                        background: rgba(6, 182, 212, 0.15);
                        border-color: #06b6d4;
                        color: #06b6d4;
                    }

                    /* Difficulty Filter Row */
                    .difficulty-filter-row {
                        display: flex;
                        align-items: center;
                        gap: var(--space-4);
                        margin-bottom: var(--space-4);
                        padding: var(--space-3) var(--space-4);
                        background: var(--bg-secondary);
                        border-radius: var(--radius-lg);
                        border: 1px solid var(--border);
                    }

                    .difficulty-filter-row .filter-label {
                        font-size: 0.85rem;
                        font-weight: 600;
                        color: #aaa;
                        white-space: nowrap;
                    }

                    .difficulty-buttons {
                        display: flex;
                        flex-wrap: wrap;
                        gap: var(--space-2);
                    }

                    .diff-btn {
                        background: rgba(255, 255, 255, 0.05);
                        border: 1.5px solid rgba(255, 255, 255, 0.15);
                        padding: 8px 16px;
                        border-radius: 8px;
                        cursor: pointer;
                        font-size: 0.85rem;
                        font-weight: 600;
                        color: #bbb;
                        transition: all 0.2s ease;
                    }

                    .diff-btn:hover {
                        background: rgba(255, 255, 255, 0.1);
                        color: white;
                    }

                    .diff-btn.active {
                        background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                        border-color: #4f46e5;
                        color: white;
                    }

                    .diff-btn.diff-beginner:hover:not(.active) {
                        background: rgba(16, 185, 129, 0.2);
                        border-color: #10b981;
                        color: #10b981;
                    }

                    .diff-btn.diff-intermediate:hover:not(.active) {
                        background: rgba(245, 158, 11, 0.2);
                        border-color: #f59e0b;
                        color: #f59e0b;
                    }

                    .diff-btn.diff-advanced:hover:not(.active) {
                        background: rgba(239, 68, 68, 0.2);
                        border-color: #ef4444;
                        color: #ef4444;
                    }

                    .diff-btn.diff-beginner.active {
                        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                        border-color: #059669;
                    }

                    .diff-btn.diff-intermediate.active {
                        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                        border-color: #d97706;
                    }

                    .diff-btn.diff-advanced.active {
                        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                        border-color: #dc2626;
                    }

                    /* Responsive adjustments */
                    @media (max-width: 768px) {
                        .filter-btn {
                            min-width: 75px;
                            padding: var(--space-2) var(--space-3);
                        }

                        .filter-btn .filter-icon {
                            font-size: 1.25rem;
                        }

                        .filter-btn .filter-label {
                            font-size: 0.75rem;
                        }

                        .difficulty-filter-row {
                            flex-direction: column;
                            align-items: flex-start;
                        }

                        .difficulty-buttons {
                            width: 100%;
                        }

                        .diff-btn {
                            flex: 1;
                            text-align: center;
                        }
                    }

                    /* Tags */
                    .flex-between {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        width: 100%;
                    }

                    /* Tag Badge Base Styles */
                    .tag-badge {
                        font-size: 10px;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        padding: 3px 8px;
                        border-radius: 12px;
                        margin-left: 4px;
                        font-weight: 600;
                        display: inline-block;
                    }

                    /* Tag-Specific Colors */
                    .tag-badge-addition {
                        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                        color: white;
                        border: 1px solid #047857;
                    }

                    .tag-badge-subtraction {
                        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                        color: white;
                        border: 1px solid #1d4ed8;
                    }

                    .tag-badge-multiplication {
                        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                        color: white;
                        border: 1px solid #b45309;
                    }

                    .tag-badge-division {
                        background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
                        color: white;
                        border: 1px solid #6d28d9;
                    }

                    .tag-badge-squares {
                        background: linear-gradient(135deg, #ec4899 0%, #db2777 100%);
                        color: white;
                        border: 1px solid #be185d;
                    }

                    .tag-badge-roots {
                        background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
                        color: white;
                        border: 1px solid #0f766e;
                    }

                    .tag-badge-percentage {
                        background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
                        color: white;
                        border: 1px solid #0e7490;
                    }

                    .tag-badge-algebra {
                        background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
                        color: white;
                        border: 1px solid #c2410c;
                    }

                    .tag-badge-fractions {
                        background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
                        color: white;
                        border: 1px solid #7e22ce;
                    }

                    .tag-badge-decimals {
                        background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                        color: white;
                        border: 1px solid #4338ca;
                    }

                    .tag-badge-money {
                        background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
                        color: white;
                        border: 1px solid #15803d;
                    }

                    .tag-badge-verification {
                        background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
                        color: white;
                        border: 1px solid #4d7c0f;
                    }

                    .tag-badge-sequence {
                        background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
                        color: white;
                        border: 1px solid #0369a1;
                    }

                    .tag-badge-advanced {
                        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                        color: white;
                        border: 1px solid #b91c1c;
                    }

                    .tag-badge-probability {
                        background: linear-gradient(135deg, #a855f7 0%, #9333ea 100%);
                        color: white;
                        border: 1px solid #7e22ce;
                    }

                    /* Default tag badge for unknown tags */
                    .tag-badge:not([class*="tag-badge-"]) {
                        background: var(--bg-tertiary);
                        color: var(--text-muted);
                        border: 1px solid var(--border);
                    }

                    /* Difficulty Badge Styles */
                    .difficulty-badge {
                        font-size: 11px;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        padding: 4px 10px;
                        border-radius: 12px;
                        font-weight: 600;
                        display: inline-block;
                    }

                    .difficulty-beginner {
                        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                        color: white;
                        border: 1px solid #047857;
                    }

                    .difficulty-intermediate {
                        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                        color: white;
                        border: 1px solid #b45309;
                    }

                    .difficulty-advanced {
                        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                        color: white;
                        border: 1px solid #b91c1c;
                    }

                    .difficulty-general {
                        background: var(--bg-tertiary);
                        color: var(--text-muted);
                        border: 1px solid var(--border);
                    }

                    /* Utils */
                    .text-accent {
                        color: var(--accent-primary);
                    }

                    .mt-8 {
                        margin-top: var(--space-8);
                    }

                    .mt-4 {
                        margin-top: var(--space-4);
                    }

                    .mt-2 {
                        margin-top: var(--space-2);
                    }

                    .font-bold {
                        font-weight: 600;
                    }
                </style>

                <%@ include file="../components/footer.jsp" %>
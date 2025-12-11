<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Modern Analytics Component
    Includes Google Analytics 4 (GA4) and StatCounter
    Enhanced event tracking for tools, search, and user interactions
    
    Usage: <%@ include file="modern/components/analytics.jsp" %>
    
    Enhanced Tracking:
    - Tool usage events
    - Search queries
    - Tool category views
    - User interactions
    - Performance metrics
--%>

<!-- Google Analytics 4 (GA4) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-FQ2QT10GDP" onerror="console.warn('Google Analytics failed to load')"></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    
    // GA4 Configuration
    gtag('config', 'G-FQ2QT10GDP', {
        'page_path': window.location.pathname,
        'page_title': document.title,
        'send_page_view': true
    });

    // Enhanced Tool Usage Tracking
    function trackToolUsage(toolName, toolCategory, action) {
        gtag('event', 'tool_usage', {
            'tool_name': toolName,
            'tool_category': toolCategory,
            'action': action, // 'view', 'execute', 'copy_result'
            'event_category': 'Tool',
            'event_label': toolName,
            'value': 1
        });
    }

    // Search Tracking
    function trackSearch(query, resultCount) {
        gtag('event', 'search', {
            'search_term': query,
            'results_count': resultCount,
            'event_category': 'Search',
            'event_label': query
        });
    }

    // Category View Tracking
    function trackCategoryView(categoryName) {
        gtag('event', 'category_view', {
            'category_name': categoryName,
            'event_category': 'Navigation',
            'event_label': categoryName
        });
    }

    // Tool Execution Tracking (for tools with generate/execute buttons)
    function trackToolExecution(toolName, executionTime, success) {
        gtag('event', 'tool_execution', {
            'tool_name': toolName,
            'execution_time': executionTime,
            'success': success,
            'event_category': 'Tool',
            'event_label': toolName,
            'value': executionTime
        });
    }

    // Copy Result Tracking
    function trackCopyResult(toolName) {
        gtag('event', 'copy_result', {
            'tool_name': toolName,
            'event_category': 'Tool',
            'event_label': toolName
        });
    }

    // Error Tracking
    function trackError(errorMessage, toolName) {
        gtag('event', 'exception', {
            'description': errorMessage,
            'fatal': false,
            'tool_name': toolName,
            'event_category': 'Error',
            'event_label': toolName
        });
    }

    // Page View Enhancement - Track if tool page
    if (window.location.pathname.includes('.jsp') && 
        !window.location.pathname.includes('index') &&
        !window.location.pathname.includes('tutorial')) {
        const toolName = document.title.split(' Online')[0] || document.title;
        trackToolUsage(toolName, 'Unknown', 'view');
    }

    // Track Search Interactions
    document.addEventListener('DOMContentLoaded', function() {
        // Hero search tracking
        const heroSearch = document.getElementById('heroSearch');
        if (heroSearch) {
            heroSearch.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    const query = this.value.trim();
                    if (query) {
                        trackSearch(query, 0);
                    }
                }
            });
        }

        // Navigation search tracking
        const navSearches = document.querySelectorAll('.search-input');
        navSearches.forEach(search => {
            search.addEventListener('input', function() {
                if (this.value.length >= 3) {
                    // Debounce search tracking
                    clearTimeout(this.searchTimeout);
                    this.searchTimeout = setTimeout(() => {
                        trackSearch(this.value, 0);
                    }, 1000);
                }
            });
        });

        // Category pill clicks
        document.querySelectorAll('.category-pill').forEach(pill => {
            pill.addEventListener('click', function() {
                const category = this.textContent.trim();
                trackCategoryView(category);
            });
        });

        // Tool card clicks
        document.querySelectorAll('.tool-card').forEach(card => {
            card.addEventListener('click', function() {
                const toolTitle = this.querySelector('.tool-title')?.textContent || 'Unknown';
                trackToolUsage(toolTitle, 'Unknown', 'view');
            });
        });
    });

    // Performance Tracking
    window.addEventListener('load', function() {
        if ('performance' in window && 'timing' in window.performance) {
            const perfData = window.performance.timing;
            const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart;
            
            gtag('event', 'page_load_time', {
                'value': pageLoadTime,
                'event_category': 'Performance',
                'event_label': window.location.pathname,
                'non_interaction': true
            });
        }
    });
</script>

<!-- StatCounter Analytics -->
<script type="text/javascript">
    var sc_project=9638240;
    var sc_invisible=1;
    var sc_security="c4db7f3d";
    var sc_https=1;
    var sc_remove_link=1;
</script>
<script type="text/javascript"
        src="https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/js/statcounter/counter/counter.js"
        async
        onerror="console.warn('StatCounter failed to load')"></script>
<noscript>
    <div class="statcounter">
        <a title="Web Analytics" 
           href="https://statcounter.com/" 
           target="_blank"
           rel="noopener">
            <img class="statcounter"
                 src="https://c.statcounter.com/9638240/0/c4db7f3d/1/"
                 alt="Web Analytics"
                 referrerPolicy="no-referrer-when-downgrade">
        </a>
    </div>
</noscript>
<!-- End of StatCounter Code -->


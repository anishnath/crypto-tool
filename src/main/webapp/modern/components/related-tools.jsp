<%--
  Related Tools Component
  Dynamically loads related tools from tools-database.json based on current tool's category/keywords

  Parameters:
  - currentToolUrl (required): Current tool's JSP filename (e.g., "CipherFunctions.jsp")
  - category (optional): Filter by category (e.g., "Cryptography")
  - keyword (optional): Filter by keyword in name/keywords (e.g., "pgp" to show only PGP tools)
  - limit (optional): Number of tools to show (default: 6)
  - excludeUrls (optional): Comma-separated list of URLs to exclude (includes currentToolUrl automatically)
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    // Helper method to escape JavaScript strings
    private String escapeJs(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
               .replace("'", "\\'")
               .replace("\"", "\\\"")
               .replace("\n", "\\n")
               .replace("\r", "\\r")
               .replace("</script>", "<\\/script>")
               .replace("</SCRIPT>", "<\\/SCRIPT>");
    }
%>

<%
    // Get parameters with null safety
    String currentToolUrl = request.getParameter("currentToolUrl");
    if (currentToolUrl == null || currentToolUrl.trim().isEmpty()) {
        currentToolUrl = "";
    } else {
        currentToolUrl = currentToolUrl.trim();
    }
    
    String category = request.getParameter("category");
    if (category == null || category.trim().isEmpty()) {
        category = "";
    } else {
        category = category.trim();
    }

    String keyword = request.getParameter("keyword");
    if (keyword == null || keyword.trim().isEmpty()) {
        keyword = "";
    } else {
        keyword = keyword.trim().toLowerCase();
    }

    int limit = 6;
    try {
        String limitStr = request.getParameter("limit");
        if (limitStr != null && !limitStr.trim().isEmpty()) {
            limit = Integer.parseInt(limitStr.trim());
            if (limit < 1) limit = 6;
            if (limit > 20) limit = 20; // Max limit
        }
    } catch (NumberFormatException e) {
        // Use default
        limit = 6;
    }
    
    String excludeUrls = request.getParameter("excludeUrls");
    if (excludeUrls == null) {
        excludeUrls = "";
    } else {
        excludeUrls = excludeUrls.trim();
    }
    
    // Always exclude current tool
    if (currentToolUrl != null && !currentToolUrl.isEmpty()) {
        if (!excludeUrls.isEmpty() && !excludeUrls.contains(currentToolUrl)) {
            excludeUrls += "," + currentToolUrl;
        } else if (excludeUrls.isEmpty()) {
            excludeUrls = currentToolUrl;
        }
    }
%>

<section class="related-tools-section" id="relatedToolsSection">
    <div class="related-tools-card">
        <div class="related-tools-header">
            <h3>
                <svg class="related-tools-icon-svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path>
                </svg>
                Related Tools
            </h3>
            <p id="relatedToolsDescription">Explore related tools</p>
        </div>
        <div class="related-tools-grid" id="relatedToolsGrid">
            <!-- Loading state -->
            <div class="related-tools-loading">
                <svg class="loading-spinner" width="40" height="40" viewBox="0 0 40 40">
                    <circle cx="20" cy="20" r="18" fill="none" stroke="currentColor" stroke-width="3" opacity="0.2"/>
                    <circle cx="20" cy="20" r="18" fill="none" stroke="currentColor" stroke-width="3" stroke-dasharray="56.5" stroke-dashoffset="28.25" opacity="0.8">
                        <animate attributeName="stroke-dasharray" dur="2s" values="0 113;56.5 56.5;0 113;0 113" repeatCount="indefinite"/>
                    </circle>
                </svg>
                <p>Loading related tools...</p>
            </div>
        </div>
    </div>
</section>

<script>
(function() {
    'use strict';
    
    // Configuration from JSP parameters
    const config = {
        currentToolUrl: '<%=escapeJs(currentToolUrl)%>',
        category: '<%=escapeJs(category)%>',
        keyword: '<%=escapeJs(keyword)%>',
        limit: <%=limit%>,
        excludeUrls: '<%=escapeJs(excludeUrls)%>'.split(',').map(function(url) { return url.trim(); }).filter(function(url) { return url !== ''; }),
        toolsDatabasePath: '<%=escapeJs(request.getContextPath() != null ? request.getContextPath() : "")%>/modern/data/tools-database.json'
    };
    
    // SVG Icon mapping for different tool types and categories
    const toolIcons = {
        // Cryptography icons
        'hash': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="4" y1="9" x2="20" y2="9"></line>
            <line x1="4" y1="15" x2="20" y2="15"></line>
            <line x1="10" y1="3" x2="8" y2="21"></line>
            <line x1="16" y1="3" x2="14" y2="21"></line>
        </svg>`,
        'lock': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
        </svg>`,
        'key': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 2l-2 2m-7.61 7.61a5.5 5.5 0 1 1-7.778 7.778 5.5 5.5 0 0 1 7.777-7.777zm0 0L15.5 7.5m0 0l3 3L22 7l-3-3m-3.5 3.5L19 4"></path>
        </svg>`,
        'shield': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
            <path d="M9 12l2 2 4-4"></path>
        </svg>`,
        'certificate': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="4" width="18" height="14" rx="2"></rect>
            <path d="M7 8h10"></path>
            <path d="M7 12h6"></path>
            <circle cx="16" cy="16" r="4"></circle>
            <path d="M14.5 19.5L12 22l-1-3"></path>
            <path d="M17.5 19.5L20 22l1-3"></path>
        </svg>`,

        // DevOps icons
        'kubernetes': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M12 2L2 7l10 5 10-5-10-5z"></path>
            <path d="M2 17l10 5 10-5"></path>
            <path d="M2 12l10 5 10-5"></path>
        </svg>`,
        'server': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="2" width="20" height="8" rx="2" ry="2"></rect>
            <rect x="2" y="14" width="20" height="8" rx="2" ry="2"></rect>
            <line x1="6" y1="6" x2="6.01" y2="6"></line>
            <line x1="6" y1="18" x2="6.01" y2="18"></line>
        </svg>`,
        'docker': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="10" width="4" height="4"></rect>
            <rect x="7" y="10" width="4" height="4"></rect>
            <rect x="12" y="10" width="4" height="4"></rect>
            <rect x="7" y="5" width="4" height="4"></rect>
            <rect x="12" y="5" width="4" height="4"></rect>
            <path d="M19 13c1.5 0 3-.5 4-2-1.5-2-4-2.5-6-1.5"></path>
            <path d="M2 14c0 3 2.5 6 8 6s10-3 10-6"></path>
        </svg>`,
        'terminal': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="4 17 10 11 4 5"></polyline>
            <line x1="12" y1="19" x2="20" y2="19"></line>
        </svg>`,

        // Network icons
        'network': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="2"></circle>
            <circle cx="12" cy="5" r="1"></circle>
            <circle cx="19" cy="12" r="1"></circle>
            <circle cx="12" cy="19" r="1"></circle>
            <circle cx="5" cy="12" r="1"></circle>
            <path d="M12 7v3"></path>
            <path d="M17 12h-3"></path>
            <path d="M12 17v-3"></path>
            <path d="M7 12h3"></path>
        </svg>`,
        'globe': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="2" y1="12" x2="22" y2="12"></line>
            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
        </svg>`,
        'dns': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
            <path d="M8 10h.01"></path>
            <path d="M12 10h.01"></path>
            <path d="M16 10h.01"></path>
            <path d="M8 14h.01"></path>
            <path d="M12 14h.01"></path>
            <path d="M16 14h.01"></path>
        </svg>`,

        // Data/Encoding icons
        'code': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="16 18 22 12 16 6"></polyline>
            <polyline points="8 6 2 12 8 18"></polyline>
        </svg>`,
        'binary': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M10 4H6v6h4V4z"></path>
            <path d="M18 4h-4v6h4V4z"></path>
            <path d="M10 14H6v6h4v-6z"></path>
            <path d="M18 14h-4v6h4v-6z"></path>
            <path d="M8 4v6"></path>
            <path d="M16 14v6"></path>
        </svg>`,
        'database': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
            <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
            <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
        </svg>`,

        // Document/File icons
        'file': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <line x1="16" y1="13" x2="8" y2="13"></line>
            <line x1="16" y1="17" x2="8" y2="17"></line>
        </svg>`,
        'pdf': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <path d="M9 13h2"></path>
            <path d="M9 17h6"></path>
        </svg>`,
        'image': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
            <circle cx="8.5" cy="8.5" r="1.5"></circle>
            <polyline points="21 15 16 10 5 21"></polyline>
        </svg>`,

        // Math/Science icons
        'calculator': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="4" y="2" width="16" height="20" rx="2"></rect>
            <line x1="8" y1="6" x2="16" y2="6"></line>
            <line x1="8" y1="10" x2="8" y2="10.01"></line>
            <line x1="12" y1="10" x2="12" y2="10.01"></line>
            <line x1="16" y1="10" x2="16" y2="10.01"></line>
            <line x1="8" y1="14" x2="8" y2="14.01"></line>
            <line x1="12" y1="14" x2="12" y2="14.01"></line>
            <line x1="16" y1="14" x2="16" y2="14.01"></line>
            <line x1="8" y1="18" x2="8" y2="18.01"></line>
            <line x1="12" y1="18" x2="12" y2="18.01"></line>
            <line x1="16" y1="18" x2="16" y2="18.01"></line>
        </svg>`,
        'function': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 17H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
            <path d="M15 3h4a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-4"></path>
            <path d="M12 3v18"></path>
            <path d="M8 12h8"></path>
        </svg>`,
        'atom': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="1"></circle>
            <path d="M20.2 20.2c2.04-2.03.02-7.36-4.5-11.9-4.54-4.52-9.87-6.54-11.9-4.5-2.04 2.03-.02 7.36 4.5 11.9 4.54 4.52 9.87 6.54 11.9 4.5Z"></path>
            <path d="M15.7 15.7c4.52-4.54 6.54-9.87 4.5-11.9-2.03-2.04-7.36-.02-11.9 4.5-4.52 4.54-6.54 9.87-4.5 11.9 2.03 2.04 7.36.02 11.9-4.5Z"></path>
        </svg>`,

        // Blockchain icons
        'blockchain': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="7" width="6" height="6" rx="1"></rect>
            <rect x="9" y="2" width="6" height="6" rx="1"></rect>
            <rect x="16" y="7" width="6" height="6" rx="1"></rect>
            <rect x="9" y="16" width="6" height="6" rx="1"></rect>
            <path d="M6 10h3"></path>
            <path d="M15 10h3"></path>
            <path d="M12 8v8"></path>
        </svg>`,
        'wallet': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 12V8H6a2 2 0 0 1-2-2c0-1.1.9-2 2-2h12v4"></path>
            <path d="M4 6v12c0 1.1.9 2 2 2h14v-4"></path>
            <path d="M18 12a2 2 0 0 0-2 2c0 1.1.9 2 2 2h4v-4h-4z"></path>
        </svg>`,

        // Token/Auth icons
        'token': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z"></path>
            <path d="M13 5v2"></path>
            <path d="M13 17v2"></path>
            <path d="M13 11v2"></path>
        </svg>`,
        'fingerprint': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M2 12C2 6.5 6.5 2 12 2a10 10 0 0 1 8 4"></path>
            <path d="M5 19.5C5.5 18 6 15 6 12c0-.7.12-1.37.34-2"></path>
            <path d="M17.29 21.02c.12-.6.43-2.3.5-3.02"></path>
            <path d="M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4"></path>
            <path d="M8.65 22c.21-.66.45-1.32.57-2"></path>
            <path d="M14 13.12c0 2.38 0 6.38-1 8.88"></path>
            <path d="M2 16h.01"></path>
            <path d="M21.8 16c.2-2 .131-5.354 0-6"></path>
            <path d="M9 6.8a6 6 0 0 1 9 5.2c0 .47 0 1.17-.02 2"></path>
        </svg>`,

        // Utility icons
        'tool': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path>
        </svg>`,
        'settings': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="3"></circle>
            <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
        </svg>`,
        'random': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="2" width="20" height="20" rx="5"></rect>
            <circle cx="8" cy="8" r="1.5" fill="currentColor"></circle>
            <circle cx="16" cy="8" r="1.5" fill="currentColor"></circle>
            <circle cx="8" cy="16" r="1.5" fill="currentColor"></circle>
            <circle cx="16" cy="16" r="1.5" fill="currentColor"></circle>
            <circle cx="12" cy="12" r="1.5" fill="currentColor"></circle>
        </svg>`,
        'qrcode': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="7" height="7"></rect>
            <rect x="14" y="3" width="7" height="7"></rect>
            <rect x="3" y="14" width="7" height="7"></rect>
            <rect x="14" y="14" width="3" height="3"></rect>
            <path d="M21 14h-3v3"></path>
            <path d="M21 21v-3h-3"></path>
        </svg>`,

        // Finance/Business
        'dollar': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="12" y1="1" x2="12" y2="23"></line>
            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
        </svg>`,

        // Media
        'video': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polygon points="23 7 16 12 23 17 23 7"></polygon>
            <rect x="1" y="5" width="15" height="14" rx="2" ry="2"></rect>
        </svg>`,
        'music': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9 18V5l12-2v13"></path>
            <circle cx="6" cy="18" r="3"></circle>
            <circle cx="18" cy="16" r="3"></circle>
        </svg>`,

        // ML/AI
        'brain': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M9.5 2A2.5 2.5 0 0 1 12 4.5v15a2.5 2.5 0 0 1-4.96.44 2.5 2.5 0 0 1-2.96-3.08 3 3 0 0 1-.34-5.58 2.5 2.5 0 0 1 1.32-4.24 2.5 2.5 0 0 1 1.98-3A2.5 2.5 0 0 1 9.5 2Z"></path>
            <path d="M14.5 2A2.5 2.5 0 0 0 12 4.5v15a2.5 2.5 0 0 0 4.96.44 2.5 2.5 0 0 0 2.96-3.08 3 3 0 0 0 .34-5.58 2.5 2.5 0 0 0-1.32-4.24 2.5 2.5 0 0 0-1.98-3A2.5 2.5 0 0 0 14.5 2Z"></path>
        </svg>`,

        // Default
        'default': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M12 6v6l4 2"></path>
        </svg>`
    };

    // Determine icon based on tool name, keywords, and category
    function getToolIcon(tool) {
        const name = (tool.name || '').toLowerCase();
        const keywords = (tool.keywords || '').toLowerCase();
        const category = (tool.category || '').toLowerCase();
        const combined = name + ' ' + keywords;

        // Kubernetes/DevOps specific
        if (combined.includes('kubernetes') || combined.includes('k8s') || combined.includes('kube') || combined.includes('yaml generator')) {
            return toolIcons.kubernetes;
        }
        if (combined.includes('docker') || combined.includes('container')) {
            return toolIcons.docker;
        }
        if (combined.includes('server') || combined.includes('apache') || combined.includes('nginx')) {
            return toolIcons.server;
        }
        if (combined.includes('terminal') || combined.includes('bash') || combined.includes('shell') || combined.includes('cli')) {
            return toolIcons.terminal;
        }

        // Blockchain
        if (combined.includes('blockchain') || combined.includes('ethereum') || combined.includes('bitcoin') || combined.includes('bip39')) {
            return toolIcons.blockchain;
        }
        if (combined.includes('wallet') || combined.includes('mnemonic')) {
            return toolIcons.wallet;
        }

        // Cryptography
        if (combined.includes('hash') || combined.includes('sha') || combined.includes('md5') || combined.includes('checksum')) {
            return toolIcons.hash;
        }
        if (combined.includes('encrypt') || combined.includes('decrypt') || combined.includes('cipher') || combined.includes('aes') || combined.includes('rsa')) {
            return toolIcons.lock;
        }
        if (combined.includes('key') || combined.includes('keygen') || combined.includes('keypair')) {
            return toolIcons.key;
        }
        if (combined.includes('certificate') || combined.includes('cert') || combined.includes('ssl') || combined.includes('tls') || combined.includes('x509') || combined.includes('pem')) {
            return toolIcons.certificate;
        }
        if (combined.includes('hmac') || combined.includes('signature') || combined.includes('sign') || combined.includes('verify')) {
            return toolIcons.fingerprint;
        }
        if (combined.includes('bcrypt') || combined.includes('password') || combined.includes('argon') || combined.includes('scrypt')) {
            return toolIcons.shield;
        }
        if (combined.includes('jwt') || combined.includes('token') || combined.includes('oauth') || combined.includes('saml')) {
            return toolIcons.token;
        }

        // Network
        if (combined.includes('dns') || combined.includes('domain') || combined.includes('whois')) {
            return toolIcons.dns;
        }
        if (combined.includes('network') || combined.includes('ping') || combined.includes('traceroute') || combined.includes('subnet') || combined.includes('ip')) {
            return toolIcons.network;
        }
        if (combined.includes('http') || combined.includes('url') || combined.includes('web')) {
            return toolIcons.globe;
        }

        // Encoding/Data
        if (combined.includes('base64') || combined.includes('base32') || combined.includes('encode') || combined.includes('decode') || combined.includes('hex')) {
            return toolIcons.code;
        }
        if (combined.includes('binary') || combined.includes('ascii') || combined.includes('unicode')) {
            return toolIcons.binary;
        }
        if (combined.includes('json') || combined.includes('xml') || combined.includes('yaml') || combined.includes('csv') || combined.includes('sql')) {
            return toolIcons.database;
        }
        if (combined.includes('qr') || combined.includes('barcode')) {
            return toolIcons.qrcode;
        }

        // Documents
        if (combined.includes('pdf')) {
            return toolIcons.pdf;
        }
        if (combined.includes('image') || combined.includes('png') || combined.includes('jpg') || combined.includes('resize') || combined.includes('compress')) {
            return toolIcons.image;
        }
        if (combined.includes('file') || combined.includes('document') || combined.includes('text')) {
            return toolIcons.file;
        }

        // Math/Science
        if (combined.includes('calculator') || combined.includes('math') || combined.includes('compute') || combined.includes('convert')) {
            return toolIcons.calculator;
        }
        if (combined.includes('function') || combined.includes('formula') || combined.includes('equation')) {
            return toolIcons.function;
        }
        if (combined.includes('chemistry') || combined.includes('physics') || combined.includes('atom') || combined.includes('molecule')) {
            return toolIcons.atom;
        }

        // Finance
        if (combined.includes('finance') || combined.includes('money') || combined.includes('currency') || combined.includes('loan') || combined.includes('interest')) {
            return toolIcons.dollar;
        }

        // Media
        if (combined.includes('video') || combined.includes('mp4') || combined.includes('trim')) {
            return toolIcons.video;
        }
        if (combined.includes('audio') || combined.includes('music') || combined.includes('mp3')) {
            return toolIcons.music;
        }

        // ML/AI
        if (combined.includes('machine learning') || combined.includes('ml') || combined.includes('ai') || combined.includes('neural') || combined.includes('model')) {
            return toolIcons.brain;
        }

        // Random/Generator
        if (combined.includes('random') || combined.includes('generator') || combined.includes('uuid') || combined.includes('guid')) {
            return toolIcons.random;
        }

        // Category-based fallbacks
        if (category.includes('devops') || category.includes('infrastructure')) {
            return toolIcons.server;
        }
        if (category.includes('crypto') && !category.includes('blockchain')) {
            return toolIcons.lock;
        }
        if (category.includes('blockchain')) {
            return toolIcons.blockchain;
        }
        if (category.includes('network')) {
            return toolIcons.network;
        }
        if (category.includes('math')) {
            return toolIcons.calculator;
        }
        if (category.includes('security') || category.includes('pki')) {
            return toolIcons.shield;
        }
        if (category.includes('document')) {
            return toolIcons.file;
        }
        if (category.includes('media')) {
            return toolIcons.image;
        }
        if (category.includes('developer')) {
            return toolIcons.code;
        }
        if (category.includes('data') || category.includes('converter')) {
            return toolIcons.database;
        }
        if (category.includes('machine') || category.includes('learning')) {
            return toolIcons.brain;
        }

        return toolIcons.tool;
    }
    
    // Load tools database
    async function loadRelatedTools() {
        try {
            if (!config.toolsDatabasePath) {
                console.warn('Related Tools: Tools database path not configured');
                showError();
                return;
            }
            
            const response = await fetch(config.toolsDatabasePath + '?v=' + Date.now());
            if (!response.ok) {
                throw new Error('Failed to load tools database: ' + response.status);
            }
            
            const data = await response.json();
            if (!data || !data.tools) {
                throw new Error('Invalid tools database format');
            }
            
            let tools = data.tools || [];
            
            // Get current tool's keywords for relevance scoring
            const currentTool = tools.find(t => t && t.url === config.currentToolUrl);
            const currentKeywords = currentTool && currentTool.keywords
                ? currentTool.keywords.toLowerCase().split(/\s+/)
                : [];

            // Filter tools
            tools = tools.filter(tool => {
                if (!tool || !tool.url) {
                    return false;
                }

                // Exclude current tool
                if (tool.url === config.currentToolUrl) {
                    return false;
                }

                // Exclude specified exclusions
                if (config.excludeUrls && config.excludeUrls.length > 0) {
                    if (config.excludeUrls.includes(tool.url)) {
                        return false;
                    }
                }

                // Filter by category if specified
                if (config.category && config.category.trim() !== '') {
                    if (tool.category !== config.category) {
                        return false;
                    }
                }

                // Filter by keyword if specified (matches name or keywords)
                if (config.keyword && config.keyword.trim() !== '') {
                    const toolName = (tool.name || '').toLowerCase();
                    const toolKeywords = (tool.keywords || '').toLowerCase();
                    const toolUrl = (tool.url || '').toLowerCase();
                    const searchIn = toolName + ' ' + toolKeywords + ' ' + toolUrl;
                    if (!searchIn.includes(config.keyword.toLowerCase())) {
                        return false;
                    }
                }

                return true;
            });

            // Score tools by keyword relevance
            if (currentKeywords.length > 0) {
                tools = tools.map(tool => {
                    const toolKeywords = (tool.keywords || '').toLowerCase().split(/\s+/);
                    let score = 0;
                    currentKeywords.forEach(kw => {
                        if (kw.length > 2 && toolKeywords.includes(kw)) {
                            score += 10; // Exact match
                        } else if (kw.length > 2) {
                            toolKeywords.forEach(tk => {
                                if (tk.includes(kw) || kw.includes(tk)) {
                                    score += 3; // Partial match
                                }
                            });
                        }
                    });
                    return { ...tool, relevanceScore: score };
                });

                // Sort by relevance score (highest first)
                tools.sort((a, b) => b.relevanceScore - a.relevanceScore);
            }

            // Limit results
            if (config.limit && config.limit > 0) {
                tools = tools.slice(0, config.limit);
            }
            
            // Render tools
            renderTools(tools);
            
            // Update description
            updateDescription(tools.length);
            
        } catch (error) {
            console.error('Error loading related tools:', error);
            showError();
        }
    }
    
    // Render tools
    function renderTools(tools) {
        const grid = document.getElementById('relatedToolsGrid');
        
        if (!grid) {
            console.error('Related Tools: Grid element not found');
            return;
        }
        
        if (!tools || tools.length === 0) {
            grid.innerHTML = '<div class="related-tools-empty"><p>No related tools found.</p></div>';
            return;
        }
        
        const contextPath = '<%=request.getContextPath() != null ? request.getContextPath() : ""%>';
        
        try {
            grid.innerHTML = tools.map(tool => {
                if (!tool || !tool.name || !tool.url) {
                    return '';
                }
                
                const icon = getToolIcon(tool);
                const url = tool.url.startsWith('http') ? tool.url : (contextPath + '/' + tool.url);
                const description = (tool.description || 'Explore this tool').replace(/ - Free online.*$/i, '');
                
                return `
                    <a href="\${escapeHtml(url)}" class="related-tool-item" title="\${escapeHtml(tool.name)}">
                        <div class="related-tool-icon">
                            \${icon}
                        </div>
                        <div class="related-tool-content">
                            <h4>\${escapeHtml(tool.name)}</h4>
                            <p>\${escapeHtml(description)}</p>
                        </div>
                        <svg class="related-tool-arrow" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </a>
                `;
            }).filter(html => html !== '').join('');
        } catch (error) {
            console.error('Error rendering related tools:', error);
            showError();
        }
    }
    
    // Update description
    function updateDescription(count) {
        const descEl = document.getElementById('relatedToolsDescription');
        if (descEl && config.keyword) {
            descEl.textContent = `Explore \${count} other \${config.keyword.toUpperCase()} tools`;
        } else if (descEl && config.category) {
            descEl.textContent = `Explore \${count} other \${config.category.toLowerCase()} tools`;
        } else if (descEl) {
            descEl.textContent = `Explore \${count} related tools`;
        }
    }
    
    // Show error state
    function showError() {
        const grid = document.getElementById('relatedToolsGrid');
        grid.innerHTML = '<div class="related-tools-error"><p>Unable to load related tools. Please try again later.</p></div>';
    }
    
    // Escape HTML
    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    // Initialize when DOM is ready
    try {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', function() {
                setTimeout(loadRelatedTools, 100);
            });
        } else {
            setTimeout(loadRelatedTools, 100);
        }
    } catch (error) {
        console.error('Error initializing related tools:', error);
        // Don't break the page - just log the error
    }
})();
</script>

<style>
/* ========== Related Tools Section ========== */
.related-tools-section {
    margin-top: 3rem;
    padding: 0;
}

.related-tools-card {
    background: var(--bg-primary, #ffffff);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 1rem;
    padding: 1.5rem 2rem 2rem;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
}

.related-tools-header {
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid var(--border, #e2e8f0);
}

.related-tools-header h3 {
    font-size: 1.25rem;
    font-weight: 600;
    color: var(--text-primary, #0f172a);
    margin: 0 0 0.25rem;
    display: flex;
    align-items: center;
}

.related-tools-header p {
    font-size: 0.875rem;
    color: var(--text-secondary, #475569);
    margin: 0;
}

/* ========== Related Tools Grid ========== */
.related-tools-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 1rem;
}

@media (max-width: 640px) {
    .related-tools-grid {
        grid-template-columns: 1fr;
    }
}

/* ========== Tool Item Cards ========== */
.related-tool-item {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    background: var(--bg-secondary, #f8fafc);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.75rem;
    text-decoration: none;
    transition: all 0.2s ease;
}

.related-tool-item:hover {
    background: var(--bg-primary, #ffffff);
    border-color: var(--primary, #6366f1);
    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.15);
    transform: translateY(-2px);
}

/* ========== Tool Icon ========== */
.related-tools-icon-svg {
    width: 24px;
    height: 24px;
    color: var(--primary, #6366f1);
    vertical-align: middle;
    margin-right: 0.5rem;
}

.related-tool-icon {
    width: 3rem;
    height: 3rem;
    background: var(--primary, #6366f1);
    border-radius: 0.625rem;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    padding: 0.5rem;
    color: white;
    transition: all 0.2s ease;
}

.related-tool-icon svg {
    width: 100%;
    height: 100%;
    max-width: 28px;
    max-height: 28px;
}

.related-tool-item:hover .related-tool-icon {
    background: var(--primary-dark, #4f46e5);
    transform: scale(1.05);
}

/* ========== Tool Content ========== */
.related-tool-content {
    flex: 1;
    min-width: 0;
}

.related-tool-content h4 {
    font-size: 0.9375rem;
    font-weight: 600;
    color: var(--text-primary, #0f172a);
    margin: 0 0 0.25rem;
    line-height: 1.3;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.related-tool-content p {
    font-size: 0.8125rem;
    color: var(--text-secondary, #475569);
    margin: 0;
    line-height: 1.4;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* ========== Tool Arrow ========== */
.related-tool-arrow {
    color: var(--text-muted, #94a3b8);
    transition: transform 0.2s ease, color 0.2s ease;
    flex-shrink: 0;
    width: 20px;
    height: 20px;
}

.related-tool-item:hover .related-tool-arrow {
    transform: translateX(4px);
    color: var(--primary, #6366f1);
}

/* ========== Loading State ========== */
.related-tools-loading {
    grid-column: 1 / -1;
    text-align: center;
    padding: 3rem 2rem;
    color: var(--text-secondary, #475569);
}

.loading-spinner {
    width: 40px;
    height: 40px;
    margin: 0 auto 1rem;
    color: var(--primary, #6366f1);
}

.related-tools-loading p {
    margin: 0;
    font-size: 0.9375rem;
}

/* ========== Empty/Error States ========== */
.related-tools-empty,
.related-tools-error {
    grid-column: 1 / -1;
    text-align: center;
    padding: 2rem;
    color: var(--text-secondary, #475569);
}

.related-tools-error {
    color: var(--error, #ef4444);
}

/* ========== DARK MODE ========== */
[data-theme="dark"] .related-tools-card {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.2);
}

[data-theme="dark"] .related-tools-header {
    border-bottom-color: var(--border, #334155);
}

[data-theme="dark"] .related-tools-header h3 {
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .related-tools-header p {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .related-tool-item {
    background: var(--bg-tertiary, #334155);
    border-color: var(--border, #475569);
}

[data-theme="dark"] .related-tool-item:hover {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--primary, #818cf8);
    box-shadow: 0 4px 12px rgba(129, 140, 248, 0.2);
}

[data-theme="dark"] .related-tool-icon {
    background: var(--primary, #818cf8);
}

[data-theme="dark"] .related-tool-item:hover .related-tool-icon {
    background: var(--primary-dark, #6366f1);
}

[data-theme="dark"] .related-tool-content h4 {
    color: var(--text-primary, #f1f5f9);
}

[data-theme="dark"] .related-tool-content p {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .related-tool-arrow {
    color: var(--text-muted, #64748b);
}

[data-theme="dark"] .related-tool-item:hover .related-tool-arrow {
    color: var(--primary, #818cf8);
}

[data-theme="dark"] .related-tools-loading {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .related-tools-empty {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .related-tools-error {
    color: var(--error, #f87171);
}
</style>


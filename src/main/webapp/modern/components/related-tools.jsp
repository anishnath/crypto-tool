<%--
  Related Tools Component
  Dynamically loads related tools from tools-database.json based on current tool's category/keywords
  
  Parameters:
  - currentToolUrl (required): Current tool's JSP filename (e.g., "CipherFunctions.jsp")
  - category (optional): Filter by category (e.g., "Cryptography")
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
        limit: <%=limit%>,
        excludeUrls: '<%=escapeJs(excludeUrls)%>'.split(',').map(function(url) { return url.trim(); }).filter(function(url) { return url !== ''; }),
        toolsDatabasePath: '<%=escapeJs(request.getContextPath() != null ? request.getContextPath() : "")%>/modern/data/tools-database.json'
    };
    
    // SVG Icon mapping for different tool types
    const toolIcons = {
        'hash': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="4" y1="9" x2="20" y2="9"></line>
            <line x1="4" y1="15" x2="20" y2="15"></line>
            <line x1="10" y1="3" x2="8" y2="21"></line>
            <line x1="16" y1="3" x2="14" y2="21"></line>
        </svg>`,
        'encryption': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
        </svg>`,
        'encode': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="16 18 22 12 16 6"></polyline>
            <polyline points="8 6 2 12 8 18"></polyline>
        </svg>`,
        'fingerprint': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M2 12C2 6.48 6.48 2 12 2s10 4.48 10 10"></path>
            <path d="M4.93 4.93a9.97 9.97 0 0 1 14.14 0"></path>
            <path d="M7.76 7.76a6 6 0 0 1 8.48 0"></path>
            <circle cx="12" cy="12" r="2"></circle>
        </svg>`,
        'lock': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
        </svg>`,
        'trophy': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path>
            <path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path>
            <path d="M4 22h16"></path>
            <path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22"></path>
            <path d="M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22"></path>
            <path d="M18 2H6v7a6 6 0 0 0 12 0V2Z"></path>
        </svg>`,
        'ticket': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z"></path>
            <path d="M13 5v2"></path>
            <path d="M13 17v2"></path>
            <path d="M13 11v2"></path>
        </svg>`,
        'default': `<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <path d="M12 6v6l4 2"></path>
        </svg>`
    };
    
    // Determine icon based on tool name/keywords
    function getToolIcon(tool) {
        const name = tool.name.toLowerCase();
        const keywords = (tool.keywords || '').toLowerCase();
        
        if (name.includes('hash') || keywords.includes('hash')) {
            return toolIcons.hash;
        } else if (name.includes('encrypt') || name.includes('decrypt') || name.includes('cipher') || keywords.includes('encrypt') || keywords.includes('decrypt')) {
            return toolIcons.encryption;
        } else if (name.includes('base64') || name.includes('base32') || name.includes('encode') || name.includes('decode')) {
            return toolIcons.encode;
        } else if (name.includes('hmac') || name.includes('sign') || keywords.includes('hmac')) {
            return toolIcons.fingerprint;
        } else if (name.includes('bcrypt') || name.includes('password') || keywords.includes('password')) {
            return toolIcons.lock;
        } else if (name.includes('argon') || name.includes('winner') || keywords.includes('phc')) {
            return toolIcons.trophy;
        } else if (name.includes('jwt') || name.includes('token')) {
            return toolIcons.ticket;
        }
        
        return toolIcons.default;
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
            
            // Filter tools
            tools = tools.filter(tool => {
                if (!tool || !tool.url) {
                    return false;
                }
                
                // Exclude current tool and specified exclusions
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
                
                return true;
            });
            
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
        if (descEl && config.category) {
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
/* Related Tools Section - SVG Icons */
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
    border-radius: 0.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    padding: 0.5rem;
    color: white;
    transition: all 0.3s ease;
}

.related-tool-icon svg {
    width: 100%;
    height: 100%;
    max-width: 32px;
    max-height: 32px;
}

.related-tool-item:hover .related-tool-icon {
    background: var(--primary-dark, #4f46e5);
    transform: scale(1.05);
}

.related-tool-arrow {
    color: var(--text-muted, #94a3b8);
    font-size: 1rem;
    transition: transform 0.3s ease, color 0.3s ease;
    flex-shrink: 0;
    width: 20px;
    height: 20px;
}

.related-tool-item:hover .related-tool-arrow {
    transform: translateX(4px);
    color: var(--primary, #6366f1);
}

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

/* Dark mode support */
[data-theme="dark"] .related-tool-icon {
    background: var(--primary-light, #818cf8);
}

[data-theme="dark"] .related-tool-item:hover .related-tool-icon {
    background: var(--primary, #6366f1);
}

[data-theme="dark"] .related-tools-loading {
    color: var(--text-secondary, #cbd5e1);
}

[data-theme="dark"] .related-tools-empty {
    color: var(--text-secondary, #cbd5e1);
}
</style>


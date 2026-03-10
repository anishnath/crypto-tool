/**
 * Recent Tools Tracking
 * Tracks tool usage in localStorage and displays in navigation
 */

function resolveToolUrl(url) {
    if (typeof window.__resolveToolUrl === 'function') {
        return window.__resolveToolUrl(url);
    }
    return url;
}

// Track tool visit
function trackToolVisit(toolName, toolUrl, category) {
    try {
        const normalizedUrl = resolveToolUrl(toolUrl);
        let recent = JSON.parse(localStorage.getItem('recentTools') || '[]');
        
        // Remove if already exists
        recent = recent.filter(t => resolveToolUrl(t.url) !== normalizedUrl);
        
        // Add to beginning
        recent.unshift({
            name: toolName,
            url: normalizedUrl,
            category: category,
            timestamp: Date.now()
        });
        
        // Keep only last 10
        recent = recent.slice(0, 10);
        
        localStorage.setItem('recentTools', JSON.stringify(recent));
        
        // Update UI if drawer is open
        updateRecentToolsDisplay();
    } catch (e) {
        console.warn('Failed to track tool visit:', e);
    }
}

// Get recent tools
function getRecentTools() {
    try {
        return JSON.parse(localStorage.getItem('recentTools') || '[]');
    } catch (e) {
        return [];
    }
}

// Update recent tools display in drawer
function updateRecentToolsDisplay() {
    const recentToolsContainer = document.getElementById('recentToolsList');
    if (!recentToolsContainer) return;
    
    const recent = getRecentTools();
    
    if (recent.length === 0) {
        recentToolsContainer.innerHTML = '<p class="drawer-empty">No recently used tools</p>';
        return;
    }
    
    const html = recent.map(tool => {
        const icon = (typeof window.getToolIcon === 'function') ? window.getToolIcon(tool) : '🔧';
        const resolvedUrl = resolveToolUrl(tool.url);
        return `
        <a href="${resolvedUrl}" class="drawer-link" onclick="trackToolClick('${tool.name}', '${tool.category}')">
            <span class="drawer-link-icon">${icon}</span>
            <div style="flex: 1;">
                <div style="font-weight: 500;">${escapeHtml(tool.name)}</div>
                <div style="font-size: 0.875rem; color: var(--text-muted);">${escapeHtml(tool.category)}</div>
            </div>
        </a>
    `;
    }).join('');
    
    recentToolsContainer.innerHTML = html;
}

// Track tool click for analytics
function trackToolClick(toolName, category) {
    if (typeof trackToolUsage === 'function') {
        trackToolUsage(toolName, category, 'navigation_click');
    }
}

// Escape HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    updateRecentToolsDisplay();
    
    // Track current page as tool visit (with delay to ensure DOM is ready)
    setTimeout(function() {
        const currentPath = window.location.pathname;
        const contextPath = window.__appContextPath || '';
        
        // Only track if it's a tool page (ends with .jsp and not index)
        if (currentPath && currentPath.endsWith('.jsp') && 
            !currentPath.includes('index') && 
            !currentPath.includes('setup') &&
            !currentPath.includes('footer')) {
            
            // Try to get tool name from various sources
            let toolName = document.title;
            if (toolName.includes(' Online')) {
                toolName = toolName.split(' Online')[0];
            } else if (toolName.includes(' - ')) {
                toolName = toolName.split(' - ')[0];
            }
            
            // Try to get category
            let category = 'Unknown';
            const categoryElement = document.querySelector('.tool-category-badge, .breadcrumb-current, .category-badge, [data-category]');
            if (categoryElement) {
                category = categoryElement.textContent.trim() || categoryElement.getAttribute('data-category') || 'Unknown';
            }
            
            const appRelativePath = contextPath && currentPath.startsWith(contextPath + '/')
                ? currentPath.substring(contextPath.length + 1)
                : currentPath.replace(/^\/+/, '');
            trackToolVisit(toolName, appRelativePath, category);
        }
    }, 500);
});

// Expose for use in other scripts
window.trackToolVisit = trackToolVisit;
window.getRecentTools = getRecentTools;

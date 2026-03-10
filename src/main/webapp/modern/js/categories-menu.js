/**
 * Categories Mega-Menu
 * Loads categories and tools from tools-database.json
 */

let categoriesData = null;
let toolsDatabase = null;

function resolveToolUrl(url) {
    if (typeof window.__resolveToolUrl === 'function') {
        return window.__resolveToolUrl(url);
    }
    return url;
}

// Load categories data (uses shared promise from nav-header.jsp)
async function loadCategoriesData() {
    if (categoriesData) return categoriesData;

    try {
        // Use shared database loader (single fetch across all scripts)
        const data = typeof window.__getToolsDatabase === 'function'
            ? await window.__getToolsDatabase()
            : null;

        if (!data) {
            console.warn('Categories: tools-database.json not available');
            return null;
        }

        toolsDatabase = data.tools || [];

        // Group tools by category
        const grouped = {};
        toolsDatabase.forEach(tool => {
            if (!tool || !tool.category || !tool.url) return;
            if (!grouped[tool.category]) {
                grouped[tool.category] = [];
            }
            // Avoid duplicates by checking URL
            const exists = grouped[tool.category].some(t => t.url === tool.url);
            if (!exists) {
                grouped[tool.category].push(tool);
            }
        });

        categoriesData = {
            categories: data.categories || [],
            toolsByCategory: grouped,
            totalTools: data.totalTools || 0
        };

        return categoriesData;
    } catch (error) {
        console.warn('Failed to load categories data:', error);
    }

    return null;
}

// Category icons mapping
const categoryIcons = {
    'Security & PKI': '🔒',
    'Cryptography': '🔐',
    'CTF & Challenges': '🚩',
    'Network Tools': '🌐',
    'Data Converters': '🔄',
    'DevOps & Infrastructure': '🐳',
    'Developer Tools': '💻',
    'Blockchain & Crypto': '⛓️',
    'File Sharing': '📁',
    'Finance': '💰',
    'Mathematics': '📊',
    'Chemistry': '🧪',
    'Physics': '⚛️',
    'Machine Learning': '🤖',
    'Media Tools': '🖼️',
    'Document Tools': '📄',
    'Productivity': '⚡',
    'Health': '❤️',
    'Legal & Compliance': '⚖️'
};

// Get icon for a tool based on its name, URL, and category
function getToolIcon(tool) {
    if (!tool) return '🔧';
    
    const url = (tool.url || '').toLowerCase();
    const name = (tool.name || '').toLowerCase();
    const category = (tool.category || '').toLowerCase();
    
    // URL-based matching (most specific)
    if (url.includes('pgp') || url.includes('key')) return '🔑';
    if (url.includes('ssl') || url.includes('tls') || url.includes('certificate') || url.includes('cert')) return '🔒';
    if (url.includes('dns') || url.includes('whois') || url.includes('subnet') || url.includes('ping') || url.includes('port')) return '🌐';
    if (url.includes('base64') || url.includes('encode') || url.includes('decode')) return '🔄';
    if (url.includes('json') || url.includes('xml') || url.includes('yaml')) return '📝';
    if (url.includes('cipher') || url.includes('encrypt') || url.includes('decrypt') || url.includes('hash') || url.includes('hmac')) return '🔐';
    if (url.includes('rsa') || url.includes('dsa') || url.includes('ec') || url.includes('elgamal')) return '🔐';
    if (url.includes('kubernetes') || url.includes('kube') || url.includes('docker')) return '🐳';
    if (url.includes('pdf')) return '📄';
    if (url.includes('image') || url.includes('jpg') || url.includes('png') || url.includes('gif') || url.includes('svg')) return '🖼️';
    if (url.includes('video')) return '🎥';
    if (url.includes('calculator') || url.includes('calc')) return '🧮';
    if (url.includes('qr') || url.includes('barcode')) return '📱';
    if (url.includes('email') || url.includes('mail')) return '📧';
    if (url.includes('url') || url.includes('short')) return '🔗';
    if (url.includes('password') || url.includes('passwd')) return '🔐';
    if (url.includes('uuid') || url.includes('guid')) return '🆔';
    if (url.includes('regex')) return '🔍';
    if (url.includes('diff') || url.includes('compare')) return '⚖️';
    if (url.includes('compiler') || url.includes('code') || url.includes('editor')) return '💻';
    if (url.includes('share') || url.includes('paste') || url.includes('bin')) return '📤';
    if (url.includes('finance') || url.includes('emi') || url.includes('interest') || url.includes('stock')) return '💰';
    if (url.includes('chemistry') || url.includes('molar') || url.includes('molecule') || url.includes('periodic')) return '🧪';
    if (url.includes('physics') || url.includes('motion') || url.includes('force') || url.includes('energy') || url.includes('circuit')) return '⚛️';
    if (url.includes('math') || url.includes('matrix') || url.includes('equation') || url.includes('derivative') || url.includes('integral')) return '📊';
    if (url.includes('blockchain') || url.includes('crypto') || url.includes('ethereum') || url.includes('wallet') || url.includes('bip39')) return '⛓️';
    if (url.includes('machine') || url.includes('learning') || url.includes('neural') || url.includes('ml')) return '🤖';
    if (url.includes('health') || url.includes('bmi') || url.includes('calorie')) return '❤️';
    if (url.includes('network') || url.includes('ipv6') || url.includes('curl') || url.includes('websocket')) return '🌐';
    
    // Name-based matching (fallback)
    if (name.includes('pgp') || name.includes('key') || name.includes('ssh')) return '🔑';
    if (name.includes('ssl') || name.includes('certificate') || name.includes('cert') || name.includes('jwt') || name.includes('jws') || name.includes('jwk')) return '🔒';
    if (name.includes('dns') || name.includes('whois') || name.includes('subnet') || name.includes('ping') || name.includes('port') || name.includes('network')) return '🌐';
    if (name.includes('base64') || name.includes('encode') || name.includes('decode') || name.includes('convert')) return '🔄';
    if (name.includes('json') || name.includes('xml') || name.includes('yaml') || name.includes('csv')) return '📝';
    if (name.includes('cipher') || name.includes('encrypt') || name.includes('decrypt') || name.includes('hash') || name.includes('hmac') || name.includes('message digest')) return '🔐';
    if (name.includes('rsa') || name.includes('dsa') || name.includes('ec') || name.includes('elgamal')) return '🔐';
    if (name.includes('kubernetes') || name.includes('kube') || name.includes('docker') || name.includes('ansible') || name.includes('devops')) return '🐳';
    if (name.includes('pdf')) return '📄';
    if (name.includes('image') || name.includes('jpg') || name.includes('png') || name.includes('gif') || name.includes('svg')) return '🖼️';
    if (name.includes('video')) return '🎥';
    if (name.includes('calculator') || name.includes('calc')) return '🧮';
    if (name.includes('qr') || name.includes('barcode')) return '📱';
    if (name.includes('email') || name.includes('mail')) return '📧';
    if (name.includes('url') || name.includes('short')) return '🔗';
    if (name.includes('password') || name.includes('passwd')) return '🔐';
    if (name.includes('uuid') || name.includes('guid')) return '🆔';
    if (name.includes('regex')) return '🔍';
    if (name.includes('diff') || name.includes('compare')) return '⚖️';
    if (name.includes('compiler') || name.includes('code') || name.includes('editor')) return '💻';
    if (name.includes('share') || name.includes('paste') || name.includes('bin')) return '📤';
    if (name.includes('finance') || name.includes('emi') || name.includes('interest') || name.includes('stock')) return '💰';
    if (name.includes('chemistry') || name.includes('molar') || name.includes('molecule') || name.includes('periodic') || name.includes('chemical')) return '🧪';
    if (name.includes('physics') || name.includes('motion') || name.includes('force') || name.includes('energy') || name.includes('circuit') || name.includes('ohm')) return '⚛️';
    if (name.includes('math') || name.includes('matrix') || name.includes('equation') || name.includes('derivative') || name.includes('integral') || name.includes('statistics')) return '📊';
    if (name.includes('blockchain') || name.includes('crypto') || name.includes('ethereum') || name.includes('wallet') || name.includes('bip39')) return '⛓️';
    if (name.includes('machine') || name.includes('learning') || name.includes('neural') || name.includes('ml')) return '🤖';
    if (name.includes('health') || name.includes('bmi') || name.includes('calorie')) return '❤️';
    
    // Category-based fallback
    if (category.includes('security') || category.includes('pki')) return '🔒';
    if (category.includes('cryptography')) return '🔐';
    if (category.includes('network')) return '🌐';
    if (category.includes('data converters') || category.includes('encoders')) return '🔄';
    if (category.includes('devops') || category.includes('infrastructure')) return '🐳';
    if (category.includes('developer')) return '💻';
    if (category.includes('blockchain') || category.includes('crypto')) return '⛓️';
    if (category.includes('file sharing') || category.includes('sharing')) return '📁';
    if (category.includes('finance')) return '💰';
    if (category.includes('mathematics') || category.includes('math')) return '📊';
    if (category.includes('chemistry')) return '🧪';
    if (category.includes('physics')) return '⚛️';
    if (category.includes('machine learning') || category.includes('ml')) return '🤖';
    if (category.includes('media')) return '🖼️';
    if (category.includes('document')) return '📄';
    if (category.includes('productivity')) return '⚡';
    if (category.includes('health')) return '❤️';
    if (category.includes('legal') || category.includes('compliance')) return '⚖️';
    
    // Default
    return '🔧';
}

// Get top tools for a category (limit to 12)
function getTopToolsForCategory(category, limit = 12) {
    if (!toolsDatabase) return [];
    
    const tools = toolsDatabase.filter(t => t.category === category);
    
    // Popular tools first (can be enhanced with analytics later)
    const popularUrls = [
        'pgpencdec.jsp',
        'jwkconvertfunctions.jsp',
        'sshfunctions.jsp',
        'PemParserFunctions.jsp',
        'rsafunctions.jsp',
        '/online-compiler'
    ];
    
    // Sort: popular first, then alphabetically
    return tools.sort((a, b) => {
        const aPopular = popularUrls.includes(a.url) ? 1 : 0;
        const bPopular = popularUrls.includes(b.url) ? 1 : 0;
        if (aPopular !== bPopular) return bPopular - aPopular;
        return a.name.localeCompare(b.name);
    }).slice(0, limit);
}

// Render categories mega-menu
async function renderCategoriesMegaMenu() {
    const container = document.getElementById('categoriesMegaMenu');
    if (!container) return;
    
    const data = await loadCategoriesData();
    if (!data) {
        return;
    }
    
    // Find content container or create it
    let contentContainer = container.querySelector('.mega-menu-content');
    if (!contentContainer) {
        contentContainer = document.createElement('div');
        contentContainer.className = 'mega-menu-content';
        container.innerHTML = '';
        container.appendChild(contentContainer);
    }
    
    // Define category order for menu (PGP tools are in Security & PKI, so Security & PKI is first)
    const categoryOrder = [
        'Security & PKI',         // PGP tools are here - put first
        'File Sharing',           // Sharing tool
        'Cryptography',           // Cryptography
        'Network Tools',          // Network
        'DevOps & Infrastructure', // Devops
        'Data Converters',        // Encoders/Decoders
        'Developer Tools'         // Developer tool
    ];
    
    // Sort categories: order specified items first, then others alphabetically
    const categories = [...data.categories].sort((a, b) => {
        const aIndex = categoryOrder.indexOf(a);
        const bIndex = categoryOrder.indexOf(b);
        
        // Both in ordered list
        if (aIndex !== -1 && bIndex !== -1) {
            return aIndex - bIndex;
        }
        // Only a in ordered list
        if (aIndex !== -1) {
            return -1;
        }
        // Only b in ordered list
        if (bIndex !== -1) {
            return 1;
        }
        // Neither in ordered list, sort alphabetically
        return a.localeCompare(b);
    });
    
    let html = '';
    
    categories.forEach((category) => {
        const allToolsInCategory = data.toolsByCategory[category] || [];
        // Show all tools, sorted by popularity first
        const tools = getTopToolsForCategory(category, allToolsInCategory.length);
        const icon = categoryIcons[category] || '📦';
        const toolCount = allToolsInCategory.length;
        
        // Debug: Log actual counts to console
        if (toolCount === 0) {
            console.warn(`Category "${category}" has no tools!`);
        }
        
        html += `
            <div class="mega-menu-column">
                <div class="mega-menu-category-header">
                    <span class="mega-menu-icon">${icon}</span>
                    <div>
                        <div class="mega-menu-category-name">${category}</div>
                        <div class="mega-menu-tool-count">${toolCount} tool${toolCount !== 1 ? 's' : ''}</div>
                    </div>
                </div>
                <ul class="mega-menu-tool-list">
        `;
        
        tools.forEach(tool => {
            const icon = getToolIcon(tool);
            const resolvedUrl = resolveToolUrl(tool.url);
            html += `
                <li>
                    <a href="${resolvedUrl}" class="mega-menu-tool-link" onclick="if(typeof trackToolVisit==='function')trackToolVisit('${escapeHtml(tool.name).replace(/'/g, "\\'")}', '${resolvedUrl}', '${category.replace(/'/g, "\\'")}');">
                        <span class="tool-icon-small">${icon}</span>
                        ${escapeHtml(tool.name)}
                    </a>
                </li>
            `;
        });
        
        html += `
                </ul>
            </div>
        `;
    });
    
    contentContainer.innerHTML = html;
}

// Render categories in mobile drawer
async function renderCategoriesInDrawer() {
    const container = document.getElementById('drawerCategoriesList');
    if (!container) return;
    
    const data = await loadCategoriesData();
    if (!data) {
        return;
    }
    
    // Define category order for menu (same as mega-menu)
    const categoryOrder = [
        'Security & PKI',         // PGP tools are here - put first
        'File Sharing',           // Sharing tool
        'Cryptography',           // Cryptography
        'Network Tools',          // Network
        'DevOps & Infrastructure', // Devops
        'Data Converters',        // Encoders/Decoders
        'Developer Tools'         // Developer tool
    ];
    
    // Sort categories: order specified items first, then others alphabetically
    const sortedCategories = [...data.categories].sort((a, b) => {
        const aIndex = categoryOrder.indexOf(a);
        const bIndex = categoryOrder.indexOf(b);
        
        if (aIndex !== -1 && bIndex !== -1) {
            return aIndex - bIndex;
        }
        if (aIndex !== -1) {
            return -1;
        }
        if (bIndex !== -1) {
            return 1;
        }
        return a.localeCompare(b);
    });
    
    let html = '';
    
    sortedCategories.forEach(category => {
        const allTools = data.toolsByCategory[category] || [];
        const icon = categoryIcons[category] || '📦';
        const toolCount = allTools.length;
        const categoryId = category.replace(/\s+/g, '-').replace(/[&]/g, '');
        
        // Show ALL tools, sorted by popularity first
        const sortedTools = getTopToolsForCategory(category, allTools.length);
        
        html += `
            <div class="drawer-category-item">
                <button class="drawer-category-toggle" onclick="toggleCategorySection('${categoryId}')">
                    <span class="drawer-category-icon">${icon}</span>
                    <span class="drawer-category-name">${escapeHtml(category)}</span>
                    <span class="drawer-category-count">${toolCount}</span>
                    <span class="drawer-category-arrow">▶</span>
                </button>
                <div class="drawer-category-content" id="category-${categoryId}">
                    <div class="drawer-category-tools">
                        ${sortedTools.map(tool => {
                            const icon = getToolIcon(tool);
                            const resolvedUrl = resolveToolUrl(tool.url);
                            return `
                            <a href="${resolvedUrl}" class="drawer-tool-link" onclick="if(typeof trackToolVisit==='function')trackToolVisit('${escapeHtml(tool.name).replace(/'/g, "\\'")}', '${resolvedUrl}', '${category.replace(/'/g, "\\'")}');">
                                <span class="tool-icon-small">${icon}</span>
                                ${escapeHtml(tool.name)}
                            </a>
                        `;
                        }).join('')}
                    </div>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

// Toggle category section in drawer
function toggleCategorySection(categoryId) {
    const section = document.getElementById(`category-${categoryId}`);
    if (!section) return;
    
    const button = event.target.closest('.drawer-category-toggle');
    if (!button) return;
    
    const arrow = button.querySelector('.drawer-category-arrow');
    if (!arrow) return;
    
    if (section.classList.contains('open')) {
        section.classList.remove('open');
        arrow.textContent = '▶';
    } else {
        // Close other sections
        document.querySelectorAll('.drawer-category-content.open').forEach(s => {
            s.classList.remove('open');
            const prevButton = s.previousElementSibling;
            if (prevButton && prevButton.classList.contains('drawer-category-toggle')) {
                const prevArrow = prevButton.querySelector('.drawer-category-arrow');
                if (prevArrow) prevArrow.textContent = '▶';
            }
        });
        
        section.classList.add('open');
        arrow.textContent = '▼';
    }
}

// Escape HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', function() {
    renderCategoriesMegaMenu();
    renderCategoriesInDrawer();
});

// Expose functions
window.toggleCategorySection = toggleCategorySection;
window.getToolIcon = getToolIcon; // Make available for search and other components

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Modern Navigation Header
    Mobile-first, no Bootstrap dependency
--%>

<nav class="modern-nav" role="navigation" aria-label="Main navigation">
    <div class="nav-container">
        <!-- Logo -->
        <a href="<%=request.getContextPath()%>/" class="nav-logo" aria-label="8gwifi.org Home">
            <img src="<%=request.getContextPath()%>/images/site/logo.svg"
                 alt="8gwifi.org logo" 
                 width="32"
                 height="32"
                 loading="eager"
                 onerror="this.onerror=null;this.src='<%=request.getContextPath()%>/images/site/logo.png';this.width=32;this.height=32;">
            <span>8gwifi.org</span>
        </a>

        <!-- Desktop Search -->
        <div class="nav-search">
            <input type="search" 
                   class="search-input" 
                   placeholder="Search 200+ tools..." 
                   aria-label="Search tools">
            <span class="search-icon">🔍</span>
        </div>

        <!-- Desktop Navigation -->
        <ul class="nav-items">
            <li class="nav-item nav-item-dropdown">
                <button class="nav-link nav-link-dropdown" id="categoriesDropdownBtn" aria-haspopup="true" aria-expanded="false">
                    Categories <span class="dropdown-arrow">▼</span>
                </button>
                <!-- Categories Mega-Menu -->
                <div class="mega-menu" id="categoriesMegaMenu" role="menu" aria-labelledby="categoriesDropdownBtn">
                    <div class="mega-menu-content" id="megaMenuContent">
                        <!-- Populated by categories-menu.js -->
                        <p style="padding: 2rem; text-align: center; color: var(--text-muted);">Loading categories...</p>
                    </div>
                </div>
            </li>
            <li class="nav-item">
                <a href="<%=request.getContextPath()%>/tutorials/" class="nav-link">
                    <span>📚</span>
                    <span>Tutorials</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="https://in.linkedin.com/in/anishnath" target="_blank" rel="noopener" class="nav-link">
                    <span>💼</span>
                    <span>LinkedIn</span>
                </a>
            </li>
        </ul>

        <!-- Action Buttons -->
        <div class="nav-actions">
            <a href="https://buymeacoffee.com/8gwifi.org" 
               target="_blank" 
               rel="noopener" 
               class="btn-nav btn-nav-primary"
               aria-label="Buy me a coffee">
                <span>☕</span>
                <span class="nav-text">Coffee</span>
            </a>
            <a href="https://twitter.com/anish2good" 
               target="_blank" 
               rel="noopener" 
               class="btn-nav btn-nav-secondary"
               aria-label="Follow on Twitter/X">
                <span>𝕏</span>
                <span class="nav-text">Follow</span>
            </a>
            <button class="mobile-search-toggle" aria-label="Open search">
                🔍
            </button>
            <button class="mobile-menu-toggle" aria-label="Open menu">
                ☰
            </button>
        </div>
    </div>
</nav>

<!-- Mobile Drawer -->
<div class="mobile-drawer" id="mobileDrawer" role="dialog" aria-label="Navigation menu">
    <div class="drawer-header">
        <h2 class="drawer-title">Menu</h2>
        <button class="drawer-close" aria-label="Close menu" onclick="closeMobileDrawer()">
            ×
        </button>
    </div>

    <div class="drawer-search">
        <input type="search" 
               class="search-input" 
               placeholder="Search tools..." 
               aria-label="Search tools">
    </div>

    <div class="drawer-content">
        <!-- Popular Tools Section -->
        <div class="drawer-section">
            <h3 class="drawer-section-title">⭐ Popular Tools</h3>
            <div id="popularToolsList">
                <a href="<%=request.getContextPath()%>/Base64Functions.jsp" class="drawer-link">
                    <span class="drawer-link-icon">🔄</span>
                    <span>Base64 Encoder/Decoder</span>
                </a>
                <a href="<%=request.getContextPath()%>/jsonparser.jsp" class="drawer-link">
                    <span class="drawer-link-icon">📝</span>
                    <span>JSON Beautifier</span>
                </a>
                <a href="<%=request.getContextPath()%>/CipherFunctions.jsp" class="drawer-link">
                    <span class="drawer-link-icon">🔐</span>
                    <span>Cipher Encryption</span>
                </a>
                <a href="<%=request.getContextPath()%>/dns.jsp" class="drawer-link">
                    <span class="drawer-link-icon">🌐</span>
                    <span>DNS Lookup</span>
                </a>
                <a href="<%=request.getContextPath()%>/rsafunctions.jsp" class="drawer-link">
                    <span class="drawer-link-icon">🔒</span>
                    <span>RSA Encryption</span>
                </a>
            </div>
        </div>

        <!-- Recently Used Tools -->
        <div class="drawer-section">
            <h3 class="drawer-section-title">🕒 Recently Used</h3>
            <div id="recentToolsList">
                <p class="drawer-empty">No recently used tools</p>
            </div>
        </div>

        <!-- Categories Section -->
        <div class="drawer-section">
            <h3 class="drawer-section-title">📁 All Categories</h3>
            <div id="drawerCategoriesList">
                <!-- Populated by categories-menu.js -->
                <p class="drawer-loading">Loading categories...</p>
            </div>
        </div>

        <!-- Quick Links -->
        <div class="drawer-section">
            <h3 class="drawer-section-title">Quick Links</h3>
            <a href="<%=request.getContextPath()%>/tutorials/" class="drawer-link">
                <span class="drawer-link-icon">📚</span>
                <span>Tutorials</span>
            </a>
            <a href="https://in.linkedin.com/in/anishnath" target="_blank" rel="noopener" class="drawer-link">
                <span class="drawer-link-icon">💼</span>
                <span>LinkedIn</span>
            </a>
            <a href="<%=request.getContextPath()%>/jsonparser.jsp" class="drawer-link">
                <span class="drawer-link-icon">📝</span>
                <span>JSON Beautifier</span>
            </a>
        </div>

        <!-- Support -->
        <div class="drawer-section">
            <h3 class="drawer-section-title">Support</h3>
            <a href="https://buymeacoffee.com/8gwifi.org" target="_blank" rel="noopener" class="drawer-link">
                <span class="drawer-link-icon">☕</span>
                <span>Buy me a coffee</span>
            </a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="drawer-link">
                <span class="drawer-link-icon">𝕏</span>
                <span>Follow on Twitter</span>
            </a>
        </div>
    </div>
</div>

<!-- Drawer Overlay -->
<div class="drawer-overlay" id="drawerOverlay" onclick="closeMobileDrawer()"></div>

<!-- Mobile Search Modal -->
<div class="mobile-search-modal" id="mobileSearchModal">
    <div class="mobile-search-header">
        <input type="search" 
               class="mobile-search-input" 
               placeholder="Search 200+ tools..." 
               autofocus
               aria-label="Search tools">
        <button class="mobile-search-close" onclick="closeMobileSearch()" aria-label="Close search">
            ×
        </button>
    </div>
</div>

<script>
    // Mobile drawer functions
    function openMobileDrawer() {
        document.getElementById('mobileDrawer').classList.add('open');
        document.getElementById('drawerOverlay').classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeMobileDrawer() {
        document.getElementById('mobileDrawer').classList.remove('open');
        document.getElementById('drawerOverlay').classList.remove('open');
        document.body.style.overflow = '';
    }

    // Mobile search functions
    function openMobileSearch() {
        document.getElementById('mobileSearchModal').classList.add('open');
    }

    function closeMobileSearch() {
        document.getElementById('mobileSearchModal').classList.remove('open');
    }

    // Categories dropdown toggle
    let categoriesDropdownOpen = false;
    const categoriesDropdownBtn = document.getElementById('categoriesDropdownBtn');
    const categoriesMegaMenu = document.getElementById('categoriesMegaMenu');

    function toggleCategoriesDropdown() {
        categoriesDropdownOpen = !categoriesDropdownOpen;
        if (categoriesDropdownOpen) {
            categoriesMegaMenu.classList.add('show');
            categoriesDropdownBtn.setAttribute('aria-expanded', 'true');
            categoriesDropdownBtn.querySelector('.dropdown-arrow').textContent = '▲';
        } else {
            categoriesMegaMenu.classList.remove('show');
            categoriesDropdownBtn.setAttribute('aria-expanded', 'false');
            categoriesDropdownBtn.querySelector('.dropdown-arrow').textContent = '▼';
        }
    }

    function closeCategoriesDropdown() {
        if (categoriesDropdownOpen) {
            categoriesDropdownOpen = false;
            categoriesMegaMenu.classList.remove('show');
            categoriesDropdownBtn.setAttribute('aria-expanded', 'false');
            if (categoriesDropdownBtn) {
                const arrow = categoriesDropdownBtn.querySelector('.dropdown-arrow');
                if (arrow) arrow.textContent = '▼';
            }
        }
    }

    // Event listeners
    document.addEventListener('DOMContentLoaded', function() {
        // Categories dropdown
        if (categoriesDropdownBtn) {
            categoriesDropdownBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                toggleCategoriesDropdown();
            });
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (categoriesMegaMenu && !categoriesMegaMenu.contains(e.target) && 
                categoriesDropdownBtn && !categoriesDropdownBtn.contains(e.target)) {
                closeCategoriesDropdown();
            }
        });

        // Menu toggle
        const menuToggle = document.querySelector('.mobile-menu-toggle');
        if (menuToggle) {
            menuToggle.addEventListener('click', openMobileDrawer);
        }

        // Search toggle
        const searchToggle = document.querySelector('.mobile-search-toggle');
        if (searchToggle) {
            searchToggle.addEventListener('click', openMobileSearch);
        }

        // Close drawer on ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeMobileDrawer();
                closeMobileSearch();
                closeCategoriesDropdown();
            }
        });

        // Close dropdown on drawer open (mobile)
        const originalOpenDrawer = window.openMobileDrawer;
        window.openMobileDrawer = function() {
            closeCategoriesDropdown();
            originalOpenDrawer();
        };
    });

    // Expose functions globally
    window.openMobileDrawer = openMobileDrawer;
    window.closeMobileDrawer = closeMobileDrawer;
    window.openMobileSearch = openMobileSearch;
    window.closeMobileSearch = closeMobileSearch;
</script>

<!-- Categories Menu Script -->
<script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer onerror="console.warn('categories-menu.js failed to load')"></script>

<!-- Recent Tools Tracking -->
<script src="<%=request.getContextPath()%>/modern/js/recent-tools.js" defer onerror="console.warn('recent-tools.js failed to load')"></script>


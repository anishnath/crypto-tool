/**
 * Modern Search Functionality v2.1
 * Fast, client-side search for tools
 * Loads tools from tools-database.json
 * Safe to load multiple times (idempotent)
 * 
 * Version: 2.1 - Fixed JSON path detection with context path support
 */

// Version marker - check console to verify this version is loading
console.log('🔍 Search.js v2.1 loaded');

(function() {
    'use strict';
    
    // Prevent multiple initializations
    if (window._searchEngineInitialized) {
        console.log('⚠️ Search: Already initialized, skipping...');
        return;
    }
    window._searchEngineInitialized = true;
    console.log('🔍 Search: Initializing search engine v2.0...');

    // Tool database - stored in window for persistence across script loads
    // Use a reference to avoid variable declaration conflicts
    if (!window._searchToolsDatabase) {
        window._searchToolsDatabase = [];
    }
    // Use window property directly to avoid var declaration issues
    var getToolsDatabase = function() {
        return window._searchToolsDatabase;
    };
    var setToolsDatabase = function(data) {
        window._searchToolsDatabase = data;
    };

    // Load tools database from JSON file
    async function loadToolsDatabase() {
        try {
            // Find the script tag that loaded this file to get the correct base path
            let basePath = '';
            const scripts = document.querySelectorAll('script[src*="search.js"]');
            if (scripts.length > 0) {
                const scriptSrc = scripts[scripts.length - 1].getAttribute('src');
                if (scriptSrc) {
                    // Extract base: /mywebapp2_war_exploded/modern/js/search.js?v=2.0 -> /mywebapp2_war_exploded/modern/data/tools-database.json
                    basePath = scriptSrc.split('?')[0]; // Remove query params
                    basePath = basePath.replace('/js/search.js', '/data/tools-database.json');
                }
            }
            
            // Extract base path from current location as fallback
            const pathname = window.location.pathname;
            const origin = window.location.origin;
            
            // Build absolute path from current page location
            let absolutePath = '';
            if (pathname.includes('/modern/')) {
                // If page is in modern directory or subdirectory
                const modernIndex = pathname.indexOf('/modern/');
                absolutePath = pathname.substring(0, modernIndex) + '/modern/data/tools-database.json';
            } else {
                // Extract context path (everything before the JSP filename)
                const lastSlash = pathname.lastIndexOf('/');
                if (lastSlash > 0) {
                    absolutePath = pathname.substring(0, lastSlash + 1) + 'modern/data/tools-database.json';
                } else {
                    absolutePath = '/modern/data/tools-database.json';
                }
            }
            
            // Try multiple path strategies (most likely first)
            const pathsToTry = [
                basePath,  // Derived from script src (most reliable)
                absolutePath,  // Derived from current page path
                origin + absolutePath,  // Full URL with current path
                '../data/tools-database.json',  // Relative to js/ directory (if script is in /modern/js/)
                origin + '/modern/data/tools-database.json',  // Absolute from origin
                '/modern/data/tools-database.json'  // Absolute from root
            ].filter(p => p); // Remove empty strings
            
            console.log('🔍 Search: Trying to load database from:', pathsToTry[0] || 'various paths');
            
            for (const jsonPath of pathsToTry) {
                try {
                    const response = await fetch(jsonPath);
                    if (response.ok) {
                        const data = await response.json();
                        const db = data.tools || [];
                        setToolsDatabase(db);
                        console.log(`✅ Search: Loaded ${db.length} tools from ${jsonPath}`);
                        return db;
                    } else {
                        // Only log first attempt to avoid spam
                        if (jsonPath === pathsToTry[0]) {
                            console.log(`❌ Search: ${jsonPath} returned ${response.status}, trying alternatives...`);
                        }
                    }
                } catch (fetchError) {
                    // Silently continue to next path
                }
            }
            
            console.warn(`⚠️ Search: Failed to load tools database (tried ${pathsToTry.length} paths)`);
        } catch (error) {
            console.warn('⚠️ Search: Failed to load tools database:', error);
            // Fallback - use existing data if available
            const existing = getToolsDatabase();
            if (existing && existing.length > 0) {
                console.log('✅ Search: Using cached database');
                return existing;
            } else {
                setToolsDatabase([]);
                return [];
            }
        }
        return getToolsDatabase();
    }

    // Initialize database on load
    loadToolsDatabase();

    class SearchEngine {
        constructor() {
            this.results = [];
            this.searchInputs = [];
            this.resultsContainer = null;
            this.databaseReady = false;
            this.init();
        }

        async init() {
            // Ensure database is loaded
            const db = getToolsDatabase();
            if (!db || db.length === 0) {
                await loadToolsDatabase();
            }
            this.databaseReady = (getToolsDatabase() || []).length > 0;
            
            // Wait a bit for DOM to be fully ready
            await new Promise(resolve => setTimeout(resolve, 100));
            
            // Get all search inputs (try multiple times as they might load after)
            this.searchInputs = document.querySelectorAll('.search-input-hero, .search-input, .mobile-search-input');
            
            // Retry if no inputs found
            if (this.searchInputs.length === 0) {
                setTimeout(() => {
                    this.searchInputs = document.querySelectorAll('.search-input-hero, .search-input, .mobile-search-input');
                    if (this.searchInputs.length > 0) {
                        this.createResultsContainer();
                        this.attachListeners();
                        console.log('✅ Search: Initialized with', this.searchInputs.length, 'search inputs');
                    } else {
                        console.warn('⚠️ Search: No search inputs found');
                    }
                }, 500);
            } else {
                // Create results container
                this.createResultsContainer();
                
                // Attach event listeners
                this.attachListeners();
                console.log('✅ Search: Initialized with', this.searchInputs.length, 'search inputs');
            }
        }

        createResultsContainer() {
            // Check if container already exists
            let container = document.getElementById('searchResults');
            if (container) {
                this.resultsContainer = container;
                return;
            }
            
            this.resultsContainer = document.createElement('div');
            this.resultsContainer.className = 'search-results';
            this.resultsContainer.id = 'searchResults';
            document.body.appendChild(this.resultsContainer);
        }

        attachListeners() {
            if (!this.searchInputs || this.searchInputs.length === 0) {
                console.warn('⚠️ Search: No search inputs found to attach listeners');
                return;
            }
            
            this.searchInputs.forEach((input, index) => {
                if (!input) return;
                
                // Store original value to restore after cloning
                const originalValue = input.value;
                
                // Clone to remove existing listeners (prevents duplicates)
                const newInput = input.cloneNode(true);
                newInput.value = originalValue;
                if (input.parentNode) {
                    input.parentNode.replaceChild(newInput, input);
                }
                
                newInput.addEventListener('input', (e) => {
                    const value = e.target.value.trim();
                    if (value.length >= 2) {
                        this.handleSearch(value);
                    } else {
                        this.hideResults();
                    }
                });
                
                newInput.addEventListener('focus', (e) => {
                    const value = e.target.value.trim();
                    if (value.length >= 2) {
                        this.handleSearch(value);
                    }
                });
                
                newInput.addEventListener('keydown', (e) => this.handleKeydown(e));
                
                console.log(`✅ Search: Attached listeners to input ${index + 1}`);
            });

            // Close on outside click (only attach once)
            if (!window._searchClickHandler) {
                window._searchClickHandler = (e) => {
                    if (!e.target.closest('.search-wrapper, .nav-search, .drawer-search, .mobile-search-header, .search-input-hero, .search-input, .mobile-search-input, .search-results, #searchResults')) {
                        if (window._searchEngineInstance) {
                            window._searchEngineInstance.hideResults();
                        }
                    }
                };
                document.addEventListener('click', window._searchClickHandler);
            }
            
            // Re-position on scroll (only attach once)
            if (!window._searchScrollHandler) {
                let scrollTimeout;
                window._searchScrollHandler = () => {
                    clearTimeout(scrollTimeout);
                    scrollTimeout = setTimeout(() => {
                        if (window._searchEngineInstance && window._searchEngineInstance.resultsContainer && window._searchEngineInstance.resultsContainer.classList.contains('show')) {
                            window._searchEngineInstance.showResults(); // Re-position
                        }
                    }, 100);
                };
                window.addEventListener('scroll', window._searchScrollHandler);
            }
        }

        handleSearch(query) {
            const trimmed = query.trim().toLowerCase();
            
            if (trimmed.length < 2) {
                this.hideResults();
                return;
            }

            this.search(trimmed);
            this.displayResults();
        }

        search(query) {
            const db = getToolsDatabase() || [];
            if (!this.databaseReady || db.length === 0) {
                // Wait a bit and retry if database not loaded yet
                setTimeout(() => {
                    const retryDb = getToolsDatabase() || [];
                    if (retryDb.length > 0) {
                        this.search(query);
                    }
                }, 100);
                return;
            }
            
            const words = query.split(' ').filter(w => w.length > 0);
            
            this.results = db
                .map(tool => {
                    const searchText = `${tool.name} ${tool.category} ${tool.keywords}`.toLowerCase();
                    let score = 0;
                    
                    // Exact match bonus
                    if (searchText.includes(query)) score += 10;
                    
                    // Word matches
                    words.forEach(word => {
                        if (tool.name.toLowerCase().includes(word)) score += 5;
                        if (tool.keywords.toLowerCase().includes(word)) score += 3;
                        if (tool.category.toLowerCase().includes(word)) score += 2;
                        if (searchText.includes(word)) score += 1;
                    });
                    
                    return { ...tool, score };
                })
                .filter(tool => tool.score > 0)
                .sort((a, b) => b.score - a.score)
                .slice(0, 10);
        }

        displayResults() {
            if (this.results.length === 0) {
                this.resultsContainer.innerHTML = `
                    <div class="search-result-empty">
                        <p>No tools found. Try different keywords.</p>
                    </div>
                `;
                this.showResults();
                return;
            }

            const html = this.results.map(tool => {
                const escapedName = tool.name.replace(/'/g, "\\'").replace(/"/g, '&quot;');
                const escapedCategory = tool.category.replace(/'/g, "\\'").replace(/"/g, '&quot;');
                const icon = (typeof window.getToolIcon === 'function') ? window.getToolIcon(tool) : '🔧';
                return `
                    <a href="${tool.url}" class="search-result-item" onclick="if(window.trackSearchClick)window.trackSearchClick('${escapedName}', '${escapedCategory}')">
                        <span class="search-result-icon">${icon}</span>
                        <div class="search-result-content">
                            <div class="search-result-category">${tool.category}</div>
                            <div class="search-result-name">${this.highlightMatch(tool.name)}</div>
                        </div>
                    </a>
                `;
            }).join('');

            this.resultsContainer.innerHTML = html;
            this.showResults();
            
            // Track search results display
            const query = document.querySelector('.search-input-hero, .search-input')?.value || '';
            if (query && typeof trackSearch === 'function') {
                trackSearch(query, this.results.length);
            }
        }

        highlightMatch(text) {
            const query = document.querySelector('.search-input-hero, .search-input')?.value || '';
            if (!query) return text;
            
            // Escape HTML in text
            const div = document.createElement('div');
            div.textContent = text;
            const escapedText = div.innerHTML;
            
            const regex = new RegExp(`(${query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
            return escapedText.replace(regex, '<mark>$1</mark>');
        }

        showResults() {
            const activeInput = document.querySelector('.search-input-hero:focus, .search-input:focus, .mobile-search-input:focus') ||
                               document.querySelector('.search-input-hero, .search-input');
            const query = activeInput?.value.trim() || '';
            
            if (this.results.length > 0 || query.length >= 2) {
                this.resultsContainer.classList.add('show');
                
                // Position results container relative to active search input
                const searchWrapper = document.querySelector('.search-wrapper, .nav-search, .drawer-search, .mobile-search-header');
                const inputElement = activeInput || searchWrapper?.querySelector('input');
                
                if (inputElement) {
                    const rect = inputElement.getBoundingClientRect();
                    const containerRect = inputElement.closest('.nav-search, .search-wrapper, .drawer-search, .mobile-search-header')?.getBoundingClientRect() || rect;
                    
                    // Position below the search input/container
                    this.resultsContainer.style.position = 'fixed';
                    this.resultsContainer.style.top = `${containerRect.bottom + 10}px`;
                    this.resultsContainer.style.left = `${containerRect.left}px`;
                    this.resultsContainer.style.width = `${Math.max(containerRect.width, 300)}px`;
                    this.resultsContainer.style.maxWidth = '90vw';
                    this.resultsContainer.style.zIndex = '10000';
                } else if (searchWrapper) {
                    // Fallback positioning
                    const rect = searchWrapper.getBoundingClientRect();
                    this.resultsContainer.style.position = 'fixed';
                    this.resultsContainer.style.top = `${rect.bottom + 10}px`;
                    this.resultsContainer.style.left = `${rect.left}px`;
                    this.resultsContainer.style.width = `${Math.max(rect.width, 300)}px`;
                    this.resultsContainer.style.maxWidth = '90vw';
                    this.resultsContainer.style.zIndex = '10000';
                }
            }
        }

        hideResults() {
            this.resultsContainer.classList.remove('show');
        }

        handleKeydown(e) {
            const items = this.resultsContainer.querySelectorAll('.search-result-item');
            const current = Array.from(items).findIndex(item => item.classList.contains('selected'));
            
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                const next = current < items.length - 1 ? current + 1 : 0;
                this.selectResult(items, next);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                const prev = current > 0 ? current - 1 : items.length - 1;
                this.selectResult(items, prev);
            } else if (e.key === 'Enter' && current >= 0) {
                e.preventDefault();
                items[current].click();
            }
        }

        selectResult(items, index) {
            items.forEach(item => item.classList.remove('selected'));
            if (items[index]) {
                items[index].classList.add('selected');
                items[index].scrollIntoView({ block: 'nearest' });
            }
        }
    }

    // Track search result clicks (expose globally)
    window.trackSearchClick = function(toolName, category) {
        if (typeof trackToolUsage === 'function') {
            trackToolUsage(toolName, category, 'search_click');
        }
    };

    // Initialize search when DOM is ready
    function initializeSearch() {
        if (window._searchEngineInstance) {
            // Already initialized, but check if inputs exist
            const inputs = document.querySelectorAll('.search-input-hero, .search-input, .mobile-search-input');
            if (inputs.length > 0 && window._searchEngineInstance.searchInputs && window._searchEngineInstance.searchInputs.length === 0) {
                // Re-initialize if inputs were found later
                window._searchEngineInstance = new SearchEngine();
            }
            return;
        }
        
        window._searchEngineInstance = new SearchEngine();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            setTimeout(initializeSearch, 200);
        });
    } else {
        setTimeout(initializeSearch, 200);
    }

    // Retry initialization after nav-header loads (with delay)
    setTimeout(() => {
        const inputs = document.querySelectorAll('.search-input-hero, .search-input, .mobile-search-input');
        if (inputs.length > 0) {
            if (!window._searchEngineInstance || (window._searchEngineInstance.searchInputs && window._searchEngineInstance.searchInputs.length === 0)) {
                console.log('🔍 Search: Retrying initialization (inputs found)...');
                window._searchEngineInstance = new SearchEngine();
            }
        } else {
            console.warn('⚠️ Search: No search inputs found after retry');
        }
    }, 800);

})(); // End of IIFE

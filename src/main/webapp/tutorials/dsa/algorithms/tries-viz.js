/**
 * Tries SVG Visualization
 * Shows trie structure and operations
 */

(function () {
    'use strict';

    class TriesViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentView = 'structure';
            this.init();
        }

        init() {
            this.render();
            this.bindEvents();
        }

        bindEvents() {
            const buttons = this.container.querySelectorAll('.viz-tab-btn');
            buttons.forEach(btn => {
                btn.addEventListener('click', () => {
                    this.currentView = btn.dataset.view;
                    this.render();
                    this.bindEvents();
                });
            });
        }

        render() {
            this.container.innerHTML = `
                <div class="viz-header">
                    <h3>Trie (Prefix Tree) Visualizations</h3>
                    <p class="viz-subtitle">Efficient string search and prefix matching</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'structure' ? 'active' : ''}" data-view="structure">
                        🌳 Trie Structure
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'insert' ? 'active' : ''}" data-view="insert">
                        ➕ Insert
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'search' ? 'active' : ''}" data-view="search">
                        🔍 Search
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'autocomplete' ? 'active' : ''}" data-view="autocomplete">
                        📝 Autocomplete
                    </button>
                </div>

                <div class="viz-canvas">
                    ${this.renderCurrentView()}
                </div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'structure':
                    return this.renderStructure();
                case 'insert':
                    return this.renderInsert();
                case 'search':
                    return this.renderSearch();
                case 'autocomplete':
                    return this.renderAutocomplete();
                default:
                    return '';
            }
        }

        renderStructure() {
            return `
                <div class="tree-viz-section">
                    <h4>Trie Structure</h4>
                    <p class="viz-description">Words: "app", "apple", "apply" - Each path from root to ⭐ is a word</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        <!-- Root -->
                        <circle cx="400" cy="60" r="25" fill="#9C27B0" stroke="#7B1FA2" stroke-width="3"/>
                        <text x="400" y="68" text-anchor="middle" font-size="16" font-weight="bold" fill="white">∅</text>
                        <text x="400" y="30" text-anchor="middle" font-size="14" font-weight="bold" fill="#9C27B0">ROOT</text>
                        
                        <!-- Level 1: 'a' -->
                        <line x1="400" y1="85" x2="400" y2="130" stroke="#666" stroke-width="2"/>
                        <text x="410" y="110" font-size="14" fill="#666">a</text>
                        <circle cx="400" cy="150" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="400" y="158" text-anchor="middle" font-size="16" font-weight="bold" fill="white">a</text>
                        
                        <!-- Level 2: 'p' -->
                        <line x1="400" y1="175" x2="400" y2="220" stroke="#666" stroke-width="2"/>
                        <text x="410" y="200" font-size="14" fill="#666">p</text>
                        <circle cx="400" cy="240" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="400" y="248" text-anchor="middle" font-size="16" font-weight="bold" fill="white">p</text>
                        
                        <!-- Level 3: 'p' and 'l' -->
                        <line x1="400" y1="265" x2="300" y2="310" stroke="#666" stroke-width="2"/>
                        <text x="340" y="290" font-size="14" fill="#666">p</text>
                        <circle cx="300" cy="330" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="300" y="338" text-anchor="middle" font-size="16" font-weight="bold" fill="white">p</text>
                        <text x="330" y="338" font-size="20" fill="#4CAF50">⭐</text>
                        <text x="300" y="370" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">"app"</text>
                        
                        <line x1="400" y1="265" x2="500" y2="310" stroke="#666" stroke-width="2"/>
                        <text x="460" y="290" font-size="14" fill="#666">l</text>
                        <circle cx="500" cy="330" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="500" y="338" text-anchor="middle" font-size="16" font-weight="bold" fill="white">l</text>
                        
                        <!-- Level 4: 'y' and 'e' -->
                        <line x1="300" y1="355" x2="250" y2="400" stroke="#666" stroke-width="2"/>
                        <text x="265" y="380" font-size="14" fill="#666">y</text>
                        <circle cx="250" cy="420" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="250" y="428" text-anchor="middle" font-size="16" font-weight="bold" fill="white">y</text>
                        <text x="280" y="428" font-size="20" fill="#4CAF50">⭐</text>
                        <text x="250" y="460" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">"apply"</text>
                        
                        <line x1="500" y1="355" x2="550" y2="400" stroke="#666" stroke-width="2"/>
                        <text x="535" y="380" font-size="14" fill="#666">e</text>
                        <circle cx="550" cy="420" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="428" text-anchor="middle" font-size="16" font-weight="bold" fill="white">e</text>
                        <text x="580" y="428" font-size="20" fill="#4CAF50">⭐</text>
                        <text x="550" y="460" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">"apple"</text>
                        
                        <!-- Key -->
                        <g transform="translate(50, 500)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Key Concepts:</text>
                            <circle cx="10" cy="25" r="8" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="25" y="30" font-size="14" fill="var(--text-secondary)">Intermediate node</text>
                            
                            <circle cx="10" cy="50" r="8" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="25" y="30" font-size="20" fill="#4CAF50">⭐</text>
                            <text x="40" y="55" font-size="14" fill="var(--text-secondary)">End of word</text>
                            
                            <text x="250" y="30" font-size="14" fill="var(--text-secondary)">• Each path = one word</text>
                            <text x="250" y="55" font-size="14" fill="var(--text-secondary)">• Shared prefixes save space</text>
                            <text x="250" y="80" font-size="14" fill="var(--text-secondary)">• "app" is prefix of "apple"</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderInsert() {
            return `
                <div class="tree-viz-section">
                    <h4>Insert "cat" into Trie</h4>
                    <p class="viz-description">Create nodes for each character, mark end of word</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        <!-- Existing trie (app, apple) -->
                        <g opacity="0.3">
                            <circle cx="400" cy="60" r="20" fill="#9C27B0" stroke="#7B1FA2" stroke-width="2"/>
                            <text x="400" y="67" text-anchor="middle" font-size="14" fill="white">∅</text>
                            
                            <line x1="400" y1="80" x2="350" y2="120" stroke="#666" stroke-width="2"/>
                            <circle cx="350" cy="135" r="20" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="350" y="142" text-anchor="middle" font-size="14" fill="white">a</text>
                        </g>
                        
                        <!-- New path for "cat" -->
                        <text x="400" y="30" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Inserting "cat"</text>
                        
                        <!-- Root -->
                        <circle cx="400" cy="80" r="25" fill="#9C27B0" stroke="#7B1FA2" stroke-width="3"/>
                        <text x="400" y="88" text-anchor="middle" font-size="16" font-weight="bold" fill="white">∅</text>
                        
                        <!-- Step 1: 'c' -->
                        <line x1="400" y1="105" x2="500" y2="150" stroke="#FF5722" stroke-width="3"/>
                        <text x="460" y="130" font-size="14" font-weight="bold" fill="#FF5722">c (new)</text>
                        <circle cx="500" cy="170" r="25" fill="#FF5722" stroke="#D32F2F" stroke-width="3"/>
                        <text x="500" y="178" text-anchor="middle" font-size="16" font-weight="bold" fill="white">c</text>
                        <text x="540" y="178" font-size="14" font-weight="bold" fill="#FF5722">① Create</text>
                        
                        <!-- Step 2: 'a' -->
                        <line x1="500" y1="195" x2="550" y2="240" stroke="#FF5722" stroke-width="3"/>
                        <text x="535" y="220" font-size="14" font-weight="bold" fill="#FF5722">a (new)</text>
                        <circle cx="550" cy="260" r="25" fill="#FF5722" stroke="#D32F2F" stroke-width="3"/>
                        <text x="550" y="268" text-anchor="middle" font-size="16" font-weight="bold" fill="white">a</text>
                        <text x="590" y="268" font-size="14" font-weight="bold" fill="#FF5722">② Create</text>
                        
                        <!-- Step 3: 't' -->
                        <line x1="550" y1="285" x2="600" y2="330" stroke="#FF5722" stroke-width="3"/>
                        <text x="585" y="310" font-size="14" font-weight="bold" fill="#FF5722">t (new)</text>
                        <circle cx="600" cy="350" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="600" y="358" text-anchor="middle" font-size="16" font-weight="bold" fill="white">t</text>
                        <text x="630" y="358" font-size="20" fill="#4CAF50">⭐</text>
                        <text x="640" y="358" font-size="14" font-weight="bold" fill="#4CAF50">③ Mark end</text>
                        <text x="600" y="390" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">"cat"</text>
                        
                        <!-- Algorithm -->
                        <g transform="translate(50, 420)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Insert Algorithm:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">1. Start at root</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">2. For each character:</text>
                            <text x="20" y="65" font-size="14" fill="var(--text-secondary)">• If child exists, move to it</text>
                            <text x="20" y="85" font-size="14" fill="var(--text-secondary)">• If not, create new node</text>
                            <text x="0" y="105" font-size="14" fill="var(--text-secondary)">3. Mark last node as end of word</text>
                            <text x="0" y="130" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(m) where m = word length</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderSearch() {
            return `
                <div class="tree-viz-section">
                    <h4>Search for "app" vs "appl"</h4>
                    <p class="viz-description">Follow path - must end at marked node for complete word</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        <!-- Trie structure -->
                        <circle cx="400" cy="60" r="25" fill="#9C27B0" stroke="#7B1FA2" stroke-width="3"/>
                        <text x="400" y="68" text-anchor="middle" font-size="16" font-weight="bold" fill="white">∅</text>
                        
                        <line x1="400" y1="85" x2="400" y2="130" stroke="#666" stroke-width="2"/>
                        <circle cx="400" cy="150" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="400" y="158" text-anchor="middle" font-size="16" font-weight="bold" fill="white">a</text>
                        
                        <line x1="400" y1="175" x2="400" y2="220" stroke="#666" stroke-width="2"/>
                        <circle cx="400" cy="240" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="400" y="248" text-anchor="middle" font-size="16" font-weight="bold" fill="white">p</text>
                        
                        <line x1="400" y1="265" x2="300" y2="310" stroke="#666" stroke-width="2"/>
                        <circle cx="300" cy="330" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="300" y="338" text-anchor="middle" font-size="16" font-weight="bold" fill="white">p</text>
                        <text x="330" y="338" font-size="20" fill="#4CAF50">⭐</text>
                        
                        <line x1="400" y1="265" x2="500" y2="310" stroke="#666" stroke-width="2"/>
                        <circle cx="500" cy="330" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="500" y="338" text-anchor="middle" font-size="16" font-weight="bold" fill="white">l</text>
                        
                        <line x1="500" y1="355" x2="550" y2="400" stroke="#666" stroke-width="2"/>
                        <circle cx="550" cy="420" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="428" text-anchor="middle" font-size="16" font-weight="bold" fill="white">e</text>
                        <text x="580" y="428" font-size="20" fill="#4CAF50">⭐</text>
                        
                        <!-- Search "app" - SUCCESS -->
                        <g transform="translate(50, 100)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="#4CAF50">Search "app": ✓ FOUND</text>
                            <circle cx="10" cy="25" r="8" fill="#4CAF50"/>
                            <text x="25" y="30" font-size="14" fill="var(--text-secondary)">a → p → p</text>
                            <circle cx="10" cy="50" r="8" fill="#4CAF50"/>
                            <text x="25" y="55" font-size="14" fill="var(--text-secondary)">Ends at ⭐ node</text>
                            <text x="0" y="80" font-size="14" font-weight="bold" fill="#4CAF50">Result: Word exists!</text>
                        </g>
                        
                        <!-- Search "appl" - NOT FOUND -->
                        <g transform="translate(50, 250)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="#F44336">Search "appl": ✗ NOT FOUND</text>
                            <circle cx="10" cy="25" r="8" fill="#FF9800"/>
                            <text x="25" y="30" font-size="14" fill="var(--text-secondary)">a → p → p → l</text>
                            <circle cx="10" cy="50" r="8" fill="#F44336"/>
                            <text x="25" y="55" font-size="14" fill="var(--text-secondary)">Node exists but NOT ⭐</text>
                            <text x="0" y="80" font-size="14" font-weight="bold" fill="#F44336">Result: Not a complete word!</text>
                        </g>
                        
                        <!-- Highlight paths -->
                        <path d="M 400 85 L 400 150 L 400 240 L 300 330" fill="none" stroke="#4CAF50" stroke-width="4" opacity="0.3"/>
                        <path d="M 400 85 L 400 150 L 400 240 L 500 330" fill="none" stroke="#FF9800" stroke-width="4" opacity="0.3"/>
                        
                        <!-- Algorithm -->
                        <g transform="translate(450, 480)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Search Algorithm:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">1. Follow path for each char</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">2. If path breaks → not found</text>
                            <text x="0" y="65" font-size="14" fill="var(--text-secondary)">3. If reach end, check ⭐ mark</text>
                            <text x="0" y="90" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(m)</text>
                        </g>
                    </svg>
                </div>
            `;
        }

        renderAutocomplete() {
            return `
                <div class="tree-viz-section">
                    <h4>Autocomplete: "app" → ?</h4>
                    <p class="viz-description">Find all words starting with prefix "app"</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        <!-- Trie -->
                        <circle cx="400" cy="60" r="25" fill="#9C27B0" stroke="#7B1FA2" stroke-width="3"/>
                        <text x="400" y="68" text-anchor="middle" font-size="16" font-weight="bold" fill="white">∅</text>
                        
                        <line x1="400" y1="85" x2="400" y2="130" stroke="#666" stroke-width="2"/>
                        <circle cx="400" cy="150" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="400" y="158" text-anchor="middle" font-size="16" font-weight="bold" fill="white">a</text>
                        
                        <line x1="400" y1="175" x2="400" y2="220" stroke="#666" stroke-width="2"/>
                        <circle cx="400" cy="240" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="400" y="248" text-anchor="middle" font-size="16" font-weight="bold" fill="white">p</text>
                        
                        <!-- Prefix node highlighted -->
                        <circle cx="400" cy="240" r="35" fill="none" stroke="#FF9800" stroke-width="4"/>
                        <text x="400" y="200" text-anchor="middle" font-size="14" font-weight="bold" fill="#FF9800">Prefix "app" ends here</text>
                        
                        <!-- All words with this prefix -->
                        <line x1="400" y1="265" x2="250" y2="310" stroke="#4CAF50" stroke-width="3"/>
                        <circle cx="250" cy="330" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="250" y="338" text-anchor="middle" font-size="16" font-weight="bold" fill="white">p</text>
                        <text x="280" y="338" font-size="20" fill="#4CAF50">⭐</text>
                        <text x="250" y="370" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">"app"</text>
                        
                        <line x1="250" y1="355" x2="200" y2="400" stroke="#4CAF50" stroke-width="3"/>
                        <circle cx="200" cy="420" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="200" y="428" text-anchor="middle" font-size="16" font-weight="bold" fill="white">y</text>
                        <text x="230" y="428" font-size="20" fill="#4CAF50">⭐</text>
                        <text x="200" y="460" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">"apply"</text>
                        
                        <line x1="400" y1="265" x2="500" y2="310" stroke="#4CAF50" stroke-width="3"/>
                        <circle cx="500" cy="330" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="500" y="338" text-anchor="middle" font-size="16" font-weight="bold" fill="white">l</text>
                        
                        <line x1="500" y1="355" x2="550" y2="400" stroke="#4CAF50" stroke-width="3"/>
                        <circle cx="550" cy="420" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="428" text-anchor="middle" font-size="16" font-weight="bold" fill="white">e</text>
                        <text x="580" y="428" font-size="20" fill="#4CAF50">⭐</text>
                        <text x="550" y="460" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">"apple"</text>
                        
                        <line x1="500" y1="355" x2="450" y2="400" stroke="#4CAF50" stroke-width="3"/>
                        <circle cx="450" cy="420" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="450" y="428" text-anchor="middle" font-size="16" font-weight="bold" fill="white">y</text>
                        <text x="480" y="428" font-size="20" fill="#4CAF50">⭐</text>
                        <text x="450" y="460" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">"apply"</text>
                        
                        <!-- Results -->
                        <rect x="50" y="500" width="700" height="80" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2" rx="8"/>
                        <text x="400" y="525" text-anchor="middle" font-size="16" font-weight="bold" fill="#2E7D32">Autocomplete Results for "app":</text>
                        <text x="400" y="550" text-anchor="middle" font-size="14" fill="#388E3C">["app", "apple", "apply"]</text>
                        <text x="400" y="570" text-anchor="middle" font-size="12" fill="var(--text-secondary)">Collect all ⭐ nodes in subtree</text>
                    </svg>
                </div>
            `;
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new TriesViz('triesVisualization');
        });
    } else {
        new TriesViz('triesVisualization');
    }
})();

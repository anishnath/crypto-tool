/**
 * Heap Applications SVG Visualization
 * Shows practical heap problem solutions
 */

(function () {
    'use strict';

    class HeapAppsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentView = 'k_largest';
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
                    <h3>Heap Applications</h3>
                    <p class="viz-subtitle">Practical problems solved with heaps</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'k_largest' ? 'active' : ''}" data-view="k_largest">
                        🔝 K Largest
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'merge_k' ? 'active' : ''}" data-view="merge_k">
                        🔀 Merge K Lists
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'median' ? 'active' : ''}" data-view="median">
                        📊 Running Median
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'meetings' ? 'active' : ''}" data-view="meetings">
                        🏢 Meeting Rooms
                    </button>
                </div>

                <div class="viz-canvas">
                    ${this.renderCurrentView()}
                </div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'k_largest':
                    return this.renderKLargest();
                case 'merge_k':
                    return this.renderMergeK();
                case 'median':
                    return this.renderMedian();
                case 'meetings':
                    return this.renderMeetings();
                default:
                    return '';
            }
        }

        renderKLargest() {
            return `
                <div class="tree-viz-section">
                    <h4>Find K Largest Elements</h4>
                    <p class="viz-description">Use min heap of size K - keep only K largest by removing smallest</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        <!-- Problem -->
                        <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Find 3 largest from: [3, 2, 1, 5, 6, 4]</text>
                        
                        <!-- Array -->
                        <g transform="translate(150, 60)">
                            <rect x="0" y="0" width="60" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="30" y="25" text-anchor="middle" font-size="18" fill="#1976D2">3</text>
                            
                            <rect x="70" y="0" width="60" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="100" y="25" text-anchor="middle" font-size="18" fill="#1976D2">2</text>
                            
                            <rect x="140" y="0" width="60" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="170" y="25" text-anchor="middle" font-size="18" fill="#1976D2">1</text>
                            
                            <rect x="210" y="0" width="60" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="240" y="25" text-anchor="middle" font-size="18" fill="#1976D2">5</text>
                            
                            <rect x="280" y="0" width="60" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="310" y="25" text-anchor="middle" font-size="18" fill="#1976D2">6</text>
                            
                            <rect x="350" y="0" width="60" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="380" y="25" text-anchor="middle" font-size="18" fill="#1976D2">4</text>
                        </g>
                        
                        <!-- Min Heap (size 3) -->
                        <text x="400" y="150" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Min Heap (K=3)</text>
                        
                        <circle cx="400" cy="200" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="400" y="208" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                        <text x="400" y="160" text-anchor="middle" font-size="12" fill="#4CAF50" font-weight="bold">MIN (smallest of K largest)</text>
                        
                        <line x1="400" y1="230" x2="320" y2="270" stroke="#666" stroke-width="2"/>
                        <line x1="400" y1="230" x2="480" y2="270" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="320" cy="290" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="320" y="298" text-anchor="middle" font-size="20" font-weight="bold" fill="white">5</text>
                        
                        <circle cx="480" cy="290" r="30" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="480" y="298" text-anchor="middle" font-size="20" font-weight="bold" fill="white">6</text>
                        
                        <!-- Algorithm -->
                        <g transform="translate(50, 360)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Algorithm:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">1. Maintain min heap of size K</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">2. For each element:</text>
                            <text x="20" y="65" font-size="14" fill="var(--text-secondary)">• Add to heap</text>
                            <text x="20" y="85" font-size="14" fill="var(--text-secondary)">• If size > K, remove min</text>
                            <text x="0" y="110" font-size="14" fill="var(--text-secondary)">3. Heap contains K largest!</text>
                            <text x="0" y="140" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(n log k) | Space: O(k)</text>
                            <text x="0" y="165" font-size="14" fill="#FF9800" font-weight="bold">Result: [6, 5, 4]</text>
                        </g>
                        
                        <!-- Use case -->
                        <rect x="450" y="360" width="300" height="120" fill="#FFF3E0" stroke="#FF9800" stroke-width="2" rx="8"/>
                        <text x="600" y="385" text-anchor="middle" font-size="14" font-weight="bold" fill="#E65100">Real-World Uses:</text>
                        <text x="600" y="410" text-anchor="middle" font-size="12" fill="#EF6C00">• Top K products</text>
                        <text x="600" y="430" text-anchor="middle" font-size="12" fill="#EF6C00">• Highest scores</text>
                        <text x="600" y="450" text-anchor="middle" font-size="12" fill="#EF6C00">• Trending items</text>
                        <text x="600" y="470" text-anchor="middle" font-size="12" fill="#EF6C00">• Leaderboards</text>
                    </svg>
                </div>
            `;
        }

        renderMergeK() {
            return `
                <div class="tree-viz-section">
                    <h4>Merge K Sorted Lists</h4>
                    <p class="viz-description">Use min heap to efficiently merge multiple sorted lists</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        <!-- K Lists -->
                        <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Merge 3 Sorted Lists</text>
                        
                        <g transform="translate(100, 60)">
                            <!-- List 1 -->
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="var(--text-primary)">List 1:</text>
                            <rect x="60" y="-20" width="40" height="35" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="80" y="0" text-anchor="middle" font-size="16" fill="#1976D2">1</text>
                            <rect x="110" y="-20" width="40" height="35" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="130" y="0" text-anchor="middle" font-size="16" fill="#1976D2">4</text>
                            <rect x="160" y="-20" width="40" height="35" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="180" y="0" text-anchor="middle" font-size="16" fill="#1976D2">5</text>
                            
                            <!-- List 2 -->
                            <text x="0" y="50" font-size="14" font-weight="bold" fill="var(--text-primary)">List 2:</text>
                            <rect x="60" y="30" width="40" height="35" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2"/>
                            <text x="80" y="50" text-anchor="middle" font-size="16" fill="#2E7D32">1</text>
                            <rect x="110" y="30" width="40" height="35" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2"/>
                            <text x="130" y="50" text-anchor="middle" font-size="16" fill="#2E7D32">3</text>
                            <rect x="160" y="30" width="40" height="35" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2"/>
                            <text x="180" y="50" text-anchor="middle" font-size="16" fill="#2E7D32">4</text>
                            
                            <!-- List 3 -->
                            <text x="0" y="100" font-size="14" font-weight="bold" fill="var(--text-primary)">List 3:</text>
                            <rect x="60" y="80" width="40" height="35" fill="#FFF3E0" stroke="#FF9800" stroke-width="2"/>
                            <text x="80" y="100" text-anchor="middle" font-size="16" fill="#E65100">2</text>
                            <rect x="110" y="80" width="40" height="35" fill="#FFF3E0" stroke="#FF9800" stroke-width="2"/>
                            <text x="130" y="100" text-anchor="middle" font-size="16" fill="#E65100">6</text>
                        </g>
                        
                        <!-- Min Heap -->
                        <text x="500" y="80" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Min Heap</text>
                        <text x="500" y="100" text-anchor="middle" font-size="12" fill="var(--text-secondary)">(value, list_id, index)</text>
                        
                        <circle cx="500" cy="140" r="25" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                        <text x="500" y="147" text-anchor="middle" font-size="16" font-weight="bold" fill="white">1</text>
                        
                        <line x1="500" y1="165" x2="450" y2="200" stroke="#666" stroke-width="2"/>
                        <line x1="500" y1="165" x2="550" y2="200" stroke="#666" stroke-width="2"/>
                        
                        <circle cx="450" cy="215" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="450" y="222" text-anchor="middle" font-size="16" font-weight="bold" fill="white">1</text>
                        
                        <circle cx="550" cy="215" r="25" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                        <text x="550" y="222" text-anchor="middle" font-size="16" font-weight="bold" fill="white">2</text>
                        
                        <!-- Result -->
                        <text x="400" y="290" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Merged Result:</text>
                        <g transform="translate(150, 310)">
                            <rect x="0" y="0" width="40" height="35" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="20" y="22" text-anchor="middle" font-size="16" fill="white">1</text>
                            <rect x="50" y="0" width="40" height="35" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="70" y="22" text-anchor="middle" font-size="16" fill="white">1</text>
                            <rect x="100" y="0" width="40" height="35" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="120" y="22" text-anchor="middle" font-size="16" fill="white">2</text>
                            <rect x="150" y="0" width="40" height="35" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="170" y="22" text-anchor="middle" font-size="16" fill="white">3</text>
                            <rect x="200" y="0" width="40" height="35" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="220" y="22" text-anchor="middle" font-size="16" fill="white">4</text>
                            <rect x="250" y="0" width="40" height="35" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="270" y="22" text-anchor="middle" font-size="16" fill="white">4</text>
                            <rect x="300" y="0" width="40" height="35" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="320" y="22" text-anchor="middle" font-size="16" fill="white">5</text>
                            <rect x="350" y="0" width="40" height="35" fill="#4CAF50" stroke="#388E3C" stroke-width="2"/>
                            <text x="370" y="22" text-anchor="middle" font-size="16" fill="white">6</text>
                        </g>
                        
                        <!-- Algorithm -->
                        <g transform="translate(50, 400)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Algorithm:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">1. Add first element from each list to heap</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">2. Pop minimum from heap → add to result</text>
                            <text x="0" y="65" font-size="14" fill="var(--text-secondary)">3. Add next element from same list to heap</text>
                            <text x="0" y="85" font-size="14" fill="var(--text-secondary)">4. Repeat until heap empty</text>
                            <text x="0" y="115" font-size="14" font-weight="bold" fill="#4CAF50">Time: O(N log k) | Space: O(k)</text>
                            <text x="0" y="135" font-size="12" fill="var(--text-secondary)">N = total elements, k = number of lists</text>
                        </g>
                        
                        <!-- Use case -->
                        <rect x="450" y="400" width="300" height="100" fill="#E3F2FD" stroke="#2196F3" stroke-width="2" rx="8"/>
                        <text x="600" y="425" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">Real-World Uses:</text>
                        <text x="600" y="450" text-anchor="middle" font-size="12" fill="#1976D2">• Merge log files</text>
                        <text x="600" y="470" text-anchor="middle" font-size="12" fill="#1976D2">• Combine sorted streams</text>
                        <text x="600" y="490" text-anchor="middle" font-size="12" fill="#1976D2">• Database merge operations</text>
                    </svg>
                </div>
            `;
        }

        renderMedian() {
            return `
                <div class="tree-viz-section">
                    <h4>Running Median from Stream</h4>
                    <p class="viz-description">Use two heaps - max heap for smaller half, min heap for larger half</p>
                    
                    <svg viewBox="0 0 800 600" class="tree-svg">
                        <!-- Stream -->
                        <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Stream: [1, 2, 3, 4, 5]</text>
                        
                        <!-- Two Heaps -->
                        <text x="250" y="80" text-anchor="middle" font-size="16" font-weight="bold" fill="#FF9800">Max Heap (smaller half)</text>
                        <text x="550" y="80" text-anchor="middle" font-size="16" font-weight="bold" fill="#4CAF50">Min Heap (larger half)</text>
                        
                        <!-- Max Heap -->
                        <circle cx="250" cy="140" r="30" fill="#FF9800" stroke="#F57C00" stroke-width="3"/>
                        <text x="250" y="148" text-anchor="middle" font-size="20" font-weight="bold" fill="white">2</text>
                        <text x="250" y="100" text-anchor="middle" font-size="12" fill="#FF9800" font-weight="bold">MAX</text>
                        
                        <line x1="250" y1="170" x2="200" y2="210" stroke="#666" stroke-width="2"/>
                        <circle cx="200" cy="230" r="25" fill="#FFF3E0" stroke="#FF9800" stroke-width="2"/>
                        <text x="200" y="237" text-anchor="middle" font-size="16" fill="#E65100">1</text>
                        
                        <!-- Min Heap -->
                        <circle cx="550" cy="140" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="148" text-anchor="middle" font-size="20" font-weight="bold" fill="white">4</text>
                        <text x="550" y="100" text-anchor="middle" font-size="12" fill="#4CAF50" font-weight="bold">MIN</text>
                        
                        <line x1="550" y1="170" x2="600" y2="210" stroke="#666" stroke-width="2"/>
                        <circle cx="600" cy="230" r="25" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2"/>
                        <text x="600" y="237" text-anchor="middle" font-size="16" fill="#2E7D32">5</text>
                        
                        <!-- Median -->
                        <text x="400" y="200" text-anchor="middle" font-size="24" font-weight="bold" fill="#2196F3">MEDIAN</text>
                        <path d="M 280 145 L 370 195" stroke="#2196F3" stroke-width="3" marker-end="url(#arrow-median)"/>
                        <path d="M 520 145 L 430 195" stroke="#2196F3" stroke-width="3" marker-end="url(#arrow-median)"/>
                        
                        <circle cx="400" cy="230" r="35" fill="#2196F3" stroke="#1976D2" stroke-width="3"/>
                        <text x="400" y="240" text-anchor="middle" font-size="24" font-weight="bold" fill="white">3</text>
                        
                        <defs>
                            <marker id="arrow-median" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#2196F3"/>
                            </marker>
                        </defs>
                        
                        <!-- Invariant -->
                        <rect x="100" y="300" width="600" height="80" fill="#E3F2FD" stroke="#2196F3" stroke-width="2" rx="8"/>
                        <text x="400" y="325" text-anchor="middle" font-size="16" font-weight="bold" fill="#1565C0">Invariant:</text>
                        <text x="400" y="350" text-anchor="middle" font-size="14" fill="#1976D2">• Max heap size = Min heap size OR Max heap size = Min heap size + 1</text>
                        <text x="400" y="370" text-anchor="middle" font-size="14" fill="#1976D2">• All elements in max heap ≤ all elements in min heap</text>
                        
                        <!-- Algorithm -->
                        <g transform="translate(50, 420)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Algorithm:</text>
                            <text x="0" y="25" font-size="14" fill="var(--text-secondary)">1. Add to appropriate heap</text>
                            <text x="0" y="45" font-size="14" fill="var(--text-secondary)">2. Balance heaps (size diff ≤ 1)</text>
                            <text x="0" y="65" font-size="14" fill="var(--text-secondary)">3. Median = top of larger heap (or average of both tops)</text>
                            <text x="0" y="95" font-size="14" font-weight="bold" fill="#4CAF50">Add: O(log n) | Find Median: O(1)</text>
                        </g>
                        
                        <!-- Use case -->
                        <rect x="450" y="420" width="300" height="100" fill="#FFF3E0" stroke="#FF9800" stroke-width="2" rx="8"/>
                        <text x="600" y="445" text-anchor="middle" font-size="14" font-weight="bold" fill="#E65100">Real-World Uses:</text>
                        <text x="600" y="470" text-anchor="middle" font-size="12" fill="#EF6C00">• Real-time analytics</text>
                        <text x="600" y="490" text-anchor="middle" font-size="12" fill="#EF6C00">• Monitoring systems</text>
                        <text x="600" y="510" text-anchor="middle" font-size="12" fill="#EF6C00">• Streaming statistics</text>
                    </svg>
                </div>
            `;
        }

        renderMeetings() {
            return `
                <div class="tree-viz-section">
                    <h4>Minimum Meeting Rooms</h4>
                    <p class="viz-description">Use min heap to track end times and reuse rooms</p>
                    
                    <svg viewBox="0 0 800 550" class="tree-svg">
                        <!-- Meetings -->
                        <text x="400" y="30" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">Meetings: [[0,30], [5,10], [15,20]]</text>
                        
                        <!-- Timeline -->
                        <g transform="translate(100, 70)">
                            <!-- Meeting 1 -->
                            <rect x="0" y="0" width="300" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2"/>
                            <text x="150" y="25" text-anchor="middle" font-size="14" fill="#1976D2">Meeting 1: 0 → 30</text>
                            
                            <!-- Meeting 2 -->
                            <rect x="50" y="60" width="50" height="40" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2"/>
                            <text x="75" y="85" text-anchor="middle" font-size="14" fill="#2E7D32">M2: 5→10</text>
                            
                            <!-- Meeting 3 -->
                            <rect x="150" y="120" width="50" height="40" fill="#FFF3E0" stroke="#FF9800" stroke-width="2"/>
                            <text x="175" y="145" text-anchor="middle" font-size="14" fill="#E65100">M3: 15→20</text>
                        </g>
                        
                        <!-- Min Heap of end times -->
                        <text x="550" y="90" text-anchor="middle" font-size="16" font-weight="bold" fill="var(--text-primary)">Min Heap (end times)</text>
                        
                        <circle cx="550" cy="140" r="30" fill="#4CAF50" stroke="#388E3C" stroke-width="3"/>
                        <text x="550" y="148" text-anchor="middle" font-size="20" font-weight="bold" fill="white">10</text>
                        
                        <line x1="550" y1="170" x2="500" y2="210" stroke="#666" stroke-width="2"/>
                        <circle cx="500" cy="230" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                        <text x="500" y="237" text-anchor="middle" font-size="16" fill="white">30</text>
                        
                        <!-- Steps -->
                        <g transform="translate(50, 280)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">Step-by-Step:</text>
                            
                            <text x="0" y="30" font-size="14" font-weight="bold" fill="#2196F3">Meeting 1 [0,30]:</text>
                            <text x="20" y="50" font-size="12" fill="var(--text-secondary)">• No rooms in use, allocate room 1</text>
                            <text x="20" y="65" font-size="12" fill="var(--text-secondary)">• Add end time 30 to heap</text>
                            
                            <text x="0" y="95" font-size="14" font-weight="bold" fill="#4CAF50">Meeting 2 [5,10]:</text>
                            <text x="20" y="115" font-size="12" fill="var(--text-secondary)">• Earliest end (30) > start (5), need new room</text>
                            <text x="20" y="130" font-size="12" fill="var(--text-secondary)">• Allocate room 2, add end time 10</text>
                            
                            <text x="0" y="160" font-size="14" font-weight="bold" fill="#FF9800">Meeting 3 [15,20]:</text>
                            <text x="20" y="180" font-size="12" fill="var(--text-secondary)">• Earliest end (10) ≤ start (15), reuse room!</text>
                            <text x="20" y="195" font-size="12" fill="var(--text-secondary)">• Remove 10, add end time 20</text>
                            
                            <text x="0" y="225" font-size="16" font-weight="bold" fill="#4CAF50">Result: 2 rooms needed</text>
                        </g>
                        
                        <!-- Use case -->
                        <rect x="450" y="350" width="300" height="140" fill="#E3F2FD" stroke="#2196F3" stroke-width="2" rx="8"/>
                        <text x="600" y="375" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">Real-World Uses:</text>
                        <text x="600" y="400" text-anchor="middle" font-size="12" fill="#1976D2">• Conference room scheduling</text>
                        <text x="600" y="420" text-anchor="middle" font-size="12" fill="#1976D2">• Resource allocation</text>
                        <text x="600" y="440" text-anchor="middle" font-size="12" fill="#1976D2">• CPU scheduling</text>
                        <text x="600" y="460" text-anchor="middle" font-size="12" fill="#1976D2">• Parking lot management</text>
                        <text x="600" y="480" text-anchor="middle" font-size="12" font-weight="bold" fill="#4CAF50">Time: O(n log n)</text>
                    </svg>
                </div>
            `;
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new HeapAppsViz('heapAppsVisualization');
        });
    } else {
        new HeapAppsViz('heapAppsVisualization');
    }
})();

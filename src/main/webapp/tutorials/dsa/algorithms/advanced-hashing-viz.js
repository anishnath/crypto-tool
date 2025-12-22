/**
 * Advanced Hashing SVG Visualizations
 * Detailed diagrams for Consistent Hashing, Bloom Filters, and Rolling Hash
 */

(function () {
    'use strict';

    class AdvancedHashViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;

            this.currentView = 'consistent';
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
                    <h3>Advanced Hashing Techniques</h3>
                    <p class="viz-subtitle">Click each technique to see detailed diagrams</p>
                </div>

                <div class="viz-tabs">
                    <button class="viz-tab-btn ${this.currentView === 'consistent' ? 'active' : ''}" data-view="consistent">
                        🔄 Consistent Hashing
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'bloom' ? 'active' : ''}" data-view="bloom">
                        🎯 Bloom Filter
                    </button>
                    <button class="viz-tab-btn ${this.currentView === 'rolling' ? 'active' : ''}" data-view="rolling">
                        📝 Rolling Hash
                    </button>
                </div>

                <div class="viz-canvas">
                    ${this.renderCurrentView()}
                </div>
            `;
        }

        renderCurrentView() {
            switch (this.currentView) {
                case 'consistent':
                    return this.renderConsistentHashing();
                case 'bloom':
                    return this.renderBloomFilter();
                case 'rolling':
                    return this.renderRollingHash();
                default:
                    return '';
            }
        }

        renderConsistentHashing() {
            return `
                <div class="advanced-viz-section">
                    <h4>Consistent Hashing - Distributed Systems</h4>
                    <p class="viz-description">Maps both servers and keys to a hash ring. Minimizes redistribution when nodes change.</p>
                    
                    <svg viewBox="0 0 800 600" class="advanced-svg">
                        <!-- Hash Ring Circle -->
                        <circle cx="400" cy="300" r="200" fill="none" stroke="#4CAF50" stroke-width="3" stroke-dasharray="5,5"/>
                        
                        <!-- Ring Label -->
                        <text x="400" y="80" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">
                            Hash Ring (0 to 2^32-1)
                        </text>
                        
                        <!-- Server Nodes on Ring -->
                        <g id="servers">
                            <!-- Server 1 at 0° -->
                            <circle cx="400" cy="100" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="400" y="105" text-anchor="middle" font-size="14" font-weight="bold" fill="white">S1</text>
                            <text x="400" y="75" text-anchor="middle" font-size="12" fill="var(--text-secondary)">hash(S1)=0</text>
                            
                            <!-- Server 2 at 120° -->
                            <circle cx="227" cy="400" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="227" y="405" text-anchor="middle" font-size="14" font-weight="bold" fill="white">S2</text>
                            <text x="180" y="430" text-anchor="middle" font-size="12" fill="var(--text-secondary)">hash(S2)=1431655765</text>
                            
                            <!-- Server 3 at 240° -->
                            <circle cx="573" cy="400" r="25" fill="#2196F3" stroke="#1976D2" stroke-width="2"/>
                            <text x="573" y="405" text-anchor="middle" font-size="14" font-weight="bold" fill="white">S3</text>
                            <text x="620" y="430" text-anchor="middle" font-size="12" fill="var(--text-secondary)">hash(S3)=2863311530</text>
                        </g>
                        
                        <!-- Keys on Ring -->
                        <g id="keys">
                            <!-- Key 1 -->
                            <circle cx="450" cy="120" r="12" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="480" y="125" font-size="11" fill="var(--text-primary)">K1 → S1</text>
                            
                            <!-- Key 2 -->
                            <circle cx="300" cy="350" r="12" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="260" y="355" font-size="11" fill="var(--text-primary)">K2 → S2</text>
                            
                            <!-- Key 3 -->
                            <circle cx="520" cy="350" r="12" fill="#FF9800" stroke="#F57C00" stroke-width="2"/>
                            <text x="540" y="355" font-size="11" fill="var(--text-primary)">K3 → S3</text>
                        </g>
                        
                        <!-- Arrows showing clockwise direction -->
                        <path d="M 600 300 Q 620 280 600 260" fill="none" stroke="#4CAF50" stroke-width="2" marker-end="url(#arrowhead)"/>
                        <text x="630" y="280" font-size="12" fill="#4CAF50">Clockwise</text>
                        
                        <!-- Arrow marker definition -->
                        <defs>
                            <marker id="arrowhead" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#4CAF50"/>
                            </marker>
                        </defs>
                        
                        <!-- Legend -->
                        <g transform="translate(50, 520)">
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="var(--text-primary)">How it works:</text>
                            <text x="0" y="20" font-size="12" fill="var(--text-secondary)">1. Hash servers → positions on ring</text>
                            <text x="0" y="40" font-size="12" fill="var(--text-secondary)">2. Hash keys → positions on ring</text>
                            <text x="0" y="60" font-size="12" fill="var(--text-secondary)">3. Key goes to next server clockwise</text>
                        </g>
                    </svg>
                    
                    <div class="info-box" style="margin-top: 20px;">
                        <h5>Why Consistent Hashing?</h5>
                        <p><strong>Traditional:</strong> hash(key) % N → Adding/removing server redistributes ALL keys</p>
                        <p><strong>Consistent:</strong> Only K/N keys redistributed (K = total keys, N = servers)</p>
                        <p><strong>Used in:</strong> Memcached, Cassandra, DynamoDB, CDNs</p>
                    </div>
                </div>
            `;
        }

        renderBloomFilter() {
            return `
                <div class="advanced-viz-section">
                    <h4>Bloom Filter - Probabilistic Set</h4>
                    <p class="viz-description">Space-efficient data structure. Can have false positives, but NO false negatives!</p>
                    
                    <svg viewBox="0 0 800 600" class="advanced-svg">
                        <!-- Bit Array -->
                        <text x="400" y="40" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">
                            Bit Array (size = 16)
                        </text>
                        
                        <!-- Bit array boxes -->
                        <g id="bitarray">
                            ${Array.from({ length: 16 }, (_, i) => {
                const x = 100 + i * 40;
                const isSet = [2, 5, 7, 11, 13].includes(i);
                return `
                                    <rect x="${x}" y="60" width="35" height="35" 
                                          fill="${isSet ? '#4CAF50' : 'white'}" 
                                          stroke="#333" stroke-width="2"/>
                                    <text x="${x + 17.5}" y="82" text-anchor="middle" 
                                          font-size="16" font-weight="bold" 
                                          fill="${isSet ? 'white' : '#333'}">${isSet ? '1' : '0'}</text>
                                    <text x="${x + 17.5}" y="110" text-anchor="middle" 
                                          font-size="10" fill="var(--text-secondary)">${i}</text>
                                `;
            }).join('')}
                        </g>
                        
                        <!-- Adding "apple" -->
                        <g transform="translate(0, 140)">
                            <text x="100" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">
                                Adding "apple":
                            </text>
                            
                            <!-- Hash function 1 -->
                            <rect x="100" y="20" width="200" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2" rx="5"/>
                            <text x="200" y="45" text-anchor="middle" font-size="14" fill="#1976D2">
                                hash1("apple") = 2
                            </text>
                            <path d="M 200 60 L 135 -20" stroke="#2196F3" stroke-width="2" marker-end="url(#arrow-blue)"/>
                            
                            <!-- Hash function 2 -->
                            <rect x="100" y="80" width="200" height="40" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2" rx="5"/>
                            <text x="200" y="105" text-anchor="middle" font-size="14" fill="#2E7D32">
                                hash2("apple") = 7
                            </text>
                            <path d="M 200 80 L 295 -20" stroke="#4CAF50" stroke-width="2" marker-end="url(#arrow-green)"/>
                            
                            <!-- Hash function 3 -->
                            <rect x="100" y="140" width="200" height="40" fill="#FFF3E0" stroke="#FF9800" stroke-width="2" rx="5"/>
                            <text x="200" y="165" text-anchor="middle" font-size="14" fill="#E65100">
                                hash3("apple") = 11
                            </text>
                            <path d="M 200 140 L 455 -20" stroke="#FF9800" stroke-width="2" marker-end="url(#arrow-orange)"/>
                        </g>
                        
                        <!-- Checking "banana" -->
                        <g transform="translate(450, 140)">
                            <text x="0" y="0" font-size="16" font-weight="bold" fill="var(--text-primary)">
                                Checking "banana":
                            </text>
                            
                            <rect x="0" y="20" width="200" height="40" fill="#E3F2FD" stroke="#2196F3" stroke-width="2" rx="5"/>
                            <text x="100" y="45" text-anchor="middle" font-size="14" fill="#1976D2">
                                hash1("banana") = 5 ✓
                            </text>
                            
                            <rect x="0" y="80" width="200" height="40" fill="#E8F5E9" stroke="#4CAF50" stroke-width="2" rx="5"/>
                            <text x="100" y="105" text-anchor="middle" font-size="14" fill="#2E7D32">
                                hash2("banana") = 13 ✓
                            </text>
                            
                            <rect x="0" y="140" width="200" height="40" fill="#FFEBEE" stroke="#F44336" stroke-width="2" rx="5"/>
                            <text x="100" y="165" text-anchor="middle" font-size="14" fill="#C62828">
                                hash3("banana") = 3 ✗
                            </text>
                            
                            <text x="100" y="200" text-anchor="middle" font-size="14" font-weight="bold" fill="#F44336">
                                NOT in set (bit 3 = 0)
                            </text>
                        </g>
                        
                        <!-- Arrow markers -->
                        <defs>
                            <marker id="arrow-blue" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#2196F3"/>
                            </marker>
                            <marker id="arrow-green" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#4CAF50"/>
                            </marker>
                            <marker id="arrow-orange" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
                                <polygon points="0 0, 10 3, 0 6" fill="#FF9800"/>
                            </marker>
                        </defs>
                        
                        <!-- Legend -->
                        <g transform="translate(50, 500)">
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="var(--text-primary)">Key Properties:</text>
                            <text x="0" y="20" font-size="12" fill="var(--text-secondary)">✓ If all bits are 1 → MIGHT be in set (could be false positive)</text>
                            <text x="0" y="40" font-size="12" fill="var(--text-secondary)">✓ If any bit is 0 → DEFINITELY NOT in set (no false negatives)</text>
                            <text x="0" y="60" font-size="12" fill="var(--text-secondary)">✓ Space-efficient: 10 bits per element (vs 64+ for hash table)</text>
                        </g>
                    </svg>
                    
                    <div class="info-box" style="margin-top: 20px;">
                        <h5>Trade-offs</h5>
                        <p><strong>Pros:</strong> Extremely space-efficient, O(k) operations (k = hash functions)</p>
                        <p><strong>Cons:</strong> False positives possible, cannot delete elements</p>
                        <p><strong>Used in:</strong> Chrome (malicious URLs), Medium (articles read), Bitcoin</p>
                    </div>
                </div>
            `;
        }

        renderRollingHash() {
            return `
                <div class="advanced-viz-section">
                    <h4>Rolling Hash - Rabin-Karp Algorithm</h4>
                    <p class="viz-description">Efficiently compute hash as window slides. Used for pattern matching in O(n+m) time.</p>
                    
                    <svg viewBox="0 0 800 650" class="advanced-svg">
                        <!-- Text and Pattern -->
                        <text x="400" y="40" text-anchor="middle" font-size="18" font-weight="bold" fill="var(--text-primary)">
                            Text: "ABCDABC"  |  Pattern: "ABC"
                        </text>
                        
                        <!-- Step 1: Initial Window -->
                        <g transform="translate(100, 80)">
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="var(--text-primary)">Step 1: Compute initial hash</text>
                            
                            <!-- Text array -->
                            ${['A', 'B', 'C', 'D', 'A', 'B', 'C'].map((char, i) => {
                const isWindow = i < 3;
                return `
                                    <rect x="${i * 50}" y="20" width="45" height="45" 
                                          fill="${isWindow ? '#4CAF50' : 'white'}" 
                                          stroke="#333" stroke-width="2"/>
                                    <text x="${i * 50 + 22.5}" y="47" text-anchor="middle" 
                                          font-size="18" font-weight="bold" 
                                          fill="${isWindow ? 'white' : '#333'}">${char}</text>
                                    <text x="${i * 50 + 22.5}" y="80" text-anchor="middle" 
                                          font-size="10" fill="var(--text-secondary)">${i}</text>
                                `;
            }).join('')}
                            
                            <!-- Hash calculation -->
                            <text x="0" y="110" font-size="13" fill="var(--text-secondary)">
                                hash = (A×256² + B×256¹ + C×256⁰) mod M
                            </text>
                            <text x="0" y="130" font-size="13" font-weight="bold" fill="#4CAF50">
                                hash = 4276803 (matches pattern!)
                            </text>
                        </g>
                        
                        <!-- Step 2: Slide Window -->
                        <g transform="translate(100, 250)">
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="var(--text-primary)">Step 2: Slide window (remove A, add D)</text>
                            
                            <!-- Text array -->
                            ${['A', 'B', 'C', 'D', 'A', 'B', 'C'].map((char, i) => {
                const isWindow = i >= 1 && i < 4;
                const isRemoved = i === 0;
                const isAdded = i === 3;
                return `
                                    <rect x="${i * 50}" y="20" width="45" height="45" 
                                          fill="${isWindow ? '#2196F3' : 'white'}" 
                                          stroke="${isRemoved ? '#F44336' : isAdded ? '#FF9800' : '#333'}" 
                                          stroke-width="${isRemoved || isAdded ? '3' : '2'}"
                                          stroke-dasharray="${isRemoved ? '5,5' : '0'}"/>
                                    <text x="${i * 50 + 22.5}" y="47" text-anchor="middle" 
                                          font-size="18" font-weight="bold" 
                                          fill="${isWindow ? 'white' : '#333'}">${char}</text>
                                `;
            }).join('')}
                            
                            <!-- Rolling hash formula -->
                            <text x="0" y="90" font-size="13" fill="var(--text-secondary)">
                                new_hash = (old_hash - A×256²) × 256 + D
                            </text>
                            <text x="0" y="110" font-size="13" font-weight="bold" fill="#2196F3">
                                new_hash = 4342340 (no match)
                            </text>
                            <text x="0" y="130" font-size="12" fill="#FF9800">
                                ⚡ O(1) update! No need to recalculate from scratch
                            </text>
                        </g>
                        
                        <!-- Step 3: Continue Sliding -->
                        <g transform="translate(100, 420)">
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="var(--text-primary)">Step 3: Continue sliding...</text>
                            
                            <!-- Text array -->
                            ${['A', 'B', 'C', 'D', 'A', 'B', 'C'].map((char, i) => {
                const isWindow = i >= 4 && i < 7;
                return `
                                    <rect x="${i * 50}" y="20" width="45" height="45" 
                                          fill="${isWindow ? '#4CAF50' : 'white'}" 
                                          stroke="#333" stroke-width="2"/>
                                    <text x="${i * 50 + 22.5}" y="47" text-anchor="middle" 
                                          font-size="18" font-weight="bold" 
                                          fill="${isWindow ? 'white' : '#333'}">${char}</text>
                                `;
            }).join('')}
                            
                            <text x="0" y="90" font-size="13" font-weight="bold" fill="#4CAF50">
                                hash = 4276803 (MATCH at index 4!)
                            </text>
                        </g>
                        
                        <!-- Legend -->
                        <g transform="translate(50, 570)">
                            <text x="0" y="0" font-size="14" font-weight="bold" fill="var(--text-primary)">Key Insight:</text>
                            <text x="0" y="20" font-size="12" fill="var(--text-secondary)">✓ Compute hash once: O(m) where m = pattern length</text>
                            <text x="0" y="40" font-size="12" fill="var(--text-secondary)">✓ Update hash in O(1) as window slides</text>
                            <text x="0" y="60" font-size="12" fill="var(--text-secondary)">✓ Total: O(n + m) vs O(nm) brute force</text>
                        </g>
                    </svg>
                    
                    <div class="info-box" style="margin-top: 20px;">
                        <h5>Applications</h5>
                        <p><strong>Pattern matching:</strong> Find substring in text efficiently</p>
                        <p><strong>Plagiarism detection:</strong> Find copied text segments</p>
                        <p><strong>DNA matching:</strong> Find gene sequences</p>
                        <p><strong>Used in:</strong> rsync, plagiarism checkers, bioinformatics tools</p>
                    </div>
                </div>
            `;
        }
    }

    // Initialize
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            new AdvancedHashViz('advancedHashVisualization');
        });
    } else {
        new AdvancedHashViz('advancedHashVisualization');
    }
})();

(function () {
    'use strict';
    class KnapsackViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.container.innerHTML = `<div class="graph-viz-section"><h4>Knapsack Problems</h4><p class="viz-description">0/1, Unbounded, Subset Sum</p><svg viewBox="0 0 1000 700" class="graph-svg"><g transform="translate(50, 50)"><text x="450" y="50" text-anchor="middle" font-size="18" font-weight="bold">Knapsack DP: dp[i][w] = max value using first i items with capacity w</text><text x="450" y="350" text-anchor="middle" font-size="16">See code examples for detailed DP table visualization</text></g></svg></div>`;
        }
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new KnapsackViz('knapsackVisualization'));
    } else { new KnapsackViz('knapsackVisualization'); }
})();

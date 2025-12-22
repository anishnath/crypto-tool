(function () {
    'use strict';
    class DP1DViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.container.innerHTML = `<div class="graph-viz-section"><h4>1D DP Problems</h4><p class="viz-description">House Robber, Coin Change, and other single-array DP</p><svg viewBox="0 0 1000 700" class="graph-svg"><g transform="translate(50, 50)"><text x="450" y="50" text-anchor="middle" font-size="18" font-weight="bold">1D DP Pattern: dp[i] = answer for subproblem i</text><text x="450" y="350" text-anchor="middle" font-size="16">See code examples for detailed DP table visualization</text></g></svg></div>`;
        }
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new DP1DViz('dp1DVisualization'));
    } else { new DP1DViz('dp1DVisualization'); }
})();

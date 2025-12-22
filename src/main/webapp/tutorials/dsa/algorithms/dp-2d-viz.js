(function () {
    'use strict';
    class DP2DViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.container.innerHTML = `<div class="graph-viz-section"><h4>2D DP Problems</h4><p class="viz-description">LCS, Edit Distance, Unique Paths</p><svg viewBox="0 0 1000 700" class="graph-svg"><g transform="translate(50, 50)"><text x="450" y="50" text-anchor="middle" font-size="18" font-weight="bold">2D DP Pattern: dp[i][j] = answer at position (i,j)</text><text x="450" y="350" text-anchor="middle" font-size="16">See code examples for detailed DP table visualization</text></g></svg></div>`;
        }
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new DP2DViz('dp2DVisualization'));
    } else { new DP2DViz('dp2DVisualization'); }
})();

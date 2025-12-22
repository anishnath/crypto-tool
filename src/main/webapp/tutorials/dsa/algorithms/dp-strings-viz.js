(function () {
    'use strict';
    class DPStringsViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.container.innerHTML = `<div class="graph-viz-section"><h4>DP on Strings</h4><p class="viz-description">Palindrome problems, Word Break</p><svg viewBox="0 0 1000 700" class="graph-svg"><g transform="translate(50, 50)"><text x="450" y="50" text-anchor="middle" font-size="18" font-weight="bold">String DP: dp[i][j] = answer for substring s[i:j]</text><text x="450" y="350" text-anchor="middle" font-size="16">See code examples for detailed DP table visualization</text></g></svg></div>`;
        }
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new DPStringsViz('dpStringsVisualization'));
    } else { new DPStringsViz('dpStringsVisualization'); }
})();

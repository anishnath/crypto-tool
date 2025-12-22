(function () {
    'use strict';
    class DPProblemSolvingViz {
        constructor(containerId) {
            this.container = document.getElementById(containerId);
            if (!this.container) return;
            this.container.innerHTML = `<div class="graph-viz-section"><h4>DP Problem-Solving Guide</h4><p class="viz-description">How to recognize DP, common patterns, strategy</p><svg viewBox="0 0 1000 700" class="graph-svg"><g transform="translate(50, 50)"><text x="450" y="50" text-anchor="middle" font-size="18" font-weight="bold">DP Problem-Solving Framework</text><text x="450" y="150" text-anchor="middle" font-size="14">1. Recognize overlapping subproblems</text><text x="450" y="200" text-anchor="middle" font-size="14">2. Define state dp[i] or dp[i][j]</text><text x="450" y="250" text-anchor="middle" font-size="14">3. Find recurrence relation</text><text x="450" y="300" text-anchor="middle" font-size="14">4. Set base cases</text><text x="450" y="350" text-anchor="middle" font-size="14">5. Implement (memoization or tabulation)</text></g></svg></div>`;
        }
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => new DPProblemSolvingViz('dpProblemSolvingVisualization'));
    } else { new DPProblemSolvingViz('dpProblemSolvingVisualization'); }
})();

// ============================================================================
// TikZ Draw - Initialization
// ============================================================================

document.addEventListener('DOMContentLoaded', () => {
    const app = new TikZDrawApp();
    window.app = app;

    // Wire up code panel toggle (button in action bar)
    const codeToggle = document.getElementById('codeToggle');
    const codePanel = document.getElementById('codePanel');
    if (codeToggle && codePanel) {
        codeToggle.addEventListener('click', () => {
            const isCollapsed = codePanel.classList.toggle('collapsed');
            codeToggle.textContent = isCollapsed ? 'Show Code' : 'Hide Code';
            // Update code when opening
            if (!isCollapsed) {
                const codeOutput = document.getElementById('tikzCodeOutput');
                if (codeOutput) {
                    codeOutput.textContent = app.generateTikZ();
                }
            }
        });
    }
});

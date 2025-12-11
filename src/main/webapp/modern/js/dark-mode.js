/**
 * Dark Mode Toggle
 * Persistent theme preference with smooth transitions
 */

class DarkMode {
    constructor() {
        this.theme = this.getTheme();
        this.init();
    }

    init() {
        // Apply theme immediately to prevent flash
        this.applyTheme(this.theme);
        
        // Create toggle button
        this.createToggle();
        
        // Listen for system preference changes
        this.watchSystemPreference();
    }

    getTheme() {
        // Check localStorage first
        const stored = localStorage.getItem('theme');
        if (stored === 'dark' || stored === 'light') {
            return stored;
        }
        
        // Fall back to system preference
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            return 'dark';
        }
        
        return 'light';
    }

    applyTheme(theme) {
        // Always set the data-theme attribute (even for light) for consistency
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
        this.theme = theme;
        
        // Update meta theme-color for mobile browsers
        let metaTheme = document.querySelector('meta[name="theme-color"]');
        if (!metaTheme) {
            metaTheme = document.createElement('meta');
            metaTheme.name = 'theme-color';
            document.head.appendChild(metaTheme);
        }
        metaTheme.content = theme === 'dark' ? '#0f172a' : '#ffffff';
        
        // Force repaint for better theme transition visibility
        document.body.offsetHeight; // Trigger reflow
    }

    toggle() {
        const newTheme = this.theme === 'dark' ? 'light' : 'dark';
        this.applyTheme(newTheme);
        
        // Update toggle button icon
        this.updateToggleIcon();
        
        // Animate transition
        this.animateTransition();
    }

    createToggle() {
        // Create toggle button
        const toggle = document.createElement('button');
        toggle.className = 'theme-toggle';
        toggle.setAttribute('aria-label', 'Toggle dark mode');
        toggle.innerHTML = this.theme === 'dark' ? '☀️' : '🌙';
        
        // Add to navigation actions
        const navActions = document.querySelector('.nav-actions');
        if (navActions) {
            navActions.insertBefore(toggle, navActions.firstChild);
        }
        
        // Also add to mobile drawer
        const drawerContent = document.querySelector('.drawer-content');
        if (drawerContent) {
            const drawerToggle = toggle.cloneNode(true);
            drawerToggle.addEventListener('click', () => this.toggle());
            const themeSection = document.createElement('div');
            themeSection.className = 'drawer-section';
            themeSection.innerHTML = `
                <h3 class="drawer-section-title">Appearance</h3>
                <button class="drawer-link" onclick="window.darkMode.toggle()" style="width: 100%; justify-content: space-between;">
                    <span>
                        <span class="drawer-link-icon">${this.theme === 'dark' ? '☀️' : '🌙'}</span>
                        <span>${this.theme === 'dark' ? 'Light Mode' : 'Dark Mode'}</span>
                    </span>
                    <span>${this.theme === 'dark' ? '🌙' : '☀️'}</span>
                </button>
            `;
            drawerContent.insertBefore(themeSection, drawerContent.firstChild);
        }
        
        toggle.addEventListener('click', () => this.toggle());
        this.updateToggleIcon();
    }

    updateToggleIcon() {
        const toggles = document.querySelectorAll('.theme-toggle');
        toggles.forEach(toggle => {
            toggle.innerHTML = this.theme === 'dark' ? '☀️' : '🌙';
            toggle.setAttribute('aria-label', `Switch to ${this.theme === 'dark' ? 'light' : 'dark'} mode`);
        });
        
        // Update drawer button if exists
        const drawerToggle = document.querySelector('.drawer-content .drawer-link');
        if (drawerToggle) {
            const icon = drawerToggle.querySelector('.drawer-link-icon');
            const text = drawerToggle.querySelector('span:not(.drawer-link-icon)');
            if (icon) icon.textContent = this.theme === 'dark' ? '☀️' : '🌙';
            if (text) text.textContent = this.theme === 'dark' ? 'Light Mode' : 'Dark Mode';
        }
    }

    animateTransition() {
        // Add transition class to body
        document.body.style.transition = 'background-color 0.3s ease, color 0.3s ease';
        
        // Remove transition after animation
        setTimeout(() => {
            document.body.style.transition = '';
        }, 300);
    }

    watchSystemPreference() {
        if (window.matchMedia) {
            const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
            mediaQuery.addEventListener('change', (e) => {
                // Only auto-switch if user hasn't set a preference
                if (!localStorage.getItem('theme')) {
                    this.applyTheme(e.matches ? 'dark' : 'light');
                    this.updateToggleIcon();
                }
            });
        }
    }
}

// Initialize dark mode
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        window.darkMode = new DarkMode();
    });
} else {
    window.darkMode = new DarkMode();
}


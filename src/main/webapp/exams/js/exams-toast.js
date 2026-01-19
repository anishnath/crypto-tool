/**
 * Exam Platform - Toast Notification Module
 * Generic toast notification system for success, error, warning, and info messages
 */

const ExamToast = (function() {
    'use strict';

    // Configuration
    const config = {
        defaultDuration: 4000, // 4 seconds
        position: 'top-right', // top-right, top-left, bottom-right, bottom-left, top-center, bottom-center
        maxToasts: 5,
        animationDuration: 300
    };

    // Toast container
    let container = null;

    /**
     * Initialize toast system
     */
    function init(options = {}) {
        Object.assign(config, options);
        createContainer();
    }

    /**
     * Create toast container
     */
    function createContainer() {
        if (container) return;

        container = document.createElement('div');
        container.id = 'exam-toast-container';
        container.className = `toast-container toast-${config.position}`;
        container.setAttribute('aria-live', 'polite');
        container.setAttribute('aria-atomic', 'true');
        document.body.appendChild(container);
    }

    /**
     * Show toast notification
     * @param {string} message - Toast message
     * @param {string} type - success, error, warning, info
     * @param {Object} options - { duration, action, onAction }
     */
    function show(message, type = 'info', options = {}) {
        if (!container) {
            init();
        }

        // Remove oldest toast if max reached
        const toasts = container.querySelectorAll('.toast');
        if (toasts.length >= config.maxToasts) {
            toasts[0].remove();
        }

        const duration = options.duration || config.defaultDuration;
        const toast = createToast(message, type, options);

        container.appendChild(toast);

        // Trigger animation
        requestAnimationFrame(() => {
            toast.classList.add('toast-show');
        });

        // Auto-dismiss
        if (duration > 0) {
            setTimeout(() => {
                dismiss(toast);
            }, duration);
        }

        return toast;
    }

    /**
     * Create toast element
     */
    function createToast(message, type, options) {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.setAttribute('role', 'alert');
        toast.setAttribute('aria-live', 'assertive');

        const icon = getIcon(type);
        const actionButton = options.action ? createActionButton(options.action) : '';

        toast.innerHTML = `
            <div class="toast-content">
                <div class="toast-icon">${icon}</div>
                <div class="toast-message">${escapeHtml(message)}</div>
            </div>
            ${actionButton}
            <button class="toast-close" aria-label="Close notification">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        `;

        // Attach close button handler
        const closeBtn = toast.querySelector('.toast-close');
        if (closeBtn) {
            closeBtn.onclick = () => dismiss(toast);
        }

        // Re-attach action button handler if present
        if (options.action && options.onAction) {
            const actionBtn = toast.querySelector('.toast-action');
            if (actionBtn) {
                actionBtn.onclick = () => {
                    if (typeof options.onAction === 'function') {
                        options.onAction(toast);
                    }
                    dismiss(toast);
                };
            }
        }

        return toast;
    }

    /**
     * Get icon for toast type
     */
    function getIcon(type) {
        const icons = {
            success: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>`,
            error: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>`,
            warning: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path>
                <line x1="12" y1="9" x2="12" y2="13"></line>
                <line x1="12" y1="17" x2="12.01" y2="17"></line>
            </svg>`,
            info: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="16" x2="12" y2="12"></line>
                <line x1="12" y1="8" x2="12.01" y2="8"></line>
            </svg>`
        };
        return icons[type] || icons.info;
    }

    /**
     * Create action button HTML
     */
    function createActionButton(actionText) {
        return `
            <button class="toast-action">
                ${escapeHtml(actionText)}
            </button>
        `;
    }

    /**
     * Dismiss toast
     */
    function dismiss(toast) {
        if (!toast) return;

        toast.classList.remove('toast-show');
        toast.classList.add('toast-hide');

        setTimeout(() => {
            if (toast.parentNode) {
                toast.remove();
            }
        }, config.animationDuration);
    }

    /**
     * Dismiss all toasts
     */
    function dismissAll() {
        if (!container) return;

        const toasts = container.querySelectorAll('.toast');
        toasts.forEach(toast => dismiss(toast));
    }

    /**
     * Escape HTML to prevent XSS
     */
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    /**
     * Convenience methods
     */
    function success(message, options) {
        return show(message, 'success', options);
    }

    function error(message, options) {
        return show(message, 'error', options);
    }

    function warning(message, options) {
        return show(message, 'warning', options);
    }

    function info(message, options) {
        return show(message, 'info', options);
    }

    // Public API
    return {
        init,
        show,
        success,
        error,
        warning,
        info,
        dismiss,
        dismissAll
    };
})();

// Auto-initialize on DOM ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => ExamToast.init());
} else {
    ExamToast.init();
}


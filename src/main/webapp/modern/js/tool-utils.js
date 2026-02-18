/**
 * Tool Page Utilities
 * Common helper functions for all tool pages
 * Version: 1.0
 */

(function () {
    'use strict';

    // Prevent multiple initializations
    if (window.ToolUtils) {
        return;
    }

    /**
     * Tool Utilities Object
     * All utility functions are exposed through this object
     */
    window.ToolUtils = {

        /**
         * Copy text to clipboard
         * Uses modern Clipboard API with fallback to execCommand
         * 
         * @param {string} text - Text to copy
         * @param {Object} options - Options object
         * @param {boolean} options.showToast - Show toast notification (default: true)
         * @param {string} options.toastMessage - Custom toast message (default: 'Copied to clipboard!')
         * @param {number} options.toastDuration - Toast duration in ms (default: 2000)
         * @returns {Promise<Object>} Promise that resolves with {success: boolean, method: string}
         */
        copyToClipboard: async function (text, options = {}) {
            const {
                showToast = true,
                toastMessage = 'Copied to clipboard!',
                toastDuration = 2000,
                showSupportPopup = true,
                toolName = null,
                resultText = null
            } = options;

            try {
                // Try modern Clipboard API
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    await navigator.clipboard.writeText(text);
                    if (showToast) {
                        this.showToast(toastMessage, toastDuration);
                    }

                    // Show support popup after successful copy
                    if (showSupportPopup) {
                        setTimeout(() => {
                            this.showSupportPopup(toolName, resultText || text);
                        }, 500);
                    }

                    return { success: true, method: 'clipboard-api' };
                }

                // Fallback for older browsers
                const result = this._fallbackCopy(text, showToast, toastMessage, toastDuration);

                // Show support popup after successful copy
                if (result.success && showSupportPopup) {
                    setTimeout(() => {
                        this.showSupportPopup(toolName, resultText || text);
                    }, 500);
                }

                return result;
            } catch (err) {
                console.error('Copy failed:', err);
                if (showToast) {
                    this.showToast('Failed to copy. Please select and copy manually.', 3000);
                }
                return { success: false, error: err };
            }
        },

        /**
         * Fallback copy method using execCommand
         * @private
         */
        _fallbackCopy: function (text, showToast, toastMessage, toastDuration) {
            const textarea = document.createElement('textarea');
            textarea.value = text;
            textarea.style.position = 'fixed';
            textarea.style.left = '-999999px';
            textarea.style.top = '-999999px';
            document.body.appendChild(textarea);
            textarea.focus();
            textarea.select();

            try {
                const successful = document.execCommand('copy');
                document.body.removeChild(textarea);

                if (successful && showToast) {
                    this.showToast(toastMessage, toastDuration);
                }

                return { success: successful, method: 'execCommand' };
            } catch (err) {
                document.body.removeChild(textarea);
                return { success: false, error: err };
            }
        },

        /**
         * Show toast notification
         * 
         * @param {string} message - Toast message
         * @param {number} duration - Duration in ms (default: 2000)
         * @param {string} type - Toast type: 'success', 'error', 'info', 'warning' (default: 'success')
         */
        showToast: function (message, duration = 2000, type = 'success') {
            // Remove existing toast
            const existing = document.querySelector('.tool-toast');
            if (existing) existing.remove();

            // Toast type colors
            const colors = {
                success: { bg: '#10b981', icon: 'fa-check-circle' },
                error: { bg: '#ef4444', icon: 'fa-exclamation-circle' },
                info: { bg: '#3b82f6', icon: 'fa-info-circle' },
                warning: { bg: '#f59e0b', icon: 'fa-exclamation-triangle' }
            };

            const config = colors[type] || colors.success;

            // Create toast
            const toast = document.createElement('div');
            toast.className = 'tool-toast';
            toast.style.setProperty('--toast-bg', config.bg);
            toast.innerHTML = `
                <div class="tool-toast-content">
                    <i class="fas ${config.icon}"></i>
                    <span>${this.escapeHtml(message)}</span>
                </div>
            `;

            document.body.appendChild(toast);

            // Show toast
            setTimeout(() => toast.classList.add('show'), 10);

            // Hide toast
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => toast.remove(), 300);
            }, duration);
        },

        /**
         * Escape HTML to prevent XSS
         * 
         * @param {string} text - Text to escape
         * @returns {string} Escaped HTML string
         */
        escapeHtml: function (text) {
            if (text == null) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        },

        /**
         * Basic form validation helper
         * 
         * @param {string} inputId - ID of input element
         * @param {Function} validatorFn - Validation function that returns boolean
         * @param {string} errorMessage - Error message to show
         * @returns {boolean} True if valid
         */
        validateInput: function (inputId, validatorFn, errorMessage) {
            const input = document.getElementById(inputId);
            if (!input) return false;

            const value = input.value.trim();
            const isValid = validatorFn(value);

            // Update visual state
            input.classList.toggle('field-invalid', !isValid);
            input.classList.toggle('field-valid', isValid && value.length > 0);

            // Show/hide error message
            let errorEl = input.parentElement.querySelector('.field-error');
            if (!isValid && errorMessage) {
                if (!errorEl) {
                    errorEl = document.createElement('div');
                    errorEl.className = 'field-error';
                    input.parentElement.appendChild(errorEl);
                }
                errorEl.textContent = errorMessage;
            } else if (errorEl) {
                errorEl.remove();
            }

            return isValid;
        },

        /**
         * Show loading state
         * 
         * @param {string} message - Loading message (default: 'Processing...')
         * @param {string} targetElement - Target element selector (default: '#output')
         */
        showLoading: function (message = 'Processing...', targetElement = '#output') {
            const html = `
                <div class="result-card">
                    <div class="result-header">
                        <i class="fas fa-spinner fa-spin"></i> ${this.escapeHtml(message)}
                    </div>
                </div>
            `;

            const target = document.querySelector(targetElement);
            if (target) {
                if (typeof jQuery !== 'undefined' && jQuery) {
                    jQuery(target).html(html);
                } else {
                    target.innerHTML = html;
                }
            }
        },

        /**
         * Show error message
         * 
         * @param {string} errorMessage - Error message to display
         * @param {string} targetElement - Target element selector (default: '#output')
         * @param {Array<string>} suggestions - Optional suggestions array
         */
        showError: function (errorMessage, targetElement = '#output', suggestions = []) {
            let suggestionsHtml = '';
            if (suggestions && suggestions.length > 0) {
                suggestionsHtml = `
                    <div class="error-suggestions">
                        <strong>Suggestions:</strong>
                        <ul>
                            ${suggestions.map(s => `<li>${this.escapeHtml(s)}</li>`).join('')}
                        </ul>
                    </div>
                `;
            }

            const html = `
                <div class="result-card error">
                    <div class="result-header">
                        <i class="fas fa-exclamation-triangle"></i> Operation Failed
                    </div>
                    <div class="error-content">
                        <p class="error-message">${this.escapeHtml(errorMessage)}</p>
                        ${suggestionsHtml}
                    </div>
                </div>
            `;

            const target = document.querySelector(targetElement);
            if (target) {
                if (typeof jQuery !== 'undefined' && jQuery) {
                    jQuery(target).html(html);
                    // Scroll to error
                    jQuery('html, body').animate({
                        scrollTop: jQuery(target).offset().top - 100
                    }, 300);
                } else {
                    target.innerHTML = html;
                    target.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                }
            }
        },

        /**
         * Show success message
         * 
         * @param {string} message - Success message
         * @param {string} targetElement - Target element selector (default: '#output')
         */
        showSuccess: function (message, targetElement = '#output') {
            const html = `
                <div class="result-card success">
                    <div class="result-header">
                        <i class="fas fa-check-circle"></i> ${this.escapeHtml(message)}
                    </div>
                </div>
            `;

            const target = document.querySelector(targetElement);
            if (target) {
                if (typeof jQuery !== 'undefined' && jQuery) {
                    jQuery(target).html(html);
                } else {
                    target.innerHTML = html;
                }
            }
        },

        /**
         * Format file size
         * 
         * @param {number} bytes - Size in bytes
         * @returns {string} Formatted size string
         */
        formatFileSize: function (bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
        },

        /**
         * Debounce function
         * 
         * @param {Function} func - Function to debounce
         * @param {number} wait - Wait time in ms
         * @returns {Function} Debounced function
         */
        debounce: function (func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        },

        /**
         * Throttle function
         * 
         * @param {Function} func - Function to throttle
         * @param {number} limit - Time limit in ms
         * @returns {Function} Throttled function
         */
        throttle: function (func, limit) {
            let inThrottle;
            return function (...args) {
                if (!inThrottle) {
                    func.apply(this, args);
                    inThrottle = true;
                    setTimeout(() => inThrottle = false, limit);
                }
            };
        },

        /**
         * Check if element is in viewport
         * 
         * @param {Element} element - DOM element
         * @returns {boolean} True if element is in viewport
         */
        isInViewport: function (element) {
            const rect = element.getBoundingClientRect();
            return (
                rect.top >= 0 &&
                rect.left >= 0 &&
                rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
                rect.right <= (window.innerWidth || document.documentElement.clientWidth)
            );
        },

        /**
         * Generate shareable URL from current form data
         * 
         * @param {Object} params - Parameters object {key: value}
         * @param {Object} options - Options object
         * @param {string} options.baseUrl - Base URL (default: current page URL)
         * @param {boolean} options.showSupportPopup - Show support popup after generation (default: true)
         * @param {string} options.toolName - Tool name for popup
         * @returns {string} Shareable URL
         */
        generateShareUrl: function (params, options = {}) {
            const {
                baseUrl = null,
                showSupportPopup = true,
                toolName = null
            } = typeof options === 'string' ? { baseUrl: options } : options;

            const urlBase = baseUrl || (window.location.origin + window.location.pathname);

            const urlParams = new URLSearchParams();
            for (const [key, value] of Object.entries(params)) {
                if (value != null && value !== '') {
                    urlParams.append(key, encodeURIComponent(value));
                }
            }

            const shareUrl = urlBase + '?' + urlParams.toString();

            // Show support popup after generating URL
            if (showSupportPopup) {
                setTimeout(() => {
                    this.showSupportPopup(toolName, shareUrl);
                }, 500);
            }

            return shareUrl;
        },

        /**
         * Load parameters from URL
         * 
         * @param {Object} mappings - Object mapping URL param names to input IDs
         * @param {Function} callback - Optional callback after loading
         * @returns {Object} Loaded parameters
         * 
         * Example:
         * ToolUtils.loadFromUrl({
         *   message: 'plaintext',
         *   key: 'secretkey',
         *   operation: 'encryptorDecrypt'
         * });
         */
        loadFromUrl: function (mappings, callback = null) {
            const urlParams = new URLSearchParams(window.location.search);
            const loaded = {};

            for (const [urlParam, inputId] of Object.entries(mappings)) {
                if (urlParams.has(urlParam)) {
                    const value = urlParams.get(urlParam);
                    const input = document.getElementById(inputId);

                    if (input) {
                        if (input.type === 'radio') {
                            // For radio buttons, find the one with matching value
                            const radios = document.querySelectorAll(`input[name="${inputId}"]`);
                            radios.forEach(radio => {
                                if (radio.value === value) {
                                    radio.checked = true;
                                    loaded[urlParam] = value;
                                }
                            });
                        } else if (input.type === 'checkbox') {
                            input.checked = value === 'true';
                            loaded[urlParam] = input.checked;
                        } else {
                            input.value = decodeURIComponent(value);
                            loaded[urlParam] = input.value;
                        }

                        // Trigger change event
                        if (input.dispatchEvent) {
                            input.dispatchEvent(new Event('change', { bubbles: true }));
                        }
                    }
                }
            }

            if (callback && typeof callback === 'function') {
                callback(loaded);
            }

            return loaded;
        },

        /**
         * Copy from element (textarea, input, etc.)
         * Helper function for copy buttons
         *
         * @param {Element|string} element - Element or selector
         * @param {Object} options - Copy options
         */
        copyFromElement: function (element, options = {}) {
            const el = typeof element === 'string'
                ? document.querySelector(element)
                : element;

            if (!el) return;

            const text = el.value || el.textContent || el.innerText;
            if (!text) return;

            return this.copyToClipboard(text, options);
        },

        /**
         * Download content as a file
         *
         * @param {string} content - Content to download
         * @param {string} filename - Filename with extension
         * @param {Object} options - Options object
         * @param {string} options.mimeType - MIME type (default: auto-detected from extension)
         * @param {boolean} options.showToast - Show toast notification (default: true)
         * @param {string} options.toastMessage - Custom toast message
         * @param {boolean} options.showSupportPopup - Show support popup after download (default: true)
         * @param {string} options.toolName - Tool name for support popup
         * @returns {boolean} Success status
         */
        downloadAsFile: function (content, filename, options = {}) {
            const {
                mimeType = null,
                showToast = true,
                toastMessage = null,
                showSupportPopup = true,
                toolName = null
            } = options;

            try {
                // Auto-detect MIME type from extension if not provided
                const detectedMime = mimeType || this._getMimeType(filename);

                // Create blob
                const blob = new Blob([content], { type: detectedMime });

                // Create download URL
                const url = URL.createObjectURL(blob);

                // Create temporary link and trigger download
                const link = document.createElement('a');
                link.href = url;
                link.download = filename;
                link.style.display = 'none';

                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);

                // Clean up URL object
                setTimeout(() => URL.revokeObjectURL(url), 100);

                // Show toast
                if (showToast) {
                    const message = toastMessage || `Downloaded ${filename}`;
                    this.showToast(message, 2000, 'success');
                }

                // Show support popup after download
                if (showSupportPopup) {
                    setTimeout(() => {
                        this.showSupportPopup(toolName, `Downloaded: ${filename}`);
                    }, 500);
                }

                return true;
            } catch (err) {
                console.error('Download failed:', err);
                if (showToast) {
                    this.showToast('Download failed. Please try again.', 3000, 'error');
                }
                return false;
            }
        },

        /**
         * Share result via URL with encoded data
         * Creates a shareable URL with the result encoded in a parameter
         *
         * @param {string} content - Content to share
         * @param {Object} options - Options object
         * @param {string} options.paramName - URL parameter name (default: 'data')
         * @param {boolean} options.encode - Base64 encode the content (default: true for large content)
         * @param {Object} options.extraParams - Additional URL parameters
         * @param {boolean} options.copyToClipboard - Auto copy URL to clipboard (default: true)
         * @param {boolean} options.showSupportPopup - Show support popup (default: true)
         * @param {string} options.toolName - Tool name for popup
         * @returns {string} Shareable URL
         */
        shareResult: function (content, options = {}) {
            const {
                paramName = 'data',
                encode = true,
                extraParams = {},
                copyToClipboard = true,
                showSupportPopup = true,
                toolName = null
            } = options;

            try {
                const baseUrl = window.location.origin + window.location.pathname;
                const urlParams = new URLSearchParams();

                // Encode content if needed (use base64 for safety with special chars)
                let encodedContent;
                if (encode) {
                    // Use base64 encoding for reliable URL transport
                    encodedContent = btoa(unescape(encodeURIComponent(content)));
                    urlParams.set(paramName, encodedContent);
                    urlParams.set('enc', 'base64'); // Flag to indicate encoding
                } else {
                    urlParams.set(paramName, encodeURIComponent(content));
                }

                // Add extra parameters
                for (const [key, value] of Object.entries(extraParams)) {
                    if (value != null && value !== '') {
                        urlParams.set(key, value);
                    }
                }

                const shareUrl = baseUrl + '?' + urlParams.toString();

                // Copy to clipboard
                if (copyToClipboard) {
                    this.copyToClipboard(shareUrl, {
                        toastMessage: 'Share URL copied to clipboard!',
                        showSupportPopup: showSupportPopup,
                        toolName: toolName,
                        resultText: shareUrl
                    });
                }

                return shareUrl;
            } catch (err) {
                console.error('Share failed:', err);
                this.showToast('Failed to generate share URL', 3000, 'error');
                return null;
            }
        },

        /**
         * Load shared result from URL
         * Decodes the result from URL parameters
         *
         * @param {string} paramName - URL parameter name (default: 'data')
         * @returns {string|null} Decoded content or null if not found
         */
        loadSharedResult: function (paramName = 'data') {
            try {
                const urlParams = new URLSearchParams(window.location.search);
                const data = urlParams.get(paramName);

                if (!data) return null;

                const encoding = urlParams.get('enc');

                if (encoding === 'base64') {
                    // Decode base64
                    return decodeURIComponent(escape(atob(data)));
                } else {
                    // URL decode
                    return decodeURIComponent(data);
                }
            } catch (err) {
                console.error('Failed to load shared result:', err);
                return null;
            }
        },

        /**
         * Download content from element as a file
         *
         * @param {Element|string} element - Element or selector containing content
         * @param {string} filename - Filename with extension
         * @param {Object} options - Download options
         */
        downloadFromElement: function (element, filename, options = {}) {
            const el = typeof element === 'string'
                ? document.querySelector(element)
                : element;

            if (!el) {
                console.error('Element not found for download');
                return false;
            }

            const content = el.value || el.textContent || el.innerText;
            if (!content) {
                this.showToast('No content to download', 2000, 'warning');
                return false;
            }

            return this.downloadAsFile(content, filename, options);
        },

        /**
         * Download a DOM element as PNG using dom-to-image-more (when loaded).
         * Prefer this for MathJax/LaTeX content. Falls back to downloadCanvasAsImage (html2canvas) if domtoimage unavailable.
         *
         * @param {Element|string} source - DOM element or CSS selector
         * @param {string} filename - Filename (default: 'download.png')
         * @param {Object} options - Options
         * @param {Function} options.filter - Node filter for domtoimage (return false to exclude)
         * @param {string} options.backgroundColor - Background (default: '#ffffff')
         * @param {boolean} options.showToast - Show toast (default: true)
         * @param {string} options.toastMessage - Custom toast message
         * @param {boolean} options.showSupportPopup - Show support popup (default: true)
         * @param {string} options.toolName - Tool name for popup
         * @returns {Promise<boolean>} Success status
         */
        downloadDomAsImage: async function (source, filename = 'download.png', options = {}) {
            var self = this;
            var el = typeof source === 'string' ? document.querySelector(source) : source;
            if (!el) {
                this.showToast('Element not found for image capture', 2000, 'error');
                return false;
            }
            var opts = options || {};
            var showToast = opts.showToast !== false;
            var toastMessage = opts.toastMessage || null;
            var showSupportPopup = opts.showSupportPopup !== false;
            var toolName = opts.toolName || null;

            try {
                if (showToast) {
                    this.showToast('Generating image...', 1500, 'info');
                }
                if (typeof domtoimage !== 'undefined' && domtoimage.toPng) {
                    var domOpts = {
                        quality: 1,
                        bgcolor: (opts.backgroundColor || '#ffffff'),
                        width: el.offsetWidth,
                        height: el.offsetHeight,
                        style: { margin: '0', padding: '20px' }
                    };
                    if (typeof opts.filter === 'function') {
                        domOpts.filter = opts.filter;
                    }
                    var dataUrl = await domtoimage.toPng(el, domOpts);
                    var link = document.createElement('a');
                    link.download = filename;
                    link.href = dataUrl;
                    link.click();
                    if (showToast) {
                        this.showToast(toastMessage || 'Downloaded ' + filename, 2000, 'success');
                    }
                    if (showSupportPopup) {
                        setTimeout(function () {
                            self.showSupportPopup(toolName, 'Downloaded: ' + filename);
                        }, 500);
                    }
                    return true;
                }
                return await this.downloadCanvasAsImage(source, filename, opts);
            } catch (err) {
                console.error('Download image failed:', err);
                if (showToast) {
                    this.showToast('Failed to generate image: ' + (err.message || ''), 3000, 'error');
                }
                return false;
            }
        },

        /**
         * Download a DOM element or canvas as a PNG image with 8gwifi.org watermark
         *
         * Supports:
         * - Canvas elements: used directly
         * - Any DOM element: captured via html2canvas (lazy-loaded from CDN)
         *
         * @param {Element|string} source - DOM element, canvas, or CSS selector
         * @param {string} filename - Filename (default: 'download.png')
         * @param {Object} options - Options object
         * @param {number} options.scale - Capture scale factor (default: 2 for retina)
         * @param {string} options.backgroundColor - Background color (default: '#ffffff')
         * @param {string} options.watermarkText - Watermark text (default: '8gwifi.org')
         * @param {string} options.watermarkPosition - Position: 'bottom-right', 'bottom-left', 'top-right', 'top-left' (default: 'bottom-right')
         * @param {number} options.watermarkOpacity - Watermark opacity 0-1 (default: 0.6)
         * @param {number} options.watermarkFontSize - Font size in px (default: auto-calculated)
         * @param {number} options.padding - Extra padding around captured content in px (default: 20)
         * @param {boolean} options.showToast - Show toast notification (default: true)
         * @param {string} options.toastMessage - Custom toast message
         * @param {boolean} options.showSupportPopup - Show support popup (default: true)
         * @param {string} options.toolName - Tool name for popup
         * @returns {Promise<boolean>} Success status
         */
        downloadCanvasAsImage: async function (source, filename = 'download.png', options = {}) {
            const {
                scale = 2,
                backgroundColor = '#ffffff',
                watermarkText = '8gwifi.org',
                watermarkPosition = 'bottom-right',
                watermarkOpacity = 0.6,
                watermarkFontSize = null,
                padding = 20,
                showToast = true,
                toastMessage = null,
                showSupportPopup = true,
                toolName = null
            } = options;

            try {
                // Resolve source element
                const el = typeof source === 'string'
                    ? document.querySelector(source)
                    : source;

                if (!el) {
                    this.showToast('Element not found for image capture', 2000, 'error');
                    return false;
                }

                // Show loading toast
                if (showToast) {
                    this.showToast('Generating image...', 1500, 'info');
                }

                let sourceCanvas;

                if (el instanceof HTMLCanvasElement) {
                    // Already a canvas — use directly
                    sourceCanvas = el;
                } else {
                    // Load html2canvas if not available
                    if (typeof html2canvas === 'undefined') {
                        await this._loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
                        // Verify it loaded
                        if (typeof html2canvas === 'undefined') {
                            throw new Error('Failed to load html2canvas library');
                        }
                    }

                    // Capture DOM element to canvas
                    sourceCanvas = await html2canvas(el, {
                        scale: scale,
                        backgroundColor: backgroundColor,
                        useCORS: true,
                        logging: false,
                        allowTaint: true
                    });
                }

                // Create final canvas with padding and watermark
                var pad = padding * scale;
                var finalWidth = sourceCanvas.width + pad * 2;
                var finalHeight = sourceCanvas.height + pad * 2;

                var finalCanvas = document.createElement('canvas');
                finalCanvas.width = finalWidth;
                finalCanvas.height = finalHeight;

                var ctx = finalCanvas.getContext('2d');

                // Fill background
                ctx.fillStyle = backgroundColor;
                ctx.fillRect(0, 0, finalWidth, finalHeight);

                // Draw source content centered
                ctx.drawImage(sourceCanvas, pad, pad);

                // Draw watermark
                var fontSize = watermarkFontSize
                    ? watermarkFontSize * scale
                    : Math.max(14, Math.min(24, Math.floor(finalWidth / 30))) * scale;
                ctx.font = 'bold ' + fontSize + 'px Inter, -apple-system, sans-serif';
                ctx.globalAlpha = watermarkOpacity;

                // Measure text
                var metrics = ctx.measureText(watermarkText);
                var textWidth = metrics.width;
                var textHeight = fontSize;
                var margin = 12 * scale;

                // Calculate position
                var x, y;
                switch (watermarkPosition) {
                    case 'bottom-left':
                        x = margin;
                        y = finalHeight - margin;
                        break;
                    case 'top-right':
                        x = finalWidth - textWidth - margin;
                        y = textHeight + margin;
                        break;
                    case 'top-left':
                        x = margin;
                        y = textHeight + margin;
                        break;
                    case 'bottom-right':
                    default:
                        x = finalWidth - textWidth - margin;
                        y = finalHeight - margin;
                        break;
                }

                // Draw watermark shadow for readability
                ctx.fillStyle = 'rgba(0, 0, 0, 0.3)';
                ctx.fillText(watermarkText, x + 1 * scale, y + 1 * scale);

                // Draw watermark text
                ctx.fillStyle = '#1DA1F2';
                ctx.fillText(watermarkText, x, y);

                // Reset alpha
                ctx.globalAlpha = 1.0;

                // Convert to blob and download
                var self = this;
                return new Promise(function (resolve) {
                    finalCanvas.toBlob(function (blob) {
                        if (!blob) {
                            self.showToast('Failed to generate image', 3000, 'error');
                            resolve(false);
                            return;
                        }

                        var url = URL.createObjectURL(blob);
                        var link = document.createElement('a');
                        link.href = url;
                        link.download = filename;
                        link.style.display = 'none';
                        document.body.appendChild(link);
                        link.click();
                        document.body.removeChild(link);
                        setTimeout(function () { URL.revokeObjectURL(url); }, 100);

                        if (showToast) {
                            var msg = toastMessage || 'Downloaded ' + filename;
                            self.showToast(msg, 2000, 'success');
                        }

                        if (showSupportPopup) {
                            setTimeout(function () {
                                self.showSupportPopup(toolName, 'Downloaded: ' + filename);
                            }, 500);
                        }

                        resolve(true);
                    }, 'image/png');
                });

            } catch (err) {
                console.error('Image download failed:', err);
                if (showToast) {
                    this.showToast('Image download failed: ' + err.message, 3000, 'error');
                }
                return false;
            }
        },

        /**
         * Lazy-load an external script
         * @private
         * @param {string} src - Script URL
         * @returns {Promise<void>}
         */
        _loadScript: function (src) {
            return new Promise(function (resolve, reject) {
                // Check if already loaded
                var existing = document.querySelector('script[src="' + src + '"]');
                if (existing) {
                    resolve();
                    return;
                }

                var script = document.createElement('script');
                script.src = src;
                script.onload = function () { resolve(); };
                script.onerror = function () { reject(new Error('Failed to load script: ' + src)); };
                document.head.appendChild(script);
            });
        },

        /**
         * Get MIME type from filename extension
         * @private
         */
        _getMimeType: function (filename) {
            const ext = filename.split('.').pop().toLowerCase();
            const mimeTypes = {
                // Text formats
                'txt': 'text/plain',
                'csv': 'text/csv',
                'html': 'text/html',
                'css': 'text/css',
                'js': 'application/javascript',

                // Data formats
                'json': 'application/json',
                'xml': 'application/xml',
                'yaml': 'text/yaml',
                'yml': 'text/yaml',

                // Config formats
                'ini': 'text/plain',
                'conf': 'text/plain',
                'cfg': 'text/plain',
                'env': 'text/plain',
                'properties': 'text/plain',

                // Code formats
                'py': 'text/x-python',
                'java': 'text/x-java',
                'sh': 'application/x-sh',
                'bash': 'application/x-sh',
                'sql': 'application/sql',

                // Document formats
                'md': 'text/markdown',
                'markdown': 'text/markdown',

                // Certificate/Key formats
                'pem': 'application/x-pem-file',
                'crt': 'application/x-x509-ca-cert',
                'cer': 'application/x-x509-ca-cert',
                'key': 'application/x-pem-file',
                'csr': 'application/pkcs10',
                'p12': 'application/x-pkcs12',
                'pfx': 'application/x-pkcs12',

                // Default
                'default': 'text/plain'
            };

            return mimeTypes[ext] || mimeTypes['default'];
        },

        /**
         * Show support popup asking for Twitter follow/tweet
         * 
         * @param {string} toolName - Name of the tool (optional)
         * @param {string} resultText - Result text or URL to include in tweet (optional)
         */
        showSupportPopup: function (toolName = null, resultText = null) {
            // Check if user has dismissed this popup in this session
            const dismissedKey = 'tool_support_popup_dismissed';
            if (sessionStorage.getItem(dismissedKey) === 'true') {
                return;
            }

            // Get tool name from page if not provided
            if (!toolName) {
                const toolTitle = document.querySelector('.tool-page-title, h1');
                toolName = toolTitle ? toolTitle.textContent.trim() : 'this tool';
            }

            // Truncate result text for tweet (max 100 chars)
            let tweetText = '';
            if (resultText) {
                const truncated = resultText.length > 100
                    ? resultText.substring(0, 97) + '...'
                    : resultText;
                tweetText = `\n\nResults: ${truncated}`;
            }

            // Generate tweet URL
            const tweetUrl = this._generateTweetUrl(toolName, tweetText);
            const followUrl = 'https://twitter.com/intent/follow?screen_name=anish2good';

            // Create modal backdrop
            const backdrop = document.createElement('div');
            backdrop.className = 'support-popup-backdrop';
            backdrop.setAttribute('role', 'dialog');
            backdrop.setAttribute('aria-modal', 'true');
            backdrop.setAttribute('aria-labelledby', 'support-popup-title');

            // Create modal content
            backdrop.innerHTML = `
                <div class="support-popup-modal">
                    <button class="support-popup-close" aria-label="Close support popup" onclick="ToolUtils.closeSupportPopup()">
                        <i class="fas fa-times"></i>
                    </button>
                    <div class="support-popup-content">
                        <div class="support-popup-icon">
                            <i class="fab fa-twitter"></i>
                        </div>
                        <h3 id="support-popup-title" class="support-popup-title">💝 Support This Free Tool</h3>
                        <p class="support-popup-message">
                            Help keep this tool free and running! 🚀 Follow <strong>@anish2good</strong> on X (Twitter) or share your results. 🙏
                        </p>
                        <div class="support-popup-actions">
                            <a href="${followUrl}" 
                               target="_blank" 
                               rel="noopener noreferrer"
                               class="support-popup-btn support-popup-btn-follow"
                               onclick="ToolUtils.trackSupportAction('follow')">
                                <i class="fab fa-twitter"></i>
                                🐦 Follow @anish2good
                            </a>
                            <a href="${tweetUrl}" 
                               target="_blank" 
                               rel="noopener noreferrer"
                               class="support-popup-btn support-popup-btn-tweet"
                               onclick="ToolUtils.trackSupportAction('tweet')">
                                <i class="fas fa-share-alt"></i>
                                📢 Tweet Results
                            </a>
                        </div>
                        <button class="support-popup-dismiss" onclick="ToolUtils.closeSupportPopup(true)">
                            Maybe later
                        </button>
                    </div>
                </div>
            `;

            document.body.appendChild(backdrop);
            document.body.style.overflow = 'hidden';

            // Show modal with animation
            setTimeout(() => {
                backdrop.classList.add('show');
            }, 10);

            // Close on backdrop click
            backdrop.addEventListener('click', function (e) {
                if (e.target === backdrop) {
                    ToolUtils.closeSupportPopup();
                }
            });

            // Close on Escape key
            const escapeHandler = function (e) {
                if (e.key === 'Escape') {
                    ToolUtils.closeSupportPopup();
                    document.removeEventListener('keydown', escapeHandler);
                }
            };
            document.addEventListener('keydown', escapeHandler);
        },

        /**
         * Close support popup
         * 
         * @param {boolean} rememberDismissal - Remember dismissal for this session
         */
        closeSupportPopup: function (rememberDismissal = false) {
            const backdrop = document.querySelector('.support-popup-backdrop');
            if (!backdrop) return;

            backdrop.classList.remove('show');

            setTimeout(() => {
                backdrop.remove();
                document.body.style.overflow = '';
            }, 300);

            if (rememberDismissal) {
                sessionStorage.setItem('tool_support_popup_dismissed', 'true');
            }
        },

        /**
         * Track support action (for analytics)
         * 
         * @param {string} action - Action type: 'follow' or 'tweet'
         */
        trackSupportAction: function (action) {
            // Track with analytics if available
            if (typeof trackToolUsage === 'function') {
                const toolName = document.querySelector('.tool-page-title, h1')?.textContent.trim() || 'Unknown Tool';
                trackToolUsage(toolName, 'Support', action);
            }

            // Close popup after a short delay to allow link to open
            setTimeout(() => {
                this.closeSupportPopup();
            }, 500);
        },

        /**
         * Generate Twitter/X tweet URL
         * 
         * @param {string} toolName - Name of the tool
         * @param {string} resultText - Result text to include
         * @returns {string} Tweet URL
         * @private
         */
        _generateTweetUrl: function (toolName, resultText) {
            const baseText = `Just used ${toolName} 🚀 Amazing free tool on 8gwifi.org! 💪`;
            const pageUrl = window.location.href;
            const fullText = `${baseText}${resultText}\n\n${pageUrl}\n\nFollow @anish2good for more free tools! 🎉`;

            // Twitter URL length limit is 280 chars, but we need to account for URL shortening
            const maxLength = 200; // Conservative limit
            let tweetText = fullText;

            if (tweetText.length > maxLength) {
                // Truncate result text if needed
                const availableLength = maxLength - baseText.length - pageUrl.length - 60; // Buffer for ellipsis and mentions
                if (resultText.length > availableLength) {
                    const truncatedResult = resultText.substring(0, availableLength - 3) + '...';
                    tweetText = `${baseText}${truncatedResult}\n\n${pageUrl}\n\nFollow @anish2good for more free tools! 🎉`;
                }
            }

            return `https://twitter.com/intent/tweet?text=${encodeURIComponent(tweetText)}`;
        },

        /**
         * Storage Utilities
         */
        storage: {
            /**
             * Save data to local storage
             * @param {string} key - Storage key
             * @param {any} data - Data to save (will be JSON stringified)
             * @returns {boolean} Success status
             */
            save: function (key, data) {
                try {
                    const payload = {
                        timestamp: Date.now(),
                        data: data
                    };
                    localStorage.setItem(key, JSON.stringify(payload));
                    return true;
                } catch (e) {
                    console.error('Storage save failed:', e);
                    return false;
                }
            },

            /**
             * Get data from local storage
             * @param {string} key - Storage key
             * @returns {any|null} Saved data or null
             */
            get: function (key) {
                try {
                    const item = localStorage.getItem(key);
                    if (!item) return null;
                    const payload = JSON.parse(item);
                    return payload.data; // Return actual data, strip metadata
                } catch (e) {
                    console.error('Storage get failed:', e);
                    return null;
                }
            },

            /**
             * Remove data from local storage
             * @param {string} key - Storage key
             */
            remove: function (key) {
                localStorage.removeItem(key);
            },

            /**
             * List all keys with prefix
             * @param {string} prefix - Key prefix
             * @returns {Array} Array of {key, timestamp, name}
             */
            list: function (prefix) {
                const items = [];
                for (let i = 0; i < localStorage.length; i++) {
                    const key = localStorage.key(i);
                    if (key.startsWith(prefix)) {
                        try {
                            const item = localStorage.getItem(key);
                            const payload = JSON.parse(item);
                            items.push({
                                key: key,
                                name: key.substring(prefix.length),
                                timestamp: payload.timestamp || 0
                            });
                        } catch (e) {
                            // Ignore invalid items
                        }
                    }
                }
                return items.sort((a, b) => b.timestamp - a.timestamp); // Newest first
            },

            /**
             * Open Storage Manager Modal
             * @param {Object} options
             * @param {string} options.toolName - Tool name for display
             * @param {string} options.keyPrefix - Prefix for storage keys
             * @param {Function} options.onLoad - Callback when item is loaded (data) => void
             */
            openManager: function (options) {
                const { toolName, keyPrefix, onLoad } = options;

                // Remove existing modal if any
                const existing = document.querySelector('.storage-modal-backdrop');
                if (existing) existing.remove();

                const items = this.list(keyPrefix);

                const backdrop = document.createElement('div');
                backdrop.className = 'storage-modal-backdrop';
                backdrop.innerHTML = `
                    <div class="storage-modal">
                        <div class="storage-header">
                            <h3>Saved ${ToolUtils.escapeHtml(toolName)}</h3>
                            <button class="storage-close">&times;</button>
                        </div>
                        <div class="storage-body">
                            ${items.length === 0 ? '<p class="storage-empty">No saved items found.</p>' : ''}
                            <div class="storage-list">
                                ${items.map(item => `
                                    <div class="storage-item" data-key="${item.key}">
                                        <div class="storage-info">
                                            <span class="storage-name">${ToolUtils.escapeHtml(item.name)}</span>
                                            <span class="storage-date">${new Date(item.timestamp).toLocaleString()}</span>
                                        </div>
                                        <div class="storage-actions">
                                            <button class="storage-btn load-btn">Load</button>
                                            <button class="storage-btn delete-btn">&times;</button>
                                        </div>
                                    </div>
                                `).join('')}
                            </div>
                        </div>
                    </div>
                `;

                document.body.appendChild(backdrop);
                setTimeout(() => backdrop.classList.add('show'), 10);

                // Event Listeners
                const close = () => {
                    backdrop.classList.remove('show');
                    setTimeout(() => backdrop.remove(), 300);
                };

                backdrop.querySelector('.storage-close').onclick = close;
                backdrop.onclick = (e) => { if (e.target === backdrop) close(); };

                // Delegate clicks
                backdrop.querySelector('.storage-list')?.addEventListener('click', (e) => {
                    const itemEl = e.target.closest('.storage-item');
                    if (!itemEl) return;
                    const key = itemEl.getAttribute('data-key');

                    if (e.target.classList.contains('load-btn')) {
                        const data = this.get(key);
                        if (data && onLoad) {
                            onLoad(data);
                            ToolUtils.showToast('Loaded successfully!');
                            close();
                        }
                    } else if (e.target.classList.contains('delete-btn')) {
                        if (confirm('Are you sure you want to delete this item?')) {
                            this.remove(key);
                            itemEl.remove();
                            if (backdrop.querySelectorAll('.storage-item').length === 0) {
                                backdrop.querySelector('.storage-body').innerHTML = '<p class="storage-empty">No saved items found.</p>';
                            }
                        }
                    }
                });
            }
        }
    };

    // Auto-initialize toast styles if not already present
    if (!document.getElementById('tool-utils-styles')) {
        const style = document.createElement('style');
        style.id = 'tool-utils-styles';
        style.textContent = `
            .tool-toast {
                position: fixed;
                bottom: 2rem;
                right: 2rem;
                background: var(--toast-bg, #10b981);
                color: white;
                padding: 1rem 1.5rem;
                border-radius: 0.5rem;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 10000;
                opacity: 0;
                transform: translateY(20px);
                transition: all 0.3s ease;
                max-width: 400px;
            }

            .tool-toast.show {
                opacity: 1;
                transform: translateY(0);
            }

            .tool-toast-content {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-weight: 500;
            }

            .tool-toast-content i {
                font-size: 1.25rem;
            }

            @media (max-width: 767px) {
                .tool-toast {
                    bottom: 1rem;
                    right: 1rem;
                    left: 1rem;
                    max-width: none;
                }
            }

            /* Field validation states */
            .field-valid {
                border-color: var(--success, #10b981) !important;
                box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
            }

            .field-invalid {
                border-color: var(--error, #ef4444) !important;
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
            }

            .field-error {
                color: var(--error, #ef4444);
                font-size: 0.875rem;
                margin-top: 0.5rem;
                display: flex;
                align-items: center;
                gap: 0.25rem;
            }

            .field-error::before {
                content: "⚠️";
                font-size: 0.875rem;
            }

            [data-theme="dark"] .field-valid {
                border-color: var(--success, #10b981) !important;
            }

            [data-theme="dark"] .field-invalid {
                border-color: var(--error, #ef4444) !important;
            }

            /* Error suggestions styling */
            .error-suggestions {
                background: var(--bg-tertiary, #f1f5f9);
                border-left: 4px solid var(--warning, #f59e0b);
                padding: 1rem;
                border-radius: 0.5rem;
                margin-top: 1rem;
            }

            [data-theme="dark"] .error-suggestions {
                background: var(--bg-tertiary, #334155);
            }

            .error-suggestions strong {
                color: var(--warning, #f59e0b);
                display: block;
                margin-bottom: 0.5rem;
            }

            .error-suggestions ul {
                margin: 0.5rem 0 0 0;
                padding-left: 1.5rem;
            }

            .error-suggestions li {
                margin-bottom: 0.25rem;
                color: var(--text-secondary, #475569);
            }

            /* Support Popup Modal */
            .support-popup-backdrop {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(4px);
                z-index: var(--z-modal, 1050);
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 1rem;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .support-popup-backdrop.show {
                opacity: 1;
            }

            .support-popup-modal {
                background: var(--bg-primary, #ffffff);
                border-radius: 1rem;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                max-width: 500px;
                width: 100%;
                position: relative;
                transform: scale(0.95);
                transition: transform 0.3s ease;
            }

            .support-popup-backdrop.show .support-popup-modal {
                transform: scale(1);
            }

            .support-popup-close {
                position: absolute;
                top: 1rem;
                right: 1rem;
                background: var(--bg-secondary, #f8fafc);
                border: none;
                border-radius: 50%;
                width: 2rem;
                height: 2rem;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                color: var(--text-secondary, #475569);
                transition: all 0.2s;
                z-index: 1;
            }

            .support-popup-close:hover {
                background: var(--bg-tertiary, #f1f5f9);
                color: var(--text-primary, #0f172a);
            }

            .support-popup-content {
                padding: 2rem;
                text-align: center;
            }

            .support-popup-icon {
                font-size: 3rem;
                color: #1DA1F2;
                margin-bottom: 1rem;
            }

            .support-popup-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--text-primary, #0f172a);
                margin-bottom: 1rem;
            }

            .support-popup-message {
                color: var(--text-secondary, #475569);
                margin-bottom: 1.5rem;
                line-height: 1.6;
            }

            .support-popup-message strong {
                color: var(--text-primary, #0f172a);
            }

            .support-popup-actions {
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
                margin-bottom: 1rem;
            }

            .support-popup-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                padding: 0.875rem 1.5rem;
                border-radius: 0.75rem;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.2s;
                border: 2px solid transparent;
            }

            .support-popup-btn-follow {
                background: #1DA1F2;
                color: white;
            }

            .support-popup-btn-follow:hover {
                background: #1a91da;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(29, 161, 242, 0.3);
            }

            .support-popup-btn-tweet {
                background: var(--bg-secondary, #f8fafc);
                color: var(--text-primary, #0f172a);
                border-color: var(--border, #e2e8f0);
            }

            .support-popup-btn-tweet:hover {
                background: var(--bg-tertiary, #f1f5f9);
                border-color: #1DA1F2;
                color: #1DA1F2;
            }

            .support-popup-dismiss {
                background: none;
                border: none;
                color: var(--text-muted, #94a3b8);
                font-size: 0.875rem;
                cursor: pointer;
                padding: 0.5rem;
                transition: color 0.2s;
            }

            .support-popup-dismiss:hover {
                color: var(--text-secondary, #475569);
            }

            /* Dark mode support */
            [data-theme="dark"] .support-popup-modal {
                background: var(--bg-secondary, #1e293b);
            }

            [data-theme="dark"] .support-popup-title {
                color: var(--text-primary, #f1f5f9);
            }

            [data-theme="dark"] .support-popup-message {
                color: var(--text-secondary, #cbd5e1);
            }

            [data-theme="dark"] .support-popup-message strong {
                color: var(--text-primary, #f1f5f9);
            }

            [data-theme="dark"] .support-popup-btn-tweet {
                background: var(--bg-tertiary, #334155);
                color: var(--text-primary, #f1f5f9);
                border-color: var(--border, #334155);
            }

            [data-theme="dark"] .support-popup-btn-tweet:hover {
                background: var(--bg-secondary, #1e293b);
                border-color: #1DA1F2;
            }

            [data-theme="dark"] .support-popup-close {
                background: var(--bg-tertiary, #334155);
                color: var(--text-secondary, #cbd5e1);
            }

            [data-theme="dark"] .support-popup-close:hover {
                background: var(--bg-secondary, #1e293b);
                color: var(--text-primary, #f1f5f9);
            }

            @media (max-width: 767px) {
                .support-popup-modal {
                    max-width: 100%;
                    margin: 1rem;
                }

                .support-popup-content {
                    padding: 1.5rem;
                }

                .support-popup-actions {
                    flex-direction: column;
                }
            }

            /* Storage Modal */
            .storage-modal-backdrop {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: rgba(0, 0, 0, 0.5);
                    backdrop-filter: blur(4px);
                    z-index: 1050;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 1rem;
                    opacity: 0;
                    transition: opacity 0.3s ease;
                }

                .storage-modal-backdrop.show {
                    opacity: 1;
                }

                .storage-modal {
                    background: var(--bg-primary, #ffffff);
                    border-radius: 1rem;
                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 600px;
                    max-height: 80vh;
                    display: flex;
                    flex-direction: column;
                }

                .storage-header {
                    padding: 1.5rem;
                    border-bottom: 1px solid var(--border, #e2e8f0);
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .storage-header h3 {
                    margin: 0;
                    font-size: 1.25rem;
                    color: var(--text-primary, #0f172a);
                }

                .storage-close {
                    background: none;
                    border: none;
                    font-size: 1.5rem;
                    color: var(--text-secondary, #475569);
                    cursor: pointer;
                    padding: 0.5rem;
                    line-height: 1;
                }

                .storage-body {
                    padding: 1.5rem;
                    overflow-y: auto;
                }

                .storage-empty {
                    text-align: center;
                    color: var(--text-secondary, #475569);
                    padding: 2rem;
                }

                .storage-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 1rem;
                    border: 1px solid var(--border, #e2e8f0);
                    border-radius: 0.5rem;
                    margin-bottom: 0.75rem;
                    background: var(--bg-secondary, #f8fafc);
                    transition: all 0.2s;
                }

                .storage-item:hover {
                    border-color: var(--tool-primary, #875afb);
                }

                .storage-info {
                    display: flex;
                    flex-direction: column;
                    gap: 0.25rem;
                }

                .storage-name {
                    font-weight: 600;
                    color: var(--text-primary, #0f172a);
                }

                .storage-date {
                    font-size: 0.875rem;
                    color: var(--text-secondary, #475569);
                }

                .storage-actions {
                    display: flex;
                    gap: 0.5rem;
                }

                .storage-btn {
                    padding: 0.5rem 1rem;
                    border-radius: 0.375rem;
                    font-weight: 500;
                    font-size: 0.875rem;
                    cursor: pointer;
                    transition: all 0.2s;
                    border: 1px solid transparent;
                }

                .load-btn {
                    background: var(--tool-primary, #875afb);
                    color: white;
                }

                .load-btn:hover {
                    background: var(--tool-primary-dark, #7c3aed);
                }

                .delete-btn {
                    background: transparent;
                    color: var(--error, #ef4444);
                    font-size: 1.25rem;
                    padding: 0.5rem;
                    line-height: 1;
                }

                .delete-btn:hover {
                    background: rgba(239, 68, 68, 0.1);
                }

                [data-theme="dark"] .storage-modal {
                    background: var(--bg-secondary, #1e293b);
                }

                [data-theme="dark"] .storage-item {
                    background: var(--bg-tertiary, #334155);
                    border-color: var(--border, #475569);
                }
        `;
        document.head.appendChild(style);
    }

})();


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Social Popup Component for Tutorials
    Shows engagement-based popup to encourage sharing and following

    Triggers:
    - User stays on page for X minutes
    - User clicks "Run" button X+ times
    - User navigates to prev/next lesson

    Includes: Share menu dropdown from header Share button

    Usage: <%@ include file="social-popup.jsp" %>
--%>

<!-- Share Menu Dropdown (for header Share button) -->
<div class="share-menu" id="shareMenu">
    <div class="share-menu-content">
        <div class="share-menu-header">
            <span>Share this tutorial</span>
            <button class="share-menu-close" onclick="closeShareMenu()" aria-label="Close">&times;</button>
        </div>
        <div class="share-menu-options">
            <button class="share-option" onclick="shareOnTwitter()">
                <span class="share-icon">𝕏</span>
                <span>Twitter</span>
            </button>
            <button class="share-option" onclick="shareOnFacebook()">
                <span class="share-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                    </svg>
                </span>
                <span>Facebook</span>
            </button>
            <button class="share-option" onclick="shareOnLinkedIn()">
                <span class="share-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                    </svg>
                </span>
                <span>LinkedIn</span>
            </button>
            <button class="share-option" onclick="copyPageLink()">
                <span class="share-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"/>
                        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
                    </svg>
                </span>
                <span>Copy Link</span>
            </button>
        </div>
    </div>
</div>

<!-- Engagement Popup -->
<div class="social-popup" id="socialPopup">
    <div class="social-popup-content">
        <button class="social-popup-close" onclick="closeSocialPopup()" aria-label="Close popup">&times;</button>

        <div class="social-popup-header">
            <span class="popup-emoji">🚀</span>
            <h3>Enjoying these tutorials?</h3>
        </div>

        <p class="social-popup-message">
            Help this project grow! Share with others or connect with me for updates on new tutorials.
        </p>

        <div class="social-popup-actions">
            <a href="https://twitter.com/anish2good"
               target="_blank"
               rel="noopener"
               class="popup-btn popup-btn-twitter"
               onclick="trackSocialAction('follow')">
                <span class="popup-btn-icon">𝕏</span>
                <span>Follow @anish2good</span>
            </a>

            <button class="popup-btn popup-btn-share" onclick="shareFromPopup()">
                <span class="popup-btn-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="18" cy="5" r="3"/>
                        <circle cx="6" cy="12" r="3"/>
                        <circle cx="18" cy="19" r="3"/>
                        <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/>
                        <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>
                    </svg>
                </span>
                <span>Share Tutorial</span>
            </button>

            <a href="https://buymeacoffee.com/8gwifi.org"
               target="_blank"
               rel="noopener"
               class="popup-btn popup-btn-coffee"
               onclick="trackSocialAction('coffee')">
                <span class="popup-btn-icon">☕</span>
                <span>Buy me a coffee</span>
            </a>
        </div>

        <button class="popup-dismiss" onclick="dismissPopupForever()">
            Don't show this again
        </button>
    </div>
</div>

<!-- Overlay -->
<div class="social-overlay" id="socialOverlay" onclick="closeAllSocialUI()"></div>

<style>
/* ============================================
   SHARE MENU DROPDOWN (Header Share Button)
   ============================================ */
.share-menu {
    position: fixed;
    top: 60px;
    right: 20px;
    z-index: 1000;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.2s ease;
}

.share-menu.active {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.share-menu-content {
    background: var(--bg-primary);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
    min-width: 200px;
    overflow: hidden;
}

.share-menu-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.75rem 1rem;
    border-bottom: 1px solid var(--border);
    font-size: var(--text-sm);
    font-weight: 600;
    color: var(--text-primary);
}

.share-menu-close {
    background: none;
    border: none;
    font-size: 1.25rem;
    color: var(--text-secondary);
    cursor: pointer;
    padding: 0;
    line-height: 1;
}

.share-menu-close:hover {
    color: var(--text-primary);
}

.share-menu-options {
    padding: 0.5rem;
}

.share-option {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    width: 100%;
    padding: 0.625rem 0.75rem;
    background: none;
    border: none;
    border-radius: var(--radius-md);
    font-size: var(--text-sm);
    color: var(--text-primary);
    cursor: pointer;
    transition: background 0.15s ease;
    font-family: inherit;
}

.share-option:hover {
    background: var(--bg-tertiary);
}

.share-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 24px;
    color: var(--text-secondary);
}

/* ============================================
   ENGAGEMENT POPUP
   ============================================ */
.social-popup {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) scale(0.9);
    z-index: 1001;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
}

.social-popup.active {
    opacity: 1;
    visibility: visible;
    transform: translate(-50%, -50%) scale(1);
}

.social-popup-content {
    background: var(--bg-primary);
    border: 1px solid var(--border);
    border-radius: var(--radius-xl);
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
    padding: 2rem;
    max-width: 400px;
    width: 90vw;
    position: relative;
    text-align: center;
}

.social-popup-close {
    position: absolute;
    top: 1rem;
    right: 1rem;
    background: none;
    border: none;
    font-size: 1.5rem;
    color: var(--text-secondary);
    cursor: pointer;
    line-height: 1;
    padding: 0.25rem;
    border-radius: var(--radius-sm);
    transition: all 0.15s ease;
}

.social-popup-close:hover {
    background: var(--bg-tertiary);
    color: var(--text-primary);
}

.social-popup-header {
    margin-bottom: 1rem;
}

.popup-emoji {
    font-size: 2.5rem;
    display: block;
    margin-bottom: 0.5rem;
}

.social-popup-header h3 {
    font-size: var(--text-xl);
    font-weight: 700;
    color: var(--text-primary);
    margin: 0;
}

.social-popup-message {
    font-size: var(--text-sm);
    color: var(--text-secondary);
    line-height: 1.6;
    margin-bottom: 1.5rem;
}

.social-popup-actions {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
}

.popup-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    padding: 0.75rem 1.25rem;
    font-size: var(--text-sm);
    font-weight: 600;
    text-decoration: none;
    border: none;
    border-radius: var(--radius-md);
    cursor: pointer;
    transition: all 0.2s ease;
    font-family: inherit;
}

.popup-btn-icon {
    display: flex;
    align-items: center;
    font-size: 1.125rem;
}

.popup-btn-twitter {
    background: #1a1a1a;
    color: #ffffff;
}

.popup-btn-twitter:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

[data-theme="dark"] .popup-btn-twitter {
    background: #ffffff;
    color: #1a1a1a;
}

.popup-btn-share {
    background: var(--accent-primary);
    color: #ffffff;
}

.popup-btn-share:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(56, 189, 248, 0.4);
}

.popup-btn-coffee {
    background: linear-gradient(135deg, #ffdd00 0%, #fbb034 100%);
    color: #1a1a1a;
}

.popup-btn-coffee:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(251, 176, 52, 0.4);
}

.popup-dismiss {
    background: none;
    border: none;
    color: var(--text-muted);
    font-size: var(--text-xs);
    cursor: pointer;
    margin-top: 1rem;
    padding: 0.5rem;
    transition: color 0.15s ease;
}

.popup-dismiss:hover {
    color: var(--text-secondary);
    text-decoration: underline;
}

/* ============================================
   OVERLAY
   ============================================ */
.social-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 999;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
}

.social-overlay.active {
    opacity: 1;
    visibility: visible;
}

/* ============================================
   TOAST NOTIFICATION
   ============================================ */
.social-toast {
    position: fixed;
    bottom: 80px;
    left: 50%;
    transform: translateX(-50%) translateY(20px);
    background: var(--bg-primary);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 0.75rem 1.5rem;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
    z-index: 1002;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
    font-size: var(--text-sm);
    font-weight: 500;
    color: var(--text-primary);
}

.social-toast.active {
    opacity: 1;
    visibility: visible;
    transform: translateX(-50%) translateY(0);
}

.social-toast.success {
    border-left: 3px solid #10b981;
}

/* ============================================
   DARK MODE
   ============================================ */
[data-theme="dark"] .share-menu-content,
[data-theme="dark"] .social-popup-content {
    background: var(--bg-secondary);
    border-color: var(--border);
}

[data-theme="dark"] .social-overlay {
    background: rgba(0, 0, 0, 0.7);
}

[data-theme="dark"] .social-toast {
    background: var(--bg-secondary);
}

/* ============================================
   MOBILE RESPONSIVE
   ============================================ */
@media (max-width: 480px) {
    .share-menu {
        top: auto;
        bottom: 0;
        right: 0;
        left: 0;
        transform: translateY(100%);
    }

    .share-menu.active {
        transform: translateY(0);
    }

    .share-menu-content {
        border-radius: var(--radius-xl) var(--radius-xl) 0 0;
        padding-bottom: env(safe-area-inset-bottom, 0);
    }

    .social-popup-content {
        padding: 1.5rem;
        border-radius: var(--radius-lg);
    }

    .popup-emoji {
        font-size: 2rem;
    }
}
</style>

<!-- Toast Element -->
<div class="social-toast" id="socialToast"></div>

<script src="<%=request.getContextPath()%>/tutorials/assets/js/social-popup.js"></script>

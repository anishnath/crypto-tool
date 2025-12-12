/**
 * Social Popup - Engagement-based sharing prompts for tutorials
 *
 * Features:
 * - Smart triggers based on user engagement
 * - Configurable timing and thresholds
 * - LocalStorage persistence for frequency control
 * - Share functionality for Twitter, Facebook, LinkedIn
 */

// ============================================
// CONFIGURATION (Tune these values)
// ============================================
const SOCIAL_POPUP_CONFIG = {
    // Trigger thresholds
    minTimeOnPage: 180,         // Seconds before time-based trigger (3 minutes)
    minRunClicks: 4,            // Run button clicks before trigger
    runClicksRepeat: true,      // If true, show popup every minRunClicks (4, 8, 12...)
    triggerOnNavigation: true,  // Show on prev/next navigation

    // Frequency control
    maxPerSession: 2,           // Max popups per session (ignored for runClicksRepeat)
    cooldownHours: 1,           // Hours before showing again after dismiss (ignored for runClicksRepeat)
    neverShowCooldownHours: 2,  // Hours before "Don't show again" expires

    // Grace period
    firstVisitDelay: 60,        // Seconds to wait on first ever visit

    // Feature flags
    enabled: true,              // Master switch
    debug: false                // Console logging
};

// ============================================
// STATE MANAGEMENT
// ============================================
const SocialPopupState = {
    sessionShowCount: 0,
    runClickCount: 0,
    pageLoadTime: Date.now(),
    hasInteracted: false,
    popupShown: false,
    shareMenuOpen: false
};

// ============================================
// STORAGE HELPERS
// ============================================
const Storage = {
    KEY_LAST_DISMISS: 'social_popup_last_dismiss',
    KEY_NEVER_SHOW: 'social_popup_never_show',
    KEY_FIRST_VISIT: 'social_popup_first_visit',
    KEY_SESSION_COUNT: 'social_popup_session_count',
    KEY_HAS_SHARED: 'social_popup_has_shared',
    KEY_HAS_FOLLOWED: 'social_popup_has_followed',

    get(key) {
        try {
            return localStorage.getItem(key);
        } catch (e) {
            return null;
        }
    },

    set(key, value) {
        try {
            localStorage.setItem(key, value);
        } catch (e) {
            // Storage not available
        }
    },

    getNumber(key, defaultVal = 0) {
        const val = this.get(key);
        return val ? parseInt(val, 10) : defaultVal;
    }
};

// ============================================
// UTILITY FUNCTIONS
// ============================================
function log(...args) {
    if (SOCIAL_POPUP_CONFIG.debug) {
        console.log('[SocialPopup]', ...args);
    }
}

function getPageTitle() {
    const h1 = document.querySelector('.lesson-title, h1');
    return h1 ? h1.textContent.trim() : document.title;
}

function getPageUrl() {
    return window.location.href;
}

function getShareText() {
    const title = getPageTitle();
    return `Learning "${title}" on 8gwifi.org Tutorials! Check it out:`;
}

function getHashtags() {
    // Detect language from URL or page
    const url = window.location.pathname.toLowerCase();
    const hashtags = ['LearnToCode', 'Programming'];

    if (url.includes('/python/')) hashtags.unshift('Python');
    else if (url.includes('/javascript/')) hashtags.unshift('JavaScript');
    else if (url.includes('/java/')) hashtags.unshift('Java');
    else if (url.includes('/rust/')) hashtags.unshift('Rust');
    else if (url.includes('/typescript/')) hashtags.unshift('TypeScript');
    else if (url.includes('/html/')) hashtags.unshift('HTML');
    else if (url.includes('/css/')) hashtags.unshift('CSS');
    else if (url.includes('/bash/')) hashtags.unshift('Bash', 'Linux');
    else if (url.includes('/lua/')) hashtags.unshift('Lua');

    return hashtags;
}

// ============================================
// ELIGIBILITY CHECK
// ============================================
function canShowPopup() {
    // Master switch
    if (!SOCIAL_POPUP_CONFIG.enabled) {
        log('Disabled by config');
        return false;
    }

    // Already shown this page load
    if (SocialPopupState.popupShown) {
        log('Already shown this page');
        return false;
    }

    // User chose "never show again" - check with expiry
    const neverShowTime = Storage.getNumber(Storage.KEY_NEVER_SHOW);
    if (neverShowTime) {
        const hoursSince = (Date.now() - neverShowTime) / (1000 * 60 * 60);
        if (hoursSince < SOCIAL_POPUP_CONFIG.neverShowCooldownHours) {
            log('In "never show" cooldown, hours remaining:', (SOCIAL_POPUP_CONFIG.neverShowCooldownHours - hoursSince).toFixed(2));
            return false;
        }
        // Cooldown expired, clear it
        Storage.set(Storage.KEY_NEVER_SHOW, '');
    }

    // Session limit
    const sessionCount = Storage.getNumber(Storage.KEY_SESSION_COUNT);
    if (sessionCount >= SOCIAL_POPUP_CONFIG.maxPerSession) {
        log('Session limit reached:', sessionCount);
        return false;
    }

    // Cooldown period
    const lastDismiss = Storage.getNumber(Storage.KEY_LAST_DISMISS);
    if (lastDismiss) {
        const hoursSince = (Date.now() - lastDismiss) / (1000 * 60 * 60);
        if (hoursSince < SOCIAL_POPUP_CONFIG.cooldownHours) {
            log('In cooldown period, hours since:', hoursSince.toFixed(2));
            return false;
        }
    }

    // First visit grace period
    const firstVisit = Storage.get(Storage.KEY_FIRST_VISIT);
    if (!firstVisit) {
        Storage.set(Storage.KEY_FIRST_VISIT, Date.now().toString());
        log('First visit, setting grace period');
        return false;
    }

    return true;
}

// ============================================
// POPUP TRIGGERS
// ============================================
function checkTimeBasedTrigger() {
    if (!canShowPopup()) return;

    const secondsOnPage = (Date.now() - SocialPopupState.pageLoadTime) / 1000;

    if (secondsOnPage >= SOCIAL_POPUP_CONFIG.minTimeOnPage) {
        log('Time trigger:', secondsOnPage, 'seconds');
        showSocialPopup();
    }
}

function checkRunClickTrigger() {
    SocialPopupState.runClickCount++;
    log('Run click count:', SocialPopupState.runClickCount);

    // Repeating run click trigger - bypasses cooldown/session limits
    if (SOCIAL_POPUP_CONFIG.runClicksRepeat) {
        // Check only basic eligibility (enabled, not in "never show" cooldown)
        if (!SOCIAL_POPUP_CONFIG.enabled) return;

        // Check "Don't show again" with expiry
        const neverShowTime = Storage.getNumber(Storage.KEY_NEVER_SHOW);
        if (neverShowTime) {
            const hoursSince = (Date.now() - neverShowTime) / (1000 * 60 * 60);
            if (hoursSince < SOCIAL_POPUP_CONFIG.neverShowCooldownHours) {
                log('In "never show" cooldown, hours remaining:', (SOCIAL_POPUP_CONFIG.neverShowCooldownHours - hoursSince).toFixed(2));
                return;
            }
            // Cooldown expired, clear it
            Storage.set(Storage.KEY_NEVER_SHOW, '');
        }

        // Trigger every N clicks (4, 8, 12, etc.)
        if (SocialPopupState.runClickCount % SOCIAL_POPUP_CONFIG.minRunClicks === 0) {
            log('Run click repeat trigger at:', SocialPopupState.runClickCount);
            SocialPopupState.popupShown = false; // Reset to allow showing again
            showSocialPopup();
        }
        return;
    }

    // Standard behavior - respects all limits
    if (!canShowPopup()) return;

    if (SocialPopupState.runClickCount >= SOCIAL_POPUP_CONFIG.minRunClicks) {
        log('Run click trigger reached');
        showSocialPopup();
    }
}

function checkNavigationTrigger() {
    if (!SOCIAL_POPUP_CONFIG.triggerOnNavigation) return;
    if (!canShowPopup()) return;

    // Only trigger if user has spent some time on page
    const secondsOnPage = (Date.now() - SocialPopupState.pageLoadTime) / 1000;
    if (secondsOnPage >= SOCIAL_POPUP_CONFIG.firstVisitDelay) {
        log('Navigation trigger');
        showSocialPopup();
    }
}

// ============================================
// POPUP UI FUNCTIONS
// ============================================
function showSocialPopup() {
    const popup = document.getElementById('socialPopup');
    const overlay = document.getElementById('socialOverlay');

    if (!popup || !overlay) return;

    popup.classList.add('active');
    overlay.classList.add('active');
    SocialPopupState.popupShown = true;

    // Increment session count
    const count = Storage.getNumber(Storage.KEY_SESSION_COUNT) + 1;
    Storage.set(Storage.KEY_SESSION_COUNT, count.toString());

    log('Popup shown, session count:', count);
}

function closeSocialPopup() {
    const popup = document.getElementById('socialPopup');
    const overlay = document.getElementById('socialOverlay');

    if (popup) popup.classList.remove('active');
    if (overlay) overlay.classList.remove('active');

    // Record dismiss time
    Storage.set(Storage.KEY_LAST_DISMISS, Date.now().toString());
    log('Popup closed');
}

function dismissPopupForever() {
    // Store timestamp instead of boolean - expires after neverShowCooldownHours
    Storage.set(Storage.KEY_NEVER_SHOW, Date.now().toString());
    closeSocialPopup();
    showToast('Got it! We won\'t bother you for a while.');
    log('Popup disabled forever');
}

// ============================================
// SHARE MENU FUNCTIONS
// ============================================
function openShareMenu() {
    const menu = document.getElementById('shareMenu');
    const overlay = document.getElementById('socialOverlay');

    if (menu) {
        menu.classList.add('active');
        SocialPopupState.shareMenuOpen = true;
    }
    if (overlay) overlay.classList.add('active');
}

function closeShareMenu() {
    const menu = document.getElementById('shareMenu');
    const overlay = document.getElementById('socialOverlay');

    if (menu) {
        menu.classList.remove('active');
        SocialPopupState.shareMenuOpen = false;
    }
    if (overlay && !document.getElementById('socialPopup')?.classList.contains('active')) {
        overlay.classList.remove('active');
    }
}

function closeAllSocialUI() {
    closeSocialPopup();
    closeShareMenu();
}

// ============================================
// SHARE FUNCTIONS
// ============================================
function shareOnTwitter() {
    const text = getShareText();
    const url = getPageUrl();
    const hashtags = getHashtags().join(',');

    const twitterUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}&hashtags=${encodeURIComponent(hashtags)}&via=anish2good`;

    window.open(twitterUrl, '_blank', 'width=550,height=420');
    trackSocialAction('share_twitter');
    closeAllSocialUI();
    showToast('Thanks for sharing!');
}

function shareOnFacebook() {
    const url = getPageUrl();
    const fbUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`;

    window.open(fbUrl, '_blank', 'width=550,height=420');
    trackSocialAction('share_facebook');
    closeAllSocialUI();
    showToast('Thanks for sharing!');
}

function shareOnLinkedIn() {
    const url = getPageUrl();
    const title = getPageTitle();
    const linkedInUrl = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`;

    window.open(linkedInUrl, '_blank', 'width=550,height=420');
    trackSocialAction('share_linkedin');
    closeAllSocialUI();
    showToast('Thanks for sharing!');
}

function copyPageLink() {
    const url = getPageUrl();

    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(url).then(() => {
            showToast('Link copied to clipboard!');
        }).catch(() => {
            fallbackCopyToClipboard(url);
        });
    } else {
        fallbackCopyToClipboard(url);
    }

    trackSocialAction('copy_link');
    closeAllSocialUI();
}

function fallbackCopyToClipboard(text) {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();

    try {
        document.execCommand('copy');
        showToast('Link copied to clipboard!');
    } catch (e) {
        showToast('Failed to copy link');
    }

    document.body.removeChild(textarea);
}

function shareFromPopup() {
    closeSocialPopup();
    setTimeout(() => {
        openShareMenu();
    }, 100);
}

// ============================================
// TRACKING
// ============================================
function trackSocialAction(action) {
    log('Social action:', action);

    if (action === 'follow') {
        Storage.set(Storage.KEY_HAS_FOLLOWED, 'true');
    } else if (action.startsWith('share')) {
        Storage.set(Storage.KEY_HAS_SHARED, 'true');
    }

    // Analytics tracking (if available)
    if (typeof gtag === 'function') {
        gtag('event', 'social_action', {
            action: action,
            page: getPageUrl()
        });
    }
}

// ============================================
// TOAST NOTIFICATION
// ============================================
function showToast(message, type = 'success') {
    const toast = document.getElementById('socialToast');
    if (!toast) return;

    toast.textContent = message;
    toast.className = 'social-toast active ' + type;

    setTimeout(() => {
        toast.classList.remove('active');
    }, 3000);
}

// ============================================
// INITIALIZATION
// ============================================
function initSocialPopup() {
    log('Initializing with config:', SOCIAL_POPUP_CONFIG);

    // Reset session count on new session (30 min inactivity = new session)
    const lastActivity = Storage.getNumber('social_popup_last_activity');
    const thirtyMinutes = 30 * 60 * 1000;
    if (Date.now() - lastActivity > thirtyMinutes) {
        Storage.set(Storage.KEY_SESSION_COUNT, '0');
        log('New session detected, reset count');
    }
    Storage.set('social_popup_last_activity', Date.now().toString());

    // Time-based trigger
    setTimeout(() => {
        checkTimeBasedTrigger();
    }, SOCIAL_POPUP_CONFIG.minTimeOnPage * 1000);

    // Hook into Run button clicks
    document.addEventListener('click', (e) => {
        // Match tutorial run buttons:
        // - .compiler-btn-primary: Python, Bash, Java, Rust, TypeScript, Lua (backend compilers)
        // - [id$="-run-btn"]: ID pattern for compiler buttons
        // - .btn-success: HTML, CSS, JavaScript tutorials (live preview run buttons)
        // - .run-btn, .btn-run: Generic fallbacks
        const runBtn = e.target.closest('.compiler-btn-primary, [id$="-run-btn"], .btn-success, .run-btn, .btn-run');
        if (runBtn) {
            checkRunClickTrigger();
        }
    });

    // Hook into prev/next navigation
    document.addEventListener('click', (e) => {
        const navLink = e.target.closest('.nav-prev, .nav-next, .lesson-nav a');
        if (navLink) {
            checkNavigationTrigger();
        }
    });

    // Keyboard shortcut to close (Escape)
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            closeAllSocialUI();
        }
    });

    log('Initialization complete');
}

// Start when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initSocialPopup);
} else {
    initSocialPopup();
}

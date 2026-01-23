/**
 * Social Popup - Engagement-based sharing prompts for exam practice
 *
 * Features:
 * - Smart triggers based on correct answers and streaks
 * - Configurable timing and thresholds
 * - LocalStorage persistence for frequency control
 * - Share functionality for Twitter, Facebook, LinkedIn, WhatsApp
 */

// ============================================
// CONFIGURATION
// ============================================
const SOCIAL_POPUP_CONFIG = {
    // Trigger thresholds
    minTimeOnPage: 30,          // Seconds before time-based trigger
    minCorrectAnswers: 5,       // Correct answers before trigger
    minStreak: 5,               // Streak to trigger popup
    streakRepeat: true,         // Trigger every minStreak (5, 10, 15...)

    // Frequency control
    maxPerSession: 2,           // Max popups per session
    cooldownHours: 2,           // Hours before showing again after dismiss
    neverShowCooldownHours: 24, // Hours before "Don't show again" expires

    // Feature flags
    enabled: true,
    debug: false
};

// ============================================
// STATE MANAGEMENT
// ============================================
const SocialPopupState = {
    sessionShowCount: 0,
    correctAnswers: 0,
    lastStreakTrigger: 0,       // Track last streak milestone
    pageLoadTime: Date.now(),
    popupShown: false,
    shareMenuOpen: false,
    currentTopic: null,
    currentStreak: 0
};

// ============================================
// STORAGE HELPERS
// ============================================
const Storage = {
    KEY_LAST_DISMISS: 'exam_social_popup_last_dismiss',
    KEY_NEVER_SHOW: 'exam_social_popup_never_show',
    KEY_FIRST_VISIT: 'exam_social_popup_first_visit',
    KEY_SESSION_COUNT: 'exam_social_popup_session_count',
    KEY_HAS_SHARED: 'exam_social_popup_has_shared',
    KEY_HAS_FOLLOWED: 'exam_social_popup_has_followed',

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
        console.log('[ExamSocialPopup]', ...args);
    }
}

function getTopicTitle() {
    const h1 = document.querySelector('#topic-title, .section-title, h1');
    return h1 ? h1.textContent.trim() : 'Mental Math Practice';
}

function getPageUrl() {
    return window.location.href;
}

function getShareText() {
    const title = getTopicTitle();
    const streak = SocialPopupState.currentStreak;
    if (streak > 0) {
        return `I just hit a ${streak}-streak on "${title}" at 8gwifi.org! Free mental math practice:`;
    }
    return `Practicing "${title}" on 8gwifi.org - Free mental math tricks for competitive exams:`;
}

function getHashtags() {
    const hashtags = ['MentalMath', 'QuickMath', 'MathTricks'];
    const url = window.location.pathname.toLowerCase();

    if (url.includes('ssc') || url.includes('bank')) hashtags.push('SSC', 'BankExam');
    else if (url.includes('cat') || url.includes('mba')) hashtags.push('CAT', 'MBA');
    else hashtags.push('CompetitiveExam');

    return hashtags;
}

// ============================================
// ELIGIBILITY CHECK
// ============================================
function canShowPopup() {
    if (!SOCIAL_POPUP_CONFIG.enabled) {
        log('Disabled by config');
        return false;
    }

    if (SocialPopupState.popupShown) {
        log('Already shown this page');
        return false;
    }

    // Check "never show" with expiry
    const neverShowTime = Storage.getNumber(Storage.KEY_NEVER_SHOW);
    if (neverShowTime) {
        const hoursSince = (Date.now() - neverShowTime) / (1000 * 60 * 60);
        if (hoursSince < SOCIAL_POPUP_CONFIG.neverShowCooldownHours) {
            log('In "never show" cooldown');
            return false;
        }
        Storage.set(Storage.KEY_NEVER_SHOW, '');
    }

    // Session limit
    const sessionCount = Storage.getNumber(Storage.KEY_SESSION_COUNT);
    if (sessionCount >= SOCIAL_POPUP_CONFIG.maxPerSession) {
        log('Session limit reached');
        return false;
    }

    // Cooldown period
    const lastDismiss = Storage.getNumber(Storage.KEY_LAST_DISMISS);
    if (lastDismiss) {
        const hoursSince = (Date.now() - lastDismiss) / (1000 * 60 * 60);
        if (hoursSince < SOCIAL_POPUP_CONFIG.cooldownHours) {
            log('In cooldown period');
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
// POPUP TRIGGERS - Called by practice.jsp
// ============================================
function checkStreakTrigger(currentStreak) {
    SocialPopupState.currentStreak = currentStreak;

    if (currentStreak < SOCIAL_POPUP_CONFIG.minStreak) return;

    // Check if we've hit a new milestone (5, 10, 15...)
    const milestone = Math.floor(currentStreak / SOCIAL_POPUP_CONFIG.minStreak) * SOCIAL_POPUP_CONFIG.minStreak;

    if (milestone > SocialPopupState.lastStreakTrigger) {
        SocialPopupState.lastStreakTrigger = milestone;

        // For streak triggers, bypass session limit but check "never show"
        const neverShowTime = Storage.getNumber(Storage.KEY_NEVER_SHOW);
        if (neverShowTime) {
            const hoursSince = (Date.now() - neverShowTime) / (1000 * 60 * 60);
            if (hoursSince < SOCIAL_POPUP_CONFIG.neverShowCooldownHours) {
                log('In "never show" cooldown');
                return;
            }
        }

        log('Streak milestone reached:', milestone);
        SocialPopupState.popupShown = false; // Allow showing again
        showSocialPopup();
    }
}

function checkCorrectAnswerTrigger() {
    SocialPopupState.correctAnswers++;
    log('Correct answers:', SocialPopupState.correctAnswers);

    if (!canShowPopup()) return;

    if (SocialPopupState.correctAnswers >= SOCIAL_POPUP_CONFIG.minCorrectAnswers) {
        log('Correct answer trigger reached');
        showSocialPopup();
    }
}

function checkTimeBasedTrigger() {
    if (!canShowPopup()) return;

    const secondsOnPage = (Date.now() - SocialPopupState.pageLoadTime) / 1000;

    if (secondsOnPage >= SOCIAL_POPUP_CONFIG.minTimeOnPage) {
        log('Time trigger:', secondsOnPage, 'seconds');
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

    // Update message based on streak
    const header = popup.querySelector('.social-popup-header h3');
    const streak = SocialPopupState.currentStreak;
    if (header && streak >= 5) {
        header.textContent = `${streak}-streak! Amazing!`;
    }

    popup.classList.add('active');
    overlay.classList.add('active');
    SocialPopupState.popupShown = true;

    // Increment session count
    const count = Storage.getNumber(Storage.KEY_SESSION_COUNT) + 1;
    Storage.set(Storage.KEY_SESSION_COUNT, count.toString());

    trackPopupEvent('shown');
    log('Popup shown, session count:', count);
}

function closeSocialPopup(skipTracking = false) {
    const popup = document.getElementById('socialPopup');
    const overlay = document.getElementById('socialOverlay');

    if (popup) popup.classList.remove('active');
    if (overlay) overlay.classList.remove('active');

    Storage.set(Storage.KEY_LAST_DISMISS, Date.now().toString());

    if (!skipTracking) {
        trackPopupEvent('dismissed');
    }

    log('Popup closed');
}

function dismissPopupForever() {
    Storage.set(Storage.KEY_NEVER_SHOW, Date.now().toString());
    trackPopupEvent('never_show');
    closeSocialPopup(true);
    showToast('Got it! We won\'t bother you for a while.');
    log('Popup disabled for ' + SOCIAL_POPUP_CONFIG.neverShowCooldownHours + ' hours');
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
    const linkedInUrl = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`;

    window.open(linkedInUrl, '_blank', 'width=550,height=420');
    trackSocialAction('share_linkedin');
    closeAllSocialUI();
    showToast('Thanks for sharing!');
}

function shareOnWhatsApp() {
    const text = getShareText();
    const url = getPageUrl();
    const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(text + ' ' + url)}`;

    window.open(whatsappUrl, '_blank');
    trackSocialAction('share_whatsapp');
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
function trackEvent(eventName, params = {}) {
    const fullParams = {
        page_url: getPageUrl(),
        page_title: getTopicTitle(),
        streak: SocialPopupState.currentStreak,
        correct_answers: SocialPopupState.correctAnswers,
        ...params
    };

    log('Track event:', eventName, fullParams);

    // Google Analytics 4
    if (typeof gtag === 'function') {
        gtag('event', eventName, fullParams);
    }
}

function trackSocialAction(action) {
    log('Social action:', action);

    if (action === 'follow') {
        Storage.set(Storage.KEY_HAS_FOLLOWED, 'true');
    } else if (action.startsWith('share')) {
        Storage.set(Storage.KEY_HAS_SHARED, 'true');
    }

    trackEvent('social_action', {
        action: action,
        event_category: 'engagement'
    });
}

function trackPopupEvent(action) {
    trackEvent('social_popup', {
        action: action,
        event_category: 'engagement'
    });
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
    log('Initializing exam social popup');

    // Reset session count on new session (30 min inactivity)
    const lastActivity = Storage.getNumber('exam_social_popup_last_activity');
    const thirtyMinutes = 30 * 60 * 1000;
    if (Date.now() - lastActivity > thirtyMinutes) {
        Storage.set(Storage.KEY_SESSION_COUNT, '0');
        log('New session detected, reset count');
    }
    Storage.set('exam_social_popup_last_activity', Date.now().toString());

    // Time-based trigger
    setTimeout(() => {
        checkTimeBasedTrigger();
    }, SOCIAL_POPUP_CONFIG.minTimeOnPage * 1000);

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

// Export for practice.jsp to call
window.ExamSocialPopup = {
    checkStreak: checkStreakTrigger,
    checkCorrectAnswer: checkCorrectAnswerTrigger,
    openShareMenu: openShareMenu,
    showToast: showToast
};

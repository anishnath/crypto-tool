<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Side Rails Ads (Desktop Only)
    Placement: Sticky ads on left and right side of viewport
    Desktop: 160x600 or 300x250 on each side
    Display: Only on screens > 1400px

    Usage: <%@ include file="../modern/ads/ad-side-rails.jsp" %>
--%>

<!-- Left Rail Ad -->
<div class="ad-side-rail ad-side-rail-left" id="adSideRailLeft">
    <div class="ad-container ad-rail-slot"
         id="site_8gwifi_org_rail_left"
         data-ad-type="side-rail"
         role="complementary"
         aria-label="Advertisement">
        <div class="ad-label">Ad</div>
        <div class="ad-content">
            <!-- Ad will be loaded here -->
        </div>
    </div>
</div>

<!-- Right Rail Ad -->
<div class="ad-side-rail ad-side-rail-right" id="adSideRailRight">
    <div class="ad-container ad-rail-slot"
         id="site_8gwifi_org_rail_right"
         data-ad-type="side-rail"
         role="complementary"
         aria-label="Advertisement">
        <div class="ad-label">Ad</div>
        <div class="ad-content">
            <!-- Ad will be loaded here -->
        </div>
    </div>
</div>

<style>
/* Side Rails Ad Styles */
.ad-side-rail {
    position: fixed;
    top: 50%;
    transform: translateY(-50%);
    z-index: 100;
    display: none;
}

.ad-side-rail-left {
    left: 10px;
}

.ad-side-rail-right {
    right: 10px;
}

.ad-rail-slot {
    background: var(--bg-secondary, #f5f5f5);
    border: 1px solid var(--border, #e0e0e0);
    border-radius: 8px;
    padding: 8px;
    min-width: 160px;
    min-height: 600px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.ad-rail-slot .ad-label {
    font-size: 10px;
    color: var(--text-secondary, #888);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 8px;
}

.ad-rail-slot .ad-content {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 160px;
    min-height: 580px;
    background: var(--bg-tertiary, #eee);
    border-radius: 4px;
}

/* Show side rails only on wide screens (> 1400px) */
@media (min-width: 1400px) {
    .ad-side-rail {
        display: block;
    }

    /* Add body padding when side rails are visible */
    body.has-side-rails {
        /* No padding needed - rails are outside content flow */
    }
}

/* Hide on smaller screens */
@media (max-width: 1399px) {
    .ad-side-rail {
        display: none !important;
    }
}

/* Wider screens - can show larger ads */
@media (min-width: 1600px) {
    .ad-rail-slot {
        min-width: 300px;
    }

    .ad-rail-slot .ad-content {
        width: 300px;
    }

    .ad-side-rail-left {
        left: 20px;
    }

    .ad-side-rail-right {
        right: 20px;
    }
}

/* Dark mode support */
[data-theme="dark"] .ad-rail-slot {
    background: var(--bg-secondary, #1a1a2e);
    border-color: var(--border, #2a2a4a);
}

[data-theme="dark"] .ad-rail-slot .ad-content {
    background: var(--bg-tertiary, #252540);
}
</style>

<script>
// Initialize side rail ads
(function() {
    var leftRail = document.getElementById('adSideRailLeft');
    var rightRail = document.getElementById('adSideRailRight');

    function checkAndShowRails() {
        if (window.innerWidth >= 1400) {
            if (leftRail) leftRail.style.display = 'block';
            if (rightRail) rightRail.style.display = 'block';
            document.body.classList.add('has-side-rails');

            // Load ads if ad system is available
            if (typeof googletag !== 'undefined' && googletag.cmd) {
                googletag.cmd.push(function() {
                    googletag.display('site_8gwifi_org_rail_left');
                    googletag.display('site_8gwifi_org_rail_right');
                });
            }
        } else {
            if (leftRail) leftRail.style.display = 'none';
            if (rightRail) rightRail.style.display = 'none';
            document.body.classList.remove('has-side-rails');
        }
    }

    // Check on load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', checkAndShowRails);
    } else {
        checkAndShowRails();
    }

    // Check on resize
    window.addEventListener('resize', checkAndShowRails);
})();
</script>

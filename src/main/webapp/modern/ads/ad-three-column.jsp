<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Three-Column Layout Ad Component
    ================================
    For use in pages with three-column CSS Grid layouts (Input | Output | Ads)

    Placement: Within dedicated ad column in CSS Grid - uses sticky positioning, NOT fixed

    Features:
    - Sticky positioning within grid column
    - Two stacked 300x250/336x280 rectangle ads
    - Lazy loading with IntersectionObserver
    - Loading placeholder animation
    - Dark mode support
    - Hides automatically on tablet/mobile (<1200px)

    Grid Requirements:
    - Parent grid should have a dedicated column for ads (typically 300px)
    - Example: grid-template-columns: minmax(320px, 400px) 1fr 300px;

    Desktop (>=1200px): Shows 2 stacked rectangle ads
    Tablet/Mobile (<1200px): Hidden (use ad-in-content-mid.jsp instead)

    Usage: <%@ include file="modern/ads/ad-three-column.jsp" %>

    Recommended with: ad-in-content-mid.jsp for mobile fallback
--%>

<div class="ad-three-column-stack" id="adThreeColumnStack">
    <!-- Ad Slot 1: Primary Rectangle -->
    <div class="ad-container ad-three-column-slot"
         id="site_8gwifi_org_three_col_primary"
         data-ad-type="three-column-rectangle"
         role="complementary"
         aria-label="Advertisement">

        <div class="ad-label">Advertisement</div>

        <div class="ad-content">
            <script>
                (function() {
                    var adContainer = document.getElementById('site_8gwifi_org_three_col_primary');
                    if (!adContainer) return;

                    // Load immediately on desktop
                    if (window.innerWidth >= 1200) {
                        setTimeout(function() {
                            adContainer.classList.add('ad-loaded');

                            if (typeof googletag !== 'undefined' && googletag.cmd) {
                                googletag.cmd.push(function() {
                                    // Reuse sidebar_top slot definition from ad-init.jsp
                                    googletag.display('site_8gwifi_org_sidebar_top');
                                });
                            }
                        }, 500);
                    }
                })();
            </script>
        </div>
    </div>

    <!-- Ad Slot 2: Secondary Rectangle -->
    <div class="ad-container ad-three-column-slot ad-three-column-secondary"
         id="site_8gwifi_org_three_col_secondary"
         data-ad-type="three-column-rectangle"
         role="complementary"
         aria-label="Advertisement">

        <div class="ad-label">Advertisement</div>

        <div class="ad-content">
            <script>
                (function() {
                    var adContainer = document.getElementById('site_8gwifi_org_three_col_secondary');
                    if (!adContainer) return;

                    // Lazy load second ad using IntersectionObserver
                    if ('IntersectionObserver' in window && window.innerWidth >= 1200) {
                        var observer = new IntersectionObserver(function(entries) {
                            entries.forEach(function(entry) {
                                if (entry.isIntersecting) {
                                    adContainer.classList.add('ad-loaded');

                                    if (typeof googletag !== 'undefined' && googletag.cmd) {
                                        googletag.cmd.push(function() {
                                            // Reuse sidebar_mid slot definition from ad-init.jsp
                                            googletag.display('site_8gwifi_org_sidebar_mid');
                                        });
                                    }
                                    observer.unobserve(adContainer);
                                }
                            });
                        }, {
                            rootMargin: '100px',
                            threshold: 0.1
                        });

                        observer.observe(adContainer);
                    }
                })();
            </script>
        </div>
    </div>
</div>

<style>
/* ============================================
   THREE-COLUMN LAYOUT AD STYLES
   For use within CSS Grid three-column layouts
   ============================================ */

.ad-three-column-stack {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    position: sticky;
    top: 90px;
    height: fit-content;
    max-height: calc(100vh - 110px);
}

.ad-three-column-slot {
    position: relative;
    min-height: 250px;
    background: var(--bg-primary, #ffffff);
    border: 1px solid var(--border, #e2e8f0);
    border-radius: 0.5rem;
    padding: 0.75rem;
    margin: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    opacity: 0.7;
    transition: opacity 0.3s ease;
}

.ad-three-column-slot.ad-loaded {
    opacity: 1;
}

.ad-three-column-slot .ad-label {
    position: absolute;
    top: 0.5rem;
    left: 0.75rem;
    font-size: 0.625rem;
    color: var(--text-secondary, #64748b);
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin: 0;
}

.ad-three-column-slot .ad-content {
    width: 100%;
    min-height: 250px;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Placeholder styling before ad loads */
.ad-three-column-slot:not(.ad-loaded) .ad-content::after {
    content: '';
    width: 280px;
    height: 230px;
    background: linear-gradient(135deg, #f1f5f9 0%, #e2e8f0 100%);
    border-radius: 0.375rem;
    animation: adThreeColPulse 2s ease-in-out infinite;
}

@keyframes adThreeColPulse {
    0%, 100% { opacity: 0.5; }
    50% { opacity: 0.8; }
}

/* Hide on tablet and mobile - use in-content ads instead */
@media (max-width: 1199px) {
    .ad-three-column-stack {
        display: none;
    }
}

/* Desktop: Standard size */
@media (min-width: 1200px) {
    .ad-three-column-slot {
        min-height: 250px;
    }
}

/* Large desktop: Larger ads */
@media (min-width: 1400px) {
    .ad-three-column-slot {
        min-height: 280px;
    }

    .ad-three-column-slot:not(.ad-loaded) .ad-content::after {
        width: 300px;
        height: 250px;
    }
}

/* Dark mode support */
[data-theme="dark"] .ad-three-column-slot {
    background: var(--bg-secondary, #1e293b);
    border-color: var(--border, #334155);
}

[data-theme="dark"] .ad-three-column-slot:not(.ad-loaded) .ad-content::after {
    background: linear-gradient(135deg, #334155 0%, #1e293b 100%);
}
</style>

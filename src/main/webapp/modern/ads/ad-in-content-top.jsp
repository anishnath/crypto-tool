<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    In-Content Leaderboard Ad
    Placement: After tool results, before "How It Works" section
    
    Desktop: 728x90 Leaderboard
    Tablet: 728x90 Leaderboard
    Mobile: 320x100 Banner or 336x280 Large Mobile
    
    Usage: <%@ include file="modern/ads/ad-in-content-top.jsp" %>
--%>

<div class="ad-container ad-in-content-top" 
     id="site_8gwifi_org_leaderboard_responsive"
     data-ad-type="leaderboard"
     role="complementary"
     aria-label="Advertisement">
    
    <div class="ad-label">Advertisement</div>

    <script>
        // Lazy load ad using native IntersectionObserver
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_leaderboard_responsive');
            if (!adContainer) return;

            // Mark as lazy loading
            adContainer.setAttribute('data-ad-lazy', 'true');

            // Check if IntersectionObserver is supported
            if ('IntersectionObserver' in window) {
                // Create observer with 200px margin (load before entering viewport)
                var observer = new IntersectionObserver(function(entries) {
                    entries.forEach(function(entry) {
                        if (entry.isIntersecting) {
                            // Ad is about to enter viewport, load it
                            if (typeof googletag !== 'undefined' && googletag.cmd) {
                                googletag.cmd.push(function() {
                                    googletag.display('site_8gwifi_org_leaderboard_responsive');
                                    adContainer.classList.add('ad-loaded');
                                    console.log('✅ Ad loaded (Top): Leaderboard');
                                });
                            }
                            // Stop observing after loading
                            observer.unobserve(adContainer);
                        }
                    });
                }, {
                    rootMargin: '200px', // Load 200px before ad enters viewport
                    threshold: 0.01 // Trigger as soon as 1% is visible
                });

                // Start observing
                observer.observe(adContainer);
                console.log('🔍 Observing ad (Top): Will load when near viewport');
            } else {
                // Fallback for older browsers (IE11, etc.)
                console.warn('⚠️ IntersectionObserver not supported, loading ad immediately');
                if (typeof googletag !== 'undefined' && googletag.cmd) {
                    googletag.cmd.push(function() {
                        googletag.display('site_8gwifi_org_leaderboard_responsive');
                        adContainer.classList.add('ad-loaded');
                    });
                }
            }
        })();
    </script>
</div>


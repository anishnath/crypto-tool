<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    In-Content Rectangle Ad
    Placement: Mid-content, between sections (after "How It Works")
    
    Desktop: 300x250 Medium Rectangle
    Tablet: 300x250 Medium Rectangle
    Mobile: 300x250 or 320x100
    
    Usage: <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
--%>

<div class="ad-container ad-in-content-mid" 
     id="site_8gwifi_org_rectangle_responsive"
     data-ad-type="rectangle"
     role="complementary"
     aria-label="Advertisement">
    
    <div class="ad-label">Advertisement</div>

    <script>
        // Lazy load ad using native IntersectionObserver
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_rectangle_responsive');
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
                                    googletag.display('site_8gwifi_org_rectangle_responsive');
                                    console.log('✅ Ad loaded (Mid): Rectangle');
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
                console.log('🔍 Observing ad (Mid): Will load when near viewport');
            } else {
                // Fallback for older browsers (IE11, etc.)
                console.warn('⚠️ IntersectionObserver not supported, loading ad immediately');
                if (typeof googletag !== 'undefined' && googletag.cmd) {
                    googletag.cmd.push(function() {
                        googletag.display('site_8gwifi_org_rectangle_responsive');
                    });
                }
            }
        })();
    </script>
</div>


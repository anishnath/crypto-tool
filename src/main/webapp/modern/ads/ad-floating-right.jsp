<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Floating Right Rectangle Ad (Desktop Only)
    Placement: Fixed right side of viewport (screens > 1200px)
    
    Desktop: 336x280 or 300x250 Rectangle
    Display: Only on screens > 1200px, after user scrolls 300px
    
    Usage: <%@ include file="modern/ads/ad-floating-right.jsp" %>
--%>

<div class="ad-container ad-floating-right" 
     id="site_8gwifi_org_floating_right"
     data-ad-type="floating-rectangle"
     role="complementary"
     aria-label="Advertisement">
    
    <div class="ad-label">Advertisement</div>
    <button class="ad-close" onclick="closeFloatingAd()" aria-label="Close ad">×</button>
    
    <script>
        // Show floating ad on desktop after scroll
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_floating_right');
            if (!adContainer) return;
            
            var hasScrolled = false;
            var isDesktop = window.innerWidth >= 1200;
            
            // Check if user has dismissed the ad
            var dismissed = localStorage.getItem('floatingAdDismissed') === 'true';
            
            function checkScroll() {
                if (!hasScrolled && !dismissed && window.pageYOffset >= 300 && isDesktop) {
                    hasScrolled = true;
                    adContainer.classList.add('ad-visible');
                    
                    // Load ad when visible
                    if (typeof googletag !== 'undefined' && googletag.cmd) {
                        googletag.cmd.push(function() {
                            googletag.display('site_8gwifi_org_floating_right');
                        });
                    }
                }
            }
            
            // Close floating ad function
            window.closeFloatingAd = function() {
                if (adContainer) {
                    adContainer.classList.remove('ad-visible');
                    localStorage.setItem('floatingAdDismissed', 'true');
                }
            };
            
            // Check on scroll
            window.addEventListener('scroll', checkScroll);
            
            // Check immediately if already scrolled
            if (window.pageYOffset >= 300 && isDesktop && !dismissed) {
                checkScroll();
            }
            
            // Hide on resize if no longer desktop
            window.addEventListener('resize', function() {
                if (window.innerWidth < 1200) {
                    adContainer.classList.remove('ad-visible');
                } else if (window.pageYOffset >= 300 && !dismissed) {
                    adContainer.classList.add('ad-visible');
                }
            });
        })();
    </script>
</div>


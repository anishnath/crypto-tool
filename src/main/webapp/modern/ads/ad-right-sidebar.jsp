<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Right Column Ad Container (Desktop Only)
    Placement: Fixed right side, uses empty space, stacked vertical ads
    Desktop: Multiple 300x250 or 336x280 rectangles stacked
    Display: Only on screens > 1300px
    
    Usage: <%@ include file="modern/ads/ad-right-sidebar.jsp" %>
--%>

<div class="ad-right-column" id="adRightColumn">
    <!-- Ad Slot 1: Top Rectangle -->
    <div class="ad-container ad-right-slot" 
         id="site_8gwifi_org_sidebar_top"
         data-ad-type="right-column-rectangle"
         role="complementary"
         aria-label="Advertisement">
        
        <div class="ad-label">Advertisement</div>
        <button class="ad-close" onclick="closeSidebarAd('site_8gwifi_org_sidebar_top')" aria-label="Close ad">×</button>
        
        <div class="ad-content">
            <script>
                // Load top sidebar ad
                (function() {
                    var adContainer = document.getElementById('site_8gwifi_org_sidebar_top');
                    if (!adContainer) return;
                    
                    var dismissed = localStorage.getItem('rightAdTopDismissed') === 'true';
                    if (dismissed) {
                        adContainer.style.display = 'none';
                        return;
                    }
                    
                    // Show after page load on desktop
                    if (window.innerWidth >= 1300) {
                        setTimeout(function() {
                            adContainer.classList.add('ad-visible');
                            document.body.classList.add('has-right-ads');
                            
                            if (typeof googletag !== 'undefined' && googletag.cmd) {
                                googletag.cmd.push(function() {
                                    googletag.display('site_8gwifi_org_sidebar_top');
                                });
                            }
                        }, 2000);
                    }
                })();
                
                // Close function
                window.closeSidebarAd = function(adId) {
                    var ad = document.getElementById(adId);
                    if (ad) {
                        ad.classList.remove('ad-visible');
                        var key = adId === 'site_8gwifi_org_sidebar_top' ? 'rightAdTopDismissed' : 'rightAdMidDismissed';
                        localStorage.setItem(key, 'true');
                        setTimeout(function() {
                            if (ad) ad.style.display = 'none';
                        }, 300);
                    }
                };
            </script>
        </div>
    </div>
    
    <!-- Ad Slot 2: Middle Rectangle (appears after scroll) -->
    <div class="ad-container ad-right-slot" 
         id="site_8gwifi_org_sidebar_mid"
         data-ad-type="right-column-rectangle"
         role="complementary"
         aria-label="Advertisement">
        
        <div class="ad-label">Advertisement</div>
        <button class="ad-close" onclick="closeSidebarAd('site_8gwifi_org_sidebar_mid')" aria-label="Close ad">×</button>
        
        <div class="ad-content">
            <script>
                // Load mid sidebar ad after scroll
                (function() {
                    var adContainer = document.getElementById('site_8gwifi_org_sidebar_mid');
                    if (!adContainer) return;
                    
                    var dismissed = localStorage.getItem('rightAdMidDismissed') === 'true';
                    var hasScrolled = false;
                    
                    if (dismissed) {
                        adContainer.style.display = 'none';
                        return;
                    }
                    
                    function checkScroll() {
                        if (!hasScrolled && window.pageYOffset >= 500 && window.innerWidth >= 1300) {
                            hasScrolled = true;
                            adContainer.classList.add('ad-visible');
                            document.body.classList.add('has-right-ads');
                            
                            if (typeof googletag !== 'undefined' && googletag.cmd) {
                                googletag.cmd.push(function() {
                                    googletag.display('site_8gwifi_org_sidebar_mid');
                                });
                            }
                        }
                    }
                    
                    window.addEventListener('scroll', checkScroll);
                    if (window.pageYOffset >= 500 && window.innerWidth >= 1300) {
                        checkScroll();
                    }
                })();
            </script>
        </div>
    </div>
</div>


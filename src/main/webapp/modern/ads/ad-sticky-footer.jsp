<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Sticky Footer Anchor Ad
    Placement: Fixed bottom of viewport, dismissible
    
    Desktop: 728x90 Leaderboard
    Mobile: 320x100 Banner
    
    Features:
    - Dismissible (stored in localStorage)
    - Auto-collapse after 30 seconds
    - Smooth animations
    
    Usage: <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
--%>

<div class="ad-container ad-sticky-footer" 
     id="site_8gwifi_org_anchor_responsive"
     data-ad-type="anchor"
     role="complementary"
     aria-label="Advertisement">
    
    <button class="ad-close" 
            aria-label="Close advertisement"
            onclick="dismissStickyAd()"
            type="button">×</button>
    
    <div class="ad-label">Advertisement</div>
    
    <div class="ad-content">
        <script>
            // Check if user has dismissed ad
            (function() {
                var dismissed = localStorage.getItem('ad_anchor_dismissed');
                if (dismissed === 'true') {
                    var container = document.getElementById('site_8gwifi_org_anchor_responsive');
                    if (container) {
                        container.style.display = 'none';
                    }
                    return;
                }
                
                // Show ad after page load
                window.addEventListener('load', function() {
                    var container = document.getElementById('site_8gwifi_org_anchor_responsive');
                    if (!container) return;
                    
                    // Delay showing on mobile (better UX)
                    var delay = window.innerWidth < 768 ? 3000 : 1000;
                    
                    setTimeout(function() {
                        container.classList.add('ad-visible');
                        
                        // Auto-collapse after 30 seconds
                        setTimeout(function() {
                            if (container && !container.classList.contains('ad-dismissed')) {
                                container.classList.add('ad-collapsed');
                            }
                        }, 30000);
                    }, delay);
                    
                    // Load ad
                    googletag.cmd.push(function() {
                        googletag.display('site_8gwifi_org_anchor_responsive');
                    });
                });
            })();
            
            // Dismiss function
            function dismissStickyAd() {
                var container = document.getElementById('site_8gwifi_org_anchor_responsive');
                if (container) {
                    container.classList.add('ad-dismissed');
                    localStorage.setItem('ad_anchor_dismissed', 'true');
                    
                    // Smooth hide animation
                    setTimeout(function() {
                        if (container) {
                            container.style.display = 'none';
                        }
                    }, 300);
                }
            }
        </script>
    </div>
</div>


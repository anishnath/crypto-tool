<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Below-Grid Leaderboard — Dashboard Main Content
    Placement: After the document grid in .me-dash-main

    Desktop: 728x90 leaderboard
    Mobile: 320x100 or 320x50 banner

    Usage: <%@ include file="modern/ads/ad-below-grid.jsp" %>
--%>

<div class="ad-container ad-below-grid"
     id="site_8gwifi_org_below_grid"
     data-ad-type="below-grid"
     role="complementary"
     aria-label="Advertisement">

    <div class="ad-label">Advertisement</div>

    <script>
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_below_grid');
            if (!adContainer) return;
            adContainer.setAttribute('data-ad-lazy', 'true');

            if ('IntersectionObserver' in window) {
                var observer = new IntersectionObserver(function(entries) {
                    entries.forEach(function(entry) {
                        if (entry.isIntersecting) {
                            if (typeof googletag !== 'undefined' && googletag.cmd) {
                                googletag.cmd.push(function() {
                                    googletag.display('site_8gwifi_org_below_grid');
                                });
                            }
                            observer.unobserve(adContainer);
                        }
                    });
                }, { rootMargin: '200px', threshold: 0.01 });
                observer.observe(adContainer);
            } else {
                if (typeof googletag !== 'undefined' && googletag.cmd) {
                    googletag.cmd.push(function() {
                        googletag.display('site_8gwifi_org_below_grid');
                    });
                }
            }
        })();
    </script>
</div>

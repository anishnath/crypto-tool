<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Panel Native Ad — Editor Right Panel (top position)
    Placement: Above the Outline tab inside .me-right-panel

    Desktop (>1024px): 250x250 square or 300x250 rectangle (fits 280px panel)
    Tablet/Mobile: Hidden (right panel is hidden below 1024px)

    Usage: <%@ include file="modern/ads/ad-panel-native.jsp" %>
--%>

<div class="ad-container ad-panel-native"
     id="site_8gwifi_org_panel_native"
     data-ad-type="panel-native"
     role="complementary"
     aria-label="Advertisement">

    <div class="ad-label">Sponsored</div>

    <script>
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_panel_native');
            if (!adContainer) return;
            adContainer.setAttribute('data-ad-lazy', 'true');

            if ('IntersectionObserver' in window) {
                var observer = new IntersectionObserver(function(entries) {
                    entries.forEach(function(entry) {
                        if (entry.isIntersecting) {
                            if (typeof googletag !== 'undefined' && googletag.cmd) {
                                googletag.cmd.push(function() {
                                    googletag.display('site_8gwifi_org_panel_native');
                                });
                            }
                            observer.unobserve(adContainer);
                        }
                    });
                }, { rootMargin: '100px', threshold: 0.01 });
                observer.observe(adContainer);
            } else {
                if (typeof googletag !== 'undefined' && googletag.cmd) {
                    googletag.cmd.push(function() {
                        googletag.display('site_8gwifi_org_panel_native');
                    });
                }
            }
        })();
    </script>
</div>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Sidebar Native Ad — Dashboard Left Sidebar
    Placement: Below navigation links in .me-sidebar

    Desktop (>768px): 200x200 square or 160x600 skyscraper
    Mobile: Hidden (sidebar collapses)

    Usage: <%@ include file="modern/ads/ad-sidebar-native.jsp" %>
--%>

<div class="ad-container ad-sidebar-native"
     id="site_8gwifi_org_sidebar_native"
     data-ad-type="sidebar-native"
     role="complementary"
     aria-label="Advertisement">

    <div class="ad-label">Sponsored</div>

    <script>
        (function() {
            var adContainer = document.getElementById('site_8gwifi_org_sidebar_native');
            if (!adContainer) return;
            adContainer.setAttribute('data-ad-lazy', 'true');

            if ('IntersectionObserver' in window) {
                var observer = new IntersectionObserver(function(entries) {
                    entries.forEach(function(entry) {
                        if (entry.isIntersecting) {
                            if (typeof googletag !== 'undefined' && googletag.cmd) {
                                googletag.cmd.push(function() {
                                    googletag.display('site_8gwifi_org_sidebar_native');
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
                        googletag.display('site_8gwifi_org_sidebar_native');
                    });
                }
            }
        })();
    </script>
</div>

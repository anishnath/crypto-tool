<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Visual Physics Lab - Additional Ad Placements
    Includes: Floating sidebars (desktop >=1600px) + Anchor sticky (mobile)

    Usage: <%@ include file="vp-ads.jsp" %> (place before footer include)
--%>
<!-- Floating Right Sidebar Ad (wide desktop, positioned via CSS) -->
<div class="viz-sidebar-ad">
    <div id='exam_sidebar' class="ad-slot" style="min-height:250px;">
        <script>
            (function() {
                if (window.innerWidth < 1720) return;
                function displaySidebar() {
                    if (typeof googletag === 'undefined') return;
                    googletag.cmd.push(function() {
                        try {
                            googletag.display('exam_sidebar');
                            if (typeof stpd !== 'undefined' && stpd.que) {
                                stpd.que.push(function() {
                                    if (typeof stpd.initializeAdUnit === 'function') {
                                        stpd.initializeAdUnit('exam_sidebar');
                                    }
                                });
                            }
                        } catch(e) {}
                    });
                }
                if (typeof inView !== 'undefined') {
                    inView('#exam_sidebar').once('enter', displaySidebar);
                } else {
                    displaySidebar();
                }
            })();
        </script>
    </div>
</div>

<!-- Floating Left Sidebar Ad (large desktop, skyscraper) -->
<div class="viz-sidebar-ad-left">
    <div id='exam_sidebar_left' class="ad-slot" style="min-height:600px;width:160px;">
        <script>
            (function() {
                if (window.innerWidth < 1600) return;
                function displayLeftSidebar() {
                    if (typeof googletag === 'undefined') return;
                    googletag.cmd.push(function() {
                        try {
                            googletag.display('exam_sidebar_left');
                            if (typeof stpd !== 'undefined' && stpd.que) {
                                stpd.que.push(function() {
                                    if (typeof stpd.initializeAdUnit === 'function') {
                                        stpd.initializeAdUnit('exam_sidebar_left');
                                    }
                                });
                            }
                        } catch(e) {}
                    });
                }
                if (typeof inView !== 'undefined') {
                    inView('#exam_sidebar_left').once('enter', displayLeftSidebar);
                } else {
                    displayLeftSidebar();
                }
            })();
        </script>
    </div>
</div>

<!-- Anchor/Sticky Bottom Ad (mobile only) -->
<div id='exam_anchor' class="ad-slot-sticky" style="display:none;">
    <button onclick="this.parentElement.style.display='none'" style="position:absolute;top:-24px;right:8px;background:var(--bg-tertiary);border:none;border-radius:4px 4px 0 0;padding:2px 8px;font-size:12px;color:var(--text-muted);cursor:pointer;">
        Close
    </button>
    <script>
        (function() {
            if (window.innerWidth >= 992) return;
            var anchor = document.getElementById('exam_anchor');
            if (!anchor) return;
            setTimeout(function() {
                anchor.style.display = 'block';
                if (typeof googletag !== 'undefined') {
                    googletag.cmd.push(function() {
                        try {
                            googletag.display('exam_anchor');
                        } catch(e) {}
                    });
                }
            }, 3000);
        })();
    </script>
</div>

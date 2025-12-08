<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Tutorial Ad Slot Component

    Displays a single ad slot based on the 'slot' parameter.
    Use collapseEmpty to hide the slot if no ad loads.

    Parameters:
    - slot: Which ad slot to display (top, middle, bottom, sidebar)
    - responsive: true/false (default: true)

    Usage:
    <jsp:include page="../tutorial-ad-slot.jsp">
        <jsp:param name="slot" value="top" />
        <jsp:param name="responsive" value="true" />
    </jsp:include>
--%>
<%
    String slot = request.getParameter("slot");
    if (slot == null) slot = "middle";

    String responsive = request.getParameter("responsive");
    boolean isResponsive = (responsive == null || responsive.equals("true"));

    // Generate unique ID based on slot
    String slotId = "ad_slot_" + slot + "_" + System.currentTimeMillis() % 10000;
%>

<% if (slot.equals("top") || slot.equals("middle") || slot.equals("bottom")) { %>
<%-- In-content leaderboard ad (lazy-loaded) --%>
<div id="<%= slotId %>" class="tutorial-ad-container" data-slot="<%= slot %>">
    <script type="text/javascript">
        (function() {
            var slotEl = document.getElementById('<%= slotId %>');
            if (typeof inView !== 'undefined') {
                inView('#<%= slotId %>').once('enter', function() {
                    loadAdSlot('<%= slotId %>', '<%= slot %>');
                });
            } else {
                // Fallback if inView not available
                loadAdSlot('<%= slotId %>', '<%= slot %>');
            }
        })();

        function loadAdSlot(id, slot) {
            if (typeof googletag === 'undefined' || typeof stpd === 'undefined') {
                // Ad libraries not loaded - hide the container
                document.getElementById(id).style.display = 'none';
                return;
            }
            googletag.cmd.push(function() {
                try {
                    if(window.innerWidth >= 1000) {
                        googletag.defineSlot('/147246189,22976055811/8gwifi.org_728x90_leaderboard_desktop', [[728,90],[468,60]], id).addService(googletag.pubads());
                    } else {
                        googletag.defineSlot('/147246189,22976055811/8gwifi.org_336x336_leaderboard_mobile', [[336,336],[336,320],[320,336],[320,320],[300,300],[336,280],[320,250],[300,250]], id).addService(googletag.pubads());
                    }
                    googletag.display(id);
                    if (typeof stpd !== 'undefined' && stpd.initializeAdUnit) {
                        stpd.initializeAdUnit(id);
                    }
                } catch(e) {
                    // Ad failed - hide container
                    document.getElementById(id).style.display = 'none';
                }
            });
        }
    </script>
</div>
<% } else if (slot.equals("sidebar")) { %>
<%-- Sidebar ad (desktop only) --%>
<div id="<%= slotId %>" class="tutorial-ad-container tutorial-ad-sidebar" data-slot="sidebar">
    <script>
        (function() {
            if (window.innerWidth < 992) {
                document.getElementById('<%= slotId %>').style.display = 'none';
                return;
            }
            if (typeof googletag !== 'undefined') {
                googletag.cmd.push(function() {
                    googletag.display('<%= slotId %>');
                });
            }
        })();
    </script>
</div>
<% } %>

<style>
.tutorial-ad-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: var(--space-4, 1rem) 0;
    min-height: 0; /* No minimum height - collapses if empty */
}

.tutorial-ad-container:empty {
    display: none;
}

.tutorial-ad-sidebar {
    margin: var(--space-4, 1rem) 0;
}

/* Hide ad containers on mobile for sidebar ads */
@media (max-width: 991px) {
    .tutorial-ad-sidebar {
        display: none;
    }
}
</style>

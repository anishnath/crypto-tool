<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Tutorial Footer Component
    Simple, minimal footer + Fixed Position Ads + Social Popup
--%>
<footer class="tutorial-footer">
    <div class="footer-content">
        <p>&copy; 2024 8gwifi.org Tutorials. Learn to code with interactive examples.</p>
        <div class="footer-links">
            <a href="/tutorials/">All Tutorials</a>
            <a href="/">Main Site</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener">Follow @anish2good</a>
            <a href="https://buymeacoffee.com/8gwifi.org" target="_blank" rel="noopener">Buy me a coffee</a>
        </div>
    </div>
</footer>

<%-- Fixed Position Ads (Siderails + Anchor) --%>
<%@ include file="ads/ad-siderails.jsp" %>
<%@ include file="ads/ad-anchor.jsp" %>

<%-- Social Popup (Engagement-based) --%>
<%@ include file="social-popup.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Reusable <head> assets for math/ studio pages.

    Usage (static include, inside <head>, AFTER your <jsp:include seo-tool-page>):
        <%@ include file="/math/partials/studio-head.jsp" %>

    Pairs with studio-open.jsp / studio-close.jsp. Absolute paths so it works
    from any directory depth under the webapp.
--%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css">
<%@ include file="/modern/ads/ad-init.jsp" %>

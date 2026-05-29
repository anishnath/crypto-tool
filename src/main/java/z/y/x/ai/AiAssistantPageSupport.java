package z.y.x.ai;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;

/**
 * Server-side bootstrap for tool-page AI assistants (JSP includes).
 * Reads gateway env flags and OAuth session; exposes request attributes for
 * {@code ai-assistant-*.inc.jsp} fragments.
 */
public final class AiAssistantPageSupport {

    private static final String READY = "_aiAssistantPageReady";

    private AiAssistantPageSupport() {
    }

    /** Idempotent — safe to call from every include fragment. */
    public static void ensurePageVars(PageContext pageContext) {
        HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
        if (Boolean.TRUE.equals(request.getAttribute(READY))) {
            return;
        }

        HttpSession session = request.getSession(false);
        String aiUserId = oauthUserId(session);
        boolean useAiGateway = AiGatewayConfig.isGatewayEnabled();
        String freeAiRoute = AiGatewayConfig.freeTierRoute();
        String ctx = request.getContextPath();

        request.setAttribute("aiCtx", ctx);
        request.setAttribute("aiUserId", aiUserId);
        request.setAttribute("aiUserIdJs", escapeJs(aiUserId));
        request.setAttribute("aiUseGateway", Boolean.valueOf(useAiGateway));
        request.setAttribute("aiFreeRoute", freeAiRoute);
        request.setAttribute("aiRouteModeJs", useAiGateway ? "'tier'" : "'auto'");
        request.setAttribute("aiUrlPath", useAiGateway ? "/ai-gateway" : "/ai");
        request.setAttribute(READY, Boolean.TRUE);
    }

    public static String oauthUserId(HttpSession session) {
        if (session == null) {
            return "";
        }
        Object oauthSub = session.getAttribute("oauth_user_sub");
        return oauthSub != null ? oauthSub.toString() : "";
    }

    /**
     * Resolve a page override: {@code pageContext} attribute, then request attribute,
     * then {@code jsp:param} on a dynamic include, then default.
     */
    public static String param(PageContext pageContext, String name, String defaultValue) {
        Object v = pageContext.getAttribute(name, PageContext.PAGE_SCOPE);
        if (v == null) {
            HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
            v = request.getAttribute(name);
            if (v == null) {
                String p = request.getParameter(name);
                if (p != null) {
                    v = p;
                }
            }
        }
        return v != null ? v.toString() : defaultValue;
    }

    public static boolean paramBool(PageContext pageContext, String name, boolean defaultValue) {
        String v = param(pageContext, name, null);
        if (v == null || v.trim().isEmpty()) {
            return defaultValue;
        }
        return "true".equalsIgnoreCase(v) || "1".equals(v) || "yes".equalsIgnoreCase(v);
    }

    /** Escape for embedding in a JS single-quoted string literal. */
    public static String escapeJs(String s) {
        if (s == null || s.isEmpty()) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("'", "\\'");
    }
}

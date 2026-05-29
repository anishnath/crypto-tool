package z.y.x.ai;

/**
 * AI routing flags for Tomcat (frontend tier routing + /ai-gateway servlet gate).
 * <p>
 * {@code USE_AI_GATEWAY} — master switch. When false, all tiers use legacy {@code /ai}.
 * {@code FREE_USE_AI_GATEWAY} — when master is on, free logged-in users use
 * {@code /ai-gateway} (true, default) or legacy {@code /ai} (false). Guest → /ai, Pro → gateway.
 */
public final class AiGatewayConfig {

    private AiGatewayConfig() {
    }

    public static boolean isGatewayEnabled() {
        return truthy(System.getenv("USE_AI_GATEWAY"));
    }

    /**
     * Free-tier route when {@link #isGatewayEnabled()} is true.
     * Defaults to gateway so existing deployments keep current behavior.
     */
    public static boolean isFreeTierGatewayEnabled() {
        if (!isGatewayEnabled()) {
            return false;
        }
        String v = System.getenv("FREE_USE_AI_GATEWAY");
        if (v == null || v.trim().isEmpty()) {
            return true;
        }
        return truthy(v);
    }

    /** {@code gateway} or {@code legacy} for JS {@code aiRouteByTier.free}. */
    public static String freeTierRoute() {
        return isFreeTierGatewayEnabled() ? "gateway" : "legacy";
    }

    private static boolean truthy(String v) {
        return "true".equalsIgnoreCase(v);
    }
}

package z.y.x.Security;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * InspectJSServlet replicates the behaviour of inspectJS.py by discovering JavaScript assets
 * for a target site, scanning them for high-value indicators (API keys, credentials, endpoints)
 * and returning a structured JSON report that can be rendered on the frontend.
 */
public class InspectJSServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Gson GSON = new Gson();

    private static final RequestConfig REQUEST_CONFIG = RequestConfig.custom()
            .setConnectTimeout(10000)
            .setConnectionRequestTimeout(10000)
            .setSocketTimeout(15000)
            .build();

    private static final Pattern SCRIPT_SRC_PATTERN = Pattern.compile(
            "<script[^>]*?src\\s*=\\s*['\"]([^'\"]+?\\.js(?:\\?[^'\"]*)?)['\"][^>]*?>",
            Pattern.CASE_INSENSITIVE);
    private static final Pattern GENERIC_JS_PATTERN = Pattern.compile(
            "['\"]([^'\"]+?\\.js(?:\\?[^'\"]*)?)['\"]",
            Pattern.CASE_INSENSITIVE);
    private static final Pattern FETCH_PATTERN = Pattern.compile(
            "fetch\\s*\\(\\s*([\"'`])([^\"'`]+?)\\1\\s*(?:,\\s*\\{([^)]*?)\\})?\\s*\\)",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
    private static final Pattern AXIOS_METHOD_PATTERN = Pattern.compile(
            "axios\\.(get|post|put|delete|patch)\\s*\\(\\s*([\"'`])([^\"'`]+?)\\2",
            Pattern.CASE_INSENSITIVE);
    private static final Pattern AXIOS_CONFIG_PATTERN = Pattern.compile(
            "axios\\s*\\(\\s*\\{([^}]+)\\}\\s*\\)",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
    private static final Pattern XHR_PATTERN = Pattern.compile(
            "\\.open\\s*\\(\\s*([\"'])(GET|POST|PUT|DELETE|PATCH)\\1\\s*,\\s*([\"'])([^\"']+?)\\3",
            Pattern.CASE_INSENSITIVE);

    private static final Pattern ROBOTS_PATH_PATTERN = Pattern.compile(
            "(?i)(?:Disallow|Allow):\\s*([^\\s#]+\\.js[^\\s#]*)");
    private static final Pattern HIGH_ENTROPY_PATTERN = Pattern.compile("[A-Za-z0-9+/=_-]{20,}");
    private static final double ENTROPY_THRESHOLD = 4.0;

    private static final Map<String, List<Pattern>> SECRET_PATTERNS;
    private static final Map<String, Severity> CATEGORY_SEVERITY;

    private static final List<String> CRITICAL_ENDPOINT_KEYWORDS;

    static {
        SECRET_PATTERNS = new LinkedHashMap<>();
        SECRET_PATTERNS.put("api_keys", compileAll(
                "api[_-]?key[\"']?\\s*[:=]\\s*[\"']([a-zA-Z0-9_\\-]{20,60})[\"']",
                "apikey[\"']?\\s*[:=]\\s*[\"']([a-zA-Z0-9_\\-]{20,60})[\"']",
                "secret[\"']?\\s*[:=]\\s*[\"']([a-zA-Z0-9_\\-]{20,60})[\"']",
                "key[\"']?\\s*[:=]\\s*[\"']([a-zA-Z0-9_\\-]{20,60})[\"']"
        ));
        SECRET_PATTERNS.put("jwt_tokens", compileAll(
                "(eyJ[a-zA-Z0-9_-]+\\.[a-zA-Z0-9_-]+\\.[a-zA-Z0-9_-]+)"
        ));
        SECRET_PATTERNS.put("passwords", compileAll(
                "password[\"']?\\s*[:=]\\s*[\"']([^\"'\\s]{3,50})[\"']",
                "pass[\"']?\\s*[:=]\\s*[\"']([^\"'\\s]{3,50})[\"']",
                "pwd[\"']?\\s*[:=]\\s*[\"']([^\"'\\s]{3,50})[\"']",
                "psw[\"']?\\s*[:=]\\s*[\"']([^\"'\\s]{3,50})[\"']"
        ));
        SECRET_PATTERNS.put("endpoints", compileAll(
                "['\"](https?://[^'\"\\s]+?/api/[^'\"\\s]*?)['\"]",
                "['\"](/api/[^'\"\\s]*?)['\"]",
                "['\"](https?://[^'\"\\s]+?/v[0-9]/[^'\"\\s]*?)['\"]",
                "['\"](https?://[^'\"\\s]+?/graphql[^'\"\\s]*?)['\"]",
                "['\"](https?://[^'\"\\s]+?/rest/[^'\"\\s]*?)['\"]",
                "['\"](https?://[^'\"\\s]+?/auth[^'\"\\s]*?)['\"]",
                "['\"](https?://[^'\"\\s]+?/login[^'\"\\s]*?)['\"]",
                "['\"](https?://[^'\"\\s]+?/register[^'\"\\s]*?)['\"]",
                "['\"](https?://[^'\"\\s]+?/user[^'\"\\s]*?)['\"]",
                "['\"](https?://[^'\"\\s]+?/admin[^'\"\\s]*?)['\"]"
        ));
        SECRET_PATTERNS.put("aws_keys", compileAll(
                "(AKIA[0-9A-Z]{16})",
                "aws[_-]?access[_-]?key[\"']?\\s*[:=]\\s*[\"']([^\"']+?)[\"']",
                "aws[_-]?secret[_-]?key[\"']?\\s*[:=]\\s*[\"']([^\"']+?)[\"']"
        ));
        SECRET_PATTERNS.put("database_urls", compileAll(
                "(mongodb\\+srv://[^\"'\\s]+)",
                "(postgresql://[^\"'\\s]+)",
                "(mysql://[^\"'\\s]+)",
                "(redis://[^\"'\\s]+)",
                "database[\"']?\\s*[:=]\\s*[\"']([^\"']+?)[\"']"
        ));
        SECRET_PATTERNS.put("emails", compileAll(
                "([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})"
        ));
        SECRET_PATTERNS.put("ip_addresses", compileAll(
                "\\b((?:[0-9]{1,3}\\.){3}[0-9]{1,3})\\b"
        ));
        SECRET_PATTERNS.put("provider_keys", compileAll(
                "(AIza[0-9A-Za-z\\-_]{35})",
                "(sk_live_[0-9a-zA-Z]{24})",
                "(sk_test_[0-9a-zA-Z]{24})",
                "(pk_live_[0-9a-zA-Z]{24})",
                "(pk_test_[0-9a-zA-Z]{24})",
                "(xox[baprs]-[0-9A-Za-z-]{10,48})",
                "(gh[pousr]_[0-9A-Za-z]{36})",
                "(github_pat_[0-9A-Za-z_]{22,100})",
                "(ya29\\.[0-9A-Za-z\\-_]+)"
        ));
        SECRET_PATTERNS.put("private_keys", compileAll(
                "-----BEGIN (?:RSA|DSA|EC|OPENSSH)?\\s*PRIVATE KEY-----",
                "-----BEGIN PGP PRIVATE KEY BLOCK-----"
        ));
        SECRET_PATTERNS.put("hardcoded_credentials", compileAll(
                "(?:user(?:name)?|login)[\"']?\\s*[:=]\\s*[\"']([^\"'\\s]{3,50})[\"']",
                "(?:client[_-]?secret)[\"']?\\s*[:=]\\s*[\"']([^\"'\\s]{10,100})[\"']"
        ));

        CATEGORY_SEVERITY = new HashMap<>();
        CATEGORY_SEVERITY.put("api_keys", Severity.HIGH);
        CATEGORY_SEVERITY.put("jwt_tokens", Severity.HIGH);
        CATEGORY_SEVERITY.put("passwords", Severity.CRITICAL);
        CATEGORY_SEVERITY.put("endpoints", Severity.MEDIUM);
        CATEGORY_SEVERITY.put("aws_keys", Severity.CRITICAL);
        CATEGORY_SEVERITY.put("database_urls", Severity.CRITICAL);
        CATEGORY_SEVERITY.put("emails", Severity.LOW);
        CATEGORY_SEVERITY.put("ip_addresses", Severity.LOW);
        CATEGORY_SEVERITY.put("provider_keys", Severity.HIGH);
        CATEGORY_SEVERITY.put("private_keys", Severity.CRITICAL);
        CATEGORY_SEVERITY.put("hardcoded_credentials", Severity.CRITICAL);
        CATEGORY_SEVERITY.put("high_entropy", Severity.HIGH);

        CRITICAL_ENDPOINT_KEYWORDS = new ArrayList<>();
        Collections.addAll(CRITICAL_ENDPOINT_KEYWORDS,
                "login", "register", "auth", "password", "reset",
                "admin", "user", "account", "profile", "payment",
                "credit", "bank", "secret", "key", "token", "oauth",
                "callback", "api");
    }

    private static List<Pattern> compileAll(String... expressions) {
        List<Pattern> patterns = new ArrayList<>();
        for (String expression : expressions) {
            patterns.add(Pattern.compile(expression, Pattern.CASE_INSENSITIVE));
        }
        return patterns;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String targetUrl = trimToNull(request.getParameter("url"));
        String export = trimToNull(request.getParameter("export"));

        response.setCharacterEncoding(StandardCharsets.UTF_8.name());

        if (targetUrl == null) {
            response.setContentType("application/json");
            try (PrintWriter out = response.getWriter()) {
                out.print(errorJson("Missing required parameter: url"));
            }
            return;
        }

        int depth = parseInteger(request.getParameter("depth"), 1, 1, 3);
        // Force single threaded execution to avoid overwhelming the public endpoint
        int threads = 1;
        boolean verifySsl = Boolean.parseBoolean(request.getParameter("verifySsl"));

        if ("csv".equalsIgnoreCase(export)) {
            response.setContentType("text/csv");
        } else {
            response.setContentType("application/json");
        }

        PrintWriter out = response.getWriter();

        try (CloseableHttpClient httpClient = buildHttpClient(verifySsl)) {
            InspectContext context = new InspectContext(targetUrl, depth, threads, verifySsl, httpClient);
            context.discover();
            context.analyse();

            String filenameBase = "inspectjs-report-" + context.getScanId();

            if ("csv".equalsIgnoreCase(export)) {
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filenameBase + ".csv\"");
                out.print(context.buildCsvReport());
            } else if ("json".equalsIgnoreCase(export)) {
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filenameBase + ".json\"");
                out.print(GSON.toJson(context.buildReportJson()));
            } else {
                out.print(GSON.toJson(context.buildReportJson()));
            }
        } catch (Exception ex) {
            response.setContentType("application/json");
            out.print(errorJson("Error while processing request: " + ex.getMessage()));
        }
    }

    private String errorJson(String message) {
        JsonObject error = new JsonObject();
        error.addProperty("status", "error");
        error.addProperty("message", message);
        return GSON.toJson(error);
    }

    private static CloseableHttpClient buildHttpClient(boolean verifySsl) throws NoSuchAlgorithmException, KeyManagementException {
        if (verifySsl) {
            return HttpClients.custom()
                    .setDefaultRequestConfig(REQUEST_CONFIG)
                    .build();
        }

        TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    @Override
                    public void checkClientTrusted(X509Certificate[] chain, String authType) {
                    }

                    @Override
                    public void checkServerTrusted(X509Certificate[] chain, String authType) {
                    }

                    @Override
                    public X509Certificate[] getAcceptedIssuers() {
                        return new X509Certificate[0];
                    }
                }
        };

        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, trustAllCerts, new SecureRandom());
        SSLConnectionSocketFactory socketFactory = new SSLConnectionSocketFactory(sslContext, NoopHostnameVerifier.INSTANCE);

        return HttpClients.custom()
                .setSSLSocketFactory(socketFactory)
                .setDefaultRequestConfig(REQUEST_CONFIG)
                .build();
    }

    private static String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private static int parseInteger(String value, int defaultValue, int min, int max) {
        if (value == null) {
            return defaultValue;
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            if (parsed < min) {
                return min;
            }
            if (parsed > max) {
                return max;
            }
            return parsed;
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    /**
     * Holds scanning state for a single request.
     */
    private static class InspectContext {
        private final String baseUrl;
        private final int depth;
        private final int threads;
        private final boolean verifySsl;
        private final CloseableHttpClient httpClient;

        private final Set<String> discoveredUrls = new LinkedHashSet<>();
        private final Set<String> analysedUrls = Collections.newSetFromMap(new ConcurrentHashMap<>());
        private final Map<String, List<JsonObject>> findings = new ConcurrentHashMap<>();
        private final Instant generatedAt;
        private final String scanId;

        private volatile Summary cachedSummary;
        private volatile JsonElement cachedReport;
        private volatile String cachedCsv;

        InspectContext(String baseUrl, int depth, int threads, boolean verifySsl, CloseableHttpClient httpClient) {
            this.baseUrl = normaliseBaseUrl(baseUrl);
            this.depth = depth;
            this.threads = threads;
            this.verifySsl = verifySsl;
            this.httpClient = httpClient;
            this.generatedAt = Instant.now();
            this.scanId = UUID.randomUUID().toString();

            for (String key : SECRET_PATTERNS.keySet()) {
                findings.putIfAbsent(key, Collections.synchronizedList(new ArrayList<>()));
            }
            findings.putIfAbsent("http_requests", Collections.synchronizedList(new ArrayList<>()));
            findings.putIfAbsent("high_entropy", Collections.synchronizedList(new ArrayList<>()));
        }

        void discover() {
            Set<String> toVisit = new LinkedHashSet<>();
            toVisit.add(baseUrl);

            int currentDepth = 0;
            Set<String> visitedPages = new HashSet<>();

            while (!toVisit.isEmpty() && currentDepth < depth) {
                Set<String> nextLevel = new LinkedHashSet<>();
                for (String pageUrl : toVisit) {
                    if (!visitedPages.add(pageUrl)) {
                        continue;
                    }
                    String body = fetch(pageUrl);
                    if (body == null) {
                        continue;
                    }

                    Set<String> scripts = extractScripts(pageUrl, body);
                    discoveredUrls.addAll(scripts);

                    if (currentDepth + 1 < depth) {
                        nextLevel.addAll(extractLinksForDepth(pageUrl, body));
                    }
                }
                toVisit = nextLevel;
                currentDepth++;
            }

            discoveredUrls.addAll(fetchFromRobots(baseUrl));
        }

        void analyse() throws Exception {
            if (discoveredUrls.isEmpty()) {
                return;
            }

            ExecutorService executorService = Executors.newFixedThreadPool(threads);
            List<Future<?>> futures = new ArrayList<>();
            for (String url : discoveredUrls) {
                futures.add(executorService.submit(() -> analyseSingle(url)));
            }

            for (Future<?> future : futures) {
                try {
                    future.get();
                } catch (Exception ignored) {
                }
            }
            executorService.shutdown();
        }

        private void analyseSingle(String url) {
            if (!analysedUrls.add(url)) {
                return;
            }

            String content = fetch(url);
            if (content == null || content.length() == 0) {
                return;
            }

            scanForSecrets(url, content);
            scanHighEntropy(url, content);
            scanForHttpRequests(url, content);
        }

        private void scanForSecrets(String sourceUrl, String content) {
            for (Map.Entry<String, List<Pattern>> entry : SECRET_PATTERNS.entrySet()) {
                String category = entry.getKey();
                List<Pattern> patterns = entry.getValue();
                Severity severity = CATEGORY_SEVERITY.getOrDefault(category, Severity.MEDIUM);

                for (Pattern pattern : patterns) {
                    Matcher matcher = pattern.matcher(content);
                    while (matcher.find()) {
                        String value = matcher.groupCount() >= 1 ? matcher.group(1) : matcher.group();
                        recordFinding(category, value, sourceUrl, snippetAround(content, matcher.start(), matcher.end()), severity);
                    }
                }
            }
        }

        private void recordFinding(String category, String value, String sourceUrl, String context, Severity severity) {
            if (value == null || value.isEmpty()) {
                return;
            }
            JsonObject finding = new JsonObject();
            finding.addProperty("value", value);
            finding.addProperty("sourceUrl", sourceUrl);
            if (context != null && !context.isEmpty()) {
                finding.addProperty("context", context);
            }
            finding.addProperty("severity", severity.name());
            findings.computeIfAbsent(category, key -> Collections.synchronizedList(new ArrayList<>())).add(finding);
        }

        private void scanHighEntropy(String sourceUrl, String content) {
            Matcher matcher = HIGH_ENTROPY_PATTERN.matcher(content);
            Set<String> seen = new HashSet<>();
            while (matcher.find()) {
                String candidate = matcher.group();
                if (candidate.length() < 24 || candidate.length() > 256) {
                    continue;
                }
                if (!seen.add(candidate)) {
                    continue;
                }
                double entropy = shannonEntropy(candidate);
                if (entropy >= ENTROPY_THRESHOLD) {
                    recordFinding("high_entropy", candidate, sourceUrl,
                            snippetAround(content, matcher.start(), matcher.end()), Severity.HIGH);
                }
            }
        }

        private void scanForHttpRequests(String sourceUrl, String content) {
            Matcher fetchMatcher = FETCH_PATTERN.matcher(content);
            while (fetchMatcher.find()) {
                String url = fetchMatcher.group(2);
                String options = fetchMatcher.group(3);
                String method = resolveMethod(options, "GET");
                registerHttpRequest(sourceUrl, "fetch", method, url);
            }

            Matcher axiosMethodMatcher = AXIOS_METHOD_PATTERN.matcher(content);
            while (axiosMethodMatcher.find()) {
                String method = axiosMethodMatcher.group(1).toUpperCase();
                String url = axiosMethodMatcher.group(3);
                registerHttpRequest(sourceUrl, "axios", method, url);
            }

            Matcher axiosConfigMatcher = AXIOS_CONFIG_PATTERN.matcher(content);
            while (axiosConfigMatcher.find()) {
                String configBody = axiosConfigMatcher.group(1);
                String method = resolveMethod(configBody, "GET");
                String url = extractJsonLikeValue(configBody, "url");
                if (url != null) {
                    registerHttpRequest(sourceUrl, "axios", method, url);
                }
            }

            Matcher xhrMatcher = XHR_PATTERN.matcher(content);
            while (xhrMatcher.find()) {
                String method = xhrMatcher.group(2).toUpperCase();
                String url = xhrMatcher.group(4);
                registerHttpRequest(sourceUrl, "xhr", method, url);
            }
        }

        private void registerHttpRequest(String sourceUrl, String type, String method, String url) {
            if (url == null || url.trim().isEmpty()) {
                return;
            }
            JsonObject obj = new JsonObject();
            obj.addProperty("sourceUrl", sourceUrl);
            obj.addProperty("type", type);
            obj.addProperty("method", method);
            obj.addProperty("url", url);

            List<String> queryParams = extractQueryParams(url);
            JsonArray queryArray = new JsonArray();
            for (String param : queryParams) {
                if (param != null) {
                    queryArray.add(new JsonPrimitive(param));
                }
            }
            obj.add("queryParams", queryArray);

            List<String> pathParams = extractPathParams(url);
            JsonArray pathArray = new JsonArray();
            for (String param : pathParams) {
                if (param != null) {
                    pathArray.add(new JsonPrimitive(param));
                }
            }
            obj.add("pathParams", pathArray);

            String criticalType = detectCritical(url);
            obj.addProperty("critical", criticalType != null);
            obj.addProperty("criticalKeyword", criticalType == null ? "" : criticalType);

            Severity severity = criticalType != null ? Severity.HIGH : Severity.MEDIUM;
            obj.addProperty("severity", severity.name());

            findings.get("http_requests").add(obj);
        }

        JsonElement buildReportJson() {
            if (cachedReport != null) {
                return cachedReport;
            }

            JsonObject result = new JsonObject();
            result.addProperty("status", "ok");
            result.addProperty("target", baseUrl);
            result.addProperty("verifySsl", verifySsl);
            result.addProperty("depth", depth);
            result.addProperty("threads", threads);
            result.addProperty("scanId", scanId);
            result.addProperty("generatedAt", generatedAt.toString());
            result.addProperty("generatedBy", "https://8gwifi.org/InspectJSFunctions.jsp");

            JsonArray discovered = new JsonArray();
            for (String url : discoveredUrls) {
                if (url != null) {
                    discovered.add(new JsonPrimitive(url));
                }
            }
            result.add("discoveredJs", discovered);

            JsonArray analysed = new JsonArray();
            for (String url : analysedUrls) {
                if (url != null) {
                    analysed.add(new JsonPrimitive(url));
                }
            }
            result.add("analyzedJs", analysed);

            JsonObject findingsJson = new JsonObject();
            for (Map.Entry<String, List<JsonObject>> entry : findings.entrySet()) {
                JsonArray array = new JsonArray();
                for (JsonObject obj : entry.getValue()) {
                    array.add(obj);
                }
                findingsJson.add(entry.getKey(), array);
            }
            result.add("findings", findingsJson);

            Summary summary = cachedSummary != null ? cachedSummary : summarize(findings);
            cachedSummary = summary;

            JsonObject summaryJson = new JsonObject();
            summaryJson.addProperty("totalFindings", summary.totalFindings);
            summaryJson.addProperty("totalCritical", summary.highSeverityFindings);
            summaryJson.addProperty("criticalRequests", summary.criticalRequests);
            summaryJson.addProperty("highSeverityFindings", summary.highSeverityFindings);
            summaryJson.addProperty("mediumSeverityFindings", summary.mediumSeverityFindings);
            summaryJson.addProperty("lowSeverityFindings", summary.lowSeverityFindings);
            summaryJson.addProperty("severityScore", summary.severityScore);
            summaryJson.addProperty("httpRequests", summary.httpRequests);
            summaryJson.addProperty("risk", summary.riskLevel);
            result.add("summary", summaryJson);

            String csv = cachedCsv != null ? cachedCsv : buildCsvReport();
            result.addProperty("csvBase64", Base64.getEncoder().encodeToString(csv.getBytes(StandardCharsets.UTF_8)));

            cachedReport = result;
            return result;
        }

        private Summary summarize(Map<String, List<JsonObject>> findings) {
            int total = 0;
            int highSeverityFindings = 0;
            int mediumSeverityFindings = 0;
            int lowSeverityFindings = 0;
            int criticalRequests = 0;
            int httpRequests = 0;
            int severityScore = 0;

            for (Map.Entry<String, List<JsonObject>> entry : findings.entrySet()) {
                List<JsonObject> items = entry.getValue();
                total += items.size();
                if ("http_requests".equals(entry.getKey())) {
                    httpRequests = items.size();
                }

                for (JsonObject obj : items) {
                    Severity severity = extractSeverity(obj, entry.getKey());
                    severityScore += severity.weight;

                    switch (severity) {
                        case CRITICAL:
                        case HIGH:
                            highSeverityFindings++;
                            break;
                        case MEDIUM:
                            mediumSeverityFindings++;
                            break;
                        default:
                            lowSeverityFindings++;
                    }

                    if ("http_requests".equals(entry.getKey()) && obj.get("critical").getAsBoolean()) {
                        criticalRequests++;
                    }
                }
            }

            String risk;
            if (highSeverityFindings > 0) {
                risk = "HIGH";
            } else if (severityScore >= 10 || mediumSeverityFindings > 0) {
                risk = "MEDIUM";
            } else {
                risk = "LOW";
            }

            return new Summary(total, highSeverityFindings, mediumSeverityFindings, lowSeverityFindings,
                    severityScore, criticalRequests, httpRequests, risk);
        }

        private Severity extractSeverity(JsonObject obj, String category) {
            if (obj.has("severity")) {
                try {
                    return Severity.valueOf(obj.get("severity").getAsString());
                } catch (Exception ignored) {
                }
            }
            return CATEGORY_SEVERITY.getOrDefault(category, Severity.MEDIUM);
        }

        String buildCsvReport() {
            if (cachedCsv != null) {
                return cachedCsv;
            }
            Summary summary = cachedSummary != null ? cachedSummary : summarize(findings);
            cachedSummary = summary;

            StringBuilder sb = new StringBuilder();
            appendCsvLine(sb, "Field", "Value");
            appendCsvLine(sb, "Scan Id", scanId);
            appendCsvLine(sb, "Generated At", generatedAt.toString());
            appendCsvLine(sb, "Target", baseUrl);
            appendCsvLine(sb, "Generated By", "https://8gwifi.org/InspectJSFunctions.jsp");
            appendCsvLine(sb, "Verify SSL", Boolean.toString(verifySsl));
            appendCsvLine(sb, "Depth", Integer.toString(depth));
            appendCsvLine(sb, "Threads", Integer.toString(threads));
            appendCsvLine(sb, "Severity Score", Integer.toString(summary.severityScore));
            appendCsvLine(sb, "High Severity Findings", Integer.toString(summary.highSeverityFindings));
            appendCsvLine(sb, "Medium Severity Findings", Integer.toString(summary.mediumSeverityFindings));
            appendCsvLine(sb, "Low Severity Findings", Integer.toString(summary.lowSeverityFindings));
            appendCsvLine(sb, "HTTP Requests", Integer.toString(summary.httpRequests));
            appendCsvLine(sb, "Critical Requests", Integer.toString(summary.criticalRequests));
            appendCsvLine(sb, "Risk Level", summary.riskLevel);

            sb.append("\n");
            appendCsvLine(sb, "Category", "Severity", "Value", "Source", "Details");

            for (Map.Entry<String, List<JsonObject>> entry : findings.entrySet()) {
                String category = entry.getKey();
                for (JsonObject obj : entry.getValue()) {
                    Severity severity = extractSeverity(obj, category);
                    String value = safeString(obj, "value");
                    String source = safeString(obj, "sourceUrl");
                    String details;
                    if ("http_requests".equals(category)) {
                        value = (obj.has("method") ? obj.get("method").getAsString() : "GET") + " " + safeString(obj, "url");
                        StringBuilder detailBuilder = new StringBuilder();
                        detailBuilder.append("type=").append(safeString(obj, "type"));
                        if (obj.has("critical") && obj.get("critical").getAsBoolean()) {
                            detailBuilder.append(" | criticalKeyword=").append(safeString(obj, "criticalKeyword"));
                        }
                        if (obj.has("queryParams")) {
                            detailBuilder.append(" | queryParams=").append(joinJsonArray(obj.getAsJsonArray("queryParams")));
                        }
                        if (obj.has("pathParams")) {
                            detailBuilder.append(" | pathParams=").append(joinJsonArray(obj.getAsJsonArray("pathParams")));
                        }
                        details = detailBuilder.toString();
                    } else {
                        details = safeString(obj, "context");
                    }
                    appendCsvLine(sb, category, severity.name(), value, source, details);
                }
            }

            cachedCsv = sb.toString();
            return cachedCsv;
        }

        private void appendCsvLine(StringBuilder sb, String... values) {
            for (int i = 0; i < values.length; i++) {
                if (i > 0) {
                    sb.append(',');
                }
                sb.append(escapeCsv(values[i]));
            }
            sb.append('\n');
        }

        private String escapeCsv(String value) {
            if (value == null) {
                return "\"\"";
            }
            String trimmed = value.replace("\r", " ").replace("\n", " ").trim();
            String escaped = trimmed.replace("\"", "\"\"");
            return "\"" + escaped + "\"";
        }

        private String safeString(JsonObject obj, String key) {
            if (obj == null || key == null || !obj.has(key) || obj.get(key).isJsonNull()) {
                return "";
            }
            return obj.get(key).getAsString();
        }

        private String joinJsonArray(JsonArray array) {
            List<String> values = new ArrayList<>();
            for (JsonElement element : array) {
                values.add(element.getAsString());
            }
            return String.join(";", values);
        }

        private double shannonEntropy(String value) {
            int[] counts = new int[256];
            int length = 0;
            for (int i = 0; i < value.length(); i++) {
                char c = value.charAt(i);
                if (c >= 256) {
                    return 0;
                }
                counts[c]++;
                length++;
            }
            if (length == 0) {
                return 0;
            }
            double entropy = 0.0;
            for (int count : counts) {
                if (count == 0) {
                    continue;
                }
                double p = (double) count / length;
                entropy -= p * (Math.log(p) / Math.log(2));
            }
            return entropy;
        }

        String getScanId() {
            return scanId;
        }

        private String snippetAround(String content, int start, int end) {
            int prefix = Math.max(0, start - 60);
            int suffix = Math.min(content.length(), end + 60);
            return content.substring(prefix, suffix);
        }

        private String fetch(String url) {
            HttpGet request = new HttpGet(url);
            request.setConfig(REQUEST_CONFIG);
            request.setHeader("User-Agent", "Mozilla/5.0 (inspectjs-servlet)");

            try (CloseableHttpResponse httpResponse = httpClient.execute(request)) {
                int statusCode = httpResponse.getStatusLine().getStatusCode();
                if (statusCode >= 200 && statusCode < 300) {
                    HttpEntity entity = httpResponse.getEntity();
                    if (entity == null) {
                        return null;
                    }

                    Charset charset = StandardCharsets.UTF_8;
                    if (entity.getContentType() != null) {
                        String type = entity.getContentType().getValue();
                        if (type != null && type.contains("charset=")) {
                            String[] parts = type.split("charset=");
                            if (parts.length == 2) {
                                try {
                                    charset = Charset.forName(parts[1].trim());
                                } catch (Exception ignored) {
                                }
                            }
                        }
                    }

                    return EntityUtils.toString(entity, charset);
                }
            } catch (IOException ignored) {
            }
            return null;
        }

        private Set<String> extractScripts(String pageUrl, String body) {
            Set<String> scripts = new LinkedHashSet<>();

            Matcher scriptMatcher = SCRIPT_SRC_PATTERN.matcher(body);
            while (scriptMatcher.find()) {
                String src = scriptMatcher.group(1);
                String full = resolveUrl(pageUrl, src);
                if (full != null) {
                    scripts.add(full);
                }
            }

            Matcher genericMatcher = GENERIC_JS_PATTERN.matcher(body);
            while (genericMatcher.find()) {
                String src = genericMatcher.group(1);
                String full = resolveUrl(pageUrl, src);
                if (full != null) {
                    scripts.add(full);
                }
            }

            return scripts;
        }

        private Set<String> extractLinksForDepth(String pageUrl, String body) {
            Set<String> pages = new LinkedHashSet<>();
            Pattern hrefPattern = Pattern.compile("<a[^>]+href=['\"]([^'\"]+)['\"]", Pattern.CASE_INSENSITIVE);
            Matcher matcher = hrefPattern.matcher(body);
            while (matcher.find()) {
                String href = matcher.group(1);
                String full = resolveUrl(pageUrl, href);
                if (full != null && full.startsWith(baseUrl)) {
                    pages.add(full);
                }
            }
            return pages;
        }

        private Set<String> fetchFromRobots(String base) {
            Set<String> result = new LinkedHashSet<>();
            String robotsUrl = resolveUrl(base, "/robots.txt");
            if (robotsUrl == null) {
                return result;
            }
            String content = fetch(robotsUrl);
            if (content == null) {
                return result;
            }
            Matcher matcher = ROBOTS_PATH_PATTERN.matcher(content);
            while (matcher.find()) {
                String path = matcher.group(1).trim();
                String resolved = resolveUrl(base, path);
                if (resolved != null) {
                    result.add(resolved);
                }
            }
            return result;
        }

        private String resolveUrl(String base, String relative) {
            if (relative == null || relative.trim().isEmpty()) {
                return null;
            }

            relative = relative.trim();

            if (relative.startsWith("data:") || relative.startsWith("javascript:")) {
                return null;
            }

            try {
                URL baseUrlObj = new URL(base);
                URL resolved = new URL(baseUrlObj, relative);
                return resolved.toExternalForm();
            } catch (MalformedURLException e) {
                try {
                    URL resolved = new URL(relative);
                    return resolved.toExternalForm();
                } catch (MalformedURLException ignored) {
                    return null;
                }
            }
        }

        private String detectCritical(String url) {
            String lower = url.toLowerCase();
            for (String keyword : CRITICAL_ENDPOINT_KEYWORDS) {
                if (lower.contains(keyword)) {
                    return keyword;
                }
            }
            return null;
        }

        private List<String> extractQueryParams(String url) {
            try {
                URI uri = new URI(url);
                String query = uri.getRawQuery();
                if (query == null || query.isEmpty()) {
                    return Collections.emptyList();
                }
                String[] pairs = query.split("&");
                List<String> params = new ArrayList<>();
                for (String pair : pairs) {
                    int idx = pair.indexOf('=');
                    String key = idx >= 0 ? pair.substring(0, idx) : pair;
                    if (!key.isEmpty()) {
                        params.add(key);
                    }
                }
                return params;
            } catch (URISyntaxException e) {
                return Collections.emptyList();
            }
        }

        private List<String> extractPathParams(String url) {
            List<String> params = new ArrayList<>();
            Matcher matcher = Pattern.compile("/:([a-zA-Z_][\\w-]*)").matcher(url);
            while (matcher.find()) {
                params.add(matcher.group(1));
            }
            return params;
        }

        private String resolveMethod(String optionsBody, String defaultMethod) {
            if (optionsBody == null) {
                return defaultMethod;
            }
            Pattern methodPattern = Pattern.compile("method\\s*[:=]\\s*['\"]([a-zA-Z]+)['\"]", Pattern.CASE_INSENSITIVE);
            Matcher matcher = methodPattern.matcher(optionsBody);
            if (matcher.find()) {
                return matcher.group(1).toUpperCase();
            }
            return defaultMethod;
        }

        private String extractJsonLikeValue(String body, String key) {
            Pattern pattern = Pattern.compile(key + "\\s*:\\s*['\"]([^'\"]+)['\"]", Pattern.CASE_INSENSITIVE);
            Matcher matcher = pattern.matcher(body);
            if (matcher.find()) {
                return matcher.group(1);
            }
            return null;
        }

        private String normaliseBaseUrl(String url) {
            if (url.endsWith("/")) {
                return url;
            }
            return url + "/";
        }
    }

    private static class Summary {
        final int totalFindings;
        final int highSeverityFindings;
        final int mediumSeverityFindings;
        final int lowSeverityFindings;
        final int severityScore;
        final int criticalRequests;
        final int httpRequests;
        final String riskLevel;

        Summary(int totalFindings,
                int highSeverityFindings,
                int mediumSeverityFindings,
                int lowSeverityFindings,
                int severityScore,
                int criticalRequests,
                int httpRequests,
                String riskLevel) {
            this.totalFindings = totalFindings;
            this.highSeverityFindings = highSeverityFindings;
            this.mediumSeverityFindings = mediumSeverityFindings;
            this.lowSeverityFindings = lowSeverityFindings;
            this.severityScore = severityScore;
            this.criticalRequests = criticalRequests;
            this.httpRequests = httpRequests;
            this.riskLevel = riskLevel;
        }
    }

    private enum Severity {
        LOW(1),
        MEDIUM(2),
        HIGH(3),
        CRITICAL(4);

        final int weight;

        Severity(int weight) {
            this.weight = weight;
        }
    }
}


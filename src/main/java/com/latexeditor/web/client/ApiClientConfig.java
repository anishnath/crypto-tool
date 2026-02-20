package com.latexeditor.web.client;

import z.y.x.r.LoadPropertyFileFunctionality;

public class ApiClientConfig {

    private static final String DEFAULT_API_BASE = "http://localhost:8080";

    public static String getApiBaseUrl() {
        String apiBase = LoadPropertyFileFunctionality.getConfigProperty().get("api");
        if (apiBase == null || apiBase.trim().isEmpty()) {
            apiBase = DEFAULT_API_BASE;
        }
        if (apiBase.endsWith("/")) {
            apiBase = apiBase.substring(0, apiBase.length() - 1);
        }
        return apiBase;
    }
}

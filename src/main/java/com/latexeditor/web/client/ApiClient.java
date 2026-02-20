package com.latexeditor.web.client;

import com.latexeditor.web.model.CompileResponse;
import com.latexeditor.web.model.JobStatus;
import com.latexeditor.web.model.UploadResponse;
import com.latexeditor.web.util.JsonUtil;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.SocketTimeoutException;

public class ApiClient {

    private final String baseUrl;
    private static final int CONNECT_TIMEOUT = 5000;
    private static final int READ_TIMEOUT = 60000;

    public ApiClient() {
        this.baseUrl = ApiClientConfig.getApiBaseUrl();
    }

    public ApiClient(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    private RequestConfig defaultConfig() {
        return RequestConfig.custom()
                .setConnectTimeout(CONNECT_TIMEOUT)
                .setSocketTimeout(READ_TIMEOUT)
                .build();
    }

    /**
     * POST /api/latex/compile
     * Sends LaTeX source (and optional fileIds for uploaded images) and returns a CompileResponse with jobId.
     */
    public CompileResponse compile(String latexSource, java.util.List<String> fileIds) throws ApiException, IOException {
        String url = baseUrl + "/api/latex/compile";
        String jsonBody = JsonUtil.toJson(new com.latexeditor.web.model.CompileRequest(latexSource, fileIds));

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(url);
            post.setConfig(defaultConfig());
            post.setHeader("Content-Type", "application/json");
            post.setHeader("Accept", "application/json");
            post.setEntity(new StringEntity(jsonBody, ContentType.APPLICATION_JSON));

            HttpResponse response = executeWithErrorHandling(client, post);
            int status = response.getStatusLine().getStatusCode();
            String body = readBody(response);

            if (status >= 400) {
                throw new ApiException(status >= 500 ? 502 : status, body);
            }

            return JsonUtil.fromJson(body, CompileResponse.class);
        } finally {
            client.close();
        }
    }

    /**
     * GET /api/latex/jobs/{jobId}/status
     */
    public JobStatus getJobStatus(String jobId) throws ApiException, IOException {
        String url = baseUrl + "/api/latex/jobs/" + jobId + "/status";

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpGet get = new HttpGet(url);
            get.setConfig(defaultConfig());
            get.setHeader("Accept", "application/json");

            HttpResponse response = executeWithErrorHandling(client, get);
            int status = response.getStatusLine().getStatusCode();
            String body = readBody(response);

            if (status >= 400) {
                throw new ApiException(status >= 500 ? 502 : status, body);
            }

            return JsonUtil.fromJson(body, JobStatus.class);
        } finally {
            client.close();
        }
    }

    /**
     * GET /api/latex/jobs/{jobId}/pdf
     * Returns raw InputStream — caller must close it.
     * NOTE: The returned HttpEntity holds the connection open.
     * Caller should stream bytes to servlet response, then close.
     */
    public HttpResponse getPDFResponse(String jobId) throws ApiException, IOException {
        String url = baseUrl + "/api/latex/jobs/" + jobId + "/pdf";

        CloseableHttpClient client = HttpClients.createDefault();
        HttpGet get = new HttpGet(url);
        get.setConfig(defaultConfig());

        HttpResponse response = executeWithErrorHandling(client, get);
        int status = response.getStatusLine().getStatusCode();

        if (status >= 400) {
            String body = readBody(response);
            client.close();
            throw new ApiException(status >= 500 ? 502 : status, body);
        }

        return response;
    }

    /**
     * GET /api/latex/jobs/{jobId}/logs
     * Returns raw InputStream for SSE forwarding — caller must close.
     */
    public InputStream getLogStream(String jobId) throws ApiException, IOException {
        String url = baseUrl + "/api/latex/jobs/" + jobId + "/logs";

        CloseableHttpClient client = HttpClients.custom()
                .setDefaultRequestConfig(RequestConfig.custom()
                        .setConnectTimeout(CONNECT_TIMEOUT)
                        .setSocketTimeout(120000) // SSE streams can be long
                        .build())
                .build();

        HttpGet get = new HttpGet(url);
        get.setHeader("Accept", "text/event-stream");

        HttpResponse response = executeWithErrorHandling(client, get);
        int status = response.getStatusLine().getStatusCode();

        if (status >= 400) {
            String body = readBody(response);
            client.close();
            throw new ApiException(status >= 500 ? 502 : status, body);
        }

        return response.getEntity().getContent();
    }

    /**
     * POST /api/latex/upload
     * Uploads a file as multipart/form-data.
     */
    public UploadResponse upload(byte[] fileBytes, String filename) throws ApiException, IOException {
        String url = baseUrl + "/api/latex/upload";

        CloseableHttpClient client = HttpClients.createDefault();
        try {
            HttpPost post = new HttpPost(url);
            post.setConfig(defaultConfig());

            HttpEntity entity = MultipartEntityBuilder.create()
                    .addBinaryBody("file", fileBytes, ContentType.APPLICATION_OCTET_STREAM, filename)
                    .build();
            post.setEntity(entity);

            HttpResponse response = executeWithErrorHandling(client, post);
            int status = response.getStatusLine().getStatusCode();
            String body = readBody(response);

            if (status >= 400) {
                throw new ApiException(status >= 500 ? 502 : status, body);
            }

            return JsonUtil.fromJson(body, UploadResponse.class);
        } finally {
            client.close();
        }
    }

    private HttpResponse executeWithErrorHandling(CloseableHttpClient client, org.apache.http.client.methods.HttpUriRequest request)
            throws ApiException, IOException {
        try {
            return client.execute(request);
        } catch (HttpHostConnectException e) {
            throw new ApiUnavailableException("Compilation service unavailable");
        } catch (ConnectTimeoutException | SocketTimeoutException e) {
            throw new ApiTimeoutException("Compilation request timed out");
        }
    }

    private String readBody(HttpResponse response) throws IOException {
        if (response.getEntity() == null) return "";
        BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }
}

package com.latexeditor.web.model;

public class CompileResponse {
    private String jobId;
    private String error;
    private String code;

    public CompileResponse() {}

    public String getJobId() { return jobId; }
    public void setJobId(String jobId) { this.jobId = jobId; }

    public String getError() { return error; }
    public void setError(String error) { this.error = error; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
}

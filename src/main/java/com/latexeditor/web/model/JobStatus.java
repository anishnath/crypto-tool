package com.latexeditor.web.model;

public class JobStatus {
    private String jobId;
    private String status;
    private String message;
    private String warning;

    public JobStatus() {}

    public String getJobId() { return jobId; }
    public void setJobId(String jobId) { this.jobId = jobId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getWarning() { return warning; }
    public void setWarning(String warning) { this.warning = warning; }
}

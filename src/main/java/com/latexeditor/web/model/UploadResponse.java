package com.latexeditor.web.model;

public class UploadResponse {
    private String fileId;
    private String filename;
    private String error;

    public UploadResponse() {}

    public String getFileId() { return fileId; }
    public void setFileId(String fileId) { this.fileId = fileId; }

    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }

    public String getError() { return error; }
    public void setError(String error) { this.error = error; }
}

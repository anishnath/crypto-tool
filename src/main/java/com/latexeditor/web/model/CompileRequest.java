package com.latexeditor.web.model;

import java.util.List;

public class CompileRequest {
    private String source;
    private List<String> fileIds;

    public CompileRequest() {}

    public CompileRequest(String source) {
        this.source = source;
    }

    public CompileRequest(String source, List<String> fileIds) {
        this.source = source;
        this.fileIds = fileIds;
    }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public List<String> getFileIds() { return fileIds; }
    public void setFileIds(List<String> fileIds) { this.fileIds = fileIds; }
}

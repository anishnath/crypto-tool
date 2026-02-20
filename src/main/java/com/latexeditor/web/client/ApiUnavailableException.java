package com.latexeditor.web.client;

public class ApiUnavailableException extends ApiException {

    public ApiUnavailableException(String message) {
        super(503, message);
    }
}

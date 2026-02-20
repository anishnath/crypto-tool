package com.latexeditor.web.client;

public class ApiTimeoutException extends ApiException {

    public ApiTimeoutException(String message) {
        super(504, message);
    }
}

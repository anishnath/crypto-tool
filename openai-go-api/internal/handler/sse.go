package handler

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
)

var errStreamingUnsupported = errors.New("streaming unsupported by response writer")

type streamEvent struct {
	Type               string     `json:"type"`
	ID                 string     `json:"id,omitempty"`
	Delta              string     `json:"delta,omitempty"`
	Model              string     `json:"model,omitempty"`
	Provider           string     `json:"provider,omitempty"`
	ProviderResponseID string     `json:"provider_response_id,omitempty"`
	Usage              *usageBody `json:"usage,omitempty"`
	Error              string     `json:"error,omitempty"`
}

func setupSSE(w http.ResponseWriter) (http.Flusher, error) {
	flusher, ok := w.(http.Flusher)
	if !ok {
		return nil, errStreamingUnsupported
	}
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")
	w.Header().Set("X-Accel-Buffering", "no")
	w.WriteHeader(http.StatusOK)
	flusher.Flush()
	return flusher, nil
}

func writeSSE(w http.ResponseWriter, flusher http.Flusher, evt streamEvent) error {
	data, err := json.Marshal(evt)
	if err != nil {
		return err
	}
	if _, err := fmt.Fprintf(w, "data: %s\n\n", data); err != nil {
		return err
	}
	flusher.Flush()
	return nil
}

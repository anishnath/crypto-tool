package registry

import "slices"

// EndpointInfo describes how to call a model for a given modality.
type EndpointInfo struct {
	Modality  string `json:"modality"`
	Path      string `json:"path"`
	Method    string `json:"method"`
	Streaming bool   `json:"streaming"`
	Available bool   `json:"available"`
}

// DeriveEndpoints maps catalog modalities to gateway HTTP routes.
func DeriveEndpoints(modalities []string) []EndpointInfo {
	var out []EndpointInfo
	if slices.Contains(modalities, "chat") {
		out = append(out, EndpointInfo{
			Modality:  "chat",
			Path:      "/v1/chat/completions",
			Method:    "POST",
			Streaming: true,
			Available: true,
		})
	}
	if slices.Contains(modalities, "responses") {
		out = append(out, EndpointInfo{
			Modality:  "responses",
			Path:      "/v1/responses",
			Method:    "POST",
			Streaming: true,
			Available: true,
		})
	}
	if slices.Contains(modalities, "tts") {
		out = append(out, EndpointInfo{
			Modality:  "tts",
			Path:      "/v1/tts",
			Method:    "POST",
			Streaming: false,
			Available: false,
		})
	}
	return out
}

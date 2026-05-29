package handler

import "net/http"

type healthResponse struct {
	Status string `json:"status"`
}

// Health handles GET /health.
func (a *API) Health(w http.ResponseWriter, _ *http.Request) {
	writeJSON(w, http.StatusOK, healthResponse{Status: "ok"})
}

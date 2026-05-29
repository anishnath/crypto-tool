package handler

import (
	"net/http"
	"strings"

	"github.com/anish/crypto-tool/openai-go-api/internal/registry"
)

type catalogResponse struct {
	DefaultModel string                  `json:"default_model"`
	CatalogPath  string                  `json:"catalog_path"`
	Providers    []registry.ProviderInfo `json:"providers"`
	Models       []registry.ModelSpec    `json:"models"`
}

// Models handles GET /v1/models — full catalog with configuration.
func (a *API) Models(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	cat := a.gateway.Catalog()
	writeJSON(w, http.StatusOK, catalogResponse{
		DefaultModel: cat.DefaultModel,
		CatalogPath:  cat.CatalogPath,
		Providers:    cat.Providers,
		Models:       cat.Models,
	})
}

// ModelByID handles GET /v1/models/{id}.
func (a *API) ModelByID(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	id := strings.TrimPrefix(r.URL.Path, "/v1/models/")
	id = strings.TrimSpace(id)
	if id == "" || strings.Contains(id, "/") {
		writeJSON(w, http.StatusBadRequest, errorResponse{Error: "model id is required"})
		return
	}

	spec, ok := a.gateway.GetModel(id)
	if !ok {
		writeJSON(w, http.StatusNotFound, errorResponse{Error: "model not found"})
		return
	}
	writeJSON(w, http.StatusOK, spec)
}

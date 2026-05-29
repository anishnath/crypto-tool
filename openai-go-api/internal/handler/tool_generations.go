package handler

import (
	"encoding/json"
	"io"
	"log/slog"
	"net/http"
	"strconv"
	"strings"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
)

const maxToolGenerationBody = 1 << 20 // 1 MiB

type toolGenerationSaveBody struct {
	ID         string `json:"id"`
	Source     string `json:"source"`
	UserPrompt string `json:"user_prompt"`
	Title      string `json:"title"`
	TikzCode   string `json:"tikz_code"`
	PreviewSVG string `json:"preview_svg"`
}

// ToolTikzGenerationsRecent lists recent TikZ generations (GET /v1/tools/tikz/generations/recent).
func (a *API) ToolTikzGenerationsRecent(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	if !a.billing.Enabled() {
		writeJSON(w, http.StatusOK, map[string]any{"items": []any{}})
		return
	}

	reqCtx := a.billing.RequestContext(r.Context(), r)
	mineLimit := 10
	publicLimit := 10
	if reqCtx.User.UserID != "" {
		publicLimit = 20
	}
	if q := strings.TrimSpace(r.URL.Query().Get("mine_limit")); q != "" {
		if n, err := strconv.Atoi(q); err == nil {
			mineLimit = n
		}
	}
	if q := strings.TrimSpace(r.URL.Query().Get("public_limit")); q != "" {
		if n, err := strconv.Atoi(q); err == nil {
			publicLimit = n
		}
	}
	if q := strings.TrimSpace(r.URL.Query().Get("limit")); q != "" {
		if n, err := strconv.Atoi(q); err == nil {
			mineLimit = n
			if reqCtx.User.UserID == "" {
				publicLimit = n
			}
		}
	}

	items, err := a.billing.ListToolGenerationsFeed(r.Context(), billing.ToolIDTikzViewer, reqCtx.User, mineLimit, publicLimit)
	if err != nil {
		slog.Debug("list tool generations failed", "error", err)
		writeToolGenerationError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{"items": items})
}

// ToolTikzGenerationsSave stores a TikZ generation (POST /v1/tools/tikz/generations).
func (a *API) ToolTikzGenerationsSave(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	if !a.billing.Enabled() {
		writeJSON(w, http.StatusAccepted, map[string]string{"status": "skipped"})
		return
	}

	raw, err := io.ReadAll(io.LimitReader(r.Body, maxToolGenerationBody))
	if err != nil {
		writeToolGenerationError(w, billing.ErrBadRequest)
		return
	}
	var body toolGenerationSaveBody
	if err := json.Unmarshal(raw, &body); err != nil {
		writeToolGenerationError(w, billing.ErrBadRequest)
		return
	}

	reqCtx := a.billing.RequestContext(r.Context(), r)

	// Preview-only update for a generation saved on apply.
	if strings.TrimSpace(body.ID) != "" && strings.TrimSpace(body.TikzCode) == "" {
		if strings.TrimSpace(body.PreviewSVG) == "" {
			writeToolGenerationError(w, billing.ErrBadRequest)
			return
		}
		if err := a.billing.UpdateToolGenerationPreview(r.Context(), body.ID, reqCtx.User, body.PreviewSVG); err != nil {
			slog.Debug("update tool generation preview failed", "error", err)
			writeToolGenerationError(w, err)
			return
		}
		writeJSON(w, http.StatusOK, map[string]string{"id": body.ID, "status": "updated"})
		return
	}

	rec := billing.ToolGenerationRecord{
		ToolID:     billing.ToolIDTikzViewer,
		User:       reqCtx.User,
		Source:     body.Source,
		UserPrompt: body.UserPrompt,
		Title:      body.Title,
		TikzCode:   body.TikzCode,
		PreviewSVG: body.PreviewSVG,
	}
	id, err := a.billing.SaveToolGeneration(r.Context(), rec)
	if err != nil {
		slog.Debug("save tool generation failed", "error", err)
		writeToolGenerationError(w, err)
		return
	}
	writeJSON(w, http.StatusCreated, map[string]string{"id": id, "status": "saved"})
}

func writeToolGenerationError(w http.ResponseWriter, err error) {
	if err == nil {
		return
	}
	status := http.StatusInternalServerError
	msg := err.Error()
	if err == billing.ErrBadRequest {
		status = http.StatusBadRequest
	}
	writeJSON(w, status, errorResponse{Error: msg, Code: "tool_generation_error"})
}

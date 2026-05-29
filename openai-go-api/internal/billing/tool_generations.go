package billing

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"
)

const (
	toolIDTikzViewer = "math/tikz-viewer"
	maxToolGenCode   = 65536
	maxToolGenSVG    = 32768
	maxToolGenPrompt = 4000
	maxToolGenTitle  = 200
)

// ToolGenerationRecord is a persisted apply/save event for supported tools.
type ToolGenerationRecord struct {
	ID          string
	ToolID      string
	User        UserIdentity
	Source      string
	UserPrompt  string
	Title       string
	TikzCode    string
	PreviewSVG  string
	CreatedAt   time.Time
}

// ToolGenerationItem is a list row for the recents UI.
type ToolGenerationItem struct {
	ID          string `json:"id"`
	ToolID      string `json:"tool_id"`
	Source      string `json:"source"`
	UserPrompt  string `json:"user_prompt,omitempty"`
	Title       string `json:"title,omitempty"`
	TikzCode    string `json:"tikz_code"`
	PreviewSVG  string `json:"preview_svg,omitempty"`
	CreatedAt   string `json:"created_at"`
	IsMine      bool   `json:"is_mine,omitempty"`
	AuthorLabel string `json:"author_label,omitempty"`
}

type toolGenerationDBRow struct {
	ID          string  `json:"id"`
	ToolID      string  `json:"tool_id"`
	Source      string  `json:"source"`
	UserPrompt  string  `json:"user_prompt"`
	Title       string  `json:"title"`
	TikzCode    string  `json:"tikz_code"`
	PreviewSVG  string  `json:"preview_svg"`
	CreatedAt   string  `json:"created_at"`
	UserID      *string `json:"user_id"`
	AnonymousID *string `json:"anonymous_id"`
}

// ToolGenerationsStore persists optional per-tool generation history.
type ToolGenerationsStore interface {
	InsertToolGeneration(ctx context.Context, rec ToolGenerationRecord) error
	UpdateToolGenerationPreview(ctx context.Context, id string, user UserIdentity, previewSVG string) error
	ListUserToolGenerations(ctx context.Context, toolID string, user UserIdentity, limit int) ([]toolGenerationDBRow, error)
	ListPublicToolGenerations(ctx context.Context, toolID string, limit int) ([]toolGenerationDBRow, error)
}

// ToolGenerationsEnabled reports whether a tool may use generation history APIs.
func ToolGenerationsEnabled(toolID string) bool {
	switch strings.TrimSpace(toolID) {
	case toolIDTikzViewer:
		return true
	default:
		return false
	}
}

func normalizeToolGeneration(rec *ToolGenerationRecord) error {
	if rec == nil {
		return fmt.Errorf("%w: missing record", ErrBadRequest)
	}
	rec.ToolID = strings.TrimSpace(rec.ToolID)
	if !ToolGenerationsEnabled(rec.ToolID) {
		return fmt.Errorf("%w: tool not enabled for generation history", ErrBadRequest)
	}
	rec.Source = strings.TrimSpace(rec.Source)
	if rec.Source == "" {
		rec.Source = "ai_apply"
	}
	switch rec.Source {
	case "ai_apply", "image_convert", "manual":
	default:
		return fmt.Errorf("%w: invalid source", ErrBadRequest)
	}
	rec.TikzCode = strings.TrimSpace(rec.TikzCode)
	if rec.TikzCode == "" {
		return fmt.Errorf("%w: tikz_code required", ErrBadRequest)
	}
	if len(rec.TikzCode) > maxToolGenCode {
		return fmt.Errorf("%w: tikz_code too large", ErrBadRequest)
	}
	if len(rec.PreviewSVG) > maxToolGenSVG {
		rec.PreviewSVG = rec.PreviewSVG[:maxToolGenSVG]
	}
	if len(rec.UserPrompt) > maxToolGenPrompt {
		rec.UserPrompt = rec.UserPrompt[:maxToolGenPrompt]
	}
	if len(rec.Title) > maxToolGenTitle {
		rec.Title = rec.Title[:maxToolGenTitle]
	}
	if rec.ID == "" {
		rec.ID = NewRequestID()
	}
	if rec.CreatedAt.IsZero() {
		rec.CreatedAt = time.Now().UTC()
	}
	if strings.TrimSpace(rec.Title) == "" {
		rec.Title = defaultToolGenerationTitle(rec.UserPrompt, rec.Source, rec.CreatedAt)
	}
	if _, _, err := subjectKey(rec.User); err != nil {
		return err
	}
	return nil
}

func (s *D1Store) InsertToolGeneration(ctx context.Context, rec ToolGenerationRecord) error {
	if err := normalizeToolGeneration(&rec); err != nil {
		return err
	}
	sql := `INSERT INTO tool_ai_generations (
		id, tool_id, user_id, anonymous_id, source, user_prompt, title, tikz_code, preview_svg, created_at
	) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
	_, err := s.exec(ctx, sql,
		rec.ID,
		rec.ToolID,
		nullIfEmpty(rec.User.UserID),
		nullIfEmpty(rec.User.AnonymousID),
		rec.Source,
		nullIfEmpty(rec.UserPrompt),
		nullIfEmpty(rec.Title),
		rec.TikzCode,
		nullIfEmpty(rec.PreviewSVG),
		formatTime(rec.CreatedAt),
	)
	return err
}

func defaultToolGenerationTitle(prompt, source string, at time.Time) string {
	base := strings.TrimSpace(prompt)
	if base == "" {
		switch source {
		case "image_convert":
			base = "Image to TikZ"
		default:
			base = "TikZ diagram"
		}
	}
	if len(base) > 48 {
		base = base[:45] + "…"
	}
	return fmt.Sprintf("%s · %s", base, at.Format("Jan 2, 3:04 PM"))
}

func (s *D1Store) UpdateToolGenerationPreview(ctx context.Context, id string, user UserIdentity, previewSVG string) error {
	id = strings.TrimSpace(id)
	if id == "" {
		return fmt.Errorf("%w: id required", ErrBadRequest)
	}
	previewSVG = strings.TrimSpace(previewSVG)
	if previewSVG == "" {
		return fmt.Errorf("%w: preview_svg required", ErrBadRequest)
	}
	if len(previewSVG) > maxToolGenSVG {
		previewSVG = previewSVG[:maxToolGenSVG]
	}
	if _, _, err := subjectKey(user); err != nil {
		return err
	}

	var sql string
	var args []interface{}
	if user.UserID != "" {
		sql = `UPDATE tool_ai_generations SET preview_svg = ?
			WHERE id = ? AND tool_id = ? AND user_id = ?`
		args = []interface{}{previewSVG, id, toolIDTikzViewer, user.UserID}
	} else if user.AnonymousID != "" {
		sql = `UPDATE tool_ai_generations SET preview_svg = ?
			WHERE id = ? AND tool_id = ? AND anonymous_id = ? AND (user_id IS NULL OR user_id = '')`
		args = []interface{}{previewSVG, id, toolIDTikzViewer, user.AnonymousID}
	} else {
		return fmt.Errorf("%w: send X-Anonymous-Id for guest AI or sign in", ErrBadRequest)
	}
	_, err := s.exec(ctx, sql, args...)
	return err
}

func clampToolGenLimit(limit, max int) int {
	if limit <= 0 {
		limit = 10
	}
	if limit > max {
		limit = max
	}
	return limit
}

func (s *D1Store) ListUserToolGenerations(ctx context.Context, toolID string, user UserIdentity, limit int) ([]toolGenerationDBRow, error) {
	toolID = strings.TrimSpace(toolID)
	if !ToolGenerationsEnabled(toolID) {
		return nil, fmt.Errorf("%w: tool not enabled for generation history", ErrBadRequest)
	}
	limit = clampToolGenLimit(limit, 50)

	var sql string
	var args []interface{}
	if user.UserID != "" {
		sql = `SELECT id, tool_id, source, user_prompt, title, tikz_code, preview_svg, created_at, user_id, anonymous_id
			FROM tool_ai_generations
			WHERE tool_id = ? AND user_id = ?
			ORDER BY datetime(created_at) DESC
			LIMIT ?`
		args = []interface{}{toolID, user.UserID, limit}
	} else if user.AnonymousID != "" {
		sql = `SELECT id, tool_id, source, user_prompt, title, tikz_code, preview_svg, created_at, user_id, anonymous_id
			FROM tool_ai_generations
			WHERE tool_id = ? AND anonymous_id = ? AND (user_id IS NULL OR user_id = '')
			ORDER BY datetime(created_at) DESC
			LIMIT ?`
		args = []interface{}{toolID, user.AnonymousID, limit}
	} else {
		return []toolGenerationDBRow{}, nil
	}
	return s.queryToolGenerationRows(ctx, sql, args...)
}

func (s *D1Store) ListPublicToolGenerations(ctx context.Context, toolID string, limit int) ([]toolGenerationDBRow, error) {
	toolID = strings.TrimSpace(toolID)
	if !ToolGenerationsEnabled(toolID) {
		return nil, fmt.Errorf("%w: tool not enabled for generation history", ErrBadRequest)
	}
	limit = clampToolGenLimit(limit, 50)
	sql := `SELECT id, tool_id, source, user_prompt, title, tikz_code, preview_svg, created_at, user_id, anonymous_id
		FROM tool_ai_generations
		WHERE tool_id = ?
		ORDER BY datetime(created_at) DESC
		LIMIT ?`
	return s.queryToolGenerationRows(ctx, sql, toolID, limit)
}

func (s *D1Store) queryToolGenerationRows(ctx context.Context, sql string, args ...interface{}) ([]toolGenerationDBRow, error) {
	raw, err := s.exec(ctx, sql, args...)
	if err != nil {
		return nil, err
	}
	var parsed struct {
		Result []struct {
			Results []toolGenerationDBRow `json:"results"`
		} `json:"result"`
	}
	if err := json.Unmarshal(raw, &parsed); err != nil {
		return nil, err
	}
	if len(parsed.Result) == 0 {
		return []toolGenerationDBRow{}, nil
	}
	out := parsed.Result[0].Results
	if out == nil {
		return []toolGenerationDBRow{}, nil
	}
	return out, nil
}

func derefString(v *string) string {
	if v == nil {
		return ""
	}
	return strings.TrimSpace(*v)
}

func generationBelongsToViewer(row toolGenerationDBRow, viewer UserIdentity) bool {
	rowUser := derefString(row.UserID)
	rowAnon := derefString(row.AnonymousID)
	if viewer.UserID != "" && rowUser == viewer.UserID {
		return true
	}
	if viewer.UserID == "" && viewer.AnonymousID != "" && rowAnon == viewer.AnonymousID && rowUser == "" {
		return true
	}
	return false
}

func authorLabelForGeneration(row toolGenerationDBRow, viewer UserIdentity) (label string, isMine bool) {
	if generationBelongsToViewer(row, viewer) {
		return "You", true
	}
	if derefString(row.UserID) != "" {
		return "Member", false
	}
	return "Guest", false
}

func toolGenerationItemFromRow(row toolGenerationDBRow, viewer UserIdentity) ToolGenerationItem {
	label, isMine := authorLabelForGeneration(row, viewer)
	return ToolGenerationItem{
		ID:          row.ID,
		ToolID:      row.ToolID,
		Source:      row.Source,
		UserPrompt:  row.UserPrompt,
		Title:       row.Title,
		TikzCode:    row.TikzCode,
		PreviewSVG:  row.PreviewSVG,
		CreatedAt:   row.CreatedAt,
		IsMine:      isMine,
		AuthorLabel: label,
	}
}

func mergeToolGenerationFeed(mine []toolGenerationDBRow, public []toolGenerationDBRow, viewer UserIdentity, mineLimit, publicLimit int) []ToolGenerationItem {
	seen := make(map[string]struct{}, mineLimit+publicLimit)
	out := make([]ToolGenerationItem, 0, mineLimit+publicLimit)

	for i, row := range mine {
		if i >= mineLimit {
			break
		}
		item := toolGenerationItemFromRow(row, viewer)
		item.IsMine = true
		item.AuthorLabel = "You"
		out = append(out, item)
		seen[row.ID] = struct{}{}
	}

	addedPublic := 0
	for _, row := range public {
		if addedPublic >= publicLimit {
			break
		}
		if _, ok := seen[row.ID]; ok {
			continue
		}
		out = append(out, toolGenerationItemFromRow(row, viewer))
		seen[row.ID] = struct{}{}
		addedPublic++
	}
	return out
}

func (NoopStore) InsertToolGeneration(context.Context, ToolGenerationRecord) error { return nil }

func (NoopStore) UpdateToolGenerationPreview(context.Context, string, UserIdentity, string) error {
	return nil
}

func (NoopStore) ListUserToolGenerations(context.Context, string, UserIdentity, int) ([]toolGenerationDBRow, error) {
	return []toolGenerationDBRow{}, nil
}

func (NoopStore) ListPublicToolGenerations(context.Context, string, int) ([]toolGenerationDBRow, error) {
	return []toolGenerationDBRow{}, nil
}

// ToolIDTikzViewer is the billing/tool slug for tikz-viewer.jsp.
const ToolIDTikzViewer = toolIDTikzViewer

func (l *Logger) SaveToolGeneration(ctx context.Context, rec ToolGenerationRecord) (string, error) {
	if gs, ok := l.store.(ToolGenerationsStore); ok {
		if err := normalizeToolGeneration(&rec); err != nil {
			return "", err
		}
		if err := gs.InsertToolGeneration(ctx, rec); err != nil {
			return "", err
		}
		return rec.ID, nil
	}
	return "", nil
}

func (l *Logger) UpdateToolGenerationPreview(ctx context.Context, id string, user UserIdentity, previewSVG string) error {
	if gs, ok := l.store.(ToolGenerationsStore); ok {
		return gs.UpdateToolGenerationPreview(ctx, id, user, previewSVG)
	}
	return nil
}

func (l *Logger) ListToolGenerationsFeed(ctx context.Context, toolID string, user UserIdentity, mineLimit, publicLimit int) ([]ToolGenerationItem, error) {
	if gs, ok := l.store.(ToolGenerationsStore); ok {
		mineLimit = clampToolGenLimit(mineLimit, 50)
		publicLimit = clampToolGenLimit(publicLimit, 50)

		mine, err := gs.ListUserToolGenerations(ctx, toolID, user, mineLimit)
		if err != nil {
			return nil, err
		}
		public, err := gs.ListPublicToolGenerations(ctx, toolID, publicLimit+mineLimit)
		if err != nil {
			return nil, err
		}
		return mergeToolGenerationFeed(mine, public, user, mineLimit, publicLimit), nil
	}
	return []ToolGenerationItem{}, nil
}

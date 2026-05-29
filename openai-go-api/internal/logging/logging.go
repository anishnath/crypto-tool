// Package logging configures structured logs via slog and LOG_LEVEL.
package logging

import (
	"context"
	"log/slog"
	"os"
	"strings"
)

// Init configures the default slog logger from LOG_LEVEL (default: info).
// Returns the active level for startup messages.
func Init() slog.Level {
	level := ParseLevel(os.Getenv("LOG_LEVEL"))
	h := slog.NewTextHandler(os.Stderr, &slog.HandlerOptions{Level: level})
	slog.SetDefault(slog.New(h))
	slog.Info("logging ready", "level", level.String())
	return level
}

// ParseLevel maps env strings to slog levels. Unknown values fall back to info.
func ParseLevel(s string) slog.Level {
	switch strings.ToLower(strings.TrimSpace(s)) {
	case "debug":
		return slog.LevelDebug
	case "warn", "warning":
		return slog.LevelWarn
	case "error":
		return slog.LevelError
	case "info", "":
		return slog.LevelInfo
	default:
		return slog.LevelInfo
	}
}

// IsDebug reports whether debug-level logs are emitted.
func IsDebug() bool {
	return slog.Default().Enabled(context.Background(), slog.LevelDebug)
}

// TruncateID shortens ids for logs (first n runes + ellipsis).
func TruncateID(id string, n int) string {
	id = strings.TrimSpace(id)
	if id == "" || len(id) <= n {
		return id
	}
	if n < 1 {
		n = 8
	}
	return id[:n] + "…"
}

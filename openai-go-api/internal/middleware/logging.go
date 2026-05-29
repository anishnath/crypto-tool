package middleware

import (
	"log/slog"
	"net/http"
	"time"

	"github.com/anish/crypto-tool/openai-go-api/internal/billing"
	"github.com/anish/crypto-tool/openai-go-api/internal/logging"
)

type responseWriter struct {
	http.ResponseWriter
	status int
	bytes  int
}

func (w *responseWriter) WriteHeader(code int) {
	w.status = code
	w.ResponseWriter.WriteHeader(code)
}

func (w *responseWriter) Write(b []byte) (int, error) {
	if w.status == 0 {
		w.status = http.StatusOK
	}
	n, err := w.ResponseWriter.Write(b)
	w.bytes += n
	return n, err
}

func (w *responseWriter) Flush() {
	if f, ok := w.ResponseWriter.(http.Flusher); ok {
		f.Flush()
	}
}

// Logging logs each HTTP request at info; debug adds identity and tool headers.
func Logging(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		wrapped := &responseWriter{ResponseWriter: w}
		next.ServeHTTP(wrapped, r)
		elapsed := time.Since(start)

		if logging.IsDebug() {
			args := []any{
				"method", r.Method,
				"path", r.URL.Path,
				"status", wrapped.status,
				"bytes", wrapped.bytes,
				"duration", elapsed,
				"tool_id", billing.ToolIDFromRequest(r),
			}
			if uid := r.Header.Get("X-User-Id"); uid != "" {
				args = append(args, "user_id", logging.TruncateID(uid, 12))
			}
			if aid := r.Header.Get("X-Anonymous-Id"); aid != "" {
				args = append(args, "anonymous_id", logging.TruncateID(aid, 12))
			}
			slog.Debug("http access", args...)
		} else {
			slog.Info("http access",
				"method", r.Method,
				"path", r.URL.Path,
				"status", wrapped.status,
				"bytes", wrapped.bytes,
				"duration", elapsed,
			)
		}
	})
}

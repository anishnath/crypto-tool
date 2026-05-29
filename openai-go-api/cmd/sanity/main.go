package main

import (
	"bytes"
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"
)

const defaultBaseURL = "http://localhost:8080"

func main() {
	baseURL := flag.String("base-url", envOr("SANITY_BASE_URL", defaultBaseURL), "gateway base URL")
	timeout := flag.Duration("timeout", 120*time.Second, "per-request timeout")
	flag.Parse()

	client := &http.Client{Timeout: *timeout}
	ctx := context.Background()

	fmt.Printf("sanity check → %s\n\n", strings.TrimRight(*baseURL, "/"))

	if err := checkHealth(client, *baseURL); err != nil {
		fatalf("health: %v", err)
	}
	fmt.Println("✓ GET /health")

	models, err := fetchModels(client, *baseURL)
	if err != nil {
		fatalf("models: %v", err)
	}
	fmt.Printf("✓ GET /v1/models (%d models, default=%s)\n\n", len(models.Models), models.DefaultModel)

	var passed, failed, skipped int
	for _, m := range models.Models {
		switch {
		case contains(m.Modalities, "chat"):
			out, err := chat(ctx, client, *baseURL, m.ID)
			report(m.ID, "chat", out, err, &passed, &failed)
		case contains(m.Modalities, "responses"):
			out, err := responses(ctx, client, *baseURL, m.ID)
			report(m.ID, "responses", out, err, &passed, &failed)
		default:
			fmt.Printf("SKIP  %-22s  modalities=%v (no chat/responses endpoint)\n", m.ID, m.Modalities)
			skipped++
		}
	}

	fmt.Printf("\nresult: %d passed, %d failed, %d skipped\n", passed, failed, skipped)
	if failed > 0 {
		os.Exit(1)
	}
}

func report(model, endpoint, output string, err error, passed, failed *int) {
	if err != nil {
		fmt.Printf("FAIL  %-22s  %-10s  %s\n", model, endpoint, err)
		*failed++
		return
	}
	fmt.Printf("PASS  %-22s  %-10s  %q\n", model, endpoint, truncate(output, 50))
	*passed++
}

func checkHealth(client *http.Client, baseURL string) error {
	resp, err := client.Get(baseURL + "/health")
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("status %d", resp.StatusCode)
	}
	return nil
}

type modelsResponse struct {
	DefaultModel string      `json:"default_model"`
	Models       []modelItem `json:"models"`
}

type modelItem struct {
	ID         string   `json:"id"`
	Provider   string   `json:"provider"`
	Modalities []string `json:"modalities"`
}

func fetchModels(client *http.Client, baseURL string) (modelsResponse, error) {
	resp, err := client.Get(baseURL + "/v1/models")
	if err != nil {
		return modelsResponse{}, err
	}
	defer resp.Body.Close()
	body, _ := io.ReadAll(resp.Body)
	if resp.StatusCode != http.StatusOK {
		return modelsResponse{}, fmt.Errorf("status %d: %s", resp.StatusCode, truncate(string(body), 120))
	}
	var out modelsResponse
	if err := json.Unmarshal(body, &out); err != nil {
		return modelsResponse{}, err
	}
	return out, nil
}

func chat(ctx context.Context, client *http.Client, baseURL, model string) (string, error) {
	payload := map[string]any{
		"model": model,
		"messages": []map[string]string{
			{"role": "user", "content": "Reply with exactly: ok"},
		},
	}
	return postJSON(ctx, client, baseURL+"/v1/chat/completions", payload, func(raw []byte) (string, error) {
		var out struct {
			Content string `json:"content"`
		}
		if err := json.Unmarshal(raw, &out); err != nil {
			return "", err
		}
		if strings.TrimSpace(out.Content) == "" {
			return "", fmt.Errorf("empty content")
		}
		return out.Content, nil
	})
}

func responses(ctx context.Context, client *http.Client, baseURL, model string) (string, error) {
	payload := map[string]any{
		"model": model,
		"input": "Reply with exactly: ok",
	}
	return postJSON(ctx, client, baseURL+"/v1/responses", payload, func(raw []byte) (string, error) {
		var out struct {
			Output string `json:"output"`
		}
		if err := json.Unmarshal(raw, &out); err != nil {
			return "", err
		}
		if strings.TrimSpace(out.Output) == "" {
			return "", fmt.Errorf("empty output")
		}
		return out.Output, nil
	})
}

func postJSON(ctx context.Context, client *http.Client, url string, payload any, parse func([]byte) (string, error)) (string, error) {
	body, err := json.Marshal(payload)
	if err != nil {
		return "", err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(body))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	raw, _ := io.ReadAll(resp.Body)

	if resp.StatusCode != http.StatusOK {
		var er struct {
			Error string `json:"error"`
		}
		_ = json.Unmarshal(raw, &er)
		if er.Error != "" {
			return "", fmt.Errorf("%s", truncate(er.Error, 160))
		}
		return "", fmt.Errorf("status %d: %s", resp.StatusCode, truncate(string(raw), 120))
	}
	return parse(raw)
}

func contains(list []string, target string) bool {
	for _, v := range list {
		if v == target {
			return true
		}
	}
	return false
}

func truncate(s string, n int) string {
	s = strings.ReplaceAll(s, "\n", " ")
	if len(s) <= n {
		return s
	}
	return s[:n] + "…"
}

func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func fatalf(format string, args ...any) {
	fmt.Fprintf(os.Stderr, format+"\n", args...)
	os.Exit(1)
}

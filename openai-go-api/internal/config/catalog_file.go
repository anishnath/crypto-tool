package config

import (
	"fmt"
	"os"
	"strings"

	"gopkg.in/yaml.v3"
)

// CatalogFile is layer 2: declarative model catalog (YAML on disk).
type CatalogFile struct {
	DefaultModel       string      `yaml:"default_model"`
	DefaultVisionModel string      `yaml:"default_vision_model"` // model to auto-route image requests to
	Models             []ModelDecl `yaml:"models"`
}

// ModelDecl is one routable model in the catalog file.
type ModelDecl struct {
	ID           string   `yaml:"id"`
	Provider     string   `yaml:"provider"`
	Modalities   []string `yaml:"modalities"`
	Capabilities []string `yaml:"capabilities,omitempty"` // e.g. [vision] — gates image input
	Enabled      *bool    `yaml:"enabled,omitempty"`
}

func (m ModelDecl) isEnabled() bool {
	if m.Enabled == nil {
		return true
	}
	return *m.Enabled
}

func loadCatalogFile(path string) (CatalogFile, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return CatalogFile{}, fmt.Errorf("read model catalog %q: %w", path, err)
	}
	var file CatalogFile
	if err := yaml.Unmarshal(data, &file); err != nil {
		return CatalogFile{}, fmt.Errorf("parse model catalog %q: %w", path, err)
	}
	if err := file.validate(); err != nil {
		return CatalogFile{}, err
	}
	return file, nil
}

func (f CatalogFile) validate() error {
	if len(f.Models) == 0 {
		return fmt.Errorf("model catalog must contain at least one model")
	}
	seen := map[string]struct{}{}
	active := 0
	for _, m := range f.Models {
		id := strings.TrimSpace(m.ID)
		provider := strings.ToLower(strings.TrimSpace(m.Provider))
		if id == "" || provider == "" {
			return fmt.Errorf("each model requires id and provider")
		}
		if len(m.Modalities) == 0 {
			return fmt.Errorf("model %q must declare modalities", id)
		}
		if _, ok := seen[id]; ok {
			return fmt.Errorf("duplicate model id %q in catalog", id)
		}
		seen[id] = struct{}{}
		if m.isEnabled() {
			active++
		}
	}
	if active == 0 {
		return fmt.Errorf("model catalog has no enabled models")
	}
	def := strings.TrimSpace(f.DefaultModel)
	if def != "" {
		found := false
		for _, m := range f.Models {
			if strings.TrimSpace(m.ID) == def && m.isEnabled() {
				found = true
				break
			}
		}
		if !found {
			return fmt.Errorf("default_model %q must refer to an enabled model in catalog", def)
		}
	}
	return nil
}

func (f CatalogFile) activeModels() []ModelDecl {
	out := make([]ModelDecl, 0, len(f.Models))
	for _, m := range f.Models {
		if m.isEnabled() {
			out = append(out, m)
		}
	}
	return out
}

func (f CatalogFile) providerIDs() []string {
	seen := map[string]struct{}{}
	var ids []string
	for _, m := range f.activeModels() {
		id := strings.ToLower(strings.TrimSpace(m.Provider))
		if _, ok := seen[id]; ok {
			continue
		}
		seen[id] = struct{}{}
		ids = append(ids, id)
	}
	return ids
}

// resolveVisionModel picks the model to auto-route image requests to. Env
// override (DEFAULT_VISION_MODEL) wins over the catalog's default_vision_model.
// Returns "" (feature off) when neither is set. Errors if the chosen model
// isn't an enabled, vision-capable model in the catalog.
func (f CatalogFile) resolveVisionModel(envOverride string) (string, error) {
	pick := strings.TrimSpace(envOverride)
	src := "DEFAULT_VISION_MODEL"
	if pick == "" {
		pick = strings.TrimSpace(f.DefaultVisionModel)
		src = "default_vision_model"
	}
	if pick == "" {
		return "", nil // no vision auto-route configured
	}
	for _, m := range f.activeModels() {
		if strings.TrimSpace(m.ID) == pick {
			for _, c := range m.Capabilities {
				if strings.TrimSpace(c) == "vision" {
					return pick, nil
				}
			}
			return "", fmt.Errorf("%s %q is not vision-capable (add 'capabilities: [vision]')", src, pick)
		}
	}
	return "", fmt.Errorf("%s %q is not an enabled model in catalog", src, pick)
}

func (f CatalogFile) resolveDefault(envOverride string) (string, error) {
	if v := strings.TrimSpace(envOverride); v != "" {
		for _, m := range f.activeModels() {
			if strings.TrimSpace(m.ID) == v {
				return v, nil
			}
		}
		return "", fmt.Errorf("DEFAULT_MODEL %q is not an enabled model in catalog", v)
	}
	if v := strings.TrimSpace(f.DefaultModel); v != "" {
		return v, nil
	}
	for _, m := range f.activeModels() {
		return strings.TrimSpace(m.ID), nil
	}
	return "", fmt.Errorf("no default model configured")
}

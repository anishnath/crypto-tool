package config

import (
	"fmt"
	"os"
	"strings"

	"gopkg.in/yaml.v3"
)

// CatalogFile is layer 2: declarative model catalog (YAML on disk).
type CatalogFile struct {
	DefaultModel string      `yaml:"default_model"`
	Models       []ModelDecl `yaml:"models"`
}

// ModelDecl is one routable model in the catalog file.
type ModelDecl struct {
	ID         string   `yaml:"id"`
	Provider   string   `yaml:"provider"`
	Modalities []string `yaml:"modalities"`
	Enabled    *bool    `yaml:"enabled,omitempty"`
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

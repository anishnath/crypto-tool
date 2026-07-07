package config

import "os"

const defaultCatalogPath = "config/models.yaml"

// Policy is layer 3: runtime settings from environment (not the model catalog).
type Policy struct {
	Port               string
	DefaultModel       string // empty → use catalog default_model
	DefaultVisionModel string // empty → use catalog default_vision_model
	ModelCatalogPath   string
}

func loadPolicy() Policy {
	return Policy{
		Port:               envOrDefault("PORT", "8080"),
		DefaultModel:       os.Getenv("DEFAULT_MODEL"),
		DefaultVisionModel: os.Getenv("DEFAULT_VISION_MODEL"),
		ModelCatalogPath:   envOrDefault("MODEL_CATALOG_PATH", defaultCatalogPath),
	}
}

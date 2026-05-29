package catalog

// ModelProfile is built-in metadata for a known model ID.
type ModelProfile struct {
	Modalities []string
	Sampling   SamplingProfile
}

var builtIn = func() map[string]ModelProfile {
	all := make(map[string]ModelProfile)
	for id, p := range OpenAIModels() {
		all[id] = p
	}
	for id, p := range MiMoModels() {
		all[id] = p
	}
	return all
}()

// Lookup returns built-in profile for a model ID, if known.
func Lookup(modelID string) (ModelProfile, bool) {
	p, ok := builtIn[modelID]
	return p, ok
}

// MergeModalities uses catalog modalities when the registry entry left capabilities generic.
func MergeModalities(modelID string, registryModalities []string) []string {
	if p, ok := Lookup(modelID); ok && len(p.Modalities) > 0 {
		return p.Modalities
	}
	return registryModalities
}

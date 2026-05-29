package registry

import (
	"errors"
	"fmt"
	"slices"
	"strings"

	"github.com/anish/crypto-tool/openai-go-api/internal/catalog"
	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
)

// Validation codes returned in API error responses.
const (
	CodeModelNotFound        = "model_not_found"
	CodeModalityNotSupported = "modality_not_supported"
	CodeEndpointUnavailable  = "endpoint_unavailable"
	CodeInvalidTask          = "invalid_task"
	CodeInvalidSampling      = "invalid_sampling"
)

// ModelValidationError describes why a model cannot be used on an endpoint.
type ModelValidationError struct {
	Code     string
	Model    string
	Modality string
	Message  string
	Hint     string
}

func (e *ModelValidationError) Error() string {
	if e.Message != "" {
		return e.Message
	}
	return fmt.Sprintf("model %q validation failed", e.Model)
}

func (e *ModelValidationError) Is(target error) bool {
	return target == ErrBadRequest
}

// ValidateModel checks that modelID can be used for the given modality.
func (r *Registry) ValidateModel(modelID string, modality provider.Modality) (ModelEntry, error) {
	id := strings.TrimSpace(modelID)
	usingDefault := id == ""
	if usingDefault {
		id = r.defaultModel
	}

	entry, ok := r.entries[id]
	if !ok {
		return ModelEntry{}, &ModelValidationError{
			Code:     CodeModelNotFound,
			Model:    id,
			Modality: string(modality),
			Message:  fmt.Sprintf("model %q is not in the catalog", id),
			Hint:     "call GET /v1/models for supported models",
		}
	}

	mod := string(modality)
	if !slices.Contains(entry.Modalities, mod) {
		return ModelEntry{}, &ModelValidationError{
			Code:     CodeModalityNotSupported,
			Model:    id,
			Modality: mod,
			Message:  fmt.Sprintf("model %q does not support %q on this endpoint", id, mod),
			Hint:     endpointHint(entry.Modalities),
		}
	}

	for _, ep := range DeriveEndpoints(entry.Modalities) {
		if ep.Modality == mod && !ep.Available {
			return ModelEntry{}, &ModelValidationError{
				Code:     CodeEndpointUnavailable,
				Model:    id,
				Modality: mod,
				Message:  fmt.Sprintf("model %q supports %q but the gateway endpoint is not available yet", id, mod),
				Hint:     "this modality is listed in the catalog but not implemented",
			}
		}
	}

	return entry, nil
}

// ValidateSampling checks task and sampling overrides for chat requests.
func ValidateSampling(profile *catalog.SamplingProfile, task string, temp, topP *float64) error {
	if profile == nil {
		if task != "" || temp != nil || topP != nil {
			return &ModelValidationError{
				Code:    CodeInvalidSampling,
				Message: "this model has no sampling configuration; omit task, temperature, and top_p",
			}
		}
		return nil
	}

	task = strings.TrimSpace(task)
	if task != "" && len(profile.TaskRecommendations) > 0 {
		if !knownTask(profile.TaskRecommendations, task) {
			return &ModelValidationError{
				Code:    CodeInvalidTask,
				Message: fmt.Sprintf("unknown task %q for this model", task),
				Hint:    taskHint(profile.TaskRecommendations),
			}
		}
	}

	_, err := profile.Resolve(task, temp, topP)
	if err != nil {
		var ve *catalog.ValidationError
		if errors.As(err, &ve) {
			return &ModelValidationError{
				Code:    CodeInvalidSampling,
				Message: ve.Error(),
			}
		}
		return err
	}
	return nil
}

func knownTask(tasks []catalog.TaskSampling, task string) bool {
	for _, t := range tasks {
		if t.Task == task {
			return true
		}
	}
	return false
}

func taskHint(tasks []catalog.TaskSampling) string {
	names := make([]string, 0, len(tasks))
	for _, t := range tasks {
		names = append(names, t.Task)
	}
	return "supported tasks: " + strings.Join(names, ", ")
}

func endpointHint(modalities []string) string {
	var parts []string
	for _, ep := range DeriveEndpoints(modalities) {
		if ep.Available {
			parts = append(parts, fmt.Sprintf("%s %s", ep.Method, ep.Path))
		}
	}
	if len(parts) == 0 {
		return "see GET /v1/models for configuration"
	}
	return "use " + strings.Join(parts, " or ")
}

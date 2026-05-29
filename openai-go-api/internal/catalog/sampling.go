package catalog

import "fmt"

// ParamRange is an inclusive allowed range for a sampling parameter.
type ParamRange struct {
	Min float64 `json:"min"`
	Max float64 `json:"max"`
}

// FloatParam describes default and allowed range.
type FloatParam struct {
	Default float64    `json:"default"`
	Range   ParamRange `json:"range"`
}

// TaskSampling recommends temperature/top_p for a task type.
type TaskSampling struct {
	Task        string  `json:"task"`
	Temperature float64 `json:"temperature"`
	TopP        float64 `json:"top_p"`
}

// SamplingProfile is per-model sampling metadata exposed by GET /v1/models.
type SamplingProfile struct {
	Temperature         FloatParam     `json:"temperature"`
	TopP                FloatParam     `json:"top_p"`
	TaskRecommendations []TaskSampling `json:"task_recommendations,omitempty"`
}

// ResolvedSampling is the values sent to the provider for a request.
type ResolvedSampling struct {
	Temperature float64
	TopP        float64
}

// Resolve picks temperature/top_p from explicit overrides, optional task, then defaults.
func (p SamplingProfile) Resolve(task string, tempOverride, topPOverride *float64) (ResolvedSampling, error) {
	temp := p.Temperature.Default
	topP := p.TopP.Default

	if task != "" {
		for _, rec := range p.TaskRecommendations {
			if rec.Task == task {
				temp = rec.Temperature
				topP = rec.TopP
				break
			}
		}
	}
	if tempOverride != nil {
		temp = *tempOverride
	}
	if topPOverride != nil {
		topP = *topPOverride
	}
	if err := validateParam("temperature", temp, p.Temperature.Range); err != nil {
		return ResolvedSampling{}, err
	}
	if err := validateParam("top_p", topP, p.TopP.Range); err != nil {
		return ResolvedSampling{}, err
	}
	return ResolvedSampling{Temperature: temp, TopP: topP}, nil
}

func validateParam(name string, value float64, r ParamRange) error {
	if value < r.Min || value > r.Max {
		return &ValidationError{
			Param: name,
			Value: value,
			Min:   r.Min,
			Max:   r.Max,
		}
	}
	return nil
}

// ValidationError indicates a sampling parameter is out of range.
type ValidationError struct {
	Param string
	Value float64
	Min   float64
	Max   float64
}

func (e *ValidationError) Error() string {
	return fmt.Sprintf("%s=%g out of range [%g, %g]", e.Param, e.Value, e.Min, e.Max)
}

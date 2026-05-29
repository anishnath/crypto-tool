package catalog

// OpenAI chat models use standard sampling defaults unless overridden per request.
var openAIChatRange = ParamRange{Min: 0, Max: 2.0}

var openAITopPRange = ParamRange{Min: 0, Max: 1.0}

func openAIChatSampling() SamplingProfile {
	return SamplingProfile{
		Temperature: FloatParam{Default: 1.0, Range: openAIChatRange},
		TopP:        FloatParam{Default: 1.0, Range: openAITopPRange},
	}
}

// OpenAIModels returns built-in catalog metadata for OpenAI GPT-5.x models.
// Pro variants are Responses-API-only per OpenAI docs.
func OpenAIModels() map[string]ModelProfile {
	chat := openAIChatSampling()
	chatAndResponses := []string{"chat", "responses"}
	responsesOnly := []string{"responses"}

	return map[string]ModelProfile{
		"gpt-5.5":      {Modalities: chatAndResponses, Sampling: chat},
		"gpt-5.5-pro":  {Modalities: responsesOnly, Sampling: chat},
		"gpt-5.4":      {Modalities: chatAndResponses, Sampling: chat},
		"gpt-5.4-mini": {Modalities: chatAndResponses, Sampling: chat},
		"gpt-5.4-nano": {Modalities: chatAndResponses, Sampling: chat},
		"gpt-5.4-pro":  {Modalities: responsesOnly, Sampling: chat},
	}
}

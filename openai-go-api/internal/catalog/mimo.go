package catalog

// mimoStandardRange is shared by most MiMo chat/TTS models.
var mimoStandardRange = ParamRange{Min: 0, Max: 1.5}

var mimoTopPRange = ParamRange{Min: 0.01, Max: 1.0}

func mimoChatSampling(defaultTemp float64, tasks []TaskSampling) SamplingProfile {
	return SamplingProfile{
		Temperature:         FloatParam{Default: defaultTemp, Range: mimoStandardRange},
		TopP:                FloatParam{Default: 0.95, Range: mimoTopPRange},
		TaskRecommendations: tasks,
	}
}

func mimoProTasks() []TaskSampling {
	return []TaskSampling{
		{Task: "vibe_coding", Temperature: 1, TopP: 0.95},
		{Task: "function_call", Temperature: 1, TopP: 0.95},
		{Task: "general_conversation", Temperature: 1, TopP: 0.95},
		{Task: "creative_writing", Temperature: 1, TopP: 0.95},
		{Task: "webdev", Temperature: 1, TopP: 0.95},
		{Task: "mathematical_reasoning", Temperature: 1, TopP: 0.95},
	}
}

func mimoFlashTasks() []TaskSampling {
	return []TaskSampling{
		{Task: "vibe_coding", Temperature: 0.3, TopP: 0.95},
		{Task: "function_call", Temperature: 0.3, TopP: 0.95},
		{Task: "general_conversation", Temperature: 0.8, TopP: 0.95},
		{Task: "creative_writing", Temperature: 0.8, TopP: 0.95},
		{Task: "webdev", Temperature: 0.8, TopP: 0.95},
		{Task: "mathematical_reasoning", Temperature: 1, TopP: 0.95},
	}
}

// MiMoModels returns built-in catalog entries for Xiaomi MiMo models.
func MiMoModels() map[string]ModelProfile {
	chatPro := mimoChatSampling(1.0, mimoProTasks())
	chatFlash := mimoChatSampling(0.3, mimoFlashTasks())
	chatTTS := mimoChatSampling(0.6, nil)

	return map[string]ModelProfile{
		"mimo-v2.5-pro":             {Modalities: []string{"chat"}, Sampling: chatPro},
		"mimo-v2-pro":               {Modalities: []string{"chat"}, Sampling: chatPro},
		"mimo-v2.5":                 {Modalities: []string{"chat"}, Sampling: chatPro},
		"mimo-v2-omni":              {Modalities: []string{"chat"}, Sampling: chatPro},
		"mimo-v2-flash":             {Modalities: []string{"chat"}, Sampling: chatFlash},
		"mimo-v2.5-tts":             {Modalities: []string{"tts"}, Sampling: chatTTS},
		"mimo-v2.5-tts-voicedesign": {Modalities: []string{"tts"}, Sampling: chatTTS},
		"mimo-v2.5-tts-voiceclone":  {Modalities: []string{"tts"}, Sampling: chatTTS},
		"mimo-v2-tts":               {Modalities: []string{"tts"}, Sampling: chatTTS},
	}
}

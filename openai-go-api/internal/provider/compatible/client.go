package compatible

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"github.com/openai/openai-go/v3"
	"github.com/openai/openai-go/v3/option"
	"github.com/openai/openai-go/v3/responses"

	"github.com/anish/crypto-tool/openai-go-api/internal/provider"
)

// Client implements ChatBackend using an OpenAI-compatible HTTP API.
type Client struct {
	id     string
	client openai.Client
}

// NewClient builds a provider client for the given base URL and API key.
func NewClient(id, apiKey, baseURL string) *Client {
	return &Client{
		id: id,
		client: openai.NewClient(
			option.WithAPIKey(apiKey),
			option.WithBaseURL(baseURL),
		),
	}
}

func (c *Client) ID() string { return c.id }

func (c *Client) Chat(ctx context.Context, model string, messages []provider.Message, sampling provider.SamplingConfig) (provider.ChatResult, error) {
	msgs, err := toSDKMessages(messages)
	if err != nil {
		return provider.ChatResult{}, err
	}
	params := openai.ChatCompletionNewParams{
		Messages: msgs,
		Model:    model,
	}
	applySampling(&params, sampling)
	completion, err := c.client.Chat.Completions.New(ctx, params)
	if err != nil {
		return provider.ChatResult{}, fmt.Errorf("%s chat: %w", c.id, err)
	}
	if len(completion.Choices) == 0 {
		return provider.ChatResult{}, errors.New("no choices in completion response")
	}
	return provider.ChatResult{
		Model:              string(completion.Model),
		Content:            completion.Choices[0].Message.Content,
		Usage:              provider.UsageFromCompletion(completion.Usage),
		ProviderResponseID: completion.ID,
	}, nil
}

func (c *Client) StreamChat(
	ctx context.Context,
	model string,
	messages []provider.Message,
	sampling provider.SamplingConfig,
	emit func(delta string) error,
) (provider.ChatResult, error) {
	msgs, err := toSDKMessages(messages)
	if err != nil {
		return provider.ChatResult{}, err
	}
	params := openai.ChatCompletionNewParams{
		Messages: msgs,
		Model:    model,
		StreamOptions: openai.ChatCompletionStreamOptionsParam{
			IncludeUsage: openai.Bool(true),
		},
	}
	applySampling(&params, sampling)
	stream := c.client.Chat.Completions.NewStreaming(ctx, params)
	defer stream.Close()

	var (
		resolved   = model
		content    strings.Builder
		usage      provider.Usage
		responseID string
	)
	for stream.Next() {
		chunk := stream.Current()
		if chunk.ID != "" {
			responseID = chunk.ID
		}
		if chunk.Model != "" {
			resolved = string(chunk.Model)
		}
		if chunk.JSON.Usage.Valid() {
			usage = provider.UsageFromCompletion(chunk.Usage)
		}
		if len(chunk.Choices) == 0 {
			continue
		}
		delta := chunk.Choices[0].Delta.Content
		if delta == "" {
			continue
		}
		content.WriteString(delta)
		if err := emit(delta); err != nil {
			return provider.ChatResult{
				Model:              resolved,
				Content:            content.String(),
				Usage:              usage,
				ProviderResponseID: responseID,
			}, err
		}
	}
	if err := stream.Err(); err != nil {
		return provider.ChatResult{
			Model:              resolved,
			Content:            content.String(),
			Usage:              usage,
			ProviderResponseID: responseID,
		}, fmt.Errorf("%s chat stream: %w", c.id, err)
	}
	return provider.ChatResult{
		Model:              resolved,
		Content:            content.String(),
		Usage:              usage,
		ProviderResponseID: responseID,
	}, nil
}

func (c *Client) Response(ctx context.Context, model, input string) (provider.ResponseResult, error) {
	resp, err := c.client.Responses.New(ctx, responses.ResponseNewParams{
		Input: responses.ResponseNewParamsInputUnion{OfString: openai.String(input)},
		Model: model,
	})
	if err != nil {
		return provider.ResponseResult{}, fmt.Errorf("%s response: %w", c.id, err)
	}
	return provider.ResponseResult{
		Model:              string(resp.Model),
		Output:             resp.OutputText(),
		Usage:              provider.UsageFromResponse(resp.Usage),
		ProviderResponseID: resp.ID,
	}, nil
}

func (c *Client) StreamResponse(
	ctx context.Context,
	model, input string,
	emit func(delta string) error,
) (provider.ResponseResult, error) {
	stream := c.client.Responses.NewStreaming(ctx, responses.ResponseNewParams{
		Input: responses.ResponseNewParamsInputUnion{OfString: openai.String(input)},
		Model: model,
	})
	defer stream.Close()

	var (
		resolved   = model
		output     strings.Builder
		usage      provider.Usage
		responseID string
	)
	for stream.Next() {
		event := stream.Current()
		if event.Type == "response.completed" {
			if event.Response.Model != "" {
				resolved = string(event.Response.Model)
			}
			if event.Response.ID != "" {
				responseID = event.Response.ID
			}
			if event.Response.JSON.Usage.Valid() {
				usage = provider.UsageFromResponse(event.Response.Usage)
			}
		}
		if event.Type != "response.output_text.delta" || event.Delta == "" {
			continue
		}
		output.WriteString(event.Delta)
		if err := emit(event.Delta); err != nil {
			return provider.ResponseResult{
				Model:              resolved,
				Output:             output.String(),
				Usage:              usage,
				ProviderResponseID: responseID,
			}, err
		}
	}
	if err := stream.Err(); err != nil {
		return provider.ResponseResult{
			Model:              resolved,
			Output:             output.String(),
			Usage:              usage,
			ProviderResponseID: responseID,
		}, fmt.Errorf("%s response stream: %w", c.id, err)
	}
	return provider.ResponseResult{
		Model:              resolved,
		Output:             output.String(),
		Usage:              usage,
		ProviderResponseID: responseID,
	}, nil
}

func applySampling(params *openai.ChatCompletionNewParams, sampling provider.SamplingConfig) {
	if !sampling.Set {
		return
	}
	params.Temperature = openai.Float(sampling.Temperature)
	params.TopP = openai.Float(sampling.TopP)
}

func toSDKMessages(messages []provider.Message) ([]openai.ChatCompletionMessageParamUnion, error) {
	if len(messages) == 0 {
		return nil, errors.New("at least one message is required")
	}
	out := make([]openai.ChatCompletionMessageParamUnion, 0, len(messages))
	for _, m := range messages {
		switch m.Role {
		case "system":
			out = append(out, openai.SystemMessage(m.Content))
		case "developer":
			out = append(out, openai.DeveloperMessage(m.Content))
		case "assistant":
			out = append(out, openai.AssistantMessage(m.Content))
		default:
			out = append(out, openai.UserMessage(m.Content))
		}
	}
	return out, nil
}

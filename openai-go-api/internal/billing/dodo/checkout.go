package dodo

// CheckoutResult is returned when a Dodo checkout session is created.
type CheckoutResult struct {
	SessionID   string `json:"session_id"`
	CheckoutURL string `json:"checkout_url"`
}

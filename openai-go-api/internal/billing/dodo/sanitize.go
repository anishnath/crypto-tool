package dodo

import (
	"encoding/json"
	"strings"
)

// SanitizedEvent is the reduced webhook shape stored in D1 (no card/billing street PII).
type SanitizedEvent struct {
	BusinessID string           `json:"business_id,omitempty"`
	Type       string           `json:"type,omitempty"`
	Timestamp  string           `json:"timestamp,omitempty"`
	Data       SanitizedPayload `json:"data,omitempty"`
}

// SanitizedPayload holds fields used for billing logic and support.
type SanitizedPayload struct {
	PayloadType       string             `json:"payload_type,omitempty"`
	PaymentID         string             `json:"payment_id,omitempty"`
	SubscriptionID    string             `json:"subscription_id,omitempty"`
	CheckoutSessionID string             `json:"checkout_session_id,omitempty"`
	Status            string             `json:"status,omitempty"`
	Currency          string             `json:"currency,omitempty"`
	TotalAmount       int64              `json:"total_amount,omitempty"`
	SettlementAmount  int64              `json:"settlement_amount,omitempty"`
	ProductID         string             `json:"product_id,omitempty"`
	Customer          *SanitizedCustomer `json:"customer,omitempty"`
	Metadata          map[string]string  `json:"metadata,omitempty"`
	NextBillingDate   string             `json:"next_billing_date,omitempty"`
	PreviousBilling   string             `json:"previous_billing_date,omitempty"`
	PaymentInterval   string             `json:"payment_frequency_interval,omitempty"`
	CancelAtNext      bool               `json:"cancel_at_next_billing_date,omitempty"`
}

// SanitizedCustomer is non-sensitive customer identifiers only.
type SanitizedCustomer struct {
	CustomerID string `json:"customer_id,omitempty"`
	Email      string `json:"email,omitempty"`
}

// SanitizeWebhookJSON parses a Dodo webhook and returns compact JSON safe for D1 audit tables.
func SanitizeWebhookJSON(raw string) string {
	root := parseEvent(raw)
	data := asMap(root, "data")
	if data == nil {
		data = root
	}
	out := SanitizedEvent{
		BusinessID: str(root, "business_id", "businessId"),
		Type:       str(root, "type"),
		Timestamp:  str(root, "timestamp"),
		Data:       buildSanitizedData(data),
	}
	b, err := json.Marshal(out)
	if err != nil {
		return raw
	}
	return string(b)
}

func buildSanitizedData(data map[string]interface{}) SanitizedPayload {
	sp := SanitizedPayload{
		PayloadType:       str(data, "payload_type", "payloadType"),
		PaymentID:         paymentID(data),
		SubscriptionID:    subscriptionID(data),
		CheckoutSessionID: checkoutSessionID(data),
		Status:            str(data, "status"),
		Currency:          str(data, "currency"),
		TotalAmount:       amountCents(data, "total_amount", "totalAmount"),
		SettlementAmount:  amountCents(data, "settlement_amount", "settlementAmount"),
		ProductID:         productIDFromData(data),
		NextBillingDate:   str(data, "next_billing_date", "nextBillingDate"),
		PreviousBilling:   str(data, "previous_billing_date", "previousBillingDate"),
		PaymentInterval:   str(data, "payment_frequency_interval", "paymentFrequencyInterval"),
		CancelAtNext:      boolField(data, "cancel_at_next_billing_date", "cancelAtNextBillingDate"),
		Metadata:          metadataStringMap(data),
	}
	if sp.Metadata == nil {
		sp.Metadata = metadataStringMap(asMap(data, "customer"))
	}
	if cust := asMap(data, "customer"); cust != nil {
		sp.Customer = &SanitizedCustomer{
			CustomerID: customerID(data),
			Email:      str(cust, "email"),
		}
	}
	return sp
}

func metadataStringMap(m map[string]interface{}) map[string]string {
	if m == nil {
		return nil
	}
	meta := asMap(m, "metadata")
	if meta == nil {
		return nil
	}
	out := make(map[string]string)
	for k, v := range meta {
		if s := strings.TrimSpace(fmtAny(v)); s != "" && s != "null" {
			out[k] = s
		}
	}
	if len(out) == 0 {
		return nil
	}
	return out
}

func boolField(m map[string]interface{}, keys ...string) bool {
	if m == nil {
		return false
	}
	for _, k := range keys {
		v, ok := m[k]
		if !ok || v == nil {
			continue
		}
		switch t := v.(type) {
		case bool:
			return t
		case string:
			return strings.EqualFold(t, "true") || t == "1"
		}
	}
	return false
}

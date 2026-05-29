package dodo

import (
	"strings"
	"testing"
)

const samplePaymentSucceeded = `{
    "business_id": "bus_P3SXLcppjXgagmHS",
    "data": {
        "checkout_session_id": "cks_stst1231",
        "currency": "USD",
        "customer": {
            "customer_id": "cus_8VbC6JDZzPEqfB",
            "email": "test@acme.com",
            "metadata": {}
        },
        "metadata": {},
        "payload_type": "Payment",
        "payment_id": "pay_2IjeQm4hqU6RA4Z4kwDee",
        "product_cart": [{"product_id": "pdt_e9mUw084cWnu0tz", "quantity": 1}],
        "status": "succeeded",
        "subscription_id": null,
        "total_amount": 400,
        "card_last_four": "4242"
    },
    "timestamp": "2025-08-04T05:30:45.182629Z",
    "type": "payment.succeeded"
}`

const sampleSubscriptionActive = `{
  "business_id": "bus_H4ekzPSlcg",
  "data": {
    "cancel_at_next_billing_date": false,
    "currency": "USD",
    "customer": {
      "customer_id": "cus_8VbC6JDZzPEqfBPUdpj0K",
      "email": "test@acme.com",
      "metadata": {}
    },
    "metadata": {},
    "next_billing_date": "2025-08-23T12:01:14.672875Z",
    "payload_type": "Subscription",
    "payment_frequency_interval": "Month",
    "previous_billing_date": "2025-07-23T12:01:21.506021Z",
    "product_id": "pdt_RUST4raxbl0Rfe4VQi1z",
    "recurring_pre_tax_amount": 1000,
    "status": "active",
    "subscription_id": "sub_7EeHq2ewQuadropD2ra"
  },
  "timestamp": "2025-08-04T05:45:31.736731Z",
  "type": "subscription.active"
}`

func TestSanitizeWebhookJSON_stripsCardPII(t *testing.T) {
	safe := SanitizeWebhookJSON(samplePaymentSucceeded)
	if strings.Contains(safe, "card_last_four") {
		t.Fatal("sanitized payload must not contain card fields")
	}
	if !strings.Contains(safe, "pay_2IjeQm4hqU6RA4Z4kwDee") {
		t.Fatal("expected payment_id in sanitized payload")
	}
	if !strings.Contains(safe, "cks_stst1231") {
		t.Fatal("expected checkout_session_id in sanitized payload")
	}
}

func TestParsePaymentFields(t *testing.T) {
	root := parseEvent(samplePaymentSucceeded)
	data := eventData(root)
	if got := paymentID(data); got != "pay_2IjeQm4hqU6RA4Z4kwDee" {
		t.Fatalf("payment_id: got %q", got)
	}
	if got := checkoutSessionID(data); got != "cks_stst1231" {
		t.Fatalf("checkout_session_id: got %q", got)
	}
	if got := productIDFromData(data); got != "pdt_e9mUw084cWnu0tz" {
		t.Fatalf("product_id: got %q", got)
	}
	if got := paymentAmountCents(data); got != 400 {
		t.Fatalf("amount: got %d", got)
	}
}

func TestParseSubscriptionFields(t *testing.T) {
	root := parseEvent(sampleSubscriptionActive)
	data := eventData(root)
	if got := subscriptionID(data); got != "sub_7EeHq2ewQuadropD2ra" {
		t.Fatalf("subscription_id: got %q", got)
	}
	if got := productIDFromData(data); got != "pdt_RUST4raxbl0Rfe4VQi1z" {
		t.Fatalf("product_id: got %q", got)
	}
	if got := periodEnd(data); got != "2025-08-23T12:01:14.672875Z" {
		t.Fatalf("period end: got %q", got)
	}
	if got := periodStart(data); got != "2025-07-23T12:01:21.506021Z" {
		t.Fatalf("period start: got %q", got)
	}
	if got := billingInterval(data, Config{}); got != "month" {
		t.Fatalf("interval: got %q", got)
	}
	if got := subscriptionStatus(data, "subscription.active"); got != "active" {
		t.Fatalf("status: got %q", got)
	}
	if got := recurringAmountCents(data); got != 1000 {
		t.Fatalf("amount: got %d", got)
	}
}

package dodo

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
)

type eventRoot map[string]interface{}

func parseEvent(raw string) eventRoot {
	var m eventRoot
	if raw == "" {
		return eventRoot{}
	}
	_ = json.Unmarshal([]byte(raw), &m)
	return m
}

func eventData(root eventRoot) map[string]interface{} {
	data := asMap(root, "data")
	if data == nil {
		return root
	}
	return data
}

func str(m map[string]interface{}, keys ...string) string {
	if m == nil {
		return ""
	}
	for _, k := range keys {
		if v, ok := m[k]; ok && v != nil {
			s := strings.TrimSpace(fmtAny(v))
			if s != "" && s != "null" {
				return s
			}
		}
	}
	return ""
}

func asMap(m map[string]interface{}, key string) map[string]interface{} {
	if m == nil {
		return nil
	}
	v, ok := m[key]
	if !ok || v == nil {
		return nil
	}
	sub, ok := v.(map[string]interface{})
	if !ok {
		return nil
	}
	return sub
}

func metadataUserID(root eventRoot) string {
	data := eventData(root)
	if uid := strFromMetadata(data); uid != "" {
		return uid
	}
	if cust := asMap(data, "customer"); cust != nil {
		if uid := strFromMetadata(cust); uid != "" {
			return uid
		}
	}
	return str(data, "user_id", "userId")
}

func strFromMetadata(m map[string]interface{}) string {
	meta := asMap(m, "metadata")
	if meta == nil {
		return ""
	}
	return str(meta, "user_id", "userId")
}

func subscriptionID(data map[string]interface{}) string {
	return str(data, "subscription_id", "subscriptionId")
}

func checkoutSessionID(data map[string]interface{}) string {
	return str(data, "checkout_session_id", "checkoutSessionId")
}

func customerID(data map[string]interface{}) string {
	if c := str(data, "customer_id", "customerId"); c != "" {
		return c
	}
	return str(asMap(data, "customer"), "customer_id", "customerId")
}

func productIDFromData(data map[string]interface{}) string {
	if pid := str(data, "product_id", "productId"); pid != "" {
		return pid
	}
	cart, ok := data["product_cart"].([]interface{})
	if !ok || len(cart) == 0 {
		return ""
	}
	first, ok := cart[0].(map[string]interface{})
	if !ok {
		return ""
	}
	return str(first, "product_id", "productId")
}

func paymentID(data map[string]interface{}) string {
	return str(data, "payment_id", "paymentId")
}

func periodEnd(data map[string]interface{}) string {
	if e := str(data, "expires_at", "expiresAt"); e != "" {
		return e
	}
	return str(data, "next_billing_date", "nextBillingDate", "current_period_end", "currentPeriodEnd")
}

func periodStart(data map[string]interface{}) string {
	if s := str(data, "previous_billing_date", "previousBillingDate"); s != "" {
		return s
	}
	return str(data, "current_period_start", "currentPeriodStart", "created_at", "createdAt")
}

func subscriptionStatus(data map[string]interface{}, eventType string) string {
	if st := strings.ToLower(str(data, "status")); st != "" {
		return st
	}
	return mapStatus(eventType)
}

func billingInterval(data map[string]interface{}, cfg Config) string {
	iv := str(data, "payment_frequency_interval", "paymentFrequencyInterval",
		"subscription_period_interval", "subscriptionPeriodInterval",
		"billing_interval", "billingInterval")
	if iv != "" {
		iv = strings.ToLower(iv)
		switch {
		case strings.Contains(iv, "year"):
			return "year"
		case strings.Contains(iv, "month"):
			return "month"
		}
	}
	pid := productIDFromData(data)
	if pid != "" && cfg.ProductYearly != "" && pid == cfg.ProductYearly {
		return "year"
	}
	if pid != "" && cfg.ProductMonthly != "" && pid == cfg.ProductMonthly {
		return "month"
	}
	return "unknown"
}

func amountCents(data map[string]interface{}, keys ...string) int64 {
	if data == nil {
		return 0
	}
	for _, k := range keys {
		v, ok := data[k]
		if !ok || v == nil {
			continue
		}
		switch t := v.(type) {
		case float64:
			return int64(t)
		case int:
			return int64(t)
		case int64:
			return t
		}
	}
	return 0
}

func paymentAmountCents(data map[string]interface{}) int64 {
	if a := amountCents(data, "total_amount", "totalAmount"); a > 0 {
		return a
	}
	return amountCents(data, "settlement_amount", "settlementAmount")
}

func recurringAmountCents(data map[string]interface{}) int64 {
	return amountCents(data, "recurring_pre_tax_amount", "recurringPreTaxAmount")
}

func cancelAtPeriodEnd(data map[string]interface{}) int {
	if boolField(data, "cancel_at_next_billing_date", "cancelAtNextBillingDate") {
		return 1
	}
	return 0
}

func mapStatus(eventType string) string {
	switch {
	case strings.Contains(eventType, "cancelled"):
		return "cancelled"
	case strings.Contains(eventType, "expired"):
		return "expired"
	case strings.Contains(eventType, "failed"):
		return "failed"
	case strings.Contains(eventType, "trialing"):
		return "trialing"
	case strings.Contains(eventType, "on_hold"):
		return "on_hold"
	case strings.Contains(eventType, "processing"):
		return "processing"
	default:
		return "active"
	}
}

func fmtAny(v interface{}) string {
	switch t := v.(type) {
	case string:
		return t
	case float64:
		if t == float64(int64(t)) {
			return strconv.FormatInt(int64(t), 10)
		}
		return fmt.Sprintf("%v", t)
	default:
		b, _ := json.Marshal(v)
		return strings.Trim(string(b), `"`)
	}
}

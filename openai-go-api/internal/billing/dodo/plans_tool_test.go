package dodo

import "testing"

func TestMergePlanOverrideToolWinsOnPrice(t *testing.T) {
	global := planOverride{
		productID:  "pdt_global",
		priceLabel: "$5.00",
		hasAmount:  true,
		priceAmount: 500,
		currency:   "USD",
		name:       "Monthly",
	}
	tool := planOverride{
		hasToolOverride: true,
		hasAmount:       true,
		priceAmount:     300,
		currency:        "USD",
		productID:       "pdt_tool",
	}
	merged := mergePlanOverride(global, tool)
	if merged.priceAmount != 300 {
		t.Fatalf("price = %d", merged.priceAmount)
	}
	if merged.productID != "pdt_tool" {
		t.Fatalf("product = %q", merged.productID)
	}
	if merged.name != "Monthly" {
		t.Fatalf("name should inherit global, got %q", merged.name)
	}
}

func TestMergePlanOverrideGlobalOnly(t *testing.T) {
	global := planOverride{priceLabel: "$5.00"}
	merged := mergePlanOverride(global, planOverride{})
	if merged.priceLabel != "$5.00" {
		t.Fatalf("got %q", merged.priceLabel)
	}
}

func TestNormalizeToolID(t *testing.T) {
	if normalizeToolID("  electronics/x  ") != "electronics/x" {
		t.Fatal("trim failed")
	}
}

func TestPricingScope(t *testing.T) {
	if pricingScope("", false) != "global" {
		t.Fatal("expected global")
	}
	if pricingScope("electronics/x", true) != "tool" {
		t.Fatal("expected tool")
	}
	if pricingScope("electronics/x", false) != "global" {
		t.Fatal("expected global fallback")
	}
}

#!/bin/bash

# Circuit AI Generation API Test Script
# Usage: ./test-circuit-api.sh [API_BASE] [API_KEY]
# Default: API_BASE=http://localhost:8787, API_KEY from .dev.vars

API_BASE="${1:-http://localhost:8787}"
if [ -f .dev.vars ]; then
  set -a
  source .dev.vars 2>/dev/null || true
  set +a
fi
API_KEY="${2:-$API_KEY}"

if [ -z "$API_KEY" ]; then
  echo "Error: API_KEY required. Set via .dev.vars or: API_KEY=xxx $0"
  exit 1
fi

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PASSED=0
FAILED=0

check() {
  local name="$1"
  local condition="$2"
  if [ "$condition" = "true" ]; then
    echo -e "  ${GREEN}✓ $name${NC}"
    ((PASSED++))
  else
    echo -e "  ${RED}✗ $name${NC}"
    ((FAILED++))
  fi
}

echo "========================================="
echo "Circuit AI Generation API Test Suite"
echo "========================================="
echo "API Base: $API_BASE"
echo ""

# ── Test 1: Simple LED circuit ──
echo -e "${YELLOW}1. Generate simple LED circuit${NC}"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"description": "Simple LED circuit with 220 ohm resistor and 5V battery"}' \
  "${API_BASE}/api/circuit-generate")
HTTP=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
check "HTTP 200" "$([ "$HTTP" = "200" ] && echo true || echo false)"
check "success: true" "$(echo "$BODY" | grep -q '"success":true' && echo true || echo false)"
check "has elements array" "$(echo "$BODY" | grep -q '"elements":\[' && echo true || echo false)"
check "has resistor" "$(echo "$BODY" | grep -q '"resistor"' && echo true || echo false)"
check "has led" "$(echo "$BODY" | grep -q '"led"' && echo true || echo false)"
check "has ground" "$(echo "$BODY" | grep -q '"ground"' && echo true || echo false)"
check "has dc-voltage" "$(echo "$BODY" | grep -q '"dc-voltage"' && echo true || echo false)"
ELEM_COUNT=$(echo "$BODY" | grep -o '"type"' | wc -l | tr -d ' ')
check "has ≥ 4 elements ($ELEM_COUNT)" "$([ "$ELEM_COUNT" -ge 4 ] && echo true || echo false)"
echo -e "  ${CYAN}Response time: $(echo "$BODY" | sed -E 's/.*"responseTimeMs":([0-9]+).*/\1/')ms${NC}"

# ── Test 2: Op-amp circuit ──
echo ""
echo -e "${YELLOW}2. Generate inverting op-amp amplifier${NC}"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"description": "Inverting op-amp amplifier with gain of -10, input resistor 1k, feedback resistor 10k"}' \
  "${API_BASE}/api/circuit-generate")
HTTP=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
check "HTTP 200" "$([ "$HTTP" = "200" ] && echo true || echo false)"
check "has opamp" "$(echo "$BODY" | grep -q '"opamp"' && echo true || echo false)"
check "has resistors" "$(echo "$BODY" | grep -q '"resistor"' && echo true || echo false)"
check "has ground" "$(echo "$BODY" | grep -q '"ground"' && echo true || echo false)"
echo -e "  ${CYAN}Name: $(echo "$BODY" | sed -E 's/.*"name":"([^"]+)".*/\1/' | head -1)${NC}"

# ── Test 3: BJT circuit ──
echo ""
echo -e "${YELLOW}3. Generate common emitter amplifier${NC}"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"description": "NPN common emitter amplifier with 10V supply and voltage divider bias"}' \
  "${API_BASE}/api/circuit-generate")
HTTP=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
check "HTTP 200" "$([ "$HTTP" = "200" ] && echo true || echo false)"
check "has bjt-npn" "$(echo "$BODY" | grep -q '"bjt-npn"' && echo true || echo false)"

# ── Test 4: Digital circuit ──
echo ""
echo -e "${YELLOW}4. Generate SR latch from NAND gates${NC}"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"description": "SR latch built from two cross-coupled NAND gates with set and reset inputs"}' \
  "${API_BASE}/api/circuit-generate")
HTTP=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
check "HTTP 200" "$([ "$HTTP" = "200" ] && echo true || echo false)"
check "has nand-gate" "$(echo "$BODY" | grep -q '"nand-gate"' && echo true || echo false)"

# ── Test 5: RLC circuit ──
echo ""
echo -e "${YELLOW}5. Generate RLC series resonance circuit${NC}"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"description": "RLC series resonance circuit with AC source, 100 ohm resistor, 10mH inductor, 10nF capacitor"}' \
  "${API_BASE}/api/circuit-generate")
HTTP=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
check "HTTP 200" "$([ "$HTTP" = "200" ] && echo true || echo false)"
check "has inductor" "$(echo "$BODY" | grep -q '"inductor"' && echo true || echo false)"
check "has capacitor" "$(echo "$BODY" | grep -q '"capacitor"' && echo true || echo false)"
check "has ac-voltage" "$(echo "$BODY" | grep -q '"ac-voltage"' && echo true || echo false)"

# ── Test 6: Validation - too short ──
echo ""
echo -e "${YELLOW}6. Reject too-short description${NC}"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"description": "hi"}' \
  "${API_BASE}/api/circuit-generate")
HTTP=$(echo "$RESP" | tail -1)
check "HTTP 400 (too short)" "$([ "$HTTP" = "400" ] && echo true || echo false)"

# ── Test 7: Validation - too long ──
echo ""
echo -e "${YELLOW}7. Reject too-long description${NC}"
LONG_DESC=$(python3 -c "print('x' * 501)")
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d "{\"description\": \"$LONG_DESC\"}" \
  "${API_BASE}/api/circuit-generate")
HTTP=$(echo "$RESP" | tail -1)
check "HTTP 400 (too long)" "$([ "$HTTP" = "400" ] && echo true || echo false)"

# ── Test 8: Auth - no API key ──
echo ""
echo -e "${YELLOW}8. Reject request without API key${NC}"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "Content-Type: application/json" \
  -d '{"description": "simple LED circuit"}' \
  "${API_BASE}/api/circuit-generate")
HTTP=$(echo "$RESP" | tail -1)
check "HTTP 401 (no API key)" "$([ "$HTTP" = "401" ] && echo true || echo false)"

# ── Test 9: Validate element structure ──
echo ""
echo -e "${YELLOW}9. Validate element structure (has x1, y1, x2, y2, type)${NC}"
RESP=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $API_KEY" \
  -d '{"description": "Voltage divider with two 1k resistors and 9V battery"}' \
  "${API_BASE}/api/circuit-generate")
check "has x1 field" "$(echo "$RESP" | grep -q '"x1"' && echo true || echo false)"
check "has y1 field" "$(echo "$RESP" | grep -q '"y1"' && echo true || echo false)"
check "has x2 field" "$(echo "$RESP" | grep -q '"x2"' && echo true || echo false)"
check "has y2 field" "$(echo "$RESP" | grep -q '"y2"' && echo true || echo false)"
check "has type field" "$(echo "$RESP" | grep -q '"type"' && echo true || echo false)"

# ── Test 10: Response has name and description ──
echo ""
echo -e "${YELLOW}10. Response includes name and description${NC}"
check "has name" "$(echo "$RESP" | grep -q '"name"' && echo true || echo false)"
check "has description" "$(echo "$RESP" | grep -q '"description"' && echo true || echo false)"
check "has responseTimeMs" "$(echo "$RESP" | grep -q '"responseTimeMs"' && echo true || echo false)"

# ── Summary ──
echo ""
echo "========================================="
echo "Test Summary"
echo "========================================="
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo "Total: $((PASSED + FAILED))"

if [ $FAILED -eq 0 ]; then
  echo -e "\n${GREEN}All tests passed! ✓${NC}"
  exit 0
else
  echo -e "\n${RED}Some tests failed.${NC}"
  exit 1
fi

#!/bin/bash

# Documents API Test Script
# Usage: ./test-documents-api.sh [API_BASE] [API_KEY]
# Default: API_BASE=http://localhost:8787, API_KEY from .dev.vars or env

API_BASE="${1:-http://localhost:8787}"
# Load API_KEY from .dev.vars if present
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
NC='\033[0m'

PASSED=0
FAILED=0

run_curl() {
  local method="$1"
  local url="$2"
  local extra_args="$3"
  curl -s -w '\n%{http_code}' -X "$method" \
    -H "X-API-Key: $API_KEY" \
    -H "Content-Type: application/json" \
    $extra_args "$url"
}

test_pass() {
  local name="$1"
  local status="$2"
  local body="$3"
  if [ "$status" -ge 200 ] && [ "$status" -lt 300 ]; then
    echo -e "  ${GREEN}✓ $name${NC} (HTTP $status)"
    ((PASSED++))
    return 0
  else
    echo -e "  ${RED}✗ $name${NC} (HTTP $status)"
    echo "$body" | head -3 | sed 's/^/    /'
    ((FAILED++))
    return 1
  fi
}

echo "========================================="
echo "Documents API Test Suite"
echo "========================================="
echo "API Base: $API_BASE"
echo ""

# 1. POST /api/documents - Create
echo -e "${YELLOW}1. Create document (anonymous)${NC}"
CREATE_BODY='{"doc_type":"math","title":"Test Worksheet","content":"<p>Hello</p>","content_type":"text/html","visibility":"private"}'
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d "$CREATE_BODY" \
  "${API_BASE}/api/documents")
HTTP_STATUS=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
test_pass "Create document" "$HTTP_STATUS" "$BODY"

DOC_ID=$(echo "$BODY" | sed -E 's/.*"id":"([^"]+)".*/\1/')
EDIT_TOKEN=$(echo "$BODY" | sed -E 's/.*"edit_token":"([^"]+)".*/\1/')

if [ -z "$DOC_ID" ] || [ "$DOC_ID" = "$BODY" ]; then
  echo -e "  ${RED}Cannot extract doc id - skipping further tests${NC}"
  echo "  Response: $BODY"
  ((FAILED++))
else
  echo "  Created doc id: $DOC_ID"

  # 2. GET /api/documents/:id (pass edit_token for private anonymous doc)
  echo ""
  echo -e "${YELLOW}2. Get document${NC}"
  if [ -n "$EDIT_TOKEN" ] && [ "$EDIT_TOKEN" != "$BODY" ]; then
    RESP=$(curl -s -w '\n%{http_code}' -X GET \
      -H "X-API-Key: $API_KEY" \
      -H "X-Edit-Token: $EDIT_TOKEN" \
      "${API_BASE}/api/documents/${DOC_ID}")
  else
    RESP=$(run_curl GET "${API_BASE}/api/documents/${DOC_ID}" "")
  fi
  HTTP_STATUS=$(echo "$RESP" | tail -1)
  BODY=$(echo "$RESP" | sed '$d')
  test_pass "Get document" "$HTTP_STATUS" "$BODY"

  # 3. PUT /api/documents/:id (with edit_token)
  if [ -n "$EDIT_TOKEN" ] && [ "$EDIT_TOKEN" != "$BODY" ]; then
    echo ""
    echo -e "${YELLOW}3. Update document (edit_token)${NC}"
    UPDATE_BODY='{"title":"Updated Title","content":"<p>Updated</p>","visibility":"private"}'
    RESP=$(curl -s -w '\n%{http_code}' -X PUT \
      -H "X-API-Key: $API_KEY" \
      -H "X-Edit-Token: $EDIT_TOKEN" \
      -H "Content-Type: application/json" \
      -d "$UPDATE_BODY" \
      "${API_BASE}/api/documents/${DOC_ID}")
    HTTP_STATUS=$(echo "$RESP" | tail -1)
    BODY=$(echo "$RESP" | sed '$d')
    test_pass "Update document" "$HTTP_STATUS" "$BODY"
  fi

  # 4. GET /api/documents (list) — anonymous gets public docs only
  echo ""
  echo -e "${YELLOW}4. List documents (anonymous → public only)${NC}"
  RESP=$(run_curl GET "${API_BASE}/api/documents?limit=5" "")
  HTTP_STATUS=$(echo "$RESP" | tail -1)
  BODY=$(echo "$RESP" | sed '$d')
  test_pass "List documents" "$HTTP_STATUS" "$BODY"

  # 4b. List public recent (sort=created_at) — for landing page
  echo ""
  echo -e "${YELLOW}4b. List public recent (sort=created_at, for landing)${NC}"
  RESP=$(run_curl GET "${API_BASE}/api/documents?limit=8&sort=created_at" "")
  HTTP_STATUS=$(echo "$RESP" | tail -1)
  BODY=$(echo "$RESP" | sed '$d')
  test_pass "List public recent" "$HTTP_STATUS" "$BODY"

  # 5. DELETE /api/documents/:id
  echo ""
  echo -e "${YELLOW}5. Delete document (edit_token)${NC}"
  if [ -n "$EDIT_TOKEN" ] && [ "$EDIT_TOKEN" != "$BODY" ]; then
    RESP=$(curl -s -w '\n%{http_code}' -X DELETE \
      -H "X-API-Key: $API_KEY" \
      -H "X-Edit-Token: $EDIT_TOKEN" \
      "${API_BASE}/api/documents/${DOC_ID}")
  else
    RESP=$(run_curl DELETE "${API_BASE}/api/documents/${DOC_ID}" "")
  fi
  HTTP_STATUS=$(echo "$RESP" | tail -1)
  BODY=$(echo "$RESP" | sed '$d')
  test_pass "Delete document" "$HTTP_STATUS" "$BODY"

  # 6. GET /api/documents/:id (should 404)
  echo ""
  echo -e "${YELLOW}6. Get deleted document (expect 404)${NC}"
  RESP=$(run_curl GET "${API_BASE}/api/documents/${DOC_ID}" "")
  HTTP_STATUS=$(echo "$RESP" | tail -1)
  if [ "$HTTP_STATUS" = "404" ]; then
    echo -e "  ${GREEN}✓ Correctly returns 404${NC}"
    ((PASSED++))
  else
    echo -e "  ${RED}✗ Expected 404, got $HTTP_STATUS${NC}"
    ((FAILED++))
  fi
fi

# 7. Create with user_id
echo ""
echo -e "${YELLOW}7. Create document with user_id${NC}"
USER_ID="test-user-$(date +%s)"
CREATE_USER_BODY="{\"doc_type\":\"math\",\"title\":\"User Doc\",\"content\":\"<p>Hi</p>\",\"content_type\":\"text/html\",\"visibility\":\"private\",\"user_id\":\"$USER_ID\"}"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "X-API-Key: $API_KEY" \
  -H "X-User-Id: $USER_ID" \
  -H "Content-Type: application/json" \
  -d "$CREATE_USER_BODY" \
  "${API_BASE}/api/documents")
HTTP_STATUS=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
test_pass "Create with user_id" "$HTTP_STATUS" "$BODY"

# 8. Claim flow: anonymous doc → login → save claims it
echo ""
echo -e "${YELLOW}8. Claim flow (anonymous → save with user_id claims doc)${NC}"
CLAIM_USER_ID="claim-user-$(date +%s)"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"doc_type":"math","title":"Anonymous Doc","content":"<p>Will be claimed</p>","content_type":"text/html","visibility":"private"}' \
  "${API_BASE}/api/documents")
HTTP_STATUS=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
if [ "$HTTP_STATUS" -lt 200 ] || [ "$HTTP_STATUS" -ge 300 ]; then
  echo -e "  ${RED}✗ Create for claim failed (HTTP $HTTP_STATUS)${NC}"
  ((FAILED++))
else
  CLAIM_DOC_ID=$(echo "$BODY" | sed -E 's/.*"id":"([^"]+)".*/\1/')
  CLAIM_EDIT_TOKEN=$(echo "$BODY" | sed -E 's/.*"edit_token":"([^"]+)".*/\1/')
  if [ -z "$CLAIM_DOC_ID" ] || [ "$CLAIM_DOC_ID" = "$BODY" ] || [ -z "$CLAIM_EDIT_TOKEN" ] || [ "$CLAIM_EDIT_TOKEN" = "$BODY" ]; then
    echo -e "  ${RED}✗ Cannot extract id/token for claim test${NC}"
    ((FAILED++))
  else
    # Update with edit_token + X-User-Id → claim
    RESP=$(curl -s -w '\n%{http_code}' -X PUT \
      -H "X-API-Key: $API_KEY" \
      -H "X-Edit-Token: $CLAIM_EDIT_TOKEN" \
      -H "X-User-Id: $CLAIM_USER_ID" \
      -H "Content-Type: application/json" \
      -d '{"title":"Claimed Doc","content":"<p>Now owned</p>","visibility":"private"}' \
      "${API_BASE}/api/documents/${CLAIM_DOC_ID}")
    HTTP_STATUS=$(echo "$RESP" | tail -1)
    BODY=$(echo "$RESP" | sed '$d')
    if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
      # Verify user_id in response
      if echo "$BODY" | grep -q "\"user_id\":\"$CLAIM_USER_ID\""; then
        echo -e "  ${GREEN}✓ Claim succeeded, user_id set${NC}"
        ((PASSED++))
      else
        echo -e "  ${RED}✗ Claim response missing user_id${NC}"
        echo "  Response: $BODY"
        ((FAILED++))
      fi
      # Verify doc appears in user's list
      RESP=$(curl -s -w '\n%{http_code}' -X GET \
        -H "X-API-Key: $API_KEY" \
        -H "X-User-Id: $CLAIM_USER_ID" \
        "${API_BASE}/api/documents?user_id=${CLAIM_USER_ID}&limit=10")
      HTTP_STATUS=$(echo "$RESP" | tail -1)
      LIST_BODY=$(echo "$RESP" | sed '$d')
      if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ] && echo "$LIST_BODY" | grep -q "\"id\":\"$CLAIM_DOC_ID\""; then
        echo -e "  ${GREEN}✓ Claimed doc appears in user list${NC}"
        ((PASSED++))
      else
        echo -e "  ${RED}✗ Claimed doc not in user list${NC}"
        ((FAILED++))
      fi
    else
      echo -e "  ${RED}✗ Claim update failed (HTTP $HTTP_STATUS)${NC}"
      ((FAILED++))
    fi
    # Cleanup
    curl -s -X DELETE -H "X-API-Key: $API_KEY" -H "X-User-Id: $CLAIM_USER_ID" "${API_BASE}/api/documents/${CLAIM_DOC_ID}" >/dev/null 2>&1 || true
  fi
fi

# 9. Missing API key (expect 401)
echo ""
echo -e "${YELLOW}9. Reject request without API key${NC}"
RESP=$(curl -s -w '\n%{http_code}' -X GET "${API_BASE}/api/documents" -H "Content-Type: application/json")
HTTP_STATUS=$(echo "$RESP" | tail -1)
if [ "$HTTP_STATUS" = "401" ]; then
  echo -e "  ${GREEN}✓ Correctly returns 401${NC}"
  ((PASSED++))
else
  echo -e "  ${RED}✗ Expected 401, got $HTTP_STATUS${NC}"
  ((FAILED++))
fi

# 10. Owned doc: create with user_id, no edit_token, delete as owner
echo ""
echo -e "${YELLOW}10. Owned doc (create with user_id, delete as owner)${NC}"
NO_XFER_USER="owner-$(date +%s)"
RESP=$(curl -s -w '\n%{http_code}' -X POST \
  -H "X-API-Key: $API_KEY" \
  -H "X-User-Id: $NO_XFER_USER" \
  -H "Content-Type: application/json" \
  -d "{\"doc_type\":\"math\",\"title\":\"Owned Doc\",\"content\":\"<p>Owned</p>\",\"content_type\":\"text/html\",\"visibility\":\"private\"}" \
  "${API_BASE}/api/documents")
HTTP_STATUS=$(echo "$RESP" | tail -1)
BODY=$(echo "$RESP" | sed '$d')
if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
  OWNED_DOC_ID=$(echo "$BODY" | sed -E 's/.*"id":"([^"]+)".*/\1/')
  # Owned docs don't get edit_token
  if echo "$BODY" | grep -q "edit_token"; then
    echo -e "  ${RED}✗ Owned doc should not have edit_token${NC}"
    ((FAILED++))
  elif [ -n "$OWNED_DOC_ID" ] && [ "$OWNED_DOC_ID" != "$BODY" ]; then
    echo -e "  ${GREEN}✓ Owned doc created (no edit_token)${NC}"
    ((PASSED++))
    # Delete as owner
    RESP=$(curl -s -w '\n%{http_code}' -X DELETE \
      -H "X-API-Key: $API_KEY" \
      -H "X-User-Id: $NO_XFER_USER" \
      "${API_BASE}/api/documents/${OWNED_DOC_ID}")
    DS=$(echo "$RESP" | tail -1)
    if [ "$DS" = "200" ]; then
      echo -e "  ${GREEN}✓ Delete as owner works${NC}"
      ((PASSED++))
    else
      echo -e "  ${RED}✗ Delete as owner failed (HTTP $DS)${NC}"
      ((FAILED++))
    fi
  else
    echo -e "  ${RED}✗ Cannot extract owned doc id${NC}"
    ((FAILED++))
  fi
else
  echo -e "  ${RED}✗ Create owned doc failed${NC}"
  ((FAILED++))
fi

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

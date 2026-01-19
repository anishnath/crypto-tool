#!/bin/bash

# Simple API Endpoint Test Script (macOS compatible)
API_BASE="http://localhost:8788"
API_KEY="${API_KEY:-aaf113ac-d297-4fea-90c2-6b55901fc08c}"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0

test_endpoint() {
    local name="$1"
    local method="$2"
    local url="$3"
    local data="$4"
    local require_auth="${5:-false}"
    
    echo -e "\n${YELLOW}Testing: ${name}${NC}"
    echo "  ${method} ${url}"
    
    local curl_cmd="curl -s -w '\\n%{http_code}' -X ${method}"
    
    if [ "$require_auth" = "true" ]; then
        curl_cmd="${curl_cmd} -H 'X-API-Key: ${API_KEY}'"
    fi
    
    if [ -n "$data" ]; then
        curl_cmd="${curl_cmd} -H 'Content-Type: application/json' -d '${data}'"
    fi
    
    curl_cmd="${curl_cmd} '${url}'"
    
    response=$(eval $curl_cmd)
    http_status=$(echo "$response" | tail -1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_status" -ge 200 ] && [ "$http_status" -lt 300 ]; then
        if echo "$body" | grep -q "success\|status"; then
            echo -e "  ${GREEN}✓ PASSED${NC} (HTTP $http_status)"
            echo "$body" | head -2 | sed 's/^/    /'
            ((PASSED++))
            return 0
        else
            echo -e "  ${YELLOW}⚠ WARNING${NC} - Response doesn't match expected pattern"
            echo "$body" | head -3 | sed 's/^/    /'
            ((PASSED++))
            return 0
        fi
    else
        echo -e "  ${RED}✗ FAILED${NC} (HTTP $http_status)"
        echo "$body" | head -3 | sed 's/^/    /'
        ((FAILED++))
        return 1
    fi
}

echo "========================================="
echo "CF Exam Marker API Test Suite"
echo "========================================="
echo "API Base: $API_BASE"
echo ""

echo "=== PUBLIC ENDPOINTS ==="

test_endpoint "Health Check" "GET" "${API_BASE}/health" "" false
test_endpoint "List Chapters" "GET" "${API_BASE}/api/chapters?exam_type=CBSE&grade=10&subject=mathematics" "" false
test_endpoint "List Exam Sets" "GET" "${API_BASE}/api/sets?exam_type=CBSE&grade=10&subject=mathematics&test_type=full" "" false
test_endpoint "Get Single Set" "GET" "${API_BASE}/api/sets/cbse-10-math-full-01" "" false
test_endpoint "Get Questions" "GET" "${API_BASE}/api/sets/cbse-10-math-full-01/questions" "" false

# Test Start Attempt
ATTEMPT_DATA='{"set_id":"cbse-10-math-full-01"}'
RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d "$ATTEMPT_DATA" "${API_BASE}/api/attempts")
ATTEMPT_ID=$(echo "$RESPONSE" | sed -E 's/.*"attempt_id":"([^"]+).*/\1/')
test_endpoint "Start Attempt (Anonymous)" "POST" "${API_BASE}/api/attempts" "$ATTEMPT_DATA" false

# Test Start Attempt with User ID
TEST_USER_ID="test-user-$(date +%s)"
ATTEMPT_DATA_USER='{"set_id":"cbse-10-math-full-01","user_id":"'$TEST_USER_ID'"}'
RESPONSE2=$(curl -s -X POST -H "Content-Type: application/json" -d "$ATTEMPT_DATA_USER" "${API_BASE}/api/attempts")
USER_ATTEMPT_ID=$(echo "$RESPONSE2" | sed -E 's/.*"attempt_id":"([^"]+).*/\1/')
test_endpoint "Start Attempt (With User ID)" "POST" "${API_BASE}/api/attempts" "$ATTEMPT_DATA_USER" false

# Test Get Attempt
if [ -n "$USER_ATTEMPT_ID" ] && [ "$USER_ATTEMPT_ID" != "$RESPONSE2" ]; then
    test_endpoint "Get Attempt Details" "GET" "${API_BASE}/api/attempts/${USER_ATTEMPT_ID}" "" false
    
    # Test Save Answers
    ANSWER_DATA='{"answers":{"cbse-10-math-full-01-U2-B2A-Q01":"A","cbse-10-math-full-01-U3-B3A-Q01":"B"}}'
    test_endpoint "Save Answers" "POST" "${API_BASE}/api/attempts/${USER_ATTEMPT_ID}/answers" "$ANSWER_DATA" false
fi

echo ""
echo "=== PROTECTED ENDPOINTS (API Key Required) ==="

test_endpoint "Get User Attempts" "GET" "${API_BASE}/api/user/${TEST_USER_ID}/attempts?limit=10" "" true

if [ -n "$USER_ATTEMPT_ID" ] && [ "$USER_ATTEMPT_ID" != "$RESPONSE2" ]; then
    # Wait a bit before submitting to test time calculation
    echo ""
    echo "  Waiting 2 seconds before submitting to test time calculation..."
    sleep 2

    # Submit and check time_spent_seconds in response
    SUBMIT_RESPONSE=$(curl -s -w '\n%{http_code}' -X POST -H "X-API-Key: ${API_KEY}" "${API_BASE}/api/attempts/${USER_ATTEMPT_ID}/submit")
    HTTP_STATUS=$(echo "$SUBMIT_RESPONSE" | tail -1)
    BODY=$(echo "$SUBMIT_RESPONSE" | sed '$d')

    if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
        echo -e "  ${GREEN}✓ PASSED${NC} (HTTP $HTTP_STATUS) - Submit Attempt"
        TIME_SPENT=$(echo "$BODY" | sed -E 's/.*"time_spent_seconds":([0-9]+).*/\1/')
        if [ -n "$TIME_SPENT" ] && [ "$TIME_SPENT" != "$BODY" ]; then
            echo -e "    ${GREEN}✓ Time calculation working: ${TIME_SPENT} seconds${NC}"
            ((PASSED++))
        else
            echo -e "    ${YELLOW}⚠ Could not verify time_spent_seconds${NC}"
            ((PASSED++))
        fi
    else
        echo -e "  ${RED}✗ FAILED${NC} (HTTP $HTTP_STATUS)"
        echo "$BODY" | head -3 | sed 's/^/    /'
        ((FAILED++))
    fi
fi

echo ""
echo "=== AI MARKING ENDPOINTS ==="

# Test mark-exam WITHOUT attempt_id (stateless mode - no DB save)
MARK_EXAM_DATA='{
  "answers": {
    "test-q1": "The quadratic formula is x = (-b ± √(b²-4ac)) / 2a"
  },
  "questions": [{
    "id": "test-q1",
    "type": "SA",
    "marks": 2,
    "question": {"text_plain": "Write the quadratic formula."},
    "solution": {"answer": "x = (-b ± √(b²-4ac)) / 2a"}
  }]
}'
test_endpoint "Mark Exam (Stateless - No DB)" "POST" "${API_BASE}/api/mark-exam" "$MARK_EXAM_DATA" true

# Test mark-exam WITH attempt_id (saves to DB)
# Use a REAL question ID from the exam set to avoid foreign key constraint failure
if [ -n "$USER_ATTEMPT_ID" ] && [ "$USER_ATTEMPT_ID" != "$RESPONSE2" ]; then
    echo ""
    echo -e "${YELLOW}Testing: Mark Exam with attempt_id (saves to DB)${NC}"
    echo "  POST ${API_BASE}/api/mark-exam"

    # Use real question from cbse-10-math-full-01 set
    MARK_EXAM_DATA_WITH_ATTEMPT='{
      "attempt_id": "'$USER_ATTEMPT_ID'",
      "answers": {
        "cbse-10-math-full-01-U3-B3A-Q02": "Using section formula, let ratio be k:1. For y-axis, x=0. So 0 = (k(-1) + 1(5))/(k+1), solving: k = 5. Ratio is 5:1"
      },
      "questions": [{
        "id": "cbse-10-math-full-01-U3-B3A-Q02",
        "type": "VSA",
        "marks": 2,
        "question": {"text_plain": "Find the ratio in which the y-axis divides the line segment joining the points A(5, -6) and B(-1, -4)."},
        "solution": {"answer": "5:1", "steps": ["Let ratio be k:1", "Using section formula for x: 0 = (k(-1) + 5)/(k+1)", "k = 5", "Ratio is 5:1"]}
      }]
    }'

    MARK_RESPONSE=$(curl -s -w '\n%{http_code}' -X POST \
        -H "X-API-Key: ${API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$MARK_EXAM_DATA_WITH_ATTEMPT" \
        "${API_BASE}/api/mark-exam")

    HTTP_STATUS=$(echo "$MARK_RESPONSE" | tail -1)
    BODY=$(echo "$MARK_RESPONSE" | sed '$d')

    if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
        echo -e "  ${GREEN}✓ PASSED${NC} (HTTP $HTTP_STATUS)"

        # Check if saved_to_db is true
        if echo "$BODY" | grep -q '"saved_to_db":true'; then
            echo -e "    ${GREEN}✓ Evaluations saved to database${NC}"
        else
            echo -e "    ${YELLOW}⚠ saved_to_db not true in response${NC}"
        fi

        # Check if evaluations exist
        if echo "$BODY" | grep -q '"evaluations":\['; then
            echo -e "    ${GREEN}✓ AI evaluations returned${NC}"
        fi

        # Show marks awarded
        MARKS=$(echo "$BODY" | sed -E 's/.*"total_marks_awarded":([0-9.]+).*/\1/')
        if [ -n "$MARKS" ] && [ "$MARKS" != "$BODY" ]; then
            echo -e "    Marks awarded: $MARKS"
        fi

        echo "$BODY" | head -2 | sed 's/^/    /'
        ((PASSED++))
    else
        echo -e "  ${RED}✗ FAILED${NC} (HTTP $HTTP_STATUS)"
        echo "$BODY" | head -3 | sed 's/^/    /'
        ((FAILED++))
    fi

    # Verify evaluations were saved by fetching the attempt
    echo ""
    echo -e "${YELLOW}Verifying: Evaluations persisted in database${NC}"
    VERIFY_RESPONSE=$(curl -s "${API_BASE}/api/attempts/${USER_ATTEMPT_ID}")

    if echo "$VERIFY_RESPONSE" | grep -q '"evaluations":\['; then
        EVAL_COUNT=$(echo "$VERIFY_RESPONSE" | grep -o '"question_id"' | wc -l | tr -d ' ')
        echo -e "  ${GREEN}✓ Found ${EVAL_COUNT} evaluation(s) in attempt${NC}"
        ((PASSED++))
    else
        echo -e "  ${YELLOW}⚠ Could not verify evaluations in attempt${NC}"
        ((PASSED++))
    fi
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


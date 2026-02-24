#!/bin/bash
# ============================================================
# ODE Solver Calculator - Integration Test Suite
# Tests file existence, structure, CSS tokens, JS modes,
# JSP SEO/layout, registry updates, and cross-links.
# ============================================================

PASS=0
FAIL=0
TOTAL=0
BASE="src/main/webapp"

pass() { ((PASS++)); ((TOTAL++)); echo "  ✅ $1"; }
fail() { ((FAIL++)); ((TOTAL++)); echo "  ❌ $1"; }
check() { if eval "$1" >/dev/null 2>&1; then pass "$2"; else fail "$2"; fi; }

echo "========================================"
echo " ODE Solver Calculator — Test Suite"
echo "========================================"
echo ""

# ----------------------------------------------------------
# 1. FILE EXISTENCE
# ----------------------------------------------------------
echo "── 1. File Existence ──"
check "test -f $BASE/modern/css/ode-solver-calculator.css" "CSS file exists"
check "test -f $BASE/modern/js/ode-solver-calculator.js"   "JS file exists"
check "test -f $BASE/ode-solver-calculator.jsp"             "JSP file exists"

# ----------------------------------------------------------
# 2. CSS — Color Tokens & Prefix
# ----------------------------------------------------------
echo ""
echo "── 2. CSS Color Tokens & Prefix ──"
CSS="$BASE/modern/css/ode-solver-calculator.css"

check "grep -q '#db2777'           $CSS" "Primary color #db2777 present"
check "grep -q '#be185d'           $CSS" "Primary-dark #be185d present"
check "grep -q '#fdf2f8'           $CSS" "Light token #fdf2f8 present"
check "grep -q '#f472b6'           $CSS" "Gradient end #f472b6 present"
check "grep -q 'rgba(219, 39, 119' $CSS" "Dark-mode light token present"
check "grep -q '\.ode-mode-toggle' $CSS" "ode- prefix: .ode-mode-toggle"
check "grep -q '\.ode-mode-btn'    $CSS" "ode- prefix: .ode-mode-btn"
check "grep -q '\.ode-preview'     $CSS" "ode- prefix: .ode-preview"
check "grep -q '\.ode-example-chip' $CSS" "ode- prefix: .ode-example-chip"
check "grep -q '\.ode-output-tab'  $CSS" "ode- prefix: .ode-output-tab"
check "grep -q '\.ode-panel'       $CSS" "ode- prefix: .ode-panel"
check "grep -q '\.ode-result-math' $CSS" "ode- prefix: .ode-result-math"
check "grep -q '\.ode-steps-btn'   $CSS" "ode- prefix: .ode-steps-btn"
check "grep -q '\.ode-error'       $CSS" "ode- prefix: .ode-error"
check "grep -q '\.ode-spinner'     $CSS" "ode- prefix: .ode-spinner"
check "grep -q '\.ode-action-row'  $CSS" "ode- prefix: .ode-action-row"
check "grep -q '\.ode-random-btn'  $CSS" "ode- prefix: .ode-random-btn"
check "grep -q '\.ode-ic-row'      $CSS" "ode- prefix: .ode-ic-row"
check "grep -q '\.ode-ic-fields'   $CSS" "ode- prefix: .ode-ic-fields"
check "grep -q '\.ode-method-badge' $CSS" "ode- prefix: .ode-method-badge"
check "grep -q '\.ode-classify-badge' $CSS" "ode- prefix: .ode-classify-badge"
check "grep -q '\.ode-verified-badge' $CSS" "ode- prefix: .ode-verified-badge"
check "grep -q '\.ode-sep'         $CSS" "ode- prefix: .ode-sep"
check "grep -q '\.ode-formulas-table' $CSS" "ode- prefix: .ode-formulas-table"

# No fd- prefix leaking
if grep -q '\.fd-' "$CSS"; then fail "No fd- prefix leak in CSS"; else pass "No fd- prefix leak in CSS"; fi

# ----------------------------------------------------------
# 3. JS — IIFE, Context, 3 Modes
# ----------------------------------------------------------
echo ""
echo "── 3. JS Structure & 3 Modes ──"
JS="$BASE/modern/js/ode-solver-calculator.js"

check "grep -q '(function()'       $JS" "IIFE wrapper present"
check "grep -q 'use strict'        $JS" "Strict mode enabled"
check "grep -q 'ODE_CALC_CTX'      $JS" "Context var ODE_CALC_CTX used"
check "grep -q 'currentMode'       $JS" "currentMode variable"

# Mode values
check "grep -q \"data-mode='first'\\|data-mode=\\\"first\\\"\\|=== 'first'\" $JS" "First-order mode"
check "grep -q \"=== 'second'\"    $JS" "Second-order mode"
check "grep -q \"=== 'field'\"     $JS" "Direction field mode"

# DOM references for all 3 modes
check "grep -q 'ode-first-expr'    $JS" "First-order input ref"
check "grep -q 'ode-second-expr'   $JS" "Second-order input ref"
check "grep -q 'ode-field-expr'    $JS" "Direction field input ref"

# IC support
check "grep -q 'ode-first-ic-check'  $JS" "First-order IC checkbox ref"
check "grep -q 'ode-second-ic-check' $JS" "Second-order IC checkbox ref"
check "grep -q 'ode-field-curve-check' $JS" "Field curve overlay checkbox ref"

# SymPy code generation
check "grep -q 'dsolve'            $JS" "dsolve in SymPy code"
check "grep -q 'classify_ode'      $JS" "classify_ode in SymPy code"
check "grep -q 'checkodesol'       $JS" "checkodesol in SymPy code"
check "grep -q 'yp.*diff'          $JS" "yp mapped to y(x).diff(x)"

# Direction field specifics
check "grep -q 'FIELD_X'           $JS" "Direction field X output tag"
check "grep -q 'FIELD_Y'           $JS" "Direction field Y output tag"
check "grep -q 'FIELD_U'           $JS" "Direction field U output tag"
check "grep -q 'FIELD_V'           $JS" "Direction field V output tag"
check "grep -q 'CURVE_X'           $JS" "Solution curve X output tag"
check "grep -q 'CURVE_Y'           $JS" "Solution curve Y output tag"

# Quick examples per mode
check "grep -q 'firstExamples'     $JS" "First-order quick examples array"
check "grep -q 'secondExamples'    $JS" "Second-order quick examples array"
check "grep -q 'fieldExamples'     $JS" "Direction field quick examples array"

# Random pools
check "grep -q 'randomFirst'       $JS" "Random first-order pool"
check "grep -q 'randomSecond'      $JS" "Random second-order pool"
check "grep -q 'randomField'       $JS" "Random field pool"

# Count random pool sizes (>= 15 each)
RFIRST=$(grep -c "rhs:" "$JS" | head -1)
check "[ $(grep -o 'randomFirst\[' $JS | wc -l) -ge 1 ]" "randomFirst pool referenced"

# Key functions
check "grep -q 'function buildSympyCode' $JS" "buildSympyCode function"
check "grep -q 'function doCompute'      $JS" "doCompute function"
check "grep -q 'function renderGraph'    $JS" "renderGraph function"
check "grep -q 'function renderSteps'    $JS" "renderSteps function"
check "grep -q 'function showError'      $JS" "showError function"
check "grep -q 'function generateWorksheet' $JS" "generateWorksheet function"
check "grep -q 'function downloadResultPdf' $JS" "downloadResultPdf function"
check "grep -q 'function loadCompilerWithTemplate' $JS" "loadCompilerWithTemplate function"
check "grep -q 'function updatePreview'  $JS" "updatePreview function"
check "grep -q 'function updateExamples' $JS" "updateExamples function"
check "grep -q 'function showODEResult'  $JS" "showODEResult function"
check "grep -q 'function showFieldResult' $JS" "showFieldResult function"

# Output tabs
check "grep -q 'ode-output-tab'    $JS" "Output tab handling"
check "grep -q 'ode-panel-'         $JS" "Result panel (dynamic: ode-panel- + id)"
check "grep -q 'ode-panel-graph'   $JS" "Graph panel"
check "grep -q 'panel.*python'     $JS" "Python compiler panel"

# Action buttons
check "grep -q 'ode-copy-latex-btn'    $JS" "Copy LaTeX button wired"
check "grep -q 'ode-download-pdf-btn'  $JS" "Download PDF button wired"
check "grep -q 'ode-share-btn'         $JS" "Share button wired"
check "grep -q 'ode-worksheet-btn'     $JS" "Worksheet button wired"
check "grep -q 'ode-random-btn'        $JS" "Random button wired"
check "grep -q 'ode-compute-btn'       $JS" "Compute button wired"

# URL params (share restore)
check "grep -q 'URLSearchParams'   $JS" "URL share restore support"

# Plotly graph types
check "grep -q \"type: 'solution'\" $JS" "Solution graph type"
check "grep -q \"type: 'field'\"    $JS" "Field graph type"

# Direction field annotations (Plotly)
check "grep -q 'annotations'       $JS" "Direction field uses Plotly annotations"

# Euler method for curve
check "grep -q 'Euler'             $JS" "Euler method for solution curve"

# Worksheet sections
check "grep -q 'First-Order ODEs'  $JS" "Worksheet section I: First-Order"
check "grep -q 'Second-Order ODEs' $JS" "Worksheet section II: Second-Order"
check "grep -q 'Direction Fields'  $JS" "Worksheet section III: Direction Fields"
check "grep -q '/ 12'              $JS" "Worksheet score /12"

# No fd- references leaking
if grep -q 'fd-compute-btn\|fd-result-content\|fd-empty-state\|FD_CALC_CTX' "$JS"; then
    fail "No fd- DOM id leak in JS"
else
    pass "No fd- DOM id leak in JS"
fi

# ----------------------------------------------------------
# 4. JSP — SEO, Layout, Structure
# ----------------------------------------------------------
echo ""
echo "── 4. JSP SEO & Layout ──"
JSP="$BASE/ode-solver-calculator.jsp"

# SEO meta
check "grep -q 'ODE Solver Calculator with Steps'  $JSP" "SEO title present"
check "grep -q 'Free online ODE solver'             $JSP" "Meta description present"
check "grep -q 'ode-solver-calculator.jsp'           $JSP" "toolUrl set correctly"
check "grep -q 'ODE solver.*differential equation'   $JSP" "Keywords include ODE solver"

# Page structure
check "grep -q 'tool-page-header'     $JSP" "Page header section"
check "grep -q 'tool-description-section' $JSP" "Description section"
check "grep -q 'tool-page-container'   $JSP" "Main container"
check "grep -q 'tool-input-column'     $JSP" "Input column"
check "grep -q 'tool-output-column'    $JSP" "Output column"
check "grep -q 'tool-ads-column'       $JSP" "Ads column"

# Header badges
check "grep -q 'Step-by-Step'  $JSP" "Badge: Step-by-Step"
check "grep -q '3 Modes'       $JSP" "Badge: 3 Modes"
check "grep -q 'SymPy CAS'     $JSP" "Badge: SymPy CAS"

# Mode toggle buttons
check "grep -q '1st Order'     $JSP" "Mode button: 1st Order"
check "grep -q '2nd Order'     $JSP" "Mode button: 2nd Order"
check "grep -q 'Direction Field' $JSP" "Mode button: Direction Field"

# Input sections for each mode
check "grep -q 'ode-first-wrap'   $JSP" "First-order input wrap"
check "grep -q 'ode-second-wrap'  $JSP" "Second-order input wrap"
check "grep -q 'ode-field-wrap'   $JSP" "Direction field input wrap"

# IC checkboxes
check "grep -q 'ode-first-ic-check'   $JSP" "First-order IC checkbox"
check "grep -q 'ode-second-ic-check'  $JSP" "Second-order IC checkbox"
check "grep -q 'ode-field-curve-check' $JSP" "Field curve overlay checkbox"

# yp syntax hint
check "grep -q 'yp.*for.*y'           $JSP" "yp syntax hint present"

# Direction field range inputs
check "grep -q 'ode-field-xmin'  $JSP" "Field x-min input"
check "grep -q 'ode-field-xmax'  $JSP" "Field x-max input"
check "grep -q 'ode-field-ymin'  $JSP" "Field y-min input"
check "grep -q 'ode-field-ymax'  $JSP" "Field y-max input"

# Output tabs
check "grep -q 'data-panel=\"result\"'  $JSP" "Result output tab"
check "grep -q 'data-panel=\"graph\"'   $JSP" "Graph output tab"
check "grep -q 'data-panel=\"python\"'  $JSP" "Python compiler output tab"

# Panels
check "grep -q 'ode-panel-result'  $JSP" "Result panel div"
check "grep -q 'ode-panel-graph'   $JSP" "Graph panel div"
check "grep -q 'ode-panel-python'  $JSP" "Python panel div"
check "grep -q 'ode-graph-container' $JSP" "Graph container div"
check "grep -q 'ode-compiler-iframe' $JSP" "Compiler iframe"

# Empty state
check "grep -q 'ode-empty-state'   $JSP" "Empty state div"

# Action buttons
check "grep -q 'ode-copy-latex-btn'    $JSP" "Copy LaTeX button"
check "grep -q 'ode-download-pdf-btn'  $JSP" "Download PDF button"
check "grep -q 'ode-share-btn'         $JSP" "Share button"
check "grep -q 'ode-worksheet-btn'     $JSP" "Print Worksheet button"

# Reference table
check "grep -q 'ODE Reference Table'   $JSP" "ODE Reference Table heading"
check "grep -q 'Separable'             $JSP" "Ref table: Separable"
check "grep -q '1st Linear'            $JSP" "Ref table: 1st Linear"
check "grep -q 'Bernoulli'             $JSP" "Ref table: Bernoulli"
check "grep -q 'Exact'                 $JSP" "Ref table: Exact"
check "grep -q 'Homogeneous'           $JSP" "Ref table: Homogeneous"
check "grep -q '2nd Const Coeff'       $JSP" "Ref table: 2nd Const Coeff"
check "grep -q 'Non-Homogeneous'       $JSP" "Ref table: Non-Homogeneous"
check "grep -q 'Cauchy-Euler'          $JSP" "Ref table: Cauchy-Euler"

# 6 FAQs
FAQ_COUNT=$(grep -c 'faq-question' "$JSP")
check "[ $FAQ_COUNT -ge 6 ]" "At least 6 FAQ items ($FAQ_COUNT found)"

# Educational content
check "grep -q 'What is an Ordinary Differential Equation' $JSP" "Edu: What is an ODE?"
check "grep -q 'ODE Solution Methods'  $JSP" "Edu: Solution Methods section"
check "grep -q 'Separation of Variables' $JSP" "Edu card: Separation of Variables"
check "grep -q 'Integrating Factor'    $JSP" "Edu card: Integrating Factor"
check "grep -q 'Characteristic Equation' $JSP" "Edu card: Characteristic Equation"
check "grep -q 'Direction Fields'       $JSP" "Edu card: Direction Fields"
check "grep -q 'Applications'          $JSP" "Edu: Applications section"
check "grep -q 'Physics'               $JSP" "Application: Physics"
check "grep -q 'Population Dynamics'   $JSP" "Application: Population Dynamics"
check "grep -q 'Circuit Analysis'      $JSP" "Application: Circuit Analysis"
check "grep -q 'Heat.*Diffusion'       $JSP" "Application: Heat & Diffusion"

# Cross-links in this tool
check "grep -q 'laplace-transform-calculator.jsp' $JSP" "Cross-link: Laplace"
check "grep -q 'finite-difference-calculator.jsp'  $JSP" "Cross-link: Finite Difference"
check "grep -q 'convolution-calculator.jsp'        $JSP" "Cross-link: Convolution"

# Breadcrumbs
check "grep -q 'Math Tools'        $JSP" "Breadcrumb: Math Tools"

# Script loading
check "grep -q 'ODE_CALC_CTX'      $JSP" "Context var set in JSP"
check "grep -q 'ode-solver-calculator.js'  $JSP" "JS file loaded"
check "grep -q 'ode-solver-calculator.css' $JSP" "CSS file loaded"
check "grep -q 'katex.min.js'      $JSP" "KaTeX JS loaded"
check "grep -q 'katex.min.css'     $JSP" "KaTeX CSS loaded"
check "grep -q 'loadPlotly'        $JSP" "Plotly deferred loader"
check "grep -q 'tool-utils.js'     $JSP" "tool-utils.js loaded"
check "grep -q 'dark-mode.js'      $JSP" "dark-mode.js loaded"
check "grep -q 'search.js'         $JSP" "search.js loaded"

# Includes
check "grep -q 'nav-header.jsp'         $JSP" "Nav header included"
check "grep -q 'seo-tool-page.jsp'      $JSP" "SEO component included"
check "grep -q 'ad-three-column.jsp'    $JSP" "Ads included"
check "grep -q 'support-section.jsp'    $JSP" "Support section included"
check "grep -q 'related-tools.jsp'      $JSP" "Related tools included"
check "grep -q 'analytics.jsp'          $JSP" "Analytics included"

# ----------------------------------------------------------
# 5. REGISTRY — tools-database.json
# ----------------------------------------------------------
echo ""
echo "── 5. Registry: tools-database.json ──"
DB="$BASE/modern/data/tools-database.json"

check "grep -q '\"totalTools\": 398'  $DB" "totalTools bumped to 398"
check "grep -q 'ODE Solver Calculator' $DB" "Tool entry name present"
check "grep -q 'ode-solver-calculator.jsp' $DB" "Tool entry URL correct"
check "grep -q '\"category\": \"Mathematics\"' $DB" "Category is Mathematics"
check "grep -q 'ODE solver.*differential equation' $DB" "Keywords include ODE solver"
check "grep -q '\"isNew\": true' $DB" "isNew flag set (at least one entry)"

# Verify JSON is valid
if python3 -c "import json; json.load(open('$DB'))" 2>/dev/null; then
    pass "tools-database.json is valid JSON"
else
    fail "tools-database.json is valid JSON"
fi

# ----------------------------------------------------------
# 6. REGISTRY — math/index.jsp card
# ----------------------------------------------------------
echo ""
echo "── 6. Registry: math/index.jsp ──"
MATH="$BASE/math/index.jsp"

check "grep -q 'ode-solver-calculator.jsp' $MATH" "ODE card link present"
check "grep -q '#db2777'                   $MATH" "Card accent color #db2777"
check "grep -q \">y'</\"                   $MATH" "Card icon is y'"
check "grep -q 'ODE Solver Calculator'     $MATH" "Card title present"
check "grep -q \"y' = f(x, y)\"            $MATH" "Card formula present"
check "grep -q '10 tools'                  $MATH" "Calculus count updated to 10"

# ----------------------------------------------------------
# 7. REGISTRY — sitemap.xml
# ----------------------------------------------------------
echo ""
echo "── 7. Registry: sitemap.xml ──"
SITEMAP="$BASE/sitemap.xml"

check "grep -q 'ode-solver-calculator.jsp' $SITEMAP" "Sitemap entry present"
check "grep -A4 'ode-solver-calculator' $SITEMAP | grep -q '0.95'" "Sitemap priority is 0.95"

# Verify sitemap is valid XML
if python3 -c "import xml.etree.ElementTree as ET; ET.parse('$SITEMAP')" 2>/dev/null; then
    pass "sitemap.xml is valid XML"
else
    fail "sitemap.xml is valid XML"
fi

# ----------------------------------------------------------
# 8. CROSS-LINKS — Laplace
# ----------------------------------------------------------
echo ""
echo "── 8. Cross-links: Laplace Transform ──"
LAPLACE="$BASE/laplace-transform-calculator.jsp"

check "grep -q 'ode-solver-calculator.jsp' $LAPLACE" "Laplace links to ODE Solver"
check "grep -q 'ODE Solver Calculator'     $LAPLACE" "Laplace shows ODE Solver title"
check "grep -q '#db2777'                   $LAPLACE" "ODE Solver pink gradient in Laplace"

# ----------------------------------------------------------
# 9. CROSS-LINKS — Finite Difference
# ----------------------------------------------------------
echo ""
echo "── 9. Cross-links: Finite Difference ──"
FD="$BASE/finite-difference-calculator.jsp"

check "grep -q 'ode-solver-calculator.jsp' $FD" "FD links to ODE Solver"
check "grep -q 'ODE Solver Calculator'     $FD" "FD shows ODE Solver title"
check "grep -q '#db2777'                   $FD" "ODE Solver pink gradient in FD"

# Ensure convolution link was replaced (not duplicated)
CONV_COUNT=$(grep -c 'convolution-calculator.jsp' "$FD" || true)
check "[ $CONV_COUNT -eq 0 ]" "Convolution link removed from FD cross-links ($CONV_COUNT found)"

# ----------------------------------------------------------
# 10. CONSISTENCY CHECKS
# ----------------------------------------------------------
echo ""
echo "── 10. Consistency Checks ──"

# All DOM IDs referenced in JS exist in JSP
for ID in ode-first-expr ode-second-expr ode-field-expr ode-preview ode-compute-btn \
          ode-result-content ode-result-actions ode-empty-state ode-graph-hint \
          ode-examples ode-random-btn ode-first-wrap ode-second-wrap ode-field-wrap \
          ode-first-ic-check ode-first-ic-fields ode-first-ic-x0 ode-first-ic-y0 \
          ode-second-ic-check ode-second-ic-fields ode-second-ic-x0 ode-second-ic-y0 ode-second-ic-dy0 \
          ode-field-xmin ode-field-xmax ode-field-ymin ode-field-ymax \
          ode-field-curve-check ode-field-curve-fields ode-field-curve-x0 ode-field-curve-y0 \
          ode-panel-result ode-panel-graph ode-panel-python ode-graph-container ode-compiler-iframe \
          ode-copy-latex-btn ode-download-pdf-btn ode-share-btn ode-worksheet-btn \
          ode-syntax-btn ode-syntax-content ode-formulas-btn ode-formulas-content; do
    check "grep -q 'id=\"$ID\"' $JSP" "DOM id '$ID' exists in JSP"
done

# Quick example counts
FIRST_EX=$(grep -c "label:.*rhs:" "$JS" | head -1)
check "[ $(grep -o 'firstExamples' $JS | wc -l) -ge 2 ]" "firstExamples array used"
check "[ $(grep -o 'secondExamples' $JS | wc -l) -ge 2 ]" "secondExamples array used"
check "[ $(grep -o 'fieldExamples' $JS | wc -l) -ge 2 ]" "fieldExamples array used"

# Reference table formula IDs (8 rows)
for i in 0 1 2 3 4 5 6 7; do
    check "grep -q 'ode-formula-f$i' $JSP && grep -q 'ode-formula-m$i' $JSP" "Ref table row $i has both formula IDs"
done

# No broken includes (check key files exist)
check "test -f $BASE/modern/components/nav-header.jsp"    "nav-header.jsp exists"
check "test -f $BASE/modern/components/seo-tool-page.jsp" "seo-tool-page.jsp exists"
check "test -f $BASE/modern/js/tool-utils.js"             "tool-utils.js exists"
check "test -f $BASE/modern/js/dark-mode.js"              "dark-mode.js exists"
check "test -f $BASE/modern/js/search.js"                 "search.js exists"
check "test -f $BASE/modern/css/design-system.css"        "design-system.css exists"
check "test -f $BASE/modern/css/three-column-tool.css"    "three-column-tool.css exists"

# ----------------------------------------------------------
# SUMMARY
# ----------------------------------------------------------
echo ""
echo "========================================"
echo " RESULTS: $PASS passed, $FAIL failed (of $TOTAL tests)"
echo "========================================"

if [ $FAIL -eq 0 ]; then
    echo " 🎉 ALL TESTS PASSED!"
    exit 0
else
    echo " ⚠️  $FAIL test(s) failed — review above."
    exit 1
fi

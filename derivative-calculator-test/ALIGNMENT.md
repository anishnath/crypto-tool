# Derivative Calculator Test Alignment

The test suite executes the **actual JSP JavaScript** shared with the integral calculator:

- **`integral-calculator-core.js`**: Provides `normalizeExpr` used by both integral and derivative calculators.
- **`derivative-calculator-core.js`**: Thin wrapper that exposes `normalizeExpr` from IntegralCalculatorCore.

## Test/JSP Alignment

| Logic | JSP Source | Test Source | Same? |
|-------|------------|-------------|-------|
| normalizeExpr | integral-calculator-core.js | require-core.js loads integral-calculator-core.js | ✓ |
| diff(expr, v) | nerdamer | nerdamer | ✓ |
| Order 1–5 | derivative-calculator.jsp loop | diff(expr, v, order) | ✓ |

## Running Tests

```bash
cd derivative-calculator-test
npm install
npm test
```

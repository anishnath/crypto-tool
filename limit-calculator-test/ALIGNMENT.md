# Limit Calculator Test Alignment

The test suite uses the **actual JSP logic** for normalization:

- **`integral-calculator-core.js`**: Provides `normalizeExpr` (sin3x → sin(3*x)).
- **`limit-calculator-core.js`**: Thin wrapper exposing `normalizeExpr` from IntegralCalculatorCore.

Limits are tested via nerdamer's `limit(expr, var, point)`.

## Running Tests

```bash
cd limit-calculator-test
npm install
npm test
```

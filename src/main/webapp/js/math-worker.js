/**
 * Web Worker for safe mathematical expression evaluation
 * Prevents blocking the main thread and provides sandboxed evaluation
 */

// Mathematical function library
const mathFunctions = {
  sin: Math.sin,
  cos: Math.cos,
  tan: Math.tan,
  asin: Math.asin,
  acos: Math.acos,
  atan: Math.atan,
  sinh: Math.sinh,
  cosh: Math.cosh,
  tanh: Math.tanh,
  log: Math.log,
  log10: Math.log10,
  log2: Math.log2,
  exp: Math.exp,
  sqrt: Math.sqrt,
  cbrt: Math.cbrt,
  abs: Math.abs,
  ceil: Math.ceil,
  floor: Math.floor,
  round: Math.round,
  min: Math.min,
  max: Math.max,
  random: Math.random,
  pi: Math.PI,
  e: Math.E,
  inf: Infinity,
  nan: NaN
};

// Safe expression parser and evaluator
class SafeExpressionEvaluator {
  constructor() {
    this.allowedTokens = new Set([
      // Numbers
      'number',
      // Variables
      'x', 'y', 'a', 'b', 'c', 'k', 'pi', 'e',
      // Operators
      '+', '-', '*', '/', '^', '**', '(', ')',
      // Functions
      'sin', 'cos', 'tan', 'asin', 'acos', 'atan',
      'sinh', 'cosh', 'tanh', 'log', 'log10', 'log2',
      'exp', 'sqrt', 'cbrt', 'abs', 'ceil', 'floor',
      'round', 'min', 'max'
    ]);
  }
  
  tokenize(expression) {
    const tokens = [];
    let current = '';
    
    for (let i = 0; i < expression.length; i++) {
      const char = expression[i];
      
      if (this.isDigit(char) || char === '.') {
        current += char;
      } else if (this.isLetter(char)) {
        current += char;
      } else if (char === ' ') {
        if (current) {
          tokens.push(current);
          current = '';
        }
      } else {
        if (current) {
          tokens.push(current);
          current = '';
        }
        tokens.push(char);
      }
    }
    
    if (current) {
      tokens.push(current);
    }
    
    return tokens;
  }
  
  isDigit(char) {
    return /[0-9]/.test(char);
  }
  
  isLetter(char) {
    return /[a-zA-Z_]/.test(char);
  }
  
  isNumber(token) {
    return !isNaN(parseFloat(token)) && isFinite(parseFloat(token));
  }
  
  validateTokens(tokens) {
    for (const token of tokens) {
      if (!this.allowedTokens.has(token) && !this.isNumber(token)) {
        throw new Error(`Disallowed token: ${token}`);
      }
    }
    return true;
  }
  
  evaluate(expression, variables = {}) {
    try {
      // Clean the expression
      let expr = expression.trim();
      
      // Remove 'y = ' prefix if present
      expr = expr.replace(/^\s*y\s*=\s*/i, '');
      
      // Replace variables
      Object.keys(variables).forEach(varName => {
        const regex = new RegExp(`\\b${varName}\\b`, 'g');
        expr = expr.replace(regex, variables[varName]);
      });
      
      // Tokenize and validate
      const tokens = this.tokenize(expr);
      this.validateTokens(tokens);
      
      // Convert to safe evaluation string
      let safeExpr = expr
        .replace(/\^/g, '**')
        .replace(/pi\b/g, 'Math.PI')
        .replace(/e\b/g, 'Math.E')
        .replace(/sin\(/g, 'Math.sin(')
        .replace(/cos\(/g, 'Math.cos(')
        .replace(/tan\(/g, 'Math.tan(')
        .replace(/asin\(/g, 'Math.asin(')
        .replace(/acos\(/g, 'Math.acos(')
        .replace(/atan\(/g, 'Math.atan(')
        .replace(/sinh\(/g, 'Math.sinh(')
        .replace(/cosh\(/g, 'Math.cosh(')
        .replace(/tanh\(/g, 'Math.tanh(')
        .replace(/log\(/g, 'Math.log(')
        .replace(/log10\(/g, 'Math.log10(')
        .replace(/log2\(/g, 'Math.log2(')
        .replace(/exp\(/g, 'Math.exp(')
        .replace(/sqrt\(/g, 'Math.sqrt(')
        .replace(/cbrt\(/g, 'Math.cbrt(')
        .replace(/abs\(/g, 'Math.abs(')
        .replace(/ceil\(/g, 'Math.ceil(')
        .replace(/floor\(/g, 'Math.floor(')
        .replace(/round\(/g, 'Math.round(');
      
      // Evaluate safely
      const result = Function('"use strict"; return (' + safeExpr + ')')();
      
      if (typeof result === 'number' && isFinite(result)) {
        return result;
      } else if (typeof result === 'number' && !isFinite(result)) {
        return result; // Infinity or -Infinity
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
  
  // Batch evaluation for performance
  evaluateBatch(expression, xValues, variables = {}) {
    const results = [];
    const evaluator = new SafeExpressionEvaluator();
    
    for (const x of xValues) {
      const result = evaluator.evaluate(expression, { ...variables, x });
      results.push(result);
    }
    
    return results;
  }
}

// Worker message handler
const evaluator = new SafeExpressionEvaluator();

self.onmessage = function(e) {
  const { type, id, expression, xValues, variables } = e.data;
  
  try {
    switch (type) {
      case 'evaluate':
        const result = evaluator.evaluate(expression, variables);
        self.postMessage({ type: 'result', id, result });
        break;
        
      case 'evaluateBatch':
        const results = evaluator.evaluateBatch(expression, xValues, variables);
        self.postMessage({ type: 'batchResult', id, results });
        break;
        
      case 'validate':
        const isValid = evaluator.validateTokens(evaluator.tokenize(expression));
        self.postMessage({ type: 'validation', id, isValid });
        break;
        
      default:
        self.postMessage({ type: 'error', id, error: 'Unknown message type' });
    }
  } catch (error) {
    self.postMessage({ type: 'error', id, error: error.message });
  }
};

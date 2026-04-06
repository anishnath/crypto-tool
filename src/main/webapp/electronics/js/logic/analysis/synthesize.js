/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Expression Parser & Circuit Generator
   Parse "A·B + ¬C" → generate gate circuit automatically.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  /* ── Tokenizer ── */
  function tokenize(expr) {
    const tokens = [];
    let i = 0;
    while (i < expr.length) {
      const ch = expr[i];
      if (/\s/.test(ch)) { i++; continue; }
      if (ch === '(') { tokens.push({ type: 'LPAREN' }); i++; }
      else if (ch === ')') { tokens.push({ type: 'RPAREN' }); i++; }
      else if (ch === '+' || ch === '|') { tokens.push({ type: 'OR' }); i++; }
      else if (ch === '\u00B7' || ch === '&' || ch === '*' || ch === '.') { tokens.push({ type: 'AND' }); i++; }
      else if (ch === '\u00AC' || ch === '!' || ch === '~') { tokens.push({ type: 'NOT' }); i++; }
      else if (ch === "'" && tokens.length && tokens[tokens.length - 1].type === 'VAR') {
        // Postfix NOT: A' means NOT A
        const varTok = tokens.pop();
        tokens.push({ type: 'NOT_POST', name: varTok.name });
        i++;
      }
      else if (/[A-Za-z]/.test(ch)) {
        // Each uppercase letter is a separate variable (enables implicit AND: "AB" → A·B)
        // Multi-char names must use underscore or digits: A0, Cin, etc.
        if (/[A-Z]/.test(ch) && (i + 1 >= expr.length || !/[a-z0-9_]/.test(expr[i + 1]))) {
          tokens.push({ type: 'VAR', name: ch });
          i++;
        } else {
          let name = '';
          while (i < expr.length && /[A-Za-z0-9_]/.test(expr[i])) name += expr[i++];
          tokens.push({ type: 'VAR', name: name.toUpperCase() });
        }
      }
      else if (ch === '0') { tokens.push({ type: 'CONST', value: 0 }); i++; }
      else if (ch === '1') { tokens.push({ type: 'CONST', value: 1 }); i++; }
      else { i++; } // skip unknown
    }

    // Insert implicit AND between adjacent terms: VAR VAR, ) VAR, VAR (, ) (
    const result = [];
    for (let j = 0; j < tokens.length; j++) {
      if (j > 0) {
        const prev = tokens[j - 1].type;
        const cur  = tokens[j].type;
        const needsAnd =
          (prev === 'VAR' || prev === 'RPAREN' || prev === 'NOT_POST' || prev === 'CONST') &&
          (cur === 'VAR' || cur === 'LPAREN' || cur === 'NOT' || cur === 'CONST');
        if (needsAnd) result.push({ type: 'AND' });
      }
      result.push(tokens[j]);
    }
    return result;
  }

  /* ── Recursive descent parser ── */
  // Precedence: OR < AND < NOT
  // Grammar:
  //   expr    → orExpr
  //   orExpr  → andExpr ('+' andExpr)*
  //   andExpr → notExpr ('·' notExpr)*
  //   notExpr → '¬' notExpr | primary ("'")?
  //   primary → VAR | CONST | '(' expr ')'

  function parse(tokens) {
    let pos = 0;

    function peek() { return pos < tokens.length ? tokens[pos] : null; }
    function eat(type) {
      const t = peek();
      if (t && t.type === type) { pos++; return t; }
      return null;
    }

    function orExpr() {
      let node = andExpr();
      while (peek() && peek().type === 'OR') {
        eat('OR');
        const right = andExpr();
        node = { type: 'or', children: [node, right] };
      }
      return node;
    }

    function andExpr() {
      let node = notExpr();
      while (peek() && peek().type === 'AND') {
        eat('AND');
        const right = notExpr();
        node = { type: 'and', children: [node, right] };
      }
      return node;
    }

    function notExpr() {
      if (peek() && peek().type === 'NOT') {
        eat('NOT');
        const child = notExpr();
        return { type: 'not', children: [child] };
      }
      return primary();
    }

    function primary() {
      const t = peek();
      if (!t) return { type: 'const', value: 0 };

      if (t.type === 'NOT_POST') {
        pos++;
        return { type: 'not', children: [{ type: 'var', name: t.name }] };
      }
      if (t.type === 'VAR') { pos++; return { type: 'var', name: t.name }; }
      if (t.type === 'CONST') { pos++; return { type: 'const', value: t.value }; }
      if (t.type === 'LPAREN') {
        eat('LPAREN');
        const node = orExpr();
        eat('RPAREN');
        return node;
      }
      pos++; // skip unexpected
      return { type: 'const', value: 0 };
    }

    const ast = orExpr();
    return ast;
  }

  /* ── AST → String (canonical) ── */
  function astToString(node) {
    if (!node) return '0';
    if (node.type === 'var') return node.name;
    if (node.type === 'const') return String(node.value);
    if (node.type === 'not') return '\u00AC' + _wrapIfComplex(node.children[0]);
    if (node.type === 'and') return node.children.map(c => _wrapIfOr(c)).join('\u00B7');
    if (node.type === 'or') return node.children.map(c => astToString(c)).join(' + ');
    return '?';
  }
  function _wrapIfComplex(n) {
    if (n.type === 'or' || n.type === 'and') return '(' + astToString(n) + ')';
    return astToString(n);
  }
  function _wrapIfOr(n) {
    if (n.type === 'or') return '(' + astToString(n) + ')';
    return astToString(n);
  }

  /* ── Collect variable names from AST ── */
  function collectVars(node) {
    const vars = new Set();
    function walk(n) {
      if (!n) return;
      if (n.type === 'var') vars.add(n.name);
      if (n.children) n.children.forEach(walk);
    }
    walk(node);
    return [...vars].sort();
  }

  /* ── AST → Circuit ── */
  function synthesize(circuit, exprStr, startX, startY) {
    const tokens = tokenize(exprStr);
    if (tokens.length === 0) return null;
    const ast = parse(tokens);
    const vars = collectVars(ast);

    // Create input pins for each variable
    const inputMap = new Map(); // varName → component
    vars.forEach((name, i) => {
      const pin = circuit.addComponent(L.PIN_TYPES.INPUT,
        startX - 160, startY + i * 56, { label: name, state: L.FALSE });
      inputMap.set(name, pin);
    });

    // Recursively generate gates
    let gateX = startX;
    let gateY = startY;

    function genNode(node) {
      if (node.type === 'var') {
        return { comp: inputMap.get(node.name), portIdx: 0 };
      }
      if (node.type === 'const') {
        const c = circuit.addComponent(L.WIRING_TYPES.CONSTANT,
          gateX, gateY, { value: node.value ? L.TRUE : L.FALSE });
        gateY += 48;
        return { comp: c, portIdx: 0 };
      }
      if (node.type === 'not') {
        const child = genNode(node.children[0]);
        const gate = circuit.addComponent(L.GATE_TYPES.NOT, gateX, gateY);
        gateX += 80;
        circuit.addWire(child.comp.id, child.portIdx, gate.id, 0);
        return { comp: gate, portIdx: 1 }; // NOT output is port 1
      }
      if (node.type === 'and' || node.type === 'or') {
        const gateType = node.type === 'and' ? L.GATE_TYPES.AND : L.GATE_TYPES.OR;
        const childResults = node.children.map(c => genNode(c));

        // Chain 2-input gates for >2 children (flatten)
        let result = childResults[0];
        for (let i = 1; i < childResults.length; i++) {
          const gate = circuit.addComponent(gateType, gateX, gateY);
          gateX += 80; gateY += 32;
          circuit.addWire(result.comp.id, result.portIdx, gate.id, 0);
          circuit.addWire(childResults[i].comp.id, childResults[i].portIdx, gate.id, 1);
          result = { comp: gate, portIdx: 2 }; // 2-input gate output is port 2
        }
        return result;
      }
      return { comp: null, portIdx: 0 };
    }

    const output = genNode(ast);

    // Add output pin
    if (output.comp) {
      const outPin = circuit.addComponent(L.PIN_TYPES.OUTPUT,
        gateX + 80, startY + (vars.length - 1) * 28, { label: 'Q' });
      circuit.addWire(output.comp.id, output.portIdx, outPin.id, 0);
    }

    return { ast, vars, expr: astToString(ast) };
  }

  /* ── Exports ── */
  L.ExprParser = { tokenize, parse, astToString, collectVars };
  L.synthesize = synthesize;
})(window.LogicSim);

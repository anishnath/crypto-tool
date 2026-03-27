/**
 * Circuit Graph — Node numbering, wire merging, analysis, solve
 *
 * This is the main entry point for the circuit simulator.
 * It manages elements, assigns node numbers, builds the MNA matrix,
 * solves, and distributes results.
 */

import { MNA } from './mna.js';

export class Circuit {
  constructor() {
    this.elements = [];     // all CircuitElements
    this.nodeCount = 0;     // total nodes (including ground = node 0)
    this.vsCount = 0;       // total voltage source count
    this.mna = null;        // MNA matrix
    this.nodeVoltages = []; // solved node voltages
    this.isNonLinear = false;
    this.time = 0;
    this.timeStep = 5e-6;   // default 5 μs

    // Node data: nodeLinks[nodeNum] = [{elm, termIndex}, ...]
    this.nodeLinks = [];
  }

  /** Add an element to the circuit */
  addElement(elm) {
    this.elements.push(elm);
    // Save raw (grid-based) node IDs — analyze() overwrites elm.nodes with sequential IDs
    elm._rawNodes = elm.nodes.slice();
  }

  /** Remove an element */
  removeElement(elm) {
    const idx = this.elements.indexOf(elm);
    if (idx >= 0) this.elements.splice(idx, 1);
  }

  /** Clear all elements */
  clear() {
    this.elements = [];
    this.mna = null;
  }

  // ─── Analysis: build node list and matrix ───

  /**
   * Analyze the circuit: number nodes, merge wires, allocate matrix, stamp.
   * Call this whenever the circuit topology changes.
   */
  analyze() {
    // Restore raw (grid-based) node IDs — previous analyze() overwrote them with sequential IDs
    for (const elm of this.elements) {
      if (elm._rawNodes) {
        for (let i = 0; i < elm._rawNodes.length; i++) elm.nodes[i] = elm._rawNodes[i];
      }
    }

    // Step 1: Merge wire-connected nodes using Union-Find
    const nodeMap = this._mergeWires();

    // Step 2: Assign sequential node numbers
    // nodeMap maps raw node IDs to canonical IDs. Now map canonicals to sequential.
    const canonicals = [...new Set(Object.values(nodeMap))];

    // Ensure ground (node 0) exists — find it from ground elements or first voltage source
    let groundCanonical = null;
    for (const elm of this.elements) {
      if (elm.type === 'ground') {
        groundCanonical = nodeMap[elm.nodes[0]] ?? elm.nodes[0];
        break;
      }
    }
    if (groundCanonical === null) {
      // Use first voltage source's negative terminal
      for (const elm of this.elements) {
        if (elm.getVoltageSourceCount() > 0) {
          groundCanonical = nodeMap[elm.nodes[0]] ?? elm.nodes[0];
          break;
        }
      }
    }
    if (groundCanonical === null && canonicals.length > 0) {
      groundCanonical = canonicals[0];  // fallback: first node is ground
    }

    // Map: canonical → sequential node number (ground = 0)
    const seqMap = new Map();
    seqMap.set(groundCanonical, 0);
    let nextNode = 1;
    for (const c of canonicals) {
      if (!seqMap.has(c)) seqMap.set(c, nextNode++);
    }
    this.nodeCount = nextNode;

    // Step 3: Assign node numbers to elements
    for (const elm of this.elements) {
      if (elm.type === 'wire' || elm.type === 'ground') continue;
      for (let i = 0; i < elm.nodes.length; i++) {
        const canon = nodeMap[elm.nodes[i]] ?? elm.nodes[i];
        elm.nodes[i] = seqMap.get(canon) ?? 0;
      }
    }

    // Step 4: Count voltage sources, assign indices
    this.vsCount = 0;
    this.isNonLinear = false;
    for (const elm of this.elements) {
      if (elm.type === 'wire' || elm.type === 'ground') continue;
      const vs = elm.getVoltageSourceCount();
      if (vs > 0) {
        elm.voltSource = this.vsCount;
        this.vsCount += vs;
      }
      if (elm.isNonLinear()) this.isNonLinear = true;
    }

    // Step 5: Build node links (for distributing solved voltages)
    this.nodeLinks = [];
    for (let i = 0; i < this.nodeCount; i++) this.nodeLinks[i] = [];
    for (const elm of this.elements) {
      if (elm.type === 'wire' || elm.type === 'ground') continue;
      for (let i = 0; i < elm.getPostCount(); i++) {
        const n = elm.nodes[i];
        if (n >= 0 && n < this.nodeCount) {
          this.nodeLinks[n].push({ elm, termIndex: i });
        }
      }
    }

    // Step 6: Allocate and stamp MNA matrix
    this.mna = new MNA(this.nodeCount, this.vsCount);
    this._stampAll();
    if (!this.isNonLinear) this.mna.saveOriginal();

    // Step 7: Initial solve
    this.nodeVoltages = new Float64Array(this.nodeCount);
    this._solve();
  }

  /** Union-Find wire merging. Returns map: rawNode → canonical rawNode */
  _mergeWires() {
    // Collect all raw node IDs
    const allNodes = new Set();
    for (const elm of this.elements) {
      for (const n of elm.nodes) allNodes.add(n);
    }

    // Union-Find parent
    const parent = {};
    for (const n of allNodes) parent[n] = n;

    function find(x) {
      while (parent[x] !== x) { parent[x] = parent[parent[x]]; x = parent[x]; }
      return x;
    }
    function union(a, b) {
      const ra = find(a), rb = find(b);
      if (ra !== rb) parent[rb] = ra;
    }

    // Merge nodes connected by wires
    for (const elm of this.elements) {
      if (elm.type === 'wire') union(elm.nodes[0], elm.nodes[1]);
    }
    // Ground elements: merge their node with a special ground marker
    for (const elm of this.elements) {
      if (elm.type === 'ground') union(elm.nodes[0], elm.nodes[0]); // no-op but ensures it exists
    }

    // Build final map
    const nodeMap = {};
    for (const n of allNodes) nodeMap[n] = find(n);
    return nodeMap;
  }

  /** Stamp all elements into the MNA matrix */
  _stampAll() {
    this.mna.clear();
    for (const elm of this.elements) {
      if (elm.type === 'wire' || elm.type === 'ground') continue;
      elm.stamp(this.mna);
    }
  }

  /** Distribute solved vector to all elements */
  _distribute(x) {
    for (let i = 1; i < this.nodeCount; i++) {
      this.nodeVoltages[i] = x[i - 1];
    }
    this.nodeVoltages[0] = 0;

    for (let n = 0; n < this.nodeCount; n++) {
      for (const link of this.nodeLinks[n]) {
        link.elm.setNodeVoltage(link.termIndex, this.nodeVoltages[n]);
      }
    }

    for (const elm of this.elements) {
      if (elm.type === 'wire' || elm.type === 'ground') continue;
      if (elm.voltSource >= 0 && elm.getVoltageSourceCount() > 0) {
        elm.current = x[(this.nodeCount - 1) + elm.voltSource];
      }
    }
  }

  /** Solve the matrix and distribute results */
  _solve() {
    if (!this.isNonLinear) {
      // Linear circuit: stamp once, solve once
      this.mna.clear();
      for (const elm of this.elements) {
        if (elm.type === 'wire' || elm.type === 'ground') continue;
        elm.stamp(this.mna);
        elm.doStep(this.mna);
      }
      const x = this.mna.solve();
      if (!x) return false;
      this._distribute(x);
      return true;
    }

    // Nonlinear circuit: Newton-Raphson sub-iteration
    const MAX_ITER = 100;
    for (let iter = 0; iter < MAX_ITER; iter++) {
      // Clear and re-stamp full matrix each iteration
      this.mna.clear();
      let converged = true;

      for (const elm of this.elements) {
        if (elm.type === 'wire' || elm.type === 'ground') continue;
        elm.stamp(this.mna);
        const ok = elm.doStep(this.mna);
        if (!ok) converged = false;
      }

      const x = this.mna.solve();
      if (!x) return false;

      this._distribute(x);

      // Converged after at least 1 iteration
      if (converged && iter > 0) return true;
    }

    // Didn't converge — use last solution anyway
    return true;
  }

  // ─── DC solve (Phase 1: no time stepping) ───

  /** Re-analyze and solve. Call after any topology change. */
  solveDC() {
    this.analyze();
  }

  /** Get voltage at a node */
  getNodeVoltage(node) {
    return this.nodeVoltages[node] || 0;
  }

  /** Get all element info for display */
  getElementInfo() {
    return this.elements
      .filter(e => e.type !== 'wire' && e.type !== 'ground')
      .map(e => ({ type: e.type, ...e.getInfo(), element: e }));
  }
}

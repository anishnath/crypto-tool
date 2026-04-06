/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Project + Subcircuits (Phase 8)
   Multi-circuit project, subcircuit definitions, drill-down.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const { Value, FALSE, TRUE, UNKNOWN } = L;
  const Port = L.Port;
  const BW = 60, PE = 8;
  const LX = -(BW / 2 + PE), RX = (BW / 2 + PE);

  /* ═══════════ Subcircuit Definition ═══════════
     Wraps a circuit template. Each instance gets a fresh clone. */
  class SubcircuitDef {
    constructor(name, circuitJSON, typeRegistry) {
      this.name         = name;
      this._json        = circuitJSON;   // serialized circuit template
      this._typeRegistry = typeRegistry;
      this._inputNames  = [];  // ordered INPUT pin labels
      this._outputNames = [];  // ordered OUTPUT pin labels
      this._scanPorts();
    }

    _scanPorts() {
      this._inputNames = [];
      this._outputNames = [];
      for (const cd of this._json.components) {
        if (cd.type === 'INPUT')  this._inputNames.push(cd.attrs.label || cd.id);
        if (cd.type === 'OUTPUT') this._outputNames.push(cd.attrs.label || cd.id);
      }
      this._inputNames.sort();
      this._outputNames.sort();
    }

    get numInputs()  { return this._inputNames.length; }
    get numOutputs() { return this._outputNames.length; }

    /* Create a fresh inner circuit clone */
    instantiate() {
      const { circuit, idMap } = L.Circuit.fromJSON(this._json, this._typeRegistry);
      // Collect INPUT and OUTPUT pins in sorted order
      const inputs = [], outputs = [];
      for (const comp of circuit.components.values()) {
        if (comp.type === 'INPUT')  inputs.push(comp);
        if (comp.type === 'OUTPUT') outputs.push(comp);
      }
      inputs.sort((a, b) => (a.attrs.label || a.id).localeCompare(b.attrs.label || b.id));
      outputs.sort((a, b) => (a.attrs.label || a.id).localeCompare(b.attrs.label || b.id));
      return { circuit, inputs, outputs };
    }

    /* Build a component type definition for this subcircuit (cached) */
    toComponentType() {
      if (this._cachedType) return this._cachedType;
      const def = this;
      const type = {
        type: 'SUB_' + def.name,
        label: def.name,
        category: 'Subcircuits',
        defaultAttrs: { _defName: def.name },
        isSubcircuit: true,

        createPorts() {
          const ports = [];
          const nIn = def.numInputs, nOut = def.numOutputs;
          const hIn  = Math.max(0, (nIn  - 1)) * 16;
          const hOut = Math.max(0, (nOut - 1)) * 16;
          for (let i = 0; i < nIn; i++)
            ports.push(new Port('in', LX, -hIn / 2 + i * 16, 1));
          for (let i = 0; i < nOut; i++)
            ports.push(new Port('out', RX, -hOut / 2 + i * 16, 1));
          return ports;
        },

        compute(inputs, attrs) {
          // Lazy instantiate inner circuit
          if (!attrs._inner) {
            const inst = def.instantiate();
            attrs._inner   = inst.circuit;
            attrs._innerIn = inst.inputs;
            attrs._innerOut = inst.outputs;
          }

          // Feed external input values into inner INPUT pins
          const innerIn = attrs._innerIn;
          for (let i = 0; i < innerIn.length && i < inputs.length; i++) {
            innerIn[i].attrs.state = inputs[i].get(0) === TRUE ? TRUE : FALSE;
          }

          // Propagate inner circuit (silent — no parent listeners)
          attrs._inner.propagate();

          // Read inner OUTPUT pin values
          const results = [];
          const innerOut = attrs._innerOut;
          for (let i = 0; i < innerOut.length; i++) {
            results.push(innerOut[i].ports[0].value);
          }
          return results;
        },

        render(comp, ctx) {
          const g = ctx.group;
          const nIn = def.numInputs, nOut = def.numOutputs;
          const rows = Math.max(nIn, nOut, 1);
          const h = Math.max(46, rows * 16 + 14);
          const hw = BW / 2, hh = h / 2;

          // Body (distinct color for subcircuits)
          const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
          rect.setAttribute('x', -hw); rect.setAttribute('y', -hh);
          rect.setAttribute('width', BW); rect.setAttribute('height', h);
          rect.setAttribute('rx', 3);
          rect.setAttribute('fill', 'var(--lg-gate-fill, #1e293b)');
          rect.setAttribute('stroke', 'var(--lg-accent)');
          rect.setAttribute('stroke-width', '1.5');
          rect.setAttribute('stroke-dasharray', '4 2');
          g.appendChild(rect);

          // Label
          const txt = document.createElementNS('http://www.w3.org/2000/svg', 'text');
          txt.setAttribute('x', 0); txt.setAttribute('y', 4);
          txt.setAttribute('text-anchor', 'middle');
          txt.setAttribute('fill', 'var(--lg-accent)');
          txt.setAttribute('font-size', '9');
          txt.setAttribute('font-weight', '600');
          txt.setAttribute('font-family', "'DM Sans', sans-serif");
          txt.textContent = def.name;
          g.appendChild(txt);

          // Port stubs + labels
          const allLabels = [...def._inputNames, ...def._outputNames];
          comp.ports.forEach((p, i) => {
            const isLeft = p.dir === 'in';
            const bodyEdge = isLeft ? -hw : hw;
            const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            line.setAttribute('x1', bodyEdge); line.setAttribute('y1', p.ry);
            line.setAttribute('x2', p.rx);     line.setAttribute('y2', p.ry);
            line.setAttribute('stroke', p.value.color());
            line.setAttribute('stroke-width', '2');
            g.appendChild(line);

            const lbl = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            lbl.setAttribute('x', isLeft ? -hw + 6 : hw - 6);
            lbl.setAttribute('y', p.ry + 3.5);
            lbl.setAttribute('text-anchor', isLeft ? 'start' : 'end');
            lbl.setAttribute('fill', 'var(--lg-muted)');
            lbl.setAttribute('font-size', '8');
            lbl.setAttribute('font-family', "'Fira Code', monospace");
            lbl.textContent = allLabels[i] || '';
            g.appendChild(lbl);
          });
        },

        dispose(comp) {
          // Clean up inner circuit (stop any clocks, etc.)
          if (comp.attrs._inner) {
            for (const c of comp.attrs._inner.components.values()) {
              if (c.typeDef.dispose) c.typeDef.dispose(c);
            }
          }
        }
      };
      this._cachedType = type;
      return type;
    }
  }

  /* ═══════════ Project (multi-circuit manager) ═══════════ */
  class Project {
    constructor() {
      this.circuits    = new Map();   // name → { circuit, json }
      this.subcircDefs = new Map();   // name → SubcircuitDef
      this.activeName  = 'main';
      this._listeners  = [];
      this._typeRegistry = null;      // set by JSP after all types loaded
    }

    onChange(fn) { this._listeners.push(fn); }
    _emit(type, data) { this._listeners.forEach(fn => fn(type, data)); }

    setTypeRegistry(reg) { this._typeRegistry = reg; }

    /* Add a named circuit */
    addCircuit(name, circuit) {
      this.circuits.set(name, { circuit, json: null });
      this._emit('addCircuit', name);
    }

    /* Get the active circuit */
    getActive() {
      const entry = this.circuits.get(this.activeName);
      return entry ? entry.circuit : null;
    }

    /* Switch active circuit */
    setActive(name) {
      if (!this.circuits.has(name)) return;
      this.activeName = name;
      this._emit('switchCircuit', name);
    }

    /* Save current circuit as a subcircuit definition */
    saveAsSubcircuit(name) {
      const active = this.getActive();
      if (!active) return null;

      // Check it has INPUT and OUTPUT pins
      let hasIn = false, hasOut = false;
      for (const c of active.components.values()) {
        if (c.type === 'INPUT') hasIn = true;
        if (c.type === 'OUTPUT') hasOut = true;
      }
      if (!hasIn || !hasOut) return null;

      const json = active.toJSON();
      const def = new SubcircuitDef(name, json, this._typeRegistry);
      this.subcircDefs.set(name, def);
      this._emit('addSubcircuit', name);
      return def;
    }

    /* Get subcircuit component type by name */
    getSubcircuitType(name) {
      const def = this.subcircDefs.get(name);
      return def ? def.toComponentType() : null;
    }

    /* List all subcircuit names */
    getSubcircuitNames() {
      return [...this.subcircDefs.keys()];
    }

    /* Remove a circuit */
    removeCircuit(name) {
      if (name === 'main') return; // can't remove main
      this.circuits.delete(name);
      if (this.activeName === name) this.setActive('main');
      this._emit('removeCircuit', name);
    }

    /* List all circuit names */
    getCircuitNames() {
      return [...this.circuits.keys()];
    }
  }

  L.SubcircuitDef = SubcircuitDef;
  L.Project       = Project;
})(window.LogicSim);

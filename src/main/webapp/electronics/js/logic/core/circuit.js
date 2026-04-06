/* ═══════════════════════════════════════════════════════════
   Logic Simulator — Circuit Model + Propagation Engine
   Event-driven, zero-delay for Phase 1.
   ═══════════════════════════════════════════════════════════ */
(function (L) {
  'use strict';

  const Value = L.Value;
  let _nextId = 1;

  /* ── Port ── */
  class Port {
    constructor(dir, x, y, width) {
      this.dir   = dir;      // 'in' | 'out'
      this.rx    = x;        // relative x (to component center)
      this.ry    = y;        // relative y
      this.width = width || 1;
      this.value = Value.X;
      this.wireId = null;    // connected wire id
    }
  }

  /* ── Component Instance ── */
  class Component {
    constructor(typeDef, x, y, attrs) {
      this.id       = 'c' + (_nextId++);
      this.type     = typeDef.type;
      this.typeDef  = typeDef;
      this.x        = x;
      this.y        = y;
      this.rotation = 0;     // degrees: 0, 90, 180, 270
      this.attrs    = Object.assign({}, typeDef.defaultAttrs || {}, attrs || {});
      this.ports    = typeDef.createPorts(this.attrs);
    }

    /* Get absolute port position (accounting for rotation) */
    portPos(portIdx) {
      const p = this.ports[portIdx];
      const rad = (this.rotation * Math.PI) / 180;
      const cos = Math.round(Math.cos(rad));
      const sin = Math.round(Math.sin(rad));
      return {
        x: this.x + p.rx * cos - p.ry * sin,
        y: this.y + p.rx * sin + p.ry * cos
      };
    }

    inputPorts()  { return this.ports.filter(p => p.dir === 'in'); }
    outputPorts() { return this.ports.filter(p => p.dir === 'out'); }

    /* Run compute function → returns array of output values */
    compute() {
      const inputs = this.inputPorts().map(p => p.value);
      const results = this.typeDef.compute(inputs, this.attrs);
      return Array.isArray(results) ? results : [results];
    }

    rotate(deg) {
      this.rotation = ((this.rotation + deg) % 360 + 360) % 360;
    }
  }

  /* ── Wire ── */
  class Wire {
    constructor(fromCompId, fromPortIdx, toCompId, toPortIdx) {
      this.id          = 'w' + (_nextId++);
      this.fromCompId  = fromCompId;
      this.fromPortIdx = fromPortIdx;
      this.toCompId    = toCompId;
      this.toPortIdx   = toPortIdx;
      this.value       = Value.X;
    }
  }

  /* ── Circuit ── */
  class Circuit {
    constructor() {
      this.components = new Map();
      this.wires      = new Map();
      this._listeners = [];
    }

    onChange(fn) { this._listeners.push(fn); }
    _emit(type, data) { this._listeners.forEach(fn => fn(type, data)); }

    /* Components */
    addComponent(typeDef, x, y, attrs) {
      const c = new Component(typeDef, x, y, attrs);
      this.components.set(c.id, c);
      this._emit('addComponent', c);
      this.propagate();
      return c;
    }

    removeComponent(id) {
      const comp = this.components.get(id);
      // Dispose (cleanup timers, etc.)
      if (comp && comp.typeDef.dispose) comp.typeDef.dispose(comp);
      // Remove all connected wires first
      const wiresToRemove = [];
      this.wires.forEach(w => {
        if (w.fromCompId === id || w.toCompId === id) wiresToRemove.push(w.id);
      });
      wiresToRemove.forEach(wid => this.removeWire(wid));
      this.components.delete(id);
      this._emit('removeComponent', id);
      this.propagate();
    }

    /* Wires */
    addWire(fromCompId, fromPortIdx, toCompId, toPortIdx) {
      const fromComp = this.components.get(fromCompId);
      const toComp   = this.components.get(toCompId);
      if (!fromComp || !toComp) return null;

      const fromPort = fromComp.ports[fromPortIdx];
      const toPort   = toComp.ports[toPortIdx];
      if (!fromPort || !toPort) return null;

      // Ensure direction: out → in
      let fci = fromCompId, fpi = fromPortIdx, tci = toCompId, tpi = toPortIdx;
      if (fromPort.dir === 'in' && toPort.dir === 'out') {
        [fci, fpi, tci, tpi] = [toCompId, toPortIdx, fromCompId, fromPortIdx];
      } else if (fromPort.dir === 'out' && toPort.dir === 'in') {
        // already correct
      } else {
        // same direction — allow in-to-in or out-to-out? no, reject
        return null;
      }

      // Check: target input already has a wire
      const targetPort = this.components.get(tci).ports[tpi];
      if (targetPort.wireId) return null; // already connected

      const w = new Wire(fci, fpi, tci, tpi);
      this.wires.set(w.id, w);

      // Mark ports
      targetPort.wireId = w.id;

      this._emit('addWire', w);
      this.propagate();
      return w;
    }

    removeWire(id) {
      const w = this.wires.get(id);
      if (!w) return;

      // Unlink ports
      const toComp = this.components.get(w.toCompId);
      if (toComp) {
        const toPort = toComp.ports[w.toPortIdx];
        if (toPort && toPort.wireId === id) {
          toPort.wireId = null;
          toPort.value = Value.X;
        }
      }

      this.wires.delete(id);
      this._emit('removeWire', id);
      this.propagate();
    }

    /* Find wire by endpoint */
    findWireAt(compId, portIdx) {
      for (const w of this.wires.values()) {
        if ((w.fromCompId === compId && w.fromPortIdx === portIdx) ||
            (w.toCompId === compId && w.toPortIdx === portIdx)) return w;
      }
      return null;
    }

    /* ── Propagation (zero-delay, iterate until stable) ── */
    propagate() {
      const MAX_ITER = 100;
      let changed = true;
      let iter = 0;

      while (changed && iter < MAX_ITER) {
        changed = false;
        iter++;

        // 1. Compute all components
        for (const comp of this.components.values()) {
          const outValues = comp.compute();
          const outPorts = comp.outputPorts();
          for (let i = 0; i < outPorts.length && i < outValues.length; i++) {
            if (!outPorts[i].value.equals(outValues[i])) {
              outPorts[i].value = outValues[i];
              changed = true;
            }
          }
        }

        // 2. Push output values through wires to input ports
        for (const w of this.wires.values()) {
          const fromComp = this.components.get(w.fromCompId);
          const toComp   = this.components.get(w.toCompId);
          if (!fromComp || !toComp) continue;

          const srcVal = fromComp.ports[w.fromPortIdx].value;
          w.value = srcVal;

          const dstPort = toComp.ports[w.toPortIdx];
          if (!dstPort.value.equals(srcVal)) {
            dstPort.value = srcVal;
            changed = true;
          }
        }

        // 3. Tunnel step inside stability loop
        if (this._propagateTunnels()) changed = true;
      }

      if (iter >= MAX_ITER) {
        console.warn('LogicSim: oscillation detected after', MAX_ITER, 'iterations');
      }

      this._emit('propagate', null);
    }

    /* Tunnel propagation: match TUNNEL_SRC → TUNNEL_TGT by name.
       Returns true if any tunnel value changed (caller re-loops). */
    _propagateTunnels() {
      const sources  = new Map();  // name → Value
      const conflicts = new Set(); // names with >1 source

      for (const comp of this.components.values()) {
        if (comp.typeDef.isTunnelSource && comp.attrs.name) {
          if (sources.has(comp.attrs.name)) conflicts.add(comp.attrs.name);
          else sources.set(comp.attrs.name, comp.ports[0].value);
        }
      }
      // Conflicting sources → ERROR
      for (const name of conflicts) sources.set(name, Value.E);

      let changed = false;
      for (const comp of this.components.values()) {
        if (!comp.typeDef.isTunnelTarget || !comp.attrs.name) continue;
        const val = sources.get(comp.attrs.name);
        // If source exists use its state; if source removed/missing → UNKNOWN
        const state = val !== undefined ? val.get(0) : L.UNKNOWN;
        if (comp.attrs._tunnelValue !== state) {
          comp.attrs._tunnelValue = state;
          changed = true;
        }
      }
      return changed;
    }

    /* Serialization */
    toJSON() {
      const comps = [];
      for (const c of this.components.values()) {
        // Shallow-copy attrs, stripping runtime-only subcircuit refs (non-serializable)
        const { _inner, _innerIn, _innerOut, ...safeAttrs } = c.attrs;
        comps.push({
          id: c.id, type: c.type,
          x: c.x, y: c.y, rotation: c.rotation,
          attrs: Object.assign({}, safeAttrs)
        });
      }
      const wires = [];
      for (const w of this.wires.values()) {
        wires.push({
          id: w.id,
          from: { comp: w.fromCompId, port: w.fromPortIdx },
          to:   { comp: w.toCompId,   port: w.toPortIdx }
        });
      }
      return { components: comps, wires };
    }
  }

  /* ── Clone / deserialize ── */
  Circuit.fromJSON = function (json, typeRegistry) {
    const c = new Circuit();
    const idMap = new Map(); // old id → new component

    for (const cd of json.components) {
      const typeDef = typeRegistry[cd.type];
      if (!typeDef) continue;
      const comp = c.addComponent(typeDef, cd.x, cd.y, cd.attrs);
      comp.rotation = cd.rotation || 0;
      idMap.set(cd.id, comp);
    }
    for (const wd of json.wires) {
      const fromComp = idMap.get(wd.from.comp);
      const toComp   = idMap.get(wd.to.comp);
      if (fromComp && toComp) {
        c.addWire(fromComp.id, wd.from.port, toComp.id, wd.to.port);
      }
    }
    return { circuit: c, idMap };
  };

  L.Port      = Port;
  L.Component = Component;
  L.Wire      = Wire;
  L.Circuit   = Circuit;
})(window.LogicSim);

/**
 * Diagram — import/export Wokwi-compatible diagram.json files.
 *
 * Format:
 *   { version: 1, parts: [...], connections: [...] }
 *
 * parts[]:
 *   { type: "wokwi-led", id: "led1", top: 100, left: 200, rotate: 0, attrs: { color: "red" } }
 *
 * connections[]:
 *   [ "led1:A", "arduino:13", "green", ["v-20", "h0"] ]
 *   (startComp:startPin, endComp:endPin, color, waypoints)
 */

/**
 * Export current canvas state to a diagram.json object.
 *
 * @param {string} boardTag - e.g. "wokwi-arduino-uno"
 * @param {string} boardId - e.g. "arduinoBoard"
 * @param {{x: number, y: number}} boardPos - board position on canvas
 * @param {Array} components - from ComponentPanel.components
 * @param {Array} wires - from WireManager.wires
 * @returns {object} diagram.json compatible object
 */
export function exportDiagram(boardTag, boardId, boardPos, components, wires) {
  const parts = [];

  // Board
  parts.push({
    type: boardTag,
    id: boardId,
    top: boardPos.y || 0,
    left: boardPos.x || 0,
    rotate: 0,
    attrs: {},
  });

  // Components
  for (const comp of components) {
    const wrapper = comp.wrapper;
    const rect = wrapper ? wrapper.getBoundingClientRect() : null;
    // Get position from transform or offset
    let top = 0, left = 0;
    if (wrapper) {
      const style = wrapper.style;
      // Components use absolute positioning via canvas.setComponentPosition
      left = parseFloat(style.left) || 0;
      top = parseFloat(style.top) || 0;
    }

    const attrs = {};
    // Capture element attributes that matter
    const el = comp.element;
    if (el) {
      for (const attr of el.attributes) {
        if (attr.name !== 'id' && attr.name !== 'style' && attr.name !== 'class') {
          attrs[attr.name] = attr.value;
        }
      }
    }
    // Store pin in attrs for re-import
    attrs['_pin'] = String(comp.pin);

    parts.push({
      type: comp.element?.tagName?.toLowerCase() || 'unknown',
      id: comp.id,
      top,
      left,
      rotate: 0,
      attrs,
    });
  }

  // Connections
  const connections = [];
  for (const wire of wires) {
    // Map our internal comp IDs to diagram format: "compId:pinName"
    const start = wire.startComp === 'board'
      ? `${boardId}:${wire.startPin}`
      : `${wire.startComp}:${wire.startPin}`;
    const end = wire.endComp === 'board'
      ? `${boardId}:${wire.endPin}`
      : `${wire.endComp}:${wire.endPin}`;

    connections.push([start, end, wire.color || 'green', []]);
  }

  return {
    version: 1,
    author: '',
    editor: '8gwifi-simulator',
    parts,
    connections,
  };
}

/**
 * Import a diagram.json object into the canvas.
 *
 * @param {object} diagram - parsed diagram.json
 * @param {import('./component-panel.js').ComponentPanel} componentPanel
 * @param {import('./wire-manager.js').WireManager} wireManager
 * @param {import('./canvas.js').SimulatorCanvas} canvas
 * @param {Function} switchBoardFn - async function to switch board by tag
 * @returns {Promise<{partsLoaded: number, wiresLoaded: number, errors: string[]}>}
 */
export async function importDiagram(diagram, componentPanel, wireManager, canvas, switchBoardFn) {
  const errors = [];
  let partsLoaded = 0;
  let wiresLoaded = 0;

  if (!diagram || !diagram.parts) {
    errors.push('Invalid diagram: missing parts array');
    return { partsLoaded, wiresLoaded, errors };
  }

  // Clear existing
  componentPanel.clearAll();
  wireManager.clearAll?.();

  // Map of diagram part ID → our internal component ID
  const idMap = {};

  // Find the board part
  const boardPart = diagram.parts.find(p =>
    p.type?.startsWith('wokwi-arduino') ||
    p.type?.startsWith('wokwi-esp32') ||
    p.type?.startsWith('pico-board') ||
    p.type === 'wokwi-nano-rp2040-connect'
  );

  if (boardPart) {
    idMap[boardPart.id] = 'board';
    // Switch board if needed
    const boardFqbnMap = {
      'wokwi-arduino-uno': 'arduino:avr:uno',
      'wokwi-arduino-nano': 'arduino:avr:nano',
      'wokwi-arduino-mega': 'arduino:avr:mega',
      'wokwi-esp32-devkit-v1': 'esp32:esp32:esp32',
    };
    const fqbn = boardFqbnMap[boardPart.type];
    if (fqbn && switchBoardFn) {
      await switchBoardFn(fqbn);
    }
  }

  // Reverse map: wokwi tag → our component type key
  // We need this because diagram uses wokwi tags but our panel uses type keys
  const tagToType = {
    'wokwi-led': 'led',
    'wokwi-pushbutton': 'pushbutton',
    'wokwi-potentiometer': 'potentiometer',
    'wokwi-slide-potentiometer': 'slide-potentiometer',
    'wokwi-servo': 'servo',
    'wokwi-buzzer': 'buzzer',
    'wokwi-ks2e-m-dc5': 'relay',
    'wokwi-slide-switch': 'slide-switch',
    'wokwi-photoresistor-sensor': 'photoresistor',
    'wokwi-neopixel': 'neopixel',
    'wokwi-7segment': '7segment',
    'wokwi-ky-040': 'encoder',
    'wokwi-membrane-keypad': 'keypad',
    'wokwi-lcd1602': 'lcd',
    'wokwi-ssd1306': 'oled',
    'wokwi-dht22': 'dht22',
    'wokwi-hc-sr04': 'hcsr04',
    'wokwi-ntc-temperature-sensor': 'ntc-temp',
  };

  // Add component parts
  for (const part of diagram.parts) {
    // Skip board parts
    if (idMap[part.id] === 'board') continue;

    const typeKey = tagToType[part.type];
    if (!typeKey) {
      errors.push(`Unknown part type: ${part.type} (id: ${part.id})`);
      continue;
    }

    // Determine pin from attrs._pin or first connection
    let pin = part.attrs?._pin || part.attrs?.pin || 2;
    if (typeof pin === 'string' && pin.match(/^\d+$/)) pin = parseInt(pin, 10);

    const comp = componentPanel.add(typeKey, pin);
    if (!comp) {
      errors.push(`Failed to add component: ${part.type} (id: ${part.id})`);
      continue;
    }

    idMap[part.id] = comp.id;

    // Set position
    if (canvas && part.left != null && part.top != null) {
      canvas.setComponentPosition(comp.wrapper, part.left, part.top);
    }

    // Apply extra attributes
    if (part.attrs) {
      for (const [k, v] of Object.entries(part.attrs)) {
        if (k.startsWith('_')) continue; // skip internal attrs
        comp.element.setAttribute(k, v);
      }
    }

    partsLoaded++;
  }

  // Add connections
  if (diagram.connections && wireManager.addWire) {
    for (const conn of diagram.connections) {
      if (!Array.isArray(conn) || conn.length < 2) continue;

      const [startRef, endRef, color] = conn;
      const [startId, startPin] = startRef.split(':');
      const [endId, endPin] = endRef.split(':');

      const startComp = idMap[startId];
      const endComp = idMap[endId];

      if (!startComp || !endComp) {
        errors.push(`Wire skipped: ${startRef} → ${endRef} (component not found)`);
        continue;
      }

      try {
        wireManager.addWire?.(startComp, startPin, endComp, endPin, color || 'green');
        wiresLoaded++;
      } catch (e) {
        errors.push(`Wire failed: ${startRef} → ${endRef}: ${e.message}`);
      }
    }
  }

  return { partsLoaded, wiresLoaded, errors };
}

/**
 * Download a diagram as a JSON file.
 */
export function downloadDiagram(diagram, filename = 'diagram.json') {
  const json = JSON.stringify(diagram, null, 2);
  const blob = new Blob([json], { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

/**
 * Open a file picker and load a diagram.json file.
 * @returns {Promise<object|null>} parsed diagram or null if cancelled
 */
export function openDiagramFile() {
  return new Promise((resolve) => {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json';
    input.addEventListener('change', () => {
      const file = input.files?.[0];
      if (!file) { resolve(null); return; }
      const reader = new FileReader();
      reader.onload = () => {
        try {
          resolve(JSON.parse(reader.result));
        } catch {
          alert('Invalid JSON file');
          resolve(null);
        }
      };
      reader.readAsText(file);
    });
    input.click();
  });
}

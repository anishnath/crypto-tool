/**
 * AI Assistant for Arduino Simulator
 *
 * Features:
 *   1. AI Generate — describe a project in English → get code + Wokwi circuit diagram
 *   2. AI Fix     — send compile errors + code → get corrected code
 *   3. AI Explain — explain selected code, full sketch, or current circuit
 *
 * Uses the generic /ai proxy endpoint (AIProxyServlet → Ollama).
 * All system prompts include the component catalog and Wokwi diagram format
 * so the AI generates valid, importable circuits.
 */

// ── Component & wiring reference for the AI system prompt ──
// This is the "cheat sheet" the AI uses to produce valid Wokwi diagrams.

const COMPONENT_REFERENCE = `
AVAILABLE COMPONENTS (Wokwi format):
- wokwi-led: LED. Pins: A (anode), C (cathode). Attrs: color (red|green|yellow). Connect: board:PIN→led:A, board:GND→led:C
- wokwi-pushbutton: Button. Pins: 1.l, 2.l. Connect: board:PIN→btn:1.l, board:GND→btn:2.l. Use INPUT_PULLUP in code.
- wokwi-potentiometer: Potentiometer. Pins: SIG, VCC, GND. Connect: board:A0→pot:SIG, board:5V→pot:VCC, board:GND→pot:GND
- wokwi-slide-potentiometer: Slide pot. Same pins as potentiometer.
- wokwi-servo: Servo motor. Pins: PWM, V+, GND. Connect: board:9→servo:PWM, board:5V→servo:V+, board:GND→servo:GND. Use Servo.h library.
- wokwi-buzzer: Buzzer. Pins: 1 (signal), 2 (GND). Connect: board:PIN→buzzer:1, board:GND→buzzer:2. Use tone() function.
- wokwi-ks2e-m-dc5: Relay. Pins: COIL1, COIL2. Connect: board:PIN→relay:COIL1, board:GND→relay:COIL2
- wokwi-slide-switch: Slide switch. Pins: 1, 2, 3. Connect: board:PIN→switch:1, board:GND→switch:3
- wokwi-photoresistor-sensor: Light sensor (LDR). Pins: VCC, GND, AO. Connect: board:A0→ldr:AO, board:5V→ldr:VCC, board:GND→ldr:GND
- wokwi-neopixel: NeoPixel LED. Pins: DIN, VDD, VSS. Connect: board:PIN→np:DIN, board:5V→np:VDD, board:GND→np:VSS. Use Adafruit_NeoPixel.h
- wokwi-7segment: 7-segment display. Pins: A,B,C,D,E,F,G,DP,COM. Multi-pin, connect each segment to a digital pin.
- wokwi-lcd1602: LCD 16x2 (I2C). Pins: SDA, SCL, VCC, GND. Connect: board:A4→lcd:SDA, board:A5→lcd:SCL, board:5V→lcd:VCC, board:GND→lcd:GND. Use LiquidCrystal_I2C.h
- wokwi-ssd1306: OLED 128x64 (I2C). Pins: SDA, SCL, VCC, GND. Same I2C wiring as LCD. Use Adafruit_SSD1306.h
- wokwi-dht22: Temperature/humidity sensor. Pins: VCC, SDA, GND. Connect: board:PIN→dht:SDA, board:5V→dht:VCC, board:GND→dht:GND. Use DHT.h
- wokwi-hc-sr04: Ultrasonic distance. Pins: TRIG, ECHO, VCC, GND. Connect: board:PIN1→hcsr04:TRIG, board:PIN2→hcsr04:ECHO, board:5V→hcsr04:VCC, board:GND→hcsr04:GND
- wokwi-ntc-temperature-sensor: NTC thermistor. Pins: VCC, GND, AO. Same as photoresistor wiring.
- wokwi-ky-040: Rotary encoder. Pins: CLK, DT, SW, VCC, GND. Connect CLK/DT/SW to digital pins.
- wokwi-membrane-keypad: 4x4 keypad. Pins: R1-R4, C1-C4. Connect each to a digital pin. Use Keypad.h

BOARD PINS (Arduino Uno):
- Digital: 2,3,4,5,6,7,8,9,10,11,12,13 (PWM: 3,5,6,9,10,11)
- Analog: A0,A1,A2,A3,A4,A5
- Power: 5V, GND.1, GND.2
- I2C: A4 (SDA), A5 (SCL)
- Servo: pins 9,10 (Timer1)

WOKWI DIAGRAM FORMAT:
{
  "parts": [
    { "type": "wokwi-arduino-uno", "id": "board", "top": 0, "left": 0 },
    { "type": "wokwi-led", "id": "led1", "top": 20, "left": 340, "attrs": { "color": "red", "_pin": "9" } }
  ],
  "connections": [
    ["board:9", "led1:A", "green", []],
    ["board:GND.1", "led1:C", "black", []]
  ]
}

RULES:
- The board part MUST always be first: { "type": "wokwi-arduino-uno", "id": "board", "top": 0, "left": 0 }
- Each component gets a unique id (led1, btn1, servo1, etc.)
- _pin attr stores the Arduino pin number for the simulator binding
- Connection format: ["fromId:pin", "toId:pin", "wireColor", []]
- Wire colors: red=power, black=ground, green/blue/orange=signal
- Position components to the right of the board (left: 340+), spaced vertically (top: 20, 80, 140...)
`;

// ── System prompts ──

// Board metadata for AI prompts
const BOARD_INFO = {
  'arduino:avr:uno':        { name: 'Arduino Uno',      mcu: 'ATmega328P', digital: '2-13', analog: 'A0-A5', pwm: '3,5,6,9,10,11', i2c: 'A4(SDA),A5(SCL)', servo: '9,10', voltage: '5V', note: 'Use Arduino AVR core APIs only.' },
  'arduino:avr:nano':       { name: 'Arduino Nano',     mcu: 'ATmega328P', digital: '2-13', analog: 'A0-A7', pwm: '3,5,6,9,10,11', i2c: 'A4(SDA),A5(SCL)', servo: '9,10', voltage: '5V', note: 'Same as Uno. Use Arduino AVR core APIs only.' },
  'rp2040:rp2040:rpipico':  { name: 'Raspberry Pi Pico', mcu: 'RP2040',    digital: '0-28', analog: '26-28', pwm: 'all digital', i2c: 'GP4(SDA),GP5(SCL)', servo: 'any', voltage: '3.3V', note: 'Use Arduino-Pico core. No AVR-specific registers.' },
  'rp2040:rp2040:rpipicow': { name: 'Raspberry Pi Pico W', mcu: 'RP2040',  digital: '0-28', analog: '26-28', pwm: 'all digital', i2c: 'GP4(SDA),GP5(SCL)', servo: 'any', voltage: '3.3V', note: 'Use Arduino-Pico core. Has WiFi via CYW43.' },
  'esp32:esp32:esp32c3':    { name: 'ESP32-C3',         mcu: 'ESP32-C3 RISC-V', digital: '0-10,18-21', analog: '0-4', pwm: 'all digital via LEDC', i2c: '8(SDA),9(SCL)', servo: 'any via LEDC', voltage: '3.3V', note: 'Use ESP32 Arduino core. Use ledcAttach() for PWM, not analogWrite().' },
  'esp32:esp32:esp32':      { name: 'ESP32',            mcu: 'ESP32 Xtensa', digital: '0-5,12-33', analog: '32-39', pwm: 'all digital via LEDC', i2c: '21(SDA),22(SCL)', servo: 'any via LEDC', voltage: '3.3V', note: 'Use ESP32 Arduino core. Use ledcAttach() for PWM.' },
  'esp32:esp32:esp32s3':    { name: 'ESP32-S3',         mcu: 'ESP32-S3 Xtensa', digital: '0-21,35-48', analog: '1-20', pwm: 'all digital via LEDC', i2c: '8(SDA),9(SCL)', servo: 'any via LEDC', voltage: '3.3V', note: 'Use ESP32 Arduino core. Use ledcAttach() for PWM.' },
};

function getBoardInfo(fqbn) {
  return BOARD_INFO[fqbn] || BOARD_INFO['arduino:avr:uno'];
}

// Step 1: Generate code only — reliable, streams into editor
function buildCodePrompt(board) {
  const b = getBoardInfo(board);
  return `You are an expert ${b.name} engineer. The user describes a project.
Return ONLY a complete, compilable Arduino sketch (.ino) for ${b.name} (${b.mcu}).
No markdown fences. No explanation. No commentary. Just the code.

TARGET BOARD: ${b.name} (${b.mcu})
- Digital pins: ${b.digital}
- Analog pins: ${b.analog}
- PWM pins: ${b.pwm}
- I2C: ${b.i2c}
- Servo pins: ${b.servo}
- Operating voltage: ${b.voltage}
- ${b.note}

CRITICAL RULES:
- Code MUST compile with arduino-cli for board FQBN "${board}" without errors.
- Use only standard Arduino functions and well-known libraries (Servo.h, Wire.h, LiquidCrystal_I2C.h, Adafruit_NeoPixel.h, DHT.h, Adafruit_SSD1306.h, Keypad.h).
- Use ONLY pins valid for ${b.name}. Do NOT use pins that don't exist on this board.
- Use descriptive pin constants (const int ledPin = 9;) not magic numbers.
- Include Serial.begin(115200) in setup() for serial monitor output.
- Include comments explaining key sections.
- Every variable must be declared. Every function must be defined. Every #include must be needed.
- The sketch must have both void setup() and void loop().`;
}

// Step 2: Generate Wokwi diagram from existing code — structured JSON
const SYS_GENERATE_DIAGRAM = `You are an expert Arduino circuit designer. Given Arduino code, generate a Wokwi-compatible circuit diagram JSON.

INSTRUCTIONS:
1. Read the code carefully. Identify every pinMode(), digitalWrite(), digitalRead(), analogRead(), analogWrite(), Servo.attach(), etc.
2. For each pin used, determine which physical component it connects to (LED, button, servo, sensor, etc.).
3. Generate the diagram with ONLY the components the code actually uses. Do not add extra components.
4. The "_pin" attribute MUST match the exact pin number used in the code.
5. Every component MUST have power (VCC/5V) and ground (GND) connections where required.

Return ONLY a valid JSON object with "parts" and "connections" arrays. No markdown fences. No explanation. No text outside the JSON.

${COMPONENT_REFERENCE}

EXAMPLE — if code uses digitalWrite(9, HIGH) for an LED and digitalRead(2) for a button:
{"parts":[{"type":"wokwi-arduino-uno","id":"board","top":0,"left":0},{"type":"wokwi-led","id":"led1","top":20,"left":340,"attrs":{"color":"red","_pin":"9"}},{"type":"wokwi-pushbutton","id":"btn1","top":100,"left":340,"attrs":{"color":"red","_pin":"2"}}],"connections":[["board:9","led1:A","green",[]],["board:GND.1","led1:C","black",[]],["board:2","btn1:1.l","green",[]],["board:GND.2","btn1:2.l","black",[]]]}`;

// Legacy single-shot prompt (kept as fallback)
const SYS_GENERATE = buildCodePrompt('arduino:avr:uno');

const SYS_FIX = `You are an expert Arduino programmer. The user's code failed to compile.
Fix the code and return ONLY the complete corrected Arduino sketch.
No markdown fences, no explanation, no commentary. Just the code.`;

const SYS_EXPLAIN = `You are an expert Arduino teacher. Explain the given Arduino code clearly and concisely.
Describe: what it does, which pins/components are used, the logic flow, and any libraries used.
Keep it short — 3-5 paragraphs maximum. Use plain English.`;

const SYS_EXPLAIN_CIRCUIT = `You are an expert Arduino teacher. The user provides a Wokwi circuit diagram in JSON format.
Explain the circuit: which components are connected, how they're wired to the Arduino, and what the circuit is designed to do.
Keep it short and clear.`;

const SYS_EXPLAIN_ERROR = `You are an expert Arduino teacher. The user's code produced compilation errors.
Explain what each error means, why it happened, and how to fix it.
Be concise — focus on actionable fixes.`;


const AI_TIMEOUT_MS = 180000; // 180s — generate (code+circuit) needs more time

export class AIAssistant {
  /**
   * @param {object} opts
   * @param {string} opts.ctx - context path (for /ai URL)
   * @param {Function} opts.getCode - returns current editor code
   * @param {Function} opts.setCode - sets editor code
   * @param {Function} opts.getSelection - returns selected text
   * @param {Function} opts.getBoard - returns current board FQBN
   * @param {Function} opts.loadPreset - async fn(preset) to load code + diagram
   * @param {Function} opts.getErrors - returns last compile errors string
   * @param {Function} opts.getDiagram - returns current diagram JSON
   * @param {Function} opts.logOutput - log message to output panel
   */
  constructor(opts) {
    this.aiUrl = opts.ctx + '/ai';
    this.getCode = opts.getCode;
    this.setCode = opts.setCode;
    this.getSelection = opts.getSelection;
    this.getBoard = opts.getBoard;
    this.loadPreset = opts.loadPreset;
    this.getErrors = opts.getErrors;
    this.getDiagram = opts.getDiagram;
    this.logOutput = opts.logOutput;
    this.abortCtrl = null;
    this.busy = false;

    this._initUI();
    this._initKeyboard();
  }

  // ══════════════════════════════════════════════
  // UI
  // ══════════════════════════════════════════════

  _initUI() {
    // AI prompt modal
    const modal = document.createElement('div');
    modal.id = 'ardAiModal';
    modal.className = 'ard-ai-modal-overlay';
    modal.innerHTML = `
      <div class="ard-ai-modal">
        <div class="ard-ai-modal-header">
          <span>&#10024; AI Arduino Project Generator</span>
          <button class="ard-ai-modal-close" id="ardAiClose">&times;</button>
        </div>
        <div class="ard-ai-modal-body">
          <textarea id="ardAiInput" class="ard-ai-input" rows="3"
            placeholder="Describe your project... e.g. &quot;traffic light with 3 LEDs cycling red-yellow-green&quot; or &quot;servo controlled by potentiometer with angle on LCD&quot;"></textarea>
          <div class="ard-ai-modal-footer">
            <span class="ard-ai-hint">Board: <strong id="ardAiBoardLabel">Arduino Uno</strong> &middot; Enter to generate &middot; Esc to close</span>
            <button class="ard-ai-submit" id="ardAiSubmit">&#10024; Generate Project</button>
          </div>
        </div>
      </div>
    `;
    modal.addEventListener('click', (e) => { if (e.target === modal) this.closePrompt(); });
    document.body.appendChild(modal);

    document.getElementById('ardAiClose').addEventListener('click', () => this.closePrompt());
    document.getElementById('ardAiSubmit').addEventListener('click', () => this._submitGenerate());
    document.getElementById('ardAiInput').addEventListener('keydown', (e) => {
      if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); this._submitGenerate(); }
      else if (e.key === 'Escape') this.closePrompt();
    });

    // AI output panel (reuses output panel area — messages go to logOutput)
  }

  _initKeyboard() {
    document.addEventListener('keydown', (e) => {
      if ((e.ctrlKey || e.metaKey) && e.shiftKey && (e.key === 'A' || e.key === 'a')) {
        e.preventDefault();
        this.openPrompt();
      }
      if (e.key === 'Escape' && this.abortCtrl) {
        this.cancel();
      }
    });
  }

  openPrompt() {
    const modal = document.getElementById('ardAiModal');
    modal.style.display = 'flex';
    const input = document.getElementById('ardAiInput');
    input.value = '';
    input.focus();
    // Show current board name in modal
    const boardLabel = document.getElementById('ardAiBoardLabel');
    if (boardLabel) {
      const info = getBoardInfo(this.getBoard());
      boardLabel.textContent = info.name;
    }
  }

  closePrompt() {
    document.getElementById('ardAiModal').style.display = 'none';
  }

  // ══════════════════════════════════════════════
  // AI GENERATE — NL → Code + Circuit
  // ══════════════════════════════════════════════

  async _submitGenerate() {
    const input = document.getElementById('ardAiInput');
    const desc = (input ? input.value.trim() : '');
    if (!desc) return;
    this.closePrompt();
    await this.generate(desc);
  }

  async generate(description) {
    if (this.busy) { this.logOutput('⚠ AI is busy. Cancel or wait for current request.'); return; }
    this.busy = true;
    this._disableButtons(true);
    const board = this.getBoard();
    const boardInfo = getBoardInfo(board);
    this.logOutput('🤖 AI generating project for ' + boardInfo.name + ': "' + description + '"');

    // ── Step 1: Generate code (streaming into editor) ──
    this.logOutput('  Step 1/2: Generating code for ' + boardInfo.name + '...');
    this._showStatus(true, 'Step 1/2: Generating code...');

    let code = '';
    try {
      code = await this._streamAccumulate({
        messages: [
          { role: 'system', content: buildCodePrompt(board) },
          { role: 'user', content: description }
        ],
        stream: true
      }, (partial) => {
        // Show accumulated code in editor as it streams
        const clean = this._cleanCode(partial);
        this.setCode(clean);
      });
    } catch (err) {
      this.logOutput('✗ Code generation failed: ' + err.message);
      this._showStatus(false);
      return;
    }

    if (!code) {
      this.logOutput('✗ AI returned empty code');
      this._showStatus(false);
      return;
    }

    // Clean and finalize code in editor
    code = this._cleanCode(code);
    this.setCode(code);
    this.logOutput('  ✓ Code generated (' + code.split('\n').length + ' lines)');

    // ── Step 2: Generate circuit diagram from the code ──
    this.logOutput('  Step 2/2: Generating circuit diagram...');
    this._showStatus(true, 'Step 2/2: Generating circuit...');

    let diagram = null;
    try {
      const diagramRaw = await this._streamAccumulate({
        messages: [
          { role: 'system', content: SYS_GENERATE_DIAGRAM },
          { role: 'user', content: code }
        ],
        stream: true
      }, (partial) => {
        this._showStatus(true, 'Step 2/2: Generating circuit... (' + partial.length + ' chars)');
      });

      if (diagramRaw) {
        // Parse JSON — strip markdown fences if any
        let clean = diagramRaw.trim();
        clean = clean.replace(/^```(?:json)?\s*\n?/i, '');
        clean = clean.replace(/\n?```\s*$/i, '');

        // Try to find JSON object in the response
        const jsonStart = clean.indexOf('{');
        const jsonEnd = clean.lastIndexOf('}');
        if (jsonStart !== -1 && jsonEnd > jsonStart) {
          clean = clean.substring(jsonStart, jsonEnd + 1);
        }

        diagram = JSON.parse(clean);

        // Validate: must have parts array with board
        if (!diagram.parts || !Array.isArray(diagram.parts) || diagram.parts.length === 0) {
          throw new Error('No parts in diagram');
        }
        if (!diagram.connections) {
          diagram.connections = [];
        }

        this.logOutput('  ✓ Circuit generated (' + diagram.parts.length + ' parts, ' + diagram.connections.length + ' wires)');
      }
    } catch (err) {
      this.logOutput('  ⚠ Circuit generation failed: ' + err.message + ' — add components manually');
      diagram = null;
    }

    // ── Load everything ──
    try {
      await this.loadPreset({
        code: code,
        diagram: diagram,
        board: board,
        description: description
      });
      if (diagram) {
        this.logOutput('✓ Project ready — code + circuit loaded. Click Run!');
      } else {
        this.logOutput('✓ Code loaded. Add components manually, then click Run.');
      }
    } catch (err) {
      this.logOutput('⚠ Failed to load circuit: ' + err.message);
    }

    this._showStatus(false);
  }

  /**
   * Stream an AI request, accumulate the full response, call onProgress with partial text.
   * Returns the complete accumulated string.
   */
  async _streamAccumulate(payload, onProgress) {
    if (this.abortCtrl) this.abortCtrl.abort();
    this.abortCtrl = new AbortController();
    const timeoutId = setTimeout(() => this.abortCtrl.abort(), AI_TIMEOUT_MS);

    try {
      const res = await fetch(this.aiUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
        signal: this.abortCtrl.signal
      });

      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || 'AI request failed (' + res.status + ')');
      }

      const reader = res.body.getReader();
      const decoder = new TextDecoder();
      let buffer = '';
      let accumulated = '';

      const processChunk = async (result) => {
        if (result.done) return;
        buffer += decoder.decode(result.value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop();

        for (const line of lines) {
          const trimmed = line.trim();
          if (!trimmed) continue;
          try {
            const obj = JSON.parse(trimmed);
            if (obj.message && obj.message.content) {
              accumulated += obj.message.content;
              if (onProgress) onProgress(accumulated);
            }
            if (obj.done === true) return;
          } catch (e) { /* skip */ }
        }
        return reader.read().then(processChunk);
      };

      await reader.read().then(processChunk);
      clearTimeout(timeoutId);
      this.abortCtrl = null;
      return accumulated;

    } catch (err) {
      clearTimeout(timeoutId);
      if (err.name === 'AbortError') throw new Error('Request timed out');
      throw err;
    }
  }

  _cleanCode(text) {
    return text.replace(/^```(?:cpp|c\+\+|arduino|ino)?\s*\n?/i, '').replace(/\n?```\s*$/i, '').trim();
  }

  // ══════════════════════════════════════════════
  // AI FIX — fix compile errors
  // ══════════════════════════════════════════════

  async fix() {
    if (this.busy) { this.logOutput('⚠ AI is busy. Cancel or wait for current request.'); return; }
    this.busy = true;
    this._disableButtons(true);
    const code = this.getCode();
    const errors = this.getErrors();

    if (!errors) {
      this.logOutput('No errors to fix. Compile first.');
      return;
    }

    this.logOutput('🤖 AI fixing compile errors...');
    this._showStatus(true, 'AI fixing errors...');

    try {
      const board = this.getBoard();
      const userContent = `Board: ${board}\n\nCompile errors:\n${errors}\n\nCode:\n${code}`;

      const payload = {
        messages: [
          { role: 'system', content: SYS_FIX },
          { role: 'user', content: userContent }
        ],
        stream: false
      };

      const result = await this._request(payload);
      if (!result) return;

      const clean = result.replace(/^```(?:cpp|c\+\+|arduino|ino)?\s*\n?/i, '').replace(/\n?```\s*$/i, '').trim();
      this.setCode(clean);
      this.logOutput('✓ AI fix applied. Click Compile to verify.');
      this._showStatus(false);

    } catch (err) {
      this.logOutput('✗ AI fix error: ' + err);
      this._showStatus(false);
    }
  }

  // ══════════════════════════════════════════════
  // AI EXPLAIN — explain code, circuit, or error
  // ══════════════════════════════════════════════

  async explain() {
    if (this.busy) { this.logOutput('⚠ AI is busy. Cancel or wait for current request.'); return; }
    this.busy = true;
    this._disableButtons(true);
    const selection = this.getSelection();
    const code = this.getCode();
    const errors = this.getErrors();
    const diagram = this.getDiagram();

    let systemPrompt, userContent;

    if (errors) {
      // Explain compile errors
      systemPrompt = SYS_EXPLAIN_ERROR;
      userContent = `Errors:\n${errors}\n\nCode:\n${code}`;
      this.logOutput('🤖 AI explaining errors...');
    } else if (selection) {
      // Explain selected code
      systemPrompt = SYS_EXPLAIN;
      userContent = selection;
      this.logOutput('🤖 AI explaining selection...');
    } else if (diagram && diagram.parts && diagram.parts.length > 1) {
      // Explain circuit + code together
      systemPrompt = SYS_EXPLAIN_CIRCUIT;
      userContent = `Circuit:\n${JSON.stringify(diagram, null, 2)}\n\nCode:\n${code}`;
      this.logOutput('🤖 AI explaining circuit + code...');
    } else {
      // Explain full code
      systemPrompt = SYS_EXPLAIN;
      userContent = code;
      this.logOutput('🤖 AI explaining code...');
    }

    this._showStatus(true, 'AI explaining...');

    try {
      const result = await this._streamToOutput({
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userContent }
        ],
        stream: true
      });
      this._showStatus(false);
    } catch (err) {
      this.logOutput('✗ AI error: ' + err);
      this._showStatus(false);
    }
  }

  // ══════════════════════════════════════════════
  // CANCEL
  // ══════════════════════════════════════════════

  cancel() {
    if (this.abortCtrl) {
      this.abortCtrl.abort();
      this.abortCtrl = null;
      this.logOutput('AI generation cancelled.');
    }
    this.busy = false;
    this._showStatus(false);
  }

  // ══════════════════════════════════════════════
  // HTTP helpers
  // ══════════════════════════════════════════════

  async _request(payload) {
    if (this.abortCtrl) this.abortCtrl.abort();
    this.abortCtrl = new AbortController();

    const timeoutId = setTimeout(() => this.abortCtrl.abort(), AI_TIMEOUT_MS);

    payload.stream = false;
    try {
      const res = await fetch(this.aiUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
        signal: this.abortCtrl.signal
      });

      clearTimeout(timeoutId);

      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || 'AI request failed (' + res.status + ')');
      }

      const data = await res.json();
      this.abortCtrl = null;
      return (data.message && data.message.content) ? data.message.content : '';
    } catch (err) {
      clearTimeout(timeoutId);
      if (err.name === 'AbortError') throw new Error('Request timed out');
      throw err;
    }
  }

  async _streamToOutput(payload) {
    if (this.abortCtrl) this.abortCtrl.abort();
    this.abortCtrl = new AbortController();

    const timeoutId = setTimeout(() => this.abortCtrl.abort(), AI_TIMEOUT_MS);

    const res = await fetch(this.aiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
      signal: this.abortCtrl.signal
    });

    if (!res.ok) {
      const data = await res.json().catch(() => ({}));
      throw new Error(data.error || 'AI request failed');
    }

    const reader = res.body.getReader();
    const decoder = new TextDecoder();
    let buffer = '';
    let accumulated = '';

    const processChunk = async (result) => {
      if (result.done) return;
      buffer += decoder.decode(result.value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop();

      for (const line of lines) {
        const trimmed = line.trim();
        if (!trimmed) continue;
        try {
          const obj = JSON.parse(trimmed);
          if (obj.message && obj.message.content) {
            accumulated += obj.message.content;
            // Update output panel with accumulated text
            this.logOutput('🤖 ' + accumulated, true);
          }
          if (obj.done === true) return;
        } catch (e) { /* skip */ }
      }
      return reader.read().then(processChunk);
    };

    await reader.read().then(processChunk);
    clearTimeout(timeoutId);
    this.abortCtrl = null;
    return accumulated;
  }

  // ══════════════════════════════════════════════
  // Status indicator
  // ══════════════════════════════════════════════

  _disableButtons(disabled) {
    const ids = ['btnAI', 'btnAIFix', 'btnAIExplain'];
    for (const id of ids) {
      const btn = document.getElementById(id);
      if (btn) {
        btn.disabled = disabled;
        if (disabled) btn.style.opacity = '0.4';
        else btn.style.opacity = '';
      }
    }
  }

  _showStatus(show, text) {
    if (!show) {
      this.busy = false;
      this._disableButtons(false);
    }
    let el = document.getElementById('ardAiStatus');
    if (!el) {
      el = document.createElement('span');
      el.id = 'ardAiStatus';
      el.className = 'ard-ai-status';
      const compileStatus = document.getElementById('compileStatus');
      if (compileStatus) compileStatus.parentNode.insertBefore(el, compileStatus);
    }
    if (show) {
      el.innerHTML = '<svg class="ard-spinner ard-ai-spinner" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-linecap="round"/></svg> ' + (text || 'AI...');
      el.style.display = '';
    } else {
      el.style.display = 'none';
    }
  }
}

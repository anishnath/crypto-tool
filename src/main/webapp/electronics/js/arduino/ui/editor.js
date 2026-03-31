/**
 * ArduinoEditor — Monaco Editor wrapper for Arduino/C++ sketches.
 *
 * Loads Monaco from CDN (AMD loader), creates editor instance,
 * handles compile error markers, and provides get/set for code.
 */

const MONACO_CDN = 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min';

const DEFAULT_CODE = `void setup() {
  Serial.begin(115200);
  pinMode(13, OUTPUT);
}

void loop() {
  Serial.println("LED ON");
  digitalWrite(13, HIGH);
  delay(500);
  Serial.println("LED OFF");
  digitalWrite(13, LOW);
  delay(500);
}`;

export class ArduinoEditor {
  /**
   * @param {HTMLElement} container - element to mount Monaco into
   * @param {object} [options]
   * @param {string} [options.code] - initial code
   * @param {string} [options.theme] - 'vs-dark' or 'vs'
   */
  constructor(container, options = {}) {
    this.container = container;
    this._editor = null;
    this._monaco = null;
    this._ready = false;
    this._initCode = options.code || DEFAULT_CODE;
    this._theme = options.theme || 'vs-dark';
    this._readyCallbacks = [];
  }

  /** Load Monaco from CDN and create editor. Returns promise. */
  async init() {
    if (this._ready) return;

    // Load AMD loader if not present
    if (!window.require) {
      await new Promise((resolve, reject) => {
        const s = document.createElement('script');
        s.src = MONACO_CDN + '/vs/loader.js';
        s.onload = resolve;
        s.onerror = reject;
        document.head.appendChild(s);
      });
    }

    // Configure and load Monaco
    window.require.config({ paths: { vs: MONACO_CDN + '/vs' } });

    await new Promise((resolve) => {
      window.require(['vs/editor/editor.main'], (monaco) => {
        this._monaco = monaco;

        this._editor = monaco.editor.create(this.container, {
          value: this._initCode,
          language: 'cpp',
          theme: this._theme,
          fontSize: 13,
          fontFamily: "'Fira Code', Consolas, 'Courier New', monospace",
          fontLigatures: true,
          minimap: { enabled: false },
          scrollBeyondLastLine: false,
          wordWrap: 'on',
          automaticLayout: true,
          lineNumbers: 'on',
          renderLineHighlight: 'line',
          bracketPairColorization: { enabled: true },
          tabSize: 2,
          padding: { top: 8 },
        });

        this._ready = true;
        for (const cb of this._readyCallbacks) cb();
        this._readyCallbacks = [];
        resolve();
      });
    });
  }

  /** Get current code */
  getCode() {
    return this._editor ? this._editor.getValue() : this._initCode;
  }

  /** Set code */
  setCode(code) {
    if (this._editor) {
      this._editor.setValue(code);
    } else {
      this._initCode = code;
    }
  }

  /** Set theme ('vs-dark' or 'vs') */
  setTheme(theme) {
    this._theme = theme;
    if (this._monaco) {
      this._monaco.editor.setTheme(theme);
    }
  }

  /**
   * Show compile errors as Monaco markers (red squiggly underlines).
   * @param {Array<{line: number, column: number, message: string}>} errors
   */
  setErrors(errors) {
    if (!this._monaco || !this._editor) return;
    const model = this._editor.getModel();
    if (!model) return;

    const markers = errors.map(e => ({
      severity: this._monaco.MarkerSeverity.Error,
      startLineNumber: e.line || 1,
      startColumn: e.column || 1,
      endLineNumber: e.line || 1,
      endColumn: (e.column || 1) + 20,
      message: e.message || 'Compile error',
    }));

    this._monaco.editor.setModelMarkers(model, 'arduino-compile', markers);
  }

  /**
   * Show compile warnings as Monaco markers (yellow squiggly underlines).
   * @param {Array<{line: number, column: number, message: string}>} warnings
   */
  setWarnings(warnings) {
    if (!this._monaco || !this._editor || !warnings || !warnings.length) return;
    const model = this._editor.getModel();
    if (!model) return;

    // Get existing markers and append warnings
    const existing = this._monaco.editor.getModelMarkers({ resource: model.uri, owner: 'arduino-compile' });
    const warnMarkers = warnings.map(w => ({
      severity: this._monaco.MarkerSeverity.Warning,
      startLineNumber: w.line || 1,
      startColumn: w.column || 1,
      endLineNumber: w.line || 1,
      endColumn: (w.column || 1) + 20,
      message: w.message || 'Warning',
    }));

    this._monaco.editor.setModelMarkers(model, 'arduino-compile', [...existing, ...warnMarkers]);
  }

  /** Clear all error and warning markers */
  clearErrors() {
    if (!this._monaco || !this._editor) return;
    const model = this._editor.getModel();
    if (model) {
      this._monaco.editor.setModelMarkers(model, 'arduino-compile', []);
    }
  }

  /** Register callback for when editor is ready */
  onReady(cb) {
    if (this._ready) cb();
    else this._readyCallbacks.push(cb);
  }

  /** Dispose editor */
  dispose() {
    if (this._editor) {
      this._editor.dispose();
      this._editor = null;
    }
    this._ready = false;
  }
}

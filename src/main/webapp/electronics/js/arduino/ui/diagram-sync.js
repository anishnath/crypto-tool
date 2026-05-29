/**
 * DiagramSync — two-way sync between diagram.json editor tab and canvas.
 *
 * Edit diagram.json in editor → canvas updates (components + wires)
 * Drag/add/wire on canvas → diagram.json updates in editor
 *
 * The diagram.json tab is auto-created in FileManager. Editing it sets
 * Monaco language to JSON with schema hints.
 */

import { exportDiagram, importDiagram } from './diagram.js';

const DIAGRAM_FILENAME = 'diagram.json';
const DEBOUNCE_MS = 500; // debounce editor→canvas sync

export class DiagramSync {
  /**
   * @param {import('./file-manager.js').FileManager} fileManager
   * @param {import('./component-panel.js').ComponentPanel} componentPanel
   * @param {import('./wire-manager.js').WireManager} wireManager
   * @param {import('./canvas.js').SimulatorCanvas} canvas
   * @param {Function} getBoardTag - returns current board tag (e.g. 'wokwi-arduino-uno')
   * @param {Function} switchBoardFn - async (fqbn) => switch board
   */
  constructor(fileManager, componentPanel, wireManager, canvas, getBoardTag, switchBoardFn) {
    this.fileManager = fileManager;
    this.componentPanel = componentPanel;
    this.wireManager = wireManager;
    this.canvas = canvas;
    this.getBoardTag = getBoardTag;
    this.switchBoardFn = switchBoardFn;

    this._syncing = false; // guard against infinite loops
    this._debounceTimer = null;
    this._canvasDebounceTimer = null;

    this._ensureDiagramFile();
    this._hookEditorChanges();
    this._hookCanvasChanges();

    // Initial sync: canvas → diagram.json
    this._canvasToEditor();
  }

  /** Ensure diagram.json exists in the file list */
  _ensureDiagramFile() {
    const fm = this.fileManager;
    const idx = fm.files.findIndex(f => f.name === DIAGRAM_FILENAME);
    if (idx >= 0) return;

    // Add diagram.json with initial empty diagram
    fm.files.push({
      name: DIAGRAM_FILENAME,
      content: JSON.stringify(this._buildDiagram(), null, 2),
      modified: false,
    });
    if (fm.onChange) fm.onChange();
  }

  /** Build diagram.json object from current canvas state */
  _buildDiagram() {
    return exportDiagram(
      this.getBoardTag(),
      'board',
      { x: 0, y: 0 },
      this.componentPanel.components,
      this.wireManager.wires
    );
  }

  /** Canvas → editor: update diagram.json content (debounced to avoid N updates during preset load) */
  _canvasToEditor() {
    if (this._syncing) return;
    clearTimeout(this._canvasDebounceTimer);
    this._canvasDebounceTimer = setTimeout(() => {
      if (this._syncing) return;
      this._syncing = true;
      try {
        const fm = this.fileManager;
        const idx = fm.files.findIndex(f => f.name === DIAGRAM_FILENAME);
        if (idx < 0) return;

        const fresh = this._buildDiagram();
        const merged = this._mergePreservedParts(fresh, fm.files[idx].content);
        const json = JSON.stringify(merged, null, 2);

        fm.files[idx].content = json;
        fm.files[idx].modified = true;

        if (fm.activeIndex === idx) {
          fm.editor.setCode(json);
        }
        if (fm.onChange) fm.onChange();
      } finally {
        this._syncing = false;
      }
    }, 200);
  }

  /**
   * Merge canvas-derived diagram with parts the canvas can't render but were
   * present in the previous diagram.json (e.g. AI-supplied `wokwi-resistor`).
   * Also keeps connections that reference any preserved part id.
   */
  _mergePreservedParts(fresh, previousJson) {
    if (!previousJson) return fresh;
    let prev;
    try { prev = JSON.parse(previousJson); } catch { return fresh; }
    if (!prev || !Array.isArray(prev.parts)) return fresh;

    const renderedIds = new Set((fresh.parts || []).map(p => p.id));
    const preservedParts = prev.parts.filter(p => p && p.id && !renderedIds.has(p.id));
    if (!preservedParts.length) return fresh;

    const preservedIds = new Set(preservedParts.map(p => p.id));
    const preservedConnections = (prev.connections || []).filter((c) => {
      if (!Array.isArray(c) || c.length < 2) return false;
      const startId = String(c[0] ?? '').split(':')[0];
      const endId = String(c[1] ?? '').split(':')[0];
      return preservedIds.has(startId) || preservedIds.has(endId);
    });

    return {
      ...fresh,
      parts: [...(fresh.parts || []), ...preservedParts],
      connections: [...(fresh.connections || []), ...preservedConnections],
    };
  }

  /** Editor → canvas: parse diagram.json and rebuild canvas (debounced) */
  _editorToCanvas() {
    if (this._syncing) return;

    clearTimeout(this._debounceTimer);
    this._debounceTimer = setTimeout(async () => {
      if (this._syncing) return;
      this._syncing = true;

      try {
        const fm = this.fileManager;
        const idx = fm.files.findIndex(f => f.name === DIAGRAM_FILENAME);
        if (idx < 0) return;

        // Get latest content from editor if active
        if (fm.activeIndex === idx) {
          fm.files[idx].content = fm.editor.getCode();
        }

        let diagram;
        try {
          diagram = JSON.parse(fm.files[idx].content);
        } catch {
          return; // invalid JSON — don't touch canvas
        }

        if (!diagram || !diagram.parts) return;

        await importDiagram(
          diagram,
          this.componentPanel,
          this.wireManager,
          this.canvas,
          this.switchBoardFn
        );
      } finally {
        this._syncing = false;
      }
    }, DEBOUNCE_MS);
  }

  /** Hook into editor changes — detect when diagram.json is being edited */
  _hookEditorChanges() {
    const fm = this.fileManager;
    const editor = fm.editor;

    // Listen for Monaco content changes
    editor.onReady(() => {
      const monacoEditor = editor._editor; // internal Monaco instance
      if (monacoEditor && monacoEditor.onDidChangeModelContent) {
        monacoEditor.onDidChangeModelContent(() => {
          if (fm.activeFile?.name === DIAGRAM_FILENAME) {
            this._editorToCanvas();
          }
        });
      }
    });

    // When switching TO diagram.json tab, set language to JSON
    const origSwitchTo = fm.switchTo.bind(fm);
    fm.switchTo = (index) => {
      origSwitchTo(index);
      if (fm.files[index]?.name === DIAGRAM_FILENAME) {
        const monacoEditor = editor._editor;
        if (monacoEditor) {
          const model = monacoEditor.getModel();
          if (model && window.monaco) {
            window.monaco.editor.setModelLanguage(model, 'json');
          }
        }
      }
    };
  }

  /**
   * Programmatically load a Wokwi diagram (e.g. from the AI assistant) without
   * letting the canvas→editor sync overwrite the canonical JSON.
   *
   * The supplied object is preserved as the source of truth for diagram.json,
   * even if some part types are unknown to the canvas importer.
   *
   * @param {object} diagram - parsed Wokwi diagram ({ parts, connections, ... })
   * @param {{ focusTab?: boolean }} [opts]
   * @returns {Promise<{ partsLoaded: number, wiresLoaded: number, errors: string[] }>}
   */
  async applyExternalDiagram(diagram, opts = {}) {
    const { focusTab = false } = opts;
    const fm = this.fileManager;

    console.log('[DiagramSync] applyExternalDiagram start',
      { parts: diagram?.parts?.length ?? 0, connections: diagram?.connections?.length ?? 0 });

    // Pause both sync directions so we don't race ourselves.
    clearTimeout(this._canvasDebounceTimer);
    clearTimeout(this._debounceTimer);
    const wasSyncing = this._syncing;
    this._syncing = true;

    let result = { partsLoaded: 0, wiresLoaded: 0, errors: [] };
    try {
      result = await importDiagram(
        diagram,
        this.componentPanel,
        this.wireManager,
        this.canvas,
        this.switchBoardFn,
      );

      const json = JSON.stringify(diagram, null, 2);
      let idx = fm.files.findIndex(f => f.name === DIAGRAM_FILENAME);
      if (idx < 0) {
        fm.files.push({ name: DIAGRAM_FILENAME, content: json, modified: true });
        idx = fm.files.length - 1;
      } else {
        fm.files[idx].content = json;
        fm.files[idx].modified = true;
      }

      // Reflect content in the editor if the diagram.json tab is already active,
      // otherwise just keep the file's content as the source of truth.
      if (fm.activeIndex === idx) {
        fm.editor.setCode(json);
      } else if (focusTab) {
        fm.switchTo(idx);
      }
      if (fm.onChange) fm.onChange();
      console.log('[DiagramSync] external diagram applied',
        { parts: diagram.parts?.length ?? 0, connections: diagram.connections?.length ?? 0, bytes: json.length, importErrors: result.errors });
    } catch (err) {
      console.error('[DiagramSync] applyExternalDiagram failed:', err);
      throw err;
    } finally {
      // Defer release past the debounce window so any straggler hook firings
      // from importDiagram don't immediately resync from the (possibly partial)
      // canvas state.
      setTimeout(() => {
        clearTimeout(this._canvasDebounceTimer);
        this._syncing = wasSyncing;
      }, 250);
    }
    return result;
  }

  /** Hook into canvas changes — update diagram.json when components/wires change */
  _hookCanvasChanges() {
    // Component added/removed
    const origAdded = this.componentPanel.onComponentAdded;
    this.componentPanel.onComponentAdded = (comp) => {
      if (origAdded) origAdded(comp);
      this._canvasToEditor();
    };

    const origRemoved = this.componentPanel.onComponentRemoved;
    this.componentPanel.onComponentRemoved = (compId) => {
      if (origRemoved) origRemoved(compId);
      this._canvasToEditor();
    };

    // Wire created/removed
    const origWireCreated = this.wireManager.onWireCreated;
    this.wireManager.onWireCreated = (wire) => {
      if (origWireCreated) origWireCreated(wire);
      this._canvasToEditor();
    };

    // Component dragged (canvas fires onDragEnd)
    const origDragEnd = this.canvas.onDragEnd;
    this.canvas.onDragEnd = () => {
      if (origDragEnd) origDragEnd();
      this._canvasToEditor();
    };
  }
}

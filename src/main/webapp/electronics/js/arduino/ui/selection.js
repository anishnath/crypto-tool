/**
 * Selection Manager — tracks selected component/wire with visual feedback.
 *
 * Features:
 *  - Click component → select (dashed border highlight)
 *  - Click empty canvas → deselect
 *  - Delete/Backspace → remove selected
 *  - Escape → deselect / cancel wire mode
 *  - R key → rotate selected component 90°
 */

export class SelectionManager {
  constructor(canvas, componentPanel) {
    this.canvas = canvas;
    this.componentPanel = componentPanel;
    this._selectedId = null;
    this._selectedType = null; // 'component' | 'wire' | null
    this._onDelete = null; // callback for wire deletion

    this._initKeyboard();
  }

  /** Get currently selected component id */
  get selectedId() { return this._selectedId; }
  get selectedType() { return this._selectedType; }

  /** Select a component by wrapper element */
  selectComponent(wrapper) {
    this.deselect();
    const id = wrapper.dataset.compId;
    if (!id) return;
    this._selectedId = id;
    this._selectedType = 'component';
    wrapper.classList.add('ard-selected');
  }

  /** Select a wire by id */
  selectWire(wireId) {
    this.deselect();
    this._selectedId = wireId;
    this._selectedType = 'wire';
  }

  /** Deselect everything */
  deselect() {
    if (this._selectedId && this._selectedType === 'component') {
      const el = document.querySelector(`[data-comp-id="${this._selectedId}"]`);
      if (el) el.classList.remove('ard-selected');
    }
    this._selectedId = null;
    this._selectedType = null;
  }

  /** Set callback for wire deletion */
  onDeleteWire(fn) { this._onDelete = fn; }

  /** Rotate the selected component by 90° */
  rotateSelected() {
    if (this._selectedType !== 'component') return;
    const comp = this.componentPanel.components.find(c => c.id === this._selectedId);
    if (!comp) return;
    const current = parseInt(comp.wrapper.dataset.rotation || '0', 10);
    const next = (current + 90) % 360;
    comp.wrapper.dataset.rotation = next;
    comp.wrapper.style.transform = `rotate(${next}deg)`;
  }

  /** Delete the selected item */
  deleteSelected() {
    if (!this._selectedId) return;
    if (this._selectedType === 'component') {
      this.componentPanel.remove(this._selectedId);
    } else if (this._selectedType === 'wire' && this._onDelete) {
      this._onDelete(this._selectedId);
    }
    this._selectedId = null;
    this._selectedType = null;
  }

  _initKeyboard() {
    document.addEventListener('keydown', (e) => {
      // Don't capture keys when typing in inputs
      const tag = e.target.tagName;
      if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return;
      // Monaco editor captures its own keys
      if (e.target.closest('.ard-editor-container')) return;

      if (e.key === 'Delete' || e.key === 'Backspace') {
        if (this._selectedId) {
          e.preventDefault();
          this.deleteSelected();
        }
      } else if (e.key === 'Escape') {
        this.deselect();
        // Also cancel wire creation if wire manager exists
        if (this._onEscape) this._onEscape();
      } else if (e.key === 'r' || e.key === 'R') {
        if (this._selectedType === 'component') {
          e.preventDefault();
          this.rotateSelected();
        }
      }
    });
  }

  /** Set Escape callback (for cancelling wire creation) */
  onEscape(fn) { this._onEscape = fn; }
}

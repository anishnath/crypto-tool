/**
 * PinOverlay — renders clickable pin dots on wokwi-elements.
 *
 * Uses div-based overlays (like Velxio) instead of a global SVG.
 * Each component gets a positioned container div at its world position,
 * with child divs at each pin's local x/y. Pins move with the component
 * automatically since they're children of the wrapper.
 */

const PIN_SIZE = 12;
const PIN_HALF = PIN_SIZE / 2;

export class PinOverlay {
  /**
   * @param {HTMLElement} worldEl - the .ard-canvas-world div
   */
  constructor(worldEl) {
    this.worldEl = worldEl;
    this._overlays = new Map(); // componentId → { container, pins[] }
    this._onPinClick = null;
    this._visible = true;
  }

  /** Set callback for pin clicks: (componentId, pinName, worldX, worldY) */
  onPinClick(fn) { this._onPinClick = fn; }

  /** Show/hide all pin dots */
  setVisible(v) {
    this._visible = v;
    for (const entry of this._overlays.values()) {
      entry.container.style.display = v ? 'block' : 'none';
    }
  }

  /**
   * Create/update pin overlay for a component.
   * @param {string} componentId
   * @param {HTMLElement} wokwiElement - the wokwi custom element
   * @param {HTMLElement} wrapper - the wrapper div (.ard-component-item or .ard-board-wrap)
   */
  updateComponent(componentId, wokwiElement, wrapper) {
    // Remove old overlay for this component
    this.removeComponent(componentId);

    // Extract pinInfo from wokwi element
    const pinInfo = wokwiElement.pinInfo;
    if (!pinInfo || !pinInfo.length) return;

    // Detect wrapper padding offset (components have 6px, board has 0)
    const style = getComputedStyle(wrapper);
    const padX = parseFloat(style.paddingLeft) || 0;
    const padY = parseFloat(style.paddingTop) || 0;

    // Create overlay container — positioned inside the wrapper so it moves with it
    const container = document.createElement('div');
    container.className = 'ard-pin-overlay-container';
    container.style.cssText = `position:absolute;top:${padY}px;left:${padX}px;pointer-events:none;z-index:30;`;
    container.dataset.overlayFor = componentId;
    container.dataset.padX = padX;
    container.dataset.padY = padY;

    const pins = [];

    for (const pin of pinInfo) {
      const dot = document.createElement('div');
      dot.className = 'ard-pin-dot';
      dot.style.cssText = `
        position:absolute;
        left:${(pin.x || 0) - PIN_HALF}px;
        top:${(pin.y || 0) - PIN_HALF}px;
        width:${PIN_SIZE}px;
        height:${PIN_SIZE}px;
        border-radius:3px;
        background:rgba(0,200,255,0.8);
        border:1.5px solid #fff;
        cursor:crosshair;
        pointer-events:all;
        transition:all .15s;
      `;
      dot.title = pin.name;
      dot.dataset.componentId = componentId;
      dot.dataset.pinName = pin.name;
      dot.dataset.pinX = pin.x || 0;
      dot.dataset.pinY = pin.y || 0;

      // Hover effect
      dot.addEventListener('mouseenter', () => {
        dot.style.background = 'rgba(0,255,100,1)';
        dot.style.transform = 'scale(1.4)';
      });
      dot.addEventListener('mouseleave', () => {
        dot.style.background = 'rgba(0,200,255,0.8)';
        dot.style.transform = 'scale(1)';
      });

      // Click to create wire
      dot.addEventListener('mousedown', (e) => {
        e.stopPropagation();
        if (!this._onPinClick) return;
        // Calculate world position: wrapper position + pin local position
        const wx = (parseFloat(wrapper.dataset.worldX) || 0) + padX + (pin.x || 0);
        const wy = (parseFloat(wrapper.dataset.worldY) || 0) + padY + (pin.y || 0);
        this._onPinClick(componentId, pin.name, wx, wy);
      });

      // Touch support
      dot.addEventListener('touchend', (e) => {
        e.stopPropagation();
        e.preventDefault();
        if (!this._onPinClick) return;
        const wx = (parseFloat(wrapper.dataset.worldX) || 0) + padX + (pin.x || 0);
        const wy = (parseFloat(wrapper.dataset.worldY) || 0) + padY + (pin.y || 0);
        this._onPinClick(componentId, pin.name, wx, wy);
      });

      container.appendChild(dot);
      pins.push({ name: pin.name, x: pin.x, y: pin.y, dot });
    }

    // Append the overlay container inside the wrapper (so it moves with the component)
    wrapper.appendChild(container);
    wrapper.style.overflow = 'visible'; // allow dots to be visible outside wrapper bounds

    this._overlays.set(componentId, { container, wrapper, pins });
  }

  /** Remove overlay for a component */
  removeComponent(componentId) {
    const entry = this._overlays.get(componentId);
    if (entry) {
      entry.container.remove();
      this._overlays.delete(componentId);
    }
  }

  /** Get pin world position */
  getPinPosition(componentId, pinName) {
    const entry = this._overlays.get(componentId);
    if (!entry) return null;
    const pin = entry.pins.find(p => p.name === pinName);
    if (!pin) return null;
    const padX = parseFloat(entry.container.dataset.padX) || 0;
    const padY = parseFloat(entry.container.dataset.padY) || 0;
    const wx = (parseFloat(entry.wrapper.dataset.worldX) || 0) + padX + (pin.x || 0);
    const wy = (parseFloat(entry.wrapper.dataset.worldY) || 0) + padY + (pin.y || 0);
    return { x: wx, y: wy };
  }

  /** Clear all overlays */
  clear() {
    for (const entry of this._overlays.values()) {
      entry.container.remove();
    }
    this._overlays.clear();
  }
}

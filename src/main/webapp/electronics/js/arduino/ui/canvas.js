/**
 * SimulatorCanvas — pan/zoom/drag canvas for the board and components.
 *
 * Inspired by Velxio's SimulatorCanvas approach:
 *   - A "world" div with CSS transform: translate(pan) scale(zoom)
 *   - Board and components are absolutely positioned inside the world
 *   - Drag to move components, drag empty space to pan, scroll to zoom
 *   - Touch: single finger = drag/pan, pinch = zoom
 */

const MIN_ZOOM = 0.3;
const MAX_ZOOM = 3;
const GRID_SIZE = 20; // snap grid

export class SimulatorCanvas {
  /**
   * @param {HTMLElement} container - the scrollable canvas area (.ard-canvas-area)
   */
  constructor(container) {
    this.container = container;

    // Create world div inside container
    this.world = document.createElement('div');
    this.world.className = 'ard-canvas-world';
    // Move existing children into world
    while (container.firstChild) {
      this.world.appendChild(container.firstChild);
    }
    container.appendChild(this.world);

    // State
    this.pan = { x: 0, y: 0 };
    this.zoom = 1;
    this._isPanning = false;
    this._panStart = { mouseX: 0, mouseY: 0, panX: 0, panY: 0 };
    this._dragTarget = null; // { element, offsetX, offsetY }
    /** @type {((element: HTMLElement) => void) | null} */
    this.onDragEnd = null; // callback after component drag finishes
    /** @type {((element: HTMLElement) => void) | null} */
    this.onDragMove = null; // callback while component drag is in progress
    /** Set true to suppress panning (e.g. during wire creation) */
    this.suppressPan = false;

    // Disable default scroll on container
    container.style.overflow = 'hidden';

    // Make the board wrap draggable
    const boardWrap = this.world.querySelector('.ard-board-wrap');
    if (boardWrap) {
      this.makeDraggable(boardWrap);
      this.setComponentPosition(boardWrap, 20, 20);
    }

    this._initMouse();
    this._initTouch();
    this._initWheel();
    this._applyTransform();
  }

  /** Convert screen coordinates to world coordinates */
  toWorld(screenX, screenY) {
    const rect = this.container.getBoundingClientRect();
    return {
      x: (screenX - rect.left - this.pan.x) / this.zoom,
      y: (screenY - rect.top - this.pan.y) / this.zoom,
    };
  }

  /** Set a component's position in world coordinates */
  setComponentPosition(element, x, y) {
    const snappedX = Math.round(x / GRID_SIZE) * GRID_SIZE;
    const snappedY = Math.round(y / GRID_SIZE) * GRID_SIZE;
    element.style.left = snappedX + 'px';
    element.style.top = snappedY + 'px';
    element.dataset.worldX = snappedX;
    element.dataset.worldY = snappedY;
  }

  /** Make a component wrapper draggable */
  makeDraggable(wrapper) {
    wrapper.style.position = 'absolute';
    wrapper.style.cursor = 'grab';

    // Default position if not set
    if (!wrapper.dataset.worldX) {
      this.setComponentPosition(wrapper, 0, 0);
    }
  }

  /** Place a component at a free position near the board */
  placeNearBoard(wrapper, index) {
    const cols = 4;
    const row = Math.floor(index / cols);
    const col = index % cols;
    this.setComponentPosition(wrapper, 320 + col * 100, 20 + row * 80);
  }

  // ── Internal ──

  _applyTransform() {
    this.world.style.transform = `translate(${this.pan.x}px, ${this.pan.y}px) scale(${this.zoom})`;
  }

  _findDraggable(target) {
    // Walk up from target to find a draggable element (component or board).
    // wokwi custom elements use Shadow DOM, so we must escape shadow roots.
    let el = target;
    const limit = 30; // safety
    for (let i = 0; i < limit && el; i++) {
      if (el === this.world || el === this.container) break;
      if (el.classList && (el.classList.contains('ard-component-item') || el.classList.contains('ard-board-wrap'))) {
        return el;
      }
      if (el.parentElement) {
        el = el.parentElement;
      } else {
        // Escape shadow DOM boundary
        const root = el.getRootNode && el.getRootNode();
        el = (root && root.host) ? root.host : null;
      }
    }
    return null;
  }

  _initMouse() {
    this.container.addEventListener('mousedown', (e) => {
      const draggable = this._findDraggable(e.target);

      if (draggable) {
        // Start component or board drag
        const world = this.toWorld(e.clientX, e.clientY);
        const cx = parseFloat(draggable.dataset.worldX) || 0;
        const cy = parseFloat(draggable.dataset.worldY) || 0;
        this._dragTarget = {
          element: draggable,
          offsetX: world.x - cx,
          offsetY: world.y - cy,
        };
        draggable.style.cursor = 'grabbing';
        draggable.style.zIndex = '10';
        e.preventDefault();
      } else if (!this.suppressPan) {
        // Start panning (click on empty canvas area) — suppressed during wire creation
        this._isPanning = true;
        this._panStart = { mouseX: e.clientX, mouseY: e.clientY, panX: this.pan.x, panY: this.pan.y };
        this.container.style.cursor = 'grabbing';
        e.preventDefault();
      }
    });

    document.addEventListener('mousemove', (e) => {
      if (this._dragTarget) {
        const world = this.toWorld(e.clientX, e.clientY);
        this.setComponentPosition(
          this._dragTarget.element,
          world.x - this._dragTarget.offsetX,
          world.y - this._dragTarget.offsetY,
        );
        if (this.onDragMove) this.onDragMove(this._dragTarget.element);
      } else if (this._isPanning) {
        this.pan.x = this._panStart.panX + (e.clientX - this._panStart.mouseX);
        this.pan.y = this._panStart.panY + (e.clientY - this._panStart.mouseY);
        this._applyTransform();
      }
    });

    document.addEventListener('mouseup', () => {
      if (this._dragTarget) {
        this._dragTarget.element.style.cursor = 'grab';
        this._dragTarget.element.style.zIndex = '';
        if (this.onDragEnd) this.onDragEnd(this._dragTarget.element);
        this._dragTarget = null;
      }
      if (this._isPanning) {
        this._isPanning = false;
        this.container.style.cursor = '';
      }
    });
  }

  _initWheel() {
    this.container.addEventListener('wheel', (e) => {
      e.preventDefault();
      const rect = this.container.getBoundingClientRect();
      const factor = e.deltaY < 0 ? 1.1 : 0.9;
      const newZoom = Math.min(MAX_ZOOM, Math.max(MIN_ZOOM, this.zoom * factor));

      // Zoom toward cursor
      const mx = e.clientX - rect.left;
      const my = e.clientY - rect.top;
      const worldX = (mx - this.pan.x) / this.zoom;
      const worldY = (my - this.pan.y) / this.zoom;

      this.zoom = newZoom;
      this.pan.x = mx - worldX * newZoom;
      this.pan.y = my - worldY * newZoom;

      this._applyTransform();
    }, { passive: false });
  }

  _initTouch() {
    let lastTouchDist = 0;
    let lastTouchCenter = { x: 0, y: 0 };
    let touchDragTarget = null;
    let touchDragOffset = { x: 0, y: 0 };
    let isPinching = false;

    this.container.addEventListener('touchstart', (e) => {
      if (e.touches.length === 2) {
        // Pinch zoom start
        isPinching = true;
        touchDragTarget = null;
        const dx = e.touches[0].clientX - e.touches[1].clientX;
        const dy = e.touches[0].clientY - e.touches[1].clientY;
        lastTouchDist = Math.hypot(dx, dy);
        lastTouchCenter = {
          x: (e.touches[0].clientX + e.touches[1].clientX) / 2,
          y: (e.touches[0].clientY + e.touches[1].clientY) / 2,
        };
        e.preventDefault();
        return;
      }

      if (e.touches.length === 1) {
        const touch = e.touches[0];
        const draggable = this._findDraggable(touch.target);

        if (draggable) {
          const world = this.toWorld(touch.clientX, touch.clientY);
          const cx = parseFloat(draggable.dataset.worldX) || 0;
          const cy = parseFloat(draggable.dataset.worldY) || 0;
          touchDragTarget = draggable;
          touchDragOffset = { x: world.x - cx, y: world.y - cy };
          e.preventDefault();
        } else if (!this.suppressPan) {
          // Pan — suppressed during wire creation
          this._isPanning = true;
          this._panStart = { mouseX: touch.clientX, mouseY: touch.clientY, panX: this.pan.x, panY: this.pan.y };
          e.preventDefault();
        }
      }
    }, { passive: false });

    this.container.addEventListener('touchmove', (e) => {
      if (isPinching && e.touches.length === 2) {
        const dx = e.touches[0].clientX - e.touches[1].clientX;
        const dy = e.touches[0].clientY - e.touches[1].clientY;
        const dist = Math.hypot(dx, dy);
        const center = {
          x: (e.touches[0].clientX + e.touches[1].clientX) / 2,
          y: (e.touches[0].clientY + e.touches[1].clientY) / 2,
        };

        const scale = dist / lastTouchDist;
        const newZoom = Math.min(MAX_ZOOM, Math.max(MIN_ZOOM, this.zoom * scale));

        const rect = this.container.getBoundingClientRect();
        const mx = center.x - rect.left;
        const my = center.y - rect.top;
        const worldX = (mx - this.pan.x) / this.zoom;
        const worldY = (my - this.pan.y) / this.zoom;

        this.zoom = newZoom;
        this.pan.x = mx - worldX * newZoom;
        this.pan.y = my - worldY * newZoom;

        // Also pan with center movement
        this.pan.x += center.x - lastTouchCenter.x;
        this.pan.y += center.y - lastTouchCenter.y;

        lastTouchDist = dist;
        lastTouchCenter = center;
        this._applyTransform();
        e.preventDefault();
        return;
      }

      if (e.touches.length === 1) {
        const touch = e.touches[0];
        if (touchDragTarget) {
          const world = this.toWorld(touch.clientX, touch.clientY);
          this.setComponentPosition(touchDragTarget, world.x - touchDragOffset.x, world.y - touchDragOffset.y);
          if (this.onDragMove) this.onDragMove(touchDragTarget);
          e.preventDefault();
        } else if (this._isPanning) {
          this.pan.x = this._panStart.panX + (touch.clientX - this._panStart.mouseX);
          this.pan.y = this._panStart.panY + (touch.clientY - this._panStart.mouseY);
          this._applyTransform();
          e.preventDefault();
        }
      }
    }, { passive: false });

    const onTouchEnd = () => {
      if (touchDragTarget && this.onDragEnd) this.onDragEnd(touchDragTarget);
      touchDragTarget = null;
      isPinching = false;
      this._isPanning = false;
      this.container.style.cursor = '';
    };
    this.container.addEventListener('touchend', onTouchEnd);
    this.container.addEventListener('touchcancel', onTouchEnd);
  }
}

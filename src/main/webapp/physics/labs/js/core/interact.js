/**
 * Interact — Mouse/Touch drag interaction system.
 *
 * Handles: mousedown → hitTest → onDrag → onRelease
 * Pure state machine + coordinate transform. DOM binding is thin wrapper.
 *
 * Design: sim.hitTest/onDrag/onRelease are optional.
 * If sim doesn't define hitTest, no drag interaction occurs.
 */

/**
 * Drag state machine (testable without DOM).
 */
export class DragState {
  constructor() {
    this.active = false;
    this.objectId = null;
    this.offset = null;
  }

  start(hitResult) {
    this.active = true;
    this.objectId = hitResult.id;
    this.offset = hitResult;
  }

  end() {
    const id = this.objectId;
    this.active = false;
    this.objectId = null;
    this.offset = null;
    return id;
  }
}

/**
 * Binds mouse/touch events to a canvas element and drives sim drag interaction.
 *
 * @param {HTMLCanvasElement} canvasEl — the simulation canvas
 * @param {object} sim — sim definition (must have hitTest/onDrag/onRelease if draggable)
 * @param {SimRunner} runner — to set isDragging flag
 * @param {function} toWorld — (pixelX, pixelY) => {wx, wy} coordinate transform
 * @returns {{ destroy: function, dragState: DragState }}
 */
export function bindInteraction(canvasEl, sim, runner, toWorld) {
  const drag = new DragState();

  // If sim has no hitTest, interaction is not supported — skip binding
  if (typeof sim.hitTest !== 'function') {
    return { destroy() {}, dragState: drag };
  }

  function getWorldPos(e) {
    const rect = canvasEl.getBoundingClientRect();
    let clientX, clientY;
    if (e.touches && e.touches.length > 0) {
      clientX = e.touches[0].clientX;
      clientY = e.touches[0].clientY;
    } else if (e.changedTouches && e.changedTouches.length > 0) {
      clientX = e.changedTouches[0].clientX;
      clientY = e.changedTouches[0].clientY;
    } else {
      clientX = e.clientX;
      clientY = e.clientY;
    }
    const px = clientX - rect.left;
    const py = clientY - rect.top;
    return toWorld(px, py);
  }

  function onPointerDown(e) {
    const { wx, wy } = getWorldPos(e);
    const hit = sim.hitTest(wx, wy, runner.state, runner.params);
    if (hit) {
      drag.start(hit);
      runner.isDragging = true;
      canvasEl.style.cursor = 'grabbing';
      if (typeof sim.onDrag === 'function') {
        sim.onDrag(hit.id, wx, wy, hit, runner.state, runner.params);
      }
      e.preventDefault();
    }
  }

  function onPointerMove(e) {
    const { wx, wy } = getWorldPos(e);

    if (drag.active) {
      // Active drag — update sim state
      if (typeof sim.onDrag === 'function') {
        sim.onDrag(drag.objectId, wx, wy, drag.offset, runner.state, runner.params);
      }
      e.preventDefault();
    } else {
      // Hover — change cursor if near draggable object
      const hit = sim.hitTest(wx, wy, runner.state, runner.params);
      canvasEl.style.cursor = hit ? 'grab' : 'default';
    }
  }

  function onPointerUp(e) {
    if (!drag.active) return;
    const id = drag.end();
    runner.isDragging = false;
    canvasEl.style.cursor = 'default';
    if (typeof sim.onRelease === 'function') {
      sim.onRelease(id, runner.state, runner.params);
    }
  }

  // Mouse events
  canvasEl.addEventListener('mousedown', onPointerDown);
  canvasEl.addEventListener('mousemove', onPointerMove);
  window.addEventListener('mouseup', onPointerUp);

  // Touch events (mirror mouse)
  canvasEl.addEventListener('touchstart', onPointerDown, { passive: false });
  canvasEl.addEventListener('touchmove', onPointerMove, { passive: false });
  window.addEventListener('touchend', onPointerUp);

  function destroy() {
    canvasEl.removeEventListener('mousedown', onPointerDown);
    canvasEl.removeEventListener('mousemove', onPointerMove);
    window.removeEventListener('mouseup', onPointerUp);
    canvasEl.removeEventListener('touchstart', onPointerDown);
    canvasEl.removeEventListener('touchmove', onPointerMove);
    window.removeEventListener('touchend', onPointerUp);
  }

  return { destroy, dragState: drag };
}

/**
 * Transport — Play/Pause/Reset/Step buttons + speed control + keyboard shortcuts.
 */

export function buildTransport(containerEl, runner) {
  const bar = document.createElement('div');
  bar.className = 'lab-transport';

  // Play/Pause
  const playBtn = makeBtn('▶', 'Play', () => runner.toggle());
  bar.appendChild(playBtn);

  // Reset
  const resetBtn = makeBtn('↺', 'Reset', () => { runner.reset(); updatePlayBtn(); });
  bar.appendChild(resetBtn);

  // Step
  const stepBtn = makeBtn('⏭', 'Step', () => { runner.pause(); runner.step(); updatePlayBtn(); });
  bar.appendChild(stepBtn);

  // Speed
  const speedWrap = document.createElement('div');
  speedWrap.className = 'transport-speed';
  const speedLabel = document.createElement('span');
  speedLabel.className = 'speed-label';
  speedLabel.textContent = '1x';
  const speedSel = document.createElement('select');
  speedSel.className = 'speed-select';
  [0.25, 0.5, 1, 2, 4].forEach(s => {
    const o = document.createElement('option');
    o.value = s; o.textContent = s + 'x';
    if (s === 1) o.selected = true;
    speedSel.appendChild(o);
  });
  speedSel.addEventListener('change', () => {
    const v = parseFloat(speedSel.value);
    runner.setSpeed(v);
    speedLabel.textContent = v + 'x';
  });
  speedWrap.appendChild(speedLabel);
  speedWrap.appendChild(speedSel);
  bar.appendChild(speedWrap);

  containerEl.appendChild(bar);

  function updatePlayBtn() {
    playBtn.textContent = runner.playing ? '⏸' : '▶';
    playBtn.title = runner.playing ? 'Pause' : 'Play';
  }

  // Update button state on play/pause
  const origPlay = runner.play.bind(runner);
  const origPause = runner.pause.bind(runner);
  runner.play = function() { origPlay(); updatePlayBtn(); };
  runner.pause = function() { origPause(); updatePlayBtn(); };

  // Keyboard shortcuts
  function onKey(e) {
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.tagName === 'SELECT') return;
    if (e.key === ' ') { e.preventDefault(); runner.toggle(); updatePlayBtn(); }
    if (e.key === 'r' || e.key === 'R') { runner.reset(); updatePlayBtn(); }
    if (e.key === 'ArrowRight') { runner.pause(); runner.step(); updatePlayBtn(); }
  }
  document.addEventListener('keydown', onKey);

  return {
    destroy() { document.removeEventListener('keydown', onKey); },
    updatePlayBtn,
  };
}

function makeBtn(icon, title, onClick) {
  const btn = document.createElement('button');
  btn.className = 'transport-btn';
  btn.textContent = icon;
  btn.title = title;
  btn.addEventListener('click', onClick);
  return btn;
}

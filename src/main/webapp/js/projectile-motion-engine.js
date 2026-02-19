(function(){
  // helpers
  function $(id){ return document.getElementById(id); }
  function fmt(n){ if(!isFinite(n)) return '–'; return (Math.round(n*1000)/1000).toString(); }
  function toRad(deg){ return deg * Math.PI/180; }
  function toDeg(rad){ return rad * 180 / Math.PI; }

  // Elements
  const preset = $('preset');
  const v0 = $('v0');
  const angle = $('angle');
  const y0 = $('y0');
  const g = $('g');
  const dragOn = $('dragOn');
  const dragCfg = $('dragCfg');
  const rho = $('rho');
  const cd = $('cd');
  const area = $('area');
  const mass = $('mass');
  const scale = $('scale');
  const speedSel = $('speed');
  const showOverlay = $('showOverlay');
  const scrub = $('scrub');
  // Dock controls
  const dockAngle = $('dockAngle');
  const dockV0 = $('dockV0');
  const dockPreset = $('dockPreset');
  const dockDragOn = $('dockDragOn');
  const dockKeep = $('dockKeep');
  const dockVectors = $('dockVectors');
  const dockAutoScale = $('dockAutoScale');
  const dockLaunch = $('dockLaunch');
  const dockResetShots = $('dockResetShots');
  const dockY0 = $('dockY0');
  const dockScale = $('dockScale');
  const dockG = $('dockG');
  const err = $('err');
  const canvas = $('traj');
  const ctx = canvas.getContext('2d');
  // Air resistance range sliders
  const rhoRange = $('rhoRange');
  const cdRange = $('cdRange');
  const areaRange = $('areaRange');
  const massRange = $('massRange');
  const rhoValue = $('rhoValue');
  const cdValue = $('cdValue');
  const areaValue = $('areaValue');
  const massValue = $('massValue');

  let data = {points:[], overlay:[], tv:[], vv:[], tTotal:0, apexIdx:0};
  let anim = {running:false, t:0, last:0, speed:1};
  let velChart, energyChart;
  let shots = []; // previous shots [{points,color}]
  const shotColors = ['#94a3b8','#a78bfa','#f472b6','#22c55e','#f59e0b'];
  let nextShotIdx = 0;
  // target (draggable)
  let target = {x: 30, y: 5, r: 1.0, hit:false};
  let draggingTarget = false;
  // drag to set velocity
  let draggingLaunch = false;

  // Presets - Gravity values for celestial bodies
  const gravityPresets = {
    'mercury': 3.7,
    'venus': 8.87,
    'earth': 9.81,
    'mars': 3.71,
    'jupiter': 24.79,
    'saturn': 10.44,
    'uranus': 8.87,
    'neptune': 11.15,
    'moon': 1.62,
    'europa': 1.31,
    'titan': 1.35,
    'pluto': 0.62,
    'ceres': 0.27,
    'sun': 274,
    'whitedwarf': 3000000
  };

  preset.addEventListener('change', ()=>{
    if(gravityPresets[preset.value]) {
      g.value = gravityPresets[preset.value];
    }
  });

  dragOn.addEventListener('change', ()=>{
    dragCfg.style.display = dragOn.checked ? 'block' : 'none';
  });

  function niceStep(totalMeters){
    const steps=[1,2,5,10,20,50,100,200,500,1000];
    for(let i=0;i<steps.length;i++){
      if(totalMeters/steps[i] <= 12) return steps[i];
    }
    return 1000;
  }
  function drawBackground(){
    ctx.clearRect(0,0,canvas.width, canvas.height);
    const s = parseFloat(scale.value)||4;
    const ox = 30, oy = canvas.height-30;

    // Subtle gradient background
    const grd = ctx.createLinearGradient(0,0,canvas.width,canvas.height);
    grd.addColorStop(0,'rgba(102,126,234,0.02)');
    grd.addColorStop(0.5,'rgba(118,75,162,0.02)');
    grd.addColorStop(1,'rgba(240,147,251,0.02)');
    ctx.fillStyle = grd;
    ctx.fillRect(0,0,canvas.width,canvas.height);

    // grid with labels
    ctx.save();
    ctx.fillStyle = '#64748b';
    ctx.font = '600 11px system-ui, -apple-system, Segoe UI, Roboto, sans-serif';
    const widthMeters = (canvas.width-ox-10)/s;
    const heightMeters = (oy-10)/s;
    const step = niceStep(widthMeters);

    // Vertical grid lines
    for(let xm=0; xm<=widthMeters; xm+=step){
      const x = ox + xm*s;
      ctx.strokeStyle = xm % (step*2) === 0 ? 'rgba(102,126,234,0.15)' : 'rgba(102,126,234,0.08)';
      ctx.lineWidth = xm % (step*2) === 0 ? 1.2 : 0.8;
      ctx.beginPath(); ctx.moveTo(x,10); ctx.lineTo(x,oy); ctx.stroke();
      if(xm>0){
        ctx.fillStyle = '#64748b';
        ctx.fillText(xm+' m', x-10, oy+14);
      }
    }

    // Horizontal grid lines
    const yStep = niceStep(heightMeters);
    for(let ym=0; ym<=heightMeters; ym+=yStep){
      const y = oy - ym*s;
      ctx.strokeStyle = ym % (yStep*2) === 0 ? 'rgba(118,75,162,0.15)' : 'rgba(118,75,162,0.08)';
      ctx.lineWidth = ym % (yStep*2) === 0 ? 1.2 : 0.8;
      ctx.beginPath(); ctx.moveTo(ox,y); ctx.lineTo(canvas.width-10,y); ctx.stroke();
      if(ym>0){
        ctx.fillStyle = '#64748b';
        ctx.fillText(ym+' m', 4, y+4);
      }
    }

    // axes with gradient
    const axisGrd = ctx.createLinearGradient(ox,oy,canvas.width,10);
    axisGrd.addColorStop(0,'#667eea');
    axisGrd.addColorStop(1,'#764ba2');
    ctx.strokeStyle = axisGrd;
    ctx.lineWidth = 2.5;
    ctx.beginPath(); ctx.moveTo(ox,oy); ctx.lineTo(canvas.width-10,oy); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(ox,oy); ctx.lineTo(ox,10); ctx.stroke();
    ctx.restore();
  }

  function drawPath(points){
    if(!points.length) return;
    const s = parseFloat(scale.value)||4;
    const ox = 30, oy = canvas.height-30;
    ctx.save();

    // Glow effect
    ctx.shadowBlur = 8;
    ctx.shadowColor = 'rgba(14,165,233,0.5)';

    // Gradient path
    const firstPt = points[0];
    const lastPt = points[points.length-1];
    const grd = ctx.createLinearGradient(ox + firstPt.x*s, oy - firstPt.y*s, ox + lastPt.x*s, oy - lastPt.y*s);
    grd.addColorStop(0,'#0ea5e9');
    grd.addColorStop(0.5,'#06b6d4');
    grd.addColorStop(1,'#0891b2');

    ctx.strokeStyle = grd;
    ctx.lineWidth = 3;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    ctx.beginPath();
    for(let i=0;i<points.length;i++){
      const p = points[i];
      const x = ox + p.x * s;
      const y = oy - p.y * s;
      if(i===0) ctx.moveTo(x,y); else ctx.lineTo(x,y);
    }
    ctx.stroke();
    ctx.restore();
  }

  function drawOverlay(points){
    if(!points.length) return;
    const s = parseFloat(scale.value)||4; const ox = 30, oy = canvas.height-30;
    ctx.save();
    ctx.setLineDash([8,6]);
    ctx.strokeStyle = '#818cf8';
    ctx.lineWidth = 2;
    ctx.globalAlpha = 0.6;
    ctx.shadowBlur = 6;
    ctx.shadowColor = 'rgba(99,102,241,0.3)';
    ctx.beginPath();
    for(let i=0;i<points.length;i++){
      const p = points[i]; const x = ox + p.x*s; const y = oy - p.y*s;
      if(i===0) ctx.moveTo(x,y); else ctx.lineTo(x,y);
    }
    ctx.stroke(); ctx.restore();
  }

  function drawBall(p){
    const s = parseFloat(scale.value)||4; const ox = 30, oy = canvas.height-30;
    const x = ox + p.x * s; const y = oy - p.y * s;
    ctx.save();

    // velocity arrow with gradient and glow
    const v = Math.hypot(p.vx||0,p.vy||0);
    if(v>0){
      const vxn = (p.vx||0)/v, vyn = (p.vy||0)/v;
      const len = Math.min(50, 10 + v*1.5);
      const arrowX = x + vxn*len, arrowY = y - vyn*len;

      // Arrow gradient
      const arrGrd = ctx.createLinearGradient(x,y,arrowX,arrowY);
      arrGrd.addColorStop(0,'#f97316');
      arrGrd.addColorStop(1,'#ef4444');

      ctx.strokeStyle = arrGrd;
      ctx.lineWidth = 3;
      ctx.lineCap = 'round';
      ctx.shadowBlur = 8;
      ctx.shadowColor = 'rgba(239,68,68,0.5)';
      ctx.beginPath();
      ctx.moveTo(x,y);
      ctx.lineTo(arrowX, arrowY);
      ctx.stroke();

      // Arrowhead
      const angle = Math.atan2(-vyn, vxn);
      const headLen = 8;
      ctx.fillStyle = '#ef4444';
      ctx.beginPath();
      ctx.moveTo(arrowX, arrowY);
      ctx.lineTo(arrowX - headLen*Math.cos(angle-Math.PI/6), arrowY + headLen*Math.sin(angle-Math.PI/6));
      ctx.lineTo(arrowX - headLen*Math.cos(angle+Math.PI/6), arrowY + headLen*Math.sin(angle+Math.PI/6));
      ctx.closePath();
      ctx.fill();
    }

    // ball with radial gradient and glow
    const ballGrd = ctx.createRadialGradient(x-2,y-2,1,x,y,8);
    ballGrd.addColorStop(0,'#fca5a5');
    ballGrd.addColorStop(0.4,'#ef4444');
    ballGrd.addColorStop(1,'#dc2626');
    ctx.fillStyle = ballGrd;
    ctx.shadowBlur = 12;
    ctx.shadowColor = 'rgba(239,68,68,0.6)';
    ctx.beginPath();
    ctx.arc(x,y,7,0,Math.PI*2);
    ctx.fill();

    // Highlight
    ctx.shadowBlur = 0;
    ctx.fillStyle = 'rgba(255,255,255,0.5)';
    ctx.beginPath();
    ctx.arc(x-1.5,y-1.5,2,0,Math.PI*2);
    ctx.fill();

    ctx.restore();
  }

  function drawComponents(p){
    if(!dockVectors.checked) return;
    const s = parseFloat(scale.value)||4; const ox=30, oy=canvas.height-30;
    const x = ox + p.x*s; const y = oy - p.y*s;
    const v = Math.hypot(p.vx||0,p.vy||0);
    if(v<=0) return;
    const k = 1.5; // pixel scale for arrow length
    ctx.save();

    // vx component (blue) with glow
    ctx.strokeStyle = '#3b82f6';
    ctx.lineWidth = 2.5;
    ctx.lineCap = 'round';
    ctx.shadowBlur = 6;
    ctx.shadowColor = 'rgba(59,130,246,0.5)';
    ctx.setLineDash([4,4]);
    ctx.beginPath();
    ctx.moveTo(x,y);
    ctx.lineTo(x + (p.vx||0)*k, y);
    ctx.stroke();

    // vy component (green) with glow
    ctx.strokeStyle = '#10b981';
    ctx.shadowColor = 'rgba(16,185,129,0.5)';
    ctx.beginPath();
    ctx.moveTo(x,y);
    ctx.lineTo(x, y - (p.vy||0)*k);
    ctx.stroke();

    ctx.restore();
  }

  function drawCannon(){
    const s = parseFloat(scale.value)||4; const ox=30, oy=canvas.height-30;
    ctx.save();

    // Base platform with gradient
    const baseGrd = ctx.createLinearGradient(ox-12, oy-8, ox+12, oy);
    baseGrd.addColorStop(0,'#1e293b');
    baseGrd.addColorStop(1,'#334155');
    ctx.fillStyle = baseGrd;
    ctx.shadowBlur = 6;
    ctx.shadowColor = 'rgba(0,0,0,0.3)';
    ctx.fillRect(ox-12, oy-8, 24, 8);

    // Cannon mount (circle)
    ctx.shadowBlur = 8;
    ctx.shadowColor = 'rgba(0,0,0,0.4)';
    const mountGrd = ctx.createRadialGradient(ox-2,oy-6,2,ox,oy-4,10);
    mountGrd.addColorStop(0,'#475569');
    mountGrd.addColorStop(1,'#334155');
    ctx.fillStyle = mountGrd;
    ctx.beginPath();
    ctx.arc(ox, oy-4, 8, 0, Math.PI*2);
    ctx.fill();

    // barrel aligned with launch angle
    const ang = toRad(parseFloat(angle.value)||0);
    const len = 32;
    ctx.translate(ox, oy-4);
    ctx.rotate(-ang);

    const barrelGrd = ctx.createLinearGradient(0, -5, len, 5);
    barrelGrd.addColorStop(0,'#64748b');
    barrelGrd.addColorStop(0.5,'#475569');
    barrelGrd.addColorStop(1,'#64748b');
    ctx.fillStyle = barrelGrd;
    ctx.shadowBlur = 4;
    ctx.shadowColor = 'rgba(0,0,0,0.3)';

    // Main barrel body
    ctx.beginPath();
    ctx.roundRect(0, -5, len, 10, 2);
    ctx.fill();

    // Barrel ring detail
    ctx.fillStyle = '#334155';
    ctx.fillRect(4, -5, 2, 10);
    ctx.fillRect(len-6, -5, 2, 10);

    // Muzzle
    ctx.fillStyle = '#1e293b';
    ctx.fillRect(len-1, -4, 2, 8);

    ctx.restore();
  }

  function drawTarget(){
    const s = parseFloat(scale.value)||4; const ox=30, oy=canvas.height-30;
    const x = ox + target.x*s; const y = oy - target.y*s; const rpx = Math.max(8, target.r*s);
    ctx.save();

    const hitColor = target.hit ? '#10b981' : '#ef4444';
    const glowColor = target.hit ? 'rgba(16,185,129,0.3)' : 'rgba(239,68,68,0.3)';

    // Glow effect
    ctx.shadowBlur = 12;
    ctx.shadowColor = glowColor;

    // Outer ring
    ctx.strokeStyle = hitColor;
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.arc(x,y,rpx,0,Math.PI*2);
    ctx.stroke();

    // Middle ring
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    ctx.arc(x,y,rpx*0.65,0,Math.PI*2);
    ctx.stroke();

    // Inner ring
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(x,y,rpx*0.35,0,Math.PI*2);
    ctx.stroke();

    // Center dot with radial gradient
    ctx.shadowBlur = 8;
    const centerGrd = ctx.createRadialGradient(x,y,0,x,y,4);
    centerGrd.addColorStop(0,'#fff');
    centerGrd.addColorStop(0.6,hitColor);
    centerGrd.addColorStop(1,hitColor);
    ctx.fillStyle = centerGrd;
    ctx.beginPath();
    ctx.arc(x,y,3,0,Math.PI*2);
    ctx.fill();

    ctx.restore();
  }

  function drawShots(){
    const s = parseFloat(scale.value)||4; const ox=30, oy=canvas.height-30;
    for(let i=0;i<shots.length;i++){
      const sh = shots[i];
      const pts = sh.points; if(!pts || !pts.length) continue;
      ctx.save();
      ctx.strokeStyle = sh.color;
      ctx.globalAlpha = 0.5;
      ctx.lineWidth = 2;
      ctx.lineCap = 'round';
      ctx.lineJoin = 'round';
      ctx.shadowBlur = 4;
      ctx.shadowColor = sh.color;
      ctx.beginPath();
      for(let j=0;j<pts.length;j++){
        const p = pts[j]; const x = ox + p.x*s; const y = oy - p.y*s;
        if(j===0) ctx.moveTo(x,y); else ctx.lineTo(x,y);
      }
      ctx.stroke(); ctx.restore();
    }
  }

  function drawMarkers(points){
    if(!points.length) return;
    const s = parseFloat(scale.value)||4; const ox = 30, oy = canvas.height-30;
    ctx.save();

    // Find Apex
    let iA = 0, yMax = -1e9;
    for(let i=0;i<points.length;i++){
      if(points[i].y>yMax){ yMax=points[i].y; iA=i; }
    }
    const apex = points[iA];
    let x = ox + apex.x*s, y = oy - apex.y*s;

    // Apex marker with glow
    ctx.shadowBlur = 10;
    ctx.shadowColor = 'rgba(16,185,129,0.5)';
    const apexGrd = ctx.createRadialGradient(x,y,0,x,y,6);
    apexGrd.addColorStop(0,'#d1fae5');
    apexGrd.addColorStop(0.6,'#10b981');
    apexGrd.addColorStop(1,'#059669');
    ctx.fillStyle = apexGrd;
    ctx.beginPath();
    ctx.arc(x,y,5,0,Math.PI*2);
    ctx.fill();

    // Apex label with background - positioned to avoid canvas edges
    ctx.shadowBlur = 0;
    ctx.font='600 12px system-ui';
    const apexText = 'Apex '+fmt(apex.y)+' m';
    const apexMetrics = ctx.measureText(apexText);
    const apexLabelWidth = apexMetrics.width + 10;
    const apexLabelHeight = 18;

    // Calculate label position - default to right of point
    let apexLabelX = x + 10;
    let apexLabelY = y - 20;

    // Adjust if too close to right edge - place on left instead
    if(apexLabelX + apexLabelWidth > canvas.width - 5){
      apexLabelX = x - apexLabelWidth - 10;
    }
    // Adjust if too close to top edge
    if(apexLabelY < 5) apexLabelY = y + 10;

    // Draw background
    ctx.fillStyle = 'rgba(16,185,129,0.95)';
    ctx.beginPath();
    ctx.roundRect(apexLabelX, apexLabelY, apexLabelWidth, apexLabelHeight, 5);
    ctx.fill();

    // Draw text
    ctx.fillStyle = '#fff';
    ctx.textAlign = 'left';
    ctx.fillText(apexText, apexLabelX + 5, apexLabelY + 13);
    ctx.textAlign = 'start'; // reset

    // Landing point
    const land = points[points.length-1];
    const xl = ox + land.x*s;
    const yl = oy - land.y*s;

    // Landing impact marker (X with circle)
    ctx.shadowBlur = 12;
    ctx.shadowColor = 'rgba(249,115,22,0.5)';

    // Outer glow circle
    const impactGrd = ctx.createRadialGradient(xl,oy,0,xl,oy,15);
    impactGrd.addColorStop(0,'rgba(249,115,22,0.4)');
    impactGrd.addColorStop(0.5,'rgba(249,115,22,0.2)');
    impactGrd.addColorStop(1,'rgba(249,115,22,0)');
    ctx.fillStyle = impactGrd;
    ctx.beginPath();
    ctx.arc(xl,oy,15,0,Math.PI*2);
    ctx.fill();

    // Impact circle
    ctx.strokeStyle = '#f97316';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.arc(xl,oy,8,0,Math.PI*2);
    ctx.stroke();

    // X mark inside
    ctx.strokeStyle = '#f97316';
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    ctx.moveTo(xl-5,oy-5);
    ctx.lineTo(xl+5,oy+5);
    ctx.moveTo(xl+5,oy-5);
    ctx.lineTo(xl-5,oy+5);
    ctx.stroke();

    // Vertical dashed line to show landing position
    ctx.strokeStyle = '#8b5cf6';
    ctx.lineWidth = 2;
    ctx.setLineDash([6,4]);
    ctx.shadowBlur = 8;
    ctx.shadowColor = 'rgba(139,92,246,0.3)';
    ctx.beginPath();
    ctx.moveTo(xl, oy);
    ctx.lineTo(xl, 10);
    ctx.stroke();
    ctx.setLineDash([]);

    // Range label with background - positioned ABOVE the impact point to stay in canvas
    ctx.shadowBlur = 0;
    const rangeText = 'Landing: '+fmt(land.x)+' m';
    const rangeMetrics = ctx.measureText(rangeText);

    // Calculate label position - keep it within canvas bounds
    let labelX = xl - rangeMetrics.width/2 - 6;
    const labelWidth = rangeMetrics.width + 12;
    const labelHeight = 20;
    const labelY = oy - 35; // Position ABOVE the ground line

    // Adjust if too close to left edge
    if(labelX < 5) labelX = 5;
    // Adjust if too close to right edge
    if(labelX + labelWidth > canvas.width - 5) labelX = canvas.width - labelWidth - 5;

    // Draw background box (above the impact point)
    ctx.fillStyle = 'rgba(249,115,22,0.95)';
    ctx.beginPath();
    ctx.roundRect(labelX, labelY, labelWidth, labelHeight, 5);
    ctx.fill();

    // Add small triangle pointer pointing DOWN to landing spot
    const triangleCenterX = Math.max(labelX + 8, Math.min(xl, labelX + labelWidth - 8));
    ctx.beginPath();
    ctx.moveTo(triangleCenterX, labelY + labelHeight);
    ctx.lineTo(triangleCenterX-6, labelY + labelHeight + 6);
    ctx.lineTo(triangleCenterX+6, labelY + labelHeight + 6);
    ctx.closePath();
    ctx.fill();

    // Draw text
    ctx.fillStyle = '#fff';
    ctx.font='700 12px system-ui';
    ctx.textAlign = 'left';
    ctx.fillText(rangeText, labelX + 6, labelY + 14);
    ctx.textAlign = 'start'; // reset

    ctx.restore();
  }

  function closedForm(v0_, th_, y0_, g_){
    // return {t, range, hmax, vf}
    const v0x = v0_*Math.cos(th_); const v0y = v0_*Math.sin(th_);
    // Solve y(t) = y0 + v0y t - 0.5 g t^2 = 0 for t>0
    const a = -0.5*g_, b = v0y, c = y0_;
    const disc = b*b - 4*a*c;
    let t = 0;
    if(disc >= 0){
      const t1 = (-b + Math.sqrt(disc)) / (2*a);
      const t2 = (-b - Math.sqrt(disc)) / (2*a);
      t = Math.max(t1, t2);
    } else { t = 0; }
    const range = v0x * t;
    const t_h = v0y/g_;
    const hmax = y0_ + v0y*t_h - 0.5*g_*t_h*t_h;
    const vyf = v0y - g_*t;
    const vf = Math.sqrt(v0x*v0x + vyf*vyf);
    return {t, range, hmax, vf};
  }

  function autoAdjustScale(points){
    if(!points.length || !dockAutoScale.checked) return;

    const s = parseFloat(scale.value)||4;
    const ox = 30, oy = canvas.height-30;

    // Find max X and Y in trajectory
    let maxX = 0, maxY = 0;
    for(let i=0;i<points.length;i++){
      maxX = Math.max(maxX, points[i].x);
      maxY = Math.max(maxY, points[i].y);
    }

    // Available canvas space
    const availableWidth = canvas.width - ox - 20;
    const availableHeight = oy - 20;

    // Calculate required scale
    const scaleX = availableWidth / maxX;
    const scaleY = availableHeight / maxY;
    const newScale = Math.min(scaleX, scaleY) * 0.9; // 0.9 for padding

    // Only adjust if trajectory goes beyond canvas OR if it's too small
    const currentPixelsX = maxX * s;
    const currentPixelsY = maxY * s;

    if(currentPixelsX > availableWidth || currentPixelsY > availableHeight ||
       (currentPixelsX < availableWidth*0.5 && currentPixelsY < availableHeight*0.5)){
      const adjustedScale = Math.max(0.5, Math.min(20, newScale));
      scale.value = adjustedScale.toFixed(2);
      dockScale.value = adjustedScale.toFixed(2);

      // Show notification that scale was adjusted
      showScaleNotification(adjustedScale);
    }
  }

  function showScaleNotification(newScale){
    // Create or update notification
    let notification = document.getElementById('scaleNotification');
    if(!notification){
      notification = document.createElement('div');
      notification.id = 'scaleNotification';
      notification.style.cssText = 'position:fixed;top:80px;right:20px;background:linear-gradient(135deg,#667eea,#764ba2);color:#fff;padding:0.8rem 1.2rem;border-radius:8px;box-shadow:0 4px 12px rgba(102,126,234,0.4);font-size:0.9rem;font-weight:600;z-index:9999;transition:all 0.3s ease;';
      document.body.appendChild(notification);
    }
    notification.textContent = `Scale auto-adjusted to ${newScale.toFixed(2)} m→px`;
    notification.style.opacity = '1';
    notification.style.transform = 'translateX(0)';

    // Hide after 2 seconds
    setTimeout(()=>{
      notification.style.opacity = '0';
      notification.style.transform = 'translateX(400px)';
    }, 2000);
  }

  function simulate(){
    err.style.display='none'; err.textContent='';
    const v0n = parseFloat(v0.value)||0;
    const ang = toRad(parseFloat(angle.value)||0);
    const y0n = parseFloat(y0.value)||0;
    const gn = parseFloat(g.value)||9.81;
    if(v0n<=0 || gn<=0){ err.style.display='block'; err.textContent='Initial speed and gravity must be > 0.'; return; }

    const useDrag = dragOn.checked;
    const v0x = v0n*Math.cos(ang); const v0y = v0n*Math.sin(ang);

    let points = [], tv=[], vv=[], overlay=[];
    // Always compute no-drag overlay (for dashed comparison)
    (function(){
      const cf = closedForm(v0n, ang, y0n, gn);
      const steps = 400;
      for(let i=0;i<=steps;i++){
        const t = cf.t * (i/steps);
        const x = v0x*t;
        const y = y0n + v0y*t - 0.5*gn*t*t;
        const vx = v0x; const vy = v0y - gn*t;
        overlay.push({t,x,y,vx,vy});
      }
    })();

    if(!useDrag){
      // sample analytic path
      const cf = closedForm(v0n, ang, y0n, gn);
      const steps = 400;
      for(let i=0;i<=steps;i++){
        const t = cf.t * (i/steps);
        const x = v0x*t;
        const y = y0n + v0y*t - 0.5*gn*t*t;
        const vx = v0x; const vy = v0y - gn*t;
        points.push({t,x,y,vx,vy});
        vv.push(Math.hypot(vx,vy)); tv.push(t);
      }
      $('res_t').textContent = fmt(cf.t) + ' s';
      $('res_r').textContent = fmt(cf.range) + ' m';
      $('res_h').textContent = fmt(cf.hmax) + ' m';
      $('res_vf').textContent = fmt(cf.vf) + ' m/s';
    } else {
      // quadratic drag: Fd = 0.5*rho*Cd*A*v^2, a = -Fd/m * v_hat - g j
      const rhoN = parseFloat(rho.value)||1.225;
      const cdN = parseFloat(cd.value)||0.47;
      const aN = parseFloat(area.value)||0.01;
      const mN = parseFloat(mass.value)||0.2;
      const k = 0.5*rhoN*cdN*aN/mN; // accel term k*v*v
      let x=0,y=y0n, vx=v0x, vy=v0y;
      let t=0, dt=0.005; // small step
      const maxT = 60; const maxSteps = 120000;
      while(y>=0 && t<maxT && points.length<maxSteps){
        const v = Math.hypot(vx,vy);
        const ax = -k*v*vx;
        const ay = -gn - k*v*vy;
        // Euler step
        vx += ax*dt; vy += ay*dt;
        x += vx*dt; y += vy*dt;
        t += dt;
        if(y<0) break;
        points.push({t,x,y,vx,vy}); tv.push(t); vv.push(Math.hypot(vx,vy));
      }
      const range = points.length? points[points.length-1].x : 0;
      const ttot = points.length? points[points.length-1].t : 0;
      const hmax = points.reduce((m,p)=> Math.max(m,p.y), y0n);
      const vf = vv.length? vv[vv.length-1] : 0;
      $('res_t').textContent = fmt(ttot) + ' s';
      $('res_r').textContent = fmt(range) + ' m';
      $('res_h').textContent = fmt(hmax) + ' m';
      $('res_vf').textContent = fmt(vf) + ' m/s';
    }

    data = {points, overlay, tv, vv, tTotal: (points.length? points[points.length-1].t : 0)};

    // Auto-adjust scale to fit trajectory
    autoAdjustScale(points);

    // check hit
    target.hit = false;
    for(let i=0;i<points.length;i++){
      const p = points[i]; const dx = p.x - target.x; const dy = p.y - target.y;
      if(Math.hypot(dx,dy) <= target.r){ target.hit = true; break; }
    }
    // set scrub to start
    scrub.value = 0;
    drawBackground();
    drawCannon();
    if(showOverlay.checked) drawOverlay(overlay);
    drawShots();
    drawPath(points);
    drawMarkers(points);
    drawTarget();
    // reset anim
    anim.running = false; anim.t = 0; anim.last = 0; $('btnPlay').textContent = 'Play';
    plotVelocity(tv, vv);
    initOrUpdateEnergyChart();
    if(points.length){ updateHUD(points[0]); updateEnergy(points[0]); }
  }

  function plotVelocity(t, v){
    const ctxC = document.getElementById('velChart');
    if(velChart) velChart.destroy();
    velChart = new Chart(ctxC, {
      type: 'line',
      data: { labels: t, datasets: [{ label: 'Speed (m/s)', data: v, borderColor:'#0ea5e9', pointRadius:0, tension:.15 }] },
      options: { responsive: true, scales: { x: { title:{display:true,text:'Time (s)'} }, y: { title:{display:true,text:'Speed (m/s)'} } }, plugins:{legend:{display:false}} }
    });
  }

  function initOrUpdateEnergyChart(){
    const ctxE = document.getElementById('energyChart');
    if(energyChart) return; // init once; we'll update values
    energyChart = new Chart(ctxE, {
      type: 'bar',
      data: {
        labels: ['Energy'],
        datasets: [
          {label:'KE', data:[0], backgroundColor:'#3b82f6'},
          {label:'PE', data:[0], backgroundColor:'#10b981'}
        ]
      },
      options: { responsive:true, scales:{ x:{ stacked:true }, y:{ stacked:true, title:{display:true,text:'Joules'} } } }
    });
  }
  function updateEnergy(p){
    if(!energyChart) return;
    const gn = parseFloat(g.value)||9.81; const mN = parseFloat(mass.value)||1;
    const v = Math.hypot(p.vx||0,p.vy||0);
    const KE = 0.5*mN*v*v;
    const PE = Math.max(0, mN*gn*Math.max(0,p.y||0));
    energyChart.data.datasets[0].data[0] = KE;
    energyChart.data.datasets[1].data[0] = PE;
    energyChart.update('none');
  }

  function updateHUD(p){
    $('hud_t').textContent = fmt(p.t)+' s';
    $('hud_x').textContent = fmt(p.x)+' m';
    $('hud_y').textContent = fmt(p.y)+' m';
    $('hud_vx').textContent = fmt(p.vx)+' m/s';
    $('hud_vy').textContent = fmt(p.vy)+' m/s';
    const v = Math.hypot(p.vx||0,p.vy||0);
    $('hud_v').textContent = fmt(v)+' m/s';
    const th = Math.atan2(p.vy||0,p.vx||0);
    $('hud_th').textContent = fmt(toDeg(th))+'°';
  }

  function getPointAtTime(t){
    if(!data.points.length) return null;
    let i=0; while(i<data.points.length-1 && data.points[i].t < t) i++;
    return data.points[Math.min(i, data.points.length-1)];
  }

  function stepAnim(ts){
    if(!anim.running) return;
    if(!anim.last) anim.last = ts;
    const dt = (ts - anim.last)/1000 * (parseFloat(speedSel.value)||1); // seconds * speed
    anim.last = ts; anim.t += dt;
    if(!data.points.length){ anim.running=false; return; }
    // find closest point by time
    let i = 0;
    while(i < data.points.length-1 && data.points[i].t < anim.t) i++;
    const p = data.points[Math.min(i, data.points.length-1)];
    drawBackground(); drawCannon(); if(showOverlay.checked) drawOverlay(data.overlay); drawShots(); drawPath(data.points); drawMarkers(data.points); drawTarget(); drawBall(p); drawComponents(p);
    updateHUD(p); updateEnergy(p);
    scrub.value = Math.round((p.t / (data.tTotal||1)) * 100);
    if(i >= data.points.length-1){ anim.running = false; $('btnPlay').textContent = '🔄 Replay'; return; }
    requestAnimationFrame(stepAnim);
  }

  function beforeLaunchKeepShot(){
    if(dockKeep.checked && data.points && data.points.length){
      shots.push({points: data.points.slice(), color: shotColors[nextShotIdx%shotColors.length]});
      nextShotIdx++;
    }
  }
  function doLaunch(){ beforeLaunchKeepShot(); simulate(); }
  $('btnSim').addEventListener('click', doLaunch);
  dockLaunch.addEventListener('click', doLaunch);
  $('btnClear').addEventListener('click', ()=>{ data={points:[],overlay:[],tv:[],vv:[],tTotal:0}; drawBackground(); if(velChart) velChart.destroy(); if(energyChart){ energyChart.data.datasets[0].data[0]=0; energyChart.data.datasets[1].data[0]=0; energyChart.update('none'); } $('res_t').textContent='–';$('res_r').textContent='–';$('res_h').textContent='–';$('res_vf').textContent='–'; ['hud_t','hud_x','hud_y','hud_vx','hud_vy','hud_v','hud_th'].forEach(id=>$(id).textContent='–'); $('btnPlay').textContent='▶️ Play'; anim.running=false; anim.t=0; anim.last=0; scrub.value=0; });
  $('btnPlay').addEventListener('click', ()=>{
    if(!data.points.length){ simulate(); }

    // If at end and clicking Replay, reset animation
    if($('btnPlay').textContent.includes('Replay')){
      anim.t = 0;
      anim.last = 0;
      scrub.value = 0;
    }

    anim.running = !anim.running;
    $('btnPlay').textContent = anim.running ? '⏸️ Pause' : '▶️ Play';
    if(anim.running) requestAnimationFrame(stepAnim);
  });
  speedSel.addEventListener('change', ()=>{ /* speed applied in loop */ });
  showOverlay.addEventListener('change', ()=>{ if(!data.points.length) return; drawBackground(); drawCannon(); if(showOverlay.checked) drawOverlay(data.overlay); drawShots(); drawPath(data.points); drawMarkers(data.points); drawTarget(); });
  scrub.addEventListener('input', ()=>{
    if(!data.points.length) return;
    anim.running = false; $('btnPlay').textContent='▶️ Play';
    const t = (parseInt(scrub.value,10)||0)/100 * (data.tTotal||0);
    const p = getPointAtTime(t); if(!p) return;
    drawBackground(); drawCannon(); if(showOverlay.checked) drawOverlay(data.overlay); drawShots(); drawPath(data.points); drawMarkers(data.points); drawTarget(); drawBall(p); drawComponents(p);
    updateHUD(p); updateEnergy(p);
  });

  // Air resistance slider bindings
  rhoRange.addEventListener('input', ()=>{
    const val = parseFloat(rhoRange.value);
    rho.value = val;
    rhoValue.textContent = val.toFixed(3);
    if(dragOn.checked) simulate();
  });
  cdRange.addEventListener('input', ()=>{
    const val = parseFloat(cdRange.value);
    cd.value = val;
    cdValue.textContent = val.toFixed(2);
    if(dragOn.checked) simulate();
  });
  areaRange.addEventListener('input', ()=>{
    const val = parseFloat(areaRange.value);
    area.value = val;
    areaValue.textContent = val.toFixed(4);
    if(dragOn.checked) simulate();
  });
  massRange.addEventListener('input', ()=>{
    const val = parseFloat(massRange.value);
    mass.value = val;
    massValue.textContent = val.toFixed(2);
    if(dragOn.checked) simulate();
  });

  // Air resistance preset objects
  function applyAirPreset(rhoVal, cdVal, areaVal, massVal){
    rhoRange.value = rhoVal; rho.value = rhoVal; rhoValue.textContent = rhoVal.toFixed(3);
    cdRange.value = cdVal; cd.value = cdVal; cdValue.textContent = cdVal.toFixed(2);
    areaRange.value = areaVal; area.value = areaVal; areaValue.textContent = areaVal.toFixed(4);
    massRange.value = massVal; mass.value = massVal; massValue.textContent = massVal.toFixed(2);
    if(dragOn.checked) simulate();
  }

  // Original 4 presets
  $('presetTennis').addEventListener('click', ()=> applyAirPreset(1.225, 0.47, 0.0034, 0.06));
  $('presetBaseball').addEventListener('click', ()=> applyAirPreset(1.225, 0.35, 0.0042, 0.145));
  $('presetBasketball').addEventListener('click', ()=> applyAirPreset(1.225, 0.47, 0.045, 0.6));
  $('presetFeather').addEventListener('click', ()=> applyAirPreset(1.225, 1.5, 0.002, 0.001));

  // New sport ball presets
  $('presetSoccer').addEventListener('click', ()=> applyAirPreset(1.225, 0.25, 0.038, 0.43));
  $('presetGolf').addEventListener('click', ()=> applyAirPreset(1.225, 0.25, 0.0014, 0.046));
  $('presetVolleyball').addEventListener('click', ()=> applyAirPreset(1.225, 0.47, 0.042, 0.27));
  $('presetPingPong').addEventListener('click', ()=> applyAirPreset(1.225, 0.47, 0.0013, 0.0027));

  // Projectile presets
  $('presetArrow').addEventListener('click', ()=> applyAirPreset(1.225, 0.05, 0.0005, 0.02));
  $('presetFrisbee').addEventListener('click', ()=> applyAirPreset(1.225, 0.08, 0.057, 0.175));
  $('presetPaper').addEventListener('click', ()=> applyAirPreset(1.225, 0.1, 0.017, 0.005));
  $('presetBalloon').addEventListener('click', ()=> applyAirPreset(1.225, 0.47, 0.05, 0.003));

  // Heavy/extreme presets
  $('presetCannonball').addEventListener('click', ()=> applyAirPreset(1.225, 0.47, 0.02, 6.0));
  $('presetWatermelon').addEventListener('click', ()=> applyAirPreset(1.225, 0.47, 0.04, 5.0));
  $('presetBeachBall').addEventListener('click', ()=> applyAirPreset(1.225, 0.47, 0.16, 0.05));

  // Scenario Presets - Full configurations
  const scenarioPreset = $('scenarioPreset');
  scenarioPreset.addEventListener('change', ()=>{
    const scenario = scenarioPreset.value;
    if(!scenario) return;

    switch(scenario){
      // Sports Challenges
      case 'freethrow':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 7;
        dockAngle.value = angle.value = 50;
        dockY0.value = y0.value = 2;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(1.225, 0.47, 0.045, 0.6); // Basketball
        target.x = 4.5; target.y = 3; target.r = 0.23;
        break;
      case 'soccer-goal':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 20;
        dockAngle.value = angle.value = 25;
        dockY0.value = y0.value = 0;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(1.225, 0.25, 0.038, 0.43); // Soccer
        target.x = 30; target.y = 1.2; target.r = 3.66;
        break;
      case 'golf-drive':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 70;
        dockAngle.value = angle.value = 12;
        dockY0.value = y0.value = 0;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(1.225, 0.25, 0.0014, 0.046); // Golf
        target.x = 250; target.y = 0; target.r = 2;
        break;
      case 'homerun':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 45;
        dockAngle.value = angle.value = 30;
        dockY0.value = y0.value = 1;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(1.225, 0.35, 0.0042, 0.145); // Baseball
        target.x = 120; target.y = 10; target.r = 3;
        break;

      // Space Adventures
      case 'moon-golf':
        dockPreset.value = 'moon'; preset.value = 'moon'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 40;
        dockAngle.value = angle.value = 45;
        dockY0.value = y0.value = 0;
        dockDragOn.checked = dragOn.checked = false; dragCfg.style.display = 'none';
        target.x = 400; target.y = 0; target.r = 5;
        break;
      case 'mars-jump':
        dockPreset.value = 'mars'; preset.value = 'mars'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 15;
        dockAngle.value = angle.value = 60;
        dockY0.value = y0.value = 0;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(0.02, 0.47, 0.5, 900); // Mars rover (thin CO2 atmosphere)
        target.x = 50; target.y = 0; target.r = 2;
        break;
      case 'europa-iceball':
        dockPreset.value = 'europa'; preset.value = 'europa'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 25;
        dockAngle.value = angle.value = 45;
        dockY0.value = y0.value = 0;
        dockDragOn.checked = dragOn.checked = false; dragCfg.style.display = 'none';
        target.x = 200; target.y = 0; target.r = 3;
        break;
      case 'titan-fall':
        dockPreset.value = 'titan'; preset.value = 'titan'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 10;
        dockAngle.value = angle.value = 80;
        dockY0.value = y0.value = 50;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(5.4, 1.2, 2, 100); // Titan's thick methane atmosphere
        target.x = 20; target.y = 0; target.r = 2;
        break;

      // Historical
      case 'trebuchet':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 50;
        dockAngle.value = angle.value = 45;
        dockY0.value = y0.value = 10;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(1.225, 0.5, 0.07, 50); // Heavy stone
        target.x = 200; target.y = 5; target.r = 10;
        break;
      case 'cannon':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 120;
        dockAngle.value = angle.value = 35;
        dockY0.value = y0.value = 2;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(1.225, 0.47, 0.02, 6.0); // Cannonball
        target.x = 600; target.y = 0; target.r = 5;
        break;
      case 'archery':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 70;
        dockAngle.value = angle.value = 5;
        dockY0.value = y0.value = 1.5;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(1.225, 0.05, 0.0005, 0.02); // Arrow
        target.x = 70; target.y = 1.4; target.r = 0.06;
        break;

      // Extreme & Fun
      case 'angry-birds':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 30;
        dockAngle.value = angle.value = 40;
        dockY0.value = y0.value = 2;
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(1.225, 0.47, 0.01, 0.5); // Bird-like
        target.x = 50; target.y = 5; target.r = 2;
        break;
      case 'superhero':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 100;
        dockAngle.value = angle.value = 15;
        dockY0.value = y0.value = 0;
        dockDragOn.checked = dragOn.checked = false; dragCfg.style.display = 'none';
        target.x = 300; target.y = 20; target.r = 5;
        break;
      case 'everest':
        dockPreset.value = 'earth'; preset.value = 'earth'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 40;
        dockAngle.value = angle.value = 45;
        dockY0.value = y0.value = 8848; // Everest height
        dockDragOn.checked = dragOn.checked = true; dragCfg.style.display = 'block';
        applyAirPreset(0.46, 0.47, 0.0034, 0.06); // Thin air at summit
        target.x = 300; target.y = 8848; target.r = 5;
        break;
      case 'white-dwarf':
        dockPreset.value = 'whitedwarf'; preset.value = 'whitedwarf'; preset.dispatchEvent(new Event('change'));
        dockV0.value = v0.value = 1000;
        dockAngle.value = angle.value = 45;
        dockY0.value = y0.value = 0;
        dockDragOn.checked = dragOn.checked = false; dragCfg.style.display = 'none';
        target.x = 0.1; target.y = 0; target.r = 0.01;
        break;
    }

    // Update dock controls to match
    dockG.value = g.value;
    if(dockPreset.value === 'custom') { dockG.disabled = false; }
    else { dockG.disabled = true; }

    simulate();
    scenarioPreset.value = ''; // Reset dropdown
  });

  // Initial draw
  drawBackground(); simulate();
  // Dock bindings
  dockAngle.addEventListener('input', ()=>{ angle.value = dockAngle.value; simulate(); });
  dockV0.addEventListener('input', ()=>{ v0.value = dockV0.value; simulate(); });
  dockPreset.addEventListener('change', ()=>{ preset.value = dockPreset.value; preset.dispatchEvent(new Event('change')); simulate(); });
  dockDragOn.addEventListener('change', ()=>{ dragOn.checked = dockDragOn.checked; dragCfg.style.display = dragOn.checked ? 'block':'none'; simulate(); });
  dockAutoScale.addEventListener('change', ()=>{ if(dockAutoScale.checked && data.points.length) autoAdjustScale(data.points); });
  dockResetShots.addEventListener('click', ()=>{ shots=[]; nextShotIdx=0; drawBackground(); drawCannon(); if(showOverlay.checked) drawOverlay(data.overlay); drawPath(data.points); drawMarkers(data.points); drawTarget(); });
  // Keep dock in sync when user changes inputs elsewhere
  angle.addEventListener('input', ()=>{ dockAngle.value = angle.value; });
  v0.addEventListener('input', ()=>{ dockV0.value = v0.value; });
  preset.addEventListener('change', ()=>{ dockPreset.value = preset.value; });
  dragOn.addEventListener('change', ()=>{ dockDragOn.checked = dragOn.checked; });
  // Dock additional bindings
  dockY0.addEventListener('input', ()=>{ y0.value = dockY0.value; simulate(); });
  dockScale.addEventListener('input', ()=>{ scale.value = dockScale.value; // re-render with new scale
    if(!data.points.length) { drawBackground(); drawCannon(); return; }
    const p = getPointAtTime(anim.t||0) || data.points[0];
    drawBackground(); drawCannon(); if(showOverlay.checked) drawOverlay(data.overlay); drawShots(); drawPath(data.points); drawMarkers(data.points); drawTarget(); drawBall(p); drawComponents(p);
  });
  dockPreset.addEventListener('change', ()=>{
    preset.value = dockPreset.value;
    preset.dispatchEvent(new Event('change'));
    // enable/disable custom g
    if(dockPreset.value === 'custom') { dockG.disabled = false; dockG.value = g.value; }
    else { dockG.disabled = true; dockG.value = g.value; }
    simulate();
  });
  dockG.addEventListener('input', ()=>{ preset.value = 'custom'; dockPreset.value = 'custom'; g.value = dockG.value; simulate(); });

  // Canvas interactions: drag to set initial velocity, drag target
  function canvasToMeters(px, py){ const s=parseFloat(scale.value)||4; const ox=30, oy=canvas.height-30; return {x: (px-ox)/s, y: (oy-py)/s}; }
  function metersToCanvas(mx, my){ const s=parseFloat(scale.value)||4; const ox=30, oy=canvas.height-30; return {x: ox+mx*s, y: oy-my*s}; }
  function isOnTarget(px, py){ const m = canvasToMeters(px,py); const dx=m.x-target.x, dy=m.y-target.y; return Math.hypot(dx,dy) <= target.r*1.4; }
  canvas.addEventListener('mousedown', (e)=>{
    const rect = canvas.getBoundingClientRect(); const px = e.clientX-rect.left, py=e.clientY-rect.top;
    if(isOnTarget(px,py)) { draggingTarget = true; return; }
    // else start launch-drag if near cannon base
    const origin = metersToCanvas(0,0); const d = Math.hypot(px-origin.x, py-origin.y);
    if(d < 40){ draggingLaunch = true; }
  });
  canvas.addEventListener('mousemove', (e)=>{
    if(!draggingTarget && !draggingLaunch) return;
    const rect = canvas.getBoundingClientRect(); const px = e.clientX-rect.left, py=e.clientY-rect.top;
    if(draggingTarget){ const m = canvasToMeters(px,py); target.x = Math.max(0, m.x); target.y = Math.max(0, m.y); drawBackground(); drawCannon(); if(showOverlay.checked) drawOverlay(data.overlay); drawShots(); drawPath(data.points); drawMarkers(data.points); drawTarget(); return; }
    if(draggingLaunch){
      // compute velocity from vector origin->mouse
      const origin = metersToCanvas(0,0);
      const dx = px - origin.x, dy = origin.y - py; // canvas y inverted
      const vPerPx = 0.5; // 2 px per 1 m/s
      const vMag = Math.max(1, Math.min(100, Math.hypot(dx,dy)*vPerPx));
      const ang = Math.atan2(dy, dx);
      v0.value = dockV0.value = vMag.toFixed(0);
      angle.value = dockAngle.value = Math.max(0, Math.min(90, toDeg(ang))).toFixed(0);
      simulate();
    }
  });
  window.addEventListener('mouseup', ()=>{ draggingTarget=false; draggingLaunch=false; });
  // Charts tab toggle
  document.getElementById('tabVel').addEventListener('click', function(e){ e.preventDefault(); this.classList.add('active'); document.getElementById('tabEnergy').classList.remove('active'); document.getElementById('velChart').style.display='block'; document.getElementById('energyChart').style.display='none'; });
  document.getElementById('tabEnergy').addEventListener('click', function(e){ e.preventDefault(); this.classList.add('active'); document.getElementById('tabVel').classList.remove('active'); document.getElementById('velChart').style.display='none'; document.getElementById('energyChart').style.display='block'; });

  // Save Image functionality
  $('btnSaveImage').addEventListener('click', ()=>{
    if(!data.points || !data.points.length){
      showNotification('⚠️ Please launch a trajectory first!', '#ef4444');
      return;
    }

    // Create a temporary canvas with expanded height for stats panel below trajectory
    const originalHeight = canvas.height; // 500px
    const statsHeight = 450; // Height for stats panel
    const tempCanvas = document.createElement('canvas');
    tempCanvas.width = canvas.width; // Keep original width (900px)
    tempCanvas.height = originalHeight + statsHeight; // 950px total
    const tempCtx = tempCanvas.getContext('2d');

    // Fill white background
    tempCtx.fillStyle = '#ffffff';
    tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);

    // Draw current canvas content on top (original trajectory area)
    tempCtx.drawImage(canvas, 0, 0);

    // Draw separator line between trajectory and stats
    tempCtx.strokeStyle = '#e2e8f0';
    tempCtx.lineWidth = 2;
    tempCtx.beginPath();
    tempCtx.moveTo(0, originalHeight + 10);
    tempCtx.lineTo(tempCanvas.width, originalHeight + 10);
    tempCtx.stroke();

    // Get current simulation parameters
    const v0Val = parseFloat(v0.value) || 0;
    const angleVal = parseFloat(angle.value) || 0;
    const y0Val = parseFloat(y0.value) || 0;
    const gVal = parseFloat(g.value) || 9.81;
    const isDrag = dragOn.checked;

    // Get results from display
    const timeOfFlight = $('res_t').textContent;
    const range = $('res_r').textContent;
    const maxHeight = $('res_h').textContent;
    const finalSpeed = $('res_vf').textContent;

    // Get planet name
    let planetName = 'Earth';
    if(preset.value && preset.value !== 'custom'){
      const presetSelect = dockPreset.options[dockPreset.selectedIndex];
      if(presetSelect) planetName = presetSelect.text.replace(/[♃♄♅♆☿♀♂⚪🌍🌙🪐🛸♇☀️]/g, '').trim();
    }

    // Add stats panel below the trajectory (no overlap!)
    tempCtx.save();

    // Stats box positioned below trajectory
    const statsX = 50; // Centered horizontally with left margin
    const statsY = originalHeight + 20; // Start 20px below trajectory
    const statsW = canvas.width - 100; // Full width minus margins
    const statsH = 410;

    // Semi-transparent background
    tempCtx.fillStyle = 'rgba(255, 255, 255, 0.95)';
    tempCtx.fillRect(statsX, statsY, statsW, statsH);

    // Border
    tempCtx.strokeStyle = '#667eea';
    tempCtx.lineWidth = 3;
    tempCtx.strokeRect(statsX, statsY, statsW, statsH);

    // Title
    tempCtx.fillStyle = '#667eea';
    tempCtx.font = 'bold 18px system-ui';
    tempCtx.textAlign = 'center';
    tempCtx.fillText('📊 PROJECTILE MOTION ANALYSIS', statsX + statsW/2, statsY + 25);

    // Three-column layout for better horizontal space usage
    const col1X = statsX + 20;
    const col2X = statsX + statsW/3 + 10;
    const col3X = statsX + (2*statsW/3) + 10;
    let yPos = statsY + 55;

    // Column 1: Parameters
    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = 'bold 14px system-ui';
    tempCtx.textAlign = 'left';
    tempCtx.fillText('⚙️ Parameters:', col1X, yPos);

    yPos += 25;
    tempCtx.font = '12px system-ui';
    tempCtx.fillStyle = '#475569';
    tempCtx.fillText(`Planet: ${planetName}`, col1X, yPos);
    yPos += 18;
    tempCtx.fillText(`Gravity: ${gVal} m/s²`, col1X, yPos);
    yPos += 18;
    tempCtx.fillText(`Initial Velocity: ${v0Val} m/s`, col1X, yPos);
    yPos += 18;
    tempCtx.fillText(`Launch Angle: ${angleVal}°`, col1X, yPos);
    yPos += 18;
    tempCtx.fillText(`Starting Height: ${y0Val} m`, col1X, yPos);
    yPos += 18;
    tempCtx.fillText(`Air Resistance: ${isDrag ? 'ON' : 'OFF'}`, col1X, yPos);

    // Column 2: Results
    yPos = statsY + 55;
    tempCtx.fillStyle = '#10b981';
    tempCtx.font = 'bold 14px system-ui';
    tempCtx.fillText('📈 Results:', col2X, yPos);

    yPos += 25;
    tempCtx.font = '12px system-ui';
    tempCtx.fillStyle = '#475569';
    tempCtx.fillText(`Time of Flight:`, col2X, yPos);
    yPos += 16;
    tempCtx.font = 'bold 12px system-ui';
    tempCtx.fillStyle = '#10b981';
    tempCtx.fillText(`${timeOfFlight}`, col2X, yPos);

    yPos += 22;
    tempCtx.font = '12px system-ui';
    tempCtx.fillStyle = '#475569';
    tempCtx.fillText(`Range:`, col2X, yPos);
    yPos += 16;
    tempCtx.font = 'bold 12px system-ui';
    tempCtx.fillStyle = '#10b981';
    tempCtx.fillText(`${range}`, col2X, yPos);

    yPos += 22;
    tempCtx.font = '12px system-ui';
    tempCtx.fillStyle = '#475569';
    tempCtx.fillText(`Max Height:`, col2X, yPos);
    yPos += 16;
    tempCtx.font = 'bold 12px system-ui';
    tempCtx.fillStyle = '#10b981';
    tempCtx.fillText(`${maxHeight}`, col2X, yPos);

    yPos += 22;
    tempCtx.font = '12px system-ui';
    tempCtx.fillStyle = '#475569';
    tempCtx.fillText(`Final Speed:`, col2X, yPos);
    yPos += 16;
    tempCtx.font = 'bold 12px system-ui';
    tempCtx.fillStyle = '#10b981';
    tempCtx.fillText(`${finalSpeed}`, col2X, yPos);

    // Column 3: Formulas
    yPos = statsY + 55;
    tempCtx.fillStyle = '#f59e0b';
    tempCtx.font = 'bold 14px system-ui';
    tempCtx.fillText('📐 Formulas:', col3X, yPos);

    yPos += 25;
    tempCtx.font = '11px monospace';
    tempCtx.fillStyle = '#1e293b';

    if(!isDrag){
      // No air resistance formulas
      tempCtx.fillText('Range:', col3X, yPos);
      yPos += 16;
      tempCtx.fillText('R = (v₀² × sin(2θ)) / g', col3X, yPos);

      yPos += 24;
      tempCtx.fillText('Time of Flight:', col3X, yPos);
      yPos += 16;
      tempCtx.fillText('T = (2v₀ × sin(θ)) / g', col3X, yPos);

      yPos += 24;
      tempCtx.fillText('Max Height:', col3X, yPos);
      yPos += 16;
      tempCtx.fillText('H = (v₀² × sin²(θ)) / (2g)', col3X, yPos);
    } else {
      // With air resistance
      tempCtx.fillText('Drag Force:', col3X, yPos);
      yPos += 16;
      tempCtx.fillText('F_d = 0.5 × ρ × C_d × A × v²', col3X, yPos);

      yPos += 24;
      tempCtx.font = '10px system-ui';
      tempCtx.fillStyle = '#64748b';
      tempCtx.fillText('Numerical integration:', col3X, yPos);
      yPos += 14;
      tempCtx.fillText('(Euler method, dt=0.005s)', col3X, yPos);
    }

    // Watermark centered at bottom
    tempCtx.fillStyle = '#667eea';
    tempCtx.font = 'bold 12px system-ui';
    tempCtx.textAlign = 'center';
    tempCtx.fillText('8gwifi.org/projectile-motion-simulator.jsp', statsX + statsW/2, statsY + statsH - 15);

    // Add timestamp at bottom left of entire canvas
    tempCtx.textAlign = 'left';
    tempCtx.font = '10px system-ui';
    tempCtx.fillStyle = 'rgba(0,0,0,0.4)';
    const timestamp = new Date().toLocaleString();
    tempCtx.fillText(`Generated: ${timestamp}`, 10, tempCanvas.height - 10);

    tempCtx.restore();

    // Convert to blob and download
    tempCanvas.toBlob((blob)=>{
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      const timestamp = new Date().toISOString().slice(0,19).replace(/:/g,'-');
      a.download = `projectile-motion-${timestamp}.png`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);

      // Show notification
      showNotification('📸 Image saved successfully!', '#10b981');
    });
  });

  // Share Link functionality
  $('btnShareLink').addEventListener('click', ()=>{
    // Build URL with parameters
    const baseUrl = window.location.origin + window.location.pathname;
    const params = new URLSearchParams();
    params.set('v0', v0.value);
    params.set('angle', angle.value);
    params.set('y0', y0.value);
    params.set('g', g.value);
    params.set('preset', preset.value);
    params.set('scale', scale.value);
    if(dragOn.checked){
      params.set('drag', '1');
      params.set('rho', rho.value);
      params.set('cd', cd.value);
      params.set('area', area.value);
      params.set('mass', mass.value);
    }

    const shareUrl = baseUrl + '?' + params.toString();

    // Copy to clipboard
    if(navigator.clipboard){
      navigator.clipboard.writeText(shareUrl).then(()=>{
        showNotification('🔗 Link copied to clipboard!', '#667eea');
      }).catch(()=>{
        // Fallback: show URL in prompt
        prompt('Copy this link:', shareUrl);
      });
    } else {
      // Fallback for older browsers
      prompt('Copy this link:', shareUrl);
    }
  });

  // Load parameters from URL on page load
  (function loadFromUrl(){
    const params = new URLSearchParams(window.location.search);
    if(params.has('v0')){
      v0.value = dockV0.value = params.get('v0');
      angle.value = dockAngle.value = params.get('angle') || 45;
      y0.value = dockY0.value = params.get('y0') || 0;
      g.value = dockG.value = params.get('g') || 9.81;
      scale.value = dockScale.value = params.get('scale') || 4;

      const presetVal = params.get('preset') || 'earth';
      preset.value = dockPreset.value = presetVal;

      if(params.has('drag')){
        dragOn.checked = dockDragOn.checked = true;
        dragCfg.style.display = 'block';
        rho.value = rhoRange.value = params.get('rho') || 1.225;
        cd.value = cdRange.value = params.get('cd') || 0.47;
        area.value = areaRange.value = params.get('area') || 0.01;
        mass.value = massRange.value = params.get('mass') || 0.2;
        rhoValue.textContent = parseFloat(rho.value).toFixed(3);
        cdValue.textContent = parseFloat(cd.value).toFixed(2);
        areaValue.textContent = parseFloat(area.value).toFixed(4);
        massValue.textContent = parseFloat(mass.value).toFixed(2);
      }

      simulate();
    }
  })();

  // Ball Kick Distance Calculator (only if DOM elements exist)
  const kickDistance = $('kickDistance');
  const kickAngle = $('kickAngle');
  const kickAngleValue = $('kickAngleValue');
  const btnCalculateKick = $('btnCalculateKick');
  const kickResults = $('kickResults');

  if(kickAngle && btnCalculateKick){
  // Update angle display
  kickAngle.addEventListener('input', ()=>{
    kickAngleValue.textContent = kickAngle.value;
  });

  btnCalculateKick.addEventListener('click', ()=>{
    const earthRange = parseFloat(kickDistance.value) || 30; // in meters
    const launchAngle = parseFloat(kickAngle.value) || 45; // in degrees
    const earthG = 9.81;

    // Calculate initial velocity from Earth range: v₀ = √(R × g / sin(2θ))
    const angleRad = toRad(launchAngle);
    const v0_kick = Math.sqrt((earthRange * earthG) / Math.sin(2 * angleRad));

    // Calculate kick distance on each planet: R = (v₀² × sin(2θ)) / g
    const planets = [
      {name: '☀️ Sun', g: 274, emoji: '☀️', color: '#fbbf24'},
      {name: '♃ Jupiter', g: 24.79, emoji: '♃', color: '#fb923c'},
      {name: '♆ Neptune', g: 11.15, emoji: '♆', color: '#60a5fa'},
      {name: '♄ Saturn', g: 10.44, emoji: '♄', color: '#fcd34d'},
      {name: '🌍 Earth', g: 9.81, emoji: '🌍', color: '#10b981'},
      {name: '♅ Uranus', g: 8.87, emoji: '♅', color: '#38bdf8'},
      {name: '♀️ Venus', g: 8.87, emoji: '♀️', color: '#f472b6'},
      {name: '☿️ Mercury', g: 3.7, emoji: '☿️', color: '#94a3b8'},
      {name: '♂️ Mars', g: 3.71, emoji: '♂️', color: '#ef4444'},
      {name: '🌙 Moon', g: 1.62, emoji: '🌙', color: '#cbd5e1'},
      {name: '🪐 Titan', g: 1.35, emoji: '🪐', color: '#fb923c'},
      {name: '🛸 Europa', g: 1.31, emoji: '🛸', color: '#93c5fd'},
      {name: '♇ Pluto', g: 0.62, emoji: '♇', color: '#a78bfa'},
      {name: '⚪ Ceres', g: 0.27, emoji: '⚪', color: '#d4d4d8'}
    ];

    // Sort by kick distance (descending)
    const results = planets.map(p => {
      const kickDist = (v0_kick * v0_kick * Math.sin(2 * angleRad)) / p.g; // Range formula
      const multiplier = kickDist / earthRange;
      return {...p, kickDist, multiplier};
    }).sort((a, b) => b.kickDist - a.kickDist);

    // Generate HTML
    let html = `<div style="margin-bottom:.5rem;font-weight:700;color:#f59e0b;font-size:.9rem">
      On Earth you kick: ${earthRange} m at ${launchAngle}°
    </div>`;

    results.forEach((r, idx) => {
      const barWidth = Math.min(100, (r.kickDist / results[0].kickDist) * 100);
      const displayDist = r.kickDist > 1000 ? `${(r.kickDist/1000).toFixed(2)}km` : `${Math.round(r.kickDist)}m`;

      html += `
        <div class="kick-planet-item" data-gravity="${r.g}" data-range="${r.kickDist}" data-name="${r.name}" style="margin-bottom:.6rem;padding:.4rem;background:#fff;border-radius:6px;border-left:3px solid ${r.color};cursor:pointer;transition:all .2s ease">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:.2rem">
            <span style="font-weight:600;font-size:.85rem">${r.name}</span>
            <span style="font-weight:700;color:${r.color};font-size:.9rem">${displayDist}</span>
          </div>
          <div style="display:flex;justify-content:space-between;align-items:center;font-size:.75rem;color:#64748b;margin-bottom:.3rem">
            <span>Gravity: ${r.g} m/s²</span>
            <span>${r.multiplier.toFixed(1)}× Earth</span>
          </div>
          <div style="background:#e2e8f0;height:6px;border-radius:3px;overflow:hidden">
            <div style="background:${r.color};height:100%;width:${barWidth}%;transition:width .5s ease;border-radius:3px"></div>
          </div>
          <div style="text-align:center;margin-top:.3rem;font-size:.7rem;color:#667eea;font-weight:600">
            👆 Click to see trajectory
          </div>
        </div>
      `;
    });

    html += `<div style="margin-top:.8rem;padding:.5rem;background:#fef3c7;border-radius:6px;border-left:3px solid #f59e0b;font-size:.8rem">
      <strong>⚽ Fun Facts:</strong><br>
      • On Ceres you could kick <strong>${(results[results.length-1].multiplier).toFixed(0)}×</strong> farther!<br>
      • Moon kicks go <strong>${results.find(r=>r.name.includes('Moon')).multiplier.toFixed(1)}×</strong> the distance<br>
      • On Jupiter the ball barely travels 😅<br>
      <br>
      <strong style="color:#667eea">💡 Tip:</strong> Click any planet to visualize the kick trajectory!
    </div>`;

    html += `<button id="btnShowAllKicks" class="btn btn-sm" style="width:100%;margin-top:.8rem;background:linear-gradient(135deg, #667eea 0%, #764ba2 100%);color:#fff;font-weight:600">
      🌌 Compare All Kicks on Canvas
    </button>`;

    kickResults.innerHTML = html;
    kickResults.style.display = 'block';

    // Add click handlers to each planet item
    setTimeout(()=>{
      document.querySelectorAll('.kick-planet-item').forEach(item => {
        item.addEventListener('click', function(){
          const gVal = parseFloat(this.dataset.gravity);
          const kickRange = parseFloat(this.dataset.range);
          const planetName = this.dataset.name;

          // Find the matching preset or use custom
          let presetVal = 'custom';
          for(let key in gravityPresets){
            if(Math.abs(gravityPresets[key] - gVal) < 0.01){
              presetVal = key;
              break;
            }
          }

          // Set gravity preset
          preset.value = dockPreset.value = presetVal;
          g.value = dockG.value = gVal;
          if(presetVal === 'custom'){
            dockG.disabled = false;
          } else {
            dockG.disabled = true;
          }

          // Set simulation parameters for the kick
          v0.value = dockV0.value = v0_kick.toFixed(2);
          angle.value = dockAngle.value = launchAngle; // Use selected angle
          y0.value = dockY0.value = 0;

          // Disable air resistance for simplicity
          dragOn.checked = dockDragOn.checked = false;
          dragCfg.style.display = 'none';

          // Auto-scale for better visualization
          dockAutoScale.checked = true;

          // Reset shots and simulate
          shots = [];
          nextShotIdx = 0;

          simulate();

          // Show notification
          const distText = kickRange > 1000 ? `${(kickRange/1000).toFixed(2)}km` : `${Math.round(kickRange)}m`;
          showNotification(`⚽ Kicking on ${planetName}: ${distText}!`, '#f59e0b');

          // Scroll to trajectory view
          document.getElementById('canvasWrap').scrollIntoView({behavior: 'smooth', block: 'center'});
        });

        // Add hover effect
        item.addEventListener('mouseenter', function(){
          this.style.transform = 'translateX(5px)';
          this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)';
        });
        item.addEventListener('mouseleave', function(){
          this.style.transform = 'translateX(0)';
          this.style.boxShadow = 'none';
        });
      });

      // Handler for "Compare All Kicks" button
      const btnShowAllKicks = document.getElementById('btnShowAllKicks');
      if(btnShowAllKicks){
        btnShowAllKicks.addEventListener('click', ()=>{
          // Clear existing shots
          shots = [];
          nextShotIdx = 0;

          // Enable "Keep Shots" mode
          dockKeep.checked = true;

          // Disable air resistance
          dragOn.checked = dockDragOn.checked = false;
          dragCfg.style.display = 'none';

          // Set common parameters
          angle.value = dockAngle.value = launchAngle; // Use selected angle
          y0.value = dockY0.value = 0;
          dockAutoScale.checked = true;

          // Simulate kicks for selected planets (avoid too many overlays)
          const planetsToShow = [
            {name: 'Jupiter', g: 24.79, color: '#fb923c'},
            {name: 'Earth', g: 9.81, color: '#10b981'},
            {name: 'Mars', g: 3.71, color: '#ef4444'},
            {name: 'Moon', g: 1.62, color: '#cbd5e1'},
            {name: 'Ceres', g: 0.27, color: '#d4d4d8'}
          ];

          planetsToShow.forEach((planet, idx) => {
            setTimeout(()=>{
              // Set gravity and velocity
              g.value = planet.g;
              v0.value = v0_kick.toFixed(2);

              // Simulate and keep the shot
              beforeLaunchKeepShot();

              // Override shot color
              simulate();
              if(shots.length > 0){
                shots[shots.length - 1].color = planet.color;
              }

              // Last one: redraw everything
              if(idx === planetsToShow.length - 1){
                setTimeout(()=>{
                  drawBackground();
                  drawCannon();
                  drawShots();
                  drawTarget();

                  // Add legend
                  const legendY = 30;
                  ctx.save();
                  ctx.font = '600 12px system-ui';
                  ctx.fillStyle = '#1e293b';
                  ctx.fillText(`Ball Kick Comparison (${launchAngle}°):`, 40, legendY);

                  planetsToShow.forEach((p, i) => {
                    const yPos = legendY + 20 + (i * 18);
                    ctx.fillStyle = p.color;
                    ctx.fillRect(40, yPos - 8, 12, 12);
                    ctx.fillStyle = '#1e293b';
                    ctx.fillText(p.name, 58, yPos);
                  });
                  ctx.restore();

                  showNotification('⚽ All kicks visualized!', '#667eea');
                }, 100);
              }
            }, idx * 200); // Stagger simulations
          });

          // Scroll to canvas
          document.getElementById('canvasWrap').scrollIntoView({behavior: 'smooth', block: 'center'});
        });
      }
    }, 100);
  });
  } // end kick calculator guard

  // Notification helper
  function showNotification(message, color){
    let notif = document.getElementById('actionNotification');
    if(!notif){
      notif = document.createElement('div');
      notif.id = 'actionNotification';
      notif.style.cssText = 'position:fixed;top:80px;right:20px;background:#fff;color:#1e293b;padding:0.8rem 1.2rem;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.15);font-size:0.9rem;font-weight:600;z-index:9999;transition:all 0.3s ease;border-left:4px solid '+color;
      document.body.appendChild(notif);
    }
    notif.style.borderLeftColor = color;
    notif.textContent = message;
    notif.style.opacity = '1';
    notif.style.transform = 'translateX(0)';

    setTimeout(()=>{
      notif.style.opacity = '0';
      notif.style.transform = 'translateX(400px)';
    }, 3000);
  }
})();

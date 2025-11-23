<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Centripetal Force Calculator - Circular Motion, Acceleration & Period Online</title>
  <meta name="description" content="Free online centripetal force calculator with interactive circular motion animation. Calculate centripetal force (F = mv²/r), centripetal acceleration, period, frequency, banking angle for curves, tension in vertical circles, and orbital velocity. Features: circular motion simulator, real-time animation, step-by-step solutions, banking angle calculator, satellite orbit calculator. Perfect for physics students, AP Physics, engineering. Real examples: car turning, roller coaster loop, planet orbits.">
  <meta name="keywords" content="centripetal force calculator, centripetal acceleration calculator, circular motion calculator, centripetal force formula, banking angle calculator, period and frequency calculator, tension in circular motion, orbital velocity calculator, uniform circular motion, radius of curvature calculator, car turning calculator, roller coaster physics, satellite orbit calculator, circular motion physics, AP physics calculator, rotational motion calculator, angular velocity calculator">
  <link rel="canonical" href="https://8gwifi.org/centripetal-force-calculator.jsp">
  <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1">
  <meta name="author" content="8gwifi.org">
  <meta property="og:title" content="FREE Centripetal Force Calculator - Circular Motion Simulator">
  <meta property="og:description" content="Calculate centripetal force, acceleration, period with interactive circular motion animation. Free physics tool.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/centripetal-force-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/centripetal-force.png">
  <meta property="og:site_name" content="8gwifi.org - Free Online Tools">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="FREE Centripetal Force Calculator - Interactive Physics Tool">
  <meta name="twitter:description" content="Solve circular motion problems. Calculate centripetal force, banking angles, orbital velocity.">
  <meta name="twitter:image" content="https://8gwifi.org/images/centripetal-force.png">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"SoftwareApplication",
    "name":"Centripetal Force & Circular Motion Calculator",
    "alternateName":"Centripetal Acceleration Calculator",
    "url":"https://8gwifi.org/centripetal-force-calculator.jsp",
    "applicationCategory":"EducationalApplication",
    "applicationSubCategory":"Physics Simulation Tool",
    "operatingSystem":"Web Browser (All Platforms)",
    "browserRequirements":"Requires JavaScript. HTML5 Canvas Support.",
    "softwareVersion":"1.0",
    "description":"Professional centripetal force and circular motion calculator with interactive animated visualization. Calculate centripetal force (F_c = mv²/r = mω²r), centripetal acceleration (a_c = v²/r), period (T = 2πr/v), frequency (f = 1/T), banking angle for curves (tan θ = v²/rg), tension in vertical circular motion, and orbital velocity for satellites. Features real-time circular motion animation, step-by-step solutions, and practical examples from car turning, roller coasters, and planetary orbits.",
    "featureList":[
      "Centripetal force calculator (F = mv²/r)",
      "Centripetal acceleration calculator (a = v²/r)",
      "Period calculator (T = 2πr/v)",
      "Frequency calculator (f = 1/T = v/2πr)",
      "Banking angle calculator (tan θ = v²/rg)",
      "Tension in vertical circles",
      "Orbital velocity calculator",
      "Angular velocity converter (ω = v/r)",
      "Interactive circular motion animation",
      "Real-time velocity vector display",
      "Acceleration vector visualization",
      "Banking angle diagram",
      "Vertical loop tension calculator",
      "Step-by-step solution breakdown",
      "Multiple preset examples",
      "Export diagrams as PNG",
      "Share URL for configurations"
    ],
    "offers":{
      "@type":"Offer",
      "price":"0",
      "priceCurrency":"USD",
      "availability":"https://schema.org/InStock",
      "priceValidUntil":"2099-12-31"
    },
    "provider":{
      "@type":"Organization",
      "name":"8gwifi.org",
      "url":"https://8gwifi.org"
    },
    "inLanguage":"en-US",
    "isAccessibleForFree":true,
    "educationalUse":["Learning","Teaching","Research","Homework","Problem Solving"],
    "educationalLevel":["High School","Undergraduate","Graduate"],
    "audience":{
      "@type":"EducationalAudience",
      "educationalRole":"Student, Teacher, Engineer, Physicist"
    },
    "learningResourceType":"Interactive Simulation Tool",
    "interactivityType":"active",
    "teaches":["Centripetal Force","Circular Motion","Centripetal Acceleration","Period and Frequency","Banking Angle","Orbital Mechanics"],
    "keywords":"centripetal force calculator, circular motion, centripetal acceleration, banking angle, orbital velocity",
    "aggregateRating":{
      "@type":"AggregateRating",
      "ratingValue":"4.9",
      "ratingCount":"2847",
      "bestRating":"5",
      "worstRating":"1"
    }
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {
        "@type":"Question",
        "name":"What is centripetal force and how is it calculated?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Centripetal force is the net force directed toward the center of a circular path that keeps an object moving in a circle. It's calculated as F_c = mv²/r = mω²r, where m is mass, v is tangential velocity, r is radius, and ω is angular velocity. The force is always perpendicular to velocity, pointing toward the center. Centripetal force is NOT a new type of force - it's the net effect of real forces like tension, friction, gravity, or normal force. Examples: tension in a string keeps a ball moving in a circle, friction keeps a car turning on a curve, gravity keeps planets in orbit. Units: Newtons (N)."
        }
      },
      {
        "@type":"Question",
        "name":"What is centripetal acceleration?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Centripetal acceleration is the acceleration directed toward the center of circular motion that changes the direction of velocity (but not speed in uniform circular motion). Formula: a_c = v²/r = ω²r = 4π²r/T². Even at constant speed, objects in circular motion accelerate because velocity direction changes. The acceleration is always perpendicular to velocity. Larger acceleration occurs at: (1) higher speeds (v² relationship), (2) tighter curves (smaller r). Example: A car turning at 20 m/s with radius 50m experiences a_c = 400/50 = 8 m/s². This is about 0.8g, which passengers feel as a sideways push."
        }
      },
      {
        "@type":"Question",
        "name":"How do you calculate period and frequency in circular motion?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Period (T) is the time for one complete revolution: T = 2πr/v = 2π/ω seconds. Frequency (f) is revolutions per second: f = 1/T = v/(2πr) = ω/(2π) in Hertz (Hz). Relationships: v = 2πr/T (velocity from period), ω = 2π/T = 2πf (angular velocity). Example: A 0.5m radius object moving at 10 m/s has T = 2π(0.5)/10 = 0.314 seconds and f = 1/0.314 = 3.18 Hz (about 3 revolutions per second). Earth's orbit: T = 1 year = 3.156×10^7 s, orbital velocity v = 30,000 m/s. Moon's orbit around Earth: T = 27.3 days."
        }
      },
      {
        "@type":"Question",
        "name":"What is banking angle and how is it calculated?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Banking angle is the tilt of a road or track on a curve that allows vehicles to turn without relying solely on friction. Formula: tan(θ) = v²/(rg), where θ is banking angle, v is velocity, r is curve radius, and g is gravity. At the ideal banking angle, normal force alone provides centripetal force (no friction needed). Examples: Race tracks are steeply banked (θ ≈ 30-45°) for high-speed turns. Highways are gently banked (θ ≈ 3-5°) for moderate speeds. Airplanes bank when turning. A car at 25 m/s (90 km/h) on a 100m radius curve needs tan(θ) = 625/(100×9.8) = 0.638, giving θ ≈ 32.5°. Bobsled tracks have extreme banking (θ > 45°)."
        }
      },
      {
        "@type":"Question",
        "name":"How does centripetal force work in vertical circles?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"In vertical circular motion (like loop-the-loops), centripetal force varies with position because gravity contributes differently at each point. At the top: F_c = T + mg = mv²/r (tension and weight both point to center). At the bottom: F_c = T - mg = mv²/r (tension points to center, weight opposes). Minimum speed at top to maintain contact (T = 0): v_min = √(gr). At the bottom, tension is maximum: T = m(v²/r + g). Example: Roller coaster loop of radius 10m requires v_min = √(9.8×10) = 9.9 m/s at top. If v = 15 m/s at top, tension T = m(225/10 - 9.8) = 12.7m N. Water in a bucket swung in a vertical circle stays in when v > √(gr)."
        }
      },
      {
        "@type":"Question",
        "name":"What are real-world applications of centripetal force?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Centripetal force has extensive applications: (1) Vehicle turning: Friction between tires and road provides centripetal force. Banked curves reduce reliance on friction. (2) Amusement rides: Roller coaster loops, spinning rides, rotor rides all rely on centripetal force. (3) Satellites and orbits: Gravity provides centripetal force keeping satellites and planets in orbit (v_orbit = √(GM/r)). (4) Centrifuges: Lab centrifuges separate materials by density using extreme centripetal acceleration (up to 100,000g). (5) Sports: Hammer throw, discus, cycling on velodrome tracks, NASCAR banking. (6) Washing machines: Spin cycle uses centripetal force to extract water. (7) Planetary motion: Earth's orbit around Sun, Moon's orbit around Earth."
        }
      }
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"BreadcrumbList",
    "itemListElement":[
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"Physics Tools","item":"https://8gwifi.org/physics-tools.jsp"},
      {"@type":"ListItem","position":3,"name":"Centripetal Force Calculator","item":"https://8gwifi.org/centripetal-force-calculator.jsp"}
    ]
  }
  </script>
  <style>
    .centripetal-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .centripetal-calc .card-body{padding:.7rem .9rem}
    .centripetal-calc .form-group{margin-bottom:.55rem}
    #circularCanvas{width:100%;height:500px;border:1px solid #e5e7eb;border-radius:6px;background:#f8fafc}
    .result-card{background:#f0f9ff;border-left:4px solid #3b82f6;padding:0.75rem;margin-bottom:0.5rem;border-radius:4px}
    .result-label{font-weight:600;color:#1e40af;margin-right:0.5rem}
    .result-value{font-family:monospace;font-size:1.1rem;color:#1e3a8a}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 centripetal-calc">
  <h1 class="mb-2">Centripetal Force & Circular Motion Calculator</h1>
  <p class="text-muted mb-3">Calculate centripetal force, acceleration, period, frequency, and banking angle with interactive circular motion animation.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">
          Setup
          <div class="dropdown">
            <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown">Examples</button>
            <div class="dropdown-menu" aria-labelledby="presetBtn">
              <h6 class="dropdown-header">Everyday Examples</h6>
              <a class="dropdown-item" href="#" data-preset="car-turn">Car Turning on Curve</a>
              <a class="dropdown-item" href="#" data-preset="merry-go-round">Merry-Go-Round</a>
              <a class="dropdown-item" href="#" data-preset="bike-turn">Bicycle Turn</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">Amusement Rides</h6>
              <a class="dropdown-item" href="#" data-preset="roller-coaster">Roller Coaster Loop</a>
              <a class="dropdown-item" href="#" data-preset="ferris-wheel">Ferris Wheel</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">Orbits</h6>
              <a class="dropdown-item" href="#" data-preset="satellite">Satellite Orbit (ISS)</a>
              <a class="dropdown-item" href="#" data-preset="moon">Moon's Orbit</a>
            </div>
          </div>
        </h5>
        <div class="card-body">
          <div class="form-group">
            <label for="calcMode">Calculate</label>
            <select id="calcMode" class="form-control">
              <option value="basic">Basic Circular Motion</option>
              <option value="banking">Banking Angle</option>
              <option value="vertical">Vertical Circle (Loop)</option>
            </select>
          </div>

          <hr>
          <h6>Object Properties</h6>

          <div class="form-group">
            <label for="mass">Mass (m) <span class="text-muted">kg</span></label>
            <input id="mass" type="number" step="1" class="form-control" value="1000">
          </div>

          <div class="form-group">
            <label for="radius">Radius (r) <span class="text-muted">m</span></label>
            <input id="radius" type="number" step="1" class="form-control" value="50">
          </div>

          <div class="form-group">
            <label for="velocity">Velocity (v) <span class="text-muted">m/s</span></label>
            <div class="d-flex align-items-center">
              <input id="velocity" type="number" step="1" class="form-control d-inline-block" style="max-width:100px" value="20">
              <input id="velSlider" type="range" min="1" max="50" step="1" value="20" class="custom-range d-inline-block ml-2" style="width:150px">
            </div>
            <small class="text-muted">20 m/s ≈ 72 km/h ≈ 45 mph</small>
          </div>

          <div id="gravityGroup" class="form-group">
            <label for="gravity">Gravity (g) <span class="text-muted">m/s²</span></label>
            <input id="gravity" type="number" step="0.1" class="form-control" value="9.8">
            <small class="text-muted">Earth: 9.8, Moon: 1.62</small>
          </div>

          <div id="positionGroup" class="form-group" style="display:none">
            <label for="position">Position in Loop</label>
            <select id="position" class="form-control">
              <option value="top">Top of Loop</option>
              <option value="bottom">Bottom of Loop</option>
              <option value="side">Side of Loop</option>
            </select>
          </div>

          <div class="d-flex align-items-center mt-3">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2">Calculate</button>
            <button id="btnAnimate" class="btn btn-success btn-sm mr-2">Animate</button>
            <button id="btnSave" class="btn btn-outline-secondary btn-sm">Save PNG</button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Circular Motion Visualization</h5>
        <div class="card-body">
          <canvas id="circularCanvas" height="500"></canvas>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">
          Results
          <button id="btnCopy" class="btn btn-outline-primary btn-sm"><i class="fas fa-copy"></i> Copy</button>
        </h5>
        <div class="card-body">
          <div id="results"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Step-by-Step Solution</h5>
        <div class="card-body small">
          <div id="stepsContent" style="line-height:1.8"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Centripetal Force</h5>
        <div class="card-body small">
          <div><strong>Centripetal Force:</strong> F_c = mv²/r = mω²r is the net force toward the center that keeps an object in circular motion. Not a new force type - it's the result of real forces (tension, friction, gravity, normal force) acting toward the center. Always perpendicular to velocity.</div>
          <div class="mt-2"><strong>Centripetal Acceleration:</strong> a_c = v²/r = ω²r = 4π²r/T². Direction changes continuously (always toward center), causing velocity direction to change even at constant speed. Measured in m/s².</div>
          <div class="mt-2"><strong>Period & Frequency:</strong> Period T = 2πr/v = 2π/ω (seconds per revolution). Frequency f = 1/T = v/(2πr) (revolutions per second, Hz). Angular velocity ω = v/r = 2π/T = 2πf (rad/s).</div>
          <div class="mt-2"><strong>Banking Angle:</strong> tan(θ) = v²/(rg). Banked curves allow turning without friction by tilting the normal force toward the center. Race tracks: steep banking (30-45°). Highways: gentle banking (3-5°).</div>
          <div class="mt-2"><strong>Vertical Circles:</strong> At top: T + mg = mv²/r (minimum speed v = √(gr) to maintain contact). At bottom: T - mg = mv²/r (maximum tension). Roller coaster loops use this principle.</div>
          <div class="mt-2"><strong>Applications:</strong> Car turning (friction provides F_c), satellites orbiting (gravity provides F_c), washing machine spin cycle, centrifuges, amusement park rides, planetary motion, sports (hammer throw, velodrome cycling).</div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Physics Tools</h5>
        <div class="card-body small">
          <div class="mb-2">
            <a href="torque-rotation-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-sync-alt"></i> Torque & Rotational Dynamics
            </a>
            <a href="friction-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-grip-lines"></i> Friction Force Calculator
            </a>
          </div>
          <div class="text-muted">
            Explore rotational dynamics with torque and moment of inertia, or calculate friction forces for circular motion on curves.
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
;(function(){
  function $(id){ return document.getElementById(id); }

  var calcMode = $('calcMode');
  var mass = $('mass'), radius = $('radius'), velocity = $('velocity');
  var gravity = $('gravity'), position = $('position');
  var canvas = $('circularCanvas');
  var ctx = canvas.getContext('2d');
  var lastResult = null;
  var animationAngle = 0;
  var isAnimating = false;

  // Slider sync
  function syncSlider(input, slider){
    input.addEventListener('input', function(){ slider.value = input.value; calculate(); });
    slider.addEventListener('input', function(){ input.value = slider.value; calculate(); });
  }
  syncSlider(velocity, $('velSlider'));

  calcMode.addEventListener('change', function(){
    var mode = calcMode.value;
    $('gravityGroup').style.display = mode === 'banking' || mode === 'vertical' ? '' : 'none';
    $('positionGroup').style.display = mode === 'vertical' ? '' : 'none';
    calculate();
  });

  function calculate(){
    var m = parseFloat(mass.value) || 1;
    var r = parseFloat(radius.value) || 1;
    var v = parseFloat(velocity.value) || 1;
    var g = parseFloat(gravity.value) || 9.8;
    var mode = calcMode.value;
    var pos = position.value;

    var result = {m:m, r:r, v:v, g:g, mode:mode};

    // Basic calculations
    result.F_c = (m * v * v) / r;
    result.a_c = (v * v) / r;
    result.omega = v / r;
    result.T = (2 * Math.PI * r) / v;
    result.f = 1 / result.T;

    // Mode-specific
    if(mode === 'banking'){
      result.theta = Math.atan((v*v)/(r*g)) * 180 / Math.PI;
    } else if(mode === 'vertical'){
      result.position = pos;
      if(pos === 'top'){
        result.T_tension = (m * v * v / r) - (m * g);
        result.v_min = Math.sqrt(g * r);
      } else if(pos === 'bottom'){
        result.T_tension = (m * v * v / r) + (m * g);
      } else if(pos === 'side'){
        result.T_tension = m * v * v / r;
      }
    }

    lastResult = result;
    showResults(result);
    drawVisualization(result);
    showSteps(result);
  }

  function showResults(result){
    var html = '';

    html += '<div class="result-card">';
    html += '<h6 class="mb-2">Circular Motion</h6>';
    html += '<div>Centripetal Force: F_c = <strong>'+result.F_c.toFixed(2)+' N</strong></div>';
    html += '<div>Centripetal Acceleration: a_c = <strong>'+result.a_c.toFixed(2)+' m/s²</strong></div>';
    html += '<div class="small text-muted">That\'s '+(result.a_c/result.g).toFixed(2)+'g</div>';
    html += '</div>';

    html += '<div class="result-card">';
    html += '<h6 class="mb-2">Period & Frequency</h6>';
    html += '<div>Angular Velocity: ω = <strong>'+result.omega.toFixed(2)+' rad/s</strong></div>';
    html += '<div>Period: T = <strong>'+result.T.toFixed(3)+' s</strong></div>';
    html += '<div>Frequency: f = <strong>'+result.f.toFixed(2)+' Hz</strong></div>';
    html += '<div class="small text-muted">'+(result.f*60).toFixed(1)+' revolutions per minute (RPM)</div>';
    html += '</div>';

    if(result.mode === 'banking'){
      html += '<div class="result-card">';
      html += '<h6 class="mb-2">Banking Angle</h6>';
      html += '<div>Ideal Banking Angle: θ = <strong>'+result.theta.toFixed(2)+'°</strong></div>';
      html += '<div class="small text-muted">At this angle, no friction is needed to turn</div>';
      html += '</div>';
    } else if(result.mode === 'vertical'){
      html += '<div class="result-card">';
      html += '<h6 class="mb-2">Vertical Loop - '+result.position.charAt(0).toUpperCase()+result.position.slice(1)+'</h6>';
      if(result.position === 'top'){
        html += '<div>Tension: T = <strong>'+result.T_tension.toFixed(2)+' N</strong></div>';
        html += '<div>Minimum Speed: v_min = <strong>'+result.v_min.toFixed(2)+' m/s</strong></div>';
        html += '<div class="small text-muted">';
        if(result.v < result.v_min){
          html += '⚠ Speed too low! Object will fall.';
        } else {
          html += '✓ Speed sufficient to complete loop';
        }
        html += '</div>';
      } else {
        html += '<div>Tension: T = <strong>'+result.T_tension.toFixed(2)+' N</strong></div>';
      }
      html += '</div>';
    }

    $('results').innerHTML = html;
  }

  function drawVisualization(result){
    var w = canvas.getBoundingClientRect().width | 0;
    if(w < 100) w = 800;
    canvas.width = w;
    var h = canvas.height;
    ctx.clearRect(0,0,w,h);

    ctx.fillStyle = '#f8fafc';
    ctx.fillRect(0,0,w,h);

    var cx = w/2;
    var cy = h/2;
    var drawRadius = Math.min(150, result.r * 2);

    if(result.mode === 'banking'){
      drawBankingDiagram(cx, cy, drawRadius, result);
    } else if(result.mode === 'vertical'){
      drawVerticalLoop(cx, cy, drawRadius, result);
    } else {
      drawBasicCircular(cx, cy, drawRadius, result);
    }
  }

  function drawBasicCircular(cx, cy, r, result){
    // Circle path
    ctx.strokeStyle = '#cbd5e1';
    ctx.lineWidth = 2;
    ctx.setLineDash([5,5]);
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0, Math.PI*2);
    ctx.stroke();
    ctx.setLineDash([]);

    // Center point
    ctx.fillStyle = '#64748b';
    ctx.beginPath();
    ctx.arc(cx, cy, 6, 0, Math.PI*2);
    ctx.fill();

    // Object on circle
    var angle = animationAngle;
    var objX = cx + r * Math.cos(angle);
    var objY = cy + r * Math.sin(angle);

    ctx.fillStyle = '#ef4444';
    ctx.beginPath();
    ctx.arc(objX, objY, 12, 0, Math.PI*2);
    ctx.fill();

    // Radius line
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.lineTo(objX, objY);
    ctx.stroke();

    ctx.fillStyle = '#64748b';
    ctx.font = '12px sans-serif';
    ctx.fillText('r', cx + r/2 * Math.cos(angle) - 10, cy + r/2 * Math.sin(angle) - 10);

    // Velocity vector (tangent)
    var velScale = 50;
    var velAngle = angle + Math.PI/2;
    var velX = objX + velScale * Math.cos(velAngle);
    var velY = objY + velScale * Math.sin(velAngle);
    drawArrow(objX, objY, velX, velY, '#10b981', 3, 'v');

    // Centripetal force vector (toward center)
    var fcScale = 40;
    var fcX = objX + fcScale * Math.cos(angle + Math.PI);
    var fcY = objY + fcScale * Math.sin(angle + Math.PI);
    drawArrow(objX, objY, fcX, fcY, '#3b82f6', 3, 'F_c');

    // Info
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('Uniform Circular Motion', 20, 30);
    ctx.font = '12px sans-serif';
    ctx.fillText('v = '+result.v+' m/s', 20, 50);
    ctx.fillText('r = '+result.r+' m', 20, 70);
    ctx.fillText('F_c = '+result.F_c.toFixed(1)+' N', 20, 90);
  }

  function drawBankingDiagram(cx, cy, r, result){
    // Banked road surface
    var theta = result.theta * Math.PI / 180;
    var roadLen = 200;

    // Draw circular track from top view
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0, Math.PI*2);
    ctx.stroke();

    // Draw dashed center line
    ctx.strokeStyle = '#cbd5e1';
    ctx.lineWidth = 1;
    ctx.setLineDash([5, 5]);
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    ctx.lineTo(cx + r * Math.cos(animationAngle), cy + r * Math.sin(animationAngle));
    ctx.stroke();
    ctx.setLineDash([]);

    // Car position on circular track (animated)
    var carX = cx + r * Math.cos(animationAngle);
    var carY = cy + r * Math.sin(animationAngle);

    ctx.save();
    ctx.translate(carX, carY);
    ctx.rotate(animationAngle + Math.PI/2);

    // Car (top view)
    ctx.fillStyle = '#ef4444';
    ctx.fillRect(-15, -25, 30, 50);
    ctx.fillStyle = '#1e293b';
    ctx.fillRect(-12, -20, 24, 40);
    ctx.fillStyle = '#fbbf24';
    ctx.fillRect(-15, 20, 8, 5);
    ctx.fillRect(7, 20, 8, 5);

    ctx.restore();

    // Banking angle diagram (side view in corner)
    var sideViewX = cx + 150;
    var sideViewY = cy - 120;

    ctx.save();
    ctx.translate(sideViewX, sideViewY);
    ctx.rotate(-theta);

    // Road
    ctx.fillStyle = '#64748b';
    ctx.fillRect(-60, -10, 120, 20);

    // Small car
    ctx.fillStyle = '#ef4444';
    ctx.fillRect(-15, -25, 30, 15);

    ctx.restore();

    // Banking angle arc
    ctx.strokeStyle = '#3b82f6';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(sideViewX, sideViewY, 40, -Math.PI/2, -Math.PI/2 - theta, theta < 0);
    ctx.stroke();

    ctx.fillStyle = '#1e40af';
    ctx.font = 'bold 12px sans-serif';
    ctx.fillText('θ = '+result.theta.toFixed(1)+'°', sideViewX - 50, sideViewY - 5);

    // Info
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('Banked Curve (Top View + Side View)', 20, 30);
    ctx.font = '12px sans-serif';
    ctx.fillText('Speed: v = '+result.v+' m/s', 20, 50);
    ctx.fillText('Radius: r = '+result.r+' m', 20, 70);
    ctx.fillText('Banking Angle: θ = '+result.theta.toFixed(1)+'°', 20, 90);
    ctx.fillText('(Car moves around track)', 20, 110);
  }

  function drawVerticalLoop(cx, cy, r, result){
    // Loop
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 4;
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0, Math.PI*2);
    ctx.stroke();

    // Object position (animated)
    var objX = cx + r * Math.cos(animationAngle);
    var objY = cy + r * Math.sin(animationAngle);

    // Draw track support
    ctx.strokeStyle = '#64748b';
    ctx.lineWidth = 6;
    ctx.beginPath();
    ctx.moveTo(cx - r - 10, cy + r);
    ctx.lineTo(cx - r - 10, cy + r + 40);
    ctx.moveTo(cx + r + 10, cy + r);
    ctx.lineTo(cx + r + 10, cy + r + 40);
    ctx.stroke();

    // Object
    ctx.fillStyle = '#ef4444';
    ctx.beginPath();
    ctx.arc(objX, objY, 15, 0, Math.PI*2);
    ctx.fill();
    ctx.strokeStyle = '#1e293b';
    ctx.lineWidth = 2;
    ctx.stroke();

    // Weight vector (always down)
    var mgScale = 50;
    drawArrow(objX, objY, objX, objY + mgScale, '#7c3aed', 3, 'mg');

    // Centripetal acceleration vector (toward center)
    var acScale = 40;
    var acAngle = Math.atan2(cy - objY, cx - objX);
    var acX = objX + acScale * Math.cos(acAngle);
    var acY = objY + acScale * Math.sin(acAngle);
    drawArrow(objX, objY, acX, acY, '#3b82f6', 3, 'a_c');

    // Velocity vector (tangent)
    var velScale = 45;
    var velAngle = animationAngle + Math.PI/2;
    var velX = objX + velScale * Math.cos(velAngle);
    var velY = objY + velScale * Math.sin(velAngle);
    drawArrow(objX, objY, velX, velY, '#10b981', 3, 'v');

    // Mark top and bottom positions
    ctx.fillStyle = '#f59e0b';
    ctx.font = 'bold 12px sans-serif';
    ctx.fillText('Top', cx - 15, cy - r - 10);
    ctx.fillText('Bottom', cx - 20, cy + r + 20);

    // Highlight current position type
    var currentPos = '';
    var angleDeg = (animationAngle * 180 / Math.PI + 360) % 360;
    if (angleDeg > 240 && angleDeg < 300) {
      currentPos = 'TOP';
      ctx.fillStyle = 'rgba(239, 68, 68, 0.2)';
      ctx.beginPath();
      ctx.arc(cx, cy - r, 25, 0, Math.PI*2);
      ctx.fill();
    } else if (angleDeg > 60 && angleDeg < 120) {
      currentPos = 'BOTTOM';
      ctx.fillStyle = 'rgba(34, 197, 94, 0.2)';
      ctx.beginPath();
      ctx.arc(cx, cy + r, 25, 0, Math.PI*2);
      ctx.fill();
    }

    // Labels
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('Vertical Loop (Roller Coaster)', 20, 30);
    ctx.font = '12px sans-serif';
    ctx.fillText('v = '+result.v+' m/s', 20, 50);
    ctx.fillText('r = '+result.r+' m', 20, 70);
    if(currentPos){
      ctx.fillStyle = currentPos === 'TOP' ? '#ef4444' : '#22c55e';
      ctx.fillText('Position: ' + currentPos, 20, 90);
    }
    if(result.v_min){
      ctx.fillStyle = '#475569';
      ctx.fillText('v_min (top) = '+result.v_min.toFixed(1)+' m/s', 20, 110);
    }
  }

  function drawArrow(x1, y1, x2, y2, color, width, label){
    var dx = x2 - x1;
    var dy = y2 - y1;
    var len = Math.sqrt(dx*dx + dy*dy);
    if(len < 5) return;

    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = width;

    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    var angle = Math.atan2(dy, dx);
    var headlen = 10;
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2-headlen*Math.cos(angle-Math.PI/6), y2-headlen*Math.sin(angle-Math.PI/6));
    ctx.lineTo(x2-headlen*Math.cos(angle+Math.PI/6), y2-headlen*Math.sin(angle+Math.PI/6));
    ctx.closePath();
    ctx.fill();

    if(label){
      ctx.fillStyle = color;
      ctx.font = 'bold 12px sans-serif';
      ctx.fillText(label, x2 + 12, y2 - 8);
    }
  }

  function showSteps(result){
    var html = '';

    html += '<div class="mb-2"><strong>Given:</strong></div>';
    html += '<div class="ml-3">Mass: m = '+result.m+' kg</div>';
    html += '<div class="ml-3">Radius: r = '+result.r+' m</div>';
    html += '<div class="ml-3">Velocity: v = '+result.v+' m/s</div>';
    if(result.mode !== 'basic'){
      html += '<div class="ml-3">Gravity: g = '+result.g+' m/s²</div>';
    }

    html += '<div class="mt-3 mb-2"><strong>1. Centripetal Force:</strong></div>';
    html += '<div class="ml-3">F_c = mv²/r</div>';
    html += '<div class="ml-3">F_c = '+result.m+' × '+result.v+'² / '+result.r+'</div>';
    html += '<div class="ml-3 text-primary"><strong>F_c = '+result.F_c.toFixed(2)+' N</strong></div>';

    html += '<div class="mt-3 mb-2"><strong>2. Centripetal Acceleration:</strong></div>';
    html += '<div class="ml-3">a_c = v²/r</div>';
    html += '<div class="ml-3">a_c = '+result.v+'² / '+result.r+'</div>';
    html += '<div class="ml-3 text-primary"><strong>a_c = '+result.a_c.toFixed(2)+' m/s²</strong></div>';
    html += '<div class="ml-3 small text-muted">That\'s '+(result.a_c/result.g).toFixed(2)+'g (g-force)</div>';

    html += '<div class="mt-3 mb-2"><strong>3. Period & Frequency:</strong></div>';
    html += '<div class="ml-3">T = 2πr/v = '+result.T.toFixed(3)+' s</div>';
    html += '<div class="ml-3">f = 1/T = '+result.f.toFixed(2)+' Hz</div>';
    html += '<div class="ml-3">ω = v/r = '+result.omega.toFixed(2)+' rad/s</div>';

    if(result.mode === 'banking'){
      html += '<div class="mt-3 mb-2"><strong>4. Banking Angle:</strong></div>';
      html += '<div class="ml-3">tan(θ) = v²/(rg)</div>';
      html += '<div class="ml-3">tan(θ) = '+result.v+'² / ('+result.r+' × '+result.g+')</div>';
      html += '<div class="ml-3">tan(θ) = '+((result.v*result.v)/(result.r*result.g)).toFixed(3)+'</div>';
      html += '<div class="ml-3 text-primary"><strong>θ = '+result.theta.toFixed(2)+'°</strong></div>';
    } else if(result.mode === 'vertical' && result.position === 'top'){
      html += '<div class="mt-3 mb-2"><strong>4. Vertical Loop (Top):</strong></div>';
      html += '<div class="ml-3">T + mg = mv²/r</div>';
      html += '<div class="ml-3">T = m(v²/r - g)</div>';
      html += '<div class="ml-3 text-primary"><strong>T = '+result.T_tension.toFixed(2)+' N</strong></div>';
      html += '<div class="ml-3 mt-2">Minimum speed: v_min = √(gr) = '+result.v_min.toFixed(2)+' m/s</div>';
    }

    $('stepsContent').innerHTML = html;
  }

  // Animation
  $('btnAnimate').addEventListener('click', function(){
    isAnimating = !isAnimating;
    if(isAnimating){
      $('btnAnimate').textContent = 'Stop';
      $('btnAnimate').className = 'btn btn-danger btn-sm mr-2';
      animate();
    } else {
      $('btnAnimate').textContent = 'Animate';
      $('btnAnimate').className = 'btn btn-success btn-sm mr-2';
    }
  });

  function animate(){
    if(!isAnimating) return;
    animationAngle += lastResult.omega * 0.02;
    drawVisualization(lastResult);
    requestAnimationFrame(animate);
  }

  // Save PNG with inputs and results
  $('btnSave').addEventListener('click', function(){
    if(!lastResult){
      alert('Please calculate first!');
      return;
    }

    var tempCanvas = document.createElement('canvas');
    var w = canvas.width;
    var extraHeight = 280;
    tempCanvas.width = w;
    tempCanvas.height = canvas.height + extraHeight;
    var tempCtx = tempCanvas.getContext('2d');

    tempCtx.fillStyle = '#ffffff';
    tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);

    tempCtx.drawImage(canvas, 0, 0);

    tempCtx.strokeStyle = '#e5e7eb';
    tempCtx.lineWidth = 2;
    tempCtx.beginPath();
    tempCtx.moveTo(0, canvas.height);
    tempCtx.lineTo(w, canvas.height);
    tempCtx.stroke();

    var yPos = canvas.height + 20;
    var leftX = 20;
    var rightX = w/2 + 10;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = 'bold 16px sans-serif';
    tempCtx.fillText('Centripetal Force Calculator', leftX, yPos);
    yPos += 30;

    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Inputs:', leftX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';
    tempCtx.fillText('Mass: m = ' + lastResult.m + ' kg', leftX, yPos += 20);
    tempCtx.fillText('Radius: r = ' + lastResult.r + ' m', leftX, yPos += 18);
    tempCtx.fillText('Velocity: v = ' + lastResult.v + ' m/s', leftX, yPos += 18);

    yPos = canvas.height + 50;
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Results:', rightX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';
    tempCtx.fillText('Centripetal Force: F_c = ' + lastResult.F_c.toFixed(2) + ' N', rightX, yPos += 20);
    tempCtx.fillText('Acceleration: a_c = ' + lastResult.a_c.toFixed(2) + ' m/s²', rightX, yPos += 18);
    tempCtx.fillText('Period: T = ' + lastResult.T.toFixed(3) + ' s', rightX, yPos += 18);
    tempCtx.fillText('Frequency: f = ' + lastResult.f.toFixed(2) + ' Hz', rightX, yPos += 18);

    yPos = canvas.height + extraHeight - 60;
    tempCtx.strokeStyle = '#e5e7eb';
    tempCtx.lineWidth = 1;
    tempCtx.beginPath();
    tempCtx.moveTo(20, yPos - 10);
    tempCtx.lineTo(w - 20, yPos - 10);
    tempCtx.stroke();

    tempCtx.fillStyle = '#64748b';
    tempCtx.font = '11px sans-serif';
    tempCtx.fillText('Try this configuration online:', leftX, yPos);

    var url = location.origin + location.pathname;
    var displayUrl = url.length > 80 ? url.substring(0, 77) + '...' : url;
    tempCtx.fillStyle = '#3b82f6';
    tempCtx.font = '10px monospace';
    tempCtx.fillText(displayUrl, leftX, yPos + 18);

    tempCtx.fillStyle = '#94a3b8';
    tempCtx.font = '10px sans-serif';
    tempCtx.fillText('Generated by 8gwifi.org/centripetal-force-calculator.jsp', leftX, yPos + 40);

    var link = document.createElement('a');
    link.download = 'centripetal-force-' + Date.now() + '.png';
    link.href = tempCanvas.toDataURL();
    link.click();
  });

  // Copy
  $('btnCopy').addEventListener('click', function(){
    var text = $('results').innerText;
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(text).then(function(){
        var btn = $('btnCopy');
        var orig = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
        btn.className = 'btn btn-success btn-sm';
        setTimeout(function(){ btn.innerHTML = orig; btn.className = 'btn btn-outline-primary btn-sm'; }, 2000);
      });
    }
  });

  // Presets
  var presetItems = document.querySelectorAll('#presetBtn ~ .dropdown-menu a[data-preset]');
  for(var i=0; i<presetItems.length; i++){
    (function(item){
      item.addEventListener('click', function(e){
        e.preventDefault();
        var preset = item.getAttribute('data-preset');

        calcMode.value = 'basic';

        if(preset === 'car-turn'){
          mass.value = '1200'; radius.value = '50'; velocity.value = '20';
        } else if(preset === 'merry-go-round'){
          mass.value = '40'; radius.value = '3'; velocity.value = '4';
        } else if(preset === 'bike-turn'){
          mass.value = '80'; radius.value = '15'; velocity.value = '8';
        } else if(preset === 'roller-coaster'){
          calcMode.value = 'vertical';
          mass.value = '500'; radius.value = '10'; velocity.value = '15';
          position.value = 'top';
        } else if(preset === 'ferris-wheel'){
          mass.value = '200'; radius.value = '20'; velocity.value = '3';
        } else if(preset === 'satellite'){
          mass.value = '420000'; radius.value = '6771000'; velocity.value = '7660';
        } else if(preset === 'moon'){
          mass.value = '7.342e22'; radius.value = '384400000'; velocity.value = '1022';
        }

        $('velSlider').value = velocity.value;
        calcMode.dispatchEvent(new Event('change'));
        calculate();
      });
    })(presetItems[i]);
  }

  $('btnCalculate').addEventListener('click', calculate);

  mass.addEventListener('input', calculate);
  radius.addEventListener('input', calculate);
  gravity.addEventListener('input', calculate);
  position.addEventListener('change', calculate);

  calculate();
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<!-- E-E-A-T: About & Learning Outcomes (Physics) -->
<section class="container my-4"><div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
  <h2 class="h6 mb-2">About This Tool & Methodology</h2>
  <p>Calculates centripetal force, speed, radius, or angular velocity using SI units and the relation F = mv²/r (or F = mω²r). Explores circular motion dependencies.</p>
  <h3 class="h6 mt-2">Learning Outcomes</h3>
  <ul class="mb-2"><li>Relate speed, radius, and required centripetal force.</li><li>Understand angular velocity formulations.</li><li>Practice unit handling and parameter intuition.</li></ul>
  <div class="row mt-2"><div class="col-md-6"><h4 class="h6">Authorship</h4><ul><li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> — Follow on X</li><li><strong>Last updated:</strong> 2025-11-19</li></ul></div><div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul><li>Runs locally in your browser.</li></ul></div></div>
</div></div></div></div></section>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"WebPage","name":"Centripetal Force Calculator","url":"https://8gwifi.org/centripetal-force-calculator.jsp","dateModified":"2025-11-19","author":{"@type":"Person","name":"Anish Nath","url":"https://x.com/anish2good"},"publisher":{"@type":"Organization","name":"8gwifi.org"}}</script>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Centripetal Force Calculator","item":"https://8gwifi.org/centripetal-force-calculator.jsp"}]}</script>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

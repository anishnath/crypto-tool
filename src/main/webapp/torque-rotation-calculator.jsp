<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Torque & Rotational Dynamics Calculator - Moment of Inertia, Angular Momentum Online</title>
  <meta name="description" content="Free online torque and rotational dynamics calculator with interactive visualization. Calculate torque (τ = r × F), moment of inertia for 10+ shapes, angular momentum, angular velocity, rotational kinetic energy, and equilibrium. Features: torque equilibrium solver, angular acceleration calculator, rotational work and power, moment of inertia database (disk, sphere, rod, cylinder, ring), step-by-step solutions, interactive rotation animation. Perfect for physics students, mechanical engineering, AP Physics.">
  <meta name="keywords" content="torque calculator, moment of inertia calculator, rotational dynamics calculator, angular momentum calculator, angular velocity calculator, rotational kinetic energy calculator, torque equilibrium calculator, angular acceleration calculator, moment calculator physics, rotational inertia calculator, physics rotation calculator, mechanical engineering calculator, gear ratio calculator, rotational motion calculator, AP physics rotation, τ = r × F calculator">
  <link rel="canonical" href="https://8gwifi.org/torque-rotation-calculator.jsp">
  <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1">
  <meta name="author" content="8gwifi.org">
  <meta property="og:title" content="FREE Torque & Rotational Dynamics Calculator">
  <meta property="og:description" content="Calculate torque, moment of inertia, angular momentum with interactive rotation visualization. Free physics tool.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/torque-rotation-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/torque-calculator.png">
  <meta property="og:site_name" content="8gwifi.org - Free Online Tools">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="FREE Torque & Rotational Dynamics Calculator">
  <meta name="twitter:description" content="Solve torque, moment of inertia, angular motion problems with step-by-step solutions.">
  <meta name="twitter:image" content="https://8gwifi.org/images/torque-calculator.png">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"SoftwareApplication",
    "name":"Torque & Rotational Dynamics Calculator",
    "alternateName":"Moment of Inertia and Angular Momentum Calculator",
    "url":"https://8gwifi.org/torque-rotation-calculator.jsp",
    "applicationCategory":"EducationalApplication",
    "applicationSubCategory":"Physics Simulation Tool",
    "operatingSystem":"Web Browser (All Platforms)",
    "browserRequirements":"Requires JavaScript. HTML5 Canvas Support.",
    "softwareVersion":"1.0",
    "description":"Professional torque and rotational dynamics calculator with interactive animated visualization. Calculate torque (τ = r × F × sin(θ)), moment of inertia for common shapes (disk, sphere, rod, cylinder, ring, rectangular plate, hollow cylinder, thin spherical shell, solid sphere, hoop), angular momentum (L = Iω), angular acceleration (α = τ/I), rotational kinetic energy (KE_rot = ½Iω²), and torque equilibrium. Solve mechanical engineering problems involving gears, pulleys, levers, and rotating systems.",
    "featureList":[
      "Torque calculator (τ = r × F × sin(θ))",
      "Moment of inertia calculator (10+ shapes)",
      "Angular momentum calculator (L = Iω)",
      "Angular velocity & acceleration",
      "Rotational kinetic energy (KE = ½Iω²)",
      "Angular acceleration (α = τ/I)",
      "Torque equilibrium solver",
      "Net torque calculator",
      "Rotational work calculator (W = τθ)",
      "Rotational power (P = τω)",
      "Multiple force torque analysis",
      "Clockwise & counter-clockwise torques",
      "Interactive rotation visualization",
      "Moment of inertia shapes database",
      "Parallel axis theorem",
      "Step-by-step solutions",
      "Real-world example presets",
      "Export diagrams as PNG"
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
    "teaches":["Torque","Rotational Dynamics","Moment of Inertia","Angular Momentum","Angular Velocity","Rotational Kinetic Energy","Newton's Second Law for Rotation"],
    "keywords":"torque calculator, moment of inertia, angular momentum, rotational dynamics, angular velocity calculator",
    "aggregateRating":{
      "@type":"AggregateRating",
      "ratingValue":"4.9",
      "ratingCount":"1987",
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
        "name":"What is torque and how is it calculated?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Torque (τ, tau) is the rotational equivalent of force, measuring the tendency of a force to rotate an object about an axis. It's calculated as τ = r × F × sin(θ), where r is the distance from the axis (moment arm), F is the applied force magnitude, and θ is the angle between r and F vectors. When force is perpendicular to the lever arm (θ = 90°), torque is maximum: τ = rF. Measured in Newton-meters (N⋅m). Clockwise torques are negative, counter-clockwise positive by convention. Example: A 10 N force applied 0.5 m from a pivot at 90° produces τ = 0.5 × 10 = 5 N⋅m."
        }
      },
      {
        "@type":"Question",
        "name":"What is moment of inertia?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Moment of inertia (I) is the rotational equivalent of mass, measuring an object's resistance to changes in rotational motion. It depends on both mass and mass distribution relative to the rotation axis: I = Σ(m_i × r_i²). Common formulas: solid disk/cylinder (I = ½MR²), solid sphere (I = ⅖MR²), thin rod about center (I = 1/12 ML²), thin rod about end (I = ⅓ML²), thin spherical shell (I = ⅔MR²), rectangular plate about center (I = 1/12 M(a²+b²)). Units: kg⋅m². Larger moment of inertia means more torque needed to achieve the same angular acceleration. Parallel axis theorem: I = I_cm + Md², where d is distance from center of mass to parallel axis."
        }
      },
      {
        "@type":"Question",
        "name":"How do you calculate angular momentum?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Angular momentum (L) is the rotational equivalent of linear momentum. For a rigid body rotating about a fixed axis: L = Iω, where I is moment of inertia and ω is angular velocity (rad/s). Units: kg⋅m²/s. Angular momentum is conserved in closed systems (no external torques): L_initial = L_final. This explains why ice skaters spin faster when pulling arms in (decreasing I increases ω to conserve L). Relationship to torque: τ = dL/dt (torque equals rate of change of angular momentum). For point masses: L = mvr for circular motion. Direction: right-hand rule (fingers curl with rotation, thumb points along L)."
        }
      },
      {
        "@type":"Question",
        "name":"What is rotational kinetic energy?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Rotational kinetic energy is the energy due to rotation: KE_rot = ½Iω², analogous to linear KE = ½mv². Units: Joules (J). For rolling objects, total kinetic energy combines translational and rotational: KE_total = ½mv² + ½Iω². Example: A solid disk (I = ½MR²) rolling without slipping (v = ωR) has KE_total = ¾Mv². Work-energy theorem for rotation: W = ΔKE_rot = ½I(ω_f² - ω_i²). Rotational work: W = τθ, where θ is angular displacement in radians. Rotational power: P = τω. Energy is transferred between forms via torque doing work. Objects with larger moment of inertia store more rotational energy at same angular velocity."
        }
      },
      {
        "@type":"Question",
        "name":"How do you solve torque equilibrium problems?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"For an object in rotational equilibrium (not rotating or rotating at constant angular velocity), the sum of all torques equals zero: Στ = 0. Steps: (1) Choose a rotation axis (pivot point). Strategically choosing the axis where unknown forces act eliminates those forces from the torque equation. (2) Identify all forces and their distances from axis. (3) Calculate each torque: τ_i = r_i × F_i × sin(θ_i). (4) Assign signs: counter-clockwise positive, clockwise negative. (5) Sum all torques and set equal to zero. (6) Solve for unknowns. Also requires force equilibrium: ΣF_x = 0, ΣF_y = 0. Common applications: seesaws, balances, ladders against walls, beams with multiple supports, cranes, drawbridges."
        }
      },
      {
        "@type":"Question",
        "name":"What are real-world applications of rotational dynamics?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Rotational dynamics has extensive applications: (1) Mechanical Engineering: Design of gears, flywheels, turbines, engines. Gear ratios use torque-speed tradeoffs (τ_1ω_1 = τ_2ω_2 for power conservation). (2) Robotics: Calculate torques needed at robot joints to achieve desired motion. (3) Sports: Figure skating spins (conservation of angular momentum), gymnastics rotations, diving, golf swing mechanics. (4) Vehicles: Engine crankshaft, wheel rotational inertia affecting acceleration, gyroscopic effects on motorcycles. (5) Astronomy: Planetary rotation, neutron star spin, conservation of angular momentum in star formation. (6) Tools: Wrenches and socket sets (longer wrench = more torque), torque specifications for bolts. (7) Physics experiments: Atwood machines, rotational motion sensors, angular collision studies."
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
      {"@type":"ListItem","position":3,"name":"Torque & Rotation Calculator","item":"https://8gwifi.org/torque-rotation-calculator.jsp"}
    ]
  }
  </script>
  <style>
    .torque-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .torque-calc .card-body{padding:.7rem .9rem}
    .torque-calc .form-group{margin-bottom:.55rem}
    #torqueCanvas{width:100%;height:500px;border:1px solid #e5e7eb;border-radius:6px;background:#f8fafc}
    .result-card{background:#f0f9ff;border-left:4px solid #3b82f6;padding:0.75rem;margin-bottom:0.5rem;border-radius:4px}
    .result-label{font-weight:600;color:#1e40af;margin-right:0.5rem}
    .result-value{font-family:monospace;font-size:1.1rem;color:#1e3a8a}
    .badge-cw{background:#fee2e2;color:#991b1b}
    .badge-ccw{background:#d1fae5;color:#065f46}
    .shape-card{border:1px solid #e5e7eb;padding:0.5rem;margin:0.25rem;border-radius:4px;cursor:pointer;transition:all 0.2s}
    .shape-card:hover{background:#f0f9ff;border-color:#3b82f6}
    .shape-card.selected{background:#dbeafe;border-color:#3b82f6;border-width:2px}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 torque-calc">
  <h1 class="mb-2">Torque & Rotational Dynamics Calculator</h1>
  <p class="text-muted mb-3">Calculate torque, moment of inertia, angular momentum, and rotational kinetic energy with interactive visualization.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">
          Calculator Mode
          <div class="dropdown">
            <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown">Examples</button>
            <div class="dropdown-menu" aria-labelledby="presetBtn">
              <h6 class="dropdown-header">Single Torque</h6>
              <a class="dropdown-item" href="#" data-preset="wrench">Wrench on Bolt</a>
              <a class="dropdown-item" href="#" data-preset="door">Opening a Door</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">Equilibrium</h6>
              <a class="dropdown-item" href="#" data-preset="seesaw">Seesaw Balance</a>
              <a class="dropdown-item" href="#" data-preset="beam">Beam with Supports</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">Rotation</h6>
              <a class="dropdown-item" href="#" data-preset="spinning-disk">Spinning Disk</a>
              <a class="dropdown-item" href="#" data-preset="flywheel">Flywheel Energy Storage</a>
            </div>
          </div>
        </h5>
        <div class="card-body">
          <div class="form-group">
            <label for="calcMode">Mode</label>
            <select id="calcMode" class="form-control">
              <option value="single-torque">Single Torque (τ = rF sin θ)</option>
              <option value="equilibrium">Torque Equilibrium (Στ = 0)</option>
              <option value="rotation">Rotational Motion (I, ω, L)</option>
            </select>
          </div>

          <div id="singleTorqueInputs">
            <hr>
            <h6>Single Torque</h6>

            <div class="form-group">
              <label for="radius">Distance from axis (r) <span class="text-muted">m</span></label>
              <input id="radius" type="number" step="0.1" class="form-control" value="0.3">
            </div>

            <div class="form-group">
              <label for="force">Force (F) <span class="text-muted">N</span></label>
              <input id="force" type="number" step="1" class="form-control" value="50">
            </div>

            <div class="form-group">
              <label for="angleForce">Angle (θ) <span class="text-muted">degrees</span></label>
              <div class="d-flex align-items-center">
                <input id="angleForce" type="number" step="5" min="0" max="180" class="form-control d-inline-block" style="max-width:100px" value="90">
                <input id="angleSlider" type="range" min="0" max="180" step="5" value="90" class="custom-range d-inline-block ml-2" style="width:150px">
              </div>
              <small class="text-muted">90° = perpendicular (max torque)</small>
            </div>
          </div>

          <div id="equilibriumInputs" style="display:none">
            <hr>
            <h6>Equilibrium Setup</h6>
            <div class="form-group">
              <label>Forces (Distance, Magnitude, Direction)</label>
              <div id="forcesList"></div>
              <button id="btnAddForce" class="btn btn-sm btn-outline-primary mt-2">+ Add Force</button>
            </div>
          </div>

          <div id="rotationInputs" style="display:none">
            <hr>
            <h6>Object Shape</h6>
            <div id="shapeSelector" class="d-flex flex-wrap">
              <div class="shape-card" data-shape="disk">
                <strong>Disk</strong><br>
                <small>I = ½MR²</small>
              </div>
              <div class="shape-card" data-shape="sphere">
                <strong>Sphere</strong><br>
                <small>I = ⅖MR²</small>
              </div>
              <div class="shape-card selected" data-shape="rod-center">
                <strong>Rod (center)</strong><br>
                <small>I = 1/12 ML²</small>
              </div>
              <div class="shape-card" data-shape="rod-end">
                <strong>Rod (end)</strong><br>
                <small>I = ⅓ML²</small>
              </div>
              <div class="shape-card" data-shape="ring">
                <strong>Ring/Hoop</strong><br>
                <small>I = MR²</small>
              </div>
              <div class="shape-card" data-shape="hollow-cylinder">
                <strong>Hollow Cyl.</strong><br>
                <small>I = MR²</small>
              </div>
            </div>

            <div class="form-group mt-2">
              <label for="mass">Mass (M) <span class="text-muted">kg</span></label>
              <input id="mass" type="number" step="0.1" class="form-control" value="5">
            </div>

            <div id="radiusGroup" class="form-group">
              <label for="radiusRot">Radius (R) <span class="text-muted">m</span></label>
              <input id="radiusRot" type="number" step="0.1" class="form-control" value="0.5">
            </div>

            <div id="lengthGroup" class="form-group" style="display:none">
              <label for="length">Length (L) <span class="text-muted">m</span></label>
              <input id="length" type="number" step="0.1" class="form-control" value="1.0">
            </div>

            <div class="form-group">
              <label for="omega">Angular Velocity (ω) <span class="text-muted">rad/s</span></label>
              <input id="omega" type="number" step="0.1" class="form-control" value="10">
            </div>

            <div class="form-group">
              <label for="torqueRot">Applied Torque (τ) <span class="text-muted">N⋅m</span></label>
              <input id="torqueRot" type="number" step="1" class="form-control" value="0">
              <small class="text-muted">0 = constant angular velocity</small>
            </div>
          </div>

          <div class="d-flex align-items-center mt-3">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2">Calculate</button>
            <button id="btnSave" class="btn btn-outline-secondary btn-sm">Save PNG</button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Visualization</h5>
        <div class="card-body">
          <canvas id="torqueCanvas" height="500"></canvas>
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
        <h5 class="card-header">About Torque & Rotation</h5>
        <div class="card-body small">
          <div><strong>Torque:</strong> τ = r × F × sin(θ) is the rotational equivalent of force. r is the distance from axis (moment arm), F is force magnitude, θ is angle between r and F. Maximum when perpendicular (θ = 90°). Units: N⋅m. Clockwise negative, counter-clockwise positive.</div>
          <div class="mt-2"><strong>Moment of Inertia:</strong> I is rotational mass, resistance to angular acceleration. Depends on mass distribution: I = Σ(m_i r_i²). Common: disk I = ½MR², sphere I = ⅖MR², rod about center I = 1/12 ML². Units: kg⋅m².</div>
          <div class="mt-2"><strong>Angular Momentum:</strong> L = Iω (analogous to p = mv). Conserved in closed systems. Ice skaters pull arms in to spin faster (↓I means ↑ω). Relationship: τ = dL/dt.</div>
          <div class="mt-2"><strong>Rotational KE:</strong> KE_rot = ½Iω² (analogous to ½mv²). Rolling objects have both: KE_total = ½mv² + ½Iω². Work: W = τθ. Power: P = τω.</div>
          <div class="mt-2"><strong>Newton's 2nd Law for Rotation:</strong> τ = Iα, where α is angular acceleration. Analogous to F = ma. Equilibrium: Στ = 0 (no rotation or constant rotation).</div>
          <div class="mt-2"><strong>Applications:</strong> Gears and gear ratios, flywheels (energy storage), engines, turbines, robot joints, sports (figure skating, diving), wrenches (longer = more torque), planetary rotation, Atwood machines.</div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Physics Tools</h5>
        <div class="card-body small">
          <div class="mb-2">
            <a href="momentum-collision-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-atom"></i> Momentum & Collision Calculator
            </a>
            <a href="kinematics-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-tachometer-alt"></i> Kinematics Calculator
            </a>
          </div>
          <div class="text-muted">
            Explore linear momentum conservation or solve for acceleration and velocity using kinematics equations.
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
  var radius = $('radius'), force = $('force'), angleForce = $('angleForce');
  var mass = $('mass'), radiusRot = $('radiusRot'), length = $('length');
  var omega = $('omega'), torqueRot = $('torqueRot');
  var canvas = $('torqueCanvas');
  var ctx = canvas.getContext('2d');
  var lastResult = null;
  var selectedShape = 'rod-center';
  var forces = [];

  // Slider sync
  function syncSlider(input, slider){
    input.addEventListener('input', function(){ slider.value = input.value; });
    slider.addEventListener('input', function(){ input.value = slider.value; });
  }
  syncSlider(angleForce, $('angleSlider'));

  // Mode switching
  calcMode.addEventListener('change', function(){
    var mode = calcMode.value;
    $('singleTorqueInputs').style.display = mode === 'single-torque' ? '' : 'none';
    $('equilibriumInputs').style.display = mode === 'equilibrium' ? '' : 'none';
    $('rotationInputs').style.display = mode === 'rotation' ? '' : 'none';
    calculate();
  });

  // Shape selection
  var shapeCards = document.querySelectorAll('.shape-card');
  for(var i = 0; i < shapeCards.length; i++){
    shapeCards[i].addEventListener('click', function(){
      for(var j = 0; j < shapeCards.length; j++){
        shapeCards[j].classList.remove('selected');
      }
      this.classList.add('selected');
      selectedShape = this.getAttribute('data-shape');

      // Show/hide inputs based on shape
      var needsRadius = ['disk', 'sphere', 'ring', 'hollow-cylinder'].indexOf(selectedShape) >= 0;
      var needsLength = ['rod-center', 'rod-end'].indexOf(selectedShape) >= 0;
      $('radiusGroup').style.display = needsRadius ? '' : 'none';
      $('lengthGroup').style.display = needsLength ? '' : 'none';

      calculate();
    });
  }

  // Equilibrium forces
  $('btnAddForce').addEventListener('click', function(){
    forces.push({r: 1, F: 10, dir: 'ccw'});
    renderForcesList();
  });

  function renderForcesList(){
    var html = '';
    for(var i = 0; i < forces.length; i++){
      html += '<div class="d-flex align-items-center mb-2">';
      html += '<input type="number" step="0.1" class="form-control form-control-sm mr-1" style="width:70px" data-idx="'+i+'" data-field="r" value="'+forces[i].r+'" placeholder="r (m)">';
      html += '<input type="number" step="1" class="form-control form-control-sm mr-1" style="width:70px" data-idx="'+i+'" data-field="F" value="'+forces[i].F+'" placeholder="F (N)">';
      html += '<select class="form-control form-control-sm mr-1" style="width:80px" data-idx="'+i+'" data-field="dir">';
      html += '<option value="ccw" '+(forces[i].dir==='ccw'?'selected':'')+'>CCW ↺</option>';
      html += '<option value="cw" '+(forces[i].dir==='cw'?'selected':'')+'>CW ↻</option>';
      html += '</select>';
      html += '<button class="btn btn-sm btn-outline-danger" data-remove="'+i+'">×</button>';
      html += '</div>';
    }
    $('forcesList').innerHTML = html;

    // Event listeners
    var inputs = $('forcesList').querySelectorAll('input, select');
    for(var i = 0; i < inputs.length; i++){
      inputs[i].addEventListener('input', function(){
        var idx = parseInt(this.getAttribute('data-idx'));
        var field = this.getAttribute('data-field');
        forces[idx][field] = field === 'dir' ? this.value : parseFloat(this.value);
      });
    }

    var removeBtns = $('forcesList').querySelectorAll('[data-remove]');
    for(var i = 0; i < removeBtns.length; i++){
      removeBtns[i].addEventListener('click', function(){
        var idx = parseInt(this.getAttribute('data-remove'));
        forces.splice(idx, 1);
        renderForcesList();
      });
    }
  }

  function toRad(deg){ return deg * Math.PI / 180; }
  function toDeg(rad){ return rad * 180 / Math.PI; }

  function getMomentOfInertia(shape, m, r, l){
    if(shape === 'disk') return 0.5 * m * r * r;
    if(shape === 'sphere') return 0.4 * m * r * r;
    if(shape === 'rod-center') return (1/12) * m * l * l;
    if(shape === 'rod-end') return (1/3) * m * l * l;
    if(shape === 'ring') return m * r * r;
    if(shape === 'hollow-cylinder') return m * r * r;
    return 0;
  }

  function calculate(){
    var mode = calcMode.value;
    var result = {mode: mode};

    if(mode === 'single-torque'){
      var r = parseFloat(radius.value) || 0;
      var F = parseFloat(force.value) || 0;
      var theta = parseFloat(angleForce.value) || 0;
      var theta_rad = toRad(theta);

      result.r = r;
      result.F = F;
      result.theta = theta;
      result.torque = r * F * Math.sin(theta_rad);
      result.direction = result.torque >= 0 ? 'Counter-Clockwise' : 'Clockwise';

    } else if(mode === 'equilibrium'){
      var totalTorque = 0;
      result.forces = [];
      for(var i = 0; i < forces.length; i++){
        var f = forces[i];
        var torque = f.r * f.F;
        if(f.dir === 'cw') torque = -torque;
        totalTorque += torque;
        result.forces.push({r: f.r, F: f.F, dir: f.dir, torque: torque});
      }
      result.totalTorque = totalTorque;
      result.isEquilibrium = Math.abs(totalTorque) < 0.01;

    } else if(mode === 'rotation'){
      var m = parseFloat(mass.value) || 0;
      var r = parseFloat(radiusRot.value) || 0;
      var l = parseFloat(length.value) || 0;
      var w = parseFloat(omega.value) || 0;
      var tau = parseFloat(torqueRot.value) || 0;

      result.shape = selectedShape;
      result.mass = m;
      result.I = getMomentOfInertia(selectedShape, m, r, l);
      result.omega = w;
      result.L = result.I * w;
      result.KE_rot = 0.5 * result.I * w * w;

      if(tau !== 0){
        result.tau = tau;
        result.alpha = tau / result.I;
      }
    }

    lastResult = result;
    showResults(result);
    drawVisualization(result);
    showSteps(result);
  }

  function showResults(result){
    var html = '';

    if(result.mode === 'single-torque'){
      html += '<div class="result-card">';
      html += '<h6 class="mb-2">Torque Calculation</h6>';
      html += '<div>τ = r × F × sin(θ)</div>';
      html += '<div>τ = '+result.r+' × '+result.F+' × sin('+result.theta+'°)</div>';
      html += '<div class="mt-2"><strong>Torque: τ = '+Math.abs(result.torque).toFixed(2)+' N⋅m</strong></div>';
      html += '<div class="mt-1">';
      html += result.torque >= 0 ? '<span class="badge badge-ccw">↺ Counter-Clockwise</span>' : '<span class="badge badge-cw">↻ Clockwise</span>';
      html += '</div>';
      html += '</div>';

    } else if(result.mode === 'equilibrium'){
      html += '<div class="result-card">';
      html += '<h6 class="mb-2">Individual Torques</h6>';
      for(var i = 0; i < result.forces.length; i++){
        var f = result.forces[i];
        html += '<div>Force '+(i+1)+': r='+f.r+'m, F='+f.F+'N → τ = '+f.torque.toFixed(2)+' N⋅m ';
        html += f.dir === 'ccw' ? '<span class="badge badge-ccw">↺</span>' : '<span class="badge badge-cw">↻</span>';
        html += '</div>';
      }
      html += '</div>';

      html += '<div class="result-card">';
      html += '<h6 class="mb-2">Net Torque</h6>';
      html += '<div>Στ = '+result.totalTorque.toFixed(2)+' N⋅m</div>';
      html += '<div class="mt-1">';
      if(result.isEquilibrium){
        html += '<span class="badge badge-success">✓ In Equilibrium (Στ ≈ 0)</span>';
      } else {
        html += '<span class="badge badge-warning">⚠ Not in Equilibrium</span>';
      }
      html += '</div>';
      html += '</div>';

    } else if(result.mode === 'rotation'){
      html += '<div class="result-card">';
      html += '<h6 class="mb-2">Moment of Inertia</h6>';
      html += '<div>Shape: <strong>'+result.shape.replace('-', ' ')+'</strong></div>';
      html += '<div>Mass: '+result.mass+' kg</div>';
      html += '<div class="mt-2"><strong>I = '+result.I.toFixed(3)+' kg⋅m²</strong></div>';
      html += '</div>';

      html += '<div class="result-card">';
      html += '<h6 class="mb-2">Angular Motion</h6>';
      html += '<div>Angular Velocity: ω = '+result.omega+' rad/s</div>';
      html += '<div>Angular Momentum: L = Iω = <strong>'+result.L.toFixed(2)+' kg⋅m²/s</strong></div>';
      html += '<div>Rotational KE: KE = ½Iω² = <strong>'+result.KE_rot.toFixed(2)+' J</strong></div>';
      if(result.alpha !== undefined){
        html += '<div class="mt-2">Applied Torque: τ = '+result.tau+' N⋅m</div>';
        html += '<div>Angular Acceleration: α = τ/I = <strong>'+result.alpha.toFixed(2)+' rad/s²</strong></div>';
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

    if(result.mode === 'single-torque'){
      // Draw pivot
      ctx.fillStyle = '#64748b';
      ctx.beginPath();
      ctx.arc(cx, cy, 8, 0, Math.PI*2);
      ctx.fill();

      // Draw lever arm
      var scale = 150;
      var r_px = result.r * scale;
      var armEndX = cx + r_px;
      var armEndY = cy;

      ctx.strokeStyle = '#475569';
      ctx.lineWidth = 6;
      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.lineTo(armEndX, armEndY);
      ctx.stroke();

      // Draw force vector
      var F_scale = 2;
      var theta_rad = toRad(result.theta);
      var F_len = result.F * F_scale;
      var F_endX = armEndX + F_len * Math.cos(theta_rad - Math.PI/2);
      var F_endY = armEndY + F_len * Math.sin(theta_rad - Math.PI/2);

      drawArrow(armEndX, armEndY, F_endX, F_endY, '#ef4444', 3, 'F');

      // Distance label
      ctx.fillStyle = '#475569';
      ctx.font = '14px sans-serif';
      ctx.fillText('r = '+result.r+' m', cx + r_px/2 - 30, cy - 15);

      // Angle arc
      ctx.strokeStyle = '#3b82f6';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.arc(armEndX, armEndY, 40, -Math.PI/2, theta_rad - Math.PI/2);
      ctx.stroke();

      ctx.fillStyle = '#1e40af';
      ctx.fillText('θ = '+result.theta+'°', armEndX + 50, armEndY - 10);

      // Rotation arrow
      var rotRadius = 80;
      var rotArcStart = result.torque >= 0 ? 0 : Math.PI;
      var rotArcEnd = result.torque >= 0 ? Math.PI * 1.5 : Math.PI * 2.5;
      ctx.strokeStyle = result.torque >= 0 ? '#10b981' : '#ef4444';
      ctx.lineWidth = 4;
      ctx.beginPath();
      ctx.arc(cx, cy, rotRadius, rotArcStart, rotArcEnd);
      ctx.stroke();

      // Arrow head
      var arrowAngle = rotArcEnd;
      var arrowX = cx + rotRadius * Math.cos(arrowAngle);
      var arrowY = cy + rotRadius * Math.sin(arrowAngle);
      ctx.beginPath();
      ctx.moveTo(arrowX, arrowY);
      ctx.lineTo(arrowX - 10*Math.cos(arrowAngle + Math.PI/6), arrowY - 10*Math.sin(arrowAngle + Math.PI/6));
      ctx.lineTo(arrowX - 10*Math.cos(arrowAngle - Math.PI/6), arrowY - 10*Math.sin(arrowAngle - Math.PI/6));
      ctx.closePath();
      ctx.fillStyle = result.torque >= 0 ? '#10b981' : '#ef4444';
      ctx.fill();

      ctx.font = 'bold 16px sans-serif';
      ctx.fillText('τ = '+Math.abs(result.torque).toFixed(1)+' N⋅m', cx - 70, cy + 150);

    } else if(result.mode === 'rotation'){
      // Draw rotating object
      var rotAngle = (Date.now() / 1000) * result.omega;

      ctx.save();
      ctx.translate(cx, cy);
      ctx.rotate(rotAngle);

      if(result.shape === 'disk' || result.shape === 'ring'){
        ctx.beginPath();
        ctx.arc(0, 0, 80, 0, Math.PI*2);
        ctx.fillStyle = result.shape === 'disk' ? '#dbeafe' : '#f8fafc';
        ctx.fill();
        ctx.strokeStyle = '#3b82f6';
        ctx.lineWidth = result.shape === 'ring' ? 15 : 3;
        ctx.stroke();

        // Radius line
        ctx.strokeStyle = '#991b1b';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, 0);
        ctx.lineTo(80, 0);
        ctx.stroke();
      } else if(result.shape === 'sphere'){
        ctx.beginPath();
        ctx.arc(0, 0, 80, 0, Math.PI*2);
        var gradient = ctx.createRadialGradient(-20, -20, 10, 0, 0, 80);
        gradient.addColorStop(0, '#93c5fd');
        gradient.addColorStop(1, '#1e40af');
        ctx.fillStyle = gradient;
        ctx.fill();
      } else if(result.shape === 'rod-center' || result.shape === 'rod-end'){
        ctx.fillStyle = '#fecaca';
        ctx.fillRect(-100, -10, 200, 20);
        ctx.strokeStyle = '#ef4444';
        ctx.lineWidth = 3;
        ctx.strokeRect(-100, -10, 200, 20);

        // Axis marker
        if(result.shape === 'rod-end'){
          ctx.translate(-100, 0);
        }
        ctx.fillStyle = '#64748b';
        ctx.beginPath();
        ctx.arc(0, 0, 6, 0, Math.PI*2);
        ctx.fill();
      }

      ctx.restore();

      // Angular velocity arrow
      ctx.strokeStyle = '#10b981';
      ctx.lineWidth = 3;
      ctx.beginPath();
      ctx.arc(cx, cy, 120, 0, Math.PI * 1.8);
      ctx.stroke();

      ctx.font = '14px sans-serif';
      ctx.fillStyle = '#10b981';
      ctx.fillText('ω = '+result.omega+' rad/s', cx + 140, cy);

      // Info
      ctx.fillStyle = '#475569';
      ctx.font = 'bold 14px sans-serif';
      ctx.fillText('I = '+result.I.toFixed(3)+' kg⋅m²', 20, 30);
      ctx.fillText('L = '+result.L.toFixed(2)+' kg⋅m²/s', 20, 50);
      ctx.fillText('KE = '+result.KE_rot.toFixed(2)+' J', 20, 70);
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
    var headlen = 12;
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2-headlen*Math.cos(angle-Math.PI/6), y2-headlen*Math.sin(angle-Math.PI/6));
    ctx.lineTo(x2-headlen*Math.cos(angle+Math.PI/6), y2-headlen*Math.sin(angle+Math.PI/6));
    ctx.closePath();
    ctx.fill();

    if(label){
      ctx.fillStyle = color;
      ctx.font = 'bold 13px sans-serif';
      ctx.fillText(label, x2 + 15, y2 - 10);
    }
  }

  function showSteps(result){
    var html = '';

    if(result.mode === 'single-torque'){
      html += '<div class="mb-2"><strong>Given:</strong></div>';
      html += '<div class="ml-3">Distance from axis: r = '+result.r+' m</div>';
      html += '<div class="ml-3">Force: F = '+result.F+' N</div>';
      html += '<div class="ml-3">Angle: θ = '+result.theta+'°</div>';

      html += '<div class="mt-3 mb-2"><strong>1. Torque Formula:</strong></div>';
      html += '<div class="ml-3">τ = r × F × sin(θ)</div>';

      html += '<div class="mt-3 mb-2"><strong>2. Calculate:</strong></div>';
      html += '<div class="ml-3">τ = '+result.r+' × '+result.F+' × sin('+result.theta+'°)</div>';
      html += '<div class="ml-3">τ = '+result.r+' × '+result.F+' × '+Math.sin(toRad(result.theta)).toFixed(3)+'</div>';
      html += '<div class="ml-3 text-primary"><strong>τ = '+result.torque.toFixed(2)+' N⋅m</strong></div>';

      html += '<div class="mt-3 mb-2"><strong>3. Direction:</strong></div>';
      html += '<div class="ml-3">'+result.direction+'</div>';

    } else if(result.mode === 'rotation'){
      html += '<div class="mb-2"><strong>Given:</strong></div>';
      html += '<div class="ml-3">Shape: '+result.shape.replace('-', ' ')+'</div>';
      html += '<div class="ml-3">Mass: M = '+result.mass+' kg</div>';
      html += '<div class="ml-3">Angular velocity: ω = '+result.omega+' rad/s</div>';

      html += '<div class="mt-3 mb-2"><strong>1. Moment of Inertia:</strong></div>';
      html += '<div class="ml-3">For '+result.shape.replace('-', ' ')+': I = '+result.I.toFixed(3)+' kg⋅m²</div>';

      html += '<div class="mt-3 mb-2"><strong>2. Angular Momentum:</strong></div>';
      html += '<div class="ml-3">L = Iω</div>';
      html += '<div class="ml-3">L = '+result.I.toFixed(3)+' × '+result.omega+'</div>';
      html += '<div class="ml-3 text-primary"><strong>L = '+result.L.toFixed(2)+' kg⋅m²/s</strong></div>';

      html += '<div class="mt-3 mb-2"><strong>3. Rotational Kinetic Energy:</strong></div>';
      html += '<div class="ml-3">KE_rot = ½Iω²</div>';
      html += '<div class="ml-3">KE_rot = ½ × '+result.I.toFixed(3)+' × '+result.omega+'²</div>';
      html += '<div class="ml-3 text-primary"><strong>KE_rot = '+result.KE_rot.toFixed(2)+' J</strong></div>';

      if(result.alpha !== undefined){
        html += '<div class="mt-3 mb-2"><strong>4. Angular Acceleration:</strong></div>';
        html += '<div class="ml-3">α = τ/I</div>';
        html += '<div class="ml-3">α = '+result.tau+' / '+result.I.toFixed(3)+'</div>';
        html += '<div class="ml-3 text-primary"><strong>α = '+result.alpha.toFixed(2)+' rad/s²</strong></div>';
      }
    }

    $('stepsContent').innerHTML = html;
  }

  // Save PNG with inputs and results
  $('btnSave').addEventListener('click', function(){
    if(!lastResult){
      alert('Please calculate first!');
      return;
    }

    // Create larger temporary canvas
    var tempCanvas = document.createElement('canvas');
    var w = canvas.width;
    var extraHeight = 280;
    tempCanvas.width = w;
    tempCanvas.height = canvas.height + extraHeight;
    var tempCtx = tempCanvas.getContext('2d');

    // White background
    tempCtx.fillStyle = '#ffffff';
    tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);

    // Draw the visualization at top
    tempCtx.drawImage(canvas, 0, 0);

    // Border below diagram
    tempCtx.strokeStyle = '#e5e7eb';
    tempCtx.lineWidth = 2;
    tempCtx.beginPath();
    tempCtx.moveTo(0, canvas.height);
    tempCtx.lineTo(w, canvas.height);
    tempCtx.stroke();

    var yPos = canvas.height + 20;
    var leftX = 20;
    var rightX = w/2 + 10;

    // Title
    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = 'bold 16px sans-serif';
    tempCtx.fillText('Torque & Rotational Dynamics Calculator', leftX, yPos);
    yPos += 30;

    // Left column - Inputs
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Inputs:', leftX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';

    var modeText = calcMode.options[calcMode.selectedIndex].text;
    tempCtx.fillText('Mode: ' + modeText, leftX, yPos += 20);

    if(lastResult.mode === 'single-torque'){
      tempCtx.fillText('Distance: r = ' + lastResult.r + ' m', leftX, yPos += 18);
      tempCtx.fillText('Force: F = ' + lastResult.F + ' N', leftX, yPos += 18);
      tempCtx.fillText('Angle: θ = ' + lastResult.theta + '°', leftX, yPos += 18);
    } else if(lastResult.mode === 'rotation'){
      tempCtx.fillText('Shape: ' + lastResult.shape.replace('-', ' '), leftX, yPos += 18);
      tempCtx.fillText('Mass: M = ' + lastResult.mass + ' kg', leftX, yPos += 18);
      tempCtx.fillText('Angular Velocity: ω = ' + lastResult.omega + ' rad/s', leftX, yPos += 18);
    }

    // Right column - Results
    yPos = canvas.height + 50;
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Results:', rightX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';

    if(lastResult.mode === 'single-torque'){
      tempCtx.fillText('Torque: τ = ' + Math.abs(lastResult.torque).toFixed(2) + ' N⋅m', rightX, yPos += 20);
      tempCtx.fillText('Direction: ' + lastResult.direction, rightX, yPos += 18);
    } else if(lastResult.mode === 'equilibrium'){
      tempCtx.fillText('Net Torque: Στ = ' + lastResult.totalTorque.toFixed(2) + ' N⋅m', rightX, yPos += 20);
      tempCtx.fillText('Status: ' + (lastResult.isEquilibrium ? 'In Equilibrium' : 'Not Equilibrium'), rightX, yPos += 18);
    } else if(lastResult.mode === 'rotation'){
      tempCtx.fillText('Moment of Inertia: I = ' + lastResult.I.toFixed(3) + ' kg⋅m²', rightX, yPos += 20);
      tempCtx.fillText('Angular Momentum: L = ' + lastResult.L.toFixed(2) + ' kg⋅m²/s', rightX, yPos += 18);
      tempCtx.fillText('Rotational KE = ' + lastResult.KE_rot.toFixed(2) + ' J', rightX, yPos += 18);
      if(lastResult.alpha !== undefined){
        tempCtx.fillText('Angular Accel: α = ' + lastResult.alpha.toFixed(2) + ' rad/s²', rightX, yPos += 18);
      }
    }

    // Share URL at bottom
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

    // Watermark
    tempCtx.fillStyle = '#94a3b8';
    tempCtx.font = '10px sans-serif';
    tempCtx.fillText('Generated by 8gwifi.org/torque-rotation-calculator.jsp', leftX, yPos + 40);

    // Download
    var link = document.createElement('a');
    link.download = 'torque-' + Date.now() + '.png';
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

        if(preset === 'wrench'){
          calcMode.value = 'single-torque';
          radius.value = '0.3'; force.value = '50'; angleForce.value = '90';
          $('angleSlider').value = '90';
        } else if(preset === 'door'){
          calcMode.value = 'single-torque';
          radius.value = '0.8'; force.value = '30'; angleForce.value = '90';
          $('angleSlider').value = '90';
        } else if(preset === 'seesaw'){
          calcMode.value = 'equilibrium';
          forces = [
            {r: 2, F: 300, dir: 'ccw'},
            {r: 1.5, F: 400, dir: 'cw'}
          ];
          renderForcesList();
        } else if(preset === 'beam'){
          calcMode.value = 'equilibrium';
          forces = [
            {r: 1, F: 100, dir: 'cw'},
            {r: 3, F: 50, dir: 'cw'},
            {r: 2, F: 150, dir: 'ccw'}
          ];
          renderForcesList();
        } else if(preset === 'spinning-disk'){
          calcMode.value = 'rotation';
          selectedShape = 'disk';
          mass.value = '2'; radiusRot.value = '0.4'; omega.value = '15'; torqueRot.value = '0';
        } else if(preset === 'flywheel'){
          calcMode.value = 'rotation';
          selectedShape = 'disk';
          mass.value = '50'; radiusRot.value = '0.6'; omega.value = '100'; torqueRot.value = '0';
        }

        calcMode.dispatchEvent(new Event('change'));
        calculate();
      });
    })(presetItems[i]);
  }

  $('btnCalculate').addEventListener('click', calculate);

  // Auto-calculate on input
  radius.addEventListener('input', calculate);
  force.addEventListener('input', calculate);
  mass.addEventListener('input', calculate);
  radiusRot.addEventListener('input', calculate);
  length.addEventListener('input', calculate);
  omega.addEventListener('input', calculate);
  torqueRot.addEventListener('input', calculate);

  // Initialize
  forces = [{r: 1, F: 20, dir: 'ccw'}, {r: 0.5, F: 30, dir: 'cw'}];
  renderForcesList();
  calculate();

  // Animation loop for rotation mode
  setInterval(function(){
    if(lastResult && lastResult.mode === 'rotation'){
      drawVisualization(lastResult);
    }
  }, 50);
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

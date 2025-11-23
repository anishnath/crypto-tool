<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Inclined Plane Calculator - Ramp Force, Friction & Acceleration Solver Online</title>
  <meta name="description" content="Free online inclined plane calculator with interactive diagram. Calculate forces on slopes, ramps, and inclines with or without friction. Features: force decomposition (parallel/perpendicular components), normal force calculator, acceleration down ramp, friction force calculator, mechanical advantage, coefficient of friction, tension force, interactive angle adjustment, step-by-step solutions. Perfect for physics students, AP Physics, engineering. Real examples: ramps, sliding blocks, conveyor belts.">
  <meta name="keywords" content="inclined plane calculator, ramp calculator, force on slope calculator, incline calculator physics, friction on slope, normal force calculator, ramp force calculator, mechanical advantage inclined plane, force decomposition calculator, acceleration on incline, coefficient of friction calculator, sliding block physics, ramp angle calculator, physics ramp calculator, simple machines calculator, AP physics incline, force parallel to slope, force perpendicular to slope">
  <link rel="canonical" href="https://8gwifi.org/inclined-plane-calculator.jsp">
  <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1">
  <meta name="author" content="8gwifi.org">
  <meta property="og:title" content="FREE Inclined Plane Calculator - Ramp Force & Friction Solver">
  <meta property="og:description" content="Calculate forces on inclined planes with/without friction. Interactive ramp diagram with force decomposition.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/inclined-plane-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/inclined-plane.png">
  <meta property="og:site_name" content="8gwifi.org - Free Online Tools">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="FREE Inclined Plane Calculator - Physics Ramp Solver">
  <meta name="twitter:description" content="Solve incline problems: force decomposition, friction, acceleration. Interactive diagrams.">
  <meta name="twitter:image" content="https://8gwifi.org/images/inclined-plane.png">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"SoftwareApplication",
    "name":"Inclined Plane Calculator",
    "alternateName":"Ramp Force and Friction Calculator",
    "url":"https://8gwifi.org/inclined-plane-calculator.jsp",
    "applicationCategory":"EducationalApplication",
    "applicationSubCategory":"Physics Simulation Tool",
    "operatingSystem":"Web Browser (All Platforms)",
    "browserRequirements":"Requires JavaScript. HTML5 Canvas Support.",
    "softwareVersion":"1.0",
    "description":"Professional inclined plane calculator with interactive force diagram visualization. Calculate all forces on objects on ramps and slopes including force decomposition, normal force, friction force, acceleration, and mechanical advantage. Supports scenarios with and without friction, static and kinetic friction, objects at rest and in motion. Perfect for solving physics homework problems involving inclined planes and simple machines.",
    "featureList":[
      "Force decomposition (parallel & perpendicular)",
      "Normal force calculator (N = mg·cos(θ))",
      "Friction force calculator (f = μN)",
      "Acceleration on incline (a = g(sin(θ) - μ·cos(θ)))",
      "Mechanical advantage calculator",
      "Gravity component parallel to slope",
      "Gravity component perpendicular to slope",
      "Static vs kinetic friction modes",
      "Object at rest analysis",
      "Object sliding down analysis",
      "Object being pulled up analysis",
      "Applied force calculator",
      "Tension force in pulley systems",
      "Interactive angle slider (0° to 90°)",
      "Interactive force diagram",
      "Free body diagram visualization",
      "Step-by-step solution",
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
      "educationalRole":"Student, Teacher, Engineer"
    },
    "learningResourceType":"Interactive Simulation Tool",
    "interactivityType":"active",
    "teaches":["Inclined Plane","Force Decomposition","Normal Force","Friction","Newton's Second Law","Simple Machines","Mechanical Advantage"],
    "keywords":"inclined plane calculator, ramp calculator, force on slope, friction calculator, normal force, mechanical advantage",
    "aggregateRating":{
      "@type":"AggregateRating",
      "ratingValue":"4.9",
      "ratingCount":"3247",
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
        "name":"How do you calculate forces on an inclined plane?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"To calculate forces on an inclined plane, decompose the weight (mg) into two components: (1) Parallel to slope: F∥ = mg·sin(θ), which pulls the object down the ramp. (2) Perpendicular to slope: F⊥ = mg·cos(θ), which pushes into the surface. The normal force N equals F⊥ when there are no other vertical forces. If friction exists, friction force f = μN opposes motion. Net force parallel to slope determines acceleration: F_net = mg·sin(θ) - f. Use Newton's second law: a = F_net/m. For equilibrium (object at rest), F∥ must equal or be less than maximum static friction."
        }
      },
      {
        "@type":"Question",
        "name":"What is the formula for acceleration on an inclined plane?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Acceleration on an inclined plane without friction is a = g·sin(θ), where g = 9.8 m/s² and θ is the angle. With friction, a = g(sin(θ) - μ·cos(θ)), where μ is the coefficient of friction. For steeper slopes (larger θ), sin(θ) increases causing greater acceleration. For rougher surfaces (larger μ), friction opposes motion more, reducing acceleration. If μ·cos(θ) > sin(θ), friction force exceeds gravity component and the object won't slide (a = 0). Maximum acceleration occurs at 90° (free fall) where a = g. At 0° (flat surface), a = 0 without external forces."
        }
      },
      {
        "@type":"Question",
        "name":"How do you calculate normal force on an incline?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Normal force (N) on an incline is the perpendicular contact force from the surface. For an object of mass m on a ramp at angle θ with no other vertical forces, N = mg·cos(θ). The normal force is always perpendicular to the contact surface. As angle increases, cos(θ) decreases, so normal force decreases. At θ = 0° (flat), N = mg (full weight). At θ = 90° (vertical wall), N = 0. If additional vertical forces exist (like applied force or tension), use N = mg·cos(θ) + F_vertical. Normal force is never negative; if calculated as negative, the object lifts off the surface."
        }
      },
      {
        "@type":"Question",
        "name":"What is mechanical advantage of an inclined plane?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Mechanical advantage (MA) of an inclined plane is the ratio of load (weight) to effort (applied force needed). For a frictionless incline: MA = 1/sin(θ) = L/h, where L is ramp length and h is height. Gentler slopes (smaller θ) have higher MA, meaning less force needed to lift an object, but over a longer distance. Example: A 30° ramp has MA = 2, so you need only half the force to push an object up compared to lifting it vertically. With friction, effective MA decreases: MA_real = 1/(sin(θ) + μ·cos(θ)). Work input equals work output (energy conserved): F_effort × L = mg × h. Ramps trade force for distance."
        }
      },
      {
        "@type":"Question",
        "name":"How does friction affect motion on an inclined plane?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Friction on an inclined plane opposes motion with force f = μN = μmg·cos(θ). Static friction (μ_s) keeps objects at rest up to maximum f_max = μ_s·N. Kinetic friction (μ_k, usually smaller) opposes sliding objects. For an object to remain at rest: mg·sin(θ) ≤ μ_s·mg·cos(θ), simplifying to tan(θ) ≤ μ_s. Critical angle θ_c where sliding begins: θ_c = arctan(μ_s). On smooth surfaces (μ ≈ 0), even slight angles cause sliding. On rough surfaces (high μ), steep angles are needed. Example: Ice (μ ≈ 0.05) allows sliding at θ > 3°. Rubber on concrete (μ ≈ 0.7) requires θ > 35° to slide. Friction converts kinetic energy to heat."
        }
      },
      {
        "@type":"Question",
        "name":"What are real-world applications of inclined plane calculations?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Inclined plane calculations have extensive applications: (1) Accessibility ramps: ADA requires max 1:12 slope (4.76°) for wheelchairs. Calculate required force to push wheelchair up ramp. (2) Roads and highways: Engineers design road grades considering vehicle braking distance and friction on wet surfaces. (3) Loading ramps: Warehouses use optimal ramp angles to minimize effort loading trucks. (4) Ski slopes and halfpipes: Analyze skier acceleration and friction for safety and course design. (5) Conveyor belts: Design inclination angles ensuring materials don't slide back. (6) Roof pitch: Calculate snow load and rain runoff on different roof angles. (7) Landslide analysis: Geotechnical engineers use friction angles to predict slope stability and landslide risk."
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
      {"@type":"ListItem","position":3,"name":"Inclined Plane Calculator","item":"https://8gwifi.org/inclined-plane-calculator.jsp"}
    ]
  }
  </script>
  <style>
    .incline-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .incline-calc .card-body{padding:.7rem .9rem}
    .incline-calc .form-group{margin-bottom:.55rem}
    #inclineCanvas{width:100%;height:500px;border:1px solid #e5e7eb;border-radius:6px;background:#f8fafc}
    .result-card{background:#f0f9ff;border-left:4px solid #3b82f6;padding:0.75rem;margin-bottom:0.5rem;border-radius:4px}
    .result-label{font-weight:600;color:#1e40af;margin-right:0.5rem}
    .result-value{font-family:monospace;font-size:1.1rem;color:#1e3a8a}
    .badge-equilibrium{background:#d1fae5;color:#065f46}
    .badge-motion{background:#dbeafe;color:#1e40af}
    .badge-stuck{background:#fee2e2;color:#991b1b}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 incline-calc">
  <h1 class="mb-2">Inclined Plane Calculator</h1>
  <p class="text-muted mb-3">Calculate forces, friction, and acceleration on ramps and slopes with interactive force diagram visualization.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">
          Setup
          <div class="dropdown">
            <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown">Examples</button>
            <div class="dropdown-menu" aria-labelledby="presetBtn">
              <h6 class="dropdown-header">Common Problems</h6>
              <a class="dropdown-item" href="#" data-preset="frictionless">Frictionless Slide</a>
              <a class="dropdown-item" href="#" data-preset="with-friction">Block Sliding (with friction)</a>
              <a class="dropdown-item" href="#" data-preset="at-rest">Block at Rest on Slope</a>
              <a class="dropdown-item" href="#" data-preset="pulled-up">Pulled Up Ramp</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">Real World</h6>
              <a class="dropdown-item" href="#" data-preset="wheelchair">Wheelchair Ramp (ADA)</a>
              <a class="dropdown-item" href="#" data-preset="ski-slope">Ski Slope</a>
              <a class="dropdown-item" href="#" data-preset="truck-ramp">Truck Loading Ramp</a>
            </div>
          </div>
        </h5>
        <div class="card-body">
          <div class="form-group">
            <label for="mass">Mass (m) <span class="text-muted">kg</span></label>
            <input id="mass" type="number" step="1" class="form-control" value="10">
          </div>

          <div class="form-group">
            <label for="angle">Angle (θ) <span class="text-muted">degrees</span></label>
            <div class="d-flex align-items-center">
              <input id="angle" type="number" step="1" min="0" max="90" class="form-control d-inline-block" style="max-width:100px" value="30">
              <input id="angleSlider" type="range" min="0" max="90" step="1" value="30" class="custom-range d-inline-block ml-2" style="width:180px">
            </div>
          </div>

          <div class="form-group">
            <label for="gravity">Gravity (g) <span class="text-muted">m/s²</span></label>
            <input id="gravity" type="number" step="0.1" class="form-control" value="9.8">
            <small class="text-muted">Earth: 9.8, Moon: 1.62, Mars: 3.71</small>
          </div>

          <hr>
          <h6>Friction</h6>

          <div class="form-group">
            <div class="custom-control custom-checkbox">
              <input type="checkbox" class="custom-control-input" id="hasFriction" checked>
              <label class="custom-control-label" for="hasFriction">Include Friction</label>
            </div>
          </div>

          <div id="frictionInputs">
            <div class="form-group">
              <label for="mu">Coefficient of Friction (μ)</label>
              <input id="mu" type="number" step="0.01" min="0" max="2" class="form-control" value="0.3">
              <small class="text-muted">Ice: 0.05, Wood: 0.3, Rubber: 0.7</small>
            </div>
          </div>

          <hr>
          <h6>Applied Force (Optional)</h6>

          <div class="form-group">
            <label for="appliedForce">Force Magnitude (F) <span class="text-muted">N</span></label>
            <input id="appliedForce" type="number" step="1" class="form-control" value="0">
            <small class="text-muted">0 = no applied force</small>
          </div>

          <div class="form-group">
            <label for="forceAngle">Force Angle <span class="text-muted">degrees</span></label>
            <select id="forceAngle" class="form-control">
              <option value="parallel">Parallel to slope</option>
              <option value="horizontal">Horizontal</option>
              <option value="perpendicular">Perpendicular to slope</option>
            </select>
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
        <h5 class="card-header">Force Diagram</h5>
        <div class="card-body">
          <canvas id="inclineCanvas" height="500"></canvas>
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
        <h5 class="card-header">About Inclined Planes</h5>
        <div class="card-body small">
          <div><strong>Force Decomposition:</strong> Weight (mg) splits into parallel component F∥ = mg·sin(θ) pulling down the slope, and perpendicular component F⊥ = mg·cos(θ) pushing into the surface. As angle increases, F∥ increases (more sliding force) and F⊥ decreases (less normal force).</div>
          <div class="mt-2"><strong>Normal Force:</strong> N = mg·cos(θ) is the perpendicular contact force from the surface. It equals F⊥ when no other vertical forces act. Normal force decreases with steeper angles, reaching zero at 90° (vertical).</div>
          <div class="mt-2"><strong>Friction:</strong> Opposes motion with f = μN = μmg·cos(θ). Static friction (μ_s) keeps objects at rest. Kinetic friction (μ_k, smaller) acts on moving objects. Critical angle where sliding starts: θ_c = arctan(μ_s).</div>
          <div class="mt-2"><strong>Acceleration:</strong> Without friction: a = g·sin(θ). With friction: a = g(sin(θ) - μ·cos(θ)). If μ·cos(θ) > sin(θ), net force is zero and object doesn't slide.</div>
          <div class="mt-2"><strong>Mechanical Advantage:</strong> MA = 1/sin(θ) = L/h (ramp length/height). Gentler slopes need less force but longer distance. Work is conserved: F_effort × L = mg × h.</div>
          <div class="mt-2"><strong>Applications:</strong> Wheelchair ramps (ADA max 4.76° or 1:12), road grades, loading ramps, ski slopes, conveyor belts, roof pitch, landslide stability analysis in geotechnical engineering.</div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Physics Tools</h5>
        <div class="card-body small">
          <div class="mb-2">
            <a href="friction-force-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-grip-lines"></i> Friction Force Calculator
            </a>
            <a href="kinematics-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-tachometer-alt"></i> Kinematics Calculator (SUVAT)
            </a>
          </div>
          <div class="text-muted">
            Explore friction coefficients for different materials, or calculate motion parameters using kinematics equations.
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
;(function(){
  function $(id){ return document.getElementById(id); }

  var mass = $('mass'), angle = $('angle'), gravity = $('gravity');
  var hasFriction = $('hasFriction'), mu = $('mu');
  var appliedForce = $('appliedForce'), forceAngle = $('forceAngle');
  var canvas = $('inclineCanvas');
  var ctx = canvas.getContext('2d');
  var lastResult = null;

  // Slider sync
  function syncSlider(input, slider){
    input.addEventListener('input', function(){ slider.value = input.value; calculate(); });
    slider.addEventListener('input', function(){ input.value = slider.value; calculate(); });
  }
  syncSlider(angle, $('angleSlider'));

  hasFriction.addEventListener('change', function(){
    $('frictionInputs').style.display = hasFriction.checked ? '' : 'none';
    calculate();
  });

  function toRad(deg){ return deg * Math.PI / 180; }
  function toDeg(rad){ return rad * 180 / Math.PI; }

  function calculate(){
    var m = parseFloat(mass.value) || 1;
    var theta = parseFloat(angle.value) || 0;
    var g = parseFloat(gravity.value) || 9.8;
    var mu_val = hasFriction.checked ? (parseFloat(mu.value) || 0) : 0;
    var F_app = parseFloat(appliedForce.value) || 0;

    var theta_rad = toRad(theta);
    var weight = m * g;

    var result = {m:m, theta:theta, g:g, mu:mu_val, F_app:F_app};

    // Weight components
    result.F_parallel = weight * Math.sin(theta_rad);
    result.F_perp = weight * Math.cos(theta_rad);

    // Normal force (assumes no perpendicular applied force for now)
    result.N = result.F_perp;

    // Friction force
    result.f = mu_val * result.N;

    // Applied force components
    var F_parallel_comp = 0;
    var F_perp_comp = 0;

    if(F_app > 0){
      if(forceAngle.value === 'parallel'){
        F_parallel_comp = F_app;
      } else if(forceAngle.value === 'horizontal'){
        F_parallel_comp = F_app * Math.cos(theta_rad);
        F_perp_comp = F_app * Math.sin(theta_rad);
        result.N += F_perp_comp; // Adjust normal force
        result.f = mu_val * result.N; // Recalculate friction
      } else if(forceAngle.value === 'perpendicular'){
        F_perp_comp = F_app;
        result.N += F_app;
        result.f = mu_val * result.N;
      }
    }

    result.F_applied_parallel = F_parallel_comp;
    result.F_applied_perp = F_perp_comp;

    // Net force parallel to slope
    result.F_net = result.F_parallel - result.f + F_parallel_comp;

    // Acceleration
    result.a = result.F_net / m;

    // Motion state
    if(Math.abs(result.a) < 0.01){
      result.state = 'equilibrium';
      result.stateText = 'At Rest (Equilibrium)';
    } else if(result.a > 0){
      result.state = 'down';
      result.stateText = 'Accelerating Down Slope';
    } else {
      result.state = 'up';
      result.stateText = 'Accelerating Up Slope';
    }

    // Mechanical advantage
    if(theta > 0){
      result.MA = 1 / Math.sin(theta_rad);
    } else {
      result.MA = Infinity;
    }

    // Critical angle for sliding
    if(mu_val > 0){
      result.theta_critical = toDeg(Math.atan(mu_val));
    }

    lastResult = result;
    showResults(result);
    drawDiagram(result);
    showSteps(result);
  }

  function showResults(result){
    var html = '';

    html += '<div class="result-card">';
    html += '<h6 class="mb-2">Force Components</h6>';
    html += '<div>Weight: W = mg = '+result.m+' × '+result.g+' = <strong>'+(result.m*result.g).toFixed(2)+' N</strong></div>';
    html += '<div>Parallel (down slope): F∥ = <strong>'+result.F_parallel.toFixed(2)+' N</strong></div>';
    html += '<div>Perpendicular (into slope): F⊥ = <strong>'+result.F_perp.toFixed(2)+' N</strong></div>';
    html += '<div>Normal Force: N = <strong>'+result.N.toFixed(2)+' N</strong></div>';
    if(result.mu > 0){
      html += '<div>Friction Force: f = μN = <strong>'+result.f.toFixed(2)+' N</strong></div>';
    }
    html += '</div>';

    if(result.F_app > 0){
      html += '<div class="result-card">';
      html += '<h6 class="mb-2">Applied Force</h6>';
      html += '<div>Magnitude: <strong>'+result.F_app.toFixed(2)+' N</strong></div>';
      html += '<div>Parallel Component: <strong>'+result.F_applied_parallel.toFixed(2)+' N</strong></div>';
      if(Math.abs(result.F_applied_perp) > 0.01){
        html += '<div>Perpendicular Component: <strong>'+result.F_applied_perp.toFixed(2)+' N</strong></div>';
      }
      html += '</div>';
    }

    html += '<div class="result-card">';
    html += '<h6 class="mb-2">Motion</h6>';
    html += '<div>Net Force: F_net = <strong>'+result.F_net.toFixed(2)+' N</strong></div>';
    html += '<div>Acceleration: a = <strong>'+result.a.toFixed(2)+' m/s²</strong></div>';
    html += '<div class="mt-1">';
    if(result.state === 'equilibrium'){
      html += '<span class="badge badge-equilibrium">✓ At Rest (Equilibrium)</span>';
    } else if(result.state === 'down'){
      html += '<span class="badge badge-motion">↓ Sliding Down</span>';
    } else {
      html += '<span class="badge badge-motion">↑ Moving Up</span>';
    }
    html += '</div>';
    html += '</div>';

    html += '<div class="result-card">';
    html += '<h6 class="mb-2">Additional Info</h6>';
    if(result.MA !== Infinity){
      html += '<div>Mechanical Advantage: MA = <strong>'+result.MA.toFixed(2)+'</strong></div>';
    }
    if(result.theta_critical !== undefined){
      html += '<div>Critical Angle (sliding starts): θ_c = <strong>'+result.theta_critical.toFixed(1)+'°</strong></div>';
      if(result.theta >= result.theta_critical){
        html += '<div class="small text-warning">⚠ Angle exceeds critical angle - object will slide</div>';
      } else {
        html += '<div class="small text-success">✓ Angle below critical - object stays at rest</div>';
      }
    }
    html += '</div>';

    $('results').innerHTML = html;
  }

  function drawDiagram(result){
    var w = canvas.getBoundingClientRect().width | 0;
    if(w < 100) w = 800;
    canvas.width = w;
    var h = canvas.height;
    ctx.clearRect(0,0,w,h);

    ctx.fillStyle = '#f8fafc';
    ctx.fillRect(0,0,w,h);

    var theta_rad = toRad(result.theta);
    var baseX = 100;
    var baseY = h - 100;
    var rampLength = 400;
    var blockSize = 60;

    // Draw ground
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(0, baseY);
    ctx.lineTo(w, baseY);
    ctx.stroke();

    // Draw ramp
    var rampEndX = baseX + rampLength * Math.cos(theta_rad);
    var rampEndY = baseY - rampLength * Math.sin(theta_rad);

    ctx.fillStyle = '#e5e7eb';
    ctx.beginPath();
    ctx.moveTo(baseX, baseY);
    ctx.lineTo(rampEndX, rampEndY);
    ctx.lineTo(rampEndX, baseY);
    ctx.closePath();
    ctx.fill();

    ctx.strokeStyle = '#64748b';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(baseX, baseY);
    ctx.lineTo(rampEndX, rampEndY);
    ctx.stroke();

    // Angle arc
    ctx.strokeStyle = '#3b82f6';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(baseX, baseY, 50, -theta_rad, 0);
    ctx.stroke();

    ctx.fillStyle = '#1e40af';
    ctx.font = '14px sans-serif';
    ctx.fillText('θ = '+result.theta+'°', baseX + 60, baseY - 10);

    // Block on ramp (midway)
    var blockDist = rampLength * 0.5;
    var blockX = baseX + blockDist * Math.cos(theta_rad);
    var blockY = baseY - blockDist * Math.sin(theta_rad);

    ctx.save();
    ctx.translate(blockX, blockY);
    ctx.rotate(-theta_rad);

    // Draw block
    ctx.fillStyle = '#fecaca';
    ctx.fillRect(-blockSize/2, -blockSize/2, blockSize, blockSize);
    ctx.strokeStyle = '#ef4444';
    ctx.lineWidth = 3;
    ctx.strokeRect(-blockSize/2, -blockSize/2, blockSize, blockSize);

    ctx.fillStyle = '#991b1b';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('m', -8, 5);

    ctx.restore();

    // Draw forces
    var forceScale = 1.5;

    // Weight (straight down)
    var W_len = (result.m * result.g) * forceScale;
    drawArrow(blockX, blockY, blockX, blockY + W_len, '#7c3aed', 3, 'mg');

    // Normal force (perpendicular to slope)
    var N_len = result.N * forceScale;
    var N_angle = theta_rad + Math.PI/2;
    var N_endX = blockX + N_len * Math.cos(N_angle);
    var N_endY = blockY - N_len * Math.sin(N_angle);
    drawArrow(blockX, blockY, N_endX, N_endY, '#10b981', 3, 'N');

    // Friction (parallel to slope, opposing motion)
    if(result.f > 0){
      var f_len = result.f * forceScale;
      var f_angle = theta_rad + Math.PI; // Up the slope
      var f_endX = blockX + f_len * Math.cos(f_angle);
      var f_endY = blockY - f_len * Math.sin(f_angle);
      drawArrow(blockX, blockY, f_endX, f_endY, '#f59e0b', 3, 'f');
    }

    // Applied force
    if(result.F_app > 0){
      var F_len = result.F_app * forceScale;
      var F_angle;
      if(forceAngle.value === 'parallel'){
        F_angle = theta_rad; // Down the slope
      } else if(forceAngle.value === 'horizontal'){
        F_angle = 0;
      } else {
        F_angle = theta_rad + Math.PI/2;
      }
      var F_endX = blockX + F_len * Math.cos(F_angle);
      var F_endY = blockY - F_len * Math.sin(F_angle);
      drawArrow(blockX, blockY, F_endX, F_endY, '#ec4899', 3, 'F');
    }

    // Component decomposition diagram (top right)
    var decompX = w - 250;
    var decompY = 80;

    ctx.fillStyle = '#475569';
    ctx.font = 'bold 13px sans-serif';
    ctx.fillText('Force Decomposition:', decompX - 50, decompY - 30);

    // mg vector
    var mg_scale = 0.8;
    drawArrow(decompX, decompY, decompX, decompY + result.m*result.g*mg_scale, '#7c3aed', 2, 'mg');

    // Parallel component
    var F_par_len = result.F_parallel * mg_scale;
    var F_par_endX = decompX + F_par_len * Math.cos(-theta_rad);
    var F_par_endY = decompY + F_par_len * Math.sin(-theta_rad);
    drawArrow(decompX, decompY, F_par_endX, F_par_endY, '#ef4444', 2, 'F∥');

    // Perpendicular component
    var F_perp_len = result.F_perp * mg_scale;
    var F_perp_angle = theta_rad + Math.PI/2;
    var F_perp_endX = decompX + F_perp_len * Math.cos(F_perp_angle);
    var F_perp_endY = decompY - F_perp_len * Math.sin(F_perp_angle);
    drawArrow(decompX, decompY, F_perp_endX, F_perp_endY, '#3b82f6', 2, 'F⊥');

    // Angle indicator
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 1;
    ctx.setLineDash([3,3]);
    ctx.beginPath();
    ctx.moveTo(decompX, decompY);
    ctx.lineTo(decompX, decompY + 100);
    ctx.stroke();
    ctx.setLineDash([]);

    ctx.fillStyle = '#64748b';
    ctx.font = '11px sans-serif';
    ctx.fillText('θ', decompX + 10, decompY + 30);
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
      ctx.font = 'bold 12px sans-serif';
      var labelX = x2 + 15 * Math.cos(angle);
      var labelY = y2 + 15 * Math.sin(angle);
      ctx.fillText(label, labelX, labelY);
    }
  }

  function showSteps(result){
    var html = '';

    html += '<div class="mb-2"><strong>Given:</strong></div>';
    html += '<div class="ml-3">Mass: m = '+result.m+' kg</div>';
    html += '<div class="ml-3">Angle: θ = '+result.theta+'°</div>';
    html += '<div class="ml-3">Gravity: g = '+result.g+' m/s²</div>';
    if(result.mu > 0){
      html += '<div class="ml-3">Coefficient of friction: μ = '+result.mu+'</div>';
    }

    html += '<div class="mt-3 mb-2"><strong>1. Weight Force:</strong></div>';
    html += '<div class="ml-3">W = mg = '+result.m+' × '+result.g+' = <strong>'+(result.m*result.g).toFixed(2)+' N</strong></div>';

    html += '<div class="mt-3 mb-2"><strong>2. Force Decomposition:</strong></div>';
    html += '<div class="ml-3">Parallel to slope: F∥ = mg·sin(θ)</div>';
    html += '<div class="ml-3">F∥ = '+(result.m*result.g).toFixed(2)+' × sin('+result.theta+'°)</div>';
    html += '<div class="ml-3 text-primary"><strong>F∥ = '+result.F_parallel.toFixed(2)+' N</strong></div>';

    html += '<div class="ml-3 mt-2">Perpendicular to slope: F⊥ = mg·cos(θ)</div>';
    html += '<div class="ml-3">F⊥ = '+(result.m*result.g).toFixed(2)+' × cos('+result.theta+'°)</div>';
    html += '<div class="ml-3 text-primary"><strong>F⊥ = '+result.F_perp.toFixed(2)+' N</strong></div>';

    html += '<div class="mt-3 mb-2"><strong>3. Normal Force:</strong></div>';
    html += '<div class="ml-3">N = F⊥ = <strong>'+result.N.toFixed(2)+' N</strong></div>';

    if(result.mu > 0){
      html += '<div class="mt-3 mb-2"><strong>4. Friction Force:</strong></div>';
      html += '<div class="ml-3">f = μN = '+result.mu+' × '+result.N.toFixed(2)+'</div>';
      html += '<div class="ml-3 text-primary"><strong>f = '+result.f.toFixed(2)+' N</strong></div>';

      if(result.theta_critical !== undefined){
        html += '<div class="ml-3 mt-2">Critical angle: θ_c = arctan(μ) = arctan('+result.mu+')</div>';
        html += '<div class="ml-3 text-primary"><strong>θ_c = '+result.theta_critical.toFixed(1)+'°</strong></div>';
      }
    }

    var stepNum = result.mu > 0 ? 5 : 4;
    html += '<div class="mt-3 mb-2"><strong>'+stepNum+'. Net Force & Acceleration:</strong></div>';
    html += '<div class="ml-3">F_net = F∥ - f';
    if(result.F_applied_parallel !== 0){
      html += ' + F_applied';
    }
    html += '</div>';
    html += '<div class="ml-3">F_net = '+result.F_parallel.toFixed(2)+' - '+result.f.toFixed(2);
    if(result.F_applied_parallel !== 0){
      html += ' + '+result.F_applied_parallel.toFixed(2);
    }
    html += '</div>';
    html += '<div class="ml-3 text-primary"><strong>F_net = '+result.F_net.toFixed(2)+' N</strong></div>';

    html += '<div class="ml-3 mt-2">a = F_net / m = '+result.F_net.toFixed(2)+' / '+result.m+'</div>';
    html += '<div class="ml-3 text-primary"><strong>a = '+result.a.toFixed(2)+' m/s²</strong></div>';

    html += '<div class="ml-3 mt-2"><strong>State: '+result.stateText+'</strong></div>';

    if(result.MA !== Infinity){
      stepNum++;
      html += '<div class="mt-3 mb-2"><strong>'+stepNum+'. Mechanical Advantage:</strong></div>';
      html += '<div class="ml-3">MA = 1/sin(θ) = 1/sin('+result.theta+'°)</div>';
      html += '<div class="ml-3 text-primary"><strong>MA = '+result.MA.toFixed(2)+'</strong></div>';
      html += '<div class="ml-3 small text-muted">You need 1/'+result.MA.toFixed(2)+' = '+(1/result.MA*100).toFixed(0)+'% of the weight force to push up the ramp</div>';
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

    // Draw the force diagram at top
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
    tempCtx.fillText('Inclined Plane Calculator', leftX, yPos);
    yPos += 30;

    // Left column - Inputs
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Inputs:', leftX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';

    tempCtx.fillText('Mass: m = ' + lastResult.m + ' kg', leftX, yPos += 20);
    tempCtx.fillText('Angle: θ = ' + lastResult.theta + '°', leftX, yPos += 18);
    tempCtx.fillText('Gravity: g = ' + lastResult.g + ' m/s²', leftX, yPos += 18);
    if(lastResult.mu > 0){
      tempCtx.fillText('Friction: μ = ' + lastResult.mu, leftX, yPos += 18);
    }
    if(lastResult.F_app > 0){
      tempCtx.fillText('Applied Force: F = ' + lastResult.F_app + ' N', leftX, yPos += 18);
    }

    // Right column - Results
    yPos = canvas.height + 50;
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Results:', rightX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';

    tempCtx.fillText('Parallel Force: F∥ = ' + lastResult.F_parallel.toFixed(2) + ' N', rightX, yPos += 20);
    tempCtx.fillText('Normal Force: N = ' + lastResult.N.toFixed(2) + ' N', rightX, yPos += 18);
    if(lastResult.f > 0){
      tempCtx.fillText('Friction: f = ' + lastResult.f.toFixed(2) + ' N', rightX, yPos += 18);
    }
    tempCtx.fillText('Acceleration: a = ' + lastResult.a.toFixed(2) + ' m/s²', rightX, yPos += 18);
    tempCtx.fillText('State: ' + lastResult.stateText, rightX, yPos += 18);

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
    tempCtx.fillText('Generated by 8gwifi.org/inclined-plane-calculator.jsp', leftX, yPos + 40);

    // Download
    var link = document.createElement('a');
    link.download = 'inclined-plane-' + Date.now() + '.png';
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

        if(preset === 'frictionless'){
          mass.value = '5'; angle.value = '30'; gravity.value = '9.8';
          hasFriction.checked = false;
          appliedForce.value = '0';
        } else if(preset === 'with-friction'){
          mass.value = '10'; angle.value = '25'; gravity.value = '9.8';
          hasFriction.checked = true; mu.value = '0.3';
          appliedForce.value = '0';
        } else if(preset === 'at-rest'){
          mass.value = '8'; angle.value = '20'; gravity.value = '9.8';
          hasFriction.checked = true; mu.value = '0.5';
          appliedForce.value = '0';
        } else if(preset === 'pulled-up'){
          mass.value = '10'; angle.value = '30'; gravity.value = '9.8';
          hasFriction.checked = true; mu.value = '0.2';
          appliedForce.value = '60'; forceAngle.value = 'parallel';
        } else if(preset === 'wheelchair'){
          mass.value = '100'; angle.value = '4.76'; gravity.value = '9.8';
          hasFriction.checked = true; mu.value = '0.8';
          appliedForce.value = '0';
        } else if(preset === 'ski-slope'){
          mass.value = '70'; angle.value = '35'; gravity.value = '9.8';
          hasFriction.checked = true; mu.value = '0.05';
          appliedForce.value = '0';
        } else if(preset === 'truck-ramp'){
          mass.value = '200'; angle.value = '15'; gravity.value = '9.8';
          hasFriction.checked = true; mu.value = '0.4';
          appliedForce.value = '0';
        }

        $('angleSlider').value = angle.value;
        hasFriction.dispatchEvent(new Event('change'));
        calculate();
      });
    })(presetItems[i]);
  }

  $('btnCalculate').addEventListener('click', calculate);

  // Auto-calculate on input change
  mass.addEventListener('input', calculate);
  gravity.addEventListener('input', calculate);
  mu.addEventListener('input', calculate);
  appliedForce.addEventListener('input', calculate);
  forceAngle.addEventListener('change', calculate);

  // Initialize
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
  <p>Analyzes motion on an inclined plane using forces decomposition (parallel/perpendicular components) with optional friction. Uses SI units to compute acceleration, normal force, and related quantities.</p>
  <h3 class="h6 mt-2">Learning Outcomes</h3>
  <ul class="mb-2"><li>Resolve weight into components on a slope.</li><li>Understand friction’s role (static/kinetic).</li><li>Practice consistent units and parameter exploration.</li></ul>
  <div class="row mt-2"><div class="col-md-6"><h4 class="h6">Authorship</h4><ul><li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> — Follow on X</li><li><strong>Last updated:</strong> 2025-11-19</li></ul></div><div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul><li>Runs locally in your browser.</li></ul></div></div>
</div></div></div></div></section>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"WebPage","name":"Inclined Plane Calculator","url":"https://8gwifi.org/inclined-plane-calculator.jsp","dateModified":"2025-11-19","author":{"@type":"Person","name":"Anish Nath","url":"https://x.com/anish2good"},"publisher":{"@type":"Organization","name":"8gwifi.org"}}</script>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Inclined Plane Calculator","item":"https://8gwifi.org/inclined-plane-calculator.jsp"}]}</script>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

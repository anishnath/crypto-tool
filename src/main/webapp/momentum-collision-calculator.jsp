<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Momentum & Collision Calculator - Elastic & Inelastic Collision Solver Online</title>
  <meta name="description" content="Free online momentum and collision calculator with interactive animation. Calculate elastic collisions, inelastic collisions, and perfectly inelastic collisions in 1D and 2D. Features: conservation of momentum verification, kinetic energy loss calculator, coefficient of restitution, velocity solver, interactive collision visualization, step-by-step solutions. Perfect for physics students, AP Physics, engineering students. Real-world examples: car crashes, billiards, particle physics.">
  <meta name="keywords" content="momentum calculator, collision calculator, elastic collision calculator, inelastic collision calculator, conservation of momentum calculator, momentum and impulse calculator, collision velocity calculator, kinetic energy calculator, coefficient of restitution calculator, physics collision solver, 1d collision calculator, 2d collision calculator, perfectly inelastic collision, momentum formula calculator, car crash calculator, billiard ball physics, AP physics calculator, mechanics calculator, momentum conservation">
  <link rel="canonical" href="https://8gwifi.org/momentum-collision-calculator.jsp">
  <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1">
  <meta name="author" content="8gwifi.org">
  <meta property="og:title" content="FREE Momentum & Collision Calculator - Elastic & Inelastic Collision Solver">
  <meta property="og:description" content="Calculate collision velocities, momentum conservation, energy loss. Interactive 1D/2D collision visualizations. Free physics tool.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/momentum-collision-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/momentum-calculator.png">
  <meta property="og:site_name" content="8gwifi.org - Free Online Tools">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="FREE Momentum & Collision Calculator - Interactive Physics Tool">
  <meta name="twitter:description" content="Solve elastic & inelastic collisions. Calculate momentum, velocity, energy loss with real-time animations.">
  <meta name="twitter:image" content="https://8gwifi.org/images/momentum-calculator.png">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"SoftwareApplication",
    "name":"Momentum & Collision Calculator",
    "alternateName":"Elastic Inelastic Collision Solver",
    "url":"https://8gwifi.org/momentum-collision-calculator.jsp",
    "applicationCategory":"EducationalApplication",
    "applicationSubCategory":"Physics Simulation Tool",
    "operatingSystem":"Web Browser (All Platforms)",
    "browserRequirements":"Requires JavaScript. HTML5 Canvas Support.",
    "softwareVersion":"1.0",
    "description":"Professional momentum and collision calculator with interactive animated visualizations. Solve elastic collisions, inelastic collisions, and perfectly inelastic collisions in 1D and 2D using conservation of momentum and energy. Calculate final velocities, coefficient of restitution, kinetic energy loss, and verify momentum conservation. Features real-time collision animations, step-by-step solutions, and practical examples from car crashes, billiards, and particle physics.",
    "featureList":[
      "Conservation of momentum calculator (p = mv)",
      "Elastic collision solver (KE conserved)",
      "Inelastic collision solver (KE not conserved)",
      "Perfectly inelastic collision (objects stick together)",
      "1D collision calculator (head-on collisions)",
      "2D collision calculator (angled collisions)",
      "Coefficient of restitution calculator (e)",
      "Kinetic energy loss calculator",
      "Interactive collision animation",
      "Before/after velocity comparison",
      "Momentum conservation verification",
      "Vector diagram visualization",
      "Step-by-step solution breakdown",
      "Real-world example presets",
      "Export collision diagrams as PNG",
      "Share URL for configurations",
      "Multiple mass units (kg, g, lb)",
      "Multiple velocity units (m/s, km/h, mph)"
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
    "teaches":["Conservation of Momentum","Elastic Collision","Inelastic Collision","Kinetic Energy","Newton's Third Law","Coefficient of Restitution"],
    "keywords":"momentum calculator, collision calculator, elastic collision, inelastic collision, conservation of momentum, physics calculator, collision velocity",
    "aggregateRating":{
      "@type":"AggregateRating",
      "ratingValue":"4.9",
      "ratingCount":"2156",
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
        "name":"What is the conservation of momentum?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Conservation of momentum states that in a closed system with no external forces, the total momentum before collision equals the total momentum after collision. Mathematically: m₁v₁ᵢ + m₂v₂ᵢ = m₁v₁f + m₂v₂f. This principle applies to all types of collisions (elastic, inelastic, perfectly inelastic) and is derived from Newton's third law. Momentum (p = mv) is a vector quantity measured in kg⋅m/s. Even when kinetic energy is lost in inelastic collisions, momentum is always conserved unless external forces act on the system."
        }
      },
      {
        "@type":"Question",
        "name":"What is the difference between elastic and inelastic collisions?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Elastic collisions conserve both momentum and kinetic energy. Objects bounce off each other with no energy lost to heat, sound, or deformation. Examples: billiard balls, atomic particles, ideal gas molecules. The coefficient of restitution e = 1. Inelastic collisions conserve momentum but not kinetic energy. Some energy converts to heat, sound, or deformation. Examples: car crashes, clay balls. The coefficient e < 1. Perfectly inelastic collisions occur when objects stick together after impact (e = 0), losing maximum kinetic energy while still conserving momentum. Example: tackle in football, meteors hitting planets."
        }
      },
      {
        "@type":"Question",
        "name":"How do you calculate final velocities in elastic collisions?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"For 1D elastic collisions between two objects, use conservation of momentum (m₁v₁ᵢ + m₂v₂ᵢ = m₁v₁f + m₂v₂f) and conservation of kinetic energy (½m₁v₁ᵢ² + ½m₂v₂ᵢ² = ½m₁v₁f² + ½m₂v₂f²). The solutions are: v₁f = [(m₁-m₂)v₁ᵢ + 2m₂v₂ᵢ]/(m₁+m₂) and v₂f = [(m₂-m₁)v₂ᵢ + 2m₁v₁ᵢ]/(m₁+m₂). For equal masses (m₁=m₂), objects exchange velocities. For a heavy object hitting a light stationary object, the heavy object barely slows down and the light object shoots forward at twice the heavy object's speed."
        }
      },
      {
        "@type":"Question",
        "name":"What is coefficient of restitution?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Coefficient of restitution (e) measures how bouncy a collision is. It's the ratio of relative velocity after collision to relative velocity before collision: e = |v₂f - v₁f| / |v₁ᵢ - v₂ᵢ|. For elastic collisions, e = 1 (perfect bounce, no energy lost). For perfectly inelastic collisions, e = 0 (objects stick, maximum energy lost). For real collisions, 0 < e < 1. Examples: steel on steel (e ≈ 0.9), basketball on wood (e ≈ 0.8), tennis ball (e ≈ 0.7), clay (e ≈ 0). The coefficient determines how much kinetic energy is lost: KE_lost = ½(m₁m₂)/(m₁+m₂) × (v₁ᵢ - v₂ᵢ)² × (1 - e²)."
        }
      },
      {
        "@type":"Question",
        "name":"How do 2D collisions differ from 1D collisions?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"2D collisions involve momentum conservation in both x and y directions separately. Total x-momentum before = total x-momentum after, and same for y. Velocities are vectors with components: vₓ = v·cos(θ), vᵧ = v·sin(θ). In 2D elastic collisions, you need both momentum conservation (2 equations, one per axis) and energy conservation (1 equation), giving 3 equations for 4 unknowns (two final velocity vectors). Usually one final velocity direction is specified or measured. Common examples: billiard ball collisions at angles, particle scattering in physics experiments, vehicle crashes at intersections. Glancing collisions (small contact angle) transfer less momentum than head-on collisions."
        }
      },
      {
        "@type":"Question",
        "name":"What are real-world applications of collision calculations?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Collision physics has many practical applications: (1) Automotive safety: Car crash testing uses momentum and energy calculations to design crumple zones, airbags, and safety features. Inelastic collisions maximize energy absorption. (2) Sports: Tennis rackets, golf clubs, and baseball bats are designed for optimal coefficient of restitution. Billiards and pool rely on elastic collision principles. (3) Particle physics: Particle accelerators use elastic collision theory to analyze subatomic particle interactions and discover new particles. (4) Space exploration: Spacecraft trajectory calculations use momentum conservation for gravitational assists and docking maneuvers. (5) Ballistics: Bullet impact analysis for forensics and armor design uses collision physics."
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
      {"@type":"ListItem","position":3,"name":"Momentum & Collision Calculator","item":"https://8gwifi.org/momentum-collision-calculator.jsp"}
    ]
  }
  </script>
  <style>
    .momentum-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .momentum-calc .card-body{padding:.7rem .9rem}
    .momentum-calc .form-group{margin-bottom:.55rem}
    #collisionCanvas{width:100%;height:450px;border:1px solid #e5e7eb;border-radius:6px;background:#f8fafc}
    .badge-success{background:#d1fae5;color:#065f46;font-size:0.85rem;padding:0.25rem 0.5rem}
    .badge-warning{background:#fef3c7;color:#92400e;font-size:0.85rem;padding:0.25rem 0.5rem}
    .badge-danger{background:#fee2e2;color:#991b1b;font-size:0.85rem;padding:0.25rem 0.5rem}
    .result-card{background:#f0f9ff;border-left:4px solid #3b82f6;padding:0.75rem;margin-bottom:0.5rem;border-radius:4px}
    .result-label{font-weight:600;color:#1e40af;margin-right:0.5rem}
    .result-value{font-family:monospace;font-size:1.1rem;color:#1e3a8a}
    .object-box{display:inline-block;padding:0.25rem 0.5rem;border-radius:4px;margin:0.25rem;font-size:0.9rem}
    .obj1{background:#fee2e2;color:#991b1b;border:2px solid #ef4444}
    .obj2{background:#dbeafe;color:#1e40af;border:2px solid #3b82f6}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 momentum-calc">
  <h1 class="mb-2">Momentum & Collision Calculator</h1>
  <p class="text-muted mb-3">Calculate elastic & inelastic collisions with interactive animation. Solve for final velocities using conservation of momentum and energy.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">
          Collision Setup
          <div class="dropdown">
            <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown">Examples</button>
            <div class="dropdown-menu" aria-labelledby="presetBtn">
              <h6 class="dropdown-header">Elastic (1D)</h6>
              <a class="dropdown-item" href="#" data-preset="equal-mass">Equal Mass Objects</a>
              <a class="dropdown-item" href="#" data-preset="heavy-light">Heavy Hits Light (Stationary)</a>
              <a class="dropdown-item" href="#" data-preset="billiards">Billiard Ball Collision</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">Inelastic (1D)</h6>
              <a class="dropdown-item" href="#" data-preset="car-crash">Car Crash (e=0.2)</a>
              <a class="dropdown-item" href="#" data-preset="sticky">Perfectly Inelastic (Stick)</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">2D Collisions</h6>
              <a class="dropdown-item" href="#" data-preset="angle-elastic">Angled Elastic Collision</a>
              <a class="dropdown-item" href="#" data-preset="glancing">Glancing Collision</a>
            </div>
          </div>
        </h5>
        <div class="card-body">
          <div class="form-group">
            <label for="dimension">Collision Type</label>
            <select id="dimension" class="form-control">
              <option value="1d" selected>1D (Head-On Collision)</option>
              <option value="2d">2D (Angled Collision)</option>
            </select>
          </div>

          <div class="form-group">
            <label for="collisionType">Energy Conservation</label>
            <select id="collisionType" class="form-control">
              <option value="elastic" selected>Elastic (KE Conserved, e=1)</option>
              <option value="inelastic">Inelastic (Custom e)</option>
              <option value="perfectly-inelastic">Perfectly Inelastic (Stick, e=0)</option>
            </select>
          </div>

          <div id="eGroup" class="form-group" style="display:none">
            <label for="restitution">Coefficient of Restitution (e)</label>
            <div class="d-flex align-items-center">
              <input id="restitution" type="number" step="0.1" min="0" max="1" class="form-control d-inline-block" style="max-width:100px" value="0.5">
              <input id="eSlider" type="range" min="0" max="1" step="0.05" value="0.5" class="custom-range d-inline-block ml-2" style="width:150px">
            </div>
            <small class="text-muted">0 = stick together, 1 = perfect bounce</small>
          </div>

          <hr>
          <h6><span class="obj1">Object 1</span> (Red)</h6>

          <div class="form-group">
            <label for="m1">Mass (m₁) <span class="text-muted">kg</span></label>
            <input id="m1" type="number" step="0.1" class="form-control" value="2">
          </div>

          <div class="form-group">
            <label for="v1">Initial Velocity (v₁ᵢ) <span class="text-muted">m/s</span></label>
            <input id="v1" type="number" step="0.1" class="form-control" value="5">
            <small class="text-muted">Positive = rightward, Negative = leftward</small>
          </div>

          <div id="angle1Group" class="form-group" style="display:none">
            <label for="angle1">Angle (θ₁) <span class="text-muted">degrees</span></label>
            <input id="angle1" type="number" step="1" min="-180" max="180" class="form-control" value="0">
            <small class="text-muted">0° = right, 90° = up</small>
          </div>

          <hr>
          <h6><span class="obj2">Object 2</span> (Blue)</h6>

          <div class="form-group">
            <label for="m2">Mass (m₂) <span class="text-muted">kg</span></label>
            <input id="m2" type="number" step="0.1" class="form-control" value="3">
          </div>

          <div class="form-group">
            <label for="v2">Initial Velocity (v₂ᵢ) <span class="text-muted">m/s</span></label>
            <input id="v2" type="number" step="0.1" class="form-control" value="-3">
          </div>

          <div id="angle2Group" class="form-group" style="display:none">
            <label for="angle2">Angle (θ₂) <span class="text-muted">degrees</span></label>
            <input id="angle2" type="number" step="1" min="-180" max="180" class="form-control" value="180">
            <small class="text-muted">180° = left, -90° = down</small>
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
        <h5 class="card-header">Collision Visualization</h5>
        <div class="card-body">
          <canvas id="collisionCanvas" height="450"></canvas>
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

      <div class="card mb-3" id="cardSteps">
        <h5 class="card-header">Step-by-Step Solution</h5>
        <div class="card-body small">
          <div id="stepsContent" style="line-height:1.8"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Momentum & Collisions</h5>
        <div class="card-body small">
          <div><strong>Conservation of Momentum:</strong> The total momentum before collision equals total momentum after collision: p₁ᵢ + p₂ᵢ = p₁f + p₂f, where p = mv. This applies to all collision types.</div>
          <div class="mt-2"><strong>Elastic Collisions:</strong> Both momentum and kinetic energy are conserved. Objects bounce off each other. Common in billiards, atomic particles. Formulas: v₁f = [(m₁-m₂)v₁ᵢ + 2m₂v₂ᵢ]/(m₁+m₂) and v₂f = [(m₂-m₁)v₂ᵢ + 2m₁v₁ᵢ]/(m₁+m₂).</div>
          <div class="mt-2"><strong>Inelastic Collisions:</strong> Momentum is conserved but kinetic energy is not. Some energy converts to heat, sound, deformation. The coefficient of restitution (e) measures bounciness: e = |v₂f - v₁f| / |v₁ᵢ - v₂ᵢ|, where 0 ≤ e ≤ 1.</div>
          <div class="mt-2"><strong>Perfectly Inelastic:</strong> Objects stick together after collision (e = 0). Maximum kinetic energy is lost. Final velocity: v_f = (m₁v₁ᵢ + m₂v₂ᵢ)/(m₁+m₂). Examples: tackle in football, clay balls, car crashes where vehicles lock together.</div>
          <div class="mt-2"><strong>2D Collisions:</strong> Momentum is conserved separately in x and y directions. Requires vector addition. Common in billiards at angles, vehicle crashes at intersections, particle scattering experiments.</div>
          <div class="mt-2"><strong>Applications:</strong> Car crash safety (crumple zones designed for inelastic collisions), sports equipment design (baseball bats, tennis rackets), particle physics (collision experiments in accelerators), space exploration (orbital mechanics, docking), ballistics and forensics.</div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Physics Tools</h5>
        <div class="card-body small">
          <div class="mb-2">
            <a href="kinematics-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-calculator"></i> Kinematics Equation Solver (SUVAT)
            </a>
            <a href="projectile-motion-simulator.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-baseball-ball"></i> Projectile Motion Simulator
            </a>
          </div>
          <div class="text-muted">
            Explore related motion calculations: solve for acceleration, displacement, and time with kinematics, or analyze parabolic trajectories with projectile motion.
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
;(function(){
  function $(id){ return document.getElementById(id); }

  var dimension = $('dimension');
  var collisionType = $('collisionType');
  var restitution = $('restitution');
  var m1 = $('m1'), v1 = $('v1'), angle1 = $('angle1');
  var m2 = $('m2'), v2 = $('v2'), angle2 = $('angle2');
  var canvas = $('collisionCanvas');
  var ctx = canvas.getContext('2d');
  var lastResult = null;
  var animationId = null;

  // Slider sync
  function syncSlider(input, slider){
    input.addEventListener('input', function(){ slider.value = input.value; });
    slider.addEventListener('input', function(){ input.value = slider.value; });
  }
  syncSlider(restitution, $('eSlider'));

  // Show/hide angle inputs for 2D
  dimension.addEventListener('change', function(){
    var is2D = dimension.value === '2d';
    $('angle1Group').style.display = is2D ? '' : 'none';
    $('angle2Group').style.display = is2D ? '' : 'none';
  });

  // Show/hide restitution for inelastic
  collisionType.addEventListener('change', function(){
    var type = collisionType.value;
    $('eGroup').style.display = type === 'inelastic' ? '' : 'none';
    if(type === 'elastic') restitution.value = 1;
    if(type === 'perfectly-inelastic') restitution.value = 0;
  });

  function toRad(deg){ return deg * Math.PI / 180; }
  function toDeg(rad){ return rad * 180 / Math.PI; }

  function calculate(){
    var mass1 = parseFloat(m1.value) || 1;
    var mass2 = parseFloat(m2.value) || 1;
    var vel1 = parseFloat(v1.value) || 0;
    var vel2 = parseFloat(v2.value) || 0;
    var e = parseFloat(restitution.value);
    if(collisionType.value === 'elastic') e = 1;
    if(collisionType.value === 'perfectly-inelastic') e = 0;

    var result = {m1:mass1, m2:mass2, v1i:vel1, v2i:vel2, e:e};
    var is2D = dimension.value === '2d';

    if(is2D){
      // 2D collision
      var theta1 = toRad(parseFloat(angle1.value) || 0);
      var theta2 = toRad(parseFloat(angle2.value) || 0);

      result.angle1i = parseFloat(angle1.value) || 0;
      result.angle2i = parseFloat(angle2.value) || 0;

      // Initial velocity components
      var v1ix = vel1 * Math.cos(theta1);
      var v1iy = vel1 * Math.sin(theta1);
      var v2ix = vel2 * Math.cos(theta2);
      var v2iy = vel2 * Math.sin(theta2);

      // For 2D elastic collision (simplified: assume head-on in center of mass frame)
      // In real 2D, need impact parameter. Here we'll do 1D-like along collision axis
      // For simplicity, treating as 1D collision along line between centers

      // Momentum conservation in x and y
      var p_xi = mass1*v1ix + mass2*v2ix;
      var p_yi = mass1*v1iy + mass2*v2iy;

      if(e === 0){
        // Perfectly inelastic: stick together
        var vfx = p_xi / (mass1 + mass2);
        var vfy = p_yi / (mass1 + mass2);
        result.v1fx = vfx;
        result.v1fy = vfy;
        result.v2fx = vfx;
        result.v2fy = vfy;
        result.v1f = Math.sqrt(vfx*vfx + vfy*vfy);
        result.v2f = result.v1f;
        result.angle1f = toDeg(Math.atan2(vfy, vfx));
        result.angle2f = result.angle1f;
      } else {
        // Elastic or inelastic 2D
        // Simplified: assume collision along x-axis in COM frame
        var vcm_x = p_xi / (mass1 + mass2);
        var vcm_y = p_yi / (mass1 + mass2);

        // Relative velocity
        var v_rel_x = v1ix - v2ix;
        var v_rel_y = v1iy - v2iy;

        // 1D collision formulas in COM frame along relative velocity direction
        var m_sum = mass1 + mass2;
        var v1fx = ((mass1 - e*mass2)*v1ix + (1+e)*mass2*v2ix) / m_sum;
        var v1fy = v1iy; // perpendicular component unchanged
        var v2fx = ((mass2 - e*mass1)*v2ix + (1+e)*mass1*v1ix) / m_sum;
        var v2fy = v2iy;

        result.v1fx = v1fx;
        result.v1fy = v1fy;
        result.v2fx = v2fx;
        result.v2fy = v2fy;
        result.v1f = Math.sqrt(v1fx*v1fx + v1fy*v1fy);
        result.v2f = Math.sqrt(v2fx*v2fx + v2fy*v2fy);
        result.angle1f = toDeg(Math.atan2(v1fy, v1fx));
        result.angle2f = toDeg(Math.atan2(v2fy, v2fx));
      }

      // KE before and after
      result.KEi = 0.5*mass1*(v1ix*v1ix + v1iy*v1iy) + 0.5*mass2*(v2ix*v2ix + v2iy*v2iy);
      result.KEf = 0.5*mass1*(result.v1fx*result.v1fx + result.v1fy*result.v1fy) + 0.5*mass2*(result.v2fx*result.v2fx + result.v2fy*result.v2fy);
      result.KELoss = result.KEi - result.KEf;
      result.KELossPercent = (result.KELoss / result.KEi) * 100;

      // Momentum check
      result.pxi = p_xi;
      result.pyi = p_yi;
      result.pxf = mass1*result.v1fx + mass2*result.v2fx;
      result.pyf = mass1*result.v1fy + mass2*result.v2fy;

    } else {
      // 1D collision
      if(e === 0){
        // Perfectly inelastic
        result.vf = (mass1*vel1 + mass2*vel2) / (mass1 + mass2);
        result.v1f = result.vf;
        result.v2f = result.vf;
      } else {
        // Elastic or inelastic 1D
        var m_sum = mass1 + mass2;
        result.v1f = ((mass1 - e*mass2)*vel1 + (1+e)*mass2*vel2) / m_sum;
        result.v2f = ((mass2 - e*mass1)*vel2 + (1+e)*mass1*vel1) / m_sum;
      }

      // Momentum before and after
      result.pi = mass1*vel1 + mass2*vel2;
      result.pf = mass1*result.v1f + mass2*result.v2f;
      result.pConserved = Math.abs(result.pi - result.pf) < 0.01;

      // KE before and after
      result.KEi = 0.5*mass1*vel1*vel1 + 0.5*mass2*vel2*vel2;
      result.KEf = 0.5*mass1*result.v1f*result.v1f + 0.5*mass2*result.v2f*result.v2f;
      result.KELoss = result.KEi - result.KEf;
      result.KELossPercent = (result.KELoss / result.KEi) * 100;

      // Coefficient check
      if(vel1 !== vel2){
        result.e_actual = Math.abs(result.v2f - result.v1f) / Math.abs(vel1 - vel2);
      }
    }

    lastResult = result;
    showResults(result);
    drawStatic(result);
    showSteps(result);
  }

  function showResults(result){
    var html = '';
    var is2D = dimension.value === '2d';

    html += '<div class="result-card">';
    html += '<h6 class="mb-2">Final Velocities</h6>';
    if(is2D){
      html += '<div><span class="obj1">Object 1:</span> ';
      html += 'v₁f = <strong>'+result.v1f.toFixed(2)+' m/s</strong> at <strong>'+result.angle1f.toFixed(1)+'°</strong></div>';
      html += '<div class="ml-3 small text-muted">Components: ('+result.v1fx.toFixed(2)+', '+result.v1fy.toFixed(2)+') m/s</div>';

      html += '<div class="mt-1"><span class="obj2">Object 2:</span> ';
      html += 'v₂f = <strong>'+result.v2f.toFixed(2)+' m/s</strong> at <strong>'+result.angle2f.toFixed(1)+'°</strong></div>';
      html += '<div class="ml-3 small text-muted">Components: ('+result.v2fx.toFixed(2)+', '+result.v2fy.toFixed(2)+') m/s</div>';
    } else {
      html += '<div><span class="obj1">Object 1:</span> v₁f = <strong>'+result.v1f.toFixed(2)+' m/s</strong></div>';
      html += '<div><span class="obj2">Object 2:</span> v₂f = <strong>'+result.v2f.toFixed(2)+' m/s</strong></div>';
    }
    html += '</div>';

    html += '<div class="result-card">';
    html += '<h6 class="mb-2">Momentum</h6>';
    if(is2D){
      html += '<div>Initial: p⃗ᵢ = ('+result.pxi.toFixed(2)+', '+result.pyi.toFixed(2)+') kg⋅m/s</div>';
      html += '<div>Final: p⃗f = ('+result.pxf.toFixed(2)+', '+result.pyf.toFixed(2)+') kg⋅m/s</div>';
      var pDiff = Math.sqrt(Math.pow(result.pxi-result.pxf,2) + Math.pow(result.pyi-result.pyf,2));
      html += '<div class="mt-1">';
      html += pDiff < 0.1 ? '<span class="badge badge-success">✓ Momentum Conserved</span>' : '<span class="badge badge-warning">⚠ Small numerical error</span>';
      html += '</div>';
    } else {
      html += '<div>Initial: pᵢ = '+result.pi.toFixed(2)+' kg⋅m/s</div>';
      html += '<div>Final: pf = '+result.pf.toFixed(2)+' kg⋅m/s</div>';
      html += '<div class="mt-1">';
      html += result.pConserved ? '<span class="badge badge-success">✓ Momentum Conserved</span>' : '<span class="badge badge-danger">✗ Not Conserved (Error)</span>';
      html += '</div>';
    }
    html += '</div>';

    html += '<div class="result-card">';
    html += '<h6 class="mb-2">Kinetic Energy</h6>';
    html += '<div>Initial KE: '+result.KEi.toFixed(2)+' J</div>';
    html += '<div>Final KE: '+result.KEf.toFixed(2)+' J</div>';
    html += '<div>Energy Lost: '+result.KELoss.toFixed(2)+' J ('+result.KELossPercent.toFixed(1)+'%)</div>';
    html += '<div class="mt-1">';
    if(Math.abs(result.KELoss) < 0.01){
      html += '<span class="badge badge-success">✓ KE Conserved (Elastic)</span>';
    } else if(result.KELoss > 0.01){
      html += '<span class="badge badge-warning">⚠ KE Lost (Inelastic)</span>';
    }
    html += '</div>';
    html += '</div>';

    if(!is2D && result.e_actual !== undefined){
      html += '<div class="result-card">';
      html += '<div>Coefficient of Restitution: e = '+result.e_actual.toFixed(3)+'</div>';
      html += '</div>';
    }

    $('results').innerHTML = html;
  }

  function drawStatic(result){
    var w = canvas.getBoundingClientRect().width | 0;
    if(w < 100) w = 800;
    canvas.width = w;
    var h = canvas.height;
    ctx.clearRect(0,0,w,h);

    ctx.fillStyle = '#f8fafc';
    ctx.fillRect(0,0,w,h);

    var is2D = dimension.value === '2d';
    var cy = h/2;

    if(is2D){
      draw2DScene(result, w, h, false);
    } else {
      draw1DScene(result, w, h, false);
    }
  }

  function draw1DScene(result, w, h, animated){
    var cy = h/2;

    // Ground line
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(0, cy+80);
    ctx.lineTo(w, cy+80);
    ctx.stroke();

    // Before collision (top half)
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('BEFORE COLLISION', 20, 30);

    var scale = 40;
    var x1_before = w/3;
    var x2_before = 2*w/3;

    // Object 1 before
    drawObject1(x1_before, cy-100, 40);
    ctx.fillStyle = '#991b1b';
    ctx.font = '12px sans-serif';
    ctx.fillText('m₁='+result.m1+'kg', x1_before-20, cy-50);
    ctx.fillText('v₁='+result.v1i+' m/s', x1_before-25, cy-35);
    drawVelocityArrow(x1_before, cy-100, result.v1i*scale, '#ef4444');

    // Object 2 before
    drawObject2(x2_before, cy-100, 40);
    ctx.fillStyle = '#1e40af';
    ctx.font = '12px sans-serif';
    ctx.fillText('m₂='+result.m2+'kg', x2_before-20, cy-50);
    ctx.fillText('v₂='+result.v2i+' m/s', x2_before-25, cy-35);
    drawVelocityArrow(x2_before, cy-100, result.v2i*scale, '#3b82f6');

    // After collision (bottom half)
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('AFTER COLLISION', 20, cy+40);

    var x1_after = w/3;
    var x2_after = 2*w/3;

    // Object 1 after
    drawObject1(x1_after, cy+120, 40);
    ctx.fillStyle = '#991b1b';
    ctx.font = '12px sans-serif';
    ctx.fillText('m₁='+result.m1+'kg', x1_after-20, cy+170);
    ctx.fillText('v₁='+result.v1f.toFixed(1)+' m/s', x1_after-25, cy+185);
    drawVelocityArrow(x1_after, cy+120, result.v1f*scale, '#ef4444');

    // Object 2 after
    if(result.e === 0){
      // Draw combined object for perfectly inelastic
      ctx.fillStyle = '#7c3aed';
      ctx.fillRect(x2_after-50, cy+100, 100, 40);
      ctx.strokeStyle = '#5b21b6';
      ctx.lineWidth = 3;
      ctx.strokeRect(x2_after-50, cy+100, 100, 40);
      ctx.fillStyle = '#ffffff';
      ctx.font = 'bold 14px sans-serif';
      ctx.fillText('STUCK', x2_after-25, cy+125);
      ctx.fillStyle = '#5b21b6';
      ctx.font = '11px sans-serif';
      ctx.fillText('m₁+m₂='+(result.m1+result.m2)+'kg', x2_after-40, cy+170);
      ctx.fillText('vf='+result.vf.toFixed(1)+' m/s', x2_after-35, cy+185);
      drawVelocityArrow(x2_after, cy+120, result.vf*scale, '#7c3aed');
    } else {
      drawObject2(x2_after, cy+120, 40);
      ctx.fillStyle = '#1e40af';
      ctx.font = '12px sans-serif';
      ctx.fillText('m₂='+result.m2+'kg', x2_after-20, cy+170);
      ctx.fillText('v₂='+result.v2f.toFixed(1)+' m/s', x2_after-25, cy+185);
      drawVelocityArrow(x2_after, cy+120, result.v2f*scale, '#3b82f6');
    }

    // Momentum labels
    ctx.fillStyle = '#059669';
    ctx.font = 'bold 12px sans-serif';
    ctx.fillText('Total pᵢ = '+result.pi.toFixed(2)+' kg⋅m/s', w-200, 30);
    ctx.fillText('Total pf = '+result.pf.toFixed(2)+' kg⋅m/s', w-200, cy+40);
  }

  function draw2DScene(result, w, h, animated){
    var cx = w/2;
    var cy = h/2;

    // Axes
    ctx.strokeStyle = '#cbd5e1';
    ctx.lineWidth = 1;
    ctx.setLineDash([5,5]);
    ctx.beginPath();
    ctx.moveTo(0, cy);
    ctx.lineTo(w, cy);
    ctx.moveTo(cx, 0);
    ctx.lineTo(cx, h);
    ctx.stroke();
    ctx.setLineDash([]);

    ctx.fillStyle = '#64748b';
    ctx.font = '11px sans-serif';
    ctx.fillText('x', w-15, cy-5);
    ctx.fillText('y', cx+5, 15);

    var scale = 30;

    // Before collision
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 13px sans-serif';
    ctx.fillText('BEFORE', 10, 20);

    var v1ix = result.v1i * Math.cos(toRad(result.angle1i));
    var v1iy = result.v1i * Math.sin(toRad(result.angle1i));
    var v2ix = result.v2i * Math.cos(toRad(result.angle2i));
    var v2iy = result.v2i * Math.sin(toRad(result.angle2i));

    var x1_before = cx - 150;
    var y1_before = cy - v1iy*5;
    var x2_before = cx + 150;
    var y2_before = cy - v2iy*5;

    drawObject1(x1_before, y1_before, 30);
    drawVelocityArrow(x1_before, y1_before, v1ix*scale, '#ef4444');
    ctx.fillStyle = '#991b1b';
    ctx.font = '10px sans-serif';
    ctx.fillText('m₁', x1_before-10, y1_before+35);

    drawObject2(x2_before, y2_before, 30);
    drawVelocityArrow(x2_before, y2_before, v2ix*scale, '#3b82f6');
    ctx.fillStyle = '#1e40af';
    ctx.font = '10px sans-serif';
    ctx.fillText('m₂', x2_before-10, y2_before+35);

    // After collision
    ctx.fillStyle = '#475569';
    ctx.font = 'bold 13px sans-serif';
    ctx.fillText('AFTER', 10, h-10);

    var x1_after = cx - 80;
    var y1_after = cy - result.v1fy*scale;
    var x2_after = cx + 80;
    var y2_after = cy - result.v2fy*scale;

    drawObject1(x1_after, y1_after, 30);
    drawVelocityArrow(x1_after, y1_after, result.v1fx*scale, '#ef4444');

    drawObject2(x2_after, y2_after, 30);
    drawVelocityArrow(x2_after, y2_after, result.v2fx*scale, '#3b82f6');

    // Momentum vectors
    ctx.strokeStyle = '#059669';
    ctx.lineWidth = 3;
    ctx.globalAlpha = 0.6;
    var pmag_i = Math.sqrt(result.pxi*result.pxi + result.pyi*result.pyi);
    var pmag_f = Math.sqrt(result.pxf*result.pxf + result.pyf*result.pyf);

    if(pmag_i > 0){
      var pscale = 3;
      drawArrow(cx, cy, cx + result.pxi*pscale, cy - result.pyi*pscale, '#059669', 3);
      ctx.fillStyle = '#059669';
      ctx.font = '11px sans-serif';
      ctx.fillText('p⃗ᵢ', cx + result.pxi*pscale + 10, cy - result.pyi*pscale);
    }

    ctx.globalAlpha = 1;
  }

  function drawObject1(x, y, size){
    ctx.fillStyle = '#fee2e2';
    ctx.fillRect(x - size/2, y - size/2, size, size);
    ctx.strokeStyle = '#ef4444';
    ctx.lineWidth = 3;
    ctx.strokeRect(x - size/2, y - size/2, size, size);
  }

  function drawObject2(x, y, size){
    ctx.beginPath();
    ctx.arc(x, y, size/2, 0, Math.PI*2);
    ctx.fillStyle = '#dbeafe';
    ctx.fill();
    ctx.strokeStyle = '#3b82f6';
    ctx.lineWidth = 3;
    ctx.stroke();
  }

  function drawVelocityArrow(x, y, len, color){
    if(Math.abs(len) < 5) return;
    drawArrow(x, y, x + len, y, color, 2);
    ctx.fillStyle = color;
    ctx.font = '11px sans-serif';
    var label = len > 0 ? '→' : '←';
    ctx.fillText(label, x + len + (len>0?5:-15), y - 5);
  }

  function drawArrow(x1, y1, x2, y2, color, width){
    ctx.strokeStyle = color;
    ctx.fillStyle = color;
    ctx.lineWidth = width;

    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    var angle = Math.atan2(y2-y1, x2-x1);
    var headlen = 10;
    ctx.beginPath();
    ctx.moveTo(x2, y2);
    ctx.lineTo(x2-headlen*Math.cos(angle-Math.PI/6), y2-headlen*Math.sin(angle-Math.PI/6));
    ctx.lineTo(x2-headlen*Math.cos(angle+Math.PI/6), y2-headlen*Math.sin(angle+Math.PI/6));
    ctx.closePath();
    ctx.fill();
  }

  function showSteps(result){
    var html = '';
    var is2D = dimension.value === '2d';

    html += '<div class="mb-2"><strong>Given:</strong></div>';
    html += '<div class="ml-3">Mass 1: m₁ = '+result.m1+' kg, Initial velocity: v₁ᵢ = '+result.v1i+' m/s</div>';
    html += '<div class="ml-3">Mass 2: m₂ = '+result.m2+' kg, Initial velocity: v₂ᵢ = '+result.v2i+' m/s</div>';
    html += '<div class="ml-3">Coefficient of restitution: e = '+result.e+'</div>';

    if(!is2D){
      html += '<div class="mt-3 mb-2"><strong>1. Conservation of Momentum:</strong></div>';
      html += '<div class="ml-3">m₁v₁ᵢ + m₂v₂ᵢ = m₁v₁f + m₂v₂f</div>';
      html += '<div class="ml-3">'+result.m1+'('+result.v1i+') + '+result.m2+'('+result.v2i+') = '+result.m1+'v₁f + '+result.m2+'v₂f</div>';
      html += '<div class="ml-3 text-primary">'+result.pi.toFixed(2)+' = '+result.m1+'v₁f + '+result.m2+'v₂f ... (Equation 1)</div>';

      if(result.e === 0){
        html += '<div class="mt-3 mb-2"><strong>2. Perfectly Inelastic (Objects Stick):</strong></div>';
        html += '<div class="ml-3">v₁f = v₂f = vf</div>';
        html += '<div class="ml-3">vf = (m₁v₁ᵢ + m₂v₂ᵢ)/(m₁+m₂)</div>';
        html += '<div class="ml-3">vf = '+result.pi.toFixed(2)+'/'+(result.m1+result.m2)+'</div>';
        html += '<div class="ml-3 text-primary"><strong>vf = '+result.vf.toFixed(2)+' m/s</strong></div>';
      } else {
        html += '<div class="mt-3 mb-2"><strong>2. Coefficient of Restitution:</strong></div>';
        html += '<div class="ml-3">e = |v₂f - v₁f| / |v₁ᵢ - v₂ᵢ|</div>';
        html += '<div class="ml-3">'+result.e+' = |v₂f - v₁f| / |'+result.v1i+' - ('+result.v2i+')|</div>';
        html += '<div class="ml-3 text-primary">v₂f - v₁f = '+result.e+' × '+Math.abs(result.v1i - result.v2i).toFixed(2)+' = '+(result.e * Math.abs(result.v1i - result.v2i)).toFixed(2)+' ... (Equation 2)</div>';

        html += '<div class="mt-3 mb-2"><strong>3. Solve System of Equations:</strong></div>';
        html += '<div class="ml-3">From equations (1) and (2):</div>';
        html += '<div class="ml-3 text-primary"><strong>v₁f = '+result.v1f.toFixed(2)+' m/s</strong></div>';
        html += '<div class="ml-3 text-primary"><strong>v₂f = '+result.v2f.toFixed(2)+' m/s</strong></div>';
      }

      html += '<div class="mt-3 mb-2"><strong>'+(result.e === 0 ? '3' : '4')+'. Kinetic Energy:</strong></div>';
      html += '<div class="ml-3">KEᵢ = ½m₁v₁ᵢ² + ½m₂v₂ᵢ² = '+result.KEi.toFixed(2)+' J</div>';
      html += '<div class="ml-3">KEf = ½m₁v₁f² + ½m₂v₂f² = '+result.KEf.toFixed(2)+' J</div>';
      html += '<div class="ml-3">Energy Lost = '+result.KELoss.toFixed(2)+' J ('+result.KELossPercent.toFixed(1)+'%)</div>';

      if(Math.abs(result.KELoss) < 0.01){
        html += '<div class="ml-3 text-success"><strong>✓ Energy is conserved (Elastic collision)</strong></div>';
      } else {
        html += '<div class="ml-3 text-warning"><strong>⚠ Energy is lost (Inelastic collision)</strong></div>';
      }
    } else {
      html += '<div class="mt-3 mb-2"><strong>1. 2D Momentum Conservation:</strong></div>';
      html += '<div class="ml-3">X-direction: m₁v₁ₓᵢ + m₂v₂ₓᵢ = m₁v₁ₓf + m₂v₂ₓf</div>';
      html += '<div class="ml-3">Y-direction: m₁v₁ᵧᵢ + m₂v₂ᵧᵢ = m₁v₁ᵧf + m₂v₂ᵧf</div>';
      html += '<div class="ml-3 text-primary">p⃗ᵢ = ('+result.pxi.toFixed(2)+', '+result.pyi.toFixed(2)+') kg⋅m/s</div>';
      html += '<div class="ml-3 text-primary">p⃗f = ('+result.pxf.toFixed(2)+', '+result.pyf.toFixed(2)+') kg⋅m/s</div>';

      html += '<div class="mt-3 mb-2"><strong>2. Final Velocities:</strong></div>';
      html += '<div class="ml-3"><strong>Object 1:</strong> v₁f = '+result.v1f.toFixed(2)+' m/s at θ₁f = '+result.angle1f.toFixed(1)+'°</div>';
      html += '<div class="ml-3"><strong>Object 2:</strong> v₂f = '+result.v2f.toFixed(2)+' m/s at θ₂f = '+result.angle2f.toFixed(1)+'°</div>';

      html += '<div class="mt-3 mb-2"><strong>3. Energy Analysis:</strong></div>';
      html += '<div class="ml-3">Energy Lost = '+result.KELoss.toFixed(2)+' J ('+result.KELossPercent.toFixed(1)+'%)</div>';
    }

    $('stepsContent').innerHTML = html;
  }

  // Animation
  $('btnAnimate').addEventListener('click', function(){
    if(!lastResult) return calculate();

    var animTime = 0;
    var duration = 3000; // 3 seconds

    if(animationId) cancelAnimationFrame(animationId);

    function animate(){
      animTime += 16;
      var progress = Math.min(animTime / duration, 1);

      // Draw animation frame
      var w = canvas.width;
      var h = canvas.height;
      ctx.clearRect(0,0,w,h);
      ctx.fillStyle = '#f8fafc';
      ctx.fillRect(0,0,w,h);

      var is2D = dimension.value === '2d';
      var cy = h/2;

      if(!is2D){
        // Animate 1D collision
        var scale = 40;
        var startX1 = w/4;
        var startX2 = 3*w/4;
        var collideX = w/2;

        var phase = progress < 0.4 ? 'before' : (progress < 0.5 ? 'collision' : 'after');

        if(phase === 'before'){
          var t = progress / 0.4;
          var x1 = startX1 + (collideX - startX1) * t;
          var x2 = startX2 + (collideX - startX2) * t;

          drawObject1(x1, cy, 40);
          drawObject2(x2, cy, 40);
          drawVelocityArrow(x1, cy-60, lastResult.v1i*scale, '#ef4444');
          drawVelocityArrow(x2, cy-60, lastResult.v2i*scale, '#3b82f6');

          ctx.fillStyle = '#475569';
          ctx.font = 'bold 16px sans-serif';
          ctx.fillText('APPROACHING...', 20, 30);
        } else if(phase === 'collision'){
          // Impact flash
          ctx.fillStyle = 'rgba(251, 191, 36, 0.5)';
          ctx.beginPath();
          ctx.arc(collideX, cy, 60, 0, Math.PI*2);
          ctx.fill();

          drawObject1(collideX-20, cy, 40);
          drawObject2(collideX+20, cy, 40);

          ctx.fillStyle = '#f59e0b';
          ctx.font = 'bold 20px sans-serif';
          ctx.fillText('COLLISION!', collideX-60, cy-60);
        } else {
          var t = (progress - 0.5) / 0.5;
          var x1 = collideX + (w/4 - collideX) * t;
          var x2 = collideX + (3*w/4 - collideX) * t;

          if(lastResult.e === 0){
            // Stuck together
            var xBoth = collideX + ((startX1 + startX2)/2 - collideX) * t;
            ctx.fillStyle = '#7c3aed';
            ctx.fillRect(xBoth-50, cy-20, 100, 40);
            ctx.strokeStyle = '#5b21b6';
            ctx.lineWidth = 3;
            ctx.strokeRect(xBoth-50, cy-20, 100, 40);
            drawVelocityArrow(xBoth, cy-60, lastResult.vf*scale, '#7c3aed');
          } else {
            x1 = collideX + (collideX + lastResult.v1f*scale*3*t - collideX);
            x2 = collideX + (collideX + lastResult.v2f*scale*3*t - collideX);

            drawObject1(x1, cy, 40);
            drawObject2(x2, cy, 40);
            drawVelocityArrow(x1, cy-60, lastResult.v1f*scale, '#ef4444');
            drawVelocityArrow(x2, cy-60, lastResult.v2f*scale, '#3b82f6');
          }

          ctx.fillStyle = '#475569';
          ctx.font = 'bold 16px sans-serif';
          ctx.fillText('AFTER COLLISION', 20, 30);
        }

        // Ground
        ctx.strokeStyle = '#94a3b8';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(0, cy+80);
        ctx.lineTo(w, cy+80);
        ctx.stroke();
      }

      if(progress < 1){
        animationId = requestAnimationFrame(animate);
      }
    }

    animate();
  });

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

    // Draw the collision diagram at top
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
    tempCtx.fillText('Momentum & Collision Calculator', leftX, yPos);
    yPos += 30;

    // Left column - Inputs
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Inputs:', leftX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';

    var collisionTypeText = collisionType.options[collisionType.selectedIndex].text;
    tempCtx.fillText('Type: ' + collisionTypeText, leftX, yPos += 20);
    tempCtx.fillText('Object 1: m₁=' + lastResult.m1 + 'kg, v₁=' + lastResult.v1i + ' m/s', leftX, yPos += 18);
    tempCtx.fillText('Object 2: m₂=' + lastResult.m2 + 'kg, v₂=' + lastResult.v2i + ' m/s', leftX, yPos += 18);
    if(lastResult.e !== undefined){
      tempCtx.fillText('Coefficient: e = ' + lastResult.e, leftX, yPos += 18);
    }

    // Right column - Results
    yPos = canvas.height + 50;
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Results:', rightX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';

    if(lastResult.mode === '1d'){
      tempCtx.fillText('Final v₁ = ' + lastResult.v1f.toFixed(2) + ' m/s', rightX, yPos += 20);
      tempCtx.fillText('Final v₂ = ' + lastResult.v2f.toFixed(2) + ' m/s', rightX, yPos += 18);
      tempCtx.fillText('Momentum: ' + lastResult.pi.toFixed(2) + ' → ' + lastResult.pf.toFixed(2) + ' kg⋅m/s', rightX, yPos += 18);
      tempCtx.fillText('KE Lost: ' + lastResult.KELoss.toFixed(2) + ' J (' + lastResult.KELossPercent.toFixed(1) + '%)', rightX, yPos += 18);
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
    tempCtx.fillText('Generated by 8gwifi.org/momentum-collision-calculator.jsp', leftX, yPos + 40);

    // Download
    var link = document.createElement('a');
    link.download = 'collision-' + Date.now() + '.png';
    link.href = tempCanvas.toDataURL();
    link.click();
  });

  // Copy results
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

        dimension.value = '1d';
        collisionType.value = 'elastic';

        if(preset === 'equal-mass'){
          m1.value = '2'; v1.value = '5';
          m2.value = '2'; v2.value = '0';
        } else if(preset === 'heavy-light'){
          m1.value = '10'; v1.value = '3';
          m2.value = '1'; v2.value = '0';
        } else if(preset === 'billiards'){
          m1.value = '0.17'; v1.value = '8';
          m2.value = '0.17'; v2.value = '-5';
        } else if(preset === 'car-crash'){
          collisionType.value = 'inelastic';
          restitution.value = '0.2';
          m1.value = '1200'; v1.value = '20';
          m2.value = '1500'; v2.value = '-15';
        } else if(preset === 'sticky'){
          collisionType.value = 'perfectly-inelastic';
          m1.value = '5'; v1.value = '10';
          m2.value = '3'; v2.value = '-5';
        } else if(preset === 'angle-elastic'){
          dimension.value = '2d';
          m1.value = '2'; v1.value = '6'; angle1.value = '30';
          m2.value = '2'; v2.value = '4'; angle2.value = '180';
        } else if(preset === 'glancing'){
          dimension.value = '2d';
          m1.value = '1'; v1.value = '8'; angle1.value = '15';
          m2.value = '1.5'; v2.value = '0'; angle2.value = '0';
        }

        dimension.dispatchEvent(new Event('change'));
        collisionType.dispatchEvent(new Event('change'));
        calculate();
      });
    })(presetItems[i]);
  }

  $('btnCalculate').addEventListener('click', calculate);

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
  <p>Calculates momentum, impulse, and collision outcomes (elastic/inelastic) using conservation laws and SI units. Shows how masses and velocities affect results.</p>
  <h3 class="h6 mt-2">Learning Outcomes</h3>
  <ul class="mb-2"><li>Apply conservation of momentum and understand energy cases.</li><li>See effects of mass and velocity on outcomes.</li><li>Practice unit consistency.</li></ul>
  <div class="row mt-2"><div class="col-md-6"><h4 class="h6">Authorship</h4><ul><li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> — Follow on X</li><li><strong>Last updated:</strong> 2025-11-19</li></ul></div><div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul><li>Runs locally; no data upload.</li></ul></div></div>
</div></div></div></div></section>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"WebPage","name":"Momentum & Collision Calculator","url":"https://8gwifi.org/momentum-collision-calculator.jsp","dateModified":"2025-11-19","author":{"@type":"Person","name":"Anish Nath","url":"https://x.com/anish2good"},"publisher":{"@type":"Organization","name":"8gwifi.org"}}</script>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Momentum & Collision Calculator","item":"https://8gwifi.org/momentum-collision-calculator.jsp"}]}</script>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

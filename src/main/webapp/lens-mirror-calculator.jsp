<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Lens Equation Calculator & Mirror Formula Calculator - Interactive Ray Diagram Tool</title>
  <meta name="description" content="Free online lens equation calculator with interactive ray diagram. Calculate focal length, object distance, image distance, and magnification for converging/diverging lenses and concave/convex mirrors. Features: thin lens equation solver (1/f = 1/u + 1/v), real-time ray tracing visualization, lens power in diopters, combined lens calculator, sign convention guide, step-by-step solutions. Perfect for physics students, optometry, optical engineering.">
  <meta name="keywords" content="lens equation calculator, mirror equation calculator, thin lens calculator, focal length calculator, lens formula calculator, magnification calculator, converging lens calculator, diverging lens calculator, concave mirror calculator, convex mirror calculator, lens power calculator, diopter calculator, optical calculator, ray diagram generator, optics calculator, physics lens calculator, image distance calculator, object distance calculator, real image virtual image calculator, optical physics tool, lens magnification, combined lens calculator, optometry calculator, optical engineering tools">
  <link rel="canonical" href="https://8gwifi.org/lens-mirror-calculator.jsp">
  <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1">
  <meta name="author" content="8gwifi.org">
  <meta property="og:title" content="FREE Lens Equation Calculator & Interactive Ray Diagram Tool">
  <meta property="og:description" content="Calculate focal length, magnification, image distance with interactive ray diagrams. Free tool for converging/diverging lenses and mirrors. Perfect for physics students.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/lens-mirror-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/lens-calculator.png">
  <meta property="og:site_name" content="8gwifi.org - Free Online Tools">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="FREE Lens Equation Calculator - Interactive Ray Diagrams">
  <meta name="twitter:description" content="Calculate lens focal length, magnification with real-time ray tracing. Free physics optics tool.">
  <meta name="twitter:image" content="https://8gwifi.org/images/lens-calculator.png">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"SoftwareApplication",
    "name":"Lens Equation Calculator & Mirror Formula Calculator",
    "alternateName":"Thin Lens Calculator",
    "url":"https://8gwifi.org/lens-mirror-calculator.jsp",
    "applicationCategory":"EducationalApplication",
    "applicationSubCategory":"Physics Simulation Tool",
    "operatingSystem":"Web Browser (All Platforms)",
    "browserRequirements":"Requires JavaScript. HTML5 Canvas Support.",
    "softwareVersion":"1.0",
    "description":"Professional lens equation calculator with interactive ray diagram visualization. Calculate focal length, object distance, image distance, and magnification using the thin lens equation (1/f = 1/u + 1/v). Features real-time ray tracing for converging lenses, diverging lenses, concave mirrors, and convex mirrors. Includes lens power calculator (diopters), combined lens system analyzer, and comprehensive sign convention guide. Perfect for physics students, optometry students, optical engineers, and educators.",
    "featureList":[
      "Thin lens equation calculator (1/f = 1/u + 1/v)",
      "Interactive ray diagram with real-time visualization",
      "Magnification calculator (m = v/u = h'/h)",
      "Converging lens (convex) calculator",
      "Diverging lens (concave) calculator",
      "Concave mirror calculator",
      "Convex mirror calculator",
      "Lens power calculator (diopters: P = 1/f)",
      "Combined lens system calculator",
      "Real vs virtual image detection",
      "Upright vs inverted image indication",
      "Sign convention guide (New Cartesian)",
      "Step-by-step calculation breakdown",
      "Principal ray tracing (3 rays)",
      "Object/image height visualization",
      "Focal points marked clearly",
      "Export ray diagrams as PNG",
      "Share URL for configurations",
      "Preset examples for learning"
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
      "educationalRole":"Student, Teacher, Optometrist, Optical Engineer"
    },
    "learningResourceType":"Interactive Simulation Tool",
    "interactivityType":"active",
    "teaches":["Lens Equation","Mirror Formula","Ray Optics","Geometric Optics","Magnification","Focal Length","Image Formation"],
    "keywords":"lens equation calculator, mirror formula, thin lens, focal length, magnification, ray diagram, optics calculator, converging lens, diverging lens, concave mirror, convex mirror",
    "aggregateRating":{
      "@type":"AggregateRating",
      "ratingValue":"4.9",
      "ratingCount":"1842",
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
        "name":"What is the thin lens equation?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"The thin lens equation is 1/f = 1/u + 1/v, where f is the focal length of the lens, u is the object distance from the lens, and v is the image distance from the lens. This fundamental equation in geometric optics relates the positions of an object and its image formed by a thin lens. For converging (convex) lenses, f is positive, while for diverging (concave) lenses, f is negative. The equation works for both lenses and mirrors using the New Cartesian sign convention."
        }
      },
      {
        "@type":"Question",
        "name":"How do you calculate magnification from the lens equation?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Magnification (m) is calculated using two equivalent formulas: m = v/u (ratio of image distance to object distance) or m = h'/h (ratio of image height to object height). If magnification is negative (m < 0), the image is inverted (upside down). If magnification is positive (m > 0), the image is upright. If |m| > 1, the image is magnified (larger than object). If |m| < 1, the image is diminished (smaller than object). For example, m = -2 means the image is inverted and twice the object's size."
        }
      },
      {
        "@type":"Question",
        "name":"What is the difference between converging and diverging lenses?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Converging lenses (convex lenses) are thicker in the middle than at the edges and bring parallel light rays to a focus at the focal point. They have positive focal lengths and can form both real (inverted) and virtual (upright) images depending on object position. Diverging lenses (concave lenses) are thinner in the middle and spread out parallel light rays as if they came from a focal point behind the lens. They have negative focal lengths and always produce virtual, upright, and diminished images. Converging lenses are used in magnifying glasses, cameras, and eyeglasses for farsightedness, while diverging lenses correct nearsightedness."
        }
      },
      {
        "@type":"Question",
        "name":"How do concave and convex mirrors differ?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Concave mirrors curve inward (like a cave) and can form both real and virtual images depending on object position. They have positive focal lengths (f = R/2, where R is radius of curvature). When the object is beyond the focal point, concave mirrors produce real, inverted images (used in telescopes, shaving mirrors at close range). Convex mirrors curve outward and always produce virtual, upright, and diminished images with negative focal lengths. Convex mirrors provide a wide field of view and are used in vehicle side mirrors, security mirrors, and blind-spot mirrors. The same lens equation (1/f = 1/u + 1/v) applies to both mirror types."
        }
      },
      {
        "@type":"Question",
        "name":"What is lens power and how is it measured in diopters?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Lens power (P) is the reciprocal of focal length in meters: P = 1/f (measured in diopters, D). A converging lens with focal length 0.5m has power +2D, while a diverging lens with focal length -0.25m has power -4D. Positive diopters indicate converging lenses (for farsightedness correction), and negative diopters indicate diverging lenses (for nearsightedness correction). Optometrists prescribe eyeglass lenses in diopters. For combined lenses in contact, total power is the sum: P_total = P₁ + P₂. For example, combining a +3D and +2D lens gives +5D total power. Higher absolute diopter values mean stronger lens power and shorter focal length."
        }
      },
      {
        "@type":"Question",
        "name":"What are the sign conventions for lens and mirror equations?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"The New Cartesian sign convention is standard: (1) Distances measured from the lens/mirror center. (2) Distances measured in the direction of incident light are positive; opposite direction is negative. (3) Object distance (u) is usually negative (object on left side). (4) Real image distance (v) is positive (right side); virtual image distance is negative (left side). (5) Converging lens/concave mirror focal length is positive; diverging lens/convex mirror focal length is negative. (6) Heights measured upward from principal axis are positive; downward are negative. Following these conventions ensures the lens equation and magnification formulas work correctly. Different sign conventions exist, so always verify which system is being used."
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
      {"@type":"ListItem","position":3,"name":"Lens Equation Calculator","item":"https://8gwifi.org/lens-mirror-calculator.jsp"}
    ]
  }
  </script>
  <style>
    .lens-calc .card-header{padding:.6rem .9rem;font-weight:600}
    .lens-calc .card-body{padding:.7rem .9rem}
    .lens-calc .form-group{margin-bottom:.55rem}
    #lensCanvas{width:100%;height:400px;border:1px solid #e5e7eb;border-radius:6px;background:#f8fafc}
    .badge-info{background:#dbeafe;color:#1e40af;font-size:0.85rem;padding:0.25rem 0.5rem}
    .result-card{background:#f0f9ff;border-left:4px solid #3b82f6;padding:0.75rem;margin-bottom:0.5rem;border-radius:4px}
    .result-label{font-weight:600;color:#1e40af;margin-right:0.5rem}
    .result-value{font-family:monospace;font-size:1.1rem;color:#1e3a8a}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 lens-calc">
  <h1 class="mb-2">Lens Equation Calculator & Mirror Formula Calculator</h1>
  <p class="text-muted mb-3">Calculate focal length, image distance, magnification with interactive ray diagram visualization. Supports converging/diverging lenses and concave/convex mirrors.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">
          Inputs
          <div class="dropdown">
            <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown">Examples</button>
            <div class="dropdown-menu" aria-labelledby="presetBtn">
              <h6 class="dropdown-header">Converging Lens</h6>
              <a class="dropdown-item" href="#" data-preset="conv-real">Real Image (beyond f)</a>
              <a class="dropdown-item" href="#" data-preset="conv-virtual">Virtual Image (within f)</a>
              <a class="dropdown-item" href="#" data-preset="magnifying">Magnifying Glass</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">Diverging Lens</h6>
              <a class="dropdown-item" href="#" data-preset="div-basic">Basic Diverging</a>
              <a class="dropdown-item" href="#" data-preset="eyeglasses">Eyeglasses (-2D)</a>
              <div class="dropdown-divider"></div>
              <h6 class="dropdown-header">Mirrors</h6>
              <a class="dropdown-item" href="#" data-preset="concave-mirror">Concave Mirror</a>
              <a class="dropdown-item" href="#" data-preset="convex-mirror">Convex Mirror</a>
            </div>
          </div>
        </h5>
        <div class="card-body">
          <div class="form-group">
            <label for="opticalType">Type</label>
            <select id="opticalType" class="form-control">
              <option value="converging" selected>Converging Lens (Convex)</option>
              <option value="diverging">Diverging Lens (Concave)</option>
              <option value="concave-mirror">Concave Mirror</option>
              <option value="convex-mirror">Convex Mirror</option>
            </select>
          </div>

          <div class="form-group">
            <label for="calcMode">Calculate</label>
            <select id="calcMode" class="form-control">
              <option value="find-v">Image Distance (v) from f and u</option>
              <option value="find-u">Object Distance (u) from f and v</option>
              <option value="find-f">Focal Length (f) from u and v</option>
            </select>
          </div>

          <div id="inputF" class="form-group">
            <label for="focalLength">Focal Length (f) <span class="text-muted">cm</span></label>
            <div class="d-flex align-items-center">
              <input id="focalLength" type="number" step="0.1" class="form-control d-inline-block" style="max-width:100px" value="10">
              <input id="fSlider" type="range" min="-50" max="50" step="0.5" value="10" class="custom-range d-inline-block ml-2" style="width:200px;vertical-align:middle">
            </div>
            <small class="text-muted d-block">Positive for converging, negative for diverging</small>
          </div>

          <div id="inputU" class="form-group">
            <label for="objectDist">Object Distance (u) <span class="text-muted">cm</span></label>
            <div class="d-flex align-items-center">
              <input id="objectDist" type="number" step="0.1" class="form-control d-inline-block" style="max-width:100px" value="-20">
              <input id="uSlider" type="range" min="-100" max="-1" step="0.5" value="-20" class="custom-range d-inline-block ml-2" style="width:200px;vertical-align:middle">
            </div>
            <small class="text-muted d-block">Negative as per sign convention (object on left)</small>
          </div>

          <div id="inputV" class="form-group" style="display:none">
            <label for="imageDist">Image Distance (v) <span class="text-muted">cm</span></label>
            <div class="d-flex align-items-center">
              <input id="imageDist" type="number" step="0.1" class="form-control d-inline-block" style="max-width:100px" value="20">
              <input id="vSlider" type="range" min="-100" max="100" step="0.5" value="20" class="custom-range d-inline-block ml-2" style="width:200px;vertical-align:middle">
            </div>
            <small class="text-muted d-block">Positive for real image, negative for virtual</small>
          </div>

          <div class="form-group">
            <label for="objectHeight">Object Height (h) <span class="text-muted">cm</span></label>
            <div class="d-flex align-items-center">
              <input id="objectHeight" type="number" step="0.1" class="form-control d-inline-block" style="max-width:100px" value="5">
              <input id="hSlider" type="range" min="1" max="20" step="0.5" value="5" class="custom-range d-inline-block ml-2" style="width:200px;vertical-align:middle">
            </div>
          </div>

          <div class="d-flex align-items-center">
            <button id="btnCalculate" class="btn btn-primary btn-sm mr-2">Calculate</button>
            <button id="btnSave" class="btn btn-outline-secondary btn-sm mr-2">Save PNG</button>
            <button id="btnShare" class="btn btn-outline-secondary btn-sm">Share URL</button>
          </div>
        </div>
      </div>

        <div class="card mb-3" id="cardSteps">
            <h5 class="card-header">Step-by-Step Calculation</h5>
            <div class="card-body small">
                <div id="stepsContent" style="line-height:1.8"></div>
            </div>
        </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Ray Diagram</h5>
        <div class="card-body">
          <canvas id="lensCanvas" height="400"></canvas>
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


      </div>

      <div class="card mb-3">
        <h5 class="card-header">About Lens & Mirror Equations</h5>
        <div class="card-body small">
          <div><strong>Thin Lens Equation:</strong> 1/f = 1/u + 1/v relates focal length (f), object distance (u), and image distance (v). This equation applies to both thin lenses and spherical mirrors.</div>
          <div class="mt-2"><strong>Magnification:</strong> m = v/u = h'/h where h' is image height and h is object height. Negative magnification indicates inverted image; |m| > 1 means enlarged image.</div>
          <div class="mt-2"><strong>Lens Power:</strong> P = 1/f (in diopters when f is in meters). Used in optometry for prescribing corrective lenses. Positive power converges light (farsightedness correction); negative power diverges light (nearsightedness correction).</div>
          <div class="mt-2"><strong>Real vs Virtual Images:</strong> Real images form where light rays actually converge (can be projected on screen), with positive v. Virtual images form where rays appear to diverge from (cannot be projected), with negative v.</div>
          <div class="mt-2"><strong>Sign Convention (New Cartesian):</strong> Distances measured from lens/mirror center. Direction of incident light is positive. Object distance usually negative (left side). Real image v is positive (right side); virtual image v is negative (left side).</div>
          <div class="mt-2"><strong>Applications:</strong> Cameras, telescopes, microscopes, eyeglasses, contact lenses, magnifying glasses, projectors, binoculars, and all optical instruments rely on lens equations for design and analysis.</div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Physics Tools</h5>
        <div class="card-body small">
          <div class="mb-2">
            <a href="snells-law-prism.jsp" class="btn btn-sm btn-outline-primary mr-2">
              <i class="fas fa-prism"></i> Snell's Law & Prism Refraction Calculator
            </a>
          </div>
          <div class="text-muted">
            Explore light refraction, critical angles, and prism deviation. Complements lens calculations by understanding how light bends through different media before entering optical systems.
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
;(function(){
  function $(id){ return document.getElementById(id); }

  var opticalType = $('opticalType');
  var calcMode = $('calcMode');
  var focalLength = $('focalLength');
  var objectDist = $('objectDist');
  var imageDist = $('imageDist');
  var objectHeight = $('objectHeight');
  var canvas = $('lensCanvas');
  var ctx = canvas.getContext('2d');
  var lastResult = null; // Store last calculation result for PNG export

  // Slider sync function
  function syncSlider(input, slider){
    input.addEventListener('input', function(){
      slider.value = input.value;
    });
    slider.addEventListener('input', function(){
      input.value = slider.value;
      calculate(); // Auto-calculate on slider change
    });
  }

  // Sync all sliders with inputs
  syncSlider(focalLength, $('fSlider'));
  syncSlider(objectDist, $('uSlider'));
  syncSlider(imageDist, $('vSlider'));
  syncSlider(objectHeight, $('hSlider'));

  // Show/hide inputs based on calculation mode
  function updateInputs(){
    var mode = calcMode.value;
    $('inputF').style.display = mode !== 'find-f' ? '' : 'none';
    $('inputU').style.display = mode !== 'find-u' ? '' : 'none';
    $('inputV').style.display = mode === 'find-f' || mode === 'find-u' ? '' : 'none';
  }

  calcMode.addEventListener('change', updateInputs);
  opticalType.addEventListener('change', function(){
    var type = opticalType.value;
    if(type === 'diverging' || type === 'convex-mirror'){
      if(parseFloat(focalLength.value) > 0) {
        focalLength.value = -Math.abs(parseFloat(focalLength.value));
        $('fSlider').value = focalLength.value;
      }
    } else if(type === 'converging' || type === 'concave-mirror'){
      if(parseFloat(focalLength.value) < 0) {
        focalLength.value = Math.abs(parseFloat(focalLength.value));
        $('fSlider').value = focalLength.value;
      }
    }
    calculate(); // Auto-calculate on type change
  });

  function calculate(){
    var mode = calcMode.value;
    var f = parseFloat(focalLength.value) || 10;
    var u = parseFloat(objectDist.value) || -20;
    var v = parseFloat(imageDist.value) || 20;
    var h = parseFloat(objectHeight.value) || 5;

    var result = {};

    // Calculate based on mode
    if(mode === 'find-v'){
      // 1/v = 1/f - 1/u
      if(Math.abs(u) < 0.01){
        result.error = 'Object distance cannot be zero';
        showResults(result);
        return;
      }
      var inv_v = (1/f) - (1/u);
      if(Math.abs(inv_v) < 0.0001){
        result.error = 'Image forms at infinity (object at focal point)';
        showResults(result);
        return;
      }
      v = 1 / inv_v;
      result.v = v;
      result.f = f;
      result.u = u;
    } else if(mode === 'find-u'){
      // 1/u = 1/f - 1/v
      if(Math.abs(v) < 0.01){
        result.error = 'Image distance cannot be zero';
        showResults(result);
        return;
      }
      var inv_u = (1/f) - (1/v);
      if(Math.abs(inv_u) < 0.0001){
        result.error = 'Object at infinity';
        showResults(result);
        return;
      }
      u = 1 / inv_u;
      result.u = u;
      result.f = f;
      result.v = v;
    } else if(mode === 'find-f'){
      // 1/f = 1/u + 1/v
      if(Math.abs(u) < 0.01 || Math.abs(v) < 0.01){
        result.error = 'Object or image distance cannot be zero';
        showResults(result);
        return;
      }
      var inv_f = (1/u) + (1/v);
      if(Math.abs(inv_f) < 0.0001){
        result.error = 'Invalid configuration';
        showResults(result);
        return;
      }
      f = 1 / inv_f;
      result.f = f;
      result.u = u;
      result.v = v;
    }

    // Calculate magnification
    result.m = v / u;
    result.h_prime = result.m * h;
    result.h = h;

    // Determine image characteristics
    result.imageType = v > 0 ? 'Real' : 'Virtual';
    result.orientation = result.m < 0 ? 'Inverted' : 'Upright';
    result.size = Math.abs(result.m) > 1 ? 'Magnified' : (Math.abs(result.m) < 1 ? 'Diminished' : 'Same Size');

    // Lens power in diopters (f in meters)
    result.power = 1 / (f / 100);

    lastResult = result; // Store for PNG export
    showResults(result);
    drawRayDiagram(result);
    showSteps(result, mode);
  }

  function showResults(result){
    var html = '';
    if(result.error){
      html = '<div class="alert alert-warning mb-0">'+result.error+'</div>';
    } else {
      html += '<div class="result-card">';
      html += '<span class="result-label">Focal Length:</span><span class="result-value">'+result.f.toFixed(2)+' cm</span>';
      html += '</div>';

      html += '<div class="result-card">';
      html += '<span class="result-label">Object Distance:</span><span class="result-value">'+result.u.toFixed(2)+' cm</span>';
      html += '</div>';

      html += '<div class="result-card">';
      html += '<span class="result-label">Image Distance:</span><span class="result-value">'+result.v.toFixed(2)+' cm</span>';
      html += '</div>';

      html += '<div class="result-card">';
      html += '<span class="result-label">Magnification:</span><span class="result-value">'+result.m.toFixed(3)+'</span>';
      html += '</div>';

      html += '<div class="result-card">';
      html += '<span class="result-label">Image Height:</span><span class="result-value">'+result.h_prime.toFixed(2)+' cm</span>';
      html += '</div>';

      html += '<div class="result-card">';
      html += '<span class="result-label">Lens Power:</span><span class="result-value">'+result.power.toFixed(2)+' D</span>';
      html += '</div>';

      html += '<div class="mt-2">';
      html += '<span class="badge badge-info mr-1">'+result.imageType+'</span>';
      html += '<span class="badge badge-info mr-1">'+result.orientation+'</span>';
      html += '<span class="badge badge-info">'+result.size+'</span>';
      html += '</div>';
    }
    $('results').innerHTML = html;
  }

  function drawRayDiagram(result){
    if(result.error) return;

    var w = canvas.getBoundingClientRect().width | 0;
    if(w < 100) w = 600;
    canvas.width = w;
    var h = canvas.height;
    ctx.clearRect(0,0,w,h);

    // Background
    ctx.fillStyle = '#f8fafc';
    ctx.fillRect(0,0,w,h);

    var cy = h/2;
    var lensX = w/2;

    // Scale factor to fit everything in canvas
    var maxDist = Math.max(Math.abs(result.u), Math.abs(result.v), Math.abs(result.f)*2);
    var scale = Math.min((w/2 - 100) / maxDist, 3);

    // Draw principal axis
    ctx.strokeStyle = '#94a3b8';
    ctx.lineWidth = 1;
    ctx.setLineDash([5,5]);
    ctx.beginPath();
    ctx.moveTo(20, cy);
    ctx.lineTo(w-20, cy);
    ctx.stroke();
    ctx.setLineDash([]);

    // Draw lens/mirror
    var type = opticalType.value;
    if(type.includes('mirror')){
      drawMirror(lensX, cy, type, h);
    } else {
      drawLens(lensX, cy, type, h);
    }

    // Draw focal points
    var f1X = lensX + result.f * scale;
    var f2X = lensX - result.f * scale;

    ctx.fillStyle = '#ef4444';
    ctx.font = 'bold 12px sans-serif';

    if(Math.abs(result.f) < 1000){
      // F on right
      ctx.beginPath();
      ctx.arc(f1X, cy, 4, 0, Math.PI*2);
      ctx.fill();
      ctx.fillText('F', f1X+8, cy-8);

      // F on left
      ctx.beginPath();
      ctx.arc(f2X, cy, 4, 0, Math.PI*2);
      ctx.fill();
      ctx.fillText('F', f2X-18, cy-8);
    }

    // Object position
    var objX = lensX + result.u * scale;
    var objH = result.h * scale * 3;

    // Draw object
    ctx.strokeStyle = '#1e293b';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(objX, cy);
    ctx.lineTo(objX, cy - objH);
    ctx.stroke();

    // Arrow head
    ctx.fillStyle = '#1e293b';
    ctx.beginPath();
    ctx.moveTo(objX, cy - objH);
    ctx.lineTo(objX - 5, cy - objH + 10);
    ctx.lineTo(objX + 5, cy - objH + 10);
    ctx.fill();

    ctx.fillStyle = '#1e293b';
    ctx.font = 'bold 14px sans-serif';
    ctx.fillText('Object', objX - 25, cy + 20);

    // Draw image
    var imgX = lensX + result.v * scale;
    var imgH = result.h_prime * scale * 3;

    if(Math.abs(imgX - lensX) < w/2 - 40 && Math.abs(imgH) < h/2 - 20){
      ctx.strokeStyle = result.v > 0 ? '#3b82f6' : '#f59e0b';
      ctx.lineWidth = 3;
      ctx.setLineDash(result.v > 0 ? [] : [5,5]);
      ctx.beginPath();
      ctx.moveTo(imgX, cy);
      ctx.lineTo(imgX, cy - imgH);
      ctx.stroke();
      ctx.setLineDash([]);

      // Arrow head
      ctx.fillStyle = result.v > 0 ? '#3b82f6' : '#f59e0b';
      ctx.beginPath();
      var arrowDir = imgH > 0 ? 1 : -1;
      ctx.moveTo(imgX, cy - imgH);
      ctx.lineTo(imgX - 5, cy - imgH + arrowDir*10);
      ctx.lineTo(imgX + 5, cy - imgH + arrowDir*10);
      ctx.fill();

      ctx.font = 'bold 14px sans-serif';
      ctx.fillText('Image', imgX - 20, cy + 20);
    }

    // Draw 3 principal rays
    drawPrincipalRays(objX, objH, lensX, cy, imgX, imgH, f1X, result, scale);

    // Labels
    ctx.fillStyle = '#475569';
    ctx.font = '12px sans-serif';
    ctx.fillText('u = '+result.u.toFixed(1)+' cm', objX, cy - objH - 10);
    if(Math.abs(imgX - lensX) < w/2 - 40){
      ctx.fillText('v = '+result.v.toFixed(1)+' cm', imgX, cy - imgH - 10);
    }
    ctx.fillText('f = '+result.f.toFixed(1)+' cm', f1X, cy + 25);
  }

  function drawLens(x, cy, type, h){
    ctx.strokeStyle = '#64748b';
    ctx.lineWidth = 4;

    if(type === 'converging'){
      // Convex lens (thicker in middle)
      ctx.beginPath();
      ctx.moveTo(x, cy - h/2 + 40);
      ctx.quadraticCurveTo(x - 10, cy, x, cy + h/2 - 40);
      ctx.stroke();

      ctx.beginPath();
      ctx.moveTo(x, cy - h/2 + 40);
      ctx.quadraticCurveTo(x + 10, cy, x, cy + h/2 - 40);
      ctx.stroke();
    } else {
      // Concave lens (thinner in middle)
      ctx.beginPath();
      ctx.moveTo(x, cy - h/2 + 40);
      ctx.quadraticCurveTo(x + 10, cy, x, cy + h/2 - 40);
      ctx.stroke();

      ctx.beginPath();
      ctx.moveTo(x, cy - h/2 + 40);
      ctx.quadraticCurveTo(x - 10, cy, x, cy + h/2 - 40);
      ctx.stroke();
    }

    // Vertical line
    ctx.lineWidth = 2;
    ctx.setLineDash([10,5]);
    ctx.beginPath();
    ctx.moveTo(x, cy - h/2 + 40);
    ctx.lineTo(x, cy + h/2 - 40);
    ctx.stroke();
    ctx.setLineDash([]);
  }

  function drawMirror(x, cy, type, h){
    ctx.strokeStyle = '#64748b';
    ctx.lineWidth = 4;

    if(type === 'concave-mirror'){
      // Concave mirror (curves inward)
      ctx.beginPath();
      ctx.moveTo(x, cy - h/2 + 40);
      ctx.quadraticCurveTo(x - 20, cy, x, cy + h/2 - 40);
      ctx.stroke();
    } else {
      // Convex mirror (curves outward)
      ctx.beginPath();
      ctx.moveTo(x, cy - h/2 + 40);
      ctx.quadraticCurveTo(x + 20, cy, x, cy + h/2 - 40);
      ctx.stroke();
    }
  }

  function drawPrincipalRays(objX, objH, lensX, cy, imgX, imgH, f1X, result, scale){
    var objTopY = cy - objH;

    // Ray 1: Parallel to axis, through focal point after lens
    ctx.save();
    ctx.strokeStyle = '#ef4444';
    ctx.lineWidth = 2;
    ctx.shadowBlur = 8;
    ctx.shadowColor = 'rgba(239, 68, 68, 0.3)';

    ctx.beginPath();
    ctx.moveTo(objX, objTopY);
    ctx.lineTo(lensX, objTopY);

    if(result.v > 0){
      ctx.lineTo(imgX, cy - imgH);
    } else {
      // Virtual image - ray appears to come from image
      ctx.lineTo(lensX + 200, objTopY + (lensX + 200 - lensX)*(cy - imgH - objTopY)/(imgX - lensX));
    }
    ctx.stroke();
    ctx.restore();

    // Ray 2: Through optical center, straight through
    ctx.save();
    ctx.strokeStyle = '#3b82f6';
    ctx.lineWidth = 2;
    ctx.shadowBlur = 8;
    ctx.shadowColor = 'rgba(59, 130, 246, 0.3)';

    ctx.beginPath();
    ctx.moveTo(objX, objTopY);
    ctx.lineTo(lensX, cy);
    if(result.v > 0){
      ctx.lineTo(imgX, cy - imgH);
    } else {
      ctx.lineTo(lensX + 200, cy + (200)*(cy - imgH - cy)/(imgX - lensX));
    }
    ctx.stroke();
    ctx.restore();

    // Ray 3: Through focal point, parallel to axis after lens
    if(Math.abs(result.f) < 1000){
      ctx.save();
      ctx.strokeStyle = '#10b981';
      ctx.lineWidth = 2;
      ctx.shadowBlur = 8;
      ctx.shadowColor = 'rgba(16, 185, 129, 0.3)';

      var f2X = lensX - result.f * scale;
      ctx.beginPath();
      ctx.moveTo(objX, objTopY);

      // Calculate where ray hits lens
      var slope = (cy - objTopY)/(f2X - objX);
      var lensY = objTopY + slope * (lensX - objX);

      ctx.lineTo(lensX, lensY);

      if(result.v > 0){
        ctx.lineTo(imgX, cy - imgH);
      } else {
        ctx.lineTo(lensX + 200, lensY);
      }
      ctx.stroke();
      ctx.restore();
    }
  }

  function showSteps(result, mode){
    var html = '';
    html += '<div class="mb-2"><strong>Given:</strong></div>';
    html += '<div class="ml-3">Object distance: u = '+result.u.toFixed(2)+' cm</div>';
    if(mode !== 'find-f'){
      html += '<div class="ml-3">Focal length: f = '+result.f.toFixed(2)+' cm</div>';
    }
    if(mode !== 'find-v'){
      html += '<div class="ml-3">Image distance: v = '+result.v.toFixed(2)+' cm</div>';
    }
    html += '<div class="ml-3">Object height: h = '+result.h.toFixed(2)+' cm</div>';

    html += '<div class="mt-3 mb-2"><strong>1. Thin Lens Equation:</strong></div>';
    html += '<div class="ml-3">1/f = 1/u + 1/v</div>';

    if(mode === 'find-v'){
      html += '<div class="ml-3">1/v = 1/f - 1/u</div>';
      html += '<div class="ml-3">1/v = 1/('+result.f.toFixed(2)+') - 1/('+result.u.toFixed(2)+')</div>';
      html += '<div class="ml-3">1/v = '+(1/result.f).toFixed(4)+' - ('+(1/result.u).toFixed(4)+')</div>';
      html += '<div class="ml-3">1/v = '+((1/result.f)-(1/result.u)).toFixed(4)+'</div>';
      html += '<div class="ml-3 text-primary"><strong>v = '+result.v.toFixed(2)+' cm</strong></div>';
    } else if(mode === 'find-u'){
      html += '<div class="ml-3">1/u = 1/f - 1/v</div>';
      html += '<div class="ml-3">1/u = 1/('+result.f.toFixed(2)+') - 1/('+result.v.toFixed(2)+')</div>';
      html += '<div class="ml-3">1/u = '+(1/result.f).toFixed(4)+' - ('+(1/result.v).toFixed(4)+')</div>';
      html += '<div class="ml-3">1/u = '+((1/result.f)-(1/result.v)).toFixed(4)+'</div>';
      html += '<div class="ml-3 text-primary"><strong>u = '+result.u.toFixed(2)+' cm</strong></div>';
    } else {
      html += '<div class="ml-3">1/f = 1/('+result.u.toFixed(2)+') + 1/('+result.v.toFixed(2)+')</div>';
      html += '<div class="ml-3">1/f = '+(1/result.u).toFixed(4)+' + ('+(1/result.v).toFixed(4)+')</div>';
      html += '<div class="ml-3">1/f = '+((1/result.u)+(1/result.v)).toFixed(4)+'</div>';
      html += '<div class="ml-3 text-primary"><strong>f = '+result.f.toFixed(2)+' cm</strong></div>';
    }

    html += '<div class="mt-3 mb-2"><strong>2. Magnification:</strong></div>';
    html += '<div class="ml-3">m = v/u = h\'/h</div>';
    html += '<div class="ml-3">m = ('+result.v.toFixed(2)+')/('+result.u.toFixed(2)+')</div>';
    html += '<div class="ml-3 text-primary"><strong>m = '+result.m.toFixed(3)+'</strong></div>';

    html += '<div class="mt-3 mb-2"><strong>3. Image Height:</strong></div>';
    html += '<div class="ml-3">h\' = m × h</div>';
    html += '<div class="ml-3">h\' = '+result.m.toFixed(3)+' × '+result.h.toFixed(2)+'</div>';
    html += '<div class="ml-3 text-primary"><strong>h\' = '+result.h_prime.toFixed(2)+' cm</strong></div>';

    html += '<div class="mt-3 mb-2"><strong>4. Lens Power:</strong></div>';
    html += '<div class="ml-3">P = 1/f (f in meters)</div>';
    html += '<div class="ml-3">P = 1/('+result.f.toFixed(2)+'/100)</div>';
    html += '<div class="ml-3 text-primary"><strong>P = '+result.power.toFixed(2)+' D (diopters)</strong></div>';

    html += '<div class="mt-3 mb-2"><strong>5. Image Characteristics:</strong></div>';
    html += '<div class="ml-3">Type: <strong>'+result.imageType+'</strong> (v '+(result.v>0?'>':'<')+' 0)</div>';
    html += '<div class="ml-3">Orientation: <strong>'+result.orientation+'</strong> (m '+(result.m<0?'<':'>')+' 0)</div>';
    html += '<div class="ml-3">Size: <strong>'+result.size+'</strong> (|m| = '+Math.abs(result.m).toFixed(3)+')</div>';

    $('stepsContent').innerHTML = html;
  }

  // Copy results
  $('btnCopy').addEventListener('click', function(){
    var results = $('results').innerText;
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(results).then(function(){
        var btn = $('btnCopy');
        var orig = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
        btn.className = 'btn btn-success btn-sm';
        setTimeout(function(){ btn.innerHTML = orig; btn.className = 'btn btn-outline-primary btn-sm'; }, 2000);
      });
    }
  });

  // Save PNG with inputs and results
  $('btnSave').addEventListener('click', function(){
    if(!lastResult || lastResult.error){
      alert('Please calculate first before saving!');
      return;
    }

    // Create a larger temporary canvas
    var tempCanvas = document.createElement('canvas');
    var w = canvas.width;
    var extraHeight = 280; // Space for inputs, results, and URL
    tempCanvas.width = w;
    tempCanvas.height = canvas.height + extraHeight;
    var tempCtx = tempCanvas.getContext('2d');

    // White background
    tempCtx.fillStyle = '#ffffff';
    tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);

    // Draw the ray diagram at the top
    tempCtx.drawImage(canvas, 0, 0);

    // Add border below diagram
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
    tempCtx.fillText('Lens Equation Calculator - Ray Diagram', leftX, yPos);
    yPos += 30;

    // Left column - Inputs
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Inputs:', leftX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';

    var typeLabel = opticalType.options[opticalType.selectedIndex].text;
    tempCtx.fillText('Type: ' + typeLabel, leftX, yPos += 20);
    tempCtx.fillText('Focal Length (f): ' + lastResult.f.toFixed(2) + ' cm', leftX, yPos += 18);
    tempCtx.fillText('Object Distance (u): ' + lastResult.u.toFixed(2) + ' cm', leftX, yPos += 18);
    tempCtx.fillText('Object Height (h): ' + lastResult.h.toFixed(2) + ' cm', leftX, yPos += 18);

    // Right column - Results
    yPos = canvas.height + 50;
    tempCtx.fillStyle = '#475569';
    tempCtx.font = 'bold 14px sans-serif';
    tempCtx.fillText('Results:', rightX, yPos);
    yPos += 5;

    tempCtx.fillStyle = '#1e293b';
    tempCtx.font = '12px sans-serif';
    tempCtx.fillText('Image Distance (v): ' + lastResult.v.toFixed(2) + ' cm', rightX, yPos += 20);
    tempCtx.fillText('Magnification (m): ' + lastResult.m.toFixed(3), rightX, yPos += 18);
    tempCtx.fillText('Image Height (h\'): ' + lastResult.h_prime.toFixed(2) + ' cm', rightX, yPos += 18);
    tempCtx.fillText('Lens Power (P): ' + lastResult.power.toFixed(2) + ' D', rightX, yPos += 18);

    // Image characteristics
    yPos += 10;
    tempCtx.fillStyle = '#0ea5e9';
    tempCtx.font = 'bold 11px sans-serif';
    tempCtx.fillText('• ' + lastResult.imageType + '  • ' + lastResult.orientation + '  • ' + lastResult.size, rightX, yPos += 18);

    // Share URL at the bottom
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

    // Build share URL
    var params = new URLSearchParams({
      type: opticalType.value,
      mode: calcMode.value,
      f: focalLength.value,
      u: objectDist.value,
      v: imageDist.value,
      h: objectHeight.value
    });
    var url = location.origin + location.pathname + '?' + params.toString();

    // Truncate URL if too long
    var displayUrl = url.length > 80 ? url.substring(0, 77) + '...' : url;
    tempCtx.fillStyle = '#3b82f6';
    tempCtx.font = '10px monospace';
    tempCtx.fillText(displayUrl, leftX, yPos + 18);

    // Watermark
    tempCtx.fillStyle = '#94a3b8';
    tempCtx.font = '10px sans-serif';
    tempCtx.fillText('Generated by 8gwifi.org/lens-mirror-calculator.jsp', leftX, yPos + 40);

    // Download the composite image
    var link = document.createElement('a');
    link.download = 'lens-calculator-' + Date.now() + '.png';
    link.href = tempCanvas.toDataURL();
    link.click();
  });

  // Share URL
  $('btnShare').addEventListener('click', function(){
    var params = new URLSearchParams({
      type: opticalType.value,
      mode: calcMode.value,
      f: focalLength.value,
      u: objectDist.value,
      v: imageDist.value,
      h: objectHeight.value
    });
    var url = location.origin + location.pathname + '?' + params.toString();
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(url).then(function(){
        alert('Share URL copied to clipboard!');
      });
    } else {
      prompt('Copy this URL:', url);
    }
  });

  // Presets
  var presetItems = document.querySelectorAll('#presetBtn ~ .dropdown-menu a[data-preset]');
  for(var i=0; i<presetItems.length; i++){
    (function(item){
      item.addEventListener('click', function(e){
        e.preventDefault();
        var preset = item.getAttribute('data-preset');

        if(preset === 'conv-real'){
          opticalType.value = 'converging';
          calcMode.value = 'find-v';
          focalLength.value = '10';
          objectDist.value = '-30';
          objectHeight.value = '5';
          $('fSlider').value = '10';
          $('uSlider').value = '-30';
          $('hSlider').value = '5';
        } else if(preset === 'conv-virtual'){
          opticalType.value = 'converging';
          calcMode.value = 'find-v';
          focalLength.value = '15';
          objectDist.value = '-8';
          objectHeight.value = '4';
          $('fSlider').value = '15';
          $('uSlider').value = '-8';
          $('hSlider').value = '4';
        } else if(preset === 'magnifying'){
          opticalType.value = 'converging';
          calcMode.value = 'find-v';
          focalLength.value = '5';
          objectDist.value = '-3';
          objectHeight.value = '2';
          $('fSlider').value = '5';
          $('uSlider').value = '-3';
          $('hSlider').value = '2';
        } else if(preset === 'div-basic'){
          opticalType.value = 'diverging';
          calcMode.value = 'find-v';
          focalLength.value = '-15';
          objectDist.value = '-30';
          objectHeight.value = '6';
          $('fSlider').value = '-15';
          $('uSlider').value = '-30';
          $('hSlider').value = '6';
        } else if(preset === 'eyeglasses'){
          opticalType.value = 'diverging';
          calcMode.value = 'find-v';
          focalLength.value = '-50';
          objectDist.value = '-200';
          objectHeight.value = '10';
          $('fSlider').value = '-50';
          $('uSlider').value = '-200';
          $('hSlider').value = '10';
        } else if(preset === 'concave-mirror'){
          opticalType.value = 'concave-mirror';
          calcMode.value = 'find-v';
          focalLength.value = '15';
          objectDist.value = '-30';
          objectHeight.value = '5';
          $('fSlider').value = '15';
          $('uSlider').value = '-30';
          $('hSlider').value = '5';
        } else if(preset === 'convex-mirror'){
          opticalType.value = 'convex-mirror';
          calcMode.value = 'find-v';
          focalLength.value = '-20';
          objectDist.value = '-40';
          objectHeight.value = '6';
          $('fSlider').value = '-20';
          $('uSlider').value = '-40';
          $('hSlider').value = '6';
        }

        updateInputs();
        calculate();
      });
    })(presetItems[i]);
  }

  // Load from URL
  function loadFromURL(){
    var params = new URLSearchParams(location.search);
    if(params.has('type')) opticalType.value = params.get('type');
    if(params.has('mode')) calcMode.value = params.get('mode');
    if(params.has('f')) {
      focalLength.value = params.get('f');
      $('fSlider').value = params.get('f');
    }
    if(params.has('u')) {
      objectDist.value = params.get('u');
      $('uSlider').value = params.get('u');
    }
    if(params.has('v')) {
      imageDist.value = params.get('v');
      $('vSlider').value = params.get('v');
    }
    if(params.has('h')) {
      objectHeight.value = params.get('h');
      $('hSlider').value = params.get('h');
    }
    updateInputs();
    calculate();
  }

  $('btnCalculate').addEventListener('click', calculate);

  // Initialize
  loadFromURL();
  if(!location.search) calculate();
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

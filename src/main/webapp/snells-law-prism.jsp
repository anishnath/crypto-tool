<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FREE Snell's Law Calculator & Prism Refraction Simulator Online - Interactive Light Refraction Tool</title>
  <meta name="description" content="Free online Snell's law calculator with interactive ray diagram simulator. Calculate refraction angles, critical angle, refractive index, and prism deviation instantly. Features: light bending visualization, total internal reflection (TIR), Fresnel equations, 10+ material presets (diamond, glass, water), RGB dispersion, step-by-step calculations. Perfect for physics students, educators, optical engineers. Export diagrams as PNG.">
  <meta name="keywords" content="snell's law calculator, light refraction calculator, refractive index calculator, prism calculator, critical angle calculator, total internal reflection calculator, TIR calculator, optics calculator online, physics calculator, optical physics tool, refraction simulator, light bending calculator, snell law formula, fresnel equations calculator, prism deviation calculator, ray diagram simulator, physics simulation tool, optics education, light physics calculator, refraction angle calculator, optical calculator, snells law online, free physics tools, optical ray tracing, refraction index tool, prism refraction, glass prism calculator, diamond refraction, fiber optics calculator, brewster angle calculator, optical engineering tools, physics homework help">
  <link rel="canonical" href="https://8gwifi.org/snells-law-prism.jsp">
  <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1">
  <meta name="author" content="8gwifi.org">
  <meta property="og:title" content="FREE Snell's Law Calculator & Prism Refraction Simulator - Interactive Physics Tool">
  <meta property="og:description" content="Calculate light refraction angles, critical angle, and prism deviation instantly. Free interactive simulator with ray diagrams, 10+ materials, RGB dispersion, and step-by-step calculations. Perfect for students and educators.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/snells-law-prism.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/snells-law-calculator.png">
  <meta property="og:site_name" content="8gwifi.org - Free Online Tools">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="FREE Snell's Law Calculator & Prism Refraction Simulator">
  <meta name="twitter:description" content="Interactive light refraction calculator with ray diagrams. Calculate critical angles, TIR, prism deviation. Free tool for physics students.">
  <meta name="twitter:image" content="https://8gwifi.org/images/snells-law-calculator.png">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"SoftwareApplication",
    "name":"Snell's Law Calculator & Prism Refraction Simulator",
    "alternateName":"Light Refraction Calculator",
    "url":"https://8gwifi.org/snells-law-prism.jsp",
    "applicationCategory":"EducationalApplication",
    "applicationSubCategory":"Physics Simulation Tool",
    "operatingSystem":"Web Browser (All Platforms)",
    "browserRequirements":"Requires JavaScript. HTML5 Canvas Support.",
    "softwareVersion":"2.0",
    "description":"Professional-grade Snell's law calculator with interactive ray diagram visualization. Calculate light refraction angles, critical angles, refractive indices, and prism deviation with step-by-step solutions. Features advanced optics simulation including total internal reflection (TIR), Fresnel equations, RGB chromatic dispersion, and Brewster angle calculations. Includes 10+ material presets (air, water, glass, diamond, ice, ethanol, acrylic, benzene, crown glass, flint glass) and custom refractive index input. Perfect for physics students, educators, optical engineers, and researchers.",
    "featureList":[
      "Interactive ray diagram with real-time visualization",
      "Snell's law refraction angle calculator",
      "Critical angle and TIR detection",
      "Prism refraction with deviation calculation",
      "Fresnel reflectance and Brewster angle",
      "RGB chromatic dispersion simulation",
      "10+ material presets (diamond, glass, water, ice, etc.)",
      "Step-by-step calculation breakdown",
      "Interactive sliders for angle adjustment",
      "Input validation with helpful messages",
      "Copy results to clipboard",
      "Export diagrams as PNG images",
      "Share URL for saved configurations",
      "Semi-transparent prism visualization",
      "Ray glow effects for clarity",
      "Background media shading",
      "Always-visible reflected ray with Fresnel intensity"
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
    "creator":{
      "@type":"Organization",
      "name":"8gwifi.org",
      "url":"https://8gwifi.org"
    },
    "inLanguage":"en-US",
    "isAccessibleForFree":true,
    "educationalUse":["Learning","Teaching","Research","Homework","Self Study"],
    "educationalLevel":["High School","Undergraduate","Graduate","Professional"],
    "audience":{
      "@type":"EducationalAudience",
      "educationalRole":"Student, Teacher, Researcher, Engineer"
    },
    "learningResourceType":"Interactive Tool",
    "interactivityType":"active",
    "teaches":["Snell's Law","Light Refraction","Critical Angle","Total Internal Reflection","Prism Optics","Fresnel Equations","Optical Physics"],
    "keywords":"snell's law calculator, light refraction calculator, refractive index calculator, prism calculator, critical angle calculator, total internal reflection, TIR, optics calculator, physics simulation, optical physics, refraction simulator, light bending, fresnel equations, prism deviation, ray diagram, physics tool, optics education, brewster angle, fiber optics, optical engineering",
    "aggregateRating":{
      "@type":"AggregateRating",
      "ratingValue":"4.8",
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
        "name":"What is Snell's law and how does it work?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Snell's law is a fundamental principle in optics that describes how light bends (refracts) when passing between two media with different refractive indices. The mathematical formula is n₁·sin(θ₁) = n₂·sin(θ₂), where n₁ and n₂ are the refractive indices of the two media, and θ₁ and θ₂ are the angles of incidence and refraction measured from the normal (perpendicular line) to the interface. This law explains why objects appear bent when partially submerged in water, why lenses focus light, and how fiber optic cables guide light signals. When light travels from air (n≈1.0003) into water (n≈1.333) at 30° incidence, it bends toward the normal to approximately 22.1°."
        }
      },
      {
        "@type":"Question",
        "name":"What is the critical angle and total internal reflection (TIR)?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"The critical angle is the angle of incidence at which light traveling from a denser medium (higher refractive index) to a less dense medium (lower refractive index) refracts at exactly 90° along the interface. It is calculated using the formula θc = arcsin(n₂/n₁) where n₁ > n₂. Beyond this critical angle, total internal reflection (TIR) occurs - all light is reflected back into the denser medium with 100% efficiency and no light escapes. For example, the critical angle for water-to-air is approximately 48.6°. This phenomenon is crucial for fiber optic communications, where light signals bounce along optical fibers without loss, and explains why underwater swimmers see a mirror-like surface when looking up at steep angles (Snell's window)."
        }
      },
      {
        "@type":"Question",
        "name":"How does a prism refract and deviate light?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"A prism refracts light twice - once at the entry face and once at the exit face. For a triangular prism with apex angle A and refractive index n in air, the internal refraction angles r₁ and r₂ are constrained by the relationship r₁ + r₂ = A. The deviation angle δ, which measures how much the light ray is bent from its original direction, is calculated using δ = i₁ + i₂ - A, where i₁ is the incident angle and i₂ is the emergent angle. At minimum deviation (when the ray path inside is parallel to the base), r₁ = r₂ = A/2. Different wavelengths (colors) refract by different amounts (dispersion), causing white light to split into a spectrum - this is why rainbows form and why diamond prisms (n≈2.417) create spectacular rainbow effects with deviation angles exceeding 50°."
        }
      },
      {
        "@type":"Question",
        "name":"What are the real-world applications of Snell's law?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Snell's law has countless practical applications in modern technology and everyday life. In telecommunications, fiber optic cables use total internal reflection to transmit data at light speed over thousands of kilometers without signal loss. Eyeglasses and contact lenses use precisely calculated refraction to correct vision by bending light rays to focus properly on the retina. Camera lenses, microscopes, and telescopes employ multiple refracting elements designed using Snell's law to magnify, focus, and correct optical aberrations. In nature, atmospheric refraction causes mirages on hot roads, the flattened appearance of the sun at sunset, and the twinkling of stars. Medical endoscopes use flexible fiber optic bundles to see inside the body. Prisms are used in binoculars, periscopes, spectrometers for chemical analysis, and laser beam steering systems. Even the sparkle of diamonds is engineered using refraction and total internal reflection principles."
        }
      },
      {
        "@type":"Question",
        "name":"How do you calculate refractive index using Snell's law?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"To calculate refractive index using Snell's law (n₁·sin(θ₁) = n₂·sin(θ₂)), you need to measure the incident and refracted angles when light passes between two media. If you know one refractive index (like air, n≈1.0003), you can solve for the unknown: n₂ = n₁·sin(θ₁)/sin(θ₂). For example, if light enters a material from air at 30° and refracts to 22°, then n₂ = 1.0003·sin(30°)/sin(22°) ≈ 1.33, indicating the material is likely water. This calculator provides instant results for any angle and material combination, including 10+ preset materials from air (n=1.0003) to diamond (n=2.417), plus custom refractive index input for specialized materials and wavelength-dependent calculations."
        }
      },
      {
        "@type":"Question",
        "name":"What is the Fresnel equation and Brewster angle?",
        "acceptedAnswer":{
          "@type":"Answer",
          "text":"Fresnel equations describe how much light is reflected versus transmitted at an interface between two media, going beyond Snell's law which only predicts the refraction angle. The equations differ for s-polarized (perpendicular) and p-polarized (parallel) light. The Brewster angle (θB = arctan(n₂/n₁)) is the special incident angle at which p-polarized light experiences zero reflection and 100% transmission. For air-to-glass (n=1.5), the Brewster angle is approximately 56.3°. This principle is used in polarizing filters, anti-reflection coatings, laser optics, and photography polarizer filters. At the Brewster angle, reflected light is completely s-polarized, which is why photographers use polarizing filters to reduce glare from water and glass surfaces."
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
      {
        "@type":"ListItem",
        "position":1,
        "name":"Home",
        "item":"https://8gwifi.org/"
      },
      {
        "@type":"ListItem",
        "position":2,
        "name":"Physics Tools",
        "item":"https://8gwifi.org/physics-tools.jsp"
      },
      {
        "@type":"ListItem",
        "position":3,
        "name":"Snell's Law Calculator",
        "item":"https://8gwifi.org/snells-law-prism.jsp"
      }
    ]
  }
  </script>
  <style>
    .sn .card-header{padding:.6rem .9rem;font-weight:600}
    .sn .card-body{padding:.7rem .9rem}
    .sn .form-group{margin-bottom:.55rem}
    #snellCanvas{width:100%;height:320px;border:1px solid #e5e7eb;border-radius:6px;background:#fff}
    .badge-note{background:#eff6ff;color:#1d4ed8}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 sn">
  <h1 class="mb-2">Snell’s Law & Prism Refraction</h1>
  <p class="text-muted mb-3">Compute refraction angles, critical angle, and prism deviation. Visualize rays with an interactive diagram.</p>
  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3"><h5 class="card-header d-flex justify-content-between align-items-center">Inputs
        <div class="dropdown"><button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown">Presets</button>
          <div class="dropdown-menu" aria-labelledby="presetBtn" style="max-height:400px;overflow-y:auto">
            <h6 class="dropdown-header">Interface Mode</h6>
            <a class="dropdown-item" href="#" data-preset="air-glass">Air → Glass (basic refraction)</a>
            <a class="dropdown-item" href="#" data-preset="water-air">Water → Air (TIR demo)</a>
            <a class="dropdown-item" href="#" data-preset="diamond-critical">Diamond → Air (critical angle)</a>
            <a class="dropdown-item" href="#" data-preset="underwater-vision">Underwater Vision (Snell's window)</a>
            <a class="dropdown-item" href="#" data-preset="fiber-optic">Fiber Optic TIR</a>
            <a class="dropdown-item" href="#" data-preset="ice-water">Ice → Water interface</a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Prism Mode</h6>
            <a class="dropdown-item" href="#" data-preset="prism-standard">Standard Prism (n=1.50, A=60°)</a>
            <a class="dropdown-item" href="#" data-preset="diamond-prism">💎 Diamond Prism Spectacular</a>
            <a class="dropdown-item" href="#" data-preset="rainbow-prism">🌈 Rainbow Prism (RGB)</a>
            <a class="dropdown-item" href="#" data-preset="min-deviation">Minimum Deviation (symmetric)</a>
            <a class="dropdown-item" href="#" data-preset="ice-halo">Ice Crystal (atmospheric halo)</a>
            <a class="dropdown-item" href="#" data-preset="near-tir">Near-TIR Exit (Flint glass)</a>
            <a class="dropdown-item" href="#" data-preset="grazing">Grazing Incidence (85°)</a>
          </div></div>
      </h5><div class="card-body">
        <div class="form-group form-inline"><label class="mr-2 mb-0" for="mode">Mode</label>
          <select id="mode" class="form-control" style="max-width:240px">
            <option value="interface" selected>Interface (Snell)</option>
            <option value="prism">Prism</option>
            <option value="fresnel">Fresnel/Brewster</option>
          </select>
        </div>
        <div id="grpIF">
          <div class="form-group form-inline"><label class="mr-2 mb-0">Medium 1</label>
            <select id="m1" class="form-control mr-2" style="max-width:160px">
              <option value="1.0003" selected>Air (1.0003)</option>
              <option value="1.31">Ice (1.31)</option>
              <option value="1.333">Water (1.333)</option>
              <option value="1.36">Ethanol (1.36)</option>
              <option value="1.49">Acrylic (1.49)</option>
              <option value="1.5">Glass (1.50)</option>
              <option value="1.501">Benzene (1.501)</option>
              <option value="1.52">Crown Glass (1.52)</option>
              <option value="1.65">Flint Glass (1.65)</option>
              <option value="2.417">Diamond (2.417)</option>
              <option value="custom1">Custom</option>
            </select>
            <input id="n1" type="number" step="0.0001" min="1" max="3" class="form-control" style="max-width:120px" value="1.0003">
          </div>
          <div class="form-group form-inline"><label class="mr-2 mb-0">Medium 2</label>
            <select id="m2" class="form-control mr-2" style="max-width:160px">
              <option value="1.0003">Air (1.0003)</option>
              <option value="1.31">Ice (1.31)</option>
              <option value="1.333" selected>Water (1.333)</option>
              <option value="1.36">Ethanol (1.36)</option>
              <option value="1.49">Acrylic (1.49)</option>
              <option value="1.5">Glass (1.50)</option>
              <option value="1.501">Benzene (1.501)</option>
              <option value="1.52">Crown Glass (1.52)</option>
              <option value="1.65">Flint Glass (1.65)</option>
              <option value="2.417">Diamond (2.417)</option>
              <option value="custom2">Custom</option>
            </select>
            <input id="n2" type="number" step="0.0001" min="1" max="3" class="form-control" style="max-width:120px" value="1.333">
          </div>
          <div class="form-group"><label class="mr-2 mb-1 d-block" for="i1">Incident θ₁ (deg)</label>
            <input id="i1" type="number" step="0.1" min="0" max="90" class="form-control d-inline-block" style="max-width:100px" value="30">
            <input id="i1Slider" type="range" min="0" max="90" step="0.5" value="30" class="custom-range d-inline-block ml-2" style="width:200px;vertical-align:middle">
            <small class="text-muted d-block" id="i1Msg"></small>
          </div>
        </div>
        <div id="grpPR" style="display:none">
          <div class="form-group"><label class="mr-2 mb-1 d-block" for="np">Prism n <span class="text-muted">(outside is air)</span></label>
            <input id="np" type="number" step="0.0001" min="1" max="3" class="form-control d-inline-block" style="max-width:100px" value="1.5">
            <input id="npSlider" type="range" min="1" max="2.5" step="0.01" value="1.5" class="custom-range d-inline-block ml-2" style="width:200px;vertical-align:middle">
            <small class="text-muted d-block" id="npMsg"></small>
          </div>
          <div class="form-group"><label class="mr-2 mb-1 d-block" for="A">Apex A (deg)</label>
            <input id="A" type="number" step="0.1" min="10" max="120" class="form-control d-inline-block" style="max-width:100px" value="60">
            <input id="ASlider" type="range" min="10" max="120" step="1" value="60" class="custom-range d-inline-block ml-2" style="width:200px;vertical-align:middle">
            <small class="text-muted d-block" id="AMsg"></small>
          </div>
          <div class="form-group"><label class="mr-2 mb-1 d-block" for="ip">Incidence i₁ (deg)</label>
            <input id="ip" type="number" step="0.1" min="0" max="90" class="form-control d-inline-block" style="max-width:100px" value="30">
            <input id="ipSlider" type="range" min="0" max="90" step="0.5" value="30" class="custom-range d-inline-block ml-2" style="width:200px;vertical-align:middle">
            <small class="text-muted d-block" id="ipMsg"></small>
          </div>
          <div class="form-group form-inline"><label class="mr-2 mb-0" for="disp">Dispersion</label>
            <select id="disp" class="form-control mr-2" style="max-width:140px"><option value="off" selected>Off</option><option value="rgb">RGB</option></select>
            <select id="mat" class="form-control" style="max-width:160px">
              <option value="custom" selected>Custom (use n)</option>
              <option value="bk7">BK7 (approx)</option>
              <option value="f2">F2 (approx)</option>
              <option value="silica">Fused Silica (approx)</option>
            </select>
          </div>
        </div>
        <div id="grpFR" style="display:none">
          <div class="form-group form-inline"><label class="mr-2 mb-0">Medium 1</label>
            <select id="fm1" class="form-control mr-2" style="max-width:160px">
              <option value="1.0003" selected>Air (1.0003)</option>
              <option value="1.333">Water (1.333)</option>
              <option value="1.5">Glass (1.50)</option>
              <option value="custom">Custom</option>
            </select>
            <input id="fn1" type="number" step="0.0001" class="form-control" style="max-width:120px" value="1.0003">
          </div>
          <div class="form-group form-inline"><label class="mr-2 mb-0">Medium 2</label>
            <select id="fm2" class="form-control mr-2" style="max-width:160px">
              <option value="1.0003">Air (1.0003)</option>
              <option value="1.333" selected>Water (1.333)</option>
              <option value="1.5">Glass (1.50)</option>
              <option value="custom">Custom</option>
            </select>
            <input id="fn2" type="number" step="0.0001" class="form-control" style="max-width:120px" value="1.333">
          </div>
          <div class="form-group form-inline"><label class="mr-2 mb-0">Brewster θ<sub>B</sub> (p‑pol)</label>
            <span id="brew" class="text-monospace">—</span>
          </div>
        </div>
        <div class="d-flex align-items-center"><button id="btnRun" class="btn btn-primary btn-sm mr-2">Run</button><button id="btnSave" class="btn btn-outline-secondary btn-sm mr-2">Save PNG</button><button id="btnShare" class="btn btn-outline-secondary btn-sm">Share URL</button></div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header d-flex justify-content-between align-items-center">Results
        <button id="btnCopy" class="btn btn-outline-primary btn-sm" title="Copy results to clipboard"><i class="fas fa-copy"></i> Copy</button>
      </h5><div class="card-body small">
        <div id="resIF">θ₂ = <span id="t2">–</span>°, θ<sub>c</sub> = <span id="tc">–</span>° <span class="text-muted" id="tirNote"></span></div>
        <div id="resPR" style="display:none">Internal r₁ = <span id="r1">–</span>°, r₂ = <span id="r2">–</span>°, Emergent i₂ = <span id="i2">–</span>°, Deviation δ = <span id="dev">–</span>° <span class="text-muted" id="tirNoteP"></span></div>
      </div></div>
      <div class="card mb-3" id="cardSteps"><h5 class="card-header">Step-by-Step Calculation</h5><div class="card-body small">
        <div id="stepsContent" class="text-monospace" style="line-height:1.8">
          <div class="text-muted">Click "Run" to see calculations...</div>
        </div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">Notes</h5><div class="card-body small text-muted">
        <div><span class="badge badge-note">Snell</span> n₁·sinθ₁ = n₂·sinθ₂; critical angle θc = arcsin(n₂/n₁) for n₁>n₂.</div>
        <div class="mt-1"><span class="badge badge-note">Prism</span> r₁ + r₂ = A; n·sin r₂ = sin i₂ (air outside). Deviation δ ≈ i₁ + i₂ − A.</div>
      </div></div>
    </div>
    <div class="col-lg-8">
      <div class="card mb-3" id="cardRay"><h5 class="card-header">Ray Diagram</h5><div class="card-body">
        <canvas id="snellCanvas" height="320"></canvas>
        <div id="rgbLegend" class="small text-muted mt-1" style="display:none"></div>
      </div></div>
      <div class="card mb-3" id="cardFresnel" style="display:none"><h5 class="card-header">Fresnel Reflectance (Rs/Rp vs θ)</h5><div class="card-body">
        <canvas id="fresnelCanvas" height="260"></canvas>
        <small class="text-muted d-block mt-1">Rs (s‑pol) and Rp (p‑pol) reflectance vs incidence; Brewster angle where Rp→0 if n₂&gt;n₁.</small>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">About Snell’s Law</h5><div class="card-body small">
        <div><strong>Definition:</strong> Snell’s law states that n₁·sin(θ₁) = n₂·sin(θ₂), where n is the refractive index and θ is the angle from the normal. It describes how waves bend at an interface between media.</div>
        <div class="mt-1"><strong>Physical meaning:</strong> The component of wavevector parallel to the interface is conserved; the speed changes from v=c/n, so the direction must adjust to satisfy boundary conditions.</div>
        <div class="mt-1"><strong>Critical angle & TIR:</strong> For light moving from higher to lower n (n₁>n₂), the transmitted angle increases until sinθ₂=1 at θ_c=arcsin(n₂/n₁). Beyond θ_c, transmission is not possible and the wave undergoes total internal reflection.</div>
        <div class="mt-1"><strong>Applications:</strong> Lenses (imaging), fiber optics (TIR guidance), atmospheric mirages (gradient index), prisms (deviation/dispersion), and AR optics.</div>
        <div class="mt-1"><strong>Prism deviation:</strong> A prism bends light twice. For apex A and internal angles r₁,r₂ with r₁+r₂=A, the emergent angle i₂ in air satisfies sin i₂ = n·sin r₂. The external deviation is δ ≈ i₁ + i₂ − A, minimized near the symmetric condition r₁=r₂=A/2.</div>
        <div class="mt-1 text-muted">Note: This tool assumes monochromatic light (single n). Dispersion (n(λ)) splits colors; a simple model could assign slightly different n for red/green/blue to visualize spread.</div>
      </div></div>
    </div>
  </div>
</div>
<script>
;(function(){
  function $(id){ return document.getElementById(id); }
  var mode=$('mode');
  var m1=$('m1'), m2=$('m2'), n1=$('n1'), n2=$('n2'), i1=$('i1');
  var np=$('np'), A=$('A'), ip=$('ip'); var disp=$('disp'), mat=$('mat');
  var grpIF=$('grpIF'), grpPR=$('grpPR');
  var t2=$('t2'), tc=$('tc'), tirNote=$('tirNote');
  var r1o=$('r1'), r2o=$('r2'), i2o=$('i2'), devo=$('dev'), tirNoteP=$('tirNoteP');
  var ctx=$('snellCanvas').getContext('2d');
  var fm1=$('fm1'), fm2=$('fm2'), fn1=$('fn1'), fn2=$('fn2'), brew=$('brew');
  var fresCtx = null, fresChart = null;

  function showGroups(){
    var md=mode.value;
    grpIF.style.display = (md==='interface')? '' : 'none';
    grpPR.style.display = (md==='prism')? '' : 'none';
    $('resIF').style.display = (md==='interface')? '' : 'none';
    $('resPR').style.display = (md==='prism')? '' : 'none';
    var showFres = (md==='fresnel');
    var fr = $('grpFR'); if(fr) fr.style.display = showFres? '' : 'none';
    var cardRay=$('cardRay'); if(cardRay) cardRay.style.display = showFres? 'none' : '';
    var cardF=$('cardFresnel'); if(cardF) cardF.style.display = showFres? '' : 'none';
    var lg=$('rgbLegend'); if(lg && md!=='prism'){ lg.style.display='none'; }
  }

  function pickN(sel, input){
    var v = sel.value;
    if(v.indexOf('custom')===0){ input.disabled=false; return parseFloat(input.value)||1; }
    input.disabled=true; return parseFloat(v)||1;
  }

  function toRad(d){ return d*Math.PI/180; }
  function toDeg(r){ return r*180/Math.PI; }

  function run(){
    showGroups();
    var md=mode.value;
    if(md==='interface') return runInterface();
    if(md==='prism') return runPrism();
    return runFresnel();
  }

  function runInterface(){
    var nn1=pickN(m1,n1), nn2=pickN(m2,n2), th1=parseFloat(i1.value)||0;
    var s1=Math.sin(toRad(th1));
    var tir=false, th2=NaN, thc=NaN;
    if(nn1>nn2){
      var x=nn2/nn1; if(x<=1) thc = toDeg(Math.asin(Math.max(0,Math.min(1,x))));
      tir = (nn1*s1>nn2);
    }
    if(!tir){ var s2=(nn1/nn2)*s1; if(Math.abs(s2)<=1) th2=toDeg(Math.asin(s2)); }
    if(tir){ t2.textContent = 'N/A'; tirNote.textContent = ' (TIR: no transmitted ray)'; }
    else { t2.textContent = isFinite(th2)? th2.toFixed(2): '—'; tirNote.textContent=''; }
    tc.textContent = isFinite(thc)? thc.toFixed(2): (nn1>nn2? '—':'N/A');
    drawInterface(nn1,nn2,th1,th2,tir);
    showSteps('interface', {n1:nn1, n2:nn2, th1:th1});
  }

  function runPrism(){
    // Ensure canvas is properly initialized
    var canvas=$('snellCanvas');
    var canvasRect = canvas.getBoundingClientRect();
    if(canvasRect.width > 0) {
      canvas.width = canvasRect.width|0;
    }
    var Adeg=parseFloat(A.value)||60; var i1deg=parseFloat(ip.value)||30; var dmode=disp.value; var material=mat.value;
    function sellmeierN(name, lam){ // lam in um; returns n
      var B,C;
      if(name==='bk7'){ B=[1.03961212,0.231792344,1.01046945]; C=[0.00600069867,0.0200179144,103.560653]; }
      else if(name==='f2'){ B=[1.34533359,0.209073176,0.937357162]; C=[0.00997743871,0.0470450767,111.886764]; }
      else if(name==='silica'){ B=[0.6961663,0.4079426,0.8974794]; var c1=0.0684043*0.0684043, c2=0.1162414*0.1162414, c3=9.896161*9.896161; C=[c1,c2,c3]; }
      else return null;
      var lam2=lam*lam; var n2=1 + (B[0]*lam2)/(lam2 - C[0]) + (B[1]*lam2)/(lam2 - C[1]) + (B[2]*lam2)/(lam2 - C[2]);
      return Math.sqrt(n2);
    }
    if(dmode==='rgb' && material!=='custom'){
      var lambdas=[0.650,0.550,0.450]; var names=['Red','Green','Blue']; var cols=['#ef4444','#22c55e','#0ea5e9'];
      var canvas=$('snellCanvas'); var w=canvas.width = canvas.getBoundingClientRect().width|0; var h=canvas.height; ctx.clearRect(0,0,w,h);
      // Draw prism outline with median n
      var nmid=sellmeierN(material, 0.550)||parseFloat(np.value)||1.5; drawPrism(nmid,Adeg,i1deg);
      // compute results from median n
      var res = computePrism(nmid,Adeg,i1deg);
      r1o.textContent = isFinite(res.r1)? res.r1.toFixed(2): (res.tirType==='entry'?'N/A':'—');
      r2o.textContent = isFinite(res.r2)? res.r2.toFixed(2): (res.tirType==='entry'?'N/A':'—');
      i2o.textContent = isFinite(res.i2)? res.i2.toFixed(2): (res.tirType==='exit'?'N/A':'—');
      devo.textContent = isFinite(res.dev)? res.dev.toFixed(2): (res.tirType?'N/A':'—');
      tirNoteP.textContent = res.tir? (res.tirType==='entry'?' (TIR at entry face)':' (TIR at exit face)') : '';
      showSteps('prism', {n:nmid, A:Adeg, i1:i1deg});
      // Overlay colored rays by redrawing rays only: reuse drawPrism to draw full; acceptable visually
      for(var j=0;j<lambdas.length;j++){ var ncol=sellmeierN(material, lambdas[j]); if(ncol){ drawPrism(ncol,Adeg,i1deg); } }
      // Legend
      var lg=$('rgbLegend'); if(lg){ lg.style.display=''; lg.textContent = names.map(function(nm,idx){ return nm+' ~ '+Math.round(lambdas[idx]*1000)+' nm'; }).join('  •  '); }
      return;
    }
    var n = parseFloat(np.value)||1.5;
    drawPrism(n,Adeg,i1deg);
    var lg=$('rgbLegend'); if(lg){ lg.style.display='none'; lg.textContent=''; }
    var res2 = computePrism(n,Adeg,i1deg);
    r1o.textContent = isFinite(res2.r1)? res2.r1.toFixed(2): (res2.tirType==='entry'?'N/A':'—');
    r2o.textContent = isFinite(res2.r2)? res2.r2.toFixed(2): (res2.tirType==='entry'?'N/A':'—');
    i2o.textContent = isFinite(res2.i2)? res2.i2.toFixed(2): (res2.tirType==='exit'?'N/A':'—');
    devo.textContent = isFinite(res2.dev)? res2.dev.toFixed(2): (res2.tirType?'N/A':'—');
    tirNoteP.textContent = res2.tir? (res2.tirType==='entry'?' (TIR at entry face)':' (TIR at exit face)') : '';
    showSteps('prism', {n:n, A:Adeg, i1:i1deg});
  }

  function runFresnel(){
    // pick indices
    var n_1 = (fm1.value==='custom')? (parseFloat(fn1.value)||1) : (parseFloat(fm1.value)||1);
    var n_2 = (fm2.value==='custom')? (parseFloat(fn2.value)||1) : (parseFloat(fm2.value)||1);
    // Brewster angle for p‑pol if n2>n1: tan θB = n2/n1
    var brewDeg = (n_2>n_1)? (toDeg(Math.atan(n_2/n_1))) : NaN;
    brew.textContent = isFinite(brewDeg)? brewDeg.toFixed(2)+'°' : '—';
    var canvas=$('fresnelCanvas'); if(!fresCtx) fresCtx = canvas.getContext('2d');
    // build data
    var thetas=[], Rs=[], Rp=[]; for(var th=0.5; th<89.5; th+=0.5){
      var thRad=toRad(th); var s1=Math.sin(thRad);
      var s2=(n_1/n_2)*s1; var RsVal=1, RpVal=1;
      if(Math.abs(s2)<=1){
        var c1=Math.cos(thRad); var t2=Math.asin(s2); var c2=Math.cos(t2);
        var rs=(n_1*c1 - n_2*c2)/(n_1*c1 + n_2*c2);
        var rp=(n_2*c1 - n_1*c2)/(n_2*c1 + n_1*c2);
        RsVal = rs*rs; RpVal = rp*rp;
      } else {
        RsVal = 1; RpVal = 1; // TIR
      }
      thetas.push(th); Rs.push({x:th,y:RsVal}); Rp.push({x:th,y:RpVal});
    }
    if(fresChart){ fresChart.destroy(); fresChart=null; }
    fresChart = new Chart(fresCtx, {
      type: 'line',
      data: {
        datasets: [
          { label: 'Rs (s-pol)', data: Rs, borderColor: '#ef4444', pointRadius: 0 },
          { label: 'Rp (p-pol)', data: Rp, borderColor: '#0ea5e9', pointRadius: 0 }
        ]
      },
      options: {
        responsive: true,
        parsing: true,
        scales: {
          x: { type: 'linear', title: { display: true, text: 'Incidence θ (deg)' } },
          y: { min: 0, max: 1, title: { display: true, text: 'Reflectance' } }
        },
        plugins: { legend: { display: true } }
      }
    });
  }

  function drawInterface(nin, nout, th1deg, th2deg, tir){
    var w=$('snellCanvas').width = $('snellCanvas').getBoundingClientRect().width|0;
    var h=$('snellCanvas').height;
    ctx.clearRect(0,0,w,h);
    var cx=Math.floor(w/2), cy=Math.floor(h/2);
    // Calculate adaptive ray length to fit within canvas
    var margin=60; var maxLen = Math.min(w/2 - margin, h/2 - margin, 180);
    var len = Math.max(80, maxLen);

    // 3. Media background colors - draw background regions
    ctx.fillStyle = 'rgba(186, 230, 253, 0.12)'; // light cyan for medium 1
    ctx.fillRect(0, 0, w, cy);
    ctx.fillStyle = 'rgba(254, 240, 138, 0.12)'; // light yellow for medium 2
    ctx.fillRect(0, cy, w, h-cy);

    // interface line
    ctx.strokeStyle='#94a3b8'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(10,cy); ctx.lineTo(w-10,cy); ctx.stroke();
    // normal
    ctx.lineWidth=1; ctx.setLineDash([4,4]); ctx.beginPath(); ctx.moveTo(cx,20); ctx.lineTo(cx,h-20); ctx.stroke(); ctx.setLineDash([]);

    // incident ray (from above-left)
    var iang = -toRad(th1deg); // angle from normal into upper medium
    var ix1=cx - Math.sin(iang)*len, iy1=cy - Math.cos(iang)*len;

    // 4. Ray glow/shadow effects for incident ray
    ctx.save();
    ctx.shadowBlur = 8;
    ctx.shadowColor = 'rgba(17, 24, 39, 0.4)';
    ctx.strokeStyle='#111827'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(ix1,iy1); ctx.lineTo(cx,cy); ctx.stroke();
    ctx.restore();

    // Draw incident angle arc with value
    var incidentAngle = th1deg;
    drawAngleArcWithValue(cx, cy, {x:0,y:-1}, incidentAngle, 'θ₁', '#111827', 22);

    // 5. Always show reflected ray (with Fresnel calculation)
    var rang = toRad(th1deg);
    var rr2 = {x: cx - Math.sin(rang)*len, y: cy + Math.cos(rang)*len};
    // Calculate Fresnel reflectance for intensity
    var cosi = Math.cos(toRad(th1deg));
    var Rs = 1; // default full reflection
    if(!tir && isFinite(th2deg)){
      var cost = Math.cos(toRad(th2deg));
      var rs = (nin*cosi - nout*cost)/(nin*cosi + nout*cost);
      Rs = rs*rs;
    }
    // Draw reflected ray with appropriate opacity
    ctx.save();
    ctx.globalAlpha = tir? 1.0 : Math.max(0.3, Rs); // at least 30% visible
    ctx.shadowBlur = 8;
    ctx.shadowColor = 'rgba(239, 68, 68, 0.4)';
    ctx.lineWidth=2; ctx.setLineDash(tir? [5,4] : [3,3]); ctx.strokeStyle='#ef4444';
    ctx.beginPath(); ctx.moveTo(cx,cy); ctx.lineTo(rr2.x,rr2.y); ctx.stroke(); ctx.setLineDash([]);
    ctx.restore();

    // refracted ray
    if(!tir && isFinite(th2deg)){
      var tang = toRad(th2deg);
      var rx2 = cx + Math.sin(tang)*len, ry2 = cy + Math.cos(tang)*len;

      // 4. Ray glow for refracted ray
      ctx.save();
      ctx.shadowBlur = 10;
      ctx.shadowColor = 'rgba(14, 165, 233, 0.5)';
      ctx.strokeStyle='#0ea5e9'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(cx,cy); ctx.lineTo(rx2,ry2); ctx.stroke();
      ctx.restore();

      // Draw refracted angle arc with value
      drawAngleArcWithValue(cx, cy, {x:0,y:1}, th2deg, 'θ₂', '#0ea5e9', 22);
    }

    // labels
    ctx.fillStyle='#1e293b'; ctx.font='bold 16px sans-serif'; ctx.fillText('n₁='+nin.toFixed(4), 14, cy-6); ctx.fillText('n₂='+nout.toFixed(4), 14, cy+14);
  }

  function drawPrism(n,Adeg,i1deg){
    var canvas=$('snellCanvas');
    var w = canvas.getBoundingClientRect().width|0;
    if(w < 100) w = 600; // fallback if canvas not rendered yet
    canvas.width = w;
    var h=canvas.height;
    if(h < 100) h = 320; // fallback
    ctx.clearRect(0,0,w,h);

    // 3. Media background color - light background for air
    ctx.fillStyle = 'rgba(224, 242, 254, 0.08)'; // very light blue for air
    ctx.fillRect(0, 0, w, h);

    // Build prism geometry from apex angle Adeg with adaptive sizing
    var cx=Math.floor(w/2), cy=Math.floor(h/2);
    var phi=toRad(Adeg/2);
    // Calculate adaptive prism size to fit canvas
    var margin = 80;
    var maxH = Math.min(h/2 - margin, w/(4*Math.sin(phi)) - margin/2, 100);
    var H = Math.max(50, maxH); // height from center to apex
    var apex={x:cx, y:cy-H};
    // compute base points where lines at ±phi from vertical hit base y=cy+H
    var t=(2*H)/Math.cos(phi);
    var left={x:cx - Math.sin(phi)*t, y:cy+H};
    var right={x:cx + Math.sin(phi)*t, y:cy+H};

    // 1. Draw prism with semi-transparent fill
    ctx.beginPath();
    ctx.moveTo(apex.x,apex.y);
    ctx.lineTo(left.x,left.y);
    ctx.lineTo(right.x,right.y);
    ctx.closePath();
    // Fill with semi-transparent color
    ctx.fillStyle='rgba(147, 197, 253, 0.15)'; // light blue with 15% opacity
    ctx.fill();
    // Stroke outline
    ctx.strokeStyle='#64748b'; ctx.lineWidth=2;
    ctx.stroke();
    // apex angle label 'A'
    drawApexArc(apex, left, right, Adeg);
    // Face tangents and outward normals
    function normOut(P,Q){ var tvec=normalize({x:Q.x-P.x,y:Q.y-P.y}); var n={x:-tvec.y,y:tvec.x}; var mid={x:(P.x+Q.x)/2,y:(P.y+Q.y)/2}; var cent={x:(apex.x+left.x+right.x)/3,y:(apex.y+left.y+right.y)/3}; var vIn={x:cent.x-mid.x,y:cent.y-mid.y}; if(dot(n,vIn)>0) n={x:-n.x,y:-n.y}; return {t:tvec,n:n,mid:mid}; }
    var f1=normOut(apex,left); var f2=normOut(apex,right);
    // incident direction from i1 relative to outward normal of face1
    var n_out=f1.n; var nrmAngle=Math.atan2(n_out.y,n_out.x);
    // choose sign so ray comes from left
    var din1=fromAngle(nrmAngle + Math.PI - toRad(i1deg));
    if(din1.x>0){ din1=fromAngle(nrmAngle + Math.PI + toRad(i1deg)); }
    // start point far from face1 along -din (use adaptive but reasonable length)
    var rayLen = Math.max(Math.min(w, h) * 0.5, 150);
    var start={x:f1.mid.x - din1.x*rayLen, y:f1.mid.y - din1.y*rayLen};
    // intersect with face1 segment
    var hit1 = intersectRaySeg(start,din1, apex,left);
    if(!hit1){ // fallback
      hit1 = {x:f1.mid.x, y:f1.mid.y, t:rayLen};
    }
    // refract into prism
    var air=1.0003;
    // Validate inputs before refraction
    if(!isFinite(din1.x) || !isFinite(din1.y) || !isFinite(n_out.x) || !isFinite(n_out.y)) {
      console.error('Invalid ray or normal direction');
      return;
    }
    var tdir = refract(din1, n_out, air, n);
    // 4. draw incident ray with glow
    ctx.save();
    ctx.shadowBlur = 8;
    ctx.shadowColor = 'rgba(17, 24, 39, 0.4)';
    ctx.strokeStyle='#111827'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(start.x,start.y); ctx.lineTo(hit1.x,hit1.y); ctx.stroke();
    ctx.restore();
    // annotate i1 at entry with value
    var i1AngleRad = Math.abs(angleBetween(reflect(din1,{x:-f1.n.x,y:-f1.n.y}), f1.n));
    drawAngleArcWithValue(hit1.x, hit1.y, f1.n, toDeg(i1AngleRad), 'i₁', '#111827', 22);
    // draw normal at entry face
    drawNormal(hit1, f1.n, 'n₁');
    if(!tdir){ // TIR on entry (rare from air)
      ctx.save();
      ctx.shadowBlur = 8;
      ctx.shadowColor = 'rgba(239, 68, 68, 0.4)';
      ctx.lineWidth=2; ctx.setLineDash([5,4]); ctx.strokeStyle='#ef4444'; ctx.beginPath(); ctx.moveTo(hit1.x,hit1.y); ctx.lineTo(hit1.x + reflect(din1,n_out).x*rayLen*0.7, hit1.y + reflect(din1,n_out).y*rayLen*0.7); ctx.stroke(); ctx.setLineDash([]);
      ctx.restore();
      return;
    }
    // propagate to face2
    var hit2 = intersectRaySeg(hit1, tdir, apex,right);
    if(!hit2){ // draw until outside with glow
      ctx.save();
      ctx.shadowBlur = 10;
      ctx.shadowColor = 'rgba(14, 165, 233, 0.5)';
      ctx.strokeStyle='#0ea5e9'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(hit1.x,hit1.y); ctx.lineTo(hit1.x + tdir.x*rayLen, hit1.y + tdir.y*rayLen); ctx.stroke();
      ctx.restore();
      return;
    }
    // inside segment with glow
    ctx.save();
    ctx.shadowBlur = 10;
    ctx.shadowColor = 'rgba(14, 165, 233, 0.5)';
    ctx.strokeStyle='#0ea5e9'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(hit1.x,hit1.y); ctx.lineTo(hit2.x,hit2.y); ctx.stroke();
    ctx.restore();
    // annotate r1 inside with value
    var r1AngleRad = Math.abs(angleBetween(tdir, {x:-f1.n.x,y:-f1.n.y}));
    drawAngleArcWithValue(hit1.x, hit1.y, {x:-f1.n.x,y:-f1.n.y}, toDeg(r1AngleRad), 'r₁', '#0ea5e9', 20);
    // exit refraction
    var tout = refract(tdir, f2.n, n, air);
    if(!tout){ // TIR on exit with glow
      ctx.save();
      ctx.shadowBlur = 8;
      ctx.shadowColor = 'rgba(239, 68, 68, 0.4)';
      ctx.lineWidth=2; ctx.setLineDash([5,4]); ctx.strokeStyle='#ef4444'; ctx.beginPath(); ctx.moveTo(hit2.x,hit2.y); ctx.lineTo(hit2.x + reflect(tdir,f2.n).x*rayLen, hit2.y + reflect(tdir,f2.n).y*rayLen); ctx.stroke(); ctx.setLineDash([]);
      ctx.restore();
    } else {
      ctx.save();
      ctx.shadowBlur = 10;
      ctx.shadowColor = 'rgba(14, 165, 233, 0.5)';
      ctx.strokeStyle='#0ea5e9'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(hit2.x,hit2.y); ctx.lineTo(hit2.x + tout.x*rayLen, hit2.y + tout.y*rayLen); ctx.stroke();
      ctx.restore();
      // annotate r2 inside and i2 exit with values
      var r2AngleRad = Math.abs(angleBetween(tdir, {x:-f2.n.x,y:-f2.n.y}));
      drawAngleArcWithValue(hit2.x, hit2.y, {x:-f2.n.x,y:-f2.n.y}, toDeg(r2AngleRad), 'r₂', '#0ea5e9', 20);
      var i2AngleRad = Math.abs(angleBetween(tout, f2.n));
      drawAngleArcWithValue(hit2.x, hit2.y, f2.n, toDeg(i2AngleRad), 'i₂', '#111827', 22);
      // draw normal at exit face
      drawNormal(hit2, f2.n, 'n₂');
    }
    ctx.fillStyle='#1e293b'; ctx.font='bold 16px sans-serif'; ctx.fillText('n='+(Array.isArray(n)? n.join('/') : n.toFixed? n.toFixed(3): n), apex.x+6, apex.y+14);
  }

  function fromAngle(a){ return {x:Math.cos(a), y:Math.sin(a)}; }
  function dot(a,b){ return a.x*b.x + a.y*b.y; }
  function normalize(v){ var m=Math.hypot(v.x,v.y)||1; return {x:v.x/m,y:v.y/m}; }
  function angleBetween(v, n){ var vv=normalize(v), nn=normalize(n); var c = Math.max(-1, Math.min(1, dot(vv,nn))); return Math.acos(c); }
  function reflect(v,n){ // reflect v about normal n (n unit)
    var d=dot(v,n); return {x: v.x - 2*d*n.x, y: v.y - 2*d*n.y};
  }
  function refract(v, n, n1, n2){ // v incident unit, n surface normal pointing from medium2 to medium1, n1->n2
    v=normalize(v); n=normalize(n);
    var cosi = Math.max(-1, Math.min(1, -dot(n, v)));
    var etai=n1, etat=n2; var nn=n;
    if(cosi<0){ cosi=-cosi; var tmp=etai; etai=etat; etat=tmp; nn={x:-n.x,y:-n.y}; }
    var eta = etai/etat; var k = 1 - eta*eta*(1 - cosi*cosi);
    if(k<0) return null; // TIR
    var a = eta; var b = (eta*cosi - Math.sqrt(k));
    return normalize({x: a*v.x + b*nn.x, y: a*v.y + b*nn.y});
  }
  function intersectRaySeg(S, v, A, B){ v=normalize(v); var w={x:B.x-A.x,y:B.y-A.y}; var denom = v.x*(-w.y) + v.y*(w.x); if(Math.abs(denom)<1e-9) return null; var diff={x:A.x-S.x,y:A.y-S.y}; var t = (diff.x*(-w.y) + diff.y*(w.x)) / denom; var u = (diff.x*v.y - diff.y*v.x) / denom; if(t<0 || u<0 || u>1) return null; return {x:S.x + v.x*t, y:S.y + v.y*t, t:t, u:u}; }

  function drawAngleArc(P, normal, angRad, label, color){
    if(!isFinite(angRad)) return;
    var r=20; var nAng=Math.atan2(normal.y, normal.x);
    var start=nAng - angRad; var end=nAng;
    ctx.save();
    ctx.strokeStyle = color || '#111827'; ctx.lineWidth = 1.5; ctx.beginPath();
    ctx.arc(P.x, P.y, r, start, end, false);
    ctx.stroke();
    ctx.fillStyle = '#1e293b'; ctx.font='bold 15px sans-serif';
    var tx=P.x + (r+14)*Math.cos((start+end)/2); var ty=P.y + (r+14)*Math.sin((start+end)/2);
    ctx.fillText(label, tx, ty);
    ctx.restore();
  }

  // 2. Helper function to draw angle arc with value display
  function drawAngleArcWithValue(x, y, normal, angleDeg, label, color, radius){
    if(!isFinite(angleDeg)) return;
    var r = radius || 22;
    var angRad = toRad(angleDeg);
    var nAng = Math.atan2(normal.y, normal.x);
    var start = nAng - angRad;
    var end = nAng;
    ctx.save();
    ctx.strokeStyle = color || '#111827';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.arc(x, y, r, start, end, false);
    ctx.stroke();
    // Draw label with angle value
    ctx.fillStyle = '#1e293b';
    ctx.font = 'bold 14px sans-serif';
    var midAngle = (start + end) / 2;
    var tx = x + (r + 16) * Math.cos(midAngle);
    var ty = y + (r + 16) * Math.sin(midAngle);
    var text = label + '=' + angleDeg.toFixed(1) + '°';
    ctx.fillText(text, tx, ty);
    ctx.restore();
  }

  function drawApexArc(apex, left, right, Adeg){
    // Draw a small arc at the apex to indicate prism apex angle A
    var v1 = normalize({x:left.x - apex.x, y:left.y - apex.y});
    var v2 = normalize({x:right.x - apex.x, y:right.y - apex.y});
    var a1 = Math.atan2(v1.y, v1.x);
    var a2 = Math.atan2(v2.y, v2.x);
    // Ensure we take the smaller interior angle between the two faces
    var diff = a2 - a1; while(diff > Math.PI) diff -= 2*Math.PI; while(diff < -Math.PI) diff += 2*Math.PI;
    var start = a1, end = a1 + diff;
    // Make arc radius small
    var r = 22; ctx.save(); ctx.strokeStyle = '#64748b'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.arc(apex.x, apex.y, r, start, end, diff<0); ctx.stroke();
    // Label 'A' with value near arc midpoint
    var mid = (start + end)/2; var tx = apex.x + (r+14)*Math.cos(mid); var ty = apex.y + (r+14)*Math.sin(mid);
    ctx.fillStyle='#1e293b'; ctx.font='bold 14px sans-serif';
    var text = 'A=' + Adeg.toFixed(1) + '°';
    ctx.fillText(text, tx, ty);
    ctx.restore();
  }

  function drawNormal(P, n, label){
    var len=22; var nx=n.x, ny=n.y; // n is unit from face outward
    var x2 = P.x + nx*len, y2 = P.y + ny*len;
    ctx.save(); ctx.strokeStyle='#94a3b8'; ctx.lineWidth = 1.5; ctx.beginPath(); ctx.moveTo(P.x, P.y); ctx.lineTo(x2, y2); ctx.stroke();
    // label a bit further along the normal
    ctx.fillStyle='#475569'; ctx.font='bold 14px sans-serif'; ctx.fillText(label, P.x + nx*(len+10), P.y + ny*(len+10));
    ctx.restore();
  }

  function computePrism(n,Adeg,i1deg){
    // Use analytical calculation based on Snell's law for prism
    // More reliable than geometric ray tracing
    var air = 1.0003;
    var Arad = toRad(Adeg);
    var i1rad = toRad(i1deg);

    // Apply Snell's law at entry: air*sin(i1) = n*sin(r1)
    var sinr1 = (air / n) * Math.sin(i1rad);
    if(Math.abs(sinr1) > 1) {
      // TIR at entry (shouldn't happen from air to glass)
      return {r1:NaN, r2:NaN, i2:NaN, dev:NaN, tir:true, tirType:'entry'};
    }
    var r1rad = Math.asin(sinr1);
    var r1deg = toDeg(r1rad);

    // For a prism: r1 + r2 = A
    var r2rad = Arad - r1rad;
    var r2deg = toDeg(r2rad);

    // Apply Snell's law at exit: n*sin(r2) = air*sin(i2)
    var sini2 = (n / air) * Math.sin(r2rad);
    if(Math.abs(sini2) > 1) {
      // TIR at exit
      return {r1:r1deg, r2:r2deg, i2:NaN, dev:NaN, tir:true, tirType:'exit'};
    }
    var i2rad = Math.asin(sini2);
    var i2deg = toDeg(i2rad);

    // Deviation: δ = i1 + i2 - A
    var dev = i1deg + i2deg - Adeg;

    return {r1:r1deg, r2:r2deg, i2:i2deg, dev:dev, tir:false, tirType:null};
  }


  // Slider sync functions
  function syncSlider(input, slider){
    input.addEventListener('input', function(){ slider.value = input.value; validateInput(input); });
    slider.addEventListener('input', function(){ input.value = slider.value; run(); });
  }
  syncSlider(i1, $('i1Slider'));
  syncSlider(ip, $('ipSlider'));
  syncSlider(np, $('npSlider'));
  syncSlider(A, $('ASlider'));

  // Input validation
  function validateInput(input){
    var val = parseFloat(input.value);
    var min = parseFloat(input.min);
    var max = parseFloat(input.max);
    var msgEl = null;
    if(input===i1) msgEl = $('i1Msg');
    else if(input===ip) msgEl = $('ipMsg');
    else if(input===np) msgEl = $('npMsg');
    else if(input===A) msgEl = $('AMsg');

    if(!msgEl) return;

    if(isNaN(val) || val < min || val > max){
      msgEl.textContent = '⚠️ Value must be between '+min+' and '+max;
      msgEl.className = 'text-danger d-block';
    } else {
      msgEl.textContent = '✓ Valid';
      msgEl.className = 'text-success d-block';
      setTimeout(function(){ msgEl.textContent = ''; }, 1500);
    }
  }

  // Step-by-step calculations
  function showSteps(md, params){
    var html = '';
    if(md === 'prism'){
      var n = params.n, A = params.A, i1 = params.i1;
      html += '<div class="mb-2"><strong>1. Entry refraction (Snell\'s law):</strong></div>';
      html += '<div class="ml-3">n<sub>air</sub> × sin(i₁) = n<sub>prism</sub> × sin(r₁)</div>';
      html += '<div class="ml-3">1.0003 × sin('+i1.toFixed(2)+'°) = '+n.toFixed(4)+' × sin(r₁)</div>';
      var sinr1 = (1.0003/n) * Math.sin(toRad(i1));
      html += '<div class="ml-3">sin(r₁) = '+(1.0003/n).toFixed(4)+' × '+Math.sin(toRad(i1)).toFixed(4)+' = '+sinr1.toFixed(4)+'</div>';
      var r1 = toDeg(Math.asin(sinr1));
      html += '<div class="ml-3 text-primary"><strong>r₁ = '+r1.toFixed(2)+'°</strong></div>';

      html += '<div class="mt-3 mb-2"><strong>2. Prism geometry:</strong></div>';
      html += '<div class="ml-3">r₁ + r₂ = A</div>';
      html += '<div class="ml-3">'+r1.toFixed(2)+'° + r₂ = '+A.toFixed(2)+'°</div>';
      var r2 = A - r1;
      html += '<div class="ml-3 text-primary"><strong>r₂ = '+r2.toFixed(2)+'°</strong></div>';

      html += '<div class="mt-3 mb-2"><strong>3. Exit refraction (Snell\'s law):</strong></div>';
      html += '<div class="ml-3">n<sub>prism</sub> × sin(r₂) = n<sub>air</sub> × sin(i₂)</div>';
      html += '<div class="ml-3">'+n.toFixed(4)+' × sin('+r2.toFixed(2)+'°) = 1.0003 × sin(i₂)</div>';
      var sini2 = (n/1.0003) * Math.sin(toRad(r2));
      html += '<div class="ml-3">sin(i₂) = '+sini2.toFixed(4)+'</div>';
      var i2 = toDeg(Math.asin(sini2));
      html += '<div class="ml-3 text-primary"><strong>i₂ = '+i2.toFixed(2)+'°</strong></div>';

      html += '<div class="mt-3 mb-2"><strong>4. Deviation:</strong></div>';
      html += '<div class="ml-3">δ = i₁ + i₂ - A</div>';
      html += '<div class="ml-3">δ = '+i1.toFixed(2)+'° + '+i2.toFixed(2)+'° - '+A.toFixed(2)+'°</div>';
      var dev = i1 + i2 - A;
      html += '<div class="ml-3 text-primary"><strong>δ = '+dev.toFixed(2)+'°</strong></div>';
    } else if(md === 'interface'){
      var n1v = params.n1, n2v = params.n2, th1 = params.th1;
      html += '<div class="mb-2"><strong>1. Snell\'s Law:</strong></div>';
      html += '<div class="ml-3">n₁ × sin(θ₁) = n₂ × sin(θ₂)</div>';
      html += '<div class="ml-3">'+n1v.toFixed(4)+' × sin('+th1.toFixed(2)+'°) = '+n2v.toFixed(4)+' × sin(θ₂)</div>';
      var sins2 = (n1v/n2v) * Math.sin(toRad(th1));
      html += '<div class="ml-3">sin(θ₂) = '+(n1v/n2v).toFixed(4)+' × '+Math.sin(toRad(th1)).toFixed(4)+' = '+sins2.toFixed(4)+'</div>';
      if(Math.abs(sins2) <= 1){
        var th2 = toDeg(Math.asin(sins2));
        html += '<div class="ml-3 text-primary"><strong>θ₂ = '+th2.toFixed(2)+'°</strong></div>';
      } else {
        html += '<div class="ml-3 text-danger"><strong>sin(θ₂) > 1: Total Internal Reflection!</strong></div>';
      }

      if(n1v > n2v){
        html += '<div class="mt-3 mb-2"><strong>2. Critical Angle:</strong></div>';
        html += '<div class="ml-3">θ<sub>c</sub> = arcsin(n₂/n₁)</div>';
        html += '<div class="ml-3">θ<sub>c</sub> = arcsin('+n2v.toFixed(4)+'/'+n1v.toFixed(4)+')</div>';
        var thc = toDeg(Math.asin(n2v/n1v));
        html += '<div class="ml-3 text-primary"><strong>θ<sub>c</sub> = '+thc.toFixed(2)+'°</strong></div>';
      }
    }
    $('stepsContent').innerHTML = html;
  }

  // Copy results button
  $('btnCopy').addEventListener('click', function(){
    var md = mode.value;
    var text = '';
    if(md === 'prism'){
      text = 'Prism Results: r₁='+r1o.textContent+', r₂='+r2o.textContent+', i₂='+i2o.textContent+', δ='+devo.textContent;
      if(tirNoteP.textContent) text += ' '+tirNoteP.textContent;
    } else if(md === 'interface'){
      text = 'Snell\'s Law Results: θ₂='+t2.textContent+', θc='+tc.textContent;
      if(tirNote.textContent) text += ' '+tirNote.textContent;
    }
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(text).then(function(){
        var btn = $('btnCopy');
        var orig = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
        btn.className = 'btn btn-success btn-sm';
        setTimeout(function(){ btn.innerHTML = orig; btn.className = 'btn btn-outline-primary btn-sm'; }, 2000);
      }).catch(function(){ alert('Copy failed. Please copy manually: ' + text); });
    } else {
      prompt('Copy this text:', text);
    }
  });

  $('btnRun').addEventListener('click', run);
  ;['change','input'].forEach(function(ev){ [mode,m1,m2,n1,n2,i1,np,A,ip,disp,mat,fm1,fm2,fn1,fn2].forEach(function(el){ el&&el.addEventListener(ev, run); }); });
  $('btnSave').addEventListener('click', function(){
    try{
      var originalCanvas = $('snellCanvas');
      var tempCanvas = document.createElement('canvas');
      var w = originalCanvas.width;
      var h = originalCanvas.height;
      // Add extra height for title, inputs, results and link
      var extraHeight = 120;
      tempCanvas.width = w;
      tempCanvas.height = h + extraHeight;
      var tempCtx = tempCanvas.getContext('2d');

      // Fill entire canvas with white background
      tempCtx.fillStyle = '#ffffff';
      tempCtx.fillRect(0, 0, w, h + extraHeight);

      // Copy original canvas
      tempCtx.drawImage(originalCanvas, 0, 0);

      // Add text below diagram
      var yPos = h + 20;
      var md = mode.value;

      // Add title
      tempCtx.fillStyle = '#1e293b';
      tempCtx.font = 'bold 16px sans-serif';
      var title = (md === 'prism') ? 'Prism Refraction' : (md === 'fresnel') ? 'Fresnel Reflectance' : 'Snell\'s Law - Interface Refraction';
      tempCtx.fillText(title, 10, yPos);
      yPos += 25;

      // Add inputs
      tempCtx.font = '13px sans-serif';
      tempCtx.fillStyle = '#475569';
      var inputText = '';
      if(md === 'prism'){
        inputText = 'Inputs: n=' + np.value + ', Apex A=' + A.value + '°, Incident i₁=' + ip.value + '°';
      } else if(md === 'interface'){
        inputText = 'Inputs: n₁=' + n1.value + ', n₂=' + n2.value + ', Incident θ₁=' + i1.value + '°';
      } else if(md === 'fresnel'){
        inputText = 'Inputs: n₁=' + fn1.value + ', n₂=' + fn2.value;
      }
      tempCtx.fillText(inputText, 10, yPos);
      yPos += 20;

      // Add results
      tempCtx.font = 'bold 13px sans-serif';
      tempCtx.fillStyle = '#1e293b';
      if(md === 'prism'){
        var resultText = 'Results: r₁=' + r1o.textContent + ', r₂=' + r2o.textContent +
                        ', i₂=' + i2o.textContent + ', δ=' + devo.textContent;
        if(tirNoteP.textContent) resultText += tirNoteP.textContent;
        tempCtx.fillText(resultText, 10, yPos);
      } else if(md === 'interface'){
        var resultText = 'Results: θ₂=' + t2.textContent + ', θc=' + tc.textContent;
        if(tirNote.textContent) resultText += tirNote.textContent;
        tempCtx.fillText(resultText, 10, yPos);
      }
      yPos += 25;

      // Add link
      tempCtx.font = '12px sans-serif';
      tempCtx.fillStyle = '#3b82f6';
      tempCtx.fillText('https://8gwifi.org/snells-law-prism.jsp', 10, yPos);

      var url = tempCanvas.toDataURL('image/png');
      var a = document.createElement('a');
      a.href = url;
      a.download = 'snell-prism.png';
      a.click();
    }catch(e){
      alert('Unable to save image: ' + e.message);
    }
  });
  $('btnShare').addEventListener('click', function(){ var params=new URLSearchParams({ mode:mode.value, m1:m1.value, n1:n1.value, m2:m2.value, n2:n2.value, i1:i1.value, np:np.value, A:A.value, ip:ip.value }); var link=location.origin+location.pathname+'?'+params.toString(); if(navigator.clipboard&&navigator.clipboard.writeText){ navigator.clipboard.writeText(link).then(function(){ alert('Share URL copied'); }).catch(function(){ prompt('Copy this URL', link); }); } else { prompt('Copy this URL', link); } });
  // presets
  var presetItems=document.querySelectorAll('#presetBtn ~ .dropdown-menu a[data-preset]');
  for(var pi=0;pi<presetItems.length;pi++){ (function(a){ a.addEventListener('click', function(e){ e.preventDefault(); var p=a.getAttribute('data-preset');
    // Interface Mode presets
    if(p==='air-glass'){ mode.value='interface'; m1.value='1.0003'; n1.value='1.0003'; m2.value='1.5'; n2.value='1.5'; i1.value='30'; }
    if(p==='water-air'){ mode.value='interface'; m1.value='1.333'; n1.value='1.333'; m2.value='1.0003'; n2.value='1.0003'; i1.value='60'; }
    if(p==='diamond-critical'){ mode.value='interface'; m1.value='2.417'; n1.value='2.417'; m2.value='1.0003'; n2.value='1.0003'; i1.value='24.4'; }
    if(p==='underwater-vision'){ mode.value='interface'; m1.value='1.333'; n1.value='1.333'; m2.value='1.0003'; n2.value='1.0003'; i1.value='30'; }
    if(p==='fiber-optic'){ mode.value='interface'; m1.value='1.5'; n1.value='1.5'; m2.value='1.0003'; n2.value='1.0003'; i1.value='85'; }
    if(p==='ice-water'){ mode.value='interface'; m1.value='1.31'; n1.value='1.31'; m2.value='1.333'; n2.value='1.333'; i1.value='45'; }
    // Prism Mode presets
    if(p==='prism-standard'){ mode.value='prism'; np.value='1.5'; A.value='60'; ip.value='30'; disp.value='off'; }
    if(p==='diamond-prism'){ mode.value='prism'; np.value='2.417'; A.value='40'; ip.value='30'; disp.value='off'; }
    if(p==='rainbow-prism'){ mode.value='prism'; np.value='1.5'; A.value='60'; ip.value='50'; disp.value='rgb'; mat.value='bk7'; }
    if(p==='min-deviation'){ mode.value='prism'; np.value='1.5'; A.value='60'; ip.value='48.6'; disp.value='off'; }
    if(p==='ice-halo'){ mode.value='prism'; np.value='1.31'; A.value='60'; ip.value='40'; disp.value='off'; }
    if(p==='near-tir'){ mode.value='prism'; np.value='1.65'; A.value='75'; ip.value='20'; disp.value='off'; }
    if(p==='grazing'){ mode.value='prism'; np.value='1.5'; A.value='45'; ip.value='85'; disp.value='off'; }
    run();
  }); })(presetItems[pi]); }
  // apply query
  function initFromQuery(){
    var p=new URLSearchParams(location.search);
    ['mode','m1','n1','m2','n2','i1','np','A','ip'].forEach(function(k){ if(p.has(k)) $(k).value=p.get(k); });
    run();
  }
  initFromQuery();
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

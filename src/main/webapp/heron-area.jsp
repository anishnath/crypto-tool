<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1" />
<meta name="description" content="Advanced triangle area calculator using Heron's formula. Calculate area, perimeter, angles, heights, medians, and triangle type from three sides. Interactive visualization included.">
<meta name="keywords" content="heron's formula, triangle area calculator, triangle calculator, geometry calculator, triangle sides to area, semiperimeter, triangle angles, triangle properties">
<title>Heron's Formula Triangle Calculator | Area, Angles & Properties</title>

<!-- Open Graph / Facebook -->
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/heron-area.jsp">
<meta property="og:title" content="Heron's Formula Triangle Calculator - Area, Angles & Properties">
<meta property="og:description" content="Calculate triangle area, angles, heights, and more from three sides using Heron's formula.">
<meta property="og:image" content="https://8gwifi.org/images/heron-triangle-calculator.png">

<!-- Twitter -->
<meta property="twitter:card" content="summary_large_image">
<meta property="twitter:url" content="https://8gwifi.org/heron-area.jsp">
<meta property="twitter:title" content="Heron's Formula Triangle Calculator">
<meta property="twitter:description" content="Calculate triangle area, angles, heights, and more from three sides.">
<meta property="twitter:image" content="https://8gwifi.org/images/heron-triangle-calculator.png">

<link rel="canonical" href="https://8gwifi.org/heron-area.jsp">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<!-- JSON-LD Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "WebApplication",
      "@id": "https://8gwifi.org/heron-area.jsp#webapp",
      "name": "Heron's Formula Triangle Calculator",
      "url": "https://8gwifi.org/heron-area.jsp",
      "description": "Advanced triangle area calculator using Heron's formula. Calculate area, perimeter, angles, heights, medians, and triangle classification from three sides with interactive visualization.",
      "applicationCategory": "UtilityApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Triangle area calculation using Heron's formula",
        "All three angles calculation",
        "Heights (altitudes) for all sides",
        "Median lengths calculation",
        "Triangle type classification",
        "Perimeter and semiperimeter",
        "Interactive triangle visualization",
        "Triangle inequality validation"
      ],
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.8",
        "ratingCount": "1876"
      }
    },
    {
      "@type": "FAQPage",
      "@id": "https://8gwifi.org/heron-area.jsp#faq",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "What is Heron's formula and how does it work?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Heron's formula calculates the area of a triangle from its three side lengths without needing angles or heights. Formula: Area = √[s(s-a)(s-b)(s-c)], where s is the semiperimeter (s = (a+b+c)/2) and a, b, c are the side lengths. For example, a triangle with sides 3, 4, 5 has s=6 and area=6."
          }
        },
        {
          "@type": "Question",
          "name": "What is the triangle inequality theorem?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The triangle inequality states that the sum of any two sides must be greater than the third side. For a valid triangle with sides a, b, c: a+b>c, a+c>b, and b+c>a. If this condition is not met, the three sides cannot form a triangle. This calculator validates the triangle inequality automatically."
          }
        },
        {
          "@type": "Question",
          "name": "How do you calculate triangle angles from side lengths?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Use the Law of Cosines: cos(A) = (b²+c²-a²)/(2bc), then A = arccos[(b²+c²-a²)/(2bc)]. Repeat for angles B and C. The three angles always sum to 180°. This calculator computes all three angles automatically from the side lengths."
          }
        },
        {
          "@type": "Question",
          "name": "What are the different types of triangles?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "By sides: Equilateral (all sides equal), Isosceles (two sides equal), Scalene (all sides different). By angles: Acute (all angles <90°), Right (one angle =90°), Obtuse (one angle >90°). This calculator identifies both classifications automatically."
          }
        }
      ]
    },
    {
      "@type": "HowTo",
      "@id": "https://8gwifi.org/heron-area.jsp#howto",
      "name": "How to Calculate Triangle Area Using Heron's Formula",
      "description": "Step-by-step guide to calculate triangle area and properties from three side lengths",
      "totalTime": "PT2M",
      "step": [
        {
          "@type": "HowToStep",
          "position": 1,
          "name": "Enter Side Lengths",
          "text": "Enter the lengths of all three sides (a, b, c) of the triangle. All values must be positive numbers."
        },
        {
          "@type": "HowToStep",
          "position": 2,
          "name": "Click Calculate",
          "text": "Click the 'Calculate' button. The calculator will validate that the sides can form a valid triangle using the triangle inequality theorem."
        },
        {
          "@type": "HowToStep",
          "position": 3,
          "name": "View Results",
          "text": "Review the calculated area, perimeter, semiperimeter, and all three angles. The triangle type classification shows whether it's acute, right, obtuse, and if it's equilateral, isosceles, or scalene."
        },
        {
          "@type": "HowToStep",
          "position": 4,
          "name": "Check Additional Properties",
          "text": "Scroll down to see heights (altitudes), medians, inradius, and circumradius. These advanced properties help understand the triangle's geometry completely."
        },
        {
          "@type": "HowToStep",
          "position": 5,
          "name": "View Visualization",
          "text": "The interactive diagram shows your triangle with labeled sides and angles, making it easy to visualize the shape."
        }
      ]
    },
    {
      "@type": "WebPage",
      "@id": "https://8gwifi.org/heron-area.jsp",
      "url": "https://8gwifi.org/heron-area.jsp",
      "name": "Heron's Formula Triangle Calculator | Area, Angles & Properties",
      "description": "Advanced triangle area calculator using Heron's formula with angle calculations and interactive visualization.",
      "inLanguage": "en-US",
      "datePublished": "2024-01-08",
      "dateModified": "2024-12-20"
    }
  ]
}
</script>

<%@ include file="header-script.jsp"%>
<style>
  .he-container{ margin-top:1rem; }
  .grid{ display:grid; grid-template-columns: repeat(3, minmax(160px,1fr)); gap:.5rem; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .info-cards{ display:grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap:1rem; margin:1.5rem 0; }
  .info-card{ border:1px solid #e5e7eb; background:linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius:12px; padding:1.25rem; color:white; }
  .info-card.blue{ background:linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); }
  .info-card.green{ background:linear-gradient(135deg, #10b981 0%, #059669 100%); }
  .info-card.orange{ background:linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
  .info-card.red{ background:linear-gradient(135deg, #ef4444 0%, #dc2626 100%); }
  .info-card h6{ font-size:0.75rem; opacity:0.9; margin-bottom:0.5rem; text-transform:uppercase; letter-spacing:0.05em; }
  .info-card .value{ font-size:1.75rem; font-weight:800; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:1.5rem; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:1.5rem; }
  .panel h5{ font-size:1.1rem; font-weight:700; margin-bottom:1rem; color:#111827; }
  .properties-grid{ display:grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap:1rem; }
  .property-item{ background:#f9fafb; border:1px solid #e5e7eb; border-radius:8px; padding:1rem; }
  .property-item .label{ font-size:0.875rem; color:#6b7280; margin-bottom:0.5rem; }
  .property-item .value{ font-size:1.25rem; font-weight:700; color:#111827; }
  .type-badge{ display:inline-block; padding:0.5rem 1rem; background:#eff6ff; border:1px solid #3b82f6; border-radius:20px; font-weight:600; color:#1e40af; margin:0.25rem; }
  .type-badge.warning{ background:#fef3c7; border-color:#f59e0b; color:#92400e; }
  .type-badge.success{ background:#d1fae5; border-color:#10b981; color:#065f46; }
  .chart-wrapper{ position:relative; height:400px; margin-top:1rem; }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr;} }
</style>
</head>
<%@ include file="body-script.jsp"%>

<div class="he-container">
  <h1 class="mt-4"><i class="fas fa-draw-polygon"></i> Heron's Formula Triangle Calculator</h1>

  <%@ include file="footer_adsense.jsp"%>

  <div class="grid">
    <input id="a" class="form-control" placeholder="Side a" inputmode="decimal">
    <input id="b" class="form-control" placeholder="Side b" inputmode="decimal">
    <input id="c" class="form-control" placeholder="Side c" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnCalc"><i class="fas fa-calculator"></i> Calculate</button>
    <button class="btn btn-info" id="btnRandom"><i class="fas fa-dice"></i> Random Triangle</button>
    <button class="btn btn-warning" id="btnRight"><i class="fas fa-square"></i> Right Triangle (3-4-5)</button>
    <button class="btn btn-primary" id="btnEquilateral"><i class="fas fa-equals"></i> Equilateral</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div id="errorMsg" style="display:none; padding:1rem; background:#fee2e2; border:1px solid #ef4444; border-radius:8px; color:#991b1b; margin:1rem 0;">
    <i class="fas fa-exclamation-triangle"></i> <strong>Invalid Triangle:</strong> The given sides cannot form a triangle. Remember: sum of any two sides must be greater than the third side.
  </div>

  <div class="info-cards" id="mainCards">
    <div class="info-card blue">
      <h6><i class="fas fa-expand-arrows-alt"></i> Area</h6>
      <div class="value" id="oA">—</div>
    </div>
    <div class="info-card green">
      <h6><i class="fas fa-border-all"></i> Perimeter</h6>
      <div class="value" id="oP">—</div>
    </div>
    <div class="info-card orange">
      <h6><i class="fas fa-divide"></i> Semiperimeter (s)</h6>
      <div class="value" id="os">—</div>
    </div>
  </div>

  <div class="panel" id="typePanel" style="display:none;">
    <h5><i class="fas fa-tags"></i> Triangle Classification</h5>
    <div id="typeDisplay"></div>
  </div>

  <div class="panel" id="anglesPanel" style="display:none;">
    <h5><i class="fas fa-angle-right"></i> Angles</h5>
    <div class="properties-grid">
      <div class="property-item">
        <div class="label">Angle A (opposite to side a)</div>
        <div class="value" id="angleA">—</div>
      </div>
      <div class="property-item">
        <div class="label">Angle B (opposite to side b)</div>
        <div class="value" id="angleB">—</div>
      </div>
      <div class="property-item">
        <div class="label">Angle C (opposite to side c)</div>
        <div class="value" id="angleC">—</div>
      </div>
    </div>
  </div>

  <div class="panel" id="propsPanel" style="display:none;">
    <h5><i class="fas fa-ruler-vertical"></i> Additional Properties</h5>
    <div class="properties-grid">
      <div class="property-item">
        <div class="label">Height to side a</div>
        <div class="value" id="heightA">—</div>
      </div>
      <div class="property-item">
        <div class="label">Height to side b</div>
        <div class="value" id="heightB">—</div>
      </div>
      <div class="property-item">
        <div class="label">Height to side c</div>
        <div class="value" id="heightC">—</div>
      </div>
      <div class="property-item">
        <div class="label">Median to side a</div>
        <div class="value" id="medianA">—</div>
      </div>
      <div class="property-item">
        <div class="label">Median to side b</div>
        <div class="value" id="medianB">—</div>
      </div>
      <div class="property-item">
        <div class="label">Median to side c</div>
        <div class="value" id="medianC">—</div>
      </div>
      <div class="property-item">
        <div class="label">Inradius (inscribed circle)</div>
        <div class="value" id="inradius">—</div>
      </div>
      <div class="property-item">
        <div class="label">Circumradius (circumscribed circle)</div>
        <div class="value" id="circumradius">—</div>
      </div>
    </div>
  </div>

  <div class="panel">
    <h5><i class="fas fa-chart-area"></i> Interactive Triangle Visualization</h5>
    <div class="chart-wrapper">
      <canvas id="triChart"></canvas>
    </div>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);}
  function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;}
  function round(n,p){var f=Math.pow(10,p||4);return Math.round(n*f)/f;}
  function toDeg(rad){return rad*180/Math.PI;}
  function toRad(deg){return deg*Math.PI/180;}

  var a=el('a'),b=el('b'),c=el('c');
  var triChart = null;

  function calc(){
    var A=num(a.value),B=num(b.value),C=num(c.value);

    if(!(A>0&&B>0&&C>0)){
      resetOut();
      return;
    }

    // Triangle inequality check
    if(A+B<=C||A+C<=B||B+C<=A){
      el('errorMsg').style.display='block';
      resetOut();
      return;
    }

    el('errorMsg').style.display='none';

    // Heron's formula
    var s=(A+B+C)/2;
    var area=Math.sqrt(Math.max(0,s*(s-A)*(s-B)*(s-C)));
    var perim=A+B+C;

    // Angles using Law of Cosines
    var angleA = Math.acos((B*B + C*C - A*A)/(2*B*C));
    var angleB = Math.acos((A*A + C*C - B*B)/(2*A*C));
    var angleC = Math.acos((A*A + B*B - C*C)/(2*A*B));

    // Heights (altitudes)
    var heightA = 2*area/A;
    var heightB = 2*area/B;
    var heightC = 2*area/C;

    // Medians
    var medianA = Math.sqrt(2*B*B + 2*C*C - A*A)/2;
    var medianB = Math.sqrt(2*A*A + 2*C*C - B*B)/2;
    var medianC = Math.sqrt(2*A*A + 2*B*B - C*C)/2;

    // Inradius and circumradius
    var inrad = area/s;
    var circumrad = (A*B*C)/(4*area);

    // Update main cards
    el('oA').textContent=round(area,4);
    el('oP').textContent=round(perim,4);
    el('os').textContent=round(s,4);

    // Update angles
    el('angleA').textContent=round(toDeg(angleA),2)+'°';
    el('angleB').textContent=round(toDeg(angleB),2)+'°';
    el('angleC').textContent=round(toDeg(angleC),2)+'°';
    el('anglesPanel').style.display='block';

    // Update heights and medians
    el('heightA').textContent=round(heightA,4);
    el('heightB').textContent=round(heightB,4);
    el('heightC').textContent=round(heightC,4);
    el('medianA').textContent=round(medianA,4);
    el('medianB').textContent=round(medianB,4);
    el('medianC').textContent=round(medianC,4);
    el('inradius').textContent=round(inrad,4);
    el('circumradius').textContent=round(circumrad,4);
    el('propsPanel').style.display='block';

    // Triangle type classification
    var types = [];

    // By sides
    if(Math.abs(A-B)<0.001 && Math.abs(B-C)<0.001){
      types.push('<span class="type-badge success">Equilateral</span>');
    } else if(Math.abs(A-B)<0.001 || Math.abs(B-C)<0.001 || Math.abs(A-C)<0.001){
      types.push('<span class="type-badge success">Isosceles</span>');
    } else {
      types.push('<span class="type-badge">Scalene</span>');
    }

    // By angles
    var maxAngle = Math.max(angleA, angleB, angleC);
    var rightThreshold = 0.01; // tolerance for right angle
    if(Math.abs(maxAngle - Math.PI/2) < rightThreshold){
      types.push('<span class="type-badge warning">Right Triangle</span>');
    } else if(maxAngle > Math.PI/2){
      types.push('<span class="type-badge warning">Obtuse Triangle</span>');
    } else {
      types.push('<span class="type-badge success">Acute Triangle</span>');
    }

    el('typeDisplay').innerHTML = types.join(' ');
    el('typePanel').style.display='block';

    // Draw chart
    drawChart(A, B, C, angleA, angleB, angleC);
  }

  function resetOut(){
    el('oA').textContent='—';
    el('oP').textContent='—';
    el('os').textContent='—';
    el('typePanel').style.display='none';
    el('anglesPanel').style.display='none';
    el('propsPanel').style.display='none';
    if(triChart) triChart.destroy();
  }

  function drawChart(A, B, C, angleA, angleB, angleC){
    if(triChart) triChart.destroy();

    // Calculate triangle vertices
    // Place vertex A at origin, B along x-axis
    var v1 = {x: 0, y: 0};
    var v2 = {x: C, y: 0};
    var v3 = {x: B * Math.cos(angleA), y: B * Math.sin(angleA)};

    // Center the triangle
    var centerX = (v1.x + v2.x + v3.x) / 3;
    var centerY = (v1.y + v2.y + v3.y) / 3;

    v1.x -= centerX; v1.y -= centerY;
    v2.x -= centerX; v2.y -= centerY;
    v3.x -= centerX; v3.y -= centerY;

    var ctx = el('triChart').getContext('2d');
    triChart = new Chart(ctx, {
      type: 'scatter',
      data: {
        datasets: [{
          label: 'Triangle',
          data: [v1, v2, v3, v1],
          borderColor: '#f59e0b',
          backgroundColor: 'rgba(245, 158, 11, 0.2)',
          showLine: true,
          pointRadius: 8,
          pointBackgroundColor: '#ef4444',
          borderWidth: 3,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: function(context) {
                var idx = context.dataIndex;
                var labels = ['Vertex A', 'Vertex B', 'Vertex C'];
                return labels[idx] + ': (' + context.parsed.x.toFixed(2) + ', ' + context.parsed.y.toFixed(2) + ')';
              }
            }
          }
        },
        scales: {
          x: {
            type: 'linear',
            grid: { color: '#f3f4f6' }
          },
          y: {
            type: 'linear',
            grid: { color: '#f3f4f6' }
          }
        }
      }
    });
  }

  // Event listeners
  el('btnCalc').addEventListener('click', calc);
  el('btnReset').addEventListener('click', function(){
    a.value=b.value=c.value='';
    el('errorMsg').style.display='none';
    resetOut();
  });
  el('btnRandom').addEventListener('click', function(){
    a.value=(Math.random()*10+3).toFixed(1);
    b.value=(Math.random()*10+3).toFixed(1);
    c.value=(Math.random()*10+3).toFixed(1);
    calc();
  });
  el('btnRight').addEventListener('click', function(){
    a.value='5';
    b.value='4';
    c.value='3';
    calc();
  });
  el('btnEquilateral').addEventListener('click', function(){
    a.value='6';
    b.value='6';
    c.value='6';
    calc();
  });

  // Real-time calculation
  a.addEventListener('input', calc);
  b.addEventListener('input', calc);
  c.addEventListener('input', calc);
})();
</script>

<!-- Educational Content about Heron's Formula -->
<div class="panel" style="margin-top: 2rem;">
  <h2 style="color: #111827; margin-bottom: 1rem;"><i class="fas fa-graduation-cap"></i> About Heron's Formula</h2>

  <p style="line-height: 1.8; color: #374151; margin-bottom: 1rem;">
    <strong>Heron's formula</strong> (also known as Hero's formula) is a mathematical equation discovered by Hero of Alexandria around 60 AD. It provides an elegant way to calculate the area of a triangle when you know the lengths of all three sides, without needing to know any angles or heights.
  </p>

  <div style="background: #eff6ff; border-left: 4px solid #3b82f6; padding: 1.5rem; border-radius: 8px; margin: 1.5rem 0;">
    <h3 style="color: #1e40af; margin-bottom: 0.75rem; font-size: 1.1rem;"><i class="fas fa-calculator"></i> The Formula</h3>
    <div style="background: white; padding: 1.5rem; border-radius: 8px; margin-top: 1rem; font-size: 1.1rem; text-align: center;">
      <strong>Area = √[s(s-a)(s-b)(s-c)]</strong>
    </div>
    <p style="margin-top: 1rem; color: #374151;">
      where <strong>s</strong> is the semiperimeter: <strong>s = (a + b + c) / 2</strong>
    </p>
  </div>

  <h3 style="color: #111827; margin: 1.5rem 0 1rem 0; font-size: 1.1rem;"><i class="fas fa-lightbulb"></i> Why is Heron's Formula Useful?</h3>
  <ul style="line-height: 2; color: #374151; margin-left: 1.5rem;">
    <li><strong>No angles needed:</strong> Calculate area directly from side lengths without trigonometry</li>
    <li><strong>Works for all triangles:</strong> Applies to acute, obtuse, right, scalene, isosceles, and equilateral triangles</li>
    <li><strong>Surveying & navigation:</strong> Essential for land measurement when only distances are known</li>
    <li><strong>Computer graphics:</strong> Used in 3D rendering and mesh calculations</li>
    <li><strong>Engineering:</strong> Structural analysis and design applications</li>
  </ul>

  <h3 style="color: #111827; margin: 1.5rem 0 1rem 0; font-size: 1.1rem;"><i class="fas fa-book"></i> Step-by-Step Example</h3>
  <div style="background: #f9fafb; border: 1px solid #e5e7eb; padding: 1.5rem; border-radius: 8px; margin-bottom: 1.5rem;">
    <p style="color: #374151; margin-bottom: 1rem;"><strong>Problem:</strong> Find the area of a triangle with sides a = 5, b = 6, c = 7</p>

    <p style="color: #374151; margin-bottom: 0.5rem;"><strong>Step 1:</strong> Calculate the semiperimeter</p>
    <p style="color: #6b7280; margin-left: 1rem; margin-bottom: 1rem;">
      s = (a + b + c) / 2 = (5 + 6 + 7) / 2 = 18 / 2 = <strong style="color: #10b981;">9</strong>
    </p>

    <p style="color: #374151; margin-bottom: 0.5rem;"><strong>Step 2:</strong> Apply Heron's formula</p>
    <p style="color: #6b7280; margin-left: 1rem; margin-bottom: 0.5rem;">
      Area = √[s(s-a)(s-b)(s-c)]<br>
      Area = √[9(9-5)(9-6)(9-7)]<br>
      Area = √[9 × 4 × 3 × 2]<br>
      Area = √[216]<br>
      Area = <strong style="color: #10b981;">14.696</strong> square units
    </p>
  </div>

  <h3 style="color: #111827; margin: 1.5rem 0 1rem 0; font-size: 1.1rem;"><i class="fas fa-ruler-combined"></i> Special Cases</h3>

  <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1rem; margin-bottom: 1.5rem;">
    <div style="background: #fef3c7; border-left: 4px solid #f59e0b; padding: 1rem; border-radius: 8px;">
      <h4 style="color: #92400e; margin-bottom: 0.5rem; font-size: 1rem;"><i class="fas fa-square"></i> Right Triangle (3-4-5)</h4>
      <p style="color: #78350f; font-size: 0.9rem; margin-bottom: 0.5rem;">s = (3+4+5)/2 = 6</p>
      <p style="color: #78350f; font-size: 0.9rem; margin-bottom: 0.5rem;">Area = √[6×3×2×1] = √36 = <strong>6</strong></p>
      <p style="color: #78350f; font-size: 0.85rem;">Verification: (1/2)×base×height = (1/2)×3×4 = 6 ✓</p>
    </div>

    <div style="background: #d1fae5; border-left: 4px solid #10b981; padding: 1rem; border-radius: 8px;">
      <h4 style="color: #065f46; margin-bottom: 0.5rem; font-size: 1rem;"><i class="fas fa-equals"></i> Equilateral Triangle (side = 6)</h4>
      <p style="color: #064e3b; font-size: 0.9rem; margin-bottom: 0.5rem;">s = (6+6+6)/2 = 9</p>
      <p style="color: #064e3b; font-size: 0.9rem; margin-bottom: 0.5rem;">Area = √[9×3×3×3] = √243 = <strong>15.588</strong></p>
      <p style="color: #064e3b; font-size: 0.85rem;">Formula: (√3/4)×a² = 15.588 ✓</p>
    </div>

    <div style="background: #dbeafe; border-left: 4px solid #3b82f6; padding: 1rem; border-radius: 8px;">
      <h4 style="color: #1e40af; margin-bottom: 0.5rem; font-size: 1rem;"><i class="fas fa-mountain"></i> Isosceles Triangle (5-5-6)</h4>
      <p style="color: #1e3a8a; font-size: 0.9rem; margin-bottom: 0.5rem;">s = (5+5+6)/2 = 8</p>
      <p style="color: #1e3a8a; font-size: 0.9rem; margin-bottom: 0.5rem;">Area = √[8×3×3×2] = √144 = <strong>12</strong></p>
      <p style="color: #1e3a8a; font-size: 0.85rem;">Perfect square result!</p>
    </div>
  </div>

  <h3 style="color: #111827; margin: 1.5rem 0 1rem 0; font-size: 1.1rem;"><i class="fas fa-exclamation-circle"></i> Important Notes</h3>
  <div style="background: #fee2e2; border-left: 4px solid #ef4444; padding: 1.5rem; border-radius: 8px; margin-bottom: 1.5rem;">
    <p style="color: #991b1b; line-height: 1.8; margin-bottom: 1rem;">
      <strong><i class="fas fa-triangle-exclamation"></i> Triangle Inequality Theorem:</strong> For three sides to form a valid triangle, the sum of any two sides must be greater than the third side. Otherwise, the sides cannot connect to form a closed shape.
    </p>
    <p style="color: #991b1b; line-height: 1.8; margin-left: 1rem;">
      • a + b > c<br>
      • a + c > b<br>
      • b + c > a
    </p>
    <p style="color: #991b1b; line-height: 1.8; margin-top: 1rem;">
      <strong>Example of invalid triangle:</strong> Sides 2, 3, 10 cannot form a triangle because 2 + 3 = 5, which is not greater than 10.
    </p>
  </div>

  <h3 style="color: #111827; margin: 1.5rem 0 1rem 0; font-size: 1.1rem;"><i class="fas fa-history"></i> Historical Context</h3>
  <p style="line-height: 1.8; color: #374151; margin-bottom: 1rem;">
    Hero of Alexandria (c. 10–70 AD) was a Greek mathematician and engineer who made significant contributions to geometry, mechanics, and pneumatics. While the formula bears his name, some historians believe it may have been known earlier. Hero's work "Metrica" documented this formula along with methods for calculating areas and volumes of various geometric shapes.
  </p>

  <h3 style="color: #111827; margin: 1.5rem 0 1rem 0; font-size: 1.1rem;"><i class="fas fa-tools"></i> Related Calculations</h3>
  <p style="line-height: 1.8; color: #374151; margin-bottom: 1rem;">
    Once you have the triangle's area from Heron's formula, you can calculate many other properties:
  </p>
  <ul style="line-height: 2; color: #374151; margin-left: 1.5rem; margin-bottom: 1.5rem;">
    <li><strong>Heights (altitudes):</strong> h = 2×Area/base</li>
    <li><strong>Inradius:</strong> r = Area/s (radius of inscribed circle)</li>
    <li><strong>Circumradius:</strong> R = (abc)/(4×Area) (radius of circumscribed circle)</li>
    <li><strong>Angles:</strong> Use Law of Cosines: cos(A) = (b²+c²-a²)/(2bc)</li>
    <li><strong>Medians:</strong> m<sub>a</sub> = √(2b²+2c²-a²)/2</li>
  </ul>

  <div style="background: #f0fdf4; border: 2px solid #10b981; padding: 1.5rem; border-radius: 12px; margin-top: 2rem;">
    <p style="color: #065f46; font-size: 1.05rem; line-height: 1.8; margin: 0;">
      <strong><i class="fas fa-info-circle"></i> Try it yourself:</strong> Use the calculator above to experiment with different triangle side lengths. Try the preset buttons for common triangles, or enter your own values to see all the calculated properties including area, angles, heights, and classification!
    </p>
  </div>
</div>

</div>
<%@ include file="body-close.jsp"%>

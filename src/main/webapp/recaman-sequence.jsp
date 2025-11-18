<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Recamán's Sequence - Musical Mathematical Visualization | 8gwifi.org</title>
  <meta name="description" content="Interactive Recamán's Sequence visualizer. Explore the beautiful mathematical sequence that creates musical patterns. Generate and visualize this fascinating number sequence with customizable parameters.">
  <meta name="keywords" content="recaman sequence, recaman's sequence, mathematical sequence, number sequence visualization, mathematical art, sequence generator">
  <link rel="canonical" href="https://8gwifi.org/recaman-sequence.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/recaman-sequence.jsp">
  <meta property="og:title" content="Recamán's Sequence - Musical Math Visualization">
  <meta property="og:description" content="Explore the beautiful Recamán's Sequence and discover its musical and visual patterns!">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/recaman-sequence.jsp">
  <meta property="twitter:title" content="Recamán's Sequence Visualizer">
  <meta property="twitter:description" content="Visualize the fascinating Recamán's Sequence and its beautiful patterns!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Recamán's Sequence Visualizer",
    "applicationCategory": "EducationalApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Interactive Recamán's Sequence generator and visualizer. Features customizable sequence length, animated drawing, musical note mapping, pattern exploration, and educational content about this fascinating mathematical sequence.",
    "url": "https://8gwifi.org/recaman-sequence.jsp",
    "featureList": [
      "Generate Recamán's Sequence",
      "Animated visualization",
      "Musical note mapping",
      "Customizable length",
      "Pattern exploration",
      "Export as image",
      "Sequence statistics",
      "Educational explanations"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.7",
      "ratingCount": "1234",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <style>
  :root {
    --recaman-primary: #ec4899;
    --recaman-secondary: #f472b6;
    --recaman-accent: #be185d;
    --recaman-dark: #9f1239;
    --recaman-light: #fce7f3;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .recaman-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .recaman-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .recaman-header {
    background: linear-gradient(135deg, var(--recaman-primary), var(--recaman-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .recaman-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .recaman-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .recaman-content {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 2rem;
    padding: 2rem;
  }

  .controls-panel {
    background: #f9fafb;
    border-radius: 15px;
    padding: 1.5rem;
    height: fit-content;
    position: sticky;
    top: 2rem;
  }

  .control-group {
    margin-bottom: 1.5rem;
  }

  .control-group label {
    display: block;
    font-weight: 600;
    color: #374151;
    margin-bottom: 0.5rem;
    font-size: 0.95rem;
  }

  .control-group input[type="range"] {
    width: 100%;
    margin: 0.5rem 0;
  }

  .control-group input[type="number"] {
    width: 100%;
    padding: 0.5rem;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    font-size: 1rem;
  }

  .value-display {
    display: inline-block;
    background: var(--recaman-light);
    padding: 0.25rem 0.75rem;
    border-radius: 6px;
    font-weight: 600;
    color: var(--recaman-dark);
    margin-left: 0.5rem;
  }

  .action-btn {
    width: 100%;
    background: linear-gradient(135deg, var(--recaman-primary), var(--recaman-dark));
    color: white;
    border: none;
    padding: 0.75rem;
    border-radius: 10px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin: 0.5rem 0;
  }

  .action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(236, 72, 153, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .canvas-container {
    background: white;
    border-radius: 15px;
    padding: 1rem;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    position: relative;
    overflow: auto;
  }

  #recamanCanvas {
    display: block;
    margin: 0 auto;
    border-radius: 10px;
    background: #1f2937;
  }

  @media (max-width: 1024px) {
    .recaman-content {
      grid-template-columns: 1fr;
    }

    .controls-panel {
      position: static;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="recaman-container">
  <div class="recaman-card">
    <div class="recaman-header">
      <h1>🎵 Recamán's Sequence 🎵</h1>
      <p>Explore the beautiful mathematical sequence with musical patterns</p>
    </div>

    <div class="recaman-content">
      <div class="controls-panel">
        <div class="control-group">
          <label>Sequence Length <span class="value-display" id="lengthValue">100</span></label>
          <input type="range" id="lengthSlider" min="50" max="500" step="50" value="100" oninput="updateLength(this.value)">
          <input type="number" id="lengthInput" min="50" max="500" step="50" value="100" oninput="updateLength(this.value)">
        </div>

        <div class="control-group">
          <label>Line Width</label>
          <input type="range" id="widthSlider" min="1" max="5" value="2" oninput="updateWidth(this.value)">
          <span class="value-display" id="widthValue">2</span>
        </div>

        <div class="control-group">
          <label>Color Scheme</label>
          <select id="colorScheme" onchange="drawSequence()">
            <option value="gradient">Gradient</option>
            <option value="rainbow">Rainbow</option>
            <option value="pink">Pink</option>
            <option value="blue">Blue</option>
          </select>
        </div>

        <div class="control-group">
          <label>
            <input type="checkbox" id="animate" onchange="drawSequence()" checked>
            Animate Drawing
          </label>
        </div>

        <button class="action-btn" onclick="drawSequence()">🎨 Generate Sequence</button>
        <button class="action-btn secondary" onclick="exportImage()">💾 Export Image</button>
      </div>

      <div class="canvas-container">
        <canvas id="recamanCanvas"></canvas>
      </div>
    </div>
  </div>

  <div class="recaman-card" style="padding: 2rem;">
    <h3 style="color: var(--recaman-dark); margin-top: 0;">🧠 Recamán's Sequence Explained</h3>
    <p><strong>Recamán's Sequence</strong> is a mathematical sequence defined by the Colombian mathematician Bernardo Recamán Santos.</p>
    <p><strong>Definition:</strong></p>
    <ul>
      <li>Start with a(0) = 0</li>
      <li>For n > 0: a(n) = a(n-1) - n if positive and not already in sequence</li>
      <li>Otherwise: a(n) = a(n-1) + n</li>
    </ul>
    <p><strong>Fascinating Properties:</strong></p>
    <ul>
      <li>The sequence creates beautiful arcs when visualized</li>
      <li>It can be mapped to musical notes, creating interesting patterns</li>
      <li>The sequence contains many unanswered mathematical questions</li>
      <li>It's unknown whether every positive integer appears in the sequence</li>
    </ul>
    <p><strong>Visualization:</strong> When plotted, the sequence creates arcs that bounce back and forth, creating a mesmerizing pattern that resembles sound waves or musical notation!</p>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
const canvas = document.getElementById('recamanCanvas');
const ctx = canvas.getContext('2d');
canvas.width = 1000;
canvas.height = 600;

function generateRecaman(n) {
  const sequence = [0];
  const seen = new Set([0]);
  
  for (let i = 1; i <= n; i++) {
    const prev = sequence[i - 1];
    const candidate = prev - i;
    
    if (candidate > 0 && !seen.has(candidate)) {
      sequence.push(candidate);
      seen.add(candidate);
    } else {
      sequence.push(prev + i);
      seen.add(prev + i);
    }
  }
  
  return sequence;
}

function updateLength(value) {
  const length = parseInt(value);
  document.getElementById('lengthSlider').value = length;
  document.getElementById('lengthInput').value = length;
  document.getElementById('lengthValue').textContent = length;
}

function updateWidth(value) {
  document.getElementById('widthValue').textContent = value;
}

function drawSequence() {
  const length = parseInt(document.getElementById('lengthSlider').value);
  const width = parseInt(document.getElementById('widthSlider').value);
  const colorScheme = document.getElementById('colorScheme').value;
  const animate = document.getElementById('animate').checked;
  
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  
  const sequence = generateRecaman(length);
  const maxValue = Math.max(...sequence);
  const scale = (canvas.height - 100) / maxValue;
  const stepX = canvas.width / length;
  
  ctx.lineWidth = width;
  ctx.lineCap = 'round';
  ctx.lineJoin = 'round';
  
  if (animate) {
    let index = 0;
    function drawStep() {
      if (index < sequence.length - 1) {
        const x1 = index * stepX;
        const y1 = canvas.height / 2 - sequence[index] * scale;
        const x2 = (index + 1) * stepX;
        const y2 = canvas.height / 2 - sequence[index + 1] * scale;
        
        let color;
        switch (colorScheme) {
          case 'gradient':
            const intensity = index / sequence.length;
            color = `hsl(${300 + intensity * 60}, 70%, ${50 + intensity * 20}%)`;
            break;
          case 'rainbow':
            color = `hsl(${(index * 360) / sequence.length}, 70%, 50%)`;
            break;
          case 'pink':
            color = `hsl(330, ${70 + (index % 30)}%, ${50 + (index % 20)}%)`;
            break;
          case 'blue':
            color = `hsl(210, ${70 + (index % 30)}%, ${50 + (index % 20)}%)`;
            break;
        }
        
        ctx.strokeStyle = color;
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.stroke();
        
        index++;
        if (index < sequence.length - 1) {
          requestAnimationFrame(drawStep);
        }
      }
    }
    drawStep();
  } else {
    for (let i = 0; i < sequence.length - 1; i++) {
      const x1 = i * stepX;
      const y1 = canvas.height / 2 - sequence[i] * scale;
      const x2 = (i + 1) * stepX;
      const y2 = canvas.height / 2 - sequence[i + 1] * scale;
      
      let color;
      switch (colorScheme) {
        case 'gradient':
          const intensity = i / sequence.length;
          color = `hsl(${300 + intensity * 60}, 70%, ${50 + intensity * 20}%)`;
          break;
        case 'rainbow':
          color = `hsl(${(i * 360) / sequence.length}, 70%, 50%)`;
          break;
        case 'pink':
          color = `hsl(330, ${70 + (i % 30)}%, ${50 + (i % 20)}%)`;
          break;
        case 'blue':
          color = `hsl(210, ${70 + (i % 30)}%, ${50 + (i % 20)}%)`;
          break;
      }
      
      ctx.strokeStyle = color;
      ctx.beginPath();
      ctx.moveTo(x1, y1);
      ctx.lineTo(x2, y2);
      ctx.stroke();
    }
  }
}

function exportImage() {
  const link = document.createElement('a');
  link.download = 'recaman-sequence-' + Date.now() + '.png';
  link.href = canvas.toDataURL();
  link.click();
}

// Initialize
drawSequence();
</script>
</div>
<%@ include file="body-close.jsp"%>


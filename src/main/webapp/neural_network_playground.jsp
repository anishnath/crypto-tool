
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Interactive Neural Network Playground - Build, train, and visualize deep learning models in your browser">
<meta name="keywords" content="neural network, deep learning, machine learning, backpropagation, activation functions, playground">
<title>Neural Network Playground Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Neural Network Playground",
  "description": "Interactive neural network builder and visualizer with real-time training",
  "url": "https://8gwifi.org/neural_network_playground.jsp",
  "keywords": "neural network, deep learning, backpropagation, activation functions"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<style>
.nn-playground { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }

/* Network Canvas */
.network-canvas { 
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  padding: 30px;
  min-height: 500px;
  position: relative;
  overflow: hidden;
}

.network-canvas::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  background: radial-gradient(circle at 30% 50%, rgba(255,255,255,0.1) 0%, transparent 50%);
  pointer-events: none;
}

#nnCanvas { 
  border: 2px solid rgba(255,255,255,0.3);
  border-radius: 8px;
  background: rgba(255,255,255,0.95);
  cursor: crosshair;
  box-shadow: 0 8px 32px rgba(0,0,0,0.2);
}

/* Layer Builder */
.layer-builder { background: #f8f9fa; border-radius: 8px; padding: 15px; margin: 10px 0; }
.layer-item {
  background: white;
  border: 2px solid #dee2e6;
  border-radius: 8px;
  padding: 12px;
  margin: 8px 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: all 0.3s;
}
.layer-item:hover { border-color: #0d6efd; transform: translateX(5px); }
.layer-item.input-layer { border-left: 4px solid #28a745; }
.layer-item.hidden-layer { border-left: 4px solid #0d6efd; }
.layer-item.output-layer { border-left: 4px solid #dc3545; }

.neuron-viz {
  display: inline-block;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea, #764ba2);
  margin: 0 2px;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 0.6; transform: scale(1); }
  50% { opacity: 1; transform: scale(1.2); }
}

/* Control Panel */
.control-section {
  background: white;
  border: 1px solid #dee2e6;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
}

.control-section h6 {
  color: #495057;
  font-weight: 600;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 2px solid #e9ecef;
}

.activation-btn {
  padding: 8px 16px;
  margin: 5px;
  border: 2px solid #dee2e6;
  border-radius: 6px;
  background: white;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 13px;
  font-weight: 500;
}

.activation-btn:hover { border-color: #0d6efd; transform: translateY(-2px); }
.activation-btn.active {
  background: #0d6efd;
  color: white;
  border-color: #0d6efd;
}

/* Dataset Selector */
.dataset-btn {
  padding: 10px 15px;
  margin: 5px;
  border: 2px solid #dee2e6;
  border-radius: 8px;
  background: white;
  cursor: pointer;
  transition: all 0.3s;
  text-align: center;
}

.dataset-btn:hover { border-color: #0d6efd; }
.dataset-btn.active {
  border-color: #0d6efd;
  background: #e7f3ff;
  font-weight: 600;
}

.dataset-preview {
  display: inline-block;
  width: 40px;
  height: 40px;
  margin-bottom: 5px;
}

/* Training Controls */
.training-controls {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.play-btn {
  background: linear-gradient(135deg, #28a745, #20c997);
  color: white;
  border: none;
  border-radius: 8px;
  padding: 12px 24px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.play-btn:hover { transform: scale(1.05); box-shadow: 0 4px 12px rgba(40,167,69,0.4); }
.play-btn.playing { background: linear-gradient(135deg, #ffc107, #ff9800); }
.play-btn.playing::before { content: '⏸ '; }
.play-btn::before { content: '▶ '; }

.reset-btn {
  background: #6c757d;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 12px 24px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.reset-btn:hover { background: #5a6268; }

/* Metrics Display */
.metric-card {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
  border-radius: 8px;
  padding: 15px;
  text-align: center;
  margin-bottom: 10px;
}

.metric-label { font-size: 12px; opacity: 0.9; margin-bottom: 5px; }
.metric-value { font-size: 24px; font-weight: bold; font-family: 'Courier New', monospace; }

/* Learning Rate Slider */
.slider-container { margin: 15px 0; }
.slider-label {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 13px;
  font-weight: 500;
}

.custom-slider {
  -webkit-appearance: none;
  width: 100%;
  height: 6px;
  border-radius: 5px;
  background: #dee2e6;
  outline: none;
}

.custom-slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: #0d6efd;
  cursor: pointer;
}

.custom-slider::-moz-range-thumb {
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: #0d6efd;
  cursor: pointer;
  border: none;
}

/* Activation Function Graphs */
.activation-graph {
  width: 100%;
  height: 80px;
  background: white;
  border: 1px solid #dee2e6;
  border-radius: 6px;
  margin: 10px 0;
}

/* Chart Container */
.chart-container {
  background: white;
  border: 1px solid #dee2e6;
  border-radius: 8px;
  padding: 15px;
  height: 300px;
  margin: 10px 0;
}

/* Data Points */
.data-point-class0 { fill: #dc3545; stroke: #721c24; }
.data-point-class1 { fill: #28a745; stroke: #155724; }

/* Info Cards */
.info-card {
  background: #e7f3ff;
  border-left: 4px solid #0d6efd;
  border-radius: 6px;
  padding: 15px;
  margin: 15px 0;
}

.info-card h6 { color: #0d6efd; margin-bottom: 10px; }
.info-card p { margin: 0; font-size: 14px; color: #495057; }

/* Responsive */
@media (max-width: 768px) {
  .network-canvas { padding: 15px; min-height: 300px; }
  #nnCanvas { width: 100% !important; }
  .training-controls { flex-direction: column; }
  .play-btn, .reset-btn { width: 100%; }
}

/* Loading Animation */
.training-indicator {
  display: inline-block;
  width: 12px;
  height: 12px;
  border: 2px solid rgba(255,255,255,.3);
  border-radius: 50%;
  border-top-color: #fff;
  animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.layer-add-btn {
  background: #28a745;
  color: white;
  border: none;
  border-radius: 6px;
  padding: 8px 16px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s;
}

.layer-add-btn:hover { background: #218838; transform: scale(1.05); }

.layer-remove-btn {
  background: #dc3545;
  color: white;
  border: none;
  border-radius: 4px;
  padding: 4px 12px;
  cursor: pointer;
  font-size: 12px;
  transition: all 0.3s;
}

.layer-remove-btn:hover { background: #c82333; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🧠 Neural Network Playground</h1>
<p>Build, train, and visualize neural networks in real-time. Experiment with architectures, activation functions, and watch your network learn!</p>

<!-- Quick Access -->
<div class="mb-2">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#visualization" class="btn btn-outline-primary">Visualization</a>
    <a href="#training" class="btn btn-outline-primary">Training</a>
    <a href="#dataset" class="btn btn-outline-primary">Dataset</a>
    <a href="#architecture" class="btn btn-outline-primary">Architecture</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="nn-playground">
  <div class="row">
    <!-- Left: Network Visualization -->
    <div class="col-lg-8 mb-4">
      <!-- Network Canvas -->
      <div class="card mb-4" id="visualization">
        <div class="card-header">
          <h5 class="mb-0">🎨 Network Visualization & Dataset</h5>
        </div>
        <div class="card-body p-0">
          <div class="network-canvas">
            <canvas id="nnCanvas" width="700" height="450"></canvas>
          </div>
        </div>
        <div class="card-footer">
          <small class="text-muted">
            <span class="badge bg-success">●</span> Class 1 (Green)
            <span class="badge bg-danger ms-2">●</span> Class 0 (Red)
            • Click canvas to add points • Current class: <strong id="currentClass">Class 1</strong>
          </small>
        </div>
      </div>

      <!-- Training Metrics -->
      <div class="card mb-4" id="training">
        <div class="card-header">
          <h5 class="mb-0">📊 Training Progress</h5>
        </div>
        <div class="card-body">
          <div class="chart-container">
            <canvas id="lossChart"></canvas>
          </div>
          <div class="row mt-3">
            <div class="col-md-4">
              <div class="metric-card">
                <div class="metric-label">Epoch</div>
                <div class="metric-value" id="epochDisplay">0</div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="metric-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                <div class="metric-label">Loss</div>
                <div class="metric-value" id="lossDisplay">—</div>
              </div>
            </div>
            <div class="col-md-4">
              <div class="metric-card" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                <div class="metric-label">Accuracy</div>
                <div class="metric-value" id="accDisplay">—</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Info Card -->
      <div class="info-card">
        <h6>💡 How to Use</h6>
        <p>
          <strong>1.</strong> Select a dataset or click the canvas to create custom data points<br>
          <strong>2.</strong> Design your network architecture by adding/removing layers<br>
          <strong>3.</strong> Choose activation functions and adjust hyperparameters<br>
          <strong>4.</strong> Hit Play and watch your neural network learn in real-time!
        </p>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4">
      <!-- Dataset Selection -->
      <div class="control-section" id="dataset">
        <h6>📦 Dataset Selection</h6>
        <div class="row">
          <div class="col-6">
            <div class="dataset-btn active" data-dataset="spiral">
              <canvas class="dataset-preview" id="spiralPreview"></canvas>
              <div>Spiral</div>
            </div>
          </div>
          <div class="col-6">
            <div class="dataset-btn" data-dataset="xor">
              <canvas class="dataset-preview" id="xorPreview"></canvas>
              <div>XOR</div>
            </div>
          </div>
          <div class="col-6">
            <div class="dataset-btn" data-dataset="circle">
              <canvas class="dataset-preview" id="circlePreview"></canvas>
              <div>Circle</div>
            </div>
          </div>
          <div class="col-6">
            <div class="dataset-btn" data-dataset="moons">
              <canvas class="dataset-preview" id="moonsPreview"></canvas>
              <div>Moons</div>
            </div>
          </div>
        </div>
        <button class="btn btn-sm btn-outline-secondary w-100 mt-2" id="btnClearData">Clear All Points</button>
      </div>

      <!-- Network Architecture -->
      <div class="control-section" id="architecture">
        <h6>🏗️ Network Architecture</h6>
        <div class="layer-builder" id="layerBuilder">
          <!-- Layers will be dynamically added here -->
        </div>
        <button class="layer-add-btn w-100" id="btnAddLayer">+ Add Hidden Layer</button>
      </div>

      <!-- Activation Functions -->
      <div class="control-section">
        <h6>⚡ Activation Function</h6>
        <div class="text-center">
          <button class="activation-btn active" data-activation="relu">ReLU</button>
          <button class="activation-btn" data-activation="sigmoid">Sigmoid</button>
          <button class="activation-btn" data-activation="tanh">Tanh</button>
          <button class="activation-btn" data-activation="leaky_relu">Leaky ReLU</button>
        </div>
        <canvas id="activationGraph" class="activation-graph mt-3"></canvas>
      </div>

      <!-- Hyperparameters -->
      <div class="control-section">
        <h6>🎛️ Hyperparameters</h6>
        
        <div class="slider-container">
          <div class="slider-label">
            <span>Learning Rate</span>
            <strong id="lrValue">0.01</strong>
          </div>
          <input type="range" class="custom-slider" id="learningRate" min="0.001" max="0.5" step="0.001" value="0.01">
        </div>

        <div class="slider-container">
          <div class="slider-label">
            <span>Batch Size</span>
            <strong id="batchValue">32</strong>
          </div>
          <input type="range" class="custom-slider" id="batchSize" min="1" max="64" step="1" value="32">
        </div>

        <div class="slider-container">
          <div class="slider-label">
            <span>Training Speed</span>
            <strong id="speedValue">Normal</strong>
          </div>
          <input type="range" class="custom-slider" id="trainSpeed" min="1" max="10" step="1" value="5">
        </div>
      </div>

      <!-- Training Controls -->
      <div class="control-section">
        <h6>🎮 Training Controls</h6>
        <div class="training-controls">
          <button class="play-btn" id="btnPlayPause">Train Network</button>
          <button class="reset-btn" id="btnReset">🔄 Reset</button>
        </div>
        <div class="form-check mt-3">
          <input class="form-check-input" type="checkbox" id="showDecisionBoundary" checked>
          <label class="form-check-label" for="showDecisionBoundary">
            Show Decision Boundary
          </label>
        </div>
      </div>

      <!-- Data Point Toggle -->
      <div class="control-section">
        <h6>🎯 Add Data Points</h6>
        <div class="btn-group w-100" role="group">
          <button type="button" class="btn btn-success active" id="btnClass1">Class 1 (Green)</button>
          <button type="button" class="btn btn-outline-danger" id="btnClass0">Class 0 (Red)</button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- moved to end -->

<script>
window.addEventListener('DOMContentLoaded', () => {
  // ============== CONFIGURATION ==============
  const canvas = document.getElementById('nnCanvas');
  const ctx = canvas.getContext('2d');
  
  let network = {
    layers: [
      { type: 'input', neurons: 2, weights: null, biases: null },
      { type: 'hidden', neurons: 4, activation: 'relu', weights: null, biases: null },
      { type: 'hidden', neurons: 4, activation: 'relu', weights: null, biases: null },
      { type: 'output', neurons: 2, activation: 'sigmoid', weights: null, biases: null }
    ]
  };

  let dataPoints = [];
  let currentClass = 1;
  let isTraining = false;
  let epoch = 0;
  let trainingInterval = null;
  let lossHistory = [];
  let currentActivation = 'relu';
  let learningRate = 0.01;
  let batchSize = 32;

  // ============== HELPER FUNCTIONS ==============
  function randn() {
    let u=0,v=0;
    while(!u) u=Math.random();
    while(!v) v=Math.random();
    return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v);
  }

  function relu(x) { return Math.max(0, x); }
  function reluDerivative(x) { return x > 0 ? 1 : 0; }
  
  function sigmoid(x) { return 1 / (1 + Math.exp(-Math.max(-500, Math.min(500, x)))); }
  function sigmoidDerivative(x) { const s = sigmoid(x); return s * (1 - s); }
  
  function tanh(x) { return Math.tanh(x); }
  function tanhDerivative(x) { const t = Math.tanh(x); return 1 - t * t; }
  
  function leakyRelu(x) { return x > 0 ? x : 0.01 * x; }
  function leakyReluDerivative(x) { return x > 0 ? 1 : 0.01; }

  function activate(x, activation) {
    switch(activation) {
      case 'relu': return relu(x);
      case 'sigmoid': return sigmoid(x);
      case 'tanh': return tanh(x);
      case 'leaky_relu': return leakyRelu(x);
      default: return relu(x);
    }
  }

  function activateDerivative(x, activation) {
    switch(activation) {
      case 'relu': return reluDerivative(x);
      case 'sigmoid': return sigmoidDerivative(x);
      case 'tanh': return tanhDerivative(x);
      case 'leaky_relu': return leakyReluDerivative(x);
      default: return reluDerivative(x);
    }
  }

  // ============== NETWORK INITIALIZATION ==============
  function initializeNetwork() {
    for(let i = 1; i < network.layers.length; i++) {
      const prevNeurons = network.layers[i-1].neurons;
      const currNeurons = network.layers[i].neurons;
      
      network.layers[i].weights = Array(currNeurons).fill(0).map(() => 
        Array(prevNeurons).fill(0).map(() => randn() * 0.5)
      );
      network.layers[i].biases = Array(currNeurons).fill(0).map(() => randn() * 0.1);
    }
    epoch = 0;
    lossHistory = [];
  }

  // ============== FORWARD PROPAGATION ==============
  function forward(input) {
    let activations = [input];
    let zValues = [input];
    
    for(let i = 1; i < network.layers.length; i++) {
      const layer = network.layers[i];
      const prevActivation = activations[i-1];
      const z = [];
      const a = [];
      
      for(let j = 0; j < layer.neurons; j++) {
        let sum = layer.biases[j];
        for(let k = 0; k < prevActivation.length; k++) {
          sum += layer.weights[j][k] * prevActivation[k];
        }
        z.push(sum);
        a.push(activate(sum, layer.activation));
      }
      
      zValues.push(z);
      activations.push(a);
    }
    
    return { activations, zValues };
  }

  // ============== BACKWARD PROPAGATION ==============
  function backward(input, target, activations, zValues) {
    const gradients = { weights: [], biases: [] };
    let delta = [];
    
    // Output layer error
    const output = activations[activations.length - 1];
    for(let i = 0; i < output.length; i++) {
      delta[i] = (output[i] - target[i]) * activateDerivative(zValues[zValues.length - 1][i], 
                                                                network.layers[network.layers.length - 1].activation);
    }
    
    // Backpropagate through layers
    for(let i = network.layers.length - 1; i >= 1; i--) {
      const layer = network.layers[i];
      const prevActivation = activations[i-1];
      
      // Compute weight gradients
      const weightGrad = Array(layer.neurons).fill(0).map(() => Array(prevActivation.length).fill(0));
      const biasGrad = Array(layer.neurons).fill(0);
      
      for(let j = 0; j < layer.neurons; j++) {
        biasGrad[j] = delta[j];
        for(let k = 0; k < prevActivation.length; k++) {
          weightGrad[j][k] = delta[j] * prevActivation[k];
        }
      }
      
      gradients.weights.unshift(weightGrad);
      gradients.biases.unshift(biasGrad);
      
      // Propagate error to previous layer
      if(i > 1) {
        const nextDelta = Array(prevActivation.length).fill(0);
        for(let j = 0; j < prevActivation.length; j++) {
          let sum = 0;
          for(let k = 0; k < layer.neurons; k++) {
            sum += layer.weights[k][j] * delta[k];
          }
          nextDelta[j] = sum * activateDerivative(zValues[i-1][j], network.layers[i-1].activation);
        }
        delta = nextDelta;
      }
    }
    
    return gradients;
  }

  // ============== TRAINING STEP ==============
  function trainStep() {
    if(dataPoints.length === 0) return;
    
    let totalLoss = 0;
    let correct = 0;
    const gradientAccum = { weights: [], biases: [] };
    
    // Initialize gradient accumulator
    for(let i = 1; i < network.layers.length; i++) {
      gradientAccum.weights.push(Array(network.layers[i].neurons).fill(0).map(() => 
        Array(network.layers[i-1].neurons).fill(0)));
      gradientAccum.biases.push(Array(network.layers[i].neurons).fill(0));
    }
    
    // Mini-batch training
    const batchIndices = [];
    for(let i = 0; i < Math.min(batchSize, dataPoints.length); i++) {
      batchIndices.push(Math.floor(Math.random() * dataPoints.length));
    }
    
    for(let idx of batchIndices) {
      const point = dataPoints[idx];
      const input = [(point.x - 350) / 350, (point.y - 225) / 225]; // Normalize
      const target = point.class === 1 ? [0, 1] : [1, 0];
      
      const { activations, zValues } = forward(input);
      const gradients = backward(input, target, activations, zValues);
      
      // Accumulate gradients
      for(let i = 0; i < gradients.weights.length; i++) {
        for(let j = 0; j < gradients.weights[i].length; j++) {
          for(let k = 0; k < gradients.weights[i][j].length; k++) {
            gradientAccum.weights[i][j][k] += gradients.weights[i][j][k];
          }
        }
        for(let j = 0; j < gradients.biases[i].length; j++) {
          gradientAccum.biases[i][j] += gradients.biases[i][j];
        }
      }
      
      // Compute loss and accuracy
      const output = activations[activations.length - 1];
      const loss = -Math.log(output[point.class] + 1e-10);
      totalLoss += loss;
      
      const prediction = output[0] > output[1] ? 0 : 1;
      if(prediction === point.class) correct++;
    }
    
    // Update weights
    for(let i = 1; i < network.layers.length; i++) {
      const layer = network.layers[i];
      for(let j = 0; j < layer.neurons; j++) {
        layer.biases[j] -= learningRate * gradientAccum.biases[i-1][j] / batchIndices.length;
        for(let k = 0; k < layer.weights[j].length; k++) {
          layer.weights[j][k] -= learningRate * gradientAccum.weights[i-1][j][k] / batchIndices.length;
        }
      }
    }
    
    epoch++;
    const avgLoss = totalLoss / batchIndices.length;
    const accuracy = correct / batchIndices.length;
    
    lossHistory.push(avgLoss);
    if(lossHistory.length > 100) lossHistory.shift();
    
    updateMetrics(avgLoss, accuracy);
  }

  // ============== VISUALIZATION ==============
  function drawNetwork() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // Draw decision boundary
    if(document.getElementById('showDecisionBoundary').checked && network.layers[1].weights) {
      drawDecisionBoundary();
    }
    
    // Draw data points
    dataPoints.forEach(point => {
      ctx.beginPath();
      ctx.arc(point.x, point.y, 6, 0, 2 * Math.PI);
      ctx.fillStyle = point.class === 1 ? '#28a745' : '#dc3545';
      ctx.fill();
      ctx.strokeStyle = point.class === 1 ? '#155724' : '#721c24';
      ctx.lineWidth = 2;
      ctx.stroke();
    });
  }

  function drawDecisionBoundary() {
    const resolution = 5;
    for(let x = 0; x < canvas.width; x += resolution) {
      for(let y = 0; y < canvas.height; y += resolution) {
        const input = [(x - 350) / 350, (y - 225) / 225];
        const result = forward(input);
        const output = result.activations[result.activations.length - 1];
        const prob = output[1];

        const alpha = Math.abs(prob - 0.5) * 0.3;
        ctx.fillStyle = prob > 0.5 ? ('rgba(40,167,69,' + alpha + ')') : ('rgba(220,53,69,' + alpha + ')');
        ctx.fillRect(x, y, resolution, resolution);
      }
    }
  }

  function updateMetrics(loss, accuracy) {
    document.getElementById('epochDisplay').textContent = epoch;
    document.getElementById('lossDisplay').textContent = loss.toFixed(4);
    document.getElementById('accDisplay').textContent = (accuracy * 100).toFixed(1) + '%';
    
    updateLossChart();
  }

  // ============== CHART UPDATES ==============
  let lossChart;
  function initLossChart() {
    const ctx = document.getElementById('lossChart').getContext('2d');
    lossChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: [],
        datasets: [{
          label: 'Training Loss',
          data: [],
          borderColor: '#f5576c',
          backgroundColor: 'rgba(245,87,108,0.1)',
          borderWidth: 2,
          tension: 0.4,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true, title: { display: true, text: 'Loss' }},
          x: { title: { display: true, text: 'Epoch' }}
        }
      }
    });
  }

  function updateLossChart() {
    lossChart.data.labels = lossHistory.map((_, i) => i);
    lossChart.data.datasets[0].data = lossHistory;
    lossChart.update('none');
  }

  // ============== DATASET GENERATION ==============
  function generateSpiral() {
    dataPoints = [];
    const points = 100;
    for(let i = 0; i < points / 2; i++) {
      const r = i / points * 5;
      const t = 1.25 * i / points * 2 * Math.PI;
      dataPoints.push({
        x: 350 + r * 50 * Math.cos(t) + randn() * 5,
        y: 225 + r * 50 * Math.sin(t) + randn() * 5,
        class: 0
      });
      dataPoints.push({
        x: 350 + r * 50 * Math.cos(t + Math.PI) + randn() * 5,
        y: 225 + r * 50 * Math.sin(t + Math.PI) + randn() * 5,
        class: 1
      });
    }
    drawNetwork();
  }

  function generateXOR() {
    dataPoints = [];
    const points = 50;
    for(let i = 0; i < points; i++) {
      dataPoints.push({ x: 200 + randn() * 30, y: 125 + randn() * 30, class: 0 });
      dataPoints.push({ x: 500 + randn() * 30, y: 125 + randn() * 30, class: 0 });
      dataPoints.push({ x: 200 + randn() * 30, y: 325 + randn() * 30, class: 1 });
      dataPoints.push({ x: 500 + randn() * 30, y: 325 + randn() * 30, class: 1 });
    }
    drawNetwork();
  }

  function generateCircle() {
    dataPoints = [];
    const points = 100;
    for(let i = 0; i < points; i++) {
      const r = Math.random() * 80;
      const t = Math.random() * 2 * Math.PI;
      dataPoints.push({
        x: 350 + r * Math.cos(t),
        y: 225 + r * Math.sin(t),
        class: 0
      });
      
      const r2 = 120 + Math.random() * 60;
      const t2 = Math.random() * 2 * Math.PI;
      dataPoints.push({
        x: 350 + r2 * Math.cos(t2),
        y: 225 + r2 * Math.sin(t2),
        class: 1
      });
    }
    drawNetwork();
  }

  function generateMoons() {
    dataPoints = [];
    const points = 100;
    for(let i = 0; i < points / 2; i++) {
      const t = Math.PI * i / (points / 2);
      dataPoints.push({
        x: 350 + 100 * Math.cos(t) + randn() * 10,
        y: 225 + 50 * Math.sin(t) + randn() * 10,
        class: 0
      });
      dataPoints.push({
        x: 350 + 100 * Math.cos(t + Math.PI) + randn() * 10,
        y: 175 + 50 * Math.sin(t + Math.PI) + randn() * 10,
        class: 1
      });
    }
    drawNetwork();
  }

  // ============== LAYER MANAGEMENT ==============
  function renderLayers() {
    const builder = document.getElementById('layerBuilder');
    builder.innerHTML = '';
    
    network.layers.forEach((layer, idx) => {
      const div = document.createElement('div');
      div.className = 'layer-item ' + layer.type + '-layer';

      const info = document.createElement('div');
      var title = (layer.type === 'input') ? 'Input' : ((layer.type === 'output') ? 'Output' : ('Hidden ' + idx));
      var neuronIcons = Array(Math.min(layer.neurons, 10)).fill(0).map(function() { return '<span class="neuron-viz"></span>'; }).join('');
      var moreIcons = (layer.neurons > 10) ? ' ...' : '';
      info.innerHTML =
        '<strong>' + title + '</strong>' +
        '<div style="margin-top:5px">' +
          neuronIcons +
          moreIcons +
          '<span class="ms-2 text-muted">' + layer.neurons + ' neurons</span>' +
        '</div>';
      
      div.appendChild(info);
      
      if(layer.type === 'hidden') {
        const controls = document.createElement('div');
        const select = document.createElement('input');
        select.type = 'number';
        select.min = 1;
        select.max = 16;
        select.value = layer.neurons;
        select.className = 'form-control form-control-sm';
        select.style.width = '60px';
        select.style.display = 'inline-block';
        select.addEventListener('change', (e) => {
          layer.neurons = parseInt(e.target.value);
          initializeNetwork();
          renderLayers();
        });
        
        const removeBtn = document.createElement('button');
        removeBtn.className = 'layer-remove-btn ms-2';
        removeBtn.textContent = '✕ Remove';
        removeBtn.addEventListener('click', () => {
          if(network.layers.filter(l => l.type === 'hidden').length > 1) {
            network.layers.splice(idx, 1);
            initializeNetwork();
            renderLayers();
          }
        });
        
        controls.appendChild(select);
        controls.appendChild(removeBtn);
        div.appendChild(controls);
      }
      
      builder.appendChild(div);
    });
  }

  // ============== ACTIVATION FUNCTION GRAPH ==============
  function drawActivationGraph(activation) {
    const canvas = document.getElementById('activationGraph');
    const ctx = canvas.getContext('2d');
    canvas.width = canvas.offsetWidth;
    canvas.height = 80;
    
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.strokeStyle = '#0d6efd';
    ctx.lineWidth = 2;
    ctx.beginPath();
    
    for(let x = 0; x < canvas.width; x++) {
      const input = (x / canvas.width - 0.5) * 10;
      const output = activate(input, activation);
      const y = canvas.height / 2 - output * 20;
      
      if(x === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }
    
    ctx.stroke();
    
    // Draw axes
    ctx.strokeStyle = '#dee2e6';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(0, canvas.height / 2);
    ctx.lineTo(canvas.width, canvas.height / 2);
    ctx.moveTo(canvas.width / 2, 0);
    ctx.lineTo(canvas.width / 2, canvas.height);
    ctx.stroke();
  }

  // ============== DATASET PREVIEW CANVASES ==============
  function drawDatasetPreviews() {
    const previews = {
      spiral: { canvas: document.getElementById('spiralPreview'), gen: generateSpiralPreview },
      xor: { canvas: document.getElementById('xorPreview'), gen: generateXORPreview },
      circle: { canvas: document.getElementById('circlePreview'), gen: generateCirclePreview },
      moons: { canvas: document.getElementById('moonsPreview'), gen: generateMoonsPreview }
    };
    
    Object.values(previews).forEach(p => {
      p.canvas.width = 40;
      p.canvas.height = 40;
      p.gen(p.canvas);
    });
  }

  function generateSpiralPreview(canvas) {
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#dc3545';
    for(let i = 0; i < 10; i++) {
      const r = i / 10 * 15;
      const t = i / 10 * Math.PI;
      ctx.fillRect(20 + r * Math.cos(t) - 1, 20 + r * Math.sin(t) - 1, 2, 2);
    }
    ctx.fillStyle = '#28a745';
    for(let i = 0; i < 10; i++) {
      const r = i / 10 * 15;
      const t = i / 10 * Math.PI + Math.PI;
      ctx.fillRect(20 + r * Math.cos(t) - 1, 20 + r * Math.sin(t) - 1, 2, 2);
    }
  }

  function generateXORPreview(canvas) {
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#dc3545';
    ctx.fillRect(5, 5, 10, 10);
    ctx.fillRect(25, 5, 10, 10);
    ctx.fillStyle = '#28a745';
    ctx.fillRect(5, 25, 10, 10);
    ctx.fillRect(25, 25, 10, 10);
  }

  function generateCirclePreview(canvas) {
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#dc3545';
    ctx.beginPath();
    ctx.arc(20, 20, 8, 0, 2 * Math.PI);
    ctx.fill();
    ctx.fillStyle = '#28a745';
    ctx.beginPath();
    ctx.arc(20, 20, 15, 0, 2 * Math.PI);
    ctx.fill();
    ctx.fillStyle = 'white';
    ctx.beginPath();
    ctx.arc(20, 20, 12, 0, 2 * Math.PI);
    ctx.fill();
  }

  function generateMoonsPreview(canvas) {
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#dc3545';
    ctx.beginPath();
    ctx.arc(20, 15, 10, 0, Math.PI);
    ctx.fill();
    ctx.fillStyle = '#28a745';
    ctx.beginPath();
    ctx.arc(20, 25, 10, Math.PI, 2 * Math.PI);
    ctx.fill();
  }

  // ============== EVENT LISTENERS ==============
  canvas.addEventListener('click', (e) => {
    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    
    dataPoints.push({ x, y, class: currentClass });
    drawNetwork();
  });

  document.getElementById('btnClass1').addEventListener('click', function() {
    currentClass = 1;
    this.classList.add('active');
    this.classList.remove('btn-outline-success');
    document.getElementById('btnClass0').classList.remove('active');
    document.getElementById('btnClass0').classList.add('btn-outline-danger');
    document.getElementById('currentClass').textContent = 'Class 1';
  });

  document.getElementById('btnClass0').addEventListener('click', function() {
    currentClass = 0;
    this.classList.add('active');
    this.classList.remove('btn-outline-danger');
    document.getElementById('btnClass1').classList.remove('active');
    document.getElementById('btnClass1').classList.add('btn-outline-success');
    document.getElementById('currentClass').textContent = 'Class 0';
  });

  document.querySelectorAll('.dataset-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      document.querySelectorAll('.dataset-btn').forEach(b => b.classList.remove('active'));
      this.classList.add('active');
      
      const dataset = this.dataset.dataset;
      switch(dataset) {
        case 'spiral': generateSpiral(); break;
        case 'xor': generateXOR(); break;
        case 'circle': generateCircle(); break;
        case 'moons': generateMoons(); break;
      }
      
      if(!isTraining) {
        initializeNetwork();
      }
    });
  });

  document.getElementById('btnClearData').addEventListener('click', () => {
    dataPoints = [];
    drawNetwork();
  });

  document.querySelectorAll('.activation-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      document.querySelectorAll('.activation-btn').forEach(b => b.classList.remove('active'));
      this.classList.add('active');
      
      currentActivation = this.dataset.activation;
      for(let i = 1; i < network.layers.length - 1; i++) {
        network.layers[i].activation = currentActivation;
      }
      
      drawActivationGraph(currentActivation);
      initializeNetwork();
    });
  });

  document.getElementById('btnAddLayer').addEventListener('click', () => {
    if(network.layers.length < 8) {
      network.layers.splice(network.layers.length - 1, 0, {
        type: 'hidden',
        neurons: 4,
        activation: currentActivation,
        weights: null,
        biases: null
      });
      initializeNetwork();
      renderLayers();
    }
  });

  document.getElementById('learningRate').addEventListener('input', (e) => {
    learningRate = parseFloat(e.target.value);
    document.getElementById('lrValue').textContent = learningRate.toFixed(3);
  });

  document.getElementById('batchSize').addEventListener('input', (e) => {
    batchSize = parseInt(e.target.value);
    document.getElementById('batchValue').textContent = batchSize;
  });

  document.getElementById('trainSpeed').addEventListener('input', (e) => {
    const speeds = ['Slowest', 'Slower', 'Slow', 'Normal', 'Normal', 'Fast', 'Faster', 'Fastest', 'Ultra', 'Instant'];
    document.getElementById('speedValue').textContent = speeds[parseInt(e.target.value) - 1];
  });

  document.getElementById('btnPlayPause').addEventListener('click', function() {
    isTraining = !isTraining;
    
    if(isTraining) {
      this.classList.add('playing');
      this.textContent = 'Pause Training';
      
      const speed = parseInt(document.getElementById('trainSpeed').value);
      const interval = Math.max(10, 200 - speed * 15);
      
      trainingInterval = setInterval(() => {
        trainStep();
        drawNetwork();
      }, interval);
    } else {
      this.classList.remove('playing');
      this.textContent = 'Resume Training';
      clearInterval(trainingInterval);
    }
  });

  document.getElementById('btnReset').addEventListener('click', () => {
    isTraining = false;
    clearInterval(trainingInterval);
    document.getElementById('btnPlayPause').classList.remove('playing');
    document.getElementById('btnPlayPause').textContent = 'Train Network';
    
    initializeNetwork();
    drawNetwork();
    updateMetrics(0, 0);
  });

  document.getElementById('showDecisionBoundary').addEventListener('change', () => {
    drawNetwork();
  });

  // ============== INITIALIZATION ==============
  initializeNetwork();
  initLossChart();
  renderLayers();
  generateSpiral();
  drawActivationGraph('relu');
  drawDatasetPreviews();
  
  console.log('🧠 Neural Network Playground loaded successfully!');
});
</script>

<hr>
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">About this Playground</h5>
  </div>
  <div class="card-body">
    <p class="mb-2">
      This interactive tool lets you build and train a small neural network to classify 2D points. You can add points manually or use preset datasets, change the network architecture (layers and neurons), choose activation functions, and watch the decision boundary evolve as training progresses.
    </p>
    <div class="row">
      <div class="col-md-6">
        <h6 class="mt-2">What is a Neural Network?</h6>
        <ul class="mb-2">
          <li><strong>Layers:</strong> Input → one or more Hidden layers → Output</li>
          <li><strong>Neurons:</strong> Compute weighted sums and apply an activation function</li>
          <li><strong>Weights & Biases:</strong> Learnable parameters updated during training</li>
        </ul>
        <h6 class="mt-3">What will you see?</h6>
        <ul class="mb-0">
          <li><strong>Decision boundary:</strong> Colored background showing model’s prediction regions</li>
          <li><strong>Loss curve:</strong> How “wrong” the model is (lower is better)</li>
          <li><strong>Accuracy:</strong> Percent of correctly classified points</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6 class="mt-2">How training works (high level)</h6>
        <ol class="mb-2">
          <li><strong>Forward pass:</strong> Inputs flow through layers to produce outputs (probabilities)</li>
          <li><strong>Loss:</strong> Measures the error (e.g., cross-entropy)</li>
          <li><strong>Backpropagation:</strong> Computes gradients of loss w.r.t. weights</li>
          <li><strong>Gradient descent:</strong> Updates weights to reduce loss using the learning rate</li>
        </ol>
        <h6 class="mt-3">Activation functions</h6>
        <ul class="mb-0">
          <li><strong>ReLU:</strong> Fast, helps deep nets; outputs 0 for negatives</li>
          <li><strong>Sigmoid:</strong> Outputs 0–1 probabilities; can saturate</li>
          <li><strong>Tanh:</strong> Outputs −1..1; zero-centered</li>
          <li><strong>Leaky ReLU:</strong> Like ReLU but allows small negative slope</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<!-- Interpretation & Datasets -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">Interpreting Results</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>Reading the visuals</h6>
        <ul class="mb-2">
          <li><strong>Decision boundary:</strong> Green areas predict Class 1; red areas predict Class 0. The sharper and better aligned the boundary, the better the fit.</li>
          <li><strong>Loss:</strong> Should trend down as training progresses. If it stalls or increases, try a smaller learning rate or adjust the architecture.</li>
          <li><strong>Accuracy:</strong> Higher is better, but be mindful of class balance (imbalanced data can mislead accuracy).</li>
        </ul>
        <h6>Troubleshooting</h6>
        <ul class="mb-0">
          <li><strong>Underfitting:</strong> Boundary is too simple; add neurons/layers or change activation</li>
          <li><strong>Overfitting:</strong> Boundary is too wiggly; reduce neurons/layers or gather more data</li>
          <li><strong>Training unstable:</strong> Lower the learning rate</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Datasets (what to expect)</h6>
        <ul class="mb-0">
          <li><strong>Spiral:</strong> Complex, non-linear; requires deeper/wider hidden layers</li>
          <li><strong>XOR:</strong> Classic non-linear problem; single hidden layer solves it</li>
          <li><strong>Circle (concentric):</strong> Requires non-linear boundary; activations matter</li>
          <li><strong>Moons:</strong> Curved classes; neural nets capture shape better than lines</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- E-E-A-T: About & Learning Outcomes (Neural Networks) -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>Interactive neural network sandbox: choose layers, neurons, activations, and observe decision boundaries and loss curves on synthetic datasets. Trains in‑browser using gradient descent variants.</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>Relate depth/width and activations to representational capacity.</li>
      <li>Observe under/overfitting and regularization effects.</li>
      <li>Understand how learning rate and batch size influence training.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>All training/inference runs locally on synthetic data by default.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Neural Network Playground",
  "url": "https://8gwifi.org/neural_network_playground.jsp",
  "dateModified": "2025-11-19",
  "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
  "reviewedBy": {"@type": "Person", "name": "Anish Nath"},
  "publisher": {"@type": "Organization", "name": "8gwifi.org"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Neural Network Playground","item":"https://8gwifi.org/neural_network_playground.jsp"}
  ]
}
</script>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>

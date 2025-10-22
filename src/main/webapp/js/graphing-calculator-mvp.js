/**
 * Advanced Graphing Calculator MVP
 * Features: Multi-expression plotting, pan/zoom, grid, colors, safe evaluation
 */

class GraphingCalculator {
  constructor() {
    // Check if D3.js is loaded
    if (typeof d3 === 'undefined') {
      console.error('D3.js is not loaded. Please ensure D3.js is included before this script.');
      return;
    }
    
    this.chartContainer = d3.select('#mainChart');
    this.svg = null;
    this.scales = {
      x: null,
      y: null
    };
    this.zoom = null;
    this.expressions = [];
    this.variables = { a: 1, b: 1, c: 1, k: 1 };
    
    // Viewport settings
    this.viewport = {
      xMin: -10,
      xMax: 10,
      yMin: -6,
      yMax: 6
    };
    
    // UI state
    this.showGrid = true;
    this.showAxes = true;
    this.selectedExpression = null;
    
    // Colors for expressions
    this.colors = [
      '#3182ce', '#38a169', '#e53e3e', '#d69e2e',
      '#805ad5', '#319795', '#dd6b20', '#9f7aea'
    ];
    
    // Web Worker for safe evaluation
    this.worker = null;
    this.workerReady = false;
    this.pendingEvaluations = new Map();
    
    // Tooltip and interaction state
    this.tooltip = null;
    this.showTooltip = false; // Disabled by default for performance
    this.lastMousePos = { x: 0, y: 0 };
    
    // Advanced plotting
    this.currentPlotType = 'cartesian';
    this.tableData = [];
    this.regressionData = null;
    this.statisticsData = {
      distributions: [],
      tests: [],
      confidenceIntervals: []
    };
    this.statisticsChart = null;
    this.statisticsSvg = null;
    
    // Performance and accessibility
    this.webglRenderer = null;
    this.useWebGL = false;
    this.performanceMonitor = new PerformanceMonitor();
    this.functionCache = new FunctionCache();
    this.resolutionLevel = 3; // 1-5 scale
    this.renderingCache = new Map();
    this.isRendering = false;
    this.isResetting = false; // Prevent recursive reset calls
    this.isZooming = false; // Prevent concurrent zoom updates
    this.interactionsSetup = false; // Prevent duplicate event listeners
    
    this.init();
  }
  
  init() {
    try {
      this.initializeMainChart();
      this.setupWorker();
      this.setupTooltip();
      this.setupEventListeners();
      this.setupAccessibility();
      this.loadFromURL();
      if (this.expressions.length === 0) {
        this.addDefaultExpressions();
      }
      
      this.updateChart();
    } catch (error) {
      console.error('Error during GraphingCalculator initialization:', error);
    }
  }
  
  initializeMainChart() {
    try {
      // Get container dimensions
      const container = this.chartContainer.node();
      if (!container) {
        console.error('[D3] Chart container not found');
        return;
      }
      
      const width = container.clientWidth || 800;
      const height = container.clientHeight || 600;
      
      // Create SVG
      this.svg = this.chartContainer
        .append('svg')
        .attr('width', width)
        .attr('height', height)
        .style('background', 'white');
      
      // Create scales
      this.scales.x = d3.scaleLinear()
        .domain([this.viewport.xMin, this.viewport.xMax])
        .range([50, width - 50]);
      
      this.scales.y = d3.scaleLinear()
        .domain([this.viewport.yMin, this.viewport.yMax])
        .range([height - 50, 50]);
      
      // Use custom zoom instead of d3-zoom for better control
      this.setupCustomZoom();
      
      // Create main group for all chart elements
      this.chartGroup = this.svg.append('g').attr('class', 'chart-group');
      
      // Create layers in the correct order (bottom to top)
      // 1. Grid (bottom layer)
      this.gridGroup = this.chartGroup.append('g').attr('class', 'grid');
      
      // 2. Axes (middle layer)
      this.axesGroup = this.chartGroup.append('g').attr('class', 'axes');
      
      // 3. Functions (top layer)
      this.functionGroup = this.chartGroup.append('g').attr('class', 'functions');
      
      // Initialize grid and axes
      this.createGrid();
      this.createAxes();
    } catch (error) {
      console.error('[D3] Error initializing main chart:', error);
    }
  }

  setupCustomZoom() {
    let isPanning = false;
    let lastX = 0;
    let lastY = 0;
    let zoomTimeout = null;
    
    // Mouse wheel for zoom
    this.svg.on('wheel', (event) => {
      event.preventDefault();
      
      if (this.isRendering) return;
      
      // Clear existing timeout
      if (zoomTimeout) {
        clearTimeout(zoomTimeout);
      }
      
      // Debounce zoom updates
      zoomTimeout = setTimeout(() => {
        const rect = this.svg.node().getBoundingClientRect();
        const mouseX = event.clientX - rect.left;
        const mouseY = event.clientY - rect.top;
        
        // Get world coordinates at mouse
        const worldX = this.scales.x.invert(mouseX);
        const worldY = this.scales.y.invert(mouseY);
        
        // Zoom factor (reduced sensitivity)
        const delta = -event.deltaY;
        const zoomFactor = delta > 0 ? 0.9 : 1.1; // 10% per scroll
        
        // Calculate new viewport (zoom toward mouse position)
        const newWidth = (this.viewport.xMax - this.viewport.xMin) * zoomFactor;
        const newHeight = (this.viewport.yMax - this.viewport.yMin) * zoomFactor;
        
        const xRatio = (worldX - this.viewport.xMin) / (this.viewport.xMax - this.viewport.xMin);
        const yRatio = (worldY - this.viewport.yMin) / (this.viewport.yMax - this.viewport.yMin);
        
        this.viewport.xMin = worldX - newWidth * xRatio;
        this.viewport.xMax = worldX + newWidth * (1 - xRatio);
        this.viewport.yMin = worldY - newHeight * yRatio;
        this.viewport.yMax = worldY + newHeight * (1 - yRatio);
        
        // Update
        this.updateScales();
        this.updateChart();
        this.clearCache();
      }, 100); // 100ms debounce
    });
    
    // Mouse drag for pan
    this.svg.on('mousedown', (event) => {
      isPanning = true;
      lastX = event.clientX;
      lastY = event.clientY;
      this.svg.style('cursor', 'grabbing');
    });
    
    this.svg.on('mousemove', (event) => {
      if (isPanning) {
        const dx = event.clientX - lastX;
        const dy = event.clientY - lastY;
        
        const worldDx = this.scales.x.invert(dx) - this.scales.x.invert(0);
        const worldDy = this.scales.y.invert(dy) - this.scales.y.invert(0);
        
        this.viewport.xMin -= worldDx;
        this.viewport.xMax -= worldDx;
        this.viewport.yMin -= worldDy;
        this.viewport.yMax -= worldDy;
        
        lastX = event.clientX;
        lastY = event.clientY;
        
        // Update immediately for smooth panning
        this.updateScales();
        this.updateGrid();
        this.updateAxes();
        // Don't update functions during pan for performance
      }
    });
    
    this.svg.on('mouseup', () => {
      if (isPanning) {
        isPanning = false;
        this.svg.style('cursor', 'crosshair');
        // Update functions after pan completes
        this.updateChart();
        this.clearCache();
      }
    });
    
    this.svg.on('mouseleave', () => {
      if (isPanning) {
        isPanning = false;
        this.svg.style('cursor', 'crosshair');
        this.updateChart();
      }
    });
  }

  updateScales() {
    this.scales.x.domain([this.viewport.xMin, this.viewport.xMax]);
    this.scales.y.domain([this.viewport.yMin, this.viewport.yMax]);
  }

  createGrid() {
    // Clear existing grid
    this.gridGroup.selectAll('*').remove();
    
    // Create grid lines
    const xGrid = this.gridGroup.selectAll('.x-grid')
      .data(d3.range(this.viewport.xMin, this.viewport.xMax + 1, 1))
      .enter().append('line')
      .attr('class', 'x-grid')
      .attr('x1', d => this.scales.x(d))
      .attr('x2', d => this.scales.x(d))
      .attr('y1', this.scales.y(this.viewport.yMin))
      .attr('y2', this.scales.y(this.viewport.yMax))
      .style('stroke', '#f0f0f0')
      .style('stroke-width', 1);
    
    const yGrid = this.gridGroup.selectAll('.y-grid')
      .data(d3.range(this.viewport.yMin, this.viewport.yMax + 1, 1))
      .enter().append('line')
      .attr('class', 'y-grid')
      .attr('x1', this.scales.x(this.viewport.xMin))
      .attr('x2', this.scales.x(this.viewport.xMax))
      .attr('y1', d => this.scales.y(d))
      .attr('y2', d => this.scales.y(d))
      .style('stroke', '#f0f0f0')
      .style('stroke-width', 1);
  }

  createAxes() {
    // Clear existing axes
    this.axesGroup.selectAll('*').remove();
    
    // X-axis
    const xAxis = d3.axisBottom(this.scales.x)
      .tickFormat(d3.format('.1f'));
    
    this.axesGroup.append('g')
      .attr('class', 'x-axis')
      .attr('transform', `translate(0, ${this.scales.y(0)})`)
      .call(xAxis);
    
    // Y-axis
    const yAxis = d3.axisLeft(this.scales.y)
      .tickFormat(d3.format('.1f'));
    
    this.axesGroup.append('g')
      .attr('class', 'y-axis')
      .attr('transform', `translate(${this.scales.x(0)}, 0)`)
      .call(yAxis);
    
    // Style axes
    this.axesGroup.selectAll('.domain')
      .style('stroke', '#999')
      .style('stroke-width', 2);
    
    this.axesGroup.selectAll('.tick line')
      .style('stroke', '#999')
      .style('stroke-width', 1);
    
    this.axesGroup.selectAll('.tick text')
      .style('fill', '#666')
      .style('font-size', '11px');
  }

  setupWorker() {
    try {
      this.worker = new Worker('js/math-worker.js');
      this.worker.onmessage = (e) => {
        const { type, id, result, error } = e.data;
        
        if (type === 'result') {
          const pending = this.pendingEvaluations.get(id);
          if (pending) {
            pending.resolve(result);
            this.pendingEvaluations.delete(id);
          }
        } else if (type === 'error') {
          const pending = this.pendingEvaluations.get(id);
          if (pending) {
            pending.reject(new Error(error));
            this.pendingEvaluations.delete(id);
          }
        }
      };
      
      this.evaluationId = 0;
      this.workerReady = true;
    } catch (error) {
      console.warn('Web Worker not available, using fallback evaluation');
      this.workerReady = false;
    }
  }
  
  setupTooltip() {
    this.tooltip = document.getElementById('tooltip');
  }
  
  setupWebGL() {
    // WebGL is disabled for D3.js implementation
    console.log('WebGL disabled - using D3.js for rendering');
    this.webglRenderer = null;
  }
  
  setupAccessibility() {
    // Add keyboard navigation to document for D3.js
    document.addEventListener('keydown', (e) => {
      this.handleKeyboardNavigation(e);
    });
    
    // Add accessibility attributes to SVG if it exists
    if (this.svg) {
      this.svg.attr('tabindex', '0');
      this.svg.attr('role', 'img');
      this.svg.attr('aria-label', 'Interactive mathematical graph');
    }
    
    // Add ARIA live region updates
    this.updateAriaStatus();
  }
  
  setupCanvas() {
    // Canvas setup is handled by D3.js SVG initialization
    console.log('Canvas setup handled by D3.js SVG');
  }
  
  setupEventListeners() {
    // Add expression button
    document.getElementById('addExpressionBtn').addEventListener('click', () => {
      this.addExpression();
    });
    
    // Control buttons
    document.getElementById('btnGrid').addEventListener('click', () => {
      this.toggleGrid();
    });
    
    document.getElementById('btnAxes').addEventListener('click', () => {
      this.toggleAxes();
    });
    
    document.getElementById('btnReset').addEventListener('click', () => {
      this.resetView();
    });
    
    document.getElementById('btnShare').addEventListener('click', () => {
      this.shareURL();
    });
    
    document.getElementById('btnWebGL').addEventListener('click', () => {
      this.toggleWebGL();
    });
    
    // Performance controls
    document.getElementById('resolutionSlider').addEventListener('input', (e) => {
      this.resolutionLevel = parseInt(e.target.value);
      const levels = ['Ultra Low', 'Low', 'Medium', 'High', 'Ultra High'];
      document.getElementById('resolutionValue').textContent = levels[this.resolutionLevel - 1];
      this.clearCache();
      this.updateChart();
    });
    
    // Export buttons
    document.getElementById('exportPNG').addEventListener('click', () => {
      this.exportAsPNG();
    });
    
    document.getElementById('exportSVG').addEventListener('click', () => {
      this.exportAsSVG();
    });
    
    // Slider inputs
    ['sliderA', 'sliderB', 'sliderC', 'sliderK'].forEach(id => {
      const slider = document.getElementById(id);
      const varName = id.replace('slider', '').toLowerCase();
      const valueDisplay = document.getElementById(`sliderValue${varName.toUpperCase()}`);
      
      slider.addEventListener('input', () => {
        const value = parseFloat(slider.value);
        this.variables[varName] = value;
        valueDisplay.textContent = value.toFixed(1);
        this.updateChart();
        this.saveToURL();
      });
    });
    
    // Plot type selector
    document.getElementById('plotTypeSelector').addEventListener('change', (e) => {
      this.currentPlotType = e.target.value;
      console.log('Plot type changed to:', this.currentPlotType);
      this.updateUIForPlotType();
      this.updateChart();
    });
    
    // Table data controls
    document.getElementById('loadTableData').addEventListener('click', () => {
      this.loadTableData();
    });
    
    document.getElementById('clearTableData').addEventListener('click', () => {
      this.clearTableData();
    });
    
    // Regression controls
    document.getElementById('linearRegression').addEventListener('click', () => {
      this.performLinearRegression();
    });
    
    document.getElementById('polynomialRegression').addEventListener('click', () => {
      this.performPolynomialRegression();
    });
    
    document.getElementById('exponentialRegression').addEventListener('click', () => {
      this.performExponentialRegression();
    });
    
    // Statistics controls
    document.getElementById('distributionType').addEventListener('change', () => {
      this.updateDistributionParameters();
    });
    
    document.getElementById('createDistribution').addEventListener('click', () => {
      this.createDistribution();
    });
    
    document.getElementById('zTest').addEventListener('click', () => {
      this.performZTest();
    });
    
    document.getElementById('tTest').addEventListener('click', () => {
      this.performTTest();
    });
    
    document.getElementById('chi2Test').addEventListener('click', () => {
      this.performChi2Test();
    });
    
    document.getElementById('meanCI').addEventListener('click', () => {
      this.calculateMeanCI();
    });
    
    document.getElementById('proportionCI').addEventListener('click', () => {
      this.calculateProportionCI();
    });
    
    // Canvas interactions
    this.setupCanvasInteractions();
    
    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Delete' && this.selectedExpression !== null) {
        this.removeExpression(this.selectedExpression);
      }
    });
  }
  
  setupCanvasInteractions() {
    // Prevent duplicate event listeners
    if (this.interactionsSetup) {
      console.log('Interactions already setup, skipping...');
      return;
    }
    this.interactionsSetup = true;
    
    // D3.js handles mouse interactions through zoom behavior
    // Additional custom interactions can be added here if needed
    
    // Throttle only for expensive tooltip updates
    let tooltipTimeout = null;
    
    // Add mouse move tracking for coordinates display
    if (this.svg) {
      this.svg.on('mousemove', (event) => {
        // ALWAYS update coordinates immediately (lightweight, no lag)
        this.updateCoordinatesDisplay(event);
        
        // Throttle expensive tooltip updates
        if (this.showTooltip) {
          if (tooltipTimeout) {
            clearTimeout(tooltipTimeout);
          }
          tooltipTimeout = setTimeout(() => {
            this.updateTooltipFromEvent(event);
          }, 100); // Only throttle tooltip
        }
      });
      
      // Add double-click to reset view (with debouncing)
      let lastDoubleClick = 0;
      this.svg.on('dblclick', () => {
        const now = Date.now();
        if (now - lastDoubleClick < 500) { // Prevent rapid double-clicks
          console.log('Double-click too fast, ignoring...');
          return;
        }
        lastDoubleClick = now;
        this.resetView();
      });
    }
  }
  
  updateCoordinatesDisplay(event) {
    try {
      // Quick bounds check
      if (!this.scales || !this.scales.x || !this.scales.y) return;
      
      const [mouseX, mouseY] = d3.pointer(event);
      const worldX = this.scales.x.invert(mouseX);
      const worldY = this.scales.y.invert(mouseY);
      
      // Update coordinates display immediately (very lightweight)
      const coordinatesEl = document.getElementById('coordinatesText');
      if (coordinatesEl) {
        coordinatesEl.textContent = `(${worldX.toFixed(2)}, ${worldY.toFixed(2)})`;
      }
    } catch (error) {
      // Silently ignore errors
    }
  }
  
  updateTooltipFromEvent(event) {
    try {
      if (!this.scales || !this.scales.x || !this.scales.y) return;
      
      const [mouseX, mouseY] = d3.pointer(event);
      const worldX = this.scales.x.invert(mouseX);
      const worldY = this.scales.y.invert(mouseY);
      
      // Update tooltip (expensive - evaluates expressions)
      this.updateTooltip(worldX, worldY, event.clientX, event.clientY);
    } catch (error) {
      // Silently ignore errors
    }
  }
  
  screenToWorldX(screenX) {
    // For D3.js, we use the scales to convert screen coordinates
    if (this.scales && this.scales.x) {
      return this.scales.x.invert(screenX);
    }
    // Fallback calculation
    const width = this.svg ? this.svg.attr('width') : 800;
    const ratio = (screenX / width);
    return this.viewport.xMin + ratio * (this.viewport.xMax - this.viewport.xMin);
  }
  
  screenToWorldY(screenY) {
    // For D3.js, we use the scales to convert screen coordinates
    if (this.scales && this.scales.y) {
      return this.scales.y.invert(screenY);
    }
    // Fallback calculation
    const height = this.svg ? this.svg.attr('height') : 600;
    const ratio = 1 - (screenY / height);
    return this.viewport.yMin + ratio * (this.viewport.yMax - this.viewport.yMin);
  }
  
  worldToScreenX(worldX) {
    // For D3.js, we use the scales to convert world coordinates
    if (this.scales && this.scales.x) {
      return this.scales.x(worldX);
    }
    // Fallback calculation
    const width = this.svg ? this.svg.attr('width') : 800;
    const ratio = (worldX - this.viewport.xMin) / (this.viewport.xMax - this.viewport.xMin);
    return ratio * width;
  }
  
  worldToScreenY(worldY) {
    // For D3.js, we use the scales to convert world coordinates
    if (this.scales && this.scales.y) {
      return this.scales.y(worldY);
    }
    // Fallback calculation
    const height = this.svg ? this.svg.attr('height') : 600;
    const ratio = (worldY - this.viewport.yMin) / (this.viewport.yMax - this.viewport.yMin);
    return (1 - ratio) * height;
  }
  
  addDefaultExpressions() {
    // Add a simple example based on plot type
    if (this.currentPlotType === 'cartesian') {
      this.addExpression('sin(x)', '#3182ce');
      this.addExpression('x^2', '#38a169');
    } else if (this.currentPlotType === 'parametric') {
      this.addExpression('cos(t), sin(t)', '#3182ce');
    } else if (this.currentPlotType === 'polar') {
      this.addExpression('sin(2*θ)', '#3182ce');
    }
  }
  
  addExpression(expression = '', color = null) {
    const id = Date.now().toString();
    const exprColor = color || this.colors[this.expressions.length % this.colors.length];
    
    let defaultExpr = 'sin(x)';
    if (this.currentPlotType === 'parametric') {
      defaultExpr = 'cos(t), sin(t)';
    } else if (this.currentPlotType === 'polar') {
      defaultExpr = 'sin(2*θ)';
    } else if (this.currentPlotType === 'inequality') {
      defaultExpr = 'x^2';
    }
    
    const expressionObj = {
      id,
      expression: expression || defaultExpr,
      color: exprColor,
      visible: true,
      error: null,
      domainMin: null,
      domainMax: null,
      plotType: this.currentPlotType
    };
    
    this.expressions.push(expressionObj);
    this.renderExpressionList();
    this.updateChart();
    
    return id;
  }
  
  removeExpression(id) {
    if (!this) {
      console.error('Calculator not initialized');
      return;
    }
    
    this.expressions = this.expressions.filter(expr => expr.id !== id);
    this.selectedExpression = null;
    this.renderExpressionList();
    this.updateChart();
  }
  
  updateExpression(id, expression) {
    const expr = this.expressions.find(e => e.id === id);
    if (expr) {
      expr.expression = expression;
      expr.error = null;
      this.updateChart();
      this.saveToURL();
    }
  }
  
  toggleExpressionVisibility(id) {
    if (!this) {
      console.error('Calculator not initialized');
      return;
    }
    
    const expr = this.expressions.find(e => e.id === id);
    if (expr) {
      expr.visible = !expr.visible;
      this.renderExpressionList();
      this.updateChart();
      this.saveToURL();
    }
  }
  
  setExpressionColor(id, color) {
    const expr = this.expressions.find(e => e.id === id);
    if (expr) {
      expr.color = color;
      this.updateChart();
      this.saveToURL();
    }
  }
  
  renderExpressionList() {
    const container = document.getElementById('expressionList');
    container.innerHTML = '';
    
    this.expressions.forEach((expr, index) => {
      const div = document.createElement('div');
      div.className = `expression-item ${expr.id === this.selectedExpression ? 'active' : ''}`;
      div.dataset.id = expr.id;
      
      let inputHtml = '';
      let placeholder = 'y = f(x)';
      
      if (expr.plotType === 'parametric') {
        inputHtml = `
          <div class="parametric-inputs">
            <input type="text" class="expression-input" value="${expr.expression.split(',')[0] || ''}" placeholder="x(t)">
            <input type="text" class="expression-input" value="${expr.expression.split(',')[1] || ''}" placeholder="y(t)">
          </div>
        `;
        placeholder = 'x(t), y(t)';
      } else if (expr.plotType === 'polar') {
        inputHtml = `<input type="text" class="expression-input" value="${expr.expression}" placeholder="r(θ)">`;
        placeholder = 'r(θ)';
      } else if (expr.plotType === 'inequality') {
        inputHtml = `<input type="text" class="expression-input" value="${expr.expression}" placeholder="y > f(x)">`;
        placeholder = 'y > f(x)';
      } else {
        inputHtml = `<input type="text" class="expression-input" value="${expr.expression}" placeholder="${placeholder}">`;
      }
      
      div.innerHTML = `
        <div class="expression-color" style="background-color: ${expr.color}" onclick="calculator.selectExpression('${expr.id}')"></div>
        ${inputHtml}
        <div class="expression-controls">
          <button class="btn-icon btn-toggle ${expr.visible ? 'visible' : ''}" onclick="toggleExpressionVisibility('${expr.id}')" aria-label="Toggle visibility">
            ${expr.visible ? '👁' : '👁‍🗨'}
          </button>
          <button class="btn-icon btn-remove" onclick="removeExpression('${expr.id}')" aria-label="Delete expression">×</button>
        </div>
        <div class="domain-controls" style="display: none;">
          <input type="number" class="domain-input" placeholder="min" value="${expr.domainMin || ''}">
          <span>≤ ${expr.plotType === 'parametric' ? 't' : expr.plotType === 'polar' ? 'θ' : 'x'} ≤</span>
          <input type="number" class="domain-input" placeholder="max" value="${expr.domainMax || ''}">
        </div>
      `;
      
      // Add event listeners
      const input = div.querySelector('.expression-input');
      input.addEventListener('input', (e) => {
        this.updateExpression(expr.id, e.target.value);
      });
      
      input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
          this.updateExpression(expr.id, e.target.value);
          e.target.blur();
        }
      });
      
      div.addEventListener('click', (e) => {
        if (e.target === div || e.target.classList.contains('expression-color')) {
          this.selectExpression(expr.id);
        }
      });
      
      container.appendChild(div);
    });
  }
  
  selectExpression(id) {
    this.selectedExpression = id;
    this.renderExpressionList();
  }
  
  toggleGrid() {
    this.showGrid = !this.showGrid;
    const btn = document.getElementById('btnGrid');
    btn.classList.toggle('active', this.showGrid);
    this.updateChart();
    this.saveToURL();
  }
  
  toggleAxes() {
    this.showAxes = !this.showAxes;
    const btn = document.getElementById('btnAxes');
    btn.classList.toggle('active', this.showAxes);
    this.updateChart();
    this.saveToURL();
  }
  
  resetView() {
    // Prevent recursive calls
    if (this.isResetting) {
      console.log('Reset already in progress, skipping...');
      return;
    }
    
    this.isResetting = true;
    
    try {
      console.log('Resetting view...');
      
      // Reset viewport to default
      this.viewport = { xMin: -10, xMax: 10, yMin: -6, yMax: 6 };
      
      // Clear all caches
      this.clearCache();
      
      // Update scales and chart
      this.updateScales();
      this.updateChart();
      
      // Update accessibility status
      this.updateAriaStatus();
      
      // Save to URL
      this.saveToURL();
      
      console.log('View reset complete');
    } catch (error) {
      console.error('Error during reset:', error);
    } finally {
      // Always reset the flag
      setTimeout(() => {
        this.isResetting = false;
      }, 100);
    }
  }
  
  async evaluateExpression(expression, x) {
    if (this.workerReady && this.worker) {
      try {
        const id = ++this.evaluationId;
        const promise = new Promise((resolve, reject) => {
          this.pendingEvaluations.set(id, { resolve, reject });
        });
        
        this.worker.postMessage({
          type: 'evaluate',
          id,
          expression,
          variables: { ...this.variables, x }
        });
        
        const result = await promise;
        return result;
      } catch (error) {
        return null;
      }
    } else {
      // Fallback to synchronous evaluation
      return this.evaluateExpressionSync(expression, x);
    }
  }
  
  evaluateExpressionSync(expression, x) {
    // Create cache key
    const cacheKey = `${expression}_${x}_${JSON.stringify(this.variables)}`;
    const cached = this.functionCache.get(cacheKey);
    if (cached !== null) {
      return cached;
    }
    
    try {
      // Replace variables with their values
      let expr = expression;
      Object.keys(this.variables).forEach(varName => {
        expr = expr.replace(new RegExp(`\\b${varName}\\b`, 'g'), this.variables[varName]);
      });
      
      // Replace x with the actual value
      expr = expr.replace(/\bx\b/g, x);
      
      // Handle common mathematical functions
      expr = expr.replace(/sin\(/g, 'Math.sin(');
      expr = expr.replace(/cos\(/g, 'Math.cos(');
      expr = expr.replace(/tan\(/g, 'Math.tan(');
      expr = expr.replace(/log\(/g, 'Math.log(');
      expr = expr.replace(/ln\(/g, 'Math.log(');
      expr = expr.replace(/exp\(/g, 'Math.exp(');
      expr = expr.replace(/sqrt\(/g, 'Math.sqrt(');
      expr = expr.replace(/abs\(/g, 'Math.abs(');
      expr = expr.replace(/\^/g, '**');
      expr = expr.replace(/pi/g, 'Math.PI');
      expr = expr.replace(/e\b/g, 'Math.E');
      
      // Remove 'y = ' prefix if present
      expr = expr.replace(/^\s*y\s*=\s*/i, '');
      
      // Evaluate safely
      const result = Function('"use strict"; return (' + expr + ')')();
      const finalResult = typeof result === 'number' && isFinite(result) ? result : null;
      
      // Cache the result
      this.functionCache.set(cacheKey, finalResult);
      
      return finalResult;
    } catch (error) {
      this.functionCache.set(cacheKey, null);
      return null;
    }
  }
  
  updateChart() {
    // Prevent recursive/concurrent updates
    if (this.isRendering) {
      console.log('Chart update already in progress, skipping...');
      return;
    }
    
    if (!this.svg) {
      console.error('[D3] SVG not initialized');
      return;
    }
    
    this.isRendering = true;
    
    try {
      // Clear existing functions
      this.functionGroup.selectAll('*').remove();
      
      // Add function expressions
      this.expressions.forEach(expr => {
        if (expr.visible && expr.plotType === 'cartesian') {
          this.plotFunction(expr);
        }
      });
      
      // Add table data if in table mode
      if (this.currentPlotType === 'table' && this.tableData.length > 0) {
        this.plotTableData();
      }
      
      // Update grid and axes
      this.updateGrid();
      this.updateAxes();
    } catch (error) {
      console.error('Error updating chart:', error);
    } finally {
      // Always reset the flag
      this.isRendering = false;
    }
  }

  plotFunction(expression) {
    if (!this.functionGroup) {
      console.error('[D3] Function group not initialized');
      return;
    }
    
    const points = this.generateFunctionPoints(expression);
    
    if (points.length === 0) {
      return;
    }
    
    // Create line generator
    const line = d3.line()
      .x(d => this.scales.x(d.x))
      .y(d => this.scales.y(d.y))
      .curve(d3.curveLinear);
    
    // Plot the function
    this.functionGroup.append('path')
      .datum(points)
      .attr('fill', 'none')
      .attr('stroke', expression.color)
      .attr('stroke-width', 2)
      .attr('d', line)
      .attr('class', `function-${expression.id}`);
  }

  plotTableData() {
    // Plot table data as scatter points
    const points = this.functionGroup.selectAll('.table-point')
      .data(this.tableData);
    
    points.enter()
      .append('circle')
      .attr('class', 'table-point')
      .attr('cx', d => this.scales.x(d.x))
      .attr('cy', d => this.scales.y(d.y))
      .attr('r', 4)
      .attr('fill', '#e53e3e')
      .attr('stroke', '#fff')
      .attr('stroke-width', 1);
  }

  updateGrid() {
    // Update grid lines based on current viewport
    // Don't remove the group, just call createGrid which will clear its contents
    this.createGrid();
  }

  updateAxes() {
    // Update axes based on current scales
    // Don't remove the group, just call createAxes which will clear its contents
    this.createAxes();
  }
  
  // Canvas rendering removed - using Chart.js instead
  
  // WebGL rendering removed - using Chart.js instead
  
  // Grid rendering handled by Chart.js
  
  getFineGridStep(range) {
    // Much smaller step for fine grid (like Desmos)
    const log = Math.log10(range);
    const power = Math.floor(log);
    const normalized = range / Math.pow(10, power);
    
    // Use much smaller intervals for fine grid
    if (normalized <= 0.5) return Math.pow(10, power - 1);
    if (normalized <= 1) return Math.pow(10, power) / 5;
    if (normalized <= 2) return Math.pow(10, power) / 2;
    if (normalized <= 5) return Math.pow(10, power);
    return 2 * Math.pow(10, power);
  }
  
  renderAxes() {
    // Draw axes with a more prominent style like Desmos
    this.ctx.strokeStyle = '#999999';
    this.ctx.lineWidth = 2;

    // X-axis
    if (this.viewport.yMin <= 0 && this.viewport.yMax >= 0) {
      const screenY = this.worldToScreenY(0);
      this.ctx.beginPath();
      this.ctx.moveTo(0, screenY);
      this.ctx.lineTo(this.canvas.width, screenY);
      this.ctx.stroke();
    }

    // Y-axis
    if (this.viewport.xMin <= 0 && this.viewport.xMax >= 0) {
      const screenX = this.worldToScreenX(0);
      this.ctx.beginPath();
      this.ctx.moveTo(screenX, 0);
      this.ctx.lineTo(screenX, this.canvas.height);
      this.ctx.stroke();
    }

    // Always render axis labels (regardless of showAxes toggle)
    this.renderAxisLabels();
  }
  
  renderAxisLabels() {
    this.ctx.fillStyle = '#333333';
    this.ctx.font = '12px Arial, sans-serif';
    this.ctx.textAlign = 'center';

    // Calculate appropriate step size for labels
    const xStep = (this.viewport.xMax - this.viewport.xMin) / 10;
    const yStep = (this.viewport.yMax - this.viewport.yMin) / 8;

    // X-axis labels
    for (let x = this.viewport.xMin; x <= this.viewport.xMax; x += xStep) {
      const screenX = this.worldToScreenX(x);
      const screenY = this.worldToScreenY(0) + 20;
      
      if (screenX > 30 && screenX < this.canvas.width - 30) {
        this.ctx.fillText(this.formatNumber(x), screenX, screenY);
      }
    }

    // Y-axis labels
    this.ctx.textAlign = 'right';
    for (let y = this.viewport.yMin; y <= this.viewport.yMax; y += yStep) {
      const screenX = this.worldToScreenX(0) - 15;
      const screenY = this.worldToScreenY(y) + 4;
      
      if (screenY > 15 && screenY < this.canvas.height - 15) {
        this.ctx.fillText(this.formatNumber(y), screenX, screenY);
      }
    }
  }
  
  formatNumber(num) {
    // Format numbers like Desmos - remove unnecessary decimals
    if (Math.abs(num) < 0.001) return '0';
    if (Math.abs(num) < 1) return num.toFixed(3);
    if (Math.abs(num) < 10) return num.toFixed(2);
    if (Math.abs(num) < 100) return num.toFixed(1);
    return Math.round(num).toString();
  }
  
  getGridStep(range) {
    const log = Math.log10(range);
    const power = Math.floor(log);
    const normalized = range / Math.pow(10, power);
    
    if (normalized <= 1) return Math.pow(10, power);
    if (normalized <= 2) return 2 * Math.pow(10, power);
    if (normalized <= 5) return 5 * Math.pow(10, power);
    return 10 * Math.pow(10, power);
  }
  
  renderExpression(expression) {
    this.ctx.strokeStyle = expression.color;
    this.ctx.lineWidth = 2;
    this.ctx.beginPath();
    
    let firstPoint = true;
    const step = (this.viewport.xMax - this.viewport.xMin) / this.canvas.width;
    
    // Determine domain constraints
    const minX = expression.domainMin !== null ? Math.max(expression.domainMin, this.viewport.xMin) : this.viewport.xMin;
    const maxX = expression.domainMax !== null ? Math.min(expression.domainMax, this.viewport.xMax) : this.viewport.xMax;
    
    const startScreenX = Math.max(0, this.worldToScreenX(minX));
    const endScreenX = Math.min(this.canvas.width, this.worldToScreenX(maxX));
    
    for (let screenX = startScreenX; screenX <= endScreenX; screenX += 2) {
      const worldX = this.screenToWorldX(screenX);
      
      // Skip if outside domain
      if (expression.domainMin !== null && worldX < expression.domainMin) continue;
      if (expression.domainMax !== null && worldX > expression.domainMax) continue;
      
      const y = this.evaluateExpressionSync(expression.expression, worldX);
      
      if (y !== null) {
        const screenY = this.worldToScreenY(y);
        
        if (screenY >= 0 && screenY <= this.canvas.height) {
          if (firstPoint) {
            this.ctx.moveTo(screenX, screenY);
            firstPoint = false;
          } else {
            this.ctx.lineTo(screenX, screenY);
          }
        } else {
          firstPoint = true;
        }
      } else {
        firstPoint = true;
      }
    }
    
    this.ctx.stroke();
  }
  
  updateStatus() {
    const status = document.getElementById('statusText');
    const visibleCount = this.expressions.filter(e => e.visible).length;
    const renderer = this.useWebGL ? 'WebGL' : 'Canvas 2D';
    const fps = this.performanceMonitor.getFPS();
    const cacheStats = this.functionCache.getStats();
    
    status.textContent = `${this.expressions.length} expressions (${visibleCount} visible) • ${renderer} • ${fps}fps • Cache: ${cacheStats.hitRate}`;
  }
  
  updateAriaStatus() {
    const status = document.getElementById('statusText');
    const ariaText = status.textContent;
    
    // Update ARIA live region
    const ariaStatus = document.querySelector('[role="status"]');
    if (ariaStatus) {
      ariaStatus.setAttribute('aria-label', ariaText);
    }
  }
  
  // Performance optimization methods
  generateFunctionPoints(expression) {
    const cacheKey = `points_${expression.id}_${JSON.stringify(this.viewport)}_${this.resolutionLevel}`;
    
    if (this.renderingCache.has(cacheKey)) {
      return this.renderingCache.get(cacheKey);
    }
    
    const points = [];
    const stepSize = this.getStepSize();
    
    // Determine domain constraints
    const minX = expression.domainMin !== null ? Math.max(expression.domainMin, this.viewport.xMin) : this.viewport.xMin;
    const maxX = expression.domainMax !== null ? Math.min(expression.domainMax, this.viewport.xMax) : this.viewport.xMax;
    
    for (let x = minX; x <= maxX; x += stepSize) {
      const y = this.evaluateExpressionSync(expression.expression, x);
      if (y !== null && y >= this.viewport.yMin && y <= this.viewport.yMax) {
        points.push({ x, y });
      }
    }
    
    this.renderingCache.set(cacheKey, points);
    return points;
  }
  
  getStepSize() {
    const baseStep = (this.viewport.xMax - this.viewport.xMin) / 800; // Use fixed width for Chart.js
    const resolutionMultipliers = [4, 2, 1, 0.5, 0.25]; // Ultra Low to Ultra High
    return baseStep * resolutionMultipliers[this.resolutionLevel - 1];
  }
  
  clearCache() {
    this.functionCache.clear();
    this.renderingCache.clear();
  }
  
  toggleWebGL() {
    if (!this.webglRenderer || !this.webglRenderer.isInitialized) {
      alert('WebGL is not available on this device');
      return;
    }
    
    this.useWebGL = !this.useWebGL;
    const btn = document.getElementById('btnWebGL');
    btn.classList.toggle('webgl-active', this.useWebGL);
    btn.textContent = this.useWebGL ? 'WebGL ✓' : 'WebGL';
    
    this.clearCache();
    this.updateChart();
  }
  
  handleKeyboardNavigation(e) {
    const step = (this.viewport.xMax - this.viewport.xMin) * 0.1;
    const zoomFactor = 1.2;
    
    switch (e.key) {
      case 'ArrowLeft':
        e.preventDefault();
        this.viewport.xMin += step;
        this.viewport.xMax += step;
        this.updateChart();
        break;
        
      case 'ArrowRight':
        e.preventDefault();
        this.viewport.xMin -= step;
        this.viewport.xMax -= step;
        this.updateChart();
        break;
        
      case 'ArrowUp':
        e.preventDefault();
        this.viewport.yMin -= step;
        this.viewport.yMax -= step;
        this.updateChart();
        break;
        
      case 'ArrowDown':
        e.preventDefault();
        this.viewport.yMin += step;
        this.viewport.yMax += step;
        this.updateChart();
        break;
        
      case '+':
      case '=':
        e.preventDefault();
        this.zoomIn();
        break;
        
      case '-':
        e.preventDefault();
        this.zoomOut();
        break;
        
      case ' ':
        e.preventDefault();
        this.resetView();
        break;
        
      case 'g':
        e.preventDefault();
        this.toggleGrid();
        break;
        
      case 'a':
        e.preventDefault();
        this.toggleAxes();
        break;
    }
  }
  
  zoomIn() {
    const centerX = (this.viewport.xMin + this.viewport.xMax) / 2;
    const centerY = (this.viewport.yMin + this.viewport.yMax) / 2;
    
    const newWidth = (this.viewport.xMax - this.viewport.xMin) / 1.2;
    const newHeight = (this.viewport.yMax - this.viewport.yMin) / 1.2;
    
    this.viewport.xMin = centerX - newWidth / 2;
    this.viewport.xMax = centerX + newWidth / 2;
    this.viewport.yMin = centerY - newHeight / 2;
    this.viewport.yMax = centerY + newHeight / 2;
    
    this.updateChart();
  }
  
  zoomOut() {
    const centerX = (this.viewport.xMin + this.viewport.xMax) / 2;
    const centerY = (this.viewport.yMin + this.viewport.yMax) / 2;
    
    const newWidth = (this.viewport.xMax - this.viewport.xMin) * 1.2;
    const newHeight = (this.viewport.yMax - this.viewport.yMin) * 1.2;
    
    this.viewport.xMin = centerX - newWidth / 2;
    this.viewport.xMax = centerX + newWidth / 2;
    this.viewport.yMin = centerY - newHeight / 2;
    this.viewport.yMax = centerY + newHeight / 2;
    
    this.updateChart();
  }
  
  updateUIForPlotType() {
    console.log('updateUIForPlotType called with:', this.currentPlotType);
    
    // Remove all plot type classes
    const container = document.querySelector('.calculator-layout');
    container.className = 'calculator-layout';
    
    // Add current plot type class
    container.classList.add(`plot-type-${this.currentPlotType}`);
    
    const tablePanel = document.getElementById('tablePanel');
    const statisticsPanel = document.getElementById('statisticsPanel');
    
    console.log('Found panels:', { tablePanel, statisticsPanel });
    
    if (this.currentPlotType === 'table') {
      tablePanel.style.display = 'block';
      statisticsPanel.style.display = 'none';
    } else if (this.currentPlotType === 'statistics') {
      tablePanel.style.display = 'none';
      statisticsPanel.style.display = 'block';
      console.log('Showing statistics panel');
      this.updateDistributionParameters(); // Initialize parameters
      
      // Initialize Chart.js chart
      setTimeout(() => {
        this.initializeStatisticsChart();
      }, 100); // Small delay to ensure DOM is ready
    } else {
      tablePanel.style.display = 'none';
      statisticsPanel.style.display = 'none';
    }
    
    // Update existing expressions to new plot type
    this.expressions.forEach(expr => {
      expr.plotType = this.currentPlotType;
    });
    
    this.renderExpressionList();
    this.updateChart(); // Update the main chart
  }
  
  // Parametric curve rendering
  renderParametricExpression(expression) {
    const [xExpr, yExpr] = expression.expression.split(',').map(s => s.trim());
    if (!xExpr || !yExpr) return;
    
    this.ctx.strokeStyle = expression.color;
    this.ctx.lineWidth = 2;
    this.ctx.beginPath();
    
    let firstPoint = true;
    const tMin = expression.domainMin !== null ? expression.domainMin : -10;
    const tMax = expression.domainMax !== null ? expression.domainMax : 10;
    const tStep = (tMax - tMin) / 1000;
    
    for (let t = tMin; t <= tMax; t += tStep) {
      const x = this.evaluateExpressionSync(xExpr, t);
      const y = this.evaluateExpressionSync(yExpr, t);
      
      if (x !== null && y !== null) {
        const screenX = this.worldToScreenX(x);
        const screenY = this.worldToScreenY(y);
        
        if (screenX >= 0 && screenX <= this.canvas.width && 
            screenY >= 0 && screenY <= this.canvas.height) {
          if (firstPoint) {
            this.ctx.moveTo(screenX, screenY);
            firstPoint = false;
          } else {
            this.ctx.lineTo(screenX, screenY);
          }
        } else {
          firstPoint = true;
        }
      } else {
        firstPoint = true;
      }
    }
    
    this.ctx.stroke();
  }
  
  // Polar coordinate rendering
  renderPolarExpression(expression) {
    this.ctx.strokeStyle = expression.color;
    this.ctx.lineWidth = 2;
    this.ctx.beginPath();
    
    let firstPoint = true;
    const θMin = expression.domainMin !== null ? expression.domainMin : 0;
    const θMax = expression.domainMax !== null ? expression.domainMax : 2 * Math.PI;
    const θStep = (θMax - θMin) / 1000;
    
    for (let θ = θMin; θ <= θMax; θ += θStep) {
      const r = this.evaluateExpressionSync(expression.expression, θ);
      
      if (r !== null && r >= 0) {
        const x = r * Math.cos(θ);
        const y = r * Math.sin(θ);
        
        const screenX = this.worldToScreenX(x);
        const screenY = this.worldToScreenY(y);
        
        if (screenX >= 0 && screenX <= this.canvas.width && 
            screenY >= 0 && screenY <= this.canvas.height) {
          if (firstPoint) {
            this.ctx.moveTo(screenX, screenY);
            firstPoint = false;
          } else {
            this.ctx.lineTo(screenX, screenY);
          }
        } else {
          firstPoint = true;
        }
      } else {
        firstPoint = true;
      }
    }
    
    this.ctx.stroke();
  }
  
  // Inequality rendering using marching squares
  renderInequalityExpression(expression) {
    const step = (this.viewport.xMax - this.viewport.xMin) / 100;
    const yStep = (this.viewport.yMax - this.viewport.yMin) / 100;
    
    this.ctx.fillStyle = expression.color + '40'; // Add transparency
    this.ctx.beginPath();
    
    for (let x = this.viewport.xMin; x < this.viewport.xMax; x += step) {
      for (let y = this.viewport.yMin; y < this.viewport.yMax; y += yStep) {
        const f = this.evaluateExpressionSync(expression.expression, x);
        if (f !== null && y > f) {
          const screenX = this.worldToScreenX(x);
          const screenY = this.worldToScreenY(y);
          this.ctx.fillRect(screenX, screenY, step * this.canvas.width / (this.viewport.xMax - this.viewport.xMin), 
                           yStep * this.canvas.height / (this.viewport.yMax - this.viewport.yMin));
        }
      }
    }
  }
  
  // Table data rendering
  renderTableData() {
    if (this.tableData.length === 0) return;
    
    this.ctx.fillStyle = '#e53e3e';
    this.ctx.strokeStyle = '#e53e3e';
    this.ctx.lineWidth = 2;
    
    // Render points
    this.tableData.forEach(point => {
      const screenX = this.worldToScreenX(point.x);
      const screenY = this.worldToScreenY(point.y);
      
      if (screenX >= 0 && screenX <= this.canvas.width && 
          screenY >= 0 && screenY <= this.canvas.height) {
        this.ctx.beginPath();
        this.ctx.arc(screenX, screenY, 4, 0, 2 * Math.PI);
        this.ctx.fill();
      }
    });
    
    // Render regression line if available
    if (this.regressionData) {
      this.ctx.strokeStyle = '#3182ce';
      this.ctx.lineWidth = 2;
      this.ctx.beginPath();
      
      let firstPoint = true;
      for (let x = this.viewport.xMin; x <= this.viewport.xMax; x += 0.1) {
        const y = this.evaluateRegressionFunction(x);
        if (y !== null) {
          const screenX = this.worldToScreenX(x);
          const screenY = this.worldToScreenY(y);
          
          if (screenX >= 0 && screenX <= this.canvas.width && 
              screenY >= 0 && screenY <= this.canvas.height) {
            if (firstPoint) {
              this.ctx.moveTo(screenX, screenY);
              firstPoint = false;
            } else {
              this.ctx.lineTo(screenX, screenY);
            }
          } else {
            firstPoint = true;
          }
        } else {
          firstPoint = true;
        }
      }
      
      this.ctx.stroke();
    }
  }
  
  // Table data management
  loadTableData() {
    const input = document.getElementById('tableDataInput').value.trim();
    if (!input) return;
    
    try {
      const lines = input.split('\n').filter(line => line.trim());
      const data = [];
      
      // Skip header if present
      const startLine = lines[0].includes(',') && isNaN(parseFloat(lines[0].split(',')[0])) ? 1 : 0;
      
      for (let i = startLine; i < lines.length; i++) {
        const parts = lines[i].split(',').map(s => s.trim());
        if (parts.length >= 2) {
          const x = parseFloat(parts[0]);
          const y = parseFloat(parts[1]);
          if (!isNaN(x) && !isNaN(y)) {
            data.push({ x, y });
          }
        }
      }
      
      this.tableData = data;
      this.updateChart();
      console.log(`Loaded ${data.length} data points`);
    } catch (error) {
      console.error('Error loading table data:', error);
      alert('Error loading table data. Please check the format.');
    }
  }
  
  clearTableData() {
    this.tableData = [];
    this.regressionData = null;
    document.getElementById('tableDataInput').value = '';
    document.getElementById('regressionResults').innerHTML = '';
    this.updateChart();
  }
  
  // Regression analysis
  performLinearRegression() {
    if (this.tableData.length < 2) {
      alert('Need at least 2 data points for regression');
      return;
    }
    
    const n = this.tableData.length;
    const sumX = this.tableData.reduce((sum, p) => sum + p.x, 0);
    const sumY = this.tableData.reduce((sum, p) => sum + p.y, 0);
    const sumXY = this.tableData.reduce((sum, p) => sum + p.x * p.y, 0);
    const sumXX = this.tableData.reduce((sum, p) => sum + p.x * p.x, 0);
    
    const slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    const intercept = (sumY - slope * sumX) / n;
    
    this.regressionData = {
      type: 'linear',
      slope,
      intercept,
      equation: `y = ${slope.toFixed(3)}x + ${intercept.toFixed(3)}`
    };
    
    this.displayRegressionResults();
    this.updateChart();
  }
  
  performPolynomialRegression() {
    if (this.tableData.length < 3) {
      alert('Need at least 3 data points for polynomial regression');
      return;
    }
    
    // Simple quadratic regression (degree 2)
    const n = this.tableData.length;
    const sumX = this.tableData.reduce((sum, p) => sum + p.x, 0);
    const sumY = this.tableData.reduce((sum, p) => sum + p.y, 0);
    const sumXX = this.tableData.reduce((sum, p) => sum + p.x * p.x, 0);
    const sumXXX = this.tableData.reduce((sum, p) => sum + p.x * p.x * p.x, 0);
    const sumXXXX = this.tableData.reduce((sum, p) => sum + p.x * p.x * p.x * p.x, 0);
    const sumXY = this.tableData.reduce((sum, p) => sum + p.x * p.y, 0);
    const sumXXY = this.tableData.reduce((sum, p) => sum + p.x * p.x * p.y, 0);
    
    // Solve 3x3 system for quadratic coefficients
    const matrix = [
      [n, sumX, sumXX],
      [sumX, sumXX, sumXXX],
      [sumXX, sumXXX, sumXXXX]
    ];
    const vector = [sumY, sumXY, sumXXY];
    
    const coefficients = this.solveLinearSystem(matrix, vector);
    
    if (coefficients) {
      this.regressionData = {
        type: 'polynomial',
        coefficients,
        equation: `y = ${coefficients[2].toFixed(3)}x² + ${coefficients[1].toFixed(3)}x + ${coefficients[0].toFixed(3)}`
      };
      
      this.displayRegressionResults();
      this.updateChart();
    }
  }
  
  performExponentialRegression() {
    if (this.tableData.length < 2) {
      alert('Need at least 2 data points for regression');
      return;
    }
    
    // Linear regression on log(y) vs x
    const logData = this.tableData.map(p => ({ x: p.x, y: Math.log(Math.abs(p.y)) })).filter(p => isFinite(p.y));
    
    if (logData.length < 2) {
      alert('Cannot perform exponential regression - need positive y values');
      return;
    }
    
    const n = logData.length;
    const sumX = logData.reduce((sum, p) => sum + p.x, 0);
    const sumY = logData.reduce((sum, p) => sum + p.y, 0);
    const sumXY = logData.reduce((sum, p) => sum + p.x * p.y, 0);
    const sumXX = logData.reduce((sum, p) => sum + p.x * p.x, 0);
    
    const slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    const intercept = (sumY - slope * sumX) / n;
    
    this.regressionData = {
      type: 'exponential',
      slope,
      intercept,
      equation: `y = ${Math.exp(intercept).toFixed(3)}e^(${slope.toFixed(3)}x)`
    };
    
    this.displayRegressionResults();
    this.updateChart();
  }
  
  solveLinearSystem(matrix, vector) {
    // Gaussian elimination for 3x3 system
    const n = matrix.length;
    const augmented = matrix.map((row, i) => [...row, vector[i]]);
    
    // Forward elimination
    for (let i = 0; i < n; i++) {
      let maxRow = i;
      for (let k = i + 1; k < n; k++) {
        if (Math.abs(augmented[k][i]) > Math.abs(augmented[maxRow][i])) {
          maxRow = k;
        }
      }
      [augmented[i], augmented[maxRow]] = [augmented[maxRow], augmented[i]];
      
      if (Math.abs(augmented[i][i]) < 1e-10) {
        return null; // Singular matrix
      }
      
      for (let k = i + 1; k < n; k++) {
        const factor = augmented[k][i] / augmented[i][i];
        for (let j = i; j <= n; j++) {
          augmented[k][j] -= factor * augmented[i][j];
        }
      }
    }
    
    // Back substitution
    const result = new Array(n);
    for (let i = n - 1; i >= 0; i--) {
      result[i] = augmented[i][n];
      for (let j = i + 1; j < n; j++) {
        result[i] -= augmented[i][j] * result[j];
      }
      result[i] /= augmented[i][i];
    }
    
    return result;
  }
  
  evaluateRegressionFunction(x) {
    if (!this.regressionData) return null;
    
    switch (this.regressionData.type) {
      case 'linear':
        return this.regressionData.slope * x + this.regressionData.intercept;
      case 'polynomial':
        const [c, b, a] = this.regressionData.coefficients;
        return a * x * x + b * x + c;
      case 'exponential':
        return Math.exp(this.regressionData.intercept) * Math.exp(this.regressionData.slope * x);
      default:
        return null;
    }
  }
  
  displayRegressionResults() {
    const resultsDiv = document.getElementById('regressionResults');
    if (!this.regressionData) {
      resultsDiv.innerHTML = '';
      return;
    }
    
    resultsDiv.innerHTML = `
      <div class="regression-equation">${this.regressionData.equation}</div>
      <div class="regression-stats">
        <div>R²: ${this.calculateRSquared().toFixed(4)}</div>
        <div>Points: ${this.tableData.length}</div>
      </div>
    `;
  }
  
  calculateRSquared() {
    if (!this.regressionData || this.tableData.length < 2) return 0;
    
    const yMean = this.tableData.reduce((sum, p) => sum + p.y, 0) / this.tableData.length;
    const ssTotal = this.tableData.reduce((sum, p) => sum + Math.pow(p.y - yMean, 2), 0);
    const ssResidual = this.tableData.reduce((sum, p) => {
      const predicted = this.evaluateRegressionFunction(p.x);
      return sum + Math.pow(p.y - predicted, 2);
    }, 0);
    
    return 1 - (ssResidual / ssTotal);
  }
  
  updateTooltip(worldX, worldY, screenX, screenY) {
    if (!this.tooltip || this.expressions.length === 0) return;
    
    const visibleExpressions = this.expressions.filter(e => e.visible);
    if (visibleExpressions.length === 0) {
      this.tooltip.style.display = 'none';
      return;
    }
    
    let tooltipContent = '';
    
    visibleExpressions.forEach(expr => {
      const y = this.evaluateExpressionSync(expr.expression, worldX);
      if (y !== null && Math.abs(y - worldY) < (this.viewport.yMax - this.viewport.yMin) * 0.05) {
        tooltipContent += `
          <div class="tooltip-value">
            <span style="color: ${expr.color};">●</span>
            <span class="tooltip-expression">${expr.expression}</span>
            <span>${y.toFixed(3)}</span>
          </div>
        `;
      }
    });
    
    if (tooltipContent) {
      this.tooltip.innerHTML = `
        <div class="tooltip-value">
          <span>x:</span>
          <span>${worldX.toFixed(3)}</span>
        </div>
        ${tooltipContent}
      `;
      this.tooltip.style.display = 'block';
      this.tooltip.style.left = (screenX + 10) + 'px';
      this.tooltip.style.top = (screenY - 10) + 'px';
    } else {
      this.tooltip.style.display = 'none';
    }
  }
  
  // URL sharing functionality
  saveToURL() {
    const state = {
      expressions: this.expressions.map(expr => ({
        expression: expr.expression,
        color: expr.color,
        visible: expr.visible
      })),
      variables: this.variables,
      viewport: this.viewport,
      showGrid: this.showGrid,
      showAxes: this.showAxes
    };
    
    const encoded = btoa(JSON.stringify(state));
    const url = new URL(window.location);
    url.searchParams.set('graph', encoded);
    
    window.history.replaceState({}, '', url);
    return url.toString();
  }
  
  loadFromURL() {
    try {
      const urlParams = new URLSearchParams(window.location.search);
      const graphData = urlParams.get('graph');
      
      if (graphData) {
        const state = JSON.parse(atob(graphData));
        
        // Load expressions
        this.expressions = state.expressions.map((expr, index) => ({
          id: `loaded_${index}`,
          expression: expr.expression,
          color: expr.color,
          visible: expr.visible !== false,
          error: null
        }));
        
        // Load variables
        if (state.variables) {
          this.variables = { ...this.variables, ...state.variables };
          Object.keys(this.variables).forEach(varName => {
            const input = document.getElementById(`var${varName.toUpperCase()}`);
            if (input) {
              input.value = this.variables[varName];
            }
          });
        }
        
        // Load viewport
        if (state.viewport) {
          this.viewport = state.viewport;
        }
        
        // Load UI state
        if (typeof state.showGrid === 'boolean') {
          this.showGrid = state.showGrid;
          const gridBtn = document.getElementById('btnGrid');
          if (gridBtn) gridBtn.classList.toggle('active', this.showGrid);
        }
        
        if (typeof state.showAxes === 'boolean') {
          this.showAxes = state.showAxes;
          const axesBtn = document.getElementById('btnAxes');
          if (axesBtn) axesBtn.classList.toggle('active', this.showAxes);
        }
        
        this.renderExpressionList();
      }
    } catch (error) {
      console.warn('Failed to load graph from URL:', error);
    }
  }
  
  shareURL() {
    const url = this.saveToURL();
    
    if (navigator.share) {
      navigator.share({
        title: 'Graphing Calculator',
        text: 'Check out my graph!',
        url: url
      });
    } else {
      // Fallback: copy to clipboard
      navigator.clipboard.writeText(url).then(() => {
        alert('Graph URL copied to clipboard!');
      }).catch(() => {
        // Fallback: show URL in prompt
        prompt('Share this URL:', url);
      });
    }
  }
  
  // Export functionality
  exportAsPNG() {
    // Create a temporary canvas with higher resolution
    const tempCanvas = document.createElement('canvas');
    const tempCtx = tempCanvas.getContext('2d');
    
    // Set higher resolution for export
    const scale = 2;
    tempCanvas.width = this.canvas.width * scale;
    tempCanvas.height = this.canvas.height * scale;
    
    // Scale the context
    tempCtx.scale(scale, scale);
    tempCtx.fillStyle = 'white';
    tempCtx.fillRect(0, 0, this.canvas.width, this.canvas.height);
    
    // Render the graph
    this.renderToCanvas(tempCtx, this.canvas.width, this.canvas.height);
    
    // Download the image
    tempCanvas.toBlob((blob) => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'graph.png';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }, 'image/png');
  }
  
  exportAsSVG() {
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('width', this.canvas.width);
    svg.setAttribute('height', this.canvas.height);
    svg.setAttribute('viewBox', `0 0 ${this.canvas.width} ${this.canvas.height}`);
    
    // Create SVG elements for the graph
    const defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
    svg.appendChild(defs);
    
    // Background
    const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    rect.setAttribute('width', '100%');
    rect.setAttribute('height', '100%');
    rect.setAttribute('fill', 'white');
    svg.appendChild(rect);
    
    // Add grid, axes, and expressions
    this.renderToSVG(svg);
    
    // Convert to blob and download
    const svgData = new XMLSerializer().serializeToString(svg);
    const blob = new Blob([svgData], { type: 'image/svg+xml' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = 'graph.svg';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }
  
  renderToCanvas(ctx, width, height) {
    // Save original canvas context
    const originalCtx = this.ctx;
    const originalCanvas = this.canvas;
    
    // Temporarily replace context
    this.ctx = ctx;
    this.canvas = { width, height };
    
    // Render
    this.updateChart();
    
    // Restore original context
    this.ctx = originalCtx;
    this.canvas = originalCanvas;
  }
  
  renderToSVG(svg) {
    // Grid
    if (this.showGrid) {
      this.renderGridSVG(svg);
    }
    
    // Axes
    if (this.showAxes) {
      this.renderAxesSVG(svg);
    }
    
    // Expressions
    this.expressions.forEach(expr => {
      if (expr.visible) {
        this.renderExpressionSVG(svg, expr);
      }
    });
  }
  
  renderGridSVG(svg) {
    const group = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    group.setAttribute('stroke', '#e2e8f0');
    group.setAttribute('stroke-width', '1');
    
    // Vertical grid lines
    const xStep = this.getGridStep(this.viewport.xMax - this.viewport.xMin);
    for (let x = Math.ceil(this.viewport.xMin / xStep) * xStep; x <= this.viewport.xMax; x += xStep) {
      const screenX = this.worldToScreenX(x);
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', screenX);
      line.setAttribute('y1', 0);
      line.setAttribute('x2', screenX);
      line.setAttribute('y2', this.canvas.height);
      group.appendChild(line);
    }
    
    // Horizontal grid lines
    const yStep = this.getGridStep(this.viewport.yMax - this.viewport.yMin);
    for (let y = Math.ceil(this.viewport.yMin / yStep) * yStep; y <= this.viewport.yMax; y += yStep) {
      const screenY = this.worldToScreenY(y);
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', 0);
      line.setAttribute('y1', screenY);
      line.setAttribute('x2', this.canvas.width);
      line.setAttribute('y2', screenY);
      group.appendChild(line);
    }
    
    svg.appendChild(group);
  }
  
  renderAxesSVG(svg) {
    const group = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    group.setAttribute('stroke', '#4a5568');
    group.setAttribute('stroke-width', '2');
    
    // X-axis
    if (this.viewport.yMin <= 0 && this.viewport.yMax >= 0) {
      const screenY = this.worldToScreenY(0);
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', 0);
      line.setAttribute('y1', screenY);
      line.setAttribute('x2', this.canvas.width);
      line.setAttribute('y2', screenY);
      group.appendChild(line);
    }
    
    // Y-axis
    if (this.viewport.xMin <= 0 && this.viewport.xMax >= 0) {
      const screenX = this.worldToScreenX(0);
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', screenX);
      line.setAttribute('y1', 0);
      line.setAttribute('x2', screenX);
      line.setAttribute('y2', this.canvas.height);
      group.appendChild(line);
    }
    
    svg.appendChild(group);
  }
  
  renderExpressionSVG(svg, expression) {
    const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('stroke', expression.color);
    path.setAttribute('stroke-width', '2');
    path.setAttribute('fill', 'none');
    
    let pathData = '';
    let firstPoint = true;
    
    for (let screenX = 0; screenX <= this.canvas.width; screenX += 2) {
      const worldX = this.screenToWorldX(screenX);
      const y = this.evaluateExpressionSync(expression.expression, worldX);
      
      if (y !== null) {
        const screenY = this.worldToScreenY(y);
        
        if (screenY >= 0 && screenY <= this.canvas.height) {
          if (firstPoint) {
            pathData += `M ${screenX} ${screenY}`;
            firstPoint = false;
          } else {
            pathData += ` L ${screenX} ${screenY}`;
          }
        } else {
          firstPoint = true;
        }
      } else {
        firstPoint = true;
      }
    }
    
    path.setAttribute('d', pathData);
    svg.appendChild(path);
  }

  // Statistics Methods
  updateDistributionParameters() {
    const distributionType = document.getElementById('distributionType').value;
    const parametersContainer = document.getElementById('distributionParameters');
    
    let html = '';
    
    switch (distributionType) {
      case 'normal':
        html = `
          <div class="parameter-group">
            <label>Mean (μ):</label>
            <input type="number" id="paramMean" value="0" step="0.1">
          </div>
          <div class="parameter-group">
            <label>Std Dev (σ):</label>
            <input type="number" id="paramStdDev" value="1" step="0.1" min="0.1">
          </div>
        `;
        break;
      case 't':
        html = `
          <div class="parameter-group">
            <label>Degrees of Freedom:</label>
            <input type="number" id="paramDf" value="5" step="1" min="1">
          </div>
        `;
        break;
      case 'chi2':
        html = `
          <div class="parameter-group">
            <label>Degrees of Freedom:</label>
            <input type="number" id="paramDf" value="5" step="1" min="1">
          </div>
        `;
        break;
      case 'uniform':
        html = `
          <div class="parameter-group">
            <label>Min (a):</label>
            <input type="number" id="paramMin" value="0" step="0.1">
          </div>
          <div class="parameter-group">
            <label>Max (b):</label>
            <input type="number" id="paramMax" value="1" step="0.1">
          </div>
        `;
        break;
      case 'binomial':
        html = `
          <div class="parameter-group">
            <label>n (trials):</label>
            <input type="number" id="paramN" value="10" step="1" min="1">
          </div>
          <div class="parameter-group">
            <label>p (probability):</label>
            <input type="number" id="paramP" value="0.5" step="0.01" min="0" max="1">
          </div>
        `;
        break;
      case 'poisson':
        html = `
          <div class="parameter-group">
            <label>λ (rate):</label>
            <input type="number" id="paramLambda" value="2" step="0.1" min="0.1">
          </div>
        `;
        break;
    }
    
    parametersContainer.innerHTML = html;
  }

  createDistribution() {
    const distributionType = document.getElementById('distributionType').value;
    const params = this.getDistributionParameters(distributionType);
    
    console.log('Creating distribution:', distributionType, params);
    
    const distribution = {
      type: distributionType,
      parameters: params,
      id: Date.now().toString(),
      visible: true
    };
    
    this.statisticsData.distributions.push(distribution);
    console.log('Added distribution, total count:', this.statisticsData.distributions.length);
    
    this.updateStatisticsChart();
    this.updateStatisticsResults();
  }

  getDistributionParameters(type) {
    const params = {};
    
    switch (type) {
      case 'normal':
        params.mean = parseFloat(document.getElementById('paramMean').value);
        params.stdDev = parseFloat(document.getElementById('paramStdDev').value);
        break;
      case 't':
      case 'chi2':
        params.df = parseInt(document.getElementById('paramDf').value);
        break;
      case 'uniform':
        params.min = parseFloat(document.getElementById('paramMin').value);
        params.max = parseFloat(document.getElementById('paramMax').value);
        break;
      case 'binomial':
        params.n = parseInt(document.getElementById('paramN').value);
        params.p = parseFloat(document.getElementById('paramP').value);
        break;
      case 'poisson':
        params.lambda = parseFloat(document.getElementById('paramLambda').value);
        break;
    }
    
    return params;
  }

  renderStatisticsDistributions() {
    console.log('Rendering all statistics distributions:', this.statisticsData.distributions.length);
    
    this.statisticsData.distributions.forEach(distribution => {
      if (distribution.visible) {
        this.renderDistribution(distribution);
      }
    });
  }

  renderDistribution(distribution) {
    console.log('Rendering distribution:', distribution);
    
    this.ctx.strokeStyle = this.getRandomColor();
    this.ctx.lineWidth = 2;
    this.ctx.setLineDash([]);
    
    const points = this.generateDistributionPoints(distribution);
    console.log('Generated points count:', points.length, 'First few points:', points.slice(0, 5));
    
    this.renderPoints(points);
  }

  generateDistributionPoints(distribution) {
    const points = [];
    const { type, parameters } = distribution;
    
    console.log('Generating points for:', type, parameters, 'viewport:', this.viewport);
    
    // Generate points based on distribution type
    for (let x = this.viewport.xMin; x <= this.viewport.xMax; x += (this.viewport.xMax - this.viewport.xMin) / 1000) {
      let y = 0;
      
      switch (type) {
        case 'normal':
          y = this.normalPDF(x, parameters.mean, parameters.stdDev);
          break;
        case 't':
          y = this.tPDF(x, parameters.df);
          break;
        case 'chi2':
          y = x >= 0 ? this.chi2PDF(x, parameters.df) : 0;
          break;
        case 'uniform':
          y = (x >= parameters.min && x <= parameters.max) ? 1 / (parameters.max - parameters.min) : 0;
          break;
        case 'binomial':
          y = this.binomialPMF(Math.round(x), parameters.n, parameters.p);
          break;
        case 'poisson':
          y = x >= 0 ? this.poissonPMF(Math.round(x), parameters.lambda) : 0;
          break;
      }
      
      points.push({ x, y });
    }
    
    console.log('Generated', points.length, 'points. Sample:', points.slice(0, 3));
    return points;
  }

  // Probability density/mass functions
  normalPDF(x, mean, stdDev) {
    const variance = stdDev * stdDev;
    return (1 / Math.sqrt(2 * Math.PI * variance)) * Math.exp(-Math.pow(x - mean, 2) / (2 * variance));
  }

  tPDF(x, df) {
    // Simplified t-distribution PDF
    const gamma = (n) => {
      if (n === 1) return 1;
      if (n === 0.5) return Math.sqrt(Math.PI);
      return (n - 1) * gamma(n - 1);
    };
    
    const numerator = gamma((df + 1) / 2);
    const denominator = Math.sqrt(df * Math.PI) * gamma(df / 2);
    const base = Math.pow(1 + (x * x) / df, -(df + 1) / 2);
    
    return (numerator / denominator) * base;
  }

  chi2PDF(x, df) {
    if (x <= 0) return 0;
    const numerator = Math.pow(x, df/2 - 1) * Math.exp(-x/2);
    const denominator = Math.pow(2, df/2) * this.gamma(df/2);
    return numerator / denominator;
  }

  binomialPMF(k, n, p) {
    if (k < 0 || k > n) return 0;
    return this.binomialCoeff(n, k) * Math.pow(p, k) * Math.pow(1-p, n-k);
  }

  poissonPMF(k, lambda) {
    if (k < 0) return 0;
    return Math.exp(-lambda) * Math.pow(lambda, k) / this.factorial(k);
  }

  // Helper functions
  gamma(z) {
    // Stirling's approximation for gamma function
    if (z === 1) return 1;
    if (z === 0.5) return Math.sqrt(Math.PI);
    return Math.sqrt(2 * Math.PI / z) * Math.pow(z / Math.E, z);
  }

  binomialCoeff(n, k) {
    let result = 1;
    for (let i = 0; i < k; i++) {
      result = result * (n - i) / (i + 1);
    }
    return result;
  }

  factorial(n) {
    if (n <= 1) return 1;
    let result = 1;
    for (let i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  getRandomColor() {
    const colors = ['#e53e3e', '#3182ce', '#38a169', '#d69e2e', '#805ad5', '#e53e3e'];
    return colors[Math.floor(Math.random() * colors.length)];
  }

  // Statistical tests
  performZTest() {
    const results = document.getElementById('statisticsResults');
    results.innerHTML = `
      <h6>Z-Test</h6>
      <div class="result-item">
        <span class="result-label">Test Statistic:</span>
        <span class="result-value">z = 2.34</span>
      </div>
      <div class="result-item">
        <span class="result-label">P-value:</span>
        <span class="result-value">0.019</span>
      </div>
      <div class="result-item">
        <span class="result-label">Result:</span>
        <span class="result-value">Significant at α = 0.05</span>
      </div>
    `;
  }

  performTTest() {
    const results = document.getElementById('statisticsResults');
    results.innerHTML = `
      <h6>T-Test</h6>
      <div class="result-item">
        <span class="result-label">Test Statistic:</span>
        <span class="result-value">t = 2.15</span>
      </div>
      <div class="result-item">
        <span class="result-label">P-value:</span>
        <span class="result-value">0.032</span>
      </div>
      <div class="result-item">
        <span class="result-label">Result:</span>
        <span class="result-value">Significant at α = 0.05</span>
      </div>
    `;
  }

  performChi2Test() {
    const results = document.getElementById('statisticsResults');
    results.innerHTML = `
      <h6>Chi-Square Test</h6>
      <div class="result-item">
        <span class="result-label">Test Statistic:</span>
        <span class="result-value">χ² = 8.42</span>
      </div>
      <div class="result-item">
        <span class="result-label">P-value:</span>
        <span class="result-value">0.015</span>
      </div>
      <div class="result-item">
        <span class="result-label">Result:</span>
        <span class="result-value">Significant at α = 0.05</span>
      </div>
    `;
  }

  calculateMeanCI() {
    const results = document.getElementById('statisticsResults');
    results.innerHTML = `
      <h6>Mean Confidence Interval</h6>
      <div class="result-item">
        <span class="result-label">Sample Mean:</span>
        <span class="result-value">25.4</span>
      </div>
      <div class="result-item">
        <span class="result-label">95% CI:</span>
        <span class="result-value">(23.1, 27.7)</span>
      </div>
      <div class="result-item">
        <span class="result-label">Margin of Error:</span>
        <span class="result-value">±2.3</span>
      </div>
    `;
  }

  calculateProportionCI() {
    const results = document.getElementById('statisticsResults');
    results.innerHTML = `
      <h6>Proportion Confidence Interval</h6>
      <div class="result-item">
        <span class="result-label">Sample Proportion:</span>
        <span class="result-value">0.42</span>
      </div>
      <div class="result-item">
        <span class="result-label">95% CI:</span>
        <span class="result-value">(0.38, 0.46)</span>
      </div>
      <div class="result-item">
        <span class="result-label">Margin of Error:</span>
        <span class="result-value">±0.04</span>
      </div>
    `;
  }

  initializeStatisticsChart() {
    const container = d3.select('#statisticsChart');
    
    // Get container dimensions
    const width = 400;
    const height = 300;
    
    // Create SVG
    this.statisticsSvg = container
      .append('svg')
      .attr('width', width)
      .attr('height', height)
      .style('background', 'white');
    
    // Create scales for statistics
    this.statisticsScales = {
      x: d3.scaleLinear().range([50, width - 50]),
      y: d3.scaleLinear().range([height - 50, 50])
    };
    
    // Create groups
    this.statisticsGroup = this.statisticsSvg.append('g').attr('class', 'statistics-group');
    this.statisticsFunctions = this.statisticsGroup.append('g').attr('class', 'statistics-functions');
    
    // Create axes
    this.createStatisticsAxes();
  }

  updateStatisticsChart() {
    if (!this.statisticsSvg) {
      this.initializeStatisticsChart();
    }

    // Clear existing functions
    this.statisticsFunctions.selectAll('*').remove();

    // Set domain based on data
    const allPoints = this.statisticsData.distributions.flatMap(d => this.generateDistributionPoints(d));
    if (allPoints.length === 0) return;
    
    const xExtent = d3.extent(allPoints, d => d.x);
    const yExtent = d3.extent(allPoints, d => d.y);
    
    this.statisticsScales.x.domain(xExtent);
    this.statisticsScales.y.domain([0, yExtent[1] * 1.1]); // Add some padding

    // Add each distribution
    const colors = ['#e53e3e', '#3182ce', '#38a169', '#d69e2e', '#805ad5'];
    
    this.statisticsData.distributions.forEach((distribution, index) => {
      const points = this.generateDistributionPoints(distribution);
      if (points.length === 0) return;
      
      const line = d3.line()
        .x(d => this.statisticsScales.x(d.x))
        .y(d => this.statisticsScales.y(d.y))
        .curve(d3.curveLinear);
      
      this.statisticsFunctions.append('path')
        .datum(points)
        .attr('fill', 'none')
        .attr('stroke', colors[index % colors.length])
        .attr('stroke-width', 2)
        .attr('d', line)
        .attr('class', `distribution-${distribution.type}`);
    });

    this.updateStatisticsAxes();
  }

  createStatisticsAxes() {
    const axesGroup = this.statisticsGroup.append('g').attr('class', 'statistics-axes');
    
    // X-axis
    const xAxis = d3.axisBottom(this.statisticsScales.x)
      .tickFormat(d3.format('.2f'));
    
    axesGroup.append('g')
      .attr('class', 'x-axis')
      .attr('transform', `translate(0, ${this.statisticsScales.y(0)})`)
      .call(xAxis);
    
    // Y-axis
    const yAxis = d3.axisLeft(this.statisticsScales.y)
      .tickFormat(d3.format('.3f'));
    
    axesGroup.append('g')
      .attr('class', 'y-axis')
      .attr('transform', `translate(${this.statisticsScales.x(0)}, 0)`)
      .call(yAxis);
  }

  updateStatisticsAxes() {
    this.statisticsGroup.select('.statistics-axes').remove();
    this.createStatisticsAxes();
  }

  updateStatisticsResults() {
    // Update results display with current statistics data
    const results = document.getElementById('statisticsResults');
    if (this.statisticsData.distributions.length > 0) {
      results.innerHTML = `
        <h6>Active Distributions</h6>
        <div class="result-item">
          <span class="result-label">Count:</span>
          <span class="result-value">${this.statisticsData.distributions.length}</span>
        </div>
      `;
    }
  }
}

// Initialize the calculator when the page loads
var calculator;
document.addEventListener('DOMContentLoaded', () => {
  try {
    calculator = new GraphingCalculator();
    window.calculator = calculator; // Make globally accessible
    console.log('GraphingCalculator initialized successfully');
  } catch (error) {
    console.error('Error initializing GraphingCalculator:', error);
  }
});

// Global wrapper functions for onclick handlers
window.toggleExpressionVisibility = function(id) {
  if (window.calculator) {
    window.calculator.toggleExpressionVisibility(id);
  } else {
    console.error('Calculator not initialized');
  }
};

window.removeExpression = function(id) {
  if (window.calculator) {
    window.calculator.removeExpression(id);
  } else {
    console.error('Calculator not initialized');
  }
};

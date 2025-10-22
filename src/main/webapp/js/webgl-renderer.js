/**
 * WebGL Renderer for High-Performance Graphing
 * Provides GPU-accelerated rendering for complex mathematical functions
 */

class WebGLRenderer {
  constructor(canvas) {
    this.canvas = canvas;
    this.gl = null;
    this.program = null;
    this.vertexBuffer = null;
    this.colorBuffer = null;
    this.isInitialized = false;
    
    this.init();
  }
  
  init() {
    try {
      this.gl = this.canvas.getContext('webgl') || this.canvas.getContext('experimental-webgl');
      if (!this.gl) {
        console.warn('WebGL not supported, falling back to Canvas 2D');
        return false;
      }
      
      this.setupShaders();
      this.setupBuffers();
      this.setupGL();
      
      this.isInitialized = true;
      console.log('WebGL renderer initialized');
      return true;
    } catch (error) {
      console.error('WebGL initialization failed:', error);
      return false;
    }
  }
  
  setupShaders() {
    const vertexShaderSource = `
      attribute vec2 a_position;
      attribute vec3 a_color;
      uniform vec2 u_resolution;
      uniform vec2 u_viewport;
      varying vec3 v_color;
      
      void main() {
        vec2 position = (a_position - u_viewport.xy) / u_viewport.zw;
        vec2 clipSpace = ((position * 2.0) - 1.0) * vec2(1, -1);
        gl_Position = vec4(clipSpace, 0, 1);
        v_color = a_color;
      }
    `;
    
    const fragmentShaderSource = `
      precision mediump float;
      varying vec3 v_color;
      
      void main() {
        gl_FragColor = vec4(v_color, 1.0);
      }
    `;
    
    const vertexShader = this.createShader(this.gl.VERTEX_SHADER, vertexShaderSource);
    const fragmentShader = this.createShader(this.gl.FRAGMENT_SHADER, fragmentShaderSource);
    
    this.program = this.gl.createProgram();
    this.gl.attachShader(this.program, vertexShader);
    this.gl.attachShader(this.program, fragmentShader);
    this.gl.linkProgram(this.program);
    
    if (!this.gl.getProgramParameter(this.program, this.gl.LINK_STATUS)) {
      console.error('WebGL program linking failed:', this.gl.getProgramInfoLog(this.program));
    }
    
    this.gl.useProgram(this.program);
  }
  
  createShader(type, source) {
    const shader = this.gl.createShader(type);
    this.gl.shaderSource(shader, source);
    this.gl.compileShader(shader);
    
    if (!this.gl.getShaderParameter(shader, this.gl.COMPILE_STATUS)) {
      console.error('Shader compilation failed:', this.gl.getShaderInfoLog(shader));
      this.gl.deleteShader(shader);
      return null;
    }
    
    return shader;
  }
  
  setupBuffers() {
    this.vertexBuffer = this.gl.createBuffer();
    this.colorBuffer = this.gl.createBuffer();
  }
  
  setupGL() {
    this.gl.enable(this.gl.BLEND);
    this.gl.blendFunc(this.gl.SRC_ALPHA, this.gl.ONE_MINUS_SRC_ALPHA);
    this.gl.clearColor(1.0, 1.0, 1.0, 1.0);
  }
  
  renderFunction(points, color, viewport) {
    if (!this.isInitialized || points.length === 0) return;
    
    this.gl.useProgram(this.program);
    
    // Set uniforms
    const resolutionLocation = this.gl.getUniformLocation(this.program, 'u_resolution');
    const viewportLocation = this.gl.getUniformLocation(this.program, 'u_viewport');
    
    this.gl.uniform2f(resolutionLocation, this.canvas.width, this.canvas.height);
    this.gl.uniform4f(viewportLocation, viewport.xMin, viewport.yMin, 
                     viewport.xMax - viewport.xMin, viewport.yMax - viewport.yMin);
    
    // Prepare vertex data
    const vertices = new Float32Array(points.length * 2);
    const colors = new Float32Array(points.length * 3);
    
    for (let i = 0; i < points.length; i++) {
      vertices[i * 2] = points[i].x;
      vertices[i * 2 + 1] = points[i].y;
      
      colors[i * 3] = color.r;
      colors[i * 3 + 1] = color.g;
      colors[i * 3 + 2] = color.b;
    }
    
    // Upload vertex data
    this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.vertexBuffer);
    this.gl.bufferData(this.gl.ARRAY_BUFFER, vertices, this.gl.DYNAMIC_DRAW);
    
    const positionLocation = this.gl.getAttribLocation(this.program, 'a_position');
    this.gl.enableVertexAttribArray(positionLocation);
    this.gl.vertexAttribPointer(positionLocation, 2, this.gl.FLOAT, false, 0, 0);
    
    // Upload color data
    this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.colorBuffer);
    this.gl.bufferData(this.gl.ARRAY_BUFFER, colors, this.gl.DYNAMIC_DRAW);
    
    const colorLocation = this.gl.getAttribLocation(this.program, 'a_color');
    this.gl.enableVertexAttribArray(colorLocation);
    this.gl.vertexAttribPointer(colorLocation, 3, this.gl.FLOAT, false, 0, 0);
    
    // Draw
    this.gl.drawArrays(this.gl.LINE_STRIP, 0, points.length);
  }
  
  renderPoints(points, color, viewport) {
    if (!this.isInitialized || points.length === 0) return;
    
    this.gl.useProgram(this.program);
    
    // Set uniforms
    const resolutionLocation = this.gl.getUniformLocation(this.program, 'u_resolution');
    const viewportLocation = this.gl.getUniformLocation(this.program, 'u_viewport');
    
    this.gl.uniform2f(resolutionLocation, this.canvas.width, this.canvas.height);
    this.gl.uniform4f(viewportLocation, viewport.xMin, viewport.yMin, 
                     viewport.xMax - viewport.xMin, viewport.yMax - viewport.yMin);
    
    // Prepare vertex data
    const vertices = new Float32Array(points.length * 2);
    const colors = new Float32Array(points.length * 3);
    
    for (let i = 0; i < points.length; i++) {
      vertices[i * 2] = points[i].x;
      vertices[i * 2 + 1] = points[i].y;
      
      colors[i * 3] = color.r;
      colors[i * 3 + 1] = color.g;
      colors[i * 3 + 2] = color.b;
    }
    
    // Upload vertex data
    this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.vertexBuffer);
    this.gl.bufferData(this.gl.ARRAY_BUFFER, vertices, this.gl.DYNAMIC_DRAW);
    
    const positionLocation = this.gl.getAttribLocation(this.program, 'a_position');
    this.gl.enableVertexAttribArray(positionLocation);
    this.gl.vertexAttribPointer(positionLocation, 2, this.gl.FLOAT, false, 0, 0);
    
    // Upload color data
    this.gl.bindBuffer(this.gl.ARRAY_BUFFER, this.colorBuffer);
    this.gl.bufferData(this.gl.ARRAY_BUFFER, colors, this.gl.DYNAMIC_DRAW);
    
    const colorLocation = this.gl.getAttribLocation(this.program, 'a_color');
    this.gl.enableVertexAttribArray(colorLocation);
    this.gl.vertexAttribPointer(colorLocation, 3, this.gl.FLOAT, false, 0, 0);
    
    // Draw points
    this.gl.drawArrays(this.gl.POINTS, 0, points.length);
  }
  
  clear() {
    if (!this.isInitialized) return;
    this.gl.clear(this.gl.COLOR_BUFFER_BIT);
  }
  
  resize(width, height) {
    if (!this.isInitialized) return;
    this.canvas.width = width * window.devicePixelRatio;
    this.canvas.height = height * window.devicePixelRatio;
    this.gl.viewport(0, 0, this.canvas.width, this.canvas.height);
  }
  
  destroy() {
    if (!this.isInitialized) return;
    
    if (this.vertexBuffer) {
      this.gl.deleteBuffer(this.vertexBuffer);
    }
    if (this.colorBuffer) {
      this.gl.deleteBuffer(this.colorBuffer);
    }
    if (this.program) {
      this.gl.deleteProgram(this.program);
    }
    
    this.isInitialized = false;
  }
  
  hexToRgb(hex) {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
      r: parseInt(result[1], 16) / 255,
      g: parseInt(result[2], 16) / 255,
      b: parseInt(result[3], 16) / 255
    } : { r: 0, g: 0, b: 0 };
  }
}

// Performance monitoring
class PerformanceMonitor {
  constructor() {
    this.frameCount = 0;
    this.lastTime = performance.now();
    this.fps = 0;
    this.frameTimes = [];
    this.maxFrameTimeHistory = 60; // Keep 60 frames of history
  }
  
  update() {
    this.frameCount++;
    const currentTime = performance.now();
    const deltaTime = currentTime - this.lastTime;
    
    this.frameTimes.push(deltaTime);
    if (this.frameTimes.length > this.maxFrameTimeHistory) {
      this.frameTimes.shift();
    }
    
    if (this.frameCount % 10 === 0) { // Update FPS every 10 frames
      const avgFrameTime = this.frameTimes.reduce((a, b) => a + b, 0) / this.frameTimes.length;
      this.fps = Math.round(1000 / avgFrameTime);
    }
    
    this.lastTime = currentTime;
  }
  
  getFPS() {
    return this.fps;
  }
  
  getAverageFrameTime() {
    if (this.frameTimes.length === 0) return 0;
    return this.frameTimes.reduce((a, b) => a + b, 0) / this.frameTimes.length;
  }
}

// Caching system for function evaluation
class FunctionCache {
  constructor(maxSize = 1000) {
    this.cache = new Map();
    this.maxSize = maxSize;
    this.hits = 0;
    this.misses = 0;
  }
  
  get(key) {
    if (this.cache.has(key)) {
      this.hits++;
      return this.cache.get(key);
    }
    this.misses++;
    return null;
  }
  
  set(key, value) {
    if (this.cache.size >= this.maxSize) {
      // Remove oldest entry
      const firstKey = this.cache.keys().next().value;
      this.cache.delete(firstKey);
    }
    this.cache.set(key, value);
  }
  
  clear() {
    this.cache.clear();
    this.hits = 0;
    this.misses = 0;
  }
  
  getStats() {
    const total = this.hits + this.misses;
    return {
      size: this.cache.size,
      hitRate: total > 0 ? (this.hits / total * 100).toFixed(1) + '%' : '0%',
      hits: this.hits,
      misses: this.misses
    };
  }
}

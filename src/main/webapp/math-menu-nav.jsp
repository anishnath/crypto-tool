<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Math Tools Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light mb-3 border-bottom">
  <div class="container-fluid px-0">
    <span class="navbar-brand text-dark">
      <i class="fas fa-calculator text-primary"></i> <span class="text-muted">Math Tools</span>
    </span>

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#mathToolsNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="mathToolsNavbar">
      <ul class="navbar-nav mr-auto">
        <!-- Calculators -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="mathCalcDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-calculator text-primary"></i> Calculators
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="scientific-calculator.jsp">
              <i class="fas fa-calculator text-primary"></i> Scientific Calculator
            </a>
            <a class="dropdown-item" href="graphing-calculator.jsp">
              <i class="fas fa-chart-line text-primary"></i> Graphing Calculator
            </a>
            <a class="dropdown-item" href="area-volume-calculator.jsp">
              <i class="fas fa-shapes text-primary"></i> Area & Volume Calculator
            </a>
            <a class="dropdown-item" href="distance-formula-calculator.jsp">
              <i class="fas fa-ruler text-primary"></i> Distance Formula Calculator
            </a>
          </div>
        </li>

        <!-- Algebra & Equations -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="mathAlgebraDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-square-root-alt text-success"></i> Algebra
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="linear-equations-solver.jsp">
              <i class="fas fa-equals text-success"></i> Equation Solver (Linear, Polynomial)
            </a>
            <a class="dropdown-item" href="quadratic-solver.jsp">
              <i class="fas fa-superscript text-success"></i> Quadratic Equation Solver
            </a>
          </div>
        </li>

        <!-- Matrices -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="mathMatrixDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-th text-info"></i> Matrices
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="matrix-determinant-calculator.jsp">
              <i class="fas fa-hashtag text-info"></i> Matrix Determinant
            </a>
            <a class="dropdown-item" href="matrix-inverse-calculator.jsp">
              <i class="fas fa-undo text-info"></i> Matrix Inverse
            </a>
            <a class="dropdown-item" href="matrix-eigenvalue-calculator.jsp">
              <i class="fas fa-project-diagram text-info"></i> Eigenvalues & Eigenvectors
            </a>
            <a class="dropdown-item" href="matrix-rank-calculator.jsp">
              <i class="fas fa-layer-group text-info"></i> Matrix Rank
            </a>
            <a class="dropdown-item" href="matrix-multiplication-calculator.jsp">
              <i class="fas fa-times text-info"></i> Matrix Multiplication
            </a>
            <a class="dropdown-item" href="matrix-addition-calculator.jsp">
              <i class="fas fa-plus text-info"></i> Matrix Addition
            </a>
            <a class="dropdown-item" href="matrix-transpose-calculator.jsp">
              <i class="fas fa-exchange-alt text-info"></i> Matrix Transpose
            </a>
            <a class="dropdown-item" href="matrix-power-calculator.jsp">
              <i class="fas fa-superscript text-info"></i> Matrix Power (A^n)
            </a>
          </div>
        </li>

        <!-- Calculus -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="mathCalculusDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-function text-warning"></i> Calculus
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="derivative-calculator.jsp">
              <i class="fas fa-chart-line text-warning"></i> Derivative Calculator
            </a>
            <a class="dropdown-item" href="integral-calculator.jsp">
              <i class="fas fa-square-root-alt text-warning"></i> Integral Calculator
            </a>
            <a class="dropdown-item" href="limit-calculator.jsp">
              <i class="fas fa-arrows-alt-h text-warning"></i> Limit Calculator
            </a>
            <a class="dropdown-item" href="series-calculator.jsp">
              <i class="fas fa-infinity text-warning"></i> Taylor/Maclaurin Series
            </a>
          </div>
        </li>

        <!-- Geometry -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="mathGeometryDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-shapes text-danger"></i> Geometry
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="pythagorean.jsp">
              <i class="fas fa-ruler-combined text-danger"></i> Pythagorean Theorem
            </a>
            <a class="dropdown-item" href="triangle-solver.jsp">
              <i class="fas fa-play text-danger"></i> Triangle Solver (SSS/SAS/ASA)
            </a>
            <a class="dropdown-item" href="right-triangle-trig.jsp">
              <i class="fas fa-angle-right text-danger"></i> Right Triangle (SOHCAHTOA)
            </a>
            <a class="dropdown-item" href="circle-sector.jsp">
              <i class="fas fa-circle text-danger"></i> Circle & Sector Calculator
            </a>
            <a class="dropdown-item" href="heron-area.jsp">
              <i class="fas fa-draw-polygon text-danger"></i> Heron's Formula (Area)
            </a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="distance-midpoint.jsp">
              <i class="fas fa-map-marker-alt text-danger"></i> Distance & Midpoint
            </a>
            <a class="dropdown-item" href="degree-radian.jsp">
              <i class="fas fa-sync-alt text-danger"></i> Degrees ↔ Radians
            </a>
            <a class="dropdown-item" href="polar-cartesian.jsp">
              <i class="fas fa-arrows-alt text-danger"></i> Polar ↔ Cartesian
            </a>
          </div>
        </li>

        <!-- Statistics -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="mathStatsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-chart-bar text-secondary"></i> Statistics
          </a>
          <div class="dropdown-menu">
            <h6 class="dropdown-header">Descriptive Statistics</h6>
            <a class="dropdown-item" href="mean-median-mode.jsp">
              <i class="fas fa-chart-bar text-secondary"></i> Mean, Median, Mode
            </a>
            <a class="dropdown-item" href="standard-deviation.jsp">
              <i class="fas fa-sigma text-secondary"></i> Standard Deviation
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Inferential Statistics</h6>
            <a class="dropdown-item" href="confidence-interval-calculator.jsp">
              <i class="fas fa-chart-area text-secondary"></i> Confidence Interval Calculator
            </a>
            <a class="dropdown-item" href="p-value-calculator.jsp">
              <i class="fas fa-vial text-secondary"></i> P-Value Calculator
            </a>
            <a class="dropdown-item" href="sample-size-calculator.jsp">
              <i class="fas fa-users text-secondary"></i> Sample Size Calculator
            </a>
            <a class="dropdown-item" href="correlation-calculator.jsp">
              <i class="fas fa-project-diagram text-secondary"></i> Correlation Calculator
            </a>
            <a class="dropdown-item" href="z-score-calculator.jsp">
              <i class="fas fa-calculator text-secondary"></i> Z-Score Calculator
            </a>
            <a class="dropdown-item" href="linear-regression-calculator.jsp">
              <i class="fas fa-chart-line text-secondary"></i> Linear Regression Calculator
            </a>
            <a class="dropdown-item" href="t-test-calculator.jsp">
              <i class="fas fa-vial text-secondary"></i> T-Test Calculator
            </a>
            <a class="dropdown-item" href="chi-square-calculator.jsp">
              <i class="fas fa-table text-secondary"></i> Chi-Square Calculator
            </a>
            <a class="dropdown-item" href="anova-calculator.jsp">
              <i class="fas fa-layer-group text-secondary"></i> ANOVA Calculator
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Probability Distributions</h6>
            <a class="dropdown-item" href="normal-distribution-calculator.jsp">
              <i class="fas fa-bell text-secondary"></i> Normal Distribution
            </a>
            <a class="dropdown-item" href="binomial-distribution-calculator.jsp">
              <i class="fas fa-dice text-secondary"></i> Binomial Distribution
            </a>
          </div>
        </li>

        <!-- Advanced & Fun -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="mathAdvancedDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-magic text-purple"></i> Advanced
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="latex-equation-editor.jsp">
              <i class="fas fa-subscript text-purple"></i> LaTeX Equation Editor
            </a>
            <a class="dropdown-item" href="tikz-viewer.jsp">
              <i class="fas fa-bezier-curve text-purple"></i> TikZ Viewer & Editor
            </a>
            <a class="dropdown-item" href="math-art-gallery.jsp">
              <i class="fas fa-palette text-purple"></i> Math Art Gallery (Fractals)
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Math Tricks & Fun</h6>
            <a class="dropdown-item" href="kaprekar.jsp">
              <i class="fas fa-magic text-purple"></i> Kaprekar's Constant (6174)
            </a>
            <a class="dropdown-item" href="magic-1089.jsp">
              <i class="fas fa-hat-wizard text-purple"></i> Magic 1089 Trick
            </a>
            <a class="dropdown-item" href="21-card-trick.jsp">
              <i class="fas fa-layer-group text-purple"></i> 21 Card Trick
            </a>
          </div>
        </li>

      </ul>
    </div>
  </div>
  <script>
    // Mark active item within math bar
    (function(){
      try{
        var path = location.pathname.replace(/^\/+/, '');
        var links = document.querySelectorAll('#mathToolsNavbar .dropdown-item');
        Array.prototype.forEach.call(links, function(a){
          var href = (a.getAttribute('href')||'').replace(/^\/+/, '');
          if(href && path.endsWith(href)){
            a.classList.add('active');
          }
        });
      }catch(e){}
    })();
  </script>
</nav>

<!-- Compact Chemistry Tools Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light mb-3 border-bottom">
  <div class="container-fluid px-0">
    <span class="navbar-brand text-dark">
      <i class="fas fa-flask text-primary"></i> <span class="text-muted">Chemistry Tools</span>
    </span>

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#chemToolsNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="chemToolsNavbar">
      <ul class="navbar-nav mr-auto">
        <!-- Core Chemistry -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="chemCoreDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-atom text-primary"></i> Core
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="periodic-table.jsp">
              <i class="fas fa-th text-primary"></i> Periodic Table (Interactive)
            </a>
            <a class="dropdown-item" href="molar-mass-calculator.jsp">
              <i class="fas fa-weight text-primary"></i> Molar Mass Calculator
            </a>
            <a class="dropdown-item" href="percent-composition-calculator.jsp">
              <i class="fas fa-chart-pie text-primary"></i> Percent Composition Calculator
            </a>
            <a class="dropdown-item" href="chemical-equation-balancer.jsp">
              <i class="fas fa-equals text-primary"></i> Chemical Equation Balancer
            </a>
            <a class="dropdown-item" href="molarity-dilution-calculator.jsp">
              <i class="fas fa-vial text-primary"></i> Molarity + Dilution (C1V1=C2V2)
            </a>
            <a class="dropdown-item" href="significant-figures-calculator.jsp">
              <i class="fas fa-calculator text-primary"></i> Significant Figures Calculator
            </a>
          </div>
        </li>

        <!-- Preparation & Conversions -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="chemPrepDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-bezier-curve text-success"></i> Prep & Conversions
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="unit-converter-chemistry.jsp">
              <i class="fas fa-exchange-alt text-success"></i> Unit Converter (Mass, Volume, Pressure, Temp)
            </a>
            <a class="dropdown-item" href="molarity-dilution-calculator.jsp?tab=conversions">
              <i class="fas fa-exchange-alt text-success"></i> ppm/ppb/% Conversions
            </a>
            <a class="dropdown-item" href="molarity-dilution-calculator.jsp?tab=molarity">
              <i class="fas fa-prescription-bottle text-success"></i> Solution Recipe Builder
            </a>
            <a class="dropdown-item" href="buffer-solution-calculator.jsp">
              <i class="fas fa-vial text-success"></i> Buffer Solution Calculator
            </a>
            <a class="dropdown-item" href="density-calculator.jsp">
              <i class="fas fa-weight text-success"></i> Density Calculator (d=m/v)
            </a>
          </div>
        </li>

        <!-- Advanced Chemistry -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="chemAdvDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-graduation-cap text-warning"></i> Advanced
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="ph-calculator.jsp">
              <i class="fas fa-tint text-warning"></i> pH Calculator
            </a>
            <a class="dropdown-item" href="stoichiometry-calculator.jsp">
              <i class="fas fa-balance-scale text-warning"></i> Stoichiometry Calculator
            </a>
            <a class="dropdown-item" href="percent-yield-calculator.jsp">
              <i class="fas fa-percentage text-warning"></i> Percent Yield Calculator
            </a>
            <a class="dropdown-item" href="limiting-reagent-calculator.jsp">
              <i class="fas fa-flask text-warning"></i> Limiting Reagent Calculator
            </a>
            <a class="dropdown-item" href="empirical-formula-calculator.jsp">
              <i class="fas fa-superscript text-warning"></i> Empirical & Molecular Formula
            </a>
            <a class="dropdown-item" href="titration-calculator.jsp">
              <i class="fas fa-vial text-warning"></i> Titration Calculator
            </a>
            <a class="dropdown-item" href="redox-balancer.jsp">
              <i class="fas fa-exchange-alt text-warning"></i> Redox Reaction Balancer
            </a>
            <a class="dropdown-item" href="thermochemistry-calculator.jsp">
              <i class="fas fa-fire text-warning"></i> Thermochemistry Calculator
            </a>
            <a class="dropdown-item" href="equilibrium-constant-calculator.jsp">
              <i class="fas fa-arrows-alt-h text-warning"></i> Equilibrium (Kc, Kp, Ka, Kb)
            </a>
            <a class="dropdown-item" href="ideal-gas-law-calculator.jsp">
              <i class="fas fa-cloud text-warning"></i> Ideal Gas Law (PV=nRT)
            </a>
            <a class="dropdown-item" href="electron-configuration-calculator.jsp">
              <i class="fas fa-atom text-warning"></i> Electron Configuration
            </a>
            <a class="dropdown-item" href="lewis-structure-generator.jsp">
              <i class="fas fa-project-diagram text-warning"></i> Lewis Structure & VSEPR
            </a>
            <a class="dropdown-item" href="molecular-geometry-calculator.jsp">
              <i class="fas fa-cube text-warning"></i> Molecular Geometry Calculator
            </a>
            <a class="dropdown-item" href="half-life-calculator.jsp">
              <i class="fas fa-radiation text-warning"></i> Half-Life Calculator
            </a>
            <a class="dropdown-item" href="electrochemistry-calculator.jsp">
              <i class="fas fa-bolt text-warning"></i> Electrochemistry (Nernst & Faraday)
            </a>
          </div>
        </li>

      </ul>
    </div>
  </div>
  <script>
    // Mark active item within chem bar
    (function(){
      try{
        var path = location.pathname.replace(/^\/+/, '');
        var links = document.querySelectorAll('#chemToolsNavbar .dropdown-item');
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


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free chemistry unit converter - Convert between mass (g, mg, kg), volume (L, mL), pressure (atm, Pa, mmHg), temperature (°C, K, °F), energy (J, cal), and concentration units instantly.">
    <meta name="keywords" content="chemistry unit converter, mass converter, volume converter, pressure converter, temperature converter, molarity converter, atm to Pa, Celsius to Kelvin">
    <title>Chemistry Unit Converter - Mass, Volume, Pressure, Temperature | Free Online Tool</title>

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="Chemistry Unit Converter - Convert Mass, Volume, Pressure, Temperature">
    <meta property="og:description" content="Free online chemistry unit converter. Instantly convert between g/mg/kg, L/mL, atm/Pa/mmHg, °C/K/°F, and more.">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Chemistry Unit Converter",
        "description": "Convert between common chemistry units including mass, volume, pressure, temperature, energy, and concentration.",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Mass conversion (g, mg, kg, μg, lb, oz), Volume conversion (L, mL, μL, gal, fl oz), Pressure conversion (atm, Pa, kPa, mmHg, psi, bar, torr), Temperature conversion (°C, K, °F), Energy conversion (J, kJ, cal, kcal, eV), Concentration conversion (M, mM, μM, ppm, ppb, %)",
        "audience": {
            "@type": "EducationalAudience",
            "educationalRole": "student"
        },
        "educationalLevel": "High School, College"
    }
    </script>

<%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container-fluid mt-4">
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <h1 class="text-center mb-3">
                <i class="fas fa-exchange-alt text-primary"></i> Chemistry Unit Converter
            </h1>
            <p class="text-center text-muted mb-4">
                Convert between common chemistry units - Mass, Volume, Pressure, Temperature, Energy, and Concentration
            </p>

            <!-- Conversion Category Tabs -->
            <ul class="nav nav-tabs mb-3" id="converterTabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="mass-tab" data-toggle="tab" href="#mass" role="tab">
                        <i class="fas fa-weight"></i> Mass
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="volume-tab" data-toggle="tab" href="#volume" role="tab">
                        <i class="fas fa-flask"></i> Volume
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="pressure-tab" data-toggle="tab" href="#pressure" role="tab">
                        <i class="fas fa-compress"></i> Pressure
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="temperature-tab" data-toggle="tab" href="#temperature" role="tab">
                        <i class="fas fa-thermometer-half"></i> Temp
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="energy-tab" data-toggle="tab" href="#energy" role="tab">
                        <i class="fas fa-bolt"></i> Energy
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="concentration-tab" data-toggle="tab" href="#concentration" role="tab">
                        <i class="fas fa-vial"></i> Concentration
                    </a>
                </li>
            </ul>

            <div class="tab-content" id="converterTabsContent">
                <!-- MASS CONVERSION TAB -->
                <div class="tab-pane fade show active" id="mass" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-weight text-primary"></i> Mass Converter</h5>

                            <div class="form-group">
                                <label>Enter Value:</label>
                                <input type="number" class="form-control" id="massValue" placeholder="Enter mass value" step="any">
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>From Unit:</label>
                                        <select class="form-control" id="massFromUnit">
                                            <option value="g" selected>Grams (g)</option>
                                            <option value="mg">Milligrams (mg)</option>
                                            <option value="kg">Kilograms (kg)</option>
                                            <option value="ug">Micrograms (μg)</option>
                                            <option value="ng">Nanograms (ng)</option>
                                            <option value="lb">Pounds (lb)</option>
                                            <option value="oz">Ounces (oz)</option>
                                            <option value="ton">Metric Tons (t)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>To Unit:</label>
                                        <select class="form-control" id="massToUnit">
                                            <option value="g">Grams (g)</option>
                                            <option value="mg" selected>Milligrams (mg)</option>
                                            <option value="kg">Kilograms (kg)</option>
                                            <option value="ug">Micrograms (μg)</option>
                                            <option value="ng">Nanograms (ng)</option>
                                            <option value="lb">Pounds (lb)</option>
                                            <option value="oz">Ounces (oz)</option>
                                            <option value="ton">Metric Tons (t)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="convertMass()">
                                <i class="fas fa-exchange-alt"></i> Convert Mass
                            </button>

                            <div id="massResult" class="mt-3"></div>

                            <hr>
                            <h6 class="text-muted">Quick Examples:</h6>
                            <div class="example-buttons">
                                <span class="badge badge-pill badge-info" onclick="setMassExample(5.5, 'g', 'mg')">5.5 g → mg</span>
                                <span class="badge badge-pill badge-info" onclick="setMassExample(250, 'mg', 'g')">250 mg → g</span>
                                <span class="badge badge-pill badge-info" onclick="setMassExample(2.5, 'kg', 'g')">2.5 kg → g</span>
                                <span class="badge badge-pill badge-info" onclick="setMassExample(500, 'ug', 'mg')">500 μg → mg</span>
                                <span class="badge badge-pill badge-info" onclick="setMassExample(1, 'lb', 'g')">1 lb → g</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- VOLUME CONVERSION TAB -->
                <div class="tab-pane fade" id="volume" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-flask text-primary"></i> Volume Converter</h5>

                            <div class="form-group">
                                <label>Enter Value:</label>
                                <input type="number" class="form-control" id="volumeValue" placeholder="Enter volume value" step="any">
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>From Unit:</label>
                                        <select class="form-control" id="volumeFromUnit">
                                            <option value="L" selected>Liters (L)</option>
                                            <option value="mL">Milliliters (mL)</option>
                                            <option value="uL">Microliters (μL)</option>
                                            <option value="nL">Nanoliters (nL)</option>
                                            <option value="m3">Cubic meters (m³)</option>
                                            <option value="cm3">Cubic centimeters (cm³)</option>
                                            <option value="gal">Gallons (gal)</option>
                                            <option value="floz">Fluid ounces (fl oz)</option>
                                            <option value="cup">Cups (cup)</option>
                                            <option value="qt">Quarts (qt)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>To Unit:</label>
                                        <select class="form-control" id="volumeToUnit">
                                            <option value="L">Liters (L)</option>
                                            <option value="mL" selected>Milliliters (mL)</option>
                                            <option value="uL">Microliters (μL)</option>
                                            <option value="nL">Nanoliters (nL)</option>
                                            <option value="m3">Cubic meters (m³)</option>
                                            <option value="cm3">Cubic centimeters (cm³)</option>
                                            <option value="gal">Gallons (gal)</option>
                                            <option value="floz">Fluid ounces (fl oz)</option>
                                            <option value="cup">Cups (cup)</option>
                                            <option value="qt">Quarts (qt)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="convertVolume()">
                                <i class="fas fa-exchange-alt"></i> Convert Volume
                            </button>

                            <div id="volumeResult" class="mt-3"></div>

                            <hr>
                            <h6 class="text-muted">Quick Examples:</h6>
                            <div class="example-buttons">
                                <span class="badge badge-pill badge-info" onclick="setVolumeExample(2.5, 'L', 'mL')">2.5 L → mL</span>
                                <span class="badge badge-pill badge-info" onclick="setVolumeExample(750, 'mL', 'L')">750 mL → L</span>
                                <span class="badge badge-pill badge-info" onclick="setVolumeExample(100, 'uL', 'mL')">100 μL → mL</span>
                                <span class="badge badge-pill badge-info" onclick="setVolumeExample(1, 'gal', 'L')">1 gal → L</span>
                                <span class="badge badge-pill badge-info" onclick="setVolumeExample(500, 'mL', 'floz')">500 mL → fl oz</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- PRESSURE CONVERSION TAB -->
                <div class="tab-pane fade" id="pressure" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-compress text-primary"></i> Pressure Converter</h5>

                            <div class="form-group">
                                <label>Enter Value:</label>
                                <input type="number" class="form-control" id="pressureValue" placeholder="Enter pressure value" step="any">
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>From Unit:</label>
                                        <select class="form-control" id="pressureFromUnit">
                                            <option value="atm" selected>Atmospheres (atm)</option>
                                            <option value="Pa">Pascals (Pa)</option>
                                            <option value="kPa">Kilopascals (kPa)</option>
                                            <option value="mmHg">Millimeters of Hg (mmHg)</option>
                                            <option value="torr">Torr</option>
                                            <option value="bar">Bar</option>
                                            <option value="psi">Pounds per sq in (psi)</option>
                                            <option value="inHg">Inches of Hg (inHg)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>To Unit:</label>
                                        <select class="form-control" id="pressureToUnit">
                                            <option value="atm">Atmospheres (atm)</option>
                                            <option value="Pa">Pascals (Pa)</option>
                                            <option value="kPa" selected>Kilopascals (kPa)</option>
                                            <option value="mmHg">Millimeters of Hg (mmHg)</option>
                                            <option value="torr">Torr</option>
                                            <option value="bar">Bar</option>
                                            <option value="psi">Pounds per sq in (psi)</option>
                                            <option value="inHg">Inches of Hg (inHg)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="convertPressure()">
                                <i class="fas fa-exchange-alt"></i> Convert Pressure
                            </button>

                            <div id="pressureResult" class="mt-3"></div>

                            <hr>
                            <h6 class="text-muted">Quick Examples:</h6>
                            <div class="example-buttons">
                                <span class="badge badge-pill badge-info" onclick="setPressureExample(1, 'atm', 'Pa')">1 atm → Pa</span>
                                <span class="badge badge-pill badge-info" onclick="setPressureExample(760, 'mmHg', 'atm')">760 mmHg → atm</span>
                                <span class="badge badge-pill badge-info" onclick="setPressureExample(101.325, 'kPa', 'psi')">101.325 kPa → psi</span>
                                <span class="badge badge-pill badge-info" onclick="setPressureExample(1, 'bar', 'atm')">1 bar → atm</span>
                                <span class="badge badge-pill badge-info" onclick="setPressureExample(14.7, 'psi', 'kPa')">14.7 psi → kPa</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TEMPERATURE CONVERSION TAB -->
                <div class="tab-pane fade" id="temperature" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-thermometer-half text-primary"></i> Temperature Converter</h5>

                            <div class="form-group">
                                <label>Enter Value:</label>
                                <input type="number" class="form-control" id="temperatureValue" placeholder="Enter temperature value" step="any">
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>From Unit:</label>
                                        <select class="form-control" id="temperatureFromUnit">
                                            <option value="C" selected>Celsius (°C)</option>
                                            <option value="K">Kelvin (K)</option>
                                            <option value="F">Fahrenheit (°F)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>To Unit:</label>
                                        <select class="form-control" id="temperatureToUnit">
                                            <option value="C">Celsius (°C)</option>
                                            <option value="K" selected>Kelvin (K)</option>
                                            <option value="F">Fahrenheit (°F)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="convertTemperature()">
                                <i class="fas fa-exchange-alt"></i> Convert Temperature
                            </button>

                            <div id="temperatureResult" class="mt-3"></div>

                            <hr>
                            <h6 class="text-muted">Quick Examples:</h6>
                            <div class="example-buttons">
                                <span class="badge badge-pill badge-info" onclick="setTemperatureExample(25, 'C', 'K')">25°C → K</span>
                                <span class="badge badge-pill badge-info" onclick="setTemperatureExample(298, 'K', 'C')">298 K → °C</span>
                                <span class="badge badge-pill badge-info" onclick="setTemperatureExample(100, 'C', 'F')">100°C → °F</span>
                                <span class="badge badge-pill badge-info" onclick="setTemperatureExample(32, 'F', 'C')">32°F → °C</span>
                                <span class="badge badge-pill badge-info" onclick="setTemperatureExample(0, 'C', 'K')">0°C → K</span>
                                <span class="badge badge-pill badge-info" onclick="setTemperatureExample(273.15, 'K', 'C')">273.15 K → °C</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ENERGY CONVERSION TAB -->
                <div class="tab-pane fade" id="energy" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-bolt text-primary"></i> Energy Converter</h5>

                            <div class="form-group">
                                <label>Enter Value:</label>
                                <input type="number" class="form-control" id="energyValue" placeholder="Enter energy value" step="any">
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>From Unit:</label>
                                        <select class="form-control" id="energyFromUnit">
                                            <option value="J" selected>Joules (J)</option>
                                            <option value="kJ">Kilojoules (kJ)</option>
                                            <option value="cal">Calories (cal)</option>
                                            <option value="kcal">Kilocalories (kcal)</option>
                                            <option value="eV">Electronvolts (eV)</option>
                                            <option value="Wh">Watt-hours (Wh)</option>
                                            <option value="kWh">Kilowatt-hours (kWh)</option>
                                            <option value="BTU">British Thermal Units (BTU)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>To Unit:</label>
                                        <select class="form-control" id="energyToUnit">
                                            <option value="J">Joules (J)</option>
                                            <option value="kJ" selected>Kilojoules (kJ)</option>
                                            <option value="cal">Calories (cal)</option>
                                            <option value="kcal">Kilocalories (kcal)</option>
                                            <option value="eV">Electronvolts (eV)</option>
                                            <option value="Wh">Watt-hours (Wh)</option>
                                            <option value="kWh">Kilowatt-hours (kWh)</option>
                                            <option value="BTU">British Thermal Units (BTU)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="convertEnergy()">
                                <i class="fas fa-exchange-alt"></i> Convert Energy
                            </button>

                            <div id="energyResult" class="mt-3"></div>

                            <hr>
                            <h6 class="text-muted">Quick Examples:</h6>
                            <div class="example-buttons">
                                <span class="badge badge-pill badge-info" onclick="setEnergyExample(1000, 'J', 'kJ')">1000 J → kJ</span>
                                <span class="badge badge-pill badge-info" onclick="setEnergyExample(4.184, 'kJ', 'kcal')">4.184 kJ → kcal</span>
                                <span class="badge badge-pill badge-info" onclick="setEnergyExample(100, 'cal', 'J')">100 cal → J</span>
                                <span class="badge badge-pill badge-info" onclick="setEnergyExample(1, 'eV', 'J')">1 eV → J</span>
                                <span class="badge badge-pill badge-info" onclick="setEnergyExample(1, 'kWh', 'kJ')">1 kWh → kJ</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CONCENTRATION CONVERSION TAB -->
                <div class="tab-pane fade" id="concentration" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-vial text-primary"></i> Concentration Converter</h5>
                            <p class="text-muted small">Note: For ppm/ppb/% conversions, assumes aqueous solutions (density ≈ 1 g/mL)</p>

                            <div class="form-group">
                                <label>Enter Value:</label>
                                <input type="number" class="form-control" id="concentrationValue" placeholder="Enter concentration value" step="any">
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>From Unit:</label>
                                        <select class="form-control" id="concentrationFromUnit">
                                            <option value="M" selected>Molar (M)</option>
                                            <option value="mM">Millimolar (mM)</option>
                                            <option value="uM">Micromolar (μM)</option>
                                            <option value="nM">Nanomolar (nM)</option>
                                            <option value="ppm">Parts per million (ppm)</option>
                                            <option value="ppb">Parts per billion (ppb)</option>
                                            <option value="percent">Percent (%)</option>
                                            <option value="mgL">mg/L</option>
                                            <option value="ugL">μg/L</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>To Unit:</label>
                                        <select class="form-control" id="concentrationToUnit">
                                            <option value="M">Molar (M)</option>
                                            <option value="mM" selected>Millimolar (mM)</option>
                                            <option value="uM">Micromolar (μM)</option>
                                            <option value="nM">Nanomolar (nM)</option>
                                            <option value="ppm">Parts per million (ppm)</option>
                                            <option value="ppb">Parts per billion (ppb)</option>
                                            <option value="percent">Percent (%)</option>
                                            <option value="mgL">mg/L</option>
                                            <option value="ugL">μg/L</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="convertConcentration()">
                                <i class="fas fa-exchange-alt"></i> Convert Concentration
                            </button>

                            <div id="concentrationResult" class="mt-3"></div>

                            <hr>
                            <h6 class="text-muted">Quick Examples:</h6>
                            <div class="example-buttons">
                                <span class="badge badge-pill badge-info" onclick="setConcentrationExample(1, 'M', 'mM')">1 M → mM</span>
                                <span class="badge badge-pill badge-info" onclick="setConcentrationExample(500, 'mM', 'M')">500 mM → M</span>
                                <span class="badge badge-pill badge-info" onclick="setConcentrationExample(100, 'uM', 'mM')">100 μM → mM</span>
                                <span class="badge badge-pill badge-info" onclick="setConcentrationExample(50, 'ppm', 'mgL')">50 ppm → mg/L</span>
                                <span class="badge badge-pill badge-info" onclick="setConcentrationExample(1000, 'ppb', 'ugL')">1000 ppb → μg/L</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Conversion Reference Tables -->
            <div class="card mt-4">
                <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-table text-primary"></i> Common Conversion Factors</h5>

                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="text-muted">Mass</h6>
                            <ul class="small">
                                <li>1 kg = 1000 g</li>
                                <li>1 g = 1000 mg</li>
                                <li>1 mg = 1000 μg</li>
                                <li>1 lb = 453.592 g</li>
                                <li>1 oz = 28.3495 g</li>
                            </ul>

                            <h6 class="text-muted">Volume</h6>
                            <ul class="small">
                                <li>1 L = 1000 mL</li>
                                <li>1 mL = 1000 μL = 1 cm³</li>
                                <li>1 gal = 3.78541 L</li>
                                <li>1 fl oz = 29.5735 mL</li>
                            </ul>

                            <h6 class="text-muted">Temperature</h6>
                            <ul class="small">
                                <li>K = °C + 273.15</li>
                                <li>°F = (°C × 9/5) + 32</li>
                                <li>°C = (°F - 32) × 5/9</li>
                            </ul>
                        </div>

                        <div class="col-md-6">
                            <h6 class="text-muted">Pressure</h6>
                            <ul class="small">
                                <li>1 atm = 101325 Pa</li>
                                <li>1 atm = 760 mmHg = 760 torr</li>
                                <li>1 bar = 100000 Pa</li>
                                <li>1 psi = 6894.76 Pa</li>
                            </ul>

                            <h6 class="text-muted">Energy</h6>
                            <ul class="small">
                                <li>1 kJ = 1000 J</li>
                                <li>1 cal = 4.184 J</li>
                                <li>1 kcal = 4184 J</li>
                                <li>1 eV = 1.602×10⁻¹⁹ J</li>
                                <li>1 kWh = 3.6×10⁶ J</li>
                            </ul>

                            <h6 class="text-muted">Concentration</h6>
                            <ul class="small">
                                <li>1 M = 1000 mM</li>
                                <li>1 mM = 1000 μM</li>
                                <li>1 ppm = 1 mg/L (aqueous)</li>
                                <li>1 ppb = 1 μg/L (aqueous)</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<style>
.example-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

.example-buttons .badge {
    cursor: pointer;
    font-size: 0.85rem;
    padding: 6px 12px;
    transition: all 0.2s;
}

.example-buttons .badge:hover {
    transform: scale(1.05);
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.nav-tabs .nav-link {
    font-size: 0.9rem;
}

@media (max-width: 768px) {
    .nav-tabs .nav-link {
        font-size: 0.75rem;
        padding: 0.5rem 0.5rem;
    }
}
</style>

<script>
// ============================================
// MASS CONVERSION
// ============================================
const massConversions = {
    g: 1,
    mg: 1e-3,
    kg: 1e3,
    ug: 1e-6,
    ng: 1e-9,
    lb: 453.59237,
    oz: 28.349523125,
    ton: 1e6
};

function convertMass() {
    const value = parseFloat(document.getElementById('massValue').value);
    const fromUnit = document.getElementById('massFromUnit').value;
    const toUnit = document.getElementById('massToUnit').value;

    if (isNaN(value)) {
        document.getElementById('massResult').innerHTML = '<div class="alert alert-danger">Please enter a valid number</div>';
        return;
    }

    // Convert to grams first, then to target unit
    const grams = value * massConversions[fromUnit];
    const result = grams / massConversions[toUnit];

    const fromLabel = document.getElementById('massFromUnit').options[document.getElementById('massFromUnit').selectedIndex].text;
    const toLabel = document.getElementById('massToUnit').options[document.getElementById('massToUnit').selectedIndex].text;

    document.getElementById('massResult').innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p class="mb-0"><strong>${value} ${fromLabel}</strong> = <strong class="text-primary">${result.toExponential(6)} ${toLabel}</strong></p>
            <p class="mb-0 mt-2">Standard form: <strong>${result.toPrecision(6)} ${toLabel}</strong></p>
        </div>
    `;
}

function setMassExample(value, fromUnit, toUnit) {
    document.getElementById('massValue').value = value;
    document.getElementById('massFromUnit').value = fromUnit;
    document.getElementById('massToUnit').value = toUnit;
    convertMass();
}

// ============================================
// VOLUME CONVERSION
// ============================================
const volumeConversions = {
    L: 1,
    mL: 1e-3,
    uL: 1e-6,
    nL: 1e-9,
    m3: 1e3,
    cm3: 1e-3,
    gal: 3.785411784,
    floz: 0.0295735295625,
    cup: 0.2365882365,
    qt: 0.946352946
};

function convertVolume() {
    const value = parseFloat(document.getElementById('volumeValue').value);
    const fromUnit = document.getElementById('volumeFromUnit').value;
    const toUnit = document.getElementById('volumeToUnit').value;

    if (isNaN(value)) {
        document.getElementById('volumeResult').innerHTML = '<div class="alert alert-danger">Please enter a valid number</div>';
        return;
    }

    // Convert to liters first, then to target unit
    const liters = value * volumeConversions[fromUnit];
    const result = liters / volumeConversions[toUnit];

    const fromLabel = document.getElementById('volumeFromUnit').options[document.getElementById('volumeFromUnit').selectedIndex].text;
    const toLabel = document.getElementById('volumeToUnit').options[document.getElementById('volumeToUnit').selectedIndex].text;

    document.getElementById('volumeResult').innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p class="mb-0"><strong>${value} ${fromLabel}</strong> = <strong class="text-primary">${result.toExponential(6)} ${toLabel}</strong></p>
            <p class="mb-0 mt-2">Standard form: <strong>${result.toPrecision(6)} ${toLabel}</strong></p>
        </div>
    `;
}

function setVolumeExample(value, fromUnit, toUnit) {
    document.getElementById('volumeValue').value = value;
    document.getElementById('volumeFromUnit').value = fromUnit;
    document.getElementById('volumeToUnit').value = toUnit;
    convertVolume();
}

// ============================================
// PRESSURE CONVERSION
// ============================================
const pressureConversions = {
    atm: 1,
    Pa: 1 / 101325,
    kPa: 1 / 101.325,
    mmHg: 1 / 760,
    torr: 1 / 760,
    bar: 1 / 1.01325,
    psi: 1 / 14.6959488,
    inHg: 1 / 29.92
};

function convertPressure() {
    const value = parseFloat(document.getElementById('pressureValue').value);
    const fromUnit = document.getElementById('pressureFromUnit').value;
    const toUnit = document.getElementById('pressureToUnit').value;

    if (isNaN(value)) {
        document.getElementById('pressureResult').innerHTML = '<div class="alert alert-danger">Please enter a valid number</div>';
        return;
    }

    // Convert to atm first, then to target unit
    const atm = value * pressureConversions[fromUnit];
    const result = atm / pressureConversions[toUnit];

    const fromLabel = document.getElementById('pressureFromUnit').options[document.getElementById('pressureFromUnit').selectedIndex].text;
    const toLabel = document.getElementById('pressureToUnit').options[document.getElementById('pressureToUnit').selectedIndex].text;

    document.getElementById('pressureResult').innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p class="mb-0"><strong>${value} ${fromLabel}</strong> = <strong class="text-primary">${result.toExponential(6)} ${toLabel}</strong></p>
            <p class="mb-0 mt-2">Standard form: <strong>${result.toPrecision(6)} ${toLabel}</strong></p>
        </div>
    `;
}

function setPressureExample(value, fromUnit, toUnit) {
    document.getElementById('pressureValue').value = value;
    document.getElementById('pressureFromUnit').value = fromUnit;
    document.getElementById('pressureToUnit').value = toUnit;
    convertPressure();
}

// ============================================
// TEMPERATURE CONVERSION
// ============================================
function convertTemperature() {
    const value = parseFloat(document.getElementById('temperatureValue').value);
    const fromUnit = document.getElementById('temperatureFromUnit').value;
    const toUnit = document.getElementById('temperatureToUnit').value;

    if (isNaN(value)) {
        document.getElementById('temperatureResult').innerHTML = '<div class="alert alert-danger">Please enter a valid number</div>';
        return;
    }

    let celsius;

    // Convert to Celsius first
    if (fromUnit === 'C') {
        celsius = value;
    } else if (fromUnit === 'K') {
        celsius = value - 273.15;
    } else if (fromUnit === 'F') {
        celsius = (value - 32) * 5/9;
    }

    // Convert from Celsius to target unit
    let result;
    if (toUnit === 'C') {
        result = celsius;
    } else if (toUnit === 'K') {
        result = celsius + 273.15;
    } else if (toUnit === 'F') {
        result = (celsius * 9/5) + 32;
    }

    const fromLabel = document.getElementById('temperatureFromUnit').options[document.getElementById('temperatureFromUnit').selectedIndex].text;
    const toLabel = document.getElementById('temperatureToUnit').options[document.getElementById('temperatureToUnit').selectedIndex].text;

    document.getElementById('temperatureResult').innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p class="mb-0"><strong>${value} ${fromLabel}</strong> = <strong class="text-primary">${result.toFixed(4)} ${toLabel}</strong></p>
            ${toUnit !== 'C' ? `<p class="mb-0 mt-2 small text-muted">Also equals: ${celsius.toFixed(4)} °C</p>` : ''}
        </div>
    `;
}

function setTemperatureExample(value, fromUnit, toUnit) {
    document.getElementById('temperatureValue').value = value;
    document.getElementById('temperatureFromUnit').value = fromUnit;
    document.getElementById('temperatureToUnit').value = toUnit;
    convertTemperature();
}

// ============================================
// ENERGY CONVERSION
// ============================================
const energyConversions = {
    J: 1,
    kJ: 1e3,
    cal: 4.184,
    kcal: 4184,
    eV: 1.602176634e-19,
    Wh: 3600,
    kWh: 3.6e6,
    BTU: 1055.06
};

function convertEnergy() {
    const value = parseFloat(document.getElementById('energyValue').value);
    const fromUnit = document.getElementById('energyFromUnit').value;
    const toUnit = document.getElementById('energyToUnit').value;

    if (isNaN(value)) {
        document.getElementById('energyResult').innerHTML = '<div class="alert alert-danger">Please enter a valid number</div>';
        return;
    }

    // Convert to joules first, then to target unit
    const joules = value * energyConversions[fromUnit];
    const result = joules / energyConversions[toUnit];

    const fromLabel = document.getElementById('energyFromUnit').options[document.getElementById('energyFromUnit').selectedIndex].text;
    const toLabel = document.getElementById('energyToUnit').options[document.getElementById('energyToUnit').selectedIndex].text;

    document.getElementById('energyResult').innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p class="mb-0"><strong>${value} ${fromLabel}</strong> = <strong class="text-primary">${result.toExponential(6)} ${toLabel}</strong></p>
            <p class="mb-0 mt-2">Standard form: <strong>${result.toPrecision(6)} ${toLabel}</strong></p>
        </div>
    `;
}

function setEnergyExample(value, fromUnit, toUnit) {
    document.getElementById('energyValue').value = value;
    document.getElementById('energyFromUnit').value = fromUnit;
    document.getElementById('energyToUnit').value = toUnit;
    convertEnergy();
}

// ============================================
// CONCENTRATION CONVERSION
// ============================================
const concentrationConversions = {
    M: 1,
    mM: 1e-3,
    uM: 1e-6,
    nM: 1e-9,
    ppm: 1e-6,      // Assuming aqueous, 1 ppm ≈ 1 mg/L ≈ 1e-6 M (for small molecules)
    ppb: 1e-9,      // 1 ppb ≈ 1 μg/L ≈ 1e-9 M
    percent: 0.01,  // 1% ≈ 0.01 M (simplified)
    mgL: 1e-6,      // mg/L, approximate
    ugL: 1e-9       // μg/L, approximate
};

function convertConcentration() {
    const value = parseFloat(document.getElementById('concentrationValue').value);
    const fromUnit = document.getElementById('concentrationFromUnit').value;
    const toUnit = document.getElementById('concentrationToUnit').value;

    if (isNaN(value)) {
        document.getElementById('concentrationResult').innerHTML = '<div class="alert alert-danger">Please enter a valid number</div>';
        return;
    }

    // Convert to M first, then to target unit
    const molar = value * concentrationConversions[fromUnit];
    const result = molar / concentrationConversions[toUnit];

    const fromLabel = document.getElementById('concentrationFromUnit').options[document.getElementById('concentrationFromUnit').selectedIndex].text;
    const toLabel = document.getElementById('concentrationToUnit').options[document.getElementById('concentrationToUnit').selectedIndex].text;

    let warning = '';
    if (['ppm', 'ppb', 'percent', 'mgL', 'ugL'].includes(fromUnit) || ['ppm', 'ppb', 'percent', 'mgL', 'ugL'].includes(toUnit)) {
        warning = '<p class="mb-0 mt-2 small text-warning"><i class="fas fa-exclamation-triangle"></i> Note: ppm/ppb/% conversions are approximate and assume aqueous solutions</p>';
    }

    document.getElementById('concentrationResult').innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p class="mb-0"><strong>${value} ${fromLabel}</strong> = <strong class="text-primary">${result.toExponential(6)} ${toLabel}</strong></p>
            <p class="mb-0 mt-2">Standard form: <strong>${result.toPrecision(6)} ${toLabel}</strong></p>
            ${warning}
        </div>
    `;
}

function setConcentrationExample(value, fromUnit, toUnit) {
    document.getElementById('concentrationValue').value = value;
    document.getElementById('concentrationFromUnit').value = fromUnit;
    document.getElementById('concentrationToUnit').value = toUnit;
    convertConcentration();
}

// Auto-convert on input change
document.addEventListener('DOMContentLoaded', function() {
    ['massValue', 'massFromUnit', 'massToUnit'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('change', () => {
                if (document.getElementById('massValue').value) convertMass();
            });
        }
    });

    ['volumeValue', 'volumeFromUnit', 'volumeToUnit'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('change', () => {
                if (document.getElementById('volumeValue').value) convertVolume();
            });
        }
    });

    ['pressureValue', 'pressureFromUnit', 'pressureToUnit'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('change', () => {
                if (document.getElementById('pressureValue').value) convertPressure();
            });
        }
    });

    ['temperatureValue', 'temperatureFromUnit', 'temperatureToUnit'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('change', () => {
                if (document.getElementById('temperatureValue').value) convertTemperature();
            });
        }
    });

    ['energyValue', 'energyFromUnit', 'energyToUnit'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('change', () => {
                if (document.getElementById('energyValue').value) convertEnergy();
            });
        }
    });

    ['concentrationValue', 'concentrationFromUnit', 'concentrationToUnit'].forEach(id => {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('change', () => {
                if (document.getElementById('concentrationValue').value) convertConcentration();
            });
        }
    });
});
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
</html>

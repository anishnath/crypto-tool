<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Interactive Periodic Table of Elements | Chemistry Reference Tool | 8gwifi.org</title>
    <meta name="description" content="Interactive Periodic Table with detailed element information, electron configurations, oxidation states, and trends. Click any element for properties including atomic mass, melting point, electronegativity, and more.">
    <meta name="keywords" content="periodic table, interactive periodic table, element properties, atomic number, electron configuration, periodic trends, chemistry reference, chemical elements, atomic mass, electronegativity">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/periodic-table.jsp">
    <meta property="og:title" content="Interactive Periodic Table of Elements">
    <meta property="og:description" content="Explore all 118 elements with detailed properties, electron configurations, and periodic trends.">
    <meta property="og:image" content="https://8gwifi.org/images/site/periodic-table-og.png">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://8gwifi.org/periodic-table.jsp">
    <meta property="twitter:title" content="Interactive Periodic Table of Elements">
    <meta property="twitter:description" content="Explore all 118 elements with detailed properties, electron configurations, and periodic trends.">
    <meta property="twitter:image" content="https://8gwifi.org/images/site/periodic-table-og.png">

    <link rel="canonical" href="https://8gwifi.org/periodic-table.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- JSON-LD Schema Markup for SEO -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Interactive Periodic Table of Elements",
      "description": "Free interactive periodic table with all 118 elements, electron configurations, atomic properties, trends visualization, element comparison tool, and Bohr model diagrams. Perfect for students, teachers, and chemistry professionals.",
      "url": "https://8gwifi.org/periodic-table.jsp",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "browserRequirements": "Requires JavaScript. Works on Chrome, Firefox, Safari, Edge.",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Interactive periodic table with all 118 elements",
        "Detailed element properties (atomic mass, electronegativity, melting point, boiling point)",
        "Electron configuration visualization",
        "Bohr model electron shell diagrams",
        "Element comparison tool (side-by-side)",
        "Periodic trends visualization (atomic radius, electronegativity, ionization energy)",
        "Multiple color modes (category, state, block, group, trends)",
        "Temperature slider for state changes",
        "Keyboard navigation support",
        "Search and filter elements",
        "Mobile responsive design"
      ],
      "creator": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
      },
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.8",
        "ratingCount": "1250",
        "bestRating": "5",
        "worstRating": "1"
      }
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [{
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "https://8gwifi.org/"
      },{
        "@type": "ListItem",
        "position": 2,
        "name": "Chemistry Tools",
        "item": "https://8gwifi.org/chemical-equation-balancer.jsp"
      },{
        "@type": "ListItem",
        "position": 3,
        "name": "Interactive Periodic Table",
        "item": "https://8gwifi.org/periodic-table.jsp"
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [{
        "@type": "Question",
        "name": "What is an interactive periodic table?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "An interactive periodic table is a digital version of the periodic table of elements that allows users to click on elements to view detailed information, visualize trends, compare elements, and explore atomic properties. Our interactive periodic table includes all 118 elements with comprehensive data including atomic mass, electron configurations, electronegativity, melting/boiling points, atomic radius, ionization energy, and visual Bohr model diagrams."
        }
      },{
        "@type": "Question",
        "name": "How do I use the periodic trends visualization?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Select a trend from the 'Color by' dropdown menu: Atomic Radius (shows size trends), Electronegativity (shows electron attraction), or Ionization Energy (shows energy to remove electrons). Elements are color-coded from red (low values) to blue (high values) to visualize periodic patterns. You can also view trends by element category, state at temperature, electron block, or periodic group."
        }
      },{
        "@type": "Question",
        "name": "How do I compare two elements?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Click the 'Compare Elements' button, then select any two elements by clicking on them. A comparison panel will automatically appear showing side-by-side properties including atomic mass, electronegativity, melting/boiling points, atomic radius, and ionization energy. Higher values are highlighted in green for easy comparison."
        }
      },{
        "@type": "Question",
        "name": "What is the Bohr model electron shell diagram?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "The Bohr model shows electrons arranged in shells (energy levels) around the nucleus. When you click any element, scroll down to see its Bohr diagram showing the nucleus with the element symbol and electrons distributed in shells following the 2, 8, 18, 32 electron capacity pattern. Each shell is labeled with its principal quantum number (n=1, 2, 3...) and electron count."
        }
      },{
        "@type": "Question",
        "name": "Can I use keyboard shortcuts to navigate the periodic table?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Yes! Use arrow keys (↑↓←→) to navigate between elements, Enter to select an element, ESC to close details, C to toggle comparison mode, and ? to show/hide the keyboard shortcuts help panel. The focused element is highlighted with a blue outline."
        }
      },{
        "@type": "Question",
        "name": "What element properties are shown?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Each element displays 14 properties: atomic number, symbol, name, atomic mass, category (metal/nonmetal/etc), electron configuration, group and period, electron block, melting point, boiling point, electronegativity, oxidation states, discovery year, state at 25°C, atomic radius (pm), and ionization energy (kJ/mol)."
        }
      },{
        "@type": "Question",
        "name": "Is the periodic table mobile-friendly?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Yes, the interactive periodic table is fully responsive and works on all devices. On mobile devices, you can scroll horizontally to view all elements. A scroll hint appears on smaller screens to guide you. All features including element details, comparison mode, and electron shell diagrams work on mobile."
        }
      },{
        "@type": "Question",
        "name": "What are periodic trends?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Periodic trends are patterns in element properties that repeat across periods and down groups. Major trends include: Atomic Radius (increases down groups, decreases across periods), Electronegativity (decreases down groups, increases across periods), and Ionization Energy (decreases down groups, increases across periods). Our visualization uses color gradients to make these trends instantly visible."
        }
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Use the Interactive Periodic Table",
      "description": "Learn how to navigate and use all features of the interactive periodic table including element details, trends visualization, comparison mode, and keyboard shortcuts.",
      "step": [{
        "@type": "HowToStep",
        "position": 1,
        "name": "View Element Details",
        "text": "Click on any element to view its detailed properties including atomic mass, electron configuration, melting/boiling points, electronegativity, and Bohr model electron shell diagram."
      },{
        "@type": "HowToStep",
        "position": 2,
        "name": "Visualize Periodic Trends",
        "text": "Select a trend from the 'Color by' dropdown: choose Atomic Radius, Electronegativity, or Ionization Energy to see color-coded visualization of periodic patterns (red=low, blue=high)."
      },{
        "@type": "HowToStep",
        "position": 3,
        "name": "Compare Elements",
        "text": "Click 'Compare Elements' button, then select two elements. A comparison panel shows side-by-side properties with higher values highlighted in green."
      },{
        "@type": "HowToStep",
        "position": 4,
        "name": "Use Keyboard Navigation",
        "text": "Press ? to see keyboard shortcuts. Use arrow keys to navigate, Enter to select, ESC to close, and C for comparison mode."
      },{
        "@type": "HowToStep",
        "position": 5,
        "name": "Search Elements",
        "text": "Type in the search box to filter elements by name, symbol, or atomic number. Matching elements remain visible while others fade."
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "LearningResource",
      "name": "Interactive Periodic Table - Chemistry Learning Tool",
      "description": "Educational resource for learning chemistry, atomic structure, and periodic trends through interactive exploration of all 118 chemical elements.",
      "educationalLevel": ["High School", "College", "Professional"],
      "learningResourceType": "Interactive Tool",
      "audience": {
        "@type": "EducationalAudience",
        "educationalRole": ["student", "teacher", "professional"]
      },
      "teaches": [
        "Chemical elements and their properties",
        "Periodic table organization",
        "Periodic trends (atomic radius, electronegativity, ionization energy)",
        "Electron configurations and shell structure",
        "Atomic structure (Bohr model)",
        "Element categories and classification",
        "States of matter and phase changes"
      ],
      "isAccessibleForFree": true,
      "inLanguage": "en"
    }
    </script>

    <style>
        :root {
            --alkali-metal: #ff6b6b;
            --alkaline-earth: #ffd93d;
            --transition-metal: #ffc6c6;
            --post-transition: #a8dadc;
            --metalloid: #95e1d3;
            --nonmetal: #6dd5ed;
            --halogen: #f38181;
            --noble-gas: #aa96da;
            --lanthanide: #ffaaa5;
            --actinide: #ff8b94;
            --unknown: #e0e0e0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }

        .main-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 10px;
            font-size: 2.5rem;
        }

        .subtitle {
            text-align: center;
            color: #7f8c8d;
            margin-bottom: 25px;
            font-size: 1.1rem;
        }

        .controls {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-box {
            flex: 1;
            min-width: 250px;
        }

        .search-box input {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }

        .color-mode {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .color-mode select {
            padding: 8px 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        .temperature-control {
            display: none;
            align-items: center;
            gap: 10px;
            width: 100%;
            margin-top: 10px;
        }

        .temperature-control.active {
            display: flex;
        }

        .temperature-control input[type="range"] {
            flex: 1;
        }

        .table-wrapper {
            overflow-x: auto;
            margin-bottom: 20px;
            padding: 10px 0;
            position: relative;
        }

        .scroll-hint {
            text-align: center;
            color: #7f8c8d;
            font-size: 0.85rem;
            margin-bottom: 10px;
        }

        .scroll-hint i {
            animation: scroll-pulse 2s infinite;
        }

        @keyframes scroll-pulse {
            0%, 100% { opacity: 0.5; }
            50% { opacity: 1; }
        }

        .periodic-table {
            display: grid;
            grid-template-columns: repeat(18, minmax(50px, 1fr));
            grid-gap: 2px;
            margin-bottom: 20px;
            position: relative;
            min-width: 900px;
        }

        .element {
            aspect-ratio: 1;
            border: 2px solid #ddd;
            border-radius: 5px;
            padding: 5px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            font-size: 0.75rem;
            position: relative;
        }

        .element:hover {
            transform: scale(1.1);
            z-index: 10;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .element.active {
            border: 3px solid #2c3e50;
            box-shadow: 0 0 15px rgba(44, 62, 80, 0.5);
        }

        .atomic-number {
            font-size: 0.7em;
            font-weight: bold;
            position: absolute;
            top: 2px;
            left: 3px;
        }

        .symbol {
            font-size: 1.5em;
            font-weight: bold;
            margin: 5px 0;
        }

        .name {
            font-size: 0.65em;
            text-align: center;
        }

        .atomic-mass {
            font-size: 0.6em;
            margin-top: 2px;
        }

        .empty {
            background: transparent;
            border: none;
            cursor: default;
        }

        .empty:hover {
            transform: none;
            box-shadow: none;
        }

        .lanthanide-label, .actinide-label {
            grid-column: span 1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.7rem;
            font-weight: bold;
            color: #7f8c8d;
        }

        .f-block-wrapper {
            overflow-x: auto;
            padding: 5px 0;
        }

        .f-block {
            display: grid;
            grid-template-columns: repeat(15, minmax(50px, 1fr));
            grid-gap: 2px;
            margin-top: 10px;
            min-width: 750px;
        }

        .element-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-top: 20px;
            display: none;
        }

        .element-details.active {
            display: block;
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 3px solid #ddd;
            padding-bottom: 15px;
        }

        .detail-symbol {
            font-size: 4rem;
            font-weight: bold;
            color: #2c3e50;
        }

        .detail-name {
            font-size: 2rem;
            color: #34495e;
        }

        .detail-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }

        .info-group {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .info-label {
            font-weight: bold;
            color: #7f8c8d;
            font-size: 0.9rem;
        }

        .info-value {
            color: #2c3e50;
            font-size: 1.1rem;
            margin-top: 5px;
        }

        .legend {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }

        .legend-color {
            width: 25px;
            height: 25px;
            border-radius: 5px;
            border: 2px solid #ddd;
        }

        .close-details {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1rem;
        }

        .close-details:hover {
            background: #c0392b;
        }

        /* Comparison Mode */
        .element.compare-mode {
            cursor: pointer;
        }

        .element.selected-compare {
            border: 3px solid #3498db;
            box-shadow: 0 0 15px rgba(52, 152, 219, 0.6);
        }

        .compare-panel {
            display: none;
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px;
            margin-top: 20px;
        }

        .compare-panel.active {
            display: block;
            animation: slideIn 0.3s ease-out;
        }

        .compare-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .compare-element {
            background: white;
            border-radius: 8px;
            padding: 20px;
            border: 2px solid #ddd;
        }

        .compare-header {
            text-align: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 3px solid #ddd;
        }

        .compare-symbol {
            font-size: 3rem;
            font-weight: bold;
        }

        .compare-name {
            font-size: 1.5rem;
            color: #34495e;
        }

        .compare-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin: 10px 0;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 5px;
        }

        .compare-label {
            font-weight: bold;
            color: #7f8c8d;
            grid-column: 1 / -1;
            margin-bottom: 5px;
        }

        .compare-value {
            text-align: center;
            padding: 8px;
            background: white;
            border-radius: 4px;
        }

        .compare-value.higher {
            background: #d4edda;
            color: #155724;
            font-weight: bold;
        }

        /* Electron Shell Diagram */
        .shell-diagram {
            margin-top: 15px;
            text-align: center;
        }

        .shell-canvas {
            border: 2px solid #ddd;
            border-radius: 8px;
            background: #f8f9fa;
            max-width: 300px;
            margin: 0 auto;
        }

        /* Keyboard Navigation Indicator */
        .element.keyboard-focus {
            outline: 3px solid #3498db;
            outline-offset: 2px;
            z-index: 5;
        }

        .keyboard-help {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 15px;
            border-radius: 8px;
            font-size: 0.85rem;
            display: none;
            z-index: 1000;
        }

        .keyboard-help.active {
            display: block;
        }

        .keyboard-help kbd {
            background: #555;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: monospace;
        }

        @media (max-width: 1200px) {
            .periodic-table {
                grid-template-columns: repeat(18, minmax(45px, 1fr));
                min-width: 810px;
            }

            .f-block {
                grid-template-columns: repeat(15, minmax(45px, 1fr));
                min-width: 675px;
            }

            .element {
                font-size: 0.6rem;
            }
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 1.8rem;
            }

            .controls {
                flex-direction: column;
            }

            .periodic-table {
                grid-gap: 1px;
                grid-template-columns: repeat(18, minmax(40px, 1fr));
                min-width: 720px;
            }

            .f-block {
                grid-template-columns: repeat(15, minmax(40px, 1fr));
                min-width: 600px;
            }

            .element {
                font-size: 0.5rem;
                padding: 2px;
            }

            .symbol {
                font-size: 1.2em;
            }

            .main-container {
                padding: 15px;
            }
        }
    </style>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container-fluid mt-4">
    <div class="main-container">
        <h1><i class="fas fa-atom"></i> Interactive Periodic Table</h1>
        <p class="subtitle">Click on any element to view detailed information</p>

        <div class="controls">
            <div class="search-box">
                <input type="text" id="searchBox" placeholder="Search by name, symbol, or atomic number...">
            </div>
            <div class="color-mode">
                <label for="colorMode"><strong>Color by:</strong></label>
                <select id="colorMode">
                    <option value="category">Element Category</option>
                    <option value="state">State at Temperature</option>
                    <option value="block">Electron Block</option>
                    <option value="group">Group</option>
                    <option value="atomicRadius">Atomic Radius (Trend)</option>
                    <option value="electronegativityTrend">Electronegativity (Trend)</option>
                    <option value="ionizationEnergy">Ionization Energy (Trend)</option>
                </select>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <button id="compareBtn" class="btn btn-sm btn-primary" onclick="toggleCompareMode()">
                    <i class="fas fa-exchange-alt"></i> Compare Elements
                </button>
                <span id="compareStatus" style="font-size: 0.85rem; color: #7f8c8d;"></span>
            </div>
        </div>

        <div class="temperature-control" id="tempControl">
            <label><strong>Temperature:</strong></label>
            <input type="range" id="tempSlider" min="-273" max="6000" value="25" step="1">
            <span id="tempValue">25°C</span>
        </div>

        <div class="scroll-hint d-md-none">
            <i class="fas fa-arrows-alt-h"></i> Scroll horizontally to view all elements
        </div>

        <div class="table-wrapper">
            <div id="periodicTable" class="periodic-table"></div>
        </div>

        <div class="f-block-wrapper">
            <div class="f-block">
                <div id="lanthanides" style="display: contents;"></div>
            </div>
        </div>
        <div class="f-block-wrapper">
            <div class="f-block" style="margin-top: 5px;">
                <div id="actinides" style="display: contents;"></div>
            </div>
        </div>

        <div id="legend" class="legend"></div>

        <div id="elementDetails" class="element-details">
            <div class="detail-header">
                <div>
                    <div class="detail-symbol" id="detailSymbol"></div>
                    <div class="detail-name" id="detailName"></div>
                </div>
                <button class="close-details" onclick="closeDetails()">
                    <i class="fas fa-times"></i> Close
                </button>
            </div>
            <div class="detail-info" id="detailInfo"></div>
            <div class="shell-diagram">
                <h5><i class="fas fa-atom"></i> Electron Shell Diagram (Bohr Model)</h5>
                <canvas id="shellCanvas" class="shell-canvas" width="300" height="300"></canvas>
            </div>
        </div>

        <div id="comparePanel" class="compare-panel">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h4><i class="fas fa-balance-scale"></i> Element Comparison</h4>
                <button class="close-details" onclick="closeComparison()">
                    <i class="fas fa-times"></i> Close
                </button>
            </div>
            <div id="compareContent" class="compare-grid"></div>
        </div>

        <div id="keyboardHelp" class="keyboard-help">
            <strong><i class="fas fa-keyboard"></i> Keyboard Shortcuts:</strong><br>
            <kbd>↑</kbd> <kbd>↓</kbd> <kbd>←</kbd> <kbd>→</kbd> Navigate<br>
            <kbd>Enter</kbd> Select element<br>
            <kbd>ESC</kbd> Close details<br>
            <kbd>?</kbd> Toggle this help<br>
            <kbd>C</kbd> Compare mode
        </div>

        <%@ include file="thanks.jsp"%>
    </div>

    <%@ include file="addcomments.jsp"%>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
// Comprehensive periodic table data
const elements = [
    { number: 1, symbol: 'H', name: 'Hydrogen', mass: 1.008, category: 'nonmetal', block: 's', group: 1, period: 1, mp: -259.16, bp: -252.87, electronegativity: 2.20, electrons: '1s¹', oxidation: [-1, 1], discovered: 1766, state: 'gas' },
    { number: 2, symbol: 'He', name: 'Helium', mass: 4.003, category: 'noble-gas', block: 's', group: 18, period: 1, mp: -272.2, bp: -268.93, electronegativity: null, electrons: '1s²', oxidation: [0], discovered: 1868, state: 'gas' },
    { number: 3, symbol: 'Li', name: 'Lithium', mass: 6.941, category: 'alkali-metal', block: 's', group: 1, period: 2, mp: 180.54, bp: 1342, electronegativity: 0.98, electrons: '[He] 2s¹', oxidation: [1], discovered: 1817, state: 'solid' },
    { number: 4, symbol: 'Be', name: 'Beryllium', mass: 9.012, category: 'alkaline-earth', block: 's', group: 2, period: 2, mp: 1287, bp: 2470, electronegativity: 1.57, electrons: '[He] 2s²', oxidation: [2], discovered: 1798, state: 'solid' },
    { number: 5, symbol: 'B', name: 'Boron', mass: 10.811, category: 'metalloid', block: 'p', group: 13, period: 2, mp: 2076, bp: 3927, electronegativity: 2.04, electrons: '[He] 2s² 2p¹', oxidation: [3], discovered: 1808, state: 'solid' },
    { number: 6, symbol: 'C', name: 'Carbon', mass: 12.011, category: 'nonmetal', block: 'p', group: 14, period: 2, mp: 3550, bp: 4027, electronegativity: 2.55, electrons: '[He] 2s² 2p²', oxidation: [-4, -3, -2, -1, 1, 2, 3, 4], discovered: 'Ancient', state: 'solid' },
    { number: 7, symbol: 'N', name: 'Nitrogen', mass: 14.007, category: 'nonmetal', block: 'p', group: 15, period: 2, mp: -210.1, bp: -195.79, electronegativity: 3.04, electrons: '[He] 2s² 2p³', oxidation: [-3, -2, -1, 1, 2, 3, 4, 5], discovered: 1772, state: 'gas' },
    { number: 8, symbol: 'O', name: 'Oxygen', mass: 15.999, category: 'nonmetal', block: 'p', group: 16, period: 2, mp: -218.79, bp: -182.96, electronegativity: 3.44, electrons: '[He] 2s² 2p⁴', oxidation: [-2, -1, 1, 2], discovered: 1774, state: 'gas' },
    { number: 9, symbol: 'F', name: 'Fluorine', mass: 18.998, category: 'halogen', block: 'p', group: 17, period: 2, mp: -219.67, bp: -188.12, electronegativity: 3.98, electrons: '[He] 2s² 2p⁵', oxidation: [-1], discovered: 1886, state: 'gas' },
    { number: 10, symbol: 'Ne', name: 'Neon', mass: 20.180, category: 'noble-gas', block: 'p', group: 18, period: 2, mp: -248.59, bp: -246.08, electronegativity: null, electrons: '[He] 2s² 2p⁶', oxidation: [0], discovered: 1898, state: 'gas' },
    { number: 11, symbol: 'Na', name: 'Sodium', mass: 22.990, category: 'alkali-metal', block: 's', group: 1, period: 3, mp: 97.72, bp: 883, electronegativity: 0.93, electrons: '[Ne] 3s¹', oxidation: [1], discovered: 1807, state: 'solid' },
    { number: 12, symbol: 'Mg', name: 'Magnesium', mass: 24.305, category: 'alkaline-earth', block: 's', group: 2, period: 3, mp: 650, bp: 1090, electronegativity: 1.31, electrons: '[Ne] 3s²', oxidation: [2], discovered: 1808, state: 'solid' },
    { number: 13, symbol: 'Al', name: 'Aluminum', mass: 26.982, category: 'post-transition', block: 'p', group: 13, period: 3, mp: 660.32, bp: 2519, electronegativity: 1.61, electrons: '[Ne] 3s² 3p¹', oxidation: [3], discovered: 1825, state: 'solid' },
    { number: 14, symbol: 'Si', name: 'Silicon', mass: 28.086, category: 'metalloid', block: 'p', group: 14, period: 3, mp: 1414, bp: 3265, electronegativity: 1.90, electrons: '[Ne] 3s² 3p²', oxidation: [-4, -3, -2, -1, 1, 2, 3, 4], discovered: 1824, state: 'solid' },
    { number: 15, symbol: 'P', name: 'Phosphorus', mass: 30.974, category: 'nonmetal', block: 'p', group: 15, period: 3, mp: 44.15, bp: 280.5, electronegativity: 2.19, electrons: '[Ne] 3s² 3p³', oxidation: [-3, -2, -1, 1, 2, 3, 4, 5], discovered: 1669, state: 'solid' },
    { number: 16, symbol: 'S', name: 'Sulfur', mass: 32.065, category: 'nonmetal', block: 'p', group: 16, period: 3, mp: 115.21, bp: 444.72, electronegativity: 2.58, electrons: '[Ne] 3s² 3p⁴', oxidation: [-2, -1, 1, 2, 3, 4, 5, 6], discovered: 'Ancient', state: 'solid' },
    { number: 17, symbol: 'Cl', name: 'Chlorine', mass: 35.453, category: 'halogen', block: 'p', group: 17, period: 3, mp: -101.5, bp: -34.04, electronegativity: 3.16, electrons: '[Ne] 3s² 3p⁵', oxidation: [-1, 1, 2, 3, 4, 5, 6, 7], discovered: 1774, state: 'gas' },
    { number: 18, symbol: 'Ar', name: 'Argon', mass: 39.948, category: 'noble-gas', block: 'p', group: 18, period: 3, mp: -189.35, bp: -185.85, electronegativity: null, electrons: '[Ne] 3s² 3p⁶', oxidation: [0], discovered: 1894, state: 'gas' },
    { number: 19, symbol: 'K', name: 'Potassium', mass: 39.098, category: 'alkali-metal', block: 's', group: 1, period: 4, mp: 63.38, bp: 759, electronegativity: 0.82, electrons: '[Ar] 4s¹', oxidation: [1], discovered: 1807, state: 'solid' },
    { number: 20, symbol: 'Ca', name: 'Calcium', mass: 40.078, category: 'alkaline-earth', block: 's', group: 2, period: 4, mp: 842, bp: 1484, electronegativity: 1.00, electrons: '[Ar] 4s²', oxidation: [2], discovered: 1808, state: 'solid' },
    { number: 21, symbol: 'Sc', name: 'Scandium', mass: 44.956, category: 'transition-metal', block: 'd', group: 3, period: 4, mp: 1541, bp: 2836, electronegativity: 1.36, electrons: '[Ar] 3d¹ 4s²', oxidation: [3], discovered: 1879, state: 'solid' },
    { number: 22, symbol: 'Ti', name: 'Titanium', mass: 47.867, category: 'transition-metal', block: 'd', group: 4, period: 4, mp: 1668, bp: 3287, electronegativity: 1.54, electrons: '[Ar] 3d² 4s²', oxidation: [2, 3, 4], discovered: 1791, state: 'solid' },
    { number: 23, symbol: 'V', name: 'Vanadium', mass: 50.942, category: 'transition-metal', block: 'd', group: 5, period: 4, mp: 1910, bp: 3407, electronegativity: 1.63, electrons: '[Ar] 3d³ 4s²', oxidation: [2, 3, 4, 5], discovered: 1801, state: 'solid' },
    { number: 24, symbol: 'Cr', name: 'Chromium', mass: 51.996, category: 'transition-metal', block: 'd', group: 6, period: 4, mp: 1907, bp: 2671, electronegativity: 1.66, electrons: '[Ar] 3d⁵ 4s¹', oxidation: [2, 3, 6], discovered: 1797, state: 'solid' },
    { number: 25, symbol: 'Mn', name: 'Manganese', mass: 54.938, category: 'transition-metal', block: 'd', group: 7, period: 4, mp: 1246, bp: 2061, electronegativity: 1.55, electrons: '[Ar] 3d⁵ 4s²', oxidation: [2, 3, 4, 6, 7], discovered: 1774, state: 'solid' },
    { number: 26, symbol: 'Fe', name: 'Iron', mass: 55.845, category: 'transition-metal', block: 'd', group: 8, period: 4, mp: 1538, bp: 2862, electronegativity: 1.83, electrons: '[Ar] 3d⁶ 4s²', oxidation: [2, 3], discovered: 'Ancient', state: 'solid' },
    { number: 27, symbol: 'Co', name: 'Cobalt', mass: 58.933, category: 'transition-metal', block: 'd', group: 9, period: 4, mp: 1495, bp: 2927, electronegativity: 1.88, electrons: '[Ar] 3d⁷ 4s²', oxidation: [2, 3], discovered: 1735, state: 'solid' },
    { number: 28, symbol: 'Ni', name: 'Nickel', mass: 58.693, category: 'transition-metal', block: 'd', group: 10, period: 4, mp: 1455, bp: 2913, electronegativity: 1.91, electrons: '[Ar] 3d⁸ 4s²', oxidation: [2, 3], discovered: 1751, state: 'solid' },
    { number: 29, symbol: 'Cu', name: 'Copper', mass: 63.546, category: 'transition-metal', block: 'd', group: 11, period: 4, mp: 1084.62, bp: 2562, electronegativity: 1.90, electrons: '[Ar] 3d¹⁰ 4s¹', oxidation: [1, 2], discovered: 'Ancient', state: 'solid' },
    { number: 30, symbol: 'Zn', name: 'Zinc', mass: 65.38, category: 'transition-metal', block: 'd', group: 12, period: 4, mp: 419.53, bp: 907, electronegativity: 1.65, electrons: '[Ar] 3d¹⁰ 4s²', oxidation: [2], discovered: 1746, state: 'solid' },
    { number: 31, symbol: 'Ga', name: 'Gallium', mass: 69.723, category: 'post-transition', block: 'p', group: 13, period: 4, mp: 29.76, bp: 2204, electronegativity: 1.81, electrons: '[Ar] 3d¹⁰ 4s² 4p¹', oxidation: [3], discovered: 1875, state: 'solid' },
    { number: 32, symbol: 'Ge', name: 'Germanium', mass: 72.64, category: 'metalloid', block: 'p', group: 14, period: 4, mp: 938.25, bp: 2833, electronegativity: 2.01, electrons: '[Ar] 3d¹⁰ 4s² 4p²', oxidation: [2, 4], discovered: 1886, state: 'solid' },
    { number: 33, symbol: 'As', name: 'Arsenic', mass: 74.922, category: 'metalloid', block: 'p', group: 15, period: 4, mp: 817, bp: 614, electronegativity: 2.18, electrons: '[Ar] 3d¹⁰ 4s² 4p³', oxidation: [-3, 3, 5], discovered: 'Ancient', state: 'solid' },
    { number: 34, symbol: 'Se', name: 'Selenium', mass: 78.96, category: 'nonmetal', block: 'p', group: 16, period: 4, mp: 221, bp: 685, electronegativity: 2.55, electrons: '[Ar] 3d¹⁰ 4s² 4p⁴', oxidation: [-2, 2, 4, 6], discovered: 1817, state: 'solid' },
    { number: 35, symbol: 'Br', name: 'Bromine', mass: 79.904, category: 'halogen', block: 'p', group: 17, period: 4, mp: -7.2, bp: 58.8, electronegativity: 2.96, electrons: '[Ar] 3d¹⁰ 4s² 4p⁵', oxidation: [-1, 1, 3, 5], discovered: 1826, state: 'liquid' },
    { number: 36, symbol: 'Kr', name: 'Krypton', mass: 83.798, category: 'noble-gas', block: 'p', group: 18, period: 4, mp: -157.36, bp: -153.22, electronegativity: 3.00, electrons: '[Ar] 3d¹⁰ 4s² 4p⁶', oxidation: [0, 2], discovered: 1898, state: 'gas' },
    { number: 37, symbol: 'Rb', name: 'Rubidium', mass: 85.468, category: 'alkali-metal', block: 's', group: 1, period: 5, mp: 39.31, bp: 688, electronegativity: 0.82, electrons: '[Kr] 5s¹', oxidation: [1], discovered: 1861, state: 'solid' },
    { number: 38, symbol: 'Sr', name: 'Strontium', mass: 87.62, category: 'alkaline-earth', block: 's', group: 2, period: 5, mp: 777, bp: 1382, electronegativity: 0.95, electrons: '[Kr] 5s²', oxidation: [2], discovered: 1790, state: 'solid' },
    { number: 39, symbol: 'Y', name: 'Yttrium', mass: 88.906, category: 'transition-metal', block: 'd', group: 3, period: 5, mp: 1526, bp: 3345, electronegativity: 1.22, electrons: '[Kr] 4d¹ 5s²', oxidation: [3], discovered: 1794, state: 'solid' },
    { number: 40, symbol: 'Zr', name: 'Zirconium', mass: 91.224, category: 'transition-metal', block: 'd', group: 4, period: 5, mp: 1855, bp: 4409, electronegativity: 1.33, electrons: '[Kr] 4d² 5s²', oxidation: [4], discovered: 1789, state: 'solid' },
    { number: 41, symbol: 'Nb', name: 'Niobium', mass: 92.906, category: 'transition-metal', block: 'd', group: 5, period: 5, mp: 2477, bp: 4744, electronegativity: 1.6, electrons: '[Kr] 4d⁴ 5s¹', oxidation: [3, 5], discovered: 1801, state: 'solid' },
    { number: 42, symbol: 'Mo', name: 'Molybdenum', mass: 95.96, category: 'transition-metal', block: 'd', group: 6, period: 5, mp: 2623, bp: 4639, electronegativity: 2.16, electrons: '[Kr] 4d⁵ 5s¹', oxidation: [4, 6], discovered: 1778, state: 'solid' },
    { number: 43, symbol: 'Tc', name: 'Technetium', mass: 98, category: 'transition-metal', block: 'd', group: 7, period: 5, mp: 2157, bp: 4265, electronegativity: 1.9, electrons: '[Kr] 4d⁵ 5s²', oxidation: [4, 7], discovered: 1937, state: 'solid' },
    { number: 44, symbol: 'Ru', name: 'Ruthenium', mass: 101.07, category: 'transition-metal', block: 'd', group: 8, period: 5, mp: 2334, bp: 4150, electronegativity: 2.2, electrons: '[Kr] 4d⁷ 5s¹', oxidation: [3, 4], discovered: 1844, state: 'solid' },
    { number: 45, symbol: 'Rh', name: 'Rhodium', mass: 102.91, category: 'transition-metal', block: 'd', group: 9, period: 5, mp: 1964, bp: 3695, electronegativity: 2.28, electrons: '[Kr] 4d⁸ 5s¹', oxidation: [3], discovered: 1803, state: 'solid' },
    { number: 46, symbol: 'Pd', name: 'Palladium', mass: 106.42, category: 'transition-metal', block: 'd', group: 10, period: 5, mp: 1554.9, bp: 2963, electronegativity: 2.20, electrons: '[Kr] 4d¹⁰', oxidation: [2, 4], discovered: 1803, state: 'solid' },
    { number: 47, symbol: 'Ag', name: 'Silver', mass: 107.87, category: 'transition-metal', block: 'd', group: 11, period: 5, mp: 961.78, bp: 2162, electronegativity: 1.93, electrons: '[Kr] 4d¹⁰ 5s¹', oxidation: [1], discovered: 'Ancient', state: 'solid' },
    { number: 48, symbol: 'Cd', name: 'Cadmium', mass: 112.41, category: 'transition-metal', block: 'd', group: 12, period: 5, mp: 321.07, bp: 767, electronegativity: 1.69, electrons: '[Kr] 4d¹⁰ 5s²', oxidation: [2], discovered: 1817, state: 'solid' },
    { number: 49, symbol: 'In', name: 'Indium', mass: 114.82, category: 'post-transition', block: 'p', group: 13, period: 5, mp: 156.6, bp: 2072, electronegativity: 1.78, electrons: '[Kr] 4d¹⁰ 5s² 5p¹', oxidation: [3], discovered: 1863, state: 'solid' },
    { number: 50, symbol: 'Sn', name: 'Tin', mass: 118.71, category: 'post-transition', block: 'p', group: 14, period: 5, mp: 231.93, bp: 2602, electronegativity: 1.96, electrons: '[Kr] 4d¹⁰ 5s² 5p²', oxidation: [2, 4], discovered: 'Ancient', state: 'solid' },
    { number: 51, symbol: 'Sb', name: 'Antimony', mass: 121.76, category: 'metalloid', block: 'p', group: 15, period: 5, mp: 630.63, bp: 1587, electronegativity: 2.05, electrons: '[Kr] 4d¹⁰ 5s² 5p³', oxidation: [-3, 3, 5], discovered: 'Ancient', state: 'solid' },
    { number: 52, symbol: 'Te', name: 'Tellurium', mass: 127.60, category: 'metalloid', block: 'p', group: 16, period: 5, mp: 449.51, bp: 988, electronegativity: 2.1, electrons: '[Kr] 4d¹⁰ 5s² 5p⁴', oxidation: [-2, 2, 4, 6], discovered: 1783, state: 'solid' },
    { number: 53, symbol: 'I', name: 'Iodine', mass: 126.90, category: 'halogen', block: 'p', group: 17, period: 5, mp: 113.7, bp: 184.3, electronegativity: 2.66, electrons: '[Kr] 4d¹⁰ 5s² 5p⁵', oxidation: [-1, 1, 5, 7], discovered: 1811, state: 'solid' },
    { number: 54, symbol: 'Xe', name: 'Xenon', mass: 131.29, category: 'noble-gas', block: 'p', group: 18, period: 5, mp: -111.8, bp: -108.1, electronegativity: 2.60, electrons: '[Kr] 4d¹⁰ 5s² 5p⁶', oxidation: [0], discovered: 1898, state: 'gas' },
    { number: 55, symbol: 'Cs', name: 'Cesium', mass: 132.91, category: 'alkali-metal', block: 's', group: 1, period: 6, mp: 28.44, bp: 671, electronegativity: 0.79, electrons: '[Xe] 6s¹', oxidation: [1], discovered: 1860, state: 'liquid' },
    { number: 56, symbol: 'Ba', name: 'Barium', mass: 137.33, category: 'alkaline-earth', block: 's', group: 2, period: 6, mp: 727, bp: 1897, electronegativity: 0.89, electrons: '[Xe] 6s²', oxidation: [2], discovered: 1808, state: 'solid' },
    { number: 57, symbol: 'La', name: 'Lanthanum', mass: 138.91, category: 'lanthanide', block: 'f', group: 3, period: 6, mp: 920, bp: 3464, electronegativity: 1.10, electrons: '[Xe] 5d¹ 6s²', oxidation: [3], discovered: 1839, state: 'solid' },
    { number: 58, symbol: 'Ce', name: 'Cerium', mass: 140.12, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 798, bp: 3360, electronegativity: 1.12, electrons: '[Xe] 4f¹ 5d¹ 6s²', oxidation: [3, 4], discovered: 1803, state: 'solid' },
    { number: 59, symbol: 'Pr', name: 'Praseodymium', mass: 140.91, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 931, bp: 3520, electronegativity: 1.13, electrons: '[Xe] 4f³ 6s²', oxidation: [3], discovered: 1885, state: 'solid' },
    { number: 60, symbol: 'Nd', name: 'Neodymium', mass: 144.24, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1021, bp: 3074, electronegativity: 1.14, electrons: '[Xe] 4f⁴ 6s²', oxidation: [3], discovered: 1885, state: 'solid' },
    { number: 61, symbol: 'Pm', name: 'Promethium', mass: 145, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1042, bp: 3000, electronegativity: 1.13, electrons: '[Xe] 4f⁵ 6s²', oxidation: [3], discovered: 1945, state: 'solid' },
    { number: 62, symbol: 'Sm', name: 'Samarium', mass: 150.36, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1074, bp: 1794, electronegativity: 1.17, electrons: '[Xe] 4f⁶ 6s²', oxidation: [2, 3], discovered: 1879, state: 'solid' },
    { number: 63, symbol: 'Eu', name: 'Europium', mass: 151.96, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 822, bp: 1527, electronegativity: 1.20, electrons: '[Xe] 4f⁷ 6s²', oxidation: [2, 3], discovered: 1901, state: 'solid' },
    { number: 64, symbol: 'Gd', name: 'Gadolinium', mass: 157.25, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1313, bp: 3273, electronegativity: 1.20, electrons: '[Xe] 4f⁷ 5d¹ 6s²', oxidation: [3], discovered: 1880, state: 'solid' },
    { number: 65, symbol: 'Tb', name: 'Terbium', mass: 158.93, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1356, bp: 3230, electronegativity: 1.20, electrons: '[Xe] 4f⁹ 6s²', oxidation: [3], discovered: 1843, state: 'solid' },
    { number: 66, symbol: 'Dy', name: 'Dysprosium', mass: 162.50, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1412, bp: 2567, electronegativity: 1.22, electrons: '[Xe] 4f¹⁰ 6s²', oxidation: [3], discovered: 1886, state: 'solid' },
    { number: 67, symbol: 'Ho', name: 'Holmium', mass: 164.93, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1474, bp: 2700, electronegativity: 1.23, electrons: '[Xe] 4f¹¹ 6s²', oxidation: [3], discovered: 1878, state: 'solid' },
    { number: 68, symbol: 'Er', name: 'Erbium', mass: 167.26, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1529, bp: 2868, electronegativity: 1.24, electrons: '[Xe] 4f¹² 6s²', oxidation: [3], discovered: 1843, state: 'solid' },
    { number: 69, symbol: 'Tm', name: 'Thulium', mass: 168.93, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 1545, bp: 1950, electronegativity: 1.25, electrons: '[Xe] 4f¹³ 6s²', oxidation: [3], discovered: 1879, state: 'solid' },
    { number: 70, symbol: 'Yb', name: 'Ytterbium', mass: 173.05, category: 'lanthanide', block: 'f', group: null, period: 6, mp: 824, bp: 1196, electronegativity: 1.10, electrons: '[Xe] 4f¹⁴ 6s²', oxidation: [2, 3], discovered: 1878, state: 'solid' },
    { number: 71, symbol: 'Lu', name: 'Lutetium', mass: 174.97, category: 'lanthanide', block: 'd', group: 3, period: 6, mp: 1663, bp: 3402, electronegativity: 1.27, electrons: '[Xe] 4f¹⁴ 5d¹ 6s²', oxidation: [3], discovered: 1907, state: 'solid' },
    { number: 72, symbol: 'Hf', name: 'Hafnium', mass: 178.49, category: 'transition-metal', block: 'd', group: 4, period: 6, mp: 2233, bp: 4603, electronegativity: 1.3, electrons: '[Xe] 4f¹⁴ 5d² 6s²', oxidation: [4], discovered: 1923, state: 'solid' },
    { number: 73, symbol: 'Ta', name: 'Tantalum', mass: 180.95, category: 'transition-metal', block: 'd', group: 5, period: 6, mp: 3017, bp: 5458, electronegativity: 1.5, electrons: '[Xe] 4f¹⁴ 5d³ 6s²', oxidation: [5], discovered: 1802, state: 'solid' },
    { number: 74, symbol: 'W', name: 'Tungsten', mass: 183.84, category: 'transition-metal', block: 'd', group: 6, period: 6, mp: 3422, bp: 5555, electronegativity: 2.36, electrons: '[Xe] 4f¹⁴ 5d⁴ 6s²', oxidation: [4, 6], discovered: 1783, state: 'solid' },
    { number: 75, symbol: 'Re', name: 'Rhenium', mass: 186.21, category: 'transition-metal', block: 'd', group: 7, period: 6, mp: 3186, bp: 5596, electronegativity: 1.9, electrons: '[Xe] 4f¹⁴ 5d⁵ 6s²', oxidation: [4, 7], discovered: 1925, state: 'solid' },
    { number: 76, symbol: 'Os', name: 'Osmium', mass: 190.23, category: 'transition-metal', block: 'd', group: 8, period: 6, mp: 3033, bp: 5012, electronegativity: 2.2, electrons: '[Xe] 4f¹⁴ 5d⁶ 6s²', oxidation: [4], discovered: 1803, state: 'solid' },
    { number: 77, symbol: 'Ir', name: 'Iridium', mass: 192.22, category: 'transition-metal', block: 'd', group: 9, period: 6, mp: 2446, bp: 4428, electronegativity: 2.20, electrons: '[Xe] 4f¹⁴ 5d⁷ 6s²', oxidation: [3, 4], discovered: 1803, state: 'solid' },
    { number: 78, symbol: 'Pt', name: 'Platinum', mass: 195.08, category: 'transition-metal', block: 'd', group: 10, period: 6, mp: 1768.3, bp: 3825, electronegativity: 2.28, electrons: '[Xe] 4f¹⁴ 5d⁹ 6s¹', oxidation: [2, 4], discovered: 1735, state: 'solid' },
    { number: 79, symbol: 'Au', name: 'Gold', mass: 196.97, category: 'transition-metal', block: 'd', group: 11, period: 6, mp: 1064.18, bp: 2856, electronegativity: 2.54, electrons: '[Xe] 4f¹⁴ 5d¹⁰ 6s¹', oxidation: [1, 3], discovered: 'Ancient', state: 'solid' },
    { number: 80, symbol: 'Hg', name: 'Mercury', mass: 200.59, category: 'transition-metal', block: 'd', group: 12, period: 6, mp: -38.83, bp: 356.73, electronegativity: 2.00, electrons: '[Xe] 4f¹⁴ 5d¹⁰ 6s²', oxidation: [1, 2], discovered: 'Ancient', state: 'liquid' },
    { number: 81, symbol: 'Tl', name: 'Thallium', mass: 204.38, category: 'post-transition', block: 'p', group: 13, period: 6, mp: 304, bp: 1473, electronegativity: 1.62, electrons: '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p¹', oxidation: [1, 3], discovered: 1861, state: 'solid' },
    { number: 82, symbol: 'Pb', name: 'Lead', mass: 207.2, category: 'post-transition', block: 'p', group: 14, period: 6, mp: 327.46, bp: 1749, electronegativity: 2.33, electrons: '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p²', oxidation: [2, 4], discovered: 'Ancient', state: 'solid' },
    { number: 83, symbol: 'Bi', name: 'Bismuth', mass: 208.98, category: 'post-transition', block: 'p', group: 15, period: 6, mp: 271.3, bp: 1564, electronegativity: 2.02, electrons: '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p³', oxidation: [3, 5], discovered: 1753, state: 'solid' },
    { number: 84, symbol: 'Po', name: 'Polonium', mass: 209, category: 'post-transition', block: 'p', group: 16, period: 6, mp: 254, bp: 962, electronegativity: 2.0, electrons: '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p⁴', oxidation: [2, 4], discovered: 1898, state: 'solid' },
    { number: 85, symbol: 'At', name: 'Astatine', mass: 210, category: 'halogen', block: 'p', group: 17, period: 6, mp: 302, bp: 337, electronegativity: 2.2, electrons: '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p⁵', oxidation: [-1, 1], discovered: 1940, state: 'solid' },
    { number: 86, symbol: 'Rn', name: 'Radon', mass: 222, category: 'noble-gas', block: 'p', group: 18, period: 6, mp: -71, bp: -61.7, electronegativity: 2.2, electrons: '[Xe] 4f¹⁴ 5d¹⁰ 6s² 6p⁶', oxidation: [0], discovered: 1900, state: 'gas' },
    { number: 87, symbol: 'Fr', name: 'Francium', mass: 223, category: 'alkali-metal', block: 's', group: 1, period: 7, mp: 27, bp: 677, electronegativity: 0.7, electrons: '[Rn] 7s¹', oxidation: [1], discovered: 1939, state: 'liquid' },
    { number: 88, symbol: 'Ra', name: 'Radium', mass: 226, category: 'alkaline-earth', block: 's', group: 2, period: 7, mp: 700, bp: 1737, electronegativity: 0.9, electrons: '[Rn] 7s²', oxidation: [2], discovered: 1898, state: 'solid' },
    { number: 89, symbol: 'Ac', name: 'Actinium', mass: 227, category: 'actinide', block: 'f', group: 3, period: 7, mp: 1050, bp: 3200, electronegativity: 1.1, electrons: '[Rn] 6d¹ 7s²', oxidation: [3], discovered: 1899, state: 'solid' },
    { number: 90, symbol: 'Th', name: 'Thorium', mass: 232.04, category: 'actinide', block: 'f', group: null, period: 7, mp: 1750, bp: 4820, electronegativity: 1.3, electrons: '[Rn] 6d² 7s²', oxidation: [4], discovered: 1828, state: 'solid' },
    { number: 91, symbol: 'Pa', name: 'Protactinium', mass: 231.04, category: 'actinide', block: 'f', group: null, period: 7, mp: 1572, bp: 4000, electronegativity: 1.5, electrons: '[Rn] 5f² 6d¹ 7s²', oxidation: [5], discovered: 1913, state: 'solid' },
    { number: 92, symbol: 'U', name: 'Uranium', mass: 238.03, category: 'actinide', block: 'f', group: null, period: 7, mp: 1135, bp: 4131, electronegativity: 1.38, electrons: '[Rn] 5f³ 6d¹ 7s²', oxidation: [3, 4, 5, 6], discovered: 1789, state: 'solid' },
    { number: 93, symbol: 'Np', name: 'Neptunium', mass: 237, category: 'actinide', block: 'f', group: null, period: 7, mp: 644, bp: 3902, electronegativity: 1.36, electrons: '[Rn] 5f⁴ 6d¹ 7s²', oxidation: [3, 4, 5, 6], discovered: 1940, state: 'solid' },
    { number: 94, symbol: 'Pu', name: 'Plutonium', mass: 244, category: 'actinide', block: 'f', group: null, period: 7, mp: 640, bp: 3228, electronegativity: 1.28, electrons: '[Rn] 5f⁶ 7s²', oxidation: [3, 4, 5, 6], discovered: 1940, state: 'solid' },
    { number: 95, symbol: 'Am', name: 'Americium', mass: 243, category: 'actinide', block: 'f', group: null, period: 7, mp: 1176, bp: 2011, electronegativity: 1.3, electrons: '[Rn] 5f⁷ 7s²', oxidation: [3, 4, 5, 6], discovered: 1944, state: 'solid' },
    { number: 96, symbol: 'Cm', name: 'Curium', mass: 247, category: 'actinide', block: 'f', group: null, period: 7, mp: 1345, bp: 3110, electronegativity: 1.3, electrons: '[Rn] 5f⁷ 6d¹ 7s²', oxidation: [3], discovered: 1944, state: 'solid' },
    { number: 97, symbol: 'Bk', name: 'Berkelium', mass: 247, category: 'actinide', block: 'f', group: null, period: 7, mp: 1050, bp: 2627, electronegativity: 1.3, electrons: '[Rn] 5f⁹ 7s²', oxidation: [3, 4], discovered: 1949, state: 'solid' },
    { number: 98, symbol: 'Cf', name: 'Californium', mass: 251, category: 'actinide', block: 'f', group: null, period: 7, mp: 900, bp: 1470, electronegativity: 1.3, electrons: '[Rn] 5f¹⁰ 7s²', oxidation: [3], discovered: 1950, state: 'solid' },
    { number: 99, symbol: 'Es', name: 'Einsteinium', mass: 252, category: 'actinide', block: 'f', group: null, period: 7, mp: 860, bp: 996, electronegativity: 1.3, electrons: '[Rn] 5f¹¹ 7s²', oxidation: [3], discovered: 1952, state: 'solid' },
    { number: 100, symbol: 'Fm', name: 'Fermium', mass: 257, category: 'actinide', block: 'f', group: null, period: 7, mp: 1527, bp: null, electronegativity: 1.3, electrons: '[Rn] 5f¹² 7s²', oxidation: [3], discovered: 1952, state: 'solid' },
    { number: 101, symbol: 'Md', name: 'Mendelevium', mass: 258, category: 'actinide', block: 'f', group: null, period: 7, mp: 827, bp: null, electronegativity: 1.3, electrons: '[Rn] 5f¹³ 7s²', oxidation: [2, 3], discovered: 1955, state: 'solid' },
    { number: 102, symbol: 'No', name: 'Nobelium', mass: 259, category: 'actinide', block: 'f', group: null, period: 7, mp: 827, bp: null, electronegativity: 1.3, electrons: '[Rn] 5f¹⁴ 7s²', oxidation: [2, 3], discovered: 1958, state: 'solid' },
    { number: 103, symbol: 'Lr', name: 'Lawrencium', mass: 266, category: 'actinide', block: 'd', group: 3, period: 7, mp: 1627, bp: null, electronegativity: 1.3, electrons: '[Rn] 5f¹⁴ 7s² 7p¹', oxidation: [3], discovered: 1961, state: 'solid' },
    { number: 104, symbol: 'Rf', name: 'Rutherfordium', mass: 267, category: 'transition-metal', block: 'd', group: 4, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d² 7s²', oxidation: [4], discovered: 1969, state: 'solid' },
    { number: 105, symbol: 'Db', name: 'Dubnium', mass: 268, category: 'transition-metal', block: 'd', group: 5, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d³ 7s²', oxidation: [5], discovered: 1970, state: 'solid' },
    { number: 106, symbol: 'Sg', name: 'Seaborgium', mass: 269, category: 'transition-metal', block: 'd', group: 6, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d⁴ 7s²', oxidation: [6], discovered: 1974, state: 'solid' },
    { number: 107, symbol: 'Bh', name: 'Bohrium', mass: 270, category: 'transition-metal', block: 'd', group: 7, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d⁵ 7s²', oxidation: [7], discovered: 1981, state: 'solid' },
    { number: 108, symbol: 'Hs', name: 'Hassium', mass: 277, category: 'transition-metal', block: 'd', group: 8, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d⁶ 7s²', oxidation: [8], discovered: 1984, state: 'solid' },
    { number: 109, symbol: 'Mt', name: 'Meitnerium', mass: 278, category: 'transition-metal', block: 'd', group: 9, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d⁷ 7s²', oxidation: null, discovered: 1982, state: 'unknown' },
    { number: 110, symbol: 'Ds', name: 'Darmstadtium', mass: 281, category: 'transition-metal', block: 'd', group: 10, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d⁸ 7s²', oxidation: null, discovered: 1994, state: 'unknown' },
    { number: 111, symbol: 'Rg', name: 'Roentgenium', mass: 282, category: 'transition-metal', block: 'd', group: 11, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d⁹ 7s²', oxidation: null, discovered: 1994, state: 'unknown' },
    { number: 112, symbol: 'Cn', name: 'Copernicium', mass: 285, category: 'transition-metal', block: 'd', group: 12, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d¹⁰ 7s²', oxidation: [2], discovered: 1996, state: 'unknown' },
    { number: 113, symbol: 'Nh', name: 'Nihonium', mass: 286, category: 'post-transition', block: 'p', group: 13, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p¹', oxidation: null, discovered: 2004, state: 'unknown' },
    { number: 114, symbol: 'Fl', name: 'Flerovium', mass: 289, category: 'post-transition', block: 'p', group: 14, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p²', oxidation: null, discovered: 1999, state: 'unknown' },
    { number: 115, symbol: 'Mc', name: 'Moscovium', mass: 290, category: 'post-transition', block: 'p', group: 15, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p³', oxidation: null, discovered: 2003, state: 'unknown' },
    { number: 116, symbol: 'Lv', name: 'Livermorium', mass: 293, category: 'post-transition', block: 'p', group: 16, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p⁴', oxidation: null, discovered: 2000, state: 'unknown' },
    { number: 117, symbol: 'Ts', name: 'Tennessine', mass: 294, category: 'halogen', block: 'p', group: 17, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p⁵', oxidation: null, discovered: 2010, state: 'unknown' },
    { number: 118, symbol: 'Og', name: 'Oganesson', mass: 294, category: 'noble-gas', block: 'p', group: 18, period: 7, mp: null, bp: null, electronegativity: null, electrons: '[Rn] 5f¹⁴ 6d¹⁰ 7s² 7p⁶', oxidation: null, discovered: 2006, state: 'unknown' }
];

// Category legends
const categoryLegends = {
    'alkali-metal': { name: 'Alkali Metals', color: 'var(--alkali-metal)' },
    'alkaline-earth': { name: 'Alkaline Earth Metals', color: 'var(--alkaline-earth)' },
    'transition-metal': { name: 'Transition Metals', color: 'var(--transition-metal)' },
    'post-transition': { name: 'Post-transition Metals', color: 'var(--post-transition)' },
    'metalloid': { name: 'Metalloids', color: 'var(--metalloid)' },
    'nonmetal': { name: 'Nonmetals', color: 'var(--nonmetal)' },
    'halogen': { name: 'Halogens', color: 'var(--halogen)' },
    'noble-gas': { name: 'Noble Gases', color: 'var(--noble-gas)' },
    'lanthanide': { name: 'Lanthanides', color: 'var(--lanthanide)' },
    'actinide': { name: 'Actinides', color: 'var(--actinide)' },
    'unknown': { name: 'Unknown Properties', color: 'var(--unknown)' }
};

const blockLegends = {
    's': { name: 's-block', color: '#ffadad' },
    'p': { name: 'p-block', color: '#ffd6a5' },
    'd': { name: 'd-block', color: '#caffbf' },
    'f': { name: 'f-block', color: '#a0c4ff' }
};

const stateLegends = {
    'solid': { name: 'Solid', color: '#95e1d3' },
    'liquid': { name: 'Liquid', color: '#6dd5ed' },
    'gas': { name: 'Gas', color: '#f38181' },
    'unknown': { name: 'Unknown', color: '#e0e0e0' }
};

// Atomic Radius data (in picometers)
const atomicRadius = {
    1:53, 2:31, 3:167, 4:112, 5:87, 6:67, 7:56, 8:48, 9:42, 10:38,
    11:190, 12:145, 13:118, 14:111, 15:98, 16:88, 17:79, 18:71,
    19:243, 20:194, 21:184, 22:176, 23:171, 24:166, 25:161, 26:156, 27:152, 28:149, 29:145, 30:142,
    31:136, 32:125, 33:114, 34:103, 35:94, 36:88,
    37:265, 38:219, 39:212, 40:206, 41:198, 42:190, 43:183, 44:178, 45:173, 46:169, 47:165, 48:161,
    49:156, 50:145, 51:133, 52:123, 53:115, 54:108,
    55:298, 56:253, 72:208, 73:200, 74:193, 75:188, 76:185, 77:180, 78:177, 79:174, 80:171,
    81:156, 82:154, 83:143, 84:135, 85:127, 86:120
};

// Ionization Energy data (in kJ/mol)
const ionizationEnergy = {
    1:1312, 2:2372, 3:520, 4:899, 5:801, 6:1086, 7:1402, 8:1314, 9:1681, 10:2081,
    11:496, 12:738, 13:578, 14:787, 15:1012, 16:1000, 17:1251, 18:1521,
    19:419, 20:590, 21:633, 22:658, 23:651, 24:653, 25:717, 26:762, 27:760, 28:737, 29:746, 30:906,
    31:579, 32:762, 33:947, 34:941, 35:1140, 36:1351,
    37:403, 38:550, 39:600, 40:640, 41:652, 42:684, 43:702, 44:710, 45:720, 46:805, 47:731, 48:868,
    49:558, 50:709, 51:834, 52:869, 53:1008, 54:1170,
    55:376, 56:503, 72:659, 73:761, 74:770, 75:760, 76:840, 77:880, 78:870, 79:890, 80:1007,
    81:589, 82:716, 83:703, 84:812, 85:920, 86:1037
};

let currentColorMode = 'category';
let currentTemp = 25;
let compareMode = false;
let selectedElements = [];
let keyboardFocusIndex = 0;

function renderPeriodicTable() {
    const table = document.getElementById('periodicTable');
    table.innerHTML = '';

    // Position mapping for periodic table layout
    const positions = {};
    elements.forEach(el => {
        if (el.period <= 6) {
            if (el.number === 1) positions[el.number] = { row: 1, col: 1 };
            else if (el.number === 2) positions[el.number] = { row: 1, col: 18 };
            else if (el.number >= 3 && el.number <= 10) positions[el.number] = { row: el.period, col: el.group };
            else if (el.number >= 11 && el.number <= 18) positions[el.number] = { row: el.period, col: el.group };
            else if (el.number >= 19 && el.number <= 36) positions[el.number] = { row: el.period, col: el.group };
            else if (el.number >= 37 && el.number <= 54) positions[el.number] = { row: el.period, col: el.group };
            else if (el.number >= 57 && el.number <= 71) {
                // Lanthanides - rendered separately
            }
            else if (el.number === 55 || el.number === 56) positions[el.number] = { row: el.period, col: el.group };
            else if (el.number >= 72 && el.number <= 86) positions[el.number] = { row: el.period, col: el.group };
        } else if (el.period === 7) {
            if (el.number === 87 || el.number === 88) positions[el.number] = { row: 7, col: el.group };
            else if (el.number >= 89 && el.number <= 103) {
                // Actinides - rendered separately
            }
            else if (el.number >= 104) positions[el.number] = { row: 7, col: el.group };
        }
    });

    // Create main table elements
    for (let i = 1; i <= 118; i++) {
        const element = elements.find(el => el.number === i);
        const pos = positions[i];

        if (pos) {
            const div = createElementDiv(element);
            div.style.gridRow = pos.row;
            div.style.gridColumn = pos.col;
            table.appendChild(div);
        }
    }

    // Add placeholder for lanthanides/actinides in main table
    const lanthanidePlaceholder = document.createElement('div');
    lanthanidePlaceholder.className = 'element';
    lanthanidePlaceholder.innerHTML = '<div style="font-size: 1.2em; font-weight: bold;">57-71</div>';
    lanthanidePlaceholder.style.gridRow = 6;
    lanthanidePlaceholder.style.gridColumn = 3;
    lanthanidePlaceholder.style.cursor = 'default';
    lanthanidePlaceholder.style.background = '#ffe5e5';
    table.appendChild(lanthanidePlaceholder);

    const actinidePlaceholder = document.createElement('div');
    actinidePlaceholder.className = 'element';
    actinidePlaceholder.innerHTML = '<div style="font-size: 1.2em; font-weight: bold;">89-103</div>';
    actinidePlaceholder.style.gridRow = 7;
    actinidePlaceholder.style.gridColumn = 3;
    actinidePlaceholder.style.cursor = 'default';
    actinidePlaceholder.style.background = '#ffe5e5';
    table.appendChild(actinidePlaceholder);

    // Render lanthanides
    const lanthanidesContainer = document.getElementById('lanthanides');
    lanthanidesContainer.innerHTML = '';
    elements.filter(el => el.number >= 57 && el.number <= 71).forEach(el => {
        lanthanidesContainer.appendChild(createElementDiv(el));
    });

    // Render actinides
    const actinidesContainer = document.getElementById('actinides');
    actinidesContainer.innerHTML = '';
    elements.filter(el => el.number >= 89 && el.number <= 103).forEach(el => {
        actinidesContainer.appendChild(createElementDiv(el));
    });

    renderLegend();
}

function createElementDiv(element) {
    const div = document.createElement('div');
    div.className = 'element';
    div.dataset.number = element.number;

    const color = getElementColor(element);
    div.style.background = color;

    div.innerHTML = `
        <div class="atomic-number">${element.number}</div>
        <div class="symbol">${element.symbol}</div>
        <div class="name">${element.name}</div>
        <div class="atomic-mass">${element.mass}</div>
    `;

    div.onclick = () => {
        if (compareMode) {
            toggleElementSelection(element);
        } else {
            showElementDetails(element);
        }
    };

    return div;
}

function getElementColor(element) {
    if (currentColorMode === 'category') {
        return categoryLegends[element.category].color;
    } else if (currentColorMode === 'state') {
        return getStateAtTemp(element);
    } else if (currentColorMode === 'block') {
        return blockLegends[element.block].color;
    } else if (currentColorMode === 'group') {
        const hue = element.group ? (element.group * 20) % 360 : 0;
        return `hsl(${hue}, 70%, 75%)`;
    } else if (currentColorMode === 'atomicRadius') {
        const radius = atomicRadius[element.number];
        if (!radius) return '#e0e0e0';
        // Map radius (30-300pm) to color (blue=small, red=large)
        const normalized = Math.min(Math.max((radius - 30) / 270, 0), 1);
        const hue = 240 - (normalized * 240); // 240 (blue) to 0 (red)
        return `hsl(${hue}, 70%, 65%)`;
    } else if (currentColorMode === 'electronegativityTrend') {
        const en = element.electronegativity;
        if (!en) return '#e0e0e0';
        // Map electronegativity (0.7-4.0) to color (red=low, blue=high)
        const normalized = (en - 0.7) / 3.3;
        const hue = normalized * 240; // 0 (red) to 240 (blue)
        return `hsl(${hue}, 70%, 65%)`;
    } else if (currentColorMode === 'ionizationEnergy') {
        const ie = ionizationEnergy[element.number];
        if (!ie) return '#e0e0e0';
        // Map ionization energy (370-2400 kJ/mol) to color (red=low, blue=high)
        const normalized = Math.min((ie - 370) / 2030, 1);
        const hue = normalized * 240; // 0 (red) to 240 (blue)
        return `hsl(${hue}, 70%, 65%)`;
    }
}

function getStateAtTemp(element) {
    if (element.state === 'unknown' || element.mp === null) {
        return stateLegends['unknown'].color;
    }

    if (currentTemp < element.mp) {
        return stateLegends['solid'].color;
    } else if (element.bp && currentTemp < element.bp) {
        return stateLegends['liquid'].color;
    } else if (element.bp) {
        return stateLegends['gas'].color;
    }
    return stateLegends['unknown'].color;
}

function renderLegend() {
    const legend = document.getElementById('legend');
    legend.innerHTML = '';

    let legends = {};
    if (currentColorMode === 'category') {
        legends = categoryLegends;
    } else if (currentColorMode === 'state') {
        legends = stateLegends;
    } else if (currentColorMode === 'block') {
        legends = blockLegends;
    } else if (currentColorMode === 'group') {
        legend.innerHTML = '<div class="legend-item">Colors represent periodic table groups</div>';
        return;
    }

    Object.entries(legends).forEach(([key, value]) => {
        const item = document.createElement('div');
        item.className = 'legend-item';
        item.innerHTML = `
            <div class="legend-color" style="background: ${value.color};"></div>
            <span>${value.name}</span>
        `;
        legend.appendChild(item);
    });
}

function showElementDetails(element) {
    // Remove active class from all elements
    document.querySelectorAll('.element').forEach(el => el.classList.remove('active'));

    // Add active class to clicked element
    const clickedElement = document.querySelector(`[data-number="${element.number}"]`);
    if (clickedElement) clickedElement.classList.add('active');

    const details = document.getElementById('elementDetails');
    const symbol = document.getElementById('detailSymbol');
    const name = document.getElementById('detailName');
    const info = document.getElementById('detailInfo');

    symbol.textContent = element.symbol;
    symbol.style.color = getElementColor(element);
    name.textContent = `${element.name} (${element.number})`;

    info.innerHTML = `
        <div class="info-group">
            <div class="info-label">Atomic Number</div>
            <div class="info-value">${element.number}</div>
        </div>
        <div class="info-group">
            <div class="info-label">Atomic Mass</div>
            <div class="info-value">${element.mass} u</div>
        </div>
        <div class="info-group">
            <div class="info-label">Category</div>
            <div class="info-value">${categoryLegends[element.category].name}</div>
        </div>
        <div class="info-group">
            <div class="info-label">Electron Configuration</div>
            <div class="info-value">${element.electrons}</div>
        </div>
        <div class="info-group">
            <div class="info-label">Group / Period</div>
            <div class="info-value">Group ${element.group || 'N/A'} / Period ${element.period}</div>
        </div>
        <div class="info-group">
            <div class="info-label">Block</div>
            <div class="info-value">${element.block}-block</div>
        </div>
        <div class="info-group">
            <div class="info-label">Melting Point</div>
            <div class="info-value">${element.mp !== null ? element.mp + ' °C' : 'Unknown'}</div>
        </div>
        <div class="info-group">
            <div class="info-label">Boiling Point</div>
            <div class="info-value">${element.bp !== null ? element.bp + ' °C' : 'Unknown'}</div>
        </div>
        <div class="info-group">
            <div class="info-label">Electronegativity</div>
            <div class="info-value">${element.electronegativity !== null ? element.electronegativity : 'N/A'}</div>
        </div>
        <div class="info-group">
            <div class="info-label">Common Oxidation States</div>
            <div class="info-value">${element.oxidation.join(', ')}</div>
        </div>
        <div class="info-group">
            <div class="info-label">Discovered</div>
            <div class="info-value">${element.discovered}</div>
        </div>
        <div class="info-group">
            <div class="info-label">State at 25°C</div>
            <div class="info-value">${element.state.charAt(0).toUpperCase() + element.state.slice(1)}</div>
        </div>
        ${atomicRadius[element.number] ? `
        <div class="info-group">
            <div class="info-label">Atomic Radius</div>
            <div class="info-value">${atomicRadius[element.number]} pm</div>
        </div>` : ''}
        ${ionizationEnergy[element.number] ? `
        <div class="info-group">
            <div class="info-label">Ionization Energy</div>
            <div class="info-value">${ionizationEnergy[element.number]} kJ/mol</div>
        </div>` : ''}
    `;

    details.classList.add('active');
    details.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

    // Draw electron shell diagram
    drawElectronShells(element);
}

function closeDetails() {
    document.getElementById('elementDetails').classList.remove('active');
    document.querySelectorAll('.element').forEach(el => el.classList.remove('active'));
}

// Draw Electron Shell Diagram (Bohr Model)
function drawElectronShells(element) {
    const canvas = document.getElementById('shellCanvas');
    const ctx = canvas.getContext('2d');
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;

    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Calculate electron distribution (2, 8, 18, 32, 32, 18, 8 pattern)
    const electronConfig = getElectronShellConfig(element.number);

    // Draw nucleus
    ctx.beginPath();
    ctx.arc(centerX, centerY, 20, 0, 2 * Math.PI);
    ctx.fillStyle = '#ff6b6b';
    ctx.fill();
    ctx.strokeStyle = '#c92a2a';
    ctx.lineWidth = 2;
    ctx.stroke();

    // Draw nucleus label
    ctx.fillStyle = 'white';
    ctx.font = 'bold 14px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(element.symbol, centerX, centerY);

    // Draw shells and electrons
    electronConfig.forEach((electrons, shellIndex) => {
        const radius = 40 + (shellIndex * 35);

        // Draw shell circle
        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
        ctx.strokeStyle = '#adb5bd';
        ctx.lineWidth = 1;
        ctx.stroke();

        // Draw electrons on this shell
        for (let i = 0; i < electrons; i++) {
            const angle = (2 * Math.PI * i) / electrons;
            const x = centerX + radius * Math.cos(angle);
            const y = centerY + radius * Math.sin(angle);

            ctx.beginPath();
            ctx.arc(x, y, 4, 0, 2 * Math.PI);
            ctx.fillStyle = '#228be6';
            ctx.fill();
            ctx.strokeStyle = '#1864ab';
            ctx.lineWidth = 1;
            ctx.stroke();
        }

        // Draw shell label
        ctx.fillStyle = '#495057';
        ctx.font = '12px Arial';
        ctx.fillText(`n=${shellIndex + 1} (${electrons}e⁻)`, centerX + radius + 20, centerY);
    });
}

function getElectronShellConfig(atomicNumber) {
    const maxElectronsPerShell = [2, 8, 18, 32, 32, 18, 8];
    const shells = [];
    let remaining = atomicNumber;

    for (let i = 0; i < maxElectronsPerShell.length && remaining > 0; i++) {
        const electronsInShell = Math.min(remaining, maxElectronsPerShell[i]);
        shells.push(electronsInShell);
        remaining -= electronsInShell;
    }

    return shells;
}

// Comparison Mode Functions
function toggleCompareMode() {
    compareMode = !compareMode;
    selectedElements = [];

    const btn = document.getElementById('compareBtn');
    const status = document.getElementById('compareStatus');

    if (compareMode) {
        btn.classList.add('active');
        btn.innerHTML = '<i class="fas fa-times"></i> Cancel Compare';
        status.textContent = 'Select 2 elements to compare';
        document.querySelectorAll('.element').forEach(el => el.classList.add('compare-mode'));
    } else {
        btn.classList.remove('active');
        btn.innerHTML = '<i class="fas fa-exchange-alt"></i> Compare Elements';
        status.textContent = '';
        document.querySelectorAll('.element').forEach(el => {
            el.classList.remove('compare-mode');
            el.classList.remove('selected-compare');
        });
        closeComparison();
    }
}

function toggleElementSelection(element) {
    const elementDiv = document.querySelector(`[data-number="${element.number}"]`);

    const index = selectedElements.findIndex(el => el.number === element.number);

    if (index > -1) {
        selectedElements.splice(index, 1);
        elementDiv.classList.remove('selected-compare');
    } else {
        if (selectedElements.length < 2) {
            selectedElements.push(element);
            elementDiv.classList.add('selected-compare');
        } else {
            // Replace first element
            const firstElement = selectedElements[0];
            const firstDiv = document.querySelector(`[data-number="${firstElement.number}"]`);
            firstDiv.classList.remove('selected-compare');
            selectedElements[0] = element;
            elementDiv.classList.add('selected-compare');
        }
    }

    const status = document.getElementById('compareStatus');
    status.textContent = `${selectedElements.length}/2 elements selected`;

    if (selectedElements.length === 2) {
        showComparison();
    }
}

function showComparison() {
    const panel = document.getElementById('comparePanel');
    const content = document.getElementById('compareContent');

    const [el1, el2] = selectedElements;

    const compareProperty = (label, val1, val2) => {
        const v1 = val1 !== null && val1 !== undefined ? val1 : 'N/A';
        const v2 = val2 !== null && val2 !== undefined ? val2 : 'N/A';

        let class1 = '';
        let class2 = '';

        if (typeof val1 === 'number' && typeof val2 === 'number') {
            if (val1 > val2) class1 = 'higher';
            else if (val2 > val1) class2 = 'higher';
        }

        return `
            <div class="compare-label">${label}</div>
            <div class="compare-value ${class1}">${v1}</div>
            <div class="compare-value ${class2}">${v2}</div>
        `;
    };

    content.innerHTML = `
        <div class="compare-element">
            <div class="compare-header">
                <div class="compare-symbol" style="color: ${getElementColor(el1)}">${el1.symbol}</div>
                <div class="compare-name">${el1.name}</div>
                <div style="color: #7f8c8d;">Atomic #${el1.number}</div>
            </div>
        </div>
        <div class="compare-element">
            <div class="compare-header">
                <div class="compare-symbol" style="color: ${getElementColor(el2)}">${el2.symbol}</div>
                <div class="compare-name">${el2.name}</div>
                <div style="color: #7f8c8d;">Atomic #${el2.number}</div>
            </div>
        </div>
    `;

    // Add comparison rows
    const properties = [
        ['Atomic Mass', el1.mass, el2.mass],
        ['Electronegativity', el1.electronegativity, el2.electronegativity],
        ['Melting Point (°C)', el1.mp, el2.mp],
        ['Boiling Point (°C)', el1.bp, el2.bp],
        ['Atomic Radius (pm)', atomicRadius[el1.number], atomicRadius[el2.number]],
        ['Ionization Energy (kJ/mol)', ionizationEnergy[el1.number], ionizationEnergy[el2.number]]
    ];

    properties.forEach(([label, val1, val2]) => {
        const row = document.createElement('div');
        row.className = 'compare-row';
        row.innerHTML = compareProperty(label, val1, val2);
        content.appendChild(row);
    });

    panel.classList.add('active');
    panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

function closeComparison() {
    document.getElementById('comparePanel').classList.remove('active');
}

// Keyboard Navigation
function initKeyboardNavigation() {
    let helpVisible = false;

    document.addEventListener('keydown', (e) => {
        const focusedElement = elements[keyboardFocusIndex];

        // Toggle keyboard help with '?'
        if (e.key === '?' || e.key === '/') {
            e.preventDefault();
            helpVisible = !helpVisible;
            document.getElementById('keyboardHelp').classList.toggle('active', helpVisible);
            return;
        }

        // Toggle compare mode with 'C'
        if (e.key.toLowerCase() === 'c' && !e.ctrlKey && !e.metaKey) {
            e.preventDefault();
            toggleCompareMode();
            return;
        }

        // Close details with ESC
        if (e.key === 'Escape') {
            e.preventDefault();
            closeDetails();
            closeComparison();
            if (helpVisible) {
                helpVisible = false;
                document.getElementById('keyboardHelp').classList.remove('active');
            }
            return;
        }

        // Select element with Enter
        if (e.key === 'Enter') {
            e.preventDefault();
            if (focusedElement) {
                if (compareMode) {
                    toggleElementSelection(focusedElement);
                } else {
                    showElementDetails(focusedElement);
                }
            }
            return;
        }

        // Arrow key navigation
        if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
            e.preventDefault();

            const currentElement = elements[keyboardFocusIndex];
            let newPeriod = currentElement.period;
            let newGroup = currentElement.group;

            if (e.key === 'ArrowUp') newPeriod--;
            if (e.key === 'ArrowDown') newPeriod++;
            if (e.key === 'ArrowLeft') newGroup--;
            if (e.key === 'ArrowRight') newGroup++;

            // Find nearest element
            const nearestElement = elements.find(el =>
                el.period === newPeriod && el.group === newGroup
            );

            if (nearestElement) {
                keyboardFocusIndex = elements.indexOf(nearestElement);
                updateKeyboardFocus();
            }
        }
    });
}

function updateKeyboardFocus() {
    document.querySelectorAll('.element').forEach(el => el.classList.remove('keyboard-focus'));

    const focusedElement = elements[keyboardFocusIndex];
    if (focusedElement) {
        const elementDiv = document.querySelector(`[data-number="${focusedElement.number}"]`);
        if (elementDiv) {
            elementDiv.classList.add('keyboard-focus');
            elementDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'nearest' });
        }
    }
}

// Event listeners
document.getElementById('colorMode').addEventListener('change', (e) => {
    currentColorMode = e.target.value;
    const tempControl = document.getElementById('tempControl');

    if (currentColorMode === 'state') {
        tempControl.classList.add('active');
    } else {
        tempControl.classList.remove('active');
    }

    renderPeriodicTable();
});

document.getElementById('tempSlider').addEventListener('input', (e) => {
    currentTemp = parseFloat(e.target.value);
    document.getElementById('tempValue').textContent = currentTemp + '°C';
    renderPeriodicTable();
});

document.getElementById('searchBox').addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase();

    document.querySelectorAll('.element').forEach(el => {
        const number = el.dataset.number;
        if (!number) return;

        const element = elements.find(e => e.number == number);
        if (!element) return;

        const matches = element.name.toLowerCase().includes(query) ||
                       element.symbol.toLowerCase().includes(query) ||
                       element.number.toString().includes(query);

        if (query === '' || matches) {
            el.style.opacity = '1';
            el.style.transform = 'scale(1)';
        } else {
            el.style.opacity = '0.2';
            el.style.transform = 'scale(0.9)';
        }
    });
});

// Initialize
renderPeriodicTable();
initKeyboardNavigation();
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>



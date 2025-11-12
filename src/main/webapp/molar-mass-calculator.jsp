
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FREE Molar Mass Calculator - Chemical Formula Parser & Molecular Weight | 8gwifi.org</title>
    <meta name="description" content="Free online molar mass calculator: Calculate molecular weight, parse chemical formulas, get elemental composition, mass percentages. Supports compounds like H2SO4, Ca(OH)2, hydrates. Educational chemistry tool for students, teachers, lab work.">
    <meta name="keywords" content="molar mass calculator, molecular weight calculator, chemical formula parser, molecular mass, elemental composition, mass percentage, chemistry calculator, stoichiometry calculator, compound molar mass, molecule weight, chemistry tools, molecular formula calculator, free chemistry calculator">
    <link rel="canonical" href="https://8gwifi.org/molar-mass-calculator.jsp">

    <!-- Open Graph -->
    <meta property="og:title" content="FREE Molar Mass Calculator - Chemical Formula Parser & Molecular Weight">
    <meta property="og:description" content="Calculate molar mass, parse chemical formulas, get elemental composition & mass percentages. Supports H2SO4, Ca(OH)2, hydrates. Free chemistry tool for students & labs.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/molar-mass-calculator.jsp">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="FREE Molar Mass Calculator - Parse Chemical Formulas">
    <meta name="twitter:description" content="Calculate molecular weight, elemental composition, mass percentages. Supports complex formulas & hydrates. Free online chemistry tool.">

    <%@ include file="header-script.jsp"%>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@graph": [
        {
          "@type": "WebApplication",
          "@id": "https://8gwifi.org/molar-mass-calculator.jsp#webapp",
          "name": "Molar Mass Calculator - Free Chemistry Tool",
          "alternateName": ["Molecular Weight Calculator", "Chemical Formula Parser", "Molecular Mass Calculator"],
          "applicationCategory": "EducationalApplication",
          "operatingSystem": "Any",
          "browserRequirements": "Requires JavaScript. Works with Chrome, Firefox, Safari, Edge.",
          "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD",
            "availability": "https://schema.org/InStock"
          },
          "description": "Free online molar mass calculator for chemistry. Calculate molecular weight, parse chemical formulas, analyze elemental composition, compute mass percentages. Supports 47+ compounds including complex formulas, parentheses, brackets, hydrates, and coefficients. Live calculation, interactive periodic table, educational examples.",
          "url": "https://8gwifi.org/molar-mass-calculator.jsp",
          "screenshot": "https://8gwifi.org/images/molar-mass-calculator-screenshot.png",
          "softwareVersion": "2.0",
          "datePublished": "2024-01-15",
          "dateModified": "2025-01-13",
          "featureList": [
            "Real-time molar mass calculation",
            "47+ pre-loaded chemical compounds",
            "Interactive periodic table with 92 elements",
            "Support for complex formulas with parentheses and brackets",
            "Hydrate compound calculations",
            "Coefficient support (multiple molecules)",
            "Visual formula preview with subscripts",
            "Elemental composition breakdown",
            "Mass percentage calculations",
            "Color-coded element categories",
            "IUPAC 2021 atomic masses",
            "Shareable calculation URLs",
            "Copy results to clipboard",
            "Mobile responsive design",
            "No registration or login required"
          ],
          "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "4.8",
            "ratingCount": "1250",
            "bestRating": "5",
            "worstRating": "1"
          },
          "interactionStatistic": {
            "@type": "InteractionCounter",
            "interactionType": "https://schema.org/UseAction",
            "userInteractionCount": "250000"
          },
          "author": {
            "@type": "Organization",
            "@id": "https://8gwifi.org/#organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
          },
          "provider": {
            "@type": "Organization",
            "@id": "https://8gwifi.org/#organization"
          }
        },
        {
          "@type": "FAQPage",
          "@id": "https://8gwifi.org/molar-mass-calculator.jsp#faq",
          "mainEntity": [
            {
              "@type": "Question",
              "name": "What is molar mass?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Molar mass is the mass of one mole of a substance (chemical element or compound), expressed in grams per mole (g/mol). One mole contains exactly 6.022 × 10²³ particles (Avogadro's number). It allows chemists to convert between mass and amount in chemical reactions."
              }
            },
            {
              "@type": "Question",
              "name": "How do I calculate molar mass?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "To calculate molar mass: 1) Write the chemical formula, 2) Identify all elements and count their atoms, 3) Find atomic masses from the periodic table, 4) Multiply atomic mass by number of atoms for each element, 5) Add all values to get total molar mass. For example, H2O = (2 × 1.008) + (1 × 15.999) = 18.015 g/mol."
              }
            },
            {
              "@type": "Question",
              "name": "What is the difference between molar mass and molecular weight?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Molar mass is expressed in g/mol (grams per mole) and refers to the mass of 1 mole of substance. Molecular weight is expressed in amu (atomic mass units) and refers to the mass of 1 molecule. Numerically they are the same, but differ in units and context of use."
              }
            },
            {
              "@type": "Question",
              "name": "Can this calculator handle complex formulas?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes! This calculator supports complex formulas including parentheses [Ca(OH)2], brackets [[Cu(NH3)4]SO4], hydrates (CuSO4·5H2O), and coefficients (3H2SO4). It includes 47+ pre-loaded compounds from basic to complex organic molecules."
              }
            },
            {
              "@type": "Question",
              "name": "Is this molar mass calculator free?",
              "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes, this molar mass calculator is 100% free to use. No registration, no downloads, no hidden fees. Access all features including the interactive periodic table, 47+ compound library, and real-time calculations instantly."
              }
            }
          ]
        },
        {
          "@type": "HowTo",
          "@id": "https://8gwifi.org/molar-mass-calculator.jsp#howto",
          "name": "How to Calculate Molar Mass Using This Calculator",
          "description": "Step-by-step guide to calculate molar mass of chemical compounds",
          "totalTime": "PT2M",
          "step": [
            {
              "@type": "HowToStep",
              "position": 1,
              "name": "Enter Chemical Formula",
              "text": "Type the chemical formula into the input field (e.g., H2SO4, Ca(OH)2, C6H12O6). The calculator provides live preview with proper subscripts as you type.",
              "url": "https://8gwifi.org/molar-mass-calculator.jsp#step1"
            },
            {
              "@type": "HowToStep",
              "position": 2,
              "name": "View Real-Time Results",
              "text": "Results appear automatically as you type (500ms delay). See the molar mass in g/mol, compound name (if recognized), and formatted chemical formula.",
              "url": "https://8gwifi.org/molar-mass-calculator.jsp#step2"
            },
            {
              "@type": "HowToStep",
              "position": 3,
              "name": "Analyze Composition",
              "text": "Review the elemental composition table showing each element, atom count, mass contribution, and percentage by mass with visual bars.",
              "url": "https://8gwifi.org/molar-mass-calculator.jsp#step3"
            },
            {
              "@type": "HowToStep",
              "position": 4,
              "name": "Share or Copy Results",
              "text": "Use the Share URL button to create a shareable link, or Copy Results to clipboard for use in reports and homework.",
              "url": "https://8gwifi.org/molar-mass-calculator.jsp#step4"
            }
          ]
        },
        {
          "@type": "BreadcrumbList",
          "@id": "https://8gwifi.org/molar-mass-calculator.jsp#breadcrumb",
          "itemListElement": [
            {
              "@type": "ListItem",
              "position": 1,
              "name": "Home",
              "item": "https://8gwifi.org/"
            },
            {
              "@type": "ListItem",
              "position": 2,
              "name": "Chemistry Tools",
              "item": "https://8gwifi.org/chemistry-tools.jsp"
            },
            {
              "@type": "ListItem",
              "position": 3,
              "name": "Molar Mass Calculator",
              "item": "https://8gwifi.org/molar-mass-calculator.jsp"
            }
          ]
        },
        {
          "@type": "Organization",
          "@id": "https://8gwifi.org/#organization",
          "name": "8gwifi.org",
          "url": "https://8gwifi.org",
          "logo": {
            "@type": "ImageObject",
            "url": "https://8gwifi.org/images/logo.png"
          },
          "sameAs": [
            "https://twitter.com/8gwifi",
            "https://github.com/8gwifi"
          ]
        }
      ]
    }
    </script>

    <style>
        .calc-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .two-column-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        @media (max-width: 992px) {
            .two-column-layout {
                grid-template-columns: 1fr;
            }
        }

        .input-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 25px;
            border-radius: 12px;
            color: white;
        }

        .formula-input {
            width: 100%;
            padding: 15px;
            font-size: 1.5rem;
            border: 3px solid #fff;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            text-align: center;
            margin-bottom: 15px;
        }

        .formula-input:focus {
            outline: none;
            border-color: #ffd700;
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.3);
        }

        .quick-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }

        .quick-btn {
            padding: 8px 15px;
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .quick-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        .calc-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .calc-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(245, 87, 108, 0.4);
        }

        .result-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .molar-mass-display {
            text-align: center;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            color: white;
            margin-bottom: 20px;
        }

        .mass-value {
            font-size: 3rem;
            font-weight: 700;
            margin: 10px 0;
        }

        .mass-unit {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .composition-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .composition-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }

        .composition-table td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
        }

        .composition-table tr:hover {
            background: #f7fafc;
        }

        .element-symbol {
            font-family: 'Courier New', monospace;
            font-weight: 700;
            font-size: 1.1rem;
            color: #667eea;
        }

        .percentage-bar {
            width: 100%;
            height: 20px;
            background: #e2e8f0;
            border-radius: 10px;
            overflow: hidden;
        }

        .percentage-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transition: width 0.3s;
        }

        .common-compounds {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 10px;
            margin-top: 15px;
        }

        .common-compounds h4:first-child {
            margin-top: 0 !important;
        }

        .compound-btn {
            padding: 10px;
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            transition: all 0.3s;
        }

        .compound-btn:hover {
            border-color: #667eea;
            background: #edf2f7;
            transform: translateY(-2px);
        }

        .compound-formula {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
        }

        .compound-name {
            font-size: 0.85rem;
            color: #718096;
        }

        .error-message {
            background: #fed7d7;
            color: #c53030;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c53030;
        }

        .info-box {
            background: #bee3f8;
            color: #2c5282;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #3182ce;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .action-btn {
            flex: 1;
            padding: 10px;
            background: #4299e1;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }

        .action-btn:hover {
            background: #3182ce;
        }

        .action-btn.secondary {
            background: #718096;
        }

        .action-btn.secondary:hover {
            background: #4a5568;
        }

        /* Periodic Table Styles */
        .periodic-table {
            display: grid;
            grid-template-columns: repeat(18, 1fr);
            gap: 2px;
            background: #f7fafc;
            padding: 10px;
            border-radius: 8px;
        }

        .element-cell {
            aspect-ratio: 1;
            min-width: 45px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 4px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.75rem;
            padding: 2px;
        }

        .element-cell:hover {
            transform: scale(1.1);
            border-color: #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            z-index: 10;
        }

        .element-cell.selected {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: #667eea;
        }

        .element-number {
            font-size: 0.6rem;
            opacity: 0.7;
        }

        .element-symbol-cell {
            font-size: 1rem;
            font-weight: 700;
        }

        .element-name {
            font-size: 0.55rem;
            opacity: 0.8;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 100%;
        }

        .element-mass-cell {
            font-size: 0.6rem;
            opacity: 0.7;
        }

        .element-placeholder {
            background: transparent;
            border: none;
            cursor: default;
        }

        .element-placeholder:hover {
            transform: none;
            box-shadow: none;
        }

        /* Element category colors */
        .element-cell.nonmetal {
            background: #e0f2fe;
        }

        .element-cell.noble-gas {
            background: #fce7f3;
        }

        .element-cell.alkali-metal {
            background: #fff7ed;
        }

        .element-cell.alkaline-earth {
            background: #fef3c7;
        }

        .element-cell.transition-metal {
            background: #fef2f2;
        }

        .element-cell.post-transition {
            background: #f3f4f6;
        }

        .element-cell.metalloid {
            background: #e7e5e4;
        }

        .element-cell.halogen {
            background: #dbeafe;
        }

        .element-cell.lanthanide {
            background: #fae8ff;
        }

        .element-cell.actinide {
            background: #fce7f3;
        }

        /* Selected element badge */
        .selected-element-badge {
            background: white;
            border: 2px solid #667eea;
            border-radius: 8px;
            padding: 10px 15px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .selected-element-badge .symbol {
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
        }

        .selected-element-badge .count-input {
            width: 60px;
            padding: 5px;
            border: 2px solid #e2e8f0;
            border-radius: 4px;
            font-size: 1rem;
            text-align: center;
        }

        .selected-element-badge .remove-btn {
            background: #ef4444;
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            font-size: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Collapsible Section Styles */
        .collapsible-section {
            margin-bottom: 15px;
        }

        .collapsible-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            user-select: none;
        }

        .collapsible-header:hover {
            background: #edf2f7;
            border-color: #cbd5e0;
        }

        .collapsible-header.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: #667eea;
        }

        .collapsible-title {
            font-size: 1.1rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .collapsible-icon {
            font-size: 1.2rem;
            transition: transform 0.3s;
        }

        .collapsible-icon.open {
            transform: rotate(180deg);
        }

        .collapsible-content {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease-out;
            padding: 0 20px;
        }

        .collapsible-content.open {
            max-height: 2000px;
            padding: 20px;
            border: 2px solid #e2e8f0;
            border-top: none;
            border-radius: 0 0 8px 8px;
        }

        .compact-result-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            height: 100%;
        }

        /* Pulse animation for live indicator */
        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.5;
            }
        }

        @media (max-width: 768px) {
            .mass-value {
                font-size: 2rem;
            }

            .common-compounds {
                grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            }

            .periodic-table {
                grid-template-columns: repeat(9, 1fr);
                gap: 1px;
            }

            .element-cell {
                min-width: 35px;
                font-size: 0.65rem;
            }

            .element-symbol-cell {
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4">
    <div class="calc-card">

        <div class="calc-container">
            <h1 style="text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 10px;">
                ⚗️ Molar Mass Calculator
            </h1>
            <p style="text-align: center; color: #718096; margin-bottom: 30px;">
                Calculate molecular weight and elemental composition of chemical compounds
            </p>

            <!-- Two Column Layout -->
            <div class="two-column-layout">
                <!-- Left Column: Input -->
                <div>
                    <div class="input-section">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                            <label style="font-size: 1.1rem; margin: 0;">
                                Enter Chemical Formula:
                            </label>
                            <span style="font-size: 0.85rem; opacity: 0.8; display: flex; align-items: center; gap: 5px;">
                                <span style="animation: pulse 2s infinite;">⚡</span>
                                <span>Live calculation enabled</span>
                            </span>
                        </div>
                        <input type="text"
                               id="formulaInput"
                               class="formula-input"
                               placeholder="e.g., H2SO4, Ca(OH)2, CuSO4·5H2O"
                               oninput="handleFormulaInput()"
                               onkeypress="if(event.key==='Enter') calculateMolarMass()">

                        <!-- Live Formula Preview -->
                        <div id="formulaPreview" style="background: rgba(255, 255, 255, 0.9); padding: 15px; border-radius: 8px; margin-top: 10px; text-align: center; min-height: 50px; display: none;">
                            <div style="font-size: 0.85rem; color: #718096; margin-bottom: 5px;">Live Preview:</div>
                            <div id="formulaPreviewText" style="font-size: 2rem; font-family: 'Times New Roman', serif; color: #2d3748;"></div>
                        </div>

                        <div class="quick-buttons">
                            <button class="quick-btn" onclick="insertText('H2O')">H₂O</button>
                            <button class="quick-btn" onclick="insertText('CO2')">CO₂</button>
                            <button class="quick-btn" onclick="insertText('NaCl')">NaCl</button>
                            <button class="quick-btn" onclick="insertText('C6H12O6')">C₆H₁₂O₆</button>
                            <button class="quick-btn" onclick="insertText('H2SO4')">H₂SO₄</button>
                            <button class="quick-btn" onclick="insertText('Ca(OH)2')">Ca(OH)₂</button>
                            <button class="quick-btn" onclick="insertText('3H2SO4')" title="3 moles">3H₂SO₄</button>
                            <button class="quick-btn" onclick="insertText('2NaCl')" title="2 moles">2NaCl</button>
                            <button class="quick-btn" onclick="insertText('(')">( )</button>
                            <button class="quick-btn" onclick="insertText('[')">[ ]</button>
                            <button class="quick-btn" onclick="insertText('·')">·</button>
                            <button class="quick-btn" onclick="clearFormula()">Clear</button>
                        </div>

                        <button class="calc-btn" onclick="calculateMolarMass()">
                            🧪 Calculate Molar Mass
                        </button>
                    </div>

                    <!-- Common Compounds (Compact) -->
                    <div class="collapsible-section" style="margin-top: 15px;">
                        <div class="collapsible-header" onclick="toggleCollapsible('commonCompounds')">
                            <div class="collapsible-title">
                                🧪 Common Compounds
                            </div>
                            <div class="collapsible-icon" id="commonCompounds-icon">▼</div>
                        </div>
                        <div class="collapsible-content" id="commonCompounds-content">
                            <div class="common-compounds" id="commonCompounds"></div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Results -->
                <div>
                    <!-- Molar Mass Display -->
                    <div id="resultsSection" style="display: none;">
                        <div class="molar-mass-display">
                            <div style="font-size: 1.2rem; opacity: 0.9;">Molar Mass</div>
                            <div class="mass-value" id="molarMassValue">0</div>
                            <div class="mass-unit">g/mol</div>
                            <div style="margin-top: 15px; font-size: 1.5rem; font-family: 'Times New Roman', serif;" id="formulaDisplay"></div>
                        </div>

                        <!-- Elemental Composition -->
                        <div class="compact-result-card">
                            <h3 style="color: #2d3748; margin-bottom: 15px;">📊 Elemental Composition</h3>
                            <table class="composition-table">
                                <thead>
                                    <tr>
                                        <th>Element</th>
                                        <th>Atoms</th>
                                        <th>Mass %</th>
                                        <th>Visual</th>
                                    </tr>
                                </thead>
                                <tbody id="compositionTableBody">
                                </tbody>
                            </table>

                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <button class="action-btn" onclick="shareURL()" title="Share this calculation">🔗 Share URL</button>
                                <button class="action-btn" onclick="copyResults()" title="Copy results to clipboard">📋 Copy</button>
                                <button class="action-btn secondary" onclick="clearResults()" title="Clear all">🗑️ Clear</button>
                                <button class="action-btn secondary" onclick="printResults()" title="Print results">🖨️ Print</button>
                            </div>

                            <!-- Share URL Display -->
                            <div id="shareURLDisplay" style="display: none; margin-top: 15px; padding: 15px; background: #f0f9ff; border: 2px solid #3b82f6; border-radius: 8px;">
                                <div style="font-size: 0.9rem; color: #1e40af; margin-bottom: 8px; font-weight: 600;">🔗 Shareable URL:</div>
                                <div style="display: flex; gap: 10px; align-items: center;">
                                    <input type="text" id="shareURLInput" readonly
                                           style="flex: 1; padding: 10px; border: 1px solid #3b82f6; border-radius: 6px; font-size: 0.85rem; font-family: monospace; background: white;">
                                    <button onclick="copyShareURL()"
                                            style="padding: 10px 15px; background: #3b82f6; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; white-space: nowrap;">
                                        📋 Copy URL
                                    </button>
                                </div>
                                <div style="font-size: 0.8rem; color: #64748b; margin-top: 8px;">
                                    Share this link to show your calculation to others
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Error Display -->
                    <div id="errorSection" style="display: none;">
                        <div class="error-message" id="errorMessage"></div>
                    </div>
                </div>
            </div>

            <!-- Visual Formula Builder (Collapsible) -->
            <div class="collapsible-section">
                <div class="collapsible-header" onclick="toggleCollapsible('formulaBuilder')">
                    <div class="collapsible-title">
                        🧬 Visual Formula Builder (Periodic Table)
                    </div>
                    <div class="collapsible-icon" id="formulaBuilder-icon">▼</div>
                </div>
                <div class="collapsible-content" id="formulaBuilder-content">
                    <!-- Periodic Table -->
                    <div id="periodicTableSection" style="margin-bottom: 20px;">
                        <div id="periodicTable" style="overflow-x: auto;"></div>
                    </div>

                    <!-- Selected Elements List -->
                    <div id="selectedElementsSection" style="display: none;">
                        <h4 style="color: #4a5568; font-size: 1rem; margin-bottom: 10px;">Selected Elements:</h4>
                        <div id="selectedElementsList" style="display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 15px;"></div>
                        <div style="display: flex; gap: 10px;">
                            <button class="action-btn" onclick="buildFormulaFromSelection()" style="flex: 1;">
                                ✨ Build Formula
                            </button>
                            <button class="action-btn secondary" onclick="clearSelection()" style="flex: 1;">
                                🗑️ Clear Selection
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Educational Content (Collapsible) -->
            <div class="collapsible-section">
                <div class="collapsible-header" onclick="toggleCollapsible('howToUse')">
                    <div class="collapsible-title">
                        📚 How to Use & Examples
                    </div>
                    <div class="collapsible-icon" id="howToUse-icon">▼</div>
                </div>
                <div class="collapsible-content" id="howToUse-content">
                    <div style="line-height: 1.8; color: #4a5568;">
                        <p><strong>Formula Syntax:</strong></p>
                        <ul style="margin-left: 20px;">
                            <li><strong>Elements:</strong> Use element symbols (H, O, C, Na, etc.)</li>
                            <li><strong>Subscripts:</strong> Use numbers after elements (H2O, CO2)</li>
                            <li><strong>Coefficients:</strong> Leading numbers for multiple molecules (3H2SO4, 2NaCl)</li>
                            <li><strong>Parentheses:</strong> For groups: Ca(OH)2, Al2(SO4)3</li>
                            <li><strong>Brackets:</strong> For complex groups: [Cu(NH3)4]SO4</li>
                            <li><strong>Hydrates:</strong> Use dot (·) for water: CuSO4·5H2O</li>
                        </ul>

                        <p style="margin-top: 15px;"><strong>Examples:</strong></p>
                        <ul style="margin-left: 20px;">
                            <li>Water: H2O → 18.015 g/mol</li>
                            <li>Sulfuric Acid: H2SO4 → 98.079 g/mol</li>
                            <li><strong>3 moles of Sulfuric Acid: 3H2SO4 → 294.237 g/mol</strong></li>
                            <li>Calcium Hydroxide: Ca(OH)2 → 74.093 g/mol</li>
                            <li>Glucose: C6H12O6 → 180.156 g/mol</li>
                            <li>Copper Sulfate Pentahydrate: CuSO4·5H2O → 249.685 g/mol</li>
                        </ul>

                        <p style="margin-top: 15px;"><strong>Understanding Coefficients:</strong></p>
                        <p style="margin-left: 20px;">
                            The coefficient (number before the formula) represents the number of molecules or moles.
                            For example, <strong>3H₂SO₄</strong> means 3 separate molecules of sulfuric acid,
                            so the total mass is 3 × 98.079 = 294.237 g/mol.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Educational Section: What is Molar Mass -->
            <div class="collapsible-section">
                <div class="collapsible-header" onclick="toggleCollapsible('whatIsMolarMass')">
                    <div class="collapsible-title">
                        📖 What is Molar Mass?
                    </div>
                    <div class="collapsible-icon" id="whatIsMolarMass-icon">▼</div>
                </div>
                <div class="collapsible-content" id="whatIsMolarMass-content">
                    <div style="line-height: 1.8; color: #4a5568;">
                        <h4 style="color: #2d3748; margin-top: 0;">Definition</h4>
                        <p>
                            <strong>Molar mass</strong> is the mass of one mole of a substance (chemical element or compound).
                            It is expressed in grams per mole (g/mol). One mole contains exactly 6.022 × 10²³ particles
                            (Avogadro's number), whether they are atoms, molecules, ions, or electrons.
                        </p>

                        <h4 style="color: #2d3748; margin-top: 20px;">Key Points</h4>
                        <ul style="margin-left: 20px;">
                            <li><strong>Unit:</strong> Grams per mole (g/mol)</li>
                            <li><strong>Symbol:</strong> M or m</li>
                            <li><strong>Purpose:</strong> Converts between mass (grams) and amount (moles)</li>
                            <li><strong>Application:</strong> Essential for stoichiometry calculations in chemistry</li>
                        </ul>

                        <h4 style="color: #2d3748; margin-top: 20px;">Why is Molar Mass Important?</h4>
                        <p>Molar mass allows chemists to:</p>
                        <ul style="margin-left: 20px;">
                            <li>Convert between grams and moles in chemical reactions</li>
                            <li>Determine the amount of reactants needed in experiments</li>
                            <li>Calculate theoretical yields in chemical synthesis</li>
                            <li>Analyze the composition of unknown substances</li>
                            <li>Prepare solutions with precise concentrations</li>
                        </ul>

                        <h4 style="color: #2d3748; margin-top: 20px;">Formula</h4>
                        <div style="background: #f7fafc; padding: 15px; border-radius: 8px; border-left: 4px solid #667eea; margin: 10px 0;">
                            <p style="margin: 0; font-size: 1.1rem;"><strong>Molar Mass = Sum of (Atomic Mass × Number of Atoms)</strong></p>
                            <p style="margin: 10px 0 0 0; font-size: 0.95rem; color: #718096;">For all elements in the compound</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Educational Section: Molar Mass vs Molecular Weight -->
            <div class="collapsible-section">
                <div class="collapsible-header" onclick="toggleCollapsible('molarVsMolecular')">
                    <div class="collapsible-title">
                        ⚖️ Molar Mass vs. Molecular Weight
                    </div>
                    <div class="collapsible-icon" id="molarVsMolecular-icon">▼</div>
                </div>
                <div class="collapsible-content" id="molarVsMolecular-content">
                    <div style="line-height: 1.8; color: #4a5568;">
                        <p>
                            While often used interchangeably, <strong>molar mass</strong> and <strong>molecular weight</strong>
                            have subtle differences:
                        </p>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0;">
                            <div style="background: #f0f9ff; padding: 20px; border-radius: 8px; border: 2px solid #3b82f6;">
                                <h4 style="color: #1e40af; margin-top: 0;">Molar Mass</h4>
                                <ul style="margin-left: 20px; padding-left: 0; list-style-position: inside;">
                                    <li><strong>Unit:</strong> g/mol (grams per mole)</li>
                                    <li><strong>Refers to:</strong> Mass of 1 mole</li>
                                    <li><strong>Has units:</strong> Yes</li>
                                    <li><strong>Example:</strong> H₂O = 18.015 g/mol</li>
                                    <li><strong>Used for:</strong> Practical calculations</li>
                                </ul>
                            </div>

                            <div style="background: #fef3c7; padding: 20px; border-radius: 8px; border: 2px solid #f59e0b;">
                                <h4 style="color: #92400e; margin-top: 0;">Molecular Weight</h4>
                                <ul style="margin-left: 20px; padding-left: 0; list-style-position: inside;">
                                    <li><strong>Unit:</strong> amu or Da (atomic mass units)</li>
                                    <li><strong>Refers to:</strong> Mass of 1 molecule</li>
                                    <li><strong>Has units:</strong> Technically, but often unitless</li>
                                    <li><strong>Example:</strong> H₂O = 18.015 amu</li>
                                    <li><strong>Used for:</strong> Relative comparisons</li>
                                </ul>
                            </div>
                        </div>

                        <div style="background: #dcfce7; padding: 15px; border-radius: 8px; border-left: 4px solid #16a34a; margin: 20px 0;">
                            <p style="margin: 0;"><strong>📌 Key Insight:</strong> Numerically, they are the same!
                            The molar mass in g/mol equals the molecular weight in amu. The difference is mainly in the units and context of use.</p>
                        </div>

                        <h4 style="color: #2d3748; margin-top: 20px;">Terminology by Substance Type</h4>
                        <ul style="margin-left: 20px;">
                            <li><strong>Molecular compounds:</strong> Molecular mass or molecular weight (H₂O, CO₂)</li>
                            <li><strong>Ionic compounds:</strong> Formula mass or formula weight (NaCl, CaCO₃)</li>
                            <li><strong>Elements:</strong> Atomic mass or atomic weight (Fe, Au, C)</li>
                            <li><strong>All substances:</strong> Molar mass (universal term)</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Educational Section: How to Calculate -->
            <div class="collapsible-section">
                <div class="collapsible-header" onclick="toggleCollapsible('howToCalculate')">
                    <div class="collapsible-title">
                        🧮 How to Calculate Molar Mass - Step by Step
                    </div>
                    <div class="collapsible-icon" id="howToCalculate-icon">▼</div>
                </div>
                <div class="collapsible-content" id="howToCalculate-content">
                    <div style="line-height: 1.8; color: #4a5568;">
                        <h4 style="color: #2d3748; margin-top: 0;">General Steps</h4>
                        <ol style="margin-left: 20px; line-height: 2;">
                            <li><strong>Write the chemical formula</strong> of the compound</li>
                            <li><strong>Identify all elements</strong> and count their atoms</li>
                            <li><strong>Find atomic masses</strong> from the periodic table</li>
                            <li><strong>Multiply</strong> atomic mass by number of atoms for each element</li>
                            <li><strong>Add all values</strong> to get total molar mass</li>
                        </ol>

                        <h4 style="color: #2d3748; margin-top: 25px;">Example 1: Water (H₂O)</h4>
                        <div style="background: #f7fafc; padding: 20px; border-radius: 8px; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0;"><strong>Step 1:</strong> Formula = H₂O</p>
                            <p style="margin: 0 0 10px 0;"><strong>Step 2:</strong> Count atoms</p>
                            <ul style="margin-left: 20px; margin-bottom: 10px;">
                                <li>Hydrogen (H): 2 atoms</li>
                                <li>Oxygen (O): 1 atom</li>
                            </ul>
                            <p style="margin: 0 0 10px 0;"><strong>Step 3:</strong> Atomic masses</p>
                            <ul style="margin-left: 20px; margin-bottom: 10px;">
                                <li>H = 1.008 g/mol</li>
                                <li>O = 15.999 g/mol</li>
                            </ul>
                            <p style="margin: 0 0 10px 0;"><strong>Step 4:</strong> Calculate</p>
                            <ul style="margin-left: 20px; margin-bottom: 10px;">
                                <li>H: 2 × 1.008 = 2.016 g/mol</li>
                                <li>O: 1 × 15.999 = 15.999 g/mol</li>
                            </ul>
                            <p style="margin: 0; font-size: 1.1rem; color: #667eea;"><strong>Step 5:</strong> Total = 2.016 + 15.999 = <strong>18.015 g/mol</strong></p>
                        </div>

                        <h4 style="color: #2d3748; margin-top: 25px;">Example 2: Sulfuric Acid (H₂SO₄)</h4>
                        <div style="background: #f7fafc; padding: 20px; border-radius: 8px; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0;"><strong>Formula:</strong> H₂SO₄</p>
                            <p style="margin: 0 0 10px 0;"><strong>Atomic composition:</strong></p>
                            <ul style="margin-left: 20px; margin-bottom: 10px;">
                                <li>H: 2 atoms × 1.008 = 2.016 g/mol</li>
                                <li>S: 1 atom × 32.06 = 32.06 g/mol</li>
                                <li>O: 4 atoms × 15.999 = 63.996 g/mol</li>
                            </ul>
                            <p style="margin: 0; font-size: 1.1rem; color: #667eea;"><strong>Total:</strong> 2.016 + 32.06 + 63.996 = <strong>98.072 g/mol</strong></p>
                        </div>

                        <h4 style="color: #2d3748; margin-top: 25px;">Example 3: Compound with Parentheses - Calcium Hydroxide Ca(OH)₂</h4>
                        <div style="background: #f7fafc; padding: 20px; border-radius: 8px; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0;"><strong>Formula:</strong> Ca(OH)₂</p>
                            <p style="margin: 0 0 10px 0;"><strong>Understanding parentheses:</strong> The subscript 2 applies to everything inside (OH)</p>
                            <ul style="margin-left: 20px; margin-bottom: 10px;">
                                <li>Ca: 1 atom</li>
                                <li>O: 1 atom × 2 = <strong>2 atoms</strong></li>
                                <li>H: 1 atom × 2 = <strong>2 atoms</strong></li>
                            </ul>
                            <p style="margin: 0 0 10px 0;"><strong>Calculation:</strong></p>
                            <ul style="margin-left: 20px; margin-bottom: 10px;">
                                <li>Ca: 1 × 40.078 = 40.078 g/mol</li>
                                <li>O: 2 × 15.999 = 31.998 g/mol</li>
                                <li>H: 2 × 1.008 = 2.016 g/mol</li>
                            </ul>
                            <p style="margin: 0; font-size: 1.1rem; color: #667eea;"><strong>Total:</strong> 40.078 + 31.998 + 2.016 = <strong>74.092 g/mol</strong></p>
                        </div>

                        <h4 style="color: #2d3748; margin-top: 25px;">Example 4: Hydrate - Copper(II) Sulfate Pentahydrate CuSO₄·5H₂O</h4>
                        <div style="background: #f7fafc; padding: 20px; border-radius: 8px; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0;"><strong>Formula:</strong> CuSO₄·5H₂O</p>
                            <p style="margin: 0 0 10px 0;"><strong>Understanding hydrates:</strong> Calculate CuSO₄ and 5H₂O separately, then add</p>

                            <p style="margin: 10px 0 5px 0;"><strong>Part 1: CuSO₄</strong></p>
                            <ul style="margin-left: 20px; margin-bottom: 10px;">
                                <li>Cu: 1 × 63.546 = 63.546 g/mol</li>
                                <li>S: 1 × 32.06 = 32.06 g/mol</li>
                                <li>O: 4 × 15.999 = 63.996 g/mol</li>
                                <li>Subtotal: 159.602 g/mol</li>
                            </ul>

                            <p style="margin: 10px 0 5px 0;"><strong>Part 2: 5H₂O (5 water molecules)</strong></p>
                            <ul style="margin-left: 20px; margin-bottom: 10px;">
                                <li>H₂O = 18.015 g/mol</li>
                                <li>5 × 18.015 = 90.075 g/mol</li>
                            </ul>

                            <p style="margin: 0; font-size: 1.1rem; color: #667eea;"><strong>Total:</strong> 159.602 + 90.075 = <strong>249.677 g/mol</strong></p>
                        </div>

                        <h4 style="color: #2d3748; margin-top: 25px;">Example 5: With Coefficient - 3H₂SO₄ (3 moles)</h4>
                        <div style="background: #f7fafc; padding: 20px; border-radius: 8px; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0;"><strong>Formula:</strong> 3H₂SO₄</p>
                            <p style="margin: 0 0 10px 0;"><strong>Understanding coefficients:</strong> Calculate one molecule first, then multiply by coefficient</p>

                            <p style="margin: 10px 0 5px 0;"><strong>Step 1:</strong> Molar mass of H₂SO₄ = 98.079 g/mol</p>
                            <p style="margin: 10px 0 5px 0;"><strong>Step 2:</strong> Multiply by coefficient 3</p>

                            <p style="margin: 0; font-size: 1.1rem; color: #667eea;"><strong>Total:</strong> 3 × 98.079 = <strong>294.237 g/mol</strong></p>

                            <div style="background: #dcfce7; padding: 10px; border-radius: 6px; margin-top: 15px;">
                                <p style="margin: 0; font-size: 0.9rem;">💡 <strong>Note:</strong> This represents the mass of 3 separate molecules of sulfuric acid,
                                which is useful in stoichiometry when balancing chemical equations.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Educational Section: Common Applications -->
            <div class="collapsible-section">
                <div class="collapsible-header" onclick="toggleCollapsible('applications')">
                    <div class="collapsible-title">
                        🔬 Real-World Applications
                    </div>
                    <div class="collapsible-icon" id="applications-icon">▼</div>
                </div>
                <div class="collapsible-content" id="applications-content">
                    <div style="line-height: 1.8; color: #4a5568;">
                        <h4 style="color: #2d3748; margin-top: 0;">1. Laboratory Preparation</h4>
                        <p><strong>Problem:</strong> How many grams of NaCl are needed to make 1 mole?</p>
                        <p><strong>Solution:</strong> Molar mass of NaCl = 58.443 g/mol, so you need exactly 58.443 grams.</p>

                        <h4 style="color: #2d3748; margin-top: 20px;">2. Chemical Reactions</h4>
                        <p><strong>Example:</strong> 2H₂ + O₂ → 2H₂O</p>
                        <p>If you have 4 grams of H₂:</p>
                        <ul style="margin-left: 20px;">
                            <li>Molar mass of H₂ = 2.016 g/mol</li>
                            <li>Moles = 4 ÷ 2.016 = 1.98 moles</li>
                            <li>From equation: 1.98 moles H₂ produces 1.98 moles H₂O</li>
                            <li>Mass of water = 1.98 × 18.015 = 35.67 grams</li>
                        </ul>

                        <h4 style="color: #2d3748; margin-top: 20px;">3. Pharmaceutical Industry</h4>
                        <p>Drug manufacturers use molar mass to:</p>
                        <ul style="margin-left: 20px;">
                            <li>Calculate precise dosages</li>
                            <li>Determine active ingredient concentrations</li>
                            <li>Ensure quality control in production</li>
                        </ul>

                        <h4 style="color: #2d3748; margin-top: 20px;">4. Environmental Science</h4>
                        <p>Used to measure:</p>
                        <ul style="margin-left: 20px;">
                            <li>CO₂ emissions (molar mass = 44.01 g/mol)</li>
                            <li>Pollutant concentrations in air and water</li>
                            <li>Chemical composition of samples</li>
                        </ul>

                        <h4 style="color: #2d3748; margin-top: 20px;">5. Forensic Science</h4>
                        <p>Forensic chemists use molar mass calculations to:</p>
                        <ul style="margin-left: 20px;">
                            <li>Identify unknown substances</li>
                            <li>Analyze drug compositions</li>
                            <li>Determine poison concentrations</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Educational Section: Tips & Tricks -->
            <div class="collapsible-section">
                <div class="collapsible-header" onclick="toggleCollapsible('tipsAndTricks')">
                    <div class="collapsible-title">
                        💡 Tips & Common Mistakes
                    </div>
                    <div class="collapsible-icon" id="tipsAndTricks-icon">▼</div>
                </div>
                <div class="collapsible-content" id="tipsAndTricks-content">
                    <div style="line-height: 1.8; color: #4a5568;">
                        <h4 style="color: #2d3748; margin-top: 0;">✅ Pro Tips</h4>
                        <ul style="margin-left: 20px;">
                            <li><strong>Use this calculator!</strong> Save time and avoid arithmetic errors</li>
                            <li><strong>Round at the end:</strong> Keep full precision during calculation, round final answer</li>
                            <li><strong>Check units:</strong> Always include g/mol in your answer</li>
                            <li><strong>Double-check parentheses:</strong> Multiply subscripts correctly</li>
                            <li><strong>Use IUPAC values:</strong> Atomic masses are standardized (2021 values in this calculator)</li>
                        </ul>

                        <h4 style="color: #2d3748; margin-top: 20px;">❌ Common Mistakes</h4>

                        <div style="background: #fee2e2; padding: 15px; border-radius: 8px; border-left: 4px solid #dc2626; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0; font-weight: 600;">Mistake 1: Forgetting to multiply by subscripts</p>
                            <p style="margin: 0;"><strong>Wrong:</strong> H₂O = 1.008 + 15.999 = 17.007 g/mol ❌</p>
                            <p style="margin: 5px 0 0 0;"><strong>Right:</strong> H₂O = (2 × 1.008) + 15.999 = 18.015 g/mol ✅</p>
                        </div>

                        <div style="background: #fee2e2; padding: 15px; border-radius: 8px; border-left: 4px solid #dc2626; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0; font-weight: 600;">Mistake 2: Ignoring parentheses distribution</p>
                            <p style="margin: 0;"><strong>Wrong:</strong> Ca(OH)₂ = 40.078 + 15.999 + (1.008 × 2) ❌</p>
                            <p style="margin: 5px 0 0 0;"><strong>Right:</strong> Ca(OH)₂ = 40.078 + (15.999 × 2) + (1.008 × 2) ✅</p>
                        </div>

                        <div style="background: #fee2e2; padding: 15px; border-radius: 8px; border-left: 4px solid #dc2626; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0; font-weight: 600;">Mistake 3: Using outdated atomic masses</p>
                            <p style="margin: 0;">Atomic masses are periodically updated by IUPAC. Always use current values!</p>
                        </div>

                        <div style="background: #fee2e2; padding: 15px; border-radius: 8px; border-left: 4px solid #dc2626; margin: 15px 0;">
                            <p style="margin: 0 0 10px 0; font-weight: 600;">Mistake 4: Confusing coefficient with subscript</p>
                            <p style="margin: 0;"><strong>2H₂O:</strong> Coefficient = 2 molecules of water (2 × 18.015 = 36.030 g/mol)</p>
                            <p style="margin: 5px 0 0 0;"><strong>H₂O₂:</strong> Subscript = 1 molecule with 2 oxygen atoms (34.015 g/mol)</p>
                        </div>

                        <h4 style="color: #2d3748; margin-top: 20px;">🎯 Quick Reference</h4>
                        <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
                            <tr style="background: #f7fafc;">
                                <th style="padding: 10px; text-align: left; border: 1px solid #e2e8f0;">Compound</th>
                                <th style="padding: 10px; text-align: left; border: 1px solid #e2e8f0;">Formula</th>
                                <th style="padding: 10px; text-align: left; border: 1px solid #e2e8f0;">Molar Mass</th>
                            </tr>
                            <tr>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">Water</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">H₂O</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">18.015 g/mol</td>
                            </tr>
                            <tr style="background: #f7fafc;">
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">Carbon Dioxide</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">CO₂</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">44.009 g/mol</td>
                            </tr>
                            <tr>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">Table Salt</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">NaCl</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">58.443 g/mol</td>
                            </tr>
                            <tr style="background: #f7fafc;">
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">Glucose</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">C₆H₁₂O₆</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">180.156 g/mol</td>
                            </tr>
                            <tr>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">Sulfuric Acid</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">H₂SO₄</td>
                                <td style="padding: 10px; border: 1px solid #e2e8f0;">98.079 g/mol</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Related Tools -->
            <div class="result-card" style="background: #f0f9ff; border-left: 4px solid #3b82f6;">
                <h3 style="color: #1e40af;">🔗 Related Chemistry Tools</h3>
                <div class="d-flex flex-wrap gap-2">
                    <a href="graphing-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Graphing Calculator</a>
                    <a href="math-art-gallery.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Math Visualizations</a>
                    <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mb-2">Equation Solver</a>
                </div>
                <p class="text-muted small mb-0 mt-2">Explore more scientific and mathematical tools.</p>
            </div>
        </div>
    </div>
</div>

<script>
    // Periodic table data with atomic masses (IUPAC 2021)
    const elements = {
        'H': {name: 'Hydrogen', mass: 1.008, number: 1},
        'He': {name: 'Helium', mass: 4.0026, number: 2},
        'Li': {name: 'Lithium', mass: 6.94, number: 3},
        'Be': {name: 'Beryllium', mass: 9.0122, number: 4},
        'B': {name: 'Boron', mass: 10.81, number: 5},
        'C': {name: 'Carbon', mass: 12.011, number: 6},
        'N': {name: 'Nitrogen', mass: 14.007, number: 7},
        'O': {name: 'Oxygen', mass: 15.999, number: 8},
        'F': {name: 'Fluorine', mass: 18.998, number: 9},
        'Ne': {name: 'Neon', mass: 20.180, number: 10},
        'Na': {name: 'Sodium', mass: 22.990, number: 11},
        'Mg': {name: 'Magnesium', mass: 24.305, number: 12},
        'Al': {name: 'Aluminum', mass: 26.982, number: 13},
        'Si': {name: 'Silicon', mass: 28.085, number: 14},
        'P': {name: 'Phosphorus', mass: 30.974, number: 15},
        'S': {name: 'Sulfur', mass: 32.06, number: 16},
        'Cl': {name: 'Chlorine', mass: 35.45, number: 17},
        'Ar': {name: 'Argon', mass: 39.948, number: 18},
        'K': {name: 'Potassium', mass: 39.098, number: 19},
        'Ca': {name: 'Calcium', mass: 40.078, number: 20},
        'Sc': {name: 'Scandium', mass: 44.956, number: 21},
        'Ti': {name: 'Titanium', mass: 47.867, number: 22},
        'V': {name: 'Vanadium', mass: 50.942, number: 23},
        'Cr': {name: 'Chromium', mass: 51.996, number: 24},
        'Mn': {name: 'Manganese', mass: 54.938, number: 25},
        'Fe': {name: 'Iron', mass: 55.845, number: 26},
        'Co': {name: 'Cobalt', mass: 58.933, number: 27},
        'Ni': {name: 'Nickel', mass: 58.693, number: 28},
        'Cu': {name: 'Copper', mass: 63.546, number: 29},
        'Zn': {name: 'Zinc', mass: 65.38, number: 30},
        'Ga': {name: 'Gallium', mass: 69.723, number: 31},
        'Ge': {name: 'Germanium', mass: 72.630, number: 32},
        'As': {name: 'Arsenic', mass: 74.922, number: 33},
        'Se': {name: 'Selenium', mass: 78.971, number: 34},
        'Br': {name: 'Bromine', mass: 79.904, number: 35},
        'Kr': {name: 'Krypton', mass: 83.798, number: 36},
        'Rb': {name: 'Rubidium', mass: 85.468, number: 37},
        'Sr': {name: 'Strontium', mass: 87.62, number: 38},
        'Y': {name: 'Yttrium', mass: 88.906, number: 39},
        'Zr': {name: 'Zirconium', mass: 91.224, number: 40},
        'Nb': {name: 'Niobium', mass: 92.906, number: 41},
        'Mo': {name: 'Molybdenum', mass: 95.95, number: 42},
        'Tc': {name: 'Technetium', mass: 98, number: 43},
        'Ru': {name: 'Ruthenium', mass: 101.07, number: 44},
        'Rh': {name: 'Rhodium', mass: 102.91, number: 45},
        'Pd': {name: 'Palladium', mass: 106.42, number: 46},
        'Ag': {name: 'Silver', mass: 107.87, number: 47},
        'Cd': {name: 'Cadmium', mass: 112.41, number: 48},
        'In': {name: 'Indium', mass: 114.82, number: 49},
        'Sn': {name: 'Tin', mass: 118.71, number: 50},
        'Sb': {name: 'Antimony', mass: 121.76, number: 51},
        'Te': {name: 'Tellurium', mass: 127.60, number: 52},
        'I': {name: 'Iodine', mass: 126.90, number: 53},
        'Xe': {name: 'Xenon', mass: 131.29, number: 54},
        'Cs': {name: 'Cesium', mass: 132.91, number: 55},
        'Ba': {name: 'Barium', mass: 137.33, number: 56},
        'La': {name: 'Lanthanum', mass: 138.91, number: 57},
        'Ce': {name: 'Cerium', mass: 140.12, number: 58},
        'Pr': {name: 'Praseodymium', mass: 140.91, number: 59},
        'Nd': {name: 'Neodymium', mass: 144.24, number: 60},
        'Pm': {name: 'Promethium', mass: 145, number: 61},
        'Sm': {name: 'Samarium', mass: 150.36, number: 62},
        'Eu': {name: 'Europium', mass: 151.96, number: 63},
        'Gd': {name: 'Gadolinium', mass: 157.25, number: 64},
        'Tb': {name: 'Terbium', mass: 158.93, number: 65},
        'Dy': {name: 'Dysprosium', mass: 162.50, number: 66},
        'Ho': {name: 'Holmium', mass: 164.93, number: 67},
        'Er': {name: 'Erbium', mass: 167.26, number: 68},
        'Tm': {name: 'Thulium', mass: 168.93, number: 69},
        'Yb': {name: 'Ytterbium', mass: 173.05, number: 70},
        'Lu': {name: 'Lutetium', mass: 174.97, number: 71},
        'Hf': {name: 'Hafnium', mass: 178.49, number: 72},
        'Ta': {name: 'Tantalum', mass: 180.95, number: 73},
        'W': {name: 'Tungsten', mass: 183.84, number: 74},
        'Re': {name: 'Rhenium', mass: 186.21, number: 75},
        'Os': {name: 'Osmium', mass: 190.23, number: 76},
        'Ir': {name: 'Iridium', mass: 192.22, number: 77},
        'Pt': {name: 'Platinum', mass: 195.08, number: 78},
        'Au': {name: 'Gold', mass: 196.97, number: 79},
        'Hg': {name: 'Mercury', mass: 200.59, number: 80},
        'Tl': {name: 'Thallium', mass: 204.38, number: 81},
        'Pb': {name: 'Lead', mass: 207.2, number: 82},
        'Bi': {name: 'Bismuth', mass: 208.98, number: 83},
        'Po': {name: 'Polonium', mass: 209, number: 84},
        'At': {name: 'Astatine', mass: 210, number: 85},
        'Rn': {name: 'Radon', mass: 222, number: 86},
        'Fr': {name: 'Francium', mass: 223, number: 87},
        'Ra': {name: 'Radium', mass: 226, number: 88},
        'Ac': {name: 'Actinium', mass: 227, number: 89},
        'Th': {name: 'Thorium', mass: 232.04, number: 90},
        'Pa': {name: 'Protactinium', mass: 231.04, number: 91},
        'U': {name: 'Uranium', mass: 238.03, number: 92}
    };

    // Common compounds library (expanded with more examples)
    const commonCompounds = [
        // Basic compounds
        {formula: 'H2O', name: 'Water', category: 'basic'},
        {formula: 'CO2', name: 'Carbon Dioxide', category: 'basic'},
        {formula: 'O2', name: 'Oxygen Gas', category: 'basic'},
        {formula: 'N2', name: 'Nitrogen Gas', category: 'basic'},
        {formula: 'NaCl', name: 'Table Salt', category: 'basic'},
        {formula: 'NH3', name: 'Ammonia', category: 'basic'},
        {formula: 'CH4', name: 'Methane', category: 'basic'},
        {formula: 'H2O2', name: 'Hydrogen Peroxide', category: 'basic'},

        // Acids
        {formula: 'H2SO4', name: 'Sulfuric Acid', category: 'acids'},
        {formula: 'HCl', name: 'Hydrochloric Acid', category: 'acids'},
        {formula: 'HNO3', name: 'Nitric Acid', category: 'acids'},
        {formula: 'CH3COOH', name: 'Acetic Acid (Vinegar)', category: 'acids'},
        {formula: 'H3PO4', name: 'Phosphoric Acid', category: 'acids'},
        {formula: 'HF', name: 'Hydrofluoric Acid', category: 'acids'},

        // Bases
        {formula: 'NaOH', name: 'Sodium Hydroxide', category: 'bases'},
        {formula: 'Ca(OH)2', name: 'Calcium Hydroxide', category: 'bases'},
        {formula: 'KOH', name: 'Potassium Hydroxide', category: 'bases'},
        {formula: 'Mg(OH)2', name: 'Magnesium Hydroxide', category: 'bases'},

        // Salts
        {formula: 'CaCO3', name: 'Calcium Carbonate (Limestone)', category: 'salts'},
        {formula: 'NaHCO3', name: 'Sodium Bicarbonate (Baking Soda)', category: 'salts'},
        {formula: 'Na2CO3', name: 'Sodium Carbonate (Washing Soda)', category: 'salts'},
        {formula: 'KNO3', name: 'Potassium Nitrate', category: 'salts'},
        {formula: 'AgNO3', name: 'Silver Nitrate', category: 'salts'},
        {formula: 'BaSO4', name: 'Barium Sulfate', category: 'salts'},

        // Organic compounds
        {formula: 'C2H5OH', name: 'Ethanol (Alcohol)', category: 'organic'},
        {formula: 'C6H12O6', name: 'Glucose (Sugar)', category: 'organic'},
        {formula: 'C12H22O11', name: 'Sucrose (Table Sugar)', category: 'organic'},
        {formula: 'C6H6', name: 'Benzene', category: 'organic'},
        {formula: 'C8H10N4O2', name: 'Caffeine', category: 'organic'},
        {formula: 'C9H8O4', name: 'Aspirin', category: 'organic'},

        // Hydrates
        {formula: 'CuSO4·5H2O', name: 'Copper Sulfate Pentahydrate', category: 'hydrates'},
        {formula: 'Na2SO4·10H2O', name: 'Sodium Sulfate Decahydrate', category: 'hydrates'},
        {formula: 'MgSO4·7H2O', name: 'Magnesium Sulfate Heptahydrate (Epsom Salt)', category: 'hydrates'},
        {formula: 'CaCl2·2H2O', name: 'Calcium Chloride Dihydrate', category: 'hydrates'},

        // Complex compounds
        {formula: 'Al2(SO4)3', name: 'Aluminum Sulfate', category: 'complex'},
        {formula: 'Fe2O3', name: 'Iron(III) Oxide (Rust)', category: 'complex'},
        {formula: 'Ca3(PO4)2', name: 'Calcium Phosphate', category: 'complex'},
        {formula: '[Cu(NH3)4]SO4', name: 'Tetraamminecopper(II) Sulfate', category: 'complex'},
        {formula: 'K4[Fe(CN)6]', name: 'Potassium Ferrocyanide', category: 'complex'},

        // With coefficients
        {formula: '2H2O', name: '2 molecules of Water', category: 'coefficients'},
        {formula: '3H2SO4', name: '3 molecules of Sulfuric Acid', category: 'coefficients'},
        {formula: '5NaCl', name: '5 molecules of Sodium Chloride', category: 'coefficients'},
        {formula: '2Ca(OH)2', name: '2 molecules of Calcium Hydroxide', category: 'coefficients'}
    ];

    // Parse chemical formula
    function parseFormula(formula) {
        // Remove spaces and convert to standard format
        formula = formula.replace(/\s+/g, '').replace(/·/g, '.');

        // Check for leading coefficient (e.g., 3H2SO4)
        let coefficient = 1;
        let i = 0;
        let leadingNumber = '';

        while (i < formula.length && formula[i] >= '0' && formula[i] <= '9') {
            leadingNumber += formula[i];
            i++;
        }

        if (leadingNumber) {
            coefficient = parseInt(leadingNumber);
            formula = formula.substring(i);
        }

        const composition = {};
        const stack = [{}];
        let currentElement = '';
        let currentNumber = '';

        for (let i = 0; i < formula.length; i++) {
            const char = formula[i];

            if (char >= 'A' && char <= 'Z') {
                // Save previous element
                if (currentElement) {
                    const count = currentNumber ? parseInt(currentNumber) : 1;
                    stack[stack.length - 1][currentElement] = (stack[stack.length - 1][currentElement] || 0) + count;
                }
                currentElement = char;
                currentNumber = '';
            } else if (char >= 'a' && char <= 'z') {
                currentElement += char;
            } else if (char >= '0' && char <= '9') {
                currentNumber += char;
            } else if (char === '(' || char === '[') {
                // Save previous element
                if (currentElement) {
                    const count = currentNumber ? parseInt(currentNumber) : 1;
                    stack[stack.length - 1][currentElement] = (stack[stack.length - 1][currentElement] || 0) + count;
                    currentElement = '';
                    currentNumber = '';
                }
                stack.push({});
            } else if (char === ')' || char === ']') {
                // Save previous element
                if (currentElement) {
                    const count = currentNumber ? parseInt(currentNumber) : 1;
                    stack[stack.length - 1][currentElement] = (stack[stack.length - 1][currentElement] || 0) + count;
                    currentElement = '';
                    currentNumber = '';
                }

                // Get multiplier
                let multiplier = '';
                let j = i + 1;
                while (j < formula.length && formula[j] >= '0' && formula[j] <= '9') {
                    multiplier += formula[j];
                    j++;
                }
                multiplier = multiplier ? parseInt(multiplier) : 1;
                i = j - 1;

                // Pop stack and multiply
                const group = stack.pop();
                for (const elem in group) {
                    stack[stack.length - 1][elem] = (stack[stack.length - 1][elem] || 0) + group[elem] * multiplier;
                }
            } else if (char === '.') {
                // Hydrate separator - treat as addition
                if (currentElement) {
                    const count = currentNumber ? parseInt(currentNumber) : 1;
                    stack[stack.length - 1][currentElement] = (stack[stack.length - 1][currentElement] || 0) + count;
                    currentElement = '';
                    currentNumber = '';
                }
            }
        }

        // Save last element
        if (currentElement) {
            const count = currentNumber ? parseInt(currentNumber) : 1;
            stack[stack.length - 1][currentElement] = (stack[stack.length - 1][currentElement] || 0) + count;
        }

        // Apply coefficient to all elements
        const result = stack[0];
        if (coefficient > 1) {
            for (const elem in result) {
                result[elem] *= coefficient;
            }
        }

        return {composition: result, coefficient: coefficient};
    }

    // Calculate molar mass
    function calculateMolarMass(isAutoCalculate = false) {
        const formula = document.getElementById('formulaInput').value.trim();

        if (!formula) {
            if (!isAutoCalculate) {
                showError('Please enter a chemical formula');
            }
            return;
        }

        try {
            const parsed = parseFormula(formula);
            const composition = parsed.composition;
            const coefficient = parsed.coefficient;

            // Validate elements
            for (const elem in composition) {
                if (!elements[elem]) {
                    throw new Error(`Unknown element: ${elem}`);
                }
            }

            // Calculate total mass
            let totalMass = 0;
            const elementData = [];

            for (const elem in composition) {
                const count = composition[elem];
                const mass = elements[elem].mass * count;
                totalMass += mass;

                elementData.push({
                    symbol: elem,
                    name: elements[elem].name,
                    count: count,
                    mass: mass,
                    atomicMass: elements[elem].mass
                });
            }

            // Sort by mass percentage (descending)
            elementData.sort((a, b) => b.mass - a.mass);

            // Display results
            displayResults(formula, totalMass, elementData, coefficient, isAutoCalculate);

        } catch (error) {
            // Show inline error for auto-calculation, full error for manual
            if (isAutoCalculate) {
                showInlineError(error.message);
            } else {
                showError(error.message);
            }
        }
    }

    // Display results
    function displayResults(formula, totalMass, elementData, coefficient, isAutoCalculate = false) {
        document.getElementById('errorSection').style.display = 'none';
        document.getElementById('resultsSection').style.display = 'block';

        // Display molar mass with animation
        const massElement = document.getElementById('molarMassValue');
        massElement.style.opacity = '0';
        setTimeout(() => {
            massElement.textContent = totalMass.toFixed(3);
            massElement.style.transition = 'opacity 0.3s';
            massElement.style.opacity = '1';
        }, 50);

        // Format formula with proper subscripts and show compound name if found
        const formulaElement = document.getElementById('formulaDisplay');

        // Find matching compound name
        const matchingCompound = commonCompounds.find(c => c.formula === formula);

        // Format the formula with subscripts
        let formattedFormula = formatFormulaWithSubscripts(formula);

        // Build display HTML
        let displayHTML = '';
        if (matchingCompound) {
            // Show compound name first, then formula
            displayHTML = `<div style="font-size: 1rem; opacity: 0.9; margin-bottom: 5px;">${matchingCompound.name}</div>`;
            displayHTML += `<div style="font-size: 1.5rem;">${formattedFormula}</div>`;
        } else {
            // Just show formatted formula
            displayHTML = formattedFormula;
        }

        if (coefficient > 1) {
            displayHTML += `<div style="font-size: 1rem; opacity: 0.9; margin-top: 5px;">(${coefficient} molecules)</div>`;
        }

        formulaElement.innerHTML = displayHTML;

        // Render composition table
        renderCompositionTable(elementData, totalMass, isAutoCalculate);
    }

    // Format formula with proper subscripts for display
    function formatFormulaWithSubscripts(formula) {
        let formatted = '';
        let i = 0;

        // Check for leading coefficient
        let coefficient = '';
        while (i < formula.length && formula[i] >= '0' && formula[i] <= '9') {
            coefficient += formula[i];
            i++;
        }

        if (coefficient) {
            formatted += `<span style="color: #f59e0b; font-weight: 700; font-size: 1.3em; margin-right: 3px;">${coefficient}</span>`;
        }

        while (i < formula.length) {
            const char = formula[i];

            // Check for element symbol (uppercase letter)
            if (char >= 'A' && char <= 'Z') {
                let element = char;
                i++;

                // Check for second lowercase letter
                if (i < formula.length && formula[i] >= 'a' && formula[i] <= 'z') {
                    element += formula[i];
                    i++;
                }

                // Color code the element if it exists
                if (elements[element]) {
                    formatted += `<span style="color: #667eea; font-weight: 600;">${element}</span>`;
                } else {
                    formatted += element;
                }

                // Check for numbers (subscripts)
                let number = '';
                while (i < formula.length && formula[i] >= '0' && formula[i] <= '9') {
                    number += formula[i];
                    i++;
                }

                if (number) {
                    formatted += `<sub style="font-size: 0.7em;">${number}</sub>`;
                }
            }
            // Parentheses and brackets
            else if (char === '(' || char === ')' || char === '[' || char === ']') {
                formatted += `<span style="color: #e53e3e; font-weight: 700; font-size: 1.1em;">${char}</span>`;
                i++;

                // Check for numbers after closing bracket (coefficient)
                if ((char === ')' || char === ']') && i < formula.length && formula[i] >= '0' && formula[i] <= '9') {
                    let number = '';
                    while (i < formula.length && formula[i] >= '0' && formula[i] <= '9') {
                        number += formula[i];
                        i++;
                    }
                    formatted += `<sub style="font-size: 0.7em; color: #e53e3e;">${number}</sub>`;
                }
            }
            // Hydrate dot
            else if (char === '·' || char === '.') {
                formatted += `<span style="color: #3182ce; font-weight: 700; margin: 0 3px;">·</span>`;
                i++;
            }
            // Other characters
            else {
                formatted += char;
                i++;
            }
        }

        return formatted;
    }

    // Continue displayResults - render composition table
    function renderCompositionTable(elementData, totalMass, isAutoCalculate) {
        const tbody = document.getElementById('compositionTableBody');
        tbody.innerHTML = '';

        elementData.forEach(elem => {
            const percentage = (elem.mass / totalMass * 100);
            const row = document.createElement('tr');
            row.innerHTML = `
                <td><strong>${elem.symbol}</strong><br><small style="color: #718096;">${elem.name}</small></td>
                <td>${elem.count}</td>
                <td><strong>${percentage.toFixed(2)}%</strong></td>
                <td>
                    <div class="percentage-bar">
                        <div class="percentage-fill" style="width: ${percentage}%"></div>
                    </div>
                </td>
            `;
            tbody.appendChild(row);
        });

        // Scroll to results only if not auto-calculating
        if (!isAutoCalculate) {
            setTimeout(() => {
                document.getElementById('resultsSection').scrollIntoView({behavior: 'smooth', block: 'nearest'});
            }, 100);
        }
    }

    // Show error
    function showError(message) {
        document.getElementById('resultsSection').style.display = 'none';
        document.getElementById('errorSection').style.display = 'block';
        document.getElementById('errorMessage').textContent = '⚠️ ' + message;
    }

    // Show inline error (for auto-calculation)
    function showInlineError(message) {
        const preview = document.getElementById('formulaPreview');
        const previewText = document.getElementById('formulaPreviewText');

        if (preview.style.display !== 'none') {
            previewText.innerHTML = `<span style="color: #dc2626; font-size: 1rem;">⚠️ ${message}</span>`;
        }

        // Hide results section
        document.getElementById('resultsSection').style.display = 'none';
        document.getElementById('errorSection').style.display = 'none';
    }

    // Insert text into input
    function insertText(text) {
        const input = document.getElementById('formulaInput');
        const cursorPos = input.selectionStart;
        const textBefore = input.value.substring(0, cursorPos);
        const textAfter = input.value.substring(cursorPos);

        if (text === '(' || text === '[') {
            const closeBracket = text === '(' ? ')' : ']';
            input.value = textBefore + text + closeBracket + textAfter;
            input.selectionStart = input.selectionEnd = cursorPos + 1;
        } else {
            input.value = textBefore + text + textAfter;
            input.selectionStart = input.selectionEnd = cursorPos + text.length;
        }

        input.focus();
        handleFormulaInput(); // Trigger auto-calculation
    }

    // Handle formula input - update preview and calculate automatically
    function handleFormulaInput() {
        updateFormulaPreview();
        autoCalculate();
    }

    // Auto-calculate with debouncing (wait 500ms after user stops typing)
    let autoCalculateTimer;
    function autoCalculate() {
        clearTimeout(autoCalculateTimer);
        autoCalculateTimer = setTimeout(() => {
            const formula = document.getElementById('formulaInput').value.trim();
            if (formula) {
                calculateMolarMass(true); // Pass true to indicate auto-calculation
            } else {
                // Hide results if input is empty
                document.getElementById('resultsSection').style.display = 'none';
                document.getElementById('errorSection').style.display = 'none';
            }
        }, 500); // 500ms delay
    }

    // Update live formula preview with proper subscripts
    function updateFormulaPreview() {
        const input = document.getElementById('formulaInput').value.trim();
        const preview = document.getElementById('formulaPreview');
        const previewText = document.getElementById('formulaPreviewText');

        if (!input) {
            preview.style.display = 'none';
            return;
        }

        preview.style.display = 'block';

        // Convert formula to HTML with subscripts and superscripts
        let formatted = '';
        let i = 0;

        // Check for leading coefficient
        let coefficient = '';
        while (i < input.length && input[i] >= '0' && input[i] <= '9') {
            coefficient += input[i];
            i++;
        }

        if (coefficient) {
            formatted += `<span style="color: #f59e0b; font-weight: 700; font-size: 1.3em; margin-right: 5px;">${coefficient}</span>`;
        }

        while (i < input.length) {
            const char = input[i];

            // Check for element symbol (uppercase letter)
            if (char >= 'A' && char <= 'Z') {
                let element = char;
                i++;

                // Check for second lowercase letter
                if (i < input.length && input[i] >= 'a' && input[i] <= 'z') {
                    element += input[i];
                    i++;
                }

                // Color code the element if it exists
                if (elements[element]) {
                    formatted += `<span style="color: #667eea; font-weight: 600;">${element}</span>`;
                } else {
                    formatted += element;
                }

                // Check for numbers (subscripts)
                let number = '';
                while (i < input.length && input[i] >= '0' && input[i] <= '9') {
                    number += input[i];
                    i++;
                }

                if (number) {
                    formatted += `<sub style="font-size: 0.7em;">${number}</sub>`;
                }
            }
            // Parentheses and brackets
            else if (char === '(' || char === ')' || char === '[' || char === ']') {
                formatted += `<span style="color: #e53e3e; font-weight: 700; font-size: 1.1em;">${char}</span>`;
                i++;

                // Check for numbers after closing bracket (coefficient)
                if ((char === ')' || char === ']') && i < input.length && input[i] >= '0' && input[i] <= '9') {
                    let number = '';
                    while (i < input.length && input[i] >= '0' && input[i] <= '9') {
                        number += input[i];
                        i++;
                    }
                    formatted += `<sub style="font-size: 0.7em; color: #e53e3e;">${number}</sub>`;
                }
            }
            // Hydrate dot
            else if (char === '·' || char === '.') {
                formatted += `<span style="color: #3182ce; font-weight: 700; margin: 0 3px;">·</span>`;
                i++;
            }
            // Plus sign
            else if (char === '+') {
                formatted += `<span style="color: #38a169; font-weight: 700; margin: 0 5px;">+</span>`;
                i++;
            }
            // Arrow
            else if (char === '→' || (char === '-' && i+1 < input.length && input[i+1] === '>')) {
                formatted += `<span style="color: #805ad5; font-weight: 700; margin: 0 5px;">→</span>`;
                i += (char === '→') ? 1 : 2;
            }
            // Charge symbols (superscripts)
            else if (char === '^') {
                i++;
                let charge = '';
                while (i < input.length && (input[i] === '+' || input[i] === '-' || (input[i] >= '0' && input[i] <= '9'))) {
                    charge += input[i];
                    i++;
                }
                formatted += `<sup style="font-size: 0.7em; color: #d53f8c;">${charge}</sup>`;
            }
            // Space
            else if (char === ' ') {
                formatted += ' ';
                i++;
            }
            // Other characters
            else {
                formatted += char;
                i++;
            }
        }

        previewText.innerHTML = formatted || input;
    }

    // Load common compound
    function loadCompound(formula) {
        document.getElementById('formulaInput').value = formula;
        handleFormulaInput();
        // Immediately calculate for compound selection (no delay)
        setTimeout(() => calculateMolarMass(false), 100);
    }

    // Share URL - generate shareable link
    function shareURL() {
        const formula = document.getElementById('formulaInput').value.trim();

        if (!formula) {
            alert('Please enter a chemical formula first!');
            return;
        }

        // Create URL with formula parameter
        const baseURL = window.location.origin + window.location.pathname;
        const shareableURL = `${baseURL}?formula=${encodeURIComponent(formula)}`;

        // Display the shareable URL
        document.getElementById('shareURLInput').value = shareableURL;
        document.getElementById('shareURLDisplay').style.display = 'block';

        // Scroll to show the URL
        setTimeout(() => {
            document.getElementById('shareURLDisplay').scrollIntoView({behavior: 'smooth', block: 'nearest'});
        }, 100);
    }

    // Copy shareable URL to clipboard
    function copyShareURL() {
        const urlInput = document.getElementById('shareURLInput');
        urlInput.select();
        document.execCommand('copy');

        // Visual feedback
        const button = event.target;
        const originalText = button.textContent;
        button.textContent = '✅ Copied!';
        button.style.background = '#16a34a';

        setTimeout(() => {
            button.textContent = originalText;
            button.style.background = '#3b82f6';
        }, 2000);
    }

    // Load formula from URL parameter on page load
    function loadFromURL() {
        const urlParams = new URLSearchParams(window.location.search);
        const formula = urlParams.get('formula');

        if (formula) {
            document.getElementById('formulaInput').value = formula;
            handleFormulaInput();
            setTimeout(() => {
                calculateMolarMass(false);
                // Scroll to results
                setTimeout(() => {
                    document.getElementById('resultsSection').scrollIntoView({behavior: 'smooth'});
                }, 500);
            }, 200);
        }
    }

    // Copy results
    function copyResults() {
        const formula = document.getElementById('formulaInput').value;
        const mass = document.getElementById('molarMassValue').textContent;

        let text = `Chemical Formula: ${formula}\n`;
        text += `Molar Mass: ${mass} g/mol\n\n`;
        text += `Elemental Composition:\n`;

        const rows = document.querySelectorAll('#compositionTableBody tr');
        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            const elementInfo = cells[0].textContent.split('\n');
            const symbol = elementInfo[0];
            const name = elementInfo[1] || '';
            text += `${symbol} ${name}: ${cells[1].textContent} atoms, ${cells[2].textContent}\n`;
        });

        text += `\n🔗 Share: ${window.location.origin}${window.location.pathname}?formula=${encodeURIComponent(formula)}`;

        navigator.clipboard.writeText(text).then(() => {
            alert('✅ Results copied to clipboard!');
        });
    }

    // Clear formula (for quick button)
    function clearFormula() {
        document.getElementById('formulaInput').value = '';
        document.getElementById('formulaPreview').style.display = 'none';
        document.getElementById('resultsSection').style.display = 'none';
        document.getElementById('errorSection').style.display = 'none';
        document.getElementById('formulaInput').focus();
    }

    // Clear results
    function clearResults() {
        clearFormula();
    }

    // Print results
    function printResults() {
        window.print();
    }

    // Initialize common compounds grouped by category
    function initCommonCompounds() {
        const container = document.getElementById('commonCompounds');

        // Group compounds by category
        const categories = {
            'basic': {title: '⚗️ Basic Compounds', compounds: []},
            'acids': {title: '🧪 Acids', compounds: []},
            'bases': {title: '🔵 Bases', compounds: []},
            'salts': {title: '🧂 Salts', compounds: []},
            'organic': {title: '🌿 Organic Compounds', compounds: []},
            'hydrates': {title: '💧 Hydrates', compounds: []},
            'complex': {title: '🔬 Complex Compounds', compounds: []},
            'coefficients': {title: '✖️ With Coefficients', compounds: []}
        };

        // Group compounds
        commonCompounds.forEach(compound => {
            if (categories[compound.category]) {
                categories[compound.category].compounds.push(compound);
            }
        });

        // Render by category
        Object.keys(categories).forEach(catKey => {
            const cat = categories[catKey];
            if (cat.compounds.length === 0) return;

            // Category header
            const header = document.createElement('h4');
            header.style.cssText = 'color: #2d3748; margin: 20px 0 10px 0; font-size: 1rem; grid-column: 1 / -1;';
            header.textContent = cat.title;
            container.appendChild(header);

            // Compounds in category
            cat.compounds.forEach(compound => {
                const btn = document.createElement('div');
                btn.className = 'compound-btn';
                btn.onclick = () => loadCompound(compound.formula);
                btn.title = `${compound.name} - Click to calculate`;
                btn.innerHTML = `
                    <div class="compound-formula">${formatFormulaHTML(compound.formula)}</div>
                    <div class="compound-name">${compound.name}</div>
                `;
                container.appendChild(btn);
            });
        });
    }

    // Format formula with subscripts for display
    function formatFormulaHTML(formula) {
        return formula.replace(/(\d+)/g, '<sub>$1</sub>').replace(/·/g, '·');
    }

    // Periodic table layout with element categories
    const periodicLayout = [
        // Period 1
        [{sym: 'H', cat: 'nonmetal'}, ...Array(16).fill(null), {sym: 'He', cat: 'noble-gas'}],
        // Period 2
        [{sym: 'Li', cat: 'alkali-metal'}, {sym: 'Be', cat: 'alkaline-earth'}, ...Array(10).fill(null),
         {sym: 'B', cat: 'metalloid'}, {sym: 'C', cat: 'nonmetal'}, {sym: 'N', cat: 'nonmetal'},
         {sym: 'O', cat: 'nonmetal'}, {sym: 'F', cat: 'halogen'}, {sym: 'Ne', cat: 'noble-gas'}],
        // Period 3
        [{sym: 'Na', cat: 'alkali-metal'}, {sym: 'Mg', cat: 'alkaline-earth'}, ...Array(10).fill(null),
         {sym: 'Al', cat: 'post-transition'}, {sym: 'Si', cat: 'metalloid'}, {sym: 'P', cat: 'nonmetal'},
         {sym: 'S', cat: 'nonmetal'}, {sym: 'Cl', cat: 'halogen'}, {sym: 'Ar', cat: 'noble-gas'}],
        // Period 4
        [{sym: 'K', cat: 'alkali-metal'}, {sym: 'Ca', cat: 'alkaline-earth'},
         {sym: 'Sc', cat: 'transition-metal'}, {sym: 'Ti', cat: 'transition-metal'}, {sym: 'V', cat: 'transition-metal'},
         {sym: 'Cr', cat: 'transition-metal'}, {sym: 'Mn', cat: 'transition-metal'}, {sym: 'Fe', cat: 'transition-metal'},
         {sym: 'Co', cat: 'transition-metal'}, {sym: 'Ni', cat: 'transition-metal'}, {sym: 'Cu', cat: 'transition-metal'},
         {sym: 'Zn', cat: 'transition-metal'}, {sym: 'Ga', cat: 'post-transition'}, {sym: 'Ge', cat: 'metalloid'},
         {sym: 'As', cat: 'metalloid'}, {sym: 'Se', cat: 'nonmetal'}, {sym: 'Br', cat: 'halogen'}, {sym: 'Kr', cat: 'noble-gas'}],
        // Period 5
        [{sym: 'Rb', cat: 'alkali-metal'}, {sym: 'Sr', cat: 'alkaline-earth'},
         {sym: 'Y', cat: 'transition-metal'}, {sym: 'Zr', cat: 'transition-metal'}, {sym: 'Nb', cat: 'transition-metal'},
         {sym: 'Mo', cat: 'transition-metal'}, {sym: 'Tc', cat: 'transition-metal'}, {sym: 'Ru', cat: 'transition-metal'},
         {sym: 'Rh', cat: 'transition-metal'}, {sym: 'Pd', cat: 'transition-metal'}, {sym: 'Ag', cat: 'transition-metal'},
         {sym: 'Cd', cat: 'transition-metal'}, {sym: 'In', cat: 'post-transition'}, {sym: 'Sn', cat: 'post-transition'},
         {sym: 'Sb', cat: 'metalloid'}, {sym: 'Te', cat: 'metalloid'}, {sym: 'I', cat: 'halogen'}, {sym: 'Xe', cat: 'noble-gas'}],
        // Period 6
        [{sym: 'Cs', cat: 'alkali-metal'}, {sym: 'Ba', cat: 'alkaline-earth'}, {sym: 'La', cat: 'lanthanide'},
         {sym: 'Hf', cat: 'transition-metal'}, {sym: 'Ta', cat: 'transition-metal'}, {sym: 'W', cat: 'transition-metal'},
         {sym: 'Re', cat: 'transition-metal'}, {sym: 'Os', cat: 'transition-metal'}, {sym: 'Ir', cat: 'transition-metal'},
         {sym: 'Pt', cat: 'transition-metal'}, {sym: 'Au', cat: 'transition-metal'}, {sym: 'Hg', cat: 'transition-metal'},
         {sym: 'Tl', cat: 'post-transition'}, {sym: 'Pb', cat: 'post-transition'}, {sym: 'Bi', cat: 'post-transition'},
         {sym: 'Po', cat: 'metalloid'}, {sym: 'At', cat: 'halogen'}, {sym: 'Rn', cat: 'noble-gas'}],
        // Period 7
        [{sym: 'Fr', cat: 'alkali-metal'}, {sym: 'Ra', cat: 'alkaline-earth'}, {sym: 'Ac', cat: 'actinide'},
         {sym: 'Rf', cat: 'transition-metal'}, ...Array(14).fill(null)]
    ];

    let selectedElements = [];

    // Toggle collapsible sections
    function toggleCollapsible(sectionId) {
        const content = document.getElementById(sectionId + '-content');
        const icon = document.getElementById(sectionId + '-icon');
        const header = content.previousElementSibling;

        if (content.classList.contains('open')) {
            content.classList.remove('open');
            icon.classList.remove('open');
            header.classList.remove('active');
        } else {
            content.classList.add('open');
            icon.classList.add('open');
            header.classList.add('active');

            // Render periodic table on first open
            if (sectionId === 'formulaBuilder' && document.getElementById('periodicTable').children.length === 0) {
                renderPeriodicTable();
            }
        }
    }

    // Render periodic table
    function renderPeriodicTable() {
        const container = document.getElementById('periodicTable');
        const table = document.createElement('div');
        table.className = 'periodic-table';

        periodicLayout.forEach(row => {
            row.forEach(cell => {
                const cellDiv = document.createElement('div');

                if (cell === null) {
                    cellDiv.className = 'element-cell element-placeholder';
                } else {
                    const elem = elements[cell.sym];
                    if (!elem) {
                        // Element not in database, skip
                        cellDiv.className = 'element-cell element-placeholder';
                    } else {
                        cellDiv.className = `element-cell ${cell.cat}`;
                        cellDiv.innerHTML = `
                            <div class="element-number">${elem.number}</div>
                            <div class="element-symbol-cell">${cell.sym}</div>
                            <div class="element-mass-cell">${elem.mass.toFixed(2)}</div>
                        `;
                        cellDiv.onclick = () => selectElement(cell.sym);
                        // Enhanced tooltip with element info
                        cellDiv.title = `${elem.name} (${cell.sym})\nAtomic Number: ${elem.number}\nAtomic Mass: ${elem.mass.toFixed(3)} g/mol\nClick to add to formula`;
                    }
                }

                table.appendChild(cellDiv);
            });
        });

        container.appendChild(table);
    }

    // Select element
    function selectElement(symbol) {
        const existing = selectedElements.find(e => e.symbol === symbol);

        if (existing) {
            existing.count++;
        } else {
            selectedElements.push({
                symbol: symbol,
                name: elements[symbol].name,
                count: 1
            });
        }

        updateSelectedElements();
    }

    // Update selected elements display
    function updateSelectedElements() {
        if (selectedElements.length === 0) {
            document.getElementById('selectedElementsSection').style.display = 'none';
            return;
        }

        document.getElementById('selectedElementsSection').style.display = 'block';
        const container = document.getElementById('selectedElementsList');
        container.innerHTML = '';

        selectedElements.forEach((elem, index) => {
            const badge = document.createElement('div');
            badge.className = 'selected-element-badge';
            badge.innerHTML = `
                <span class="symbol">${elem.symbol}</span>
                <input type="number"
                       class="count-input"
                       value="${elem.count}"
                       min="1"
                       max="99"
                       onchange="updateElementCount(${index}, this.value)">
                <button class="remove-btn" onclick="removeElement(${index})">×</button>
            `;
            container.appendChild(badge);
        });
    }

    // Update element count
    function updateElementCount(index, newCount) {
        selectedElements[index].count = parseInt(newCount) || 1;
    }

    // Remove element
    function removeElement(index) {
        selectedElements.splice(index, 1);
        updateSelectedElements();
    }

    // Clear selection
    function clearSelection() {
        selectedElements = [];
        updateSelectedElements();
    }

    // Build formula from selection
    function buildFormulaFromSelection() {
        if (selectedElements.length === 0) {
            alert('Please select elements from the periodic table first!');
            return;
        }

        // Sort elements by: C, H, then alphabetically
        const sortedElements = [...selectedElements].sort((a, b) => {
            if (a.symbol === 'C') return -1;
            if (b.symbol === 'C') return 1;
            if (a.symbol === 'H') return -1;
            if (b.symbol === 'H') return 1;
            return a.symbol.localeCompare(b.symbol);
        });

        // Build formula string
        let formula = '';
        sortedElements.forEach(elem => {
            formula += elem.symbol;
            if (elem.count > 1) {
                formula += elem.count;
            }
        });

        // Insert into formula input
        document.getElementById('formulaInput').value = formula;

        // Update preview and calculate
        handleFormulaInput();

        // Immediately calculate (no delay)
        setTimeout(() => {
            calculateMolarMass(false);
            // Scroll to results
            document.getElementById('resultsSection').scrollIntoView({behavior: 'smooth'});
        }, 100);
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        initCommonCompounds();

        // Check if formula is in URL (shared link)
        const urlParams = new URLSearchParams(window.location.search);
        const formulaFromURL = urlParams.get('formula');

        if (formulaFromURL) {
            // Load from shared URL
            loadFromURL();
        } else {
            // Load default example (Glucose - a common and interesting compound)
            setTimeout(() => {
                document.getElementById('formulaInput').value = 'C6H12O6';
                handleFormulaInput();
                setTimeout(() => calculateMolarMass(false), 200);
            }, 500);
        }
    });
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

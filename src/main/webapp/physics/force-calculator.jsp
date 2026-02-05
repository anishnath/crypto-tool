<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<% String cacheVersion = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">

    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Force Calculator - Newton's Laws & Free Body Diagrams" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription"
            value="Calculate force, mass, and acceleration using Newton's Second Law (F=ma). Includes weight, friction, normal force calculations with interactive free body diagrams and step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/force-calculator.jsp" />
        <jsp:param name="toolKeywords"
            value="force calculator, F=ma calculator, Newton's second law, free body diagram, friction calculator, weight calculator, normal force, net force, physics calculator, Newton calculator" />
        <jsp:param name="toolImage" value="force-calculator.png" />
        <jsp:param name="toolFeatures"
            value="F=ma calculator,Weight calculator,Friction force,Normal force,Free body diagrams,Step-by-step solutions,Unit conversions,Multiple scenarios,Interactive visualization,Physics education" />
        <jsp:param name="faq1q" value="How do I calculate force using F=ma?" />
        <jsp:param name="faq1a" value="Enter mass (m) in kg and acceleration (a) in m/s². The calculator uses F = ma to compute force in Newtons. You can also calculate mass or acceleration if you know the force." />
        <jsp:param name="faq2q" value="What is a free body diagram?" />
        <jsp:param name="faq2a" value="A free body diagram shows all forces acting on an object. This calculator generates interactive diagrams showing weight, normal force, friction, and net force with arrows and labels." />
        <jsp:param name="faq3q" value="How do I calculate friction force?" />
        <jsp:param name="faq3a" value="Enter coefficient of friction (μ) and normal force (N). Friction = μN. The calculator handles static and kinetic friction, and can solve for coefficient if you know the friction force." />
        <jsp:param name="faq4q" value="Is this force calculator free?" />
        <jsp:param name="faq4a" value="Yes, completely free with no registration. Includes Newton's laws, weight calculations, friction, and inclined planes with step-by-step solutions perfect for physics students." />
        <jsp:param name="faq5q" value="Can I use this for inclined plane problems?" />
        <jsp:param name="faq5a" value="Yes! Enter the angle and the calculator automatically resolves forces into components. Shows parallel force (mg sin θ), perpendicular force (mg cos θ), and friction calculations." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">

    <style>
        :root {
            --physics-blue: #2563eb;
            --physics-purple: #7c3aed;
            --physics-green: #059669;
            --physics-orange: #ea580c;
            --physics-red: #dc2626;
            --physics-cyan: #0891b2;
            --surface-1: #ffffff;
            --surface-2: #f8fafc;
            --surface-3: #f1f5f9;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --text-tertiary: #94a3b8;
            --border-light: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
        }

        [data-theme="dark"], .dark-mode {
            --surface-1: #1e293b;
            --surface-2: #0f172a;
            --surface-3: #334155;
            --text-primary: #f1f5f9;
            --text-secondary: #cbd5e1;
            --text-tertiary: #64748b;
            --border-light: #334155;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--surface-2);
            margin: 0;
        }

        /* Tool Header */
        .tool-header {
            background: linear-gradient(135deg, #0891b2 0%, #0e7490 100%);
            padding: 1.25rem 1.5rem;
            margin-top: 72px;
            border-bottom: 1px solid var(--border-light);
        }

        .tool-header-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .tool-page-title {
            margin: 0;
            font-size: 1.75rem;
            font-weight: 700;
            color: white;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .tool-page-description {
            color: rgba(255, 255, 255, 0.9);
            margin: 0.5rem 0 0 0;
            font-size: 1rem;
        }

        .tool-badges {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            flex-wrap: wrap;
        }

        .tool-badge {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        /* Layout */
        .edu-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .edu-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1.5rem;
        }

        @media (min-width: 1024px) {
            .edu-grid {
                grid-template-columns: 400px 1fr;
                gap: 2rem;
            }
        }

        /* Info Box */
        .info-box {
            background: linear-gradient(135deg, rgba(8, 145, 178, 0.1), rgba(14, 116, 144, 0.1));
            border-left: 4px solid var(--physics-cyan);
            border-radius: 12px;
            padding: 1rem 1.25rem;
            margin-bottom: 2rem;
        }

        .info-box-title {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .info-box p {
            margin: 0;
            color: var(--text-secondary);
            font-size: 0.9rem;
            line-height: 1.5;
        }

        /* Control Panel */
        .control-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid var(--border-light);
        }

        .panel-header {
            background: linear-gradient(135deg, #0891b2, #0e7490);
            color: white;
            padding: 1.25rem 1.5rem;
        }

        .panel-header h2 {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 700;
        }

        .panel-header p {
            margin: 0.25rem 0 0 0;
            opacity: 0.9;
            font-size: 0.875rem;
        }

        .panel-body {
            padding: 1.5rem;
        }

        /* Mode Tabs */
        .mode-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }

        .mode-tab {
            flex: 1;
            min-width: 100px;
            padding: 0.75rem 1rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }

        .mode-tab:hover {
            border-color: var(--physics-cyan);
            color: var(--physics-cyan);
        }

        .mode-tab.active {
            background: linear-gradient(135deg, #0891b2, #0e7490);
            border-color: transparent;
            color: white;
        }

        /* Input Section */
        .input-section {
            margin-bottom: 1.25rem;
        }

        .input-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .input-with-unit {
            display: flex;
            gap: 0;
            align-items: stretch;
        }

        .number-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border-light);
            border-radius: 10px 0 0 10px;
            font-size: 1rem;
            font-family: 'JetBrains Mono', monospace;
            background: var(--surface-1);
            color: var(--text-primary);
            transition: all 0.2s;
        }

        .number-input:focus {
            outline: none;
            border-color: var(--physics-cyan);
        }

        .unit-select {
            padding: 0.75rem;
            background: var(--surface-3);
            border: 2px solid var(--border-light);
            border-left: none;
            border-radius: 0 10px 10px 0;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            min-width: 70px;
        }

        .unit-select:focus {
            outline: none;
            border-color: var(--physics-cyan);
        }

        /* Solve For Selection */
        .solve-for-section {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.25rem;
            border: 1px solid var(--border-light);
        }

        .solve-for-label {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-secondary);
            margin-bottom: 0.75rem;
            display: block;
        }

        .solve-for-btns {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .solve-btn {
            flex: 1;
            min-width: 80px;
            padding: 0.625rem 1rem;
            background: var(--surface-1);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .solve-btn:hover {
            border-color: var(--physics-cyan);
            color: var(--physics-cyan);
        }

        .solve-btn.active {
            background: var(--physics-cyan);
            border-color: var(--physics-cyan);
            color: white;
        }

        /* Calculate Button */
        .calc-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, var(--physics-cyan), #0e7490);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: var(--shadow-md);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .calc-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Results */
        .results-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
            margin-top: 1.5rem;
        }

        .result-card {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
            border: 1px solid var(--border-light);
        }

        .result-card.highlight {
            background: linear-gradient(135deg, var(--physics-cyan), #0e7490);
            color: white;
            border: none;
            grid-column: span 2;
        }

        .result-icon {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .result-label {
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.8;
            margin-bottom: 0.25rem;
        }

        .result-value {
            font-size: 1.25rem;
            font-weight: 800;
            font-family: 'JetBrains Mono', monospace;
        }

        .result-card:not(.highlight) .result-value {
            color: var(--text-primary);
        }

        /* Output Units */
        .output-units {
            margin-top: 1rem;
            padding: 0.75rem;
            background: var(--surface-2);
            border-radius: 10px;
            border: 1px solid var(--border-light);
        }

        .output-units-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
            display: block;
        }

        .output-units-row {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .unit-btn {
            padding: 0.375rem 0.75rem;
            background: var(--surface-1);
            border: 2px solid var(--border-light);
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .unit-btn:hover {
            border-color: var(--physics-cyan);
            color: var(--physics-cyan);
        }

        .unit-btn.active {
            background: linear-gradient(135deg, var(--physics-cyan), #0e7490);
            border-color: transparent;
            color: white;
        }

        /* Examples */
        .examples-section {
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border-light);
        }

        .examples-section h4 {
            margin: 0 0 1rem 0;
            font-size: 0.9rem;
            color: var(--text-primary);
        }

        .examples-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
        }

        .example-card {
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 10px;
            padding: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }

        .example-card:hover {
            border-color: var(--physics-cyan);
            transform: translateY(-2px);
        }

        .example-icon {
            font-size: 1.5rem;
            margin-bottom: 0.25rem;
        }

        .example-title {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .example-desc {
            font-size: 0.7rem;
            color: var(--text-secondary);
        }

        /* Simulation Panel */
        .simulation-panel {
            background: var(--surface-1);
            border-radius: 16px;
            box-shadow: var(--shadow-md);
            overflow: hidden;
            border: 1px solid var(--border-light);
        }

        .simulation-header {
            background: linear-gradient(135deg, rgba(8, 145, 178, 0.1), rgba(14, 116, 144, 0.05));
            padding: 1rem 1.25rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-light);
        }

        .simulation-header h3 {
            margin: 0;
            font-size: 1rem;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Free Body Diagram */
        .fbd-container {
            position: relative;
            width: 100%;
            height: 350px;
            background: linear-gradient(180deg, #e0f2fe 0%, #f0f9ff 100%);
            border-radius: 12px;
            margin: 1rem;
            overflow: hidden;
            border: 2px solid var(--border-light);
        }

        [data-theme="dark"] .fbd-container,
        .dark-mode .fbd-container {
            background: linear-gradient(180deg, #164e63 0%, #0f172a 100%);
        }

        .fbd-canvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .fbd-object {
            position: absolute;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #64748b, #475569);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            box-shadow: var(--shadow-lg);
            z-index: 10;
        }

        .fbd-info {
            position: absolute;
            bottom: 10px;
            left: 10px;
            right: 10px;
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .fbd-info-pill {
            background: rgba(255, 255, 255, 0.95);
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-primary);
            box-shadow: var(--shadow-sm);
        }

        [data-theme="dark"] .fbd-info-pill,
        .dark-mode .fbd-info-pill {
            background: rgba(30, 41, 59, 0.95);
            color: var(--text-primary);
        }

        /* Force Legend */
        .force-legend {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            padding: 1rem;
            background: var(--surface-2);
            border-top: 1px solid var(--border-light);
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .legend-color {
            width: 20px;
            height: 4px;
            border-radius: 2px;
        }

        .legend-color.applied {
            background: #dc2626;
        }

        .legend-color.weight {
            background: #7c3aed;
        }

        .legend-color.normal {
            background: #059669;
        }

        .legend-color.friction {
            background: #ea580c;
        }

        .legend-color.net {
            background: #2563eb;
        }

        /* Formula Section */
        .formula-section {
            padding: 1rem;
            border-top: 1px solid var(--border-light);
        }

        .formula-section h4 {
            margin: 0 0 1rem 0;
            font-size: 0.9rem;
            color: var(--text-primary);
        }

        .formula-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.75rem;
        }

        .formula-card {
            background: var(--surface-2);
            border-radius: 10px;
            padding: 1rem;
            border: 1px solid var(--border-light);
        }

        .formula-code {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--physics-cyan);
            margin-bottom: 0.25rem;
        }

        .formula-name {
            font-size: 0.75rem;
            color: var(--text-secondary);
        }

        /* Steps Section */
        .steps-section {
            margin: 1rem;
            background: var(--surface-2);
            border-radius: 12px;
            border: 1px solid var(--border-light);
            overflow: hidden;
        }

        .steps-header {
            background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple));
            color: white;
            padding: 0.75rem 1rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            user-select: none;
        }

        .steps-toggle {
            margin-left: auto;
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .steps-body {
            padding: 1rem;
            max-height: 400px;
            overflow-y: auto;
        }

        .steps-body.collapsed {
            display: none;
        }

        .step-item {
            background: var(--surface-1);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            border-left: 4px solid var(--physics-cyan);
        }

        .step-item:last-child {
            margin-bottom: 0;
        }

        .step-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            background: var(--physics-cyan);
            color: white;
            border-radius: 50%;
            font-size: 0.75rem;
            font-weight: 700;
            margin-right: 0.5rem;
        }

        .step-title {
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .step-formula {
            background: var(--surface-2);
            padding: 0.75rem;
            border-radius: 8px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9rem;
            color: var(--physics-blue);
            margin: 0.5rem 0;
        }

        .step-calc {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.8;
        }

        .step-calc .highlight {
            color: var(--physics-cyan);
            font-weight: 700;
        }

        .step-result {
            background: linear-gradient(135deg, rgba(5, 150, 105, 0.1), rgba(16, 185, 129, 0.1));
            border: 1px solid rgba(5, 150, 105, 0.3);
            border-radius: 8px;
            padding: 0.75rem;
            margin-top: 0.5rem;
        }

        .step-result-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--physics-green);
            font-weight: 600;
        }

        .step-result-value {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--physics-green);
        }

        /* Friction Options */
        .friction-options {
            margin-top: 1rem;
            padding: 1rem;
            background: var(--surface-2);
            border-radius: 10px;
            border: 1px solid var(--border-light);
        }

        .friction-toggle {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }

        .toggle-switch {
            position: relative;
            width: 48px;
            height: 26px;
            background: var(--border-light);
            border-radius: 13px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .toggle-switch.active {
            background: var(--physics-cyan);
        }

        .toggle-switch::after {
            content: '';
            position: absolute;
            top: 3px;
            left: 3px;
            width: 20px;
            height: 20px;
            background: white;
            border-radius: 50%;
            transition: all 0.3s;
            box-shadow: var(--shadow-sm);
        }

        .toggle-switch.active::after {
            left: 25px;
        }

        .toggle-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .friction-inputs {
            display: none;
        }

        .friction-inputs.show {
            display: block;
        }

        /* Educational Content */
        .edu-content {
            background: var(--surface-1);
            border-radius: 16px;
            padding: 2rem;
            margin-top: 2rem;
            border: 1px solid var(--border-light);
        }

        .edu-content h2 {
            color: var(--text-primary);
            margin: 0 0 1rem 0;
            font-size: 1.5rem;
        }

        .edu-content h3 {
            color: var(--text-primary);
            margin: 1.5rem 0 0.75rem 0;
            font-size: 1.1rem;
        }

        .edu-content p, .edu-content li {
            color: var(--text-secondary);
            line-height: 1.7;
        }

        .edu-content ul {
            padding-left: 1.5rem;
        }

        /* Mobile */
        @media (max-width: 768px) {
            .tool-header {
                padding: 1rem;
            }

            .tool-page-title {
                font-size: 1.25rem;
            }

            .edu-container {
                padding: 1rem;
            }

            .fbd-container {
                height: 280px;
            }

            .results-grid {
                grid-template-columns: 1fr;
            }

            .result-card.highlight {
                grid-column: span 1;
            }

            .mode-tabs {
                flex-direction: column;
            }

            .mode-tab {
                min-width: auto;
            }
        }
    </style>
</head>

<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title">
                <span>💪</span> Force Calculator
            </h1>
            <p class="tool-page-description">Calculate force, mass, acceleration with Newton's Laws & free body diagrams</p>
            <div class="tool-badges">
                <span class="tool-badge">F = ma</span>
                <span class="tool-badge">Free Body Diagrams</span>
                <span class="tool-badge">Friction</span>
                <span class="tool-badge">Step-by-Step</span>
            </div>
        </div>
    </header>

    <main class="edu-container">

        <div class="info-box">
            <div class="info-box-title">
                <span>💡</span> Newton's Second Law
            </div>
            <p>
                <strong>F = ma</strong> — Force equals mass times acceleration. Enter any two values to calculate the third.
                Enable friction to include real-world effects like sliding resistance.
            </p>
        </div>

        <div class="edu-grid">

            <!-- Control Panel -->
            <div class="control-panel">
                <div class="panel-header">
                    <h2>Force Calculator</h2>
                    <p>Configure your calculation</p>
                </div>
                <div class="panel-body">

                    <!-- Mode Tabs -->
                    <div class="mode-tabs">
                        <button class="mode-tab active" onclick="setMode('basic')" data-mode="basic">Basic F=ma</button>
                        <button class="mode-tab" onclick="setMode('weight')" data-mode="weight">Weight</button>
                        <button class="mode-tab" onclick="setMode('incline')" data-mode="incline">Inclined Plane</button>
                    </div>

                    <!-- Solve For -->
                    <div class="solve-for-section" id="solve-for-section">
                        <span class="solve-for-label">Solve for:</span>
                        <div class="solve-for-btns">
                            <button class="solve-btn active" onclick="setSolveFor('force')" data-var="force">Force (F)</button>
                            <button class="solve-btn" onclick="setSolveFor('mass')" data-var="mass">Mass (m)</button>
                            <button class="solve-btn" onclick="setSolveFor('acceleration')" data-var="acceleration">Accel (a)</button>
                        </div>
                    </div>

                    <!-- Basic Inputs -->
                    <div id="basic-inputs">
                        <!-- Mass -->
                        <div class="input-section" id="mass-input-section">
                            <div class="input-label">
                                <span>⚖️</span>
                                <span>Mass (m)</span>
                            </div>
                            <div class="input-with-unit">
                                <input type="number" id="mass" class="number-input" value="10" min="0.001" step="0.1">
                                <select id="mass-unit" class="unit-select" onchange="calculate()">
                                    <option value="kg" selected>kg</option>
                                    <option value="g">g</option>
                                    <option value="lb">lb</option>
                                    <option value="oz">oz</option>
                                </select>
                            </div>
                        </div>

                        <!-- Acceleration -->
                        <div class="input-section" id="accel-input-section">
                            <div class="input-label">
                                <span>🚀</span>
                                <span>Acceleration (a)</span>
                            </div>
                            <div class="input-with-unit">
                                <input type="number" id="acceleration" class="number-input" value="9.8" min="0" step="0.1">
                                <select id="accel-unit" class="unit-select" onchange="calculate()">
                                    <option value="m/s²" selected>m/s²</option>
                                    <option value="ft/s²">ft/s²</option>
                                    <option value="g">g</option>
                                </select>
                            </div>
                            <div class="gravity-presets" style="margin-top: 0.5rem; display: flex; gap: 0.5rem; flex-wrap: wrap;">
                                <button class="unit-btn" onclick="setAccelPreset(9.81)">🌍 Earth g</button>
                                <button class="unit-btn" onclick="setAccelPreset(1.62)">🌙 Moon</button>
                                <button class="unit-btn" onclick="setAccelPreset(3.72)">🔴 Mars</button>
                            </div>
                        </div>

                        <!-- Force (for solving mass or acceleration) -->
                        <div class="input-section" id="force-input-section" style="display: none;">
                            <div class="input-label">
                                <span>💪</span>
                                <span>Force (F)</span>
                            </div>
                            <div class="input-with-unit">
                                <input type="number" id="force" class="number-input" value="98" min="0" step="0.1">
                                <select id="force-unit" class="unit-select" onchange="calculate()">
                                    <option value="N" selected>N</option>
                                    <option value="kN">kN</option>
                                    <option value="lbf">lbf</option>
                                    <option value="dyn">dyn</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Incline Inputs -->
                    <div id="incline-inputs" style="display: none;">
                        <div class="input-section">
                            <div class="input-label">
                                <span>📐</span>
                                <span>Incline Angle (θ)</span>
                            </div>
                            <div class="input-with-unit">
                                <input type="number" id="incline-angle" class="number-input" value="30" min="0" max="90" step="1">
                                <div class="unit-select" style="background: var(--surface-3);">°</div>
                            </div>
                        </div>
                    </div>

                    <!-- Friction Options -->
                    <div class="friction-options">
                        <div class="friction-toggle">
                            <div class="toggle-switch" id="friction-toggle" onclick="toggleFriction()"></div>
                            <span class="toggle-label">Include Friction</span>
                        </div>
                        <div class="friction-inputs" id="friction-inputs">
                            <div class="input-section" style="margin-bottom: 0;">
                                <div class="input-label">
                                    <span>🧲</span>
                                    <span>Coefficient of Friction (μ)</span>
                                </div>
                                <div class="input-with-unit">
                                    <input type="number" id="friction-coeff" class="number-input" value="0.3" min="0" max="1" step="0.01">
                                    <div class="unit-select" style="background: var(--surface-3);">μ</div>
                                </div>
                                <div style="margin-top: 0.5rem; display: flex; gap: 0.5rem; flex-wrap: wrap;">
                                    <button class="unit-btn" onclick="setFriction(0.1)">Ice 0.1</button>
                                    <button class="unit-btn" onclick="setFriction(0.3)">Wood 0.3</button>
                                    <button class="unit-btn" onclick="setFriction(0.5)">Concrete 0.5</button>
                                    <button class="unit-btn" onclick="setFriction(0.8)">Rubber 0.8</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Calculate Button -->
                    <button class="calc-btn" onclick="calculate()">
                        <span>⚡</span>
                        <span>Calculate Force</span>
                    </button>

                    <!-- Results -->
                    <div class="results-grid" id="results-grid">
                        <div class="result-card highlight">
                            <div class="result-icon">💪</div>
                            <div class="result-label">Net Force</div>
                            <div class="result-value" id="result-force">98.00 N</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">⚖️</div>
                            <div class="result-label">Weight</div>
                            <div class="result-value" id="result-weight">98.00 N</div>
                        </div>
                        <div class="result-card">
                            <div class="result-icon">⬆️</div>
                            <div class="result-label">Normal Force</div>
                            <div class="result-value" id="result-normal">98.00 N</div>
                        </div>
                        <div class="result-card" id="friction-result" style="display: none;">
                            <div class="result-icon">🧲</div>
                            <div class="result-label">Friction Force</div>
                            <div class="result-value" id="result-friction">29.40 N</div>
                        </div>
                    </div>

                    <!-- Output Units -->
                    <div class="output-units">
                        <span class="output-units-label">📐 Force Units</span>
                        <div class="output-units-row">
                            <button class="unit-btn active" onclick="setOutputUnit('N')" data-unit="N">Newtons</button>
                            <button class="unit-btn" onclick="setOutputUnit('kN')" data-unit="kN">kN</button>
                            <button class="unit-btn" onclick="setOutputUnit('lbf')" data-unit="lbf">lbf</button>
                            <button class="unit-btn" onclick="setOutputUnit('dyn')" data-unit="dyn">dyn</button>
                        </div>
                    </div>

                    <!-- Examples -->
                    <div class="examples-section">
                        <h4>📚 Try These Examples</h4>
                        <div class="examples-grid">
                            <div class="example-card" onclick="loadExample(1)">
                                <div class="example-icon">🚗</div>
                                <div class="example-title">Car Acceleration</div>
                                <div class="example-desc">1500 kg @ 3 m/s²</div>
                            </div>
                            <div class="example-card" onclick="loadExample(2)">
                                <div class="example-icon">🏋️</div>
                                <div class="example-title">Weightlifting</div>
                                <div class="example-desc">100 kg weight</div>
                            </div>
                            <div class="example-card" onclick="loadExample(3)">
                                <div class="example-icon">📦</div>
                                <div class="example-title">Box on Ramp</div>
                                <div class="example-desc">20 kg @ 30° incline</div>
                            </div>
                            <div class="example-card" onclick="loadExample(4)">
                                <div class="example-icon">🚀</div>
                                <div class="example-title">Rocket Launch</div>
                                <div class="example-desc">50000 kg @ 20 m/s²</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Simulation Panel -->
            <div class="simulation-panel">
                <div class="simulation-header">
                    <h3>📊 Free Body Diagram</h3>
                </div>

                <!-- Free Body Diagram -->
                <div class="fbd-container" id="fbd-container">
                    <canvas class="fbd-canvas" id="fbd-canvas"></canvas>
                    <div class="fbd-object" id="fbd-object">📦</div>
                    <div class="fbd-info">
                        <div class="fbd-info-pill" id="info-mass">m = 10 kg</div>
                        <div class="fbd-info-pill" id="info-accel">a = 9.8 m/s²</div>
                    </div>
                </div>

                <!-- Force Legend -->
                <div class="force-legend">
                    <div class="legend-item">
                        <div class="legend-color applied"></div>
                        <span>Applied Force</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color weight"></div>
                        <span>Weight (mg)</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color normal"></div>
                        <span>Normal Force</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color friction"></div>
                        <span>Friction</span>
                    </div>
                </div>

                <!-- Animation Controls (for incline mode) -->
                <div class="animation-controls" id="animation-controls" style="display: none; padding: 1rem; background: var(--surface-2); border-top: 1px solid var(--border-light);">
                    <div style="display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;">
                        <button id="simulate-btn" onclick="startSlideAnimation()" style="flex: 1; min-width: 150px; padding: 0.75rem 1rem; background: linear-gradient(135deg, #059669, #047857); color: white; border: none; border-radius: 10px; font-size: 0.95rem; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 0.5rem; transition: all 0.2s;">
                            <span>▶️</span><span>Simulate Slide</span>
                        </button>
                        <button onclick="resetAnimation()" style="padding: 0.75rem 1rem; background: var(--surface-1); color: var(--text-secondary); border: 2px solid var(--border-light); border-radius: 10px; font-size: 0.9rem; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 0.5rem;">
                            <span>🔄</span><span>Reset</span>
                        </button>
                    </div>
                    <p style="margin: 0.75rem 0 0; font-size: 0.8rem; color: var(--text-secondary);">
                        💡 When <strong>mg sin(θ) > μ·mg cos(θ)</strong>, the object slides down the incline.
                    </p>
                </div>

                <!-- Formulas -->
                <div class="formula-section">
                    <h4>📝 Force Formulas</h4>
                    <div class="formula-grid">
                        <div class="formula-card">
                            <div class="formula-code">F = ma</div>
                            <div class="formula-name">Newton's Second Law</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">W = mg</div>
                            <div class="formula-name">Weight</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">f = μN</div>
                            <div class="formula-name">Friction Force</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula-code">N = mg cos(θ)</div>
                            <div class="formula-name">Normal (incline)</div>
                        </div>
                    </div>
                </div>

                <!-- Step by Step -->
                <div class="steps-section">
                    <div class="steps-header" onclick="toggleSteps()">
                        <span>🧮</span>
                        <span>Step-by-Step Solution</span>
                        <span class="steps-toggle" id="steps-toggle">▼ Show</span>
                    </div>
                    <div class="steps-body collapsed" id="steps-body">
                        <!-- Populated by JavaScript -->
                    </div>
                </div>
            </div>

        </div>

        <!-- Educational Content -->
        <div class="edu-content">
            <h2>Understanding Force and Newton's Laws</h2>
            <p>
                Force is a push or pull that can change an object's motion. Sir Isaac Newton's three laws of motion describe
                how forces affect the movement of objects, forming the foundation of classical mechanics.
            </p>

            <h3>Newton's Three Laws of Motion</h3>
            <ul>
                <li><strong>First Law (Inertia):</strong> An object at rest stays at rest, and an object in motion stays in motion unless acted upon by an external force.</li>
                <li><strong>Second Law (F = ma):</strong> The acceleration of an object is directly proportional to the net force and inversely proportional to its mass.</li>
                <li><strong>Third Law (Action-Reaction):</strong> For every action, there is an equal and opposite reaction.</li>
            </ul>

            <h3>Types of Forces</h3>
            <ul>
                <li><strong>Applied Force:</strong> A force applied to an object by a person or another object</li>
                <li><strong>Gravitational Force (Weight):</strong> W = mg — the force of gravity on an object</li>
                <li><strong>Normal Force:</strong> The support force perpendicular to a surface</li>
                <li><strong>Friction Force:</strong> f = μN — resistance force opposing motion</li>
                <li><strong>Tension:</strong> Force transmitted through a rope, string, or cable</li>
            </ul>

            <h3>Free Body Diagrams</h3>
            <p>
                A free body diagram (FBD) shows all forces acting on an object as vectors. This visual representation
                helps analyze the net force and predict the object's motion. Forces are drawn as arrows pointing in
                the direction they act, with length proportional to magnitude.
            </p>

            <h3>Units of Force</h3>
            <ul>
                <li><strong>Newton (N):</strong> SI unit — 1 N = 1 kg·m/s²</li>
                <li><strong>Kilonewton (kN):</strong> 1 kN = 1000 N</li>
                <li><strong>Pound-force (lbf):</strong> Imperial unit — 1 lbf ≈ 4.448 N</li>
                <li><strong>Dyne (dyn):</strong> CGS unit — 1 dyn = 10⁻⁵ N</li>
            </ul>
        </div>

    </main>

    <footer class="tool-page-footer" style="background: var(--surface-1); border-top: 1px solid var(--border-light); padding: 2rem; text-align: center; margin-top: 2rem;">
        <div class="tool-page-footer-inner">
            <p style="color: var(--text-secondary); margin: 0;">&copy; 2025 8gwifi.org. All rights reserved.</p>
        </div>
    </footer>
    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <!-- Matter.js Physics Engine -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js"></script>
    <script src="<%=request.getContextPath()%>/physics/js/force-calculator.js?v=<%=cacheVersion%>"></script>
</body>

</html>

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
        <jsp:param name="toolName" value="Kinematics Solver - SUVAT Equation Calculator" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription"
            value="Advanced kinematics equation solver. Enter any 3 known values (u, v, a, s, t) and automatically solve for the unknowns. Features step-by-step solutions, interactive graphs, and motion visualization." />
        <jsp:param name="toolUrl" value="physics/kinematics-solver.jsp" />
        <jsp:param name="toolKeywords"
            value="kinematics solver, SUVAT calculator, physics calculator, motion equations, kinematic equations solver, physics problem solver, acceleration calculator, velocity calculator, displacement calculator" />
        <jsp:param name="toolImage" value="kinematics-solver.png" />
        <jsp:param name="toolFeatures"
            value="Smart equation solver,Any 3 known values,Automatic formula selection,Step-by-step solutions,Interactive graphs,Unit conversions,Motion visualization,Physics education" />
        <jsp:param name="faq1q" value="How does the kinematics solver work?" />
        <jsp:param name="faq1a" value="Enter any 3 of the 5 SUVAT variables (u=initial velocity, v=final velocity, a=acceleration, s=displacement, t=time). The solver automatically selects the correct kinematic equations to find the remaining 2 unknowns." />
        <jsp:param name="faq2q" value="What are the SUVAT equations?" />
        <jsp:param name="faq2a" value="SUVAT stands for: s=displacement, u=initial velocity, v=final velocity, a=acceleration, t=time. The 5 equations are: v=u+at, s=ut+½at², v²=u²+2as, s=½(u+v)t, s=vt-½at²." />
        <jsp:param name="faq3q" value="Is this kinematics solver free?" />
        <jsp:param name="faq3a" value="Yes, completely free with no registration. Enter any 3 values and get instant solutions with step-by-step explanations showing which equations were used and how they were solved." />
        <jsp:param name="faq4q" value="Can I use this for physics exams?" />
        <jsp:param name="faq4a" value="Perfect for exam prep! Shows all steps so you can understand the method. Practice with different scenarios - the solver handles all SUVAT combinations and includes unit conversions." />
        <jsp:param name="faq5q" value="What if I don't know which values to enter?" />
        <jsp:param name="faq5a" value="The solver is flexible - enter any 3 known values from your problem. For example: initial speed, final speed, and time. Or distance, acceleration, and time. It automatically finds the rest." />
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

        [data-theme="dark"] {
            --surface-1: #1e293b;
            --surface-2: #0f172a;
            --surface-3: #334155;
            --text-primary: #f1f5f9;
            --text-secondary: #cbd5e1;
            --text-tertiary: #64748b;
            --border-light: #334155;
        }

        .dark-mode {
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
            background: linear-gradient(135deg, #1e3a5f 0%, #0f172a 100%);
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
            color: rgba(255, 255, 255, 0.85);
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
            background: rgba(255, 255, 255, 0.15);
            color: white;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        /* Educational Layout */
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
                grid-template-columns: 450px 1fr;
                gap: 2rem;
            }
        }

        /* Info Box */
        .info-box {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.1), rgba(124, 58, 237, 0.1));
            border-left: 4px solid var(--physics-blue);
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
            font-size: 0.9375rem;
        }

        .info-box-content {
            color: var(--text-secondary);
            font-size: 0.875rem;
            line-height: 1.6;
            margin: 0;
        }

        .info-box-content strong {
            color: var(--text-primary);
        }

        /* Control Panel */
        .control-panel {
            background: var(--surface-1);
            border-radius: 16px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }

        .panel-header {
            background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple));
            color: white;
            padding: 1.5rem;
            text-align: center;
        }

        .panel-header h2 {
            margin: 0 0 0.5rem 0;
            font-size: 1.5rem;
            font-weight: 700;
        }

        .panel-header p {
            margin: 0;
            opacity: 0.95;
            font-size: 0.9rem;
        }

        .panel-body {
            padding: 1.5rem;
        }

        /* Variable Selector */
        .variable-selector {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 600px) {
            .variable-selector {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        .var-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.25rem;
            padding: 0.875rem 0.5rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .var-btn:hover {
            border-color: var(--physics-blue);
            background: var(--surface-3);
        }

        .var-btn.active {
            background: linear-gradient(135deg, var(--physics-green), #10b981);
            border-color: var(--physics-green);
            color: white;
        }

        .var-symbol {
            font-size: 1.5rem;
            font-weight: 800;
            font-family: 'JetBrains Mono', monospace;
        }

        .var-btn:not(.active) .var-symbol {
            color: var(--text-primary);
        }

        .var-name {
            font-size: 0.65rem;
            font-weight: 500;
            text-align: center;
            line-height: 1.2;
        }

        .var-btn:not(.active) .var-name {
            color: var(--text-secondary);
        }

        .var-status {
            font-size: 0.6rem;
            font-weight: 600;
            padding: 0.125rem 0.5rem;
            border-radius: 10px;
            background: rgba(0, 0, 0, 0.1);
        }

        .var-btn.active .var-status {
            background: rgba(255, 255, 255, 0.25);
        }

        /* Input Groups */
        .inputs-section {
            margin-bottom: 1.5rem;
        }

        .input-group {
            margin-bottom: 1rem;
        }

        .input-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--text-primary);
        }

        .input-row {
            display: grid;
            grid-template-columns: 1fr 100px;
            gap: 0.5rem;
        }

        .number-input {
            width: 100%;
            padding: 0.875rem;
            border: 2px solid var(--border-light);
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            background: var(--surface-1);
            color: var(--text-primary);
            font-family: 'JetBrains Mono', monospace;
            transition: all 0.2s;
        }

        .number-input:focus {
            outline: none;
            border-color: var(--physics-blue);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .unit-select {
            padding: 0.875rem 0.5rem;
            border: 2px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            background: var(--surface-1);
            color: var(--text-primary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .unit-select:focus {
            outline: none;
            border-color: var(--physics-blue);
        }

        /* Solve Button */
        .calculate-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, var(--physics-blue), var(--physics-purple));
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: var(--shadow-md);
        }

        .calculate-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .calculate-btn:active {
            transform: translateY(0);
        }

        /* Result Panel */
        .result-panel {
            background: var(--surface-1);
            border-radius: 16px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-md);
            padding: 1.5rem;
            min-height: 400px;
        }

        .placeholder-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            height: 100%;
            min-height: 350px;
            color: var(--text-tertiary);
        }

        .placeholder-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .placeholder-state h3 {
            margin: 0 0 0.5rem 0;
            color: var(--text-secondary);
            font-size: 1.25rem;
        }

        .placeholder-state p {
            margin: 0;
            font-size: 0.9rem;
            max-width: 280px;
        }

        /* Solution Display */
        .solution-header {
            margin-bottom: 1.5rem;
        }

        .solution-title {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--physics-green);
        }

        .solution-card {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border-light);
        }

        .result-main {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-primary);
            font-family: 'JetBrains Mono', monospace;
            margin-bottom: 0.75rem;
        }

        .result-conversions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-bottom: 1rem;
        }

        .conversion-badge {
            background: var(--surface-3);
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            font-family: 'JetBrains Mono', monospace;
        }

        .formula-box {
            background: rgba(37, 99, 235, 0.1);
            padding: 0.75rem 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            border-left: 3px solid var(--physics-blue);
        }

        .formula-box strong {
            color: var(--text-primary);
        }

        .formula-text {
            font-family: 'JetBrains Mono', monospace;
            color: var(--physics-blue);
            font-weight: 600;
        }

        .steps-container {
            margin-top: 0.75rem;
        }

        .step {
            padding: 0.5rem 0 0.5rem 1.25rem;
            position: relative;
            border-left: 2px solid var(--border-light);
            margin-left: 0.5rem;
        }

        .step::before {
            content: '';
            position: absolute;
            left: -5px;
            top: 0.75rem;
            width: 8px;
            height: 8px;
            background: var(--physics-blue);
            border-radius: 50%;
        }

        .step-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--physics-blue);
            margin-bottom: 0.25rem;
        }

        .step-content {
            color: var(--text-secondary);
            font-size: 0.875rem;
            font-family: 'JetBrains Mono', monospace;
        }

        /* Animation Stage */
        .animation-stage {
            position: relative;
            height: 200px;
            background: linear-gradient(180deg, #87CEEB 0%, #B0E0E6 50%, #E0E0E0 100%);
            border-radius: 12px;
            margin: 1.5rem 0;
            overflow: hidden;
            border: 2px solid var(--border-light);
        }

        .stage-info {
            position: absolute;
            top: 0.75rem;
            left: 0.75rem;
            right: 0.75rem;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 0.5rem;
            z-index: 10;
        }

        .info-badge {
            background: var(--surface-1);
            padding: 0.375rem 0.75rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.75rem;
            color: var(--text-primary);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-light);
        }

        .info-badge .label {
            color: var(--text-tertiary);
            font-size: 0.65rem;
            display: block;
        }

        .info-badge .value {
            font-family: 'JetBrains Mono', monospace;
        }

        .road {
            position: absolute;
            bottom: 50px;
            left: 0;
            right: 0;
            height: 40px;
            background: linear-gradient(to bottom, #64748b 0%, #475569 100%);
        }

        .road-line {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 3px;
            background: repeating-linear-gradient(to right,
                white 0px, white 20px,
                transparent 20px, transparent 40px);
            transform: translateY(-50%);
        }

        .vehicle-container {
            position: absolute;
            bottom: 60px;
            left: 30px;
            transition: left 2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .vehicle {
            font-size: 3rem;
            filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.2));
        }

        .distance-markers {
            position: absolute;
            bottom: 15px;
            left: 30px;
            right: 30px;
            display: flex;
            justify-content: space-between;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary);
        }

        /* Graphs */
        .graphs-container {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-top: 1.5rem;
        }

        @media (max-width: 768px) {
            .graphs-container {
                grid-template-columns: 1fr;
            }
        }

        .graph-card {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1rem;
            border: 1px solid var(--border-light);
        }

        .graph-title {
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .graph-svg {
            width: 100%;
            height: 180px;
            background: var(--surface-1);
            border-radius: 8px;
        }

        .graph-axis {
            stroke: var(--text-tertiary);
            stroke-width: 2;
        }

        .graph-line {
            fill: none;
            stroke: var(--physics-blue);
            stroke-width: 3;
            stroke-linecap: round;
        }

        .graph-point {
            fill: var(--physics-purple);
        }

        .graph-label {
            fill: var(--text-secondary);
            font-size: 11px;
            font-weight: 600;
        }

        /* Examples */
        .examples-section {
            margin-top: 1.5rem;
        }

        .examples-section h4 {
            margin: 0 0 1rem 0;
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .examples-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 0.75rem;
        }

        .example-card {
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 10px;
            padding: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }

        .example-card:hover {
            border-color: var(--physics-blue);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .example-icon {
            font-size: 1.75rem;
            margin-bottom: 0.5rem;
        }

        .example-title {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.85rem;
            margin-bottom: 0.25rem;
        }

        .example-desc {
            color: var(--text-secondary);
            font-size: 0.7rem;
        }

        /* Educational Content */
        .edu-content {
            margin-top: 3rem;
            background: var(--surface-1);
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid var(--border-light);
        }

        .edu-content h2 {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0 0 1rem 0;
        }

        .edu-content h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 2rem 0 1rem 0;
        }

        .edu-content p {
            color: var(--text-secondary);
            line-height: 1.7;
            margin-bottom: 1rem;
        }

        .edu-content ul, .edu-content ol {
            color: var(--text-secondary);
            line-height: 1.7;
            margin-bottom: 1rem;
            padding-left: 1.5rem;
        }

        .edu-content li {
            margin-bottom: 0.5rem;
        }

        .formula-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin: 1.5rem 0;
        }

        .formula-card {
            background: var(--surface-2);
            border-radius: 10px;
            padding: 1rem;
            text-align: center;
            border: 1px solid var(--border-light);
        }

        .formula-card .formula {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--physics-blue);
            margin-bottom: 0.5rem;
        }

        .formula-card .desc {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        /* Footer */
        .tool-page-footer {
            background: var(--surface-1);
            border-top: 1px solid var(--border-light);
            padding: 1.5rem;
            text-align: center;
            margin-top: 3rem;
        }

        .tool-page-footer p {
            margin: 0;
            color: var(--text-tertiary);
            font-size: 0.875rem;
        }
    </style>
</head>

<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <!-- Tool Header -->
    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title">
                <span>🧮</span> Kinematics Solver
            </h1>
            <p class="tool-page-description">Enter any 3 known values, solve for the rest automatically</p>
            <div class="tool-badges">
                <span class="tool-badge">SUVAT Equations</span>
                <span class="tool-badge">Step-by-Step</span>
                <span class="tool-badge">Visual Graphs</span>
            </div>
        </div>
    </header>

    <!-- Breadcrumbs -->
    <nav class="breadcrumbs">
        <div class="breadcrumbs-container">
            <a href="<%=request.getContextPath()%>/">Home</a>
            <span class="breadcrumb-separator">></span>
            <a href="<%=request.getContextPath()%>/physics/">Physics Tools</a>
            <span class="breadcrumb-separator">></span>
            <span class="breadcrumb-current">Kinematics Solver</span>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="tool-main">
        <div class="tool-container">
            <div class="edu-container">

                <!-- Info Box -->
                <div class="info-box">
                    <div class="info-box-title">
                        <span>💡</span>
                        <span>How It Works</span>
                    </div>
                    <p class="info-box-content">
                        <strong>Click 3 variable buttons</strong> to mark as Known (green). Enter their values, then click "Solve".
                        The solver automatically picks the right kinematic formulas and calculates the 2 unknowns with step-by-step solutions!
                    </p>
                </div>

                <div class="edu-grid">

                    <!-- Control Panel -->
                    <div class="control-panel">
                        <div class="panel-header">
                            <h2>Select Known Variables</h2>
                            <p>Choose exactly 3 variables you know</p>
                        </div>
                        <div class="panel-body">
                            <div class="variable-selector">
                                <button class="var-btn active" id="btn-u" onclick="toggleVar('u')">
                                    <span class="var-symbol">u</span>
                                    <span class="var-name">Initial Velocity</span>
                                    <span class="var-status">Known</span>
                                </button>
                                <button class="var-btn" id="btn-v" onclick="toggleVar('v')">
                                    <span class="var-symbol">v</span>
                                    <span class="var-name">Final Velocity</span>
                                    <span class="var-status">Unknown</span>
                                </button>
                                <button class="var-btn active" id="btn-a" onclick="toggleVar('a')">
                                    <span class="var-symbol">a</span>
                                    <span class="var-name">Acceleration</span>
                                    <span class="var-status">Known</span>
                                </button>
                                <button class="var-btn" id="btn-s" onclick="toggleVar('s')">
                                    <span class="var-symbol">s</span>
                                    <span class="var-name">Displacement</span>
                                    <span class="var-status">Unknown</span>
                                </button>
                                <button class="var-btn active" id="btn-t" onclick="toggleVar('t')">
                                    <span class="var-symbol">t</span>
                                    <span class="var-name">Time</span>
                                    <span class="var-status">Known</span>
                                </button>
                            </div>

                            <div class="inputs-section" id="inputs-section">
                                <!-- Inputs will be shown here dynamically -->
                            </div>

                            <button class="calculate-btn" onclick="solve()">
                                🚀 Solve for Unknowns
                            </button>

                            <!-- Examples -->
                            <div class="examples-section">
                                <h4>📚 Quick Examples</h4>
                                <div class="examples-grid">
                                    <div class="example-card" onclick="loadExample(1)">
                                        <div class="example-icon">🚗</div>
                                        <div class="example-title">Car Braking</div>
                                        <div class="example-desc">u=20, a=-5, t=4</div>
                                    </div>
                                    <div class="example-card" onclick="loadExample(2)">
                                        <div class="example-icon">🚀</div>
                                        <div class="example-title">Rocket Launch</div>
                                        <div class="example-desc">u=0, a=10, t=5</div>
                                    </div>
                                    <div class="example-card" onclick="loadExample(3)">
                                        <div class="example-icon">⚽</div>
                                        <div class="example-title">Ball Throw</div>
                                        <div class="example-desc">u=15, v=0, a=-10</div>
                                    </div>
                                    <div class="example-card" onclick="loadExample(4)">
                                        <div class="example-icon">🚂</div>
                                        <div class="example-title">Train Start</div>
                                        <div class="example-desc">u=0, s=100, t=10</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Result Panel -->
                    <div class="result-panel" id="result-panel">
                        <div class="placeholder-state">
                            <div class="placeholder-icon">🎯</div>
                            <h3>Ready to Solve!</h3>
                            <p>Select 3 known variables, enter their values, then click "Solve for Unknowns"</p>
                        </div>
                    </div>

                </div>

                <!-- Educational Content -->
                <div class="edu-content">
                    <h2>Understanding Kinematic Equations (SUVAT)</h2>
                    <p>
                        Kinematics is the branch of physics that describes the motion of objects without considering the forces that cause the motion.
                        The five kinematic variables are: initial velocity (u), final velocity (v), acceleration (a), displacement (s), and time (t).
                    </p>

                    <h3>The Five SUVAT Equations</h3>
                    <div class="formula-grid">
                        <div class="formula-card">
                            <div class="formula">v = u + at</div>
                            <div class="desc">No displacement (s)</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula">s = ut + ½at²</div>
                            <div class="desc">No final velocity (v)</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula">s = vt - ½at²</div>
                            <div class="desc">No initial velocity (u)</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula">v² = u² + 2as</div>
                            <div class="desc">No time (t)</div>
                        </div>
                        <div class="formula-card">
                            <div class="formula">s = ½(u + v)t</div>
                            <div class="desc">No acceleration (a)</div>
                        </div>
                    </div>

                    <h3>How to Use This Calculator</h3>
                    <ol>
                        <li><strong>Identify known values:</strong> From your physics problem, determine which 3 of the 5 variables you know</li>
                        <li><strong>Select variables:</strong> Click the buttons for your 3 known variables (they turn green)</li>
                        <li><strong>Enter values:</strong> Type in your known values with appropriate units</li>
                        <li><strong>Solve:</strong> Click "Solve for Unknowns" to calculate the remaining 2 variables</li>
                        <li><strong>Study the solution:</strong> Review the step-by-step calculation and graphs</li>
                    </ol>

                    <h3>Tips for Problem Solving</h3>
                    <ul>
                        <li><strong>Direction matters:</strong> Assign positive/negative signs based on your chosen direction</li>
                        <li><strong>Units consistency:</strong> Make sure all values use consistent units (SI: m, m/s, m/s², s)</li>
                        <li><strong>Free fall:</strong> Use a = -9.8 m/s² (or +9.8 if downward is positive)</li>
                        <li><strong>Starting from rest:</strong> If an object starts from rest, u = 0</li>
                        <li><strong>Maximum height:</strong> At the highest point, v = 0</li>
                    </ul>

                    <h3>Real-World Applications</h3>
                    <ul>
                        <li><strong>Vehicle safety:</strong> Calculating braking distances and stopping times</li>
                        <li><strong>Sports science:</strong> Analyzing athlete performance and projectile motion</li>
                        <li><strong>Engineering:</strong> Designing elevators, roller coasters, and transportation systems</li>
                        <li><strong>Aerospace:</strong> Planning rocket launches and spacecraft trajectories</li>
                    </ul>
                </div>

            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="tool-page-footer">
        <p>&copy; 2024 8gwifi.org - Physics Education Tools</p>
    </footer>

    <%@ include file="../modern/components/analytics.jsp" %>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>
    <script src="<%=request.getContextPath()%>/physics/js/kinematics-solver.js?v=<%=cacheVersion%>"></script>
    <script>
        // Load example presets
        function loadExample(num) {
            // Reset all buttons first
            ['u', 'v', 'a', 's', 't'].forEach(varName => {
                const btn = document.getElementById('btn-' + varName);
                if (btn) {
                    btn.classList.remove('active');
                    const status = btn.querySelector('.var-status');
                    if (status) status.textContent = 'Unknown';
                }
            });

            const examples = {
                1: { vars: ['u', 'a', 't'], values: { u: 20, a: -5, t: 4 } },      // Car braking
                2: { vars: ['u', 'a', 't'], values: { u: 0, a: 10, t: 5 } },       // Rocket launch
                3: { vars: ['u', 'v', 'a'], values: { u: 15, v: 0, a: -10 } },     // Ball throw up
                4: { vars: ['u', 's', 't'], values: { u: 0, s: 100, t: 10 } }      // Train start
            };

            const example = examples[num];
            knownVars.clear();

            example.vars.forEach(v => {
                knownVars.add(v);
                const btn = document.getElementById('btn-' + v);
                if (btn) {
                    btn.classList.add('active');
                    const status = btn.querySelector('.var-status');
                    if (status) status.textContent = 'Known';
                }
            });

            updateInputs();

            // Set values after inputs are created
            setTimeout(() => {
                for (const [varName, value] of Object.entries(example.values)) {
                    const input = document.getElementById('input-' + varName);
                    if (input) input.value = value;
                }
                solve();
            }, 50);
        }
    </script>
</body>

</html>

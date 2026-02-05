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
        <jsp:param name="toolName" value="Projectile Motion Calculator - Trajectory Simulator" />
        <jsp:param name="toolCategory" value="Physics Tools" />
        <jsp:param name="toolDescription"
            value="Interactive projectile motion calculator with real-time trajectory visualization. Calculate range, maximum height, and time of flight. Features animated simulation and step-by-step solutions." />
        <jsp:param name="toolUrl" value="physics/projectile-motion.jsp" />
        <jsp:param name="toolKeywords"
            value="projectile motion calculator, trajectory calculator, physics simulator, ballistics calculator, range calculator, maximum height, time of flight, launch angle, parabolic motion, physics education" />
        <jsp:param name="toolImage" value="projectile-motion.png" />
        <jsp:param name="toolFeatures"
            value="Real-time trajectory,Animated simulation,Range calculation,Maximum height,Time of flight,Adjustable angle,Multiple examples,Step-by-step solutions,Interactive graphs,Physics education" />
        <jsp:param name="faq1q" value="How do I calculate projectile range?" />
        <jsp:param name="faq1a" value="Enter initial velocity (v₀) and launch angle (θ). Range = v₀²sin(2θ)/g where g = 9.8 m/s². The calculator shows the full trajectory with maximum height and flight time." />
        <jsp:param name="faq2q" value="What is the maximum height of a projectile?" />
        <jsp:param name="faq2a" value="Maximum height h = (v₀²sin²θ)/(2g). Enter velocity and angle to see the peak height. The animated visualization shows the projectile reaching this point." />
        <jsp:param name="faq3q" value="Is this projectile motion calculator free?" />
        <jsp:param name="faq3a" value="Yes, 100% free with no signup. Features real-time trajectory animation, range calculations, and step-by-step solutions showing all kinematic equations used." />
        <jsp:param name="faq4q" value="What angle gives maximum range?" />
        <jsp:param name="faq4a" value="45° gives maximum range for level ground. The calculator shows how range changes with angle - try different angles to see the trajectory and range comparison." />
        <jsp:param name="faq5q" value="Can I use this for physics homework?" />
        <jsp:param name="faq5a" value="Absolutely! Perfect for projectile motion problems. Shows range, max height, time of flight, and velocity components with animated visualization and detailed step-by-step solutions." />
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
                grid-template-columns: 380px 1fr;
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

        /* Control Panel */
        .control-panel {
            background: var(--surface-1);
            border-radius: 16px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-md);
            overflow: hidden;
        }

        .panel-header {
            background: linear-gradient(135deg, var(--physics-orange), var(--physics-red));
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

        /* Input Groups */
        .input-section {
            margin-bottom: 1.5rem;
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
            grid-template-columns: 1fr 80px;
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
            border-color: var(--physics-orange);
            box-shadow: 0 0 0 4px rgba(234, 88, 12, 0.1);
        }

        .unit-label {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0.875rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
        }

        /* Angle Slider */
        .angle-slider-container {
            margin-bottom: 1.5rem;
        }

        .angle-display {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }

        .angle-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--physics-orange);
            font-family: 'JetBrains Mono', monospace;
        }

        .angle-slider {
            width: 100%;
            height: 8px;
            -webkit-appearance: none;
            appearance: none;
            background: linear-gradient(to right, var(--physics-blue) 0%, var(--physics-orange) 45%, var(--physics-red) 90%);
            border-radius: 4px;
            outline: none;
        }

        .angle-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 24px;
            height: 24px;
            background: white;
            border: 3px solid var(--physics-orange);
            border-radius: 50%;
            cursor: pointer;
            box-shadow: var(--shadow-md);
        }

        .angle-slider::-moz-range-thumb {
            width: 24px;
            height: 24px;
            background: white;
            border: 3px solid var(--physics-orange);
            border-radius: 50%;
            cursor: pointer;
        }

        .angle-presets {
            display: flex;
            gap: 0.5rem;
            margin-top: 0.75rem;
            flex-wrap: wrap;
        }

        .angle-preset {
            padding: 0.375rem 0.75rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .angle-preset:hover {
            border-color: var(--physics-orange);
            color: var(--physics-orange);
        }

        .angle-preset.optimal {
            background: rgba(234, 88, 12, 0.1);
            border-color: var(--physics-orange);
            color: var(--physics-orange);
        }

        /* Launch Button */
        .launch-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, var(--physics-orange), var(--physics-red));
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

        .launch-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Results Cards */
        .results-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
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
            background: linear-gradient(135deg, var(--physics-orange), var(--physics-red));
            color: white;
            border: none;
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

        /* Unit Selector */
        .input-with-unit {
            display: flex;
            gap: 0.5rem;
            align-items: stretch;
        }

        .input-with-unit .number-input {
            flex: 1;
            border-radius: 10px 0 0 10px;
        }

        .unit-select {
            padding: 0.5rem 0.75rem;
            background: var(--surface-3);
            border: 2px solid var(--border-light);
            border-left: none;
            border-radius: 0 10px 10px 0;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            min-width: 70px;
            transition: all 0.2s;
        }

        .unit-select:hover, .unit-select:focus {
            border-color: var(--physics-orange);
            outline: none;
        }

        /* Output Unit Selector */
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
            border-color: var(--physics-orange);
            color: var(--physics-orange);
        }

        .unit-btn.active {
            background: linear-gradient(135deg, var(--physics-orange), var(--physics-red));
            border-color: transparent;
            color: white;
        }

        /* Step by Step Section */
        .steps-section {
            margin-top: 1.5rem;
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

        .steps-header:hover {
            opacity: 0.95;
        }

        .steps-toggle {
            margin-left: auto;
            font-size: 0.8rem;
            opacity: 0.8;
        }

        .steps-body {
            padding: 1rem;
            max-height: 500px;
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
            border-left: 4px solid var(--physics-orange);
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
            background: var(--physics-orange);
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
            overflow-x: auto;
        }

        .step-calc {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
            color: var(--text-secondary);
            line-height: 1.8;
        }

        .step-calc .highlight {
            color: var(--physics-orange);
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

        .unit-conversions {
            margin-top: 0.5rem;
            padding-top: 0.5rem;
            border-top: 1px dashed var(--border-light);
        }

        .unit-conversion-item {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            padding: 0.25rem 0;
        }

        .unit-conversion-item .label {
            color: var(--text-secondary);
        }

        .unit-conversion-item .value {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            color: var(--text-primary);
        }

        /* Simulation Panel */
        .simulation-panel {
            background: var(--surface-1);
            border-radius: 16px;
            border: 1px solid var(--border-light);
            box-shadow: var(--shadow-md);
            padding: 1.5rem;
        }

        .simulation-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .simulation-header h3 {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .simulation-controls {
            display: flex;
            gap: 0.5rem;
        }

        .sim-btn {
            padding: 0.5rem 1rem;
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s;
        }

        .sim-btn:hover {
            border-color: var(--physics-orange);
            color: var(--physics-orange);
        }

        .sim-btn.active {
            background: var(--physics-orange);
            border-color: var(--physics-orange);
            color: white;
        }

        /* Trajectory Canvas */
        .trajectory-container {
            position: relative;
            width: 100%;
            height: 400px;
            background: linear-gradient(180deg, #87CEEB 0%, #B0E0E6 60%, #90EE90 60%, #228B22 100%);
            border-radius: 12px;
            overflow: hidden;
            border: 2px solid var(--border-light);
        }

        .trajectory-canvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .projectile {
            position: absolute;
            font-size: 1.5rem;
            transform: translate(-50%, -50%);
            transition: none;
            z-index: 10;
        }

        .launcher {
            position: absolute;
            bottom: 40%;
            left: 30px;
            font-size: 2rem;
            transform-origin: center center;
            z-index: 5;
        }

        .ground-markers {
            position: absolute;
            bottom: 35%;
            left: 30px;
            right: 30px;
            display: flex;
            justify-content: space-between;
            font-size: 0.75rem;
            font-weight: 600;
            color: #1a5f1a;
        }

        .height-marker {
            position: absolute;
            left: 10px;
            font-size: 0.7rem;
            font-weight: 600;
            color: #1a5f1a;
            background: rgba(255, 255, 255, 0.8);
            padding: 0.125rem 0.375rem;
            border-radius: 4px;
        }

        .trajectory-info {
            position: absolute;
            top: 1rem;
            right: 1rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .info-pill {
            background: rgba(255, 255, 255, 0.95);
            padding: 0.5rem 0.75rem;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
            box-shadow: var(--shadow-sm);
        }

        .info-pill .label {
            color: var(--text-tertiary);
            font-size: 0.65rem;
        }

        .info-pill .value {
            color: var(--text-primary);
            font-family: 'JetBrains Mono', monospace;
        }

        /* Graphs */
        .graphs-section {
            margin-top: 2rem;
        }

        .graphs-section h4 {
            margin: 0 0 1rem 0;
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .graphs-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
        }

        @media (max-width: 900px) {
            .graphs-grid {
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
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .graph-svg {
            width: 100%;
            height: 150px;
            background: var(--surface-1);
            border-radius: 8px;
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
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 0.75rem;
        }

        .example-card {
            background: var(--surface-2);
            border: 2px solid var(--border-light);
            border-radius: 10px;
            padding: 0.875rem;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
        }

        .example-card:hover {
            border-color: var(--physics-orange);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .example-icon {
            font-size: 1.5rem;
            margin-bottom: 0.375rem;
        }

        .example-title {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.8rem;
            margin-bottom: 0.125rem;
        }

        .example-desc {
            color: var(--text-secondary);
            font-size: 0.65rem;
        }

        /* Formula Section */
        .formula-section {
            background: var(--surface-2);
            border-radius: 12px;
            padding: 1.25rem;
            margin-top: 1.5rem;
            border-left: 4px solid var(--physics-orange);
        }

        .formula-section h4 {
            margin: 0 0 1rem 0;
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .formula-list {
            display: grid;
            gap: 0.75rem;
        }

        .formula-item {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .formula-code {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--physics-orange);
            background: var(--surface-1);
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            min-width: 180px;
        }

        .formula-desc {
            font-size: 0.85rem;
            color: var(--text-secondary);
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

        /* Responsive */
        @media (max-width: 768px) {
            .results-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .trajectory-container {
                height: 300px;
            }
        }
    </style>
</head>

<body>
    <%@ include file="../modern/components/nav-header.jsp" %>

    <!-- Tool Header -->
    <header class="tool-header">
        <div class="tool-header-container">
            <h1 class="tool-page-title">
                <span>🎯</span> Projectile Motion Calculator
            </h1>
            <p class="tool-page-description">Simulate projectile trajectories with real-time animation</p>
            <div class="tool-badges">
                <span class="tool-badge">Trajectory Simulation</span>
                <span class="tool-badge">Range & Height</span>
                <span class="tool-badge">Animated</span>
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
            <span class="breadcrumb-current">Projectile Motion</span>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="tool-main">
        <div class="tool-container">
            <div class="edu-container">

                <!-- Info Box -->
                <div class="info-box">
                    <div class="info-box-title">
                        <span>🎯</span>
                        <span>Projectile Motion Simulator</span>
                    </div>
                    <p class="info-box-content">
                        Set the <strong>initial velocity</strong> and <strong>launch angle</strong>, then click Launch!
                        Watch the projectile follow its parabolic path. <strong>45° gives maximum range</strong> on flat ground.
                    </p>
                </div>

                <div class="edu-grid">

                    <!-- Control Panel -->
                    <div class="control-panel">
                        <div class="panel-header">
                            <h2>Launch Settings</h2>
                            <p>Configure your projectile</p>
                        </div>
                        <div class="panel-body">

                            <!-- Initial Velocity -->
                            <div class="input-section">
                                <div class="input-label">
                                    <span>🚀</span>
                                    <span>Initial Velocity (v₀)</span>
                                </div>
                                <div class="input-with-unit">
                                    <input type="number" id="velocity" class="number-input" value="20" min="1" max="500" step="1">
                                    <select id="velocity-unit" class="unit-select" onchange="onUnitChange()">
                                        <option value="m/s" selected>m/s</option>
                                        <option value="km/h">km/h</option>
                                        <option value="ft/s">ft/s</option>
                                        <option value="mph">mph</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Launch Angle -->
                            <div class="angle-slider-container">
                                <div class="input-label">
                                    <span>📐</span>
                                    <span>Launch Angle (θ)</span>
                                </div>
                                <div class="angle-display">
                                    <span class="angle-value" id="angle-value">45°</span>
                                </div>
                                <input type="range" id="angle" class="angle-slider" min="5" max="85" value="45">
                                <div class="angle-presets">
                                    <button class="angle-preset" onclick="setAngle(15)">15°</button>
                                    <button class="angle-preset" onclick="setAngle(30)">30°</button>
                                    <button class="angle-preset optimal" onclick="setAngle(45)">45° ⭐</button>
                                    <button class="angle-preset" onclick="setAngle(60)">60°</button>
                                    <button class="angle-preset" onclick="setAngle(75)">75°</button>
                                </div>
                            </div>

                            <!-- Gravity -->
                            <div class="input-section">
                                <div class="input-label">
                                    <span>🌍</span>
                                    <span>Gravity (g)</span>
                                </div>
                                <div class="input-with-unit">
                                    <input type="number" id="gravity" class="number-input" value="9.8" min="0.1" max="100" step="0.1">
                                    <select id="gravity-unit" class="unit-select" onchange="onUnitChange()">
                                        <option value="m/s²" selected>m/s²</option>
                                        <option value="ft/s²">ft/s²</option>
                                    </select>
                                </div>
                                <div class="gravity-presets" style="margin-top: 0.5rem;">
                                    <button class="angle-preset" onclick="setGravity(9.81, 'm/s²')" title="Earth">🌍 Earth</button>
                                    <button class="angle-preset" onclick="setGravity(1.62, 'm/s²')" title="Moon">🌙 Moon</button>
                                    <button class="angle-preset" onclick="setGravity(3.72, 'm/s²')" title="Mars">🔴 Mars</button>
                                    <button class="angle-preset" onclick="setGravity(24.79, 'm/s²')" title="Jupiter">🟠 Jupiter</button>
                                </div>
                            </div>

                            <!-- Launch Button -->
                            <button class="launch-btn" onclick="launch()">
                                <span>🚀</span>
                                <span>Launch Projectile!</span>
                            </button>

                            <!-- Results -->
                            <div class="results-grid" id="results-grid">
                                <div class="result-card highlight">
                                    <div class="result-icon">📏</div>
                                    <div class="result-label">Range</div>
                                    <div class="result-value" id="result-range">40.8 m</div>
                                </div>
                                <div class="result-card">
                                    <div class="result-icon">⬆️</div>
                                    <div class="result-label">Max Height</div>
                                    <div class="result-value" id="result-height">10.2 m</div>
                                </div>
                                <div class="result-card">
                                    <div class="result-icon">⏱️</div>
                                    <div class="result-label">Flight Time</div>
                                    <div class="result-value" id="result-time">2.88 s</div>
                                </div>
                            </div>

                            <!-- Output Unit Selector -->
                            <div class="output-units">
                                <span class="output-units-label">📐 Display Units</span>
                                <div class="output-units-row">
                                    <button class="unit-btn active" onclick="setOutputUnit('m')" data-unit="m">Meters</button>
                                    <button class="unit-btn" onclick="setOutputUnit('ft')" data-unit="ft">Feet</button>
                                    <button class="unit-btn" onclick="setOutputUnit('yd')" data-unit="yd">Yards</button>
                                    <button class="unit-btn" onclick="setOutputUnit('km')" data-unit="km">Kilometers</button>
                                    <button class="unit-btn" onclick="setOutputUnit('mi')" data-unit="mi">Miles</button>
                                </div>
                            </div>

                            <!-- Examples -->
                            <div class="examples-section">
                                <h4>📚 Try These</h4>
                                <div class="examples-grid">
                                    <div class="example-card" onclick="loadExample(1)">
                                        <div class="example-icon">⚽</div>
                                        <div class="example-title">Soccer Kick</div>
                                        <div class="example-desc">25 m/s @ 35°</div>
                                    </div>
                                    <div class="example-card" onclick="loadExample(2)">
                                        <div class="example-icon">🏀</div>
                                        <div class="example-title">Basketball</div>
                                        <div class="example-desc">8 m/s @ 55°</div>
                                    </div>
                                    <div class="example-card" onclick="loadExample(3)">
                                        <div class="example-icon">🎾</div>
                                        <div class="example-title">Tennis Serve</div>
                                        <div class="example-desc">50 m/s @ 10°</div>
                                    </div>
                                    <div class="example-card" onclick="loadExample(4)">
                                        <div class="example-icon">💣</div>
                                        <div class="example-title">Cannonball</div>
                                        <div class="example-desc">80 m/s @ 45°</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Simulation Panel -->
                    <div class="simulation-panel">
                        <div class="simulation-header">
                            <h3>🎬 Trajectory Simulation</h3>
                            <div class="simulation-controls">
                                <button class="sim-btn" onclick="toggleTrail()" id="trail-btn">Trail: ON</button>
                                <button class="sim-btn" onclick="toggleMatterJS()" id="matter-btn">Physics: Normal</button>
                                <button class="sim-btn" onclick="resetSimulation()">Reset</button>
                            </div>
                        </div>

                        <!-- Trajectory Visualization -->
                        <div class="trajectory-container" id="trajectory-container">
                            <canvas class="trajectory-canvas" id="trajectory-canvas"></canvas>
                            <div class="launcher" id="launcher">🎯</div>
                            <div class="projectile" id="projectile" style="display: none;">⚫</div>
                            <div class="ground-markers">
                                <span>0 m</span>
                                <span id="range-marker">40 m</span>
                            </div>
                            <div class="trajectory-info">
                                <div class="info-pill">
                                    <div class="label">Position</div>
                                    <div class="value" id="info-position">x: 0 m, y: 0 m</div>
                                </div>
                                <div class="info-pill">
                                    <div class="label">Velocity</div>
                                    <div class="value" id="info-velocity">vx: 0, vy: 0 m/s</div>
                                </div>
                                <div class="info-pill">
                                    <div class="label">Time</div>
                                    <div class="value" id="info-time">t = 0.00 s</div>
                                </div>
                            </div>
                            <div class="height-marker" id="height-marker" style="bottom: 60%;">Max: 10.2 m</div>
                        </div>

                        <!-- Graphs -->
                        <div class="graphs-section">
                            <h4>📊 Motion Graphs</h4>
                            <div class="graphs-grid">
                                <div class="graph-card">
                                    <div class="graph-title">
                                        <span>📈</span> x vs t
                                    </div>
                                    <svg class="graph-svg" id="x-t-graph" viewBox="0 0 200 150"></svg>
                                </div>
                                <div class="graph-card">
                                    <div class="graph-title">
                                        <span>📈</span> y vs t
                                    </div>
                                    <svg class="graph-svg" id="y-t-graph" viewBox="0 0 200 150"></svg>
                                </div>
                                <div class="graph-card">
                                    <div class="graph-title">
                                        <span>📈</span> y vs x (Trajectory)
                                    </div>
                                    <svg class="graph-svg" id="y-x-graph" viewBox="0 0 200 150"></svg>
                                </div>
                            </div>
                        </div>

                        <!-- Formulas -->
                        <div class="formula-section">
                            <h4>📝 Projectile Motion Formulas</h4>
                            <div class="formula-list">
                                <div class="formula-item">
                                    <span class="formula-code">R = v₀²sin(2θ) / g</span>
                                    <span class="formula-desc">Range (horizontal distance)</span>
                                </div>
                                <div class="formula-item">
                                    <span class="formula-code">H = v₀²sin²(θ) / 2g</span>
                                    <span class="formula-desc">Maximum height</span>
                                </div>
                                <div class="formula-item">
                                    <span class="formula-code">T = 2v₀sin(θ) / g</span>
                                    <span class="formula-desc">Total flight time</span>
                                </div>
                            </div>
                        </div>

                        <!-- Step by Step Calculations -->
                        <div class="steps-section">
                            <div class="steps-header" onclick="toggleSteps()">
                                <span>🧮</span>
                                <span>Step-by-Step Solution</span>
                                <span class="steps-toggle" id="steps-toggle">▼ Show</span>
                            </div>
                            <div class="steps-body collapsed" id="steps-body">
                                <!-- Steps will be populated by JavaScript -->
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Educational Content -->
                <div class="edu-content">
                    <h2>Understanding Projectile Motion</h2>
                    <p>
                        Projectile motion is the motion of an object thrown or projected into the air, subject only to gravity.
                        The path of a projectile is called its <strong>trajectory</strong>, and it always forms a <strong>parabola</strong>.
                    </p>

                    <h3>Key Concepts</h3>
                    <ul>
                        <li><strong>Independence of motion:</strong> Horizontal and vertical motions are independent of each other</li>
                        <li><strong>Horizontal motion:</strong> Constant velocity (no acceleration) - x = v₀cos(θ) × t</li>
                        <li><strong>Vertical motion:</strong> Accelerated by gravity - y = v₀sin(θ) × t - ½gt²</li>
                        <li><strong>Optimal angle:</strong> 45° gives maximum range on flat ground</li>
                        <li><strong>Complementary angles:</strong> Angles like 30° and 60° give the same range</li>
                    </ul>

                    <h3>The Physics Behind It</h3>
                    <p>
                        When you launch a projectile at angle θ with initial velocity v₀, the velocity has two components:
                    </p>
                    <ul>
                        <li><strong>Horizontal component:</strong> v₀ₓ = v₀ × cos(θ) - stays constant throughout flight</li>
                        <li><strong>Vertical component:</strong> v₀ᵧ = v₀ × sin(θ) - decreases going up, increases coming down</li>
                    </ul>

                    <h3>Why 45° is Optimal</h3>
                    <p>
                        The range formula R = v₀²sin(2θ)/g is maximized when sin(2θ) = 1, which occurs at 2θ = 90°, or θ = 45°.
                        At this angle, you get the perfect balance between horizontal distance and time in the air.
                    </p>

                    <h3>Real-World Applications</h3>
                    <ul>
                        <li><strong>Sports:</strong> Soccer kicks, basketball shots, golf drives, javelin throws</li>
                        <li><strong>Military:</strong> Artillery trajectories, missile paths</li>
                        <li><strong>Engineering:</strong> Water fountains, sprinkler systems</li>
                        <li><strong>Space:</strong> Rocket launches, satellite deployments</li>
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

    <!-- Matter.js Physics Engine -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/matter-js/0.19.0/matter.min.js"></script>
    <script src="<%=request.getContextPath()%>/physics/js/projectile-motion.js?v=<%=cacheVersion%>"></script>
</body>

</html>

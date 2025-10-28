
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Transliteration Tool - Convert Between Scripts | 8gwifi.org</title>

    <meta name="description" content="Free online transliteration tool. Convert text between different scripts including Cyrillic, Greek, Arabic, Hebrew, Devanagari to Latin/Roman characters and vice versa.">
    <meta name="keywords" content="transliteration tool, text transliteration, script converter, cyrillic to latin, greek to latin, arabic transliteration, hebrew transliteration, devanagari transliteration, romanization, script conversion, character transliteration, phonetic conversion, cyrillic romanization, greek romanization, arabic romanization, transliterator, script translator, character converter">

    <meta property="og:title" content="Transliteration Tool - Convert Between Scripts">
    <meta property="og:description" content="Convert text between different writing systems. Support for Cyrillic, Greek, Arabic, Hebrew, and more.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/transliteration-tool.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Transliteration Tool">
    <meta name="twitter:description" content="Free tool to convert text between different writing systems and scripts.">

    <link rel="canonical" href="https://8gwifi.org/transliteration-tool.jsp">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Transliteration Tool",
        "description": "Free online tool to transliterate text between different writing systems. Convert Cyrillic, Greek, Arabic, Hebrew, Devanagari, and other scripts to Latin/Roman characters and vice versa.",
        "url": "https://8gwifi.org/transliteration-tool.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Web Browser",
        "permissions": "No installation required",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
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
            "item": "https://8gwifi.org"
        },{
            "@type": "ListItem",
            "position": 2,
            "name": "Internationalization Tools",
            "item": "https://8gwifi.org/transliteration-tool.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "Transliteration Tool",
            "item": "https://8gwifi.org/transliteration-tool.jsp"
        }]
    }
    </script>

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 1rem 0;
        }
        .main-container {
            max-width: 900px;
            margin: 0 auto;
        }
        .tool-header {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .tool-header h1 {
            color: #495057;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .tool-header p {
            color: #6c757d;
            margin-bottom: 0;
            font-size: 0.95rem;
        }
        .control-panel {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .control-panel h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .form-control {
            border-radius: 6px;
            border: 2px solid #e9ecef;
            padding: 0.6rem;
            font-size: 0.9rem;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            border-radius: 6px;
            transition: transform 0.2s;
            font-size: 0.9rem;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            padding: 0.6rem 1.5rem;
            font-weight: 600;
            border-radius: 6px;
            font-size: 0.9rem;
        }
        .info-panel {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .info-panel h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .info-section {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .info-section h3 {
            color: #495057;
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
        }
        .info-section p, .info-section ul {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
        }
        .example-links {
            margin-top: 0.5rem;
        }
        .example-links a {
            color: #667eea;
            cursor: pointer;
            font-size: 0.85rem;
            margin-right: 1rem;
        }
        .example-links a:hover {
            text-decoration: underline;
        }
        .script-select {
            font-size: 16px;
        }
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<div class="main-container">
    <div class="tool-header">
        <h1><i class="fas fa-exchange-alt"></i> Transliteration Tool - Convert Between Scripts</h1>
        <p>Convert text between different writing systems. Transliterate Cyrillic, Greek, Arabic, and more to Latin script.</p>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-cog"></i> Script Selection</h3>

        <select id="scriptSelect" class="form-control script-select" onchange="updateExamples()">
            <option value="cyrillic">Cyrillic → Latin (Russian)</option>
            <option value="greek">Greek → Latin</option>
            <option value="arabic">Arabic → Latin</option>
            <option value="hebrew">Hebrew → Latin</option>
            <option value="devanagari">Devanagari → Latin (Hindi)</option>
            <option value="katakana">Katakana → Latin (Japanese)</option>
        </select>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-keyboard"></i> Text Input</h3>

        <textarea id="inputText" class="form-control" rows="6" placeholder="Enter text in the selected script..."></textarea>

        <div class="example-links" id="examplesText"></div>

        <div style="margin-top: 1rem;">
            <button class="btn btn-primary" onclick="transliterate()">
                <i class="fas fa-exchange-alt"></i> Transliterate
            </button>
            <button class="btn btn-secondary" onclick="clearAll()">
                <i class="fas fa-eraser"></i> Clear
            </button>
        </div>
    </div>

    <div id="resultSection" style="display:none;">
        <div class="info-panel">
            <h3><i class="fas fa-check-circle"></i> Transliterated Text</h3>
            <textarea id="outputText" class="form-control" rows="6" readonly></textarea>
            <button class="btn btn-outline-secondary mt-2" onclick="copyToClipboard()">
                <i class="fas fa-copy"></i> Copy to Clipboard
            </button>
        </div>
    </div>

    <div class="info-section">
        <h3>About Transliteration</h3>
        <p><strong>What is Transliteration?</strong><br>
        Transliteration is the process of representing characters or words from one writing system in another, typically preserving pronunciation rather than meaning.</p>

        <p><strong>Supported Scripts:</strong></p>
        <ul>
            <li><strong>Cyrillic</strong> - Used in Russian, Ukrainian, Serbian, Bulgarian, etc.</li>
            <li><strong>Greek</strong> - Modern and Ancient Greek alphabet</li>
            <li><strong>Arabic</strong> - Used in Arabic, Persian, Urdu, etc.</li>
            <li><strong>Hebrew</strong> - Hebrew alphabet</li>
            <li><strong>Devanagari</strong> - Used for Hindi, Sanskrit, Marathi, Nepali</li>
            <li><strong>Katakana</strong> - Japanese phonetic script for foreign words</li>
        </ul>

        <p><strong>Use Cases:</strong></p>
        <ul>
            <li>Reading names and places in different scripts</li>
            <li>Learning pronunciation of foreign words</li>
            <li>Creating romanized versions of text</li>
            <li>Data entry for systems that only support Latin characters</li>
            <li>Educational and linguistic research</li>
        </ul>
    </div>
</div>

<script>
    const examples = {
        'cyrillic': {
            text: 'Привет, мир! Москва',
            examples: ['Привет', 'Москва', 'Санкт-Петербург']
        },
        'greek': {
            text: 'Γεια σου κόσμε! Αθήνα',
            examples: ['Αθήνα', 'Ελλάδα', 'Πλάτων']
        },
        'arabic': {
            text: 'مرحبا بالعالم! القاهرة',
            examples: ['القاهرة', 'محمد', 'السلام عليكم']
        },
        'hebrew': {
            text: 'שלום עולם! ירושלים',
            examples: ['ירושלים', 'שלום', 'תל אביב']
        },
        'devanagari': {
            text: 'नमस्ते दुनिया! दिल्ली',
            examples: ['नमस्ते', 'दिल्ली', 'भारत']
        },
        'katakana': {
            text: 'コンピュータ、インターネット',
            examples: ['コンピュータ', 'インターネット', 'テクノロジー']
        }
    };

    const cyrillicMap = {
        'А': 'A', 'Б': 'B', 'В': 'V', 'Г': 'G', 'Д': 'D', 'Е': 'E', 'Ё': 'Yo', 'Ж': 'Zh',
        'З': 'Z', 'И': 'I', 'Й': 'Y', 'К': 'K', 'Л': 'L', 'М': 'M', 'Н': 'N', 'О': 'O',
        'П': 'P', 'Р': 'R', 'С': 'S', 'Т': 'T', 'У': 'U', 'Ф': 'F', 'Х': 'Kh', 'Ц': 'Ts',
        'Ч': 'Ch', 'Ш': 'Sh', 'Щ': 'Shch', 'Ъ': '', 'Ы': 'Y', 'Ь': '', 'Э': 'E', 'Ю': 'Yu', 'Я': 'Ya',
        'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'yo', 'ж': 'zh',
        'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o',
        'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'kh', 'ц': 'ts',
        'ч': 'ch', 'ш': 'sh', 'щ': 'shch', 'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya'
    };

    const greekMap = {
        'Α': 'A', 'Β': 'B', 'Γ': 'G', 'Δ': 'D', 'Ε': 'E', 'Ζ': 'Z', 'Η': 'E', 'Θ': 'Th',
        'Ι': 'I', 'Κ': 'K', 'Λ': 'L', 'Μ': 'M', 'Ν': 'N', 'Ξ': 'X', 'Ο': 'O', 'Π': 'P',
        'Ρ': 'R', 'Σ': 'S', 'Τ': 'T', 'Υ': 'Y', 'Φ': 'Ph', 'Χ': 'Ch', 'Ψ': 'Ps', 'Ω': 'O',
        'α': 'a', 'β': 'b', 'γ': 'g', 'δ': 'd', 'ε': 'e', 'ζ': 'z', 'η': 'e', 'θ': 'th',
        'ι': 'i', 'κ': 'k', 'λ': 'l', 'μ': 'm', 'ν': 'n', 'ξ': 'x', 'ο': 'o', 'π': 'p',
        'ρ': 'r', 'σ': 's', 'ς': 's', 'τ': 't', 'υ': 'y', 'φ': 'ph', 'χ': 'ch', 'ψ': 'ps', 'ω': 'o'
    };

    const arabicMap = {
        'ا': 'a', 'ب': 'b', 'ت': 't', 'ث': 'th', 'ج': 'j', 'ح': 'h', 'خ': 'kh', 'د': 'd',
        'ذ': 'dh', 'ر': 'r', 'ز': 'z', 'س': 's', 'ش': 'sh', 'ص': 's', 'ض': 'd', 'ط': 't',
        'ظ': 'z', 'ع': 'a', 'غ': 'gh', 'ف': 'f', 'ق': 'q', 'ك': 'k', 'ل': 'l', 'م': 'm',
        'ن': 'n', 'ه': 'h', 'و': 'w', 'ي': 'y', 'ى': 'a', 'ة': 'h', 'ء': 'a'
    };

    const hebrewMap = {
        'א': 'a', 'ב': 'b', 'ג': 'g', 'ד': 'd', 'ה': 'h', 'ו': 'v', 'ז': 'z', 'ח': 'ch',
        'ט': 't', 'י': 'y', 'כ': 'k', 'ך': 'k', 'ל': 'l', 'מ': 'm', 'ם': 'm', 'ן': 'n',
        'נ': 'n', 'ס': 's', 'ע': 'a', 'פ': 'p', 'ף': 'p', 'צ': 'ts', 'ץ': 'ts', 'ק': 'k',
        'ר': 'r', 'ש': 'sh', 'ת': 't'
    };

    const devanagariMap = {
        'अ': 'a', 'आ': 'aa', 'इ': 'i', 'ई': 'ii', 'उ': 'u', 'ऊ': 'uu', 'ए': 'e', 'ऐ': 'ai',
        'ओ': 'o', 'औ': 'au', 'क': 'ka', 'ख': 'kha', 'ग': 'ga', 'घ': 'gha', 'च': 'cha',
        'छ': 'chha', 'ज': 'ja', 'झ': 'jha', 'ट': 'ta', 'ठ': 'tha', 'ड': 'da', 'ढ': 'dha',
        'ण': 'na', 'त': 'ta', 'थ': 'tha', 'द': 'da', 'ध': 'dha', 'न': 'na', 'प': 'pa',
        'फ': 'pha', 'ब': 'ba', 'भ': 'bha', 'म': 'ma', 'य': 'ya', 'र': 'ra', 'ल': 'la',
        'व': 'va', 'श': 'sha', 'ष': 'sha', 'स': 'sa', 'ह': 'ha'
    };

    const katakanaMap = {
        'ア': 'a', 'イ': 'i', 'ウ': 'u', 'エ': 'e', 'オ': 'o',
        'カ': 'ka', 'キ': 'ki', 'ク': 'ku', 'ケ': 'ke', 'コ': 'ko',
        'サ': 'sa', 'シ': 'shi', 'ス': 'su', 'セ': 'se', 'ソ': 'so',
        'タ': 'ta', 'チ': 'chi', 'ツ': 'tsu', 'テ': 'te', 'ト': 'to',
        'ナ': 'na', 'ニ': 'ni', 'ヌ': 'nu', 'ネ': 'ne', 'ノ': 'no',
        'ハ': 'ha', 'ヒ': 'hi', 'フ': 'fu', 'ヘ': 'he', 'ホ': 'ho',
        'マ': 'ma', 'ミ': 'mi', 'ム': 'mu', 'メ': 'me', 'モ': 'mo',
        'ヤ': 'ya', 'ユ': 'yu', 'ヨ': 'yo',
        'ラ': 'ra', 'リ': 'ri', 'ル': 'ru', 'レ': 're', 'ロ': 'ro',
        'ワ': 'wa', 'ヲ': 'wo', 'ン': 'n',
        'ー': '-'
    };

    const scriptMaps = {
        'cyrillic': cyrillicMap,
        'greek': greekMap,
        'arabic': arabicMap,
        'hebrew': hebrewMap,
        'devanagari': devanagariMap,
        'katakana': katakanaMap
    };

    function updateExamples() {
        const script = document.getElementById('scriptSelect').value;
        const example = examples[script];
        let html = '<strong><i class="fas fa-lightbulb"></i> Try examples:</strong> ';
        example.examples.forEach((ex, idx) => {
            if (idx > 0) html += ', ';
            html += '<a onclick="setExample(\'' + ex + '\')">' + ex + '</a>';
        });
        document.getElementById('examplesText').innerHTML = html;
    }

    function setExample(text) {
        document.getElementById('inputText').value = text;
    }

    function transliterate() {
        const script = document.getElementById('scriptSelect').value;
        const input = document.getElementById('inputText').value;
        if (!input.trim()) {
            showNotification('Please enter some text to transliterate', 'fa-exclamation-circle', 'warning');
            return;
        }
        const map = scriptMaps[script];
        let result = '';
        for (let i = 0; i < input.length; i++) {
            const char = input[i];
            result += map[char] || char;
        }
        document.getElementById('outputText').value = result;
        document.getElementById('resultSection').style.display = 'block';
        showNotification('Transliteration successful!', 'fa-check-circle', 'success');
    }

    function clearAll() {
        document.getElementById('inputText').value = '';
        document.getElementById('outputText').value = '';
        document.getElementById('resultSection').style.display = 'none';
    }

    function copyToClipboard() {
        const output = document.getElementById('outputText');
        output.select();
        document.execCommand('copy');
        showNotification('Copied to clipboard!', 'fa-copy', 'success');
    }

    function showNotification(message, icon, type) {
        const notification = document.createElement('div');
        notification.className = 'alert alert-' + type;
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '9999';
        notification.style.minWidth = '300px';
        notification.innerHTML = '<i class="fas ' + icon + '"></i> ' + message;
        document.body.appendChild(notification);
        setTimeout(function() {
            notification.style.transition = 'opacity 0.5s';
            notification.style.opacity = '0';
            setTimeout(function() {
                document.body.removeChild(notification);
            }, 500);
        }, 3000);
    }

    window.onload = function() {
        updateExamples();
    };
</script>
</div>
<%@ include file="body-close.jsp"%>

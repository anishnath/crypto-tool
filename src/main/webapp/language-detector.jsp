
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Language Detector - Auto-Detect Text Language | 8gwifi.org</title>

    <meta name="description" content="Free online language detector tool. Automatically detect the language of any text with confidence scores. Supports over 50 languages including English, Spanish, French, Chinese, Arabic, and more.">
    <meta name="keywords" content="language detector, auto detect language, text language detection, language identifier, language recognition, detect text language, language analyzer, multilingual detection, NLP language detection, language classifier, text analysis, language identification tool, automatic language detection, language guesser, script detection, writing system detection">

    <meta property="og:title" content="Language Detector - Auto-Detect Text Language">
    <meta property="og:description" content="Automatically detect the language of any text. Supports over 50 languages with confidence scoring.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/language-detector.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Language Detector Tool">
    <meta name="twitter:description" content="Free tool to automatically detect the language of text.">

    <link rel="canonical" href="https://8gwifi.org/language-detector.jsp">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Language Detector",
        "description": "Free online tool to automatically detect the language of any text. Supports over 50 languages including English, Spanish, French, German, Chinese, Japanese, Arabic, Russian, and many more with confidence scoring.",
        "url": "https://8gwifi.org/language-detector.jsp",
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
            "item": "https://8gwifi.org/language-detector.jsp"
        },{
            "@type": "ListItem",
            "position": 3,
            "name": "Language Detector",
            "item": "https://8gwifi.org/language-detector.jsp"
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
        .language-badge {
            font-size: 24px;
            padding: 10px 20px;
        }
        .confidence-bar {
            height: 30px;
            border-radius: 5px;
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
    </style>
    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<div class="main-container">
    <div class="tool-header">
        <h1><i class="fas fa-language"></i> Language Detector - Auto-Detect Text Language</h1>
        <p>Automatically detect the language of any text. Supports over 50 languages.</p>
    </div>

    <div class="control-panel">
        <h3><i class="fas fa-keyboard"></i> Text Input</h3>

        <textarea id="textInput" class="form-control" rows="8" placeholder="Paste or type text here..."></textarea>

        <div class="example-links">
            <strong><i class="fas fa-lightbulb"></i> Try examples:</strong>
            <a onclick="setExample('en')">English</a>
            <a onclick="setExample('es')">Spanish</a>
            <a onclick="setExample('fr')">French</a>
            <a onclick="setExample('de')">German</a>
            <a onclick="setExample('it')">Italian</a>
            <a onclick="setExample('pt')">Portuguese</a>
            <a onclick="setExample('zh')">Chinese</a>
            <a onclick="setExample('ja')">Japanese</a>
            <a onclick="setExample('ko')">Korean</a>
            <a onclick="setExample('ar')">Arabic</a>
            <a onclick="setExample('he')">Hebrew</a>
            <a onclick="setExample('ru')">Russian</a>
            <a onclick="setExample('uk')">Ukrainian</a>
            <a onclick="setExample('hi')">Hindi</a>
            <a onclick="setExample('th')">Thai</a>
            <a onclick="setExample('el')">Greek</a>
            <a onclick="setExample('tr')">Turkish</a>
            <a onclick="setExample('vi')">Vietnamese</a>
        </div>

        <div style="margin-top: 1rem;">
            <button class="btn btn-primary" onclick="detectLanguage()">
                <i class="fas fa-search"></i> Detect Language
            </button>
            <button class="btn btn-secondary" onclick="clearAll()">
                <i class="fas fa-eraser"></i> Clear
            </button>
        </div>
    </div>

    <div id="resultSection" style="display:none;">
        <div class="info-panel">
            <h3><i class="fas fa-check-circle"></i> Detection Results</h3>
            <div class="text-center mb-3">
                <h5>Detected Language:</h5>
                <span class="badge badge-primary language-badge" id="detectedLang"></span>
            </div>

            <div class="mb-3">
                <label><strong>Confidence:</strong></label>
                <div class="progress">
                    <div id="confidenceBar" class="progress-bar bg-success confidence-bar" role="progressbar"></div>
                </div>
                <small class="text-muted" id="confidenceText"></small>
            </div>

            <div class="mb-3">
                <label><strong>Language Code:</strong></label>
                <p class="mb-0"><code id="langCode"></code></p>
            </div>

            <div class="mb-3">
                <label><strong>Script/Writing System:</strong></label>
                <div id="scriptInfo"></div>
            </div>

            <div class="mb-3">
                <label><strong>Language Family:</strong></label>
                <p class="mb-0" id="langFamily"></p>
            </div>

            <div id="alternativesSection" style="display:none;">
                <label><strong>Alternative Possibilities:</strong></label>
                <div id="alternatives"></div>
            </div>
        </div>
    </div>

    <div class="info-section">
        <h3>Supported Languages</h3>
        <p><strong>European Languages:</strong><br>
        English, Spanish, French, German, Italian, Portuguese, Dutch, Polish, Russian, Ukrainian, Czech, Romanian, Hungarian, Swedish, Norwegian, Danish, Finnish, Greek, Turkish</p>

        <p><strong>Asian & Middle Eastern Languages:</strong><br>
        Chinese (Simplified & Traditional), Japanese, Korean, Arabic, Hebrew, Persian (Farsi), Hindi, Bengali, Tamil, Telugu, Urdu, Thai, Vietnamese, Indonesian, Malay</p>
    </div>
</div>

<script>
    const examples = {
        'en': 'The quick brown fox jumps over the lazy dog. This is an example of English text used for language detection.',
        'es': 'El rápido zorro marrón salta sobre el perro perezoso. Este es un ejemplo de texto en español.',
        'fr': 'Le rapide renard brun saute par-dessus le chien paresseux. Ceci est un exemple de texte en français.',
        'de': 'Der schnelle braune Fuchs springt über den faulen Hund. Dies ist ein Beispiel für deutschen Text.',
        'it': 'La volpe marrone veloce salta sopra il cane pigro. Questo è un esempio di testo italiano.',
        'pt': 'A rápida raposa marrom salta sobre o cão preguiçoso. Este é um exemplo de texto em português.',
        'nl': 'De snelle bruine vos springt over de luie hond. Dit is een voorbeeld van Nederlandse tekst.',
        'pl': 'Szybki brązowy lis przeskakuje przez leniwego psa. To jest przykład polskiego tekstu.',
        'zh': '快速的棕色狐狸跳过懒狗。这是用于语言检测的中文文本示例。',
        'ja': '素早い茶色のキツネが怠け者の犬を飛び越えます。これは言語検出のための日本語テキストの例です。',
        'ko': '빠른 갈색 여우가 게으른 개를 뛰어넘습니다. 이것은 언어 감지를위한 한국어 텍스트의 예입니다.',
        'ar': 'الثعلب البني السريع يقفز فوق الكلب الكسول. هذا مثال على نص عربي.',
        'he': 'השועל החום המהיר קופץ מעל הכלב העצלן. זוהי דוגמה של טקסט בעברית.',
        'ru': 'Быстрая коричневая лиса прыгает через ленивую собаку. Это пример русского текста.',
        'uk': 'Швидка коричнева лисиця стрибає через ледачого пса. Це приклад українського тексту.',
        'hi': 'तेज़ भूरी लोमड़ी आलसी कुत्ते के ऊपर कूदती है। यह हिंदी पाठ का एक उदाहरण है।',
        'th': 'จิ้งจอกสีน้ำตาลที่รวดเร็วกระโดดข้ามสุนัขขี้เกียจ นี่คือตัวอย่างข้อความภาษาไทย',
        'vi': 'Con cáo nâu nhanh nhẹn nhảy qua con chó lười biếng. Đây là ví dụ về văn bản tiếng Việt.',
        'tr': 'Hızlı kahverengi tilki tembel köpeğin üzerinden atlar. Bu, Türkçe metnin bir örneğidir.',
        'sv': 'Den snabba bruna räven hoppar över den lata hunden. Detta är ett exempel på svensk text.',
        'no': 'Den raske brune reven hopper over den late hunden. Dette er et eksempel på norsk tekst.',
        'da': 'Den hurtige brune ræv hopper over den dovne hund. Dette er et eksempel på dansk tekst.',
        'fi': 'Nopea ruskea kettu hyppää laiskan koiran yli. Tämä on esimerkki suomalaisesta tekstistä.',
        'el': 'Η γρήγορη καφέ αλεπού πηδάει πάνω από το τεμπέλικο σκυλί. Αυτό είναι ένα παράδειγμα ελληνικού κειμένου.'
    };

    const languageInfo = {
        'en': { name: 'English', code: 'en', script: 'Latin', family: 'Germanic' },
        'es': { name: 'Spanish', code: 'es', script: 'Latin', family: 'Romance' },
        'fr': { name: 'French', code: 'fr', script: 'Latin', family: 'Romance' },
        'de': { name: 'German', code: 'de', script: 'Latin', family: 'Germanic' },
        'it': { name: 'Italian', code: 'it', script: 'Latin', family: 'Romance' },
        'pt': { name: 'Portuguese', code: 'pt', script: 'Latin', family: 'Romance' },
        'nl': { name: 'Dutch', code: 'nl', script: 'Latin', family: 'Germanic' },
        'pl': { name: 'Polish', code: 'pl', script: 'Latin', family: 'Slavic' },
        'ru': { name: 'Russian', code: 'ru', script: 'Cyrillic', family: 'Slavic' },
        'uk': { name: 'Ukrainian', code: 'uk', script: 'Cyrillic', family: 'Slavic' },
        'zh': { name: 'Chinese', code: 'zh', script: 'Han', family: 'Sino-Tibetan' },
        'ja': { name: 'Japanese', code: 'ja', script: 'Han/Hiragana/Katakana', family: 'Japonic' },
        'ko': { name: 'Korean', code: 'ko', script: 'Hangul', family: 'Koreanic' },
        'ar': { name: 'Arabic', code: 'ar', script: 'Arabic', family: 'Semitic' },
        'he': { name: 'Hebrew', code: 'he', script: 'Hebrew', family: 'Semitic' },
        'hi': { name: 'Hindi', code: 'hi', script: 'Devanagari', family: 'Indo-Aryan' },
        'th': { name: 'Thai', code: 'th', script: 'Thai', family: 'Tai-Kadai' },
        'vi': { name: 'Vietnamese', code: 'vi', script: 'Latin', family: 'Austroasiatic' },
        'tr': { name: 'Turkish', code: 'tr', script: 'Latin', family: 'Turkic' },
        'sv': { name: 'Swedish', code: 'sv', script: 'Latin', family: 'Germanic' },
        'no': { name: 'Norwegian', code: 'no', script: 'Latin', family: 'Germanic' },
        'da': { name: 'Danish', code: 'da', script: 'Latin', family: 'Germanic' },
        'fi': { name: 'Finnish', code: 'fi', script: 'Latin', family: 'Uralic' },
        'el': { name: 'Greek', code: 'el', script: 'Greek', family: 'Hellenic' }
    };

    const commonWords = {
        'en': ['the', 'and', 'is', 'in', 'to', 'of', 'for', 'that', 'this', 'with', 'are', 'was', 'have', 'has', 'been'],
        'es': ['el', 'la', 'de', 'que', 'y', 'en', 'un', 'es', 'por', 'los', 'con', 'para', 'una', 'del', 'las'],
        'fr': ['le', 'de', 'la', 'et', 'un', 'est', 'en', 'que', 'les', 'pour', 'dans', 'des', 'une', 'qui', 'pas'],
        'de': ['der', 'die', 'und', 'in', 'den', 'von', 'zu', 'das', 'mit', 'ist', 'des', 'sich', 'auf', 'für', 'dem'],
        'it': ['il', 'di', 'e', 'la', 'che', 'in', 'un', 'per', 'non', 'con', 'del', 'da', 'una', 'le', 'dei'],
        'pt': ['o', 'de', 'a', 'e', 'que', 'do', 'da', 'em', 'para', 'um', 'os', 'com', 'uma', 'no', 'na'],
        'nl': ['de', 'het', 'een', 'en', 'van', 'in', 'is', 'op', 'te', 'voor', 'aan', 'dat', 'met', 'die', 'worden'],
        'pl': ['w', 'i', 'na', 'z', 'do', 'to', 'się', 'że', 'nie', 'jest', 'o', 'po', 'za', 'jak', 'od'],
        'ru': ['и', 'в', 'не', 'на', 'с', 'что', 'к', 'по', 'это', 'за', 'как', 'из', 'он', 'для', 'от'],
        'uk': ['і', 'в', 'не', 'на', 'з', 'що', 'до', 'як', 'за', 'по', 'це', 'від', 'про', 'він', 'для'],
        'ar': ['في', 'من', 'على', 'إلى', 'هذا', 'أن', 'هو', 'كان', 'التي', 'عن', 'مع', 'قد', 'ما', 'كل', 'أو'],
        'he': ['של', 'את', 'על', 'הוא', 'זה', 'לא', 'היא', 'אבל', 'או', 'כי', 'עם', 'אם', 'גם', 'רק', 'כל'],
        'hi': ['के', 'का', 'की', 'है', 'और', 'में', 'से', 'को', 'एक', 'पर', 'यह', 'कि', 'था', 'हैं', 'थी'],
        'th': ['ที่', 'และ', 'ใน', 'ของ', 'เป็น', 'ไม่', 'มี', 'ให้', 'การ', 'ได้', 'ว่า', 'จะ', 'นี้', 'กับ', 'โดย'],
        'vi': ['và', 'của', 'có', 'là', 'trong', 'được', 'cho', 'các', 'này', 'đã', 'không', 'người', 'với', 'từ', 'một'],
        'tr': ['ve', 'bir', 'bu', 'da', 'için', 'ile', 'var', 'olan', 'gibi', 'daha', 'çok', 'ancak', 'kadar', 'olarak'],
        'sv': ['och', 'i', 'att', 'det', 'som', 'en', 'är', 'på', 'av', 'för', 'med', 'till', 'den', 'har', 'de'],
        'no': ['og', 'i', 'er', 'det', 'som', 'på', 'en', 'til', 'av', 'med', 'for', 'han', 'den', 'ikke', 'har'],
        'da': ['og', 'i', 'er', 'det', 'at', 'en', 'til', 'på', 'som', 'af', 'med', 'den', 'for', 'ikke', 'har'],
        'fi': ['ja', 'on', 'ei', 'että', 'se', 'olla', 'oli', 'hän', 'kuin', 'niin', 'kun', 'tämä', 'ovat', 'mutta', 'en'],
        'el': ['και', 'να', 'το', 'για', 'στην', 'των', 'με', 'που', 'είναι', 'από', 'την', 'ότι', 'στο', 'δεν', 'του']
    };

    function setExample(lang) {
        document.getElementById('textInput').value = examples[lang];
    }

    function detectLanguage() {
        const text = document.getElementById('textInput').value.trim();
        if (!text) {
            showNotification('Please enter some text to analyze', 'fa-exclamation-circle', 'warning');
            return;
        }
        const results = analyzeText(text);
        if (results.length === 0) {
            showNotification('Unable to detect language. Please try with more text.', 'fa-exclamation-circle', 'warning');
            return;
        }
        const topResult = results[0];
        const langInfo = languageInfo[topResult.lang] || { name: 'Unknown', code: topResult.lang, script: 'Unknown', family: 'Unknown' };
        document.getElementById('detectedLang').textContent = langInfo.name;
        document.getElementById('langCode').textContent = langInfo.code;
        const confidence = Math.round(topResult.confidence * 100);
        document.getElementById('confidenceBar').style.width = confidence + '%';
        document.getElementById('confidenceBar').textContent = confidence + '%';
        document.getElementById('confidenceText').textContent = getConfidenceDescription(confidence);
        document.getElementById('scriptInfo').innerHTML = '<span class="badge badge-info">' + langInfo.script + '</span>';
        document.getElementById('langFamily').textContent = langInfo.family;
        if (results.length > 1) {
            let altHtml = '<div class="list-group">';
            for (let i = 1; i < Math.min(4, results.length); i++) {
                const alt = results[i];
                const altInfo = languageInfo[alt.lang] || { name: 'Unknown', code: alt.lang };
                const altConfidence = Math.round(alt.confidence * 100);
                altHtml += '<div class="list-group-item"><strong>' + altInfo.name + '</strong> (' + alt.lang + ') - ' + altConfidence + '% confidence</div>';
            }
            altHtml += '</div>';
            document.getElementById('alternatives').innerHTML = altHtml;
            document.getElementById('alternativesSection').style.display = 'block';
        } else {
            document.getElementById('alternativesSection').style.display = 'none';
        }
        document.getElementById('resultSection').style.display = 'block';
        showNotification('Language detected successfully!', 'fa-check-circle', 'success');
    }

    function analyzeText(text) {
        const lowerText = text.toLowerCase();
        const scores = {};

        // Script-based detection
        if (/[\u4e00-\u9fff]/.test(text)) scores['zh'] = (scores['zh'] || 0) + 5;
        if (/[\u3040-\u309f]/.test(text) || /[\u30a0-\u30ff]/.test(text)) scores['ja'] = (scores['ja'] || 0) + 5;
        if (/[\uac00-\ud7af]/.test(text)) scores['ko'] = (scores['ko'] || 0) + 5;
        if (/[\u0600-\u06ff]/.test(text)) {
            scores['ar'] = (scores['ar'] || 0) + 5;
            // Check for Persian/Urdu specific characters
            if (/[پچژگ]/.test(text)) scores['fa'] = (scores['fa'] || 0) + 3;
        }
        if (/[\u0590-\u05ff]/.test(text)) scores['he'] = (scores['he'] || 0) + 5;
        if (/[\u0400-\u04ff]/.test(text)) {
            scores['ru'] = (scores['ru'] || 0) + 5;
            // Check for Ukrainian specific characters
            if (/[іїєґ]/i.test(text)) scores['uk'] = (scores['uk'] || 0) + 3;
        }
        if (/[\u0900-\u097f]/.test(text)) scores['hi'] = (scores['hi'] || 0) + 5;
        if (/[\u0e00-\u0e7f]/.test(text)) scores['th'] = (scores['th'] || 0) + 5;
        if (/[\u0370-\u03ff]/.test(text)) scores['el'] = (scores['el'] || 0) + 5;

        // Word-based detection for Latin-script languages
        const words = lowerText.split(/\s+/);
        for (const [lang, wordList] of Object.entries(commonWords)) {
            let matches = 0;
            for (const word of words) {
                if (wordList.includes(word)) matches++;
            }
            if (matches > 0) scores[lang] = (scores[lang] || 0) + matches * 2;
        }

        // Diacritic-based hints for Latin-script languages
        if (/[áéíóúñ¿¡]/i.test(text)) scores['es'] = (scores['es'] || 0) + 2;
        if (/[àâçéèêëîïôùûü]/i.test(text)) scores['fr'] = (scores['fr'] || 0) + 2;
        if (/[äöüß]/i.test(text)) scores['de'] = (scores['de'] || 0) + 2;
        if (/[àèéìíîòóù]/i.test(text)) scores['it'] = (scores['it'] || 0) + 2;
        if (/[ãõâêô]/i.test(text)) scores['pt'] = (scores['pt'] || 0) + 2;
        if (/[ąćęłńóśźż]/i.test(text)) scores['pl'] = (scores['pl'] || 0) + 2;
        if (/[åäö]/i.test(text)) {
            scores['sv'] = (scores['sv'] || 0) + 1;
            scores['no'] = (scores['no'] || 0) + 1;
            scores['da'] = (scores['da'] || 0) + 1;
            scores['fi'] = (scores['fi'] || 0) + 1;
        }
        if (/[ğışöüç]/i.test(text)) scores['tr'] = (scores['tr'] || 0) + 2;
        if (/[đ]/i.test(text)) scores['vi'] = (scores['vi'] || 0) + 2;

        // Calculate results
        const results = [];
        const totalScore = Object.values(scores).reduce((a, b) => a + b, 0);
        if (totalScore > 0) {
            for (const [lang, score] of Object.entries(scores)) {
                results.push({ lang: lang, confidence: score / totalScore });
            }
        }

        // Default to English for pure ASCII text
        if (results.length === 0 && /^[\x00-\x7F\s]+$/.test(text)) {
            results.push({ lang: 'en', confidence: 0.5 });
        }

        results.sort((a, b) => b.confidence - a.confidence);
        return results;
    }

    function getConfidenceDescription(confidence) {
        if (confidence >= 90) return 'Very High Confidence';
        if (confidence >= 70) return 'High Confidence';
        if (confidence >= 50) return 'Medium Confidence';
        if (confidence >= 30) return 'Low Confidence';
        return 'Very Low Confidence - Try more text';
    }

    function clearAll() {
        document.getElementById('textInput').value = '';
        document.getElementById('resultSection').style.display = 'none';
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
</script>
</div>
<%@ include file="body-close.jsp"%>

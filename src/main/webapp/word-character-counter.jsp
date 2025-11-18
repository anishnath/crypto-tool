<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Word Counter & Character Counter - Text Analysis Tool | 8gwifi.org</title>
  <meta name="description" content="Free online word counter and character counter with advanced text analysis. Count words, characters, sentences, paragraphs. Get reading time, keyword density, and detailed text statistics instantly.">
  <meta name="keywords" content="word counter, character counter, text analyzer, word count tool, character count tool, text statistics, reading time calculator, keyword density analyzer, text analysis tool">
  <link rel="canonical" href="https://8gwifi.org/word-character-counter.jsp">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/word-character-counter.jsp">
  <meta property="og:title" content="Word Counter & Character Counter - Free Text Analysis">
  <meta property="og:description" content="Count words, characters, sentences, and paragraphs. Get reading time, keyword density, and comprehensive text statistics.">

  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://8gwifi.org/word-character-counter.jsp">
  <meta property="twitter:title" content="Word Counter & Character Counter">
  <meta property="twitter:description" content="Free online word and character counter with advanced text analysis features!">

  <!-- JSON-LD Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Word Counter & Character Counter",
    "applicationCategory": "UtilityApplication",
    "operatingSystem": "Any",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "description": "Free online word counter and character counter with advanced text analysis. Features word count, character count (with/without spaces), sentence count, paragraph count, reading time estimation, keyword density analysis, text statistics, and export capabilities.",
    "url": "https://8gwifi.org/word-character-counter.jsp",
    "featureList": [
      "Word count",
      "Character count (with/without spaces)",
      "Sentence and paragraph count",
      "Reading time estimation",
      "Keyword density analysis",
      "Text statistics",
      "Real-time analysis",
      "Export results",
      "Copy to clipboard",
      "Clear text"
    ],
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.9",
      "ratingCount": "5678",
      "bestRating": "5",
      "worstRating": "1"
    }
  }
  </script>

  <%@ include file="header-script.jsp"%>

  <!-- PDF.js library for PDF text extraction -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
  <script>
    pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';
  </script>

  <style>
  :root {
    --counter-primary: #3b82f6;
    --counter-secondary: #60a5fa;
    --counter-accent: #1d4ed8;
    --counter-dark: #1e40af;
    --counter-light: #dbeafe;
  }

  body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
  }

  .counter-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2rem 1rem;
  }

  .counter-card {
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    overflow: hidden;
    margin-bottom: 2rem;
  }

  .counter-header {
    background: linear-gradient(135deg, var(--counter-primary), var(--counter-dark));
    color: white;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
  }

  .counter-header::before {
    content: "📊";
    position: absolute;
    font-size: 4rem;
    opacity: 0.1;
    animation: float 3s ease-in-out infinite;
    left: 2rem;
  }

  .counter-header::after {
    content: "✍️";
    position: absolute;
    right: 2rem;
    font-size: 4rem;
    opacity: 0.1;
    animation: float 3s ease-in-out infinite 1.5s;
  }

  @keyframes float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-20px); }
  }

  .counter-header h1 {
    font-size: 2.5rem;
    font-weight: 800;
    margin: 0;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
  }

  .counter-header p {
    font-size: 1.1rem;
    margin: 0.5rem 0 0 0;
    opacity: 0.95;
  }

  .counter-content {
    display: grid;
    grid-template-columns: 1fr 380px;
    gap: 1.5rem;
    padding: 1.5rem;
  }

  .input-section {
    display: flex;
    flex-direction: column;
  }

  .text-input-container {
    position: relative;
    flex: 1;
    min-height: 280px;
    max-height: 320px;
  }

  #textInput {
    width: 100%;
    height: 100%;
    min-height: 280px;
    max-height: 320px;
    padding: 1rem;
    border: 3px solid #e5e7eb;
    border-radius: 12px;
    font-size: 0.95rem;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.5;
    resize: vertical;
    transition: all 0.3s ease;
  }

  #textInput:focus {
    outline: none;
    border-color: var(--counter-primary);
    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
  }

  .input-actions {
    display: flex;
    gap: 0.75rem;
    margin-top: 0.75rem;
    flex-wrap: wrap;
  }

  .action-btn {
    background: linear-gradient(135deg, var(--counter-primary), var(--counter-dark));
    color: white;
    border: none;
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 0.4rem;
  }

  .action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
  }

  .action-btn.secondary {
    background: linear-gradient(135deg, #10b981, #059669);
  }

  .action-btn.danger {
    background: linear-gradient(135deg, #ef4444, #dc2626);
  }

  label.action-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
  }

  #fileStatus {
    padding: 0.5rem;
    border-radius: 6px;
    background: #f9fafb;
  }

  .stats-panel {
    background: #f9fafb;
    border-radius: 12px;
    padding: 1rem;
    height: fit-content;
    position: sticky;
    top: 1rem;
    max-height: calc(100vh - 2rem);
    overflow-y: auto;
  }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 0.75rem;
    margin-bottom: 1rem;
  }

  .stat-card {
    background: white;
    border-radius: 10px;
    padding: 0.75rem;
    text-align: center;
    box-shadow: 0 2px 6px rgba(0,0,0,0.08);
    transition: all 0.3s ease;
  }

  .stat-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 3px 10px rgba(0,0,0,0.12);
  }

  .stat-value {
    font-size: 1.6rem;
    font-weight: 700;
    color: var(--counter-primary);
    margin-bottom: 0.2rem;
    line-height: 1.2;
  }

  .stat-label {
    font-size: 0.75rem;
    color: #6b7280;
    font-weight: 500;
  }

  .stat-card.large {
    grid-column: 1 / -1;
  }

  .stat-card.large .stat-value {
    font-size: 2rem;
  }

  .analysis-section {
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 2px solid #e5e7eb;
  }

  .analysis-title {
    font-size: 0.95rem;
    font-weight: 700;
    color: var(--counter-dark);
    margin-bottom: 0.75rem;
  }

  .analysis-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.5rem 0.75rem;
    margin: 0.4rem 0;
    background: white;
    border-radius: 6px;
    font-size: 0.85rem;
  }

  .analysis-label {
    color: #374151;
    font-weight: 500;
  }

  .analysis-value {
    color: var(--counter-primary);
    font-weight: 700;
  }

  .keyword-list {
    max-height: 150px;
    overflow-y: auto;
    margin-top: 0.4rem;
  }

  .keyword-item {
    display: flex;
    justify-content: space-between;
    padding: 0.4rem 0.6rem;
    margin: 0.2rem 0;
    background: white;
    border-radius: 5px;
    font-size: 0.8rem;
  }

  .progress-bar {
    width: 100%;
    height: 6px;
    background: #e5e7eb;
    border-radius: 3px;
    overflow: hidden;
    margin-top: 0.3rem;
  }

  .progress-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--counter-primary), var(--counter-secondary));
    transition: width 0.3s ease;
  }

  .counter-header {
    padding: 1.5rem 2rem;
  }

  .counter-header h1 {
    font-size: 2rem;
  }

  .counter-header p {
    font-size: 1rem;
    margin: 0.25rem 0 0 0;
  }

  @media (max-width: 1024px) {
    .counter-content {
      grid-template-columns: 1fr;
    }

    .stats-panel {
      position: static;
      max-height: none;
    }
  }
  </style>
</head>

<%@ include file="body-script.jsp"%>

<div class="counter-container">
  <div class="counter-card">
    <div class="counter-header">
      <h1>📊 Word Counter & Character Counter 📊</h1>
      <p>Comprehensive text analysis tool with real-time statistics</p>
    </div>

    <div class="counter-content">
      <div class="input-section">
        <div class="text-input-container">
          <textarea id="textInput" placeholder="Start typing or paste your text here to see real-time word count, character count, and detailed text analysis..."></textarea>
        </div>
        <div class="input-actions">
          <label for="fileInput" class="action-btn secondary" style="cursor: pointer; margin: 0;">
            📁 Load File
            <input type="file" id="fileInput" accept=".pdf,.doc,.docx,.txt,.rtf,.odt" style="display: none;" onchange="handleFileSelect(event)">
          </label>
          <button class="action-btn" onclick="copyText()">📋 Copy Text</button>
          <button class="action-btn secondary" onclick="clearText()">🗑️ Clear</button>
          <button class="action-btn secondary" onclick="pasteText()">📥 Paste</button>
          <button class="action-btn secondary" onclick="exportResults()">💾 Export Results</button>
        </div>
        <div id="fileStatus" style="margin-top: 0.5rem; font-size: 0.85rem; color: #6b7280; min-height: 1.2rem;"></div>
      </div>

      <div class="stats-panel">
        <div class="stats-grid" id="statsGrid">
          <!-- Stats will be populated by JavaScript -->
        </div>

        <div class="analysis-section" id="analysisSection">
          <!-- Analysis will be populated by JavaScript -->
        </div>
      </div>
    </div>
  </div>

  <div class="counter-card" style="padding: 1.5rem; margin-top: 1rem;">
    <h3 style="color: var(--counter-dark); margin-top: 0; font-size: 1.2rem;">🧠 Text Analysis Features</h3>
    <p>This tool provides comprehensive text analysis including:</p>
    <ul>
      <li><strong>Word Count:</strong> Total number of words in your text</li>
      <li><strong>Character Count:</strong> Total characters with and without spaces</li>
      <li><strong>Sentence Count:</strong> Number of sentences detected</li>
      <li><strong>Paragraph Count:</strong> Number of paragraphs</li>
      <li><strong>Reading Time:</strong> Estimated time to read the text (based on average reading speed of 200-250 words per minute)</li>
      <li><strong>Keyword Density:</strong> Most frequent words and their percentage</li>
      <li><strong>Average Words per Sentence:</strong> Text complexity indicator</li>
      <li><strong>Average Characters per Word:</strong> Word length analysis</li>
    </ul>
    <p><strong>Perfect for:</strong> Students writing essays, content creators, SEO professionals, social media managers, and anyone who needs accurate text statistics!</p>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
const textInput = document.getElementById('textInput');

textInput.addEventListener('input', analyzeText);
textInput.addEventListener('paste', () => setTimeout(analyzeText, 10));

function analyzeText() {
  const text = textInput.value;
  const stats = calculateStats(text);
  displayStats(stats);
  displayAnalysis(stats);
}

function calculateStats(text) {
  // Basic counts
  const words = text.trim() ? text.trim().split(/\s+/).filter(w => w.length > 0) : [];
  const wordCount = words.length;
  const charCount = text.length;
  const charCountNoSpaces = text.replace(/\s/g, '').length;
  
  // Sentences (ending with . ! ?)
  const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 0);
  const sentenceCount = sentences.length;
  
  // Paragraphs
  const paragraphs = text.split(/\n\s*\n/).filter(p => p.trim().length > 0);
  const paragraphCount = paragraphs.length || (text.trim() ? 1 : 0);
  
  // Reading time (average 225 words per minute)
  const readingTimeMinutes = wordCount / 225;
  const readingTimeSeconds = Math.round(readingTimeMinutes * 60);
  
  // Keyword analysis
  const wordFreq = {};
  words.forEach(word => {
    const cleanWord = word.toLowerCase().replace(/[^\w]/g, '');
    if (cleanWord.length > 0) {
      wordFreq[cleanWord] = (wordFreq[cleanWord] || 0) + 1;
    }
  });
  
  const sortedKeywords = Object.entries(wordFreq)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 10)
    .map(([word, count]) => ({
      word,
      count,
      percentage: ((count / wordCount) * 100).toFixed(2)
    }));
  
  // Averages
  const avgWordsPerSentence = sentenceCount > 0 ? (wordCount / sentenceCount).toFixed(1) : 0;
  const avgCharsPerWord = wordCount > 0 ? (charCountNoSpaces / wordCount).toFixed(1) : 0;
  const avgCharsPerSentence = sentenceCount > 0 ? (charCountNoSpaces / sentenceCount).toFixed(1) : 0;
  
  return {
    wordCount,
    charCount,
    charCountNoSpaces,
    sentenceCount,
    paragraphCount,
    readingTimeMinutes: readingTimeMinutes.toFixed(1),
    readingTimeSeconds,
    keywords: sortedKeywords,
    avgWordsPerSentence,
    avgCharsPerWord,
    avgCharsPerSentence
  };
}

function displayStats(stats) {
  const grid = document.getElementById('statsGrid');
  grid.innerHTML = `
    <div class="stat-card large">
      <div class="stat-value">${stats.wordCount.toLocaleString()}</div>
      <div class="stat-label">Words</div>
    </div>
    <div class="stat-card">
      <div class="stat-value">${stats.charCount.toLocaleString()}</div>
      <div class="stat-label">Characters</div>
    </div>
    <div class="stat-card">
      <div class="stat-value">${stats.charCountNoSpaces.toLocaleString()}</div>
      <div class="stat-label">Characters (no spaces)</div>
    </div>
    <div class="stat-card">
      <div class="stat-value">${stats.sentenceCount}</div>
      <div class="stat-label">Sentences</div>
    </div>
    <div class="stat-card">
      <div class="stat-value">${stats.paragraphCount}</div>
      <div class="stat-label">Paragraphs</div>
    </div>
    <div class="stat-card">
      <div class="stat-value">${formatReadingTime(stats.readingTimeMinutes, stats.readingTimeSeconds)}</div>
      <div class="stat-label">Reading Time</div>
    </div>
  `;
}

function formatReadingTime(minutes, seconds) {
  const mins = Math.floor(parseFloat(minutes));
  const secs = seconds % 60;
  if (mins === 0) {
    return secs < 1 ? '< 1 sec' : `${secs} sec`;
  }
  return secs < 30 ? `${mins} min` : `${mins} min ${secs} sec`;
}

function displayAnalysis(stats) {
  const section = document.getElementById('analysisSection');
  
  let html = `
    <div class="analysis-title">📈 Text Analysis</div>
    
    <div class="analysis-item">
      <span class="analysis-label">Average Words per Sentence</span>
      <span class="analysis-value">${stats.avgWordsPerSentence}</span>
    </div>
    
    <div class="analysis-item">
      <span class="analysis-label">Average Characters per Word</span>
      <span class="analysis-value">${stats.avgCharsPerWord}</span>
    </div>
    
    <div class="analysis-item">
      <span class="analysis-label">Average Characters per Sentence</span>
      <span class="analysis-value">${stats.avgCharsPerSentence}</span>
    </div>
  `;
  
    if (stats.keywords.length > 0) {
    html += `
      <div class="analysis-title" style="margin-top: 1rem;">🔑 Top Keywords</div>
      <div class="keyword-list">
    `;
    
    stats.keywords.forEach(({ word, count, percentage }) => {
      const maxCount = stats.keywords[0].count;
      const width = (count / maxCount) * 100;
      html += `
        <div class="keyword-item">
          <span><strong>${word}</strong> (${count}x)</span>
          <span style="color: var(--counter-primary); font-weight: 600;">${percentage}%</span>
        </div>
        <div class="progress-bar">
          <div class="progress-fill" style="width: ${width}%"></div>
        </div>
      `;
    });
    
    html += `</div>`;
  }
  
  section.innerHTML = html;
}

function copyText() {
  textInput.select();
  document.execCommand('copy');
  showNotification('Text copied to clipboard!');
}

function clearText() {
  if (confirm('Are you sure you want to clear all text?')) {
    textInput.value = '';
    analyzeText();
    showNotification('Text cleared!');
  }
}

function pasteText() {
  navigator.clipboard.readText().then(text => {
    textInput.value = text;
    analyzeText();
    showNotification('Text pasted!');
  }).catch(() => {
    textInput.focus();
    showNotification('Please paste using Ctrl+V / Cmd+V');
  });
}

function exportResults() {
  const text = textInput.value;
  const stats = calculateStats(text);
  
  const report = `
WORD & CHARACTER COUNTER REPORT
Generated: ${new Date().toLocaleString()}

BASIC STATISTICS:
- Words: ${stats.wordCount.toLocaleString()}
- Characters: ${stats.charCount.toLocaleString()}
- Characters (no spaces): ${stats.charCountNoSpaces.toLocaleString()}
- Sentences: ${stats.sentenceCount}
- Paragraphs: ${stats.paragraphCount}
- Reading Time: ${formatReadingTime(stats.readingTimeMinutes, stats.readingTimeSeconds)}

ANALYSIS:
- Average Words per Sentence: ${stats.avgWordsPerSentence}
- Average Characters per Word: ${stats.avgCharsPerWord}
- Average Characters per Sentence: ${stats.avgCharsPerSentence}

TOP KEYWORDS:
${stats.keywords.map((k, i) => `${i + 1}. ${k.word} - ${k.count} times (${k.percentage}%)`).join('\n')}

---
TEXT CONTENT:
${text}
  `.trim();
  
  const blob = new Blob([report], { type: 'text/plain' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `text-analysis-${Date.now()}.txt`;
  a.click();
  URL.revokeObjectURL(url);
  showNotification('Results exported!');
}

function showNotification(message) {
  const notification = document.createElement('div');
  notification.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
    padding: 1rem 1.5rem;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    z-index: 10000;
    font-weight: 600;
    animation: slideIn 0.3s ease-out;
  `;
  notification.textContent = message;
  document.body.appendChild(notification);
  
  setTimeout(() => {
    notification.style.animation = 'slideOut 0.3s ease-out';
    setTimeout(() => notification.remove(), 300);
  }, 2000);
}

// Add animations
const style = document.createElement('style');
style.textContent = `
  @keyframes slideIn {
    from {
      transform: translateX(100%);
      opacity: 0;
    }
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
  @keyframes slideOut {
    from {
      transform: translateX(0);
      opacity: 1;
    }
    to {
      transform: translateX(100%);
      opacity: 0;
    }
  }
`;
document.head.appendChild(style);

async function handleFileSelect(event) {
  const file = event.target.files[0];
  if (!file) return;

  const statusDiv = document.getElementById('fileStatus');
  statusDiv.innerHTML = `<span style="color: #3b82f6;">📄 Loading ${file.name}...</span>`;
  
  const fileExtension = file.name.split('.').pop().toLowerCase();
  
  try {
    let text = '';
    
    switch(fileExtension) {
      case 'pdf':
        text = await extractTextFromPDF(file);
        break;
      case 'txt':
      case 'rtf':
        text = await extractTextFromTextFile(file);
        break;
      case 'doc':
        text = await extractTextFromDoc(file);
        break;
      case 'docx':
        text = await extractTextFromDocx(file);
        break;
      case 'odt':
        text = await extractTextFromODT(file);
        break;
      default:
        throw new Error('Unsupported file type');
    }
    
    if (text.trim()) {
      textInput.value = text;
      analyzeText();
      statusDiv.innerHTML = `<span style="color: #10b981;">✓ Successfully loaded ${file.name} (${formatFileSize(file.size)})</span>`;
      setTimeout(() => {
        statusDiv.innerHTML = '';
      }, 3000);
    } else {
      throw new Error('No text found in file');
    }
  } catch (error) {
    console.error('Error loading file:', error);
    statusDiv.innerHTML = `<span style="color: #ef4444;">✗ Error: ${error.message}</span>`;
    setTimeout(() => {
      statusDiv.innerHTML = '';
    }, 5000);
  }
  
  // Reset file input
  event.target.value = '';
}

async function extractTextFromPDF(file) {
  const arrayBuffer = await file.arrayBuffer();
  const pdf = await pdfjsLib.getDocument({ data: arrayBuffer }).promise;
  
  let fullText = '';
  
  for (let i = 1; i <= pdf.numPages; i++) {
    const page = await pdf.getPage(i);
    const textContent = await page.getTextContent();
    const pageText = textContent.items.map(item => item.str).join(' ');
    fullText += pageText + '\n\n';
  }
  
  return fullText.trim();
}

async function extractTextFromTextFile(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (e) => resolve(e.target.result);
    reader.onerror = (e) => reject(new Error('Failed to read file'));
    reader.readAsText(file);
  });
}

async function extractTextFromDoc(file) {
  // For .doc files, we'll try to read as text (limited support)
  // Full .doc support would require a library like mammoth or docx
  try {
    return await extractTextFromTextFile(file);
  } catch (error) {
    // If that fails, try using FileReader with different encoding
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = (e) => {
        // Try to extract readable text from binary
        const result = e.target.result;
        // Basic attempt to extract text (limited)
        const textMatch = result.match(/[a-zA-Z0-9\s]{20,}/g);
        if (textMatch) {
          resolve(textMatch.join(' '));
        } else {
          reject(new Error('Could not extract text from DOC file. Please convert to DOCX or PDF.'));
        }
      };
      reader.onerror = () => reject(new Error('Failed to read DOC file'));
      reader.readAsBinaryString(file);
    });
  }
}

async function extractTextFromDocx(file) {
  // DOCX files are ZIP archives containing XML
  // Extract text from word/document.xml
  try {
    const JSZip = await loadJSZip();
    const zip = await JSZip.loadAsync(file);
    const documentXml = await zip.file('word/document.xml').async('string');
    
    // Extract text from XML (remove all tags and decode XML entities)
    let text = documentXml
      .replace(/<[^>]+>/g, ' ')  // Remove all XML tags
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&amp;/g, '&')
      .replace(/&quot;/g, '"')
      .replace(/&apos;/g, "'")
      .replace(/\s+/g, ' ')  // Normalize whitespace
      .trim();
    
    return text;
  } catch (error) {
    throw new Error('Failed to extract text from DOCX file. Please ensure it\'s a valid DOCX file.');
  }
}

async function extractTextFromODT(file) {
  // ODT files are ZIP archives containing XML
  // We'll try to extract text from content.xml
  try {
    const JSZip = await loadJSZip();
    const zip = await JSZip.loadAsync(file);
    const content = await zip.file('content.xml').async('string');
    
    // Extract text from XML (basic extraction)
    const textMatch = content.match(/<text:span[^>]*>([^<]+)<\/text:span>/g);
    if (textMatch) {
      return textMatch
        .map(match => match.replace(/<[^>]+>/g, ''))
        .join(' ')
        .trim();
    }
    
    // Fallback: extract all text between tags
    return content.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
  } catch (error) {
    // Fallback to text reading
    return await extractTextFromTextFile(file);
  }
}

function loadJSZip() {
  return new Promise((resolve, reject) => {
    if (window.JSZip) {
      resolve(window.JSZip);
      return;
    }
    
    const script = document.createElement('script');
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js';
    script.onload = () => resolve(window.JSZip);
    script.onerror = () => reject(new Error('Failed to load JSZip library'));
    document.head.appendChild(script);
  });
}

function formatFileSize(bytes) {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

// Initialize
analyzeText();
</script>
    <%@ include file="thanks.jsp"%>
</div>
<%@ include file="body-close.jsp"%>


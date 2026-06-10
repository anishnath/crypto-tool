#!/usr/bin/env node
/**
 * Generate topics-seo.json from JS topic files
 *
 * This script extracts SEO fields (title, description, ctrHeadline) from all
 * quick-math-topics-*.js files and generates a single JSON file for
 * server-side SEO rendering.
 *
 * Run: node generate-seo-json.js
 *
 * The JS files are the SINGLE SOURCE OF TRUTH.
 * This script auto-generates topics-seo.json for server-side SEO.
 */

const fs = require('fs');
const path = require('path');

const JS_DIR = path.join(__dirname, '../js');
const OUTPUT_FILE = path.join(__dirname, 'topics-seo.json');

// Find all topic JS files
const topicFiles = fs.readdirSync(JS_DIR)
    .filter(f => f.startsWith('quick-math-topics-') && f.endsWith('.js'));

console.log('Found topic files:', topicFiles);

const seoData = {};

topicFiles.forEach(file => {
    const filePath = path.join(JS_DIR, file);
    const content = fs.readFileSync(filePath, 'utf8');

    // Match topic definitions: 'topic-id': { ... }
    // Pattern finds quoted keys followed by object definitions
    const topicPattern = /'([a-z0-9-]+)'\s*:\s*\{[^}]*?title\s*:/g;

    let match;
    while ((match = topicPattern.exec(content)) !== null) {
        const topicId = match[1];
        const startIdx = content.indexOf('{', match.index + topicId.length);

        // Find the object boundaries by tracking braces and backticks (for template literals)
        let braceCount = 1;
        let idx = startIdx + 1;
        let inTemplate = false;
        let inString = false;
        let stringChar = '';

        while (braceCount > 0 && idx < content.length) {
            const char = content[idx];
            const prevChar = content[idx - 1];

            // Track template literals
            if (char === '`' && prevChar !== '\\') {
                inTemplate = !inTemplate;
            }
            // Track strings
            else if ((char === '"' || char === "'") && prevChar !== '\\' && !inTemplate) {
                if (!inString) {
                    inString = true;
                    stringChar = char;
                } else if (char === stringChar) {
                    inString = false;
                }
            }
            // Count braces only when not in string/template
            else if (!inString && !inTemplate) {
                if (char === '{') braceCount++;
                if (char === '}') braceCount--;
            }
            idx++;
        }

        const objectStr = content.substring(startIdx, idx);

        // Extract SEO fields - use a function to handle escaped quotes properly
        function extractField(str, field) {
            const regex = new RegExp(field + "\\s*:\\s*['\"]");
            const match = regex.exec(str);
            if (!match) return null;

            const startQuote = str[match.index + match[0].length - 1];
            let idx = match.index + match[0].length;
            let result = '';

            while (idx < str.length) {
                if (str[idx] === '\\' && idx + 1 < str.length) {
                    // Escaped character - skip the backslash, keep the char
                    result += str[idx + 1];
                    idx += 2;
                } else if (str[idx] === startQuote) {
                    // End of string
                    break;
                } else {
                    result += str[idx];
                    idx++;
                }
            }
            return result;
        }

        const title = extractField(objectStr, 'title');
        const description = extractField(objectStr, 'description');
        const h1 = extractField(objectStr, 'ctrHeadline');

        if (title) {
            seoData[topicId] = {
                title: title,
                description: description || title,
                h1: h1 || title.split('|')[0].trim()
            };
            console.log(`  ✓ ${topicId}`);
        }
    }
});

// Add default fallback
seoData['_default'] = {
    title: 'Mental Math Practice | Quick Math',
    description: 'Practice mental math tricks and speed calculation techniques.',
    h1: 'Mental Math Practice'
};

// Sort keys for consistent output
const sorted = {};
Object.keys(seoData).sort().forEach(key => {
    sorted[key] = seoData[key];
});

// Write output
const output = JSON.stringify(sorted, null, 2);
fs.writeFileSync(OUTPUT_FILE, output, 'utf8');

console.log(`\n✅ Generated ${OUTPUT_FILE}`);
console.log(`   Total topics: ${Object.keys(sorted).length - 1}`); // -1 for _default

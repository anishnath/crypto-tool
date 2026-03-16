/**
 * convert-to-mp4.js — Batch convert all .webm files in output/ to .mp4
 *
 * Usage: node convert-to-mp4.js
 * Requires: ffmpeg installed (brew install ffmpeg)
 */
const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const outputDir = path.join(__dirname, 'output');

if (!fs.existsSync(outputDir)) {
    console.log('No output/ directory found.');
    process.exit(0);
}

const webmFiles = fs.readdirSync(outputDir).filter(f => f.endsWith('.webm'));

if (webmFiles.length === 0) {
    console.log('No .webm files found in output/');
    process.exit(0);
}

console.log(`Found ${webmFiles.length} .webm file(s) to convert:\n`);

for (const webm of webmFiles) {
    const mp4 = webm.replace('.webm', '.mp4');
    const webmPath = path.join(outputDir, webm);
    const mp4Path = path.join(outputDir, mp4);

    console.log(`  ${webm} -> ${mp4}`);
    try {
        execSync(
            `ffmpeg -y -i "${webmPath}" -c:v libx264 -preset fast -crf 22 -pix_fmt yuv420p "${mp4Path}"`,
            { stdio: 'pipe' }
        );
        console.log(`    Done.\n`);
    } catch (e) {
        console.error(`    Failed: ${e.message}\n`);
    }
}

console.log('Conversion complete. MP4 files are in demo-recorder/output/');

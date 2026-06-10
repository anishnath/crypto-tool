#!/usr/bin/env node

/**
 * Sitemap Generator for Quick Math Topics
 * 
 * Generates sitemap.xml entries for all Quick Math topics
 * Run this script and copy the output to your main sitemap.xml
 * 
 * Usage: node generate-sitemap-urls.cjs > quick-math-sitemap-urls.xml
 */

const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
    seoJsonPath: path.join(__dirname, 'topics-seo.json'),
    baseUrl: 'https://8gwifi.org/exams/quick-math',
    changefreq: 'weekly', // How often the page is likely to change
    priority: '0.8', // Priority of this URL (0.0 to 1.0)
};

/**
 * Format date as YYYY-MM-DD for sitemap lastmod
 */
function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

/**
 * Generate sitemap URL entry
 */
function generateUrlEntry(url, lastmod, changefreq, priority) {
    return `  <url>
    <loc>${url}</loc>
    <lastmod>${lastmod}</lastmod>
    <changefreq>${changefreq}</changefreq>
    <priority>${priority}</priority>
  </url>`;
}

/**
 * Main function
 */
function main() {
    console.log('<!-- Quick Math Sitemap URLs -->');
    console.log('<!-- Generated on ' + new Date().toISOString() + ' -->');
    console.log('<!-- Total: 153 URLs (index + practice + 151 topics) -->\n');

    // Read SEO JSON
    const seoData = JSON.parse(fs.readFileSync(CONFIG.seoJsonPath, 'utf-8'));
    const lastmod = formatDate(new Date());

    // Generate main page URLs
    console.log('  <!-- Quick Math Main Pages -->');
    console.log(generateUrlEntry(
        `${CONFIG.baseUrl}/index.jsp`,
        lastmod,
        'weekly',
        '0.9'
    ));
    console.log(generateUrlEntry(
        `${CONFIG.baseUrl}/practice.jsp`,
        lastmod,
        'weekly',
        '0.8'
    ));
    console.log();

    // Group topics by category for better organization
    const topicsByCategory = {};
    seoData.topics.forEach(topic => {
        const category = topic.jsonLD.about.name;
        if (!topicsByCategory[category]) {
            topicsByCategory[category] = [];
        }
        topicsByCategory[category].push(topic);
    });

    // Generate URLs for each category
    const categories = Object.keys(topicsByCategory).sort();

    categories.forEach(category => {
        console.log(`  <!-- ${category} (${topicsByCategory[category].length} topics) -->`);

        topicsByCategory[category].forEach(topic => {
            console.log(generateUrlEntry(
                topic.url,
                lastmod,
                CONFIG.changefreq,
                CONFIG.priority
            ));
        });

        console.log();
    });

    // Summary
    console.error('\n=================================');
    console.error('📊 Sitemap Generation Summary');
    console.error('=================================');
    console.error(`Total URLs: ${seoData.topics.length + 2}`);
    console.error(`Main Pages: 2`);
    console.error(`Topic Pages: ${seoData.topics.length}`);
    console.error(`Categories: ${categories.length}`);
    console.error('\n✅ Copy the XML output above and paste it into your sitemap.xml');
    console.error('   Location: <urlset> section of your sitemap');
}

// Run the script
main();

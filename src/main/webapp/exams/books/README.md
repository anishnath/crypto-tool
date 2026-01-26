# Books Q&A System

This directory contains educational book solutions with individual question pages optimized for SEO.

## Directory Structure

```
books/
├── README.md                          # This file
├── ncert/
│   ├── ncert-books.css               # Shared styles for all NCERT books
│   └── class-9/
│       └── mathematics/
│           ├── index.jsp              # Subject landing page (lists all chapters)
│           ├── chapter.jsp            # Shared chapter template
│           ├── question.jsp           # Shared individual question template
│           ├── data/
│           │   └── chapters.json      # All questions data
│           ├── diagrams/              # SVG diagrams for questions
│           │   └── fig-*.svg
│           ├── question-sitemap.xml   # Sitemap for question pages
│           ├── question-urls.txt      # Plain text list of URLs
│           └── [chapter-slug]/        # One folder per chapter
│               ├── index.jsp          # Chapter listing (includes chapter.jsp)
│               └── ex-X-Y-qZ.jsp      # Individual question pages
```

## Adding a New Book

### Step 1: Create Directory Structure

```bash
# Example: Adding NCERT Class 10 Science
mkdir -p ncert/class-10/science/data
mkdir -p ncert/class-10/science/diagrams
```

### Step 2: Create the JSON Data File

Create `data/chapters.json` with all questions. Each question should follow this format:

```json
{
  "question_id": "AUTO",
  "type": "Numerical|Proof|MCQ|Short Answer",
  "chapter": "Class X - Chapter 1: Chemical Reactions",
  "section": "1.1 Chemical Equations",
  "exercise": "Exercise 1.1",
  "question_number": "Q1",
  "marks": 2,
  "difficulty": 0.5,
  "question_plain": "Plain text version of the question",
  "question_latex": "LaTeX version with \\( math \\) if needed",
  "correct_answer_plain": "Plain text answer",
  "correct_answer_latex": "LaTeX answer",
  "hint": "Optional hint for students",
  "solution_steps": [
    "Step 1: ...",
    "Step 2: ...",
    "Final answer: ..."
  ],
  "visual_content": {
    "has_diagram": false,
    "diagram_description": "",
    "diagram_svg": ""
  },
  "tags": ["topic1", "topic2"],
  "source": {
    "book": "NCERT",
    "curriculum": "CBSE",
    "class": 10,
    "chapter": 1,
    "exercise": "1.1",
    "question_number": "Q1",
    "page": 10
  }
}
```

### Step 3: Create Chapter Mapping

In your `chapter.jsp`, define the chapter slug mapping:

```java
Map<String, String[]> chapterMap = new HashMap<>();
// Format: slug -> [chapterNum, chapterName, metaDescription]
chapterMap.put("chemical-reactions", new String[]{
    "1",
    "Chemical Reactions and Equations",
    "NCERT Class 10 Science Chapter 1 solutions..."
});
chapterMap.put("acids-bases-salts", new String[]{
    "2",
    "Acids, Bases and Salts",
    "NCERT Class 10 Science Chapter 2 solutions..."
});
// ... add all chapters
```

### Step 4: Create Chapter Folders

For each chapter, create a folder with an `index.jsp`:

```bash
mkdir ncert/class-10/science/chemical-reactions
```

Create `chemical-reactions/index.jsp`:
```jsp
<%@ include file="../chapter.jsp" %>
```

### Step 5: Copy and Adapt Templates

Copy these files from an existing book (e.g., class-9/mathematics):

| File | Purpose | What to Change |
|------|---------|----------------|
| `index.jsp` | Subject landing page | Title, description, chapter list |
| `chapter.jsp` | Chapter template | Chapter mapping, breadcrumbs |
| `question.jsp` | Question page template | Breadcrumbs, schema |

### Step 6: Generate Individual Question Pages

Update the generation script at `/scripts/generate-question-pages.cjs`:

1. Add new chapter mapping:
```javascript
const CHAPTER_MAP = {
    1: 'chemical-reactions',
    2: 'acids-bases-salts',
    // ...
};
```

2. Update paths:
```javascript
const BASE_PATH = path.join(__dirname,
    '../src/main/webapp/exams/books/ncert/class-10/science');
```

3. Run the script:
```bash
node scripts/generate-question-pages.cjs
```

This generates:
- Individual question JSP stubs (e.g., `ex-1-1-q1.jsp`)
- `question-sitemap.xml` with all URLs
- `question-urls.txt` for reference

### Step 7: Add Diagrams (Optional)

Place SVG diagrams in the `diagrams/` folder with naming convention:
```
fig-[chapter]-[section]-[description].svg
```

Reference in JSON:
```json
"visual_content": {
    "has_diagram": true,
    "diagram_description": "Diagram showing chemical reaction",
    "diagram_svg": "fig-1-1-chemical-reaction.svg"
}
```

### Step 8: Submit to Search Engines

1. Add the question sitemap to your main sitemap index
2. Submit to Google Search Console
3. Request indexing for key pages

## URL Patterns

| Type | URL Pattern | Example |
|------|-------------|---------|
| Subject | `/books/ncert/class-9/mathematics/` | Landing page |
| Chapter | `/books/ncert/class-9/mathematics/circles/` | Chapter listing |
| Question | `/books/ncert/class-9/mathematics/circles/ex-10-1-q1.jsp` | Individual Q&A |

## Question Slug Format

Slugs are auto-generated from exercise and question number:

```
Exercise 10.1, Q1  →  ex-10-1-q1
Exercise 2.3, Q5   →  ex-2-3-q5
Exercise 9.4 (Optional), Q3  →  ex-9-4-q3  (parenthetical removed)
```

## SEO Features

Each question page includes:

1. **QAPage Schema** - Google recognizes Q&A format
2. **BreadcrumbList Schema** - Navigation trail
3. **Unique Title** - Question text + exercise info
4. **Canonical URL** - Prevents duplicate content
5. **Related Questions** - Internal linking

## Key Files Reference

### chapter.jsp
- Renders chapter listing with all questions
- Groups questions by exercise
- Links to individual question pages via "View Full Page" button
- Generates FAQPage schema for chapter

### question.jsp
- Renders single question with full solution
- Prev/Next navigation between questions
- Related questions from same exercise
- QAPage schema for the question

### generate-question-pages.cjs
- Reads chapters.json
- Creates stub JSP files for each question
- Generates sitemap XML

## Checklist for New Book

- [ ] Create directory structure
- [ ] Create chapters.json with all questions
- [ ] Create/adapt chapter.jsp with slug mapping
- [ ] Create/adapt question.jsp template
- [ ] Create/adapt index.jsp subject page
- [ ] Create chapter folders with index.jsp
- [ ] Run generation script for question pages
- [ ] Add diagrams if needed
- [ ] Test a few question pages locally
- [ ] Submit sitemap to Search Console

## Troubleshooting

### Questions not loading
- Check chapters.json is valid JSON
- Verify chapter number in JSON matches mapping
- Check browser console for fetch errors

### Slug mismatch
- Ensure exercise format is "Exercise X.Y"
- Question number should be "Q1", "Q2", etc.
- Parenthetical notes like "(Optional)" are auto-removed

### Diagrams not showing
- Check file exists in diagrams/ folder
- Verify diagram_svg filename matches exactly
- SVGs should be properly formatted

## Example: Complete File List for New Subject

```
ncert/class-10/science/
├── index.jsp                    # Subject page
├── chapter.jsp                  # Chapter template
├── question.jsp                 # Question template
├── data/
│   └── chapters.json           # ~500KB for 200+ questions
├── diagrams/
│   └── fig-1-1-example.svg     # Optional diagrams
├── question-sitemap.xml        # Generated
├── question-urls.txt           # Generated
├── chemical-reactions/
│   ├── index.jsp               # 1 line include
│   ├── ex-1-1-q1.jsp          # Generated stubs
│   ├── ex-1-1-q2.jsp
│   └── ...
├── acids-bases-salts/
│   ├── index.jsp
│   └── ...
└── [other-chapters]/
```

## Generating question-sitemap.xml

The sitemap is auto-generated by the script. Here's how:

### For Existing Book (Regenerate Sitemap)

```bash
# Navigate to project root
cd /Users/anish/git/crypto-tool

# Run the generation script
node scripts/generate-question-pages.cjs
```

**Output files generated:**
- `question-sitemap.xml` - Full XML sitemap for Google
- `question-urls.txt` - Plain text list of all URLs

### For New Book (Create New Script)

1. Copy the script:
```bash
cp scripts/generate-question-pages.cjs scripts/generate-[book]-pages.cjs
```

2. Update these variables in the new script:
```javascript
// Path to your new book
const BASE_PATH = path.join(__dirname,
    '../src/main/webapp/exams/books/ncert/class-10/science');

// Path to your JSON data
const JSON_PATH = path.join(BASE_PATH, 'data/chapters.json');

// Your chapter slug mapping
const CHAPTER_MAP = {
    1: 'chemical-reactions',
    2: 'acids-bases-salts',
    // ... all chapters
};
```

3. Run the script:
```bash
node scripts/generate-[book]-pages.cjs
```

### Sitemap XML Format

The generated `question-sitemap.xml` looks like:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://8gwifi.org/exams/books/ncert/class-9/mathematics/circles/ex-10-1-q1.jsp</loc>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>
  <!-- ... 244 URLs total -->
</urlset>
```

### Adding to Main Sitemap

Add a reference in your main `sitemap.xml`:
```xml
<sitemap>
  <loc>https://8gwifi.org/exams/books/ncert/class-9/mathematics/question-sitemap.xml</loc>
</sitemap>
```

Or use a sitemap index file (`sitemap-index.xml`):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>https://8gwifi.org/sitemap.xml</loc>
  </sitemap>
  <sitemap>
    <loc>https://8gwifi.org/exams/books/ncert/class-9/mathematics/question-sitemap.xml</loc>
  </sitemap>
</sitemapindex>
```

## Performance Notes

- chapters.json is loaded once per page via fetch
- Questions are filtered client-side by chapter number
- Lazy loading for diagrams
- MathJax renders LaTeX on demand

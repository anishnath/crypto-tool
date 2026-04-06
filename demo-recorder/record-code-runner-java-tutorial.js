/**
 * record-code-runner-java-tutorial.js — Java tutorial showcasing the code runner
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080/mywebapp2_war_exploded node record-code-runner-java-tutorial.js
 */
const H = require('./helpers');

// ── Code Runner Helpers ─────────────────────────────────────

async function insertCodeBlock(page) {
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (!editor) return;
        if (editor.isActive('runnableCodeBlock')) {
            const { $from } = editor.state.selection;
            const after = $from.after();
            const docSize = editor.state.doc.content.size;
            if (after >= docSize) {
                editor.chain().insertContentAt(after, { type: 'paragraph' }).setTextSelection(after + 1).run();
            } else {
                editor.commands.setTextSelection(after);
            }
        }
        editor.commands.setRunnableCodeBlock();
    });
    await page.waitForTimeout(500);
}

async function typeCode(page, code) {
    await page.evaluate((text) => {
        const editor = window.MeEditor;
        if (editor) editor.commands.insertContent(text);
    }, code);
    await page.waitForTimeout(400);
}

async function clickRun(page) {
    const runBtns = await page.$$('.me-rcb-run-btn');
    if (runBtns.length > 0) await runBtns[runBtns.length - 1].click();
    await page.waitForTimeout(3000);
}

async function selectLanguage(page, lang) {
    const selects = await page.$$('.me-rcb-lang-select');
    if (selects.length > 0) await selects[selects.length - 1].selectOption(lang);
    await page.waitForTimeout(300);
}

async function exitCodeBlock(page) {
    await page.evaluate(() => {
        const editor = window.MeEditor;
        if (!editor) return;
        const { $from } = editor.state.selection;
        for (let depth = $from.depth; depth >= 0; depth--) {
            const node = $from.node(depth);
            if (node.type.name === 'runnableCodeBlock') {
                const after = $from.after(depth);
                const docSize = editor.state.doc.content.size;
                if (after >= docSize) {
                    editor.chain().insertContentAt(after, { type: 'paragraph' }).setTextSelection(after + 1).focus().run();
                } else {
                    editor.chain().setTextSelection(after).focus().run();
                }
                return;
            }
        }
        editor.commands.focus('end');
    });
    await page.waitForTimeout(400);
}

// ── Main Recording ──────────────────────────────────────────

(async () => {
    console.log('Recording: Java Tutorial — Code Runner Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('code-runner-java-tutorial', { width: 1280, height: 720 });

    try {
        console.log('[1] Setup...');
        await H.openEditor(page);
        await H.pause(page);
        await H.clearEditor(page);

        await page.click('.me-doc-title-input');
        await page.waitForTimeout(150);
        await page.keyboard.press('Meta+a');
        await page.keyboard.type('Java Crash Course — Write & Run', { delay: 25 });
        await page.keyboard.press('Enter');
        await H.focusEditor(page);

        // ── 1. HELLO WORLD ──────────────────────────────────
        console.log('[2] Hello World...');
        await H.typeText(page, 'Hello World', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'java');
        await H.beat(page);

        await typeCode(page,
            'public class Main {\n' +
            '    public static void main(String[] args) {\n' +
            '        System.out.println("Hello, Java!");\n' +
            '\n' +
            '        // Variables & types\n' +
            '        String name = "Java";\n' +
            '        int version = 21;\n' +
            '        double pi = 3.14159;\n' +
            '        boolean modern = true;\n' +
            '\n' +
            '        System.out.printf("Language: %s %d%n", name, version);\n' +
            '        System.out.printf("Pi: %.2f%n", pi);\n' +
            '        System.out.printf("Modern: %b%n", modern);\n' +
            '    }\n' +
            '}');
        await H.pause(page);
        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 250);

        // ── 2. COLLECTIONS & STREAMS ────────────────────────
        console.log('[3] Collections & Streams...');
        await H.pressEnter(page);
        await H.typeText(page, 'Collections & Streams', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'java');
        await H.beat(page);

        await typeCode(page,
            'import java.util.*;\n' +
            'import java.util.stream.*;\n' +
            '\n' +
            'public class Main {\n' +
            '    public static void main(String[] args) {\n' +
            '        var names = List.of("Alice", "Bob", "Charlie", "Diana", "Eve");\n' +
            '\n' +
            '        // Filter + transform\n' +
            '        var long_names = names.stream()\n' +
            '            .filter(n -> n.length() > 3)\n' +
            '            .map(String::toUpperCase)\n' +
            '            .sorted()\n' +
            '            .collect(Collectors.toList());\n' +
            '\n' +
            '        System.out.println("Long names: " + long_names);\n' +
            '\n' +
            '        // Map with frequency count\n' +
            '        var words = List.of("java", "python", "java", "rust", "java", "rust");\n' +
            '        var freq = words.stream()\n' +
            '            .collect(Collectors.groupingBy(w -> w, Collectors.counting()));\n' +
            '\n' +
            '        freq.forEach((word, count) ->\n' +
            '            System.out.printf("  %s: %d%n", word, count));\n' +
            '    }\n' +
            '}');
        await H.pause(page);
        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 350);

        // ── 3. OOP: RECORDS & INTERFACES ────────────────────
        console.log('[4] OOP...');
        await H.pressEnter(page);
        await H.typeText(page, 'Records & Interfaces', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'java');
        await H.beat(page);

        await typeCode(page,
            'import java.util.*;\n' +
            '\n' +
            'public class Main {\n' +
            '\n' +
            '    interface Shape {\n' +
            '        double area();\n' +
            '        String describe();\n' +
            '    }\n' +
            '\n' +
            '    record Circle(double radius) implements Shape {\n' +
            '        public double area() { return Math.PI * radius * radius; }\n' +
            '        public String describe() {\n' +
            '            return String.format("Circle(r=%.1f, area=%.2f)", radius, area());\n' +
            '        }\n' +
            '    }\n' +
            '\n' +
            '    record Rect(double w, double h) implements Shape {\n' +
            '        public double area() { return w * h; }\n' +
            '        public String describe() {\n' +
            '            return String.format("Rect(%.1fx%.1f, area=%.2f)", w, h, area());\n' +
            '        }\n' +
            '    }\n' +
            '\n' +
            '    public static void main(String[] args) {\n' +
            '        var shapes = List.of(\n' +
            '            new Circle(5),\n' +
            '            new Rect(4, 6),\n' +
            '            new Circle(3),\n' +
            '            new Rect(10, 2)\n' +
            '        );\n' +
            '\n' +
            '        shapes.stream()\n' +
            '            .sorted(Comparator.comparingDouble(Shape::area).reversed())\n' +
            '            .forEach(s -> System.out.println("  " + s.describe()));\n' +
            '\n' +
            '        double total = shapes.stream().mapToDouble(Shape::area).sum();\n' +
            '        System.out.printf("%nTotal area: %.2f%n", total);\n' +
            '    }\n' +
            '}');
        await H.pause(page);
        await clickRun(page);
        await H.pause(page);

        await exitCodeBlock(page);
        await H.smoothScroll(page, 400);

        // ── 4. PATTERN MATCHING (Java 21) ───────────────────
        console.log('[5] Pattern Matching...');
        await H.pressEnter(page);
        await H.typeText(page, 'Pattern Matching', { fast: true });
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.pressEnter(page);

        await insertCodeBlock(page);
        await selectLanguage(page, 'java');
        await H.beat(page);

        await typeCode(page,
            'public class Main {\n' +
            '\n' +
            '    sealed interface Expr permits Num, Add, Mul {}\n' +
            '    record Num(int value) implements Expr {}\n' +
            '    record Add(Expr left, Expr right) implements Expr {}\n' +
            '    record Mul(Expr left, Expr right) implements Expr {}\n' +
            '\n' +
            '    static int eval(Expr expr) {\n' +
            '        return switch (expr) {\n' +
            '            case Num n   -> n.value();\n' +
            '            case Add a   -> eval(a.left()) + eval(a.right());\n' +
            '            case Mul m   -> eval(m.left()) * eval(m.right());\n' +
            '        };\n' +
            '    }\n' +
            '\n' +
            '    static String pretty(Expr expr) {\n' +
            '        return switch (expr) {\n' +
            '            case Num n   -> String.valueOf(n.value());\n' +
            '            case Add a   -> "(" + pretty(a.left()) + " + " + pretty(a.right()) + ")";\n' +
            '            case Mul m   -> pretty(m.left()) + " * " + pretty(m.right());\n' +
            '        };\n' +
            '    }\n' +
            '\n' +
            '    public static void main(String[] args) {\n' +
            '        // (2 + 3) * 4\n' +
            '        var expr = new Mul(new Add(new Num(2), new Num(3)), new Num(4));\n' +
            '        System.out.println(pretty(expr) + " = " + eval(expr));\n' +
            '\n' +
            '        // 1 + (2 * (3 + 4))\n' +
            '        var expr2 = new Add(new Num(1), new Mul(new Num(2), new Add(new Num(3), new Num(4))));\n' +
            '        System.out.println(pretty(expr2) + " = " + eval(expr2));\n' +
            '    }\n' +
            '}');
        await H.pause(page);
        await clickRun(page);
        await H.longPause(page);

        // ── EXPORT AS PDF ───────────────────────────────────
        console.log('[6] Export as PDF...');

        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);

        await page.evaluate(() => {
            if (!window.MathAPI) window.MathAPI = {};
            window.MathAPI.checkSession = function () {
                return Promise.resolve({ logged_in: true, user_id: 'demo-user' });
            };
        });

        const downloadPromise = page.waitForEvent('download', { timeout: 120000 }).catch(() => null);

        await page.click('.me-btn-export');
        await page.waitForTimeout(400);
        await page.click('.me-export-menu-item[data-export="pdf"]');
        await H.beat(page);

        console.log('[6a] Waiting for PDF...');
        await H.extraPause(page);
        await H.extraPause(page);
        await H.extraPause(page);

        const download = await downloadPromise;
        if (download) {
            const pdfPath = await download.path();
            if (pdfPath) {
                const pdfPage = await context.newPage();
                await pdfPage.goto('file://' + pdfPath);
                await H.longPause(pdfPage);
                await H.extraPause(pdfPage);
                for (let i = 0; i < 3; i++) {
                    await pdfPage.keyboard.press('Space');
                    await page.waitForTimeout(800);
                }
                await H.longPause(pdfPage);
                await pdfPage.close();
            }
        } else {
            await H.extraPause(page);
        }

        // ── FINAL SCROLL ────────────────────────────────────
        console.log('[7] Final scroll...');
        await page.evaluate(() => {
            const w = document.querySelector('.me-canvas-wrapper');
            if (w) w.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.longPause(page);
        for (let i = 0; i < 7; i++) {
            await H.smoothScroll(page, 400);
            await page.waitForTimeout(500);
        }
        await H.pause(page);

        console.log('Done!');
    } catch (err) {
        console.error('Recording error:', err.message);
        console.error(err.stack);
    }

    await H.finishRecording(browser, context, page, outputDir, 'code-runner-java-tutorial');
})();

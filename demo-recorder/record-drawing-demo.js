/**
 * record-drawing-demo.js — Drawing & Diagrams Demo (~50s)
 *
 * Shows:
 *   1. Open drawing canvas via toolbar / slash menu
 *   2. Draw shapes (rectangle, circle)
 *   3. Draw arrows between shapes
 *   4. Add text labels
 *   5. Change colors, stroke width
 *   6. Toggle grid, use snap
 *   7. Insert finished drawing into document
 *   8. Double-click to re-edit
 *
 * Usage:
 *   DEMO_URL=http://localhost:8080 node record-drawing-demo.js
 */
const H = require('./helpers');

(async () => {
    console.log('Recording: Drawing & Diagrams Demo...');
    const { browser, context, page, outputDir } = await H.launchRecorder('drawing-demo');

    try {
        await H.openEditor(page);
        await H.longPause(page);
        await H.clearEditor(page);

        // ─── Scene 1: Set up context ─────────────────────────
        await H.typeText(page, 'Commutative Diagram Example');
        await H.clickToolbarBtn(page, 'Heading 1');
        await H.beat(page);

        await H.pressEnter(page);
        await H.typeText(page, 'Click the diagram button or use the slash menu to open the drawing canvas:');
        await H.pause(page);

        // ─── Scene 2: Open Drawing via Toolbar ───────────────
        await H.pressEnter(page, 2);
        await H.clickToolbarBtn(page, 'Insert Diagram');
        await H.longPause(page);

        // Wait for drawing modal to appear
        await page.waitForSelector('.me-draw-overlay', { timeout: 5000 });
        await H.longPause(page);

        // ─── Scene 3: Draw a Rectangle ───────────────────────
        // Click rectangle tool
        const rectTool = await page.$('.me-draw-tool[data-tool="rect"]');
        if (rectTool) {
            await rectTool.click();
            await H.beat(page);
        }

        // Draw rectangle on canvas (drag from point A to point B)
        const canvasEl = await page.$('.me-draw-canvas-area canvas');
        if (canvasEl) {
            const box = await canvasEl.boundingBox();
            const cx = box.x, cy = box.y;

            // Rectangle 1: top-left area
            await page.mouse.move(cx + 100, cy + 120, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 260, cy + 200, { steps: 20 });
            await page.mouse.up();
            await H.pause(page);

            // ─── Scene 4: Draw a Circle ──────────────────────
            const circleTool = await page.$('.me-draw-tool[data-tool="circle"]');
            if (circleTool) {
                await circleTool.click();
                await H.beat(page);
            }

            // Circle: right side
            await page.mouse.move(cx + 500, cy + 160, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 580, cy + 220, { steps: 20 });
            await page.mouse.up();
            await H.pause(page);

            // ─── Scene 5: Draw an Arrow ──────────────────────
            const arrowTool = await page.$('.me-draw-tool[data-tool="arrow"]');
            if (arrowTool) {
                await arrowTool.click();
                await H.beat(page);
            }

            // Arrow from rectangle to circle
            await page.mouse.move(cx + 260, cy + 160, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 490, cy + 160, { steps: 25 });
            await page.mouse.up();
            await H.pause(page);

            // ─── Scene 6: Draw second row ────────────────────
            // Rectangle 2: bottom-left
            if (rectTool) {
                await rectTool.click();
                await H.beat(page);
            }
            await page.mouse.move(cx + 100, cy + 320, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 260, cy + 400, { steps: 20 });
            await page.mouse.up();
            await H.beat(page);

            // Circle 2: bottom-right
            if (circleTool) {
                await circleTool.click();
                await H.beat(page);
            }
            await page.mouse.move(cx + 500, cy + 360, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 580, cy + 420, { steps: 20 });
            await page.mouse.up();
            await H.beat(page);

            // Arrows: bottom row + vertical
            if (arrowTool) {
                await arrowTool.click();
                await H.beat(page);
            }

            // Bottom horizontal arrow
            await page.mouse.move(cx + 260, cy + 360, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 490, cy + 360, { steps: 25 });
            await page.mouse.up();
            await H.beat(page);

            // Left vertical arrow
            await page.mouse.move(cx + 180, cy + 205, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 180, cy + 315, { steps: 20 });
            await page.mouse.up();
            await H.beat(page);

            // Right vertical arrow
            await page.mouse.move(cx + 540, cy + 225, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 540, cy + 345, { steps: 20 });
            await page.mouse.up();
            await H.pause(page);

            // ─── Scene 7: Add Text Labels ────────────────────
            const labelTool = await page.$('.me-draw-tool[data-tool="label"]');
            if (labelTool) {
                await labelTool.click();
                await H.beat(page);

                // Click to place label on top arrow
                await page.mouse.click(cx + 360, cy + 140);
                await H.beat(page);

                // Type label text (double-click to edit IText in Fabric)
                await page.keyboard.type('f', { delay: 80 });
                await H.beat(page);

                // Click elsewhere to deselect
                await page.mouse.click(cx + 50, cy + 50);
                await H.beat(page);
            }

            // ─── Scene 8: Change Color ───────────────────────
            // Select the select tool first
            const selectTool = await page.$('.me-draw-tool[data-tool="select"]');
            if (selectTool) {
                await selectTool.click();
                await H.beat(page);
            }

            // Click a red color swatch
            const redColor = await page.$('.me-draw-color[data-color="#ef4444"]');
            if (redColor) {
                await redColor.click();
                await H.beat(page);
            }

            // Draw a red dashed line
            const dashedTool = await page.$('.me-draw-tool[data-tool="dashed"]');
            if (dashedTool) {
                await dashedTool.click();
                await H.beat(page);
            }

            // Diagonal dashed line
            await page.mouse.move(cx + 260, cy + 200, { steps: 10 });
            await page.mouse.down();
            await page.mouse.move(cx + 490, cy + 345, { steps: 25 });
            await page.mouse.up();
            await H.pause(page);

            // ─── Scene 9: Change stroke width ────────────────
            const width4 = await page.$('.me-draw-width[data-width="4"]');
            if (width4) {
                await width4.click();
                await H.beat(page);
            }

            // Reset to blue
            const blueColor = await page.$('.me-draw-color[data-color="#3b82f6"]');
            if (blueColor) {
                await blueColor.click();
                await H.beat(page);
            }

            // ─── Scene 10: Toggle Grid ───────────────────────
            const gridToggle = await page.$('#draw-grid-toggle');
            if (gridToggle) {
                await gridToggle.click(); // turn off
                await H.pause(page);
                await gridToggle.click(); // turn back on
                await H.beat(page);
            }
        }

        // ─── Scene 11: Click Done — Insert into Document ────
        await H.longPause(page);

        const doneBtn = await page.$('.me-draw-done');
        if (doneBtn) {
            await doneBtn.click();
            await H.longPause(page);
        }

        // Drawing should now appear as an image in the editor
        await H.longPause(page);

        // ─── Scene 12: Double-click to Re-edit ──────────────
        await H.typeText(page, '');  // ensure editor focus
        await H.pressEnter(page);
        await H.typeText(page, 'Double-click the drawing above to re-edit it anytime.');
        await H.pause(page);

        // Double-click the drawing block to reopen
        const drawingBlock = await page.$('.me-drawing-block');
        if (drawingBlock) {
            await drawingBlock.dblclick();
            await H.longPause(page);

            // Show the modal opened with existing content
            await H.longPause(page);

            // Close without changes
            const cancelBtn = await page.$('.me-draw-cancel');
            if (cancelBtn) {
                await cancelBtn.click();
                await H.pause(page);
            } else {
                // Just close via Done
                const doneBtn2 = await page.$('.me-draw-done');
                if (doneBtn2) {
                    await doneBtn2.click();
                    await H.pause(page);
                }
            }
        }

        // ─── Scene 13: Final view ────────────────────────────
        await page.evaluate(() => {
            const wrapper = document.querySelector('.me-canvas-wrapper');
            if (wrapper) wrapper.scrollTo({ top: 0, behavior: 'smooth' });
        });
        await H.extraPause(page);

        console.log('Drawing demo recording complete!');
    } catch (err) {
        console.error('Recording error:', err.message);
    }

    await H.finishRecording(browser, context, page, outputDir, 'drawing-demo');
})();

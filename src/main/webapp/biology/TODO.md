# Biology — TODO

## Medium Priority

- [ ] **AI vision on user-uploaded microscopy images** — the "Add Image"
      card currently lets users upload a microscope photo (resized +
      saved to localStorage + viewable in the lightbox). Next step: when
      the upload completes, optionally POST the image to
      `/ai?action=vision` (AIProxyServlet → AI_ENDPOINT2 with gemma's
      multi-modal endpoint) with a system prompt like:

          "You are a cell biology tutor. Identify the cell type in this
          microscopy image and call out any organelles visible. Use plain
          text, 2-3 short paragraphs."

      Stream the response into a new "AI analysis" block below the image
      in the lightbox. Reuses the existing streaming pipeline already
      built for the AI Tutor panel (multi-turn, abort-aware, error
      states).

      Source files: `biology/cell-atlas.jsp` (file-input change handler,
      around the `resizeImageFile` callback; new lightbox sub-block in
      `.ca-lightbox-meta`). Reference implementation:
      `modern/js/ai-vision-modal.js` already does exactly this pattern
      for other tools — could reuse most of it.

      Held off in v1 per user direction. Revisit when ready.

- [ ] **AI vision on curated microscopy cards** — same endpoint, but
      sent against one of the already-shipped CC-licensed photos
      (animal-stained.jpg, plant-tem.png, etc.). Pre-canned prompt:
      "Annotate the organelles visible in this image of a [cell name]
      under [microscope technique]." Could surface as a new "Ask the
      tutor about this image" button in the lightbox meta bar. Builds
      on top of the user-upload vision item — share the pump-stream
      code path.

- [ ] **Next batch of cell additions (Egg + Adipocyte + Smooth Muscle)** —
      the three highest-value cells still missing from the atlas after the
      12 currently shipped. Each fills a clear curriculum gap:

      - **Egg Cell (Ovum)** — pairs with the existing sperm cell.
        Largest human cell; intro biology always teaches the pair.
        Procedural: large sphere + translucent zona pellucida shell +
        scattered cortical granules. `comparison: "sperm"`.

      - **Adipocyte (Fat Cell)** — fills the major tissue type missing
        for physiology / metabolism / obesity teaching. Procedural is
        trivial: outer sphere + single huge inner lipid sphere + thin
        cytoplasm shell + peripheral nucleus.

      - **Smooth Muscle Cell** — completes the muscle trio alongside
        existing skeletal muscle and cardiomyocyte. Spindle-shaped,
        single central nucleus, no sarcomere striations. Procedural:
        tapered double-cone capsule.

      Follow the established `cells-data.js` shape (id, accent, accentSoft,
      modelKind, defaultOrganelle, comparison, organelles[], microscope[],
      occurrence). Add 3 builders to `cell-scene.js` and register them in
      `PROCEDURAL_BUILDERS`. Launch the same Wikimedia-image-sourcing agent
      for 9 more micrographs (3 cells × 3 techniques). Update the 7→12→15
      count strings in `cell-atlas.jsp` and `index.jsp`.

      Effort: ~1-2 hours of geometry + data + image-sourcing.

- [ ] **Beyond +3: macrophage, photoreceptor (rod/cone), hepatocyte,
      T-cell, archaea cell** — diminishing returns past 15 cells, but
      each fills a niche. Macrophage and photoreceptor would be the next
      two strongest if anyone wants to extend further. Archaea would
      complete the three-domain coverage (we have bacteria but not
      archaea).

## Low Priority

- [ ] **Per-organelle picking on GLB cells** — animal, neuron, and bacteria
      GLBs are opaque to the canvas raycaster: every mesh inside them is
      tagged with the `"_asset_"` sentinel in `buildAssetGroup()`
      (`cell-scene.js`), and `organelleAtPointer()` explicitly filters
      that out. Result: hovering / clicking organelles in 3D works on the
      four procedural cells (plant, white-blood, epithelial, muscle) but
      does nothing on the three GLB cells — left-rail clicks still work
      both ways.

      Fix: inspect each NIH GLB in Blender, identify which named sub-mesh
      corresponds to which organelle, then build a per-cell
      `meshNameToOrganelleId` map in `cells-data.js`. Update
      `buildAssetGroup()` to tag each mesh's `userData.organelleId` from
      the map instead of the sentinel. ~1-2 hours per GLB.

      Source files: `biology/js/cell-scene.js` (`buildAssetGroup`,
      `organelleAtPointer`), `biology/js/cells-data.js` (per-cell
      `modelAsset`).

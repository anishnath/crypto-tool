# Bundled assets

This directory is Manic's production asset catalog. Files here are packaged
with releases and can be addressed from a `.manic` file with a stable
`asset:` URI, independent of the process working directory.

## Available assets

| URI | Type | Intended use |
|---|---|---|
| `asset:manic-logo.png` | PNG | The Manic mark in `image(...)` scenes or a Creator `logo=` field |
| `asset:models/manic-pyramid.obj` | geometry-only OBJ | A small generic pyramid for `model3` examples, prototypes, and spatial stories |
| `asset:models/manic-console.obj` | grouped geometry-only OBJ | A small `base`/`screen`/`key` assembly for `assembly3`, part callouts, and staged technical stories |
| `asset:svg/physics/effusion-reservoir.svg` | native vector SVG | A reusable thermal-reservoir/nozzle shell for process and statistical-mechanics stories |
| `asset:svg/physics/rocket-cutaway.svg` | native vector SVG | An educational cutaway rocket with payload, propellant tanks, chamber, nozzle, and fins |
| `asset:svg/physics/rocket-first-stage.svg` | native vector SVG | A reusable first-stage booster that can separate independently in launch stories |
| `asset:svg/physics/rocket-second-stage.svg` | native vector SVG | A reusable second-stage body and engine assembly |
| `asset:svg/physics/rocket-upper-stage.svg` | native vector SVG | A payload fairing and upper stage for multi-stage rocket explainers |
| `asset:svg/chem/plate-1536.svg` | native vector SVG | A 1536-well microplate on the real ANSI/SLAS footprint — 32 × 48 wells on a 2.25 mm pitch. Every well is its own subpath, so `{id}.p{i}` addresses one well |
| `asset:svg/chem/plate-384.svg` | native vector SVG | The 384-well plate, 16 × 24 on a 4.5 mm pitch |
| `asset:svg/chem/liquid-handler-frame.svg` | native vector SVG | The **static** half of a nanolitre liquid handler: gantry frame, rail, deck and plate |
| `asset:svg/chem/liquid-handler-head.svg` | native vector SVG | The **moving** half: the multi-channel head and its four tips (`{id}.p3`…`{id}.p6`) |
| `asset:svg/chem/thermomixer-body.svg` | native vector SVG | The **static** half of a benchtop thermomixer: chassis, display, knobs, feet |
| `asset:svg/chem/thermomixer-block.svg` | native vector SVG | The **moving** half: the dry aluminium plate block, the part `shake` should move |
| `asset:svg/chem/foil-seal.svg` | native vector SVG | Foil sealing tape with a peeled corner — why a 0.2 µL well survives 18 h at 60 °C |
| `asset:diagrams/aws/...` | PNG/SVG source package | Experimental Systems Kit PoC; official AWS Architecture Icons, accessed through stable kit names rather than authored paths |
| `asset:molecules/*.sdf` | MDL structure file (SDF) | Real molecules for `molecule3` — PubChem downloads, so the coordinates are computed conformers rather than anything drawn by hand. Listed in full below |

**Machines are shipped in parts on purpose.** `svg()` emits one native Manic entity per
subpath rather than a raster texture, so an imported drawing is already animatable — but a
machine imported from *one* file is one id, and a single id can only move as a blob. Split
across two files it is two ids, and then `shift` travels the liquid-handler head while its
frame holds still, and `shake` moves the thermomixer block while its feet do not. The rocket
stages above follow the same rule. Anything that has to change *parametrically* — a droplet
that falls at a chosen moment, a fill level, an indicator that changes colour — is not artwork
at all and belongs in the scene as a primitive. See `examples/reaction-ord-screen.manic`.

SMIL animation (`<animate>`, `<animateTransform>`, `<set>`) in an asset is **ignored**: the
importer resolves an SVG through `usvg` to a static render tree. This is deliberate — a SMIL
clock would not scrub with `--still`, would not compose inside `par`/`stagger`, and could not
be sequenced against the rest of the scene. Rig the art in parts and animate it with core
verbs instead.

The Manic logo, pyramid, and console were authored for this project and are covered by
the repository license. The AWS package is third-party official diagram artwork;
see `diagrams/aws/README.md` for provenance and usage constraints. OBJ imports
remain subject to Manic's file-size and geometry limits. Files under `fonts/`
are engine-internal and embedded into the binary; they are not public `asset:`
choices.

## Molecules (`molecules/`)

Byte-exact **PubChem** downloads, fetched with the public PUG REST endpoint:

```
https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/<CID>/record/SDF?record_type=3d
```

They are unmodified on purpose. The value of a `molecule3` scene is that the geometry came from
somewhere accountable, and editing the file — even to tidy a title line — would throw that away.
Two consequences worth knowing:

- **These are computed conformers, not measured structures.** PubChem optimises with MMFF94, so a
  bond length sits within about 0.05 Å of the experimental value rather than on it (its CO₂ gives a
  1.197 Å C=O against 1.163 Å measured). Right for teaching shape; not a source for a number you
  intend to quote.
- **The title line is the CID, not a name.** PubChem's 3-D records put the compound id there, so
  `water.sdf` is titled `962`. The reader treats a purely numeric title as an identifier and exposes
  it separately, which is why a scene should caption a molecule itself.

Files named **`<name>-2d.sdf`** are the **2-D depiction** record of the same compound — coordinates
laid out for reading, on a clean grid with regular hexagons. They are what `structure` needs, and
they are not interchangeable with the 3-D files: a 3-D conformer flattened is a tangle of crossing
bonds, and a 2-D depiction has no depth to show. `structure` refuses a 3-D file and names the fix.
The 2-D records also carry **wedge/hash stereo flags** in the bond block, which is where a
structural drawing's chirality comes from.

A few have **no 3-D conformer in PubChem** — mostly the inorganics and salts — so the 2-D depiction
is bundled instead and every z is zero. `is_flat()` reports that, and a scene that tilts such a
molecule will see it edge-on.

**192 molecules, 392 files** — the full table with compound ids is in
[`molecules/INDEX.md`](molecules/INDEX.md), grouped the way a syllabus is: inorganics and gases,
hydrocarbons, aromatics, solvents and acids, sugars, all twenty amino acids, nucleobases and
nucleotides, vitamins, lipids and steroids, neurotransmitters, medicines, flavours and famous
molecules, industrial monomers.

A few names have **no single compound record** and are deliberately absent: cellulose, starch and
haemoglobin are polymers or proteins rather than compounds, so PubChem has no one CID for them.
Insulin was fetched and then dropped — at 785 atoms its structural formula is unreadable and it has
no 3-D conformer, so it served neither kit.

**Licence.** PubChem is produced by the US National Center for Biotechnology Information, and its
records are in the public domain in the United States; NCBI asks that the source be cited rather
than implied to endorse anything. Chemical structures are facts about molecules and carry no
copyright of their own. Cite a compound by its CID above.

## Add another asset

1. Put it in a typed subdirectory such as `models/`, using a lowercase,
   descriptive filename.
2. Add its stable `asset:` URI to the table above and to the mdBook asset
   catalog.
3. Add or update a checked example that uses the URI. Do not make examples
   depend on an absolute path or their launch directory.
4. Keep imported models geometry-only. Do not add scripts, arbitrary shaders,
   or remote dependencies.
5. Run the full tests and mdBook build. The Linux, Docker, and playground
   pipelines copy the complete `assets/` tree, so no per-file deploy rule is
   required.

Ordinary filesystem paths are still accepted by `model3` for user-provided
models. A backend must provision those files itself; bundled assets should use
the `asset:` form.

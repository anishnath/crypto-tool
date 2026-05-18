/*
 * biology/js/cells-data.js
 *
 * Catalogue of the seven cell specimens rendered by Cell Atlas 3D, plus
 * the per-cell organelle / microscopy / occurrence data the right rail
 * and bottom panels read. Plain JS — no TypeScript, no imports.
 *
 * Asset paths are relative; the host page sets `window.BIOLOGY_ASSET_BASE`
 * (e.g. `${ctx}/biology/assets`) before this script loads. To migrate to a
 * jsDelivr / git-CDN later, just point that base at the CDN URL.
 *
 * Plant and white-blood cells render with procedural three.js geometry
 * (built in cell-scene.js). The other three eukaryotic cells (animal,
 * neuron, bacteria) load real NIH-3D GLB models self-hosted under
 * assets/models/.
 */
(function () {
    "use strict";

    var BASE = (typeof window !== "undefined" && window.BIOLOGY_ASSET_BASE) || "/biology/assets";

    function asset(path) { return BASE + path; }

    var cells = [
        {
            id: "plant",
            name: "Plant Cell",
            type: "Eukaryotic Cell",
            accent: "#4f8a3f",
            accentSoft: "#e5f1d8",
            color: "#81b64b",
            modelKind: "plant",
            defaultOrganelle: "nucleus",
            comparison: "animal",
            renderImage: { url: asset("/renders/plant.png"), aspect: "square" },
            // NOTE: original project shipped a user-supplied GLB here; we
            // fall back to procedural geometry to avoid hosting it.
            occurrence: {
                title: "Leaves, stems, roots",
                body: "Plant cells form tissues that store energy, move water, and turn sunlight into sugars.",
                motif: "leaf"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#b9d48a", pattern: "plant-light",
                    image: {
                        url:     asset("/microscopy/plant-light.jpg"),
                        caption: "Anacharis (Elodea) leaf cells at 400x showing cell walls and chloroplasts",
                        source:  "https://commons.wikimedia.org/wiki/File:Anacharis_Magnified.jpg",
                        credit:  "Lilyviolet / CC BY 4.0"
                    }
                },
                {
                    label: "Stained Selection", tone: "#cf8cc2", pattern: "plant-stain",
                    image: {
                        url:     asset("/microscopy/plant-stained.jpg"),
                        caption: "Stained onion root-tip cells under light microscope",
                        source:  "https://commons.wikimedia.org/wiki/File:Onion_cells_light_microscope.jpg",
                        credit:  "Bobjgalindo / CC BY-SA 4.0"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#9a9a8e", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/plant-tem.png"),
                        caption: "TEM of a chloroplast inside an Anemone leaf cell (12000x)",
                        source:  "https://commons.wikimedia.org/wiki/File:Chloroplast_in_leaf_of_Anemone_sp_TEM_12000x.png",
                        credit:  "and3k & caper437 / CC BY-SA 3.0"
                    }
                }
            ],
            organelles: [
                {
                    id: "nucleus",
                    name: "Nucleus",
                    subtitle: "The control center",
                    color: "#7047a8",
                    attributes: [
                        { label: "Size", value: "5 to 10 µm in diameter" },
                        { label: "Location", value: "Usually central" },
                        { label: "Visible in LM", value: "Yes" }
                    ],
                    note: "The nucleus is surrounded by a double membrane called the nuclear envelope, which contains pores that regulate molecular traffic.",
                    fact: "The nucleus was one of the first cell structures discovered."
                },
                {
                    id: "chloroplast",
                    name: "Chloroplast",
                    subtitle: "The light harvester",
                    color: "#5fa842",
                    attributes: [
                        { label: "Role", value: "Photosynthesis" },
                        { label: "Pigment", value: "Chlorophyll" },
                        { label: "Visible in LM", value: "Often" }
                    ],
                    note: "Chloroplasts convert light energy into chemical energy and give many plant tissues their green color.",
                    fact: "A single leaf cell can contain dozens of chloroplasts."
                },
                {
                    id: "vacuole",
                    name: "Vacuole",
                    subtitle: "The pressure reservoir",
                    color: "#62bdd2",
                    attributes: [
                        { label: "Volume", value: "Large central space" },
                        { label: "Content", value: "Water and solutes" },
                        { label: "Function", value: "Turgor support" }
                    ],
                    note: "The central vacuole stores water, ions, and small molecules while helping the plant cell remain firm.",
                    fact: "Vacuoles can occupy most of a mature plant cell."
                },
                {
                    id: "cellWall",
                    name: "Cell Wall",
                    subtitle: "The rigid frame",
                    color: "#7aa647",
                    attributes: [
                        { label: "Material", value: "Cellulose rich" },
                        { label: "Position", value: "Outer boundary" },
                        { label: "Function", value: "Protection" }
                    ],
                    note: "The cell wall gives plant cells their regular shape and protects the membrane beneath it.",
                    fact: "Cell walls help plants stand upright without a skeleton."
                },
                {
                    id: "mitochondrion",
                    name: "Mitochondrion",
                    subtitle: "The energy converter",
                    color: "#ce785c",
                    attributes: [
                        { label: "Size", value: "0.5 to 2 µm long" },
                        { label: "Function", value: "Cellular respiration" },
                        { label: "Visible in LM", value: "Rarely (specks)" }
                    ],
                    note: "Mitochondria release energy stored in sugars made by chloroplasts, supplying ATP for every reaction in the cell.",
                    fact: "A leaf cell may carry hundreds of mitochondria alongside its chloroplasts."
                },
                {
                    id: "er",
                    name: "Endoplasmic Reticulum",
                    subtitle: "The protein highway",
                    color: "#d97757",
                    attributes: [
                        { label: "Type", value: "Rough + smooth" },
                        { label: "Role", value: "Protein and lipid synthesis" },
                        { label: "Connects to", value: "Nuclear envelope" }
                    ],
                    note: "The endoplasmic reticulum threads through the cytoplasm as a folded membrane network, folding proteins and building lipids.",
                    fact: "Rough ER is studded with ribosomes; smooth ER has none."
                },
                {
                    id: "ribosomes",
                    name: "Ribosomes",
                    subtitle: "The protein builders",
                    color: "#a05f9f",
                    attributes: [
                        { label: "Size", value: "20 to 25 nm" },
                        { label: "Location", value: "Cytoplasm + rough ER" },
                        { label: "Role", value: "Translate mRNA" }
                    ],
                    note: "Ribosomes read genetic instructions from mRNA and string amino acids together into proteins. They float free or attach to the rough ER.",
                    fact: "A single plant cell may contain millions of ribosomes."
                },
                {
                    id: "golgi",
                    name: "Golgi Apparatus",
                    subtitle: "The shipping center",
                    color: "#d49057",
                    attributes: [
                        { label: "Shape", value: "Stack of flattened sacs" },
                        { label: "Role", value: "Sort and package proteins" },
                        { label: "Output", value: "Cell wall material, vesicles" }
                    ],
                    note: "The Golgi receives proteins from the ER, modifies them, and ships them in vesicles. In plants it also assembles cell-wall polysaccharides.",
                    fact: "Plant Golgi stacks are often called dictyosomes."
                },
                {
                    id: "plasmaMembrane",
                    name: "Plasma Membrane",
                    subtitle: "The selective gate",
                    color: "#b5cf95",
                    attributes: [
                        { label: "Structure", value: "Lipid bilayer" },
                        { label: "Position", value: "Inside the cell wall" },
                        { label: "Function", value: "Controls entry / exit" }
                    ],
                    note: "Under the rigid wall sits a thin lipid bilayer studded with proteins. It decides what crosses into and out of the cell.",
                    fact: "The cell wall is rigid scaffolding; the real gatekeeper is the membrane underneath."
                },
                {
                    id: "plasmodesmata",
                    name: "Plasmodesmata",
                    subtitle: "The plant-only channels",
                    color: "#c2a87a",
                    attributes: [
                        { label: "Width", value: "~50 nm" },
                        { label: "Cross", value: "The cell wall" },
                        { label: "Function", value: "Cell-to-cell transport" }
                    ],
                    note: "Plasmodesmata are tiny channels that pierce the cell wall, linking the cytoplasm of neighboring plant cells so they can share water, nutrients, and signals.",
                    fact: "Animal cells have no equivalent — plasmodesmata are unique to plants."
                }
            ]
        },
        {
            id: "whiteBlood",
            name: "White Blood Cell",
            type: "Immune Cell",
            accent: "#6d78a8",
            accentSoft: "#e6eaf7",
            color: "#b9bfd7",
            modelKind: "whiteBlood",
            defaultOrganelle: "lysosome",
            comparison: "epithelial",
            renderImage: { url: asset("/renders/white-blood.png"), aspect: "square" },
            // Original used a user-supplied GLB; procedural fallback here.
            occurrence: {
                title: "Blood, lymph, tissues",
                body: "White blood cells move through blood and tissue spaces to identify threats and coordinate immune defense.",
                motif: "blood"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#ded6e9", pattern: "blood-light",
                    image: {
                        url:     asset("/microscopy/whiteBlood-light.jpg"),
                        caption: "Segmented neutrophil with multilobed nucleus on stained blood smear",
                        source:  "https://commons.wikimedia.org/wiki/File:Segmented_neutrophil.jpg",
                        credit:  "Makysm / CC0"
                    }
                },
                {
                    label: "Stained Selection", tone: "#9c73be", pattern: "blood-stain",
                    image: {
                        url:     asset("/microscopy/whiteBlood-stained.jpg"),
                        caption: "Stained lymphocyte on peripheral blood smear",
                        source:  "https://commons.wikimedia.org/wiki/File:Lymph.jpg",
                        credit:  "Makysm / CC0"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#8f8f91", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/whiteBlood-tem.jpg"),
                        caption: "Electron micrograph of a neutrophil engulfing anthrax bacteria",
                        source:  "https://commons.wikimedia.org/wiki/File:Neutrophil_with_anthrax_copy.jpg",
                        credit:  "Volker Brinkmann / CC BY 2.5"
                    }
                }
            ],
            organelles: [
                {
                    id: "lysosome",
                    name: "Lysosome",
                    subtitle: "The cleanup vesicle",
                    color: "#8b54b7",
                    attributes: [
                        { label: "Size", value: "About 1 µm" },
                        { label: "Content", value: "Digestive enzymes" },
                        { label: "Role", value: "Breakdown" }
                    ],
                    note: "Lysosomes help immune cells digest engulfed material and recycle worn cellular components.",
                    fact: "White blood cells rely heavily on vesicles for defense."
                },
                {
                    id: "nucleus",
                    name: "Lobed Nucleus",
                    subtitle: "Flexible genome vault",
                    color: "#6f35a1",
                    attributes: [
                        { label: "Shape", value: "Often lobed" },
                        { label: "Location", value: "Central" },
                        { label: "Visible in LM", value: "Yes, with stain" }
                    ],
                    note: "Many white blood cells have a lobed nucleus that helps them squeeze through tight spaces.",
                    fact: "Nuclear shape is one clue used to identify immune cell types."
                },
                {
                    id: "granules",
                    name: "Granules",
                    subtitle: "The chemical packets",
                    color: "#c06696",
                    attributes: [
                        { label: "Content", value: "Proteins and enzymes" },
                        { label: "Use", value: "Defense" },
                        { label: "Visibility", value: "Stain dependent" }
                    ],
                    note: "Granules store molecules that help immune cells respond quickly to infection or inflammation.",
                    fact: "Some immune cells are named by how their granules stain."
                },
                {
                    id: "mitochondrion",
                    name: "Mitochondrion",
                    subtitle: "The energy converter",
                    color: "#ce785c",
                    attributes: [
                        { label: "Size", value: "0.5 to 2 µm long" },
                        { label: "Role", value: "ATP production" },
                        { label: "Why many?", value: "Immune cells are metabolically active" }
                    ],
                    note: "Immune cells burn through ATP during chemotaxis, engulfment, and burst respiration — they pack many mitochondria for the energy demand.",
                    fact: "Activated neutrophils can multiply their oxygen use by 100x in seconds — the 'respiratory burst' that kills swallowed microbes."
                },
                {
                    id: "er",
                    name: "Endoplasmic Reticulum",
                    subtitle: "The protein factory",
                    color: "#d97757",
                    attributes: [
                        { label: "Type", value: "Rough + smooth" },
                        { label: "Role", value: "Builds defense proteins" },
                        { label: "Heavy in", value: "B cells, plasma cells" }
                    ],
                    note: "Rough ER is studded with ribosomes that translate mRNA into proteins. In B cells it's massively expanded — they're antibody factories.",
                    fact: "A single plasma cell can secrete thousands of antibody molecules per second from its ER + Golgi assembly line."
                },
                {
                    id: "ribosomes",
                    name: "Ribosomes",
                    subtitle: "The protein builders",
                    color: "#a05f9f",
                    attributes: [
                        { label: "Size", value: "20 to 25 nm" },
                        { label: "Location", value: "Cytoplasm + rough ER" },
                        { label: "Role", value: "Translate mRNA into protein" }
                    ],
                    note: "Ribosomes string amino acids together to build the cytokines, antibodies, and enzymes the cell uses to fight pathogens.",
                    fact: "Immune cells crank ribosomes up sharply when activated by an infection."
                },
                {
                    id: "golgi",
                    name: "Golgi Apparatus",
                    subtitle: "The cytokine packager",
                    color: "#d49057",
                    attributes: [
                        { label: "Shape", value: "Stack of flattened sacs" },
                        { label: "Role", value: "Sort + ship signaling proteins" },
                        { label: "Output", value: "Cytokine + antibody vesicles" }
                    ],
                    note: "The Golgi tags, glycosylates, and bundles proteins from the ER into vesicles. Immune cells use it to ship cytokines and antibodies out of the cell.",
                    fact: "Cytokines released by Golgi vesicles can call thousands of other immune cells to a single infection site."
                },
                {
                    id: "plasmaMembrane",
                    name: "Plasma Membrane",
                    subtitle: "The pathogen-sensor",
                    color: "#b6c0e0",
                    attributes: [
                        { label: "Structure", value: "Lipid bilayer + receptors" },
                        { label: "Function", value: "Detects pathogens, controls entry" },
                        { label: "Special", value: "Forms pseudopodia for engulfment" }
                    ],
                    note: "The plasma membrane studs itself with pattern-recognition receptors that detect microbes, then bends inward to engulf them via phagocytosis.",
                    fact: "Toll-like receptors on this membrane were the discovery that won the 2011 Nobel Prize in Medicine."
                },
                {
                    id: "phagosome",
                    name: "Phagosome",
                    subtitle: "The pathogen prison",
                    color: "#aa8c5a",
                    attributes: [
                        { label: "Contents", value: "Engulfed bacterium or debris" },
                        { label: "Forms via", value: "Membrane wrapping (phagocytosis)" },
                        { label: "Fate", value: "Fuses with lysosome → kills" }
                    ],
                    note: "When an immune cell wraps its membrane around a pathogen, the pinched-off vesicle is a phagosome. Lysosomes fuse with it to dump enzymes that digest the contents.",
                    fact: "Phagocytosis was first described in 1882 by Élie Metchnikoff watching starfish larvae — it won him the 1908 Nobel Prize."
                }
            ]
        },
        {
            id: "neuron",
            name: "Neuron",
            type: "Nerve Cell",
            accent: "#6578b5",
            accentSoft: "#e4e9f8",
            color: "#8c91d0",
            modelKind: "neuron",
            defaultOrganelle: "axon",
            comparison: "muscle",
            renderImage: { url: asset("/renders/neuron.png"), aspect: "wide" },
            modelAsset: {
                url: asset("/models/neuron-nih.glb"),
                previewUrl: asset("/nih-previews/neuron-nih.png"),
                sourceLabel: "NIH 3D Neuron",
                sourceUrl: "https://3d.nih.gov/entries/3DPX-015796",
                scale: 3.15,
                rotation: [0.18, -0.24, -0.18],
                position: [0, 0.05, 0],
                exposure: 1.05
            },
            occurrence: {
                title: "Brain, spinal cord, nerves",
                body: "Neurons carry electrical and chemical signals through long branching networks.",
                motif: "nerve"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#c9c4ed", pattern: "neuron-light",
                    image: {
                        url:     asset("/microscopy/neuron-light.png"),
                        caption: "GFP-labelled pyramidal neuron in mouse cerebral cortex",
                        source:  "https://commons.wikimedia.org/wiki/File:GFPneuron.png",
                        credit:  "Wei-Chung Allen Lee et al. / CC BY 2.5"
                    }
                },
                {
                    label: "Stained Selection", tone: "#dc99cc", pattern: "neuron-stain",
                    image: {
                        url:     asset("/microscopy/neuron-stained.jpg"),
                        caption: "Golgi-stained neurons in human dentate gyrus, 40x",
                        source:  "https://commons.wikimedia.org/wiki/File:Gyrus_Dentatus_40x.jpg",
                        credit:  "MethoxyRoxy / CC BY-SA 2.5"
                    }
                },
                // No verified CC-licensed neuron TEM found on Wikimedia
                // Commons. Falls back to gradient placeholder + "coming
                // soon" toast via the page script's renderMicro.
                { label: "Electron Microscope", tone: "#8e8e94", pattern: "electron" }
            ],
            organelles: [
                {
                    id: "axon",
                    name: "Axon",
                    subtitle: "The signal highway",
                    color: "#6b7dc6",
                    labelPosition: [1.1, 0.2, 0.1],
                    attributes: [
                        { label: "Length", value: "µm to over 1 metre" },
                        { label: "Insulation", value: "Myelin sheath" },
                        { label: "Visible in LM", value: "Yes, with stain" }
                    ],
                    note: "Some axons in the human body run from the spine to the foot, making neurons among the longest cells in nature.",
                    fact: "A nerve impulse can travel at over 100 metres per second."
                },
                {
                    id: "soma",
                    name: "Soma",
                    subtitle: "The cell body",
                    color: "#7c52b7",
                    labelPosition: [-0.1, 0.7, 0.1],
                    attributes: [
                        { label: "Contains", value: "Nucleus" },
                        { label: "Role", value: "Metabolic hub" },
                        { label: "Shape", value: "Rounded" }
                    ],
                    note: "The soma maintains the neuron and integrates signals arriving from branching dendrites.",
                    fact: "Most neuron proteins are made in or near the soma."
                },
                {
                    id: "dendrites",
                    name: "Dendrites",
                    subtitle: "The receiving branches",
                    color: "#7d9bcf",
                    labelPosition: [-1.3, 1.0, 0.1],
                    attributes: [
                        { label: "Shape", value: "Branched" },
                        { label: "Role", value: "Input" },
                        { label: "Surface", value: "Often spiny" }
                    ],
                    note: "Dendrites increase the surface area available for receiving signals from other cells.",
                    fact: "A single neuron can receive thousands of synaptic inputs."
                },
                {
                    id: "nucleus",
                    name: "Nucleus",
                    subtitle: "The neuron's command center",
                    color: "#7047a8",
                    labelPosition: [-0.3, 0.4, 0.2],
                    attributes: [
                        { label: "Location", value: "Inside the soma" },
                        { label: "Size", value: "5 to 10 µm" },
                        { label: "Special", value: "Often a single prominent nucleolus" }
                    ],
                    note: "The nucleus sits at the center of the soma and produces the mRNA that codes for every protein the neuron uses — including ion channels, receptors, and neurotransmitter enzymes.",
                    fact: "Mature neurons don't divide — the nucleus you have at birth is the same one you'll keep your whole life."
                },
                {
                    id: "mitochondrion",
                    name: "Mitochondrion",
                    subtitle: "The neural power plant",
                    color: "#ce785c",
                    labelPosition: [-0.7, 0.55, 0.2],
                    attributes: [
                        { label: "Where", value: "Soma, axon, synapses" },
                        { label: "Role", value: "ATP for ion pumps" },
                        { label: "Why so many?", value: "Action potentials cost energy" }
                    ],
                    note: "Neurons spend more ATP than almost any other cell type — pumping sodium and potassium back across the membrane after every action potential. Mitochondria cluster especially densely at synapses.",
                    fact: "Your brain is 2% of your body weight but burns 20% of your daily energy — mitochondria in neurons are the reason."
                },
                {
                    id: "er",
                    name: "Endoplasmic Reticulum (Nissl Bodies)",
                    subtitle: "The neurotransmitter factory",
                    color: "#d97757",
                    labelPosition: [0.4, 0.55, 0.2],
                    attributes: [
                        { label: "Neuron name", value: "Nissl bodies" },
                        { label: "Where", value: "Densely packed in the soma" },
                        { label: "Role", value: "Builds receptors + enzymes" }
                    ],
                    note: "In neurons, rough ER and bound ribosomes cluster so densely in the soma that stained sections show distinct spots — Franz Nissl named them in 1894. They synthesize membrane channels, receptors, and the enzymes that make neurotransmitters.",
                    fact: "Nissl bodies are confined to the soma and dendrites — never the axon. That's how neuroanatomists tell parts of a stained neuron apart."
                },
                {
                    id: "golgi",
                    name: "Golgi Apparatus",
                    subtitle: "The vesicle shipper",
                    color: "#d49057",
                    labelPosition: [-0.05, 0.05, 0.2],
                    attributes: [
                        { label: "Where", value: "Soma, near the nucleus" },
                        { label: "Role", value: "Packages receptors + neurotransmitter enzymes" },
                        { label: "Output", value: "Vesicles to dendrites and axon" }
                    ],
                    note: "The Golgi receives proteins from the rough ER, sorts them, and packages them into vesicles destined for specific parts of the neuron — receptors travel to dendrites, neurotransmitter-making enzymes travel down the axon.",
                    fact: "Camillo Golgi discovered both this organelle AND the silver-staining method that made the first neuron drawings possible — he won the 1906 Nobel Prize alongside Ramón y Cajal."
                },
                {
                    id: "myelinSheath",
                    name: "Myelin Sheath",
                    subtitle: "The axon's insulation",
                    color: "#bfd1df",
                    labelPosition: [1.5, 0.5, 0.1],
                    attributes: [
                        { label: "Made by", value: "Schwann cells / oligodendrocytes" },
                        { label: "Composition", value: "Lipid-rich wrapping" },
                        { label: "Why?", value: "Speeds up signal conduction" }
                    ],
                    note: "Other glial cells wrap the axon in fatty layers that act as electrical insulation. Without myelin, neurons would conduct signals up to 100x slower.",
                    fact: "Multiple sclerosis is the autoimmune destruction of myelin — and it's why MS patients lose motor control as conduction fails."
                },
                {
                    id: "nodesOfRanvier",
                    name: "Nodes of Ranvier",
                    subtitle: "The signal-boosting gaps",
                    color: "#e8a76a",
                    labelPosition: [1.85, 0.7, 0.1],
                    attributes: [
                        { label: "Where", value: "Between myelin segments" },
                        { label: "Length", value: "About 1 µm" },
                        { label: "Role", value: "Saltatory conduction" }
                    ],
                    note: "The myelin sheath isn't continuous — small bare patches of axon appear between each Schwann cell. Action potentials 'jump' from one node to the next, dramatically speeding conduction.",
                    fact: "Saltatory conduction (from Latin saltare, 'to leap') makes myelinated axons up to 100x faster than unmyelinated ones."
                },
                {
                    id: "axonTerminal",
                    name: "Axon Terminal",
                    subtitle: "The signal sender",
                    color: "#b46ac7",
                    labelPosition: [2.2, 0.3, 0.1],
                    attributes: [
                        { label: "Where", value: "End of axon" },
                        { label: "Contains", value: "Synaptic vesicles" },
                        { label: "Role", value: "Releases neurotransmitter" }
                    ],
                    note: "When an action potential reaches the axon terminal, calcium pours in and synaptic vesicles fuse with the membrane, dumping neurotransmitter into the synaptic cleft. This is where one neuron talks to the next.",
                    fact: "A single axon can have thousands of terminals — pyramidal neurons in your cortex form ~10,000 synapses each."
                }
            ]
        },
        {
            id: "epithelial",
            name: "Epithelial Cell",
            type: "Human Tissue Cell",
            accent: "#a56d7f",
            accentSoft: "#f4e2e7",
            color: "#d79baa",
            modelKind: "epithelial",
            defaultOrganelle: "microvilli",
            comparison: "animal",
            renderImage: { url: asset("/renders/epithelial.png"), aspect: "square" },
            occurrence: {
                title: "Skin, intestine, airways",
                body: "Epithelial cells form protective sheets and absorption surfaces across the body.",
                motif: "surface"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#e6a4bd", pattern: "tissue-light",
                    image: {
                        url:     asset("/microscopy/epithelial-light.jpg"),
                        caption: "Human cheek cells (stratified squamous epithelium) at 500x",
                        source:  "https://commons.wikimedia.org/wiki/File:Cheekcells_stained.jpg",
                        credit:  "Mulletsrokk / CC BY-SA 3.0"
                    }
                },
                {
                    label: "Stained Selection", tone: "#cb72a4", pattern: "tissue-stain",
                    image: {
                        url:     asset("/microscopy/epithelial-stained.jpg"),
                        caption: "H&E-stained intestinal epithelium with goblet cells",
                        source:  "https://commons.wikimedia.org/wiki/File:Normal_epithelium_with_goblet_cells_-_3_--_very_high_mag_(cropped).jpg",
                        credit:  "Nephron / CC BY-SA 3.0"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#989899", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/epithelial-tem.jpg"),
                        caption: "TEM of human jejunum epithelial cell showing microvilli",
                        source:  "https://commons.wikimedia.org/wiki/File:Human_jejunum_microvilli_2_-_TEM.jpg",
                        credit:  "Louisa Howard & Katherine Connollly / Public domain"
                    }
                }
            ],
            organelles: [
                {
                    id: "microvilli",
                    name: "Microvilli",
                    subtitle: "The absorption brush",
                    color: "#c86f80",
                    attributes: [
                        { label: "Length", value: "0.5 to 1 µm" },
                        { label: "Location", value: "Apical surface" },
                        { label: "Role", value: "Surface area" }
                    ],
                    note: "Microvilli increase surface area for absorption and secretion along epithelial sheets.",
                    fact: "Intestinal microvilli form a dense brush border."
                },
                {
                    id: "junctions",
                    name: "Tight Junctions",
                    subtitle: "The sealed seams",
                    color: "#9f6cbd",
                    attributes: [
                        { label: "Position", value: "Between cells" },
                        { label: "Role", value: "Barrier" },
                        { label: "Visibility", value: "EM preferred" }
                    ],
                    note: "Tight junctions link neighboring epithelial cells and control what passes between them.",
                    fact: "Epithelial barriers are essential for organ boundaries."
                },
                {
                    id: "nucleus",
                    name: "Nucleus",
                    subtitle: "The instruction store",
                    color: "#7a4aa2",
                    attributes: [
                        { label: "Position", value: "Basal to central" },
                        { label: "Shape", value: "Oval" },
                        { label: "Visible in LM", value: "Yes" }
                    ],
                    note: "The epithelial nucleus stores genetic information and changes position depending on tissue shape.",
                    fact: "Nuclear shape helps pathologists read tissue samples."
                },
                {
                    id: "plasmaMembrane",
                    name: "Plasma Membrane",
                    subtitle: "The polarized boundary",
                    color: "#d79baa",
                    attributes: [
                        { label: "Faces", value: "Apical + basolateral" },
                        { label: "Made of", value: "Lipid bilayer + proteins" },
                        { label: "Special", value: "Different proteins on each side" }
                    ],
                    note: "Epithelial cells are polarized — the apical (top) and basolateral (sides + bottom) faces of the plasma membrane carry different transporters and receptors. That's how intestinal cells absorb nutrients in one direction.",
                    fact: "Glucose transporters on the apical side and Na+/K+ pumps on the basolateral side are what move sugar from your gut into your bloodstream."
                },
                {
                    id: "mitochondrion",
                    name: "Mitochondrion",
                    subtitle: "The transport powerhouse",
                    color: "#ce785c",
                    attributes: [
                        { label: "Length", value: "0.5 to 2 µm" },
                        { label: "Why many?", value: "Active transport is ATP-hungry" },
                        { label: "Heavy in", value: "Intestine, kidney epithelia" }
                    ],
                    note: "Cells that pump nutrients against gradients — intestinal villi, kidney tubules — pack mitochondria densely along their basolateral membranes to fuel the Na+/K+ pumps.",
                    fact: "Kidney proximal tubule cells are so mitochondria-rich the EM images look like tessellated honeycomb."
                },
                {
                    id: "er",
                    name: "Endoplasmic Reticulum",
                    subtitle: "The protein factory",
                    color: "#d97757",
                    attributes: [
                        { label: "Type", value: "Rough + smooth" },
                        { label: "Role", value: "Builds secreted proteins" },
                        { label: "Notable in", value: "Goblet cells (mucus)" }
                    ],
                    note: "Secretory epithelia — goblet cells in the intestine, mucus cells in airways — have hugely expanded rough ER for protein production. The ER folds membrane proteins, mucins, and digestive enzymes.",
                    fact: "A single goblet cell can be 80% ER by volume when it's actively churning out mucus."
                },
                {
                    id: "ribosomes",
                    name: "Ribosomes",
                    subtitle: "The protein builders",
                    color: "#a05f9f",
                    attributes: [
                        { label: "Type", value: "80S eukaryotic" },
                        { label: "Location", value: "Cytoplasm + rough ER" },
                        { label: "Role", value: "Translate mRNA into protein" }
                    ],
                    note: "Ribosomes string amino acids into proteins. Free ribosomes make cytoplasmic proteins; rough-ER-bound ribosomes make secreted and membrane proteins.",
                    fact: "Epithelial turnover is fast — intestinal lining cells live only 3-5 days, so their ribosomes never stop."
                },
                {
                    id: "golgi",
                    name: "Golgi Apparatus",
                    subtitle: "The polarity sorter",
                    color: "#d49057",
                    attributes: [
                        { label: "Shape", value: "Flattened sac stack" },
                        { label: "Role", value: "Sorts apical vs basolateral cargo" },
                        { label: "Position", value: "Above the nucleus" }
                    ],
                    note: "The Golgi is the traffic-control point for epithelial polarity — it decides which membrane proteins go to the apical surface and which go to the basolateral side, packaging them into different vesicle types.",
                    fact: "The Golgi tags each protein with a 'shipping address' lipid that targets it to one face or the other."
                },
                {
                    id: "basementMembrane",
                    name: "Basement Membrane",
                    subtitle: "The anchor layer",
                    color: "#a87f64",
                    attributes: [
                        { label: "What", value: "Extracellular protein mat" },
                        { label: "Position", value: "Below the basal surface" },
                        { label: "Made of", value: "Collagen IV + laminin" }
                    ],
                    note: "Epithelia don't float free — they sit on a thin sheet of structural proteins (collagen IV, laminin, fibronectin) that anchors them to the connective tissue below. It's the defining feature that separates epithelium from underlying stroma.",
                    fact: "Most carcinomas (cancers from epithelial cells) only become invasive once they break through this basement membrane — pathologists watch for that breach to grade tumors."
                },
                {
                    id: "desmosomes",
                    name: "Desmosomes",
                    subtitle: "The cell-to-cell rivets",
                    color: "#c44b6e",
                    attributes: [
                        { label: "Where", value: "Lateral surfaces" },
                        { label: "Role", value: "Mechanical anchoring" },
                        { label: "Made of", value: "Cadherin proteins + keratin" }
                    ],
                    note: "Different from tight junctions — desmosomes are spot-weld connections that lock neighboring cells together against pulling forces. Densest in skin and heart muscle, where tissues stretch constantly.",
                    fact: "In pemphigus vulgaris, antibodies attack desmosomes — skin cells stop sticking together and the skin literally peels off in sheets."
                }
            ]
        },
        {
            id: "bacteria",
            name: "Bacteria Cell",
            type: "Prokaryotic Cell",
            accent: "#48a77d",
            accentSoft: "#dbf1e7",
            color: "#65b8ae",
            modelKind: "bacteria",
            defaultOrganelle: "nucleoid",
            comparison: "animal",
            renderImage: { url: asset("/renders/bacteria.png"), aspect: "landscape" },
            modelAsset: {
                url: asset("/models/bacteria-wall-nih.glb"),
                previewUrl: asset("/nih-previews/bacteria-wall-nih.png"),
                sourceLabel: "NIH 3D Gram Positive Cell Wall",
                sourceUrl: "https://3d.nih.gov/entries/3DPX-010752",
                scale: 0.00185,
                rotation: [0.08, -0.44, -0.08],
                position: [0, -0.1, 0],
                exposure: 1.1
            },
            occurrence: {
                title: "Soil, water, gut, skin",
                body: "Bacteria live in nearly every environment and can exist as independent single cells.",
                motif: "microbe"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#c7b8eb", pattern: "bacteria-light",
                    image: {
                        url:     asset("/microscopy/bacteria-light.jpg"),
                        caption: "Brightfield microscopy of Pseudescherichia vulneris (rods)",
                        source:  "https://commons.wikimedia.org/wiki/File:Pseudescherichia_vulneris_Gram_Stain.jpg",
                        credit:  "Pérez et al. / CC BY 4.0"
                    }
                },
                {
                    label: "Stained Selection", tone: "#dc6e96", pattern: "bacteria-stain",
                    image: {
                        url:     asset("/microscopy/bacteria-stained.jpg"),
                        caption: "Gram-positive Staphylococcus aureus in clusters (Gram stain)",
                        source:  "https://commons.wikimedia.org/wiki/File:Staphylococcus_aureus_Gram_stain.jpg",
                        credit:  "Graham Beards / CC BY-SA 4.0"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#8c8c8c", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/bacteria-tem.jpg"),
                        caption: "TEM of Bacillus subtilis bacterium (Tecnai T-12)",
                        source:  "https://commons.wikimedia.org/wiki/File:Bacillus_subtilis.jpg",
                        credit:  "Allon Weiner / Public domain"
                    }
                }
            ],
            organelles: [
                {
                    id: "nucleoid",
                    name: "Nucleoid",
                    subtitle: "The naked genome",
                    color: "#7a43ad",
                    labelPosition: [0.0, 0.3, 0.1],
                    attributes: [
                        { label: "Size", value: "About 1 µm region" },
                        { label: "Membrane", value: "None" },
                        { label: "Visible in LM", value: "No, EM only" }
                    ],
                    note: "Unlike eukaryotic cells, bacteria have no nuclear envelope. Their DNA floats in a cytoplasm region called the nucleoid.",
                    fact: "There are more bacterial cells in your body than many people expect."
                },
                {
                    id: "cellWall",
                    name: "Cell Wall",
                    subtitle: "The protective shell",
                    color: "#55aa89",
                    labelPosition: [0.0, 1.1, 0.1],
                    attributes: [
                        { label: "Material", value: "Peptidoglycan" },
                        { label: "Role", value: "Shape and defense" },
                        { label: "Position", value: "Outside membrane" }
                    ],
                    note: "The bacterial cell wall helps cells resist pressure and gives many species their characteristic shapes.",
                    fact: "Gram staining reveals differences in bacterial wall structure."
                },
                {
                    id: "flagellum",
                    name: "Flagellum",
                    subtitle: "The swimming tail",
                    color: "#b87438",
                    labelPosition: [-1.3, -0.4, 0.1],
                    attributes: [
                        { label: "Role", value: "Movement" },
                        { label: "Shape", value: "Helical filament" },
                        { label: "Visible in LM", value: "Special stain" }
                    ],
                    note: "Some bacteria rotate flagella like tiny motors to move through liquid environments.",
                    fact: "Bacterial flagella are powered by ion gradients."
                },
                {
                    id: "plasmaMembrane",
                    name: "Plasma Membrane",
                    subtitle: "The inner barrier",
                    color: "#7ac6b8",
                    labelPosition: [0.0, -0.85, 0.1],
                    attributes: [
                        { label: "Structure", value: "Lipid bilayer" },
                        { label: "Position", value: "Inside the cell wall" },
                        { label: "Function", value: "Selective transport + energy" }
                    ],
                    note: "Inside the rigid cell wall sits a thin lipid bilayer. Unlike eukaryotic cells, bacteria run their entire energy-generating respiratory chain on this membrane — they have no mitochondria.",
                    fact: "Penicillin doesn't touch the membrane — it disrupts cell wall synthesis, which is why it's harmless to your own cells but lethal to bacteria."
                },
                {
                    id: "ribosomes",
                    name: "Ribosomes (70S)",
                    subtitle: "The protein builders",
                    color: "#a05f9f",
                    labelPosition: [0.55, 0.4, 0.1],
                    attributes: [
                        { label: "Type", value: "70S (different from eukaryotic 80S)" },
                        { label: "Subunits", value: "50S + 30S" },
                        { label: "Role", value: "Translate mRNA" }
                    ],
                    note: "Bacterial ribosomes are smaller and structurally distinct from your own — which is precisely why many antibiotics work. Tetracycline, streptomycin, and erythromycin all target the 70S ribosome.",
                    fact: "Mitochondria and chloroplasts contain 70S ribosomes too — evidence they descended from ancient bacteria swallowed by early eukaryotes."
                },
                {
                    id: "plasmid",
                    name: "Plasmid",
                    subtitle: "The accessory DNA loop",
                    color: "#d04c8a",
                    labelPosition: [0.85, -0.2, 0.1],
                    attributes: [
                        { label: "Shape", value: "Small circular DNA" },
                        { label: "Carries", value: "Antibiotic resistance genes" },
                        { label: "Spread by", value: "Horizontal transfer" }
                    ],
                    note: "Separate from the main nucleoid chromosome, plasmids are small circular DNA molecules that bacteria can copy and pass to neighbors — including across species. This is how antibiotic resistance spreads through a population in days.",
                    fact: "Every recombinant-DNA biotech tool you've heard of, from insulin production to CRISPR delivery, was built on bacterial plasmids."
                },
                {
                    id: "pili",
                    name: "Pili",
                    subtitle: "The grappling hooks",
                    color: "#c98f3e",
                    labelPosition: [0.5, 0.95, 0.1],
                    attributes: [
                        { label: "Length", value: "1 to 10 µm" },
                        { label: "Made of", value: "Pilin protein" },
                        { label: "Role", value: "Adhesion + DNA transfer" }
                    ],
                    note: "Pili are hair-like surface fibers — shorter and thinner than the flagellum. Bacteria use them to stick to surfaces (yours included) and to swap plasmids directly with other cells through a specialized 'sex pilus'.",
                    fact: "The reason a urinary tract infection sticks instead of getting flushed out is E. coli's adhesive pili gripping the bladder wall."
                },
                {
                    id: "capsule",
                    name: "Capsule",
                    subtitle: "The slime shield",
                    color: "#a8d3c4",
                    labelPosition: [-0.7, 0.95, 0.1],
                    attributes: [
                        { label: "Material", value: "Polysaccharide slime" },
                        { label: "Position", value: "Outside the cell wall" },
                        { label: "Role", value: "Hides from immune system" }
                    ],
                    note: "Some bacteria coat themselves in a slippery polysaccharide layer that helps them evade white blood cells, resist drying out, and form biofilms on surfaces.",
                    fact: "Streptococcus pneumoniae's capsule is what made it deadly before vaccines — without it, the bacterium is harmless because immune cells can grab it."
                }
            ]
        },
        {
            id: "animal",
            name: "Animal Cell",
            type: "Eukaryotic Cell",
            accent: "#9b74b7",
            accentSoft: "#efe5f6",
            color: "#9db6dc",
            modelKind: "animal",
            defaultOrganelle: "mitochondrion",
            comparison: "plant",
            renderImage: { url: asset("/renders/animal.png"), aspect: "square" },
            modelAsset: {
                url: asset("/models/animal-cell-nih.glb"),
                previewUrl: asset("/nih-previews/animal-cell-nih.png"),
                sourceLabel: "NIH 3D Animal Cell",
                sourceUrl: "https://3d.nih.gov/entries/3DPX-015797",
                scale: 0.044,
                rotation: [0.24, -0.08, 0.03],
                position: [0, -0.03, 0],
                exposure: 1.12
            },
            occurrence: {
                title: "Animal tissues",
                body: "Animal cells form flexible tissues with membranes, internal organelles, and specialized signaling structures.",
                motif: "animal"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#d9a7c7", pattern: "animal-light",
                    image: {
                        url:     asset("/microscopy/animal-light.jpg"),
                        caption: "Multiphoton fluorescence image of cultured HeLa cells",
                        source:  "https://commons.wikimedia.org/wiki/File:HeLa-I.jpg",
                        credit:  "NIH / Public domain"
                    }
                },
                {
                    label: "Stained Selection", tone: "#b889da", pattern: "animal-stain",
                    image: {
                        url:     asset("/microscopy/animal-stained.jpg"),
                        caption: "HeLa cells stained for tubulin, HSP60, fibrillarin and DNA",
                        source:  "https://commons.wikimedia.org/wiki/File:HeLa-Tubulin-HSP60-Fibrillarin-DNA.jpg",
                        credit:  "Gerry Shaw / CC BY-SA 4.0"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#8b8b8d", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/animal-tem.jpg"),
                        caption: "TEM of mammalian club (Clara) cell showing nucleus and organelles",
                        source:  "https://commons.wikimedia.org/wiki/File:Clara_cell_lung_-_TEM.jpg",
                        credit:  "Louisa Howard / Public domain"
                    }
                }
            ],
            organelles: [
                {
                    id: "mitochondrion",
                    name: "Mitochondrion",
                    subtitle: "The energy converter",
                    color: "#cf6f42",
                    labelPosition: [0.7, 0.5, 0.2],
                    attributes: [
                        { label: "Length", value: "1 to 10 µm" },
                        { label: "Membrane", value: "Double" },
                        { label: "Role", value: "ATP production" }
                    ],
                    note: "Mitochondria convert fuel molecules into usable cellular energy through folded inner membranes.",
                    fact: "Mitochondria contain their own small DNA genome."
                },
                {
                    id: "nucleus",
                    name: "Nucleus",
                    subtitle: "The command room",
                    color: "#7a49b0",
                    labelPosition: [0.0, 0.6, 0.2],
                    attributes: [
                        { label: "Shape", value: "Rounded" },
                        { label: "Membrane", value: "Double" },
                        { label: "Visible in LM", value: "Yes" }
                    ],
                    note: "The nucleus stores chromosomes and regulates which genes are active in a cell.",
                    fact: "Not all animal cells keep a nucleus. Mature red blood cells lose theirs."
                },
                {
                    id: "golgi",
                    name: "Golgi Apparatus",
                    subtitle: "The packaging stack",
                    color: "#d49057",
                    labelPosition: [-0.7, 0.4, 0.2],
                    attributes: [
                        { label: "Shape", value: "Flattened stacks" },
                        { label: "Role", value: "Modify and sort" },
                        { label: "Position", value: "Near nucleus" }
                    ],
                    note: "The Golgi apparatus modifies, sorts, and ships proteins and lipids to their destinations.",
                    fact: "Secretory cells often have a prominent Golgi apparatus."
                },
                {
                    id: "plasmaMembrane",
                    name: "Plasma Membrane",
                    subtitle: "The selective boundary",
                    color: "#9db6dc",
                    labelPosition: [0.0, 1.0, 0.2],
                    attributes: [
                        { label: "Structure", value: "Lipid bilayer + proteins" },
                        { label: "Role", value: "Controls entry / exit" },
                        { label: "No wall", value: "Why animal cells are flexible" }
                    ],
                    note: "Without a rigid cell wall, the plasma membrane is the entire boundary of an animal cell. Studded with receptors, transporters, and ion channels, it decides what crosses in and out — and signals when neighbors come knocking.",
                    fact: "The fluid-mosaic model proposed in 1972 — proteins floating in a lipid sea — is still how we describe this membrane today."
                },
                {
                    id: "er",
                    name: "Endoplasmic Reticulum",
                    subtitle: "The protein highway",
                    color: "#d97757",
                    labelPosition: [0.3, 0.15, 0.2],
                    attributes: [
                        { label: "Type", value: "Rough + smooth" },
                        { label: "Role", value: "Protein and lipid synthesis" },
                        { label: "Connects to", value: "Nuclear envelope" }
                    ],
                    note: "An interconnected membrane network spreading out from the nuclear envelope. Rough ER (with bound ribosomes) builds proteins; smooth ER builds lipids and detoxifies drugs.",
                    fact: "Liver cells are packed with smooth ER — it's how your liver neutralizes alcohol and most medications."
                },
                {
                    id: "ribosomes",
                    name: "Ribosomes (80S)",
                    subtitle: "The protein builders",
                    color: "#a05f9f",
                    labelPosition: [0.5, -0.35, 0.2],
                    attributes: [
                        { label: "Type", value: "80S (60S + 40S subunits)" },
                        { label: "Location", value: "Cytoplasm + rough ER" },
                        { label: "Role", value: "Translate mRNA into protein" }
                    ],
                    note: "Eukaryotic ribosomes are larger than bacterial 70S ribosomes. Free ribosomes make cytoplasmic proteins; ribosomes bound to rough ER make proteins destined for secretion or membranes.",
                    fact: "A single animal cell can carry millions of ribosomes — they make up roughly 25% of a cell's dry mass."
                },
                {
                    id: "lysosome",
                    name: "Lysosome",
                    subtitle: "The waste digester",
                    color: "#8b54b7",
                    labelPosition: [-0.55, -0.45, 0.2],
                    attributes: [
                        { label: "Contents", value: "60+ digestive enzymes" },
                        { label: "Internal pH", value: "About 4.5 (acidic)" },
                        { label: "Animal-only", value: "Plants use vacuoles instead" }
                    ],
                    note: "Membrane-bound vesicles full of acidic enzymes that digest worn-out organelles, engulfed bacteria, and damaged proteins. They're the cell's recycling and waste-disposal plant.",
                    fact: "Tay-Sachs disease, Pompe disease, and dozens of other inherited illnesses are 'lysosomal storage disorders' — failures of specific lysosomal enzymes."
                },
                {
                    id: "centrosome",
                    name: "Centrosome",
                    subtitle: "The cell-division organizer",
                    color: "#67b1c4",
                    labelPosition: [0.0, -0.65, 0.2],
                    attributes: [
                        { label: "Made of", value: "Two perpendicular centrioles" },
                        { label: "Role", value: "Microtubule organizing center" },
                        { label: "Animal-only", value: "Plants lack centrioles" }
                    ],
                    note: "A pair of cylinder-shaped centrioles set at right angles, sitting near the nucleus. During mitosis they duplicate, move to opposite poles, and grow the spindle fibers that pull chromosomes apart.",
                    fact: "Most plant cells divide without centrioles entirely — one of the cleanest visible differences between animal and plant cells."
                }
            ]
        },
        {
            id: "muscle",
            name: "Muscle Cell",
            type: "Muscle Fiber",
            accent: "#bd514d",
            accentSoft: "#f5dfdc",
            color: "#ca6678",
            modelKind: "muscle",
            defaultOrganelle: "myofibril",
            comparison: "neuron",
            renderImage: { url: asset("/renders/muscle.png"), aspect: "wide" },
            occurrence: {
                title: "Skeletal muscles",
                body: "Muscle fibers contain repeating contractile bundles that shorten to generate force.",
                motif: "muscle"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#ef9aab", pattern: "muscle-light",
                    image: {
                        url:     asset("/microscopy/muscle-light.jpg"),
                        caption: "Striated skeletal muscle fibres at 200x",
                        source:  "https://commons.wikimedia.org/wiki/File:Skeletal_Muscle_Tissue.jpg",
                        credit:  "Community College Bioscience / CC0"
                    }
                },
                {
                    label: "Stained Selection", tone: "#c7508d", pattern: "muscle-stain",
                    image: {
                        url:     asset("/microscopy/muscle-stained.jpg"),
                        caption: "H&E-stained skeletal muscle (FNA, intermediate magnification)",
                        source:  "https://commons.wikimedia.org/wiki/File:Skeletal_muscle_-_FNA_1_-_intermed_mag.jpg",
                        credit:  "Nephron / CC BY-SA 4.0"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#8d8d8d", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/muscle-tem.jpg"),
                        caption: "TEM of human skeletal muscle showing myofibrils and sarcomere bands",
                        source:  "https://commons.wikimedia.org/wiki/File:Human_skeletal_muscle_tissue_2_-_TEM.jpg",
                        credit:  "Louisa Howard / Public domain"
                    }
                }
            ],
            organelles: [
                {
                    id: "myofibril",
                    name: "Myofibril",
                    subtitle: "The contracting thread",
                    color: "#bd3d51",
                    attributes: [
                        { label: "Diameter", value: "About 1 µm" },
                        { label: "Arrangement", value: "Striated bundles" },
                        { label: "Visible in LM", value: "Yes, banded" }
                    ],
                    note: "Each muscle fiber contains hundreds to thousands of myofibrils running its full length, packed tightly together.",
                    fact: "A single muscle fiber can be up to 30 cm long."
                },
                {
                    id: "sarcolemma",
                    name: "Sarcolemma",
                    subtitle: "The excitable membrane",
                    color: "#d7b284",
                    attributes: [
                        { label: "Position", value: "Outer surface" },
                        { label: "Role", value: "Signal spread" },
                        { label: "Type", value: "Cell membrane" }
                    ],
                    note: "The sarcolemma conducts electrical signals that trigger contraction throughout the muscle fiber.",
                    fact: "Membrane signals reach deep into fibers through T tubules."
                },
                {
                    id: "mitochondrion",
                    name: "Mitochondrion",
                    subtitle: "The endurance supply",
                    color: "#cf7042",
                    attributes: [
                        { label: "Role", value: "ATP for contraction" },
                        { label: "Position", value: "Between myofibrils" },
                        { label: "Density", value: "Activity dependent" }
                    ],
                    note: "Skeletal muscle packs mitochondria between myofibrils to fuel the millions of myosin power-strokes per contraction. Slow-twitch ('red') fibers carry many more than fast-twitch ('white') fibers.",
                    fact: "Endurance training literally builds more mitochondria — that's why marathoners' muscles look darker than sprinters'."
                },
                {
                    id: "nucleus",
                    name: "Nucleus (multinucleated)",
                    subtitle: "The many command centers",
                    color: "#7a4aa2",
                    attributes: [
                        { label: "Count per cell", value: "Hundreds" },
                        { label: "Position", value: "Near the sarcolemma" },
                        { label: "Origin", value: "Fused myoblasts" }
                    ],
                    note: "Skeletal muscle fibers form when many myoblast cells fuse end-to-end into one giant cell — so the fiber carries hundreds of nuclei, lined up just beneath the sarcolemma. No other cell in your body works this way.",
                    fact: "A single 30 cm muscle fiber from your thigh can carry over 3,000 nuclei."
                },
                {
                    id: "tTubules",
                    name: "T-Tubules",
                    subtitle: "The signal-delivery tunnels",
                    color: "#ead2a7",
                    attributes: [
                        { label: "What", value: "Sarcolemma invaginations" },
                        { label: "Role", value: "Carry action potential deep" },
                        { label: "Pair with", value: "Sarcoplasmic reticulum" }
                    ],
                    note: "Action potentials racing along the sarcolemma can't reach the inner myofibrils fast enough — so the membrane folds inward as T-tubules that dive between every sarcomere, delivering the electrical signal everywhere within microseconds.",
                    fact: "Each myofibril is wrapped by T-tubules every ~2 µm, exactly where a sarcomere begins."
                },
                {
                    id: "sarcoplasmicReticulum",
                    name: "Sarcoplasmic Reticulum",
                    subtitle: "The calcium reservoir",
                    color: "#b9c7e9",
                    attributes: [
                        { label: "What", value: "Modified smooth ER" },
                        { label: "Stores", value: "Ca²⁺ ions" },
                        { label: "Releases when", value: "T-tubule fires" }
                    ],
                    note: "A network of membrane sleeves wrapping each myofibril, filled with calcium. When the T-tubule signal arrives, the SR dumps Ca²⁺ into the cytoplasm — calcium binds troponin and contraction fires.",
                    fact: "Malignant hyperthermia (a fatal anesthesia reaction) is caused by a defective Ca²⁺ release channel in this membrane."
                },
                {
                    id: "zDisc",
                    name: "Z-Disc",
                    subtitle: "The sarcomere boundary",
                    color: "#e8a76a",
                    attributes: [
                        { label: "Spacing", value: "About 2 µm apart" },
                        { label: "Anchors", value: "Actin filaments" },
                        { label: "Visible", value: "The striations in EM" }
                    ],
                    note: "Each myofibril is built from repeating sarcomere units. The Z-discs are the protein-rich boundaries between units — they anchor the thin actin filaments. When the muscle contracts, neighboring Z-discs are pulled toward each other.",
                    fact: "Z-disc-to-Z-disc distance is what microscopists count as 'sarcomere length' — it shortens from ~2.5 µm at rest to ~1.5 µm at full contraction."
                },
                {
                    id: "ribosomes",
                    name: "Ribosomes",
                    subtitle: "The protein builders",
                    color: "#a05f9f",
                    attributes: [
                        { label: "Type", value: "80S eukaryotic" },
                        { label: "Role", value: "Builds actin, myosin, titin" },
                        { label: "Spike during", value: "Hypertrophy" }
                    ],
                    note: "Muscle proteins turn over constantly — actin, myosin, and the giant titin filament are all built locally by ribosomes between the myofibrils. Strength training spikes ribosomal output for days.",
                    fact: "Titin is the largest protein in the body — a single titin molecule spans an entire half-sarcomere and contains over 33,000 amino acids."
                }
            ]
        },
        {
            id: "redBlood",
            name: "Red Blood Cell",
            type: "Erythrocyte",
            accent: "#b03a3a",
            accentSoft: "#f7dcdc",
            color: "#d96565",
            modelKind: "redBlood",
            defaultOrganelle: "hemoglobin",
            comparison: "whiteBlood",
            occurrence: {
                title: "Bloodstream",
                body: "Red blood cells flow through arteries, veins, and capillaries to deliver oxygen from the lungs to every tissue in the body.",
                motif: "blood"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#f7c0c0", pattern: "redblood-light",
                    image: {
                        url:     asset("/microscopy/redBlood-light.jpg"),
                        caption: "Variant red-cell shapes on a peripheral blood smear (poikilocytes)",
                        source:  "https://commons.wikimedia.org/wiki/File:Poikilocytes_-_Red_blood_cell_types.jpg",
                        credit:  "Ed Uthman / Mikael Häggström / CC BY 4.0"
                    }
                },
                {
                    label: "Wright Stained", tone: "#bd5a8a", pattern: "redblood-stain",
                    image: {
                        url:     asset("/microscopy/redBlood-stained.jpg"),
                        caption: "Giemsa-stained normal adult peripheral blood smear",
                        source:  "https://commons.wikimedia.org/wiki/File:Normal_Adult_Blood_Smear.JPG",
                        credit:  "Keith Chambers / CC BY-SA 3.0"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#909090", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/redBlood-tem.jpg"),
                        caption: "Colorized SEM showing erythrocyte, platelet, and leukocyte",
                        source:  "https://commons.wikimedia.org/wiki/File:Red_White_Blood_cells.jpg",
                        credit:  "NCI-Frederick EM Facility / Public domain"
                    }
                }
            ],
            organelles: [
                {
                    id: "plasmaMembrane",
                    name: "Plasma Membrane",
                    subtitle: "The flexible envelope",
                    color: "#c8505a",
                    attributes: [
                        { label: "Shape", value: "Biconcave disc" },
                        { label: "Diameter", value: "7-8 µm" },
                        { label: "Lifespan", value: "~120 days" }
                    ],
                    note: "The biconcave shape maximises surface area for oxygen exchange and lets the cell deform to squeeze through narrow capillaries.",
                    fact: "Mature red blood cells are the only human cells without a nucleus, mitochondria, ribosomes, ER, or Golgi — they eject everything during maturation."
                },
                {
                    id: "hemoglobin",
                    name: "Hemoglobin",
                    subtitle: "The oxygen carrier",
                    color: "#b8323a",
                    attributes: [
                        { label: "Copies per cell", value: "~250 million" },
                        { label: "Binds", value: "Oxygen + CO₂" },
                        { label: "Pigment", value: "Iron-based heme" }
                    ],
                    note: "Each red blood cell packs hundreds of millions of hemoglobin proteins. The iron at each binding site is what makes oxygenated blood red.",
                    fact: "An adult body makes about 2 million red blood cells every second."
                },
                {
                    id: "cytoskeleton",
                    name: "Spectrin Cytoskeleton",
                    subtitle: "The springy scaffold",
                    color: "#8b465a",
                    attributes: [
                        { label: "Main protein", value: "Spectrin" },
                        { label: "Role", value: "Holds biconcave shape" },
                        { label: "Visibility", value: "EM only" }
                    ],
                    note: "A mesh of spectrin and actin under the membrane keeps the disc shape and lets the cell flex through capillaries without bursting.",
                    fact: "Defective spectrin causes hereditary spherocytosis — the cells become spheres and fragile."
                },
                {
                    id: "surfaceAntigens",
                    name: "Surface Antigens (ABO / Rh)",
                    subtitle: "The blood-type markers",
                    color: "#e8b95a",
                    attributes: [
                        { label: "Proteins", value: "Band 3, Glycophorin A/B" },
                        { label: "Carbohydrates", value: "A, B, or H antigens" },
                        { label: "Rh factor", value: "RhD protein (+ or −)" }
                    ],
                    note: "Sugar and protein decorations on the membrane define your blood type. Type A has the A antigen; Type B has B; Type AB has both; Type O has neither. RhD presence makes you positive. Mismatched transfusions trigger immune destruction of donor cells.",
                    fact: "There are over 600 known blood-group antigens — ABO and Rh are just the two with the strongest transfusion reactions."
                },
                {
                    id: "bpg",
                    name: "2,3-BPG",
                    subtitle: "The oxygen-release switch",
                    color: "#7fc1c4",
                    attributes: [
                        { label: "Full name", value: "2,3-Bisphosphoglycerate" },
                        { label: "Source", value: "Glycolysis side-branch" },
                        { label: "Function", value: "Lowers O₂ affinity" }
                    ],
                    note: "A small molecule produced as a side product of glycolysis. It binds inside hemoglobin and pushes it toward the deoxygenated state — exactly when you want oxygen released at the tissues. Without 2,3-BPG, hemoglobin would never let go of its oxygen.",
                    fact: "People living at high altitude crank out more 2,3-BPG so their hemoglobin offloads oxygen more easily — that's part of altitude acclimatization."
                }
            ]
        },
        {
            id: "sperm",
            name: "Sperm Cell",
            type: "Spermatozoon",
            accent: "#7c5cba",
            accentSoft: "#eae0f7",
            color: "#a98ec8",
            modelKind: "sperm",
            defaultOrganelle: "head",
            comparison: "animal",
            occurrence: {
                title: "Male reproductive tract",
                body: "Sperm cells form in the testes, mature in the epididymis, and swim through fluids to reach and fertilise an egg.",
                motif: "animal"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#cfb3ee", pattern: "sperm-light",
                    image: {
                        url:     asset("/microscopy/sperm-light.png"),
                        caption: "Human sperm cells, automated urinalysis light micrograph",
                        source:  "https://commons.wikimedia.org/wiki/File:Sperms_(urine)_-_Spermler_(idrar)_-_01.png",
                        credit:  "Doruk Salancı / CC BY-SA 3.0"
                    }
                },
                {
                    label: "Stained", tone: "#b87fd6", pattern: "sperm-stain",
                    image: {
                        url:     asset("/microscopy/sperm-stained.jpg"),
                        caption: "Stained human sperm for clinical semen-quality testing",
                        source:  "https://commons.wikimedia.org/wiki/File:Sperm_stained.JPG",
                        credit:  "Bobjgalindo / CC BY-SA 4.0"
                    }
                },
                // No CC-licensed human-sperm TEM in jpg/png on Wikimedia
                // Commons. Falls back to gradient placeholder + "coming
                // soon" toast via the page script's renderMicro.
                { label: "Electron Microscope", tone: "#8d8d94", pattern: "electron" }
            ],
            organelles: [
                {
                    id: "head",
                    name: "Head",
                    subtitle: "The DNA payload",
                    color: "#7a49b0",
                    attributes: [
                        { label: "Length", value: "4-5 µm" },
                        { label: "Contents", value: "Haploid nucleus" },
                        { label: "Shape", value: "Oval, flattened" }
                    ],
                    note: "The head holds tightly-packed DNA in a haploid nucleus — half the chromosomes of a normal body cell, ready to combine with an egg's half.",
                    fact: "Sperm DNA is packaged with protamines, making it ~6x denser than DNA in other cells."
                },
                {
                    id: "acrosome",
                    name: "Acrosome",
                    subtitle: "The enzyme cap",
                    color: "#c9a8ee",
                    attributes: [
                        { label: "Position", value: "Front of head" },
                        { label: "Role", value: "Egg penetration" },
                        { label: "Contents", value: "Hydrolytic enzymes" }
                    ],
                    note: "The acrosome is a cap of enzymes at the front tip of the head. On contact with an egg, it releases enzymes that digest the egg's outer layer.",
                    fact: "Without a working acrosome a sperm cannot fertilise an egg, even if it reaches one."
                },
                {
                    id: "midpiece",
                    name: "Midpiece",
                    subtitle: "The mitochondrial engine",
                    color: "#cf7042",
                    attributes: [
                        { label: "Mitochondria", value: "Helical spiral" },
                        { label: "Role", value: "ATP for swimming" },
                        { label: "Length", value: "~5 µm" }
                    ],
                    note: "A tightly-wound spiral of mitochondria in the midpiece produces all the ATP the flagellum needs to whip and propel the cell forward.",
                    fact: "Sperm mitochondria are tagged for destruction after fertilisation — that's why mitochondrial DNA is inherited only from the mother."
                },
                {
                    id: "flagellum",
                    name: "Flagellum",
                    subtitle: "The propulsion tail",
                    color: "#7d9bcf",
                    attributes: [
                        { label: "Length", value: "~50 µm" },
                        { label: "Structure", value: "9+2 microtubule pair" },
                        { label: "Speed", value: "~5 mm/min" }
                    ],
                    note: "The flagellum beats in a wave-like motion driven by dynein motors walking along microtubule pairs. It's the longest part of the cell by far.",
                    fact: "A sperm flagellum beats roughly 10-20 times per second."
                },
                {
                    id: "nucleus",
                    name: "Nucleus (haploid)",
                    subtitle: "The genetic payload",
                    color: "#5a368e",
                    attributes: [
                        { label: "Ploidy", value: "Haploid (23 chromosomes)" },
                        { label: "Packaging", value: "Protamines, not histones" },
                        { label: "Density", value: "~6x normal chromatin" }
                    ],
                    note: "Sperm replace nearly all their histones with smaller protamines, compressing the DNA into a fraction of the normal volume. This dense, streamlined package is what fits inside the tiny head.",
                    fact: "Disrupted protamine swap during sperm production is one of the leading molecular causes of male infertility."
                },
                {
                    id: "mitochondrion",
                    name: "Mitochondria (helical sheath)",
                    subtitle: "The swimming engine",
                    color: "#f0b074",
                    attributes: [
                        { label: "Arrangement", value: "Tight helical spiral" },
                        { label: "Where", value: "Midpiece only" },
                        { label: "Fate", value: "Destroyed after fertilisation" }
                    ],
                    note: "Sperm cram their mitochondria into a single tightly-wound helix around the midpiece — the most concentrated mitochondrial geometry in any human cell. Every ATP it produces feeds the flagellum.",
                    fact: "When the egg detects a sperm's mitochondria after fertilisation, it tags them with ubiquitin for destruction — which is why mitochondrial DNA is inherited only from the mother."
                },
                {
                    id: "centriole",
                    name: "Proximal Centriole",
                    subtitle: "The inherited microtubule seed",
                    color: "#67b1c4",
                    attributes: [
                        { label: "Position", value: "Head-midpiece junction" },
                        { label: "Role", value: "Builds the flagellum scaffold" },
                        { label: "Inherited", value: "Egg gets this from the sperm" }
                    ],
                    note: "Sperm carry one functional centriole — the egg, surprisingly, has none of its own. After fertilisation, this paternal centriole seeds the first mitotic spindle of the new embryo. Without it the embryo cannot divide.",
                    fact: "Mammalian eggs have lost their centrioles during evolution and rely entirely on the sperm to supply this single organelle."
                },
                {
                    id: "plasmaMembrane",
                    name: "Plasma Membrane",
                    subtitle: "The streamlined envelope",
                    color: "#a98ec8",
                    attributes: [
                        { label: "Coverage", value: "Whole cell" },
                        { label: "Composition", value: "Lipid + receptor proteins" },
                        { label: "Sensors", value: "Detect egg-released chemicals" }
                    ],
                    note: "A thin lipid bilayer wraps the entire sperm — head, midpiece, and flagellum. It's studded with receptors that detect chemical gradients released by the egg, helping the sperm find its way (chemotaxis).",
                    fact: "Capacitation — the chemical transformation that makes a sperm competent to fertilise — happens entirely in this membrane on the swim through the female tract."
                }
            ]
        },
        {
            id: "yeast",
            name: "Yeast Cell",
            type: "Fungal Cell",
            accent: "#c9952f",
            accentSoft: "#f6ead0",
            color: "#dab15c",
            modelKind: "yeast",
            defaultOrganelle: "cellWall",
            comparison: "bacteria",
            occurrence: {
                title: "Bread, beer, gut, soil",
                body: "Yeast cells are single-celled fungi that turn sugars into alcohol and CO₂ by fermentation. They live on plants, in soil, and inside animals.",
                motif: "microbe"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#f0d997", pattern: "yeast-light",
                    image: {
                        url:     asset("/microscopy/yeast-light.jpg"),
                        caption: "Live budding Saccharomyces cerevisiae, ~1500x compound microscope",
                        source:  "https://commons.wikimedia.org/wiki/File:20100911_232323_Yeast_Live.jpg",
                        credit:  "Bob Blaylock / CC BY-SA 3.0"
                    }
                },
                {
                    label: "Stained", tone: "#c98c4a", pattern: "yeast-stain",
                    image: {
                        url:     asset("/microscopy/yeast-stained.jpg"),
                        caption: "S. cerevisiae stained with Loeffler's methylene blue at 400x",
                        source:  "https://commons.wikimedia.org/wiki/File:Saccharomyces_cerevisiae_Loeffler%27s_Methylene_Blue_Staining.jpg",
                        credit:  "Cboerner / CC0"
                    }
                },
                // No suitable whole-cell yeast TEM on Wikimedia under a
                // permissive license. Falls back gracefully via renderMicro.
                { label: "Electron Microscope", tone: "#888888", pattern: "electron" }
            ],
            organelles: [
                {
                    id: "cellWall",
                    name: "Cell Wall",
                    subtitle: "The chitin armour",
                    color: "#d5a849",
                    attributes: [
                        { label: "Material", value: "Chitin + β-glucan" },
                        { label: "Thickness", value: "100-200 nm" },
                        { label: "Function", value: "Shape, protection" }
                    ],
                    note: "Yeast walls are made of chitin and β-glucan polymers — chemically distinct from plant cellulose and bacterial peptidoglycan. They keep the cell round and resist osmotic stress.",
                    fact: "Chitin is the same polymer that forms insect exoskeletons."
                },
                {
                    id: "nucleus",
                    name: "Nucleus",
                    subtitle: "The chromosome vault",
                    color: "#7047a8",
                    attributes: [
                        { label: "Chromosomes", value: "16 (S. cerevisiae)" },
                        { label: "Diameter", value: "~1.5 µm" },
                        { label: "Membrane", value: "Stays intact in mitosis" }
                    ],
                    note: "Unlike most eukaryotes, yeast keeps its nuclear envelope intact during mitosis — the spindle assembles inside the nucleus itself.",
                    fact: "S. cerevisiae was the first eukaryote to have its entire genome sequenced (1996)."
                },
                {
                    id: "vacuole",
                    name: "Vacuole",
                    subtitle: "The storage tank",
                    color: "#62bdd2",
                    attributes: [
                        { label: "Role", value: "Storage + recycling" },
                        { label: "Content", value: "Ions, amino acids, enzymes" },
                        { label: "Equivalent", value: "Animal lysosome" }
                    ],
                    note: "The yeast vacuole is the equivalent of an animal cell's lysosome — it stores nutrients and breaks down worn proteins.",
                    fact: "When yeast starves, autophagy delivers cytoplasm into the vacuole for recycling."
                },
                {
                    id: "bud",
                    name: "Bud",
                    subtitle: "The daughter cell",
                    color: "#e0b76a",
                    attributes: [
                        { label: "Process", value: "Asymmetric mitosis" },
                        { label: "Duration", value: "~90 min" },
                        { label: "Scar visible", value: "Lifetime record" }
                    ],
                    note: "Yeast reproduces by budding: a smaller daughter pouches out from the parent, takes a copy of every organelle, then pinches off.",
                    fact: "A bud scar stays on the parent forever — researchers count scars to measure yeast age."
                },
                {
                    id: "plasmaMembrane",
                    name: "Plasma Membrane",
                    subtitle: "The inner barrier",
                    color: "#b88040",
                    attributes: [
                        { label: "Position", value: "Just inside the cell wall" },
                        { label: "Composition", value: "Lipid bilayer with ergosterol" },
                        { label: "Drug target", value: "Yes — antifungals bind ergosterol" }
                    ],
                    note: "Under the chitin wall sits a lipid bilayer. Yeast (and other fungi) use ergosterol instead of the cholesterol your cells use — which is exactly what antifungal drugs like fluconazole and amphotericin B exploit.",
                    fact: "Polyene antifungals literally punch holes through fungal membranes by binding ergosterol; your cells survive because you use cholesterol, not ergosterol."
                },
                {
                    id: "mitochondrion",
                    name: "Mitochondrion",
                    subtitle: "The fermenting engine",
                    color: "#cf7042",
                    attributes: [
                        { label: "Role", value: "Aerobic respiration when O₂ is present" },
                        { label: "Fallback", value: "Fermentation when O₂ is low" },
                        { label: "Genome", value: "Own circular DNA" }
                    ],
                    note: "Yeast can switch between aerobic respiration (using mitochondria) and anaerobic fermentation (using glycolysis only). When oxygen runs low, fermentation kicks in and CO₂ + ethanol are the side products — bread rises and beer brews.",
                    fact: "Yeast mitochondria were the first ever sequenced eukaryotic mitochondrial genome (1980)."
                },
                {
                    id: "er",
                    name: "Endoplasmic Reticulum",
                    subtitle: "The membrane factory",
                    color: "#d97757",
                    attributes: [
                        { label: "Type", value: "Continuous with nuclear envelope" },
                        { label: "Role", value: "Builds new membrane lipids" },
                        { label: "Notable in", value: "Wall-remodelling buds" }
                    ],
                    note: "The yeast ER builds new lipids and folds proteins. During budding, ER expands dramatically to keep up with the doubled membrane demand.",
                    fact: "Yeast mutants where the ER fails are a major workhorse for understanding human ER stress diseases."
                },
                {
                    id: "ribosomes",
                    name: "Ribosomes",
                    subtitle: "The protein builders",
                    color: "#a05f9f",
                    attributes: [
                        { label: "Type", value: "80S eukaryotic" },
                        { label: "Free or bound", value: "Both" },
                        { label: "Use in research", value: "First eukaryote sequenced" }
                    ],
                    note: "Yeast ribosomes are eukaryotic 80S — much more similar to your own than to bacterial 70S. That's part of why yeast is the model organism of choice for studying human translation.",
                    fact: "About a quarter of human disease genes have a recognisable yeast counterpart, often studied via mutated yeast ribosomes."
                },
                {
                    id: "budScar",
                    name: "Bud Scar",
                    subtitle: "The lifetime record",
                    color: "#b87438",
                    attributes: [
                        { label: "Composition", value: "Chitin ring" },
                        { label: "Persists", value: "Forever on the mother" },
                        { label: "Count = age", value: "One scar per daughter" }
                    ],
                    note: "When a daughter bud pinches off, the cell wall remodels and leaves a permanent chitin ring on the mother. Every yeast cell wears a record of every daughter it ever produced — like growth rings on a tree.",
                    fact: "By staining bud scars with calcofluor, you can literally count the age of a yeast cell under a fluorescence microscope. Most cells max out at 20-30 scars before dying of replicative senescence."
                }
            ]
        },
        {
            id: "cardiomyocyte",
            name: "Cardiomyocyte",
            type: "Heart Muscle Cell",
            accent: "#c66e7a",
            accentSoft: "#f3dde1",
            color: "#d18494",
            modelKind: "cardiomyocyte",
            defaultOrganelle: "sarcomere",
            comparison: "muscle",
            occurrence: {
                title: "Heart wall (myocardium)",
                body: "Cardiomyocytes form the muscular layer of the heart, branching and connecting end-to-end so the whole organ contracts as one synchronised pump.",
                motif: "muscle"
            },
            microscope: [
                {
                    label: "Light Microscope", tone: "#f3b9c0", pattern: "cardio-light",
                    image: {
                        url:     asset("/microscopy/cardiomyocyte-light.jpg"),
                        caption: "Cardiac muscle showing intercalated discs and striations",
                        source:  "https://commons.wikimedia.org/wiki/File:1020_Cardiac_Muscle.jpg",
                        credit:  "OpenStax Anatomy & Physiology / CC BY 4.0"
                    }
                },
                {
                    label: "H&E Stained", tone: "#bd5e7c", pattern: "cardio-stain",
                    image: {
                        url:     asset("/microscopy/cardiomyocyte-stained.jpg"),
                        caption: "Cardiac muscle tissue, light microscope at 1600x",
                        source:  "https://commons.wikimedia.org/wiki/File:414c_Cardiacmuscle.jpg",
                        credit:  "OpenStax College / CC BY 3.0"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#8a8a8a", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/cardiomyocyte-tem.jpg"),
                        caption: "Cryo-ET tomographic slice of cardiac sarcomere M-band filaments",
                        source:  "https://commons.wikimedia.org/wiki/File:Cardiac_sarcomere_tomogram.jpg",
                        credit:  "Tamborrini et al. (Raunser lab) / CC BY 4.0"
                    }
                }
            ],
            organelles: [
                {
                    id: "sarcomere",
                    name: "Sarcomere",
                    subtitle: "The contraction unit",
                    color: "#a04d5a",
                    attributes: [
                        { label: "Length (relaxed)", value: "~2.2 µm" },
                        { label: "Length (contracted)", value: "~1.6 µm" },
                        { label: "Bands visible", value: "Z, I, A, H, M" }
                    ],
                    note: "Sarcomeres are the repeating contractile units that give heart and skeletal muscle their striped appearance. Actin and myosin filaments slide past each other to shorten the cell.",
                    fact: "A healthy adult heart contracts about 3 billion times in a lifetime."
                },
                {
                    id: "sarcolemma",
                    name: "Sarcolemma",
                    subtitle: "The excitable membrane",
                    color: "#c66e7a",
                    attributes: [
                        { label: "Specialisation", value: "T-tubules" },
                        { label: "Role", value: "Spread electrical signal" },
                        { label: "Wraps", value: "Each cardiomyocyte" }
                    ],
                    note: "The sarcolemma carries the action potential that triggers contraction. T-tubule invaginations make sure the signal reaches deep into the cell almost instantly.",
                    fact: "Cardiomyocyte sarcolemma is unusually rich in calcium channels — the trigger for contraction."
                },
                {
                    id: "mitochondrion",
                    name: "Mitochondria",
                    subtitle: "The energy mob",
                    color: "#cf7042",
                    attributes: [
                        { label: "Cell volume", value: "~30-35%" },
                        { label: "Role", value: "Continuous ATP supply" },
                        { label: "Density", value: "Highest in body" }
                    ],
                    note: "About a third of a heart cell's interior is mitochondria — the heart never rests, so the ATP supply line can't either.",
                    fact: "Cardiomyocytes have more mitochondria per volume than any other cell type."
                },
                {
                    id: "intercalatedDisc",
                    name: "Intercalated Disc",
                    subtitle: "The cell-to-cell junction",
                    color: "#5e3a4d",
                    attributes: [
                        { label: "Position", value: "End-to-end joins" },
                        { label: "Contains", value: "Gap junctions, desmosomes" },
                        { label: "Function", value: "Electrical + mechanical coupling" }
                    ],
                    note: "Intercalated discs glue cardiomyocytes together physically AND electrically — gap junctions let the action potential jump from cell to cell so the heart fires as one tissue.",
                    fact: "Mutations in disc proteins cause arrhythmogenic cardiomyopathy."
                },
                {
                    id: "nucleus",
                    name: "Nucleus (single, central)",
                    subtitle: "The lone command center",
                    color: "#7a49b0",
                    attributes: [
                        { label: "Count per cell", value: "Usually 1 (rarely 2)" },
                        { label: "Position", value: "Central, between myofibrils" },
                        { label: "Vs skeletal", value: "Skeletal has hundreds" }
                    ],
                    note: "Cardiomyocytes carry a single nucleus parked in the center of the cell — the cleanest visible difference from skeletal muscle (which fuses many myoblasts and ends up multinucleated). Some cardiomyocytes become binucleated in adults.",
                    fact: "Adult human cardiomyocytes barely divide — your heart cells are mostly the same ones you were born with, kept alive for 80+ years."
                },
                {
                    id: "tTubules",
                    name: "T-Tubules",
                    subtitle: "The voltage delivery network",
                    color: "#ead2a7",
                    attributes: [
                        { label: "Cardiac vs skeletal", value: "Wider, more abundant" },
                        { label: "Location", value: "At Z-discs, not A-I junctions" },
                        { label: "Pair with", value: "SR cisterna → dyad" }
                    ],
                    note: "T-tubules are sarcolemma invaginations that carry the action potential deep into the cell. Cardiac T-tubules are bigger and appear at every Z-disc — different from skeletal muscle's narrower tubules at A-I junctions.",
                    fact: "T-tubule loss is a hallmark of heart failure — losing them slows excitation-contraction coupling and weakens each beat."
                },
                {
                    id: "sarcoplasmicReticulum",
                    name: "Sarcoplasmic Reticulum",
                    subtitle: "The calcium store",
                    color: "#b9c7e9",
                    attributes: [
                        { label: "Architecture", value: "Dyad (1 SR + 1 T-tubule)" },
                        { label: "Stores", value: "Ca²⁺ ions" },
                        { label: "Releases via", value: "Ryanodine receptors" }
                    ],
                    note: "When the action potential arrives at a T-tubule, it opens calcium channels that trigger a much bigger Ca²⁺ release from the paired SR — the famous calcium-induced-calcium-release that drives every heartbeat.",
                    fact: "Many anti-arrhythmic drugs work by tweaking the SR's ryanodine receptor — too much leak causes potentially fatal rhythm disturbances."
                },
                {
                    id: "gapJunction",
                    name: "Gap Junctions",
                    subtitle: "The electrical bridge",
                    color: "#e6c46a",
                    attributes: [
                        { label: "Position", value: "Inside intercalated discs" },
                        { label: "Made of", value: "Connexin-43 pores" },
                        { label: "Role", value: "Direct ion + signal passage" }
                    ],
                    note: "Tiny pores embedded in the intercalated disc — they let ions flow directly from one cardiomyocyte to the next, so the action potential spreads through the whole tissue in a fraction of a second. Without them, the heart can't beat in sync.",
                    fact: "Connexin-43 mutations cause oculodentodigital dysplasia and several inherited heart-rhythm disorders."
                },
                {
                    id: "ribosomes",
                    name: "Ribosomes",
                    subtitle: "The protein builders",
                    color: "#a05f9f",
                    attributes: [
                        { label: "Type", value: "80S eukaryotic" },
                        { label: "Output", value: "Actin, myosin, titin" },
                        { label: "Replacement rate", value: "Days for sarcomere proteins" }
                    ],
                    note: "Sarcomere proteins turn over constantly — ribosomes between the myofibrils rebuild the contractile machinery to keep the heart running through billions of beats.",
                    fact: "After a heart attack, the surviving cardiomyocytes hypertrophy: ribosomes go into overdrive making more sarcomere protein to compensate for the lost tissue."
                }
            ]
        },
        {
            id: "virus",
            name: "Virus",
            type: "Infectious Particle",
            accent: "#b85a9c",
            accentSoft: "#f1dcea",
            color: "#cf80b9",
            modelKind: "virus",
            defaultOrganelle: "capsid",
            comparison: "bacteria",
            occurrence: {
                title: "Inside host cells",
                body: "Viruses are not technically cells — they have no metabolism of their own. They drift between hosts and hijack living cells to replicate.",
                motif: "microbe"
            },
            microscope: [
                {
                    label: "Fluorescence", tone: "#e4b3d2", pattern: "virus-light",
                    image: {
                        url:     asset("/microscopy/virus-light.jpg"),
                        caption: "Cells infected with rabies virus, fluorescence microscopy",
                        source:  "https://commons.wikimedia.org/wiki/File:Rabies_in_cells.jpg",
                        credit:  "Lerabird09 / CC BY 4.0"
                    }
                },
                {
                    label: "Labelled", tone: "#a455a0", pattern: "virus-stain",
                    image: {
                        url:     asset("/microscopy/virus-stained.jpg"),
                        caption: "HeLa cells with adenovirus, SEM (light micrograph inset)",
                        source:  "https://commons.wikimedia.org/wiki/File:Hela_cells_with_adenovirus.jpg",
                        credit:  "NIH / Public domain"
                    }
                },
                {
                    label: "Electron Microscope", tone: "#8b8b8b", pattern: "electron",
                    image: {
                        url:     asset("/microscopy/virus-tem.jpg"),
                        caption: "T4 bacteriophage virion, transmission electron micrograph",
                        source:  "https://commons.wikimedia.org/wiki/File:T4_phage_EM.jpg",
                        credit:  "7USSR7 / CC BY 4.0"
                    }
                }
            ],
            organelles: [
                {
                    id: "capsid",
                    name: "Capsid",
                    subtitle: "The protein shell",
                    color: "#b85a9c",
                    attributes: [
                        { label: "Symmetry", value: "Icosahedral (commonly)" },
                        { label: "Subunits", value: "Identical proteins (capsomers)" },
                        { label: "Function", value: "Protects genome" }
                    ],
                    note: "The capsid is a precise crystalline arrangement of identical protein subunits — often a 20-faced icosahedron — that shields the genome between hosts.",
                    fact: "An icosahedron uses the minimum number of identical proteins to enclose a volume — natural selection found this trick billions of years before geometers proved it."
                },
                {
                    id: "spike",
                    name: "Spike Proteins",
                    subtitle: "The host-cell key",
                    color: "#e07ec0",
                    attributes: [
                        { label: "Role", value: "Bind host receptor" },
                        { label: "Present in", value: "Enveloped viruses" },
                        { label: "Example", value: "SARS-CoV-2 spike (S)" }
                    ],
                    note: "Spike proteins poke out from the viral surface and lock onto specific receptors on host cells — that recognition is what determines which cells (and species) a virus can infect.",
                    fact: "COVID-19 mRNA vaccines train the immune system to recognise the SARS-CoV-2 spike protein."
                },
                {
                    id: "genome",
                    name: "Genome",
                    subtitle: "The hijack instructions",
                    color: "#7a43ad",
                    attributes: [
                        { label: "Material", value: "DNA or RNA" },
                        { label: "Strand", value: "Single or double" },
                        { label: "Size", value: "1 kb to ~1 Mb" }
                    ],
                    note: "Viral genomes are tiny — often only a handful of genes. They code just enough to commandeer a host cell's machinery and make more virus.",
                    fact: "The smallest known viral genomes encode as few as 2 proteins."
                },
                {
                    id: "envelope",
                    name: "Envelope",
                    subtitle: "The stolen membrane",
                    color: "#e0b3d5",
                    attributes: [
                        { label: "Origin", value: "Stolen from host cell" },
                        { label: "Composition", value: "Lipid bilayer + viral glycoproteins" },
                        { label: "Found in", value: "Flu, HIV, SARS-CoV-2, herpes" }
                    ],
                    note: "Some viruses wrap themselves in a stolen piece of host-cell membrane as they exit. The envelope makes them more fragile to soap and alcohol — exactly what hand sanitizer does to coronavirus.",
                    fact: "Naked viruses (no envelope) are tougher and often spread by fecal-oral route; enveloped viruses spread mostly through droplets and direct contact."
                },
                {
                    id: "matrix",
                    name: "Matrix Protein",
                    subtitle: "The structural glue",
                    color: "#9a4d8c",
                    attributes: [
                        { label: "Position", value: "Between envelope and capsid" },
                        { label: "Role", value: "Structural scaffold" },
                        { label: "Anchors", value: "Spikes to capsid" }
                    ],
                    note: "In enveloped viruses, a layer of matrix protein sits between the lipid envelope and the inner capsid. It anchors the spike proteins from underneath and holds the whole particle together during assembly and budding.",
                    fact: "HIV's matrix protein (Gag-MA) is what tells the virus where to bud out of the infected cell — drug-targeting this is one anti-HIV strategy."
                }
            ]
        }
    ];

    function getCellById(id) {
        for (var i = 0; i < cells.length; i++) {
            if (cells[i].id === id) return cells[i];
        }
        return cells[0];
    }

    window.BIOLOGY_CELLS = cells;
    window.BIOLOGY_getCellById = getCellById;
})();

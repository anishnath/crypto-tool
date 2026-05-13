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
                    attributes: [
                        { label: "Shape", value: "Branched" },
                        { label: "Role", value: "Input" },
                        { label: "Surface", value: "Often spiny" }
                    ],
                    note: "Dendrites increase the surface area available for receiving signals from other cells.",
                    fact: "A single neuron can receive thousands of synaptic inputs."
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
                    attributes: [
                        { label: "Role", value: "Movement" },
                        { label: "Shape", value: "Helical filament" },
                        { label: "Visible in LM", value: "Special stain" }
                    ],
                    note: "Some bacteria rotate flagella like tiny motors to move through liquid environments.",
                    fact: "Bacterial flagella are powered by ion gradients."
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
                    attributes: [
                        { label: "Shape", value: "Flattened stacks" },
                        { label: "Role", value: "Modify and sort" },
                        { label: "Position", value: "Near nucleus" }
                    ],
                    note: "The Golgi apparatus modifies, sorts, and ships proteins and lipids to their destinations.",
                    fact: "Secretory cells often have a prominent Golgi apparatus."
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
                    id: "mitochondria",
                    name: "Mitochondria",
                    subtitle: "The endurance supply",
                    color: "#cf7042",
                    attributes: [
                        { label: "Role", value: "Energy supply" },
                        { label: "Position", value: "Between fibers" },
                        { label: "Density", value: "Activity dependent" }
                    ],
                    note: "Muscle cells need many mitochondria because contraction consumes large amounts of ATP.",
                    fact: "Endurance training can increase mitochondrial density."
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
                    id: "membrane",
                    name: "Plasma Membrane",
                    subtitle: "The flexible envelope",
                    color: "#c8505a",
                    attributes: [
                        { label: "Shape", value: "Biconcave disc" },
                        { label: "Diameter", value: "7-8 µm" },
                        { label: "Lifespan", value: "~120 days" }
                    ],
                    note: "The biconcave shape maximises surface area for oxygen exchange and lets the cell deform to squeeze through narrow capillaries.",
                    fact: "Mature red blood cells are the only human cells without a nucleus."
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

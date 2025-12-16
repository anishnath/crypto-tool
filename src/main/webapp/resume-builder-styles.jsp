<%-- Resume Builder Styles - Included by resume-builder.jsp --%>
<style>
    :root {
        --theme-primary: #4f46e5;
        --theme-gradient: linear-gradient(135deg, #4f46e5 0%, #818cf8 100%);
        --theme-light: #eef2ff;
    }

    .tool-card { border: none; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, .1); }
    .card-header-custom { background: var(--theme-gradient); color: white; font-weight: 600; }

    .form-section {
        background-color: var(--theme-light);
        padding: 0.75rem;
        border-radius: .5rem;
        margin-bottom: 0.5rem;
        border-left: 4px solid var(--theme-primary);
        transition: all 0.2s;
    }

    .form-section.dragging { opacity: 0.5; transform: scale(0.98); }
    .form-section.drag-over { border: 2px dashed var(--theme-primary); background: #ddd5ff; }

    .form-section-title {
        color: var(--theme-primary);
        font-weight: 700;
        margin-bottom: 0.4rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 0.9rem;
        cursor: pointer;
    }

    .drag-handle { cursor: grab; color: #9ca3af; margin-right: 0.5rem; }
    .drag-handle:active { cursor: grabbing; }

    .form-section.collapsed .section-body { display: none; }
    .form-section.collapsed .toggle-icon { transform: rotate(-90deg); }
    .toggle-icon { transition: transform 0.2s; }

    .sticky-preview { position: sticky; top: 80px; }
    .eeat-badge { background: var(--theme-gradient); color: white; padding: .35rem .75rem; border-radius: 20px; font-size: .75rem; }

    /* Template Gallery */
    .template-gallery { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 0.75rem; }
    .template-card {
        border: 2px solid #e5e7eb;
        border-radius: 8px;
        padding: 0.5rem;
        cursor: pointer;
        transition: all 0.2s;
        text-align: center;
    }
    .template-card:hover { border-color: var(--theme-primary); transform: translateY(-2px); }
    .template-card.active { border-color: var(--theme-primary); background: var(--theme-light); }
    .template-card img { width: 100%; height: 120px; object-fit: cover; border-radius: 4px; background: #f3f4f6; }
    .template-card .name { font-size: 0.75rem; font-weight: 600; margin-top: 0.4rem; }
    .template-card .type { font-size: 0.65rem; color: #6b7280; }

    /* Category Pills */
    .category-pills { display: flex; flex-wrap: wrap; gap: 0.4rem; margin-bottom: 1rem; }
    .category-pill {
        padding: 0.3rem 0.75rem;
        border-radius: 20px;
        font-size: 0.75rem;
        border: 1px solid #e5e7eb;
        cursor: pointer;
        transition: all 0.2s;
        background: white;
    }
    .category-pill:hover { border-color: var(--theme-primary); }
    .category-pill.active { background: var(--theme-primary); color: white; border-color: var(--theme-primary); }

    /* Industry Examples */
    .industry-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(120px, 1fr)); gap: 0.5rem; }
    .industry-card {
        padding: 0.75rem;
        border: 1px solid #e5e7eb;
        border-radius: 8px;
        text-align: center;
        cursor: pointer;
        transition: all 0.2s;
    }
    .industry-card:hover { border-color: var(--theme-primary); background: var(--theme-light); }
    .industry-card i { font-size: 1.5rem; color: var(--theme-primary); margin-bottom: 0.3rem; }
    .industry-card .name { font-size: 0.75rem; font-weight: 500; }

    /* Famous People Cards */
    .famous-card {
        padding: 0.75rem;
        border: 2px solid #fbbf24;
        border-radius: 8px;
        text-align: center;
        cursor: pointer;
        transition: all 0.2s;
        background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
    }
    .famous-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(251, 191, 36, 0.3); }
    .famous-card i { font-size: 1.5rem; color: #b45309; margin-bottom: 0.3rem; }
    .famous-card .name { font-size: 0.75rem; font-weight: 600; color: #92400e; }
    .famous-card .title { font-size: 0.6rem; color: #a16207; }

    /* Preview Container */
    .preview-container {
        background: #f1f5f9;
        border-radius: 8px;
        padding: 1rem;
        max-height: 80vh;
        overflow-y: auto;
        overflow-x: hidden;
    }

    .resume-preview, .resume-page {
        width: 595px;
        max-width: 595px;
        background: white;
        padding: 1.5rem;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        font-family: var(--resume-font, 'Inter', sans-serif);
        color: #1f2937;
        --accent-color: #4f46e5;
        min-height: 842px;
        margin: 0 auto 1rem auto;
    }

    .resume-page {
        margin-top: 1rem;
        position: relative;
    }

    .page-number {
        position: absolute;
        bottom: 15px;
        width: 100%;
        text-align: center;
        font-size: 0.6rem;
        color: #9ca3af;
    }

    .page-divider {
        width: 595px;
        max-width: 100%;
        text-align: center;
        font-size: 0.85rem;
        color: #94a3b8;
        padding: 10px 0;
        margin: 0 auto;
    }
    .page-divider::before {
        content: '--- Page ';
    }
    .page-divider::after {
        content: ' ---';
    }

    /* Entry Cards */
    .entry-card {
        background: white;
        border: 1px solid #e5e7eb;
        border-radius: 6px;
        padding: 0.5rem;
        margin-bottom: 0.3rem;
        position: relative;
    }
    .entry-card .remove-btn {
        position: absolute;
        top: 0.3rem;
        right: 0.3rem;
        color: #ef4444;
        background: none;
        border: none;
        cursor: pointer;
        font-size: 0.75rem;
    }
    .add-entry-btn {
        border: 2px dashed #cbd5e1;
        background: transparent;
        color: #64748b;
        width: 100%;
        padding: 0.35rem;
        border-radius: 6px;
        cursor: pointer;
        font-size: 0.8rem;
    }
    .add-entry-btn:hover { border-color: var(--theme-primary); color: var(--theme-primary); }

    /* Main Tabs */
    .main-tabs .nav-link { font-weight: 600; color: #6b7280; border: none; padding: 0.4rem 0.75rem; font-size: 0.9rem; }
    .main-tabs .nav-link.active { color: var(--theme-primary); border-bottom: 3px solid var(--theme-primary); background: transparent; }

    /* Resume Base Styles */
    .resume-header { margin-bottom: 1rem; padding-bottom: 0.6rem; border-bottom: 2px solid var(--accent-color); }
    .resume-name { font-size: 1.4rem; font-weight: 800; color: #111827; }
    .resume-title { font-size: 0.85rem; color: var(--accent-color); font-weight: 500; }
    .resume-contact { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 0.4rem; font-size: 0.65rem; color: #6b7280; }
    .resume-contact-item { display: flex; align-items: center; gap: 0.2rem; }
    .resume-section { margin-bottom: 0.8rem; }
    .resume-section-title { font-size: 0.8rem; font-weight: 700; color: #111827; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 1px solid #e5e7eb; padding-bottom: 0.25rem; margin-bottom: 0.4rem; }
    .resume-item { margin-bottom: 0.5rem; }
    .resume-item-header { display: flex; justify-content: space-between; align-items: baseline; }
    .resume-item-title { font-weight: 600; font-size: 0.75rem; }
    .resume-item-date { font-size: 0.65rem; color: #6b7280; }
    .resume-item-subtitle { font-size: 0.7rem; color: #4b5563; }
    .resume-item-desc { font-size: 0.65rem; color: #374151; line-height: 1.4; }
    .resume-skills { display: flex; flex-wrap: wrap; gap: 0.25rem; }
    .resume-skill-tag { background: #eff6ff; color: var(--accent-color); padding: 0.1rem 0.4rem; border-radius: 999px; font-size: 0.6rem; font-weight: 500; }
    .resume-langs { font-size: 0.65rem; }

    /* Skill Bars */
    .skill-bar-container { margin-bottom: 0.4rem; }
    .skill-bar-label { font-size: 0.65rem; display: flex; justify-content: space-between; margin-bottom: 0.15rem; }
    .skill-bar { height: 6px; background: #e5e7eb; border-radius: 3px; overflow: hidden; }
    .skill-bar-fill { height: 100%; background: var(--accent-color); border-radius: 3px; }

    /* ===== TEMPLATE STYLES ===== */

    /* Functional Template */
    .template-functional .resume-header { text-align: center; border-bottom: none; padding-bottom: 0; margin-bottom: 0.5rem; }
    .template-functional .resume-contact { justify-content: center; }
    .template-functional #previewSkillsSection { order: -2; }
    .template-functional #previewSummarySection { order: -1; }
    .template-functional .resume-section-title { background: var(--accent-color); color: white; padding: 0.3rem 0.6rem; border-bottom: none; border-radius: 4px; }

    /* Combination Template */
    .template-combination #resumeSectionsContainer { display: grid !important; grid-template-columns: 1fr 1fr; gap: 0.8rem; }
    .template-combination .resume-header { border-bottom: 3px solid var(--accent-color); }
    .template-combination #previewSummarySection { grid-column: 1 / -1; }
    .template-combination #previewSkillsSection { grid-column: 1; grid-row: 2; }
    .template-combination #previewCertSection { grid-column: 1; grid-row: 3; }
    .template-combination #previewLangSection { grid-column: 1; grid-row: 4; }
    .template-combination #previewExpSection { grid-column: 2; grid-row: 2 / span 2; }
    .template-combination #previewEduSection { grid-column: 2; grid-row: 4; }
    .template-combination #previewProjectSection { grid-column: 1 / -1; }
    .template-combination #previewCustomSections { grid-column: 1 / -1; }

    /* Modern Template */
    .template-modern .resume-header { background: linear-gradient(135deg, var(--accent-color) 0%, #818cf8 100%); color: white; margin: -1.5rem -1.5rem 1rem -1.5rem; padding: 1.25rem 1.5rem; border-bottom: none; }
    .template-modern .resume-name { color: white; }
    .template-modern .resume-title { color: rgba(255,255,255,0.9); }
    .template-modern .resume-contact { color: rgba(255,255,255,0.8); }
    .template-modern .resume-section-title { color: var(--accent-color); border-bottom: 2px solid var(--accent-color); }

    /* Professional Template */
    .template-professional .resume-header { border-bottom: 4px double #333; padding-bottom: 0.75rem; }
    .template-professional .resume-name { font-family: Georgia, serif; letter-spacing: 1px; }
    .template-professional .resume-section-title { font-family: Georgia, serif; border-bottom: 1px solid #999; }

    /* Simple Template */
    .template-simple .resume-header { border-bottom: 1px solid #ddd; }
    .template-simple .resume-name { font-weight: 600; font-size: 1.3rem; }
    .template-simple .resume-section-title { font-size: 0.75rem; border-bottom: none; color: #666; margin-bottom: 0.3rem; }
    .template-simple .resume-skill-tag { background: transparent; border: 1px solid #ddd; color: #333; }

    /* Executive Template */
    .template-executive .resume-header { text-align: center; border-top: 2px solid #333; border-bottom: 2px solid #333; padding: 0.75rem 0; margin-bottom: 1rem; }
    .template-executive .resume-name { font-family: Georgia, serif; font-size: 1.5rem; text-transform: uppercase; letter-spacing: 2px; }
    .template-executive .resume-contact { justify-content: center; }
    .template-executive .resume-section-title { text-align: center; border-bottom: 1px solid #999; }

    /* Two-Column Template */
    .template-twocolumn .resume-header { background: var(--accent-color); color: white; margin: -1.5rem -1.5rem 0 -1.5rem; padding: 1rem 1.5rem; border-bottom: none; }
    .template-twocolumn .resume-name { color: white; }
    .template-twocolumn .resume-title { color: rgba(255,255,255,0.9); }
    .template-twocolumn .resume-contact { color: rgba(255,255,255,0.85); }
    .template-twocolumn #resumeSectionsContainer { display: grid !important; grid-template-columns: 35% 1fr; gap: 0; }
    .template-twocolumn #previewSkillsSection { grid-column: 1; background: #f8f9fa; padding: 0.6rem; margin-left: -1.5rem; padding-left: 1.5rem; }
    .template-twocolumn #previewLangSection { grid-column: 1; background: #f8f9fa; padding: 0.6rem; margin-left: -1.5rem; padding-left: 1.5rem; }
    .template-twocolumn #previewCertSection { grid-column: 1; background: #f8f9fa; padding: 0.6rem; margin-left: -1.5rem; padding-left: 1.5rem; }
    .template-twocolumn #previewSummarySection { grid-column: 2; padding: 0.6rem; grid-row: 1; }
    .template-twocolumn #previewExpSection { grid-column: 2; padding: 0.6rem; }
    .template-twocolumn #previewEduSection { grid-column: 2; padding: 0.6rem; }
    .template-twocolumn #previewProjectSection { grid-column: 2; padding: 0.6rem; }
    .template-twocolumn #previewCustomSections { grid-column: 1 / -1; padding: 0.6rem; }

    /* Creative Template */
    .template-creative .resume-header { background: #1f2937; color: white; margin: -1.5rem -1.5rem 1rem -1.5rem; padding: 1.5rem; text-align: center; border-bottom: 5px solid var(--accent-color); }
    .template-creative .resume-name { color: white; font-size: 1.6rem; letter-spacing: 1px; }
    .template-creative .resume-title { color: var(--accent-color); text-transform: uppercase; letter-spacing: 2px; }
    .template-creative .resume-contact { color: #d1d5db; justify-content: center; }
    .template-creative .resume-section-title { border-left: 4px solid var(--accent-color); padding-left: 0.6rem; border-bottom: none; }
    .template-creative .resume-skill-tag { background: #1f2937; color: white; }

    /* Minimal Template */
    .template-minimal .resume-header { text-align: center; border-bottom: 1px solid #333; padding-bottom: 0.75rem; }
    .template-minimal .resume-name { font-family: Georgia, serif; letter-spacing: 2px; }
    .template-minimal .resume-title { font-style: italic; color: #666; }
    .template-minimal .resume-contact { justify-content: center; }
    .template-minimal .resume-section-title { text-align: center; font-weight: normal; letter-spacing: 1px; border-bottom: none; color: var(--accent-color); }
    .template-minimal .resume-skill-tag { background: transparent; border: 1px solid #999; border-radius: 0; }

    /* Compact form */
    .form-control-xs { padding: 0.2rem 0.4rem; font-size: 0.75rem; height: auto; }

    /* Cover Letter */
    .cover-letter-preview {
        width: 100%;
        max-width: 595px;
        background: white;
        padding: 2rem;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        font-size: 0.85rem;
        line-height: 1.6;
        min-height: 700px;
    }

    /* Job Match */
    .match-keyword { background: #dcfce7; color: #166534; padding: 0.1rem 0.4rem; border-radius: 4px; font-size: 0.7rem; display: inline-block; margin: 0.1rem; }
    .missing-keyword { background: #fee2e2; color: #991b1b; padding: 0.1rem 0.4rem; border-radius: 4px; font-size: 0.7rem; display: inline-block; margin: 0.1rem; }
    .match-score { font-size: 2rem; font-weight: 800; }
    .match-score.good { color: #16a34a; }
    .match-score.medium { color: #ca8a04; }
    .match-score.low { color: #dc2626; }

    /* Saved Resumes */
    .saved-item { display: flex; justify-content: space-between; align-items: center; padding: 0.4rem; background: white; border: 1px solid #e5e7eb; border-radius: 4px; margin-bottom: 0.3rem; font-size: 0.8rem; }

    /* Color Theme Presets */
    .color-presets { display: flex; gap: 0.4rem; flex-wrap: wrap; margin-top: 0.5rem; }
    .color-preset {
        width: 24px; height: 24px; border-radius: 50%; cursor: pointer;
        border: 2px solid transparent; transition: all 0.2s;
    }
    .color-preset:hover { transform: scale(1.15); }
    .color-preset.active { border-color: #333; box-shadow: 0 0 0 2px white, 0 0 0 4px currentColor; }

    /* Photo Upload */
    .photo-upload-container { text-align: center; margin-bottom: 0.5rem; }
    .photo-preview {
        width: 80px; height: 80px; border-radius: 50%; margin: 0 auto 0.5rem;
        background: #e5e7eb; display: flex; align-items: center; justify-content: center;
        overflow: hidden; border: 3px solid var(--theme-primary);
    }
    .photo-preview img { width: 100%; height: 100%; object-fit: cover; }
    .photo-preview i { font-size: 2rem; color: #9ca3af; }
    .resume-photo {
        width: 70px; height: 70px; border-radius: 50%; object-fit: cover;
        border: 2px solid var(--accent-color); float: right; margin-left: 1rem;
    }

    /* Custom Section */
    .custom-section-card {
        background: white; border: 1px solid #e5e7eb; border-radius: 6px;
        padding: 0.5rem; margin-bottom: 0.3rem; position: relative;
    }
    .custom-section-card .remove-btn {
        position: absolute; top: 0.3rem; right: 0.3rem; color: #ef4444;
        background: none; border: none; cursor: pointer; font-size: 0.75rem;
    }

    /* Draggable sections container */
    #draggableSections { min-height: 100px; }

    /* Section ordering */
    #resumeSectionsContainer { display: flex; flex-direction: column; }
    #resumeSectionsContainer > .resume-section { order: 0; }
    .section-hidden { display: none !important; }
    .opacity-50 { opacity: 0.5; }

    /* PDF Export Styles - scale up fonts for print */
    .pdf-export {
        transform: none !important;
        box-shadow: none !important;
        width: 100% !important;
        max-width: none !important;
        padding: 40px !important;
    }
    .pdf-export .resume-name { font-size: 28px !important; }
    .pdf-export .resume-title { font-size: 16px !important; }
    .pdf-export .resume-contact { font-size: 12px !important; gap: 12px !important; }
    .pdf-export .resume-section { margin-bottom: 16px !important; }
    .pdf-export .resume-section-title { font-size: 14px !important; margin-bottom: 8px !important; }
    .pdf-export .resume-item { margin-bottom: 12px !important; }
    .pdf-export .resume-item-title { font-size: 13px !important; }
    .pdf-export .resume-item-date { font-size: 12px !important; }
    .pdf-export .resume-item-subtitle { font-size: 12px !important; }
    .pdf-export .resume-item-desc { font-size: 11px !important; line-height: 1.5 !important; }
    .pdf-export .resume-skill-tag { font-size: 11px !important; padding: 4px 10px !important; }
    .pdf-export .resume-skills { gap: 6px !important; }
    .pdf-export .resume-langs { font-size: 12px !important; }
    .pdf-export .resume-photo { width: 100px !important; height: 100px !important; }
</style>

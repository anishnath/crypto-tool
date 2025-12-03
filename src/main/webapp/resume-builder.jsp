<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <title>Free Online Resume Builder - 50+ Professional Templates | Create CV in Minutes | 8gwifi.org</title>
        <meta name="description"
            content="Build your professional resume online for free with 50+ templates. Choose from Chronological, Functional, Modern, Executive, and Creative styles. Features famous people resume examples (Elon Musk, Steve Jobs, Bill Gates), real-time preview, PDF & Word export. No signup required!">
        <meta name="keywords"
            content="resume builder, free resume maker, CV builder, resume templates, professional resume, chronological resume, functional resume, modern resume, executive resume, creative resume, PDF resume, Word resume, career resume, job application, resume examples, Elon Musk resume, Steve Jobs resume, resume generator, online resume creator, ATS friendly resume">
        <meta name="robots" content="index, follow">
        <meta property="og:title" content="Free Online Resume Builder - 50+ Professional Templates">
        <meta property="og:description" content="Create a stunning professional resume in minutes with our free online resume builder. 50+ templates, real-time preview, PDF export. No signup required!">
        <meta property="og:type" content="website">
        <meta property="og:url" content="https://8gwifi.org/resume-builder.jsp">
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="Free Online Resume Builder - Create Professional CV">
        <meta name="twitter:description" content="Build your resume with 50+ templates. Includes famous people examples like Elon Musk & Steve Jobs. Free PDF export!">
        <link rel="canonical" href="https://8gwifi.org/resume-builder.jsp">
        <%@ include file="header-script.jsp" %>
            <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Free Online Resume Builder",
      "url": "https://8gwifi.org/resume-builder.jsp",
      "description": "Create professional resumes online for free with 50+ templates including Chronological, Functional, Modern, Executive, and Creative styles. Features real-time preview, famous people resume examples, and PDF/Word export.",
      "applicationCategory": "BusinessApplication",
      "operatingSystem": "Any",
      "browserRequirements": "Requires JavaScript",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" },
      "featureList": ["50+ Resume Templates", "Real-time Preview", "PDF Export", "Word Export", "Famous People Examples", "Industry-specific Templates", "Custom Sections", "Photo Upload", "Color Themes"],
      "screenshot": "https://8gwifi.org/images/resume-builder-screenshot.png"
    }
    </script>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Create a Professional Resume",
      "description": "Step-by-step guide to building your resume with our free online tool",
      "step": [
        {"@type": "HowToStep", "name": "Choose Template", "text": "Select from 50+ professional templates including Chronological, Functional, Modern, and Executive styles"},
        {"@type": "HowToStep", "name": "Fill Details", "text": "Enter your personal information, experience, education, and skills"},
        {"@type": "HowToStep", "name": "Customize Design", "text": "Choose colors, fonts, and arrange sections to match your style"},
        {"@type": "HowToStep", "name": "Preview & Export", "text": "Review your resume in real-time and download as PDF or Word document"}
      ]
    }
    </script>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {"@type": "Question", "name": "Is this resume builder really free?", "acceptedAnswer": {"@type": "Answer", "text": "Yes, our resume builder is completely free with no hidden charges. Create unlimited resumes and export to PDF or Word format."}},
        {"@type": "Question", "name": "Do I need to create an account?", "acceptedAnswer": {"@type": "Answer", "text": "No signup required! Start building your resume immediately. Your data stays in your browser for privacy."}},
        {"@type": "Question", "name": "What resume templates are available?", "acceptedAnswer": {"@type": "Answer", "text": "We offer 50+ templates including Chronological, Functional, Combination, Modern, Professional, Executive, Creative, Minimal, and Two-Column layouts."}},
        {"@type": "Question", "name": "Can I see example resumes?", "acceptedAnswer": {"@type": "Answer", "text": "Yes! We feature resume examples from famous people like Elon Musk, Steve Jobs, Bill Gates, and industry-specific examples for Software Engineers, Teachers, Nurses, and more."}}
      ]
    }
    </script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
            <%@ include file="resume-builder-styles.jsp" %>
    </head>
    <%@ include file="body-script.jsp" %>

            <div class="container-fluid px-lg-4 mt-3">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <div>
                        <h1 class="h4 mb-0">Resume Builder</h1>
                        <p class="text-muted mb-0 small">50+ Templates for Every Profession</p>
                    </div>
                    <div class="eeat-badge"><i class="fas fa-user-check mr-1"></i>Anish Nath</div>
                </div>

                <!-- Main Tabs -->
                <ul class="nav main-tabs mb-2" role="tablist">
                    <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#resumePanel"><i class="fas fa-file-alt mr-1"></i>Resume</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#templatesPanel"><i class="fas fa-th-large mr-1"></i>Templates</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#examplesPanel"><i class="fas fa-briefcase mr-1"></i>Examples</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#coverPanel"><i class="fas fa-envelope mr-1"></i>Cover Letter</a></li>
                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#matchPanel"><i class="fas fa-search mr-1"></i>Job Match</a></li>
                </ul>

                <div class="tab-content">
                    <!-- RESUME TAB -->
                    <div class="tab-pane fade show active" id="resumePanel">
                        <div class="row">
                            <div class="col-lg-5">
                                <div class="card tool-card mb-2">
                                    <div class="card-header card-header-custom d-flex justify-content-between align-items-center py-2">
                                        <span><i class="fas fa-edit mr-1"></i>Editor</span>
                                        <div>
                                            <button class="btn btn-light btn-sm mr-1" onclick="showSaveModal()" title="Save"><i class="fas fa-save"></i></button>
                                            <button class="btn btn-warning btn-sm" onclick="downloadPDF()"><i class="fas fa-file-pdf"></i> PDF</button>
                                        </div>
                                    </div>
                                    <div class="card-body py-2" style="max-height: 100vh; overflow-y: auto;">

                                        <!-- Quick Template Select -->
                                        <div class="form-section">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-palette mr-1"></i>Template & Design</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <select class="form-control form-control-xs mb-2" id="templateSelect" onchange="setTemplate(this.value)">
                                                    <optgroup label="Resume Types">
                                                        <option value="chronological">Chronological (Default)</option>
                                                        <option value="functional">Functional (Skills-Based)</option>
                                                        <option value="combination">Combination / Hybrid</option>
                                                    </optgroup>
                                                    <optgroup label="Design Styles">
                                                        <option value="modern">Modern</option>
                                                        <option value="professional">Professional / Traditional</option>
                                                        <option value="simple">Simple / Basic</option>
                                                        <option value="executive">Executive</option>
                                                        <option value="creative">Creative / Bold</option>
                                                        <option value="minimal">Minimal</option>
                                                        <option value="twocolumn">Two-Column</option>
                                                    </optgroup>
                                                </select>
                                                <div class="row mb-2">
                                                    <div class="col-6"><input type="color" class="form-control form-control-sm" id="colorPicker" value="#4f46e5" onchange="updateTheme()"></div>
                                                    <div class="col-6">
                                                        <select class="form-control form-control-xs" id="fontPicker" onchange="updateTheme()">
                                                            <option value="Inter, sans-serif">Modern</option>
                                                            <option value="Georgia, serif">Classic</option>
                                                            <option value="Arial, sans-serif">Clean</option>
                                                            <option value="Roboto, sans-serif">Roboto</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <label class="small text-muted mb-1">Color Themes:</label>
                                                <div class="color-presets" id="colorPresets"></div>
                                            </div>
                                        </div>

                                        <!-- Photo Upload -->
                                        <div class="form-section collapsed">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-camera mr-1"></i>Photo (Optional)</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <div class="photo-upload-container">
                                                    <div class="photo-preview" id="photoPreviewThumb">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    <input type="file" id="photoInput" accept="image/*" onchange="handlePhotoUpload(event)" style="display:none;">
                                                    <button class="btn btn-outline-primary btn-sm" onclick="document.getElementById('photoInput').click()">
                                                        <i class="fas fa-upload"></i> Upload
                                                    </button>
                                                    <button class="btn btn-outline-danger btn-sm" onclick="removePhoto()" id="removePhotoBtn" style="display:none;">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Personal Info -->
                                        <div class="form-section">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-user mr-1"></i>Personal Info</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <div class="row">
                                                    <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" id="inputName" placeholder="Full Name" oninput="updatePreview()"></div>
                                                    <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" id="inputTitle" placeholder="Job Title" oninput="updatePreview()"></div>
                                                    <div class="col-6 mb-1"><input type="email" class="form-control form-control-xs" id="inputEmail" placeholder="Email" oninput="updatePreview()"></div>
                                                    <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" id="inputPhone" placeholder="Phone" oninput="updatePreview()"></div>
                                                    <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" id="inputLocation" placeholder="Location" oninput="updatePreview()"></div>
                                                    <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" id="inputWebsite" placeholder="LinkedIn/Website" oninput="updatePreview()"></div>
                                                    <div class="col-12"><textarea class="form-control form-control-xs" id="inputSummary" rows="2" placeholder="Professional Summary" oninput="updatePreview()"></textarea></div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Experience -->
                                        <div class="form-section">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-briefcase mr-1"></i>Experience</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <div id="experienceList"></div>
                                                <button type="button" class="add-entry-btn" onclick="addExperience()"><i class="fas fa-plus"></i> Add</button>
                                            </div>
                                        </div>

                                        <!-- Education -->
                                        <div class="form-section">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-graduation-cap mr-1"></i>Education</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <div id="educationList"></div>
                                                <button type="button" class="add-entry-btn" onclick="addEducation()"><i class="fas fa-plus"></i> Add</button>
                                            </div>
                                        </div>

                                        <!-- Skills -->
                                        <div class="form-section">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-tools mr-1"></i>Skills</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <input type="text" class="form-control form-control-xs" id="inputSkills" placeholder="Skill 1, Skill 2, Skill 3..." oninput="updatePreview()">
                                                <div class="custom-control custom-checkbox mt-1">
                                                    <input type="checkbox" class="custom-control-input" id="showSkillBars" onchange="updatePreview()">
                                                    <label class="custom-control-label small" for="showSkillBars">Show skill bars</label>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Projects -->
                                        <div class="form-section collapsed">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-project-diagram mr-1"></i>Projects</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <div id="projectList"></div>
                                                <button type="button" class="add-entry-btn" onclick="addProject()"><i class="fas fa-plus"></i> Add</button>
                                            </div>
                                        </div>

                                        <!-- Certifications -->
                                        <div class="form-section collapsed">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-certificate mr-1"></i>Certifications</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <div id="certList"></div>
                                                <button type="button" class="add-entry-btn" onclick="addCert()"><i class="fas fa-plus"></i> Add</button>
                                            </div>
                                        </div>

                                        <!-- Languages -->
                                        <div class="form-section collapsed">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-language mr-1"></i>Languages</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <div id="langList"></div>
                                                <button type="button" class="add-entry-btn" onclick="addLang()"><i class="fas fa-plus"></i> Add</button>
                                            </div>
                                        </div>

                                        <!-- Custom Sections -->
                                        <div class="form-section collapsed">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-plus-square mr-1"></i>Custom Sections</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <p class="small text-muted mb-2">Create custom sections like Awards, Volunteer Work, Publications, etc.</p>
                                                <div id="customSectionsList"></div>
                                                <button type="button" class="add-entry-btn" onclick="addCustomSection()"><i class="fas fa-plus"></i> Add Custom Section</button>
                                            </div>
                                        </div>

                                        <!-- Section Visibility & Reordering -->
                                        <div class="form-section collapsed">
                                            <div class="form-section-title" onclick="toggleSection(this)">
                                                <span><i class="fas fa-sliders-h mr-1"></i>Show/Hide & Reorder</span>
                                                <i class="fas fa-chevron-down toggle-icon"></i>
                                            </div>
                                            <div class="section-body">
                                                <p class="small text-muted mb-2">Toggle visibility and drag to reorder</p>
                                                <div id="sectionOrderList"></div>
                                                <div class="mt-2">
                                                    <button class="btn btn-outline-secondary btn-sm btn-block" onclick="resetSectionSettings()">
                                                        <i class="fas fa-undo"></i> Reset to Default
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>

                            <!-- Preview Panel -->
                            <div class="col-lg-7">
                                <div class="sticky-preview">
                                    <div class="card tool-card">
                                        <div class="card-header bg-white d-flex justify-content-between align-items-center py-2">
                                            <span class="font-weight-bold small"><i class="fas fa-eye mr-1"></i>Live Preview</span>
                                            <div>
                                                <button class="btn btn-sm btn-outline-primary mr-1" onclick="downloadWord()" title="Download as Word"><i class="fas fa-file-word"></i></button>
                                                <button class="btn btn-sm btn-primary" onclick="downloadPDF()"><i class="fas fa-download"></i> PDF</button>
                                            </div>
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="preview-container" id="previewContainer">
                                                <div id="resumePreview" class="resume-preview">
                                                    <div class="resume-header">
                                                        <img id="previewPhoto" class="resume-photo" style="display:none;" src="" alt="Photo">
                                                        <div class="resume-name" id="previewName">Your Name</div>
                                                        <div class="resume-title" id="previewTitle">Professional Title</div>
                                                        <div class="resume-contact">
                                                            <span class="resume-contact-item" id="previewEmailWrap"><i class="fas fa-envelope"></i> <span id="previewEmail"></span></span>
                                                            <span class="resume-contact-item" id="previewPhoneWrap"><i class="fas fa-phone"></i> <span id="previewPhone"></span></span>
                                                            <span class="resume-contact-item" id="previewLocationWrap"><i class="fas fa-map-marker-alt"></i> <span id="previewLocation"></span></span>
                                                            <span class="resume-contact-item" id="previewWebsiteWrap"><i class="fas fa-link"></i> <span id="previewWebsite"></span></span>
                                                        </div>
                                                    </div>
                                                    <div id="resumeSectionsContainer">
                                                        <div class="resume-section" id="previewSummarySection" data-order="0" style="display:none;"><div class="resume-section-title">Summary</div><div class="resume-item-desc" id="previewSummary"></div></div>
                                                        <div class="resume-section" id="previewExpSection" data-order="1" style="display:none;"><div class="resume-section-title">Experience</div><div id="previewExpList"></div></div>
                                                        <div class="resume-section" id="previewEduSection" data-order="2" style="display:none;"><div class="resume-section-title">Education</div><div id="previewEduList"></div></div>
                                                        <div class="resume-section" id="previewSkillsSection" data-order="3" style="display:none;"><div class="resume-section-title">Skills</div><div id="previewSkills"></div></div>
                                                        <div class="resume-section" id="previewProjectSection" data-order="4" style="display:none;"><div class="resume-section-title">Projects</div><div id="previewProjectList"></div></div>
                                                        <div class="resume-section" id="previewCertSection" data-order="5" style="display:none;"><div class="resume-section-title">Certifications</div><div id="previewCertList"></div></div>
                                                        <div class="resume-section" id="previewLangSection" data-order="6" style="display:none;"><div class="resume-section-title">Languages</div><div class="resume-langs" id="previewLangList"></div></div>
                                                        <div id="previewCustomSections"></div>
                                                    </div>
                                                    <div class="page-number">Page 1</div>
                                                </div>
                                                <!-- Additional pages will be added dynamically -->
                                                <div id="additionalPages"></div>
                                            </div>
                                            <div class="text-center py-1 bg-light border-top">
                                                <small class="text-muted" id="pageInfo">Page 1 of 1</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- TEMPLATES TAB -->
                    <div class="tab-pane fade" id="templatesPanel">
                        <div class="card tool-card">
                            <div class="card-body">
                                <h5 class="mb-3">Choose a Template Style</h5>
                                <div class="category-pills mb-3">
                                    <span class="category-pill active" onclick="filterTemplates('all', this)">All</span>
                                    <span class="category-pill" onclick="filterTemplates('type', this)">Resume Types</span>
                                    <span class="category-pill" onclick="filterTemplates('style', this)">Design Styles</span>
                                </div>
                                <div class="template-gallery" id="templateGallery">
                                    <!-- Populated by JS -->
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- EXAMPLES TAB -->
                    <div class="tab-pane fade" id="examplesPanel">
                        <div class="card tool-card mb-3">
                            <div class="card-body">
                                <h5 class="mb-3"><i class="fas fa-star text-warning mr-2"></i>Famous People Resumes</h5>
                                <p class="text-muted small mb-3">See how world leaders, entrepreneurs, and visionaries would present their careers. Click to load their resume examples.</p>
                                <div class="industry-grid" id="famousPeopleGrid">
                                    <!-- Populated by JS -->
                                </div>
                            </div>
                        </div>
                        <div class="card tool-card">
                            <div class="card-body">
                                <h5 class="mb-3">Industry Resume Examples</h5>
                                <p class="text-muted small mb-3">Click on any profession to load a sample resume with industry-specific content.</p>
                                <div class="industry-grid" id="industryGrid">
                                    <!-- Populated by JS -->
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- COVER LETTER TAB -->
                    <div class="tab-pane fade" id="coverPanel">
                        <div class="row">
                            <div class="col-lg-5">
                                <div class="card tool-card mb-2">
                                    <div class="card-header card-header-custom py-2"><i class="fas fa-envelope mr-1"></i>Cover Letter</div>
                                    <div class="card-body" style="max-height: 65vh; overflow-y: auto;">
                                        <div class="form-section">
                                            <div class="form-section-title"><span><i class="fas fa-building mr-1"></i>Recipient</span></div>
                                            <div class="section-body">
                                                <input type="text" class="form-control form-control-xs mb-1" id="coverManager" placeholder="Hiring Manager Name" oninput="updateCoverLetter()">
                                                <input type="text" class="form-control form-control-xs mb-1" id="coverCompany" placeholder="Company Name" oninput="updateCoverLetter()">
                                                <input type="text" class="form-control form-control-xs" id="coverJob" placeholder="Position" oninput="updateCoverLetter()">
                                            </div>
                                        </div>
                                        <div class="form-section">
                                            <div class="form-section-title"><span><i class="fas fa-pen mr-1"></i>Content</span></div>
                                            <div class="section-body">
                                                <textarea class="form-control form-control-xs mb-1" id="coverOpening" rows="3" placeholder="Opening paragraph..." oninput="updateCoverLetter()"></textarea>
                                                <textarea class="form-control form-control-xs mb-1" id="coverBody" rows="4" placeholder="Body paragraph..." oninput="updateCoverLetter()"></textarea>
                                                <textarea class="form-control form-control-xs" id="coverClosing" rows="2" placeholder="Closing..." oninput="updateCoverLetter()"></textarea>
                                            </div>
                                        </div>
                                        <button class="btn btn-outline-primary btn-sm btn-block" onclick="generateCoverLetter()"><i class="fas fa-magic"></i> Auto-Generate</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-7">
                                <div class="card tool-card">
                                    <div class="card-header bg-white py-2 d-flex justify-content-between">
                                        <span class="font-weight-bold small"><i class="fas fa-eye mr-1"></i>Preview</span>
                                        <button class="btn btn-sm btn-primary" onclick="downloadCoverLetterPDF()"><i class="fas fa-download"></i> PDF</button>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="preview-container">
                                            <div id="coverLetterPreview" class="cover-letter-preview">
                                                <div style="margin-bottom:1.5rem;">
                                                    <div id="clName" style="font-weight:600;"></div>
                                                    <div id="clContact" style="font-size:0.8rem;color:#666;"></div>
                                                </div>
                                                <div id="clDate" style="margin-bottom:1rem;"></div>
                                                <div style="margin-bottom:1.5rem;">
                                                    <div id="clRecipient"></div>
                                                    <div id="clCompany"></div>
                                                </div>
                                                <div id="clGreeting" style="margin-bottom:1rem;">Dear Hiring Manager,</div>
                                                <div><p id="clOpening"></p><p id="clBody"></p><p id="clClosing"></p></div>
                                                <div style="margin-top:1.5rem;">Sincerely,</div>
                                                <div id="clSignature" style="margin-top:1.5rem;font-weight:600;"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- JOB MATCH TAB -->
                    <div class="tab-pane fade" id="matchPanel">
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="card tool-card mb-2">
                                    <div class="card-header card-header-custom py-2"><i class="fas fa-paste mr-1"></i>Job Description</div>
                                    <div class="card-body">
                                        <textarea class="form-control" id="jobDescription" rows="10" placeholder="Paste job description here..."></textarea>
                                        <button class="btn btn-primary btn-block mt-2" onclick="analyzeJobMatch()"><i class="fas fa-search"></i> Analyze Match</button>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="card tool-card">
                                    <div class="card-header bg-white py-2"><span class="font-weight-bold"><i class="fas fa-chart-pie mr-1"></i>Results</span></div>
                                    <div class="card-body" id="matchResults">
                                        <div class="text-center text-muted py-4">
                                            <i class="fas fa-search fa-2x mb-2 opacity-50"></i>
                                            <p class="small">Paste a job description to analyze</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Save Modal -->
            <div class="modal fade" id="saveModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header border-0 pb-0">
                            <h5 class="modal-title"><i class="fas fa-save mr-2"></i>Save / Load</h5>
                            <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                        </div>
                        <div class="modal-body">
                            <div class="input-group mb-3">
                                <input type="text" class="form-control form-control-sm" id="saveResumeName" placeholder="Resume name...">
                                <div class="input-group-append"><button class="btn btn-primary btn-sm" onclick="saveResume()">Save</button></div>
                            </div>
                            <div id="savedResumesList" class="mb-3"></div>
                            <div class="d-flex">
                                <button class="btn btn-outline-secondary btn-sm flex-fill mr-1" onclick="exportJSON()"><i class="fas fa-download"></i> Export</button>
                                <label class="btn btn-outline-secondary btn-sm flex-fill mb-0"><i class="fas fa-upload"></i> Import<input type="file" accept=".json" onchange="importJSON(event)" style="display:none;"></label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="resume-builder-scripts.jsp" %>

            <div class="sharethis-inline-share-buttons mt-3"></div>
            <%@ include file="footer_adsense.jsp" %>
                <%@ include file="thanks.jsp" %>
                    <hr>
                    <%@ include file="addcomments.jsp" %>
                        </div>
                        <%@ include file="body-close.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- Resume Builder Scripts - Included by resume-builder.jsp --%>
<script>
    // Data
    let experiences = [], educations = [], projects = [], certs = [], langs = [], customSections = [];
    let currentTemplate = 'chronological';
    let profilePhoto = null;
    let sectionOrder = ['summary', 'experience', 'education', 'skills', 'projects', 'certs', 'langs'];
    let sectionVisibility = { summary: true, experience: true, education: true, skills: true, projects: true, certs: true, langs: true };

    // Color Presets
    const COLOR_PRESETS = [
        { name: 'Indigo', color: '#4f46e5' },
        { name: 'Blue', color: '#2563eb' },
        { name: 'Teal', color: '#0d9488' },
        { name: 'Emerald', color: '#059669' },
        { name: 'Orange', color: '#ea580c' },
        { name: 'Red', color: '#dc2626' },
        { name: 'Pink', color: '#db2777' },
        { name: 'Purple', color: '#7c3aed' },
        { name: 'Slate', color: '#475569' },
        { name: 'Black', color: '#171717' }
    ];

    // Templates Data
    const TEMPLATES = [
        { id: 'chronological', name: 'Chronological', type: 'type', desc: 'Traditional reverse time order', icon: 'fa-list-ol' },
        { id: 'functional', name: 'Functional', type: 'type', desc: 'Skills-focused format', icon: 'fa-tools' },
        { id: 'combination', name: 'Combination', type: 'type', desc: 'Hybrid skills + experience', icon: 'fa-columns' },
        { id: 'modern', name: 'Modern', type: 'style', desc: 'Contemporary design', icon: 'fa-star' },
        { id: 'professional', name: 'Professional', type: 'style', desc: 'Traditional corporate', icon: 'fa-briefcase' },
        { id: 'simple', name: 'Simple', type: 'style', desc: 'Clean minimal design', icon: 'fa-minus' },
        { id: 'executive', name: 'Executive', type: 'style', desc: 'Senior leadership', icon: 'fa-crown' },
        { id: 'creative', name: 'Creative', type: 'style', desc: 'Bold unique design', icon: 'fa-palette' },
        { id: 'minimal', name: 'Minimal', type: 'style', desc: 'Elegant simplicity', icon: 'fa-feather' },
        { id: 'twocolumn', name: 'Two-Column', type: 'style', desc: 'Sidebar layout', icon: 'fa-columns' }
    ];

    // Famous People Examples
    const FAMOUS_PEOPLE = [
        { id: 'elon_musk', name: 'Elon Musk', title: 'Tech Entrepreneur', icon: 'fa-rocket', data: {
            name: 'Elon Musk', title: 'Chief Executive Officer & Product Architect', email: 'elon@spacex.com', phone: '', location: 'Austin, TX', website: 'tesla.com | spacex.com',
            summary: 'Serial entrepreneur and visionary leader driving innovation in electric vehicles, space exploration, and sustainable energy. Founded and led multiple billion-dollar companies to transform entire industries. Pioneer in making humanity a multi-planetary species.',
            skills: 'Strategic Vision, Product Design, Engineering Leadership, Capital Markets, Manufacturing Innovation, AI/ML, Rocket Science, Battery Technology, Solar Energy, Executive Management',
            experiences: [
                { title: 'CEO & Product Architect', company: 'Tesla, Inc.', start: '2008', end: 'Present', desc: '• Grew company from startup to $800B+ market cap\n• Led development of Model S, 3, X, Y, Cybertruck\n• Revolutionized electric vehicle industry globally\n• Built Gigafactories on 3 continents' },
                { title: 'Founder & CEO', company: 'SpaceX', start: '2002', end: 'Present', desc: '• Created first private company to launch humans to ISS\n• Developed reusable rocket technology (Falcon 9)\n• Building Starship for Mars colonization\n• Launched Starlink satellite constellation' },
                { title: 'Co-Founder', company: 'Neuralink', start: '2016', end: 'Present', desc: '• Developing brain-computer interface technology\n• Advancing treatment for neurological conditions' },
                { title: 'Co-Founder & Chairman', company: 'PayPal (X.com)', start: '1999', end: '2002', desc: '• Built online payment platform\n• Sold to eBay for $1.5 billion' }
            ],
            educations: [{ degree: 'B.S. Economics & B.S. Physics', school: 'University of Pennsylvania', year: '1997' }],
            certs: []
        }},
        { id: 'donald_trump', name: 'Donald Trump', title: '45th & 47th US President', icon: 'fa-landmark', data: {
            name: 'Donald J. Trump', title: '45th & 47th President of the United States', email: '', phone: '', location: 'Palm Beach, FL', website: 'donaldjtrump.com',
            summary: 'Business executive turned political leader. Built global real estate and entertainment brand over five decades. First president elected without prior political or military experience. Known for unconventional communication style and negotiation tactics.',
            skills: 'Real Estate Development, Brand Building, Negotiation, Media & Communications, Deal Making, Public Speaking, Marketing, Television Production, Golf Course Development, Hospitality Management',
            experiences: [
                { title: '47th President', company: 'United States of America', start: '2025', end: 'Present', desc: '• Re-elected to serve second term\n• Focus on border security and economic policies\n• Trade negotiations and foreign policy' },
                { title: '45th President', company: 'United States of America', start: '2017', end: '2021', desc: '• Tax Cuts and Jobs Act of 2017\n• Three Supreme Court Justice appointments\n• Operation Warp Speed vaccine development\n• USMCA trade agreement' },
                { title: 'Chairman & President', company: 'The Trump Organization', start: '1971', end: '2017', desc: '• Built portfolio of hotels, casinos, golf courses\n• Developed Trump Tower NYC, Mar-a-Lago\n• Licensed Trump brand globally\n• Net worth estimated at billions' },
                { title: 'Executive Producer & Host', company: 'The Apprentice (NBC)', start: '2004', end: '2015', desc: '• Hosted 14 seasons of hit reality TV show\n• Popularized "You\'re Fired" catchphrase\n• Emmy-nominated television producer' }
            ],
            educations: [{ degree: 'B.S. Economics', school: 'Wharton School, University of Pennsylvania', year: '1968' }],
            certs: []
        }},
        { id: 'manmohan_singh', name: 'Manmohan Singh', title: 'Former PM of India', icon: 'fa-university', data: {
            name: 'Dr. Manmohan Singh', title: 'Economist & Former Prime Minister of India', email: '', phone: '', location: 'New Delhi, India', website: '',
            summary: 'Renowned economist and statesman who served as Prime Minister of India for two terms. Architect of India\'s economic liberalization in 1991 that transformed the nation into a major global economy. Known for integrity, intellectual rigor, and consensus-building leadership.',
            skills: 'Economic Policy, Fiscal Management, International Relations, Public Administration, Monetary Policy, Development Economics, Academic Research, Coalition Building, Crisis Management, Diplomacy',
            experiences: [
                { title: 'Prime Minister', company: 'Government of India', start: '2004', end: '2014', desc: '• Led India through decade of high economic growth (8%+ GDP)\n• Indo-US Civil Nuclear Agreement\n• Right to Information Act, MGNREGA\n• Navigated 2008 global financial crisis' },
                { title: 'Finance Minister', company: 'Government of India', start: '1991', end: '1996', desc: '• Architected historic 1991 economic reforms\n• Liberalized Indian economy, opened to global trade\n• Reduced fiscal deficit, stabilized currency\n• Laid foundation for India\'s economic growth' },
                { title: 'Governor', company: 'Reserve Bank of India', start: '1982', end: '1985', desc: '• Managed monetary policy for world\'s largest democracy\n• Implemented banking sector reforms\n• Strengthened foreign exchange reserves' },
                { title: 'Chief Economic Advisor', company: 'Ministry of Finance, India', start: '1972', end: '1976', desc: '• Advised on economic policy formulation\n• Authored key economic reports' }
            ],
            educations: [
                { degree: 'D.Phil. Economics', school: 'University of Oxford (Nuffield College)', year: '1962' },
                { degree: 'M.A. Economics (First Class)', school: 'University of Cambridge', year: '1957' },
                { degree: 'B.A. & M.A. Economics', school: 'Panjab University', year: '1954' }
            ],
            certs: [
                { name: 'Padma Vibhushan', issuer: 'Government of India', year: '1987' },
                { name: 'Honorary Doctorate', issuer: 'University of Cambridge', year: '2017' }
            ]
        }},
        { id: 'steve_jobs', name: 'Steve Jobs', title: 'Apple Co-Founder', icon: 'fa-apple-alt', data: {
            name: 'Steve Jobs', title: 'Co-Founder, Chairman & CEO', email: '', phone: '', location: 'Palo Alto, CA', website: 'apple.com',
            summary: 'Visionary entrepreneur who revolutionized personal computing, animated films, music, phones, and tablet computing. Known for obsessive attention to design and user experience. Built Apple into the world\'s most valuable company.',
            skills: 'Product Design, User Experience, Brand Strategy, Public Speaking, Negotiation, Marketing Vision, Industrial Design, Retail Innovation, Supply Chain, Talent Recruitment',
            experiences: [
                { title: 'CEO', company: 'Apple Inc.', start: '1997', end: '2011', desc: '• Transformed Apple from near-bankruptcy to most valuable company\n• Launched iPod, iPhone, iPad, MacBook Air\n• Created Apple Retail Stores\n• Revolutionized music industry with iTunes' },
                { title: 'CEO', company: 'Pixar Animation Studios', start: '1986', end: '2006', desc: '• Produced Toy Story, Finding Nemo, The Incredibles\n• Won multiple Academy Awards\n• Sold to Disney for $7.4 billion' },
                { title: 'Founder & CEO', company: 'NeXT Computer', start: '1985', end: '1997', desc: '• Developed NeXTSTEP operating system\n• Technology became foundation of Mac OS X' },
                { title: 'Co-Founder & CEO', company: 'Apple Computer', start: '1976', end: '1985', desc: '• Co-founded Apple in garage with Steve Wozniak\n• Launched Apple II, Macintosh\n• Pioneered personal computing revolution' }
            ],
            educations: [{ degree: 'Attended (dropped out)', school: 'Reed College', year: '1972' }],
            certs: []
        }},
        { id: 'bill_gates', name: 'Bill Gates', title: 'Microsoft Co-Founder', icon: 'fa-windows', data: {
            name: 'Bill Gates', title: 'Co-Founder & Technology Advisor', email: '', phone: '', location: 'Seattle, WA', website: 'gatesnotes.com',
            summary: 'Pioneering software entrepreneur who co-founded Microsoft and led the personal computer revolution. Now focused on global health, climate change, and education through the Bill & Melinda Gates Foundation. One of history\'s greatest philanthropists.',
            skills: 'Software Development, Business Strategy, Venture Capital, Philanthropy, Public Health, Climate Technology, Education Policy, Global Development, Technology Vision, Executive Leadership',
            experiences: [
                { title: 'Co-Chair', company: 'Bill & Melinda Gates Foundation', start: '2000', end: 'Present', desc: '• Largest private foundation ($50B+ endowment)\n• Leading fight against malaria, polio, HIV\n• Improving global education\n• Investing in climate solutions' },
                { title: 'Technology Advisor', company: 'Microsoft', start: '2020', end: 'Present', desc: '• Advising on product and technology strategy\n• Focus on AI and cloud computing' },
                { title: 'Chairman & CEO', company: 'Microsoft', start: '1975', end: '2014', desc: '• Built Microsoft into world\'s largest software company\n• Created Windows, Office, Azure cloud platform\n• Peak net worth: world\'s richest person for 18 years\n• Grew revenue from $0 to $85B+' }
            ],
            educations: [{ degree: 'Attended (dropped out)', school: 'Harvard University', year: '1975' }],
            certs: [
                { name: 'Honorary Knighthood (KBE)', issuer: 'Queen Elizabeth II', year: '2005' },
                { name: 'Presidential Medal of Freedom', issuer: 'United States', year: '2016' }
            ]
        }},
        { id: 'jensen_huang', name: 'Jensen Huang', title: 'NVIDIA CEO', icon: 'fa-microchip', data: {
            name: 'Jensen Huang', title: 'Co-Founder, President & CEO', email: '', phone: '', location: 'Santa Clara, CA', website: 'nvidia.com',
            summary: 'Semiconductor and AI computing pioneer. Co-founded NVIDIA in 1993 and led the creation of the GPU and CUDA platform, catalyzing modern AI and accelerated computing. Scaled NVIDIA into a global leader powering data centers, autonomous systems, and generative AI.',
            skills: 'Semiconductor Strategy, GPU Architecture, AI Platforms, High-Performance Computing, Product Vision, Go-to-Market, Strategic Partnerships, Supply Chain, Executive Leadership, Public Speaking',
            experiences: [
                { title: 'Co-Founder, President & CEO', company: 'NVIDIA Corporation', start: '1993', end: 'Present', desc: '• Built NVIDIA into leader in accelerated computing and AI\n• Led invention of the GPU and CUDA software platform\n• Scaled data center business for AI training and inference\n• Forged ecosystem partnerships across cloud, enterprise, and automotive' },
                { title: 'Director', company: 'LSI Logic', start: '1985', end: '1993', desc: '• Led core logic and ASIC initiatives\n• Worked with global customers on chip design' },
                { title: 'Microprocessor Designer', company: 'Advanced Micro Devices (AMD)', start: '1984', end: '1985', desc: '• Designed microprocessor components\n• Developed expertise in VLSI and computer architecture' }
            ],
            educations: [
                { degree: 'M.S. Electrical Engineering', school: 'Stanford University', year: '1992' },
                { degree: 'B.S. Electrical Engineering', school: 'Oregon State University', year: '1984' }
            ],
            certs: []
        }},
        { id: 'volodymyr_zelenskyy', name: 'Volodymyr Zelenskyy', title: 'President of Ukraine', icon: 'fa-landmark', data: {
            name: 'Volodymyr Zelenskyy', title: 'President of Ukraine', email: '', phone: '', location: 'Kyiv, Ukraine', website: 'president.gov.ua',
            summary: 'Former entertainer turned national leader known for crisis leadership, international advocacy, and mobilizing global support. Communicates effectively under pressure and builds coalitions across governments and institutions.',
            skills: 'Crisis Leadership, International Relations, Strategic Communication, Coalition Building, Public Speaking, Negotiation, Policy Strategy, Media Engagement',
            experiences: [
                { title: 'President', company: 'Ukraine', start: '2019', end: 'Present', desc: '• Led national response during wartime\n• Secured international aid and partnerships\n• Addressed parliaments and global forums' },
                { title: 'Founder & CEO', company: 'Kvartal 95 Studio', start: '2003', end: '2019', desc: '• Built leading production company\n• Produced award-winning TV series and films\n• Managed creative and business operations' },
                { title: 'Actor & Producer', company: 'Entertainment Industry', start: '1997', end: '2019', desc: '• Starred in TV, film, and stage\n• Developed and wrote comedic content' }
            ],
            educations: [
                { degree: 'Law (LL.B.)', school: 'Kyiv National Economic University', year: '' }
            ],
            certs: []
        }},
        { id: 'taylor_swift', name: 'Taylor Swift', title: 'Singer-Songwriter', icon: 'fa-music', data: {
            name: 'Taylor Swift', title: 'Singer-Songwriter & Producer', email: '', phone: '', location: 'Nashville, TN', website: 'taylorswift.com',
            summary: 'Record-breaking recording artist and producer recognized for storytelling, dynamic live performances, and innovative ownership and release strategies. Blends creative direction with savvy business, marketing, and fan engagement.',
            skills: 'Songwriting, Vocal Performance, Music Production, Guitar, Creative Direction, Brand Strategy, Business Management, Touring, Social Media, Storytelling',
            experiences: [
                { title: 'Recording Artist & Producer', company: 'Taylor Swift Productions', start: '2006', end: 'Present', desc: '• Released multiple multi-platinum albums across genres\n• Produced and directed music videos and films\n• Executed innovative re-recording and ownership strategy' },
                { title: 'Touring Artist', company: 'Global Touring', start: '2007', end: 'Present', desc: '• Headlined global stadium tours\n• Designed large-scale productions and fan experiences\n• Led teams across creative, logistics, and marketing' }
            ],
            educations: [],
            certs: []
        }},
        { id: 'vitalik_buterin', name: 'Vitalik Buterin', title: 'Ethereum Co‑Founder', icon: 'fa-coins', data: {
            name: 'Vitalik Buterin', title: 'Co-Founder, Ethereum', email: '', phone: '', location: 'Global', website: 'vitalik.ca',
            summary: 'Software developer and researcher who co-created Ethereum, a programmable blockchain that enabled smart contracts and decentralized applications. Focused on protocol design, scalability, security, and governance.',
            skills: 'Protocol Design, Cryptography, Mechanism Design, Distributed Systems, Research, Writing, Open-Source Leadership, Governance, Public Speaking',
            experiences: [
                { title: 'Co-Founder', company: 'Ethereum Foundation', start: '2014', end: 'Present', desc: '• Led Ethereum whitepaper and early design\n• Contributed to roadmap across PoS, scaling, and security\n• Engaged global developer and research communities' },
                { title: 'Researcher & Writer', company: 'Independent', start: '2011', end: 'Present', desc: '• Published research on cryptoeconomics and governance\n• Wrote extensively on protocol trade-offs and design' },
                { title: 'Co-Founder', company: 'Bitcoin Magazine', start: '2012', end: '2014', desc: '• Reported on early cryptocurrency ecosystem\n• Helped educate public on blockchain technology' }
            ],
            educations: [
                { degree: 'Computer Science (studies, departed)', school: 'University of Waterloo', year: '2014' }
            ],
            certs: [
                { name: 'Thiel Fellowship', issuer: 'Thiel Foundation', year: '2014' }
            ]
        }},
        { id: 'vladimir_putin', name: 'Vladimir Putin', title: 'President of Russia', icon: 'fa-landmark', data: {
            name: 'Vladimir Putin', title: 'President of the Russian Federation', email: '', phone: '', location: 'Moscow, Russia', website: 'en.kremlin.ru',
            summary: 'State leader with multi-decade experience in executive government, national security, and foreign policy. Led federal administration, energy strategy, and international negotiations across complex geopolitical environments.',
            skills: 'Statecraft, National Security, Foreign Policy, Energy Policy, Economic Policy, Diplomacy, Crisis Management, Strategic Communications, Negotiation, Public Administration',
            experiences: [
                { title: 'President', company: 'Russian Federation', start: '2012', end: 'Present', desc: '• Head of state and commander-in-chief\n• Oversaw domestic policy and federal administration\n• Directed foreign policy and security strategy' },
                { title: 'Prime Minister', company: 'Russian Federation', start: '2008', end: '2012', desc: '• Led government operations and cabinet\n• Coordinated economic and social policy\n• Managed intergovernmental programs and budgets' },
                { title: 'President', company: 'Russian Federation', start: '2000', end: '2008', desc: '• Implemented federal reforms and fiscal policy\n• Centralized administrative functions\n• Engaged in international diplomacy' },
                { title: 'Director', company: 'Federal Security Service (FSB)', start: '1998', end: '1999', desc: '• Led federal security service\n• Oversaw security and counterintelligence' }
            ],
            educations: [
                { degree: 'Law (J.D. equivalent)', school: 'Leningrad State University', year: '1975' }
            ],
            certs: []
        }},
        { id: 'lionel_messi', name: 'Lionel Messi', title: 'Footballer', icon: 'fa-futbol', data: {
            name: 'Lionel Messi', title: 'Forward | Captain', email: '', phone: '', location: 'Miami, FL', website: 'intermiamiCF.com',
            summary: 'Professional footballer widely regarded as one of the greatest of all time. Known for playmaking, finishing, and leadership on and off the pitch. Delivers consistent performance in club and international competitions.',
            skills: 'Playmaking, Finishing, Dribbling, Vision, Set Pieces, Leadership, Teamwork, High-Pressure Performance, Media Relations, Community Engagement',
            experiences: [
                { title: 'Forward', company: 'Inter Miami CF', start: '2023', end: 'Present', desc: '• Elevated league visibility and attendance\n• Led team in goals/assists contributions\n• Mentored developing players and academy talent' },
                { title: 'Forward', company: 'Paris Saint-Germain (PSG)', start: '2021', end: '2023', desc: '• Contributed to domestic titles\n• Formed attacking core with elite forwards\n• Delivered key assists and goals in Europe' },
                { title: 'Forward', company: 'FC Barcelona', start: '2004', end: '2021', desc: '• Club record goalscorer\n• Won multiple domestic and European titles\n• Anchored team tactics and creativity' }
            ],
            educations: [
                { degree: 'Youth Development (La Masia)', school: 'FC Barcelona Academy', year: '' }
            ],
            certs: [
                { name: 'FIFA World Cup Winner', issuer: 'Argentina National Team', year: '2022' }
            ]
        }},
        { id: 'data_scientist', name: 'Data Scientist', icon: 'fa-database', data: {
            name: 'Priya Sharma', title: 'Senior Data Scientist', email: 'priya.ds@email.com', phone: '+1 (555) 012-7788', location: 'New York, NY', website: 'github.com/priyasharma',
            summary: 'Applied ML scientist with 6+ years delivering predictive models and experimentation platforms that drive product and revenue outcomes. Experienced across NLP, time series, and causal inference.',
            skills: 'Python, SQL, Pandas, NumPy, Scikit-Learn, PyTorch, Feature Engineering, Experimentation, A/B Testing, Airflow, ML Ops, Docker, AWS Sagemaker',
            experiences: [{ title: 'Senior Data Scientist', company: 'Marketplace Co', start: '2021', end: 'Present', desc: '• Built ranking model improving GMV +6%\n• Launched experimentation service used by 20+ teams\n• Productionized models with CI/CD and monitoring' },
                { title: 'Data Scientist', company: 'Fintech Startup', start: '2018', end: '2021', desc: '• Deployed fraud detection model reducing chargebacks 30%\n• Partnered with product to prioritize data features' }],
            educations: [{ degree: 'M.S. Computer Science', school: 'Columbia University', year: '2018' }, { degree: 'B.S. Mathematics', school: 'University of Michigan', year: '2016' }],
            certs: [{ name: 'TensorFlow Developer', issuer: 'Google', year: '2020' }]
        }},
        { id: 'product_manager', name: 'Product Manager', icon: 'fa-lightbulb', data: {
            name: 'James Patel', title: 'Senior Product Manager', email: 'james.p@email.com', phone: '+1 (555) 234-7788', location: 'San Francisco, CA', website: 'linkedin.com/in/jamespatel',
            summary: 'Outcome-driven PM with 7+ years owning B2B SaaS roadmaps from discovery to GTM. Experienced in growth, pricing, and platform initiatives across cross-functional teams.',
            skills: 'Product Strategy, Roadmapping, Discovery, User Research, Prioritization, Agile, OKRs, Analytics, Monetization, Stakeholder Management, Go-To-Market',
            experiences: [{ title: 'Senior Product Manager', company: 'SaaS Platform', start: '2020', end: 'Present', desc: '• Grew ARR by $5M via packaging/pricing\n• Shipped features lifting activation +12%\n• Led 3 squads across platform and growth' },
                { title: 'Product Manager', company: 'Analytics Co', start: '2017', end: '2020', desc: '• Drove integrations adopted by 1K+ customers\n• Implemented discovery rituals and KPI reviews' }],
            educations: [{ degree: 'MBA', school: 'UC Berkeley, Haas', year: '2017' }, { degree: 'B.S. Electrical Engineering', school: 'Purdue University', year: '2013' }],
            certs: [{ name: 'Pragmatic Product Certified', issuer: 'Pragmatic Institute', year: '2019' }]
        }},
        { id: 'cybersecurity', name: 'Cybersecurity Analyst', icon: 'fa-shield-alt', data: {
            name: 'Nina Alvarez', title: 'Security Analyst (Blue Team)', email: 'nina.sec@email.com', phone: '+1 (555) 678-3344', location: 'Remote', website: 'linkedin.com/in/ninaalvarez',
            summary: 'Defensive security analyst specializing in detection engineering, incident response, and cloud security. Builds SIEM detections and playbooks to reduce MTTR and improve coverage.',
            skills: 'SIEM (Splunk), EDR, Detection Engineering, Threat Hunting, Incident Response, MITRE ATT&CK, AWS Security, Python, KQL, SOAR, Risk Assessment',
            experiences: [{ title: 'Security Analyst II', company: 'Global Retailer', start: '2021', end: 'Present', desc: '• Authored 40+ detections reducing false positives 25%\n• Led IR for cloud credential compromise incident\n• Automated triage with SOAR runbooks' },
                { title: 'SOC Analyst', company: 'MSSP', start: '2019', end: '2021', desc: '• Monitored 20+ client environments\n• Contained endpoint malware outbreaks\n• Wrote weekly threat intel briefs' }],
            educations: [{ degree: 'B.S. Information Security', school: 'UTSA', year: '2019' }],
            certs: [{ name: 'CompTIA Security+', issuer: 'CompTIA', year: '2019' }, { name: 'AWS Security Specialty', issuer: 'AWS', year: '2022' }]
        }},
        { id: 'devops', name: 'DevOps Engineer', icon: 'fa-server', data: {
            name: 'Omar Hassan', title: 'Senior DevOps Engineer', email: 'omar.devops@email.com', phone: '+1 (555) 998-2211', location: 'Austin, TX', website: 'github.com/omarhassan',
            summary: 'DevOps engineer focused on reliability, CI/CD, and infrastructure as code. Designed scalable Kubernetes platforms and observability stacks to support 100+ microservices.',
            skills: 'AWS, Terraform, Kubernetes, Helm, Docker, GitHub Actions, ArgoCD, Prometheus, Grafana, Linux, Bash, Python, SRE, Incident Management',
            experiences: [{ title: 'Senior DevOps Engineer', company: 'Streaming Company', start: '2020', end: 'Present', desc: '• Cut deploy time from 30m to 5m\n• Reduced cloud spend 18% via rightsizing\n• Built golden path templates for services' },
                { title: 'DevOps Engineer', company: 'E-commerce Platform', start: '2017', end: '2020', desc: '• Migrated to EKS with IaC\n• Implemented blue/green + canary releases' }],
            educations: [{ degree: 'B.S. Computer Engineering', school: 'UT Austin', year: '2017' }],
            certs: [{ name: 'CKA', issuer: 'CNCF', year: '2021' }]
        }},
        { id: 'investment_analyst', name: 'Investment Analyst', icon: 'fa-chart-line', data: {
            name: 'Ethan Brooks', title: 'Equity Research Analyst', email: 'ethan.b@email.com', phone: '+1 (555) 441-8899', location: 'Boston, MA', website: 'linkedin.com/in/ethanbrooks',
            summary: 'Public equities analyst covering software and semiconductors. Builds bottom‑up models, conducts channel checks, and publishes investment theses with risk frameworks.',
            skills: 'Financial Modeling, DCF, Comps, Channel Checks, Excel, PowerPoint, SQL, Alternative Data, Earnings Analysis, Writing, Presentation',
            experiences: [{ title: 'Equity Research Analyst', company: 'Asset Manager', start: '2020', end: 'Present', desc: '• Coverage: 25+ tickers in software/semis\n• Top‑quartile performance vs. benchmark\n• Built standardized KPI tracker' },
                { title: 'Investment Banking Analyst', company: 'Bulge Bracket Bank', start: '2018', end: '2020', desc: '• Supported 10+ IPO/M&A processes\n• Built operating/valuation models\n• Authored client materials' }],
            educations: [{ degree: 'B.S. Finance', school: 'Wharton School, UPenn', year: '2018' }],
            certs: [{ name: 'CFA Level II Passed', issuer: 'CFA Institute', year: '2023' }]
        }},
        { id: 'operations_manager', name: 'Operations Manager', icon: 'fa-cogs', data: {
            name: 'Olivia Nguyen', title: 'Operations Manager', email: 'olivia.ops@email.com', phone: '+1 (555) 321-4455', location: 'Denver, CO', website: 'linkedin.com/in/olivian',
            summary: 'Operations leader optimizing processes, people, and platforms across warehousing and last‑mile delivery. Uses lean principles and KPIs to reduce cost and improve SLA attainment.',
            skills: 'Operations Strategy, Process Improvement, Lean/Six Sigma, WMS/TMS, KPI Dashboards, Vendor Management, Budgeting, Workforce Planning, SOPs, Safety Compliance',
            experiences: [{ title: 'Operations Manager', company: 'Logistics Co', start: '2019', end: 'Present', desc: '• Improved on‑time delivery from 90%→97%\n• Reduced cost/order 12% via process redesign\n• Implemented WMS with barcode scanning' },
                { title: 'Area Manager', company: '3PL Provider', start: '2016', end: '2019', desc: '• Managed 120 associates across 2 sites\n• Launched new facility in 6 months' }],
            educations: [{ degree: 'B.S. Industrial Engineering', school: 'Penn State', year: '2016' }],
            certs: [{ name: 'Lean Six Sigma Green Belt', issuer: 'ASQ', year: '2019' }]
        }},
        { id: 'ux_designer', name: 'UX Designer', icon: 'fa-pencil-ruler', data: {
            name: 'Ava Morales', title: 'Senior Product Designer', email: 'ava.design@email.com', phone: '+1 (555) 667-9020', location: 'Remote', website: 'ava.design',
            summary: 'Product designer crafting end‑to‑end experiences from discovery to polished UI. Partners closely with PM and Eng to ship accessible, usable products that move metrics.',
            skills: 'Figma, Prototyping, Design Systems, User Research, Usability Testing, Accessibility, Interaction Design, Visual Design, Storytelling, HTML/CSS',
            experiences: [{ title: 'Senior Product Designer', company: 'B2B SaaS', start: '2020', end: 'Present', desc: '• Led redesign improving task success +25%\n• Built design system adopted by 6 squads\n• Ran research shaping roadmap' },
                { title: 'Product Designer', company: 'Fintech', start: '2017', end: '2020', desc: '• Shipped mobile onboarding cutting drop‑off 18%\n• Partnered with data to define UX metrics' }],
            educations: [{ degree: 'BFA Interaction Design', school: 'School of Visual Arts', year: '2017' }],
            certs: [{ name: 'NN/g UX Certification', issuer: 'Nielsen Norman Group', year: '2021' }]
        }},
        { id: 'customer_success', name: 'Customer Success', icon: 'fa-headset', data: {
            name: 'Marcus Allen', title: 'Customer Success Manager', email: 'marcus.cs@email.com', phone: '+1 (555) 909-4400', location: 'Chicago, IL', website: 'linkedin.com/in/marcusallen',
            summary: 'CSM driving retention and expansion through proactive adoption, QBRs, and executive alignment. Experienced with enterprise SaaS accounts and complex multi‑stakeholder rollouts.',
            skills: 'Onboarding, QBRs, Health Scoring, Playbooks, Churn Risk Mitigation, Upsell/Cross‑sell, Executive Communication, Salesforce, Gainsight, Zendesk',
            experiences: [{ title: 'Customer Success Manager', company: 'SaaS Growth Co', start: '2021', end: 'Present', desc: '• Managed $4M book with 120% NRR\n• Cut time‑to‑value by 35% via onboarding revamp\n• Built CSM playbooks and dashboards' },
                { title: 'Account Manager', company: 'Marketing Tech', start: '2018', end: '2021', desc: '• Drove 20% expansion across portfolio\n• Ran executive business reviews quarterly' }],
            educations: [{ degree: 'B.A. Communications', school: 'University of Illinois', year: '2018' }],
            certs: [{ name: 'Gainsight Admin', issuer: 'Gainsight', year: '2022' }]
        }}
    ];

    // Industry Examples
    const INDUSTRIES = [
        { id: 'software', name: 'Software Engineer', icon: 'fa-code', data: {
            name: 'Alex Chen', title: 'Senior Software Engineer', email: 'alex.chen@email.com', phone: '+1 (555) 123-4567', location: 'San Francisco, CA', website: 'github.com/alexchen',
            summary: 'Full-stack engineer with 6+ years building scalable web applications. Expert in React, Node.js, Python, and cloud architecture. Led teams delivering high-impact products.',
            skills: 'JavaScript, TypeScript, React, Node.js, Python, AWS, Docker, Kubernetes, PostgreSQL, MongoDB, Git, CI/CD',
            experiences: [{ title: 'Senior Software Engineer', company: 'Tech Corp', start: '2021', end: 'Present', desc: '• Architected microservices handling 1M+ daily requests\n• Led team of 5 engineers on core platform\n• Reduced API latency by 40%' },
                { title: 'Software Engineer', company: 'StartUp Inc', start: '2018', end: '2021', desc: '• Built React dashboard used by 50K+ users\n• Implemented CI/CD pipelines\n• Mentored 3 junior developers' }],
            educations: [{ degree: 'B.S. Computer Science', school: 'Stanford University', year: '2018' }],
            certs: [{ name: 'AWS Solutions Architect', issuer: 'Amazon', year: '2022' }]
        }},
        { id: 'teacher', name: 'Teacher', icon: 'fa-chalkboard-teacher', data: {
            name: 'Sarah Johnson', title: 'High School English Teacher', email: 'sarah.j@email.com', phone: '+1 (555) 234-5678', location: 'Boston, MA', website: 'linkedin.com/in/sarahjohnson',
            summary: 'Dedicated educator with 8+ years teaching high school English. Passionate about fostering critical thinking and literacy skills. Experienced in curriculum development and differentiated instruction.',
            skills: 'Curriculum Development, Classroom Management, Differentiated Instruction, Student Assessment, Google Classroom, Canvas LMS, Special Education, ESL Support',
            experiences: [{ title: 'English Teacher', company: 'Lincoln High School', start: '2018', end: 'Present', desc: '• Teach AP English Literature to 150+ students\n• Improved standardized test scores by 20%\n• Lead department curriculum committee' },
                { title: 'English Teacher', company: 'Roosevelt Middle School', start: '2015', end: '2018', desc: '• Developed creative writing program\n• Coached debate team to state finals\n• Implemented literacy intervention program' }],
            educations: [{ degree: 'M.Ed. Secondary Education', school: 'Boston University', year: '2015' }, { degree: 'B.A. English Literature', school: 'UMass Amherst', year: '2013' }],
            certs: [{ name: 'State Teaching License', issuer: 'MA Dept of Education', year: '2015' }]
        }},
        { id: 'nurse', name: 'Nurse', icon: 'fa-heartbeat', data: {
            name: 'Emily Rodriguez', title: 'Registered Nurse (RN)', email: 'emily.rn@email.com', phone: '+1 (555) 345-6789', location: 'Chicago, IL', website: 'linkedin.com/in/emilyrodriguez',
            summary: 'Compassionate RN with 5+ years in critical care and emergency medicine. Skilled in patient assessment, medication administration, and family communication. BLS and ACLS certified.',
            skills: 'Patient Care, Vital Signs Monitoring, IV Therapy, Medication Administration, Electronic Health Records (EHR), Patient Education, Wound Care, CPR/BLS, ACLS',
            experiences: [{ title: 'ICU Registered Nurse', company: 'Northwestern Memorial Hospital', start: '2020', end: 'Present', desc: '• Provide critical care for 4-6 patients per shift\n• Coordinate with multidisciplinary teams\n• Precept new graduate nurses' },
                { title: 'ER Nurse', company: 'Rush University Medical Center', start: '2018', end: '2020', desc: '• Triaged and assessed emergency patients\n• Administered medications and treatments\n• Maintained 98% patient satisfaction score' }],
            educations: [{ degree: 'BSN Nursing', school: 'University of Illinois Chicago', year: '2018' }],
            certs: [{ name: 'CCRN Certification', issuer: 'AACN', year: '2021' }, { name: 'BLS/ACLS', issuer: 'American Heart Association', year: '2023' }]
        }},
        { id: 'sales', name: 'Sales', icon: 'fa-handshake', data: {
            name: 'Michael Thompson', title: 'Senior Sales Executive', email: 'michael.t@email.com', phone: '+1 (555) 456-7890', location: 'New York, NY', website: 'linkedin.com/in/michaelthompson',
            summary: 'Top-performing sales professional with 7+ years exceeding quotas in B2B SaaS. Proven track record of closing enterprise deals worth $1M+. Expert in consultative selling and relationship building.',
            skills: 'B2B Sales, Account Management, Salesforce, HubSpot, Negotiation, Pipeline Management, Cold Calling, Presentations, Contract Negotiation, CRM',
            experiences: [{ title: 'Senior Account Executive', company: 'SaaS Solutions Inc', start: '2020', end: 'Present', desc: '• Exceeded quota by 140% ($2.8M ARR)\n• Closed largest deal in company history ($1.2M)\n• Built enterprise sales playbook' },
                { title: 'Account Executive', company: 'Tech Sales Co', start: '2017', end: '2020', desc: '• Achieved 125% of quota for 3 consecutive years\n• Managed portfolio of 50+ accounts\n• Generated $1.5M in new business' }],
            educations: [{ degree: 'B.S. Business Administration', school: 'NYU Stern', year: '2017' }],
            certs: [{ name: 'Salesforce Administrator', issuer: 'Salesforce', year: '2021' }]
        }},
        { id: 'marketing', name: 'Marketing', icon: 'fa-bullhorn', data: {
            name: 'Jessica Lee', title: 'Digital Marketing Manager', email: 'jessica.lee@email.com', phone: '+1 (555) 567-8901', location: 'Los Angeles, CA', website: 'jessicalee.com',
            summary: 'Data-driven marketing professional with 6+ years in digital marketing and brand strategy. Expertise in SEO, paid media, content marketing, and marketing automation. Track record of 3x ROI improvements.',
            skills: 'SEO/SEM, Google Ads, Facebook Ads, Google Analytics, HubSpot, Mailchimp, Content Strategy, A/B Testing, Social Media Marketing, Marketing Automation',
            experiences: [{ title: 'Digital Marketing Manager', company: 'Brand Agency', start: '2020', end: 'Present', desc: '• Manage $500K annual ad budget across channels\n• Increased organic traffic by 200%\n• Led rebrand generating 50% more leads' },
                { title: 'Marketing Specialist', company: 'E-commerce Co', start: '2017', end: '2020', desc: '• Launched email campaigns with 35% open rate\n• Managed social media growing followers 300%\n• Improved conversion rate by 25%' }],
            educations: [{ degree: 'B.A. Marketing', school: 'UCLA', year: '2017' }],
            certs: [{ name: 'Google Analytics Certified', issuer: 'Google', year: '2022' }]
        }},
        { id: 'accountant', name: 'Accountant', icon: 'fa-calculator', data: {
            name: 'David Wilson', title: 'Senior Accountant, CPA', email: 'david.w@email.com', phone: '+1 (555) 678-9012', location: 'Dallas, TX', website: 'linkedin.com/in/davidwilsoncpa',
            summary: 'CPA with 8+ years in public and corporate accounting. Expert in financial reporting, tax compliance, and audit management. Proficient in GAAP and IFRS standards.',
            skills: 'Financial Reporting, Tax Preparation, GAAP, IFRS, QuickBooks, SAP, Excel Advanced, Auditing, Budgeting, Accounts Payable/Receivable',
            experiences: [{ title: 'Senior Accountant', company: 'Fortune 500 Corp', start: '2019', end: 'Present', desc: '• Manage month-end close for $50M subsidiary\n• Prepare quarterly SEC filings\n• Lead team of 3 staff accountants' },
                { title: 'Staff Accountant', company: 'Big 4 Accounting Firm', start: '2015', end: '2019', desc: '• Performed audits for clients up to $100M revenue\n• Prepared corporate tax returns\n• Trained new associates' }],
            educations: [{ degree: 'M.S. Accounting', school: 'University of Texas', year: '2015' }, { degree: 'B.S. Finance', school: 'Texas A&M', year: '2013' }],
            certs: [{ name: 'CPA License', issuer: 'Texas State Board', year: '2016' }]
        }},
        { id: 'pm', name: 'Project Manager', icon: 'fa-tasks', data: {
            name: 'Amanda Garcia', title: 'Senior Project Manager, PMP', email: 'amanda.g@email.com', phone: '+1 (555) 789-0123', location: 'Seattle, WA', website: 'linkedin.com/in/amandagarcia',
            summary: 'PMP-certified project manager with 7+ years leading cross-functional teams. Delivered $10M+ in projects on time and under budget. Expert in Agile, Scrum, and Waterfall methodologies.',
            skills: 'Project Management, Agile/Scrum, JIRA, Asana, MS Project, Risk Management, Stakeholder Management, Budget Management, Resource Planning, Confluence',
            experiences: [{ title: 'Senior Project Manager', company: 'Tech Enterprise', start: '2019', end: 'Present', desc: '• Lead portfolio of 5+ concurrent projects ($5M+)\n• Implemented Agile transformation for department\n• Achieved 95% on-time delivery rate' },
                { title: 'Project Manager', company: 'Consulting Firm', start: '2016', end: '2019', desc: '• Managed client engagements worth $2M+\n• Delivered 20+ projects across industries\n• Mentored junior project coordinators' }],
            educations: [{ degree: 'MBA', school: 'University of Washington', year: '2016' }, { degree: 'B.S. Industrial Engineering', school: 'Georgia Tech', year: '2014' }],
            certs: [{ name: 'PMP Certification', issuer: 'PMI', year: '2018' }, { name: 'Certified Scrum Master', issuer: 'Scrum Alliance', year: '2020' }]
        }},
        { id: 'data', name: 'Data Analyst', icon: 'fa-chart-bar', data: {
            name: 'Kevin Park', title: 'Senior Data Analyst', email: 'kevin.park@email.com', phone: '+1 (555) 890-1234', location: 'Austin, TX', website: 'github.com/kevinpark',
            summary: 'Data analyst with 5+ years transforming data into actionable insights. Expert in SQL, Python, and visualization tools. Delivered analytics solutions saving $2M+ annually.',
            skills: 'SQL, Python, R, Tableau, Power BI, Excel, Statistical Analysis, A/B Testing, ETL, Data Modeling, Machine Learning Basics, BigQuery',
            experiences: [{ title: 'Senior Data Analyst', company: 'Tech Company', start: '2020', end: 'Present', desc: '• Built dashboards used by 200+ stakeholders\n• Automated reporting saving 20 hrs/week\n• Led pricing optimization increasing revenue 15%' },
                { title: 'Data Analyst', company: 'Retail Corp', start: '2018', end: '2020', desc: '• Analyzed customer behavior for 5M+ users\n• Created predictive churn model (85% accuracy)\n• Supported $10M marketing budget decisions' }],
            educations: [{ degree: 'M.S. Data Science', school: 'UT Austin', year: '2018' }, { degree: 'B.S. Statistics', school: 'UC Berkeley', year: '2016' }],
            certs: [{ name: 'Google Data Analytics', issuer: 'Google', year: '2021' }]
        }},
        { id: 'customer', name: 'Customer Service', icon: 'fa-headset', data: {
            name: 'Lisa Martinez', title: 'Customer Service Manager', email: 'lisa.m@email.com', phone: '+1 (555) 901-2345', location: 'Phoenix, AZ', website: 'linkedin.com/in/lisamartinez',
            summary: 'Customer service leader with 6+ years managing high-volume support teams. Track record of improving CSAT scores and reducing resolution times. Expert in Zendesk and Salesforce Service Cloud.',
            skills: 'Customer Support, Team Leadership, Zendesk, Salesforce, Conflict Resolution, Quality Assurance, Training & Development, KPI Management, Live Chat, Phone Support',
            experiences: [{ title: 'Customer Service Manager', company: 'E-commerce Giant', start: '2020', end: 'Present', desc: '• Manage team of 15 support agents\n• Improved CSAT from 82% to 94%\n• Reduced average handle time by 30%' },
                { title: 'Senior Customer Service Rep', company: 'SaaS Company', start: '2017', end: '2020', desc: '• Handled 50+ tickets daily with 98% satisfaction\n• Trained 10+ new team members\n• Created knowledge base reducing tickets 25%' }],
            educations: [{ degree: 'B.A. Communications', school: 'Arizona State University', year: '2017' }],
            certs: [{ name: 'Zendesk Administrator', issuer: 'Zendesk', year: '2021' }]
        }},
        { id: 'designer', name: 'Graphic Designer', icon: 'fa-paint-brush', data: {
            name: 'Rachel Kim', title: 'Senior Graphic Designer', email: 'rachel.kim@email.com', phone: '+1 (555) 012-3456', location: 'Portland, OR', website: 'rachelkimdesign.com',
            summary: 'Creative graphic designer with 5+ years crafting visual identities for brands. Expert in Adobe Creative Suite, UI/UX design, and brand strategy. Portfolio includes Fortune 500 clients.',
            skills: 'Adobe Photoshop, Illustrator, InDesign, Figma, Sketch, Brand Identity, Typography, Print Design, Digital Design, UI/UX, Motion Graphics',
            experiences: [{ title: 'Senior Graphic Designer', company: 'Creative Agency', start: '2020', end: 'Present', desc: '• Lead designer for 10+ major brand accounts\n• Created award-winning campaign visuals\n• Mentor junior designers' },
                { title: 'Graphic Designer', company: 'Marketing Firm', start: '2018', end: '2020', desc: '• Designed collateral for 50+ clients\n• Developed brand guidelines for startups\n• Increased social engagement 40% with designs' }],
            educations: [{ degree: 'BFA Graphic Design', school: 'RISD', year: '2018' }],
            certs: [{ name: 'Adobe Certified Expert', issuer: 'Adobe', year: '2020' }]
        }},
        { id: 'admin', name: 'Administrative', icon: 'fa-clipboard', data: {
            name: 'Jennifer Brown', title: 'Executive Administrative Assistant', email: 'jennifer.b@email.com', phone: '+1 (555) 123-4567', location: 'Atlanta, GA', website: 'linkedin.com/in/jenniferbrown',
            summary: 'Highly organized administrative professional with 7+ years supporting C-level executives. Expert in calendar management, travel coordination, and office operations. Notary public certified.',
            skills: 'Calendar Management, Microsoft Office Suite, Travel Coordination, Meeting Planning, Expense Reports, Document Management, Communication, Multitasking, Confidentiality, Notary Public',
            experiences: [{ title: 'Executive Assistant', company: 'Fortune 500 Corp', start: '2019', end: 'Present', desc: '• Support CEO and 3 VPs with daily operations\n• Coordinate complex international travel\n• Manage $100K+ annual budget for events' },
                { title: 'Administrative Assistant', company: 'Law Firm', start: '2016', end: '2019', desc: '• Supported 5 partners with scheduling\n• Prepared legal documents and filings\n• Coordinated client meetings and events' }],
            educations: [{ degree: 'A.S. Business Administration', school: 'Community College', year: '2016' }],
            certs: [{ name: 'Notary Public', issuer: 'State of Georgia', year: '2020' }]
        }},
        { id: 'server', name: 'Server / Hospitality', icon: 'fa-utensils', data: {
            name: 'Carlos Rivera', title: 'Lead Server', email: 'carlos.r@email.com', phone: '+1 (555) 234-5678', location: 'Miami, FL', website: '',
            summary: 'Experienced hospitality professional with 5+ years in fine dining. Expert in wine service, customer experience, and team leadership. TIPS certified with extensive menu knowledge.',
            skills: 'Customer Service, Wine Knowledge, POS Systems, Food Safety, Team Leadership, Upselling, Menu Knowledge, Cash Handling, Conflict Resolution, Fine Dining Service',
            experiences: [{ title: 'Lead Server', company: 'Upscale Restaurant', start: '2020', end: 'Present', desc: '• Serve 50+ guests nightly in fine dining\n• Train new servers on wine and menu\n• Consistently top performer in sales' },
                { title: 'Server', company: 'Hotel Restaurant', start: '2018', end: '2020', desc: '• Provided excellent service earning 4.9 rating\n• Handled private events up to 100 guests\n• Increased average check by 20% through upselling' }],
            educations: [{ degree: 'Hospitality Certificate', school: 'Culinary Institute', year: '2018' }],
            certs: [{ name: 'TIPS Certified', issuer: 'TIPS', year: '2022' }, { name: 'ServSafe', issuer: 'National Restaurant Association', year: '2023' }]
        }}
    ];

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        renderTemplateGallery();
        renderIndustryGrid();
        renderFamousPeopleGrid();
        renderColorPresets();
        renderSectionOrderList();
        updateTheme();

        // Load random famous person by default
        const randomFamous = FAMOUS_PEOPLE[Math.floor(Math.random() * FAMOUS_PEOPLE.length)];
        loadFamousExample(randomFamous.id);

        updateCoverLetter();
    });

    // Color Presets
    function renderColorPresets() {
        const container = document.getElementById('colorPresets');
        container.innerHTML = COLOR_PRESETS.map(p => `
            <div class="color-preset" style="background:${p.color};" title="${p.name}" onclick="selectColorPreset('${p.color}', this)"></div>
        `).join('');
    }

    function selectColorPreset(color, el) {
        document.getElementById('colorPicker').value = color;
        document.querySelectorAll('.color-preset').forEach(p => p.classList.remove('active'));
        el.classList.add('active');
        updateTheme();
    }

    // Photo Upload
    function handlePhotoUpload(event) {
        const file = event.target.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = function(e) {
            profilePhoto = e.target.result;
            document.getElementById('photoPreviewThumb').innerHTML = `<img src="${profilePhoto}" alt="Photo">`;
            document.getElementById('removePhotoBtn').style.display = 'inline-block';
            updatePreview();
        };
        reader.readAsDataURL(file);
    }

    function removePhoto() {
        profilePhoto = null;
        document.getElementById('photoPreviewThumb').innerHTML = '<i class="fas fa-user"></i>';
        document.getElementById('removePhotoBtn').style.display = 'none';
        document.getElementById('photoInput').value = '';
        updatePreview();
    }

    // Custom Sections
    function addCustomSection() {
        customSections.push({ id: Date.now(), title: 'Custom Section', items: [{ id: Date.now() + 1, content: '' }] });
        renderCustomSectionsForm();
        updatePreview();
    }

    function removeCustomSection(id) {
        customSections = customSections.filter(s => s.id !== id);
        renderCustomSectionsForm();
        updatePreview();
    }

    function updateCustomSectionTitle(id, title) {
        const section = customSections.find(s => s.id === id);
        if (section) { section.title = title; updatePreview(); }
    }

    function addCustomSectionItem(sectionId) {
        const section = customSections.find(s => s.id === sectionId);
        if (section) { section.items.push({ id: Date.now(), content: '' }); renderCustomSectionsForm(); }
    }

    function removeCustomSectionItem(sectionId, itemId) {
        const section = customSections.find(s => s.id === sectionId);
        if (section) { section.items = section.items.filter(i => i.id !== itemId); renderCustomSectionsForm(); updatePreview(); }
    }

    function updateCustomSectionItem(sectionId, itemId, content) {
        const section = customSections.find(s => s.id === sectionId);
        if (section) { const item = section.items.find(i => i.id === itemId); if (item) { item.content = content; updatePreview(); } }
    }

    function renderCustomSectionsForm() {
        const container = document.getElementById('customSectionsList');
        container.innerHTML = customSections.map(sec => `
            <div class="custom-section-card">
                <button class="remove-btn" onclick="removeCustomSection(${sec.id})"><i class="fas fa-times"></i></button>
                <input type="text" class="form-control form-control-xs mb-2" placeholder="Section Title" value="${sec.title}" oninput="updateCustomSectionTitle(${sec.id}, this.value)">
                ${sec.items.map(item => `
                    <div class="d-flex mb-1">
                        <input type="text" class="form-control form-control-xs flex-grow-1" placeholder="Item content" value="${item.content}" oninput="updateCustomSectionItem(${sec.id}, ${item.id}, this.value)">
                        <button class="btn btn-sm text-danger" onclick="removeCustomSectionItem(${sec.id}, ${item.id})"><i class="fas fa-times"></i></button>
                    </div>
                `).join('')}
                <button class="btn btn-outline-secondary btn-sm btn-block" onclick="addCustomSectionItem(${sec.id})"><i class="fas fa-plus"></i> Add Item</button>
            </div>
        `).join('');
    }

    // Section Reordering & Visibility
    const SECTION_NAMES = {
        summary: 'Summary', experience: 'Experience', education: 'Education',
        skills: 'Skills', projects: 'Projects', certs: 'Certifications', langs: 'Languages'
    };
    const SECTION_ICONS = {
        summary: 'fa-align-left', experience: 'fa-briefcase', education: 'fa-graduation-cap',
        skills: 'fa-tools', projects: 'fa-project-diagram', certs: 'fa-certificate', langs: 'fa-language'
    };

    function renderSectionOrderList() {
        const container = document.getElementById('sectionOrderList');
        container.innerHTML = sectionOrder.map((sec, i) => `
            <div class="entry-card d-flex align-items-center ${sectionVisibility[sec] ? '' : 'opacity-50'}" draggable="true" data-section="${sec}" ondragstart="dragSectionStart(event)" ondragover="dragSectionOver(event)" ondrop="dropSection(event)" ondragend="dragSectionEnd(event)">
                <i class="fas fa-grip-vertical drag-handle mr-2"></i>
                <div class="custom-control custom-switch mr-2">
                    <input type="checkbox" class="custom-control-input" id="toggle_${sec}" ${sectionVisibility[sec] ? 'checked' : ''} onchange="toggleSectionVisibility('${sec}')">
                    <label class="custom-control-label" for="toggle_${sec}"></label>
                </div>
                <i class="fas ${SECTION_ICONS[sec]} mr-2 text-muted" style="width:16px;"></i>
                <span class="flex-grow-1 small">${SECTION_NAMES[sec] || sec}</span>
                <div>
                    <button class="btn btn-sm btn-link p-0 mr-1" onclick="moveSectionUp('${sec}')" ${i === 0 ? 'disabled' : ''}><i class="fas fa-chevron-up"></i></button>
                    <button class="btn btn-sm btn-link p-0" onclick="moveSectionDown('${sec}')" ${i === sectionOrder.length - 1 ? 'disabled' : ''}><i class="fas fa-chevron-down"></i></button>
                </div>
            </div>
        `).join('');
    }

    function toggleSectionVisibility(sec) {
        sectionVisibility[sec] = !sectionVisibility[sec];
        renderSectionOrderList();
        applySectionOrder();
    }

    function moveSectionUp(sec) {
        const idx = sectionOrder.indexOf(sec);
        if (idx > 0) {
            sectionOrder.splice(idx, 1);
            sectionOrder.splice(idx - 1, 0, sec);
            renderSectionOrderList();
            applySectionOrder();
        }
    }

    function moveSectionDown(sec) {
        const idx = sectionOrder.indexOf(sec);
        if (idx < sectionOrder.length - 1) {
            sectionOrder.splice(idx, 1);
            sectionOrder.splice(idx + 1, 0, sec);
            renderSectionOrderList();
            applySectionOrder();
        }
    }

    function resetSectionSettings() {
        sectionOrder = ['summary', 'experience', 'education', 'skills', 'projects', 'certs', 'langs'];
        sectionVisibility = { summary: true, experience: true, education: true, skills: true, projects: true, certs: true, langs: true };
        renderSectionOrderList();
        applySectionOrder();
    }

    let draggedSection = null;
    function dragSectionStart(e) { draggedSection = e.target.dataset.section; e.target.classList.add('dragging'); }
    function dragSectionEnd(e) { e.target.classList.remove('dragging'); document.querySelectorAll('.drag-over').forEach(el => el.classList.remove('drag-over')); }
    function dragSectionOver(e) { e.preventDefault(); e.currentTarget.classList.add('drag-over'); }
    function dropSection(e) {
        e.preventDefault();
        e.currentTarget.classList.remove('drag-over');
        const targetSection = e.currentTarget.dataset.section;
        if (draggedSection && targetSection && draggedSection !== targetSection) {
            const fromIdx = sectionOrder.indexOf(draggedSection);
            const toIdx = sectionOrder.indexOf(targetSection);
            sectionOrder.splice(fromIdx, 1);
            sectionOrder.splice(toIdx, 0, draggedSection);
            renderSectionOrderList();
            applySectionOrder();
        }
    }

    function applySectionOrder() {
        const sectionMap = {
            summary: 'previewSummarySection', experience: 'previewExpSection', education: 'previewEduSection',
            skills: 'previewSkillsSection', projects: 'previewProjectSection', certs: 'previewCertSection', langs: 'previewLangSection'
        };
        sectionOrder.forEach((sec, i) => {
            const el = document.getElementById(sectionMap[sec]);
            if (el) {
                el.style.order = i;
                el.dataset.order = i;
                if (!sectionVisibility[sec]) {
                    el.classList.add('section-hidden');
                } else {
                    el.classList.remove('section-hidden');
                }
            }
        });
    }

    function renderTemplateGallery() {
        const gallery = document.getElementById('templateGallery');
        gallery.innerHTML = TEMPLATES.map(t => `
            <div class="template-card ${t.id === currentTemplate ? 'active' : ''}" onclick="selectTemplate('${t.id}')" data-type="${t.type}">
                <div style="height:80px;background:#f3f4f6;display:flex;align-items:center;justify-content:center;border-radius:4px;">
                    <i class="fas ${t.icon} fa-2x" style="color:var(--theme-primary);opacity:0.5;"></i>
                </div>
                <div class="name">${t.name}</div>
                <div class="type">${t.desc}</div>
            </div>
        `).join('');
    }

    function renderIndustryGrid() {
        const grid = document.getElementById('industryGrid');
        grid.innerHTML = INDUSTRIES.map(ind => `
            <div class="industry-card" onclick="loadIndustryExample('${ind.id}')">
                <i class="fas ${ind.icon}"></i>
                <div class="name">${ind.name}</div>
            </div>
        `).join('');
    }

    function renderFamousPeopleGrid() {
        const grid = document.getElementById('famousPeopleGrid');
        if (!grid) return;
        grid.innerHTML = FAMOUS_PEOPLE.map(fp => `
            <div class="famous-card" onclick="loadFamousExample('${fp.id}')">
                <i class="fas ${fp.icon}"></i>
                <div class="name">${fp.name}</div>
                <div class="title">${fp.title}</div>
            </div>
        `).join('');
    }

    function loadFamousExample(id) {
        const fp = FAMOUS_PEOPLE.find(p => p.id === id);
        if (!fp) return;
        const d = fp.data;

        document.getElementById('inputName').value = d.name;
        document.getElementById('inputTitle').value = d.title;
        document.getElementById('inputEmail').value = d.email;
        document.getElementById('inputPhone').value = d.phone;
        document.getElementById('inputLocation').value = d.location;
        document.getElementById('inputWebsite').value = d.website;
        document.getElementById('inputSummary').value = d.summary;
        document.getElementById('inputSkills').value = d.skills;

        experiences = (d.experiences || []).map((e, i) => ({ id: Date.now() + i, ...e }));
        educations = (d.educations || []).map((e, i) => ({ id: Date.now() + 100 + i, ...e }));
        certs = (d.certs || []).map((c, i) => ({ id: Date.now() + 200 + i, ...c }));
        projects = [];
        langs = [];

        renderExperienceForm();
        renderEducationForm();
        renderCertForm();
        renderProjectForm();
        renderLangForm();
        updatePreview();

        // Select executive template for famous people
        selectTemplate('executive');
        $('a[href="#resumePanel"]').tab('show');
    }

    function selectTemplate(id) {
        currentTemplate = id;
        document.getElementById('templateSelect').value = id;
        setTemplate(id);
        renderTemplateGallery();
        $('a[href="#resumePanel"]').tab('show');
    }

    function filterTemplates(filter, el) {
        document.querySelectorAll('.category-pill').forEach(p => p.classList.remove('active'));
        el.classList.add('active');
        document.querySelectorAll('.template-card').forEach(card => {
            if (filter === 'all' || card.dataset.type === filter) {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function loadIndustryExample(id) {
        const ind = INDUSTRIES.find(i => i.id === id);
        if (!ind) return;
        const d = ind.data;

        document.getElementById('inputName').value = d.name;
        document.getElementById('inputTitle').value = d.title;
        document.getElementById('inputEmail').value = d.email;
        document.getElementById('inputPhone').value = d.phone;
        document.getElementById('inputLocation').value = d.location;
        document.getElementById('inputWebsite').value = d.website;
        document.getElementById('inputSummary').value = d.summary;
        document.getElementById('inputSkills').value = d.skills;

        experiences = (d.experiences || []).map((e, i) => ({ id: Date.now() + i, ...e }));
        educations = (d.educations || []).map((e, i) => ({ id: Date.now() + 100 + i, ...e }));
        certs = (d.certs || []).map((c, i) => ({ id: Date.now() + 200 + i, ...c }));
        projects = [];
        langs = [];

        renderExperienceForm();
        renderEducationForm();
        renderCertForm();
        renderProjectForm();
        renderLangForm();
        updatePreview();

        $('a[href="#resumePanel"]').tab('show');
    }

    // Toggle Section
    function toggleSection(el) { el.parentElement.classList.toggle('collapsed'); }

    // Update Preview
    function updatePreview() {
        document.getElementById('previewName').textContent = document.getElementById('inputName').value || 'Your Name';
        document.getElementById('previewTitle').textContent = document.getElementById('inputTitle').value || 'Professional Title';
        updateContactField('inputEmail', 'previewEmail', 'previewEmailWrap');
        updateContactField('inputPhone', 'previewPhone', 'previewPhoneWrap');
        updateContactField('inputLocation', 'previewLocation', 'previewLocationWrap');
        updateContactField('inputWebsite', 'previewWebsite', 'previewWebsiteWrap');

        // Photo
        const photoEl = document.getElementById('previewPhoto');
        if (profilePhoto) {
            photoEl.src = profilePhoto;
            photoEl.style.display = 'block';
        } else {
            photoEl.style.display = 'none';
        }

        const summary = document.getElementById('inputSummary').value;
        document.getElementById('previewSummary').textContent = summary;
        document.getElementById('previewSummarySection').style.display = summary ? 'block' : 'none';

        // Skills
        const skills = document.getElementById('inputSkills').value;
        const showBars = document.getElementById('showSkillBars').checked;
        const skillsContainer = document.getElementById('previewSkills');
        skillsContainer.innerHTML = '';
        if (skills) {
            const skillArr = skills.split(',').filter(s => s.trim());
            if (showBars) {
                skillsContainer.innerHTML = skillArr.map((skill, i) => {
                    const level = 90 - (i * 5);
                    return `<div class="skill-bar-container"><div class="skill-bar-label"><span>${skill.trim()}</span><span>${level}%</span></div><div class="skill-bar"><div class="skill-bar-fill" style="width:${level}%"></div></div></div>`;
                }).join('');
            } else {
                skillsContainer.className = 'resume-skills';
                skillsContainer.innerHTML = skillArr.map(s => `<span class="resume-skill-tag">${s.trim()}</span>`).join('');
            }
            document.getElementById('previewSkillsSection').style.display = 'block';
        } else {
            document.getElementById('previewSkillsSection').style.display = 'none';
        }

        renderAllPreviews();
        renderCustomSectionsPreview();
        applySectionOrder();
        updateCoverLetter();
        updatePageCount();
    }

    // Page calculation
    function updatePageCount() {
        const preview = document.getElementById('resumePreview');
        const pageHeight = 842;
        const contentHeight = preview.scrollHeight;
        const totalPages = Math.max(1, Math.ceil(contentHeight / pageHeight));

        document.getElementById('pageInfo').textContent = `Page 1 of ${totalPages}` + (totalPages > 1 ? ' (scroll to see more)' : '');

        const pageNum = preview.querySelector('.page-number');
        if (pageNum) {
            pageNum.textContent = totalPages > 1 ? `Page 1 of ${totalPages}` : '';
        }

        const additionalPages = document.getElementById('additionalPages');
        additionalPages.innerHTML = '';

        if (totalPages > 1) {
            for (let i = 2; i <= totalPages; i++) {
                additionalPages.innerHTML += `<div class="page-divider">${i}</div>`;
            }
        }
    }

    function renderCustomSectionsPreview() {
        const container = document.getElementById('previewCustomSections');
        container.innerHTML = customSections.filter(s => s.items.some(i => i.content.trim())).map(sec => `
            <div class="resume-section">
                <div class="resume-section-title">${sec.title}</div>
                <ul style="margin:0;padding-left:1.2rem;font-size:0.65rem;">
                    ${sec.items.filter(i => i.content.trim()).map(item => `<li>${item.content}</li>`).join('')}
                </ul>
            </div>
        `).join('');
    }

    function updateContactField(inputId, previewId, wrapId) {
        const val = document.getElementById(inputId).value;
        document.getElementById(previewId).textContent = val;
        document.getElementById(wrapId).style.display = val ? 'inline-flex' : 'none';
    }

    // CRUD helpers
    function addExperience(data = {}) { experiences.push({ id: Date.now(), ...data }); renderExperienceForm(); updatePreview(); }
    function addEducation(data = {}) { educations.push({ id: Date.now(), ...data }); renderEducationForm(); updatePreview(); }
    function addProject(data = {}) { projects.push({ id: Date.now(), ...data }); renderProjectForm(); updatePreview(); }
    function addCert(data = {}) { certs.push({ id: Date.now(), ...data }); renderCertForm(); updatePreview(); }
    function addLang(data = {}) { langs.push({ id: Date.now(), ...data }); renderLangForm(); updatePreview(); }

    function removeItem(list, id, renderFn) { const idx = list.findIndex(e => e.id === id); if (idx > -1) list.splice(idx, 1); renderFn(); updatePreview(); }
    function updateItem(list, id, field, value) { const item = list.find(e => e.id === id); if (item) { item[field] = value; updatePreview(); } }

    function renderExperienceForm() {
        document.getElementById('experienceList').innerHTML = experiences.map(exp => `
            <div class="entry-card"><button class="remove-btn" onclick="removeItem(experiences, ${exp.id}, renderExperienceForm)"><i class="fas fa-times"></i></button>
            <div class="row"><div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" placeholder="Title" value="${exp.title || ''}" oninput="updateItem(experiences, ${exp.id}, 'title', this.value)"></div>
            <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" placeholder="Company" value="${exp.company || ''}" oninput="updateItem(experiences, ${exp.id}, 'company', this.value)"></div>
            <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" placeholder="Start" value="${exp.start || ''}" oninput="updateItem(experiences, ${exp.id}, 'start', this.value)"></div>
            <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" placeholder="End" value="${exp.end || ''}" oninput="updateItem(experiences, ${exp.id}, 'end', this.value)"></div>
            <div class="col-12"><textarea class="form-control form-control-xs" rows="2" placeholder="Description" oninput="updateItem(experiences, ${exp.id}, 'desc', this.value)">${exp.desc || ''}</textarea></div></div></div>
        `).join('');
    }

    function renderEducationForm() {
        document.getElementById('educationList').innerHTML = educations.map(edu => `
            <div class="entry-card"><button class="remove-btn" onclick="removeItem(educations, ${edu.id}, renderEducationForm)"><i class="fas fa-times"></i></button>
            <div class="row"><div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" placeholder="Degree" value="${edu.degree || ''}" oninput="updateItem(educations, ${edu.id}, 'degree', this.value)"></div>
            <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" placeholder="School" value="${edu.school || ''}" oninput="updateItem(educations, ${edu.id}, 'school', this.value)"></div>
            <div class="col-6"><input type="text" class="form-control form-control-xs" placeholder="Year" value="${edu.year || ''}" oninput="updateItem(educations, ${edu.id}, 'year', this.value)"></div></div></div>
        `).join('');
    }

    function renderProjectForm() {
        document.getElementById('projectList').innerHTML = projects.map(p => `
            <div class="entry-card"><button class="remove-btn" onclick="removeItem(projects, ${p.id}, renderProjectForm)"><i class="fas fa-times"></i></button>
            <div class="row"><div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" placeholder="Name" value="${p.name || ''}" oninput="updateItem(projects, ${p.id}, 'name', this.value)"></div>
            <div class="col-6 mb-1"><input type="text" class="form-control form-control-xs" placeholder="Tech" value="${p.tech || ''}" oninput="updateItem(projects, ${p.id}, 'tech', this.value)"></div>
            <div class="col-12"><textarea class="form-control form-control-xs" rows="2" placeholder="Description" oninput="updateItem(projects, ${p.id}, 'desc', this.value)">${p.desc || ''}</textarea></div></div></div>
        `).join('');
    }

    function renderCertForm() {
        document.getElementById('certList').innerHTML = certs.map(c => `
            <div class="entry-card"><button class="remove-btn" onclick="removeItem(certs, ${c.id}, renderCertForm)"><i class="fas fa-times"></i></button>
            <div class="row"><div class="col-8 mb-1"><input type="text" class="form-control form-control-xs" placeholder="Name" value="${c.name || ''}" oninput="updateItem(certs, ${c.id}, 'name', this.value)"></div>
            <div class="col-4 mb-1"><input type="text" class="form-control form-control-xs" placeholder="Year" value="${c.year || ''}" oninput="updateItem(certs, ${c.id}, 'year', this.value)"></div>
            <div class="col-12"><input type="text" class="form-control form-control-xs" placeholder="Issuer" value="${c.issuer || ''}" oninput="updateItem(certs, ${c.id}, 'issuer', this.value)"></div></div></div>
        `).join('');
    }

    function renderLangForm() {
        document.getElementById('langList').innerHTML = langs.map(l => `
            <div class="entry-card"><button class="remove-btn" onclick="removeItem(langs, ${l.id}, renderLangForm)"><i class="fas fa-times"></i></button>
            <div class="row"><div class="col-6"><input type="text" class="form-control form-control-xs" placeholder="Language" value="${l.name || ''}" oninput="updateItem(langs, ${l.id}, 'name', this.value)"></div>
            <div class="col-6"><select class="form-control form-control-xs" onchange="updateItem(langs, ${l.id}, 'level', this.value)">
            <option value="">Level</option><option value="Native" ${l.level==='Native'?'selected':''}>Native</option><option value="Fluent" ${l.level==='Fluent'?'selected':''}>Fluent</option>
            <option value="Advanced" ${l.level==='Advanced'?'selected':''}>Advanced</option><option value="Intermediate" ${l.level==='Intermediate'?'selected':''}>Intermediate</option><option value="Basic" ${l.level==='Basic'?'selected':''}>Basic</option></select></div></div></div>
        `).join('');
    }

    function renderAllPreviews() {
        const renderSection = (list, sectionId, listId, mapFn) => {
            const section = document.getElementById(sectionId);
            const container = document.getElementById(listId);
            if (list.length === 0) { section.style.display = 'none'; }
            else { section.style.display = 'block'; container.innerHTML = list.map(mapFn).join(''); }
        };

        renderSection(experiences, 'previewExpSection', 'previewExpList', exp => `
            <div class="resume-item"><div class="resume-item-header"><span class="resume-item-title">${exp.title || 'Title'}</span><span class="resume-item-date">${exp.start || ''} - ${exp.end || ''}</span></div>
            <div class="resume-item-subtitle">${exp.company || ''}</div><div class="resume-item-desc">${(exp.desc || '').replace(/\n/g, '<br>')}</div></div>`);

        renderSection(educations, 'previewEduSection', 'previewEduList', edu => `
            <div class="resume-item"><div class="resume-item-header"><span class="resume-item-title">${edu.school || 'School'}</span><span class="resume-item-date">${edu.year || ''}</span></div>
            <div class="resume-item-subtitle">${edu.degree || ''}</div></div>`);

        renderSection(projects, 'previewProjectSection', 'previewProjectList', p => `
            <div class="resume-item"><div class="resume-item-header"><span class="resume-item-title">${p.name || 'Project'}</span><span class="resume-item-date">${p.tech || ''}</span></div>
            <div class="resume-item-desc">${(p.desc || '').replace(/\n/g, '<br>')}</div></div>`);

        renderSection(certs, 'previewCertSection', 'previewCertList', c => `
            <div class="resume-item"><div class="resume-item-header"><span class="resume-item-title">${c.name || 'Cert'}</span><span class="resume-item-date">${c.year || ''}</span></div>
            <div class="resume-item-subtitle">${c.issuer || ''}</div></div>`);

        const langSection = document.getElementById('previewLangSection');
        const langList = document.getElementById('previewLangList');
        if (langs.length === 0) { langSection.style.display = 'none'; }
        else { langSection.style.display = 'block'; langList.innerHTML = langs.map(l => `<span>${l.name}${l.level ? ' (' + l.level + ')' : ''}</span>`).join(' &bull; '); }
    }

    // Template & Theme
    function setTemplate(name) {
        currentTemplate = name;
        const preview = document.getElementById('resumePreview');
        preview.className = 'resume-preview';
        if (name !== 'chronological') preview.classList.add('template-' + name);
    }

    function updateTheme() {
        const color = document.getElementById('colorPicker').value;
        const font = document.getElementById('fontPicker').value;
        const preview = document.getElementById('resumePreview');
        preview.style.setProperty('--accent-color', color);
        preview.style.fontFamily = font;
    }

    // Cover Letter
    function updateCoverLetter() {
        const name = document.getElementById('inputName').value || 'Your Name';
        const email = document.getElementById('inputEmail').value;
        const phone = document.getElementById('inputPhone').value;
        document.getElementById('clName').textContent = name;
        document.getElementById('clContact').textContent = [email, phone].filter(Boolean).join(' | ');
        document.getElementById('clDate').textContent = new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
        const manager = document.getElementById('coverManager').value;
        document.getElementById('clRecipient').textContent = manager || '';
        document.getElementById('clCompany').textContent = document.getElementById('coverCompany').value || '';
        document.getElementById('clGreeting').textContent = manager ? `Dear ${manager},` : 'Dear Hiring Manager,';
        document.getElementById('clOpening').textContent = document.getElementById('coverOpening').value || '';
        document.getElementById('clBody').textContent = document.getElementById('coverBody').value || '';
        document.getElementById('clClosing').textContent = document.getElementById('coverClosing').value || '';
        document.getElementById('clSignature').textContent = name;
    }

    function generateCoverLetter() {
        const name = document.getElementById('inputName').value || '[Name]';
        const title = document.getElementById('inputTitle').value || '[Title]';
        const company = document.getElementById('coverCompany').value || '[Company]';
        const job = document.getElementById('coverJob').value || '[Position]';
        const skills = document.getElementById('inputSkills').value.split(',').slice(0, 3).join(', ');
        document.getElementById('coverOpening').value = `I am writing to express my interest in the ${job} position at ${company}. As a ${title}, I am confident my skills make me an excellent candidate.`;
        document.getElementById('coverBody').value = `Throughout my career, I have developed expertise in ${skills}. ${experiences[0] ? `At ${experiences[0].company}, I ${experiences[0].desc?.split('\n')[0]?.replace('• ', '') || 'delivered impactful results'}.` : ''}`;
        document.getElementById('coverClosing').value = `I am excited about this opportunity and would welcome the chance to discuss how I can contribute to ${company}. Thank you for your consideration.`;
        updateCoverLetter();
    }

    // Job Match
    function analyzeJobMatch() {
        const jobDesc = document.getElementById('jobDescription').value.toLowerCase();
        if (!jobDesc) { alert('Please paste a job description.'); return; }
        const resumeSkills = document.getElementById('inputSkills').value.split(',').map(s => s.trim().toLowerCase()).filter(Boolean);
        const resumeText = [document.getElementById('inputTitle').value, document.getElementById('inputSummary').value, ...experiences.map(e => `${e.title} ${e.company} ${e.desc}`)].join(' ').toLowerCase();
        const stopWords = new Set(['the','and','or','a','an','in','on','at','to','for','of','with','is','are','was','were','be','been','have','has','do','does','will','would','could','should','this','that','you','we','they','it','i','what','which','who','where','when','how','all','each','both','few','more','most','other','some','no','not','only','but','if','as','into','through','during','before','after','from','up','down','out','off','over','under','again','then','here','there','any','about','our','your','their','experience','work','team','ability','strong','looking','join','position','role','company','requirements','required','preferred','skills','years','year']);
        const words = jobDesc.match(/\b[a-z]+\b/g) || [];
        const counts = {};
        words.forEach(w => { if (w.length > 2 && !stopWords.has(w)) counts[w] = (counts[w] || 0) + 1; });
        const topKw = Object.entries(counts).sort((a, b) => b[1] - a[1]).slice(0, 20).map(e => e[0]);
        const matched = [], missing = [];
        topKw.forEach(kw => { (resumeText.includes(kw) || resumeSkills.some(s => s.includes(kw))) ? matched.push(kw) : missing.push(kw); });
        const score = topKw.length > 0 ? Math.round((matched.length / topKw.length) * 100) : 0;
        const cls = score >= 70 ? 'good' : score >= 40 ? 'medium' : 'low';
        document.getElementById('matchResults').innerHTML = `
            <div class="text-center mb-3"><div class="match-score ${cls}">${score}%</div><div class="text-muted small">Match Score</div></div>
            <div class="mb-2"><h6 class="text-success small"><i class="fas fa-check-circle"></i> Matched (${matched.length})</h6><div>${matched.map(k => `<span class="match-keyword">${k}</span>`).join(' ') || '<span class="text-muted">None</span>'}</div></div>
            <div class="mb-2"><h6 class="text-danger small"><i class="fas fa-times-circle"></i> Missing (${missing.length})</h6><div>${missing.map(k => `<span class="missing-keyword">${k}</span>`).join(' ') || '<span class="text-muted">None</span>'}</div></div>
            <div class="alert alert-info small py-2"><i class="fas fa-lightbulb"></i> Add missing keywords where relevant.</div>`;
    }

    // Save/Load
    function showSaveModal() { renderSavedResumes(); $('#saveModal').modal('show'); }
    function getResumeData() { return { personal: { name: document.getElementById('inputName').value, title: document.getElementById('inputTitle').value, email: document.getElementById('inputEmail').value, phone: document.getElementById('inputPhone').value, location: document.getElementById('inputLocation').value, website: document.getElementById('inputWebsite').value, summary: document.getElementById('inputSummary').value, skills: document.getElementById('inputSkills').value }, experiences, educations, projects, certs, langs, customSections, profilePhoto, sectionOrder, sectionVisibility, design: { color: document.getElementById('colorPicker').value, font: document.getElementById('fontPicker').value, template: currentTemplate } }; }
    function loadResumeData(d) {
        if (d.personal) { ['name','title','email','phone','location','website','summary','skills'].forEach(f => document.getElementById('input' + f.charAt(0).toUpperCase() + f.slice(1)).value = d.personal[f] || ''); }
        experiences = d.experiences || []; educations = d.educations || []; projects = d.projects || []; certs = d.certs || []; langs = d.langs || []; customSections = d.customSections || [];
        if (d.profilePhoto) { profilePhoto = d.profilePhoto; document.getElementById('photoPreviewThumb').innerHTML = `<img src="${profilePhoto}" alt="Photo">`; document.getElementById('removePhotoBtn').style.display = 'inline-block'; } else { profilePhoto = null; document.getElementById('photoPreviewThumb').innerHTML = '<i class="fas fa-user"></i>'; document.getElementById('removePhotoBtn').style.display = 'none'; }
        if (d.sectionOrder) { sectionOrder = d.sectionOrder; }
        if (d.sectionVisibility) { sectionVisibility = d.sectionVisibility; }
        renderSectionOrderList();
        if (d.design) { document.getElementById('colorPicker').value = d.design.color || '#4f46e5'; document.getElementById('fontPicker').value = d.design.font || 'Inter, sans-serif'; if (d.design.template) { document.getElementById('templateSelect').value = d.design.template; setTemplate(d.design.template); } }
        renderExperienceForm(); renderEducationForm(); renderProjectForm(); renderCertForm(); renderLangForm(); renderCustomSectionsForm(); updatePreview(); updateTheme();
    }
    function saveResume() { const name = document.getElementById('saveResumeName').value.trim(); if (!name) return alert('Enter a name.'); const saved = JSON.parse(localStorage.getItem('savedResumes') || '{}'); saved[name] = { data: getResumeData(), savedAt: new Date().toISOString() }; localStorage.setItem('savedResumes', JSON.stringify(saved)); document.getElementById('saveResumeName').value = ''; renderSavedResumes(); alert('Saved!'); }
    function loadSavedResume(name) { const saved = JSON.parse(localStorage.getItem('savedResumes') || '{}'); if (saved[name]) { loadResumeData(saved[name].data); $('#saveModal').modal('hide'); } }
    function deleteSavedResume(name) { if (confirm('Delete "' + name + '"?')) { const saved = JSON.parse(localStorage.getItem('savedResumes') || '{}'); delete saved[name]; localStorage.setItem('savedResumes', JSON.stringify(saved)); renderSavedResumes(); } }
    function renderSavedResumes() { const saved = JSON.parse(localStorage.getItem('savedResumes') || '{}'); const names = Object.keys(saved); document.getElementById('savedResumesList').innerHTML = names.length === 0 ? '<div class="text-muted small">No saved resumes.</div>' : names.map(n => `<div class="saved-item"><span>${n}</span><div><button class="btn btn-sm btn-outline-primary" onclick="loadSavedResume('${n}')">Load</button> <button class="btn btn-sm btn-outline-danger" onclick="deleteSavedResume('${n}')"><i class="fas fa-trash"></i></button></div></div>`).join(''); }
    function exportJSON() { const blob = new Blob([JSON.stringify(getResumeData(), null, 2)], { type: 'application/json' }); const link = document.createElement('a'); link.href = URL.createObjectURL(blob); link.download = 'resume.json'; link.click(); }
    function importJSON(e) { const file = e.target.files[0]; if (!file) return; const reader = new FileReader(); reader.onload = function(ev) { try { loadResumeData(JSON.parse(ev.target.result)); $('#saveModal').modal('hide'); alert('Imported!'); } catch (err) { alert('Invalid file.'); } }; reader.readAsText(file); }

    // PDF Download
    function downloadPDF() {
        const el = document.getElementById('resumePreview');
        el.classList.add('pdf-export');
        html2pdf().set({
            margin: [10, 10, 10, 10],
            filename: 'resume.pdf',
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: { scale: 2, useCORS: true },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
        }).from(el).save().then(function() {
            el.classList.remove('pdf-export');
        });
    }

    function downloadCoverLetterPDF() {
        const el = document.getElementById('coverLetterPreview');
        html2pdf().set({ margin: 10, filename: 'cover-letter.pdf', image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2 }, jsPDF: { unit: 'mm', format: 'a4' } }).from(el).save();
    }

    // Word Export
    function downloadWord() {
        const el = document.getElementById('resumePreview');
        const content = el.innerHTML;
        const styles = `
            <style>
                body { font-family: Arial, sans-serif; max-width: 700px; margin: 0 auto; padding: 20px; }
                .resume-header { margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #4f46e5; }
                .resume-name { font-size: 24px; font-weight: bold; }
                .resume-title { font-size: 14px; color: #4f46e5; }
                .resume-contact { font-size: 11px; color: #666; margin-top: 5px; }
                .resume-contact-item { margin-right: 10px; }
                .resume-section { margin-bottom: 15px; }
                .resume-section-title { font-size: 14px; font-weight: bold; text-transform: uppercase; border-bottom: 1px solid #ddd; padding-bottom: 3px; margin-bottom: 8px; }
                .resume-item { margin-bottom: 10px; }
                .resume-item-title { font-weight: bold; font-size: 12px; }
                .resume-item-date { font-size: 11px; color: #666; float: right; }
                .resume-item-subtitle { font-size: 11px; color: #444; }
                .resume-item-desc { font-size: 11px; line-height: 1.4; }
                .resume-skill-tag { background: #eef2ff; padding: 2px 8px; border-radius: 10px; font-size: 10px; margin-right: 4px; display: inline-block; margin-bottom: 3px; }
                .resume-photo { width: 80px; height: 80px; border-radius: 50%; float: right; margin-left: 15px; }
            </style>
        `;
        const html = `
            <!DOCTYPE html>
            <html>
            <head><meta charset="utf-8"><title>Resume</title>${styles}</head>
            <body>${content}</body>
            </html>
        `;
        const blob = new Blob(['\ufeff', html], { type: 'application/msword' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'resume.doc';
        link.click();
        URL.revokeObjectURL(link.href);
    }
</script>

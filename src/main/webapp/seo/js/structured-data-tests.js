/**
 * Structured Data Validation Engine.
 *
 * Works in browser (as IIFE → window.StructuredDataTests) and Node (as CommonJS export).
 *
 * Presets are data-driven: each preset is an object with { name, tests[] }.
 * Tests are { prop, warning?, nested?, expect? }.
 * The engine matches schemas to presets and runs all checks.
 */
var StructuredDataTests;
(function () {
    'use strict';

    // ═══════════════════════════════════════
    // PRESETS — Google Rich Results, OG, Twitter, Meta
    // ═══════════════════════════════════════

    // Shorthand: r = required, w = warning (recommended)
    function r(prop, nested) { return { prop: prop, nested: nested }; }
    function w(prop, nested) { return { prop: prop, warning: true, nested: nested }; }

    var PRESETS = {

        // ── Google Rich Results ──

        Article: {
            name: 'Article',
            types: ['Article', 'NewsArticle', 'BlogPosting', 'TechArticle', 'ScholarlyArticle',
                    'SatiricalArticle', 'Report', 'AdvertiserContentArticle',
                    'SocialMediaPosting', 'LiveBlogPosting', 'DiscussionForumPosting'],
            // Google: NO required properties. All are recommended.
            tests: [
                w('headline'),
                w('author', [w('name'), w('url')]),
                w('datePublished'),
                w('dateModified'),
                w('image'),
                w('publisher', [w('name'), w('url')]),
                w('mainEntityOfPage'),
                w('description')
            ]
        },

        Product: {
            name: 'Product',
            types: ['Product'],
            // Google: name required + at least one of review/aggregateRating/offers
            tests: [
                r('name'),
                w('image'),
                w('description'),
                w('offers', [w('price'), w('priceCurrency'), w('availability'), w('priceValidUntil')]),
                w('aggregateRating', [w('ratingValue'), w('reviewCount')]),
                w('review'),
                w('sku'),
                w('brand')
            ]
        },

        FAQPage: {
            name: 'FAQPage',
            types: ['FAQPage'],
            // Google: mainEntity required
            tests: [
                r('mainEntity')
            ],
            custom: function (item, tests) {
                var entity = item.mainEntity;
                if (Array.isArray(entity)) {
                    tests.push(runTest('Questions count', entity.length + ' questions'));
                    entity.forEach(function (q, i) {
                        var p = 'Q' + (i + 1) + ': ';
                        tests.push(runTest(p + 'name', q.name));
                        tests.push(runTest(p + 'acceptedAnswer', q.acceptedAnswer));
                        if (q.acceptedAnswer && typeof q.acceptedAnswer === 'object') {
                            tests.push(runTest(p + 'acceptedAnswer.text', q.acceptedAnswer.text));
                        }
                    });
                }
            }
        },

        BreadcrumbList: {
            name: 'BreadcrumbList',
            types: ['BreadcrumbList'],
            // Google: itemListElement required with position, name, item
            tests: [
                r('itemListElement')
            ],
            custom: function (item, tests) {
                var items = item.itemListElement;
                if (Array.isArray(items)) {
                    tests.push(runTest('Breadcrumbs count', items.length >= 2 ? items.length + ' items' : null));
                    items.forEach(function (li, i) {
                        tests.push(runTest('Item ' + (i + 1) + ' position', li.position));
                        tests.push(runTest('Item ' + (i + 1) + ' name', li.name));
                        // item (URL) not required for the last breadcrumb
                        var isLast = (i === items.length - 1);
                        tests.push(runTest('Item ' + (i + 1) + ' item (URL)', li.item, isLast));
                    });
                }
            }
        },

        HowTo: {
            name: 'HowTo',
            types: ['HowTo'],
            // NOTE: Google DEPRECATED HowTo rich results (Sep 2023). No longer shown in search.
            // Keeping for schema.org compliance but marking as deprecated.
            deprecated: true,
            tests: [
                w('name'),
                w('step'),
                w('description'),
                w('image'),
                w('totalTime')
            ],
            custom: function (item, tests) {
                if (Array.isArray(item.step)) {
                    tests.push(runTest('Steps count', item.step.length + ' steps'));
                    item.step.forEach(function (s, i) {
                        tests.push(runTest('Step ' + (i + 1) + ' name', s.name, true));
                        tests.push(runTest('Step ' + (i + 1) + ' text', s.text, true));
                    });
                }
            }
        },

        // WebApplication/SoftwareApplication/MobileApplication handled by SoftwareApplication preset below

        LocalBusiness: {
            name: 'LocalBusiness',
            types: ['LocalBusiness', 'Restaurant', 'Store', 'MedicalBusiness',
                    'LegalService', 'FinancialService', 'FoodEstablishment'],
            // Google: name + address required
            tests: [
                r('name'),
                r('address'),
                w('geo', [w('latitude'), w('longitude')]),
                w('telephone'),
                w('image'),
                w('url'),
                w('openingHoursSpecification'),
                w('priceRange'),
                w('servesCuisine'),
                w('review'),
                w('aggregateRating')
            ]
        },

        Organization: {
            name: 'Organization',
            types: ['Organization', 'Corporation', 'EducationalOrganization',
                    'GovernmentOrganization', 'NGO'],
            tests: [
                r('name'),
                r('url'),
                w('logo'),
                w('sameAs'),
                w('contactPoint'),
                w('description')
            ]
        },

        WebSite: {
            name: 'WebSite',
            types: ['WebSite'],
            tests: [
                r('name'),
                r('url'),
                w('potentialAction'),
                w('description')
            ]
        },

        WebPage: {
            name: 'WebPage',
            types: ['WebPage', 'CollectionPage', 'ItemPage', 'AboutPage',
                    'ContactPage', 'SearchResultsPage', 'ProfilePage'],
            tests: [
                r('name'),
                w('description'),
                w('url'),
                w('inLanguage'),
                w('dateModified'),
                w('breadcrumb')
            ]
        },

        Event: {
            name: 'Event',
            types: ['Event', 'MusicEvent', 'SportsEvent', 'BusinessEvent'],
            // Google: name, startDate, location, location.address required
            tests: [
                r('name'),
                r('startDate'),
                r('location', [r('address'), w('name')]),
                w('endDate'),
                w('eventStatus'),
                w('description'),
                w('image'),
                w('offers'),
                w('performer'),
                w('organizer'),
                w('previousStartDate')
            ]
        },

        Recipe: {
            name: 'Recipe',
            types: ['Recipe'],
            // Google: name + image required
            tests: [
                r('name'),
                r('image'),
                w('recipeIngredient'),
                w('recipeInstructions'),
                w('description'),
                w('author'),
                w('datePublished'),
                w('prepTime'),
                w('cookTime'),
                w('totalTime'),
                w('recipeYield'),
                w('recipeCategory'),
                w('recipeCuisine'),
                w('nutrition', [w('calories')]),
                w('aggregateRating'),
                w('keywords'),
                w('video')
            ]
        },

        VideoObject: {
            name: 'VideoObject',
            types: ['VideoObject'],
            // Google: name, thumbnailUrl, uploadDate required
            tests: [
                r('name'),
                r('thumbnailUrl'),
                r('uploadDate'),
                w('description'),
                w('contentUrl'),
                w('duration'),
                w('embedUrl'),
                w('expires'),
                w('interactionStatistic')
            ]
        },

        JobPosting: {
            name: 'JobPosting',
            types: ['JobPosting'],
            // Google: datePosted, description, hiringOrganization, jobLocation, title required
            tests: [
                r('title'),
                r('description'),
                r('datePosted'),
                r('hiringOrganization', [w('name'), w('sameAs')]),
                r('jobLocation', [w('addressCountry')]),
                w('validThrough'),
                w('employmentType'),
                w('baseSalary'),
                w('applicantLocationRequirements'),
                w('directApply')
            ]
        },

        Course: {
            name: 'Course',
            types: ['Course'],
            // Google: name + description required
            tests: [
                r('name'),
                r('description'),
                w('provider', [w('name'), w('url')]),
                w('url'),
                w('courseCode'),
                w('hasCourseInstance')
            ]
        },

        LearningResource: {
            name: 'LearningResource',
            types: ['LearningResource'],
            tests: [
                r('name'),
                r('description'),
                w('url'),
                w('learningResourceType'),
                w('educationalLevel'),
                w('teaches')
            ]
        },

        ClaimReview: {
            name: 'ClaimReview',
            types: ['ClaimReview'],
            tests: [
                r('claimReviewed'),
                r('reviewRating', [r('ratingValue'), r('bestRating'), r('worstRating')]),
                r('author'),
                w('datePublished'),
                w('url'),
                w('itemReviewed')
            ]
        },

        // ── Additional Google Rich Results types ──

        SoftwareApplication: {
            name: 'SoftwareApplication',
            types: ['SoftwareApplication', 'MobileApplication', 'WebApplication'],
            // Google: name required + offers.price required + one of aggregateRating/review
            tests: [
                r('name'),
                r('offers', [r('price'), w('priceCurrency')]),
                w('aggregateRating', [w('ratingValue'), w('ratingCount')]),
                w('review'),
                w('applicationCategory'),
                w('operatingSystem')
            ]
        },

        Dataset: {
            name: 'Dataset',
            types: ['Dataset'],
            // Google: name + description required
            tests: [
                r('name'),
                r('description'),
                w('url'),
                w('identifier'),
                w('creator'),
                w('license'),
                w('keywords'),
                w('isAccessibleForFree'),
                w('temporalCoverage'),
                w('spatialCoverage'),
                w('version'),
                w('alternateName'),
                w('citation'),
                w('funder')
            ]
        },

        QAPage: {
            name: 'QAPage',
            types: ['QAPage'],
            // Google: mainEntity required
            tests: [
                r('mainEntity')
            ],
            custom: function (item, tests) {
                var q = item.mainEntity;
                if (q && typeof q === 'object' && !Array.isArray(q)) {
                    tests.push(runTest('Question name', q.name));
                    tests.push(runTest('Question answerCount', q.answerCount));
                    var hasAccepted = q.acceptedAnswer && (typeof q.acceptedAnswer === 'object');
                    var hasSuggested = q.suggestedAnswer;
                    tests.push(runTest('acceptedAnswer or suggestedAnswer', hasAccepted || hasSuggested ? 'present' : null));
                    if (hasAccepted) {
                        tests.push(runTest('acceptedAnswer.text', q.acceptedAnswer.text));
                    }
                    tests.push(runTest('Question author', q.author, true));
                    tests.push(runTest('Question datePublished', q.datePublished, true, 'datePublished'));
                    tests.push(runTest('Question upvoteCount', q.upvoteCount, true));
                }
            }
        },

        DiscussionForumPosting: {
            name: 'DiscussionForumPosting',
            types: ['DiscussionForumPosting'],
            // Google: author, author.name, datePublished, + one of text/image/video required
            tests: [
                r('author', [r('name'), w('url')]),
                r('datePublished'),
                w('headline'),
                w('text'),
                w('image'),
                w('video'),
                w('comment'),
                w('commentCount'),
                w('dateModified'),
                w('url'),
                w('interactionStatistic')
            ]
        },

        Review: {
            name: 'Review',
            types: ['Review'],
            // Google: author, itemReviewed, reviewRating.ratingValue required
            tests: [
                r('author', [w('name')]),
                r('reviewRating', [r('ratingValue'), w('bestRating'), w('worstRating')]),
                w('itemReviewed', [w('name')]),
                w('datePublished'),
                w('reviewBody')
            ]
        },

        AggregateRating: {
            name: 'AggregateRating',
            types: ['AggregateRating'],
            // Google: ratingValue required + ratingCount or reviewCount required
            tests: [
                r('ratingValue'),
                w('ratingCount'),
                w('reviewCount'),
                w('bestRating'),
                w('worstRating'),
                w('itemReviewed', [w('name')])
            ]
        },

        ProfilePage: {
            name: 'ProfilePage',
            types: ['ProfilePage'],
            // Google: mainEntity required with name
            tests: [
                r('mainEntity')
            ],
            custom: function (item, tests) {
                var entity = item.mainEntity;
                if (entity && typeof entity === 'object') {
                    tests.push(runTest('mainEntity.name', entity.name || entity.alternateName));
                    tests.push(runTest('mainEntity.alternateName', entity.alternateName, true));
                    tests.push(runTest('mainEntity.description', entity.description, true));
                    tests.push(runTest('mainEntity.image', entity.image, true));
                    tests.push(runTest('mainEntity.sameAs', entity.sameAs, true));
                    tests.push(runTest('mainEntity.interactionStatistic', entity.interactionStatistic, true));
                }
            }
        },

        VacationRental: {
            name: 'VacationRental',
            types: ['VacationRental', 'LodgingBusiness'],
            // Google: name, image, identifier, latitude, longitude, containsPlace.occupancy required
            tests: [
                r('name'),
                r('image'),
                r('identifier'),
                r('latitude'),
                r('longitude'),
                w('description'),
                w('address'),
                w('aggregateRating'),
                w('review'),
                w('checkinTime'),
                w('checkoutTime'),
                w('containsPlace')
            ]
        },

        EmployerAggregateRating: {
            name: 'EmployerAggregateRating',
            types: ['EmployerAggregateRating'],
            tests: [
                r('itemReviewed', [r('name')]),
                r('ratingValue'),
                r('ratingCount'),
                w('bestRating'),
                w('worstRating')
            ]
        },

        // ── Common non-Google-rich-result types people still search for ──

        Person: {
            name: 'Person',
            types: ['Person'],
            tests: [
                r('name'),
                w('url'),
                w('image'),
                w('jobTitle'),
                w('worksFor'),
                w('sameAs'),
                w('email'),
                w('telephone'),
                w('address')
            ]
        },

        Place: {
            name: 'Place',
            types: ['Place'],
            tests: [
                r('name'),
                w('address'),
                w('geo', [w('latitude'), w('longitude')]),
                w('url'),
                w('image'),
                w('telephone')
            ]
        },

        ImageObject: {
            name: 'ImageObject',
            types: ['ImageObject'],
            tests: [
                w('contentUrl'),
                w('url'),
                w('caption'),
                w('creator'),
                w('creditText'),
                w('copyrightNotice'),
                w('license'),
                w('acquireLicensePage')
            ]
        },

        Offer: {
            name: 'Offer',
            types: ['Offer'],
            tests: [
                r('price'),
                w('priceCurrency'),
                w('availability'),
                w('url'),
                w('priceValidUntil'),
                w('itemCondition'),
                w('seller')
            ]
        },

        MedicalWebPage: {
            name: 'MedicalWebPage',
            types: ['MedicalWebPage', 'MedicalCondition', 'Drug', 'MedicalProcedure'],
            tests: [
                r('name'),
                w('description'),
                w('url'),
                w('lastReviewed'),
                w('reviewedBy', [w('name')]),
                w('mainContentOfPage')
            ]
        },

        Book: {
            name: 'Book',
            types: ['Book'],
            tests: [
                r('name'),
                w('author', [w('name')]),
                w('url'),
                w('workExample', [w('isbn'), w('bookFormat')]),
                w('isbn'),
                w('datePublished'),
                w('image'),
                w('aggregateRating')
            ]
        },

        Movie: {
            name: 'Movie',
            types: ['Movie'],
            tests: [
                r('name'),
                w('image'),
                w('dateCreated'),
                w('director', [w('name')]),
                w('review'),
                w('aggregateRating'),
                w('url')
            ]
        }
    };

    // ── Meta tag presets ──

    var META_PRESETS = {

        OpenGraph: {
            name: 'Open Graph',
            icon: 'og',
            detect: function (m) { return Object.keys(m).some(function (k) { return k.indexOf('og:') === 0; }); },
            tests: [
                { key: 'og:title', label: 'og:title' },
                { key: 'og:type', label: 'og:type' },
                { key: 'og:url', label: 'og:url' },
                { key: 'og:image||og:image:src', label: 'og:image' },
                { key: 'og:description', label: 'og:description', warning: true },
                { key: 'og:site_name', label: 'og:site_name', warning: true },
                { key: 'og:locale', label: 'og:locale', warning: true },
                { key: 'og:image:alt', label: 'og:image:alt', warning: true }
            ]
        },

        TwitterCard: {
            name: 'Twitter Card',
            icon: 'twitter',
            detect: function (m) { return Object.keys(m).some(function (k) { return k.indexOf('twitter:') === 0; }); },
            tests: [
                { key: 'twitter:card', label: 'twitter:card' },
                { key: 'twitter:title', label: 'twitter:title' },
                { key: 'twitter:description', label: 'twitter:description' },
                { key: 'twitter:image||twitter:image:src', label: 'twitter:image' },
                { key: 'twitter:image:alt', label: 'twitter:image:alt', warning: true },
                { key: 'twitter:site', label: 'twitter:site', warning: true },
                { key: 'twitter:creator', label: 'twitter:creator', warning: true }
            ]
        },

        GeneralMeta: {
            name: 'Meta Tags',
            icon: 'meta',
            detect: function () { return true; }, // always run
            tests: [
                { key: 'description', label: 'description' },
                { key: 'viewport', label: 'viewport' },
                { key: 'robots', label: 'robots', warning: true },
                { key: 'author', label: 'author', warning: true },
                { key: 'title', label: 'title (meta)', warning: true }
            ]
        }
    };

    // ═══════════════════════════════════════
    // SCHEMA.ORG DATA (loaded async in browser, sync in Node)
    // ═══════════════════════════════════════

    var schemaData = null; // { allTypes[], v: {type→"prop,prop,..."}, p: {prop→1} }

    // Call before runAll() in browser — loads the schema JSON
    function loadSchemaData(basePath) {
        if (schemaData) return Promise.resolve();
        var url = (basePath || '') + '/seo/js/schema-org-data.json';
        return fetch(url).then(function (r) { return r.json(); }).then(function (d) {
            schemaData = d;
        }).catch(function () { schemaData = null; });
    }

    // Sync load for Node
    function loadSchemaDataSync(filePath) {
        if (schemaData) return;
        try {
            var fs = typeof require !== 'undefined' ? require('fs') : null;
            if (fs && filePath) {
                schemaData = JSON.parse(fs.readFileSync(filePath, 'utf8'));
            }
        } catch (e) { schemaData = null; }
    }

    function isKnownType(typeName) {
        if (!schemaData) return true; // no data = skip check
        return schemaData.allTypes.indexOf(typeName) !== -1;
    }

    function getValidProps(typeName) {
        if (!schemaData || !schemaData.v[typeName]) return null;
        return schemaData.v[typeName].split(',');
    }

    function isPendingProp(propName) {
        return schemaData && schemaData.p && schemaData.p[propName] === 1;
    }

    function getPropDescription(propName) {
        if (!schemaData || !schemaData.desc) return '';
        // Try exact match, then strip prefix (e.g. "offers.price" → "price")
        var d = schemaData.desc[propName];
        if (d) return d;
        var lastDot = propName.lastIndexOf('.');
        if (lastDot !== -1) return schemaData.desc[propName.substring(lastDot + 1)] || '';
        return '';
    }

    // ═══════════════════════════════════════
    // VALUE VALIDATORS
    // ═══════════════════════════════════════

    var VALUE_VALIDATORS = {
        datePublished: isISO8601,
        dateModified: isISO8601,
        dateCreated: isISO8601,
        startDate: isISO8601,
        endDate: isISO8601,
        uploadDate: isISO8601,
        datePosted: isISO8601,
        validThrough: isISO8601,
        url: isURL,
        'og:url': isURL,
        'og:image': isURL,
        'twitter:image': isURL,
        image: isURLOrObject,
        logo: isURLOrObject,
        thumbnailUrl: isURL,
        'twitter:card': function (v) { return /^(summary|summary_large_image|app|player)$/.test(v); },
        'og:type': function (v) { return /^(website|article|book|profile|music\.|video\.)/.test(v); }
    };

    function isISO8601(val) {
        if (typeof val !== 'string') return false;
        return /^\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}(:\d{2})?([+-]\d{2}:\d{2}|Z)?)?$/.test(val);
    }

    function isURL(val) {
        if (typeof val !== 'string') return false;
        return /^https?:\/\/.+/.test(val);
    }

    function isURLOrObject(val) {
        if (typeof val === 'object' && val !== null) return true;
        if (Array.isArray(val)) return true;
        return isURL(String(val));
    }

    // ═══════════════════════════════════════
    // HELPERS
    // ═══════════════════════════════════════

    function getTypes(item) {
        if (!item) return [];
        var t = item['@type'];
        if (!t) return [];
        return Array.isArray(t) ? t : [t];
    }

    function findByType(jsonld, types) {
        if (!jsonld || !jsonld.length) return [];
        return jsonld.filter(function (item) {
            return getTypes(item).some(function (t) {
                return types.indexOf(t) !== -1 || types.indexOf(t.replace(/^schema:/, '')) !== -1;
            });
        });
    }

    function isEmpty(val) {
        if (val === undefined || val === null || val === '') return true;
        if (Array.isArray(val) && val.length === 0) return true;
        return false;
    }

    function runTest(label, value, isWarning, propName) {
        var passed = !isEmpty(value);
        var valueError = null;

        // Validate value format if a validator exists
        if (passed && propName && VALUE_VALIDATORS[propName]) {
            var rawVal = (typeof value === 'object' && !Array.isArray(value)) ? value : value;
            var strVal = typeof rawVal === 'string' ? rawVal : null;
            if (strVal && !VALUE_VALIDATORS[propName](strVal)) {
                valueError = 'Invalid format';
                passed = false;
            }
        }

        // Look up schema.org description for the property
        var desc = propName ? getPropDescription(propName) : '';

        return {
            label: label + (valueError ? ' (' + valueError + ')' : ''),
            passed: passed,
            value: passed ? value : (valueError ? value : null),
            warning: !!isWarning,
            status: passed ? 'pass' : (isWarning ? 'warning' : 'fail'),
            description: desc
        };
    }

    // ═══════════════════════════════════════
    // ENGINE
    // ═══════════════════════════════════════

    // Run preset tests against an item
    function runPresetTests(item, presetTests, prefix) {
        var results = [];
        prefix = prefix || '';
        presetTests.forEach(function (t) {
            var label = prefix + t.prop;
            var val = item[t.prop];
            results.push(runTest(label, val, t.warning, t.prop));

            // Nested property checks
            if (t.nested && val && typeof val === 'object' && !Array.isArray(val)) {
                t.nested.forEach(function (nt) {
                    results.push(runTest(prefix + t.prop + '.' + nt.prop, val[nt.prop], nt.warning, nt.prop));
                });
            }
        });
        return results;
    }

    // Run meta tag preset
    function runMetaPreset(preset, metatags) {
        var tests = [];
        preset.tests.forEach(function (t) {
            // Support "key1||key2" OR syntax
            var keys = t.key.split('||');
            var val = null;
            for (var i = 0; i < keys.length; i++) {
                if (metatags[keys[i]] != null && metatags[keys[i]] !== '') {
                    val = metatags[keys[i]];
                    break;
                }
            }
            tests.push(runTest(t.label, val, t.warning, t.key.split('||')[0]));
        });
        return tests;
    }

    // ── Schema.org property validator ──
    // Checks each property on a JSON-LD item against the schema.org spec.
    // Returns tests for: invalid properties, pending (draft) properties.
    function validateSchemaProperties(item, prefix) {
        var results = [];
        if (!schemaData) return results; // no schema data loaded — skip

        var types = getTypes(item);
        if (types.length === 0) return results;

        // Collect valid properties across all declared types
        var validSet = {};
        var hasSpec = false;
        types.forEach(function (type) {
            var props = getValidProps(type);
            if (props) {
                hasSpec = true;
                props.forEach(function (p) { validSet[p] = true; });
            }
        });

        if (!hasSpec) return results; // type not in our data — skip

        // Always-valid JSON-LD keywords
        var jsonldKeywords = { '@context': 1, '@type': 1, '@id': 1, '@graph': 1, '@list': 1, '@value': 1, '@language': 1, '@reverse': 1 };

        Object.keys(item).forEach(function (k) {
            if (jsonldKeywords[k]) return;
            if (validSet[k]) {
                // Valid property — check if pending (draft)
                if (isPendingProp(k)) {
                    results.push({
                        label: prefix + k + ' (draft schema.org property)',
                        passed: true,
                        value: item[k],
                        warning: true,
                        status: 'warning'
                    });
                }
            } else {
                // Not a valid property for this type
                results.push({
                    label: prefix + '"' + k + '" is not a valid property of ' + types.join('/'),
                    passed: false,
                    value: item[k],
                    warning: true,
                    status: 'warning'
                });
            }
        });

        return results;
    }

    // ═══════════════════════════════════════
    // MAIN ENTRY
    // ═══════════════════════════════════════

    function runAll(data) {
        var jsonld = data.jsonld || [];
        var microdata = data.microdata || [];
        var rdfa = data.rdfa || [];
        var metatags = data.metatags || {};

        var groups = [];
        var matchedTypes = {};

        // ── JSON-LD: match presets ──
        Object.keys(PRESETS).forEach(function (key) {
            var preset = PRESETS[key];
            var items = findByType(jsonld, preset.types);
            if (items.length === 0) return;

            items.forEach(function (item) {
                getTypes(item).forEach(function (t) { matchedTypes[t] = true; });
            });

            var tests = [];

            // Flag deprecated Google rich results
            if (preset.deprecated) {
                tests.push({
                    label: preset.name + ' rich result is DEPRECATED by Google (Sep 2023) — no longer shown in search',
                    passed: true, value: 'deprecated', warning: true, status: 'warning'
                });
            }

            // Build a display name from the actual @types found
            var actualTypes = [];
            items.forEach(function (item) {
                getTypes(item).forEach(function (t) {
                    if (actualTypes.indexOf(t) === -1) actualTypes.push(t);
                });
            });
            var displayName = actualTypes.length === 1 ? actualTypes[0] : preset.name;
            if (preset.deprecated) displayName += ' (deprecated)';

            items.forEach(function (item, idx) {
                var itemType = getTypes(item).join(', ');
                var prefix = items.length > 1 ? itemType + ' #' + (idx + 1) + ': ' : '';
                tests.push(runTest(prefix + '@type', itemType));
                tests = tests.concat(runPresetTests(item, preset.tests, prefix));
                if (preset.custom) preset.custom(item, tests);

                // Schema.org property validation (if data loaded)
                tests = tests.concat(validateSchemaProperties(item, prefix));
            });

            groups.push({
                name: displayName,
                source: 'JSON-LD',
                tests: tests
            });
        });

        // ── JSON-LD: generic fallback for unmatched types ──
        jsonld.forEach(function (item) {
            getTypes(item).forEach(function (type) {
                if (matchedTypes[type]) return;
                matchedTypes[type] = true;

                // Check if @type is valid schema.org
                var typeValid = isKnownType(type);
                var tests = [];
                if (!typeValid) {
                    tests.push({ label: '@type "' + type + '" is not a known schema.org type',
                        passed: false, value: type, warning: true, status: 'warning' });
                } else {
                    tests.push(runTest('@type', type));
                }

                Object.keys(item).forEach(function (k) {
                    if (k === '@context' || k === '@type' || k === '@id') return;
                    tests.push(runTest(k, item[k], false, k));
                });

                // Schema.org property validation
                tests = tests.concat(validateSchemaProperties(item, ''));

                groups.push({ name: type, source: 'JSON-LD', tests: tests });
            });
        });

        // ── Microdata ──
        if (microdata.length > 0) {
            var mdTests = [];
            microdata.forEach(function (item, idx) {
                var typeName = (item.type || 'Unknown').replace(/^https?:\/\/schema\.org\//, '');
                var prefix = microdata.length > 1 ? typeName + ' #' + (idx + 1) + ': ' : typeName + ': ';
                mdTests.push(runTest(prefix + 'type', typeName));
                if (item.properties) {
                    Object.keys(item.properties).forEach(function (k) {
                        mdTests.push(runTest(prefix + k, item.properties[k]));
                    });
                }
            });
            groups.push({ name: 'Microdata', source: 'Microdata', tests: mdTests });
        }

        // ── RDFa ──
        if (rdfa.length > 0) {
            var rdfaTests = [];
            rdfa.forEach(function (item, idx) {
                var typeName = (item.type || 'Unknown').replace(/^schema:/, '');
                var prefix = rdfa.length > 1 ? typeName + ' #' + (idx + 1) + ': ' : typeName + ': ';
                rdfaTests.push(runTest(prefix + 'type', typeName));
                if (item.properties) {
                    Object.keys(item.properties).forEach(function (k) {
                        rdfaTests.push(runTest(prefix + k.replace(/^schema:/, ''), item.properties[k]));
                    });
                }
            });
            groups.push({ name: 'RDFa', source: 'RDFa', tests: rdfaTests });
        }

        // ── Meta tag presets ──
        Object.keys(META_PRESETS).forEach(function (key) {
            var preset = META_PRESETS[key];
            if (!preset.detect(metatags)) return;
            var tests = runMetaPreset(preset, metatags);
            // Skip if all tests have no value and it's the "always run" preset
            var hasAnyValue = tests.some(function (t) { return t.passed; });
            if (!hasAnyValue && key === 'GeneralMeta') return; // skip if page has zero meta tags
            groups.push({ name: preset.name, source: 'Meta Tags', tests: tests });
        });

        // ── Compute summary ──
        var passed = 0, failed = 0, warnings = 0, total = 0;
        groups.forEach(function (g) {
            g.passed = 0; g.failed = 0; g.warnings = 0;
            g.tests.forEach(function (t) {
                total++;
                if (t.status === 'pass') { passed++; g.passed++; }
                else if (t.status === 'warning') { warnings++; g.warnings++; }
                else { failed++; g.failed++; }
            });
            g.total = g.tests.length;
            g.pct = g.total > 0 ? Math.round(g.passed / g.total * 100) : 0;
        });

        return {
            groups: groups,
            detected: {
                jsonld: jsonld.length,
                microdata: microdata.length,
                rdfa: rdfa.length,
                metatags: Object.keys(metatags).length
            },
            summary: { passed: passed, failed: failed, warnings: warnings, total: total },
            presets: PRESETS,
            metaPresets: META_PRESETS
        };
    }

    // ── Export ──
    var api = { runAll: runAll, PRESETS: PRESETS, META_PRESETS: META_PRESETS };

    var api = {
        runAll: runAll,
        loadSchemaData: loadSchemaData,
        loadSchemaDataSync: loadSchemaDataSync,
        PRESETS: PRESETS,
        META_PRESETS: META_PRESETS
    };

    StructuredDataTests = api;

    if (typeof window !== 'undefined') {
        window.StructuredDataTests = api;
    }
})();

// Node / CommonJS
if (typeof module !== 'undefined' && module.exports) {
    module.exports = StructuredDataTests;
}

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Website Screenshot Tool</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="keywords" content="website screenshot, web page capture, responsive design testing, multi-device screenshots, viewport testing" />
    <meta name="description" content="Free online tool to capture website screenshots across multiple devices (desktop, tablet, mobile). Test responsive design and download high-quality screenshots." />
    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <%@ include file="header-script.jsp"%>

    <!-- JSON-LD Structured Data for SEO -->
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Website Screenshot Tool",
            "description": "Free online tool to capture website screenshots across multiple devices (desktop, tablet, mobile). Test responsive design and download high-quality screenshots.",
            "url": "https://8gwifi.org/screenshot.jsp",
            "applicationCategory": "NetworkTool",
            "operatingSystem": "Web Browser",
            "browserRequirements": "Requires JavaScript. Requires HTML5.",
            "featureList": [
                "Multi-device screenshots",
                "Responsive design testing",
                "Batch URL processing",
                "Viewport size selection",
                "Image download",
                "Social media sharing"
            ],
            "offers": {
                "@type": "Offer",
                "price": "0",
                "priceCurrency": "USD"
            },
            "author": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org"
            },
            "creator": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org"
            },
            "keywords": "website screenshot, web page capture, responsive design testing, multi-device screenshots, viewport testing, mobile desktop tablet screenshots",
            "about": {
                "@type": "Thing",
                "name": "Website Screenshot",
                "description": "Capture screenshots of websites across different devices and viewport sizes for responsive design testing and analysis."
            },
            "audience": {
                "@type": "Audience",
                "audienceType": "Web Developers, Designers, QA Testers, Digital Marketers, SEO Specialists"
            }
        }
    </script>

    <script type="text/javascript">
        $(document).ready(function() {
            // Viewport selection helper functions
            $('#selectAllViewports').click(function() {
                $('.viewport-checkbox').prop('checked', true);
            });

            $('#selectDesktop').click(function() {
                $('.viewport-checkbox').prop('checked', false);
                $('#viewport_1920x1080, #viewport_1366x768, #viewport_1440x900, #viewport_2560x1440, #viewport_1280x720, #viewport_1600x900, #viewport_1680x1050, #viewport_3840x2160').prop('checked', true);
            });

            $('#selectTablet').click(function() {
                $('.viewport-checkbox').prop('checked', false);
                $('#viewport_768x1024, #viewport_1024x768, #viewport_820x1180, #viewport_1024x1366, #viewport_800x1280, #viewport_1280x800').prop('checked', true);
            });

            $('#selectMobile').click(function() {
                $('.viewport-checkbox').prop('checked', false);
                $('#viewport_375x667, #viewport_414x896, #viewport_360x640, #viewport_390x844, #viewport_428x926, #viewport_393x851, #viewport_430x932, #viewport_412x915, #viewport_320x568').prop('checked', true);
            });

            $('#clearViewports').click(function() {
                $('.viewport-checkbox').prop('checked', false);
            });

            $('#screenshotForm').submit(function(event) {
                event.preventDefault();

                var urls = $('#urls').val().trim();
                if (!urls) {
                    alert('Please enter one or more URLs');
                    return;
                }

                // Get selected viewports
                var selectedViewports = [];
                $('.viewport-checkbox:checked').each(function() {
                    selectedViewports.push($(this).val());
                });

                if (selectedViewports.length === 0) {
                    alert('Please select at least one viewport size');
                    return;
                }

                $('#error').hide();
                $('#resultsCard').hide();
                $('#resultsBody').empty();
                $('#progressiveGallery').empty();
                $('#loading').show();
                $('#progressText').text('Starting captures...').show();

                // Parse URLs
                var urlList = urls.split('\n').map(function(url) {
                    return url.trim();
                }).filter(function(url) {
                    return url.length > 0;
                });

                // Add https:// if no protocol specified
                urlList = urlList.map(function(url) {
                    if (!url.match(/^https?:\/\//)) {
                        return 'https://' + url;
                    }
                    return url;
                });

                var totalRequests = urlList.length * selectedViewports.length;
                var completedRequests = 0;

                // Process each URL with each selected viewport
                var requestDelay = 0;
                urlList.forEach(function(url) {
                    selectedViewports.forEach(function(viewport) {
                        var viewportParts = viewport.split('x');
                        var width = viewportParts[0];
                        var height = viewportParts[1];

                        // Add delay between requests to ensure different viewport processing
                        setTimeout(function() {
                            console.log('Requesting screenshot for', url, 'with viewport', viewport, 'dimensions', width + 'x' + height);

                            // Get full page setting
                            var fullPage = $('#fullPage').is(':checked');

                            $.ajax({
                                type: 'POST',
                                url: 'ScreenshotFunctionality',
                                contentType: 'application/json',
                                data: JSON.stringify({
                                    url: url,
                                    width: parseInt(width),
                                    height: parseInt(height),
                                    viewport: viewport,
                                    viewportWidth: parseInt(width),
                                    viewportHeight: parseInt(height),
                                    viewport_size: viewport,
                                    device: viewport,
                                    viewport_string: width + 'x' + height,
                                    fullPage: fullPage,
                                    full_page: fullPage,
                                    capture_full_page: fullPage,
                                    request_id: url + '_' + viewport + '_' + Date.now()
                                }),
                                success: function(data) {
                                    completedRequests++;
                                    updateProgress(completedRequests, totalRequests);
                                    console.log('Screenshot response for', url, viewport, ':', data);
                                    displayProgressiveResult(url, viewport, data);
                                },
                                error: function(xhr) {
                                    completedRequests++;
                                    updateProgress(completedRequests, totalRequests);
                                    var errorMsg = 'Screenshot failed';
                                    if (xhr.responseJSON && xhr.responseJSON.error) {
                                        errorMsg = xhr.responseJSON.error;
                                    }
                                    displayProgressiveResult(url, viewport, { error: errorMsg });
                                }
                            });
                        }, requestDelay);

                        // Increment delay for next request
                        requestDelay += 1000; // 1 second delay between requests
                    });
                });
            });

            function updateProgress(completed, total) {
                var percentage = Math.round((completed / total) * 100);
                $('#progressText').text('Progress: ' + completed + '/' + total + ' (' + percentage + '%)');

                if (completed === total) {
                    $('#loading').hide();
                    $('#progressText').text('All screenshots completed!');
                    setTimeout(function() {
                        $('#progressText').hide();
                    }, 3000);
                }
            }

            function displayProgressiveResult(url, viewport, data) {
                // Check if this URL already has a row, if not create one
                var existingRow = $('#url-row-' + url.replace(/[^a-zA-Z0-9]/g, '_'));
                if (existingRow.length === 0) {
                    // Create new row for this URL
                    var rowHtml = '<div class="row mb-4" id="url-row-' + url.replace(/[^a-zA-Z0-9]/g, '_') + '">';
                    rowHtml += '<div class="col-12">';
                    rowHtml += '<h5 class="mb-3">' + url + '</h5>';
                    rowHtml += '<div class="row" id="viewport-cards-' + url.replace(/[^a-zA-Z0-9]/g, '_') + '">';
                    rowHtml += '</div></div></div>';
                    $('#progressiveGallery').append(rowHtml);
                }

                // Create card for this viewport
                var cardHtml = '<div class="col-md-6 col-lg-4 mb-3">';
                cardHtml += '<div class="card h-100">';
                cardHtml += '<div class="card-body p-2">';
                cardHtml += '<h6 class="card-title text-center mb-2"><small class="badge badge-primary">' + viewport + '</small></h6>';

                if (data.error) {
                    cardHtml += '<div class="alert alert-danger alert-sm">' + data.error + '</div>';
                } else if (data.result && data.result.screenshot_base64) {
                    // Handle the actual API response format: {success: true, result: {screenshot_base64: "..."}}
                    var escapedScreenshot = data.result.screenshot_base64.replace(/'/g, "\\'");
                    var escapedUrl = url.replace(/'/g, "\\'");
                    var escapedViewport = viewport.replace(/'/g, "\\'");

                    cardHtml += '<img src="data:image/png;base64,' + data.result.screenshot_base64 + '" class="img-fluid mb-2 screenshot-image" style="max-height: 600px; width: 100%; object-fit: contain; cursor: pointer;" data-screenshot="' + data.result.screenshot_base64 + '" data-url="' + url + '" data-viewport="' + viewport + '" title="Click to view full size">';
                    cardHtml += '<div class="text-center">';
                    cardHtml += '<button type="button" class="btn btn-sm btn-primary download-screenshot" data-screenshot="' + data.result.screenshot_base64 + '" data-url="' + url + '" data-viewport="' + viewport + '">Download</button>';
                    cardHtml += '</div>';
                } else if (data.screenshot) {
                    // Handle direct screenshot field
                    var escapedScreenshot = data.screenshot.replace(/'/g, "\\'");
                    var escapedUrl = url.replace(/'/g, "\\'");
                    var escapedViewport = viewport.replace(/'/g, "\\'");

                    cardHtml += '<img src="data:image/png;base64,' + data.screenshot + '" class="img-fluid mb-2 screenshot-image" style="max-height: 600px; width: 100%; object-fit: contain; cursor: pointer;" data-screenshot="' + data.screenshot + '" data-url="' + url + '" data-viewport="' + viewport + '" title="Click to view full size">';
                    cardHtml += '<div class="text-center">';
                    cardHtml += '<button type="button" class="btn btn-sm btn-primary download-screenshot" data-screenshot="' + data.screenshot + '" data-url="' + url + '" data-viewport="' + viewport + '">Download</button>';
                    cardHtml += '</div>';
                } else if (data.image) {
                    // Handle alternative field name
                    var escapedScreenshot = data.image.replace(/'/g, "\\'");
                    var escapedUrl = url.replace(/'/g, "\\'");
                    var escapedViewport = viewport.replace(/'/g, "\\'");

                    cardHtml += '<img src="data:image/png;base64,' + data.image + '" class="img-fluid mb-2 screenshot-image" style="max-height: 600px; width: 100%; object-fit: contain; cursor: pointer;" data-screenshot="' + data.image + '" data-url="' + url + '" data-viewport="' + viewport + '" title="Click to view full size">';
                    cardHtml += '<div class="text-center">';
                    cardHtml += '<button type="button" class="btn btn-sm btn-primary download-screenshot" data-screenshot="' + data.image + '" data-url="' + url + '" data-viewport="' + viewport + '">Download</button>';
                    cardHtml += '</div>';
                } else if (data.data) {
                    // Handle nested data structure
                    var screenshotData = data.data.screenshot || data.data.image;
                    if (screenshotData) {
                        var escapedScreenshot = screenshotData.replace(/'/g, "\\'");
                        var escapedUrl = url.replace(/'/g, "\\'");
                        var escapedViewport = viewport.replace(/'/g, "\\'");

                        cardHtml += '<img src="data:image/png;base64,' + screenshotData + '" class="img-fluid mb-2 screenshot-image" style="max-height: 600px; width: 100%; object-fit: contain; cursor: pointer;" data-screenshot="' + screenshotData + '" data-url="' + url + '" data-viewport="' + viewport + '" title="Click to view full size">';
                        cardHtml += '<div class="text-center">';
                        cardHtml += '<button type="button" class="btn btn-sm btn-primary download-screenshot" data-screenshot="' + screenshotData + '" data-url="' + url + '" data-viewport="' + viewport + '">Download</button>';
                        cardHtml += '</div>';
                    } else {
                        cardHtml += '<div class="alert alert-warning alert-sm">No screenshot data found</div>';
                    }
                } else {
                    cardHtml += '<div class="alert alert-warning alert-sm">No screenshot data received</div>';
                }

                cardHtml += '</div></div></div>';

                // Append to the viewport cards container for this URL
                $('#viewport-cards-' + url.replace(/[^a-zA-Z0-9]/g, '_')).append(cardHtml);
            }

            // Event delegation for screenshot image clicks
            $(document).on('click', '.screenshot-image', function() {
                var screenshot = $(this).data('screenshot');
                var url = $(this).data('url');
                var viewport = $(this).data('viewport');
                openScreenshotModal(screenshot, url, viewport);
            });

            // Event delegation for download button clicks
            $(document).on('click', '.download-screenshot', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var screenshot = $(this).data('screenshot');
                var url = $(this).data('url');
                var viewport = $(this).data('viewport');
                downloadScreenshot(screenshot, url, viewport);
            });
        });

        // Global functions for download and modal
        function downloadScreenshot(base64Data, url, viewport) {
            var link = document.createElement('a');
            link.href = 'data:image/png;base64,' + base64Data;
            var filename = url.replace(/[^a-zA-Z0-9]/g, '_') + '_' + viewport + '.png';
            link.download = filename;
            link.click();
        }

        function openScreenshotModal(base64Data, url, viewport) {
            $('#screenshotModal .modal-title').text(url + ' - ' + viewport);
            $('#screenshotModal .modal-body img').attr('src', 'data:image/png;base64,' + base64Data);
            $('#screenshotModal').modal('show');
        }
    </script>
    <style>
      /* Scoped layout tweaks for screenshot tool */
      .viewport-panel .card-body { max-height: 60vh; overflow-y: auto; }
      .viewport-panel .form-check { margin-bottom: .2rem; }
      .viewport-panel h5.card-header { padding: .5rem .75rem; font-size: 1rem; }
      .viewport-panel h6 { margin: .35rem 0 .25rem; font-size: .9rem; text-transform: uppercase; letter-spacing: .3px; color: #495057; }
      .viewport-panel .form-check-label { font-size: .85rem; line-height: 1.2; }
      .viewport-panel .form-check-input { margin-top: .2rem; }
      .viewport-panel .checkbox-grid { display: grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap: .2rem .5rem; }
      .viewport-panel .checkbox-grid .form-check { margin-bottom: .15rem; }
      @media (max-width: 992px) {
        .viewport-panel .card-body { max-height: none; }
      }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<!-- Compact Network Tools Navigation Bar -->
<%@ include file="network-tools-navbar.jsp"%>

<h1 class="mt-4">Website Screenshot Tool</h1>
<hr>

<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="" />Loading!
</div>

<form id="screenshotForm" class="form-horizontal" method="POST">
  <div class="row">
    <!-- Left panel: Viewport sizes -->
    <div class="col-lg-4 order-lg-1 order-2 viewport-panel">
      <div class="card mb-3">
        <h5 class="card-header">Viewport Sizes</h5>
        <div class="card-body">
          <div class="row">
            <div class="col-12">
              <h6>Desktop</h6>
              <div class="checkbox-grid">
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1920x1080" value="1920x1080">
                    <label class="form-check-label" for="viewport_1920x1080">1920x1080 (Full HD)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1366x768" value="1366x768" checked>
                    <label class="form-check-label" for="viewport_1366x768">1366x768 (Common laptop)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1440x900" value="1440x900">
                    <label class="form-check-label" for="viewport_1440x900">1440x900 (MacBook Air)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_2560x1440" value="2560x1440">
                    <label class="form-check-label" for="viewport_2560x1440">2560x1440 (2K monitor)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1280x720" value="1280x720">
                    <label class="form-check-label" for="viewport_1280x720">1280x720 (HD)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1600x900" value="1600x900">
                    <label class="form-check-label" for="viewport_1600x900">1600x900 (Wide laptop)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1680x1050" value="1680x1050">
                    <label class="form-check-label" for="viewport_1680x1050">1680x1050 (MacBook Pro)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_3840x2160" value="3840x2160">
                    <label class="form-check-label" for="viewport_3840x2160">3840x2160 (4K UHD)</label>
                </div>
              </div>
            </div>
            <div class="col-12 mt-2">
              <h6>Tablet</h6>
              <div class="checkbox-grid">
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_768x1024" value="768x1024">
                    <label class="form-check-label" for="viewport_768x1024">768x1024 (iPad portrait)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1024x768" value="1024x768">
                    <label class="form-check-label" for="viewport_1024x768">1024x768 (iPad landscape)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_820x1180" value="820x1180">
                    <label class="form-check-label" for="viewport_820x1180">820x1180 (iPad Pro 11")</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1024x1366" value="1024x1366">
                    <label class="form-check-label" for="viewport_1024x1366">1024x1366 (iPad Pro 12.9")</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_800x1280" value="800x1280">
                    <label class="form-check-label" for="viewport_800x1280">800x1280 (Android tablet)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_1280x800" value="1280x800">
                    <label class="form-check-label" for="viewport_1280x800">1280x800 (Android landscape)</label>
                </div>
              </div>
            </div>
            <div class="col-12 mt-2">
              <h6>Mobile</h6>
              <div class="checkbox-grid">
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_375x667" value="375x667">
                    <label class="form-check-label" for="viewport_375x667">375x667 (iPhone SE)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_414x896" value="414x896">
                    <label class="form-check-label" for="viewport_414x896">414x896 (iPhone 11 Pro Max)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_360x640" value="360x640">
                    <label class="form-check-label" for="viewport_360x640">360x640 (Android common)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_390x844" value="390x844">
                    <label class="form-check-label" for="viewport_390x844">390x844 (iPhone 12/13/14)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_428x926" value="428x926">
                    <label class="form-check-label" for="viewport_428x926">428x926 (iPhone 12/13/14 Pro Max)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_393x851" value="393x851">
                    <label class="form-check-label" for="viewport_393x851">393x851 (iPhone 15/Plus)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_430x932" value="430x932">
                    <label class="form-check-label" for="viewport_430x932">430x932 (iPhone 15 Pro Max)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_412x915" value="412x915">
                    <label class="form-check-label" for="viewport_412x915">412x915 (Samsung Galaxy S21)</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input viewport-checkbox" type="checkbox" id="viewport_320x568" value="320x568">
                    <label class="form-check-label" for="viewport_320x568">320x568 (iPhone 5/SE 1st gen)</label>
                </div>
              </div>
            </div>
          </div>
          <small class="form-text text-muted">Select one or more viewport sizes. Each URL will be captured in all selected sizes.</small>
          <div class="mt-2">
            <div class="btn-group" role="group">
              <button type="button" class="btn btn-sm btn-outline-primary" id="selectAllViewports">Select All</button>
              <button type="button" class="btn btn-sm btn-outline-info" id="selectDesktop">Desktop Only</button>
              <button type="button" class="btn btn-sm btn-outline-warning" id="selectTablet">Tablet Only</button>
              <button type="button" class="btn btn-sm btn-outline-success" id="selectMobile">Mobile Only</button>
              <button type="button" class="btn btn-sm btn-outline-secondary" id="clearViewports">Clear All</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right panel: URL input and options -->
    <div class="col-lg-8 order-lg-2 order-1">
      <div class="form-group">
        <label for="urls"><strong>URL(s):</strong></label>
        <textarea class="form-control" id="urls" name="urls" rows="3" placeholder="Enter single URL or multiple URLs (one per line), e.g. google.com or google.com&#10;github.com&#10;stackoverflow.com" required></textarea>
        <small class="form-text text-muted">Supports single or multiple URLs. Protocol (https://) will be added automatically if missing.</small>
      </div>

      <div class="form-group">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" id="fullPage" value="true">
          <label class="form-check-label" for="fullPage">
            <strong>Capture Full Page</strong> - Capture the entire webpage (not just visible area)
          </label>
        </div>
        <small class="form-text text-muted">When enabled, captures the full length of the webpage instead of just the visible viewport.</small>
      </div>

      <button type="submit" class="btn btn-primary">Capture Screenshots</button>

      <!-- Results inline under the button -->
      <div id="error" class="alert alert-danger mt-3" style="display:none;"></div>

      <div id="progressText" class="alert alert-info mt-2" style="display:none;"></div>

      <div id="progressiveGallery" class="mt-3"></div>

      <div class="card mt-3" id="resultsCard" style="display:none;">
        <div class="card-header">
            <h6 class="mb-0">Results</h6>
        </div>
        <div class="card-body">
            <div id="resultsBody"></div>
        </div>
      </div>
    </div>
  </div>
</form>

    

<hr>

<!-- Screenshot Modal -->
<div class="modal fade" id="screenshotModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Screenshot</h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body text-center">
                <img src="" class="img-fluid" alt="Screenshot">
            </div>
        </div>
    </div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4">About Website Screenshots</h2>
<p>This tool captures screenshots of websites across different devices and viewport sizes. It's useful for testing responsive design, checking how your site appears on different devices, and creating visual documentation.</p>

<h3>How to Use</h3>
<p>Simply enter one or more URLs and select viewport sizes:</p>
<ul>
    <li><strong>URLs:</strong> Enter one or more URLs (one per line) in the text area</li>
    <li><strong>Multi-Viewport Selection:</strong> Choose one or more viewport sizes from Desktop, Tablet, and Mobile options</li>
    <li><strong>Batch Processing:</strong> Each URL will be captured in all selected viewport sizes</li>
    <li><strong>Quick Selection:</strong> Use "Select All", "Desktop Only", "Tablet Only", "Mobile Only", or "Clear All" buttons</li>
    <li><strong>Protocol Auto-detection:</strong> URLs without http:// or https:// will automatically get https:// added</li>
</ul>

<h3>Multi-Viewport Workflow</h3>
<p>When you select multiple viewport sizes, the tool will:</p>
<ol>
    <li>Process each URL with each selected viewport size</li>
    <li>Display results as they become available (progressive loading)</li>
    <li>Show progress counter for real-time feedback</li>
    <li>Allow individual download of each screenshot</li>
    <li>Show comprehensive summary of all captures</li>
</ol>

<h3>Supported Viewport Sizes</h3>
<div class="row">
    <div class="col-md-4">
        <h5>Desktop</h5>
        <ul>
            <li>1920x1080 (Full HD)</li>
            <li>1366x768 (Common laptop)</li>
            <li>1440x900 (MacBook Air)</li>
            <li>2560x1440 (2K monitor)</li>
            <li>1280x720 (HD)</li>
            <li>1600x900 (Wide laptop)</li>
            <li>1680x1050 (MacBook Pro)</li>
            <li>3840x2160 (4K UHD)</li>
        </ul>
    </div>
    <div class="col-md-4">
        <h5>Tablet</h5>
        <ul>
            <li>768x1024 (iPad portrait)</li>
            <li>1024x768 (iPad landscape)</li>
            <li>820x1180 (iPad Pro 11")</li>
            <li>1024x1366 (iPad Pro 12.9")</li>
            <li>800x1280 (Android tablet)</li>
            <li>1280x800 (Android landscape)</li>
        </ul>
    </div>
    <div class="col-md-4">
        <h5>Mobile</h5>
        <ul>
            <li>375x667 (iPhone SE)</li>
            <li>414x896 (iPhone 11 Pro Max)</li>
            <li>360x640 (Android common)</li>
            <li>390x844 (iPhone 12/13/14)</li>
            <li>428x926 (iPhone 12/13/14 Pro Max)</li>
            <li>393x851 (iPhone 15/Plus)</li>
            <li>430x932 (iPhone 15 Pro Max)</li>
            <li>412x915 (Samsung Galaxy S21)</li>
            <li>320x568 (iPhone 5/SE 1st gen)</li>
        </ul>
    </div>
</div>

<h3>Features</h3>
<ul>
    <li><strong>Unified Interface:</strong> One form handles both single and multiple URL screenshots</li>
    <li><strong>Multi-Viewport Support:</strong> Capture the same URL in multiple device sizes</li>
    <li><strong>Progressive Display:</strong> Results appear as they're captured, not all at once</li>
    <li><strong>Download Support:</strong> Download individual screenshots with descriptive filenames</li>
    <li><strong>Modal Viewing:</strong> Click screenshots to view them in full size</li>
    <li><strong>Error Handling:</strong> Graceful handling of failed captures with error messages</li>
    <li><strong>Progress Tracking:</strong> Real-time progress counter for batch operations</li>
</ul>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>

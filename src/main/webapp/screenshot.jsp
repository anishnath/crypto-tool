<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Free Multi-Device Website Screenshot Tool | Capture & Share Responsive Web Pages</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="website screenshot tool, responsive design testing, multi-device screenshots, web page capture, mobile desktop tablet screenshots, social media sharing, viewport testing, responsive design checker, website preview tool, cross-device testing, free screenshot tool" />
	<meta name="description" content="Free online tool to capture website screenshots across multiple devices (desktop, tablet, mobile). Test responsive design, share on social media, and download high-quality screenshots instantly. No registration required!" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>
	
	<!-- Font Awesome for social media icons -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
	
	<!-- JSON-LD Structured Data for SEO -->
	<script type="application/ld+json">
	{
		"@context": "https://schema.org",
		"@type": "WebApplication",
		"name": "Free Multi-Device Website Screenshot Tool",
		"description": "Free online tool to capture website screenshots across multiple devices (desktop, tablet, mobile). Test responsive design, share on social media, and download high-quality screenshots instantly. No registration required!",
		"url": "https://8gwifi.org/screenshot.jsp",
		"applicationCategory": "WebTool",
		"operatingSystem": "Web Browser",
		"browserRequirements": "Requires JavaScript. Requires HTML5.",
		"featureList": [
			"Multi-device screenshot capture",
			"9 different viewport sizes",
			"Progressive results display",
			"Social media sharing integration",
			"Batch screenshot processing",
			"Full page screenshots",
			"Responsive design testing",
			"Instant download functionality",
			"Cross-platform compatibility",
			"Free to use - no registration"
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
		"keywords": "website screenshot tool, responsive design testing, multi-device screenshots, web page capture, mobile desktop tablet screenshots, social media sharing, viewport testing, responsive design checker, website preview tool, cross-device testing, free screenshot tool",
		"about": {
			"@type": "Thing",
			"name": "Multi-Device Website Screenshot Capture",
			"description": "Free online tool for capturing website screenshots across multiple devices and viewport sizes. Perfect for responsive design testing, social media sharing, documentation, and cross-device analysis."
		},
		"audience": {
			"@type": "Audience",
			"audienceType": "Web Developers, UI/UX Designers, QA Testers, Digital Marketers, Content Creators, Social Media Managers, Product Managers, Frontend Developers"
		}
	}
	</script>

	<style>
		/* Main page styling */
		body {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			min-height: 100vh;
		}
		
		/* Header styling overrides */
		.navbar {
			background: transparent !important;
			box-shadow: none !important;
		}
		
		.navbar .container {
			background: rgba(255, 255, 255, 0.95);
			border-radius: 15px;
			padding: 15px 20px;
			margin-top: 10px;
			box-shadow: 0 10px 30px rgba(0,0,0,0.1);
		}
		
		.navbar-brand {
			color: #333 !important;
			font-weight: 600;
		}
		
		.navbar-nav .nav-link {
			color: #495057 !important;
			font-weight: 500;
		}
		
		.navbar-nav .nav-link:hover {
			color: #667eea !important;
		}
		
		/* Twitter follow button styling */
		.twitter-follow-button {
			margin-left: 10px;
		}
		
		/* Remove dark navbar background */
		.navbar-dark {
			background-color: transparent !important;
		}
		
		/* Make navbar content more integrated */
		.navbar .navbar-brand img {
			filter: none;
		}
		
		/* Ensure proper spacing */
		body {
			padding-top: 0 !important;
		}
		
		/* Main container spacing */
		.container {
			margin-top: 30px;
		}
		
		/* Enhanced navbar styling */
		.navbar .container {
			backdrop-filter: blur(10px);
			border: 1px solid rgba(255, 255, 255, 0.2);
		}
		
		.navbar-brand {
			display: flex;
			align-items: center;
			gap: 10px;
		}
		
		.navbar-brand img {
			width: 30px;
			height: 30px;
		}
		
		/* Navigation links styling */
		.navbar-nav {
			gap: 20px;
		}
		
		.navbar-nav .nav-item {
			position: relative;
		}
		
		.navbar-nav .nav-item::after {
			content: '';
			position: absolute;
			bottom: -5px;
			left: 50%;
			width: 0;
			height: 2px;
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			transition: all 0.3s ease;
			transform: translateX(-50%);
		}
		
		.navbar-nav .nav-item:hover::after {
			width: 100%;
		}
		
		.container {
			background: rgba(255, 255, 255, 0.95);
			border-radius: 20px;
			box-shadow: 0 20px 40px rgba(0,0,0,0.1);
			margin-top: 20px;
			margin-bottom: 20px;
			padding: 30px;
		}
		
		/* Header styling */
		h1 {
			background: linear-gradient(45deg, #667eea, #764ba2);
			-webkit-background-clip: text;
			-webkit-text-fill-color: transparent;
			background-clip: text;
			font-weight: 700;
			text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
		}
		
		.lead {
			color: #6c757d;
			font-size: 1.2rem;
			font-weight: 400;
		}
		
		/* Card styling */
		.card {
			border: none;
			border-radius: 15px;
			box-shadow: 0 10px 30px rgba(0,0,0,0.1);
			overflow: hidden;
			transition: transform 0.3s ease, box-shadow 0.3s ease;
		}
		
		.card:hover {
			transform: translateY(-5px);
			box-shadow: 0 20px 40px rgba(0,0,0,0.15);
		}
		
		.card-header {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			color: white;
			border: none;
			padding: 20px;
		}
		
		.card-header h5 {
			margin: 0;
			font-weight: 600;
			font-size: 1.3rem;
		}
		
		.card-body {
			padding: 25px;
		}
		
		/* Form styling */
		.form-control {
			border-radius: 10px;
			border: 2px solid #e9ecef;
			padding: 12px 15px;
			transition: all 0.3s ease;
		}
		
		.form-control:focus {
			border-color: #667eea;
			box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
		}
		
		/* Button styling */
		.btn {
			border-radius: 10px;
			padding: 12px 25px;
			font-weight: 600;
			text-transform: uppercase;
			letter-spacing: 0.5px;
			transition: all 0.3s ease;
		}
		
		.btn-primary {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			border: none;
			box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
		}
		
		.btn-primary:hover {
			transform: translateY(-2px);
			box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
		}
		
		.btn-success {
			background: linear-gradient(135deg, #56ab2f 0%, #a8e6cf 100%);
			border: none;
		}
		
		.btn-outline-primary {
			border: 2px solid #667eea;
			color: #667eea;
		}
		
		.btn-outline-primary:hover {
			background: #667eea;
			transform: translateY(-2px);
		}
		
		/* Viewport selection styling */
		.viewport-category {
			margin-bottom: 15px;
		}
		
		.viewport-category h6 {
			color: #667eea;
			font-weight: 700;
			margin-bottom: 8px;
			display: flex;
			align-items: center;
			gap: 8px;
		}
		
		.viewport-category h6 i {
			font-size: 1.2rem;
		}
		
		.category-border {
			height: 3px;
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			border-radius: 2px;
			margin-bottom: 10px;
		}
		
		.form-check {
			padding: 8px 0;
			background: rgba(102, 126, 234, 0.05);
			border-radius: 8px;
			margin: 5px 0;
			padding: 10px 15px;
			transition: all 0.3s ease;
		}
		
		.form-check:hover {
			background: rgba(102, 126, 234, 0.1);
			transform: translateX(5px);
		}
		
		.form-check-input {
			width: 20px;
			height: 20px;
			margin-top: 0.25rem;
		}
		
		.form-check-input:checked {
			background-color: #667eea;
			border-color: #667eea;
		}
		
		.form-check-label {
			font-weight: 500;
			color: #495057;
			cursor: pointer;
		}
		
		/* Screenshot gallery styling */
		.screenshot-gallery img {
			transition: all 0.3s ease;
			border-radius: 10px;
		}
		
		.screenshot-gallery img:hover {
			transform: scale(1.05);
			box-shadow: 0 10px 30px rgba(0,0,0,0.3);
		}
		
		.screenshot-preview {
			max-height: 500px;
			overflow-y: auto;
		}
		
		.modal-body img {
			max-height: 70vh;
			border-radius: 10px;
		}
		
		/* Badge styling */
		.badge {
			font-size: 0.8rem;
			padding: 6px 12px;
			border-radius: 20px;
		}
		
		.badge-info {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		}
		
		/* Alert styling */
		.alert {
			border: none;
			border-radius: 10px;
			padding: 15px 20px;
		}
		
		.alert-info {
			background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
			color: #0c5460;
		}
		
		.alert-success {
			background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
			color: #155724;
		}
		
		/* Loading animation */
		#loading {
			text-align: center;
			padding: 40px;
			color: #667eea;
			font-weight: 600;
		}
		
		/* Social sharing buttons */
		.btn-group .btn {
			border-radius: 8px;
			margin: 2px;
		}
		
		/* Enhanced button styling */
		.btn-lg {
			padding: 15px 40px;
			font-size: 1.1rem;
			box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
		}
		
		.btn-lg:hover {
			transform: translateY(-3px);
			box-shadow: 0 10px 30px rgba(102, 126, 234, 0.6);
		}
		
		/* Loading spinner enhancement */
		#loading img {
			animation: spin 1s linear infinite;
		}
		
		@keyframes spin {
			0% { transform: rotate(0deg); }
			100% { transform: rotate(360deg); }
		}
		
		/* Card hover effects for gallery */
		.screenshot-gallery .card {
			transition: all 0.3s ease;
		}
		
		.screenshot-gallery .card:hover {
			transform: translateY(-8px);
			box-shadow: 0 15px 35px rgba(0,0,0,0.2);
		}
		
		/* Progress indicator styling */
		#progressText {
			font-weight: 600;
			color: #667eea;
		}
		
		/* Enhanced form labels */
		label strong {
			color: #495057;
			font-size: 1.1rem;
		}
		
		/* Textarea styling */
		textarea.form-control {
			resize: vertical;
			min-height: 120px;
		}
		
		/* Placeholder styling */
		::placeholder {
			color: #adb5bd;
			font-style: italic;
		}
		
		/* Responsive design */
		@media (max-width: 768px) {
			.container {
				margin: 10px;
				padding: 20px;
				border-radius: 15px;
			}
			
			h1 {
				font-size: 2rem;
			}
			
			.lead {
				font-size: 1rem;
			}
		}
		
		/* Custom scrollbar */
		::-webkit-scrollbar {
			width: 8px;
		}
		
		::-webkit-scrollbar-track {
			background: #f1f1f1;
			border-radius: 10px;
		}
		
		::-webkit-scrollbar-thumb {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			border-radius: 10px;
		}
		
		::-webkit-scrollbar-thumb:hover {
			background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
		}
	</style>

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
				$('#loading').show();

				var urlList = urls.split('\n').filter(function(url) {
					return url.trim().length > 0;
				});

				// Add protocol if missing
				urlList = urlList.map(function(url) {
					if (!url.match(/^https?:\/\//)) {
						return 'https://' + url;
					}
					return url;
				});

				// Create requests for each viewport
				var completedRequests = 0;
				var totalRequests = urlList.length * selectedViewports.length;
				var allResults = [];
				var isFirstResult = true;

				// Show results card immediately
				$('#resultsCard').show();
				$('#queryCount').text('0');
				$('#screenshotDisplay').html('<div><h5>Multi-Viewport Screenshot Gallery</h5><p class="text-muted">Capturing screenshots... Please wait for all to complete.</p><div class="row screenshot-gallery" id="progressiveGallery"></div></div>');
				$('#summaryInfo').html('<div class="alert alert-info"><strong>Progress:</strong> <span id="progressText">0 / ' + totalRequests + ' completed</span></div>');

				// Process each URL with each viewport
				urlList.forEach(function(url) {
					selectedViewports.forEach(function(viewport) {
						var requestData = {
							url: url,
							viewport: viewport,
							full_page: $('#fullPage').is(':checked')
						};

						$.ajax({
							type: 'POST',
							url: 'ScreenshotFunctionality',
							data: JSON.stringify(requestData),
							contentType: 'application/json',
							dataType: 'json',
							success: function(data) {
								if (data && data.success && data.result) {
									var result = {
										url: data.result.url,
										viewport: viewport,
										status_code: data.result.status_code,
										title: data.result.title,
										response_time_ms: data.result.response_time_ms,
										content_length: data.result.content_length,
										content_type: data.result.content_type,
										screenshot_base64: data.result.screenshot_base64
									};
									allResults.push(result);
									
									// Display result immediately
									displayProgressiveResult(result);
								}
								completedRequests++;
								updateProgress();
								
								if (completedRequests === totalRequests) {
									$('#loading').hide();
									updateFinalSummary(allResults, urlList, selectedViewports);
								}
							},
							error: function(xhr) {
								completedRequests++;
								updateProgress();
								
								if (completedRequests === totalRequests) {
									$('#loading').hide();
									if (allResults.length > 0) {
										updateFinalSummary(allResults, urlList, selectedViewports);
									} else {
										var msg = 'Screenshot capture failed. Please try again.';
										if (xhr.responseJSON && xhr.responseJSON.error) {
											msg = xhr.responseJSON.error;
										}
										$('#error').text(msg).show();
									}
								}
							}
						});
					});
				});

				// Function to display individual results as they come in
				function displayProgressiveResult(result) {
					var screenshotData = result.screenshot_base64 || '';
					var downloadBtn = '';
					
					if (screenshotData) {
						downloadBtn = '<button class="btn btn-sm btn-success" onclick="downloadScreenshot(\'' + screenshotData + '\', \'' + (result.url || 'screenshot') + '_' + result.viewport + '\')"><i class="fas fa-download"></i> Download</button>';
						
						var shareButtons = '<div class="btn-group btn-group-sm mt-1" role="group">' +
							'<button class="btn btn-outline-primary" onclick="shareToTwitter(\'' + screenshotData + '\', \'' + (result.url || '') + '\', \'' + result.viewport + '\')" title="Share on Twitter"><i class="fab fa-twitter"></i></button>' +
							'<button class="btn btn-outline-success" onclick="shareToLinkedIn(\'' + screenshotData + '\', \'' + (result.url || '') + '\', \'' + result.viewport + '\')" title="Share on LinkedIn"><i class="fab fa-linkedin"></i></button>' +
							'<button class="btn btn-outline-info" onclick="shareToFacebook(\'' + screenshotData + '\', \'' + (result.url || '') + '\', \'' + result.viewport + '\')" title="Share on Facebook"><i class="fab fa-facebook"></i></button>' +
							'<button class="btn btn-outline-secondary" onclick="copyImageLink(\'' + screenshotData + '\', \'' + (result.url || '') + '\', \'' + result.viewport + '\')" title="Copy Image Link"><i class="fas fa-link"></i></button>' +
						'</div>';
						
						var screenshotCard = '<div class="col-md-6 col-lg-4 mb-3">' +
							'<div class="card">' +
								'<div class="card-body p-2">' +
									'<h6 class="card-title text-truncate" title="' + (result.url || '') + '">' + (result.title || result.url || 'Screenshot') + '</h6>' +
									'<div class="badge badge-info mb-2">' + result.viewport + '</div>' +
									'<img src="data:image/png;base64,' + screenshotData + '" class="img-fluid" style="max-width: 100%; height: auto; border: 1px solid #ddd; border-radius: 4px; cursor: pointer;" onclick="openScreenshotModal(\'' + screenshotData + '\', \'' + (result.url || '') + '\')" alt="Screenshot">' +
									'<div class="mt-2">' + downloadBtn + '</div>' +
									shareButtons +
								'</div>' +
							'</div>' +
						'</div>';
						
						$('#progressiveGallery').append(screenshotCard);
					}
				}

				// Function to update progress
				function updateProgress() {
					$('#progressText').text(completedRequests + ' / ' + totalRequests + ' completed');
					$('#queryCount').text(allResults.length);
				}

				// Function to update final summary
				function updateFinalSummary(allResults, urlList, selectedViewports) {
					$('#summaryInfo').html(
						'<div class="alert alert-success">' +
						'<strong>Completed!</strong> ' +
						'URLs: ' + urlList.length + ', ' +
						'Viewports: ' + selectedViewports.join(', ') + ', ' +
						'Total Screenshots: ' + allResults.length +
						'</div>'
					);
					
					// Update gallery description
					$('#screenshotDisplay h5').after('<p class="text-muted">Captured ' + urlList.length + ' URL(s) in ' + selectedViewports.length + ' viewport size(s)</p>');
				}
			});

			function renderResults(data) {
				if (!data || !data.success) {
					$('#error').text('Screenshot capture failed.').show();
					return;
				}

				var result = data.result;
				var screenshotData = result.screenshot_base64 || '';
				var screenshotImg = '';
				var downloadBtn = '';
				
				if (screenshotData) {
					screenshotImg = '<img src="data:image/png;base64,' + screenshotData + '" class="img-fluid" style="max-width: 100%; height: auto; border: 1px solid #ddd; border-radius: 4px;" alt="Screenshot">';
					downloadBtn = '<button class="btn btn-sm btn-success" onclick="downloadScreenshot(\'' + screenshotData + '\', \'' + (result.url || 'screenshot') + '\')"><i class="fas fa-download"></i> Download</button>';
				} else {
					screenshotImg = '<div class="text-muted">No screenshot available</div>';
					downloadBtn = '<button class="btn btn-sm btn-secondary" disabled>No Image</button>';
				}

				var rows = '<tr>' +
					'<td>' + (result.url || '') + '</td>' +
					'<td>' + (result.status_code || '') + '</td>' +
					'<td>' + (result.title || '') + '</td>' +
					'<td>' + (result.response_time_ms || '') + ' ms</td>' +
					'<td>' + (result.content_length || '') + ' bytes</td>' +
					'<td>' + (result.content_type || '') + '</td>' +
					'<td>' + downloadBtn + '</td>' +
				'</tr>';
				
				$('#resultsBody').html(rows);
				$('#queryCount').text('1');
				$('#screenshotDisplay').html('<div class="text-center screenshot-preview"><h5>Screenshot Preview</h5>' + screenshotImg + '</div>');
				$('#resultsCard').show();
			}

			function renderBatchResults(data) {
				if (!data || !data.success || !data.results) {
					$('#error').text('Batch screenshot capture failed.').show();
					return;
				}

				var rows = '';
				var screenshotsHtml = '<div class="row screenshot-gallery">';
				
				for (var i = 0; i < data.results.length; i++) {
					var result = data.results[i];
					var screenshotData = result.screenshot_base64 || '';
					var downloadBtn = '';
					
					if (screenshotData) {
						downloadBtn = '<button class="btn btn-sm btn-success" onclick="downloadScreenshot(\'' + screenshotData + '\', \'' + (result.url || 'screenshot') + '\')"><i class="fas fa-download"></i> Download</button>';
					} else {
						downloadBtn = '<button class="btn btn-sm btn-secondary" disabled>No Image</button>';
					}

					rows += '<tr>' +
						'<td>' + (result.url || '') + '</td>' +
						'<td>' + (result.status_code || '') + '</td>' +
						'<td>' + (result.title || '') + '</td>' +
						'<td>' + (result.response_time_ms || '') + ' ms</td>' +
						'<td>' + (result.content_length || '') + ' bytes</td>' +
						'<td>' + (result.content_type || '') + '</td>' +
						'<td>' + downloadBtn + '</td>' +
					'</tr>';

					// Add screenshot to gallery
					if (screenshotData) {
						screenshotsHtml += '<div class="col-md-6 col-lg-4 mb-3">' +
							'<div class="card">' +
								'<div class="card-body p-2">' +
									'<h6 class="card-title text-truncate" title="' + (result.url || '') + '">' + (result.title || result.url || 'Screenshot') + '</h6>' +
									'<img src="data:image/png;base64,' + screenshotData + '" class="img-fluid" style="max-width: 100%; height: auto; border: 1px solid #ddd; border-radius: 4px; cursor: pointer;" onclick="openScreenshotModal(\'' + screenshotData + '\', \'' + (result.url || '') + '\')" alt="Screenshot">' +
									'<div class="mt-2">' + downloadBtn + '</div>' +
								'</div>' +
							'</div>' +
						'</div>';
					}
				}
				
				screenshotsHtml += '</div>';
				
				$('#resultsBody').html(rows);
				$('#queryCount').text(data.results.length);
				$('#screenshotDisplay').html('<div><h5>Screenshot Gallery</h5>' + screenshotsHtml + '</div>');
				$('#summaryInfo').html(
					'<div class="alert alert-info">' +
					'<strong>Summary:</strong> ' +
					'Total: ' + (data.summary.total || 0) + ', ' +
					'Successful: ' + (data.summary.successful || 0) + ', ' +
					'Failed: ' + (data.summary.failed || 0) + ', ' +
					'Total Time: ' + (data.summary.total_time_ms || 0) + ' ms' +
					'</div>'
				);
				$('#resultsCard').show();
			}

			function renderMultiViewportResults(results, urlList, selectedViewports) {
				if (results.length === 0) {
					$('#error').text('No screenshots captured.').show();
					return;
				}

				// Group results by URL
				var groupedResults = {};
				results.forEach(function(result) {
					if (!groupedResults[result.url]) {
						groupedResults[result.url] = [];
					}
					groupedResults[result.url].push(result);
				});

				// Create gallery HTML
				var galleryHtml = '<div class="row screenshot-gallery">';
				
				// Create table rows
				var tableRows = '';
				
				Object.keys(groupedResults).forEach(function(url) {
					var urlResults = groupedResults[url];
					var firstResult = urlResults[0];
					
					// Add table row for first viewport
					tableRows += '<tr>' +
						'<td rowspan="' + urlResults.length + '">' + url + '</td>' +
						'<td>' + (firstResult.status_code || '') + '</td>' +
						'<td>' + (firstResult.title || '') + '</td>' +
						'<td>' + (firstResult.response_time_ms || '') + ' ms</td>' +
						'<td>' + (firstResult.content_length || '') + ' bytes</td>' +
						'<td>' + (firstResult.content_type || '') + '</td>' +
						'<td>' + urlResults.length + ' viewport(s)</td>' +
					'</tr>';
					
					// Add remaining rows for other viewports
					for (var i = 1; i < urlResults.length; i++) {
						var result = urlResults[i];
						tableRows += '<tr>' +
							'<td>' + (result.status_code || '') + '</td>' +
							'<td>' + (result.title || '') + '</td>' +
							'<td>' + (result.response_time_ms || '') + ' ms</td>' +
							'<td>' + (result.content_length || '') + ' bytes</td>' +
							'<td>' + (result.content_type || '') + '</td>' +
							'<td></td>' +
						'</tr>';
					}
					
					// Add screenshots to gallery
					urlResults.forEach(function(result) {
						var screenshotData = result.screenshot_base64 || '';
						var downloadBtn = '';
						
						if (screenshotData) {
							downloadBtn = '<button class="btn btn-sm btn-success" onclick="downloadScreenshot(\'' + screenshotData + '\', \'' + (result.url || 'screenshot') + '_' + result.viewport + '\')"><i class="fas fa-download"></i> Download</button>';
							
							galleryHtml += '<div class="col-md-6 col-lg-4 mb-3">' +
								'<div class="card">' +
									'<div class="card-body p-2">' +
										'<h6 class="card-title text-truncate" title="' + (result.url || '') + '">' + (result.title || result.url || 'Screenshot') + '</h6>' +
										'<div class="badge badge-info mb-2">' + result.viewport + '</div>' +
										'<img src="data:image/png;base64,' + screenshotData + '" class="img-fluid" style="max-width: 100%; height: auto; border: 1px solid #ddd; border-radius: 4px; cursor: pointer;" onclick="openScreenshotModal(\'' + screenshotData + '\', \'' + (result.url || '') + '\')" alt="Screenshot">' +
										'<div class="mt-2">' + downloadBtn + '</div>' +
									'</div>' +
								'</div>' +
							'</div>';
						}
					});
				});
				
				galleryHtml += '</div>';
				
				$('#resultsBody').html(tableRows);
				$('#queryCount').text(results.length);
				$('#screenshotDisplay').html('<div><h5>Multi-Viewport Screenshot Gallery</h5><p class="text-muted">Captured ' + urlList.length + ' URL(s) in ' + selectedViewports.length + ' viewport size(s)</p>' + galleryHtml + '</div>');
				$('#summaryInfo').html(
					'<div class="alert alert-info">' +
					'<strong>Summary:</strong> ' +
					'URLs: ' + urlList.length + ', ' +
					'Viewports: ' + selectedViewports.join(', ') + ', ' +
					'Total Screenshots: ' + results.length +
					'</div>'
				);
				$('#resultsCard').show();
			}

			// Download screenshot function
			window.downloadScreenshot = function(base64Data, url) {
				try {
					// Create a temporary link element
					var link = document.createElement('a');
					link.href = 'data:image/png;base64,' + base64Data;
					
					// Generate filename from URL
					var filename = 'screenshot';
					if (url) {
						try {
							var urlObj = new URL(url);
							filename = urlObj.hostname.replace(/[^a-zA-Z0-9]/g, '_') + '_' + new Date().getTime();
						} catch (e) {
							filename = 'screenshot_' + new Date().getTime();
						}
					}
					link.download = filename + '.png';
					
					// Trigger download
					document.body.appendChild(link);
					link.click();
					document.body.removeChild(link);
				} catch (error) {
					alert('Download failed. Please try again.');
				}
			};

			// Open screenshot in modal
			window.openScreenshotModal = function(base64Data, url) {
				var modalHtml = '<div class="modal fade" id="screenshotModal" tabindex="-1" role="dialog">' +
					'<div class="modal-dialog modal-lg" role="document">' +
						'<div class="modal-content">' +
							'<div class="modal-header">' +
								'<h5 class="modal-title">Screenshot - ' + (url || 'Unknown') + '</h5>' +
								'<button type="button" class="close" data-dismiss="modal">&times;</button>' +
							'</div>' +
							'<div class="modal-body text-center">' +
								'<img src="data:image/png;base64,' + base64Data + '" class="img-fluid" style="max-width: 100%; height: auto;" alt="Screenshot">' +
							'</div>' +
							'<div class="modal-footer">' +
								'<div class="btn-group mr-2" role="group">' +
									'<button type="button" class="btn btn-outline-primary" onclick="shareToTwitter(\'' + base64Data + '\', \'' + (url || '') + '\', \'\')" title="Share on Twitter"><i class="fab fa-twitter"></i> Twitter</button>' +
									'<button type="button" class="btn btn-outline-success" onclick="shareToLinkedIn(\'' + base64Data + '\', \'' + (url || '') + '\', \'\')" title="Share on LinkedIn"><i class="fab fa-linkedin"></i> LinkedIn</button>' +
									'<button type="button" class="btn btn-outline-info" onclick="shareToFacebook(\'' + base64Data + '\', \'' + (url || '') + '\', \'\')" title="Share on Facebook"><i class="fab fa-facebook"></i> Facebook</button>' +
								'</div>' +
								'<button type="button" class="btn btn-outline-secondary mr-2" onclick="copyImageLink(\'' + base64Data + '\', \'' + (url || '') + '\', \'\')" title="Copy Image Link"><i class="fas fa-link"></i> Copy Link</button>' +
								'<button type="button" class="btn btn-success" onclick="downloadScreenshot(\'' + base64Data + '\', \'' + (url || 'screenshot') + '\')"><i class="fas fa-download"></i> Download</button>' +
								'<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>' +
							'</div>' +
						'</div>' +
					'</div>' +
				'</div>';
				
				// Remove existing modal if any
				$('#screenshotModal').remove();
				
				// Add modal to body
				$('body').append(modalHtml);
				
				// Show modal
				$('#screenshotModal').modal('show');
			};

			// Social sharing functions
			window.shareToTwitter = function(base64Data, url, viewport) {
				var text = 'Check out this website screenshot';
				if (url) {
					text += ' of ' + url;
				}
				if (viewport) {
					text += ' (' + viewport + ' viewport)';
				}
				text += ' captured with 8gwifi.org screenshot tool!';
				
				var twitterUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(text);
				if (url) {
					twitterUrl += '&url=' + encodeURIComponent(url);
				}
				
				window.open(twitterUrl, '_blank', 'width=600,height=400');
			};

			window.shareToLinkedIn = function(base64Data, url, viewport) {
				var text = 'Website screenshot';
				if (url) {
					text += ' of ' + url;
				}
				if (viewport) {
					text += ' (' + viewport + ' viewport)';
				}
				text += ' captured with 8gwifi.org/screenshot.jsp screenshot tool';
				
				var linkedinUrl = 'https://www.linkedin.com/sharing/share-offsite/?url=' + encodeURIComponent(url || 'https://8gwifi.org/screenshot.jsp');
				linkedinUrl += '&summary=' + encodeURIComponent(text);
				
				window.open(linkedinUrl, '_blank', 'width=600,height=400');
			};

			window.shareToFacebook = function(base64Data, url, viewport) {
				var text = 'Check out this website screenshot';
				if (url) {
					text += ' of ' + url;
				}
				if (viewport) {
					text += ' (' + viewport + ' viewport)';
				}
				text += ' captured with 8gwifi.org screenshot tool!';
				
				var facebookUrl = 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(url || 'https://8gwifi.org/screenshot.jsp');
				facebookUrl += '&quote=' + encodeURIComponent(text);
				
				window.open(facebookUrl, '_blank', 'width=600,height=400');
			};

			window.copyImageLink = function(base64Data, url, viewport) {
				var imageUrl = 'data:image/png;base64,' + base64Data;
				var text = 'Website screenshot';
				if (url) {
					text += ' of ' + url;
				}
				if (viewport) {
					text += ' (' + viewport + ' viewport)';
				}
				text += ' captured with 8gwifi.org screenshot tool: ' + imageUrl;
				
				// Create a temporary textarea to copy the text
				var textarea = document.createElement('textarea');
				textarea.value = text;
				document.body.appendChild(textarea);
				textarea.select();
				document.execCommand('copy');
				document.body.removeChild(textarea);
				
				// Show success message
				var originalText = event.target.innerHTML;
				event.target.innerHTML = '<i class="fas fa-check"></i> Copied!';
				event.target.classList.remove('btn-outline-secondary');
				event.target.classList.add('btn-success');
				
				setTimeout(function() {
					event.target.innerHTML = originalText;
					event.target.classList.remove('btn-success');
					event.target.classList.add('btn-outline-secondary');
				}, 2000);
			};
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<!-- Compact Network Tools Navigation Bar -->
<%@ include file="network-tools-navbar.jsp"%>

<h1 class="mt-4">Free Multi-Device Website Screenshot Tool</h1>
<p class="lead">Capture responsive screenshots across desktop, tablet & mobile devices. Test your website's design, share on social media, and download instantly - all for free!</p>
<hr>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Capturing screenshots...
</div>

<!-- Unified Screenshot Form -->
<div class="card mb-4">
	<div class="card-header">
		<h5 class="mb-0">🚀 Multi-Device Screenshot Capture</h5>
		<p class="mb-0 text-muted">Enter URLs and select viewport sizes to capture responsive screenshots</p>
	</div>
	<div class="card-body">
		<form id="screenshotForm" class="form-horizontal" method="POST">
			<div class="form-group">
				<label for="urls"><strong>Website URL(s):</strong></label>
				<textarea class="form-control" id="urls" name="urls" rows="4" placeholder="Enter one or more URLs (one per line):&#10;https://google.com&#10;github.com&#10;stackoverflow.com" required></textarea>
				<small class="form-text text-muted">Enter URLs with or without protocol (https:// will be added automatically if missing)</small>
			</div>
			<div class="form-group">
				<label><strong>📱 Viewport Sizes:</strong></label>
				<div class="row">
					<div class="col-md-4">
						<div class="viewport-category">
							<h6><i class="fas fa-desktop"></i> Desktop</h6>
							<div class="category-border"></div>
						</div>
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
					<div class="col-md-4">
						<div class="viewport-category">
							<h6><i class="fas fa-tablet-alt"></i> Tablet</h6>
							<div class="category-border"></div>
						</div>
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
					<div class="col-md-4">
						<div class="viewport-category">
							<h6><i class="fas fa-mobile-alt"></i> Mobile</h6>
							<div class="category-border"></div>
						</div>
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
				<small class="form-text text-muted">Select one or more viewport sizes. Each URL will be captured in all selected sizes.</small>
				<div class="mt-3">
					<div class="btn-group" role="group">
						<button type="button" class="btn btn-sm btn-outline-primary" id="selectAllViewports">
							<i class="fas fa-check-square"></i> Select All
						</button>
						<button type="button" class="btn btn-sm btn-outline-info" id="selectDesktop">
							<i class="fas fa-desktop"></i> Desktop Only
						</button>
						<button type="button" class="btn btn-sm btn-outline-warning" id="selectTablet">
							<i class="fas fa-tablet-alt"></i> Tablet Only
						</button>
						<button type="button" class="btn btn-sm btn-outline-success" id="selectMobile">
							<i class="fas fa-mobile-alt"></i> Mobile Only
						</button>
						<button type="button" class="btn btn-sm btn-outline-secondary" id="clearViewports">
							<i class="fas fa-times"></i> Clear All
						</button>
					</div>
				</div>
			</div>
			<div class="form-group">
				<div class="form-check">
					<input class="form-check-input" type="checkbox" id="fullPage" name="fullPage">
					<label class="form-check-label" for="fullPage">
						Capture full page (not just viewport)
					</label>
				</div>
			</div>
			<button type="submit" class="btn btn-primary btn-lg">
				<i class="fas fa-camera"></i> Capture Screenshots
			</button>
		</form>
	</div>
</div>

<hr>

<div id="error" class="alert alert-danger" style="display:none;"></div>

<div class="card" id="resultsCard" style="display:none;">
	<div class="card-header">
		<h6 class="mb-0">Results (<span id="queryCount">0</span> screenshots)</h6>
	</div>
	<div class="card-body">
		<div id="summaryInfo"></div>
		
		<!-- Screenshot Display Area -->
		<div id="screenshotDisplay" class="mb-4"></div>

	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4">About Website Screenshots</h2>
<p>Capture high-quality screenshots of any website or web page with customizable viewport sizes. Perfect for testing responsive designs, creating documentation, or generating website previews for different devices.</p>

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
	<li>Capture each URL in every selected viewport size</li>
	<li>Display all screenshots in an organized gallery</li>
	<li>Group results by URL with viewport badges</li>
	<li>Allow individual download of each viewport screenshot</li>
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
	<li><strong>Batch Processing:</strong> Capture multiple websites simultaneously with configurable concurrency</li>
	<li><strong>Full Page Capture:</strong> Screenshot entire page, not just viewport</li>
	<li><strong>Multiple Devices:</strong> Test responsive design across 9 different viewport sizes</li>
	<li><strong>Base64 Output:</strong> Get screenshots as base64 encoded images for easy embedding</li>
	<li><strong>Social Sharing:</strong> Share screenshots directly to Twitter, LinkedIn, Facebook, or copy image links</li>
	<li><strong>Progressive Display:</strong> See screenshots as they're captured, no waiting for all to complete</li>
	<li><strong>Performance Metrics:</strong> View response times, status codes, and content details</li>
	<li><strong>Simple Input:</strong> Just paste URLs - no complex validation or setup required</li>
</ul>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>

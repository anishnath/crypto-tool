<!DOCTYPE html>
<html lang="en">

<head>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="covid dashbaord, covid analytics, comapre data for diffrent country">
	<meta name="author" content="covid dashboard, covid analytics">

	<title>COVID-19 Dashbaord</title>

	<!-- Bootstrap core CSS -->
	<link href="vendor1/bootstrap/css/bootstrap.min.css" rel="stylesheet">

	<!-- Custom styles for this template -->
	<link href="css/simple-sidebar.css" rel="stylesheet">

	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

	<script type="text/javascript">
		var sc_project=9638240;
		var sc_invisible=1;
		var sc_security="c4db7f3d";
	</script>
	<script type="text/javascript" src="js/statcounter/counter/counter.js" async></script>
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="js/gtag/js?id=UA-109251861-1"></script>
	<script>
		window.dataLayer = window.dataLayer || [];
		function gtag(){dataLayer.push(arguments);}
		gtag('js', new Date());

		gtag('config', 'UA-109251861-1');
	</script>

</head>



<body>

<div class="d-flex" id="wrapper">

	<!-- Sidebar -->
	<div class="bg-light border-right" id="sidebar-wrapper">
		<div class="sidebar-heading">8gwifi.org</div>
		<div class="list-group list-group-flush">
			<a href="index.jsp" class="list-group-item list-group-item-action bg-light">Home</a>
			<%@ include file="footer_adsense.jsp"%>
		</div>
	</div>
	<!-- /#sidebar-wrapper -->

	<!-- Page Content -->
	<div id="page-content-wrapper">



		<div class="container-fluid">
			<center> <h1 class="mt-4">COVID-19 DashBaord</h1> </center>
			<hr>


			<div class="row">
				<div class="col-sm" id="chart_div"></div>
			</div>




			<div class="row">
				<div class="col-sm-10">
					<label for="exampleFormControlSelect2">Select Multiple Countries to Compare</label>
					<select multiple class="form-control" id="lstSelect">
						<option value="US">USA</option>
						<option value="ES">Spain</option>
						<option value="IT">Italy</option>
						<option value="DE">Germany</option>
						<option value="GB">UK</option>
						<option value="SG">Singapore</option>
						<option value="CN">China</option>
						<option value="IR">Iran</option>
						<option value="TR">Turkey</option>
						<option value="BE">Belgium</option>
						<option value="NL">Netharlands</option>
						<option value="CA">Canada</option>
						<option value="CH">Switzerland</option>
						<option value="BR">Brazil</option>
						<option value="RU">Russian</option>
						<option value="PT">Portugal</option>
						<option value="AT">Austria</option>
						<option value="IL">Israel</option>
						<option value="IN">India</option>
						<option value="IE">Ireland</option>
						<option value="SE">Sweden</option>
						<option value="KR">Korea(S)</option>
						<option value="PE">Peru</option>
						<option value="CL">Chile</option>
						<option value="JP">Japan</option>
						<option value="EC">Ecuador</option>
						<option value="PL">Poland</option>
						<option value="RO">Romania</option>
						<option value="DK">Denmark</option>
						<option value="NO">Norway</option>
						<option value="AU">Australia</option>
						<option value="CZ">Czech Republic</option>
						<option value="TW">Taiwan</option>
						<option value="JO">Jordan</option>
						<option value="PK">Pakistan</option>
						<option value="SA">Saudi Arabia</option>
						<option value="PH">Philippines</option>
						<option value="MX">Mexico</option>
						<option value="MY">Malaysia</option>
						<option value="AE">UAE</option>
						<option value="RS">Serbia</option>
						<option value="PA">Panama</option>
						<option value="QA">Qatar</option>
						<option value="UA">Ukraine</option>
						<option value="DO">Dominican Republic</option>
						<option value="BY">Belarus</option>
						<option value="FI">Finland</option>
						<option value="CO">Colombia</option>
						<option value="TH">Thailand</option>
						<option value="ZA">South Africa</option>
						<option value="EG">Egypt</option>
						<option value="AR">Argentina</option>
						<option value="GR">Greece</option>
						<option value="DZ">Algeria</option>
						<option value="MD">Moldova</option>
						<option value="MA">Morocco</option>
						<option value="IS">Iceland</option>
						<option value="HR">Croatia</option>
						<option value="BH">Bahrain</option>
						<option value="HU">Hungary</option>
						<option value="IQ">Iraq</option>
						<option value="EE">Estonia</option>
						<option value="NZ">New Zealand</option>
						<option value="KW">Kuwait</option>
					</select>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10" id="compare_visualization1"></div>
				<div class="col-sm-10" id="compare_visualization2"></div>
				<div class="col-sm-10" id="compare_visualization3"></div>
			</div>

			<script>
				$("#lstSelect").change(function(){
					/*  var selectedValues = [];
					 $("#lstSelect :selected").each(function(){
					 selectedValues.push($(this).val());
					 });
					 console.log(selectedValues);
					 return false; */

					//console.log($(this).val());

					arr = $(this).val();

					console.log('Length ' + arr.length)

					if(arr.length==13)
					{alert('You can comprate Max 12 Countries') }
					else {
						compareCountry(arr)
					}





				});
			</script>


			<div class="row">
				<div class="col-sm-3" id="visualization"></div>
				<div class="col-sm-7" id="visualization1"></div>

			</div>

			<div id="output"></div>

			<div class="row">
				<div class="col-sm-10" id="visualization2"></div>
				<div class="col-sm-10" id="visualization3"></div>
			</div>

			<div class="row">
				<div class="col-sm-5" id="us_div"></div>
				<div class="col-sm-5" id="us_div1"></div>
			</div>
			<div class="row">
				<div class="col-sm-10" id="us_div2"></div>
			</div>

			<hr>

			<h2>All Affected country sorted by confirmed cases</h2>
			<p>Choose Country for additonal visualization</p>
			<div class="row">

				<div class="col-sm" id="chart2_div"></div>

			</div>


			<script type="text/javascript">

				function compareCountry(topCountry) {

					google.charts.load('current', {
						'packages': ['corechart', 'treemap', 'table', 'geochart', 'line']
					});
					var data = new google.visualization.DataTable();
					var data1 = new google.visualization.DataTable();
					var data2 = new google.visualization.DataTable();
					data.addColumn('date', 'date');
					data1.addColumn('date', 'date');
					data2.addColumn('date', 'date');

					for (i = 0; i < topCountry.length; i++) {
						data.addColumn('number', topCountry[i]);
						data1.addColumn('number', topCountry[i]);
						data2.addColumn('number', topCountry[i]);
					}


					var itemArray = []
					var deathArray = []
					var recoveredArray = []
					var finalcountryCase = []
					var topCountryLength = topCountry.length;

					topCountry.forEach(countryData);

					function countryData(value, index, array) {

						posturl = 'https://corona.lmao.ninja/v2/historical/' + value
						//console.log(posturl)


						//$.getJSON(posturl, function(jdata) {

						$.ajax({
							dataType: "json",
							url: posturl,
							async: false,
							success: function(jdata) {

								//console.log(posturl)

								// console.log(jdata)

								$.each(jdata, function(index) {

									if (jdata[index].hasOwnProperty('cases')) {
										//console.log(jdata[index].cases)
										$.each(jdata[index].cases, function(index, element) {
											itemArray.push(index + ',' + element)
										});

									}

									if (jdata[index].hasOwnProperty('deaths')) {
										//console.log(jdata[index].cases)
										$.each(jdata[index].deaths, function(index, element) {
											deathArray.push(index + ',' + element)
										});

									}

									if (jdata[index].hasOwnProperty('recovered')) {
										//console.log(jdata[index].cases)
										$.each(jdata[index].recovered, function(index, element) {
											recoveredArray.push(index + ',' + element)
										});

									}

								});


								result = Object
										.entries(itemArray.reduce((r, s) => {
													const [date, value] = s.split(',');
								r[date] = r[date] || [];
								r[date].push(value);
								return r;
							}, {}))
								.flat(2);

								result1 = Object
										.entries(deathArray.reduce((r, s) => {
													const [date, value] = s.split(',');
								r[date] = r[date] || [];
								r[date].push(value);
								return r;
							}, {}))
								.flat(2);

								result2 = Object
										.entries(recoveredArray.reduce((r, s) => {
													const [date, value] = s.split(',');
								r[date] = r[date] || [];
								r[date].push(value);
								return r;
							}, {}))
								.flat(2);



								//console.log(itemArray)
								//console.log(result)

								str = ''
								for (index = 0; index < result.length; index++) {
									str = str + ',' + result[index]
								}

								//console.log(str)

								str = str.substr(1);

								//console.log(str)

								str1 = ''
								for (index = 0; index < result1.length; index++) {
									str1 = str1 + ',' + result1[index]
								}

								str1 = str1.substr(1);

								str2 = ''
								for (index = 0; index < result2.length; index++) {
									str2 = str2 + ',' + result2[index]
								}

								str2 = str2.substr(1);


								//console.log(str)

								const arr = str
												.split(/,(?=\d+\/)/)
												.map(str => str.split(','));


								const arr1 = str1
												.split(/,(?=\d+\/)/)
												.map(str1 => str1.split(','));

								const arr2 = str2
												.split(/,(?=\d+\/)/)
												.map(str2 => str2.split(','));


								//console.log(arr);

								arr.map(function(val, index) {
									console.log(val.length)
									if (val.length == topCountry.length + 1) {

										//console.log(str)

										var parts = val[0].split("/");

										var dt = new Date(parseInt('20' + parts[2]),
												parseInt(parts[0]) - 1,
												parseInt(parts[1]));


										if (val.length == 2) {
											data.addRow([
												dt, parseInt(val[1]),
											])
										} else if (val.length == 3) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
											])
										} else if (val.length == 4) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
											])
										} else if (val.length == 5) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
											])
										} else if (val.length == 6) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
											])
										} else if (val.length == 7) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
											])
										} else if (val.length == 8) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
											])
										} else if (val.length == 9) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
											])
										} else if (val.length == 10) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
											])
										} else if (val.length == 11) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
												parseInt(val[10]),
											])
										}
										else if (val.length == 12) {
											data.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
												parseInt(val[10]),
												parseInt(val[11]),
											])
										}

										else {
											//Do Nothing
										}


										// console.log(data)

									} // End If

								})

								arr1.map(function(val, index) {
									//console.log(val.length)
									x = 0
									if (val.length == topCountry.length + 1) {

										var parts = val[0].split("/");

										var dt = new Date(parseInt('20' + parts[2]),
												parseInt(parts[0]) - 1,
												parseInt(parts[1]));


										if (val.length == 2) {
											data1.addRow([
												dt, parseInt(val[1]),
											])
										} else if (val.length == 3) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
											])
										} else if (val.length == 4) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
											])
										} else if (val.length == 5) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
											])
										} else if (val.length == 6) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
											])
										} else if (val.length == 7) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
											])
										} else if (val.length == 8) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
											])
										} else if (val.length == 9) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
											])
										} else if (val.length == 10) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
											])
										} else if (val.length == 11) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
												parseInt(val[10]),
											])
										}
										else if (val.length == 12) {
											data1.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
												parseInt(val[10]),
												parseInt(val[11]),
											])
										}

										else {
											//Do Nothing
										}
									}

								})

								arr2.map(function(val, index) {
									//console.log(val.length)
									x = 0
									if (val.length == topCountry.length + 1) {

										var parts = val[0].split("/");

										var dt = new Date(parseInt('20' + parts[2]),
												parseInt(parts[0]) - 1,
												parseInt(parts[1]));


										if (val.length == 2) {
											data2.addRow([
												dt, parseInt(val[1]),
											])
										} else if (val.length == 3) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
											])
										} else if (val.length == 4) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
											])
										} else if (val.length == 5) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
											])
										} else if (val.length == 6) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
											])
										} else if (val.length == 7) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
											])
										} else if (val.length == 8) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
											])
										} else if (val.length == 9) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
											])
										} else if (val.length == 10) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
											])
										} else if (val.length == 11) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
												parseInt(val[10]),
											])
										}
										else if (val.length == 12) {
											data2.addRow([
												dt,
												parseInt(val[1]),
												parseInt(val[2]),
												parseInt(val[3]),
												parseInt(val[4]),
												parseInt(val[5]),
												parseInt(val[6]),
												parseInt(val[7]),
												parseInt(val[8]),
												parseInt(val[9]),
												parseInt(val[10]),
												parseInt(val[11]),
											])
										}

										else {
											//Do Nothing
										}
									}

								})

								var options = {
									hAxis: {
										title: 'Time',
										format: 'd MMM',
									},
									vAxis: {
										title: 'Top Confirmed Cases'
									},
									//colors: ['black', 'blue', 'red', 'green', 'gold', 'gray', 'pink', 'brown', 'purple', 'orange'],
									curveType: 'function',
									//colors: ['#a52714', '#097138'],
									//legend: 'none',
								};

								var chart = new google.visualization.LineChart(document.getElementById('compare_visualization1'));

								//console.log(data)
								chart.draw(data, options);

								var options = {
									hAxis: {
										title: 'Time',
										format: 'd MMM',
									},
									vAxis: {
										title: 'Death Cases'
									},
									curveType: 'function',
									//legend: 'none',
									//colors: ['black', 'blue', 'red', 'green', 'gold', 'gray', 'pink', 'brown', 'purple', 'orange'],
									//colors: ['#a52714', '#097138'],

								};

								var chart = new google.visualization.LineChart(document.getElementById('compare_visualization2'));

								//console.log(data)
								chart.draw(data1, options);

								var options = {
									hAxis: {
										title: 'Time',
										format: 'd MMM',
									},
									vAxis: {
										title: 'Recovered Cases'
									},
									curveType: 'function',
									colors: ['black', 'blue', 'red', 'green', 'gold', 'gray', 'pink', 'brown', 'purple', 'orange'],
									//colors: ['#a52714', '#097138'],
									//legend: 'none',


								};

								var chart = new google.visualization.LineChart(document.getElementById('compare_visualization3'));

								//console.log(data)
								chart.draw(data2, options);


							}
						}) // End of Ajax

					}




				}
			</script>





			<!--   <script  src="js/country.js"></script>     -->

			<script type="text/javascript">


				// Load the Visualization API and the piechart package.
				google.charts.load('current', {'packages':['corechart','treemap','table', 'geochart','line']});

				// Set a callback to run when the Google Visualization API is loaded.
				google.charts.setOnLoadCallback(drawChart);
				google.charts.setOnLoadCallback(drawLineStyles);
				// google.charts.setOnLoadCallback(drawChart3);

				function drawLineStyles() {

					var topCountry = ['US', 'ES', 'IT', 'FR', 'DE', 'CN', 'GB', 'IN', 'SG', 'TW']

					var data = new google.visualization.DataTable();
					data.addColumn('date', 'date');
					data.addColumn('number', 'US');
					data.addColumn('number', 'SPAIN');
					data.addColumn('number', 'ITALY');
					data.addColumn('number', 'FRANCE');
					data.addColumn('number', 'GERMANY');
					data.addColumn('number', 'CHINA');
					data.addColumn('number', 'UK');
					data.addColumn('number', 'INDIA');
					data.addColumn('number', 'SINGAPORE');
					data.addColumn('number', 'TAIWAN');


					var data1 = new google.visualization.DataTable();
					data1.addColumn('date', 'date');
					data1.addColumn('number', 'US');
					data1.addColumn('number', 'SPAIN');
					data1.addColumn('number', 'ITALY');
					data1.addColumn('number', 'FRANCE');
					data1.addColumn('number', 'GERMANY');
					data1.addColumn('number', 'CHINA');
					data1.addColumn('number', 'UK');
					data1.addColumn('number', 'INDIA');
					data1.addColumn('number', 'SINGAPORE');
					data1.addColumn('number', 'TAIWAN');

					var data2 = new google.visualization.DataTable();
					data2.addColumn('date', 'date');
					data2.addColumn('number', 'US');
					data2.addColumn('number', 'SPAIN');
					data2.addColumn('number', 'ITALY');
					data2.addColumn('number', 'FRANCE');
					data2.addColumn('number', 'GERMANY');
					data2.addColumn('number', 'CHINA');
					data2.addColumn('number', 'UK');
					data2.addColumn('number', 'INDIA');
					data2.addColumn('number', 'SINGAPORE');
					data2.addColumn('number', 'TAIWAN');


					var itemArray = []
					var deathArray = []
					var recoveredArray = []
					var finalcountryCase = []

					topCountry.forEach(countryData);

					function countryData(value, index, array) {

						posturl = 'https://corona.lmao.ninja/v2/historical/' + value
						//console.log(posturl)


						//$.getJSON(posturl, function(jdata) {

						$.ajax({
							dataType: "json",
							url: posturl,
							async: false,
							success: function(jdata) {

								//console.log(posturl)

								// console.log(jdata)

								$.each(jdata, function(index) {

									if (jdata[index].hasOwnProperty('cases')) {
										//console.log(jdata[index].cases)
										$.each(jdata[index].cases, function(index, element) {
											itemArray.push(index + ',' + element)
										});

									}

									if (jdata[index].hasOwnProperty('deaths')) {
										//console.log(jdata[index].cases)
										$.each(jdata[index].deaths, function(index, element) {
											deathArray.push(index + ',' + element)
										});

									}

									if (jdata[index].hasOwnProperty('recovered')) {
										//console.log(jdata[index].cases)
										$.each(jdata[index].recovered, function(index, element) {
											recoveredArray.push(index + ',' + element)
										});

									}

								});


								result = Object
										.entries(itemArray.reduce((r, s) => {
													const [date, value] = s.split(',');
								r[date] = r[date] || [];
								r[date].push(value);
								return r;
							}, {}))
								.flat(2);

								result1 = Object
										.entries(deathArray.reduce((r, s) => {
													const [date, value] = s.split(',');
								r[date] = r[date] || [];
								r[date].push(value);
								return r;
							}, {}))
								.flat(2);

								result2 = Object
										.entries(recoveredArray.reduce((r, s) => {
													const [date, value] = s.split(',');
								r[date] = r[date] || [];
								r[date].push(value);
								return r;
							}, {}))
								.flat(2);



								//console.log(itemArray)
								//console.log(result)

								str = ''
								for (index = 0; index < result.length; index++) {
									str = str + ',' + result[index]
								}

								//console.log(str)

								str1 = ''
								for (index = 0; index < result1.length; index++) {
									str1 = str1 + ',' + result1[index]
								}

								str2 = ''
								for (index = 0; index < result2.length; index++) {
									str2 = str2 + ',' + result2[index]
								}


								//console.log(str)

								const arr = str
												.split(/,(?=\d+\/)/)
												.map(str => str.split(','));


								const arr1 = str1
												.split(/,(?=\d+\/)/)
												.map(str1 => str1.split(','));

								const arr2 = str2
												.split(/,(?=\d+\/)/)
												.map(str2 => str2.split(','));


								//console.log(arr);

								arr.map(function(val, index) {
									//console.log(val.length)
									x = 0
									if (val.length == 11) {

										//console.log(str)

										var parts = val[0].split("/");

										var dt = new Date(parseInt('20' + parts[2]),
												parseInt(parts[0]) - 1,
												parseInt(parts[1]));
										data.addRow([dt, parseInt(val[1]),
											parseInt(val[2]),
											parseInt(val[3]),
											parseInt(val[4]),
											parseInt(val[5]),
											parseInt(val[6]),
											parseInt(val[7]),
											parseInt(val[8]),
											parseInt(val[9]),
											parseInt(val[10]),
										])

										// console.log(data)

									}

								})

								arr1.map(function(val, index) {
									//console.log(val.length)
									x = 0
									if (val.length == 11) {

										var parts = val[0].split("/");

										var dt = new Date(parseInt('20' + parts[2]),
												parseInt(parts[0]) - 1,
												parseInt(parts[1]));
										data1.addRow([dt, parseInt(val[1]),
											parseInt(val[2]),
											parseInt(val[3]),
											parseInt(val[4]),
											parseInt(val[5]),
											parseInt(val[6]),
											parseInt(val[7]),
											parseInt(val[8]),
											parseInt(val[9]),
											parseInt(val[10]),
										])
									}

								})

								arr2.map(function(val, index) {
									//console.log(val.length)
									x = 0
									if (val.length == 11) {

										var parts = val[0].split("/");

										var dt = new Date(parseInt('20' + parts[2]),
												parseInt(parts[0]) - 1,
												parseInt(parts[1]));
										data2.addRow([dt, parseInt(val[1]),
											parseInt(val[2]),
											parseInt(val[3]),
											parseInt(val[4]),
											parseInt(val[5]),
											parseInt(val[6]),
											parseInt(val[7]),
											parseInt(val[8]),
											parseInt(val[9]),
											parseInt(val[10]),
										])
									}

								})

								var options = {
									hAxis: {
										title: 'Time',
										format: 'd MMM',
									},
									vAxis: {
										title: 'Top Confirmed Cases'
									},
									colors: ['black', 'blue', 'red', 'green', 'gold', 'gray', 'pink', 'brown', 'purple', 'orange'],
									curveType: 'function',
									//colors: ['#a52714', '#097138'],
									//legend: 'none',
								};

								var chart = new google.visualization.LineChart(document.getElementById('compare_visualization1'));

								//console.log(data)
								chart.draw(data, options);

								var options = {
									hAxis: {
										title: 'Time',
										format: 'd MMM',
									},
									vAxis: {
										title: 'Death Cases'
									},
									curveType: 'function',
									//legend: 'none',
									colors: ['black', 'blue', 'red', 'green', 'gold', 'gray', 'pink', 'brown', 'purple', 'orange'],
									//colors: ['#a52714', '#097138'],

								};

								var chart = new google.visualization.LineChart(document.getElementById('compare_visualization2'));

								//console.log(data)
								chart.draw(data1, options);

								var options = {
									hAxis: {
										title: 'Time',
										format: 'd MMM',
									},
									vAxis: {
										title: 'Recovered Cases'
									},
									curveType: 'function',
									colors: ['black', 'blue', 'red', 'green', 'gold', 'gray', 'pink', 'brown', 'purple', 'orange'],
									//colors: ['#a52714', '#097138'],
									//legend: 'none',


								};

								var chart = new google.visualization.LineChart(document.getElementById('compare_visualization3'));

								//console.log(data)
								chart.draw(data2, options);


							}
						}) // End of Ajax

					}




					//chart.draw(data, options);
				}


				function drawChart() {

					$.ajax({
						url: "https://api.covid19api.com/summary",
						dataType: "json",
					}).done(function (jsonData) {

						jdata = JSON.stringify(jsonData)
						var data = google.visualization.arrayToDataTable([
							['Task', 'Corona Cases',  { role: "style" }],
							['TotalDeaths',      parseInt(jsonData.Global.TotalDeaths),"red"],
							['NewDeaths',      parseInt(jsonData.Global.NewDeaths),"silver"],
							['TotalRecovered', parseInt(jsonData.Global.TotalRecovered), "gold"],
							['NewConfirmed',    parseInt(jsonData.Global.NewConfirmed), "green"],
							['TotalConfirmed',     parseInt(jsonData.Global.TotalConfirmed), "blue"],
						]);

						var view = new google.visualization.DataView(data);
						view.setColumns([0, 1,
							{ calc: "stringify",
								sourceColumn: 1,
								type: "string",
								role: "annotation" },
							2]);


						var options = {
							title: 'COVID-19 WorldWide Status',
							// width: 700,
							// pieSliceText: 'label',
							legend: 'true',

						};

						var chart = new google.visualization.BarChart(document.getElementById('chart_div'));

						chart.draw(view, options);

						var data = new google.visualization.DataTable();

						data.addColumn('string', 'country Code');
						data.addColumn('string', 'country');
						data.addColumn('number', 'NewConfirmed');
						data.addColumn('number', 'TotalConfirmed');
						data.addColumn('number', 'NewDeaths');
						data.addColumn('number', 'TotalDeaths');
						data.addColumn('number', 'NewRecovered');
						data.addColumn('number', 'TotalRecovered');

						for(var key in jsonData.Countries) {
							//console.log(jsonData.Countries[key].Country);
							//console.log(jsonData.Countries[key].CountryCode)

							data.addRow([
								jsonData.Countries[key].CountryCode,
								jsonData.Countries[key].Country,
								jsonData.Countries[key].NewConfirmed,
								jsonData.Countries[key].TotalConfirmed,
								jsonData.Countries[key].NewDeaths,
								jsonData.Countries[key].TotalDeaths,
								jsonData.Countries[key].NewRecovered,
								jsonData.Countries[key].TotalRecovered,
							]);

						}

						//console.log(data)




						var options = {
							legend:'none',
							showRowNumber: true,
							sortAscending: false,
							sortColumn: 3
						};

						/* chart1.draw(data, {
						 minColor: '#f00',
						 midColor: '#ddd',
						 maxColor: '#0d0',
						 headerHeight: 15,
						 fontColor: 'black',
						 showScale: true
						 }); */

						var chart1 = new google.visualization.Table(document.getElementById('chart2_div'));
						chart1.draw(data, options);
						google.visualization.events.addListener(chart1, 'select', selectHandler);

						function selectHandler() {
							var selection = chart1.getSelection();
							var message = '';
							for (var i = 0; i < selection.length; i++) {
								var item = selection[i];
								if (item.row != null && item.column != null) {
									var str = data.getFormattedValue(item.row, item.column);
									message += '{row:' + item.row + ',column:' + item.column + '} = ' + str + '\n';
								} else if (item.row != null) {
									var str = data.getFormattedValue(item.row, 0);
									NewConfirmed = data.getFormattedValue(item.row, 2)
									TotalConfirmed = data.getFormattedValue(item.row, 3)
									NewDeaths = data.getFormattedValue(item.row, 4)
									TotalDeaths = data.getFormattedValue(item.row, 5)
									NewRecovered = data.getFormattedValue(item.row, 6)
									TotalRecovered = data.getFormattedValue(item.row, 7)

									message += '{row:' + item.row + ', column:none}; value (col 0) = ' + str + '\n';
									showVisualizationMap(str,NewConfirmed,TotalConfirmed,NewDeaths,TotalDeaths,NewRecovered,TotalRecovered)
									//console.log(NewConfirmed)
									//console.log(NewDeaths)
									//console.log(TotalDeaths)
									//console.log(NewRecovered)
									//console.log(TotalRecovered)
								} else if (item.column != null) {
									var str = data.getFormattedValue(0, item.column);
									message += '{row:none, column:' + item.column + '}; value (row 0) = ' + str + '\n';
								}
							}
							if (message == '') {
								message = 'nothing';
							}

							//alert('You selected ' + message);
						}

					}).fail(function (jq, text, err) {
						console.log(text + ' - ' + err);
					});
				}


				async function SHOWUSStateStuff() {

					$.getJSON('https://covidtracking.com/api/states', function(jdata) {

						var data = new google.visualization.DataTable();
						data.addColumn('string', 'state');
						data.addColumn('number', 'positive');
						data.addColumn('number', 'posNeg');
						data.addColumn('number', 'negative');
						data.addColumn('number', 'recovered');
						data.addColumn('number', 'death');
						data.addColumn('number', 'totalTestResults');
						data.addColumn('number', 'positiveScore');
						data.addColumn('number', 'negativeScore');
						data.addColumn('number', 'negativeRegularScore');
						//data.addColumn('number', 'commercialScore');
						data.addColumn('string', 'grade');
						data.addColumn('number', 'score');

						data.addColumn('number', 'pending');
						data.addColumn('number', 'hospitalizedCurrently');
						data.addColumn('number', 'hospitalizedCumulative');
						data.addColumn('number', 'inIcuCurrently');
						data.addColumn('number', 'inIcuCumulative');
						data.addColumn('number', 'onVentilatorCurrently');
						data.addColumn('number', 'onVentilatorCumulative');

						data.addColumn('number', 'hospitalized');




						$.each(jdata, function(index) {

							// console.log(jdata[index].state)


							data.addRow([

								jdata[index].state,
								parseInt(jdata[index].positive),
								parseInt(jdata[index].posNeg),
								parseInt(jdata[index].negative),
								parseInt(jdata[index].recovered),
								parseInt(jdata[index].death),
								parseInt(jdata[index].totalTestResults),
								parseInt(jdata[index].positiveScore),
								parseInt(jdata[index].negativeScore),
								parseInt(jdata[index].negativeRegularScore),
								jdata[index].grade,
								parseInt(jdata[index].score),

								parseInt(jdata[index].pending),
								parseInt(jdata[index].hospitalizedCurrently),
								parseInt(jdata[index].hospitalizedCumulative),
								parseInt(jdata[index].inIcuCurrently),
								parseInt(jdata[index].inIcuCumulative),
								parseInt(jdata[index].onVentilatorCurrently),
								parseInt(jdata[index].onVentilatorCumulative),

								parseInt(jdata[index].hospitalized),


							])


							var options = {
								title: 'CDC Data StateWise',
								legend: 'left',
								showRowNumber: true,
								sortAscending: false,
								sortColumn: 1
							};

							var chart1 = new google.visualization.Table(document.getElementById('us_div2'));
							chart1.draw(data, options);



						});


					});




				}

				async function SHOWUSStuff() {

					$.getJSON('https://covidtracking.com/api/v1/us/current.json', function(jdata) {

						var data = new google.visualization.DataTable();
						data.addColumn('string', 'CDC Data');
						data.addColumn('number', 'positive Cases');
						data.addColumn('number', 'negative Cases');
						data.addColumn('number', 'pending Cases');



						//data.addColumn('number', 'Total');
						data.addColumn('number', 'Total Test Results');
						data.addColumn('number', 'Postive Negative');


						var data1 = new google.visualization.DataTable();

						data1.addColumn('string', 'CDC Data');
						data1.addColumn('number', 'Recovered');
						data1.addColumn('number', 'Death');
						data1.addColumn('number', 'Hospitalized Currently');
						data1.addColumn('number', 'Hospitalized Cumulative');
						data1.addColumn('number', 'In Icu Currently');
						data1.addColumn('number', 'In Icu Cumulative');
						data1.addColumn('number', 'Ventilator Currently');
						data1.addColumn('number', 'Ventilator Cumulative');
						data1.addColumn('number', 'Hospitalized');

						$.each(jdata, function(index) {


							data.addRow([
								'CDC Data',
								parseInt(jdata[index].positive),
								parseInt(jdata[index].negative),
								parseInt(jdata[index].pending),
								//parseInt(jdata[index].hospitalizedCurrently),
								//parseInt(jdata[index].hospitalizedCumulative),
								//parseInt(jdata[index].inIcuCurrently),
								//parseInt(jdata[index].inIcuCumulative),
								//parseInt(jdata[index].onVentilatorCurrently),
								//parseInt(jdata[index].onVentilatorCumulative),
								//parseInt(jdata[index].recovered),
								//parseInt(jdata[index].death),
								//parseInt(jdata[index].hospitalized),
								//parseInt(jdata[index].total),
								parseInt(jdata[index].totalTestResults),
								parseInt(jdata[index].posNeg),

							]);

							var options = {
								title: 'US ',
								hAxis: {
									title: 'Test Results'
								},
								/* vAxis: {
								 title: 'Test Results'
								 } */
								isStacked: true,
								legend: { position: 'top', maxLines: 10 },
								bar: { groupWidth: '55%' },
							};

							var view = new google.visualization.DataView(data);
							view.setColumns([0,1,
								{ calc: "stringify",
									sourceColumn: 1,
									type: "string",
									role: "annotation" },
								2]);

							var chart = new google.visualization.BarChart(document.getElementById('us_div'));
							chart.draw(data, options);


							data1.addRow([
								'CDC Data',
								//parseInt(jdata[index].positive),
								//parseInt(jdata[index].negative),
								//parseInt(jdata[index].pending),
								parseInt(jdata[index].hospitalizedCurrently),
								parseInt(jdata[index].hospitalizedCumulative),
								parseInt(jdata[index].inIcuCurrently),
								parseInt(jdata[index].inIcuCumulative),
								parseInt(jdata[index].onVentilatorCurrently),
								parseInt(jdata[index].onVentilatorCumulative),
								parseInt(jdata[index].recovered),
								parseInt(jdata[index].death),
								parseInt(jdata[index].hospitalized),
								//parseInt(jdata[index].total),
								//parseInt(jdata[index].totalTestResults),
								//parseInt(jdata[index].posNeg),

							]);

							var chart = new google.visualization.BarChart(document.getElementById('us_div1'));
							chart.draw(data1, options);



						});


					});




				}


				async function showVisualizationMap(countryCode,NewConfirmed,TotalConfirmed,NewDeaths,TotalDeaths,NewRecovered,TotalRecovered)
				{
					//alert(data)




					posturl = "https://api.covid19api.com/live/country/"+countryCode+"/status/confirmed"

					if(countryCode == 'US')
					{
						SHOWUSStuff()
						SHOWUSStateStuff()
					}
					else {

						$('#us_div').empty();
						$('#us_div1').empty();
						$('#us_div2').empty();
					}

					//alert (posturl)

					/* $.ajax({
					 url: posturl,
					 dataType: "json",
					 }).done(function (jsonData) {

					 }); */

					$.getJSON(posturl, function(jdata) {

						var data = new google.visualization.DataTable();

						data.addColumn('number', 'Lat');
						data.addColumn('number', 'Long');
						data.addColumn('number', 'Confirmed');
						//data.addColumn('number', 'Deaths');
						//data.addColumn('number', 'Recovered');
						//data.addColumn('number', 'Active');
						data.addColumn({type:'string', role:'tooltip'});

						Country = ''

						$.each(jdata, function(index) {
							// console.log(jdata[index].Lat);
							// console.log(jdata[index].Lon);

							toolTipMessage = 'Province: ' + jdata[index].Province + '\n' + 'Confirmed: ' + jdata[index].Confirmed + '\n' + 'Deaths: ' + jdata[index].Deaths + '\n' + 'Recovered: ' + jdata[index].Recovered + '\n ' +  'Active: ' + jdata[index].Active + "\n"

							//Confirmed =  Confirmed+parseInt(jdata[index].Confirmed)
							//Deaths = Deaths + parseInt(jdata[index].Deaths)
							//Recovered = Recovered + parseInt(jdata[index].Recovered)
							//Active =  Active + parseInt(jdata[index].Active)
							Country = jdata[index].Country

							data.addRow([
								parseInt(jdata[index].Lat),
								parseInt(jdata[index].Lon),
								parseInt(jdata[index].Confirmed),
								//parseInt(jdata[index].Deaths),
								//parseInt(jdata[index].Recovered),
								//parseInt(jdata[index].Active),
								toolTipMessage,
							]);

						});


						var options = {
							colorAxis:  {minValue: 0, maxValue: 0,  colors: ['#6699CC']},
							legend: 'none',
							backgroundColor: {fill:'transparent',stroke:'#FFF' ,strokeWidth:0 },
							datalessRegionColor: '#f5f5f5',
							//displayMode: 'markers',
							enableRegionInteractivity: 'true',
							resolution: 'countries',
							sizeAxis: {minValue: 1, maxValue:1,minSize:5,  maxSize: 5},
							region:'world',
							keepAspectRatio: true,
							//width:400,
							//height:300,
							tooltip: {textStyle: {color: '#444444'}}
						};



						var chart = new   google.visualization.GeoChart(document.getElementById('visualization'));
						chart.draw(data, options);

						//alert(parseInt(NewConfirmed.replace(/,/g, '')))
						//alert(NewConfirmed)

						var data = google.visualization.arrayToDataTable([
									['Task', 'Corona Cases ' ,  { role: "style" }],
									['NewConfirmed',  parseInt(NewConfirmed.replace(/,/g, '')),"red"],
									['TotalConfirmed',     parseInt(TotalConfirmed.replace(/,/g, '')),"silver"],
									['NewDeaths', parseInt(NewDeaths.replace(/,/g, '')), "orange"],
									['TotalDeaths',    parseInt(TotalDeaths.replace(/,/g, '')), "green"],
									['NewRecovered',     parseInt(NewRecovered.replace(/,/g, '')), "gold"],
									['TotalRecovered',      parseInt(TotalRecovered.replace(/,/g, '')), "pink"],
								]
						);

						var view = new google.visualization.DataView(data);
						view.setColumns([0, 1,
							{ calc: "stringify",
								sourceColumn: 1,
								type: "string",
								role: "annotation" },
							2]);
						var options = {
							title: 'COVID-19 ' + Country + ' Status',
							// width: 700,
							// pieSliceText: 'label',
							legend: 'true',
						};
						var chart = new google.visualization.BarChart(document.getElementById('visualization1'));
						chart.draw(view, options);

						////TrendLines

						/**

						 var data = new google.visualization.DataTable();
						 data.addColumn('number', 'X');
						 //data.addColumn('number', 'Confirmed');
						 data.addColumn('number', 'Deaths');
						 data.addColumn('number', 'Recovered');
						 //data.addColumn('number', 'Active');


						 $.each(jdata, function(index) {
        		console.log('[' + index + ',' + jdata[index].Deaths + ']')
                 data.addRow([
                              index,
 							//parseInt(jdata[index].Confirmed),
 							parseInt(jdata[index].Deaths),
 							parseInt(jdata[index].Recovered),
 							//parseInt(jdata[index].Active),
 			    		    ]);

             });



						 var options = {
        	        hAxis: {
        	          title: 'Time'
        	        },
        	        vAxis: {
        	          title: 'Death vs Recovered'
        	        },
        	        colors: ['#AB0D06', '#007329'],
        	        trendlines: {
        	          0: {type: 'exponential', color: '#333', opacity: 1},
        	          1: {type: 'linear', color: '#111', opacity: .3}
        	        }
        	      };

						 var chart = new google.visualization.LineChart(document.getElementById('visualization2'));
						 chart.draw(data, options);

						 **/

						showCountrySpecficData(countryCode,Country)

						function showCountrySpecficData(countryCode,Country)
						{
							$('#output').html('<img src="images/712.GIF"> loading...');
							$('#output').show()

							var data = new google.visualization.DataTable();
							data.addColumn('date', 'Date');
							data.addColumn('number', 'Confirmed cases');

							var data1 = new google.visualization.DataTable();
							data1.addColumn('date', 'Date');
							data1.addColumn('number', 'Death');
							data1.addColumn('number', 'Recovered');

							posturl = 'https://corona.lmao.ninja/v2/historical/'+countryCode

							//console.log(posturl)

							$.getJSON(posturl, function(jdata) {


								var itemArray = []


								$.each(jdata, function(index) {

									//console.log(jdata[index])

									if (jdata[index].hasOwnProperty('cases')) {

										$.each(jdata[index].cases, function(index, element) {
											itemArray.push(index + '$$' + element)
										});
									}

									if (jdata[index].hasOwnProperty('deaths')) {

										i = 0
										$.each(jdata[index].deaths, function(index, element) {
											temp = itemArray[i]
											temp1 = temp.split('$$')
											if (temp1[0] === index) {
												//console.log(itemArray[i] + ' ' + index + ' ' + temp1[0] )
												itemArray[i] = itemArray[i] + '$$' + element
												//console.log(itemArray[i])
											} // End

											i++

										});

									} // End If

									if (jdata[index].hasOwnProperty('recovered')) {

										i = 0
										$.each(jdata[index].recovered, function(index, element) {
											temp = itemArray[i]
											temp1 = temp.split('$$')
											if (temp1[0] === index) {
												//console.log(itemArray[i] + ' ' + index + ' ' + temp1[0] )
												itemArray[i] = itemArray[i] + '$$' + element
												//console.log(itemArray[i])
											} // End

											i++

										});

									} // End If
									//console.log(itemArray)

									itemArray.forEach(deriveFunction);

									function deriveFunction(value) {
										//console.log(value)

										part = value.split('$$')
										var parts = part[0].split("/");
										var dt = new Date(parseInt('20' + parts[2]),
												parseInt(parts[0]) - 1,
												parseInt(parts[1]));
										//console.log('new Date('+parseInt('20' + parts[2]+'+,)'))



										//data.addRow([dt, parseInt(part[1]),parseInt(part[2]),parseInt(part[3])])
										data.addRow([dt, parseInt(part[1])])
										data1.addRow([dt, parseInt(part[2]),parseInt(part[3])])

										var options = {
											title: 'Trendline Confirm Cases Growth for ' + Country,
											//curveType: 'function',
											colors: ['#AB0D06', '#007329'],
											legend: {
												//position: 'bottom'
											},
											hAxis: {
												format: 'd MMM',
												title: 'Date'
											},
											vAxis: {
												title: 'Number of People'
											},
											trendlines: {
												0: {type: 'exponential', color: '#333', opacity: 1},
												1: {type: 'linear', color: '#111', opacity: .3}
											}
										};


										var chart = new google.visualization.LineChart(document.getElementById('visualization2'));



										chart.draw(data, options);


										var options = {
											title: ' Death / Recovered for ' + Country,
											//curveType: 'function',
											colors: ['#AB0D06', '#007329'],
											legend: {
												//position: 'bottom'
											},
											hAxis: {
												format: 'd MMM',
												title: 'Date'
											},
											vAxis: {
												title: 'Number of People'
											},
											/*  trendlines: {
											 0: {type: 'exponential', color: '#333', opacity: 1},
											 1: {type: 'linear', color: '#111', opacity: .3}
											 } */
										};

										var chart = new google.visualization.LineChart(document.getElementById('visualization3'));
										$('#output').empty();
										$('#output').hide();
										chart.draw(data1, options);


									} // end of deriveFunction


								}); // ENd of $ Each
							});



						}

					});
				}


			</script>



		</div>

		<%@ include file="thanks.jsp"%>
		<hr>

		<%@ include file="addcomments.jsp"%>

	</div>
	<!-- /#page-content-wrapper -->

</div>
<!-- /#wrapper -->

<!-- Bootstrap core JavaScript -->
<script src="vendor1/jquery/jquery.min.js"></script>
<script src="vendor1/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- Menu Toggle Script -->
<script>
	$("#menu-toggle").click(function(e) {
		e.preventDefault();
		$("#wrapper").toggleClass("toggled");
	});
</script>



</body>

</html>

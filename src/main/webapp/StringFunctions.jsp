<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Online String functions length,indexOf,toUpperCase,trim,palindrome,reverse,replace, hashing, base64,  hex, encode/decoding, hashing</title>
	<%@ include file="header-script.jsp"%>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
	<meta name="description"
		  content="Online String palindrome,revrese to UpperCase,Lowercase,trim,replace white characters, substring,indexOf,lastIndexOff,Miscellaneous String utility meth">
	<meta name="keywords" content="string functions, trim, lowercase, uppercase, base64, hex, hash, md5, sha1, sha256, sha512">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<script type="application/ld+json">
		{
			"@context": "https://schema.org",
			"@type": "WebPage",
			"name": "String Functions",
			"description": "This page provides various string manipulation functions such as trimming, case conversion, encoding, decoding, hashing, and more.",
			"image": "https://example.com/path/to/your/image.jpg"
		}
	</script>

</head>

<%@ include file="body-script.jsp"%>

<div class="container">
	<h1>String Functions</h1>
	<textarea id="inputText" class="form-control" rows="5" placeholder="Enter your text here..."></textarea>

	<div class="row">
		<div class="col-md-6">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="trimCheck">
				<label class="form-check-label" for="trimCheck">Trim</label>
			</div>
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="trimAllWhiteSpaceCheck">
				<label class="form-check-label" for="trimAllWhiteSpaceCheck">Trim All Whitespace</label>
			</div>
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="toLowerCaseCheck">
				<label class="form-check-label" for="toLowerCaseCheck">To Lowercase</label>
			</div>
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="toUpperCaseCheck">
				<label class="form-check-label" for="toUpperCaseCheck">To Uppercase</label>
			</div>
		</div>

		<div class="col-md-6">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="trimWhitespaceCheck">
				<label class="form-check-label" for="trimWhitespaceCheck">Trim Whitespace</label>
			</div>
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="trimLeadingWhitespaceCheck">
				<label class="form-check-label" for="trimLeadingWhitespaceCheck">Trim Leading Whitespace</label>
			</div>
			<div class="form-check mt-2">
				<input class="form-check-input" type="checkbox" id="trimTrailingWhitespaceCheck">
				<label class="form-check-label" for="trimTrailingWhitespaceCheck">Trim Trailing Whitespace</label>
			</div>
		</div>

	</div>

	<div class="row">
		<div class="col-md-6">
			<div class="form-check mt-2">
				<input class="form-check-input" type="checkbox" id="palindromeCheck">
				<label class="form-check-label" for="palindromeCheck">Palindrome</label>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-check mt-2">
				<input class="form-check-input" type="checkbox" id="reverseCheck">
				<label class="form-check-label" for="reverseCheck">Reverse</label>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-6">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="base64EncodeCheck">
				<label class="form-check-label" for="base64EncodeCheck">Encode to Base64</label>
			</div>
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="base64DecodeCheck">
				<label class="form-check-label" for="base64DecodeCheck">Decode from Base64</label>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="toHexCheck">
				<label class="form-check-label" for="toHexCheck">Convert to Hexadecimal</label>
			</div>
			<div class="form-check mt-2">
				<input class="form-check-input" type="checkbox" id="fromHexCheck">
				<label class="form-check-label" for="fromHexCheck">Convert from Hexadecimal</label>
			</div>
		</div>

		<div class="col-md-6">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="md5HashCheck">
				<label class="form-check-label" for="md5HashCheck">Md5 Hash</label>
			</div>
			<div class="form-check mt-2">
				<input class="form-check-input" type="checkbox" id="sha1HashCheck">
				<label class="form-check-label" for="sha1HashCheck">SHA-1 Hash</label>
			</div>
		</div>

		<div class="col-md-6">
			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="sha256HashCheck">
				<label class="form-check-label" for="sha256HashCheck">sha256Hashh</label>
			</div>
			<div class="form-check mt-2">
				<input class="form-check-input" type="checkbox" id="sha512HashCheck">
				<label class="form-check-label" for="sha512HashCheck">sha512Hash</label>
			</div>
		</div>

	</div>

	<%--	<div class="row">--%>
	<%--		<div class="col-md-6">--%>
	<%--			<div class="form-check">--%>
	<%--				<input type="checkbox" id="md5HashCheck">--%>
	<%--				<label class="form-check-label" for="md5HashCheck">MD5 Hash</label>--%>
	<%--			</div>--%>
	<%--			<div class="form-check">--%>
	<%--				<input type="checkbox" id="sha1HashCheck">--%>
	<%--				<label class="form-check-label" for="sha1HashCheck">SHA-1 Hash</label>--%>
	<%--			</div>--%>
	<%--		</div>--%>
	<%--		<div class="col-md-6">--%>
	<%--			<div class="form-check">--%>
	<%--				<input type="checkbox" id="sha256HashCheck"><br>--%>
	<%--				<label class="form-check-label" for="sha256HashCheck">SHA-256 Hash</label>--%>
	<%--			</div>--%>
	<%--			<div class="form-check">--%>
	<%--				<input type="checkbox" id="sha512HashCheck">--%>
	<%--				<label class="form-check-label" for="sha512HashCheck">SHA-512 Hash</label>--%>
	<%--			</div>--%>
	<%--		</div>--%>
	<%--	</div>--%>



	<div class="row mt-3">
		<div class="col">
			<div class="form-group">
				<label for="indexOfString">String IndexOf:</label>
				<input type="text" class="form-control" id="indexOfString" placeholder="Enter string to find index of">
			</div>
		</div>
		<div class="col">
			<div class="form-group">
				<label for="fromIndex">fromIndex:</label>
				<input type="number" class="form-control" id="fromIndex" placeholder="Optional: Enter fromIndex">
			</div>
		</div>
		<div class="col">
			<div class="form-group">
				<label for="lastIndexOf">String LastIndexOf:</label>
				<input type="text" class="form-control" id="lastIndexOf" placeholder="Enter string to find last index of">
			</div>
		</div>
		<div class="col">
			<div class="form-group">
				<label for="lastFromIndex">fromIndex:</label>
				<input type="number" class="form-control" id="lastFromIndex" placeholder="Optional: Enter fromIndex">
			</div>
		</div>
	</div>

	<div class="row mt-3">
		<div class="col">
			<div class="form-group">
				<label for="oldChar">String Replace:</label>
				<input type="text" class="form-control" id="oldChar" placeholder="Enter character to replace">
			</div>
		</div>
		<div class="col">
			<div class="form-group">
				<label for="newChar">newChar:</label>
				<input type="text" class="form-control" id="newChar" placeholder="Enter replacement character">
			</div>
		</div>
		<div class="col">
			<div class="form-group">
				<label for="regex">String ReplaceAll:</label>
				<input type="text" class="form-control" id="regex" placeholder="Enter regex pattern">
			</div>
		</div>
		<div class="col">
			<div class="form-group">
				<label for="replacement">replacement:</label>
				<input type="text" class="form-control" id="replacement" placeholder="Enter replacement string">
			</div>
		</div>
	</div>

	<div class="row mt-3">
		<div class="col">
			<div class="form-group">
				<label for="beginIndex">Substring: (from Index)</label>
				<input type="number" class="form-control" id="beginIndex" placeholder="Enter begin index">
			</div>
		</div>
		<div class="col">
			<div class="form-group">
				<label for="endIndex">endIndex:</label>
				<input type="number" class="form-control" id="endIndex" placeholder="Enter end index">
			</div>
		</div>
	</div>
	<%--	<div id="output" class="output">Length: 0</div>--%>
	<div class="row mt-3">
		<div class="col-md-12">
			<div class="output-box border p-3 bg-light">
				<div id="output">Length: 0</div>
			</div>
		</div>
	</div>
</div>

<script>

	function calculateMD5(str) {
		return CryptoJS.MD5(str).toString();
	}

	// Function to calculate SHA-1 hash
	function calculateSHA1(str) {
		return CryptoJS.SHA1(str).toString();
	}

	// Function to calculate SHA-256 hash
	function calculateSHA256(str) {
		return CryptoJS.SHA256(str).toString();
	}

	// Function to calculate SHA-512 hash
	function calculateSHA512(str) {
		return CryptoJS.SHA512(str).toString();
	}

	// Function to encode string to Base64
	function encodeToBase64(str) {
		return btoa(str);
	}

	// Function to decode Base64 to string
	function decodeBase64(str) {
		return atob(str);
	}

	// Function to convert string to hexadecimal
	function stringToHex(str) {
		let hex = '';
		for (let i = 0; i < str.length; i++) {
			hex += str.charCodeAt(i).toString(16);
		}
		return hex;
	}

	// Function to convert hexadecimal to string
	function hexToString(hex) {
		let str = '';
		for (let i = 0; i < hex.length; i += 2) {
			str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
		}
		return str;
	}

	function applyStringFunctions() {
		var input = document.getElementById('inputText').value;
		var output = "";

		output += "<strong>Length:</strong> <code> " + input.length + " </code><br>";

		var indexOfString = document.getElementById('indexOfString').value;
		var fromIndex = document.getElementById('fromIndex').value;
		if (indexOfString !== "") {
			output += "<strong>IndexOf( " + indexOfString  + "): </strong> <code> " + input.indexOf(indexOfString, fromIndex) + "</code><br>";
		}

		var lastIndexOfString = document.getElementById('lastIndexOf').value;
		var lastFromIndex = document.getElementById('lastFromIndex').value;
		if (lastIndexOfString !== "") {
			output += "<strong>LastIndexOf:( " + lastIndexOfString  + "): </strong> <code> " + input.lastIndexOf(lastIndexOfString, lastFromIndex) + "</code><br>";
		}

		var oldChar = document.getElementById('oldChar').value;
		var newChar = document.getElementById('newChar').value;
		if (oldChar !== "") {
			output += "<strong>Replace:( " + oldChar + "," + newChar  + "): </strong> <code> " +  input.replace(oldChar, newChar) + "</code><br>";
		}

		var regex = document.getElementById('regex').value;
		var replacement = document.getElementById('replacement').value;
		if (regex !== "") {
			output += "<strong>String ReplaceAll:( " + replacement  + "): </strong> <code> " +  input.replaceAll(new RegExp(regex, 'g'), replacement) + "</code><br>";
		}

		var beginIndex = document.getElementById('beginIndex').value;
		var endIndex = document.getElementById('endIndex').value;
		if (beginIndex !== "" && endIndex !== "") {
			output += "<strong>Substring:( " + beginIndex + "," +  endIndex + "): </strong> <code> " + input.substring(beginIndex, endIndex) + "</code><br>";
		}

		if (document.getElementById('trimCheck').checked) {
			output += "<strong>Trim:</strong> " + input.trim() + "<br>";
		}
		if (document.getElementById('trimAllWhiteSpaceCheck').checked) {
			output += "<strong>Trim All Whitespace:</strong> <code>" + input.replace(/\s/g, '') + "</code><br>";
		}
		if (document.getElementById('toLowerCaseCheck').checked) {
			output += "<strong>To Lowercase:</strong> <code>" + input.toLowerCase() + "</code><br>";
		}
		if (document.getElementById('toUpperCaseCheck').checked) {
			output += "<strong>To Uppercase:</strong> <code>" + input.toUpperCase() + "</code><br>";
		}
		if (document.getElementById('trimWhitespaceCheck').checked) {
			output += "<strong>Trim Whitespace:</strong> <code>" + input.replace(/^\s+|\s+$/g, '') + "</code><br>";
		}
		if (document.getElementById('trimLeadingWhitespaceCheck').checked) {
			output += "<strong>Trim Leading Whitespace:</strong> <code> " + input.replace(/^\s+/g, '') + " </code><br>";
		}
		if (document.getElementById('trimTrailingWhitespaceCheck').checked) {
			output += "<strong>Trim Trailing Whitespace:</strong> <cocde> " + input.replace(/\s+$/g, '') + " </code><br>";
		}
		if (document.getElementById('palindromeCheck').checked) {
			var reversed = input.split('').reverse().join('');
			var palindromeResult = (input === reversed) ? 'Yes, it is a palindrome' : 'No, it is not a palindrome';
			output += "<strong>Palindrome:</strong> <code> " + palindromeResult + "</code><br>";
		}
		if (document.getElementById('reverseCheck').checked) {
			output += "<strong>Reverse:</strong> <code> " + input.split('').reverse().join('') + " </code><br>";
		}

		// Base64 Encoding
		if (document.getElementById('base64EncodeCheck').checked) {
			output += "<strong>Base64 Encoded:</strong> <code> " + encodeToBase64(input) + "</code><br>";
		}

		// Base64 Decoding
		if (document.getElementById('base64DecodeCheck').checked) {
			output += "<strong>Base64 Decoded:</strong> <code>" + decodeBase64(input) + " </code><br>";
		}

		// Hexadecimal Conversion
		if (document.getElementById('toHexCheck').checked) {
			output += "<strong>Hexadecimal:</strong> <code> " + stringToHex(input) + " </code><br>";
		}

		// Hexadecimal to String
		if (document.getElementById('fromHexCheck').checked) {
			output += "<strong>From Hexadecimal:</strong> <code>" + hexToString(input) + " </code><br>";
		}

		// MD5 Hashing
		if (document.getElementById('md5HashCheck').checked) {
			output += "<strong>MD5 Hash:</strong> <code> " + calculateMD5(input) + "</code><br>";
		}

		// SHA-1 Hashing
		if (document.getElementById('sha1HashCheck').checked) {
			output += "<strong>SHA-1 Hash:</strong> <code> " + calculateSHA1(input) + " </code><br>";
		}

		// SHA-256 Hashing
		if (document.getElementById('sha256HashCheck').checked) {
			output += "<strong>SHA-256 Hash:</strong> <code> " + calculateSHA256(input) + "</code><br>";
		}

		// SHA-512 Hashing
		if (document.getElementById('sha512HashCheck').checked) {
			output += "<strong>SHA-512 Hash:</strong> <code> " + calculateSHA512(input) + "</code><br>";
		}

		document.getElementById('output').innerHTML = output;
	}

	// Add event listener to checkboxes
	var checkboxes = document.querySelectorAll('input[type=checkbox]');
	checkboxes.forEach(function(checkbox) {
		checkbox.addEventListener('change', applyStringFunctions);
	});

	// Add event listener to input field
	document.getElementById('inputText').addEventListener('input', function() {
		var input = this.value;
		var lengthOutput = "Length: " + input.length;
		document.getElementById('output').innerHTML = lengthOutput;
		applyStringFunctions();
	});

	// Add event listener to form elements
	var formElements = document.querySelectorAll('.form-control');
	formElements.forEach(function(element) {
		element.addEventListener('input', applyStringFunctions);
	});

</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
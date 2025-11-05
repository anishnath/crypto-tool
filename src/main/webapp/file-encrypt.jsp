<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
        <title>Encrypt & Decrypt Files Online – AES‑256, No Uploads (Browser‑Only)</title>
		<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
		 <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
         <meta name="keywords" content="file encryption online, encrypt file in browser, AES 256 encryption, decrypt file online, password protect file, client-side encryption, secure file tool, PBKDF2, WebCrypto, drag and drop encrypt">
    	<meta name="description" content="Free online file encryption and decryption. AES‑256 with PBKDF2, runs 100% in your browser, no file uploads. Drag & drop, strong passwords, save encrypted .enc files securely.">
         <link rel="canonical" href="https://8gwifi.org/file-encrypt.jsp">
         <meta name="robots" content="index,follow">
         <meta property="og:title" content="Encrypt & Decrypt Files Online – AES‑256, No Uploads">
         <meta property="og:description" content="Client‑side AES‑256 file encryption/decryption with PBKDF2. Works entirely in your browser—nothing uploaded.">
         <meta property="og:type" content="website">
         <meta property="og:url" content="https://8gwifi.org/file-encrypt.jsp">
         <meta property="og:image" content="https://8gwifi.org/images/site/file-encrypt.png">
         <meta name="twitter:card" content="summary_large_image">
         <meta name="twitter:title" content="Encrypt & Decrypt Files Online – AES‑256, No Uploads">
         <meta name="twitter:description" content="Secure, browser‑only AES‑256 file encryption/decryption with PBKDF2. Drag & drop, no uploads.">
         <meta name="twitter:image" content="https://8gwifi.org/images/site/file-encrypt.png">
    	
    	   <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": "Online File Encryption (AES‑256)",
            "description": "Free client‑side file encryption/decryption. AES‑256 with PBKDF2 (SHA‑256), drag & drop, no uploads.",
            "url": "https://8gwifi.org/file-encrypt.jsp",
			"image" : "https://8gwifi.org/images/site/file-encrypt.png",
            "applicationCategory": "SecurityApplication",
            "operatingSystem": "All",
            "version": "1.0",
            "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
            "featureList": [
              "AES‑256 (CBC) encryption",
              "PBKDF2‑SHA256 key derivation",
              "Browser‑only, no server uploads",
              "Drag & drop files",
              "Strong password generator"
            ],
            "author": {
                "@type": "Person",
                "name": "Anish Nathe"
            }
        }
    </script>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "Are my files uploaded or stored?",
          "acceptedAnswer": {"@type": "Answer", "text": "No. All encryption and decryption run locally in your browser using the WebCrypto API. Files are never uploaded or stored on our servers."}
        },
        {
          "@type": "Question",
          "name": "What encryption does this tool use?",
          "acceptedAnswer": {"@type": "Answer", "text": "AES‑256 (CBC) with keys derived via PBKDF2 using SHA‑256 and a random salt. Encrypted downloads use a .enc file extension."}
        },
        {
          "@type": "Question",
          "name": "How do I encrypt a file?",
          "acceptedAnswer": {"@type": "Answer", "text": "Choose Encrypt, enter a strong password or generate one, then drag & drop your file or click to select it. Click Encrypt File to download the .enc file."}
        },
        {
          "@type": "Question",
          "name": "How do I decrypt and keep the original extension?",
          "acceptedAnswer": {"@type": "Answer", "text": "Choose Decrypt, enter the same password, and drop the .enc file. The tool removes trailing .enc/.dec so the original filename and extension are preserved."}
        }
      ]
    }
    </script>
    
		 <%@ include file="header-script.jsp"%>
	</head>
		
	<style>
    /* Scoped styling for a cleaner, consistent layout */
    .fe .card-header { padding: .6rem .9rem; font-weight: 600; }
    .fe .card-body { padding: .9rem; }
    .fe .form-group { margin-bottom: .6rem; }
    .fe .help { color: #6c757d; font-size: .9rem; }
    .fe .btn-group .btn { min-width: 140px; }

    /* Dropzone styling similar to Base32 page */
    .fe .dropzone { border: 2px dashed #cbd5e1; border-radius: 8px; padding: .9rem; text-align: center; color: #64748b; cursor: pointer; }
    .fe .dropzone.drag { background: #f1f5f9; }

    /* Status chips */
    .fe .status { font-weight: 600; }
	</style>
	
	<%@ include file="body-script.jsp"%>
		
			<div class="container mt-4 fe">
    <div class="mb-3">
      <h1 class="mb-1">File Encryption / Decryption</h1>
      <p class="text-muted mb-2">Use your web browser to encrypt and decrypt files. All processing happens locally in your browser.</p>
      <div class="d-flex align-items-center">
        <div class="btn-group btn-group-toggle mr-2" data-toggle="buttons">
          <button id="btnDivEncrypt" class="btn btn-outline-primary btn-sm active" onClick="javascript:switchdiv('encrypt');">Encrypt</button>
          <button id="btnDivDecrypt" class="btn btn-outline-primary btn-sm" onClick="javascript:switchdiv('decrypt');">Decrypt</button>
        </div>
        <button id="btnRefresh" class="btn btn-secondary btn-sm" onClick="javascript:location.reload();">Refresh</button>
      </div>
    </div>
  </div>
			
		
		<div class="container fe" id="divEncryptfile">
    <div class="card mb-3">
      <h5 class="card-header">Encrypt a File</h5>
      <div class="card-body">
        <p class="help mb-3">Enter a strong password (8+ chars), then drop your file below to encrypt it locally in your browser.</p>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="txtEncpassphrase">Password <span class="text-danger">*</span></label>
            <div class="input-group input-group-sm">
              <input id="txtEncpassphrase" type="password" required class="form-control" onkeyup="javascript:encvalidate();" value="">
              <div class="input-group-append">
                <button class="btn btn-outline-secondary" type="button" id="btnGenEnc" title="Generate strong password" onclick="genStrongPassword();">Generate</button>
                <button class="btn btn-outline-secondary" type="button" title="Copy" onclick="copyField('txtEncpassphrase', this);" aria-label="Copy password">
                  <!-- copy icon (inline SVG) -->
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M16 1H4C2.9 1 2 1.9 2 3V15H4V3H16V1ZM19 5H8C6.9 5 6 5.9 6 7V19C6 20.1 6.9 21 8 21H19C20.1 21 21 20.1 21 19V7C21 5.9 20.1 5 19 5ZM19 19H8V7H19V19Z"/></svg>
                </button>
                <button class="btn btn-outline-secondary" type="button" title="Show/Hide" onclick="toggleVisibility('txtEncpassphrase', this);" aria-label="Show or hide password">
                  <svg class="eye" width="16" height="16" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M12 5c-7 0-11 7-11 7s4 7 11 7 11-7 11-7-4-7-11-7zm0 12a5 5 0 110-10 5 5 0 010 10z"/><circle cx="12" cy="12" r="3"/></svg>
                </button>
              </div>
            </div>
            <small class="form-text text-muted">Minimum 8 characters</small>
          </div>
          <div class="form-group col-md-6">
            <label for="txtEncpassphraseretype">Password (retype) <span class="text-danger">*</span></label>
            <div class="input-group input-group-sm">
              <input id="txtEncpassphraseretype" type="password" required class="form-control" onkeyup="javascript:encvalidate();" value="">
              <div class="input-group-append">
                <button class="btn btn-outline-secondary" type="button" title="Copy" onclick="copyField('txtEncpassphraseretype', this);" aria-label="Copy password retype">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M16 1H4C2.9 1 2 1.9 2 3V15H4V3H16V1ZM19 5H8C6.9 5 6 5.9 6 7V19C6 20.1 6.9 21 8 21H19C20.1 21 21 20.1 21 19V7C21 5.9 20.1 5 19 5ZM19 19H8V7H19V19Z"/></svg>
                </button>
                <button class="btn btn-outline-secondary" type="button" title="Show/Hide" onclick="toggleVisibility('txtEncpassphraseretype', this);" aria-label="Show or hide password">
                  <svg class="eye" width="16" height="16" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M12 5c-7 0-11 7-11 7s4 7 11 7 11-7 11-7-4-7-11-7zm0 12a5 5 0 110-10 5 5 0 010 10z"/><circle cx="12" cy="12" r="3"/></svg>
                </button>
              </div>
            </div>
            <span class="ml-2" id="spnCheckretype"></span>
          </div>
        </div>

        <div class="mb-3">
          <div class="dropzone" id="encdropzone" ondrop="drop_handler(event);" ondragover="dragover_handler(event);" ondragend="dragend_handler(event);" ondragenter="dragenter_handler(event);" ondragleave="dragleave_handler(event);" onclick="javascript:encfileElem.click();">
            <div>Drag & drop a file here or <u>click to select</u></div>
            <div class="mt-1"><span id="spnencfilename"></span></div>
          </div>
          <input type="file" id="encfileElem" style="display:none" onchange="selectfile(this.files)">
        </div>

        <div class="d-flex align-items-center flex-wrap">
          <button id="btnEncrypt" onclick="javascript:encryptfile();" class="btn btn-primary mr-2" disabled title="Enter password (min 8), match retype, and select a file">Encrypt File</button>
          <span id="spnEncstatus" class="status mr-3"></span>
          <small id="encReqMsg" class="text-muted">Enter password (min 8), confirm it, and select a file to enable.</small>
        </div>

        <div class="mt-3">
          <a id="aEncsavefile" hidden><button class="btn btn-success">Save Encrypted File</button></a>
        </div>
      </div>
    </div>
  </div>
		
	<div class="container fe" id="divDecryptfile">
    <div class="card mb-3">
      <h5 class="card-header">Decrypt a File</h5>
      <div class="card-body">
        <p class="help mb-3">Use the same password that was used to encrypt the file, then drop the encrypted file below to decrypt it locally.</p>

        <div class="form-group col-md-6 p-0">
          <label for="txtDecpassphrase">Password <span class="text-danger">*</span></label>
          <div class="input-group input-group-sm">
            <input id="txtDecpassphrase" type="password" required class="form-control" onkeyup="javascript:decvalidate();" value=''>
            <div class="input-group-append">
              <button class="btn btn-outline-secondary" type="button" title="Copy" onclick="copyField('txtDecpassphrase', this);" aria-label="Copy password">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M16 1H4C2.9 1 2 1.9 2 3V15H4V3H16V1ZM19 5H8C6.9 5 6 5.9 6 7V19C6 20.1 6.9 21 8 21H19C20.1 21 21 20.1 21 19V7C21 5.9 20.1 5 19 5ZM19 19H8V7H19V19Z"/></svg>
              </button>
              <button class="btn btn-outline-secondary" type="button" title="Show/Hide" onclick="toggleVisibility('txtDecpassphrase', this);" aria-label="Show or hide password">
                <svg class="eye" width="16" height="16" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M12 5c-7 0-11 7-11 7s4 7 11 7 11-7 11-7-4-7-11-7zm0 12a5 5 0 110-10 5 5 0 010 10z"/><circle cx="12" cy="12" r="3"/></svg>
              </button>
            </div>
          </div>
        </div>

        <div class="mb-3">
          <div class="dropzone" id="decdropzone" ondrop="drop_handler(event);" ondragover="dragover_handler(event);" ondragend="dragend_handler(event);" ondragenter="dragenter_handler(event);" ondragleave="dragleave_handler(event);" onclick="javascript:decfileElem.click();">
            <div>Drag & drop the encrypted file here or <u>click to select</u></div>
            <div class="mt-1"><span id="spndecfilename"></span></div>
          </div>
          <input type="file" id="decfileElem" style="display:none" onchange="selectfile(this.files)">
        </div>

        <div class="d-flex align-items-center flex-wrap">
          <button id="btnDecrypt" onclick="javascript:decryptfile();" class="btn btn-primary mr-2" disabled title="Enter password and select a file">Decrypt File</button>
          <span id="spnDecstatus" class="status mr-3"></span>
          <small id="decReqMsg" class="text-muted">Enter password and select a file to enable.</small>
        </div>

        <div class="mt-3">
          <a id="aDecsavefile" hidden><button class="btn btn-success">Save Decrypted File</button></a>
        </div>
      </div>
    </div>
  </div>
		

  <div class="container fe">
    <div class="card mb-3">
      <h5 class="card-header">How Encryption/Decryption Works</h5>
      <div class="card-body">
        <p class="mb-2">This tool performs all cryptography locally in your browser using the WebCrypto API. Nothing is uploaded to a server.</p>
        <ul class="mb-2">
          <li><b>Key derivation:</b> Your password is converted to a 384‑bit stream via PBKDF2‑SHA256 with a random 8‑byte salt and 10,000 iterations. The first 32 bytes form the AES‑256 key; the next 16 bytes form the IV.</li>
          <li><b>Encryption:</b> The file bytes are encrypted using AES‑256 in CBC mode. The output format is <code>"Salted__" | salt(8) | ciphertext</code>, compatible with many tools.</li>
          <li><b>Decryption:</b> The salt is read from the first 16 bytes (after the <code>"Salted__"</code> header), the same PBKDF2 parameters are applied to rebuild the key/IV, and the ciphertext is decrypted.</li>
          <li><b>File naming:</b> Encrypted downloads use the <code>.enc</code> extension. When decrypting, trailing <code>.dec</code> and <code>.enc</code> are removed to restore the original filename and extension.</li>
          <li><b>Privacy:</b> Keys and file data never leave your device. Closing the tab clears all in‑memory state.</li>
        </ul>
        <p class="text-muted mb-0">Tip: Use a long, unique password. The built‑in generator creates strong, random passwords with a balanced mix of characters.</p>
      </div>
    </div>
  </div>

<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>


<script type="text/javascript">
	var mode=null;
	var objFile=null;
	switchdiv('encrypt');

	function switchdiv(t) {
		if(t=='encrypt') {
			divEncryptfile.style.display='block';
			divDecryptfile.style.display='none';
			btnDivEncrypt.disabled=true;
			btnDivDecrypt.disabled=false;
			mode='encrypt';
		} else if(t=='decrypt') {
			divEncryptfile.style.display='none';
			divDecryptfile.style.display='block';
			btnDivEncrypt.disabled=false;
			btnDivDecrypt.disabled=true;
			mode='decrypt';
		}
	}

	function encvalidate() {
		var okLen = txtEncpassphrase.value.length>=8;
		var okMatch = txtEncpassphrase.value==txtEncpassphraseretype.value;
		if(okLen && okMatch) { 
		  spnCheckretype.classList.add("greenspan");
		  spnCheckretype.classList.remove("redspan");
		  spnCheckretype.innerHTML='&#10004;';
		} else { 
		  spnCheckretype.classList.remove("greenspan");
		  spnCheckretype.classList.add("redspan");
  		  spnCheckretype.innerHTML='&#10006;';
		}

		var msg = '';
		if(!okLen) msg = 'Password (min 8) required';
		else if(!okMatch) msg = 'Passwords must match';
		else if(!objFile) msg = 'Select a file to encrypt';
		if(typeof encReqMsg !== 'undefined') {
			encReqMsg.textContent = msg || '';
			if(msg){ encReqMsg.classList.remove('text-success'); encReqMsg.classList.add('text-danger'); }
			else { encReqMsg.classList.remove('text-danger'); encReqMsg.classList.add('text-success'); encReqMsg.textContent='Ready'; }
		}

		if( okLen && okMatch && objFile ) { btnEncrypt.disabled=false; } else { btnEncrypt.disabled=true; }
	}

	function decvalidate() {
		var ok = txtDecpassphrase.value.length>0 && objFile;
		if(typeof decReqMsg !== 'undefined') {
			if(!txtDecpassphrase.value.length) { decReqMsg.textContent='Password required'; decReqMsg.classList.add('text-danger'); decReqMsg.classList.remove('text-success'); }
			else if(!objFile) { decReqMsg.textContent='Select a file to decrypt'; decReqMsg.classList.add('text-danger'); decReqMsg.classList.remove('text-success'); }
			else { decReqMsg.textContent='Ready'; decReqMsg.classList.add('text-success'); decReqMsg.classList.remove('text-danger'); }
		}
		btnDecrypt.disabled = !ok;
	}

	//drag and drop functions:
	//https://developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API/File_drag_and_drop
	function drop_handler(ev) {
		console.log("Drop");
		ev.preventDefault();
		try { if(ev.currentTarget && ev.currentTarget.classList) ev.currentTarget.classList.remove('drag'); } catch(e){}
		// If dropped items aren't files, reject them
		var dt = ev.dataTransfer;
		if (dt.items) {
			// Use DataTransferItemList interface to access the file(s)
			for (var i=0; i < dt.items.length; i++) {
				if (dt.items[i].kind == "file") {
					var f = dt.items[i].getAsFile();
					console.log("... file[" + i + "].name = " + f.name);
					objFile=f;
				}
			}
		} else {
			// Use DataTransfer interface to access the file(s)
			for (var i=0; i < dt.files.length; i++) {
				console.log("... file[" + i + "].name = " + dt.files[i].name);
			}  
			objFile=file[0];
		}		 
		displayfile()
		if(mode=='encrypt') { encvalidate(); } else if(mode=='decrypt') { decvalidate(); }
	}

	function dragover_handler(ev) {
		console.log("dragOver");
		// Prevent default select and drag behavior
		ev.preventDefault();
		try { if(ev.currentTarget && ev.currentTarget.classList) ev.currentTarget.classList.add('drag'); } catch(e){}
	}

	function dragend_handler(ev) {
		console.log("dragEnd");
		// Remove all of the drag data
		var dt = ev.dataTransfer;
		if (dt.items) {
			// Use DataTransferItemList interface to remove the drag data
			for (var i = 0; i < dt.items.length; i++) {
				dt.items.remove(i);
			}
		} else {
			// Use DataTransfer interface to remove the drag data
			ev.dataTransfer.clearData();
		}
		try { if(ev.currentTarget && ev.currentTarget.classList) ev.currentTarget.classList.remove('drag'); } catch(e){}
	}

	function dragenter_handler(ev) {
		try { if(ev.currentTarget && ev.currentTarget.classList) ev.currentTarget.classList.add('drag'); } catch(e){}
	}

	function dragleave_handler(ev) {
		try { if(ev.currentTarget && ev.currentTarget.classList) ev.currentTarget.classList.remove('drag'); } catch(e){}
	}

	function selectfile(Files) {
		objFile=Files[0];
		displayfile()
		if(mode=='encrypt') { encvalidate(); } else if(mode=='decrypt') { decvalidate(); }
	}

	function displayfile() {
		var s;
		var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
		var bytes=objFile.size;
		var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
		if(i==0) { s=bytes + ' ' + sizes[i]; } else { s=(bytes / Math.pow(1024, i)).toFixed(2) + ' ' + sizes[i]; }

		if(mode=='encrypt') { 
			spnencfilename.textContent=objFile.name + ' (' + s + ')'; 
		} else if(mode=='decrypt') {  
			spndecfilename.textContent=objFile.name + ' (' + s + ')'; 
		} 
	}

	function readfile(file){
		return new Promise((resolve, reject) => {
			var fr = new FileReader();  
			fr.onload = () => {
				resolve(fr.result )
			};
			fr.readAsArrayBuffer(file);
		});
	}

	async function encryptfile() {
		btnEncrypt.disabled=true;

		var plaintextbytes=await readfile(objFile)
		.catch(function(err){
			console.error(err);
		});	
		var plaintextbytes=new Uint8Array(plaintextbytes);

		var pbkdf2iterations=10000;
		var passphrasebytes=new TextEncoder("utf-8").encode(txtEncpassphrase.value);
		var pbkdf2salt=window.crypto.getRandomValues(new Uint8Array(8));

		var passphrasekey=await window.crypto.subtle.importKey('raw', passphrasebytes, {name: 'PBKDF2'}, false, ['deriveBits'])
		.catch(function(err){
			console.error(err);
		});
		console.log('passphrasekey imported');

		var pbkdf2bytes=await window.crypto.subtle.deriveBits({"name": 'PBKDF2', "salt": pbkdf2salt, "iterations": pbkdf2iterations, "hash": 'SHA-256'}, passphrasekey, 384)		
		.catch(function(err){
			console.error(err);
		});
		console.log('pbkdf2bytes derived');
		pbkdf2bytes=new Uint8Array(pbkdf2bytes);

		keybytes=pbkdf2bytes.slice(0,32);
		ivbytes=pbkdf2bytes.slice(32);

		var key=await window.crypto.subtle.importKey('raw', keybytes, {name: 'AES-CBC', length: 256}, false, ['encrypt']) 
		.catch(function(err){
			console.error(err);
		});
		console.log('key imported');		

		var cipherbytes=await window.crypto.subtle.encrypt({name: "AES-CBC", iv: ivbytes}, key, plaintextbytes)
		.catch(function(err){
			console.error(err);
		});

		if(!cipherbytes) {
		 	spnEncstatus.classList.add("redspan");
			spnEncstatus.innerHTML='<p>Error encrypting file.  See console log.</p>';
			return;
		}

		console.log('plaintext encrypted');
		cipherbytes=new Uint8Array(cipherbytes);

		var resultbytes=new Uint8Array(cipherbytes.length+16)
		resultbytes.set(new TextEncoder("utf-8").encode('Salted__'));
		resultbytes.set(pbkdf2salt, 8);
		resultbytes.set(cipherbytes, 16);

		var blob=new Blob([resultbytes], {type: 'application/download'});
		var blobUrl=URL.createObjectURL(blob);
		aEncsavefile.href=blobUrl;
		aEncsavefile.download=objFile.name + '.enc';

	 	spnEncstatus.classList.add("greenspan");
		spnEncstatus.innerHTML='<p>File encrypted.</p>';
		aEncsavefile.hidden=false;
	}

	// Generate a strong password and populate both encrypt fields
	function genStrongPassword() {
		var pass = generatePassword(20);
		try {
			txtEncpassphrase.value = pass;
			txtEncpassphraseretype.value = pass;
			encvalidate();
		} catch(e){}
	}

	function generatePassword(length) {
		length = length || 20;
		var lowers = 'abcdefghijklmnopqrstuvwxyz';
		var uppers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		var digits = '0123456789';
		var symbols = '!@#$%^&*()-_=+[]{};:,.<>?';
		var all = lowers + uppers + digits + symbols;
		var arr = new Uint32Array(length);
		if (window.crypto && window.crypto.getRandomValues) {
			window.crypto.getRandomValues(arr);
		} else {
			for (var i=0;i<length;i++) arr[i] = Math.floor(Math.random()*0xffffffff);
		}
		var res = [];
		// ensure at least one of each category
		res.push(lowers[arr[0]%lowers.length]);
		res.push(uppers[arr[1]%uppers.length]);
		res.push(digits[arr[2]%digits.length]);
		res.push(symbols[arr[3]%symbols.length]);
		for (var i=4;i<length;i++) {
			res.push(all[arr[i]%all.length]);
		}
		// shuffle
		for (var j=res.length-1;j>0;j--) {
			var k = arr[j] % (j+1);
			var tmp = res[j]; res[j]=res[k]; res[k]=tmp;
		}
		return res.join('');
	}

	function copyField(id) {
		try {
			var el = document.getElementById(id);
			var btn = arguments[1];
			if(!el) return;
			var val = el.value || '';
			if(navigator.clipboard && navigator.clipboard.writeText) {
				navigator.clipboard.writeText(val).then(function(){ showCopied(btn); });
			} else {
				var ta = document.createElement('textarea');
				ta.value = val; document.body.appendChild(ta); ta.select();
				try { document.execCommand('copy'); } catch(e) {}
				document.body.removeChild(ta);
				showCopied(btn);
			}
		} catch(e){}
	}

	function showCopied(btn){
		try {
			if(!btn) return;
			if (window.jQuery && $(btn).tooltip) {
				$(btn).tooltip({title:'Copied!', trigger:'manual', placement:'top'});
				$(btn).tooltip('show');
				setTimeout(function(){ try { $(btn).tooltip('hide').tooltip('dispose'); } catch(e){} }, 900);
			} else {
				var orig = btn.getAttribute('data-orig-html');
				if(!orig){ orig = btn.innerHTML; btn.setAttribute('data-orig-html', orig); }
				btn.innerHTML = 'Copied!';
				setTimeout(function(){ btn.innerHTML = btn.getAttribute('data-orig-html'); }, 900);
			}
		} catch(e){}
	}

	function toggleVisibility(id, btn){
		try {
			var el = document.getElementById(id);
			if(!el) return;
			if(el.type === 'password'){
				el.type = 'text';
				if(btn) btn.innerHTML = '<svg class="eye-off" width="16" height="16" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M2 5l2-2 17 17-2 2-3.1-3.1C14.3 19.3 13.2 19.5 12 19.5 5 19.5 1 12.5 1 12.5c.9-1.6 2.2-3.1 3.7-4.3l-2-2zM12 6.5c2.2 0 4.3.7 6.1 2l-2.2 2.2c-.4-.3-.8-.5-1.3-.6-.3-.1-.7-.1-1-.1-2.2 0-4 1.8-4 4 0 .3 0 .7.1 1 .1.5.3.9.6 1.3L7.3 19C9.1 20 10.9 20.5 12 20.5c7 0 11-7 11-7s-1.1-1.8-3-3.6L18.5 12l-2-2 2.4-2.4C16.6 6.9 14.5 6.5 12 6.5z"/></svg>';
			} else {
				el.type = 'password';
				if(btn) btn.innerHTML = '<svg class="eye" width="16" height="16" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M12 5c-7 0-11 7-11 7s4 7 11 7 11-7 11-7-4-7-11-7zm0 12a5 5 0 110-10 5 5 0 010 10z"/><circle cx="12" cy="12" r="3"/></svg>';
			}
		} catch(e){}
	}

	async function decryptfile() {
		btnDecrypt.disabled=true;

		var cipherbytes=await readfile(objFile)
		.catch(function(err){
			console.error(err);
		});	
		var cipherbytes=new Uint8Array(cipherbytes);

		var pbkdf2iterations=10000;
		var passphrasebytes=new TextEncoder("utf-8").encode(txtDecpassphrase.value);
		var pbkdf2salt=cipherbytes.slice(8,16);


		var passphrasekey=await window.crypto.subtle.importKey('raw', passphrasebytes, {name: 'PBKDF2'}, false, ['deriveBits'])
		.catch(function(err){
			console.error(err);

		});
		console.log('passphrasekey imported');

		var pbkdf2bytes=await window.crypto.subtle.deriveBits({"name": 'PBKDF2', "salt": pbkdf2salt, "iterations": pbkdf2iterations, "hash": 'SHA-256'}, passphrasekey, 384)		
		.catch(function(err){
			console.error(err);
		});
		console.log('pbkdf2bytes derived');
		pbkdf2bytes=new Uint8Array(pbkdf2bytes);

		keybytes=pbkdf2bytes.slice(0,32);
		ivbytes=pbkdf2bytes.slice(32);
		cipherbytes=cipherbytes.slice(16);

		var key=await window.crypto.subtle.importKey('raw', keybytes, {name: 'AES-CBC', length: 256}, false, ['decrypt']) 
		.catch(function(err){
			console.error(err);
		});
		console.log('key imported');		

		var plaintextbytes=await window.crypto.subtle.decrypt({name: "AES-CBC", iv: ivbytes}, key, cipherbytes)
		.catch(function(err){
			console.error(err);
		});

		if(!plaintextbytes) {
		 	spnDecstatus.classList.add("redspan");
			spnDecstatus.innerHTML='<p>Error decrypting file.  Password may be incorrect.</p>';
			return;
		}

		console.log('ciphertext decrypted');
		plaintextbytes=new Uint8Array(plaintextbytes);

		var blob=new Blob([plaintextbytes], {type: 'application/download'});
		var blobUrl=URL.createObjectURL(blob);
		aDecsavefile.href=blobUrl;
		aDecsavefile.download=stripEncDec(objFile.name);

	 	spnDecstatus.classList.add("greenspan");
		spnDecstatus.innerHTML='<p>File decrypted.</p>';
		aDecsavefile.hidden=false;
	}

	function stripEncDec(name) {
		if(!name) return 'decrypted.bin';
		var n = name;
		var lower = n.toLowerCase();
		if (lower.endsWith('.dec')) { n = n.slice(0,-4); lower = n.toLowerCase(); }
		if (lower.endsWith('.enc')) { n = n.slice(0,-4); }
		return n;
	}

</script>

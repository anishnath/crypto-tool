<%--
  Created by IntelliJ IDEA.
  User: anish
  Date: 21/11/23
  Time: 12:37 pm
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- <link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"> -->

	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<!-- Meta Tags for SEO -->
<meta name="description"
	content="share file with pgp , pgp encrption file share service">
<meta name="keywords"
	content="share file with pgp, pgp encrption file share service">
<title>Share file with PGP Encryption online</title>

<%@ include file="header-script.jsp"%>
<!-- 	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script> -->

	<!-- Include OpenPGP.js -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/openpgp/4.10.10/openpgp.min.js"></script>
	<script src="js/pgp-upload.js"></script>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.10/clipboard.min.js"></script>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
    {
        "@context": "http://schema.org",
        "@type": "WebPage",
        "name": "Send encrypted pgg files",
        "description": "share file using pgp ",
        "url": "https://8gwifi.org/pgp-upload.jsp",
        "image": "https://8gwifi.org/images/pgp-upload.png",
        "keywords": "file upload, pgp file upload and share, transfer encrypted file with pgp"
    }
    </script>

</head>
<%@ include file="body-script.jsp"%>
<h1 class="mt-4">Transfer files using pgp encryption</h1>
<p>Send and share large files and other documents quickly and securely with our PGP publically file transfer solution. </p>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<%@ include file="footer_adsense.jsp"%>

<hr>

		<form id="uploadForm" enctype="multipart/form-data">
			<div class="form-group">
				<label for="file">Choose File:</label> <input type="file"
					class="form-control-file" id="file" name="file">
			</div>

			<!-- Add Email Input -->
			<div class="form-group">
				<label for="email">Email:</label> <input type="email"
					class="form-control" id="email" name="email" placeholder="Type your email"
					value="" required>
			</div>

			<!-- Add Textarea for PGP Public Keys -->
			<div class="form-group">
				<label for="pgpKeys">PGP Public Keys:</label>
				<textarea class="form-control" id="pgpKeys" name="pgpKeys" rows="7"
					required>-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EZe2QiQEEAKiZnLZkugOZhU7Lw5K7ZezGVeGAV4rO/RdxE0eruHOm6g87V2pQ
+1zA6CPojk3yyaHabjUNvtYWqD9g2Vk595v2iG/OxZ5/6qzpXUDIeS2z/etT3k8i
dzZH01/K21JW3NIpSrVBB3m7osfAT/VTi7PISf05ZhgQ1wHAnCIuAEIFABEBAAG0
BWFuaXNoiJwEEAECAAYFAmXtkIkACgkQlusdronXgTRWSgP+Ju4B0XJUR3yVUMsj
utiHUBgzAcfdHBjcmQgBxGjpWwPCx8PzIem11OrDfzDmDynetTzyOLgZOmpEsgdY
mnvy6YZuJS2ukOPgmYH+AlhIKR3DyYtNXK7W/Jw1L7da4vq+4BzyRrMOEGeCqdlF
9zztSwQCfIL1UvpHoPMPP+5pR8c=
=ku/w
-----END PGP PUBLIC KEY BLOCK-----</textarea>
			</div>

			<div>
				<button type="button" class="btn btn-primary" onclick="uploadFile()">Transfer</button>
			</div>

			<!-- Progress Bar -->
			<div class="progress mt-3">
				<div id="progressBar" class="progress-bar" role="progressbar"
					style="width: 0%;" aria-valuenow="0" aria-valuemin="0"
					aria-valuemax="100"></div>
			</div>

		</form>
<hr>

<div id="fileTableContainer">
        <!-- Table will be added dynamically here -->
    </div>

 <div class="card my-4">
     <h5 class="card-header">Other PGP Tools</h5>
	 <ul>
		 <li><a href="pgpencdec.jsp">PGP Encryption/Decryption  </a></li>
		 <li><a href="pgpkeyfunction.jsp">PGP Key Generation  </a></li>
		 <li><a href="PGPFunctionality?invalidate=yes">PGP Signature Verifier  </a></li>
		 <li><a href="pgpdump.jsp">PGP KeyDumper</a></li>
		 <li><a href="pgp-upload.jsp">PGP Send Encrypt files</a></li>
		 <li><a href="pgp-file-decrypt.jsp">PGP Decrypt files</a></li>
	 </ul>
 </div>

<%@ include file="footer_adsense.jsp"%>


<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>


<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div class="row">

<%@ include file="body-close.jsp"%>
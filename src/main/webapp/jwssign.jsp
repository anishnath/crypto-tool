<%@ page import="java.util.UUID" %>
<!DOCTYPE html>
<html>
<head>
    <title>JWS sign payload with custom MAC,RSA,EC key</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="JWS sign payload with custom MAC,RSA,EC key using alogrithms HS256,H354,H512,RS256,RS512,RS384,PS256,PS356,PS512,ES256,ES384,ES512 "/>
    <meta name="keywords" content="online jws sign payload, generate jws online,jws online sign,jws signature,jws sign payload with rsa key,jws sign payload with mac key,jws sign payload with ec key,jws alogithom HS256,H354,H512,RS256,RS512,RS384,PS256,PS356,PS512,ES256,ES384,ES512"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%@ include file="header-script.jsp"%>


    <!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
    <script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "online jws signature generate with custom MAC,RSA,EC key",
  "image" : "https://8gwifi.org/images/site/jwssign.png",
  "url" : "https://8gwifi.org/jwssign.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2020-01-27",
  "applicationCategory" : [ "online jws sign payload" , "generate jws online", "jws online sign" , "jws signature" , "jws sign payload with rsa key" , "jws sign payload with mac key", "jws sign payload with ec key"],
  "downloadUrl" : "https://8gwifi.org/jwssign.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu",
  "requirements" : "Generate JWS key, sign payload using alogrithms HS256,H354,H512,RS256,RS512,RS384,PS256,PS356,PS512,ES256,ES384,ES512 ",
  "softwareVersion" : "v1.0"
}
</script>


    <script type="text/javascript">


        var ec256="-----BEGIN EC PRIVATE KEY-----\n" +
                "MHcCAQEEIJ9dBOzljC0Sjm+ExwqYSimlB/FoRIG4Ck7GT4WXtsz5oAoGCCqGSM49\n" +
                "AwEHoUQDQgAEpJAJb5GRI38F8ENaXj9dDw0C5IH735J1WK39+nOqppMkV172zQEw\n" +
                "1ZvCamjxE8QeSkLEAUAYs2jt36dNObIuPg==\n" +
                "-----END EC PRIVATE KEY-----";

        var ec384="-----BEGIN EC PRIVATE KEY-----\n" +
                "MIGkAgEBBDCIYUdofVNWXqGoIlvHsBENRegvswCzArOtKhDHQZ6rOrYHlRJ3BrYF\n" +
                "UJt1d1qmiDugBwYFK4EEACKhZANiAASGN1KVmdWtxUSko2lWV4lHjaXLtz/ylH37\n" +
                "DbwZoqN/owVyCtwYXhjL+8VjT1XGliPFFJAzKjkq4N88U3FjZk7cM3fqyPpyknlg\n" +
                "+Iuc9+VsX8LNx+QPSf312kJtQBWTpsM=\n" +
                "-----END EC PRIVATE KEY-----";

        var ec512="-----BEGIN EC PRIVATE KEY-----\n" +
                "MIHcAgEBBEIA9t5Rfgyuid5fjqJYQwPDfPTo9psgtCp95ARjRacGj7bFPLxN49iK\n" +
                "Pl0bZGVG5PhT01vKRzloPv6WUGxddHa/jQigBwYFK4EEACOhgYkDgYYABADf+Gmd\n" +
                "ZeVvDlLyNdvymp6JdPMi2nu0ggAQrq55HJr++pzTYQ2jcXRrJfFC7UdlPVLEj2Fy\n" +
                "fsTmLtjSxPTCLz1YPgA4BBQGj0A09RAF2EI9aTtYLttfHH7LS6J8b15sr/+DVs7N\n" +
                "Ap1KteIXON6oTeVvYb9oTKvHl9cm7OI373ztaWWKjQ==\n" +
                "-----END EC PRIVATE KEY-----";

        var rsakey = "-----BEGIN RSA PRIVATE KEY-----\n" +
                "MIIEowIBAAKCAQEAzqyzjjC6Mu679TyTrokg1ifH8SsqyLNhpyn/ToyxLahJPPty\n" +
                "DcC+QwRuIzhLR2JbrMNVbWd3LjfPlXLaqHL23v9EOYSe8is+iKSsXW0CrsdiztNn\n" +
                "Y1ZczzUdN+4Ic7CQZxHYdI1IRumd5O1q0AjVOMpwPoZtvmvkqEnfhnoUOPo1hH5X\n" +
                "Y7rmTWEMg0JPZked2zljGKEIBt1gmRvwxuDwBKteycveUHDe7+fvH5TwdVoHEbNs\n" +
                "HCRrO1RpmBd5TG1PrCXVB/wSiyBsxld7H6JYzE7ic8uGT98BLvZGE0qV9D0fR4z+\n" +
                "XIow073ZOIa9v8aPu/2QIpbv6x0re5gPRTAnfwIDAQABAoIBAQCEIk453lVtMszg\n" +
                "oXYZ5Hol8REX021rG6SXZ3ZfFfxBIJKSdoAY4t3Boxd3VQpr/Sp3bfs0Ey5TUkNZ\n" +
                "XTEG+Vl0gOdxjqTAV32HhyDcKlHIxJkbenVjQVfc8ixYEcs9i+kGvJYTDjDjhYD5\n" +
                "WAEuODd6M5NHplKLqBdssK5EH9DGC6uU9sYxHqGTIeh3/RGg2uxRyH92CukajEgn\n" +
                "OSDw7lWLZt9GhOw/CHrCc/UDhfhnT3V0N7DC1sIOkMVxg7Hf8jlxYkp03hTmMw7s\n" +
                "4NKK5Bjnj2wyC/20SHnDw+WU7mW8aXygcsp3Rhpy4GADwHvXcJM4xv7t6tNvBEui\n" +
                "ilvrB/ahAoGBAPLgv6LbNg31lMs3Dq1VboT2yUiW1rCESEhnmNAV3reuFLt15bRN\n" +
                "N0oiD5bEAYViMHFvhXNrOtHP/xP9UIMXl9OZTrugE+65AAfYdp1M4VEv5Bqu6a9M\n" +
                "GrL+M0k0phiOUlqpn1wiVqM8pLTNOqPo85dtVKVLIkahblipyvdupT5tAoGBANnX\n" +
                "OUwOfUCjcK8dljwxFHPmPczZK5ckBNaTzHGx0dDBKjvqzz9r6vMYyIlJvdIT+EL7\n" +
                "eSPokDhKP/l6wUVqc+pFppzrBP3juRVITgPmtGVclH/cMixBuy1XwaKo5qecndoJ\n" +
                "yCBSGXEKES6Pg1X7/lVKOQlozxovdhvHCSZF6ZobAoGAeUNPSu9p2KRhquiNUmuS\n" +
                "J57TtoNhI3aYZFYdDN+ueETZIxNlIZVf4oqI//xSyhbRGwHUPmEuV+0ibQePuDQC\n" +
                "YOptTe5JpWoGouQnrLfi01c26z+jextjRTT3xDgeKap9YbjI0QZv/UZc8cx517aK\n" +
                "UHOMzI5ryZn17xyvMsSyii0CgYBHuU9KNXMT9zxAzBMNGnPLfUFX0yFBEEDvjZZA\n" +
                "0PVuMEuBktxN23BuPfi5CyiOpLiXBUlrg0UI45mQwNQl0Nj9h5VGETOBjJsB4N6e\n" +
                "9jTrMsJKHuv+Gl5QnZZJwia/hReMFLBpw95Qk6n4lJP/mYqx9lA1Qub9jibrGmtu\n" +
                "yJIThQKBgFffqhO7ZGWOmoMSKUyTemKJ8LwSPJTWKiOtxjK1g5wuVCoPWBj3WOhO\n" +
                "zusqafhdJNFsI1cy0ZiRsRcegLK5VWehaPywj0zVf+tDqbb8teOayakn/4RQ1lIF\n" +
                "BaDd01ooIX8Uuydf06TiZt4u11ikjPFv1TY6HFqMnb7USjp+Ge07\n" +
                "-----END RSA PRIVATE KEY-----\n";

        $(document).ready(function() {

            $("#key1").hide();



            $('#HS256').click(function (event)
            {
                $("#key1").hide();
                $("#sharedsecret1").show();
                $('#form').delay(200).submit()
            });

            $('#payload').keyup(function (event)
            {
                $("#key1").hide();
                $('#form').delay(200).submit()
            });

            $('#HS384').click(function (event)
            {
                $("#key1").hide();
                $("#sharedsecret1").show();
                $('#form').delay(200).submit()
            });
            $('#HS512').click(function (event)
            {
                $("#key1").hide();
                $("#sharedsecret1").show();
                $('#form').delay(200).submit()
            });

            $('#RS256').click(function (event)
            {
                $("#key1").show();
                $("#sharedsecret1").hide();
                $("#key").val(rsakey);
                $('#form').delay(200).submit()
            });

            $('#RS384').click(function (event)
            {
                $("#sharedsecret1").hide();
                $("#key1").show();
                $("#key").val(rsakey);
                $('#form').delay(200).submit()
            });
            $('#RS512').click(function (event)
            {

                $("#key1").show();
                $("#key").val(rsakey);
                $('#form').delay(200).submit()
            });

            $('#PS256').click(function (event)
            {

                $("#key1").show();
                $("#key").val(rsakey);
                $('#form').delay(200).submit()
            });

            $('#PS384').click(function (event)
            {

                $("#key1").show();
                $("#key").val(rsakey);
                $('#form').delay(200).submit()
            });

            $('#PS512').click(function (event)
            {

                $("#key1").show();
                $("#key").val(rsakey);
                $('#form').delay(200).submit()
            });

            $('#ES256').click(function (event)
            {

                $("#key1").show();
                $("#key").val(ec256);
                $('#form').delay(200).submit()
            });

            $('#ES384').click(function (event)
            {

                $("#key1").show();
                $("#key").val(ec384);
                $('#form').delay(200).submit()
            });

            $('#ES512').click(function (event)
            {

                $("#key1").show();
                $("#key").val(ec512);
                $('#form').delay(200).submit()
            });
            $('#form').submit(function (event)
            {
                //
                $('#output').html('<img src="images/712.GIF"> loading...');
                event.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "JWSFunctionality", //this is my servlet

                    data: $("#form").serialize(),
                    success: function(msg){
                        $('#output').empty();
                        $('#output').append(msg);

                    }
                });
            });
        });

    </script>
</head>
<%@ include file="body-script.jsp"%>

<h1 class="mt-4">JWS Sign Payload with Custom Key</h1>
<p>This tool will help you to signed the payload with custom JWS Key using Algorithms HMAC,RSA and EC</p>
<hr>

<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="" />Loading!
</div>



<form id="form" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="SIGN_JSON">


    <fieldset class="form-group">
        <div class="row">

            <legend class="col-form-label col-sm-2 pt-0">JWS Algorithm</legend>




            <div class="col-sm-10">


                <div class="form-check form-check-inline">
                    <input class="form-check-input" checked type="radio" name="algo" id="HS256" value="HS256">
                    <label class="form-check-label" for="HS256">HS256</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="HS384" value="HS384">
                    <label class="form-check-label" for="HS384">HS384</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="HS512" value="HS512">
                    <label class="form-check-label" for="HS512">HS512</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="RS256" value="RS256">
                    <label class="form-check-label" for="RS256">RS256</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="RS384" value="RS384">
                    <label class="form-check-label" for="RS384">RS384</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="RS512" value="RS512">
                    <label class="form-check-label" for="RS512">RS512</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="PS256" value="PS256">
                    <label class="form-check-label" for="PS256">PS256</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="PS384" value="PS384">
                    <label class="form-check-label" for="PS384">PS384</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="PS512" value="PS512">
                    <label class="form-check-label" for="PS512">PS512</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="ES256" value="ES256">
                    <label class="form-check-label" for="ES256">ES256</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="ES384" value="ES384">
                    <label class="form-check-label" for="ES256">ES384</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="algo" id="ES512" value="ES512">
                    <label class="form-check-label" for="ES512">ES512</label>
                </div>
            </div>
            <div class="col-sm-10">
                <label for="payload">Payload</label>
    <textarea class="form-control" name="payload" id="payload" rows="5">{
  "sub": "1234567890",
  "name": "Anish Nath",
  "iat": 1516239022
}</textarea>
            </div>

            <div id="sharedsecret1" class="col-sm-10">
                <label for="sharedsecret">Shared Secret</label>
                <input type="sharedsecret" class="form-control" name="sharedsecret" id="sharedsecret" aria-describedby="sharedsecret" value="<%=UUID.randomUUID().toString()%>" placeholder="Enter 32 bit Key">
                <small id="sharedsecret2" class="form-text text-muted">This is your MAC Key</small>
            </div>

            <div id="key1" class="col-sm-10">
                <label for="key">PEM Key</label>
                <textarea class="form-control" name="key" id="key" rows="5"></textarea>
                <small id="key2" class="form-text text-muted">Private is Required for JWS Sign, Public Key is required for  Signature verification</small>
            </div>

            <div class="col-sm-10">
                <button type="submit" class="btn btn-primary">Submit</button>
            </div>

        </div>

    </fieldset>


</form>

<div id="output"></div>

<hr>
<p> Related Tool </p>
<ul>
    <li><a href="jwkfunctions.jsp"><font size="2.5px">JSON Web Key (JWK) Generate</font> </a></li>
    <li><a href="jwkconvertfunctions.jsp"><font size="2.5px">JSON Web Key (JWK) to PEM Convert</font> </a></li>
    <li><a href="jwsparse.jsp"><font size="2.5px">JWS Parser</font> </a></li>
    <li><a href="jwsgen.jsp"><font size="2.5px">JWS Generate Key Sign Data</font> </a></li>
    <li><a href="jwssign.jsp"><font size="2.5px">JWS Sign Data with custom key</font> </a></li>
    <li><a href="jwsverify.jsp"><font size="2.5px">JWS Signature Verification</font> </a></li>
</ul>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<h3 class="code-line" data-line-start=0 data-line-end=1 ><a id="JWS_0"></a>JWS</h3>

<p class="has-line-data" data-line-start="1" data-line-end="2">JSON Web Signature (JWS) represents content secured with <strong>digital signatures</strong> or Message Authentication Codes (MACs) using JSON based data structures</p>
<p class="has-line-data" data-line-start="3" data-line-end="4"><strong>JWS HMAC Algo</strong></p>
<ul>
    <li class="has-line-data" data-line-start="5" data-line-end="6">HS256 - HMAC with SHA-256, requires 256+ bit secret</li>
    <li class="has-line-data" data-line-start="6" data-line-end="7">HS384 - HMAC with SHA-384, requires 384+ bit secret</li>
    <li class="has-line-data" data-line-start="7" data-line-end="9">HS512 - HMAC with SHA-512, requires 512+ bit secret</li>
</ul>
<p class="has-line-data" data-line-start="9" data-line-end="10"><strong>JWS RSA Algo</strong></p>
<ul>
    <li class="has-line-data" data-line-start="11" data-line-end="12">RS256 - RSA PKCS#1 signature with SHA-256</li>
    <li class="has-line-data" data-line-start="12" data-line-end="13">RS384 - RSA PKCS#1 signature with SHA-384</li>
    <li class="has-line-data" data-line-start="13" data-line-end="14">RS512 - RSA PKCS#1 signature with SHA-512</li>
    <li class="has-line-data" data-line-start="14" data-line-end="15">PS256 - RSA PSS signature with SHA-256</li>
    <li class="has-line-data" data-line-start="15" data-line-end="16">PS384 - RSA PSS signature with SHA-384</li>
    <li class="has-line-data" data-line-start="16" data-line-end="18">PS512 - RSA PSS signature with SHA-512</li>
</ul>
<p class="has-line-data" data-line-start="18" data-line-end="19"><strong>JWS Elliptic Curve (EC) Algo</strong></p>
<ul>
    <li class="has-line-data" data-line-start="20" data-line-end="21">ES256 - EC P-256 DSA with SHA-256</li>
    <li class="has-line-data" data-line-start="21" data-line-end="22">ES384 - EC P-384 DSA with SHA-384</li>
    <li class="has-line-data" data-line-start="22" data-line-end="23">ES512 - EC P-521 DSA with SHA-512</li>
</ul>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
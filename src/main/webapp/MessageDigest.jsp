<!DOCTYPE html>
<html>
<head>


    <title>Online Message Digest Algorithms checker and verifier</title>

    <%@ include file="include_css.jsp" %>

    <%
        String[] validList = { "md2","md4","ripemd128","sha","sha-1","sha-224","sha-256","sha-384","sha-512","sha-512/224","sha-512/256","sha3-224","sha3-256","sha3-384","sha3-512","ripemd160","ripemd256","ripemd320","sm3","skein-1024-1024","skein-1024-384","skein-1024-512","skein-256-128","skein-256-160","skein-256-224","skein-256-256","skein-512-128","skein-512-160","skein-512-224","skein-512-256","skein-512-384","skein-512-512","tiger","tiger","whirlpool","blake2b-160","blake2b-256","blake2b-384","blake2b-512","dstu7564-256","dstu7564-384","dstu7564-512","gost3411","gost3411-2012-256","gost3411-2012-512","keccak-224","keccak-256","keccak-288","keccak-384","keccak-512",
                "1.2.804.2.1.1.1.1.2.2.1","1.2.804.2.1.1.1.1.2.2.2","1.2.804.2.1.1.1.1.2.2.3","2.16.840.1.101.3.4.2.10","2.16.840.1.101.3.4.2.7","2.16.840.1.101.3.4.2.8","2.16.840.1.101.3.4.2.9","oid.1.2.804.2.1.1.1.1.2.2.1","oid.1.2.804.2.1.1.1.1.2.2.2","oid.1.2.804.2.1.1.1.1.2.2.3","oid.2.16.840.1.101.3.4.2.10","oid.2.16.840.1.101.3.4.2.7","oid.2.16.840.1.101.3.4.2.8","oid.2.16.840.1.101.3.4.2.9"};
    %>
    <script type="text/javascript">
        $(document).ready(function() {

            $('#cipherparameternew').change(function(event) {
                //
                // event.preventDefault();
                $('#form').delay(200).submit()
            });

            $('#inputtext').keyup(function (event)
            {
                $('#form').delay(200).submit()
            });


            $('#sun').click(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#form').submit(function (event)
            {
                //
                $('#output').html('<img src="images/712.GIF"> loading...');
                event.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "MDFunctionality", //this is my servlet

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
<body>
<div id="page">
    <%@ include file="include.jsp" %>
    <div id="loading" style="display: none;">
        <img src="images/712.GIF" alt="" />Loading!
    </div>
    <article id="contentWrapper" role="main">
        <section id="content">
            <form id="form" method="POST">
                <input type="hidden" name="methodName" id="methodName" value="CALCULATE_MD">
                <fieldset name="Message Digest Functionality">
                    <legend>
                        <B>Get Message Digest Information </B>
                    </legend>
                    <b>Input Message</b><input id="inputtext" placeholder="Type your message here to generate Message Digest" type="text" name="text"
                                               value="" size="100" >
                    <br>

                    <b>Choose Message Digest </b>

                    <select  size="10" multiple name="cipherparameternew" id="cipherparameternew">
                        <option selected value="MD5">MD5</option>
                        <%
                            for (int i = 0; i < validList.length; i++) {
                                String param = validList[i];
                        %>
                        <option value="<%=param%>"><%=param%></option>
                        <%}%>
                    </select>
                </fieldset>
                <div id="output"></div>
            </form>
            <%@ include file="footer.jsp"%>
            <%@ include file="include_security_links.jsp"%>
        </section>
    </article>

</div>
</body>
</html>
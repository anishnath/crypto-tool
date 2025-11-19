<script src="https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/js/jquery.min.js"></script>
<script>
(function(){
  function loadShare(){
    var s = document.createElement('script');
    s.src = 'https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/js/sharethis.js#property=5a04129f05073300123e3782&product=inline-share-buttons';
    s.async = true; s.defer = true;
    document.head.appendChild(s);
  }
  if ('requestIdleCallback' in window) {
    requestIdleCallback(loadShare, {timeout: 5000});
  } else {
    window.addEventListener('load', loadShare, { once: true });
  }
})();
</script>
<!-- Bootstrap core CSS -->
<link href="https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/css/blog-post.css" rel="stylesheet">

<link rel="stylesheet"  href="https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/css/highlight/default.min.css">
<script src="https://cdn.jsdelivr.net/gh/anishnath/crypto-tool@master/src/main/webapp/css/highlight/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>

<%@ include file="analytics.jsp"%>
<%@ include file="setupad.jsp"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Tutorial Analytics Include
    Google Analytics 4 (GA4) tracking code
    Include in <head> section of all tutorial pages

    Usage: <%@ include file="tutorial-analytics.jsp" %>
--%>

<%-- Google Analytics 4 (GA4) --%>
<script async src="https://www.googletagmanager.com/gtag/js?id=G-FQ2QT10GDP"></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-FQ2QT10GDP');

    // Track tutorial progress events
    function trackLessonView(lessonName, moduleName) {
        gtag('event', 'lesson_view', {
            'lesson_name': lessonName,
            'module_name': moduleName,
            'content_type': 'tutorial'
        });
    }

    function trackLessonComplete(lessonName) {
        gtag('event', 'lesson_complete', {
            'lesson_name': lessonName,
            'content_type': 'tutorial'
        });
    }

    function trackQuizAnswer(quizId, isCorrect) {
        gtag('event', 'quiz_answer', {
            'quiz_id': quizId,
            'correct': isCorrect,
            'content_type': 'tutorial'
        });
    }
</script>

<!-- Default Statcounter code for 8gwifi.org
http://8gwifi.org -->
<script type="text/javascript">
    var sc_project=9638240;
    var sc_invisible=1;
    var sc_security="c4db7f3d";
</script>
<script type="text/javascript"
        src="https://www.statcounter.com/counter/counter.js"
        async></script>
<noscript><div class="statcounter"><a title="Web Analytics"
                                      href="https://statcounter.com/" target="_blank"><img
        class="statcounter"
        src="https://c.statcounter.com/9638240/0/c4db7f3d/1/"
        alt="Web Analytics"
        referrerPolicy="no-referrer-when-downgrade"></a></div></noscript>
<!-- End of Statcounter Code -->
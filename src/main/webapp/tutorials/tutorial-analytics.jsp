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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    Exam Platform - Footer Component

    Usage: <%@ include file="components/footer.jsp" %>
--%>
    </main>
    <!-- Main Content End -->

    <!-- Footer -->
    <footer class="exam-footer">
        <div class="container">
            <div class="footer-content">
                <p>&copy; 2025 8gwifi.org - Practice Exams</p>
                <div class="footer-links">
                    <a href="<%=request.getContextPath()%>/">Tools</a>
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <a href="https://twitter.com/anish2good" target="_blank" rel="noopener">Twitter</a>
                    <a href="https://buymeacoffee.com/8gwifi.org" target="_blank" rel="noopener">Support</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Core JavaScript -->
    <script src="<%=request.getContextPath()%>/exams/js/exams-core.js"></script>

    <!-- Mobile Menu Script -->
    <script>
        function toggleMobileMenu() {
            document.getElementById('mobileMenu').classList.add('open');
            document.getElementById('mobileMenuOverlay').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeMobileMenu() {
            document.getElementById('mobileMenu').classList.remove('open');
            document.getElementById('mobileMenuOverlay').classList.remove('active');
            document.body.style.overflow = '';
        }

        // Initialize core
        ExamCore.init();
    </script>
</body>
</html>

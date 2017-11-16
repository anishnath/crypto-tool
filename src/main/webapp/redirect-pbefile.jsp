<%
    String value =(String)session.getAttribute("msg");
    if(value!=null);
    {
        session.setAttribute("msg","");
        session.setAttribute("uid","");
        session.setAttribute("downloadlink","");
    }
    response.sendRedirect("pbefile.jsp");
%>
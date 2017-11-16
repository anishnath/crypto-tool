package z.y.x.Security;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.Security;

/**
 * Created by aninath on 11/16/17.
 */
public class BCCryptFunctionality extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private static final String METHOD_HASH_BCCRYPT = "CALCULATE_BCCRYPT";
    private static final String METHOD_CHECK_PASSWORD = "METHOD_CHECK_PASSWORD";

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public BCCryptFunctionality() {

    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub


        final String methodName = request.getParameter("methodName");


        PrintWriter out = response.getWriter();

        if (METHOD_HASH_BCCRYPT.equals(methodName)) {
            final String password = request.getParameter("password");
            final String workload = request.getParameter("workload");

            if (password == null || password.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> Password is Empty </font>");
                return;
            }


            int rs = 5;
            try {
                rs = Integer.parseInt(workload);
                if (rs > 13) {
                    out.println("<font size=\"2\" color=\"red\"> The System support only 13 round </font>");
                    return;
                }
            } catch (NumberFormatException nfe) {
                rs = 5;
            }
            String hashpassword = JBCryptUtil.hashPassword(password, rs);
            out.println("<font size=\"4\" color=\"green\"> Hash Password ["
                    + hashpassword + "]</font><br/>");
            addHorizontalLine(out);

            StringBuilder builder = new StringBuilder();
            builder.append("<font size=\"2\" color=\"green\">Bcrypt="
                    + hashpassword.substring(0, 4) + "</font><br/>");
            builder.append("<font size=\"2\" color=\"green\">Round="
                    + hashpassword.substring(4, 6) + "</font><br/>");
            builder.append("<font size=\"2\" color=\"green\">Salt="
                    + hashpassword.substring(7, 29) + "</font><br/>");
            builder.append("<font size=\"2\" color=\"green\">Hash="
                    + hashpassword.substring(29, hashpassword.length()) + "</font><br/>");

            out.println(builder.toString());


            //Validate Password
            String passwordhash = request.getParameter("hash");

            if (null == passwordhash || passwordhash.trim().length() == 0) {

                return;
            }

            if (null == password || password.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> Password is Empty </font>");
                return;
            }

            if (passwordhash.length() < 5) {
                out.println("<br/><font size=\"2\" color=\"red\"> Invalid BCCrypt Hash </font>");
                return;
            }

            if ("$2a$".equals(passwordhash.substring(0, 4)) || "$2y$".equals(passwordhash.substring(0, 4)) || "$2b$".equals(passwordhash.substring(0, 4))) {
                boolean x = JBCryptUtil.checkPassword(password, passwordhash);

                if (x) {


                    addHorizontalLine(out);

                    builder.append("<font size=\"5\" color=\"green\"> Hash Verification Passed [" + passwordhash +
                            "]</font>");
                    builder.append("<hr>");

                    out.println(builder.toString());
                    return;
                } else {
                    out.println("<font size=\"4\" color=\"red\"> Hash Verification failed </font>");
                    return;
                }

            } else {
                out.println("<br/><font size=\"4\" color=\"red\"> Invalid BCCrypt Hash </font>");
                return;
            }

        }

    }


    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}

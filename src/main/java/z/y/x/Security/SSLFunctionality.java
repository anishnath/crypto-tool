package z.y.x.Security;


import com.google.gson.Gson;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import z.y.x.Network.NetworkDiagnostics;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.security.SecureRandom;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.*;

/**
 * Created by aninath on 11/16/17.
 * For Demo Visit https://8gwifi.org
 */

public class SSLFunctionality extends HttpServlet {

    private final NetworkDiagnostics networkDiagnostics = new NetworkDiagnostics();
    private static final char ESCAPE = '\u00a7';
    private static final long serialVersionUID = 2L;
    private static final String METHOD_SSL_CHECKER = "SSL_CHECKER";

    public SSLFunctionality() {

    }


    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {


        response.setContentType("text/html");


        request.getRequestDispatcher("index.jsp").forward(request,
                response);
        ;
        return;

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        System.out.println("Here-------");
        request.setAttribute("org.apache.catalina.ASYNC_SUPPORTED", true);
        final AsyncContext asyncContext = request.startAsync();
        asyncContext.setTimeout(240000);
        asyncContext.start( new Runnable(){
            @Override
            public void run() {

                    try {

                        String pingommand = "/Users/aninath/workspaces/testssl.sh/testssl.sh";
                        final List<String> commands = new ArrayList<String>();
                        commands.add(pingommand);
                        commands.add("cisco.com");

                        final  SSLFunctionality sslfunctinlaity =  new SSLFunctionality();
                        Callable<Object> callable = new Callable<Object>() {
                            public Object call() throws Exception {
                                return sslfunctinlaity.doCommandX(commands,asyncContext);
                            }
                        };

                        ExecutorService executorService = Executors.newCachedThreadPool();
                        Object result = null;
                        Future<Object> task = executorService.submit(callable);

                        result = task.get(4, TimeUnit.MINUTES);


                    } catch (Exception ex) {

                    }


            }
        });
    }

    private  String doCommandX(List<String> command,AsyncContext asyncContext)

    {
        System.out.println("Here-2------");
        StringBuilder builder = new StringBuilder();
        System.out.println("Command  " + command.toString());
        try {
            String s = null;

            ProcessBuilder pb = new ProcessBuilder(command);
            Process process = pb.start();

            BufferedReader stdInput = new BufferedReader(new InputStreamReader(
                    process.getInputStream()));
            BufferedReader stdError = new BufferedReader(new InputStreamReader(
                    process.getErrorStream()));

            int i=0;

            while ((s = stdInput.readLine()) != null) {

                System.out.println(s);
                if(!s.contains("OpenSSL 1.0.2-chacha"))
                {
                    builder.append(s + "<br>");

                    List<Row> list = new ArrayList<Row>();
                    list.add(new Row("First", clean(s), String.valueOf(i), "link" + i));

                    String json = new Gson().toJson(list);

                    asyncContext.getResponse().setContentType("application/json");
                    asyncContext.getResponse().setCharacterEncoding("UTF-8");
                    try {
                        asyncContext.getResponse().getWriter().write(json);
                        asyncContext.getResponse().getWriter().flush();
                    } catch (IOException ex) {
                        System.out.println("fail");
                    }


                    builder.append(System.getProperty("line.separator"));

                    i++;
                }

            }

            // read any errors from the attempted command
            //System.out
            //		.println("Here is the standard error of the command (if any):\n");
            while ((s = stdError.readLine()) != null) {
                builder.append(s + "<br>");
                builder.append(System.getProperty("line.separator"));
            }

        } catch (Exception e) {
            System.out.println("Error " + e);
        }
        asyncContext.complete();
        return builder.toString();


    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

    /**
     * @param request
     * @return
     */
    private DiskFileItemFactory getDiskFileFactory(HttpServletRequest request) {
        // Check that we have a file upload request

        // Create a factory for disk-based file items
        DiskFileItemFactory factory = new DiskFileItemFactory();

        // Configure a repository (to ensure a secure temp location is used)
        ServletContext servletContext = this.getServletConfig()
                .getServletContext();
        File repository = (File) servletContext
                .getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);
        return factory;
    }

    public static String clean( String message ) {
        return clean( message, true );
    }

    public static String clean( String message, boolean removeFormat ) {
        message = message.replaceAll( (char) 0x1b + "[0-9;\\[\\(]+[Bm]", "" );
        return removeFormat ? message.replaceAll( ESCAPE + "[0123456789abcdefklmnor]", "" ) : message;
    }

}

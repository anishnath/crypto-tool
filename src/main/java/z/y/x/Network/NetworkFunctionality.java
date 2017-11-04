package z.y.x.Network;


import java.io.IOException;
import java.io.PrintWriter;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.net.InetAddresses;

public class NetworkFunctionality extends HttpServlet {

    private static final String METHOD_EXECUTENETWORKPINGCOMMAND = "NETWORKPINGCOMMAND";
    /**
     *
     */
    private static final long serialVersionUID = -2727554819975126562L;
    private final String os = System.getProperty("os.name");
    private final NetworkDiagnostics networkDiagnostics = new NetworkDiagnostics();

    public static String getClientIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    public static void main(String[] args) {
        System.out.println("10.10.10.10".length());
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE TRY AGAIN " + "</h1>");
        out.println("<b><u>Get Client Ip Address </b></u>= <font size=\"3\" color=\"cyan\">"
                + InetAddress.getLocalHost().toString() + "</font><br>");
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        final String isgetClientIpAddrRequested = request.getParameter("getClientIpAddr");
        final String queryV6 = request.getParameter("queryV6DOmain");

        final String methodName = request.getParameter("methodName");

        if (isgetClientIpAddrRequested != null && !isgetClientIpAddrRequested.isEmpty()) {
            addHorizontalLine(out);
            out.println("<b><u> Client Ip Address </b></u>= <font size=\"3\" color=\"blue\">"
                    + getClientIpAddr(request) + "</font><br>");
        }

        if (METHOD_EXECUTENETWORKPINGCOMMAND.equalsIgnoreCase(methodName)) {


            //PING
            String ipaddress = request.getParameter("ipaddress");


            if (ipaddress != null && !ipaddress.isEmpty()) {
                ipaddress = ipaddress.trim();
                String pingommand = "ping";
                try {

                    InetAddress addr = InetAddress.getByName(ipaddress);
                    if (addr != null) {
                        final String s1 = addr.getHostAddress();
                        // if(InetAddresses)


                        if (InetAddresses.forString(s1) instanceof Inet4Address) {
                            pingommand = "ping";
                        } else if (InetAddresses.forString(s1) instanceof Inet6Address) {
                            pingommand = "ping6";
                        } else {
                            pingommand = "ping";
                        }
                        addHorizontalLine(out);
                        final List<String> commands = new ArrayList<String>();
                        commands.add(pingommand);
                        if (os.contains("win")) {
                            commands.add("-n"); // Nott TESTED
                        } else {
                            commands.add("-c"); // On Windows it's Different
                        }
                        commands.add("5");
                        commands.add(s1);
                        //final String output =networkDiagnostics.doCommand(command);
                        addHorizontalLine(out);

                        Callable<Object> callable = new Callable<Object>() {
                            public Object call() throws Exception {
                                return networkDiagnostics.doCommand(commands);
                            }
                        };

                        ExecutorService executorService = Executors.newCachedThreadPool();
                        Object result = null;
                        Future<Object> task = executorService.submit(callable);
                        try {
                            // ok, wait for 15 seconds max
                            result = task.get(15, TimeUnit.SECONDS);
                            System.out.println("Finished with result: " + result);
                            out.println("<b><u>ICMP Echo Reply </b></u>= "  +  pingommand + " -c5 " +ipaddress + "<br><font size=\"3\" color=\"blue\">"
                                    + result + "</font><br>");
                        } catch (ExecutionException e) {
                            throw new RuntimeException(e);

                        } catch (TimeoutException e) {
                            out.println("<b><u>Command </b></u>= Cant Ping" + ipaddress + " Server Busy<br><font size=\"3\" color=\"blue\">"
                                    + result + "</font><br>");
                        } catch (InterruptedException e) {
                            out.println("<b><u>Command </b></u>= Cant Ping" + ipaddress + " Server Busy<br><font size=\"3\" color=\"blue\">"
                                    + result + "</font><br>");
                        }

                    }
                } catch (Exception e) {
                    //IGNORE
                    out.println("<b><u> Unknown Host </font><br>" + ipaddress);
                }
            } else {
                out.println("<b><u> Invalid IP Address/DNS Name Please Check and try Again  </font><br>" + ipaddress);
            }

        }
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}

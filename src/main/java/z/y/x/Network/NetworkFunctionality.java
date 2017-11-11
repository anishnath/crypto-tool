package z.y.x.Network;


import java.io.IOException;
import java.io.PrintWriter;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.xbill.DNS.*;

import com.google.common.net.InetAddresses;
import z.y.x.Security.VerifyRecaptcha;
import z.y.x.u.IPLocation;

public class NetworkFunctionality extends HttpServlet {

    private static final String METHOD_EXECUTENETWORKPINGCOMMAND = "NETWORKPINGCOMMAND";
    private static final String METHOD_EXECUTENETWORKCURLCOMMAND = "NETWORKCURLCOMMAND";
    /**
     *
     */
    private static final long serialVersionUID = -2727554819975126562L;
    private final String os = System.getProperty("os.name");
    private final NetworkDiagnostics networkDiagnostics = new NetworkDiagnostics();

    public static String getClientIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        InetAddress localip = null;
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
        if (ip.equals("0:0:0:0:0:0:0:1")) {

            try {
                localip = InetAddress.getLocalHost();
            } catch (UnknownHostException e) {
                return  ip;
            }

        }
        if(localip!=null)
        {

            return localip.getHostAddress();
        }
        else
        {
            return  ip;
        }
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
        String gRecaptchaResponse = request
                .getParameter("g-recaptcha-response");

        //System.out.println(gRecaptchaResponse);
        boolean verify = VerifyRecaptcha.verify(gRecaptchaResponse);

       // System.out.println(verify);

        if(!verify)
        {
            addHorizontalLine(out);
            out.println("<b><u> Captcha Error Client Ip Address </b></u>= <font size=\"3\" color=\"blue\">"
                    + getClientIpAddr(request) + "</font><br>");
            return;
        }

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
                    boolean status = addr.isReachable(5000);
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
                            //System.out.println("Finished with result: " + result);
                            out.println("<b><u>ICMP Echo Reply </b></u>= "  +  pingommand + " -c5 " +ipaddress + "<br><font size=\"3\" color=\"blue\">"
                                    + result + "</font><br>");
                            getIpLocation(out, addr);
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

        if (METHOD_EXECUTENETWORKCURLCOMMAND.equalsIgnoreCase(methodName)) {


            //PING
            String ipaddress = request.getParameter("ipaddress");
            String scheme = request.getParameter("scheme");
            String port = request.getParameter("port");

            if(scheme==null || scheme.isEmpty())
            {
                scheme="http";
            }

            if(port!=null)
            {
                try
                {
                    int result = Integer.parseInt(port);
                }catch (NumberFormatException ex )
                {
                    port="80";
                }

            }

            if (ipaddress != null && !ipaddress.isEmpty()) {
                ipaddress = ipaddress.trim();
                String curloption = "--ipv4";
                try {

                    InetAddress addr = InetAddress.getByName(ipaddress);


                    final List<String> commands = new ArrayList<String>();
                        if (addr != null) {
                            commands.add("curl");
                            commands.add("-I");

                            String s1 = addr.getHostAddress();
                            // if(InetAddresses)


                            if (InetAddresses.forString(s1) instanceof Inet4Address) {
                                curloption = "--ipv4";
                            } else if (InetAddresses.forString(s1) instanceof Inet6Address) {
                                curloption = "--ipv6";
                                s1 = "[" + ipaddress + "]";

                               // System.out.println(s1);
                            } else {
                                curloption = "--ipv4";
                            }
                            addHorizontalLine(out);
                            commands.add("-g");
                            commands.add("-k");
                            commands.add(curloption);
                            if (ipaddress.contains(":")) {
                                commands.add(scheme+"://[" + ipaddress + "]:"+port);
                            } else {
                                commands.add(scheme+"://"+ipaddress+":"+port);
                            }

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
                                //System.out.println("Finished with result: " + result);
                                out.println("<b><u>SCHEME</b>["+scheme+"] <b>IPAddress </b> </u>[" + addr.getHostAddress() + "] port[" + port + "]<br><font size=\"3\" color=\"blue\">"+
                                       "</font><br>");
                                addHorizontalLine(out);
                                out.println("<b><u>HTTP Header Response </b></u>=  <br><font size=\"3\" color=\"blue\">"
                                        + result + "</font><br>");
                                addHorizontalLine(out);
                                Record [] aaaaRecord = new Lookup(ipaddress, Type.AAAA).run();
                                if(aaaaRecord!=null)
                                {
                                    for (int i = 0; i < aaaaRecord.length; i++) {
                                        AAAARecord aaaaRecorda = (AAAARecord) aaaaRecord[i];
                                        if(aaaaRecorda!=null)
                                        {
                                            out.println("<b><u>AAAA Record</b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() +"</font><br>");
                                            addHorizontalLine(out);
                                        }

                                    }
                                }

                                aaaaRecord = new Lookup(ipaddress, Type.A).run();
                                if(aaaaRecord!=null) {
                                    for (int i = 0; i < aaaaRecord.length; i++) {
                                        ARecord aaaaRecorda = (ARecord) aaaaRecord[i];
                                        if (aaaaRecorda != null) {
                                            out.println("<b><u>A Record </b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                                            addHorizontalLine(out);
                                        }
                                    }
                                }

                                aaaaRecord = new Lookup(ipaddress, Type.MX).run();
                                if(aaaaRecord!=null) {
                                    for (int i = 0; i < aaaaRecord.length; i++) {
                                        MXRecord aaaaRecorda = (MXRecord) aaaaRecord[i];
                                        if (aaaaRecorda != null) {
                                            out.println("<b><u>MX Record</b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                                            addHorizontalLine(out);
                                        }
                                    }
                                }

                                aaaaRecord = new Lookup(ipaddress, Type.NSAP).run();
                                if(aaaaRecord!=null) {
                                    for (int i = 0; i < aaaaRecord.length; i++) {
                                        NSAPRecord aaaaRecorda = (NSAPRecord) aaaaRecord[i];
                                        if (aaaaRecorda != null) {
                                            out.println("<b><u>MX Record</b></u>= <font size=\"3\" color=\"blue\">\"" + aaaaRecorda.toString() + "</font><br>");
                                            addHorizontalLine(out);
                                        }
                                    }
                                }
                                getIpLocation(out, addr);

                            } catch (ExecutionException e) {
                                throw new RuntimeException(e);

                            } catch (TimeoutException e) {
                                out.println("<b><u>Command </b></u>= Cant Fetch Header" + ipaddress + " Server Busy<br><font size=\"3\" color=\"blue\">"
                                        + result + "</font><br>");
                            } catch (InterruptedException e) {
                                out.println("<b><u>Command </b></u>= Cant Header" + ipaddress + " Server Busy<br><font size=\"3\" color=\"blue\">"
                                        + result + "</font><br>");
                            }

                        }
                    else {
                        out.println("<b><u> Host Not Reachable  </font><br>" + ipaddress);
                    }

                } catch (Exception e) {
                    //IGNORE
                    //e.printStackTrace();
                    out.println("<b><u> Unknown Host </font>" + ipaddress);
                }
            } else {
                out.println("<b><u> Invalid IP Address/DNS Name Please Check and try Again  </font><br>" + ipaddress);
            }

        }
    }

    private void getIpLocation(PrintWriter out, InetAddress addr) {
        IPLocation ipLocation = IpLocationDetector.getLocation(addr.getHostAddress());
        {
            if (ipLocation != null) {
                out.println("<b><u>Country</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getCountry() + "</font><br>");
                out.println("<b><u>City</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getCity() + "</font><br>");
                out.println("<b><u>Location</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getLoc() + "</font><br>");
                out.println("<b><u>Region</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getRegion() + "</font><br>");
                out.println("<b><u>Organization</b></u>= <font size=\"3\" color=\"blue\">\"" + ipLocation.getOrg() + "</font><br>");
                addHorizontalLine(out);

            }

        }
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

}

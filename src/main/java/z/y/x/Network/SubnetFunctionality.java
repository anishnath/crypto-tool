package z.y.x.Network;

import org.apache.commons.net.util.SubnetUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Anish Nath on 11/3/17.
 */
public class SubnetFunctionality extends HttpServlet  {

    private static final long serialVersionUID = 1L;
    private static final String METHOD_EXECUTECOMMAND = "SUBNETCOMMAND";

    public SubnetFunctionality()
    {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE TRY AGAIN " + "</h1>");
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        final String methodName = request.getParameter("methodName");
        final String subnetName=request.getParameter("subnet");
        final String inCludeAddress=request.getParameter("encoding");

        PrintWriter out = response.getWriter();
        final List<String> command = new ArrayList<String>();
        if (METHOD_EXECUTECOMMAND.equalsIgnoreCase(methodName)) {
            boolean inAd=false;
            try {
                SubnetUtils utils = new SubnetUtils(subnetName);
                if (inCludeAddress!=null)
                {
                    if("Y".equalsIgnoreCase(inCludeAddress))
                    {
                        inAd=true;
                    }

                }
                out.println(getSubnetInformation(subnetName,inAd));

            }catch (Exception ex) {
                out.println("<b><u>Inavlid Subnet </b></u>= "+ subnetName +"<br><font size=\"3\" color=\"blue\">"
                        + "</font><br>");
                return;
            }

        }
    }


    private String cidrRangeConvertor(final String subnet)
    {

        final StringBuilder builder = new StringBuilder();
        SubnetUtils utils = new SubnetUtils(subnet);
        utils.isInclusiveHostCount();

        if(subnet!=null)
        {
            String s1 = subnet.substring(subnet.indexOf("/")+1,subnet.length());

            int x= Integer.valueOf(s1);
            if (x <=16)
            {
                builder.append("IP RANGE IS VERY HIGH MEMORY RESTRICTION : " + utils.getInfo().getAddressCountLong() +
                        "TRY CIDR RANGE Greater Than 16 ");
                builder.append("\n");
                builder.append("SORRY......\n");
                return builder.toString();
            }

            String[] subnetAddress = utils.getInfo().getAllAddresses();
            for (String s : subnetAddress) {
                builder.append(s);
                builder.append("\n");
            }


        }
        return builder.toString();
    }

    private String getSubnetInformation(final String subnet, boolean includeAddress)
    {
        //System.out.print("inCludeAddress2--- " + includeAddress);
        final StringBuilder builder = new StringBuilder();
        SubnetUtils utils = new SubnetUtils(subnet);
        builder.append(utils.getInfo().toString());
        if(includeAddress){
            builder.append("================STRAT IP ADDRESSES==============\n");
            builder.append(cidrRangeConvertor(subnet));
            builder.append("================END IP ADDRESSES==============\n");
        }

        return builder.toString();
    }

    public static void main (String[] args)
    {
        //new SubnetFunctionality().cidrRangeConvertor("192.168.21.1/16");
        //System.out.println(new SubnetFunctionality().getSubnetInformation("192.168.255.242/16",true));
    }
}

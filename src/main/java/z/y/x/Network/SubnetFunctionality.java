package z.y.x.Network;

import com.google.gson.Gson;
import org.apache.commons.net.util.SubnetUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Anish Nath on 11/3/17.
 */
public class SubnetFunctionality extends HttpServlet  {

    private static final long serialVersionUID = 1L;
    private static final String METHOD_EXECUTECOMMAND = "SUBNETCOMMAND";

    public SubnetFunctionality()
    {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("errorMessage", "GET method not supported. Use POST.");
        out.println(new Gson().toJson(errorResponse));
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        final String methodName = request.getParameter("methodName");
        String subnetName = request.getParameter("subnet");
        final String includeAddressParam = request.getParameter("encoding");

        if (null == subnetName || subnetName.trim().length() == 0) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("errorMessage", "Please provide a subnet in CIDR notation (e.g., 192.168.1.0/24)");
            out.println(gson.toJson(errorResponse));
            return;
        }

        subnetName = subnetName.trim();

        if (METHOD_EXECUTECOMMAND.equalsIgnoreCase(methodName)) {
            boolean includeAddress = "Y".equalsIgnoreCase(includeAddressParam);

            try {
                SubnetUtils utils = new SubnetUtils(subnetName);
                SubnetUtils.SubnetInfo info = utils.getInfo();

                // Build structured response
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("input", subnetName);

                // Network information
                Map<String, Object> network = new HashMap<>();
                network.put("cidrNotation", info.getCidrSignature());
                network.put("networkAddress", info.getNetworkAddress());
                network.put("broadcastAddress", info.getBroadcastAddress());
                network.put("subnetMask", info.getNetmask());
                network.put("wildcardMask", calculateWildcard(info.getNetmask()));
                network.put("lowAddress", info.getLowAddress());
                network.put("highAddress", info.getHighAddress());
                network.put("addressCount", info.getAddressCountLong());
                network.put("usableHosts", Math.max(0, info.getAddressCountLong() - 2));

                // Extract prefix length
                String prefix = subnetName.substring(subnetName.indexOf("/") + 1);
                int prefixLength = Integer.parseInt(prefix);
                network.put("prefixLength", prefixLength);
                network.put("hostBits", 32 - prefixLength);

                // Binary representations
                Map<String, String> binary = new HashMap<>();
                binary.put("networkAddress", ipToBinary(info.getNetworkAddress()));
                binary.put("subnetMask", ipToBinary(info.getNetmask()));
                binary.put("broadcastAddress", ipToBinary(info.getBroadcastAddress()));
                network.put("binary", binary);

                // Network class
                network.put("networkClass", getNetworkClass(info.getNetworkAddress()));
                network.put("isPrivate", isPrivateNetwork(info.getNetworkAddress()));

                result.put("network", network);

                // Include IP addresses if requested (with limit)
                if (includeAddress) {
                    if (prefixLength <= 16) {
                        result.put("addressListError", "IP range too large (>" + info.getAddressCountLong() + " addresses). Use CIDR /17 or higher.");
                        result.put("addresses", new ArrayList<>());
                    } else {
                        String[] allAddresses = info.getAllAddresses();
                        List<String> addressList = new ArrayList<>();
                        int limit = Math.min(allAddresses.length, 1000); // Limit to 1000 for performance
                        for (int i = 0; i < limit; i++) {
                            addressList.add(allAddresses[i]);
                        }
                        result.put("addresses", addressList);
                        if (allAddresses.length > 1000) {
                            result.put("addressListTruncated", true);
                            result.put("totalAddresses", allAddresses.length);
                        }
                    }
                }

                out.println(gson.toJson(result));

            } catch (IllegalArgumentException ex) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("errorMessage", "Invalid subnet: " + subnetName + ". Use format like 192.168.1.0/24");
                errorResponse.put("input", subnetName);
                out.println(gson.toJson(errorResponse));
            }
        }
    }

    private String calculateWildcard(String netmask) {
        String[] parts = netmask.split("\\.");
        int[] wildcard = new int[4];
        for (int i = 0; i < 4; i++) {
            wildcard[i] = 255 - Integer.parseInt(parts[i]);
        }
        return wildcard[0] + "." + wildcard[1] + "." + wildcard[2] + "." + wildcard[3];
    }

    private String ipToBinary(String ip) {
        String[] octets = ip.split("\\.");
        StringBuilder binary = new StringBuilder();
        for (int i = 0; i < octets.length; i++) {
            if (i > 0) binary.append(".");
            String bin = Integer.toBinaryString(Integer.parseInt(octets[i]));
            binary.append(String.format("%8s", bin).replace(' ', '0'));
        }
        return binary.toString();
    }

    private String getNetworkClass(String ip) {
        int firstOctet = Integer.parseInt(ip.split("\\.")[0]);
        if (firstOctet >= 1 && firstOctet <= 126) return "A";
        if (firstOctet >= 128 && firstOctet <= 191) return "B";
        if (firstOctet >= 192 && firstOctet <= 223) return "C";
        if (firstOctet >= 224 && firstOctet <= 239) return "D (Multicast)";
        if (firstOctet >= 240 && firstOctet <= 255) return "E (Reserved)";
        return "Unknown";
    }

    private boolean isPrivateNetwork(String ip) {
        String[] parts = ip.split("\\.");
        int first = Integer.parseInt(parts[0]);
        int second = Integer.parseInt(parts[1]);

        // 10.0.0.0/8
        if (first == 10) return true;
        // 172.16.0.0/12
        if (first == 172 && second >= 16 && second <= 31) return true;
        // 192.168.0.0/16
        if (first == 192 && second == 168) return true;

        return false;
    }

    public static void main (String[] args)
    {
        //new SubnetFunctionality().cidrRangeConvertor("192.168.21.1/16");
        //System.out.println(new SubnetFunctionality().getSubnetInformation("192.168.255.242/16",true));
    }
}

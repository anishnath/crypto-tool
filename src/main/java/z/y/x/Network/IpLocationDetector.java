package z.y.x.Network;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import z.y.x.u.IPLocation;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;

/**
 * Created by aninath on 11/11/17.
 */
public class IpLocationDetector {



    public static IPLocation getLocation(final String ipaddress)
    {

        //System.out.println(ipaddress);

        if(ipaddress!=null )
            try {
                {

                        Gson gson = new Gson();


                        DefaultHttpClient httpClient = new DefaultHttpClient();

                    String url = "http://ipinfo.io/"+ipaddress.trim().toString()+"?token=3eaeb645588723";
                    String url1="http://ipinfo.io/216.58.197.78?token=3eaeb645588723";
                    //System.out.println(url);
                        HttpGet getRequest = new HttpGet(url);
                        getRequest.addHeader("accept", "application/json");

                        HttpResponse response = httpClient.execute(getRequest);

                        if (response.getStatusLine().getStatusCode() != 200) {
                            throw new RuntimeException("Failed : HTTP error code : "
                                    + response.getStatusLine().getStatusCode());
                        }

                        BufferedReader br = new BufferedReader(
                                new InputStreamReader(
                                        (response.getEntity().getContent())
                                )
                        );

                        StringBuilder content = new StringBuilder();
                        String line;
                        while (null != (line = br.readLine())) {
                            content.append(line);
                        }
                       // System.out.println(content);
                        IPLocation iploc = gson.fromJson(content.toString(),IPLocation.class);
                        return  iploc;


                }
            } catch (IOException e) {
                return null;
            }

        return null;
    }

    public static void main(String[] args ) throws Exception
    {
        String ipaddress="216.58.197.78";
        InetAddress addr = InetAddress.getByName(ipaddress);
        IPLocation x = IpLocationDetector.getLocation(addr.getHostAddress());

        System.out.println(x);

    }


}

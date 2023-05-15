package z.y.x.blockchain;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;

public class ETHTest {

    public static void main(String[] args) throws IOException {
        // Define the payload
        String payload = "{\n" +
                "    \"ip\": \"10.10.0.0\",\n" +
                "    \"sign\": false,\n" +
                "    \"tcp\": 30303,\n" +
                "    \"udp\": 0\n" +
                "}";

        // Create the HTTP POST request
        HttpPost request = new HttpPost("http://localhost:1888/generateDevp2pNodeKey");
        request.setHeader("Content-type", "application/json");
        request.setEntity(new StringEntity(payload));

        // Create the HTTP client and execute the request
        HttpClient client = HttpClients.createDefault();
        HttpResponse response = client.execute(request);

        // Extract the response entity as a string
        HttpEntity entity = response.getEntity();
        String responseString = EntityUtils.toString(entity);

        // Print the response string
        System.out.println(responseString);
    }
}


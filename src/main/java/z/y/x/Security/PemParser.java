package z.y.x.Security;

import com.google.gson.Gson;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.security.Security;
import java.util.ArrayList;
import java.util.List;

final public class PemParser {
	

	static {
		Security.addProvider(new BouncyCastleProvider());
	}
	
	


	public static void main(String[] args) throws Exception {
		
		
	}

	public String crackPemFile(final String data,final String password,final String email) throws Exception
	{
		try{

			if(data==null || data.isEmpty())
			{
				throw new Exception("Input PEM Data is Missing");
			}

			Gson gson = new Gson();
			HttpClient client = HttpClientBuilder.create().build();
			String url1 = "http://localhost:8080/crypto/rest/pem/crack";
			HttpPost post = new HttpPost(url1);
			List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
			urlParameters.add(new BasicNameValuePair("p_pem", data));
			urlParameters.add(new BasicNameValuePair("p_email", email));
			urlParameters.add(new BasicNameValuePair("p_passwordlist", password));

			post.setEntity(new UrlEncodedFormEntity(urlParameters));
			post.addHeader("accept", "application/json");

			HttpResponse response1 = client.execute(post);

			if (response1.getStatusLine().getStatusCode() != 200) {
				if (response1.getStatusLine().getStatusCode() == 404) {
					BufferedReader br1 = new BufferedReader(
							new InputStreamReader(
									(response1.getEntity().getContent())
							)
					);
					StringBuilder content1 = new StringBuilder();
					String line;
					while (null != (line = br1.readLine())) {
						content1.append(line);
					}
					throw new Exception(content1.toString());

				} else {
					throw new Exception("SYSTEM Error Please Try Later If Problem Persist raise the feature request ");

				}

			}
			BufferedReader br1 = new BufferedReader(
					new InputStreamReader(
							(response1.getEntity().getContent())
					)
			);
			StringBuilder content1 = new StringBuilder();
			String line;
			while (null != (line = br1.readLine())) {
				content1.append(line);
			}
			return content1.toString();

		}
		catch (Exception e) {
			throw new Exception(e);
		}
	}

	/**
	 * @return 
	 * @throws Exception 
	 */
	public  String parsePemFile(final String data,final String password) throws Exception {

		try {

			if(data==null || data.isEmpty())
			{
				throw new Exception("Input PEM Data is Missing");
			}

			Gson gson = new Gson();
			HttpClient client = HttpClientBuilder.create().build();
			String url1 = "http://localhost:8080/crypto/rest/pem/parseencryptedpem";
			HttpPost post = new HttpPost(url1);
			List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
			urlParameters.add(new BasicNameValuePair("p_pem", data));
			urlParameters.add(new BasicNameValuePair("p_password", password));

			post.setEntity(new UrlEncodedFormEntity(urlParameters));
			post.addHeader("accept", "application/json");

			HttpResponse response1 = client.execute(post);

			if (response1.getStatusLine().getStatusCode() != 200) {
				if (response1.getStatusLine().getStatusCode() == 404) {
					BufferedReader br1 = new BufferedReader(
							new InputStreamReader(
									(response1.getEntity().getContent())
							)
					);
					StringBuilder content1 = new StringBuilder();
					String line;
					while (null != (line = br1.readLine())) {
						content1.append(line);
					}
					throw new Exception(content1.toString());

				} else {
					throw new Exception("SYSTEM Error Please Try Later If Problem Persist raise the feature request ");

				}

			}
			BufferedReader br1 = new BufferedReader(
					new InputStreamReader(
							(response1.getEntity().getContent())
					)
			);
			StringBuilder content1 = new StringBuilder();
			String line;
			while (null != (line = br1.readLine())) {
				content1.append(line);
			}

			//System.out.println("line-- " + content1);

			EncodedMessage encodedMessage = gson.fromJson(content1.toString(), EncodedMessage.class);

			return encodedMessage.getMessage();


		} catch (Exception e) {
			throw new Exception(e);
		}

	}

}

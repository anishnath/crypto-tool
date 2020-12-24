package z.y.x.aws;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.Protocol;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.internal.StaticCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.ec2.AmazonEC2Client;

/**
 * 
 * @author anishnath
 *
 */
public class EC2Client {
	
	public AmazonEC2Client getEC2Client(String accessKey, String secretKey, String region) throws Exception {
		AWSCredentialsProvider provider;
		if (accessKey != null && secretKey != null) {
			AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
			provider = new StaticCredentialsProvider(credentials);
		} else {
			provider = new DefaultAWSCredentialsProviderChain();
		}
		AmazonEC2Client client = new AmazonEC2Client(provider).withRegion(Regions.fromName(region));
		ClientConfiguration configuration = new ClientConfiguration();
		configuration.setProtocol(Protocol.HTTPS);
		return client;
	}

}

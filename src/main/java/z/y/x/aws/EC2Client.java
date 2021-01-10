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
import com.amazonaws.services.elasticloadbalancing.AmazonElasticLoadBalancingClient;
import com.amazonaws.services.identitymanagement.AmazonIdentityManagementClient;
import com.amazonaws.services.route53.AmazonRoute53Client;

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
	
	public AmazonRoute53Client getRoute53Client(String accessKey, String secretKey, String region) throws Exception {
		AWSCredentialsProvider provider;
		if (accessKey != null && secretKey != null) {
			AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
			provider = new StaticCredentialsProvider(credentials);
		} else {
			provider = new DefaultAWSCredentialsProviderChain();
		}
		AmazonRoute53Client client = new AmazonRoute53Client(provider).withRegion(Regions.fromName(region));
		ClientConfiguration configuration = new ClientConfiguration();
		configuration.setProtocol(Protocol.HTTPS);
		return client;
	}
	
	//AmazonElasticLoadBalancingClient
	public AmazonElasticLoadBalancingClient  getELBClient(String accessKey, String secretKey, String region) throws Exception {
		AWSCredentialsProvider provider;
		if (accessKey != null && secretKey != null) {
			AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
			provider = new StaticCredentialsProvider(credentials);
		} else {
			provider = new DefaultAWSCredentialsProviderChain();
		}
		AmazonElasticLoadBalancingClient client = new AmazonElasticLoadBalancingClient(provider).withRegion(Regions.fromName(region));
		ClientConfiguration configuration = new ClientConfiguration();
		configuration.setProtocol(Protocol.HTTPS);
		return client;
	}
	
	public com.amazonaws.services.elasticloadbalancingv2.AmazonElasticLoadBalancingClient  getELBClientv2(String accessKey, String secretKey, String region) throws Exception {
		AWSCredentialsProvider provider;
		if (accessKey != null && secretKey != null) {
			AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
			provider = new StaticCredentialsProvider(credentials);
		} else {
			provider = new DefaultAWSCredentialsProviderChain();
		}
		com.amazonaws.services.elasticloadbalancingv2.AmazonElasticLoadBalancingClient  client = new com.amazonaws.services.elasticloadbalancingv2.AmazonElasticLoadBalancingClient (provider).withRegion(Regions.fromName(region));
		ClientConfiguration configuration = new ClientConfiguration();
		configuration.setProtocol(Protocol.HTTPS);
		return client;
	}
	
	public AmazonIdentityManagementClient  getIAM(String accessKey, String secretKey, String region) throws Exception {
		AWSCredentialsProvider provider;
		if (accessKey != null && secretKey != null) {
			AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
			provider = new StaticCredentialsProvider(credentials);
		} else {
			provider = new DefaultAWSCredentialsProviderChain();
		}
		AmazonIdentityManagementClient client = new AmazonIdentityManagementClient (provider).withRegion(Regions.fromName(region));
		ClientConfiguration configuration = new ClientConfiguration();
		configuration.setProtocol(Protocol.HTTPS);
		return client;
	}
}

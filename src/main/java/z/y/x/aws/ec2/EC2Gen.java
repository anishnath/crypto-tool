package z.y.x.aws.ec2;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.Protocol;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.internal.StaticCredentialsProvider;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.ec2.AmazonEC2Client;
import com.amazonaws.services.ec2.model.DescribeInstancesRequest;
import com.amazonaws.services.ec2.model.DescribeInstancesResult;
import com.amazonaws.services.ec2.model.GroupIdentifier;
import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.InstanceBlockDeviceMapping;
import com.amazonaws.services.ec2.model.Placement;
import com.amazonaws.services.ec2.model.Reservation;

import z.y.x.aws.EC2Client;
import z.y.x.aws.Utils;
import z.y.x.aws.ec2.secgroup.SecurityGroupGen;

/**
 * 
 * @author anishnath
 *
 */

public class EC2Gen {

	public static final String USER_DATA = "userData";

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

	public String getEC2(String accessKey, String secretKey, String region, String... instanceIds) throws Exception {

		AmazonEC2Client amazonEC2Client = new EC2Client().getEC2Client(accessKey, secretKey, region);

		DescribeInstancesRequest describeInstancesRequest = new DescribeInstancesRequest().withInstanceIds(instanceIds);
		DescribeInstancesResult describeHostsResult = amazonEC2Client.describeInstances(describeInstancesRequest);
		List<Task> listTasks = new ArrayList<Task>();
		List<AWSEC2GroupWrapper> awsec2GroupWrappers = new ArrayList<>();
		AWSEC2GroupWrapper awsec2GroupWrapper = new AWSEC2GroupWrapper();
		List<Reservation> lisReservations = describeHostsResult.getReservations();
		for (Iterator iterator = lisReservations.iterator(); iterator.hasNext();) {
			Reservation reservation = (Reservation) iterator.next();
			List<Instance> listInstances = reservation.getInstances();
			for (Iterator iterator2 = listInstances.iterator(); iterator2.hasNext();) {
				Task task = new Task();
				List<Volume> volList = new ArrayList<>();
				AwsEc2Pojo awsEc2Pojo = new AwsEc2Pojo();
				Instance instance = (Instance) iterator2.next();
				awsEc2Pojo.setKey_name(instance.getKeyName());
				List<String> groupList = new ArrayList<String>();
				for (Iterator iterator3 = instance.getSecurityGroups().iterator(); iterator3.hasNext();) {
					GroupIdentifier groupIdentifier = (GroupIdentifier) iterator3.next();
					groupList.add(groupIdentifier.getGroupName());
				}
				awsEc2Pojo.setGroup(groupList);
				awsEc2Pojo.setInstance_type(instance.getInstanceType());
				awsEc2Pojo.setImage(instance.getImageId());
				if (!"disabled".equalsIgnoreCase(instance.getMonitoring().getState())) {
					awsEc2Pojo.setMonitoring(true);
				}
				awsEc2Pojo.setVpc_subnet_id(instance.getSubnetId());
				if (instance.getPublicIpAddress() != null && instance.getPublicIpAddress().length() > 2) {
					awsEc2Pojo.setAssign_public_ip(true);
				}
				System.out.println(instance.getPublicIpAddress());
				Map<String, String> tagMap = new HashMap<String, String>();
				java.util.List<com.amazonaws.services.ec2.model.Tag> listTags = instance.getTags();
				for (iterator2 = listTags.iterator(); iterator2.hasNext();) {
					com.amazonaws.services.ec2.model.Tag tag = (com.amazonaws.services.ec2.model.Tag) iterator2.next();
					tagMap.put(tag.getKey(), tag.getValue());
				}
				if (tagMap.size() > 0) {
					awsEc2Pojo.setInstance_tags(tagMap);
				}

				java.util.List<InstanceBlockDeviceMapping> blockDeviceMappings = instance.getBlockDeviceMappings();
				for (Iterator iterator3 = blockDeviceMappings.iterator(); iterator3.hasNext();) {
					Volume volume = new Volume();
					InstanceBlockDeviceMapping instanceBlockDeviceMapping = (InstanceBlockDeviceMapping) iterator3
							.next();
					volume.setDevice_name(instanceBlockDeviceMapping.getDeviceName());
					volume.setDelete_on_termination(instanceBlockDeviceMapping.getEbs().getDeleteOnTermination());
					volList.add(volume);
				}

				awsEc2Pojo.setVolumes(volList);

				// State
				// pending running shutting-down terminated stopping stopped

				if ("stopped".equalsIgnoreCase(instance.getState().getName())) {
					List<String> instanceList = new ArrayList<>();
					instanceList.add(instance.getInstanceId());
					awsEc2Pojo.setState("stopped");
					awsEc2Pojo.setInstance_ids(instanceList);
				}
				if ("running".equalsIgnoreCase(instance.getState().getName())) {
					List<String> instanceList = new ArrayList<>();
					instanceList.add(instance.getInstanceId());
					awsEc2Pojo.setState("running");
					awsEc2Pojo.setInstance_ids(instanceList);
				}
				if ("terminated".equalsIgnoreCase(instance.getState().getName())) {
					List<String> instanceList = new ArrayList<>();
					instanceList.add(instance.getInstanceId());
					awsEc2Pojo.setState("absent");
					awsEc2Pojo.setInstance_ids(instanceList);
				}

				if (instance.getIamInstanceProfile() != null) {
					awsEc2Pojo.setInstance_profile_name(instance.getIamInstanceProfile().getArn());
				}

				// awsEc2Pojo.setTermination_protection(instance.get);
				// System.out.println(instance.));
				// awsEc2Pojo.setUser_data(instance.getMetadataOptions().);

				if (instance.getSourceDestCheck() != null) {
					awsEc2Pojo.setSource_dest_check("yes");
				}

				final com.amazonaws.services.ec2.model.DescribeInstanceAttributeResult response = amazonEC2Client
						.describeInstanceAttribute(
								new com.amazonaws.services.ec2.model.DescribeInstanceAttributeRequest()
										.withInstanceId(instance.getInstanceId()).withAttribute(USER_DATA));

				if (response.getInstanceAttribute() != null && response.getInstanceAttribute().getUserData() != null) {
					awsEc2Pojo.setUser_data(response.getInstanceAttribute().getUserData());
				}

				// System.out.println(response);

				if (instance.getPlacement() != null) {
					Placement placement = instance.getPlacement();
					awsEc2Pojo.setTenancy(placement.getTenancy());

				}

				task.setAmazonawsec2(awsEc2Pojo);
				listTasks.add(task);
			}

		}

		awsec2GroupWrapper.setTasks(listTasks);
		awsec2GroupWrappers.add(awsec2GroupWrapper);

		StringWriter writer = new StringWriter();
		Yaml yaml = Utils.getYAML();

		yaml.dump(awsec2GroupWrappers, writer);

		StringBuilder builder = new StringBuilder();
		builder.append("# Generated by the Online Tool 8gwifi.org \n");
		builder.append(writer.toString());

		// System.out.println(builder.toString());

		String s = builder.toString();
		s = s.replaceAll("amazonawsec2", "amazon.aws.ec2");

		return s;

	}

	public static void main(String[] args) throws Exception {
	}

}

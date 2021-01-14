package z.y.x.aws.iam;

import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

import com.amazonaws.services.identitymanagement.AmazonIdentityManagementClient;
import com.amazonaws.services.identitymanagement.model.AttachedPolicy;
import com.amazonaws.services.identitymanagement.model.Group;
import com.amazonaws.services.identitymanagement.model.ListAttachedGroupPoliciesRequest;
import com.amazonaws.services.identitymanagement.model.ListAttachedGroupPoliciesResult;
import com.amazonaws.services.identitymanagement.model.ListGroupsForUserRequest;
import com.amazonaws.services.identitymanagement.model.ListGroupsForUserResult;
import com.amazonaws.services.identitymanagement.model.ListUsersRequest;
import com.amazonaws.services.identitymanagement.model.ListUsersResult;
import com.amazonaws.services.identitymanagement.model.User;

import z.y.x.aws.EC2Client;
import z.y.x.aws.Utils;
import z.y.x.aws.iam.group.IAMWrapper;
import z.y.x.aws.iam.group.IamGroup;
import z.y.x.aws.iam.group.Task;

/**
 * 
 * @author anishnath
 *
 */
public class IAMGen {

	public String getIAM(String accessKey, String secretKey, String region, String... iammusers) throws Exception {

		Map<String, List> mappolicy = new HashMap<>();
		Map<String, List> userGroupMap = new HashMap<>();

		AmazonIdentityManagementClient amazonIdentityManagementClient = new EC2Client().getIAM(accessKey, secretKey,
				region);
		ListUsersResult listUsersResult;

		if (iammusers != null) {
			List<com.amazonaws.services.identitymanagement.model.User> userNameList = new ArrayList<com.amazonaws.services.identitymanagement.model.User>();
			for (String users : iammusers) {
				com.amazonaws.services.identitymanagement.model.User user = new User();
				user.setUserName(users);
				userNameList.add(user);

			}
			listUsersResult = amazonIdentityManagementClient.listUsers().withUsers(userNameList);
		} else {
			ListUsersRequest request = new ListUsersRequest();
			listUsersResult = amazonIdentityManagementClient.listUsers(request);
		}

		if (listUsersResult != null) {
			List<User> iamUserList = listUsersResult.getUsers();
			for (Iterator iterator = iamUserList.iterator(); iterator.hasNext();) {
				User user = (User) iterator.next();
				// System.out.println(user);

				// ListGroupsForUserResult listGroupsForUserResult =
				// amazonIdentityManagementClient.listGroupsForUser(new
				// ListGroupsForUserRequest().withUserName(user.getUserName()));
				ListGroupsForUserResult listGroupsForUserResult = amazonIdentityManagementClient
						.listGroupsForUser(new ListGroupsForUserRequest().withUserName(user.getUserName()));
				List<Group> iamGroupList = listGroupsForUserResult.getGroups();
				if (iamGroupList != null) {
					for (Iterator iterator3 = iamGroupList.iterator(); iterator3.hasNext();) {
						Group group = (Group) iterator3.next();
						// System.out.println(group);

						if (userGroupMap.get(group.getGroupName()) == null) {
							List<String> userName = new ArrayList<>();
							userName.add(user.getUserName());
							userGroupMap.put(group.getGroupName(), userName);
						} else {
							List<String> userName = userGroupMap.get(group.getGroupName());
							userName.add(user.getUserName());
						}

						ListAttachedGroupPoliciesResult listAttachedGroupPoliciesResult = amazonIdentityManagementClient
								.listAttachedGroupPolicies(
										new ListAttachedGroupPoliciesRequest().withGroupName(group.getGroupName()));
						List<AttachedPolicy> listAttachedPolicies = listAttachedGroupPoliciesResult
								.getAttachedPolicies();
						if (listAttachedPolicies != null) {
							for (Iterator iterator2 = listAttachedPolicies.iterator(); iterator2.hasNext();) {
								AttachedPolicy attachedPolicy = (AttachedPolicy) iterator2.next();
								// System.out.println(attachedPolicy);
								if (mappolicy.get(group.getGroupName()) == null) {
									List<String> policyARN = new ArrayList<>();
									policyARN.add(attachedPolicy.getPolicyArn());
									mappolicy.put(group.getGroupName(), policyARN);
								} else {
									List<String> policyARN = mappolicy.get(group.getGroupName());
									policyARN.add(attachedPolicy.getPolicyArn());
								}
							}
						}
					}
				}

			}
		} // End Main If

		// List<AWSVPCWrapper> awsVPCWrappersList = new ArrayList<>();
		// AWSVPCWrapper awsVPCWrappers = new AWSVPCWrapper();

		IAMWrapper iamWrapper = new IAMWrapper();
		List<IAMWrapper> iamWrapperList = new ArrayList<>();
		List<Task> tasklist = new ArrayList<>();
		Iterator it = userGroupMap.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry pair = (Map.Entry) it.next();
			// System.out.println(pair.getKey() + " = " + pair.getValue());

			Task task = new Task();
			IamGroup iamGroup = new IamGroup();
			iamGroup.setName(String.valueOf(pair.getKey()));
			iamGroup.setUsers((List) pair.getValue());
			iamGroup.setManaged_policy(mappolicy.get(pair.getKey()));
			task.setName("Creating IAM Group " + String.valueOf(pair.getKey()));
			task.setIam_group(iamGroup);
			tasklist.add(task);
			it.remove(); // avoids a ConcurrentModificationException
		}

		iamWrapper.setTasks(tasklist);
		iamWrapperList.add(iamWrapper);

		StringWriter writer = new StringWriter();
		Yaml yaml = Utils.getYAML();

		yaml.dump(iamWrapperList, writer);

		StringBuilder builder = new StringBuilder();
		builder.append("# IAM Group Generated by the Online Tool 8gwifi.org/aws.jsp \n");
		builder.append(writer.toString());
		String s = builder.toString();
		return s;

	}

	public static void main(String[] args) throws Exception {
		

	}

}

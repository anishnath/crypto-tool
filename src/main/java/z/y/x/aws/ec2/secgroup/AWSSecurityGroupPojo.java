package z.y.x.aws.ec2.secgroup;

import java.util.List;
import java.util.Map;

/**
 * 
 * @author anishnath
 *
 */
public class AWSSecurityGroupPojo {
	
	private String  name;
	private Map<String, Object> ec2_group;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Map<String, Object> getEc2_group() {
		return ec2_group;
	}
	public void setEc2_group(Map<String, Object> ec2_group) {
		this.ec2_group = ec2_group;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((ec2_group == null) ? 0 : ec2_group.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		AWSSecurityGroupPojo other = (AWSSecurityGroupPojo) obj;
		if (ec2_group == null) {
			if (other.ec2_group != null)
				return false;
		} else if (!ec2_group.equals(other.ec2_group))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "AWSSecurityGroupPojo [name=" + name + ", ec2_group=" + ec2_group + "]";
	}
	

}

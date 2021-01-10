package z.y.x.aws.vpc;

/**
 * 
 * @author anishnath
 *
 */

public class Task {
	private String name;
	private AmazonAwsEc2VpcNet ec2_vpc_net;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public AmazonAwsEc2VpcNet getEc2_vpc_net() {
		return ec2_vpc_net;
	}
	public void setEc2_vpc_net(AmazonAwsEc2VpcNet ec2_vpc_net) {
		this.ec2_vpc_net = ec2_vpc_net;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((ec2_vpc_net == null) ? 0 : ec2_vpc_net.hashCode());
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
		Task other = (Task) obj;
		if (ec2_vpc_net == null) {
			if (other.ec2_vpc_net != null)
				return false;
		} else if (!ec2_vpc_net.equals(other.ec2_vpc_net))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
	
	
	
}

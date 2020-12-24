package z.y.x.aws.ec2;

/**
 * 
 * @author anishnath
 *
 */

public class Task {
	
	public String name;
	public AwsEc2Pojo amazonawsec2;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public AwsEc2Pojo getAmazonawsec2() {
		return amazonawsec2;
	}
	public void setAmazonawsec2(AwsEc2Pojo amazonawsec2) {
		this.amazonawsec2 = amazonawsec2;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((amazonawsec2 == null) ? 0 : amazonawsec2.hashCode());
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
		if (amazonawsec2 == null) {
			if (other.amazonawsec2 != null)
				return false;
		} else if (!amazonawsec2.equals(other.amazonawsec2))
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
		return "Task [name=" + name + ", amazonawsec2=" + amazonawsec2 + "]";
	}
	
	

}

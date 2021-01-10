package z.y.x.aws.vpc;

import java.util.Map;

/**
 * 
 * @author anishnath
 *
 */
public class AmazonAwsEc2VpcNet {

	private String name;
	private String cidr_block;
	private String region;
	private Map<String, String> tags = null;
	private String tenancy="default";
	private String state  = "present";
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCidr_block() {
		return cidr_block;
	}
	public void setCidr_block(String cidr_block) {
		this.cidr_block = cidr_block;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public Map<String, String> getTags() {
		return tags;
	}
	public void setTags(Map<String, String> tags) {
		this.tags = tags;
	}
	public String getTenancy() {
		return tenancy;
	}
	public void setTenancy(String tenancy) {
		this.tenancy = tenancy;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((cidr_block == null) ? 0 : cidr_block.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((region == null) ? 0 : region.hashCode());
		result = prime * result + ((state == null) ? 0 : state.hashCode());
		result = prime * result + ((tags == null) ? 0 : tags.hashCode());
		result = prime * result + ((tenancy == null) ? 0 : tenancy.hashCode());
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
		AmazonAwsEc2VpcNet other = (AmazonAwsEc2VpcNet) obj;
		if (cidr_block == null) {
			if (other.cidr_block != null)
				return false;
		} else if (!cidr_block.equals(other.cidr_block))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (region == null) {
			if (other.region != null)
				return false;
		} else if (!region.equals(other.region))
			return false;
		if (state == null) {
			if (other.state != null)
				return false;
		} else if (!state.equals(other.state))
			return false;
		if (tags == null) {
			if (other.tags != null)
				return false;
		} else if (!tags.equals(other.tags))
			return false;
		if (tenancy == null) {
			if (other.tenancy != null)
				return false;
		} else if (!tenancy.equals(other.tenancy))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "AmazonAwsEc2VpcNet [name=" + name + ", cidr_block=" + cidr_block + ", region=" + region + ", tags="
				+ tags + ", tenancy=" + tenancy + ", state=" + state + "]";
	}
	
	
	
}

package z.y.x.aws.vpc.subnet;

import java.util.Map;

/**
 * 
 * @author anishnath
 *
 */
public class AmazonAwsSubnet {
	
	private String vpc_id;
	private String cidr;
	private String az;
	private String map_public;
	private Map<String, String> tags = null;
	private String state="present";
	public String getVpc_id() {
		return vpc_id;
	}
	public void setVpc_id(String vpc_id) {
		this.vpc_id = vpc_id;
	}
	public String getCidr() {
		return cidr;
	}
	public void setCidr(String cidr) {
		this.cidr = cidr;
	}
	public String getAz() {
		return az;
	}
	public void setAz(String az) {
		this.az = az;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public Map<String, String> getTags() {
		return tags;
	}
	public void setTags(Map<String, String> tags) {
		this.tags = tags;
	}
	public String getMap_public() {
		return map_public;
	}
	public void setMap_public(String map_public) {
		this.map_public = map_public;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((az == null) ? 0 : az.hashCode());
		result = prime * result + ((cidr == null) ? 0 : cidr.hashCode());
		result = prime * result + ((map_public == null) ? 0 : map_public.hashCode());
		result = prime * result + ((state == null) ? 0 : state.hashCode());
		result = prime * result + ((tags == null) ? 0 : tags.hashCode());
		result = prime * result + ((vpc_id == null) ? 0 : vpc_id.hashCode());
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
		AmazonAwsSubnet other = (AmazonAwsSubnet) obj;
		if (az == null) {
			if (other.az != null)
				return false;
		} else if (!az.equals(other.az))
			return false;
		if (cidr == null) {
			if (other.cidr != null)
				return false;
		} else if (!cidr.equals(other.cidr))
			return false;
		if (map_public == null) {
			if (other.map_public != null)
				return false;
		} else if (!map_public.equals(other.map_public))
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
		if (vpc_id == null) {
			if (other.vpc_id != null)
				return false;
		} else if (!vpc_id.equals(other.vpc_id))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "AmazonAwsSubnet [vpc_id=" + vpc_id + ", cidr=" + cidr + ", az=" + az + ", state=" + state + ", tags="
				+ tags + ", map_public=" + map_public + "]";
	}
	
	
	

}

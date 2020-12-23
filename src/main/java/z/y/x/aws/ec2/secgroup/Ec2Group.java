package z.y.x.aws.ec2.secgroup;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Ec2Group {

	private String name;
	private String description;
	private String region;
	private String awsAccessKey;
	private String awsSecretKey;
	private String vpc_id;
	private List<Rule> rules = null;
	private List<RulesEgress> rules_egress = null;
	private Map<String, String> tags = null;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String getAwsAccessKey() {
		return awsAccessKey;
	}
	public void setAwsAccessKey(String awsAccessKey) {
		this.awsAccessKey = awsAccessKey;
	}
	public String getAwsSecretKey() {
		return awsSecretKey;
	}
	public void setAwsSecretKey(String awsSecretKey) {
		this.awsSecretKey = awsSecretKey;
	}
	public String getVpc_id() {
		return vpc_id;
	}
	public void setVpc_id(String vpc_id) {
		this.vpc_id = vpc_id;
	}
	public List<Rule> getRules() {
		return rules;
	}
	public void setRules(List<Rule> rules) {
		this.rules = rules;
	}
	public List<RulesEgress> getRules_egress() {
		return rules_egress;
	}
	public void setRules_egress(List<RulesEgress> rules_egress) {
		this.rules_egress = rules_egress;
	}
	public Map<String, String> getTags() {
		return tags;
	}
	public void setTags(Map<String, String> tags) {
		this.tags = tags;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((awsAccessKey == null) ? 0 : awsAccessKey.hashCode());
		result = prime * result + ((awsSecretKey == null) ? 0 : awsSecretKey.hashCode());
		result = prime * result + ((description == null) ? 0 : description.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((region == null) ? 0 : region.hashCode());
		result = prime * result + ((rules == null) ? 0 : rules.hashCode());
		result = prime * result + ((rules_egress == null) ? 0 : rules_egress.hashCode());
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
		Ec2Group other = (Ec2Group) obj;
		if (awsAccessKey == null) {
			if (other.awsAccessKey != null)
				return false;
		} else if (!awsAccessKey.equals(other.awsAccessKey))
			return false;
		if (awsSecretKey == null) {
			if (other.awsSecretKey != null)
				return false;
		} else if (!awsSecretKey.equals(other.awsSecretKey))
			return false;
		if (description == null) {
			if (other.description != null)
				return false;
		} else if (!description.equals(other.description))
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
		if (rules == null) {
			if (other.rules != null)
				return false;
		} else if (!rules.equals(other.rules))
			return false;
		if (rules_egress == null) {
			if (other.rules_egress != null)
				return false;
		} else if (!rules_egress.equals(other.rules_egress))
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
		return "Ec2Group [name=" + name + ", description=" + description + ", region=" + region + ", awsAccessKey="
				+ awsAccessKey + ", awsSecretKey=" + awsSecretKey + ", vpc_id=" + vpc_id + ", rules=" + rules
				+ ", rules_egress=" + rules_egress + ", tags=" + tags + "]";
	}
	
}

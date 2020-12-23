package z.y.x.aws.ec2.secgroup;

import java.util.HashMap;
import java.util.Map;

public class RulesEgress {

	private String proto;
	private Integer from_port;
	private Integer to_port;
	private String cidr_ip;
	private String cidr_ipv6;
	private String group_id;
	private String group_name;
	private String group_desc;
	private String rule_desc;
	public String getProto() {
		return proto;
	}
	public void setProto(String proto) {
		this.proto = proto;
	}
	public Integer getFrom_port() {
		return from_port;
	}
	public void setFrom_port(Integer from_port) {
		this.from_port = from_port;
	}
	public Integer getTo_port() {
		return to_port;
	}
	public void setTo_port(Integer to_port) {
		this.to_port = to_port;
	}
	public String getCidr_ip() {
		return cidr_ip;
	}
	public void setCidr_ip(String cidr_ip) {
		this.cidr_ip = cidr_ip;
	}
	public String getCidr_ipv6() {
		return cidr_ipv6;
	}
	public void setCidr_ipv6(String cidr_ipv6) {
		this.cidr_ipv6 = cidr_ipv6;
	}
	public String getGroup_id() {
		return group_id;
	}
	public void setGroup_id(String group_id) {
		this.group_id = group_id;
	}
	public String getGroup_name() {
		return group_name;
	}
	public void setGroup_name(String group_name) {
		this.group_name = group_name;
	}
	public String getGroup_desc() {
		return group_desc;
	}
	public void setGroup_desc(String group_desc) {
		this.group_desc = group_desc;
	}
	public String getRule_desc() {
		return rule_desc;
	}
	public void setRule_desc(String rule_desc) {
		this.rule_desc = rule_desc;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((cidr_ip == null) ? 0 : cidr_ip.hashCode());
		result = prime * result + ((cidr_ipv6 == null) ? 0 : cidr_ipv6.hashCode());
		result = prime * result + ((from_port == null) ? 0 : from_port.hashCode());
		result = prime * result + ((group_desc == null) ? 0 : group_desc.hashCode());
		result = prime * result + ((group_id == null) ? 0 : group_id.hashCode());
		result = prime * result + ((group_name == null) ? 0 : group_name.hashCode());
		result = prime * result + ((proto == null) ? 0 : proto.hashCode());
		result = prime * result + ((rule_desc == null) ? 0 : rule_desc.hashCode());
		result = prime * result + ((to_port == null) ? 0 : to_port.hashCode());
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
		RulesEgress other = (RulesEgress) obj;
		if (cidr_ip == null) {
			if (other.cidr_ip != null)
				return false;
		} else if (!cidr_ip.equals(other.cidr_ip))
			return false;
		if (cidr_ipv6 == null) {
			if (other.cidr_ipv6 != null)
				return false;
		} else if (!cidr_ipv6.equals(other.cidr_ipv6))
			return false;
		if (from_port == null) {
			if (other.from_port != null)
				return false;
		} else if (!from_port.equals(other.from_port))
			return false;
		if (group_desc == null) {
			if (other.group_desc != null)
				return false;
		} else if (!group_desc.equals(other.group_desc))
			return false;
		if (group_id == null) {
			if (other.group_id != null)
				return false;
		} else if (!group_id.equals(other.group_id))
			return false;
		if (group_name == null) {
			if (other.group_name != null)
				return false;
		} else if (!group_name.equals(other.group_name))
			return false;
		if (proto == null) {
			if (other.proto != null)
				return false;
		} else if (!proto.equals(other.proto))
			return false;
		if (rule_desc == null) {
			if (other.rule_desc != null)
				return false;
		} else if (!rule_desc.equals(other.rule_desc))
			return false;
		if (to_port == null) {
			if (other.to_port != null)
				return false;
		} else if (!to_port.equals(other.to_port))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "RulesEgress [proto=" + proto + ", from_port=" + from_port + ", to_port=" + to_port + ", cidr_ip="
				+ cidr_ip + ", cidr_ipv6=" + cidr_ipv6 + ", group_id=" + group_id + ", group_name=" + group_name
				+ ", group_desc=" + group_desc + ", rule_desc=" + rule_desc + "]";
	}
	
	

}

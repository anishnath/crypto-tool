package z.y.x.aws.ec2;

import java.util.List;
import java.util.Map;

public class AwsEc2Pojo {
	private String id;
	private String key_name;
	
	private String instance_type;
	private String instance_profile_name;
	private Float spot_price;
	private Integer spot_wait_timeout;
	private String image;
	private Boolean wait;
	private Integer wait_timeout;
	private String vpc_subnet_id;
	private Boolean assign_public_ip=false;
	private Boolean monitoring=false;
	private String source_dest_check="no";
	private Boolean termination_protection=false;
	private String spot_launch_group;
	private String instance_initiated_shutdown_behavior;
	private String state;
	private List<String> instance_ids;
	private Integer count=1;
	private String tenancy;
	private String user_data;
	private List<Volume> volumes = null;
	private List<String> network_interfaces = null;
	private List<String> group = null;
	
	private Map<String, String> instance_tags = null;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getKey_name() {
		return key_name;
	}
	public void setKey_name(String key_name) {
		this.key_name = key_name;
	}
	public String getInstance_type() {
		return instance_type;
	}
	public void setInstance_type(String instance_type) {
		this.instance_type = instance_type;
	}
	public String getInstance_profile_name() {
		return instance_profile_name;
	}
	public void setInstance_profile_name(String instance_profile_name) {
		this.instance_profile_name = instance_profile_name;
	}
	public Float getSpot_price() {
		return spot_price;
	}
	public void setSpot_price(Float spot_price) {
		this.spot_price = spot_price;
	}
	public Integer getSpot_wait_timeout() {
		return spot_wait_timeout;
	}
	public void setSpot_wait_timeout(Integer spot_wait_timeout) {
		this.spot_wait_timeout = spot_wait_timeout;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public Boolean getWait() {
		return wait;
	}
	public void setWait(Boolean wait) {
		this.wait = wait;
	}
	public Integer getWait_timeout() {
		return wait_timeout;
	}
	public void setWait_timeout(Integer wait_timeout) {
		this.wait_timeout = wait_timeout;
	}
	public String getVpc_subnet_id() {
		return vpc_subnet_id;
	}
	public void setVpc_subnet_id(String vpc_subnet_id) {
		this.vpc_subnet_id = vpc_subnet_id;
	}
	public Boolean getAssign_public_ip() {
		return assign_public_ip;
	}
	public void setAssign_public_ip(Boolean assign_public_ip) {
		this.assign_public_ip = assign_public_ip;
	}
	public Boolean getMonitoring() {
		return monitoring;
	}
	public void setMonitoring(Boolean monitoring) {
		this.monitoring = monitoring;
	}
	public String getSource_dest_check() {
		return source_dest_check;
	}
	public void setSource_dest_check(String source_dest_check) {
		this.source_dest_check = source_dest_check;
	}
	public Boolean getTermination_protection() {
		return termination_protection;
	}
	public void setTermination_protection(Boolean termination_protection) {
		this.termination_protection = termination_protection;
	}
	public String getSpot_launch_group() {
		return spot_launch_group;
	}
	public void setSpot_launch_group(String spot_launch_group) {
		this.spot_launch_group = spot_launch_group;
	}
	public String getInstance_initiated_shutdown_behavior() {
		return instance_initiated_shutdown_behavior;
	}
	public void setInstance_initiated_shutdown_behavior(String instance_initiated_shutdown_behavior) {
		this.instance_initiated_shutdown_behavior = instance_initiated_shutdown_behavior;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public Integer getCount() {
		return count;
	}
	public void setCount(Integer count) {
		this.count = count;
	}
	public String getTenancy() {
		return tenancy;
	}
	public void setTenancy(String tenancy) {
		this.tenancy = tenancy;
	}
	public String getUser_data() {
		return user_data;
	}
	public void setUser_data(String user_data) {
		this.user_data = user_data;
	}
	public List<Volume> getVolumes() {
		return volumes;
	}
	public void setVolumes(List<Volume> volumes) {
		this.volumes = volumes;
	}
	public List<String> getNetwork_interfaces() {
		return network_interfaces;
	}
	public void setNetwork_interfaces(List<String> network_interfaces) {
		this.network_interfaces = network_interfaces;
	}
	public List<String> getGroup() {
		return group;
	}
	public void setGroup(List<String> group) {
		this.group = group;
	}
	public List<String> getInstance_ids() {
		return instance_ids;
	}
	public void setInstance_ids(List<String> instance_ids) {
		this.instance_ids = instance_ids;
	}
	public Map<String, String> getInstance_tags() {
		return instance_tags;
	}
	public void setInstance_tags(Map<String, String> instance_tags) {
		this.instance_tags = instance_tags;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((assign_public_ip == null) ? 0 : assign_public_ip.hashCode());
		result = prime * result + ((count == null) ? 0 : count.hashCode());
		result = prime * result + ((group == null) ? 0 : group.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((image == null) ? 0 : image.hashCode());
		result = prime * result + ((instance_ids == null) ? 0 : instance_ids.hashCode());
		result = prime * result + ((instance_initiated_shutdown_behavior == null) ? 0
				: instance_initiated_shutdown_behavior.hashCode());
		result = prime * result + ((instance_profile_name == null) ? 0 : instance_profile_name.hashCode());
		result = prime * result + ((instance_tags == null) ? 0 : instance_tags.hashCode());
		result = prime * result + ((instance_type == null) ? 0 : instance_type.hashCode());
		result = prime * result + ((key_name == null) ? 0 : key_name.hashCode());
		result = prime * result + ((monitoring == null) ? 0 : monitoring.hashCode());
		result = prime * result + ((network_interfaces == null) ? 0 : network_interfaces.hashCode());
		result = prime * result + ((source_dest_check == null) ? 0 : source_dest_check.hashCode());
		result = prime * result + ((spot_launch_group == null) ? 0 : spot_launch_group.hashCode());
		result = prime * result + ((spot_price == null) ? 0 : spot_price.hashCode());
		result = prime * result + ((spot_wait_timeout == null) ? 0 : spot_wait_timeout.hashCode());
		result = prime * result + ((state == null) ? 0 : state.hashCode());
		result = prime * result + ((tenancy == null) ? 0 : tenancy.hashCode());
		result = prime * result + ((termination_protection == null) ? 0 : termination_protection.hashCode());
		result = prime * result + ((user_data == null) ? 0 : user_data.hashCode());
		result = prime * result + ((volumes == null) ? 0 : volumes.hashCode());
		result = prime * result + ((vpc_subnet_id == null) ? 0 : vpc_subnet_id.hashCode());
		result = prime * result + ((wait == null) ? 0 : wait.hashCode());
		result = prime * result + ((wait_timeout == null) ? 0 : wait_timeout.hashCode());
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
		AwsEc2Pojo other = (AwsEc2Pojo) obj;
		if (assign_public_ip == null) {
			if (other.assign_public_ip != null)
				return false;
		} else if (!assign_public_ip.equals(other.assign_public_ip))
			return false;
		if (count == null) {
			if (other.count != null)
				return false;
		} else if (!count.equals(other.count))
			return false;
		if (group == null) {
			if (other.group != null)
				return false;
		} else if (!group.equals(other.group))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (image == null) {
			if (other.image != null)
				return false;
		} else if (!image.equals(other.image))
			return false;
		if (instance_ids == null) {
			if (other.instance_ids != null)
				return false;
		} else if (!instance_ids.equals(other.instance_ids))
			return false;
		if (instance_initiated_shutdown_behavior == null) {
			if (other.instance_initiated_shutdown_behavior != null)
				return false;
		} else if (!instance_initiated_shutdown_behavior.equals(other.instance_initiated_shutdown_behavior))
			return false;
		if (instance_profile_name == null) {
			if (other.instance_profile_name != null)
				return false;
		} else if (!instance_profile_name.equals(other.instance_profile_name))
			return false;
		if (instance_tags == null) {
			if (other.instance_tags != null)
				return false;
		} else if (!instance_tags.equals(other.instance_tags))
			return false;
		if (instance_type == null) {
			if (other.instance_type != null)
				return false;
		} else if (!instance_type.equals(other.instance_type))
			return false;
		if (key_name == null) {
			if (other.key_name != null)
				return false;
		} else if (!key_name.equals(other.key_name))
			return false;
		if (monitoring == null) {
			if (other.monitoring != null)
				return false;
		} else if (!monitoring.equals(other.monitoring))
			return false;
		if (network_interfaces == null) {
			if (other.network_interfaces != null)
				return false;
		} else if (!network_interfaces.equals(other.network_interfaces))
			return false;
		if (source_dest_check == null) {
			if (other.source_dest_check != null)
				return false;
		} else if (!source_dest_check.equals(other.source_dest_check))
			return false;
		if (spot_launch_group == null) {
			if (other.spot_launch_group != null)
				return false;
		} else if (!spot_launch_group.equals(other.spot_launch_group))
			return false;
		if (spot_price == null) {
			if (other.spot_price != null)
				return false;
		} else if (!spot_price.equals(other.spot_price))
			return false;
		if (spot_wait_timeout == null) {
			if (other.spot_wait_timeout != null)
				return false;
		} else if (!spot_wait_timeout.equals(other.spot_wait_timeout))
			return false;
		if (state == null) {
			if (other.state != null)
				return false;
		} else if (!state.equals(other.state))
			return false;
		if (tenancy == null) {
			if (other.tenancy != null)
				return false;
		} else if (!tenancy.equals(other.tenancy))
			return false;
		if (termination_protection == null) {
			if (other.termination_protection != null)
				return false;
		} else if (!termination_protection.equals(other.termination_protection))
			return false;
		if (user_data == null) {
			if (other.user_data != null)
				return false;
		} else if (!user_data.equals(other.user_data))
			return false;
		if (volumes == null) {
			if (other.volumes != null)
				return false;
		} else if (!volumes.equals(other.volumes))
			return false;
		if (vpc_subnet_id == null) {
			if (other.vpc_subnet_id != null)
				return false;
		} else if (!vpc_subnet_id.equals(other.vpc_subnet_id))
			return false;
		if (wait == null) {
			if (other.wait != null)
				return false;
		} else if (!wait.equals(other.wait))
			return false;
		if (wait_timeout == null) {
			if (other.wait_timeout != null)
				return false;
		} else if (!wait_timeout.equals(other.wait_timeout))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "AwsEc2Pojo [id=" + id + ", key_name=" + key_name + ", instance_type=" + instance_type
				+ ", instance_profile_name=" + instance_profile_name + ", spot_price=" + spot_price
				+ ", spot_wait_timeout=" + spot_wait_timeout + ", image=" + image + ", wait=" + wait + ", wait_timeout="
				+ wait_timeout + ", vpc_subnet_id=" + vpc_subnet_id + ", assign_public_ip=" + assign_public_ip
				+ ", monitoring=" + monitoring + ", source_dest_check=" + source_dest_check
				+ ", termination_protection=" + termination_protection + ", spot_launch_group=" + spot_launch_group
				+ ", instance_initiated_shutdown_behavior=" + instance_initiated_shutdown_behavior + ", state=" + state
				+ ", count=" + count + ", tenancy=" + tenancy + ", user_data=" + user_data + ", volumes=" + volumes
				+ ", network_interfaces=" + network_interfaces + ", group=" + group + ", instance_ids=" + instance_ids
				+ ", instance_tags=" + instance_tags + "]";
	}
}

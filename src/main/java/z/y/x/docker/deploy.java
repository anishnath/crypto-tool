package z.y.x.docker;

import java.util.Map;

public class deploy {
	
	int replicas=1;
	private Map<String,Object> update_config;
	private Map<String,Object> restart_policy;
	//private Map<String,String[]> placement;
	private placement placement;
	private resources resources;
	public int getReplicas() {
		return replicas;
	}
	public void setReplicas(int replicas) {
		this.replicas = replicas;
	}
	public Map<String, Object> getUpdate_config() {
		return update_config;
	}
	public void setUpdate_config(Map<String, Object> update_config) {
		this.update_config = update_config;
	}
	public Map<String, Object> getRestart_policy() {
		return restart_policy;
	}
	public void setRestart_policy(Map<String, Object> restart_policy) {
		this.restart_policy = restart_policy;
	}
	public placement getPlacement() {
		return placement;
	}
	public void setPlacement(placement placement) {
		this.placement = placement;
	}
	public resources getResources() {
		return resources;
	}
	public void setResources(resources resources) {
		this.resources = resources;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((placement == null) ? 0 : placement.hashCode());
		result = prime * result + replicas;
		result = prime * result + ((resources == null) ? 0 : resources.hashCode());
		result = prime * result + ((restart_policy == null) ? 0 : restart_policy.hashCode());
		result = prime * result + ((update_config == null) ? 0 : update_config.hashCode());
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
		deploy other = (deploy) obj;
		if (placement == null) {
			if (other.placement != null)
				return false;
		} else if (!placement.equals(other.placement))
			return false;
		if (replicas != other.replicas)
			return false;
		if (resources == null) {
			if (other.resources != null)
				return false;
		} else if (!resources.equals(other.resources))
			return false;
		if (restart_policy == null) {
			if (other.restart_policy != null)
				return false;
		} else if (!restart_policy.equals(other.restart_policy))
			return false;
		if (update_config == null) {
			if (other.update_config != null)
				return false;
		} else if (!update_config.equals(other.update_config))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "deploy [replicas=" + replicas + ", "
				+ (update_config != null ? "update_config=" + update_config + ", " : "")
				+ (restart_policy != null ? "restart_policy=" + restart_policy + ", " : "")
				+ (placement != null ? "placement=" + placement + ", " : "")
				+ (resources != null ? "resources=" + resources : "") + "]";
	}
	
	
}

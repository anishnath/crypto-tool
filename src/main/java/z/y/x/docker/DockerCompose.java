package z.y.x.docker;

import java.util.Map;

public class DockerCompose {
	
	private String version="3";
	private Map<String,services> services;
	
	
	private Map<String,String> volumes;
	private Map<String,String> networks;
	
	
	

	public Map<String, String> getVolumes() {
		return volumes;
	}

	public void setVolumes(Map<String, String> volumes) {
		this.volumes = volumes;
	}

	public Map<String, String> getNetworks() {
		return networks;
	}

	public void setNetworks(Map<String, String> networks) {
		this.networks = networks;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public Map<String, services> getServices() {
		return services;
	}

	public void setServices(Map<String, services> services) {
		this.services = services;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((networks == null) ? 0 : networks.hashCode());
		result = prime * result + ((services == null) ? 0 : services.hashCode());
		result = prime * result + ((version == null) ? 0 : version.hashCode());
		result = prime * result + ((volumes == null) ? 0 : volumes.hashCode());
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
		DockerCompose other = (DockerCompose) obj;
		if (networks == null) {
			if (other.networks != null)
				return false;
		} else if (!networks.equals(other.networks))
			return false;
		if (services == null) {
			if (other.services != null)
				return false;
		} else if (!services.equals(other.services))
			return false;
		if (version == null) {
			if (other.version != null)
				return false;
		} else if (!version.equals(other.version))
			return false;
		if (volumes == null) {
			if (other.volumes != null)
				return false;
		} else if (!volumes.equals(other.volumes))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "DockerCompose [" + (version != null ? "version=" + version + ", " : "")
				+ (services != null ? "services=" + services + ", " : "")
				+ (volumes != null ? "volumes=" + volumes + ", " : "")
				+ (networks != null ? "networks=" + networks : "") + "]";
	}

	
	

}

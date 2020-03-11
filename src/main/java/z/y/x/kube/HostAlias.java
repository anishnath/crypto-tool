package z.y.x.kube;

import java.util.List;

public class HostAlias {

	
	private String ip;
	private List<String> hostnames;
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public List<String> getHostnames() {
		return hostnames;
	}
	public void setHostnames(List<String> hostnames) {
		this.hostnames = hostnames;
	}
	@Override
	public String toString() {
		return "HostAlias [ip=" + ip + ", hostnames=" + hostnames + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((hostnames == null) ? 0 : hostnames.hashCode());
		result = prime * result + ((ip == null) ? 0 : ip.hashCode());
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
		HostAlias other = (HostAlias) obj;
		if (hostnames == null) {
			if (other.hostnames != null)
				return false;
		} else if (!hostnames.equals(other.hostnames))
			return false;
		if (ip == null) {
			if (other.ip != null)
				return false;
		} else if (!ip.equals(other.ip))
			return false;
		return true;
	}
	
	
	
}

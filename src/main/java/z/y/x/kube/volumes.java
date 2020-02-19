package z.y.x.kube;

public class volumes {
	
	private String name;
	private hostPath hostPath;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public hostPath getHostPath() {
		return hostPath;
	}
	public void setHostPath(hostPath hostPath) {
		this.hostPath = hostPath;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((hostPath == null) ? 0 : hostPath.hashCode());
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
		volumes other = (volumes) obj;
		if (hostPath == null) {
			if (other.hostPath != null)
				return false;
		} else if (!hostPath.equals(other.hostPath))
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
		return "volumes [" + (name != null ? "name=" + name + ", " : "")
				+ (hostPath != null ? "hostPath=" + hostPath : "") + "]";
	}
	
	

}

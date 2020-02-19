package z.y.x.kube;

public class ports {
	
	private int containerPort;
	private String name;
	private String protocol;
	public int getContainerPort() {
		return containerPort;
	}
	public void setContainerPort(int containerPort) {
		this.containerPort = containerPort;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getProtocol() {
		return protocol;
	}
	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + containerPort;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((protocol == null) ? 0 : protocol.hashCode());
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
		ports other = (ports) obj;
		if (containerPort != other.containerPort)
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (protocol == null) {
			if (other.protocol != null)
				return false;
		} else if (!protocol.equals(other.protocol))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "ports [containerPort=" + containerPort + ", " + (name != null ? "name=" + name + ", " : "")
				+ (protocol != null ? "protocol=" + protocol : "") + "]";
	}

	
	
}

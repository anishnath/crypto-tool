package z.y.x.kube.service;

public class servicepojo {
	private String containerPort;
	private String targetPort;
	public String getContainerPort() {
		return containerPort;
	}
	public void setContainerPort(String containerPort) {
		this.containerPort = containerPort;
	}
	public String getTargetPort() {
		return targetPort;
	}
	public void setTargetPort(String targetPort) {
		this.targetPort = targetPort;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((containerPort == null) ? 0 : containerPort.hashCode());
		result = prime * result + ((targetPort == null) ? 0 : targetPort.hashCode());
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
		servicepojo other = (servicepojo) obj;
		if (containerPort == null) {
			if (other.containerPort != null)
				return false;
		} else if (!containerPort.equals(other.containerPort))
			return false;
		if (targetPort == null) {
			if (other.targetPort != null)
				return false;
		} else if (!targetPort.equals(other.targetPort))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "servicepojo [containerPort=" + containerPort + ", targetPort=" + targetPort + "]";
	}
	
	
}

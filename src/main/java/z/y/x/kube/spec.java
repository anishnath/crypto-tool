package z.y.x.kube;

import java.util.List;

public class spec {
	
	private String dnsPolicy;
	private String serviceAccountName;
	private String restartPolicy;
	private String subdomain;
	private String hostname;
	private String nodeName;
	
	private List<containers> containers;
	private List<volumes> volumes;

	
	private securityContext securityContext;

	

	public List<volumes> getVolumes() {
		return volumes;
	}


	public void setVolumes(List<volumes> volumes) {
		this.volumes = volumes;
	}


	public String getDnsPolicy() {
		return dnsPolicy;
	}


	public void setDnsPolicy(String dnsPolicy) {
		this.dnsPolicy = dnsPolicy;
	}


	public String getServiceAccountName() {
		return serviceAccountName;
	}


	public void setServiceAccountName(String serviceAccountName) {
		this.serviceAccountName = serviceAccountName;
	}


	public String getRestartPolicy() {
		return restartPolicy;
	}


	public void setRestartPolicy(String restartPolicy) {
		this.restartPolicy = restartPolicy;
	}


	public String getSubdomain() {
		return subdomain;
	}


	public void setSubdomain(String subdomain) {
		this.subdomain = subdomain;
	}


	public String getHostname() {
		return hostname;
	}


	public void setHostname(String hostname) {
		this.hostname = hostname;
	}


	public String getNodeName() {
		return nodeName;
	}


	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}


	public List<containers> getContainers() {
		return containers;
	}


	public void setContainers(List<containers> containers) {
		this.containers = containers;
	}


	public securityContext getSecurityContext() {
		return securityContext;
	}


	public void setSecurityContext(securityContext securityContext) {
		this.securityContext = securityContext;
	}


	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((containers == null) ? 0 : containers.hashCode());
		result = prime * result + ((dnsPolicy == null) ? 0 : dnsPolicy.hashCode());
		result = prime * result + ((hostname == null) ? 0 : hostname.hashCode());
		result = prime * result + ((nodeName == null) ? 0 : nodeName.hashCode());
		result = prime * result + ((restartPolicy == null) ? 0 : restartPolicy.hashCode());
		result = prime * result + ((securityContext == null) ? 0 : securityContext.hashCode());
		result = prime * result + ((serviceAccountName == null) ? 0 : serviceAccountName.hashCode());
		result = prime * result + ((subdomain == null) ? 0 : subdomain.hashCode());
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
		spec other = (spec) obj;
		if (containers == null) {
			if (other.containers != null)
				return false;
		} else if (!containers.equals(other.containers))
			return false;
		if (dnsPolicy == null) {
			if (other.dnsPolicy != null)
				return false;
		} else if (!dnsPolicy.equals(other.dnsPolicy))
			return false;
		if (hostname == null) {
			if (other.hostname != null)
				return false;
		} else if (!hostname.equals(other.hostname))
			return false;
		if (nodeName == null) {
			if (other.nodeName != null)
				return false;
		} else if (!nodeName.equals(other.nodeName))
			return false;
		if (restartPolicy == null) {
			if (other.restartPolicy != null)
				return false;
		} else if (!restartPolicy.equals(other.restartPolicy))
			return false;
		if (securityContext == null) {
			if (other.securityContext != null)
				return false;
		} else if (!securityContext.equals(other.securityContext))
			return false;
		if (serviceAccountName == null) {
			if (other.serviceAccountName != null)
				return false;
		} else if (!serviceAccountName.equals(other.serviceAccountName))
			return false;
		if (subdomain == null) {
			if (other.subdomain != null)
				return false;
		} else if (!subdomain.equals(other.subdomain))
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
		return "spec [" + (dnsPolicy != null ? "dnsPolicy=" + dnsPolicy + ", " : "")
				+ (serviceAccountName != null ? "serviceAccountName=" + serviceAccountName + ", " : "")
				+ (restartPolicy != null ? "restartPolicy=" + restartPolicy + ", " : "")
				+ (subdomain != null ? "subdomain=" + subdomain + ", " : "")
				+ (hostname != null ? "hostname=" + hostname + ", " : "")
				+ (nodeName != null ? "nodeName=" + nodeName + ", " : "")
				+ (containers != null ? "containers=" + containers + ", " : "")
				+ (volumes != null ? "volumes=" + volumes + ", " : "")
				+ (securityContext != null ? "securityContext=" + securityContext : "") + "]";
	}
	
	
	
	



}

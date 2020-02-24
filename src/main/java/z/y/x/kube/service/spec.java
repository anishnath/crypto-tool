package z.y.x.kube.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class spec {
	
	private String clusterIP;
	private String[] externalIPs;
	private String externalName;
	private String externalTrafficPolicy;
	private int healthCheckNodePort;
	private String loadBalancerIP;
	private String loadBalancerSourceRanges;
	private List<ports> ports;
	private Map<String,String> selector;
	private boolean publishNotReadyAddresses;
	//private selector selector;
	private String sessionAffinity="None";
	private String type = "NodePort";
	public String getClusterIP() {
		return clusterIP;
	}
	public void setClusterIP(String clusterIP) {
		this.clusterIP = clusterIP;
	}
	public String[] getExternalIPs() {
		return externalIPs;
	}
	public void setExternalIPs(String[] externalIPs) {
		this.externalIPs = externalIPs;
	}
	public String getExternalName() {
		return externalName;
	}
	public void setExternalName(String externalName) {
		this.externalName = externalName;
	}
	public String getExternalTrafficPolicy() {
		return externalTrafficPolicy;
	}
	public void setExternalTrafficPolicy(String externalTrafficPolicy) {
		this.externalTrafficPolicy = externalTrafficPolicy;
	}
	public int getHealthCheckNodePort() {
		return healthCheckNodePort;
	}
	public void setHealthCheckNodePort(int healthCheckNodePort) {
		this.healthCheckNodePort = healthCheckNodePort;
	}
	public String getLoadBalancerIP() {
		return loadBalancerIP;
	}
	public void setLoadBalancerIP(String loadBalancerIP) {
		this.loadBalancerIP = loadBalancerIP;
	}
	public String getLoadBalancerSourceRanges() {
		return loadBalancerSourceRanges;
	}
	public void setLoadBalancerSourceRanges(String loadBalancerSourceRanges) {
		this.loadBalancerSourceRanges = loadBalancerSourceRanges;
	}
	public List<ports> getPorts() {
		return ports;
	}
	public void setPorts(List<ports> ports) {
		this.ports = ports;
	}
	public Map<String, String> getSelector() {
		return selector;
	}
	public void setSelector(Map<String, String> selector) {
		this.selector = selector;
	}
	public boolean isPublishNotReadyAddresses() {
		return publishNotReadyAddresses;
	}
	public void setPublishNotReadyAddresses(boolean publishNotReadyAddresses) {
		this.publishNotReadyAddresses = publishNotReadyAddresses;
	}
	public String getSessionAffinity() {
		return sessionAffinity;
	}
	public void setSessionAffinity(String sessionAffinity) {
		this.sessionAffinity = sessionAffinity;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((clusterIP == null) ? 0 : clusterIP.hashCode());
		result = prime * result + Arrays.hashCode(externalIPs);
		result = prime * result + ((externalName == null) ? 0 : externalName.hashCode());
		result = prime * result + ((externalTrafficPolicy == null) ? 0 : externalTrafficPolicy.hashCode());
		result = prime * result + healthCheckNodePort;
		result = prime * result + ((loadBalancerIP == null) ? 0 : loadBalancerIP.hashCode());
		result = prime * result + ((loadBalancerSourceRanges == null) ? 0 : loadBalancerSourceRanges.hashCode());
		result = prime * result + ((ports == null) ? 0 : ports.hashCode());
		result = prime * result + (publishNotReadyAddresses ? 1231 : 1237);
		result = prime * result + ((selector == null) ? 0 : selector.hashCode());
		result = prime * result + ((sessionAffinity == null) ? 0 : sessionAffinity.hashCode());
		result = prime * result + ((type == null) ? 0 : type.hashCode());
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
		if (clusterIP == null) {
			if (other.clusterIP != null)
				return false;
		} else if (!clusterIP.equals(other.clusterIP))
			return false;
		if (!Arrays.equals(externalIPs, other.externalIPs))
			return false;
		if (externalName == null) {
			if (other.externalName != null)
				return false;
		} else if (!externalName.equals(other.externalName))
			return false;
		if (externalTrafficPolicy == null) {
			if (other.externalTrafficPolicy != null)
				return false;
		} else if (!externalTrafficPolicy.equals(other.externalTrafficPolicy))
			return false;
		if (healthCheckNodePort != other.healthCheckNodePort)
			return false;
		if (loadBalancerIP == null) {
			if (other.loadBalancerIP != null)
				return false;
		} else if (!loadBalancerIP.equals(other.loadBalancerIP))
			return false;
		if (loadBalancerSourceRanges == null) {
			if (other.loadBalancerSourceRanges != null)
				return false;
		} else if (!loadBalancerSourceRanges.equals(other.loadBalancerSourceRanges))
			return false;
		if (ports == null) {
			if (other.ports != null)
				return false;
		} else if (!ports.equals(other.ports))
			return false;
		if (publishNotReadyAddresses != other.publishNotReadyAddresses)
			return false;
		if (selector == null) {
			if (other.selector != null)
				return false;
		} else if (!selector.equals(other.selector))
			return false;
		if (sessionAffinity == null) {
			if (other.sessionAffinity != null)
				return false;
		} else if (!sessionAffinity.equals(other.sessionAffinity))
			return false;
		if (type == null) {
			if (other.type != null)
				return false;
		} else if (!type.equals(other.type))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "spec [" + (clusterIP != null ? "clusterIP=" + clusterIP + ", " : "")
				+ (externalIPs != null ? "externalIPs=" + Arrays.toString(externalIPs) + ", " : "")
				+ (externalName != null ? "externalName=" + externalName + ", " : "")
				+ (externalTrafficPolicy != null ? "externalTrafficPolicy=" + externalTrafficPolicy + ", " : "")
				+ "healthCheckNodePort=" + healthCheckNodePort + ", "
				+ (loadBalancerIP != null ? "loadBalancerIP=" + loadBalancerIP + ", " : "")
				+ (loadBalancerSourceRanges != null ? "loadBalancerSourceRanges=" + loadBalancerSourceRanges + ", "
						: "")
				+ (ports != null ? "ports=" + ports + ", " : "")
				+ (selector != null ? "selector=" + selector + ", " : "") + "publishNotReadyAddresses="
				+ publishNotReadyAddresses + ", "
				+ (sessionAffinity != null ? "sessionAffinity=" + sessionAffinity + ", " : "")
				+ (type != null ? "type=" + type : "") + "]";
	}
	
	
}

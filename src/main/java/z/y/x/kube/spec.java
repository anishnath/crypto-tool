package z.y.x.kube;
import java.util.List;
import java.util.Map;

public class spec {
	
	private int activeDeadlineSeconds;
	private boolean automountServiceAccountToken;
	private List<containers> containers;
	private dnsConfig dnsConfig;
	private String dnsPolicy;
	private boolean enableServiceLinks;
	private List<HostAlias> hostAliases;
	private boolean hostIPC;
	private boolean hostNetwork;
	private boolean hostPID;
	private String hostname;
	private String nodeName;
	private Map<String,String> nodeSelector;
	private int priority;
	private String priorityClassName;
	private String restartPolicy;
	private String runtimeClassName;
	private String schedulerName;
	private securityContext securityContext;
	private String serviceAccountName;
	private String subdomain;
	private int terminationGracePeriodSeconds;
	private List<Toleration> tolerations;
	private List<volumes> volumes;
	public int getActiveDeadlineSeconds() {
		return activeDeadlineSeconds;
	}
	public void setActiveDeadlineSeconds(int activeDeadlineSeconds) {
		this.activeDeadlineSeconds = activeDeadlineSeconds;
	}
	public boolean isAutomountServiceAccountToken() {
		return automountServiceAccountToken;
	}
	public void setAutomountServiceAccountToken(boolean automountServiceAccountToken) {
		this.automountServiceAccountToken = automountServiceAccountToken;
	}
	public List<containers> getContainers() {
		return containers;
	}
	public void setContainers(List<containers> containers) {
		this.containers = containers;
	}
	public dnsConfig getDnsConfig() {
		return dnsConfig;
	}
	public void setDnsConfig(dnsConfig dnsConfig) {
		this.dnsConfig = dnsConfig;
	}
	public String getDnsPolicy() {
		return dnsPolicy;
	}
	public void setDnsPolicy(String dnsPolicy) {
		this.dnsPolicy = dnsPolicy;
	}
	public boolean isEnableServiceLinks() {
		return enableServiceLinks;
	}
	public void setEnableServiceLinks(boolean enableServiceLinks) {
		this.enableServiceLinks = enableServiceLinks;
	}
	public List<HostAlias> getHostAliases() {
		return hostAliases;
	}
	public void setHostAliases(List<HostAlias> hostAliases) {
		this.hostAliases = hostAliases;
	}
	public boolean isHostIPC() {
		return hostIPC;
	}
	public void setHostIPC(boolean hostIPC) {
		this.hostIPC = hostIPC;
	}
	public boolean isHostNetwork() {
		return hostNetwork;
	}
	public void setHostNetwork(boolean hostNetwork) {
		this.hostNetwork = hostNetwork;
	}
	public boolean isHostPID() {
		return hostPID;
	}
	public void setHostPID(boolean hostPID) {
		this.hostPID = hostPID;
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
	public Map<String, String> getNodeSelector() {
		return nodeSelector;
	}
	public void setNodeSelector(Map<String, String> nodeSelector) {
		this.nodeSelector = nodeSelector;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public String getPriorityClassName() {
		return priorityClassName;
	}
	public void setPriorityClassName(String priorityClassName) {
		this.priorityClassName = priorityClassName;
	}
	public String getRestartPolicy() {
		return restartPolicy;
	}
	public void setRestartPolicy(String restartPolicy) {
		this.restartPolicy = restartPolicy;
	}
	public String getRuntimeClassName() {
		return runtimeClassName;
	}
	public void setRuntimeClassName(String runtimeClassName) {
		this.runtimeClassName = runtimeClassName;
	}
	public String getSchedulerName() {
		return schedulerName;
	}
	public void setSchedulerName(String schedulerName) {
		this.schedulerName = schedulerName;
	}
	public securityContext getSecurityContext() {
		return securityContext;
	}
	public void setSecurityContext(securityContext securityContext) {
		this.securityContext = securityContext;
	}
	public String getServiceAccountName() {
		return serviceAccountName;
	}
	public void setServiceAccountName(String serviceAccountName) {
		this.serviceAccountName = serviceAccountName;
	}
	public String getSubdomain() {
		return subdomain;
	}
	public void setSubdomain(String subdomain) {
		this.subdomain = subdomain;
	}
	public int getTerminationGracePeriodSeconds() {
		return terminationGracePeriodSeconds;
	}
	public void setTerminationGracePeriodSeconds(int terminationGracePeriodSeconds) {
		this.terminationGracePeriodSeconds = terminationGracePeriodSeconds;
	}
	public List<Toleration> getTolerations() {
		return tolerations;
	}
	public void setTolerations(List<Toleration> tolerations) {
		this.tolerations = tolerations;
	}
	public List<volumes> getVolumes() {
		return volumes;
	}
	public void setVolumes(List<volumes> volumes) {
		this.volumes = volumes;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + activeDeadlineSeconds;
		result = prime * result + (automountServiceAccountToken ? 1231 : 1237);
		result = prime * result + ((containers == null) ? 0 : containers.hashCode());
		result = prime * result + ((dnsConfig == null) ? 0 : dnsConfig.hashCode());
		result = prime * result + ((dnsPolicy == null) ? 0 : dnsPolicy.hashCode());
		result = prime * result + (enableServiceLinks ? 1231 : 1237);
		result = prime * result + ((hostAliases == null) ? 0 : hostAliases.hashCode());
		result = prime * result + (hostIPC ? 1231 : 1237);
		result = prime * result + (hostNetwork ? 1231 : 1237);
		result = prime * result + (hostPID ? 1231 : 1237);
		result = prime * result + ((hostname == null) ? 0 : hostname.hashCode());
		result = prime * result + ((nodeName == null) ? 0 : nodeName.hashCode());
		result = prime * result + ((nodeSelector == null) ? 0 : nodeSelector.hashCode());
		result = prime * result + priority;
		result = prime * result + ((priorityClassName == null) ? 0 : priorityClassName.hashCode());
		result = prime * result + ((restartPolicy == null) ? 0 : restartPolicy.hashCode());
		result = prime * result + ((runtimeClassName == null) ? 0 : runtimeClassName.hashCode());
		result = prime * result + ((schedulerName == null) ? 0 : schedulerName.hashCode());
		result = prime * result + ((securityContext == null) ? 0 : securityContext.hashCode());
		result = prime * result + ((serviceAccountName == null) ? 0 : serviceAccountName.hashCode());
		result = prime * result + ((subdomain == null) ? 0 : subdomain.hashCode());
		result = prime * result + terminationGracePeriodSeconds;
		result = prime * result + ((tolerations == null) ? 0 : tolerations.hashCode());
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
		if (activeDeadlineSeconds != other.activeDeadlineSeconds)
			return false;
		if (automountServiceAccountToken != other.automountServiceAccountToken)
			return false;
		if (containers == null) {
			if (other.containers != null)
				return false;
		} else if (!containers.equals(other.containers))
			return false;
		if (dnsConfig == null) {
			if (other.dnsConfig != null)
				return false;
		} else if (!dnsConfig.equals(other.dnsConfig))
			return false;
		if (dnsPolicy == null) {
			if (other.dnsPolicy != null)
				return false;
		} else if (!dnsPolicy.equals(other.dnsPolicy))
			return false;
		if (enableServiceLinks != other.enableServiceLinks)
			return false;
		if (hostAliases == null) {
			if (other.hostAliases != null)
				return false;
		} else if (!hostAliases.equals(other.hostAliases))
			return false;
		if (hostIPC != other.hostIPC)
			return false;
		if (hostNetwork != other.hostNetwork)
			return false;
		if (hostPID != other.hostPID)
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
		if (nodeSelector == null) {
			if (other.nodeSelector != null)
				return false;
		} else if (!nodeSelector.equals(other.nodeSelector))
			return false;
		if (priority != other.priority)
			return false;
		if (priorityClassName == null) {
			if (other.priorityClassName != null)
				return false;
		} else if (!priorityClassName.equals(other.priorityClassName))
			return false;
		if (restartPolicy == null) {
			if (other.restartPolicy != null)
				return false;
		} else if (!restartPolicy.equals(other.restartPolicy))
			return false;
		if (runtimeClassName == null) {
			if (other.runtimeClassName != null)
				return false;
		} else if (!runtimeClassName.equals(other.runtimeClassName))
			return false;
		if (schedulerName == null) {
			if (other.schedulerName != null)
				return false;
		} else if (!schedulerName.equals(other.schedulerName))
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
		if (terminationGracePeriodSeconds != other.terminationGracePeriodSeconds)
			return false;
		if (tolerations == null) {
			if (other.tolerations != null)
				return false;
		} else if (!tolerations.equals(other.tolerations))
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
		return "spec [activeDeadlineSeconds=" + activeDeadlineSeconds + ", automountServiceAccountToken="
				+ automountServiceAccountToken + ", containers=" + containers + ", dnsConfig=" + dnsConfig
				+ ", dnsPolicy=" + dnsPolicy + ", enableServiceLinks=" + enableServiceLinks + ", hostAliases="
				+ hostAliases + ", hostIPC=" + hostIPC + ", hostNetwork=" + hostNetwork + ", hostPID=" + hostPID
				+ ", hostname=" + hostname + ", nodeName=" + nodeName + ", nodeSelector=" + nodeSelector + ", priority="
				+ priority + ", priorityClassName=" + priorityClassName + ", restartPolicy=" + restartPolicy
				+ ", runtimeClassName=" + runtimeClassName + ", schedulerName=" + schedulerName + ", securityContext="
				+ securityContext + ", serviceAccountName=" + serviceAccountName + ", subdomain=" + subdomain
				+ ", terminationGracePeriodSeconds=" + terminationGracePeriodSeconds + ", tolerations=" + tolerations
				+ ", volumes=" + volumes + "]";
	}
	
	
}

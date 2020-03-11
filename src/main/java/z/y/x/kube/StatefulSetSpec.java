package z.y.x.kube;

import java.util.List;

import z.y.x.kube.deployment.selector;
import z.y.x.kube.deployment.template;
import z.y.x.kube.persistentvolume.PersistentVolumeClaim;
import z.y.x.kube.persistentvolume.PersistentVolumeClaimSpec;

public class StatefulSetSpec {
	private String podManagementPolicy="OrderedReady";
	private int replicas=1;
	private int revisionHistoryLimit=10;
	private selector selector;
	private String serviceName;
	private template template;
	private List<PersistentVolumeClaimSpec> volumeClaimTemplates;
	public String getPodManagementPolicy() {
		return podManagementPolicy;
	}
	public void setPodManagementPolicy(String podManagementPolicy) {
		this.podManagementPolicy = podManagementPolicy;
	}
	public int getReplicas() {
		return replicas;
	}
	public void setReplicas(int replicas) {
		this.replicas = replicas;
	}
	public int getRevisionHistoryLimit() {
		return revisionHistoryLimit;
	}
	public void setRevisionHistoryLimit(int revisionHistoryLimit) {
		this.revisionHistoryLimit = revisionHistoryLimit;
	}
	public selector getSelector() {
		return selector;
	}
	public void setSelector(selector selector) {
		this.selector = selector;
	}
	public String getServiceName() {
		return serviceName;
	}
	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}
	public template getTemplate() {
		return template;
	}
	public void setTemplate(template template) {
		this.template = template;
	}
	public List<PersistentVolumeClaimSpec> getVolumeClaimTemplates() {
		return volumeClaimTemplates;
	}
	public void setVolumeClaimTemplates(List<PersistentVolumeClaimSpec> volumeClaimTemplates) {
		this.volumeClaimTemplates = volumeClaimTemplates;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((podManagementPolicy == null) ? 0 : podManagementPolicy.hashCode());
		result = prime * result + replicas;
		result = prime * result + revisionHistoryLimit;
		result = prime * result + ((selector == null) ? 0 : selector.hashCode());
		result = prime * result + ((serviceName == null) ? 0 : serviceName.hashCode());
		result = prime * result + ((template == null) ? 0 : template.hashCode());
		result = prime * result + ((volumeClaimTemplates == null) ? 0 : volumeClaimTemplates.hashCode());
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
		StatefulSetSpec other = (StatefulSetSpec) obj;
		if (podManagementPolicy == null) {
			if (other.podManagementPolicy != null)
				return false;
		} else if (!podManagementPolicy.equals(other.podManagementPolicy))
			return false;
		if (replicas != other.replicas)
			return false;
		if (revisionHistoryLimit != other.revisionHistoryLimit)
			return false;
		if (selector == null) {
			if (other.selector != null)
				return false;
		} else if (!selector.equals(other.selector))
			return false;
		if (serviceName == null) {
			if (other.serviceName != null)
				return false;
		} else if (!serviceName.equals(other.serviceName))
			return false;
		if (template == null) {
			if (other.template != null)
				return false;
		} else if (!template.equals(other.template))
			return false;
		if (volumeClaimTemplates == null) {
			if (other.volumeClaimTemplates != null)
				return false;
		} else if (!volumeClaimTemplates.equals(other.volumeClaimTemplates))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "StatefulSetSpec [podManagementPolicy=" + podManagementPolicy + ", replicas=" + replicas
				+ ", revisionHistoryLimit=" + revisionHistoryLimit + ", selector=" + selector + ", serviceName="
				+ serviceName + ", template=" + template + ", volumeClaimTemplates=" + volumeClaimTemplates + "]";
	}
	
	
	
}

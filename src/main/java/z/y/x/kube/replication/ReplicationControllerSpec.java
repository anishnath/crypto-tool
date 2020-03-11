package z.y.x.kube.replication;

import z.y.x.kube.deployment.selector;
import z.y.x.kube.deployment.template;

public class ReplicationControllerSpec {
	private int minReadySeconds;
	private int replicas;
	private selector selector;
	private template template;
	public int getMinReadySeconds() {
		return minReadySeconds;
	}
	public void setMinReadySeconds(int minReadySeconds) {
		this.minReadySeconds = minReadySeconds;
	}
	public int getReplicas() {
		return replicas;
	}
	public void setReplicas(int replicas) {
		this.replicas = replicas;
	}
	public selector getSelector() {
		return selector;
	}
	public void setSelector(selector selector) {
		this.selector = selector;
	}
	public template getTemplate() {
		return template;
	}
	public void setTemplate(template template) {
		this.template = template;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + minReadySeconds;
		result = prime * result + replicas;
		result = prime * result + ((selector == null) ? 0 : selector.hashCode());
		result = prime * result + ((template == null) ? 0 : template.hashCode());
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
		ReplicationControllerSpec other = (ReplicationControllerSpec) obj;
		if (minReadySeconds != other.minReadySeconds)
			return false;
		if (replicas != other.replicas)
			return false;
		if (selector == null) {
			if (other.selector != null)
				return false;
		} else if (!selector.equals(other.selector))
			return false;
		if (template == null) {
			if (other.template != null)
				return false;
		} else if (!template.equals(other.template))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "ReplicationControllerSpec [minReadySeconds=" + minReadySeconds + ", replicas=" + replicas
				+ ", selector=" + selector + ", template=" + template + "]";
	}
	
	

}

package z.y.x.kube.deployment;

public class spec {
	
	private int replicas=1;
	private int revisionHistoryLimit=1;
	private selector selector;
	private template template;
	
	
	
	
	public template getTemplate() {
		return template;
	}
	public void setTemplate(template template) {
		this.template = template;
	}
	public selector getSelector() {
		return selector;
	}
	public void setSelector(selector selector) {
		this.selector = selector;
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
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + replicas;
		result = prime * result + revisionHistoryLimit;
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
		spec other = (spec) obj;
		if (replicas != other.replicas)
			return false;
		if (revisionHistoryLimit != other.revisionHistoryLimit)
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
		return "spec [replicas=" + replicas + ", revisionHistoryLimit=" + revisionHistoryLimit + ", "
				+ (selector != null ? "selector=" + selector + ", " : "")
				+ (template != null ? "template=" + template : "") + "]";
	}
	
	

}

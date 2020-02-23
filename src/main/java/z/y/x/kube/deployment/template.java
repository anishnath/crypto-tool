package z.y.x.kube.deployment;

import z.y.x.kube.metadata;
import z.y.x.kube.spec;

public class template {
	
	private metadata metadata;
	private spec  spec;
	public metadata getMetadata() {
		return metadata;
	}
	public void setMetadata(metadata metadata) {
		this.metadata = metadata;
	}
	public spec getSpec() {
		return spec;
	}
	public void setSpec(spec spec) {
		this.spec = spec;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((metadata == null) ? 0 : metadata.hashCode());
		result = prime * result + ((spec == null) ? 0 : spec.hashCode());
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
		template other = (template) obj;
		if (metadata == null) {
			if (other.metadata != null)
				return false;
		} else if (!metadata.equals(other.metadata))
			return false;
		if (spec == null) {
			if (other.spec != null)
				return false;
		} else if (!spec.equals(other.spec))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "template [" + (metadata != null ? "metadata=" + metadata + ", " : "")
				+ (spec != null ? "spec=" + spec : "") + "]";
	}
	
	

}

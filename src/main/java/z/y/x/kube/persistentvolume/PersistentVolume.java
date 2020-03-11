package z.y.x.kube.persistentvolume;

import z.y.x.kube.metadata;

public class PersistentVolume {
	
	private String apiVersion = "v1";
	private String kind = "PersistentVolume";
	private metadata metadata;
	private PersistentVolumeSpec spec;
	public String getApiVersion() {
		return apiVersion;
	}
	public void setApiVersion(String apiVersion) {
		this.apiVersion = apiVersion;
	}
	public String getKind() {
		return kind;
	}
	public void setKind(String kind) {
		this.kind = kind;
	}
	public metadata getMetadata() {
		return metadata;
	}
	public void setMetadata(metadata metadata) {
		this.metadata = metadata;
	}
	public PersistentVolumeSpec getSpec() {
		return spec;
	}
	public void setSpec(PersistentVolumeSpec spec) {
		this.spec = spec;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((apiVersion == null) ? 0 : apiVersion.hashCode());
		result = prime * result + ((kind == null) ? 0 : kind.hashCode());
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
		PersistentVolume other = (PersistentVolume) obj;
		if (apiVersion == null) {
			if (other.apiVersion != null)
				return false;
		} else if (!apiVersion.equals(other.apiVersion))
			return false;
		if (kind == null) {
			if (other.kind != null)
				return false;
		} else if (!kind.equals(other.kind))
			return false;
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
		return "PersistentVolume [apiVersion=" + apiVersion + ", kind=" + kind + ", metadata=" + metadata + ", spec="
				+ spec + "]";
	}
}

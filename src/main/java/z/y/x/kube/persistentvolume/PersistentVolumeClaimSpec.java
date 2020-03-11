package z.y.x.kube.persistentvolume;

import java.util.List;

import z.y.x.kube.deployment.selector;
import z.y.x.kube.generic.resources;

public class PersistentVolumeClaimSpec {
	
	private String storageClassName;
	private String volumeName;	
	private String volumeMode;
	private selector selector;
	private resources resources;
	private List<String> accessModes;
	public String getStorageClassName() {
		return storageClassName;
	}
	public void setStorageClassName(String storageClassName) {
		this.storageClassName = storageClassName;
	}
	public String getVolumeName() {
		return volumeName;
	}
	public void setVolumeName(String volumeName) {
		this.volumeName = volumeName;
	}
	public String getVolumeMode() {
		return volumeMode;
	}
	public void setVolumeMode(String volumeMode) {
		this.volumeMode = volumeMode;
	}
	public selector getSelector() {
		return selector;
	}
	public void setSelector(selector selector) {
		this.selector = selector;
	}
	public resources getResources() {
		return resources;
	}
	public void setResources(resources resources) {
		this.resources = resources;
	}
	public List<String> getAccessModes() {
		return accessModes;
	}
	public void setAccessModes(List<String> accessModes) {
		this.accessModes = accessModes;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((accessModes == null) ? 0 : accessModes.hashCode());
		result = prime * result + ((resources == null) ? 0 : resources.hashCode());
		result = prime * result + ((selector == null) ? 0 : selector.hashCode());
		result = prime * result + ((storageClassName == null) ? 0 : storageClassName.hashCode());
		result = prime * result + ((volumeMode == null) ? 0 : volumeMode.hashCode());
		result = prime * result + ((volumeName == null) ? 0 : volumeName.hashCode());
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
		PersistentVolumeClaimSpec other = (PersistentVolumeClaimSpec) obj;
		if (accessModes == null) {
			if (other.accessModes != null)
				return false;
		} else if (!accessModes.equals(other.accessModes))
			return false;
		if (resources == null) {
			if (other.resources != null)
				return false;
		} else if (!resources.equals(other.resources))
			return false;
		if (selector == null) {
			if (other.selector != null)
				return false;
		} else if (!selector.equals(other.selector))
			return false;
		if (storageClassName == null) {
			if (other.storageClassName != null)
				return false;
		} else if (!storageClassName.equals(other.storageClassName))
			return false;
		if (volumeMode == null) {
			if (other.volumeMode != null)
				return false;
		} else if (!volumeMode.equals(other.volumeMode))
			return false;
		if (volumeName == null) {
			if (other.volumeName != null)
				return false;
		} else if (!volumeName.equals(other.volumeName))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "PersistentVolumeClaimSpec [storageClassName=" + storageClassName + ", volumeName=" + volumeName
				+ ", volumeMode=" + volumeMode + ", selector=" + selector + ", resources=" + resources
				+ ", accessModes=" + accessModes + "]";
	}
	
	
	
}

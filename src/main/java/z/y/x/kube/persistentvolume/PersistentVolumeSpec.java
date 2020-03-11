package z.y.x.kube.persistentvolume;

import java.util.List;

import z.y.x.kube.generic.ObjectReference;
import z.y.x.kube.hostPath;

public class PersistentVolumeSpec {

	
	private capacity capacity;
	private String persistentVolumeReclaimPolicy;
	private hostPath hostPath;
	private String storageClassName;
	private List<String> accessModes;
	private List<String> mountOptions;
	private String volumeMode;
	private ObjectReference claimRef;
	public capacity getCapacity() {
		return capacity;
	}
	public void setCapacity(capacity capacity) {
		this.capacity = capacity;
	}
	public String getPersistentVolumeReclaimPolicy() {
		return persistentVolumeReclaimPolicy;
	}
	public void setPersistentVolumeReclaimPolicy(String persistentVolumeReclaimPolicy) {
		this.persistentVolumeReclaimPolicy = persistentVolumeReclaimPolicy;
	}
	public hostPath getHostPath() {
		return hostPath;
	}
	public void setHostPath(hostPath hostPath) {
		this.hostPath = hostPath;
	}
	public String getStorageClassName() {
		return storageClassName;
	}
	public void setStorageClassName(String storageClassName) {
		this.storageClassName = storageClassName;
	}
	public List<String> getAccessModes() {
		return accessModes;
	}
	public void setAccessModes(List<String> accessModes) {
		this.accessModes = accessModes;
	}
	public List<String> getMountOptions() {
		return mountOptions;
	}
	public void setMountOptions(List<String> mountOptions) {
		this.mountOptions = mountOptions;
	}
	public String getVolumeMode() {
		return volumeMode;
	}
	public void setVolumeMode(String volumeMode) {
		this.volumeMode = volumeMode;
	}
	public ObjectReference getClaimRef() {
		return claimRef;
	}
	public void setClaimRef(ObjectReference claimRef) {
		this.claimRef = claimRef;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((accessModes == null) ? 0 : accessModes.hashCode());
		result = prime * result + ((capacity == null) ? 0 : capacity.hashCode());
		result = prime * result + ((claimRef == null) ? 0 : claimRef.hashCode());
		result = prime * result + ((hostPath == null) ? 0 : hostPath.hashCode());
		result = prime * result + ((mountOptions == null) ? 0 : mountOptions.hashCode());
		result = prime * result
				+ ((persistentVolumeReclaimPolicy == null) ? 0 : persistentVolumeReclaimPolicy.hashCode());
		result = prime * result + ((storageClassName == null) ? 0 : storageClassName.hashCode());
		result = prime * result + ((volumeMode == null) ? 0 : volumeMode.hashCode());
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
		PersistentVolumeSpec other = (PersistentVolumeSpec) obj;
		if (accessModes == null) {
			if (other.accessModes != null)
				return false;
		} else if (!accessModes.equals(other.accessModes))
			return false;
		if (capacity == null) {
			if (other.capacity != null)
				return false;
		} else if (!capacity.equals(other.capacity))
			return false;
		if (claimRef == null) {
			if (other.claimRef != null)
				return false;
		} else if (!claimRef.equals(other.claimRef))
			return false;
		if (hostPath == null) {
			if (other.hostPath != null)
				return false;
		} else if (!hostPath.equals(other.hostPath))
			return false;
		if (mountOptions == null) {
			if (other.mountOptions != null)
				return false;
		} else if (!mountOptions.equals(other.mountOptions))
			return false;
		if (persistentVolumeReclaimPolicy == null) {
			if (other.persistentVolumeReclaimPolicy != null)
				return false;
		} else if (!persistentVolumeReclaimPolicy.equals(other.persistentVolumeReclaimPolicy))
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
		return true;
	}
	@Override
	public String toString() {
		return "PersistentVolumeSpec [capacity=" + capacity + ", persistentVolumeReclaimPolicy="
				+ persistentVolumeReclaimPolicy + ", hostPath=" + hostPath + ", storageClassName=" + storageClassName
				+ ", accessModes=" + accessModes + ", mountOptions=" + mountOptions + ", volumeMode=" + volumeMode
				+ ", claimRef=" + claimRef + "]";
	}
	
	
}

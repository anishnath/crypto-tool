package z.y.x.kube;

import z.y.x.kube.persistentvolume.EmptyDirVolumeSource;
import z.y.x.kube.persistentvolume.PersistentVolumeClaimVolumeSource;

public class volumes {
	
	private String name;
	private hostPath hostPath;
	private PersistentVolumeClaimVolumeSource persistentVolumeClaim;
	private EmptyDirVolumeSource emptyDir;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public hostPath getHostPath() {
		return hostPath;
	}
	public void setHostPath(hostPath hostPath) {
		this.hostPath = hostPath;
	}
	public PersistentVolumeClaimVolumeSource getPersistentVolumeClaim() {
		return persistentVolumeClaim;
	}
	public void setPersistentVolumeClaim(PersistentVolumeClaimVolumeSource persistentVolumeClaim) {
		this.persistentVolumeClaim = persistentVolumeClaim;
	}
	public EmptyDirVolumeSource getEmptyDir() {
		return emptyDir;
	}
	public void setEmptyDir(EmptyDirVolumeSource emptyDir) {
		this.emptyDir = emptyDir;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((emptyDir == null) ? 0 : emptyDir.hashCode());
		result = prime * result + ((hostPath == null) ? 0 : hostPath.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((persistentVolumeClaim == null) ? 0 : persistentVolumeClaim.hashCode());
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
		volumes other = (volumes) obj;
		if (emptyDir == null) {
			if (other.emptyDir != null)
				return false;
		} else if (!emptyDir.equals(other.emptyDir))
			return false;
		if (hostPath == null) {
			if (other.hostPath != null)
				return false;
		} else if (!hostPath.equals(other.hostPath))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (persistentVolumeClaim == null) {
			if (other.persistentVolumeClaim != null)
				return false;
		} else if (!persistentVolumeClaim.equals(other.persistentVolumeClaim))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "volumes [name=" + name + ", hostPath=" + hostPath + ", persistentVolumeClaim=" + persistentVolumeClaim
				+ ", emptyDir=" + emptyDir + "]";
	}
	
	

}

package z.y.x.kube.persistentvolume;

public class PersistentVolumeClaimVolumeSource {
	
	private String claimName;
	boolean readOnly;
	public String getClaimName() {
		return claimName;
	}
	public void setClaimName(String claimName) {
		this.claimName = claimName;
	}
	public boolean isReadOnly() {
		return readOnly;
	}
	public void setReadOnly(boolean readOnly) {
		this.readOnly = readOnly;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((claimName == null) ? 0 : claimName.hashCode());
		result = prime * result + (readOnly ? 1231 : 1237);
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
		PersistentVolumeClaimVolumeSource other = (PersistentVolumeClaimVolumeSource) obj;
		if (claimName == null) {
			if (other.claimName != null)
				return false;
		} else if (!claimName.equals(other.claimName))
			return false;
		if (readOnly != other.readOnly)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "PersistentVolumeClaimVolumeSource [claimName=" + claimName + ", readOnly=" + readOnly + "]";
	}
	
	

}

package z.y.x.kube.persistentvolume;

public class EmptyDirVolumeSource {
	private String medium;

	public String getMedium() {
		return medium;
	}

	public void setMedium(String medium) {
		this.medium = medium;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((medium == null) ? 0 : medium.hashCode());
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
		EmptyDirVolumeSource other = (EmptyDirVolumeSource) obj;
		if (medium == null) {
			if (other.medium != null)
				return false;
		} else if (!medium.equals(other.medium))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "EmptyDirVolumeSource [medium=" + medium + "]";
	}
	

}

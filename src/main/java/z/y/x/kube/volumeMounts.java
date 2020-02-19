package z.y.x.kube;

public class volumeMounts {
	
	private String mountPath;
	private String name;
	private boolean readOnly=false;
	
	
	public boolean isReadOnly() {
		return readOnly;
	}
	public void setReadOnly(boolean readOnly) {
		this.readOnly = readOnly;
	}
	public String getMountPath() {
		return mountPath;
	}
	public void setMountPath(String mountPath) {
		this.mountPath = mountPath;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((mountPath == null) ? 0 : mountPath.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
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
		volumeMounts other = (volumeMounts) obj;
		if (mountPath == null) {
			if (other.mountPath != null)
				return false;
		} else if (!mountPath.equals(other.mountPath))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (readOnly != other.readOnly)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "volumeMounts [" + (mountPath != null ? "mountPath=" + mountPath + ", " : "")
				+ (name != null ? "name=" + name + ", " : "") + "readOnly=" + readOnly + "]";
	}

	
	
}

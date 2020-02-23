package z.y.x.kube.deployment;

public class strategy {
	
	private String type="RollingUpdate";
	private rollingUpdate rollingUpdate;
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public rollingUpdate getRollingUpdate() {
		return rollingUpdate;
	}
	public void setRollingUpdate(rollingUpdate rollingUpdate) {
		this.rollingUpdate = rollingUpdate;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((rollingUpdate == null) ? 0 : rollingUpdate.hashCode());
		result = prime * result + ((type == null) ? 0 : type.hashCode());
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
		strategy other = (strategy) obj;
		if (rollingUpdate == null) {
			if (other.rollingUpdate != null)
				return false;
		} else if (!rollingUpdate.equals(other.rollingUpdate))
			return false;
		if (type == null) {
			if (other.type != null)
				return false;
		} else if (!type.equals(other.type))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "strategy [" + (type != null ? "type=" + type + ", " : "")
				+ (rollingUpdate != null ? "rollingUpdate=" + rollingUpdate : "") + "]";
	}
	
	
	

}

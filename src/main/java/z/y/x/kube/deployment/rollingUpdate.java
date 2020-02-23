package z.y.x.kube.deployment;

public class rollingUpdate {
	
	private String maxSurge="25%";
	private String maxUnavailable = "25%";
	public String getMaxSurge() {
		return maxSurge;
	}
	public void setMaxSurge(String maxSurge) {
		this.maxSurge = maxSurge;
	}
	public String getMaxUnavailable() {
		return maxUnavailable;
	}
	public void setMaxUnavailable(String maxUnavailable) {
		this.maxUnavailable = maxUnavailable;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((maxSurge == null) ? 0 : maxSurge.hashCode());
		result = prime * result + ((maxUnavailable == null) ? 0 : maxUnavailable.hashCode());
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
		rollingUpdate other = (rollingUpdate) obj;
		if (maxSurge == null) {
			if (other.maxSurge != null)
				return false;
		} else if (!maxSurge.equals(other.maxSurge))
			return false;
		if (maxUnavailable == null) {
			if (other.maxUnavailable != null)
				return false;
		} else if (!maxUnavailable.equals(other.maxUnavailable))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "rollingUpdate [" + (maxSurge != null ? "maxSurge=" + maxSurge + ", " : "")
				+ (maxUnavailable != null ? "maxUnavailable=" + maxUnavailable : "") + "]";
	}
	
	

}

package z.y.x.kube;

public class securityContext {
	
	private int fsGroup;
	private int runAsGroup;
	private boolean runAsNonRoot;
	private int runAsUser;
	public int getFsGroup() {
		return fsGroup;
	}
	public void setFsGroup(int fsGroup) {
		this.fsGroup = fsGroup;
	}
	public int getRunAsGroup() {
		return runAsGroup;
	}
	public void setRunAsGroup(int runAsGroup) {
		this.runAsGroup = runAsGroup;
	}
	public boolean isRunAsNonRoot() {
		return runAsNonRoot;
	}
	public void setRunAsNonRoot(boolean runAsNonRoot) {
		this.runAsNonRoot = runAsNonRoot;
	}
	public int getRunAsUser() {
		return runAsUser;
	}
	public void setRunAsUser(int runAsUser) {
		this.runAsUser = runAsUser;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + fsGroup;
		result = prime * result + runAsGroup;
		result = prime * result + (runAsNonRoot ? 1231 : 1237);
		result = prime * result + runAsUser;
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
		securityContext other = (securityContext) obj;
		if (fsGroup != other.fsGroup)
			return false;
		if (runAsGroup != other.runAsGroup)
			return false;
		if (runAsNonRoot != other.runAsNonRoot)
			return false;
		if (runAsUser != other.runAsUser)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "securityContext [fsGroup=" + fsGroup + ", runAsGroup=" + runAsGroup + ", runAsNonRoot=" + runAsNonRoot
				+ ", runAsUser=" + runAsUser + "]";
	}
	
	

}

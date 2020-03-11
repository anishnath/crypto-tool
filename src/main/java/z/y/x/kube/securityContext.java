package z.y.x.kube;

import java.util.List;

public class securityContext {
	
	private int fsGroup;
	private boolean allowPrivilegeEscalation;
	private capabilities capabilities;
	private boolean privileged;
	private boolean readOnlyRootFilesystem;
	
	private int runAsGroup;
	private boolean runAsNonRoot;
	private int runAsUser;
		
	private SELinuxOptions seLinuxOptions;
	private List<String> sysctls;
	public int getFsGroup() {
		return fsGroup;
	}
	public void setFsGroup(int fsGroup) {
		this.fsGroup = fsGroup;
	}
	public boolean isAllowPrivilegeEscalation() {
		return allowPrivilegeEscalation;
	}
	public void setAllowPrivilegeEscalation(boolean allowPrivilegeEscalation) {
		this.allowPrivilegeEscalation = allowPrivilegeEscalation;
	}
	public capabilities getCapabilities() {
		return capabilities;
	}
	public void setCapabilities(capabilities capabilities) {
		this.capabilities = capabilities;
	}
	public boolean isPrivileged() {
		return privileged;
	}
	public void setPrivileged(boolean privileged) {
		this.privileged = privileged;
	}
	public boolean isReadOnlyRootFilesystem() {
		return readOnlyRootFilesystem;
	}
	public void setReadOnlyRootFilesystem(boolean readOnlyRootFilesystem) {
		this.readOnlyRootFilesystem = readOnlyRootFilesystem;
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
	public SELinuxOptions getSeLinuxOptions() {
		return seLinuxOptions;
	}
	public void setSeLinuxOptions(SELinuxOptions seLinuxOptions) {
		this.seLinuxOptions = seLinuxOptions;
	}
	public List<String> getSysctls() {
		return sysctls;
	}
	public void setSysctls(List<String> sysctls) {
		this.sysctls = sysctls;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (allowPrivilegeEscalation ? 1231 : 1237);
		result = prime * result + ((capabilities == null) ? 0 : capabilities.hashCode());
		result = prime * result + fsGroup;
		result = prime * result + (privileged ? 1231 : 1237);
		result = prime * result + (readOnlyRootFilesystem ? 1231 : 1237);
		result = prime * result + runAsGroup;
		result = prime * result + (runAsNonRoot ? 1231 : 1237);
		result = prime * result + runAsUser;
		result = prime * result + ((seLinuxOptions == null) ? 0 : seLinuxOptions.hashCode());
		result = prime * result + ((sysctls == null) ? 0 : sysctls.hashCode());
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
		if (allowPrivilegeEscalation != other.allowPrivilegeEscalation)
			return false;
		if (capabilities == null) {
			if (other.capabilities != null)
				return false;
		} else if (!capabilities.equals(other.capabilities))
			return false;
		if (fsGroup != other.fsGroup)
			return false;
		if (privileged != other.privileged)
			return false;
		if (readOnlyRootFilesystem != other.readOnlyRootFilesystem)
			return false;
		if (runAsGroup != other.runAsGroup)
			return false;
		if (runAsNonRoot != other.runAsNonRoot)
			return false;
		if (runAsUser != other.runAsUser)
			return false;
		if (seLinuxOptions == null) {
			if (other.seLinuxOptions != null)
				return false;
		} else if (!seLinuxOptions.equals(other.seLinuxOptions))
			return false;
		if (sysctls == null) {
			if (other.sysctls != null)
				return false;
		} else if (!sysctls.equals(other.sysctls))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "securityContext [fsGroup=" + fsGroup + ", allowPrivilegeEscalation=" + allowPrivilegeEscalation
				+ ", capabilities=" + capabilities + ", privileged=" + privileged + ", readOnlyRootFilesystem="
				+ readOnlyRootFilesystem + ", runAsGroup=" + runAsGroup + ", runAsNonRoot=" + runAsNonRoot
				+ ", runAsUser=" + runAsUser + ", seLinuxOptions=" + seLinuxOptions + ", sysctls=" + sysctls + "]";
	}

}

package z.y.x.kube.env1;

public class EnvFromSource {
	private ConfigMapEnvSource configMapRef; 
	private String prefix;
	public ConfigMapEnvSource getConfigMapRef() {
		return configMapRef;
	}
	public void setConfigMapRef(ConfigMapEnvSource configMapRef) {
		this.configMapRef = configMapRef;
	}
	public String getPrefix() {
		return prefix;
	}
	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((configMapRef == null) ? 0 : configMapRef.hashCode());
		result = prime * result + ((prefix == null) ? 0 : prefix.hashCode());
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
		EnvFromSource other = (EnvFromSource) obj;
		if (configMapRef == null) {
			if (other.configMapRef != null)
				return false;
		} else if (!configMapRef.equals(other.configMapRef))
			return false;
		if (prefix == null) {
			if (other.prefix != null)
				return false;
		} else if (!prefix.equals(other.prefix))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "EnvFromSource [configMapRef=" + configMapRef + ", prefix=" + prefix + "]";
	}

	
}

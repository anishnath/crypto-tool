package z.y.x.kube.env1;

public class SecretEnvSource {
	private String name;
	private boolean optional;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isOptional() {
		return optional;
	}
	public void setOptional(boolean optional) {
		this.optional = optional;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + (optional ? 1231 : 1237);
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
		SecretEnvSource other = (SecretEnvSource) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (optional != other.optional)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "SecretEnvSource [name=" + name + ", optional=" + optional + "]";
	}
	
	

}

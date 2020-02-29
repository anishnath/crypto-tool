package z.y.x.docker;

public class config {
	
	private String subnet;

	public String getSubnet() {
		return subnet;
	}

	public void setSubnet(String subnet) {
		this.subnet = subnet;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((subnet == null) ? 0 : subnet.hashCode());
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
		config other = (config) obj;
		if (subnet == null) {
			if (other.subnet != null)
				return false;
		} else if (!subnet.equals(other.subnet))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "config [" + (subnet != null ? "subnet=" + subnet : "") + "]";
	}
	
	

}

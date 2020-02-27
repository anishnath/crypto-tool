package z.y.x.docker;

class reservations {
	private String cpus;
	private String memory;
	public String getCpus() {
		return cpus;
	}
	public void setCpus(String cpus) {
		this.cpus = cpus;
	}
	public String getMemory() {
		return memory;
	}
	public void setMemory(String memory) {
		this.memory = memory;
	}
	@Override
	public String toString() {
		return "reservations [" + (cpus != null ? "cpus=" + cpus + ", " : "")
				+ (memory != null ? "memory=" + memory : "") + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((cpus == null) ? 0 : cpus.hashCode());
		result = prime * result + ((memory == null) ? 0 : memory.hashCode());
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
		reservations other = (reservations) obj;
		if (cpus == null) {
			if (other.cpus != null)
				return false;
		} else if (!cpus.equals(other.cpus))
			return false;
		if (memory == null) {
			if (other.memory != null)
				return false;
		} else if (!memory.equals(other.memory))
			return false;
		return true;
	}
	
	

}

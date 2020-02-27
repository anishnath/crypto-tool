package z.y.x.docker;

public class preferences {
	
	private String spread;

	public String getSpread() {
		return spread;
	}

	public void setSpread(String spread) {
		this.spread = spread;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((spread == null) ? 0 : spread.hashCode());
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
		preferences other = (preferences) obj;
		if (spread == null) {
			if (other.spread != null)
				return false;
		} else if (!spread.equals(other.spread))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "preferences [" + (spread != null ? "spread=" + spread : "") + "]";
	}
	
	
}

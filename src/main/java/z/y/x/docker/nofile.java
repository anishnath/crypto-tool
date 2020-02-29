package z.y.x.docker;

public class nofile {
	
	private int soft;
	private int hard;
	public int getSoft() {
		return soft;
	}
	public void setSoft(int soft) {
		this.soft = soft;
	}
	public int getHard() {
		return hard;
	}
	public void setHard(int hard) {
		this.hard = hard;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + hard;
		result = prime * result + soft;
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
		nofile other = (nofile) obj;
		if (hard != other.hard)
			return false;
		if (soft != other.soft)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "nofile [soft=" + soft + ", hard=" + hard + "]";
	}
	
	

}

package z.y.x.docker;

public class resources {
	
	private limits limits;
	private reservations reservations;
	public limits getLimits() {
		return limits;
	}
	public void setLimits(limits limits) {
		this.limits = limits;
	}
	public reservations getReservations() {
		return reservations;
	}
	public void setReservations(reservations reservations) {
		this.reservations = reservations;
	}
	@Override
	public String toString() {
		return "resources [" + (limits != null ? "limits=" + limits + ", " : "")
				+ (reservations != null ? "reservations=" + reservations : "") + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((limits == null) ? 0 : limits.hashCode());
		result = prime * result + ((reservations == null) ? 0 : reservations.hashCode());
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
		resources other = (resources) obj;
		if (limits == null) {
			if (other.limits != null)
				return false;
		} else if (!limits.equals(other.limits))
			return false;
		if (reservations == null) {
			if (other.reservations != null)
				return false;
		} else if (!reservations.equals(other.reservations))
			return false;
		return true;
	}
}

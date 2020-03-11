package z.y.x.kube.generic;

import java.util.Map;

public class resources {
	private requests requests;
	private limits limits;
	public requests getRequests() {
		return requests;
	}
	public void setRequests(requests requests) {
		this.requests = requests;
	}
	public limits getLimits() {
		return limits;
	}
	public void setLimits(limits limits) {
		this.limits = limits;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((limits == null) ? 0 : limits.hashCode());
		result = prime * result + ((requests == null) ? 0 : requests.hashCode());
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
		if (requests == null) {
			if (other.requests != null)
				return false;
		} else if (!requests.equals(other.requests))
			return false;
		return true;
	}
	
	
	
}

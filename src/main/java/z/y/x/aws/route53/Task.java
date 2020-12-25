package z.y.x.aws.route53;

public class Task {
	public String name;
	private Route53 route53;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Route53 getRoute53() {
		return route53;
	}
	public void setRoute53(Route53 route53) {
		this.route53 = route53;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((route53 == null) ? 0 : route53.hashCode());
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
		Task other = (Task) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (route53 == null) {
			if (other.route53 != null)
				return false;
		} else if (!route53.equals(other.route53))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Task [name=" + name + ", route53=" + route53 + "]";
	}
	

}

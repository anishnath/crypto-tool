package z.y.x.aws.iam.group;

/**
 * 
 * @author anishnath
 *
 */
public class Task {
	
	private String name;
	private IamGroup iam_group;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public IamGroup getIam_group() {
		return iam_group;
	}
	public void setIam_group(IamGroup iam_group) {
		this.iam_group = iam_group;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((iam_group == null) ? 0 : iam_group.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
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
		if (iam_group == null) {
			if (other.iam_group != null)
				return false;
		} else if (!iam_group.equals(other.iam_group))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Task [name=" + name + ", iam_group=" + iam_group + "]";
	}
	
	

}

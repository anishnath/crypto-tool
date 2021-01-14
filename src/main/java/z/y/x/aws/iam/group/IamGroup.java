package z.y.x.aws.iam.group;

import java.util.List;

/**
 * 
 * @author anishnath
 *
 */
public class IamGroup {
	
	private String name;
	private List<String> managed_policy = null;
	private List<String> users = null;
	private String state = "present";
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<String> getManaged_policy() {
		return managed_policy;
	}
	public void setManaged_policy(List<String> managed_policy) {
		this.managed_policy = managed_policy;
	}
	public List<String> getUsers() {
		return users;
	}
	public void setUsers(List<String> users) {
		this.users = users;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((managed_policy == null) ? 0 : managed_policy.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((state == null) ? 0 : state.hashCode());
		result = prime * result + ((users == null) ? 0 : users.hashCode());
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
		IamGroup other = (IamGroup) obj;
		if (managed_policy == null) {
			if (other.managed_policy != null)
				return false;
		} else if (!managed_policy.equals(other.managed_policy))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (state == null) {
			if (other.state != null)
				return false;
		} else if (!state.equals(other.state))
			return false;
		if (users == null) {
			if (other.users != null)
				return false;
		} else if (!users.equals(other.users))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "IamGroup [name=" + name + ", managed_policy=" + managed_policy + ", users=" + users + ", state=" + state
				+ "]";
	}
	
	
	

}

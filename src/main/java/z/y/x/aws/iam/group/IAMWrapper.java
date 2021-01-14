package z.y.x.aws.iam.group;

import java.util.List;

/**
 * 
 * @author anishnath
 *
 */

public class IAMWrapper {
	private String hosts="localhost";
	private String connection="local";
	private Boolean gather_facts=false;
	private List<Task> tasks = null;
	public String getHosts() {
		return hosts;
	}
	public void setHosts(String hosts) {
		this.hosts = hosts;
	}
	public String getConnection() {
		return connection;
	}
	public void setConnection(String connection) {
		this.connection = connection;
	}
	public Boolean getGather_facts() {
		return gather_facts;
	}
	public void setGather_facts(Boolean gather_facts) {
		this.gather_facts = gather_facts;
	}
	public List<Task> getTasks() {
		return tasks;
	}
	public void setTasks(List<Task> tasks) {
		this.tasks = tasks;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((connection == null) ? 0 : connection.hashCode());
		result = prime * result + ((gather_facts == null) ? 0 : gather_facts.hashCode());
		result = prime * result + ((hosts == null) ? 0 : hosts.hashCode());
		result = prime * result + ((tasks == null) ? 0 : tasks.hashCode());
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
		IAMWrapper other = (IAMWrapper) obj;
		if (connection == null) {
			if (other.connection != null)
				return false;
		} else if (!connection.equals(other.connection))
			return false;
		if (gather_facts == null) {
			if (other.gather_facts != null)
				return false;
		} else if (!gather_facts.equals(other.gather_facts))
			return false;
		if (hosts == null) {
			if (other.hosts != null)
				return false;
		} else if (!hosts.equals(other.hosts))
			return false;
		if (tasks == null) {
			if (other.tasks != null)
				return false;
		} else if (!tasks.equals(other.tasks))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "IAMWrapper [hosts=" + hosts + ", connection=" + connection + ", gather_facts=" + gather_facts
				+ ", tasks=" + tasks + "]";
	}
	
	

}

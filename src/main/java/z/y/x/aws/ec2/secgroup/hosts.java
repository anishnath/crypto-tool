package z.y.x.aws.ec2.secgroup;

public class hosts {
	public String connection="local";
	public Boolean gather_facts=false;
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
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((connection == null) ? 0 : connection.hashCode());
		result = prime * result + ((gather_facts == null) ? 0 : gather_facts.hashCode());
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
		hosts other = (hosts) obj;
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
		return true;
	}
	@Override
	public String toString() {
		return "hosts [connection=" + connection + ", gather_facts=" + gather_facts + "]";
	}
	
	
	

}

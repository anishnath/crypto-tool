package z.y.x.aws.route53;

/**
 * 
 * @author anishnath
 *
 */
public class Route53 {

	private String command="create";
	private String zone;
	private String record;
	private String type;
	private Long ttl;
	private String value;
	private String wait="no";
	public String getCommand() {
		return command;
	}
	public void setCommand(String command) {
		this.command = command;
	}
	public String getZone() {
		return zone;
	}
	public void setZone(String zone) {
		this.zone = zone;
	}
	public String getRecord() {
		return record;
	}
	public void setRecord(String record) {
		this.record = record;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Long getTtl() {
		return ttl;
	}
	public void setTtl(Long ttl) {
		this.ttl = ttl;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((command == null) ? 0 : command.hashCode());
		result = prime * result + ((record == null) ? 0 : record.hashCode());
		result = prime * result + ((ttl == null) ? 0 : ttl.hashCode());
		result = prime * result + ((type == null) ? 0 : type.hashCode());
		result = prime * result + ((value == null) ? 0 : value.hashCode());
		result = prime * result + ((zone == null) ? 0 : zone.hashCode());
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
		Route53 other = (Route53) obj;
		if (command == null) {
			if (other.command != null)
				return false;
		} else if (!command.equals(other.command))
			return false;
		if (record == null) {
			if (other.record != null)
				return false;
		} else if (!record.equals(other.record))
			return false;
		if (ttl == null) {
			if (other.ttl != null)
				return false;
		} else if (!ttl.equals(other.ttl))
			return false;
		if (type == null) {
			if (other.type != null)
				return false;
		} else if (!type.equals(other.type))
			return false;
		if (value == null) {
			if (other.value != null)
				return false;
		} else if (!value.equals(other.value))
			return false;
		if (zone == null) {
			if (other.zone != null)
				return false;
		} else if (!zone.equals(other.zone))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Route53 [command=" + command + ", zone=" + zone + ", record=" + record + ", type=" + type + ", ttl="
				+ ttl + ", value=" + value + "]";
	}
	
}

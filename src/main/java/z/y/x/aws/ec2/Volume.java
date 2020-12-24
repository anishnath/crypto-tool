package z.y.x.aws.ec2;

public class Volume {
	
	private String device_name;
	private String snapshot;
	private String volume_type;
	private Integer iops;
	private Integer volume_size;
	private Boolean delete_on_termination=false;
	private Boolean encrypted;
	private String ephemeral;
	public String getDevice_name() {
		return device_name;
	}
	public void setDevice_name(String device_name) {
		this.device_name = device_name;
	}
	public String getSnapshot() {
		return snapshot;
	}
	public void setSnapshot(String snapshot) {
		this.snapshot = snapshot;
	}
	public String getVolume_type() {
		return volume_type;
	}
	public void setVolume_type(String volume_type) {
		this.volume_type = volume_type;
	}
	public Integer getIops() {
		return iops;
	}
	public void setIops(Integer iops) {
		this.iops = iops;
	}
	public Integer getVolume_size() {
		return volume_size;
	}
	public void setVolume_size(Integer volume_size) {
		this.volume_size = volume_size;
	}
	public Boolean getDelete_on_termination() {
		return delete_on_termination;
	}
	public void setDelete_on_termination(Boolean delete_on_termination) {
		this.delete_on_termination = delete_on_termination;
	}
	public Boolean getEncrypted() {
		return encrypted;
	}
	public void setEncrypted(Boolean encrypted) {
		this.encrypted = encrypted;
	}
	public String getEphemeral() {
		return ephemeral;
	}
	public void setEphemeral(String ephemeral) {
		this.ephemeral = ephemeral;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((delete_on_termination == null) ? 0 : delete_on_termination.hashCode());
		result = prime * result + ((device_name == null) ? 0 : device_name.hashCode());
		result = prime * result + ((encrypted == null) ? 0 : encrypted.hashCode());
		result = prime * result + ((ephemeral == null) ? 0 : ephemeral.hashCode());
		result = prime * result + ((iops == null) ? 0 : iops.hashCode());
		result = prime * result + ((snapshot == null) ? 0 : snapshot.hashCode());
		result = prime * result + ((volume_size == null) ? 0 : volume_size.hashCode());
		result = prime * result + ((volume_type == null) ? 0 : volume_type.hashCode());
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
		Volume other = (Volume) obj;
		if (delete_on_termination == null) {
			if (other.delete_on_termination != null)
				return false;
		} else if (!delete_on_termination.equals(other.delete_on_termination))
			return false;
		if (device_name == null) {
			if (other.device_name != null)
				return false;
		} else if (!device_name.equals(other.device_name))
			return false;
		if (encrypted == null) {
			if (other.encrypted != null)
				return false;
		} else if (!encrypted.equals(other.encrypted))
			return false;
		if (ephemeral == null) {
			if (other.ephemeral != null)
				return false;
		} else if (!ephemeral.equals(other.ephemeral))
			return false;
		if (iops == null) {
			if (other.iops != null)
				return false;
		} else if (!iops.equals(other.iops))
			return false;
		if (snapshot == null) {
			if (other.snapshot != null)
				return false;
		} else if (!snapshot.equals(other.snapshot))
			return false;
		if (volume_size == null) {
			if (other.volume_size != null)
				return false;
		} else if (!volume_size.equals(other.volume_size))
			return false;
		if (volume_type == null) {
			if (other.volume_type != null)
				return false;
		} else if (!volume_type.equals(other.volume_type))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "Volume [device_name=" + device_name + ", snapshot=" + snapshot + ", volume_type=" + volume_type
				+ ", iops=" + iops + ", volume_size=" + volume_size + ", delete_on_termination=" + delete_on_termination
				+ ", encrypted=" + encrypted + ", ephemeral=" + ephemeral + "]";
	}
	
}

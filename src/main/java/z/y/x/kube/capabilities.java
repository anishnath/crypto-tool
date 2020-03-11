package z.y.x.kube;

import java.util.List;

public class capabilities {

	private List<String> add;
	private List<String> drop;
	public List<String> getAdd() {
		return add;
	}
	public void setAdd(List<String> add) {
		this.add = add;
	}
	public List<String> getDrop() {
		return drop;
	}
	public void setDrop(List<String> drop) {
		this.drop = drop;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((add == null) ? 0 : add.hashCode());
		result = prime * result + ((drop == null) ? 0 : drop.hashCode());
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
		capabilities other = (capabilities) obj;
		if (add == null) {
			if (other.add != null)
				return false;
		} else if (!add.equals(other.add))
			return false;
		if (drop == null) {
			if (other.drop != null)
				return false;
		} else if (!drop.equals(other.drop))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "capabilities [add=" + add + ", drop=" + drop + "]";
	}
}

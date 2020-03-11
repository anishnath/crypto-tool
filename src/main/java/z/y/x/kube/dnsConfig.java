package z.y.x.kube;
import java.util.Arrays;
import java.util.List;

public class dnsConfig {
	
	private String nameservers[] ;
	private String searches[];
	private List<options> options;
	public String[] getNameservers() {
		return nameservers;
	}
	public void setNameservers(String[] nameservers) {
		this.nameservers = nameservers;
	}
	public String[] getSearches() {
		return searches;
	}
	public void setSearches(String[] searches) {
		this.searches = searches;
	}
	public List<options> getOptions() {
		return options;
	}
	public void setOptions(List<options> options) {
		this.options = options;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(nameservers);
		result = prime * result + ((options == null) ? 0 : options.hashCode());
		result = prime * result + Arrays.hashCode(searches);
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
		dnsConfig other = (dnsConfig) obj;
		if (!Arrays.equals(nameservers, other.nameservers))
			return false;
		if (options == null) {
			if (other.options != null)
				return false;
		} else if (!options.equals(other.options))
			return false;
		if (!Arrays.equals(searches, other.searches))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "dnsConfig [" + (nameservers != null ? "nameservers=" + Arrays.toString(nameservers) + ", " : "")
				+ (searches != null ? "searches=" + Arrays.toString(searches) + ", " : "")
				+ (options != null ? "options=" + options : "") + "]";
	}
	
	

}


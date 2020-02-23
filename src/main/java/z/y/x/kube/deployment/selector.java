package z.y.x.kube.deployment;

import java.util.Map;

public class selector {
	
	private Map<String, String> matchLabels;

	public Map<String, String> getMatchLabels() {
		return matchLabels;
	}

	public void setMatchLabels(Map<String, String> matchLabels) {
		this.matchLabels = matchLabels;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((matchLabels == null) ? 0 : matchLabels.hashCode());
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
		selector other = (selector) obj;
		if (matchLabels == null) {
			if (other.matchLabels != null)
				return false;
		} else if (!matchLabels.equals(other.matchLabels))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "selector [" + (matchLabels != null ? "matchLabels=" + matchLabels : "") + "]";
	}
	
	

}

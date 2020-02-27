package z.y.x.docker;

import java.util.Arrays;
import java.util.List;

public class placement {
	
	private String constraints[];
	private List<preferences> preferences;
	public String[] getConstraints() {
		return constraints;
	}
	public void setConstraints(String[] constraints) {
		this.constraints = constraints;
	}
	public List<preferences> getPreferences() {
		return preferences;
	}
	public void setPreferences(List<preferences> preferences) {
		this.preferences = preferences;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(constraints);
		result = prime * result + ((preferences == null) ? 0 : preferences.hashCode());
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
		placement other = (placement) obj;
		if (!Arrays.equals(constraints, other.constraints))
			return false;
		if (preferences == null) {
			if (other.preferences != null)
				return false;
		} else if (!preferences.equals(other.preferences))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "placement [" + (constraints != null ? "constraints=" + Arrays.toString(constraints) + ", " : "")
				+ (preferences != null ? "preferences=" + preferences : "") + "]";
	}
	
	

}

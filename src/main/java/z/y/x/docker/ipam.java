package z.y.x.docker;

import java.util.Arrays;
import java.util.List;

public class ipam {
	
	private String driver="default";
	private config[] config;
	public String getDriver() {
		return driver;
	}
	public void setDriver(String driver) {
		this.driver = driver;
	}
	public config[] getConfig() {
		return config;
	}
	public void setConfig(config[] config) {
		this.config = config;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(config);
		result = prime * result + ((driver == null) ? 0 : driver.hashCode());
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
		ipam other = (ipam) obj;
		if (!Arrays.equals(config, other.config))
			return false;
		if (driver == null) {
			if (other.driver != null)
				return false;
		} else if (!driver.equals(other.driver))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "ipam [" + (driver != null ? "driver=" + driver + ", " : "")
				+ (config != null ? "config=" + Arrays.toString(config) : "") + "]";
	}
	
	
	

}

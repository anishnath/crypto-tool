package z.y.x.docker;

import java.util.Arrays;

public class healthcheck {
	
	private String[] test;
	private String interval="1m30s";
	private String timeout="10s";
	private int retries=3;
	public String[] getTest() {
		return test;
	}
	public void setTest(String[] test) {
		this.test = test;
	}
	public String getInterval() {
		return interval;
	}
	public void setInterval(String interval) {
		this.interval = interval;
	}
	public String getTimeout() {
		return timeout;
	}
	public void setTimeout(String timeout) {
		this.timeout = timeout;
	}
	public int getRetries() {
		return retries;
	}
	public void setRetries(int retries) {
		this.retries = retries;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((interval == null) ? 0 : interval.hashCode());
		result = prime * result + retries;
		result = prime * result + Arrays.hashCode(test);
		result = prime * result + ((timeout == null) ? 0 : timeout.hashCode());
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
		healthcheck other = (healthcheck) obj;
		if (interval == null) {
			if (other.interval != null)
				return false;
		} else if (!interval.equals(other.interval))
			return false;
		if (retries != other.retries)
			return false;
		if (!Arrays.equals(test, other.test))
			return false;
		if (timeout == null) {
			if (other.timeout != null)
				return false;
		} else if (!timeout.equals(other.timeout))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "healthcheck [" + (test != null ? "test=" + Arrays.toString(test) + ", " : "")
				+ (interval != null ? "interval=" + interval + ", " : "")
				+ (timeout != null ? "timeout=" + timeout + ", " : "") + "retries=" + retries + "]";
	}

	

}

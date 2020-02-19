package z.y.x.kube;

public class livenessProbe {
	
	private int failureThreshold=3;
	private int initialDelaySeconds=10;
	private int periodSeconds=10;
	private int successThreshold=1;
	private int timeoutSeconds=1;
	
	private httpGet httpGet;

	public int getFailureThreshold() {
		return failureThreshold;
	}

	public void setFailureThreshold(int failureThreshold) {
		this.failureThreshold = failureThreshold;
	}

	public int getInitialDelaySeconds() {
		return initialDelaySeconds;
	}

	public void setInitialDelaySeconds(int initialDelaySeconds) {
		this.initialDelaySeconds = initialDelaySeconds;
	}

	public int getPeriodSeconds() {
		return periodSeconds;
	}

	public void setPeriodSeconds(int periodSeconds) {
		this.periodSeconds = periodSeconds;
	}

	public int getSuccessThreshold() {
		return successThreshold;
	}

	public void setSuccessThreshold(int successThreshold) {
		this.successThreshold = successThreshold;
	}

	public int getTimeoutSeconds() {
		return timeoutSeconds;
	}

	public void setTimeoutSeconds(int timeoutSeconds) {
		this.timeoutSeconds = timeoutSeconds;
	}

	public httpGet getHttpGet() {
		return httpGet;
	}

	public void setHttpGet(httpGet httpGet) {
		this.httpGet = httpGet;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + failureThreshold;
		result = prime * result + ((httpGet == null) ? 0 : httpGet.hashCode());
		result = prime * result + initialDelaySeconds;
		result = prime * result + periodSeconds;
		result = prime * result + successThreshold;
		result = prime * result + timeoutSeconds;
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
		livenessProbe other = (livenessProbe) obj;
		if (failureThreshold != other.failureThreshold)
			return false;
		if (httpGet == null) {
			if (other.httpGet != null)
				return false;
		} else if (!httpGet.equals(other.httpGet))
			return false;
		if (initialDelaySeconds != other.initialDelaySeconds)
			return false;
		if (periodSeconds != other.periodSeconds)
			return false;
		if (successThreshold != other.successThreshold)
			return false;
		if (timeoutSeconds != other.timeoutSeconds)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "livenessProbe [failureThreshold=" + failureThreshold + ", initialDelaySeconds=" + initialDelaySeconds
				+ ", periodSeconds=" + periodSeconds + ", successThreshold=" + successThreshold + ", timeoutSeconds="
				+ timeoutSeconds + ", " + (httpGet != null ? "httpGet=" + httpGet : "") + "]";
	}
	
	
	

}

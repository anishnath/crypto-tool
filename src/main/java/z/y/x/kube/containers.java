package z.y.x.kube;

import java.util.Arrays;
import java.util.List;

public class containers {
	
	private String args[] ;
	private String command [];
	private List<ports> ports ;
	private List<env> env ;
	private List<volumeMounts> volumeMounts ;
	private String image;
	private String name;
	private String imagePullPolicy="IfNotPresent";
	
	private dnsConfig dnsConfig;
	
	private livenessProbe livenessProbe;
	private readinessProbe readinessProbe;
	
	private securityContext securityContext;
	
	
	
	
	public List<volumeMounts> getVolumeMounts() {
		return volumeMounts;
	}
	public void setVolumeMounts(List<volumeMounts> volumeMounts) {
		this.volumeMounts = volumeMounts;
	}
	public securityContext getSecurityContext() {
		return securityContext;
	}
	public void setSecurityContext(securityContext securityContext) {
		this.securityContext = securityContext;
	}
	public dnsConfig getDnsConfig() {
		return dnsConfig;
	}
	public void setDnsConfig(dnsConfig dnsConfig) {
		this.dnsConfig = dnsConfig;
	}
	public String[] getArgs() {
		return args;
	}
	public void setArgs(String[] args) {
		this.args = args;
	}
	public String[] getCommand() {
		return command;
	}
	public void setCommand(String[] command) {
		this.command = command;
	}
	public List<ports> getPorts() {
		return ports;
	}
	public void setPorts(List<ports> ports) {
		this.ports = ports;
	}
	public List<env> getEnv() {
		return env;
	}
	public void setEnv(List<env> env) {
		this.env = env;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getImagePullPolicy() {
		return imagePullPolicy;
	}
	public void setImagePullPolicy(String imagePullPolicy) {
		this.imagePullPolicy = imagePullPolicy;
	}
	public livenessProbe getLivenessProbe() {
		return livenessProbe;
	}
	public void setLivenessProbe(livenessProbe livenessProbe) {
		this.livenessProbe = livenessProbe;
	}
	public readinessProbe getReadinessProbe() {
		return readinessProbe;
	}
	public void setReadinessProbe(readinessProbe readinessProbe) {
		this.readinessProbe = readinessProbe;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + Arrays.hashCode(args);
		result = prime * result + Arrays.hashCode(command);
		result = prime * result + ((dnsConfig == null) ? 0 : dnsConfig.hashCode());
		result = prime * result + ((env == null) ? 0 : env.hashCode());
		result = prime * result + ((image == null) ? 0 : image.hashCode());
		result = prime * result + ((imagePullPolicy == null) ? 0 : imagePullPolicy.hashCode());
		result = prime * result + ((livenessProbe == null) ? 0 : livenessProbe.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((ports == null) ? 0 : ports.hashCode());
		result = prime * result + ((readinessProbe == null) ? 0 : readinessProbe.hashCode());
		result = prime * result + ((securityContext == null) ? 0 : securityContext.hashCode());
		result = prime * result + ((volumeMounts == null) ? 0 : volumeMounts.hashCode());
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
		containers other = (containers) obj;
		if (!Arrays.equals(args, other.args))
			return false;
		if (!Arrays.equals(command, other.command))
			return false;
		if (dnsConfig == null) {
			if (other.dnsConfig != null)
				return false;
		} else if (!dnsConfig.equals(other.dnsConfig))
			return false;
		if (env == null) {
			if (other.env != null)
				return false;
		} else if (!env.equals(other.env))
			return false;
		if (image == null) {
			if (other.image != null)
				return false;
		} else if (!image.equals(other.image))
			return false;
		if (imagePullPolicy == null) {
			if (other.imagePullPolicy != null)
				return false;
		} else if (!imagePullPolicy.equals(other.imagePullPolicy))
			return false;
		if (livenessProbe == null) {
			if (other.livenessProbe != null)
				return false;
		} else if (!livenessProbe.equals(other.livenessProbe))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (ports == null) {
			if (other.ports != null)
				return false;
		} else if (!ports.equals(other.ports))
			return false;
		if (readinessProbe == null) {
			if (other.readinessProbe != null)
				return false;
		} else if (!readinessProbe.equals(other.readinessProbe))
			return false;
		if (securityContext == null) {
			if (other.securityContext != null)
				return false;
		} else if (!securityContext.equals(other.securityContext))
			return false;
		if (volumeMounts == null) {
			if (other.volumeMounts != null)
				return false;
		} else if (!volumeMounts.equals(other.volumeMounts))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "containers [" + (args != null ? "args=" + Arrays.toString(args) + ", " : "")
				+ (command != null ? "command=" + Arrays.toString(command) + ", " : "")
				+ (ports != null ? "ports=" + ports + ", " : "") + (env != null ? "env=" + env + ", " : "")
				+ (volumeMounts != null ? "volumeMounts=" + volumeMounts + ", " : "")
				+ (image != null ? "image=" + image + ", " : "") + (name != null ? "name=" + name + ", " : "")
				+ (imagePullPolicy != null ? "imagePullPolicy=" + imagePullPolicy + ", " : "")
				+ (dnsConfig != null ? "dnsConfig=" + dnsConfig + ", " : "")
				+ (livenessProbe != null ? "livenessProbe=" + livenessProbe + ", " : "")
				+ (readinessProbe != null ? "readinessProbe=" + readinessProbe + ", " : "")
				+ (securityContext != null ? "securityContext=" + securityContext : "") + "]";
	}
	
	

	
	
	
}

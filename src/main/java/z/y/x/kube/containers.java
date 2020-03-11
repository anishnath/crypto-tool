package z.y.x.kube;
import java.util.Arrays;
import java.util.List;

import z.y.x.kube.env1.EnvFromSource;
import z.y.x.kube.generic.VolumeDevice;
import z.y.x.kube.generic.resources;

public class containers {
	
	private List<String> args ;
	private List<String> command;
	private List<env> env ;
	private EnvFromSource envFrom;
	private String image;
	private String imagePullPolicy="IfNotPresent";
	private livenessProbe livenessProbe;
	private String name;
	private List<ports> ports ;
	private readinessProbe readinessProbe;
	private resources resources;
	private securityContext securityContext;
	private boolean stdin;
	private boolean stdinOnce;
	private boolean tty;
	private List<volumeMounts> volumeMounts ;
	private List<VolumeDevice> volumeDevices ;
	private String workingDir;
	public List<String> getArgs() {
		return args;
	}
	public void setArgs(List<String> args) {
		this.args = args;
	}
	public List<String> getCommand() {
		return command;
	}
	public void setCommand(List<String> command) {
		this.command = command;
	}
	public List<env> getEnv() {
		return env;
	}
	public void setEnv(List<env> env) {
		this.env = env;
	}
	public EnvFromSource getEnvFrom() {
		return envFrom;
	}
	public void setEnvFrom(EnvFromSource envFrom) {
		this.envFrom = envFrom;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<ports> getPorts() {
		return ports;
	}
	public void setPorts(List<ports> ports) {
		this.ports = ports;
	}
	public readinessProbe getReadinessProbe() {
		return readinessProbe;
	}
	public void setReadinessProbe(readinessProbe readinessProbe) {
		this.readinessProbe = readinessProbe;
	}
	public resources getResources() {
		return resources;
	}
	public void setResources(resources resources) {
		this.resources = resources;
	}
	public securityContext getSecurityContext() {
		return securityContext;
	}
	public void setSecurityContext(securityContext securityContext) {
		this.securityContext = securityContext;
	}
	public boolean isStdin() {
		return stdin;
	}
	public void setStdin(boolean stdin) {
		this.stdin = stdin;
	}
	public boolean isStdinOnce() {
		return stdinOnce;
	}
	public void setStdinOnce(boolean stdinOnce) {
		this.stdinOnce = stdinOnce;
	}
	public boolean isTty() {
		return tty;
	}
	public void setTty(boolean tty) {
		this.tty = tty;
	}
	public List<volumeMounts> getVolumeMounts() {
		return volumeMounts;
	}
	public void setVolumeMounts(List<volumeMounts> volumeMounts) {
		this.volumeMounts = volumeMounts;
	}
	public List<VolumeDevice> getVolumeDevices() {
		return volumeDevices;
	}
	public void setVolumeDevices(List<VolumeDevice> volumeDevices) {
		this.volumeDevices = volumeDevices;
	}
	public String getWorkingDir() {
		return workingDir;
	}
	public void setWorkingDir(String workingDir) {
		this.workingDir = workingDir;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((args == null) ? 0 : args.hashCode());
		result = prime * result + ((command == null) ? 0 : command.hashCode());
		result = prime * result + ((env == null) ? 0 : env.hashCode());
		result = prime * result + ((envFrom == null) ? 0 : envFrom.hashCode());
		result = prime * result + ((image == null) ? 0 : image.hashCode());
		result = prime * result + ((imagePullPolicy == null) ? 0 : imagePullPolicy.hashCode());
		result = prime * result + ((livenessProbe == null) ? 0 : livenessProbe.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((ports == null) ? 0 : ports.hashCode());
		result = prime * result + ((readinessProbe == null) ? 0 : readinessProbe.hashCode());
		result = prime * result + ((resources == null) ? 0 : resources.hashCode());
		result = prime * result + ((securityContext == null) ? 0 : securityContext.hashCode());
		result = prime * result + (stdin ? 1231 : 1237);
		result = prime * result + (stdinOnce ? 1231 : 1237);
		result = prime * result + (tty ? 1231 : 1237);
		result = prime * result + ((volumeDevices == null) ? 0 : volumeDevices.hashCode());
		result = prime * result + ((volumeMounts == null) ? 0 : volumeMounts.hashCode());
		result = prime * result + ((workingDir == null) ? 0 : workingDir.hashCode());
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
		if (args == null) {
			if (other.args != null)
				return false;
		} else if (!args.equals(other.args))
			return false;
		if (command == null) {
			if (other.command != null)
				return false;
		} else if (!command.equals(other.command))
			return false;
		if (env == null) {
			if (other.env != null)
				return false;
		} else if (!env.equals(other.env))
			return false;
		if (envFrom == null) {
			if (other.envFrom != null)
				return false;
		} else if (!envFrom.equals(other.envFrom))
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
		if (resources == null) {
			if (other.resources != null)
				return false;
		} else if (!resources.equals(other.resources))
			return false;
		if (securityContext == null) {
			if (other.securityContext != null)
				return false;
		} else if (!securityContext.equals(other.securityContext))
			return false;
		if (stdin != other.stdin)
			return false;
		if (stdinOnce != other.stdinOnce)
			return false;
		if (tty != other.tty)
			return false;
		if (volumeDevices == null) {
			if (other.volumeDevices != null)
				return false;
		} else if (!volumeDevices.equals(other.volumeDevices))
			return false;
		if (volumeMounts == null) {
			if (other.volumeMounts != null)
				return false;
		} else if (!volumeMounts.equals(other.volumeMounts))
			return false;
		if (workingDir == null) {
			if (other.workingDir != null)
				return false;
		} else if (!workingDir.equals(other.workingDir))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "containers [args=" + args + ", command=" + command + ", env=" + env + ", envFrom=" + envFrom
				+ ", image=" + image + ", imagePullPolicy=" + imagePullPolicy + ", livenessProbe=" + livenessProbe
				+ ", name=" + name + ", ports=" + ports + ", readinessProbe=" + readinessProbe + ", resources="
				+ resources + ", securityContext=" + securityContext + ", stdin=" + stdin + ", stdinOnce=" + stdinOnce
				+ ", tty=" + tty + ", volumeMounts=" + volumeMounts + ", volumeDevices=" + volumeDevices
				+ ", workingDir=" + workingDir + "]";
	}
}

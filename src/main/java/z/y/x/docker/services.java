package z.y.x.docker;

import java.util.Arrays;
import java.util.Map;

public class services {
	
	private String image;
	private String command;
	private deploy deploy;
	private String container_name;
	private Map<String,String> environment;
	private Map<String,String> labels;
	private int[] expose;
	private String[] ports;
	private String[] dns;
	private String[] dns_search;
	private String[] links;
	private String[] depends_on;
	private String[] entrypoint;
	private String[] volumes;
	private String[] extra_hosts; 
	private String user;
	private String working_dir;
	private String domainname;
	private String hostname;
	private String ipc;
	private String mac_address;
	private boolean privileged = false;
	private healthcheck healthcheck;
	
	
	
	public healthcheck getHealthcheck() {
		return healthcheck;
	}
	public void setHealthcheck(healthcheck healthcheck) {
		this.healthcheck = healthcheck;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getCommand() {
		return command;
	}
	public void setCommand(String command) {
		this.command = command;
	}
	public deploy getDeploy() {
		return deploy;
	}
	public void setDeploy(deploy deploy) {
		this.deploy = deploy;
	}
	public String getContainer_name() {
		return container_name;
	}
	public void setContainer_name(String container_name) {
		this.container_name = container_name;
	}
	public Map<String, String> getEnvironment() {
		return environment;
	}
	public void setEnvironment(Map<String, String> environment) {
		this.environment = environment;
	}
	public Map<String, String> getLabels() {
		return labels;
	}
	public void setLabels(Map<String, String> labels) {
		this.labels = labels;
	}
	public int[] getExpose() {
		return expose;
	}
	public void setExpose(int[] expose) {
		this.expose = expose;
	}
	public String[] getPorts() {
		return ports;
	}
	public void setPorts(String[] ports) {
		this.ports = ports;
	}
	public String[] getDns() {
		return dns;
	}
	public void setDns(String[] dns) {
		this.dns = dns;
	}
	public String[] getDns_search() {
		return dns_search;
	}
	public void setDns_search(String[] dns_search) {
		this.dns_search = dns_search;
	}
	public String[] getLinks() {
		return links;
	}
	public void setLinks(String[] links) {
		this.links = links;
	}
	public String[] getDepends_on() {
		return depends_on;
	}
	public void setDepends_on(String[] depends_on) {
		this.depends_on = depends_on;
	}
	public String[] getEntrypoint() {
		return entrypoint;
	}
	public void setEntrypoint(String[] entrypoint) {
		this.entrypoint = entrypoint;
	}
	public String[] getVolumes() {
		return volumes;
	}
	public void setVolumes(String[] volumes) {
		this.volumes = volumes;
	}
	public String[] getExtra_hosts() {
		return extra_hosts;
	}
	public void setExtra_hosts(String[] extra_hosts) {
		this.extra_hosts = extra_hosts;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getWorking_dir() {
		return working_dir;
	}
	public void setWorking_dir(String working_dir) {
		this.working_dir = working_dir;
	}
	public String getDomainname() {
		return domainname;
	}
	public void setDomainname(String domainname) {
		this.domainname = domainname;
	}
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	public String getIpc() {
		return ipc;
	}
	public void setIpc(String ipc) {
		this.ipc = ipc;
	}
	public String getMac_address() {
		return mac_address;
	}
	public void setMac_address(String mac_address) {
		this.mac_address = mac_address;
	}
	public boolean isPrivileged() {
		return privileged;
	}
	public void setPrivileged(boolean privileged) {
		this.privileged = privileged;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((command == null) ? 0 : command.hashCode());
		result = prime * result + ((container_name == null) ? 0 : container_name.hashCode());
		result = prime * result + Arrays.hashCode(depends_on);
		result = prime * result + ((deploy == null) ? 0 : deploy.hashCode());
		result = prime * result + Arrays.hashCode(dns);
		result = prime * result + Arrays.hashCode(dns_search);
		result = prime * result + ((domainname == null) ? 0 : domainname.hashCode());
		result = prime * result + Arrays.hashCode(entrypoint);
		result = prime * result + ((environment == null) ? 0 : environment.hashCode());
		result = prime * result + Arrays.hashCode(expose);
		result = prime * result + Arrays.hashCode(extra_hosts);
		result = prime * result + ((healthcheck == null) ? 0 : healthcheck.hashCode());
		result = prime * result + ((hostname == null) ? 0 : hostname.hashCode());
		result = prime * result + ((image == null) ? 0 : image.hashCode());
		result = prime * result + ((ipc == null) ? 0 : ipc.hashCode());
		result = prime * result + ((labels == null) ? 0 : labels.hashCode());
		result = prime * result + Arrays.hashCode(links);
		result = prime * result + ((mac_address == null) ? 0 : mac_address.hashCode());
		result = prime * result + Arrays.hashCode(ports);
		result = prime * result + (privileged ? 1231 : 1237);
		result = prime * result + ((user == null) ? 0 : user.hashCode());
		result = prime * result + Arrays.hashCode(volumes);
		result = prime * result + ((working_dir == null) ? 0 : working_dir.hashCode());
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
		services other = (services) obj;
		if (command == null) {
			if (other.command != null)
				return false;
		} else if (!command.equals(other.command))
			return false;
		if (container_name == null) {
			if (other.container_name != null)
				return false;
		} else if (!container_name.equals(other.container_name))
			return false;
		if (!Arrays.equals(depends_on, other.depends_on))
			return false;
		if (deploy == null) {
			if (other.deploy != null)
				return false;
		} else if (!deploy.equals(other.deploy))
			return false;
		if (!Arrays.equals(dns, other.dns))
			return false;
		if (!Arrays.equals(dns_search, other.dns_search))
			return false;
		if (domainname == null) {
			if (other.domainname != null)
				return false;
		} else if (!domainname.equals(other.domainname))
			return false;
		if (!Arrays.equals(entrypoint, other.entrypoint))
			return false;
		if (environment == null) {
			if (other.environment != null)
				return false;
		} else if (!environment.equals(other.environment))
			return false;
		if (!Arrays.equals(expose, other.expose))
			return false;
		if (!Arrays.equals(extra_hosts, other.extra_hosts))
			return false;
		if (healthcheck == null) {
			if (other.healthcheck != null)
				return false;
		} else if (!healthcheck.equals(other.healthcheck))
			return false;
		if (hostname == null) {
			if (other.hostname != null)
				return false;
		} else if (!hostname.equals(other.hostname))
			return false;
		if (image == null) {
			if (other.image != null)
				return false;
		} else if (!image.equals(other.image))
			return false;
		if (ipc == null) {
			if (other.ipc != null)
				return false;
		} else if (!ipc.equals(other.ipc))
			return false;
		if (labels == null) {
			if (other.labels != null)
				return false;
		} else if (!labels.equals(other.labels))
			return false;
		if (!Arrays.equals(links, other.links))
			return false;
		if (mac_address == null) {
			if (other.mac_address != null)
				return false;
		} else if (!mac_address.equals(other.mac_address))
			return false;
		if (!Arrays.equals(ports, other.ports))
			return false;
		if (privileged != other.privileged)
			return false;
		if (user == null) {
			if (other.user != null)
				return false;
		} else if (!user.equals(other.user))
			return false;
		if (!Arrays.equals(volumes, other.volumes))
			return false;
		if (working_dir == null) {
			if (other.working_dir != null)
				return false;
		} else if (!working_dir.equals(other.working_dir))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "services [" + (image != null ? "image=" + image + ", " : "")
				+ (command != null ? "command=" + command + ", " : "")
				+ (deploy != null ? "deploy=" + deploy + ", " : "")
				+ (container_name != null ? "container_name=" + container_name + ", " : "")
				+ (environment != null ? "environment=" + environment + ", " : "")
				+ (labels != null ? "labels=" + labels + ", " : "")
				+ (expose != null ? "expose=" + Arrays.toString(expose) + ", " : "")
				+ (ports != null ? "ports=" + Arrays.toString(ports) + ", " : "")
				+ (dns != null ? "dns=" + Arrays.toString(dns) + ", " : "")
				+ (dns_search != null ? "dns_search=" + Arrays.toString(dns_search) + ", " : "")
				+ (links != null ? "links=" + Arrays.toString(links) + ", " : "")
				+ (depends_on != null ? "depends_on=" + Arrays.toString(depends_on) + ", " : "")
				+ (entrypoint != null ? "entrypoint=" + Arrays.toString(entrypoint) + ", " : "")
				+ (volumes != null ? "volumes=" + Arrays.toString(volumes) + ", " : "")
				+ (extra_hosts != null ? "extra_hosts=" + Arrays.toString(extra_hosts) + ", " : "")
				+ (user != null ? "user=" + user + ", " : "")
				+ (working_dir != null ? "working_dir=" + working_dir + ", " : "")
				+ (domainname != null ? "domainname=" + domainname + ", " : "")
				+ (hostname != null ? "hostname=" + hostname + ", " : "") + (ipc != null ? "ipc=" + ipc + ", " : "")
				+ (mac_address != null ? "mac_address=" + mac_address + ", " : "") + "privileged=" + privileged + ", "
				+ (healthcheck != null ? "healthcheck=" + healthcheck : "") + "]";
	}
}

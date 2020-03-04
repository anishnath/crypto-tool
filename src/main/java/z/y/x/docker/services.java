package z.y.x.docker;

import java.util.Arrays;
import java.util.Map;

public class services {
	
	private String image;
	private String[] command;
	private deploy deploy;
	private String container_name;
	private Map<String,String> environment;
	private String[] env_file;
	private Map<String,String> labels;
	private int[] expose;
	private String[] ports;
	private String[] dns;
	private String[] dns_search;
	private String[] dns_option;
	private String[] links;
	private String[] depends_on;
	private String[] entrypoint;
	private String[] volumes;
	private String[] devices;
	private String[] extra_hosts; 
	private String[] tmpfs;
	private String[] cap_add;
	private String[] cap_drop;
	private String[] networks;
	private String[] security_opt;
	private String user;
	private String working_dir;
	private String domainname;
	private String hostname;
	private String ipc;
	private String mac_address;
	private boolean privileged = false;
	private healthcheck healthcheck;
	private logging logging;
	private ulimits ulimits;
	private boolean tty;
	private boolean init;
	private boolean stdin_open;
	private String pid;
	private String cidfile;
	
	
	
	
	
	
	
	
	
	public boolean isStdin_open() {
		return stdin_open;
	}
	public void setStdin_open(boolean stdin_open) {
		this.stdin_open = stdin_open;
	}
	public String getCidfile() {
		return cidfile;
	}
	public void setCidfile(String cidfile) {
		this.cidfile = cidfile;
	}
	public String[] getCommand() {
		return command;
	}
	public void setCommand(String[] command) {
		this.command = command;
	}
	public String getPid() {
		return pid;
	}
	public void setPid(String pid) {
		this.pid = pid;
	}
	public boolean isInit() {
		return init;
	}
	public void setInit(boolean init) {
		this.init = init;
	}
	public String[] getSecurity_opt() {
		return security_opt;
	}
	public void setSecurity_opt(String[] security_opt) {
		this.security_opt = security_opt;
	}
	public boolean isTty() {
		return tty;
	}
	public void setTty(boolean tty) {
		this.tty = tty;
	}
	public ulimits getUlimits() {
		return ulimits;
	}
	public void setUlimits(ulimits ulimits) {
		this.ulimits = ulimits;
	}
	public String[] getNetworks() {
		return networks;
	}
	public void setNetworks(String[] networks) {
		this.networks = networks;
	}
	public String[] getCap_add() {
		return cap_add;
	}
	public void setCap_add(String[] cap_add) {
		this.cap_add = cap_add;
	}
	public String[] getCap_drop() {
		return cap_drop;
	}
	public void setCap_drop(String[] cap_drop) {
		this.cap_drop = cap_drop;
	}
	public String[] getTmpfs() {
		return tmpfs;
	}
	public void setTmpfs(String[] tmpfs) {
		this.tmpfs = tmpfs;
	}
	public String[] getDevices() {
		return devices;
	}
	public void setDevices(String[] devices) {
		this.devices = devices;
	}
	public String[] getEnv_file() {
		return env_file;
	}
	public void setEnv_file(String[] env_file) {
		this.env_file = env_file;
	}
	public String[] getDns_option() {
		return dns_option;
	}
	public void setDns_option(String[] dns_option) {
		this.dns_option = dns_option;
	}
	public logging getLogging() {
		return logging;
	}
	public void setLogging(logging logging) {
		this.logging = logging;
	}
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
		result = prime * result + Arrays.hashCode(cap_add);
		result = prime * result + Arrays.hashCode(cap_drop);
		result = prime * result + ((cidfile == null) ? 0 : cidfile.hashCode());
		result = prime * result + Arrays.hashCode(command);
		result = prime * result + ((container_name == null) ? 0 : container_name.hashCode());
		result = prime * result + Arrays.hashCode(depends_on);
		result = prime * result + ((deploy == null) ? 0 : deploy.hashCode());
		result = prime * result + Arrays.hashCode(devices);
		result = prime * result + Arrays.hashCode(dns);
		result = prime * result + Arrays.hashCode(dns_option);
		result = prime * result + Arrays.hashCode(dns_search);
		result = prime * result + ((domainname == null) ? 0 : domainname.hashCode());
		result = prime * result + Arrays.hashCode(entrypoint);
		result = prime * result + Arrays.hashCode(env_file);
		result = prime * result + ((environment == null) ? 0 : environment.hashCode());
		result = prime * result + Arrays.hashCode(expose);
		result = prime * result + Arrays.hashCode(extra_hosts);
		result = prime * result + ((healthcheck == null) ? 0 : healthcheck.hashCode());
		result = prime * result + ((hostname == null) ? 0 : hostname.hashCode());
		result = prime * result + ((image == null) ? 0 : image.hashCode());
		result = prime * result + (init ? 1231 : 1237);
		result = prime * result + ((ipc == null) ? 0 : ipc.hashCode());
		result = prime * result + ((labels == null) ? 0 : labels.hashCode());
		result = prime * result + Arrays.hashCode(links);
		result = prime * result + ((logging == null) ? 0 : logging.hashCode());
		result = prime * result + ((mac_address == null) ? 0 : mac_address.hashCode());
		result = prime * result + Arrays.hashCode(networks);
		result = prime * result + ((pid == null) ? 0 : pid.hashCode());
		result = prime * result + Arrays.hashCode(ports);
		result = prime * result + (privileged ? 1231 : 1237);
		result = prime * result + Arrays.hashCode(security_opt);
		result = prime * result + (stdin_open ? 1231 : 1237);
		result = prime * result + Arrays.hashCode(tmpfs);
		result = prime * result + (tty ? 1231 : 1237);
		result = prime * result + ((ulimits == null) ? 0 : ulimits.hashCode());
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
		if (!Arrays.equals(cap_add, other.cap_add))
			return false;
		if (!Arrays.equals(cap_drop, other.cap_drop))
			return false;
		if (cidfile == null) {
			if (other.cidfile != null)
				return false;
		} else if (!cidfile.equals(other.cidfile))
			return false;
		if (!Arrays.equals(command, other.command))
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
		if (!Arrays.equals(devices, other.devices))
			return false;
		if (!Arrays.equals(dns, other.dns))
			return false;
		if (!Arrays.equals(dns_option, other.dns_option))
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
		if (!Arrays.equals(env_file, other.env_file))
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
		if (init != other.init)
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
		if (logging == null) {
			if (other.logging != null)
				return false;
		} else if (!logging.equals(other.logging))
			return false;
		if (mac_address == null) {
			if (other.mac_address != null)
				return false;
		} else if (!mac_address.equals(other.mac_address))
			return false;
		if (!Arrays.equals(networks, other.networks))
			return false;
		if (pid == null) {
			if (other.pid != null)
				return false;
		} else if (!pid.equals(other.pid))
			return false;
		if (!Arrays.equals(ports, other.ports))
			return false;
		if (privileged != other.privileged)
			return false;
		if (!Arrays.equals(security_opt, other.security_opt))
			return false;
		if (stdin_open != other.stdin_open)
			return false;
		if (!Arrays.equals(tmpfs, other.tmpfs))
			return false;
		if (tty != other.tty)
			return false;
		if (ulimits == null) {
			if (other.ulimits != null)
				return false;
		} else if (!ulimits.equals(other.ulimits))
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
				+ (command != null ? "command=" + Arrays.toString(command) + ", " : "")
				+ (deploy != null ? "deploy=" + deploy + ", " : "")
				+ (container_name != null ? "container_name=" + container_name + ", " : "")
				+ (environment != null ? "environment=" + environment + ", " : "")
				+ (env_file != null ? "env_file=" + Arrays.toString(env_file) + ", " : "")
				+ (labels != null ? "labels=" + labels + ", " : "")
				+ (expose != null ? "expose=" + Arrays.toString(expose) + ", " : "")
				+ (ports != null ? "ports=" + Arrays.toString(ports) + ", " : "")
				+ (dns != null ? "dns=" + Arrays.toString(dns) + ", " : "")
				+ (dns_search != null ? "dns_search=" + Arrays.toString(dns_search) + ", " : "")
				+ (dns_option != null ? "dns_option=" + Arrays.toString(dns_option) + ", " : "")
				+ (links != null ? "links=" + Arrays.toString(links) + ", " : "")
				+ (depends_on != null ? "depends_on=" + Arrays.toString(depends_on) + ", " : "")
				+ (entrypoint != null ? "entrypoint=" + Arrays.toString(entrypoint) + ", " : "")
				+ (volumes != null ? "volumes=" + Arrays.toString(volumes) + ", " : "")
				+ (devices != null ? "devices=" + Arrays.toString(devices) + ", " : "")
				+ (extra_hosts != null ? "extra_hosts=" + Arrays.toString(extra_hosts) + ", " : "")
				+ (tmpfs != null ? "tmpfs=" + Arrays.toString(tmpfs) + ", " : "")
				+ (cap_add != null ? "cap_add=" + Arrays.toString(cap_add) + ", " : "")
				+ (cap_drop != null ? "cap_drop=" + Arrays.toString(cap_drop) + ", " : "")
				+ (networks != null ? "networks=" + Arrays.toString(networks) + ", " : "")
				+ (security_opt != null ? "security_opt=" + Arrays.toString(security_opt) + ", " : "")
				+ (user != null ? "user=" + user + ", " : "")
				+ (working_dir != null ? "working_dir=" + working_dir + ", " : "")
				+ (domainname != null ? "domainname=" + domainname + ", " : "")
				+ (hostname != null ? "hostname=" + hostname + ", " : "") + (ipc != null ? "ipc=" + ipc + ", " : "")
				+ (mac_address != null ? "mac_address=" + mac_address + ", " : "") + "privileged=" + privileged + ", "
				+ (healthcheck != null ? "healthcheck=" + healthcheck + ", " : "")
				+ (logging != null ? "logging=" + logging + ", " : "")
				+ (ulimits != null ? "ulimits=" + ulimits + ", " : "") + "tty=" + tty + ", init=" + init
				+ ", stdin_open=" + stdin_open + ", " + (pid != null ? "pid=" + pid + ", " : "")
				+ (cidfile != null ? "cidfile=" + cidfile : "") + "]";
	}
}

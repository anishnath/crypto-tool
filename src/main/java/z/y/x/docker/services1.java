package z.y.x.docker;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class services1 {
	
	private String restart;
	private String image;
	private String command;
	private deploy deploy;
	private String container_name;
	private List<String> environment;
	private List<String> sysctls;
	private String[] env_file;
	private List<String> labels;
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
	private List<String> cap_add;
	private List<String> cap_drop;
	private Map<String,Object> networks;
	private String[] security_opt;
	private String user;
	private String working_dir;
	private String domainname;
	private String hostname;
	private String ipc;
	private String mac_address;
	private boolean privileged = false;
	private healthcheck1 healthcheck;
	private logging logging;
	private ulimits ulimits;
	private boolean tty;
	private boolean init;
	private boolean stdin_open;
	private String pid;
	private String cidfile;
	private String cgroup_parent;
	private String stop_signal;
	
	//v2.2
	
	private int cpu_count;
	private int cpu_percent;
	private float cpus;  //--cpus
	private int cpu_shares; //--cpu-shares
	private int cpu_quota; //--cpu-quota
	private String cpu_period; //--cpu-period
	private String cpuset;  //--cpuset-cpus
		
	private String mem_limit; //--memory
	private String memswap_limit; // --memory-swap
	private String mem_reservation; //--memory-reservation
		
	private int oom_score_adj; //--oom-score-adj
	private boolean oom_kill_disable; //--oom-kill-disable
		
	private String shm_size;

	public String getRestart() {
		return restart;
	}

	public void setRestart(String restart) {
		this.restart = restart;
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

	public List<String> getEnvironment() {
		return environment;
	}

	public void setEnvironment(List<String> environment) {
		this.environment = environment;
	}

	public List<String> getSysctls() {
		return sysctls;
	}

	public void setSysctls(List<String> sysctls) {
		this.sysctls = sysctls;
	}

	public String[] getEnv_file() {
		return env_file;
	}

	public void setEnv_file(String[] env_file) {
		this.env_file = env_file;
	}

	public List<String> getLabels() {
		return labels;
	}

	public void setLabels(List<String> labels) {
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

	public String[] getDns_option() {
		return dns_option;
	}

	public void setDns_option(String[] dns_option) {
		this.dns_option = dns_option;
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

	public String[] getDevices() {
		return devices;
	}

	public void setDevices(String[] devices) {
		this.devices = devices;
	}

	public String[] getExtra_hosts() {
		return extra_hosts;
	}

	public void setExtra_hosts(String[] extra_hosts) {
		this.extra_hosts = extra_hosts;
	}

	public String[] getTmpfs() {
		return tmpfs;
	}

	public void setTmpfs(String[] tmpfs) {
		this.tmpfs = tmpfs;
	}

	public List<String> getCap_add() {
		return cap_add;
	}

	public void setCap_add(List<String> cap_add) {
		this.cap_add = cap_add;
	}

	public List<String> getCap_drop() {
		return cap_drop;
	}

	public void setCap_drop(List<String> cap_drop) {
		this.cap_drop = cap_drop;
	}

	public Map<String, Object> getNetworks() {
		return networks;
	}

	public void setNetworks(Map<String, Object> networks) {
		this.networks = networks;
	}

	public String[] getSecurity_opt() {
		return security_opt;
	}

	public void setSecurity_opt(String[] security_opt) {
		this.security_opt = security_opt;
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

	public healthcheck1 getHealthcheck() {
		return healthcheck;
	}

	public void setHealthcheck(healthcheck1 healthcheck) {
		this.healthcheck = healthcheck;
	}

	public logging getLogging() {
		return logging;
	}

	public void setLogging(logging logging) {
		this.logging = logging;
	}

	public ulimits getUlimits() {
		return ulimits;
	}

	public void setUlimits(ulimits ulimits) {
		this.ulimits = ulimits;
	}

	public boolean isTty() {
		return tty;
	}

	public void setTty(boolean tty) {
		this.tty = tty;
	}

	public boolean isInit() {
		return init;
	}

	public void setInit(boolean init) {
		this.init = init;
	}

	public boolean isStdin_open() {
		return stdin_open;
	}

	public void setStdin_open(boolean stdin_open) {
		this.stdin_open = stdin_open;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getCidfile() {
		return cidfile;
	}

	public void setCidfile(String cidfile) {
		this.cidfile = cidfile;
	}

	public String getCgroup_parent() {
		return cgroup_parent;
	}

	public void setCgroup_parent(String cgroup_parent) {
		this.cgroup_parent = cgroup_parent;
	}

	public String getStop_signal() {
		return stop_signal;
	}

	public void setStop_signal(String stop_signal) {
		this.stop_signal = stop_signal;
	}

	public int getCpu_count() {
		return cpu_count;
	}

	public void setCpu_count(int cpu_count) {
		this.cpu_count = cpu_count;
	}

	public int getCpu_percent() {
		return cpu_percent;
	}

	public void setCpu_percent(int cpu_percent) {
		this.cpu_percent = cpu_percent;
	}

	public float getCpus() {
		return cpus;
	}

	public void setCpus(float cpus) {
		this.cpus = cpus;
	}

	public int getCpu_shares() {
		return cpu_shares;
	}

	public void setCpu_shares(int cpu_shares) {
		this.cpu_shares = cpu_shares;
	}

	public int getCpu_quota() {
		return cpu_quota;
	}

	public void setCpu_quota(int cpu_quota) {
		this.cpu_quota = cpu_quota;
	}

	public String getCpu_period() {
		return cpu_period;
	}

	public void setCpu_period(String cpu_period) {
		this.cpu_period = cpu_period;
	}

	public String getCpuset() {
		return cpuset;
	}

	public void setCpuset(String cpuset) {
		this.cpuset = cpuset;
	}

	public String getMem_limit() {
		return mem_limit;
	}

	public void setMem_limit(String mem_limit) {
		this.mem_limit = mem_limit;
	}

	public String getMemswap_limit() {
		return memswap_limit;
	}

	public void setMemswap_limit(String memswap_limit) {
		this.memswap_limit = memswap_limit;
	}

	public String getMem_reservation() {
		return mem_reservation;
	}

	public void setMem_reservation(String mem_reservation) {
		this.mem_reservation = mem_reservation;
	}

	public int getOom_score_adj() {
		return oom_score_adj;
	}

	public void setOom_score_adj(int oom_score_adj) {
		this.oom_score_adj = oom_score_adj;
	}

	public boolean isOom_kill_disable() {
		return oom_kill_disable;
	}

	public void setOom_kill_disable(boolean oom_kill_disable) {
		this.oom_kill_disable = oom_kill_disable;
	}

	public String getShm_size() {
		return shm_size;
	}

	public void setShm_size(String shm_size) {
		this.shm_size = shm_size;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((cap_add == null) ? 0 : cap_add.hashCode());
		result = prime * result + ((cap_drop == null) ? 0 : cap_drop.hashCode());
		result = prime * result + ((cgroup_parent == null) ? 0 : cgroup_parent.hashCode());
		result = prime * result + ((cidfile == null) ? 0 : cidfile.hashCode());
		result = prime * result + ((command == null) ? 0 : command.hashCode());
		result = prime * result + ((container_name == null) ? 0 : container_name.hashCode());
		result = prime * result + cpu_count;
		result = prime * result + cpu_percent;
		result = prime * result + ((cpu_period == null) ? 0 : cpu_period.hashCode());
		result = prime * result + cpu_quota;
		result = prime * result + cpu_shares;
		result = prime * result + Float.floatToIntBits(cpus);
		result = prime * result + ((cpuset == null) ? 0 : cpuset.hashCode());
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
		result = prime * result + ((mem_limit == null) ? 0 : mem_limit.hashCode());
		result = prime * result + ((mem_reservation == null) ? 0 : mem_reservation.hashCode());
		result = prime * result + ((memswap_limit == null) ? 0 : memswap_limit.hashCode());
		result = prime * result + ((networks == null) ? 0 : networks.hashCode());
		result = prime * result + (oom_kill_disable ? 1231 : 1237);
		result = prime * result + oom_score_adj;
		result = prime * result + ((pid == null) ? 0 : pid.hashCode());
		result = prime * result + Arrays.hashCode(ports);
		result = prime * result + (privileged ? 1231 : 1237);
		result = prime * result + ((restart == null) ? 0 : restart.hashCode());
		result = prime * result + Arrays.hashCode(security_opt);
		result = prime * result + ((shm_size == null) ? 0 : shm_size.hashCode());
		result = prime * result + (stdin_open ? 1231 : 1237);
		result = prime * result + ((stop_signal == null) ? 0 : stop_signal.hashCode());
		result = prime * result + ((sysctls == null) ? 0 : sysctls.hashCode());
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
		services1 other = (services1) obj;
		if (cap_add == null) {
			if (other.cap_add != null)
				return false;
		} else if (!cap_add.equals(other.cap_add))
			return false;
		if (cap_drop == null) {
			if (other.cap_drop != null)
				return false;
		} else if (!cap_drop.equals(other.cap_drop))
			return false;
		if (cgroup_parent == null) {
			if (other.cgroup_parent != null)
				return false;
		} else if (!cgroup_parent.equals(other.cgroup_parent))
			return false;
		if (cidfile == null) {
			if (other.cidfile != null)
				return false;
		} else if (!cidfile.equals(other.cidfile))
			return false;
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
		if (cpu_count != other.cpu_count)
			return false;
		if (cpu_percent != other.cpu_percent)
			return false;
		if (cpu_period == null) {
			if (other.cpu_period != null)
				return false;
		} else if (!cpu_period.equals(other.cpu_period))
			return false;
		if (cpu_quota != other.cpu_quota)
			return false;
		if (cpu_shares != other.cpu_shares)
			return false;
		if (Float.floatToIntBits(cpus) != Float.floatToIntBits(other.cpus))
			return false;
		if (cpuset == null) {
			if (other.cpuset != null)
				return false;
		} else if (!cpuset.equals(other.cpuset))
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
		if (mem_limit == null) {
			if (other.mem_limit != null)
				return false;
		} else if (!mem_limit.equals(other.mem_limit))
			return false;
		if (mem_reservation == null) {
			if (other.mem_reservation != null)
				return false;
		} else if (!mem_reservation.equals(other.mem_reservation))
			return false;
		if (memswap_limit == null) {
			if (other.memswap_limit != null)
				return false;
		} else if (!memswap_limit.equals(other.memswap_limit))
			return false;
		if (networks == null) {
			if (other.networks != null)
				return false;
		} else if (!networks.equals(other.networks))
			return false;
		if (oom_kill_disable != other.oom_kill_disable)
			return false;
		if (oom_score_adj != other.oom_score_adj)
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
		if (restart == null) {
			if (other.restart != null)
				return false;
		} else if (!restart.equals(other.restart))
			return false;
		if (!Arrays.equals(security_opt, other.security_opt))
			return false;
		if (shm_size == null) {
			if (other.shm_size != null)
				return false;
		} else if (!shm_size.equals(other.shm_size))
			return false;
		if (stdin_open != other.stdin_open)
			return false;
		if (stop_signal == null) {
			if (other.stop_signal != null)
				return false;
		} else if (!stop_signal.equals(other.stop_signal))
			return false;
		if (sysctls == null) {
			if (other.sysctls != null)
				return false;
		} else if (!sysctls.equals(other.sysctls))
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
		return "services1 [restart=" + restart + ", image=" + image + ", command=" + command + ", deploy=" + deploy
				+ ", container_name=" + container_name + ", environment=" + environment + ", sysctls=" + sysctls
				+ ", env_file=" + Arrays.toString(env_file) + ", labels=" + labels + ", expose="
				+ Arrays.toString(expose) + ", ports=" + Arrays.toString(ports) + ", dns=" + Arrays.toString(dns)
				+ ", dns_search=" + Arrays.toString(dns_search) + ", dns_option=" + Arrays.toString(dns_option)
				+ ", links=" + Arrays.toString(links) + ", depends_on=" + Arrays.toString(depends_on) + ", entrypoint="
				+ Arrays.toString(entrypoint) + ", volumes=" + Arrays.toString(volumes) + ", devices="
				+ Arrays.toString(devices) + ", extra_hosts=" + Arrays.toString(extra_hosts) + ", tmpfs="
				+ Arrays.toString(tmpfs) + ", cap_add=" + cap_add + ", cap_drop=" + cap_drop + ", networks=" + networks
				+ ", security_opt=" + Arrays.toString(security_opt) + ", user=" + user + ", working_dir=" + working_dir
				+ ", domainname=" + domainname + ", hostname=" + hostname + ", ipc=" + ipc + ", mac_address="
				+ mac_address + ", privileged=" + privileged + ", healthcheck=" + healthcheck + ", logging=" + logging
				+ ", ulimits=" + ulimits + ", tty=" + tty + ", init=" + init + ", stdin_open=" + stdin_open + ", pid="
				+ pid + ", cidfile=" + cidfile + ", cgroup_parent=" + cgroup_parent + ", stop_signal=" + stop_signal
				+ ", cpu_count=" + cpu_count + ", cpu_percent=" + cpu_percent + ", cpus=" + cpus + ", cpu_shares="
				+ cpu_shares + ", cpu_quota=" + cpu_quota + ", cpu_period=" + cpu_period + ", cpuset=" + cpuset
				+ ", mem_limit=" + mem_limit + ", memswap_limit=" + memswap_limit + ", mem_reservation="
				+ mem_reservation + ", oom_score_adj=" + oom_score_adj + ", oom_kill_disable=" + oom_kill_disable
				+ ", shm_size=" + shm_size + "]";
	}
	
	
}

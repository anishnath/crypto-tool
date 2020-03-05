package z.y.x.docker;

import java.util.HashMap;
import java.util.Map;

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;


public class Docker {

    private static final Map<String, String> commandMap = new HashMap<>();

    static {
        commandMap.put("--add-host", "--add-host");
        commandMap.put("--attach", "--attach");
        commandMap.put("--blkio-weight", "--blkio-weight");
        commandMap.put("--blkio-weight-device", "--blkio-weight-device");
        commandMap.put("--cap-add", "--cap-add");
        commandMap.put("--cap-drop", "--cap-drop");
        commandMap.put("-it", "-it");
        commandMap.put("-ti", "-ti");
        commandMap.put("-a", "-a");
        commandMap.put("-c", "-c");
        commandMap.put("-d", "-d");
        commandMap.put("-e", "-e");
        commandMap.put("-h", "-h");
        commandMap.put("-i", "-i");
        commandMap.put("-l", "-l");
        commandMap.put("-m", "-m");
        commandMap.put("-p", "-p");
        commandMap.put("-P", "-P");
        commandMap.put("-t", "-t");
        commandMap.put("-u", "-u");
        commandMap.put("-v", "-v");
        commandMap.put("-w", "-w");
        commandMap.put("--cgroup-parent", "--cgroup-parent");
        commandMap.put("--cidfile", "--cidfile");
        commandMap.put("--cpu-period", "--cpu-period");
        commandMap.put("--cpu-quota", "--cpu-quota");
        commandMap.put("--cpu-rt-period", "--cpu-rt-period");
        commandMap.put("--cpu-rt-runtime", "--cpu-rt-runtime");
        commandMap.put("--cpu-shares", "--cpu-shares");
        commandMap.put("--cpus", "--cpus");
        commandMap.put("--cpuset-cpus", "--cpuset-cpus");
        commandMap.put("--cpuset-mems", "--cpuset-mems");
        commandMap.put("--detach ", "--detach ");
        commandMap.put("--detach-keys", "--detach-keys");
        commandMap.put("--device", "--device");
        commandMap.put("--device-cgroup-rule", "--device-cgroup-rule");
        commandMap.put("--device-read-bps", "--device-read-bps");
        commandMap.put("--device-read-iops", "--device-read-iops");
        commandMap.put("--device-write-bps", "--device-write-bps");
        commandMap.put("--device-write-iops", "--device-write-iops");
        commandMap.put("--disable-content-trust", "--disable-content-trust");
        commandMap.put("--dns", "--dns");
        commandMap.put("--dns-option", "--dns-option");
        commandMap.put("--dns-search", "--dns-search");
        commandMap.put("--domainname", "--domainname");
        commandMap.put("--entrypoint", "--entrypoint");
        commandMap.put("--env", "--env");
        commandMap.put("--env-file", "--env-file");
        commandMap.put("--expose", "--expose");
        commandMap.put("--gpus", "--gpus");
        commandMap.put("--group-add", "--group-add");
        commandMap.put("--health-cmd", "--health-cmd");
        commandMap.put("--health-interval", "--health-interval");
        commandMap.put("--health-retries", "--health-retries");
        commandMap.put("--health-start-period", "--health-start-period");
        commandMap.put("--health-timeout", "--health-timeout");
        commandMap.put("--hostname", "--hostname");
        commandMap.put("--init", "--init");
        commandMap.put("--interactive", "--interactive");
        commandMap.put("--ip", "--ip");
        commandMap.put("--ip6", "--ip6");
        commandMap.put("--ipc", "--ipc");
        commandMap.put("--isolation", "--isolation");
        commandMap.put("--kernel-memory", "--kernel-memory");
        commandMap.put("--label", "--label");
        commandMap.put("--label-file", "--label-file");
        commandMap.put("--link", "--link");
        commandMap.put("--link-local-ip", "--link-local-ip");
        commandMap.put("--log-driver", "--log-driver");
        commandMap.put("--log-opt", "--log-opt");
        commandMap.put("--mac-address", "--mac-address");
        commandMap.put("--memory", "--memory");
        commandMap.put("--memory-reservation", "--memory-reservation");
        commandMap.put("--memory-swap", "--memory-swap");
        commandMap.put("--memory-swappiness", "--memory-swappiness");
        commandMap.put("--mount", "--mount");
        commandMap.put("--name", "--name");
        commandMap.put("--network", "--network");
        commandMap.put("--network-alias", "--network-alias");
        commandMap.put("--no-healthcheck", "--no-healthcheck");
        commandMap.put("--oom-kill-disable", "--oom-kill-disable");
        commandMap.put("--oom-score-adj", "--oom-score-adj");
        commandMap.put("--pid", "--pid");
        commandMap.put("--pids-limit", "--pids-limit");
        commandMap.put("--privileged", "--privileged");
        commandMap.put("--publish", "--publish");
        commandMap.put("--publish-all", "--publish-all");
        commandMap.put("--read-only", "--read-only");
        commandMap.put("--restart", "--restart");
        commandMap.put("--rm", "--rm");
        commandMap.put("--runtime", "--runtime");
        commandMap.put("--security-opt", "--security-opt");
        commandMap.put("--shm-size", "--shm-size");
        commandMap.put("--sig-proxy", "--sig-proxy");
        commandMap.put("--stop-signal", "--stop-signal");
        commandMap.put("--stop-timeout", "--stop-timeout");
        commandMap.put("--storage-opt", "--storage-opt");
        commandMap.put("--sysctl", "--sysctl");
        commandMap.put("--tmpfs", "--tmpfs");
        commandMap.put("--tty", "--tty");
        commandMap.put("--ulimit", "--ulimit");
        commandMap.put("--user", "--user");
        commandMap.put("--userns", "--userns");
        commandMap.put("--uts", "--uts");
        commandMap.put("--volume", "--volume");
        commandMap.put("--volume-driver", "--volume-driver");
        commandMap.put("--volumes-from", "--volumes-from");
        commandMap.put("--workdir", "--workdir");
    }

    private String image;
    private String[] command;
    private deploy deploy;
    private String container_name;
    private Map<String, String> environment;
    private Map<String, String> sysctls;
    private Map<String, String> labels;
    private int[] expose;
    private String[] ports;
    private String[] dns;
    private String[] dns_search;
    private String[] dns_option;
    private String[] links;
    private String[] depends_on;
    private String[] entrypoint;
    private String[] volumes;
    private String[] extra_hosts;
    private String[] env_file;
    private String user;
    private String working_dir;
    private String domainname;
    private String[] security_opt;
    private String hostname;
    private String ipc;
    private String mac_address;
    private boolean privileged = false;
    private String[] devices;
    private String[] tmpfs;
    private healthcheck healthcheck;
    private String[] healthCMD;
    private String[] cap_add;
    private String[] cap_drop;
    private String[] networks;
    private limits limits;
    private reservations reservations;
    private resources resources;
    private ulimits ulimits;

    public static void main(String[] args) {

        Docker docker = new Docker();

        String dockerCommand = "docker run -p 80:80 --tty --init --security-opt=seccomp:unconfined --mac-address=02:42:ac:11:65:43 --ulimit nofile=1024:1024  --network network  -h containerhostname --name nginxc --cap-drop NET_ADMIN  --cap-drop SYS_ADMIN --cap-add ALL --health-cmd 'curl -sS http://127.0.0.1 || exit 1' --tmpfs /run --privileged --restart on-failure --device /dev/sdc:/dev/xvdc -l my-label --label com.example.foo=bar -e MYVAR1 --env MYVAR2=foo --env-file ./env.list --add-host somehost:162.242.195.82 --dns 10.0.0.10  --dns=1.1.1.1 -v /var/run/docker.sock:/tmp/docker.sock -v 32:32 --restart always --log-opt max-size=1g nginx";


        docker.genDockerCompose(dockerCommand);

    }

    public static String[] determineObject(String value, String[] obj) {
        if (value != null && value.length() > 0) {
            if (obj == null) {
                obj = new String[1];
            }

            if (null == obj[0]) {
                obj[0] = value;
            } else {
                obj = addX(obj.length, obj, value);
            }


        }
        return obj;
    }

    private static int[] addX(int n, int arr[], int x) {
        int i;

        // create a new array of size n+1
        int newarr[] = new int[n + 1];

        // insert the elements from
        // the old array into the new array
        // insert all elements till n
        // then insert x at n+1
        for (i = 0; i < n; i++)
            newarr[i] = arr[i];

        newarr[n] = x;

        return newarr;
    }

    private static String[] addX(int n, String arr[], String x) {
        int i;

        // create a new array of size n+1
        String newarr[] = new String[n + 1];

        // insert the elements from
        // the old array into the new array
        // insert all elements till n
        // then insert x at n+1
        for (i = 0; i < n; i++)
            newarr[i] = arr[i];

        newarr[n] = x;

        return newarr;
    }

    public String genDockerCompose() {

        return genDockerCompose(null);

    }

    public String genDockerCompose(String dockercommand) {


        DockerCompose dockerCompose = new DockerCompose();
        services services = new services();
        logging logging = new logging();
        Map<String, String> logMap = new HashMap<>();


        //String arr = "docker run -i -t --dns=10.0.0.10 --dns=10.0.0.11 --dns-search=example.com --dns-opt=use-vc   8dbd9e392a96 /bin/bash ";
        //arr = "docker run -p 80:80 --tty --init --security-opt=seccomp:unconfined --mac-address=02:42:ac:11:65:43 --ulimit nofile=1024:1024  --network network  -h containerhostname --name nginxc --cap-drop NET_ADMIN  --cap-drop SYS_ADMIN --cap-add ALL --health-cmd 'curl -sS http://127.0.0.1 || exit 1' --tmpfs /run --privileged --restart on-failure --device /dev/sdc:/dev/xvdc -l my-label --label com.example.foo=bar -e MYVAR1 --env MYVAR2=foo --env-file ./env.list --add-host somehost:162.242.195.82 --dns 10.0.0.10  --dns=1.1.1.1 -v /var/run/docker.sock:/tmp/docker.sock -v 32:32 --restart always --log-opt max-size=1g nginx";

        //System.out.println(arr);

        String dockerarr[] = dockercommand.split(" ");


        String imageName = dockerarr[dockerarr.length - 1];

        //services.setImage(imageName);

        for (int i = 0; i < dockerarr.length - 1; i++) {

            String temp = dockerarr[i].trim();

            //System.out.println(temp);

            if ("docker".equals(temp)
                    || "-a".equals(temp)
                    || "--attach".equals(temp)
                    || "-d".equals(temp)
                    || "run".equals(temp)
                    || "--detach".equals(temp)) {
                continue;
            }

            if ("--privileged".equals(temp)) {
                services.setPrivileged(true);
                continue;
            }

            if ("--tty".equals(temp) || "-t".equals(temp)) {
                services.setTty(true);
                continue;
            }

            if ("--interactive".equals(temp) || "-i".equals(temp)) {
                services.setStdin_open(true);
                continue;
            }

            if ("-it".equals(temp) || "-ti".equals(temp)) {
                services.setStdin_open(true);
                services.setTty(true);
                continue;
            }

            if ("--init".equals(temp)) {
                services.setInit(true);
                dockerCompose.setVersion("3.7");
                continue;
            }


            if (temp.trim().length() > 0) {

                if (commandMap.get(temp) != null) {
                    //System.out.println("COMMAND " + temp);
                    String value = dockerarr[i + 1].trim();
                    //System.out.println("VALUE " + value );

                    if (value != null) {
                        if ("--log-opt".equals(commandMap.get(temp))) {

                            logMap = getMapValue(value);
                            logging.setOptions(logMap);
                            services.setLogging(logging);
                        }

                        if ("-v".equals(commandMap.get(temp)) || "--volume".equals(commandMap.get(temp))) {

                            addVolume(value);
                            services.setVolumes(this.volumes);
                        }

                        if ("-p".equals(commandMap.get(temp)) || "--publish".equals(commandMap.get(temp))) {

                            addPorts(value);
                            services.setPorts(this.ports);
                        }

                        if ("--ulimit".equals(commandMap.get(temp))) {
                            addUlimits(value);
                            services.setUlimits(this.ulimits);
                        }

                        if ("--pid".equals(commandMap.get(temp))) {

                            services.setPid(value);
                        }

                        if ("--name".equals(commandMap.get(temp))) {
                            services.setContainer_name(value);
                        }

                        if ("--dns".equals(commandMap.get(temp))) {
                            addDNS(value);
                            services.setDns(this.dns);
                        }

                        if ("--dns-search".equals(commandMap.get(temp))) {
                            addDNSSearch(value);
                            services.setDns(this.dns_search);
                        }

                        if ("--dns-option".equals(commandMap.get(temp))) {
                            addDNSOptions(value);
                            services.setDns(this.dns_option);
                        }

                        if ("--domainname".equals(commandMap.get(temp))) {

                            services.setDomainname(value);
                        }

                        if ("--cidfile".equals(commandMap.get(temp))) {

                            //There is No CID file
                            //services.setCidfile(value);
                        }

                        if ("--user".equals(commandMap.get(temp)) || "-u".equals(commandMap.get(temp))) {

                            services.setUser(value);
                        }

                        if ("--hostname".equals(commandMap.get(temp)) || "-h".equals(commandMap.get(temp))) {

                            services.setHostname(value);
                        }

                        if ("--entrypoint".equals(commandMap.get(temp))) {
                            addEntryPoint(value);
                            services.setEntrypoint(this.entrypoint);
                        }

                        if ("--add-host".equals(commandMap.get(temp))) {
                            addExtraHosts(value);
                            services.setExtra_hosts(this.extra_hosts);
                        }

                        if ("-e".equals(commandMap.get(temp)) || "--env".equals(commandMap.get(temp))) {
                            addEnv(value);
                            services.setEnvironment(this.environment);
                        }

                        if ("--env-file".equals(commandMap.get(temp))) {
                            addenv_file(value);
                            services.setEnv_file(this.env_file);
                        }

                        if ("-l".equals(commandMap.get(temp)) || "--label".equals(commandMap.get(temp))) {
                            addLabels(value);
                            services.setLabels(this.labels);
                        }

                        if ("--device".equals(commandMap.get(temp))) {
                            addDevices(value);
                            services.setDevices(this.devices);
                        }

                        if ("--mac-address".equals(commandMap.get(temp))) {
                            services.setMac_address(value);
                        }

                        if ("--link".equals(commandMap.get(temp))) {
                            addLinks(value);
                            services.setLinks(this.links);
                        }

                        if ("--cap-add".equals(commandMap.get(temp))) {
                            addCap_Add(value);
                            services.setCap_add(this.cap_add);
                        }
                        if ("--cap-drop".equals(commandMap.get(temp))) {
                            addCap_Drop(value);
                            services.setCap_drop(this.cap_drop);
                        }

                        if ("--network".equals(commandMap.get(temp))) {
                            addNetwork(value);
                            services.setNetworks(this.networks);


                        }

                        if ("--security-opt".equals(commandMap.get(temp))) {
                            addSecurityOpts(value);
                            services.setSecurity_opt(this.security_opt);
                        }

                        if ("-w".equals(commandMap.get(temp)) || "--workdir".equals(commandMap.get(temp))) {
                            services.setWorking_dir(value);
                        }

                        if ("--cpus".equals(commandMap.get(temp))) {
                            try {
                                services.setCpus(Float.valueOf(value));
                            } catch (NumberFormatException ne) {
                            }
                        }

                        if ("--cpu-shares".equals(commandMap.get(temp))) {
                            try {
                                services.setCpu_shares(Integer.valueOf(value));
                            } catch (NumberFormatException ne) {
                            }
                        }

                        if ("--cpu-quota".equals(commandMap.get(temp))) {
                            try {
                                services.setCpu_quota(Integer.valueOf(value));
                            } catch (NumberFormatException ne) {
                            }
                        }

                        if ("--cpu-period".equals(commandMap.get(temp))) {
                            services.setCpu_period(value);
                        }

                        if ("--cpuset-cpus".equals(commandMap.get(temp))) {
                            services.setCpuset(value);
                        }

                        if ("--memory".equals(commandMap.get(temp)) || "-m".equals(commandMap.get(temp))) {
                            services.setMem_limit(value);
                        }

                        if ("--memory-swap".equals(commandMap.get(temp))) {
                            services.setMemswap_limit(value);
                        }

                        if ("--memory-reservation".equals(commandMap.get(temp))) {
                            services.setMem_reservation(value);
                        }

                        if ("--oom-score-adj".equals(commandMap.get(temp))) {
                            try {
                                services.setOom_score_adj(Integer.valueOf(value));
                            } catch (NumberFormatException ne) {
                            }
                        }

                        if ("--oom-kill-disable".equals(commandMap.get(temp))) {
                            services.setOom_kill_disable(Boolean.valueOf(value));
                        }

                        if ("--shm-size".equals(commandMap.get(temp))) {
                            services.setShm_size(value);
                        }

                        if ("--cgroup-parent".equals(commandMap.get(temp))) {
                            services.setCgroup_parent(value);
                        }

                        if ("--stop-signal".equals(commandMap.get(temp))) {
                            services.setStop_signal(value);
                        }

                        if ("--stop-timeout".equals(commandMap.get(temp))) {
                            services.setStop_grace_period(value);
                        }

                        if ("--sysctl".equals(commandMap.get(temp))) {
                            addSysctl(value);
                            services.setSysctls(this.sysctls);
                        }


                        if ("--tmpfs".equals(commandMap.get(temp))) {
                            addTmpfs(value);
                            services.setTmpfs(this.tmpfs);
                        }

                        if ("--health-cmd".equals(commandMap.get(temp))) {
                            addHealthCheck(value, "test");
                        }

                        if ("--health-interval".equals(commandMap.get(temp))) {
                            addHealthCheck(value, "interval");
                        }


                        if ("--health-retries".equals(commandMap.get(temp))) {
                            addHealthCheck(value, "retries");
                        }


                        if ("--restart".equals(commandMap.get(temp))) {
                            Map<String, Object> m1 = new HashMap<String, Object>();
                            m1.put("condition", value);
                            if (deploy == null) {
                                deploy = new deploy();
                            }
                            deploy.setRestart_policy(m1);
                            if ("on-failure".equalsIgnoreCase(value)) {

                                deploy.setReplicas(2);

                                m1.put("condition", value);
                                m1.put("delay", "5s");
                                m1.put("window", "120s");
                                m1.put("max_attempts", Integer.valueOf(3));

                                Map<String, Object> m2 = new HashMap<String, Object>();
                                m2.put("parallelism", Integer.valueOf(2));
                                deploy.setUpdate_config(m2);
                                deploy.setRestart_policy(m1);
                            }


                        }


                    }
                } else {
                    String[] temparr = temp.split("=");
                    if (temparr != null && temparr[0] != null) {
                        temp = temparr[0];

                        if (commandMap.get(temp) != null) {
                            //System.out.println("COMMAND2 " + temp);
                            if (temparr.length == 2) {
                                String value = temparr[1];
                                if (value != null) {

                                    if ("--log-opt".equals(commandMap.get(temp))) {

                                        logMap = getMapValue(value);
                                        logging.setOptions(logMap);
                                        services.setLogging(logging);
                                    }

                                    if ("-v".equals(commandMap.get(temp)) || "--volume".equals(commandMap.get(temp))) {

                                        addVolume(value);
                                        services.setVolumes(this.volumes);
                                    }

                                    if ("-p".equals(commandMap.get(temp)) || "--publish".equals(commandMap.get(temp))) {

                                        addPorts(value);
                                        services.setPorts(this.ports);
                                    }

                                    if ("--ulimit".equals(commandMap.get(temp))) {
                                        addUlimits(value);
                                        services.setUlimits(this.ulimits);
                                    }

                                    if ("--pid".equals(commandMap.get(temp))) {

                                        services.setPid(value);
                                    }

                                    if ("--name".equals(commandMap.get(temp))) {
                                        services.setContainer_name(value);
                                    }

                                    if ("--dns".equals(commandMap.get(temp))) {
                                        addDNS(value);
                                        services.setDns(this.dns);
                                    }

                                    if ("--dns-search".equals(commandMap.get(temp))) {
                                        addDNSSearch(value);
                                        services.setDns(this.dns_search);
                                    }

                                    if ("--dns-option".equals(commandMap.get(temp))) {
                                        addDNSOptions(value);
                                        services.setDns(this.dns_option);
                                    }

                                    if ("--domainname".equals(commandMap.get(temp))) {

                                        services.setDomainname(value);
                                    }

                                    if ("--cidfile".equals(commandMap.get(temp))) {

                                        services.setCidfile(value);
                                    }

                                    if ("--user".equals(commandMap.get(temp)) || "-u".equals(commandMap.get(temp))) {

                                        services.setUser(value);
                                    }

                                    if ("--hostname".equals(commandMap.get(temp)) || "-h".equals(commandMap.get(temp))) {

                                        services.setHostname(value);
                                    }

                                    if ("--entrypoint".equals(commandMap.get(temp))) {
                                        addEntryPoint(value);
                                        services.setEntrypoint(this.entrypoint);
                                    }

                                    if ("--add-host".equals(commandMap.get(temp))) {
                                        addExtraHosts(value);
                                        services.setExtra_hosts(this.extra_hosts);
                                    }

                                    if ("-e".equals(commandMap.get(temp)) || "--env".equals(commandMap.get(temp))) {
                                        addEnv(value);
                                        services.setEnvironment(this.environment);
                                    }

                                    if ("--env-file".equals(commandMap.get(temp))) {
                                        addenv_file(value);
                                        services.setEnv_file(this.env_file);
                                    }

                                    if ("-l".equals(commandMap.get(temp)) || "--label".equals(commandMap.get(temp))) {
                                        addLabels(value);
                                        services.setLabels(this.labels);
                                    }

                                    if ("--device".equals(commandMap.get(temp))) {
                                        addDevices(value);
                                        services.setDevices(this.devices);
                                    }

                                    if ("--mac-address".equals(commandMap.get(temp))) {
                                        services.setMac_address(value);
                                    }

                                    if ("--link".equals(commandMap.get(temp))) {
                                        addLinks(value);
                                        services.setLinks(this.links);
                                    }

                                    if ("--cap-add".equals(commandMap.get(temp))) {
                                        addCap_Add(value);
                                        services.setCap_add(this.cap_add);
                                    }
                                    if ("--cap-drop".equals(commandMap.get(temp))) {
                                        addCap_Drop(value);
                                        services.setCap_drop(this.cap_drop);
                                    }

                                    if ("--network".equals(commandMap.get(temp))) {
                                        addNetwork(value);
                                        services.setNetworks(this.networks);


                                    }

                                    if ("--security-opt".equals(commandMap.get(temp))) {
                                        addSecurityOpts(value);
                                        services.setSecurity_opt(this.security_opt);
                                    }

                                    if ("-w".equals(commandMap.get(temp)) || "--workdir".equals(commandMap.get(temp))) {
                                        services.setWorking_dir(value);
                                    }

                                    if ("--cpus".equals(commandMap.get(temp))) {
                                        try {
                                            services.setCpus(Float.valueOf(value));
                                        } catch (NumberFormatException ne) {
                                        }
                                    }

                                    if ("--cpu-shares".equals(commandMap.get(temp))) {
                                        try {
                                            services.setCpu_shares(Integer.valueOf(value));
                                        } catch (NumberFormatException ne) {
                                        }
                                    }

                                    if ("--cpu-quota".equals(commandMap.get(temp))) {
                                        try {
                                            services.setCpu_quota(Integer.valueOf(value));
                                        } catch (NumberFormatException ne) {
                                        }
                                    }

                                    if ("--cpu-period".equals(commandMap.get(temp))) {
                                        services.setCpu_period(value);
                                    }

                                    if ("--cpuset-cpus".equals(commandMap.get(temp))) {
                                        services.setCpuset(value);
                                    }

                                    if ("--memory".equals(commandMap.get(temp)) || "-m".equals(commandMap.get(temp))) {
                                        services.setMem_limit(value);
                                    }

                                    if ("--memory-swap".equals(commandMap.get(temp))) {
                                        services.setMemswap_limit(value);
                                    }

                                    if ("--memory-reservation".equals(commandMap.get(temp))) {
                                        services.setMem_reservation(value);
                                    }

                                    if ("--oom-score-adj".equals(commandMap.get(temp))) {
                                        try {
                                            services.setOom_score_adj(Integer.valueOf(value));
                                        } catch (NumberFormatException ne) {
                                        }
                                    }

                                    if ("--oom-kill-disable".equals(commandMap.get(temp))) {
                                        services.setOom_kill_disable(Boolean.valueOf(value));
                                    }

                                    if ("--shm-size".equals(commandMap.get(temp))) {
                                        services.setShm_size(value);
                                    }

                                    if ("--cgroup-parent".equals(commandMap.get(temp))) {
                                        services.setCgroup_parent(value);
                                    }

                                    if ("--stop-signal".equals(commandMap.get(temp))) {
                                        services.setStop_signal(value);
                                    }

                                    if ("--stop-timeout".equals(commandMap.get(temp))) {
                                        services.setStop_grace_period(value);
                                    }

                                    if ("--sysctl".equals(commandMap.get(temp))) {
                                        addSysctl(value);
                                        services.setSysctls(this.sysctls);
                                    }


                                    if ("--tmpfs".equals(commandMap.get(temp))) {
                                        addTmpfs(value);
                                        services.setTmpfs(this.tmpfs);
                                    }

                                    if ("--health-cmd".equals(commandMap.get(temp))) {
                                        addHealthCheck(value, "test");
                                    }

                                    if ("--health-interval".equals(commandMap.get(temp))) {
                                        addHealthCheck(value, "interval");
                                    }


                                    if ("--health-retries".equals(commandMap.get(temp))) {
                                        addHealthCheck(value, "retries");
                                    }


                                    if ("--restart".equals(commandMap.get(temp))) {
                                        Map<String, Object> m1 = new HashMap<String, Object>();
                                        m1.put("condition", value);
                                        if (deploy == null) {
                                            deploy = new deploy();
                                        }
                                        deploy.setRestart_policy(m1);
                                        if ("on-failure".equalsIgnoreCase(value)) {

                                            deploy.setReplicas(2);

                                            m1.put("condition", value);
                                            m1.put("delay", "5s");
                                            m1.put("window", "120s");
                                            m1.put("max_attempts", Integer.valueOf(3));

                                            Map<String, Object> m2 = new HashMap<String, Object>();
                                            m2.put("parallelism", Integer.valueOf(2));
                                            deploy.setUpdate_config(m2);
                                            deploy.setRestart_policy(m1);
                                        }


                                    }


                                }

                            }
                        }
                    }
                }
            }

            //System.out.println(temp);


        }


        String array[] = dockercommand.split(" ");

        int j = array.length - 1;
        for (int i = array.length - 1; i > 0; i--) {
            String temp = array[i];

            if (temp != null && temp.trim().length() > 0) {
                temp = temp.trim();
                if (temp.contains("=")) {
                    String[] temparr = temp.split("=");
                    temp = temparr[0];
                }

                if (commandMap.get(temp) == null) {
                    j--;
                    if (j > 0) {
                        if (commandMap.get(array[j]) != null) {
                            break;
                        }

                    }

                }
            }
        }

        String[] trimmedArray = new String[array.length];
        int i = 0;
        for (j = j; j < array.length; j++) {

            if (array[j] != null && array[j].trim().length() > 0) {
                if (commandMap.get(array[j]) == null) {
                    trimmedArray[i] = array[j];
                    i++;
                }
            }

        }

        String whatatIndex0 = trimmedArray[0];

        //System.out.println("whatatIndex0 "  + whatatIndex0);

        boolean invalidIndex = false;
        if (whatatIndex0 != null) {
            if (whatatIndex0.contains("/tmp") || whatatIndex0.contains("=") || whatatIndex0.contains("--")) {
                invalidIndex = true;
            }
        }

        int k = 0;
        if (invalidIndex) {
            k = 1;
        }

        if (k < trimmedArray.length) {
            //System.out.println("Image Name " + trimmedArray[k]);
            services.setImage(trimmedArray[k]);
        }

        for (int k2 = k + 1; k2 < trimmedArray.length; k2++) {
            String commandsArgs = trimmedArray[k2];
            if (commandsArgs != null) {
                //System.out.println("Arguments " + commandsArgs);
                addCommands(commandsArgs);
                services.setCommand(this.command);
            }
        }


        Representer representer = new Representer() {
            @Override
            protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue, Tag customTag) {
                // if value of property is null, ignore it.
                if (propertyValue == null || propertyValue == "") {
                    return null;
                } else if ("init".equals(property.getName())
                        || "tty".equals(property.getName())
                        || "privileged".equals(property.getName())
                        || "stdin_open".equals(property.getName())
                        || "oom_kill_disable".equals(property.getName())
                        ) {

                    if (propertyValue != null) {
                        if (!Boolean.valueOf(propertyValue.toString())) {
                            return null;
                        }
                    }
                    return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);

                } else if ("cpu_count".equals(property.getName())
                        || "cpu_percent".equals(property.getName())
                        || "cpu_quota".equals(property.getName())
                        || "cpu_shares".equals(property.getName())
                        || "cpus".equals(property.getName())
                        || "oom_score_adj".equals(property.getName())
                        )

                {
                    if (propertyValue != null) {
                        try {
                            int tmp = Integer.valueOf(propertyValue.toString());
                            if (tmp == 0) {
                                return null;
                            }
                        } catch (NumberFormatException ne) {
                            return null;
                        }
                    }
                    return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);

                } else {
                    return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
                }
            }
        };

        representer.addClassTag(ipam.class, Tag.MAP);
        representer.addClassTag(DockerCompose.class, Tag.MAP);

        DumperOptions options = new DumperOptions();
        options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
        //options.set
        options.setPrettyFlow(true);

        Yaml yaml = new Yaml(representer, options);


        Map<String, services> mapServices = new HashMap<>();

        if (deploy != null) {
            services.setDeploy(deploy);
        }

        if (healthcheck != null) {
            services.setHealthcheck(healthcheck);
        }


        String cName = services.getContainer_name();

        if (null == cName) {
            cName = "mysrv";
        }

        mapServices.put(cName, services);
        dockerCompose.setServices(mapServices);

        String output = yaml.dump(dockerCompose);

        //System.out.println(output);

        return output;
    }

    //private String[] tmpfs;

    private void addEnv(String value) {
        if (value != null && value.length() > 0) {
            if (environment == null) {
                environment = new HashMap<>();
            }

            String[] items = value.split("\\s*,\\s*");

            for (String pair : items) {
                String[] entry = pair.split("=");
                if (entry.length == 2) {
                    environment.put(entry[0].trim(), entry[1].trim());
                } else if (entry.length < 2) {
                    environment.put(entry[0].trim(), entry[0].trim());
                }
            }
        }
    }

    private void addSysctl(String value) {
        if (value != null && value.length() > 0) {
            if (sysctls == null) {
                sysctls = new HashMap<>();
            }

            String[] items = value.split("\\s*,\\s*");

            for (String pair : items) {
                String[] entry = pair.split("=");
                if (entry.length == 2) {
                    sysctls.put(entry[0].trim(), entry[1].trim());
                } else if (entry.length < 2) {
                    sysctls.put(entry[0].trim(), entry[0].trim());
                }
            }
        }
    }

    private void addLabels(String value) {
        if (value != null && value.length() > 0) {
            if (labels == null) {
                labels = new HashMap<>();
            }

            String[] items = value.split("\\s*,\\s*");

            for (String pair : items) {
                String[] entry = pair.split("=");
                if (entry.length == 2) {
                    labels.put(entry[0].trim(), entry[1].trim());
                } else if (entry.length < 2) {
                    labels.put(entry[0].trim(), entry[0].trim());
                }
            }
        }
    }

    private void addCommands(String value) {
        if (value != null && value.length() > 0) {

            if (command == null) {
                command = new String[1];
            }

            if (null == command[0]) {
                command[0] = value;
            } else {
                command = addX(command.length, command, value);
            }

        }
    }

    private void addSecurityOpts(String value) {
        if (value != null && value.length() > 0) {

            if (security_opt == null) {
                security_opt = new String[1];
            }

            if (null == security_opt[0]) {
                security_opt[0] = value;
            } else {
                security_opt = addX(security_opt.length, security_opt, value);
            }

        }
    }

    private void addTmpfs(String value) {
        if (value != null && value.length() > 0) {
            if (tmpfs == null) {
                tmpfs = new String[1];
            }

            if (null == tmpfs[0]) {
                tmpfs[0] = value;
            } else {
                tmpfs = addX(tmpfs.length, tmpfs, value);
            }
        }
    }

    private void addNetwork(String value) {
        if (value != null && value.length() > 0) {
            if (networks == null) {
                networks = new String[1];
            }

            if (null == networks[0]) {
                networks[0] = value;
            } else {
                networks = addX(networks.length, networks, value);
            }
        }
    }

    private void addCap_Drop(String value) {
        if (value != null && value.length() > 0) {
            if (cap_drop == null) {
                cap_drop = new String[1];
            }

            if (null == cap_drop[0]) {
                cap_drop[0] = value;
            } else {
                cap_drop = addX(cap_drop.length, cap_drop, value);
            }
        }
    }

    private void addCap_Add(String value) {
        if (value != null && value.length() > 0) {
            if (cap_add == null) {
                cap_add = new String[1];
            }

            if (null == cap_add[0]) {
                cap_add[0] = value;
            } else {
                cap_add = addX(cap_add.length, cap_add, value);
            }
        }
    }

    private void addDevices(String value) {
        if (value != null && value.length() > 0) {
            if (devices == null) {
                devices = new String[1];
            }

            if (null == devices[0]) {
                devices[0] = value;
            } else {
                devices = addX(devices.length, devices, value);
            }
        }
    }

    private void addPorts(String value) {
        if (value != null && value.length() > 0) {
            if (ports == null) {
                ports = new String[1];
            }

            if (null == ports[0]) {
                ports[0] = value;
            } else {
                ports = addX(ports.length, ports, value);
            }
        }
    }

    //expose

    private void addenv_file(String value) {
        if (value != null && value.length() > 0) {
            if (env_file == null) {
                env_file = new String[1];
            }

            if (null == env_file[0]) {
                env_file[0] = value;
            } else {
                env_file = addX(env_file.length, env_file, value);
            }
        }
    }

    //entrypoint

    private void addExtraHosts(String value) {
        if (value != null && value.length() > 0) {
            if (extra_hosts == null) {
                extra_hosts = new String[1];
            }

            if (null == extra_hosts[0]) {
                extra_hosts[0] = value;
            } else {
                extra_hosts = addX(extra_hosts.length, extra_hosts, value);
            }
        }
    }

    private void addExpose(String value) {
        if (value != null && value.length() > 0) {
            if (expose == null) {
                expose = new int[1];
            }

            if (0 == expose[0]) {
                entrypoint[0] = value;
            } else {

                try {
                    Integer.valueOf(value);
                    expose = addX(expose.length, expose, Integer.valueOf(value));
                } catch (NumberFormatException e) {
                    expose = addX(expose.length, expose, 8080);
                }
            }
        }
    }

    private void addEntryPoint(String value) {
        if (value != null && value.length() > 0) {
            if (entrypoint == null) {
                entrypoint = new String[1];
            }

            if (null == entrypoint[0]) {
                entrypoint[0] = value;
            } else {
                entrypoint = addX(entrypoint.length, entrypoint, value);
            }
        }
    }

    private void addVolume(String value) {
        if (value != null && value.length() > 0) {
            if (volumes == null) {
                volumes = new String[1];
            }

            if (null == volumes[0]) {
                volumes[0] = value;
            } else {
                volumes = addX(volumes.length, volumes, value);
            }
        }
    }

    private void addDNS(String value) {
        if (value != null && value.length() > 0) {
            if (dns == null) {
                dns = new String[1];
            }

            if (null == dns[0]) {
                dns[0] = value;
            } else {
                dns = addX(dns.length, dns, value);
            }
        }
    }

    private void addDNSSearch(String value) {
        if (value != null && value.length() > 0) {
            if (dns_search == null) {
                dns_search = new String[1];
            }

            if (null == dns_search[0]) {
                dns_search[0] = value;
            } else {
                dns_search = addX(dns_search.length, dns_search, value);
            }
        }
    }

    private void addDNSOptions(String value) {
        if (value != null && value.length() > 0) {
            if (dns_option == null) {
                dns_option = new String[1];
            }

            if (null == dns_option[0]) {
                dns_option[0] = value;
            } else {
                dns_option = addX(dns_option.length, dns_option, value);
            }
        }
    }

    private void addLinks(String value) {
        if (value != null && value.length() > 0) {
            if (links == null) {
                links = new String[1];
            }

            if (null == links[0]) {
                links[0] = value;
            } else {
                links = addX(links.length, links, value);
            }
        }
    }

    private void addDependsOn(String value) {
        if (value != null && value.length() > 0) {
            if (depends_on == null) {
                depends_on = new String[1];
            }

            if (null == depends_on[0]) {
                depends_on[0] = value;
            } else {
                depends_on = addX(depends_on.length, depends_on, value);
            }
        }
    }

    private void addLimits(String value, String dataType) {
        if (value != null && value.length() > 0) {
            if (limits == null) {
                limits = new limits();
            }
        }
    }

    private void addUlimits(String value) {
        if (value != null && value.length() > 0) {
            if (ulimits == null) {
                ulimits = new ulimits();
            }

            //System.out.println("Ulimit -- " + value);

            if (value.contains("=") && value.contains("nofile")) {
                String[] tmp = value.split("=");
                if (tmp.length == 2) {
                    nofile nofile2 = new nofile();
                    String nofile = tmp[0];
                    String nofileValue = tmp[1];

                    String[] t1 = nofileValue.split(":");
                    if (t1.length == 2) {

                        try {
                            nofile2.setHard(Integer.valueOf(t1[0]));
                        } catch (NumberFormatException e) {
                        }

                        try {
                            nofile2.setSoft(Integer.valueOf(t1[1]));
                        } catch (NumberFormatException e) {
                        }

                        ulimits.setNofile(nofile2);
                        ulimits.setNproc(65535);
                    }


                }
            } else if (value.contains("=") && value.contains("nproc")) {
                String[] tmp = value.split("=");
                if (tmp.length == 2) {
                    try {
                        ulimits.setNproc(Integer.valueOf(tmp[1]));
                    } catch (NumberFormatException e) {
                    }
                }

            }

        }
    }

    private void addHealthCheck(String value, String dataType) {
        if (value != null && value.length() > 0) {
            if (healthcheck == null) {
                healthcheck = new healthcheck();
            }

            if (null == dataType) {
                dataType = "test";
            }


            if ("interval".equals(dataType)) {
                healthcheck.setInterval(value);
            }

            if ("timeout".equals(dataType)) {
                healthcheck.setTimeout(value);
            }
            if ("retries".equals(dataType)) {
                try {
                    healthcheck.setRetries(Integer.valueOf(value));
                } catch (NumberFormatException e) {
                    healthcheck.setRetries(3);
                }
            }
            if ("test".equals(dataType)) {
                if (healthCMD == null) {
                    healthCMD = new String[1];
                }

                if (null == healthCMD[0]) {
                    healthCMD[0] = value;
                } else {
                    healthCMD = addX(healthCMD.length, healthCMD, value);
                }
                healthcheck.setTest(healthCMD);
            }

        }

    }

    private String[] getArrayString(String data, String delimated) {
        String[] items = data.split(delimated);
        return items;

    }

    private String[] getArrayString(String data) {
        String[] items = data.split("\\s*,\\s*");
        return items;

    }

    private int[] getArrayINT(String data) {
        String[] items = data.split("\\s*,\\s*");
        int[] intItems = new int[items.length];

        for (int i = 0; i < items.length; i++) {
            try {

                intItems[i] = Integer.valueOf(items[i]);

            } catch (Exception ex) {
            }
        }
        return intItems;
    }

    private Map<String, String> getMapValue(String data) {
        String[] items = data.split("\\s*,\\s*");
        Map<String, String> map = new HashMap<>();

        for (String pair : items) {
            String[] entry = pair.split("=");
            if (entry.length == 2) {
                map.put(entry[0].trim(), entry[1].trim());
            } else if (entry.length < 2) {
                map.put(entry[0].trim(), entry[0].trim());
            }
        }
        return map;

    }

}

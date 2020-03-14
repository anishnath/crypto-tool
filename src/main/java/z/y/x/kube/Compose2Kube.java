package z.y.x.kube;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;

import z.y.x.kube.deployment.Deployment;
import z.y.x.kube.deployment.selector;
import z.y.x.kube.deployment.template;
import z.y.x.docker.DockerCompose;
import z.y.x.docker.DockerCompose1;
import z.y.x.docker.DockerCompose2Command;
import z.y.x.docker.deploy;
import z.y.x.docker.healthcheck;
import z.y.x.docker.healthcheck1;
import z.y.x.docker.ipam;
import z.y.x.docker.placement;
import z.y.x.docker.reservations;
import z.y.x.docker.services;
import z.y.x.docker.services1;
import z.y.x.kube.env1.ConfigMapEnvSource;
import z.y.x.kube.env1.EnvFromSource;
import z.y.x.kube.generic.VolumeDevice;
import z.y.x.kube.generic.limits;
import z.y.x.kube.generic.requests;
import z.y.x.kube.generic.resources;
import z.y.x.kube.persistentvolume.EmptyDirVolumeSource;
import z.y.x.kube.persistentvolume.PersistentVolume;
import z.y.x.kube.persistentvolume.PersistentVolumeClaim;
import z.y.x.kube.persistentvolume.PersistentVolumeClaimSpec;
import z.y.x.kube.persistentvolume.PersistentVolumeClaimVolumeSource;
import z.y.x.kube.persistentvolume.PersistentVolumeSpec;
import z.y.x.kube.persistentvolume.capacity;
import z.y.x.kube.persistentvolume.volumepojo;
import z.y.x.kube.ExecAction;
import z.y.x.kube.HostAlias;
import z.y.x.kube.Pod;
import z.y.x.kube.SELinuxOptions;
import z.y.x.kube.StatefulSet;
import z.y.x.kube.StatefulSetSpec;
import z.y.x.kube.capabilities;
import z.y.x.kube.containers;
import z.y.x.kube.dnsConfig;
import z.y.x.kube.env;
import z.y.x.kube.hostPath;
import z.y.x.kube.livenessProbe;
import z.y.x.kube.metadata;
import z.y.x.kube.options;
import z.y.x.kube.ports;
import z.y.x.kube.securityContext;
import z.y.x.kube.spec;
import z.y.x.kube.volumeMounts;
import z.y.x.kube.volumes;
import z.y.x.kube.replication.Replication;
import z.y.x.kube.replication.ReplicationControllerSpec;
import z.y.x.kube.service.Service;
import z.y.x.kube.service.servicepojo;

public class Compose2Kube {

	private final static String defualt = "default";

	public static void main(String[] args) throws Exception {
		Compose2Kube compose2Kube = new Compose2Kube();
		String pvcName = "claim2";
		String pvName = "pv0002";

		String path = "/data/drupal";
		List<String> accessModes = new ArrayList<>();
		accessModes.add("ReadWriteOnce");
		accessModes.add("ReadOnlyMany");

		String yaml = compose2Kube.getPV(pvName, null, path);
		System.out.println(yaml);

		yaml = compose2Kube.getPVC(pvcName, pvName, null);

		System.out.println(yaml);

		String svcName = "mysrv";
		List<String> ports = new ArrayList<>();
		ports.add("123");
		ports.add("80:8080");
		ports.add("443:8443");
		ports.add("INVALID");

		Map<String, String> srvMap = new HashMap<>();
		srvMap.put("app", "nginx");

		yaml = compose2Kube.getSVC(svcName, srvMap, ports);
		System.out.println(yaml);

		InputStream inputStream = DockerCompose2Command.class.getResourceAsStream("../docker/nginx.yml");
		String testYAML = convertInputStreamToString(inputStream);

		yaml = compose2Kube.getKube(testYAML, false, false, false, false, true);

	}

	public String getKube(String yamlString, boolean addSecurityContextToPod, boolean podGen, boolean deployGen,
			boolean repliGen, boolean statefulGen) throws Exception {

		if (null == yamlString || yamlString.trim().length() == 0) {
			throw new Exception("Invalid YAML File");
		}

		StringBuilder finalString = new StringBuilder();

		Object obj = null;
		boolean yamlLoaded = false;
		try {
			Yaml yaml = getDockerYaml();
			InputStream inputStream = new ByteArrayInputStream(yamlString.getBytes());
			obj = yaml.loadAs(inputStream, DockerCompose.class);
			yamlLoaded = true;
		} catch (Exception e) {

		}

		if (!yamlLoaded) {
			try {
				Yaml yaml = getDockerYaml();
				InputStream inputStream = new ByteArrayInputStream(yamlString.getBytes());
				obj = yaml.loadAs(inputStream, DockerCompose1.class);
				yamlLoaded = true;
			} catch (Exception e) {
				throw new Exception(e);
			}
		}

		if (!yamlLoaded) {
			throw new Exception("Invalid Compose File");
		}

		List<containers> containersList = null;
		List<volumeMounts> volumeMountsList = null;
		List<volumepojo> volumeMountsTmpfsList = null;
		List<volumes> volumesList = null;

		// Non Kube Stuff
		List<volumepojo> volumepojoList = null;
		List<servicepojo> servicepojosList = null;
		List<String> configMapFileNameList = null;

		Pod pod = null;
		spec spec = null;
		resources resources = null;
		requests requests = null;
		limits limits = null;
		volumeMounts volumeMounts = null;
		securityContext securityContext = null;
		dnsConfig dnsConfig = null;
		containers containers = null;
		metadata metadata = null;
		capabilities capabilities = null;
		servicepojo servicepojo = null;

		if (obj instanceof DockerCompose1) {
			DockerCompose1 compose = (DockerCompose1) obj;
			if (compose != null && compose.getServices() != null) {
				Map<String, services1> servicesMap = compose.getServices();

				int size = servicesMap.entrySet().size();
				finalString.append("#Generated using the tool https://8gwifi.org/kube1.jsp\n");
				finalString.append("#Total Number of Services Found " + size + "\n");

				for (Map.Entry<String, services1> entry : servicesMap.entrySet()) {
					String key = entry.getKey();

					finalString.append("\n#Generating kubernetes YAML file for the Service " + key + ".yml\n");

					containersList = new ArrayList<>();
					volumeMountsList = new ArrayList<>();
					volumeMountsTmpfsList = new ArrayList<>();
					volumesList = new ArrayList<>();
					volumepojoList = new ArrayList<>();
					servicepojosList = new ArrayList<>();
					configMapFileNameList = new ArrayList<>();

					services1 services = entry.getValue();
					containers = new containers();
					pod = new Pod();
					spec = new spec();
					resources = new resources();
					limits = new limits();
					requests = new requests();
					securityContext = new securityContext();
					dnsConfig = new dnsConfig();
					metadata = new metadata();
					capabilities = new capabilities();

					int replica = 1;

					metadata.setNamespace(defualt);

					if (services.isPrivileged()) {
						securityContext.setPrivileged(true);
						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}

					}
					if (services.isTty()) {
						containers.setTty(true);
					}
					if (services.isStdin_open()) {
						containers.setStdin(true);
					}

					if (services.isInit()) {
						// Check This
					}

					if (services.getCgroup_parent() != null) {
						// Check This
					}
					if (services.getLogging() != null) {
						// Check This
					}
					if (services.getVolumes() != null) {
						String[] data = services.getVolumes();
						for (int i = 0; i < data.length; i++) {
							volumeMounts = new volumeMounts();
							String data1 = data[i];
							String hostpath = null;
							String conatinerPath = data1;
							String accessMode = null;
							if (data1.contains(":")) {
								String[] temp = data1.split(":");
								if (temp.length == 2) {
									hostpath = temp[0];
									conatinerPath = temp[1];
								}
								if (temp.length == 3) {
									hostpath = temp[0];
									conatinerPath = temp[1];
									accessMode = temp[2];
								}
							}
							String volmeMountname = "pvo." + i;
							volumepojo volumepojo = new volumepojo();
							volumeMounts.setMountPath(conatinerPath);
							volumeMounts.setName(volmeMountname);
							if (accessMode != null && "ro".equals(accessMode)) {
								volumeMounts.setReadOnly(true);
								volumepojo.setAccessMode("ReadOnlyMany");
							} else {
								volumepojo.setAccessMode("ReadWriteOnce");
							}
							if (hostpath != null && hostpath.trim().length() > 0) {
								volumepojo.setName(volmeMountname);
								volumepojo.setPath(hostpath);
								volumepojoList.add(volumepojo);
							}
							volumeMountsList.add(volumeMounts);
						}

						containers.setVolumeMounts(volumeMountsList);

						if (volumepojoList.size() > 0) {
							int i = 0;
							for (Iterator iterator = volumepojoList.iterator(); iterator.hasNext();) {
								volumepojo volumepojo2 = (volumepojo) iterator.next();
								volumes volumes = new volumes();
								PersistentVolumeClaimVolumeSource persistentVolumeClaim = new PersistentVolumeClaimVolumeSource();
								volumes.setName(volumepojo2.getName());
								persistentVolumeClaim.setClaimName("claimname." + i);
								volumes.setPersistentVolumeClaim(persistentVolumeClaim);
								volumesList.add(volumes);
								spec.setVolumes(volumesList);
								i++;
							}
						}
					}

					if (services.getUlimits() != null) {
						// Cant Do Anything
					}

					if (services.getPid() != null) {
						String pid = services.getPid().trim();
						if ("host".equalsIgnoreCase(pid)) {
							spec.setHostPID(true);
						}
					}

					if (services.getContainer_name() != null) {
						containers.setName(services.getContainer_name());
					}

					if (services.getCpus() != 0.0) {
						// What to Do
						// System.out.println("CPU- " + services.getCpus());
					}

					if (services.getCpu_shares() != 0) {
						requests.setCpu(String.valueOf(services.getCpu_shares()));
						resources.setRequests(requests);
						containers.setResources(resources);
					}

					if (services.getCpu_quota() != 0) {
						// What to Do
					}

					if (services.getCpu_period() != null) {
						// What to do
					}

					if (services.getCpuset() != null) {
						// What to do
					}
					if (services.getMem_limit() != null) {
						requests.setMemory(services.getMem_limit());
						resources.setRequests(requests);
						containers.setResources(resources);
					}

					if (services.getMemswap_limit() != null) {
						// What to do
					}
					if (services.getMem_reservation() != null) {
						limits.setMemory(services.getMem_reservation());
					}
					if (services.getOom_score_adj() != 0) {
						// What to do
					}
					if (services.getShm_size() != null) {
						// What to do
					}

					if (services.getSysctls() != null) {
						securityContext.setSysctls(services.getSysctls());
						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}
					}
					if (services.getDns() != null) {

						dnsConfig.setNameservers(services.getDns());
						spec.setDnsConfig(dnsConfig);
					}
					if (services.getDns_search() != null) {
						dnsConfig.setSearches(services.getDns_search());
						spec.setDnsConfig(dnsConfig);
					}
					if (services.getDns_option() != null) {
						z.y.x.kube.options options = null;
						List<options> optionsList = new ArrayList<>();
						String[] data = services.getDns_option();
						for (int i = 0; i < data.length; i++) {
							options = new z.y.x.kube.options();
							String temp[] = data[i].split("=");
							if (temp.length == 2) {
								options.setName(temp[0]);
								options.setValue(temp[1]);
							}
							if (temp.length == 1) {
								options.setName(temp[0]);
							}
							optionsList.add(options);
						}

						if (optionsList.size() > 0) {
							dnsConfig.setOptions(optionsList);
							spec.setDnsConfig(dnsConfig);
						}

					}

					if (services.getDomainname() != null) {
						spec.setSubdomain(services.getDomainname());
					}

					if (services.getUser() != null) {

						int runAsUser = 1000;
						try {
							runAsUser = Integer.valueOf(services.getUser());
						} catch (NumberFormatException e) {
							runAsUser = 1000;
						}
						securityContext.setRunAsUser(runAsUser);
						securityContext.setRunAsGroup(runAsUser);
						if (runAsUser == 0) {
							securityContext.setAllowPrivilegeEscalation(true);
						}

						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}
					}

					if (services.getHostname() != null) {
						spec.setHostname(services.getHostname());
					}

					if (services.getStop_signal() != null) {
						spec.setTerminationGracePeriodSeconds(30);
					}

					if (services.getEntrypoint() != null) {
						ArrayList<String> entrylist = new ArrayList<String>(Arrays.asList(services.getEntrypoint()));
						containers.setCommand(entrylist);
					}

					if (services.getExtra_hosts() != null) {
						// System.out.println("Extra Hosts");
						String[] data = services.getExtra_hosts();
						List<HostAlias> hostaliasesList = new ArrayList<>();
						for (int i = 0; i < data.length; i++) {
							String temp[] = data[i].split(":");
							if (temp.length == 2) {
								HostAlias hostaliases = new HostAlias();
								List<String> hostname = new ArrayList<String>();
								hostname.add(temp[0]);
								hostaliases.setHostnames(hostname);
								hostaliases.setIp(temp[1]);
								hostaliasesList.add(hostaliases);
							}
						}

						if (hostaliasesList.size() > 0) {
							spec.setHostAliases(hostaliasesList);
						}
					}

					if (services.getEnv_file() != null) {
						EnvFromSource envFromSource = new EnvFromSource();
						ConfigMapEnvSource configMapEnvSource = new ConfigMapEnvSource();
						String filename = "env_file_from_configmap_" + new Random().nextInt(10);
						configMapEnvSource.setName(filename);
						envFromSource.setConfigMapRef(configMapEnvSource);
						containers.setEnvFrom(envFromSource);
						StringBuilder builder = new StringBuilder();
						for (int i = 0; i < services.getEnv_file().length; i++) {
							builder.append(" ");
							builder.append("--from-file=");
							builder.append(services.getEnv_file()[i]);
						}
						String kubeCommand = "# kubectl create configmap " + filename + " " + builder.toString();
						configMapFileNameList.add(kubeCommand);
					}

					if (services.getLabels() != null) {
						List<String> labelList = services.getLabels();
						labelList.add("generated.by=8gwifi.org");
						Map<String, String> annotanationMap = getMapValue(services.getLabels(), "=");
						metadata.setAnnotations(annotanationMap);

					}

					if (services.getDevices() != null) {
						List<VolumeDevice> volumedeviceList = new ArrayList<>();
						VolumeDevice volumeDevice;
						String[] data = services.getDevices();
						for (int i = 0; i < data.length; i++) {
							volumeDevice = new VolumeDevice();
							String data1 = data[i];
							String hostpath = null;
							String conatinerPath = data1;
							String accessMode = null;
							if (data1.contains(":")) {
								String[] temp = data1.split(":");
								if (temp.length == 2) {
									hostpath = temp[0];
									conatinerPath = temp[1];
								}
								if (temp.length == 3) {
									hostpath = temp[0];
									conatinerPath = temp[1];
									accessMode = temp[2];
								}
							}
							String volmeMountname = "mydevice" + i;
							volumeDevice.setDevicePath(conatinerPath);
							volumeDevice.setName(volmeMountname);
							volumedeviceList.add(volumeDevice);
						}

						if (volumedeviceList.size() > 0) {
							containers.setVolumeDevices(volumedeviceList);
							securityContext.setPrivileged(true);
							if (!addSecurityContextToPod) {
								containers.setSecurityContext(securityContext);
							} else {
								spec.setSecurityContext(securityContext);
							}

							for (Iterator iterator = volumedeviceList.iterator(); iterator.hasNext();) {
								VolumeDevice volumeDevice2 = (VolumeDevice) iterator.next();
								volumes volumes = new volumes();
								hostPath hostPath = new hostPath();
								hostPath.setPath(volumeDevice2.getDevicePath());
								hostPath.setType(null);
								volumes.setHostPath(hostPath);
								volumes.setName(volumeDevice2.getName());
								volumesList.add(volumes);
							}
							if (volumesList.size() > 0) {
								spec.setVolumes(volumesList);
							}

						}

					}

					if (services.getMac_address() != null) {
						// What To DO
					}

					if (services.getCap_add() != null) {
						capabilities.setAdd(services.getCap_add());
						securityContext.setCapabilities(capabilities);
						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}
					}

					if (services.getCap_drop() != null) {
						capabilities.setDrop(services.getCap_drop());
						securityContext.setCapabilities(capabilities);
						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}
					}

					if (services.getSecurity_opt() != null) {
						String[] data = services.getSecurity_opt();
						SELinuxOptions linuxOptions = new SELinuxOptions();
						for (int i = 0; i < data.length; i++) {
							// System.out.println(data[i].indexOf("label:"));
							int isExist = data[i].indexOf("label:");

							if (isExist < 0) {
								isExist = data[i].indexOf("label=");
							}

							// System.out.println(isExist);

							if (isExist == 0) {
								String temp = data[i].substring(6, data[i].length());
								// System.out.println(temp);

								if (temp.indexOf("level:") == 0) {
									linuxOptions.setLevel(temp.substring(6, temp.length()));
								}
								if (temp.indexOf("type:") == 0) {
									linuxOptions.setType(temp.substring(5, temp.length()));
								}
								if (temp.indexOf("user:") == 0) {
									linuxOptions.setUser(temp.substring(5, temp.length()));
								}

								if (temp.indexOf("role:") == 0) {
									linuxOptions.setRole(temp.substring(5, temp.length()));
								}
								securityContext.setSeLinuxOptions(linuxOptions);

								if (!addSecurityContextToPod) {
									containers.setSecurityContext(securityContext);
								} else {
									spec.setSecurityContext(securityContext);
								}

							}

						}
					}

					if (services.getWorking_dir() != null) {
						containers.setWorkingDir(services.getWorking_dir());
					}

					if (services.getTmpfs() != null) {
						String[] data = services.getTmpfs();
						for (int i = 0; i < data.length; i++) {
							volumeMounts = new volumeMounts();
							String data1 = data[i];
							String hostpath = null;
							String conatinerPath = data1;
							String accessMode = null;
							if (data1.contains(":")) {
								String[] temp = data1.split(":");
								if (temp.length == 2) {
									hostpath = temp[0];
									conatinerPath = temp[1];
								}
								if (temp.length == 3) {
									hostpath = temp[0];
									conatinerPath = temp[1];
									accessMode = temp[2];
								}
							}
							String volmeMountname = "pvotmpfs_" + i;
							volumepojo volumepojo = new volumepojo();
							volumeMounts.setMountPath(conatinerPath);
							volumeMounts.setName(volmeMountname);
							if (accessMode != null && "ro".equals(accessMode)) {
								volumeMounts.setReadOnly(true);
								volumepojo.setAccessMode("ReadOnlyMany");
							} else {
								volumepojo.setAccessMode("ReadWriteOnce");
							}
							volumepojo.setName(volmeMountname);
							// volumepojo.setPath(hostpath);
							volumeMountsTmpfsList.add(volumepojo);
							volumeMountsList.add(volumeMounts);
							containers.setVolumeMounts(volumeMountsList);
						}

						if (volumeMountsTmpfsList.size() > 0) {
							for (Iterator iterator = volumeMountsTmpfsList.iterator(); iterator.hasNext();) {
								volumepojo volumepojo = (volumepojo) iterator.next();
								volumes volumes = new volumes();
								volumes.setName(volumepojo.getName());
								EmptyDirVolumeSource dirVolumeSource = new EmptyDirVolumeSource();
								dirVolumeSource.setMedium("Memory");
								volumes.setEmptyDir(dirVolumeSource);
								volumesList.add(volumes);
								if (volumesList.size() > 0) {
									spec.setVolumes(volumesList);
								}

							}
						}

					}

					if (services.getHealthcheck() != null) {
						healthcheck1 healthcheck = services.getHealthcheck();
						livenessProbe livenessProbe = new livenessProbe();
						if (healthcheck.getInterval() != null) {
							try {
								livenessProbe.setPeriodSeconds(Integer.valueOf(healthcheck.getInterval()));
							} catch (NumberFormatException e) {

							}
						}

						if (healthcheck.getTimeout() != null) {
							try {
								livenessProbe.setTimeoutSeconds(Integer.valueOf(healthcheck.getTimeout()));
							} catch (NumberFormatException e) {
							}
						}
						if (healthcheck.getTest() != null) {
							List<String> command = new ArrayList<>();
							Matcher m = Pattern.compile("([^\"]\\S*|\".+?\")\\s*").matcher(healthcheck.getTest());
							while (m.find())
								command.add(m.group(1));
							if (command.size() > 0) {
								ExecAction action = new ExecAction();
								action.setCommand(command);
								livenessProbe.setExec(action);
							}
							containers.setLivenessProbe(livenessProbe);

						}
					}

					if (services.getRestart() != null) {
						String temp = services.getRestart().trim();
						if ("on-failure".equalsIgnoreCase(temp) || "on-failure".equalsIgnoreCase(temp)) {
							spec.setRestartPolicy("OnFailure");
						} else if ("always".equalsIgnoreCase(temp)) {
							spec.setRestartPolicy("Always");
						} else if ("no".equalsIgnoreCase(temp)) {
							spec.setRestartPolicy("Never");
						} else {
							spec.setRestartPolicy("Always");
						}
					}

					// oVerride restart Policy from restart
					if (services.getDeploy() != null) {
						deploy deploy = services.getDeploy();
						Map<String, Object> deployMap = deploy.getRestart_policy();
						placement placement = deploy.getPlacement();
						replica = deploy.getReplicas();
						if (placement!=null && placement.getConstraints() != null) {
							String[] constraints = placement.getConstraints();
							Map<String, String> constraintsMap = new HashMap();
							for (int i = 0; i < constraints.length; i++) {
								// System.out.println(constraints[i]);
								String tmp[] = constraints[i].split("=");

								if (tmp.length == 2) {
									constraintsMap.put(tmp[0], tmp[1]);
									spec.setNodeSelector(constraintsMap);
								}
								if (tmp.length == 1) {
									constraintsMap.put(tmp[0], tmp[0]);
									spec.setNodeSelector(constraintsMap);
								}
							}
						}
						if (deployMap != null) {
							Iterator it = deployMap.entrySet().iterator();
							while (it.hasNext()) {
								Map.Entry pair = (Map.Entry) it.next();
								if (pair.getKey() != null && "condition".equals(pair.getKey())) {
									if (pair.getValue() != null) {
										String temp = pair.getValue().toString();
										if ("on_failure".equalsIgnoreCase(temp)
												|| "on-failure".equalsIgnoreCase(temp)) {
											spec.setRestartPolicy("OnFailure");
										} else if ("always".equalsIgnoreCase(temp)) {
											spec.setRestartPolicy("Always");
										} else if ("no".equalsIgnoreCase(temp)) {
											spec.setRestartPolicy("Never");
										} else {
											spec.setRestartPolicy("Always");
										}
									}
								}
							}
						}

					}

					if (services.getLinks() != null) {
						// What to DO
					}

					if (services.getPorts() != null) {
						String[] temp1 = services.getPorts();
						List<ports> portList = new ArrayList<>();
						for (int i = 0; i < temp1.length; i++) {
							String[] temp = temp1[i].split(":");
							String containerPort = null;
							String targetPort = null;
							if (temp.length == 1) {
								containerPort = temp[0];
							}
							if (temp.length == 2) {
								targetPort = temp[0];
								containerPort = temp[1];
							}

							servicepojo = new servicepojo();
							servicepojo.setContainerPort(containerPort);
							servicepojo.setTargetPort(targetPort);
							servicepojosList.add(servicepojo);

							ports ports = new ports();
							try {
								ports.setContainerPort(Integer.valueOf(containerPort));
								ports.setName("portname." + i);
								ports.setProtocol("tcp");
								portList.add(ports);
							} catch (NumberFormatException e) {

							}

						}

						containers.setPorts(portList);
					}

					if (services.getEnvironment() != null) {
						List<String> envMap = services.getEnvironment();
						List<env> envList = new ArrayList<>();
						for (Iterator iterator = envMap.iterator(); iterator.hasNext();) {
							String env2 = (String) iterator.next();
							env env = new env();
							String[] envArr = env2.split("=");
							if (envArr.length == 2) {
								env.setName(envArr[0].trim());
								env.setValue(envArr[1].trim().replace("'", ""));
							}
							if (envArr.length == 1) {
								env.setName(envArr[0].trim());
							}
							envList.add(env);

						}

						containers.setEnv(envList);
					}

					if (services.getImage() != null) {
						containers.setImage(services.getImage());
					}

					String svcName = "service.name." + new Random().nextInt(10);
					String value = "demo." + new Random().nextInt(100);
					if (servicepojosList.size() > 0) {
						List<String> portss = new ArrayList<>();
						for (Iterator iterator = servicepojosList.iterator(); iterator.hasNext();) {
							servicepojo string = (servicepojo) iterator.next();
							// System.out.println(string);
							String targetPort = string.getTargetPort();
							if (targetPort != null) {
								if (targetPort.contains("-")) {
									String temp[] = targetPort.split("-");
									if (temp.length == 2) {
										portss.add(temp[0]);
										portss.add(temp[1]);
									}
									if (temp.length == 1) {
										portss.add(temp[0]);
									}
								} else {
									portss.add(targetPort);
								}

							}
						}
						String serviceString = getSVC(svcName, getDummyLabel(value), portss);
						finalString.append("#This is Service Configuration Kube definition\n");
						finalString.append(serviceString);
						finalString.append("\n");
					}

					// Add Label

					metadata.setLabels(getDummyLabel(value));
					containersList.add(containers);
					spec.setContainers(containersList);
					pod.setSpec(spec);
					pod.setMetadata(metadata);

					Yaml yaml = getYaml();

					if (statefulGen) {
						StatefulSet statefulSet = new StatefulSet();
						metadata.setName("statefulset.name." + new Random().nextInt(100));
						statefulSet.setMetadata(metadata);
						StatefulSetSpec setSpec = new StatefulSetSpec();
						setSpec.setPodManagementPolicy("OrderedReady");
						setSpec.setReplicas(replica);
						template template = new template();
						metadata metadep = new metadata();
						metadep.setLabels(getDummyLabel(value));
						template.setMetadata(metadep);
						template.setSpec(spec);
						setSpec.setTemplate(template);
						selector selector = new selector();
						selector.setMatchLabels(getDummyLabel(value));
						setSpec.setSelector(selector);
						setSpec.setServiceName(svcName);

						List<PersistentVolumeClaimSpec> claimSpecs = new ArrayList<>();

						if (volumesList.size() > 0) {

							for (Iterator iterator = volumesList.iterator(); iterator.hasNext();) {
								volumes volName = (volumes) iterator.next();
								// System.out.println(volName);
								if (volName != null) {
									if (volName.getName() != null) {
										String pvName = volName.getName();

										if (volName.getPersistentVolumeClaim() != null) {
											if (volName.getPersistentVolumeClaim().getClaimName() != null) {

												String pvcName = volName.getPersistentVolumeClaim().getClaimName();
												PersistentVolumeClaimSpec pvc = getPVCObj(pvcName, pvName, null);
												claimSpecs.add(pvc);

											}
										}
									}
								}
							}
						}

						if (claimSpecs.size() > 0) {
							setSpec.setVolumeClaimTemplates(claimSpecs);
						}

						statefulSet.setSpec(setSpec);
						finalString.append("#This is StatefulSet Configuration Kube definition\n");
						finalString.append("---\n");
						String output = yaml.dump(statefulSet);
						// System.out.println(output);
						finalString.append(output);
						finalString.append("\n");

					}

					if (podGen) {
						finalString.append("#This is Pod Configuration Kube definition\n");
						finalString.append("---\n");
						String output = yaml.dump(pod);
						// System.out.println(output);
						finalString.append(output);
					}

					if (repliGen) {
						Replication replication = new Replication();
						metadata metadep = new metadata();
						metadata.setName("replication.name." + new Random().nextInt(100));
						replication.setMetadata(metadata);
						ReplicationControllerSpec controllerSpec = new ReplicationControllerSpec();
						selector selector = new selector();
						selector.setMatchLabels(getDummyLabel(value));
						template template = new template();
						metadep = new metadata();
						metadep.setLabels(getDummyLabel(value));
						template.setMetadata(metadep);
						controllerSpec.setSelector(selector);
						template.setSpec(spec);
						controllerSpec.setTemplate(template);
						controllerSpec.setReplicas(replica);
						replication.setSpec(controllerSpec);
						String output = yaml.dump(replication);
						finalString.append("\n#This is Replication Configuration Kube definition\n");
						finalString.append("---\n");
						finalString.append(output);

					}
					if (deployGen) {
						Deployment deployment = new Deployment();
						metadata metadep = new metadata();
						metadata.setName("deployment.name." + new Random().nextInt(100));
						deployment.setMetadata(metadata);
						z.y.x.kube.deployment.spec specd = new z.y.x.kube.deployment.spec();
						selector selector = new selector();
						selector.setMatchLabels(getDummyLabel(value));
						template template = new template();
						metadep = new metadata();
						metadep.setLabels(getDummyLabel(value));
						template.setMetadata(metadep);
						specd.setSelector(selector);
						template.setSpec(spec);
						specd.setTemplate(template);
						specd.setReplicas(replica);
						deployment.setSpec(specd);
						String output = yaml.dump(deployment);
						finalString.append("\n#This is Deployment Configuration Kube definition\n");
						finalString.append("---\n");
						finalString.append(output);
					}

					if (volumepojoList.size() > 0) {
						int i = 0;
						for (Iterator iterator = volumepojoList.iterator(); iterator.hasNext();) {
							volumepojo volumepojo2 = (volumepojo) iterator.next();
							// System.out.println(volumepojo2);
							List<String> accessModeList = new ArrayList<>();
							accessModeList.add(volumepojo2.getAccessMode());
							String pv = getPV(volumepojo2.getName(), accessModeList, volumepojo2.getPath());
							finalString.append("\n");
							finalString.append("#This is PersistentVolume Kube Object with Name\n");
							finalString.append("#" + volumepojo2.getName() + ".yml\n");
							finalString.append(pv);
						}
					}

					if (volumesList.size() > 0 && !statefulGen) {
						for (Iterator iterator = volumesList.iterator(); iterator.hasNext();) {
							volumes volName = (volumes) iterator.next();
							// System.out.println(volName);

							if (volName != null) {
								if (volName.getName() != null) {
									String pvName = volName.getName();

									if (volName.getPersistentVolumeClaim() != null) {
										if (volName.getPersistentVolumeClaim().getClaimName() != null) {
											String pvcName = volName.getPersistentVolumeClaim().getClaimName();
											String pvc = getPVC(pvcName, pvName, null);
											finalString.append("\n");
											finalString
													.append("#This is PersistentVolumeClaim Kube Object with Name\n");
											finalString.append("#" + pvcName + ".yml\n");
											finalString.append(pvc);
										}
									}
								}
							}
						}
					}

					if (configMapFileNameList.size() > 0) {
						for (Iterator iterator = configMapFileNameList.iterator(); iterator.hasNext();) {
							String string = (String) iterator.next();
							finalString.append("\n");
							finalString.append("# Additional Config Map Needs to be created\n");
							finalString.append(string);
							// System.out.println(string);
						}
					}

				}

			}

			//System.out.println(finalString.toString());
		}

		if (obj instanceof DockerCompose) {
			

			DockerCompose compose = (DockerCompose) obj;
			if (compose != null && compose.getServices() != null) {
				Map<String, services> servicesMap = compose.getServices();

				int size = servicesMap.entrySet().size();
				finalString.append("#Generated using the tool https://8gwifi.org/kube1.jsp\n");
				finalString.append("#Total Number of Services Found " + size + "\n");

				for (Map.Entry<String, services> entry : servicesMap.entrySet()) {
					String key = entry.getKey();

					finalString.append("\n#Generating kubernetes YAML file for the Service " + key + ".yml\n");

					containersList = new ArrayList<>();
					volumeMountsList = new ArrayList<>();
					volumeMountsTmpfsList = new ArrayList<>();
					volumesList = new ArrayList<>();
					volumepojoList = new ArrayList<>();
					servicepojosList = new ArrayList<>();
					configMapFileNameList = new ArrayList<>();

					services services = entry.getValue();
					containers = new containers();
					pod = new Pod();
					spec = new spec();
					resources = new resources();
					limits = new limits();
					requests = new requests();
					securityContext = new securityContext();
					dnsConfig = new dnsConfig();
					metadata = new metadata();
					capabilities = new capabilities();

					int replica = 1;

					metadata.setNamespace(defualt);

					if (services.isPrivileged()) {
						securityContext.setPrivileged(true);
						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}

					}
					if (services.isTty()) {
						containers.setTty(true);
					}
					if (services.isStdin_open()) {
						containers.setStdin(true);
					}

					if (services.isInit()) {
						// Check This
					}

					if (services.getCgroup_parent() != null) {
						// Check This
					}
					if (services.getLogging() != null) {
						// Check This
					}
					if (services.getVolumes() != null) {
						String[] data = services.getVolumes();
						for (int i = 0; i < data.length; i++) {
							volumeMounts = new volumeMounts();
							String data1 = data[i];
							String hostpath = null;
							String conatinerPath = data1;
							String accessMode = null;
							if (data1.contains(":")) {
								String[] temp = data1.split(":");
								if (temp.length == 2) {
									hostpath = temp[0];
									conatinerPath = temp[1];
								}
								if (temp.length == 3) {
									hostpath = temp[0];
									conatinerPath = temp[1];
									accessMode = temp[2];
								}
							}
							String volmeMountname = "pvo." + i;
							volumepojo volumepojo = new volumepojo();
							volumeMounts.setMountPath(conatinerPath);
							volumeMounts.setName(volmeMountname);
							if (accessMode != null && "ro".equals(accessMode)) {
								volumeMounts.setReadOnly(true);
								volumepojo.setAccessMode("ReadOnlyMany");
							} else {
								volumepojo.setAccessMode("ReadWriteOnce");
							}
							if (hostpath != null && hostpath.trim().length() > 0) {
								volumepojo.setName(volmeMountname);
								volumepojo.setPath(hostpath);
								volumepojoList.add(volumepojo);
							}
							volumeMountsList.add(volumeMounts);
						}

						containers.setVolumeMounts(volumeMountsList);

						if (volumepojoList.size() > 0) {
							int i = 0;
							for (Iterator iterator = volumepojoList.iterator(); iterator.hasNext();) {
								volumepojo volumepojo2 = (volumepojo) iterator.next();
								volumes volumes = new volumes();
								PersistentVolumeClaimVolumeSource persistentVolumeClaim = new PersistentVolumeClaimVolumeSource();
								volumes.setName(volumepojo2.getName());
								persistentVolumeClaim.setClaimName("claimname." + i);
								volumes.setPersistentVolumeClaim(persistentVolumeClaim);
								volumesList.add(volumes);
								spec.setVolumes(volumesList);
								i++;
							}
						}
					}

					if (services.getUlimits() != null) {
						// Cant Do Anything
					}

					if (services.getPid() != null) {
						String pid = services.getPid().trim();
						if ("host".equalsIgnoreCase(pid)) {
							spec.setHostPID(true);
						}
					}

					if (services.getContainer_name() != null) {
						containers.setName(services.getContainer_name());
					}

					if (services.getCpus() != 0.0) {
						// What to Do
						// System.out.println("CPU- " + services.getCpus());
					}

					if (services.getCpu_shares() != 0) {
						requests.setCpu(String.valueOf(services.getCpu_shares()));
						resources.setRequests(requests);
						containers.setResources(resources);
					}

					if (services.getCpu_quota() != 0) {
						// What to Do
					}

					if (services.getCpu_period() != null) {
						// What to do
					}

					if (services.getCpuset() != null) {
						// What to do
					}
					if (services.getMem_limit() != null) {
						requests.setMemory(services.getMem_limit());
						resources.setRequests(requests);
						containers.setResources(resources);
					}

					if (services.getMemswap_limit() != null) {
						// What to do
					}
					if (services.getMem_reservation() != null) {
						limits.setMemory(services.getMem_reservation());
					}
					if (services.getOom_score_adj() != 0) {
						// What to do
					}
					if (services.getShm_size() != null) {
						// What to do
					}

					if (services.getSysctls() != null) {
						securityContext.setSysctls(mapToList(services.getSysctls()));
						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}
					}
					if (services.getDns() != null) {

						dnsConfig.setNameservers(services.getDns());
						spec.setDnsConfig(dnsConfig);
					}
					if (services.getDns_search() != null) {
						dnsConfig.setSearches(services.getDns_search());
						spec.setDnsConfig(dnsConfig);
					}
					if (services.getDns_option() != null) {
						z.y.x.kube.options options = null;
						List<options> optionsList = new ArrayList<>();
						String[] data = services.getDns_option();
						for (int i = 0; i < data.length; i++) {
							options = new z.y.x.kube.options();
							String temp[] = data[i].split("=");
							if (temp.length == 2) {
								options.setName(temp[0]);
								options.setValue(temp[1]);
							}
							if (temp.length == 1) {
								options.setName(temp[0]);
							}
							optionsList.add(options);
						}

						if (optionsList.size() > 0) {
							dnsConfig.setOptions(optionsList);
							spec.setDnsConfig(dnsConfig);
						}

					}

					if (services.getDomainname() != null) {
						spec.setSubdomain(services.getDomainname());
					}

					if (services.getUser() != null) {

						int runAsUser = 1000;
						try {
							runAsUser = Integer.valueOf(services.getUser());
						} catch (NumberFormatException e) {
							runAsUser = 1000;
						}
						securityContext.setRunAsUser(runAsUser);
						securityContext.setRunAsGroup(runAsUser);
						if (runAsUser == 0) {
							securityContext.setAllowPrivilegeEscalation(true);
						}

						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}
					}

					if (services.getHostname() != null) {
						spec.setHostname(services.getHostname());
					}

					if (services.getStop_signal() != null) {
						spec.setTerminationGracePeriodSeconds(30);
					}

					if (services.getEntrypoint() != null) {
						ArrayList<String> entrylist = new ArrayList<String>(Arrays.asList(services.getEntrypoint()));
						containers.setCommand(entrylist);
					}

					if (services.getExtra_hosts() != null) {
						// System.out.println("Extra Hosts");
						String[] data = services.getExtra_hosts();
						List<HostAlias> hostaliasesList = new ArrayList<>();
						for (int i = 0; i < data.length; i++) {
							String temp[] = data[i].split(":");
							if (temp.length == 2) {
								HostAlias hostaliases = new HostAlias();
								List<String> hostname = new ArrayList<String>();
								hostname.add(temp[0]);
								hostaliases.setHostnames(hostname);
								hostaliases.setIp(temp[1]);
								hostaliasesList.add(hostaliases);
							}
						}

						if (hostaliasesList.size() > 0) {
							spec.setHostAliases(hostaliasesList);
						}
					}

					if (services.getEnv_file() != null) {
						EnvFromSource envFromSource = new EnvFromSource();
						ConfigMapEnvSource configMapEnvSource = new ConfigMapEnvSource();
						String filename = "env_file_from_configmap_" + new Random().nextInt(10);
						configMapEnvSource.setName(filename);
						envFromSource.setConfigMapRef(configMapEnvSource);
						containers.setEnvFrom(envFromSource);
						StringBuilder builder = new StringBuilder();
						for (int i = 0; i < services.getEnv_file().length; i++) {
							builder.append(" ");
							builder.append("--from-file=");
							builder.append(services.getEnv_file()[i]);
						}
						String kubeCommand = "# kubectl create configmap " + filename + " " + builder.toString();
						configMapFileNameList.add(kubeCommand);
					}

					if (services.getLabels() != null) {
						List<String> labelList = mapToList(services.getLabels());
						labelList.add("generated.by=8gwifi.org");
						Map<String, String> annotanationMap = services.getLabels();
						annotanationMap.put("generated.by", "8gwifi.org");
						metadata.setAnnotations(annotanationMap);

					}

					if (services.getDevices() != null) {
						List<VolumeDevice> volumedeviceList = new ArrayList<>();
						VolumeDevice volumeDevice;
						String[] data = services.getDevices();
						for (int i = 0; i < data.length; i++) {
							volumeDevice = new VolumeDevice();
							String data1 = data[i];
							String hostpath = null;
							String conatinerPath = data1;
							String accessMode = null;
							if (data1.contains(":")) {
								String[] temp = data1.split(":");
								if (temp.length == 2) {
									hostpath = temp[0];
									conatinerPath = temp[1];
								}
								if (temp.length == 3) {
									hostpath = temp[0];
									conatinerPath = temp[1];
									accessMode = temp[2];
								}
							}
							String volmeMountname = "mydevice" + i;
							volumeDevice.setDevicePath(conatinerPath);
							volumeDevice.setName(volmeMountname);
							volumedeviceList.add(volumeDevice);
						}

						if (volumedeviceList.size() > 0) {
							containers.setVolumeDevices(volumedeviceList);
							securityContext.setPrivileged(true);
							if (!addSecurityContextToPod) {
								containers.setSecurityContext(securityContext);
							} else {
								spec.setSecurityContext(securityContext);
							}

							for (Iterator iterator = volumedeviceList.iterator(); iterator.hasNext();) {
								VolumeDevice volumeDevice2 = (VolumeDevice) iterator.next();
								volumes volumes = new volumes();
								hostPath hostPath = new hostPath();
								hostPath.setPath(volumeDevice2.getDevicePath());
								hostPath.setType(null);
								volumes.setHostPath(hostPath);
								volumes.setName(volumeDevice2.getName());
								volumesList.add(volumes);
							}
							if (volumesList.size() > 0) {
								spec.setVolumes(volumesList);
							}

						}

					}

					if (services.getMac_address() != null) {
						// What To DO
					}

					if (services.getCap_add() != null) {
						capabilities.setAdd(arrayToArrayList(services.getCap_add()));
						securityContext.setCapabilities(capabilities);
						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}
					}

					if (services.getCap_drop() != null) {
						capabilities.setDrop(arrayToArrayList(services.getCap_drop()));
						securityContext.setCapabilities(capabilities);
						if (!addSecurityContextToPod) {
							containers.setSecurityContext(securityContext);
						} else {
							spec.setSecurityContext(securityContext);
						}
					}

					if (services.getSecurity_opt() != null) {
						String[] data = services.getSecurity_opt();
						SELinuxOptions linuxOptions = new SELinuxOptions();
						for (int i = 0; i < data.length; i++) {
							// System.out.println(data[i].indexOf("label:"));
							int isExist = data[i].indexOf("label:");

							if (isExist < 0) {
								isExist = data[i].indexOf("label=");
							}

							// System.out.println(isExist);

							if (isExist == 0) {
								String temp = data[i].substring(6, data[i].length());
								// System.out.println(temp);

								if (temp.indexOf("level:") == 0) {
									linuxOptions.setLevel(temp.substring(6, temp.length()));
								}
								if (temp.indexOf("type:") == 0) {
									linuxOptions.setType(temp.substring(5, temp.length()));
								}
								if (temp.indexOf("user:") == 0) {
									linuxOptions.setUser(temp.substring(5, temp.length()));
								}

								if (temp.indexOf("role:") == 0) {
									linuxOptions.setRole(temp.substring(5, temp.length()));
								}
								securityContext.setSeLinuxOptions(linuxOptions);

								if (!addSecurityContextToPod) {
									containers.setSecurityContext(securityContext);
								} else {
									spec.setSecurityContext(securityContext);
								}

							}

						}
					}

					if (services.getWorking_dir() != null) {
						containers.setWorkingDir(services.getWorking_dir());
					}

					if (services.getTmpfs() != null) {
						String[] data = services.getTmpfs();
						for (int i = 0; i < data.length; i++) {
							volumeMounts = new volumeMounts();
							String data1 = data[i];
							String hostpath = null;
							String conatinerPath = data1;
							String accessMode = null;
							if (data1.contains(":")) {
								String[] temp = data1.split(":");
								if (temp.length == 2) {
									hostpath = temp[0];
									conatinerPath = temp[1];
								}
								if (temp.length == 3) {
									hostpath = temp[0];
									conatinerPath = temp[1];
									accessMode = temp[2];
								}
							}
							String volmeMountname = "pvotmpfs_" + i;
							volumepojo volumepojo = new volumepojo();
							volumeMounts.setMountPath(conatinerPath);
							volumeMounts.setName(volmeMountname);
							if (accessMode != null && "ro".equals(accessMode)) {
								volumeMounts.setReadOnly(true);
								volumepojo.setAccessMode("ReadOnlyMany");
							} else {
								volumepojo.setAccessMode("ReadWriteOnce");
							}
							volumepojo.setName(volmeMountname);
							// volumepojo.setPath(hostpath);
							volumeMountsTmpfsList.add(volumepojo);
							volumeMountsList.add(volumeMounts);
							containers.setVolumeMounts(volumeMountsList);
						}

						if (volumeMountsTmpfsList.size() > 0) {
							for (Iterator iterator = volumeMountsTmpfsList.iterator(); iterator.hasNext();) {
								volumepojo volumepojo = (volumepojo) iterator.next();
								volumes volumes = new volumes();
								volumes.setName(volumepojo.getName());
								EmptyDirVolumeSource dirVolumeSource = new EmptyDirVolumeSource();
								dirVolumeSource.setMedium("Memory");
								volumes.setEmptyDir(dirVolumeSource);
								volumesList.add(volumes);
								if (volumesList.size() > 0) {
									spec.setVolumes(volumesList);
								}

							}
						}

					}

					if (services.getHealthcheck() != null) {
						healthcheck healthcheck = services.getHealthcheck();
						livenessProbe livenessProbe = new livenessProbe();
						if (healthcheck.getInterval() != null) {
							try {
								livenessProbe.setPeriodSeconds(Integer.valueOf(healthcheck.getInterval()));
							} catch (NumberFormatException e) {

							}
						}

						if (healthcheck.getTimeout() != null) {
							try {
								livenessProbe.setTimeoutSeconds(Integer.valueOf(healthcheck.getTimeout()));
							} catch (NumberFormatException e) {
							}
						}
						if (healthcheck.getTest() != null) {
							List<String> command = new ArrayList<>();
							Matcher m = Pattern.compile("([^\"]\\S*|\".+?\")\\s*").matcher(healthcheck.getTest()[0]);
							while (m.find())
								command.add(m.group(1));
							if (command.size() > 0) {
								ExecAction action = new ExecAction();
								action.setCommand(command);
								livenessProbe.setExec(action);
							}
							containers.setLivenessProbe(livenessProbe);

						}
					}

//					if (services.getRestart() != null) {
//						String temp = services.getRestart().trim();
//						if ("on-failure".equalsIgnoreCase(temp) || "on-failure".equalsIgnoreCase(temp)) {
//							spec.setRestartPolicy("OnFailure");
//						} else if ("always".equalsIgnoreCase(temp)) {
//							spec.setRestartPolicy("Always");
//						} else if ("no".equalsIgnoreCase(temp)) {
//							spec.setRestartPolicy("Never");
//						} else {
//							spec.setRestartPolicy("Always");
//						}
//					}

					// oVerride restart Policy from restart
					if (services.getDeploy() != null) {
						deploy deploy = services.getDeploy();
						Map<String, Object> deployMap = deploy.getRestart_policy();
						placement placement = deploy.getPlacement();
						replica = deploy.getReplicas();
						if ( placement!=null && placement.getConstraints() != null) {
							String[] constraints = placement.getConstraints();
							Map<String, String> constraintsMap = new HashMap();
							for (int i = 0; i < constraints.length; i++) {
								// System.out.println(constraints[i]);
								String tmp[] = constraints[i].split("=");

								if (tmp.length == 2) {
									constraintsMap.put(tmp[0], tmp[1]);
									spec.setNodeSelector(constraintsMap);
								}
								if (tmp.length == 1) {
									constraintsMap.put(tmp[0], tmp[0]);
									spec.setNodeSelector(constraintsMap);
								}
							}
						}
						if (deployMap != null) {
							Iterator it = deployMap.entrySet().iterator();
							while (it.hasNext()) {
								Map.Entry pair = (Map.Entry) it.next();
								if (pair.getKey() != null && "condition".equals(pair.getKey())) {
									if (pair.getValue() != null) {
										String temp = pair.getValue().toString();
										if ("on_failure".equalsIgnoreCase(temp)
												|| "on-failure".equalsIgnoreCase(temp)) {
											spec.setRestartPolicy("OnFailure");
										} else if ("always".equalsIgnoreCase(temp)) {
											spec.setRestartPolicy("Always");
										} else if ("no".equalsIgnoreCase(temp)) {
											spec.setRestartPolicy("Never");
										} else {
											spec.setRestartPolicy("Always");
										}
									}
								}
							}
						}

					}

					if (services.getLinks() != null) {
						// What to DO
					}

					if (services.getPorts() != null) {
						String[] temp1 = services.getPorts();
						List<ports> portList = new ArrayList<>();
						for (int i = 0; i < temp1.length; i++) {
							String[] temp = temp1[i].split(":");
							String containerPort = null;
							String targetPort = null;
							if (temp.length == 1) {
								containerPort = temp[0];
							}
							if (temp.length == 2) {
								targetPort = temp[0];
								containerPort = temp[1];
							}

							servicepojo = new servicepojo();
							servicepojo.setContainerPort(containerPort);
							servicepojo.setTargetPort(targetPort);
							servicepojosList.add(servicepojo);

							ports ports = new ports();
							try {
								ports.setContainerPort(Integer.valueOf(containerPort));
								ports.setName("portname." + i);
								ports.setProtocol("tcp");
								portList.add(ports);
							} catch (NumberFormatException e) {

							}

						}

						containers.setPorts(portList);
					}

					if (services.getEnvironment() != null) {
						List<String> envMap = mapToList(services.getEnvironment());
						List<env> envList = new ArrayList<>();
						for (Iterator iterator = envMap.iterator(); iterator.hasNext();) {
							String env2 = (String) iterator.next();
							env env = new env();
							String[] envArr = env2.split("=");
							if (envArr.length == 2) {
								env.setName(envArr[0].trim());
								env.setValue(envArr[1].trim().replace("'", ""));
							}
							if (envArr.length == 1) {
								env.setName(envArr[0].trim());
							}
							envList.add(env);

						}

						containers.setEnv(envList);
					}

					if (services.getImage() != null) {
						containers.setImage(services.getImage());
					}

					String svcName = "service.name." + new Random().nextInt(10);
					String value = "demo." + new Random().nextInt(100);
					if (servicepojosList.size() > 0) {
						List<String> portss = new ArrayList<>();
						for (Iterator iterator = servicepojosList.iterator(); iterator.hasNext();) {
							servicepojo string = (servicepojo) iterator.next();
							// System.out.println(string);
							String targetPort = string.getTargetPort();
							if (targetPort != null) {
								if (targetPort.contains("-")) {
									String temp[] = targetPort.split("-");
									if (temp.length == 2) {
										portss.add(temp[0]);
										portss.add(temp[1]);
									}
									if (temp.length == 1) {
										portss.add(temp[0]);
									}
								} else {
									portss.add(targetPort);
								}

							}
						}
						String serviceString = getSVC(svcName, getDummyLabel(value), portss);
						finalString.append("#This is Service Configuration Kube definition\n");
						finalString.append(serviceString);
						finalString.append("\n");
					}

					// Add Label

					metadata.setLabels(getDummyLabel(value));
					containersList.add(containers);
					spec.setContainers(containersList);
					pod.setSpec(spec);
					pod.setMetadata(metadata);

					Yaml yaml = getYaml();

					if (statefulGen) {
						StatefulSet statefulSet = new StatefulSet();
						metadata.setName("statefulset.name." + new Random().nextInt(100));
						statefulSet.setMetadata(metadata);
						StatefulSetSpec setSpec = new StatefulSetSpec();
						setSpec.setPodManagementPolicy("OrderedReady");
						setSpec.setReplicas(replica);

						template template = new template();
						metadata metadep = new metadata();
						metadep.setLabels(getDummyLabel(value));
						template.setMetadata(metadep);
						template.setSpec(spec);
						setSpec.setTemplate(template);
						selector selector = new selector();
						selector.setMatchLabels(getDummyLabel(value));
						setSpec.setSelector(selector);
						setSpec.setServiceName(svcName);

						List<PersistentVolumeClaimSpec> claimSpecs = new ArrayList<>();

						if (volumesList.size() > 0) {

							for (Iterator iterator = volumesList.iterator(); iterator.hasNext();) {
								volumes volName = (volumes) iterator.next();
								// System.out.println(volName);
								if (volName != null) {
									if (volName.getName() != null) {
										String pvName = volName.getName();

										if (volName.getPersistentVolumeClaim() != null) {
											if (volName.getPersistentVolumeClaim().getClaimName() != null) {

												String pvcName = volName.getPersistentVolumeClaim().getClaimName();
												PersistentVolumeClaimSpec pvc = getPVCObj(pvcName, pvName, null);
												claimSpecs.add(pvc);

											}
										}
									}
								}
							}
						}

						if (claimSpecs.size() > 0) {
							setSpec.setVolumeClaimTemplates(claimSpecs);
						}

						statefulSet.setSpec(setSpec);
						finalString.append("#This is StatefulSet Configuration Kube definition\n");
						finalString.append("---\n");
						String output = yaml.dump(statefulSet);
						// System.out.println(output);
						finalString.append(output);
						finalString.append("\n");

					}

					if (podGen) {
						finalString.append("#This is Pod Configuration Kube definition\n");
						finalString.append("---\n");
						String output = yaml.dump(pod);
						// System.out.println(output);
						finalString.append(output);
					}

					if (repliGen) {
						Replication replication = new Replication();
						metadata metadep = new metadata();
						metadata.setName("replication.name." + new Random().nextInt(100));
						replication.setMetadata(metadata);
						ReplicationControllerSpec controllerSpec = new ReplicationControllerSpec();
						selector selector = new selector();
						selector.setMatchLabels(getDummyLabel(value));
						template template = new template();
						metadep = new metadata();
						metadep.setLabels(getDummyLabel(value));
						template.setMetadata(metadep);
						controllerSpec.setSelector(selector);
						template.setSpec(spec);
						controllerSpec.setTemplate(template);
						controllerSpec.setReplicas(replica);
						replication.setSpec(controllerSpec);
						String output = yaml.dump(replication);
						finalString.append("\n#This is Replication Configuration Kube definition\n");
						finalString.append("---\n");
						finalString.append(output);

					}
					if (deployGen) {
						Deployment deployment = new Deployment();
						metadata metadep = new metadata();
						metadata.setName("deployment.name." + new Random().nextInt(100));
						deployment.setMetadata(metadata);
						z.y.x.kube.deployment.spec specd = new z.y.x.kube.deployment.spec();
						selector selector = new selector();
						selector.setMatchLabels(getDummyLabel(value));
						template template = new template();
						metadep = new metadata();
						metadep.setLabels(getDummyLabel(value));
						template.setMetadata(metadep);
						specd.setSelector(selector);
						template.setSpec(spec);
						specd.setTemplate(template);
						specd.setReplicas(replica);
						deployment.setSpec(specd);
						String output = yaml.dump(deployment);
						finalString.append("\n#This is Deployment Configuration Kube definition\n");
						finalString.append("---\n");
						finalString.append(output);
					}

					if (volumepojoList.size() > 0) {
						int i = 0;
						for (Iterator iterator = volumepojoList.iterator(); iterator.hasNext();) {
							volumepojo volumepojo2 = (volumepojo) iterator.next();
							// System.out.println(volumepojo2);
							List<String> accessModeList = new ArrayList<>();
							accessModeList.add(volumepojo2.getAccessMode());
							String pv = getPV(volumepojo2.getName(), accessModeList, volumepojo2.getPath());
							finalString.append("\n");
							finalString.append("#This is PersistentVolume Kube Object with Name\n");
							finalString.append("#" + volumepojo2.getName() + ".yml\n");
							finalString.append(pv);
						}
					}

					if (volumesList.size() > 0 && !statefulGen) {
						for (Iterator iterator = volumesList.iterator(); iterator.hasNext();) {
							volumes volName = (volumes) iterator.next();
							// System.out.println(volName);

							if (volName != null) {
								if (volName.getName() != null) {
									String pvName = volName.getName();

									if (volName.getPersistentVolumeClaim() != null) {
										if (volName.getPersistentVolumeClaim().getClaimName() != null) {
											String pvcName = volName.getPersistentVolumeClaim().getClaimName();
											String pvc = getPVC(pvcName, pvName, null);
											finalString.append("\n");
											finalString
													.append("#This is PersistentVolumeClaim Kube Object with Name\n");
											finalString.append("#" + pvcName + ".yml\n");
											finalString.append(pvc);
										}
									}
								}
							}
						}
					}

					if (configMapFileNameList.size() > 0) {
						for (Iterator iterator = configMapFileNameList.iterator(); iterator.hasNext();) {
							String string = (String) iterator.next();
							finalString.append("\n");
							finalString.append("# Additional Config Map Needs to be created\n");
							finalString.append(string);
							// System.out.println(string);
						}
					}

				}

			}

			//System.out.println(finalString.toString());
		
			
		}

		return finalString.toString();

	}

	public String getSVC(String svcName, Map<String, String> selector, List<String> ports) {
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("---");
		stringBuilder.append("\n");

		Service rv = new Service();
		z.y.x.kube.service.spec srvspec = new z.y.x.kube.service.spec();
		List<z.y.x.kube.service.ports> srvportsList = new ArrayList<>();

		metadata metadata = new metadata();
		metadata.setName(svcName);
		metadata.setNamespace(defualt);
		Map<String, String> annotationMap = new HashMap<>();
		annotationMap.put("generated.by", "8gwifi.org");
		metadata.setAnnotations(annotationMap);

		rv.setMetadata(metadata);

		if (ports != null) {
			int i = 0;
			for (Iterator iterator = ports.iterator(); iterator.hasNext();) {
				String port = (String) iterator.next();
				if (port != null && port.trim().length() > 0) {
					String targetPort = port;
					if (port.contains(":")) {
						String[] temp = port.split(":");
						if (temp.length == 2) {
							port = temp[0];
							targetPort = temp[1];
						}
					}
					z.y.x.kube.service.ports srvports = new z.y.x.kube.service.ports();
					try {
						srvports.setPort(Integer.valueOf(port));
						srvports.setTargetPort(Integer.valueOf(targetPort));
						srvports.setProtocol("tcp");
						if ("80".equals(port) || "8080".equals(port)) {
							srvports.setName("http");
						} else if ("443".equals(port) || "443".equals(port)) {
							srvports.setName("https");
						} else {
							srvports.setName("nameme_" + i + 1);
						}
						i++;
						srvportsList.add(srvports);
					} catch (NumberFormatException e) {
						// System.err.println(port);
					}
				}
			}

			srvspec.setPorts(srvportsList);

		}

		if (selector != null) {
			srvspec.setSelector(selector);

		}

		srvspec.setSessionAffinity(null);

		rv.setSpec(srvspec);

		Yaml yaml = getYaml();
		String output = yaml.dump(rv);
		stringBuilder.append(output);
		return stringBuilder.toString();

	}

	public String getPV(String pvName, List<String> accessModes, String path) {
		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("---");
		stringBuilder.append("\n");

		DumperOptions options = new DumperOptions();
		options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
		// options.set
		options.setPrettyFlow(true);

		PersistentVolume pv = new PersistentVolume();
		PersistentVolumeSpec pvs = new PersistentVolumeSpec();

		metadata metadata = new metadata();
		Map<String, String> annotationMap = new HashMap<>();
		annotationMap.put("generated.by", "8gwifi.org");
		metadata.setName(pvName);
		metadata.setNamespace(defualt);
		metadata.setAnnotations(annotationMap);

		pv.setMetadata(metadata);

		pvs.setPersistentVolumeReclaimPolicy("Retain");

		pvs.setStorageClassName("");

		capacity capacity = new capacity();
		capacity.setStorage("10Gi");

		pvs.setCapacity(capacity);

		if (null == accessModes || accessModes.size() == 0) {
			accessModes = new ArrayList<>();
			accessModes.add("ReadWriteOnce");
			accessModes.add("ReadOnlyMany");
		}

		pvs.setAccessModes(accessModes);

		hostPath hostPath = new hostPath();
		hostPath.setPath(path);
		pvs.setHostPath(hostPath);

		pv.setSpec(pvs);
		Yaml yaml = getYaml();
		String output = yaml.dump(pv);
		stringBuilder.append(output);
		return stringBuilder.toString();

	}

	public PersistentVolumeClaimSpec getPVCObj(String pvcName, String pvName, List<String> accessModes) {

		PersistentVolumeClaimSpec spec = new PersistentVolumeClaimSpec();
		if (null == accessModes || accessModes.size() == 0) {
			accessModes = new ArrayList<>();
			accessModes.add("ReadWriteOnce");
		}
		// list.add("ReadOnlyMany");
		// list.add("ReadWriteMany");

		spec.setAccessModes(accessModes);
		spec.setVolumeName(pvName);
		requests requests = new requests();
		requests.setStorage("1Gi");
		resources resources = new resources();
		resources.setRequests(requests);
		spec.setResources(resources);
		return spec;

	}

	public String getPVC(String pvcName, String pvName, List<String> accessModes) {

		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append("---");
		stringBuilder.append("\n");

		PersistentVolumeClaimSpec spec = new PersistentVolumeClaimSpec();
		PersistentVolumeClaim pvc = new PersistentVolumeClaim();

		Map<String, String> annotationMap = new HashMap<>();
		annotationMap.put("generated.by", "8gwifi.org");
		metadata metadata = new metadata();
		metadata.setAnnotations(annotationMap);
		metadata.setName(pvcName);
		metadata.setNamespace(defualt);

		pvc.setMetadata(metadata);

		if (null == accessModes || accessModes.size() == 0) {
			accessModes = new ArrayList<>();
			accessModes.add("ReadWriteOnce");
		}
		// list.add("ReadOnlyMany");
		// list.add("ReadWriteMany");

		spec.setAccessModes(accessModes);
		spec.setVolumeName(pvName);

		requests requests = new requests();
		requests.setStorage("1Gi");
		resources resources = new resources();
		resources.setRequests(requests);

		spec.setResources(resources);

		pvc.setSpec(spec);

		Yaml yaml = getYaml();
		String output = yaml.dump(pvc);
		stringBuilder.append(output);
		return stringBuilder.toString();

	}

	public Yaml getYaml() {
		Representer representer = new Representer() {
			@Override
			protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue,
					Tag customTag) {
				// if value of property is null, ignore it.

				// System.out.println(property.getName());

				if (propertyValue == null || propertyValue == "") {
					return null;
				}

				else if ("nodePort".equals(property.getName()) || "healthCheckNodePort".equals(property.getName())
						|| "runAsGroup".equals(property.getName()) || "runAsUser".equals(property.getName())
						|| "priority".equals(property.getName()) || "fsGroup".equals(property.getName())
						|| "activeDeadlineSeconds".equals(property.getName())
						|| "minReadySeconds".equals(property.getName())) {
					if (propertyValue != null) {
						if (0 == Integer.parseInt(propertyValue.toString())) {
							return null;
						}
					}
					return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
				} else if ("readOnly".equals(property.getName())
						|| "publishNotReadyAddresses".equals(property.getName())
						|| "allowPrivilegeEscalation".equals(property.getName())
						|| "privileged".equals(property.getName()) || "runAsNonRoot".equals(property.getName())
						|| "stdin".equals(property.getName()) || "stdinOnce".equals(property.getName())
						|| "tty".equals(property.getName()) || "stdin".equals(property.getName())
						|| "enableServiceLinks".equals(property.getName()) || "hostIPC".equals(property.getName())
						|| "hostNetwork".equals(property.getName()) || "hostPID".equals(property.getName())
						|| "allowPrivilegeEscalation".equals(property.getName())
						|| "readOnlyRootFilesystem".equals(property.getName())
						|| "automountServiceAccountToken".equals(property.getName())
						|| "optional".equals(property.getName())) {
					if (propertyValue != null) {
						if (!Boolean.valueOf(propertyValue.toString())) {
							return null;
						}
					}
					return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
				}

				else {
					return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
				}
			}
		};

		representer.addClassTag(PersistentVolumeClaim.class, Tag.MAP);
		representer.addClassTag(PersistentVolume.class, Tag.MAP);
		representer.addClassTag(z.y.x.kube.service.Service.class, Tag.MAP);
		representer.addClassTag(Pod.class, Tag.MAP);
		representer.addClassTag(Deployment.class, Tag.MAP);
		representer.addClassTag(Replication.class, Tag.MAP);
		representer.addClassTag(StatefulSet.class, Tag.MAP);
		representer.getPropertyUtils().setSkipMissingProperties(true);
		DumperOptions options = new DumperOptions();
		options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
		// options.set
		options.setPrettyFlow(true);
		Yaml yaml = new Yaml(representer, options);

		return yaml;
	}

	public Yaml getDockerYaml() {
		Representer representer = new Representer() {
			@Override
			protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue,
					Tag customTag) {
				if (propertyValue == null || propertyValue == "") {
					return null;
				} else if ("init".equals(property.getName()) || "tty".equals(property.getName())
						|| "privileged".equals(property.getName()) || "stdin_open".equals(property.getName())
						|| "oom_kill_disable".equals(property.getName())) {
					if (propertyValue != null) {
						if (!Boolean.valueOf(propertyValue.toString())) {
							return null;
						}
					}
					return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);

				}

				else if ("cpu_count".equals(property.getName()) || "cpu_percent".equals(property.getName())
						|| "cpu_quota".equals(property.getName()) || "cpu_shares".equals(property.getName())
						|| "cpus".equals(property.getName()) || "oom_score_adj".equals(property.getName()))

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

				}

				else {
					return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
				}
			}
		};
		representer.addClassTag(reservations.class, Tag.MAP);
		representer.addClassTag(deploy.class, Tag.MAP);
		representer.addClassTag(ipam.class, Tag.MAP);
		representer.addClassTag(DockerCompose.class, Tag.MAP);
		representer.addClassTag(DockerCompose1.class, Tag.MAP);
		representer.getPropertyUtils().setSkipMissingProperties(true);
		DumperOptions options = new DumperOptions();
		options = new DumperOptions();
		options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
		// options.set
		options.setPrettyFlow(true);

		Yaml yaml = new Yaml(representer, options);
		return yaml;

	}

	private static String convertInputStreamToString(InputStream inputStream) throws IOException {

		ByteArrayOutputStream result = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		int length;
		while ((length = inputStream.read(buffer)) != -1) {
			result.write(buffer, 0, length);
		}

		return result.toString(StandardCharsets.UTF_8.name());

	}

	private Map<String, String> getMapValue(String data, String delim) {
		String[] items = data.split(delim);
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

	private Map<String, String> getMapValue(List<String> data, String delim) {
		Map<String, String> map = new HashMap<>();
		for (Iterator iterator = data.iterator(); iterator.hasNext();) {
			String string = (String) iterator.next();
			// System.out.println(string);
			String[] items = string.split(delim);

			if (items.length == 2) {
				map.put(items[0].trim(), items[1].trim());
			} else if (items.length < 2) {
				map.put(items[0].trim(), items[0].trim());
			}
		}
		return map;

	}

	private Map<String, String> getDummyLabel(String value) {
		Map<String, String> labelMap = new HashMap<>();
		labelMap.put("app", value);
		return labelMap;
	}
	
	private List<String> mapToList(Map<String,String> mp)
	{
		List<String> list = new ArrayList<>();
		Iterator it = mp.entrySet().iterator();
	    while (it.hasNext()) {
	        Map.Entry pair = (Map.Entry)it.next();
	        list.add(pair.getKey() + "=" + pair.getValue());
	        it.remove(); // avoids a ConcurrentModificationException
	    }
	    return list;
	}
	
	private List<String> arrayToArrayList(String[] array)
	{
		return new ArrayList<>(Arrays.asList(array));
	}

}

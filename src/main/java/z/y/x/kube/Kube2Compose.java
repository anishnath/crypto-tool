package z.y.x.kube;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.Yaml;

import z.y.x.kube.deployment.Deployment;
import z.y.x.kube.deployment.template;
import z.y.x.docker.DockerCompose1;
import z.y.x.docker.DockerCompose2Command;
import z.y.x.docker.deploy;
import z.y.x.docker.healthcheck1;
import z.y.x.docker.placement;
import z.y.x.docker.services1;
import z.y.x.kube.generic.requests;
import z.y.x.kube.generic.resources;
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
import z.y.x.kube.livenessProbe;
import z.y.x.kube.metadata;
import z.y.x.kube.options;
import z.y.x.kube.ports;
import z.y.x.kube.securityContext;
import z.y.x.kube.volumeMounts;
import z.y.x.kube.replication.Replication;
import z.y.x.kube.replication.ReplicationControllerSpec;

public class Kube2Compose {

	public static void main(String[] args) throws Exception {

		InputStream inputStream = DockerCompose2Command.class.getResourceAsStream("../pod/full2.yml");
		String testYAML = convertInputStreamToString(inputStream);
		String output = new Kube2Compose().getCompose(testYAML);
		System.out.println(output);

	}

	public String getCompose(String yamlData) throws Exception {
		
		if (null == yamlData || yamlData.trim().length() == 0) {
			throw new Exception("Invalid YAML File");
		}

		// System.out.println(yamlString);

		// yamlString = yamlString.replaceAll("___", "");

		String[] yamlarr = yamlData.split("---");
		
		DockerCompose1 compose = new DockerCompose1();
		Map<String, services1> servicesMap = new HashMap<>();
		for (int i = 0; i < yamlarr.length; i++) {

			Replication replication = null;
			ReplicationControllerSpec controllerSpec = null;
			Deployment deployment = null;
			StatefulSet statefulSet = null;
			StatefulSetSpec statefulSetSpec = null;
			metadata metadata = null;
			z.y.x.kube.spec podspec = null;
			z.y.x.kube.deployment.spec depSec = null;
			template template = null;
			Pod pod = null;
			List<containers> containerslist = null;
			services1 services = new services1();

			String yamlString = yamlarr[i];
			// System.out.println("i--> " + i + " " + yamlString);

			if (yamlString.contains("kind: Service") || yamlString.contains("kind:Service")) {
				// This is Service Object
				continue;
			}
			
			

			else if (yamlString.contains("kind: Pod") || yamlString.contains("kind:Pod")) {
				
				try{
					
					Yaml yaml = new Compose2Kube().getYaml();
					InputStream inputStream = new ByteArrayInputStream(yamlString.getBytes());
					pod =  yaml.loadAs(inputStream, Pod.class);
					if(pod!=null)
					{
						podspec = pod.getSpec();
						metadata = pod.getMetadata();
						if(podspec!=null)
						{
							containerslist = podspec.getContainers();
						}
						
						if (containerslist != null && containerslist.size() > 0) {
							GenCompose(i, metadata, podspec, compose, servicesMap, containerslist, services);
						}
					}
				}catch(Exception ex)
				{
					throw new Exception(ex);
				}
			}
			
			else if (yamlString.contains("kind: ReplicationController")
					|| yamlString.contains("kind:ReplicationController")) {
				
				try {
					
					Yaml yaml = new Compose2Kube().getYaml();
					InputStream inputStream = new ByteArrayInputStream(yamlString.getBytes());
					replication = yaml.loadAs(inputStream, Replication.class);
					if (replication != null) {
						controllerSpec = replication.getSpec();
						if(controllerSpec!=null)
						{
							template = controllerSpec.getTemplate();
							metadata = replication.getMetadata();
							if (template != null) {
								podspec = template.getSpec();
							} else {
								continue;
							}

							containerslist = template.getSpec().getContainers();
							if (containerslist != null && containerslist.size() > 0) {
								GenCompose(i, metadata, podspec, compose, servicesMap, containerslist, services);
							}
						}
					}
					
				}catch(Exception ex)
				{
					throw new Exception(ex);
				}

			}

			else if (yamlString.contains("kind: StatefulSet") || yamlString.contains("kind:StatefulSet")) {
				try {
					Yaml yaml = new Compose2Kube().getYaml();
					InputStream inputStream = new ByteArrayInputStream(yamlString.getBytes());
					statefulSet = yaml.loadAs(inputStream, StatefulSet.class);
					if (statefulSet != null) {
						statefulSetSpec = statefulSet.getSpec();
						if (statefulSetSpec != null) {
							template = statefulSetSpec.getTemplate();
							metadata = statefulSet.getMetadata();
							if (template != null) {
								podspec = template.getSpec();
							} else {
								continue;
							}

							containerslist = template.getSpec().getContainers();
							if (containerslist != null && containerslist.size() > 0) {
								GenCompose(i, metadata, podspec, compose, servicesMap, containerslist, services);
							}
						}
					}

				} catch (Exception e) {
					throw new Exception(e);
				}

			} else if (yamlString.contains("kind: Deployment") || yamlString.contains("kind:Deployment")) {

				try {
					Yaml yaml = new Compose2Kube().getYaml();
					InputStream inputStream = new ByteArrayInputStream(yamlString.getBytes());
					deployment = yaml.loadAs(inputStream, Deployment.class);
					if (deployment != null) {

						depSec = deployment.getSpec();

						if (depSec != null) {

							template = depSec.getTemplate();
							metadata = deployment.getMetadata();
							if (template != null) {
								podspec = template.getSpec();
							} else {
								continue;
							}

							containerslist = template.getSpec().getContainers();
							if (containerslist != null && containerslist.size() > 0) {
								GenCompose(i, metadata, podspec, compose, servicesMap, containerslist, services);
							}
						}
					}

				} catch (Exception e) {
					throw new Exception(e);
				}
			}

			else if (yamlString.contains("kind: ReplicationController")
					|| yamlString.contains("kind:ReplicationController")) {

			}

			else {
				continue;
			}
		}
		Yaml yaml = new Compose2Kube().getDockerYaml();
		String output = yaml.dump(compose);
		return output;
		
	}

	private void GenCompose(int i, metadata metadata, z.y.x.kube.spec podspec, DockerCompose1 compose,
			Map<String, services1> servicesMap, List<containers> containerslist, services1 services) {
		securityContext securityContext;
		deploy deploy = null;
		for (Iterator iterator = containerslist.iterator(); iterator.hasNext();) {
			containers containers2 = (containers) iterator.next();
			securityContext = containers2.getSecurityContext();
			if (securityContext != null) {
				services.setPrivileged(securityContext.isPrivileged());
			}
			if (containers2.isTty()) {
				services.setTty(containers2.isTty());
			}
			if (containers2.isStdin()) {
				services.setStdin_open(containers2.isStdin());
			}

			List<volumeMounts> volumeMountsList = containers2.getVolumeMounts();
			if (volumeMountsList != null && volumeMountsList.size() > 0) {

				List<String> mainList = new ArrayList<String>();
				int k = 0;
				for (Iterator iterator2 = volumeMountsList.iterator(); iterator2.hasNext();) {
					volumeMounts volumeMounts = (volumeMounts) iterator2.next();
					if (volumeMounts != null) {
						String mountPath = volumeMounts.getMountPath();
						if (mountPath != null) {
							mainList.add(mountPath);
						}
					}
				}

				if (mainList.size() > 0) {
					services.setVolumes(mainList.toArray(new String[mainList.size()]));
				}

			} // End of VilumeList

			if (podspec.isHostPID()) {
				services.setPid("host");
			}
			if (containers2.getName() != null) {
				services.setContainer_name(containers2.getName());
			}
			if (containers2.getResources() != null) {
				resources resources = containers2.getResources();
				requests requests = resources.getRequests();
				if (requests != null) {
					try {
						services.setMem_limit(requests.getMemory());
						services.setCpu_shares(Integer.valueOf(requests.getCpu()));
					} catch (NumberFormatException e) {

					}
				}

			} // End of Resources

			if (containers2.getSecurityContext() != null) {
				securityContext = containers2.getSecurityContext();
				services.setPrivileged(securityContext.isPrivileged());
				if (securityContext.getSysctls() != null && securityContext.getSysctls().size() > 0) {
					services.setSysctls(securityContext.getSysctls());
				}

				if (securityContext.getRunAsUser() != 0) {
					services.setUser(String.valueOf(securityContext.getRunAsUser()));
				}

				if (securityContext.getCapabilities() != null) {
					capabilities capabilities = securityContext.getCapabilities();
					if (capabilities.getAdd() != null) {
						services.setCap_add(capabilities.getAdd());
					}
					if (capabilities.getDrop() != null) {
						services.setCap_drop(capabilities.getDrop());
					}
				}

				if (securityContext.getSeLinuxOptions() != null) {
					SELinuxOptions seLinuxOptions = securityContext.getSeLinuxOptions();
					String level = seLinuxOptions.getLevel();
					String role = seLinuxOptions.getRole();
					String type = seLinuxOptions.getType();
					String user = seLinuxOptions.getUser();
					String label = "label=";
					List<String> mainList = new ArrayList();
					if (level != null) {
						label = label + "level:" + level;
						mainList.add(label);
					}

					if (role != null) {
						label = "label=" + "role:" + role;
						mainList.add(label);
					}

					if (type != null) {
						label = "label=" + "type:" + type;
						mainList.add(label);
					}

					if (user != null) {
						label = "label=" + "type:" + user;
						mainList.add(label);
					}
					if (mainList.size() > 0) {
						services.setSecurity_opt(mainList.toArray(new String[mainList.size()]));
					}

				}

			} else if (podspec.getSecurityContext() != null) {
				securityContext = podspec.getSecurityContext();
				services.setPrivileged(securityContext.isPrivileged());
				if (securityContext.getSysctls() != null && securityContext.getSysctls().size() > 0) {
					services.setSysctls(securityContext.getSysctls());
				}

				if (securityContext.getRunAsUser() != 0) {
					services.setUser(String.valueOf(securityContext.getRunAsUser()));
				}
				if (securityContext.getCapabilities() != null) {
					capabilities capabilities = securityContext.getCapabilities();
					if (capabilities.getAdd() != null) {
						services.setCap_add(capabilities.getAdd());
					}
					if (capabilities.getDrop() != null) {
						services.setCap_drop(capabilities.getDrop());
					}
				}

				if (securityContext.getSeLinuxOptions() != null) {
					SELinuxOptions seLinuxOptions = securityContext.getSeLinuxOptions();
					String level = seLinuxOptions.getLevel();
					String role = seLinuxOptions.getRole();
					String type = seLinuxOptions.getType();
					String user = seLinuxOptions.getUser();
					String label = "label=";
					String[] data = new String[5];
					int k = 0;
					if (level != null) {
						label = label + ":level:" + level;
						data[k] = label;
						k++;
					}

					if (role != null) {
						label = label + ":role:" + role;
						data[k] = label;
						k++;
					}

					if (type != null) {
						label = label + ":type:" + type;
						data[k] = label;
						k++;
					}

					if (user != null) {
						label = label + ":type:" + user;
						data[k] = label;
						k++;
					}
					services.setSecurity_opt(data);
				}

			} // END of Security Context

			
			if (podspec.getDnsConfig() != null) {
				dnsConfig dnsConfig = podspec.getDnsConfig();
				if (dnsConfig.getNameservers() != null) {
					services.setDns(dnsConfig.getNameservers());
				}
				if (dnsConfig.getSearches() != null) {
					services.setDns_search(dnsConfig.getSearches());
				}

				if (dnsConfig.getOptions() != null && dnsConfig.getOptions().size() > 0) {
					List<options> optionsList = dnsConfig.getOptions();
					String[] data = new String[optionsList.size() + 1];
					int k = 0;
					for (Iterator iterator2 = optionsList.iterator(); iterator2.hasNext();) {
						options options = (options) iterator2.next();
						if (options != null) {
							if (options.getName() != null && options.getValue() != null) {
								data[k] = options.getName() + "=" + options.getValue();
							} else if (options.getName() != null) {
								data[k] = options.getName();
							}
							k++;
						}
					}
					services.setDns_option(data);
				}
			} // END of DNS Config

			if (podspec.getSubdomain() != null) {
				services.setDomainname(podspec.getSubdomain());
			}

			if (podspec.getHostname() != null) {
				services.setHostname(podspec.getHostname());
			}

			if (podspec.getTerminationGracePeriodSeconds() != 0) {
				services.setStop_signal("SIGTERM");
			}

			if (podspec.getHostAliases() != null) {
				List<HostAlias> hostAlisesList = podspec.getHostAliases();
				String[] data = new String[hostAlisesList.size()];
				int k = 0;
				for (Iterator iterator2 = hostAlisesList.iterator(); iterator2.hasNext();) {
					HostAlias hostAlias = (HostAlias) iterator2.next();
					if (hostAlias != null) {
						List<String> hoatnames = hostAlias.getHostnames();
						String ip = hostAlias.getIp();
						String hName = null;
						if (hoatnames != null && hoatnames.size() > 0) {
							for (Iterator iterator3 = hoatnames.iterator(); iterator3.hasNext();) {
								String string = (String) iterator3.next();
								hName = string;
							}
							data[k] = hName + ":" + ip;
						}

					}
					k++;
				}
				services.setExtra_hosts(data);
			} // End Of Host aliases

			if (metadata.getAnnotations() != null) {
				Map<String, String> labelMap = metadata.getAnnotations();
				services.setLabels(mapToList(labelMap));
			} // Annoataions

			if (containers2.getWorkingDir() != null) {
				services.setWorking_dir(containers2.getWorkingDir());
			}

			if (containers2.getLivenessProbe() != null) {
				livenessProbe livenessProbe = containers2.getLivenessProbe();
				healthcheck1 healthcheck1 = new healthcheck1();
				if (livenessProbe.getPeriodSeconds() != 0) {
					healthcheck1.setInterval(String.valueOf(livenessProbe.getPeriodSeconds()));
				}
				if (livenessProbe.getTimeoutSeconds() != 0) {
					healthcheck1.setTimeout(String.valueOf(livenessProbe.getTimeoutSeconds()));
				}

				if (livenessProbe.getExec() != null) {
					ExecAction execAction = livenessProbe.getExec();
					List<String> execCommand = execAction.getCommand();
					StringBuilder builder = new StringBuilder();
					if (execCommand != null && execCommand.size() > 0) {
						for (Iterator iterator2 = execCommand.iterator(); iterator2.hasNext();) {
							String string = (String) iterator2.next();
							builder.append(string);
							builder.append(" ");
						}
					}

					healthcheck1.setTest(builder.toString());
					services.setHealthcheck(healthcheck1);
				}
			} // End Of Liveness Probe

			if (podspec.getRestartPolicy() != null) {
				deploy = new deploy();
				Map<String, Object> restratPolicy = new HashMap<String, Object>();
				String restartCommand = podspec.getRestartPolicy();
				if ("OnFailure".equalsIgnoreCase(restartCommand)) {
					restratPolicy.put("condition", "on-failure");
				} else if ("Always".equals(restartCommand)) {
					restratPolicy.put("condition", "always");
				} else if ("Never".equals(restartCommand)) {
					restratPolicy.put("condition", "no");
				} else {
					restratPolicy.put("condition", "always");
				}

				deploy.setRestart_policy(restratPolicy);

				services.setDeploy(deploy);
			} // End of Restart Policy

			if (podspec.getNodeSelector() != null) {
				
				if(null==deploy)
				{
					deploy = new deploy();	
				}
				placement placement = new placement();
				Map<String, String> nodeSelector = podspec.getNodeSelector();
				List<String> mapList = mapToList(nodeSelector);
				placement.setConstraints(mapList.toArray(new String[mapList.size()]));
				deploy.setPlacement(placement);
				services.setDeploy(deploy);
			}//End of Node Selector
			
			if (containers2.getPorts() != null) {
				List<ports> portList = containers2.getPorts();
				String[] data = new String[portList.size()];
				int k = 0;
				for (Iterator iterator2 = portList.iterator(); iterator2.hasNext();) {
					ports ports = (ports) iterator2.next();
					if (ports.getContainerPort() != 0) {
						data[k] = String.valueOf(ports.getContainerPort());
						k++;
					}

				}
				services.setPorts(data);
			}

			if (containers2.getEnv() != null) {
				List<env> envList = containers2.getEnv();
				List<String> envStringLIst = new ArrayList<>();
				for (Iterator iterator2 = envList.iterator(); iterator2.hasNext();) {
					env env = (env) iterator2.next();
					envStringLIst.add(env.getName() + "=" + env.getValue());

				}
				if (envStringLIst.size() > 0) {
					services.setEnvironment(envStringLIst);
				}
			}

			if (containers2.getImage() != null) {
				services.setImage(containers2.getImage());
			}
		}
		servicesMap.put("myservice" + i, services);
		compose.setServices(servicesMap);
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

	private List<String> mapToList(Map<String, String> mp) {
		List<String> list = new ArrayList<>();
		Iterator it = mp.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry pair = (Map.Entry) it.next();
			list.add(pair.getKey() + "=" + pair.getValue());
			it.remove(); // avoids a ConcurrentModificationException
		}
		return list;
	}

}

package z.y.x.docker;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;

public class DockerCompose2Command {

	public String getDockerCommand(String yamlString) throws Exception {
		if (null == yamlString || yamlString.trim().length() == 0) {
			throw new Exception("Invalid YAML File");
		}

		InputStream inputStream = new ByteArrayInputStream(yamlString.getBytes());

		Representer representer = new Representer() {
			@Override
			protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue,
					Tag customTag) {
				if (propertyValue == null || propertyValue == "") {
					return null;
				} else if ("init".equals(property.getName()) || "tty".equals(property.getName())
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

				}

				else if ("cpu_count".equals(property.getName())
						|| "cpu_percent".equals(property.getName())
						|| "cpu_quota".equals(property.getName())
						|| "cpu_shares".equals(property.getName())
						|| "cpus".equals(property.getName())
						|| "oom_score_adj".equals(property.getName())
						)

				{
					if (propertyValue !=null)
					{
						try {
							int tmp = Integer.valueOf(propertyValue.toString());
							if(tmp==0)
							{
								return null;
							}
						}catch (NumberFormatException ne) {
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
		// representer.addClassTag(reservations.class, Tag.MAP);
		// representer.addClassTag(limits.class, Tag.MAP);
		representer.addClassTag(ipam.class, Tag.MAP);
		representer.addClassTag(DockerCompose.class, Tag.MAP);
		// representer.addClassTag(DockerCompose1.class, Tag.MAP);
		representer.getPropertyUtils().setSkipMissingProperties(true);
		DumperOptions options = new DumperOptions();
		options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
		// options.set
		options.setPrettyFlow(true);

		Yaml yaml = new Yaml(representer, options);
		StringBuilder finalString = new StringBuilder();

		boolean yamlLoaded = false;

		try {
			DockerCompose dc = yaml.loadAs(inputStream, DockerCompose.class);
			yamlLoaded = true;
			if (dc != null && dc.getServices() != null) {
				Map<String, services> servicesMap = dc.getServices();
				for (Map.Entry<String, services> entry : servicesMap.entrySet()) {
					String key = entry.getKey();
					services services = entry.getValue();

					StringBuilder builder = new StringBuilder();
					builder.append("docker");
					builder.append(" ");
					builder.append("run");
					builder.append(" ");

					if (services.isPrivileged()) {
						builder.append("--privileged");
						builder.append(" ");
					}

					if (services.isTty()) {
						builder.append("-t");
						builder.append(" ");
					}

					if (services.isStdin_open()) {
						builder.append("-i");
						builder.append(" ");
					}

					if (services.isInit()) {
						builder.append("--init");
						builder.append(" ");
					}

					if (services.getCgroup_parent() != null) {
						builder.append("--cgroup-parent");
						builder.append(" ");
						builder.append(services.getCgroup_parent());
						builder.append(" ");
					}

					if (services.getLogging() != null) {
						logging logging = services.getLogging();
						if (logging.getDriver() != null) {
							builder.append("--log-driver");
							builder.append(" ");
							builder.append(logging.getDriver());
							builder.append(" ");
						}
						if (logging.getOptions() != null) {
							Map<String, String> envMap = logging.getOptions();
							Iterator it = envMap.entrySet().iterator();
							while (it.hasNext()) {
								builder.append("--log-opt");
								builder.append(" ");
								Map.Entry pair = (Map.Entry) it.next();
								builder.append(pair.getKey() + "=" + pair.getValue());
								builder.append(" ");
							}

						}
					}

					if (services.getVolumes() != null) {
						String[] data = services.getVolumes();
						for (int i = 0; i < data.length; i++) {
							builder.append("-v");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getUlimits() != null) {
						ulimits data = services.getUlimits();
						if (data.getNofile() != null) {
							builder.append("--ulimit");
							builder.append(" ");

							if (data.getNofile().getHard() != 0 && data.getNofile().getSoft() != 0) {
								builder.append("nofile=");
								builder.append(data.getNofile().getHard() + ":" + data.getNofile().getSoft());
								builder.append(" ");
							}
							if (data.getNproc() != 0) {
								builder.append("nproc=" + data.getNproc());
								builder.append(" ");
							}

						}
					}

					if (services.getPid() != null) {
						builder.append("--pid");
						builder.append(" ");
						builder.append(services.getPid());
						builder.append(" ");
					}

					if (services.getContainer_name() != null) {
						builder.append("--name");
						builder.append(" ");
						builder.append(services.getContainer_name());
						builder.append(" ");
					}
					
					if(services.getCpus()!=0.0)
					{
						builder.append("--cpus");
						builder.append(" ");
						builder.append(services.getCpus());
						builder.append(" ");
					}
					if(services.getCpu_shares()!=0)
					{
						builder.append("--cpu-shares");
						builder.append(" ");
						builder.append(services.getCpu_shares());
						builder.append(" ");
					}
					
					if(services.getCpu_quota()!=0)
					{
						builder.append("--cpu-quota");
						builder.append(" ");
						builder.append(services.getCpu_quota());
						builder.append(" ");
					}
					
					if(services.getCpu_period()!=null)
					{
						builder.append("--cpu-period");
						builder.append(" ");
						builder.append(services.getCpu_period());
						builder.append(" ");
					}
					
					if(services.getCpuset()!=null)
					{
						builder.append("--cpuset-cpus");
						builder.append(" ");
						builder.append(services.getCpuset());
						builder.append(" ");
					}
					
					if(services.getMem_limit()!=null)
					{
						builder.append("--memory");
						builder.append(" ");
						builder.append(services.getMem_limit());
						builder.append(" ");
					}
					
					if(services.getMemswap_limit()!=null)
					{
						builder.append("--memory-swap");
						builder.append(" ");
						builder.append(services.getMemswap_limit());
						builder.append(" ");
					}
					
					if(services.getMem_reservation()!=null)
					{
						builder.append("--memory-reservation");
						builder.append(" ");
						builder.append(services.getMem_reservation());
						builder.append(" ");
					}
					
					if(services.getOom_score_adj()!=0)
					{
						builder.append("--oom-score-adj");
						builder.append(" ");
						builder.append(services.getOom_score_adj());
						builder.append(" ");	
					}
					
					if(services.isOom_kill_disable())
					{
						builder.append("--oom-kill-disable");
						builder.append(" ");
						builder.append(true);
						builder.append(" ");	
					}
					
					if(services.getShm_size()!=null)
					{
						builder.append("--shm-size");
						builder.append(" ");
						builder.append(services.getShm_size());
						builder.append(" ");	
					}
					
					if(services.getSysctls()!=null)
					{
						Map<String, String> envMap = services.getSysctls();
						Iterator it = envMap.entrySet().iterator();
						while (it.hasNext()) {
							builder.append("--sysctl");
							builder.append(" ");
							Map.Entry pair = (Map.Entry) it.next();
							builder.append(pair.getKey() + "=" + pair.getValue());
							builder.append(" ");
						}
					}

					if (services.getDns() != null) {
						String[] data = services.getDns();
						for (int i = 0; i < data.length; i++) {
							builder.append("--dns");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getDns_search() != null) {
						String[] data = services.getDns_search();
						for (int i = 0; i < data.length; i++) {
							builder.append("--dns-search");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getDns_option() != null) {
						String[] data = services.getDns_option();
						for (int i = 0; i < data.length; i++) {
							builder.append("--dns-option");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getDomainname() != null) {
						builder.append("--domainname");
						builder.append(" ");
						builder.append(services.getDomainname());
						builder.append(" ");
					}

					if (services.getUser() != null) {
						builder.append("-u");
						builder.append(" ");
						builder.append(services.getUser());
						builder.append(" ");
					}

					if (services.getHostname() != null) {
						builder.append("-h");
						builder.append(" ");
						builder.append(services.getHostname());
						builder.append(" ");
					}

					if (services.getStop_signal() != null) {
						builder.append("--stop-signal");
						builder.append(" ");
						builder.append(services.getStop_signal());
						builder.append(" ");
					}

					if (services.getEntrypoint() != null) {
						String[] data = services.getEntrypoint();
						for (int i = 0; i < data.length; i++) {
							builder.append("--entrypoint");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getExtra_hosts() != null) {
						String[] data = services.getExtra_hosts();
						for (int i = 0; i < data.length; i++) {
							builder.append("--add-host");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getEnv_file() != null) {
						String[] data = services.getEnv_file();
						for (int i = 0; i < data.length; i++) {
							builder.append("--env-file");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getLabels() != null) {
						Map<String, String> envMap = services.getLabels();
						Iterator it = envMap.entrySet().iterator();
						while (it.hasNext()) {
							builder.append("-l");
							builder.append(" ");
							Map.Entry pair = (Map.Entry) it.next();
							builder.append(pair.getKey() + "=" + pair.getValue());
							builder.append(" ");
						}
					}

					if (services.getDevices() != null) {

						String[] data = services.getDevices();
						for (int i = 0; i < data.length; i++) {
							builder.append("--device");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}

					}

					if (services.getMac_address() != null) {
						builder.append("--mac-address");
						builder.append(" ");
						builder.append(services.getMac_address());
						builder.append(" ");
					}

					if (services.getCap_add() != null) {
						String[] data = services.getCap_add();
						for (int i = 0; i < data.length; i++) {
							builder.append("--cap-add");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getCap_drop() != null) {
						String[] data = services.getCap_drop();
						for (int i = 0; i < data.length; i++) {
							builder.append("--cap-drop");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getNetworks() != null) {
						String[] data = services.getNetworks();
						for (int i = 0; i < data.length; i++) {
							builder.append("--network");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getSecurity_opt() != null) {
						String[] data = services.getSecurity_opt();
						for (int i = 0; i < data.length; i++) {
							builder.append("--security-opt");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getWorking_dir() != null) {
						builder.append("-w");
						builder.append(" ");
						builder.append(services.getWorking_dir());
						builder.append(" ");
					}

					if (services.getTmpfs() != null) {
						String[] data = services.getTmpfs();
						for (int i = 0; i < data.length; i++) {
							builder.append("--tmpfs");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}
					}

					if (services.getHealthcheck() != null) {
						healthcheck healthcheck = services.getHealthcheck();
						if (healthcheck.getInterval() != null) {
							builder.append("--health-interval");
							builder.append(" ");
							builder.append(healthcheck.getInterval());
							builder.append(" ");
						}
						if (healthcheck.getRetries() != 0) {
							builder.append("--health-retries");
							builder.append(" ");
							builder.append(healthcheck.getInterval());
							builder.append(" ");
						}

						if (healthcheck.getTest() != null) {
							String[] data = healthcheck.getTest();
							for (int i = 0; i < data.length; i++) {
								builder.append("--health-cmd");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}

						}

					}

					if (services.getDeploy() != null) {
						deploy deploy = services.getDeploy();
						Map<String, Object> deployMap = deploy.getRestart_policy();
						if(deployMap!=null)
						{
							Iterator it = deployMap.entrySet().iterator();
							while (it.hasNext()) {
								Map.Entry pair = (Map.Entry) it.next();
								if (pair.getKey() != null && "condition".equals(pair.getKey())) {
									builder.append("--restart");
									builder.append(" ");
									builder.append(pair.getValue());
									builder.append(" ");
								}
							}
						}

					}

					if (services.getLinks() != null) {

						String[] data = services.getLinks();
						for (int i = 0; i < data.length; i++) {
							builder.append("--link");
							builder.append(" ");
							builder.append(data[i]);
							builder.append(" ");
						}

					}

					if (services.getPorts() != null) {
						String[] ports = services.getPorts();
						for (int i = 0; i < ports.length; i++) {
							builder.append("-p");
							builder.append(" ");
							builder.append(ports[i]);
							builder.append(" ");
						}
					}

					if (services.getEnvironment() != null) {
						Map<String, String> envMap = services.getEnvironment();
						Iterator it = envMap.entrySet().iterator();
						while (it.hasNext()) {
							builder.append("-e");
							builder.append(" ");
							Map.Entry pair = (Map.Entry) it.next();
							builder.append(pair.getKey() + "=" + pair.getValue());
							builder.append(" ");
						}
					}

					if (services.getImage() != null) {
						builder.append(services.getImage());
						builder.append(" ");
					}

					if (services.getCommand() != null) {
						String[] commands = services.getCommand();
						for (int i = 0; i < commands.length; i++) {
							builder.append(commands[i]);
							builder.append(" ");
						}

					}

					finalString.append(builder.toString());
					finalString.append("\n");
					// System.out.println(builder.toString());

				}
			}

		} catch (Exception e) {
			//e.printStackTrace();
			// System.out.println("I got Exception");
		}

		// System.out.println(yamlLoaded);

		if (!yamlLoaded) {
			try {

				inputStream = new ByteArrayInputStream(yamlString.getBytes());

				representer = new Representer() {
					@Override
					protected NodeTuple representJavaBeanProperty(Object javaBean, Property property,
							Object propertyValue, Tag customTag) {
						if (propertyValue == null || propertyValue == "") {
							return null;
						} else if ("init".equals(property.getName()) || "tty".equals(property.getName())
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

						}

						else if ("cpu_count".equals(property.getName())
								|| "cpu_percent".equals(property.getName())
								|| "cpu_quota".equals(property.getName())
								|| "cpu_shares".equals(property.getName())
								|| "cpus".equals(property.getName())
								|| "oom_score_adj".equals(property.getName())
								)

						{
							if (propertyValue !=null)
							{
								try {
									int tmp = Integer.valueOf(propertyValue.toString());
									if(tmp==0)
									{
										return null;
									}
								}catch (NumberFormatException ne) {
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
				// representer.addClassTag(reservations.class, Tag.MAP);
				// representer.addClassTag(deploy.class, Tag.PAIRS);
				representer.addClassTag(ipam.class, Tag.MAP);
				// representer.addClassTag(DockerCompose.class, Tag.MAP);
				representer.addClassTag(DockerCompose1.class, Tag.MAP);
				representer.getPropertyUtils().setSkipMissingProperties(true);
				options = new DumperOptions();
				options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
				// options.set
				options.setPrettyFlow(true);

				yaml = new Yaml(representer, options);

				DockerCompose1 dc = yaml.loadAs(inputStream, DockerCompose1.class);

				if (dc != null && dc.getServices() != null) {
					// System.out.println("Did I got Thos");
					Map<String, services1> servicesMap = dc.getServices();
					for (Map.Entry<String, services1> entry : servicesMap.entrySet()) {
						String key = entry.getKey();
						services1 services = entry.getValue();
						StringBuilder builder = new StringBuilder();
						builder.append("docker");
						builder.append(" ");
						builder.append("run");
						builder.append(" ");

						if (services.isPrivileged()) {
							builder.append("--privileged");
							builder.append(" ");
						}

						if (services.isTty()) {
							builder.append("-t");
							builder.append(" ");
						}

						if (services.isStdin_open()) {
							builder.append("-i");
							builder.append(" ");
						}

						if (services.isInit()) {
							builder.append("--init");
							builder.append(" ");
						}

						if (services.getLogging() != null) {
							logging logging = services.getLogging();
							if (logging.getDriver() != null) {
								builder.append("--log-driver");
								builder.append(" ");
								builder.append(logging.getDriver());
								builder.append(" ");
							}
							if (logging.getOptions() != null) {
								Map<String, String> envMap = logging.getOptions();
								Iterator it = envMap.entrySet().iterator();
								while (it.hasNext()) {
									builder.append("--log-opt");
									builder.append(" ");
									Map.Entry pair = (Map.Entry) it.next();
									builder.append(pair.getKey() + "=" + pair.getValue());
									builder.append(" ");
								}

							}
						}

						if (services.getCgroup_parent() != null) {
							builder.append("--cgroup-parent");
							builder.append(" ");
							builder.append(services.getCgroup_parent());
							builder.append(" ");
						}

						if (services.getVolumes() != null) {
							String[] data = services.getVolumes();
							for (int i = 0; i < data.length; i++) {
								builder.append("-v");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getUlimits() != null) {
							ulimits data = services.getUlimits();
							if (data.getNofile() != null) {
								builder.append("--ulimit");
								builder.append(" ");

								if (data.getNofile().getHard() != 0 && data.getNofile().getSoft() != 0) {
									builder.append("nofile=");
									builder.append(data.getNofile().getHard() + ":" + data.getNofile().getSoft());
									builder.append(" ");
								}
								if (data.getNproc() != 0) {
									builder.append("nproc=" + data.getNproc());
									builder.append(" ");
								}

							}
						}

						if (services.getPid() != null) {
							builder.append("--pid");
							builder.append(" ");
							builder.append(services.getPid());
							builder.append(" ");
						}

						if (services.getContainer_name() != null) {
							builder.append("--name");
							builder.append(" ");
							builder.append(services.getContainer_name());
							builder.append(" ");
						}
						
						if(services.getCpus()!=0.0)
						{
							builder.append("--cpus");
							builder.append(" ");
							builder.append(services.getCpus());
							builder.append(" ");
						}
						if(services.getCpu_shares()!=0)
						{
							builder.append("--cpu-shares");
							builder.append(" ");
							builder.append(services.getCpu_shares());
							builder.append(" ");
						}
						
						if(services.getCpu_quota()!=0)
						{
							builder.append("--cpu-quota");
							builder.append(" ");
							builder.append(services.getCpu_quota());
							builder.append(" ");
						}
						
						if(services.getCpu_period()!=null)
						{
							builder.append("--cpu-period");
							builder.append(" ");
							builder.append(services.getCpu_period());
							builder.append(" ");
						}
						
						if(services.getCpuset()!=null)
						{
							builder.append("--cpuset-cpus");
							builder.append(" ");
							builder.append(services.getCpuset());
							builder.append(" ");
						}
						
						if(services.getMem_limit()!=null)
						{
							builder.append("--memory");
							builder.append(" ");
							builder.append(services.getMem_limit());
							builder.append(" ");
						}
						
						if(services.getMemswap_limit()!=null)
						{
							builder.append("--memory-swap");
							builder.append(" ");
							builder.append(services.getMemswap_limit());
							builder.append(" ");
						}
						
						if(services.getMem_reservation()!=null)
						{
							builder.append("--memory-reservation");
							builder.append(" ");
							builder.append(services.getMem_reservation());
							builder.append(" ");
						}
						
						if(services.getOom_score_adj()!=0)
						{
							builder.append("--oom-score-adj");
							builder.append(" ");
							builder.append(services.getOom_score_adj());
							builder.append(" ");	
						}
						
						if(services.isOom_kill_disable())
						{
							builder.append("--oom-kill-disable");
							builder.append(" ");
							builder.append(true);
							builder.append(" ");	
						}
						
						if(services.getShm_size()!=null)
						{
							builder.append("--shm-size");
							builder.append(" ");
							builder.append(services.getShm_size());
							builder.append(" ");	
						}
						
						if(services.getSysctls()!=null)
						{
							List<String> envMap = services.getSysctls();
							for (Iterator iterator = envMap.iterator(); iterator.hasNext();) {
								String string = (String) iterator.next();
								builder.append("--sysctl");
								builder.append(" ");
								builder.append(string);
								builder.append(" ");
							}
						}

						if (services.getDns() != null) {
							String[] data = services.getDns();
							for (int i = 0; i < data.length; i++) {
								builder.append("--dns");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getDns_search() != null) {
							String[] data = services.getDns_search();
							for (int i = 0; i < data.length; i++) {
								builder.append("--dns-search");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getDns_option() != null) {
							String[] data = services.getDns_option();
							for (int i = 0; i < data.length; i++) {
								builder.append("--dns-option");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getDomainname() != null) {
							builder.append("--domainname");
							builder.append(" ");
							builder.append(services.getDomainname());
							builder.append(" ");
						}

						if (services.getUser() != null) {
							builder.append("-u");
							builder.append(" ");
							builder.append(services.getUser());
							builder.append(" ");
						}

						if (services.getHostname() != null) {
							builder.append("-h");
							builder.append(" ");
							builder.append(services.getHostname());
							builder.append(" ");
						}

						if (services.getStop_signal() != null) {
							builder.append("--stop-signal");
							builder.append(" ");
							builder.append(services.getStop_signal());
							builder.append(" ");
						}

						if (services.getEntrypoint() != null) {
							String[] data = services.getEntrypoint();
							builder.append("--entrypoint");
							builder.append(" ");
							for (int i = 0; i < data.length; i++) {
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getExtra_hosts() != null) {
							String[] data = services.getExtra_hosts();
							for (int i = 0; i < data.length; i++) {
								builder.append("--add-host");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getEnv_file() != null) {
							String[] data = services.getExtra_hosts();
							for (int i = 0; i < data.length; i++) {
								builder.append("--env-file");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getLabels() != null) {
							List<String> envMap = services.getLabels();

							for (Iterator iterator = envMap.iterator(); iterator.hasNext();) {
								String string = (String) iterator.next();
								builder.append("-l");
								builder.append(" ");
								builder.append(string);
								builder.append(" ");
							}
						}

						if (services.getDevices() != null) {

							String[] data = services.getDevices();
							for (int i = 0; i < data.length; i++) {
								builder.append("--device");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}

						}

						if (services.getMac_address() != null) {
							builder.append("--mac-address");
							builder.append(" ");
							builder.append(services.getMac_address());
							builder.append(" ");
						}

						if (services.getCap_add() != null) {
							List<String> data = services.getCap_add();
							for (Iterator iterator = data.iterator(); iterator.hasNext();) {
								String string = (String) iterator.next();
								builder.append("--cap-add");
								builder.append(" ");
								builder.append(string);
								builder.append(" ");

							}
							// for (int i = 0; i < data.length; i++) {
							// builder.append("--cap-add");
							// builder.append(" ");
							// builder.append(data[i]);
							// builder.append(" ");
							// }
						}

						if (services.getCap_drop() != null) {
							List<String> data = services.getCap_drop();
							for (Iterator iterator = data.iterator(); iterator.hasNext();) {
								String string = (String) iterator.next();
								builder.append("--cap-drop");
								builder.append(" ");
								builder.append(string);
								builder.append(" ");

							}

							// for (int i = 0; i < data.length; i++) {
							// builder.append("--cap-drop");
							// builder.append(" ");
							// builder.append(data[i]);
							// builder.append(" ");
							// }
						}

						// if(services.getNetworks()!=null)
						// {
						// String[] data = services.getNetworks();
						// for (int i = 0; i < data.length; i++) {
						// builder.append("--network");
						// builder.append(" ");
						// builder.append(data[i]);
						// builder.append(" ");
						// }
						// }

						if (services.getSecurity_opt() != null) {
							String[] data = services.getSecurity_opt();
							for (int i = 0; i < data.length; i++) {
								builder.append("--security-opt");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getWorking_dir() != null) {
							builder.append("-w");
							builder.append(" ");
							builder.append(services.getWorking_dir());
							builder.append(" ");
						}

						if (services.getTmpfs() != null) {
							String[] data = services.getTmpfs();
							for (int i = 0; i < data.length; i++) {
								builder.append("--tmpfs");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}
						}

						if (services.getHealthcheck() != null) {
							healthcheck1 healthcheck = services.getHealthcheck();
							if (healthcheck.getInterval() != null) {
								builder.append("--health-interval");
								builder.append(" ");
								builder.append(healthcheck.getInterval());
								builder.append(" ");
							}
							if (healthcheck.getRetries() != 0) {
								builder.append("--health-retries");
								builder.append(" ");
								builder.append(healthcheck.getInterval());
								builder.append(" ");
							}

							if (healthcheck.getTest() != null) {
								String data = healthcheck.getTest();
								builder.append("--health-cmd");
								builder.append(" ");
								builder.append(data);
								builder.append(" ");
							}

						}

						if (services.getDeploy() != null) {
							deploy deploy = services.getDeploy();
							Map<String, Object> deployMap = deploy.getRestart_policy();
							Iterator it = deployMap.entrySet().iterator();
							while (it.hasNext()) {
								Map.Entry pair = (Map.Entry) it.next();
								if (pair.getKey() != null && "condition".equals(pair.getKey())) {
									builder.append("--restart");
									builder.append(" ");
									builder.append(pair.getValue());
									builder.append(" ");
								}
							}
						}

						if (services.getLinks() != null) {

							String[] data = services.getLinks();
							for (int i = 0; i < data.length; i++) {
								builder.append("--link");
								builder.append(" ");
								builder.append(data[i]);
								builder.append(" ");
							}

						}

						if (services.getPorts() != null) {
							String[] ports = services.getPorts();
							for (int i = 0; i < ports.length; i++) {
								builder.append("-p");
								builder.append(" ");
								builder.append(ports[i]);
								builder.append(" ");
							}
						}

						if (services.getEnvironment() != null) {
							List<String> envMap = services.getEnvironment();

							for (Iterator iterator = envMap.iterator(); iterator.hasNext();) {
								String string = (String) iterator.next();
								builder.append("-e");
								builder.append(" ");
								builder.append(string);
								builder.append(" ");

							}
						}

						if (services.getImage() != null) {
							builder.append(services.getImage());
							builder.append(" ");
						}

						if (services.getNetworks() != null) {
							Map<String, Object> mapObj = services.getNetworks();
							Iterator it = mapObj.entrySet().iterator();
							while (it.hasNext()) {
								Map.Entry pair = (Map.Entry) it.next();
								if (pair.getKey() != null) {
									// System.out.println("pair.getKey() " +
									// pair.getKey());
									if (pair.getValue() != null) {
										// System.out.println(pair.getValue().getClass());
										LinkedHashMap<String, Object> lhm = (LinkedHashMap<String, Object>) pair
												.getValue();
										for (Map.Entry<String, Object> entry1 : lhm.entrySet()) {
											String key1 = entry1.getKey();
											// System.out.println("key1 " +
											// key1);
											// System.out.println("Class" +
											// entry1.getValue().getClass());
											if ("ipv4_address".equals(key1)) {
												builder.append("--ip");
												builder.append(" ");
												builder.append(entry1.getValue());
												builder.append(" ");
												// System.out.println(entry1.getValue());
											}
											if ("ipv6_address".equals(key1)) {
												builder.append("--ip6");
												builder.append(" ");
												builder.append(entry1.getValue());
												builder.append(" ");
											}
											// ArrayList<String> value =
											// entry1.getValue();
											// now work with key and value...
										}
									}
								}
							}
						}

						if (services.getCommand() != null) {
							// List<String> data = services.getCommand();

							String data = services.getCommand();
							builder.append(" ");
							builder.append(data);
							builder.append(" ");

							// for (Iterator iterator = data.iterator();
							// iterator.hasNext();) {
							// String string = (String) iterator.next();
							// builder.append(" ");
							// builder.append(string);
							// builder.append(" ");
							//
							// }

							// for (int i = 0; i < commands.length; i++) {
							// builder.append(commands[i]);
							// builder.append(" ");
							// }

						}

						finalString.append(builder.toString());
						finalString.append("\n");
						// System.out.println(builder.toString());

					}
				}

			} catch (Exception e) {
				throw new Exception(e);
			}
		}

		return finalString.toString();
	}

	public static void main(String[] args) throws Exception {

		InputStream inputStream = DockerCompose2Command.class.getResourceAsStream("./file3.yml");
		String testYAML = convertInputStreamToString(inputStream);
		// System.out.println(testYAML);
		DockerCompose2Command test2 = new DockerCompose2Command();
		System.out.println(test2.getDockerCommand(testYAML));
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

}

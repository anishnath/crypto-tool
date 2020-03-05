package z.y.x.docker;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;

public class DockerComposeGen {
	
	public static void main(String[] args) {
		
		String s = "db-data:${DOCKER_MOUNT_PATH:-/root/scdf}";
		
		System.out.println(s.substring(0,s.indexOf(":")));
		
		Representer representer = new Representer() {
		    @Override
		    protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue,Tag customTag) {
		        // if value of property is null, ignore it.
		    	
		    	
		    	//System.out.println(property.getName());
		    	
		        if (propertyValue == null || propertyValue == ""  ) {
		            return null;
		        }

				else if ("init".equals(property.getName())
						|| "tty".equals(property.getName())
						|| "privileged".equals(property.getName())
						|| "stdin_open".equals(property.getName())
						|| "oom_kill_disable".equals(property.getName())
						)
				{

					if (propertyValue !=null)
					{
						if(!Boolean.valueOf(propertyValue.toString()))
						{
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
		
		representer.addClassTag(ipam.class, Tag.MAP);
		
		DumperOptions options = new DumperOptions();
		options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
		//options.set
		options.setCanonical(false);
		options.setPrettyFlow(true);
		
		Yaml yaml = new Yaml(representer,options);
		
		DockerCompose dockerCompose = new DockerCompose();
		services services = new services();
		services.setContainer_name("dataflow-mysql");
		
		Map<String, String> envMap = new HashMap<String, String>();
		envMap.put("MYSQL_DATABASE", "dataflow");
		envMap.put("MYSQL_USER", "root");
		envMap.put("MYSQL_ROOT_PASSWORD", "rootpw");
		
		Map<String, String> labelMap = new HashMap<String, String>();
		labelMap.put("app", "demo");
		labelMap.put("gen", "test");
		
		healthcheck healthcheck = new healthcheck();
		healthcheck.setTest(new String[]{"CMD","curl","-f","http://localhost"});
		services.setHealthcheck(healthcheck);
		
		services.setEnvironment(envMap);
		services.setLabels(labelMap);
		services.setExpose(new int[]{3306});
		services.setPorts(new String[]{"9393:9393"});
		services.setVolumes(new String[]{"db-data:${DOCKER_MOUNT_PATH:-/root/scdf}"});
		services.setEntrypoint(new String[]{"./wait-for-it.sh mysql:3306 -- java -jar /maven/spring-cloud-dataflow-server.jar"});
		
		services.setDns(new String[]{"1.1.1.1","2.2.2.2"});
		services.setDns_search(new String[]{"dc1.example.com","dc2.example.com"});
		services.setLinks(new String[]{"db","db:database"});
		
		services.setUser("Anish");
		services.setWorking_dir("/tmp");
		services.setDomainname("domainame");
		services.setHostname("hostname");
		services.setIpc("IPC");
		services.setMac_address("MAC ADDRE");
		
		deploy deploy = new deploy();
		deploy.setReplicas(2);
		Map<String, Object> m1 = new HashMap<String, Object>();
		m1.put("condition", "on-failure");
		deploy.setRestart_policy(m1);
		
		Map<String, Object> m2 = new HashMap<String, Object>();
		m2.put("parallelism", Integer.valueOf(2));
		
		
		deploy.setUpdate_config(m2);
		
		Map<String,String[]> placementMap = new HashMap<>();
		placementMap.put("constraints", new String[]{"node.role == manager","engine.labels.operatingsystem == ubuntu 14.04"});
		//deploy.setPlacement(placementMap);
		
		
		placement placement = new placement();
		placement.setConstraints(new String[]{"node.role == manager","engine.labels.operatingsystem == ubuntu 14.04"});
		List<preferences> preferenceslist = new ArrayList<preferences>();
		preferences preferences = new preferences();
		preferences.setSpread("node.labels.zone");
		preferenceslist.add(preferences);
		
		placement.setPreferences(preferenceslist);
		
		deploy.setPlacement(placement);
		
		
		limits limits = new limits();
		limits.setCpus("0.50");
		limits.setMemory("50M");
		
		reservations reservations = new reservations();
		reservations.setCpus("0.25");
		reservations.setMemory("20M");
		
		resources resources = new resources();
		resources.setLimits(limits);
		resources.setReservations(reservations);
		
		deploy.setResources(resources);
		
		services.setDeploy(deploy);
		services.setImage("mysql:5.7.25");
		
		logging logging = new logging();
		Map<String,String> logMap = new HashMap<>();
		logMap.put("max-size", "200k");
		logMap.put("max-file", "10");
		
		logging.setOptions(logMap);
		
		services.setLogging(logging);
		
		nofile nofile = new nofile();
		nofile.setHard(65535);
		nofile.setSoft(65535);
		
		ulimits ulimits = new ulimits();
		ulimits.setNofile(nofile);
		
		ulimits.setNproc(4000);
		
		//services.setUlimits(ulimits);
		
		
		Map<String,services> mapServices = new HashMap<>();
		mapServices.put("mysql", services);
		dockerCompose.setServices(mapServices);
		
		Map<String,Object> networkMap = new HashMap<>();
		networkMap.put("frontend", null);
		networkMap.put("backend", null);
		
		
		config config = new config();
		
		config.setSubnet("172.16.238.0/24");
		config[] configarr = new config[]{config};
		ipam ipam = new ipam();
		ipam.setConfig(configarr);
		
		Map<String,Object> test = new HashMap<>();
		test.put("ipam", ipam);
		
		networkMap.put("frontend", test);
		//networkMap.put("ipam", ipam);
		
		
		
		dockerCompose.setNetworks(networkMap);
		
		
		Map<String,String> volumeMap = new HashMap<>();
		volumeMap.put("db-data", null );
		
		dockerCompose.setVolumes(volumeMap);
		
		String output = yaml.dump(dockerCompose);
		
		System.out.println(output);
		
	}

}

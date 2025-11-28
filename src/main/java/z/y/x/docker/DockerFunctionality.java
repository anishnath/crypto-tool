package z.y.x.docker;

/**
 * Created by aninath on 19/02/20.
 */


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.apache.commons.lang3.RandomStringUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;
import z.y.x.kube.*;
import z.y.x.kube.deployment.Deployment;
import z.y.x.kube.deployment.selector;
import z.y.x.kube.deployment.template;
import z.y.x.kube.service.Service;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * Created by aninath on 11/16/17.
 */
public class DockerFunctionality extends HttpServlet {

    private static final long serialVersionUID = 2L;
    private static final String METHOD_GENERATE_DC = "GENERATE_DC";
    private static final String METHOD_GENERATE_DC_FROM_DOCKER_RUN = "GENERATE_DC_FROM_DOCKER_RUN";
    private static final String METHOD_GENERATE_DC_RUN_2_DC = "GENERATE_DC_RUN_2_DC";




    public DockerFunctionality() {

    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        // TODO Auto-generated method stub

        // Set response content type
        response.setContentType("text/html");

        // Actual logic goes here.
        PrintWriter out = response.getWriter();
        out.println("<h1>" + "Hello CANT PROCESS THE MESSAGE " + "</h1>");

    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        final String methodName = request.getParameter("methodName");
        Gson gson = new Gson();
        PrintWriter out = response.getWriter();

        //System.out.println("methodName" + methodName);

        if (METHOD_GENERATE_DC_RUN_2_DC.equals(methodName)) {

            String dockerrun = request.getParameter("dockerrun");
            DockerComposeResponse resp = new DockerComposeResponse();
            resp.setOperation("docker_compose_to_command");

            if(null == dockerrun || dockerrun.trim().length()==0)
            {
                resp.setSuccess(false);
                resp.setErrorMessage("Please provide a Docker Compose file");
                out.println(gson.toJson(resp));
                return;
            }

            DockerCompose2Command dockerCompose2Command = new DockerCompose2Command();

            try {
                String output = dockerCompose2Command.getDockerCommand(dockerrun);

                if(output!=null && output.trim().length()>0) {
                    resp.setSuccess(true);
                    resp.setDockerComposeYaml(output);
                    out.println(gson.toJson(resp));
                    return;
                }
                else {
                    resp.setSuccess(false);
                    resp.setErrorMessage("The Docker Compose file is not valid");
                    out.println(gson.toJson(resp));
                    return;
                }

            }catch (Exception ex)
            {
                resp.setSuccess(false);
                resp.setErrorMessage(ex.getMessage() != null ? ex.getMessage() : "Error processing Docker Compose file");
                out.println(gson.toJson(resp));
                return;
            }

        }

        if (METHOD_GENERATE_DC_FROM_DOCKER_RUN.equals(methodName)) {

            String dockerrun = request.getParameter("dockerrun");
            DockerComposeResponse resp = new DockerComposeResponse();
            resp.setOperation("docker_run_to_compose");

            if(null == dockerrun || dockerrun.trim().length()==0)
            {
                resp.setSuccess(false);
                resp.setErrorMessage("Please provide a Docker run command");
                out.println(gson.toJson(resp));
                return;
            }

            try {
                Docker docker = new Docker();
                String output = docker.genDockerCompose(dockerrun);

                resp.setSuccess(true);
                resp.setDockerComposeYaml(output);
                resp.setVersion("3");
                out.println(gson.toJson(resp));
                return;
            } catch (Exception ex) {
                resp.setSuccess(false);
                resp.setErrorMessage(ex.getMessage() != null ? ex.getMessage() : "Error converting Docker run command");
                out.println(gson.toJson(resp));
                return;
            }
        }

        if (METHOD_GENERATE_DC.equals(methodName)) {

            String name = request.getParameter("serviceName");
            String image = request.getParameter("image");
            String container_name = request.getParameter("container_name");
            String entrypoint = request.getParameter("entrypoint");
            String volumes = request.getParameter("volumes");
            String environment = request.getParameter("environment");
            String labels = request.getParameter("labels");
            String expose = request.getParameter("expose");
            String ports = request.getParameter("ports");
            String user = request.getParameter("user");
            String working_dir = request.getParameter("working_dir");
            String domainname = request.getParameter("domainname");
            String hostname = request.getParameter("hostname");
            String ipc = request.getParameter("ipc");
            String mac_address = request.getParameter("mac_address");
            String privileged = request.getParameter("privileged");
            String restart_policy = request.getParameter("restart_policy");
            String dns = request.getParameter("dns");
            String dns_search = request.getParameter("dns_search");
            String links = request.getParameter("links");
            String depends_on = request.getParameter("depends_on");
            String cpus = request.getParameter("cpus");
            String memory = request.getParameter("memory");
            String rcpus = request.getParameter("rcpus");
            String rmemory = request.getParameter("rmemory");
            String constraints = request.getParameter("constraints");
            String healthcheck = request.getParameter("healthcheck");

            if (name == null || name.trim().length() == 0) {
                name="demo";
            }

            if (image == null || image.trim().length() == 0) {
                image="nginx";
            }

            if (container_name == null || container_name.trim().length() == 0) {
                container_name="nginxc";
            }

            Representer representer = new Representer() {
                @Override
                protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue,Tag customTag) {
                    // if value of property is null, ignore it.
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

            DumperOptions options = new DumperOptions();
            options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
            //options.set
            options.setPrettyFlow(true);

            Yaml yaml = new Yaml(representer,options);

            DockerCompose dockerCompose = new DockerCompose();
            services services = new services();
            healthcheck healthcheckk = new healthcheck();

            services.setContainer_name(container_name);
            services.setImage(image);

            if (environment != null && environment.trim().length() > 0) {
                services.setEnvironment(getMapValue(environment));
            }

            if (labels != null && labels.trim().length() > 0) {
                labels = labels + ",generated=by 8gwifi.org";
                services.setLabels(getMapValue(labels));
            }
            else{
                services.setLabels(getMapValue("generated=by 8gwifi.org"));

            }

            if(expose!=null && expose.trim().length()>0)
            {
                services.setExpose(getArrayINT(expose));
            }

            if(ports!=null && ports.trim().length()>0)
            {
                services.setPorts(getArrayString(ports));
            }

            if(entrypoint!=null && entrypoint.trim().length()>0)
            {
                services.setEntrypoint(getArrayString(entrypoint,"&&"));
            }

            if(volumes!=null && volumes.trim().length()>0)
            {
                String[] volumearr = getArrayString(volumes);
                services.setVolumes(volumearr);
                Map<String,String> volumeMap = new HashMap<>();
                for(int i=0; i<volumearr.length;i++)
                {
                    String vol = volumearr[i];
                    vol = vol.substring(0,vol.indexOf(":"));

                    volumeMap.put(vol, null );
                    dockerCompose.setVolumes(volumeMap);
                }

            }

            if(dns!=null && dns.trim().length()>0)
            {
                services.setDns(getArrayString(dns));
            }

            if(dns_search!=null && dns_search.trim().length()>0)
            {
                services.setDns_search(getArrayString(dns_search));
            }

            if(links!=null && links.trim().length()>0)
            {
                services.setLinks(getArrayString(links));
            }

            if(user!=null && user.trim().length()>0)
            {
                try {

                    int uid = Integer.valueOf(user);
                    services.setUser(user);

                }catch (Exception ex) {
                    services.setUser("1000");
                }
            }

            if(working_dir!=null && working_dir.trim().length()>0)
            {
                services.setWorking_dir(working_dir);
            }

            if(domainname!=null && domainname.trim().length()>0)
            {
                services.setDomainname(domainname);
            }

            if(hostname!=null && hostname.trim().length()>0)
            {
                services.setHostname(hostname);
            }

            if(ipc!=null && ipc.trim().length()>0)
            {
                services.setIpc(ipc);
            }

            if(mac_address!=null && mac_address.trim().length()>0)
            {
                services.setMac_address(mac_address);
            }

            if("healthcheck".equalsIgnoreCase(healthcheck))
            {
                healthcheck healthcheckl = new healthcheck();
                healthcheckl.setTest(new String[]{"CMD","curl","-f","http://localhost"});
                services.setHealthcheck(healthcheckl);
            }

            if(privileged!=null && privileged.trim().length()>0)
            {
                boolean pv = Boolean.valueOf(privileged);
                services.setPrivileged(pv);
            }

            if(depends_on!=null && depends_on.trim().length()>0)
            {
                services.setDepends_on(getArrayString(depends_on));
            }

            deploy deploy = new deploy();

            if(restart_policy!=null && restart_policy.trim().length()>0)
            {

                Map<String, Object> m1 = new HashMap<String, Object>();
                if("on-failure".equalsIgnoreCase(restart_policy))
                {

                    deploy.setReplicas(2);

                    m1.put("condition", restart_policy);
                    m1.put("delay", "5s");
                    m1.put("window", "120s");
                    m1.put("max_attempts",Integer.valueOf(3));

                    Map<String, Object> m2 = new HashMap<String, Object>();
                    m2.put("parallelism", Integer.valueOf(2));
                    deploy.setUpdate_config(m2);
                    deploy.setRestart_policy(m1);
                }
                else{
                    m1.put("condition", restart_policy);
                    deploy.setReplicas(1);
                    deploy.setRestart_policy(m1);
                }
            }

            if(constraints!=null && constraints.trim().length()>0)
            {

                placement placement = new placement();
                placement.setConstraints(getArrayString(constraints));
                deploy.setPlacement(placement);

            }

            limits limits = new limits();
            if(cpus!=null && cpus.trim().length()>0)
            {

                limits.setCpus(cpus);

            }

            if(memory!=null && memory.trim().length()>0)
            {
                limits.setMemory(memory);
            }

            reservations reservations = new reservations();

            if(rcpus!=null && rcpus.trim().length()>0)
            {
                reservations.setCpus(rcpus);
            }

            if(rmemory!=null && rmemory.trim().length()>0)
            {
                reservations.setMemory(rmemory);
            }

            resources resources = new resources();


            if(limits.getCpus()!=null || limits.getMemory()!=null) {
                resources.setLimits(limits);
            }

            if(reservations.getMemory()!=null || reservations.getCpus()!=null)
            {
                resources.setReservations(reservations);
            }

            if(resources.getLimits()!=null || resources.getReservations()!=null )
            {
                deploy.setResources(resources);
            }






            services.setDeploy(deploy);

            Map<String,services> mapServices = new HashMap<>();
            mapServices.put(name, services);
            dockerCompose.setServices(mapServices);


            try {
                String output = yaml.dump(dockerCompose);
                output = output.replaceAll("!!z.y.x.docker.DockerCompose","");

                DockerComposeResponse resp = new DockerComposeResponse();
                resp.setSuccess(true);
                resp.setOperation("generate_docker_compose");
                resp.setDockerComposeYaml(output);
                resp.setServiceName(name);
                resp.setImage(image);
                resp.setContainerName(container_name);
                resp.setVersion("3");
                resp.setGeneratedAt(java.time.Instant.now().toString());

                out.println(gson.toJson(resp));
                return;
            } catch (Exception ex) {
                DockerComposeResponse resp = new DockerComposeResponse();
                resp.setSuccess(false);
                resp.setOperation("generate_docker_compose");
                resp.setErrorMessage(ex.getMessage() != null ? ex.getMessage() : "Error generating Docker Compose file");
                out.println(gson.toJson(resp));
                return;
            }
        }
    }

    private void addHorizontalLine(PrintWriter out) {
        out.println("<hr>");
    }

    private String convertYamlToJson(String yaml) throws  Exception {

        ObjectMapper yamlReader = new ObjectMapper(new YAMLFactory());
        Object obj = yamlReader.readValue(yaml, Object.class);

        ObjectMapper jsonWriter = new ObjectMapper();
        return jsonWriter.writeValueAsString(obj);
    }

    private List<String> getListString(String data)
    {
        List<String> list = new ArrayList(Arrays.asList(data.split(" , ")));
        return list;

    }


    private String[] getArrayString(String data,String delimated)
    {
        String [] items = data.split(delimated);
        return items;

    }

    private String[] getArrayString(String data)
    {
        String [] items = data.split("\\s*,\\s*");
        return items;

    }

    private int[] getArrayINT(String data)
    {
        String [] items = data.split("\\s*,\\s*");
        int[] intItems = new int[items.length];

        for (int i=0 ; i< items.length; i++)
        {
            try{

                intItems[i] = Integer.valueOf(items[i]);

            }catch (Exception ex) {}
        }
        return  intItems;
    }

    private Map<String,String> getMapValue(String data)
    {
        String [] items = data.split("\\s*,\\s*");
        Map<String,String> map = new HashMap<>();

        for(String pair : items)
        {
            String[] entry = pair.split("=");
            if(entry.length==2) {
                map.put(entry[0].trim(), entry[1].trim());
            }else if (entry.length<2) {
                map.put(entry[0].trim(), entry[0].trim());
            }
        }
        return map;

    }

}


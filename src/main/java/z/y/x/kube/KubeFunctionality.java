package z.y.x.kube;

/**
 * Created by aninath on 19/02/20.
 */


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

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
import org.yaml.snakeyaml.constructor.Constructor;
import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.NodeId;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;
import org.yaml.snakeyaml.resolver.Resolver;
import z.y.x.docker.Docker;
import z.y.x.kube.deployment.Deployment;
import z.y.x.kube.deployment.selector;
import z.y.x.kube.deployment.template;
import z.y.x.kube.generic.limits;
import z.y.x.kube.generic.requests;
import z.y.x.kube.generic.resources;
import z.y.x.kube.service.Service;
import z.y.x.kube.job.Job;
import z.y.x.kube.job.JobSpec;
import z.y.x.kube.job.CronJob;
import z.y.x.kube.job.CronJobSpec;
import z.y.x.kube.job.JobTemplateSpec;
import z.y.x.kube.configmap.ConfigMap;
import z.y.x.kube.configmap.Secret;

/**
 * Created by aninath on 11/16/17.
 */
public class KubeFunctionality extends HttpServlet {

    private static final long serialVersionUID = 2L;
    private static final String METHOD_POD_GENERATE = "POD_GENERATE";
    private static final String METHOD_SERVICE_GENERATE = "SERVICE_GENERATE";
    private static final String METHOD_CONFIG_GENERATE = "CONFIG_GENERATE";
    private static final String METHOD_KUBE_2_COMPOSE = "KUBE_2_COMPOSE";
    private static final String METHOD_JOB_GENERATE = "JOB_GENERATE";
    private static final String METHOD_CRONJOB_GENERATE = "CRONJOB_GENERATE";
    private static final String METHOD_CONFIGMAP_GENERATE = "CONFIGMAP_GENERATE";
    private static final String METHOD_SECRET_GENERATE = "SECRET_GENERATE";
    private static final String METHOD_STATEFULSET_GENERATE = "STATEFULSET_GENERATE";




    public KubeFunctionality() {

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

        if (METHOD_KUBE_2_COMPOSE.equals(methodName)) {

            String kubestuff = request.getParameter("kubestuff");
            KubernetesResponse resp = new KubernetesResponse();
            resp.setOperation("kubernetes_to_compose");

            if (kubestuff == null || kubestuff.trim().length() == 0) {
                resp.setSuccess(false);
                resp.setErrorMessage("Please provide Kubernetes YAML (Pod, Deployment, StatefulSet, etc.)");
                out.println(gson.toJson(resp));
                return;
            }

            try{
                Kube2Compose kube2compose = new Kube2Compose();
                String output = kube2compose.getCompose(kubestuff);
                
                resp.setSuccess(true);
                resp.setDockerComposeFile(output);
                resp.setKubernetesManifest(kubestuff);
                resp.setGeneratedAt(java.time.Instant.now().toString());
                
                out.println(gson.toJson(resp));
                return;
            }catch (Exception ex)
            {
                resp.setSuccess(false);
                resp.setErrorMessage(ex.getMessage() != null ? ex.getMessage() : "Error converting Kubernetes to Docker Compose");
                out.println(gson.toJson(resp));
                return;
            }
        }

        if (METHOD_CONFIG_GENERATE.equals(methodName)) {
            String dockerstuff = request.getParameter("dockerstuff");
            String addSecurityContextOn = request.getParameter("addSecurityContextOn");
            String generateroption = request.getParameter("generateroption");

            KubernetesResponse resp = new KubernetesResponse();
            resp.setOperation("compose_to_kubernetes");

            if (dockerstuff == null || dockerstuff.trim().length() == 0) {
                resp.setSuccess(false);
                resp.setErrorMessage("Please provide a Docker Compose file or Docker run command");
                out.println(gson.toJson(resp));
                return;
            }

            boolean onPod=false;

            if(addSecurityContextOn!=null && "pod".equalsIgnoreCase(addSecurityContextOn))
            {
                onPod = true;
            }

            boolean podGen =true;
            boolean deployGen=false;
            boolean repliGen=false;
            boolean statefulGen=false;

            if(generateroption!=null)
            {

                if("deployGen".equalsIgnoreCase(generateroption))
                {
                    deployGen=true;
                    podGen=false;
                    repliGen=false;
                    statefulGen=false;
                }

                if("repliGen".equalsIgnoreCase(generateroption))
                {
                    deployGen=false;
                    podGen=false;
                    repliGen=true;
                    statefulGen=false;
                }

                if("statefulGen".equalsIgnoreCase(generateroption))
                {
                    deployGen=false;
                    podGen=false;
                    repliGen=false;
                    statefulGen=true;
                }
            }

            if(dockerstuff.startsWith("docker run"))
            {
                Docker docker = new Docker();
                dockerstuff =  docker.genDockerCompose(dockerstuff);
            }

            try{
                Compose2Kube compose2Kube = new Compose2Kube();
                String output = compose2Kube.getKube(dockerstuff,onPod,podGen,deployGen,repliGen,statefulGen);
                
                resp.setSuccess(true);
                resp.setKubernetesYaml(output);
                resp.setDockerComposeFile(dockerstuff);
                
                // Determine resource type
                if (deployGen) {
                    resp.setResourceType("Deployment");
                } else if (repliGen) {
                    resp.setResourceType("ReplicaSet");
                } else if (statefulGen) {
                    resp.setResourceType("StatefulSet");
                } else {
                    resp.setResourceType("Pod");
                }
                
                // Convert YAML to JSON
                try {
                    String jsonOutput = convertYamlToJson(output);
                    resp.setKubernetesJson(jsonOutput);
                } catch (Exception jsonEx) {
                    // JSON conversion failed, but YAML is still available
                }
                
                resp.setGeneratedAt(java.time.Instant.now().toString());
                
                out.println(gson.toJson(resp));
                return;
            }catch (Exception ex)
            {
                resp.setSuccess(false);
                resp.setErrorMessage(ex.getMessage() != null ? ex.getMessage() : "Error converting Docker Compose to Kubernetes");
                out.println(gson.toJson(resp));
                return;
            }



        }

        if (METHOD_SERVICE_GENERATE.equals(methodName)) {

            String name = request.getParameter("name");
            String namespace = request.getParameter("namespace");
            String type = request.getParameter("type");
            String label = request.getParameter("label");
            String clusterIP = request.getParameter("clusterIP");
            String loadBalancerIP = request.getParameter("loadBalancerIP");
            String externalName = request.getParameter("externalName");


            String portname = request.getParameter("portname");
            String port = request.getParameter("port");
            String targetPort = request.getParameter("targetPort");
            String nodePort = request.getParameter("nodePort");
            String protocol = request.getParameter("protocol");
            String portname1 = request.getParameter("portname1");
            String port1 = request.getParameter("port1");
            String targetPort1 = request.getParameter("targetPort1");
            String nodePort1 = request.getParameter("nodePort1");
            String protocol1 = request.getParameter("protocol1");

            String externalIPs = request.getParameter("externalIPs");
            String sessionAffinity = request.getParameter("sessionAffinity");

            if (name == null || name.trim().length() == 0) {
                name="demo";
            }

            name=name.trim().toLowerCase();

            if (namespace == null || namespace.trim().length() == 0) {
                namespace="default";
            }

            if (type == null || type.trim().length() == 0) {
                type="ClusterIP";
            }


            Yaml yaml = new Compose2Kube().getYaml();

            Service rv = new Service();
            z.y.x.kube.service.spec srvspec = new z.y.x.kube.service.spec();
            List<z.y.x.kube.service.ports> srvportsList  = new ArrayList<>();
            z.y.x.kube.service.ports srvports= new z.y.x.kube.service.ports();


            metadata metadata = new metadata();
            metadata.setName(name);
            metadata.setNamespace(namespace);


            if (label != null && label.trim().length() > 0) {
                srvspec.setSelector(getMapValue(label));
            }

            metadata.setAnnotations(getMapValue("generated=by 8gwifi.org"));


            srvspec.setType(type);

            if(externalIPs!=null && externalIPs.trim().length()>0)
            {
                srvspec.setExternalIPs(getArrayString(externalIPs));
            }

            if(clusterIP!=null && clusterIP.trim().length()>0)
            {
                srvspec.setClusterIP(clusterIP);
            }

            if (sessionAffinity == null || sessionAffinity.trim().length() == 0) {
                sessionAffinity="None";

            }

            srvspec.setSessionAffinity(sessionAffinity);

            if("ExternalName".equalsIgnoreCase(srvspec.getType()))
            {
                if (externalName == null || externalName.trim().length() == 0) {
                    externalName="replace-my.external-service.name";

                }
                srvspec.setExternalName(externalName);
                srvspec.setSelector(null);
            }
            else {

                boolean addports=false;

                if(portname!=null && portname.trim().length()>0)
                {
                    addports=true;
                    srvports.setName(portname);
                }

                if(port!=null && port.trim().length()>0)
                {
                    addports=true;
                    try {
                        srvports.setPort(Integer.valueOf(port));
                    }catch (Exception ex) {}
                }

                if(targetPort!=null && targetPort.trim().length()>0)
                {
                    addports=true;
                    try {
                        srvports.setTargetPort(Integer.valueOf(targetPort));
                    }catch (Exception ex) {}
                }

                if(nodePort!=null && nodePort.trim().length()>0)
                {
                    addports=true;
                    try {
                        srvports.setTargetPort(Integer.valueOf(nodePort));
                    }catch (Exception ex) {}
                }

                if(addports)
                {
                    srvports.setProtocol(protocol);
                    srvportsList.add(srvports);
                }

                srvports= new z.y.x.kube.service.ports();
                addports = false;

                if(portname1!=null && portname1.trim().length()>0)
                {
                    addports=true;
                    srvports.setName(portname1);
                }

                if(port1!=null && port1.trim().length()>0)
                {
                    addports=true;
                    try {
                        srvports.setPort(Integer.valueOf(port1));
                    }catch (Exception ex) {}
                }

                if(targetPort1!=null && targetPort1.trim().length()>0)
                {
                    addports=true;
                    try {
                        srvports.setTargetPort(Integer.valueOf(targetPort1));
                    }catch (Exception ex) {}
                }

                if(nodePort1!=null && nodePort1.trim().length()>0)
                {
                    addports=true;
                    try {
                        srvports.setTargetPort(Integer.valueOf(nodePort1));
                    }catch (Exception ex) {}
                }

                if(addports)
                {
                    srvports.setProtocol(protocol1);
                    srvportsList.add(srvports);
                }

                if(srvportsList.size()>0)
                {
                    srvspec.setPorts(srvportsList);
                }

                if(loadBalancerIP!=null && loadBalancerIP.trim().length()>0)
                {
                    srvspec.setLoadBalancerIP(loadBalancerIP);
                }

                if("None".equalsIgnoreCase(srvspec.getClusterIP()))
                {
                    if("NodePort".equalsIgnoreCase(srvspec.getType()) || "LoadBalancer".equalsIgnoreCase(srvspec.getType()) )
                    {
                        srvspec.setClusterIP(null);
                    }
                }
            }

            rv.setMetadata(metadata);
            rv.setSpec(srvspec);


            String output = yaml.dump(rv);
            output = output.replaceAll("!!z.y.x.kube.service.Service","---");

            KubernetesResponse resp = new KubernetesResponse();
            resp.setSuccess(true);
            resp.setOperation("generate_service");
            resp.setResourceType("Service");
            resp.setKubernetesYaml(output);
            resp.setGeneratedAt(java.time.Instant.now().toString());

            try {
                JSONParser parser = new JSONParser();
                JSONObject json = null;
                try {
                    json = (JSONObject) parser.parse(convertYamlToJson(output));
                } catch (ParseException e) {
                    resp.setSuccess(false);
                    resp.setErrorMessage("Error converting YAML to JSON: " + e.getMessage());
                    out.println(gson.toJson(resp));
                    return;
                }

                gson = new GsonBuilder().setPrettyPrinting().create();
                String prettyJson = gson.toJson(json);
                resp.setKubernetesJson(prettyJson);
            } catch (Exception ex) {
                resp.setSuccess(false);
                resp.setErrorMessage("Error processing JSON: " + ex.getMessage());
            }

            out.println(gson.toJson(resp));
            return;
        }

        if (METHOD_POD_GENERATE.equals(methodName)) {

            String name = request.getParameter("name");
            String namespace = request.getParameter("namespace");
            String annotation = request.getParameter("annotation");
            String label = request.getParameter("label");
            String image = request.getParameter("image");
            String containerName = request.getParameter("containerName");
            String imagePullPolicy = request.getParameter("imagePullPolicy");
            String restartPolicy = request.getParameter("restartPolicy");
            String dnsPolicy = request.getParameter("dnsPolicy");
            String containercommand = request.getParameter("containercommand");
            String containerargs = request.getParameter("containerargs");
            String containerPorts = request.getParameter("containerPorts");
            String volumeMounts = request.getParameter("volumeMounts");
            String env1 = request.getParameter("env1");
            String env2 = request.getParameter("env2");
            String v1 = request.getParameter("v1");
            String v2 = request.getParameter("v2");
            String environment = request.getParameter("environment"); // New key-value format
            String livenessProbepath = request.getParameter("livenessProbepath");
            String livenessProbeport = request.getParameter("livenessProbeport");
            String livenessProbescheme = request.getParameter("livenessProbescheme");
            String readinessProbepath = request.getParameter("readinessProbepath");
            String readinessProbeport = request.getParameter("readinessProbeport");
            String readinessProbescheme = request.getParameter("readinessProbescheme");
            String nameservers = request.getParameter("nameservers");
            String searches = request.getParameter("searches");
            String optionsN = request.getParameter("optionsN");
            String optionsV = request.getParameter("optionsV");
            String subdomain = request.getParameter("subdomain");
            String serviceAccountName = request.getParameter("serviceAccountName");
            String hostname = request.getParameter("hostname");
            String nodeName = request.getParameter("nodeName");
            String apployonPod = request.getParameter("apployonPod");
            String fsGroup = request.getParameter("fsGroup");
            String runAsGroup = request.getParameter("runAsGroup");
            String runAsNonRoot = request.getParameter("runAsNonRoot");
            String runAsUser = request.getParameter("runAsUser");

            // Resource limits/requests (modern K8s best practice)
            String cpuLimit = request.getParameter("cpuLimit");
            String memoryLimit = request.getParameter("memoryLimit");
            String cpuRequest = request.getParameter("cpuRequest");
            String memoryRequest = request.getParameter("memoryRequest");

            // Deployment replicas
            String replicas = request.getParameter("replicas");

            String deploy = request.getParameter("deployment");
          //  System.out.println("deployment " + deploy);



//            System.out.println("annotation " + annotation);
//            System.out.println("label "+ label);
//            System.out.println("apployonPod "+ apployonPod);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);
//            System.out.println(annotation);

            if (image == null || image.trim().length() == 0) {
                KubernetesResponse resp = new KubernetesResponse();
                resp.setSuccess(false);
                resp.setErrorMessage("Docker Image Name is required");
                out.println(gson.toJson(resp));
                return;
            }

            if (name == null || name.trim().length() == 0) {
                name="demo";
            }

            if (containerName == null || containerName.trim().length() == 0) {
                containerName=name;
            }



            Yaml yaml = new Compose2Kube().getYaml();



            metadata metadata = new metadata();


            metadata.setName(name);
            metadata.setNamespace(namespace);



            if (annotation != null && annotation.trim().length() > 0) {
                annotation = annotation + ",generated=by 8gwifi.org";
                metadata.setAnnotations(getMapValue(annotation));
            }
            else {
                metadata.setAnnotations(getMapValue("generated=by 8gwifi.org"));
            }



            if (label != null && label.trim().length() > 0) {
                metadata.setLabels(getMapValue(label));
            }

//           String output = yaml.dump(metadata);
//
//            System.out.println(output);


            Pod pod2 = new Pod();
            spec spec = new spec();


            pod2.setApiVersion("v1");
            pod2.setMetadata(metadata);

            List<containers> containerlist = new ArrayList<>();
            containers c1 = new containers();
            c1.setImage(image);



            c1.setName(containerName);

            if(containerargs!=null && containerargs.trim().length()>0)
            {
                c1.setArgs(getListtring(containerargs));
            }

            if(containercommand!=null && containercommand.trim().length()>0)
            {
                c1.setCommand(getListtring(containercommand));
            }

            List<ports> portslist = new ArrayList<>();

            if(containerPorts!=null && containerPorts.trim().length()>0)
            {
                String [] portarray = getArrayString(containerPorts);

                for (int i=0; i<portarray.length; i++)
                {
                    ports ports = new ports();
                    try{

                        int port = Integer.valueOf(portarray[i]);
                        ports.setContainerPort(port);

                        if(80==port || 8080 == port || 8000 == port || 25 == port || 20 == port || 3389 == port)
                        {
                            ports.setName("http");
                            ports.setProtocol("TCP");


                        }
                        else if(443==port || 4443 == port || 8443 == port)
                        {
                            ports.setName("https");
                            ports.setProtocol("TCP");
                        }

                        else if(53==port)
                        {
                            ports.setName("dns");
                            ports.setProtocol("UDP");
                        }

                        else{
                            ports.setProtocol("TCP");
                            ports.setName("setnamehere");

                        }

                        portslist.add(ports);

                    }catch (Exception ex)
                    {

                    }
                }
            }

            if(portslist.size()>0)
            {
                c1.setPorts(portslist);
            }

            c1.setImagePullPolicy(imagePullPolicy);

            // Set resource limits and requests (modern K8s best practice)
            boolean hasLimits = (cpuLimit != null && cpuLimit.trim().length() > 0) ||
                               (memoryLimit != null && memoryLimit.trim().length() > 0);
            boolean hasRequests = (cpuRequest != null && cpuRequest.trim().length() > 0) ||
                                 (memoryRequest != null && memoryRequest.trim().length() > 0);

            if (hasLimits || hasRequests) {
                resources res = new resources();

                if (hasLimits) {
                    limits lim = new limits();
                    if (cpuLimit != null && cpuLimit.trim().length() > 0) {
                        lim.setCpu(cpuLimit.trim());
                    }
                    if (memoryLimit != null && memoryLimit.trim().length() > 0) {
                        lim.setMemory(memoryLimit.trim());
                    }
                    res.setLimits(lim);
                }

                if (hasRequests) {
                    requests req = new requests();
                    if (cpuRequest != null && cpuRequest.trim().length() > 0) {
                        req.setCpu(cpuRequest.trim());
                    }
                    if (memoryRequest != null && memoryRequest.trim().length() > 0) {
                        req.setMemory(memoryRequest.trim());
                    }
                    res.setRequests(req);
                }

                c1.setResources(res);
            }

            containerlist.add(c1);


            List<env> envlist = new ArrayList<>();

            // Handle new key-value format (environment=KEY=value,KEY2=value2)
            if(environment != null && environment.trim().length() > 0) {
                String[] envPairs = environment.split(",");
                for(String pair : envPairs) {
                    if(pair != null && pair.trim().length() > 0) {
                        String[] kv = pair.split("=", 2);
                        if(kv.length == 2) {
                            env env = new env();
                            env.setName(kv[0].trim());
                            env.setValue(kv[1].trim());
                            envlist.add(env);
                        }
                    }
                }
            }
            
            // Fallback to old format for backward compatibility
            if(envlist.size() == 0) {
                if(env1!=null && env1.trim().length()>0)
                {
                    if(v1!=null && v1.trim().length()>0)
                    {
                        env env = new env();
                        env.setName(env1);
                        env.setValue(v1);
                        envlist.add(env);
                    }
                }

                if(env2!=null && env2.trim().length()>0)
                {
                    if(v2!=null && v2.trim().length()>0)
                    {
                        env env = new env();
                        env.setName(env2);
                        env.setValue(v2);
                        envlist.add(env);
                    }
                }
            }

            if(envlist.size()>0)
            {
                c1.setEnv(envlist);
            }

            if(volumeMounts!=null && volumeMounts.trim().length()>0)
            {

                List<volumeMounts> volumeMountslist = new ArrayList<>();
                List<volumes> volumeList = new ArrayList<>();

                String[] arr = getArrayString(volumeMounts);
                for(int i=0; i<arr.length;i++)
                {

                    String mntPATH = arr[i];
                    String mntName =  RandomStringUtils.randomAlphabetic(6).toLowerCase();
                    volumeMounts volumeMount = new volumeMounts();
                    volumeMount.setName(mntName);
                    volumeMount.setMountPath(mntPATH);
                    volumeMountslist.add(volumeMount);

                    hostPath hostPath = new hostPath();
                    hostPath.setPath("/var/lib/data-"+RandomStringUtils.randomNumeric(3));
                    volumes volumes = new volumes();
                    volumes.setHostPath(hostPath);
                    volumes.setName(mntName);
                    volumeList.add(volumes);

                }
                c1.setVolumeMounts(volumeMountslist);
                spec.setVolumes(volumeList);
            }






            httpGet httpGet = new httpGet();

            if(livenessProbepath!=null && livenessProbepath.trim().length()>0)
            {
                httpGet.setPath(livenessProbepath);
            }

            if(livenessProbeport!=null && livenessProbeport.trim().length()>0)
            {
                try {
                    httpGet.setPort(Integer.valueOf(livenessProbeport));
                }catch (Exception ex) {}
            }

            if(livenessProbescheme!=null && livenessProbescheme.trim().length()>0)
            {
                httpGet.setScheme(livenessProbescheme);
            }

            livenessProbe livenessProbe = new livenessProbe();

            if(httpGet.getPath()!=null)
            {
                livenessProbe.setHttpGet(httpGet);
                c1.setLivenessProbe(livenessProbe);
            }



            readinessProbe readinessProbe = new readinessProbe();

            httpGet = new httpGet();



            if(readinessProbepath!=null && readinessProbepath.trim().length()>0)
            {
                httpGet.setPath(readinessProbepath);
            }

            if(readinessProbeport!=null && readinessProbeport.trim().length()>0)
            {
                try {
                    httpGet.setPort(Integer.valueOf(readinessProbeport));
                }catch (Exception ex) {}
            }

            if(readinessProbescheme!=null && readinessProbescheme.trim().length()>0)
            {
                httpGet.setScheme(livenessProbescheme);
            }

            if(httpGet.getPath()!=null)
            {
                readinessProbe.setHttpGet(httpGet);
                c1.setReadinessProbe(readinessProbe);
            }

            dnsConfig dnsConfig = new dnsConfig();

            boolean dnsflag =false;



            if(nameservers!=null && nameservers.trim().length()>0)
            {
                dnsConfig.setNameservers(getArrayString(nameservers));
                dnsflag=true;
            }

            if(searches!=null && searches.trim().length()>0)
            {
                dnsConfig.setSearches(getArrayString(searches));
                dnsflag=true;
            }

            List<options> optionslist = new ArrayList<>();
            options options2 = new options();

            if(optionsN!=null && optionsN.trim().length()>0)
            {
                options2.setName(optionsN);
                dnsflag=true;
            }

            if(optionsV!=null && optionsV.trim().length()>0)
            {
                options2.setValue(optionsV);
                dnsflag=true;
            }

            if(dnsflag)
            {
                optionslist.add(options2);
                dnsConfig.setOptions(optionslist);
                spec.setDnsConfig(dnsConfig);
            }



            boolean flag = false;
            securityContext securityContext = new securityContext();

            try{


                //            String apployonPod = request.getParameter("apployonPod");
//            String fsGroup = request.getParameter("fsGroup");
//            String runAsGroup = request.getParameter("runAsGroup");
//            String runAsNonRoot = request.getParameter("runAsNonRoot");
//            String runAsUser = request.getParameter("runAsUser");



                if(fsGroup!=null && fsGroup.trim().length()>0)
                {
                    securityContext.setFsGroup(Integer.valueOf(fsGroup));
                    flag=true;
                }

                if(runAsGroup!=null && runAsGroup.trim().length()>0)
                {
                    securityContext.setRunAsGroup(Integer.valueOf(runAsGroup));
                    flag=true;
                }

                if(runAsNonRoot!=null && runAsNonRoot.trim().length()>0)
                {
                    runAsNonRoot = runAsNonRoot.trim().toLowerCase();
                    if("true".equalsIgnoreCase(runAsNonRoot))
                    {
                        securityContext.setRunAsNonRoot(true);
                    }
                    flag=true;

                }

                if(runAsUser!=null && runAsUser.trim().length()>0)
                {
                    securityContext.setRunAsUser(Integer.valueOf(runAsUser));
                    flag=true;
                }

            }catch (Exception ex)
            {

            }


            if("apployonPod".equalsIgnoreCase(apployonPod))
            {
                if(flag)
                {
                    spec.setSecurityContext(securityContext);
                }

            }
            else{
                if(flag) {
                    c1.setSecurityContext(securityContext);
                }
            }


            spec.setDnsPolicy(dnsPolicy);
            spec.setRestartPolicy(restartPolicy);
            spec.setNodeName(nodeName);
            spec.setHostname(hostname);
            spec.setSubdomain(subdomain);
            spec.setServiceAccountName(serviceAccountName);
            spec.setContainers(containerlist);


            pod2.setSpec(spec);

            String output = yaml.dump(pod2);

            output = output.replaceAll("!!z.y.x.kube.Pod","---");

           // System.out.println(output);

            if("pod".equalsIgnoreCase(deploy)) {
                KubernetesResponse resp = new KubernetesResponse();
                resp.setSuccess(true);
                resp.setOperation("generate_pod");
                resp.setResourceType("Pod");
                resp.setKubernetesYaml(output);
                resp.setGeneratedAt(java.time.Instant.now().toString());

                try {
                    JSONParser parser = new JSONParser();
                    JSONObject json = null;
                    try {
                        json = (JSONObject) parser.parse(convertYamlToJson(output));
                    } catch (ParseException e) {
                        resp.setSuccess(false);
                        resp.setErrorMessage("Error converting YAML to JSON: " + e.getMessage());
                        out.println(gson.toJson(resp));
                        return;
                    }

                    gson = new GsonBuilder().setPrettyPrinting().create();
                    String prettyJson = gson.toJson(json);
                    resp.setKubernetesJson(prettyJson);
                } catch (Exception ex) {
                    resp.setSuccess(false);
                    resp.setErrorMessage("Error processing JSON: " + ex.getMessage());
                }

                out.println(gson.toJson(resp));
                return;
            }

            if("deployment".equalsIgnoreCase(deploy))
            {
                Deployment deployment = new Deployment();
                z.y.x.kube.deployment.spec specd = new z.y.x.kube.deployment.spec();
                selector selector = new selector();
                template template = new template();

                metadata = new metadata();


                metadata.setName(name);
                metadata.setNamespace(namespace);




                if (annotation != null && annotation.trim().length() > 0) {
                    metadata.setAnnotations(getMapValue(annotation));
                }



                if (label != null && label.trim().length() > 0) {
                   // metadata.setLabels(getMapValue(label));
                    selector.setMatchLabels(getMapValue(label));
                    deployment.setMetadata(metadata);
                    metadata = new metadata();
                    metadata.setLabels(getMapValue(label));
                    template.setMetadata(metadata);

                }



                specd.setSelector(selector);
                template.setSpec(spec);

                // Set replicas (default 1, configurable)
                if (replicas != null && replicas.trim().length() > 0) {
                    try {
                        int replicaCount = Integer.parseInt(replicas.trim());
                        if (replicaCount > 0) {
                            specd.setReplicas(replicaCount);
                        }
                    } catch (NumberFormatException e) {
                        // Keep default of 1
                    }
                }

                specd.setTemplate(template);

                deployment.setSpec(specd);

                output = yaml.dump(deployment);

                output = output.replaceAll("!!z.y.x.kube.deployment.Deployment","---");

                KubernetesResponse resp = new KubernetesResponse();
                resp.setSuccess(true);
                resp.setOperation("generate_deployment");
                resp.setResourceType("Deployment");
                resp.setKubernetesYaml(output);
                resp.setGeneratedAt(java.time.Instant.now().toString());

                try {
                    JSONParser parser = new JSONParser();
                    JSONObject json = null;
                    try {
                        json = (JSONObject) parser.parse(convertYamlToJson(output));
                    } catch (ParseException e) {
                        resp.setSuccess(false);
                        resp.setErrorMessage("Error converting YAML to JSON: " + e.getMessage());
                        out.println(gson.toJson(resp));
                        return;
                    }

                    gson = new GsonBuilder().setPrettyPrinting().create();
                    String prettyJson = gson.toJson(json);
                    resp.setKubernetesJson(prettyJson);
                } catch (Exception ex) {
                    resp.setSuccess(false);
                    resp.setErrorMessage("Error processing JSON: " + ex.getMessage());
                }

                out.println(gson.toJson(resp));
                return;
            }




        }

        // Job Generation Handler
        if (METHOD_JOB_GENERATE.equals(methodName)) {
            String name = request.getParameter("name");
            String namespace = request.getParameter("namespace");
            String image = request.getParameter("image");
            String containerName = request.getParameter("containerName");
            String containercommand = request.getParameter("containercommand");
            String containerargs = request.getParameter("containerargs");
            String backoffLimit = request.getParameter("backoffLimit");
            String completions = request.getParameter("completions");
            String parallelism = request.getParameter("parallelism");
            String activeDeadlineSeconds = request.getParameter("activeDeadlineSeconds");
            String ttlSecondsAfterFinished = request.getParameter("ttlSecondsAfterFinished");
            String restartPolicy = request.getParameter("restartPolicy");
            String label = request.getParameter("label");
            String environment = request.getParameter("environment");

            KubernetesResponse resp = new KubernetesResponse();
            resp.setOperation("generate_job");
            resp.setResourceType("Job");

            if (image == null || image.trim().length() == 0) {
                resp.setSuccess(false);
                resp.setErrorMessage("Docker Image Name is required");
                out.println(gson.toJson(resp));
                return;
            }

            if (name == null || name.trim().length() == 0) {
                name = "demo-job";
            }
            name = name.trim().toLowerCase();

            if (containerName == null || containerName.trim().length() == 0) {
                containerName = name;
            }

            if (namespace == null || namespace.trim().length() == 0) {
                namespace = "default";
            }

            if (restartPolicy == null || restartPolicy.trim().length() == 0) {
                restartPolicy = "Never";
            }

            Yaml yaml = new Compose2Kube().getYaml();

            Job job = new Job();
            JobSpec jobSpec = new JobSpec();
            template template = new template();
            spec podSpec = new spec();

            metadata metadata = new metadata();
            metadata.setName(name);
            metadata.setNamespace(namespace);
            metadata.setAnnotations(getMapValue("generated=by 8gwifi.org"));

            if (label != null && label.trim().length() > 0) {
                metadata.setLabels(getMapValue(label));
            }

            job.setMetadata(metadata);

            // Container setup
            List<containers> containerlist = new ArrayList<>();
            containers c1 = new containers();
            c1.setImage(image);
            c1.setName(containerName);

            if (containercommand != null && containercommand.trim().length() > 0) {
                c1.setCommand(getListtring(containercommand));
            }
            if (containerargs != null && containerargs.trim().length() > 0) {
                c1.setArgs(getListtring(containerargs));
            }

            // Environment variables
            if (environment != null && environment.trim().length() > 0) {
                List<env> envlist = new ArrayList<>();
                String[] envPairs = environment.split(",");
                for (String pair : envPairs) {
                    if (pair != null && pair.trim().length() > 0) {
                        String[] kv = pair.split("=", 2);
                        if (kv.length == 2) {
                            env env = new env();
                            env.setName(kv[0].trim());
                            env.setValue(kv[1].trim());
                            envlist.add(env);
                        }
                    }
                }
                if (envlist.size() > 0) {
                    c1.setEnv(envlist);
                }
            }

            containerlist.add(c1);
            podSpec.setContainers(containerlist);
            podSpec.setRestartPolicy(restartPolicy);

            template.setSpec(podSpec);

            // Set template metadata with labels for selector
            if (label != null && label.trim().length() > 0) {
                metadata templateMeta = new metadata();
                templateMeta.setLabels(getMapValue(label));
                template.setMetadata(templateMeta);
            }

            jobSpec.setTemplate(template);

            // Job specific settings
            if (backoffLimit != null && backoffLimit.trim().length() > 0) {
                try {
                    jobSpec.setBackoffLimit(Integer.valueOf(backoffLimit.trim()));
                } catch (NumberFormatException e) {}
            }
            if (completions != null && completions.trim().length() > 0) {
                try {
                    jobSpec.setCompletions(Integer.valueOf(completions.trim()));
                } catch (NumberFormatException e) {}
            }
            if (parallelism != null && parallelism.trim().length() > 0) {
                try {
                    jobSpec.setParallelism(Integer.valueOf(parallelism.trim()));
                } catch (NumberFormatException e) {}
            }
            if (activeDeadlineSeconds != null && activeDeadlineSeconds.trim().length() > 0) {
                try {
                    jobSpec.setActiveDeadlineSeconds(Integer.valueOf(activeDeadlineSeconds.trim()));
                } catch (NumberFormatException e) {}
            }
            if (ttlSecondsAfterFinished != null && ttlSecondsAfterFinished.trim().length() > 0) {
                try {
                    jobSpec.setTtlSecondsAfterFinished(Integer.valueOf(ttlSecondsAfterFinished.trim()));
                } catch (NumberFormatException e) {}
            }

            job.setSpec(jobSpec);

            String output = yaml.dump(job);
            output = output.replaceAll("!!z.y.x.kube.job.Job", "---");

            resp.setSuccess(true);
            resp.setKubernetesYaml(output);
            resp.setGeneratedAt(java.time.Instant.now().toString());

            try {
                JSONParser parser = new JSONParser();
                JSONObject json = (JSONObject) parser.parse(convertYamlToJson(output));
                gson = new GsonBuilder().setPrettyPrinting().create();
                resp.setKubernetesJson(gson.toJson(json));
            } catch (Exception ex) {
                // JSON conversion failed
            }

            out.println(gson.toJson(resp));
            return;
        }

        // CronJob Generation Handler
        if (METHOD_CRONJOB_GENERATE.equals(methodName)) {
            String name = request.getParameter("name");
            String namespace = request.getParameter("namespace");
            String image = request.getParameter("image");
            String containerName = request.getParameter("containerName");
            String containercommand = request.getParameter("containercommand");
            String containerargs = request.getParameter("containerargs");
            String schedule = request.getParameter("schedule");
            String concurrencyPolicy = request.getParameter("concurrencyPolicy");
            String successfulJobsHistoryLimit = request.getParameter("successfulJobsHistoryLimit");
            String failedJobsHistoryLimit = request.getParameter("failedJobsHistoryLimit");
            String startingDeadlineSeconds = request.getParameter("startingDeadlineSeconds");
            String backoffLimit = request.getParameter("backoffLimit");
            String restartPolicy = request.getParameter("restartPolicy");
            String label = request.getParameter("label");
            String environment = request.getParameter("environment");

            KubernetesResponse resp = new KubernetesResponse();
            resp.setOperation("generate_cronjob");
            resp.setResourceType("CronJob");

            if (image == null || image.trim().length() == 0) {
                resp.setSuccess(false);
                resp.setErrorMessage("Docker Image Name is required");
                out.println(gson.toJson(resp));
                return;
            }

            if (schedule == null || schedule.trim().length() == 0) {
                resp.setSuccess(false);
                resp.setErrorMessage("Cron Schedule is required (e.g., */5 * * * *)");
                out.println(gson.toJson(resp));
                return;
            }

            if (name == null || name.trim().length() == 0) {
                name = "demo-cronjob";
            }
            name = name.trim().toLowerCase();

            if (containerName == null || containerName.trim().length() == 0) {
                containerName = name;
            }

            if (namespace == null || namespace.trim().length() == 0) {
                namespace = "default";
            }

            if (restartPolicy == null || restartPolicy.trim().length() == 0) {
                restartPolicy = "OnFailure";
            }

            if (concurrencyPolicy == null || concurrencyPolicy.trim().length() == 0) {
                concurrencyPolicy = "Allow";
            }

            Yaml yaml = new Compose2Kube().getYaml();

            CronJob cronJob = new CronJob();
            CronJobSpec cronJobSpec = new CronJobSpec();
            JobTemplateSpec jobTemplate = new JobTemplateSpec();
            JobSpec jobSpec = new JobSpec();
            template template = new template();
            spec podSpec = new spec();

            metadata metadata = new metadata();
            metadata.setName(name);
            metadata.setNamespace(namespace);
            metadata.setAnnotations(getMapValue("generated=by 8gwifi.org"));

            if (label != null && label.trim().length() > 0) {
                metadata.setLabels(getMapValue(label));
            }

            cronJob.setMetadata(metadata);

            // Container setup
            List<containers> containerlist = new ArrayList<>();
            containers c1 = new containers();
            c1.setImage(image);
            c1.setName(containerName);

            if (containercommand != null && containercommand.trim().length() > 0) {
                c1.setCommand(getListtring(containercommand));
            }
            if (containerargs != null && containerargs.trim().length() > 0) {
                c1.setArgs(getListtring(containerargs));
            }

            // Environment variables
            if (environment != null && environment.trim().length() > 0) {
                List<env> envlist = new ArrayList<>();
                String[] envPairs = environment.split(",");
                for (String pair : envPairs) {
                    if (pair != null && pair.trim().length() > 0) {
                        String[] kv = pair.split("=", 2);
                        if (kv.length == 2) {
                            env env = new env();
                            env.setName(kv[0].trim());
                            env.setValue(kv[1].trim());
                            envlist.add(env);
                        }
                    }
                }
                if (envlist.size() > 0) {
                    c1.setEnv(envlist);
                }
            }

            containerlist.add(c1);
            podSpec.setContainers(containerlist);
            podSpec.setRestartPolicy(restartPolicy);

            template.setSpec(podSpec);

            if (label != null && label.trim().length() > 0) {
                metadata templateMeta = new metadata();
                templateMeta.setLabels(getMapValue(label));
                template.setMetadata(templateMeta);
            }

            jobSpec.setTemplate(template);

            if (backoffLimit != null && backoffLimit.trim().length() > 0) {
                try {
                    jobSpec.setBackoffLimit(Integer.valueOf(backoffLimit.trim()));
                } catch (NumberFormatException e) {}
            }

            jobTemplate.setSpec(jobSpec);

            cronJobSpec.setSchedule(schedule.trim());
            cronJobSpec.setConcurrencyPolicy(concurrencyPolicy);
            cronJobSpec.setJobTemplate(jobTemplate);

            if (successfulJobsHistoryLimit != null && successfulJobsHistoryLimit.trim().length() > 0) {
                try {
                    cronJobSpec.setSuccessfulJobsHistoryLimit(Integer.valueOf(successfulJobsHistoryLimit.trim()));
                } catch (NumberFormatException e) {}
            }
            if (failedJobsHistoryLimit != null && failedJobsHistoryLimit.trim().length() > 0) {
                try {
                    cronJobSpec.setFailedJobsHistoryLimit(Integer.valueOf(failedJobsHistoryLimit.trim()));
                } catch (NumberFormatException e) {}
            }
            if (startingDeadlineSeconds != null && startingDeadlineSeconds.trim().length() > 0) {
                try {
                    cronJobSpec.setStartingDeadlineSeconds(Integer.valueOf(startingDeadlineSeconds.trim()));
                } catch (NumberFormatException e) {}
            }

            cronJob.setSpec(cronJobSpec);

            String output = yaml.dump(cronJob);
            output = output.replaceAll("!!z.y.x.kube.job.CronJob", "---");

            resp.setSuccess(true);
            resp.setKubernetesYaml(output);
            resp.setGeneratedAt(java.time.Instant.now().toString());

            try {
                JSONParser parser = new JSONParser();
                JSONObject json = (JSONObject) parser.parse(convertYamlToJson(output));
                gson = new GsonBuilder().setPrettyPrinting().create();
                resp.setKubernetesJson(gson.toJson(json));
            } catch (Exception ex) {
                // JSON conversion failed
            }

            out.println(gson.toJson(resp));
            return;
        }

        // ConfigMap Generation Handler
        if (METHOD_CONFIGMAP_GENERATE.equals(methodName)) {
            String name = request.getParameter("name");
            String namespace = request.getParameter("namespace");
            String data = request.getParameter("data");
            String immutable = request.getParameter("immutable");
            String label = request.getParameter("label");

            KubernetesResponse resp = new KubernetesResponse();
            resp.setOperation("generate_configmap");
            resp.setResourceType("ConfigMap");

            if (name == null || name.trim().length() == 0) {
                name = "demo-configmap";
            }
            name = name.trim().toLowerCase();

            if (namespace == null || namespace.trim().length() == 0) {
                namespace = "default";
            }

            Yaml yaml = new Compose2Kube().getYaml();

            ConfigMap configMap = new ConfigMap();

            metadata metadata = new metadata();
            metadata.setName(name);
            metadata.setNamespace(namespace);
            metadata.setAnnotations(getMapValue("generated=by 8gwifi.org"));

            if (label != null && label.trim().length() > 0) {
                metadata.setLabels(getMapValue(label));
            }

            configMap.setMetadata(metadata);

            if (data != null && data.trim().length() > 0) {
                configMap.setData(getMapValue(data));
            }

            if ("true".equalsIgnoreCase(immutable)) {
                configMap.setImmutable(true);
            }

            String output = yaml.dump(configMap);
            output = output.replaceAll("!!z.y.x.kube.configmap.ConfigMap", "---");

            resp.setSuccess(true);
            resp.setKubernetesYaml(output);
            resp.setGeneratedAt(java.time.Instant.now().toString());

            try {
                JSONParser parser = new JSONParser();
                JSONObject json = (JSONObject) parser.parse(convertYamlToJson(output));
                gson = new GsonBuilder().setPrettyPrinting().create();
                resp.setKubernetesJson(gson.toJson(json));
            } catch (Exception ex) {
                // JSON conversion failed
            }

            out.println(gson.toJson(resp));
            return;
        }

        // Secret Generation Handler
        if (METHOD_SECRET_GENERATE.equals(methodName)) {
            String name = request.getParameter("name");
            String namespace = request.getParameter("namespace");
            String data = request.getParameter("data");
            String secretType = request.getParameter("secretType");
            String immutable = request.getParameter("immutable");
            String label = request.getParameter("label");

            KubernetesResponse resp = new KubernetesResponse();
            resp.setOperation("generate_secret");
            resp.setResourceType("Secret");

            if (name == null || name.trim().length() == 0) {
                name = "demo-secret";
            }
            name = name.trim().toLowerCase();

            if (namespace == null || namespace.trim().length() == 0) {
                namespace = "default";
            }

            if (secretType == null || secretType.trim().length() == 0) {
                secretType = "Opaque";
            }

            Yaml yaml = new Compose2Kube().getYaml();

            Secret secret = new Secret();

            metadata metadata = new metadata();
            metadata.setName(name);
            metadata.setNamespace(namespace);
            metadata.setAnnotations(getMapValue("generated=by 8gwifi.org"));

            if (label != null && label.trim().length() > 0) {
                metadata.setLabels(getMapValue(label));
            }

            secret.setMetadata(metadata);
            secret.setType(secretType);

            // Parse data based on secret type
            if (data != null && data.trim().length() > 0) {
                Map<String, String> secretData = new HashMap<>();

                if ("kubernetes.io/tls".equals(secretType)) {
                    // TLS secrets: parse tls.crt and tls.key separately (they contain special chars)
                    String[] parts = data.split(",tls\\.key=", 2);
                    if (parts.length == 2) {
                        String certPart = parts[0];
                        String keyPart = parts[1];
                        if (certPart.startsWith("tls.crt=")) {
                            secretData.put("tls.crt", certPart.substring(8));
                        }
                        secretData.put("tls.key", keyPart);
                    } else if (data.startsWith("tls.crt=")) {
                        secretData.put("tls.crt", data.substring(8));
                    } else if (data.startsWith("tls.key=")) {
                        secretData.put("tls.key", data.substring(8));
                    }
                } else if ("kubernetes.io/ssh-auth".equals(secretType)) {
                    // SSH secrets: the value is the entire key after "ssh-privatekey="
                    if (data.startsWith("ssh-privatekey=")) {
                        secretData.put("ssh-privatekey", data.substring(15));
                    }
                } else if ("kubernetes.io/dockerconfigjson".equals(secretType)) {
                    // Docker registry: the value is JSON after ".dockerconfigjson="
                    if (data.startsWith(".dockerconfigjson=")) {
                        secretData.put(".dockerconfigjson", data.substring(18));
                    }
                } else {
                    // Opaque and basic-auth: use standard key=value,key2=value2 parsing
                    secretData = getMapValue(data);
                }

                secret.setStringData(secretData);
            }

            if ("true".equalsIgnoreCase(immutable)) {
                secret.setImmutable(true);
            }

            String output = yaml.dump(secret);
            output = output.replaceAll("!!z.y.x.kube.configmap.Secret", "---");

            resp.setSuccess(true);
            resp.setKubernetesYaml(output);
            resp.setGeneratedAt(java.time.Instant.now().toString());

            try {
                JSONParser parser = new JSONParser();
                JSONObject json = (JSONObject) parser.parse(convertYamlToJson(output));
                gson = new GsonBuilder().setPrettyPrinting().create();
                resp.setKubernetesJson(gson.toJson(json));
            } catch (Exception ex) {
                // JSON conversion failed
            }

            out.println(gson.toJson(resp));
            return;
        }

        // StatefulSet Generation Handler
        if (METHOD_STATEFULSET_GENERATE.equals(methodName)) {
            String name = request.getParameter("name");
            String namespace = request.getParameter("namespace");
            String image = request.getParameter("image");
            String containerName = request.getParameter("containerName");
            String containerPorts = request.getParameter("containerPorts");
            String replicas = request.getParameter("replicas");
            String serviceName = request.getParameter("serviceName");
            String podManagementPolicy = request.getParameter("podManagementPolicy");
            String label = request.getParameter("label");
            String environment = request.getParameter("environment");
            String volumeMounts = request.getParameter("volumeMounts");
            String cpuRequest = request.getParameter("cpuRequest");
            String memoryRequest = request.getParameter("memoryRequest");
            String cpuLimit = request.getParameter("cpuLimit");
            String memoryLimit = request.getParameter("memoryLimit");

            KubernetesResponse resp = new KubernetesResponse();
            resp.setOperation("generate_statefulset");
            resp.setResourceType("StatefulSet");

            if (image == null || image.trim().length() == 0) {
                resp.setSuccess(false);
                resp.setErrorMessage("Docker Image Name is required");
                out.println(gson.toJson(resp));
                return;
            }

            if (name == null || name.trim().length() == 0) {
                name = "demo-statefulset";
            }
            name = name.trim().toLowerCase();

            if (containerName == null || containerName.trim().length() == 0) {
                containerName = name;
            }

            if (namespace == null || namespace.trim().length() == 0) {
                namespace = "default";
            }

            if (serviceName == null || serviceName.trim().length() == 0) {
                serviceName = name + "-svc";
            }

            if (podManagementPolicy == null || podManagementPolicy.trim().length() == 0) {
                podManagementPolicy = "OrderedReady";
            }

            Yaml yaml = new Compose2Kube().getYaml();

            StatefulSet statefulSet = new StatefulSet();
            StatefulSetSpec ssSpec = new StatefulSetSpec();
            selector selector = new selector();
            template template = new template();
            spec podSpec = new spec();

            metadata metadata = new metadata();
            metadata.setName(name);
            metadata.setNamespace(namespace);
            metadata.setAnnotations(getMapValue("generated=by 8gwifi.org"));

            if (label != null && label.trim().length() > 0) {
                metadata.setLabels(getMapValue(label));
                selector.setMatchLabels(getMapValue(label));
            }

            statefulSet.setMetadata(metadata);

            // Container setup
            List<containers> containerlist = new ArrayList<>();
            containers c1 = new containers();
            c1.setImage(image);
            c1.setName(containerName);

            // Ports
            if (containerPorts != null && containerPorts.trim().length() > 0) {
                List<ports> portslist = new ArrayList<>();
                String[] portarray = getArrayString(containerPorts);
                for (int i = 0; i < portarray.length; i++) {
                    try {
                        ports port = new ports();
                        port.setContainerPort(Integer.valueOf(portarray[i]));
                        port.setProtocol("TCP");
                        portslist.add(port);
                    } catch (Exception e) {}
                }
                if (portslist.size() > 0) {
                    c1.setPorts(portslist);
                }
            }

            // Resources
            boolean hasLimits = (cpuLimit != null && cpuLimit.trim().length() > 0) ||
                               (memoryLimit != null && memoryLimit.trim().length() > 0);
            boolean hasRequests = (cpuRequest != null && cpuRequest.trim().length() > 0) ||
                                 (memoryRequest != null && memoryRequest.trim().length() > 0);

            if (hasLimits || hasRequests) {
                resources res = new resources();
                if (hasLimits) {
                    limits lim = new limits();
                    if (cpuLimit != null && cpuLimit.trim().length() > 0) lim.setCpu(cpuLimit.trim());
                    if (memoryLimit != null && memoryLimit.trim().length() > 0) lim.setMemory(memoryLimit.trim());
                    res.setLimits(lim);
                }
                if (hasRequests) {
                    requests req = new requests();
                    if (cpuRequest != null && cpuRequest.trim().length() > 0) req.setCpu(cpuRequest.trim());
                    if (memoryRequest != null && memoryRequest.trim().length() > 0) req.setMemory(memoryRequest.trim());
                    res.setRequests(req);
                }
                c1.setResources(res);
            }

            // Environment variables
            if (environment != null && environment.trim().length() > 0) {
                List<env> envlist = new ArrayList<>();
                String[] envPairs = environment.split(",");
                for (String pair : envPairs) {
                    if (pair != null && pair.trim().length() > 0) {
                        String[] kv = pair.split("=", 2);
                        if (kv.length == 2) {
                            env env = new env();
                            env.setName(kv[0].trim());
                            env.setValue(kv[1].trim());
                            envlist.add(env);
                        }
                    }
                }
                if (envlist.size() > 0) {
                    c1.setEnv(envlist);
                }
            }

            // Volume mounts
            if (volumeMounts != null && volumeMounts.trim().length() > 0) {
                List<volumeMounts> volumeMountslist = new ArrayList<>();
                List<volumes> volumeList = new ArrayList<>();
                String[] arr = getArrayString(volumeMounts);
                for (int i = 0; i < arr.length; i++) {
                    String mntPATH = arr[i];
                    String mntName = "data-" + i;
                    volumeMounts volumeMount = new volumeMounts();
                    volumeMount.setName(mntName);
                    volumeMount.setMountPath(mntPATH);
                    volumeMountslist.add(volumeMount);
                }
                c1.setVolumeMounts(volumeMountslist);
            }

            containerlist.add(c1);
            podSpec.setContainers(containerlist);

            template.setSpec(podSpec);

            if (label != null && label.trim().length() > 0) {
                metadata templateMeta = new metadata();
                templateMeta.setLabels(getMapValue(label));
                template.setMetadata(templateMeta);
            }

            ssSpec.setSelector(selector);
            ssSpec.setTemplate(template);
            ssSpec.setServiceName(serviceName);
            ssSpec.setPodManagementPolicy(podManagementPolicy);

            if (replicas != null && replicas.trim().length() > 0) {
                try {
                    ssSpec.setReplicas(Integer.parseInt(replicas.trim()));
                } catch (NumberFormatException e) {}
            }

            statefulSet.setSpec(ssSpec);

            String output = yaml.dump(statefulSet);
            output = output.replaceAll("!!z.y.x.kube.StatefulSet", "---");

            resp.setSuccess(true);
            resp.setKubernetesYaml(output);
            resp.setGeneratedAt(java.time.Instant.now().toString());

            try {
                JSONParser parser = new JSONParser();
                JSONObject json = (JSONObject) parser.parse(convertYamlToJson(output));
                gson = new GsonBuilder().setPrettyPrinting().create();
                resp.setKubernetesJson(gson.toJson(json));
            } catch (Exception ex) {
                // JSON conversion failed
            }

            out.println(gson.toJson(resp));
            return;
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

    private String[] getArrayString(String data)
    {
        String [] items = data.split("\\s*,\\s*");
        return items;

    }

    private List<String> getListtring(String data)
    {
        String [] items = data.split("\\s*,\\s*");
        return new ArrayList<>(Arrays.asList(data));

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


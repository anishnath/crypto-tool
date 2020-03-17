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
import z.y.x.kube.service.Service;

/**
 * Created by aninath on 11/16/17.
 */
public class KubeFunctionality extends HttpServlet {

    private static final long serialVersionUID = 2L;
    private static final String METHOD_POD_GENERATE = "POD_GENERATE";
    private static final String METHOD_SERVICE_GENERATE = "SERVICE_GENERATE";
    private static final String METHOD_CONFIG_GENERATE = "CONFIG_GENERATE";
    private static final String METHOD_KUBE_2_COMPOSE = "KUBE_2_COMPOSE";




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


        final String methodName = request.getParameter("methodName");


        PrintWriter out = response.getWriter();

        //System.out.println("methodName" + methodName);

        if (METHOD_KUBE_2_COMPOSE.equals(methodName)) {

            String kubestuff = request.getParameter("kubestuff");
            if (kubestuff == null || kubestuff.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> Please input Kube Pod/Deployment/StetfuleSet File</font>");
                return;
            }

            try{
                Kube2Compose kube2compose = new Kube2Compose();
                String output = kube2compose.getCompose(kubestuff);
                out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=35  form=\"X\"> " + output +"</textarea>");
            }catch (Exception ex)
            {
                out.println("<font size=\"2\" color=\"red\"> " + ex + "</font>");
                return;
            }


        }

        if (METHOD_CONFIG_GENERATE.equals(methodName)) {
            String dockerstuff = request.getParameter("dockerstuff");
            String addSecurityContextOn = request.getParameter("addSecurityContextOn");
            String generateroption = request.getParameter("generateroption");

            if (dockerstuff == null || dockerstuff.trim().length() == 0) {
                out.println("<font size=\"2\" color=\"red\"> Please give docker compose file or Docur run Command</font>");
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
                out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=35  form=\"X\"> " + output +"</textarea>");
            }catch (Exception ex)
            {
                out.println("<font size=\"2\" color=\"red\"> " + ex + "</font>");
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

            //System.out.println(output);



                out.println("<h4 class=\"mt-4\">YAML</h4>");
                out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=25  form=\"X\">cat <<EOF | kubectl apply -f -\n" + output + "\n" +
                        "EOF</textarea>");

                try {

                    out.println("<h4 class=\"mt-4\">JSON</h4>");

                    JSONParser parser = new JSONParser();

                    JSONObject json = null;
                    try {
                        json = (JSONObject) parser.parse(convertYamlToJson(output));
                    } catch (ParseException e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"3\" color=\"red\"><b> Problem invalid JSON ["
                                + e

                                + "]</font></b><br>");
                        return;
                    }


                    Gson gson = new GsonBuilder().setPrettyPrinting().create();
                    String prettyJson = gson.toJson(json);


                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=35  form=\"X\"> cat <<EOF | kubectl apply -f -\n " + prettyJson + "\nEOF</textarea>");

                } catch (Exception ex) {

                }

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
                out.println("<font size=\"2\" color=\"red\"> Docker Image Name is Empty </font>");
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

            containerlist.add(c1);


            List<env> envlist = new ArrayList<>();

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

                out.println("<h4 class=\"mt-4\">YAML</h4>");
                out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=30  form=\"X\">cat <<EOF | kubectl apply -f -\n" + output + "\n" +
                        "EOF</textarea>");

                try {

                    out.println("<h4 class=\"mt-4\">JSON</h4>");

                    JSONParser parser = new JSONParser();

                    JSONObject json = null;
                    try {
                        json = (JSONObject) parser.parse(convertYamlToJson(output));
                    } catch (ParseException e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"3\" color=\"red\"><b> Problem invalid JSON ["
                                + e

                                + "]</font></b><br>");
                        return;
                    }


                    Gson gson = new GsonBuilder().setPrettyPrinting().create();
                    String prettyJson = gson.toJson(json);


                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=35  form=\"X\"> cat <<EOF | kubectl apply -f -\n " + prettyJson + "\nEOF</textarea>");

                } catch (Exception ex) {

                }
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

                specd.setTemplate(template);

                deployment.setSpec(specd);

                output = yaml.dump(deployment);

                output = output.replaceAll("!!z.y.x.kube.deployment.Deployment","---");

               // System.out.println(output);


                out.println("<h4 class=\"mt-4\">YAML</h4>");
                out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=30  form=\"X\">cat <<EOF | kubectl apply -f -\n" + output + "\n" +
                        "EOF</textarea>");

                try {

                    out.println("<h4 class=\"mt-4\">JSON</h4>");

                    JSONParser parser = new JSONParser();

                    JSONObject json = null;
                    try {
                        json = (JSONObject) parser.parse(convertYamlToJson(output));
                    } catch (ParseException e) {
                        addHorizontalLine(out);
                        out.println("<font size=\"3\" color=\"red\"><b> Problem invalid JSON ["
                                + e

                                + "]</font></b><br>");
                        return;
                    }


                    Gson gson = new GsonBuilder().setPrettyPrinting().create();
                    String prettyJson = gson.toJson(json);


                    out.println("<textarea class=\"form-control animated\" readonly=\"true\" name=\"comment1\" rows=35  form=\"X\"> cat <<EOF | kubectl apply -f -\n " + prettyJson + "\nEOF</textarea>");

                } catch (Exception ex) {

                }


            }



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


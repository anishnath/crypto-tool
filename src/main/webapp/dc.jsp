<!DOCTYPE html>
<html>
<head>
    <title>docker compose file generator</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="generate docker compose file online, docker-compose.yml file generate "/>
    <meta name="keywords" content="online docker compose file generate, docker compose generate, generate docker-compose file online"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%@ include file="header-script.jsp"%>


    <!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
    <script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "docker compose generator",
  "image" : "https://8gwifi.org/images/site/dc.png",
  "url" : "https://8gwifi.org/dc.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2020-02-26",
  "applicationCategory" : [ "docker compose yaml file" , "generate docker compose file", "docker-compose.yaml file generate online"],
  "downloadUrl" : "https://8gwifi.org/dc.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu",
  "requirements" : "Generate docker compose file onliine ",
  "softwareVersion" : "v1.0"
}
</script>


    <script type="text/javascript">
        $(document).ready(function() {

            $('#generatedc').click(function (event)
            {
                //
                $('#form').delay(200).submit()

            });

            $('#form').submit(function (event)
            {
                //
                $('#output').html('<img src="images/712.GIF"> loading...');
                event.preventDefault();
                $.ajax({
                    type: "POST",
                    url: "DockerFunctionality", //this is my servlet

                    data: $("#form").serialize(),
                    success: function(msg){
                        $('#output').empty();
                        $('#output').append(msg);

                    }
                });
            });
        });

    </script>
</head>
<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Generate Docker Compose YAML File</h1>
<p>This tool will help you to generate docker-compose.yaml using V3</p>
<hr>

<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="" />Loading!
</div>

<%@ include file="footer_adsense.jsp"%>

<form id="form" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="GENERATE_DC">

    <div class="form-row">
        <div class="form-group col-md-4">
            <label for="serviceName">Service Name</label>
            <input type="text" class="form-control form-control-sm" name="serviceName" id="serviceName" placeholder="svcname">
        </div>
        <div class="form-group col-md-4">
            <label for="image">Docker Image</label>
            <input type="text" class="form-control form-control-sm" id="image" name="image" placeholder="nginx">
        </div>
        <div class="form-group col-md-4">
            <label for="container_name">container Name</label>
            <input type="text" class="form-control form-control-sm" id="container_name" name="container_name" placeholder="nginxc">
        </div>
    </div>
    <div class="form-row">
        <div class="form-group col-md-12">
            <label for="entrypoint">Entrypoint</label>
            <input type="text" class="form-control form-control-lg" id="entrypoint" name="entrypoint" placeholder="/code/entrypoint.sh && ls -ltr">
        </div>
    </div>

    <div class="form-row">
        <div class="form-group col-md-12">
            <label for="expose">volumes</label>
            <input type="text" class="form-control form-control-lg" name="volumes" id="volumes" placeholder="db-data:/var/lib/data1,www-data:/var/lib/www">
            <small>To add multiple volume use "," as delimeter</small>
        </div>
    </div>

    <div class="form-row">
        <div class="form-group col-md-6">
            <label for="environment">Environment</label>
            <input type="text" class="form-control form-control-lg" id="environment" name="environment" placeholder="NGINX_PORT=80,NGNIX_HOST=test">
            <small>Format env1=val1,env=val</small>
        </div>
        <div class="form-group col-md-6">
            <label for="labels">Labels </label>
            <input type="text" class="form-control form-control-lg" id="labels" name="labels" placeholder="app=stage,app1=db">
            <small>Format app=nginx,env=staging</small>
        </div>
    </div>
    <div class="form-row">
        <div class="form-group col-md-6">
            <label for="expose">expose</label>
            <input type="text" class="form-control form-control-sm" name="expose" id="expose" placeholder="80,443">
        </div>
        <div class="form-group col-md-6">
            <label for="ports">ports</label>
            <input type="text" class="form-control form-control-sm" name="ports" id="ports" placeholder="8080,8443">
        </div>
    </div>


    <div class="form-row">
        <div class="form-group col-md-3">
            <label for="user">user</label>
            <input type="text" class="form-control form-control-sm" name="user" id="user" placeholder="1000">
        </div>
        <div class="form-group col-md-3">
            <label for="image">working_dir</label>
            <input type="text" class="form-control form-control-sm" id="working_dir" name="working_dir" placeholder="/code">
        </div>
        <div class="form-group col-md-3">
            <label for="container_name">domainname</label>
            <input type="text" class="form-control form-control-sm" id="domainname" name="domainname" placeholder="nginx.8gwifi.org">
        </div>

        <div class="form-group col-md-3">
            <label for="container_name">hostname</label>
            <input type="text" class="form-control form-control-sm" id="hostname" name="hostname" placeholder="nginx-demo">
        </div>

    </div>

    <div class="form-row">
        <div class="form-group col-md-3">
            <label for="ipc">ipc</label>
            <input type="text" class="form-control form-control-sm" name="ipc" id="ipc" placeholder="host">
        </div>

        <div class="form-group col-md-4">
            <label for="mac_address">mac_address</label>
            <input type="text" class="form-control form-control-sm" name="mac_address" id="mac_address" placeholder="8a:ca:58:b9:e9:51">
        </div>

        <div class="form-group col-md-2">
            <label for="privileged">privileged</label>
            <select class="form-control" name="privileged" id="privileged">
                <option value="false" selected >false</option>
                <option value="true">true</option>
            </select>
        </div>

        <div class="form-group col-md-3">
            <label for="restart_policy">restart_policy</label>
            <select class="form-control" name="restart_policy" id="restart_policy">
                <option value="any" selected >any</option>
                <option value="on-failure">on-failure</option>
                <option value="none">none</option>
            </select>
        </div>
    </div>

    <div class="form-row">
        <div class="form-group col-md-3">
            <label for="dns">dns</label>
            <input type="text" class="form-control form-control-sm" name="dns" id="dns" placeholder="8.8.8.8,9.9.9.9">
        </div>
        <div class="form-group col-md-3">
            <label for="dns_search">dns_search</label>
            <input type="text" class="form-control form-control-sm" id="dns_search" name="dns_search" placeholder="dc1.example.com,dc2.example.com">
        </div>
        <div class="form-group col-md-3">
            <label for="links">links</label>
            <input type="text" class="form-control form-control-sm" id="links" name="links" placeholder="db,redis,db:database">
            <small>Link to containers</small>
        </div>
        <div class="form-group col-md-3">
            <label for="depends_on">depends_on</label>
            <input type="text" class="form-control form-control-sm" id="depends_on" name="depends_on" placeholder="db,redis">
            <small>dependent services</small>
        </div>
    </div>

    <div class="form-row">
        <div class="form-group col-md-3">
            <label for="dns">limits CPU</label>
            <input type="text" class="form-control form-control-sm" name="cpus" id="cpus" placeholder="0.50">
        </div>
        <div class="form-group col-md-3">
            <label for="dns_search">limits memory</label>
            <input type="text" class="form-control form-control-sm" id="memory" name="memory" placeholder="50M">
        </div>
        <div class="form-group col-md-3">
            <label for="links">reservations CPU</label>
            <input type="text" class="form-control form-control-sm" id="rcpus" name="rcpus" placeholder="0.25">
        </div>
        <div class="form-group col-md-3">
            <label for="rmemory">reservations Memory</label>
            <input type="text" class="form-control form-control-sm" id="rmemory" name="rmemory" placeholder="20M">
        </div>
    </div>


    <div class="form-row">
        <div class="form-group col-md-9">
            <label for="constraints">placement(constraints)</label>
            <input type="text" class="form-control" name="constraints" id="constraints" placeholder="node.role == manager">
        </div>

        <div class="form-group col-md-5">
            <input class="form-check-input" type="checkbox" value="healthcheck" name="healthcheck" id="healthcheck">
            <label for="healthcheck">Add HealthCheck</label>
        </div>


    </div>



    <input type="button" class="btn btn-primary" id="generatedc" name="Generate docker Compose" value="Generate docker-compose.yml">
</form>

<hr>

<div id="output"></div>

<hr>

<div class="sharethis-inline-share-buttons"></div>

<%@ include file="footer_adsense.jsp"%>

<hr>
<h2 class="mt-4">Try Other Convertor</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="dc1.jsp">Docker run to Docker Compose Conversion</a></li>
            <li><a href="dc2.jsp">Docker Compose to docker run Conversion</a></li>
            <li><a href="dc.jsp">Docker Compose Generator</a></li>
            <li><a href="kube.jsp">Kubertes Spec Generate(Pods/svc)</a></li>
            <li><a href="jsonparser.jsp">JSON-2-YAML Convertor</a></li>
            <li><a href="yamlparser.jsp">YAML-2-JSON Convertor</a></li>
            <li><a href="qrcodegen.jsp">QR Code generate</a></li>
            <li><a href="hexdump.jsp">Online Hexdump Generate</a></li>
            <li><a href="diff.jsp">Compare text differences</a></li>
            <li><a href="UrlEncodeDecodeFunctions.jsp">URL Encoders/Decoders</a></li>
            <li><a href="HexToStringFunctions.jsp">Hex To String Conversion</a></li>
            <li><a href="HexToStringFunctions.jsp">String To Hex Conversion</a></li>
            <li><a href="base64Hex.jsp">Base64 To Hex (ViceVersa)</a></li>
            <li><a href="Base64Functions.jsp">Base64 Encode/Decode</a></li>
            <li><a href="base64image.jsp">Base64 Image Converter(data:image/png)</a></li>
            <li><a href="StringFunctions.jsp">Various String Functions</a></li>
        </ul>
    </div>
</div>

<hr>
<h2 class="mt-4">Kubernetes Topic </h2>
<div>
    <ul>
        <li>
            <a href="docs/ansible-kube-install.jsp">kubernetes install on using ansible</a>
        </li>
        <li>
            <a href="docs/kube-install.jsp">kube install on in centos7/ubuntu7</a>
        </li>
        <li>
            <a href="docs/kube-dash.jsp">kubernetes Dashbaord Setup</a>
        </li>
        <li>
            <a href="docs/kube-pods.jsp">Pod,Cluster,Deploy,ReplicaSet Light Dive</a>
        </li>
        <li>
            <a href="docs/kube-nginx.jsp">kubernetes secure nginx deployment</a>
        </li>
        <li>
            <a href="docs/kube-ports.jsp">kubernetes Port, Targetport and NodePort</a>
        </li>
        <li>
            <a href="docs/kube-namespaces.jsp">kubernetes Namespace</a>
        </li>
        <li>
            <a href="docs/kube-auth.jsp">kubenetes Auth,Authorization,Admission</a>
        </li>
        <li>
            <a href="docs/kube-rbac.jsp">kubernetes Role-Based Access Control</a>
        </li>
        <li>
            <a href="docs/CVE-2018-1002105.jsp">Kubernetes Privilege Escalation Vulnerability</a>
        </li>
        <li>
            <a href="docs/prometheus-dashboard.jsp">Prometheus Dashboard Access</a>
        </li>
        <li>
            <a href="docs/kube-mysql.jsp">Kubernetes mysql installation</a>
        </li>
        <li>
            <a href="docs/kube-jenkins.jsp">Kubernetes Jenkins installation</a>
        </li>
        <li>
            <a href="docs/podman-jenkins.jsp">Podman Jenkins installation</a>
        </li>
        <li>
            <a href="docs/kube-mariadb.jsp">Kubernetes mariadb installation</a>
        </li>
        <li>
            <a href="docs/kube-wordpress.jsp">Kubernetes wordpress installation</a>
        </li>
        <li>
            <a href="docs/kube-drupal.jsp">Kubernetes drupal installation</a>
        </li>
        <li>
            <a href="docs/kube-traefik.jsp">Kubernetes traefik installation</a>
        </li>

        <li>
            <a href="docs/kube-traefik2.jsp">Kubernetes Ingress traefik </a>
        </li>

        <li>
            <a href="docs/kube-debug.jsp">kubernetes service external ip pending ?</a>
        </li>

        <li>
            <a href="docs/kube-Istio.jsp">Service Mesh With Istio</a>
        </li>

        <li>
            <a href="docs/kube-externalname.jsp">Access SVC in Another Namespaces</a>
        </li>

        <li>
            <a href="docs/kube-java.jsp">kubernetes Java client example</a>
        </li>

        <li>
            <a href="docs/kube-lets.jsp">kubernetes letsencrypt deploy wild card certificate</a>
        </li>

        <li>
            <a href="docs/docker-install.jsp">Right Way to Install Docker</a>
        </li>

        <li>
            <a href="docs/docker-privaterepo.jsp">Docker Private repo with SSL and AUTH</a>
        </li>

        <li>
            <a href="docs/docker-baseimage.jsp">Creating Docker Base Image</a>
        </li>

        <li>
            <a href="docs/containers.jsp">Container Runtime (RUNC,RKT,CRI-O,Conatinerd) </a>
        </li>

        <li>
            <a href="docs/podman-install.jsp">Podman Install on Ubuntu/Debian</a>
        </li>
    </ul>
</div>



<hr>


<hr>


<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
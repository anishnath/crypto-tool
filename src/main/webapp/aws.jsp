<!DOCTYPE html>
<html>
<head>
    <title>ansible generator for aws resourses</title>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="generate ansible file for aws resources, aws ansible generator, aws ansible tutorrial, ansible aws tutorial "/>
    <meta name="keywords" content="ansible generator, ansible aws generator, generate ansible files for aws resources"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%@ include file="header-script.jsp"%>


    <!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
    <script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Generate ansible file for AWS reqources",
  "image" : "https://8gwifi.org/images/site/aws.png",
  "url" : "https://8gwifi.org/aws.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2020-12-23",
  "applicationCategory" : [ "ansible generator" , "generate ansible file from your aws resourcs", "aws ansible generator"],
  "downloadUrl" : "https://8gwifi.org/dc.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu,AWS",
  "requirements" : "Generate ansible file for AWS reqources ",
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
                    url: "AWSFunctionality", //this is my servlet

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

<h1 class="mt-4">Generate Ansible file for your AWS Workload</h1>
<p>This tool will help you to generate ansible file for your given AWS resources</p>
<hr>

<div id="loading" style="display: none;">
    <img src="images/712.GIF" alt="" />Loading!
</div>

<%@ include file="footer_adsense.jsp"%>


<form id="form" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="GENERATE_AWS_CONFIG">

    <div class="form-row">
        <div class="form-group col-md-4">
            <label for="serviceName">AWS_ACCESS_KEY_ID</label>
            <input type="password" class="form-control form-control-sm" name="access_key" id="access_key" placeholder="AKIAIOSFODNN7EXAMPLE">
        </div>
        <div class="form-group col-md-4">
            <label for="image">AWS_SECRET_ACCESS_KEY</label>
            <input type="password" class="form-control form-control-sm" id="secret_key" name="secret_key" placeholder="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY">
        </div>
        <div class="form-group col-md-4">
            <label for="container_name">AWS_DEFAULT_REGION</label>
            <select class="form-control" name="region" id="region">
			      <option value="us-west-2" >us-west-2</option>
			     <option value="us-west-1" >us-west-1</option>
			     <option value="us-east-1" >us-east-1</option>
			     <option value="us-east-2" >us-east-2</option>
			     <option value="us-gov-east-1" >us-gov-east-1</option>
			     <option value="eu-west-1" >eu-west-1</option>
			     <option value="eu-west-2" >eu-west-2</option>
			     <option value="eu-west-3" >eu-west-1</option>
			     <option value="eu-central-1" >eu-central-1</option>
			     <option value="eu-north-1" >eu-north-1</option>
			     <option value="eu-south-1" >eu-south-1</option>
			     <option value="ap-southeast-1" >ap-southeast-1</option>
			     <option value="ap-southeast-2" >ap-southeast-2</option>
			     <option value="ap-northeast-1" >ap-northeast-1</option>
			     <option value="ap-northeast-2" >ap-northeast-2</option>
			     <option value="sa-east-1" >sa-east-1</option>
			     <option value="cn-north-1" >cn-north-1</option>
			     <option value="cn-northwest-1" >cn-northwest-1</option>
			     <option value="ca-central-1" >ca-central-1</option>
			     <option value="me-south-1" >me-south-1</option>
			     <option value="af-south-1" >af-south-1</option>
    		</select>
        </div>
       <p class="text-danger"> <small>This site doesn't store any AWS keys, for additional security try with readonly keys only and change it Immediately</small></p>
    </div>
    <div class="form-row">
        <div class="form-group col-md-12">
            <label for="entrypoint">AWS Resource</label>
            <select class="form-control" name="aws_resource" id="exampleFormControlSelect1">
		      <option value="security_group" >Security Group</option>
		      <option value="ec2" >EC2</option>
		      <option value="route53" >Route53</option>
		      <option value="vpc" >VPC</option>
		      <option value="subnet">Subnet</option>
		      <option value="iam-group">IAM(Groups)</option>
    </select>
    <small>Working to bring this feature to all AWS Resources keep check in</small>
        </div>
        
         <div class="form-group col-md-12">
            <label for="filter">Filter</label>
            <input type="text" class="form-control form-control-sm" id="filter" name="filter" placeholder="Give the AWS resources Id's you waana Filter">
            <small>AWS Resources needs to be filter mentions the Id's only in comma separated Value for e.g  sg-aed1,sg-deoa or i-098277,i-0929s92</small>
        </div>
        
    </div>
    <input type="button" class="btn btn-primary" id="generatedc" name="Generate Ansibile Config" value="Generate Ansibile Config">
</form>

<hr>

<div id="output"></div>

<hr>

<div class="sharethis-inline-share-buttons"></div>

<%@ include file="thanks.jsp"%>

<%@ include file="footer_adsense.jsp"%>

<hr>
<h2 class="mt-4">Try Other Convertor</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="dc1.jsp">Docker run to Docker Compose Conversion</a></li>
            <li><a href="dc2.jsp">Docker Compose to docker run Conversion</a></li>
            <li><a href="dc.jsp">Docker Compose Generator</a></li>
            <li><a href="kube1.jsp">Docker Compose to Kubernetes conversion</a></li>
            <li><a href="kube2.jsp">Kubernetes to Docker compose conversion</a></li>
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

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
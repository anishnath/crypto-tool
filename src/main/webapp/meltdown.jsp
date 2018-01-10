<!DOCTYPE html>
<html>
<head>

    <title>Meltdown Spectre Vendor Update</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="meltdown spectre vendor Update Speculative Execution Exploit Performance Impacts - Describing the performance impacts to security patches for CVE-2017-5754 CVE-2017-5753 and CVE-2017-5715, cpu performance issue, XEN, QEMU,VMware,rhel,mozilla,chrome,aws,cloud,azure,digitalocean,antivirus,trendmocro" />
<meta name="keywords" content="Meltdown,Spectre Vendor Patches,XEN, QEMU,VMware,rhel,mozilla,chrome,aws,cloud,azure,digitalocean,antivirus,trendmocro,windows,andorid,minipli patches,Apple" />
<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {
            $('#executeMethod').click(function (event)
            {
 			$('#form').delay(200).submit()
            });
                    
            $('#form').submit(function (event)
                    {
                    //	
                  $('#output').html('<img src="images/712.GIF"> loading...');
         			 event.preventDefault();
                        $.ajax({
                            type: "POST",
                            url: "NetworkFunctionality", //this is my servlet
                
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
<body>
<div id="page">
<%@ include file="include.jsp" %> 
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<article id="contentWrapper" role="main">
        <%@ include file="footer_adsense.jsp" %>
        <section id="content">


                <p>&nbsp;</p>
                <h1 class="display-4 text-left">Meltdown and Spectre Vendor Patches</h1>
                <p><strong>Linux upstream kernel</strong></p>
                <p><a href="https://en.wikipedia.org/wiki/Kernel_page-table_isolation#cite_note-:2-4">Kernel Page Table Isolation</a>&nbsp;is a mitigation in the Linux Kernel, originally named KAISER.</p>
                <ul>
                    <li><a href="https://cdn.kernel.org/pub/linux/kernel/v4.x/ChangeLog-4.14.11">Version 4.14.11</a>contains KPTI.</li>
                    <li><a href="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?h=v4.15-rc6">Version 4.15-rc6</a>contains KPTI.</li>
                    <li>Longterm support kernels&nbsp;<a href="https://cdn.kernel.org/pub/linux/kernel/v4.x/ChangeLog-4.9.75">Version 4.9.75</a>and&nbsp;<a href="https://cdn.kernel.org/pub/linux/kernel/v4.x/ChangeLog-4.4.110">4.4.110</a>&nbsp;contain KPTI backports.</li>
                </ul>
                <p><strong>minipli patches</strong></p>
                <p>minipli is an unofficial fork of the former grsecurity patches (original grsecurity is no longer publicly available). minipli is based on the longterm kernel 4.9, which supports KPTI since 4.9.75, yet the patchset isn't ported yet.</p>
                <ul>
                    <li><a href="https://github.com/minipli/linux-unofficial_grsec/issues/25">bug report with discussion about backporting KPTI</a></li>
                </ul>
                <p><strong>Android</strong></p>
                <ul>
                    <li>Fixed with&nbsp;<a href="https://source.android.com/security/bulletin/2018-01-01">Android Security Bulletin&mdash;January 2018</a>.</li>
                </ul>
                <p><strong>Windows</strong></p>
                <ul>
                    <li><a href="https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/adv180002">Microsoft Advisory</a></li>
                    <li><a href="https://support.microsoft.com/en-gb/help/4072698/windows-server-guidance-to-protect-against-the-speculative-execution-s">Windows Server Guidance</a>and&nbsp;<a href="https://support.microsoft.com/en-gb/help/4073119/windows-client-guidance-for-it-pros-to-protect-against-speculative-exe">Windows Client Guidance</a>. Note: both links include a Powershell tool to query the status of Windows mitigations for CVE-2017-5715 (branch target injection) and CVE-2017-5754 (rogue data cache load).</li>
                </ul>
                <p><strong>Apple</strong></p>
                <p>Apple has already released mitigations in iOS 11.2, macOS 10.13.2, and tvOS 11.2 to help defend against Meltdown. In the coming days they plan to release mitigations in Safari to help defend against Spectre. They continue to develop and test further mitigations for these issues and will release them in upcoming updates of iOS, macOS, tvOS, and watchOS.</p>
                <ul>
                    <li><a href="https://support.apple.com/en-us/HT208394">Official statement</a></li>
                </ul>
                <p>The security patch released on December 6, 2017 includes Meltdown mitigation also for Sierra and El Capitan</p>
                <ul>
                    <li><a href="https://support.apple.com/en-us/HT208331">About the security content of macOS High Sierra 10.13.2, Security Update 2017-002 Sierra, and Security Update 2017-005 El Capitan</a></li>
                </ul>
                <p><strong>Linux distributions</strong></p>
                <ul>
                    <li><a href="https://access.redhat.com/security/vulnerabilities/speculativeexecution">Red Hat Advisory</a></li>
                    <li><a href="https://access.redhat.com/articles/3307751">Speculative Execution Exploit Performance Impacts - Describing the performance impacts to security patches for CVE-2017-5754 CVE-2017-5753 and CVE-2017-5715</a></li>
                    <li>CentOS:</li>
                </ul>
                <p>o&nbsp;&nbsp; 7 -&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022696.html">CESA-2018:0007</a>&nbsp;(kernel),&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022697.html">CESA-2018:0012</a>&nbsp;(microcode_ctl),&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022698.html">CESA-2018:0014</a>&nbsp;(linux-firmware),&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022705.html">CESA-2018:0023</a>(qemu-kvm),&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022704.html">CESA-2018:0029</a>&nbsp;(libvirt)</p>
                <p>o&nbsp;&nbsp; 6 -&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022701.html">CESA-2018:0008</a>&nbsp;(kernel),&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022700.html">CESA-2018:0013</a>&nbsp;(microcode_ctl),&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022702.html">CESA-2018:0024</a>&nbsp;(qemu-kvm),&nbsp;<a href="https://lists.centos.org/pipermail/centos-announce/2018-January/022703.html">CESA-2018:0030</a>(libvirt)</p>
                <ul>
                    <li>Fedora - Fixed in&nbsp;<a href="https://bodhi.fedoraproject.org/updates/FEDORA-2018-8ed5eff2c0">FEDORA-2018-8ed5eff2c0</a>(Fedora 26) and&nbsp;<a href="https://bodhi.fedoraproject.org/updates/FEDORA-2018-22d5fa8a90">FEDORA-2018-22d5fa8a90</a>&nbsp;(Fedora 27).</li>
                    <li>Ubuntu (tl;dr - Ubuntu users of the 64-bit x86 architecture (aka, amd64) can expect updated kernels by the original January 9, 2018 coordinated release date, and sooner if possible.):</li>
                </ul>
                <p>o&nbsp;&nbsp; <a href="https://wiki.ubuntu.com/SecurityTeam/KnowledgeBase/SpectreAndMeltdown">Ubuntu Wiki SecurityTeam KnowledgeBase</a></p>
                <p>o&nbsp;&nbsp; <a href="https://insights.ubuntu.com/2018/01/04/ubuntu-updates-for-the-meltdown-spectre-vulnerabilities/">Ubuntu Insights blog - Ubuntu Updates for the Meltdown / Spectre Vulnerabilities</a></p>
                <p>o&nbsp;&nbsp; <a href="https://people.canonical.com/%7Eubuntu-security/cve/2017/CVE-2017-5753">Details about CVE-2017-5753 (variant 1, aka "Spectre")</a></p>
                <p>o&nbsp;&nbsp; <a href="https://people.canonical.com/%7Eubuntu-security/cve/2017/CVE-2017-5715">Details about CVE-2017-5715 (variant 2, aka "Spectre")</a></p>
                <p>o&nbsp;&nbsp; <a href="https://people.canonical.com/%7Eubuntu-security/cve/2017/CVE-2017-5754.html">Details about CVE-2017-5754 (variant 3, aka "Meltdown")</a></p>
                <ul>
                    <li>Debian: "Meltdown" fixed in stretch (4.9.65-3+deb9u2,&nbsp;<a href="https://security-tracker.debian.org/tracker/DSA-4078-1">DSA-4078-1</a>). "Spectre" mitigations are a work in progress.</li>
                </ul>
                <p>o&nbsp;&nbsp; <a href="https://security-tracker.debian.org/tracker/CVE-2017-5753">Details about CVE-2017-5753 (variant 1, aka "Spectre")</a></p>
                <p>o&nbsp;&nbsp; <a href="https://security-tracker.debian.org/tracker/CVE-2017-5715">Details about CVE-2017-5715 (variant 2, aka "Spectre")</a></p>
                <p>o&nbsp;&nbsp; <a href="https://security-tracker.debian.org/tracker/CVE-2017-5754">Details about CVE-2017-5754 (variant 3, aka "Meltdown")</a></p>
                <ul>
                    <li><a href="https://www.suse.com/c/suse-addresses-meltdown-spectre-vulnerabilities/">SUSE Advisory</a></li>
                    <li>Scientific Linux:</li>
                </ul>
                <p>o&nbsp;&nbsp; 7 -&nbsp;<a href="https://www.scientificlinux.org/category/sl-errata/slsa-20180007-1/">SLSA-2018:0007-1</a>&nbsp;(kernel),&nbsp;<a href="https://www.scientificlinux.org/category/sl-errata/slsa-20180012-1/">SLSA-2018:0012-1</a>&nbsp;(microcode_ctl),&nbsp;<a href="https://www.scientificlinux.org/category/sl-errata/slsa-20180014-1/">SLSA-2018:0014-1</a>&nbsp;(linux-firmware)</p>
                <p>o&nbsp;&nbsp; 6 -&nbsp;<a href="https://www.scientificlinux.org/category/sl-errata/slsa-20180008-1/">SLSA-2018:0008-1</a>&nbsp;(kernel),&nbsp;<a href="https://www.scientificlinux.org/category/sl-errata/slsa-20180013-1/">SLSA-2018:0013-1</a>&nbsp;(microcode_ctl)</p>
                <ul>
                    <li>CoreOS Container Linux: Fixes for Meltdown are&nbsp;<a href="https://coreos.com/blog/container-linux-meltdown-patch">available in all release channels now</a>(Alpha 1649.0.0, Beta 1632.1.0, Stable 1576.5.0). Auto-updated systems will receive the releases containing the patch on 2017-01-08. Spectre patches are still WIP.</li>
                    <li>NixOS: According to&nbsp;<a href="https://github.com/NixOS/nixpkgs/issues/33414">#33414</a>, KPTI is in nixpkgs since&nbsp;<a href="https://github.com/NixOS/nixpkgs/commit/1e129a3f9934ae62b77475909f6812f2ac3ab51f">1e129a3</a>.</li>
                    <li><a href="https://lists.archlinux.org/pipermail/arch-security/2018-January/001110.html">Arch Linux Advisory</a></li>
                    <li>Gentoo:</li>
                </ul>
                <p>o&nbsp;&nbsp; <a href="https://wiki.gentoo.org/wiki/Project:Security/Vulnerabilities/Meltdown_and_Spectre">Gentoo Wiki - Project:Security/Vulnerabilities/Meltdown and Spectre</a></p>
                <p>o&nbsp;&nbsp; <a href="https://bugs.gentoo.org/643228">Bugtracker - Bug#643228 - Security Tracking Bug</a></p>
                <ul>
                    <li>Oracle Linux (ELSA Security Advisory):</li>
                </ul>
                <p>o&nbsp;&nbsp; <a href="https://linux.oracle.com/cve/CVE-2017-5753.html">Details about CVE-2017-5753 (variant 1, aka "Spectre")</a></p>
                <p>o&nbsp;&nbsp; <a href="https://linux.oracle.com/cve/CVE-2017-5715.html">Details about CVE-2017-5715 (variant 2, aka "Spectre")</a></p>
                <p>o&nbsp;&nbsp; <a href="https://linux.oracle.com/cve/CVE-2017-5754.html">Details about CVE-2017-5754 (variant 3, aka "Meltdown")</a></p>
                <p><strong>FreeBSD</strong></p>
                <ul>
                    <li><a href="https://www.freebsd.org/news/newsflash.html#event20180104:01">Statement</a></li>
                </ul>
                <p><strong>Virtualization</strong></p>
                <ul>
                    <li>XEN -&nbsp;<a href="https://xenbits.xen.org/xsa/advisory-254.html">XSA-254</a>and&nbsp;<a href="https://blog.xenproject.org/2018/01/04/xen-project-spectremeltdown-faq/">Xen Project Spectre/Meltdown FAQ</a>, no patches yet</li>
                    <li>QEMU - unofficial patch published&nbsp;<a href="https://lists.nongnu.org/archive/html/qemu-devel/2018-01/msg00811.html">here</a>,&nbsp;<a href="https://www.qemu.org/2018/01/04/spectre/">official blog post</a>,&nbsp;<a href="https://lists.nongnu.org/archive/html/qemu-devel/2018-01/msg00613.html">discussion on qemu-devel</a></li>
                    <li>VMware -&nbsp;<a href="https://www.vmware.com/us/security/advisories/VMSA-2018-0002.html">VMSA-2018-0002</a>** Update 01/04/18: "OS vendors have begun issuing patches that address CVE-2017-5753, CVE-2017-5715, and CVE-2017-5754 for their operating systems. For these patches to be fully functional in a guest OS additional ESXi and vCenter Server updates will be required. These updates are being given the highest priority. Please sign up to the&nbsp;<a href="https://lists.vmware.com/cgi-bin/mailman/listinfo/security-announce">Security-Announce mailing list</a>&nbsp;to be alerted when these updates are available." **&nbsp;<a href="https://twitter.com/lamw/status/949662333038559232">William Lam suggests</a>forthcoming patches for ESXi 5.5 and a vCenter patch to deliver microcode when using EVC. **&nbsp;<a href="https://kb.vmware.com/s/article/52264">KB 52264</a>&nbsp;tracks VMware appliance status (currently all unaffected or pending)</li>
                    <li>Red Hat Enterprise Virtualization -&nbsp;<a href="https://access.redhat.com/solutions/3307851">Impacts of CVE-2017-5754, CVE-2017-5753, and CVE-2017-5715 to Red Hat Virtualization products</a></li>
                    <li>Citrix XenServer -&nbsp;<a href="https://support.citrix.com/article/CTX231390">Citrix XenServer Multiple Security Updates</a></li>
                    <li>Nutanix -&nbsp;<a href="http://download.nutanix.com/alerts/Security-Advisory_0007_v1.pdf">Nutanix Side-Channel Speculative Execution Vulnerabilities</a></li>
                </ul>
                <p><strong>Browsers</strong></p>
                <ul>
                    <li>Mozilla:&nbsp;<a href="https://blog.mozilla.org/security/2018/01/03/mitigations-landing-new-class-timing-attack/">Mitigations landing for new class of timing attack (blog post)</a>,&nbsp;<a href="https://www.mozilla.org/en-US/security/advisories/mfsa2018-01/">Security Advisory 2018-01</a>,&nbsp;<a href="https://www.mozilla.org/en-US/firefox/57.0.4/releasenotes/">Firefox mitigation update 57.0.4</a></li>
                    <li>Chrome:&nbsp;<a href="https://www.chromium.org/Home/chromium-security/ssca">Actions Required to Mitigate Speculative Side-Channel Attack Techniques</a></li>
                    <li>Microsoft Edge:&nbsp;<a href="https://blogs.windows.com/msedgedev/2018/01/03/speculative-execution-mitigations-microsoft-edge-internet-explorer/">Mitigating speculative execution side-channel attacks in Microsoft Edge and Internet Explorer</a></li>
                </ul>
                <p><strong>Cloud Providers</strong></p>
                <ul>
                    <li>Amazon AWS:&nbsp;<a href="https://aws.amazon.com/security/security-bulletins/AWS-2018-013/">Processor Speculative Execution Research Disclosure</a></li>
                    <li>Google Cloud:&nbsp;<a href="https://support.google.com/faqs/answer/7622138">Google&rsquo;s Mitigations Against CPU Speculative Execution Attack Methods</a></li>
                    <li>Microsoft Azure:&nbsp;<a href="https://azure.microsoft.com/en-us/blog/securing-azure-customers-from-cpu-vulnerability/">Securing Azure customers from CPU vulnerability</a></li>
                    <li>DigitalOcean:&nbsp;<a href="https://blog.digitalocean.com/a-message-about-intel-security-findings/">A Message About Intel Security Findings</a></li>
                    <li>Scaleway:&nbsp;<a href="https://status.online.net/index.php?do=details&amp;task_id=1116">Emergency security update required on all hypervisors</a></li>
                    <li>Linode:&nbsp;<a href="https://blog.linode.com/2018/01/03/cpu-vulnerabilities-meltdown-spectre/">CPU Vulnerabilities: Meltdown &amp; Spectre</a></li>
                    <li>Rackspace:&nbsp;<a href="https://blog.rackspace.com/rackspace-is-tracking-vulnerabilities-affecting-processors-by-intel-amd-and-arm">Rackspace is Tracking Vulnerabilities Affecting Processors by Intel, AMD and ARM</a></li>
                    <li>OVH:&nbsp;<a href="https://www.ovh.co.uk/news/articles/a2570.meltdown-spectre-bug-x86-64-cpu-ovh-fully-mobilised">Meltdown, Spectre bug impacting x86-64 CPU - OVH fully mobilised</a>(en),&nbsp;<a href="https://www.ovh.com/fr/blog/vulnerabilites-meltdown-spectre-cpu-x86-64-ovh-pleinement-mobilise/">Vuln&eacute;rabilit&eacute;s Meltdown/Spectre affectant les CPU x86-64 : OVH pleinement mobilis&eacute;</a>&nbsp;(fr)</li>
                    <li>Vultr:&nbsp;<a href="https://www.vultr.com/news/Intel-CPU-Vulnerability-Alert/">Intel CPU Vulnerability Alert</a></li>
                    <li>Hetzner:&nbsp;<a href="https://wiki.hetzner.de/index.php/Spectre_and_Meltdown/en">Spectre and Meltdown</a></li>
                </ul>
                <p><strong>Chip Manufacturers / HW Vendors</strong></p>
                <ul>
                    <li>Intel:&nbsp;<a href="https://security-center.intel.com/advisory.aspx?intelid=INTEL-SA-00088&amp;languageid=en-fr">INTEL-SA-00088 - Speculative Execution and Indirect Branch Prediction Side Channel Analysis Method</a>,&nbsp;<a href="https://newsroom.intel.com/wp-content/uploads/sites/11/2018/01/Intel-Analysis-of-Speculative-Execution-Side-Channels.pdf">Intel Analysis of Speculative Execution Side Channels (Whitepaper)</a>,&nbsp;<a href="https://newsroom.intel.com/news-releases/intel-issues-updates-protect-systems-security-exploits/">Intel Issues Updates to Protect Systems from Security Exploits</a></li>
                    <li>AMD:&nbsp;<a href="https://www.amd.com/en/corporate/speculative-execution">An Update on AMD Processor Security</a></li>
                    <li>ARM:&nbsp;<a href="https://developer.arm.com/support/security-update">Security Update</a></li>
                    <li>Raspberry Pi:&nbsp;<a href="https://www.raspberrypi.org/blog/why-raspberry-pi-isnt-vulnerable-to-spectre-or-meltdown/">Why Raspberry Pi isn't vulnerable to Spectre or Meltdown</a></li>
                    <li>NVIDIA:&nbsp;<a href="https://nvidia.custhelp.com/app/answers/detail/a_id/4609">Security Notice: Speculative Side Channels</a></li>
                    <li>Lenovo:&nbsp;<a href="https://support.lenovo.com/it/en/solutions/len-18282">LEN-18282 - Reading Privileged Memory with a Side Channel</a></li>
                    <li>IBM:&nbsp;<a href="https://exchange.xforce.ibmcloud.com/collection/Central-Processor-Unit-CPU-Architectural-Design-Flaws-c422fb7c4f08a679812cf1190db15441">Central Processor Unit (CPU) Architectural Design Flaws</a>,&nbsp;<a href="https://www.ibm.com/blogs/psirt/potential-impact-processors-power-family/">Potential Impact on Processors in the POWER family</a></li>
                    <li>Huawei:&nbsp;<a href="http://www.huawei.com/en/psirt/security-notices/huawei-sn-20180104-01-intel-en">huawei-sn-20180104-01 - Statement on the Media Disclosure of a Security Vulnerability in the Intel CPU Architecture Design</a></li>
                    <li>F5:&nbsp;<a href="https://support.f5.com/csp/article/K91229003">K91229003 - Side-channel processor vulnerabilities CVE-2017-5715, CVE-2017-5753, and CVE-2017-5754</a></li>
                    <li>Cisco&nbsp;<a href="https://tools.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-20180104-cpusidechannel">CPU Side-Channel Information Disclosure Vulnerabilities</a></li>
                    <li>Fortigate&nbsp;<a href="https://fortiguard.com/psirt/FG-IR-18-002">CPU hardware vulnerable to Meltdown and Spectre attacks</a></li>
                    <li>Cumulus Linux&nbsp;<a href="https://support.cumulusnetworks.com/hc/en-us/articles/115015951667-Meltdown-and-Spectre-Modern-CPU-Vulnerabilities">Meltdown and Spectre: Modern CPU Vulnerabilities</a></li>
                    <li>Check Point&nbsp;<a href="https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&amp;solutionid=sk122205">Check Point Response to Meltdown and Spectre (CVE-2017-5753, CVE-2017-5715, CVE-2017-5754)</a></li>
                    <li>Palo Alto Networks&nbsp;<a href="https://securityadvisories.paloaltonetworks.com/">Information about Meltdown and Spectre findings (PAN-SA-2018-0001)</a></li>
                    <li>HP Enterprise:&nbsp;<a href="https://support.hpe.com/hpsc/doc/public/display?docId=emr_na-a00039267en_us">Side Channel Analysis Method Allows Improper Information Disclosure in Microprocessors (CVE-2017-5715, CVE-2017-5753, CVE-2017-5754)</a>,&nbsp;<a href="https://support.hpe.com/hpsc/doc/public/display?docId=emr_na-hpesbhf03805en_us">HPESBHF03805 Certain HPE products using Microprocessors from Intel, AMD, and ARM, with Speculative Execution, Elevation of Privilege and Information Disclosure</a></li>
                </ul>
                <p><strong>CERTs</strong></p>
                <ul>
                    <li>CERT/CC:&nbsp;<a href="https://www.kb.cert.org/vuls/id/584653">Vulnerability Note VU#584653 - CPU hardware vulnerable to side-channel attacks</a></li>
                    <li>US-CERT:&nbsp;<a href="https://www.us-cert.gov/ncas/alerts/TA18-004A">TA18-004A - Meltdown and Spectre Side-Channel Vulnerability Guidance</a></li>
                    <li>NCSC-UK:&nbsp;<a href="https://www.ncsc.gov.uk/guidance/meltdown-and-spectre-guidance">Meltdown and Spectre guidance</a></li>
                    <li>CERT-FR:&nbsp;<a href="https://www.cert.ssi.gouv.fr/alerte/CERTFR-2018-ALE-001/">CERTFR-2018-ALE-001 - Multiples vuln&eacute;rabilit&eacute;s de fuite d&rsquo;informations dans des processeurs</a>(french only)</li>
                    <li>CERT Nazionale:&nbsp;<a href="https://www.certnazionale.it/news/2018/01/04/moderni-processori-vulnerabili-ad-attacchi-side-channel/">Moderni processori vulnerabili ad attacchi side-channel</a>(italian only)</li>
                </ul>
                <p><strong>CPU microcode</strong></p>
                <p>Latest&nbsp;<a href="https://downloadcenter.intel.com/download/27337">Intel microcode</a>&nbsp;update is 20171117. It is unclear whether microcode updates are needed and which version contains them. The microcode update does not contain any changelog.<br />If it will become necessary to update Intel (or AMD) microcode under Windows, before the release of official OS-level patches,&nbsp;<a href="https://labs.vmware.com/flings/vmware-cpu-microcode-update-driver">this VMware Labs fling</a>&nbsp;- though formally experimental - can serve the purpose, at least temporarily.</p>
                <p><strong>Update - Thu 4 Jan 2018, 15:30 UTC</strong></p>
                <p>It seems that the new Intel&rsquo;s microcode archive (2017-12-15) provided with the latest Red Hat&rsquo;s microcode_ctl update includes three new files: 06-3f-02, 06-4f-01, 06-55-04.</p>
                <p>Based on what we know:</p>
                <ol>
                    <li>it adds one new CPUID and two MSR for the variant of Spectre that uses indirect branches</li>
                    <li>it forces LFENCE to terminate the execution of all previous instructions, thus having the desired effect for the variant of Spectre that uses conditional branches (out-of-bounds-bypass)</li>
                </ol>
                <p>Those IDs belong to the following processor microarchitectures: Haswell, Broadwell, Skylake (<a href="https://software.intel.com/en-us/articles/intel-architecture-and-processor-identification-with-cpuid-model-and-family-numbers">official reference</a>)</p>
                <p><strong>Update - Thu 4 Jan 2018, 16:30 UTC</strong></p>
                <p>Regarding AMD's microcode update: it seems to be only for EPYC (maybe Ryzen, not sure!) and it only adds one of the two MSRs (IA32_PRED_CMD). It uses a different bit than Intel's in the CPUID. It is also for Spectre with indirect branches. Previous microprocessors resolved it with a chicken bit. Please note that the same solution implemented at kernel level works for both Intel and AMD.</p>
                <p><strong>Update - Fri 5 Jan 2018, 03:35 UTC</strong></p>
                <p>Debian Project package maintainers released an&nbsp;<a href="https://packages.debian.org/sid/intel-microcode">[updated version of the "intel-microcode" package (version 2017-12-15)]</a>&nbsp;for the Sid (unstable) branch olny. Upon inspection, it seems to contain the same microcode additions observed in the Red Hat microcode_ctl update of Thu 4 Jan 2018, 15:30 UTC. The package in compatible with all Debian-based distributions that support post-boot microcode updates.</p>
                <p><strong>Antiviruses</strong></p>
                <p>&nbsp;</p>
                <p>Some Antiviruses do things that break when installing the Windows patches, therefore Microsoft doesn't automatically install the patches on those systems.</p>
                <p>Vendor overview:&nbsp;<a href="https://docs.google.com/spreadsheets/d/184wcDt9I9TUNFFbsAVLpzAtckQxYiuirADzf3cL42FQ/htmlview?usp=sharing&amp;sle=true">https://docs.google.com/spreadsheets/d/184wcDt9I9TUNFFbsAVLpzAtckQxYiuirADzf3cL42FQ/htmlview?usp=sharing&amp;sle=true</a></p>
                <ul>
                    <li>Trend Micro:&nbsp;<a href="https://success.trendmicro.com/solution/1119183-important-information-for-trend-micro-solutions-and-microsoft-january-2018-security-updates">Important Information for Trend Micro Solutions and Microsoft January 2018 Security Updates (Meltdown and Spectre)</a></li>
                    <li>Emsisoft:&nbsp;<a href="https://blog.emsisoft.com/2018/01/04/chip-vulnerabilities-and-emsisoft-what-you-need-to-know/">Chip vulnerabilities and Emsisoft: What you need to know</a></li>
                    <li>Sophos:&nbsp;<a href="https://community.sophos.com/kb/en-us/128053">Advisory - Kernel memory issue affecting multiple OS (aka F..CKWIT, KAISER, KPTI, Meltdown &amp; Spectre)</a></li>
                    <li>Webroot:&nbsp;<a href="https://community.webroot.com/t5/Announcements/Microsoft-Patch-Release-Wednesday-January-3-2018/m-p/310146">Microsoft Patch Release - Wednesday, January 3, 2018</a></li>
                    <li>McAfee:&nbsp;<a href="https://securingtomorrow.mcafee.com/mcafee-labs/decyphering-the-noise-around-meltdown-and-spectre/">Decyphering the Noise Around &lsquo;Meltdown&rsquo; and &lsquo;Spectre&rsquo;</a>and&nbsp;<a href="https://kc.mcafee.com/corporate/index?page=content&amp;id=KB90167">Meltdown and Spectre &ndash; Microsoft update (January 3, 2018) compatibility issue with anti-virus products</a></li>
                    <li>Kaspersky:&nbsp;<a href="https://support.kaspersky.com/14042">Compatibility of Kaspersky Lab solutions with the Microsoft Security update of January 9, 2018</a></li>
                    <li>ESET:&nbsp;<a href="https://www.eset.com/us/about/newsroom/corporate-blog-list/corporate-blog/meltdown-spectre-how-to-protect-yourself-from-these-cpu-security-flaws/">Meltdown &amp; Spectre: How to protect yourself from these CPU security flaws</a></li>
                    <li>Avira:&nbsp;<a href="https://www.avira.com/en/support-for-home-knowledgebase-detail/kbid/1925">With our latest product update 15.0.34.17 Avira Antivirus Free, Avira Antivirus Pro and Avira Antivirus Server are compatible with the Microsoft update</a></li>
                </ul>
                <p><strong>RDBMS</strong></p>
                <ul>
                    <li>SQL Server:&nbsp;<a href="https://support.microsoft.com/en-us/help/4073225/guidance-for-sql-server">SQL Server Guidance to protect against speculative execution side-channel vulnerabilities</a></li>
                </ul>
                <p><strong>Embedded Devices</strong></p>
                <ul>
                    <li>Synology:&nbsp;<a href="https://www.synology.com/en-us/support/security/Synology_SA_18_01">Synology-SA-18:01 Meltdown and Spectre Attacks</a></li>
                    <li>Opengear: Nothing yet. Support claims an announcement is being prepared but did not provide a timeframe for public release.</li>
                </ul>
                <p><strong>Compilers</strong></p>
                <ul>
                    <li><a href="https://support.google.com/faqs/answer/7625886">Google's Retpoline: a software construct for preventing branch-target-injection</a>(technical write-up)</li>
                </ul>
                <p>o&nbsp;&nbsp; LLVM: An implementation is under review for official merge&nbsp;<a href="https://reviews.llvm.org/D41723">here</a></p>
                <p>o&nbsp;&nbsp; GCC: An implementation for GCC is available&nbsp;<a href="http://git.infradead.org/users/dwmw2/gcc-retpoline.git/shortlog/refs/heads/gcc-7_2_0-retpoline-20171219">here</a></p>
	</section>
        </article>
</body>
</html>
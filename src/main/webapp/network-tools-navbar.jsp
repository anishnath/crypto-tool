<!-- Compact Network Tools Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-3">
    <div class="container-fluid px-0">
        <span class="navbar-brand">
            <i class="fas fa-network-wired"></i> Network Tools
        </span>
        
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#networkToolsNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="networkToolsNavbar">
            <ul class="navbar-nav mr-auto">
                <!-- Discovery Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="discoveryDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-search"></i> Discovery
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="subdomain.jsp">
                            <i class="fas fa-sitemap"></i> Subdomain Finder
                        </a>
                        <a class="dropdown-item" href="portscan.jsp">
                            <i class="fas fa-shield-alt"></i> Port Scanner
                        </a>
                        <a class="dropdown-item" href="screenshot.jsp">
                            <i class="fas fa-camera"></i> Website Screenshot
                        </a>
                        <a class="dropdown-item" href="sslscan.jsp">
                            <i class="fas fa-lock"></i> SSL Scanner
                        </a>
                    </div>
                </li>
                
                <!-- DNS Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="dnsDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-globe"></i> DNS
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="dns.jsp">
                            <i class="fas fa-search"></i> DNS Lookup (All Records)
                        </a>
                        <a class="dropdown-item" href="dnsresolver.jsp">
                            <i class="fas fa-link"></i> DNS Propagation Checker
                        </a>
                        <a class="dropdown-item" href="revdns.jsp">
                            <i class="fas fa-undo"></i> Reverse DNS (PTR)
                        </a>
                        <a class="dropdown-item" href="dmarc.jsp">
                            <i class="fas fa-envelope"></i> DMARC Record Lookup & Validator
                        </a>
                    </div>
                </li>
                
                <!-- Diagnostics -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="diagnosticsDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-stethoscope"></i> Diagnostics
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="pingfunctions.jsp">
                            <i class="fas fa-ping-pong"></i> Online Ping Tool (IPv4/IPv6)
                        </a>
                        <a class="dropdown-item" href="mtr.jsp">
                            <i class="fas fa-route"></i> MTR Traceroute
                        </a>
                        <a class="dropdown-item" href="curlfunctions.jsp">
                            <i class="fas fa-globe"></i> Online Curl Tool (HTTP/HTTPS)
                        </a>
                        <a class="dropdown-item" href="socket-io-client.jsp">
                            <i class="fas fa-bolt"></i> Socket.IO Client
                        </a>
                        <a class="dropdown-item" href="websocket-client.jsp">
                            <i class="fas fa-plug"></i> WebSocket Client
                        </a>

                    </div>
                </li>
                
                <!-- Analysis -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="analysisDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-chart-line"></i> Analysis
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="SubnetFunctions.jsp">
                            <i class="fas fa-calculator"></i> IP Subnet Calculator (CIDR)
                        </a>
                        <a class="dropdown-item" href="vpc-calculator.jsp">
                            <i class="fas fa-cloud"></i> VPC Calculator & Subnet Planner
                        </a>
                        <a class="dropdown-item" href="ipv6-tool.jsp">
                            <i class="fas fa-compress-alt"></i> IPv6 Compressor & Expander
                        </a>
                        <a class="dropdown-item" href="mac-address-generator.jsp">
                            <i class="fas fa-network-wired"></i> MAC Address Generator
                        </a>
                        <a class="dropdown-item" href="httpstat.jsp">
                            <i class="fas fa-chart-line"></i> HTTP Status Tool
                        </a>
                    </div>
                </li>
                
                <!-- Info Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="infoDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-info-circle"></i> Info
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="whois.jsp">
                            <i class="fas fa-user"></i> WHOIS Lookup
                        </a>
                    </div>
                </li>
            </ul>
            
            <!-- Quick Actions -->
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="related-network.jsp" title="View All Network Tools">
                        <i class="fas fa-th"></i>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<style>
/* Compact navbar styling */
.navbar {
    padding: 0.4rem 0.75rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    min-height: 50px;
}

.navbar-brand {
    font-size: 1rem;
    font-weight: 600;
    margin-right: 1rem;
}

.navbar-brand i {
    margin-right: 0.4rem;
}

.nav-link {
    padding: 0.4rem 0.6rem !important;
    font-size: 0.85rem;
    white-space: nowrap;
}

.dropdown-menu {
    border: none;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    border-radius: 8px;
    margin-top: 0.5rem;
}

.dropdown-item {
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
    border-bottom: 1px solid #f8f9fa;
}

.dropdown-item:last-child {
    border-bottom: none;
}

.dropdown-item i {
    margin-right: 0.5rem;
    width: 16px;
    text-align: center;
}

.dropdown-item:hover {
    background-color: #f8f9fa;
    color: #495057;
}

/* Responsive adjustments */
@media (max-width: 991.98px) {
    .navbar-nav {
        text-align: left;
    }
    
    .dropdown-menu {
        border: none;
        box-shadow: none;
        background-color: #343a40;
    }
    
    .dropdown-item {
        color: #fff;
        border-bottom: 1px solid #495057;
    }
    
    .dropdown-item:hover {
        background-color: #495057;
        color: #fff;
    }
}

/* Active page highlighting */
.navbar-nav .nav-link.active {
    background-color: rgba(255,255,255,0.1);
    border-radius: 4px;
}
</style>

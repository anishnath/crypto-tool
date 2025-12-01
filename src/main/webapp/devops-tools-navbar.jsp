<!-- Compact DevOps Tools Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-3">
    <div class="container-fluid px-0">
        <span class="navbar-brand">
            <i class="fab fa-docker"></i> DevOps Tools
        </span>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#devopsToolsNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="devopsToolsNavbar">
            <ul class="navbar-nav mr-auto">
                <!-- Docker Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="dockerDropdown" role="button"
                        data-toggle="dropdown">
                        <i class="fab fa-docker"></i> Docker
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="dc.jsp">
                            <i class="fas fa-file-code"></i> Docker Compose Generator
                        </a>
                        <a class="dropdown-item" href="dc1.jsp">
                            <i class="fas fa-exchange-alt"></i> Docker Run to Compose
                        </a>
                        <a class="dropdown-item" href="dc2.jsp">
                            <i class="fas fa-exchange-alt"></i> Compose to Docker Run
                        </a>
                    </div>
                </li>

                <!-- Kubernetes Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="kubeDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-cube"></i> Kubernetes
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="helm-chart-generator.jsp">
                            <i class="fas fa-dharmachakra text-primary"></i> Helm Chart Generator
                        </a>
                        <a class="dropdown-item" href="kube.jsp">
                            <i class="fas fa-server"></i> Kubernetes Spec Generator
                        </a>
                        <a class="dropdown-item" href="kube1.jsp">
                            <i class="fas fa-exchange-alt"></i> Docker to Kubernetes
                        </a>
                        <a class="dropdown-item" href="kube2.jsp">
                            <i class="fas fa-exchange-alt"></i> Kubernetes to Docker Compose
                        </a>
                    </div>
                </li>

                <!-- AWS Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="awsDropdown" role="button" data-toggle="dropdown">
                        <i class="fab fa-aws"></i> AWS
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="aws.jsp">
                            <i class="fas fa-code"></i> Ansible Generator (AWS)
                        </a>
                        <a class="dropdown-item" href="aws-smtp.jsp">
                            <i class="fas fa-envelope"></i> AWS SMTP Password Generator
                        </a>
                    </div>
                </li>

                <!-- Development Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="devToolsDropdown" role="button"
                        data-toggle="dropdown">
                        <i class="fas fa-tools"></i> Development
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="nginx-config-generator.jsp">
                            <i class="fas fa-server"></i> Nginx Config Generator
                        </a>
                        <a class="dropdown-item" href="load-test-generator.jsp">
                            <i class="fas fa-tachometer-alt text-purple"></i> Load Testing Generator (K6, Locust,
                            JMeter, Gatling)
                        </a>
                        <a class="dropdown-item" href="chmod-calculator.jsp">
                            <i class="fas fa-calculator"></i> Chmod Calculator
                        </a>
                        <a class="dropdown-item" href="systemd-generator.jsp">
                            <i class="fas fa-cogs text-danger"></i> Systemd Service Generator
                        </a>
                        <a class="dropdown-item" href="dockerfile-generator.jsp">
                            <i class="fab fa-docker text-primary"></i> Dockerfile Generator
                        </a>
                        <a class="dropdown-item" href="firewall-generator.jsp">
                            <i class="fas fa-shield-alt text-danger"></i> Firewall Rules Generator
                        </a>
                        <a class="dropdown-item" href="apache-virtualhost-generator.jsp">
                            <i class="fas fa-server text-purple"></i> Apache VirtualHost Generator
                        </a>
                        <a class="dropdown-item" href="github-actions-generator.jsp">
                            <i class="fab fa-github text-dark"></i> GitHub Actions Generator
                        </a>
                        <a class="dropdown-item" href="gitlab-ci-generator.jsp">
                            <i class="fab fa-gitlab text-warning"></i> GitLab CI/CD Generator
                        </a>
                        <a class="dropdown-item" href="rbac-policy-generator.jsp">
                            <i class="fas fa-user-shield text-danger"></i> Kubernetes RBAC Generator
                        </a>
                        <a class="dropdown-item" href="service-mesh-generator.jsp">
                            <i class="fas fa-project-diagram text-info"></i> Istio Service Mesh Generator
                        </a>
                        <a class="dropdown-item" href="k8s-resource-calculator.jsp">
                            <i class="fas fa-calculator text-success"></i> K8s Resource Calculator
                        </a>
                        <a class="dropdown-item" href="rate-limiter-generator.jsp">
                            <i class="fas fa-tachometer-alt text-danger"></i> API Rate Limiter Generator
                        </a>
                        <a class="dropdown-item" href="sql-query-builder.jsp">
                            <i class="fas fa-database text-primary"></i> SQL Query Builder
                        </a>
                        <a class="dropdown-item" href="curl-builder.jsp">
                            <i class="fas fa-terminal"></i> cURL Builder & HTTP Client
                        </a>
                        <a class="dropdown-item" href="websocket-client.jsp">
                            <i class="fas fa-plug"></i> WebSocket Client
                        </a>
                        <a class="dropdown-item" href="prometheus-query-builder.jsp">
                            <i class="fas fa-chart-line"></i> Prometheus Query Builder
                        </a>
                        <a class="dropdown-item" href="cron-generator.jsp">
                            <i class="fas fa-clock"></i> Cron Expression Generator
                        </a>
                    </div>
                </li>
            </ul>

            <!-- Quick Actions -->
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="related-devops.jsp" title="View All DevOps Tools">
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
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
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
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 4px;
    }
</style>
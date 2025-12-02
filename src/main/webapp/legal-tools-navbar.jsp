<!-- Legal Tools Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-3">
    <div class="container-fluid px-0">
        <span class="navbar-brand">
            <i class="fas fa-balance-scale"></i> Legal Tools
        </span>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#legalToolsNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="legalToolsNavbar">
            <ul class="navbar-nav mr-auto">
                <!-- Policy Generators -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="policyDropdown" role="button"
                        data-toggle="dropdown">
                        <i class="fas fa-file-contract"></i> Policy Generators
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="app-privacy-policy-generator.jsp">
                            <i class="fas fa-user-shield text-primary"></i> Privacy Policy Generator
                        </a>
                        <a class="dropdown-item" href="terms-of-use-generator.jsp">
                            <i class="fas fa-gavel text-warning"></i> Terms of Use Generator
                        </a>
                        <a class="dropdown-item" href="eula-generator.jsp">
                            <i class="fas fa-file-signature text-info"></i> EULA Generator
                        </a>
                        <a class="dropdown-item" href="cookie-policy-generator.jsp">
                            <i class="fas fa-cookie-bite text-warning"></i> Cookie Policy Generator
                        </a>
                        <a class="dropdown-item" href="aup-generator.jsp">
                            <i class="fas fa-user-shield text-warning"></i> Acceptable Use Policy
                        </a>
                        <a class="dropdown-item" href="disclaimer-generator.jsp">
                            <i class="fas fa-exclamation-triangle text-danger"></i> Disclaimer Generator
                        </a>
                        <a class="dropdown-item" href="dmca-policy-generator.jsp">
                            <i class="fas fa-copyright text-dark"></i> DMCA Policy Generator
                        </a>
                        <a class="dropdown-item" href="shipping-policy-generator.jsp">
                            <i class="fas fa-shipping-fast text-info"></i> Shipping Policy Generator
                        </a>
                        <a class="dropdown-item" href="return-refund-policy-generator.jsp">
                            <i class="fas fa-undo text-success"></i> Return & Refund Policy
                        </a>
                    </div>
                </li>
            </ul>

            <!-- Quick Actions -->
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp" title="Home">
                        <i class="fas fa-home"></i>
                    </a>
                </li>
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
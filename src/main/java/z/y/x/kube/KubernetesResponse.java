package z.y.x.kube;

import com.google.gson.Gson;

/**
 * JSON response wrapper for Kubernetes generation operations
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class KubernetesResponse {

    private boolean success;
    private String operation;
    private String errorMessage;

    // Generated Kubernetes manifests
    private String kubernetesYaml;
    private String kubernetesJson;

    // Input parameters (for reference)
    private String dockerComposeFile; // For CONFIG_GENERATE
    private String kubernetesManifest; // For KUBE_2_COMPOSE
    private String resourceType; // Pod, Deployment, ReplicaSet, StatefulSet, Service

    // Metadata
    private String generatedAt;

    public KubernetesResponse() {
        this.success = false;
    }

    // Getters and Setters
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getKubernetesYaml() {
        return kubernetesYaml;
    }

    public void setKubernetesYaml(String kubernetesYaml) {
        this.kubernetesYaml = kubernetesYaml;
    }

    public String getKubernetesJson() {
        return kubernetesJson;
    }

    public void setKubernetesJson(String kubernetesJson) {
        this.kubernetesJson = kubernetesJson;
    }

    public String getDockerComposeFile() {
        return dockerComposeFile;
    }

    public void setDockerComposeFile(String dockerComposeFile) {
        this.dockerComposeFile = dockerComposeFile;
    }

    public String getKubernetesManifest() {
        return kubernetesManifest;
    }

    public void setKubernetesManifest(String kubernetesManifest) {
        this.kubernetesManifest = kubernetesManifest;
    }

    public String getResourceType() {
        return resourceType;
    }

    public void setResourceType(String resourceType) {
        this.resourceType = resourceType;
    }

    public String getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(String generatedAt) {
        this.generatedAt = generatedAt;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}


package z.y.x.docker;

import com.google.gson.Gson;

/**
 * JSON response wrapper for Docker Compose generation operations
 * @author Anish Nath
 * For Demo Visit https://8gwifi.org
 */
public class DockerComposeResponse {

    private boolean success;
    private String operation;
    private String errorMessage;

    // Generated compose file
    private String dockerComposeYaml;
    private String dockerComposeJson; // Optional: JSON representation

    // Input parameters (for reference)
    private String serviceName;
    private String image;
    private String containerName;
    private String dockerRunCommand; // Original docker run command (for dc1.jsp)

    // Metadata
    private String version; // Docker Compose version
    private String generatedAt;

    public DockerComposeResponse() {
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

    public String getDockerComposeYaml() {
        return dockerComposeYaml;
    }

    public void setDockerComposeYaml(String dockerComposeYaml) {
        this.dockerComposeYaml = dockerComposeYaml;
    }

    public String getDockerComposeJson() {
        return dockerComposeJson;
    }

    public void setDockerComposeJson(String dockerComposeJson) {
        this.dockerComposeJson = dockerComposeJson;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getContainerName() {
        return containerName;
    }

    public void setContainerName(String containerName) {
        this.containerName = containerName;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(String generatedAt) {
        this.generatedAt = generatedAt;
    }

    public String getDockerRunCommand() {
        return dockerRunCommand;
    }

    public void setDockerRunCommand(String dockerRunCommand) {
        this.dockerRunCommand = dockerRunCommand;
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}


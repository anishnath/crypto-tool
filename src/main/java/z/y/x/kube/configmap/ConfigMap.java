package z.y.x.kube.configmap;

import java.util.Map;
import z.y.x.kube.metadata;

public class ConfigMap {
    private String apiVersion = "v1";
    private String kind = "ConfigMap";
    private metadata metadata;
    private Map<String, String> data;
    private Map<String, String> binaryData;
    private Boolean immutable;

    public String getApiVersion() {
        return apiVersion;
    }

    public void setApiVersion(String apiVersion) {
        this.apiVersion = apiVersion;
    }

    public String getKind() {
        return kind;
    }

    public void setKind(String kind) {
        this.kind = kind;
    }

    public metadata getMetadata() {
        return metadata;
    }

    public void setMetadata(metadata metadata) {
        this.metadata = metadata;
    }

    public Map<String, String> getData() {
        return data;
    }

    public void setData(Map<String, String> data) {
        this.data = data;
    }

    public Map<String, String> getBinaryData() {
        return binaryData;
    }

    public void setBinaryData(Map<String, String> binaryData) {
        this.binaryData = binaryData;
    }

    public Boolean getImmutable() {
        return immutable;
    }

    public void setImmutable(Boolean immutable) {
        this.immutable = immutable;
    }

    @Override
    public String toString() {
        return "ConfigMap [apiVersion=" + apiVersion + ", kind=" + kind + ", metadata=" + metadata + ", data=" + data
                + ", binaryData=" + binaryData + ", immutable=" + immutable + "]";
    }
}

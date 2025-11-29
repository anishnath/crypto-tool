package z.y.x.kube.configmap;

import java.util.Map;
import z.y.x.kube.metadata;

public class Secret {
    private String apiVersion = "v1";
    private String kind = "Secret";
    private metadata metadata;
    private Map<String, String> data;          // base64 encoded values
    private Map<String, String> stringData;    // plain text values (auto-encoded)
    private String type = "Opaque";            // Opaque, kubernetes.io/tls, kubernetes.io/dockerconfigjson, etc.
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

    public Map<String, String> getStringData() {
        return stringData;
    }

    public void setStringData(Map<String, String> stringData) {
        this.stringData = stringData;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Boolean getImmutable() {
        return immutable;
    }

    public void setImmutable(Boolean immutable) {
        this.immutable = immutable;
    }

    @Override
    public String toString() {
        return "Secret [apiVersion=" + apiVersion + ", kind=" + kind + ", metadata=" + metadata + ", data=" + data
                + ", stringData=" + stringData + ", type=" + type + ", immutable=" + immutable + "]";
    }
}

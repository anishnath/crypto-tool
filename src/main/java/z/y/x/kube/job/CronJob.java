package z.y.x.kube.job;

import z.y.x.kube.metadata;

public class CronJob {
    private String apiVersion = "batch/v1";
    private String kind = "CronJob";
    private metadata metadata;
    private CronJobSpec spec;

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

    public CronJobSpec getSpec() {
        return spec;
    }

    public void setSpec(CronJobSpec spec) {
        this.spec = spec;
    }

    @Override
    public String toString() {
        return "CronJob [apiVersion=" + apiVersion + ", kind=" + kind + ", metadata=" + metadata + ", spec=" + spec + "]";
    }
}

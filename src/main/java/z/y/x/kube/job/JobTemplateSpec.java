package z.y.x.kube.job;

import z.y.x.kube.metadata;

public class JobTemplateSpec {
    private metadata metadata;
    private JobSpec spec;

    public metadata getMetadata() {
        return metadata;
    }

    public void setMetadata(metadata metadata) {
        this.metadata = metadata;
    }

    public JobSpec getSpec() {
        return spec;
    }

    public void setSpec(JobSpec spec) {
        this.spec = spec;
    }

    @Override
    public String toString() {
        return "JobTemplateSpec [metadata=" + metadata + ", spec=" + spec + "]";
    }
}

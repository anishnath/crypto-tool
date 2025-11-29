package z.y.x.kube.job;

import z.y.x.kube.deployment.template;

public class JobSpec {
    private Integer backoffLimit;
    private Integer completions;
    private Integer parallelism;
    private Integer activeDeadlineSeconds;
    private Integer ttlSecondsAfterFinished;
    private String restartPolicy = "Never";
    private template template;

    public Integer getBackoffLimit() {
        return backoffLimit;
    }

    public void setBackoffLimit(Integer backoffLimit) {
        this.backoffLimit = backoffLimit;
    }

    public Integer getCompletions() {
        return completions;
    }

    public void setCompletions(Integer completions) {
        this.completions = completions;
    }

    public Integer getParallelism() {
        return parallelism;
    }

    public void setParallelism(Integer parallelism) {
        this.parallelism = parallelism;
    }

    public Integer getActiveDeadlineSeconds() {
        return activeDeadlineSeconds;
    }

    public void setActiveDeadlineSeconds(Integer activeDeadlineSeconds) {
        this.activeDeadlineSeconds = activeDeadlineSeconds;
    }

    public Integer getTtlSecondsAfterFinished() {
        return ttlSecondsAfterFinished;
    }

    public void setTtlSecondsAfterFinished(Integer ttlSecondsAfterFinished) {
        this.ttlSecondsAfterFinished = ttlSecondsAfterFinished;
    }

    public String getRestartPolicy() {
        return restartPolicy;
    }

    public void setRestartPolicy(String restartPolicy) {
        this.restartPolicy = restartPolicy;
    }

    public template getTemplate() {
        return template;
    }

    public void setTemplate(template template) {
        this.template = template;
    }

    @Override
    public String toString() {
        return "JobSpec [backoffLimit=" + backoffLimit + ", completions=" + completions + ", parallelism=" + parallelism
                + ", activeDeadlineSeconds=" + activeDeadlineSeconds + ", ttlSecondsAfterFinished=" + ttlSecondsAfterFinished
                + ", restartPolicy=" + restartPolicy + ", template=" + template + "]";
    }
}

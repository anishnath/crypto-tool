package z.y.x.kube.job;

public class CronJobSpec {
    private String schedule;
    private String concurrencyPolicy = "Allow";  // Allow, Forbid, Replace
    private Boolean suspend = false;
    private Integer successfulJobsHistoryLimit = 3;
    private Integer failedJobsHistoryLimit = 1;
    private Integer startingDeadlineSeconds;
    private JobTemplateSpec jobTemplate;

    public String getSchedule() {
        return schedule;
    }

    public void setSchedule(String schedule) {
        this.schedule = schedule;
    }

    public String getConcurrencyPolicy() {
        return concurrencyPolicy;
    }

    public void setConcurrencyPolicy(String concurrencyPolicy) {
        this.concurrencyPolicy = concurrencyPolicy;
    }

    public Boolean getSuspend() {
        return suspend;
    }

    public void setSuspend(Boolean suspend) {
        this.suspend = suspend;
    }

    public Integer getSuccessfulJobsHistoryLimit() {
        return successfulJobsHistoryLimit;
    }

    public void setSuccessfulJobsHistoryLimit(Integer successfulJobsHistoryLimit) {
        this.successfulJobsHistoryLimit = successfulJobsHistoryLimit;
    }

    public Integer getFailedJobsHistoryLimit() {
        return failedJobsHistoryLimit;
    }

    public void setFailedJobsHistoryLimit(Integer failedJobsHistoryLimit) {
        this.failedJobsHistoryLimit = failedJobsHistoryLimit;
    }

    public Integer getStartingDeadlineSeconds() {
        return startingDeadlineSeconds;
    }

    public void setStartingDeadlineSeconds(Integer startingDeadlineSeconds) {
        this.startingDeadlineSeconds = startingDeadlineSeconds;
    }

    public JobTemplateSpec getJobTemplate() {
        return jobTemplate;
    }

    public void setJobTemplate(JobTemplateSpec jobTemplate) {
        this.jobTemplate = jobTemplate;
    }

    @Override
    public String toString() {
        return "CronJobSpec [schedule=" + schedule + ", concurrencyPolicy=" + concurrencyPolicy + ", suspend=" + suspend
                + ", successfulJobsHistoryLimit=" + successfulJobsHistoryLimit + ", failedJobsHistoryLimit=" + failedJobsHistoryLimit
                + ", startingDeadlineSeconds=" + startingDeadlineSeconds + ", jobTemplate=" + jobTemplate + "]";
    }
}

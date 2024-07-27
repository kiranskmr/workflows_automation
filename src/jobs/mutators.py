from dataclasses import replace

from databricks.bundles.jobs import Job, JobCluster, job_mutator
from databricks.bundles.variables import Bundle


@job_mutator
def default_job_cluster_mutator(job: Job) -> Job:
    """
    Automatically set default job cluster on each job that doesn't specify it.
    """

    job_clusters = job.job_clusters or []

    for job_cluster in job_clusters:
        if job_cluster.job_cluster_key == JobCluster.DEFAULT_KEY:
            return job

    default_job_cluster = JobCluster.create(
        job_cluster_key=JobCluster.DEFAULT_KEY,
        new_cluster={
            "spark_version": Bundle.variables.spark_version,
            "node_type_id": Bundle.variables.node_type,
            "autoscale": {
                "min_workers": 1,
                "max_workers": 4,
            },
        },
    )

    return replace(job, job_clusters=[*job_clusters, default_job_cluster])

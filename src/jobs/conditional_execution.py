from databricks.bundles.jobs import task, job


@job(name="PyDABS - Detect Anomalies job")
def detect_anomalies():
    anomaly_count = get_anomaly_count()

    if anomaly_count.output > 0:
        send_report()


@task
def get_anomaly_count() -> int:
    return 42


@task
def send_report():
    print("Sending report")

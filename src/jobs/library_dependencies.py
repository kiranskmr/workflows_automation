import cowsay

from databricks.bundles.jobs import task, job

# see requirements.txt for library dependencies


@task
def cow_task(msg: str):
    cowsay.cow(msg)


@job(name="PyDABS - Library Dependancy")
def cowsay_job():
    cow_task("Hello World")

from databricks.bundles.jobs import task, job


@task
def get_message() -> str:
    return "Hello, World!"


@task
def print_message(msg: str):
    print(msg)


@job(name="PyDABS - Task Values")
def task_values():
    message = get_message()

    print_message(message.output)

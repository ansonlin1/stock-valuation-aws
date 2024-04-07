#!/usr/bin/env python
import os

from aws_stack import App, Environment

from lib.stages.stage import AwsStage


def main():
    app = App()

    account_name = os.environ.get("ACCOUNT_NAME")
    account_num = os.environ.get("ACCOUNT_NUM")
    env_name = os.environ.get("ENV_NAME")
    region = os.environ.get("REGION")
    stage_type = os.environ.get("STAGE_TYPE")

    props = {
        'account_name': account_name,
        'account_num': account_num,
        'env_name': env_name,
        'region': region,
        'stage_type': stage_type,
    }

    main.stage = AwsStage(
        app, f'{env_name}-{stage_type}',
        env=Environment(account=account_num, region=region),
        **props
    )

    app.synth()


if __name__ == "__main__":
    main()

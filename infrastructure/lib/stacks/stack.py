import logging

from constructs import Construct
from aws_cdk import (
    Environment,
    Stack
)

log = logging.getLogger(__name__)


class AwsStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, env: Environment, **kwargs) -> None:
        super().__init__(scope, construct_id, env=env, stack_name=kwargs['stack_name'])

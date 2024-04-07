from unittest.mock import patch

import pytest

from aws_cdk.assertions import Template

from app import main


@pytest.fixture(autouse=True)
def mock_environ():
    with patch.dict("app.os.environ",
                    {
                        "ACCOUNT_NAME": "",
                        "ACCOUNT_NUM": "",
                        "ENV_NAME": "",
                        "REGION": "",
                        "STAGE_TYPE": "",
                    }
                    ) as mock_environ:
        yield mock_environ


@pytest.mark.parametrize("resource_type, count", [
    ("AWS::S3::Bucket", 1)
])
def test_stack_creates_correct_resource_count(resource_type, count):
    main()
    stack_template = Template.from_stack(main.stage.aws_stack)

    stack_template.resource_count_is(resource_type, count)

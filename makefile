SHELL := /bin/bash
.DEFAULT_GOAL := help
.PHONY: help

help:  ##List the targets
    @LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

create-infrastructure-venv:
    test -d infrastructure/.venv || cd infrastructure && python -m venv .venv
    chmod 755  infrastructure/.venv/bin/activate
    ( \
        source infrastructure/.venv/bin/activate; \
        python3 -m -pip install -r infrastructure/requirements.txt -r requirements-validation.txt; \
    )

create-infrastructure-validations: create-infrastructure-venv
    chmod 755  infrastructure/.venv/bin/activate
    ( \
        source infrastructure/.venv/bin/activate; \
        export PYTHONPATH=$PYTHONPATH:./infrastructure/; \
        \
        echo "Run pycodestyle ..."; \
        pycodestyle --config=.pycodestyle -r infrastructure/app.py -r infrastructure/lib/; \
        \
        echo "Run pylint ..."; \
        pylint infrastructure/app.py infrastructure/lib/; \
    )

create-infrastructure-tests: create-infrastructure-venv
    chmod 755  infrastructure/.venv/bin/activate
    ( \
        source infrastructure/.venv/bin/activate; \
        export PYTHONPATH=./infrastructure/; \
        \
        echo "Run pytest on infrastructure..."; \
        pytest --cov-report= --cov=infrastructure/lib/ infrastructure/tests/; \
    )

create-infrastructure-coverage:
    chmod 755  infrastructure/.venv/bin/activate
    ( \
        source infrastructure/.venv/bin/activate; \
        export PYTHONPATH=./infrastructure/; \
        \
        echo "Run coverage on infrastructure..."; \
        ./do/coverage.sh; \
    )

cdk-synth: create-infrastructure-venv
    npm install aws-cdk -g
    chmod 755  infrastructure/.venv/bin/activate
    ( \
        source infrastructure/.venv/bin/activate; \
        cd infrastructure && cdk synth; \
    )

cdk-deploy: create-infrastructure-venv
    chmod 755  infrastructure/.venv/bin/activate
    ( \
        source infrastructure/.venv/bin/activate; \
        cd infrastructure && cdk deploy --app 'cdk.out/' $(arg1)/* --require-approval never; \
    )
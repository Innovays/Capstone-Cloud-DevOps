# The Makefile includes instructions for: 
# environment configuration, installing, linting and building

# Variables
CLUSTER_ID=hello
REGION_ID=us-west-2
KEY_PAIR_ID=key-pair-us-west-2
DEPLOYMENT_ID=hello-app-modified
NEW_DOCKER_IMAGE=registry.hub.docker.com/innovays/hello-app:latest
CONTAINER_GATE=80
HOST_GATE=8080
KUBECTL=./bin/kubectl

configure:
	# Create a python virtual environment and activate it
	python3 -m venv ~/.devops-project
	# source ~/.devops-project/bin/activate 

install:
	# This should be executed from inside a virtual environment
	echo "Installing: dependencies..."
	pip install --upgrade pip &&\
	pip install -r hello_app/requirements.txt &&\
	echo
	pytest --version
	echo "Set permissions for the scripts"
	chmod +x ./bin/install_*.sh
	echo
	echo "Installing: shellcheck"
	./bin/install_shellcheck.sh
	echo
	echo "Installing: hadolint"
	./bin/install_hadolint.sh
	echo
	echo "Installing: kubectl"
	./bin/install_kubectl.sh
	echo
	echo "Installing: eksctl"
	./bin/install_eksctl.sh
	
test:
	# Additional, optional, tests could be included here
	#python -m pytest -vv hello_app/hello.py
	#python -m pytest 

lint:
	# https://github.com/koalaman/shellcheck: a linter for shell scripts
	./bin/shellcheck -Cauto -a ./bin/*.sh
	# https://github.com/hadolint/hadolint: a linter for Dockerfiles
	./bin/hadolint hello_app/Dockerfile
	# https://www.pylint.org/: a linter for Python source code 
	# This should be executed from inside a virtual environment
	pylint --output-format=colorized --disable=C hello_app/hello.py

start-app:
	python3 hello_app/hello.py

build-docker:
	./bin/build_docker.sh

start-docker: build-docker
	./bin/start_docker.sh

push-docker: build-docker
	./bin/upload_docker.sh

ci-validation:
	# Required file: .circleci/config.yml
	circleci config validate
	
eks-create-cluster: 
	./bin/eks_create_cluster.sh

k8s-deploy: eks-create-cluster
	# If using minikube, first execute: minikube start
	./bin/k8s_deployment.sh

forward-port: 
	# Needed for "minikube" only
	${KUBECTL} port-forward service/${DEPLOYMENT_ID} ${HOST_GATE}:${CONTAINER_GATE}

update-rolling:
	${KUBECTL} get deployments -o wide
	${KUBECTL} set image deployments/${DEPLOYMENT_ID} \
		${DEPLOYMENT_ID}=${NEW_DOCKER_IMAGE}
	echo
	${KUBECTL} get deployments -o wide
	${KUBECTL} describe pods | grep -i image
	${KUBECTL} get pods -o wide

check-rollout-status:
	${KUBECTL} rollout status deployment ${DEPLOYMENT_ID}
	echo
	${KUBECTL} get deployments -o wide

reverse:
	${KUBECTL} get deployments -o wide
	${KUBECTL} rollout undo deployment ${DEPLOYMENT}

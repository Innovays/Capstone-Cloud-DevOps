# AWS DevOps Engineer Project Showcase

####

## Project Details

This project is a culmination of the skills and tools learned in the [Udacity - AWS Cloud DevOps Engineer](https://www.udacity.com/course/cloud-dev-ops-nanodegree--nd9991) program, demonstrating the implementation of various CI/CD tools and cloud services.

### Project Outline

In this project, we apply the DevOps principles to a Python/Flask demo app named ["hello"](./hello_app/hello.py), making use of [CircleCI](https://www.circleci.com) for continuous integration and AWS's [Kubernetes](https://kubernetes.io/)(K8S) service [EKS](https://aws.amazon.com/eks/) for deployment:

* The project's pipeline on [CircleCI](https://www.circleci.com) lints the source code, builds a [Docker](https://www.docker.com/resources/what-container) image and deploys it to Docker Hub.
* The containerized application is then deployed and run on a Kubernetes cluster on [AWS EKS](https://aws.amazon.com/eks/).
* Finally, we update the deployed application with a new version, using a rolling update strategy.

For ease of use, all tasks within this project are contained within a [Makefile](Makefile), which in turn leverages various shell scripts in the [bin](bin) directory.

### Key Tasks

With CI/CD as our strategy, we containerize the application with Docker and deploy it onto a Kubernetes cluster. Here are the primary tasks:

* Set up the Python virtual environment:  `make setup`
* Install necessary dependencies:  `make install`
* Lint the project's code:  `make lint`
  * Lints shell scripts, Dockerfile and Python code
* Create a Dockerfile to containerize the [hello](/hello_app/hello.py) application: [Dockerfile](hello_app/Dockerfile)
* Deploy the containerized application to Docker Hub.
* Deploy a Kubernetes cluster:  `make eks-create-cluster`
* Deploy the application:  `make k8s-deployment`
* Update the application on the cluster, using a rolling update strategy:  `make rolling-update`
* Delete the cluster:  `make eks-delete-cluster`

The CircleCI pipeline([config.yml](.circleci/config.yml)) runs the following tasks automatically:

* `make setup`
* `make install`
* `make lint`
* Build and publish the container image

To verify that the application is running, input your deployment's IP into your browser with port 80, like `http://localhost:80` or `http://LOAD_BALANCER_IP:80`.

You can also use `curl` to test the application: `curl localhost:80` or `curl LOAD_BALANCER_IP:80`

### Tools and Services

* [Circle CI](https://www.circleci.com) - CI/CD service
* [Amazon AWS](https://aws.amazon.com/) - Cloud services
* [AWS EKS](https://aws.amazon.com/eks/) - Amazon Elastic Kubernetes Services
* [AWS eksctl](https://eksctl.io) - The official CLI for Amazon EKS

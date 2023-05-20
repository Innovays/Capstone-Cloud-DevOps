setup:
	# include environment variables
	python3 -m venv ~/.devops
install:
	# install dependencies 
	pip install --upgrade pip &&\
		pip install -r requirements.txt
	wget -O ./hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 &&\
		chmod +x ./hadolint
test:
	#Nothing to test
lint:
	# lint file
	./hadolint Dockerfile
	pylint --disable=R,C,W1203 app.py
all: install lint test

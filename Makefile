tag?=develop

build:
	docker build --no-cache=true -t qoopido/php70:${tag} .
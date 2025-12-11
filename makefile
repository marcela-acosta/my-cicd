include ../../../make.inc
include .env
export

# YOUR CODE HERE
build_docker_image:
	docker build -t ${DOCKER_IMAGE_NAME} -f Dockerfile .

run_docker_image:
	docker run -e PORT=${PORT} -p 8000:${PORT} ${DOCKER_IMAGE_NAME}

push_docker_image:
	docker push ${DOCKER_IMAGE_NAME}

deploy_docker_image:
	gcloud run deploy --image ${DOCKER_IMAGE_NAME} --region europe-west1 --allow-unauthenticated

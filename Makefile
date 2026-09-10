run-project:
	# run project
	@echo "Grafana UI: http://localhost:3000"

test-api:
	curl -X POST "https://localhost/predict" \
     -H "Content-Type: application/json" \
     -d '{"sentence": "Oh yeah, that was soooo cool!"}' \
	 --user admin:admin \
     --cacert ./deployments/nginx/certs/nginx.crt;

build-api:
	docker build -t mlops-nginx_api_v1 -f ./src/api/v1/Dockerfile .
	docker build -t mlops-nginx_api_v2 -f ./src/api/v2/Dockerfile .

run-api:
	docker run --rm -d --name senti-api-v1 -p 8000:8000 mlops-nginx_api_v1
	docker run --rm -d --name senti-api-v2 -p 8001:8000 mlops-nginx_api_v2

stop-api:
	docker stop senti-api-v1
	docker stop senti-api-v2

start-project:
	docker compose -p mlops up -d --build

stop-project:
	docker compose -p mlops down

test:
	bash tests/run_tests.sh
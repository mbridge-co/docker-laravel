install:
	@make build
	@make up
	docker compose exec app composer install
	docker compose exec app cp .env.example .env
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan storage:link
	docker compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh
up:
	docker compose up -d
build:
	docker compose build
remake:
	@make destroy
	@make install
remake-web:
	docker-compose stop web
	docker-compose rm web
	docker-compose up --no-deps --build -d
remake-app:
	docker-compose stop app
	docker-compose rm app
	docker-compose up --no-deps --build -d
stop:
	docker compose stop
down:
	docker compose down --remove-orphans
down-v:
	docker compose down --remove-orphans --volumes
restart:
	@make down
	@make up
destroy:
	docker compose down --rmi all --volumes --remove-orphans
ps:
	docker compose ps
logs:
	docker compose logs
logs-watch:
	docker compose logs --follow
log-web:
	docker compose logs web
log-web-watch:
	docker compose logs --follow web
log-app:
	docker compose logs app
log-app-watch:
	docker compose logs --follow app
log-db:
	docker compose logs db
log-db-watch:
	docker compose logs --follow db
web:
	docker compose exec web bash
app:
	docker compose exec app bash
migrate:
	docker compose exec app php artisan migrate
fresh:
	docker compose exec app php artisan migrate:fresh --seed
seed:
	docker compose exec app php artisan db:seed
dacapo:
	docker compose exec app php artisan dacapo
rollback-test:
	docker compose exec app php artisan migrate:fresh
	docker compose exec app php artisan migrate:refresh
tinker:
	docker compose exec app php artisan tinker
test:
	docker compose exec app php artisan test
optimize:
	docker compose exec app php artisan optimize
optimize-clear:
	docker compose exec app php artisan optimize:clear
cache:
	docker compose exec app composer dump-autoload -o
	@make optimize
	docker compose exec app php artisan event:cache
	docker compose exec app php artisan view:cache
cache-clear:
	docker compose exec app composer clear-cache
	@make optimize-clear
	docker compose exec app php artisan event:clear
db:
	docker compose exec db bash
sql:
	docker compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
redis:
	docker compose exec redis redis-cli
ide-helper:
	docker compose exec app php artisan clear-compiled
	docker compose exec app php artisan ide-helper:generate
	docker compose exec app php artisan ide-helper:meta
	docker compose exec app php artisan ide-helper:models --nowrite
aws-ssm:
	aws ssm start-session --target i-02db00b939b95c364
aws-login:
	aws ecr get-login-password | docker login --username AWS --password-stdin 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com
aws-build-staging:
	docker build --platform linux/amd64 -t marugame-stg-ecs/nginx:latest --target deploy -f ./infra/docker/nginx/Dockerfile --build-arg APP_ENV=staging .
	docker build --platform linux/amd64 -t marugame-stg-ecs/php:latest --target deploy -f ./infra/docker/php/Dockerfile --build-arg APP_ENV=staging .
aws-tag-staging:
	docker tag marugame-stg-ecs/nginx:latest 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com/marugame-stg-ecs/nginx:latest
	docker tag marugame-stg-ecs/php:latest 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com/marugame-stg-ecs/php:latest
aws-push-staging:
	docker push 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com/marugame-stg-ecs/nginx:latest --disable-content-trust=true
	docker push 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com/marugame-stg-ecs/php:latest --disable-content-trust=true
aws-register-task-definition-staging:
	aws ecs register-task-definition --family marugame-stg-ecs --cli-input-json "$(aws ecs describe-task-definition --task-definition marugame-stg-ecs | jq '.taskDefinition | { containerDefinitions: .containerDefinitions }')"
aws-update-service-staging:
	aws ecs update-service --cluster marugame-stg-ecs/marugame-stg-ecs --service marugame-stg-ecs --task-definition marugame-stg-ecs
aws-build-production:
	docker build --platform linux/amd64 -t marugame-prod-ecs/nginx:latest --target deploy -f ./infra/docker/nginx/Dockerfile --build-arg APP_ENV=production .
	docker build --platform linux/amd64 -t marugame-prod-ecs/php:latest --target deploy -f ./infra/docker/php/Dockerfile --build-arg APP_ENV=production .
aws-tag-production:
	docker tag marugame-prod-ecs/nginx:latest 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com/marugame-prod-ecs/nginx:latest
	docker tag marugame-prod-ecs/php:latest 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com/marugame-prod-ecs/php:latest
aws-push-production:
	docker push 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com/marugame-prod-ecs/nginx:latest --disable-content-trust=true
	docker push 127531411257.dkr.ecr.ap-northeast-1.amazonaws.com/marugame-prod-ecs/php:latest --disable-content-trust=true
aws-staging:
	@make aws-build-staging
	@make aws-tag-staging
	@make aws-push-staging
	# @make aws-register-task-definition-staging
	# @make aws-update-service-staging
aws-production:
	@make aws-build-production
	@make aws-tag-production
	@make aws-push-production

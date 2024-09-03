for-linux-env:
	echo "UID=$$(id -u)" >> .env
	echo "GID=$$(id -g)" >> .env
install:
	@make build
	@make up
	docker compose exec app composer install
	docker compose exec app cp .env.example .env
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan storage:link
	docker compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh
create-project:
	mkdir src
	docker compose build
	docker compose up -d
	docker compose exec app composer create-project --prefer-dist laravel/laravel .
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan storage:link
	docker compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh
build:
	docker compose build
up:
	docker compose up --detach
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
remake:
	@make destroy
	@make install
ps:
	docker compose ps
web:
	docker compose exec web bash
app:
	docker compose exec app bash
tinker:
	docker compose exec app php artisan tinker
dump:
	docker compose exec app php artisan dump-server
test:
	docker compose exec app php artisan test
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
optimize:
	docker compose exec app php artisan optimize
optimize-clear:
	docker compose exec app php artisan optimize:clear
cache:
	docker compose exec app composer dump-autoload --optimize
	@make optimize
	docker compose exec app php artisan event:cache
	docker compose exec app php artisan view:cache
cache-clear:
	docker compose exec app composer clear-cache
	@make optimize-clear
	docker compose exec app php artisan event:clear
	docker compose exec app php artisan view:clear
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
	docker compose exec app php artisan ide-helper:models --write --reset
pint:
	docker compose exec app ./vendor/bin/pint --verbose
pint-test:
	docker compose exec app ./vendor/bin/pint --verbose --test

## ECS
aws-ecs-login:
	aws ecr get-login-password --profile 046325697959_operation-administrator | docker login --username AWS --password-stdin 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com
### staging
aws-build-staging:
	docker build --platform linux/amd64 -t crmstg-tawaraya-paseos-ecs/nginx:latest --target deploy -f ./infra/docker/nginx/Dockerfile --build-arg APP_ENV=staging .
	docker build --platform linux/amd64 -t crmstg-tawaraya-paseos-ecs/php:latest --target deploy -f ./infra/docker/php/Dockerfile --build-arg APP_ENV=staging .
aws-tag-staging:
	docker tag crmstg-tawaraya-paseos-ecs/nginx:latest 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com/crmstg-tawaraya-paseos-ecs/nginx:latest
	docker tag crmstg-tawaraya-paseos-ecs/php:latest 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com/crmstg-tawaraya-paseos-ecs/php:latest
aws-push-staging:
	docker push 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com/crmstg-tawaraya-paseos-ecs/nginx:latest --disable-content-trust=true
	docker push 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com/crmstg-tawaraya-paseos-ecs/php:latest --disable-content-trust=true
aws-register-task-definition-staging:
	aws ecs register-task-definition --family crmstg-tawaraya-paseos-ecs --cli-input-json "$(aws ecs describe-task-definition --task-definition crmstg-tawaraya-paseos-ecs | jq '.taskDefinition | { containerDefinitions: .containerDefinitions }')"
aws-update-service-staging:
	aws ecs update-service --cluster crmstg-tawaraya-paseos-ecs/crmstg-tawaraya-paseos-ecs --service crmstg-tawaraya-paseos-ecs --task-definition crmstg-tawaraya-paseos-ecs
aws-staging:
	@make aws-build-staging
	@make aws-tag-staging
	@make aws-push-staging
	# @make aws-register-task-definition-staging
	# @make aws-update-service-staging
### production
aws-build-production:
	docker build --platform linux/amd64 -t crmprod-tawaraya-paseos-ecs/nginx:latest --target deploy -f ./infra/docker/nginx/Dockerfile --build-arg APP_ENV=production .
	docker build --platform linux/amd64 -t crmprod-tawaraya-paseos-ecs/php:latest --target deploy -f ./infra/docker/php/Dockerfile --build-arg APP_ENV=production .
aws-tag-production:
	docker tag crmprod-tawaraya-paseos-ecs/nginx:latest 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com/crmprod-tawaraya-paseos-ecs/nginx:latest
	docker tag crmprod-tawaraya-paseos-ecs/php:latest 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com/crmprod-tawaraya-paseos-ecs/php:latest
aws-push-production:
	docker push 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com/crmprod-tawaraya-paseos-ecs/nginx:latest --disable-content-trust=true
	docker push 046325697959.dkr.ecr.ap-northeast-1.amazonaws.com/crmprod-tawaraya-paseos-ecs/php:latest --disable-content-trust=true
aws-production:
	@make aws-build-production
	@make aws-tag-production
	@make aws-push-production


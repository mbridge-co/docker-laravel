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

# AWS
aws-ssm-staging:
	aws ssm start-session --profile 127531411257_ext01-developer --target i-0d4ca4a57fd596a75
aws-ssm-production:
	aws ssm start-session --profile 127531411257_ext01-developer --target i-097e2bbd54a4e83e1
aws-ssm-portfowarding-staging:
	aws ssm start-session --profile 127531411257_ext01-developer --target i-0d4ca4a57fd596a75 --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"host":["omron-healthcare-prod-rds-instance-1.cqyirad7xvfl.ap-northeast-1.rds.amazonaws.com"],"portNumber":["3306"], "localPortNumber":["3307"]}'
aws-ssm-portfowarding-production:
	aws ssm start-session --profile 127531411257_ext01-developer --target i-097e2bbd54a4e83e1 --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"host":["omron-healthcare-prod-rds-instance-1.cqyirad7xvfl.ap-northeast-1.rds.amazonaws.com"],"portNumber":["3306"], "localPortNumber":["3307"]}'

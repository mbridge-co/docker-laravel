up:
	docker compose up -d
build:
	docker compose build --no-cache --force-rm
laravel-install:
	docker compose exec app composer create-project --prefer-dist laravel/laravel .
create-project:
	mkdir -p src
	@make build
	@make up
	@make laravel-install
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan storage:link
	docker compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh
install-recommend-packages:
	docker compose exec app composer require doctrine/dbal
	docker compose exec app composer require --dev ucan-lab/laravel-dacapo
	docker compose exec app composer require --dev barryvdh/laravel-ide-helper
	docker compose exec app composer require --dev beyondcode/laravel-dump-server
	docker compose exec app composer require --dev barryvdh/laravel-debugbar
	docker compose exec app composer require --dev roave/security-advisories:dev-master
	docker compose exec app php artisan vendor:publish --provider="BeyondCode\DumpServer\DumpServerServiceProvider"
	docker compose exec app php artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"
init:
	docker compose up -d --build
	docker compose exec app composer install
	docker compose exec app cp .env.example .env
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan storage:link
	docker compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh
remake:
	@make destroy
	@make init
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
aws-ssm-staging:
	aws ssm start-session --profile 235277883553_csportalstg-developer --target i-012bd55a6682a1431
aws-ssm-production:
	aws ssm start-session --profile 975768626619_csportalprod-developer --target i-0b169cb691d9740ab
aws-ssm-portfowarding-staging:
	aws ssm start-session --profile 235277883553_csportalstg-developer --target i-012bd55a6682a1431 --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"host":["csportalstg-rds-instance-1.c4nlyouzfqnv.ap-northeast-1.rds.amazonaws.com"],"portNumber":["3306"], "localPortNumber":["3307"]}'
aws-ssm-portfowarding-production:
	aws ssm start-session --profile 975768626619_csportalprod-developer --target i-0b169cb691d9740ab --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"host":["csportalprod-rds-instance-1.cjak4bhminva.ap-northeast-1.rds.amazonaws.com"],"portNumber":["3306"], "localPortNumber":["3307"]}'

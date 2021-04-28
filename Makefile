# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS

# Build the container
create: ## construct the services
	docker-compose create 

dev: ## run services in development mode
	# TODO: Load Ligero in "DEV Mode".
	#docker-compose run 

up: ## run the services and show logs
	docker-compose pull
	docker-compose up -d

run: ## run stack
	docker-compose run 

start: ## start all services 
	docker-compose start 

console: ## open console app
	docker-compose exec web bash

stop: ## stop all services 
	docker-compose stop 

restart: stop start ## restart all services

rm: stop ## stop and remove services
	docker-compose rm 

set-permissions: ## fix files permission on /opt/otrs
	docker-compose exec web otrs.SetPermissions.pl --web-group=www-data

upgrade-containers: ## download new image version and reconstruct services
	docker-compose pull && docker-compose up -d

backup: ## run backup.pl on the web service
	docker-compose exec web /opt/otrs/scripts/backup.pl -d /app-backups

restore: ## restore backup from BACKUP_DATE param format like YYYY-MM-DD_HH-mm
	docker-compose exec web test -f "/app-backups/$(BACKUP_DATE)/Config.tar.gz"
	docker-compose exec web /opt/otrs/scripts/restore.pl -d /opt/otrs/ -b /app-backups/$(BACKUP_DATE)

cron-enable-backup: ## activate daily backup with crontab
	docker-compose exec web test -f /opt/otrs/var/cron/app-backups.dist
	docker-compose exec web Cron.sh stop otrs
	docker-compose exec web mv var/cron/app-backups.dist var/cron/app-backups
	docker-compose exec web Cron.sh start otrs
	docker-compose exec web chown otrs /app-backups

cron-disable-backup: ## deactivate daily backup with crontab
	docker-compose exec web test -f /opt/otrs/var/cron/app-backups
	docker-compose exec web Cron.sh stop otrs
	docker-compose exec web mv var/cron/app-backups var/cron/app-backups.dist
	docker-compose exec web Cron.sh start otrs

elasticsearch-mapping: ## run MappingInstall command
	docker-compose exec -u otrs web otrs.Console.pl Admin::Ligero::Elasticsearch::MappingInstall --DefaultLanguage

elasticsearch-ticket-reindex: ## force reindex tickets 
	docker-compose exec -u otrs web otrs.Console.pl Maint::Ligero::Elasticsearch::TicketIndexRebuild --micro-sleep 5000

elasticsearch-portalfaq-reindex: ## force reindex Portal FAQ 
	docker-compose exec -u otrs web otrs.Console.pl Maint::Ligero::Elasticsearch::PortalFaqIndexRebuild --DefaultLanguage

elasticsearch-portalservice-reindex: ## force reindex Portal Service 
	docker-compose exec -u otrs web otrs.Console.pl Maint::Ligero::Elasticsearch::PortalServiceIndexRebuild --DefaultLanguage

elasticsearch-all-reindex: elasticsearch-indices-delete elasticsearch-ticket-reindex elasticsearch-portalfaq-reindex elasticsearch-portalservice-reindex ## Rebuild all on elasticsearch

elasticsearch-sysctl-config: ## configure server to run elasticsearch service
	sysctl -w vm.max_map_count=262144
	echo 'sysctl -w vm.max_map_count=262144' > /etc/sysctl.d/elasticsearch.conf

elasticsearch-indices: ## show elasticsearch indices
	docker-compose exec -u otrs web curl http://elasticsearch:9200/_cat/indices

elasticsearch-indices-delete: ## show elasticsearch indices
	docker-compose exec -u otrs web curl -XDELETE http://elasticsearch:9200/_all


tail-web-log: ## show web service log
	docker-compose logs -f web 

daemon-stop: ## stop Daemon
	docker-compose exec -u otrs web otrs.Daemon.pl stop

daemon-start: ## start Daemon
	docker-compose exec -u otrs web otrs.Daemon.pl start

daemon-restart: daemon-stop daemon-start ## restart Daemon

clean: stop ## clean all containers, networks and volumes
	   docker-compose down -v 
	   rm -rf ./app/

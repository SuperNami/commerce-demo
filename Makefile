create-core:
	solr create_core -c drupalcommerce_demo

# https://drushcommands.com/drush-8x/sql/sql-dump/
backup-db: cache-rebuild sql-dump

cache-rebuild:
	cd web && drush cache-rebuild

sql-dump:
	cd web && drush sql-dump --result-file=../dumps/commercedemolk-280418-1214.sql

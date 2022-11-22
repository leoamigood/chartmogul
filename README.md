# chartmogul

Please make sure you don't have postgres/redis/rails running locally and ports **5432, 6379, 3000** available, then run

Build docker images
* docker compose build

Run one time migration:
* docker compose run web rails db:create db:migrate

Bring up services:
* docker compose up

In order to load universities data execute rake task as:
* docker compose exec web rake hipolabs:discover\\["finland"\\]

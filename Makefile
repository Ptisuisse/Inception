WP_DIR = ./home/lvan-slu/data/wordpres
DB_DIR = ./home/lvan-slu/data/mariadb
COMPOSE_DIR = ./srcs

up:
	cd $(COMPOSE_DIR) && docker-compose up -d

down:
	cd $(COMPOSE_DIR) && docker-compose down -v
	docker system prune -a --volumes
	sudo rm -rf $(WP_DIR) $(DB_DIR)

default: up


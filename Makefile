WP_DIR = /home/lvan-slu/data/wordpress
DB_DIR = /home/lvan-slu/data/mariadb
COMPOSE_DIR = ./srcs

up:
	@sudo mkdir -p /home/lvan-slu/data/mariadb
	@sudo mkdir -p /home/lvan-slu/data/wordpress
	@mkdir -p ./srcs/requirements/bonus/static-site/dist
	@echo "Starting Docker services from $(COMPOSE_DIR)..."
	cd $(COMPOSE_DIR) && docker-compose up -d

down:
	@echo "Stopping Docker services from $(COMPOSE_DIR)..."
	cd $(COMPOSE_DIR) && docker-compose down -v
	@echo "Pruning Docker system..."
	docker system prune -a -f --volumes
	docker network prune -f
	@echo "Deleting host directories..."
	@sudo rm -rf $(WP_DIR)
	@sudo rm -rf $(DB_DIR)
	@sudo rm -rf ./srcs/requirements/bonus/static-site/dist
	@echo "Cleanup complete."

re: down && up

fclean: down

default: up

.PHONY: up down fclean default

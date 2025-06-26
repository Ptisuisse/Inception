WP_DIR = /home/lvan-slu/data/wordpress
DB_DIR = /home/lvan-slu/data/mariadb
COMPOSE_DIR = ./srcs

up:
	@sudo mkdir -p /home/lvan-slu/data/mariadb
	@sudo mkdir -p /home/lvan-slu/data/wordpress
	@echo "Building static site..."
	@mkdir -p ./srcs/requirements/bonus/static-site/dist
	cd ./srcs/requirements/bonus/static-site && npm install && npm run build
	@echo "Starting Docker services from $(COMPOSE_DIR)..."
	cd $(COMPOSE_DIR) && docker-compose up -d

down:
	@echo "Stopping Docker services from $(COMPOSE_DIR)..."
	cd $(COMPOSE_DIR) && docker-compose down -v

re: fclean up

fclean: down
	@echo "Pruning Docker system..."
	docker system prune -a -f --volumes
	docker network prune -f
	@echo "Deleting host directories..."
	@sudo rm -rf $(WP_DIR)
	@sudo rm -rf $(DB_DIR)
	@sudo rm -rf ./srcs/requirements/bonus/static-site/dist
	@sudo rm -rf ./srcs/requirements/bonus/static-site/node_modules
	@echo "Cleanup complete."

default: up

.PHONY: up down fclean default

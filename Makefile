# Définir des variables de répertoire
WEB_DIR = ./srcs/web
COMPOSE_DIR = ./srcs

# Commande pour lancer Docker Compose depuis le dossier srcs
up:
	cd $(COMPOSE_DIR) && docker-compose up -d

# Commande pour arrêter les containers, supprimer les volumes et le dossier 'web'
down:
	cd $(COMPOSE_DIR) && docker-compose down -v
	sudo rm -rf $(WEB_DIR)

# Cible par défaut, lance "up" si aucune commande n'est donnée
default: up


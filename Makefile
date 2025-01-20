# Variables
DOCKER_COMPOSE = docker compose
PROJECT_NAME = jenkins_sonarqube_project

# Commandes Make
.PHONY: up down restart logs clean build jenkins-logs postgres-logs sonarqube-logs

# Démarrer les services en arrière-plan
up:
	@echo "🚀 Starting services..."
	$(DOCKER_COMPOSE) up -d

# Arrêter les services
down:
	@echo "🛑 Stopping services..."
	$(DOCKER_COMPOSE) down

# Redémarrer les services
restart: down up
	@echo "🔄 Services restarted."

# Voir les logs de tous les services
logs:
	@echo "📜 Viewing logs for all services..."
	$(DOCKER_COMPOSE) logs -f

# Voir les logs de Jenkins
jenkins-logs:
	@echo "📜 Viewing logs for Jenkins..."
	$(DOCKER_COMPOSE) logs -f jenkins

# Voir les logs de PostgreSQL
postgres-logs:
	@echo "📜 Viewing logs for PostgreSQL..."
	$(DOCKER_COMPOSE) logs -f postgres

# Voir les logs de SonarQube
sonarqube-logs:
	@echo "📜 Viewing logs for SonarQube..."
	$(DOCKER_COMPOSE) logs -f sonarqube

# Nettoyer les volumes, conteneurs et images inutilisés
clean:
	@echo "🧹 Cleaning up unused volumes, containers, and images..."
	$(DOCKER_COMPOSE) down --volumes --remove-orphans
	docker system prune -f

# Recréer les conteneurs sans utiliser le cache
build:
	@echo "🔨 Building containers without cache..."
	$(DOCKER_COMPOSE) build --no-cache
	$(DOCKER_COMPOSE) up -d

# Jenkins & SonarQube Docker Setup

Ce projet configure une intégration continue avec Jenkins et SonarQube à l'aide de Docker Compose. Il inclut également des agents Jenkins préconfigurés et un `Makefile` pour simplifier la gestion.

---

## Prérequis

### Linux
Si vous êtes sur Linux, assurez-vous d'augmenter la limite de mémoire mappée par le système :
```bash
sudo sysctl -w vm.max_map_count=262144
```

### Configuration requise
- Docker (v20+)
- Docker Compose (v2+)
- Make (optionnel, pour automatiser les commandes)

---

## Installation et Démarrage

### 1. Créer et démarrer les conteneurs
Pour démarrer les services Jenkins, SonarQube et PostgreSQL :
```bash
docker compose up -d
```

---

### 2. Configuration des services

#### a. Configurer Jenkins
1. Accédez à Jenkins via : [http://localhost:8085](http://localhost:8085).
2. Récupérez le mot de passe initial pour Jenkins :
   ```bash
   docker exec -it jenkins_container bash -c "cat /var/jenkins_home/secrets/initialAdminPassword"
   ```
   ou utilisez :
   ```bash
   docker logs jenkins_container
   ```

#### b. Configurer SonarQube
1. Accédez à SonarQube via : [http://localhost:9090](http://localhost:9090).
2. Connectez-vous avec les identifiants par défaut :
   - **Nom d'utilisateur** : `admin`
   - **Mot de passe** : `admin`

---

## Agents Jenkins

Ajoutez des agents à Jenkins pour exécuter des builds spécifiques à vos projets.

1. Accédez à : [http://localhost:8085/manage/computer/](http://localhost:8085/manage/computer/).
2. Configurez un nouvel agent en fonction de vos besoins.
3. Récupérer le <secret> qu'on utilisera ensuite

### Exemple : Agent NodeJS
Pour ajouter un agent Jenkins avec Node.js, utilisez la commande suivante :
```bash
docker run --platform linux/amd64 -d --network devops --name jenkins_agent_node_container \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --init fredericeducentre/jenkins_agent_node \
  -url http://jenkins_container:8080 <secret> agent_node
```

---

## Gestion avec Makefile

Un `Makefile` est inclus pour simplifier la gestion des conteneurs Docker.

### Commandes disponibles :
- **Démarrer les services** :
  ```bash
  make up
  ```
- **Arrêter les services** :
  ```bash
  make down
  ```
- **Redémarrer les services** :
  ```bash
  make restart
  ```
- **Voir les logs de tous les services** :
  ```bash
  make logs
  ```
- **Voir les logs spécifiques** :
  - Jenkins : `make jenkins-logs`
  - PostgreSQL : `make postgres-logs`
  - SonarQube : `make sonarqube-logs`
- **Nettoyer les volumes et conteneurs inutilisés** :
  ```bash
  make clean
  ```
- **Recréer les images sans cache** :
  ```bash
  make build
  ```

---

## Structure du Projet

- **`docker-compose.yml`** : Définit les services Jenkins, PostgreSQL et SonarQube.
- **`Dockerfile`** : Contient la configuration pour les agents Jenkins personnalisés.
- **`Makefile`** : Automatisation des tâches pour gérer les conteneurs.
- **`README.md`** : Documentation du projet.

---

## Notes

- Les données de Jenkins et PostgreSQL sont persistées via des volumes Docker définis dans `docker-compose.yml`.
- Assurez-vous que vos variables d'environnement sont bien configurées :
  - `POSTGRES_USER`
  - `POSTGRES_PASSWORD`
  - `POSTGRES_DB`
- Pour des besoins spécifiques, modifiez les configurations dans les fichiers correspondants.

---
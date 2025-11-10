# Dockerfile
FROM sonarqube:community

# (Optionnel) Ajouter des plugins SonarQube :
# Place tes .jar dans un dossier local "plugins/" avant build
COPY plugins/*.jar /opt/sonarqube/extensions/plugins/

# (Optionnel) Ajouter des fonts/locales/etc.
RUN apt-get update && apt-get install -y fonts-dejavu && rm -rf /var/lib/apt/lists/*

# Les volumes /opt/sonarqube/{data,extensions,logs} seront montés par docker-compose

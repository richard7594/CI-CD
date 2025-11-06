FROM jenkins/jenkins:lts

USER root

# Installation de Docker CLI et Node.js (NodeSource inclut npm)
RUN apt-get update && \
    apt-get install -y curl gnupg lsb-release ca-certificates && \
    # Ajouter le dépôt Docker
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    # Ajouter le dépôt Node.js (version 20 LTS, plus récente et stable)
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    # Installer Docker CLI + Node.js (npm est inclus)
    apt-get update && apt-get install -y docker-ce-cli nodejs && \
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \

    # Nettoyage
    rm -rf /var/lib/apt/lists/*

  
# Assurer que le groupe docker existe dans le conteneur
RUN groupadd -g 144 docker || true

# Assurer que l'utilisateur Jenkins est bien dans le groupe docker
RUN usermod -aG docker jenkins

USER jenkins


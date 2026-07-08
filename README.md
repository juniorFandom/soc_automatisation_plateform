# SOC Automatisation Platform

## Présentation

**SOC Automatisation Platform** est une plateforme de **Security Operations Center (SOC)** conçue pour centraliser la surveillance de la sécurité, automatiser la réponse aux incidents et gérer l'authentification des utilisateurs au sein d'une architecture unifiée.

Le projet s'appuie exclusivement sur des technologies **Open Source** afin de proposer une solution complète de supervision, de détection des menaces, d'automatisation des réponses et de gestion des identités.

La plateforme intègre les composants suivants :

* **Wazuh** : SIEM/XDR pour la collecte des journaux, la détection des menaces et la génération d'alertes.
* **Ansible** : automatisation des procédures de remédiation et de déploiement.
* **Keycloak** : gestion des identités, des rôles et authentification centralisée (SSO).
* **Liferay** : portail web offrant une interface unique pour l'administration et la visualisation des tableaux de bord de sécurité.

L'objectif principal est de réduire les délais de détection (**MTTD**) et de réponse (**MTTR**) tout en améliorant la traçabilité des actions de sécurité.

---

# Fonctionnalités

La plateforme fournit notamment les fonctionnalités suivantes :

* Centralisation des journaux de sécurité.
* Détection des menaces en temps réel.
* Corrélation des événements de sécurité.
* Génération automatique d'alertes.
* Réponse automatisée aux incidents via Ansible.
* Déploiement automatisé des configurations.
* Authentification unique (Single Sign-On) avec OpenID Connect.
* Gestion centralisée des utilisateurs et des rôles.
* Tableaux de bord personnalisables.
* Reporting et supervision de l'infrastructure.

---

# Technologies utilisées

| Composant      | Description                           |
| -------------- | ------------------------------------- |
| Wazuh          | SIEM / XDR                            |
| OpenSearch     | Stockage et indexation des événements |
| Ansible        | Automatisation et orchestration       |
| Keycloak       | IAM / Single Sign-On                  |
| Liferay        | Portail Web                           |
| Docker         | Conteneurisation                      |
| Docker Compose | Orchestration des conteneurs          |
| Linux          | Environnement d'exécution             |

---

# Objectifs du projet

Le projet poursuit les objectifs suivants :

* Détecter les incidents de sécurité en temps réel.
* Automatiser les actions de remédiation.
* Centraliser la supervision de l'ensemble des équipements.
* Fournir une authentification unique aux utilisateurs.
* Faciliter le déploiement et l'administration des composants.
* Améliorer la visibilité sur l'état de sécurité du système.

---

# Architecture générale

L'architecture de la plateforme est illustrée ci-dessous.

<p align="center">
<img width="799" src="https://github.com/user-attachments/assets/1a39ba97-4a4e-4a46-ae91-1640b74edb6f">
</p>

---

# Structure du projet

```text
soc-project/
│
├── README.md
├── .gitignore
├── .env
│
├── docs/
│   ├── architecture/
│   ├── diagrams/
│   └── screenshots/
│
├── wazuh/
│   ├── rules/
│   ├── decoders/
│   ├── agents/
│   └── configs/
│
├── ansible/
│   ├── inventories/
│   ├── playbooks/
│   ├── roles/
│   └── group_vars/
│
├── keycloak/
│   ├── realm-export/
│   └── configs/
│
├── liferay/
│   ├── dashboards/
│   └── portal-config/
│
├── shuffle/
│   ├── workflows/
│   └── integrations/
│
├── scripts/
│   ├── deploy.sh
│   ├── backup.sh
│   └── monitoring.sh
│
└── docker/
    ├── docker-compose.yml
    └── containers/
```

---

# Architecture fonctionnelle

Le fonctionnement global de la plateforme est le suivant :

1. Les agents Wazuh collectent les journaux des systèmes surveillés.
2. Les événements sont envoyés au Wazuh Manager.
3. Le Manager analyse les événements grâce aux règles de détection.
4. Les alertes sont stockées dans OpenSearch.
5. Les tableaux de bord affichent les alertes via Wazuh Dashboard.
6. Les alertes critiques déclenchent automatiquement des playbooks Ansible.
7. Les playbooks exécutent les actions de remédiation.
8. Les utilisateurs accèdent au portail Liferay.
9. L'authentification est assurée par Keycloak via OpenID Connect (OIDC).

---

# Prérequis

Avant de lancer le projet, assurez-vous de disposer des éléments suivants :

* Docker
* Docker Compose
* Git
* Linux (Ubuntu recommandé)
* 8 Go de RAM minimum (16 Go recommandés)
* 4 processeurs minimum
* Accès Internet

---

# Installation

## 1. Cloner le dépôt

```bash
git clone https://github.com/juniorFandom/soc-project.git

cd soc-project
```

---

## 2. Configurer les variables d'environnement

Copiez le fichier d'exemple :

```bash
cp .env.example .env
```

Puis modifiez les paramètres selon votre environnement :

* mots de passe ;
* ports ;
* adresses IP ;
* certificats ;
* variables Keycloak ;
* variables Liferay.

---

## 3. Construire les images Docker

```bash
docker compose build
```

---

## 4. Démarrer la plateforme

```bash
docker compose up -d
```

---

## 5. Vérifier les conteneurs

```bash
docker ps
```

Tous les services doivent être démarrés.

---

## 6. Vérifier les journaux

```bash
docker compose logs -f
```

---

# Accès aux services

| Service         | URL                     |
| --------------- | ----------------------- |
| Wazuh Dashboard | http://localhost:5601   |
| Wazuh API       | https://localhost:55000 |
| Keycloak        | http://localhost:8080   |
| Liferay         | http://localhost:8081   |

Les ports peuvent être adaptés selon votre fichier `docker-compose.yml`.

---

# Configuration après installation

Une fois la plateforme démarrée, les étapes suivantes doivent être réalisées :

## Wazuh

* Ajouter les agents.
* Vérifier la remontée des journaux.
* Importer les règles personnalisées.
* Tester la génération d'alertes.

## Ansible

* Configurer l'inventaire.
* Tester la connexion SSH.
* Exécuter les playbooks.
* Vérifier l'automatisation.

## Keycloak

* Créer le Realm.
* Importer le Realm si nécessaire.
* Créer les utilisateurs.
* Configurer les rôles.
* Créer le client OpenID Connect.

## Liferay

* Configurer OpenID Connect.
* Déclarer Keycloak comme fournisseur d'identité.
* Vérifier l'authentification SSO.

---

# Tests

Après le déploiement, les tests suivants peuvent être réalisés :

* Vérification des services Docker.
* Vérification de la communication entre les conteneurs.
* Test de connexion au portail Liferay.
* Test d'authentification via Keycloak.
* Génération d'une alerte Wazuh.
* Déclenchement automatique d'un playbook Ansible.
* Vérification des tableaux de bord.

---

# Déploiement

Pour déployer entièrement la plateforme :

```bash
docker compose build

docker compose up -d

docker compose ps
```

---



Ils permettent respectivement :

* le déploiement de la plateforme ;
* la sauvegarde des données ;
* la supervision des services.

---

# Documentation

La documentation complète est disponible dans le dossier :

```text
docs/
```

Elle comprend :

* l'architecture technique ;
* les diagrammes UML ;
* les captures d'écran ;
* les guides d'installation ;
* les procédures d'administration.

---

# Licence

Ce projet est distribué sous licence MIT.

---



Projet académique de mise en œuvre d'une plateforme SOC automatisée reposant sur Wazuh, Ansible, Keycloak et Liferay.

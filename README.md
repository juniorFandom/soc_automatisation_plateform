# soc_automatisation_plateform

Description

Cette plateforme SOC automatisée vise à fournir une solution complète pour la surveillance, la détection, l'investigation et la réponse aux incidents de sécurité. Le projet intègre des composants open-source et des outils d'automatisation pour permettre :

- la collecte et l'analyse centralisée des logs et évènements (Wazuh),
- l'orchestration et l'automatisation des procédures de remédiation (Shuffle, Ansible),
- la gestion des identités et des accès (Keycloak),
- la visualisation et le reporting via un portail de tableaux de bord (Liferay).

Le but est de réduire le délai de détection et de réponse (MTTD/MTTR), d'améliorer la traçabilité des actions et de faciliter le déploiement et la gestion des règles de sécurité dans des environnements hétérogènes.

Les principales fonctionnalités incluent :

- ingestion et corrélation d'événements,
- génération d'alertes et enrichissement automatique des incidents,
- playbooks automatisés pour la réponse aux incidents,
- gestion centralisée des configurations et déploiement via Ansible,
- authentification unique et gestion des rôles avec Keycloak,
- tableaux de bord personnalisables pour le suivi des indicateurs de sécurité.

Projet de Security Operations Center (SOC) automatisé utilisant :

- Wazuh (SIEM/XDR)
- Ansible (Automation)
- Keycloak (IAM/SSO)
- Liferay (Dashboard)

## Objectifs

- Détection des menaces en temps reel
- Réponse automatisée
- Supervision centralisée
- Gestion des accès

## Architecture

<img width="799" height="624" alt="image" src="https://github.com/user-attachments/assets/1a39ba97-4a4e-4a46-ae91-1640b74edb6f" />

## structure du projet

soc-project/
│
├── README.md
├── .gitignore
├── .env
│
├── docs/
│ ├── architecture/ ( architecure du systeme)
│ ├── diagrams/ ( diagramme du systeme)
│ ├── screenshots/
│
├── wazuh/
│ ├── rules/ ( regle de filtrage de wazuh)
│ ├── decoders/
│ ├── agents/
│ └── configs/
│
├── shuffle/
│ ├── workflows/
│ └── integrations/
│
├── ansible/
│ ├── inventories/
│ ├── playbooks/
│ ├── roles/
│ └── group_vars/
│
├── keycloak/
│ ├── realm-export/
│ └── configs/
│
├── liferay/
│ ├── dashboards/
│ └── portal-config/
│
├── scripts/
│ ├── deploy.sh
│ ├── backup.sh
│ └── monitoring.sh
│
└── docker/
├── docker-compose.yml
└── containers

pour lancer le prrojet, les etapes suivantes doivent etre suivies:


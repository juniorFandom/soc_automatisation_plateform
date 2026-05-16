# soc_automatisation_plateform
Ce projet consiste à concevoir et déployer une plateforme SOC (Security Operations Center) moderne permettant la surveillance, la détection et la réponse automatisée aux incidents de cybersécurité au sein d’un système d’information.

Projet de Security Operations Center (SOC) automatisé utilisant :
- Wazuh (SIEM/XDR)
- Shuffle (SOAR)
- Ansible (Automation)
- Keycloak (IAM/SSO)
- Liferay (Dashboard)

## Objectifs
- Détection des menaces
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
│   ├── architecture/
│   ├── diagrams/
│   ├── screenshots/
│
├── wazuh/
│   ├── rules/
│   ├── decoders/
│   ├── agents/
│   └── configs/
│
├── shuffle/
│   ├── workflows/
│   └── integrations/
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
├── scripts/
│   ├── deploy.sh
│   ├── backup.sh
│   └── monitoring.sh
│
└── docker/
    ├── docker-compose.yml
    └── containers/
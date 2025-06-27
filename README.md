# DevOps Project

Ce projet est une démonstration d'Infrastructure as Code (IaC) avec Terraform et Ansible pour déployer une application web sur AWS.

## Architecture

L'architecture du projet comprend :

- Un VPC avec des sous-réseaux publics et privés
- Une passerelle Internet et une passerelle NAT
- Des groupes de sécurité pour contrôler l'accès
- Des instances EC2 pour le frontend et le backend
- Une application web simple avec un frontend et un backend

## Structure du Projet

```
ProjetDevops/
├── frontend/                # Application frontend (HTML, CSS, JS)
├── backend/                 # Application backend (Node.js, Express, SQLite)
├── terraform/               # Configuration Terraform pour AWS
├── ansible/                 # Playbooks Ansible pour la configuration des serveurs
├── .github/workflows/       # Workflows CI/CD GitHub Actions
└── deploy.sh                # Script de déploiement
```

## Prérequis

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.9+)
- [AWS CLI](https://aws.amazon.com/cli/) configuré avec des identifiants valides
- [TFLint](https://github.com/terraform-linters/tflint) pour le linting Terraform
- [Checkov](https://www.checkov.io/1.Welcome/Quick%20Start.html) pour les vérifications de sécurité
- Une paire de clés SSH pour l'accès aux instances EC2

## Configuration

1. Créez une paire de clés SSH dans la console AWS ou utilisez une paire existante.
2. Configurez vos identifiants AWS :

```bash
export AWS_ACCESS_KEY_ID=votre_access_key
export AWS_SECRET_ACCESS_KEY=votre_secret_key
export AWS_DEFAULT_REGION=eu-west-3  # Région Paris
```

3. Définissez le chemin vers votre clé SSH privée :

```bash
export SSH_KEY_PATH=/chemin/vers/votre/cle.pem
```

## Déploiement

Pour déployer l'infrastructure et l'application, exécutez le script de déploiement :

```bash
chmod +x deploy.sh
./deploy.sh
```

Le script effectuera les opérations suivantes :
1. Initialisation et validation de Terraform
2. Exécution de TFLint pour le linting
3. Exécution de Checkov pour les vérifications de sécurité
4. Génération d'un plan Terraform
5. Application du plan Terraform (après confirmation)
6. Configuration des serveurs avec Ansible

## CI/CD

Le projet inclut des configurations CI/CD pour GitHub Actions et GitLab CI :

### GitHub Actions
Un workflow GitHub Actions (`.github/workflows/terraform-ci.yml`) qui effectue les vérifications suivantes :
- Validation de la syntaxe Terraform
- Linting avec TFLint
- Vérifications de sécurité avec Checkov
- Génération d'un plan Terraform (sans l'appliquer)

### GitLab CI
Une configuration GitLab CI (`.gitlab-ci.yml`) qui effectue les mêmes vérifications :
- Validation et formatage Terraform
- Génération d'un plan Terraform
- Linting avec TFLint
- Vérifications de sécurité avec Checkov

**Note importante :** L'application du plan Terraform (`terraform apply`) n'est pas automatisée dans les pipelines CI/CD pour des raisons de sécurité. Cette étape doit être effectuée manuellement après examen du plan, conformément aux bonnes pratiques.

### Pourquoi utiliser les deux plateformes ?
- **GitHub** offre une excellente intégration avec de nombreux outils et une interface utilisateur intuitive
- **GitLab** propose des fonctionnalités CI/CD natives plus avancées et une meilleure gestion des secrets
- L'utilisation des deux plateformes permet de démontrer la portabilité de votre pipeline CI/CD

## Nettoyage

Pour détruire l'infrastructure créée par Terraform :

```bash
cd terraform
terraform destroy
```

## Bonnes Pratiques

- Les identifiants AWS ne sont jamais stockés dans le code
- Les groupes de sécurité limitent l'accès aux services
- Le backend est placé dans un sous-réseau privé pour une sécurité accrue
- Les vérifications de linting et de sécurité sont intégrées au pipeline CI/CD
- L'application du plan Terraform est manuelle pour éviter les modifications accidentelles

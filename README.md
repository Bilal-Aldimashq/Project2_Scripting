# TSSR-Projet2-Groupe_1-TheScriptingProject V1.0
_(Date de documentation 10 octobre 2023)_
# Sommmaire

[1 : Besoin Initiaux :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#besoins-initiaux)

[2 : Etapes d'installation et de configuration :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#%C3%A9tapes-dinstallation-et-de-configuration)

[3 : Roles par Semaine :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#r%C3%B4les-par-semaine)

[4 : Objectif semaine :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#objectif-par-semaines)

[5 : Choix techniques :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#choix-techniques)

[6 : Difficultées rencontrées :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#les-difficult%C3%A9s-rencontr%C3%A9es)

[7 : Solutions :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#les-solutions)

[8 : Test réalisés :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#les-tests-r%C3%A9alis%C3%A9s)

[9 : Axes d'améliorations :](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/README.md#axes-dam%C3%A9liorations)

## Besoins Initiaux
Le projet consiste à créer un script multisupport qui s’exécute sur un serveur et agit sur des clients.

 - A partir du serveur Windows Server, on pourra exécuter un script Powershell qui aura pour cible des ordinateurs clients Windows 10 et Ubuntu, ainsi que leurs utilisateurs.

 - A partir du serveur Debian, on pourra exécuter un script shell bash qui aura pour cible des ordinateurs clients Windows 10 et Ubuntu, ainsi que leurs utilisateurs.

_Les scripts pourront effectuer des actions et/ou récupérer des informations._

## Étapes d'installation et de configuration

Vous trouverez un fichier [Install.md](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/INSTALL.md), qui vous servira d'instruction d'installation étape par étape.

Vous trouverez un fichier [USER_GUIDE.md](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/USER_GUIDE.md), pour vous aider à tout configurer.


##  Rôles par semaine

### Semaine 1 
| NOM | Roles | Taches éffectuées |
| :-- |:----- | :---------- |
| Valentin | Scrum Master | Gestion équipe, Préparation des Daily, Recherche annexes, |
| Bilal | Product Owner | Gestion Projet Client, Création du Trello, Création de la Présentation, Recherche principal, |
| Fabrice | Equipe |  Préparation du depot Github, Recherche principale,|
| Michael | Equipe | Recherche annexes, Préparation Squelette, |

### Semaine 2 
| NOM | Roles | Taches éffectuées |
| :-- |:----- | :---------- |
| Fabrice | Scrum Master | Gestion équipe, Préparation des Daily, Recherche annexes, début script |
| Michael | Product Owner| Gestion Projet Client, Recherche annexes, début script |
| Bilal | Equipe | Recherche annexes, début script |
| Valentin | Equipe | Recherche annexes, début script |

### Semaine 3 
| NOM | Roles | Taches éffectuées |
| :-- |:----- | :---------- |
| Bilal  | Scrum Master | Gestion équipe , préparation des daily , début du script PowerShell |
|  Valentin  |  Product Owner | Gestion projet client , recherches annexes , fin du script Bash |
| Fabrice | Equipe | Recherches annexes , début du script PowerShell |
| Michael | Equipe | Recherches annexes , fin du script Bash |

## Objectif par semaines
### Semaine 1
- Comprendre comment avancer dans le projet
- Mise en place d’un exosquelette de Script
- Préparation et configuration des VM (serveur/client)
- Débuter le Script
- Recherches gestion du fichier de journalisation
- Recherches prise en main terminal par le réseau
- Recherches complémentaires
- Création des Daily
- Création du dépot Github
- Création des livrables

### Semaine 2
- Débuter le Script bash Final
- Recherches gestion du fichier de journalisation
- Recherches complémentaires
- Création des Daily
- Remplissage des livrables
- Préparation Demonstration2
  
### Semaine 3
- Tester toutes les commandes utiliser dans le script
- Finir le script final Bash
- Faire le squelette du script final PowerShell
- Rechercher les commandes PowerShell
- Tester les commandes PowerShell
- Préparer la démo finale
- Remplir les livrables
  
##  Choix Techniques

Pour ce projet, il nous sera demandé d’utiliser un serveur Windows et debian ainsi qu’un client windows et linux

##  Les difficultées rencontrées

Nous avons rencontrés des difficultées sur la journalisation , sur la prise en main à distance à l'aide de WinRM et sur les croisement d'OS .

##  Les solutions 

Il a fallut trouver les bonnes commandes sur la redirection des informations pour avoir le format demmandé par le client , pour WinRM il a fallut bien configurer les machines ainsi que changer leurs noms. Pour les croisement d'OS il a fallut "traduire" les commandes d'un language à l'autre et dans certains cas se connécté en root pour avoir les permissions necessaires pour effectué les actions demander .

##  Les tests réalisés

Pour les test réalisés , il nous fallait tester une à une chaque commandes utiliser dans le script sur les différents clients depuis les différents serveurs en même temps que nous ecrivions le script .

##  Axes d'améliorations

Il y as certaines commandes qui ne fonctionnent pas comme le "WakeOnLan" et d'autres que nous avons réussies juste en locale mais qui ne fonctionnaient pas en croisant les OS , ou a distance . Nous pourions ameliorés certaines redirections d'informations pour qu'elles soient plus précises et peut être que le script qui est fonctionnel néanmoins , pourrait être plus court .

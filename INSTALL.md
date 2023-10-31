# _**Guide d'installation V1.0**_ 
Ce guide d'installation, va vous permettre de suivre _PAS à PAS_ la procédure d'installation 
    
# _**Sommaire**_

[Pré-requis](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/INSTALL.md#pr%C3%A9-requis-) 

[Architecture Reseaux](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/INSTALL.md#architecture-reseaux-) 

[Parametrage Linux](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/INSTALL.md#parametrage-linux-) 
 
[Parametrage Windows](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/blob/main/INSTALL.md#parametrage-windows-) 


## Pré-requis :
- 4 VM avec une adresse IP statique ( 1 serveur windows 2022 , 1 serveur Debian , 1 client Windows 10 , 1 client Ubuntu )
- Avoir une connexion ssh .
- Les machines Windows doivent être sur les plages réseau de 1 à 127 .
- Les machines Linux doivent être sur les plages réseau de 127 à 254 .
- Avoir une connexion WinRM .
- Avoir changé le nom des différentes machines (pour WinRM )
- Différent paquets installé ( openssh-server , nettools , Powershell 7 )
  
## Architecture Reseaux :

||Adresse Réseau|1ère adresse|Dernière Adresse|Adresse de Broacast|Masque de sous réseau|
|---|---|---|---|---|---|
|**Serveur Windows**|_192.168.1.0_|192.168.1.1|192.168.1.11|192.168.1.255|_255.255.255.0_|
|**Client Windows**|_192.168.1.0_|192.168.1.12|192.168.1.127|192.168.1.255|_255.255.255.0_|
|**Serveur Linux**|_192.168.1.0_|192.168.1.128|192.168.1.137|192.168.1.255|_255.255.255.0_|
|**Client Linux**|_192.168.1.0_|192.168.1.138|192.168.1.254|192.168.1.255|_255.255.255.0_|


## Parametrage Linux :
1) **Configuration Machines :**
   
Installé les paquets et les applications necessaire au bon deroulement du script bash .

pour cela on va commencé par installer les mise a jour avec la commande : `sudo apt-get update && apt-get upgrade`

ceci fait nous allons installer Nettools avec la commande : `sudo apt install nettools`, on va continuer avec l'installation de OpenSSH avec la commande : `sudo apt install openssh`.

Pour le bon deroulement du script Powershell on va installer powershell core avec les commandes suivantes : 

`wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb` ; 

`dpkg -i packages-microsoft-prod.deb`; `sudo apt-get update` et `sudo apt-get install -y powershell`


2) **Paramètrage des noms des machines :**

- Mettre
- Editer le fichier _/etc/hostname_ puis rentré le nom désiré pour la machine enregistrer puis quitter .
- Editer le fichier _/etc/hosts_ puis renseigner les adresses IP à coter des noms des machines du réseau , enregistrer et quitter .
 ( choisir des noms reconnaissable )

![Capture d'écran 2023-10-28 102949](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/32019fbc-3254-44be-aa9a-fa5b4cff94e8)

3) **Configuration du SSH**

Editer le fichier **/etc/ssh/sshd_config** , autoriser les utilisateurs voulus avec les lignes suivantes :
     - AllowUsers "nom de l'utilisateur"
     - PermitRootLogin yes

Pour une connexion windows linux en WINRM ajouté la ligne suivante

    - Subsystem powershell /usr/bin/pwsh -sshs -NoLogo -NoProfile

et decommenter la ligne :
    - PasswordAuthentication yes 

![Capture d'écran 2023-10-28 100745](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/8d88f9ba-b533-42c4-8b71-7f5472665a44)

Une fois le fichier **/etc/ssh/sshd_config** editer redemarer le service SSH avec la commande `systemctl restart ssh`

## Parametrage Windows :

1) **Installé openSSH** :

   - Verifier sa présence avec la commande :
     

      ``
     Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
     ``

    - Installer les paquets manquants ( client , server ) avec les commandes :

      ``
      Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
      ``

      ``
      Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
      ``

![Capture d'écran 2023-10-28 165132](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/d0a2491c-88bb-40c6-8b3e-5c34709ab5aa)


- Démarer le service avec la commande :
    

    ``
    Start-Service sshd
    ``

    
- Mettre OpenSSH en démarage automatique :



    ``
    Set-Service -Name sshd -StartupType 'Automatic'
    ``
  
   
- Se connecter en ecrivant la commande suivante dans l'invite de commande :
   

![Capture d'écran 2023-10-28 170616](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/c46633ea-69d8-46d3-8517-43cee7ceb6a1)


3) **Changer le nom de l'ordinateur sur le réseau**

   Aller dans _paramètre_ / Changer le nom du groupe de travail 

   
![Capture d'écran 2023-10-28 171239](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/3ee01725-c615-4068-aff3-0cf143e0045c)



- Mofidier le nom de l'ordinateur 



![Capture d'écran 2023-10-28 172408](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/40f4b6e7-dc5c-4e98-99ef-8484d29a0f29)


4) **Télécharger PowerShell 7**

   - pour télécharger PowerShell 7 taper la commande suivante : `winget install --id Microsoft.Powershell --source winget`
   

5) **Installation de WinRM**

   -Sur le client :

  Ouvrir powershell ISE en administrateur et lancé la commande :  `enable-psremoting`

  Ouvrir CMD et tapé la commande suivante : `reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f`

  Aller dans les paramètres > système > bureau a distance pour activer le service

![Capture d'écran 2023-10-30 214348](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/60ba51dc-9f51-4fd9-822f-e5ad648945f9)

Puis ajouter le/les utilisateurs qui pourronts se connecter a distance en vérifiant le nom 

![Capture d'écran 2023-10-30 214519](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/b495ec03-ab29-44f5-82d0-58cf9b669ed7)

  
    -Sur le Serveur : 


Ouvrir powershell ISE en administrateur et lancé les commandes :  `enable-psremoting` ; `Set-Item WSMan:\localhost\Client\TrustedHosts -Value "<NomDuPcClient>"`


 Aller dans les paramètres > système > bureau a distance pour activer le service


![Capture d'écran 2023-10-30 214348](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/60ba51dc-9f51-4fd9-822f-e5ad648945f9)



6) **Configuration du fichier sshd_config**

   - Désactiver la sécurité sur le fichier : C:\windows\system32\openSSH\sshd_config_default , en faisant un clic droit dessus puis en allant sur propriétés > sécurité > onglet avancé


![Capture d'écran 2023-10-30 220629](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/9136fa5b-ea0e-4b70-adb5-eabd326aaefa)

Il faut modifier le propriétaire du fichier en cliquant sur modifier et en ajoutant l'utilisateur de l'ordinateur pour lui donner les droit de modification du fichier

![Capture d'écran 2023-10-30 220700](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/0226abd2-63d3-4aa0-986c-fb6d79417c40)


![Capture d'écran 2023-10-30 220725](https://github.com/shagoi/TSSR-Projet2-Groupe_1-TheScriptingProject/assets/144699498/69218e35-b9f7-493b-8f11-2cc2c36dbf58)

  
 - Modifier le nom du fichier sshd_config_default en sshd_config 
  
 - Editer le fichier en décommentant la ligne _passwordauthentification yes_ et rajouter la ligne _Subsystem powershell c:/progra~1/powershell/7/pwsh.exe -sshs -NoLogo -NoProfile_


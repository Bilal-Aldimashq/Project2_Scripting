
#--------------------------Description-----------------------------------
#regionDescription
<#
-SYNOPSIS
    Script permettant d'agir sur des postes linux ou windows distants.
    Actions sur les machines et leurs utilisateurs.
    Recherche et exportation d'informations des machines et leurs utilisateurs.
    Journalisations des actions
-OUTPUTS Log File:
    La journalisation sera stockée dans le dossier log_actions.log dans C:\Windows\System32\LogFiles
    Les informations exportées seront stockées dans un fichiers info.log dans  C:\Users\<Utilisateur>\Desktop
- NOTES
    Version:        1.0
    Authors:        Valentin A.; Fabrice C.; Mickaël C.; Bilal M.
    Creation Date:  09/10/2023
    Purpose/Change: 
#>
#endregion
#-----------------------------Action---------------------------------
#regionAction 

#Le script proposera sur quel client (Windows ou Linux)
# Actions sur les utilisateurs :
	# Ajout d'utilisateur :
	# Suppression d'utilisateur : 
	# Suspension d'utilisateur :
	# Modification d'utilisateur :
	# Changement de mot de passe :
	# Ajout à un groupe : 
	# Sortie d’un groupe : 

# Actions sur les ordinateurs clients :
#
	# Arrêt : 
	# Redémarrage 
	# Démarrage (wake-on-lan) :
	# Mise-à-jour du système : 
	# Verrouillage : 
	# Création de répertoire : 
	# Modification de répertoire :  
	# Suppression de répertoire : 
	# Prendre la main à distance :
	# Définition de règles de pare-feu :
#endregion
#---------------------------Journalisation--------------------------------
#regionJournal
# Toutes les actions seront journalisées:
#
# (Commande pour de la journalisation a tester : Date, Who, Uptime) 
#
# Stocké sur le serveur nommé : log_actions.log
# Sur le serveur Windows, dans C:\Windows\System32\LogFiles
# Sur le serveur Debian, dans /var/log
# Les actions seront enregistrées sous la forme :
# <Date>-<Heure>-<Utilisateur>-<Cible>-<TypeDAction>
#
# Avec :
# <Date> au format yyyymmdd
# <Heure> au format hhmmss
# <Utilisateur> est le nom de compte qui exécute le script
# <Cible> est le nom/l’adresse IP de l’ordinateur ou l’utilisateur cible
# <TypeDAction> est à définir
#
# Information sur les utilisateurs :
#
	# Date de dernière connection d’un utilisateur
	# Date de dernière modification du mot de passe
	# Groupe d’appartenance d’un utilisateur
	# Droits/permissions de l’utilisateur
#
# Information sur les Ordinateurs :
#
	# Version de l'OS
	# Espace disque restant
	# Taille de répertoire (qui sera demandé)
	# Liste des lecteurs
	# Adresse IP
	# Adresse Mac
	# Liste des applications/paquets installées
	# Type de CPU, nombre de coeurs, etc.
	# Mémoire RAM totale
	# Liste des ports ouverts
	# Statut du pare-feu
	# Liste des utilisateurs locaux

# Export des informations
#
# Les informations qui seront affichées et/ou demandées seront automatiquement exportées dans 
# un fichier d’information nommé info_<Cible>_<Date>_<Heure>.txt
# Avec :
# <Cible> : Nom d’utilisateur ou de l’ordinateur cible
# <Date> au format yyyymmdd
# <Heure> au format hhmmss
#
# Il sera stocké :
# Sur le serveur Windows, dans C:\Users\<Utilisateur>\Desktop
# Sur le serveur Debian, dans /home/<Utilisateur>/
#endregion
#----------------------------Initialisation----------------------------
#regionInit
Clear-host


$menu1 = @("==================","= CLIENT WINDOWS =","==================","==============================","- Que souhaitez-vous faire ? -","==============================","","1 - Actions Utilisateurs/Ordinateurs",
            "2 - Informations Utilisateurs/Ordinateurs","3 - Quitter","")


$menu2 = @("====================================","= ACTIONS UTILISATEURS/ORDINATEURS =","====================================","","1 - Actions Utilisateurs","2 - Actions Ordinateurs","3 - Retour au Menu Précédent","")
            

$menu3 = @("================================","= ACTIONS SUR LES UTILISATEURS =","================================","","1 - Ajout d'utilisateurs","2 - Suppression d'utilisateurs","3 - Suspension d'utilisateurs",
             "4 - Modification d'utilisateur","5 - Changement de mot de passe","6 - Ajout à un groupe","7 - Sortie d'un groupe","8 - Retour au Menu précédent","")  


$menu4 = @("===============================","= ACTIONS SUR LES ORDINATEURS =","===============================","","1 - Arrêt","2 - Redémarrage","3 - Démarrage (wake-on-lan)","4 - Mise-à-jour du système",
            "5 - Verrouillage session","6 - Création de répertoire","7 - Modification de répertoire","8 - Suppression de répertoire","9 - Prendre la main à distance",
            "10 - Définition des règles de pare-feu","11 - Retour au Menu précédent","")	


$menu5 = @("=========================================","= INFORMATIONS UTILISATEURS/ORDINATEURS =","=========================================","","Que souhaitez vous faire ?","","1 - Informations Utilisateurs",
            "2 - Informations Ordinateurs","3 - Retour au Menu précédent";"")


$menu6 = @("=============================","= INFORMATIONS UTILISATEURS =","=============================","","1 - Date de dernière connection d’un utilisateur","2 - Date de dernière modification du mot de passe",
            "3 - Groupe d’appartenance d’un utilisateur","4 - Droits/permissions de l’utilisateur","5 - Retour au Menu précédent","")


$menu7 = @("============================","= INFORMATIONS ORDINATEURS =","============================","","1 - Version de l'OS","2 - Espace disque restant","3 - Taille du répertoire","4 - Liste des lecteurs",
            "5 - Adresse IP","6 - Adresse Mac","7 - Liste des applications/paquets installés","8 - Type de CPU, nombre de coeurs, etc.","9 - Mémoire RAM totale",
            "10 - Liste des ports ouverts","11 - Statut du pare-feu","12 - Liste des utilisateurs locaux","13 - Retour au Menu précédent","")


$menu8 = @("================","= CLIENT LINUX =","================","==============================","- Que souhaitez-vous faire ? -","==============================","","1 - Actions Utilisateurs/Ordinateurs",
            "2 - Informations Utilisateurs/Ordinateurs","3 - Quitter","")



[int]$end = read-host "Suffixe adresse IP"

$cpu = read-host "Nom de l'ordinateur cible"

$name = Read-Host "Nom d'utilisateur"

Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$cpu"

#endregion
#-------------------------------------------------Functions-----------------------------------------------
#regionfonctions
#regionfonction Windows
#regionfonction Journal
function journal
{
    param([STRING]$journal)
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "[NEW]============================================"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "---------------"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Date et Heure :"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "---------------"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -value $(get-date -format "yyyy/MM/dd HH:mm:ss") 
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "----------------------"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Utilisateur connecté :"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "----------------------"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value $(whoami)
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "-------------------"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Utilisateur cible :"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "-------------------"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "$name"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "----------------------"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Actions/Informations :"
    Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "----------------------"
}

function journalfin
{
   Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "[FIN]============================================"
   Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "" 
}

#endregion
#regionfonction réponse des menus
function choix
{
    $choice = Read-host "Choix N°"
}
#endregion
#regionfonction Ajout utilisateur
function NewUser
{
    Clear-Host
    $name = Read-host "Nom de l'utilisateur à créer"
    if (-not (Get-LocalUser -Name $name -ErrorAction SilentlyContinue))
    {
        $description = Read-Host "Service" 
        New-LocalUser -Name "$name" -Description "$description"
        Write-Host "L'utilisateur $name à bien été créé" -ForegroundColor green
       
    }
    else
    {
        write-host "L'utilisateur $name existe déja" -ForegroundColor Red -ErrorAction SilentlyContinue
    }
    
}
#endregion
#regionFonction supprime user
function DelUser
{
    Clear-Host
    $name = Read-host "Nom de l'utilisateur à supprimer"
    if (Get-LocalUser -Name $name -ErrorAction SilentlyContinue)
    {
        Remove-LocalUser -Name "$name" 
        Write-Host "L'utilisateur $name à bien été supprimé" -ForegroundColor green
    }
    else
    {
        write-host "L'utilisateur $name n'existe pas" -ForegroundColor Red 
    }
}
#endregion    
#regionFonction suspension user
function Susp1
{
    Clear-Host
    $name = Read-host "Nom de l'utilisateur à suspendre"
    if (Get-LocalUser -Name $name -ErrorAction SilentlyContinue)
    {
        Disable-LocalUser -Name "$name"
        Write-Host "L'utilisateur $name à bien été suspendu" -ForegroundColor green
    }
    else
    {
        Write-Host "L'utilisateur $name n'existe pas" -ForegroundColor Red 
    }
}
#endregion
#regionFonction modification user
function Modif
{
    Clear-Host
    $name = Read-host "Nom de l'utilisateur à modifier"
    if (Get-LocalUser -name $name -ErrorAction SilentlyContinue)
    {
        $change = Read-host "Nouveau service"
        Set-LocalUser -Name $name -Description "$change" 
        Write-Host "L'utilisateur $name a été modifié" -ForegroundColor Green 
    }
    else
    {
        Write-Host "L'utilisateur $name n'existe pas" -ForegroundColor Red 
    }
}
#endregion
#regionFonction change de MDP
function Passwd
{
    Clear-Host
    $name = Read-host "Nom de l'utilisateur dont le mot de passe est à modifier"
    if (Get-LocalUser -Name $name -ErrorAction SilentlyContinue)
    {
        $passwd = Read-host "Quel est le nouveau mot de passe" -AsSecureString
        $name | set-localuser -Password $passwd
        Write-Host "Le mot de passe de $name a été changé" -ForegroundColor Green
    }
    else
    {
        Write-Host "L'utilisateur $name n'existe pas" -ForegroundColor Red 
    }   

}
#endregion
#regionFonction Ajout à un groupe
function addgrp
{
    Clear-Host
    $name = Read-host "Nom de l'utilisateur changeant de groupe"
    if (-not (Get-LocalUser -Name $name -ErrorAction SilentlyContinue))
    {
        Write-Host "L'utilisateur $name n'existe pas" -ForegroundColor Red 
        break
    }
    $groupe = read-host "A quel groupe doit-il être ajouté?"
    if (Get-LocalGroup -Name $groupe)
    {
        Add-LocalGroupMember -Group $groupe -Member $name 
        write-host "L'utilisateur $name a été ajouté au groupe $groupe" -ForegroundColor Green
    }
    else
    {
        Write-Host "Le groupe $groupe n'existe pas" -ForegroundColor Red -ErrorAction SilentlyContinue        
    }

}

#endregion
#regionfonction retrait d'un groupe
function supgrp
{
    Clear-Host
    $name = Read-host "Nom de l'utilisateur supprimer du groupe"
    if (-not (Get-LocalUser -Name $name -ErrorAction SilentlyContinue))
    {
        Write-Host "L'utilisateur $name n'existe pas" -ForegroundColor Red 
        break
    }
    $groupe = read-host "De quel groupe doit-il être supprimé?"
    if (Get-LocalGroup -Name $groupe -ErrorAction SilentlyContinue)
    {
        Remove-LocalGroupMember -Group $groupe -Member $name 
        write-host "L'utilisateur $name a été supprimé du groupe $groupe" -ForegroundColor Green
    }
    else
    {
        Write-Host "Le groupe $groupe n'existe pas" -ForegroundColor Red         
    }
}
#endregion
#regionfonction MAJ
function Maj 
{
    Install-Module -name PSwindowsUpdate 
    Get-windowsupdate -acceptall -install -autoreboot
    Write-Host "Système mis à jour"
   
}  
#endregion
#regionfonction Off
function off
{
    Write-host " ATTENTION: Si ID de session inconnu, depuis une console PowerShell ISE, lancer la commande suivante:" -ForegroundColor Red
    Write-Host "Invoke-command -ComputerName <Nom_d'ordinateur> -Credential <Nom_d'utilisateur> -Scriptblock {quser}" -ForegroundColor Cyan
    $NID = Read-Host "Numéro d'ID de la session"
    $off = logoff $NID
    $off
}
#endregion
#regionfonction Rep
function Rep1
{
    $repertoire = Read-Host "Nom du répertoire à créer"
    $chemin = read-host "Chemin du repertoire"
    if (Test-Path $chemin\$repertoire)
    {
      Write-host "Répertoire éxistant" -ForegroundColor Red
      break
    }
    else
    {
        New-Item -Name $repertoire -ItemType Directory -Path $chemin\ 
        Write-Host "Le répertoire $repertoire a été créé" -ForegroundColor Green
    }
}

#endregion
#regionfonction Modif
function modifrep1
{
    $repertoire = Read-Host "Nom du répertoire à modifier"
    $chemin = read-host "Chemin du repertoire"
    if (Test-Path $chemin\$repertoire)
    {
        $new = Read-Host "Nouveau nom du répertoire"
        Rename-Item -NewName $new -Path $chemin\$repertoire  
        Write-Host "Le nom du répertoire $repertoire a été modifié par $new" -ForegroundColor Green 
        break
    }
    else
    {
        Write-host "Répertoire inéxistant" -ForegroundColor Red  
    }
}

#endregion
#regionfonction DelRep
function DelRep
{
    $Del = Read-Host "Nom du répertoire à supprimer"
    $chemin = read-host "Chemin du repertoire"
    if (Test-Path $chemin\$Del)
    {        
        Remove-Item -path $chemin\$Del 
        Write-Host "Le répertoire $Del a été supprimé" -ForegroundColor Green 
        break
    }
    else
    {
        Write-host "Répertoire inéxistant" -ForegroundColor Red  
    }
}

#endregion
#regionfonction Dist
function Dist
{
   param ([string]$conect)
   Write-host "Cette manipulation vous sortira du script pour la connection à distance. Taper Exit pour sortir de la connection distante" -ForegroundColor Cyan 
    Enter-PSSession -ComputerName $cpu -Credential $name -ErrorAction SilentlyContinue
    exit
}

#endregion
#regionfonction Fire
function Fire
{
$fire = $true
while ($fire)
{
Clear-Host

Write-Host "============================"
Write-Host "= ACTIONS SUR LES FIREWALL ="
Write-Host "============================"
Write-host ""
write-host "1 - Etat des pares-feu"
Write-host "2 - Activer pare-feu"
write-host "3 - Désactiver parefeu"
Write-Host "4 - Quitter"
Write-host ""
$wall = read-host "Action N°"
    switch ($wall)
    {
        1{Invoke-command -ComputerName $cpu -credential $name -ScriptBlock {Get-NetFirewallProfile | ft Name, Enabled}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Etat Firewall"; sleep 3}
        2{Invoke-command -ComputerName $cpu -credential $name -ScriptBlock {Set-NetFirewallProfile -Profile * -Enabled True}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Activation Firewall"; sleep 3}
        3{Invoke-command -ComputerName $cpu -credential $name -ScriptBlock {Set-NetFirewallProfile -Profile * -Enabled False}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Desactivation Firewall"; sleep 3}
        4{$fire = $false}
        default{Write-Host "Erreur"}

    }
}
}

#endregion
#regionfonction Connect
function Connect
{
   param ([string]$connect)
  
   $last = Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-ComputerInfo | select "OsLastBootUpTime"}  
   Add-Content -Path "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt" -value "$last"
   $last
   sleep 3
}
#endregion
#regionfonction Lastpass
function lastpass
{
    param([string]$connect)
    
    $passwd = Read-Host "nom d'utilisateur"
    $tab = @($(net user $passwd))
    $tab[8] 
    
}
#endregion
#regionfonction grplocal

function grplocal
{
    param([string]$connect)
    
    $passwd = Read-Host "nom d'utilisateur"
    $tab = @($(net user $passwd))
    $tab[22,23,24]  
    
}
#endregion
#regionfonction Permission
function permission
{
   param ([string]$connect)
  
   $right = Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-Acl}  
   Add-Content -Path "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt" -value "$right"
   $right
   sleep 3
}
#endregion
#regionfonction OS
function OS
{
   param ([string]$label)

  $OS = Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-ComputerInfo | Select Osname,osversion}  
   Add-Content -Path "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt" -value "$OS"
   $OS
   sleep 3   
}
#endregion
#regionfonction Disk
function disk
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-Volume | Select-Object DriveLetter, @{Name="SizeRemainingGB";Expression={[math]::Round($_.SizeRemaining / 1GB,  1)}} | Format-Table -AutoSize} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction Lecteur
function lecteur
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-PSDrive | Select-Object -Property Name} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#

 

#endregion
#regionfonction IP
function IP
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {(Get-NetIPAddress).IPAddress} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction Mac
function Mac
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-NetAdapter | Select-Object -Property macaddress} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction Pqt
function pqt
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-WmiObject -Class Win32_Product | Select-Object Name, Version} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction Hearth
function Hearth
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-WmiObject -Class Win32_Processor | Select-Object Name, NumberOfCores} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction Ram
function Ram
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {(Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction Ports
function Ports
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-NetTCPConnection} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction Status
function Status
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-NetFirewallProfile | ft Name, Enabled} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction User
function User
{
   param ([string]$label)

   Invoke-Command -ComputerName $Cpu -Credential $name -ScriptBlock {Get-LocalUser | Select-Object name, enabled} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"
   Write-Host "Les informations sont enregistrés dans le fichier sur le Desktop" -ForegroundColor Green 
   sleep 3
   
}
#endregion
#regionfonction Size
function Size
{
   $repertoire = Read-Host "Nom de repertoire à traiter"
  $Chemin = Read-Host "Chemin du dossier à traiter"
  if (test-path $Chemin\$repertoire)
  {
    $test = (Get-ChildItem -path $Chemin\$repertoire -file -Recurse| Measure-Object -Property length -Sum).Sum 
    $taillegb = [math]::Round($test / 1Kb, 2) 
    $taillegb
    Write-Host "Informations envoyé dans le fichier sur le bureau" -ForegroundColor Green
    sleep 3
  }
  else
  {
    Write-Host "Dossier introuvable" -ForegroundColor Red
    sleep 3
  }
 }
   
#endregion
#endregion
#regionfonction Linux
#regionfonction ajout utilisateur
function ajout
{
    $user = Read-Host "nom d'utilisateur"
    useradd $user && echo "$user a été crée"
    sleep 3
}
#endregion
#regionfonction suppression utilisateur
Function suppr
{
    $user = Read-Host "nom d'utilisateur"
    deluser $user && echo "$user a été supprimer"
    sleep 3
}
#endregion
#regionfonction suspension utilisateur
Function susp
{
    $user = Read-Host "nom d'utilisateur"
    usermod --expiredate 1 $user && echo "$user à été suspendu"
    sleep 3
}
#endregion
#regionfonction modification utilisateur
Function modifuser
{
    $user = Read-Host "nom d'utilisateur"
    $fullname = read-host "complement de nom  a rajouter"
    usermod - c "$fullname" $user && echo "$user a été modifié"
    sleep 3
}
#endregion
#regionfonction modification mot de passe
Function modifpasswd
{
    $user = Read-Host "nom d'utilisateur"
    passwd -d $user && echo "le mot de passe de $user a été changé"
    sleep 3
}
#endregion
#regionfonction ajout groupe
Function ajtgrp
{
    $user = Read-Host "nom d'utilisateur"
    $grp = Read-Host "nom du groupe"
    gpasswd -a $grp $user && echo "$user a été ajoute a $grp" 
    sleep 3
}
#endregion
#regionfonction sorti groupe
Function sortigrp
{
    $user = Read-Host "nom d'utilisateur"
    $grp = Read-Host "nom du groupe"
    gpasswd --delete $user $grp && echo "$user à été sorti de $grp"
    sleep 3
}
#endregion
#regionfonction création repertoire
function rep
{
    $doss = Read-Host "nom de dossier a créé ? "
    $chemin = Read-Host "chemin du dossier"
    if (test-path $Chemin/$doss)
    {
        mkdir $chemin/$doss && echo "$doss a été crée"
        sleep 3
    }
    else
    {
        Write-Host "Dossier introuvable" -ForegroundColor Red
        sleep 3
    }
}
#endregion
#regionfonction modification repertoire 
function modifrep
{
    $doss = Read-Host "nom de dossier a renommer ? "
    $doss2 = Read-Host "nouveau nom de dossier "
    $chemin = Read-Host "chemin du dossier"
    if (test-path $Chemin/$doss)
    {
        mv $chemin/$doss $chemin/$doss2 && echo "$doss a été modifer"
        sleep 3
    }
    else
    {
        Write-Host "Dossier introuvable" -ForegroundColor Red
        sleep 3
    }
}
#endregion
#regionfonction suppression repertoire
function suprep
{
    $doss = Read-Host "nom de dossier a supprimer ? "
    $chemin = Read-Host "chemin du dossier"
    if (test-path $Chemin/$doss)
    {
         rm -r $chemin/$doss && echo "$doss a été supprimer" 
         sleep 3
    }
    else
    {
        Write-Host "Dossier introuvable" -ForegroundColor Red
        sleep 3
    }
}
#endregion
#regionfonction Firewall
function Fire2
{
$fire = $true
while ($fire)
{
Clear-Host

Write-Host "============================"
Write-Host "= ACTIONS SUR LES FIREWALL ="
Write-Host "============================"
Write-host ""
write-host "1 - Etat des pares-feu"
Write-host "2 - Activer pare-feu"
write-host "3 - Désactiver parefeu"
Write-Host "4 - Quitter"
Write-host ""
$wall = read-host "Action N°"
    switch ($wall)
    {
        1{Invoke-Command -hostname $cpu -username $name -ScriptBlock {ufw status};Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Etat Firewall"; sleep 3}
        2{Invoke-Command -hostname $cpu -username $name -ScriptBlock {ufw enable};Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Activation Firewall"; sleep 3}
        3{Invoke-Command -hostname $cpu -username $name -ScriptBlock {ufw disable};Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Desactivation Firewall" ;sleep 3}
        4{$fire = $false}
        default{Write-Host "Erreur"}

    }
}
}
#endregion
#regionfonction Derniere co
function Derco
{
    $user = Read-Host "nom 'dutilisateur concerné"
    last $user | head -n1 
}
#endregion
#regionfonction dernier chagement mot de passe
function Derpasswd
{
    $user = Read-Host "nom 'dutilisateur concerné"
    passwd -S $user 
}
#endregion
#regionfonction groupe d'appartenance
function Grpappartenace
{
    $user = Read-Host "nom 'dutilisateur concerné"
    cat /etc/passwd | grep "$user" 
}
#endregion
#regionfonction taille repertoire
function taille
{
  $repertoire = Read-Host "Nom de repertoire à traiter"
  $Chemin = Read-Host "Chemin du dossier à traiter"
  if (test-path $Chemin/$repertoire)
  {
    ls -lh $chemin/$repertoire | grep "total"
    Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan
    sleep 3
  }
  else
  {
    Write-Host "Dossier introuvable" -ForegroundColor Red
    sleep 3
  }
 }
 #region Droit et permission
function Droit
{
    $doss1 = Read-Host "permission du dossier"
    $chemin = Read-Host "chemin du dossier"
    if (test-path $chemin/$doss1)
    {
    ls -lh $chemin/$doss1 
    sleep 3
    }
    else
    {
    Write-Host "dossier inexistant" -ForegroundColor Red
    }
}
#endregion
#endregion
#endregion
#endregion



#-----------------------------------------------------Main--------------------------------


journal


if ($end -lt 128)
{
#regionwindows #Script Windows
    
    $continue = $true
    while ($continue)
    {
        Clear-Host
        $menu1 

        $choice = Read-Host "Choix N°"
        switch ($choice)
        {
            1{$bclmenu2 = $true
                while ($bclmenu2)
                {
                    Clear-Host
                    $menu2
                    $choice = Read-Host "Choix N°"
                    switch ($choice)
                    {
                        1 {$bclmenu3 = $true
                         while ($bclmenu3)
                         {
                            Clear-Host
                            $menu3
                            $choice = Read-Host "Choix N°"
                            switch ($choice)
                            {
                                1 {Invoke-Command -ComputerName $Cpu  -Credential $name -ScriptBlock ${function:NewUser}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Création d'utilisateur" sleep 3}
                                2 {Invoke-Command -ComputerName $Cpu  -Credential $name -ScriptBlock ${function:DelUser}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Suppession d'utilisateur"; sleep 3}
                                3 {Invoke-Command -ComputerName $Cpu  -Credential $name -ScriptBlock ${function:Susp1}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Suspension d'utilisateur"; sleep 3}
                                4 {Invoke-Command -ComputerName $Cpu  -Credential $name -ScriptBlock ${function:Modif}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Modification d'utilisateur"; sleep 3}
                                5 {Invoke-Command -ComputerName $Cpu  -Credential $name -ScriptBlock ${function:Passwd}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Modification du mot de passe"; sleep 3}
                                6 {Invoke-Command -ComputerName $Cpu  -Credential $name -ScriptBlock ${function:addgrp}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Ajout d'un utilisateur à un groupe"; sleep 3}
                                7 {Invoke-Command -ComputerName $Cpu  -Credential $name -ScriptBlock ${function:supgrp}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Retrait d'un utilisatteur d'un groupe"; sleep 3}
                                8 {$bclmenu3 = $false}
                                default {Write-Host "Choix invalide" -ForegroundColor Red; sleep 3}
                            }                        

                          }
                          }
                         2 {$bclmenu4 =$true
                            while ($bclmenu4)
                            {
                                Clear-host
                                $menu4
                                $choice = Read-Host "Choix N°"
                                switch ($choice)
                                {
                                    1 {Invoke-Command -ComputerName $cpu -Credential $name -scriptblock {stop-computer -Force}; write-host "L'ordinateur de $name a été arrété" -ForegroundColor Green; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Arrêt de l'ordinateur"; sleep 3}
                                    2 {Restart-Computer -Force -ComputerName $cpu -Credential $name;Write-Host "L'ordinateur de $name a été redémarré" -ForegroundColor Green; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Redémarrage ordinateur" sleep 3}                                  
                                    3 {Write-host "En cours de dévelloppement" -ForegroundColor Cyan;Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Tentative démarrage Wake-on-lane"; sleep 3}
                                    4 {Invoke-Command -ComputerName $cpu -Credential $name -ScriptBlock ${function:Maj}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Mise à jour du système"; sleep 3}
                                    5 {Invoke-Command -ComputerName $cpu -Credential $name -ScriptBlock ${function:Off}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Vérrouillage de session"; sleep 3}
                                    6 {Invoke-Command -ComputerName $Cpu -Credential $name -scriptblock ${function:Rep1}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Création de répertoire"; sleep 3}
                                    7 {Invoke-Command -ComputerName $Cpu -Credential $name -scriptblock ${function:modifrep1}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Modification de répertoire"; sleep 3}
                                    8 {Invoke-Command -ComputerName $Cpu -Credential $name -scriptblock ${function:DelRep}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Suppression de répertoire"; sleep 3}
                                    9 {dist ; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Connexion à distance"}
                                    10 {fire}
                                    11 {$bclmenu4 = $false}
                                    default {Write-Host "Choix invalide" -ForegroundColor red; sleep 3}                        
                                }  
                             }
                           }
                        3 {$bclmenu2 = $false}
                        default {Write-host "Choix invalide" -ForegroundColor red; sleep 3}
                     } #Fin menu 3

                 }  
              }
            2{$bclmenu5 = $true
                while ($bclmenu5)
                {
                    Clear-host
                    $menu5
                    $choice = Read-Host "Choix N°"
                    switch ($choice)
                    {
                        1{$bclmenu6 = $true
                             while ($bclmenu6)
                             {
                                Clear-Host
                                $menu6
                                $choice = Read-Host "Choix N°"
                                switch ($choice)
                                {
                                     1 {connect; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos dernière connection utilisateur"}
                                     2 {Invoke-Command -ComputerName $cpu -Credential $name -ScriptBlock ${function:lastpass} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos modification mot de passe"}
                                     3 {Invoke-Command -ComputerName $cpu -Credential $name -ScriptBlock ${function:grplocal} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos appartenance groupe de l'utilisateur"}
                                     4 {permission;Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos permissions utilisateur"}
                                     5 {$bclmenu6 = $false}
                                     default {Write-Host "Choix invalide" -ForegroundColor red;sleep 3}
                                }
                             }                          
                          }
                        2{$bclmenu7 = $true
                            while ($bclmenu7)
                            {
                                Clear-Host
                                $Menu7
                                $choice = Read-Host "Choix N°"
                                switch ($choice)
                                {
                                    1 {OS; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value " Infos Version d'OS"}
                                    2 {disk; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos Stockage disponible"}
                                    3 {Invoke-command -computername $cpu -Credential $name -ScriptBlock ${function:size} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos Taille de répertoire"}
                                    4 {lecteur; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos lecteurs"}
                                    5 {IP;Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos adresse IP"}
                                    6 {Mac; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos adresse MAC"}
                                    7 {pqt; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos logiciels installés"}
                                    8 {hearth; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos Coeurs ordinateur"}
                                    9 {RAm; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos RAM"}
                                    10 {Ports; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos Ports ouvert"}
                                    11 {Status; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos status des pare-feu"}
                                    12 {User; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos des utilisateurs locaux"}
                                    13{$bclmenu7 = $false}
                                    default {Write-host "Choix invalide" -ForegroundColor red; sleep 3}
                                }
                            }
                         }
                      3{$bclmenu5 = $false}
                      default {Write-host "Choix invalide" -ForegroundColor red; sleep 3}
                    }
                 }
               }                                 
              3{journalfin; $continue = $false}
              default {Write-host "Choix invalide" -ForegroundColor red; sleep 3}
        } #Fin switch menu1
    } #Fin du 1er while

} #fin du then
#endregion
else #Script Linux
{
#regionLinux #Script Windows    
    $continuebis = $true
    while ($continuebis)
    {
        Clear-Host
        $menu8 

        $choice = Read-Host "Choix N°"
        switch ($choice)
        {
            1{$bclmenu2bis = $true
                while ($bclmenu2bis)
                {
                    Clear-Host
                    $menu2
                    $choice = Read-Host "Choix N°"
                    switch ($choice)
                    {
                        1 {$bclmenu3bis = $true
                         while ($bclmenu3bis)
                         {
                            Clear-Host
                            $menu3
                            $choice = Read-Host "Choix N°"
                            switch ($choice)
                            {
                                1 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:ajout}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Création d'utilisateur"; sleep 3}
                                2 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:suppr}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Suppression d'utilisateur"; sleep 3}
                                3 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:susp}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Suspension d'utilisateur"; sleep 3}
                                4 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:modifuser}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "modification utilisateur"; sleep 3}
                                5 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:modifpasswd}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "modification mot de passe"; sleep 3}
                                6 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:ajtgrp}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Ajout Groupe utilisateur"; sleep 3}
                                7 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:sortigrp}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Sorti Groupe utilisateur"; sleep 3}
                                8 {$bclmenu3bis = $false}
                                default {Write-Host "Choix invalide" -ForegroundColor Red; sleep 3}
                            }                        

                          }
                          }
                         2 {$bclmenu4bis =$true
                            while ($bclmenu4bis)
                            {
                                Clear-host
                                $menu4
                                $choice = Read-Host "Choix N°"
                                switch ($choice)
                                {
                                    1 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {shutdown}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "extintion ordinateur"; sleep 3}
                                    2 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {reboot}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Redemarage ordinateur"; sleep 3}                                  
                                    3 {Write-Host "commande en cours de création" -ForegroundColor Cyan; sleep 3}
                                    4 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {apt update && apt upgrade}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Mise a jour"; sleep 3}
                                    5 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {gnome-session-quit --logout}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Verouillage session"; sleep 3}
                                    6 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:rep}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Création de dossier"; sleep 3}
                                    7 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:modifrep}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "modification dossier"; sleep 3}
                                    8 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:suprep}; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "suppression dossier"; sleep 3}
                                    9 {write-host "cette action fermera le script pour une prise en main a distance" ;Enter-PSSession -hostname $cpu -username $name ;exit}
                                    10 {fire2}
                                    11 {$bclmenu4bis = $false}
                                    default {Write-Host "Choix invalide" -ForegroundColor red; sleep 3}                        
                                }  
                             }
                           }
                        3 {$bclmenu2bis = $false}
                        default {Write-host "Choix invalide" -ForegroundColor red; sleep 3}
                     } #Fin menu 2bis

                 }  
              }
            2{$bclmenu5bis = $true
                while ($bclmenu5bis)
                {
                    Clear-host
                    $menu5
                    $choice = Read-Host "Choix N°"
                    switch ($choice)
                    {
                        1{$bclmenu6bis = $true
                             while ($bclmenu6bis)
                             {
                                Clear-Host
                                $menu6
                                $choice = Read-Host "Choix N°"
                                switch ($choice)
                                {
                                     1 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:Derco} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos modification mot de passe"}
                                     2 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:Derpasswd} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos modification mot de passe"}
                                     3 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:Grpappartenace} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Infos modification mot de passe"}
                                     4 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:droit} > "C:\Users\Administrator\Desktop\info_$name_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Droit et permission utilisateur"; sleep 3}
                                     5 {$bclmenu6bis = $false}
                                     default {Write-Host "Choix invalide" -ForegroundColor red;sleep 3}
                                }
                             }                          
                          }
                        2{$bclmenu7bis = $true
                            while ($bclmenu7bis)
                            {
                                Clear-Host
                                $Menu7
                                $choice = Read-Host "Choix N°"
                                switch ($choice)
                                {
                                    1 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {lsb_release -d} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Version OS"}
                                    2 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {df -h | awk '{print $1, $4}'} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Espace disque Restant"}
                                    3 {Invoke-Command -hostname $cpu -username $name -ScriptBlock ${function:taille} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Taille du repertoire"}
                                    4 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {lshw -C disk} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Liste des Lecteurs"}
                                    5 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {ip a | grep "inet"} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Adresse IP"}
                                    6 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {ip a | grep "link/ether"} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Adresse MAC"}
                                    7 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {grep "install" /var/log/apt/history.log && echo "" && grep "install" /var/log/dpkg.log} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Liste des Application et paquets installées"}
                                    8 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {lshw -short | grep -E "system|processor"} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Type de CPU, nombre de coeurs, etc."}
                                    9 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {lshw -short | grep -E "memory"} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Mémoire RAM totale"}
                                    10 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {netstat -l} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Liste des ports ouverts"}
                                    11 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {ufw status} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Statut du pare-feu"}
                                    12 {Invoke-Command -hostname $cpu -username $name -ScriptBlock {getent passwd | grep "home"} > "C:\Users\Administrator\Desktop\info`_$name`_$(get-date -Format "yyyy-MM-dd_HH-mm-ss").txt"; Write-Host "information envoyée sur le Desktop" -ForegroundColor Cyan; sleep 3; Add-Content -path 'C:\Windows\System32\LogFiles\journal.txt' -Value "Liste des utilisateurs locaux"}
                                    13{$bclmenu7bis = $false}
                                    default {Write-host "Choix invalide" -ForegroundColor red; sleep 3}
                                }
                            }
                         }
                      3{$bclmenu5bis = $false}
                      default {Write-host "Choix invalide" -ForegroundColor red; sleep 3}
                    }
                 }
               }                                 
              3{journalfin; $continuebis = $false}
              default {Write-host "Choix invalide" -ForegroundColor red; sleep 3}
        } #Fin switch menu5bis
    } #Fin du 1er while
}
#endregion

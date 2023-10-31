#! /bin/bash
#---------------------------------- DESCRIPTION ----------------------------------

#---------------------------------- ACTION ----------------------------------
# Le script proposera sur quel client se connecter (windows, linux)
# Il effectuera les actions suivantes sur les clients et sur les ordinateurs.
#
# Actions sur les utilisateurs :
	# Ajout d'utilisateur 
	# Suppression d'utilisateur 
	# Suspension d'utilisateur 
	# Modification d'utilisateur 
	# Changement de mot de passe 
	# Ajout à un groupe 
	# Sortie d’un groupe 
#
# (tester les utilisateurs : cat /etc/passwd | grep $utilisateur)
# (tester le groupes : groups) 
#
# Actions sur les ordinateurs clients :
#
	# Arrêt  
	# Redémarrage 
	# Démarrage (wake-on-lan) : wakeonlan
	# Mise-à-jour du système 
	# Verrouillage  
	# Création de répertoire 
	# Modification de répertoire  
	# Suppression de répertoire  
	# Prendre la main à distance : (VNC oui ou non)
	# Définition de règles de pare-feu 
#
#---------------------------------- JOURNALISATION ----------------------------------
#
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
#
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
# Sur le serveur Debian, dans /home/<Utilisateur>/
#---------------------------------- FONCTION ----------------------------------

function journal()
{
	des="/var/log/journal.log"
	echo "[NEW]---------------" >> $des
	echo "Date et Heure :" >> $des
	echo $( date "+%F %H:%M:%S") >> $des
	echo "Utilisateurs connectés :" >> $des
	echo $(w -hi) | awk '{print $1}' >> $des
	echo "Utilisateur ciblé :" >> $des
	echo "$cible" >> $des
	echo "Actions :" >> $des
	echo "=========" >> $des
}

function journalfin()
{
	des="/var/log/journal.log"
	echo "[FIN]---------------" >> $des
	echo "" >> $des
}

function Menu1()
{
	echo "==========="
 	echo "= WINDOWS ="
	echo "==========="
	echo "=============================="
	echo "- Que souhaitez vous faire ? -"
	echo "=============================="
	echo ""
	echo "1 - Actions Utilisateurs/Ordinateurs"
	echo "2 - Informations Utilisateurs/Ordinateurs"
	echo "3 - Quitter"
	echo ""
}

function Menu2()
{
	echo "=================================="
 	echo "= ACTION UTILISATEUR/ORDINATEURS ="
	echo "=================================="
	echo "=============================="
	echo "- Que souhaitez vous faire ? -"
	echo "=============================="
	echo ""
	echo "1 - Actions Utilisateurs"
	echo "2 - Actions Ordinateurs"	
	echo "3 - Retour Menu Precedant"
	echo ""	
}

function Menu3()
{
	echo "=============================="	
 	echo "= ACTION SUR LES UTILISATEUR ="
	echo "=============================="
	echo ""
	echo "1 - Ajout d'utilisateurs"
	echo "2 - Suppression d'utilsateurs"
	echo "3 - Suspension d'utilisateurs"
	echo "4 - Modification d'utilisateur"
	echo "5 - Changement de mot de passe"
	echo "6 - Ajout à un groupe"
	echo "7 - Sortie d'un groupe"
	echo "8 - Retour Menu précédent"
	echo ""		
}

function Menu4()
{
	echo "============================="
 	echo "= ACTION SUR LES ORDINATEUR ="
	echo "============================="
	echo ""
	echo "1 - Arrêt"	
	echo "2 - Redémarrage"
	echo "3 - Démarrage (wake-on-lan)"
	echo "4 - Mise-à-jour du système" 
	echo "5 - Verrouillage"
	echo "6 - Création de répertoire"
	echo "7 - Modification de répertoire" 
	echo "8 - Suppression de répertoire"
	echo "9 - Prendre la main à distance"
	echo "10 - Définition de règles de pare-feu"
	echo "11 - Retour Menu précédent"
	echo ""
}

function Menu5()
{
	echo "========================================"
 	echo "= INFORMATION UTILISATEURS/ORDINATEURS ="
	echo "========================================"
	echo ""
	echo "Que souhaitez vous faire ?"
	echo "1 - Informations Utilisateurs"
	echo "2 - Informations Ordinations"
	echo "3 - Retour Menu precedant"
	echo ""
}

function Menu6()
{
	echo "============================="
 	echo "= INFORMATIONS UTILISATEURS ="
	echo "============================="
	echo ""
	echo "1 - Date de dernière connection d’un utilisateur"
	echo "2 - Date de dernière modification du mot de passe"
	echo "3 - Groupe d’appartenance d’un utilisateur"
	echo "4 - Droits/permissions de l’utilisateur (administrateur only)"
	echo "5 - Retour Menu précédent"
	echo ""
}

function Menu7()
{
	echo "============================"
 	echo "= INFORMATIONS ORDINATEURS ="
	echo "============================"
	echo ""
	echo "1 - Version de l'OS"
	echo "2 - Espace disque restant"  
	echo "3 - Taille de répertoire"
	echo "4 - Liste des lecteurs"
	echo "5 - Adresse IP"
	echo "6 - Adresse Mac"
	echo "7 - Liste des applications/paquets installées"
	echo "8 - Type de CPU, nombre de coeurs, etc."
	echo "9 - Mémoire RAM totale" 
	echo "10 - Liste des ports ouverts"
	echo "11 - Statut du pare-feu"
	echo "12 - Liste des utilisateurs locaux"
	echo "13 - Retour Menu précédent"
	echo ""
}

function Menu8() 
{
	echo "========="
 	echo "= LINUX ="	
	echo "========="
	echo "=============================="
	echo "- Que souhaitez vous faire ? -"
	echo "=============================="
	echo ""
	echo "1 - Actions Utilisateurs/Ordinateurs"
	echo "2 - Informations Utilisateurs/Ordinateurs"
	echo "3 - Quitter"
	echo ""
}

function Menu9() 
{
	echo "============"
 	echo "= Firewall ="	
	echo "============"
	echo "=============================="
	echo "- Que souhaitez vous faire ? -"
	echo "=============================="
	echo ""
	echo "1 - Etats Firewall"
	echo "2 - Activer firewall"
	echo "3 - Désactiver firewall"
	echo "4 - REtour Menu Precedent"
	echo ""
}

#---------------------------------- VARIABLE ----------------------------------

des2="/var/log/journal.log"

admin=$(whoami)

cible=$1

adresse="127"

debut="192.168.1."

#------------------------------------ MAIN -----------------------------------

journal

if [ -z $1 ]
then 
	clear
 	echo "ARGUMENTS manquants : nom d'utilisateur et adresse IP "
	journalfin	
	exit 1
else
	if [ "$2" -lt "$adresse" ]
	then 	

		while true
		do
		clear
		Menu1
		read reponse2

		case $reponse2 in
			1)
				while true 
				do 
				clear
				Menu2
				read reponse3

				case $reponse3 in	
					1)			
						while true 
						do
						clear
						Menu3
						read reponse4 	

						case $reponse4 in
							1)
								echo "creation utilisateur" >> $des2
								read -p "nom utilisateur : " util 
								ssh $1@$debut$2 net user $util /add && echo "utilisateur $util à été créé" 
								sleep 3;;
				                        2)
								echo "suppression utilisateur" >> $des2
								read -p "nom utilisateur : " util2 
								ssh $1@$debut$2 net user $util2 /delete && echo "utilisateur $util2 à été supprimé" 
								sleep 3;;
							3)	 
								echo "desactivé utilisateur" >> $des2
								read -p "nom utilisateur : " util3 
								ssh $1@$debut$2 net user $util3 /active:no && echo "utilisateur $util3 à été desactivé"
								sleep 3;;
							4)
								echo "modifier utilisateur" >> $des2
								read -p "nom utilisateur : " util4
       								read -p "donnez nom complet de l'utilisateur : " rep1
								ssh $1@$debut$2 net user $util4 /fullname:"$rep1" && echo "utilisateur $user4 à été modifié"
								sleep 3;;
							5)
								echo "changement de mot de passe" >> $des2
								read -p "nom d'utilisateur a change le mot de passe : " util5
								read -p "nouveau mot de passe : " pass1
					            		ssh $1@$debut$2 net user $util5 $pass1 && echo "le mot de passe de l'utilisateur $util5 à été changé."
								sleep 3;;						
							6)
								echo "changement de groupe utilisateur" >> $des2
								read -p "nom utilisateur : " util6
								read -p "nom du groupe  : " group1
								ssh $1@$debut$2 net localgroup $group1 $util6 /add && echo "utilisateur $util6 a été ajouté au groupe $group1 "
								sleep 3;;	
	       					7)
								echo "sorti de groupe utilisateur" >> $des2
								read -p " nom d'utilisateur : " util7
								read -p " nom de groupe : " group2
								ssh $1@$debut$2 net localgroup $group2 $util7 /delete && echo "l'utilisateur $util7 à été sorti du groupe $group2"
								sleep 3;;			
							8)
								echo "retour Menu Precedant"
								break;; 
							*)
								echo "Choix Invalide";;
						esac
						done;;
					2)
						while true 
						do
						clear
						Menu4
						read reponse5 	
	
						case $reponse5 in
							1)
								echo "arret ordinateur" >> $des2
								ssh $1@$debut$2 shutdown -s -f && echo "l'ordinateur $2 va s'eteindre"
								sleep 3;;
							2)
								echo "redemarrage ordinateur" >> $des2
								ssh $1@$debut$2 shutdown /s && echo "l'ordinateur $2 va redémarrer"
								sleep 3;;
							3)	 
								echo "commande en cours de création"
       								sleep 3;;	
							4)
								echo "commande impossible en CMD actuel"
      								sleep 3;;
							5)
								echo "commande impossible en CMD actuel"							
								sleep 3;;
							6)
								echo "creation dossier" >> $des2
								read -p "nom de dossier a crée : " doss1						
	       							ssh $1@$debut$2 md $doss1 && echo "le dossier $doss1 a été crée"
								sleep 3;;
							7)
								echo "modification dossier" >> $des2
								read -p "nom de dossier a modifier : " doss2
	       							read -p " quel nom voulez-vous donnez au dossier $doss2 : " doss3
		      						ssh $1@$debut$2 ren $doss2 $doss3 && echo "le dossier $doss2 a été renommé en $doss3"
								sleep 3;;		
							8) 
								echo "suppression dossier" >> $des2
								read -p "nom de dossier a supprimer : " doss4
								ssh $1@$debut$2 rd $doss4 && echo "le dossier $doss4 a été supprimer"
								sleep 3;;
							9)
								echo "Prise en main a distance" >> $des2
								echo "attention cette action lancera la prise en main a distance et fermera le script"
								ssh $1@$debut$2 
								exit;;
							10)
							 	while true
								do
								clear 
								Menu9
								read reponsebis

								case $reponsebis in
									1)
										echo "Etat Firewall" >> $des2
										ssh $1@$debut$2 netsh advfirewall show allprofiles
										sleep 5;;
									2)
										echo "activation firewall" >> $des2
										ssh $1@$debut$2 netsh advfirewall set allprofiles state on && echo "firewall activé"
										sleep 3;;
									3)
										echo "desactivation firewall" >> $des2
										ssh $1@$debut$2 netsh advfirewall set allprofiles state off && echo "firewall désactivé"
										sleep 3;;
									4)
										echo "retour Menu Précédent"
										break;;
									*)
										echo "Choix Invalide";;  
								esac
								done;;
							11)
								echo "retour Menu Precedant"
								break;; 
							*)
								echo "Choix Invalide";;
						esac
						done;;
				3)
					echo "Retour Menu precedant"
					break;;
				*)	
					echo "Choix Invalide";;
				esac
				done;;
			2)
				while true 
				do 
				clear
				Menu5
				read reponse6
				
				case $reponse6 in
					1)			
						while true 
						do
						clear
						Menu6
						read reponse7 	
	
						case $reponse7 in
							1)
								echo "Date derniere connection" >> $des2
								read -p "nom utilisateur : " util8 
								ssh $1@$debut$2 "net user $util8 | findstr "Dernier"" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							2)
								echo "Date de derniere modification du mot de passe" >> $des2
								read -p "nom utilisateur : " util9 
								ssh $1@$debut$2 "net user $util9 | finstr "dernier"" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							3)	 
								echo "Groupe d'appartenance" >> $des2
								read -p "nom utilisateur : " util10 
								ssh $1@$debut$2 "net user $util10 | findstr "locaux"" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							4)
								echo "Droits/Permissions utilisateur" >> $des2
								read -p "nom utilisateur : " util11 
								ssh $1@$debut$2 "net user $util11 | findstr "Appart*"" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							5)
								echo "retour Menu Précédent"
								break;; 
							*)
								echo "Choix Invalide";;
						esac
						done;;
					2)
						while true 
						do
						clear
						Menu7
						read reponse8 	
	
						case $reponse8 in
							1)
								echo "Version de L'OS" >> $des2
								ssh $1@$debut$2 ' systeminfo | find "exploitation" | find "Windows"' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							2)
								echo "Espace disque restant" >> $des2
								ssh $1@$debut$2 ' chkdsk | find "disponibles" | find "Ko"' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							3)	 
								echo "Taille du repertoire" >> $des2
								read -p "Nom de dossier : " NomDeDossier 
								ssh $1@$debut$2 "dir $NomDeDossier | findstr "octet"" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							4)
								echo "Liste des lecteurs" >> $des2
								ssh $1@$debut$2 'wmic logicaldisk get caption' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							5)
								echo "Adresse IP" >> $des2
								ssh $1@$debut$2 'ipconfig | find "IP"' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							6)
								echo "Adresse MAC" >> $des2
								ssh $1@$debut$2 'ipconfig /all | find "physique"' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							7)
								echo "Liste des applications/paquets installées" >> $des2
								ssh $1@$debut$2 'wmic product get name' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							8) 
								echo "Type de CPU, nombre de coeurs, etc." >> $des2
								ssh $1@$debut$2 'wmic cpu get caption, deviceid, numberofcores' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							9)
								echo "Memoire RAM totale" >> $des2
								ssh $1@$debut$2 'systeminfo | find "physique"' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							10)
							 	echo "Liste des ports ouverts" >> $des2
								ssh $1@$debut$2 'netstat -a' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							11)
								echo "Statut du pare-feu" >> $des2
								ssh $1@$debut$2 'netsh advfirewall show allprofiles | find "tat"' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							12)
								echo "Liste des utilisateurs locaux" >> $des2
								ssh $1@$debut$2 'net user' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
								echo "Fichier crée dans le /home"
								sleep 3 ;;
							13)
								echo "retour Menu Precedant"
								break;; 
							*)
								echo "Choix Invalide";;
						esac
						done;;
					3)
						echo "Retour Menu precedant"
						break;;
					*)	
						echo "Choix Invalide";;
				esac
				done;;	
			3)	
				journalfin
				exit 1;;
			*)
				echo "Choix Invalide";;
			esac
			done
	else	
		while true 
		do
		clear
		Menu8
		read reponse9

		case $reponse9 in
			1)
				while true 
				do 
				clear
				Menu2
				read reponse10

				case $reponse10 in
				1)			
					while true 
					do
					clear
					Menu3
					read reponse11 	

					case $reponse11 in
						1) 
							echo "creation utilisateur" >> $des2
							read -p "Nom d'utilisateur : " util11
							ssh $1@$debut$2 " 
							if cat /etc/passwd | grep "$util11"
							then
								echo "utilisateur existant"
								sleep 3
							else
								useradd $util11 && echo "$util11 a été créé"
								sleep 3
							fi";;
						2)
							echo "supression utilisateur" >> $des2
							read -p "Nom d'utilisateur à supprimer : " util12
							ssh $1@$debut$2 " 
							if cat /etc/passwd | grep "$util12"
							then
								deluser $util12 && echo "$util12 est supprimé"
								sleep 3
							else
								echo "utilisateur inexistant"
								sleep 3
							fi";; 
						3)	 
							echo "suspension utilisateur" >> $des2
							read -p "Nom d'utilisateur à suspendre : " util13
							ssh $1@$debut$2 "
							if cat /etc/passwd | grep "$util13"
							then
								usermod --expiredate 1 $util13 && echo "$util13 est suspendu."
								sleep 3
							else
								echo "utilisateur inexistant"
								sleep 3
							fi";; 
						4)
							echo "modification utilisateur" >> $des2
							read -p "Nom d'utilisateur à modifier : " util14
							ssh $1@$debut$2 "
							if cat /etc/passwd | grep "$util14"
							then
								chfn $util14 && echo "$util14 a été modifié."
								sleep 3
							else
								echo "utilisateur inexistant"
								sleep 3
							fi";;
						5)
							echo "modification de mot de passe" >> $des2
							read -p "Nom d'utilisateur dont le mot de passe sera modifié : " util15
							ssh $1@$debut$2 "
							if cat /etc/passwd | grep "$util15"
							then
								passwd $util15  && echo "Le mot de passe de $util15 a été modifié."
								sleep 3
							else
								echo "utilisateur inexistant"
								sleep 3
							fi";;
						6)
							echo "ajout au groupe" >> $des2
							read -p "Quel utilisateur est concérné ? : " util16
							read -p "A quel groupe $util16 sera ajouté ? : " grp
							ssh $1@$debut$2 "
							if cat /etc/passwd | grep "$util16"
							then
								gpasswd -a $grp $util16 && echo "$util16 a été ajouté au groupe $grp."
								sleep 3
							else
								echo "utilisateur inexistant"
								sleep 3
							fi";;
						7)
							echo "sorti groupe" >> $des2
							read -p "Quel utilisateur est concérné ? : " util17
							read -p "A quel groupe $util17 sera enlevé ? : " grp2
							ssh $1@$debut$2 "
							if cat /etc/passwd | grep "$util16"
							then
								gpasswd --delete $util17 $grp2 && echo "$util17 a été ajouté au groupe $grp2."
								sleep 3
							else
								echo "utilisateur inexistant"
							sleep 3
							fi";;
						8)
							echo "retour Menu Precedant"
							break;; 
						*)
							echo "Choix Invalide";;
					esac
					done;;
				2)
					while true 
					do
					clear
					Menu4
					read reponse12	
					
					case $reponse12 in
						1)	
							echo "extinction ordinateur" >> $des2
							ssh $1@$debut$2 shutdown now && echo "l'ordinateur $2 va s'eteindre"
							sleep 3;;
						2)
							echo "redemarage ordinateur" >> $des2
							ssh $1@$debut$2 reboot && echo "l'ordinateur $2 va redémarer"
							sleep 3;;
						3)	
							echo "commande en cours de création"
       						sleep 3;;
						4)
							echo "Mise a jour" >> $des2
							ssh $1@$debut$2 apt update && apt upgrade && echo "Mise a jour effectuer"
							sleep 3;;
						5)  
							echo "Verouillage session" >> $des2
							ssh $1@$debut$2 gnome-session-quit --logout && echo "l'utilisateur $1 à été fermé." 
							sleep 3;;
						6)  
							echo "creation dossier" >> $des2
							read -p "nom de dossier a créé ? : " dossier
							read -p "nom de chemin : " chemin
							ssh $1@$debut$2"
								if [ -d "$chemin/$dossier" ];
								then
									echo "dossier existant" 
									sleep 3
								else 
									mkdir $chemin/$dossier && echo "le dossier $dossier à été créé"
									sleep 3
								fi";;
						7)
							echo "modifier dossier" >> $des2
							read -p "chemin du dossier a modifier : " dossier
							read -p "nouveau chemin du dossier : " chemin
							ssh $1@1$debut$2 "
							if [ -d "$dossier" ];
							then
								mv $dossier $chemin && echo "le dossier $dossier à ete modifier"
							sleep 3
							else 
								echo "dossier inexistant"
								sleep 3
							fi";;
						8) 
							echo "suppression dossier" >> $des2
							read -p "nom de dossier a supprimer ? : " dossier3
							read -p "nom du chemin : " chemin3
							ssh $1@$debut$2 "
							if [ -d "$chemin3/$dossier3" ]
							then
								rm -r $chemin3/$dossier3 && echo "dossier $dossier3 à été supprimé"
								sleep 3
							else 
								echo "dossier inexistant"
								sleep 3
							fi ";;
						9)  
							echo "Prise en main a distance" >> $des2
							echo "attention cette action lancera la prise en main a distance et fermera le script"
							ssh $1@$debut$2
							exit;;
						10) 
						 	while true
							do
							clear 
							Menu9
							read reponsebis
							
							case $reponsebis in
								1)
									echo "état Firewall" >> $des2
									ssh $1@$debut$2 ufw status 
									sleep 3;;
								2)
									echo "activation firewall" >> $des2
									ssh $1@$debut$2 ufw enable && echo "firewall activé"
									sleep 3;;
								3)
									echo "désactivation firewall" >> $des2
									ssh $1@$debut$2 ufw disable && echo "firewall désactivé"
									sleep 3;;
								4)
									echo "retour Menu Précédent"
									break;;
								*)
									echo "Choix Invalide";;  
							esac
							done;;
						11)
							echo "retour Menu Precedant"
							break;; 
						*)
							echo "Choix Invalide";;						
					esac
					done;;
				3)
					echo "Retour Menu precedant"
					break;;
				*)	
					echo "Choix Invalide";;
				esac
				done;;
		2)
			while true 
			do 
			clear
			Menu5
			read reponse13
			
			case $reponse13 in
				1)			
					while true 
					do
					clear
					Menu6
					read reponse14 	
					
					case $reponse14 in
						1)
							echo "derniere connection utilisateur" >> $des2
							read -p "nom utilisateur concerné : " util22
							ssh $1@$debut$2 "
							if cat /etc/passwd | grep "$util22" > /dev/null
							then 
								last $util22 | head -n1 
							else
								echo "utilisateur $util22 inexistant"
								sleep 3
							fi " > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						2)	
							echo "dernier changement de mot de passe utilisateur" >> $des2
							read -p "nom utilisateur concerné : " util21
							ssh $1@$debut$2 "
							if cat /etc/passwd | grep "$util21" > /dev/null
							then 
								passwd -S $util21 
							else
								echo "utilisateur $util21 inexistant"
								sleep 3
							fi " > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						3)	 
							echo "group d'appartenance utilisateur" >> $des2
							read -p "nom utilisateur concerné : " util20
							ssh $1@$debut$2 "
							if cat /etc/passwd | grep "$util20" > /dev/null
							then 
								cat /etc/group | grep "$util20" 
							else
								echo "utilisateur $util20 inexistant"
								sleep 3
							fi " > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						4)
							echo "Permission/droit utilisateur" >> $des2
							read -p "nom du repertoire : " rep10
							read -p "chemin du repertoire : " chemin10
							ssh $1@$debut$2 "
							if [ -d "$chemin10/$rep10" ]
							then
								ls -lh $chemin10/$rep10
							else
								echo "dossier introuvable"
       							sleep 3;;
							fi" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						5)
							echo "retour Menu Precedant"
							break;; 
						*)
							echo "Choix Invalide";;
					esac
					done;;
				2)
					while true 
					do
					clear
					Menu7
					read reponse15 	
	
					case $reponse15 in
						1)
							echo "Version OS" >> $des2
							ssh $1@$debut$2 lsb_release -d > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						2)
							echo "Espace disque restant" >> $des2
							ssh $1@$debut$2 df -h | awk '{print $1, $4}' > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						3)	
							echo "Taille repertoire" >> $des2
							read -p "Nom de dossier : " dossier4 
							read -p "nom du chemin : " chemin4
							ssh $1@$debut$2 " 
							if [ -d "$chemin4/$dossier4" ]
							then
								ls -lh $chemin4/$dossier4 | grep "total" 
							else 
								echo "Dossier inexistant" 
							fi" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						4)	
							echo "Liste des lecteurs" >> $des2
							ssh $1@$debut$2 lshw -C disk > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						5)
							echo "Adresse IP" >> $des2
							ssh $1@$debut$2 ip a | grep "inet" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						6)
							echo "Adresse MAC" >> $des2
							ssh $1@$debut$2 ip a | grep "link/ether" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						7)
							echo "Type de CPU, nombre de coeurs, etc." >> $des2
							ssh $1@$debut$2 grep "install" /var/log/apt/history.log > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							ssh $1@$debut$2 grep "install" /var/log/dpkg.log > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;		
						8) 
							echo "Liste des applications/paquets installées" >> $des2
							ssh $1@$debut$2 lshw -short | grep -E "system|processor" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						9)
							echo "Memoire RAM totale" >> $des2
							ssh $1@$debut$2 lshw -short | grep -E "memory" > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						10) 
							echo "Liste des ports ouverts" >> $des2
							ssh $1@$debut$2 netstat -l > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;							
						11)
							echo "Status Firewall" >> $des2
							ssh $1@$debut$2 ufw status > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						12)
							echo "Liste des utilisateur locaux" >> $des2
							ssh $1@$debut$2 getent passwd {1000..5000} > /home/$admin/info_$1_$(date "+%F")_$(date "+%H:%M:%S").txt
							echo "Fichier crée dans le /home"
							sleep 3 ;;
						13)
							echo "retour Menu Precedant"
							break;; 
						*)
							echo "Choix Invalide";;			
					esac
					done;;
				3)
					echo "Retour Menu precedant"
					break;;
				*)	
					echo "Choix Invalide";;
			esac
			done;;	
		3)
			journalfin
			exit 0;;
		*)	
			echo "Choix Invalide";;
		esac
		done
	fi
fi
exit

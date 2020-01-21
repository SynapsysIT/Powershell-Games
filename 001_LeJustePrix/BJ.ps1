#****************************************************************************
#Name					: SYNAPSYS_LeJustePrix
#Description			: Jeu du juste prix
#Last modification		: 31/05/2019
# Version				: 1905
#****************************************************************************
# Auto-ByPass
Try {
	Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop'
}
Catch {
}
#
set-psdebug -strict		
#
#Variable initialization
[Int]$iMinNumber = 0
[Int]$iMaxNumber = 1000
[Int]$iTryNumber = 500
[String]$sTitle = "Synapsys-IT - Le Juste Prix"
#
#Primary Functions and Sub-procedures****************************************
#
#Select Game type and get number to find
Function Get-PlayerSecretNumber{
#	[Int32]$iPlayerNumber = read-Host "Combien de joueurs (1 ou 2) ?"
	[Int32]$iPlayerNumber = Input-MessageBox -Message "Combien de joueurs (1 ou 2) ?" -Title $sTitle -Default "1"
	Switch ($iPlayerNumber){
		1{
			Show-MessageBox -Message "Jeu contre l'ordinateur." -Title $sTitle -Type "Information"
			[Int]$iComputer_GoodNumber = Get-Random -Maximum ($iMaxNumber + 1)
			Test-Number -iGoodNumber $iComputer_GoodNumber
		}
		2{
			Show-MessageBox -Message "Jeu contre un autre joueur." -Title $sTitle -Type "Information"
			Do{
				[Int32]$iPlayer1_GoodNumber  = Input-MessageBox -Message "Joueur 1 : Choisissez le prix a trouver entre 0 et 1000" -Title $sTitle -Default (Get-Random -Maximum ($iMaxNumber + 1))
			}
			Until (Test-Limit -iNumber $iPlayer1_GoodNumber -iMin $iMinNumber -iMax $iMaxNumber)
			Do{
				[Int32]$iPlayer2_GoodNumber  = Input-MessageBox -Message "Joueur 2 : Choisissez le prix a trouver entre 0 et 1000" -Title $sTitle -Default (Get-Random -Maximum ($iMaxNumber + 1))		
			}
			Until (Test-Limit -iNumber $iPlayer2_GoodNumber -iMin $iMinNumber -iMax $iMaxNumber)
			Show-MessageBox -Message "Au joueur 1 de deviner !" -Title $sTitle -Type "Avertissement"
			Test-Number -iGoodNumber $iPlayer2_GoodNumber
			Show-MessageBox -Message "Au joueur 2 de deviner !" -Title $sTitle -Type "Avertissement"
			Test-Number -iGoodNumber $iPlayer1_GoodNumber
		}
		default{
			Show-MessageBox -Message "Merci de choisir uniquement entre 1 ou 2." -Title $sTitle -Type "Erreur"
			Exit
		}
	}
}
#
#Secondary Functions and Sub-procedures**************************************
#
#Get value and Test this value against true price
Function Test-Number{
	param(
		[Parameter(Mandatory=$True)]
		[int]$iGoodNumber
	)
	For($i=1; $i -le 10; $i++){
		Try{
#			[Int]$iTryNumber = read-Host "Quelle est le juste prix ? (entre $iMinNumber ou $iMaxNumber) ?" -EA SilentlyContinue
			[Int]$iTryNumber = Input-MessageBox -Message "Quelle est le juste prix ? (entre $iMinNumber ou $iMaxNumber)" -Title $sTitle -Default $iTryNumber

			If ($iTryNumber -lt $iGoodNumber){
				Show-MessageBox -Message "C'est plus" -Title $sTitle -Type "Avertissement"
				If ($iTryNumber -ge $iMinNumber){
					$iMinNumber = $iTryNumber
				}
			}
			If ($iTryNumber -gt $iGoodNumber){
				Show-MessageBox -Message "C'est moins" -Title $sTitle -Type "Avertissement"
				If ($iTryNumber -le $iMaxNumber){
					$iMaxNumber = $iTryNumber
				}
			}
			If ($iTryNumber -eq $iGoodNumber){
				Show-MessageBox -Message "Bien joue ! Vous avez gagne en $i essais !" -Title $sTitle -Type "Information"
				return $i
			}
		}
		Catch {
			Show-MessageBox -Message "Merci d'entrer uniquement un nombre entier !" -Title $sTitle -Type "Erreur"
			$i--
		}
		$Error.Clear()
	}
	Show-MessageBox -Message "Perdu ! Le Juste Prix etait de $iGoodNumber euros" -Title $sTitle -Type "Information"
	return 11
}
#
#Test if 
Function Test-Limit{
	param(
		[Parameter(Mandatory=$True)]
		[int]$iNumber,
		[Parameter(Mandatory=$True)]
		[int]$iMin,
		[Parameter(Mandatory=$True)]
		[int]$iMax
	)
	Try {
		If(($iNumber -ge $iMin) -and ($iNumber -le $iMax)){
			Return $TRUE
		}
		Else{
			Return $FALSE
		}
		}
	Catch {
		Show-MessageBox -Message "Merci d'entrer uniquement un nombre entre 0 et 1000!" -Title $sTitle -Type "Erreur"
	}
	$Error.Clear()
}
#
#Display Windows Message
function Show-MessageBox{
	param(
		[Parameter(Mandatory=$True)]
		[string]$Message,
		[Parameter(Mandatory=$True)]
		[string]$Title,
		[Parameter(Mandatory=$True)]
		[String]$Type
	)
	Switch ($Type){
		"Erreur" {$Icon = 16}
		"Question" {$Icon = 32}
		"Avertissement" {$Icon = 48}
		"Information" {$Icon = 64}
		default{$Icon = 0}
	}
	[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")|Out-Null
	[System.Windows.Forms.MessageBox]::Show($Message, $Title , 0, $Icon)
}
#
#Display Input Windows Message
function Input-MessageBox{
	param(
		[Parameter(Mandatory=$True)]
		[string]$Message,
		[Parameter(Mandatory=$True)]
		[string]$Title,
		[Parameter(Mandatory=$True)]
		[string]$Default
	)
	[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
	[String]$sResponse = [Microsoft.VisualBasic.Interaction]::InputBox($Message, $Title, $Default)
	Return $sResponse 
}
#
#Main Procedure**************************************************************
#
Function Main(){
	Get-PlayerSecretNumber
}
#
#Call of the Main Procedure**************************************************
#
Main
#
#EOF*************************************************************************

<#
Mathieu
- Efficacit� du code (Action inutile ? Redondante ?)
    2 /2 - Script r�pondant parfaitement a la demande et m�me plus ! 
- Propret� du code (Respect des normes / Syntaxe PowerShell)
    1.5 / 2 - Bonne indentation, nom de variaibles parlantes, dommage, utilisation d'un verb non officiel ;)
- Utilisation simple ou avanc�e de PowerShell (Test ? Boucle ? Param�tre ? Fonction ?)
    2 / 2 - Fonctions interm�diaires tr�s bien utilis�es, les tests et les boucles sont fonctionnels ainsi que le check de l'environnement
- Propret� de l'interface lors de l'utilisation
    2 / 2 - Affichage �cran clair avec mise en forme et utilisation de couleur pour remonter l'infos ! Nice 
- Contr�le d'erreurs et de saisies
    1.5 / 2 - erreur lors du contr�le de saisie pour jouer a 1 ou 2, dommage

    9 / 10
#>


<# 
Julien
- Efficacit� du code (Action inutile ? Redondante ?)
    1/2 - Interface graphique mal exploit�e, validation suppl�mentaire sur chaque proposition.
- Propret� du code (Respect des normes / Syntaxe PowerShell)
    1.0 / 2 - Bonne indentation, nom de variaibles parlantes, dommage, utilisation d'un verb non officiel ;) Attention, peut �tre un peu beaucoup de code "tout fait" ;)
- Utilisation simple ou avanc�e de PowerShell (Test ? Boucle ? Param�tre ? Fonction ?)
    2 / 2 - Fonctions interm�diaires tr�s bien utilis�es, les tests et les boucles sont fonctionnels ainsi que le check de l'environnement
- Propret� de l'interface lors de l'utilisation
    2 / 2 - Affichage �cran clair avec mise en forme et utilisation de couleur pour remonter l'infos ! Nice 
- Contr�le d'erreurs et de saisies
    0.5 / 2 - Bouton Annuler et Croix non g�r�e, impossible de quitter le jeu avant d'avoir perdu.

    6.5/ 10
#>

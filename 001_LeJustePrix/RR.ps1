Function Plus-Moins
{
    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$True)] [int]$NumMystere

    )

    for ($i=0; $i -lt 10; $i++) #Boucle pour 10 Tentatives
        {
            Write-Host " "
            Write-Host "Il vous reste $(10-$i) Essais!" #tentatives restantes
            do
                {
                    $test= Read-Host "Entrez votre proposition"
                    $valid=(($test -notmatch "^\d{1,3}$") -and ($test -ne "1000")) #verification que la valeur n'est pas un nombre entre 0 et 1000
                        if ($valid) 
                        {
                            Write-Host "Vous devez entrer un nombre entre " -NoNewline
                            write-host "0" -ForegroundColor Red -NoNewline
                            write-host " et " -NoNewline
                            write-host "1000"  -ForegroundColor Red
                        }
                }
            while ($valid) #on boucle tant que la valeur n'est pas un nombre entre 0 et 1000

            if ([int]$test -eq $NumMystere) #Test si la proposition est Juste
                {
                    Write-host "GAGNE!" -ForegroundColor Green
                    break #sortie forcée de la boucle
                }

            if ([int]$test -lt $NumMystere) #test si la proposition est inférieure à la valeur à trouver
                {Write-host "C'est PLUS !" -ForegroundColor DarkYellow}

            else
                {Write-host "C'est MOINS !" -ForegroundColor DarkMagenta}



                
        }

    if ([int]$test -ne $NumMystere) {Write-host "PERDU !!!" -ForegroundColor Red} #verification à la sortie de la boucle si la derniere proposition est correcte ou non
}






CLS
$choix=""
while ($choix -ne "q") #Boucle sur le menu jusqu'à ce qu'on décide d'en sortir en tapant "Q"
{
Write-Host "  "
Write-Host "  "
Write-Host "***************************************************************"
Write-Host "*                     LE JUSTE PRIX                           *"
Write-Host "***************************************************************"
Write-Host "  "
Write-Host "  "
Write-Host "1: Jouer en Solo"
Write-Host "2: Jouer avec un ami"
Write-Host "  "
Write-Host "q: quiter"
Write-Host "  "

$choix = Read-Host -Prompt 'entrez votre choix'
Write-Host "  "
Write-Host "  "
   
    switch ($choix)
    {
        1 #Jouer Solo
            {
                $Num=get-random -Minimum 0 -Maximum 1000 
                cls
                write-host "Trouvez le Nombre Mystere entre 0 et 1000"
                Plus-Moins $Num
                Write-host " Le Nombre a trouver etait $num"
            }

    
        2 # Jouer avec un ami
            {
                do {

                        $Num=Read-Host -Prompt "entrez le numero mystere (entre 0 et 1000)"
                        if (($Num -match "^\d{1,3}$") -or ($Num -eq "1000")) #verification que la valeur est bien un nombre entre 0 et 1000
                        {cls}
                        else
                        {
                            Write-Host "Vous devez entrer un nombre entre " -NoNewline
                            write-host "0" -ForegroundColor Red -NoNewline
                            write-host " et " -NoNewline
                            write-host "1000"  -ForegroundColor Red
                        }
                    }
                while (($Num -notmatch "^\d{1,3}$") -and ($Num -ne "1000")) #on boucle tant que la valeur n'est pas un nombre entre 0 et 1000
                cls
                write-host "Trouvez le Nombre Mystere entre 0 et 1000"
                Plus-Moins $Num
                Write-host " Le Nombre a trouver etait $num"
                               
            }
        
        q # quitter le jeu
            {
                Write-host "Bye" -foreground Red             
            }

        default #entrée non conforme aux propositions
            {Write-Host "Entrez un choix du menu!" -foreground red }
    
    }
}

<# 
- Efficacité du code (Action inutile ? Redondante ?)
    2 /2 - Script répondant parfaitement a la demande 
- Propreté du code (Respect des normes / Syntaxe PowerShell)
    1.5 / 2 - Bonne indentation, nom de variaibles parlantes, dommage, utilisation de l'alias "cls" en lieu et place de la cmdlet Clear-Host et surtout utilisation d'un verb non officiel pour la fonction
- Utilisation simple ou avancée de PowerShell (Test ? Boucle ? Paramètre ? Fonction ?)
    2 / 2 - Fonction simple utilisé suffissante, les tests sont bons, les boucles et switch fonctionnels
- Propreté de l'interface lors de l'utilisation
    2 / 2 - Affichage écran clair avec mise en forme et utilisation de couleur pour remonter l'infos ! Nice 
- Contrôle d'erreurs et de saisies
    2 / 2 - Contrôle d'erreur parfaitement intégré, nickel !

    9.5 / 10
#>
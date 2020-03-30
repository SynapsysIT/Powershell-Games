# Pendu
# Auteur : Bassam SOUABNI
# Date: 17/02/2020


Function recupe () #recuppere un mot aleatoirment dans la liste
{
$URL = "https://raw.githubusercontent.com/SynapsysIT/Powershell-Games/master/002_LePendu/mots.txt"
Invoke-RestMethod -Uri $URL -OutFile "$env:userprofile\pendu.txt"   #telecharge les mots

$words = Get-Content "$env:userprofile\pendu.txt" -encoding utf8
$random=Get-Random -Minimum 0 -Maximum $words.Length
return $words[$random]
}

Function menu () #lance le menu
{

$choice = 0

Do{


$choice=Read-Host "***********************************
*   1. Rejouer                    *
*   2. Quitter                    *
* Choisir un chiffre entre 1 et 2 "

}Until($choice -eq 1 -or $choice -eq 2)

return $choice

}

Function jeu () #lance le pendu
{
    $word= recupe
    $nbletter = $word.Length
    $lifes=8
    $view1 = "-----------"
    
    clear
    Write-Host "*************       Bienvenue au jeu du pendu       *************"
    Write-Host "Le mot à trouver contient $nbletter lettres, vous avez le droit à $lifes erreurs"
    
    do{

        do{
            $userletter=Read-Host "veuillez entrer une lettre"
            if ($userletter.Length -ne 1){Write-Host "Une seul lettre à la foi" }
        } until ($userletter.Length -eq 1) #on verifie que l'utilisateur ne rentre qu'une lettre


        if ($word -match $userletter) { 
            $i=0
            $userview = ""
            
            do{
                if ($word[$i] -like $userletter) { $userview = $userview + $userletter } else { $userview = $userview + $view1[$i] }
                $i++
            } until ( $i -eq $nbletter )
            
            $view1 = $userview
            clear
            if ($word -like $userview) { $win = 1 
            } else {
                Write-Host "Bien joué! Il vous reste encore $lifes tentative"
                Write-Host "$userview"
            }
        

        } else {
            $lifes--
            clear
            Write-Host "Dommage, il ne vous reste plus que $lifes tentative(s) "
            Write-Host "$userview"
        }

    } until ($lifes -eq 0 -or $win -eq 1)

    if ($win -eq 1) {
        Write-Host "Bravo! Vous avez trouvé le mot $word"
        Start-Sleep -Seconds 3
    } else {
        Write-Host "Vous avez perdu! Le mot à trouver etait $word"
        Start-Sleep -Seconds 3
    }
    
}


#main

jeu
While($true) #le jeu se relance jusqu'à que l'utilisateur decide de quiter
{ 
    $choice=menu
    if($choice -eq 1){
       jeu
    } else {
       write-host("A bientot!")
       exit
    }
}
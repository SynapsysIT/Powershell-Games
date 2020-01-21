Param
(
     [string]$ChoixOrigine,
     [int]$Number,
     [int]$NumberMin,
     [int]$NumberMax,
     [int]$Chance,
     $NumberCompared
)



"######################################################################################################"
"                                  BIENVENUE AU JUSTE PRIX                                             "
"######################################################################################################"

"Afin de jouer , Merci de m'indiquer le nombre de joueur : "



do{


$ChoixOrigine = Read-Host " 1 - Joueur , 2 - Joueurs "

 switch($ChoixOrigine)
 {
   1 {[int]$Number = Get-Random -Minimum 0 -Maximum 1000;break}
   2 {         #le Joueur 1 doit bien choisir un nombre entier 
     try {   
       
      [int]$Number = Read-Host  " Joueur 1 - Merci de choisir un Prix entre 0 et 1000 " 
      Clear-Host
      " Le Joueur 1 à choisi son Prix "

         }

     catch {" erreur sur le choix , recommence ";$ChoixOrigine = "0"}   #On Recommence le choix n'est pas validé
    
     }  
   Default {"Attention j'ai besoin de savoir : 1 - Joueur , 2 - Joueurs ";break}
}


}while(($ChoixOrigine -ne 1) -and ($ChoixOrigine -ne 2))




" Merci pour ce choix place au jeu !!!"
  $NumberMin = 0
  $NumberMax = 1000
  $Chance = 10
    

while(($Number -ne $NumberCompared) -and ($Chance -ne 0))
{

  try {                # String -> Int  avec gestion de l'information String -> Int 

    [int]$NumberCompared = Read-Host "Joueur : Merci de me donner un Prix entre" $NumberMin " et " $NumberMax 
    
     
    if(($NumberCompared -gt $NumberMax) -or ($NumberCompared -lt $NumberMin))  # Le choix doit rester dans l'intervalle de recherche !

     {  " Votre Juste Prix est entre " + $NumberMin + " et " + $NumberMax }
 
    else {
          
    $Chance--

  
    if($NumberCompared -gt $Number)
        {
    
          "Le Prix est plus bas"
          $NumberMax = $NumberCompared
          "Il vous reste " + $Chance + " Chances "
    
        }
    
     if($NumberCompared -lt $Number)
        {
    
          "Le Prix est plus haut"
          $NumberMin = $NumberCompared
          "Il vous reste " + $Chance + " Chances "
    
        } 
      
      }

    }
      
  catch {"erreur de saisie , Attention Je souhaite un nombre Entier "}
       


    }

 if($Number -ne $NumberCompared)
    {

       "Vous avez perdu à cette partie !!!!! , Le juste prix était de " + $Number 
    }
   else 
     {

       "Bravo vous être le gagnant du juste Prix !!!!"

     }

<# 
- Efficacité du code (Action inutile ? Redondante ?)
    2 /2 - Script répondant parfaitement a la demande 
- Propreté du code (Respect des normes / Syntaxe PowerShell)
    2 / 2 - Bonne indentation, nom de variaibles parlantes 
- Utilisation simple ou avancée de PowerShell (Test ? Boucle ? Paramètre ? Fonction ?)
    1.5 / 2 - Pas de fonction, mais en l'état pas indispensable, les tests sont bons, les boucles et switch fonctionnels, le bloc paramètres est mal utilisé
- Propreté de l'interface lors de l'utilisation
    1 / 2 - Affichage écran simple, pas de clean de l'interface ou de saut de ligne ou encore de couleur, dommage
- Contrôle d'erreurs et de saisies
    2 / 2 - Contrôle d'erreur parfaitement intégré, nickel !

    8.5 / 10
#>

<# 
- Efficacité du code (Action inutile ? Redondante ?)
    2 /2 - Script répondant parfaitement a la demande 
- Propreté du code (Respect des normes / Syntaxe PowerShell)
    2 / 2 - Bonne indentation, nom de variables parlantes 
- Utilisation simple ou avancée de PowerShell (Test ? Boucle ? Paramètre ? Fonction ?)
    1.5 / 2 - Pas de fonction, mais en l'état pas indispensable, les tests sont bons, les boucles et switch fonctionnels, le bloc paramètres est mal utilisé
- Propreté de l'interface lors de l'utilisation
    1 / 2 - Affichage écran simple, pas de clean de l'interface ou de saut de ligne ou encore de couleur, dommage
- Contrôle d'erreurs et de saisies
    2 / 2 - Utilisation du try catch ! Parfait.

    8.5 / 10
#>
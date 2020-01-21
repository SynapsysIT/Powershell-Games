# Le juste prix !

## Le but du jeu

Il faut découvrir un nombre inconnu avec pour seule indication, à chaque proposition, "C'est plus" ou "C'est moins" (Dans un scope raisonnable, disons entre 0 et 1000)

La demande initiale est donc celle-ci, créer un script vous permettant de jouer au Juste Prix (seul avec un nombre random ou à deux avec une saisie manuelle)

Demandes supplémentaires : Il faut que le nombre mystère soit découvert en 10 tentatives maximum.

## Les points d'attentes

- Efficacité du code (Action inutile ? Redondante ?)

- Propreté du code (Respect des normes / Syntaxe PowerShell)

- Utilisation simple ou avancée de PowerShell (Test ? Boucle ? Paramètre ? Fonction ?)

- Propreté de l'interface lors de l'utilisation

- Contrôle d'erreurs et de saisies

## Participants

### [Bertrand](/001_LeJustePrix/BJ.ps1)

#### - Contrôle d'erreurs et de saisies
    1.5 / 2 - erreur lors du contrôle de saisie pour jouer a 1 ou 2, dommage
    9 / 10
#>


<# 
Julien
- Efficacité du code (Action inutile ? Redondante ?)
    1/2 - Interface graphique mal exploitée, validation supplémentaire sur chaque proposition.
- Propreté du code (Respect des normes / Syntaxe PowerShell)
    1.0 / 2 - Bonne indentation, nom de variaibles parlantes, dommage, utilisation d'un verb non officiel ;) Attention, peut être un peu beaucoup de code "tout fait" ;)
- Utilisation simple ou avancée de PowerShell (Test ? Boucle ? Paramètre ? Fonction ?)
    2 / 2 - Fonctions intermédiaires très bien utilisées, les tests et les boucles sont fonctionnels ainsi que le check de l'environnement
- Propreté de l'interface lors de l'utilisation
    2 / 2 - Affichage écran clair avec mise en forme et utilisation de couleur pour remonter l'infos ! Nice 
- Contrôle d'erreurs et de saisies
    0.5 / 2 - Bouton Annuler et Croix non gérée, impossible de quitter le jeu avant d'avoir perdu.
    6.5/ 10
#>

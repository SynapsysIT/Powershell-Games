[int]$justeprix = Get-Random -minimum 1 -maximum 50
[int]$essaismax = 9
[int]$proposition=Read-Host "Devinez le juste prix entre 0 et 50 "
# Tant que la valeur saisie ne correspond pas au juste prix on affiche une phrase
While ($proposition -ne $justeprix) {
if ($proposition -lt $justeprix) {Write-Output "C'est plus! Il vous reste $essaismax essais.
"} $essaismax--
if ($proposition -gt $justeprix) {Write-Output "C'est moins! Il vous reste $essaismax essais.
"}
if ($essaismax -le -1) {Write-Output "*** GAME OVER ***
"
exit}
# On enregistre la valeur saisie par l'utilisateur dans une variable
$proposition=Read-Host
}
Write-Output "C'est gagne! Le juste prix est bien $justeprix !
"

<# 
Mathieu
- Efficacité du code (Action inutile ? Redondante ?)
    1 /2 - Ne répond pas complétement a la demande mais "fonctionnel"
- Propreté du code (Respect des normes / Syntaxe PowerShell)
    1 / 2 - Pas d'indentation mais noms de variables parlantes
- Utilisation simple ou avancée de PowerShell (Test ? Boucle ? Paramétre ? Fonction ?)
    0.5 / 2 - Trop basique
- Propreté de l'interface lors de l'utilisation
    0 / 2 - Affichage écran basique
- Contréle d'erreurs et de saisies
    0.5 / 2 - Définition des variables mais ce n'est pas suffisant

    ==> 3 / 10
#>

<#
Julien
- Efficacité du code (Action inutile ? Redondante ?)
    1 /2 - Ne répond pas complétement a la demande mais "fonctionnel"
- Propreté du code (Respect des normes / Syntaxe PowerShell)
    1 / 2 - Pas d'indentation mais noms de variables parlantes
- Utilisation simple ou avancée de PowerShell (Test ? Boucle ? Paramétre ? Fonction ?)
    0.5 / 2 - Trop basique
- Propreté de l'interface lors de l'utilisation
    0 / 2 - Affichage écran basique
- Contréle d'erreurs et de saisies
    0.5 / 2 - Définition des variables mais ce n'est pas suffisant

    ==> 3 / 10
#>
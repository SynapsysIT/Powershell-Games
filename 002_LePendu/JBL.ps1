############################################################################
#                              Shell Games- 2                              #
#                               Jeu du Pendu                               #
#  Version 1.0 (ou "Pourquoi faire simple quand on peut faire complique")  #
#                    Auteur : Jean-Baptiste LETONNELIER                    #
# ASCII-art: http://laurent.le-brun.eu/ascii/index.php/2007/10/10/16-pendu #
############################################################################



# Parce-que vous non-plus, vous ne faites pas confiance à l'utilisateur ?
# Get-CleanString est fait pour vous !
# Accepte une chaine de caracteres en entree, et la retourne "nettoyee" en sortie
function Get-CleanString{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)] [string]$textInput
    )

    # Enleve les accents, universalise la separation entre characteres par des espaces
    $textInput = $textInput -replace "à|@|ã", "a"
    $textInput = $textInput -replace "ç", "c"
    $textInput = $textInput -replace "é|è|ê|€|ë", "e"
    $textInput = $textInput -replace "ì|î|ï", "i"
    $textInput = $textInput -replace "ñ", "n"
    $textInput = $textInput -replace "ô|ö|õ|ò", "o"
    $textInput = $textInput -replace "ù|û|ü", "u"
    $textInput = $textInput -replace "_|-|`t|`n|`r", " "
    
    # Enleve tout ce qui n'est pas dans l'alphabet latin, un chiffre, ou un espace
    $textInput = $textInput -replace "[^a-zA-Z0-9 ]", ""
    
    # Nettoye les espaces multiples, et ceux en debut et fin de chaine
    $textInput = $textInput -replace "\s+", " "
    $textInput = $textInput.Trim()
    
    return $textInput
}

# Recupere le dictionnaire en ligne, tout en gérant l'éventualité que l'on n'y arrive pas, et selectionne un mot au hasard
function Get-MysteryWord{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)] [string]$onlineDictionary
    )

    try
    {
        $webResponse = Invoke-WebRequest -Uri $onlineDictionary -ErrorAction Stop
        # Ne s'execute que si Invoke-WebRequest ne retourne pas d'erreur
        $webResponseStatusCode = $webResponse.StatusCode

        # $webResponse.content nous retourne une chaine de caracteres, au chaque mot est separe par un charactere de saut de ligne
        # Decoupe la chaine en 'substrings', une par ligne (et donc une par entree du dictionnaire)
        $dictionnaire = ($webResponse.content -split '\r?\n')

        $mysteryWord = ($dictionnaire | Get-Random)
    }
    catch
    {
        Write-Error -Message "Impossible de recuperer le dictionnaire. Lancement de la solution de repli !" -Category ConnectionError

        # Pas de dictionnaire ? Pas de probleme !
        $mysteryWord = (("déconnexion", "malheureux", "injouable", "dictionnaire") | Get-Random)
    }

    return $mysteryWord
}

# Gere l'affichage du pendu en fonction des essais errones du joueur
function Show-HangMan{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)] [int]$failedAttempts
    )

    Clear-Host
    Write-Host "`n=================================================="
    Write-Host "|                    LE PENDU                    |"
    Write-Host "==================================================`n"
    Write-Host "       ,==========Y===`n       ||  /      |`n       || /       |"

    switch($failedAttempts) {
        0 {
            Write-Host "       ||/`n       ||`n       ||`n       ||`n      /||`n     //||`n    ==================`n`n`n"
        }

        1 {
            Write-Host "       ||/        o`n       ||`n       ||`n       ||`n      /||`n     //||`n    ==================`n`n`n"
        }

        2 {
            Write-Host "       ||/        o`n       ||         T`n       ||         |`n       ||`n      /||`n     //||`n    ==================`n`n`n"
        }

        3 {
            Write-Host "       ||/        o`n       ||        /T`n       ||         |`n       ||`n      /||`n     //||`n    ==================`n`n`n"
        }

        4 {
            Write-Host "       ||/        o`n       ||        /T\`n       ||         |`n       ||`n      /||`n     //||`n    ==================`n`n`n"
        }

        5 {
            Write-Host "       ||/        o`n       ||        /T\`n       ||         |`n       ||        /`n      /||`n     //||`n    ==================`n`n`n"
        }

        6 {
            Write-Host "       ||/        o`n       ||        /T\`n       ||         |`n       ||        / \`n      /||`n     //||`n    ==================`n`n`n"
            return $false
        }
    }
    
    return $True
}


function Update-GameState{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)] [string]$mysteryWord,
        [Parameter(Mandatory = $True)] [string]$cleanedMysteryWord,
        [Parameter(Mandatory = $True)] [char[]]$mysteryWordArray,
        [Parameter(Mandatory = $True)] [char[]]$triedChars,
        [Parameter(Mandatory = $True)] [char[]]$hiddenWordArray,
        [Parameter(Mandatory = $True)] [int]$failedAttempts
    )
    $textInput = " "
    $cleanedTextInput = ""
    $isAlive = $True
    $guessWordReturn = @()
    $cleanedMysteryWordArray = $cleanedMysteryWord.ToCharArray()
    
    
    $isAlive = Show-HangMan $failedAttempts
    Write-Host "Mot mystere : $hiddenWordArray`n`n"

    while ($isAlive) {
        $triesLeft = 5 - $failedAttempts
        $textInput = Read-Host "Vous avez le droit a $triesLeft erreur(s)`n"

        if ($textInput -ne ""){
            $cleanedTextInput = Get-CleanString $textInput

            # Logique si l'utilisateur renseigne un seul caractere alphanumerique
            if ($cleanedTextInput.Length -eq 1) {
                
                
                Write-Host $cleanedTextInput
                Write-Host "Essais : $triedChars`n`n" -ForegroundColor Blue

                if (-not ($triedChars -contains [char]$cleanedTextInput)) {
                    $triedChars += [char]$cleanedTextInput
                    $newFail = $True

                    $i = 0
                    $cleanedMysteryWordArray | foreach{
                        if ([char]$cleanedTextInput -eq $_) {
                            $hiddenWordArray[$i] = $mysteryWordArray[$i]
                            $newFail = $false
                        }
                        $i++
                    }
                    if ($newFail) {
                        $failedAttempts++
                    }
                    $isAlive = Show-HangMan $failedAttempts
                    Write-Host "Mot mystere : $hiddenWordArray`n`n"
                    Write-Host "Essais : $triedChars`n`n" -ForegroundColor Blue

                    # Si les deux tableaux sont identiques, le tableau cree par Compare-Object est vide
                    if (@(Compare-Object $hiddenWordArray $mysteryWordArray).Length -eq 0){
                        Write-Host "Felicitations ! Le mot a deviner etait bien $mysteryWord`n" -ForegroundColor Green
                        Read-Host "Appuyez sur Entree"
                        Clear-Host
                        return
                    }
                }
                else {
                    $isAlive = Show-HangMan $failedAttempts
                    Write-Host "Mot mystere : $hiddenWordArray`n`n"
                    Write-Host "Essais : $triedChars`n`n" -ForegroundColor Blue
                    Write-Host "Vous avez deja essaye ce caractere`n" -ForegroundColor Red
                }
            }
            elseif ($cleanedTextInput.Length -eq 0){
                $isAlive = Show-HangMan $failedAttempts
                Write-Host "Mot mystere : $hiddenWordArray`n`n"
                Write-Host "Essais : $triedChars`n`n" -ForegroundColor Blue
                Write-Host "Merci de renseigner au moins un caractere alphanumerique`n" -ForegroundColor Red
            }
            # Offre la possibilite a l'utilisateur de tapper le mot entier
            elseif ($cleanedTextInput.Length -eq $cleanedMysteryWord.Length){
                if ($cleanedTextInput -eq $cleanedMysteryWord){
                    Write-Host "Felicitations ! Le mot a deviner etait bien $mysteryWord`n" -ForegroundColor Green
                    Read-Host "Appuyez sur Entree"
                    Clear-Host
                    return
                }
                else
                {
                    Write-Host "Game Over ! Le mot a deviner etait $mysteryWord`n" -ForegroundColor Magenta
                    Read-Host "Appuyez sur Entree"
                    Clear-Host
                    return
                }
            }
            else {
                Write-Host "Mot mystere : $hiddenWordArray`n`n"
                Write-Host "Essais : $triedChars`n`n" -ForegroundColor Blue
                Write-Host "Essayez un seul charactere a la fois, ou bien le mot entier`n" -ForegroundColor Red
            }
        }
        else {
            $isAlive = Show-HangMan $failedAttempts
            Write-Host "Mot mystere : $hiddenWordArray`n`n"
            Write-Host "Essais : $triedChars`n`n" -ForegroundColor Blue
            Write-Host "Merci de renseigner au moins un caractere`n" -ForegroundColor Red
        }
    }
    
    Write-Host "Game Over ! Le mot a deviner etait $mysteryWord`n" -ForegroundColor Magenta
    Read-Host "Appuyez sur Entree"
    Clear-Host
    return
    }

# Initialisation d'une nouvelle session de jeu
function Start-NewGame{
    [CmdletBinding()]
    param ()

    # Initialisation des variables
    $mysteryWord = " "
    $cleanedMysteryWord = ""
    $mysteryWordArray = @(' ')
    $triedChars = @(' ')
    $hiddenWordArray = @(' ')
    $failedAttempts = 0

    # Selection d'un mot mystere aleatoire
    $mysteryWord = Get-MysteryWord "https://raw.githubusercontent.com/SynapsysIT/Powershell-Games/master/002_LePendu/mots.txt"

    # Permet de donner la liberte au joueur de ne pas s'inquieter des accents (entre autres)
    $cleanedMysteryWord = Get-CleanString $mysteryWord

    # Je prefere travailler avec des tableaux de characteres qu'avec des chaines
    $mysteryWordArray = $mysteryWord.ToCharArray()
    $hiddenWordArray = @('_') * $mysteryWord.Length

    # Renseigne les traits d'union ou espaces dans l'affichage du mot mystere
    $i = 0
    $mysteryWordArray | foreach {
        if ($_ -eq ' ' -or $_ -eq '-'){
            $hiddenWordArray[$i] = $_
        }
        $i++
    }

    Update-GameState $mysteryWord $cleanedMysteryWord $mysteryWordArray $triedChars $hiddenWordArray $failedAttempts
}





# Menu principal / d'accueil
$menuPick = ""
Clear-Host
while($menuPick -ne "x"){
    Write-Host "`n=================================================="
    Write-Host "|                    LE PENDU                    |"
    Write-Host "==================================================`n"
    Write-Host "       ,==========Y===
       ||  /      |
       || /       |
       ||/
       ||
       ||
       ||
      /||
     //||
    ==================`n`n`n"
    Write-Host "[o] Jouer`n[x] Quitter`n"

    $menuPick = Read-Host "Desirez-vous"

    switch -Regex ($menuPick) {
        '^[o0]{1}$' {
            Clear-Host
            Start-NewGame
        }

        '^x{1}$' {
            Clear-Host
        }

        default {
            Clear-Host
            Write-Host ""
            Write-Warning "Veuillez selectionner un choix valide ( o / x )`n"
        }
    }
}


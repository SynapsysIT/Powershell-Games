#****************************************************************************
#Name					: SYNAPSYS_BJO_LePendu
#Description			: Jeu du Pendu
#Last modification		: 12/02/2020
# Version				: 2002
#****************************************************************************
# Auto-ByPass
Try {
	Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop'
}
Catch {
}
#
	#set-psdebug -strict		
#
#Variable initialization
[INT]$iFoundLetter = 0
[String]$sOldLetter = " "
[String]$sResultWord = ""
[INT]$iErrorTry = 7
#
#Main Procedure**************************************************************
Function Main(){
	[String]$sWord = Retrieve-Word
	[INT]$iWordLength = $sWord.length
	FOR($i=1; $i -le $iWordLength; $i++){
		$sResultWord = $sResultWord +"-"
	}
	Clear
	Write-Host "Jeu du Pendu."
	Write-Host "Le mot a trouver contient $iWordLength lettres : $sResultWord  `n"
	While ($iErrorTry -gt 0){
		Write-Host "Il vous reste $iErrorTry erreurs." `n
		If ($iFoundLetter -lt $iWordLength){
			$sTestedLetter = (Read-Letter $sOldLetter)
			$sOldLetter = $sOldLetter + $sTestedLetter
			$sOldResultWord = $sResultWord
			$sResultWord = (Test-Word $sWord $sTestedLetter $sOldResultWord)
			$iOldHyphenCount = ($sOldResultWord.ToCharArray() | Where-Object {$_ -eq '-'} | Measure-Object).Count
			$iNewHyphenCount = ($sResultWord.ToCharArray() | Where-Object {$_ -eq '-'} | Measure-Object).Count
			If ($iNewHyphenCount -eq $iOldHyphenCount){
				$iErrorTry = $iErrorTry -1
				Write-Hanged $iErrorTry
			}
			Write-Host $sResultWord  `n
			$iFoundLetter = $iWordLength - ($iWordLength - ($sResultWord.replace("-","")).length)
			If (($($iErrorTry - $i) -eq 0) -AND ($iFoundLetter -lt $iWordLength)){
				Write-Host "Perdu, le mot a trouver etait : $sWord."
				Exit
			}
		}
		Else{
			Write-Host "Bravo, vous avez trouve le mot !"
			Exit
		}
	}
	Write-Host "Perdu, le mot a trouver etait : $sWord."
}
#
#Primary Functions and Sub-procedures****************************************
#Retrieve random Word in Internet file
#	Return this word
Function Retrieve-Word{
	$oContent = Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/SynapsysIT/Powershell-Games/master/002_LePendu/mots.txt"
	$result = ($oContent.content -split "`r?`n")
	$sWord = Get-random -InputObject $result
	$sWord = Remove-StringLatinCharacters $sWord
#	write-host $sWord
	Return $sWord
}
#
#Retrieve Letter Input and Test if value is correct
#	Return this Letter
Function Read-Letter{
	Param(
		[Parameter(Mandatory=$True)]
		[string]$sOldLetter
	)
	[String]$sLetterValue = read-host "Choisissez une lettre"
	If($sLetterValue -MATCH '\d'){
		Write-host "ERREUR. Merci de choisir une lettre et non un chiffre."
		(Read-Letter $sOldLetter)
	}
	ElseIf ($sLetterValue -MATCH '\W'){
		Write-host "ERREUR. Merci de choisir une lettre et non un caractere special."
		(Read-Letter $sOldLetter)
	}
	ElseIf ($sLetterValue.length -GT 1){
		Write-host "ERREUR. Merci de choisir une seule lettre et non plusieurs."
		(Read-Letter $sOldLetter)
	}
	ElseIf ($sLetterValue -EQ ""){
		Write-host "ERREUR. Merci de choisir une lettre."
		(Read-Letter $sOldLetter)
	}
	ElseIf ($sOldLetter.contains($sLetterValue)){
		Write-host "ERREUR. Lettre deja choisis, Merci de choisir une autre lettre."
		(Read-Letter $sOldLetter)
	}
	Else{
		[String]$sLetterValue = $sLetterValue.ToLower()
		$sLetterValue = Remove-StringLatinCharacters $sLetterValue
		Clear
		Return $sLetterValue
	}
}
#
#Test if a letter is in a word
#	return result of a word with only found letter
Function Test-Word{
	Param(
		[Parameter(Mandatory=$True)]
		[string]$sString,
		[Parameter(Mandatory=$True)]
		[string]$sLetter,		
		[Parameter(Mandatory=$True)]
		[string]$sResultWord		
	)
	[INT]$iLength = $sString.length
	FOR($j=0; $j -lt $iLength; $j++){
		If($sResultWord.Substring($j,1) -NE "-"){
			$sTestedWord = $sTestedWord + $sResultWord.Substring($j,1)
		}
		ElseIf($sString.Substring($j,1) -EQ $sLetter){
			$sTestedWord = $sTestedWord + "$sLetter"
		}
		Else{
			$sTestedWord = $sTestedWord + "-"
		}
}
	Return $sTestedWord
}
#
#Secondary Functions and Sub-procedures**************************************
#Remove accent
#	Return normalized letter 
Function Remove-StringLatinCharacters{
	Param(
		[Parameter(Mandatory=$True)]
		[string]$StringValue
	)
	Try{
		[Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($StringValue))
	}
	Catch{
		$PSCmdlet.ThrowTerminatingError($_)
	}
}
#
Function Write-Hanged{
	Param(
		[Parameter(Mandatory=$True)]
		[INT]$iErrorTry
	)
	Clear
	switch ($iErrorTry){
		7{
			Write-Host "               "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "    
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "==============="
		}
		6{
			Write-Host "==============="
			Write-Host "   ||  /       "
			Write-Host "   || /        "
			Write-Host "   ||/         "    
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "==============="
		}
		5{
			Write-Host "===========Y==="
			Write-Host "   ||  /   |   "
			Write-Host "   || /    |   "
			Write-Host "   ||/         "    
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "==============="
		}
		4{
			Write-Host "===========Y==="
			Write-Host "   ||  /   |   "
			Write-Host "   || /    |   "
			Write-Host "   ||/    ( )  "    
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "==============="
		}
		3{
			Write-Host "===========Y==="
			Write-Host "   ||  /   |   "
			Write-Host "   || /    |   "
			Write-Host "   ||/    ( )  "    
			Write-Host "   ||      |   "
			Write-Host "   ||      |   "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "==============="
		}
		2{
			Write-Host "===========Y==="
			Write-Host "   ||  /   |   "
			Write-Host "   || /    |   "
			Write-Host "   ||/    ( )  "    
			Write-Host "   ||      |   "
			Write-Host "   ||      |   "
			Write-Host "   ||     / \  "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "==============="
		}
		1{
			Write-Host "===========Y==="
			Write-Host "   ||  /   |   "
			Write-Host "   || /    |   "
			Write-Host "   ||/    ( )  "    
			Write-Host "   ||     /|\  "
			Write-Host "   ||      |   "
			Write-Host "   ||     / \  "
			Write-Host "   ||          "
			Write-Host "   ||          "
			Write-Host "==============="
		}
	}
}
#
#Call of the Main Procedure**************************************************
Main
#
#EOF*************************************************************************
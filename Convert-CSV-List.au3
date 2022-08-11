#CS
	Authored by Juan Fox in 2020
	Script that converts a list (String) from NewLine-Separated to Comma-Sepparated or vice versa. It takes either a clipboard
	list or a File with a list within it.
	>Arguments:
		- [Optional] $1 or %1%: Path to a file that contains the list, and where the output will be written into (replace).
	>Outputs: Converted list (String).
	>Usage:
		script.au3
		or
		script.au3 myFileWithAList.txt
#CE

; #FUNCTION# ====================================================================================================================
; Name ..........: Launch
; Description ...: 	Validates arguments and launches one of two modes accordingly:
;					- No Arguments (MODE 1): Converts clipboard content and outputs back into clipboard (replace)
;					- Single Argument with File Path (MODE 2): Converts file content and outputs into the file (replace)
; Syntax ........: Launch()
; Parameters ....: None
; Return values .: None
; Author ........: Juan Fox
; ===============================================================================================================================
Func Launch()
	Local $bReturnValue=False ;;Default value

	;;Verifies if no arguments were used
	If $CMDLine[0]=0 Then ;;MODE 1: Clipboard content (no argument)

		;;Fetches clipboard content
		$sContent=ClipGet()
		;;Launches the main function and
		$aNewList=Main_Conversion($sContent)
		;;Verifies success
		If $aNewList Then
			;;Stores it's output in clipboard
			ClipPut($aNewList)
			$bReturnValue=True
		EndIf

	Else ;;MODE 2: File content (argument)

		;;Fetches file path from argument $1.
		$sFileName=$CMDLine[1]
		;;Reads the file content (opens and closes the file in read mode)
		$sContent=FileRead($sFileName)
		;;Opens the file and generates a handle (overwrite mode)
		$hFile_HWND=FileOpen($sFileName,2)
		;;Launches the main function and stores it's output in a variable
		$aNewList=Main_Conversion($sContent) ;;Launches the main function
		;;Verifies success
		If $aNewList Then
			;;Writes the new list into the file (replaces original content).
			FileWrite($hFile_HWND,$aNewList)
			;;Closes the file
			FileClose($hFile_HWND)
			$bReturnValue=True
		EndIf

	EndIf
Return $bReturnValue
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: Main_Conversion
; Description ...: Converts a list from NewLine-Separated to Comma-Sepparated or vice versa.
; Syntax ........: Main_Conversion($sList)
; Parameters ....: $sList                - A NewLine or Comma Separated list in String format.
; Return values .: $sNewList			- Converted list (String) or False
; Author ........: Juan Fox
; ===============================================================================================================================
Func Main_Conversion($sList)
	Local $vNewList=False ;;Default value
	;;Detects the format
	$sPreviousSeparator=DetectFormat($sList)
	If $sPreviousSeparator Then
		;;Depending on the format, it defines the new separator to use for the list
		$sNewSeparator=($sPreviousSeparator=@CRLF)?(","):(@CRLF)
		;;Converts the list
		$vNewList=CSVConvert($sList,$sPreviousSeparator,$sNewSeparator)
	EndIf
Return $vNewList
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: DetectFormat
; Description ...: Detects the format, meaning the separator for the received list.
; Syntax ........: DetectFormat($sList)
; Parameters ....: $sList                - A NewLine or Comma Separated list in String format.
; Return values .: $sSeparator			- Separator character (String) or False
; Author ........: Juan Fox
; ===============================================================================================================================
Func DetectFormat($sList)
	Local $vSeparator=False ;;Default value
	;;Generates an array by splitting the string by the new-line character.
	$aArray=StringSplit($sList,@CRLF,1)
	;;Verifies if it is a valid Array
	If IsArray($aArray) Then
		;;Verifies if the array is larger than 1 item
		If $aArray[0]>1 Then
			$vSeparator=@CRLF ;;Separator is new-line
		Else
			$vSeparator="," ;;Separator is comma
		EndIf
	EndIf
Return $vSeparator
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVConvert
; Description ...: Detects the format, meaning the separator for the received list.
; Syntax ........: CSVConvert($sList,$sPreviousSeparator,$sNewSeparator)
; Parameters ....: $sList                - A NewLine or Comma Separated list in String format.
;				   $sPreviousSeparator   - The current separator (String).
;                  $sNewSeparator        - The new separator (String).
; Return values .: $sNewList			- The list with the new separator (String) or False
; Author ........: Juan Fox
; ===============================================================================================================================
Func CSVConvert($sList,$sPreviousSeparator,$sNewSeparator)
	Local $vNewList="" ;;Default value
	;;Generates an array by splitting the string by the new-line character.
	$aArray=StringSplit($sList,$sPreviousSeparator,1)
	;;Verifies if it is a valid Array
	If IsArray($aArray) Then
		;;Goes through every item in the array
		For $i=1 To $aArray[0] Step 1
			;;Concatenates the item with the current list (String) using the new separator
			$vNewList=$vNewList & $sNewSeparator & $aArray[$i]
		Next
		;;Removes leading separator
		$vNewList=StringReplace($vNewList,$sNewSeparator,"",1)
	EndIf

Return ($vNewList == "")?(False):($vNewList)
EndFunc


;;Script init
$bSuccess=Launch() ;;Launches the script
$iRC=($bSuccess)?(0):(1) ;;Calculates binary return code based on success
Exit($iRC) ;;Exits with proper RC
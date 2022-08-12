; #UDF# =======================================================================================================================
; Name ..........: CodeLines_Counter
; Description ...: A program that counts the lines of code in a plain-text file, segregating:
;						- Actual code lines
;						- Commented lines (Requires a comment character like ";","//","#", etc)
;						- Empty lines
;						- Total characters
;						- Total functions (requires a function keyword, like in Bash, Powershell or AutoIt)
;
; Comments ......: This is a pretty old script from back when I started scripting/automating, so theres a lot of things that could be made better (modularization, DRYness, return values,
;					dynamic parameters, etc).
; Usage .........: Execute the program, select the file through the GUI and view the result.
; Dependancies...: As you can see, I rely on some native libraries:
;					- File.au3 -> Native
;					- MsgBoxConstants.au3 -> Native
;					Credits to the autors.
; Platforms .....: Windows 7, 8 and 10.
; Version .......: v1
; Autor ........: Juan Fox
; Year  ........: 2019
; ===============================================================================================================================


#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=CodeLine_Counter.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <MsgBoxConstants.au3>
#include <File.au3>

$APP = "CodeLine_Counter"

$ChosenFile = FileOpenDialog ($APP & " - Select file to analyze", @DesktopDir, "All (*.*)")
$Char = InputBox ($APP, "Enter comment character:", ";")

$RC = _FileCountLinesExt ($ChosenFile, $Char, 5)

$MSG = "Total lines: " & $RC [0] & @CRLF _
		& "Code lines: " & $RC [1] & @CRLF _
		& "Commented lines: " & $RC [2] & @CRLF _
		& "Empty lines: " & $RC [3] & @CRLF _
		& "Total characters: " & $RC [4] & @CRLF _
		& "Total functions: " & $RC [1]
MsgBox ($MB_OK, $APP, $MSG)

	;

; #FUNCTION# ====================================================================================================================
; Name ..........: _FileCountLinesExt
; Description ...:  Counts Total lines in a file and also provides useful information on Commented/Empty lines, total characters
;					and even amount of Functions defined in it.
; Syntax ........: _FileCountLinesExt ($FilePath, $CommentChar[, $Mode = 1])
; Parameters ....: $FilePath            - Text file full path.
;                  $CommentChar         - Character to determine when a line is commented.
;                  $Mode         		- 1 (default) will return Total lines and Code lines as @extended.
;										  2 will return Total lines and Commented lines as @extended.
;										  3 will return Total lines and Empty lines as @extended.
;										  4 will return Total lines and Total characters as @extended.
;										  5 will return an Array with all elements in the following order:
;										  (Total Lines/Code Lines/Commented Lines/Empty Lines/Total Characters/Total Functions)
; Return values .: Total lines and Commented/Empty lines as @extended value. In case of error, it will return 0.
; Author ........: Juan Fox
; Modified ......:
; Remarks .......: @error can be used to determine error code. -1 will be returned if File opening fails and 2 if count check fails.
; Related .......: _FileCountLines function (Native on AutoIt V3).
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _FileCountLinesExt ($FilePath, $CommentChar = ";", $Mode = 1, $FuncKeyWord = "Func")

	Local $CommentedLineCount = "0"
	Local $EmptyLineCount = "0"
	Local $CodeLineCount = "0"
	Local $FuncCount = "0"
	Local $KeyWordLen = StringLen ($FuncKeyWord)
	If $Mode = "" Then $Mode = 1 ;Default mode

	Local $File = FileOpen ($FilePath)
	If @error Then Return SetError ("-1", "", 0) ;Unable to open file.

	Local $Content = FileRead ($File)
	Local $TotalChars = @extended ;Total characters.

	Local $LineArray = StringSplit ($Content, @CRLF, 1)
	Local $TotalLineCount = $LineArray [0] ;Total lines.

	For $i = 1 To $TotalLineCount Step 1
		$FirstChar = StringMid ($LineArray [$i], 1, 1) ;Extracts the first character in the current line.
		Switch $FirstChar ;Analyzes the character.
			Case $CommentChar
				$CommentedLineCount = $CommentedLineCount + 1 ;Commented lines.
			Case Else
				If $LineArray [$i] = "" Then
					$EmptyLineCount = $EmptyLineCount + 1 ;Empty lines.
				Else
					$CodeLineCount = $CodeLineCount + 1 ;Code lines.
					$LineStart = StringMid ($LineArray [$i],1,$KeyWordLen)
					If $LineStart = $FuncKeyWord Then $FuncCount = $FuncCount + 1 ;Func count.
				EndIf
		EndSwitch

	Next
		If Not $TotalLineCount = $CommentedLineCount + $EmptyLineCount + $CodeLineCount Then Return SetError (2, "", 0) ;Invalid count.

	FileClose ($File) ;Releases file.

	;Return Section
	Switch $Mode
		Case 1 ;Returns Total lines and Commented+Empty as @extended.
			Return SetExtended ($CodeLineCount, $TotalLineCount)
		Case 2 ;Returns Total lines and Commented as @extended.
			Return SetExtended ($CommentedLineCount, $TotalLineCount)
		Case 3 ;Returns Total lines and Empty as @extended.
			Return SetExtended ($EmptyLineCount, $TotalLineCount)
		Case 4 ;Returns Total lines and Total Characters as @extended.
			Return SetExtended ($TotalChars, $TotalLineCount)
		Case 5 ;Returns Total lines and Total Characters as @extended.
			Local $Array [6]
			$Array [0] = $TotalLineCount
			$Array [1] = $CodeLineCount
			$Array [2] = $CommentedLineCount
			$Array [3] = $EmptyLineCount
			$Array [4] = $TotalChars
			$Array [5] = $FuncCount

			Return $Array
	EndSwitch

EndFunc

; #UDF# =======================================================================================================================
; Name ..........: JIF
; Description ...: Provides functions that make automation easier in AutoIt.
; Version .......: v1
; Autor ........: Juan Fox
; ===============================================================================================================================

#include <MsgBoxConstants.au3>


; #FUNCTION# ====================================================================================================================
; Name: Debug
; Description: Shows a debug dialog window with an option to copy the message to the clipboard.
; Syntax: Debug ($Text)
; Parameters: $Text	-	String to show
; Return values: Ninguno
;===============================================================================================================================
Func Debug ($Text)
	$Choice = MsgBox ($MB_OKCANCEL, "Debug", $Text & @CRLF & @CRLF & "Press OK to copy message to clipboard.")
	If $Choice = 1 Then
		ClipPut ($Text)
	EndIf
EndFunc


; #FUNCTION# ====================================================================================================================
; Name: InputProcess
; Description: Processes a string, removing spaces, Carriage-Return characters and turning it into Uper-Case.
; Syntax: InputProcess ($String)
; Parameters: $String	-	String.
; Return values: Processed string.
;===============================================================================================================================
Func CleanStr ($String)
	Return StringUpper(StringStripCR(StringStripWS($String,8)))
EndFunc


; #FUNCTION# ====================================================================================================================
; Name: WaitUntilFileExists
; Description: Waits until a file exists or the timer runs out.
; Syntax: WaitUntilFileExists ($File, $MaxTime [, $PollTime = 2000])
; Parameters:   $File	-	Path to file.
;				$MaxTime	-	Max time to wait in ms
;				$PollTime	-	OPTIONAL The time in between attempts defaults to (2000ms or 2 sec)
; Return values: Boolean for success
;===============================================================================================================================
Func WaitUntilFileExists ($File,$MaxTime,$PollTime=2)
	$FileExists=False ;Initial status
	;;MS to SEC
	$MaxTime=$MaxTime*1000
	$PollTime=$PollTime*1000

	$Timer=TimerInit()
	While TimerDiff($Timer)<=$MaxTime And Not $FileExists
		Sleep($PollTime)
		;;Actual test
		$FileExists=FileExists($File)
	WEnd

	Return ($FileExists)?(True):(False)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name: Comspec
; Description: Executes commands on CMD and returns outputs as string.
; Comments: Works with STDOUT/STDERR. It pretty much executes "cmd.exe /c <command>", but it makes life a lot easier on AutoIt.
; Syntax: Comspec ($Command)
; Parameters:   $Command	-	Comando to execute with arguments (CMD).
; Return values: Console output.
;===============================================================================================================================
Func Comspec ($Command)
	$PID = Run(@ComSpec & ' /c ' & $Command, "", @SW_HIDE, 2)
	ProcessWaitClose ($PID)
	Local $CMDData
	$CMDData &= StdoutRead ($PID)

Return $CMDData
EndFunc


; #FUNCTION# ====================================================================================================================
; Name: BasicWMI
; Description: Executes a WMI query on a remote or local host and returns output as string.
; Syntax: BasicWMI ($Host, $Command)
; Parameters:   $Host	-	Hostname or IP of destination. Leave blank ("") for localhost.
;				$Command	-	Comando to execute (WMI, without "/node").
; Return values: Console output.
;===============================================================================================================================
Func BasicWMI ($Host, $Command)
	Local $Node=($Host="")?(''):('/node:'&$Host&' ') ;;Verifies if it is local.
	$PID=Run(@ComSpec & ' /c ' & 'wmic ' & $Node & $Command,"", @SW_HIDE,2)
	ProcessWaitClose ($PID)
	Local $WMIData
	$WMIData &= StdoutRead ($PID)

Return $WMIData
EndFunc


; #FUNCTION# ====================================================================================================================
; Name: CSVRead
; Description: Reads a value from a Comma-Separated-Values list based on an index.
; Comments: If no index is set, the lenght of the list is returned.
; Syntax: CSVRead ($String, $ID)
; Parameters:   $String	-	CSV list in one line.
;				$ID	-	Index to use.
; Return values: A String with the value in that position, the lenght of the list or False if error.
;===============================================================================================================================
Func CSVRead ($String,$ID=0)
	$Array = Stringsplit ($String, ",", 1)
	If Not @error Then
		If $ID <= $Array [0] Then
			Return $Array [$ID]
		Else
			Return SetError(3,"",False)
		EndIf
	Else
		Return SetError(2,"",False)
	EndIf
EndFunc


; #FUNCTION# ====================================================================================================================
; Name: ArrayRead
; Description: Safely reads a value from an array, avoiding exceptions for out-of-range queries.
; Syntax: ArrayRead ($Array, $ID)
; Parameters:   $Array	-	Input array
;				$ID	-	Index wanted
; Return values: Either the value in that position, the lenght of the array or False if error.
;===============================================================================================================================
Func ArrayRead ($Array, $ID = 0)
	If IsArray ($Array) Then
		If $ID <= $Array [0] Then
			Return $Array [$ID]
		Else
			Return SetError(3,"",False)
		EndIf
	Else
		Return SetError(2,"",False)
	EndIf
EndFunc


; #FUNCIÓN FileGenerator # ============================================================================================================
; Name: FileGenerator
; Description:	Simplifies file creation with a set content.
; Syntax: 	FileGenerator ($FileName, $Content)
; Parameters:	$FileName	-	Name -or full path- of the file to create.
;				$Content	-	File content.
; Retorno: 		Boolean for success.
;=====================================================================================================================================
Func FileGenerator ($FileName, $Content)
	$File = FileOpen ($FileName,2)
	$Write = FileWrite ($File, $Content)
	FileClose ($File)

	Return ($Write)?(True):(False)
EndFunc


; #FUNCIÓN FileVersionCheck # ============================================================================================================
; Name: FileVersionCheck
; Description:	Verifies the version of a file.
; Syntax: 	FileVersionCheck ($File, $CheckType = 1)
; Parameters:	$File	- Path of file to check
;				$CheckType	-	Type of version to obtain: 1)ProductVersion, 2)FileVersion
; Retorno: 		Version obtained or False for error. If the file does not exist, it changes errorLevel to 2.
;==============================================================================================================================
Func FileVersionCheck ($File,$CheckType=1)
	;Defines type of version to fetch
	$CheckType=($CheckType=2)?("FileVersion"):("ProductVersion")
	;Verifies if file exists
	If FileExists ($File) Then
		;Fetches version
		$Version = FileGetVersion ($File,$CheckType)
		Return (@error<>0)?(SetError(3,"",False)):($Version)
	Else
		Return SetError (2,"",False)
	EndIf

EndFunc


; #FUNCIÓN ExecuteWait # ============================================================================================================
; Description:	Executes a program and waits for it's window to exist.
; Tipo: 		Complementaria
; Syntax: 	ExecuteWait ($Target,$Title,$Text="",$Time=20,$Mode="Run")
; Parameters:	$Target	-	Path to executable file
;				$Title	-	Title of the expected window
;				$Text	-	Text of the expected Window
;				$Time	-	Max time to wait
;				$Mode 	-   Wether to use the "Run" or "ShellExecute" built-in functions.
; Retorno: 		Boolean for success
;==============================================================================================================================
Func ExecuteWait ($Target,$Title,$Text="",$Time=20,$Mode="Run")

	$Mode=($Mode="Run")?("Run"):("ShellExecute")
	;Actual execution
	Call($Mode,$Target)
	;Wait until window exists or time out
	$Window = WinWaitActive($Title, $Text, $Time)
	Return ($Window)?(True):(False)

EndFunc


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
	Local $KeyWoardLen = StringLen ($FuncKeyWord)
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
					$LineStart = StringMid ($LineArray [$i], $KeyWoardLen)
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


; #FUNCTION# ====================================================================================================================
; Name ..........: IPRange
; Description ...:	Generates a list of IPs in a certain subnet range (only supports the last octet).
; Syntax ........: IPRange ($Subnet[, $Min = 2[, $Max = 253]])
; Parameters ....: $Subnet              - IP subnet to complete.
;                  $Min                 - [optional] Initial IP. Default is 2.
;                  $Max                 - [optional] Stopping IP. Default is 253.
; Return values .: IP List separated by CRLF chars or False in case of error (sets Error to 2 or 3).
; ===============================================================================================================================
Func IPRange ($Subnet,$Min=2,$Max=253)
	ConsoleWrite ("Subnet input: " & $Subnet & @CRLF)
	$Array=StringSplit($Subnet,".",1)
	If IsArray ($Array) Then
		If $Array[0]>3 Then
			ConsoleWrite ("Invalid subnet format: " & $Subnet & @CRLF)
			Return SetError (2,"",False)
		EndIf
	Else
		ConsoleWriteError ("No dots found in subnet: " & $Subnet & @CRLF)
		Return SetError (3,"",False)
	EndIf
	Local $IPList
	Local $IP
	For $i=$Min To $Max Step 1
		$IP=$Subnet & "." & $i
		$IPList=$IPList & $IP & @CRLF
	Next
		ConsoleWrite ("Success." & @CRLF)
		Return $IPList
EndFunc

; #FUNCIÓN IsIn # ======================================================================================================================================
; Name: IsIn
; Description: 	Verifies if a value exists in an Array (inspired in modern languages "x in collection" type functions).
; Syntax: 	IsIn ($Array,$Value)
; Parameters: 	$Array	-	Input array
;				$Value	-	Value wanted
; Retorno: 		Boolean for success
;==========================================================================================================================================================
Func IsIn ($Array,$Value)
	Local $iMax
	If IsArray($Array) Then $iMax = UBound($Array); Get array size

	For $i=0 To $iMax-1 Step 1
		If $Array[$i]=$Value Then Return True ;Breaks if the value is found.
	Next
		Return False ;In case it wasn't found.
EndFunc

; #FUNCIÓN Array_Show # ======================================================================================================================================
; Name: Array_Show
; Description: 	Prints every item in an array.
; Syntax: 	Array_Show ($Array)
; Parameters: 	$Array	-	Input array
; Retorno: 		Boolean for success
;==========================================================================================================================================================
Func Array_Show($Array)
	Local $iMax
	If IsArray($Array) Then $iMax = UBound($Array); Get array size

	For $i=0 To $iMax-1 Step 1
		ConsoleWrite($i & " : " & $Array[$i] & @CRLF)
	Next
		Return True
Endfunc

; #FUNCIÓN FileGetName # ======================================================================================================================================
; Name: FileGetName
; Description: 	Extracts the name of a file from it's path (either relative or absolute).
; Syntax: 	FileGetName ($File_Path)
; Parameters: 	$File_Path	-	Full path of the file.
; Retorno: 		The file name or False in case of error.
;==========================================================================================================================================================
Func FileGetName($File_Path)
	$ReturnValue=False
	$Array=StringSplit($File_Path,"\",1)
	If IsArray($Array) Then
		$ReturnValue=$Array[$Array[0]]
	Else
		$ReturnValue=$File_Path
	EndIf
Return $ReturnValue
EndFunc

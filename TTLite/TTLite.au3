#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=rzk.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; #UDF# =======================================================================================================================
; Name ..........: Temp-Terminator
; Description ...: A useful -lite and silent- executable that removes temporary files from a Windows system, at both User (every user) and System level (requires valid permissions).
;				   It targets the following paths (not case sensitive):
;				    	> System Level:
;							- %WINDIR%\Temp (usually C:\Windows\Temp)
;							- %WINDIR%\Downloaded Program Files (usually C:\Windows\Downloaded Program Files)
;							- <RootDrive>\Temp  (usually C:\Temp)
;						> User Level, for every user (recursive):
;							- %TEMP% (usually C:\Users\<username>\AppData\Local\Temp)
;							- %APPDATA%\Local\Microsoft\Windows\Temporary Internet Files (usually C:\Users\<username>\AppData\Local\Microsoft\Windows\Temporary Internet Files)
;							- %APPDATA%\Local\Microsoft\Windows\INetCache (usually C:\Users\<username>\AppData\Local\Microsoft\Windows\INetCache )
;
; Comments ......: This is a pretty old script from back when I started scripting/automating, so theres a lot of things that could be made better (modularization, DRYness, return values,
;					dynamic parameters, etc).
;					I dediced to leave this as it is, since I know for a fact it is a fully working solution. Back in my Help Desk days, I used to run this script against docens of hosts
;					per day with success.
; Usage .........: Simply execute the program and wait for it to finish. You could also remove all the compile syntax and simply use this as a script with AutoIt's runtime.
; Dependancies...: As you can see, I rely on some native and non-native (UDF) libraries:
;					- AutoItConstants.au3 -> Native
;					- Constants.au3 -> Native
;					- FileConstants.au3 -> Native
;					- JIF.au3 -> My own helper UDF
;					Credits to the autors.
; Platforms .....: Windows 7, 8 and 10.
; Version .......: v1
; Autor ........: Juan Fox
; Year  ........: 2018
; ===============================================================================================================================


#include <AutoItConstants.au3>
#include <Constants.au3>
#include <FileConstants.au3>
#include <JIF.au3>

;Program launch
MainEvent ()

; #FUNCTION# ====================================================================================================================
; Name ..........: MainEvent
; Description ...: Deletes temp files at system level and user (all) level
; Syntax ........: MainEvent ()
; Parameters ....: None
; Return values .: None
; ===============================================================================================================================
Func MainEvent ()

;Deletes temp files at system level
TempDelete_System ()
;Deletes temp files for every user
TempDelete_AllUsers ()

EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: TempDelete_AllUsers
; Description ...: Deletes temp files for every user recursively
; Syntax ........: TempDelete_AllUsers ()
; Parameters ....: None
; Return values .: None
; ===============================================================================================================================
Func TempDelete_AllUsers ()

	;Fetches user list
	$UserArray = GetUserArray ()

	;Performs cleaning on every user
	For $i = 0 To $UserArray [0] - 1 Step 1
		$User = StringStripWS ($UserArray [$i], 8)
		TempDelete_User ($User)
	Next

EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: GetUserArray
; Description ...: Fetches the user list on the system, but from the folder structure in C:\Users, rather than other tooling.
; Syntax ........: GetUserArray ()
; Parameters ....: None
; Return values .: None
;===========================================================================================================
Func GetUserArray ()

	$GlobalUsers = @HomeDrive & "\Users"

	;Uses CMD to list the sub-folders in the path
	$DirOutput = Comspec ("dir /b " & $GlobalUsers)
	;Converts this to an array
	$UserArray = StringSplit ($DirOutput, @CRLF, 1)

Return $UserArray

EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: TempDelete_System
; Description ...: Deletes temporary file at system level
; Syntax ........: TempDelete_System ()
; Parameters ....: None
; Return values .: None
; ===============================================================================================================================
Func TempDelete_System ()

	Local $Target [4]
		$Target [0] = @WindowsDir & "\Temp"
		$Target [1] = @HomeDrive & "\Temp"
		$Target [2] = @WindowsDir & "\Downloaded Program Files"

	;For every target path
	For $i = 0 To 3 Step 1
		;Uses CMD to move CWD to the folder and perform a deletion of every file or dir.
		Comspec ('cd "' & $Target [$i] & '" & rmdir /s /q ' & $Target [$i])
	Next
		;

EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: TempDelete_User
; Description ...: Deletes temporary files at user level
; Syntax ........: TempDelete_User ($User)
; Parameters ....: $User                - The user homedir name, rather than the username (these could be different on certain scenarios).
; Return values .: None
; ===============================================================================================================================
Func TempDelete_User ($User)

	Local $UserPath = @HomeDrive & "\Users\" & $User

	Local $Target [3]
		$Target [0] = $UserPath & "\AppData\Local\Temp\"
		$Target [1] = $UserPath & "\AppData\Local\Microsoft\Windows\Temporary Internet Files"
		$Target [2] = $UserPath & "\AppData\Local\Microsoft\Windows\INetCache"

	;For every target path
	For $i = 0 To 2 Step 1
		;Uses CMD to move CWD to the folder and perform a deletion of every file or dir.
		Comspec ('cd "' & $Target [$i] & '" & rmdir /s /q ' & $Target [$i])
	Next
		;

EndFunc

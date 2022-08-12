;Authored by Juan Fox in 2019.
;Shows a couple of examples of how to interact with the WINAPI via AutoIt.

#include <JIF.au3>

;Script init

;;Query for an existing process by name
$Result=ProcessExists_User("notepad.exe")
ConsoleWrite("PIDs are:")
Array_Show($Result)

;Query for installed printers
$Result=Printer_Query()
ConsoleWrite("Printers are:")
Array_Show($Result)

Func ProcessExists_User ($Process,$Find_All=True)
	Dim $objWMI, $colResults, $objItem, $Result_Array, $Username, $Domain

	$objWMI = ObjGet("winmgmts:\\.\root\cimv2") ;Gets Root permissions
	If Not IsObj($objWMI) Then Return SetError(2,"",False)

	$colResults = $objWMI.ExecQuery("Select * from Win32_Process WHERE Name = '" & $Process & "'"); Note the single quotes
	If Not IsObj($colResults) Then Return SetError(3,"",False)

	For $objItem in $colResults
		If IsObj($objItem) Then ;Filters only objects
			;Queries owner (returns 0 on success).
			$OwnerQuery=$objItem.GetOwner($Username,$Domain)
			;Filters only processes belonging to executing user.
			If $OwnerQuery=0 And $Domain=@LogonDomain And $Username=@UserName Then
				$Result_Array=$Result_Array&","&$objItem.ProcessId
			EndIf
		EndIf
	Next
		;Processing Array.
		$Result_Array=StringTrimLeft($Result_Array,1) ;Removes heading separator ",".
		$Result_Array=StringReplace($Result_Array,",,",",") ;Removes empty spaces.
		$Result_Array=StringSplit($Result_Array,",",1) ;Splits the string into the mentioned Array.
		;;$Result_Array=Arr_Remove($Result_Array,0) ;Removes the initial value (amount of query results returned by Win32)
		If Not IsArray($Result_Array) Then Return False ;Case erorr (non-array result)
		Return $Result_Array
EndFunc

Func Printer_Query ($Hostname=".")
	Dim $Result_Array,$objWMI, $colResults, $objItem, $intCount, $answer ;Variable designation
	If $Hostname="" Or $Hostname="localhost" Or $Hostname=@ComputerName Or $Hostname="127.0.0.1" Then $Hostname="."

	;Obtaining root cimv2 permissions
	$objWMI = ObjGet("winmgmts:\\"&$Hostname&"\root\cimv2")
	If Not IsObj($objWMI) Then Return SetError(2,"",False) ;Case error (non object)

	;Queries Win32 class with no filter.
	$colResults = $objWMI.ExecQuery("SELECT * FROM Win32_PrinterDriver")
	If Not IsObj($colResults) Then Return SetError(3,"",False) ;Case error (non object)

	;Iterates over results (array of objects).
	For $objItem In $colResults
		If IsObj($objItem) Then ;Filters only Objects
			;Creates a Main Array separated by ",," with items being Sub Arrays with info separated by values.
			$SubArray=$objItem.Name
			$Result_Array=$Result_Array&",,"&$SubArray
		EndIf
	Next
		;Processing Array.
		$Result_Array=StringTrimLeft($Result_Array,2) ;Removes heading separator ",,".
		$Result_Array=StringReplace($Result_Array,",,,,",",,") ;Removes empty spaces.
		$Result_Array=StringSplit($Result_Array,",,",1) ;Splits the string into the mentioned Array.
		;;$Result_Array=Arr_Remove($Result_Array,0) ;Removes the initial value (amount of query results returned by Win32)
		If Not IsArray($Result_Array) Then Return False ;Case erorr (non-array result)
		Return $Result_Array
EndFunc
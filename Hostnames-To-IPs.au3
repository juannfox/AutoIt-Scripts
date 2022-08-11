#CS
	Authored by Juan Fox in 2020
	Simple helper script for the day-to-day operations of IT admin/devops/helpdesk.
	Resolves a list of hostnames copied in the clipboard -new line separated- into IP addresses
	and copies them into clipboard again.
#CE


;;Gets input from clipboard
$sInput=ClipGet()
;;Generates an array by new-line characters
$sInput=StringSplit($sInput,@crlf,1)
$sOutput="" ;;Emtpy list

;;TCP open
TCPStartup()

;;Loops over the array
for $i=1 to $sInput[0] Step 1
	;;Resolves Domain Name to IP
	$sIP=TCPNameToIP($sInput[$i])
	;;Appends new IP to list
	$sOutput=$sOutput&@CRLF&$sIP
Next

;;TCP close
TCPShutdown()

;;Puts output in clipboard
ClipPut($sOutput)
ConsoleWrite("Copied to clipboard."&@CRLF)
Exit
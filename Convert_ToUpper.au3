#CS
	Simple script that converts a String to upper. The string is either provided via Clipboard or as the first Argument.
#CE

If $CMDLine[0]=0 Then
	ClipPut(StringUpper(ClipGet()))
Else
	ClipPut(StringUpper($CMDLine[1]))
EndIf
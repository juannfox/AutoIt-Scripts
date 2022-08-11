#CS
	Simple script that removes CR (Carriage-Return) and LF (Line Finish) characters from a string
	that is either provided via Clipboard or as the first Argument.
#CE

If $CMDLine[0]=0 Then
	ClipPut(StringReplace(StringReplace(ClipGet(),@CRLF,""),"  ",""))
Else
	ClipPut(StringReplace(StringReplace($CMDLine[1],@CRLF,""),"  ",""))
EndIf
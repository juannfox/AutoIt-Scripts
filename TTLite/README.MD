# TempTerminator
A useful -lite and silent- executable that removes temporary files from a Windows system, at both User (every user) and System level (requires valid permissions).
It targets the following paths (not case sensitive):
**System Level**:
- %WINDIR%\Temp
- %WINDIR%\Downloaded Program Files
- -RootDrive-\Temp

**User Level**, for every user (recursive):
- %TEMP%
- %APPDATA%\Local\Microsoft\Windows\Temporary Internet Files
- %APPDATA%\Local\Microsoft\Windows\INetCache

#### Note
This is a pretty old script from back when I started scripting/automating, so theres a lot of things that could be made better (modularization, DRYness, return values, dynamic parameters, etc).
I dediced to leave this as it is, since I know for a fact it is a fully working solution. Back in my Help Desk days, I used to run this script against docens of hosts per day with success.

## Usage
### UDF file usage
Simply execute the program and wait for it to finish (compiling necessary, as I wouldnt be a trusted source for .exe files...).
```
TempTerminator.exe
```
## Requirements
### Runtime
**AutoIt** 3 or higher.
### UDF Libraries
 Dependancies...: As you can see, I rely on some native and non-native (UDF) libraries:
- AutoItConstants.au3 -> Native
- Constants.au3 -> Native
- FileConstants.au3 -> Native
- JIF.au3 -> My own helper UDF https://github.com/juannfox/AutoIt-Scripts/tree/main/UDF/JIF

### Platforms 
Windows 7, 8 and 10.
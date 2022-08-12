# CodeLine_Counter

A program that counts the lines of code in a plain-text file, segregating:
- Actual code lines
- Commented lines (Requires a comment character like ";","//","#", etc)
- Empty lines
- Total characters
- Total functions (requires a function keyword, like in **Bash**, **Powershell** or **AutoIt**)
#### Note
This is a pretty old script from back when I started scripting/automating, so theres a lot of things that could be made better (modularization, DRYness, return values, dynamic parameters, etc).

## Usage
### Compiling
Compiling is necessary, as I wouldn't be a trusted source for .exe files.
### Execution
Execute the program, select the file through the GUI and view the result.
```
CodeLine_Counter.exe
```
## Requirements
### Runtime
**AutoIt** 3 or higher.
### UDF Libraries
 Dependancies...: As you can see, I rely on some native libraries:
- MsgBoxConstants.au3 -> Native
- File.au3 -> Native

### Platforms 
Windows 7, 8 and 10.

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
### Usage
Execute the program and select the file through the GUI and view the result.
```
CodeLine_Counter.exe
```
![Open file](https://drive.google.com/uc?export=view&id=1tuac-IFoiEgyQOtJkUGQlehfvoOyRJ-I)

Then insert the comment character (defaults to ";"):

![Enter char](https://drive.google.com/uc?export=view&id=1OT_dbqWW-dMAHl95GiWJWOA3oVOVzsLe)

And view your results:

![View result](https://drive.google.com/uc?exporrt=view&id=19aDPHKDnW8kYSRZbppLwwVzT0B6U42Uo)
## Requirements
### Runtime
**AutoIt** 3 or higher.
### UDF Libraries
 Dependancies...: As you can see, I rely on some native libraries:
- MsgBoxConstants.au3 -> Native
- File.au3 -> Native

### Platforms 
Windows 7, 8 and 10.

# JIF UDF

A series of functions I created to make my day to day IT operator easier when automating with AutoIt.

## Usage
### UDF file usage
Add this to your **AutoIt** *include* folder (usually C:\Program Files (x86)\AutoIt3\Include).
Then include the UDF in your code.
```
#include <JIF.au3>
```
### Function usage xample
With the UDF file included, erase temporary files for your user with this command:
```
Comspec("rmdir /s /q %TEMP%") 
```
Or check if a value exists within an array in a modern-fashion:
```
IsIn ($Fruits_Array,"Banana")
```

**AutoIt** 3 or higher.
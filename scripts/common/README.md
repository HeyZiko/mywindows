This folder contains common functions and code that can be reused in the primary scripts.
The best way to use these common functions is to wrap any primary script with start-execution.ps1
and finish the script with end-execution.ps1:
```
# Some primary script (not in the common folder)
. $env:MyWindowsScripts\common\start-execution.ps1 # includes all common scripts
# Do some stuff
# Do some more stuff
# Finish doing the stuff
. $env:MyWindowsScripts\common\end-execution.ps1
```

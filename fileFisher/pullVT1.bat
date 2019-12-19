@ECHO OFF
ECHO ===================================================================================
ECHO                                  --FILE FISHER--
ECHO    This utility will take in a root directory of your choice, and a target file, 
ECHO    and will recursively run through all subdirectories from the root looking for
ECHO    any file that shares the name (including file extension). Once identified, 
ECHO    all matching files are copied to a new folder in the root, /_data/filename, 
ECHO    and renamed to the name of the containing folder (retaining the file type).
ECHO    A report containing the original paths of each file is put in _report.txt.
ECHO ===================================================================================
:: Creates a log file for advanced error checking, with the actual command output
ECHO New Session: %date% %time% >> output.log
GOTO :SetRoot

:: Sets the directory, but checks that it actually exists
:SetRoot
SET /P r=" > Enter Root of Search Tree: "
DIR %r% >> output.log
IF %ERRORLEVEL% EQU 0 GOTO :SetTarget
IF %ERRORLEVEL% NEQ 0 GOTO :RootFnF

:: If the directory can't be found, users are directed to debugging
:RootFnF
ECHO = There was an error locating this root, please ensure you have quotes around the 
ECHO   path if there are any spaces, and check it's the full path, e.g. "C:\Windows\".
GOTO :SetRoot

:SetTarget
SET /P f=" > Enter Target Filename: "
GOTO :EOF

:: Recursively search folders for all matching files
:Search
SET n=0
ECHO ===================================================================================
ECHO = Searching subdirectories for "VT1.mpg", renaming each to the name of the folder 
ECHO ===================================================================================
MD %r%\_data
FOR /F "delims=" %%x IN ('dir VT1.mpg /S /B') DO (CALL :Sub "%%x" "%%n")
ECHO = Total of %n% file(s) renamed and copied to \_data				  
ECHO ===================================================================================
PAUSE
GOTO :EOF

:Sub
:: First trim the quote marks
SET a=%~1%
ECHO Found: ...%a:~-73%
:: Substring down to the Date (Starting with \20xx)
SET b=%a:*\20=%
:: Cut off the actual filename
SET c=%b:~,-8%
:: Reappend full date, file extension, and target path
SET d=%cd%\_data\20%c%.mpg
ECHO Copying to: ...%d:~-68%
::COPY "%a%" "%d%"
SET /A %~2%+=1
ECHO ===================================================================================
EXIT /B
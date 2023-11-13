### 0. Open run  <kbd>Win</kbd> + <kbd>R</kbd>
    type: powershell
### 1. Run powershell as administrator
    start powershell -verb runas
### 2. Make folder 
```
mkdir $HOME/.pyenv
cd $HOME/.pyenv
```
### 3. Download the file

    Invoke-WebRequest -Uri "https://github.com/pyenv-win/pyenv-win/archive/master.zip" -OutFile "pyenv-win.zip"
### 4. Extract
    Expand-Archive -Path "pyenv-win.zip" -DestinationPath "."
### 5. Move the file
```
Move-Item -Path "$HOME\.pyenv\pyenv-win-master\pyenv-win" -Destination "$HOME\.pyenv\"
```
```
Move-Item -Path "$HOME\.pyenv\pyenv-win-master\.version" -Destination "$HOME\.pyenv\"
```
### 6. Remove the folder
```
Remove-Item -Path "$HOME\.pyenv\pyenv-win-master" -Recurse
```
### 7. Set the environment variables PYENV and PYENV_HOME
```
[System.Environment]::SetEnvironmentVariable('PYENV',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")

[System.Environment]::SetEnvironmentVariable('PYENV_HOME',$env:USERPROFILE + "\.pyenv\pyenv-win\","User")
```
### 8. Add the `bin && shims` &nbsp; folder to the PATH variable.
    [System.Environment]::SetEnvironmentVariable('path', $env:USERPROFILE + "\.pyenv\pyenv-win\bin;" + $env:USERPROFILE + "\.pyenv\pyenv-win\shims;" + [System.Environment]::GetEnvironmentVariable('path', "User"),"User")
### 9. Execution of scripts
     Set-ExecutionPolicy unrestricted
### 10. Disable this warning by “unblocking”
    
     Unblock-File $HOME/.pyenv/pyenv-win/bin/pyenv.ps1

### 11. pyenv list and install
```
pyenv install --list 
```
```
pyenv install 3.10.0
pyenv install 3.12.0
```
### 12. pyenv set version
     pyenv shell 3.10.0
     pyenv global 3.10.0
### 13. pyenv show current version

<table>
<tr>
<th> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 </th>
<th> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 </th>
</tr>
<tr>
<td>

```
pyenv versions
```

</td>
<td>

```
pyenv version-name
```

</td>
</tr>
</table>

### 14. Test python3.10
     python3.10.bat -V
!!! Location Here:
```
cd $HOME\.pyenv\pyenv-win\shims
```
```
dir
```
### 15. pyenv set version to 3.12
     pyenv shell 3.12.0
     pyenv global 3.12.0
### 16. Run python 3.12
     python3.12.bat
### 17. Exit from python

<table>
<tr>
<th> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 </th>
<th> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 </th>
</tr>
<tr>
<td>

```
quit()
```

</td>
<td>

```
exit()
```

</td>
</tr>
</table>

### 18. Access to pip
    pip3.12.bat

### 19. Install package to pip 
```
python3.12.bat -m pip install --upgrade pip
```
```
pip3.12.bat install pynput screeninfo pywinctl
```

### 20. List the package pip
    pip3.12.bat list
    

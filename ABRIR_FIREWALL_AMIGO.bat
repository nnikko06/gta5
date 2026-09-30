@echo off
net session >nul 2>&1 || (powershell -Command "Start-Process '%~f0' -Verb RunAs" & exit /b)
netsh advfirewall firewall add rule name="NATURAL LIFE - FiveM 30120 TCP" dir=in action=allow protocol=TCP localport=30120 profile=private,public
netsh advfirewall firewall add rule name="NATURAL LIFE - FiveM 30120 UDP" dir=in action=allow protocol=UDP localport=30120 profile=private,public
echo.
echo Listo. Tu amigo ya puede conectar con: connect 26.132.7.221:30120
pause

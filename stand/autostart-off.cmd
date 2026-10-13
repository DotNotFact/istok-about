@echo off
chcp 65001 >nul
rem Istok stand: turn autostart off.
rem Удаляет ключ автозапуска, который поставил autostart-on.cmd. Уже
rem запущенную стойку не закрывает: выйти из неё - способом, выбранным во
rem вкладке «Стойка», или Alt+F4.

reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v IstokStand >nul 2>&1
if errorlevel 1 (
  echo Автозапуск стойки и так выключен.
  pause
  exit /b 0
)

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v IstokStand /f >nul
if errorlevel 1 (
  echo Не удалось выключить автозапуск. Покажите это окно ИТ-службе заказчика.
  pause
  exit /b 1
)

echo Автозапуск стойки выключен. Стойка больше не будет запускаться при входе в Windows.
pause

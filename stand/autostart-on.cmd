@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
rem Istok stand: autostart at Windows sign-in, restart after a crash.
rem Пишет ключ автозапуска текущего пользователя (HKCU\...\Run), права
rem администратора не нужны. Запускается exe с ключом --watch: это сторож,
rem который поднимает стойку снова, если она упала или её сняли из
rem диспетчера задач. Штатный выход сотрудника сторож не отменяет.

set "EXE=%~dp0istok-shell.exe"
if not exist "!EXE!" (
  echo Рядом с этим файлом нет istok-shell.exe.
  echo Распакуйте архив стойки целиком и запустите autostart-on.cmd из папки стойки.
  pause
  exit /b 1
)

rem Путь — через !EXE!, а не %EXE%: отложенное раскрытие идёт ПОСЛЕ разбора
rem строки, и папка с «&» или «^» в имени не режет команду.
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v IstokStand /t REG_SZ /d "\"!EXE!\" --watch" /f >nul
if errorlevel 1 (
  echo Не удалось включить автозапуск: Windows не дала записать ключ автозапуска.
  echo Покажите это окно ИТ-службе заказчика.
  pause
  exit /b 1
)

echo Автозапуск стойки включён:
echo   "!EXE!"
echo Стойка будет запускаться при входе в Windows и подниматься сама после сбоя.
echo Выключить - autostart-off.cmd из этой же папки.
echo.
echo Запускаю стойку под присмотром...
rem Уже открытая стойка закрывается: второй экземпляр вышел бы сразу, и
rem сторож решил бы, что стойку закрыли штатно, — до следующего входа в
rem Windows она осталась бы без присмотра.
taskkill /IM istok-shell.exe >nul 2>&1
timeout /t 2 >nul
start "" "!EXE!" --watch
timeout /t 5 >nul

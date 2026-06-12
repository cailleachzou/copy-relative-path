@echo off
chcp 65001 >nul
echo ========================================
echo   卸载 Ctrl+Shift+C 快捷键
echo ========================================
echo.

:: 删除注册表自启项
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "CopyRelativePath" /f >nul 2>&1
if %errorlevel%==0 (
    echo [√] 已删除开机自启
) else (
    echo [√] 开机自启项不存在，无需删除
)

:: 杀掉 AHK 进程
taskkill /f /im "AutoHotkey.exe" >nul 2>&1
echo [√] 已停止 AutoHotkey 进程

echo.
echo   卸载完成！
echo.
pause

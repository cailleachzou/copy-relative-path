@echo off
chcp 65001 >nul
echo ========================================
echo   安装 Ctrl+Shift+C 快捷键（复制相对路径）
echo ========================================
echo.

:: 检查 AutoHotkey v2 是否安装
set "ahk="
where /q ahk.exe 2>nul && set "ahk=ahk.exe"
if "%ahk%"=="" (
    if exist "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe" (
        set "ahk=C:\Program Files\AutoHotkey\v2\AutoHotkey.exe"
    ) else if exist "C:\Program Files\AutoHotkey\AutoHotkey.exe" (
        set "ahk=C:\Program Files\AutoHotkey\AutoHotkey.exe"
    )
)

if "%ahk%"=="" (
    echo [!] 未检测到 AutoHotkey v2
    echo     请先安装: winget install AutoHotkey.AutoHotkey
    echo.
    pause
    exit /b 1
)

echo [√] 找到 AutoHotkey: %ahk%
echo.

:: 注册开机自启（注册表 Run 键）
set "scriptPath=%~dp0copy_relative_path_hotkey.ahk"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "CopyRelativePath" /t REG_SZ /d "\"%ahk%\" \"%scriptPath%\"" /f >nul 2>&1

if %errorlevel%==0 (
    echo [√] 已注册开机自启
) else (
    echo [!] 注册开机自启失败，请以管理员权限运行
)

:: 立即启动 AHK 脚本
start "" "%ahk%" "%scriptPath%"
echo [√] 已启动快捷键监听（Ctrl+Shift+C）
echo.
echo ========================================
echo   安装完成！在资源管理器选中文件，按 Ctrl+Shift+C 即可复制
echo   如需卸载，运行 uninstall_hotkey.bat
echo ========================================
echo.
pause

; copy_relative_path_hotkey.ahk
; AutoHotkey v2 脚本 — Ctrl+Shift+C 复制相对路径（替换用户名）
; 纯 AHK 原生实现，不依赖 PowerShell，响应快

#Requires AutoHotkey v2.0
#SingleInstance Force

^+c::  ; Ctrl+Shift+C
{
    ; 获取前台窗口的 Explorer COM 对象
    try {
        shell := ComObject("Shell.Application")
        windows := shell.Windows()

        ; 找到前台 Explorer 窗口
        foregroundHwnd := DllCall("GetForegroundWindow", "Ptr")
        selectedPath := ""

        for window in windows {
            if (window.HWND = foregroundHwnd) {
                selectedItems := window.Document.SelectedItems()
                if (selectedItems.Count > 0) {
                    selectedPath := selectedItems.Item(0).Path
                }
                break
            }
        }

        ; 如果前台不是 Explorer，尝试第一个
        if (selectedPath = "" && windows.Count > 0) {
            selectedItems := windows.Item(0).Document.SelectedItems()
            if (selectedItems.Count > 0) {
                selectedPath := selectedItems.Item(0).Path
            }
        }

        if (selectedPath != "") {
            ; 替换用户目录为 %USERPROFILE%
            userProfile := EnvGet("USERPROFILE")
            result := StrReplace(selectedPath, userProfile, "%USERPROFILE%")
            A_Clipboard := result
        }
    }
}

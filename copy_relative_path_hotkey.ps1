# copy_relative_path_hotkey.ps1
# Ctrl+Shift+C 触发：获取 Explorer 选中文件 → 替换用户名 → 写剪贴板

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

try {
    # 获取当前 Explorer 窗口的选中文件
    $shell = New-Object -ComObject Shell.Application
    $windows = $shell.Windows()

    # 找到前台 Explorer 窗口
    $foregroundHwnd = (Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();' -Name 'User32' -Namespace 'Win32' -PassThru)::GetForegroundWindow()

    $selectedPath = $null
    foreach ($window in $windows) {
        if ($window.HWND -eq [int]$foregroundHwnd) {
            $selectedItems = $window.Document.SelectedItems()
            if ($selectedItems.Count -gt 0) {
                $selectedPath = $selectedItems.Item(0).Path
            }
            break
        }
    }

    if (-not $selectedPath) {
        # 如果前台不是 Explorer，尝试第一个 Explorer 窗口
        if ($windows.Count -gt 0) {
            $selectedItems = $windows.Item(0).Document.SelectedItems()
            if ($selectedItems.Count -gt 0) {
                $selectedPath = $selectedItems.Item(0).Path
            }
        }
    }

    if ($selectedPath) {
        # 替换用户目录为 %USERPROFILE%
        $result = $selectedPath -replace [regex]::Escape($env:USERPROFILE), '%USERPROFILE%'
        $result | Set-Clipboard

        # 短暂提示（3秒后消失）
        $tip = New-Object System.Windows.Forms.NotifyIcon
        $tip.Icon = [System.Drawing.SystemIcons]::Information
        $tip.Visible = $true
        $tip.ShowBalloonTip(3000, '已复制', $result, [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Seconds 3
        $tip.Dispose()
    }
} catch {
    # 静默失败，不弹错误
}

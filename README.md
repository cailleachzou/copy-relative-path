# Copy Relative Path - Windows 右键菜单工具

一键复制文件/文件夹的相对路径到剪贴板，路径中的用户目录自动替换为 `%USERPROFILE%`，方便在不同机器间复用。

## 功能

- 右键文件或文件夹 →「复制相对路径」
- **Ctrl+Shift+C** 快捷键（需安装 AutoHotkey）— 选中文件直接按快捷键复制
- 自动将 `C:\Users\YourName\...` 替换为 `%USERPROFILE%\...`
- 结果直接进剪贴板，无需手动拼接

## 安装

### 1. 注册菜单项

双击导入 `copy_relative_path.reg`，确认注册表写入。

### 2. Win11 用户：恢复经典右键菜单

Windows 11 默认隐藏了传统右键菜单（需要点"显示更多选项"才能看到）。导入以下注册表文件即可恢复经典菜单：

```
win11_restore_classic_menu.reg   ← 恢复经典右键菜单
win11_restore_new_menu.reg       ← 撤销，恢复 Win11 新菜单
```

### 3. 重启资源管理器

双击 `restart_explorer.bat` 让改动立即生效，或注销/重启电脑。

## 卸载

在注册表中删除以下路径即可：

```
HKEY_CLASSES_ROOT\Directory\shell\copyrelativepath
HKEY_CLASSES_ROOT\*\shell\copyrelativepath
```

---

## Ctrl+Shift+C 快捷键

右键菜单够用，但有时候手不想离开键盘。装个 AutoHotkey 就能在资源管理器里按 Ctrl+Shift+C 直接复制。

### 安装快捷键

1. 安装 AutoHotkey v2：
   ```
   winget install AutoHotkey.AutoHotkey
   ```
2. 双击 `install_hotkey.bat`，一键注册开机自启 + 启动监听

### 卸载快捷键

双击 `uninstall_hotkey.bat` 即可。

### 原理

| 文件 | 说明 |
|------|------|
| `copy_relative_path_hotkey.ps1` | PowerShell 脚本：通过 COM 获取 Explorer 选中文件，替换用户名，写剪贴板 |
| `copy_relative_path_hotkey.ahk` | AutoHotkey v2 脚本：注册 Ctrl+Shift+C 全局快捷键 |
| `install_hotkey.bat` | 注册开机自启（注册表 Run 键）+ 立即启动 |
| `uninstall_hotkey.bat` | 删除自启项 + 停止进程 |

## 原理

| 组件 | 说明 |
|------|------|
| `copy_relative_path.reg` | 在 `HKCR\Directory\shell` 和 `HKCR\*\shell` 下注册右键菜单项（文件夹 + 所有文件类型），调用 PowerShell 完成路径替换并写入剪贴板 |
| `win11_restore_classic_menu.reg` | 设置 `{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}` 注册表键，告诉 Win11 默认使用经典右键菜单 |
| `restart_explorer.bat` | 重启 `explorer.exe` 使注册表改动立即生效 |

## 兼容性

- Windows 10 / Windows 11
- 右键菜单：无需额外软件
- 快捷键：需要 [AutoHotkey v2](https://www.autohotkey.com/)

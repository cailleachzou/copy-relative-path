# Copy Relative Path - Windows 右键菜单工具

一键复制文件/文件夹的相对路径到剪贴板，路径中的用户目录自动替换为 `%USERPROFILE%`，方便在不同机器间复用。

## 功能

- 右键文件或文件夹 →「复制相对路径」
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
```

## 原理

| 组件 | 说明 |
|------|------|
| `copy_relative_path.reg` | 在 `HKCR\Directory\shell` 下注册右键菜单项，调用 PowerShell 完成路径替换并写入剪贴板 |
| `win11_restore_classic_menu.reg` | 设置 `{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}` 注册表键，告诉 Win11 默认使用经典右键菜单 |
| `restart_explorer.bat` | 重启 `explorer.exe` 使注册表改动立即生效 |

## 兼容性

- Windows 10 / Windows 11
- 无需安装额外软件

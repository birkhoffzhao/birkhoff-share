# 文件分类归档工具

一个简单实用的文件自动分类归档脚本，支持按文件后缀自动整理到对应文件夹。

## 功能特性

- ✅ **自动分类** - 根据文件后缀自动归档到对应分类文件夹
- ✅ **重名处理** - 自动添加序号 `_1`, `_2`... 避免文件覆盖
- ✅ **日志输出** - 实时打印操作日志和统计信息
- ✅ **异常捕获** - 单个文件失败不影响整体运行
- ✅ **可配置** - 可自定义分类规则和目标路径

## 文件说明

| 文件 | 说明 | 运行环境 |
|------|------|----------|
| `file_organizer.ps1` | PowerShell 版本 | Windows 自带，无需安装 |
| `file_organizer.py` | Python 版本 | 需安装 Python 3.x |

## 快速开始

### PowerShell 版（推荐）

1. 打开 `file_organizer.ps1` 文件
2. 修改配置区域的源文件夹路径：
   ```powershell
   $SOURCE_FOLDER = "C:\你的文件夹路径"
   ```
3. 在 VS Code 终端中运行：
   ```powershell
   powershell -ExecutionPolicy Bypass -File file_organizer.ps1
   ```
   或右键文件选择「使用 PowerShell 运行」

### Python 版本

1. 确保已安装 Python 3.x
2. 修改脚本顶部的 `SOURCE_FOLDER` 变量
3. 运行脚本：
   ```bash
   python file_organizer.py
   ```

## 配置说明

### 修改源文件夹

```powershell
# PowerShell 版
$SOURCE_FOLDER = "C:\Users\用户名\Downloads\待整理"

# Python 版
SOURCE_FOLDER: str = r"C:\Users\用户名\Downloads\待整理"
```

### 修改目标文件夹

默认在源文件夹内创建分类目录。如需指定其他位置：

```powershell
# PowerShell 版
$TARGET_FOLDER = "D:\归档文件"

# Python 版
TARGET_FOLDER: Optional[str] = r"D:\归档文件"
```

### 自定义分类规则

```powershell
# PowerShell 版
$CATEGORY_RULES = @{
    ".jpg"  = "图片"
    ".png"  = "图片"
    ".pdf"  = "文档"
    ".zip"  = "压缩包"
    # 添加更多规则...
}

# Python 版
CATEGORY_RULES: Dict[str, str] = {
    ".jpg": "图片",
    ".png": "图片",
    ".pdf": "文档",
    # 添加更多规则...
}
```

## 默认分类规则

| 分类 | 支持的后缀 |
|------|-----------|
| Images | .jpg, .jpeg, .png, .gif, .bmp, .webp, .svg, .ico |
| Documents | .pdf, .doc, .docx, .txt, .xls, .xlsx, .ppt, .pptx, .md |
| Archives | .zip, .rar, .7z, .tar, .gz |
| Code | .py, .js, .ts, .html, .css, .json, .xml, .java, .c, .cpp, .h |
| Audio | .mp3, .wav, .flac, .aac, .m4a |
| Video | .mp4, .avi, .mkv, .mov, .wmv |
| Programs | .exe, .msi, .bat, .cmd, .sh |
| Others | 未匹配后缀的文件 |

## 运行示例

```
============================================================
File Organizer (PowerShell Version)
============================================================

============================================================
Source: C:\Users\用户名\Desktop\附件材料
============================================================
[OK] 文档1.pdf -> Documents/
[OK] 图片1.jpg -> Images/
[OK] 文档2.docx -> Documents/
  -> Renamed duplicate: 文档2_1.docx
[OK] 压缩包.zip -> Archives/
============================================================
Total: 4 | Success: 4 | Failed: 0
============================================================
```

## 注意事项

1. **文件移动** - 脚本会**移动**文件而非复制，请确保已备份重要文件
2. **文件夹跳过** - 脚本仅处理文件，不会移动子文件夹
3. **权限问题** - 如遇权限错误，请以管理员身份运行

## 作者

赵晖 - 浙江海泰（奉化）律师事务所

## 更新日志

- 2026-06-13 - 初始版本，支持按后缀自动分类

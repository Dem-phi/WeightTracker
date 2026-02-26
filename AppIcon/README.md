# 应用图标替换说明

## 快速开始（5 分钟搞定）

### 方式一：使用在线图标生成器（最简单）
1. 访问 [AppIcon.co](https://appicon.co/) 或 [IconKitchen](https://icon.kitchen/)
2. 上传你的图片或选择一个模板
3. 选择 iOS 平台，点击下载
4. 解压下载的文件
5. 将 `AppIcon.appiconset` 文件夹拖入 Xcode 项目中的 `Assets.xcassets`

### 方式二：使用 Xcode（推荐）
1. 准备一张 1024x1024 的 PNG 图片
2. 在 Xcode 中打开项目
3. 找到 `Assets.xcassets` 文件夹
4. 点击 `AppIcon`
5. 将你的图片拖放到对应的插槽中
6. 点击任意其他位置保存

## 图标位置
AppIcon 配置位于：
```
WeightTracker/WeightTracker/Assets.xcassets/AppIcon.appiconset/
```

## 图标规格要求
iOS 应用需要以下尺寸的图标：
- **主要图标**: 1024x1024 像素（推荐使用此尺寸）
- **自动生成**: iOS 会根据 1024x1024 的图标自动生成其他尺寸

## 直接替换文件
如果你已经准备好了 1024x1024 的图标：
1. 将图标命名为 `appicon.png`
2. 复制到 `WeightTracker/WeightTracker/Assets.xcassets/AppIcon.appiconset/` 目录
3. 更新 `Contents.json` 文件：
```json
{
  "images" : [
    {
      "filename" : "appicon.png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

## 设计建议
- **简单识别**: 使用简洁的图形或文字
- **高对比度**: 确保在不同背景下清晰可见
- **圆角处理**: iOS 会自动添加圆角，建议使用方形图片
- **避免过多细节**: 小尺寸下细节会丢失
- **支持深色模式**: 考虑浅色和深色背景下的效果

## 当前状态
- ✅ AppIcon.appiconset 已配置完成
- ✅ 支持通用图标（1024x1024）
- ✅ 支持深色模式和着色
- ⏳ 等待添加实际图标文件

## 推荐工具
- **[AppIcon.co](https://appicon.co/)**: 一键生成所有尺寸图标
- **[IconKitchen](https://icon.kitchen/)**: 快速生成应用图标
- **[Figma](https://www.figma.com/)**: 免费在线设计工具
- **[Canva](https://www.canva.com/)**: 在线模板工具
- **[Sketch](https://www.sketch.com/)**: macOS 原生设计工具

## 临时占位图标
如果需要快速测试，可以：
1. 使用任何图片编辑器创建一个 1024x1024 的纯色图片
2. 保存为 PNG 格式
3. 按照上述步骤添加到项目中

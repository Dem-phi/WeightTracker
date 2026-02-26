# WeightTracker iOS 应用开发进度记录

## 功能增强 🚀

### 2026-02-26 - 支持双人体重追踪和可配置平均天数

**问题描述**: 需要支持记录两个人的体重数据，并能够分别显示，同时提供可选择的平均天数计算功能
**需求分析**:
1. 支持记录两个人的体重数据（我和女朋友）
2. 使用不同颜色的曲线分别显示
3. 提供Tab切换界面，方便查看每个人的数据
4. 移除固定的7天/30天平均，改为可选择的天数（3天到30天）
5. 增加更多统计数据（最高/最低体重）

**解决方案**:
1. 更新CoreData数据模型，添加`person`字段区分两个人
2. 创建`Person`枚举，定义颜色和显示名称
3. 使用`TabView`创建两个独立的界面
4. 为每个人创建独立的`PersonWeightView`
5. 添加天数选择器，支持3-30天的平均计算
6. 优化图表显示，使用虚线表示平均线
7. 增加最高/最低体重统计

**新增文件**:
- `Person.swift` - 定义人物枚举和颜色配置
- 更新 `ContentView.swift` - 实现TabView导航
- 更新 `PersistenceController.swift` - 支持按人物查询

**修改文件**:
- `ContentView.swift` - 重构为支持两个人分别查看
- `PersistenceController.swift` - 添加人物过滤功能

**完成时间**: 2026-02-26
**状态**: 已完成

## 已修复的问题 ✅

### 1. ContentView.swift 重复代码问题
**问题描述**: 文件中存在重复的导入语句和结构定义，导致编译失败
**解决方案**: 删除了重复的代码，保持文件结构清晰
**修复时间**: 2026-02-26
**状态**: 已修复

### 2. '@main' 属性重复定义问题
**问题描述**: Command SwiftCompile failed with a nonzero exit code
**错误信息**: WeightTrackerApp.swift:4:1 'main' attribute can only apply to one type in a module
**错误原因**: 模块中有多个类型使用了 @main 属性，但 Swift 只允许一个 @main 入口点
**解决方案**: 从 AppDelegate.swift 中删除 @main 属性，只保留 WeightTrackerApp.swift 中的 @main 定义
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/WeightTrackerApp.swift` (保留 @main)
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/AppDelegate.swift` (已删除 @main)
**修复时间**: 2026-02-26
**状态**: 已修复

### 3. SwiftUI Color 类型未导入问题
**问题描述**: /Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/Person.swift:7:16 Cannot find type 'Color' in scope
**错误信息**: Person.swift 文件中使用了 SwiftUI 的 Color 类型，但没有导入 SwiftUI 框架
**错误原因**: Person.swift 文件缺少 `import SwiftUI` 语句
**解决方案**: 在 Person.swift 文件顶部添加 SwiftUI 框架导入
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/Person.swift` (已添加 `import SwiftUI`)
**修复时间**: 2026-02-26
**状态**: 已修复

### 4. SwiftUI 属性初始化器中使用 self 问题
**问题描述**: /Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/ContentView.swift:25:64 Cannot use instance member 'person' within property initializer; property initializers run before 'self' is available
**错误信息**: 在属性初始化器中不能使用实例成员 'self'，因为属性初始化器在 'self' 可用之前运行
**错误原因**: ContentView 中定义了 @FetchRequest，它试图使用实例属性 'person'，但 @FetchRequest 是 computed property，不能直接访问实例属性
**解决方案**: 在 PersonWeightView 中直接定义 @FetchRequest，使用 entity 和 predicate 而不是调用方法
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/ContentView.swift` (已重构 FetchRequest 定义)
**修复时间**: 2026-02-26
**状态**: 已修复

### 5. NSPredicate 类型不匹配问题
**问题描述**: /Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/ContentView.swift:28:20 Closure passed to parameter of type 'NSPredicate' that does not accept a closure
**错误信息**: 传递给 NSPredicate 参数的是一个闭包，但 NSPredicate 不接受闭包类型
**错误原因**: @FetchRequest 的 predicate 参数期望的是 NSPredicate 类型，而不是闭包
**解决方案**: 使用 @State 来管理 predicate，在 onAppear 中初始化，这样可以在运行时访问 person 属性
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/ContentView.swift` (已使用 @State 和 onAppear 来管理 predicate)
**修复时间**: 2026-02-26
**状态**: 已修复

### 6. 文件命名不匹配问题
**问题描述**: `Item.swift` 包含 `Weight` 类定义，但文件名不匹配
**解决方案**: 重命名 `Item.swift` 为 `Weight.swift`
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/Item.swift` → `Weight.swift`
**修复时间**: 2026-02-26
**状态**: 已修复

### 7. Weight 类缺少 person 属性
**问题描述**: Weight 类缺少 `@NSManaged public var person: String` 属性
**解决方案**: 在 Weight 类中添加 person 属性
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/Weight.swift`
**修复时间**: 2026-02-26
**状态**: 已修复

### 8. Info.plist 重复定义问题
**问题描述**: Multiple commands produce '/Users/demphi/Library/Developer/Xcode/DerivedData/WeightTracker-fuzxjedgarfadqcnwfofwmteqqef/Build/Products/Debug-iphonesimulator/WeightTracker.app/Info.plist'
**错误信息**: Xcode 构建系统检测到多个目标都在生成 Info.plist 文件，导致冲突
**错误原因**: 我们手动创建了 Info.plist 文件，但 Xcode 项目配置中仍然设置了 `GENERATE_INFOPLIST_FILE = YES`
**解决方案**: 删除手动创建的 Info.plist 文件，让 Xcode 自动生成
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/Info.plist` (已删除)
- Xcode 项目配置中的 `GENERATE_INFOPLIST_FILE = YES` 设置
**修复时间**: 2026-02-26
**状态**: 已修复

### 9. 数字键盘无法关闭问题
**问题描述**: 在输入体重后，下方的数字键盘一直显示，无法关闭
**错误原因**: TextField 没有提供关闭键盘的方式，用户无法退出键盘输入状态
**解决方案**:
1. 添加 `@FocusState` 来跟踪输入框的焦点状态
2. 在 TextField 上添加 `.focused($isWeightFieldFocused)` 修饰符
3. 在 ScrollView 上添加 `.onTapGesture`，点击空白区域时关闭键盘
4. 在 `saveEntry()` 函数中添加 `isWeightFieldFocused = false`，保存后自动关闭键盘
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/ContentView.swift`
**修复时间**: 2026-02-26
**状态**: 已修复

### 10. 退出 App 后数据清空问题
**问题描述**: 当退出 App 后再次打开，所有的体重记录数据都清空了，需要重新输入
**错误原因**: 程序化创建 CoreData 模型时，数据库文件没有正确保存到 Documents 目录，导致每次启动都使用新的临时存储
**解决方案**:
1. 在 PersistenceController 中显式配置 `NSPersistentStoreDescription`
2. 使用 `FileManager` 获取 Documents 目录，并设置数据库文件的正确 URL
3. 添加调试日志，显示数据库存储位置和保存状态
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/PersistenceController.swift`
**修复时间**: 2026-02-26
**状态**: 已修复

### 11. 最低体重显示错误问题
**问题描述**: 最低体重显示的数值不正确，显示的是最高体重或其他错误的数值
**错误原因**: `lowestWeightText()` 函数中的 `min(by:)` 方法比较逻辑错误，使用了 `{ $0.weight > $1.weight }`，导致大的权重排在前面，返回了最大值而不是最小值
**解决方案**: 将比较逻辑从 `{ $0.weight > $1.weight }` 改为 `{ $0.weight < $1.weight }`，确保小的权重排在前面，正确返回最小值
**相关文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/ContentView.swift`
**修复时间**: 2026-02-26
**状态**: 已修复

## 功能优化 📝

### 2026-02-26 - 显示精度和提醒时间调整

**优化内容**:
1. 小数点显示位数从 1 位改为 2 位（`%.1f` → `%.2f`），提供更精确的体重显示
2. 每日提醒时间从 09:00 改为 22:00，更符合晚间记录体重的使用习惯

**修改文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/ContentView.swift`
  - 第 158 行：提醒时间改为 22:00
  - 第 174、231、236、241 行：体重显示格式从 `%.1f` 改为 `%.2f`
  - 第 259 行：移动平均显示格式从 `%.1f` 改为 `%.3f`

**优化时间**: 2026-02-26
**状态**: 已完成

### 2026-02-26 - 人物名称个性化

**优化内容**:
将人物名称从中文改为英文名字，更加个性化
- "我" → "Zack Chen"
- "女朋友" → "Aria Luo"

**修改文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/Person.swift`

**优化时间**: 2026-02-26
**状态**: 已完成

## 功能优化 📝

### 2026-02-26 - 添加应用图标

**优化内容**:
1. 创建 AppIcon.appiconset 配置文件
2. 提供详细的图标替换说明文档
3. 配置支持 iOS 通用图标（1024x1024）
4. 支持深色模式和着色效果
5. 提供在线图标生成工具推荐

**新增文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/AppIcon/README.md` - 图标替换说明文档
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/Assets.xcassets/AppIcon.appiconset/placeholder.txt` - 占位符说明

**修改文件**:
- `/Users/demphi/Projects/ZackApp/WeightTracker/WeightTracker/WeightTracker/Assets.xcassets/AppIcon.appiconset/Contents.json` - 图标配置文件

**使用方法**:
1. 访问 https://appicon.co/ 或 https://icon.kitchen/ 生成图标
2. 将生成的 AppIcon.appiconset 文件夹拖入 Xcode 项目
3. 或者在 Xcode 中直接拖放 1024x1024 PNG 图片到 AppIcon 插槽

**优化时间**: 2026-02-26
**状态**: 已完成（等待添加实际图标文件）

## 当前应用功能 📱

- ✅ 支持两个人的体重记录（我和女朋友）
- ✅ Tab 切换界面，方便分别查看每个人的数据
- ✅ 不同颜色的曲线显示（蓝色和粉色）
- ✅ 可选择的平均天数计算（3天、4天、5天、6天、7天、10天、14天、30天）
- ✅ 丰富的统计数据（最新体重、平均体重、最高/最低体重）
- ✅ 每日提醒功能（使用UserNotifications）
- ✅ 数据持久化存储（使用CoreData）
- ✅ 支持编辑已有记录
- ✅ 支持删除记录

## 技术栈 🛠️

- **UI框架**: SwiftUI
- **图表框架**: Charts
- **数据存储**: CoreData
- **通知系统**: UserNotifications
- **开发语言**: Swift

## 编译状态 ✅

所有 Swift 文件已通过语法检查，项目结构完整，可在 Xcode 中正常编译运行。

## 待解决问题 🚧

暂无

## 记录新的错误 🔧

请在此记录之后遇到的问题：

---

### 问题记录模板

**日期**: YYYY-MM-DD
**问题描述**: [具体错误描述]
**错误信息**: [完整的错误日志或代码]
**解决方案**: [采取的修复步骤]
**修复时间**: YYYY-MM-DD
**状态**: [待修复/已修复]
**相关文件**: [涉及的文件路径]

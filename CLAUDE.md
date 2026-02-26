# WeightTracker iOS 应用 - 项目概览

## 项目概述

**项目名称**: WeightTracker（体重追踪应用）
**平台**: iOS
**开发语言**: Swift
**UI框架**: SwiftUI
**主要用途**: 双人体重追踪和数据分析

## 核心功能

### 1. 双人体重记录
- 支持两个人分别记录体重数据
- 每个人独立存储，数据完全隔离
- 可编辑和删除历史记录

### 2. 数据可视化
- 使用 Charts 框架绘制体重变化曲线
- 不同颜色区分两个人（蓝色/粉色）
- 移动平均线（虚线显示）
- 时间轴可调整显示

### 3. 统计分析
- 可选择天数的移动平均计算（3-30天）
- 实时显示最新体重
- 最高/最低体重统计
- 数据趋势分析

### 4. 提醒功能
- 每日定时提醒（09:00）
- 使用 UserNotifications 框架
- 可开关提醒功能

## 技术架构

### 数据存储层
**技术**: CoreData
**实现方式**: 程序化创建模型
**实体**: Weight
- 属性: `date: Date`, `weight: Double`, `person: String`
**控制器**: PersistenceController（单例模式）
**上下文管理**: SwiftUI @Environment

### UI层
**架构**: SwiftUI + MVVM模式
**导航**: TabView（双Tab切换）
**状态管理**: @State + @FetchRequest
**图表**: SwiftUI Charts 框架
**组件**: PersonWeightView（独立视图组件）

### 服务层
**通知管理**: NotificationManager（独立类）
**错误处理**: do-catch模式，避免崩溃
**类型安全**: Identifiable 协议支持

## 数据模型设计

### Person 枚举
```swift
enum Person: String, CaseIterable, Identifiable {
    case me = "我"
    case girlfriend = "女朋友"

    var id: String { rawValue }
    var color: Color { 蓝色/粉色区分 }
    var displayName: String { rawValue }
}
```

### Weight 实体
```swift
@objc(Weight)
public class Weight: NSManagedObject {
    @NSManaged public var date: Date
    @NSManaged public var weight: Double
    @NSManaged public var person: String
}
```

## 实现特点

### SwiftUI 最佳实践
- **声明式 UI**: 使用 SwiftUI 的声明式语法
- **属性包装器**: 正确使用 @FetchRequest、@State、@Environment
- **错误处理**: 使用 do-catch 而非强制解包
- **组合模式**: 使用 TabView 实现多界面
- **计算属性**: 使用 computed property 进行动态数据计算

### CoreData 最佳实践
- **程序化模型**: 避免 .xcdatamodeld 文件
- **单例模式**: PersistenceController.shared
- **上下文隔离**: 每个人使用独立的查询条件
- **数据验证**: 通过 NSPredicate 过滤数据

### 视图组件化
- **PersonWeightView**: 独立的人体重视图
- **复用性**: 同一视图用于两个人，减少代码重复
- **关注点分离**: 表单、图表、统计、列表各区域独立

## 扩展性考虑

### 数据备份
- 支持 CoreData 自动迁移
- 考虑 iCloud 同步
- 支持 CSV/Excel 数据导出

### 功能增强
- 体重目标设定
- BMI 计算
- 健康提醒和建议
- 数据趋势分析图表
- 多语言支持（国际化）
- 深色模式支持
- Apple Watch 伴侣应用
- Siri 快捷指令
- Widget 支持

### 用户体验优化
- 手势操作（拖拽滑动删除记录）
- 数据输入验证
- 长按时间数据浏览
- 搜索和筛选功能
- 空状态占位显示
- 动画效果
- 声音和触觉反馈

### 性能优化
- 懒加载和数据分页
- 图表渲染优化
- CoreData 查询缓存
- 内存使用优化
- App 启动时间优化

## 开发和部署

### 开发工具链
- Swift Package Manager 用于依赖管理
- Xcode 作为 IDE
- Git 版本控制

### 构建配置
- 部署目标：iOS 15.0+
- Charts 框架要求：iOS 16.0+
- 使用 Xcode 自动生成的 Info.plist
- GENERATE_INFOPLIST_FILE = YES 设置

### 测试策略
- 单元测试：测试各个组件
- 集成测试：测试完整流程
- UI 测试：测试不同屏幕尺寸
- 性能测试：大数据量情况
- 真机测试：在设备上验证

### 发布准备
- App Store Connect 配置
- 应用图标和启动画面
- 屏幕截图和描述
- 隐私政策和数据使用说明
- 版本号和发布说明
- 审核流程准备

## 技术债务和改进建议

### 当前限制
1. 程序化创建 CoreData 模型可能在迁移时出错
2. 缺少正式的 .xcdatamodeld 文件，影响模型可视化
3. 数据验证不够完善，可能导致异常数据
4. 错误处理可以更细致，提供更好的用户反馈

### 改进建议
1. **迁移到 .xcdatamodeld**: 考虑使用 Core Data Editor 创建可视化模型
2. **添加数据验证**: 在输入层进行体重值验证
3. **改进错误处理**: 提供更友好的错误消息
4. **添加单元测试**: 对核心逻辑进行测试覆盖
5. **实现数据备份**: 定期备份用户数据
6. **添加崩溃报告**: 使用 Crashlytics 或其他服务
7. **实现数据导出**: 允许用户导出数据进行分析
8. **添加暗黑模式**: 改善夜间使用体验

## 使用说明

### 用户操作流程
1. 打开应用，选择"我"或"女朋友"标签
2. 选择日期，输入体重，点击"保存"
3. 查看体重变化曲线和统计数据
4. 可选择移动平均天数，查看不同天数的趋势
5. 可开启每日提醒，提醒记录体重
6. 在列表中查看历史记录，点击可编辑或删除
7. 切换标签查看另一个人的数据

### 配置选项
- 移动平均天数：3天、4天、5天、6天、7天、10天、14天、30天
- 提醒时间：固定为 09:00
- 数据存储：本地 CoreData 数据库

## 维护说明

### 常见问题
1. CoreData 存储配置错误 → 删除 DerivedData 缓存，重新生成配置
2. 编译错误 → 修复导入语句、属性访问、协议一致性问题
3. 运行时错误 → 使用 do-catch 替代强制解包

### 更新日志
详见 PROGRESS.md 文件，记录所有修复的问题和解决方案。

### 版本信息
- 当前版本：1.0
- 开发状态：开发中，已实现核心功能

---

*本文档为 AI 辅助分析提供了项目的完整技术概览，便于进行代码审查、功能扩展和问题诊断。*
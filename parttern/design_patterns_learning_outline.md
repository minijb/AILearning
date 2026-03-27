# 设计模式学习大纲

> 系统学习设计模式，涵盖 GoF 23 种经典模式及常用扩展模式

---

## 阶段一：设计模式基础（2-3 天）

### 1.1 什么是设计模式
- 设计模式的定义与历史（GoF四人帮）
- 设计模式的核心价值：复用解决方案、促进沟通
- 设计模式的三大分类：创建型、结构型、行为型

### 1.2 UML 类图基础
- 类与接口的表示方法
- 继承、实现、关联、聚合、组合、依赖的关系
- 常见 UML 符号速查

### 1.3 面向对象设计原则（SOLID）
| 原则 | 全称 | 核心含义 |
|------|------|----------|
| SRP | 单一职责原则 | 一个类只做一件事 |
| OCP | 开闭原则 | 对扩展开放，对修改封闭 |
| LSP | 里氏替换原则 | 子类可以替换父类 |
| ISP | 接口隔离原则 | 接口要小而专 |
| DIP | 依赖倒置原则 | 依赖抽象，不依赖具体 |

### 1.4 其他重要原则
- DRY（Don't Repeat Yourself）
- KISS（Keep It Simple, Stupid）
- LOD（Law of Demeter，最少知识原则）

---

## 阶段二：创建型模式（3-4 天）

> 核心：对象的创建机制，将创建与使用分离

### 2.1 Singleton（单例模式）
- **意图**：确保一个类只有一个实例，并提供全局访问点
- **实现**：饿汉式、懒汉式、双重检查锁、静态内部类、枚举
- **应用场景**：配置类、连接池、线程池、日志器
- **注意**：多线程问题、单例与依赖注入的权衡
- **示例代码**：
```csharp
// C# 懒汉式双重检查锁（线程安全）
public sealed class Singleton
{
    private static volatile Singleton _instance;
    private static readonly object _lock = new object();

    private Singleton() { }

    public static Singleton Instance
    {
        get
        {
            if (_instance == null)
            {
                lock (_lock)
                {
                    if (_instance == null)
                        _instance = new Singleton();
                }
            }
            return _instance;
        }
    }
}
```

### 2.2 Factory Method（工厂方法模式）
- **意图**：定义创建对象的接口，让子类决定实例化哪个类
- **结构**：Product / ConcreteProduct / Creator / ConcreteCreator
- **与简单工厂的对比**
- **应用场景**：数据库连接创建、日志记录器、文档格式处理

### 2.3 Abstract Factory（抽象工厂模式）
- **意图**：创建一系列相关对象，而无需指定具体类
- **结构**：AbstractFactory / ConcreteFactory / AbstractProduct / ConcreteProduct / Client
- **应用场景**：跨平台 UI 组件、数据库访问层
- **优点**：一致性保证；**缺点**：难以支持新产品

### 2.4 Builder（建造者模式）
- **意图**：分步骤构建复杂对象
- **结构**：Builder / ConcreteBuilder / Director / Product
- **链式调用实现**
- **应用场景**：`StringBuilder`、Entity Framework 的 `IQueryable`、自定义 Builder 链式调用

### 2.5 Prototype（原型模式）
- **意图**：通过复制现有对象来创建新对象
- **浅拷贝 vs 深拷贝**
- **应用场景**：原型菜单、复杂对象初始化开销大时
- **C# 实现**：`MemberwiseClone()`（浅拷贝）、深拷贝（手动复制或序列化）

---

## 阶段三：结构型模式（4-5 天）

> 核心：将类或对象组合成更大的结构

### 3.1 Adapter（适配器模式）
- **意图**：将一个类的接口转换成另一个接口
- **类适配器（继承）vs 对象适配器（组合）**
- **应用场景**：第三方库适配、旧系统对接
- **示例**：USB转接头、C# 包装类实现目标接口

### 3.2 Bridge（桥接模式）
- **意图**：将抽象部分与实现部分分离，使它们可以独立变化
- **核心思想**：组合代替继承，避免类爆炸
- **应用场景**：跨平台应用、多维度变化场景
- **与适配器模式的区别**：适配器是事后补救，桥接是事前设计

### 3.3 Composite（组合模式）
- **意图**：将对象组合成树形结构以表示"部分-整体"层次
- **透明方式 vs 安全方式**
- **应用场景**：文件系统、GUI组件树、组织架构
- **示例**：
```csharp
public abstract class Component
{
    public abstract string Operation();
}

public class Leaf : Component
{
    public override string Operation() => "Leaf";
}

public class Composite : Component
{
    private readonly List<Component> _children = new List<Component>();

    public void Add(Component c) => _children.Add(c);

    public override string Operation()
        => "Composite(" + string.Join("+", _children.Select(c => c.Operation())) + ")";
}
```

### 3.4 Decorator（装饰器模式）
- **意图**：动态地给对象添加额外职责
- **结构**：Component / ConcreteComponent / Decorator / ConcreteDecorator
- **C# 中的实现**：继承结构（经典方式）、扩展方法（语法层面的"装饰"）
- **应用场景**：IO流包装、日志增强、缓存层
- **与继承的对比**：更灵活，避免类爆炸

### 3.5 Facade（外观模式）
- **意图**：为子系统中的一组接口提供统一的高层接口
- **应用场景**：封装复杂第三方库、统一API网关
- **设计要点**：外观类不应知道子系统的所有细节

### 3.6 Flyweight（享元模式）
- **意图**：运用共享技术有效地支持大量细粒度对象
- **内部状态 vs 外部状态**
- **应用场景**：文本编辑器（字符对象）、游戏中的子弹/树
- **池化技术的关系**

### 3.7 Proxy（代理模式）
- **意图**：为其他对象提供一种代理以控制对这个对象的访问
- **类型**：远程代理、虚代理（懒加载）、保护代理、智能引用
- **应用场景**：延迟初始化（图片加载）、访问控制（AOP）、日志增强
- **与装饰器的区别**：代理控制访问，装饰器增强功能

---

## 阶段四：行为型模式 — 对象型（4-5 天）

> 核心：对象间的职责分配与算法协作

### 4.1 Chain of Responsibility（责任链模式）
- **意图**：将请求沿着处理者链传递，直到有一个处理它
- **结构**：Handler / ConcreteHandler
- **应用场景**：过滤器链、拦截器、日志级别处理
- **与装饰器的区别**：责任链可中途终止，装饰器一定会执行

### 4.2 Command（命令模式）
- **意图**：将请求封装为对象，从而支持参数化、排队、日志
- **结构**：Command / ConcreteCommand / Invoker / Receiver
- **应用场景**：撤销/重做、批处理任务、宏命令
- **与策略模式的区别**：命令关注"做什么"，策略关注"怎么做"

### 4.3 Iterator（迭代器模式）
- **意图**：提供一种顺序访问集合元素的方法，不暴露内部表示
- **C# 的 `IEnumerable<T>` / `yield` 内置支持**
- **应用场景**：集合遍历、数据库游标

### 4.4 Mediator（中介者模式）
- **意图**：用一个中介对象来封装一系列对象交互
- **结构**：Mediator / ConcreteMediator / Colleague
- **应用场景**：GUI对话框、聊天室中央服务器
- **与观察者模式的区别**

### 4.5 Memento（备忘录模式）
- **意图**：在不破坏封装性的情况下捕获对象的内部状态
- **结构**：Originator / Memento / Caretaker
- **应用场景**：游戏存档、撤销功能
- **深拷贝 vs Memento**

### 4.6 Observer（观察者模式）
- **意图**：定义对象间的一对多依赖关系
- **结构**：Subject / Observer / ConcreteSubject / ConcreteObserver
- **C# 实现**：`event` 关键字、`INotifyPropertyChanged` 接口、事件总线
- **应用场景**：GUI事件系统、消息推送、MVC架构
- **缺点**：观察者过多时的性能问题

### 4.7 State（状态模式）
- **意图**：允许对象在内部状态改变时改变它的行为
- **结构**：Context / State / ConcreteState
- **应用场景**：状态机实现（订单流程、TCP连接）
- **与策略模式的区别**：状态由上下文管理，策略由客户选择

### 4.8 Strategy（策略模式）
- **意图**：定义一系列算法，把它们一个个封装起来
- **结构**：Strategy / ConcreteStrategy / Context
- **应用场景**：排序算法选择、支付方式、促销计算
- **与状态模式的区别**：见 4.7

### 4.9 Template Method（模板方法模式）
- **意图**：在父类中定义算法骨架，某些步骤由子类实现
- **结构**：AbstractClass / ConcreteClass
- **C# 实现**：抽象类（`abstract`）+ 虚方法（`virtual` / `override`）
- **应用场景**：框架生命周期、排序算法骨架
- **好莱坞原则**："别调用我们，我们会调用你"

### 4.10 Visitor（访问者模式）
- **意图**：将算法与对象结构分离
- **结构**：Visitor / ConcreteVisitor / Element / ObjectStructure
- **双重分发（Double Dispatch）机制**
- **应用场景**：编译器 AST 遍历、报表生成
- **缺点**：添加新元素困难

---

## 阶段五：进阶与扩展（3-4 天）

### 5.1 模式之间的关系与对比
- 装饰器 vs 代理 vs 适配器
- 策略 vs 状态
- 工厂方法 vs 抽象工厂
- 组合 vs 装饰（结构性对比）
- 观察者 vs 中介者

### 5.2 常用扩展模式
- **DAO模式**：数据访问对象
- **DTO模式**：数据传输对象
- **Repository模式**：仓储模式
- **Factory Method的变体**：参数化工厂
- **对象池模式（Object Pool）**：连接池、线程池
- **空对象模式（Null Object）**：替代 null 检查
- **规格模式（Specification）**：业务规则组合

### 5.3 反模式（Anti-Patterns）
- 认识常见的错误设计：
  - 上帝类（God Object）
  - 深层继承树
  - 字符串枚举
  - 硬编码
  - 回调地狱

### 5.4 设计模式与架构
- MVC / MVP / MVVM 中的模式应用
- 依赖注入（DI）与控制反转（IoC）
- CQRS 与事件溯源中的模式
- 微服务架构中的模式应用

---

## 阶段六：实践与总结（持续）

### 6.1 编码练习建议
- 用多种语言实现同一个模式（C# / Java / TypeScript）
- 分析 .NET 源码 / Spring / React 源码中的设计模式
- 重构一段"坏代码"，用设计模式改进

### 6.2 推荐阅读
- 《设计模式：可复用面向对象软件的基础》（GoF）— 经典必读
- 《Head First 设计模式》— 入门友好
- 《重构与模式》— 实战导向
- 《代码大全》— 编码实践

### 6.3 学习检查清单
- [ ] 能说出 23 种模式的名称与分类
- [ ] 能用自己的话解释每种模式的意图
- [ ] 能说出模式的核心结构（类图）
- [ ] 能识别代码中使用的模式
- [ ] 能根据场景选择合适的模式
- [ ] 能指出模式的适用场景与缺点
- [ ] 能区分易混淆的模式对

---

## 学习进度追踪

| 阶段 | 主题 | 完成度 | 备注 |
|------|------|--------|------|
| 一 | 设计模式基础 | / | |
| 二 | 创建型模式 | / | |
| 三 | 结构型模式 | / | |
| 四 | 行为型模式 | / | |
| 五 | 进阶与扩展 | / | |
| 六 | 实践与总结 | / | |

---

*最后更新：2026-03-25*

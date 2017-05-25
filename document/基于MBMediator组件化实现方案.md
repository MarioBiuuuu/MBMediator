# 基于MBMediator组件化实现方案
#### 一、 代码托管平台（github，oschina，coding）创建一个组织用来管理维护整个项目（包含各个子模块所开项目），其中需要一个壳应用（主程序）。抽出来的独立Pod、私有Pod源也都会放在这个orgnization中去。   
#### 二、主程序以及相应配置  

```
1. 先去开一个repo，这个repo就是我们私有Pod源仓库
2. pod repo add [私有Pod源仓库名字] [私有Pod源的repo地址]
3. 创立一个文件夹，例如Project。把我们的主工程文件夹放到Project下：~/Project/MainProject
4. 在~/Project下clone快速配置私有源的脚本repo：git clone https://github.com/MarioBiuuuu/MBConfigPrivatePod.git
5. 将MBConfigPrivatePod的template文件夹下Podfile中source 'https://github.com/私有仓库地址.git'改成第一步里面你自己的私有Pod源仓库的repo地址
6. 将MBConfigPrivatePod的template文件夹下upload.sh中PrivatePods改成第二步里面你自己的私有Pod源仓库的名字
``` 

目录结构： 

```
Project
├── MBConfigPrivatePod
└── MainProject
```

#### 三、组件化核心步骤：
**第一步：创建私有Pod工程`AProject`**

```
1. 新建子模块项目工程，命名为AProject，放到Project下
2. 仓库中新建Repo，命名也为AProject
```
目录结构： 

```
Project
├── MBConfigPrivatePod
├── MainProject
└── AProject
```

通过终端cd到ConfigPrivatePod下， 执行./config.sh脚本，自动化配置私用Pod。根据终端提示填写对应的Project Name、HTTPS Repo、SSH Repo、Home Page Url。([SSH 配置另有文档](http://www.jianshu.com/p/b3e6e2b51937)，[单独创建私有仓库依然另有文档](http://www.jianshu.com/p/7b65bc1ecb91))。
这个脚本要求私有Pod的文件目录要跟脚本所在目录平级，也会在XCode工程的代码目录下新建一个跟项目同名的目录。放在这个目录下的代码就会随着Pod的发版而发出去，这个目录以外的代码就不会跟随Pod的版本发布而发布，这样子写用于测试的代码就比较方便。

此时A工程结构：

```
AProject
├── AProject
|   ├── AProject
|   │   ├── AViewController.h
|   │   └── AViewController.m
|   ├── AppDelegate.h
|   ├── AppDelegate.m
|   ├── ViewController.h
|   ├── ViewController.m
|   └── main.m
└── AProject.xcodeproj
```

第二步、Category工程创建`AProject_Category Pod`
与创建工程AProject方式一样，再创建一个AProject_Category, 同样需要执行./config.sh脚本来配置私有Pod。

此时的目录结构应该为:

```
Project
├── AProject
│   ├── AProject
│   │   ├── AProject
│   │   ├── AppDelegate.h
│   │   ├── AppDelegate.m
│   │   ├── Assets.xcassets
│   │   ├── Info.plist
│   │   ├── ViewController.h
│   │   ├── ViewController.m
│   │   └── main.m
│   ├── AProject.podspec
│   ├── AProject.xcodeproj
│   ├── FILE_LICENSE
│   ├── Podfile
│   ├── readme.md
│   └── upload.sh
├── AProject_Category
│   ├── AProject_Category
│   │   ├── AProject_Category
│   │   ├── AppDelegate.h
│   │   ├── AppDelegate.m
│   │   ├── Info.plist
│   │   ├── ViewController.h
│   │   ├── ViewController.m
│   │   └── main.m
│   ├── AProject_Category.podspec
│   ├── AProject_Category.xcodeproj
│   ├── FILE_LICENSE
│   ├── Podfile
│   ├── readme.md
│   └── upload.sh
├── MBConfigPrivatePod
│   ├── config.sh
│   └── templates
└── MainProject
    ├── FILE_LICENSE
    ├── MainProject
    ├── MainProject.xcodeproj
    ├── MainProject.xcworkspace
    ├── Podfile
    ├── Podfile.lock
    ├── Pods
    └── readme.md
```
此时需要CD 进入 AProject_Category目录, 编辑Podfile 新增`pod "MBMediator"`, 在podspec文件的后面添加s.dependency "CTMediator",最后需要执行`pod install --verbose --no-repo-update`来对工作去进行更新。

打开AProject_Category.xcworkspace，把脚本生成的名为AProject_Category的空目录拖放到Xcode对应的位置下，然后在这里新建基于MBMediator的Category：MBMediator+A。最后你的A_Category工程应该是这样的：

```
AProject_Category
├── AProject_Category
|   ├── AProject_Category
|   │   ├── MBMediator+A.h
|   │   └── MBMediator+A.m
|   ├── AppDelegate.h
|   ├── AppDelegate.m
|   ├── ViewController.h
|   └── ViewController.m
└── AProject_Category.xcodeproj
```

**第二步：在主工程中引入A_Category工程, 实现分类方法**
首先，去主工程的Podfile下添加`pod "AProject_Category", :path => "../AProject_Category"`来本地引用AProject_Category。

在Development Pods下的MBMediator+A.h中添加：

```
- (UIViewController *)A_aViewController;
- (UIViewController *)A_aViewController:(NSDictionary *)params;
```

再去MBMediator+A.m中，补上这个方法的实现：

```
- (UIViewController *)A_aViewController {
    return [self performTarget:@"A" action:@"viewController" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)A_aViewController:(NSDictionary *)params {
    return [self performTarget:@"A" action:@"viewController" params:params shouldCacheTarget:NO];
}
```

*注意：performTarget:@"A"中给到的@"A"其实是Target对象的名字。一般来说，一个业务Pod只需要有一个Target就够了，但一个Target下可以有很多个Action。Action的名字也是可以随意命名的，只要到时候Target对象中能够给到对应的Action就可以了*

在主程序中实现跳转方法：

```
UIViewController *viewController = [[MBMediator sharedInstance] A_aViewController];
[self.navigationController pushViewController:viewController animated:YES];
```

**第三步：添加Target-Action**

在A工程中创建一个文件夹：Targets，新建一个对象Target_A。在Target_A中新建一个方法：Action_viewController。
其实在实现的过程中主要是对照：A_Category的内容去做。
如：
`performTarget:@"A" ——> Target_A`
`对应的Action是viewController，于是在Target_A中新建一个方法：Action_viewController`
因为Target对象处于APeoject的命名域中，所以Target对象中可以随意import A业务线中的任何头文件。

实现：

```
头文件：
#import <UIKit/UIKit.h>

@interface Target_A : NSObject

- (UIViewController *)Action_viewController:(NSDictionary *)params;

@end

实现文件：
#import "Target_A.h"
#import "AViewController.h"

@implementation Target_A

- (UIViewController *)Action_viewController:(NSDictionary *)params {
    AViewController *viewController = [[AViewController alloc] init];
//    
    return viewController;
}

@end
```

版本发布：
命令行cd进入到对应的项目中，然后执行命令就可以了。

```
git add .
git commit -m "版本号"
git tag 版本号
git push origin master --tags
./upload.sh
```
最后，所有的Pod发完版之后，我们再把Podfile里原来的本地引用改回正常引用，也就是把:path...那一段从Podfile里面去掉就好了，改动之后记得commit并push。



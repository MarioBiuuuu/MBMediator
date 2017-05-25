//
//  MBMediator.h
//
//  Created by ZhangXiaofei on 2017/5/23.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBMediator : NSObject
/** 单例 */
+ (instancetype)sharedInstance;

/**
 远程APP调用
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234

 @param url url
 @param completion 代码块
 @return 对象
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;

/**
 本地组件调用

 @param targetName target_名称
 @param actionName 调用方法名
 @param params 请求参数
 @param shouldCacheTarget 是否缓存当前target
 @return 对象
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

/**
 是否target

 @param targetName 待释放target_名称
 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;
@end

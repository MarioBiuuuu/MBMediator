//
//  MBMediator.m
//
//  Created by ZhangXiaofei on 2017/5/23.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBMediator.h"
#import <objc/runtime.h>

@interface MBMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation MBMediator

static MBMediator *mediator;

#pragma mark - public methods
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[MBMediator alloc] init];
    });
    return mediator;
}

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    Class targetClass;
    
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([self checReturnVoidSelector:action target:target]) {
            [target performSelector:action withObject:params];
            return nil;
        } else {
            return [target performSelector:action withObject:params];
        }
#pragma clang diagnostic pop
    } else {
        // 有可能target是Swift对象
        actionString = [NSString stringWithFormat:@"Action_%@WithParams:", actionName];
        action = NSSelectorFromString(actionString);
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([self checReturnVoidSelector:action target:target]) {
                [target performSelector:action withObject:params];
                return nil;
            } else {
                return [target performSelector:action withObject:params];
            }
#pragma clang diagnostic pop
        } else {
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
            SEL action = NSSelectorFromString(@"notFound:");
            if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if ([self checReturnVoidSelector:action target:target]) {
                    [target performSelector:action withObject:params];
                    return nil;
                } else {
                    return [target performSelector:action withObject:params];
                }
#pragma clang diagnostic pop
            } else {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                [self.cachedTarget removeObjectForKey:targetClassString];
                return nil;
            }
        }
    }
}

/** 检测方法返回值是否为void */
- (BOOL)checReturnVoidSelector:(SEL)aSelector target:(NSObject *)target {
    Method m = class_getInstanceMethod([target class], aSelector);
    char returnType[512];
    method_getReturnType(m, returnType, 512);
    
    if (returnType[0] != 'v') {
        return NO;
    } else {
        return YES;
    }
    
}

/** 释放缓存 */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName {
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - lazy load
- (NSMutableDictionary *)cachedTarget {
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

@end

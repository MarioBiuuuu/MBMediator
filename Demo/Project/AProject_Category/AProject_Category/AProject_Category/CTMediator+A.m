//
//  CTMediator+A.m
//  AProject_Category
//
//  Created by ZhangXiaofei on 2017/5/22.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "CTMediator+A.h"

@implementation MBMediator (A)
- (UIViewController *)A_aViewController {
    /*
     AViewController *viewController = [[AViewController alloc] init];
     */
    return [self performTarget:@"A" action:@"getViewController" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)A_aViewController:(NSDictionary *)params {
    return [self performTarget:@"A" action:@"getViewController" params:params shouldCacheTarget:NO];

}

- (UIViewController *)A_aViewController:(NSDictionary *)params handler:(void(^)(NSDictionary *info))handler {
    NSMutableDictionary *paramsToSend = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if (handler) {
        paramsToSend[@"handler"] = handler;
    }
    return [self performTarget:@"A" action:@"getViewController" params:paramsToSend shouldCacheTarget:NO];

}

@end

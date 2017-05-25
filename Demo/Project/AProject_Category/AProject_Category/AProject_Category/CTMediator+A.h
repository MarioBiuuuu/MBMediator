//
//  CTMediator+A.h
//  AProject_Category
//
//  Created by ZhangXiaofei on 2017/5/22.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <MBMediator/MBMediator.h>

@interface MBMediator (A)
- (UIViewController *)A_aViewController;

- (UIViewController *)A_aViewController:(NSDictionary *)params;

- (UIViewController *)A_aViewController:(NSDictionary *)params;

- (UIViewController *)A_aViewController:(NSDictionary *)params handler:(void(^)(NSDictionary *info))handler;

@end

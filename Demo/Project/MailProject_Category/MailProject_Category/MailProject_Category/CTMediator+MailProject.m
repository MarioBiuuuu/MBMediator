//
//  CTMediator+MailProject.m
//  MailProject_Category
//
//  Created by ZhangXiaofei on 2017/5/25.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "CTMediator+MailProject.h"

@implementation MBMediator (MailProject)
- (UIViewController *)Mail_login {
    NSLog(@"step 1");
    return [self performTarget:@"MailProject" action:@"loginStatus" params:nil shouldCacheTarget:NO];
}
- (void)Mail_login2 {
    [self performTarget:@"MailProject" action:@"loginStatus2" params:nil shouldCacheTarget:NO];
}
@end

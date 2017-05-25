//
//  Target_MailProject.m
//  MailProject
//
//  Created by ZhangXiaofei on 2017/5/25.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "Target_MailProject.h"
#import "MailViewController.h"
@implementation Target_MailProject

- (UIViewController *)Action_loginStatus:(NSDictionary *)param {
    return [[MailViewController alloc] init];
}

- (void)Action_loginStatus2:(NSDictionary *)param {
    NSLog(@"hihihihi");
}
@end

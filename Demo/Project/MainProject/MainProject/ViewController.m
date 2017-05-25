//
//  ViewController.m
//  MainProject
//
//  Created by ZhangXiaofei on 2017/5/22.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "ViewController.h"
#import <AProject_Category/CTMediator+A.h>
#import <MailProject_Category/CTMediator+MailProject.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"Main";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
}

- (IBAction)function1:(id)sender {
    //    UIViewController *viewController = [[CTMediator sharedInstance] A_aViewController];
//    void (^textBlock) (NSString*text) = ^(NSString*str){
//        
//        NSLog(@"%@", str);
//        
//    };
//    UIViewController *viewController = [[MBMediator sharedInstance] A_aViewController:@{@"title" : @"标题", @"handler" : textBlock}];
    UIViewController *viewController = [[MBMediator sharedInstance] A_aViewController:@{@"title" : @"标题"} handler:^(NSDictionary *info) {
        NSLog(@"%@", info);

    }];
    [self.navigationController pushViewController:viewController animated:YES];

}
- (IBAction)function2:(id)sender {
    UIViewController *viewController = [[MBMediator sharedInstance] Mail_login];
    [self.navigationController pushViewController:viewController animated:YES];

}
- (IBAction)aaaa:(id)sender {
    [[MBMediator sharedInstance] Mail_login2];;
}

@end

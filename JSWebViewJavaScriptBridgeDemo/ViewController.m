//
//  ViewController.m
//  JSWebViewJavaScriptBridgeDemo
//
//  Created by lianditech on 2017/8/25.
//  Copyright © 2017年 lianditech. All rights reserved.
//

#import "ViewController.h"
#import "HtmlViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static NSString *const webViewSegueIdf = @"webViewSegueIdf";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Click
- (IBAction)baiduClick:(id)sender {
    [self performSegueWithIdentifier:webViewSegueIdf sender:@(YES)];
}

- (IBAction)interactClick:(id)sender {
    [self performSegueWithIdentifier:webViewSegueIdf sender:@(NO)];
}

#pragma mark - Nav
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:webViewSegueIdf]) {
        HtmlViewController *htmlVC = segue.destinationViewController;
        if ([sender boolValue]) {
            htmlVC.urlString = @"https://www.baidu.com";
            htmlVC.isOnline = YES;
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"html"];
            htmlVC.urlString = path;
            htmlVC.isOnline = NO;
        }
        
    }
}

@end

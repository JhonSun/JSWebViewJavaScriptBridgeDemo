//
//  HtmlViewController.m
//  JSWebViewJavaScriptBridgeDemo
//
//  Created by lianditech on 2017/8/25.
//  Copyright © 2017年 lianditech. All rights reserved.
//

#import "HtmlViewController.h"
#import "WebViewJavascriptBridge.h"

@interface HtmlViewController ()<UIWebViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) WebViewJavascriptBridge* bridge;

@end

@implementation HtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    
    NSURL *url = nil;
    if (self.isOnline) {
        url = [NSURL URLWithString:self.urlString];
    } else {
        url = [NSURL fileURLWithPath:self.urlString];
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    
    [self.bridge registerHandler:@"getImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"调用oc代码了，参数：%@", data[@"key"]);
        UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
        imagePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerC.allowsImageEditing = YES;
        imagePickerC.delegate = self;
        [self presentViewController:imagePickerC animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Clcik
- (IBAction)gobackClick:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"网页加载错误，错误原因:%@", [error localizedDescription]);
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyyMMddHHssmmSSS"];
    NSString *aPath=[NSString stringWithFormat:
                     @"%@/Documents/%@%@.jpg",NSHomeDirectory(),@"test", [dataFormatter stringFromDate:[NSDate date]]];
    NSLog(@"沙盒路劲：%@", aPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [NSString stringWithFormat:
                              @"%@/Documents/",NSHomeDirectory()];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentPath error:nil];
    for (NSString *filePath in fileList) {
        [fileManager removeItemAtPath:[documentPath stringByAppendingString:filePath] error:nil];
    }
    //image是对应的图片,即图片通过UIPickerController获取系统相册图
    NSData *imgData = UIImageJPEGRepresentation(originalImage,0);
    //保存到当地文件中
    [imgData writeToFile:aPath atomically:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.bridge callHandler:@"setImage" data:aPath];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

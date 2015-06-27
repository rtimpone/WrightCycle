//
//  WRCAccountViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 6/27/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCAccountViewController.h"

@interface WRCAccountViewController ()

///The webview to show the account page in
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


NSString * const kDivvyAccountURL = @"https://www.divvybikes.com/login";

@implementation WRCAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString: kDivvyAccountURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: request];
}

@end

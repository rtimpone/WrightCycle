//
//  WRCAccountViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 6/27/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCAccountViewController.h"
#import "WrightCycle-Swift.h"

@interface WRCAccountViewController ()

///The webview to show the account page in
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


NSString * const kDivvyAccountURL = @"https://www.divvybikes.com/login";
NSString * const kSetupLoginSegueIdentifier = @"setupLoginSegue";
NSString * const kUsernameFieldElementName = @"subscriberUsername";
NSString * const kPasswordFieldElementName = @"subscriberPassword";

@implementation WRCAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLoginPage];
}

- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if ([segue.identifier isEqualToString: @"setupLoginSegue"])
    {
        WRCSetupLoginViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

#pragma mark - Web View Delegate

- (void)webViewDidFinishLoad: (UIWebView *)webView
{
    //autofill the username and password fields with the values stored in the keychain if displaying the login screen
    if ([webView.request.URL.absoluteString isEqualToString: kDivvyAccountURL])
    {
        NSString *username = [[WRCKeychainManager sharedInstance] retrieveStringFromKeychainOfType: WRCKeychainItemTypeUsername];
        NSString *password = [[WRCKeychainManager sharedInstance] retrieveStringFromKeychainOfType: WRCKeychainItemTypePassword];
        
        if (username)
        {
            NSString *usernameJavascript = [NSString stringWithFormat: @"document.getElementById('%@').value='%@'", kUsernameFieldElementName, username];
            [self.webView stringByEvaluatingJavaScriptFromString: usernameJavascript];
        }
        
        if (password)
        {
            NSString *passwordJavascript = [NSString stringWithFormat: @"document.getElementById('%@').value='%@'", kPasswordFieldElementName, password];
            [self.webView stringByEvaluatingJavaScriptFromString: passwordJavascript];
        }
    }
}

#pragma mark - Setup Login Controller Delegate

//Called when the user updates their login credentials
- (void)setupLoginViewControllerUserDidUpdateCredentials: (WRCSetupLoginViewController *)controller
{
    if ([self.webView.request.URL.absoluteString isEqualToString: kDivvyAccountURL])
    {
        [self loadLoginPage];
    }
}

#pragma mark - Helpers

//Load the Divvy account login page
- (void)loadLoginPage
{
    NSURL *url = [NSURL URLWithString: kDivvyAccountURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: request];
}

@end

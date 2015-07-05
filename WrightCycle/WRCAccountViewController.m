//
//  WRCAccountViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 6/27/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCAutoRefreshDataManager.h"
#import "WRCAccountViewController.h"
#import "WRCConfiguration.h"
#import "WRCiCloudRequestHandler.h"
#import "WrightCycle-Swift.h"

@interface WRCAccountViewController ()

///The webview to show the account page in
@property (weak, nonatomic) IBOutlet UIWebView *webView;

///The activity indicator that is visible when the page first loads
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

///The toolbar containing the webview controls
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

///The string URL of the Divvy account login screen
@property (strong, nonatomic) NSString *divvyAccountURLString;

@end


NSString * const kSetupLoginSegueIdentifier = @"setupLoginSegue";
NSString * const kDefaultDivvyAccountURL = @"https://www.divvybikes.com/login";
NSString * const kDefaultUsernameFieldElementName = @"subscriberUsername";
NSString * const kDefaultPasswordFieldElementName = @"subscriberPassword";

@implementation WRCAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WRCConfiguration *configuration = [[WRCiCloudRequestHandler sharedManager] cachedConfiguration];
    self.divvyAccountURLString = configuration.accountURLString ? configuration.accountURLString : kDefaultDivvyAccountURL;
    
    //adjust insets of the webview to account for the toolbar
    UIEdgeInsets insets = self.webView.scrollView.contentInset;
    UIEdgeInsets newInsets = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + self.toolbar.frame.size.height, insets.right);
    self.webView.scrollView.contentInset = newInsets;
    self.webView.scrollView.scrollIndicatorInsets = newInsets;
    
    //load the Divvy account login page
    [self reloadLoginPage];
    
    //listen for application becoming active
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(configurationUpdateNotificationReceived:) name: kConfigurationUpdatedNotification object: nil];
}

- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if ([segue.identifier isEqualToString: @"setupLoginSegue"])
    {
        WRCSetupLoginViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Notification Center Callbacks

- (void)configurationUpdateNotificationReceived: (NSNotification *)notification
{
    WRCConfiguration *configuration = notification.object;
    if (configuration.accountURLString && ![configuration.accountURLString isEqualToString: self.divvyAccountURLString])
    {
        self.divvyAccountURLString = configuration.accountURLString;
        [self reloadLoginPage];
    }
}

#pragma mark - Web View Delegate

- (void)webViewDidFinishLoad: (UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    
    if ([self.webView.request.URL.absoluteString isEqualToString: self.divvyAccountURLString])
    {
        [self updateUsernameAndPasswordFieldsInWebview];
    }
}

#pragma mark - Setup Login Controller Delegate

//Called when the user updates their login credentials
- (void)setupLoginViewControllerUserDidUpdateCredentials: (WRCSetupLoginViewController *)controller
{
    if ([self.webView.request.URL.absoluteString isEqualToString: self.divvyAccountURLString])
    {
        [self updateUsernameAndPasswordFieldsInWebview];
    }
}

#pragma mark - Actions

- (IBAction)refreshAction: (id)sender
{
    [self.webView reload];
}

- (IBAction)backAction: (id)sender
{
    [self.webView goBack];
}

#pragma mark - Helpers

//Update username and password fields in the webview using javascript
- (void)updateUsernameAndPasswordFieldsInWebview
{
    NSString *username = [[WRCKeychainManager sharedInstance] retrieveStringFromKeychainOfType: WRCKeychainItemTypeUsername];
    NSString *password = [[WRCKeychainManager sharedInstance] retrieveStringFromKeychainOfType: WRCKeychainItemTypePassword];
    
    if (!username)
    {
        username = @"";
    }
    
    if (!password)
    {
        password = @"";
    }
    
    WRCConfiguration *configuration = [[WRCiCloudRequestHandler sharedManager] cachedConfiguration];
    
    NSString *usernameElementName = configuration.usernameFieldElementName ? configuration.usernameFieldElementName : kDefaultUsernameFieldElementName;
    NSString *usernameJavascript = [NSString stringWithFormat: @"document.getElementById('%@').value='%@'", usernameElementName, username];
    [self.webView stringByEvaluatingJavaScriptFromString: usernameJavascript];

    NSString *passwordElementName = configuration.passwordFieldElementName ? configuration.passwordFieldElementName : kDefaultPasswordFieldElementName;
    NSString *passwordJavascript = [NSString stringWithFormat: @"document.getElementById('%@').value='%@'", passwordElementName, password];
    [self.webView stringByEvaluatingJavaScriptFromString: passwordJavascript];
}

//Load the Divvy login page in the webview
- (void)reloadLoginPage
{
    NSURL *url = [NSURL URLWithString: self.divvyAccountURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: request];
}

@end

//
//  AppDelegate.m
//  Messenger
//
//  Created by Marco on 6/3/15.
//  Copyright (c) 2015 marcojetson. All rights reserved.
//

#import "AppDelegate.h"
#import "WebWrapper.h"

@import WebKit;

@interface AppDelegate () <NSWindowDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) WebWrapper *webWrapper;

- (WKUserScript *) script: (NSString *) file;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [_window setAppearance: [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight]];
    [_window setTitle:@"Messenger"];
    [_window setTitlebarAppearsTransparent: YES];
    
    // setup web wrapper
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    [controller addUserScript:[self script:@"jquery"]];
    [controller addUserScript:[self script:@"messenger"]];
    
    [config setUserContentController:controller];
    [config.preferences setValue:@YES forKey:@"developerExtrasEnabled"];
    
    _webWrapper = [[WebWrapper alloc] initWithFrame:CGRectMake(0, 0, 100, 100) configuration:config];

    [_window setContentView:_webWrapper];
    [_webWrapper setNavigationDelegate:self];
    [_webWrapper setUIDelegate:self];
    
    NSURL *url = [NSURL URLWithString:@"https://www.messenger.com/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webWrapper loadRequest:urlRequest];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSArray *messageBody = message.body;
    NSUserNotification *notification = [NSUserNotification new];
    notification.title = messageBody[0];
    notification.subtitle = messageBody[1];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Messenger"];
    [alert setInformativeText:message];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
    completionHandler();
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    
    if ([url.host length] == 0 || [url.host hasSuffix:@"messenger.com"] || [url.scheme isEqualToString:@"file"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
}

- (WKUserScript *) script: (NSString *) file {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"js"];
    NSString *code = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:code injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    return script;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

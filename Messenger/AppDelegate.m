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
@property (strong, nonatomic) NSString *notificationCount;

- (WKUserScript *) script: (NSString *) file;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [_window setAppearance: [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight]];
    [_window setTitlebarAppearsTransparent: YES];
    
    // setup web wrapper
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    [controller addUserScript:[self script:@"jquery"]];
    [controller addUserScript:[self script:@"stylesheet"]];
    [controller addUserScript:[self script:@"messenger"]];
    
    [config setUserContentController:controller];
    [config.preferences setValue:@YES forKey:@"developerExtrasEnabled"];
    
    _webWrapper = [[WebWrapper alloc] initWithFrame:CGRectMake(0, 0, 100, 100) configuration:config];

    [_window setContentView:_webWrapper];
    [_webWrapper setNavigationDelegate:self];
    [_webWrapper setUIDelegate:self];
    [_webWrapper addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    
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

    if ([url.host length] == 0 ||
        [url.host hasSuffix:@"messenger.com"] ||
        (
            [url.host isEqualToString:@"www.facebook.com"] &&
            [url.path hasPrefix:@"/login/"]
        ) ||
        [url.scheme isEqualToString:@"file"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSString *title = change[NSKeyValueChangeNewKey];
    
    [_window setTitle:title];
    
    if ([title isEqualToString:@"Messenger"]) {
        [self updateNotificationCount:@""];
        return;
    }
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"\\(([0-9]+)\\) Messenger" options:0 error:nil];
    NSTextCheckingResult* match = [regex firstMatchInString:title options:0 range:NSMakeRange(0, title.length)];
    if (match) {
        [self updateNotificationCount:[title substringWithRange:[match rangeAtIndex:1]]];
    }
}

- (void)updateNotificationCount:(NSString *)notificationCount {
    if (![_notificationCount isEqualToString:notificationCount]) {
        [[NSApp dockTile] setBadgeLabel:notificationCount];
    }
}

- (WKUserScript *) script: (NSString *) file {
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"scripts/%@", file] ofType:@"js"];
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

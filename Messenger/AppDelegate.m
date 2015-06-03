//
//  AppDelegate.m
//  Messenger
//
//  Created by Marco on 6/3/15.
//  Copyright (c) 2015 marcojetson. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSView* titlebarView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [_webView setFrameLoadDelegate:self];
    [_webView setUIDelegate:self];
    
    _window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    _window.titlebarAppearsTransparent = YES;
    [_window setMinSize: CGSizeMake(640, 400)];
    _window.releasedWhenClosed = NO;
    
    NSURL *url = [NSURL URLWithString:@"https://www.messenger.com/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView.mainFrame loadRequest:urlRequest];
    [_window setContentView:_webView];
    [_window setTitle:@"Messenger"];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    [self inject:@"jquery" into:sender];
    [self inject:@"messenger" into:sender];
}

- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Messenger"];
    [alert setInformativeText:message];
    [alert runModal];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    
    if ([url.host hasSuffix:@"messenger.com"] || [url.scheme isEqualToString:@"file"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
}


- (void) inject: (NSString *) file into:(WebView *) webView {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"js"];
    NSString *code = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:code];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

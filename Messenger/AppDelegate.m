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
    [_webView setPolicyDelegate:self];
    
    [_window setAppearance: [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight]];
    [_window setContentView:_webView];
    [_window setTitle:@"Messenger"];
    [_window setTitlebarAppearsTransparent: YES];
    
    NSURL *url = [NSURL URLWithString:@"https://www.messenger.com/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView.mainFrame loadRequest:urlRequest];
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

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id)listener {
    [listener use];
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener {
    [[NSWorkspace sharedWorkspace] openURL:request.URL];
}


- (void) inject: (NSString *) file into:(WebView *) webView {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"js"];
    NSString *code = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:code];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

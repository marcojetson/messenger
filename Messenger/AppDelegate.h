//
//  AppDelegate.h
//  Messenger
//
//  Created by Marco on 6/3/15.
//  Copyright (c) 2015 marcojetson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet WebView *webView;

- (void) inject: (NSString *) file into:(WebView *) webView;

@end

